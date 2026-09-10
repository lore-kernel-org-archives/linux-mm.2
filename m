Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D39DC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 19:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61026B008A; Thu, 10 Sep 2026 15:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBD16B008C; Thu, 10 Sep 2026 15:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BEE6B0092; Thu, 10 Sep 2026 15:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 827FC6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:58:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D0D2140640
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:58:06 +0000 (UTC)
X-FDA: 85198913772.22.041FF51
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id A258440006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:58:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XrwSt8nl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XrwSt8nl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789070284;
	b=N4zF9QV11LWiUdMnX42qXR6q/9wy0VVRSnAQpmsLbMDaiEijhG9sTBvn8CX30whFQqtkpe
	6oob0vGAN93r9tYQm1s4+ZYNmDa4UgX6FokPVBmlH2bbnWpGmOo7qjH7a3Ja2jw9lv88aG
	uJ9Pn4OSrnnFn1mftTuRRY2g4tApcXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789070284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwZeLG/lY3dlk1m8H+DGflPWf4vG9wjk2ruxseRkZqU=;
	b=ICeYwiMtKqTApgLupBKgAw/zbfrUPgeGTQlOAfuzC2seECnEqnCUYq5hK1L+BiGXmyhmiN
	o3WRs2MY319zha/3TV8bXpqExn/maQ7VjujQFBePVnNxg3XGZEoxm7QA/aE5RfyfG6ftc4
	+CD6qXGtrrNl5d/j6VHubiTDczr5B1c=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7f6617c7536so105987a34.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789070283; x=1789675083; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vwZeLG/lY3dlk1m8H+DGflPWf4vG9wjk2ruxseRkZqU=;
        b=XrwSt8nlMOa+ArhtZ1B6WpGvceZI/PUlk+fGyAx/0TZKMd7ZdV9KsfNt/2VgOXqOjK
         DJ49fMVRuITJqV31cLHeBXcuBcJWJOOZ/CCSHy7sXAWfjAANpcwG/CWk7eGTc5SICBB+
         y3bCMlx0JgmvpA3GOVFwbOqHq+ftwEQBN9FzW7Z0sGHBWh1lvqJv9CqTnPldwwYU8FZI
         ldx24Tyay6UHHcoIizsjet2jxaC7vSDrfBO0dYyiLdk3it+71oorwno7NRxmf7HSPr3a
         IRh10Yr9a/kWPv5Cv6ZvaSECMBW3Vi9JLS6Ay6Z3UaizGDvvEOBVWgMZ9Z6OrNwIWK9E
         +1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789070283; x=1789675083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vwZeLG/lY3dlk1m8H+DGflPWf4vG9wjk2ruxseRkZqU=;
        b=nuEeM/Q++7EoaU67v+ipG8heba0hdICdo2NduInBMxqTAezfZLOpGRHbyIQwr7i5QM
         eRpLJoHSfSh598RrlZr3J+kVKUC66OZ3SZeQK1n6eU0RAEOE39BPTpK3spzI2Vi5MXrR
         0uiSMnHqMCxMW76Ctvaf08DQAyDiixDA4pJc4mN4HrYDC81gEm6OVj+YClwr6IlyAxIX
         ugWCwqSKCh2ZpFK4x6ggDBz9XsIqu6AC9ctcsfPY2RiNsDm6f3qJP04uFLeUJtLJ+BhL
         /NJRaTJWIaeuKrajzNOV9MyQ63V7tKWUJO5cUHEx+bndsJMf798rhjvNf1CcCPfJljl6
         lwEQ==
X-Forwarded-Encrypted: i=1; AKwUvBzvqA44xwnWV46vQvvKjDOpmQFRG1OQYn4RP/Z/fNy7t/fKeHeONEuzuojHU+ztI/PAMV9FVYxatA==@kvack.org
X-Gm-Message-State: AFuF++lp82JfoH/MTg75zfeyOozbbDgtGOuW6oZSojpin0mgaFGvKR/G
	Gs+YKqJ6EBHbRtjh9ArkGNsU46oW++SHYM0Gy/Yly2y/iL406ZzYaOhr
