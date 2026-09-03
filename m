Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA54C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A14D6B00B7; Thu,  3 Sep 2026 05:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5514A6B00B8; Thu,  3 Sep 2026 05:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419A86B00B9; Thu,  3 Sep 2026 05:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F16816B00B7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:20:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 523871A048E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:20:49 +0000 (UTC)
X-FDA: 85171906218.18.C840A65
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2743A14000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:20:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bSvT1lRt;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427247;
	b=z8GRySNv8KE8F9bU4ACqoBNY4EfTTvDo2Eq9LPcBOSdh3PTegLPpyM1qv/MR4wdLnq9XpJ
	aC57qeGVSwGXOUNBhFgRW5YeTizc8Re3toveLEVvmYKdA5AVDuwvzVB5q9KUgsUGyD6gdF
	fTq0ldfhuwtgDnMpWBPp3HEDu8hysW4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bSvT1lRt;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFqwbaUO8ajLlDZU7UCQW1v3q9ppgqy2c66ladFQ9yc=;
	b=tkJ5wLEEyFcomb+ZNYkebMPHsYg7T2Y3UScSNmApBchOKfRoZsN65bGFLdeTDZ6USC3vJ9
	7SyTeeYWhWYfNAdPEVC4muAu4LZCs22slT00T/WR2au4S1CY5iag8GvRLpB5FfRD9V6KPN
	RhYy9buZAlvusCV6dwkQPWrg7zXYdcg=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-482f2ee53e7so1307743f8f.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 02:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788427246; x=1789032046; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vFqwbaUO8ajLlDZU7UCQW1v3q9ppgqy2c66ladFQ9yc=;
        b=bSvT1lRtKKaCTLDSB7FwyF/Le6dZ45hVvGEKqhCEkvMdtH77iDx62QpE8rTP9yksvt
         cQtrMUA0lD4fyOXKmpPcuRezWGABzanvjWSWJ4lz+nTMM6SagTu80x4Ugw+MDFotmRK7
         Ok7JX0knPyKkCRsGSPvyj3miYbEu/F8J2RMnww4pjso0lvbmMxASuD6XgjcYdDzzyfgz
         Hx6s4XGluFfCoZUkEU00n4/XeWCEGEfmU+/gUzcmp3OwAhpkRKrv3FT+IM9vTMNJy11v
         XNwL4uqOr/eMFfeK6l/VUrUjgMF9JiVV/s7njKBUnOBaiI/j3tvaIlgihjSMRl4JkDvF
         SMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788427246; x=1789032046;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vFqwbaUO8ajLlDZU7UCQW1v3q9ppgqy2c66ladFQ9yc=;
        b=WUobvp5DCVuJBOY1KqKl/FrTLTFEtQ5ozUOuac4jbboAix6WLolUR/w/v9mKzvYB+0
         FQhea9xw93b5UA0JoAFKOJcEf7cIGzaXH2HLqVWvfihFyKCzqJj4L8vcW8guoWg9An6F
         w6E0c0jBcGNm6TRykWy62lhR51KvYSxjqV2XXTDFWIQX2VixwUCvIeZbmlbJEesDUfr1
         Kglhl5/66ZWv19lfW6fV4AuealMjrb1EeuVpAlqQwUIylPLanfGHLZRJssT29z79uDQY
         xCF5GISGolhF+xcbHerJP+cPCUiU4MrqKdhCmfY+exCSzqOlf2lcrx/CU8Qhln6Ul6IF
         RD4A==
X-Forwarded-Encrypted: i=1; AKwUvBzAotFVCTZRZ5jrY1t3HwxVFDbXZKvHbdKpAUZuntbGZGs1tI4ONcn1B5AIxJ7s/9oBD+M1E1tgNA==@kvack.org
X-Gm-Message-State: AFuF++kEbctkrNU3Fy+4BljMSvPusmAUbURVVEoXas8BABLoqaWVBfGe
	3Ef/3IvKScSkZ1mTrGY5XI5eUG8GBoVsLrtrSElTsFoSAIyH3YAZOIX4avPkg8Xy9i0=
