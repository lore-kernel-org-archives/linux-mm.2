Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3741CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 11:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70C06B0005; Sat,  2 May 2026 07:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21EC6B008A; Sat,  2 May 2026 07:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F8B6B008C; Sat,  2 May 2026 07:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3DE6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 07:53:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2924D1A065B
	for <linux-mm@kvack.org>; Sat,  2 May 2026 11:53:26 +0000 (UTC)
X-FDA: 84722319612.20.3294CC5
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 84874140003
	for <linux-mm@kvack.org>; Sat,  2 May 2026 11:53:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FUy0eU24;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777722803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MwZ67b6kVq0qP5McWKtdO/QZVgJMGMPc9j3uB7+0BE=;
	b=To2C9J6JKBNfwTQRYXd8+Ts0mDmZyYmGpyfPGiKUcIhoI9ghakcrCaLl5BH3+HmbzenJF/
	jXtv2lDvbWckcjz1Rz4HKRT4JvpAL1FWB75u2J+51pf9fABM2F3FBAszzXWoY2rHJ2e81n
	5A3nyvQyuxbYI9u2EpQnglF9+Mo9RYo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FUy0eU24;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777722803; a=rsa-sha256;
	cv=none;
	b=C5DR0Wfd61AH1oYx/xS8digs/yfRvLxdk+HHu4t2gRDSizEpJeORkZZ/yVwUHlOjZLbVw4
	klkb4heRP4Pa0DFcAVZX5+jceCWImr8T/V4rbKd9+8V/XqtQkEzQUVsz3V2OP0xG+KWMXb
	raBJDIqHMV1OzGySVfepW+nANYAk3jg=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488ac04e13dso2382165e9.1
        for <linux-mm@kvack.org>; Sat, 02 May 2026 04:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777722802; x=1778327602; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9MwZ67b6kVq0qP5McWKtdO/QZVgJMGMPc9j3uB7+0BE=;
        b=FUy0eU24moXgMQOfOK/3DQBhtLjGUqiI2XbqKtCtyeCiQ4UzRWWLPLuvY3ylPCtKQj
         jdPlXXv/JmfJruWNXbaN36V1YV6RDowgF+r3/1O4gIHOJ2xgTFq7JtJwn+h2s1nR4X9q
         9zK7PVCRf6LDQhoIErL9GfwlPM7BVnCbmKueI7sqkcyECbpL251RfjaQqXuTfHf8ZlXy
         m8gz69EsHImFJvGjh0oew0qndWL6WeM7wYAkM6N/27FF5AnTnBAxHl89eBfr19kFcPGy
         tiUzeXfuI51GVCyDrzc/gAWAUnyZ+FXPTAxe/AnQ2ChaQW2yIZhNw9JDfFJW1j9ibhCH
         QXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777722802; x=1778327602;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9MwZ67b6kVq0qP5McWKtdO/QZVgJMGMPc9j3uB7+0BE=;
        b=RVjfk4axEu3dzeCrERMj0YI7s4PUqEgO4MUB1ECD91yNptVL9IoeCBpdlVt4OSzQ2t
         IrLIEe34jbeNNSGSl4XupCaJa359y7AWwLFOhys7x6g3naBEEtqq+c9HkqAUPxEJEJ0K
         BFaF+R5jj9xkoUaqeG17gC/uf1UJVFWG5CiLEbAFfpVRfs4vZIxeVMv5tN/DMINWFMuA
         d7B88BSwac8w8CKVLhsxT9Gm3Q2y8nBhqtNm1XQGevq35/fNHmMACwMr6C+hoSVAoyC3
         JVnfT8XQ58aWkBEXYqtatXfe4Yko/UHWW8e0ICIjO5ggtEfZjndZHMc3GTC1StUfiESe
         OANw==
X-Forwarded-Encrypted: i=1; AFNElJ9TI/SLbjaKq6vAmXDQ5pwGcgZiAoS5LDz2VncL1GauKEKmJL7VZjgb36vCj2497abCWk8DJAiWyw==@kvack.org
X-Gm-Message-State: AOJu0YzFqYohz/ASJ9xCW9yrET6eTC9w+xoztwtSFHCTu8TLUGTtlQ14
	5fOKpetE6UTVhJ3Trbq6lHR1f3YvW2uy+zgVTLhdxJfhzmQO+6HrM7nBJyGyH8tmY/Q=
X-Gm-Gg: AeBDievR0E729CdX3W887pwtANujN8UfC1LGu8VXaVn5pmkAzzK7mcp9XAKVp48HIc4
	coucpGR3SBDtzPup/lP0B/f5lzV8qnNHCMYkGg+RFK6j3WnjPXcYGIciz6priQMB4eENTDza6IV
	Q90INJNM5iEaY5cpavw5h+idpLb3PuI+m47ciNxl3Xh9vztjeLjnwRHb4lVX1fJi5hJIOm29kNi
	S9iieJqK4i30oSJ29IsV056BgNXNjtqydPbrce+h5NacDZv4BWTZ/Myr22225IhsBvSwXqwhrgb
	KbznCSK3bLtiafoZMznvLc/esfp9GYAUiPndgT3CQWXRlh09q2OA6ouaXny76ePHgfaQBUt/NU5
	0X0tyDnoB+wZKg74IZtzOGR5nLaipHJt3H2R0mgnXzzZ/cBtPoCXf4XI/WCRLO23WFSn+zp3KwO
	UjDr71armzXlStU9dq8/2Xl7kbCIl0EjbfzQpHb3kszsYdIUoyHGFz7DmBO+enoZhn7pVTqWaTg
	FVh55o=
