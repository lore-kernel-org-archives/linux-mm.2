Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA47C531D1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 22:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852166B007B; Thu, 23 Jul 2026 18:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802D66B0088; Thu, 23 Jul 2026 18:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2FD6B008A; Thu, 23 Jul 2026 18:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA846B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:56:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2605A0227
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:56:44 +0000 (UTC)
X-FDA: 85021552728.07.3A26536
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id C1C7D80008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:56:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=V4vDiDS7;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784847402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpdYfO2GUSLBiSa6MSguWwX6UOJE2iVOhfM84BSexIY=;
	b=PTyidwzC+z+STFQnlz/CgMQrEYqzKAclwgwcjj29Cx58oCUskJ54OTc5VeWPoxzhr/PFn6
	KBUF0ufJqWDAbLYuYSgBafl3B7s8NXE6GEW4J0Vm4XcFtt0JGiGby3TUZzJ8eSucN1v946
	76f2YXbVLOHaih24JVvVMFyDAH15LXw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=V4vDiDS7;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784847402;
	b=YdpXRt3fz/GqURbNhK4lbS4kTgPVu/MLAvcaTAqLf5tdGVC1jxolTUaAQZZ76dRCk0Bkjg
	JDtVmr2CcJ6mTjID4raY6PNJqAv7qRku7dcc3wguLHvbTOEkaZQk2JAwmS0UFuWr/kF1rl
	nOzLKcfJ0j5eiwmz0eS2FJguMk+cuuc=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51bfa429aa6so9030541cf.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784847402; x=1785452202; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FpdYfO2GUSLBiSa6MSguWwX6UOJE2iVOhfM84BSexIY=;
        b=V4vDiDS7aE7tE9x0vn4CIA68nEIlzoDCjSdO7/U35Z/+WfS0NPvTRLwF8Vvm78a+Qd
         F5OrRU+XMzEmeV+M/DMVC8o4z9zgqwyeEIsY3j2qMjhkyKm5iokK/qDw0Rsp447FD3Q5
         08i7Q5pIs61UALPQ+vtJPWScMWpbt5inA7f9JXX6ASs0Uq3UXMSaA0yNbZ7lWyHo0mTx
         rEwkKi2IaCco//5SNzfwUhWXOkrW3/SAN4Av63JL8z+2AbHxfcSknal0Df/QWN1WlqWM
         3uxM2zWgVnQ7+hhLC7R+L7AtSELvE/g0pV1+YE82+RF/R+eudxyhhgTCSp+cYQO2KZkw
         WPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784847402; x=1785452202;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FpdYfO2GUSLBiSa6MSguWwX6UOJE2iVOhfM84BSexIY=;
        b=Bb1Mx9tjBZ//b1Yk333scoN5Npx9RX97O/LelWw3VxVwTtZbm3m5mkmBHFh3sxOgGY
         z3NqdScRD/WSC6rR2zo182poisdFUuHDi5zzP4O29uyKJrKmv5Xi2zqTaIjlVkeW/gm+
         X7kkvX7Pcc1RgalkUuBMiE/1skeD5P9GsHqXQki4/bSfT5M0LeqOpWu0K7Zs69B1VI8I
         T+igC9NS9ANv7tI4RIKOkPgdk0zxoFfQuptNwuZkEy1e67/0KCfDYg4pglmGboH48gT0
         oCvv5NTVtnJmwNKzy8W2t5Pf+f4BC1+l/vjSFyFgdd9zY1Pk3/dASWGxSvKU32HLJ+D3
         YH8g==
X-Forwarded-Encrypted: i=1; AHgh+RogWxZJGbDcsq83snsgkv2KsU3Sb6Gr327YfJt+BVIF4sf5n/iDl3vVAc55z5634bWyxa8PP7a8TA==@kvack.org
X-Gm-Message-State: AOJu0YzFdbD8ahOzhYocaqki0ZgDIZT4MdvuG3F8R0itsg6l/uqkOxEJ
	5srHFn+3S+idgeJ0QH95wq0e+40KgC6IGQL/cA0pvZOp337gb99giRygmip5jZyk2ls=
X-Gm-Gg: AR+sD12nPFu4FW/lbbwNcGG2EihDWl10f9ELl2NwbKNFlHXRQ+hoUKjMJ4FnDSLL/04
	4o7ha5hROxi5QUMIQNV4olocX6cRwssZoYnlL0TTMh8UMPegSEJ7p38OUH/gOZvCRk7xx+Co08f
	IryjAIlZUhmHCp8ufZEoxCzC5IbFQVm8sYjhH1EF5VP1XO9UypglFTKOJRKIzc8VQBnrBlUVHXT
	TUHzjd20DaeEnuOMKWtmTwRBxASkyuzFYgMDh1EWXO7VdCyPspB9VYV1GF+mwGywqPxZm3wRkJt
	/Bjz7Xknbifmr4JoKzWwW8jsTr+mtaQz7WcRiJhI6FrYnjOgEQB4tcTWPUhwhDwbwYOxbJSza+q
	ks/C2+3Jmp0iNgKlF1dhB+dcSxEC77WjSwIDtERw5y1CijCS9fBxgRhRYdPtYrPTvGJ2eUkNctR
	/YkP2Hx9SnEWkh/ptxMzKBG3F5ViF3/bNZDl8SJ2wlPJXw4GlFEtfbphuSDg==
X-Received: by 2002:a05:622a:353:b0:51c:f8f:13b with SMTP id d75a77b69052e-5283edce92cmr47173041cf.23.1784847401808;
        Thu, 23 Jul 2026 15:56:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b5d70sm54929666d6.4.2026.07.23.15.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:56:41 -0700 (PDT)