X-Gm-Gg: AYBFou2ldo6SMUvwr0b4h2VxvbAyFLhhOzwJt0i2SdM9byuFXDLG+ZDyua0lNjYSyQo
	WsUlM4r+DHPLQnGFB8Tl7FuUufvRzLCcT6Dp/PirvrM5ZZjz9OPnQQvI+2mfSCWus3/hm9013Hv
	5qhMu/tJeyCMW+m1o8/D+g7JGbjUcohU0BPIu+CLccJnsMCcwIEkjOLGh3hNMCSCUPRjI2QRCxz
	xw/FMb8NcoC853k9pteDw6KuhCHSYdXkgaAcr1wLep5evDT3Q2nNt5BeHNC07qy/ynV2e7me9Y6
	sbI01SvHNfmhjGHcowLbxeA7lcPAnbZubjb6EbPokc1E/xNP8OGTWUflLSn7iKG6pS9f4HzGRWo
	jslwQq9+p9INg6MEqKq3bW7x+kkXip1TscUZAMAk349GWab9dZRGhIoUTDebXAUXxIQHtilbGya
	aLpBHFL44AYnTjC77qZd7Yx0awNzJDIVytiOlIIxctV95IcQLLfg8bHm0g/7LEsk3Rmuv0TTAdY
	qrt9aPydDvGrPN8SwzA0qlJBKMKQw==
X-Received: by 2002:a05:6830:3886:b0:7fa:5c68:d04c with SMTP id 46e09a7af769-80401bc5c1fmr251411a34.22.1789070283153;
        Thu, 10 Sep 2026 12:58:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f670db38sm485051a34.18.2026.09.10.12.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 12:58:02 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ackerleytng@google.com,
	Alex Shi <alexs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	fvdl@google.com,
	jthoughton@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Zhao Li <enderaoelyther@gmail.com>
Subject: Re: [PATCH v2 3/4] mm: hugetlb: Fix subpool usage leak on allocation failure
Date: Thu, 10 Sep 2026 12:57:59 -0700
Message-ID: <20260910195800.3459455-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909155459.dbf9d67ae21a72935bb863d9@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A258440006
X-Stat-Signature: anosh9e7qygyjt4bpkk76fdo97b3yuzy
X-Rspamd-Server: rspam01
X-HE-Tag: 1789070284-910337
X-HE-Meta: U2FsdGVkX195UUbtl0Xi0HMvT9n6ESscNCkHi284CsSKP0PpejSK8e5kwauDDE7uCnQhwDLoQRRWK0QdYjBNdpsntSBvKh5y3TRCNDfQkaRgM8EerbHiyUnspZ8FBu5XJfoiaMbIXn+ARNo6cHsvtnqbS/1NFLmmxy6aydItHpUgHTPlP9O+pAHYu6kiO5NaXDto0xSxXbR3KL33bhSQuHUVuMBam7ntP4Thi/kWt9kuIaFcmJW/TLv1dAdOLwBBEv4bbH8wNwM9MGlGecVpTrtiKwb0eJMaW1jIqUu7j0hUEjeSA5ZCnT8c9gFfsfxCkkm3gend/W9pSQxd50+wPW6oU01CJb+NDE4NA9OpvCzQBwYiS1j+YHNC1uEI7xu9CzKZq3ZZSD1acO6+iRfKl8op//0dOkMSwDcNbG1bhz++yOcUlhF21fU0meOfLR2AKzmDG9bnoeVLHg0WWdGOqdug7hAZR2I/ce41q48u+JVR+nVoRuqF3Jf8X4M7lWx/CDX4eLD/xKWFdVNJBD4N5XWn7uv2MWXeuhH1ikFYpTWJWXxcJMBl0ol0PIsQOmMbcVswLzSeun/qeRmNKdoIGffZfYurKC+NjmH8CHNmWFMk3vBN0FnVIW8WmLQ36wTsD2VPDzy7lsijrOjvNd4IKb4rzYzjt4oWu8fbWgTx89gm39eUC1Hg1KSgufZp1Xgf6REZfLT+TyrhZbQX5v6+TU/lPh6aLrhPvEvO/8u2fgWKAhSxVbkLEVzmE6asFEhr5kYCQYRxkXO2MVIMdhNXZ1LENpSfkki6M/Ib5D2zsztXzKYykYUX4EjFP4+L/DvTE1SC7cBk//2UhFq4EyKEjsyIvTnWEjHkvsBiMy9SesrpAOMX/PlgaL0EwNQTyc44od0xxe9/ApUMO66+08Iyg3nbTAPfVyNueZV3xXDceU7vCpXgEekeZgoOPkGtdRASHiltyy1905tfMqtSaU6
 DOk3q4c1
 nFP5CF5V1h+oq6xc9W+Kv37BCl33DMYXkE4S+cjb3W4+h6MVDHSNohlyIOv/CYee+yUBx151ndHbxP/DhuAZt+lgbdf7kjCYlIMu6BOWc+XXlIpwLOtx3Q2TuooEI8o1d/+ufApkPh6aWpp1Tp6AWa4ELARGOjweMrt71rM3B7jhLvbpznPe0VEq3+u+HfK2+eMGRPpymU+XFoJkdu5f4IhBrKO6vwSI94gSaNbT+e1PktBz1ts/54p8hB0hQi3CPQ4aAsyC4yFe1wo5YtqYG2FAo7PNmCoEgrUj8jTlPSeejBWRwatghon3C0OK0ijkhcRZQwOLoKV3F+tZDuZnD5t73S78mhhUUIeiNOVpwKgkWiP4baeQQqLch15ghqBL1CYQ3UBwAE3cC5XV8SrfyvkyWdtLNxGcYq9Iv3nX2h87PKYJKPDqjjm5Ko2goLQH6RAIOrf35lyFIPlUVFh+1wdQEsgpGy8zlLCwZZW/X2VCv5ZT49etNWpT8LTGCTLZCvSNxMQbmhGJMwXB615oavuElkRl60jaLDKCH6X4LLiC8/8u2nPUuqIbVNei0In5IodhNn4pGA4MUMIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

