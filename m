Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4035CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B9C8E0017; Mon, 13 Oct 2025 05:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBB38E0007; Mon, 13 Oct 2025 05:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D0C8E0017; Mon, 13 Oct 2025 05:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD4388E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:52:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E424C13A8DA
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:52:45 +0000 (UTC)
X-FDA: 83992626690.07.939FE10
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C98B1C0013
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:52:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V9Tetipf;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760349163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oi2Sfmi23s/YBlvwVz9Zb9lC5VzSuAra6/nQkk0ykMs=;
	b=l/eXURY/7hKtJnMbRO0j80JWTooU2NkTa4bmHhXbhxcNCOCMQMYITpZvNcz/al+Vgo4n+I
	/16a9+bOQfqpbgapfsj+0JxK9qjOjaRcoS6Ufw0rx390crySLXDDAArpX68epRgq/3mwE7
	kyW1ESANq+nS4s7f1sAnc7mSTjooBw4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V9Tetipf;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760349163; a=rsa-sha256;
	cv=none;
	b=4VWM+azDQ2WpTTab8vyb1bOdshxoDnbteTlmVAAM/imjl7/R+05I/XtXqMyvnOjq7pbWWM
	zAlBaeyx3lkNEnCN7dr2wcleeiu+Zm9xk3O+ZRmeLdPRKV1reROopHBIv61Znz7RTOaUEx
	aRGQeTovnX3+EM7R6jhprBevVYtqVNg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760349162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oi2Sfmi23s/YBlvwVz9Zb9lC5VzSuAra6/nQkk0ykMs=;
	b=V9TetipfCVyiSb0KC1prLpcdj9x0kmcuOhFvF8FrFooJ89xjgO26ARZ2JCva97Hj01wmUy
	sc8HZYuOQafebvlXUpkBMuHSrSjwC3rXkWZumjd9FEk5Zb8iMOP8klRaGax2TXponqvSDW
	UzSfbvFdMj5peSnxGbyai7Fo5Iiaev8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-sgGCGApuPXOPYoJb7dSSGQ-1; Mon, 13 Oct 2025 05:52:41 -0400
X-MC-Unique: sgGCGApuPXOPYoJb7dSSGQ-1
X-Mimecast-MFC-AGG-ID: sgGCGApuPXOPYoJb7dSSGQ_1760349160
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e4c8fa2b1so16400305e9.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760349160; x=1760953960;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oi2Sfmi23s/YBlvwVz9Zb9lC5VzSuAra6/nQkk0ykMs=;
        b=PKq7BbL2jOPL/NK3QV3Y1ZV+zKx2kW6ARqVtsZ9XGrWJ3m+8ABRVSd8GrNvrxx3wdx
         +9LvQsDxOR9Pldh8DF7FE5e5PCV1SFEd4YU/Lt9OMsIFPTZ2bDY2TrTCTwlkJJrqy79r
         oLTt0BkLG8UCrCxeo77uhlohHPTTszBzP/qa57b4ll+NDUvxImu6ZwbzDrPWbjjDZFtc
         TB0eYV0UUpwuZ4lafBFvs6paHIdqyQ6Vi8dEoUnZhu7kQSgvqygm5o/2jMhbuNTyxKxW
         87PF61I0lWkeKTfKfsekFdiwKk0f9X9qaAtGjbpFOm8rFZ6hmBpJqEWz5F+qbnGn7ImT
         8c0A==
X-Gm-Message-State: AOJu0YxPyyjuAa1o3YIVYjZcCKbjlUDquMn9pmuEgNUJ69j3tBVPvvfN
	RXSwSZehVPvi2bHPtvrgeFX8wYA2bEtULszumpnj6H6fmn19uXJWRzbRwS1ZDKz9DKMaUslgIz7
	ey5fzWZbXmjqE1o2SHPPSHnu9DXXZTZYSjy47Q98JQpAj2Jo36kce
X-Gm-Gg: ASbGncuKQlqarJM+qJfbRnUxYTxLNZgqk1fD2xJEkmGIib9JInnwfUQiiHz/il5xjDU
	FCjhC6oWXvHWtImGE1zKesN4SVB8bih6APVcCqzVihIlNQM1PEBlgx1xyFCKl2anrvMuhoY1Snf
	LefFGPpu7LLZ96fDn8Tcpe15Jf5jkXxqHtN6s4EE743OWZZZITtVBMqTAIyhbFhY7BiHlr450J3
	Uq6ErJ3t50UCNO3dQ72JiwFPHB8eEyqYuWjqGLFrI6LPcM+d+ZG8FiQVIXhHiV+868OlbHqWeQk
	foYTqZbGdh01AxKaXLYr84qpHNbt5w6QNSb5YJ12OyaJ7vM+tmAAeDO7iga19+qAnr4RolSwN3B
	pSj0=
X-Received: by 2002:a05:600c:3f0c:b0:45b:9912:9f30 with SMTP id 5b1f17b1804b1-46fa9a86314mr139354495e9.6.1760349160059;
        Mon, 13 Oct 2025 02:52:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJJvTJXXAUYSufRJ6bGBwkvZMnE+XlLk3jeO6iflZplpU6Frmuj3270Nw6mNxOlIuKspxZ0g==
X-Received: by 2002:a05:600c:3f0c:b0:45b:9912:9f30 with SMTP id 5b1f17b1804b1-46fa9a86314mr139354395e9.6.1760349159668;
        Mon, 13 Oct 2025 02:52:39 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab656554sm123876145e9.11.2025.10.13.02.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 02:52:39 -0700 (PDT)
