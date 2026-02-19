Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C825DE9A057
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067F46B0005; Thu, 19 Feb 2026 12:51:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015E16B0089; Thu, 19 Feb 2026 12:51:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63D46B008A; Thu, 19 Feb 2026 12:51:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF2A36B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:51:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 301E91C782
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:51:18 +0000 (UTC)
X-FDA: 84461947836.08.725BBBB
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 70B63A000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:51:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0VD2J1Dq;
	spf=pass (imf15.hostedemail.com: domain of 3kk2XaQgKCN0I9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3kk2XaQgKCN0I9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771523476; a=rsa-sha256;
	cv=none;
	b=a0j8V9bqrUalxkDKaAKCRmxNMSvKs4Fj6loOtfSfwAVedxPWYnjBa8Pb/7pUdZeUOY7yyg
	9kc7j9ZnZIxbe8Cg3d96kUm4sDws7Y2r30CBr5A7hUlrDtuI7qyvBiSa783J9tM8k72ZqN
	Dxueghq7WFmEqxIaGmh6m3YUOeOTsag=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0VD2J1Dq;
	spf=pass (imf15.hostedemail.com: domain of 3kk2XaQgKCN0I9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3kk2XaQgKCN0I9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771523476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IXpBP8QQij/QANTEmrSzmhAgXmjTuFNt1jCC1s0HYK4=;
	b=g1pAPr05CFLd/sWbFTlfPwk0PChnxC1fVvjHYqqY9o/vrqjhaTXwq7hE2BbE7Jnpl72T8z
	jhJaYAvJ6QjaChSVjpHuAsnay6MTjAuYSzRB/1A0V2iEi99h2hZzuiRCjdkjQ5NNw6TDwT
	KI7nLL2hd2pgzuAj2IR6D/JyhuNfSrk=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so10309755e9.3
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771523475; x=1772128275; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IXpBP8QQij/QANTEmrSzmhAgXmjTuFNt1jCC1s0HYK4=;
        b=0VD2J1DqhoCNnl8rptgfJdznOi97sT3zUdEtR22dqo9RNSOVug0cZJVO0Qi8MeiQtc
         7e3nkLYYCBljKE0G/NbWYhrVSF1X73efYlnvTM6U4yVAoq1NwE7cqpg9tu71SFCGcEbJ
         3+qMoYPKixIdP6NvmmB+lRe4qvkFscGcKPKVF6VPHonJrL/LpVjcCz68LB60A6/iGKH9
         FVWGSBHs+PluN/qSfkKoPuXijOF1NvW51e3/S3+OT1w7FQgEFDE3IpWrXXH7o82bXdF2
         ZMjfCIzsiHNTOKYMZq8laQhDxQyzcDrem8UO3ROE02WH6517cYtx+hHXxRDyvWxgaUVY
         7mZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771523475; x=1772128275;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXpBP8QQij/QANTEmrSzmhAgXmjTuFNt1jCC1s0HYK4=;
        b=I0RLDhcQZPWrXIgkCgChHNUYdfwMzirw2g5b0/BxOLOk930EbEsw33WAGitnkb4I9c
         X1IPH6dwJX1ZsRIsc4D7p6eMpd1fr0wVDRTxZzKx9Dtv/qu/vZk9sNW9CoHuL/gYDtfu
         9VXQcYbOXVVRnnNkr05LDMXwt4ngG5pQYv1+iy/H4XmCwYIDogZOi3YtD5IL4HTNTzsw
         jE6HxYsuxCrhutLqkUD7+jjmcm65ZtNgM8BWJTr3QEhB+FNVns40mLQFS2lpKN4+dUXW
         nCHWvMWxvIPwZRPSdV62372/XiJbIlofSBUSSFiRX+WLXeJeoom2gVbfByDgmD4pNQlL
         mJOA==
X-Gm-Message-State: AOJu0YwKmiqo4/bfsmXWwBK1JOrBXkTDrwP+rQFrnpsWIgwXdZ68m+vA
	M2U7zGmHgwJTWwQFbKSD+wo48lEoEE5kb47aKf8lP4l/so4VURD4FR3ciTeWxkfzGTlRlQglTT5
	nTEphP/0C9ZU5bg==
X-Received: from wmqi17.prod.google.com ([2002:a05:600c:3551:b0:483:2c43:9664])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c08:b0:47a:8cce:2940 with SMTP id 5b1f17b1804b1-48379b991c6mr321632285e9.14.1771523474570;
 Thu, 19 Feb 2026 09:51:14 -0800 (PST)
Date: Thu, 19 Feb 2026 17:51:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2
Message-ID: <20260219175113.618562-1-jackmanb@google.com>
Subject: [LSF/MM/BPF TOPIC] A pagetable library for the kernel?
From: Brendan Jackman <jackmanb@google.com>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, rppt@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 70B63A000A
X-Stat-Signature: 8bxf9urkwttpqeqmz4rm4ci8hhbb4hxe
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771523476-873310
X-HE-Meta: U2FsdGVkX18ax6nlRou7dpiAnRYH9VQ8l5u59cbQw23o3AJdGXG26CbkCw0Ge5p3nO36brxqrtSo1r1oTn9U6wOrAm3CGSPSPaleDZuof7cMArnJ0Ci4K+Z0M2k+e41MYjwQS2ltB+lAeqvcnuAsrfKUPD8v3weYEoI9IFrDqFoL8KdOwQY56wWgmUps6Nnh8IVzaD4Crf9dBVvxD6QypIcMHypZDiZfRkfzEkoPF3X8MRUhKek2e+He4/wiXEZwoyWNhC7JywJhTwnIB6612MqpGKvKwGRJzIGdZuFrKKCRc5pE/+u6nCZ3piOZ0G+VeqqILtFvlGKmLAb+rYlXFdhjOvTie24qP9HIxJrjSLf8Abg1FHWxb6TUJIZJNRiY8Q0ve9wCHfEtHiFEtlU2ez5YyUPbFsoagmAUOIZ/arhnjtHnPoKPH/Gm2y+CSLwGFCsqJ5lxlGWZG8UyPU4IOonqKYewmAwwR/2GXLht3KIFAfcbMO9/t/oX2GnsXO4cGtUJxvNHYPPk/GnQBT8XdsoMnCVOwkJi42RBrlnfCsEc0nuqaOxvcaO5CF9PdthOlhQQ6mJ9OrgeHcuX99659t0lbgeB7o07HT4LNbY1hp5vxKm0LVYR4YKPm09QhnphnkWQHNV4ZeYwKPHPaeiHD8YxtOK+BFQI1FyTCRTusidD8jMukruoKhs0ziDyedRW8JVfeIF061PYrYEiqVD0Wj5Y/rEOcskg5xj7EQm8WTLWoAbgY6NlW5Ipq9S1cB8qLn8R+HE6BZuWHPtTn4eZSslboD9RA29KM162GsVQVjxgfuUAtdoRLQHwnlHlw7LIpvUXoOn6wdC0bXDHKcsfy0tmaPIfCDClLaEWpBKO/BZmUO48/3t3H+aVjf4SxC2o7wsB9/DKjnOByWJT2WRenWW6zn1R6vNPSDUA+dd97TaikUGsxFP0xNdpKHngo8UpEtIUhhKqKQz32Z0Qzgp
 gdGOiNP+
 ilwjNr7Cj/V6+nvNad+Lk6HVZ0iWloxe/vNRqQKMNPLaYlD5ZGhfEQqO9AqVDDcJz8S5kKQE8pQZ3AYB+yav1GNve9EEHiGI+PUvu/yox2b5wRF1IMq/8KyJgSR5BqKlE2lfG5DcLH7Y0i/ZxLZCqNgMz7A75RKBpP0oTMG49J74F0xcNjBVUXY5FGKmXDsUmZxpikkoC7PrAdtEsHYbJ8WJk/+akFflDA87zWCQfZOPt7gRFdxIlt6+WJi7X3UHmM7ZbJKs8wr4aTk9OFuSRRHYWz++gXMsVVO/SMKQ53waT/frNe6kp7um3VP9+7VEs3Vfvc/PgHPzhyP/tKjCrC/koytIb03H1iVyGy/eBPpOSYXTpC4k6SjI8dEZ3iT64FW4E2VutzhzUYFyTcaGhV4lVxvIQTQ+6L5j84rSypk8VVrbbzuPhskFvnZ+06T6z2g6BK4Z/iPvHN5fiZiYn7J5uWqBCx+Jb52aauDjczUifquxuRjvgTTB31KR5XMxp31q7RdTclhh/IStfDNI+htjsZRcUK8E4GkjXwN/QfR1nSM2A+pyM6oyLM8tiokujwHZAO5tyq+ZRdoJYN4AeazUsB4iR9wMTs0KKXV97sXOXFaZAOUqpmqoFi0+OYSriqC14lWPuiXdCFqe+a+DOKVf0yKfU9Vy5HkxQMvjk9TfjDHuKIe0EFRJXVdjCCN0BQOnboXSW6cOM4yU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As work on Address Space Isolation [0] trudges slowly along (next series co=
ming
soon=E2=84=A2... I promise... some details of the plan are in [0]) I've bee=
n running
into a common issue whenever I try to do new stuff with the kernel address
space: We have too many sets of pagetable manipulation routines, and yet we
don't have one that suits ASI's needs.

Similarly, I'm currently working on support for efficiently unmapping
guest_memfd pages from the physmap (an extension to [1]) - in this case I'v=
e run
into very much the same issues as with ASI.

Here are some areas of the kernel that manipulate pagetables:

1. The collection of APIs that are specific to userspace pagetables: mmu_ga=
ther,
   mm/pagewalk.c, some vm_fault logic, all that good stuff.

2. The set_memory_* and set_direct_map_* APIs. (Which are implemented per-a=
rch).

3. Some non-userspace-specific APIs in mm/memory.c, such as
   apply_to_page_range().

4. mm/vmalloc.c

5. Highmem logic such as kmap_local_*

6. Boot and memory-hotplug support code (your architecture's version of
   arch/x86/mm/init_64.c).

7. x86's KPTI

8. x86's LDT logic

(At LPC I started enumerating these off the top of my head and multiple peo=
ple
spoke out with more examples I hadn't thought of - please join in if you ca=
n see
more!)

By and large, these components are designed completely independently from o=
ne
another. This is made possible by the smart design of the low-level helper =
API
(pte_present() and friends), and it does lead to nice explicit coding style=
.

Here are some "new" things I've wanted to do with pagetables, which are not
currently supported by any library:

- Have a second kernel pagetable (for ASI's "nonsensitive address space")

- Modify pagetables safely from a context where allocation is not possible

- Modify the kernel's pagetables while accounting pagetable allocations to =
the
  current process

I think it's time to discuss if there's a way to scope out a "library" that=
:

a) Reduces the overall amount of code in the kernel, while

b) Serving the needs of the incoming guest_memfd and ASI features.

In this session I'd first like to do a quick survey of the pagetable
manipulation systems already in the kernel (that I know about), what purpos=
es
they serve and what capabilities they have. Then I'd like to discuss some i=
deas
for the scope of a new "library" and which of these components it might rep=
lace.

Mike Rapoport has shared a prototype that he wrote for a generic higher-lev=
el
PGD abstraction, so I will be using that as inspiration.

This is mostly about looking for feedback and input from maintainers and
experts: what opportunities for refactoring might I be missing? What challe=
nges
might I be forgetting about for sharing code?

[0] https://lpc.events/event/19/contributions/2029/
[1] https://lore.kernel.org/all/20260126164445.11867-1-kalyazin@amazon.com/

