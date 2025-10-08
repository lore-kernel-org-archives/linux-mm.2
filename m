Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C48CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37D38E000F; Wed,  8 Oct 2025 11:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE16E8E0002; Wed,  8 Oct 2025 11:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9158E000F; Wed,  8 Oct 2025 11:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96D328E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:14:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2716745A77
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:14:37 +0000 (UTC)
X-FDA: 83975293794.20.52B522D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id B54861C0007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:14:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XS0LNpAq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759936474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+0tHTbYNLyy/uNCkOecrm6JI30eU5cWEMyPpwmUNBE=;
	b=IhNkRUFJTIg+VnLmXR25sXS+rJTTtczSusNL3+2wPeeek9Ahgaca+hopptv0FGqjRd8k9P
	n8rPxkIhW/NwEa6u6iZfiY+l0Ilg+ewmdeSva4QjFY9mMW4WSfhft0VlH5gjzDrg9vJT7V
	scMuDc32Hw5ovjMPxCV0/hlxGOFFI/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759936474; a=rsa-sha256;
	cv=none;
	b=RPTx0STTtl0ojj9psst8p4CF3NqGcJgI+BwqQiQbpuW+wDssuxf44nFQlyUNG4j8By/1Nh
	V5G2UW1B97Aq7ejzIuQbs+45Hhzz95AW2Bl1W6684gV8cvmfirE/f/Qbx2W3z7wqyf4zz9
	Kl09A82FrXYJyP0Lek2IQ33k3U+9sWk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XS0LNpAq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759936474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=v+0tHTbYNLyy/uNCkOecrm6JI30eU5cWEMyPpwmUNBE=;
	b=XS0LNpAq/+cHxYZJE0jLLOljmTog+FERWqovoGXV7xl+1WKwQ4QAdj8+LFf2sY8aL5aFKJ
	G0gPpTdTHSMk2sKgPI3HsmBfEImMl4IziignHLo86Qtyl/YdJLNOYu57jLIPCCg+0en6BZ
	lBHGscnI1Rt/2R13gt3YDY35wj4Hx1Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-we2hqPSiNlqJgQj02I747Q-1; Wed, 08 Oct 2025 11:14:30 -0400
X-MC-Unique: we2hqPSiNlqJgQj02I747Q-1
X-Mimecast-MFC-AGG-ID: we2hqPSiNlqJgQj02I747Q_1759936470
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42557bdbe50so550893f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 08:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759936469; x=1760541269;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v+0tHTbYNLyy/uNCkOecrm6JI30eU5cWEMyPpwmUNBE=;
        b=X9oRM2B8xRN8SIL0Zven4c7DckA6BaCYQqLGqx6B0Cc7xum+uAEDKZ1n2LQXaxbAoA
         08byuw6LgIzuggrWKUs7NrlXFRjC7PmLnugQ3NQAH6+iRCYaDjuY8DwGJrf+SbEPks2c
         yEnd+/13CNoCxZUQeT25ltHkNwuhQh+fiZvqbXtbK/aT85ahobgVCzxSFcHjxAEImgAa
         Th7vY18QQYleEME44qWYlGTyVP4+m6V1KKRXd1y/3yfre4iUGvfLsPGQRTARqBHYx/E/
         tz4KVFK0+dfjoYDFYAgYj+Cb+ueRw28XkVPEkoanUF+BCfQ5MHegfmDUwekMT2LxHkQF
         P/OA==
X-Forwarded-Encrypted: i=1; AJvYcCU0yjx6mjsOEo21g7GuwhXWZR5C7xqHpVEFcYdmT8msxgZQx28YX1/sRai5iF9TW9Z/hYmVcGHGwQ==@kvack.org
X-Gm-Message-State: AOJu0Yyb8zHT46TjKHujOBBY94XMONaFTO+jJcRUccIl3j7lUPgYaXBP
	KhR1ddos/jQVB1pce+jNJo0inAy0pQNjrOTL01Xq7Ynlyflhrd95Kn5UtkBiMkVAyEaIEGTjq2a
	2WMf4iGP/JxtOLn/JQgF8igSY27hTLR5vPT5K7wV7MQNTv0K0fTUZ
