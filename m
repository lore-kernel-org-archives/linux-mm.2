Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C52B606A681
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FZN2qWfd
Received: by kanga.kvack.org (Postfix)
	id 213566B05B9; Thu, 26 Nov 2026 04:54:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB416B05BA; Thu, 26 Nov 2026 04:54:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA036B05BB; Thu, 26 Nov 2026 04:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8D386B05B9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:54:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32BDD12038E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:54:02 +0000 (UTC)
X-FDA: 85476809124.25.D2721F7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id A629914000E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:53:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FZN2qWfd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795686840;
	b=h9uAfNegbQOOw7vnxyJYZHSgHePNVmnuREMIYzGcHzjoZhCSl0efL0S6mpIv6jPFwptVyT
	epUwdKdJ4bXn8suyKF344MeCzzKxMtDV5obyZbV9PLL037tovdyOijSM/T3nuuMM9Z1OLd
	2r30VmIOVtcUTiYzz7ZrIQe/gexpmrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukj4Sg1+w/27c32YNvtbbyMue2DoY98FNZztnwJcgds=;
	b=vUFEKeFhNaZ2eJdJhKxMpaDuQK6kbORBSd3N9YhBF/vpRVJJVRXXNCfvMIgNJW/Cs5ialQ
	wckmZKs1NLPnQpxP1pMwkZNTHiSzjYyw7qusX2N6qpi7JvlVn4MKsBltFEbyPHeTYpFy7i
	IfUD5OjHYGfIj/CrbLdL3t4mGW2aAjQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FZN2qWfd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795686839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ukj4Sg1+w/27c32YNvtbbyMue2DoY98FNZztnwJcgds=;
	b=FZN2qWfd1mb9vbEfE2RiYWHugLDlAB6/B2wA2lKuCq79N83a5VGlQhuhn0A/bQFwsyPIC0
	1VXBIkVGD+EVSdvLKebWk569IyZbclbk1ybpR4kHp6nCTp1RKFJEBBtVymyAWzesoiqJIX
	JmRTU3bg4X1ANHiSTLKgaPmE4MTg2qg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-VZaCsgsSNJqQ3iNh922O2Q-1; Thu, 26 Nov 2026 09:53:56 +0000
X-MC-Unique: VZaCsgsSNJqQ3iNh922O2Q-1
X-Mimecast-MFC-AGG-ID: VZaCsgsSNJqQ3iNh922O2Q_1795686835
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5c14cc3cf00so2759641e87.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:53:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795686835; x=1796291635;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ukj4Sg1+w/27c32YNvtbbyMue2DoY98FNZztnwJcgds=;
        b=lIeH4hSlYav+PHlMwE4Vn7ddZq2pyYjFjI94G1ukznfe44mlaAWN9r1p3mi7+OB7gv
         0FFDA4x45dtvWoxJbFq4afVffVndC+n35oycQD9FjpTkfT4mUYW/VgHpyBEDnfVRCBOS
         Q2o4K26aX1KI1/2WYR6hlQ9wg7xudeR0a2rcWikJ7KpLn3BLptTvzhzJkgm1gblN5nXv
         ausRAbPI5sjAq6ud6uwy8w0WvrbYSLwYvpJK+q+YIpcKy6e3YZLAi/C1fxDanvZhxPys
         hqkzWwVOPg3ePaM2/utgxTmyBieDIz3G6pqEHDWarL/NurG8f1NVnoHOmBSC/HW/o/uT
         PdLQ==
X-Forwarded-Encrypted: i=1; AL+hErHL93+VXz4GONZEobdzMucndAL3vfZj+hu55ZMEQxD+VAknYkNtk7mXnypnkHcl1tegw20Nhc8T0Q==@kvack.org
X-Gm-Message-State: APuU4Z/NjlY8vl3tXj4AliIf4BWI0KR/Lw0mta9vsykGtJPh90mkpMrV
	pEwv9cdIrl4WtHU6W0PzzeX/X6SdziZc3BPchLpXbaIUd2Ej5cKMyfbtUaomZZvI23CrA3ce6wY
	iASBCzanRJzbYsoO67R0uxuiNINVpy6aWCHBV1GNvD33Q9crmfhc=
