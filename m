Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D439FCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331A18E000D; Tue, 11 Nov 2025 15:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E27D8E0002; Tue, 11 Nov 2025 15:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8468E000D; Tue, 11 Nov 2025 15:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC6A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:44:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9EE5C01EE
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:44:14 +0000 (UTC)
X-FDA: 84099503628.09.965B812
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 293134000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:44:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OBufCgjA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762893852; a=rsa-sha256;
	cv=none;
	b=EdlJF9l9B4xh/MrO98SZmGxQYrtiyChQNagTqWFY0ZBMQEvq89NKX9SQ3Y2AUvC3sEq60s
	eFuRGRGnzRoa9ZTjztYDMZbWIBuYMuQ5AJaZVvUrjnz4XmutP9JOv3JwmPqdh53iRpSqle
	gdb1UF8huJcPqTyHblqRVg6KPvLCayQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OBufCgjA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762893852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AouMFoYtS/g71aagKlLU9Deonq3urwuQMJX7R1T1Afc=;
	b=hKeJRPX9VurJUS/WN9FDmk/6fALjVM/K7/SpDF9U5qiESuNLXOhOUd2+4d0DJgHebYRdpG
	Q6BdAlab+u8yP2gCLnCoVeLW2LEuKUfSaEx5iz7uMrGVLse3pezebzvygTt/ttMFQEdEqc
	a+T342Qd4KHbyH0oawzScGtX6WfDBug=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762893851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AouMFoYtS/g71aagKlLU9Deonq3urwuQMJX7R1T1Afc=;
	b=OBufCgjAiPdpFy77mMWSt7drfV9KIUfRyr33ww7za69cdtM3FndbifYiMUlKTpnGZkuYM+
	FfGP5b6+ev8VX4ZnNGJL18phs2ZejB2hno0NuIaMrxFHGTwy6FyJ1zwgLfUFeBDRO/+Le5
	xPxwZD0SPGwLP3h+iXf0ksNAQ3vMgb8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-LiEehJBePa6ivc_jnL5zUQ-1; Tue, 11 Nov 2025 15:44:10 -0500
X-MC-Unique: LiEehJBePa6ivc_jnL5zUQ-1
X-Mimecast-MFC-AGG-ID: LiEehJBePa6ivc_jnL5zUQ_1762893850
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4edd678b2a3so2062441cf.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:44:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762893850; x=1763498650;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AouMFoYtS/g71aagKlLU9Deonq3urwuQMJX7R1T1Afc=;
        b=LbSlNMBhViwYzNArC2ymh4ARw9naOEsIS6ldOHsAYAYnf8fJugwOUinfTk4si/7Qkv
         9ERKPLjQfrQmkFeRKsLR5TaBlrhv7X5ctV3g5Owx2Uf884s9dfkieBNW7WfO7sOLQTEv
         lB0+9LMQOTrn3Sc6mIjSQy7LHPc02CFRo02c97v8g3DQZeTpyiIVAlf3Dv0NBG/59J9b
         Kp1f/AVIz4NcKd+qjKG5G+MUeIFBeoFgtxMlZGKjs5IH2o5XodRTwL4zZMIVx5ydCRdw
         6c8yQuT1c+Wu14hPJg2ZDzYyxOt5KbRWKXcA+dD7+AXVJFKdIK03nMsPwNUUy1MJPquq
         CO/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWEqIybDuSlHi0rGthOdAiir8OFoxreetPETaYz1PoZHbpw4il9GNjpNmMXoAllJquNpF1nJPTXbA==@kvack.org
X-Gm-Message-State: AOJu0YzUXVUc0KcCDMWkspGKMiXSch1Nw2wo+2dFFlFH7luJdvaStCX5
	MXnOY2hLbjVz/9QpcH5NWd73R59F2R28rxrKUbllgTj/VKQNZ6Kwg24UnXtAKnRzYUDmxfAlIWN
	hEb344bDqCrk8S+DqyaDMc6mtF9QvXqN/TMjY9IhRtg3qo38GroGa