X-Gm-Gg: AYBFou2lXueBkVQvr/fqN3z8bm6xeiHcyKw+3eRBd5prOold8o+NsKxuHXUH5ygOnAt
	YRMYacMwElbC9f6vlWZ77s3w3b0gw9XNiQbL/aMAwK/vuSkhgaWVPoPzq32mSN8ag80ftK/DnOr
	0qa7oWdT8fUNcgAHXBMvPUEbQoKwR4d10+TuRAkUD1aYzbas/OiWRavMSELXiNdC0p4dRM5MJpz
	/hObv8KKbu+bzburEp2cD3iBFszITenhwK/FwNrJFvYopxZGLXH+UyKtrNGNS+ArhRgpa16U31f
	Tj9YOAdqjPJ33X2hj5SOwatKDJfogdHCfVSaPWpTUFq8QUI98kTZWHtiJ/B+DE9RMm38sheXVbz
	HugkgjI5O42mAEHZCyfiyBz4tdLnqiqjHWUPtHImaRGGOy5dzg7xEaqOQIIJQxoEGL5liQg7K0y
	bhaJUCeB3MklJX489zpSKNGCW6T4LmSxTLdW7kjLIsqsWj34wxiYk184JdO+mr8EA=
X-Received: by 2002:a05:6000:2c0a:b0:482:d94e:f33b with SMTP id ffacd0b85a97d-4847b620f94mr20317856f8f.0.1788427245506;
        Thu, 03 Sep 2026 02:20:45 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448e800cfsm12140789f8f.12.2026.09.03.02.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 02:20:45 -0700 (PDT)
Date: Thu, 3 Sep 2026 11:20:43 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
Message-ID: <apktMn_hwvZwsRUG@localhost.localdomain>
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
 <aphXPCn8isUVV87k@localhost.localdomain>
 <0c5aba0f-137a-4aaf-bddc-060118322602@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="alzhxiaviugnzwzs"
Content-Disposition: inline
In-Reply-To: <0c5aba0f-137a-4aaf-bddc-060118322602@linux.alibaba.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2743A14000E
X-Stat-Signature: i97jcpiatkh9y31pj4tqp8b5uhy4satb
X-Rspam-User: 
X-HE-Tag: 1788427247-417527
X-HE-Meta: U2FsdGVkX1/5KjAH4OmX2kTmanIKn+aFt1D5rNPJEQTuo5Jd+yBkZTyiTCu82aoTCINXAnwoyY1FKS1/4iP5YZjNqinzqM3jCEN1pfc72VKoLlp2+FJiRKue6FDHeuOocoW8EAojGiel6CS4TFR0LtCtySY8n4p5hRO6WurTo52XcWnYd1N7E0C9ZIRvlmCGl7urAa1BJLSCH1kqT2lItrI3n9GuwWp6GcdwKv1IIrAsR67Gnbe0oNA9H+m/Q4VmCQdmy54lBMfz98prBos3KBoqW0Vf903s4h65jBr963Fa01BTMXuWs73uqkFLBvEp11+64OASdAPBxOWKpRFv/njbSAAwnQg9mPLz020HCu3WKGCBNPtQIdPyZ3kX9GxKEsmyqP1w+QYJbjIVBJShj6oppIlghtVLqThv+r5mOUwC/bkWoOFEv8U1UKHDB6BhYHAsTj9RMOd/Rq7LzB94x30p+znsxgXcZZG6CGpAMqBwma9raGoilH/8loRk1L2jONNexWQxMKpFulsXIkZAl6t8CtumNlMOkt03+lJy1/N5RGfd4d9DJJfQnDSvNrPpOBZuNHgMsHe57bRTqNFw6D8fCdP4qno+pQxxMemhtJDidWhUcjBhuMxAfkZCB4Bn7Vo9sk8vOVsl4gj5cDPQh5Nnu6JyHc0b/g9QdwRKwSBclbLcrtkgTvIH++/ScSgXhcuGFpYL4JFnTikeLbe4Sc47DusZL37ZhMPgUE/y5+dHiYnFnol2UDqhyiRIP1FfA332z9gmdaCuTu2tNRWxAIYh/g5jvXGwxNco5aKjdi32sKbFmrKLRqcnRUUF8gZaP4DG5I1miQYEpJ21ycs5AH0A1iKhuUJUH++Kiu11P6R9AxY9r0nVWDoxjURxdSyZOTCn3rvQVc1JNH6Kcjm3fNL7BYiQZyar4vhCWvQf/yxfpt4GCTCS02m/LcECcroALIaRGNt86A13QX2wBI1
 5NrZUMuz
 8MDO93F3LrCL7iA0c7c/H/dJBnGCw9OCPEv78Xhl/4vekdJC683BqI7rnLiWgbsUBAeba06g+YmqrgLgGIVRLF0x9Q1b6ko1++fSFcqXmUDqaPxWiChomBizvFpTnzA2Gl4FADb/9ouTaksCVZcqUeZ1xsGKK9tx1QD3WEzQg3Xuc+xPqokvuTEqI/8qbQ/8Xl0etwBWLO3qw+6vxSYe1E9YkFPo2xPgJNwJj9Fk2K693hODrCxOEog5M83oGp0QGwO5qbY5UBR/vdze4XK0F5FUk5oZFaSNMucfYTb+/EL4Ad1gN/Z2EGN7L1s+2jy98uvaW7F8UGeGFvdDKxH8YRZvkwPuPFghIYxymjDmzknvrmJkEF1HOe//iF/2frxzmNBwp/03hGSAKfl5DeMwLpsTJEX5Fqx5vjb3l1TOQYUIhX7O1vsrTkM18RzC7A4LMHLaQHwfL+0+J/NsFFi+viJROs260Mkk5QKE8rvF+P7KgWZt6WsvwF5xPhsT+sp8tQ3Li
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--alzhxiaviugnzwzs
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
MIME-Version: 1.0

