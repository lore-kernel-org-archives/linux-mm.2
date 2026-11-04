Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBF6606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=RTIP7nB4
Received: by kanga.kvack.org (Postfix)
	id A57826B05C1; Wed,  4 Nov 2026 01:22:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A786B05C2; Wed,  4 Nov 2026 01:22:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8836B05C3; Wed,  4 Nov 2026 01:22:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6F86B05C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:22:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 060801C3EF6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:22:07 +0000 (UTC)
X-FDA: 85396441494.17.967021B
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1423DC0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:22:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RTIP7nB4;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773325;
	b=N5EnYnxiKkwh7Po+ZqgbaIl3fRLV0zAnJIzGNnZGsB5+qbGUEskiFxTmXOkoVf3z0ihG4c
	1JiM3DiNQw2lGu6vEGJF8LZFZsNkpezdKLiB802cLhBImMxm3V4awi1w1OF00mLga3G6wr
	jdBiPils4fwvcqzmbZC8x6ojYyse368=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RTIP7nB4;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqcQe7O5wAeagY/E7/oDRIMbBP90oX0eJ6ciW8cwB1M=;
	b=szPGEirSENgTmy2Z/r7rV6zjDfnvwJL6PyUL8imzQTf7TI/QhJWFMUnTB/jEDz2RMsFEUm
	oP07anvPLJQdws8cZHCtNtq4qdIbtGy7j1sx1JdsHpiR1ScVv9I9NI2+Ja1c3fdqZyB4M5
	RmAhpou6mFRQBxwyF38RMrhE0GKaHaQ=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-353804b591eso633283eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 22:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793773323; x=1794378123; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AqcQe7O5wAeagY/E7/oDRIMbBP90oX0eJ6ciW8cwB1M=;
        b=RTIP7nB4tHvdqyAvAVH2aUFk47KWv28dru5LbY3ZsIMgr22gV2tW4MWmiSUMkgay3V
         zrIG8Ipt+kCNQVr6tcMJOMkjjZKdB06CcGFMwgL+iW0828MdjbV56D/C2xVI45se3g0Z
         zFGNRnruo/PhQ77t6+cWwBsZI+iwU1xBSXpCVEWf9s8EmTehAVmxqHxhNqgx9g18WJ+X
         p1PV6tfbC7xzq+TQvG4eSVIBopNYCT0yRSsj533m2FsCGUDom/wTNMdjEiVPe+hf1GGh
         gIia7QCVkI3LbFKcy3KPvKTBi34JieOJeiwGMd97/iXzwwR0q6Ys3Ex7EaFqdfvYyMxb
         ZH5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793773323; x=1794378123;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AqcQe7O5wAeagY/E7/oDRIMbBP90oX0eJ6ciW8cwB1M=;
        b=YGl1KNlExZofG7jHzU/5eqsa7/Q/LHNgXhLaInfA+4ClZ4QGNQCLHHTpsIO6pdZbz8
         UT2XHAFK+z/FbrBvFJ+07Ix2mswZn3JYdyox2rz04A/IZrNKakbF84UBoDDGRVkbPa0Y
         psSSEz6fhdOtlaVt5Gi4bOw7m7JTPyyqXvc64hQJqDJw/7DesBC6a6qH/AB8m1vBirwv
         QNiZuDnEAy7qpnqIIYo98TC5sO9LycFekdOfQr4L4xt72MSvlzIvE6WJPv5yd4/jQgoD
         wAERq3aoXJJTlGm+nNw/CB8aFdlIVRnfD83XHBiJ90FSLH8F7rEqZpuGgjy8z9v4+QPa
         ZkDA==
X-Forwarded-Encrypted: i=1; AKwUvBzwCZYsFcmgHyYoaYDBSUQz4acAKhyZ+Sighr4VhByM0ET3WCDmWMZNkgpbSsLIdzBwJkpl01aq7w==@kvack.org
X-Gm-Message-State: APuU4Z80dsCzt10KjDHq2kJew94LUcucZ7y2ZvbQPd5pygTVmzcvp2s+
	BPqojCnSK+xcGiSYo0D4BGOw/FlNNIrB46rW8XiX/en0PfihlHwDSO5Z7SUI0Wc2PwQ=
X-Gm-Gg: AYBFou1t+u1woQUTDHSbmRdsQ1jT6QrpkYhEDJGRqMLBV1z6hzRd9prMDCmcSESI9ws
	kcsNTPCTkpQA0XpMV70fR3pCa/L/xVSHJNTvjulKW0YrZpsjv+/dvA1ZMLcCtq6B9Bk9y00ojNR
	j8H8DJ9HTEJJMrfpC43Ii6WX8HxJ0Hj11HxdEr6SfywSDXmIkaivkI9R2bNGpcIw+aC8tux8j4F
	3Fr1KPNB3cvuFyW0KU2StNn7jVM6aP1O5dcIP+E3LY5XFTf2MijoxTsGEiH/khLFBNDFqkLeEU+
	jQ8+qaka+o/VcXYzoJCs4KW5z9WHO2IMWCfw1Qlp3n2S3CfnFGLDkhEnO44TG8TTqc1Av1tMJ4r
	r5gWu+yiiTsYzLozXuSIjJHWwut04VtNagUEE1JosoKBfvADB5ie559a+wvFIqAWzIKkGhfbyYz
	8itNtYGbllHXicKo35MNWZfYi1im8mn/eHnbYzatkWpXQNZo52cYlMJGn2K761fsQjp/1aolfaY
	vdfTUd90P37itPbj2ueLkc/MCq0PH8QYkAnmordKv1c78sgD58xyJ/L5971nTYT9vTOEgzfFNWl
	bJSYY2OBawKPH2FXDzizs7C4Hump/tI9+tjJrcy/ORgObRNz2PoYD30GhuE=
