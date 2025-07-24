Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3526CC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB146B0095; Thu, 24 Jul 2025 12:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C446B0096; Thu, 24 Jul 2025 12:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1F56B0098; Thu, 24 Jul 2025 12:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB1CB6B0095
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:29:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34CA05905E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:29:58 +0000 (UTC)
X-FDA: 83699694876.15.01CA8DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 94FD31A000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:29:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U+dbrFAn;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753374595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrhDtkp9y3EEZFxtZgGx3JWfJlEdHobtUIUVYpu8I2E=;
	b=ak/9uXZ+yuGVhXMX1geY0XIPiPZDSszV31OrtRp0wTXR/+JoZVqgcavOm1frOtMsi/AmY3
	Of1NEDhYwP45r6R/leV4f7FzfqPyFFC0Cpf3Oj/XMVsIBvOKHJqrPQCbFLfphQfssSnl6a
	wrB3Zs1jj5IsZRM/w6mpBRlAgrUViSw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U+dbrFAn;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753374595; a=rsa-sha256;
	cv=none;
	b=GXPLn/Elyxc+qKlbUS8q98wM1xkwtsThzcoavTMWAf8fXabWevRVNVqDXNEivxS82gY0G1
	fu1Q76gD5Rr0O1NsP0vEYojD/ocYv9GGatTuWta0N0ZHsEfh+51TfC2xvV4QVdS89AdZZl
	CGMu3lZYzp618vVAt/Sqg9RviTKa0f4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753374595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WrhDtkp9y3EEZFxtZgGx3JWfJlEdHobtUIUVYpu8I2E=;
	b=U+dbrFAnM3LvDNydeOoGRucb7v1SspXN5vJlB3I0o0rpqQPCL1bqyWJlG3lD/mFdataOna
	P8I0S+FA+SGCbSIuTNjS0fgE2PDKXRYPvRYIMhTwXWPbv+8QLFHrDhHPPiPqCjzuuFzPcG
	42QIhkD9a7snKFRVSUeOV4a5990jUK8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-kXkc5hC-OSCc-4QSoc6hnA-1; Thu, 24 Jul 2025 12:29:51 -0400
X-MC-Unique: kXkc5hC-OSCc-4QSoc6hnA-1
X-Mimecast-MFC-AGG-ID: kXkc5hC-OSCc-4QSoc6hnA_1753374590
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso745112f8f.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:29:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753374590; x=1753979390;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WrhDtkp9y3EEZFxtZgGx3JWfJlEdHobtUIUVYpu8I2E=;
        b=iqUhMrC+FusVRLYs/s7d8/6MoViM6N5mL8Kp+pbTIyFAljUP50R77wBIJa57n0khO/
         wBzMUO4ngfEJrFS7CQ76sRvZBASwOoQ1cpCgi8RdEY++Dj3mFFP0msDOcUKsRYOkOwrM
         hKyiISRamz98uPit9+EBot4/kmkY65Zrv5cD4dpZMOWTnRX5dRIO4Y1H2baR4coljLai
         TFkGpzt2mMCoBr6C8inJNSS6LPVUC6xmEhbw652wVI1x7kQUNhdy6ttyYn/QTbF0noO7
         nkcrS4Cx9ESvvFr25wL9IzAovwHhrjdU9610OWLs5kMHWkgFOnCv7VlEKntpds84qf+t
         wshw==
X-Gm-Message-State: AOJu0Yw5xgUe9HgrIFcKKrW33CmIajJsVBhAXwIIyGqNVNsM+9aIYrNs
	ofryrhE/wh+ppNXVXD+8Ac4kfCr6i4rYxSlyLiXec1EH7eRBxA/cbIyVmy6aCnL5q2ulV0Z7IMH
	KSv3f8ggmFYnHivINsYpCU9Nyuwsa+DPKIur7JSaZgas9hX972rUD
X-Gm-Gg: ASbGncvgluxKWmyHpRVClVD0AP8+AKtM4myKnNnq3Qmzgf7Fbq5l3TpGTQOngLhCOd0
	qTzpVckogbfhqzwWJJvTkrzadcNzYvFanOJlHJgkj/vfktobhMyibjdUjt60UJXFhT3+l73/qXH
	BABitcwCnDWsM0ni2/FPHm7tCRDcNx15+R5q17gqnCd5LeQp1WQUYsE6spOkSIhRmpYaNcQimmT
	onx6gVopqmxVC3ljitHZM9/h7+fWudVAepcj86skUNJXydgt3MFU2kECFKwjBgteHlwhCoXNB6S
	o0VGJJ7vMD8jDX2YsMqzsiYptKvW+J/DTmxwxpqxIj1Drun3gq9XlUfPIbXL5ME8pUoIasGFdOi
	mcZxO3UJMyzlxWfKhF8pZKMjAvlIaheceo2dKUWchTcRHm/vKAGwGv3yB1PfpRobv4Es=
X-Received: by 2002:a5d:5f86:0:b0:3a8:6260:ea91 with SMTP id ffacd0b85a97d-3b768f05550mr6035467f8f.40.1753374590249;
        Thu, 24 Jul 2025 09:29:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6wdK8qKpzDm8FG0QzBSAiEFr6/DAuTxTmE5f15fsNgmMMj9ZmFs4WEc6VAhhPhJiiKEvUqA==
