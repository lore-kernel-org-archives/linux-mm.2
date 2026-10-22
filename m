Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A17606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AUc3IFV3
Received: by kanga.kvack.org (Postfix)
	id 12E066B0910; Thu, 22 Oct 2026 07:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE9F6B0912; Thu, 22 Oct 2026 07:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11896B0913; Thu, 22 Oct 2026 07:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5EE06B0910
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:23:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 352EAC0768
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:23:49 +0000 (UTC)
X-FDA: 85350027378.26.0CB2E91
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5A3BA140006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:23:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AUc3IFV3;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792668227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbuYOQqzgIfOAiaZGXnsrc5kralu1woOsjsJovLSjjs=;
	b=wgI2xs2sg0IoLl8swJBuwxZXhLUg0iw2m/X5Z2q2rBY0OeDWo8d9wwgPasbEf/QlB+6SbZ
	r3d9iy3UGRI4GTW/4jo8WICPR5qI7y/G4OrpOWaaItrM9rE1QiqvmuZb0i20DDKtIVOfx0
	pnH+YGvIw9Yx6+DTXeB2UR4Cm/mTKV4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792668227;
	b=nxBMcKOm/UkHUABQDVAPwVu8vyx625vwoSBgohf3vhQZzuPTUOpq4E9jFQXP3Rby+ZwMiN
	ZdhF2RWVtPPqXG+RZUtKHGJOMR3dzuFKYKtbIVIC4knBhE2oNdBjDTNK3A113ol7UJQglg
	2+jZH99odPtjDGk+wZuH4tjPksn7N6M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AUc3IFV3;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-360236b6c3cso184144eec.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792668226; x=1793273026; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RbuYOQqzgIfOAiaZGXnsrc5kralu1woOsjsJovLSjjs=;
        b=AUc3IFV3f+TGAWYvJQamsFGDo9jPEBJQu+Yto920/ofmHhjfrpaghqfrIcwXY6QRcn
         X6/0LbKaueDi9/XYXpj98zmMIIAIqE3GCq4NKW5GvgLQmex7S0xPrfmjHzUWXrcWuoY0
         LSh7YtQX0g0WsPTnYi5hgxkCEPSPFBKMBWtjrA+lBNi2aQT6+bAK/iS/60pmdGTUsmHa
         6EKfOYPL7awufEtYDNlhjDLDSh0cnzA265ZY4ypO+U2BMUpKtRobZ9+wHtmavwWCFf5c
         rwVL+ALO5EMcYeJah61txYe5s1QZnfrIbZglrpxLaW8c1Q3lBme2Qkaa7CZLWV/6JDU+
         bAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792668226; x=1793273026;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RbuYOQqzgIfOAiaZGXnsrc5kralu1woOsjsJovLSjjs=;
        b=jsQGwKJKCwTcvKFTd4X/iaOHtj8dnkF7jmLfAWb3rhTkWrysafL/YDpPZdjq+iysxY
         tiEjXgwP6GgTOAds4U/KHSLSk4v2zzDFX5p8FaHruC7O16aEetvVG1o6PI1lC70vOAXg
         yN06oKyaTub/78gcwpMaiGSUIts/VQNSaPWNJJI1oGym+KyLUwcjkUaDd1qfwn6H5it3
         aHPNlHZfQF2Kk+IS3Hw4gIIZdXiPnyVMmdbyxL/bgt4LHyHXkL9HveXStrX2nEGbAYNu
         v3+0z7gkZmzqxkmgB0LXOJThJEHGji5QnfSJoQ25v//Y3Qx0VoSHXBWSpsd0NkdPMO9G
         BqDQ==
X-Forwarded-Encrypted: i=1; AKwUvBwXkBJuKsbCW4yaHOqOMpePq+ldk0uXhPV+PsPYgd15yaSfdLgJVsaFU5CNd6quBOZ8n3jHGC2n6g==@kvack.org
X-Gm-Message-State: AFq9FYIjCY/m+1sdhz87vidhCov8M1cYMc9tFyT2JU/346Lxgr5bCdgE
	vJcZ9Gd92KF9G7njNy3X2cZ4hRp3sdyanTgblCn+V7aimVqr93/zRVJ/
X-Gm-Gg: AYBFou2GulO+tnFlVTRT8BOa/zXhQejmDtL/nLtAyP/o9OIlWEbhicRXS0cCGIsaupH
	xeELvlugXGtxvaRbf69SyRMcMbcouADJhZTajuQAX8Zlsw6xGrCcrnw6xPCsXgppdTvX0iVz8hp
	y4r7adcLz2iWtutVSGtsy5Xr1QDNsGiEMYyociVzosP0dE8B6OSt+3b72D7TPIyRuIDczz8iYTQ
	XAY9kyeeaAG4JDnvQbHJCbmk+DZ0hLzwfn9CBkeYoGrymwB94JRSw2ugquSMVdl9iHaSxl2Kz2+
	tI5vVFmzKmE/425Ekk/DZAW+BkJdt+McTTF2mZb4N29o+9yj4/HogrpugGN1jG+Vhoobcsy4DT7
	qRVJ17s/xL1lG9oaFqjwB3unsHhu+Zvlf+AWqvTM3V94PSNFwQIlvKNVn2ZjH7c92cA/EV6n4l5
	3Z8ZgonyQIxmYUs8hDyBtLYKiS8UwC1OZ/FUCZNukIr/tvdf7AfQDkm31pCh1yeBENu55OZmDrR
	ZY2mc2OeaKvUNME4mx7UP5Wsls9AIg3MTx9XglnKLGPY+UrG6BDpQgeNjdBz6lffOl+qz4Fr1eu
	+NjEMMMMwWrtcSgGuA==
