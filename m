Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79D5DD6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AE46B008A; Thu, 18 Dec 2025 08:02:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25666B008C; Thu, 18 Dec 2025 08:02:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5BE36B0092; Thu, 18 Dec 2025 08:02:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3A266B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:02:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F2B316013F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:02:19 +0000 (UTC)
X-FDA: 84232605198.09.B9905F7
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8713AA0023
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:02:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=n0sf24dA;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoMgDKwUqiYQLz/exZipbw/eWEAMXUec9gMtKJ9jU2U=;
	b=xQLki59KO455mND6YLTCIBg0xAgLwsy5vZvg4iYID3aqEBDPFALjOVLezIGii+0JsUA7aS
	LaZlmwCvoDYn8Wq0xxSUW1jPiWK4dphsUs/10J/0BY19WslIwLQ4sq2eGfhDzT46eia0x9
	yKAKqSHHWDOkMCjhCXVCQT+KJEoTNGk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=n0sf24dA;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766062937; a=rsa-sha256;
	cv=none;
	b=dHX6B7bnWhQjWbew7Fxb9J9SDCeLINAnu8p2Cpb5xTlORqC+nOYJ4m2X7mbwf0XfkLV6yd
	kjzF8fH+szJ/jVsY91WlLvN1EEsWFZwmom93XVr6lGomGjjtDbApLt4G1rk+kRRCTqt4dV
	RrrFbWkO4LXDXQ6qJ7OqeDn9ZCSQfuA=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a2ad13c24so5618106d6.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766062936; x=1766667736; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eoMgDKwUqiYQLz/exZipbw/eWEAMXUec9gMtKJ9jU2U=;
        b=n0sf24dA2yXiDslZxWvHybW7MWSc6vieVe0RGapiH/rD/OhAjUCCMC0J6pMiZ1B9bS
         OnOzKE5GLwnDefPaO4Ov50uZk5UcH7u3blYtMw34mQI4bmIFh7EeDbH3SjAs1EkuoQdf
         +snQdoCftpFaReFSmI3S7uJhva5bE7GXUiwsUisyazKW9C+33SZL9NyNC1xNSS9cux2p
         dEDu5AhiKShEzQKwu9mw16XrvxizcWKk21v0QndVl1CmqWIg5FsTf4mYeYr7CrV/DHkO
         54FpC2WRCZp7HJp8PR4p6P+yDkn6MGGsp9ih3XLlFYQPXpohBWCQPbu5w88y5laL3tz8
         88XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766062936; x=1766667736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eoMgDKwUqiYQLz/exZipbw/eWEAMXUec9gMtKJ9jU2U=;
        b=tAk5yxqXdZP6ImcPim44CvAEpUrJCrB79s3ctzSHefOYTFn6EIXSgmbBMVu/2gkWF9
         bgS/MOZ97a9Kp1L8P1k9HuTEvq/Wcqy9zWpe7NfxdX+ghrX/lR615jSm7ElIO8+Yuo5U
         21Swu4W0KkJCd3pzu7LToBRMVXL8aKW4vG3tWFQwBfdtvjOuxtDNcALYogyUtB0fe81K
         2v6g+EWLPvUkt3rhKOSYYr6LoauukVMLrSZp6SCuiDF3VuSJ8irSeMp40svsyYWxaeE8
         Hyh61IjnqdsU+1U2HfMr1qp1ULsxsPBZdxKLV0B5ux5VJf1rcP2XBiOYlAXaZ7eYMCV2
         cffA==
X-Forwarded-Encrypted: i=1; AJvYcCXsja9Hf08debUmRcSZGar3DoN3n0fXV7XwGeNcxapfXtjJz1JUgU39F6dtXuKeDQnbj8ny4LWE+g==@kvack.org
X-Gm-Message-State: AOJu0YwSvIhFWZQ2J7zQg0KPXB3bqX9kcD/aM6l4s2Q7bXOIGiRBaHvv
	mHsKdzgrEfq2VR9MNsnZtXzbzJcbzBt4AOYjp4OdYh3YfTDddGgMalvLYH4GEVCLI+A=
