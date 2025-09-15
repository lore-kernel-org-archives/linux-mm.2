Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 284B2CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0568E0005; Mon, 15 Sep 2025 05:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597438E0001; Mon, 15 Sep 2025 05:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC608E0005; Mon, 15 Sep 2025 05:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 370978E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:39:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E593A1A0527
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:39:36 +0000 (UTC)
X-FDA: 83890987152.23.37FDD44
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id E393AA0011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:39:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="F Lk+a5T";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NvuyJDds;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757929175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZlJhY6MXpuBEX5SLYlKiH+Oy4vfYCu8Tyo+hYoFesM=;
	b=O17+k7Y0fyBfyJP10AkIy+fpBMhNwn6sOmHyNcesPmjmDO3eH+aIj1sj+j6Q+Rjm8nUaQJ
	uz5kbwyUYm2HdO4PRfTpcUxicchYKTNCAEjlVNrpJJ5uxp7M+8H61hFKMKcjX8wl203lUq
	rnBW0MeJN/1E+SKgCArPLDX8q5aXghs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="F Lk+a5T";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=NvuyJDds;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757929175; a=rsa-sha256;
	cv=none;
	b=k2vXKh6T5YgeyF59ttEmD0pS5xVH7RUvbsYXdwenUU/GLJNrA1pjZRvX4t54dE6m3vNZJE
	VDw2JYqRY8ddwmer+ZN7yhkNMt+O/QHwk4ns+YqxVVoZz11Mj4Stg7GJNIhlA9MyG3wor2
	w1hpc/6TxnPs8yubTKojgkjyPTxAcEU=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 4016D1D00153;
	Mon, 15 Sep 2025 05:39:33 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Mon, 15 Sep 2025 05:39:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1757929173; x=
	1758015573; bh=ZZlJhY6MXpuBEX5SLYlKiH+Oy4vfYCu8Tyo+hYoFesM=; b=F
	Lk+a5TEgMrF88/pcSh2hKD0MvzLy61AXSGlZ5/LjDlW9ZJc4D+bqa4xP4/l54wno
	3eF/roeO1O4SLWeaiRE7Hz1wQafMh8lP1musx0ICKrqW4dgd6CDq2eZTBXB+QMkJ
	PIU4EQchgqSTQqX4ARHwvpI5tlaaz85DjzlBJ+9WBVyyhcZyHYCmI8LuwhcrgOs4
	LxjJvadTlEssUhcdvyh1x+VISkgQsbMAHzLEN2g3qPl8X9DKeQwZ0Mbo5nTb21SP
	/kWYHq9F/95jfKAlT7waqf6oeM5HZw91/npa7bnUcmzdzfSDbCpSjdC1PPIwioW8
	IUD0Sa5X46CCErIzxeQBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757929173; x=1758015573; bh=ZZlJhY6MXpuBEX5SLYlKiH+Oy4vfYCu8Tyo
	+hYoFesM=; b=NvuyJDdsxZMWLFRNHICBrZIdbnX+DuudQa+sqB6ZoQQj7LQKS2H
	SHvxjShZpvm19N7VpwAnuuSqzV/bbsTryTv+9qjMYa/j/m1LnmlGpgoL2g1GV37/
	Vdd9zo83/qfHfZMR93bcLoFi2tVZBCghjpabE8uQu+cc20/ZKv6k50Ei/yY/ZXe1
	/8EDPoPUPSYjUQwDiRxRtsj13rqohk8Mj2l6IlktfbhnTe0TzSwoQUE0YhvWvyuv
	7604eUvxiDavjLxNBS9NKsTOrH4KH3LlWpExBcq+o9Fu6wHvlrqmCM4NJ8b49ge6
	wsrP0oBbpQXz3b9CBVKBJSML+H0+5jZYBjw==
X-ME-Sender: <xms:097HaFqJkdjXDEoVKGnuedlviN8ZU8r0hxLwN_0TiRe-y4ckAQWZ8g>
    <xme:097HaKB9yIWPPY3dROpEv4fUEHf07EgI1PPoGoFs5hLIdNjq55G6ngojdAH8yKvLV
    E-iM_likCUymSsA3OA>
X-ME-Received: <xmr:097HaLc-TqAyN__3SB_jyQGxPvua-sv0GVB79B187BOgEt9YKdXloo-xQz7mNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdefjeefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrihgthhgrrhgurdifvghihigrnh
    hgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprh
    gtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgt
    phhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfi
    grnhhgsehlihhnuhigrdgrlhhisggrsggrrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehnphgrtghhvgesrhgvug
    hhrghtrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhm
X-ME-Proxy: <xmx:097HaEDJHZwLGytJJ41aiPf7YuzOzZ0wuQaAlqWWGtKm33h7siqcXQ>
    <xmx:097HaHQ58YO0pbyNcVXZwC8oryrE1lZC_pG75i7tNyMS2PPgJ7hi_w>
    <xmx:097HaAfeCKRjo4m-QL7fQEqogV5nGJ7KyIvXxd8oFOWJr_MtuK3brA>
    <xmx:097HaCppU9WLs2zLh_C6QgEaSRfRI3YFESpiy4IXB-N59PDbIgNr9w>
    <xmx:1d7HaLHbsOcuOoEc8o_b-DNNkEsxfra4T1M12Tb8Smph5-3yycuUFlV9>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Sep 2025 05:39:31 -0400 (EDT)
