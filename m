Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD4ED3C928
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 16:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32FE56B0005; Wed, 10 Dec 2025 11:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0A16B0006; Wed, 10 Dec 2025 11:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEC06B0008; Wed, 10 Dec 2025 11:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2296B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:36:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0CD460334
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:36:39 +0000 (UTC)
X-FDA: 84204114918.21.2699E2A
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D1A6180003
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:36:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Z34rGDzO;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765384597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8agRBKmWPH4WtPmE+5IIMo3OzvlggOYwQwERk0higo=;
	b=jlLPRX1ZAqpVXDzE9iXj5IIVGZX9E3mMeeKf778FboEQ/8DHfrjw+b6jEV9pjHuWTYdFmY
	qixpocpn9W6ODhWvf6MD2G7dzQJbmZEG893IeK7BHFsGbgL3mQ4M2ABCfMWX37DuaCECHK
	2eHl5zRfNStJ0wa+1oEeuOxc9bDBCjE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765384597; a=rsa-sha256;
	cv=none;
	b=nFIDN+eGXrlJ03r8XMrIk/H/FHhy5LjyLqbMlzO0zxqElk4bPwXesKhS65uM1rEYwZ4WoH
	bd2L5HXt+VJG1mdIXVfrW0MDOgEA86EjXAlgmKbdHTbipb6SYQen37CM4G3FWinvDbsuMf
	pVT+FAmPAlpF95mU3C0N2wDFkDv/FYw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Z34rGDzO;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-882451b353fso252356d6.1
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765384596; x=1765989396; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p8agRBKmWPH4WtPmE+5IIMo3OzvlggOYwQwERk0higo=;
        b=Z34rGDzOapxihWqpnMdPe6vhHIuccf2b73VdIjLFjZYOe941G8pWrHIvkcOAUBlgPi
         463fYuc94chgc8DUq7We9DV2/wSr0BAiqUH/kHfKy3PIgcehthaZO6oyAESC3ENonnsF
         PqbIuDTv9fJkXBilRFgNwwUGhGWdpWPXQOl+CgUorI0bFrggK6tEFyucMBWS2cG/kTTi
         Uz8gvVH3co3xytZsQZ/90fy7xk5tlyMjSzFeZ5PA2My3NrFHxUvN5vrLiupgNqtJfR3P
         MxqTFAURYP5s1IOmGycTivLQH6O1gPlxCrwfwWrV8YCLFnboOfPs1TSprmLM1SQ4pjgU
         8tzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765384596; x=1765989396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8agRBKmWPH4WtPmE+5IIMo3OzvlggOYwQwERk0higo=;
        b=lOQw+KbmTr2OWOsd6nwAx98mJEsxGBOWlUxBOMG0IVxHoIFL0DUTiTld/Y8SI5Fp6C
         EaBhHmH/Rt2xTkVHAdht+L1ZQTP99rYWQAmkM2x+DO1iJlFC7doicnjKibor9a+Q5KJ1
         6kgjmKdgFwW1dP5BeVXpRecEhxDiXGCc10YHCR4tzWtGeWUE0i+qybYfxxO2Ay1BwsQJ
         9Gi67CqP26MqhxB/EHKFLoWs8AnqkYXPVvsOrPtyy9Z6trQdH3fHf2Oh6f3llNWPvjLh
         YEgZjQVv4YVJ13CbOJEiFCkb3QdG8e1QbwAm1z3dduZqnAGzwXHOU5Q9C9cZp54jN+RV
         XLfA==
X-Forwarded-Encrypted: i=1; AJvYcCXiuM3eEOSc+KEP3yahwMcjhG2LA0UskVVujc6iqSjZJ/HvoCIxba5K9z6aSr9ojvQ0P1eyMS/mCQ==@kvack.org
X-Gm-Message-State: AOJu0YxO6HK9tYUfD709cL4OssB7scPWLKjKlOZeoy20QTfJzqRyGEOs
	OFgnHx4c977fm6+xA35OcxkrAh8HkSWdVHN1okvvenJaf1PJ3M6g/dQ0j2lEZ5HoTHc=
