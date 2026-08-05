Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CDBAC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3330D6B007B; Wed,  5 Aug 2026 11:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCE86B0088; Wed,  5 Aug 2026 11:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1855A6B008A; Wed,  5 Aug 2026 11:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2BE66B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:54:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 677B91A0533
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:54:46 +0000 (UTC)
X-FDA: 85067663772.18.7C9A361
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7E6124000E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:54:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m3tMjbbj;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785945284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiDL1RzWS9KxGO4Do/pBrGufTQ4ZH9KDIw9xKfe1s38=;
	b=A3x4HxqVYgBEwlWijVqE0A+IZRd7FR9ewAWw19gvlRUbdqXSrnZ1B/WfioFUm3u5RgsjeP
	xU/piULbWhsg4eMZoxvebT99HOL0u4J+uoD5PvVmvWj+MciguvnovF5ISqB9NAMbhsHM57
	RHpJYTVANuB61SkheLXFg24geNsKq/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785945284;
	b=5Q363HRveOv95GywlwsdC8y1ZM/zdCGBAY9eXVCORHgBG6KaRvYKoPi3VjEdHwVzlAKX5n
	OcZfOT6/7yj5ug7S0VIEwEEo3i1FERfa2SjWHdvQWuv02oeN9uPE5Kp8O9uSB7svQ+oLpc
	I2awrQH0ld8yn4DmSAOo+/I8dRjjfSs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m3tMjbbj;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cea3004256so14920865ad.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785945283; x=1786550083; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SiDL1RzWS9KxGO4Do/pBrGufTQ4ZH9KDIw9xKfe1s38=;
        b=m3tMjbbjrMwifmlAPR+ljgRTeAhDEw9JfKD3ttcWtv4D7rnDtZCXroBNKQcZmgHM2p
         HSGGEwQfMLBP0l8LBpCQoyrPEiUYpniGyt9HbA8GbhwnBIXonmGLnIZY9kcCAwf2Tjw4
         UjjKolx2Nt8eeR7TbMGQvEVJhteUeGvlC3mCwUt728KPjABJMN6WhHV5aqkvbZv8romp
         8QLtqc4hjrg+D7eKv3vwFCQHVsNk+JKvwEHOj9iIxa6l+9y3E7VTnjgNerUOUke/8w3i
         +md6iu7Qv6LxO4hn3+BYKD0vfLeyjX2+35T+FkRs25c6xlUNIptL3B1WMng/TOKmxIP2
         Wknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785945283; x=1786550083;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SiDL1RzWS9KxGO4Do/pBrGufTQ4ZH9KDIw9xKfe1s38=;
        b=fhiJLjW+vZOuXnajLdTPKBesSThoNVkjHjze17B1OYPyqYqVv6r5KzpdqRMer3QdpY
         b7Plyqv8DRlcPNFJW96AajtIyg70JL1I4G93pEAQXYJXeOKslnQMIISxKKV41ggVbFBv
         CpWrM+oEG4LfbwafxFwnuOtIraOSHMJu20IchA7uwNE8XZik3ETe8DdrzEZJ0snL0KKi
         0EGopaEvsOIDXLzZybj/UYt4JL1E55xo5OU60+Fn811X4eXyUkBre8WbkAr7NxA/1McJ
         IPfpO1sS+nKFyCW0z4LCXfNHTRTonTvcosUaNWKcGpWVNCnzio/Xv+4Yia/Clgj0JUUq
         3TiQ==
X-Forwarded-Encrypted: i=1; AHgh+RrX3w/XCErIl3wfCSlGKCl6cU+2tmsix3o3645N6Mfr0eOCxvUDwNW+9pCb7oQY5bhQRe/S3QhkoA==@kvack.org
X-Gm-Message-State: AOJu0YyoFJrZgjbSNHWbguMEI7HZKf2OcyqigSUPbdOXQ8Uj7NbS142e
	c7fQS1Ow5b2UQvLo5hSTwBzr7xphbErBUu20Xp/2uQF5LwwhjFmAoSs5
