Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC25F53D91
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5988B6B0371; Mon, 16 Mar 2026 15:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5485D6B0372; Mon, 16 Mar 2026 15:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491726B0373; Mon, 16 Mar 2026 15:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37A8F6B0371
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:42:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE77F140451
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:42:00 +0000 (UTC)
X-FDA: 84552946800.30.2E31B0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57FFE40011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:41:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MT72woAm;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773690119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYk0WqC1X3yn3i5ZRrAq0OqMzblsSIpXUjF8i7/7dY8=;
	b=mV7TeONP01GPkJNbtwQ5xJPY0ahzITDjeYqUiVkken3/G9zDXciHAnEsVP69wid+p5hkkQ
	MCOHUzsqZCL9PwKIkU76hHikpN3iEm4VZJWXfsxO+ltcfFOVFI0LLYyQQXtbjQ5avCxY+8
	fv5o0kfVxC7CCyT0D1Udb+9RJAJvcFs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MT72woAm;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773690119; a=rsa-sha256;
	cv=none;
	b=VsNx2k2VOsFsIRDKrmuJXNKNE2zIV6K3xzLQJFM9wfIg+Uq+beVCs9ptkfD1/2IfVnTaIV
	vDWCsNMJ529coVho48N4AlKaN/zHfgqW6Ai12/qNVjW/LJ4Wg7B7rqLWVzCaPRoW4dtMmk
	mLL++acUVs2vWZlC7JBNk8TEI0HJwgA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B634B60018;
	Mon, 16 Mar 2026 19:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCEFC19421;
	Mon, 16 Mar 2026 19:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773690118;
	bh=1NtvT4EJ/Ckct9Ou9lVpgKq0RbkjW7z//cTUuUc4hbc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MT72woAmtBqyBZx2hX002+tcXvGabIiodBFvGg3VbCZ1upvHeUOcSHn3ywj7wCuN2
	 mLOVLIh0DH2D6OHGOEuTeYKDD+aqt/6FhwkmRXSavfaBJHGEEGfhZ4b3DNhV0QXmad
	 H1bEvzD5yPamWKb5a3MvjZCGctuKCWwsejwiU0a8=
Date: Mon, 16 Mar 2026 12:41:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
Message-Id: <20260316124157.bfc7e00976c22bc028913945@linux-foundation.org>
In-Reply-To: <i4uowkt4h2ev47obm5h2vtd4zbk6fyw5g364up7kkjn2vmcikq@auepvqethj5r>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
	<20260221093918.1456187-5-vernon2gm@gmail.com>
	<CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
	<xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
	<CAGsJ_4ycodbcWHxFRacpzbxx4evQRJbuqJy3gfweAdHOtJg1Og@mail.gmail.com>
	<i4uowkt4h2ev47obm5h2vtd4zbk6fyw5g364up7kkjn2vmcikq@auepvqethj5r>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57FFE40011
X-Stat-Signature: by6myggtyfkmu56yfuhkeqmwm47ycnm7
X-Rspam-User: 
X-HE-Tag: 1773690119-53452
X-HE-Meta: U2FsdGVkX1/cDE/MICkznaIqq9/8UifGUHz6Bqnk56bmPCoGxA4k/H/A5eO/SmY0/TIk0ZeC3qPzEReq4qFWFQloSAQYfspMObq++K6JcMpssUbjMkMwZxSM9Qx+fwSatHoGa6K34zwJZjP7fxhZi/3Kg2FGUNgb9V4BXI8O/wI2+YhM1y+odYZ+ErSCh/lUV5mVvBgBoHlyi2LfBcH31/nUNu6fNUDEslIcXtRIwI/TYtGBnsjt0WtfcmUX9/DOB3FXqSBVefi3CLdZUy/AXSMc0VKZT1xAf9iVYHOT3NAfrsvDRbZ09vJRDXI+F0qmI/4ghHyZ8tx3o5ZRhPNJUnO9zdHJxZXYoSIOaCvz7Mte8Ukmb82fXr0EwhEQCA4yhjyJ3NRJETE+51tB0P1Qtfcvvxz43/1sbxd91D3dICkzD/7om65scEJq+3JakmJM6HSfdeoATmY2M2A/Gf2nCr9xE3OebOQ8mHK+wBXNfRH3bSj/1a51kg54quY9VMC2sKioKB8VYhyT7tRTDkcvT/GdwIky8zCnl9mZ1d+pGFQNoCmkC9z4p9FrVbgC4VAEIaFvTN6VDzTc8JOnh2r5yifRt2ZWQHiveKRQGx+8G3Eyl+aiQHFPu971chp4/ukL/smdMAm+AjfQESV0NOr6ZCQKMF93l7jv/rZ23M7jzrArCwZEHyq2maAPW1UmPBzRbmpfrq1xatp5Sngp6pAS4xluQ5TaDt/xJ2hHHZ2YdEwDUtnRhfrJF3zeFOYH16dkwY40svddosUP5AC8w98stR19K7dMuOI3puxM4ZI2GnFaoYd12M0eUoIJ8kkkZ6h7EWAZVMnOXDtcqyBVA1yffHgNDyL58IHoCW3ZXVzeN29DOL/ZKAMZstcGKbGLxVhx2n2RyEjR279VllUjCcQLVFUD+hUxDWyjpOJECWakFdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 15:55:45 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:

> Hi Andrew, could you please squash the following fix into this patch?

yup.

> also remove "if" in the changelog above.

So you want it like this?

: All folios in VM_DROPPABLE are lazyfree, Collapsing maintains that
: property, so we can just collapse and memory pressure in the future will
: free it up.  In contrast, collapsing in !VM_DROPPABLE does not maintain
: that property, the collapsed folio will not be lazyfree and memory
: pressure in the future will not be able to free it up.


