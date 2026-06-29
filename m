Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1357AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0546B011D; Mon, 29 Jun 2026 12:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6CF6B011E; Mon, 29 Jun 2026 12:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6666B011F; Mon, 29 Jun 2026 12:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A84A6B011D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:02:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 257FE1C12D1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:02:46 +0000 (UTC)
X-FDA: 84933418332.07.8A43E8A
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FB268001D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:02:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="l terjNH";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=f4Prm+vx;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782748964;
	b=YcHIccabx9wIKrjiff3GQgI96CikJyCLOmDIx9Ldt2wRN2VYumQV4EyMayLK5GENRP1RLk
	TLRGO3V5TFKvRGNevfFFA3al5gaTE9Oa0MyPsDmBZxuy1KytzOwrOLNsbamfu5aR8THe/Z
	uV2RIWPSHj0PriW/ly7rYnI/fK/uCbo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782748964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5M7UrWTmU2fnWKZojvoJwc5RGoqcaVVltooaRFZSbD8=;
	b=0nNKZEsby0TlsXS7EEkmbaQncGreWmZrDDUDMUEKgzYkR4vpYB6Dzm4YmS8mjEgDplIl5Q
	4d8hY+tw/5zF7lbmOwSdpCpOazE36LwCJ3vvmlW+FdgAuYjqEJNE5KLsCepFvPgiqsLB0x
	teCcYIoiTvWLeT+6c6oReFBFpoIHCms=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="l terjNH";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=f4Prm+vx;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.phl.internal (Postfix) with ESMTP id 6FBBF138037E;
	Mon, 29 Jun 2026 12:02:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 29 Jun 2026 12:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1782748963; x=
	1782756163; bh=5M7UrWTmU2fnWKZojvoJwc5RGoqcaVVltooaRFZSbD8=; b=l
	terjNH4SS6dbm7ZLR3cT8v0CQWM6BYPp7JwJx5JHs6wYmDrskeL9eFpXHU7x5FP9
	i7ovNMukFffN45qrCtjS5pVHdrUWJQuIsxug6mnYgJ8XN1PRNJw/yVQufVv8vV7W
	X25/eoFjgyFoGvv/DplYNLrPAV5fdPTMfp9adZ+5bzKIyTk6uVbaMcXvodkORq9m
	rFz7oNrgxuYOPK4a5gD+/YhYEfqASmYZVM2laU8bM5n3xGFrX7mIEaj+7sRV+yIr
	P9fS3RowK9esq9C4O+4JY6c03GlWm9STey+km/jkknM04NQGoy79z8VBAilMDjli
	3ISCnhaa/y/MXCmTkojQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1782748963; x=1782756163; bh=5M7UrWTmU2fnWKZojvoJwc5RGoqcaVVltoo
	aRFZSbD8=; b=f4Prm+vxw0uPrjIauItnXpWZWosjcyK5uKoXRf3h8MOxc0RK/TQ
	NxeUehuXq0dAp9HeDS6CARmGeyw6ESQNFvu11X8Zdy7XaU2nr0Jrwzc/+0s9c3RN
	wnIGjqIIwd5En4IDHPFOA8jE6kMWpN5/L0zoZZEhliNp7YEioZGAM2trxB4bnNZX
	UK6BlFw63n7yRsTEeZVRMNsD9gl9y4+lLXuC19yw09hvfS5RdqrC3SJT2ARSuID1
	froiUydCH9CNMUaEOr+hXtUy87hkEW1knryg4vVMfH/cZfHcAeZs7azys99Izkgs
	TnnqGCY/NaiYRZVVYMArKRvnHBoCtfUsQ8Q==
X-ME-Sender: <xms:I5dCahmrywK2XmKKrXi34cxfd-7jZ5vYqMOZDLC0dONzWjSgGWB0IA>
    <xme:I5dCalPY2ZqO546gF66vI4g5nJZD3yjlQCs-aNCcJMfRorFAHAyrva09ADxB68QqJ
    WCZoneYSMMDZwQWA9yDBJYZiAI2vmZ_lYZdxTAl_oSAtJhs39SZai0>
X-ME-Received: <xmr:I5dCah7z1q6CBoH2evDYJLFJ126BboKdoqYET9eu2yv8roOyvjPZ_-Mbc0P7Ow>
X-ME-Proxy-Cause: dmFkZTFDlTNK+FNohJg4noCYbW5VpwAEJ/3lhl31ZFTIvh6wOi6MwAQn2pdhCP1fDqPjSp
    DThp5HlJoStLNnqS7NKN1XFUvrVLCFaaDrqKHocOP7Q0yFfyk9vYJwPjD4MtZnSSU+huSE
    0bkQ4ZIkzUfj30WTfAyH257AFUsdMzCDhw0NoGAJUakjPmDj4VwuK9ibUEs2fq3McnGv78
    Nh2JYbn4djoiaQDuiejPXLoPHxDQPhQeipCwDaQnTK65xBeDKRnJz9LO1G0ubz+7ygczav
    kf9ymsjv6R0e7EpJWlgyVS12qRilACHu4La+l0bLD0/MxAsnjj+YIo73t+IxeqDILoe3aI
    EGi5XfI/jWveDG9g4WL+5X/HQPKMnj5RRBtKX05jMG7+yCi7C450Ue3g9/WkhfbZVE1DD+
    BXn09yMHPghVteggvBz2uHm+ayYXAy4SInb/5Q8CrS2AiPIChqLo/yfuVTLXhZg9UKdLu2
    BK7bij7g/xg9IyuQmHAsF2svJoFNX+gKUlLyXZVTwg0oU9NpZFhqZIhetDbTjdDqIw6FxV
    NDL+Jg024Pzi/8xay+OtYIKFSFiKHP9C82afWChq9YWh8ws9G8Mxn40tP1FMgFeJw3igq/
    7iPc6nh1nX/NB32lxDYrSzQ1mF4YU4WilWmhoSLeg78JloBwBmC45O+6h4XA
