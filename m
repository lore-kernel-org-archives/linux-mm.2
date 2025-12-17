Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C90D609D5
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 02:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA6C6B0005; Tue, 16 Dec 2025 21:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64D76B008C; Tue, 16 Dec 2025 21:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991906B0092; Tue, 16 Dec 2025 21:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8653E6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:48:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 367CB136BEB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:48:23 +0000 (UTC)
X-FDA: 84227429286.23.66C2E23
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2BF2314000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:48:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ik0y2/EE";
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765939701;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTMYwp/g74fxgb/i/Lv8htybblW+OirvMdDQqwF3ziU=;
	b=WM1pRmAFo5i5Nwx33hxcJ+9jotrNUgXX5dNboL5TqxgiohKMPPfLzVuugEiQLcdwHRlSRn
	5yVuCO2r65tBASgLrBs+P8uB8IwJ44ofG1o/oam4QECvF7bgJgEsLr3x30d0Lv+YmBz4s0
	sVVs4G2B46TrZP+pWaGf/eGuDInl/9A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ik0y2/EE";
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765939701; a=rsa-sha256;
	cv=none;
	b=AKIll+yGsDueK6yPCWrCucOTH6gVsxK4FI2lphBIRikxMQ7dMiEies2dmilA+kmXAWgePm
	dhiGhCtkzaIp4ys1D+csbVFkZbIEGr+YUiQaBfjJatwvCpcO06w/vMlyRrMtpBRoiaJF2S
	1QIwMecV++fl0Cz45XnGIeHCS50hIdE=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b735e278fa1so967284966b.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765939699; x=1766544499; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTMYwp/g74fxgb/i/Lv8htybblW+OirvMdDQqwF3ziU=;
        b=ik0y2/EExxqCK9/Sx8wzlwK7Q7etLcJO0SeP09WEFpomMzLPiDyoTiNFA1N6ktL/8O
         1Oh8s62UCj2jrfyuhPuLzrTp8ZjhlJYJP7kbUiEbwS7z5iodC6qWRiD2rfn/WJ77TlOk
         Lm2NYVecoN3BoAGvqBWepSouD+G/EmxI77orE6jgW36sye+rtdxMQofVu6G6MyLaXFz6
         TsTjtBscTGCeUp3eIbX8FN6ymb/N8Cdbgy1mtzF63RfWZVAT3KtSfbFwvybVFGBawqZe
         HpP2H158j0HEEzqfsY8HLiC7eYSd5gD86mhNAWjRdJ2ZLXVQwCx0v3H0ohh+6EDYJ7s5
         zVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765939699; x=1766544499;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QTMYwp/g74fxgb/i/Lv8htybblW+OirvMdDQqwF3ziU=;
        b=g5Ed3zqVm2JkdCHKU6BsaIx7+OdIhXVr/H0tAlOSAGSebJ778/2S8C1tMXSZqpNe3S
         C+7uB5Ctd85acoJHlUCBFyKgGM9g6Sush5L5W4mKgEiZepAQWwwiceZtXy9M+VPNPZQw
         VY078Y+g9waRDJ7SdLIjyDCYAsftsS1kZ6+g0P6QmlE7nXfjK6Ra5grH/hx1i9WRrtvs
         6YJ50x1pD1Bc5xAlakzChHQd6gxvdyREKCe55wZXagQIjuUIzidvYsSFE3TMzmajfScG
         nK0LiuB3tW9RpASKHGxqAA/codbaWEO1I+rHsYof3JeIHPgBBmdHfXbh/If0w4C+LMpR
         XX8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW007eN5K1so2aX8nJIO3PWChOhc50/aXXzAEh1tbmb2e33z7ZbpNH+FrPVKRw7g1w83ABLICIFww==@kvack.org
X-Gm-Message-State: AOJu0YxGi7qtq34oOHYxFlMNUCkXAd5AuGrt5BblLczthwLVLrjJVdi9
	OWnjTIu91uyrUvIXtw3NZ3QVTOVeMZyAfqWsoaN2j6Vz5iqYck5k66Ag
