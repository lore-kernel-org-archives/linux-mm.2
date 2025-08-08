Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522F6C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22E16B0095; Fri,  8 Aug 2025 04:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFAAF6B0096; Fri,  8 Aug 2025 04:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C102F6B0098; Fri,  8 Aug 2025 04:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7B9D6B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:48:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 365E15FA86
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:48:35 +0000 (UTC)
X-FDA: 83752964190.27.5026074
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37DEFA0003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:48:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CoNHPySa;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754642913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9nfb25BPwvJZ+khUKkOpGadyQIkm1x1hsyBk6u4F3w=;
	b=G8cN+p+zOAHEgFSyt95EP3FDjt6KAVIOxKVoSfhm5Ujj5QFSYkP8Pu39+iYt3AvPxZ8NZB
	OabJzx2Jh4F0v6h3NcG37bGy+Tcpy96GKl485C7BVDNYwkalcpe3llA8aoLAAkfUatY8iB
	n/BCbVmSnDF+g1Q35AgmUS3PfPR3avc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754642913; a=rsa-sha256;
	cv=none;
	b=01P4NKXZks/VGnP5kitrZMmMAlpvLjIWR8m7XYG8MO1Wpt+c2q9O18tfj3dHF2c3qFZZfp
	rDkERJrHby15OJAtlmNP1F+/CWWc5XwXN5Zmagm9E7HypOuzbX9xLjmQj83N5PigHAPUk6
	KmVh3mC1Ov28Q+o0I8gyaP2dIA/ZRBw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CoNHPySa;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3326163941dso16338721fa.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 01:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754642911; x=1755247711; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v9nfb25BPwvJZ+khUKkOpGadyQIkm1x1hsyBk6u4F3w=;
        b=CoNHPySajVr7GPcXxopgLUvTmtqLeuzhoENztI4bLda1U1jWvxrcUZXcgGFS9HwHC0
         3puWk3x4tutzKooavhJyadNqbiQshjODskPZfArg9hSs8b0iyOiQ68fxRP4669SGvZbP
         6gaP9DbU5g+H9Y1j0BpfMdLM9K63feZhFpgk95t7uC2wTcxvw0gNTaXGXumAj+2wca0Z
         OM0zkFRTPWKamJ9ZMUkuZ87yE6H1VyiR3BdgEQ8fWfxzWL3QdFQKvdcHQYmmm1VvsmOi
         RYEQ55oVy0hlBpwgSvHfUv0Xff61n7WFgmmcbohJI+M17EKeO39ofPkvkZ/X+w5Bq0rJ
         l87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754642911; x=1755247711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v9nfb25BPwvJZ+khUKkOpGadyQIkm1x1hsyBk6u4F3w=;
        b=t1bV2UlfuTjzMYwUZt2swvwB63bYdtI5hpnRTp/JWJTljZVPHcksEWmEUWg20v6WJR
         XRgXDUE+gEJVs7Ql2XLLnHXMcDUV6UAL89UAvuUb3BYGedGScy9JkMPXErNuSvCz+UUZ
         XHb2MyBv866XL6jGs/1eCc0PIEMXHv/1qxRrltOS/xwueC14oh8S2lBPgdGa//HxyUQg
         rcwEQ9ITYDYVydWfvYNBdUoZTks8LYDTBFn29QvCaCFMHFYrgkFPA7Nv79rcxeGZwG8p
         I5wRlkXIQaDRL/pF8J73yj/qHaRFl+sl3PssKU9IUQJ7fN1BvhM8BhfHhSvyCuOibo10
         tuAg==
X-Forwarded-Encrypted: i=1; AJvYcCUCBkRXtM/2kPL8vpg96+cTqtiTsW0eGKnHDnM/o//01zT+Sr3yZOGwos3zZT98naxsJih6r5X9Gw==@kvack.org
X-Gm-Message-State: AOJu0YzmZCgOXdx4/1L5LQOalwG2+4/3qxrWq5jDXIu2KRzwSxy95NX3
	8wTcaE0WuqsdT5I79WVslnE64YrqS/V3yebOjUP9cX/6JpAO79ZFpd1E
X-Gm-Gg: ASbGncuykM+O1dDtoU9JhcLAo6Ucvs6PwTrd8+WfI0ZK3lHAd+if3Asren/dPvtCbPQ
	1mMdXOR7/xWRTKs4trMgHOD8ACTcSMyMAvPBTBHIdGR+0nlD/ENWqgJ65yEnV5ddw7JrKnqYLXm
	DuryBsR03L0TXGrPba9/SXDm1naRzOL89quI3pDvCuNrdDJJYCuMiJQ7I5LdhT1/N2CFEkHd9LI
	tHackFaJwwUPxWu3cdQ+U5mSs8G0G+qoI2NQ+8IoqAcqdOINVzPrObcVSLxJ1DKaBGCsYVPV2bv
	QPDnaC9+ANJAQb+ns0vYW7ToioLJndFo3/DaP2UzB+HAZlqV4GeBuklC2YFtTBf1h3yBDfOeAHj
	ukqCYHtH9mhHHIAewgrhh+389nGkdANaIH0I3iZNazSDTOctTzzuiHM/TH6zf
X-Google-Smtp-Source: AGHT+IHvT0XYEWQ0ViZuhDl7GWh1hgaQjAzFy5t13nBqp0OTBNM85tmsrZa7UxMhIAMZiOtWohN+RQ==
X-Received: by 2002:a05:651c:50c:b0:32b:7ddd:2758 with SMTP id 38308e7fff4ca-333a236da8emr4056051fa.0.1754642910978;
        Fri, 08 Aug 2025 01:48:30 -0700 (PDT)