X-Gm-Gg: AZFdTZcuncuabkQcdK90eze+6agd96ukAN/D7XWPXuGXKs38I0uptkEs7SP1OYtmviT
	+S5f+Z9bJq3/agoTH7uYXPdXZSx9zmM4Q3coC8Lm3vN+lolv59LWY5+0UImV53hMMvHDAVKlSZs
	2nk9ncHD95FNVm05K6BXsJ0Zmt2qVfhyjh7B319u+P9hz+kUbEnEsB6rzindbpy+/zmvMbmQWFY
	Bk5j/OtZvPxZuTLPlY+kWY2txO+1Dks/ijqwWG052Yhgd+gefV0tHtTCt2NLJkH6LIrQawc4C/a
	K6+BLxdnbwQXsEQuv4b/hbY7QJFOKnqdpLcv1ARHHlMoDeZa9waYpHvM/kG9xDuJ7hvOQjpBLi8
	AxSEq2BEgspHII1fa6+bzwpMhsxAGWOm9vOtDHIUzFphjusdTBjQSpQ5z49vxOgP1FV86iSolu6
	RRqDSG
X-Received: by 2002:a05:6512:3093:b0:5c1:590a:ea5 with SMTP id 2adb3069b0e04-5c1bc82196bmr6367936e87.36.1795686835206;
        Thu, 26 Nov 2026 01:53:55 -0800 (PST)
X-Received: by 2002:a05:6512:3093:b0:5c1:590a:ea5 with SMTP id 2adb3069b0e04-5c1bc82196bmr6367930e87.36.1795686834668;
        Thu, 26 Nov 2026 01:53:54 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bcf332e3sm5099396e87.1.2026.11.26.01.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 01:53:53 -0800 (PST)
