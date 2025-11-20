Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34BBCCF857B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 11:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B406B002D; Thu, 20 Nov 2025 06:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F32C6B002E; Thu, 20 Nov 2025 06:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F266B002F; Thu, 20 Nov 2025 06:18:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22ADE6B002D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:18:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB8BDBB9DC
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:18:33 +0000 (UTC)
X-FDA: 84130737306.08.4779A7E
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id BE68C40014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:18:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q4rGwhVs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763637511; a=rsa-sha256;
	cv=none;
	b=zqcY5bK2GxZks9jk9QrQoeYiDUAaj2a+FM76bosrk3b+SdvaPjZrW0rBZL9vFi9XgFgnB3
	qqlFPvWLBKS1V/jacVT7G/6gMMCNjZuHY1TZ8QuKhuupvAk97C5ztS7rYyEBvHWgewUbM5
	LWKwduIw+2otWol5OyWc9TNJPPIegRk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q4rGwhVs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763637511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dF/pjzfYykuLtKaPyJMWY8rSAkFJWU7DY4gOk+0f57c=;
	b=oLJACzYhihD3jyQ2Ix5xsDvqSY9UyC1uBDf2FHs+V3vdzg0c4U1UKs99euICR7faCPTYdE
	3lTY6X1pN5az/sk5M8K9QdGRuY28XYaGsu8/Hv67t4WEsnUVCaSuQ1uAdAqcOkq13KrKq7
	ykmq1P0l3TeHBY7L/m9E2ibYJG/zg1Q=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59426cbaf79so88508e87.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763637510; x=1764242310; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dF/pjzfYykuLtKaPyJMWY8rSAkFJWU7DY4gOk+0f57c=;
        b=Q4rGwhVsW6ZkWEF43DJKh5IMBD/VYo7DALgpt7ReAHp9SOc6W+kCsAOfzxlGu6C8iO
         In2lTAZJUV6zCApSGCd9V3ccnAajzJARwwnJIxyYAZVUUs2OVb7NcTxZNfi+SQoc6YyY
         dT/WsNNbjyH34STd+25TIER9E01rUmMuP10mD7XLaW/heduN/ERYI8eNPo+Eds6A6Ng8
         SHNIecW7mwBXwL7gRNkJr4z4KuKchatAQ8iK+60Seg7SWcNitbYnJOG0VPaFcdpFy7Bs
         rpX4zYBSnmQuXBp+5o3chgnbomYAONFJiXIXU2RKA8rDlBjKNMO4EbxEDk+IgA0wHHbS
         TYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763637510; x=1764242310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dF/pjzfYykuLtKaPyJMWY8rSAkFJWU7DY4gOk+0f57c=;
        b=dbA+Kn4Xqi5YTX1TCo/hDdiPejDqeYLvf7FFO7zR9cbREhmCYD+yBfiNrkPPQ8CGlj
         lLRimUQElyCrTwwQ/nio7fffX1ybKqx4L/FnCg7F5wmNqWIALkX5uOp1ohKypCX6M0jA
         iFOIRiAzU9aKiBvWvpyU/ZEVg6vYYL4w2sIvN6eRWKuGJzFJQRLAh+XvrLb6BtbyZkWf
         xjHfOVT7Bwgv7fyExD/sw2ojgfUNwCdYCsYECOt6WSCFIGI5BjJImzaOuauqo2suW7LU
         QlDD3HglBhJOweMEtyovi1MxCRvCkPpGjyFN031hxYUXRa/wZIzBm88yXsPSWRT/NqYr
         CZFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRU726srMVT6rhiwmzcZN6q41aBY42H5r/eNBFn/4bWoLVyZ7rcyPG2bo/3Vk79yPFUfUCmIYb4w==@kvack.org
X-Gm-Message-State: AOJu0YydKT83EJXYKodvl2ds16787XbG9c8Or6w9dMSjZCV/NANcyiaY
	Mtc4vNTyEtjfk6+pI5zpkrAD8WDpUDa1IO6fLXn4Ql6A3v8dq7sIWDag
X-Gm-Gg: ASbGnctFLkc/cE77xXcUURHuTx03NULtbBGa7fVvofLgpGLM8xH/ks3xon82sngzPmF
	DLnmjPKTVM+jWL9VRViUN7DVHq5QOWG6MTwlmzfxvCABt96hE8TRczvqp4Yhxh/wPreuB995uU0
	SnmA0UEwYu5BuwRX9t4m8GoQDVhlLpD+V8KM+COnGNs+07m6FOFiZLkpLORxtdXmRxLjET7qXXS
	OTmKza+sj36S88Wx6ssqL+46uiqEXQkNs9Kbl/UVWLkFABa2kYcvJr2WALxxmT18id0I56tM25u
	kM8PKLe6gNFuQHUStppAKZzQizpVIqVV4J8/psXGUb4f+LxBNomY3Oh5jleALb1Rburk3BTmxyf
	t6R0M5/3rn/N5r7QUfGHcPKTdIFyDM6WbSr9R+2QNtwF/Cmy4YYIPzCRc9QEdizQsHUaU9z7eH7
	QPxD0q2AASDp98/qNPpt6ShO2JPJdV
