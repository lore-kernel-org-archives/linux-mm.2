Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56294CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF1BC8E0023; Mon, 20 Oct 2025 11:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9B28E0002; Mon, 20 Oct 2025 11:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A066D8E0023; Mon, 20 Oct 2025 11:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93B938E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:06:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48139B6E52
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:06:03 +0000 (UTC)
X-FDA: 84018817806.01.60D9537
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 603864000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:06:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DzZxabVM;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1mZfa6PPfYiWQUvQbwihX13IYOS0TbObq87rU2SWyc=;
	b=7pxmT1M3XXw0AzyF8a5qMEewi1uYBGbwc8arEmZqJznvodlzzn+CxbSSmzHFXQqhMa11hQ
	ETDoIlHNeEitZc9K0G8O4uo1GF8SwOhWarccmj/kYNnyGcWUKsMww+7rylSO44rz/4mslQ
	jHae0MwtfmDoUp0dr8qgMVrExR8v0cg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DzZxabVM;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972761; a=rsa-sha256;
	cv=none;
	b=bZFM8RQgMpatDzPKS3+H9RydDKk/K+hnnx2b4IebZr1JdLe1WkQhAiaS0kJzk/AAUsMfw/
	k32UuqrsAAvsW9hq9ePHRXTm3OJIIDkUfp1HTffLfrNTzHOFxqmo+VyFb51I8I/J6gSTFx
	Jz7HR+GYXqgKz0r650n0FwLPR2H0ahE=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-87bb66dd224so61745756d6.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760972760; x=1761577560; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1mZfa6PPfYiWQUvQbwihX13IYOS0TbObq87rU2SWyc=;
        b=DzZxabVMEO4rsIdv3romhv8KU0Owq2fdrX4cgu/trYECYC4bsZRH4lL8ov9vKE2rCo
         JJj9i01vDgvydiW8MpTDPhPmzusJn+6t+ijMrW5pBnGOH1qAkXYYMnBFmqQHlKoQKUn4
         +TYVtOh43zWh8uo0BDuoV01x3A65D9iSXTMTHQynnPYplVUE1oPURdDKxLogZ7HKiARo
         QfBWw7YGVPUNoUvzvp8x2DOAdhOf61iiVcUdw3QNRlCF9486rz4Ux4P9S8GniK73mHD3
         vH6N/Dd76+UCVuLQiJ1DocpLDnKs6OdFelFaGifPmqqOJEDhDMVjWCZOoTUj0vWjx6+d
         r+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760972760; x=1761577560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1mZfa6PPfYiWQUvQbwihX13IYOS0TbObq87rU2SWyc=;
        b=t9a9+BQy6j84d8SDnjfTS0pYku2d+mvmHdzOKLhM/lmuJMu+O9JSSs1meuTYtZ1X9k
         KVYsdQwaS3TtF5EWoAn0DkVsMynhhNglV++s2WflNcehNdDps0LhePiV39y4lEy4yrlV
         yO9HcLEZdS4bcZk4EE6Rpvlfqu+R+O7DdcuTvCqMaoQZ/auV6of6AmTelTzqHa7QAFxB
         CcTFl5t4z7NgGjpluIxDrxWSq78tkJKkd8A1O+cSVSnGB6rc0+Vf8Hdg0DW16pIUXnUr
         HHAyUPcmPGqaVxZz4ufxhhYDI4RDBCMApy3MqlRCS2w7rs84NLP9B4bEFpsLM5YhiJb/
         Gy3A==
X-Forwarded-Encrypted: i=1; AJvYcCXUmvzOiMycO4cesci71nZZv5pmMHsawkmzfLBGz/DlqaZPZ/YxMG3ED/9hnjNjLS9PIVN9dttKjA==@kvack.org
X-Gm-Message-State: AOJu0YwPXg0HNTA4Ht7Z5Se/32+rHcseiwgINPyDOA6jqN57ft0ROdFu
	wuHmT7G1TL9RVRtIyyenoBhhaRyb4id+dAZJyK+1mNalholHULsPa8tjaDKMbxbqIo4m1yevFzS
	qSguD
X-Gm-Gg: ASbGncvcPyqDPaifQnyLAoN39S6i/UQXoJNXCPQg61MwKgX54a9n4P9yVyepncbFsQS
	seO9/6e3xgwlINN/FDWHUN68kBRTC2e3EWe2sXkqPwSAmXCUV9+RKkehsD4gx71spX98a9hBPVx
	MrsV4WNRx+lvbobhnTdq3G2KGXD5oYhs+vWS5HeUa+l4TIGK736MbDwF+dyLYwLv12UV+y3JZ4J
	PW5HPi6gMI0vTGfOOOh8bk5TG4ykZyFKCyPCoVbZaG+irS6a7g6sHkV3wN409rRj+IIBV1byFi1
	fvd+I08UBhPUK/3CfvUIlVA1AxJG2dY2PrDeWVDRRTW7emV8t0Y51Pdfv2QGtOclx5//WdO5nDd
	thzjnO50g4lhguu4QU6Ouqzzhba3r/BWCt/oTOGPOTiUUTrjsvs8MjQFbtyPZ2mQC2KZTDksSf0
	Tjf7tKNRNa8kWcbkFBtXxfvjDymr158C/D7TljaFQc27s88Jz0Ljo8FzI6/eY=
