Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3B4C2A06A
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 02:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A231F6B0095; Sat,  3 Jan 2026 21:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC1A6B0093; Sat,  3 Jan 2026 21:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87ABF6B0095; Sat,  3 Jan 2026 21:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72BE66B0092
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 21:38:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C0D78DEA3
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 02:38:03 +0000 (UTC)
X-FDA: 84292721646.20.E5501E4
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id F0409160004
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 02:38:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="kXC/cckK";
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767494281;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wKB+j20nmK7xDpcTxTiEEDSD6VNb6s5qDeWYX+VR1M=;
	b=ptLZgCseUSc0nElue5fZHKAbOhgu/FPAJPJL+81Ek29WDplu2QHbIgnczMPksULCGKGL8d
	2WtPZU2t73aERRJmNNo6R+R5bUJyZ1qHqlrGJrjvj8YsXhsIMumSiVvCmPgNHEFQ77omv8
	m5b1VovLIZvpbTPQ1/93RkNnLBXw3Hs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="kXC/cckK";
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767494281; a=rsa-sha256;
	cv=none;
	b=6YGRsK45c5GV1ek9fJmrUsMIVZPPX9Hi3snwxpyrBL2VXn6lDicdECgYJgKaJP7uvIZ02o
	vC5wtLuRMlYKOumWwK1ZDzAuXsLk229KHAwltVDxlBXZZNYVWUsim3aW3F5bviB/LR1aMB
	NLxCwTXVjv5wSJvq8fNieXgGPntyxh4=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65022780bb2so5672a12.1
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 18:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767494279; x=1768099079; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wKB+j20nmK7xDpcTxTiEEDSD6VNb6s5qDeWYX+VR1M=;
        b=kXC/cckKZ7iCgJbpqTy6m3RxVqf6FAFWA1OZYgdU0S3BDtUNJnskJfTR7LDM6Vb3ri
         06We51FWHaTD0hFpGW8595hTf17cqMsn1hlvbEVwDB7u/BlArLWL8LykOaN1olCuOW89
         O81fuS5WouTEIE1PtYTvo5NEAo8lf3e4mzcumThTIF/HPif+KaplSifJihxmkbOMvlWt
         e7nk/PKCw24FsHo75sjNNtO1WTA1H3+ath2T4ajc1aX8HrUSoA9s2BQ+TjT9qqwrS4Ka
         E6/E69mpi0gBCk1yNbe4BH04EI/CQKwQbelQZUFx8UkJi5DlgwSaCS2hMnCcEE/n0Rx2
         xPhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767494279; x=1768099079;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6wKB+j20nmK7xDpcTxTiEEDSD6VNb6s5qDeWYX+VR1M=;
        b=Fl/CPtmcc4gSRH/qRkQj4xp7YZtmivuWlh3ZLeZHwm43vsMbBsDMG9JRuSMkPdbfKI
         /25CGetYsFU+7d+udjiRkdyI6nUB4xGq/OW3RJUuaR5+GSw37dT4rUbK/pNcTsZVD+Bj
         8zzCwfnhhy03ycnIkOyeaONe5iOkqQ5otIRUmicAD/lhFSJ3Fpc7797zOjhik7EZ5/VI
         J35uge/91rClvPzxNTpRLDf6whT+bUBIvIfTazVgjvh5qyKp7juRkFsSDAY0iLTM7Pz1
         BQYwaRlS8czd5RIfAHYK/5RDzGvrKxm7mS5nl5CZOd3PWO7WpTJ3SlTC78tBBeyak+Z0
         1Plg==
X-Forwarded-Encrypted: i=1; AJvYcCW47tXEMLpmZ8dNcRhFCzmJfSG7vMVsF9lj+u85liOzLgkBwgNMFo56N189IbhKHn4HM0Oej97ltQ==@kvack.org
X-Gm-Message-State: AOJu0YzFYOtwi/Ru4VRFRqWFF97RfD9B8tiro3nDfSnCMcY8wDezN/22
	WM55SZCJyZi/MR1gTRtJWI+/X91Z4RJfiLuOnvqoDBYGDtnd9ESQj39E
