Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16884C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98A4A6B0093; Tue, 22 Jul 2025 15:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A798E0006; Tue, 22 Jul 2025 15:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8606C6B009E; Tue, 22 Jul 2025 15:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 78B9E6B0093
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:53:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DE7F112C8F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:53:58 +0000 (UTC)
X-FDA: 83692951356.30.742AF0B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0DD394000D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:53:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IbVUw29E;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753214036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=442BRRYG3h5woAErCP/LBz96KN9HIYm8CRPC2WQ7d7s=;
	b=uDtHkCu0HUgnO1oiw63AJPJKAZY86a63VfMDDPTNkC52cygN3awxDg46YA4q/53tfSp8kj
	X7b15iP8vWZY0MvvfvuZ/8g1r/wyy2L8CjpnJ5xBsXnV6VKImpT2zCUoBmfzvBd/gmb/sQ
	awDrkfNmDjdAfbOASQPlF7wOynHNF/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753214036; a=rsa-sha256;
	cv=none;
	b=wR+UuTyrXRBJ3TsvakRHocWQyVwDR3+Ewi/IFDT6aMIGxi7JNMZV6Jk7XPm5leVLB0nW5a
	MGXC6WiVSgW+hYQi2oRb30i14XNlrgOTlKJ1zWpwHtLJR5DRktrMPcqeSBNk+4C40Tp2EW
	nQsmpk1u7cRrPRzN45wXGSa7C+NRebA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IbVUw29E;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753214035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=442BRRYG3h5woAErCP/LBz96KN9HIYm8CRPC2WQ7d7s=;
	b=IbVUw29EoTkpoq3iYRZF2vUgxWIDzHHno9SUWO2LTRlrg3MtftsXuwLAdCIfHN6iPJQg6t
	2eTkriUXBdW4tys2Dc9GeGEOUXKE4StOBPj61OXgyBjy08uilV2fSw0SdJ5rTwy6X/0l/G
	VQu2865Bw40VOaB3C9ROdMWSt4KJ76s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-HbTxaYHFMKyH7Tm1WRaI3w-1; Tue, 22 Jul 2025 15:53:52 -0400
X-MC-Unique: HbTxaYHFMKyH7Tm1WRaI3w-1
X-Mimecast-MFC-AGG-ID: HbTxaYHFMKyH7Tm1WRaI3w_1753214031
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4fac7fa27so2112453f8f.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753214030; x=1753818830;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=442BRRYG3h5woAErCP/LBz96KN9HIYm8CRPC2WQ7d7s=;
        b=ijS5neisHzyRzWFfyiokY20anynNsKvQuEkBKUvthSUatSrASwNG5rAtYdOaiR501Y
         mbOl6Vm+3K9OrPr7Yv8CNWjitEZew1LC2XTM29PbD6O2t7scZUHlAzAJAfa7BbnvoVdN
         GSviMJg4kIH1jBrBygKt6E+ve0jmAHxd/JoziJPfBmjy3Z08z2/lT3vfBNXAqnGqoI9O
         A8Fixux5lBBmgU7/mrrubt/DBWgSUsyMgbSbKp78i9pjeG9DD/qht5KCORb5QU0Se/nT
         XipytQjiUsn/+8CU974U6o9iJiC8ZTUEBnJYEd28Deof59hD97uLgGwPakTdFc86n3gJ
         lQ/g==
X-Forwarded-Encrypted: i=1; AJvYcCV9ijrmbVjGDs82IkYqpn2CY8AiaY0i5rEpGTE8xX9BnO797M8gaeK8QWBF0xWapIt8AkTXBgYvdw==@kvack.org
X-Gm-Message-State: AOJu0YylF+7e/G8Jiu/IJsMzg5C7f7qU7TD4Tw53jpYgQBN3Dy3sGnVa
	mZlE+6UjnhA/JNAJUx5ejBE7Cug3k495Wj4/fLGUJzKAQKdMkzrxME/iglMPjWv/XuOoGqqOxE2
	y5lEHus2L/RlobaDqL+ShzMVqJ07/7pW6Dct5MeEw9L/QFVZ+pPay
X-Gm-Gg: ASbGnct2TTwyVGsRj8aC3c1CrdIY3Ux+YE1HdfanVhIQng7GFmYZNTFgQMBEMx4iYf+
	FHOREKHlB15EdbBgRXxg7b6+1bc6gDzeHkjp2EgkS0Iqlsxzpkttlp3GqySfxBEt9mUFdvqgrzx
	91DpF6QAOB9gpaJUm+MpA1YU/dERldtEdgAa/5D9hZlyvEtji+dMaYRCy0vYcoLAu7Tby/BNyxr
	wlK+ByI5MQF+v6uOmR/bx0yxdoOsxlPojLr7WT25tFWQrRzspr3MLuCntDKR1iE2bGoHO83G5dg
	zGOlysePpledqyHVl/QqSPMEYFhucN2QiYmrqTIVQS1AI1MjCHXZ0U136hVjpf0jAGMvkYCms4r
	xtEi9tTK5p11AZGWrWNuAu3+octQJqgF0jIPeQA+pjp3GbXFEq65++0LcWqxiMZWSpYg=
