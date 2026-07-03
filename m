Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FCB0C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7396B018C; Thu,  2 Jul 2026 22:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978376B018F; Thu,  2 Jul 2026 22:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863CB6B0191; Thu,  2 Jul 2026 22:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3666B018C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:07:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C07F403B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:07:00 +0000 (UTC)
X-FDA: 84945827400.09.7EC9E69
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 79A1B180006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:06:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oqEYw4vS;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783044418;
	b=h8iBhiV1prnDU3Ea1QO5NdIn5M3SUzwkhq9N+yICNkYSdMvEDZFYiVAct18hjVSxF/4sBn
	BW2k+D2JFW8k5BspoyVrNUMeR1tcgt23UVdZoK1nsvHUhXxy3LGpwxhZv30epx4pOo4Yji
	0iHQ21N/nMRk4F5QMqeNrubB7u/fIYs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783044418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxCNSeDf4o6wf7efRsyXIuer0kCHRZDVpz10zBJVPFs=;
	b=ur1CcFXRaUCTQYJdV3yefxCkLSy6ImhwJcarWXQIcxtIKdimGbf9Tj4v7H3LHjrSn67jCT
	4F+SAO+uUxYLdnAeUJyFxpXSTduo7q7bnoNktrv+nQdfDMPPaFwqJ11VcwdQI2gFkASHEk
	Zbh3OJDY4L87grl+Qc33NN5f+26AOwU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oqEYw4vS;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso35693a12.2
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 19:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783044417; x=1783649217; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:content-type
         :message-id:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rxCNSeDf4o6wf7efRsyXIuer0kCHRZDVpz10zBJVPFs=;
        b=oqEYw4vSO1eNk/xlgHodWx/C1wBF7L1cE7nmIn+yH9KiEaLk4yhhXGA7eTipd6S5FN
         gOzbyQbBojvwOzPPDpTgHVYTrln6vZgV8j/Hirnop2dQ2HUrv176p7aQIEKFFmzgmRg+
         tpavFqysRkht8NgAqkpTgcF1dwoh7VYUL0RadYSt5Tg8F/q/R8y2ZWi6iq67bC/S5MIV
         kvUPAZ5tgdzUJlM9l9pDY/cJ+GYmjXNQVaJGt4nTJc/cF5Bj5S4xtJQSidVtksP7N1ki
         Z3c+kIruoIh1PwyIsfjUZ7s6+FR1eas4zv3aubOxbabCWhhQK59TaLhBM4Vg6jV2+cvY
         9aCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783044417; x=1783649217;
        h=references:to:cc:in-reply-to:date:subject:mime-version:content-type
         :message-id:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rxCNSeDf4o6wf7efRsyXIuer0kCHRZDVpz10zBJVPFs=;
        b=p5IRSpDMohaWMc6yzi5yeRFj6L+1G5p+EsdU6MLb4j2T+tgs+qsDXv/JNyyu6Wy1bX
         eWHrHmVsKf/nepoekcIPOCCXYbDbatDPWh98Z7+RsHSd8+jQLW86FdgAYvAh3PPTK054
         6irC1Tz4zdxCh7baz2I8XHbG/pNmkRczNWFAvhtSEqyLIpIv8S4lUzC8U6n2IdL4XdSp
         ST/+zSeocPlSYyJ7vLSZnetdNaLLOuAhkugCos0T+bhODQ4WcpWZNZbVqt68CEo16kAm
         KqqZsv0CneAZrdUtEPax17Mm/tIo5i82Gz6AZiq52CWq5q+qhd76wb13NysWRpqtseL5
         MGIg==
X-Forwarded-Encrypted: i=1; AFNElJ8+lL4D193ygeQU1JtVIPzqlAo0O+3Dml7UwKtY6tKGb8BIHD0Ec6MMQ5zB3Fu8D1NLQNxrgwxKsg==@kvack.org
X-Gm-Message-State: AOJu0YwcKXSZUqcjqqi5/wPexf6sN2W6LHXUmZwhk+UiMRykKcc8kK50
	XphlDtLgM9KQZaMlIWzpW5c8YQscOiBICG6uVS+WNxCuqm1WkqsrhVAS
