Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC082D637DF
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 22:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E056B0088; Tue, 16 Dec 2025 17:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E180D6B0089; Tue, 16 Dec 2025 17:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0546B008A; Tue, 16 Dec 2025 17:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCFE76B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:21:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3629160848
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:21:51 +0000 (UTC)
X-FDA: 84226757622.18.7794626
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id A2C271C0012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:21:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=a8+RADNq;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=I7ZeflaX;
	spf=pass (imf18.hostedemail.com: domain of oreoluwa.babatunde@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=oreoluwa.babatunde@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765923708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HiBCIcpdMLJOIL1RNrE8wcn9Ndx6c9xmNAQz1tizXE=;
	b=F6r8aSL/S1AZOybqXZVjGIw42NPkzi0ouwC864zH8d2vp99wINsa3lm4fl65REVj+D0/ZU
	c21ivkyVKNvk03auTvGU6pjrdVp/cIVvzhmMBHCnzx12LLv0Q5VhmaN6kNNM4zYaW7Sgwe
	8Syo+afydJjnC8YeRAo/zXt0n65Au8w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=a8+RADNq;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=I7ZeflaX;
	spf=pass (imf18.hostedemail.com: domain of oreoluwa.babatunde@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=oreoluwa.babatunde@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765923708; a=rsa-sha256;
	cv=none;
	b=aNSbLFhjX/pS/ok9KT7z8aQS180C8AkZ6I2ogv7UWJRHHrPEsCcRzlpuvpVatgN994ovY5
	fg1Q/Q5t9b4gusIO1Mp5D7sgrIo3CThFgcdiBNN6gBmo7DPLfUTnJdeVloaxNxx+nVHyai
	Lht32XI0VjURiWAYQskfRt/LHWp6Sww=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGGDMu73872310
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8HiBCIcpdMLJOIL1RNrE8wcn9Ndx6c9xmNAQz1tizXE=; b=a8+RADNquD3dbLe7
	+bqhf0fh2DctX9R54PGcC0xDlKgryDav/GufPQFB2V7bE30tCggJx7MvypzhUxMU
	b/9r1Y7WAGgOPKxjIiOE1XcLn44H9ljW68uJV9beA7U/kHBEyM+Ts8026k8siSHa
	QMtexlhafmgBmWyf5dnjt36xrHB2obJM8eMNP04+Ejy1Q31uky9K/9QGfFtHVvQU
	Fl8GFnybqvANGF1dMjy86q5/n+p3C+tEpr0NcZpk4y/rZOrWG1oXnjM4jXHNZ+Tf
	LKMuaJS044tJvcVW81iCMh4OFEAMAsSWRhq7trDeA2OA4R04TSWHFsdTnYJ0KhWO
	UhY3cQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b369wa6ua-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:21:47 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so5353935a12.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765923703; x=1766528503; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8HiBCIcpdMLJOIL1RNrE8wcn9Ndx6c9xmNAQz1tizXE=;
        b=I7ZeflaXofjDdzOKjMo3q/trLw7RUsqgPesMXqLCW3fp9nTD7WbxQ48xYflCTlfovq
         ndVYT46fa2MlFtojIoZKbBBDvHcgicQnICpBUHELlaljzBKVyIR2r2bq/4HxXiWJB/gp
         qAdEcpFkZm2wwgOy2THleHnAbjSzgVJ0PRF9KYoDoJVId0xuojV3uT8M4aomuH3U+pqa
         TFXrGBZlAVDxhI2f4MO+ElvWtG7dWBvFXQBpKQOrYcmfNNt2RrALNhcJuPVBZAtIkFrN
         9DJYn1dYtBLFKQPZCFQFFGmLHxtqBpc9kXkStW22hI/ptdvi9fEOr/VbpYPef9V2T8Um
         GcBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765923703; x=1766528503;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8HiBCIcpdMLJOIL1RNrE8wcn9Ndx6c9xmNAQz1tizXE=;
        b=bzB1ljJTOfqkYrMu4O4KqwaCI+zQI9lRQ9hOI16QLRb+a/E7qsGdej/QAS+Af3u1yI
         nE5Xvqjs9KV7BQD9qXAiUsrpSFWwKpzUSisHxDwF5oARdLMQw1kVY6yT/zpPn+8YMicR
         JNeRxGOmYHyUzFDX0O09HMrH0z6cxJkov8nNLA05uNtMpJv62ADrkWhDeO2d2RTfBXuh
         YwTsTdCsfGqYt00E4NjT0nZClvDnkBo9czneXhi+EV+s/UHUpX67SrwxbIii6NNoFEnf
         DcX1026o3F8JpuAV4pZv9nvxrMYi7QCJOwa1rKv2DXRpWG8NZwndq4mcCa23bHU+nTeM
         VVow==
X-Forwarded-Encrypted: i=1; AJvYcCWCl+WIlB5kIiflzDD6HhL28ZnHJlohRIeUWTYnXONVnsGgcTOkilp8NlKioxCylkNLW2HWnxP2Fg==@kvack.org
X-Gm-Message-State: AOJu0YzbRUj75Hvol0V0hrgZaSfbhqeKX4SE316+fIX1+f93xERS8N67
	QbLUt9anYP53qx4f4tI7vv7T02kuqvh+cDjYZeNPUcHTU9tcCJG4AEjrGQ2a/OkAOcKICPIWLuy
	6+Hovj5S6ghkVlCekCrqGA/iSLDauduDLtetbJzhjqJJMMctU6tyU9A==
X-Gm-Gg: AY/fxX6AgMh5uT2IAbnsa2MFc5sFK3x7fLCu660uxjcpkzjOmtx5jU0dEpa75d/aO+L
	94gIViZRlgr6Y3ZQhej2H77zuTDIfgiJ+hFGpa4QbmD2DwF8xeiOD0vnwprBEj2Jleibn+QAKR+
	z+oFan0pUCyABPVwKmItrJ/1gRJXPlHRfMfCASKlSRqZDfriH4VOv2UZXS9uhvUpahjeBdSRdru
	qrpo+DYgmkZtC31H2qX8vsj+97otHiJmo55HzLPXpuAor7kMH+J3igc0ZWVzbjdJSmO1edCqiod
	SLXQ+JJy+8yuZs2RPd6qNEksB/fVCF64JtmtRIiimg7iLgDu2H2EJHjW4Fmnc9j9HCATjnT6THx
	abIbnUnjIOJ99MRysdVTB9ABsiGZIH1Gbf2IDh80kQv55f1a9kMfngdF6vEIdX7B0Hl3GRDjHSw
	==
X-Received: by 2002:a05:693c:40d0:b0:2ab:ca55:89ab with SMTP id 5a478bee46e88-2ac3014dce6mr10730972eec.42.1765923702468;
        Tue, 16 Dec 2025 14:21:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFi/A5m1zIJyuP7xZZ92DFDZYKgvLKmrGiV5FjsUQjVbjI+cenqaoY5wg0bM2r+933ZgklO/Q==
X-Received: by 2002:a05:693c:40d0:b0:2ab:ca55:89ab with SMTP id 5a478bee46e88-2ac3014dce6mr10730925eec.42.1765923701875;
        Tue, 16 Dec 2025 14:21:41 -0800 (PST)
Received: from [10.71.110.87] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ae4f054476sm1665750eec.16.2025.12.16.14.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 14:21:41 -0800 (PST)
Message-ID: <61102a92-ad98-4fbd-bee8-760a758b0eb6@oss.qualcomm.com>
Date: Tue, 16 Dec 2025 14:21:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
To: Rob Herring <robh@kernel.org>
Cc: m.szyprowski@samsung.com, ye.li@oss.nxp.com, kernel@oss.qualcomm.com,
        saravanak@google.com, akpm@linux-foundation.org, david@redhat.com,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        robin.murphy@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, quic_c_gdjako@quicinc.com
References: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
 <CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
Content-Language: en-US
From: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
In-Reply-To: <CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: HuLb4QLfcHt_DK43zzunRZeHu4My_KMw
X-Proofpoint-ORIG-GUID: HuLb4QLfcHt_DK43zzunRZeHu4My_KMw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDE5MCBTYWx0ZWRfX0aZD4I9+ldvs
 a7IQNlTP5fIzkP8bjhzakadxAkWpek1ZRGTyQUg2tLh3hjqpe/Rgon2xg0S1FyKBtOL08hpglR8
 o10m1Exa8wEaprrDLhyFMaqXtCXrC2aP+bM+NZDiiNn43MCWQXTDI00Pg4nQF3RkkhnhwhW+pj1
 yKrzJaoKFBCFT0K6GDBpbdN7lhSmk8ekljSzNl2MNWdCvuMjB6hGRcy+B9ixP1my2HC1ep9slCK
 jaPwPaR/pVZc5jwN1EWBK3FT+U/my2wo/zl5tjLmlPiVa/FT0mx2GyiDlUItAVlKd5HJ1mtAV36
 5UBKNHtpTCe/3j1Et7HIRAIVZRpT7IHj5jViZXo1h1F/dtfhPOO0hzQug3ZctPJa4BnYp/zLjUe
 7ZJIyQv4BYdF2qenxLFaiWLrDI8QRw==
X-Authority-Analysis: v=2.4 cv=MP5tWcZl c=1 sm=1 tr=0 ts=6941db7b cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=KYYUgL8zeczeCQrUCMoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_02,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512160190
X-Rspamd-Server: rspam02
X-Stat-Signature: mj8ngajmq6tysaic75negr7fjt4wnq4o
X-Rspam-User: 
X-Rspamd-Queue-Id: A2C271C0012
X-HE-Tag: 1765923708-999469
X-HE-Meta: U2FsdGVkX18nu1P+uYSceT+HZvCRnAplvkOfHQ9sHIRt/43vMg94hnL/x6QMsODuKgqi0onWL71lcMMwtm+qw3VPSVd7o0vOFOLKLZ6ya5iAkvzZZdMK8IC8OLDt5tVot6/4v8ZMFfSV7g0MECRsm8jD+foT2rUxWUm4uihgjOwnM/F0DS5GsU9sYqRBt5sLCgvo/AjlpTYCNqnA9FcqYAiNtmRd1cv+CL+JQjch75Hzr124bbD1lKULL0gPBU6dCB4f1YJA2AaCef6iXcpOOyTsEEGXo4LN7AV2XpHsLX4NgI2dQDOvkl8WZcEvfO1jO8uIu8r7gPRy1M6agNFCMaeVjsWDTpCdT28Hw84hx8G5Uw9Q9HiKp9KoJPpO+cdwQ81ltndIOzgzHOK3QcFQffQOdSP3E0Qk+GvkXZ1IYpn/IpTh7GUIR773hNSNicye7XMGmUNsjTbmkZLXPntqS1FUyObuIImrVca0kgaygdjOiwHvwEGVDHf6WNdBBizuaayeRQvmnq5AI/Z8YoqYO0jfxn+D+zivs82GFbfmUzVTIZ0G2uAdYzL54Lxg3yoCK5Khg6Oh39F3GoGKtdc2Lriq/1L9xfN+Tb1o12GM5RhXonsLWEP826HsViwn4VeAzcyNdEjx+muZKjB7uzrKZfkzpQAWGpitnXkG5feB/z0fMBa9ZcvW2TEBCs8ppruXlnILCSCUad1nBcX57izj21HHmSc2TuV/kjJWDJ2odSkpiDC1ZQ3x5EhqhReiUbDmMurqCVoQj788W9shd3m6PMJnsVeRhYGRW9tbqwFYY2FoFyDsvsIy8G1MC4AnR3figvljUsChSfAIZJ3cwsM6RzJRCCKiY6+pHCwxmtPAYzB6YJG0hpz+SQZ/OSjhpVMXiCLISDR59SqXXotYJW8KNoTn1l+zhM37ZK2DxWf0GaiTxOKtXohxcsmHdKixYJztUivBFmHyVG7EqD4gM7X
 NQOHBbVr
 XeTCHzNQ4aiLiaIc/zC4Ae9XZoePzx5AmJ/OsynjeMBt1R5OZPFczuGOdIzc4w2dl5gsBxkLSS+2tUwuM3sYE3Zk8XkBw2SI792RxX7nGVHnt4z6j47hkIfBbgcLWadxTUPZ6hgA0jxWEmiVuwv51TvFnEvoe3lAsopFXvv1mIiM2u2IhE+LhkZ42/RgJTew+MQ6KFvaeynHmcsYDNYbJy2xGNtBeLLwbsXs+oL37F/Lch76JzknOOkSyORJKtDI0DXckZXS6vIgyQrTGeG5rEv5PbPxqmlJG1KFGj1o+aZrLAsbfPzajPBuD0/pT6JUqkJsbCJgsHcMR239kvYrTbLKK2yHRz9LsN6mj/gT8Fh2p03D3HPEgQZjEpOJLWrwJbFy0ckIR3iAhNuYt7K5HuwHZl0aEhcpiFJ96NWhmlZQrQb+eJggVCRjp73Au2Qa7hcaIWwFkbeH18zEb1pTQImUt9r1r07d6jbFfpJZMs3mvmBJBrl8P/0FuNoVIoJkUSu7UBvjiCahMPbLD30J5ecezmeQXmJeI5//sa/ayFnuzASai0ixIHTrlzHoo638sPyxY50GDC+7y9eNAh1OJpr3oCwh34S1YqqvaYxyMW9h6duQpwQA52iqbEUFinEZyeIGGIH85x1G3Rj8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hi Rob,

On 12/10/2025 6:07 AM, Rob Herring wrote:
> On Tue, Dec 9, 2025 at 6:20 PM Oreoluwa Babatunde
> <oreoluwa.babatunde@oss.qualcomm.com> wrote:
>>
>> When initializing the default cma region, the "cma=" kernel parameter
>> takes priority over a DT defined linux,cma-default region. Hence, give
>> the reserved_mem framework the ability to detect this so that the DT
>> defined cma region can skip initialization accordingly.
> 
> Please explain here why this is a new problem. Presumably the
> RESERVEDMEM_OF_DECLARE hook after commit xxxx gets called before the
> early_param hook. And why is it now earlier?

ACK. I will add more of this info in the next patch version.

> 
> I don't really like the state/ordering having to be worried about in 2 places.

The advantage to having the state visible to the reserved_mem code is that
we can skip adding the DT node to the resrved_mem array since it actually
won't be used.

If this is still not preferred, another option would be to use a helper
function  in contiguous.c to call dma_contiguous_early_fixup() for the
reserved_mem code. This way, "size_cmdline" can be checked internally within
the file and it can call dma_contiguous_early_fixup based on that.

> 
>> Signed-off-by: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
>> ---
>>  drivers/of/of_reserved_mem.c | 19 +++++++++++++++++--
>>  include/linux/cma.h          |  1 +
>>  kernel/dma/contiguous.c      | 16 ++++++++++------
>>  3 files changed, 28 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
>> index 2e9ea751ed2d..bef68a4916b5 100644
>> --- a/drivers/of/of_reserved_mem.c
>> +++ b/drivers/of/of_reserved_mem.c
>> @@ -158,7 +158,7 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
>>         phys_addr_t base, size;
>>         int len;
>>         const __be32 *prop;
>> -       bool nomap;
>> +       bool nomap, default_cma;
>>
>>         prop = of_get_flat_dt_prop(node, "reg", &len);
>>         if (!prop)
>> @@ -171,6 +171,12 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
>>         }
>>
>>         nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
>> +       default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
>> +
>> +       if (default_cma && cma_skip_dt_default_reserved_mem()) {
>> +               pr_err("Skipping dt linux,cma-default for \"cma=\" kernel param.\n");
>> +               return -EINVAL;
>> +       }
>>
>>         while (len >= t_len) {
>>                 base = dt_mem_next_cell(dt_root_addr_cells, &prop);
>> @@ -256,12 +262,15 @@ void __init fdt_scan_reserved_mem_reg_nodes(void)
>>
>>         fdt_for_each_subnode(child, fdt, node) {
>>                 const char *uname;
>> +               bool default_cma = of_get_flat_dt_prop(child, "linux,cma-default", NULL);
>>
>>                 prop = of_get_flat_dt_prop(child, "reg", &len);
>>                 if (!prop)
>>                         continue;
>>                 if (!of_fdt_device_is_available(fdt, child))
>>                         continue;
>> +               if (default_cma && cma_skip_dt_default_reserved_mem())
>> +                       continue;
>>
>>                 uname = fdt_get_name(fdt, child, NULL);
>>                 if (len && len % t_len != 0) {
>> @@ -406,7 +415,7 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
>>         phys_addr_t base = 0, align = 0, size;
>>         int len;
>>         const __be32 *prop;
>> -       bool nomap;
>> +       bool nomap, default_cma;
>>         int ret;
>>
>>         prop = of_get_flat_dt_prop(node, "size", &len);
>> @@ -430,6 +439,12 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
>>         }
>>
>>         nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
>> +       default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
>> +
>> +       if (default_cma && cma_skip_dt_default_reserved_mem()) {
>> +               pr_err("Skipping dt linux,cma-default for \"cma=\" kernel param.\n");
>> +               return -EINVAL;
>> +       }
>>
>>         /* Need adjust the alignment to satisfy the CMA requirement */
>>         if (IS_ENABLED(CONFIG_CMA)
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 62d9c1cf6326..3d3047029950 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -47,6 +47,7 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>>                                         unsigned int order_per_bit,
>>                                         const char *name,
>>                                         struct cma **res_cma);
>> +extern bool cma_skip_dt_default_reserved_mem(void);
>>  extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
>>                               bool no_warn);
>>  extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
>> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
>> index d9b9dcba6ff7..9071c08650e3 100644
>> --- a/kernel/dma/contiguous.c
>> +++ b/kernel/dma/contiguous.c
>> @@ -90,6 +90,16 @@ static int __init early_cma(char *p)
>>  }
>>  early_param("cma", early_cma);
>>
>> +/*
>> + * cma_skip_dt_default_reserved_mem - This is called from the
>> + * reserved_mem framework to detect if the default cma region is being
>> + * set by the "cma=" kernel parameter.
>> + */
>> +bool __init cma_skip_dt_default_reserved_mem(void)
>> +{
>> +       return size_cmdline != -1;
>> +}
>> +
>>  #ifdef CONFIG_DMA_NUMA_CMA
>>
>>  static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
>> @@ -463,12 +473,6 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
>>         struct cma *cma;
>>         int err;
>>
>> -       if (size_cmdline != -1 && default_cma) {
>> -               pr_info("Reserved memory: bypass %s node, using cmdline CMA params instead\n",
>> -                       rmem->name);
>> -               return -EBUSY;
>> -       }
>> -
>>         if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
>>             of_get_flat_dt_prop(node, "no-map", NULL))
>>                 return -EINVAL;
>> --
>> 2.34.1
>>
>>

Regards,
Oreoluwa

