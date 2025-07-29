Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45487C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3056B008A; Tue, 29 Jul 2025 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B046B0092; Tue, 29 Jul 2025 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0706B0093; Tue, 29 Jul 2025 04:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B68B6B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:52:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51E72113BA6
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:52:16 +0000 (UTC)
X-FDA: 83716685472.09.74B491B
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 515CB100003
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:52:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UR5gRV2b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753779134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puylhfEeh04//TXk56E+rvqvhJy4E6rc8s7DMainMJQ=;
	b=FISMBGi9h+yhnSL42n9Q5ahMmXwa8cukBzlQbXdQuN2H9B6Q2hdu18E+S/kjGswCRUi8HE
	Sqo7fAC0jlu11PlLaxSmFPIJ0nFEy7fYR8RchO3xqj97ps3cnJZEU8rkVl4JAvjaCeMHmm
	Lw96EMFTsOtvJn6UOtOFf8QraD1Jb70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753779134; a=rsa-sha256;
	cv=none;
	b=dgmCVSyqy9cUiipAd8dN2l5xLie9HCfPdmNXiTglJlEwZeeuGAdtxJiCIX+gNArfc1poKF
	6hS7jnK43pHVoIKgRCrDhasRINuuT9YTKq27Sb524+wWCoX/lXbb9YQW+UcNQ5OVB1eTTx
	nbzZT49HViirzYw265i596Y51UO7pwE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UR5gRV2b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4550709f2c1so41375535e9.3
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753779133; x=1754383933; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=puylhfEeh04//TXk56E+rvqvhJy4E6rc8s7DMainMJQ=;
        b=UR5gRV2b815uUZ0KiH/mbIoa8XgMinywsRgHp4ta4aPPzaPl/ZhH/XebtLaDPXuPXu
         D06UK3cIY6/twL5PeE2EPNDOMbGbqkJugXXz19WUY0if0mwEKuYzbHGjAw5hW7CeEWCA
         Y7LSZTXrYHFybC8T3lLUbYXiD4JhhkL24duaiLF+4c+IUs00d8OaCBMb3Wi7lvpGjLvQ
         Z+UGBkxcBcH98Gukn2o54PxoOs7RbYSy+wB1ZMHnXfYxRoGlBMD1VLyM6LRwGppfw2mw
         Ye6MgeHwA8a+4thdr8lPNOXVV26wbAd/DAklT17RWYPh4q4vSgUnLBnEw4xTZfnZNesW
         40+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753779133; x=1754383933;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=puylhfEeh04//TXk56E+rvqvhJy4E6rc8s7DMainMJQ=;
        b=Y/9oI1kHEpkFuFxQvdgadtiCsA6GYxooewI5v3CMQUjqnoOMdPsC6zTvBX9xRVTX7v
         za6fduPCF7sNqGLm/A9sMkU3Ig+qLBIlk0Kzrvngv3FFp0eOpdBkEw4Otg7e0LdkWX8k
         UsyxTQtZEeZxWUJXHXsCMHizMJoiOLUjzhpuhZKtBS57qbjnNhvJHgTxVS0e+7Z8KBI3
         CyJsATL8p9gY7vLaAgReklb/1QDNLig9kypS+ZELnI09tKdQ10+jORXC4UfD2Oc53L9c
         IKy+jtZZY2fEOgT/fYKCeNU+JN09u5GROoc7UOnUCDBPiRy7QYhVtGDuipXSC/Y/+Nu2
         P/xA==
X-Forwarded-Encrypted: i=1; AJvYcCW1ZEwHQolhdiP0d10AkNx8BHl/0bsHXMAnITjSF4KVzT6Mx7SeDSH9khNOjTj84aG8+VhD9CGVFA==@kvack.org
X-Gm-Message-State: AOJu0YxTpC7tFNozNxEr2oCnOfWAHLD9mI+33POcLFplxS1IGjePnXkt
	DSTIcbFa9Vqz0DHq/4vlDhu4g2mPAcM9E4CJ8geudepacBgxhckW5984
