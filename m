Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47A6CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED4E8E00C1; Tue, 26 Aug 2025 05:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E818E00A8; Tue, 26 Aug 2025 05:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D2B8E00C1; Tue, 26 Aug 2025 05:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A32428E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:52:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57F6D8474D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:52:14 +0000 (UTC)
X-FDA: 83818442988.18.33A54A7
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53465140008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:52:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X70nCV1I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756201932; a=rsa-sha256;
	cv=none;
	b=iVMZanlo1TOIPMF2JV3mqqG7/q6T6MVRCqy1aF9Jj+i0B9B/1pOqr8KdfWU0h4U8kaL4pY
	cr7ErOvaevaswLGNN689iWmyWkKsK2gv2qh6q1YmMw8EvC4ghtP6PqSgRW+NQPjLZRNDGY
	DCNedhTxLD58O/8Xde3Bc3KxbJC/iEo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X70nCV1I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756201932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zINnuaBM5jY+LnKv0RHMN8aDv06gHxZMWVC8kSjaf9s=;
	b=bSSo6H2x9Vw2ZZBvOGLOujpZAMMkYgo8Gd9O7551jr2VSii+gir7iQnD7Lj5P1SnxFAcAP
	Vqd4Q5yy/J9Js1kUYhIOr3w05zMGv1J7Ol9Hsyb63BajS1Bd1f/YQWLGAtm0XKwC8RbMxa
	bGsHhIFgJaiJj935jf5FmdSuMQN69JE=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3c68ac7e238so1827933f8f.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756201931; x=1756806731; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zINnuaBM5jY+LnKv0RHMN8aDv06gHxZMWVC8kSjaf9s=;
        b=X70nCV1ICdfjAkRL6XU4FQOfpxaqLrD3I9UK1l0Q+k+hogUrH7+BpZ2Rtd8FgZYHne
         CV605/WL7X2lzS0+lYzc0HE3awetx2gOBdoMc9Gjnszvus1/a4wmx+0lZ0E53BRQNK6J
         ZZ9VqwmpVaamFOYwXJKFh/PNLitl5R6quHGLT8XQa7K7GfZwxBtekkT5FIvRtMLF1o4U
         36KSr+slExKxzxI4cGE9rGWWzPPprfBb+St2I0PlfYN5E37sNPu/1jGrqsPaP5WYt3qe
         ilYMZWwVFuNinWH+gRIqtSnXYrcnNIpEWJ1bhZTkIwfFGXqeUxVDGEf9cj0ckvVIbfg3
         Zftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756201931; x=1756806731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zINnuaBM5jY+LnKv0RHMN8aDv06gHxZMWVC8kSjaf9s=;
        b=c3CTwubSjaNnzjB6iRxMW7Pt+bc7kf7XSFRIEVo5Wxn08O/LKSxgt196XSEqg7OOBb
         +dLi5vRRyszonbm8rcIuCEa2J6HQRsr9jOqn3BgqpCX7X4OrOdNiPUThlPxdHeFMX/F3
         HJ/l6VQE1RjZ4RLRtCoLG01JEXcf91+94NW+d7GWXmCFC48BDI0Q2yeXBQZ9p3Zxyp1I
         OjGGcIVnr5bYNeOjTPDl/B7YMyJXDdpV4frAN67vzE/xGm9qU6GnoOuXF0MJz2xT3Pwd
         6saBkS21ze4qaVZD4Whh6Q5nW6PN/OeBJxzAy8lag07N5vzpIODaKK1MYa2S6QLC8XTP
         u6qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVJOE0XT2S33k48Q0UkGhDBk/BU/rSkjCVMINNB2bgTvKRkuKh6YlmKrSSz5OdXx9mF0qZpbAAtQ==@kvack.org
