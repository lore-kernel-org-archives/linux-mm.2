Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF9ECAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62718E00A8; Wed, 17 Sep 2025 23:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39C38E006B; Wed, 17 Sep 2025 23:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976768E00A8; Wed, 17 Sep 2025 23:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 832C48E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:39:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26586BB0E1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:39:55 +0000 (UTC)
X-FDA: 83900967150.22.CC3DC37
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02E87140002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:39:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uEAPl0RM;
	spf=pass (imf09.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758166792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYVy/gmUNLATO0N4l/CoYAjcvd2P1j3UppG+aVdlgxg=;
	b=cKUL4QI4DsIYbp084CpYy7Fur3zcNglncBMv6lZ7QRTz5ZRQMQEp7ECSMbRnmODslpgF4y
	LUUdDL2ZvZXmRCN2FebUoJwry+VOXYMgePdv9ebOnYBFZgOgMZJC2e3m+Zg0wENp6Cxe7l
	6sDfm/Kf40TdqB8r5t4g2/pLq6I2Reo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uEAPl0RM;
	spf=pass (imf09.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758166792; a=rsa-sha256;
	cv=none;
	b=gRjreHK11SSR0ZkIc/Ql8Yu+d8utEdgCxTDhGEKCdCjhpq5R/wWzeqdLD3bFiwGpEoqegC
	13GhlLxlp6viWeZEB2JmkRBh/IN2nue7Fj24k0Lp+rHdZNGW6023Dyr0qOQzAnD59DR5Lg
	Mepy+8WYxxqYH0SToSn1o2JjdtlaFec=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758166786; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xYVy/gmUNLATO0N4l/CoYAjcvd2P1j3UppG+aVdlgxg=;
	b=uEAPl0RM9X1CS00QTa2VDHoerdAOSvGdyawmn2kPDIcBSr6OnAw0aPxURjZQV3yqMppKNToFAr12Hy65xjz8p7GRzXaVVfaZbFexRmUeY9ITsQoP07et5ly+Sw1L5ZJ4dSce7qNHZni2ev0aKoUhNdGDzNbIaAAucsAN7XkNWzY=
Received: from 30.246.178.33(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0WoEX-ch_1758166783 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 11:39:44 +0800
Message-ID: <7d3cc42c-f1ef-4f28-985e-3a5e4011c585@linux.alibaba.com>
Date: Thu, 18 Sep 2025 11:39:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
To: Kyle Meyer <kyle.meyer@hpe.com>, Jiaqi Yan <jiaqiyan@google.com>
Cc: jane.chu@oracle.com, "Luck, Tony" <tony.luck@intel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, surenb@google.com,
 "Anderson, Russ" <russ.anderson@hpe.com>, rppt@kernel.org,
 osalvador@suse.de, nao.horiguchi@gmail.com, mhocko@suse.com,
 lorenzo.stoakes@oracle.com, linmiaohe@huawei.com, david@redhat.com,
 bp@alien8.de, akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
 linux-acpi@vger.kernel.org, Shawn Fan <shawn.fan@intel.com>
References: <20250904155720.22149-1-tony.luck@intel.com>
 <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3>
 <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
 <aLspJ5Tpqp4qRDk2@agluck-desk3>
 <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
 <CACw3F538k+dshTs1_rxbpYoRdFyX3tLYzfaWj-_d7Lq5Dd2Jsg@mail.gmail.com>
 <aL8rIgSImDh7Nj7E@hpe.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <aL8rIgSImDh7Nj7E@hpe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 02E87140002
X-Stat-Signature: 7x6ngxir55qo9apwc8wtediumrx9ciuo
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758166790-770499
X-HE-Meta: U2FsdGVkX19aR/L6s+qHdEXUyLjmQTTULiJpQ7zW6O5TfRZFni7vapuYa9O6XlX96EbyJocJcAHxCdNtauP+F6IUHFpr7m9Lxjo4a6RL8qGAdsI5Z9Ef5+7z2FH/dIAOyu2XDvIe6RcWk0Tfk6DhVEmOf3nYiLVxI1j9V7H+o4eEPsWtw5ShlQCdkX9/XWtlUok2TNJwUFL6MbyAZNgupcFOSAD1yn1TQlY/mQc9W5Aka+0+WvC4+/0bKCZQ9UKv2C6fjhi1wacOrdwJbIHdx33Sk4F56IZvfANXU7xZ0ijJMlM7nt2ARL/RBWHDYlCxqHX5iQ4EU9qKFS1xs0iKTGieTb8P5ok/8z9lMEeavEMnD4onPMC+EWKjp5/OBPbeB9KIsI9342baVwBQxT1g6HSIAklXFsZK3DPP3zTH8DqEe2fvG5WJqzN5gSMx+ycdx4BSr3quiTfCRC18BW75FS+x2FEHAID/kQAhGN9gfk8CSvY0nWnxipAbCnRTxxa78CEPjjNPIiRt0+nvwKBw6IAX521lTt1JW4elI0hAxy1DbK8IEEPzSb40WIjYPZuUD9FPokZn6tSMeI2m9X8TxahaVrCGUtU8ew5KTERhTJL6cR8pj1S7qK4pVQX8/EHli9u+oMkYnO0biEdNxDv4fOgkjXwqz94oeqADOeV8ub3G7T3Zotj27a01EBB5yC3OYepdZ5dE4mEcAP6PFEtBUkeaHsVAl46JWuOSzFSg9ymL08dAx/KAbcW+qnSUjyDYzbGAcRVFesqvg7y8eaRqXKyPd7v38f97nk3iw9IFdQHKYv9S0E6sS7xOYBF2EPwo9lRe3XPtkFw98a44cPAUwTVvTSmN3VGDaLP6FwzGhBZAyokFmjpNHqtPtEIjdlRECzLkclSNasy4A+gfXUwczkBdEPhCXndSvJ5TrbFnQw4C0Ij5BdvnSZO/ju20kP+xh8l2C2xRhr8Jz0bNT02
 cAycyk6b
 tS1KaL5UjHE/B5YPBDHCZlMjYf3sIr6gA93qftIRB6RMYfBpi0ZDyr8Jaiy0xgqw6/RglxjiyN165ZJ1cKOnR4LhmIbdg2jqdCPMPHukg6CL5wmV1J3AF7EuqcsG8N6mnsP7cbKOnZIGqtMu5LwRbd67KOlC/3cL+gvMNvzgFeJZg/01KfBev4E6AVXE5lz1lK49HA9wCoK8TUOmnKkTJupESCjpVM7KXYbY6FbwxAyrYkEjzht1rKfDDr15aUD4fqdZBROGlydV4eusc3/1peGhwTDEALhKUjT0XaBG5IpyVVuNrBj8yS5pH/Vl6qlQH7j6GIKV7oOu4joXO2/3XD5FrseTnxO0UN3NIXxqZUCNsL2lOFXHTRZpVaCF6hO+cxojy+c3xZCigB9UelIDzH7UYwbGm2PMyw6lD1S4iesnRyKXFb0g6fkh4Xa9vYwrYfZJs9sJtVblcr/QZekVFRZfbHff7eFyfJjkSGjRD3/n31BYaza6fKeykaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/9/9 03:14, Kyle Meyer 写道:> On Fri, Sep 05, 2025 at 12:59:00PM -0700, Jiaqi Yan wrote:
 >> On Fri, Sep 5, 2025 at 12:39 PM <jane.chu@oracle.com> wrote:
 >>>
 >>>
 >>> On 9/5/2025 11:17 AM, Luck, Tony wrote:
 >>>> BIOS can supply a GHES error record that reports that the corrected
 >>>> error threshold has been exceeded. Linux will attempt to soft offline
 >>>> the page in response.
 >>>>
 >>>> But "exceeded threshold" has many interpretations. Some BIOS versions
 >>>> accumulate error counts per-rank, and then report threshold exceeded
 >>>> when the number of errors crosses a threshold for the rank. Taking
 >>>> a page offline in this case is unlikely to solve any problems. But
 >>>> losing a 4KB page will have little impact on the overall system.

Hi, Tony,

Thank you for your detailed explanation. I believe this is exactly the problem
we're encountering in our production environment.

As you mentioned, memory access is typically interleaved between channels. When
the per-rank threshold is exceeded, soft-offlining the last accessed address
seems unreasonable - regardless of whether it's a 4KB page or a huge page. The
error accumulation happens at the rank level, but the action is taken on a
specific page that happened to trigger the threshold, which doesn't address the
underlying issue.

I'm curious about the intended use case for the CPER_SEC_ERROR_THRESHOLD_EXCEEDED
flag. What scenario was Intel BIOS expecting the OS to handle when this flag is set?
Is there a specific interpretation of "threshold exceeded" that would make
page-level offline action meaningful? If not, how about disabling soft offline from
GHES and leave that to userspace tools like rasdaemon (mcelog) ?

 >>
 >> Hi Tony,
 >>
 >> This is exactly the problem I encountered [1], and I agree with Jane
 >> that disabling soft offline via /proc/sys/vm/enable_soft_offline
 >> should work for your case.
 >>
 >> [1] https://lore.kernel.org/all/20240628205958.2845610-3-jiaqiyan@google.com/T/#me8ff6bc901037e853d61d85d96aa3642cbd93b86
 >
 > If that doesn't work for your case, I just want to mention that hugepages might
 > still be soft offlined with that check in ghes_handle_memory_failure().
 >
 >>>>
 >>>> On the other hand, taking a huge page offline will have significant
 >>>> impact (and still not solve any problems).
 >>>>
 >>>> Check if the GHES record refers to a huge page. Skip the offline
 >>>> process if the page is huge.
 >
 > AFAICT, we're still notifying the MCE decoder chain and CEC will soft offline
 > the hugepage once the "action threshold" is reached.
 >
 > This could be moved to soft_offline_page(). That would prevent other sources
 > (/sys/devices/system/memory/soft_offline_page, CEC, etc.) from being able to
 > soft offline hugepages, not just GHES.
 >
 >>>> Reported-by: Shawn Fan <shawn.fan@intel.com>
 >>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
 >>>> ---
 >>>>
 >>>> Change since v2:
 >>>>
 >>>> Me: Add sanity check on the address (pfn) that BIOS provided. It might
 >>>> be in some reserved area that doesn't have a "struct page" which would
 >>>> likely result in an OOPs if fed to pfn_folio().
 >>>>
 >>>> The original code relied on sanity check of the pfn received from the
 >>>> BIOS when this eventually feeds into memory_failure(). That used to
 >>>> result in:
 >>>>        pr_err("%#lx: memory outside kernel control\n", pfn);
 >>>> which won't happen with this change, since memory_failure is not
 >>>> called. Was that a useful message? A Google search mostly shows
 >>>> references to the code. There are few instances of people reporting
 >>>> they saw this message.
 >>>>
 >>>>
 >>>>    drivers/acpi/apei/ghes.c | 13 +++++++++++--
 >>>>    1 file changed, 11 insertions(+), 2 deletions(-)
 >>>>
 >>>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
 >>>> index a0d54993edb3..c2fc1196438c 100644
 >>>> --- a/drivers/acpi/apei/ghes.c
 >>>> +++ b/drivers/acpi/apei/ghes.c
 >>>> @@ -540,8 +540,17 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 >>>>
 >>>>        /* iff following two events can be handled properly by now */
 >>>>        if (sec_sev == GHES_SEV_CORRECTED &&
 >>>> -         (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
 >>>> -             flags = MF_SOFT_OFFLINE;
 >>>> +         (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
 >>>> +             unsigned long pfn = PHYS_PFN(mem_err->physical_addr);
 >>>> +
 >>>> +             if (pfn_valid(pfn)) {
 >>>> +                     struct folio *folio = pfn_folio(pfn);
 >>>> +
 >>>> +                     /* Only try to offline non-huge pages */
 >>>> +                     if (!folio_test_hugetlb(folio))
 >>>> +                             flags = MF_SOFT_OFFLINE;
 >>>> +             }
 >>>> +     }
 >>>>        if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
 >>>>                flags = sync ? MF_ACTION_REQUIRED : 0;
 >>>>
 >>>
 >>> So the issue is the result of inaccurate MCA record about per rank CE
 >>> threshold being crossed. If OS offline the indicted page, it might be
 >>> signaled to offline another 4K page in the same rank upon access.
 >>>
 >>> Both MCA and offline-op are performance hitter, and as argued by this
 >>> patch, offline doesn't help except loosing a already corrected page.
 >>>
 >>> Here we choose to bypass hugetlb page simply because it's huge.  Is it
 >>> possible to argue that because the page is huge, it's less likely to get
 >>> another MCA on another page from the same rank?
 >>>
 >>> A while back this patch
 >>> 56374430c5dfc mm/memory-failure: userspace controls soft-offlining pages
 >>> has provided userspace control over whether to soft offline, could it be
 >>> a more preferable option?
 >
 > Optionally, a 3rd setting could be added to /proc/sys/vm/enable_soft_offline:
 >
 > 0: Soft offline is disabled.
 > 1: Soft offline is enabled for normal pages (skip hugepages).
 > 2: Soft offline is enabled for normal pages and hugepages.
 >

I prefer having soft-offline fully controlled by userspace, especially
for DPDK-style applications. These applications use hugepage mappings and maintain
their own VA-to-PA mappings. When the kernel migrates a hugepage to a new physical
page during soft-offline, DPDK continues accessing the old physical address,
leading to data corruption or access errors.

For such use cases, the application needs to be aware of and handle memory errors
itself. The kernel performing automatic page migration breaks the assumptions these
applications make about stable physical addresses.
Thanks.
Shuai