X-Gm-Gg: AfdE7cncI1+HRpFNIReHyklilZBytvm9aq8CG7qrn10hPdu0X/yvY9Tqquft/uGvLVK
	AXXf/K8kEjwFdRchxRBgLoPW5g/oWpMrmR2eWep+8jHHRXBkRfqm4wM8Lw+bkLNQ894izxF9mQO
	ZAqDW85wPxr+i0clrn3FNKggJQwKquDBrfScRQ2I1OaeQm4xfgqqAtyZTpkkAjvuQXmsJftCAQ8
	bLH2hEF512fx7HGbqxJE1rSajE0uKR58+f/Bz1tgGOsHHEF5bQGkL1qKzkfyX6ckh2eO4Tmjamb
	nR+LXHvPCKxBXLYzIdcgML5NgCLUIICnqWH+UcZffSRefMqcPpyPMDZVxLArX47gd9FJ3mwLcoB
	YKfVMJkaWhe2MuDnuslfGciuxxVJ8QGiifFGJrqYwd6itMDD0TbtAnbNaRkhmgyNMzLZRuZI=
X-Received: by 2002:a05:6a21:e0a7:b0:3aa:f9cb:d438 with SMTP id adf61e73a8af0-3bff40ce501mr9127388637.21.1783044417039;
        Thu, 02 Jul 2026 19:06:57 -0700 (PDT)
Received: from smtpclient.apple ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c7fa65asm14312138c88.6.2026.07.02.19.06.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2026 19:06:56 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
Message-Id: <0024693E-CFBB-4924-86BB-641F54554C18@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_32F0C9EA-003F-4C51-805E-A97C9DC82B9A"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [RESEND RFC PATCH v2 2/5] mm/khugepaged: add
 damon_collapse_folio_range() for external callers
Date: Fri, 3 Jul 2026 10:06:37 +0800
In-Reply-To: <akZDj6s8U5_Mnetv@lucifer>
Cc: sj@kernel.org,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 daichaobing@sangfor.com.cn,
 kunwu.chan@gmail.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org
