Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BC59CAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 19:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5568E0002; Thu, 25 Sep 2025 15:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DA38E0001; Thu, 25 Sep 2025 15:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C218E0002; Thu, 25 Sep 2025 15:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 771398E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:35:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1143F1A04C1
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:35:13 +0000 (UTC)
X-FDA: 83928776106.09.6C05727
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E54E040006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:35:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V0OA8pQs;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758828911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJwwywmn8MlVeferLmRGbOLpNjhdj0h30dn2f1aSujg=;
	b=YxwdsY1GpGncxwCDXwiNOMeKhT1ZZ+TUpBGApxLCdhTDmThhR1LmrtnJI+1fggGx7DiNpz
	X+k+YIGy7f7ijiuGzBBgveIl+bw1+VoQnW7J/EEJYVpP/6M0X3kVfcBC50orECp314B5lq
	WH+DNYSFZd3//FymTu33MFBv2MyIBbw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758828911; a=rsa-sha256;
	cv=none;
	b=ZnuwGXMKD0R2RHT/nN2VeueooVzUyBg6EaB7+wsgu9wuLa/T4b6eosXJHmm9qsFfhpxDzj
	j97gj4DhiUD04SI/fvdFXbXGHIQPdzkm6ATNvKmpX5kWrQz5rvDNMZ1/i1R49i0kQhqNDS
	EgYPm5kaDcR2+lGE0aj8Fofuxe4qp0Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V0OA8pQs;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758828910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VJwwywmn8MlVeferLmRGbOLpNjhdj0h30dn2f1aSujg=;
	b=V0OA8pQsRJu2iwwv3QXtn5Xj4KNfVUWs1zLoEncvcEPaj1Z2xjMGlLn80CwGe6eeayKHBS
	yOGUyoyqxPpG6MoWd4TW5FzUbGzwJ0RYM/8JAVtnQlbx8tA/V6HvhOHveKLn8tl7yXZWsi
	ZILcwXfTVMdCfs8OErYzK+vuRPm1yws=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-9xTRVrPePCWoh2GH5LQpFQ-1; Thu, 25 Sep 2025 15:35:06 -0400
X-MC-Unique: 9xTRVrPePCWoh2GH5LQpFQ-1
X-Mimecast-MFC-AGG-ID: 9xTRVrPePCWoh2GH5LQpFQ_1758828905
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e25f5ed85so8676715e9.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758828905; x=1759433705;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VJwwywmn8MlVeferLmRGbOLpNjhdj0h30dn2f1aSujg=;
        b=Ic+Fn5dpnVBS+gKvwR/cqSvo/VrH6vj2/UUdM28Zq5dAfydTwvMIUnVrvDOY2SSXfW
         8i4ZvDqMsZbyEotK/HIbj8m26bu6oyQ0ie7XJcVxzYqovFvAm+GHcX0S7EpVcgER8WAb
         1HQSUpKFMA0RY6+vFcBKjRwMecSlKxlwN9u2kOqzr+iy5qHyTaNuceRfSnAkj9wqE5Tl
         djPtOOH0/7H6QhCc/G7gzT6881X2xbJU+GNOSwHWqhtJcGETz2K8mISnw0mQBYSRTVeM
         PUQnosjhlvCDSLnV2I7MZZtJeka3LfM/+sSNOiVpqLqlRbRRKBEqpn2lrKu7bJb/204/
         SA9w==
X-Gm-Message-State: AOJu0YwqyaW7lkcjQVCOkBItj4mHzJGhP2TwDPeH5j9ID9zuK8V4M6eD
	WSqZ36OmqphioXoT9Q8Ph8GORkKUvowa5EKqCLehllua4zC2dTNG/b3jdXwCtx4qLCUUlhYtGNM
	p9hX+QM/bP3p70DJzapvl5riB54t73kJoOBBOcmGk1l24eq6+9/bB
X-Gm-Gg: ASbGnctnForiegNgakDxMNAL6am5TItJWGNok4tq6S0U6R+Pl1+HxiUBejRkXqXhbfJ
	1iMSmsgP1zZUL7J5jCHiNVXYR+GWt/veEZpNkdVF02yCmPVIYNu+eiKWo2nMmFZbEhWH/diMG6S
	y3pYpsYCdjHeaeSqZBhHQCax4xl8tI+t835irO0wFB1mZemRrnGt7VkUAPGMovKTD3EzzwE+l6C
	IqmKk78kwoE51uusfo92FsMNr/82CEy1EkAmr+A924DPlmrtIxunQ7zOmng/zErn7+4D4N0byTa
	CVoN9WZ4zZiOsoLphG2vo0h+rqf8ORHiLCVCeYn76MhZkGGvVFPmnqIp182Nr7nEWGq0KdDoxb8
	kLSSqFFS7luho/epmFv7I7//m0m9PM9gcZR5tlJ3G5PkNNhw02yVH5zLGicoHVOJxvTDH
X-Received: by 2002:a05:600c:c04b:10b0:46e:2d0d:8053 with SMTP id 5b1f17b1804b1-46e32a30481mr40382395e9.18.1758828904935;
        Thu, 25 Sep 2025 12:35:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGd82MPk0+1Hmip3UQRbBk+SH7Cq3z6WmT4cbaRtBd04WMOf1YdLsAcp6Q0b+Vu83a2w7bdQg==
