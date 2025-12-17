Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E5D1D6406D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 03:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F26C6B0005; Tue, 16 Dec 2025 22:32:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0656B0089; Tue, 16 Dec 2025 22:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881A76B008A; Tue, 16 Dec 2025 22:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74B5E6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:32:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1103C5B6C9
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:32:00 +0000 (UTC)
X-FDA: 84227539200.27.DE62110
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id F167C40007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:31:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ggLPXsUZ;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765942318;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yrt0krtSkhxFdwbJh3XMwdymVKEbrhRi3WUm41XmuLg=;
	b=uaOtSPR8yTbbaqyIrW+7jdrs7pyvAy/7jaHkVwKZ/rYqsg/6XPlRnIlwutklIgzJT5G8K+
	l/pTUlFnQUNggF+hv6qaFjrGTVnHCde10gz0IvugHuMtvimkmxLMBvieB0aBKRApq4vc9D
	YjWrcJrh4OmPImZ97DxWBHqmY52MCCU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ggLPXsUZ;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765942318; a=rsa-sha256;
	cv=none;
	b=Z5RwUDKIVWDnYYVlZp6oZYQhPb/7aKxk8uts6n0pPlgFw3NQplMTx6SAI4558Xz9aVRCj3
	Zsw2uRbksevAkkV08q2kktVrMhilIfywMUBDhPN0doRfItgsKozUupt+P0IYt0eZyGd/uy
	XecrrqqTB7PpMoky//qHMz2YJrHOqUM=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b727f452fffso21426566b.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765942316; x=1766547116; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yrt0krtSkhxFdwbJh3XMwdymVKEbrhRi3WUm41XmuLg=;
        b=ggLPXsUZoej1Vhc1gaB7nRffX4sDmkiCMztQy2FLIfpx7iOZMbcp6C5U0Rga20S+Te
         aMBSSJfB0TUHrz6v+5TNqUcKaMKO4JimG8DP4cVOKVT5hSAP8G9bhY0d33JN1p1e1wH9
         MRPCv8nd6syyBDtubnkKv5VukL5yRGLMDKm5ip81gASOYIAbKksnrCKIoGkLV7m2ExgP
         pY3x4GNrn/3rNb8ikWd3FXcfE6F/ZJb8R2BbEGVyQ+mwZG3b6jMfMqHFp9lrFonzksml
         RoZBQ6+3FDdTRhFX6zu9HMGEQyU8dIcbYZzo/cLjOUPBnGQm/nOHXg4MxItipFA0TpT5
         HYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765942316; x=1766547116;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yrt0krtSkhxFdwbJh3XMwdymVKEbrhRi3WUm41XmuLg=;
        b=a3l3D8OQxN9Ljrf5eWb1vmFHdxAPsY8i+TB98tTteDwYKOGB7VpVisOSLJdD7+HaYf
         QRRHzyQFaRJ2nE5h2zX52uAlvSlILCCfluI/zhwWVJTs98CwS6tvCUXnS4vZTjolSO8E
         OZ8/+HCtVesAhUFiG4aA6u8Pz0Aacg97jksDiziJjfmPPjVpugxb6B4/H6VjqldbiAME
         EgdwtFWwdKtUQtNH0/kJj1pmkZ3BVrhrugkCRhJvbmbPO02oyytn6/vGIWN9hsuA/17v
         OQ+SnQW45JOzEG3ZAPqcoJQfR/WlqW3x4gJPgfbrRC/fJ882IgRjtOsfFob2hWcmsHTp
         w7Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXWJkD8jAvZR+F9wTqpGEMgkS4D91K/OPAGYL0G09hzLxLTvAkYTJ8H7q0JbLLltOA2XU8g2XahPA==@kvack.org
X-Gm-Message-State: AOJu0YzTJRtqRmtEattBB8AjrKQdGSQnpE3A4qO3SVEdEyWqyhy3WARL
	fWqsmG7LNXs9nLyT0r3TMwgH1kEd6lyroMPEuZkbFMuP2jXGVJh4ERUJ
X-Gm-Gg: AY/fxX7CMwa1Ndro/Hq+fH1tv4FqJEK5my2EGcHXhoaUF+oPuFBdpP3cjT8e6z0qzDb
	Qe+9/wilZzL5lUPA/Xc8GmA11uJVCRIjuhb4Jdh4h88W9+HdHvKwRlQfiwBo4AW9BmrAtFvjcx1
	bC8uSUclWhZWtsEoFZzVoIsjUsr31Ca9nM2vx2kWMi10NbYEy27Ul4AFFejLh/HF2r3Vb3L4oiq
	1z17j1uNz70SVe6bFMGG5Ze5iR2KvgeMiYdb0Qgab5Jq1U29Q2VeCgDk8h1L+12oa7iTYHFbuRX
	MtfwmtbUZ0kZJaaEtXJm+s+a7k8oGHHyWU7m+v2f+AOjcEc8tp8QqJSMSMapYoomphy/rmBgb7n
	7aZrY9FK8lWoC0JMvmXLplVwM+Lqz3hGgTvlP0KsYFwOkBOxVi78L+IDnHQQZ7XrDLpxxoowZzB
	vzfIz7nCPBpQ==
