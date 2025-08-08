Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771C1C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1905E6B0089; Fri,  8 Aug 2025 05:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167FA6B008A; Fri,  8 Aug 2025 05:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056916B008C; Fri,  8 Aug 2025 05:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6AD06B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:42:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C03021A15D4
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:42:50 +0000 (UTC)
X-FDA: 83753100900.11.F76F304
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1F6301C0003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:42:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iq+Ard1P;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754646168; a=rsa-sha256;
	cv=none;
	b=8PjX3ahAEjk7ESwFzI91GUdENXIOk38GwDoACo9VYv9/MO2uzKhF6K8WH4h29LMVGVEv1W
	kvfkoc+F8RkfmhIIZI9lihVNaTnnif7/o9MGMEq84Q20iUpQ/w+tBYE6PtdOG6x48Jt4gJ
	OVdf7AVHd3PEufOavRjNBpnca29teeE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iq+Ard1P;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754646168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MrQzdrJbcnzVF+wkegO/u32eadRZC34/Y8ls/2HbFA=;
	b=CsQ5DilShhc49EYw/NmU4BJ3uaBkpDs2hdXcQndpfq1qXt82AE5DuWLBtD5YxhywV6P+Lu
	gx3j/DBEdrI10thQWCDg4yNHFZ0UZCxCzOAPjPqzkVJWIeJffub5dSojyMp0PLxgeUfrCz
	vNIS+Dc1movPFZhPUvU4ErD8Vu6RKe0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754646167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0MrQzdrJbcnzVF+wkegO/u32eadRZC34/Y8ls/2HbFA=;
	b=iq+Ard1PKv5y8t9ZOmMmOcuwxmPp0HMmA2dL25+osgXEcLHwyli9Bpxp5d6XydIGrGBs/8
	yyGDDEHi/rXX4nK8D6iHk7Snez3cmByDTnQGGs2h1YIJ8WnxxZfBi7h2itnqsAjop0LAuG
	G7192npepYGG2GI8i2tB2rXCgzrSD7I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-RS6f_oHcNl-kf-KlETR5uQ-1; Fri, 08 Aug 2025 05:42:46 -0400
X-MC-Unique: RS6f_oHcNl-kf-KlETR5uQ-1
X-Mimecast-MFC-AGG-ID: RS6f_oHcNl-kf-KlETR5uQ_1754646165
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459f53d29d2so2882675e9.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 02:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754646165; x=1755250965;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0MrQzdrJbcnzVF+wkegO/u32eadRZC34/Y8ls/2HbFA=;
        b=EtHNEkY7Dbh5HE5/w7tFoDF7oFfYHsEZObFu1QEaZXccz2eQBAc7T+E/JowQ8qf3UF
         4P3x4km71Eh+MfStNzDJbHa4MAvlUCNedNF386YzD6nJ0RRR4zQvgBidyEEG8REKbNzp
         7a8izP8zWE/HsL5gy4iwba6Lmnd0kn5GgSr4oK9klD9wtBj1/ivDz+MrcRSzWaG60FMq
         tVWcU/QmevMJs+5CYpi07H7r7fVMWW519kwRdSNLaGhrsnVllStxSLtQ5rIqZnYqI3hQ
         MJTTkv6LPJwLrQuEU9yXaGNsN3meJKZ9ucxlCdMS8ciOgFkRuHTreOuT0ZAMptiGabpA
         nzIA==
X-Forwarded-Encrypted: i=1; AJvYcCXm9jiTibDcF1/bCiBd46YHJoCfCDWzEtT8QFkcoLtmY28gnD9UXMdb95+Hj4V+nUooNIaNjNJOoA==@kvack.org
X-Gm-Message-State: AOJu0YxZZQQpeoZRc9hv8iUp5t8JNY44gXJsSq5A/IWL0tMKQy6rh8JX
	aA3Hiz9Z5KNKNVNq9BO7zCkWcl9KMe7Zk2ncs6/pkqqHbO2l6IxYrGPm5IFM+UAIfubpmD/u1im
	9zARO1RBhFtT7T/TH1sKiDX9uS+s6YIC8+x5a929rVKAM42dLCLh6
X-Gm-Gg: ASbGncviDYci+tLNgHxJbpZgWJJdg+rgz+UM6GZp8wCNVQliD9/BpBKNxetE1MTFkmu
	v7xeAcxiGOluXnkDH5gvLyordlN8b3QSMFXWkS+3nPObj3dlFH5dRqSeAkGbAfcixU5/iPsaObS
	zMCLHEyhF147YtUGrTJg5xGjdHeYx5379FkTOn59FSaOfb36lMJ/6VbhJKW8xm8yIS1WTxWLi5V
	70P2r3GKQpgTpLar5ByCSoK0HmoOXBEBsj139uoQ+3Z3dA3Bzh/Yznn79qU7dn1FrbfOfR0lhg7
	wEwm4HHO4Z+ipmjSPpoL/8+cIdIWyP/q6ZvOfzkFqcvn1y2/z83ftnlbk3Rog5ra/2HJBJ2kwFx
	a5JibO8nii08td9mrKnLmb1k85+1nkzqQ9VFmcxeK4Z6kcg6xJ9Lo6F8Q1xvak4rF