X-Gm-Gg: ASbGnctAI5j5Bhm0ELfTpuR6V+w1oE8pSUwxgAsfouwwIDDpT6IsHj6fdSZl4Th48qu
	AL/eAQJqH0wUtgj2LenSeJNtF3VJajdYMLs6W/uO4lC7BJvpp9JCrDqG+qy8UE6+pUGc6CScXhy
	w1zCo7XRdRma95fDd1AMm0HrLgCe/a5HxOVSLPPmwjJkYVKBZfpyav3raP8Y1hy1Ko4QdpNEgIJ
	9e7dk6K3nryXbTgAABDIApOTjw5FKst8wC5iEfBZBJcqaYFRuqnCyK9z3Z2zdrp6bByODi3s8Zu
	1A1EAW0t+oKPT+/rpEhoEccwXfVzSZhWwwf6eU3lHYFNPX4dz0HGK01oA4BGYqvw2tDPATu4iTd
	QVTCx0a+/6ZS/fRAKDxoqGc3k1xdoNGJ/dnoqkqI90Hyr9A==
X-Received: by 2002:ac8:5f8f:0:b0:4ed:b83f:78a3 with SMTP id d75a77b69052e-4eddbd7785dmr8990351cf.47.1762893849851;
        Tue, 11 Nov 2025 12:44:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE61o27JhGsft3MQNQXeIYKNMG5x6jKVgyaMvlVyyB9523TiIR1DvWB2nD07G01lezcrWTZAQ==
X-Received: by 2002:ac8:5f8f:0:b0:4ed:b83f:78a3 with SMTP id d75a77b69052e-4eddbd7785dmr8989821cf.47.1762893849371;
        Tue, 11 Nov 2025 12:44:09 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4edb56e2173sm55990661cf.2.2025.11.11.12.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 12:44:08 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <061cdd9e-a70b-4d45-909a-6d50f4da8ef3@redhat.com>
Date: Tue, 11 Nov 2025 15:44:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
To: Michal Hocko <mhocko@suse.com>, Waiman Long <llong@redhat.com>
Cc: Leon Huang Fu <leon.huangfu@shopee.com>, linux-mm@kvack.org,
 tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz,
 laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com,
 corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
 <9a9a2ede-af6e-413a-97a0-800993072b22@redhat.com>
 <aROS7yxDU6qFAWzp@tiehlicka>