Date: Thu, 23 Jul 2026 18:56:36 -0400
From: Gregory Price <gourry@gourry.net>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <amKb8sBroYNOiZhy@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com>
 <amIrDncrL4K-JRBO@cmpxchg.org>
 <amIxyy4Vg_TTE8Y4@gourry-fedora-PF4VCD3F>
 <amJKOPczNMb96NJv@cmpxchg.org>
 <amJQAs3Bm99ZR_sF@gourry-fedora-PF4VCD3F>
 <amJgdSXxFk24e94p@gourry-fedora-PF4VCD3F>
 <CAO9r8zN2mPsFiRTPYOPTq3gTVZwsj5hODke4asTTY-jXpSioxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zN2mPsFiRTPYOPTq3gTVZwsj5hODke4asTTY-jXpSioxA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1C7D80008
X-Stat-Signature: m4yxw7pdu5po1zaokw4tjhodeppu5ahu
X-HE-Tag: 1784847402-541874
X-HE-Meta: U2FsdGVkX1/KDEtFTtVnfHwbKW1ri1v5xdvR8U1BAjjwgTP0X5vC1zbHeHJWL+1PKOSt+a/VzSwgO+PTeIIeVeuLnetvcxK1UYaU6Itm6qjrHmEZgUoFyJXa2uWxRhxH6HqjYXndDWwoeB9ZmL/jwoje/tl/w0lrwRBqEA593Su8UzGGnwlyfNzjCz7MFiiZWboFPfKWP7h3FNASpFwXOOqVsKXXyPjm2dPb06LHW7W/EFHAwahCGdNSFs9baBLspdB3JQ/C4+yjPLkKEsICgli/uI1/SUO+S+iYvMbjWk5grv71e3Vt4VCJDwQuG3kt8Of9p37VmT6NXhhiPf0IQ/0wvQ2TyIkXPH/Z580guyVxbpu3c9tbbupwFTlWbE+StZSe/Xs5GeQ3NYnYLxujliQ0YlIcPgeFP3+iwabXY2dlGaXD6/hQ7Fzp/lyx1SDECpE0Wmh4cWMdSbIfu4hNPrAe4m9bZe5t+9rC2LskUncAFw1125zdDnJCfcYEu0UKTmBf6U3pc3iNgCQ3PDX/cawYc/NOzM3vqj/r8WwFyeeCsr24p1IORQ7vatRw9U8kanvFZ7jk7p7ITNhFI9JvJ4C1ILH8KHW1PLNoNTDNrTrBI7nEFU2MR+Rkv5uplN7yz+CQsxDhdfrW6ClqeltL3+I5InEPrKFQgTDABLYiDW49xVPcdXi012JSMHoSXjj05TqcA+lEVRs+4E1bDnMETr5ZAj3GGj+jUUcgIPMZuXKEHxGMgeqtEpYpQlFDfz2PUcZWTERyHW1e5nUk4L0sUhbjVAXx+ZL7IGiC0lDv0VIWXwI9KGOANcC4qlnB5ABe3XJzpjByDMNo3i2pRu4A6+dk90gO3L/cshoJHRS3dJzS4HX7NCXxeagMtCJALYKVrhhG8YVu0PoRG1RIX4IX75EllPh9YrlO1Fp47Sx6pPV0HVtUEIjp/+FTlsKLFrHaC7kPffxMkWKHMwSmYxY
 OJRCjcic
 wv9otRnOaFL24aiJoPKe6Dtwd+MPDPE65uhDoTzeUVnzh12VVJES+BMJZflPD9NCRzrgST6shpEjkBmFqV53JlM/jBbEpCnIm4FGCO3rMovIvUnhrLj6Yyh6qRE7CV54gbRTgliFEfHInwJrSwK6FQ/MBo+VY2mxbO5DbIQrcKXhLCXM0M/Tj76mhKdK2OkN2D6MGuad4bD0CZTZZ2vOWTQBuX/AavJHsWHOt2lb+zUJcSgjT3eANWhU2cOhE5pMs1p5Ss2iZJz0ODNsvbPEfT/dGPGXeovJKzsAjwTqvK78jFEupKFZ7705Hq5nZ/jc07hDKiGSA0iH7+Oh0iRe1FBzm2mcqpB7w+kXGhGbANgYnzjgtOUdbSU0azSOiSsT2R2+q57I4vzcohnfxIypfd0Y4Wp0xhhhWRO3UMSmsbj183fv9at4LBfiql/hwJplYf+yWp/+CG5ZPrgxdmechkQGf6Y7vvmmhkrhDmkjEOwtKAJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 03:30:52PM -0700, Yosry Ahmed wrote:
> On Thu, Jul 23, 2026 at 11:45 AM Gregory Price <gourry@gourry.net> wrote:
> >
> > Walking this all back:
> >
> >   - MPOL_DEFAULT is the default policy
> >   - numa_balancing=on means enable NUMA_BALANCING on the defaul policy
> >   - shmem was broken and did not respect this
> >
> > Johannes' fix is correct, and there are no additional changes required.
> >
> > Users enabling numa balancing while running KVM with shared regions are
> > not getting what they're asking for presently - that is a bug.
> >
> > They should get the performance hit they're asking for (and then either
> > turn off numa balancing or set an explicit mempolicy for those tasks /
> > memfd's).
> 
> Does it make sense to add a pr_warn() or pr_info() to help users
> figure this out when they see a regression?

I'm not sure in what scenario we would do this that doesn't simple
reduce to "You turned numa balancing on".

Not against it.

~Gregory

