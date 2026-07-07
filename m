Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8354FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606226B009E; Tue,  7 Jul 2026 06:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DDC56B009F; Tue,  7 Jul 2026 06:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3FC6B00A0; Tue,  7 Jul 2026 06:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23B316B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:25:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D80B1203BE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:25:48 +0000 (UTC)
X-FDA: 84961599576.11.60DD348
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 34FE7C0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:25:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ET1/u8IB";
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783419946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VR1L8Tfvs37DPjneOYKS8+jqtMz73BhJHMeN7x0oADU=;
	b=OOjyJlvHBCJaEtd3+Ry9OBb2WwHffmzKxycHcw1Deyp0Q5e37QdQe8yqwNByTjQPtbckNq
	3HhNVK3o+1rXq9c0FPDZdbetRxtoQtOggKYPXSLR1AAmK8exejpg04qJN1Mn47ZQDQ7Ql6
	3ky2Z7FU1174VC658KbR6ZIfBR20qak=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ET1/u8IB";
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783419946;
	b=SkYaxGS0w2p1+XL3/SwGxmcCnRFD2r46YS4TMMR7yqjS3/PMC9Weoxm/XafDlnb/6be714
	vlsB01Q76nQdZqDhnXIvP8jb5Mi1jzfdis4SwL6th0kbNrO9G5o6eItN3dH2Ngiz6l/zRT
	ylWNDEF7ynatNXs5cnv0wHB4UukCpkM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783419945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VR1L8Tfvs37DPjneOYKS8+jqtMz73BhJHMeN7x0oADU=;
	b=ET1/u8IBfPQN1+dYA5WR1p3QUb4q9LsNu2aZE0qcY2ivSSyo/QsWtqlW8SIrU1B2z7NDLF
	WCfdnOjgj7IouBS/ar6F+sekWpGkgZ12B0ArqJ3gdDjoRZjnZpdvzXPOdkKZTrFK7/4nc7
	tadoSATc5qxFyEo6mTiPWgVanhZRINA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-PvP8OjCtOXqHRykzgaBsdA-1; Tue, 07 Jul 2026 06:25:42 -0400
X-MC-Unique: PvP8OjCtOXqHRykzgaBsdA-1
X-Mimecast-MFC-AGG-ID: PvP8OjCtOXqHRykzgaBsdA_1783419941
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-493ba771d1bso37674125e9.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 03:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783419941; x=1784024741;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VR1L8Tfvs37DPjneOYKS8+jqtMz73BhJHMeN7x0oADU=;
        b=k2TA211NuKymsyD63YSl0JGM3vuwB6gb9QPhu3mObH//q1bjPP02m7UwAliSNzkL6a
         iNtiEMYK4ebGSwEbdgAkZam+laXwI3DOLrxFR/zwvRhVJHKEJJ5Gng9xaLMYL9EMoZal
         vCJ5tT0K7FzyyIImwLaFUaGIoLXKJQdBm4FnCnPBgxzZN6boSHN/EbJZ3J8phsrKWCwI
         1Fz6ic1QbxWYSbnr/HLdBjG3ncsS4H8E7bTOGbDE5dChG8o5OPGLOOwA7K7bwK6MnNiu
         tbl2PyEU2nyiLAaoo8CDF8LgaK/cqFJAYiwrs5hojCQNjwpZD3u3yF+6CTVpF0pYtULh
         S9Kw==
X-Forwarded-Encrypted: i=1; AHgh+RreTBAxIMY36q6IyXCeBWYRSH5ACvzUyqjsmia1+fhKfn8PrXqkBLxMK0tYpho+RtoVANR92cj1SQ==@kvack.org
X-Gm-Message-State: AOJu0YwOXFJIeiO2ZrbcwWB7i/+N+vzEygRnHi5JDMs9oeYPrGQrka3a
	ER3QGKl8daVi7GIzNFfdWzvTk4mI5zrtq8WYSP8ayU6047MmOZOceKoDcztjOzhWW2XdBH31Cls
	4H59V9BKypYWdTo4J9jWp2w1sUHQwy9Pu3HCaRyFr9tPqqkgFXkY7
X-Gm-Gg: AfdE7cm7I5hy+lZpfpcxyuAHn6HRIxCc3jRAc1NU5NxaWFESQmeGKA0pV39fFi9LJj8
	WA99eQTyldaCu+Pq34Iws6L1ShEjrQOXWYUZcaA8/U96mwJoLlelsNhSTKyyT6HzBNr1YnP/+Lq
	IgOihtSFXnHzZs+LiNUFPTQUadl4K/W3bxBkZpFFuFFaFkquwplWp3FUYaiLKXFk54TIAQ9tINV
	E0ZTjyfseUptVUWuIuT8TngIcj3CsETiLAYeCrVltDY6Lz37yvKl+um55D0J6oKU2DJr7ghsbS/
	r2n4HskbqjFLWnMVleRZ4HNQEvfJf3iCarFM+uWvovBBytdw0Ug7E0TVRysL8Ujxjd23naCVuUw
	ldyVz5LN4n2kbEyWiVD1Szz9bikhVZj+F
X-Received: by 2002:a05:600c:1383:b0:493:b647:1acd with SMTP id 5b1f17b1804b1-493df090a95mr49448655e9.36.1783419941258;
        Tue, 07 Jul 2026 03:25:41 -0700 (PDT)
