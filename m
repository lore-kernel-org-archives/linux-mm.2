Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6004E8FDB8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 22:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075ED6B0005; Fri, 26 Dec 2025 17:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023666B0089; Fri, 26 Dec 2025 17:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3DFD6B008A; Fri, 26 Dec 2025 17:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D212B6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 17:13:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A0131A0649
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 22:13:35 +0000 (UTC)
X-FDA: 84263024790.12.EF5B70D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD01340004
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 22:13:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RLlGyUwt;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766787213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbQAbHkG6iNX6LkB+q4ATv+TKkhtMlH6KHEacyY50T0=;
	b=ZU7M4U398o7lLZNW7QPLEsSHKiHvU70WOdmuK9B89MptyVb1P3IRulm6yNjfVkul15cVBo
	emEcem1vFLAN/J1PMoTjX3REImgw455pE66pEa+XT9ZlDv5o1Mx4w0ZUD2uuzJyiD98AmD
	wn3kpng4WqSbVt0PqaztUczTM8CgaG0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RLlGyUwt;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766787213; a=rsa-sha256;
	cv=none;
	b=sjOPZUjcgQl1Yjyvd/BoQk1RMbEGpjTRsf/NM2fEvyi6VzcRkSGTCm9rdiYMjUw09Fx8eA
	bVXpWkO+KmDLgVFHWHRqJCI+u+9+RwMr/BejVvXmCsbamoGQ+RIuY9UQCZvxS96LEeFkVE
	0aSd5qE9fbCAySa7mt3ABpVo2b+yKZM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766787212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MbQAbHkG6iNX6LkB+q4ATv+TKkhtMlH6KHEacyY50T0=;
	b=RLlGyUwtYevISZY2BzXkC+HU2I13BJVJnZfdig3vmf1eRamCR6Z5+pBqr9wf1y5Gh76d8l
	uwjAfSZrC3YEokcCIZU7r+bV0UqYuQdTPhGNAe+phYMbNYerhjryR/wEpLw/JAvgPLwK24
	/1qDKqfSCVpV5gLipzIhB33e1BMKU+Q=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-nRWRb9BGMwGjIm-7xV0A1g-1; Fri, 26 Dec 2025 17:13:31 -0500
X-MC-Unique: nRWRb9BGMwGjIm-7xV0A1g-1
X-Mimecast-MFC-AGG-ID: nRWRb9BGMwGjIm-7xV0A1g_1766787210
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88a31ce8214so189891696d6.2
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 14:13:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766787210; x=1767392010;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MbQAbHkG6iNX6LkB+q4ATv+TKkhtMlH6KHEacyY50T0=;
        b=v4ctBW5ADvVlx2MW+QZ+rWIgcCiqS3spRYGUwIcdTMZ+OYgghYWbZkU4JKyN7ICVG7
         PjrUKcecEuySzaQBtRJEQ4FwxT8tHL4AssBgn+Yl/FR//pdvIZRYIQ+CgAqGQuiqyxgL
         DEoIA2KkZMyFtVqLFW3oVssuR3fw5j/i5/AQYR7+UO/BpKqCiE3XiaXEmWtqTDe+YoAa
         y8Q4+oLhopqUeDc1RLr9F+EzzUVnldhanuePOqZ1bUE39UH+BCtyAh29ph6/MY0z1CYr
         e9pbx20hswRY0+75ROKsmjvXzLKPlPmYhViy0rOkcH8AlU8RxThkJEpenzNUYssQ7LqV
         26Lw==
X-Forwarded-Encrypted: i=1; AJvYcCW8mtaTOx/N3dB9wdzB2KBvC4DGcfKgMfQPuVFOU9sSiN8LLI4BDvVBJWpTSZFy9tyz7v4SqEq/0w==@kvack.org
X-Gm-Message-State: AOJu0YwrvjjvMAoASlBgUi3J8UH2/duBNoaI2LHcB6LtYdF9RJ+/MipH
	dcdbelmP9spFZ3AZ32d2TL0R7bDy9aeACDk9t58LSzCKqSbz00S647Qe+TH/WNwxTXE8hTRVFbX
	AH/RusZCUPhPOqQMUXKqgWwWgdzzsLUTbontT173duisBZCQndLQq
X-Gm-Gg: AY/fxX4nHlRzy5+dngy5hnVM84tSXbG9U1Up0Wiu1wDzowaSIOXYd5kUdK3f/KxT6X2
	D3QuOhuif5O+t0zl0fdpNJ0046j3XQgtxprLzz1q+vRgkV2UZUTdHVTSLmtijAtWjnOMxwp1cbF
	oHCdX2Oy8O5eRQ2Q1TnxNCtsiCdJP9ohdBCjHwOOxF9IOvnIz/SbKcjAFlzTjDZcrFDlf2WFIi+
	0aG4NYa9acNgMRnLkY4mS7qaM0gGqdaK8rgeCJVkDIEfxyrqgCGFhUEHPGkvvqGxEZiZ8/B43RS
	xlib7mT0w5iJby4xmS2YcdxJeWF/T8dcOSPMJ5357VCCihtFgXU2LR0WZF7smsVgPiIEEwPsYbN
	mMDa2kbBvSd4ZYLonNqk5x4Ny/+mkJ7i1PVz/JjCAiq3Q5LRJ/9wBT/oU
X-Received: by 2002:a05:6214:c2e:b0:888:8047:e514 with SMTP id 6a1803df08f44-88d81278a7bmr406254396d6.5.1766787210435;
        Fri, 26 Dec 2025 14:13:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEYVLwcCzEd9vRQ5ZAiqiA7WVLjHHO5Pqc++xoxQfNciNGScOhGispLouTYQ6DDT3yyTzTvrQ==