X-Gm-Gg: ASbGncvpBIEQWrJ9SGpORWPYjOsPn9odSUoiM4JrwsZM2R6fFfKWTbAlNao1g8fdrMp
	sj6Qh0OFgYwAkfaz22Aa6VpED9JjITcJR2UtItM/xYiKekmPWtSgdkVu/YpkD1uoHuTu2Ze5JSE
	rMJt9yfa9thGNpD6XnwMqOSHv03qakH6hCPEiiU4UvNOScQrKrSEdaitSL/4Xm3DT6nMTSRwepr
	SFHn2IzTiOgx6OqFTFnhJmzlMOvGctP8g0V00HbaCZ1LJjVw129c3wrrVog0bikhb0sqroXPBUk
	U1QXK1Z/lp5q48kxpZV9u8OFULAbo5y2xSvtiCDtgTXU9gnVeDBbLjcFbdpGnWnh5eseXRFboS8
	T7DN3021J
X-Received: by 2002:a5d:5f96:0:b0:3ec:42f9:952b with SMTP id ffacd0b85a97d-42666a9e191mr2772400f8f.4.1759936469624;
        Wed, 08 Oct 2025 08:14:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG22vJDbZMGyFhB6b9FW0kGmBlLTgjeKs34KZwmyZ+I1S9kY00Ouo2PyuoPztwdlVe6iSg06A==
X-Received: by 2002:a5d:5f96:0:b0:3ec:42f9:952b with SMTP id ffacd0b85a97d-42666a9e191mr2772371f8f.4.1759936469201;
        Wed, 08 Oct 2025 08:14:29 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6bb2sm29576337f8f.10.2025.10.08.08.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 08:14:28 -0700 (PDT)
