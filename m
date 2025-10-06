Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A6ECCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8A78E0009; Mon,  6 Oct 2025 02:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88AF8E0002; Mon,  6 Oct 2025 02:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50DB8E0009; Mon,  6 Oct 2025 02:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9033F8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:46:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD9DE1DFFAD
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:46:44 +0000 (UTC)
X-FDA: 83966756328.04.063C6FF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73E1680009
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:46:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PlmsdmuZ;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759733202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EVi3IC+VD9OTyIfuQoplPqPl1jhS5tZPWBqrRRN26A=;
	b=Sqyk99lsrW44GnG1T1myBadHBdZa8LQzDS8hVGK2a6v1EQNfjPq+CRQ+ZWYCHMxjN3kBPi
	e81AhG0OB3uEQMKWJksAG/y/V9oPylY7gRmDN7DRgPmB9FnNnzNbKrE1tFrSGvNBvqw7fp
	VFu7ouRZlQtcuNkI49LJ656/VEzaUDk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PlmsdmuZ;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759733202; a=rsa-sha256;
	cv=none;
	b=WgNjtYHyIxW+n0HbEKVwdjhbgEzN/KYVfDd/KR9havizGDL7SopafGrmAvPIvaITJlxj6M
	oR2QUvMDNTsZnb2Bio6lCk5IzZ33yL3zECElrLILUeqBWL1Ls5ZiLpJXuB0XJ/45spPCi1
	Lj3m7D1pPPENq5BVMJAd3qJb7vN3AE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759733201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4EVi3IC+VD9OTyIfuQoplPqPl1jhS5tZPWBqrRRN26A=;
	b=PlmsdmuZxsk6kRG0fuUVLZ0mJvsnogAvG89tfI+GGbaezxSMQN6Np71UzD8UPRD2N3m/Lm
	e0UixU+3EW6mjGLIjCtw7nHYjoH5ze158r56ZoWF5+EtK+4ddVTvCjELeEyfrPrRhewfdP
	/ylQoPgsj6YKKT92APAMf1ZPjMGA5M8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-xQkjadQENf-sH-F6dVkWhg-1; Mon, 06 Oct 2025 02:46:40 -0400
X-MC-Unique: xQkjadQENf-sH-F6dVkWhg-1
X-Mimecast-MFC-AGG-ID: xQkjadQENf-sH-F6dVkWhg_1759733199
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e3d43bbc7so16645125e9.2
        for <linux-mm@kvack.org>; Sun, 05 Oct 2025 23:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759733199; x=1760337999;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4EVi3IC+VD9OTyIfuQoplPqPl1jhS5tZPWBqrRRN26A=;
        b=Vc4PWEA76y9jOIXsxj2pzGDkiNo81ykfPYiqzywVAQOKAW2DuzJsB4Oc+SK8eya8i7
         WupBaVZieGcu4McPsleytxSPjAu/gF+VZhGwYwTN8VjQvxRvZzRvRby60w6oZcBEEvf6
         AUO+SYR8dF2FCxP4/26Hbj4kk/p11xh9lR6RRbuJ8OMkdr5Jahf1FXhtzpmopFoWuu6D
         SLN/Vag198v1GOBPQIsVMei+V41tUdUqWozxiZ799RbSJKcgSySHULCQomusojn0xk0r
         44mlUHRZy0lrgSse0wLRQJ3Dg++51LGnSZfwNCOHM/XAL9iTBRl7Tj71B94YRXcx69CS
         gTUw==
X-Gm-Message-State: AOJu0YzF04ybsu9ELCVp+vx4KxO6rE+/YPQ/8vdnoAZ7vliGJkcw8YHs
	hhqJ8FdL4YRNbUq2rMqf8yIXwnqpx4dRLDV7Wh2eqvsrt1WjqjU6ioF/VD4M+YksnlpXO93CxVD
	LJxQQDaH7gMNbYTdb7aQxBatc8RbtsynDzAe8VuEfQHup4LTIYdwU
X-Gm-Gg: ASbGncu10fbtb1EHnToaxByE2F28Cl8sUBXPmZe8+zhnXO/tzxSPUyIfpaDSqEIUToc
	HNEPQ+qniP2TGciGekrX8eCVA9wvwyyAmahZ6h0dKqtV420F2KUsTaVsTa27p66loG083GVhX/W
	vmLtpUbaBM0+Q7KK/hHS0rdGsK5BVb9+xiFnBqme6cgnxfxsFPyi1YI0YA4RgsitMfDeLgs2wlY
	wLm6OgFRsN02cf9p9x24gusW1hqdInzv9PQqnV8IDuBtkGL/DpFXccW9LV+A7zcssse5JKrFcOW
	GvYvFie2unnUyTQsdhO5i3UA1OX1JTv4JP0ucg3oQqdEW6ulASOKeRhjjYAKyEMMrfFRKlfMwgs
	94mqYC8v5