To: Lorenzo Stoakes <ljs@kernel.org>
References: <20260702094633.75658-1-lianux.mm@gmail.com>
 <20260702094633.75658-3-lianux.mm@gmail.com> <akZDj6s8U5_Mnetv@lucifer>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Stat-Signature: fy7zdf1zu1in5mmbe5uwxmyxj5sen73a
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79A1B180006
X-HE-Tag: 1783044418-567233
X-HE-Meta: U2FsdGVkX1+aOVWq6vrFCHLQ6Q47ht3fEpJOrfc0kAfB99ZGLjMRzwRKQ4utBqhSOBnugaEEk6731Btapf4dx8XScBlYh1DRMvf1WQZSrL22C7TJFGHQdEykt+nnjWPrqq+Zjra3gpvWWbw6XTuloagdfQJPLC7SqoPUedjzmErS1DsASOQ+XavWAKruTGpZlzyWmbL3S40XLzwRNJJjhEx2wcjPwHEwpK476X81sraj3b4ZkiW9R5vyyIbife/wfw1DH7WSEDodij+027krLOifB9LdSU0pnsEE+1I1iFGd8bX9FCjq9tJvobEOOrHA2o+180eOG16+PbntbjuUn2he1zFXbYZs104HvgweVGhpQBXg1DHuSYLLVus02A6iMHZInbgSV2fva/mwbgRGkdCMVEDVOWd/7cQ/UOkoVx0XdJRcEKTJ5Fir26EvWKrvrnsFQfQRMYFyiuuCUDIhsX6eHStIps4IlDoHh5gSJW8pt0DXgrxWfrjyNvBs6tNxXdyXoeglLmXr2E0EPzrKrmy2Q9JhtLCsabBClPAJojx16GxXtfUiAomahyapp9dATx9AVtmhnSSPG2xfWy3FvO1bJeGTXo6/n5t4IxnAXqBXL51tqQn7roSB9JTYhbS7dzlhZqivBDq4fdgTCKNAgdoZYK8JVq18+soFLm390U2tHrtHEaDsqwm6Al+SsQbJCYLWI4bQm+g1eTk0es6vc37fccB3+e83V0fat1dyMhGUO7hBYMpatDtpSmeGLkWAPnaKbQUOWG2GifKdEPkq2TK3Lt1pZl8zUDoJjDc+jmIHZpjz+GxF7+TF1LtMIELONhtDDUn+64iWxrOYkYsDYgTCgOQhJZsVz6sBdvAal0jpQMumyoDRd6yA7k+7Wh1EAj0Q7DUsILlJs0msWTxy3ei58TFF/BY8fXG1XN7t00T2Wihw4JNXEAGIzvWeaMhgcq1EzGA/R91aRCBCCf+
 JZPhZNN5
 Nj7BuHXrD6Vkqu2/eG6t7DcJOnGaB6CvyMJlk9cu5ty+19xicR0QLPXTZh26zOnja5FIoDNoWAO/LBuSNFyqoJE5CCKg3tRGcHA2FKP9sq0AI3zafTltwXSGYVVNSXJdmlRsRjxcdiu23hAlIRTF3AOUoBPquT3E81SfvwdrLjzG95jBNrUHOD+o6Lzxvckdz6mjWCzFQlj8VQYqlptY1h3hPSYxVeOkf8KkKX6AFavKfBjrg8HAzsOevVa8gDU2+PlUAQr5s2ZzcYADeH2YUGU/68y3Vs0IiYCir4NNm4GPk2X1xqpSkNYcoFfQVHIxKpVQRkP2jplXGPaDXgyAtk9DDjduigDQ/CAN0nrT2YY7A/BzKtoE2zgxVPYuMIgPwuf4u1qWrtfksM3NmM5uqqH0FbwEu9DzjHjRPMnyOIycLQWZ/EbJGGao+B4X7Zu4y8c9vtPMbBUEqMp0wPgZMjkkXGQkVmrTSQfXNanznev871Sa6NBJVxYJwPC8mTRMexfeULMVQ79T8alzhASyj3cbD5cHXU6Ybi2bvbksF/y7DffXGyNVCSFypqbisocHh4U9KK+FIczVIAHqbOz79S80Pg17v0amhAczvYVGQc+V6xXYhzs/6iIl/A194TaYThhPmWPhGynw9YyOq7NXLwtopJUzOE1vZExrtEiFeDaneVZFz9iYhHVstF/qLQOaP6fccAXM6WQzRncTHOqGzA+q6KkjJFH7Qe492PrGKGm9v4oaQymExUz8ViNv+pHq4gVqmzi4MLM5uDOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_32F0C9EA-003F-4C51-805E-A97C9DC82B9A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi Lorenzo,