Message-ID: <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
Date: Wed, 8 Oct 2025 17:14:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
To: Michal Hocko <mhocko@suse.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, corbet@lwn.net,
 muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 hannes@cmpxchg.org, laoar.shao@gmail.com, brauner@kernel.org,
 mclapinski@google.com, joel.granados@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, David Rientjes <rientjes@google.com>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <aOZ8PPWMchRN_t5-@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R_JyhYpb36jCahbGSdFE4gOnUEJpvj9vGeFAGSNE7mM_1759936470
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B54861C0007
X-Rspamd-Server: rspam02
X-Stat-Signature: 1nfwq1fn1hpdhx1omnrzeumqi8iggke3
X-HE-Tag: 1759936474-889924
X-HE-Meta: U2FsdGVkX19jBGZ+k/xKN27D+A9I+ZHSu2XDJUNJ1tkM7y+nwW/3CY1baqvMVPARlm8+azzvQ2n8NovdZiYbJ0X3knr8gdMGKlsLdhwHyV53mUH1PPH3wzGa4Wz/0h6bwcZ5ZXDQbyI6bf+Kx4Hz/s2iaKrHEdaM1r2PEaGTTp1CkT4WUq1Bae27gl4Q3xs/HEuxg5wa1W2U2Odoz7YMiTwcQFDTvSRzNgoR0fm2FEIFQu2OMAee6stVplevgax6CKR8Wu3zesiljz7s5bwBjqp/stwEYr0AcpuKpdrQwaEowHm55oYcs7mQtYBxY7upVtMw32U/h61bU/xLkXKPU9z/3utp5tSIRQQvIMHvgTc8bnEW1E9qI+2b+oGpgiWvPmYtI1qu3DNibR3Y160aToVY19FjpfXC+yBWoGvROt8NhowxUKgrA+8e6kP0NF6iDWgcslnuzk23uimSQEYK4ZZKXxCcD9mgByu2N0LGochucyHQ6CRMSd7t5cNoyoak6xC9mACSq0rp8VOOqZID5KaG8aSjKaYtA81UqlpIQzaZCEjv1CmqilL/GrGo1JHoogv7gnPxnioL4OiEfPmMXOiVmNZRGIqXaeiH1B9rYWaJYrr+N+ZYyWR7+iPRcx+Qks8ziCogekaQCzy4CwCmovuz2Yi6Zdf4BhxKt2SNmeReFW2QlVHpYLm9NfNyHm2azbmVD8C5YexpqcOYg8FTUlbw0xrUDaM1rpClqN98EH8cLKM7Ob0l5drS7cNyz0vagzDIu9JB/K07v9n0LSHZPA3K2KeNzlj0n6H5/JtQ8xEzXv3yK/+svJ5yNdgxE6CcPshvv+jAuvWiNul6AHm5L5ZKVbV+BKlmNq1QxWDSFBkUZ8u5o4gNyC04CGhBfF81X6FUS75nSDBpwKZ8M17ZIdBvt5FkIag1fUi7Qoi1zNxEv3dW6EYaNVFfnHJxt692QhmFpqiP0GCuu4GrBIN
 E3QybZsy
 /+KKXMpIJfoc9ESoGLbk/MbXZEdryZV8KVKIYKxp5oVCe451eCshHusxg5WNJGtMav0N6TDm2pOmXZL5DFKX/kLbcMx3znL0tVaMRB08srcdSjHRaI5GEQyzNFGufMS/ktm7+GkM/ExfFHigfFEcV5oHuqYEnvWPdNPspFqgHZ7tDADfOCMDa+9lF/WiPe6jnQ5w6WcNZxtQnYDIYRR7zt25a/cCv1QG9aXP7sZhG+psyJuFBNcjR6ZXY1FdwjG4keTgELJy5rJhevLRGyXezuAer1RPES+OhUSi1hqVujOYwyYTmReGFOMpeh0jzRCeRwUvSA5os/67guC6JulPjXSTnXjf9cqdrNIprg1YpYGkwJiK5qcIFRkK+0tKKRrS4/4M/RCxgj70v3hCFtt8wlUGSVuj8UxLZgFS0kkRV883FuLxUD7koF5cy3um3QOE3SZ2eD7h54RacbeBCgd3RZp8C70GfePdY6GCVRvkMvaxd43anOrlwDvjPkeJlSwNoxabR8uNSvLbyYEjM4dDRO44vLuoGK95EWrCwT2Y9cKUyayX/OnPE1HrbYam8aZGplmrC7PxZGaoi/bMnrTqQMdipIJpjnQVT/pRcyFVgqoL3LkQxnGG3zRVg5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 16:59, Michal Hocko wrote:
> On Wed 08-10-25 10:58:23, David Hildenbrand wrote:
>> On 07.10.25 23:44, Gregory Price wrote:
> [...]
>>> @@ -926,7 +927,8 @@ static inline gfp_t htlb_alloc_mask(struct hstate *h)
>>>    {
>>>    	gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
>>> -	gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
>>> +	gfp |= (hugepage_movable_supported(h) || hugepages_treat_as_movable) ?
>>> +	       GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
>>
>> I mean, this is as ugly as it gets.
>>
>> Can't we just let that old approach RIP where it belongs? :)
>>
>> If something unmovable, it does not belong on ZONE_MOVABLE, as simple as that.
> 
> yes, I do agree. This is just muddying the semantic of the zone.
> 
> Maybe what we really want is to have a configurable zone rather than a
> very specific consumer of it instead. What do I mean by that? We clearly
> have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
> zones. So rather than having a MOVABLE zone we can have a single zone
> $FOO_NAME zone with configurable attributes - like allocation
> constrains (kernel, user, movable, etc). Now that we can overlap zones
> this should allow for quite a lot flexibility. Implementation wise this
> would require some tricks as we have 2 zone types for potentially 3
> different major usecases (kernel allocations, userspace reserved ranges
> without movability and movable allocations). I haven't thought this
> through completely and mostly throwing this as an idea (maybe won't
> work). Does that make sense?

I suggested something called PREFER_MOVABLE in the past, that would 
prefer movable allocations but nothing would stop unmovable allocations 
to end up on it. But only as a last resort or when explicitly requested 
(e.g., gigantic pages).

Maybe that's similar to what you have in mind?

-- 
Cheers

David / dhildenb


