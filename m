Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6E2D25B44
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D710C6B0089; Wed, 28 Jan 2026 06:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFEC96B008A; Wed, 28 Jan 2026 06:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28306B008C; Wed, 28 Jan 2026 06:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE43B6B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:19:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 559711B0DA2
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:19:47 +0000 (UTC)
X-FDA: 84381127614.08.A4C18B2
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5FF491C0007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:19:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b26bIAC6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769599185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sE6tlLY2cerxXtkLllgRGINAxWflpeXsllvs5CeFxl4=;
	b=ix5OynVKyQZj/LxMGzJ4ePdeDRoXAkgUJFh0ha14WInPmI4bZSalIGg7YT4E9G7+hWX3E0
	l8XqBPSJINiDqzj///PbCegp+oLcqvmkwme61r3nPcj7NGvzfBBCwP7LIhJ7PQrnb6V/H0
	+SOptMw5MAGmVlpk+PJojqtL05hSyDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769599185; a=rsa-sha256;
	cv=none;
	b=fqUkfNj/NUHu8bAHbwZydHkRkm29wTtIAar+ZbN3iTOa9wCaPcWX0ZACZtbZkKlNAaBD21
	IMYRzm5vWGHWKj0X5evFbCpsx9WlYNCvjSFsOmzizNtZVXj5fTVXC8MQUx3Axg+uBh/Qsv
	lDfYtFFUroVT7mST2tX+QqCBQy7Fgyg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b26bIAC6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806e0f6b69so4902955e9.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769599184; x=1770203984; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sE6tlLY2cerxXtkLllgRGINAxWflpeXsllvs5CeFxl4=;
        b=b26bIAC6PS4kwOuSwVu9HHBP0V4dv1mNOXyb1u29/65hXnBqmblPqvFHGJQluvcVGi
         62+JbpwW65VNdYZsTsQno7dSZ0Ma1BTJW+Q8y8/NHq0P663Q7/Epsyg6bAr9+BPAJM2E
         8oCNtw7bmrH1fT7dw7cY2Sm7Zrnn9QI4ZH8tJIZejbXkb83jXFeHOoEmMugNTe6Q7RyX
         Mo4++HYspa3jp+CtoQBUMNgF7H+Jm6myERzN6236raoHuGNadwd3ja7xkEbzBxjn+JKq
         VqmiSC/OX9c6I1yfUItEo2ugmGnhrYqoXcbqN6Ek9oVoIwtRajgx0E+kh1yrdLcrWrCE
         yrpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769599184; x=1770203984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sE6tlLY2cerxXtkLllgRGINAxWflpeXsllvs5CeFxl4=;
        b=sMb2BxqMwheaVLGnPN77F0wYs4gPMlaZc6GgTQniRLvZWozC7uqDkLU1ysTAsJ/4do
         e9D6svYqNIv/9gL9H6APAf8PQEINO7vjDpRHki4XE+P2+SuUocdGXaMIukzVpYtTI1JJ
         sAth+pGm724TCtDDI4P0Yh33+gEIIpbWxoUrYBGbtiWh5+CTVNL0im/lF+VpqjN+PThQ
         it0E0Ec9voYLdcwaLkiUBROLjxrV00x7v+be1lfsCoZY/YEWmimaBwPwgSziVL8RiHIp
         Kh47re3690dVtulIIlp4aXKZg/qlA7TXAobHea9p1Z7mmPTGsxA0RK5JSgcbJ7cexiUY
         u7KQ==
X-Forwarded-Encrypted: i=1; AJvYcCVa8rXIUc5kUvQO/UJ1ZUtc+C4p2AxMOyNofYosy9ScZ+VA23SWaPHqig765SVND8Dqlg0sNdWJxA==@kvack.org
X-Gm-Message-State: AOJu0YwXmHHCntEw/RIGnS8N/IYnvZHuuz0xAhBcL086fsYBvHTvwxka
	YLR5Hi2o03cHN3kQ+kS+RoV/2IGqgSam+/7aVbUVJqI1mWWtqOs5hyWc9ZkP4G+gXMk=
X-Gm-Gg: AZuq6aI5G/umxsdiCXenTQxhy3w/5nPp7iYkIUxFVgbmC4aPDz1ZjN5Rsq0jOCNJ7bG
	xb799teMHCAX1Ul6XWOfenhwbwPasaTkxblpnW7cpvblX/qhZBdAbkDJb8I2hjw3FKjZ0S1bEhz
	+KKWODzPc0PIQ+5barxDaHg2iDcduFCIt+u9co7fuQsJoHIb2JZCAvg+jFEJdGHAzk/r7bhpVvO
	LrP/YMYmdlVLmb86NyKVGdDx9hFyJuMahEXz1pe9XKNRX9G3pKLklkxg3t6dTko8ZT2Z/OCkhBe
	4lH0HAhh/HMnYcDWG/pw/zM40meYlaP1zaXdadQ6O4rAhfwL5lQXzmWefN+EEFJjMx1dpj44W2a
	2Gj6N5PKmBFeVxsUxr+cSRS8mvDn5c2bxz+44kBXsto+IaNGtH1/DMw1UZI49tKD1PxWY5OplWI
	+p9glLrrtNaEmrFAiYq9RIbD7t
