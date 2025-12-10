Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812A9D2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 08:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C566B0006; Wed, 10 Dec 2025 03:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CDD6B0007; Wed, 10 Dec 2025 03:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BA06B0008; Wed, 10 Dec 2025 03:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD916B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:37:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08394160420
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:37:18 +0000 (UTC)
X-FDA: 84202906956.26.322C67F
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 053B71C0002
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:37:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WkyKCh7D;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765355836; a=rsa-sha256;
	cv=none;
	b=kQm93jLNNKVpA8tgT4aUzZeDBWq/KAJoW7DWBjujy9xoRnMPQWNnZP5+xDTPegffWnDwIo
	ldMdznmpuVlvP/MauPszIPv3iqzi4TXnr8/ctIInvsVDgRdwHLDkj9mBSkylssz7d08pZp
	d2XQHolYmNJUzAaDAI3hn3wpqSFLvMQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WkyKCh7D;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765355836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5Z7LqtWX++TrZQXqb+j50GbpVJl0TfbDa+cwgx1VsI=;
	b=dxQLmw/hj0Eb9EOS4bN7eSfcTuusXP2TpFAWoEvSLWSyQGRmk+6rYVFPvngOHG09P6Z9qG
	f4EEhMsUbpVnxxruculwIkzbRw0Q5X0yZ3pcfABRLB9eENKNymcaTOszCF6frI4sh37NhG
	J7bs+ZRSWdslYvg6vFpFuGy8D3Qo2ZI=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42f9ece6387so724097f8f.0
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765355834; x=1765960634; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q5Z7LqtWX++TrZQXqb+j50GbpVJl0TfbDa+cwgx1VsI=;
        b=WkyKCh7DHYnl7d5rFEEg8WXYK0kr7vHfk1NVaqHwy61Eff1gmoe86cNQYtQcBeX9Ey
         by9yO6YKwCJ4zI/jjzeCDZf3bsPe+6TWKfpHXkw/M6CvWcpFVrXJDBleR8j3bzSfYBPu
         +kZgb7DcN5/Bd9v6NtgUq+qvqYN4GnI5ERHUc4YwWh2RMNYlhUOK23TuPa0fJnTfwkqQ
         cLwrjt9gAoCt/qtnHpz8wn44iF6y2ASND99jq86LBe9uaUced4V575+2nbHdC2/WERBS
         9PYhbuAuZmoNwahVYfPphH94pTk6pQKVHA4JfOycoi7zw1SounBqD+uz8xwAtXZ0isxB
         k7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765355834; x=1765960634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5Z7LqtWX++TrZQXqb+j50GbpVJl0TfbDa+cwgx1VsI=;
        b=vRXE/TfJYsAAchHVAluvJgCwAxYfB3OPWkv02wC9ZGBTtp5ShAYLD6e/LLs1ieaANw
         3behmaHkjsC2/dq2PeGGdEvvCHglGltcckmyits0se0b0Q8r/M1+233YdVCDLSX17O/P
         S3lpcTdyf0/azlFgZwXVcEFJmo8SKH8Mnr6YHPleZT9ScDMdqr2XJ88AZW2WMqrFI8js
         ScMIoVDXguWo8FxEBUwitcZ9b5DC14H0HIWm5oML5FVptwGoIr7jWOpgG2Wb5cCqb2MH
         l4O6EPkI0t3755gfVmU2yi4Qaaq6qTfdPM4yDA93cDh0RWapaFk21N8Yjl5ObPK4tj6t
         ylZw==
X-Forwarded-Encrypted: i=1; AJvYcCUgQsmAiv67gKZnPFkeySBkYEM+r6WSoOIk5JDpo19BqIxo/ZaTJYTD4idZOOhl6dV/ohNi+Hdm5A==@kvack.org
X-Gm-Message-State: AOJu0YxMPvw3jUcE/ix3adDVKBq0Vsx/XyKdofNgW0SfU9zkzEZEY+zT
	mUhs3uZDhbJWjYRWbFO4i5tGqkPpnjPYHYcTmxQDvYmZeHvUlYVI/+F0WUjZBL6SGzg=
X-Gm-Gg: AY/fxX6RvwTKGaPGNlXRE5yCcR1XUt1CwzrkSBNkIcOOaxgVga94frXoixC9GvSWdGc
	q35PCooF8vIq00NG1l59M0w1TR71sSaVClb0qjWMVL/kI/Sc4dNY0P7Hp1Fb3NN7tNqUguvZN2f
	SkrYBjCNwcnN6G8KO5HG+gs09Ki8/f7B6Iijyfnu+4Ydx5a0srnbKb+HhsGFCAwt3p3bxkL3GOp
	2+Yxtf7eQFyQzjHCeOZMIEDQBMREdrnXoXFD1nFO+sb63I5k0vBjRs2vF3Zvj1EHUTyUOdOsD/c
	XMGALQDdLpsN1ptucOTuY3amTJZxPanSklFqfM1Ml2qV0BtZSH9EamtXZmx4cjRBoYNNKOh0rpN
	Tr5Z32hQKAsXyGpRvqZR6o/odvOVC8sDXhQpNC1TmBF1sU7JPYCMwK9muQasFkybvAoCqV3sXsq
	05An4i134cV7lVF+UEQOgo5OHb
X-Google-Smtp-Source: AGHT+IF+0BsDMsiyluvJipcU5buTJ9BVa+hpm1ai1joNB4UB0lSIVLHG9K4VLv9sZg2snNuLroWy6A==
X-Received: by 2002:a5d:5f45:0:b0:42b:39ee:2889 with SMTP id ffacd0b85a97d-42fa3b05eb8mr1389247f8f.48.1765355834307;
        Wed, 10 Dec 2025 00:37:14 -0800 (PST)