In-Reply-To: <aROS7yxDU6qFAWzp@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PzuGnHveMzFt5BjrU2Sr-DTsKZQ-SdcexJNuzxasy8k_1762893850
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 293134000E
X-Stat-Signature: u7wnp8e8jycmwtgzonyjswmn4zbocsex
X-HE-Tag: 1762893852-695466
X-HE-Meta: U2FsdGVkX19Sq1umSqzA43IYeADWc14vCOtNL6YWI7S2KZmWflIGHU7K2eRh+dUfhxfOh+gr9c5ei8Fh1nVMio1z0fNyQ3YFE1N3MkZxfmT+JNsb3u035pHJaKWuCtdreWfO+fXDJuaEBC/0erzsZqsrVesF8QBKnEIjxzscl5XdCqhDfxBGKNnKJs/Ql/qHx3DcrkoVZ1p6IBe6q2Najvy9/6JlIJjRRlJ/kcY14+jVaqtdtFQCTu+h3kdfIAY7m+gGWpvvekGQMnIogo98/iWmi3Gywo+8ZlG6q0q5PrW9AN4qqGXH/7xDkPfeoIhxcaByRsnezPDdmLuBDqSfKzvNeorq6g1sB1l7BhwPndgJHXOJhcFTnRq3yHJVBYKRX2qtziFrL0jEYApVc1KuG3TMAlKusO0Izaf9JUtDYRl/1zTL81oUMxizZAtDz52mrsQSd2dC1sUATN7oJRfv9gtLRwEJMzLxw4LYHMUMA3RF5rMyFrkPmC6WLD34Zpn9UCgBwlmOqYgpyA2nQmD9l4WchAopD8YHOavmYO5sHGr/tm1j7Q9bV4gPZI4XJ2nNZlf4x0XTq9ETgTvW6iMJ4yUSAtG5RucP7IszwfbaDbm+7GJ/crMiQpjXsCjlo0+w/3J++2iAfw/MC59PJ0IrWVPsXETd00W1NQ2XMlEPaa/IwGTIiOTtoNkZdu9cyymfDSeDg3LWw11fMCqr3iaMUmw8wc9+GAdegedhuvbkwKW4rgFTHnVb8fKs2tkAFQqKDg5HS1/Nn6aosnVQkguRGncixPghdjMbObYaYQ3gevq4cogbiw+NdIGSRjSKU9zjN8ZBKx25y/w/Yn5HgQAAtGnXPgy4skqQOHKCy06yGDnXg6lNeulJ8Inhh4TTWUkhd1E1O+JLarAZtA/gVH3GhoJR7PmpESAuldvN8f+3yaNcc3TqtYrmDBKiSM1KPLpIyXUEnxplwjvfmTefgiG
 mT+TsAfY
 rOtC8g+/OcnCWoKmwnKmZhNuEDlOSNPDSIAaelMpGScKMMCBVHvoe1oIqP8G1yUa3pTSYjJdaJlfJtwnEmxndzW3OzMaLEsxqTSRM4J4tdzriDTLDPIyUfP4+vyaD5Jz1BZL9pvphaDgwfn2tn2AIOsVRWAy+9ORuXZhSMQ0FG/7Mhlkp3AYvddmWEJree4SaOKsRA89FHalANcZ4zYfBKqmUCnaNFILz+PxdmD0NMe0F7dbV0wsEDgUXaOWOGyjdLOQOQLNbYom56HiBBbCzjAfOrKCOc/Qflx6Asd0qGziDkC2cQI5LeU4l6vfvbiFgHJKKkX/7vi9tatUrZ5AKcyoZ5H2AG1By6gsFI3YW9DpZGe6aOMrEbQ6KJsI0J3lR9UQJOsDSc+fNcWKfefoU4Uo9eA4ZLFBh6MS++O8qikPpkKBw1ZmdUIfiF8o4M39V31K2+rh1Kk52SCX/ra6BaCGeeFChQE2pfsom63y6XK4e1Y01LZ/2cNfJP7ZXMPptryyE5cq0UQlnsA04S3DHXoa6tFrlWIJWraKViwz9PdCdnudTg1EfQA7xVbvAywj+xmoBLUQhOGf6VqZS/I/7Ikl6QEFGiBkCpDcWyuKOj83OxSemCUPI8yOiDy4glOpU9vb16GXDJOwzgR90UobrPyALUAe8pGCGZeH1LxNYDBUxAyE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/11/25 2:47 PM, Michal Hocko wrote:
> On Tue 11-11-25 14:10:28, Waiman Long wrote:
> [...]
>>> +static void memcg_flush_stats(struct mem_cgroup *memcg, bool force)
>>> +{
>>> +	if (mem_cgroup_disabled())
>>> +		return;
>>> +
>>> +	memcg = memcg ?: root_mem_cgroup;
>>> +	__mem_cgroup_flush_stats(memcg, force);
>>> +}
>> Shouldn't we impose a limit in term of how frequently this
>> memcg_flush_stats() function can be called like at most a few times per
> This effectivelly invalidates the primary purpose of the interface to
> provide a method to get as-fresh-as-possible value AFAICS.
>
>> second to prevent abuse from user space as stat flushing is expensive? We
>> should prevent some kind of user space DoS attack by using this new API if
>> we decide to implement it.
> What exactly would be an attack vector?

just repeatedly write a string to the new cgroup file. It will then call 
css_rstat_flush() repeatedly. It is not a real DoS attack, but it can 
still consume a lot of cpu time and slow down other tasks.

Cheers,
Longman


