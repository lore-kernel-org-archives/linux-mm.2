Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A59C87FD3
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 07:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D246B0095; Mon,  4 Aug 2025 03:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE096B0096; Mon,  4 Aug 2025 03:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E0D6B0098; Mon,  4 Aug 2025 03:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 652176B0095
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:43:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11E97C0F6A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:43:11 +0000 (UTC)
X-FDA: 83738284182.03.21A6B40
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 96AA940011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:43:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KpgYLb3s;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754293388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ee51bhVRgXR/LrdskPcsfNsnddOHs8GW6sYBGb/h10U=;
	b=o0KI9taXe/QK06NG7Kkq8PFEqxDypjtuRsJ1WdsTcH3Yz3ZGrZie94fZAeppKhDyVSOkyz
	fDzWf5v3Nziwx275Qry105CWTNOibNlPHC5FnJ+1G0RT1q8dl3HQxv/hDZ1aSn8BS0RNJN
	LoQemgC93GIecUn2KNBlxms0b7OaJik=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KpgYLb3s;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754293388; a=rsa-sha256;
	cv=none;
	b=ZNShqoGyXkhXKAtYti30UFyrCr/ANUSbqi+Ym7RGH+ym3ghTFSYAEWKkQtAZczym4PLuY+
	HeSefTtPC6FP74EJYdsZogEaRgHWdRSu4RX24lgWPJIiej0s/RGLTdKlJgmY/D9Gy/epQs
	sNV9oqn+TkzS2SwbdioU9E4958c08A8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754293388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ee51bhVRgXR/LrdskPcsfNsnddOHs8GW6sYBGb/h10U=;
	b=KpgYLb3sPLVJZdHxnIX1FyBjc82GTxKFOdY8jQjhjLcddD9JXtL1nGz9XXkDfF+dl8UKRk
	buE69UCzRrTYSNIsn6/vbTAFIginNlCOwdu40UfEbaZj7B48nDWfZ4lZ673MpG1jDSAvaG
	OSKNBiztD5ZUa6Fw5jTlEGHpyaUzXDI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-2DST8QZ6N46itwZT_WkYdg-1; Mon, 04 Aug 2025 03:43:06 -0400
X-MC-Unique: 2DST8QZ6N46itwZT_WkYdg-1
X-Mimecast-MFC-AGG-ID: 2DST8QZ6N46itwZT_WkYdg_1754293386
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7812e887aso1004816f8f.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 00:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754293385; x=1754898185;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ee51bhVRgXR/LrdskPcsfNsnddOHs8GW6sYBGb/h10U=;
        b=trDuKd0QfcbyFVRjPyx7S3+lkZICaF6gQKdekQf5W/p9qn+OhU8QSKKffxxkc71Y6w
         xtX3ixIQ2hckVzBN0DOXDVzXheqfo0NORUJwkVSJDvPW0zmIRM74Vt6hRmRpUp39bthF
         loX78QE8RYl+Dwedqn0ymj360TGS6FX6cRA9KcQxBiZeBpLN2AbCJyI59q8WQCdbkPvk
         FIV5MNbhs5Qnx//1e2AmkACXrHzuMVoEAtMhm9slywsV9zOZO4wZ3zSj1o36pe+awJeb
         evE9p9V95o7ki+GObkASlXH3wys4ICL0ooFvR9rbfSyMgH/V+sJsD4F6y9+MQIf9B4uR
         pl/A==
X-Gm-Message-State: AOJu0YwHk7pMTTCVprCv1xlZfCpz6eNctYc+/+SCFDPRqznDG4QFNQTe
	mflXbdWCYeFYGLdhOucgM+CDO/PldkqpxUsSR50KBWpqf6z86RKLA9z8liWeA7Fb4Rga1pkSpZm
	HhoTenxerhtb2jWGchi2FY6D/bO3tKbVRlkCJmYXOgY3cdca3yCwp
X-Gm-Gg: ASbGnct/IoIb2VPXPNievqgAEOhjHVGv5WzNoGOJ1Nov/Wm22u0oh0DV6rkNsIXZjRQ
	7T8E5SAexJZiD4nDQpO15YDzQM2GWPcQWyqJy+BCIW1co4m5sKM30Gzxd0udTvYAd4xcYW1MEg7
	4C+Aoq/ryUhXlkf4KIKUCq1szyOtbeiNKznwXgo1v4i30azkEu1OpzRvstNYSUhj26qRKDNYOOI
	VKYBn25Px58VOZAxIctB4mAh0RDP2NChzd/Y6ZkIv2UZeWXJt/I4PPTN+1hkviPaQMX+f7kguwt
	rrW1ubfZ8Tf7IAvy69sEZpF7qvKZMSZ+yA7ywV9yHSYulItumEj6pOBheu7YGAzAOQ5NqAyGDoI
	A83LZhTpGZRwSGiMYzEzJfM4HD96MmLA8xw+1fvIfCTWnniQPQ4E6QE+wwaxU4Nn9lu4=
X-Received: by 2002:a05:6000:2282:b0:3b7:9a31:2a10 with SMTP id ffacd0b85a97d-3b8d94ba17bmr5437937f8f.41.1754293385559;
        Mon, 04 Aug 2025 00:43:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIaEJ5suc8xb3Ad7mW9Ipaw6zGJALuh+g1hmUJnRpAxJe1oc4nfpMYbPlfqd8QoLeicduKRw==