Received: from localhost (109-81-30-110.rct.o2.cz. [109.81.30.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe9070sm35533483f8f.7.2025.12.10.00.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 00:37:13 -0800 (PST)
Date: Wed, 10 Dec 2025 09:37:12 +0100
From: Michal Hocko <mhocko@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH -next v2 2/2] memcg: remove mem_cgroup_size()
Message-ID: <aTkxOJtONChaM8o5@tiehlicka>
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
 <20251210071142.2043478-3-chenridong@huaweicloud.com>
 <aTkp1tIIiw8Nti10@tiehlicka>
 <9a9abc04-8915-40ac-ad40-2ae67d429ddb@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a9abc04-8915-40ac-ad40-2ae67d429ddb@huaweicloud.com>
X-Stat-Signature: bct4gattz1micwxdaa6gfqkirj11kagp
X-Rspam-User: 
X-Rspamd-Queue-Id: 053B71C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1765355835-77353
X-HE-Meta: U2FsdGVkX1+Nj6uVCQjFuFKyYRGPmR7FQl1kGWgxoi3FTwsCFxlQmm3Pas1BktwmV1AstEpDe60fQTfvDvggqMLsFBU2B3Ok3EG1H3b5P+D3G5hHdi45vTdiE3R2oriUnANOFvltFQo9YtmZlSc/K7gvCgPuSdCnWzNnBSxFw26sXPJ65oORWneqZ2ORse/0zBtpZniuRD6u1UlsGjOhz2dbcEshpHt8hPkmxHBsV7YUD0mXyYfIl9kgMUI0+FvgDYR6gFeafntRmql5ieyD9SY+6rA+a0wBoHv5Ulohd2ehsgIaNaralzRwwNut88DtkfRMnLYLkFjwAI8wOD3Ab6Y+D1C2pguJLfNZ8hJnej67fFZdNCcD+Y6Anlq+EF0Fa9SM6LxroQ4O/wHuHwZiLN0sstCJU2In9tjqYT0T0ZPKBcHFZlwBL5iF4QgBVfDCx9BTAdqtrqrkZ3gxIua3kEyqFW1s5O+AAZ3AjwQKheLLsyEscx71tTzkwvJox9a8+VkNMjZw0LPjvjaT1pllrF7VF/VN26cKqhFSK/SSdXgkbHHghwAFTEp9Lyc0CvHKKA7d2ojC63x66b+4xTXRdBF8WVZpOMP7AbIlm5TQ6QGbTvH4Ma/uabcoI+jMxhEGju/NFKUYctBJ/6pbjxR3c1eqFfJ0SiumZDaXEpQxB8siNklBOB0rkLeprjci2XA4KXiYQZ9rGCt4srfi4lzQxh0pzMIIKxcmeDLSWL2CtZg4tO1E7y5IfQvJF3ukr8kbXDWZMN91CI8T21XoiMFFCSPbxoPJQNZUT60pTXymn96PWoyuqyRq0lYA2zBa8vsgBQf9y1C2fk/V+tJiF39NpYU4HI/HbsFz7atTFMVMdmkvoDZ5a8J3ySN9i2os7fiZxYrqTjVU6Rvw+P4leIuwLzEXiVwHICfFCom+7Nor74QzRliWQy0EIvOjmx32Y1OdExw6jHSlg3naNFmcopE
 AmfByW0B
 QQV3IsVFicz16aKtgg1tr8c+LLye2frXhYoJMvtvDJxoJLQW7XUU8g5rxH9HtFTT4EyM4VqBfip62CNCr0zw8OUc7Oxhi19AudayPYDStwM0egA7bGWKEXe5DMPqgNs2V5LR5kK3gt9/AOhF8T0u6yGme7ICglL0BJtEKbNKx/uE7u7WSFTAVTc/lVyKQVh5ItqdoPPOO0dgbfOYTjfTAJmvvLapmMbnPln1AdQ+A4wjn0cxCIXFZzo/XNX0JWyvqQDjIz2RBKKL3freMUeSM58Fn2NY5oVc9xfwmN1Wf9k0gtTn/ar0W9svAEKzp0j5LCCMwqKEi9TtTTTc/CHnVvOlnE2VKjHtSIFkAh0QkV6PIHGsk5h2TItuxo8RPEW2cj3U5C9zjzv1LyQ+NUTKvwbDSGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-12-25 16:31:37, Chen Ridong wrote:
> 
> 
> On 2025/12/10 16:05, Michal Hocko wrote:
[...]
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 670fe9fae5ba..fe48d0376e7c 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -2451,6 +2451,7 @@ static inline void calculate_pressure_balance(struct scan_control *sc,
> >>  static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
> >>  		struct scan_control *sc, unsigned long scan)
> >>  {
> >> +#ifdef CONFIG_MEMCG
> >>  	unsigned long min, low;
> >>  
> >>  	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
> > [...]
> >> @@ -2508,6 +2509,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
> >>  		 */
> >>  		scan = max(scan, SWAP_CLUSTER_MAX);
> >>  	}
> >> +#endif
> >>  	return scan;
> >>  }
> > 
> > This returns a random garbage for !CONFIG_MEMCG, doesn't it?
> > 
> 
> This returns what was passed as input. This means the scan behavior remains unchanged when memcg is
> disabled. When memcg is enabled, the scan amount may be proportionally scaled.

Right you are. My bad. Sorry for the confusion.
-- 
Michal Hocko
SUSE Labs