X-Gm-Gg: AY/fxX69iqawtOl6l0JhRODohsPUvooH7boYyRJ13qrUL5K+QsWAEse4KmecFYDfhf9
	8NLdBweljhtqVVGg3/w0xWoKK7Uh44rqiG/i6WJ7VVr/XpueUCnr80IA/CvjLGwfvCLCrVn0DLA
	Q35K1mFeL/UPdfqb+QpGO5ZST82W4d9w011N7FZZF7iuWEDDzOF7yX0Q304K1y40cmleDPyhz/g
	Jgfd6YHXp3pRaMrCIkKI1MVy9yP53j6hVoU0mrDnrFKXcjqpXoG6wa73vX+QFMh2se2vcFu2He+
	7f/eysaAqLYviB8sk33l5bWVQhyBoLsGsuJ3c5DQ0e7kLUWyjnua17zKlk4bVCukG7F0Ie+EiiC
	1BMzGb+2sMNuPaEpSdpRmqYgQ9WswiEzSSQUjjbwWtoxBsMd0+qUQaG4rnZleZ1ycekqfQv+kkA
	zE7IL9qGMWEA==
X-Google-Smtp-Source: AGHT+IG8zgb0q79+2CGdVoNqQLo0gj+pkXe+FFJHkbkGRdgyA1XRa8a1rj6gXn5OP1VM1atpo/VVUQ==
X-Received: by 2002:a05:6402:350a:b0:649:79a8:8b4f with SMTP id 4fb4d7f45d1cf-64b8e94e1bbmr43300523a12.11.1767494278896;
        Sat, 03 Jan 2026 18:37:58 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b90414649sm49815378a12.0.2026.01.03.18.37.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 03 Jan 2026 18:37:57 -0800 (PST)
Date: Sun, 4 Jan 2026 02:37:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: consolidate order-related checks into
 folio_check_splittable()
Message-ID: <20260104023756.jufklyl3bl64fnck@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251223122539.10726-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223122539.10726-1-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Stat-Signature: s1afkz1os7g4j4dkncbh1hk8fmytr7k8
X-Rspam-User: 
X-Rspamd-Queue-Id: F0409160004
X-HE-Tag: 1767494280-52850
X-HE-Meta: U2FsdGVkX1+RZcNi2WX71EUcrWgr1nzaoKHKs0E7TdOPSNGFTfTa8UA3x4h4WSRjjyhlZz8oeSO3aS5Z2cpHS8iUUyFbsosfr5pgROpkdMEGQNiRgnEghdRpcnDXyXaSQeH+rRjG5qM47YL3SvbnkoerAviHDd5xuwc11+XzUBoH0MIbbUYUguR8/irzPw/Lj7CWMpG1waNgNxN3+M6i3DZsVdZR7Sd6UyzpesDCiGNj37SsMVWl6UDUDF98zXpv6MxlMvUUOjd8jFN4x9KzWRIkB/I93nd8QoM8shSmCpjAgZQaHI4Yri5MsriTDkV+/NJQSGlhyKqvv31AKavJU1qLh1C9NMGyHLlbuKeC2JN7t6ff2TAXLX1oC3QLaRc7NBjaQdb42WVvN7MZg3svRrGRt8BNa8fa4jledkS901UJoTlT2yN1BPocvfxpbDCKEYU+x5RkZVy9D4I/hnqjrbWudelzO032EAWeAJp8oqjFpMhfZjhpcB2i/xWbqKJSQQY0gRd2j6gboisFdtYgXNttHrmTqZKlxtbtnDADG6vpyBQU6ynB7JbreV8qtPS0jYeLrP211xFEY5GGoxLxLyZT3PJ/b683pKrX0n8hnxfAnFymVfkwg7FxYvIU1xUVeAtZw5nwQQ4OmaqLOci56FZgA93wkGtVtzY2aGsiLaQnm7xztC+2yuMFDzlIlrtrrwAX7dBour95TFkQxxwmOdYEZ9xXFlFCQiMLmmBGjgtK83AvmW+ARB6zBgjJXFvx5AnnN+dl+9v/h9Qxh5FJTd+/DafOiOohK0RRiia5blw/B4EmywKXO4AlvEdgc/DHXL5k2cOya78UQk8sdAB/zKPy1ufib5FvVIaDLd1bTqBecEgQNpcyqVnDEjy2JktEfdtu07XUWc30Z25YYm2Qf01uT2hbkP4pxqAFsLhZ61+7SpT7bJw6242J+j8ezQJp5innLYbaTBgU1NH8ztW
 JiJiSSWf
 7RRDxX3ZyQ8ov87FzDTgdqe8lZMvd45m/bTwlznP2UOV0BVPF0XpLJEYMvJcc/zhn9yojwpDvYTzj7ChkMlHxrLEDXlE1S49B6rYCp/rERvP4IbCQM3q4JSIGys6SHhdTOeY1Mwz+K3tborWTx++dUNomAQP2Im8McysGH+4HmbFwSTmypIVAZ0jzCizR7WJuGnUSo6nTIk1Zl9E1ymQp8ERy3h2A0iyxMsRD1jtNSesN4KF7qjkU5n9/EeTm96A6pKREvbYrzRA0ekZfARINAZAWGjDGwGAIDTaBCeAIkxej9v8tV9QE+h16MS1+w0hOsk7OByGVDazK7xuWG22OuhT7tOpt+ah72J8I1BvEM0lbyV+Ql/CbdyqTnrDv8Ed0aFkrxiGHnXc/cDO7Y6Lfwu73HdHMZna1suQ5PvRz2J870XGQQtN9O/QwozBrPBBZOnWy+O+CfUb8lAMCBYNDW/TMAymMbm4w3WsItYY/PxJavMN0XuMA7LDhLyWFJyBq1HwQTSKeqx/PNxN7q4fzaOiG4aIUoBAnOr/tW0VTatt4SsMHiJZJtA9FwbbSDbKGHw9XY7KaohQmtnePOtGAJtZt33nrjhAKcgWYaGsYuQDona7ju3+3iW3c+g51hW4T8Q39wNgKD62kdaDIwwtj7IQGj0cEHV8AjnSei+M/10+rQVLBgQmr0KEF/9woYf+t5nWvp1UyVfBiL0BLwotX0taHvaMBw8vAWBjswr/mZkJcvstFrWefXhlYzgk74STDMy+nO/Vm9RazN0ZOCnoH/+wjVxss2erFIGtN7E0TtUkNjG1KN+SJSPTydQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 12:25:39PM +0000, Wei Yang wrote:
>The primary goal of the folio_check_splittable() function is to validate
>whether a folio is suitable for splitting and to bail out early if it is
>not.
>
>Currently, some order-related checks are scattered throughout the
>calling code rather than being centralized in folio_check_splittable().
>
>This commit moves all remaining order-related validation logic into
>folio_check_splittable(). This consolidation ensures that the function
>serves its intended purpose as a single point of failure and improves
>the clarity and maintainability of the surrounding code.
>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Cc: Zi Yan <ziy@nvidia.com>
>
>---
[...]
>@@ -3719,28 +3723,33 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
> 		/* order-1 is not supported for anonymous THP. */
> 		if (new_order == 1)
> 			return -EINVAL;
>-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>-		    !mapping_large_folio_support(folio->mapping)) {
>-			/*
>-			 * We can always split a folio down to a single page
>-			 * (new_order == 0) uniformly.
>-			 *
>-			 * For any other scenario
>-			 *   a) uniform split targeting a large folio
>-			 *      (new_order > 0)
>-			 *   b) any non-uniform split
>-			 * we must confirm that the file system supports large
>-			 * folios.
>-			 *
>-			 * Note that we might still have THPs in such
>-			 * mappings, which is created from khugepaged when
>-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>-			 * case, the mapping does not actually support large
>-			 * folios properly.
>-			 */
>-			return -EINVAL;
>+	} else {
>+		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>+			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>+			    !mapping_large_folio_support(folio->mapping)) {
>+				/*
>+				 * We can always split a folio down to a
>+				 * single page (new_order == 0) uniformly.
>+				 *
>+				 * For any other scenario
>+				 *   a) uniform split targeting a large folio
>+				 *      (new_order > 0)
>+				 *   b) any non-uniform split
>+				 * we must confirm that the file system
>+				 * supports large folios.
>+				 *
>+				 * Note that we might still have THPs in such
>+				 * mappings, which is created from khugepaged
>+				 * when CONFIG_READ_ONLY_THP_FOR_FS is
>+				 * enabled. But in that case, the mapping does
>+				 * not actually support large folios properly.
>+				 */
>+				return -EINVAL;
>+			}
> 		}

