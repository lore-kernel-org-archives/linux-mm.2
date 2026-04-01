Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B1AE107639C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0273C6B0005; Wed,  1 Apr 2026 15:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19F06B0089; Wed,  1 Apr 2026 15:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E302C6B008A; Wed,  1 Apr 2026 15:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D37676B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:22:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95B771A01F8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:22:14 +0000 (UTC)
X-FDA: 84610957788.07.EB98094
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF185140002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:22:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DaXA9Pby;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775071332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJDFokxm2ee0d3XM98QfLETjiOPLsllTVCxCL55zJzE=;
	b=qEnGae67jo8wyswAWGLhKkY8vSJvTO7q9Y/nrJBuX5hH32K7lGUM0t+VGwvg68YyE/oeVL
	8xSsOpRgzHJwB+PD3imP4H+glq+Bt5hUtWBZZg1kJ5ylVWfTd18DzH6LbyFhthr3sKm7Ta
	16UREUVNJnAK7fGJU36oumF3mGb/Mfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775071332; a=rsa-sha256;
	cv=none;
	b=xh+Vj0O32W5t0LVVBf8OBjqcXElm5jmrEIbbapqvVUXXE8iZLiNlHqcqObggGbEqxC76Ii
	gaqciE6pTbzpe42+MaXQ0sag17pSuk0u6p/8oRzyJnqaSt92+lwzY7EyJfj+gxlv6r83gt
	pvQ7BesQpvSiG4TfTA+vr0LVMLQUOHw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DaXA9Pby;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775071330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NJDFokxm2ee0d3XM98QfLETjiOPLsllTVCxCL55zJzE=;
	b=DaXA9PbyRV1DoPx9lwH9SHLPvldiOol6hnrqFdfqqnsawsuoyZyS2BlWSlEDUHnzlm72mb
	lJ+hEojIVBIAtqXQxeqN2pK/g6xJvpFzsWFvBVZgiTqTvtU1lA/rMkgJHbJ7FJmp8xPppU
	MpUJoRgzaCGFU7CH2R3j+Z38ch6vLeU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-9VOOncsJNkmqGh4ErSHFQA-1; Wed, 01 Apr 2026 15:22:09 -0400
X-MC-Unique: 9VOOncsJNkmqGh4ErSHFQA-1
X-Mimecast-MFC-AGG-ID: 9VOOncsJNkmqGh4ErSHFQA_1775071329
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cfc5294894so47785585a.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 12:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775071329; x=1775676129;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJDFokxm2ee0d3XM98QfLETjiOPLsllTVCxCL55zJzE=;
        b=bJ4oPsPJfOmewXGMS75EyzXBlpkKNhpeucwDA4oqw/21afRp0qFCx9FQuvjQKFOGMV
         faHw3BjhqEe33bLTnX2/AaC+tLPg+4i8QvulfgX6yTXpgPs3B+LY1uaUatQvn/6pNoho
         Ma4WGIuFX/MUfhjvGmsDzNiNuhnPwNoX6Y+i+HaDgJnugcD/Nd9EwbGHtjqQ/2JCeWNA
         rfG1dQEhOrqIgLn37+4A9GW9awiTF/+GCS+gnuEvZBe8R7RhEP70pdwln2v0sVSNgODt
         YFijdyiCOPN9TzcgSbAtqI432lsYK9ngbY0Zt0Asx5jo0boTzjMZEy7hA0YFkV9o28Tn
         Z0Hw==
X-Forwarded-Encrypted: i=1; AJvYcCVvUct2LvsdEDpOmNBoQgQSwKGODJsq4TcWTxw4enJRFDpkvXoLxCN1yks3Fmu3wtr8cpZnHk2J1w==@kvack.org
X-Gm-Message-State: AOJu0YwR7OgCJ/m56mkwfLseh75B+XanWlsGCFSmTg7filZFkD60PFHI
	SlbwzhJXKbxSTcQid1oVd+kZwswCVTFWYbPIAEr2tKivWSz0n6KvA9ZC18ijZDoWqo+GiQr3eBA
	Lqr1tZkVlOOWwaXEsS6irglxZc1qBRqqxZEl1+podQjPyvn3gmYm+
