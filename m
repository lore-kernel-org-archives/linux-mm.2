Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 060CDCF45C2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C1F6B0005; Mon, 12 Jan 2026 13:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A466B0088; Mon, 12 Jan 2026 13:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4292E6B0089; Mon, 12 Jan 2026 13:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31E8B6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:24:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C11C98CB1E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:24:03 +0000 (UTC)
X-FDA: 84324135966.03.6B7738D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 44CAA40002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:24:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZEKfiJTn;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768242241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gLOxIDyxhTvVzJuSwvSFZ4MlqhsCFk9OHFtuRb1ESk=;
	b=NNwfN3h0FuQgHmKGxlkZfa0IpDCZPExoEvrei/s7YQ92L64H7q6bajoEA22z3UYvo0k9cR
	682KeqkyZ8aRLbCeuRumcO5Gx5Efv1Z7CKzTg4yKrrKyrVNwEBAhMUZYgu6vHJmOamFeXP
	7YUSb46viAR2DJYa/I/bDsMqRCiaNQw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZEKfiJTn;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768242241; a=rsa-sha256;
	cv=none;
	b=YGEM+We2lKqRyNCfUR4VYrGNU01xHwEzUKl5zL4zPmXdgT7dEOi7LgCghLAGFWOHXwAaCD
	0wY8+4zy8Axxj8iCFAgLAu2LTYFOEh0BG3Mc3J4EjXX/BJ3Rg43ibd7HGwW/KWYtZ2/+Wq
	q58a7NmaBFB4SDuFZvdV/YtCk6BIKRg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768242240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2gLOxIDyxhTvVzJuSwvSFZ4MlqhsCFk9OHFtuRb1ESk=;
	b=ZEKfiJTnSraWkn02MXq0c7Y+LxT7+7G7tlBLiQlje6spKzRO2OSTcYAYsvhND+8n1Tclw7
	JLMuR6ilynWf8EciIlcwTEYwjWhOxKk9/JL05xNaWP21vGdzpiL8VP8B2I+syIMURhFyyp
	5jXXJqF7yiOM9/3n0no/XL9Ho7o0x5M=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-Y5HeCQIpPUa5YGnnDeN_UQ-1; Mon, 12 Jan 2026 13:23:59 -0500
X-MC-Unique: Y5HeCQIpPUa5YGnnDeN_UQ-1
X-Mimecast-MFC-AGG-ID: Y5HeCQIpPUa5YGnnDeN_UQ_1768242239
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-5ec9a4e6cb0so5988269137.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:23:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242239; x=1768847039;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2gLOxIDyxhTvVzJuSwvSFZ4MlqhsCFk9OHFtuRb1ESk=;
        b=wOqXXdYF0fFWLL6fK31XcuT7LcwnajHFg4B0zZd7ba1SnslAprrLkBXA+umjb9CnOz
         Ufm1L+4pFxtUQI86QDJgtawHCy1aOW1awE4jFuOu4oEuVMv0UEjxTaVG1EXscPGjpwfZ
         Kyeglv6X7kO3WxS29o6StZnZJ+RcTxupPQhmaU5TPPGJo9G/L/xGYy3r7jcIKECX5McK
         y2J3PHyXI16b8VkQrHbC8Bz4xEXOWnrrf0tIMzH5g4Qwv9B/ZCJxDJXbFjF+DA6Wez0o
         YeliAtxV6Q2XI1vIsNgBJL2DcgM3HYz1uaxVq6jerXzbuZFUZK+BbhZ7xqD+em8qK0fm
         KqTw==
X-Forwarded-Encrypted: i=1; AJvYcCUNmGAECgaQo5uvL4/ppSLte49MN2sd7KsR1lsLuyVBa17AF6eTw3zYraTuZfwaCtg9OFxBaRXv9A==@kvack.org
X-Gm-Message-State: AOJu0YxUj5YdI7MKSVLxX+OuzIWNMq03jFx5wikfTXvMxInPUbJ8Vi9z
	DjuhUTseC0jtEsB7TFdFxqEgY9zzoiBJRTyn+oqSX+fWGMqsu1+917sYWKMb42DqZ+ar1fWUreU
	vwjc1HcgA7jlEdBcoed7kkM1lH42niEVTizENOwoysnYmqyNPcAur
