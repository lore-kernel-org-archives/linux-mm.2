Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E85EC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 08:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03EE56B0005; Sun, 18 Jan 2026 03:39:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DE96B0089; Sun, 18 Jan 2026 03:39:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E344F6B008A; Sun, 18 Jan 2026 03:39:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D0C7D6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:39:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A56E1604B6
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 08:39:39 +0000 (UTC)
X-FDA: 84344436078.08.30AF56C
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 43C6340004
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 08:39:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=elxkmbIR;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768725577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kf5vvI0XpsxUrrKsjVxrAI30uxGfTH908lu1v83Vp98=;
	b=hz4VoLDcojrLHnpvA/WUQ2xqcvzrDc7/nOzvrecJowRxmBIvPSVPGI3vr5gfqexgLwF8YQ
	2+NaSq1xa2yCOb0VXvoZHT/gLHD4qolyUBJhp1uHf5SivgrGMkSUfFw/nfu5TCUknDmObb
	5Q33hzOsbLWzlw1Ks7ip+7TF6RQnvVI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=elxkmbIR;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768725577; a=rsa-sha256;
	cv=none;
	b=j6ulfrpF88w+K3qZdl4ulqUSDKuQq9l4BIVDkSSefLWGMT4objpeAkMHYYkJXp4YYnVt8Y
	1UWG1Cd1rp41rmi6YNZDer+7Oq7ZDuy61lC4DFJaexTn5WvLmtAxmlYTjxXVVaUazhXii2
	z3ksgrgga1epvQdYAbJH+lXzIJJww9c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768725574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kf5vvI0XpsxUrrKsjVxrAI30uxGfTH908lu1v83Vp98=;
	b=elxkmbIRMuIO52A3PVmj1hYbRcVOj9JHklVu1OiD+esMg2jsnOg4EkVoymcRpF/Kj4EBOH
	8A0VpPlvwAVutjPo2aRt+dvRLvxvumTLM5a1U1F0dcUSa7poBs1NPecvubbRBRsOG9+wwC
	vDwuTxJHyNcsBgTe+7Ed8yD17SmwbDk=
From: Lance Yang <lance.yang@linux.dev>
To: hughd@google.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v1 1/1] mm/khugepaged: move tlb_remove_table_sync_one out
Date: Sun, 18 Jan 2026 16:39:11 +0800
Message-ID: <20260118083911.21523-1-lance.yang@linux.dev>
In-Reply-To: <62e637cf-91e6-454d-a943-e5946bdf7784@linux.dev>
References: <62e637cf-91e6-454d-a943-e5946bdf7784@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 43C6340004
X-Stat-Signature: tzo5mg3hp1rd6wpeerj6y1xu77b1uj31
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768725577-784811
X-HE-Meta: U2FsdGVkX1+Lx/dbh58JPZFjk+B7+6URgvwoxUJ+l15mc7pusiQppUOpZOvJHkdH2xJb1cijGTl0ykabxHEKC7GZ1OP8Dh1m5WCPpymMaGro/mAxFZGcfPWAcI/hgB6CrVjdvdWJaPyiexM9f8sSKH6CQl7zRe6Efw8/Z+j+MiPirZSjBrsscp5b0XSPGBbmB0YzYgu1uxEku4EXfEgyL6KEOZXAacpcYg+tsidRpRHTexUL6CStgof7G1AbAAtLk/H+/edalF181Ifr+sLpLxY7KbYFogRMUurgKKm1AEStftoWtI8DlmLP7bIg5/P5F5oq1DuMr/HXCnb1yQE+Jk0iPybXnXAaKbK53nhK8HMmpYObc7s9ezgTCeE6wVSKfzlVuIjwSIh1XmNWWuyil9+Y9s7sMar960uxTHQqFzfFB0pIVVW2SkFVcWsqUUzPlpCrldSSxE0IoIXaLnjuac4Eujnl54QDIdjW2HOEawKWeSOCDDwo1sMyJX4jzPubK9osI9+C1Toe8SZlcbFZo60+zBCC8eNY7Of9ri60MRAqi0Zzw2j04fL5pGplOo0eEunRKcQQiMfjnc3LcSNRga6VOejvw4wFArDUSd5ftn7O0+yQjkBI/HpuMbcLDNh9d0EDs54xfk1wWd/QEZj4VYR3LBJR+HHqM7qIPD1gaAq38W3pailpscEFGSxWjlnSucHGsJFjkqYX0ersKcbfbZ08hn140A8b1rZKSXEZxQJWCT2MlOgx2GIrlZK73qHX0+EOxTPgW1/0SMJDD3tuUdUxDilkkI7HqxCYF963Q5edz6lLfKW5iXA334uQxksypiDC638rpgnZal0XPRezG1LhSeLLKGZllSki+huCcbJCPLb1ndbnl1EIesXH6Y14ygjMkWaw80HDAaLwgX7Ug26ltT1A7IB55eWAe+oNdNb0RZn8+C2nSg+bmDsQGczAxfyjeiQVw/IzdNf4k/f
 fEV2oGB6
 TbipfsDUBsfnH8qEN5mKJgBmaEZSDm0ky4pKCfz547aR/FbtVTa15W7/zfhva7DkCiE7CdRrj45ZdLoUXtC2UaS0s02PIfSfLhY+QrCAKrK/ycojp8mbDGmg1RLJUxZJNa7U5U5DY6F1LhqTMeGgqOveu1OvSP32XgdwOe0fKOJWn6/pedQvUP/1v6vjqbmaQSYFo09JNR/cSU6Zxg8m7Sd2+bDK4EJBz05phjP1Jtiu+80ysrdPgA3AzRXLX2AiCexYXLSN6h+rDKow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hugh,