X-Received: by 2002:a05:6214:c2e:b0:888:8047:e514 with SMTP id 6a1803df08f44-88d81278a7bmr406253916d6.5.1766787209977;
        Fri, 26 Dec 2025 14:13:29 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4d5b4c975sm115870181cf.1.2025.12.26.14.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 14:13:29 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <48f8bff9-178c-4ab7-a8ef-7edba9b0e7bb@redhat.com>
Date: Fri, 26 Dec 2025 17:13:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/33] kthread: Include kthreadd to the managed affinity
 list
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
 <20251224134520.33231-27-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-27-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ucwCj4tfnJ7z_WTrChE_nt0_vgR48l4OT1isCWYcgRg_1766787210
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD01340004
X-Stat-Signature: 6s6u6pdcbqk9ykg4gbjhfybxdjz4c9t6
X-Rspam-User: 
X-HE-Tag: 1766787212-126627
X-HE-Meta: U2FsdGVkX18z2J1nTSSMTFHTsmFz9iMaps1QVa8cPWW6Yvkhb/b4yL7T+2Wv6RaObgNPv7pkj+uPAXHPUUuuWk76ea0wMLj3/OUQeybiiICMRQ8ebMluZ9ikVAdBgnabojhQr4tQQvh5rQBofy04G8QHcM1UTMA/DDCYKkB3raHulSgQhCX2/C7vuTlg1STNuM6ZQmf3m2HZvGsVdeEcQDiM9za73LaBHihh3L3OngCPDiiLObxaFbiIPpR9fv8b52/TwCsQqR4T4OUJSO5TL7ErFLd3M5F4R3b6+I79niB38ee+C39pz39Pde1hvMVAqEnMg0uFKs3gJwFkDsPDbVkjoTcMRpIZQk39ytgxc1gUvItgayKysbqQ/22JCJ0d4cf5NPo6bhLM2VCWBNx1L8T6o9ZSvZNclq1bqmAl5zrpBZ7DQ/0LrZ5vhiSB3uhTQWxM9lm+/UxyNkxgBPZZliAlmyS4wzrKsuGL1Ui/vHJFmGR0dyQpa1GO7jaoEopK4vu75LJmkWkzO90KoCjF+DEwEexiOjxlycKobCQSaL1g2oMwQWjrqGeTpa1w2q90Y9C8DrIYiVGE6BwHsywYdyBdHZVuLDj2OTzWkSsh6TmzoJUBJUGt/sOQSq98T7PzMnXRWbSQ/IlqNMaYBhBdboaffopmpRymZw9Ur36S7Esi9sE4AQWr9UdMQBDkOGbfWrqfsMFDB1JmGaxnDcdnBuzIr8BgEy/Ro2voUp3rZ44DOxtTZTrl6rJs6xqOvUjrSOSB8fZkTJKA2LbqOd5ehBiiEzvmNc5NuRFQkYqTsgIettBdZ+VpHWUAGVkHsUt2ZvOoV9zK/whVzNsNKS28Ik7BBApcs26dDMUQKBD5RKtqUn5CC3WU7ml5heq16D0T18e6BM70CRifpzFn/obO12wTcvi2k2tHq8BrAm4B3BYXupG+LeMHk8FryNk5XRXhoKkz2F9zuRMyGH++PWH
 Tj+Fh3lL
 XYIZMu8fXQ0jHaz0hzTylSu/zWyxpbPH34poBMWs6suMIAoMHbX17Qda3w5T6lbQPDypG+k3I3EK5EDMGncMWFJEIrkwW3odczCrZBTlyyWXtUaXlXhLVKphX/2xA3IFliEr9nclZ41IgzaQpH+UE2gu7XM2khlP/hpmkh75R8MgKLn/u20zbXoM0fRQ53po4kQ3yVUcNCKvfF0t9Bq2t4vRNVCop6sYZMyFPbjFRF5sVdZiKpNA/wNsOXG+IphiVfRroyU9o8AAsdaxr/7SPPmn8vJnn1rRkNJp5/js+3yx/NnqaVT3Mimzphnrm2xO34epE+8GeNvlJbLWmT65ucL+2TKzyi3+FTj07CaJBVduGRCLOg5zKpLw33LmRdpAl1u8WZUaZd4REIIb/LxxU/cnLWEhsAdsHntUYkzlD48+lIaF1MUuseXSdZf6SFFPBzF67gn/PlS6ul5LfxVH6USNlHjn4e9Zs6maXLup0su4BYd1uij0rt3q6hTGpO5NGfVTRbTGb/ovkTi7lNxJijoEGTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> The unbound kthreads affinity management performed by cpuset is going to
> be imported to the kthread core code for consolidation purposes.
>
> Treat kthreadd just like any other kthread.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   kernel/kthread.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 51c0908d3d02..85ccf5bb17c9 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -818,12 +818,13 @@ int kthreadd(void *unused)
>   	/* Setup a clean context for our children to inherit. */
>   	set_task_comm(tsk, comm);
>   	ignore_signals(tsk);
> -	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_TYPE_KTHREAD));
>   	set_mems_allowed(node_states[N_MEMORY]);
>   
>   	current->flags |= PF_NOFREEZE;
>   	cgroup_init_kthreadd();
>   
> +	kthread_affine_node();
> +
>   	for (;;) {
>   		set_current_state(TASK_INTERRUPTIBLE);
>   		if (list_empty(&kthread_create_list))
Reviewed-by: Waiman Long <longman@redhat.com>