> On Jul 2, 2026, at 19:07, Lorenzo Stoakes <ljs@kernel.org> wrote:
>=20
> (+cc missing people again)
>=20
> Sorry but we're not going to accept anything that exports THP logic =
like this at
> all.
>=20
> And a damon wrapper in core mm code is just a non-starter, so you =
really need to
> rethink your approach.
>=20
> I think SJ already commented on this in your v1 from what I can see? =
I'd listen
> to his advice on this :)
>=20
> On Thu, Jul 02, 2026 at 05:46:30PM +0800, Lian Wang wrote:
>> Export a thin wrapper around collapse_huge_page() that allows =
external
>> subsystems such as DAMON to trigger THP collapse on a target address
>> range.
>>=20
>> Currently restricted to PMD order (HPAGE_PMD_ORDER), since
>> collapse_huge_page() does not yet support arbitrary mTHP orders.
>> The restriction can be relaxed when khugepaged gains mTHP support.
>>=20
>> The caller must hold a reference to @mm.  Do not hold mmap lock:
>> collapse_huge_page() acquires mmap_read_lock for validation, releases
>> it, then acquires mmap_write_lock for the actual collapse.  Holding
>> an outer mmap_read_lock would cause a self-deadlock when the same
>> thread attempts the inner mmap_write_lock.
>>=20
>> Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
>> Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
>> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
>> Signed-off-by: Lian Wang <lianux.wang@processmission.com>
>=20
> This patch is exporting internal mm logic without proper safeguards so =
it's just
> not something we're going to accept, sorry.
>=20
> (Also not sure it's correct to have multiple S-o-b for the same person =
(unless
> re-tagging a backport or something)? I'm not sure though)
>=20
>> ---
>> include/linux/khugepaged.h |  9 ++++++++
>> mm/khugepaged.c            | 46 =
++++++++++++++++++++++++++++++++++++++
>> 2 files changed, 55 insertions(+)
>>=20
>> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
>> index d7a9053ff4fe..f7d49cba712f 100644
>> --- a/include/linux/khugepaged.h
>> +++ b/include/linux/khugepaged.h
>> @@ -20,6 +20,9 @@ extern bool current_is_khugepaged(void);
>> void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long =
addr,
>> 		bool install_pmd);
>>=20
>> +int damon_collapse_folio_range(struct mm_struct *mm, unsigned long =
start_addr,
>> +			       unsigned int target_order);
>=20
> No thanks. We're not putting damon wrappers into core code. This is =
breaking the
> abstraction and letting arbitrary users invoke internal mm logic.
>=20
> Plus you're literally exporting this so it can be abused by drivers.
>=20
>> +
>> static inline void khugepaged_fork(struct mm_struct *mm, struct =
mm_struct *oldmm)
>> {
>> 	if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm))
>> @@ -47,6 +50,12 @@ static inline void collapse_pte_mapped_thp(struct =
mm_struct *mm,
>> {
>> }
>>=20
>> +static inline int damon_collapse_folio_range(struct mm_struct *mm,
>> +		unsigned long start_addr, unsigned int target_order)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> static inline void khugepaged_min_free_kbytes_update(void)
>> {
>> }
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 617bca76db49..7fe9ce1e0533 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -3272,3 +3272,49 @@ int madvise_collapse(struct vm_area_struct =
*vma, unsigned long start,
>> 	return thps =3D=3D ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
>> 			: madvise_collapse_errno(last_fail);
>> }
>> +
>> +/**
>> + * damon_collapse_folio_range() - Collapse base pages in range into =
a THP
>> + * @mm:         mm_struct of the target process
>> + * @start_addr: start address (must be order-aligned)
>> + * @target_order: page order of the collapse result (currently only
>> + *                HPAGE_PMD_ORDER is supported)
>> + *
>> + * Thin wrapper around collapse_huge_page() for external callers =
such as
>> + * DAMON.  The caller must hold a reference to @mm.  Do not hold =
mmap
>=20
> This is really fragile and bug bait.
>=20
>> + * lock: collapse_huge_page() acquires mmap_read_lock for =
validation,
>=20
> This is just gross, you're now collapsing based on an outdated concept =
of
> what the current VMA state is...
>=20
> You're also losing literally everything that madvise_collapse() does.
>=20
> AND you're overriding THP limitations like max_ptes_none, which is =
horrible...
>=20
>> + * releases it, then acquires mmap_write_lock for the collapse.  =
Holding
>> + * an outer mmap_read_lock would self-deadlock.
>=20
> This is a sign the interface is wrong!
>=20
>> + *
>> + * Return: 0 on success, -EINVAL on bad arguments, negative error =
from
>> + *         madvise_collapse_errno() otherwise.
>> + */
>> +int damon_collapse_folio_range(struct mm_struct *mm, unsigned long =
start_addr,
>> +			       unsigned int target_order)
>> +{
>> +	struct collapse_control *cc;
>> +	enum scan_result result;
>> +
>> +	if (target_order !=3D HPAGE_PMD_ORDER) {
>> +		pr_warn_once("%s: only PMD order (%u) is supported, got =
%u\n",
>> +			     __func__, HPAGE_PMD_ORDER, target_order);
>> +		return -EINVAL;
>> +	}
>> +	if (start_addr & ((PAGE_SIZE << target_order) - 1))
>> +		return -EINVAL;
>> +
>> +	cc =3D kmalloc_obj(*cc);
>> +	if (!cc)
>> +		return -ENOMEM;
>> +	cc->is_khugepaged =3D false;
>> +	cc->progress =3D 0;
>> +
>> +	lru_add_drain_all();
>=20
> This is quite literally a copy/paste from madvise_collapse(). No no no =
:) code
> duplication like this is also unacceptable.
>=20
>> +
>> +	result =3D collapse_huge_page(mm, start_addr, 1, 0, cc, =
target_order);
>> +	kfree(cc);
>> +	if (result =3D=3D SCAN_SUCCEED || result =3D=3D SCAN_PMD_MAPPED)
>> +		return 0;
>> +	return madvise_collapse_errno(result);
>> +}
>> +EXPORT_SYMBOL_GPL(damon_collapse_folio_range);
>=20
> We _definitely_ cannot have internal mm logic _exported_.
>=20
> Yeah sorry you need to rethink this.
>=20
Thank you for the incredibly candid and sharp review.  You are
completely right, and I apologize for my rashness.

