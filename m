Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B81C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00FE6B00D2; Mon,  4 Aug 2025 10:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB11F6B00D3; Mon,  4 Aug 2025 10:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79226B00D4; Mon,  4 Aug 2025 10:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7D2A6B00D2
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:36:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4148459E51
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:36:19 +0000 (UTC)
X-FDA: 83739325278.29.F14CBB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C7E414000E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:36:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PQvX7ixf;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754318176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKInsm6bnVNCfi59KtVGbMO4lX6gaZZcpWuiTBk1kCI=;
	b=TkCWvY5gGUpZ24ZtpxEq0C3FdFQQsv0oFirpbMxdiYa0yXlcd+hmuzPS7+AUDWNYuyYgT2
	omiUIAenO88pNJM3R7KHpEYLLYlsjy1AYu9SfoiuqScYDWD6pJbYIrfnOUi/5coq0xYSGv
	LVRg9s2+VapRPs0+tQPcTuJEyRSS/S8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754318176; a=rsa-sha256;
	cv=none;
	b=SjUpTQ/ZpBZsU5qZVTE6NLK/y5/xq+TWGwZHJg03mqxPjybQh8knd3F/CXVzUkjo5gco3b
	RKoHd+IyYIY6ZJ9eYbwdgbOmGgYzo2zlXzVp1ouvSey1bm1GXfQpuO0ouGRDpMP1FZjC8U
	gHtJSMfC9oAKR4PcXT+k1OASieMwcZo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PQvX7ixf;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754318175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bKInsm6bnVNCfi59KtVGbMO4lX6gaZZcpWuiTBk1kCI=;
	b=PQvX7ixf3sl8LuZSYjbOoxNvcWWeUNYcXfmvUujj0h6KdrxK26gyQ8HG9viKMA78e+XM/K
	TUST7hSDs1cgV80lxMkJchY9ryOFm4lWl79znHj0XQUK8iCxGU945cHCljFLFeOshmbpV7
	TF/vfxGCM2U+iGJqivzS+o7nC3fnDpI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-kAwMfiIKMmKjU9d7d7DlHg-1; Mon, 04 Aug 2025 10:36:14 -0400
X-MC-Unique: kAwMfiIKMmKjU9d7d7DlHg-1
X-Mimecast-MFC-AGG-ID: kAwMfiIKMmKjU9d7d7DlHg_1754318173
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b78329f007so4032825f8f.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 07:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754318173; x=1754922973;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bKInsm6bnVNCfi59KtVGbMO4lX6gaZZcpWuiTBk1kCI=;
        b=f5gLzYA3Rtm2lU0u56Usu99Ao38WCZCeLN1oCPiMhiTPTZHxz51yETur+t3oKcIQqg
         HIVvKNn+vbeFd1XhcNT2sQQTPpkIbqiyQNJUlzqVU4gP6EVeV27RfUNWhecI/xYZO0f6
         XTFkz6aPHKQl535aaCzeoZ58FxsruKuOprSYu2HzTh/UuQ8+Om8zkwVyzvL50y5Gux6n
         L75dOnQ9cukTZaFcjbMIBvGN6H2dkCGGUYnIV4zLftiBlwIrDxo1kYnvMYpe4IaHJyMD
         frIvGRgZ3Brz1kfmo0d1rWltnWpNkwyASfHsDeC4tqyySE7rRBSJvR5UyspchpciFo77
         WZ4A==
X-Forwarded-Encrypted: i=1; AJvYcCWpMpo16pDJBb5cQAenawhVp45ovapxKNH4L0iJ0fcuQ0whE/JcTo6O7He32kko8qWAlgTHcsoiXg==@kvack.org
X-Gm-Message-State: AOJu0Yx5TGTjWufXwer4/4v2RsmRykv20xBwjX7IYnHguNpik59aPDJK
	u4tbd4dD5IzlB4K/37eH2IKzOOG6mgiNkI16uJZtDJxLkXxK32IyskwySXF9aBzztCkQWlOTF9B
	p1lE6j+YoXr5/W+gf8PzZDmkpe1cciIR2OyWBJdEdLIM5YwPMIRpi