X-Received: by 2002:a05:6000:2506:b0:3b4:9dfa:b7 with SMTP id ffacd0b85a97d-3b768ec1e6fmr426922f8f.25.1753214030521;
        Tue, 22 Jul 2025 12:53:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEN1iAlahy8gxW/DQ+z5/WqCm8zMOZZFPJckZsiWBcqfL84pcNoPcb0hgdw6sBOS2KQgD+UTA==
X-Received: by 2002:a05:6000:2506:b0:3b4:9dfa:b7 with SMTP id ffacd0b85a97d-3b768ec1e6fmr426912f8f.25.1753214029997;
        Tue, 22 Jul 2025 12:53:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4893fsm14430776f8f.52.2025.07.22.12.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 12:53:49 -0700 (PDT)
Message-ID: <832d47c3-9390-44d2-ac58-f856119b4953@redhat.com>
Date: Tue, 22 Jul 2025 21:53:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page-flags: remove folio_start_writeback_keepwrite()
To: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, willy@infradead.org
References: <20250722182230.2114587-1-joannelkoong@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250722182230.2114587-1-joannelkoong@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hUQ4sNwRTg4MstWJrr1d8h5eSxVy8u7z9TbDgSl8qxM_1753214031
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DD394000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: acfjhjqb7nutdk9du3wth4dj4h6y3cdu
X-HE-Tag: 1753214035-556060
X-HE-Meta: U2FsdGVkX19qL+uSFTjZV2x96ca08t/rTz7nO6Kww2BC6lq+rGJJBB/7jOSWxZFu13zZ96dv7NfoQMpyeoV/4HAWiSLt1+DtRQv3qID3uF+1vpYtX56j6MZZQwehjOgtwRsIzLxEcbCt4f56dwTM8oPuyLQ3v35KFXnVXw+Fwwgxyllu8v1bJdfWUVACj06WBsdI+0XhLkQuF3BAe+aqu5CvsNmhUdcYF3APqCnKNdcOdfrZqOaIOaWSbDfBqxbg44hegFyk7LNU51CpybJFws3i5Gy0wXQGzLW7AOU3ZSL0ZUInnBNu/LQDbjMV/cM9msdV8Yw6hYnqNKommXYW7STFv/asOzLp3Fae+BnV0EhT9ny93OWVEoH9iLpnJmSRWNLwx/B+r5pTbmrxdp/RMGjsCBRZW+3xMj895GeVqjCScXw2esLX6YFUGJOcUbB4zjlW92oP0lTy9tVfNe1a1NZG3IuwcB7eNXTn7QRp0wNi80LxPX9TxIkVU/rOg9iDBl4T5F24EUnDLQcYnXfFHnOW7gri8S8RauOgWeo1/fUiE6egQZKONUrh1pQCAOavWHPN4/3DSokTmdhkCpkUlFRzq4NFcPHzzxnV36vS/5e98hwQlmh2Om5mmKC7fncoMI7IPg9RIlHOb7hGjgnzB5uS5hpI88f4VR3Ib3bq60IcL9GcewewvbLxxKB8eOhdIBp5QpNbrh+iqrcdRjfrsZp7sukEuaSSyUxq/DCC/x28zr9kuocxi4cN5/mT4OjSlNIibr/59YPFlS8k9NQf/MLTr/yNcXQyfdqMIUqUVunqgH+xiOACkWUM4D0pM8uHk5SUBW77WHsyVW4opu6BV5pfgA3nAxHRvUR5olCxKGoCWAPBwCUqFIdLT8PonpPSW50yEelGH8R1nnqKJrAy9+Ojo6+Ia2Jjyr7JJj0QKyGEfdyB9bKL3MfBWxDee18YQT1yVCftMeoHpl+fhht
 DfT77f4b
 fdPEJsBBzJQaxt93eZPNOQpmbF95HYJQePoeVgwFocDZTskvlStXSAzi/5KhhqxJvEyhSQM+WevFZjcc/srQ2pFBrYneAPqTQKzDgD23GLaJO9IrilLbqAQPi4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 20:22, Joanne Koong wrote:
> Commit cd57b77197a4 ("ext4: Convert ext4_bio_write_page() to use a
> folio) removed set_page_writeback_keepwrite() which was the last/only
> caller of folio_start_writeback_keepwrite().
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


