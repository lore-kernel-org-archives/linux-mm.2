Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4E9CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 13:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7466B0005; Fri,  1 May 2026 09:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA84C6B008A; Fri,  1 May 2026 09:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDED6B008C; Fri,  1 May 2026 09:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA03B6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:23:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8ED7C1C02B7
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:18:20 +0000 (UTC)
X-FDA: 84718904760.19.CC501F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A5EBB12001C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:18:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QMPiIR6I;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777641498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZN5oUnuZIjp13ZYYG8K5hBlUnUOUmy47oFpVDv1c0w=;
	b=iy1VYu88ABGZrTfq9J80TWzMGIBKHDRoWgXqZBDGQyR35RHP+dFyzYv+kw4Jwg4jC5UcBL
	/1408SQQKBoFCn+GihKnEwXkVHPbYEBMl8aw3b8lUdX8FqoNxyLDN7uQPOluCP8GO+ffqq
	+yGTyXddeFlWLAd25++ImbYE1so13uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777641498; a=rsa-sha256;
	cv=none;
	b=ny1RecftTVx0t6WEaehvr7Bani3Gfxzhd6N7HV3WtrcviVtfh/D1sOxxVuIOhpxI85uPN+
	FZmycJDQSP2hsCOgYTHorfRC/WgJrX7piRZLF3mM32AYGU47qjdCkxjkHAZQ4pZckBrM1b
	m/ZOkpb8Ku9KmuGUzJxNHcwNgmRb/nA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QMPiIR6I;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F4DE44531;
	Fri,  1 May 2026 13:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3F6C2BCB9;
	Fri,  1 May 2026 13:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777641497;
	bh=D6S/B01MEUfCR6VXKLKqzNn9DH6s9mBnNCGUd1tdrAs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QMPiIR6IFYeIFuRnabCqi7hl1SNQJee2T2jwmjPUjUU4qK/D64EGc3sypoEv7NihU
	 oa+Nq/+z9Jg4/Oi31Joz1tkvVneMyD4HSXvwLq2Nxfv5HwBeTsmufACSQW4a2C8a0y
	 KoXMS3eChOrGUOVGT5jj1tCi3QQ5vY47LU5+H1ag=
Date: Fri, 1 May 2026 06:18:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel
 Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] mm/swap, PM: hibernate: atomically replace hibernation
 pin
Message-Id: <20260501061816.5d59d1eefb0a41a3480a3a11@linux-foundation.org>
In-Reply-To: <20260430195651.287659-1-devnexen@gmail.com>
References: <20260430195651.287659-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A5EBB12001C
X-Rspamd-Server: rspam04
X-Stat-Signature: 5umef163w43qumuyu5uyex81cqxxk3dq
X-HE-Tag: 1777641498-384895
X-HE-Meta: U2FsdGVkX19J7mnK6F8gGxTFKmoGMoWKwGF4xw8QqAfXUTuGPQYMn8tD0Jqjpy6wOrIp3A9VTxao1C0xr+ZTSTkfB1jmgzyeQOOoXrz7ewwyYTkcLP5d2ZHSvDZOOcATL5oQflRXv4/ciVoqf/4sZy1xqGa4FXyNT/XpmenNfC7NXV0HKPXf3+XQA6ehXz3Hx0XgsfVs62XhjrLGO2lWXF443ZuIX+KhU6rn+EBMxF7L1AkkunNt1dGHyrrjb4bAaB1hER0EoFY8AzEnwoZuMGdaXQvoNOt/+ff9gU3NpST8HwOixMjNJrkJBp+MhdVmNNwzj+5hZTSgg5Y+DYy8Swnq1ZzWSe0IB1t8bt8tzZtgsWAvRGbno61n0nMT+oDSKYAmszdJoWPoKZEVgRld2OVseMsQHn/egDMwpCTIDVs61K325DP6v5wZCBiRdGdm1gAqikoRZn/1DWOJoo/AB5dczfqyFSdr6gI7Y/0rAapafinxJBW5InoGCnLvXn83CXkgdFG1p8u4sLnO6Dx3CMRrKPQf2BYx7KDChtE1+3oOjOAXCf6CH/LFQdFVod9gOQZL2sCxqgGHmPUXgKs0rxZgPdDrjbk/AtlpvjZKhPu3YlI513QdsX1pDoDx/rcd5DfxpUJVxnYkBbofxYlUtAaXyELn6vZIHCGn+POlP3/EqAvvJEUpy6Cf9DNUPcWQxYwHnL4i7bayQsF1dFVp4t08phsdIYI2FlFQiZFBL012d8THnvZleQAhXm5FakHCOdBxJsKCNu693PMJCDc/e0GdLo5DssI9df4mp/k0/bnH+9rbKfMClZGMr2oPLcTVtObXGOJvSbFkLCQtzHkw61tIKlAIZQjRqHvXTR0T37HM0z7PYmuNgmX9fu9g3prKarS0E9NKK1kRq1k6o8l2l7kKm04hVVAp3Tah202t96/7aPYG/hihylOjI6seG5sc+ycw/oZaPklg1jUWl99
 3vDp7mWR
 Uf6gFnBWoYImHRWfpu2FvSLzoH9X8lgfE9bmM81QFYAjxniElLgcnMfmimuqmoQi7R9g56ohJ36nZxYVLaommWCNcXY9AJB/EnBl6J2c7MMmNLJrAv5YsmT0beP64APXqaGkQ2WfrvJ3E3U0jzq+E8KLgwIU7h9pAw8zpwLj0NhFQImAF+GkJiRt+z+qCvWaZzBe8DbyNM3FCJEQudJLqMgdiRFIO1DimnFkyzWK/ExBTb0tJv5HBfyXP/M7kw9O5BnmGSAMz2PW55t7soYTpj58kXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 20:56:51 +0100 David Carlier <devnexen@gmail.com> wrote:

> snapshot_set_swap_area() unpins the previously selected swap device
> and pins the new one in two separate swap_lock critical sections.
> In the gap between them, swapoff() observes SWP_HIBERNATION cleared,
> bypasses the guard, and tears down the device, reopening the race
> the SWP_HIBERNATION pin was meant to close. The window is reachable
> on any SNAPSHOT_SET_SWAP_AREA call after the snapshot device is
> opened for hibernation, and on any retry after the resume path's
> first selection.
> 
> Add repin_hibernation_swap_type(), which looks up the new device,
> clears the old SWP_HIBERNATION flag and sets the new one under a
> single swap_lock acquisition. The same-device case is short-
> circuited so userspace can re-select the same swap area without
> tripping WARN_ON_ONCE and -EBUSY. Switch snapshot_set_swap_area()
> to the new helper.
> 
> A failed lookup now preserves the previous pin instead of dropping
> it, so a bad SNAPSHOT_SET_SWAP_AREA leaves the prior selection
> intact. The open and release paths keep using
> pin_hibernation_swap_type() and unpin_hibernation_swap_type().
> 
> The race was identified during AI-assisted review of the
> SWP_HIBERNATION pinning series.

Thanks, I'll queue this for testing.  Can the swap maintainers please
do a detailed review at some point?

