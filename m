Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF812CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F378E0015; Mon, 25 Aug 2025 08:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F848E0001; Mon, 25 Aug 2025 08:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE1F8E0015; Mon, 25 Aug 2025 08:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A779E8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:08:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 578FB1A03DA
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:08:26 +0000 (UTC)
X-FDA: 83815157412.19.8628DBA
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9163914000F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:08:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KUSYqSs4;
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756123704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djLIMBABOQ5QMilKv8RGXgyY8Eozctcb9yd8r0Ea10E=;
	b=fIw9wdnhPLgWkKFfjz9tGR4O/jlUFKs9n8pRVv4Z1laKC9c+3QpvImA7d+YNdK/8NoENPU
	1mu/fPXxZbXuK9LmMJwKkWiPIV7LQNZAD/NevajpgKn8MuEr6cd9CSg+010Y2wCS+vZ1MK
	2oaMxihj6QiBmJCKdTWgoUgZwLVNE2E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KUSYqSs4;
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756123704; a=rsa-sha256;
	cv=none;
	b=x9Pk7SkfULhY5h4up85r1TYQOUpdpaPs+yoPPjQglYWUDatfBUZePM3ufoErss2Nv2uG8n
	496pPycpfSmu9yxFS1vl2fnmbLZZxxMEzi1772eO8mfgkrWq55Hvor1Eb1wMyzrQJiibTW
	u6bX4R8bDCuATOhfByvpWmr2rqVOGlg=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so3699831b3a.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756123702; x=1756728502; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djLIMBABOQ5QMilKv8RGXgyY8Eozctcb9yd8r0Ea10E=;
        b=KUSYqSs4gez4ehcbWosb5LCgHqrX39vXLjjmssI5WN0/VCdyHNeUbzuvtTUrchhTXn
         Bn/9qkI6HeHsU1nVmOlD/AB6zC699ZEGzksESbjhiBAMty26UatAhFjVBUlPwkBoY2Bi
         4SZkeEBVfGB7zahg+f0PZ/DZ+hlOpg/hTm6yecpv1owx5ZU+YfM1NcsAW2kd9MRsf4Jl
         fPmV40XHFCfvUDaJisnEOG/1+/tC8Iic39LbJwTaYMVIxfm4ne5yhGHgvPLHVKHh2WfE
         IClz6c1a35Q3DMsY0nCdxGjsF1mlpIv76rSVdhhqHwlM4NjSnAcdu/sH8wIVzKU0Cx7g
         HyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756123702; x=1756728502;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=djLIMBABOQ5QMilKv8RGXgyY8Eozctcb9yd8r0Ea10E=;
        b=aZAEgFKSs0kIpIdqAG1qdrg36ACxpbvHHgogViM2tt8m3fcwtBBveo7LJEnYiKu/9W
         v4E8CdRMZVzrSqZAGZx1dGlL12paB3WGYHlMwa7LxN1MLpEtIh0DbkUyVKYrk8Q93DxX
         1Yal9IP/wPz3Qpr/0HzSxEGydUYt8p7iwj2V9EHKY3a1zaUaRQNpi+48NLKViLUJM6M+
         VJd2lc9DraPn0U/y5ezT1vAf9bZr2qRHl2VVP/nyzzeRBpp/PIw4MNGYvxu4wuxJ9bZr
         8HZwx2YSjIdtXndBpvSxbfLyf+hll9ZXrmidxANVhBHBnMypXusV/NVH5jwS1CenzojG
         6Vzw==
X-Forwarded-Encrypted: i=1; AJvYcCU5wRfr3d0MjsRDU51U+9d+WVZoV8dYRcRMVsCcU4JSqUECMcjyJWIPCOsjgklji5EfAjmjt4SuGA==@kvack.org
X-Gm-Message-State: AOJu0Yzoh5WSuB8dA50h1sR64SAVChXIAcswXQ/2MKE6mvMeCXKqDJqu
	2qEFvDMracsm9zsjzkSvYiN1cJQBAIWIuqwp4qGHVVp/s+MdeIhBNYltHyooYyxCxfU=
