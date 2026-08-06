Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB328C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E126B00AD; Thu,  6 Aug 2026 05:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F936B00AF; Thu,  6 Aug 2026 05:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E306B00B0; Thu,  6 Aug 2026 05:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5E56B00AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:22:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 004B112067B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:22:22 +0000 (UTC)
X-FDA: 85070303766.21.8C9230C
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B39D8000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:22:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Fa1iucpS;
	spf=pass (imf02.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786008141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pcnhqt0EtUylxXGbjqsf+1Pc4DS5YZiCgI0VutNek2Q=;
	b=n5j2xd7+NGMWXyhPAp5wFH0TZcrUK8ImUmC/tNdCnRB2oRBcjIDDVrPWZA51qhfxiBPSoI
	FBxiFH9jKI63YUT92tv5Mc9aVq/VGBmHMcX6wCJP97n9pPMzc8AO+GvwgfS5/ItxYVQFt5
	C1Xsv5wXnBZeO2WVjFI82El3Ck2M8EY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786008141;
	b=YKfyuvpqR/Snq9YN8qRJsuK7wPrLRSGve7fTQTTEuADcyy3+ccM8vcyydy1Y/G5RlGkcCb
	oRvmYHxDcf/GkhEiE7GP93wIef2r4D2Gk8bZv3uTFVjLGMGoK64BhQHMexh5qzPBb21oCy
	1SoE6VdSf3sYNMBa3598iooSu244588=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Fa1iucpS;
	spf=pass (imf02.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-472326ca506so1329682f8f.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786008140; x=1786612940; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pcnhqt0EtUylxXGbjqsf+1Pc4DS5YZiCgI0VutNek2Q=;
        b=Fa1iucpSpitEbW0Dqkmumb2dtaNjMQl4AQFCFyvQqcLA9A1zgYYZc+NYy6vc5Hv7Ih
         khG0n9BV4O3nKrNU4MJ3uTEqWzQmjayEP4GdDo33dkvBTB4h4cxlaEj2J2sy0B7NS6Uz
         EGUSiCQzKdcpb+uvHev7rB3vhG3SJC73Mqka0he8Mpc+5zl1QEraw5wOMJzsEXPcrKUx
         zC12jy1htVgTbdl9q6HQ+7bRXCo05MXuAhsCFUkUrM0amwXv0ZgPm9/D4a/Zwcoti3Lz
         Mk/JmZTL9Lb2EAnp27Mkn7ncyrugw4zng7OE0+bBQbEYoRgvO/lKIde/3s2DgaG5KWVY
         Q0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008140; x=1786612940;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pcnhqt0EtUylxXGbjqsf+1Pc4DS5YZiCgI0VutNek2Q=;
        b=qk5x0p4seNlSnwQRcTg2vc4IvLSvzRyBytgB7hwlsVgO5O3SLFdU8fADt8gon8A1xW
         zh6blppNoP185dfs6xwzZgfkYEHIgw2BaajjRy4HuU3pbA/FLmd7SjSHvvQePDpCxCbE
         n97NvDKYix5WkcYazO47FWxdMUm3GJZ41hEy0Ox4pXO8h31RpgdjOUAM0Uxvx8FZiTGn
         so7pRR7sphV0Wtf4Bg2Xnrk7Ul2IO2xmc7egbj5K7mGWuBamIBWiHlrWyUa8ShPP95s4
         g/lyvZgXlPsWPqd33q5f7kt7czpf5AzLxG0OBNYiHNqsYLpib+dzhPwYhfsTAeXY2nQj
         nuDw==
X-Forwarded-Encrypted: i=1; AHgh+RpHtGrM+tyK818pQlqFDa+TMA8qjmJvfsLiuPsBIzAr9qNxwVRY3X+noSZsUovdM7i51czipJc8Rg==@kvack.org
X-Gm-Message-State: AOJu0Yz5BV3XR9dubVousoRqTmZHQSHRC/gHqbrWAUhdLE5HJ88Tpkj3
	FrN2oeKB55cMKFNpsNdrUX+rz9cjrMQhpnJH+5A2T9vFuhmYXvw+d57H34oOdSUpWPA=
X-Gm-Gg: AR+sD13jhUPFBj6oCHFxxPxCflDaUU01N8kkd2c6ePlCt3pc5VBi7/XFsKaj9KpRlXH
	eS4ByFhOB7aFeVrbbfUE2T1EoEVd8JybWmQGq2MeGDQnKWZgepxrWReeRr/IDco5aHQBS15yqJO
	QVTvaui07KSt7uV1VLjcZsFpaOhsXicWSqPflyr8ZkrMAS1ALhCoWj3sRUb737i63znjLD5oyiC
	Ti+7g/S1OqY6WI6xLsoRymbwBcr/0txx1As5azyl2XjTbMCbh//NW08vMbmpwyrPYJtYCG0AAwH
	eDou+IrJJSmlnc4v5QEtacEg/d+QLfe1mmmjIzEkgeXP8aV3LWPl0qdfhSQuj2uZVLPv7cTZNkg
	RHK6bQNwH+/lnRD81FdDFLcSO3fT0Vj7aeZoSDGgo8MNsHg6j4fe2UZ953rHkmhC+9+cdi2qgy5
	3EfV1o2gEn68QdydcAV56GoYzD6AO2EI61GQNuScZzWM1AlEO3r4Mva7vFM4n1yTC/
X-Received: by 2002:a5d:624a:0:b0:47f:9750:26cc with SMTP id ffacd0b85a97d-47fec630b5cmr16574414f8f.23.1786008139632;
        Thu, 06 Aug 2026 02:22:19 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm4112794f8f.33.2026.08.06.02.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:22:18 -0700 (PDT)
Date: Thu, 6 Aug 2026 11:22:16 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Yu Kuai <yukuai@fygo.io>, 
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>, Tao Cui <cui.tao@linux.dev>, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-ID: <anRPSKHWo59GPIA0@localhost.localdomain>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-3-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ltojthlavrpt3nkl"
Content-Disposition: inline
In-Reply-To: <20260804065313.2092022-3-yukuai@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 13fyscknqbpb1758tkh77xzfhcagyiti
X-Rspamd-Queue-Id: 1B39D8000C
X-HE-Tag: 1786008141-29217
X-HE-Meta: U2FsdGVkX19mWFObLGKD2blWOQKLupVKb5J27PZfB6+20iXK9AsMb21ZBGo7ckWQEztcmh3EqtqleurxHW/090OXqLtG7r+8fAOER8s49wxvvsEObOD1MZbXW6zsePqnpk0eWuxFidvAlvG8yfJUQ6xaaLtnSiJRnzgejBGKlXWZrmrBp3biOFJ1JrqzpI0OkppfGsftlIVASEdXvS3LjY57eoX6Yfe75vOjnD4bwYNllUxs1tw3eZh16gwuBy4Ooi6shgrpqcuy6RGXITGimNKCW0QXcjBlvCStCg6hqfBrTqrhgW5cgxr8b3mjUSFjDy1zu+/bH3vgvUMsxUZCK/JMeyf0w+FyDklzWm9MxVw8BNMnz3Kw4olJOqUK8FMJk/0YNpAeKBQwEsJ2PzMv8u93SvLTY1m0daFbuaGIkVEtJtlfX+otKv57NXtNG3osAIglVWo9BJ4MPAC+wRuumJWNpEOP+DWP1l0517HBFBH2WaYuxzuocOSyrX3Qg35ESavyfO+4VipHTZMmoN1JRvnBWZxnmMF3rxnSDI314r/f8RTtagiR9xdxyS10ezJFat/UgFnKtIA/ZCmY72kGV/zihJLAzaxMcl9eU/eFGb+eXXpwqy35+RJVNA+W4MpXU9HRlg+J0muIsY/TNpGw1d6H/4I+eelMbVJdoayNVzOInlrnW6SsVPXWH0pFdTsmyJRY2fXnv/wdh+Dts4TQDK//XldRB9vcwqBfzhpLyIRdVcLqWCECKij4giSfcGTPqhTHc9z6Y74sk2sw/0mo3krVuHN4mL1EUZ+QfNepXYiM3Xua4ewQ9bbPj5JNalwxNopG0T5R0RnIqn6nj8IVfVJrEW0NrQfWsZ2/i4mKhUxis2UTD4DdGHsBgLaqxCMXolABkvyqVxxeiVyfaBiIIzmrdD4nnymnioUlfTPhbxk/eQiPh0+fCobbhyL6pni674TNtemVGtyuqWYvDWO
 5tmr408W
 Jkyc4JvrNiLtTooFkwAYZYzTW7a4a7lLXv4CUr4mWwWCfQ8rdTKulm/wu1PXReqsKmsMSNU9NIMJrJyGwvRB4MEZ6iRxJIYiJ49W9R67R16m1gMjVIio3GrfpWD/42pmjuJykCt8byOlXg+0sC+31E4m+Sr1AEna0J5336YE+FeJHrM1GbjJDiLnABI/96u4dFULlMTJvZqjwFoVRPdq34RBGRtPDX+iWJF8+khM+QMTKEmLxeHV1e71r40KDZtUn3CkYrZNGJloU5sMVV6kmGbi+O9KCQmUWvncosHC9FjVVF1LCI01iVkIlKTJ9VuCtrt+Wtz8nmdvAFjfJH1DeMnh2z7DMEg4rVqOr5nVVuujTo8+sGyT7bECFMfnRsDlLD07v/0/ei+gR/ymKuPlCLLlRVO86pugRdPSYPRudq4lKxHkQP5piA14AtwxUnf82eW5mV1CxNAxxHrQB7iLPnx6grWdhHGqZyQrqem9Ba4KrILvcGbDmjJdKmeaAfQtVuM0ZD2bsRJ2A+lO1llyXA01gjrUgM6Vfhpm+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ltojthlavrpt3nkl
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
MIME-Version: 1.0

Hi Kuai.

On Tue, Aug 04, 2026 at 02:53:12PM +0800, Yu Kuai <yukuai@kernel.org> wrote:
> From: Yu Kuai <yukuai@fygo.io>
>=20
> A bio currently stores a queue-local blkg reference.  This forces bio
> association and remap paths to look up or create a blkg even when the bio
> will never enter a blkcg policy.
>=20
> Store the blkcg css association in the bio instead, and derive the blkg
> from the bio's blkcg and current bdev when a policy needs it.  The first
> successful policy lookup pins the blkg, records the pin with BIO_BLKG_REF,
> and drops it from bio_clear_blkcg() or when bio_set_dev() changes the
> lookup key.
>=20
> Keep lookup-only users from creating missing blkgs by using
> bio_blkg_lookup(), and rename the bio cgroup association helpers to match
> the stored blkcg state.

I assume this should be OK due to limited lifetime of bios -- this would
not lead no possibly indefinite accumulation of offlined blkcgs,
correct?

> -void bio_associate_blkg_from_css(struct bio *bio,
> +void bio_associate_blkcg_from_css(struct bio *bio,
>  				 struct cgroup_subsys_state *css)
>  {
> -	if (bio_blkg(bio))
> -		blkg_put(bio_blkg(bio));
> +	struct blkcg *blkcg;
> =20
> -	if (css && css->parent) {
> -		bio->bi_blkg =3D blkg_tryget_closest(bio, css);
> -	} else {
> -		blkg_get(bdev_get_queue(bio->bi_bdev)->root_blkg);
> -		bio->bi_blkg =3D bdev_get_queue(bio->bi_bdev)->root_blkg;
> -	}
> +	if (!css || !css->parent)
> +		css =3D &blkcg_root.css;
> +
> +	blkcg =3D css_to_blkcg(css);
> +	if (bio_blkcg(bio) =3D=3D blkcg)
> +		return;
> +
> +	css_get(css);	<---
> +	bio_clear_blkcg(bio);
> +	bio->bi_blkcg =3D blkcg;
>  }
> -EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
> +EXPORT_SYMBOL_GPL(bio_associate_blkcg_from_css);

[skip to next comment below now]

And here yet another (any) reference to same css is taken 2nd time.

[skip after next comment below :)]


> =20
>  /**
> - * bio_associate_blkg - associate a bio with a blkg
> + * bio_associate_blkcg - associate a bio with a blkcg
>   * @bio: target bio
>   *
> - * Associate @bio with the blkg found from the bio's css and request_que=
ue.
> - * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
> - * already associated, the css is reused and association redone as the
> - * request_queue may have changed.
> + * Associate @bio with the blkcg found from the bio's css.  If a blkcg is
> + * already associated, keep it as blkcg association is not queue-local.
>   */
> -void bio_associate_blkg(struct bio *bio)


> +void bio_associate_blkcg(struct bio *bio)
>  {
>  	struct cgroup_subsys_state *css;
> =20
>  	if (blk_op_is_passthrough(bio->bi_opf))
>  		return;
> =20
> -	if (bio_blkg(bio)) {
> -		css =3D bio_blkcg_css(bio);
> -		bio_associate_blkg_from_css(bio, css);
> -	} else {
> -		rcu_read_lock();
> -		css =3D blkcg_css();
> -		if (!css_tryget_online(css))
> -			css =3D NULL;
> -		rcu_read_unlock();
> +	if (bio_blkcg(bio))
> +		return;
> =20
> -		bio_associate_blkg_from_css(bio, css);
> -		if (css)
> -			css_put(css);
> -	}
> +	rcu_read_lock();
> +	css =3D blkcg_css();
> +	if (!css_tryget_online(css))	<---
> +		css =3D NULL;
> +	rcu_read_unlock();
> +
> +	bio_associate_blkcg_from_css(bio, css);
> +	if (css)
> +		css_put(css);
>  }
> -EXPORT_SYMBOL_GPL(bio_associate_blkg);
> +EXPORT_SYMBOL_GPL(bio_associate_blkcg);

next:
Here you take (online) reference to the blkcg->css.

[return back to previous comment]


after:
Ideally, no tasks should be in offlined (blk)cgs, so the `current` would
not resolve to blkcg_css() returning an offlined blkcgs. OTOH, it's
generally good not to do _new_ associations to an offlined blkcg.
Which is why I think this logic would better fit to
bio_associate_blkcg_from_css()


0.02=E2=82=AC,
Michal


--ltojthlavrpt3nkl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCanRSRBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ahf+gEA5FtU8iXyQA9tlhJdWJEf
nyf1IBDUt4tisH7UDE8KiSEBAP5BK6FXkSftml/wn918ol1iwizfBzFhephd2gZc
e3UL
=GgwG
-----END PGP SIGNATURE-----

--ltojthlavrpt3nkl--

