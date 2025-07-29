Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85F1C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD4E8E0007; Tue, 29 Jul 2025 05:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D368E0001; Tue, 29 Jul 2025 05:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355C98E0007; Tue, 29 Jul 2025 05:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 218098E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:29:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCB7880571
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:29:36 +0000 (UTC)
X-FDA: 83716779552.19.4AB7D3D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E26B1C000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:29:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IlKkHFSD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753781374; a=rsa-sha256;
	cv=none;
	b=AZ/fXzqKywPy8s5ryq88u1LUu1ULW0ValdsY1V0Exy+e3AVFf5+w2KzfryQOFA66UTFGNi
	MGoqUuQu0wx3NehudI6SdXUzRPOkzuR+tPPnDh/Ys/KesRUwabcvNM3xGnlLH86l5XkimE
	QGfyqVn1TPVve1VoCov2yyd/t3P9HTc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IlKkHFSD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753781374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DMXTaLjXB64t1BDlPj4yYTKhGmLr0woM0Vff2Ca5QQ=;
	b=IIYgTAhM/LI1hgttN4cDXyzW5Dzl6VyMQHcNUw1BxYLIDs10JJ7/762xVyfWJ5TpRpufNI
	OhHyCDkVXpWm5X8WVZnAm4jubwSLOCkzEiXpu2UIkQ+MCIFiKYd5QMsya5E2GbFdi1K5fo
	uCGN78PSTliX1uih0/GE97coQu5BPps=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753781373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0DMXTaLjXB64t1BDlPj4yYTKhGmLr0woM0Vff2Ca5QQ=;
	b=IlKkHFSDxbIbIYBrPJ3IVhEgNuQTwTevV/Fo5t9K41pwJJzPkc0UJqHsE+zufKgVf15BNc
	/Z3Pycq8aVMDGAYqpsq8XzlDPhhK0dkoKUIFVyzzZ1CSXNlIAL5gX9kEO2EZDL/MHNTsMp
	bB4RP2gBh2jf76Ni7WM9CArMPdnHrwo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-2DdmSIssOCKtDBcXbyhrFw-1; Tue, 29 Jul 2025 05:29:32 -0400
X-MC-Unique: 2DdmSIssOCKtDBcXbyhrFw-1
X-Mimecast-MFC-AGG-ID: 2DdmSIssOCKtDBcXbyhrFw_1753781371
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so25603175e9.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753781371; x=1754386171;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0DMXTaLjXB64t1BDlPj4yYTKhGmLr0woM0Vff2Ca5QQ=;
        b=bDUK1BsWAnqrn/4F6+H1GgrZ/WwxFu+Q/6T9o2UymcLTegrXYFCuonzWOQ8CP6+gzH
         z9MPUqisaIXNFDAgJ039L79oGdDBXEs/oIIDwgfXLWH3QZLvb8fBkp4OwcbQKvxCD/CI
         ZHT1v0awI0259vx1X6g1Ujjf2Z4NwstvxkW39hmp4hEXP4nCL0kjCJ9OWaeqnpDzAEnj
         aDNbbnZ87NxSNZyoU7wTYQ5lF7+z4dbfF4T3PiX4DleqDMbpfo/6HgjjhxpvWQzypn/w
         0njDBz20jzEc1L0jSAfZO1LlrYEByaEXesb9vNAAc9nOOD3327uOucOnVApGQwZEi8kH
         83zg==
X-Forwarded-Encrypted: i=1; AJvYcCXqtQpB2HL9IZy7LIyTAuggtiJYUmIBkc28MNWVVmt7d64uCi5tcIRT22IWZ5+rAOiM018DV1aOOg==@kvack.org
X-Gm-Message-State: AOJu0YxrQAGdYEP6iGN24sj68/pvYTBBM3JaMQz8+mMfpjsCHbbcbhSM
	cRxYmlnih3k/zocHTQUrpRAe9Xaq6xpKCV878LrcVO2OD3VKP7tAFFFhpRC5hqKCmK9wH0GXDaN
	Tv+XAqI//k78z1SppuTbierEJumOc8vdx/rlHhbTpXuuskZYV8u/aKcJh1AFjwY0=
X-Gm-Gg: ASbGnctNiEB5z45ho9IpYiGm+xvm0+BrO+jLqn/NdjvbZZyZoqOcgNFDE3DUegMkF/K
	meg7M58lzF/veFJ3sB35PGgH+mTD8zmhe0GGC6dBcF4v5Z0Y88ttoYz5RGcS06NOnaslwTkyBmr
	vb8Ojf4mX9m59hIP78Ijifzis2d+pJFNE/NdvhgSsEKtQz52ip1mr+3yY/0OTsrVWZp4l4L5Kv9
	wmMl3j8ksjf9jJYv3rMyi3jb9MZ8Ri1oc0qJBW/vH29mxgj3s20cEoJTFaZFTUw6oCOJrbd95aM
	6Vofh15m1X+0S06Ut1Xnivo48ExxqZ56m5SGnodqMcwmmKXZ/Pk4FUJDwFIswO+oquCDAKCV
X-Received: by 2002:a05:600c:8b17:b0:453:7713:546a with SMTP id 5b1f17b1804b1-4587631f3aamr135778785e9.14.1753781371171;
        Tue, 29 Jul 2025 02:29:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+HbldFeZTmHrvF5OMPxooJGH3Eh4A8z0/BnqRdzXbm2pabTWwUjKXw6MBR+oUzq7pcH/m0A==
X-Received: by 2002:a05:600c:8b17:b0:453:7713:546a with SMTP id 5b1f17b1804b1-4587631f3aamr135778545e9.14.1753781370716;
        Tue, 29 Jul 2025 02:29:30 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4588e5e6232sm16822615e9.32.2025.07.29.02.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 02:29:29 -0700 (PDT)