X-ME-Proxy: <xmx:I5dCamKBecsIvHRTs86s7_UMNMQyF4VfTO6wv8sfOFicnMvOAY836Q>
    <xmx:I5dCatKhWeWhuybIyaV1aL_pZOF0pD_VdovgDw0lObYC_lxqQBUnww>
    <xmx:I5dCam1ygCErQMLo99_D0L_5-34w1LIlYTQEGpJyn4JSFaCCkqubHQ>
    <xmx:I5dCatyNiRsJqyMNLB5UB_39zZ8g0COnUVokKpTu8WxgXOfpBZtTqA>
    <xmx:I5dCam1Ngh67dJljnvhol0Oi168Rb156u1MIFMAysA-Umwqcqk0HfOvm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 12:02:42 -0400 (EDT)
Date: Mon, 29 Jun 2026 17:02:41 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org, 
	rppt@kernel.org, peterx@redhat.com, david@kernel.org
Cc: kvm@vger.kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v7 07/15] mm: preserve RWP marker across PTE rewrites
Message-ID: <akKWzol3mExZhVYq@thinkstation>
References: <20260629120749.566063-1-kirill@shutemov.name>
 <20260629120749.566063-8-kirill@shutemov.name>
 <20260629123320.1EF891F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629123320.1EF891F000E9@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FB268001D
X-Rspam-User: 
X-Stat-Signature: 1o446mxozzd8isw4c716k1iezhos6rw3
X-HE-Tag: 1782748963-861758
X-HE-Meta: U2FsdGVkX1+zYS83+eFSHPt+XdltZ3o0rhjNMKiH1RtfyhXauVnjELcNdRwdUSdawYIoKu40w6jqInhcfTOCykMCasqS4Wqy+rIFtqcXMXywcOZwjpA/lycbt/5wqd8wWQfJbC7JS2DwVtgOXw/TIJMJHob0HLzkrsJzyHkLvoHmKR2WM2wX/fReZ5qAoW1zQ5kiC9VdMS4d8XdBXmOH4ri3kKaOvMblv85lUai6batSxRUrVes4msajwsgokOTHd/Jf2M6gSUfKnVTzjqRzZ/JF1BNdRKM+kvPFwLwfLEo3f9E6f5hpUTufMSllc67pFaAsDjpSMblc1+sp6TAjKu/4Dy5aa/AeS+63spXZlMWL4NjUpXdE+SJFcnugbV4KOWGEN1dj1aWAQM4dvQthQZYeZ897aK23/6KDQFqHTXGMBNZadwSOsiO/2pnvSjb61XuroL8LbpHux/MQhkyJTqRnillB24LjCylzkvGLH1PmvIcUVBtQSVuPZ8oFhOLKfWYRxUBx3tPs83Lyi5bHUvWkPEAJlx4KACtuE+N7I4+H0QKwbMNGxF2l2LB5okA1gnnuOkW8CEWcdkQXwtD58hbJq1PdKzjH6J36bZVLXFtBve3Q2OSfB0VgTTo34iJAseDbHu6MjMtxVhpD09hl0UnPkybpuaZf/Q7wDyH3pn+lgKU2gqwOQAM7Rw86P1zNszfvsjPoez67Ss2ZDeGPWbKm6DvhKgJRg0Gnq4xV6pKhAYwnB9nXjI1Fhkg4UEP7uekfSrQJ/pzmqhQj2hVwvCIoOM3IBtk0YyiUev4yUAnUp+H/GrqyccU6DXiYWblbuZk0czGBKdiPKoDK99hveZE6nDzOka279dH/rSQTZqMhXPpwY1hOFq0sDRxfRpnd17tsVFQX80ssoc59j0FNY93KQi2WJyE1by2RgzjygKrT/g65/j2ncYs7iZJVLtYeZNKLKYDEHNYuBEmvbVF
 Spa+iAIF
 Y7Z8tfuT2BsNLn6FMOnizFxcdO0S1GD+Esw5XCC9C08Dt1yTScSwYOdOVOMbENQpNkUfqXpySHzRObPPGhFNBp5q6hOpDuWLozGti6PJiDcfKvQYl2Vlnjn0XSYiUYnZUorQ1EXdWB3pMzCqLuXLmQQF2EazwUaQ4xnsxif/t03sZ77WEPMe+cSo8Bd28HfhxSpvqAL08K+lTkJFoMhbwDFh0yisqSxDRysQ2VucFbPv7fp71Yalciqfc/HHoj+bJjbAsOwHIOt0oydbYQl1HV/Ff5yQwEaL5K02p+yT48YHH0JKy3s+ARUwDFq5oflZf1meScIaRrPG+1BRM331DC+LFdZeKfWAEUeGXbJEN73LNNZErnXFWc5KratwpLeRpmtpP/TYEE56yWuUOuIaog40j6buy/e/Ptq9Z603w2IO0Av2+aHBSW4d89FxHhiTCEztNWUGxjYxD1+tsJrYOly9AuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 12:33:19PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] do_swap_page bypasses RWP tracking on non-exclusive private pages by resolving COW faults internally, dropping the RWP marker.

Okay, this one is real. I will add test-case for it and fix in v8.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

