Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50EACD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322F36B0005; Tue,  9 Jun 2026 14:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA466B0088; Tue,  9 Jun 2026 14:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210B46B008A; Tue,  9 Jun 2026 14:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6FE6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:34:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B70C406DD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:34:00 +0000 (UTC)
X-FDA: 84861223440.17.976FDAB
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id A29B640002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:33:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HituY0rR;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OySD+ExhHPCEiw9aOnLHfgmqMe+Ca/7oT+zDoVBuOjM=;
	b=fPlqLJ8Hiwz6YM9vqnYnXy7YarTYCl8KpvzVcCaIkgdRcisKQd7zy2iVKOkh8jujPbw7sx
	erMI51xLgNkHKE8Zy2QT8NwYh8ZA711RvtUFxHTCHf5Jr5PP5wIozi6IbUCZk+aLy5FNgB
	JsCezrW6bk9xW11sJDF5aGqbiO12BcE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HituY0rR;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781030038;
	b=vjJ5A9weetn09RLVbyV2L5H75UR3sc374WGuPVUEW55AndIiwTb9DX+NKvOZDvauMbJdpo
	i72SUmHAVu9x9EQKew0+bMs6qpOAjlNB9F+9rhS20ksE2iBqsEYWADpfmGd8QwbNQJcqoN
	mxLh5sbOC9mrycCjB53SYKVZ7pm56ss=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9157b94a07aso686806385a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 11:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781030038; x=1781634838; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OySD+ExhHPCEiw9aOnLHfgmqMe+Ca/7oT+zDoVBuOjM=;
        b=HituY0rREVlaVKp1EEjvNB3WuRwLmbI/rir+wEWbxf0aVPY6sm8NUCmW9/oisC+GKO
         iS9e6ViEo8u2GONShRaG6yK9J4vHZd0Zjt/zMobCivMN2q3tGxv1RO2HCQPfLoKfez5N
         AYwuO0x497AWdrJjbdP0168Z4I4aCfAb6WywDy2xetLRM9wqbTVyhY7EJ9cgogLFyZrX
         MOOF9zMAh/sGiOHrUb7wnN+EWyoy0QtDx+Oj+JGcmF4JRCI3+9YfjpiRIlKyisVTG+4l
         waAyBZ/IjnvsBjkVGew3h8GqYuUdm7HayV8oaYq5PLvAEg6IShGkadn837qmBPEAnMnD
         KwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781030038; x=1781634838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OySD+ExhHPCEiw9aOnLHfgmqMe+Ca/7oT+zDoVBuOjM=;
        b=WvYeWD+AC20fuXdJuNk9k7Ywxp5xnfXEqiYKl8hlMKmKs0BJMb/JNii2MmnrWVPoEr
         RjX38kbd9hFK4SpAV0K06ulExClhOLGJBGfnsZSk58WvR4QbVR7KqFwuqtobeCqRXjMv
         1aj/lcaY28u/ubIKUE94a9FNSpi+1IT94Tf1jiYXeSj3sERwNEsNyjuQSKsak+LOZd95
         hjRLtFM3hymNWNCNYy9I/RIzBBnhLE2CaLcq1AQVe3ULQ56P0bGdGNPxbDJAes16/kfI
         EjecyHBGiKt7T95j8KmikNYaVf823w6DGSs4IdwEUro++MXcZZjSMBWXw34Q9YOxv9G3
         jqHg==
X-Gm-Message-State: AOJu0Yzku8wKLl3NaBCFSMgAJKPRz5t7FMS715NA5B27T/hebm2kGj3O
	LU/gRaDw1tdalwj+kZy5Bk8GYZctynOo3WF5imrs+sAug2A+Xd4Mn4+/QiBaTgFT/yY=
X-Gm-Gg: Acq92OGNhI2/51EaF4U1cyQcn0t2RsQkQtkravMqgi80Gu2uoiwk/WOwmM01xqJnX13
	mF4kcKVReDejUZrVWmLUsfD/s1Dlo9GexrYKToh12WVpJ6NBITZK24XxjewwEBWc7wvDZpnptx4
	vXAW5MIHq2rQLIGV1OxfhSuZaQcITzx7i3aludek1fW5x1r0FRNMB19zx8XUQ3PMEgLCC6Rm6Zy
	jmhn2gw1keTi/ZVTd7ad/3SJVOu0ujy3LWyNeZjsA2d1XWqkVGH5R9/uhXTN8Uyjvx6oKnuVhmr
	ZVC7XeljvD3t74r/BIO+bugOtnD5JMsk+rGhOdYZqgcn3xoQOfQEbJuT4sZhuLEsAq/p921Enq7
	ZIIZzvj4kGho67kP01oBWE7NiHWuevNd53JY4ed9crR8mazsya/OnGS3ykxjZdv8inNZ2gvf2xk
	8Ukgt5FNxordOc4TMSJWjTlfuMYy5Zkfoi6ycLKZB03kJf54SiL44AwFynEIf4IsXSmt17EK1eb
	nfMDBAJ3NqHghfGfg==
