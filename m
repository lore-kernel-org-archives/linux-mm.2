Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A91CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7243B6B0093; Thu, 28 May 2026 04:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2556B0096; Thu, 28 May 2026 04:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5731A6B0098; Thu, 28 May 2026 04:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 486246B0093
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:55:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A23FC279F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:55:12 +0000 (UTC)
X-FDA: 84816219264.26.2B94E64
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9C8964000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:55:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779958510; a=rsa-sha256;
	cv=none;
	b=R0XX9enXQSYvN6ZXEZ2YVbHQ8eDGWO1Bz8FcxkgDEODl1sb3eFO8PySWY0oP2+zKWC4RMl
	OsIXcMShBLzSCveoiaAUnUXLuhEFTih09R6/pXCdiYH9B8iclcr75Fp/T167Ii2TXSVzUo
	N/95cuKjV4W55ltUAnNs0Ly5bk0IYQc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779958510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8n1zT3Gm/DRroonjTQmNnen/Lf0jqpA9JaXamE5T3Z8=;
	b=AxxJgQr/cCCQe9Ci4BNr5pbSR4y4FvTQQeh5llSb+hgFvXQO5ZD26gFAaJ3222fwzBjIXh
	OeBiKVOWXJto0QlzuTxBg1DZ3wFOfLPgFILlH/HbiGySNQd0TJpN6054TE3XIAoIrsHZVP
	dv29eUOCFLQMDa2waKK8DNWN63Qupn4=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gR0dK5BqmzYkxql;
	Thu, 28 May 2026 16:53:25 +0800 (CST)