X-Gm-Gg: ATEYQzzpD0+W53bIsUmNRLGvtK0PWn3PV3LN1HorZaYtuvOzVp2gwsTOJnS7ObE/Ftc
	2O0g6k0gnVEcY2CnPkycBuB/bvNtZLxSeh2LxAMu8ZyBk6jXuL0WHlcdETjSoLzc8rhLmkPwKCp
	+a1k9SlroBCVDePQPu/jSe2enMDutF12FoNukjnpjg/eWsVlaE03fjq+qyz5/jU5f6lOvw8itxB
	iOXXJ7eRfm0rHPtS/SJXAWkHQMOJ/x6+d3s1PnLoZU95duAH8TLuy5psOQXg4FnjQVgWS8DytJf
	50bKrCamUm5jZyM1jHJdwtmRzmMcMxqgcjfhNMgBvXNVIvG86nEQ4yArJOAId5sY4FpblbZRP7V
	mIodxMygHGTPpYAfFPtlYGSHxASb4CsVQ2COUNo3ToQPgdg==
X-Received: by 2002:a05:620a:2698:b0:8cf:dd63:fae7 with SMTP id af79cd13be357-8d1b5b94ed5mr694372185a.34.1775071325104;
        Wed, 01 Apr 2026 12:22:05 -0700 (PDT)
X-Received: by 2002:a05:620a:2698:b0:8cf:dd63:fae7 with SMTP id af79cd13be357-8d1b5b94ed5mr694366185a.34.1775071324562;
        Wed, 01 Apr 2026 12:22:04 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a59323a2d1sm6565296d6.9.2026.04.01.12.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 12:22:04 -0700 (PDT)
Date: Wed, 1 Apr 2026 15:22:03 -0400
From: Peter Xu <peterx@redhat.com>
To: David CARLIER <devnexen@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <ac1wW6LHzzkXBeSl@x1.local>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac04ZeFdz7yvByRp@x1.local>
 <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rO-FTwmmarqCK9btda-QHDPwalF2yMs3_oyLOMOOVz0_1775071329
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF185140002
X-Stat-Signature: ow9fuuk4c8z7g5bidimpzcijopm98e37
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775071331-357074
X-HE-Meta: U2FsdGVkX1/xLO0EX9EPQYfKSInshyByJggmVUK3zPzovFZnSnvKWkPqgO+cR47xztQfMa/s+Mktul/TAELDQtFebjRESKCoN0z4rwtXFO4ZW91YAZ5ulbjF5L3UipvqruzTywWK0eQDKea7TvEhSD1P0SJfVt9r9ayVSq3zKBOXCZw+I9Q+CCd8SfqPzczvcxoO+d3bg/8v6ZjckMz9vILsD6DtXMOzJwLzhRLAvPDy+fvEVTL5BiCw2CHL56cxmjd75n2xW9f84yfcz65CLXfmGTcCFQIRyQ4u5eAe78j8mYePSU+DrV7C3Bn/Ou3TRzsHriB/7cQgDfiXLxcwz6lUB6Y6k7WqyWtWWqniFpCnTEeLngd/NOV/yFLG36xgQ9+Ie/L/Ji8g2xUfcHw/FDP8kPC1FKGtYR5rI3e3AMrIFjkByAmsQ9UZfxWpPW7/3Tgk7caAu1BOCespfdzpTPZG06M3gG4dGuNkPTqunG4i7nwdl4U6TwKoKvCY/undqIOVhc77oiWfgQ4ATHWeN6K0yTXYPZRomYV2D6Df+ru2FfTKFY11yh0EWr69RF1WCv/o2bQflFZ9V100ayucsIt5yYaweODXc+NPPZvg9lJlvYvYr/BsIMU2Ldt3GN0xLfhClDuIWUKyhVvj0OuHd14JXJP3DDfpcf5V2n4uzyLd+6LMpNdBx5nJO1LEL1DcxYj/kWXsOayzM4xbWIhqSIiwCzv2TI2ngssJgn7IT8F0aSsqG1WX5NR28/pZEEaOc1nmxuMZUjEC+/GuCP1PdlEXxLz2oD0A8UHh5wbzxWr94gG+YmlBKSV2X5Kh3HPPBqkWudkX0N9yjsBvFu6rLJfiUP1L6Keu4yVNqBhvpqDPrxrGfCwQPXXsMGQrCqRXLifCuStOfQ0lQnlgjJrdw+CfL1scfMjeeXGWcH5xdUUH9ILe+MLds935XaqsW2DmFm/NmDVbLhjkD2sfiff
 GH3rcU8y
 dSc/ZfVdj7JrTuDUUfcrkbgW9rlQLAA4xZlvTugHUBmr4XuFsgMrwyYmAwmo1Z67zox+EZqmstCionXqwzdcel9Yaj3BU1dHrL7cWEP0gKzCweENqOwBT6yw+JOt7ZN6vmMiXKJJPVCtJb2xz6jAvvlK31IKPP12nbxbd92Bu4+hpaHVfa4rhS6hxwyk0kUQ4N5rNqSl8ek7jcoeQiUbXqB+KSzpMCqHdL2V13070HhboQpJog6YldMZQaCuJmlKsg1TIF84REKUZ51025hOFM9J7UMa9pLq++FE/M3kGjRZwoGdR8d3u/+eJRAqcrsYBtCQcjZCPTMKhQNS06sId+PnJiVnMsibmGZRgrAiSQbSnT6z9D6mVGCnXTpe8O0mH7z/TOaUGHxcVDlLEEmvyMbT8dJD/NC5uktIja8U12Z7aZafXDbhRU7QPoBxWcQheyfNC1YyZ+9DjmI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 07:34:47PM +0100, David CARLIER wrote:
> Hi Peter,
> 
>   On Tue, Apr 01, 2026 at 04:23:00PM +0300, Peter Xu wrote:
>   > IMHO the flags is needed, consider a shared shmem vma remapped to a private
>   > shmem vma.  That needs to be covered in the fix.
> 
>   Right, I hadn't considered that case. Shared->private changes how
> the
>   folio gets handled even with the same backing file. I'll keep the
> flags
>   check.
> 
>   > Actually instead of reducing checks, maybe we also need to check
> the offset
>   > of the mapping too, that is: vma->vm_pgoff can't change otherwise it may
>   > also affect how the back store would behave on this UFFDIO_COPY
> request.
>   >
>   > For that, see the example of shmem_get_pgoff_policy() where it
> seems we can
>   > apply different policies to different ranges of the back store.
> 
>   Good point. If vm_pgoff changes, linear_page_index() derives a
>   different page cache offset for the same virtual address, and
>   shmem_get_pgoff_policy() could apply a different NUMA policy to that
>   range. So the folio could end up at the wrong offset or with the wrong
>   placement.
> 
>   I'll add vm_pgoff to the snapshot. So the full set of checks after
>   re-acquiring locks would be: vm_file, vm_flags, and vm_pgoff — ensuring
>   the folio was allocated for the right backing file, at the right
> offset,
>   with the right VMA type.

When caching the offset, we should likely use linear_page_index() with the
address provided rather than caching vma->vm_pgoff directly, then it'll
avoid same vm_pgoff while VMA mapping shifted like this:

  VMA1:  vm_pgoff=0x10000, vm_start=0x10000
  VMA2:  vm_pgoff=0x10000, vm_start=0xf000

So VMA1 unmapped, then the app mappped VMA2 at different VA but still cover
the address we're requesting for UFFDIO_COPY, even if the VMA will still
have the same vm_pgoff, the VA to access the same offset might change.
Using linear_page_index() will be accurate, IIUC.

The other thing is I just noticed the err code was changed to -EINVAL for
snapshot changed cases, sorry I didn't follow previously as closely on the
discussion.  I think it should be -EAGAIN.  It's because the userapp can't
resolve -EINVAL failures and app will crash.  In a VMA change use case, we
should return -EAGAIN to imply the app to retry, rather than crashing.

Thanks,

-- 
Peter Xu