X-Gm-Gg: AY/fxX7bDtcExB4b8KfPhIJaQYCrJYIAD0KnLqXgy9wsqIp5TFFTsve3hxE54CAP0p5
	3aYs6OR1CIjXDXJJ3nh5MsZscR6ubpgqQRAx9xv+dsQWYJuGjK8hafTbI3J3ARKxd2MCWDk8nXT
	s58qyKs683XINJKjjXnk87oZLRejB7CxariBKScmrZaOSJwCFt1taMMbqdO8LmH2RpJYkAA0x7M
	ZLf5QtUEZLmrVMZM4gHP9QInCX28Vz+Oh02g2cLuMYoZEfMEaMAPYdqxtMvz6A6/rvfhBldnsEz
	ZD0UsyyOg549TkeJc4l6d9Hu8Of9d4desMboYVy3LXsCEn70pISb0y45TDrV/zkv767wVu/aZQC
	xo2vfu8MURt6zwjHLk9vp59OlhgFuvKX0dROiaoffANwEhBJyCAgMcWAn
X-Received: by 2002:a05:6102:ccd:b0:5ef:b5fc:dd4c with SMTP id ada2fe7eead31-5efb5fceabcmr2465140137.7.1768242237195;
        Mon, 12 Jan 2026 10:23:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwmHNbjOkRHiOzASiFvy8qH079mvHRUgTgzybGWlZGH94huRhJ7zei/lWRFsGQLOin7Q4KDw==
X-Received: by 2002:a05:6102:ccd:b0:5ef:b5fc:dd4c with SMTP id ada2fe7eead31-5efb5fceabcmr2465086137.7.1768242235294;
        Mon, 12 Jan 2026 10:23:55 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-5ef15be79c6sm10965711137.12.2026.01.12.10.23.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 10:23:54 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <437ccd7a-e839-4b40-840c-7c40d22f8166@redhat.com>
Date: Mon, 12 Jan 2026 13:23:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/33 v6] cpuset/isolation: Honour kthreads preferred
 affinity
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Phil Auld <pauld@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Danilo Krummrich <dakr@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Michal Koutny <mkoutny@suse.com>,
 netdev@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>,
 linux-block@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Eric Dumazet <edumazet@google.com>, Michal Hocko <mhocko@suse.com>,
 Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
 Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-pci@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "David S . Miller" <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>,
 Marco Crivellari <marco.crivellari@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Simon Horman <horms@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 Jakub Kicinski <kuba@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Gabriele Monaco <gmonaco@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Will Deacon <will@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Chen Ridong <chenridong@huaweicloud.com>
