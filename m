Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CDCD3C92C
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 16:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2E56B0005; Wed, 10 Dec 2025 11:28:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64BDD6B0006; Wed, 10 Dec 2025 11:28:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513E46B0008; Wed, 10 Dec 2025 11:28:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 408CF6B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:28:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D97AEBA3E2
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:28:18 +0000 (UTC)
X-FDA: 84204093876.26.6750A7E
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8CE831C001B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:28:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fedr7GU9;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765384096; a=rsa-sha256;
	cv=none;
	b=GkEoYVX9nRo77M+Vc/gNvmq4j4NczfxaZ9wIvRBOFJhE9OMdeaeSr1MYZyxIOXCL9NsasH
	d3Ew2RPN5OBn6PxkKnzFP/bjYnUXcdCh7/dCAOayNX3OP3mAorKrGknqGswrsTGAka8a3e
	+yzkQdnRM9hTZUiF5r0KqW+0rDxX1Ik=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fedr7GU9;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765384096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7st3SloIc7ayJq36pfh8REUWXYhW/DKTGg4/6o2J1q0=;
	b=qHlqEXUkA02RrjXuEr5eX7+KalIDw+/+dcKBoGUnW+thRi9fawpKm2X+VMG0BLjl8R48L7
	2SoZD0EZbO4vTrjxJFob8RfbKcCFtU1BNIWx4RxiUYMo1OBMxjf7pRrFCYxXavBVbj/xuD
	To/7HG0qS/3j3HDu3cF01kYNhW1wEqs=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ee05b2b1beso62378221cf.2
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765384095; x=1765988895; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7st3SloIc7ayJq36pfh8REUWXYhW/DKTGg4/6o2J1q0=;
        b=fedr7GU9/gH8ds8JprCP+9F8ZJTNndMJCZUlFHpxqWmLxkIWyv7BIOK5wC+XYFx0gn
         vvrSGKfp0GZ5rCkSbGXSl4GAM5PhhuWK6VJDmn6H75BrsTcq9pezuercvfgX71MWnhyW
         Pcu8LDNpBXDk6jGMDmlSH12LtuO7lhMMt+emDYK0EaaSBoek20B1BirktxNFVcNCYdXe
         YJ9cSj7k3IXw5gVY/J4IY6iMqeNaSYlpgckmow3TFmi+xKeOrdFCyi7xv27c8OLSSdbJ
         dEnFIeE2S1zxvpUKKjEY2X4XJHl9Qx6ShY8/hwH9/1Qo1xLev8NHt43lWjsSoHvueSfI
         1GBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765384095; x=1765988895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7st3SloIc7ayJq36pfh8REUWXYhW/DKTGg4/6o2J1q0=;
        b=pvImdv0/bezfzKtDHhEV3oHQ+7962aU7SebN9st7V1TS7ZwHbJt54rLKi1iSsQYvyG
         CG2X/7buNUIAjCtMcKmm1OzKZMsi4u3agPNUsZKGwyzPLVaDyiowksG+8V9PA6PWOz+v
         vCq0CNlFpYaRsm5PpwbGYTogvBkFf5n+q5D3imq193YHCcU0BcCVyaXXxubLr7vZUfPV
         H8EEUsfob5JCGi4Fj29gGSNkWAxw63Mj56zqJlZcVI8QuAw/OTaVH+QH1r0YUH7E3EN+
         w3VjhDhvjmHYOvzqZ2Gfs41ez49c8dnNskefCRBOwoNBxakZcLX62NC9mzMW+mID/cFQ
         pPkA==
X-Forwarded-Encrypted: i=1; AJvYcCUnJE3ycGBlut+eVYNYltG6m9WpgT/vawt/NOg6ePLbFOaiZbt8ib3lBzOUmDvRxbSsw6b8F4IvrQ==@kvack.org
X-Gm-Message-State: AOJu0YylIqNdTXtfrSlEWNcuKOdEaWs8dx5XvBYae7GJfRCABjjyd5kl
	z+P0g7ln83UrBmvGWPNFhM+P1gf0UffH/KH0EIZ6hZCM0ccZV46ctIZdcgMRWr09g3U=
X-Gm-Gg: ASbGncviYy+I9g8VBlPjYV+g8Ztijvxozv6hLCRW01WbTXxEKcveFqJ4gxbuVMLlJtw
	+IkS6MCYwCc1o7UYOtKLYkiSxNmFcwaMN04Yn9lZ+bY66x60O7/GBe+O+xSB8dzXTf+rfTFeLJT
	kF6yILg8p9MQLbDnd5O4xWEvz/4Oik+XX0kDTJ5x/3zWvV4y+rwrn1VaQZvuBUmN+DY2HDdO1pz
	ZZsvIzCV1vhWOSJxOjY79yUpj6QhZh9jnFpxzgjxE9rV1Ue3sUQPusF6ikT41BigAKOKD3VNGUr
	lJsvbbnZfdXGAVy7pVrvtoYz/1iMrP9QWaihaBUBKFdWl8gdTQCvanM+yV0hm7D74bhW+/PyX3N
	q8OF9q34Xmj1nB2MGr1PJSbmCABB9nXXwbeyQ1zT3p3Rb2yO+al088Q+ftX0mhNmUya+F5mOxnx
	QASoiwEpLaIw==