X-Gm-Gg: ASbGncsIu5gYT0SvkyapzzFqRl0PpWpTROXEqs0hu+B1ZAda1hKMj+b3EArEOZpbXD9
	Sx982OvSgxI90GMMPYKkfP5D7jBMYank4O9oFT4QC2R2rMDJsVdcBbxz70O3tCrcJoVMwSJ/kiv
	jbVUQxw+tDXGDZ1rgtJe1Y/1l2iS1rviRbdkVLKlJMl/I2MzYN6JKKPB8sQZvGSYthpTGSgF8Ev
	7L6hamOQWPH02cmrSSyiq3SA+yfJ5ORHE+/SJu1xswx0BT5ScX4LUY8k0XQ5PriOSGs6go6cjoH
	82iz51v939cplaime8SlmgMN8pf8G+qCtGfZkw9W+JKFJlwd7Dy2OHT1wMBppjdNCp32ZNbhDk3
	eTOQBBwM3+jAOHARAHdUcqrIk3MrGf5YPynWkzq4YmAOu3gfB19NBXxn+fulFL7nUtKs=
X-Received: by 2002:a05:6000:4202:b0:3b7:9617:c9d6 with SMTP id ffacd0b85a97d-3b8d94c4853mr6430780f8f.45.1754318173074;
        Mon, 04 Aug 2025 07:36:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgF7WdMM20TEgdrxz26bfqmzRB7DX+Wy1M6x4RxWiGvkCMPMJ2Regb4dTIbgWyxWvwdHL0cw==
X-Received: by 2002:a05:6000:4202:b0:3b7:9617:c9d6 with SMTP id ffacd0b85a97d-3b8d94c4853mr6430750f8f.45.1754318172621;
        Mon, 04 Aug 2025 07:36:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e9464f46sm1633873f8f.19.2025.08.04.07.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 07:36:11 -0700 (PDT)