On Thu, Sep 03, 2026 at 12:06:53PM +0800, Qinyun Tan <qinyuntan@linux.aliba=
ba.com> wrote:
> You're right, that sentence is imprecise - SHRINKER_NONSLAB shrinkers
> do register per-memcg under nokmem.  What I meant is that on a system
> where no NONSLAB shrinker happens to register, shrinker_nr_max stays 0.

And ideally, with cgroup.memory=3Dnokmem no slab-based code should call
set_shrinker_bit() with whatever shrinker_id.

> That said, I see the flag restoration and this patch as complementary
> rather than either-or:=20

Yes, it fixes your immediate issue and it is a prudent approach in
list_lru_init(). OTOH, with this fixup, we won't be able to learn about
shrinkers that are missing SHRINKER_NONSLAB.


> other MEMCG_AWARE-but-not-NONSLAB shrinkers
> (superblock, workingset shadow nodes) still take the fallback path
> under nokmem by design, and __list_lru_init() copying an unassigned
> id there is a landmine independent of the deferred split case.  So I
> think this patch is still wanted as the generic fix, with the flag
> restoration on top for THP.
>=20
> (zswap might deserve the same NONSLAB treatment as THP, btw - its
> entries resolve the memcg from the folio's objcg, which is available
> regardless of nokmem.)

_That_ is an important point.
So that would need a fix too, and likely Fixes: b5ba474f3f518 ("zswap:
shrink zswap pool based on memory pressure").

(I'd have preferred if there weren't Fixes: 03375203e1da8 which honors
the SHRINKER_NONSLAB semantics and it only uncovered pre-existing
missing flags. Or keep that Fixes: but explain the relation to the other
commits. (To make it clear to backporters.))

> Would you like me to send a separate patch restoring SHRINKER_NONSLAB
> in thp_shrinker_init() (Fixes: fafaeceb89a5e)?  Happy to do so if
> that works for you.

SHRINKER_MEMCG_AWARE are due to be checked for correct marking with
SHRINKER_NONSLAB. I can see that it is missing in: thp-deferred_split,
zswap-shrinker in the v7.3-rc1. (The shrinkers in nfs42xattr.c seem to
be slab-based so they're correct.)

The shrinkers mentioned in your original commit message:  workingset
shadow nodes, superblock lrus are both slab-based, so systemd with only
those shouldn't be affected by this bug.

Thanks,
Michal

--alzhxiaviugnzwzs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCapk75xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjkfgD/alsyn9uZiiCPsdyNhqYv
Yn9T8TQGEeq86BTyrTIkQ4sA/1ZoY1P6ugpHG19ZGQ2G7ElBR1IKYhR/43jXdA3B
XEkK
=g9WI
-----END PGP SIGNATURE-----

--alzhxiaviugnzwzs--