X-Gm-Gg: AY/fxX6kt2qV+McvO1cSG2JOoOIrbIAsJVYkhxmcBMCv3KlyvyTjKBLfht4Geu6bpCD
	2OBfUXTnk8qPtbYXEjfZb22nLedjxx+6iOGm76uHmpgJ+DSHjnCppLm0/kXfA2mKRI8tmLgHbZf
	pCNbYoXbNszalrMLkLqVPvcWPeCY1joo+dO5o25M3h9838+Comf9XJp132DZhEPcdqQZ5KQChCA
	tU3Zjng0Ur9/adZAGXdnvV0NN+SS8bC5+0cw5e3S98iaEMvWToXGkM65C32qPFUmgLM1Q0t2s3z
	aw39s7HLSLmxu6KYZ91Z/qvxCzVPXCdAn5AfJ6qtWXBpuB+YPXfcBSD6b4q+ZBgO6t/9KpJHwZx
	T0XDrdVEpOVKv/AtuooFgsP+LWl972+9Mx65uI9Z7mtl+qdiiLS/2hEiPOF8gdJcYnetwWi4kAe
	0v87eU6p4I5w==
X-Google-Smtp-Source: AGHT+IFVI/xOKQYJhESjIuCfEpKQpuoNTM6MQ4mD11zbQuJPwB9HOkC9UT6xUK7xl7kYv/i4CQfBUA==
X-Received: by 2002:a05:6214:4385:b0:880:88fa:d742 with SMTP id 6a1803df08f44-88863ad4d22mr43775186d6.65.1765384596326;
        Wed, 10 Dec 2025 08:36:36 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886ec54e4fsm993946d6.19.2025.12.10.08.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 08:36:35 -0800 (PST)
Date: Wed, 10 Dec 2025 11:36:34 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH -next v2 2/2] memcg: remove mem_cgroup_size()
Message-ID: <20251210163634.GB643576@cmpxchg.org>
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
 <20251210071142.2043478-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210071142.2043478-3-chenridong@huaweicloud.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6D1A6180003
