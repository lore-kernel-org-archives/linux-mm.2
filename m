Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44154C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070C96B0088; Fri, 28 Aug 2026 01:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021D06B008A; Fri, 28 Aug 2026 01:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53246B008C; Fri, 28 Aug 2026 01:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0BCB6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:22:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C71A120265
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:22:57 +0000 (UTC)
X-FDA: 85149533994.27.6FDDC64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 719FD180002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:22:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=H2AL5RTj;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787894575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5khobLmqtjgjuOflj6ImLhvXgr7WDfp3IPwlBxU+EA=;
	b=A4dB0W9Hyl2nXZKwuv6fyDt1KkLjhM4oy8MwlNf1tN54d24vR+RQ6RcTGkh/ZFPDsVFoiI
	1pGEpQelvpq5GUQ0bjPpLRp+fJ63QQ7EzTihPe9Fh9/H+hHBMscL9kOF510Kik07jFS+ra
	bfXTLfmE+8iJTLvN6SzLZw5po96crsY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787894575;
	b=Hi53748tfajd8nAql/sjgSfhTPVCL+3ZqLVY00ORZznTS32DB/dM3zvAcyckqgfLZ3Drhu
	aLM+AeEbE2uIUl7pOCitRDE/QrQETcsMTiyItvVWVXSrOFgm72ogKZ6Rz6SLXXunIt52Oa
	vnmUM8uWMnNIBI5ppx1rZNp1T2L23MM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=H2AL5RTj;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB14B601F5;
	Fri, 28 Aug 2026 05:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4346A1F000E9;
	Fri, 28 Aug 2026 05:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787894573;
	bh=C5khobLmqtjgjuOflj6ImLhvXgr7WDfp3IPwlBxU+EA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=H2AL5RTjeaU1UGTpU2IxtXECuNad5hjA0WDx9Xhe/P6rqCiHdgmNce0375QgW3XmY
	 VfJaaiAUrZoXhx89CXUQYijFf3EIRwZxRDxgsrosd7Wwpkmsws08C0pZD8o1+p1RdF
	 s1kmLFOaNFl/kYW26LyfCuTjAK5WTgOw+FAXpPs4=
Date: Thu, 27 Aug 2026 22:22:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 mike.kravetz@oracle.com, mhocko@suse.com, linmiaohe@huawei.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, xialonglong@kylinos.cn
Subject: Re: [PATCH v2 1/2] mm/hugetlb: do not dissolve gigantic pages
 without runtime support
Message-Id: <20260827222252.13fc8852f4bc7d6a5bab6178@linux-foundation.org>
In-Reply-To: <20260823044118.1097121-2-xialonglong2025@163.com>
References: <20260823044118.1097121-1-xialonglong2025@163.com>
	<20260823044118.1097121-2-xialonglong2025@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 719FD180002
