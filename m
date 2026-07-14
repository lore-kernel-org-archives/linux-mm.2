Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD80C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2812E6B0093; Tue, 14 Jul 2026 14:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258536B0095; Tue, 14 Jul 2026 14:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171666B009B; Tue, 14 Jul 2026 14:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA2F26B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:21:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4303616046A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:21:38 +0000 (UTC)
X-FDA: 84988200276.23.B5C0874
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81463100005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:21:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JLBzPbxe;
	spf=pass (imf05.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gQRzGlj1G5cVe9CASOoXX9GLstMyJGv9XUVp1m4BJc=;
	b=J8HQpSELyvwhPA8buK6WBraCtq63wGzY1Pq2KRIcG/svi5yAGsRwVBwt/gN0fj6Rllw0bM
	f0kFfGvWbMAxe76Ehg4IF3K2DrypiQPy6ME9uj+MoRD2kxFbahQT8VU9+S5+70+MKHEOLX
	vp9DKsckvtNQBmwIpOgw1vO3cGoErEg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JLBzPbxe;
	spf=pass (imf05.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053296;
	b=CubHhYCAGB018n4TX5xcmxXLI3A3c0uL8cFld04tCYLVUJOXrKB79wxApa54kO+8pkl6Fj
	SSZxDrHVHqoO45WkhU3XQK5MUj+GiOZk/tx6YJTcHVd10md9ej7Ljqm6ElPRvqXjuQOKwh
	6vUxIP1ucqPYwWSdf+kzZUt2aDt/oUI=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cede6375caso171135ad.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784053295; x=1784658095; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8gQRzGlj1G5cVe9CASOoXX9GLstMyJGv9XUVp1m4BJc=;
        b=JLBzPbxeafrLLrjROpb1LqD26jlT6AiT7nNhKSLOo7fZ8ylefU3yyLcJPWKFccLV1C
         2WOupsYMrt/xtviTpIWzvDrAu93dPr7Gg8SFu0j/H84HHJz5ABN0JTz8Tg9aUwGpVidV
         1yTpWjM+c5o1HcMbk4wEp4AK47rE9lYbtjueppbRT4SSSdjmbzMltNOegASlN7oT571O
         pEh1Ui7cWk72RxLoor7MwXQD9TkvW0abddX2ZumQDH5/CCzi07anL+ylxKyjRFLHmhig
         x7TXRTetZFq1IELxFszIGgO2ZF4CtMeOJ6z+BGv2921Ib/t5dlUwTrOm4qTqr2fCR410
         hNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053295; x=1784658095;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8gQRzGlj1G5cVe9CASOoXX9GLstMyJGv9XUVp1m4BJc=;
        b=oRBn0Uum+BcrKAHGxt0LXsw8gUspMBYDg13c6p0VgOZ3aNYWePi42sKvaQhQLPeuf7
         flMAluibbCksqTQnZFL9EJwNYVT4LqOukYFaxQ0F3ofq39NJkdbv65tEbSI1y4FPL8vG
         c9z+qtmb7pGZ9gAqRTOWQ4GFCWcdzqeiGfo59xqs9TlxoJYOl/5g4TZNgkngwTdpEUHD
         4G4VDe/WKs+4g8nl3dexmQDRtl9goaDy/kqVgf3g673vfX42L3WQT3SOyf0yqKHVDomH
         Dv1jxpSlV82+LWLShfBtuPnFGjuzWJxnckx6Z86eMjfPajSezq7wbzCYZ3OqPf4AvvY0
         Hw6g==
X-Forwarded-Encrypted: i=1; AHgh+RoRhCAJplwC8qwaMqepnD3fATV5elHEvBtow3PXJ4+7oDDUrrXJzABvHKqHp46c+cTF8dkfLszxuA==@kvack.org
X-Gm-Message-State: AOJu0YzZ9ErtZTdux/ZVtobSwtDJRxky17yMf30XIATz+iS5TeZNSwDH
	EfdMBSfaM4iWz44PcUBaBMcDfqQr9i5lrF7ihvT1F8HHIdwX/jpR4iFg+s2fYUS5aA==
X-Gm-Gg: AfdE7cmupL5N7fpyx8IM/bnn8NhyHWuSpSOuEOxQcLm7JwDD250ePZdDnJwVpSx3yF0
	Y1pXwgCCL6OggCNKLQC8eER9sNeIM61V00v7HyzA/57m92TK/WNlAX2ylo4rIBkWo+uQ18yEVXN
	C5R+XEWgC5EiryCJg6ye5sgayE/XmCWqFBtEIDA60WJFDA9+y3JJF2JRXTtQDNuc+EwMgVWYUJJ
	RhP1ah0khzMjl1q/UCkZT1CjnQ6EiYY4pR6gSxD+Uq/+Yke99wjtfHMNLsKJLli6hEEUlJkyxrv
	9NF4/vozdHUmOJorYJ0MakzGRXVES99+rHzZ/7YHY70fXG3GiRsQOJ1uqnI/rTaSHMjXOX/WCbK
	zMzKezMP0apFTcpt6ZtuhMDlPbPYLdKMDJfLBIYBbbcIjso1MhSr5LCBvS5Uaau1cSvVgN8kshT
	GCCu7QIQaua+IHq1G2ZB2dilDzw4xOX2S/vp2D3zKHkrA9KqFC4HsaqnCmUOcXuTkt1uLyS8LGw
	i6Bq9Ac2VeYKIVqVICSC/2JRTeCZAN4wyVDvg6gbi8=
X-Received: by 2002:a17:902:f70b:b0:2cc:6df5:62a1 with SMTP id d9443c01a7336-2cee1ca3115mr7223455ad.20.1784053294748;
        Tue, 14 Jul 2026 11:21:34 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:c2bd:d216:2ddc:2568] ([2a00:79e0:2eb4:9:c2bd:d216:2ddc:2568])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172cc7f1sm1933730a91.5.2026.07.14.11.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:21:33 -0700 (PDT)
Date: Tue, 14 Jul 2026 11:21:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: "David Hildenbrand (Arm)" <david@kernel.org>, Link Lin <linkl@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, prasin@google.com, 
    duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
    Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, 
    ahwilkins@google.com, Greg Thelen <gthelen@google.com>, 
    Alexander Duyck <alexander.duyck@gmail.com>, stable@vger.kernel.org
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting during
 PM freeze
In-Reply-To: <20260714092146-mutt-send-email-mst@kernel.org>
Message-ID: <5e18d7ec-a9d7-2cc3-7741-695ec3580ffa@google.com>
References: <20260709224330.946683-1-linkl@google.com> <8d316b6c-41fb-4ae3-8923-3b649b92b33d@kernel.org> <20260714092146-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81463100005
X-Stat-Signature: 6es8y5tzi3tnwy78mnq6ms8r8dfyf9gd
X-HE-Tag: 1784053296-299268
X-HE-Meta: U2FsdGVkX185lFwvbBaK0I0cI/l7GWLDy0DjbSTM252XZZiv2VoKwWF9oEpwRwbmvxY14VSS4vdCH1hoixcoxEkg9JEXG9fN+cQ/xs71gddBHdIf0uePqcIb/FUAzsMltp6XFpddnjRyITV/BJWOmfMtQWs5558iLelzb4vgkbkRk1xi0Q8t2ZFJGKA9P01NLqDHVfSMiMGhY4mJWrdVLjE/PnzATl6B7dqlqO3MT4zrD292Xc3uhmc4ovsldWilSWzvVP71KIZiJfAgOMZLa9dCmmYpH262XqMdRryB9p88Zm6a3HiPVq8TtztvOiFYXr1wAoUMMXlnpoUXP87X/hdkRsGXPEW3wwqzTpc2OVFH9RuNQtqJJZd+tkTM1eokblA0oAggourfWlgcRLEgjw346DKf9f55XySvY9WLhfKfdi1B5SEWjJA2tcUFcjpKX/UgO9bklKUCpaUZTzOjhcnQuGn6BoGHUMmNbUobZQXI7qQElAAsBFQKTYfwpLyadpJnJ6XbNEPNDIm+mwEhwgD9SOpC7dlfHkjCwlS7PU8O+BgdAGDO31cfX7AKK3pzPjrY5CUW2E4yHVNlrLLeWjzhnks0IjlXzLStu1HdG4orN97mXWApHDfDdd0ooVgb+JGkFkhvytpfU782lMVinapI9T8APhXIjWNcU7ycycUkhJdr7m9ABkBOojnoK93UalR7StF3NpMCi85n2GbPZB/BWdlKaVvoqQPsRgVozK03DQVONv5uqrK6mfuFhS0fonSNvm2ZDcfhSFp435gdQRN1k2arJu/dt8gYWC/kN3rfTVkVET1A1m/B3/UovuVQXA8kX+fSlROv73RR0DsDYbvTHHZadpkcB5ZuZw8O1doO3v2gxIrEIa+RdAQpOzGS38ICXcR4qi5smPQHCYMEcwaK21ujSaJthPUzD0Cmg/MgOE9ViisOLWXLyv1ExRBZKY+M6Vx/vcqzV42okxi
 A9Evp1UC
 JFNLEtEOywjpctTsebniBQPXqjOqIWTZBtLo9qs2aM7lUe4Vfg3vmmnH2PYjscxuCSXBmPm4IcFEddkTtNQ5KHARAHH2WDhJacrdkhiHnKRIwGcI95VB5aKH9HveyZIKnoPTSaP0N1qEqeem/q4kK84Dr20vjkCs5MIFlDq1p72lTKNjNMPVsZzFa4QANNmSOl1QONnz1Hk94w/sLMoOQUybTgCwKPNKN0xpcRk4tEboc2IjQtU4/hCjbv0KmkcznrQbR6A1HrphXWujIUj+Tr7ENwcG1wl474qs1yBash24MRSxVn7klyIV3ClE7husMizsUDvwNV0KotARAYwVFOeX1WLKKi+7Jztbs/Su26d3nFWcQYf8W+E+FbfAOT09Yy70nCQVJ5UWeMqRKu2gkP/AjBO8sE/HwFcq8yyRPxPNLObKGpi0uyaKhxs1JN2Pu0JTAZ1YcWdZKDWXjX85e5A9viFIRMABuXTFnLXkNYsrRlI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026, Michael S. Tsirkin wrote:

> > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > index a1b2c3d4e5f6..45a90fb3abf8 100640
> > > --- a/drivers/virtio/virtio_balloon.c
> > > +++ b/drivers/virtio/virtio_balloon.c
> > > @@ -1055,6 +1055,9 @@ static int virtballoon_freeze(struct virtio_device *vdev)
> > >  	 * The workqueue is already frozen by the PM core before this
> > >  	 * function is called.
> > >  	 */
> > > +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > > +		page_reporting_unregister(&vb->pr_dev_info);
> > > +
> > >  	remove_common(vb);
> > >  	return 0;
> > >  }
> > >  
> > >  static int virtballoon_restore(struct virtio_device *vdev)
> > >  {
> > >  	struct virtio_balloon *vb = vdev->priv;
> > >  	int ret;
> > >  
> > >  	ret = init_vqs(vdev->priv);
> > >  	if (ret)
> > >  		return ret;
> > >  
> > >  	virtio_device_ready(vdev);
> > >  
> > > +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > > +		ret = page_reporting_register(&vb->pr_dev_info);
> > > +		if (ret)
> > > +			goto out_remove_vqs;
> > > +	}
> > 
> > Hm, that failure handling is rather nasty.
> > 
> > 
> > In virtballoon_freeze() we document:
> > 
> > "The workqueue is already frozen by the PM core before this function is called"
> > 
> > Your report states:
> > 
> > "Workqueue: events page_reporting_process"
> > 
> > 
> > I assume that workqueue is not frozen yet because ... it's not freezable :)
> > 
> > So could we queue to system_freezable_wq instead, or define our own freezable
> > workqueue there? Then a driver doesn't have to worry about that.
> > 
> > -- 
> > Cheers,
> > 
> > David
> 
> +1.  Just system_freezable_wq will do the trick.
> 

This makes sense.

I'm curious why this bug hasn't popped up earlier, presumably any VM that 
has gone through suspend while reporting free pages through FPR is 
vulnerable to it and could have panicked as a result.  Which would suggest 
maybe >99% of FPR is done by guests that never suspend?  While under 
pressure this issue seems reproducible.

