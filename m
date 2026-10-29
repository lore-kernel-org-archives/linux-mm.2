Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D14606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=R2WPL6ZU;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=taIap1Cf
Received: by kanga.kvack.org (Postfix)
	id DC9866B05CE; Thu, 29 Oct 2026 13:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A766B05D0; Thu, 29 Oct 2026 13:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68C46B05D2; Thu, 29 Oct 2026 13:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E90E6B05CE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:57:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 288AF1402B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:57:06 +0000 (UTC)
X-FDA: 85376420052.08.23C3164
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 096824000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:57:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=R2WPL6ZU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=taIap1Cf;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf17.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793296623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6u0rHBR+nKG0I7hTd+T8m2cWP7AXG8Lp35TLCAr+jM=;
	b=Mv/wlQjwmu3BbUmCl3OwF/DEeqwDMyzt7fT2kw2yaRRCU0miLr2mQNCW3iUoFW8EGltrsZ
	NzSidVukVGTKVK8X8Bbfuui6BVMH96RKoiquOZ6OwXw16AbdYEzgo/EBRefY69tTO6J5zj
	qmqvBfqCOhZj4cFBDsxoo2m0kaOuThk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=R2WPL6ZU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=taIap1Cf;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf17.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793296623;
	b=qyqnMBbQaP84WXc5Ecj+QPZ6VKm9BjAZ5kSVyvzTtgj9FI4FsU1c1ObUrFJxDU25DSveUc
	IUZ7Xh3uAnjpz0/Kd5mgzv+XxNMdqQSkijCrytMPxUkxCnQJQcLAoEm1S9aDeNeNQVV2ga
	ustOe2oZJX2p9jPW5e2ReaF9Q1P6vbU=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TGYfvh2341662
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=P6u0
	rHBR+nKG0I7hTd+T8m2cWP7AXG8Lp35TLCAr+jM=; b=R2WPL6ZUjrui4fmhn+Sb
	e5gUuP1PcNQgEhpFzYKIMjAXUlCBgrAZFfkmm3XlKqse9oF0ByxyWXob4U/8jsI7
	UG3avqA23zTo9Rint/Ahb7tLRBn99QfnVE6johJgca7U88xHG3fazeMGoSKsKuxF
	VyKAGdu8hGjLMmB3oOaRNVdENLuZhc6z+K/XqWg8D/c0ExoVjyP89NQAAOc/dB6H
	WUbsiI3nCIEC1zGOpR8Xgmt4+wKX3PUEdrwKLUXqu/dlDKsJJMF4i5Bw/XfFFqYQ
	QkJ/lAtndodswk3q9A5u9jLk2XPikQEu2Ocb+VszZ0YRLh7F1+9zSXhm5LEUjPMr
	jA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hm7tt23hf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:57:01 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-934963b2bc0so433212785a.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793296620; x=1793901420; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P6u0rHBR+nKG0I7hTd+T8m2cWP7AXG8Lp35TLCAr+jM=;
        b=taIap1CfEQjbkNyVsVO5BYVHcTDbeqcaaYDS0hCh2J8Q+y4O1fe40C929WnDl2iR6T
         E/IkH1xs2P92QmTRuZbl4x9JZRkvHi5i5aRfv0uPmg4JhYqrPwdySvqprVXiC1nasH/a
         6nnoKUBMxjqSCtnDfrQa8NXu6+BGKKxavGIXJdo9nAlsPNHx7UsZL3w8wl0I+Qbbsue1
         JsGE8Tk2SZH/CW9XUfk0r8ee7D39OiC4x5rm26PvM+hPYM7XLg5tKd+jhktHGwms+2FD
         Nw86rxbenMya0vttGZNM4EZkwXA2vzyJZfj94uR//pznZwiJapJmISiUu34SFHNXJKSs
         gpWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793296620; x=1793901420;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P6u0rHBR+nKG0I7hTd+T8m2cWP7AXG8Lp35TLCAr+jM=;
        b=b0XmgaJNBL/FUTJkY6NQiKwhlOTXUFLrAkeJ7Xd6brgb21ulbz57ndCYWVXWZr9vLu
         K6JyvMneuVRYGTb6Rq/dIz+zE/ET/FCL/ZeKeauEsUK9TIqikowBMNUT77KAXAKZAuSb
         9q0UpphWX76ExQnkpNUYcvLXgsBb4wbasJtjNHj/GHHhpLo+35ZXI0LScAGnPfPQLZ+6
         lrU0uP6tvhOO6HgLZXWaN5r80R+0jcFjoSiSxlOzvSvzfe6nk82ocpFEw3Pu6Hl4BjJh
         jf2CZBJ1DdzLQM5HRTTncwOYAyRyOFQxLnHkCTq2efmHeeuML5333GHSi7CBr6h+tNOp
         tiTw==