X-Google-Smtp-Source: AGHT+IEDd3QUmFfWnD59fzqxhZ4zU6ssVEsswD0iOlDrrZaBBqS4/Mukcnxxbbe1lTjFYUwS5Sv68A==
X-Received: by 2002:a17:907:e895:b0:b73:6695:cae6 with SMTP id a640c23a62f3a-b7d0219ed0emr2164844166b.10.1765942316200;
        Tue, 16 Dec 2025 19:31:56 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa2ea57csm1848713866b.22.2025.12.16.19.31.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Dec 2025 19:31:55 -0800 (PST)
Date: Wed, 17 Dec 2025 03:31:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, npache@redhat.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <20251217033155.yhjerlthr36utnbr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215090419.174418-3-yanglincheng@kylinos.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: fythwi5qjcuy1tzjcjgtewd33npxw3n4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F167C40007
X-HE-Tag: 1765942317-456372
X-HE-Meta: U2FsdGVkX1+E4L3OKX2ErpizPSVgTfkoCAth0jivIQ80+1krr9dF55Aaq5+gKyNxHyEdgaNhbfAd5tlZW+C0efNYu7MzSMxgrdPkD9ETvbCtR1qFhH0sCLXUM1mCI0SG0UrXWIV2SGWBPPyQoxE9UPkdtoHoznBMfF2H6CZpyp+srJumGEY+pMSymNINSraJIZaVkFRRlhtoovpLyvpKlAevf6DlJD3fNe8SSGv2vs9gF48WbEOpQhTVImZAie/hmlHMv4qDuza5EiqvtNpCUnlp9Azut20lbgRoqSHe9b7fxjDMOuakJQ6epngA6n9inkKBzrW9gC9Q7e9PpYszgWPd/qxUilxhzbjYAj/X0ocPnvO5gwJCCLZ2XzFwAot3Bx8HTj5wp1Y5PavcxzcItjeuFYwvWUqo+ZAaxFxz2QWK09c4pwAj9TV1yyZuses6ce0IggewemzSEbJbrTublyoMXv3XKOEwvsEyUQLJ36FXvZ/gZm4hruvJHvolS13CKfmWVETqzeWRggeAtYw6PvQDpY/WgIa7Ha82JX2798BWW05QgmdlHcRPFSDV0BQsXxe49tAWbPXH0pGbpu8NTYYE1DHXfYshYVG6N9wz8yAC1KB6D0lpHAsc9faCo93tB87rlSjvbWQkwopUJr+KSsiuqph/XFRNThNMbDWSX3up/j6+9vd7bR4Zwj8t6j5drxbLgPi/9DbPbbH9Px1YH7jonN7JFZPZztZHGIA8ttBYMHfZ/YZ5LSNBJTIfMMC3+xwpVhP9XUdcY72jJvKSikiZvqypUVKQEnmYGMkjFLC2r5L0MwdfX32NKTpdkkjfDLlLGmFBkMWbjwFHavGBrCMOx0JMAeq+8k8Z/6Np5DmlAwZPz+DzgXPQgFn23Og74OsCX28bDuhNXQoDcujVFsC73qKbk+xX61Uh/qyrjxinsduQkSH4nDfM9mENAIpjXslnBabCGxs+z61a9V4
 fylKAu9y
 vXkHtbaOJxj9Zsy3nWlTdBJ52P6gehfUUqqjg15QlbeipP4QPfsj07nlnhC+Ar5FVifwHrIVKZlalpO9rvx37WScFC3ONgryv1xPj6wGNnSNKcJvllcrf5oBB5CGvCeuFu4FIGqkCZP2CxdXqAVvBYPeSFeIGaM+iEPSIIDHPSvDS4Kb+/fu0ta+cS/ATEVGDYC1BBSxgpFg7wvBqnFmWbyfaoslk/mN8jlQig6u3/Rq5VD7+Owg7VTj1k0ve3jGds5ZACKHIarkY324BmQ30TTXXGnNRLdg8N6ruV8QLCG3MYOoWTxuTzrXr3c6YeAs3WxyQySMGkMt1FEEhHzzhDGlpXl0QizNjxSUibtvbPmKfZCcn+HEfkGdJkDqrfWhlFn8TCVXv26Fvsd437kCovxW3befn5W1r6q8BV8bVyqt6Q1F2KfQt5TYi5lzAbn4QfzfRPjTpTvW2VRm/3zkdAph7SOw957gcVXelkJsYFKYha/7tXm4u+8JxEgbhSbUmrxOWtH6Jxmg6GFa9/PlZurrbItnXOpxb+ZkgCVwiNxaIozptgjIGZDHJvj5DJy7UDNp3v5DKq+fcJ8vOfqXZI0hs7vKFAOpmcTW/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 05:04:17PM +0800, Vernon Yang wrote:
>The following data is traced by bpftrace on a desktop system. After
>the system has been left idle for 10 minutes upon booting, a lot of
>SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
>khugepaged.
>
>@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
>@scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
>@scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
>total progress size: 701 MB
>Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
>
>The khugepaged_scan list save all task that support collapse into hugepage,
>as long as the take is not destroyed, khugepaged will not remove it from
>the khugepaged_scan list. This exist a phenomenon where task has already
>collapsed all memory regions into hugepage, but khugepaged continues to
>scan it, which wastes CPU time and invalid, and due to
>khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>scanning a large number of invalid task, so scanning really valid task
>is later.
>
>After applying this patch, when all memory is either SCAN_PMD_MAPPED or
>SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
>list. If the page fault or MADV_HUGEPAGE again, it is added back to
>khugepaged.

Two thing s come up my mind:

  * what happens if we split the huge page under memory pressure?
  * would this interfere with mTHP collapse?

>
>Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>---
> mm/khugepaged.c | 35 +++++++++++++++++++++++++----------
> 1 file changed, 25 insertions(+), 10 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 0598a19a98cc..1ec1af5be3c8 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -115,6 +115,7 @@ struct khugepaged_scan {
> 	struct list_head mm_head;
> 	struct mm_slot *mm_slot;
> 	unsigned long address;
>+	bool maybe_collapse;
> };
> 
> static struct khugepaged_scan khugepaged_scan = {
>@@ -1420,22 +1421,19 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> 	return result;
> }
> 
>-static void collect_mm_slot(struct mm_slot *slot)
>+static void collect_mm_slot(struct mm_slot *slot, bool maybe_collapse)
> {
> 	struct mm_struct *mm = slot->mm;
> 
> 	lockdep_assert_held(&khugepaged_mm_lock);
> 
>-	if (hpage_collapse_test_exit(mm)) {
>+	if (hpage_collapse_test_exit(mm) || !maybe_collapse) {
> 		/* free mm_slot */
> 		hash_del(&slot->hash);
> 		list_del(&slot->mm_node);
> 
>-		/*
>-		 * Not strictly needed because the mm exited already.
>-		 *
>-		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>-		 */
>+		if (!maybe_collapse)
>+			mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> 
> 		/* khugepaged_mm_lock actually not necessary for the below */
> 		mm_slot_free(mm_slot_cache, slot);
>@@ -2397,6 +2395,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> 				     struct mm_slot, mm_node);
> 		khugepaged_scan.address = 0;
> 		khugepaged_scan.mm_slot = slot;
>+		khugepaged_scan.maybe_collapse = false;
> 	}
> 	spin_unlock(&khugepaged_mm_lock);
> 
>@@ -2470,8 +2469,18 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> 					khugepaged_scan.address, &mmap_locked, cc);
> 			}
> 
>-			if (*result == SCAN_SUCCEED)
>+			switch (*result) {
>+			case SCAN_PMD_NULL:
>+			case SCAN_PMD_NONE:
>+			case SCAN_PMD_MAPPED:
>+			case SCAN_PTE_MAPPED_HUGEPAGE:
>+				break;
>+			case SCAN_SUCCEED:
> 				++khugepaged_pages_collapsed;
>+				fallthrough;

If collapse successfully, we don't need to set maybe_collapse to true?

>+			default:
>+				khugepaged_scan.maybe_collapse = true;
>+			}
> 
> 			/* move to next address */
> 			khugepaged_scan.address += HPAGE_PMD_SIZE;
>@@ -2500,6 +2509,11 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> 	 * if we scanned all vmas of this mm.
> 	 */
> 	if (hpage_collapse_test_exit(mm) || !vma) {
>+		bool maybe_collapse = khugepaged_scan.maybe_collapse;
>+
>+		if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
>+			maybe_collapse = true;
>+
> 		/*
> 		 * Make sure that if mm_users is reaching zero while
> 		 * khugepaged runs here, khugepaged_exit will find
>@@ -2508,12 +2522,13 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> 			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
> 			khugepaged_scan.address = 0;
>+			khugepaged_scan.maybe_collapse = false;
> 		} else {
> 			khugepaged_scan.mm_slot = NULL;
> 			khugepaged_full_scans++;
> 		}
> 
>-		collect_mm_slot(slot);
>+		collect_mm_slot(slot, maybe_collapse);
> 	}
> 
> 	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
>@@ -2616,7 +2631,7 @@ static int khugepaged(void *none)
> 	slot = khugepaged_scan.mm_slot;
> 	khugepaged_scan.mm_slot = NULL;
> 	if (slot)
>-		collect_mm_slot(slot);
>+		collect_mm_slot(slot, true);
> 	spin_unlock(&khugepaged_mm_lock);
> 	return 0;
> }
>-- 
>2.51.0
>

-- 
Wei Yang
Help you, Help me