X-Received: by 2002:a05:7300:ce97:b0:35d:8c3a:38a8 with SMTP id 5a478bee46e88-36a42437327mr20872358eec.39.1793773322655;
        Tue, 03 Nov 2026 22:22:02 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([61.251.99.240])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca3785430sm6173162eec.3.2026.11.03.22.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 22:22:02 -0800 (PST)
Date: Wed, 4 Nov 2026 01:21:43 -0500
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Bharata B Rao <bharata@amd.com>, akpm@linux-foundation.org,
	bsegall@google.com, david@kernel.org, dietmar.eggemann@arm.com,
	joshua.hahnjy@gmail.com, juri.lelli@redhat.com,
	kprateek.nayak@amd.com, ljs@kernel.org, mgorman@suse.de,
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
	vincent.guittot@linaro.org, vschneid@redhat.com, ziy@nvidia.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion
 bypass configurable
Message-ID: <aurO98PC4TTweJs0@gourry-fedora-PF4VCD3F>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
 <20261028041253.74839-2-lizhe.67@bytedance.com>
 <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com>
 <010b2b6c-8f1b-4c3b-913f-cc2e8b957759@bytedance.com>
 <a6bcd771-fcf7-4fe4-8c21-5e65bd579de7@amd.com>
 <1bab234e-8914-4694-b0aa-f265fa49c6d3@bytedance.com>
 <c9cf96bf-f3b1-47da-b22a-9600b5fb01be@amd.com>
 <3318a7f7-4dec-431b-9284-ec7c2807151c@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3318a7f7-4dec-431b-9284-ec7c2807151c@bytedance.com>
X-Stat-Signature: t57gke3acxwt6xbb5gjaddt93rnzfzmi
X-Rspamd-Queue-Id: 1423DC0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793773324-32985
X-HE-Meta: U2FsdGVkX1/LlaTuIvPfJlxlJrF2jLtKaZpdx5qNkqkcm8m867dBkhOjhCFcF+Do2uteX+5P12gFZQbryM3J8vNw1rhVU7BJrHCn5ZYLpxR0Adv4hCq9rZBROHCk7bzM0NfgNAzOaJ6dshq0itWTv27pQ+kpNSU/qXQgrPBkgAKjEFdUKer5L597QJ/AoOLS5AoPOBru1yifFVVcH80C8YYYb+0CHGRXOvgfaH27U2WBjhlmO7En9VbvuOTHOfEtUkgmVqvDNalRUEnjLF7rCEN9/8IseHvfpQHGwgidH/tlRAmzLpaeNTTFnCjqFGvMDMXEe8q7t12OC3/Cvjz1YRwc8F7rJEPUpv1s70bFNMj07Eg3QrV3RFV6OUz3tiMq8NwQlB1eTIkopU7gtREEWCRvzYvgZDVuQ7dIhZZ3t47y17Ls0eDRQ0/JfTZokbRrv1EsbDsUpC7IywlsMg5x/8E7mDOdkFmYoX6aUjy744oXRqYcDfQZfP1fzrhKGLcC2QLYi2ARDL7bK+otz6c9rSSar9vV/0/P3lR44p5hRohsDYOH5zsUvGE+x5Zs8b/ojssSHUMof5tKQUlmJEB/xJS4Mk4JuNWOq3IUDk9N3P2iJurSkY1x8joORDQs5Idtpek1G3M9ht1iiSySlrw1o3mgEQaHnoDUpho1iKPUah1nTwp3IYp0hgs+p4A2vNjKEepDWIHWc0rCGbXSn8/CknUA9EC8RHkNyFLYbHluQEmJMUYMFaae/PHFtO9+MC00781GSWscVG6RQuF0Kct8PBX3MXPjPs806x/ORSYx2vBSazTdebC+Ub4H0OLy5pp1I12G1e3n58S8+tfaSGwuq5hUYp7ZXOjAu0Bd8c8vKloV8BbU/slFHtgsZhJYiVnqKuZwjQOkty75Ap9agYUCzjOIepS7ZQDMGlwRwv5e1t33ABW5HJXJAnY7h5wT1D/p+0Aalzbt3IGrNhFDE7m
 YKl+/IUC
 J+xD5msuB6dNLaHpLpxlZirWuM5IHRawBabDz9eSqVFHJZoZ8TqWSEdtG1PUImYnVChNSGTg+vn2sDKlVQ703F1PEsoqEOEXA8Djr3qaiwMX53v9ZDpZKBVzLr4a4x6fWUt0kt4Pks1CjAKPO6dZFCJ6GvuZ44xtGBCTxD4msy97y4Y8fHEFlkq2yeTxvtAKltJm2RI8tXWLrSQthFKWdurDpKRgP7x1ZVfQRFKIR/Y0jVQrRI6kWuLtT33x6wdk8gWq+ctbiy1fZ63OXtiQB0GIb/Krx6ze3IqcgElCK+ApVQjYRls87fgnOLEXs8v9K6ozcch2BF4QcfrY6+YqRMhpADAEY+dRK85Q6eiNjgWAZes2AWgsT7c8fiSu2VryuBmfjFdIx0PRImlFFjXgA0PkHuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 10:56:27AM +0800, Li Zhe wrote:
> On 10/30/26 11:44 AM, Bharata B Rao wrote:
> Thanks, Bharata.
> 
> I would appreciate further maintainer feedback on whether this series
> looks acceptable.
>

I will give it some additional time when I get back to normal next week.

~Gregory

