Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D4BDD38FFF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757B86B0088; Wed, 14 Jan 2026 12:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4426B0089; Wed, 14 Jan 2026 12:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5DE6B008A; Wed, 14 Jan 2026 12:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 488D06B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:57:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E17B01A054C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:57:09 +0000 (UTC)
X-FDA: 84331325778.06.AA36B4E
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0BFF14000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:57:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="nCh5/BcZ";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1LfBQtSvV6SLM6qNtJr3uIJMakO8hJc3sz5OkZetqw=;
	b=I50FGRa3GcMpG29s7IX2hZrMOT2KJK3g3KOYDlPOCd1eEGV6VBIwlUCWbMOq98gxEcG+TW
	YJGknYX+25D/eKOODVgRF4YEOoI8HKW5Gbee+I8daKHQ7RoDB0pvRtEuZNAP4GmOTx4vnI
	x1Ubyx7DAZC2wi8m/c3PkOBWuRrkeoY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="nCh5/BcZ";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768413428; a=rsa-sha256;
	cv=none;
	b=tb0/Jff6wNdCKGHKimbRlBgZdxZhJSgBdAOMLuxDqR4B8HABf9hZTS9Nb9LLfWa9JmNVwc
	WHRT21dhX0BHEI6ZX3Spx6P207eoXuq0GIXZlKnEQ8dOVa6aZ7rb+7yHuM0w40HaVCN2SL
	nuDnC0QG55K9z3qv2oLT1dwao8UzJjQ=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-88a32bf0248so255846d6.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768413427; x=1769018227; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1LfBQtSvV6SLM6qNtJr3uIJMakO8hJc3sz5OkZetqw=;
        b=nCh5/BcZrCf/N4vHx3AzH/SeDlpLDI0BTdyHyHUzQYCMpq6ovi9rbhILacfGVvFWYi
         umi6v8017wkd7v57+RhjhXjqkFblFCVYaaY2Wo39uHtryyHsWXJMQWumu2lf1Gju0kf7
         R5F2wR6mOtqIiUxm+NTwfycCLF+lpoIKex0NVxxrIPIytbQX/esELQNRswODZq/6NDPt
         akFCLMxK6wLBffKY45bXngECD6O6UHfWXC1eBHJlckRC3HC8uMf84FhbepZwi0rso5Fe
         YnAxoOoxHPxmogg8VF04TYgGPZ5AsVm/yUFLKgwXfpATil4E//mwGoM8fA7g8zp2ZY6o
         8vGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413427; x=1769018227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1LfBQtSvV6SLM6qNtJr3uIJMakO8hJc3sz5OkZetqw=;
        b=kHgYUoCGZv7L+dbnT2hcaoSGLxk9IC5M3YoMahtef4EVKy+Mo5wUaJ8ssr8cW+v3N9
         axPV73cL4OaKcN/GMNvmVcQmxpOqKG5N74pyu5p/J3kmfkkPj+uPSPBylPX9dz5uoNGU
         vgOzMdUaAPxPYCurUFGHrTDAU9B+6l4S08DeZ9BbiQSXJH8XFpPbsXEv6HoFIldrHcZc
         obk3kwzX+MBWVqyGg9IaTIDIbSuHeEq0qkFcXzR56n51FKr85Hq8NxfocaKmD7TPsg1t
         e+AKOuoPk33rOgPs2Opq9P5Rrk4s7IHSLbiNBHC6fJQ3HW4ijp9EtXVkyEsBdbyxTszs
         5UCg==
X-Forwarded-Encrypted: i=1; AJvYcCV5LZYQz7DqQp8AqCYRT8pRPwfaRSexUwHRtiS6NM+xylmn1BgYkvm3Sa+OyyKZX+eqHmEOecaZkA==@kvack.org
X-Gm-Message-State: AOJu0YyJ6LurqhQXRLbyCWfMp7qmeLA/a0Z0Bzq+FGy2cmFlMRr3w49a
	yIg6xDJYevS11PfBgwopz2q4GzqAOlHLjHDcbBUdnI8r7Bzr+t/xEZ500x6rFnChpts=
X-Gm-Gg: AY/fxX7h0GavzVKsJEAQKGyv3L0aoa01T8YSC5HjT04/VOq4bjhLnA1r/vRUM6meaLV
	j0i87vOn+TwURekI9afp9QmjluN1T22ovtl6ngQ15M4BEtveqqhPM5FAYd4WY9xFg7vaU1rJ074
	ycGCkbWHaW1IR2nzCLqzJWM85AnvvDCUb0fcEft35bsHOzwMGDGwP+hz9CKlHkDzopozeAh3OSc
	amW24kiOFEUVH6XNJTa5BeXiyGRb5QAT2wD7PKZbjDKs77BA7+waXoyLmvaXI9qSlAoU2Y9xvoq
	JFpdd80P9Hw9jGvcysUHrwayS0Q4/z2ehu+WP7Pr4kSTiHBf+O5p8fLULH5vX0eKaGkZt51JJh4
	7Tgf1NqUcb7dX1bYyXcNMsZUIGBtWKcBt5r3iSaatckZ8iFSVEb4muRi6ASMCUmaVrrsIKlBytR
	N4XuBI10rv4bOOtu97o/wBcMSmPHmsMpaxTslISeNH1eHSamiRM9DWPH8qc3YakZT4l2Nezw==
