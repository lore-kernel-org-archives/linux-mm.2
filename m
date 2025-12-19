Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0796D78786
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D166B0088; Fri, 19 Dec 2025 10:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510E56B0089; Fri, 19 Dec 2025 10:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427C36B008A; Fri, 19 Dec 2025 10:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DFB66B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:13:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD5331A0213
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:13:42 +0000 (UTC)
X-FDA: 84236565084.15.A6C935F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5FBB3140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:13:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g2AK8cSa;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766157220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQ3vOUUQ1NjGmI17rM2LbdHZ3220JBGGJd5kbhGRHEQ=;
	b=poFGKGcKqEZ5AFbwFMlQCi0Nwf5LU+5+VAeHpfk81dFxeUdCMePy3uPNF59QeIvMRghgCz
	pDx6pEcdNae8upHPj6tU0jFEvpMynzuZAQkufwjvl1gW/QUXPJHa9GHVJ/RUAyJWUMsnrA
	0j4k1OoFwt5Ic+88fqEikKY1zTcClqI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g2AK8cSa;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766157220; a=rsa-sha256;
	cv=none;
	b=SarxOH7noUWbQwcsW4XuurSGdoIV5BEUGu9HQ+4lnbYdCZYjwv2Kn2zl3nDiX5UtjT7ykz
	EB6gMxVSq83/dGlPkF/AuQZa7pSm6O5ZOsWsEyqWsFWJa6wEA0cRZmBm5AzBAQlpDTiOg7
	iPvM6uDvY6TNWyzyDb8ZVxY7HefTsw8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766157203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQ3vOUUQ1NjGmI17rM2LbdHZ3220JBGGJd5kbhGRHEQ=;
	b=g2AK8cSaoA2KOXtElvpGfbrUjkGBTjf7A0rAZd6uYXsDLtuVie3ud2VHr+fPyomu6Qf/jC
	E4VtbRAnqgJooPOd2ecuj7bac59778ilRjGi0L2iDJl45bJEtJ+z4q/+ao/Jw1KQnN2a6o
	WnL89oDfmYBdX3IByJU9HVi5Ls6W3L8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-oCsorKl8Oh-DsAnIu8wSIA-1; Fri, 19 Dec 2025 10:13:08 -0500
X-MC-Unique: oCsorKl8Oh-DsAnIu8wSIA-1
X-Mimecast-MFC-AGG-ID: oCsorKl8Oh-DsAnIu8wSIA_1766157185
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b6963d163eso420292785a.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766157185; x=1766761985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ3vOUUQ1NjGmI17rM2LbdHZ3220JBGGJd5kbhGRHEQ=;
        b=nQ6jvqeYlKxsLhN0K8Fhrf0uIQDO+jAbYZrIoMM2sEVB9Bev5CD2I1oKObThCNkQ5A
         FFcMUN2t89XBOKWbzfdWm3fNvoqt8fkL1pL1uE4ss7kz1fj1wHQLIF5wKp2LMdaVQkMh
         ZP7zOx2el4y6sgAX45SkFuS4F9TNPNfCnGiS88dKXndl/uvI9hndRdVuPBikvkJrNvaS
         ThuHysp9yBkMk+JBFHYkFmHO3yv0Bw7Sz349QvPuihMeKOGKFd4wzwOcw1YWmeDYy/aA
         95qrNfAb0BiGFo2zi1Ui9rTZJRgGP5SBO/577YUR5HSnvs/mfdwVdCsCe8G0rp0HTac5
         nZUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEFkqJ4bhfWbUknePlo1IXTG59hKk/elRzGXZlsz+m5/KxwoZwxgv1xdJyPPcrhemq5gZedGl+xg==@kvack.org
X-Gm-Message-State: AOJu0YwrszRRV92kT8cK2GU1JIm5En6AWS2GRv3rVMn0TBqDeKnLITWY
	hdRud8CMoT6Ri/jA3aRWHnQ12QF7VSOW8xq16Bze+qXObYzQxXVQDJZ5NUj+qzMyg5UyHBfP3zB
	Xj7ckrIqe68qKEri49FTi1EhMrv0sGYra1UWq4vewhuiavNaAJ908
X-Gm-Gg: AY/fxX6z0zkfAxs1FwJTfusdQ1L9NtmGChxSjwBtxvaSsGmO/eeDJB1CMgBFla2e76X
	2GILkrRePzby4FJs4wVkhS05YfdpwYZ9Nn6oK8N+RNkOP05wtOAHt2u9z9ghv2u8ux3YdeGMZLJ
	HX/W1oxg5cWUMaQ+hMX7wvk1jPgob/PAFj7sU64ED4UakGuo32RADmFaHaolDpDMtDtMBNhHYVp
	8KpqaPI/r/R9vsHR3sou7ir7OaryI2hmurjCCh+65nci25hMdYESCg0DTMEpAEbpfx0uvlssN3y
	3iCkZ2mDcD9PDCmqnrZdnh8c6qdww3uKLiNjFpNU1Ujl+v9zUMO85+wtnXJ6eVvpTpa39ft/uQs
	PIOk=
X-Received: by 2002:a05:620a:2545:b0:8be:92e3:916a with SMTP id af79cd13be357-8c08fbd08c5mr525924685a.88.1766157184857;
        Fri, 19 Dec 2025 07:13:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEABygr+TjXx8kPMcVgd88EC2i1KOIT0Poa6j5o9tNZ+dAjo/xEl7EzQTikQ39L491y0GI2Tw==