X-Gm-Gg: AR+sD10XXvm1BwRZ57b2BIDvF0GEIzXTS29YUpb5wdNoAkG7GktaJs8HmEo7aPt+5d5
	5dXDQeS9GwlYrhtm52Z+dFUNcEo2r2yZNtcoKrkJ4eNlalbTIVJBCZwGMAsdbLh3P4ViGTYJaF8
	AifNe78f2hDvtKBvdtwT0qI+0CrZQV1CqdQycOZzxMySqZp3FiiJJvVubWA7MUDMvcc341KUEBJ
	dAs+v6fYflfe7CU5YFGQPLkybFtZTZUGJziEySAdkpYoigYjuO2KCQR7bVCQZZAyvOuZf3Qjj6b
	ZrVU+l6jyCQeUTka7c5zzzIG9MPJYyNXbIdrmoBnn8zPG9+R+pT+g7/Hrne53dDDBjLcOBE7TBg
	rqiM/PdTpeCzQxPBfUWWSrMCctFbLPlWWLMGobMM/6v/AzoAbfPEsAeNGZlJ4DqI9YEa1+5Eik6
	CSs1GKto7FtXbjIUbSrpKT/VSFA3nHFVpi9sF8HWUKN0+fLJszZh5tuWJPc+a/KdxDwHO8QCcPe
	a55DR5fjW1thEjx03rF0A2L
X-Received: by 2002:a17:903:3201:b0:2d0:401c:2ebb with SMTP id d9443c01a7336-2d0ca7125cemr99090365ad.4.1785945283158;
        Wed, 05 Aug 2026 08:54:43 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4ba225sm18570705ad.61.2026.08.05.08.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 08:54:42 -0700 (PDT)
Date: Wed, 5 Aug 2026 23:54:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <kasong@tencent.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Nico Pache <nico.pache@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: support splitting mappingless swapcache folios
Message-ID: <anNOroQdjQh7xmU9@KASONG-MC4>
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
 <590B3189-5B66-4ECB-84CD-7B7EF18C0E54@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <590B3189-5B66-4ECB-84CD-7B7EF18C0E54@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7E6124000E
