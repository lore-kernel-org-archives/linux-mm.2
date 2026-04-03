Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB23E8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 17:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5306B0005; Fri,  3 Apr 2026 13:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1757E6B0088; Fri,  3 Apr 2026 13:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064206B008A; Fri,  3 Apr 2026 13:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E868C6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 13:15:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51F9B14070B
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:15:09 +0000 (UTC)
X-FDA: 84617895138.12.8AB4DCA
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 21CF440011
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:15:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cP7eyYsW;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775236507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIb1V/U3iyEpQy5G2ZO1niSW/i2jfqib/HV9z8tr9R4=;
	b=dnuLTsevE/am/Lb3IYx8R0CiSesU4c3z703tvc3k8oU3zHI0OPiJKQMkriRvWWq52G6/mc
	TUAGoqi1uVTJRhxrd8cCfdR+yoQVxY0N24NzKgGSTyH2vU8U37UMPMYOOBNe3BBwJB7Wcn
	BWCozxADzzdMVohPyQLepoDSgD5Mpjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775236507; a=rsa-sha256;
	cv=none;
	b=mlsEpKFUIzWeSrUrHbUO2SnzuAzRNo1dzeLo21pJ0/r1H4DYCkZHNokqkdRdJanz4UlOCY
	KYDKy8ikbejytSFDohYqSiWsLU2LRJs+dyJ0EmwY9bH3pGHJl69YyaRfIAkrPtp75n/2gT
	EvwxoHaQdj9dhhe3wREG9zrz/9wZtLw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cP7eyYsW;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cfc085395fso188930685a.2
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 10:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775236506; x=1775841306; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NIb1V/U3iyEpQy5G2ZO1niSW/i2jfqib/HV9z8tr9R4=;
        b=cP7eyYsW+I13Bs5MZ3Yx8hb+OC1m2oMtYOF1MCmicOroGJ+5BqjvqS/HqThbm7hB9t
         uxA/4AZbsNn6GEEq2NZ5y3+uosUVZ8/Ia3J3A+49rbzb41MZn96XB/4T52+m2Biy2hyW
         ncOoAjtekWV3c0qxoN+NQSqumIDu8Bx9TzwB52OmcyT8MEXTYjJml0uBvpof4du7OUdm
         B1H59QthihpQoSmJsLt9QhEFcNarZwuSMQ47RH7c0iIcMlEw3X2w1snjTYo6Y/vHIz4a
         VsFjW2bzQ5hNQhfouqKp/+g9Ext1XcSi1BoNBpfGyVALOKSbzxlucueHyB9pITzlGaOG
         Bmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775236506; x=1775841306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NIb1V/U3iyEpQy5G2ZO1niSW/i2jfqib/HV9z8tr9R4=;
        b=rR2SzpuQ4hm+QrzokJd1h5xOr+VOnHRJkTFHYKnl4MlfOp0zOvDihTQmvbdyujyvWh
         lzhcwe/0kYOPqyxp6vDrTG0kkHkuu46HdGSHugBqf8RZygc38XgQD74Z7uHNs54jVRbo
         hnLGEm7Or0TFM5JrEWpk6le8tWhK9Tpxbw89QxOE1LBt/E9dcVX5773B4ClIu8XasSoz
         QV9fLL9In/9lCkYq57apeOOQW8Cf9D0oVwwhOFNnYBB9W3Kegm+RXZUtxuRK6f+iClRo
         ih5UDbD5O8po4V1zr3dxk5Mi7HJc/IS2BbxeeIHR6ZIR6glaeyBtPHVFaUcX0hapAIzV
         mtrg==
X-Forwarded-Encrypted: i=1; AJvYcCXfCIwedexMSIVPWiQLjKAzmXWDtEO8JvQBopZxFwVHJiHZccKydgN6yQvjif+bibKKyLuy+1XBWw==@kvack.org
X-Gm-Message-State: AOJu0Yw2yqSb9j2FYoVyXfz1N0K1g0ILOTF6KlHX6TxjIXIWgueSdGH4
	MGxUdvHg0jecj+lgKQjLIsMh/r81/2ErU2pVY4O99S5K/fq1loQQAKmL9yO9OLwMe38=
X-Gm-Gg: ATEYQzxXwNdEFJnixVnEMFsPjyldRlqOqThsjBGrrG54D660pbR5hqAxe4u4zVBd01l
	/esRMaX4lZoZpfvKMdDjAFsrflovszbw15DtcA29H1J4uuRL71RghIm7Y1PewquZY3xhZhrpu4a
	JisK1WbKmxftxFzt+avF3M3wZt0g+CwRKiUjxuwFkeAzDSLkZC6mZR1oAyynOsY2Cr6UEP/ARFq
	HI0fqpjAx93sSV83RTyZNaTcrd/C6oF5kZ93MuQZX2Ob9UQG/iDk5mQlH+kLfYD3OAR2kt3x+Oj
	vDsvsH+/omuOXHBf0WO9XGYpTprf5PjadiVRa+4zzsx3mITfUbMMyxGLkGcPBlD6Crolk2GQD9t
	V9vVc9Bc8UDjyV7tItD9k2O91lRSrshGrERoEpLICT4xzLUlrcxmbZYEgN+N+QnkfP7prF1dAud
	wcq+IfwQdBaIl39idguVil7w==