X-Gm-Gg: ASbGnctXmuBDFpJJLnb3JauIPUbhj58ag0bQiydxFlC5k6A3TkUqY/sG817k3lQHDoy
	O7NZvAmhryBwlVzrkWit+/tnGGzur4UvQNlsYSYEKpHXpy3Mhs5CBStT/msZsLuh9jBN7B1bTqM
	/tWq3b2RVXnvaMjLsdPkyGcvLo/FWFjWYBWQTEif59u5flYjepbS6pRCCyCp/sOxQtjx24iuyQb
	qsMw2CRbC+3K0HDMXdj+c6iMBql77pydg40ZNVynH4K4WY+7eh8eSp/5ENx/NYrXS0mP8CHoGuD
	rHpliNYcvVbYoLOQf3eoRW/1YCCGisVptFMUxdB5fzhYVTZND8WB6O1VvSrw8KJ2TY+mKE+7KsA
	sNNigszftk3jMLCHnkAUpVeqkoRlni/TKFdM=
X-Google-Smtp-Source: AGHT+IEm4VTiD/JSN689v0JLsMbYqbkmePqxtHqQp6IbEjtW00P2+vOo5p+wkfxwZCh3NLYlWmARzg==
X-Received: by 2002:a05:600c:458d:b0:43d:9d5:474d with SMTP id 5b1f17b1804b1-4587b16efb2mr105032655e9.0.1753779132350;
        Tue, 29 Jul 2025 01:52:12 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:72ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b77e216516sm10225969f8f.72.2025.07.29.01.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 01:52:11 -0700 (PDT)
Message-ID: <7d7eb3cd-db7e-4a9e-8671-4185b716bbc8@gmail.com>
Date: Tue, 29 Jul 2025 09:53:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page pool
 in page type
To: Byungchul Park <byungchul@sk.com>
Cc: Mina Almasry <almasrymina@google.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com, toke@redhat.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
 <CAHS8izO6t0euQcNyhxXKPbrV7BZ1MfuMjrQiqKr-Y68t5XCGaA@mail.gmail.com>
 <da4a9efd-64b3-4dc5-a613-b73e17f160d6@gmail.com>
 <20250729010410.GC56089@system.software.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250729010410.GC56089@system.software.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8gr3fop71earjhabpm79nqocy6unghin