X-Google-Smtp-Source: AGHT+IG64O7TTyjxLTZ38fgOeBLjdeYNrZLY4n0ybWUVjcABTD3EdxQBSK+822vTZP3xcEIfpC6UqA==
X-Received: by 2002:a05:622a:14:b0:4ed:6177:dfa1 with SMTP id d75a77b69052e-4f1b19487b9mr39447421cf.0.1765384095434;
        Wed, 10 Dec 2025 08:28:15 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f0276b0351sm119233251cf.8.2025.12.10.08.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 08:28:14 -0800 (PST)
Date: Wed, 10 Dec 2025 11:28:13 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH -next v2 1/2] memcg: move mem_cgroup_usage memcontrol-v1.c
Message-ID: <20251210162813.GA643576@cmpxchg.org>
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
 <20251210071142.2043478-2-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210071142.2043478-2-chenridong@huaweicloud.com>
X-Stat-Signature: zpn57wyqfqc91dyyu8grxz4qarwqz55t
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CE831C001B
X-Rspamd-Server: rspam01
X-HE-Tag: 1765384096-87390
X-HE-Meta: U2FsdGVkX19oqq8tbELCLpdly+p1F1C/RmnUxTsAQM6h8qiyDotXgFqwDWpdVfW50WSSfViebh5DBDhLcSAtaZNi49Y2eSaDIWJl+uxmGNQJsjH13Vt4Nij/ff+DFKNna5GpHTOKyFqVK8RmOTen/tDKBSwaKjkanyQ/8aQvlVZ/QBwswHiC3Jq6uK+fCtqh8Vdd36hke7+oTAuItaJDT000nK4gOgiXehrMiWDGPWTfF36rkBTeRVB9pq6sOdW4WY5JAZrJyHVybhEiz9HIXwBiiddKb0SllvbCzPoQj0VzUQF/hXVzgSKqN8GFwQiurO5JZ+46n8FJCqNy7PTyi13dongVTq7XTiDRA69F6VpvK5nchJDeU2yVk25hrOPV6Rjl0BgnIaI97BVuBPojv2tqzFTJQLSoAVVdmC8G4NrMuNF/4ElJv54vJfWUskIDH2rPCGNHaDq42ZWNLEW2SykPrRCv7hhyFpiRoBbF5rVxfI6oGCyW6jevXyFoJV/eUXQzqpXGVzyxx9yjfzoCHA+6ljKsp5hUBcbxz+0e8VYgpIbEdhanB3QTOln0GOONSZtiMSvHkOFJszoYEiLWRPjY7V91xIMPo9fakuCaYK92hDWc0+zPh8jvfD2WjrrqOdrvjA9cNd1/XSxZ7++s0mhCovdUmuwqe3dpnywP94+srcRe309EKyyiof13w+2zqKzhel5h/qUSuAVvQD1s3NpYYiNp0LSFDSWMxw/01JlEzUPFN6/aZPJGbUUn7dbnVi5/DYCjaZJaSlod0kCXIsFSlr4ylirksflJr3CzDwESSvGEBV7+4X5ckP/nkqR8PsVCPmqyDTq36TwA15wmc0GVKSVafJuJhgqpRxfKPugt59Onyb+JhMi/oK76w3s4ZHVqzriK5KvlavvglrgEspN9GnaMOJDfSfQEZ8Y8s22TKh51EMH4KQYwtpZsDjq3KV826eNCspIx9+q1nXn
 FYc20+i+
 MyVQ+QjNURgByq+qhT2qeFjZM9BnGZjuJjr1+eyQkknpceVyA6aQUit/vT5Z06qErB2TZO0ycK/sgS5J+Tn01yuSOKSNenc9uZeEVCOoVu3Kq8kcQBczV/HV3Oe82Y1p16XbY9+wCiy1njeZ6Via3vIzFjDrsRc/epTGVlZJy6kCCbJdDegu7dO20DF0BT5rqg3BmfA+ZhNk9zUDO7kUyh2pnLvfWFLGJtCbVCYRCpYqndjtSuC1j2+r6w8yjJvf6UL943DT10/IO78HEOwueqpO9H33nZaymQhkUcHyOhdbj/K77cFCV0rpZNUp+mvPwX5DoqaIJeorDF2WXXWPc5qKcmh+WVXBmxUfeRGl7baT3YuSPrTyo7YcTNjb2BZ9cpdDj4psR0pe0Pzo6FcuJDcBWC8+hAWmf93MxLn5GAtvl+6Hcz0A5uF7dkNetWiIwJFCgJrmzpeMCLJUtzvaZKfBVrRsneydVQx1KtyMXeFzz9mp0197swtf922MOv7hi6K/oHCLsbXL/etIEMcfOe6lVjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 07:11:41AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Currently, mem_cgroup_usage is only used for v1, just move it to
> memcontrol-v1.c
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