X-Gm-Message-State: AOJu0YwsEx8wGMSKjpu2LorCoYBK3kFc+jGZ6MOCWu10Esmr4aDGqqnb
	hn+4rIK8GRUIa9IUuN9UZ33tMuM6S1deoXRmP0D+AVjZbwxW39nsc86S
X-Gm-Gg: ASbGncu8UihBCHXeH50GzULITu58HPznQNXCJZg6/lvJl1bTpsl7O8vpEh74I2FqN+Y
	YkzfFanxxPt1F5O1T1Zwhi0vC4DJYcbcqD8w4brJvP0yHEewO9ku4MObd1PccDqulntscRVCAiG
	MgnqZKFlmQNN09tH/y0XV9j5tHg913JE4nPRInD36GRBTDEL+yl81D9GYdo6XaN5Cd6YEnOwfVg
	GZHgR97auahfVLydpc3xlFNqKMGLWbyxR/NoQi6C883QBwbubAsRQmzv2sd1iHOxQB9tOtxafBi
	RCBHWfXLoBCGRqnOAbsy7BJdR5ONrslO5SxSB/hQ7VBH4v/bWfMSrj+6ewZoYwhNrykCHX6C83g
	qFcOLP1x6g6t5nevvBZFAOhwUSQHI6IKvbkO+Daztj8hhlxqZejcRtl1klZ58fKpp9UTIt4o=
X-Google-Smtp-Source: AGHT+IFKQdWy6VOJNLDLaTKqGDmbcvShGmfha1Y5OVvRHw7Jd/2Y6z+QukXL8SXmZ752TF56eRlH0Q==
X-Received: by 2002:a05:6000:188d:b0:3ca:c607:ad8a with SMTP id ffacd0b85a97d-3cac607b234mr2794959f8f.57.1756201930397;
        Tue, 26 Aug 2025 02:52:10 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::6:c6e2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57444b3asm146358405e9.4.2025.08.26.02.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 02:52:09 -0700 (PDT)
Message-ID: <ed4fc853-97ce-47b3-be80-4de9627c3276@gmail.com>
Date: Tue, 26 Aug 2025 10:52:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 mm-new 00/10] mm, bpf: BPF based THP order selection
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>, Yafang Shao <laoar.shao@gmail.com>,
 akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com, corbet@lwn.net
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20250826071948.2618-1-laoar.shao@gmail.com>
 <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 53465140008