X-Gm-Gg: ASbGnct8qZJxodpARVkn4CHTdu7FSQaZXPrZAaTBVMuiMKoQ3CpBwLh7ijzXiyAbAMc
	+jXebHV2ITBaxm23ytI9p0Bt36mN6o1EnIIprreU4LVhrzJxXMF2lzAvTPlRZx0IwHIRmujxeOW
	u2PlVdpj4ieMHXG/7qYJ6YtwGt3K0kiIlzd13LmY5E82MTnyyQBgi22Wxr71OXzeYmsjSpuxVOG
	ehaOA2iGaEcapE4mZ7YWi5TjpxW76sbY7TluzjLHDp+YcDME+oBqWetCJinBAr3qXbe8oG1+ut9
	Sh7jYkrw2HTNNfdbNc8MulGrZbeyyKfqkzIg0E3D7WCFJuXsovi7bFEKk72rHBzFBBxXTx8+cwj
	Zc/CBtZqX4THNiAqIS3ESV6KWpLMJYGAYlK88NNnCW/ayYJQ2OoCnfKEVjEX3SVFQhNMXPqM=
X-Google-Smtp-Source: AGHT+IEANcNrkMuJ1PjBmSdPjmdk9y77EAYoFZYgAnfWDeZy+q3lUhQjHBWmnTqj+0/HSjBZ/qdDeQ==
X-Received: by 2002:a05:6a20:5493:b0:240:10d2:adf5 with SMTP id adf61e73a8af0-24340b57600mr17869147637.2.1756123701840;
        Mon, 25 Aug 2025 05:08:21 -0700 (PDT)