X-Received: by 2002:a05:600c:8b63:b0:480:4be7:4f53 with SMTP id 5b1f17b1804b1-48069c5fad8mr72206785e9.31.1769599183682;
        Wed, 28 Jan 2026 03:19:43 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4806ce4c515sm55723105e9.11.2026.01.28.03.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 03:19:43 -0800 (PST)
Date: Wed, 28 Jan 2026 12:19:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
Message-ID: <aXnwzpeaggySKRzd@tiehlicka>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-8-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-8-roman.gushchin@linux.dev>
X-Rspamd-Queue-Id: 5FF491C0007
X-Stat-Signature: wubtqhswf3df5cngohi17jt9utiex1po
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769599185-374030
X-HE-Meta: U2FsdGVkX1+k2TJq2EQMUBDQVfr6p8is+5geVs06PPI6kf88AW+2TAhJ+WM0S3pGPEkYESm05VKlKoLdO+7Hq2mABQzXAdlFAe8t4KfACoWBQNhK7mLsTSjB++nzkpVDdN0tOEIhsq7gCK2z9BmOwLYaePPCNR1KH7LAgdEsCli52aEQj0W5tO7BoiZFEl5lJA+qJ6fIrQOxY5KAhZ7iY7O/eG8CUWspuIudqxCW+cp9tvW08v5hsPiWUkhxYE/oQ8HyRXSIqU68JGxQWiL+HsJlYazLHATGz3bv6pOEXZGCFFS6oaljKR4F5dI/Foh74N6XgSvyYDQMtTTSNnRrWyuqTlB/lxK0PXO7asbKCWs/h8BCQvRp2CKsFclrcJKS5NdTB5FDSx2ciXBYs8pWXGdsxFQh0P7UKkg2BYcabTpYYGSamvgZpMYFi2gh2U53SvxhL8/sFUzgd3VHtsC2Hw5DkBLNSYckO3csePieJMhHnyIx92L1jpzJhWgZ47dk6VxJYl71qHPeJ2t+BvkxKl7sWRChTzJ1J9Bvc244ysznSxG3mv5PIK36fyQRLc+bZIxrB7otIIXM/itv4Wdf2qF3wXT5wBw+OlBIEvy/5ILWROhLKYqbecdKrKqwvQ8vm5lFq/B+JJmbtRFLDDus5WxcmLEFauDN3qkaR8ffkwRZppU0pwut2ckN1AHwcORXapkNXRzNpJPlWLeb73JqBjE7qkGmZELvBZfeYbQh1LfGwdQRyjdoGpL9IGYcf0Q2UbMyHKMVKBfD4PsuMlzP3tzualoSZJheeR4xaV+VGnpJ+r+ZqmNTqZA7WJSp2mcW8W4g1l/wCEXXZPYbEb6whfFUO/YP8NYCJpAuG7lGD9gKgZXFMu3jbIU+FG7ULmrfHaS2XdKpVwkskcQUNb8WBd9GKGGNdu7AcOJs19RhHeHeZH6jpRD4Ffwb6KtEFY36qUZdSSzrcUikkZVxuqg
 Gy8fa24p
 SCJ6bKhQLjKNCjMibi8wzDtdo1sWLQx4Bv7nhp734GCSUrI0uWAe3eA6R7lEN/5odwP5cOQ9VCET020qNzQpvdpdOw7xC0YNvVNmokXf7LK5b0tXpFx8ar4sqe7JGCfHAqhnHiQ5qzV1t+wPn/yQoLHqapVcpN457cpHMIUxxI7b1VHEGafmBkl1OqfnbHMydBj/zyI574+/PMzm4uc8yoadVsSgHHwz7rKHZ9hQUf7Al5K+lKXwe7J1GYychcZAPrxyKGfVWQuoGpSW8sWVZ8I54cddPLyoVPvUfr02DdKLBSFMpoVqUdcIBxN8YOMt4Cf4MTY91nFU4R5FbWqjV5ZVTJa3oeAaNgXYZRtoQu+FuT/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once additional point I forgot to mention previously

On Mon 26-01-26 18:44:10, Roman Gushchin wrote:
> @@ -1168,6 +1180,13 @@ bool out_of_memory(struct oom_control *oc)
>  		return true;
>  	}
>  
> +	/*
> +	 * Let bpf handle the OOM first. If it was able to free up some memory,
> +	 * bail out. Otherwise fall back to the kernel OOM killer.
> +	 */
> +	if (bpf_handle_oom(oc))
> +		return true;
> +
>  	select_bad_process(oc);
>  	/* Found nothing?!?! */
>  	if (!oc->chosen) {

Should this check for is_sysrq_oom and always use the in kernel OOM
handling for Sysrq triggered ooms as a failsafe measure?
-- 
Michal Hocko
SUSE Labs

