Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D67CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 18:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DFD8E0013; Tue, 30 Sep 2025 14:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FE28E0002; Tue, 30 Sep 2025 14:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D66D8E0013; Tue, 30 Sep 2025 14:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 564778E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:48:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DF3B44347
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:48:59 +0000 (UTC)
X-FDA: 83946803598.12.DB215FF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id CD1DD1C000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:48:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CPDJeYY5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759258137; a=rsa-sha256;
	cv=none;
	b=znUJFxviFlXCoWf/DPWQoEpBoPYGFwq5xGl7S4KinKA6KIfbRVcASnFbaJaL+2vkSm43/g
	6W/hJ6ubjgq45pinhMfTpPJEPz5tcrx7+eEV3KkX0vEeINMPQmAJ+l6Ed3xH8/noL1khTY
	w+VUC9BwUfLvyO0WYZfk+fGeKgOn0uw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CPDJeYY5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759258136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsK2ZJQMv6HTGwzBtNFmgf1Bb8Mvb8sxIYfW5o9dQJg=;
	b=Am1B9pZ+hBWyj7o+hAsnhbmR+rxAdO++umKJwA/dKbN+WEZkj5L6BaeRZMd+/TOGWS6F5S
	hcRnuJ0loaO67qclYYlBVOEeCWWXXZuV2z2EEZbWLAatTViS1UIscV/1PcInLZg+hxe31U
	bfIpxAktt6NsHrhSVjQjWBTcfczGMVM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759258136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GsK2ZJQMv6HTGwzBtNFmgf1Bb8Mvb8sxIYfW5o9dQJg=;
	b=CPDJeYY53qk7dp0qBtRHsJUozPdb8IOBhEV4CsDOX+06Kdv1+1IQoQUK4pqJvdiiu13F6u
	yGS+67DfusdCIW2jYeVnHffxYabIVi870xgal1TC+pJonEy1AXs5agQHsTwtb5RWIM5FOk
	dJLNyeM/RNnV1cOPjYz76WbdTacv18g=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-MZJIgoO9NYy-zyGbTV_4uA-1; Tue, 30 Sep 2025 14:48:54 -0400
X-MC-Unique: MZJIgoO9NYy-zyGbTV_4uA-1
X-Mimecast-MFC-AGG-ID: MZJIgoO9NYy-zyGbTV_4uA_1759258134
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-857003e911fso1409414685a.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759258134; x=1759862934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GsK2ZJQMv6HTGwzBtNFmgf1Bb8Mvb8sxIYfW5o9dQJg=;
        b=BllpRl4PY/M2oMB7q/ZCZ+7uWYt8upgM64Tef/z3idwaGkkAZQ0PZgArt7XH4/NATS
         vcfExOvhb7q1FE7uAaGvgPeQDz3/MtyDBAJlwTz9p8s6DJch+lnhJz8QbNtVHMwxoR7O
         V2UZpagoV1enEd7ichgb44Y+aflAnrid5kW9/voITVWpPkvQ0WpfEF3x8LC2XOBoeh+a
         t9Z0eRzO44qY5ilOMGUTHqlttK8W+dI831/2/eTCOtLTVPbOiiQxPs5r1/7j/N0JBfyR
         8m2zav2vJ62RC1sCatphUJwBwUZd92obM9K8J2P9MwaWlOzt9aUsxuzQ4xRxlwtso2C+
         OOhQ==
X-Gm-Message-State: AOJu0YxhrdHnG+kYeLYIRTrRqvlb5IN5RMbEfG39gOVpeng/Mmshe6xW
	WkP8ZseuscBmcpLu0dgtkBMFMMVYNeWfsJ9dRoE9pb+Ss0iMas/OMpOz8nKvyYurBdxOOB3zK7o
	NPb0IIfVwVn1XHHCgmsoAHyJqSucvZ5N9c10uQjU7NSj3dbbFLgPs
