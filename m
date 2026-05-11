Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C42CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBEA6B0148; Mon, 11 May 2026 12:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3AF6B0149; Mon, 11 May 2026 12:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601C16B014A; Mon, 11 May 2026 12:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F55B6B0148
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:37:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19FA51601ED
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:37:26 +0000 (UTC)
X-FDA: 84755694492.13.2A2F817
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 952FE120003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:37:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXwreISv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517444; a=rsa-sha256;
	cv=none;
	b=K8vB70XuCXG36pFSJesFBFztyd6lxG9o/55F3FTBJn0pQKQryE/ydugG3Bso2p4wuHpeuQ
	ZQ3u9vCSn0eZCR06Qchq+/OOyGF2Wiz1yyt4IJGDp/zrxLuU8iT997WnhiWtEMD4q325R0
	b8qiGMLiQkbYyOLkhelhwAqKiiSVQnY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXwreISv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxLGg8/beFqi55fuw6m5jzykjB/pARNr7wxzOWVsglo=;
	b=GoCG0fd0L+0UWz6HAvf+9jXyXaU7UWDcfrDXQahruQz/G/zHmCupLujGxT4hmK+Ipo6LEQ
	/ItrYTWLE8whQb3Of+WIJBy9PrInq3Xyn4tyJgAqVfClSJwVWy4MnbpcS9DtRePqX038d2
	sxDBOeGZiA4q/bCjVibPs2N69bgsxwo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23A486001A;
	Mon, 11 May 2026 16:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27EFC2BCB0;
	Mon, 11 May 2026 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517443;
	bh=PRBYljbQKWzUvkUwyYwlu8uiQpZenEvMUngtqTEHQlE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=SXwreISvRN5mfNFWBWr1nGiO5hu5rrN0ri50RX37nwn0k2uG9o50p+kw5zkvfXGji
	 h++6onZ61CzAHXkj4m6FL39l3DTNhO8rDlsTDqBmPvTOEQqOlonQXkskpHTd/xZ1Cl
	 XV1yFOsOlVTWVX+fBMMWqwRHpw/YGJKE4lVwcfChPi4DKc8d34rxBZJNP8QlVhls7y
	 LAGdUZc70kxDlUPctWdJX4KPBigq1SQY6eP/D1YHDN8qUhH1nqJkP1drlNRN+fDdx9
	 i7+5JFrTQi+jD7DyvC+B7CH1uJIV8+Mql2GLxouJ1z7HW+C8ojsPjU3eZu8XmzjIPN
	 2uqLraTQFx+YQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] kho: add data argument to radix walk callback
In-Reply-To: <agHDI-NdI_AhslBJ@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 14:53:07 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-6-pratyush@kernel.org>
	<agHDI-NdI_AhslBJ@kernel.org>
Date: Mon, 11 May 2026 18:37:20 +0200
Message-ID: <2vxzqznhc37j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: b97grbbxy6e1uis1tc9tgz4cxy7o8bwi
X-Rspam-User: 
X-Rspamd-Queue-Id: 952FE120003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778517444-632937
X-HE-Meta: U2FsdGVkX1/sspSpyvYYFzpSNe/11jW6e3sRje61LCrsJYyCTTJLA1b7FfKFhoVNpvj42Ww5nqIyPOF2ObW9rh3uB2PAhLcdwUhp5ZwyzDa9IVQROeUK6tgt9LrHr+hfbyC5QVvXVidtTJ7FN+PCrQKVEaPWOI7PRjz3tBuPPFBbuQLsQVs+UvsXDZLRtSF8cuNPvD8WBu9KhpN50+fBMVDKowGzQeBU+H7Fgbi/eQqfUkK/iJfz0uMMW3VS1uuuKvEoMuwaVa4rrIH9nYUr9wsTLZGGemuTKbSF9ei2xAWShWfpG5/K4TEb78m260JUeiNBEA6jUQnyLE7sHr+x3Uhb5TjHgnuT1tsnjNgr6mgYb5bbXjf4gtN7fvA1GSLhkDFJ9yHIKl4emn8JPY49annPFVXwtmOX/kzMKZz1i6juZvfXKn/mVd6g5tK5kKTO4+XcljnHihHsqLewQ94sxn6IEI4FomKjSezNWfEIMn9iOn9bnsN2fCG8KKlawIaF7lvTbwPiRItw0QyK7pXwTKtE2jjQVAjvice6Fiq8oyZ+H04P/DrJuzv2PG+Q9NVrPBQ+jnEzcYObVJW8KSuCVCjVfZ8gAufMlVMMjxY7M4olJJePjhAxfWnvHZybKFZFAFsEW7tz9Wd40nng8lOjPyXvCp35H9MhLjpNp8cITfCnoQBrWnQde9KCAhSPOn0R17WivUH6CQRWOXOBsUQRIME0WkH7EOg976Fy/hA8olHcV3sFPv1iH/Enx3sE8ppDrHvs5D1J7tBxEDS/PwOCbuobRRT5ZWUMa81aOpWG7YDw7qpQBjgKiCqhoVQ+26AL7vd/FXoHkSmNT7ilXkjWGvQU4ir6anXZ5s4b1LA3PrwGxlPgn3jVraNy/ZRle7YMpWN9kMSFyhATSPVH1mVNag2crZtt/oQiuOEEDMmuZLPxaowt0RuoBDR7f1ml4ADlXLpOv2vw4YZo6twoKO1
 2tWpiuoL
 A5yt4Yn1GRsz6wN97XoKpbTF7T2delh21/UsPZ5rAuEZ7aoj7PJO5jhyKaK8Sm4bcmQ6n2KNyJqx9qBA2qoXmJDb4FPC3IqYYmIhZtAAY0sz+BCrrj6qIhNfZloSRrviB8L30jxT0CgCRERKQa5op+GND2opDEKe2UXA8sKKBEFnFsZTn+W1Op90XdzPAWQMfwgoR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, Apr 29, 2026 at 03:39:07PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Add an opaque data pointer argument to kho_radix_walk_cb_t. This can be
>> used for callers to pass extra information to the callback.
>
> Nit:  ^by IMHO

ACK, makes sense.

-- 
Regards,
Pratyush Yadav