X-Received: by 2002:a05:600c:4e94:b0:456:1846:6566 with SMTP id 5b1f17b1804b1-459f4fa8a20mr16024935e9.29.1754646164705;
        Fri, 08 Aug 2025 02:42:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECbtEIdNMBLy0FLygd0cVTYC+gBMQpD+maXZQx9LpgpoUM3XCikyJgg1dewZlUjd3zovVfdQ==
X-Received: by 2002:a05:600c:4e94:b0:456:1846:6566 with SMTP id 5b1f17b1804b1-459f4fa8a20mr16024745e9.29.1754646164321;
        Fri, 08 Aug 2025 02:42:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5887b7fsm127134155e9.30.2025.08.08.02.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 02:42:43 -0700 (PDT)
Message-ID: <cd3c9744-c07e-4ab6-aba7-9392e431b9e9@redhat.com>
Date: Fri, 8 Aug 2025 11:42:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
To: Qingshuang Fu <fffsqian@163.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>
References: <20250808092717.191444-1-fffsqian@163.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250808092717.191444-1-fffsqian@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JqeKKKIoI8ratcvlsoaQxHicMMD1TRZ6dxNiCJoSTTY_1754646165
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j4iox8zp367fn5zzxmaykgwydbraohsf
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F6301C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754646167-194747
X-HE-Meta: U2FsdGVkX18qaVB8V7stt5op2PtG7gpph7MxzcRBkl23yKZp5/rtgv3xLWTnWX6wov07bxKGZKXkDpkn+E2bnxKUXbCFF0Wq+JkyAd0f3MpUstJ/qSSYexcXVQT4jjF/xPBrvjGHD3uOE81rRmIvdJuAhRL4kNNkIJcaLuwJ5zmrcHN4R0l06tWvUAhTVSj0DIqapxGBKlHP9eIFzyhwpKSfHWt+Ux/E9iEb2OyljJA4VlTOYiJAU0t3UoucRg5adVKBxUTuURkEgf7vAohBX2nwHYxYe/ZCOkkA6kiqKB9UeLeYGEEBKcTmfqCmskJXIGIlhE9Qxd8pEKB3epu5YlsBD9DWWLT8TyfXoxy+32J53sAd4tORrYVP/Xq4lXM6HMm0XB1E/hW56AIRyxFU+lcHm9Tu34CGeFBDJ/pEHr0oDMU6BVD3LDUn87ZrZlM+Cav6ADddpHPiWP4yhS8VY3nTqKKpg4U/GfoV3YeM4YepPi0JGBpQyPNV/Gv7IvESOnnTOJeGl1emcHAlI8zE1mzsNDxsqgBL+J+SVkhyJHvn57q5so9X33QtgptVTfMS/pwmhKCu8MqQMF5xcjwZv7WPd0r+zLjnyxkHAQDQ+Rljwfz8ATFUnuLL9rynQja8G0nXww6sHUmjha6sfZ2fNuglgPJ2WuNaeLoGSo8ExAvhA23mnUagTSYU/BMyp0Tu/VE1VgZPJdSEgQr6cZza6K5Af5PQ2OneCCeyjH/RuwclR3DdTdt8fsPQ/25F8WjQhNxS1Qx5HUjGLnWUjJZLZLFmfybPp/z1/ETnTg6OnBl6ngwGn6YKkdhrhS/28G0wabKGZ6uzsZirQh/Kp1l/xtuuninYEzettDudmETRfsxXewHEgyZEUzjHHeolGYNaSCT1y3k4TUNKQr4Wvt14jbZZsJDtOu/oY/ZRlgRp9EqLX3VOTtVqUyq/iC9QG9KdeAUGz43m4PnmBq+IuoE
 /WsjFxdd
 fTXfWySEaE2wwyS5HBHprSOU9KyOi7/VNwKiaeJbGtg2ieteujaPs2+qKUdvJkU/mEAG3eKA35HDEHU1GroTWVh++pWELY4rM5MS6jtqtpcCEH6XJCBajy52Ozjn7LaIL+QQ5sF+MHwoyXYcDN7yeX5NRuu3zmgs84wZNJpmaoCsvTyLxBKlQTD/sJV9cRf1ybAEpzvOQNRXIRsthUNINXwwcFU2aGWbhV6rlZrUIbioe95BEUFAvuJH3I/t/iCSikWXrLU0cdjTE4BKZniTUNeBLgEsoFvDob6CIuRDWobF6m9sHJ7XfgFpM0EfDjPwNev3RT8Qkzn10IWjdPfNwNXmPwS2pvILFopPoIVD0qOloLFtfioTGyPgYVLbb5vO+S65qSsmaLvGhrrtcsbE/OjhdFQnjlXOoveLfIfRjczSnmsJRyVEHGe2KFunHRTzCvQhxb4Q8NDSAw6f5OCvvyw+WpiepJl4/lIftyOYFxdSJrZXiLPrF9XaG7MtEk5d+J8AAQU7Gpy3bHMgIXsemBKTTOeETZ7hylaYHfuw9E0/cpjfBvEwe2cF2/X011I2WYZWt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.08.25 11:27, Qingshuang Fu wrote:
> From: Qingshuang Fu <fuqingshuang@kylinos.cn>
> 

See my other reply, (e.g., versioning), how you have to provide more 
detail on how to *actually* reproduce this (I cannot) and you ignored my 
comment about the patch subject.

-- 
Cheers,

David / dhildenb