References: <20260101221359.22298-1-frederic@kernel.org>
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SdhCAQXOGH1DXz_SxVB-Tg_mtTCe49Zdpqoq9ml_IEQ_1768242239
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aurjm1edra6ak11qmbckgtqwf1xbc6di
X-Rspamd-Queue-Id: 44CAA40002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768242241-413624
X-HE-Meta: U2FsdGVkX1+KLxxCOUxBbZjzK2WJfB1A5OOYzbLncabIFXN9n3lzdLNXM/FtLvy8HlroSpLI0grrLcJ4kpIyBw2o+ARBnL6f7SCxJdL7OdG85/+NHXwpZ6laJPEu2D74rmRjzH4yV8Ev4+IrX6AUaA8vQmZFOMQg1hpniGPfyvc7rTA9JynuvqLOmSdPn2bb/mBsEA3zc2rocDQPrK6QMGeV/2+xa3efYjHk5UvuxfmWaSveoUAKopALO7kQFjZOEZjDDgxT2Gu7Atsz3wr6wsJK2By6lvD6fShSSN9LR1l1xuX+KfXtkji8w5DifY7XID+yhWY/ei6CNsM3zxX17+ViErGHFncvlBLM/gWW0LwTHxPNrF+KwMIFVjA6RNLmfedku8QGud/v87mKBK2hzI3PhBYgAH7br0iI+hSPwymHFtWuJeb0MrliYENdf3WWY2pnG3RLmGw5EPPKFJiYDpYLlsI0ZlByVHXOqOGxBIbWhB5rmt2BHlFx4FnMrby0aqIVkiksOUQHJH0c0U94QZPwr+W6fJUlqDo4FUr0LEZ5+8gDildcffZ9yCKv7lma+4s5UsZX8XONbqCw7vIOmNZ3WjqNi/8D956S8vUwP1vuSB2ww3ygYRabK1ndssxSXsGn1VTI9g+hxOj4A+SpG80QHX/jiOpjoq/BR4RGb2QCDdhI29niepWX8hEmtVCwpnrdbKUNLIqaJzput8ckba8ldEv3E/p9E+70LZixYk977fGECXy3Rde/qLgaXD8BXRdY+HKF7cHiJUMy+g8eGYA0Nk3tFs2ON1Kqx7rBH1jpOui5ll5FUmrBENJnP+/+ZVa+/IreNvPUlonNZfxFZbqefa5nyyTedxPnjJiLC31i4m0jvjyJwsXN5LsLBwBw2akoIXngyjB4PsEDlcSKbX6pZANvgxPMHkyjL4mjkQyPsfkg/DktGCq/zhaEgnp3eSWmweVnSUfoIOfGcSs
 TVyxfRKv
 b/EOf/XZjZzYUDT0DhzKz8sxesYNV4EtjqsT773tYkJsIhMpoqcLXkaaO23ht20v2I4h2N3Ojp8j0ifzB8ekpnlqVmQ6LsJapB+8vx40FYex/IlpyeRjHTMkPgm9hIA0GFcSp4T2l4mh2AxcGwhc7EdvplJ1pzN91ZmKX8e7dmmys3JQiGerr7ZkefcZyBmWuoUpWX2SUgqS7Yk4DkuFtu3qLFFhxs0yI0qfocXx3Mn+X+HAE2MlJw8GjJpY8szIFEu3QGXoRxQStMybwRtP/EiL7n5RrhlCIfYg9tpGASi3BAx8E4sCEeTevdXF2SpUHFtPTYR/5fX3y/+LJ6wyvrbae6QVRLk3dN6qFLfRadCtL8dTiAbqKGjsbLnJ7Bgo6e/Y3qQ8hXzxUMreJnn9YiUZjJC00boet5L3U6qLoUyYScy0NGx6M5pjD7ShE62KWMhwDQjxEkeSomUW7qJGX7mLicVnO/O2kK8n0ywPraDIw38tZ3o+FhqGLZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/1/26 5:13 PM, Frederic Weisbecker wrote:
> Hi,
>
> The kthread code was enhanced lately to provide an infrastructure which
> manages the preferred affinity of unbound kthreads (node or custom
> cpumask) against housekeeping constraints and CPU hotplug events.
>
> One crucial missing piece is cpuset: when an isolated partition is
> created, deleted, or its CPUs updated, all the unbound kthreads in the
> top cpuset are affine to _all_ the non-isolated CPUs, possibly breaking
> their preferred affinity along the way
>
> Solve this with performing the kthreads affinity update from cpuset to
> the kthreads consolidated relevant code instead so that preferred
> affinities are honoured.
>
> The dispatch of the new cpumasks to workqueues and kthreads is performed
> by housekeeping, as per the nice Tejun's suggestion.
>
> As a welcome side effect, HK_TYPE_DOMAIN then integrates both the set
> from isolcpus= and cpuset isolated partitions. Housekeeping cpumasks are
> now modifyable with specific synchronization. A big step toward making
> nohz_full= also mutable through cpuset in the future.
>
> Changes since v5:
>
> * Add more tags
>
> * Fix leaked destroy_work_on_stack() (Zhang Qiao, Waiman Long)
>
> * Comment schedule_drain_work() synchronization requirement (Tejun)
>
> * s/Revert of/Inverse of (Waiman Long)
>
> * Remove housekeeping_update() needless (for now) parameter (Chen Ridong)
>
> * Don't propagate housekeeping_update() failures beyond allocations (Waiman Long)
>
> * Whitespace cleanup (Waiman Long)
>
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	kthread/core-v6
>
> HEAD: 811e87ca8a0a1e54eb5f23e71896cb97436cccdc
>
> Happy new year,
> 	Frederic

I don't see any major issue with this v6 version. There may be some 
minor issues that can be cleaned up later. Now the issue is which tree 
should this series go to as it touches a number of different subsystems 
with different maintainers.

Cheers,
Longman