X-Gm-Gg: AY/fxX7Q+OlVEXM4nEi6XLhMvn9FxLA0bgd4Fy/RoUwK4pTrbJEh7hcXn6NhgZ8u4vh
	1zWtw8v3ZxsX18wKLJKIINuHQVJpqYR2RZd9lqYCYoPQGGScqWPRoMfdauNxw/I8/rB5j4Iamlu
	ufmAwytFd20MX7hZ7iw4Rz/35Te3uQXaY4wX6/ljbOff7ZZ5/VshNowGwomav5k37C0UYNR9pOr
	gkPoo+p+oKYcMnn3Fjf31TkIMPVCgrKXIKTT8CjSvJh8sjqNSdH0yKBUXqoA+sscxICx8VNutPl
	3TbOm1DV+fiad7NP++yzJ5Va9/pK0C2fAlc6tUfC67RWxVWR8fSv3DyB/r16mwcjwymxxKgscAw
	rb0fli3Fk6VR9GhlpVQRTMN8fgPc7dsJitEMdKCDS0LwJQvOMirF0Wz98v+u1Ke27XznGHQq6Cv
	CMAxyGUjRkBQ==
X-Google-Smtp-Source: AGHT+IHCmTOM62jrKF5e0i3ecD3lTx7BUsHXoHpv+YPi0JwtT9sblxf5OQ9g95krK7LMiJWfCtz3PQ==
X-Received: by 2002:a05:6214:2b87:b0:86b:9167:b0e9 with SMTP id 6a1803df08f44-8887feff208mr316576036d6.4.1766062936323;
        Thu, 18 Dec 2025 05:02:16 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c5e15be44sm16360706d6.20.2025.12.18.05.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:02:15 -0800 (PST)
Date: Thu, 18 Dec 2025 08:02:14 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 20/28] mm: zswap: prevent lruvec release in
 zswap_folio_swapin()
Message-ID: <aUP7VkCmTVSoMdBN@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <bd929a89469bff4f1f77dbe6508b06e386b73595.1765956026.git.zhengqi.arch@bytedance.com>
 <aUMvp5WzDp6dZCVr@cmpxchg.org>
 <8aee44f5-11ec-410a-9b45-5cb224e9e23a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aee44f5-11ec-410a-9b45-5cb224e9e23a@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8713AA0023
