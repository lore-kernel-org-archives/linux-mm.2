Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D05C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46836B0099; Mon, 14 Sep 2026 05:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0CD6B009B; Mon, 14 Sep 2026 05:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0816B009D; Mon, 14 Sep 2026 05:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99D4E6B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:46:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CEEA1601B7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:46:09 +0000 (UTC)
X-FDA: 85211886858.25.C0751C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7757780006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:46:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lByBiBS5;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789379167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKRrOy7tbwvzlXx8P1r3kZeDknPM56bdaGruTZ5Yf0U=;
	b=q9gKp7VEQMqy0D/LUMl2JnXu4br4SFJrvILbxhVSlmSVooHtlaAsRbx8aJlAckdo9Wk0sd
	GHV4TGTb8xj8i0oaz5/nlz+EBvZpxC7OEOpgLeRo6eF9PIohuGYd/PEzYUY+N5Wc4441Og
	MX8yGfX92vEIzA2QyUO0cnwIo8j8BFc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lByBiBS5;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789379167;
	b=mwnvopAhuw8CXbxkeTw0ghwOWAnpR3KdP/rH2ani+z9+RRcxRJyYojB3sSL7YCbpXCqQd5
	7msm3UvO16/+pQ+9kwU2DSe6+M5GsEqINk1OgSCzCiiwsqLcpPJ64Bzi2Vru2ucVThHqQr
	Cs0YQSoX7lhbx9GEb5Bmslm/qbeiR+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19DB0601DB;
	Mon, 14 Sep 2026 09:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562DC1F00893;
	Mon, 14 Sep 2026 09:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789379166;
	bh=NKRrOy7tbwvzlXx8P1r3kZeDknPM56bdaGruTZ5Yf0U=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=lByBiBS5exlTNY8E5U3nWhjR0DH3wzJKzpcDwuNhKi0vt3+3lFsf8aLxuC/4i0e4G
	 d4DQYJzaM0B4ZWSDO3H954E80KqDFcwlSqHU1zrE1rbaIZ0R4PGfNubDSKMbPVWsex
	 2mifhLkrYxt839BjAsk0hPi7h/OYLYxft4ARIIyOSJQY1Hays/3Xu6lJ9eI8CnRTgX
	 J9VjCigVIh2yvvl6P7xJMMddyeLE5/4kUosHkk3UWBUrwzQD60Kk7lrEQdtWy+UK12
	 dEYI4ktxxbsvD5+EaawtC/hQGisx7QjisQ87yxKxu2tvPNfPyLOv6NfAYIN2cfXDoy
	 tRbmsj2lPLUhA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/12] mm/sparse: rename __highest_present_section_nr
 to __highest_used_section_nr
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-6-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-6-008fc8d579fe@kernel.org>
Date: Mon, 14 Sep 2026 12:45:42 +0300
Message-Id: <178937914266.4188640.6188797346240816067.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: n65usgxwzbs89m79whm351n3cx9xswj4
X-Rspamd-Queue-Id: 7757780006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789379167-955799
X-HE-Meta: U2FsdGVkX19gKRTkBt9/DO1AZOCaMHC5JEFjENcdEcz6QmjpW+/qzJvi7v5p7qJ9Nw/yMU7bWtKxr7l4wQFjNOxDPP/705qUXRyGlWKmVZYgpq5j3Me+tU/HAriWPJ630oYdKlhRCy04Ty7K5Tk34nU7kcaDsoNTdEHgSNL+Heb/dDZl4AlkOk0iNUKC2QGPa/XQEvx1jbKm2RKLk2NATJwN9G3L+7Y6wYzj901EgBbrRg8IszSsQih6oiU/rYmvTQyMwUJhL/RIraD9F3RP57g/0yGr+rVx3fUlDSxIUvKpnoJRwwUIrDnSTUDjnMZo+bOB+W43AyLsxa7nrMF28z8XiBaGAMND9vx73Y66E+1PbMWUQAPhDZAlDMiPe0iwN/Aj2LaKatCczKsOPHxBHIExOMVnWO14c8v11dnwdMCJEyaJuTYglcplpJqVYPDU8BgJUUaVqMVrMDcJ0KI4A0d7k6d+iGEWuITr9APpDLv2TM3Pi41BL5bGap3dRgW4RcGTnrpbrHp4khk+w1J0n+p80bgtWRLtfQjOTXjtmc8oQjfx7nmcgwnqm/eAatCpwBfk8Fxzb+DpJCSYw/qOZPP6BuCYOkbqKAWOkyYrQ83PaXnlKx11YeTpq59+lec3/rsO0S2te+fz2RtA0jDyoMCLJKND5XiNPhkwz1t1eiS3aRj/q8ty78Mfrd17LGee8hxDlvmCP9NQaWqWcfAear+xQVD7uQb7cr1esCVhf1TtYpbJ+5nBSJRTPQFxGRXjp+lmE+1yWtvVJ+E6FugAmkos0f52utyBCsWQJeVKuN7pxwaurLuRh4K985WzL+zHgErOaZIiqs9iLejVsTVwW7+n58FgizOpO/9WiRv6Ko0W3XQxJ5oIcM7XDi40dsH4XyH+oYCVwEM330Sh/tmomIS3vYiX+r6lmsnkgAc9QgJXmP3ZdKAYtyeLLXN1WmA59yeN1sC4p71ox8uTonG
 yYxPs9YY
 d7J+eUg8maX761CXGwAyNhS4NWpSPwLvpH9ryjj8D/6s1xueEhzHQkPLAv4JBQ9zEO1bi0tGjfrLZ//vaVhmOcyukiat/dBQd8NnDGpDcqK1GCTElLqLD8hLGtKCLB4/0c/c/nzaZfqqjRIwLMJqgA8tLaloBYTA2y3Vow6eRVw7wMfY07UpXSQ+uI6MhjCb55/xYoK19OGosBrSPt6eOrfyVvBbcfwitpPEhyu40K1sjy/xxE6b1GuiDMS7cECfPaiKX1AB2+q3XAJfdCKafI4ZEquQzz92415PF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> In preparation for getting rid of SECTION_MARKED_PRESENT, rename