X-Google-Smtp-Source: AGHT+IHCR6Hf7N1ShRtL3lk0u8guzOoW4/TZOFCA7Eg+GhA9B86BxUjN3JLFmeMqJd+MnnQjrtVoSg==
X-Received: by 2002:a05:6512:3d25:b0:592:f3c8:39d8 with SMTP id 2adb3069b0e04-5969e316a89mr487099e87.5.1763637509408;
        Thu, 20 Nov 2025 03:18:29 -0800 (PST)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5969db75632sm601938e87.9.2025.11.20.03.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 03:18:28 -0800 (PST)
Message-ID: <9e066a2f-28fd-4da7-bca8-c10f7b58f811@gmail.com>
Date: Thu, 20 Nov 2025 12:17:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mempool] 022e94e2c3:
 BUG:KASAN:double-free_in_mempool_free
To: Christoph Hellwig <hch@lst.de>, kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
References: <202511201309.55538605-lkp@intel.com>
 <20251120072726.GA31171@lst.de>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20251120072726.GA31171@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BE68C40014
X-Rspamd-Server: rspam07
X-Stat-Signature: 5hm67yebsthxyiomqzr3b1zanpaw78gu
X-Rspam-User: 
X-HE-Tag: 1763637511-511121
X-HE-Meta: U2FsdGVkX1/gPY9FJ7XT2/2U2tq7mPLpoKDUa+cFzQh1syUaQGM3xGDPikv2GZbbn/VG+jwFyO9rw8SzvWZiYOxQLG6lZd5xErZ558azuYIxncBMto/QZQS9akDcqFIRkUJDU/WnX3IVkBnqoHJfit2VNt0lv5hEfYzuI5CN2Ke1g/P+lix3K0f+BzsOwf/gb6PZi3ZIZ0WMohLfsdWBefAf/Z3o0R2tNTGMO31HFj/OldZieiijYW55Ks7cIA4qkYl0orZ3+ypfdJmcwbRnqPzCIGUxTKjK9FpgQH4V/x7srT2HS3oAPxJhUIbGQWOBCzX9UBMHMFRCDpQ0yHLxmnJq6eEo998rPyDb7leJiRY0q4agGTwHcgHGj1soo7ef6FR3g2bXZ0dLUWb58Upy4S0/VLKeEVU3O1jxv+MQs805GxqgOWhM6hg/V1MnEWJJiyJNvFNzAZ8fzga1GQ4G9SL0PnvDEqg3fvPjFoOhxT5Di8TfmTovr6RTdBxTBdUkaErtLzSNGtzpqGwhQ7ZIcx+snrA2QU3L+zJtODIzyxSv+tbU8U9bLXdhVWmpLvpWyV4g0PaJnRwXerAkrMv8Gu3OnwGtGOExMSeitXDkOtKPX7kdbqT/BJQNz9CEU5vpWMxdTBiwRFYwY4Gd+0Xo8tL0rxsZ2ypw26JsSebF2COOHSGfibzfHn3j0e5emMw89+2EG8umw2hUxz3CrJ0SLCeSA6ZJHZNx6ZScLTsE+88TmhWRQffefiZQxuWB5OP7O8r6GfIJA+YPMw9FCvgrzwstS8aXQ5OsEBVgxxB8ZGsvjiVWLVcKC9NyjWfXz+qpUhtaAdmFqC57+XP+I3/0RiT6UZYp0/R3FG70uj7Y8eEOmohLigqFRJJKdeams09zxhTk4/UBns4WHHIc6MJ48frjxwYwrCswpetfbF2yx+onv4P2BXZgrBSEa+UPkeJxYKWZczuUQIThngNeLmo
 KhtsGCYp
 6ZNCD6ojSP4bGAxyCWtOXQE0ujRiW5PuHlhlEqhEO7J1PbF6O1qRgWpeJBgIRAxkKHUVVJ+ovJapBq5oYOJgY2No7hlUgfDA9NxIZEb1eQh3QBGjAS6no+om/ZML0w5KoMiYm5DeFy23bIUSaEn+9azQ92uOewOv0ZKgTGY3Q+nFXKfeFq7I1HmbqOGzgp7eEIDkLPtXsSO3Se7BQyR6NbQAeWL39LpX6dkY5fEzDikGUMM4yCQCREueXHBUFwbuymSvNmLU6wwO/ou/QIhj1tXf9r31veK8USYpv6HeAfDwGkr8t6cuCGOgnFu/LdyFY34TpeOrcnUxfWh0VlXk8YKyeY1iaySpZ3dCVzkDjJ/nzvqM4HrdmeoiS4sKDEKVot0qh7t7JQoOB96e+tmBKxBC/jY3zamFMtiasTqgOkbn8J9H6E+mymlz9AXO0Nfqkz3X+7LNXe3c/T+21Crg5y8C+qHK2AJ52UoxxI/apnZH9UL28rdj3hVyW2oFH0kp1d6enGqInCkhQeCM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/25 8:27 AM, Christoph Hellwig wrote:
> Maybe I'm misunderstanding the trace, but AFAICS this comes from
> the KASAN kunit test that injects a double free, and the trace
> shows that KASAN indeed detected the double free and everything is
> fine.  Or did I misunderstand the report?
> 

Right, the report comes from the test, so it's expected behavior.