X-Gm-Gg: AY/fxX7cdb94SmVqpC1idYOMNGfMwiJIOGdFtrZPfYkxkO38Q4n+bE1bAWHQ++JmoNz
	6aqEBPfHCLaJ5eRkWJjekKUx22vCyHnzunRIf3J4b4JyhEF88k0OOR3yLCBzzeWYhcTEhs+/OZ6
	FgGin0/uWB29TpQO5QNYkTc9I9HjK7R22ohSOvECF10mxjpuCZ+l8MLgGVQ/AGnSJ09ZDWiIdrF
	OGtc2j4uzRttO7/jwBxlS9cXIosEXLMgzdVyNxM7Mrj3gKj/yP40kPImEFcfGlIVUeREG9eYTHb
	f5lVxHdHHQa/DX5KJZoYWSfLw8NGAjUcSK8C88L3IqxiD1towaRjdG9zkkJj2RIbPFaC+JTAsdl
	qSppSXTJUBRrUU2bD53UpecwmFNfiQFHUP4azHKrpcYqi1sJZmvyMxEbxfbppBnvUYm1MUH+Bss
	hMCrxxJexZKA==
X-Google-Smtp-Source: AGHT+IFhKEFOVaiZGW0iX8z6HR1iAF8pgy5NX5EasuQ15D3ejV9v3HpNxYAjBAX045Mp0eeJPN6AQA==
X-Received: by 2002:a17:906:7951:b0:b7d:11ae:4006 with SMTP id a640c23a62f3a-b7d23a68805mr1809328966b.52.1765939699191;
        Tue, 16 Dec 2025 18:48:19 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa2ebafcsm1837731166b.28.2025.12.16.18.48.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Dec 2025 18:48:18 -0800 (PST)