> __highest_present_section_nr and clarify the comment.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c9ae7991a8b20..19296e8ef44f8 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2170,7 +2170,7 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
>  	return __nr_to_section(pfn_to_section_nr(pfn));
>  }
>  
> -extern unsigned long __highest_present_section_nr;
> +extern unsigned long __highest_used_section_nr;
>  
>  static inline int subsection_map_index(unsigned long pfn)
>  {
> @@ -2269,7 +2269,7 @@ static inline unsigned long first_valid_pfn(unsigned long pfn, unsigned long end
>  
>  	rcu_read_lock_sched();
>  
> -	while (nr <= __highest_present_section_nr && pfn < end_pfn) {
> +	while (nr <= __highest_used_section_nr && pfn < end_pfn) {
>  		struct mem_section *ms = __pfn_to_section(pfn);
>  
>  		if (valid_section(ms) &&
> @@ -2324,7 +2324,7 @@ static inline int pfn_in_present_section(unsigned long pfn)
>  
>  static inline unsigned long next_present_section_nr(unsigned long section_nr)
>  {
> -	while (++section_nr <= __highest_present_section_nr) {
> +	while (++section_nr <= __highest_used_section_nr) {
>  		if (present_section_nr(section_nr))
>  			return section_nr;
>  	}
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 4994e200bbecd..f1b2060eb2016 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -216,7 +216,7 @@ static unsigned long skip_offline_sections(unsigned long start_pfn)
>  	if (online_section_nr(start_nr))
>  		return 0;
>  
> -	while (++start_nr <= __highest_present_section_nr) {
> +	while (++start_nr <= __highest_used_section_nr) {
>  		if (online_section_nr(start_nr))
>  			return section_nr_to_pfn(start_nr);
>  	}
> diff --git a/mm/sparse.c b/mm/sparse.c
> index f84bfceb53060..2b41ae36f20b8 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -164,15 +164,11 @@ static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
>  }
>  
>  /*
> - * There are a number of times that we loop over NR_MEM_SECTIONS,
> - * looking for section_present() on each.  But, when we have very
> - * large physical address spaces, NR_MEM_SECTIONS can also be
> - * very large which makes the loops quite long.
> - *
> - * Keeping track of this gives us an easy way to break out of
> - * those loops early.
> + * Looping over all memory sections is expensive, especially if NR_MEM_SECTIONS

... all possible ... maybe?

> + * is large but only a fraction is actually used. Keep track of the highest
> + * section number we ever used.
>   */
> -unsigned long __highest_present_section_nr;
> +unsigned long __highest_used_section_nr;
>  
>  static inline unsigned long first_present_section_nr(void)
>  {
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 744ae29002f5e..7c5d82ceb7142 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -114,8 +114,8 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  static inline void __section_mark_present(struct mem_section *ms,
>  		unsigned long section_nr)
>  {
> -	if (section_nr > __highest_present_section_nr)
> -		__highest_present_section_nr = section_nr;
> +	if (section_nr > __highest_used_section_nr)
> +		__highest_used_section_nr = section_nr;
>  
>  	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>  }

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