X-Received: by 2002:a05:600c:1383:b0:493:b647:1acd with SMTP id 5b1f17b1804b1-493df090a95mr49448105e9.36.1783419940603;
        Tue, 07 Jul 2026 03:25:40 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039b126sm32286020f8f.24.2026.07.07.03.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 03:25:40 -0700 (PDT)
Date: Tue, 7 Jul 2026 06:25:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, mhklinux@outlook.com,
	fvdl@google.com, gthelen@google.com, mike.kravetz@oracle.com,
	pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
Message-ID: <20260707062428-mutt-send-email-mst@kernel.org>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
MIME-Version: 1.0
In-Reply-To: <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4RoeKMfu3ds6d6kG5Os3JvvX66jKpWHZ87Ei-EvwTy0_1783419941
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 34FE7C0002
X-Stat-Signature: 4gzx7fxff1q6ttau9s35n6rd1qqoe5i6
X-HE-Tag: 1783419946-315898
X-HE-Meta: U2FsdGVkX19jniZcAGbghGoJH1q9V83NjoTUqIIOF0E3CfbPba3wH3u2gdZBC0NJulyB7keJsDoWJ9KY6VHgyQg+x3E0ihpbrORYnIAxZyUWqs60AlP3jN3NwZ3DPcYGLHu20er5geArL51u2u/k1krEWqK+6ZlTp3ojNOsjP61JIttW91zFkk24fAaJO2j1SAQuYmacAoBxo4I57uFCR+NrnIFWRkfq3mk22YhmTrMmzgUBs09QmnVa0S0DxwYuEVDtjvhsFXyuK3/ZxCdA/RNjvL1zcbY0+tbpFY3PMOM+7a0WZhvea+LrC7lxnzF49PAANlaRD4ILwMt4ys7Go+8HPBOc4tL/DpNPV4p6HFZV7HfW/me4Q0PUVE+DIWZRxAMTLI75ijz6bgTGT1SZSf+2ywhBltsc/QL3A7kIAyYRd4Y1UVbac4MgCJj7bN0Q8dRVIYejjuVE56ZYoHptKMsxBHmiASUbYUctpy9Ga/ZIBPqPMpeiIjyJm4CORRd/qidBfrKqrOTxZDnnau10CyggSz/no9wSg1Epmkf4c5pvQapMd926SSsMXKoY93ej0je2bpe4qzZ0zQBaTkDxLpYCkWycjI9yoFC8X6qGYUUHq/jK4MdhcUCI9db8j4faO9qrpJoOGh+ugJAmsY4iZEn73Fk5CnrVaAXPUbTyVr8bezhj0Gynz4TVqL3rdD1j5yDZ1CXhCefa/iNEoL6psjANnTzcqcuLRy54AgqvxYuxwwVkF9Kh2ShKAEQvFmI5piZE7Sxl4COVrZAep/AZ6UFZ171QPkeNdVLYfTDIW1Qb9FacOJqf2p/bh2P/WN0bYnUngBGK5j7hs0QWOsHkGLrnkvJWDrh86VbcgkV7TVNI0lUGLCANnv/djBSuC2WOUVyl/ErYf+9NlbV3OiELV/f+IJzDW5Zb/sL8nIubP0Atvyt9t2VXJhaZ1KTZQJsbN/QGKF/hVSMjzh+eJLx
 WkJBkq8O
 ArK0adTWTH/3cnQHnP4rqgQ/r6Nx2UaZIjNguqlFPuOJzxW6j//cGJCj6W+U8TOtzBaY2+4APEDAkLG9hrJMVTEttzPlC1JFFLRvuxafxcQczFw8Oh8N1RYiiIj88WI93L3PME1uIm6/wIzQmd/J9mosxcJqBsEG4jkIzLpqr6+kUUCsh21XP3F6+aHZWNiDcLWCMug21hTBf/ZvN1B/TREo4Dw38hW+i0k3JoPEV6hXAbsBBffFZQCL06mRn5c5HBjGtTuOqEagWHylL0T43CGE3sx9WvFoQBZhageaMKLQrI81n7RjudkRsqqDHkI9OivFuOTha8v23NB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 09:29:07AM +0200, David Hildenbrand (Arm) wrote:
> On 7/7/26 08:42, Sourav Panda wrote:
> > Overview
> > This patch series introduces a dynamic, NUMA-aware HugePage Cache,
> > backed by a kernel shrinker to safely return memory under pressure, and
> > integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
> > specifically targeting gigantic (1GB) hugepages. The goal is to solve
> > the tradeoff between allocation latency and memory
> > fungibility in virtualized and heterogeneous cloud environments.
> 
> Hi,
> 
> in general, we consider hugetlb nowadays to be mostly in feature freeze, as we
> realized a while ago that adding more special casing on top of something too
> special for all of MM is only going to hurt us more in the long run.
> 
> We want to have less special casing and less special sauce, not more.
> 
> Now, there is nothing wrong in making hugetlb be less special, by making it use
> more of core infrastructure etc.
> 
> But optimizing for surplus hugetlb pages by teaching hugetlb about new caches
> and its custom free-page-reporting support rather looks like the wrong direction
> for me?
> 
> -- 
> Cheers,
> 
> David


It is currently bypassing free-page-reporting completely.
Making existing free lists not ignore free-page-reporting would
maybe considered "making it be less special"?


