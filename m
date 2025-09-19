Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04F4CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 08:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522BC280040; Fri, 19 Sep 2025 04:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBE88E0022; Fri, 19 Sep 2025 04:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E995280040; Fri, 19 Sep 2025 04:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29A148E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:00:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D165B13B37A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:00:22 +0000 (UTC)
X-FDA: 83905252284.27.DBA97E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7CD5D1C000C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:00:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R5CQ4Hij;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758268820; a=rsa-sha256;
	cv=none;
	b=vtv/C+zC9x9Sd413LQ1a+dcgqgq0a0VIozQH5XedVgvK9KbrM88FAZWePOimADRH/LATEI
	Br623B8JD+IfApVBuaJ3KP3XY2jP6rEbWM6wXZX3//UwtjGiV6/jFM+PqwcpLzAKpw+tNp
	WIhgaLDHcaEgBP3FqlCKP+k5Tk+QFJM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R5CQ4Hij;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758268820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+042s/OQ8tt/41h13rc/O/ZdxLQ7dgj1n0m0iBdyvM=;
	b=aqNPbS9b+Z2l9oWp+DyO8qdD5aUoQpi3V2YGABDkpj75LqU0HmTtuEit3rcGlNTfFq2MQw
	7opVoO4KVtf+fXysYtnOBuSq+wCZyHR4aYuHt4ByDvzPkZbO32kum7Lw071qYZDVv4Ho79
	UMFSWeX0/DiefKCSgOy7N15j66r6Xlo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758268819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h+042s/OQ8tt/41h13rc/O/ZdxLQ7dgj1n0m0iBdyvM=;
	b=R5CQ4HijFRyfXHKl3Vl9WIWItJLDcGCG5m2pyxEDNIaTjS3aquEpHXMNGH8ZYMjv1DuD9E
	7O+o5+m1iGb4roP8NiTuNCcpsWnlXoGKpQPrRMgtIZEp4OR6WWa2xXQekyM+AkGFdClsHz
	26YuDDrkfhIio0ySTi8ytTTX3UY46dc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-RZa_qqTrNi28mAFjedGTpA-1; Fri, 19 Sep 2025 04:00:18 -0400
X-MC-Unique: RZa_qqTrNi28mAFjedGTpA-1
X-Mimecast-MFC-AGG-ID: RZa_qqTrNi28mAFjedGTpA_1758268817
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f2f1a650dso11693565e9.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:00:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758268817; x=1758873617;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h+042s/OQ8tt/41h13rc/O/ZdxLQ7dgj1n0m0iBdyvM=;
        b=I8X1y9n49cOJhCfjmuVhtN7QLo4vucy81xEz+tOLnZWRp4fgmFVCfbFg3HUeRQts6R
         KCS2h0bBZzkpU+7ANCm06n8OfY+YoLT5syC1A1JC/aTtkcLgZCyKqH92wLoShur2KTGq
         8Ba3RPOteLNV394oiYLt9Dj8KnzretkR5+DpNYZEVSycq6oc21bNSMt2W9G7JQQ6NJnf
         zwcwt36/jnIuriRJcgAJmTh+c50RsZL1+wthtWTxStnY9euBLzb7l21Msmz/Yp4edrLb
         zqxQ4eUn9q3DYGqWoqv6QzluOCTwQ2bIV/99MtMQwtUGZgHD9F5AAyzpng5Pa7RlREJT
         dbKw==
X-Forwarded-Encrypted: i=1; AJvYcCVPRwdxUVKHC/6NUZ8Nn1zHpX3FXJJyd3jtCAyqYKyheKWD3I9c2KgZ/9Zf7ST9zERMKxYeGBaKOw==@kvack.org
X-Gm-Message-State: AOJu0YzRukwb7Eqa0zy0hupBCqu9phMdkYIFLW0tDh9IXSkI6kaUJXV5
	aXxX7wjCWXVwrU0I1rtU1rM+g+dYJyVDaRDr4+4voh6IgfQrw3tckFb7mipBCyhJupqB6Br9kSp
	zmtI2186MVd+bhLQZxlz7d30tiDAmYynCDBMs61woHtwaWrCfOQzz
