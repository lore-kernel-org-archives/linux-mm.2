Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C558FCD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E3C6B0093; Tue,  9 Jun 2026 11:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF296B0095; Tue,  9 Jun 2026 11:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4BE6B0096; Tue,  9 Jun 2026 11:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEA606B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:11:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 467341404CF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:57 +0000 (UTC)
X-FDA: 84860714274.02.36ABAF2
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 61DCA20013
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pUfSkrGg;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781017915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JHWQ15ZRzqnNTI4yBH6/uoHMgLXFxEcxAiVyb8DKfs=;
	b=z092tvUZNlcrJ+H3Aep8zNPEVgKj8oYZjPWCv15tpKntD3r5bdPPVsmjsJB2lXFwdxI0Mn
	P9JDdkwoSV6TzUOKOx//LIh7eunfI6egmxUqtewvKABgY2qe+/khOGbCnpMFZ6zQEUtxSN
	3BYLVsZwJX7V54xgsKHDSxaHnF/vriM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pUfSkrGg;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781017915;
	b=ENXrwz7NRf66tpvssq6QSv85s7uyNtI13a/YRb6iWYKMPSbLDQrrqC0axd2JOYNJfQGJ6t
	FlPLPKbpz1ZkoirwGPOoldim0iparuPQeA5iRvvb8kYR2X1nOd3s45dGTS1v6Z25GcM9tB
	30E1MwqA8IE+dj6ZT8Ky/a67QhnouUE=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-91562bf6c12so692714085a.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781017914; x=1781622714; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4JHWQ15ZRzqnNTI4yBH6/uoHMgLXFxEcxAiVyb8DKfs=;
        b=pUfSkrGgRc9NGwkWV6NKqfCtqpyPgph8B5Ugz/CUZth+IN/HU6o7APAgdDJpPShqFR
         XJ24Gi6+m1IAz2ZrQkgPYCJBn2bYXMln4Sz7SJv2ldRkFPoItHOzBsQ66vxtsBRo+Ffr
         rr8Ivqso64rrl7923SV7C5Rm4bfJ2XsgqGoK3F086UwkgA//hFkmCPE2K09Sv7EIVCYT
         IWuu6mnTIjG5S6MpuViAiQ3pbWY9C//lUlQ+sJ1FG6WusU/PkKGsto2i8nfzPb/xSrue
         c2qaxa49EsrNM8kf34vmj+4q5fZneLjh183WHWJQvv7kGcUCkPEojV3MVK5T/Z4ne2YT
         d5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781017914; x=1781622714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JHWQ15ZRzqnNTI4yBH6/uoHMgLXFxEcxAiVyb8DKfs=;
        b=q8SD2Sz/td8cHEckgXsxt6rRxDw2/VrZEe+25WM2BrfPmH7vmHrGoAqDFG7bM8cFeC
         qnqK+7I5jEhIvVP4X0Bc3peuIBx/idxA+mnRGKdp12P+wD90UeLNSBVCyAO2B3oB2yg7
         KQ8SgqQieviIg1r8EvBIi82enDf+TH0x6OJ39PEuSNpIvvH2N9nY015rDlKUcnoIzOnn
         y4vw/JCLkPXyUNC5d/Ln66T5vFGNcedLMP1iUs2vQsAFlv/j41BorOJweErqG79Zlods
         u/+nInoVUs/+U5558dK8Ej1UPlSCpXnHcK8DU28rNMMA4wwoCPwpE+MzJlP8LkaJrAs8
         tIHw==
X-Gm-Message-State: AOJu0YwuxWjWVVoirYVVicc6PvFV6WpinU4aLsCLLA2LC+/vZaZzc0O3
	V97wcGGldkyqgoxwCc55xXS39e/VPGGvvRFycJKhUqgfjjuExi5JsRps3O2Rr7dnbAU=
X-Gm-Gg: Acq92OHmxgtGr+0mfBnbEa7+nIUNgqZgUF0gwCOSlgRT2qVd02feQeYrOZ9+rNyR1oY
	qLnCyGC8gTuG0M4sjACmY+RFqkh+8wbSN61os4ftTFUlbEMgs2f83kqRZ0ZFHhHal8HAYx8E4I8
	MS05XmxkdTx1Z1uigmSlVhB2GXYeDmI5N796g7uSnFK3X1OjLWo/7Ilzsjac9l3TPCYoGWhqUSG
	I/Sul7vZcbL2XJ80rTEYvR837iBo4e+NT88m314rIRtpg0TnZRZQOLgLsai7Nn0MbYwaZpOYVG1
	BNYEJeftUkwhhiwj7MQ7lWMdX4WXFxMbbkpm+j+pf8IrAcveivXhWITbUhp3yn9uLUFpecyy7/w
	M2jaCwtuyKNdDEPddXCWyi/FblZif6HjxrKngBeKqaM4jbaVTrGg1u6nyRAutz1flD6JJAQhWQu
	VVeoQWCJZ99cP8zVnCModxjkLZ4SvBYtFEeZA3owLnGmNFlFxPvWwVcOVwAYp96cZkqTwYHk1Ab
	NK/+qWpD5sxsWChEg==
