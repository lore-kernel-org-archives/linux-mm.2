Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE86D5B87B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 00:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8706B0088; Mon, 15 Dec 2025 19:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955726B0089; Mon, 15 Dec 2025 19:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855E46B008A; Mon, 15 Dec 2025 19:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF386B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:19:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FC7C1359E6
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:19:01 +0000 (UTC)
X-FDA: 84223424082.30.4D54A42
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3344D2000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:18:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g3PPCepM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3caVAaQYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3caVAaQYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765844339; a=rsa-sha256;
	cv=none;
	b=hyYVL/RGw2aH60fYMrbo3dq9ZCBChRB949LT04GJQm38A2EsJVSky5CXBsBsVwFX/QBSLK
	mQC7kOtEcGZi0lNW9BfHjlYr4ElnT1156BmV3O6ehXJ3ovKAX/Z+LgoFSHRsf7gmJT0rNB
	90WyOV6C/WzEECRzD4Rv0XcN5WGj+zk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g3PPCepM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3caVAaQYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3caVAaQYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765844339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2oerIBUWdoiR/iDg/DmDggDlh+UQ2iDCVQ3m0zhhek=;
	b=pUgopPT0VeA/nUUHTngjgtGjDCqcx9rebgyX0NGnmhsooPAMDGc6UQHYNwEeeJNZSLQRWA
	IUNej+Tug3Z1Aq2KRPu0UqoiY/xrHQPKwk6xm9Sn+fxqdGXky0XD4i5mHnTQL9iRUjPoUB
	MZKe8rzVMUwTjBgJ56cxeXfwPZUKCRY=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a13be531b2so1623105ad.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844338; x=1766449138; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x2oerIBUWdoiR/iDg/DmDggDlh+UQ2iDCVQ3m0zhhek=;
        b=g3PPCepM1Edd3E2c516CMtsRVlzxE7M09+EkZNSi6IiHJP1rZdnkhs0QFX/SWyfk3f
         opxQ8O/TASFmF/vecLf5WgmmqZqn3KF53IOXl2LWJit3veilONtRDIBUQnVH7txN6WYG
         P1c3Wo1Vy2jQxSzvSP8SLxw7qtY6TCpWTj+CagsavQ6jvT7tApkDkCmeSs8pG8jFMWtG
         Zk+DbkGknwcC1ZXAmml3/TXjK/vwoDrU5AGhUMLjoQGasvgQcPN0tyW+gkIiL+wNp5ds
         S/8Wy4X6VXoilIQ2Tur/yQ1V7d7IMCuzxZc419Eyaoq1uMKd3E4iXUL3NVOwa1G2Q4ve
         F35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844338; x=1766449138;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x2oerIBUWdoiR/iDg/DmDggDlh+UQ2iDCVQ3m0zhhek=;
        b=jjoa3qTojmCf+aQQ1RqD0cMkKrXVAlUkp4Roixcb/fkWWIMw3PwHvsvcAP7K5ZTD6Q
         kOOPdFc2rdZyjj0c2d8+Cd28XIAvuBHU6SXT5lmBfxXsbWyJhwdmpDt3cCclkmqdo9+i
         H4aPYXRLPY8/WIJmvVv0T87tPOtvQXSCrGjXKyH0cToaxsu6Fg/iOLG+HW/8//ub+Uvs
         uS4qkkdbC2UoeorbKX6uLJwYPgJ4LtplmdDJWrxyXdTTg42x4TBi2myic8OF0hq0s+3w
         yJZdgyyUpQ2c+hMhN3QvjMx/gP2uB/6qOpnXgpQccVCBuoLm+5du9v2R2iIN4nLQgNFu
         aYUw==
X-Forwarded-Encrypted: i=1; AJvYcCWUi8sGEI7xTezkwKLGAMIShsHxHxIPwcasPZdQPMcJM1hJdDJ8cIxRIqZ5zn+lOh+uxDaRLf0MKA==@kvack.org
X-Gm-Message-State: AOJu0YzpxzGMVwdfl4gFDnzlAqjp/Jw8/LGrAXrKowCMAL1Lmt27rn85
	XwYdEZ4/ha8YJJH6/ytHwC+/Oy5+PL2M+7TfS2GwXcu+xs09vrMu6hhojk9hRo8Pdud+7sy+Euu
	tRDTkMQ==
