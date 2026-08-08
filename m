Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B98FFC5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 10:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A306B00B2; Sat,  8 Aug 2026 06:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1ADF6B00B3; Sat,  8 Aug 2026 06:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90ADD6B00B4; Sat,  8 Aug 2026 06:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 664C56B00B2
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 06:58:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1794160365
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 10:58:40 +0000 (UTC)
X-FDA: 85077804000.16.78210B6
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf15.hostedemail.com (Postfix) with ESMTP id E013BA0003
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 10:58:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DGgdRj2F;
	spf=pass (imf15.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786186718;
	b=aSh80NOB84umjpay4gT6WXMYPS7k1VIV5SyyFBiF5zMZd/lHSfH/cRodmNkkXMEWPvldb0
	pWZCkoU/bXQI7pDcvYnHHX6XrVX7wfqWzo1goQCa+poj9KC/KXjvDrlm8CuLxebLz/TM72
	SDjq+AgGoVL54IH/PUbjxjC/pOMk0yA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DGgdRj2F;
	spf=pass (imf15.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786186718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gFo3pDq4eQYRdy3D1/uGQvkKMwUkSIKPZQA1ehAXiU=;
	b=8dOd8Z3MBZByeN5TokODJEIbko0plL4JRp++b7KiZrSDwSTY6OD750baU1G0fOq5z4KzcP
	HxDc96bOMQmGckyA2YknzXny7U+fexGDJRl2bdgZjjw+Z7a/VK31LMbMwXFsXZ7a+pj9Tl
	/+kPS3qqohIlK28WrCiJpl8otnmu3l0=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-38dbe53179bso158397a91.0
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 03:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786186718; x=1786791518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9gFo3pDq4eQYRdy3D1/uGQvkKMwUkSIKPZQA1ehAXiU=;
        b=DGgdRj2Fmyqrb+sc6qCvmdT+ayQqf2z6A/RGYhQt48IWv5PsqzdKptzOclPvPKJ3Ww
         T18V5PWKdH8+czyyju/tBZax+PA/Z1HF4gn4ivjCR3JVIfLQ3bgVyscThuwNR6LdEht7
         rbp8/s/dZHuq262QAdNoy0g2tSm7C7H4T8HeiirydrPiebtwvUhYZmawaQCKprhxw0MP
         USx/JhBtQaadDo4zSgaZzxnQupQOdfS6uxa9i/xxRn3FwY0TwTchVGeSOcUm9ber2f9O
         sjdb9xMJ+tu0Yim5HQKGxmmJsh7ktnSjf3S0/bipoZ9Q29qNqvS+AdO0JA9/OL6MrJeJ
         VqOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786186718; x=1786791518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9gFo3pDq4eQYRdy3D1/uGQvkKMwUkSIKPZQA1ehAXiU=;
        b=aLrLDWjPMMlJk8fsyrkJkvBuhYIe59WUtDcb77kYJGglI0mB780X3+IA7lLZV6jtp7
         W93IPJm2OBIapjULxMTvzAqGOwf3VT3knKdLRl6g148Yo/RH2NqsXiMkS8MWoWZekBq0
         WVq/S2ixHJNDmQ54y6V4b0bzbe6/0hwz5uaRERsxnlLzMkDSMxE6s4k3e5rJ6uUSmvH6
         aBRDPa3To8KCTJc5i1NRNNVwB39sBsphEYwXlx3yKIryYgDQzI++zY8J8YqrKhWe1kaV
         G0ytDD8g9jbTO2aQxNgbpBqwesmuw6Lv+5J8tpHStERdK9lzMmmQ2e0lOQY0AiGQgaO1
         5hGA==
X-Forwarded-Encrypted: i=1; AHgh+Rq7zslAh8AmrOvfsVLQMHMh6TzHz6mWn11Dr4+aQvN184Yhnzp2oAIpYWdbnj96ACxGpWUGntciOA==@kvack.org
X-Gm-Message-State: AOJu0YwrNOa+xEWpjZt/hH32cnlOOQrUWy5RqhhqvYGQZJu89SY9luQS
	xxw9hlv+iWg4bNshToo5I5u7IA6r6O3Na9Hk4D8O4QKQqWgStd0zqjbI
X-Gm-Gg: AR+sD117fF9euCxhb7UBrpYJ1htxvqZF0fCRqKwQ9+77Y/NmquNcLx2Ji/bKe9vsMaZ
	WEMNImNO5yycXmHCdYd5/FlYmF1+Cr6j2GZaV8o+u3KuqLzwSbZun15NWqdpbDKEkwzurLEmXx7
	XBvULA7ThjGD9rNAg3eOxAS7mgvq+5dbqOlUHgYG97wo+q8t9+ZLhETRazTt2ylHziCEzn+D1TS
	Z1Q7G8vp7R+f6mCFzi8OvjKXW9YzuvwNZ/nZBSREWK58TPZwzo32pstArDjkolLT6wHL35JUfNH
	yIM7hxcDO5kK0Br0BvetCRAcfKlxf7+hACvRwrjijZjivkpBxuU8twXb1zrX+Fzaq6bGiFm6Pco
	v6erxE0XSu1kVdIW1QGkn4LHXIC3Mng4RuSKLCWt4x4UNYY6GGf/XDubeys2ndiihJUn29iwvvs
	nnUUwcOC0pJBhyrOeNXMQPE6xSW7s1cXT2gm4lHxck0zX0zH7HjCI4qjUSCWzYF22UwrXTzTgJV
	tQk7k5NmkotYKar
X-Received: by 2002:a17:90b:1a92:b0:392:6638:2e6a with SMTP id 98e67ed59e1d1-392823bfc0emr5468220a91.13.1786186717681;
        Sat, 08 Aug 2026 03:58:37 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:4438:bc18:5a8c:feec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3908616d21esm8552074a91.17.2026.08.08.03.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 03:58:37 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: zhanghongru06@gmail.com,
	baohua@kernel.org,
	ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	willy@infradead.org,
	zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v4 1/3] mm: allow page faults to request VMA-lock retry
Date: Sat,  8 Aug 2026 18:58:20 +0800
Message-ID: <20260808105820.23608-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260807074948.28953-1-zhanghongru@xiaomi.com>
References: <20260807074948.28953-1-zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E013BA0003
X-Stat-Signature: ou8sudu1btpsd31nokqj41f9hmh4mpfq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786186718-761213
X-HE-Meta: U2FsdGVkX19nXxnwKYEMtwQN+KIWGB+cdCVH1Qg/bExsrvK0Yx4tHJOXvS1mNkrBK1l73ak17DVLXSvvXsOff2rCXZBbKnETytfqxNgxtPI47TpZcHHCQ18QE0QX3nyKeM8OYY0h1RFqqbSyPRMSpFk3ghUA46NBnCJxSKvSomC7Kg0g+A+RRxxi+8dclHu0VgAp3n+uk8d5yUNbES8stxYlIynIurAZMHO2M+FnSCcWpVeyiaOb6Yt2DAuufiU2yCf6by5ifZq0OOQ3r0g8NJgXnK18fxhoGHzp6KRDyNB6HV3lTxoBdpkp8jfBaKSi9FdvqVQyl6uhd896idRAASs6+khOm0ReeKM4MXqn8ET6CUpAE7jpO7x9GdGxExdaPOUhJRLvTI4TNLJldqda9ICG5ayruOaqpdUhw/fvLsO9E/FnIg4xIFQ57a7qYLeSUhQwhqSjK7Rla8TkwcKgqicYWM9eMG0HOZPgJNtFOVPpWG3ZiCtv7U0z4ZfRO+Q6qi0fOmZbJF/x0RGqosDUqA9sih5xSUeJSVUYWbuKJHhaK71utcVFRW7o+9EFeE6I8g33ELV70MO6UPHlb0Iowdu5fj3KNzD4RKvwjICgJMVznlKv87jrxTomDxhbBCEV6vk0TjkBX5CBgTqCvNVLxkCkQPaYKRbrF4ODcYbDujyaKh3YO38hjo6/q3arDCM+7e8v84i4sv2X863zV+7EDKm56Gk3vI4ysGj0QUd4Qh7FuIB9yajFziRoS+t9tmoD4t6xMSk63pTd1RFMGwYZ8D//fxzwpeeSke4MAlUoFcLzIbrgSdKyud8iMSZXJUBV4sMSQJny37aCmmfrKlHqHyWmor5bLf33Hz8M+tfcKJFof9jMpJPGIbWJvDZAyuCUyomL8JXU2EjwYxhIKLD+pFG4O28Ns3C7Vcc1AWMaHQSYycJMD0sduqo/nm7KD/2os+tbH7iBB/DnSjrLX9q
 /scDgkBg
 dtMRUCl0Nb19J+LDCqtJphXrWD0ODNnegyQg1SxnWJqzI97QhowVM0G+cG8K8ta62lY/+R+Fb7Q7y00K50V2IzgEH9nMJfi23n7zLdUGYGbs/OGpyMCW+FhhJqjnnWGrG2z6aCsWDZd+XuN6TMl0Aa9JVgDaXcuhH4cW8NZMc3GVlx0A1382sd/TGUAnCcIDbhvjs62ltvSixoXiDSpjOKcpQZMH7rV6u/VnofTQGlVXmoGgCs5vRWKWahEXFFzq0Z+susQRhAjoYphFbF2ZeeOn91Xao38TczsOF/Li2qzJR8tmDnVNYpzvY1UE5+aZ6uF9NdfPrZihPHgoROz5FlWkkGQ7MQR9kUtv5YDDKRSnhifh00LowM2W4SDSctQddEJg2kHenvux+kXH7qQr+PqNtkd4Pxk2qgDzfF5qFU5Wiw8DHvf4mhRwWR5k7NnqHs9UEoxTs67lcezM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Swap Throughput (higher is better):
> +--------------+-------------+----------------------+----------------------+
> | mmap writers |   Vanilla   |          P1          |          P3          |
> +--------------+-------------+----------------------+----------------------+
> |      0       | 17303.09 /s | 17899.48 /s  (+3.4%) | 18190.62 /s  (+5.1%) |
> +--------------+-------------+----------------------+----------------------+
> |      2       | 16728.04 /s | 18346.72 /s  (+9.7%) | 18162.03 /s  (+8.6%) |
> +--------------+-------------+----------------------+----------------------+
> |      4       | 12596.23 /s | 16095.20 /s (+27.8%) | 17991.45 /s (+42.8%) |
> +--------------+-------------+----------------------+----------------------+
>
> P3:
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 45b99c3b1442..c3ab30d32a15 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> 	struct mm_struct *mm;
> 	vm_fault_t fault;
> 	unsigned int flags = FAULT_FLAG_DEFAULT;
> +	bool vma_lock_retried = false;
>
> 	tsk = current;
> 	mm = tsk->mm;
> @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> 	if (!(flags & FAULT_FLAG_USER))
> 		goto lock_mmap;
>
> +lock_vma:
> 	vma = lock_vma_under_rcu(mm, address);
> 	if (!vma)
> 		goto lock_mmap;
> @@ -1360,6 +1362,12 @@ void do_user_addr_fault(struct pt_regs *regs,
> 						 ARCH_DEFAULT_PKEY);
> 		return;
> 	}
> +
> +	if (!vma_lock_retried) {
> +		vma_lock_retried = true;
> +		goto lock_vma;
> +	}
> +
>  lock_mmap:
>
>  retry:
> diff --git a/mm/memory.c b/mm/memory.c
> index 428eb555ecb7..8c34a857548b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4987,6 +4987,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> 	}
>
> 	swapcache = folio;
> +	/*
> +	 * If the folio is uptodate, we are likely only waiting for
> +	 * another concurrent PTE mapping to complete, which should
> +	 * be brief. No need to drop the lock and retry the fault.
> +	 */
> +	if (folio_test_uptodate(folio))
> +		vmf->flags &= ~FAULT_FLAG_ALLOW_RETRY;
> 	ret |= folio_lock_or_retry(folio, vmf);
> 	if (ret & VM_FAULT_RETRY)
> 		goto out_release;
>
> Thanks,
> Hongru