Could you check if my understanding is correct?

On PAE, pmdp_get_lockless() reads pmd_low first, then pmd_high. There's a
risk of reading mismatched values if another CPU modifies the PMD between
the two reads.

Commit 146b42e07494[1] introduced local_irq_save() to protect the
split-read, blocking TLB flush IPIs during the operation.

After modifying the PMD, pmdp_get_lockless_sync() sends an IPI to ensure
all ongoing split-reads complete before proceeding with pte_free_defer().

As commit 146b42e07494[1] says:

```
Complement this pmdp_get_lockless_start() and pmdp_get_lockless_end(),
used only locally in __pte_offset_map(), with a pmdp_get_lockless_sync()
synonym for tlb_remove_table_sync_one(): to send the necessary interrupt
at the right moment on those configs which do not already send it.
```

And commit 1043173eb5eb[2] says: 

```
Follow the pattern in retract_page_tables(); and using pte_free_defer()
removes most of the need for tlb_remove_table_sync_one() here; but call
pmdp_get_lockless_sync() to use it in the PAE case.
```

Regarding moving pmdp_get_lockless_sync() out from under PTL: Since
lockless readers (e.g., GUP-fast, __pte_offset_map()) are protected by
local_irq_save() rather than PTL, pmdp_get_lockless_sync() can be called
outside PTL as long as it's before pte_free_defer().

In contrast, for non-PAE, PMD reads are atomic, so pmdp_get_lockless_sync()
is a no-op.

[1] https://github.com/torvalds/linux/commit/146b42e07494e45f7c7bcf2cbf7afd1424afd78e
[2] https://github.com/torvalds/linux/commit/1043173eb5eb351a1dba11cca12705075fe74a9e


Thanks,
Lance

On Fri, 16 Jan 2026 09:25:54 +0800, Lance Yang wrote:
> 
> 
> On 2026/1/16 09:03, Baolin Wang wrote:
> > 
> > 
> > On 1/15/26 8:28 PM, Lance Yang wrote:
> >>
> >>
> >> On 2026/1/15 18:00, Baolin Wang wrote:
> >>> Hi Lance,
> >>>
> >>> On 1/15/26 3:16 PM, Lance Yang wrote:
> >>>> From: Lance Yang <lance.yang@linux.dev>
> >>>>
> >>>> tlb_remove_table_sync_one() sends IPIs to all CPUs and waits for them,
> >>>> which we really don't want to do while holding PTL.
> >>>
> >>> Could you add more comments to explain why this is safe for the PAE 
> >>> case?
> >>
> >> Yep, IIUC, it is safe because we've already done pmdp_collapse_flush()
> >> which ensures the PMD change is visible.
> >>
> >> pmdp_get_lockless_sync() (which calls tlb_remove_table_sync_one() on PAE)
> >> is just to ensure any ongoing lockless pmd readers (e.g., GUP-fast) 
> >> complete
> >> before we proceed. It sends IPIs to all CPUs and waits for responses - 
> >> a CPU
> >> can only respond when it's not between local_irq_save() and 
> >> local_irq_restore().
> >>
> >> Moving it out from under PTL doesn't change the synchronization 
> >> semantics,
> >> since lockless readers don't depend on PTL anyway.
> > 
> > Cc Hugh who introduced the pmdp_get_lockless_sync(), to double check.
> > 
> > Sounds reasonable to me, please add these comments into the commit 
> > message. Thanks.
> 
> Yes, will do. Thanks!
> 
> > 
> >>> For the non-PAE case, you added a new tlb_remove_table_sync_one(), 
> >>> why we need this (to solve what problem)? Please also add more 
> >>> comments to explain.
> >>
> >> Oops, you're right, the original macro was a no-op for non-PAE.
> >>
> >> I should just move the macro call out from under PTL, rather than
> >> replacing it with direct tlb_remove_table_sync_one() calls.
> > 
> > OK.
> 
> Cheers,
> Lance
> 