My initial motivation was purely focused on solving a pressing
production issue we encountered, but in my eagerness, I rushed
into the implementation without respecting the structural
boundaries of the core MM code.  Bypassing the proper mmap_lock
state checks, duplicating the madvise validation logic, and
blindly exporting internal MM machinery via EXPORT_SYMBOL_GPL
creates fragile bug bait.  It was reckless of me, and I feel I
have let down the valuable time and enthusiasm you and SJ
invested in reviewing this work.

I will completely withdraw this design, step back, and
fundamentally rethink how to achieve this functionality
gracefully within proper subsystem boundaries.

Please give me some time to restructure this into a safe and
elegant design.  In the meantime, I want to channel this energy
into doing something genuinely useful for you and the community.
I will take on the development of the patch pre-flight check bot
we discussed to automate the verification of CC lists based on
scripts/get_maintainer.pl.  I hope this tool can help save your
valuable time and prevent other newcomers from repeating my
exact blunders.

Thank you again for your patience and for steering me back onto
the right path.

Best regards,
Wang Lian
> Thanks, Lorenzo


--Apple-Mail=_32F0C9EA-003F-4C51-805E-A97C9DC82B9A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;">Hi Lorenzo,<br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Jul 2, 2026, at 19:07, Lorenzo Stoakes =
&lt;ljs@kernel.org&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">(+cc missing people again)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Sorry but we're not going to accept =
anything that exports THP logic like this at</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">all.</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">And a damon wrapper in core mm code is just =
a non-starter, so you really need to</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">rethink your approach.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">I think SJ already commented on this in =
your v1 from what I can see? I'd listen</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">to his advice on this :)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">On Thu, Jul 02, 2026 at 05:46:30PM +0800, =
Lian Wang wrote:</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;">Export a thin wrapper around collapse_huge_page() that allows =
external<br>subsystems such as DAMON to trigger THP collapse on a target =
address<br>range.<br><br>Currently restricted to PMD order =
(HPAGE_PMD_ORDER), since<br>collapse_huge_page() does not yet support =
arbitrary mTHP orders.<br>The restriction can be relaxed when khugepaged =
gains mTHP support.<br><br>The caller must hold a reference to @mm. =
&nbsp;Do not hold mmap lock:<br>collapse_huge_page() acquires =
mmap_read_lock for validation, releases<br>it, then acquires =
mmap_write_lock for the actual collapse. &nbsp;Holding<br>an outer =
mmap_read_lock would cause a self-deadlock when the same<br>thread =
attempts the inner mmap_write_lock.<br><br>Co-developed-by: Kunwu Chan =
&lt;kunwu.chan@gmail.com&gt;<br>Signed-off-by: Kunwu Chan =
&lt;kunwu.chan@gmail.com&gt;<br>Signed-off-by: Lian Wang =
&lt;lianux.mm@gmail.com&gt;<br>Signed-off-by: Lian Wang =
&lt;lianux.wang@processmission.com&gt;<br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">This patch is exporting internal mm logic =
without proper safeguards so it's just</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">not something we're going to accept, =
sorry.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">(Also not sure it's correct to have =
multiple S-o-b for the same person (unless</span><br style=3D"caret-color:=
 rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">re-tagging a backport or something)? I'm =
not sure though)</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;">---<br>include/linux/khugepaged.h | &nbsp;9 =
++++++++<br>mm/khugepaged.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 46 =
++++++++++++++++++++++++++++++++++++++<br>2 files changed, 55 =
insertions(+)<br><br>diff --git a/include/linux/khugepaged.h =
b/include/linux/khugepaged.h<br>index d7a9053ff4fe..f7d49cba712f =
100644<br>--- a/include/linux/khugepaged.h<br>+++ =
b/include/linux/khugepaged.h<br>@@ -20,6 +20,9 @@ extern bool =
current_is_khugepaged(void);<br>void collapse_pte_mapped_thp(struct =
mm_struct *mm, unsigned long addr,<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>bool install_pmd);<br><br>+int =
damon_collapse_folio_range(struct mm_struct *mm, unsigned long =
start_addr,<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;unsigned int target_order);<br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">No thanks. We're not putting damon wrappers =
into core code. This is breaking the</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">abstraction and letting arbitrary users =
invoke internal mm logic.</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Plus you're literally exporting this so it =
can be abused by drivers.</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;">+<br>static inline void khugepaged_fork(struct mm_struct *mm, =
struct mm_struct *oldmm)<br>{<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if =
(mm_flags_test(MMF_VM_HUGEPAGE, oldmm))<br>@@ -47,6 +50,12 @@ static =
inline void collapse_pte_mapped_thp(struct mm_struct =
*mm,<br>{<br>}<br><br>+static inline int =
damon_collapse_folio_range(struct mm_struct *mm,<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>unsigned =
long start_addr, unsigned int target_order)<br>+{<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
-EINVAL;<br>+}<br>+<br>static inline void =
khugepaged_min_free_kbytes_update(void)<br>{<br>}<br>diff --git =
a/mm/khugepaged.c b/mm/khugepaged.c<br>index 617bca76db49..7fe9ce1e0533 =
100644<br>--- a/mm/khugepaged.c<br>+++ b/mm/khugepaged.c<br>@@ -3272,3 =
+3272,49 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned =
long start,<br><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return thps =3D=3D ((hend - hstart) &gt;&gt; =
HPAGE_PMD_SHIFT) ? 0<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>: =
madvise_collapse_errno(last_fail);<br>}<br>+<br>+/**<br>+ * =
damon_collapse_folio_range() - Collapse base pages in range into a =
THP<br>+ * @mm: =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mm_struct of the target =
process<br>+ * @start_addr: start address (must be order-aligned)<br>+ * =
@target_order: page order of the collapse result (currently only<br>+ * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;HPAGE_PMD_ORDER is supported)<br>+ *<br>+ * Thin wrapper =
around collapse_huge_page() for external callers such as<br>+ * DAMON. =
&nbsp;The caller must hold a reference to @mm. &nbsp;Do not hold =
mmap<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">This is really fragile and bug =
bait.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: solid;">+ =
* lock: collapse_huge_page() acquires mmap_read_lock for =
validation,<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">This is just gross, you're now collapsing =
based on an outdated concept of</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">what the current VMA state is...</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">You're also losing literally everything =
that madvise_collapse() does.</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">AND you're overriding THP limitations like =
max_ptes_none, which is horrible...</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: solid;">+ =
* releases it, then acquires mmap_write_lock for the collapse. =
&nbsp;Holding<br>+ * an outer mmap_read_lock would =
self-deadlock.<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">This is a sign the interface is =
wrong!</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: solid;">+ =
*<br>+ * Return: 0 on success, -EINVAL on bad arguments, negative error =
from<br>+ * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;madvise_collapse_errno() =
otherwise.<br>+ */<br>+int damon_collapse_folio_range(struct mm_struct =
*mm, unsigned long start_addr,<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;unsigned int target_order)<br>+{<br>+<span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	</span>struct collapse_control =
*cc;<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>enum scan_result result;<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (target_order !=3D =
HPAGE_PMD_ORDER) {<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>pr_warn_once("%s: only PMD order =
(%u) is supported, got %u\n",<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;__fun=
c__, HPAGE_PMD_ORDER, target_order);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return -EINVAL;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>}<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>if (start_addr &amp; ((PAGE_SIZE &lt;&lt; target_order) - =
1))<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>return -EINVAL;<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>cc =3D =
kmalloc_obj(*cc);<br>+<span class=3D"Apple-tab-span" style=3D"white-space:=
 pre;">	</span>if (!cc)<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return -ENOMEM;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>cc-&gt;is_khugepaged =3D false;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>cc-&gt;progress =3D =
0;<br>+<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>lru_add_drain_all();<br></blockquote><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">This is quite literally a copy/paste from =
madvise_collapse(). No no no :) code</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">duplication like this is also =
unacceptable.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;">+<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>result =3D collapse_huge_page(mm, start_addr, 1, 0, cc, =
target_order);<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>kfree(cc);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (result =3D=3D SCAN_SUCCEED || =
result =3D=3D SCAN_PMD_MAPPED)<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return 0;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
madvise_collapse_errno(result);<br>+}<br>+EXPORT_SYMBOL_GPL(damon_collapse=
_folio_range);<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">We _definitely_ cannot have internal mm =
logic _exported_.</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Yeah sorry you need to rethink =
this.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"></div></blockquote><div>Thank you for the incredibly candid and =
sharp review. &nbsp;You are</div><div>completely right, and I apologize =
for my rashness.</div><div><br></div><div>My initial motivation was =
purely focused on solving a pressing</div><div>production issue we =
encountered, but in my eagerness, I rushed</div><div>into the =
implementation without respecting the structural</div><div>boundaries of =
the core MM code. &nbsp;Bypassing the proper mmap_lock</div><div>state =
checks, duplicating the madvise validation logic, and</div><div>blindly =
exporting internal MM machinery via EXPORT_SYMBOL_GPL</div><div>creates =
fragile bug bait. &nbsp;It was reckless of me, and I feel =
I</div><div>have let down the valuable time and enthusiasm you and =
SJ</div><div>invested in reviewing this work.</div><div><br></div><div>I =
will completely withdraw this design, step back, =
and</div><div>fundamentally rethink how to achieve this =
functionality</div><div>gracefully within proper subsystem =
boundaries.</div><div><br></div><div>Please give me some time to =
restructure this into a safe and</div><div>elegant design. &nbsp;In the =
meantime, I want to channel this energy</div><div>into doing something =
genuinely useful for you and the community.</div><div>I will take on the =
development of the patch pre-flight check bot</div><div>we discussed to =
automate the verification of CC lists based =
on</div><div>scripts/get_maintainer.pl. &nbsp;I hope this tool can help =
save your</div><div>valuable time and prevent other newcomers from =
repeating my</div><div>exact blunders.</div><div><br></div><div>Thank =
you again for your patience and for steering me back onto</div><div>the =
right path.</div><div><br></div><div>Best regards,</div><div>Wang =
Lian</div><blockquote type=3D"cite"><div><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Thanks, =
Lorenzo</span></div></blockquote></div><br></body></html>=

--Apple-Mail=_32F0C9EA-003F-4C51-805E-A97C9DC82B9A--