The two-writer results varied too much to show a clear difference, so I
increased the number of writers to eight.

Using a dedicated benchmark [1], we tested this on a 20-core Intel
i7-12700 desktop with a 2GB swapfile. The benchmark uses one pressure
thread under memcg limits to keep a 128MB non-zero anonymous mapping
under swap pressure, 12 reader threads to fault it back in, and optional
mmap writer threads to amplify mmap_lock read-write contention. Each
test ran for 60 seconds and reports completed reader rounds per second
under swap pressure.

Swap Throughput (higher is better):
+--------------+-------------+---------------------------+---------------------------+
| mmap writers |   Vanilla   |             P1            |             P3            |
+--------------+-------------+---------------------------+---------------------------+
|      0       | 17303.09 /s | 17899.48 /s       (+3.4%) | 18190.62 /s       (+5.1%) |
+--------------+-------------+---------------------------+---------------------------+
|      4       | 12596.23 /s | 16095.20 /s      (+27.8%) | 17991.45 /s      (+42.8%) |
+--------------+-------------+---------------------------+---------------------------+
|      8       |     0.58 /s | 15420.57 /s (+2658619.0%) | 17328.80 /s (+2987624.1%) |
+--------------+-------------+---------------------------+---------------------------+

With increasing mmap_lock write pressure, Vanilla degrades sharply and
drops to near zero at eight writers. P1 and P3 hold up much better, with
P3 consistently outperforming P1.

P1 retries once under the VMA lock before falling back to mmap_lock. P3
additionally skips the retry in do_swap_page() when the folio is already
uptodate.

If there are no objections, I plan to respin with P1. The do_swap_page()
change will be sent as a separate patch.

P1:

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..c3ab30d32a15 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct mm_struct *mm;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
+	bool vma_lock_retried = false;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1360,6 +1362,12 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:


P3:

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..c3ab30d32a15 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct mm_struct *mm;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
+	bool vma_lock_retried = false;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1360,6 +1362,12 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 retry:
diff --git a/mm/memory.c b/mm/memory.c
index 428eb555ecb7..8c34a857548b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4987,6 +4987,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	}
 
 	swapcache = folio;
+	/*
+	 * If the folio is uptodate, we are likely only waiting for
+	 * another concurrent PTE mapping to complete, which should
+	 * be brief. No need to drop the lock and retry the fault.
+	 */
+	if (folio_test_uptodate(folio))
+		vmf->flags &= ~FAULT_FLAG_ALLOW_RETRY;
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;


[1] https://gist.github.com/zhr250/218ffe693f842346b56434483127422c

Thanks,
Hongru