X-Google-Smtp-Source: AGHT+IEWAD5o+jOHDqlEeD5qpWYrl9uWEbLiDfCND9UBUiVYMl3ijPuTAanLZR/4J50fvr/IM5bDgbUTjCY=
X-Received: from ploo12.prod.google.com ([2002:a17:902:e00c:b0:29f:b21:b1c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cecf:b0:2a0:8df5:2f6f
 with SMTP id d9443c01a7336-2a08df53433mr95353555ad.15.1765844337858; Mon, 15
 Dec 2025 16:18:57 -0800 (PST)
Date: Mon, 15 Dec 2025 16:18:56 -0800
In-Reply-To: <CAGtprH95s5wL1=rSSpG7Cmj5HhJOftwJY7CP27WE-qmq7hr+XA@mail.gmail.com>
Mime-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com>
 <20251215153411.3613928-2-michael.roth@amd.com> <CAGtprH95s5wL1=rSSpG7Cmj5HhJOftwJY7CP27WE-qmq7hr+XA@mail.gmail.com>
Message-ID: <aUClcGHzJK7PyutH@google.com>
Subject: Re: [PATCH v2 1/5] KVM: guest_memfd: Remove partial hugepage handling
 from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3344D2000A
X-Stat-Signature: c3bh3y7rcdq6eqsbkn96fc3gfyhosrf6
X-Rspam-User: 
X-HE-Tag: 1765844338-471620
X-HE-Meta: U2FsdGVkX19Q56LjIy4NNxtjI8bTbLiBQ+ruhNVRjU7yTvJFgqI2uspsnBBqQkF2jCPpEKrPhtIyj0sXkTrxM7rVGxCVekFPPgL0sJ4DL6MlPuCVj1NSL/C7Zr0374hDQrylHHk41QU0qNNWXLr04a3kZBENHksNc9VQzU3wol8XN+9uhTtmCOR+pEpD208dE6woAjA4U4OGCPMkLWd+flc89HwTF4ljSV3R4L429E7H7tCCrl8Xgtu9yXtzOcj9c/KkjGe7owLgJhfkHg7w6YEzCzx3Uk8n6UkYOLrECvOmbn9a1Ali+g9ckZ6QhWmn5XgE/1fb6saKfNCHUi4xWe3YnOKtvoxmIQxs4nTdBH8ti8OZmzXi4YlvJhvdQy+EijJICy25mtNGs17dqoFiLvaryVBcNcniW02slAQRvrLbMsDuXx7XYsqojsbaL0ak87iKxRWNYoWrgu+vx4kUeW53z2vpaChs8vyiVVOgw0VgxXcAZnWdUSS5iybZxPm5O2IoDRmEGKkCHSpdtcXZxjIXs+qEo43dt44hgbxdrBkiNIbxBvi1d9WngOzrg6jOZ6AgG1FKwRmYptVhG/iXhOcxtHLM3XRkxGQ4W1KlUVLdIgG2Y2VZKQ6F1+1tCVc3mnPB5qwlYtg7kBA1ThGcZnrIp8kSAoJGm02gb8pBYMaiJD7S57m/AB8vIJjRh9smYTM3FgY87QoiQpmfeBA7+WaPJrrj3i2R/dxFBwzrlPA5uHbFg1CJJhpPXmVblL71U5Vc0HO+ilpPxsgfYqy9AvpuiNhuYljaXL6fYzESdS4YIAXE1FLlv7HRQDioGMZdbDJbsZgyuKz+sWqjSfosvubk4SAvf4MHw5zZik4NPs5szs6R8a1+Ty3hF9gjP0c9KYh0P66zYh5z10tGLyMaL3af3y2iMDTfR5JrIgbSTXh7OJE4guzwVXqNpKpknFVm38VsqEA9hokVhTbjV4/
 mrPM6AcE
 478KS1ICJMq0HLytJIP/CZPaz0uzKPpT5n+wGbRNSkPSyJdI71xKQXpi7vg6Bbmt5KxY7Qo7tf5f9u0i/+1/pxLpOzMgDX3bGHnbMA3Y/cr0KDOJTfztKvjjOzZRe90rR99JXNQTrDQDHvpW38qAKr7oCipKRdJYS2iKZLJ20c7qNYR7PZmjTxKk8SOADIoi2VpuC/3z+cF52EUQJloNbLCWBoXhAcuVfDaIe8J1Qa37HGC3gThlI1QId2b8zJ4YKQ4f0MLHBQ//HPxE65Xng3UqcuHhS0p471gpXcAL3lxp7aU3NYUdGvYOq2WDFHHVzDtQoJzjkWbzLuyZIS8MvOHNXrdihtMNObPA7+TXwdy7+TIrciqkbsOtc7/Eifxs7dTD42H5hUMkKI/2NNTeB23TS3Wll4xBLQ/XOdQ/3kAsmp+OZoZXnSLCmm+NNyB5evtS0Gl/dfclAaaPIFgPucIGKgZpnKLgZmS5Np8SKMfFrTlF946vN8heeKS/iSFyTVGvtrMfuBXVhauJZhNV9TGXxd53denH/dK4BJCX2+B0LPqf+DDFhhWBC2ZuDP0o7JFG+LrunNXlYRF6eBTSZr5mLOvXrU/vNgK4Ugfl6sp19NIUkLXlRq/2+0mrz1PlIAFZT8xTM9goA02k+KDysSy8pS9a0tbasNvf4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025, Vishal Annapurve wrote:
> On Mon, Dec 15, 2025 at 7:35=E2=80=AFAM Michael Roth <michael.roth@amd.co=
m> wrote:
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index fdaea3422c30..9dafa44838fe 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct ino=
de *inode, pgoff_t index)
> >                                          mapping_gfp_mask(inode->i_mapp=
ing), policy);
> >         mpol_cond_put(policy);
> >
> > +       /*
> > +        * External interfaces like kvm_gmem_get_pfn() support dealing
> > +        * with hugepages to a degree, but internally, guest_memfd curr=
ently
> > +        * assumes that all folios are order-0 and handling would need
> > +        * to be updated for anything otherwise (e.g. page-clearing
> > +        * operations).
> > +        */
> > +       WARN_ON_ONCE(folio_order(folio));
>=20
> I am not sure if this WARN_ON adds any value. i.e. The current code
> can't hit it.

The current code _shouldn't_ hit it.

> This note concerns future efforts to add hugepage support and could be
> omitted altogether from the current implementation.

IMO, this is a good use of WARN_ON_ONCE().  It documents guest_memfd's assu=
mptions
and/or limitations, which is extremely helpful to readers/contributors that=
 aren't
familiar with guest_memfd and/or its history of hugepage support.