X-Stat-Signature: jt1r7xaf3quqj4wbtfed5w8ncj8frwmt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756201932-716425
X-HE-Meta: U2FsdGVkX1/MqV7Z/OWq3Wg4M23gIUkSEFr6Q6oIEI7Pb5KDWtNaSyHF1ru94kZCvdPpt3b8U87cHItLgHsRxcNZcV7yAZdUipfYn1SEi4NvbKBceKY6tiMTNgniTTMQbE2uDOFY+H/yfPWVC+AEEkHcysNL1gHInqSF7BspSztB8tnCPC+aH+L//7LNs+1/Mfy5A+vFYTTdzsNp7b9lvUDqYz4n+fiM/z7TV8SHhCrv0t3z9F0h0lSSK07rEuOFnyJQWSPoWs4rD+TsnE2r4RDp36D6qcORznEx6GTMKbuEMdmztrSCjfs6/hcn0F2AZ3ZSWyUDAECmjeSFFYpANkxBCtAJ66dpBWmcQ0wjyEKBrytwSj3qLHluMfAIyNbujdq1SKXVxcldVBeZkvwFSD8S0dvf+GlNccfsFzYuIQsqm0TtdqATi21fapeeHjBQLid5Ef08Ita1QVvYVJ6MSU1cRQIjgVr6ecHRH3/gEYgc8u07gEFvAGxrpCVuupFyiJUMblzAl9jBdjpob96krHuy5GUzqGFnvdhKIW5ZoHJw66Mqvec4EH3impoSL8ac3tugkHVPIaDrlJLyJ1M1Sh+7+dAqb/HfAHZYteqxYH2AO8rrpaQM2OfkrimTgWt8pRQhkjWoziah5ZPVIlYN9LbfpLhqlIZNu2NBZYDUOH5sYgr7aj/8LNxgJyPpcOhiAzxh1Ja9zbzuLahGX6U2LiBEDfuI9cot4DcpxwmSZgfbBs9nUyDZa+KV8u5ZtCOwqgxw03jFAUH1R7jzitdHfdCoYCZnbOFMfDzSMVrI54d6jQIQPkbodLOqeCSaJ7WxIWWSjiVjhS9itHR1ZcElGgh3dmaGbBhH/UX2QKTJVGpsgZTTyMOmdGN+eQX30Siqag1uHVf4n1UiReo3lJXGDRF5ykPGvxJ7TDY3ZeRK1ER7VGN4wa74WNMcfVo+Z7IdnQm1Kk5QnlmbQtJY3Qf
 5i3arlPL
 1z5Wa+HmvSsRTOzQv+e/BABYJz+5f/7NXMKnos2q5g6eC9u1WoC4uer2E+twq19fQeU8odW95z6naNvpG/8aBVM13o4xQ/0oHuG965hAVyam0ykdGpwcw/ypY64a3jAJkIkM6IQSy+Qaw4peWXk8bqjlSFiTS2LsVQsIvDkTyK3h4hyN3DHdrcvUYD7o5fdXuBbX627LPzmJuqKhpdSHwOJ7LZEpVF4IHEDIyYRgnEY4u/+yWgZ1QnCj63cqeEyxsURMGKz0q02yZYworCKnnNt2rJetAdvVToAfyuJD6w7VfVDb/gL84vOMBJjZmrLA9zTzYI4/IVtryVRZR5UJuqTnlPhtWIBVhmOOSsi1xkil2Lex0ZGJgTPu0gyHvb/Lr2O/4eh3YaMZBCtJpuYe48C1IqvxZHhrU36CyZT7RACHH5O2zZwGZIcwW66wo5aetgb7dSBtk0uUYL6aNoTWILLOMWWhX7nJMYCZaiituyeNs5P4TaIrATRbVWptW7aR2gx7CbYZ/s8Jvf+cgXRLHxYRcL+tewm2du96+wnPVVtlj++8xjHi6GYnfYAjEOCHrbPNJSoQVDSKzT8vrU52mmzDqqPVqUhv/I4IW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/08/2025 08:42, David Hildenbrand wrote:
> On 26.08.25 09:19, Yafang Shao wrote:
>> Background
>> ==========
>>
>> Our production servers consistently configure THP to "never" due to
>> historical incidents caused by its behavior. Key issues include:
>> - Increased Memory Consumption
>>    THP significantly raises overall memory usage, reducing available memory
>>    for workloads.
>>
>> - Latency Spikes
>>    Random latency spikes occur due to frequent memory compaction triggered
>>    by THP.
>>
>> - Lack of Fine-Grained Control
>>    THP tuning is globally configured, making it unsuitable for containerized
>>    environments. When multiple workloads share a host, enabling THP without
>>    per-workload control leads to unpredictable behavior.
>>
>> Due to these issues, administrators avoid switching to madvise or always
>> modes—unless per-workload THP control is implemented.
>>
>> To address this, we propose BPF-based THP policy for flexible adjustment.
>> Additionally, as David mentioned [0], this mechanism can also serve as a
>> policy prototyping tool (test policies via BPF before upstreaming them).
> 
> There is a lot going on and most reviewers (including me) are fairly busy right now, so getting more detailed review could take a while.
> 
> This topic sounds like a good candidate for the bi-weekly MM alignment session.
> 
> Would you be interested in presenting the current bpf interface, how to use it,  drawbacks, todos, ... in that forum?
> 

Could I get an invite please? Thanks!

Usama

> David Rientjes, who organizes this meeting, is already on Cc.
> 


