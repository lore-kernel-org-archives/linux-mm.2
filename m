Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F71D74964
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2EF6B0088; Fri, 19 Dec 2025 03:35:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D1A6B0089; Fri, 19 Dec 2025 03:35:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89896B008A; Fri, 19 Dec 2025 03:35:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA6FC6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:35:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6447916022A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:35:18 +0000 (UTC)
X-FDA: 84235561116.08.4B3CD90
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 76B0B1A0016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:35:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PW1n1H/W";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766133316; a=rsa-sha256;
	cv=none;
	b=BPVNaJe9laeyIIdeOzACQWfQru/y0nf5EyY69tIqSO08hCiHDuqGLiJE+jicnOuL8lxjwF
	EcEXufMnF8Ub4FdWB7Pwm/gMDdF7EP6vREeXrfAfaF2xvQpW9Ua9fU5fqmBVZAh+8/qlKu
	GKnGQWYDzRdMoroySfbntiCr9DPk334=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PW1n1H/W";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766133316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmq1ynABAbkhs0OGsiz118T4MKIB/o9hyfGA0oaMdfE=;
	b=kzU7ukeuTm6mBqgzuE/ki0myZqKxPk0k1TVLf/lUk4YWS0IrLf5b7gzXb5OHCAdrIXMGmI
	22X87MQr5VPET5PxeOLfl3g8/VjeiGbLgqyQ9Gfy6P8WJ01AWJVFd4FoAAm4k33uAYm/eP
	lvc3yZHLtHgQ1o+tUw59/cQpnO+43Is=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso2228726b3a.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766133315; x=1766738115; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zmq1ynABAbkhs0OGsiz118T4MKIB/o9hyfGA0oaMdfE=;
        b=PW1n1H/WAAXIuQA03NPx6/LMbd2CawO9MqLKgtcrlJCEQL2XK4BMtDo72oWDKGwjOf
         VHRNCSZDSN8c9DFPUDisOWNOCyJeI1o21jEuFjzMvrP/dD2x2Yiw/Rtvy5OTmMh9RUVI
         n9vmSpniF9F7tL7ljxT3vx56rdJ4CBk8RfikF0r2gTSTyrLxQHiSk5DNXze71x3SN1R9
         26XcLCUVqAPshYZx3OBQA//yMhEgga5foqVBm+JIqTcixHQz+1hlVtmoZxklu8tT2kc1
         sxDNcNl/Gkbqt8UurOMo5ZuqDrUUyJzUDJF7vuuppfMpZ1NyRuUOovdYWDJZb8r+pp2/
         JI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766133315; x=1766738115;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmq1ynABAbkhs0OGsiz118T4MKIB/o9hyfGA0oaMdfE=;
        b=ZCoRaikrjWTJJXchjAGVvMP4RAtNn0M5wCQITTFLG26mU2lsmuyMJlO4enO9IaPV3s
         HkLapHEMFc/RBQNupzFHLJLOx/u+aYLdaoZlOrgD/X4vsbj9JsZUcTbhB9NiqnlOfa3g
         abBGWxTJQPkYiwvMnJo0vnMmpAbcW6d+pTWOFCdV4G+nrmiYKg+D+hLbGnh6pOlCKia3
         KGZyoTY7PVcSALV6U0rIvr3lHoiLzTvUyAPXQoJA+bWUna3YU5WzCpws4mwHAgDCjLhM
         gOhEe+P8KgqgYxjP7D4HgtDyNZS3459fdThhnA2IGbC9MmPJ1WrgHZ/WfKeJH5nVsrsX
         K1GQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdeo8RCcu15gUmWf+7zGkJYluEbt/zpOnuVYX0ZhKtfY8EfiFasYUCDXW+G2RSVyi7SWmyLrSrTQ==@kvack.org
X-Gm-Message-State: AOJu0YyHl1tyMgrK0ttXHJrJi1Ih4faXXJIWf62prRZU3caSEGhSyqwp
	/aZ/vbuxhXMyM71nSvBMfULfsv4Rqlhzd43HUtnxEUugzWpH39MQ4kvr
