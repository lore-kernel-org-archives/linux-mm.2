Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD3EC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2FEE6B0131; Mon,  5 Jan 2026 07:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7A76B013B; Mon,  5 Jan 2026 07:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6E06B013D; Mon,  5 Jan 2026 07:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5A56B0131
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:23:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C3C21A252D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:23:00 +0000 (UTC)
X-FDA: 84297824520.29.D43C15E
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36D5A8000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:22:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WXuqFbJ2;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767615778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDjr7sjCBTGkDF0qNYJvmYk50F7qRRVcJ9woEM6oAYE=;
	b=JbWv/UaL8dVu/eoQNkUCaTrzFbjpbJkG6eCZa0r7s1G/gupgSMPQHjOpWZrudfp6UcBrN8
	vMQpn2SeymFqvPza73POwbBBftLUInRkT5Ey+dJy9ectnG6QTOOol6BUlOLP5brKvmF7Ua
	ka9fX85S2i9INaZg+sueKCXlm0QjSQc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WXuqFbJ2;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767615778; a=rsa-sha256;
	cv=none;
	b=SzzshVZ+oqSCjMO/ZjJOvq88hYMMI4IaesucJ3VFM4q+arF5mkW7CRyvV0nxl4Iks/z7Je
	O7TvMiB1cgIQSHoTI3Knon7yi5TNSC+/huQT0Qf/6n+ohduS9mA63pHim76G4CHzD7NBD2
	bQUakZRnvb3wQhLIqYQPc/PvsEjmCy8=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47774d3536dso15810315e9.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 04:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767615776; x=1768220576; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDjr7sjCBTGkDF0qNYJvmYk50F7qRRVcJ9woEM6oAYE=;
        b=WXuqFbJ2am495ZyEHEzunYBBEVyjSuVLbJGN+p251hTuqz5OX+ds8CV8UC4V9Ll5w7
         /wC0A6tctl3D+wH7jeZz36ioecDRwaF8IbKsbWFAyclYPrxkHrAi69Na1dhbVeK6GsFl
         4X7mdPcwcHVaCbNqPMMEHIhh6qjtqREvtETauxPdqaqAj0vZq6BIjkG2NeMlvXKi43Kc
         fkJi6hIsF81ZUpSFsN2TWx/+/wFbhQgMmY5PDG6zOD3bXSkfLpfliRJkUEsjWansBJQd
         TlRTHA8jz/CostOflxIZCwpsV+UMvLLKa7ycfBM4tOtUQ/paSOBGU3Iw4yht5Xf2OmfL
         Dgkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767615776; x=1768220576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rDjr7sjCBTGkDF0qNYJvmYk50F7qRRVcJ9woEM6oAYE=;
        b=qLwLrnGvAQYZYUni811B4/Il8p5GqI9BFKdKtb7UETh466XkJM9szmedfJEVqY3c5m
         WNJku7hCe2/NVCraNPS9AYLH0c/OENUZklA1gH86hLjLBMb32T43umfH9IYSTi7NOeK8
         EHALoRmhG2p3v13o4nvQhOvowftbVV5PT6jO9fhm5bPCsC4csvg5z61V0HfWLcrYnrC9
         uqubtDMHKZppsaqi+lcYOBzLNJzAZqY+q7+Jtc/I0MQK5jvtDjhnfIwvyxxRlXDOHHsg
         ELZGE2cAtDlW1Su0t8BEYpM+Sswsa+kfz9miGPm/ntBwS3J6x9vwOBurBkQwmK1VqysN
         FiGA==
X-Forwarded-Encrypted: i=1; AJvYcCX8W0zeduSFUIxsGxb8lKyfRNc9FrSVS3iQAZQcjGi3ohNh7sJpvhBgyI7uevgmA2LATgWup0NKcg==@kvack.org
X-Gm-Message-State: AOJu0YxlrNcc1QhIxHw8oJAtzavV5D5ZaHL/sZanHNNOZFIpepAWRMXl
	dtUxQeC2Y4R+qJ5uWliDkXl0502D9l2RjaVfH6wu5ck4lB8XBWZM/2bvZLMs1CCaZUw=
X-Gm-Gg: AY/fxX42e01ps9XFp77l1sykrD8rI8RGVWqbxArEb21gjI2MZqKcq9d7+RPKqcKCkwX
	wtizKRhP5DoDG3/7KNsCaotVA+xGtDlOZOH0Kz5AScTbs1OO8sXT76umNuDCNor2nVBiuhkvF8X
	NVA3eLUHNzDWdwNRN384ACQc7NgEdM0AfEODNM4To4VIQELPvBwnfkiRST5OxhjDstpEuDLLt7I
	r4MxmxRIxJpWLvGwuLce1QRe/LuVkM/xSHtIQEn820ZkMYu/t13y1t3O7Zdo5BkHoU4HKC/wEjU
	wjZj+cnNHlrbDgml3oG88pHP9MdsXz5Jp99hmwFgjgdmhQtD4D5DmLrTX16XBq0YewMjoNlo+KM
	v+iZrbq640OvaWA2SaRlWKjCPVBfuc+bl4+oD+ZXiOZ1TRwF1dJxX+JiKzZgAOFrsSeLn2tkgj+
	GOH9vXaiiaGSaOrF5aag+BBcEqxdS8tH4RRhE=
