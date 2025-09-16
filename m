Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A4BCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47438E0014; Tue, 16 Sep 2025 11:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7218E0002; Tue, 16 Sep 2025 11:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6828E0014; Tue, 16 Sep 2025 11:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86D408E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:27:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 409521601EE
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:27:51 +0000 (UTC)
X-FDA: 83895493542.04.FEB6C2B
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 39ED4120009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:27:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=H5EmSGdU;
	spf=pass (imf29.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758036469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBk3cgVrEpdZ+x59L+pHlmsugwnIS3miRhoSDYBnqO0=;
	b=AKknoL1Va3L4lD3DbGhIKvySlMlmDUtZbWFvEObgRjKkqqQH/BpIZoBdXj9qeNzAMsXWZx
	Ehh5hbhw2F/zKsDFXszbEHsHYiTodoXiKJsGoWO+MpE9nXaZHy52uLSHPpIRHqI74mYNSb
	2nlpKHPOLIwgrF4GDNTSv27SSEUC+aw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=H5EmSGdU;
	spf=pass (imf29.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758036469; a=rsa-sha256;
	cv=none;
	b=YNIPJt8b6RG/U0w8OQjL0zxxNmBw5yg9jEYfmAxvPcMYFnAa7b12EHIqAID1UFIfBfLQp9
	wU5LBKQjgSgsvfeoqcfGhrQGzMSofJTw2c4J+1cPVMXYxECpFkH4Fp4vqpAIEdkR2qwXQS
	Fo+llNeirUYRKayX8jFAD+wc0k4fkwk=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e8ea11a325so3841065f8f.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758036468; x=1758641268; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zBk3cgVrEpdZ+x59L+pHlmsugwnIS3miRhoSDYBnqO0=;
        b=H5EmSGdUJYjHYzUa/NcEmZWrViCDcCbsbn1TvpKPJwToRBo/a7EDgCbiQ7PaQbp1az
         SmpU2pWXkkoiFzrbfP2w1LhuI9tNRkMQv4haW4pcqWm4pv3zRxvUif0BBkF4UfWatf0b
         ZYlG/jq7hnNQxNYbOzZoCx1izHZl1XjZagiDdmj27y35YzOPBlo1mz8+paK15TIxQcXT
         C9n6aI0guc/G9UpZHPQfB31YFwr/Tz4zRZCcx96gL46MAXxmJNYfvNDKj+dPRR0cLt5q
         PPBp0L1PLyys6PCq3rveNSVT0/38h8nS0QXODpJcPvGT6h62mqQv+K6teKYwJdC+akM0
         zYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758036468; x=1758641268;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBk3cgVrEpdZ+x59L+pHlmsugwnIS3miRhoSDYBnqO0=;
        b=KJ/MLKe9EMhumAKShUzbeiDZPuBrO9TPOXvcqXi3JBhh46gSsRime60rcilstl8iMg
         /6Y3LHhtmjdWWmXMpBsZ6q0C/vOaanK61/PUgHgcqbCzN0cMYMKl7ke+xzzbPzOzOrFP
         iE7t35lJ1j2VCgvOZK10Ce9wJ2qV4bsRKATZBKHJ/RIb0O0AgnFjIzuPpwfnHZqpXBls
         U2aACCJ9RV/auphsXZNCgU0Z1jUy4FXW5TsrAZWuq3d7M7KU2FgT4t6TjAshjGP7vw8e
         u4QY8fEvq9+sdl8N1OO5bCd31f36/mDInLjSvCFubFjf4hC2OUoxwSkyGLXG+M3GGSWu
         BmcA==
X-Forwarded-Encrypted: i=1; AJvYcCU0ZSFmojcPKIH9IqFx3OrsfAFKcQc2hcDmbzUwJkHRJ92ryQV2qB1fLBLND0AlUwBO1lq0vbkGAw==@kvack.org
X-Gm-Message-State: AOJu0Yxr70vk1XmVW+1AxxcRJd6/dM11c3tB8QLb86xLvDJC/EI3MyWJ
	Sf3gc7e+rm/v+8WrlMY2o76KlTQrGWt2S+/+OxmVnnykT+F+l+L8H1IXbD40NyJ4t1U=
X-Gm-Gg: ASbGncuPy3b5/m0SvP63WwgiULttPcV8kZu1GBcecFR6JmvnoI6c0INZoUBXiC7VOcp
	hc4eHG08UMw3A11TMDjkfIl3gCWCknJHxAplGJ68lg+AqtrMC2Qf1m+nosGC6hvuB1xMSHiZUB1
	km8gq4Vu7E+ocHW4FXTm7sJQ+IP3zfj1juJyXnPWZ2qja/K8obaAxNZUIgTt48tQ6EGBfy19MTV
	rE7nOsx3Z3MMIdUS72LBdK+1XiWZENaTiwOpYKQmC0gKG2tORbzUQCmcUk7EkTcwe3jLHSRInyX
	ZPCq5Iig4IT+MkH9aE6icvBss60I3cVgJ43cQLJoUVH45u/q4lR6G3aF6QPL+FMwtz0SwusVlo7
	Dvl+E+cV6T+nekK9degsSxqvRz7QjnA==
X-Google-Smtp-Source: AGHT+IHDwjfQuIQJuBkMmBQqFsxSOzTJndqBY6wuQhoBVd+d/7RL64/dV9lAVoQBQ7xySIf7p9k7wA==
X-Received: by 2002:a5d:5d05:0:b0:3e2:c41c:bfe3 with SMTP id ffacd0b85a97d-3e7659d3a79mr16152029f8f.38.1758036467575;
        Tue, 16 Sep 2025 08:27:47 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f27f44624sm148981005e9.3.2025.09.16.08.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 08:27:47 -0700 (PDT)
Message-ID: <f9e90d18-ead0-404a-937e-f5e2cf11c0f7@linaro.org>
Date: Tue, 16 Sep 2025 18:27:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 00/16] Introduce kmemdump
To: "Luck, Tony" <tony.luck@intel.com>,
 Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: "kees@kernel.org" <kees@kernel.org>,
 "gpiccoli@igalia.com" <gpiccoli@igalia.com>,
 "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "andersson@kernel.org" <andersson@kernel.org>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "rdunlap@infradead.org" <rdunlap@infradead.org>,
 "corbet@lwn.net" <corbet@lwn.net>, "david@redhat.com" <david@redhat.com>,
 "mhocko@suse.com" <mhocko@suse.com>,
 "tudor.ambarus@linaro.org" <tudor.ambarus@linaro.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 "jonechou@google.com" <jonechou@google.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250916074929.xiait75tbnbyjt4c@hu-mojha-hyd.qualcomm.com>
 <SJ1PR11MB6083477193D9EF7CD10DE9EAFC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <SJ1PR11MB6083477193D9EF7CD10DE9EAFC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 39ED4120009
X-Stat-Signature: cd6omz8gkexucijoo8jobt9umw6i4ik5
X-HE-Tag: 1758036469-279219
X-HE-Meta: U2FsdGVkX19iU7AGqSFZWDTDB3CLkdkip7neSRWt7FF9zk9FEbAmQTG9Ks5hrbsSw7rVbt+PJF5umT30CFYlRLVTsHpt9QRNp1l+u6PVPNd40fyknnhsTl/rQXhrNQ/0N47AIhoPKstInub0p++CdvaZ+ZHF4Ex4aVLxKN+fLZbViYmRYB3/r59TAwDxF3rDsbH46dAgaToK7gQroIoAtTfV+vtEzrb6lME4K3STZXK1yzk03WOSqotM4b1zome4BIM8jFZboofgPoNN29li2P5p5E7L9tKPM/lwtNvL66LvA0gHdEOnCNf3iYa3QMNMEneiUL3lzCTa7Z16G5ggLSudG6Eaosh7VyUhrEYGBptTru8JKU49NSNKztwtRy0vBJ9DuNwgsec5sYJaI5uD82iWzoJEQs6UJHL8hgrdkhxDYwNY75XpYDAFQQrwazbY2+ZlDwAZY+kCJJjiv/bYY/2r1booDlXn4y5XeqRTodaDM0jgHIFLo6Lm4nNbaHW2OXH/WsywQw8lIErG/g+E6clmsLjIKclLLGQAcdq4W7C+eP1ugnr8t/VK57Yq7AkNQI0l7ErbSO5MX2VBzTjFyc7kEvwZVXzLHHe+1MOqiRz20VZFWmFjP79zzmLVCrLm9GCAI6RFrEVDBOlPtv75n4eAnm3lnWgcm6z0WlPtts5BxO1A81eGYtYKcvw8ejXGrxh/5UIJDjYgChbSAVxpHLPDpI6Va6Xre5FKsLIQ4k9eeYpvsSS/nP1eRFwbkDVIoN/OQGPRtQrTWk27fH35V43UC4o5prpA1+yG5bvcErkgjzAgwBQgw7MpOaSfv3JU6ixIER2l3mGoH0pSqrq0mbi2PEAg1gwazD86WLFUqq54SRorGvFxfiQmyENOg7/ECfG6JbbYj5ycK5wAcF0Iup70WR6lZDGSzWoVBCUegG7lk1w8HyClhMHFCgYkQsBQznwg/K6pN0FfhPFdUjj
 vesZFd0L
 9i6gIEn6uyG2wB1VAN/MGTAIsU9PazKyF6GdG77nX/NzxNq3blWcTxGsS1YS4/DrT9W/jMpNvLTytD6q6fwA4E5SMHIdeGvQ2JAO3MeLrJsa7qYkh+CRPnts9kIQ1W5aYhUP5Ya+wkbIRCB9QjyPXQWOO8aqfFChEj048NfYFNSmNQRfzgMTUc05GxFFzv88kxZCHRFN0uJPKihPIH/O2PjLHQMyAb7Fw6Ef8C05s9rPrXqx1S4cc1+kcyLv8DfcIfeJHkrznBpCPqKql8POD9X1OhKi1JLCZNaCyPX4vJyOvoQ6PzasIXbvptHZO2ArZvytdQzEeDZ8ryCBBMrPQFCS6Owk2ahf1WUR+PTcEoyqxWjowLNfyfmJUo/PZiTFLo0rA0WJmR+vhqcl4rJAii2KqzBSjxf/RJ+srcllShuqCZ0laQqCOz2dVz2lVBBzHQHxX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/16/25 18:25, Luck, Tony wrote:
>> +Adding some pstore experts to bring this to their attention if this can
>> be followed and if they find it useful.
> 
> Depends on the capabilities of the pstore backend. Some of them
> (ERST, EFI variables) have tiny capacity (just a few kilobytes) so
> well suited for saving the tail of the console log, but if the user specified
> more than a couple of pages to be dumped using this mechanism, that
> would exceed the persistent store capacity.
> 
> -Tony

The backend can fully decide what to select from all the regions.
Some regions of interest are named (listed inside an enum with an ID),
and some have an incremental ID that is being assigned.
Either way, the backend can choose to ignore what is unwanted.
E.g. patch 16/16 where the kinfo driver selects just a few of the
regions which are of interest for Pixel debugging, the rest being ignored.