X-Forwarded-Encrypted: i=1; AKwUvBze3dIWPpriX+IcHBC4Yq1Ek9JiN0weo2ks/xsMuTc9AcuOBcQJ4rjBXtbAec73I5nrMM7z4UeieA==@kvack.org
X-Gm-Message-State: AFq9FYKUvaJfKAQoZPa5F3Az5KnX6e/5J3dIvQp4HZCikgOxH1+KTj8F
	mw7td9CNVAXG8HwKigVBi6x24DmiyrY5+8siLxKVkqb/oI3KrpzRIji0jCAdFwyUfVfyqUkyAC6
	ZQbFkw8TkXBd52UIPCumbSUF9035CL3TuOQ6Bvq3wIiSR+jl/
X-Gm-Gg: AYBFou00qieMgHcxdJtx+ds0PXDfUpMvkKyWu4WN4ynlpJINRAzLOUYVc+2itQKJdPn
	k85tlPIyQqkrS77s4lzSUvuO95sqjMV/kRcspXIpOzfY1l5k97HdKduT+lKYvA8oAFwa6eO1DRX
	9nvXNeN5vdB9BRn2TIG0kbhRVzPTKsNWmpSTU+qzilDiFh/ex37XpZxx1Xk/WkHmo3g0S/2Tsgp
	XhLV5HqJDxXayvnmf+6178wW98IO3tU+kEiIy/8Pvy6McOLjuZy9et5OoCRdEZ2nmz5nxZvrTX+
	h9irbEn9U8QVuQxB5oGD/7V9ZnzuBh11eGeqvubjPzMOFRutOBtDA6iG4Ci/D3GEaWmZekQhzkl
	9tHwqR3o7wM/pNqDrjuilLcznEWmypgQiyib1aO47TFWqXu7nYRq9YzAUQq11qc2CfXR+kkvOas
	mT6BMKJaa5ocwmvRaRJgiaTDhnhl6870MbZz6XPCjOwsdp4mEL2NoExPOmLEYTKrnr5+C7qJrGV
	OIAhKsxKRpgiOo/1xNOApm/LYr+fD3NLMDVx0/XqhLUObkwuNIW6+ot+ttW5FZe86g=
X-Received: by 2002:a05:620a:40d5:b0:93e:c12c:43fd with SMTP id af79cd13be357-94408d5083cmr892193085a.74.1793296620598;
        Thu, 29 Oct 2026 10:57:00 -0700 (PDT)
X-Received: by 2002:a05:620a:40d5:b0:93e:c12c:43fd with SMTP id af79cd13be357-94408d5083cmr892190085a.74.1793296620185;
        Thu, 29 Oct 2026 10:57:00 -0700 (PDT)
