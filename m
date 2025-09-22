Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0497DCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C988E000C; Mon, 22 Sep 2025 04:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574218E0001; Mon, 22 Sep 2025 04:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4634B8E000C; Mon, 22 Sep 2025 04:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33A548E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:17:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B63A13B502
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:17:21 +0000 (UTC)
X-FDA: 83916181482.21.D322DD2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 59A691C0009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:17:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UYxPSI8R;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758529039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xl+oAizSjcdN2DSW8OsX7gKnJcWLeuJ4HjmHVAHxhI4=;
	b=BktLu4ORqRSZHHomoraX/Wk9sLxBvcD5Z9OIUkYp6QmN52jZRamRVWTMLd4z1rQp+e4zvx
	BOlzgWUIDm8EeeDiQG9ucAVv9EIPgp7zlmYnZ8vgtDoIw5yJzhfSWqxiNEEwM8NP6s3Paz
	JVEycJM/zehbpwyLLMZbU+KAvzYr48g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758529039; a=rsa-sha256;
	cv=none;
	b=FCxUiiVmapNW8zJ1ra/WuK3QVC8ncZoLVfUy1aUQUDxMMdOfCwmT3ZFV+8PDuWw1DPHY91
	4g/ROHWNjXBkqfrqTpEZRLCBucFFVvCJvKI2hA9vUNgk+q3ZEhJEBo+DsSR7NoNfiUgFme
	F3EIfYtu8OjRF0kUfV0nln+x4PfjchM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UYxPSI8R;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758529038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xl+oAizSjcdN2DSW8OsX7gKnJcWLeuJ4HjmHVAHxhI4=;
	b=UYxPSI8RSzj1gghJoZIYOPyInuAqP0WFBo6chCNly36K1NjuUs6Q0AiR6zhpSjg/ZW17uI
	tzISGeAwl6uQMvGnNQ1qNhuM5KeVEfNufJF1I0FaKYdboivYiAeNGhaZ7upZCdnP9Adh+P
	HfjW1PsWo1Vlilgzn9RYGPAalt+2NWw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-9y51lmfDNue6K26l-H-TDg-1; Mon, 22 Sep 2025 04:17:17 -0400
X-MC-Unique: 9y51lmfDNue6K26l-H-TDg-1
X-Mimecast-MFC-AGG-ID: 9y51lmfDNue6K26l-H-TDg_1758529036
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f2f15003aso23313535e9.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758529036; x=1759133836;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xl+oAizSjcdN2DSW8OsX7gKnJcWLeuJ4HjmHVAHxhI4=;
        b=aPIEblNfirj7S8OPdnK0Qkg3oRhXZ5agwBU3H4mmR4Oo2js3+MMjF3mv0ha4GKd6uy
         1QTtSzdRgoFTewOjfplWCT5Xl5zXab5h/5+CYGMmBL4wlBCYySwTBSZIbpWNPphx+lv4
         l5eJjXrTeDErS3//QRC4uS3UUT5oTCaKmtgc+rVEsagY+OhVMtWg58zRTjG3VE702F0D
         mqrfX3B3vfaXIMWlxsvkPzwTexjX/4TUmeHVA/wnlwu2Vms2vIGYo/TOiU5d24Llmlvf
         MHX5o7tMhyQwEFHWj1ohgUvLPK3NsfMCEbdIKDejJYl84rSOFCSLdjiztiBBfrwUAxqo
         xaHg==
X-Gm-Message-State: AOJu0YwOZQAl5Tx+J0+g7xD6dKr4jmyDKbLFEOy1tnpuVzc+9EROAjHi
	dcn3fwpw28GNEUQkBPo0O87sHN13SudVYH0znbUksZrsXBV4TQ7zEtCS9+v2MCtvXcZ4x3+aQJj
	LtB0zUI+khprS9CWHIHQr+nax2kpSHiKNA0OK1TDCkaP8dNULzPm8
X-Gm-Gg: ASbGncu/P/BCLXQGm6fRnxqe9KABkEIuOgwTg+JiRjmQwLBaJ7K6OeL8UqrtnN56Qn3
	nlU8mmfV8d6TWpnJt+SQjJNYRHeWNq4NtSMEDf4HSzyh4WwvUlknXOzmyI1rrhbaf/KPDCUfmAa
	jk9N/BnTF5Y42St7JJwqdZOzvbspv615rgnCVQRpZoNd8UU8GwLsYff3OaxwQvPwqSqbeHQRIQx
	cMVVchFnNHULjtTsYBEn8OraPmg0nnWHXvpGKrJmVExNecOjnrlJGvZoZg0aCpeXUyC+ipCV9Hz
	iXVsipFx/Bl4IHVQGAFh+telMDaqoGQEA0O22ya8RBSFdmL7xKLGUtW8qf1afoypl35Nkq/gSwf
	4vACLoCMFA58eN1yt/EPc0PrdAYg8lpUlNpRL9NgMBbDM1z6795N21Dvm0G/Z3j0=
