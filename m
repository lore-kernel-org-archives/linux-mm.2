Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC1ED3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 06:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02846B0089; Mon, 29 Dec 2025 01:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85BF6B008A; Mon, 29 Dec 2025 01:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67486B008C; Mon, 29 Dec 2025 01:02:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B473A6B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:02:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 424ED1409ED
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:02:55 +0000 (UTC)
X-FDA: 84271465110.24.21625D7
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DA0EC0004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:02:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKvB3y3U;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766988173; a=rsa-sha256;
	cv=none;
	b=ObIXnEnvVbdQKC8nEEdpmuw0lZRN4T6r+vuODUvS9ES8lSV8VK+XDXFApAMUUGgQzfen6S
	682BDVdx3Z8yXLkfn7Hdx+uWBPDIKzLML9XgmiMpzM4neP1GXXgyG+OWvkOIhGYuuds/O9
	1+rZPPqichRl5D3OShkUGi4wgvGmWF8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKvB3y3U;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766988173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9z7dAcGdGLyR7vtraJhuT9FmCukGfeyiWnjfPxJfB8=;
	b=39we3JD6TaRGM6v8v8yzV63mOlcy3MQcgmAUKQafb2F+GEt5I0I2qPjrvCOJm3uF1TCAod
	+XkV8c7Fcf+HFDcBw8ifEhz6HWUdH+c1ZrbNH/yfBDiVuRvvvRYZ0aIW9lhxtisgAOLsNe
	x/XmKUGJrhWd5qauDWhqrTtvbh66HZw=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7f0da2dfeaeso9380277b3a.1
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766988172; x=1767592972; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9z7dAcGdGLyR7vtraJhuT9FmCukGfeyiWnjfPxJfB8=;
        b=fKvB3y3UfLcTJkNhXcSTrdoKXMcGAmgnGrOGP6PHKvLBR13hW6OjfTbWdjVGefmWzA
         aIUou2nWxSxAP2Zcdz1+GsUYvEI3VdSVkvg/NlxGYAa6JCOKmsIopZJ8LmFEmUnchcUq
         ASMPlsaYu1YIsnffN/enhDqXGCe/zFNtNxo74OtivogWaTa2ASU/gYeornBBOS6Ty7wm
         p1zjhasJRk+h2tN+DKoQBqBh0ZTkl8pu8r7KCQ5Pg8PdczXpqdbAC8bL+XV5yL1bpqJ/
         lgbQPEOQ415Rdd5qNKe0fFwH3JLvEXqrQr9Bc/t+dELcHWhKzEuIMoHWOob287TINB8H
         aCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766988172; x=1767592972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9z7dAcGdGLyR7vtraJhuT9FmCukGfeyiWnjfPxJfB8=;
        b=PgPa641AyeNy2mMAQipv1HqcFX38+v2plOl32P0j1u5e+XY/rzueNdZqmcbdBy4vrN
         tU+cXmtpu4hB7vnKnj1d8k9beCaAT2zlUl1j7qIoZOQ68GynTvh5oEaLKPOC7kYRHFU6
         hvmiWK6KEK7oYA29cGoUWcoBFH0vK60AIAAq3TlJJ766ZAZVianMSYL0O1WHWrDEB1hO
         kY4XthIi7CiHDoMh3tn5IgyK9GpqPRYmGPzPOxYb+7qm5w+Vhn7Tv6EAqxCBHqRXtRzd
         GwY56vuXBI161qBRotIUu8FBSgoB8UWzLY9yPjC523sPr1JeLe3C/bdKhby6ANUwA0f8
         khog==
X-Forwarded-Encrypted: i=1; AJvYcCXfExr7UgvwhacZzCo1y1Z3iVFWueGrfQCUpYvC3wUw+NZueljMuGBMcjFATK/e5IF83bYJ7uVyWg==@kvack.org
X-Gm-Message-State: AOJu0YxlmZc5UGtsz8CUQKXolrEIS28Trc7w82zcA6jpeUDyx1KBY2ce
	Ji3SLEjnOS7DgJ26OBRgLWP9ILvRrUGIT8BSfn2wAoSYs0hMnhoHnnCH