X-Received: by 2002:a05:620a:4546:b0:915:cf88:1e3b with SMTP id af79cd13be357-915cf882096mr1578753385a.47.1781017914136;
        Tue, 09 Jun 2026 08:11:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a237330sm2207058485a.16.2026.06.09.08.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:11:53 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:11:51 -0400
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
	ira.weiny@intel.com, apopple@nvidia.com
Subject: Re: [PATCH v4 3/9] mm/memory_hotplug: export
 mhp_get_default_online_type
Message-ID: <aigtN28XUvHyCSkG@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-4-gourry@gourry.net>
 <eaea4aac-fcba-4f83-99dd-f8289e5556c0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaea4aac-fcba-4f83-99dd-f8289e5556c0@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7nnsqjfm7hqdijc8mm67pk5zmk4wokkr
X-Rspamd-Queue-Id: 61DCA20013
X-HE-Tag: 1781017915-671889
X-HE-Meta: U2FsdGVkX1+9rX/jET0r/Yt/0bruN1y7FM7MhS6X/w7D1J8aZgEfxEcCwLxCao1FgmsmECdvRel0s0Dgb3cAuJnbY6EwFwJbSZRRE9QmoBXQamXKaffIXTGSRpQihMA3O9SfOxWtDmaoZyCr9mM4by4I5w76fkFB3EJ7HMd375ur1ye6sSJFDcp5Dd0F/4rEnxjhlWjYQfAFjkOyYcFBufKRZWEDh9lr2bKvu5jq5d/5DDJDYhY4Fa7BqJWp8pS1d94ITR4xbUNC2DutCQo+r5pPzA4eQPPew7XqAFjfRSu/S5qHxzqwIlFqouZhlBVFxYgGsji/u5U+jfb51LwCLM04PFfhLFr23jLFoslnG2lt79mYUlmXJf3QLYs32bM1gRA6RjZ52sIlfxtnyCMqo5AWkO67ukt/BSuSWHr20JcmJBlkzAgxEZVvlNnAltYIq6iIWPK55ukjIyFuEzn+rVsQ86fHSfpi47RX/R6QxZyWP/2UIINkF7lNGjQuLSHHKBf8BGjb2ls9f7A6kcpxXi52XA/yKTOzxpQRswyUhWsbEbALNGNpjTx0TvdFkEbN6vWFV1G0jYEK2ej/Aslq36vtZnnI11PVf7foynT6ipJIAjGriX/xPA1KZmHrcdO5G/8lnDpkzr/douUpl09s/rM/hOtCzkSMce549nTWYyZ+kD9tI2WDBCsTHZz/JEbC2vGr5GfYHr5OofaZvGJLvGmJH/5lOJVsDsoeSJeUWxcQPHXRitujfieLEE5UulVZz7HCv9XO3Q7hbUXuTLk24f7YcuV5Mtgqo7dGry5JLrdOpHvs67XfNyz25rmn+VH1QHC+G/3IrW6ZHpdB2emWgHlSr++0h/P90gdgu5MIjgEDwA3/RQvKTSvg1fQJ3ebTREncLUU1Az9lRU1+DdLLIZ/HKplxogv50lmJftXBCvgaF9+sSj/E/6QK9fU2jrXY8lBTU6L909qJV5I5PBa
 7eyuzb01
 iwl13yd3IuHxByaKMrgrE7XoJK5XRJ6pePioi8PHkV7+GLxyIHns9o0m0A7lBJjWIg+DZh2HrhZfx4+uc7z2V7N8TsGgubAc5L4eeuV+IUHSQ86/RGvfJWJ0wo4wNyb9Kb2GiM6Qr0ZCjm5BFVthjYxW2g1fnd9G+xb1Q2vy4gkIcReG14cVvuyKnWTlolNwxPespOfFJp1j5xU2o0snKay13Q303dwE0PjWtKOPWnXVvp4Nf/Q1Up896O0HrlZzziMdr37kjvOXzaCOPOpmAVrQ9NeQZ9sSDDeRo/55rp1nh+M2de72N2i3f/QQXTlfGV9/JT6aLHHwZHRCkOMJOKh7go8Wt1dSkmaNP8mPmgWEq7sXnUpbtVqTWLT440bQTBn5B0Wnnb9Rmia2J19hzcfx1hXtHlUsS++BCkfl2kCyfM6Xsndi79F2dYlaYdav3iHyUuDnLO5M1torJXAVS4gf/R1Ac9HVvpALbL5MjBgDX/Us=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 11:52:21AM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 23:19, Gregory Price wrote:
> > Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
> > and the mhp_get_default_online_type function for hotplug use cases.
> > 
> > Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
> > the same driver code, and chose the dax_kmem path as the default driver
> > path - making it difficult to require hotplug as a predicate to building
> > the overall driver (it may break other non-hotplug use-cases).
> > 
> > Export mhp_get_default_online_type function to allow these drivers to
> > build when hotplug is disabled and still use the DAX use case.
> > 
> > In the built-out case we simply return MMOP_OFFLINE as it's
> 
> Ah, you mean without CONFIG_MEMORY_HOTPLUG
> 

Yeah i'll update the commit message, thanks!

> > non-destructive.  The internal function can never return -1 either,
> > so we choose this to allow for defining the function with 'enum mmop'.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