X-Received: by 2002:a5d:5f86:0:b0:3a8:6260:ea91 with SMTP id ffacd0b85a97d-3b768f05550mr6035428f8f.40.1753374589753;
        Thu, 24 Jul 2025 09:29:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc6d07asm2665689f8f.19.2025.07.24.09.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 09:29:49 -0700 (PDT)
Message-ID: <68d09c1e-517d-4cba-b22d-5d44900faef8@redhat.com>
Date: Thu, 24 Jul 2025 18:29:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/mincore: hold PTL in mincore_hugetlb
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 dev.jain@arm.com, catalin.marinas@arm.com, lorenzo.stoakes@oracle.com,
 thiago.bauermann@linaro.org, superman.xpt@gmail.com,
 christophe.leroy@csgroup.eu, brahmajit.xyz@gmail.com, andrii@kernel.org,
 avagin@gmail.com, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 hughd@google.com, rientjes@google.com, mhocko@suse.com, joern@logfs.org
Cc: linux-mm@kvack.org, wangkefeng.wang@huawei.com
References: <20250724090958.455887-1-tujinjiang@huawei.com>
 <20250724090958.455887-4-tujinjiang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724090958.455887-4-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tm67vx3c6Duosj4hX7FJLMPJwlWFrPfrh2ADpJhiu9s_1753374590
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xt3o7z178dob8dtw1xydh6q4mbgdc4gm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 94FD31A000E
X-Rspam-User: 
X-HE-Tag: 1753374595-972740
X-HE-Meta: U2FsdGVkX183IbDWm464M/UA970U/yIgLkAtFTDPTX/hX74zR9qAgbYc7+I3xbA81GSkq12I0o5fiRrguPjWcNKW3z5VKAUJrckKMgxupPd4dJLvwGVSFpJm+jrccfYilD84DO1VAqrkhmFxixFtrbxGKSIfpW1RZuRuSNtQuuWRWgaj8UTeyxgsTFcnWNNL41L7mQQBaRxZh+fqymcaIeGxHNq0jcwnq6ngMraE9c9Zx1dzvSXZfYpPv2pbkLlL1R6UlKIZ+zBzvvDdyK64dRytV0jpIxTPeVxWLj5KJW46C4sBPzzHLSqY/Jsod0v1t/9nOfeiulMafA8lnfCfiuLenFajLILu/+ZN0NGSvs+Zh+o8IPELp4/8CFbyeJBPTypCJ8XY2radmBIAHuduYwZl/X3r3rSquL2EWdHVMRWjkEcYbOYvus8YmsEtqBDIm+y0CYqd9e2+GhitIBhx8mV3QbRrGs0hKPnzOhQqQTPnjzadhRccxEc4Doxzy+G8237HB3Bfkpt/RPNRp4P2d1OUT4nZ431wI8AY0uZT0UX75RhBoQuYnrotjQfVyK+rI1NFaaEUzKyfFqnlUNm3d68mnh3Ll4fIqs6+mpBk0iYwte4+eskxDKuE6rqw2n4TQvPDN6knsZTIXSzNxcpxV6oVmAKeo1T1UftH2RSCqP8KoDtr+Ws6k1g/r65wFr5tOvhM8UpmvVruMElLYqY41p+Q+14bAb0TmoOittfGds3iHrcT+hRVXgz4CwQ7kDEZrAWif9ABLdk7auD9VJ0p6VLuGxcx7IB0mdnMeAGrVzG1Ii8UU03Kuy1jQNO5DmWQL4eO9UNqxDfAUKnOQZ0+SBWryLUYAzBOzom46p/RjqR9vXi54o1y1L737j+ATDHED8GNs3G3RfG4ULPb+E2aQIbmeYE2OKvDypQe2FqKYnopuJgmcxObtG8svmDPFZ5yflRf/v6qgfhmEvK4Mlq
 OfjdZi3W
 LrqB05NrUqBw2819EG0vloOzGfbI0m9lYQ55vXCqhK0WeINvUzGkXT3dXIYRVuZWrBMBEQdijmar4DKrsASNKtWErN3RxDGATcS17u2iewvqi5zcaOoqTJgwMtmsd1uMal0/E7PEirQh6/pfkxIl5B64n6ebLCdLwbSf6/3/DfxYq4Xj0A1vm2XWBpP6n4ze40hBks3cizmZFlEqwxteK0VHAg3qU7OhS8fKoYWNqU65+WzIjZi4vZIuK1j4NE9KVsyaa2JzdMpAQivZIntoFgIpT9ImEDUnEEAKT+t8Ir+nWUNyGKnVtKjKS7rG4UeF2dItdvxNrtodqcNKRXb5YyJ2aT1+quArCJECpG8/LGkc+4PSnifIudhtS794z1ZTTKm3k9Z40Fore3ctrQlrHC3fuWE+wBq1UXOoKUUi2OiSMI7tjliFNN5iI7sGuM9z8UlmS2cMYpeF9latw9QgE4QRlc8OZ38RtPNMRjnv7SBe2jKLEQSOPYoQdUjAu3VxxG5sy8hQSaX77P0toul9B3Wq+CyMn5X0rlP4qSTvcocHhuNl0b2pR3BJeKKxlG0HO+Q5o3vbQcT9fWD0hE+uOgk63XYbnk249rCVu/8Cinpwe/NMONCmUFd7zCdUbs6HHJOGgngFq4KsJLBc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 11:09, Jinjiang Tu wrote:
> Hold PTL in mincore_hugetlb() to avoid operating on stale page, as
> mincore_pte_range() have done.
> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---

Yeah, likely nothing broken but matches the ordinary PMD handling.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