X-Gm-Gg: AY/fxX77ydBvwMYYRt2uBuJ59/LfEAlz2JsXys8Ha47xm7tD2rrd3CiMFp8HdVkv98p
	SUoB9/0VcZ5//1N4UJOFOl+pxR/S46doW89uFh9DzvIkhrigEiHU1xFVC76VyzFyIbx/k4u7I9m
	HrdLAXrZlLRx3IJ+2HBpm/qNE3WxpxGFDhn6Gb1yGVXyFBhuu6sc6/vFjcE1ws1IbMnGtEOXRrk
	W1IJPXrhC7A67SWp0Gj0HeNog2tSR2g3bwOKdYxWqNMHvMPTKi10fCqPJz766DtrLuT05324Qt8
	bAhL9x5y84fh1s8taZc6xInchuKVirdWM0n0zwdhoMfw8788Kt/QNhuF7Agl88wpMN4iTdqqaQo
	tJLNF0e5PmJ8UXwH775/KUg0wO5pggrxwOvvpJIgkO7wEgBmNFIfwzWYr+AX8WOiU82Ecj8b5wR
	gE/g2/wzH9UTPrAQy+WNqnH4A3Wp6LKIGEDA==
X-Google-Smtp-Source: AGHT+IGoepxRgYIF7g4fnLW1GuKco392J3Bx/eHz2velvIsKZktG5Tct0qgk+XSzDqTr+wWagp/6Sw==
X-Received: by 2002:a05:6a00:2c86:b0:7e8:43f5:bd19 with SMTP id d2e1a72fcca58-7ff6735e594mr24067262b3a.46.1766988172166;
        Sun, 28 Dec 2025 22:02:52 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e48e1d6sm25491914b3a.53.2025.12.28.22.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 22:02:51 -0800 (PST)
Date: Mon, 29 Dec 2025 14:02:45 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <lxb772vmath36ytqqllvszsiltv6ntd4pwmkjv77dvf3zxxhrg@qc7372lkqo5o>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
 <djh6xaia56grmgxdok23kp6ly3oe3ugsinxdp6jie3k2tzwaml@57gbrcr75jng>
 <52174c05-e9ed-4049-ac05-d0d0b3228f2a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52174c05-e9ed-4049-ac05-d0d0b3228f2a@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DA0EC0004
X-Rspamd-Server: rspam04
X-Stat-Signature: oqt3p5g6x7zkupkqihz3zpxjd78zh6jm
X-HE-Tag: 1766988173-205867
X-HE-Meta: U2FsdGVkX1/koHODPBb/t0aYtLpVGSckJ7/JAnydltvUnyoaAAFwthnjMzucOu0Ihtix291Mu/cILgeWE+DDuYMPHpdHxkjBIaWsiA+Pm+elxuV5OJocsdjJ5Ee0ZW+SYCqIEFRiB+GRLF6NgQQhNzMWM42/XEdu6ZORgMIPB4AxQ0dRuRyPY7gxUV0wBwSNlpQDQbRgaFjpqYmn3/jGmMv9tsJj0ZYUhgsE0TJ7DXbhzd6DyV5UF8ncn7zeW5MWBN71Uq0WjwFOno/9CouegEnvMqZVsO60X/etl+fAIDDXJh0n4nxjeNgdLmHPiLyb8h9eqxj1+MGF8d1IcAZ4KJoo1zmaW0jBTXlQvkyGyfcC5o4T03I/QyM5T+Jfs393GVc06nN6cB6CBKyMK6+N2fMu52sQ5ZYlrr5h6jch5ffnIC0nq6UCiG4r6QUAuMGQHZ1+LOexFZqGYUeLvJnoZH2pg7XDw6XtABHjxXAsiEy6WrPh+oo/zcRNoZFmIGJhfVXMC6dlCOFnOTcIzHlQTxX4a5DyaaV4GenTbdjq0Q3WFrjvO03xYDesAu83Ds3eI1xBo46KJ9Ttiy7dUy4ZWDBsDYJ+VEhItZVgfE1rOTlGuh51XiUO5U/1yPrwvLV8alNnzKiWzuLt76oAIaO9Qm1ta5k6F7SR6nRgwbYGyxR11lUO6Cx8JZ61cokGaPeMuKyJUPjC1jQiK9rSwRWqocmNGUHhLPRXPePKuHNfxSRWb5EUzTVNbyqYPxmIPsvXI939B6p60BcjoAgCm3sQQFkDEKqA0IsHQr31pMR5KQXRbFg4rUpqriWdncXqLtHkWCVrv2R3ZATjghynbO86PHF4XeIkC1AJKobjVELeLoB5TyutSmTY08FH910PyvFJ/wpMgaFGC42MyIsuBNqOZatr++5ll4+EfW5Slmg2VGlY2UVT3qyfMrBReN0ILQJsvkwgEJ5zkokvscFljm/
 E2YVMCGT
 84thxg25OMVODDYRc1uGq57RdUSt52MlbfZCFEQx25yIGVmOEecWjqwL1Bxvhj0kVCsnpUycX4fMyHwd/w/LTLyVNakLlYdnatO9K6/v3nt8Cz9kG5OP/rpKzgiNMdAqXdc7YTFG2OclHOyeKEd7aaqQSl5k7YKACZbw6a1zlVvKE8huTC7cLd4aydMNnNTCaEEDrEkloMJKxadj5vI3+iN4M7BZ2qnZSuzK5WcjLvaEk0gIwxIjJF0CkSSB/YL7wcr1uxbVSBx17HhEutblTmm7z1QOeXQw8x/RHYGg1iVNGmWhu/68N4gp9X4q9VzTSskL2B15NgxmfgaQIe5P07YaWXstSFBXbzasSLVLrxYq6c81KQbaGzBWp64sHx2WCJMq/CejJaeGtVq8mGQmTzf7vx3Hcn8yZoOyPT8fY9egapdJNjQpkJMJ5nobGGbgqAeEqhoga0ieTKsU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 04:48:57PM +0530, Dev Jain wrote:
>
> On 19/12/25 2:05 pm, Vernon Yang wrote:
> > On Thu, Dec 18, 2025 at 10:29:18AM +0100, David Hildenbrand (Red Hat) wrote:
> >> On 12/15/25 10:04, Vernon Yang wrote:
> >>> The following data is traced by bpftrace on a desktop system. After
> >>> the system has been left idle for 10 minutes upon booting, a lot of
> >>> SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> >>> khugepaged.
> >>>
> >>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> >>> @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> >>> @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> >>> total progress size: 701 MB
> >>> Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> >>>
> >>> The khugepaged_scan list save all task that support collapse into hugepage,
> >>> as long as the take is not destroyed, khugepaged will not remove it from
> >>> the khugepaged_scan list. This exist a phenomenon where task has already
> >>> collapsed all memory regions into hugepage, but khugepaged continues to
> >>> scan it, which wastes CPU time and invalid, and due to
> >>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> >>> scanning a large number of invalid task, so scanning really valid task
> >>> is later.
> >>>
> >>> After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> >>> SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> >>> list. If the page fault or MADV_HUGEPAGE again, it is added back to
> >>> khugepaged.
> >> I don't like that, as it assumes that memory within such a process would be
> >> rather static, which is easily not the case (e.g., allocators just doing
> >> MADV_DONTNEED to free memory).
> >>
> >> If most stuff is collapsed to PMDs already, can't we just skip over these
> >> regions a bit faster?
> > I have a flash of inspiration and came up with a good idea.
> >
> > If these regions have already been collapsed into hugepage, rechecking
> > them would be very fast. Due to the khugepaged_pages_to_scan can also
> > represent the number of VMAs to skip, we can extend its semantics as
> > follows:
> >
> > 	/*
> > 	 * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> > 	 * every 10 second.
> > 	 */
> > 	static unsigned int khugepaged_pages_to_scan __read_mostly;
> >
> > 	switch (*result) {
> > 	case SCAN_NO_PTE_TABLE:
> > 	case SCAN_PMD_MAPPED:
> > 	case SCAN_PTE_MAPPED_HUGEPAGE:
> > 		progress++; // here
> > 		break;
> > 	case SCAN_SUCCEED:
> > 		++khugepaged_pages_collapsed;
> > 		fallthrough;
> > 	default:
> > 		progress += HPAGE_PMD_NR;
> > 	}
> >
> > This way can achieve our goal. David, do you like it?
>
> This looks good, can you formally test this and see if it comes close to the optimizations
> yielded by the current version of the patchset?

Either has same performance. For detailed data, you can see the v2[1].

[1] https://lore.kernel.org/linux-mm/20251229055151.54887-1-yanglincheng@kylinos.cn/

--
Thanks,
Vernon