X-Received: by 2002:a05:600c:c04b:10b0:46e:2d0d:8053 with SMTP id 5b1f17b1804b1-46e32a30481mr40382185e9.18.1758828904542;
        Thu, 25 Sep 2025 12:35:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9b6e1bsm99082945e9.10.2025.09.25.12.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 12:35:04 -0700 (PDT)
Message-ID: <39f22c1a-705e-4e76-919a-2ca99d1ed7d6@redhat.com>
Date: Thu, 25 Sep 2025 21:35:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
 <b041b58d-b0e4-4a01-a459-5449c232c437@redhat.com>
 <46da5d33-20d5-4b32-bca5-466474424178@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <46da5d33-20d5-4b32-bca5-466474424178@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZULXtur0MlWqKB-ngo3NHT-TZ4BvGbwH3XJIgbCsKNc_1758828905
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3eyt9zsoqzzmgpecw4toghfmd13eyxp6
X-Rspam-User: 
X-Rspamd-Queue-Id: E54E040006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758828910-847133
X-HE-Meta: U2FsdGVkX1/vHxLP/G2ofquyh/M8irphIeYxV39RgaJdlfIGM0Nkpe4aEFcHayYBPGUtT62yaPmcy9eAR6doo9eZQj1Tkhrd3hnfl5v/WNG1us+XjFGUyO2f56IHtHfBCJwuh9at8k6CpZei2Ze1Of35gfqKSf0A7KJaGkGZXZBXTBWzhk77TbL4meUXx6wX3KaphzKSdl/Ze4LUiaKr0XH4ik2GzJ0ogc1YNet5oCqsae0d0lJnZ9zWrVTojHb90VqOoZbjF4jJY9hbtwhp7CHFzrVao+a+jKySONDJCOB6aePZou8/T4ficopVE4yO4YBsNVeq/lqlN0Hr64P9iVXixEWaERtjUrawGh1TOy7eDB4MqlyW+W/DYygMYYvOUvqk/SBNiV1hxiMRN1ItVCIJZD+lL/tARWmZ3DEOloVTkNii0vBABrUn5jaVlmxVaUuvZHNcAlRKI8+ZAh94yoETvMumtishioAo6UQG1DVbImXFCy9oKNnV+yLT0yF/nPmvrrKGH8PMqOXfU1RtKiZ13nUDcRLDuEX3wyK5jngDm7s4pXM5IJQ7ctey3FKToYg4qKuaZanYh4AWzvgVncGIKGjoNN9jEydzl57U3bJ6A/FCCiS50nTSWjtJd9OHLwjR4g2blDv3ATE6WYHZ5gM2MiA+YjhaBSVe/HaZhnUWZ8hhzPj65hYswimXDAPvP7jIUKa7s9+xVVxbY2Zynfrq4QdSpdXoQ0prQ/FZG4U5vl0qTWvHDpR5EqOk1PAvgW/bd2EO1ODri/GEV/vvTniPMqw2oM7uRS+iuPxKza6iA70eIZUbvBahWVBRBz+sIxhmKuzEMrDDNBhOqGr5J4r/WjsFOcrKJ6oVloEq57Wbu75lQj9yMmo8wWkKJIxmMupqL1/ZVqyB5Sg89y4LiEID2Exbmn2Fx+LCLiSqJ2tmVsAHVMMQU0YSRfG02ag6Su2De0nQNXQlURPmDEa
 Yg24+auh
 6dzYeBjZnAU4GPTVBCQ6oH+kNagIEUFwAnVQUNroUcm3+xp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 08:11, Qi Zheng wrote:
> Hi David,

Hi :)

[...]

>>> +++ b/include/linux/mmzone.h
>>> @@ -1346,6 +1346,7 @@ struct deferred_split {
>>>        spinlock_t split_queue_lock;
>>>        struct list_head split_queue;
>>>        unsigned long split_queue_len;
>>> +    bool is_dying;
>>
>> It's a bit weird to query whether the "struct deferred_split" is dying.
>> Shouldn't this be a memcg property? (and in particular, not exist for
> 
> There is indeed a CSS_DYING flag. But we must modify 'is_dying' under
> the protection of the split_queue_lock, otherwise the folio may be added
> back to the deferred_split of child memcg.

Is there no way to reuse the existing mechanisms, and find a way to have 
the shrinker / queue locking sync against that?

There is also the offline_css() function where we clear CSS_ONLINE. But 
it happens after calling ss->css_offline(css);

Being able to query "is the memcg going offline" and having a way to 
sync against that would be probably cleanest.

I'll let all the memcg people comment on how that could be done best.

> 
>> the pglist_data part where it might not make sense at all?).
> 
> Maybe:
> 
> #ifdef CONFIG_MEMCG
>       bool is_dying;
> #endif
> 

Still doesn't quite look like it would belong here :(

Also, is "dying" really the right terminology? It's more like "going 
offline"?

But then, the queue is not going offline, the memcg is ...

-- 
Cheers

David / dhildenb