X-Received: by 2002:a05:6214:485:b0:890:808f:c26a with SMTP id 6a1803df08f44-89274371674mr44821006d6.30.1768413426930;
        Wed, 14 Jan 2026 09:57:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530a73499sm206213985a.3.2026.01.14.09.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:57:06 -0800 (PST)
Date: Wed, 14 Jan 2026 12:56:33 -0500
From: Gregory Price <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] nodemask: propagate boolean for nodes_and{,not}
Message-ID: <aWfY0T6Crf9lb5Yv@gourry-fedora-PF4VCD3F>
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-2-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114172217.861204-2-ynorov@nvidia.com>
X-Rspamd-Queue-Id: F0BFF14000C
X-Stat-Signature: xk9rfmgsr1kafebbxid4mzcbzi45afop
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768413427-271384
X-HE-Meta: U2FsdGVkX19VWi5T9cs6/dFYtZpueZywTgOvF3vZr5jiVIWIU/8zxyZDjbmqN/JQNaxOBPdNIkqoK9XiHn3FBr3ziU5PtIrzwEm9wv1hVuuV2mHgaKzbWXCfRIS6sIsUczJS/nAEl/Q6I5UpGP/Dp5s+z7eb4WQlp6WOj811gBwtBJOqDC5xCkfJOVRslzsAU8IdrqqSKhlxx4xk9pZelU2vxXnbWayEzrzccG3G8u9ap9P8UbhBnCenx1R6SCo1o7noDEglAV9Ty9Tz4AG63mm0oimeH0ju45aqGNaXGjyDjY8Fp4Z1Zg3CqXkQjzC9ZLUlP8mA+eZRKSmxaE5I+CWrCbDxrFQMbDqgbpdGGRzEoQ6Rky7w89uzToxMEI9uuH1knaQAoQQ+yl/pRTo8TiyzIv+3DWh63zZ1u0yiVCqgIH1BD8/BglvzMdWOJjkklXKOckPmm1JNrFSb2b8fGj+SuqsleGXco6eVEoWm+rnY2RhzLAen+myREsjg2J87G5Pu5+PkZD7sSWGdRdMs4ucH3EyJ4MN67w6oBABrSMT40gBLFnXLBdo9Jc7EJncnwN8gaEuS45xsikfEHYKuWXg+662DxseCxDzWcY0uZpwSJgIuhGyY/aY+FCMFZvZQXrAyJJ5NtiGOZyVvY/dlrwwVbmBXyMUF6XEHGgDv/ZR2ynRTyg4W8jzoz8z2NWNu8FfLqISdVTe96hcQPMKwujtcFOjAxHZpJDH6qoj5zZewx5AIj8mbAK8DiP2+syD3Rl98ATez8vWbbJ0Wzrcy2PUemQbJZS8vrX6WfRp2eHqnBU/tn4LBE9Nx4uRsGeEJdE+JShxj5PChKCpyaE2khu6zSbymHlKz6O2alTaR+RvuWyGH2QnvSaezuTcl9yiUdm/x2uepx0+5X+Zvlm2LaRnp8vSVUHCx5a60aJWeQD1rbsGFDVBM++oxYLi85w1tNpZYYBvJoxGfzVV38nn
 Thi/b+Eo
 qmZ1V79SpVR+M/Nz0z86IwugzSZeBduJaLppMI8g2feffaWsH/yo/7WfLOjkJ8iA2IZDEx2EYrPj/d4CMBSJtV2adxzAr1an3tirlnPidV23Q3ltz7D0iFCCH2ein6Rc+YuHmegI/l52Ih6XmJogb44FCGJ1d7IrEPVJlskTHzWOIw00+Oz2d5vXV8MHR5ywF9oG6Q6DXvw9OmW4b9Ny/eAYwkj0JWECHDolguuMABFZaJOaWQPSfad131nRQV9M061lBwD7PGsyUDBXwmaPP3daRb+MNRmn9dw1XUvDoaR0rjzgzZLJcnwAj9iVn75yNBYZGAPid44PAFfrJivscq+SRru2VLQ4Ge9UEi8aerrhhBi43TbWNo3q6DndL5Hem820yuZhR1KjSi6XJ1caGENgzsefXr7E3Gewnzgfgx25QLYqpmvpLBepu9Wh81SsWlk6RttMG2zXL7jbGsrs5ebN3PQCV4GoUxBRO2O5z2v9oC4dm+poURKu8IH9cAbEQw5aSNUscmfdG+u02DKbTqqAblg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 12:22:13PM -0500, Yury Norov wrote:
> Bitmap functions bitmap_and{,not} return boolean depending on emptiness
> of the result bitmap. The corresponding nodemask helpers ignore the
> returned value.
> 
> Propagate the underlying bitmaps result to nodemasks users, as it
> simplifies user code.
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Reviewed-by: Gregory Price <gourry@gourry.net>