Received: from [10.206.158.158] ([129.236.230.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-944212069b9sm3934585a.17.2026.10.29.10.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 10:56:59 -0700 (PDT)
Message-ID: <0043912c-4225-4d2a-a8aa-d160c832e7eb@columbia.edu>
Date: Thu, 29 Oct 2026 13:56:59 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: clear the hugetlb flag before leaking a
 hwpoisoned folio
To: sashiko-reviews@lists.linux.dev, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, Jane Chu <jane.chu@oracle.com>,
        linux-mm@kvack.org, tz2294@columbia.edu, Zi Yan <ziy@nvidia.com>,
        kaitao.cheng@linux.dev
References: <20261028-hugetlb-hwpoison-leak-v1-1-77ce56002523@columbia.edu>
 <sashiko-outbox-189633@kernel.org>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <sashiko-outbox-189633@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=E6lYNqdl c=1 sm=1 tr=0 ts=6ae388ed cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=s68UaERRFoarOrKl7kvqFw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=N3hL5AxQErDOUL2KMnYA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA3MCBTYWx0ZWRfXwmngaGCGBt5V
 KyayEqspE5hQ5fn+6lFcufLYifLy9MjXIxwiDd4h42YYWvxs9/wczdxldlcNmfQm4eybg1z9qTR
 PnveYMd/aedQPMlWxNWKSJc6n+lxAh2mdHjByAcVae0tQnISUXAmPoOxe/UlZYAcLUOQe9onK5A
 qzb536wGvk247dNrR15sZ3YbSlZx2EHlaJ7I8Fh4tU8PL374ViMqEUkH+bI0P6ljldZ/tiF/ZVW
 IfgFijU7R0wnq7QotSgkADXkGHCRyy6oEHtlUU5cDn1lyoyeR9UWFNisesZ4NtzSogC4zGf9Ax9
 6kUFLEq4AYRe1QURmlSTyPKyR8UaD5p1c9DbpLQzuteaKebNdMn0LkEMort6B3RuT7y+GP5xogY
 yxo/uheDyMnWra4wce7v18eR1dHZxNuRHJb7usgH2LiHuwho8taNk9wzVWuW+sRK6i1HWnnyOEj
 1OdC7a+a9aoghAAbXDQ==
X-Proofpoint-ORIG-GUID: AX_IhCve6HsGY3iJkAY6XRlAzhF3sBRs
X-Proofpoint-GUID: AX_IhCve6HsGY3iJkAY6XRlAzhF3sBRs
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA3MCBTYWx0ZWRfX0uu9zQmq3GWe
 dgXZpMznplLc/oXeEYR0nkJzb/2eqSfPeh1R+c0sRkbQQ8zvBRgmile6T/MlLGLU+p9KxHgIHY8
 zqwx6wVBa0XNt39eh8gFRGp/46i6XH3vyI22Ptw5PLNgPRcn6oia
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11950
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 clxscore=1015 lowpriorityscore=10 malwarescore=0
 priorityscore=1501 bulkscore=10 impostorscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290070
X-Rspamd-Queue-Id: 096824000B
X-Stat-Signature: zm44rwuzgwrtterwz8errtkuorntbofo
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793296622-239673
X-HE-Meta: U2FsdGVkX1+KRkSXgqcJegeKWOCYRdneaaPjYkvlB/E3BGwFvC0KAwbycObPxb1W+ogOmxtBOkXDVdzuVhG6N6/WfglY0Dk4SJODtNUYoXaZ9rajiWk/9v1cMbKX/X54UCTm2DttQwxo/IZ7KPoVsTHkHKilU7ZsudT3Ax62SoTAWnzT/JlIOOkiKexzJYKDj5rlB875dhaK4n4AMTdrv3Idv4ym5/J4PaREifdW+H2h+foC14yVmWzTFiwa6E4CvRCdX0byaU2LDkCg6kJv4YvAxtHK1agYCKtjTBIQ/Ywjj06C/STxtXOz/CJlx4z3J+h7p2W6NbL47lBS+nP0Qyz+6eW6xzjFDClOijCD8+qxxPAgwf5Twx1m2lIskfzDwQBpFpsGPKCpyyRBg8Tq9Cp0Tgj+V7uzNWNGVLDeChudecNP+LNVsPSu3k4rKCMbi7d3BKJbBRtQw7H0mqSy80qL5Itf1JahfGBDhEhG3LiyP52RPJ1b8O8gqfv0aRAxjxQt4O5JmyVNnn4lmPxOF+VnxGz6zSHI5lK+HiDto1XYX9RI85hGYqnT3E6QuYRJokQt+5pXOpZ3AGMq0eTRYdeeiIqBH8RFJFF2t5RUjs7qRZuoErRkpE7TAygCwKQEShuO8HUTrXtd1zFQdjql5fJBVNs3QxQ1J24bnxUZVGhGKSzVvBh+NV9mRGnkQ9SFnSeuNfqFEcIL6rMMF74RzWjEdo48b78Vie3cx387iRxlcp71GqOZYTMYS0x6MaUUv5SpYlFUwpNxrtybp00ADl6DJra7ybz/WbohSDbK+pultsjRcSvtHDMPxsaGLLczICMobDMyhH/jiXiC75eJN6tNs1GGinwq9NZihXawC419KInjeDNW1xR+mqCkxDXmIaVR9j+U1CpqVZGLwMf07K3XnxjY2iseRGoH1juVkP4LpPceSDA17LttHesgEkzvlNhZ7Vxp1PPdDqQ5/3F
 ZfKYI2kT
 qPcWtEDthd+sEwCG6bQfk9fvGssI+c2uBsPeRDKFYLqX8xizkBkCKpeTU6tZk0tMcDeFmaO39detYXkDxr6+f3VFKIdAn1IgMQNK/YLPIg6NglrANqapnTuaTUhKudB4Pr7iaTZmcGakSLbY+eEy6awzUpDFFnh+37A/0hd2q7ChkkBaNXFvk4bEdNxWaXJA28YuSRVkMndXRC8Jvx4X+rpT/HF5hnJ6P36Q16W2Lj+tnH6gqYfvVjEd8JePqF0Lk04y7Kzwq14+J19K8e3njx5j2LnqZyCQMAA8T1YUCa1EdR8Jfgq1RJ+15s2Qfgzotyh8uXRlshWV221iijRUztrgKVy2v9o06XAGyhDIAmIJYzwKJCBS/7aLEvqqH9td9My5ZKcc3/Rtl2cbQYGxAzd2YF/1xKRHrDXHoZk17RPumMhkFKaVyUhdVkxSxkt570ZlOJgJ/MiJ7xtQlfIxxrebd0mrCqiSok1Sl27wqs793zOfbl/RbEXKm8omt2qCDTvoERdMDO+otHuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+Cc Zi, Kaitao

On 10/29/26 11:43 AM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] mm/hugetlb: add_hugetlb_folio() clears HPG_raw_hwp_unreliable on error
> --
> 
> commit cae6d1104a254ddb073fab05f2a9308005af88fa
> Author: Mani Tofigh <mt4022@columbia.edu>
> 
> mm/hugetlb: clear the hugetlb flag before leaking a hwpoisoned folio
> 
> This commit moves the folio_test_hugetlb_raw_hwp_unreliable() check in
> __update_and_free_hugetlb_folio() to after the hugetlb flag is cleared, so
> that vmemmap-optimized folios with unreliable hwpoison tracking are leaked as
> non-hugetlb folios instead of causing dissolve paths to loop indefinitely.
> 
> [Severity: Critical]
> Can moving folio_test_hugetlb_raw_hwp_unreliable() below
> hugetlb_vmemmap_restore_folio() cause hardware-poisoned subpages to be freed
> back to the buddy allocator as healthy pages if vmemmap restoration fails?
> 
> When hugetlb_update_hwpoison() fails to allocate a raw_hwp_page struct, it
> marks the folio with HPG_raw_hwp_unreliable and frees the raw_hwp_page list
> without transferring PG_hwpoison to the subpages:
> 
> If the folio is later freed or dissolved and hugetlb_vmemmap_restore_folio()
> succeeds, folio_test_hugetlb_raw_hwp_unreliable(folio) will now return false.
> Wouldn't __update_and_free_hugetlb_folio() then call
> folio_clear_hugetlb_hwpoison(), clearing PG_hwpoison on the head page against
> an empty raw_hwp_page list, and release the poisoned subpages to
> free_frozen_pages() as clean pages?
> 

This isn't something new with this patch. dissolve_free_hugetlb_folio()
already drops raw_hwp_unreliable the same way when the vmemmap restore
fails. Zi's change [1] to stop clearing folio->private in
add_hugetlb_folio() would address this so I think this patch can rely
on it too.

[1] 
https://lore.kernel.org/linux-mm/A1A14368-7A43-40ED-B2AB-C2EC2C5FFB1D@linux.dev/

Mani