X-Received: by 2002:ac8:57d2:0:b0:50b:b32d:b55c with SMTP id d75a77b69052e-50d6209bd29mr57954271cf.0.1775236505840;
        Fri, 03 Apr 2026 10:15:05 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b93dd10sm49032401cf.7.2026.04.03.10.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 10:15:04 -0700 (PDT)
Date: Fri, 3 Apr 2026 13:15:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Eric Chanudet <echanude@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>, Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH RFC 1/2] mm/memcontrol: add page-level charge/uncharge
 functions
Message-ID: <ac_1l4Fyrq1AhY8D@cmpxchg.org>
References: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
 <20260403-cgroup-dmem-memcg-double-charge-v1-1-c371d155de2a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403-cgroup-dmem-memcg-double-charge-v1-1-c371d155de2a@redhat.com>
X-Rspamd-Queue-Id: 21CF440011
X-Stat-Signature: 5tfnu4u83yydjot1dhcanxdtb7ue1u5f
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775236506-351008
X-HE-Meta: U2FsdGVkX1/67wVvdOFQEBkf9z9Ss2iUDhlbq+A32dv/SIjlnp6p+R/xMG8EPYkQx7ux0SGAFB8EkDFPGqsQlZRe4//9n2tf3ck4YBaGnScMQ3+LKDWpBSQWte7WTZHs+xgGY6peaFscj/LZwSUtyIGQtSKaWV2Lo77RUGSWATQeHXB7ezyNrLhaQNLDUTcETHaJ1k2n4iXdKm2nARwO3tSyalrKnMqXzJReIlFmkUH7e4Y3pRCVPWdixawbF6RO3RL7M7fMOHE5wephIar4n2iDTo9iBJUjz04wTGz0xuKBny+Xn2pVVzu9PH7rxJyoq6Amfg6rE2SgQ9V1MxRMQLEbVjX2mFVJXMbTuZolcSZADhgrm18VZTjeiO6BESXWviR5HrIa4oVqc6MqY+Xz6emWGAa74Pu0ACsNbaSbdi+7KbwkjVkPMIySxkIUnR1wJCjzmiMw3GgFpudP04ZKCpcrVPY+4jwv02lh/K/rTz2pFw9/h3b4LXjCjhfDpUaZCBFAQtjAgNfgU1e7uyAJM6HbBmz4rQUvpu0NWvGm6RsWnKPUx1iYwtuXDz9s38ksssK8rT/zGY+aX90/MqpE1v9gHW3gNDfWUPpIq9D8jVNNZxFNShXmAIDRCnpzL+GGjGvrfMJEm0xu3zjorRpYvdldbrBEAXc/+jyUYvD1bwL+P7uyxZKnalkKe+enqNiklt8gM2FIcaG7o+8IpUmfQgLIGcWLZTlGa0Zept5Da7f80W7Ie8N2GiktaCd34FCKQG4mozBC3UVItO6UKNy1Al0nmw6IJF0yBOutMGJ/2po9rzXAbAPkaZOzbf83hiqpnwPclIn9OqUjMgE4sL80AY55iVSgWKFMuzQlf2v/vPmprhTZ98OQca7OnlebtsPxDeFA0sMrpfG7WM9B/EbZ7FMZ37LOyFo5aye7ss620sCeUfDDrCxC+iZHpH47HltB6PvooAxfheMb5p3Zhth
 DfQJR3yV
 rjk/01CQ67MTFBrfLWaiiCBCKZt3UxNmoix+EvvANxvqQr5CLUN8jNapT0N9BEL21kJFwDM8Xy7UoebSpkAODOZ1laXIV7Y4fejmdq4bx3Fm35RTtqGjimT6VfR82qWFN6ApgXVZGMW5dv6D0jJKZz+pTk3zB/IbsOWmZWlUbim3cPeqL68VIjf/giFtrKTWDP1PQ+HCc/ZkbL5PS8FjzpSUptwka6jcyGISJXssWK8iRXql/hIKNO1gpWnRp6pfMuVNbCCZvtifB047gXnURcf/EBIYoj0axCpB+U717s65D/0SReOeELXT4/LSE6Pgy8ZW9UiQURp3PY6ET/D181bm13OMj4Fl4UqgBDL4sCV6K7MnlkUPlNg/X/4aC/+6QCRbTwAcem8uf/mSkA8SnGJ4/oFteXuCtO7G1eO7+8pbPzz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 10:08:35AM -0400, Eric Chanudet wrote:
> Expose functions to charge/uncharge memcg with a number of pages instead
> of a folio.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>

No naked number accounting, please. The reason existing charge paths
require you to pass an object is because there are other memory
attributes we need to track (such as NUMA node location).