Message-ID: <a9e524af-baf4-4da9-938f-5da71cfbd769@redhat.com>
Date: Tue, 29 Jul 2025 11:29:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Michal Hocko <mhocko@suse.com>, Hannes Reinecke <hare@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de> <aId16W4EaqjANtKR@tiehlicka>
 <3e88642f-3914-42b0-b864-4ad374b659b5@redhat.com>
 <ac7add36-808d-4883-a09e-ef1bf6fd6834@suse.de> <aIiSEpQhWqPsvaST@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIiSEpQhWqPsvaST@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -Ygxmw9wAtTHI-c2jZ7OYl-W-9JzxYBGi7eCpAvgP58_1753781371
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eycqcquhni11m5u9fc1px6e6j3xjcnky
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E26B1C000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1753781374-147235
X-HE-Meta: U2FsdGVkX19Q814iEcW+mRZS6rbAN54ZiqyoGzhmH7zAE/0YfL6UyDTwtYJkdmJIKe7g7TskRBflDFK/4ze6eFWkoDS1+U9YPwGarTPktYp7Foid/klKrErnhYH18U2IeSs6GCKLMsKcFuMDkQERY9J4jQWb89U52J8GLUC2zqBQx8xt4CL9BQ50VY9QN9sAJRpfqUoKwoZ4VlOpHafBeUztdoxk033j4ye0dHizkx4liSW0OwW5ZJC7+bvnOEvNyoYqNs6gIdstEoWAGPFq+vhvtYgEXAjrZ9nMgMSQd26IgxzfojZjK+2WO1klpZ8SB+KfpQMkPN/a6HICBRNStskgcg9Zs+5WxycQf/CG+zIlfbhglPCi9ajhtITZ16zY+0evX28ow/XsAuXXVzmgVYr4v44bhy0tnkRoSRULXNoMVwx13sQC0NegJNoSx2Jja/OsBuyDKJHwKD+smQ1UOaJfY9PWBlybjKPmX9cazi1jUlTDhe46asgXpqmJEu6+IWTXHeX4ZfQuVrNZMBbwGBbefcjPpT5dKRyBHh/qrEKHhEzKsJcrxjW2C38q7o3UfNogw1pepoC7usMBsT4pGw27h/ngRxY5rRaUBQBHjtNZO2/wEAVUeJj8w0cME4kahe4LmSs9aRY4QsboCsXdnh9cTlV/Zocx+0Q6Eqgw2MlIXinZIa/5FtFPAY1GqZJe2z8pJOHtB4a/fWr0UxO+V3Y0QhXkX8w5LeQxdPVriLuDCnb+4kYbRp0mytIfpsfxxcH8pEqnX1rGqH2SEci3AY6cm+/UqGeOjZ2sXlWEsvpTq0zAi1gKKspO/gfUSUgwGIPo2GbO4vxfCHz666svWCCuoSPSaDgutGqSN4coiRMG7Y0nAZGTRTTMsnwJAewDOr3645Pb66dg3fiyr5lgmLCMa1qjVI3oRhaHCo2AJqr6tLeNHbdv9EOIUnbDvBc0LN4VAKbhjVej4e7nRNO
 rz5J/H0P
 ealzepcAFKv2vjBpZhHMoV/SfuscHnfsmN5FDCP2HQh9alCHDIbCV2XZ3wtJacrudVpd0VALoecZyYzSJKR1Fs3Qg/6TcfSeIbpouynmKlSvvLxsVDvfSFLPN/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.07.25 11:19, Michal Hocko wrote:
> On Tue 29-07-25 09:24:37, Hannes Reinecke wrote:
>> On 7/28/25 15:08, David Hildenbrand wrote:
>>> On 28.07.25 15:06, Michal Hocko wrote:
>>>> On Mon 28-07-25 11:37:46, Hannes Reinecke wrote:
>>>>> On 7/28/25 11:10, David Hildenbrand wrote:
>>>>> And to make matters worse, we have two competing user-space programs:
>>>>> - udev
>>>>> - daxctl
>>>>> neither of which is (or can be made) aware of each other.
>>>>> This leads to races and/or inconsistencies.
>>>>
>>>> Would it help if generic udev memory hotplug rule exclude anything that
>>>> is dax backed? Is there a way to check for that? Sorry if this is a
>>>> stupid question.
>>> Parsing /proc/iomem, it's indicated as "System RAM (kmem)".
>>>
>> I would rather do it the other way round, and make daxctl aware of
>> udev. In the end, even 'daxctl' uses the sysfs interface to online
>> memory, which really is the territory of udev and can easily be
>> done via udev rules (for static configuration).
> 
> udev doesn't really have any context what user space wants to do with
> the memory and therefore how to online it. Therefore we have (arguably)
> ugly hacks like auto onlining and movable_ration etc. daxctl can take
> information from the admin directly and therfore it can do what is
> needed without further hacks.

Really the only difference between daxctl and everything else is the way 
the memory is added.

daxctl triggers hotplug of memory synchronously, everything else is 
asynchronous.

On most systems, the admin (the same one that triggers onlining) could 
just set the auto-onlining policy accordingly instead of manually 
onlining memory blocks from user space.

> 
>> Note, we do a similar thing on s/390; the configuration tool there
>> just spits out udev rules.
> 
> Those were easy times when you just need to online memory without any
> more requirements where it should land.

Again, I don't think udev is the future for that.

What I think we (Red Hat) want is a better and easier way to configure 
the kernel policy.

If you want to control onlining manually, then disable the auto-online 
policy.

-- 
Cheers,

David / dhildenb