Message-ID: <8e458538-69dc-4c0f-a25b-0c85ce1e866e@redhat.com>
Date: Mon, 13 Oct 2025 11:52:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regerssion] [KSM] KSM CPU overhead in 6.16+ kernel compared to
 <=6.15 versions ("folio_walk_start" kernel object overhead)
To: craftfever@murena.io, akpm@linux-foundation.org, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
References: <020cf8de6e773bb78ba7614ef250129f11a63781@murena.io>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <020cf8de6e773bb78ba7614ef250129f11a63781@murena.io>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gLozfbGbYoRCTXr6lsdlBq27rTUfEVzu7aItKVlXkjs_1760349160
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C98B1C0013
X-Stat-Signature: oygwz8pmrord6948godxgduuww4tzspg
X-Rspam-User: 
X-HE-Tag: 1760349163-114633
X-HE-Meta: U2FsdGVkX19hYZMsf35lV/BZdAPK87KFWlBbTEl4EdHNqg2V6ypzklENBlhZyeXpStKnjx5sW10/PJ+SupT8ath2jef7hGi4YWIjW1rCMBSprhpgUUbuM5As415vL0wq2e2fNc6W6Qe0sgdgWnw/Dsg1HW/ZF399UlRPfhGDFAm4yZDcnejz7S69cHP5sQBM92aQoFmX3YNJHWWPYDrnJM574JV2krrg9BW9aLL8PizyitE+vBuHqswvSKiL2apQmGmIxORedjMhrc05jCRsHiJRHcUkRaXq7h7KnKBmJlGWY+JUrD0wYjnYev9UeVqZ628jsmQ+jgUvAVdl1jiH0M8zU/xJihonbCX7tY9QZfcMN5XpMPpYMZ+e7ucuEjc2EvF47dfLh8bxeQeWM5fJ9hftLlemInSTueFnGlWJfxLDGrEXAsMc3LgQ7mgLOsV2KGPdh2jkXqCnLBX0YyKwzMSoGk6DfFdG1/IFM1h6hPT2xnzzuB7Av6mWqPTlH177KBZ2MCcQhGEPf3EfVZFxTp1JU/YQb7mJNPFIlMsmBmv0nx6/2KzGunFqu/j777pE8AMyl5e82rWsam839xsO1J4alArygFTn3o6BVUeXclqP5Uqjr8D68So8IsdSLb8TKm/I1KkxRbbUuB+MACMegXldP1LRI+eoIZ0/dAqxuhmaBRrgM1BvI5RRvyR9yQlWQLGa5QtXnSV7Ir31QK0ovy8zIue1p9+Cxwcrwd3Bl26oSVVew828mQIiYq79jVkpNGC44VisTnExPNrn4PibGLroVMk6d2oSiU6oWFhF9i8f8/8gJ441wFzmx7PAT+0HH1aB1lPBs4wC+NlTLDDAbPdJFQfbHZH/RUL/dch00SK5CbpgdCKIqa3TpMdKn6/3e1dhtxGlZXrUFA6OloxLcJYu2QevrIkEvpbDCusacwcPvWSXSYJ8koFR1/TYXBg0NDUkmA1142chtISGaj0
 1zXgzEFN
 4niZOcjkmChsfEaYrZIPbp+Y3bUA6peL9g6w93zB1QPVjDCID/hRJwSm8AxvdPTYAUQU9xsgCoN72i1nqmB24uZid/tPKiyyYSNvNj9BNIJQKN2XG+C7URslXhKNyQCGWX3CWvNrl6D6Ugj8skX3cYoO0xHCoasYtOZM/Zlz3wCZrtGAT9/tvooRszWeQ632miReG2hp4tPTUWdnebrN1Nx1m8xpeDhwmedUPtUF6lTllY0UcCfv3Dd9xtxDaY0miAioZr5TFE4UEwyATscFdYy8IZKLftPypWDe6ONhj+iokft5I+ixE7lHUsUXQ1UBEQlov8Ya/mgSmd+Oj9T+lj1GtjAavAm6UvWdNcNzKV6LtoZG2VYWeMrvd91DODdMilb+9NBd9Yi76Wbmh0IDdwOO4t/7Zjv4kJJmDEQYDFqrrJTmD/FpFHWdJEQVttY+3arZe6/LlJZ2HWTrjjWRjnsiLmNNsD88RaefAUkv7RLruNJPyn9iU1w71NpfuA1zoScWL/Tgxb062boDgrGAWmEhraUHL+AzGyCy86dTWgPQWANs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 11:22, craftfever@murena.io wrote:

Hi,

> I've posted about that problem already on bigzilla (#220599), but maintainers asked to post issues on maillist.
> The problem with freezes during KSM page scanning with certain processes like Chromium with huge virtual memory size amount was fized in 6.17.1 compared to 6.16.x/6.17, but problem with huge CPU overhead is present there. Compared to Linux <=6.15, where the overhead is much lighter anad there no much CPU consuming during KSM scanning, there is "folio_walk_start" kernel object is present (which I reviewed with "perf top" command) that is not present in versions <=6.15 during KSM work and which is in work starting from Linux 6.16. This method very resource-consuming compared to algorithm used in <=6.15 versions. Is there a kernel parameter to disable it or it needs more optimization?

I doubt hat it has a lot to do with folio_walk_start(), that's just a 
simple page table walk replacing the previous walk based on follow_page().

So that's why you would suddenly spot it in perf top -- before commit 
b1d3e9bbccb4 ("mm/ksm: convert scan_get_next_rmap_item() from 
follow_page() to folio_walk") we would have used follow_page().

Do you see any kernel splats / soft-lockups?

I can see that in commit b1d3e9bbccb4 I removed a cond_resched(). maybe 
that's why it's a problem in you kernel config.

-- 
Cheers

David / dhildenb