X-Stat-Signature: 8wnmahhq69wsp83sfd55tiu6psxfdoyf
X-HE-Tag: 1766062937-805833
X-HE-Meta: U2FsdGVkX1+CelHBWQuxTqTPqBKM4yxlq4dqcmZ0zM8jELAYkJG9iZKdiwYYAf4txRZSZd1MYp5lV/8DIbznq9viAbzhK0IZi0rfDPhPjf7FSIu+itywdZRGOt6AcZed6CaFjY+OzDx8c8mWtGL21mVbd6Tqi1bYjzfT4Got6QIACMmMndHDABYZDe9fqm8nkDbWdKdqZALOYqoKaa+Txs/J/VEvDHcAxci5K40itE2UEM+BnePQcOILAM5Q6q+CwGvGi8u3ZGJHRkyS33iy2cniW1g9OKMd91h0/+fuHy0nYsXAbZTY06/iS9SLiaxZHH9Y9BvRyiNDcLdgQQyW0Pc661rLRldwqcAvTLINxTXCkf8YvkvL8yJeMkcEngXevUXvth6xhRTHl6o8qhVJaUGO93xiBlPVNl7zH93ET9gdVucAhFspQKze0rmntOjj2hkj1DcSI/6hvpvQKRKxMChvWMyhaVEeRy4DMRC1sHucGCVwOQvs/hqWHi9G+mvZrylXGt5Sp8/K1QoiZqzGlDrtzWAEiuzkK8de4BcwslFkwipGsXjgvPumT3MuAc1wHCJ5DSwukvKxgLQmk4eb0ZFNHT+NjD8nKnmhc57+032LZ0LnzzQ8dxwzv8YUUlirLszZeds6k9szbBPZH3Wih+q1qjqwWKV4FLeGtNoPjzuC97ojisk7j4phje2ahXp67A3Hxiu7oBLpUjWSBgJ8TP/WNKutyA6snGHi6ph7NClReoN6EFzokxBIEwTiGX6EhGiHOlgt8qa7F3DJGTUVuUUI68MirBiVGMIjdfW14bU2/sTE8sAXq2CrgI8xQhDvuZZTOhczDEKw+/PrPdJ1DLfMeunOE9nX7jfQJAKdyewj+GqTaucu2Rj7BTRreW35SjnSh4TNS8NQJ1mw2G8VtaI4adqpS2lfWcRbob+JU5P0cSs10Qrv7fDt23/8PQlqPcnZ0+eJzrPrwATcwSt
 8CLfzRih
 K6xeGjt0zjE1rVD0qBciMhOWk6zE80Qq1Fyq+eAUzsZq8nuCIB1H18xtGtK/0vCZ+hHWB20aFbdh7xjCm5+MAyp81nAFaslNoz9hwCazseGMpBUTfMXMZHmhbMyutEZ1niw4wkL8XluV/zBlFBBsuvze3NA+7JQl2HaQ1wmzGWmM1TnNXCNV5useR2RF0RTlfsF3N9LlH1kxXily2saJNx9rkigEZgcHVWI7JHqa7OYf/u0OlQLpDVSGHj7Wchjj32oSL+jviVtPH1CInYnGP0+OH2RIEL345ZTxJSJdLY7b/LWRtq8UrBgu1uB1h+X/p3Sy7wyBDuvcafV4Xj1a58W+RAJVfzB4K56bUKxJhz5gU674dYOEacLDlaLDuVwS1SMN3CBvhYAsliNcaQa5fYibPLIErbCWge7HtqNw86q+qLjPw+CHZFuJhpi9I89SNRYo9PKHT19pzR79DCc1V57TrsFbYzeDNs+jfd1p2UG1nqJkABXulohlBzhY7KBPiiWHYKbqUstiyxOtzqNRDLhjZXhrb7P7L9JD8LxHQ0irwSxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 03:09:04PM +0800, Qi Zheng wrote:
> 
> 
> On 12/18/25 6:33 AM, Johannes Weiner wrote:
> > On Wed, Dec 17, 2025 at 03:27:44PM +0800, Qi Zheng wrote:
> >> From: Muchun Song <songmuchun@bytedance.com>
> >>
> >> In the near future, a folio will no longer pin its corresponding
> >> memory cgroup. So an lruvec returned by folio_lruvec() could be
> >> released without the rcu read lock or a reference to its memory
> >> cgroup.
> >>
> >> In the current patch, the rcu read lock is employed to safeguard
> >> against the release of the lruvec in zswap_folio_swapin().
> >>
> >> This serves as a preparatory measure for the reparenting of the
> >> LRU pages.
> >>
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >> Acked-by: Nhat Pham <nphamcs@gmail.com>
> >> Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
> >> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> >> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > 
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Thanks!
> 
> > 
> > Btw, it would make the series shorter if you combined the changes to
> > workingset.c, zswap.c etc. It should still be easy to review as long
> > as you just stick to making folio_memcg(), folio_lruvec() calls safe.
> 
> I prefer to separate them. For example, as you pointed out, in some
> places, it would be more appropriate to switch to use
> get_mem_cgroup_from_folio() to handle it. Separating them also makes
> subsequent updates and iterations easier.

Ok, that works for me!