X-Gm-Gg: AY/fxX5t29VpvX9WeOky7cFaKIuFJjLUpsx/S5aEUonvKaCO6bGgbKf6avcLynJsJe2
	HmvsVAdzPetGhVJZTE2gzE9HYqSYWQ5iX4NuqFEe+itLikFE5zt5HrRx3hzVWfgYasmP1TQCAqV
	1K9ZS4rzpvl6LbRPFAS5kImv3RXLUj3ov4J5cmqJj0bpRN680uR3niq13pUzUhQ78+fYzuRkO6C
	yfuk3D7XBw2mv2LBxF399zC+AX2ualBcDWTjU8HF0dFLtpcLhvFsUUw8UTefC7RhBPwtIVSuSPm
	vbnaSqtw271+RZzw3xw5EtSb/Zg6zY3oZqNlM8fs8hXpO33VD4OoZ8nFzlySDT+gIDUTpFnUsPs
	pt0ssrpoYfJCuNqjpwclMWspBidcuFPkz312T75MrIw0/qU0KvfryNZLMolYo/oeP8QnU1ZSnfS
	nFJ7Umrh4qP+6BWIIOnb4Ujbbh
X-Google-Smtp-Source: AGHT+IEw5hDSeB3qpsLX+xm4ynqmmYxk8XGOldnANdFKvs9A2sBFAz6s9g/mHWXzWpte6A6cNYf/bw==
X-Received: by 2002:a05:6a20:1586:b0:36a:dbc6:2572 with SMTP id adf61e73a8af0-376a7af532dmr2243918637.18.1766133315151;
        Fri, 19 Dec 2025 00:35:15 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e76de1e41sm1870109a91.2.2025.12.19.00.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 00:35:14 -0800 (PST)
Date: Fri, 19 Dec 2025 16:35:09 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <djh6xaia56grmgxdok23kp6ly3oe3ugsinxdp6jie3k2tzwaml@57gbrcr75jng>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 76B0B1A0016
X-Stat-Signature: t8gfh8ykz9yr111hchecwnq1gbodp7dd
X-Rspam-User: 
X-HE-Tag: 1766133316-698266
X-HE-Meta: U2FsdGVkX1/1sl20YCqaBG9DpDZIoNhDENrjA8ImT5eWxYDXSqYJ3N3h/IlhfIe2gCzPchgFC7MA5xnJYJLzZXI5wRrEu2sQkBxnBrbFUL6IkYvh5Xz9RJj2H1yspoMboITkHM1nA3AKYe3r2oV+ccIWqEoC6B+Qfbv051QzfMk8+T2wkdNmwUR0YC3JPjChH8zBMkkxyM+WuUb2WPvFxRm1vyjyfKyBFdgmO5OX+mfDgpcBTLW3RbZo74Z4DyzeBwieMgiQgkDtNXdWGLpEtnwnW2svqRyrr8Yfifv7mQiZ1e2CgM9n1iHC3RybfJmn64PWb90jR7qIUlCSx//242jtCooTxkcgzLi9BuBxXrPcPZotPI5j6uxk+UfDeN491btzjBGuFjBIriTNcJwxyCWVEUkRYlX5sbdOptB6GLvH2zMHgxQwX9VQxtIMS+APYrCVV2CvaxUUpBlOvg0SsVIISrhoL/3ueuAFEm/r+gdJvbSGe4LtPZGHFr9pWvlCtjJZpuIhzOzbfuNDJNZBLVSyGlXiIwek0MAoedJLG+8lTZQJr4tFaRH1RYCzBZEH70056/GKaRYxcrwCEpLZLoKQdSO9AAuB3FCjuxCQYnyCyBizRr4MymwFIVXk67mJz1hoaBS2WPcGX07MVs88oeY7VfAsOG9H13bV8WIkVjVve4/Mu3lpO2N43UlnkoVmqbCMVaKJRfB09LpBOddkS6QRhHOKOy3yW1rA7NhWb/6nmwGdSmOePrETbuEFoHlCyWURvlqm/uecB3xI9U4RMxa0vPgAemqg3bJRxZVgeavHlk5gvMWMVUEWowT2m/js4YZVNVpukdGS2eyYM+7+ZBYAlWR2Upu0XEEJ1OmeGU4lJ+ogo21Nav4983Zqidi1vMhVgcuneNpa5nABWBZmAFbWU3mhzeKdzgcQ/I/k16quQpu74PYbBMKvjRfc5pWZnIzSrDrP5zsvydK1WZv
 ezG+18QB
 OJgBUV4EF/3LiZlpIda2sjLoGrG9hHm9vuT3AHeNSe46Q2DZLY3s/xGFHN7GfsmSLMWJmkalXO1xzOLg6jxzsIm79dt0b138rauzbwSUZGQeIfpQCgfkyGu4vIShhy2gR6R1Vs8l4cumy0xL5d0p9Bmb/ai+NG07X1vuo0oPcfWIqekyiV6+ULQk8Iu7/LnDoaBB9/DN6F35Ki8bPvCgs8kX35VNHnLIBSA3gRmuX1XJoVuvy4kq2a80ijLAQxdI1GrzxYwOS6qHnSEqDpvz2JUIWDUl0iDl4SJ3V4zQDtgmxdA9+JHz3XjpHmr2+b/KQFTkHSkeHeSHH74LGtt0yDnfA5wUkKqobHSHMsIEOSC51e4fXRKWUd0oWr2McknIuSIFNonGJx8aWrVUXYCdSjAAMayBdyAXRR0Wuyy9zbc+ePn8J+KuKifZfmbNByLCfI7kThKG/nesqRL92Rpcw6unJvJe5cDusgnyiwTBpTDXoaGsnS9S8aiNfycN5ii1ageRZsua8ZzUg8jmH2WROom2vzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:29:18AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/15/25 10:04, Vernon Yang wrote:
> > The following data is traced by bpftrace on a desktop system. After
> > the system has been left idle for 10 minutes upon booting, a lot of
> > SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> > khugepaged.
> >
> > @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> > @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> > @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> > total progress size: 701 MB
> > Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> >
> > The khugepaged_scan list save all task that support collapse into hugepage,
> > as long as the take is not destroyed, khugepaged will not remove it from
> > the khugepaged_scan list. This exist a phenomenon where task has already
> > collapsed all memory regions into hugepage, but khugepaged continues to
> > scan it, which wastes CPU time and invalid, and due to
> > khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> > scanning a large number of invalid task, so scanning really valid task
> > is later.
> >
> > After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> > SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> > list. If the page fault or MADV_HUGEPAGE again, it is added back to
> > khugepaged.
>
> I don't like that, as it assumes that memory within such a process would be
> rather static, which is easily not the case (e.g., allocators just doing
> MADV_DONTNEED to free memory).
>
> If most stuff is collapsed to PMDs already, can't we just skip over these
> regions a bit faster?

I have a flash of inspiration and came up with a good idea.

If these regions have already been collapsed into hugepage, rechecking
them would be very fast. Due to the khugepaged_pages_to_scan can also
represent the number of VMAs to skip, we can extend its semantics as
follows:

	/*
	 * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
	 * every 10 second.
	 */
	static unsigned int khugepaged_pages_to_scan __read_mostly;

	switch (*result) {
	case SCAN_NO_PTE_TABLE:
	case SCAN_PMD_MAPPED:
	case SCAN_PTE_MAPPED_HUGEPAGE:
		progress++; // here
		break;
	case SCAN_SUCCEED:
		++khugepaged_pages_collapsed;
		fallthrough;
	default:
		progress += HPAGE_PMD_NR;
	}

This way can achieve our goal. David, do you like it?

> --
> Cheers
>
> David

--
Thanks,
Vernon