X-Google-Smtp-Source: AGHT+IHeC7mUboBRlz7N9ZYgFCvggY5aIL7EnfSyiNx0ei6dT1WAdqZGjNK1YMGVuVNtrTLRGbVA6w==
X-Received: by 2002:a05:600c:4704:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-47d6ba8900dmr108543375e9.16.1767615776595;
        Mon, 05 Jan 2026 04:22:56 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6c0c62c8sm54656705e9.19.2026.01.05.04.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 04:22:56 -0800 (PST)
Date: Mon, 5 Jan 2026 13:22:54 +0100
From: Michal Hocko <mhocko@suse.com>
To: Dipendra Khadka <kdipendra88@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rientjes@google.com, shakeel.butt@linux.dev
Subject: Re: [PATCH] mm/oom_kill: Remove unnecessary integer promotion in
 format string
Message-ID: <aVutHsTCcHgt7qHk@tiehlicka>
References: <20251230123336.ef33f8a55df71f3e3f782532@linux-foundation.org>
 <20251231122117.7683-1-kdipendra88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231122117.7683-1-kdipendra88@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36D5A8000F
X-Stat-Signature: x3ae1f3wtkodkpdgbqu131yrfaiprjan
X-HE-Tag: 1767615778-110487
X-HE-Meta: U2FsdGVkX1+dBh0zg0KYyZAOOmEyMzRywF+f8gFF9FSXaCiMjfcZirVVegkUZLXD1VcE5O7Yl22nHU+aGOtdqqZYkvnhJ0rDzqgQwTAKM5+p01zpDd7nIxshqgaco7PpSFPR83OJTZPourNZI4vhcWS44G/r2bLVsFtNpdL+hSfztPU6Hy+STPZJqyEABm1nBuL/uqB+CHMmuGnq+PQx5nxCVLdne4Rn60C1eBL0aOLuFlGkUwpOglS6F6I8i+feVSNB6frxsZIlaRA+4LyPtlIwElcn8toHT72nzKFaJglkPsWKND0ie/OVJ1SxKOAM+w0uMhyZpJGlxzSH9vJP+wbu9tsEEHi172N3pxCz5MLUhkTeUXpM5rhf+eCxTbsOx1UcvbdywofHaEqOfqQo47SjW75LLZRDUSpqLZofQPDsOBl7nZJuXpjDHTv2b5egPTyQ7tdX4EdBbKDoj69Dh8vzS4xZmGVMTYCbwTO0KhpfUJyKxxRgkgZPMyN1aUeooPQpxUZhGeLpDFI/CZ8frSNs2SUbavCh6yxXfTI/b7xe6nntEGhojASPqyeLeORRXBy0mELVX6MnbWCH3lY6iZsodYe4J6QVszLcv7O43c2gIAJr7f2YqRkPnj9STyI+PG+ip9UFfR3Fq4lhWjK9vcx6dFqnAuwbsluJ7XVnKC1laE9/BMc//ooez7ZXNmrdcrropVUHN6QTCBlja6N6lJrKmxnS9/b/mhTDzToyuyj+//A+AQkzyDUdKOct0+OirS1NUWbjsWcmxw5fZYXuK5ynJkb+h2W5BeJ3tP2I8V9v7GIhk6rSdFtEmpndi24T1uOlelor9NqsKNX3wp+p5nIr0uY8iypv6+O0/dxDCwuA1a5bU9cDMBwXDrHCAFJM/OxnIGgMxGh9WUamDmO1nhi+od4g+zkOrpYHgoZWpvYJiASH8NCRCo2qVKOAQY+dan4k6qR4Bf8g2eNYe6L
 OF2buG30
 ggreSHfZglvnPh0F9vPKfu6rvDFGKSj3sBEgTCO+UDIWGwaSGrLEsq4/3ht5igvgR1WzpmuvyZuQY8gDY5fTcEUXAXdeqRtu6EilqIbEvp2UtUk/hAY9lfzZhEefjkdQo+k9ffkiJyA0amSg0+y5A/+q+XzSQm4AirHXibOne9RyQ31PrNHVxbfgOg0DqXdmsmnWZ4QZBSg0FFxLnoc74GcnPYTedkditi/CFDWN01PiH9CM6I6rQqfHVp0EQ2XHYnkTpjt20qR1HJ1xvDY7x1YvvGwWlt+HQq3Zq7eY+GUm0dz4D++t8RHcgjyFAHjOp3kOJ1O4GYx82T/BVrA0rEWYgBnITpa9juhtcU8e6uRZfdDfj/ReYX2DDEP12rb8rrqEdC3W+y7hAmzkL86lB1JYTw5pVpvNNk0SkJ5IsFWQ58gN/7HEsZ7+4iDuSjHTrRWSFY5eV0HwZEao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 31-12-25 12:21:17, Dipendra Khadka wrote:
[...]
> Checkpatch flags the 'h' modifier as unnecessary for this reason, 
> and many other subsystems have moved to using %d for promoted types. 
> Hence, I think this patch aligns with kernel coding practices.

And here, this is the actual argument to push change like that. On its
own this is not really worth it. But if there is a general push to
remove %hd then sure change like this makes us closer to do that and
quite honestly I am not a great fan of %hd. I will not miss it.

Please update the changelog and then feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
-- 
Michal Hocko
SUSE Labs