X-Google-Smtp-Source: AGHT+IHi6hTC/FllE1Hp/tmAHDAJqxkK+nzpm+chWs/vbx/HyCSGCja8fWvNBZvZG6WZVkt7B3u62A==
X-Received: by 2002:a05:622a:1820:b0:4e8:9459:4f61 with SMTP id d75a77b69052e-4e89d355d9fmr163821891cf.53.1760972760160;
        Mon, 20 Oct 2025 08:06:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8af0126a9sm51384451cf.12.2025.10.20.08.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 08:05:59 -0700 (PDT)
Date: Mon, 20 Oct 2025 11:05:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aPZP1eb4moioEOhc@gourry-fedora-PF4VCD3F>
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com>
 <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <20250925160058.00002645@huawei.com>
 <CAOi6=wS6s2FAAbMbxX5zCZzPQE7Mm73pbhxpiM_5e44o6yyPMw@mail.gmail.com>
 <20251020152345.00003d61@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020152345.00003d61@huawei.com>
X-Stat-Signature: asbdsmrrejbom6khakhmfiqba7anc44j
X-Rspamd-Queue-Id: 603864000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760972761-3090
X-HE-Meta: U2FsdGVkX1+X5/v+vJ5WMlQ0ijOy40v2mW4Bbg82q4KqPhJ0AKKs9Agl9HUkC/HBbwCPfhjd6Vj1grahTxO2NAx4dodbYAERfiRloZX5IJyhzriUTdrS0Cws+k4mIApQkCXGk1/mg0AVURbmGCqnsn4rDJRSYngCEkUjfffzlwp4GJf6AQY4BvY5Cs8/KFcXA3xWqK+9kNicUeZzrevNGmzTUTTlLNnpeUsO4Q/tRkX7DrqcO9R+2M6flFIptcm7n/RbZiYV/e0/xXqVawjVFQv0+Ktuw6TYsJkb2B5i+Ti5Oe0auepj8EhYUQS+p3UtrgR8jAKvu4rQTCyShduwx1p4owkxGE91NyAjTth93oogo21jvJDesw4mktUMeGBCnav7ajZ3TZt2D3R7YWYW9d48NG43YMUo9qzaYIXVVh5/pjgAzvEQ4NOMrA+BiNtZ1TMOfLCps/iQLGLByYbaQtQO4inGZBvk49EfLKYi9Vbq+Ou6dmq/Tz4JmzrqAYg3nftsO+xu+wpP+mnDkyb2w//nQZDlaE1ny+68RJkiHRGcVQaKfAxKBlByolp8bfZG8SEQ+A3Tejz7ob7QAelQiAyvBxK0Pla6WsNy0vF1kxV1bNwKkX0WJoAohsJenTwpBYNpCzty0OzyYXwXgNdY78xInli8o0Or7oXfvsyeGbEecGhEaDLm5RwyJvAI3tA5yAJFVFv18c48ZVbaRJbnVbDrJ35nIT071tN9D0oXwcw3/kZaRLGzK9AyhmfyNr028t/8Y2aFM/NsZ67Dd+a88ASuq3oGfb7rTAWFHtTMrKzJHKmAbnUErt9ILGWACGTs6ZxkK5u66A2wGEnJF2iW26h+USilomYwZc+UYRvLJbWE2lRiijPOkm0EIhzKIjfrGV1El815/s73bCDIb1i1McMx2wjpoKhJoO2L5A36Z39GGNqfL4+Tes6wMIQQm/DEdwzzfjyDDzrspO0jCzL
 fdwfkrwZ
 RmNvlUSvfbQ04G2eQNJYwWje4Q4bivibM1RlSPrCIogExzQLy13enhXsSBSCr8Y7HcRr28rBC5QxF0TUpWFhB5Nf/wUdWw/xLRRURpGnh+c8JPA6ssezs8rsMzhC9JbRCg+d4im1nd0dAs8ioLAFyDPNugs0Bz313wSmci9rpLf/mrFXzRf/rPsMmz1oxyqYnkoe+iXzzmAltXmV3GLQimmtrsyoR486CEsulh1n3tKq7l5iwfEWPdHLbHv8AG5M++GRRvFug8zNdXjd9/FrlBSZhIwXKoOrO4TxQDfAMSqAfBnHLSJcX6EpiwhuUURx98gdSg0Jv/QotNhat26m1pk3VVLVMoeKp0u2Ig5Q8omK63GcJXXMLNcs9cu4PgbcFDzOfaWCkxCmwRdJ7XqR3mVIILlcDZBhcyxvrrB+bVe1lp0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 03:23:45PM +0100, Jonathan Cameron wrote:
> On Thu, 16 Oct 2025 18:16:31 +0200
> Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com> wrote:
> 
> > These could be good starting points, as I see in the rest of the thread.
> > 
> Fun problems.  Maybe we start with very conservative handling and then
> argue for relaxations later.
> 

Not to pile on, but if we can't even manage the conservative handling
due to other design issues - then it doesn't bode well for the rest.
So getting that right should be the priority - not a maybe.

~Gregory