X-Stat-Signature: if4fri8ejx9wtw6mdxk1shwfny4oizo4
X-Rspam-User: 
X-HE-Tag: 1785945284-118211
X-HE-Meta: U2FsdGVkX1/EZUwhKWVIIqz6yF13wigWM4puE+0IcQdM7S5FZ0lPiqEYu3vRu0c8pWtK+G20/RuxxQ4M72O0hoXc1aPjrtK/GPNVIg9pGBUrYSb9A8AOE2UF1phH2DUjoJV+8PO01vGsqUXWBlnAw0my1hxpPm9j3FfJmKbs670B3fQAlwz1mxoXDpb1c9M0UtNkERAfqRZzycTrR0ImmnUl/fjNtCVa1IzT0qzFwjNMjRtAFAmHAEs0uIpY9FvbeOS87AgfxsSSi2pu1WBTlJ9u5k14SNnOAxkHpLopoMadDzpAj8/6AiyqWijp3V8ypJfN8O1kcfLHPI0UTqdSlt2JNiptsYGHEqgU2XGLhhc4P2kvhzeB+Fq0wRiQYnsxmxfsIotBqTE48kB6aAookjh1pyaDaUqsVvEvBVtA0oHtT/FkLeYBJkCIztLR9EBbZV7UiBjagb0zuHf2ZrX93avDDRId+5J6Us9qmcjl1ErM8WawyeTjlnbhn6za9Nc0zKqsvslWsGFu2y1FnslGtRompei+RTJbAkw+qtNnt67uP2GbgA7H3KlF5Nf7Ik/NVkdbOZEcNwpOIVpJcQZDzTLgf+BzeWR8kZ49l2xzXh+akdjmMC7ziRDy66cb4Y0f9eU6x2OKIhigVNKt1vRHutJcwo7eQxS2SlrhyPmz1JS4hPdtWzmZlGagnok6AEs6oJ4LAakcS1byTghQ1c3M1Bzx4RFtl4Rkt7uUCLaMDU6YVtp4xiXEWwiZr91KSm5qhJ3wimxWXZKtwI1B6WV+WeX1FM9jle+03PmXaw7ZmIHGoWQBgtFA8XgzEj3Gbya0iWm4MEsAtHfAHZYCIZpfDs0ZRNx1T6K0WFzscI0G0Iw5F8ZKguUJtGA7ANbXKGsGwyIgjmgxqHo5ha+XW0tE/Dn59NtbTFQ2dUm7yNlSbvGzrZCuffDBcKxK3ewXEhM8FtBGR0yFhPBpjEQbSTn
 zjNbd4SD
 CvNl9U/Ot9RKPXskK1Mx7FkM+sKRcjEujsGF/nVr7NGKCKekxJOP2/m4NDtcOjChC7j/UHuEPhrSlWOeKzKfrBWD054X75wa75zG31NTl+5rOiHFGWoSZrU6IJckvpFF9FtXhECfJrqRv7l7prd0JbxV8Egcs4R9X4eZarYkjcrmi+sppDM/yeQF/zvi/pLaH92TXpJ1aC2h2JbFDWhj86vk3Ihl2vhKl5dVkCISQTwq0m1OxWHinaHN8ABz6t4o4bhzPw7ak453SPLtZ9TwkQN0VkYx33uWpcwXcv+O2GaWWPszu8SryLtaEx0XRCPbAbvzbzRYgFOOmR3RPIo/x0eZ0yuFtdJgF0GurqlWVvAPzSj2vq0ercLFFeHTbepOVl3qQ6u1O1MhLLVWc5HuVj4r7xYOGZzreO4Ui3SFu6V6Kp9yQYLqVucQKXcLh6dzjN8EUf9wMMN7EzrWRb3BUYxPECIkgMtcSSCEC8IpltVr3BQj/xPZxC+JdFAHZU3cOlaAp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 08:03:33AM +0800, Zi Yan wrote:
> On 5 Aug 2026, at 7:18, Shivam Kalra via B4 Relay wrote:
> 
> > Large shmem folios lose their address-space mapping when they are written
> > to swap, but remain valid members of the swap cache. Folios read from swap
> > but not yet associated with an anon_vma can have the same mappingless
> > swapcache state. folio_check_splittable() currently mistakes both cases for
> > truncation and rejects the split with -EBUSY.
> >
> > Implement the longstanding TODO for this state. Allow mappingless
> > swapcache folios to use the existing uniform order-0 swapcache split path,
> > while continuing to reject truly truncated folios and unsupported
> > higher-order or non-uniform swapcache splits.
> 
> Thank you for your patches.
> 
> As Kairui (cc’d) mentioned in [1] (see “A bit more details on this”),
> we might not need to implement this split. I will let Kairui to decide
> how we should deal with this patchset.
> 
> [1] https://lore.kernel.org/all/CAMgjq7CHDG8JhesSPMkn1kzG8jKb0BXO756BvxMQC_MCn2eTyA@mail.gmail.com/

Thanks for the CC, this is actually not hard to implement as shown by
Shivam, I just found the code more and more hard to follow and fragile
as we add more logic to it. And we don't have to reject higher order
split either which can be seen easily if the code is cleaner.

Personally I think doing some cleanup first is better, I haven't post any
code as right now there doesn't seem to be much user of this. It will be
needed if more clean THP swapcache begin to show up due to things like
THP readahead for swap, which isn't here yet. I think I can send an RFC
tomorrow just for reference. I'm fine if we prefer to remove that TODO
using this smaller change first :)