X-Gm-Gg: ASbGncvBEsghGT29mNws8GBwnGufB7rZiAa784ZmwbiY52BECqXiZHIVWLtx0b+FlwE
	scxfTm18nSYjWNmlUKRF+hVx8pyWO6+X9eudBzPhBCBZNvRBUKP3pxiGw4XCQhyz+jm831Kwkuk
	t+hU6KuPKyiHJgXkLcqOnyJMrX93ebMzCxzLNYnvfLK1opWaiogmu+9SwlJRbk+xEC+akGliDy3
	G4sE/Q3ZvS+B7UeNzF9lG87rtG/S4vkMa9gVD4EXl9nmzP+TALFTg8YHifHC3XMiSHmsT8Tm+90
	FRVU2ad/gnNPoQZUevcUHxB9ojuJgPz9MoapnsnK+mFUBXJVIiW5amI6ZeR3q7cG0+NLMYWYUyO
	hvnxDGt6b2AAtDnn662xDVIynZHdtMpSb/ZVDV5h/orGmSCO7FaNoyEPosn/o3IqchIz5
X-Received: by 2002:a05:600c:4fc2:b0:45d:ec9d:5fde with SMTP id 5b1f17b1804b1-467ec46079dmr17229355e9.37.1758268816901;
        Fri, 19 Sep 2025 01:00:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGom1Qw6n3XFPDCOTSj/1O9ThoOyY8Y4gVn1ncgKcnD1fztu0a8MoRQ/npOz5+Wv2OG/wiqSA==