X-Received: by 2002:a05:600c:c8d:b0:468:4350:c84d with SMTP id 5b1f17b1804b1-4684350c98cmr94305435e9.7.1758529036129;
        Mon, 22 Sep 2025 01:17:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH20k4kJt62SfinRtlqPZ+1RxOz7CShF583y1p3NV6Zfw2UT9IzSp6E71WCtZFAHxn58tJ9Ag==
X-Received: by 2002:a05:600c:c8d:b0:468:4350:c84d with SMTP id 5b1f17b1804b1-4684350c98cmr94305285e9.7.1758529035750;
        Mon, 22 Sep 2025 01:17:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e15d1610fsm8286165e9.7.2025.09.22.01.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 01:17:15 -0700 (PDT)
Message-ID: <a4f7c004-b96a-4902-b003-111c83b0ddc1@redhat.com>
Date: Mon, 22 Sep 2025 10:17:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: thp: replace folio_memcg() with
 folio_memcg_charged()
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <35038de39456f827c88766b90a1cec93cf151ef2.1758253018.git.zhengqi.arch@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <35038de39456f827c88766b90a1cec93cf151ef2.1758253018.git.zhengqi.arch@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cy0vjOtOkkmqEX0vqoMrNa6TDqMAAeNXFc-4EmTx8CM_1758529036
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59A691C0009
X-Stat-Signature: kc874sq8b6z7j3tp3irq7nqcrxo64gxf
X-Rspam-User: 
X-HE-Tag: 1758529039-229037
X-HE-Meta: U2FsdGVkX1+TDk96n2WPz0bNGtZilj8YUNYmdX1hXbaIFf165pusFS6OE1kfIY66uheWjOihB9mM/y9UgWSnXEH5x8UraQQyXn20/BXrebfDV/Uq3/wFLV137q6YmyAnLiWULSwjcsP0OWWwEUwHiv6c2rPVc5hDtkG0KgAgIE+fQ3IhQkG9j9yVbKUdLA2Q5jAywtJ8apM8SuQu0Ul33zSUsHM+21kfD5Hz2fL066TTyvSPSOzZt47FjQIvJwtPTwxFsVdOWyq/ZQ8GK+eEz6cgFZREQFyDuoN56TbQRaIJY0jRFeTrEWppTRLUTnMWFVJUbHelVhXro2Jx/byQP8m9RVXI47XuvxLoc1bieC2LDubmcBvdretMrQ+wztWVhPseDISCQbsVQ3bASi4iRKNSnf08MSl99QEpQzER0m6wy62+6cFzbRHpvKNtWQPOks0YTzzJuRxDMeqH/rAjJ9oSmeMftoatnUdL8R/CEhn8+dlbvNL5yQEXoliWaTASVjqSXHA34hQPZARXPxsaRSGCK0q4PiRU88l9TH4IJ6U76gf1tX/e89DmPc0LkTtbc+y4jNBHB9uHJO9RC/6Me2KXOMzmhu9ZJOC+FYW41q87PNwmSB4rodMhaak333GMc1zU19J/n/hX/1zosBpwU1OV/riqMBrwvbmI13H8BzxNTjNwn79z8uALeIH34q258w8G7taj3CKCQErH7oP2SONinEeJygguJjPk9w/Y9rKpTigHGLgJl3Ga+SFqxwBdAZidDFPkheZXGTt7SdgC1DkGL3+UHiz1namqolYENVq9GvzDwzDYJq3eiiBqA9hEZf9Q7qGs2c5OqzfWHf2u2zRuTQun9nMPoVqyDh21QZWpcY3BjKCyo1L7VA/k2sPxwfETKMe9XYDYI1Vqo3GmCpHcDah6IkZCkwYghvm90HUVBvb9E8DY7cc8LrAL5e+uXLSw7Ntph9IxrexiuOk
 ktZXNkHq
 9wmDI+tkl+rwvbfhS9geQWx0+T5xZTE5/xaecgW6HvJKlwGSokvTifOrlKCKBgvhrlMZR9vGB7ixuWkdkZvZq/yHmYo80AS9WsFpM4Sb0fCMJI7B2A1NREOQe1q0DCB6SpV0/QKPcie8cXfYjYPe+VQs6E5toL/PAfM+ydVAiThlvYpe76rYxnxKd4X/Jd6JwFVTtP0Pqjy6akd2ekHBq4h8rUkFG9dPzaRqmf3pH16evR5e1opu04P9PogCSz86qN1SsSagplsT+buVosG7mGHKJGgGH7N8BxmfHMKN3tgHT7mEsLOIM7GDrCYOfk0kLqCgkRYERQSs2YDbNVW+eRalDBedE0mEKuyaTRLcQ1Yw1CC6t+QDo8A8FUOlb6dp2WWmLSKZMdsbHr2GONeQ3lXS8T2Oytycy7xI1er1XsLhx+kcNrZWJX9Cm+2FNukoJReEftefTR1hAnCSC7QfHqeIcgCpdstCHLYp539HqWPpJCPSepQcjrG8s1v6woEPTqMEfJgNjgEFt4miObsKmjMMi6uzU86GzAVfG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 05:46, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> folio_memcg_charged() is intended for use when the user is unconcerned
> about the returned memcg pointer. It is more efficient than folio_memcg().
> Therefore, replace folio_memcg() with folio_memcg_charged().
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


