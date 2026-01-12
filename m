Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76F2D2502E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 01:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F342F6B0088; Sun, 11 Jan 2026 20:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2086B0089; Sun, 11 Jan 2026 20:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3F86B008A; Sun, 11 Jan 2026 20:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAA226B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:43:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50052141474
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 01:43:36 +0000 (UTC)
X-FDA: 84321614832.11.BCC357D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id C78E440002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 01:43:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h20AJA39;
	spf=pass (imf12.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768182214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5g0eqFZw+saooIdmg9NsoPWVUWAMnQL8vdrqEmKZ9zg=;
	b=bwb5Rn7GKetYmsYVMP1Y4Q+W7wMq72ujf1BnFCfnsZGccn/v8Pjugw0amrx26zoAu4c2On
	q+fF1zfS+9JjkutWJz0K8AvfY6h1qvCglTNjr1qh7zcoJ/P7kuEZCg8exrSApZvAMgxYoj
	yqmsynKac5wicbrNfsdjGz1jyVuwELE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h20AJA39;
	spf=pass (imf12.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768182214; a=rsa-sha256;
	cv=none;
	b=dOuxAwvDSUx9BJLPAev0/mGjOQ/ZRFXBggtTBzItJt1BZ+JghKwKFnlbceCeN1oPbQHa8/
	LUTwNt18IyYGIiF+Eu2UGDufgW/1FnSn6CUDlTCfcrBOJCYRntmFNOT3gJBFadqYZmJ/eB
	vhD28HaqQyQ/vnAfidRCX/gVRBFDr4A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768182213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5g0eqFZw+saooIdmg9NsoPWVUWAMnQL8vdrqEmKZ9zg=;
	b=h20AJA39iueWpUfsWHIyMbWOwGr8njJH8B4VH6UaX9OhjXt+tovB3b7LQHHY5qVQKl6Eei
	xDpOBfFhSoOh9al/I60XBM719p4XDmEPiDT0H+lkx2j3j7ldZmy1lijmYRRAgUHxUZSg36
	uwZz3emhbIMqwGSSDShzUQS6iDs908A=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-f04kXBt4NlWMIRgSsgtouw-1; Sun, 11 Jan 2026 20:43:31 -0500
X-MC-Unique: f04kXBt4NlWMIRgSsgtouw-1
X-Mimecast-MFC-AGG-ID: f04kXBt4NlWMIRgSsgtouw_1768182211
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-563719ce0bfso4917636e0c.1
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 17:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768182211; x=1768787011;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5g0eqFZw+saooIdmg9NsoPWVUWAMnQL8vdrqEmKZ9zg=;
        b=spjzjw+VAlkYEU8Q1wArL/UDVgACHpPACvkx8ry3fIk9wpyvXQ9orE2ytITkGfiwSn
         uvCoos8d/pGW8k7DFD37heO8l1rYWNRYRQCazmnEIpYJvX8PKH8L353n/AkkPzkuval9
         Z2pQdVGGk8hOzNWWPUmVfTuiGX3GxDxTK2UNZrey7v87exXLYM5wth4glunSywSWW/Ss
         pJUjqZrwpeAxgY81A0GxuSyeElxdOMVjLMcp/Hku34X2cyBIETBpucUpyGAml/z2tECr
         NzoKfiz+EW6HXU0YBT+PVGcGCVmB547/cjmvLO8QJU5TL6J+uI1sqPKIW4ME5xEgd4rk
         gaQw==
X-Forwarded-Encrypted: i=1; AJvYcCVquDNCZOpZWP4zdUPD8q3uP7TknWWP8WjDP+Q0YW/lZaWBGZnSbOYXMfWAafah7PLJlSqZ22yT/g==@kvack.org
X-Gm-Message-State: AOJu0YyPCbKzP48YcsGNIlqAe2dEV5nNTVZOpj8HQLIw7tWuzgAX6api
	mNzELkrw2kuOVFGJsR1rgM9G5Hgp1OJ1aqhxnMm8FRPgJBRjnF9MzukSh4FJi87hyfYupmj9/V/
	j1w4VR5dUdo1dsyZPiaoszjywUcd8onq/tEmzT8V4dYzhKfmMm+F3
X-Gm-Gg: AY/fxX6dwB5dPE6MlzD8/vDnryy9Kq31QTCMnvWYU+omtWAFXN2Jk9BO2ffisu9T46Y
	2LKyFUsoSXf2PamSNp42YpSHUy/8w9L4xt7jfp95Q8grTXWwPaj2LOsG6Pxm5QkLqRpGEEWpisA
	nFa7XQToWBPdyYnbD7abk2XRCvBJZT6cfGJVmVGD7irkvUXTgnYlwQ4AMIvkVVC026OqYsoSEpD
	rfNwGNM4pv7lEO2Om6sbxds54LIfUhm9LbxpyctebCL3SlBz2r7F2Q/VC4ukoMWUBdH2s/ui6V3
	1E/YBuB/9vk5aQ1gtYHjHx35zCbZ4u3joHTP1I/u2ZRXq4V8FEo0Y5mAAjuJd5IBeHClPKcsFCd
	X2Oz3Sck2Bdog70uuJ/PiJ+EAamfK4N1AXFge4Tofy9zXZg3R0+8FfKb5
X-Received: by 2002:a05:6122:3383:b0:55e:82c3:e1fb with SMTP id 71dfb90a1353d-563466b1471mr6360627e0c.10.1768182211341;
        Sun, 11 Jan 2026 17:43:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHV+QUILwqeHqopifLZI0TMkyTSwUxskEqEsydIK3wu+6ViPTcpBZklzMvbaEYb1jKTIvUBCg==
X-Received: by 2002:a05:6122:3383:b0:55e:82c3:e1fb with SMTP id 71dfb90a1353d-563466b1471mr6360599e0c.10.1768182210967;
        Sun, 11 Jan 2026 17:43:30 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56375cd7cd6sm4961512e0c.10.2026.01.11.17.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 17:43:30 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <e97d96fc-cbdf-4c03-aa1a-b0cde5419681@redhat.com>
Date: Sun, 11 Jan 2026 20:43:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/33] cpuset: Provide lockdep check for cpuset lock held
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
 <20260101221359.22298-13-frederic@kernel.org>
In-Reply-To: <20260101221359.22298-13-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gt_24srctGzxYNB_VsDSvmAxku1lRT80rOZ7VHMQCqk_1768182211
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e5pkkoqmbberx56qunq9upra8j9ukxyb
X-Rspamd-Queue-Id: C78E440002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768182213-556328
X-HE-Meta: U2FsdGVkX1/EWOee86D1abB3/QJT7fxrvtyabiwdG9XFDGmjSMGfjn0Ue6qanFCt1eP7sh7ARJrfTKZ0IAdpuI2VnBX97b3DDzzNRfm6YctiLr4bl1tNocaTBlx49WRnndjDhIRAhNzdmyHQOvBiEtyVwXyOlIzGwHloGgcggfdY8NnBBSFx6NeasyrPxaC7RVrmQtImhT5UOmL7Yz4qdKPrHGaOpRiy3T2f9aOVWzf0g9glv6BJpHxR7JrQ3E6ALme9OoEFK/+xGus64CmlhCl+Lg3/HF15JP9PouZK1leSZp3CIqhSywNIhO8IrstTtiOQH1PfdjZHA7hyNvSS47Lsj/FUJ6/euZw7zQXZSH+UlPPZV37UvrImpfhRDIH4Cf6mKbDCT0mVuSoKFeBlgb7/qX7fp1aobJxwdlr68VdKTzp53SD0V6/LmbZ3Ns3r/0b10PXeBTZhSuLJal02zYTxk3FSUm/IS50Ei3kZ1EJIhPCHwfzjk3l5PFVLfhLNUiIA74exv96Cy5MGuaK0pcm9UX6hsYrsYLOoNt+zpkZDdS5XQKneicRR4sVSAPaG9ewk8DwBqTuEkr2bvdiMP1L3sVdRCxUFR58b/pDg8o4JUGfDFV2bgOAzLa+YFtuq3IRK0Qn/oj/XR9baoI1oUcqjaQPMML1puThKUhNxEYYo02NBSaOlB3jRrESIXwyON47gONb2iHU43et00QuXA7rQOkS8pWIFhyPRGFYbT8WYsxrnHumNXGrkpA3I/YJ1q7RKpShb1YRAiQt5UzLApYBz9PFT/ScdumjmsQd2HDsmIP9NFz1HpSYnbBZfCnqKszJAmJv/Hh5U5yQwXyb0+dbSgBeEXQd+ESrvLWYxsI5c8/UaDRyJTxIipblYpy5TuWsg3uEM0zxaEd4Uj8wSU+wEYBv7ky+uXNlJ6mLFMLxwf8wlVNTIWHl1kY7tZ0ZKtQIz/j8oQTjFk3K4+0z
 hqALhx82
 AJH5H+bWDmnSDY6ALChibZ1EFbsvAF+vb0PE0L4Q6toFXhaHqkrfP6jSJEg4Ft9bRwypCvz3E3UmwL/hfZMzMV7WHF7SJQEyF9MflJUgkKFlWdbYV3zjQsuYWwAxRws/JipFTIifTLrOu2+HmLHMK2NNxjEXvXhSHIZYgr4YqFLM+KcN0hI8PRCIwkBwY+iSNYVb4KSHnEb8Bxn2qfxd0OFHekjfZZSlcvM2YmpVnTZzFUeXE6ud8RQEZfC6LaSGCOgBYBJ8855O661wClZJ7xdf+HZhuAaV0KoxxcjT/23/BpVl4fw7qAD6ca512j3j+if/clvpynJ7ACdWLtshm7yL9zRl/RlKquyZ7h8A21rpelegv1JOYJXETku/BuVQzKywThhVPKPTR5TXMXuEwzj/8u1BJ/VRP2Nptl6T/HjGQmmQvaxReT+vQf4lu3yuqKnjjSM+QMuqG2OEwSlfBLAj6JL1VnYzRbqikHdNzLTNyUXYNFfYuumpkbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/1/26 5:13 PM, Frederic Weisbecker wrote:
> cpuset modifies partitions, including isolated, while holding the cpuset
> mutex.
>
> This means that holding the cpuset mutex is safe to synchronize against
> housekeeping cpumask changes.
>
> Provide a lockdep check to validate that.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/cpuset.h | 2 ++
>   kernel/cgroup/cpuset.c | 7 +++++++
>   2 files changed, 9 insertions(+)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index a98d3330385c..1c49ffd2ca9b 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -18,6 +18,8 @@
>   #include <linux/mmu_context.h>
>   #include <linux/jump_label.h>
>   
> +extern bool lockdep_is_cpuset_held(void);
> +
>   #ifdef CONFIG_CPUSETS
>   
>   /*
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3afa72f8d579..5e2e3514c22e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -283,6 +283,13 @@ void cpuset_full_unlock(void)
>   	cpus_read_unlock();
>   }
>   
> +#ifdef CONFIG_LOCKDEP
> +bool lockdep_is_cpuset_held(void)
> +{
> +	return lockdep_is_held(&cpuset_mutex);
> +}
> +#endif
> +
>   static DEFINE_SPINLOCK(callback_lock);
>   
>   void cpuset_callback_lock_irq(void)

The cgroup/for-next tree already have a similar 
lockdep_assert_cpuset_lock_held() defined. So you can drop this patch if 
this series won't land in the next merge window.

Cheers,
Longman


