Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB84D39003
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA9D6B0088; Wed, 14 Jan 2026 13:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A78B6B0089; Wed, 14 Jan 2026 13:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B49B6B008A; Wed, 14 Jan 2026 13:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3557E6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:12:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAC7159799
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:12:22 +0000 (UTC)
X-FDA: 84331364124.28.4DC0C6F
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 10AC31A0010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:12:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h3Ndcfyv;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768414341; a=rsa-sha256;
	cv=none;
	b=r6CKRTvx957Uoq1JjvIQ+k7BEQCHAanJJOy8DaAzy+POxHszghq3r2jhRPx70WUltMn79p
	qYNHtNH/o+tag5VAB/clZppcNurUQCdCQOGhIFsI0gyGom7BTYAJxEEkinnDtEudpYt+cC
	Uokmg2OK0hE1ewleRvLzZy9OZ166qa0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h3Ndcfyv;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768414341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfgGnc8yYPLi9t7dHOsu001XcSCAHL7N89lmWN6W/2k=;
	b=V5vfRwhY8d6ZhpLL0kpzI09LvS3Yp8/YLL4cCNC2iSTXBvXruyDveQBLbIn3T24xNgs+TQ
	ZbhmlMhBydxMQoMx+aBmAuGVlRK8BBMo88SbdgRi7kmvWv5oKjBpzeV05hD/MiGo/wGoES
	TodVUita8gkZtbQqaVXu6YasxvYP1XM=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88a3b9ddd40so232086d6.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768414340; x=1769019140; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MfgGnc8yYPLi9t7dHOsu001XcSCAHL7N89lmWN6W/2k=;
        b=h3NdcfyvyKeLz0OkJhEQnjiYDh13JvvBqTZeIdZNEHj/GaKZSiW/tjQ/EcxEjNhjpG
         KiQf7Am0/nbQIxCoSnxcQ/eZMg4LLi81IpCtV88Nzu7UQkhrm0UQU76XFXllnXny5Kre
         SQH9ZEcZsrDV0PmZEo2nsgxWzu7zSR6NDBvGYCYvRob5Gn/iWadWaeIx94qqcvOslENY
         nRRCzpoHWIPu64V5Rcq5qmq7QJmlp6k39aTq3t5BRPC30JCdzPbOP1xtnUX+jS7AVAyZ
         0yP549Ki+EDBeA8Uv4CZ1c+Axse4XNHgXig0mLG80U9cSVY8SHBfMhlix+hwGkyRwQk7
         4uHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768414340; x=1769019140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MfgGnc8yYPLi9t7dHOsu001XcSCAHL7N89lmWN6W/2k=;
        b=pgbnqwYX4ugXA5IwyeUyfkhglL0503ScmiDTJ2T8XvTe3zf/g8A/uCR3SyzjSvp9cl
         /kAjVtwMFxCg0LuAb6LLrd/zRuZH3Op0QV1zZW+95bovYql2k77oxnBRnfSLHfvwrhRD
         WCt1Lkr2TA60/Y/VoVymjxVQn54dIwR/TxO6pC8LN1Z2uo6gW9EF0jTBZhQHY5EznRzo
         0OCtnabWAGlD2K9XtCDSdawmYS+NfHfbDk1HPNUfjSqb9r1acorvHpqj32fcmdKDX72I
         +ueWQ8D6vgErhDxswWx9YQ1qEwXOJxV8lfZKNOt6v0g8fmIMfUB2j2PenFLYNBTg0QFh
         ZCBw==
X-Gm-Message-State: AOJu0YxPEhSHlZ0T8ijVqxQq5IRqG+hJF4Pe4Oo7toQfl1HdAFaoLCC+
	FTI6LwhnELfyGDYoeUsFtmfRJ6CBjhOPvomCYgM2GhRqLXFYrpsktpRO7FA9CAlLAGY=
X-Gm-Gg: AY/fxX593hZ9iXQM3s0Etf4piJKiuBE/HvCE/I4iuN3fGjD+7gKxoEupxunGTG9a3vV
	K7gdVGmL+9fPDA/V067ZnVo79+hOKqQxSj4n0YRn0ixZNxSqzicQbegdf4a4/88ul9lyZsnB+bV
	STOZVqsLnrlJNSq25sgCEuPfGaPtaNgvd/ifZ+e/Swzfw6cohB/r5luLeXOQ18QVSKqrP7ZUHQn
	l/v9yaBCfnqMXcEkQuyowcj5qgIAAAYn0XEve4hunKDQcJ3n3OxzkAAUWdk3JG1X9mxTpAM35c5
	GH7ppHZoRRA6aM+PsToUaB0WO0AjaSnHG2jbIX68ybj73epJInpeyiXGmV2w8WG1g23vDOJuRSD
	xFoCgifF4uoE2FDXqbdG02Id/ic7ABpVIQjHpJI6L23pClOiJQAG08J37ZIeY8RVyzu5tdu5pSG
	j+Eq4Yu1XfXc+0ir/a/P30yqHSx1ouADo5qHgjbz7xRIE4y+5HoC9gFUEZnBCYPNgiDCltxA==
X-Received: by 2002:a05:6214:10c2:b0:785:aa57:b5bb with SMTP id 6a1803df08f44-892743cfe92mr35226416d6.43.1768414339907;
        Wed, 14 Jan 2026 10:12:19 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770d17a3sm181634186d6.9.2026.01.14.10.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 10:12:19 -0800 (PST)