X-Received: by 2002:a05:620a:1d01:b0:915:9e84:85ee with SMTP id af79cd13be357-915a9ca7655mr3263727985a.15.1781030037611;
        Tue, 09 Jun 2026 11:33:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3eea49sm2158492985a.44.2026.06.09.11.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 11:33:57 -0700 (PDT)
Date: Tue, 9 Jun 2026 14:33:55 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
Message-ID: <aihck-U9nyne98H0@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
 <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
 <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
 <e6e7453a-d2af-4f1a-8930-5e5e5c5879cd@kernel.org>
 <aihZG8WKVSvA86mA@gourry-fedora-PF4VCD3F>
 <06bcee07-5e56-4a82-95ff-2a8e75b7154d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06bcee07-5e56-4a82-95ff-2a8e75b7154d@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: m7puhuxbadikqn73z5983fzc46h9g63s
X-Rspamd-Queue-Id: A29B640002
X-HE-Tag: 1781030038-286191
X-HE-Meta: U2FsdGVkX18R5BSi+r1P8lWNjsU62xi6LfdOkOGeXyFaiW6YFRiQK97eXcrwG8qTLkgUCiCf78MHxCIPlXUtFjGqEimDVq7v3fll7knjEA40AcKmg4ldjzcV2+ym5EHkGB1oDHZAfnIfl7HVmOjvGC258WPGt4UBDMQUJQ1sSNIrZ+MVR2EQVH9PpL0YKNJdu9nEx7qWhY+N4DCDpjKdN84kUqgnBL5mV2StwQq0OCOxNHeCqt4G/4D0dOKa10a3G6mPrvQCWpkOwDbClOBLj3PVptyYJMZD471x1XvuUsmvB0dbN+vNx3rJjS3+dotx4QI/WVXoFBNkGBSHHhPxFrRUcmQMANFvfvmwkhzdhZut3lfmU9r6dfOMt1Cj1183rBNNGWbkLzf++RO9fUfzjrGLS0zkUuiiGDJnrCLOO1wssc3/gkeU8gPmTOdoWn5SlewS9zkGubFw10564/WjABHl90YQ1+9EAqBtJzLO2i/SPjcAI7Gfm2whUr/b5fzgQ489aJ4maw3U86oUsnOuI1xdZ7fUWSdF7HfCYYPduXzOvwzq30GV0Ezy3FDBr7Q0KggZxTQ/3jej7x1zbEwrYfOUCvwXAzCXr0f8kQmh11qNSi5sPswJhCkcGRubuiAdPIAJIkLBiLmXqfhDxK0rkxf74oEW3ldy1xd5zTik5g75BweiEpxFRptMOmf3AXnFTjBvsdPfQ8esKiMp1rHCMJcZAoI5mNCghZgGcTXjpFQUIsRfFBBRcqAsyN8OVvmabW6k0kl9xqc5vnQjktqQ7ZA6r2XFjfLiz3leNl496vfb2n4T+R1/Qs1NDVjvZvV+Np8HlSrb8zVx94qghb/Xf89chTkuupnSGPuDtVzD5d9CpcVWfh/0xamrL0O5tDeW0wISm6t3ZT9eT7XYI56Vn0UBv5qp6ZvS/D/po5W1pd6tKP5Niw6q68VvSplHrvV+TnMnoxrfOswDEP06Mb5
 hZLSOec8
 3sLsk06k05Uyh/1lWS3i5nfWQpHcI22UfhiKRbuk8nEmJWP6wmTb06MVg1+zhvEfbnCOcXazooVI365uUthF2v1COxYx+P9lDebmtXMOHW4iCRCAm+vuoXiuynLAB/tn9D1iN7MGtOS21NTaer0Ca9lrIYIvsMgMwUtGsG/enIQ5TfKp7SkBizfFC3VE1+t43OnYBMsWiQcoVJQkHtwsO4XPYvSETnsgVJhGSZfPsAHO+32NMUTlC9hV25oR6mf2OmPeHav3p+4gqij4JcDziUeQSJkdplChFdFBcRtgBOv6ha4NBH9LAi0d56Feevacjv+UqdfutHA2smhMvwXVPzD3cSHDZ8Yi7A/p+U1/pU8NlV1e5LESO6GPB1dN4CzZNsnu7fu1lorSJtyIS6o1lZDh8WTHbNZvfGViQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:22:20PM +0200, David Hildenbrand (Arm) wrote:
> On 6/9/26 20:19, Gregory Price wrote:
> > On Tue, Jun 09, 2026 at 08:11:42PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/9/26 17:35, Gregory Price wrote:
> > 
> > Was going to propose this, but then I thought... well if CXL detactes
> > itself from dax and does this same pattern, maybe MMOP_UNPLUGGED makes
> > sense.
> > 
> > But i'll leave that for another day and do as you suggest.
> 
> Let me sleep over it :)
> 

Have some other sets i'm trying to break out of private-nodes anyway,
i'll let this bake for the week.

~Gregory

