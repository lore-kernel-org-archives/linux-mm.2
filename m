Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADBF6E8FDB4
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 20:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062726B0005; Fri, 26 Dec 2025 15:45:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FDD6B0089; Fri, 26 Dec 2025 15:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09EE6B008A; Fri, 26 Dec 2025 15:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CECFC6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:45:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D2E6C172D
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:45:23 +0000 (UTC)
X-FDA: 84262802526.08.7B60DF3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id BDB2E4000C
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:45:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U8euMJKG;
	spf=pass (imf12.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766781921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TeXICaWTl/KfVZ8H31EGm2TJnHW3xapz5vNb0Sw/RM=;
	b=FWWskckBLknEdP5FO0PWKEYB5w22s3cSVsCPwcvozHCZDtNCcCxmhLuNQiaCyKbleHPV+c
	OihRON6gLfVO9mzZBFEG8yz59Pz7t9kUMcuuWU/Yc5HeJxah+ib/N3YY10Vs5Cuf8R/L6T
	Fp5D1rBxPA528pHI7ONnP3JjtTpGbfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766781921; a=rsa-sha256;
	cv=none;
	b=RuNdipMKpuwA0tgDawPrrVOfeWxptGYqU9zCHx1hQMZNRgZbaq6To9FvbssXdAWkx6pU7O
	ghTO03OSfNYxtmnFMMfnkzoCDrtyQ7l73BDCB9KU/0Axgp9uHFqO8W187bqPIhHLT5TsQQ
	u/rmt+62jCRJQdHwNLATRKbZfRQrcBA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U8euMJKG;
	spf=pass (imf12.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766781920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3TeXICaWTl/KfVZ8H31EGm2TJnHW3xapz5vNb0Sw/RM=;
	b=U8euMJKGQtFlOA15dlVWuSnGT5RdzrnTqSNqC9+jZTeyfo8Q19ruZL2jguLvglZ8IJDCcC
	iMS0glWu5ThsSOngS8zzDcMA37p+KFwWjaDQGcuSYK8k9SytA8gLhxJYdqduoEGwgemyLg
	PXfBRiSo9KhzxLpNeSn+x7EUYpSPp9c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-ORHROFrbMc-UV85w6UFXfw-1; Fri, 26 Dec 2025 15:45:18 -0500
X-MC-Unique: ORHROFrbMc-UV85w6UFXfw-1
X-Mimecast-MFC-AGG-ID: ORHROFrbMc-UV85w6UFXfw_1766781918
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b2e235d4d2so2762668785a.3
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 12:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766781918; x=1767386718;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3TeXICaWTl/KfVZ8H31EGm2TJnHW3xapz5vNb0Sw/RM=;
        b=TA//rFTtneWnn5qT02M07jJLVC9NXZldq8JgGIoqpCsd4z71vPUTd9qiuYFlR1kPN3
         qNtTa1kusjPsnS2lqH3lVCSybu2fN2rTeqwsb3nJoMIG18H5Iadk2OXnCowEsK3W/4lU
         Y+1njI+PYfTeFrSDxaxWCT7Fc/1yI0khtQfbwDlp3dnjFIdfitb1XjHoPggKBLZcaAux
         GlQgCOlYONk3taK57MorZ0s/81xZfEUWeHkdLG9w1oowU2YRx23LAXii4fgQe7MC7ebx
         8dwFoY8zMMVcjCyldEmb6hSjLkDISvx2MhaLtnNndbP00bl6ya7e0wrA96qGyrw9pz4e
         RkUg==
X-Forwarded-Encrypted: i=1; AJvYcCXoSfFGcqTcjTPP8BGCCjsR1U5BJ8PQi7tJDMqBPFDbz4AW8pRLwklfdWSUIWWI4PG0nq++FOighA==@kvack.org
X-Gm-Message-State: AOJu0YxqROS8Ga2gGgFBIjqbedYNt348TZ7/gQ9XHdLGIrKBIxvFEgDC
	I2PGLIW2U9+3pfBsW8bcpCMTLFbI0yYRgM+dmzcFXXIbrZzuk3vN4/SIfpUcgr/MgBKDiafjFBd
	VLLBV9ZLSdY6Yqr7/P3qVe1Yyk2sIc3w2SonhiDOL/wBcFY4Mcb0g
X-Gm-Gg: AY/fxX7ryXSwFANvjaqo4huXqzJB2bsk0HWPSQ+Fw0bTBAdIkhRbi/3YxZtYSsNYUwX
	f0HXPw0GEJNHHyAbem4NpMx5XP8G6w3rQCU70XdY7woNYQqedqEpiXUN6u/emSkFWrja9Ms3S88
	3wU7YNGfK+tLSi4+pnJIHuRX7W12VWGtxWdbTq1ys6wvmAQULO/ultrbeQHb3CSYzwV8s3bzYno
	wgm3wPgS7fq80WNLRSR/8v37DNmCuEORfSS0fvIZvcGKG9hpG5+rhf7PgjYjU+0yoWP0p2ziRpv
	Xp4Gr0Vvzsz0i0ivZOFsW0wXPDe9oKqxWyA5xKom1QKXCUZ9pWBh4b/15OC9ON5lMx1aroCd8SE
	x+4yslW6weSi4r8SMWgraig14nPXLgA/wcncjHo+tlsACvdgPRMPmgzOF
X-Received: by 2002:a05:620a:29c5:b0:8b2:dec7:d756 with SMTP id af79cd13be357-8c08fab88a2mr3620500585a.66.1766781918234;
        Fri, 26 Dec 2025 12:45:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXv60plEpPy2fU+PATnpKAA1Y80YGBXC1cy+B1fIWSmCaoTRFPW7/kxK6mjum3QMoJNZ6o1Q==
X-Received: by 2002:a05:620a:29c5:b0:8b2:dec7:d756 with SMTP id af79cd13be357-8c08fab88a2mr3620496685a.66.1766781917751;
        Fri, 26 Dec 2025 12:45:17 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c09689153asm1727228085a.17.2025.12.26.12.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 12:45:17 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <8282d85f-37b6-4f39-a70a-de5e6c77fb0b@redhat.com>
Date: Fri, 26 Dec 2025 15:45:12 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/33] timers/migration: Remove superfluous cpuset
 isolation test
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 netdev@vger.kernel.org
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-21-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-21-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZXcXBeCS6nqTksff9jwgE0GY5KYUjqNjH55HQqyQNP0_1766781918
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hynwdk36t1e3wknx8wep7arht6ycp438
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BDB2E4000C
X-Rspam-User: 
X-HE-Tag: 1766781920-638782
X-HE-Meta: U2FsdGVkX1+nQpAOF7ewiUYc6+mqBK/dMrzvJQlnrMF0SFLzwhbYHprbj2KVXAt57amNPfHTu+5f/baatNio8bDU6X0QB2MOhkHq3ip7Hc8GJ6D1YH2S6ud0SF0x5BehjxpNvq8f+lpvH0rFkBBsLRPh7jMFh6Jeu87xc5yZa7gihH80xc3HXM/rDWMHJzp4Yel2/K7sSedETSlr+bYGjZoTewHOZxsz1iYmws4E6R0hQNizhmepTUga7k11oBmhIMZaG/OJ3+QXfbzZBVhTx68x4JABhNpkwPq1Zv6rqYI16be7l6GnPRLCfHUE92Ks18BP3v3pErwIFRo/CKYQlCo1McfsXyKBYax3N96Ji9L3sGjqT083eWFMOCCSiJp7inaO00+igyKzDLJCbqgWjxbEny83y5WbBkAVLCCd0Q7bdQ/XyLSCAx6IHlpDDTsVlBWSYaBF+LZVRWytxSnfBmTIjC4AYmEEmWN3lkZqfMLpcyp4Jd0ewlUGeeexWIoTHyPc7Hsd6liAAwPABkKaVQouVilIkWmX0IRKzRnjEWGILgFi2x3x0yFQkHlCiX6RAMuAivS7VT3Xugos7gqEUT22xxLIbgLSwf0cs2dgumqz3IFj9FFWxzT2o2W2KwUkUHmBwskH67MLzb3e1ZFLuTe3tYeDPzet50ETIQo5JucZ3PkNMFiYu+qzTv7Ozz5niJl2byJ4foGhYMDj+sMsKAoP/1/cpXYTnWJ95nEYopAkaBO6BCOdVcUTxhqrQ0zVHr08+gJXauWQn4uPT3XSWbG7CGmHb8pHkyJjHbApBOfFn7MHa+EEMLk/Ki4EY4bfPYGHt7DIVCUPlHh83rLv6uwTPWkmTI+VRNegExrQtKTQiQeFEHDc2DI/kVzCMu3gwz20QL7h5V+Osnn3/rLDiV09eE5B+UxJdBJCrGkMzh76YKymBN5oE8GuhMENkkP7zc76KMa7YtET24xuh0b
 4KVahZMJ
 aTHeNdHNuzjWAFuUkTvvtB8/sgm5X0T/tIA+9RefshHmR1VtueD/NdC9/YF9DpRSXmZVWMg9M5b5rCxl24mPkfB12dGxWziXZbZCBCuIInZhp8W0g/CZL8uYGHemRQ2Dcnzn3abZ61bCKD0Cql8yq2+Inc4eURshLBUT4ne4M5nJIy7t05Ar+qXNUJwXFRk1ty9Y+9FQlY1nuSDfxxzGk0qb5vxcOQNqBa0FlNfhJfQ0XgL+dLCqQ7ibCNlTWCb54epQ4rvnBFxohUaKsvINuS9PRhhwGknIvsJJ2EEojhl9qLwdY2ibFsU/H4Nl3FAMIwOtoG2/hP6PbX65O5S77qhf6js+tadP1BEGbPmYeNWDKMRBi7xm9hVBq5PjEtDInQOrp0/MveJylWvGqdRqkO2MIw9NmTG/xl8Tp7ePvMskyFu4WcZBcY+DvlWEfYcQQUuuepeqEDKGJxXqWayL2PT4cOqGOMa55HNyQjCoC0Mxq7O0JUVlLXrzW3okVxtYSEXTenwyUT5VzL5WKx0QKp5se3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> Cpuset isolated partitions are now included in HK_TYPE_DOMAIN. Testing
> if a CPU is part of an isolated partition alone is now useless.
>
> Remove the superflous test.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   kernel/time/timer_migration.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
> index 3879575a4975..6da9cd562b20 100644
> --- a/kernel/time/timer_migration.c
> +++ b/kernel/time/timer_migration.c
> @@ -466,9 +466,8 @@ static inline bool tmigr_is_isolated(int cpu)
>   {
>   	if (!static_branch_unlikely(&tmigr_exclude_isolated))
>   		return false;
> -	return (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) ||
> -		cpuset_cpu_is_isolated(cpu)) &&
> -	       housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE);
> +	return (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) &&
> +		housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE));
>   }
>   
>   /*
Reviewed-by: Waiman Long <longman@redhat.com>