Received: from TA004.hihonor.com (10.72.0.6) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 28 May
 2026 16:55:02 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA004.hihonor.com (10.72.0.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 28 May
 2026 16:55:02 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 28 May 2026 16:55:02 +0800
From: wangtao <tao.wangtao@honor.com>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>,
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz"
	<jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "harry@kernel.org"
	<harry@kernel.org>, "jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com"
	<rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "ryncsn@gmail.com" <ryncsn@gmail.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "jparsana@google.com"
	<jparsana@google.com>, "dvander@google.com" <dvander@google.com>, zhangji
	<zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: RE: [PATCH 02/15] mm: convert anon_vma rmap APIs to anon_rmap
Thread-Topic: [PATCH 02/15] mm: convert anon_vma rmap APIs to anon_rmap
Thread-Index: AQHc7ckSlLO6TLjg1UCiENwGiuHKtrYhPCKAgAHl8fA=
Date: Thu, 28 May 2026 08:55:01 +0000
Message-ID: <e55c557e85a64e439194d0fc5ea27aaf@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <20260527110147.17815-3-tao.wangtao@honor.com> <ahbZdWDiqTCWU77K@lucifer>
In-Reply-To: <ahbZdWDiqTCWU77K@lucifer>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C8964000A
X-Rspamd-Server: rspam03
X-Stat-Signature: fjhhygtm63dr7bi4j7am5t7smn8kuyzw
X-HE-Tag: 1779958509-104760
X-HE-Meta: U2FsdGVkX1+BLofUzT0nnCDZ1OrXyw9yCRl8yWbcxWI0MSE0hPqDDJaYwBj+ObbqAvID1Tzy+WH7+c+g4cS/MAlhgpZFHNxvO9mewcZBtoXiVxVCbaDRHNoc9rYTLGdkRBRTwihI+p1QNjdGkPFWtqz5FrCAoFAKW6wOKbm3u8d0YADvQyHGi2QbGapwnmMrVjHqt0de8t5Uc9Upe8LVufYsR6VI2UB34gImiuYAG8CC5WK3na7Z6FgxAw/TUYmqC9T/eES4+G+8kLS3p+IXuNMA0YbSz/S5TVTU/nNq0NTM0u2sA1Zn8N31K6fQTmJlCZhLQdla9G0abG4CfFiKHVkQVu4KpLXPzx9DsjHxqG5pPJR2dnfLqBEwVVguRTEHP6QntJX+XsDPJSZyczGt4oAuojrg473SnDesolvdtantm7zhDA8ZigJRMvTfzpPGOpNjheCK9mtNlXUrqbafoKVsVQvOSRDBtKt32AsJpmrLbxSQ+62pHxH/Tu6TmG0CoVXtiQH+ln7cshLtmVBys+E7u3VQNSjGjiyDQhV/bxtltp0THl9x7xNiFgFga5ZowvHrncH/QR6dTdUcTSljWnpAfFpU2G4y3qCKeljfQ8xlMzfjXEb+bxKYsrprZBNknlr3bcdWXogDk3Owo1KK4Oor9HHOK0WEk97y/plOfXPMLcjPPquIs0AJWYLfXdD1hu76ewqYnqWLvLxWgvDADxUJsF3qURymaTeHuPs5jPdQd8RTbLB26gSa/sO4v9EIYnOitei1pSwR7hFhLE9T6moXQc5CMc+k8HxlfQUkCDkRbwlA7GeXpLKxg3/zjLXBz6cZYajPJ2WFwNtEjgpZd5kberyoAhNyUXBnJuCtsQZ5jEVJY3MWLi/jGLU+aPwsEB5IkSoDXdHP0KfeYYCkxonKsXhfuOLAFmY5Fvb9zRI7uIu68hzVls/sWy+NiOG2lIAv4pdHqMyUbWthcLx
 onNYQpBY
 rxdgGBYD4/yM33NXhCjlcNhErX3bFwM2E3J5I7go4rhoWVvbg2g00HR8aAKZ9P1lLfDFDino4FFDGW1/zdl6LYvgu1iZi5h83yUVlwZJx7vvpok++za5aBgedAeqfGHSGFq7/Vhmq7W7adInTato2bHAQ3CPxFOWBwm/EeFQWDnoq1cpeyAVPNoChRg1Hf9BHeniVwOepyoPmiGFk2ekfM62UrcaqmgB67Gg0iIkSZiAcbA8gbWpxhEnN0Mg/NAZQecByYqw5G6pc13GMuBiji+TzCk2uQvkR020p5jlBtSRqk6Mw3ZzEuoKwBO+Pxt4rXLlnUhFz3DQqvesGRonpisbEWmxH0+4x0yd7Bqr0oabECZKs5PfjuCAO/ZcAFpHmT9JoBh06AjESbPLAoat1HMMfmqjQfmocM7lSEiF84JYHUoOTRaXuAQR87dSEE/Drz92S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Subject: Re: [PATCH 02/15] mm: convert anon_vma rmap APIs to anon_rmap
>=20
> On Wed, May 27, 2026 at 07:01:34PM +0800, tao wrote:
> > Convert the rmap anon_vma interfaces to anon_rmap APIs to clarify the
> > semantics of anonymous rmap operations and prepare for upcoming
> > ANON_VMA_LAZY support and RCU-based lockless rmap traversal.
> >
> > Replace folio_anon_vma(), folio_get_anon_vma(),
> > folio_lock_anon_vma_read(), anon_vma_trylock_read(),
> > anon_vma_lock_read(), anon_vma_unlock_read(),
> > anon_vma_trylock_write(), anon_vma_lock_write(),
> anon_vma_unlock_write(), and vma_interval_tree_foreach() with the
> anon_rmap APIs.
>=20
> This is another worthless commit message. You're again just writing what =
you
> did not why or what for. This gives no help whatsoever.
>=20
I will update the commit message to add more explanation.

> >
> > No functional change intended.
>=20
> Err, there is a functional change, since you're literally changing how th=
ings
> iterate?
>=20
> >
> > Signed-off-by: tao <tao.wangtao@honor.com>
>=20
> All of this is terrible, you're replacing a broken abstraction with somet=
hing
> that assumes something completely broken with zero explanation.
>=20
> No to this.
>=20
Before supporting ANON_VMA_LAZY, these were indeed just simple wrappers.

> >  /*
> > @@ -3035,9 +3040,10 @@ static struct anon_vma
> > *rmap_walk_anon_lock(const struct folio *folio,  static void
> rmap_walk_anon(struct folio *folio,
> >  		struct rmap_walk_control *rwc, bool locked)  {
> > -	struct anon_vma *anon_vma;
> > +	anon_rmap_t anon_rmap;
> >  	pgoff_t pgoff_start, pgoff_end;
> >  	struct anon_vma_chain *avc;
> > +	struct vm_area_struct *vma;
>=20
> I have no idea why you put the VMA at this scope...

The vma is used in anon_rmap_foreach_vma().

>=20
> >
> >  	/*
> >  	 * The folio lock ensures that folio->mapping can't be changed under
> > us @@ -3046,20 +3052,19 @@ static void rmap_walk_anon(struct folio
> *folio,
> >  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> >
> >  	if (locked) {
> > -		anon_vma =3D folio_anon_vma(folio);
> > +		anon_rmap =3D folio_anon_rmap(folio);
> >  		/* anon_vma disappear under us? */
> > -		VM_BUG_ON_FOLIO(!anon_vma, folio);
> > +		VM_BUG_ON_FOLIO(!anon_rmap_value(anon_rmap), folio);
> >  	} else {
> > -		anon_vma =3D rmap_walk_anon_lock(folio, rwc);
> > +		anon_rmap =3D rmap_walk_anon_lock(folio, rwc);
> >  	}
> > -	if (!anon_vma)
> > +	if (!anon_rmap_value(anon_rmap))
> >  		return;
> >
> >  	pgoff_start =3D folio_pgoff(folio);
> >  	pgoff_end =3D pgoff_start + folio_nr_pages(folio) - 1;
> > -	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
> > +	anon_rmap_foreach_vma(vma, avc, anon_rmap,
> >  			pgoff_start, pgoff_end) {
> > -		struct vm_area_struct *vma =3D avc->vma;
>=20
> Don't throw random changes like this in with a general replacement patch.

These were replaced carefully, but there may still be omissions or mistakes=
. Please point them out specifically.
>=20
> >  		unsigned long address =3D vma_address(vma, pgoff_start,
> >  				folio_nr_pages(folio));
> >
> > @@ -3076,7 +3081,7 @@ static void rmap_walk_anon(struct folio *folio,
> >  	}
> >
> >  	if (!locked)
> > -		anon_vma_unlock_read(anon_vma);
> > +		anon_rmap_unlock_read(anon_rmap);
> >  }
> >
> >  /**
> > --
> > 2.17.1
> >