X-Received: by 2002:a05:620a:2545:b0:8be:92e3:916a with SMTP id af79cd13be357-8c08fbd08c5mr525917085a.88.1766157184316;
        Fri, 19 Dec 2025 07:13:04 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0973f28e3sm210526485a.45.2025.12.19.07.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 07:13:03 -0800 (PST)
Date: Fri, 19 Dec 2025 10:13:02 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUVrfs1w6Sg0jfRw@x1.local>
References: <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
 <aUG2ne_zMyR0eCLX@x1.local>
 <20251219145957.GD254720@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20251219145957.GD254720@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SemwJSU-xRjKPCdscNeujnJFVCCMAeFT7QoBdwPbKmE_1766157185
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: jmwirnjhdrh1dhm9jenseqkrrhd6ejqd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5FBB3140006
X-HE-Tag: 1766157217-414511
X-HE-Meta: U2FsdGVkX18ylR5qMiNH/pyEiN9QRLRPwJntxqhuckQio+2entWz9wSo8ATX95dvjF8zKpjPoinAFYIMywFaBxI8S2hofdEgHSLlEPKWM2sZs1o2Hwc7O3a/dvhxocpUPfLS7NNG7upWRVyMSfuDwi7bv6KO+WfFynx/ZzFruhzfXDe1nNR0xHoRniMGVgNF30qmGRaeyCxkcQsG4+BDeyNFQmPq+G3js4b2xkHROgSYxFEeJVOvs2UfoK15vtYlKvTK2qXVGS2HWMxw6eobZ0HOp4ajFtMwDkAiBEGLEUvHyXNjF2oRVN9SUXzh5KjzWdYVfeOeGjeLfnOO6ujrRhKCAyGnNXyD4jcM1KCt+XvmM7bDsXEBXkkE/19+qZrImErVIrObEPSfnjM+vvnFJ2DPFmSaXgqvnqXDXp8TYd0HmVgv+4Lm1j5wvUiXMUE0xoL4mE5fYUWIGBh67DKh1iapyAaK/+YDt6xAqm4A/4CuC0vP27rYiaotFfLsMp+OWdW9s7fDkYvbQts2cqwTNV3pWK3YXTp4/nySr76F8xXcPXokBLAAn7C8ED9YAZ9pnGwsMZoTi/X0o8EdkjRqksZm9twXkDCfOQvdfCeD0GsON/DDsgwfvQD5vve4OTe5SXRV9VmZ+IANI12oitDG0WbgqIqskJoGlY/CDkjIEw6tngigfgahFpGmqeWOLzXBSfSHIs7hWubp/WQzmI6C6tjbjlfjOM72QwRqa1wN00MIDg+kn9iYYdN6XITJP2CEnrtuXIrGLoi9JhrmrGLbBQ3n0sWTtIQ281Dq6+JxLMuBA/Zj9l1LYturiGcaRdSvUxYAeIO+TpnRD2TYYTBf3nySMdf6Uef6DGqJ6r2xouV+/fXmgcpQyo+ZNcQdX4tzDiGI4NwKZoo/8uJfTO1IMJOMleHVxycxnlH/LGgFGaBsIgw3cOTinZeMAyIRozYeLW9OlyGN2bOL5JzNTuu
 /fbFJJAn
 u+z99TxCCo+tsp6ti0dJ4MLwR7ic9JwA+73wT8IzonkyGPHeCbUKq2SbK3XA/f2N3ZlE/10vZSR73Tyio2jE1cH51Fj4YyL560Ud45TMozsr5F/p04E5LL3hP8j4s4HdSv+gkToXSV4E+t6p/6h93YfjcV55otJC2I4jluWHK47udYh3R+jENccsBYOjTFLw0TpVC4BRV2IYwR47fmiOJ8oFoU+y18FexRa2Lb2+BS6VSi95IEYGXjLx2BC2OlyxHmlaKMFqUkcgxKm91ACuax9+ZD5DYdse/z7t08upmnATinvxhvk3cQ4WILJuULWo+XxU2eStlc2pqVIQlhdnFE8iJ8de7qYU9ViSdvdVcbM0vnuIYDFbyKtbYblLixOM+qPkBHsVmpCNflbQyLefUpSZZ99ve6wxo7ec1WRS4jFVrSfoUDweYX0Uk0HDfKoKlsqQUB1vaPd+1Q6jgd1lLhawRP/PK23dpBrJppSTrbAa0rGq2fU9j4KnAwQkikAp8r4VY4axHgVNQ3d4zZKMOFlsmzAH2VXTtcu7S7RT/XFRb+Fw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:59:57AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 16, 2025 at 02:44:29PM -0500, Peter Xu wrote:
> > > > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > > > let me know; some example would be greatly helpful.
> > > 
> > > Just document the 'VA % order = pgoff % order' equation in the kdoc
> > > for the new op.
> > 
> > When it's "related to PTEs", it's talking about (2) above, so that's really
> > what I want to avoid mentioning.
> 
> You can't avoid it. Drivers must ensure that
> 
>   pgoff % order == physical % order
> 
> And that is something only drivers can do by knowing about this
> requirement.

This is a current limitation that above must be guaranteed, there's not
much the driver can do, IMHO.

If you could remember, that's the only reason why I used to suggest (while
we were discussing this in v1) to make it *pgoff instead of pgoff, so that
drivers can change *pgoff to make it relevant to HPA.

I didn't take that approach as I want to make this simple until it's
justified to be required.

It holds true for vfio-pci, I hope it holds true forever.  If not, this API
will stop working, afaict.

-- 
Peter Xu


