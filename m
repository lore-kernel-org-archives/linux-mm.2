Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2344CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C2F6B00E2; Fri, 26 Jun 2026 05:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3E26B00E4; Fri, 26 Jun 2026 05:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621196B00E5; Fri, 26 Jun 2026 05:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1976B00E2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:40:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B96971203DA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:40:11 +0000 (UTC)
X-FDA: 84921567822.17.C9785C2
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf29.hostedemail.com (Postfix) with ESMTP id DE991120007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:40:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T8uUuCee;
	spf=pass (imf29.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782466809;
	b=UYDYyeXKm0+jBF6VxlqS2mh7aDnGOmQKEpVHyxR8yxa7OJLBu0BOltcfsCuxaglvxyf66I
	14aZC7T+xcUMKBDfd1L+RYsmY83CooEW2DsoBlkEE+HHXZqjsCzCCvfwEFaANHkMCalruD
	QX90tpXpAYBu7YXR9vqJa2F3ylO5p5M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OU7EDEnprCD/MPTnLuThgw4IEgCvhreE+q7skzKaR3c=;
	b=JkLhvfoDWzoXIu/EX3OLkVyDsjSsG4d0LYWdwWLuMXKPmBbyknFPHzInIMXQ111NtxWHOH
	5UtFyFdq0a1p2kZrNo/aNeynci5yULDmFjT5Hh4NcjIl++LK3Nox0GXzkNiOqvlwXEBX7Y
	gHKqxz3mIEZVZ0VAFmbG8fjEDIw7nus=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T8uUuCee;
	spf=pass (imf29.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2c7f3148705so6491315ad.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782466809; x=1783071609; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OU7EDEnprCD/MPTnLuThgw4IEgCvhreE+q7skzKaR3c=;
        b=T8uUuCeeRJTcyqn+McJUl2gejQ+wW+QxVe/RB1J6PXRbf6gIDgJwDaHpjZZWletOhm
         P9Y0buRF/j0JMptfWIAMA+r3TvQtgCcVL6i+MR3RQe32Jxr0xS0Upw9ievK5AGixGJL1
         u/ryjf0sk7d5CgykITXALzmDrYWQHzpLs4axbSoPBPSWOrJYtnyIDVxpUPdebWYz0RMz
         hCOTCC8TzmkuRqAyCymqyOY2gU2hF9vo42xfa54k0DIfPuxvG4K8puTJxuUmaCDJwu80
         YUHoiz1W6w2+UZY9sFlbr+k6aE6JrP31Q7aItAKo3MTuGrUGJhQc5AdrhHhNFLTa7rP0
         2y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782466809; x=1783071609;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OU7EDEnprCD/MPTnLuThgw4IEgCvhreE+q7skzKaR3c=;
        b=q+jE4t6GxV/H79q1Ge0GtmGOhmjtHyWExuYko/vGq6ke8FT++SxtJhE5VRviwUfJxm
         WXh6qkhH7oCEcqW9Bun+hcRBlZNj8treXbdp1nUyII2eZZ375Nx4bFjbRdfpilaWTy7B
         mlzhtHvcDj0p/g4N9FVk7RTFX8vyacLD6F0Am1DJAcXyZ6+6vS1NoHqbY+J2LjCSayR7
         oJiIv3xPLIq60w38P1cx5dT8Oeb2jOxxiABFG3cfg4ehqbnrY79nhRXro0/QKQc81ETg
         w3wxoT22uQFkpwYbThea5ClkeceFy2Xq6pcpRM8eqUPdY/myazYwvN2TsUou7qOiiWCr
         hEQQ==
X-Gm-Message-State: AOJu0YxlSmeNmN5y4DEQ9lxqHrf3BL66DfTwPI85qkP3zRqnEM0UN1P9
	+c/fhYNeTzdpu2xsSfNYeqgoiT2EGCVV8+sjlH4YX8wXV05ViB0AMt3m
X-Gm-Gg: AfdE7cmI94PW9aYFiKvnYnzB/gwgCeG3xUeMPAnEasc07YHdBWvLaTm1JpfojNJyyvc
	17DzDvJtByP51MfhRHANVxhwcvoWHQ/pTsO9/phnXO34SX2afHIpoly36Z8tmaHOysqdEgqvvq+
	ecPWqo7tuNDBUv2ZC02gzcf3X7O7gQ0vKLC8MmcqGA/TlYbVPigRyRoOnnfByHjLvtw0in9eFqR
	5mxgY++QKBUTqi/ZZGUowvHFB+D3AhFA7I3ePFMJqu73cTQc2ZO8KuKuDOfKaqylCqFEvXVKCMw
	ehG4l22AbNuEj/BDK7NRw8Ed3bVb9fwAxRDFMV+GwLFUI8FnTmG71O2JVZS/CGtmdEDrYOLtI/P
	UNoaH2QtCq0i2f7MOkEefslrZCMEEVISMynThgem0lTUPS+cHebCGkbyyaBKvbNs3H0J7h0PZNE
	NUrrf0lW9pCoeoSMH6YkVdG77ngEyVTiE=
X-Received: by 2002:a17:902:e744:b0:2c0:b35d:ed54 with SMTP id d9443c01a7336-2c7fcce0738mr61668045ad.35.1782466808869;
        Fri, 26 Jun 2026 02:40:08 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f5afcb18sm36565685ad.31.2026.06.26.02.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 02:40:08 -0700 (PDT)
Message-ID: <47b53ee1-1077-4689-8be2-433c6db6fa81@gmail.com>
Date: Fri, 26 Jun 2026 17:39:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 clrkwllms@kernel.org, Alexander.Krabler@kuka.com
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <20260604023812.3700316-2-chenwandun1@gmail.com>
 <20260626092606.7BgipTin@linutronix.de>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <20260626092606.7BgipTin@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE991120007
X-Stat-Signature: 88h6askscxjxcz5tpkek11gwt1ypm5yn
X-HE-Tag: 1782466809-761490
X-HE-Meta: U2FsdGVkX1+h9YaZ8qv8o/uklWR/7gbmukiRr1EKrtJqVbBaIH1WUREYbZmc01hBbr4WhwjfmnQ/xIsQgAwo2tl8lta01l7ZsOCYKAlC6pxXdrcQka9Oe8GQEBIPVJaVCklD/tzg0YZ1ayUf0EaJqAA5KOGCTrmZKmjvBHcIJMg34nX92ubzleNrDel4ND0A3ULl/mRLz7ZO0V6aGmSNLcKhJtOT5LFnCfHmysDuzyCdz8gV7G0Afxk6WR16OPucV9aQiNi+IpQr4fzIaMSrDtaiTbzRKd7j0wS7eg88q5QcisTf8ZOEhi1eetHYvytu+SkFa2WJ9Rgie5E0SZEn16SsghZkAUav22ZChinCbeLuRo+iW+trFC3go5bly6byA2m0J2DOOfvHeHdIEUFn2saqJg1b047eiHHU5QAHzWozU4eVaIEiUwN+IXCnmr2ctLMdXXjoLXAVgjv7tZIWInMQ0+5MoC3a3Qnse2xozT2ayDDr0fT7fnpgfsq6fmd9mv11IzVTqhsvhemYKObQJrWMp2RAiEbeGLAyaptPHkV3ezywthiewsFzcHKVd0+HPTky8ANoA9STZyaXVnXN8bbgOdfv6GDluFwfzvBAT868omxQ0RZTCovGd7ydh4FploxxXMQyIF3TehIAYbGywEpCcyQ4eJ7D/wXeJPOrDH0hOJr4VxtnPp4WYbC9n5TjCMMEs5+J0fyDTPqPQm6ntAvzoEFSUJJmwlFx5OoCWYkLpT5J1vVLPlLY208w03Vq9MBA47GLRHDjxC5U4Z8APkhM2WGJgO5a3eh5WlpSTG/FsHX7H0K4HnaiDVah5s4kIJJokAtIeCJ8CXFXoFx9OcsYPmA2P/co7VIA0hJM9ywBu6uhhJoMnR0eozGlJ9jQTlVoBZxWhnZ4zw8/HqvVDm9g8CCxN3xJIB58lnYVY3NxpeC8HhrDkTCDm1tqbnvjXYO5pYAgu5tyZK3/bZS
 PIVq0Mgn
 kzKzwPZmmQMREAJxs7vJ4BiOzpJpPmw/o2n3mCNI/vIr4G4d32kYAW+5xsuTkqZWy1jxKwWCbnP/hSSaDSq4ZJ7NBE7WAQPfbUuiFoz7dZh2Enp3Oh6aCM4eDhYh/NW5bWyPHeqzg8AlHD4EulnPbQjIzVU+QW1i+1ZSB4emKSkmRxmqIZ2gW2hip6a0ffRsSqvq4HCPdjAVyrQ/1s8WVkECmVf6G/45fn+JnbnVyFwO5HX1Z9IeglgFxRkE4Odpb1OpgB4HIwb8cKo0eKOHC928GYT3YX3IZpnTm5k8PyrjyNm6GclCQjtsumE/r5ASFEGSembwMyHifEQ6XN3aAzk2rBVXADx6P9xREBAArFSjLHXuq8b2whqkXb5d/ti0GRLo10l7usF5PHNLorqDnC7QZAY9gf21UmvjhO4XECITUbAGbMqr+kUDaf5DIUdPFGyXLPys/nI5NiWmIEbyyQY/TYxivEb6y+KyhGNRxMof4zyquMCEeXPv6lhyRukP3fFJVKUHMiPUf4t9UWdBQ4i3llFtprx6FiC8cig9wC7t+csiMbLH2ANOuhx8rJKt6Xyja/+pa2YRj7gYnvMPCYzLq6UXi84iiw4H8N3GQFV2ENWd8w1QMuFRP5sWWq6JY54WOygIE7UksrbA27BDF/Jn6C2a0YJ4HZgW4hrWzqT5n6WI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/26 17:26, Sebastian Andrzej Siewior wrote:
> On 2026-06-04 10:38:10 [+0800], Wandun Chen wrote:
> …
>> Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
>> Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Link: https://lore.kernel.org/all/33275585-f2db-4779-89f0-3ae24b455a67@suse.cz/ [1]
> 
> Is it possible to get a Fixes tag on the final fix so that it can be
> backported stable?

Got it.

Best regards,
Wandun

> 
> Sebastian


