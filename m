Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCBECF45C0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FEA76B0005; Mon, 12 Jan 2026 13:04:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181B86B0088; Mon, 12 Jan 2026 13:04:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056BF6B0089; Mon, 12 Jan 2026 13:04:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E39906B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:04:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46B75D1984
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:04:11 +0000 (UTC)
X-FDA: 84324085902.20.2958599
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id A312C120015
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:04:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bmm5xuEu;
	spf=pass (imf29.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768241049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGMJ5LbPFmGC8KsyFzZBiUpjaLMx+kfqn+JlgSdWn4Q=;
	b=qu7SNvD753m8+DSBkiDT9T8c/TOsK0C43BakITT6uFlqYAOj+i/wIVoSxlBFDyG84/Y78N
	UFJyizZjvZzQDVahM9tQryBHCGNEQRsBww1bCEdHnJwO4TdxQSev5VnVta+qDHkVekts3q
	H2jGz5dVhLxk6d9VHHr0evRucVDE2X4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bmm5xuEu;
	spf=pass (imf29.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768241049; a=rsa-sha256;
	cv=none;
	b=fIEj+UUMP95Wvv+DqWr6QZ2ZfY4NjgfVn+Zz04qKbz4RMmgh/5fXXqHKjxsN7ySfGc5BdD
	aPy215QRUaJm0QJIO7NGFbmabFMLn2r/XVVFB49/Lee9zGbAjQrsSJDFHZ1U+lw8C2s5JJ
	W+dYIjt5au6rGSNMvoYHN4PZNW+QhO4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768241048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nGMJ5LbPFmGC8KsyFzZBiUpjaLMx+kfqn+JlgSdWn4Q=;
	b=Bmm5xuEuavZq6ulGSuTXum4O1WLyQa0mjLadZsGuZE5SE37M8cvFX2d+WYZWUed4fz97Xz
	MC9hYebQmY4iuFmKOn7EIhgnLD3G0eKlWdJrvybGh39VzPjPIVhwrk35b2rsOQioSwDVx8
	aTXTp024YCpjEZselQmG+FJL3RjmFAg=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575--UrcM1rlOBGIiIun8-W1eQ-1; Mon, 12 Jan 2026 13:04:06 -0500
X-MC-Unique: -UrcM1rlOBGIiIun8-W1eQ-1
X-Mimecast-MFC-AGG-ID: -UrcM1rlOBGIiIun8-W1eQ_1768241046
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-93f503aeb85so14243222241.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:04:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768241046; x=1768845846;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nGMJ5LbPFmGC8KsyFzZBiUpjaLMx+kfqn+JlgSdWn4Q=;
        b=u1GrBPSIBzJwKauXtcBuzNQQb1KxfS9ZmG+4NXf43NypX68CbGbyUnHgBrPiuWEyQH
         1SPIJ7Rz5L6P2ArYWAk1hA3TvMk5fnkM7/GkyXtvN6FmoKbzrNBJ7NKmmXUu7AzO1FWb
         UJl1TMyNNMvQylF0uXX4nYs8AhhaSIX+hhRZEOcbRAccBICt/V8XTRsJ67C5d0hlmG7u
         PQSX9OkcyhUHExl0Q5qy058ceNM6TO/EQnBWdC6p60mW9RhQGOhJmGZ5DpPd8E8xNw97
         dbQtJcvWgDo/YvdNUTkGALlYOqEw7C/+3VZNuA/Gpvu+CCJe6rERHrgxqHdDU9Yqzi5M
         XumA==
X-Forwarded-Encrypted: i=1; AJvYcCXp6IuG32W8IQdc+I8lZ9TBa4TZyep0/TCRZNwrkd73glEZa6rM9Jf8AzFaZVsRTvc6x+g48/5GWA==@kvack.org
X-Gm-Message-State: AOJu0Yw0XG9ZH3Bw6Yz/l8mFHSpIHaxxSDNPyIbtpMcATUobLbPhZBsC
	6XAMnRF9RxCkUrr1HbhDqI8aPCykTYD4pmzSMstMUayFKnB+ySVz+zA+9CekCIk6zQNd6bdv8Dl
	R6ln17+ctu82RkmrVTo8dvWMrceibA5ISuUtSycDNx0e8Ttss/Qiu
X-Gm-Gg: AY/fxX5j0Lwqyq9w8RFEX21xl0+Rkl0PNBiLRUidmfDlctoBuwlQXQKDi7Ri3sfvmQ0
	2B3zKvaiyFepACJbDHnQx2Y/9AFkMBZeyvg8AjIsKaxnJWz5ySuczNWea/C735xJagZwmo2Nff6
	uouGw9kosz7ktLPHv8YFOGHauT9eUBwBruxaLUGefCZyvbgl6/5pLR+5jQynhnA131Q1C/01jzM
	bCeYV1L6FM12VW4IBhB3z3mgt+lInTOUl8dnHhS3LmexkpyrAI/PdNXqqCaxPGEjYAMpZLyv3sj
	MxgbwvzXgjBePgdXlW67I0uqBAbLQ8aoWZWL1jePviDHz3tXl7V1ieOtUrzsJFArtP13ymoLnEV
	R7+GSx+tZLnlf71mt2z/Q9nuGkoCRpV+9bhauqkVVI39NRR4/+xTzTyRz
X-Received: by 2002:a05:6122:4897:b0:563:7886:5e7a with SMTP id 71dfb90a1353d-563788663a0mr2841991e0c.9.1768241044887;
        Mon, 12 Jan 2026 10:04:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHM6+Ba4s/MEV+9Zbgj4Jf91uX/qo/VCXWtL6yFKP9LvZ7kJD7E9gBdpreY2pV75Zsq8xOxKw==
X-Received: by 2002:a05:6122:4897:b0:563:7886:5e7a with SMTP id 71dfb90a1353d-563788663a0mr2841898e0c.9.1768241043068;
        Mon, 12 Jan 2026 10:04:03 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-563667cf148sm10043559e0c.2.2026.01.12.10.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 10:04:02 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <c1cac1a6-22fe-479f-bfc5-89a5d3aabda5@redhat.com>
Date: Mon, 12 Jan 2026 13:03:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/33] sched/isolation: Save boot defined domain flags
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
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-6-frederic@kernel.org>
In-Reply-To: <20260101221359.22298-6-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _zR3bhSPNPU7Q2RSRgi3V-6dyhclhQtvvf0187KpKqk_1768241046
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5g96jgjztwns5iyxqwhequupgzmxhrym
X-Rspamd-Queue-Id: A312C120015
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768241048-466690
X-HE-Meta: U2FsdGVkX18rOsxla4UpQW8U0yV3ooaeopuALXoo86SSyjbeMY4ssmegtv4CV+Ys3hlvAaNyVT4AWzvXPPapdx15HyB6xxMeyimlayXOurzehag/letvPhORSA01GlVIwSnsuA0qCIppCP/BvZdvC0aXKSd7SvR5hBJHty9mDfQhV+eTShZK4WxNpxRuZ9bROYIF+zE3skRUWiHbNSovt4l8Ql6SZCQse5VQKhwaa9r8aJUMxXtbHggrnaP+EllexaiJSKvqAT50GxBg94N6ujqP1KmCaY45imcv7+DGB6frF0BZXfUP8Jrh5u2sGjVdt+f5ZYjgdT8bj7F7edQf2reTHa30ZOcYM8PZDTU1jsH6bLXCXylo954te3Mb1dD3e/5Gp584/hItRtpGvDUMUH9g6GWMbS7vO0v/32YUKkF+Bo/5owgGa8tdDlgDxwVDxZSFE/X6crEgUgO0aBnuYPojSXon6thZUmp94Vr68Y76wO2u1ETs7OnJAgbOxX8wBnukU8UR0cIezu75Da00Fjg5i3e2yQARauNCbi3iO52KywfopUgSFkXJfE3Bcr7QZb4pVAne/wzmeWw1iVDs8HfYKXITFsChbmvVuGtoUMUgwQHyDQKq+QQIATi2gyUzl4luPnZpa7wdEmDA6Xi4xCG7lPrVygarBXvnuAO4774z03YaDLXL0ATmrlnVv0xpqiAxB9vfQ4gDHly9QsPrezFCII9ymGoWHAT+ODD3DLgwkjQEjrmaTsS69ty90ci6tQqIIo3/RgO5oDg90FUOEGE6UjmYYZ3f1LfbA1om//OXShbgpdBOUklFrC1yHxp5Zrn5dpNpjekxzY6bWm1rOlOpMlQIm8Mk0zG3JjTSpgV9xBoNr+WgAMCXkSraavXCSggM62EBfAH2EPcFkLwI72ekzc8e50tE3FYR1/NFEcbemmfClxyoOmw7dgIewkc02k6LZKjYG2tfKjvrjI+
 V7KIKaW/
 jkI8zn2WRyvf8rYZZzUC5GDNCpYGsqOjFAI6j/cqnOVsbwScr4e69gYw1J0WcgJ6XQDZ8ZO4WETvSvcDJkb5V8etuyBJuUZCJrZ9V8WVpAPbDHJeH+Qi+w5bHOZCi5E3tBGU9+nySFBIA811W5Y9iajuDNuOR4xXhdhZX6a/ym7arU+wFim4T5aJd5nEYkws21hRsndlxm+VPFUtYwpFob1pElmjuZvh5FxAXFOKUNeajehHqEhJdYvJkLVdpw4LDowHBfqVCf1yaWWjhtyPa+KbRFevP3qIZtIK2tLyFRbBOg9PYJfHte0Zz66yldHybVFE0Kn1pQAeJEjqCuQxXknWpp1Ri/FA5BZguXShVivaI8wG+Oyx+vG1A6JL7kIpP+tAA8JsmuRabkyEo315Q19I7IOVxHsASIBY/IzBZE+lFthMdyOfTTVahYD/cfnnQrnUWZGyISO+8DJMl1ij8UfXL1JLqecL1mSo5NY0M6g4z/hs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/1/26 5:13 PM, Frederic Weisbecker wrote:
> HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
> but also cpuset isolated partitions.
>
> Housekeeping still needs a way to record what was initially passed
> to isolcpus= in order to keep these CPUs isolated after a cpuset
> isolated partition is modified or destroyed while containing some of
> them.
>
> Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Phil Auld <pauld@redhat.com>
> ---
>   include/linux/sched/isolation.h | 4 ++++
>   kernel/sched/isolation.c        | 5 +++--
>   2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index d8501f4709b5..c7cf6934489c 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -7,8 +7,12 @@
>   #include <linux/tick.h>
>   
>   enum hk_type {
> +	/* Inverse of boot-time isolcpus= argument */
> +	HK_TYPE_DOMAIN_BOOT,
>   	HK_TYPE_DOMAIN,
> +	/* Inverse of boot-time isolcpus=managed_irq argument */
>   	HK_TYPE_MANAGED_IRQ,
> +	/* Inverse of boot-time nohz_full= or isolcpus=nohz arguments */
>   	HK_TYPE_KERNEL_NOISE,
>   	HK_TYPE_MAX,
>   
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 3ad0d6df6a0a..11a623fa6320 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -11,6 +11,7 @@
>   #include "sched.h"
>   
>   enum hk_flags {
> +	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
>   	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
>   	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
>   	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
> @@ -239,7 +240,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
>   
>   		if (!strncmp(str, "domain,", 7)) {
>   			str += 7;
> -			flags |= HK_FLAG_DOMAIN;
> +			flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
>   			continue;
>   		}
>   
> @@ -269,7 +270,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
>   
>   	/* Default behaviour for isolcpus without flags */
>   	if (!flags)
> -		flags |= HK_FLAG_DOMAIN;
> +		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
>   
>   	return housekeeping_setup(str, flags);
>   }
Reviewed-by: Waiman Long <longman@redhat.com>