Message-ID: <9f4e1263-c3d4-45be-a964-3eb0de828d95@redhat.com>
Date: Mon, 4 Aug 2025 16:36:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] selftest/mm: Fix ksm_funtional_test failures
To: Wei Yang <richard.weiyang@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, donettom@linux.ibm.com, ritesh.list@gmail.com
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-4-aboorvad@linux.ibm.com>
 <20250804091141.ifwryfmgjepwrog4@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804091141.ifwryfmgjepwrog4@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0etw12pke_y98JMAATYNSIXtruobHpfT0f8W48WFaPI_1754318173
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9C7E414000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: fp5to317fdhxsa45q3kfy687jsa34dw4
X-HE-Tag: 1754318176-333963
X-HE-Meta: U2FsdGVkX195zjqmY6XXt+uzBZG3pBlAlSIcjo8EFS7fkQgtGPyrs2HFEuv1su+uAExCinNh90YO4Qxj+8n3P3Jh85DqoW6B21i4WjKummjbYtR9HOBbRzK8HjIyj8wfvnRgfTWlrtGn/PqRlXmOVJb0Ix24bR5Ft+M4+FfJetHe58897YA7guV2C1exG876kqweYXomLQlC9wG2wa9W9fk5uHAOW1UbeXRqZzyWfk069xeJ21j1BIxc3DBTk/9CrwfwPGoAzVjNjeH1hOMGYp7rmursOo+/bu4TjboJqquxNAgFFrNFp52apRxI6kn0UbCRz2+MZ8882HrCwh+fj5Fttflls35oAM6vsG82nNuc+5OIfGz1+AiSTvp4GS+VKTexgS4I6I7cDbCrE60R8YeUfayIQmgKarZIGIs7b2HkfVvG5b5mtK5uTuLCuYnu5iUtg6tPryCDbLjaq5vm0IkJrowxPkijpX+9vH1b8UsEh7rzPZn+3Ij2fv/vY91MScnjJkMEVcKZ0q0ceTlA/WSUVclEIcxtsYjIEkEzdks4TGmGt+HhBNMC4bWE49DBiJJsB8mVHgzS0GFTyidRf1JRpYPvolbswl0XHXiDIKUk790JNeJl1OqTB+g1IRFNY1miKAsh7Q//qMMSvhNvDcjq80WKoNKhDAJ72Upvrqff7s+S+JQcHPXkDK6PTpGMCGwMUqrVJnqQpVtnPmII1wGopGZ8GK6I+qPQolzJGP3w9D7BOXDskkBKlxdWD/yumilMb+uehgQ51R99JJw7Iiud43GR8F1Fhqq8tcGCH8L7QtaXxsP8bBt7KrDmHOCrllnKkWBNWxnrjBHN8Di2nYbTik/5P9+NQx07u4i7FqOUlBUB8X1UI69J9SpYP/se85lvj1cd2lmqR9H/Da3iIiAkrqZN2OKnA4Bswm3PJtU2X1KChSggmbPx6nvHqq71JGJn5/Nh1OQW8m5tG+b
 ai1JGT64
 X5/xWFsg5RunUzvdKB0dRuPK0V05IgMojmphNSy+qexMZ1/GhpsC6/gu6PSJCQz1mo69JGiCIfJt38Jqrg5AbsSFWOQboTKT6DJQQQFcNQuOw9mm9p+FtC1lCy03q1grDZ4nXFWlvPcC7oWnN2fTPLY6/bQpPVbkxkmncuqw7ESOTG3fFKk6XoJcDIT+ixk5FrqrQizNmepTIokTKCd3OoVHDkt59eA1zOaY7JwvfBfbijT6cu1RW2tDIgn758cfyh/nonExlm6oYUWk9h6pj647VFHwW7TpZ/MYw0p9G48+eoiOKYZ7yZVPZDdc3sZ2VLKL8Jzf0JKBU7rSkCCAU5vVjZyqJNZsBu6CQ9srJmoJY7a8s2A26Pagk/ZigoCX/oBAmRRkKi/wBdeG7c9o0kyCGLOpE+c7uBjuqBT6uWM37sLFmg0xnAr4plvpJNquDn4xX9uEbLpQ0DmLGGYXXhVB91nMUB1KCIqGfVOkqamli6QapJN5gOrkEs/Il7q+nqiVnBxrUzr38qG9AypBobcy9+sAXTrTGg5J8i1Zi1d9vVE4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> }
>>
>> @@ -338,6 +341,7 @@ static void test_unmerge_zero_pages(void)
>> 	ksft_test_result(!range_maps_duplicates(map, size),
>> 			"KSM zero pages were unmerged\n");
>> unmap:
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> }
>>
>> @@ -366,6 +370,7 @@ static void test_unmerge_discarded(void)
>> 	ksft_test_result(!range_maps_duplicates(map, size),
>> 			 "Pages were unmerged\n");
>> unmap:
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> }
>>
>> @@ -452,6 +457,7 @@ static void test_unmerge_uffd_wp(void)
>> close_uffd:
>> 	close(uffd);
>> unmap:
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> }
>> #endif
>> @@ -515,6 +521,7 @@ static int test_child_ksm(void)
>> 	else if (map == MAP_MERGE_SKIP)
>> 		return -3;
>>
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> 	return 0;
>> }
>> @@ -548,6 +555,7 @@ static void test_prctl_fork(void)
>>
>> 	child_pid = fork();
>> 	if (!child_pid) {
>> +		init_global_file_handles();
> 
> Would this leave fd in parent as orphan?

Probably yes, but only until the child quits, so likely we don't care.

-- 
Cheers,

David / dhildenb