X-Received: by 2002:a05:693c:42d6:b0:368:5521:612f with SMTP id 5a478bee46e88-3685522022emr5243257eec.0.1792668225739;
        Thu, 22 Oct 2026 04:23:45 -0700 (PDT)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc88b5sm16249400eec.10.2026.10.22.04.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 04:23:45 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/vma: avoid broken uffd merge on mremap
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, shaos <shawnq1@163.com>, 
 stable@vger.kernel.org
In-Reply-To: <atniL5lYyE28HSTm@gremlin>
References: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
 <179266301162.763593.1501773594946042790.b4-review@b4>
 <atniL5lYyE28HSTm@gremlin>
Date: Thu, 22 Oct 2026 19:23:38 +0800
Message-Id: <179266821816.763593.10189260302790417327.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A3BA140006
X-Stat-Signature: 55754zcwnrnisxuggkbmzbtqqitah3fn
X-Rspam-User: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792668227-330477
X-HE-Meta: U2FsdGVkX18lp43I9J1WPSdIhuOGLc8AQlJrmCuXaMxVZ9wa6a1amO7Ab4KiyGVXMN0vT8IQ9yQi5HCXO+OFgMKeuZ0zmuYzlMYc1zRyQWScU693sM+bCgSmAs12lLeUo6WQjhFZ9EQoDCvzuXx3VwlaXtoUvJsp8cOMup56pWTmTkBOpxfprI01RrMuJFPAItR2k+4h2qb5Tlj1/SHkqKQVR2JeR0JME0SEorQ058zyaJ4o6WFYMRwm0APn27abyQdpevSVMiMuKvj0fgNOToWDAOTfdGqQ6u74RFxobYe8Jc2kVKu76p7bYVqqhTz1d2vM2LYMHLMLA6siy5B12XEr/zKE826Pne8PNfAA/w0yUOohUR9dDD4axduBE6lvfunzNrszQVLz2pxaY6V93NJHlcfGTAgQXO4GlmaCu3YXuNOuE0MAO3J0eywfj6jnYl7fxHhaWKLogsk7l9jcwD19X9Kb8XNFE94ctNTi2RRG9z07UJSkaZqtHBhZKHD6n7vL1c0Gr2HfrJGNtLVw5aYW9f/3jluxR6bCJZ804YXwzQEhgIOQHgWdiH2vsuvFTnR34O268Vvc/JnhdB5m0VK7FqP8USgpxEBCvv1FRZ2PhuCeWA8kOaZHMUKvMia3QOu5tWSPAuoVfoyGRCYzO36F9/JCNShVHb91N2Lrpz3YraVLTrW8sw8VQhV6Vz4TEZjIioDdELTEmtmlgvVTRPklsDFJbAPaRh5fpeNuGVuavwkOJ22kHDndKtXt7giWeQT0ZIEKwuCkcCRbgkgWof9Wn1TuHlitd0OHPbL4uQyf6MW0rmxuhYZA3zupz1HnJrhB0uAiMX2GuT/tcFcE/EPgxB3QfXB5vlChBdbRdkxBzqoVuINN+Kjpsqr1F2zZ2KF2vN3jbi4wAkCQ9LRr8MNB/Twts73TEzgyvQauCdrySk5ctCftmDDQP2K5laSIphqzGo1jFrF0nPDrPE7
 9k3vUkCR
 50CylDogJ9jRTe7Vexbd80Wm4oDoENC00nfzE5+gVPeijCwQ0ZNZEg00pmoRmpA+w9pE7ZFCC1c+gArfygt4FUm1r4J7uZUwtMKZwe7fZrDCcyd3dflm81WbSO2XWPtqlqIVWZsVdKMGh2zzWJWchLiYu7gJPnnePnWsSnz23n5OskC8iX6zWIu3Ky4OaulO+abgs629WmQUSbfmW2SbUUcErlvvXBNNxCundUquL7++x4k5/UCc/4+hg5SEhqDwmpYiPYGxfprm4gKOV0aJZ8LHFb6f3TkmrCs0r8twi7hDl5ZHthH0Xysg0UYUG75AkOcDzOAdi6jadLzXzxmUx4F59amu1gqzVcl///IB85+Cq/ll7+Hp0bgImg+L875zUzFX1Pr6rzx+9erVjXQB7Lj2RjycI8fZjAuRg1ajzoGXNOarJScR79A5HfOSzdn+6PGN4koxPZURlKU026T37522CJnRiKvHxRTre+IlcIJx7F7RMmWcGuMkJEsRWWUD6Np2WkPWmzGnRETs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-22 11:15 +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Oct 22, 2026 at 05:56:51PM +0800, Xueyuan Chen wrote:
> 
> > > diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> > > index be8f5161f92a..f786a585caf0 100644
> > > --- a/tools/testing/vma/include/stubs.h
> > > +++ b/tools/testing/vma/include/stubs.h
> 
> > > +static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
> > > +{
> > > +	return false;
> > > +}
> > > +
> >
> > Would it make sense to have the stub in tools/testing/vma/include/stubs.h
> > return a configurable bool, e.g. uffd_without_event_remap, and add a test
> > for the true case? The existing tests would continue to cover the false case.
> 
> No, stubs.h are for simple stubs.
> 
> Changes like that would be only be made if needed.

Got it, thanks!

-- 
Thanks,
Xueyuan