Hi, Happy New Year to all :-)


Following the application of this patch, a warning was reported [5]. The root
cause is an attempt to uniformly split a page cache folio down to order-0 when
the mapping has a mapping_min_folio_order() > 0.

It is worth noting that the current upstream code also denies this split, but
it does so silently. This patch simply makes the violation visible.

Upon reviewing the code history, I believe the logic introduced here is
correct. The existing comment--"We can always split a folio down to a single
page"--appears to be misleading, as it does not account for modern
constraints where a minimum folio order is required by the mapping.

Below is my analysis and suggestion:
----


All the story came from [1] which introduced folio split to any lower order.
The check on order is fixed by [2], which is the base of current form.

When we split a large pagecache folio, it has two possibilities:

    1) khugepaged collapsed folio
    2) filesystem supported large folio 

For case 1), the folio could only be splitted to order-0, so the check is
added, (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !mapping_large_folio_support(folio->mapping))

For case 2), it looks implies mapping_large_folio_support() is true. And it
looks we assume it could be splitted to any lower order. Because the
mapping_min_folio_order() is introduced by [3] and the min_order check is
introduced in [4], both are later than [1] and [2]. So when [2] applied, we
don't have the knowledge of mapping_min_folio_order(). (I may lose some
background here, if not correct, please correct me.)

The introduction of [3] and [4] changes the assumption at [2], besides
checking mapping_large_folio_support(), the mapping_min_folio_order() should
be checked. So the comment in current code is misleading:

	/* 
	 * We can always split a folio down to a
	 * single page (new_order == 0) uniformly.
	 */

For case 1), it still stands, but for case 2) we should also check min_order
with mapping_min_folio_order(), which [4] does.

If my understanding is correct, below is my suggestion for the comment change.
Feel free to correct me, if I miss something.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..b0ba27b0f763 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3714,28 +3718,28 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
                /* order-1 is not supported for anonymous THP. */
                if (new_order == 1)
                        return -EINVAL;
-       } else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-               if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-                   !mapping_large_folio_support(folio->mapping)) {
-                       /*
-                        * We can always split a folio down to a single page
-                        * (new_order == 0) uniformly.
-                        *
-                        * For any other scenario
-                        *   a) uniform split targeting a large folio
-                        *      (new_order > 0)
-                        *   b) any non-uniform split
-                        * we must confirm that the file system supports large
-                        * folios.
-                        *
-                        * Note that we might still have THPs in such
-                        * mappings, which is created from khugepaged when
-                        * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-                        * case, the mapping does not actually support large
-                        * folios properly.
-                        */
-                       return -EINVAL;
+       } else {
+               /*
+                * When splitting a large pagecache folio, it has two
+                * possibilities:
+                *
+                *   1) khugepaged collapsed folio when
+                *      CONFIG_READ_ONLY_THP_FOR_FS is enabled
+                *   2) filesystem supported folio
+                *
+                * For case 1), we only support uniform split to order-0.
+                * For case 2), we need to make sure new_order is not less
+                * than mapping_min_folio_order().
+                */
+               if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
+                       if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+                           !mapping_large_folio_support(folio->mapping)) {
+                               return -EINVAL;
+                       }
                }
+
+               if (new_order < mapping_min_folio_order(folio->mapping))
+                       return -EINVAL;
        }


The warning reported is in madvise_cold_or_pageout_pte_range(). I don't find a
way to eliminate it, since user may specify any range to madvise(). Uniformly
splitting to order-0 is a general way.

[1]: 2024-02-26 c010d47f107f mm: thp: split huge page to any lower order pages
[2]: 2024-06-07 6a50c9b512f7 mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
[3]: 2024-08-22 84429b675bcf fs: Allow fine-grained control of folio sizes
[4]: 2024-08-22 e220917fa507 mm: split a folio in minimum folio order chunks
[5]: https://lore.kernel.org/all/694ac438.050a0220.35954c.0000.GAE@google.com/

-- 
Wei Yang
Help you, Help me