X-Stat-Signature: tn6gbmi5iseagkhkjw7dma5fmkbh8edo
X-HE-Tag: 1787894575-327381
X-HE-Meta: U2FsdGVkX1+0pu/pJ6C6NlkuCx0ERr5XnqJH8poVO7iRbhadfGCKmcFsGTEwPQMeHBZbLOet1RNQibfPuHHJgLx+J+nXhzxMawd+2D61o7ZiC/lPVP0qoWY5jp5sii3EUNke2KnhfcJOE2DvbWti/n0i5lEPUqejZQu07cvXDOb0M+58O/2hU+SYxe0MSd3rJh9pLqiIFDXPgyBqxLO+dkzg80Lffn5+FBJRzJ1VQvDJQA8TobnSiKmMI7HosWxu335wq7SkO68WjM57h9udIPr6nr+KGqj8KXwt96FHFShQTFRaF1IDpAfSh6f6JCjQ0ayn+2736EYq1bLVrf/N4oB0Ep9yJ3qWr8KoYPnCDa7oemPKez1h/KENOnjwMS+n3AYN7oLjnEZ2+bUPLV1suCzBflELB/tEFMmaPI5/hdI0TUYJUC7vdLPlshMq+DQuChGp0rxUYJysJDlPjstFTbgPI1ycynBBts5lUf6ODJr6pT4ePQ1aj7aDTGL7Lxzfho8xumGFLRg6Yls4DUhZ1T2co1zFnFCs7ncEKax+2md1jpA+a1bMv0+/sSEfGJgPgufEWwbm6GQmhdqzMjewJNlaHvzGBATgjrNVhdavChj6GkdsJm8AI01JrEKxPVLvF5hvrKxXMw8xeZThMWt0nUuKIuNFiuUQHIBsqZndx1k3f+zGOapvgkLuxP+fpae4Pw3MGWLiOR7sACGW77nE2fzxuYwQ09+tRURCR5nhaX/8DQpG7AXP+G95ndGB8Sn9iwjfn0DQLpF2VMMztbc0LP2s4ZkuhXwARFh7sZyXBttvHPrITlcbgaH/33xJfk+2/MqhYy4oJXByCMHUmpnKohssa7fF9UItIjfyTSBxX8jTXgl62zscXVk299JngXC/+DrHBt2Z9TX4JZtfgoaIkDnNRpLJzfVsoxIohegLJOuHlftjtwnT75GGr0nOctrKFP3pYb9DJ3BF+zj6Fcf
 FmTioQ33
 KOGazBJMsgHU5UykDgxWk6Fbr3cm11SFpZSZTpayLgSRSuS75P4o2McXuiSlGBCvHr2jri86hPpg93I/4rjCXkX2idEyXKDhLWNAtVrEWDqAlKZw0m0JxgZgczWlc2bjAT/IKAi1eoVVp7XlStusMmMdqOvLZLeUyIxeVNBTm5EVuU9yFkKoKPIInAV+GVq7Atul5jkRgXFC8cdPGh4opBCWfMN1lgg+Aa5oGIFexnzHhtaV1rGzDrerqPjBHD13e6ENsH7nxhHiM7nzhfpUO8Z2pU2SfsllgVZ8PMVoQh1EuGHozmF2QS87ADYg9/WJhcD0BAQ9MnPd3nRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 23 Aug 2026 12:40:51 +0800 Longlong Xia <xialonglong2025@163.com> wrote:

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> dissolve_free_hugetlb_folio() doesn't check
> hstate_is_gigantic_no_runtime(h) though remove_hugetlb_folio()/
> update_and_free_hugetlb_folio() silently bail for such folios, so it
> frees a still-listed folio and, on vmemmap restore failure, the
> add_hugetlb_folio() rollback corrupts the free list.
> 
> Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to separate functionality")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

This doesn't carry an explicit cc:stable, as you mentioned in the cover
letter.  And that's OK - people often omit it.  Perhaps because the
-stable people backport every dang thing which has a Fixes:.  They've
been asked not to do that for MM.

Also, the changelogging doesn't provide reasons for backporting the
fix.  Please review Documentation/process/stable-kernel-rules.rst.  The
key thing is to include a description of the userspace-visible runtime
effects of the bug.

A reproducer, a Reported-by:, a Closes:, etc.  *something* to explain
to people why they should make this change to their kernel.

From the v1 review discussion it appears that this fix was inspired by
a Sashiko report?  Changelogging this detail would be helpful.


I asked Gemini to create a reproducer for this
(https://share.gemini.google/be2PvvOLw6kx) and it's very involved. 
Makes me suspect that nobody has hit this in real life?


Muchun's ack wasn't carried over from the v1 patch?


Thanks, I'll apply the patches (hoping for additional review) but at
this stage I'm not really sure *why* I"m applying them!


btw, there wasn't anything in the [0/N] cover letter which was usable
in a cover letter.  But that's OK - I'll split the series apart anyway
Because [1/1] is cc:stable so it will take a different path into
mainline, with different timing.


hm, anyway, that was lengthy.  Please send along a few additional words
telling people why we feel this should be backported?