X-Received: by 2002:a05:600c:46c6:b0:48a:5302:8ed9 with SMTP id 5b1f17b1804b1-48a980fb90fmr20789835e9.0.1777722801649;
        Sat, 02 May 2026 04:53:21 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a8ef52854sm11695231f8f.12.2026.05.02.04.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2026 04:53:21 -0700 (PDT)
Message-ID: <83c146d2-d52f-41f3-975d-ad607a6f741c@suse.com>
Date: Sat, 2 May 2026 13:53:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Content-Language: en-US
To: Hillf Danton <hdanton@sina.com>, Matthew Wilcox <willy@infradead.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <20260502085645.262-1-hdanton@sina.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260502085645.262-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 84874140003
X-Rspamd-Server: rspam06
X-Stat-Signature: 31osorwbbeud4rx46qyw87psxjunj5mc
X-HE-Tag: 1777722803-169485
X-HE-Meta: U2FsdGVkX198diZvWXMy+W0PGyAm8gKpiALCbpFsF3mnMp6gk/vbPy4tbYDK6eqCw6/L39Zkxrv99EkA2mmCV29EUpr82zlrh2zkhluwNO1Fbg7pG3bb9BqcL2g4ZQkIMyjprsWEJka4B4nb+LpejdPq3zOxYfpNpBJX6pSoKfeSCddDZhQSv+BCYe94p+7pw4eH6Dw5wYbTu/AbhpzuPAz7nxkavMqKlmg5ia8aLstMt+ZLJPt9rH+ZPdKM7waHoM23eJtBAe8axvjIw3AJ8ciR8WhfOjSLN4Iv5MPPnjZRcj3wkMoan/WYhtZDqUN/86IqGSMG0mf+RlgXFIi9Pvbbktme9tT0xxbCk/UrOhTv/otGF8JgO8Z63cKDeCKr9JyVr7FbXmkA+iJYA4VaEneCPnzkJ5JURBjZSJB1tFl6+Iuxp5I6oq7KzraBp3l4o/Yg/34DiV9uXoMg4qUqoMNOw0VR/kO15wM+6aBMOJq5y+c2aSfy9Nenk33Au/m3Fn8Nwuq0vMzxJ/skVy7xeRa9R1Ln/mThiE2gFk6XrDT3oZZhKknnqYHDajQs+xLyetzzSdh5nprzM+P9hxaL6qYveqHSV3p96ZwctugZpsNKaOP87yITAVpuQoNrrX65nyHD/448UL2u9GLjtXXoEaA+QAaJQ/Wot4fW2Sxf+h2PiR72RoD3lFYMqX2CFkAvUYn2TRnVACUwg9Wx3XlvZ7KnAOMwvyWpl7z4wwrvtgOurVDldr3AoDg+58PQs7/ZSzaUUbgHVS2wXqAMDpo2YkpBh/+ZXSlZjfz4F0HF6hV3jRpdC78SMahxhC9h5CoHTuwthS3llU+wxvM3+5LVqNP6F1Tvc3mCcFUcVs6CMmDggH2Y3lT0oUOIk/8CWohomLmpLFpZnyX5zVdyPD8wKERLxwR4zDR5bwjl9X9zk0XihJ4QlpHWPbZ8SzBb9PlO9qX1+zOiPQ/WKQm9w5Q
 z3avCrIy
 U88z08RRpOA1WEoVaaSyaClhCG+b6JMeAoMIBFS6/wSCXxjo+So01Q6i1Q5r0FpyPl2fGocX9r4C04mfrVF5vdXG5Vq2rsHlnsdfTHjeSPk3BLAXvWid6Xc6rHkWsGMy0/U6EzoaSNa/T4bitwQXVjrtFpvf3paRmi8eG7vD5J1XeyKJQ0TTEXCua8idz6SOCaVJSarePhUbjJQb7U1ITi2CR1vy17kz8BRlYuMhGEyxqqRKQaktD9XjyxVlwJXeeUDsqmjbUtuYhHzc++qOMpfFra5inS+cE5JJ80sw5Ed2jQUGij1tZ+ms6Y8/aRq7YSBuZmX4DRnJoOLRJOyjKUiRrHPL1RRgmFy0s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/2/26 10:56, Hillf Danton wrote:
> On Thu, 26 Feb 2026 15:54:22 +0000 Matthew Wilcox wrote:
>> On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
>> > MGLRU has been introduced in the mainline for years, but we still have two LRUs
>> > today. There are many reasons MGLRU is still not the only LRU implementation in
>> > the kernel.
>> 
>> To my mind, the biggest problem with MGLRU is that Google dumped it on us
>> and ran away.  Commit 44958000bada claimed that it was now maintained and
>> added three people as maintainers.  In the six months since that commit,
>> none of those three people have any commits in mm/!  This is a shameful
>> state of affairs.
>> 
>> I say rip it out.
>> 
> I suspect you are kidding again. Go and cut it off then we know how sharp
> you are.
> 

I can't wait for the day when you finally decide to do that with your e-mail
"contributions".