X-Rspamd-Queue-Id: 515CB100003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753779134-939362
X-HE-Meta: U2FsdGVkX18eD5u7cIAfUs4Tp1kHB9QtVF1SeCL/taICeWM0bk3+WD76zX4KdZas5/RB9WagbQ0QFMvclLxhd+RGyY4lfjf8Gq5tXe8nHKcHjUsxqQnE9I/7COfMaRcdx+5Uk6th4AOzHwHGEV9/BR2fym3z6KNnksQ1/bOq9PQfSEdG9qHogH+BjAqFNGnYF2ZBUuw0EKHqb2VVpxKC9TTulfnU9bLVcVB1vVjBlEvbfI0m4f0zpxSQAXZCj5V0dC5kfJqjbAXDS9dd0uSurJs+rhooPEjXg9isUFAYainGZOz2cHoauNB2XJqGIxvwm6NWRfbCZt/VSYkXJN4dq5MiNhFsVEdodmXNYskth2Ho72wJ7CgASczkO7HNWuwT0tJaAUpZgnCPQxSL+c06EDFc2SkkQyoSaFUweVAdvrjt0n82D/qIoGqsJTHo4+sz4sryC7s4wxnmdZR/u4/jYTNgsoTaI9zlXwcUHAGl/EIfq46gG09nYezalfw12msDdcmTkZ2ShvAEw3AdY9Qck4S4lxqNsDKlGZyEmSlJRoBi0mX+e4HHVQCDsmVASsyBmtvuyZwnIob5juNODG1GSGa7qvuKQIKmsWjtsxGo19VMPEKbqnso0/l7ggkXP+o3u+62wiqu4c2nzUxgEjw71nXnpjyxEFKJsKGPPFrD8q+wKX5eDZ45Ahws9TmPylR7emYdOhsrXOGqIRXnXW3wBc03nSQLWAnJl2Gftz+LYMY7ElMRjWizKBX/ZtThQHWRwvlSQTbGFJXGB/pGr/BvMD2sqdfMEFUejDApVCphNGoxwAxdSdL8rHitbanQZsqwBOmkw4IIMKGx4IVx+UJeRkK6KjDBfcHg7iyV3AESrQYamfaKin61wFiaANFkWzKbTglP+9oCduF4RegdGcSQacEeDBt3l7fpF/4566/VkfHvq9EYMX8LVOnDHZSKK9RLeSzFt3PES+WFc6ElDGw
 pviT/J6s
 JD9H22CO1vG/BGAxvgq8o1fE+tM/LoJ27/juvvGydmZzQHDjFfCxfMhw633d3aC5N7kNTL0/cAf9rh9mMFfSewn+t7EMxPNsE6vmBQMu38VkZyto8UtV0yt/rjfNT1rEM1+Yd2qSnvKxm7kcR+XXKsMYoZDas3WPvBhZw81/R+ujwjsBp6wqZbOsnmo+jFflAZauxS8sfu4gpPPuGgty6AvFAuD8GMsOK8+2u4phh2BvsV/LLz6GiV3JAyuadG2hYI+x12RFEWYF28hsOApSRX5oDqNrYS+jcGRKZrxvMnWlHVXHUaPd4rGyaucVIrPZjtuHdvQscQLkASue0KhT3yUh9CGGuqPGcQwun6J3Xw2JYVk8pTWRjavtbg1cbuIwLFjhcg6VMaAMhQdJDO/CVbZVFO7lpMmIoJlgvzrgi1/kDJY7Bny0SwMDQh2WIvPuXAEBkfSPdTrO50GJH6XutbYI89fzj1mtaVjSEfG0pgmBfrXr+csH+L08KaAV2n3qH2/rxlUZOdLXD9ZgPR/O3fW6RkdJz7bWDsTgpBywU7H2mkPM2ETjo52wAQL9ij2v22q0hgxT6u3lWSxTdC/fmEQupuxly3+8b+PPGY8JfmfeqBR8mQschnnuEtDAt+uMQTdzZhwdmd4/A9+ehG3c7nTN/de12JEgYvtyeCVt4uSroCrjdSUh6haLQSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 02:04, Byungchul Park wrote:
> On Mon, Jul 28, 2025 at 07:49:30PM +0100, Pavel Begunkov wrote:
>> On 7/28/25 19:39, Mina Almasry wrote:
>>> On Mon, Jul 28, 2025 at 11:35 AM Pavel Begunkov <asml.silence@gmail.com> wrote:

...>>> This may be my bad since I said we should check if it's 0 initialized.
>>>
>>> It looks like on the devmem side as well we kvmalloc_array the niovs,
>>> and if I'm checking through the helpers right, kvmalloc_array does
>>> 0-initialize indeed.
>>
>> I wouldn't rely on that, it's just for zcrx I do:
>>
>> kvmalloc_array(...,  GFP_KERNEL | __GFP_ZERO);
> 
> For net_devmem_bind_dmabuf(), __GFP_ZERO will add bigger overhead than
> just assignment, 'niov->pp = NULL'.

That's not a place where you should care about zeroing overhead.

> I'd like to ask you if you are still good with __GFP_ZERO overhead
> before going ahead.

However, it might be easier for you to just assign it directly
for devmem and let Mina add GFP_ZERO if he fancy the idea.

-- 
Pavel Begunkov


