Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4187CCFA18
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 02:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306328E000C; Sat,  8 Nov 2025 21:40:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD5F8E0003; Sat,  8 Nov 2025 21:40:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2DA8E000C; Sat,  8 Nov 2025 21:40:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB038E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 21:40:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A16F21408AC
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:40:18 +0000 (UTC)
X-FDA: 84089514516.27.9BDE11F
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9AD4540006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:40:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m56MBNOk;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762656016;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDJSjfjd98R9zyaioAZ2ttihCqA9hQAGiasYcBqo+LQ=;
	b=i9IaVNbI6SogC+SS8m/xBveZMGZK3UqkEhcmPxsVABdKcsoXixQWApmwGfVzWAiXVCLBsc
	xx60OtlZ/af2qi2tXyacuOh+vB/s317dTUCWk+mefPYvVym02P4SDXHR3iJJhabGoXEX09
	FjCstQ1Zw9duO6IZnvITspPmb5PLdNQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762656016; a=rsa-sha256;
	cv=none;
	b=ku6Yt6DkaUGzOSP+rQHPFsiGqT5MyETD6IDKmkUKZy94j5eYZ3TS7PupyLgc/Jodlen6S2
	0cDIuGzq46WjdamWIp6UwweEV+5lbHRzO6qZdezoh8QHkF5bx65tHz+s13k32tbcT8VoNv
	Nk0ZYMi9vLf3UTCoJeDjaMKJ9RStesM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m56MBNOk;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3c2db014easo361091266b.0
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 18:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762656015; x=1763260815; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VDJSjfjd98R9zyaioAZ2ttihCqA9hQAGiasYcBqo+LQ=;
        b=m56MBNOkklEuqPNtJbRDPEzDSH5DlH8M0YSsR8wwkJs8FijJWgR9VnKeyBK2Dym5ya
         WlNxBsFRXoh0aAATjxXmpOxwzIKkyvBEeW9Rspy/resJIB+oUc01Y/4KkOcHuW+Z3MHx
         K6jiqqn/JrnICOSRL+JoCnPqPQYug4FTJPQV9aoQQT3DyS4lBvUOKNTABcaR46bQ41JN
         fDsz+WWIDInl+CMEdRqkCM9uH+fPWefKiCTNOLf6bMjRQkQMwZa9Ks+r5EPuU1LuVcW+
         m/B0JhLDm+kWtmllgDQhGXo5/BqbWh8ApiaoHJcIA3bKMq3ACoNcdvjnWh/Pl1XX8nku
         5/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762656015; x=1763260815;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDJSjfjd98R9zyaioAZ2ttihCqA9hQAGiasYcBqo+LQ=;
        b=KB5zCPwABhlT0+fXMgTtOj4FLpUfVYTf5srg/DtXYzJqBmja2qPBRHoYU+Bk5y21Hh
         y98J7u2tALJWRIu6G0+NFvfrh7a66o0Dq25b2kkujrxfQ7jiLStwFKeZ8RCE5EgPlrLG
         cdUDqDmC7I+oZK9J4g4imNGESTtgKCGScUn+Q+MQRDFcq3LQUUtQS3YzUalsVp46R4U3
         rvY9oMCuZut238r242fZMwPl6rOowwsJwE6D/NE8oOATHXOoqn/EPGQGwF4SQXeoNvxP
         oWARUrIT+kuH0vQzqVnBJNbr2ywwDa/P30NM1SK1q89YbnoQYFE3w0+n1FDllTN74/Va
         xLoA==
X-Forwarded-Encrypted: i=1; AJvYcCXG+kuL2OLNUj9KKqi7G1FQCNOojZZSUJ69tjq7xLVQn9bhDqVwGxzl4A6pFtxehFkbfZoM8L7HCw==@kvack.org
X-Gm-Message-State: AOJu0YxZjl0EAlTF8jEuXmKbKjyyDeXSxTMlqzMXmXZSPKO+Vvuz/WqL
	0dLMwzQpFSFzFgBYh+awylYt+LGoLs2Ad5ZPX0ZCxKPeG8Mk8kV8vURtGUNjP5R3
