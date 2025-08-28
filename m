Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6AA3CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A146B0026; Thu, 28 Aug 2025 10:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB006B002B; Thu, 28 Aug 2025 10:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33036B002C; Thu, 28 Aug 2025 10:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E36906B0026
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:30:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 922B01601ED
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:30:04 +0000 (UTC)
X-FDA: 83826400728.04.8F1511B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8B1DD100016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:30:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=n4XIC1rg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756391402; a=rsa-sha256;
	cv=none;
	b=fTlpSF+rGcUsO4RGuv0EB82xizWNl4A8gjD60Jv+gm6EQjCV+USPo22cwR0u6WGLq1GXUP
	/9eyq7kytHXspatNjT5HuOPkTgMXGCNTTkvql7+y1PYB1yz3u9qFHNSRD7uZuIohvDl/OA
	j9CqdA/2CSGvFcEXsQHHlKiKWN5QsLw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=n4XIC1rg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756391402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llJ1M4xxxeRjXKYFSOXlWlEyAgEpbCFW6TAfAztxyRI=;
	b=x5cCDjpE80rj+WiTOoJAj5SAEfTmaMSo7Jx11SaQOWtLdSCzSTyDINUH+FAZvaGV4oKsXH
	2OQDCT5BM3ojXZCyVqrKeZIltME/rM3AMpzzxTByQ2QwnCLv3rARU9vjp1+EnCV2TnaXRI
	M2ZT7Wia+6imI1hsdNIMBAEfY/XQUxY=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-248f08d31dcso71975ad.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756391401; x=1756996201; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=llJ1M4xxxeRjXKYFSOXlWlEyAgEpbCFW6TAfAztxyRI=;
        b=n4XIC1rgPRYvD1HqivB7hdFA4I6eIX6Ar5uk5yUf87Fhe0jVbJoPPscprdllFkPU4W
         5pO/Malx/lA5IZv5gJhqX3Wmvja55iiTXE3bleeQd4xX621nLEMLgRG6M6lr+yir2XE9
         z8dp9QKqIY5Wm2IBjHJZv3aduOf2N17srdl9n9FDiSGRC/I7sDNeiaQonl+igMPxCF2I
         Cnn2XfpH+mlpV++h+V8BHAYBPiGO5Lib3Zr/g7XO/pScZ0Zze7Cs4ZNimuzW2lPqbWZP
         fOyA7fsGgwpIN/M2GWBdLD0dk3GqC6mL8n2OUWKzvvWj6Y0ajOl1mM/gZ3os5V/iHRYs
         eCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756391401; x=1756996201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llJ1M4xxxeRjXKYFSOXlWlEyAgEpbCFW6TAfAztxyRI=;
        b=Y/BRxQ/+LmuXi+BzMfj76K+UPXVb7qrCHG+cOHPqmfkghJG2SBSJC5QUSsvodPZkBv
         XQT6pxu54NXE0PGTc6kiRtqYFAKp0qfnI9TqRyzzgsNEI8fKJ1Bzr6MNUNN+0WAyC4bM
         1IhEEP62l63Ikr83gJWFD92P7s2z8wIqWU9AXqHgKl6e/TnwbD/EgVGl83Xgx/bYhtap
         azOcu+uAdXiEiISTbgjm/TRrLWDh1TuXCmlItmv6uTfmOQ7C6Rbq/vC0NQMkG8QBR/rX
         Ggn/l5IYL+6qAfz0RmJ1/V61Lkah76qnz79rZ5+u3aER8XCBu8xy4uz1yvuDnrLw72Dz
         MBFA==
X-Forwarded-Encrypted: i=1; AJvYcCWYAemsmqsDhuGG8g+O6zoyoP4nJ8qPr/TsOI5RsK0usd/TIC1GrfJ4gn2Fj/XQgXnz2heteNP9dA==@kvack.org
X-Gm-Message-State: AOJu0YyTnEJuiDsE+etASuyM0msFz7O+53HlOtEseMikog0X0X5d8nLm
	j4rh574aQLRU1sK8YknXR+E64HMKbLZhT+DmxKhm1Vn9EPLIxblnP/Suo1v83WjchA==
X-Gm-Gg: ASbGncufqdix47KIq8jd31uIc/wlugRQhWcMF/VwYBOxNfU1tT6qnNvhEYFPS4tvTpV
	Rj6UAxjkea/NbemsgMeQAVocIW2rgTBF+mcLscDNpch9HNvo41Tt03Sz4vLqCb9XxqwMwX1TU0r
	vzyg0cpcAjGH6EoH2/hlrL8kLq5Hl1XmLoobqS/k0A0Dy8IT2jpgNgxTq2m3WCJVvbenCkiAyd/
	8r2VRlbUJwPETsnLecxHT+Cr2GBUdHdX81l8N0mSlsz0Mm3GLvaPg/zRB3FzfWhBOYKFWoIuTS9
	v7GtvTkCGFptjgTmg6vNoWbIcTN7jOBr1Petp3+9s4IGwHfT1Ltx8Vepj3v64NC8so0A6WG8sw7
	uDIbcastRHErBnOFEKjUh41KPNKbOkMIyX5g+HrMLvgYBYyDIOKRHoKHJK2kpdhkpwL8m/DFF
X-Google-Smtp-Source: AGHT+IGqnjMUnHwbY8ZYK4ZrateHqnkIq/oBjnMDFO1wIh4c+rK9agNtu2KOniT/7Fx7O0+N24b8zg==
X-Received: by 2002:a17:902:c40a:b0:231:f6bc:5c84 with SMTP id d9443c01a7336-2485bd5ad00mr16238015ad.8.1756391401204;
        Thu, 28 Aug 2025 07:30:01 -0700 (PDT)