Received: from [10.88.210.107] ([61.213.176.55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f3818abfsm6684739a91.0.2025.08.25.05.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 05:08:21 -0700 (PDT)
Message-ID: <6d54e933-5ff4-4711-abb9-96d39a5dd62e@bytedance.com>
Date: Mon, 25 Aug 2025 20:08:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: Don't wait writeback completion when release
 memcg.
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 axboe@kernel.dk
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
 <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <lvycz43vcro2cwjun4tswjv67tz5sg4tans3hragwils3gvnbh@hxbjk6x6v5zk>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <lvycz43vcro2cwjun4tswjv67tz5sg4tans3hragwils3gvnbh@hxbjk6x6v5zk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9163914000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bjzpy896s56kjt5ep3inm13qkwgndo4z
X-HE-Tag: 1756123703-448260
X-HE-Meta: U2FsdGVkX195lHU4SUTgEPgZIfbQXmm4kPf2nL4kf9TwSaDn0PTOFspGzeGBHKNvON/TK0TVBjJxlme1B33R2OOJADN0FIbluZ3SfqXYHJcxq9JjM8Jxr9GhJ/VY2OKI6MtfI/pzMDTQMK4MvdTuBsAahvDEwLL3yQfjxcVlxE+lGlGjCcDCGKYK5ChiMhnDVMm6yYmIt5FlBa/K9S+A3XHdF+XZf422Tn/RnWeVoloEKW8Lpa1oZFcvdDJ1AvJqEKYLRbtX16aZitklICrxqXXHxZvR5od1KcFdbM4s/GhAOBrSpn6VtxiIFJER3r6E9OxJBAvvY3AtcBgu7+8XmJ5tljI6zN8HU2mzkxkJ7wGxuF47x/e3ax7rGm1QJWDoGnYqiG9gsjL8maqKhXu4rvZBxPA/ieY1rcKv5DsmXUoP78VmCt+jOVP5306RgpWzKQQ/dEajyMekkfZ+D+/WocpR1F+7rTc5nC0YpckKHuq6QWJ7Xvb5r9lxdd90xNQoAWCqG5MmnaGrI4TFYYPVQhs5wa4HsrCJaFM71NQOyZsJeuFTbhqUZiw13y4eKCqFYAtw8Bkj5SiqG3DSVRO3vqT2BO/WjqsnYvd9qWclIZQAzybmIlWCVrGDpyB/RV1SIFjc7NGWX0X4Dbl1MQJXV9eGtfYgXMSIRlc1G3JAHGqtxTpZtUr9lchYP6RvY01+r8Mpj5TrazWs8LdyG6IlOMQGA+jGMPR1Ko6rG24jDpdm/mNpHOPdIhnXnddFE4TWM9SjBrJnTgXqwYD57u/xvt7pdSm9omaDQ0EEiSaf8IcoCH2ybQx6E5gCvI8pK4zI6B4PIblJVPyA1jSPMXzUKEbadY6qe3rKYbI0a2s6SxXZ0QmHi7YP9zF3fMTNMY5cwLiNMNECYkLW789wxw1fNd2fOXRqF4KpEOcUpQTSfM0uEQm/NNdGL9a+rbLPydUTquMXakwAE8wnHf4tfQ6
 a0PKOVQx
 u+b3AiAIyrP7RSI635PgNmFaQCFU6PQDWnJKLLIAKZNQ3XsNAG3hGEpaoRfl+HeZcFuEeuZ3TTCbzFY6EqrSbJSJFJ6a1lnCMlkKPWb/zVy9vNSF5y+m4uG/TF/Olx5S2smhwCL5KogNPoGwQ6pkLrm844lqMUwlo7IwBDea7ZrkECepOhN4PqBpe5nwNHV1wQ5epjtH5SlYhh4+IR+eDC75XjBNq+W4WnydSa9RlSFKtG9T28eYizmCGHdMo5wBQI8d2wgLKWbb181i4/A6MaUT9BfWSK1AU1Yuzh5FYQkIZrtOzirE+yxgpCjg7AbE23HdvSWB9Y0Gs7c5BDVg4PhnhydMjeLT7WcEqvWxSLHsRUJmHsh5Wb3YKHwxFv2WcI10uvtV1oilhST5DJ4U92k7JJWFAfiCXuUna
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2025/8/25 18:13, Jan Kara 写道:

Hi, Jan

Thanks for your review and comments.

> On Thu 21-08-25 10:30:30, Julian Sun wrote:
>> On Thu, Aug 21, 2025 at 4:58 AM Tejun Heo <tj@kernel.org> wrote:
>>>
>>> On Wed, Aug 20, 2025 at 07:19:40PM +0800, Julian Sun wrote:
>>>> @@ -3912,8 +3921,12 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>>>>        int __maybe_unused i;
>>>>
>>>>   #ifdef CONFIG_CGROUP_WRITEBACK
>>>> -     for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
>>>> -             wb_wait_for_completion(&memcg->cgwb_frn[i].done);
>>>> +     for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
>>>> +             struct wb_completion *done = memcg->cgwb_frn[i].done;
>>>> +
>>>> +             if (atomic_dec_and_test(&done->cnt))
>>>> +                     kfree(done);
>>>> +     }
>>>>   #endif
>>>
>>> Can't you just remove done? I don't think it's doing anything after your
>>> changes anyway.
>>
>> Thanks for your review.
>>
>> AFAICT done is also used to track free slots in
>> mem_cgroup_track_foreign_dirty_slowpath() and
>> mem_cgroup_flush_foreign(), otherwise we have no method to know which
>> one is free and might flush more than what MEMCG_CGWB_FRN_CNT allow.
>>
>> Am I missing something?
> 
> True, but is that mechanism really needed? Given the approximate nature of
> foreign flushing, couldn't we just always replace the oldest foreign entry
> regardless of whether the writeback is running or not? I didn't give too
> deep thought to this but from a quick look this should work just fine...


AFAICT the mechanism is used to make the max number of wb works that we 
issue concurrently less than MEMCG_CGWB_FRN_CNT(4). If we replace the 
oldest and flush wb work whether the writeback is running or not, it 
seems that we are likely to flush more than MEMCG_CGWB_FRN_CNT wb works 
concurrently, I'm not sure how much influence this will have...
> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