*/
On Wed, 9 Sep 2026 15:54:59 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 09 Sep 2026 14:49:28 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
> 
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > When folio allocation fails early (e.g. buddy allocation failure or
> > cgroup charging failure) and a reservation was not used (meaning an
> > unreserved global page was needed), the subpool page acquired during the
> > allocation attempt must still be returned.
> > 
> > Currently, the subpool cleanup error path only returns the page to the
> > subpool if a reservation was used. If no reservation was used, it skips
> > releasing the page back to the subpool, permanently leaking the subpool's
> > used pages counter.
> > 
> > With subpools now always tracking used pages, always release the page
> > back to the subpool whenever a subpool page was acquired.
> > 
> > Opportunistically rename the local variables tracking global reservations
> > needed and global reservations returned. This clarifies the accounting:
> > a value of zero for needed global reservations indicates an existing
> > reservation satisfies the allocation, while a non-zero value indicates
> > new global pages are required.
> > 
> > Adjust global reservations using the difference between reservations
> > needed and reservations returned to properly handle races where concurrent
> > threads interact with the same subpool.
> 
> This one conflicts with "mm/hugetlb: fix max-only subpool accounting on
> alloc_hugetlb_folio failure". 
> https://lore.kernel.org/20260428113037.88766-2-enderaoelyther@gmail.com.
> 
> 
> > @@ -3074,13 +3074,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
> >  	return folio;
> >  
> >  out_subpool_put:
> > -	/*
> > -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
> > -	 * during hugepage_subpool_get_pages.
> > -	 */
> > -	if (map_chg && !gbl_chg) {
> > -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> > -		hugetlb_acct_memory(h, -gbl_reserve);
> > +	if (map_chg) {
> > +		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
> > +
> > +		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
> >  	}
> >  
> >  out_end_reservation:
> 
> Here.
> 
> I presently have Zhao Li's patch staged in mm.git's
> mm-hotfixes-unstable branch, awaiting review.
> 
> What to do?

Hi Andrew, I hope you are having a good day!

Yeah, I also noticed this too [1]. There are actually 4 proposed
solutions for this in the mailing list which is a good indication that
something is wrong here : -) But unfortunately it seems like there was 
no resolution the last time I pointed this out : -(

I CC-ed all the authors previously on that chain but wasn't able to
get a response, maybe we'll give it another shot here?

Ackerley, Zhao, David, Song, hopefully we can align here.

Personally I'm partial to Ackerley's approach here since I think the
get/put semantics that he proposes is the easiest to understand for me.

It would be great if we could sort this out since I think it's been
a while since we've had all of these proposals in flight.

Thank you everyone!
Joshua

[1] https://lore.kernel.org/all/20260713144557.3845941-1-joshua.hahnjy@gmail.com/