X-Received: by 2002:a05:600c:4fc2:b0:45d:ec9d:5fde with SMTP id 5b1f17b1804b1-467ec46079dmr17227785e9.37.1758268814964;
        Fri, 19 Sep 2025 01:00:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:5600:727b:b2f6:94a1:a51b? (p200300d82f235600727bb2f694a1a51b.dip0.t-ipconnect.de. [2003:d8:2f23:5600:727b:b2f6:94a1:a51b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613e849a41sm113556505e9.20.2025.09.19.01.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 01:00:09 -0700 (PDT)
Message-ID: <db051a89-4eef-42c1-9fd2-16ffbad18b75@redhat.com>
Date: Fri, 19 Sep 2025 10:00:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, hughd@google.com,
 willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
 <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com>
 <17d1b293-e393-4989-a357-7eea74b3c805@redhat.com>
 <4e938fa1-c6ea-43fb-abbd-de514842a005@linux.alibaba.com>
 <tombfifwrhx2n4jnj2pgcdcpj42mdv7yizkpxrppnqrtsxd5fw@epnrjqgmmy6z>
 <787dc1a4-d0b7-4559-8160-55de987beac3@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <787dc1a4-d0b7-4559-8160-55de987beac3@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oiFS_vngKt3wuVeb2v1i-fP3hDRPbypDf1iqzVIKtRo_1758268817
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CD5D1C000C
X-Stat-Signature: yf75zbpbuokwtjkwfotdhotm8fkrnify
X-Rspam-User: 
X-HE-Tag: 1758268820-809944
X-HE-Meta: U2FsdGVkX1+nfypdwpmL7ECF5Ptue3jTgdTzPFW+Sw/ikJLyq80b9gW5b2gj98CbaUFICDwDXPTNDoTvocrmH7ZkOAelz/f4XC77WtEZ5uJXimruV7jQaav779R8wE1GTp7C8DpOBcF8aD2EKa+CjA/oSDuVN4B2vAJUq+ajz9EGty/+eWTFj1yHw8fn1nrM/ibQLwIcg2mYEZAGdrEythIM7TX+02/xafkOiZc5h2UQEmdpwYgpDH2Uia6ConM40xhVANOzdkrnoMY1/s7hSH3PktrsvdhZgARgahRQbOG0P10yvbPHJluz4JhuIVTur3t8PC5Kqrb73MBQ0c20nG2dMKBRb4h3QRdFM/4y2tv8FP27j4iFND5/AF7klXsH9eSkdt6F5NjimYrOzO1HGy8OYbY++QirEpHdr0LX9STvIv3gqbB1gN/aBIcSjIvhT+lgOrwGmYjH4DURGKcE8m+ZDEaGz9VJBTZu4tiqYcvjJ4ZzJ9+VGxl6YO0tCR2Tq40TwlYSlOneI2Nj5MCBf6TMkD8V90Z8Pf1wGJaqdzxTqRR6tvI7uY/Ay+pwTicxLh028gViAXYYL5+XntvDOeWnK/ZKelB41t0N0WG1FsBIaava5IRz7YZy4RmgiOKhuqt7M9d3uZs+GjyVltd/lDja94EgCe3kdCDiHUKyuZyXn8a69J/kKETeYuoScfmayKYM8PDR3SOEgd2BHWeWFBB7VJ+UAlshoMGIAXyzJz+Nnkd+CFbXWw+D4wJC/pBkPUqbaic9FmTQ/lySv1B93NH1fsTcb/wN0RhDBy7bOL/B3OvXUzEU30oYtgQ6usDdz3/B4gjqnHbYFrjomvEY7zL0UlJUbSd5wQfsCUSAmmBbuB/ntZ7raFC5s9RpoA3/iDv5VUs0wjJkjyzJS8cmR99dUmaz5beEBesZ1dxaVOaPSxn6ZRjjsBE663aii1hEajiZ9ttEyl4280WAYvR
 leF+ujzC
 RyHdtaatL4MJhqFXP6djMBCxnAbDBCNsVQksFCB+DrxbR4ep6/hEA+3Mvec6NVnCSIa+k1AuSGHBJQT3gt4+Ukl1zsE8C4aFO1QpfCKUz+Gob9aF/ASz42ZZ/nDmOCjgtCBd/BADdGfEBndmstgpbPLLr8L7rMccSv00QhzNSR46K/oMnCbUJUtwifx8UevPu+n/wPbNeKiSb9c3X8P/poqG+jtzn+lzvvQ2mhC1ehl4bROOykJViG03OsKWk+BD/46itRrbcro8NGuaMbJOoL6ow36NQe0feMz4As80UB4QhhxuKVSH6gJ7COgDOZEW/zD/8NZMNCK217qdopKazQRVEtkDaX/sMnsXJP7Jo7isPO1Z4NTYfRESXx1r6J+yTsIQBcQyg7G/OjywJ+CGmUZnSlkEG76IL/XpPUT7wZp9005GsX/QIiNuRSxuJ8Kv1JD4l+orlf+/NpZYFCR6Va3clU6eIFXzHYFst1iyliZ8Rz5m6jCkwN6qlHtYc1AwkjQtzsvqBD955UJj1t9nr2eoJnfs6lFpjtbMrcAB1RzCCU9NOvZGZwhPToUxO7ccIZL7GUlRuQX0sRAISxa5SXAuHxA7cE6nFMlLBqfcplxd0ghfP3+YudUz9FQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>>> -        if (folio_test_private(folio)) {
>>>>> -            if (try_to_free_buffers(folio)) {
>>>>> -                folio_clear_dirty(folio);
>>>>> -                pr_info("%s: orphaned folio\n", __func__);
>>>>> -                return PAGE_CLEAN;
>>>>> -            }
>>>>> -        }
>>>>> +        VM_WARN_ON_FOLIO(true, folio);
>>
>> Unexpected but better to use VM_WARN_ON_ONCE_FOLIO here.
> 
> Um, I don't think it makes much difference, because we should no longer
> hit this.

I mean, all VM_WARN_ON are not expected to be hit. But if it ever 
happens, it's usually going to be a lot.

(I recall Lorenzo wanted to look into cleaning a lot of that up and 
possibly unifying both helpers)

-- 
Cheers

David / dhildenb