X-Gm-Gg: ASbGncs9qrNu8GDELssPLVrZSXs54bKqnxAhXs5wnPT6P/fwJuKucRIOTquLbdGDoGW
	2T5cXsXT9OUEfif1hzdjDokfXsDgoKwlOykuUDTUCj/i2ugYQ6KCrdTfV8vEEOnhN06/hDpIKV5
	ZoviRmhFR7IJ+3rdq7b5ZqkBsErw/dq0DiE6tElWtlZHyANoeRlx2cjpTh4p/lwD1gm7rpW1nOq
	5S7YQ74usdp4CWZpJzxi8mw1B8ur12dsYxtP7X8Z270cCWs4IR1ffRTvX4tbj9cC/VFIC4tX4Tj
	gkEwPZvkehJYCYEvE3NRqSBJwDQRWTWyiUpkyJ0fuSb4yRlGyr6zl97CC9SwQ+JquZ/mWGZvwQ2
	HBd9OZv8cBnjCPsPaH+aL53dd/aB+FH8NtC9ZaorO1Q7dmf7AJ3XGCDaT4qOx0hAQyF/WCsM/QS
	c=
X-Google-Smtp-Source: AGHT+IE2Wq8Y+ygBID6i/t3iykn6/9+oUOxVHVcNRiQ6+GmbFnEIqdu/5sD0+e0Gaz1ul5lCkjm1dQ==
X-Received: by 2002:a17:907:1c03:b0:b72:9c81:48ab with SMTP id a640c23a62f3a-b72e050415bmr364444366b.59.1762656014957;
        Sat, 08 Nov 2025 18:40:14 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bdbcadb5sm713642666b.9.2025.11.08.18.40.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 08 Nov 2025 18:40:13 -0800 (PST)
Date: Sun, 9 Nov 2025 02:40:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
	cl@gentwo.org, jglisse@google.com, surenb@google.com,
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
	mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 13/15] khugepaged: avoid unnecessary mTHP
 collapse attempts
Message-ID: <20251109024013.fzt7xxpmxwi75xgr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-14-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-14-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AD4540006
X-Stat-Signature: 4mxah1ym8me6arj4us9yd3r8s5dxqybp
X-HE-Tag: 1762656016-551337
X-HE-Meta: U2FsdGVkX19eSs8QArErT8ZCJJafkUy/zzeZsyWxQfpDCSzWbVwgoVUD34BNOAHs8/hoyZY0Yo3AVpbgISWJmU50maE+es6UQVmo8KxkDs3Ftqm9a1nk+8LkDa4Xa70yIlrmW/j2i0h5PODFYhhTYs5VCeAoNxr0IEVpXgh1wMlUKTt3CFLttwieDF3i3EKC93WCH5isKqOC6MlupN0kDhFuPMHbt6YebkeKsK2fUlp//7hC4dZDC9InhLUHslakVH2ULoa+TyZpJlWQ7z05sAKZWnmqJ9Guk3PCauisOpI+Psq7GRc2suaszNSAodZK7UGWiZ4WoTkDfvDsTG7uOWsC0DVdmZAQS+88BLsXC9NoOvNvpi3exYo9R+dhA8Cv2yS0x8FOroWEZkPGZ3ki9EXGY0Jpcn4nAkfYpYBBP7bywPRzmvmjeQuT1zsR116w4DZRfHpS8MmLy1sFWFuXIdg1cKWEtOgBoEz+j+ACwfQ5d+4fdZM/BPTmz+JUKhcL4TfR0HHwrpLFjZXA2lFciliqR7zgH/axGEDwsflktEfryrMs9XK4XI0/kCId/5uaVQf2K3f0dOxDdLSJl+uRSYCcRzvc9LjReW9GxD2V677XbrTcPG0jPtnYR/udcP0SMNKJBfzLQJOQxSy7q1r1iWvV//Ps7UYvN3H/57Q7r0MYsLwaqa/sqDt/sdRBt74BQx9k4g/5g7nZ/AnVKHyrWNKWtx1CkXseAnOuK0rRyEm1yNKLeWPbeqjgDRWMS8Ma59ca/GRxL5cA/06IYbtv5yfLVMdczjp9+wtYdpZRTq1Hl9luRAZ2wavtHKCoQK3Hm+xFZtrsc9zQSWZ8QoyaqU+k1Dv27rxHriQa2z6grRmg+GOKlEIQAm8YO5/nrRDxKYkYDZQKod0VIVZX1TY4DL1t2s4/sqJLK0zPQ+tbAhJcW/QcBiqZj4iokZOtlzzskO+Lz7ORrZuh0xXWOkY
 PPgpzxMe
 Z1we0I6UKVWEGOWfUvf6kIOvXdSIROjqcSprivupSb0jquoHJTr1a+ULNKVU5oTWmXVqjJi2gJBXjdhzO9fL1Dtn9PVDuK5VpM3QkjDw5YM+MelqPW9TeWcziJHp6iL5h9/jPJ319LdPlAGT7/64KwbmZ5Kop+B94uqRES/DQaMGG5doqQSQpCbHlhVsLLpdG0tfgqZnRFq6kIrhpGad36DkbYQ4woClNTnviJQsVQIPCIMgz9yw33uUwUGRa2ShfOpY0zP6nitmsJhi8j1DZMjUxFW+vl8yhmSz2di6exQwL/gel1eRv+tzvKm/dZcfGfE8PLYaBxE9CR8tsBb0tlbc0GYGGYTU2D+lbKtvx/I0JUXD2IvMgT8TrPAT3gf9Dxs9bN3TONDea5IePPQMb2XgA2JrznUOLAUjYRke/MrHrGt5nqKYNaFaUWESAPSnKGP/0EzUw1qybWxQsynm6z64O9qyXGtCmz0yuVOnpEaQSuXX24qS8Qs2pzMlERDp1PR7JclN1Ui4azPYs4ARDH4Yw40qvNxmVOLkXk4SWcXjYeESc5+w/48LU9O7fxyIxJLl5yJIF9oEz63OQvVZDQLFRpHpLr+M2Y/lgnjQAT/X6vs+6vW6jKnGqcfXE6R4gmmPrk1PUhMsoLm8VsXxiciSCLmwFanXwCaIUEaF6L59UKhgrpZG1MImjrdppSp/Yj2yfIoYx7Vv8EqW5LjOpjOoAXisP0L0q5r1c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:15PM -0600, Nico Pache wrote:
>There are cases where, if an attempted collapse fails, all subsequent
>orders are guaranteed to also fail. Avoid these collapse attempts by
>bailing out early.
>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
> 1 file changed, 30 insertions(+), 1 deletion(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index e2319bfd0065..54f5c7888e46 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1431,10 +1431,39 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
> 			ret = collapse_huge_page(mm, address, referenced,
> 						 unmapped, cc, mmap_locked,
> 						 order, offset);
>-			if (ret == SCAN_SUCCEED) {
>+
>+			/*
>+			 * Analyze failure reason to determine next action:
>+			 * - goto next_order: try smaller orders in same region
>+			 * - continue: try other regions at same order
>+			 * - break: stop all attempts (system-wide failure)
>+			 */
>+			switch (ret) {
>+			/* Cases were we should continue to the next region */
>+			case SCAN_SUCCEED:
> 				collapsed += 1UL << order;
>+				fallthrough;
>+			case SCAN_PTE_MAPPED_HUGEPAGE:
> 				continue;
>+			/* Cases were lower orders might still succeed */
>+			case SCAN_LACK_REFERENCED_PAGE:
>+			case SCAN_EXCEED_NONE_PTE:
>+			case SCAN_EXCEED_SWAP_PTE:
>+			case SCAN_EXCEED_SHARED_PTE:
>+			case SCAN_PAGE_LOCK:
>+			case SCAN_PAGE_COUNT:
>+			case SCAN_PAGE_LRU:
>+			case SCAN_PAGE_NULL:
>+			case SCAN_DEL_PAGE_LRU:
>+			case SCAN_PTE_NON_PRESENT:
>+			case SCAN_PTE_UFFD_WP:
>+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
>+				goto next_order;
>+			/* All other cases should stop collapse attempts */
>+			default:
>+				break;
> 			}
>+			break;

One question here:

Suppose we have iterated several orders and not collapse successfully yet. So
the mthp_bitmap_stack[] would look like this:

[8 7 6 6]
       ^
       |

Now we found this one pass the threshold check, but it fails with other
result.

Current code looks it would give up at all, but we may still have a chance to
collapse the above 3 range?

> 		}
> 
> next_order:
>-- 
>2.51.0

-- 
Wei Yang
Help you, Help me