Received: from pc636 (host-90-233-217-11.mobileonline.telia.com. [90.233.217.11])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3323a85d7c1sm28777831fa.68.2025.08.08.01.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 01:48:30 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 8 Aug 2025 10:48:27 +0200
To: Marco Elver <elver@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH 0/8] __vmalloc() and no-block support
Message-ID: <aJW520nQ78NrhXWX@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <aJSHbFviIiB2oN5G@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSHbFviIiB2oN5G@elver.google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 37DEFA0003
X-Stat-Signature: 3abeb9eaxffd8mzomqg6qctu8y84xazf
X-Rspam-User: 
X-HE-Tag: 1754642912-94949
X-HE-Meta: U2FsdGVkX1/eLFSeDEunCt0H9mWL1wbfaNjN7orH9exv+AM4pKEDFn0gQZKy8S8FCbg4jZnBhP7QFM+DEVVJYBXvkO6pg3E98aBQn5NpEOUth+Ctp9zBQc8ESADjoGgGxC6ZNrwO8+hDxF6BWaSVZ3eJi1Mqr0Mg3z1vQmScnna1z/Ci1N5DK8v87v9m/XhR+moqSmFTF82eWfOyMvYOu1QNTEx9X4Rgo/oi78s1ZaKS+Vu9OOmB0LMJnu7isDWUHnZz0cl8gDzsXs7IcoLTuh14mcHuExCwTQGsOPZom1L5h0BW+SJEZPs6QylxprKyJYE7mK6Bw2MfBdPTC55LuuXBChiaNFkP+ha1CM8tiBNTdLTSJlBsXL2mIV5o7fVmiN5Bu44+wyjWKnIqIFlsK0nrn7yI36hVjF4+rDWWqG+5Z5wX18WuUYGxxjBJY0rNc+JxtYc2N69pIGozX6Jo6FeriKlVFliwm/cLpjigNkE8SzqM/307kVENPW9M10OzgqUe+7tkeB8lTLIaoA82X91tqbS7hADQa7ajEDTmw2Y8SjpaCJOOWEZ4pEE94VVg3YvsYZ0HGInnlEth430P69oq/873wAW9/0SzeU6aCAfo0JNIyKZ62bkOIvQy2oefyNdmVvGyGJwCrMBdAkiPw1cmthLK1xrgHLmThzd4dN/0L3upjohwaS06Cg8HuCldkidvBdpjs7zrWgEscggTZXUPm1RZZuQ0001j2wvPibf+MWDmkKFe3LmtKucoK74m8wSWFfzvRhwO9rmhKSUzCDHVkUWdcOorng+WHS922dxyme8bc61oQLWYdmMpuY6oaE3AMtqO/YGA1qWYS9DN67ZqID4TCls+CXHIT0V0/iNmEyKkaM+pp4J1Xh4UaV5h51+XRVGyi/tVZJAeZTEKaCGv35n8JfP0/CN+Voh04q6nztom/B7JQBRw+Y6BnufIcY5d0E7QhpJrUzoM75m
 4+E89F2n
 fK3RQSJXi1AIsUZ4rrJmQVbGZSyEoklbDY4Vk6Z7dgdtZ+MJKRueYQTqlhJcf51oDCwTccHEQqntqIaRNNyDITA+ojrPnf183t3FXkQhRbtZjcHijrolT3lvRY6UodiCI82IjsHVII3UVJiesGMIq8lvp3AAihFx8RtHFXy50xuASBgHcaElnLXlvqYq3HGaS533cE3Ohm6ZW/zE9LMY0ZuaQY6kxKS0CAVY8cXFVEXEkJEqJvmD9OGGSc+ZoNTr5Un0MtCNrhUQM3GkVGqahBJwuU8PoSGCL5anfmoaVY0C7e3va+yJwt6gCgY19t7Qqg3FZpIVbqX9W9md15SB5owu2z+f31Jg9yQoJFD5Ls7F4gbKuVA1I0Kgqe/UxKbyTQmnYnsnepQUjNyMIJ5M8s7xNik6OEYeREbPyd4p3t4cpiCKDA6lQYfS4VnpH7jkI4l1Ct4Q88YWa/VJuMePqS5v0Jzjmxcpc3GWroC5Z12aDpbhW4rk8K5PX388X/xeKE1BLdD/XO9r96N/puytMl2YA7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:01:00PM +0200, Marco Elver wrote:
> On Thu, Aug 07, 2025 at 09:58AM +0200, Uladzislau Rezki (Sony) wrote:
> > Hello.
> > 
> > This is a second series of making __vmalloc() to support GFP_ATOMIC and
> > GFP_NOWAIT flags. It tends to improve the non-blocking behaviour.
> > 
> > The first one can be found here:
> > 
> > https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/
> > 
> > that was an RFC. Using this series for testing i have not found more
> > places which can trigger: scheduling during atomic. Though there is
> > one which requires attention. I will explain in [1].
> > 
> > Please note, non-blocking gets improved in the __vmalloc() call only,
> > i.e. vmalloc_huge() still contains in its paths many cond_resched()
> > points and can not be used as non-blocking as of now.
> > 
> > [1] The vmap_pages_range_noflush() contains the kmsan_vmap_pages_range_noflush()
> > external implementation for KCSAN specifically which is hard coded to GFP_KERNEL.
> > The kernel should be built with CONFIG_KCSAN option. To me it looks like not
> > straight forward to run such kernel on my box, therefore i need more time to
> > investigate what is wrong with CONFIG_KCSAN and my env.
> 
> KMSAN or KCSAN?
> 
> [+Cc KMSAN maintainers]
>
Sorry for type, yes, that was about CONFIG_KMSAN.

--
Uladzislau Rezki