Date: Mon, 15 Sep 2025 10:39:28 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <ncyl7ryvmvzz5ndycb322nxknyruyouzxgemzgqroopp6nkuho@dugqpe3ij4ad>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250914000026.17986-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: E393AA0011
X-Stat-Signature: 41hdqne6przkwa1p8ixwog3zjjba7kg9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757929174-411884
X-HE-Meta: U2FsdGVkX1/uXFWZfNSL+X2LuTFfYsgZB4gYylmah46qoBWaLGtWiGE2C10a6bdYUK8TPjOgC20gG3yZn6Fd9ToOe+etBPPTV+JYmtuHd4Me9rl94ujBPPMWjiaT/yKZVV+dCJFvPHF7PIqi+aTUeG4d6YePC/CtRbQB8/FuhkduhP/pGi6K3AKe1/E/prE5E0u9BxmkIQEVCuh3bwMPUcE1DW94alMf9WoWlkDMI1+6BcqrcOYF9Q02SgCFTXhl33CKON/48HsHnTsQyRMHJ2TrED1QdYrzRv6CFUs+BxYGJcHS1/h+GECL/iqcFdVb1mZ0ej395JHTSsjsWE6Q0PMEAl8wDS8IeU2u5JbDNcUyLhp9G55Km2qYnLG+7T2JuVMVcDy6+Q4g6692e4NOfmltd1z2qhU4rBnfa7UJLiwrJ0FY2l5k7rHlKXzxXGM4JoY7TmwTmwjp+YapefBNrhqgMl6Xh0BwWyixUwqcCSE25ptVGRDeo5uuZ5RJfPKNX33RooaBEd/QmiGGp3NUaHK8dlU0ywrKnJcrF2zOdnJMl0Xi6ikSzfoESA3EMz+5eLiTyfdGR21KOEy+Rl5Zct+/CiUtBjanBpMueQLpRF711zD9NUzSU0alhy3LZIU87IX8muNYBvv6T1ni063ymHt+9d+vdmwiiQmjyP9ODPZYibN6Dn+htzWBUTFPcEIG2x0x5hV7momsSDc/GMJqzKUSNOTuodviSF0TWJfLpcn1dFGvOkjZjuq6wf2wAwJp0HsEbSGF17akFAT2rnIFlbSwBb72EnBIdfRGLF5LT74dOrWxqNxA51oSgYJ9Z6COSgBYfg030JcJhmE3nJ6Dc2EvFn6MpJcphAfaBKzzjX5F1F4T9oQlJZZtIoqKB71xYqVwbcZJDXQgo1oezoa4+W/G7U8W35vr2/Z4jxcB9Dxs83V9L5quMtM+oAHwp3cQpeIHwKCD1lC5v7rI/fb
 EI07dnab
 xeXCek0pn1hub/g8MyJI0DqLzEjnSefFJyPJ9lLM0QONoC0XAi5DFh/wD2M3tEKUuKi5Q3T62X8dAOBXa9DBQpcaeqUbkIkNdRcDbaMF59QQKk9D4RzTXdeo2uqzfRRDB/SEp0wEELZ9sm30xw5W594zGXwb87ecQLg+GTSqG4tP9fBYKD/wMDjDRyTXfXg7xvrWtUEtMVYu9vshB2KHcRlyuC6bAi3aJ+Q8WTDJVpW93i+uOrfUdw7RXtMn5ILFWj17eR+8k/RXhmP29XTADFXVMcFLNJ1fR1ZtK26p+vApNPBEXSpIQbaWeACb891a3eGavA4X9z1Z+U9qYg2j7VO0S/QDfkxsAjUc4GGjgQEUKuZ8rLMHXAueNcEQ2Mot0uFAY538Iw2CXSpdoXBtfCVk1q81UfbmkAhTiyaDE8frATPqNhRipnmjgsTKqVmI5qo7M9aWkFJHnmdpxsD5DoKZTRKjVT88nW2SvnSa9z1PESEskg1qoAwlPwarXjI6aRQ58GnOEmh+86NJnveUuLQH3Swo17ZrK80GG60ycKwv0Wf/p04mykObJZK75vo3UF4CbCv08hcGMbw3q2SCDBGTqpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 12:00:26AM +0000, Wei Yang wrote:
> When using mm_slot in ksm/khugepaged, there is code snip like:
> 
> 	slot = mm_slot_lookup(mm_slots_hash, mm);
> 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> 	if (mm_slot && ..) {
> 	}
> 
> This is only valid when mm_slot is the first element of its wrapper
> structure, otherwise a NULL slot would converted to a mm_slot with
> negative value. And current code thinks it is valid and continue.
> 
> Current code works since mm_slot is the first element, but make sure it
> won't be disturbed.

Seems excessive for this kind of problem.

Why not check slot in mm_slot_entry?

diff --git a/mm/mm_slot.h b/mm/mm_slot.h
index 83f18ed1c4bd..0de24c490b62 100644
--- a/mm/mm_slot.h
+++ b/mm/mm_slot.h
@@ -19,7 +19,7 @@ struct mm_slot {
 };

 #define mm_slot_entry(ptr, type, member) \
-	container_of(ptr, type, member)
+	(ptr ? container_of(ptr, type, member) : NULL)

 static inline void *mm_slot_alloc(struct kmem_cache *cache)
 {
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