Received: from google.com (3.32.125.34.bc.googleusercontent.com. [34.125.32.3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327ab094f00sm2684545a91.6.2025.08.28.07.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 07:29:59 -0700 (PDT)
Date: Thu, 28 Aug 2025 14:29:54 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	kernel-team@android.com, linux-kernel@vger.kernel.org,
	"open list:MEMORY MAPPING" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mremap: fix regression in vrm->new_addr check
Message-ID: <aLBn4vb0Pmwoqt51@google.com>
References: <20250828032653.521314-1-cmllamas@google.com>
 <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
 <53b938ed-dd78-42fa-8cde-f3a938b6f39f@suse.cz>
 <b58449cc-022b-497a-97f2-c91776d133dc@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b58449cc-022b-497a-97f2-c91776d133dc@lucifer.local>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B1DD100016
X-Stat-Signature: yzzpg781x74xnhb57i1irddbynkqri9p
X-HE-Tag: 1756391402-345086
X-HE-Meta: U2FsdGVkX1/NwKMENN3eBZvhdnQ9LOPH19Ui1w/DBp5lHy7qsLo5lKck94IVpIeWLpTVoZeclfAuupbLk5t0Tz/MYhxR2rw1fOfHNt1UgFBr+Abb5CX/F2YzC6/IHw+tklXsP/l3TW8oCgOf/9KMaDyoEzZXglAPPE8MjIwPk/91aYVOuU7gNaK9vMUzHF48gj+T3NlsNV/4YLA6xZQhoBeEkQsrVoStLuLnkXTaxTF7wm+UujLoLlSUAs2r6Ip4+zThe8KE9AX9s1KJEYG4l54uhtLe0/j5MheLBiv5TR5EDqbkvo87CyYSbqxJfSQ9kdtJ81BGBm4NHaC+H4XnwZYkCa3Y9yrD98Hb4tGQ0zQ6Ju5gu3/w6fYSztamw40ErjAYBqlErzPMhdczgWjszbtPDBgrGHy11CKC5WLNN4RGSyJebOcoW8/6gfQAQi6NCjCfuM1SU10hKJ6+zlDsa8V8cusSUhesdK4ag1wJzB+f8XTkFRfFCR/rojNxEKlps4HkyXshsx5QuLee1Mm3B1sYzeojbYwEGVPH4BBGjzRu3WKBbniK4+xX68Od60dZzR2Sp9pgAxxOY363ev0zvI3jz8iNQA/ibuCtdVcsXv8YnINwvhduuChzkvJSiNA1OechFr5GnF/PLEsTc+HqHC59G/d+OU8+RNM1OHHnb1ki8VRt1uWQ4ksHABsNF+mgo/u8wbnKHFPdxzpdc0PNXzEk74/emv3yEXGeM9c4tI+zeI4ExBi0ThobQKcU9T9gwfUKGr2ky8TEPA1f1TpcYyYzc6csYW6dqNgSdq/17cIRHO73pGaF361ftqrumUdmwpXZtY9wcROk7ByxbdR5Y7mZLCZznzopizqdWe/7KVgExqMaYl35YBQ4ADKfqtNTpT0xbR50LnKhzCiQvFWzyvB99K0dfNZzJLYEyW+mLsw8IbOKpVXkpgv/nAFwX1j4aqbHQ56K4ZMo2/yoIar
 Yg50rH8v
 sD140rJ7yq8wdJzf11SH22+oRuETuubWiQOdGgxkltAN1cqppYcergLb0DAvLQfXIUwFT8zI6YTzGdo1DQ3lCx806+NCDc0axjfZG1WXTc0Yx2bgTtHMy6NHU61mFNs2qJdN9W/q54g4yp2FJClclqeycYZFxH0b/RJ9jePt/SHLldhAbGZFYhGDpFMCPNuNA9G9B0I9uOxRp/vxCiIbedolvt7QyN2WgSSWXPZXfpSM2awN3An7jDB4VAeDJ0dJNCIgb44e1ZYR7Y8Q9rXAecv2RnsBR82+sig4NCS0TO6eKtPCPizv8biEP8QMc2wv5ygBc+m6pEYWZ6v0D8Aa6uhig2RAkzRtvXibEEvpwEctuhl63A2/dU2qjyQkLW/hEybH4iYMmluYCGVU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 03:22:54PM +0100, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 04:21:05PM +0200, Vlastimil Babka wrote:
> > On 8/28/25 07:38, Lorenzo Stoakes wrote:
> > > On Thu, Aug 28, 2025 at 03:26:52AM +0000, Carlos Llamas wrote:
> > >> Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
> > >> checks") moved the sanity check for vrm->new_addr from mremap_to() to
> > >> check_mremap_params().
> > >>
> > >> However, this caused a regression as vrm->new_addr is now checked even
> > >> when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
> > >> case, vrm->new_addr can be garbage and create unexpected failures.
> > >
> > > Yikes, sorry my mistake.
> > >
> > >>
> > >> Fix this by moving the new_addr check after the vrm_implies_new_addr()
> > >> guard. This ensures that the new_addr is only checked when the user has
> > >> specified one explicitly.
> > >>
> > >> Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
> > >> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> > >
> > > You need a Cc: Stable.
> >
> > No need as the commit being fixed is from 6.17-rc1?
> > But it's better to use "[PATCH mm-hotfixes]" to make sure it goes to 6.17
> > and not the next merge window.
> >
> 
> Ah haha really? I'm losing track of my patches.
> 
> Yeah sure as per Vlasta then Carlos :)

Oops, sorry my v2 raced with this.