Date: Wed, 14 Jan 2026 13:11:46 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug
 state control
Message-ID: <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
 <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
X-Rspamd-Queue-Id: 10AC31A0010
X-Rspamd-Server: rspam06
X-Stat-Signature: pxbbdoc564mxm9dhzem6fqr4ooi8mq3f
X-Rspam-User: 
X-HE-Tag: 1768414340-152684
X-HE-Meta: U2FsdGVkX1+aadDjymxYGCiYqzg+OZNn2H9cp6lM1ONNnGWBihVPeeFmrEdkR4pbECyFa4w2U6buOaVR9xS5JrE3uXRo/dUngMsWLiuhJp/nAm9zaAd4CX4ITioydqNI/geUAu5I2P8vN8nA6mPROATxdvrk4/VqfQTvsT6uMPAuZvXwf9/MnXelgDqEL633OlZvKFUPaP9SMfUhs+BdrHXAkl1rhxBOF5QNwDk5GplZqZFDDV1qoOZ4wxBOGn+QZJUL54meMvtLHiTrJehTc7ALr50G3XMj5YVlwCMWkAKoUWTXtnkomJm4G2DI7bU+zoUhvb7DO0ZyDpy2L/1GdBHMs995z0DgSZSH6iDRvYQpaxlbb0muWoHusS1brO/K5Yl1qGlLIlHeqhwGwnZ/18wJL5ZvG1QM9lH/rESak194l4tjRHZkG+HRcNAKIbsdbsFsuo1WT6u09HXb4DAevJaKSOHMUunKEY+Us9HWEjI2LQ5RbRAk+dbLyLVgLqKjmGP7Y1xsA2NbxxAoZ760xD1isi9jVlEcC/f1ev7gBq7jAfMuz1uxCfpR748pidAFnCPqI+oFYpdSfce1CIJ3fRYskoh6qy1+KnWQtUss/QnGjeBDlen6gF3/dCIV9yKjg/UnNfQLOqAuLoaFH+Lcbndopr3LJAdnX6/qzRv1kWgpnDgbErdEvVe9ExbphKRw8OEDd7v7biZyPaVYaWw0aazv4UcLew5r1ScHBSmnnelxjKOidoA+Tk9xZAAkfQHhUZxhr7sAxTgdL/WYqqaMf4mKHgoSOjwEEjkzHIhOcXy4G905QjB7hcEo3KcvId0NSvnaZTwRKt/7swlMwatbFAtRqRwsxSE4cZg0IVh4tPucjJImxut7yF4cz1y82DTNrK07QyI3pPn9nAT6EYTh+3W44AVmLtIhpUpelpyQkjQ63XmDHxkJ3pyFte3Irv0q6z1rDNqAU0P5Pdirks9
 IwH997Zh
 uXBdVyRdG/PWD8DzvfcPSkULfnhZEunAUUAAQNbqh5OpZOouXiNCc/z9w+rtGJksxVAZwVN6haFG/qfFTso9pTJBagB5I2KBL9DJDAasJ+huF8aW4VKr0Ke7pMNEMXPTmZap/njbfpgdbxTsVpDYSIhaUHyqmAGOCk1YxYeO+JCVPQ9LDiSp1K5TJAyi+j+eOH6/12Akethfw+1Z/hsLTQz0JvH5QL4PTl++5hthDz9U20Y/eSv6BUfer9MrhQQNoWIKQvhTeM3rlP9h5QyZgNcMm8x6Xm/soyy1cpkMcYP4V4J1v5yjZrL7gp6YMeFAu9c0KJ26C69joScU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:55:21AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:51, Gregory Price wrote:
> > The dax kmem driver currently onlines memory automatically during
> > probe using the system's default online policy but provides no way
> > to control or query the memory state at runtime. Users cannot change
> > the online type after probe, and there's no atomic way to offline and
> > remove memory blocks together.
> > 
> > Add a new 'hotplug' sysfs attribute that allows userspace to control
> > and query the memory state. The interface supports the following states:
> > 
> >    - "offline": memory is added but not online
> >    - "online": memory is online as normal system RAM
> >    - "online_movable": memory is online in ZONE_MOVABLE
> >    - "unplug": memory is offlined and removed
> > 
> > The initial state after probe uses MMOP_SYSTEM_DEFAULT to preserve
> > backwards compatibility - existing systems with auto-online policies
> > will continue to work as before.
> > 
> > The state machine enforces valid transitions:
> >    - From offline: can transition to online, online_movable, or unplug
> >    - From online/online_movable: can transition to offline or unplug
> >    - Cannot switch directly between online and online_movable
> 
> Do we have to support these transitions right from the start?
> 
> What are the use cases for adding memory as offline and then onlining it,
> and why do we have to support that through this interface?
> 

After a re-read of the feedback - are you suggested to basically kill the
entire offline state of blocks entirely? (e.g. if a driver calls to
offline a block, instead fully unplug it)

I took a look at the acpi and ppc code you suggested, and I think they
also have "expect offline then online" as a default expectation.  I
can't speak to those users requirements.

This would definitely break things like daxctl/ndctl, but maybe that's
preferable?  I pointed out that patch 8 does this anyway - and I'd like
input from ndctl folks as to whether that should end in a NACK.

~Gregory