X-Stat-Signature: 6z11b1nobmhk953hgqffaybb74g73tun
X-Rspam-User: 
X-HE-Tag: 1765384597-432293
X-HE-Meta: U2FsdGVkX19/q6A3bmfnH/6XD5VcQnRjKTfdFqBDHURTHJFbOT9tI/uxr1jWdUYjkhpkWKsKcvKz05oxms2iaGFimxC6YhBzaGaGQs38HT7JRbpkX0qhMI2R+BUspF55GtyLzgDgEuRV4tXi5+3EO3lNm3TvTxMM/7Ai+UnxkRv2MmVK+PKCGUuRaUp0Iy5B+S+tdyqPFCbsfDUnqO7mSqHiT6jqkAGwtoiMux/71MH1U/3qvr4KD8MuwInjSjJH0bsq3dWKF4RsRn/y65pttlN2AInSO+o9GU3o0i2Bl0gqHIZTC301ED/c8jYf6fa/IA/KfNdsnG3CbBmtx1Ev+Yizn0daYv3lqppwgbYOEBqL415jcECpeBGI0byBoyvMDXLEkLRONI55cnqbUW+SK3egdnD2ix4RYJYRwGVObBIfuzY+N8c7DCkplJhxUVM2fVYWfeuNpLhUSg7NcPoPxR9o9Qtr7uImdUu6ZqaQ77FxfM7qvp1DiHda8oMKbHdvWbjHX3DVSa9yxRm2HNJbEIm8LbkgOCzVepsKELwnDiu+ktX+Zbglnh3KJ+43EbrGYp0e9LpHxZAEUiwMzq3NAUtnFekFlmjLA8rXVT5UCbNl98vVAKWgCTOaM5egxvIOZikpBXQRje58u6VFIXL+RQ1vZDKf/tBd4yh4o+YCKc+btXy+z4BxyjFfVLcILyY4W4D1GHFWFHpcg8Qjk3oavGOq5T22ulDUBagZN5Ly4vqkl7tlIU8Gs0LEW3pT8Xw4ZVD4zeMEj3pYkHinYPUojcqqY//UqDCiIPCJ0XCvZrf+L9+5wP5qswKoQpV4uW83e3OHEs+0a6HCG46HeoAR09ZJEM4jN8+rcLWnLb9cuhGsYMcOXPDXWd+mCxlreahvA5vNB3wn8cRe17TKGWJpcImRo6LUYMbub+LWsXZ8acaTEjMTSG2HPAflnJS3PNqAO0xdVwFjrvEij2dUClX
 60E+0UPn
 LZfxixLu+ydPV2eHNOovZlYDiapwRYVn7YwT4kOMPJuwd2pyjr7qKgMI1gb63CsM7Z+BRP1AWpQ/gfwSHe/O1CbmsWU/8Cn5nq+09TQymUjrXW8WXrmQaZE6WTpYLo7ZiF08T63ULfUq3G1hnrFE+mzsuMwEAzQncSO+J9nYgVIl7GUpLhl1T1SxTy82ZJD1cEBhRhH5lSb3fRDW8TN8pJuz1nx903t3ptw/iqVZzc+thFQc2+LFnNvAo89ZhGED2VsaBOznbix3/8D5dxe3SxDneHKoF2PuUtC343pnSPcvIEBtQfAfEDQDqPEWVoxY19uhzC+yk4krE5QKTQlHliRfHAUpi9x/3F8exXes4kWsNEeMXQvU/YQhupMPAr3rOEIo7nws4O7KKCzKxN7/lfE5qlpMl2TJEicDRy7144l94gp9di5EZNrtj9oI6kHblMCYpaIIDWaVyYeeDv5pe/nQIbWOE2mMGjy5l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 07:11:42AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The mem_cgroup_size helper is used only in apply_proportional_protection
> to read the current memory usage. Its semantics are unclear and
> inconsistent with other sites, which directly call page_counter_read for
> the same purpose.
> 
> Remove this helper and replace its usage with page_counter_read for
> clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
> to better reflect its meaning.

+1

I don't think the helper adds much.

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2451,6 +2451,7 @@ static inline void calculate_pressure_balance(struct scan_control *sc,
>  static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		struct scan_control *sc, unsigned long scan)
>  {
> +#ifdef CONFIG_MEMCG
>  	unsigned long min, low;
>  
>  	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
> @@ -2485,7 +2486,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		 * again by how much of the total memory used is under
>  		 * hard protection.
>  		 */
> -		unsigned long cgroup_size = mem_cgroup_size(memcg);
> +		unsigned long usage = page_counter_read(&memcg->memory);
>  		unsigned long protection;
>  
>  		/* memory.low scaling, make sure we retry before OOM */
> @@ -2497,9 +2498,9 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		}
>  
>  		/* Avoid TOCTOU with earlier protection check */
> -		cgroup_size = max(cgroup_size, protection);
> +		usage = max(usage, protection);
>  
> -		scan -= scan * protection / (cgroup_size + 1);
> +		scan -= scan * protection / (usage + 1);
>  
>  		/*
>  		 * Minimally target SWAP_CLUSTER_MAX pages to keep
> @@ -2508,6 +2509,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		 */
>  		scan = max(scan, SWAP_CLUSTER_MAX);
>  	}
> +#endif

To avoid the ifdef, how about making it

	bool mem_cgroup_protection(root, memcg, &min, &low, &usage)

and branch the scaling on that return value. The compiler should be
able to eliminate the entire branch in the !CONFIG_MEMCG case. And it
keeps a cleaner split between memcg logic and reclaim logic.