X-Received: by 2002:a05:6000:2282:b0:3b7:9a31:2a10 with SMTP id ffacd0b85a97d-3b8d94ba17bmr5437921f8f.41.1754293385087;
        Mon, 04 Aug 2025 00:43:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589536acc9sm201876495e9.6.2025.08.04.00.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 00:43:04 -0700 (PDT)
Message-ID: <d297547a-a0f7-49c9-8d5b-5e7d6fbe1fc9@redhat.com>
Date: Mon, 4 Aug 2025 09:43:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: do __folio_mod_stat() in __folio_add_rmap()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Rik van Riel <riel@surriel.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>
References: <20250804064106.21269-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804064106.21269-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Uar_jg_ygJ_B8nj58KyRUunj0_oDCQJZmBGP3sPOlQo_1754293386
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 96AA940011
X-Rspamd-Server: rspam06
X-Stat-Signature: fuak1cmaph1zp761ko1ot1qmfbpkjemk
X-HE-Tag: 1754293388-805554
X-HE-Meta: U2FsdGVkX1/pd4RuiK+pGuxdcQa1aFfMJMS0KBwy7uRfI3Wl/5HkVdx5+keU6nOyN5Y6oM+9vLbtD8alZFHSnsE9FQHYHNUk4PfY5p5eqy+PXFZTP2nTbryfaEpA2xJuekyBSD1I/d5A6R+096bxBiYUGoEDjDEcCe4gyojUwHZfy4m/MEgfO36yNAhdfyISa3sqDf2c7T4zXug/21sYG9gzCfMb4OV8S6eiVp2jZXVj9KsgxBqT9e874Ngn/ZlgKvOtBQHuaV1jIY4d8gOwDgs5af3CvIRH8HdRnW04yUEsYkbGdoAgiW/ez2YgODigoGUJi2MEtrVRybKD2/CGzQhmM5rOQbamcR3mseHj89nSWiFK8DjUG7nDlqZnP/CloZlgrXEDG2/DbUcx1viFaXK4yce/dV1bFR6C0GxkIjidBjt9qrNAjgs4lspa576bFoDvvQk4iGfDU+/2ue17Vv3Q8NrRqGrrXEmBqJF8EpZGAS3g/hZO8SaPAIRPArwtYZEp6bul+UrkJq5ocbTBUUTPVHsGuwSTwykUpgDrCy9boHeAKanE430a2sOjkG/tiolUADtzvh1Wy0znf3vsSlCq3mpr8x81M5fMTij52ds7F7LbusMwoLXZ41lLc2NkVYGoHtIXHcWJsOzGm+KMuXdwRXgE0gAGHdE4WID2wZIV5hK2zfuJWKDJ80o2HlLv7IPgG47+af/63/6Fi3hI/s6JqUgUP8NlBMIoHY+6r7nGntNROEW2unsn2oAZD3ECSLB0wZVZRGH83jA7wz/k8alCz9j5fMTtWwRhWFEYgLHFD3rvHHDKaGaeNA7tdWeZhck3QqgJlmuWeUggpLmCVGbKhejs9eoQMfN5kvnAwM1TrwSAgT1PR3Zl8lsmEg/K/TJdVBKVYUg8FRnll8PcyZb0M5CUG8Vf/3Xy+ZcNAeZsX7iXS0Ns4iVKVbcEl0K5fNVFFEdJC8o6Fj/qD4F
 C4/RP1RQ
 7lFdK9q3d4uSmZ9wemQp6KXvfU4IuHbNF1iR6TzONJW3uBQkgI8n0ipa5Fz9jYtTX2ET+0IauVwDcv88QBp/K3doTS90UTzXdZ/uhHdjF51xWocSr1uT6NiLAE882C0eqiE2sRllYXI+z0gxsUgU4TRzjYk9bpRghIJjswelOGx/Iv/4WvZA2iQNVCvUi4BsGOUtVbw71734TuJryUHgu+DOozi4+js/UN9pNvBUWF0s/qMbQyxvEN4+0q+qXY0JDlx+fEbtdinP515gZuckmLkdAaH6u7m5MdGxdCuIdtFXSNFnIXEnoLzuBiMmx/V2ZX5CunD5q1nz4E0fDcedU4KfTS0RHJAHV9vwo6t4Dez/nYNH3NH0Nt2IzSD0nl/c58LeZkEmck+MGxAdkPo4WD9twDhK/3TT5HbPicS5wR8rzWMcUQAg+dIoFVtzUpQPdcZGIU0uJp4q71WH8olub9tNmpRCoQHp33bSgQxtdYoJQymX89RBA/mP/vjBlw+Sak1E1CzfMHJlPRtVpSOimjwn8/yS59kYzyytntEw1rOvVMiBL43tXrcbQtkA8HXQJQQKqzmZcWpPX0BP4TKMUSvMsIlAyeDE8jcNoLtQ17mlzcbZqc2JYZV/8jhwFTnF9LpUnLk0xA/fcGzgnQuGgu9X37ZEF3imkh6DyE9Ll38USBTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 08:41, Wei Yang wrote:
> It is required to modify folio statistic after rmap changes, so it looks
> reasonable to do it in __folio_add_rmap(), which is the current behavior
> of __folio_remove_rmap() and folio_add_new_anon_rmap().
> 
> Call __folio_mod_stat() in __folio_add_rmap(), so that rmap adjustment
> family shares the same pattern.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> ---

Looks cleaner and nothing jumped at me

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