Message-ID: <a1ac4efd-7d77-4352-93bc-44c4d2650ab1@redhat.com>
Date: Thu, 26 Nov 2026 11:53:53 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: move the HMM migration benchmark out of
 selftests
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Balbir Singh <balbirs@nvidia.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20261126025653.1344932-1-balbirs@nvidia.com>
 <fba23668-add0-4787-b027-bfba1f66e090@kernel.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <fba23668-add0-4787-b027-bfba1f66e090@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yZy4yOawfjDHtORsUQTrL8Lg8bUs_aEw5in22uiQt4U_1795686835
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A629914000E
X-Stat-Signature: xo3jgffuqretodnpz357t1pp4nfgp41g
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795686839-513360
X-HE-Meta: U2FsdGVkX19fL7ohzGHyf+0foTqk2CAZ0ecKU8k5UCc8WYboavboCJonBwEMmmr+4DxtSFzIUbfLpSYX7jBaRu8mh2oFVWe/sDQ/6tCpHH9SfNu60sdYyn6cQERLe7bhct/fJBSbs1CmkzVeLcafyT/D/6tXP1+7dQozXdo4rS5NLz/6FLDd/Tw3XzhGZ2caYidNxFjyCxRzs+dPqWUwynTD20wYbXIXDbc4Uzs+sTkDW74XCfzBrrJR+2Xrj04QS+3p6QL1XwDPya7EK/ZFF1nKiBGpsG4xEtM4muNheZnf4/jSngR5Q9h+1GFX1b3fsbFPZePtlm1zU4bXzSIW738cCWPz8ABfa0D/1/lF/+VV1XOncPSQiWbFIT7iTWE7y2XDeB3wiNjUIgX0tDrT6fztZsMxVqhY/u0nbOftypKi4GA6l6uEwqb/IylI8+p13Ebb7DuZGH15Fsj/NL6Ch0it6C2eKe01G51Py4AkcZgaXjgX4bLioD1jeEfLIv6YeRGojq4w3Brq7f2OHFCiOl75YkWLuFMUUyPGmHTpyzs0Wb0NS4hGZsvNR4fH3FTAKgMiO/x7ql97CSzK2PtzkgzJcydR/PH4YY2oybl+nblclFUU2j8aEyE7NcTHFPSRj7rZfIEsVPb8RR+8d64R0oUWSM7wWRC1w1q/8EcExWrbyLT86rQhvX6kSAcuwVMvHACqnHpKZTLapicUiTexY48GOoNVM6Wthf5CP9ESJqn2CQtFElt0sLjzCj8erdf0dbVc6jEDDd5nYR/cATJhk7CJojJeK6j9w20J0U5Zg1BT0Y907zWUPnd4M9BdWnex4EgSruxCQ8shjTGNu7jBIcovQg4dwFAJJKoY+s+0fWO+BYrLWaq2GTx5orBwLF/q2G1cWjrbKBK+k4cJW4mu5pX/zTeaSGGxprqq29eCUV3zMMBGiD0fIuBoZy+KD3wKXIdfn/ZwKv4w3qXJnOA
 tvtsbhR+
 5tznjHeub68bph3mDhgowlvD1HcAIXsYm48pxpxQjxHa/eocPzmux7kNcb72TxNeTNCP2Ejeqv4FXkRP5J/Z6tUAIhgsTpiMZEZHQVItD1foxq+mlUi6/UqcfXLRxiGCDxUECqx8/LED7jLGmR8xds3PKFaMFq3R3RoIZiW6gtpGYGvku1zQ2Y6XAT8xyPutDV6rv6jOw3Ob0wKs/Qo5kBx/VF+RzDJI9EswhfZvn8dt7pDJIa9JHyEp8s2mfasAWvzOwhPfuAOYPN6V7JLRT8dHY1BlAmT3hSf0QmzKZrKnOX/rLLh/a7h5nQo+SLpRFP1WmXZW59vCXtLHPKrZLK7aGXR4+1fojOTogucXjeRV5TcUjt9HV6+YN2X1RyEoOOHAt7cOCzANIh9HmeYFDPPG1tUYL8RGrwMYXZQoPGMPMLUDt03L6Pa3hnGxhMKfEmgjg+ZVmn+jIgrXBQRvUtzHPfje+bZCzpPuwnDwIAimsSwxu+xIQkbwixj4NxoUUGSbZlhHuYKgyspB0lC7I5pMWZ9b345d4dW9xM7LLDR4ccKMOtkGxACQnptEH2h00yZR5GAU1txZsjoRbWjUg9mtuZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/26/26 08:41, David Hildenbrand (Arm) wrote:
> On 11/26/26 03:56, Balbir Singh wrote:
>> The HMM selftest runs benchmark_thp_migration on every invocation.
>> The benchmark repeatedly migrates buffers in both directions to measure
>> latency and throughput with and without THP. Run it on demand so the
>> regular suite spends its time checking correctness.
>>
>> Move the benchmark into its own hmm-bench binary and share the device
>> fixture, buffer helpers and migration ioctls with hmm-tests. To run it:
>>
>>   make -C tools/testing/performance-tests/mm
>>   sudo modprobe test_hmm
>>   sudo tools/testing/performance-tests/mm/hmm-bench
>>
>> Drop the 128-PMD buffer to bound the amount of memory migrated in one
>> measurement. With 2 MiB PMDs, the largest buffer falls from 256 MiB to
>> 16 MiB. The remaining sizes still cover buffers smaller than a PMD, a
>> single PMD and multiple PMDs, with and without MADV_HUGEPAGE.
>>
>> Call fflush(stdout) after printing the results for each buffer size.
>> The kselftest harness ends the test child with _exit(0), so timing
>> results still buffered in stdout can be lost when output is redirected
>> to a file or pipe.
> There was recently a discussion on where to put performance tests. Usually it's
> much rather tools to test performance.
> 
> So what about tools/mm/ instead, where we also placed gup_bench.c ?
> 
The slimmed down test runs very quickly and with less memory pressure already, so maybe not a big issue keeping that in hmm-tests either, i see the value of having all HMM tests in one test. 
But tools/mm sounds a logical place if want to separate tests.

--Mika