X-Gm-Gg: ASbGncvLAswSl3bcXjxrxKX0Ez0DCW3PYJvR4xQJkbY51kXJymVAT9aBXktj0t+65Cc
	qc4K91/FViKq7n+tCqxLpFxE4BZzpkPsBcrIzPgYXrCg01ySFl2V91GTknRLpiKGES/QaNPB9sk
	YprmlCTU40PQGS0qqBdt6BzJ2HvWGincBDOy/roo75CK326iUsaP/aFKmU19mDhC0cKAzm35jz3
	98LrxO/fdSmnFUe66gVGTegOWIkDsqbuUfOipGCXceSHHJhFWwDWg3hjAJicNJ7Nw5dyPF/ZFzm
	9mgnqw0phmJ9h5+ACAyCmQjxRb+kWA7YLNe41g==
X-Received: by 2002:a05:620a:d8e:b0:815:87ab:37e0 with SMTP id af79cd13be357-873758551c8mr121579585a.53.1759258133770;
        Tue, 30 Sep 2025 11:48:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHR75yoXHKLyo204zRVz+mQdvcWMzFHs268w3lCm1SiwqLIybwfgDOJTTuWeF1rAdKiczAlOQ==
X-Received: by 2002:a05:620a:d8e:b0:815:87ab:37e0 with SMTP id af79cd13be357-873758551c8mr121575285a.53.1759258133235;
        Tue, 30 Sep 2025 11:48:53 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-85c337a1e1csm1083938985a.62.2025.09.30.11.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 11:48:52 -0700 (PDT)
Date: Tue, 30 Sep 2025 14:48:51 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aNwmE11LirPtEuGW@x1.local>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
MIME-Version: 1.0
In-Reply-To: <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ra8xXZuBW3h5jcpHMWSOgHEYHt5m0THqKsi1HfBTrq4_1759258134
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD1DD1C000C
X-Stat-Signature: qk15kxd935zygis1i3deqmw16q1ii6zn
X-Rspam-User: 
X-HE-Tag: 1759258136-219334
X-HE-Meta: U2FsdGVkX18vxpObSwoplFQU3mIwVia8LaGTdXb1X1x8b0hrQrzXHcrdx5rWp9OzYtllzbKWF+78G6UQFKq2zC8BL7QN7jluNuI0TwBLBWAV4dG7zZ9Wzbfap0ZUAmc6wyXuz6cGi7+njb3l0GPAq9sEpsc1FiE0PX20MA5j/odM2FeelYgshoZAVhKJG4H5BHo3alfG/KPPceo9/UO6xp01LL6961zKZzzpH3TxFkTFApk5XE4SPTx0grOqrJDY4mcCw+LipcN9uj3q5x2nuVz3q4HVUt2i2YOjpQTJBgi/ZEEsdI2H2cnZ+irBFoOCWnpnO92unQLDj2LqU7oi+djd8+g7H04oleytGMRSpPROrqAAoGrjur0CHzQsBIiuHAth5XkPyzHKCgH3Z+Ge5oWnJ9d/X3diNWhLlPg17Or1yr6jgifLUl99/6EXLcM7RxLQKLuxkZV5EzsFTcQ0Zz89JWeOeI0cpAQpGFnft1jE03KGXqcsxOhjNGFxf8FM91iR+a5QH+e270QHc4UZ2sOJWSD0zqg3n72f5M4/phgtSsX1TpkHDdTsgaAsxPnUY8H01LYTK2w7eL4yVVsBYfXGKaPLLx9Xzbaf3rk5R1PZT4z0CaXyrYOuupslbg2gtIccC13DsM/4+LA/qDvveO5b8GyI4K4EvKWnV2VggdITVCSjCLHEmTzP3Eeyddy1STODagPUWDeLcxZFzLs5rfvWhaGeBFMUuEbJQPbM3+8+V5PQair990xKN1V0gepgVdAQ7sqHJFepljaxtuxZQAhGEmNHL0wBbnnaZop+Nf6xX/519IycR5XHbTJFB4xcozvBEwj5V3gbiLxESMD/8Il84gUWe5dNrk+fwJEPrshNKTjZEhZK2M/mejxw+0EqHUhjqcfD2/muMGhPRRMV/qTG+jwvAZ1wqcS+QfHLGjQu27gmi2lz+NDoLAnV9+JWcrbcd14fOiwY8ebsnJw
 5hT+9EcE
 EqqdoYzSy0hpDWe0suRhcJunxPtDf9U1lhAHQFSyDLwRwzqwBihtl3fM2DDjBYGvF9/i05a9Nd2BgUGvzl99P/yqpymQSgaizBromPC9gwgawNdA0u+f+v4hyGu08Ydkx3NwTjFJ6Ola6wDSjYm6L/iu1e1mCjQKVuIPrKgbkrx5goIJqiw/RhtsuUscQgtVHZolrvTwzLT2u0EKBKMSQIrTJ6ezX/0NxESQfG0CJ65IwnK2QGfPcqu/fKpf3Gxv5YUgLL3M/WH0TVNVhjzRVeuPU/dv3Cu8hDvsRyftM/ePShnfly/H8cSGzPs5fRzqvf7bgeAK6x7p5IdG4l1WaTaEU9PCM1GJZtRIrL+3dPnI3bRNdQ/+oIijJwDjCHIfwvJo22vEs50yZgNXvm65zKnpVBBu9gVlR8PA5Sbn0hZlIV/6GZZz+jA8az+ajema3BqtfFur46oN/HhogK8gsJF71nEzUz5BN19CDbEwSlMMqOg351TYc1vWI5AvWnLTXkVJulcbxpxmsHc5zzGkZqwPkH7IsSw72FARRL7dnDCQvwxkXuzaT6OvFvm+jz22KWfLUQ0jZDwJiDIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 11:36:53AM +0200, David Hildenbrand wrote:
> > +/* VMA userfaultfd operations */
> > +struct vm_uffd_ops {
> > +	/**
> > +	 * @uffd_features: features supported in bitmask.
> > +	 *
> > +	 * When the ops is defined, the driver must set non-zero features
> > +	 * to be a subset (or all) of: VM_UFFD_MISSING|WP|MINOR.
> > +	 *
> > +	 * NOTE: VM_UFFD_MISSING is still only supported under mm/ so far.
> > +	 */
> > +	unsigned long uffd_features;
> 
> This variable name is a bit confusing , because it's all about vma flags,
> not uffd features. Just reading the variable, I would rather connect it to
> things like UFFD_FEATURE_WP_UNPOPULATED.
> 
> As currently used for VM flags, maybe you should call this
> 
> 	unsigned long uffd_vm_flags;
> 
> or sth like that.

Indeed it's slightly confusing.  However uffd_vm_flags is confusing in
another way, where it seems to imply some flags similar to vm_flags that is
prone to change.

How about uffd_vm_flags_supported / uffd_modes_supported?

> 
> I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
> are rather unsuited for this case here (e.g., different feature flags for
> hugetlb support/shmem support etc).
> 
> But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
> the supported ioctls?
> 
> _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
> _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
> _UFFDIO_CONTINUE -> VM_UFFD_MINOR

Yes we can deduce that, but it'll be unclear then when one stares at a
bunch of ioctls and cannot easily digest the modes the memory type
supports.  Here, the modes should be the most straightforward way to
describe the capability of a memory type.

If hugetlbfs supported ZEROPAGE, then we can deduce the ioctls the other
way round, and we can drop the uffd_ioctls.  However we need the ioctls now
for hugetlbfs to make everything generic.

Do you mind I still keep it as-is?  So far that's still the clearest I can
think of.  It's only set when some support is added to a memory type, so
it's a one-time shot.

Thanks,

-- 
Peter Xu