Date: Wed, 17 Dec 2025 02:48:18 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
Message-ID: <20251217024818.ngoime34bxeatqij@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216111139.95438-4-shivankg@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2BF2314000D
X-Stat-Signature: dns6keodwnip9cxj3ndrb96pf8uoidfg
X-Rspam-User: 
X-HE-Tag: 1765939700-269183
X-HE-Meta: U2FsdGVkX18sJ78L9AcnRKXIVaKzXQ2x7afuHdM17L1OjnHajRt9zpYdH1nErK833ObPiYPRsbKgVKyEk7j4PHHzC+1sHgpe862ZKDGBsybOYXxeBF6sFCxzPWGHR/1L4RkatRriBTqlkc/vuS2e8PiP2yppsgH/X8yVHlsOKhQ/59DPhoJftOH7m+umpHJTjHPQd/Rq8xIyKtK/sHZF0npeZJZN/IiLk9fJCMHWndYGB5AWfmxnXLOjk8KpyPDHBX+tI3buJQkthyZOb5aOCZelxIbJNdUDrLzjjS5a22H1E1V3ZchSOH3IpZyA0FqmlC4hcn5o+9sazHc+bJ/73FRBsvJaU58uKVCVH/eC4mj6J3t7nQ675f/DF+bi8O3sI/IUoxEjyzUa4o0Qgjap7xIUE5R8Bv1lRSflkyz17Lg7m929hgY0X3S/5fGmSTnC2iTk+zubZ16aSnqNeWlv+egbnQ4Dqn8ZGNUh1ddEU8yobRvNRDXzrvJCQCcCuIsF3Js2hpXva4WI/nsJ8bLDq5ffDwW1IT7tbY1YmTUwB2PEdEHu0aDJ8IlNX/+h2ITiZiHYtgQUgOKOSnhoCHwwoHGjXwMCodjuKi46hDpRkfggkWpSlaMa5pSQBJdMyeS6NKf24xgPptXuvAeSkvfsSrj2oSsjjQxDBNu/RTJklV2S9VDZQbnD7hECPZH4bjYKJgBSKl4KLXpHl+DT3PCVNtxT1pQhdje96+TlQ5YHkuQ5axvgtOQ1lsuqj5Na9FLazpcs4+vIEpELg35WimbRl0nCSel4ffi3VCKsBh5bCjo2mgNTh5iM7X/JgUPy2R93UPiO7Vj2NmjmA2XEO+E+gvNO8pdIw6VZhAxFlG0BcZ3mY1SQbBdEKZFDoho0bmm21KWZ6EGGrvalAU1Qfh3bJzntPk0cZgjeHiNEK+3Z68ncdY+EM5cWJou/6nr1g1X2h0xgViRdB1aOf/pl5Vf
 wXgj+DLB
 AzslSMwbXcHBwU8bnI11jRTotFRLuJkq3jH/oa5a6CbHza7TiBX4/2N2E25/ERC6VhyYkv3lurDE7fR89LZ+qARPVA8XE0O3UPEimwTlUQpU7NNGGC/dr6sR5S2PhDpiy5y9gxIgSD8hvDFw9ynTWIi2++dxsLdHLLu7CjpfE2zkEgn2B+KR3od0zsBwS0DmhnOe98okQGpG0EGgQUj/Vk51Tsnb6AOw3nTwBgXdXhm18Mhbk9nASVQfRAYUYh7Xmky7EvyuCRkYkESMjrNBhiZIUyg8JOOv6iMUBMVUGBBTJ4WTB1/I3iUPPU02E/IS953mdjPD0pxrUhKrTgTgGqEmcY96pb2LhpkO0vCjSlBA4AYz/avhU1kgByPVAJ4rZyzBxjBG3jFAyrrm9hseBa9NIUowYMlArhiQDBOTTBGNh+Xczq7u7zdjBzm6YTiwLCSdaxdFxwgZoTAVpp3yYtGxhCBKQxHIgI3p8GP37VRhX5bUMJGLTEbWFFvqrb2ob4QHwyf5N6ivZkna4W7VKkfyd690rWvKLmN9t+bD2bZVfg5hqHXWDJsQceVUpZz3RGuXWyPuSh9zK0H1QtLhEmpO7YRJGy0s+KGxgZ+cMhSGxcYY739bM49OhE4gEafIjMkNiuMni0XSNQ0VqJsRn0TT7eKj+wy790hYWc+wYjOJXchO0l/77LNYVVz0Nl0wI7SrX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 11:11:38AM +0000, Shivank Garg wrote:
>Replace 'goto skip' with actual logic for better code readability.
>
>No functional change.
>
>Signed-off-by: Shivank Garg <shivankg@amd.com>
>---
> mm/khugepaged.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 6c8c35d3e0c9..107146f012b1 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> 			break;
> 		}
> 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
>-skip:
> 			progress++;
> 			continue;
> 		}
> 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
> 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>-		if (khugepaged_scan.address > hend)
>-			goto skip;
>+		if (khugepaged_scan.address > hend) {
>+			progress++;
>+			continue;
>+		}

Hi, Shivank

The change here looks good, while I come up with an question.

The @progress here seems record two things:

  * number of pages scaned
  * number of vma skipped

While in very rare case, we may miss to count the second case.

For example, we have following vmas in a process:

     vma1             vma2
    +----------------+------------+
    |2M              |1M          |
    +----------------+------------+

Let's assume vma1 is exactly HPAGE_PMD_SIZE and also HPAGE_PMD_SIZE aligned.
But vma2 is only half of HPAGE_PMD_SIZE.

When scan finish vma1 and start on vma2, we would have hstart = hend =
address. So we continue here but would not do real scan, since address == hend.

I am thinking whether this could handle it:

		if (khugepaged_scan.address > hend || hend <= hstart) {
			progress++;
			continue;
		}

Do you thinks I am correct on this?

> 		if (khugepaged_scan.address < hstart)
> 			khugepaged_scan.address = hstart;
> 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
>-- 
>2.43.0
>

-- 
Wei Yang
Help you, Help me