X-Received: by 2002:a05:600c:8718:b0:46e:3193:fecb with SMTP id 5b1f17b1804b1-46e7114680dmr67606805e9.27.1759733199344;
        Sun, 05 Oct 2025 23:46:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvwz+OXGnsIlk+C8wzDZFDgyJpUrRBsLqCQT5ExdPtJxykmdjWSSQ3rfmlasZacEMy+dxtAw==
X-Received: by 2002:a05:600c:8718:b0:46e:3193:fecb with SMTP id 5b1f17b1804b1-46e7114680dmr67606505e9.27.1759733198968;
        Sun, 05 Oct 2025 23:46:38 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f011bsm19722250f8f.46.2025.10.05.23.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 23:46:38 -0700 (PDT)
Message-ID: <488a0640-9096-41d0-9a5f-34ba5f2a279c@redhat.com>
Date: Mon, 6 Oct 2025 08:46:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tfee_ozbNWfSFEC10Ru878cLJwlSyywgdRPRy9u73qo_1759733199
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 73E1680009
X-Rspamd-Server: rspam05
X-Stat-Signature: xhku7zpptbajg4nz3iwffyomu5pr3aom
X-Rspam-User: 
X-HE-Tag: 1759733202-307669
X-HE-Meta: U2FsdGVkX1+BbKNUXD6zTuHODSiULP1If/EHIfvxEVa8pZpZpoKfAEM8WU3UHlPRrWYy1aVTi0GpGihpTyKq3mcmBiqRGhpczl7pErNNEI8UvL6RfHHm5QDKelia13VOLtZdoGf4Duwp40NyFnMIp79xobCYSpyNmzXY8yuieLQRvC4c8wzvCIJOgO8UPlyXF+4+FiPmngbUADm+Qj1g3fQ5aQ1tP7TubBKncCdvPn7g1vVMnbFgNHfCL9j/mM8kSmuRSkxRZUU69OPYekybs8BM51AXZNFk9DPIz6jZi8sdGtiO+thTWYGgkxKVEo1E3/Ys2BHfLOTOGdyLNdO2RPUHta8lgh+dT/lF4lIyfwOXZjenPOIPW1t1Ij6SbvF8vxgWtWJFA1OEMd90OuPFDfQ/Bs5bdDRZzuKjF0bPA32XkNuFTL390YdlLdpC9HG8jVWPeTZpkm0438mS8SH9BMqhKSAPTdK6xzCqRNtNa8qaeVom0EafV1UbtvJpZi2EfEolVz1QU4itCAtQXkbakmvNJs9+rJzXD3q/mTB28qU+hMDtyn55ILeeQ2dEAOycR9fP6uIKNLtwvqihBIv02dK9nJnC6Wghh3GQX5ND4i8GEtHJkmtXihsSY7SAWUbVAisnQCTaTlDfKKcinSdZwRWXCLvMYy9d9fvDbBAMGLarj7M58w1N4aH+qmHRzS+plUkV25hRHLOz/66nUIHx5G8pQRxhxhCloYIe8o4szhQD6rBIdvQXIIFINO2D3FWbHdMOSG0bxnbRhfHV620hNVx7iX7vwNSPXnRLS2bWwFlPhTW4ogXHeXEhjg/L1fIx6zTJoUSSnf4XWx+YsOWUQI778uCq6rtgUP9OjOV5smgr7LP4r9VV+0xmYNJaPH6r49kvn1PtVtd/ojrCQvs0vRrJaJu1avlvZMtylhdrb620go93fiuv4LfQMtUmus6Txd5Qdv/A4LhIus/kWPj
 jMyAsD4U
 0dSnPezcqJEhEYqH0Ntq3x26IBgxvQ/p3SFMERxfW1RRwQYy1alpi81K+VC73vxJUvVxLYEpAcOdjKZaZEWM1yWKga4z94fju0zH4dwTBktq7mrFS8INNE441gPW1wF+giHSfmaMuMlP3zl7jtoJjtHHILPlJPaEmLtn7OBV9h+OjD/Q9ctG/ttjlMWpZbXlmXV8Tw4aDNJfBEZj+2uZVpfqljk/Ox+KTkvs9XiD5OJraa8lX6cgak6b4eyOoyYx5vtFujRyomm3ZOKyoB3KcI7M38b0jZv/2vDo3OAcX/TLL8nOYSPQAaapTdQLQ4H6JUsg0BjajHPyjZGSxrdx3kIn0Z8ipi1pEIcFiX+qMfXoLdWCcP3UHAo73Ld1GcRxVJipuoTpZW3v/mjL8TN2ag42wao8tKHdaL2FDyQXe2hg4jFKdczeoNHn3CXV6rChOvzOLupIxS+uOTX4A7d8wKrygYOMi0aLjpWlDGrDopTSQhuB//RbOyv86HRt/msbusKWc0Fc8ErbTgvsyEhkgjp28CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.10.25 18:53, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Similar to list_lru, the split queue is relatively independent and does
> not need to be reparented along with objcg and LRU folios (holding
> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
> to reparent the split queue separately when memcg is offine.
> 
> This is also a preparation for reparenting LRU folios.
> 

Much cleaner IMHO

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


