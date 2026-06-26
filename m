Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 381EFCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA676B00E4; Fri, 26 Jun 2026 05:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB736B00E6; Fri, 26 Jun 2026 05:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5236B00E7; Fri, 26 Jun 2026 05:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C66B06B00E4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:43:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 497A1C1E05
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:43:55 +0000 (UTC)
X-FDA: 84921577230.06.9BAF932
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8784540008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:43:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AJVYM1sO;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=QB9l6ENd;
	spf=pass (imf12.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782467032;
	b=HUiEqbpYePf5hd5xkMB7uUTwmlfhMVYHSZ/mgcIjgxcj/Mq34flLpHX95EaO0hsR+wKt5+
	Gh7Ddza9vcCiurvISoAY88iGtg2rvVmoQYT6iFJVbQBx4GwQDo5MhRdaPok6y/hgqaUbAP
	rR5QssRDCSGurHiDGtKgsj8GJS63PB0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782467032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJR0sgePn08C5LSYaXjJKVn++m0V1zKkluMfeBu+TGw=;
	b=5+c+uvNrcxXquqBhwzJBaLlpRuSy806HX1RndSwLiXslJ7IrGS1KWIq1lcWhkdl3pgvu77
	d51Q8567TYyRFVM/okCxGS4MRn6lKuRIsvBHc6Avh2SJXAKvFrs+Ex9tvy3Y9QZjLR5iBp
	sT+xCkIW0CeXHGUIg9QFO5eKAwmwE9s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AJVYM1sO;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=QB9l6ENd;
	spf=pass (imf12.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65Q6VWFN2823392
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DJR0sgePn08C5LSYaXjJKVn++m0V1zKkluMfeBu+TGw=; b=AJVYM1sOs7RyYHBz
	RCmf50nu5Av0PyOCRuE3+YF1ALmXhNJpKOHhk3GrnZl8rtk+HUPukr00+bZcaWJp
	r58fhRFeLRxl5n1H0LNu7MBjZxlAvZI1Uq0uv+VRGfxct1fkX8fH64cvDYDV2BmR
	6Eu57I2ufQo6rUOikWj9q/pJCaPrXICsXGhf4yZc/VOoFNkKZwnsh5zZMNt8Qju5
	SCIbPA/ucYdMWJ9fcqOWPPCsT8M7sAEKp7H1EsyikkVyf5xHq3sSJpotN6sI9rif
	G3F2Ur6YqUqP/tVjYYXK57JlPNIT28bk1beZxc1cu0WkOtuW1C9l8gRGQt0aEtpp
	fkj1eg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f19m3u4rb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:43:51 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-845b9e634ffso1128044b3a.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782467030; x=1783071830; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DJR0sgePn08C5LSYaXjJKVn++m0V1zKkluMfeBu+TGw=;
        b=QB9l6ENdABDxuk5lODe8gpM+0dLWpQ+XwOpqzYYl7Hlz6WqdMBbtJlVHf4T9t6kjhs
         XphvKi9JwpykdLfZbnJFgo0EXcqvEjY8TVP3AUS63gFcNjMcAQn8krFKMX/hHEkdp92d
         +4+nknWT8PSSG9IqKjTBSrxhwizZ+ak2d0fubtWiyW6Vn3EZZjWXLsrNLC/3D8v2H/jC
         5vMjr/iubFeYzIOEkIP6sEsL7MAl4eJu11N9l3STqmTaJXogIXcT5sl15BgNLqEcHkCy
         9xmem34CKg0Rvw6KlCC2Wz+hIVqBY55j8j4eudo0DQrMmI0CYph4ZWnyjxwiJDyAAv2P
         boRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782467030; x=1783071830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DJR0sgePn08C5LSYaXjJKVn++m0V1zKkluMfeBu+TGw=;
        b=D1YZCW/t0QaIczsvba9CdEm0Irfd1w1GEWvV3D+2AsQUHYQSHNQkoiWcHR5XIK9j1k
         cdF13UOG5dXnm4Ini4zjNXMQA4U2xd5pR+q7Y5Dqu8qTDUV3B7whKu82yMepaKoCF1pP
         tXVgcptnQDZ1vGgTOQgHCWP0QinNpT57kK5HNl+KD9ASgqfIvuPMroH8NSzjGI03j8LW
         wlg36PWI7JzFr0wF/TJ4/YEcHS1fenhfM/G6HE/ovWh/4UZbacbTD48S9TsA5GGnvHbC
         TwSgtXiQf01T96T7ipqn/Ixu21M646BxO3lCAuqg+3jK0+S2LsP4GxlGgLuyMi85WONF
         5CWA==
X-Forwarded-Encrypted: i=1; AHgh+RpDIthP+8zLdZ7yyHkwRtix24YN0+JI11Ns4urMBgb6d2j75IY7YQ+IbCqDG3VvO0Iyv9eBvnuiUQ==@kvack.org
X-Gm-Message-State: AOJu0YyUQRWIc2fAk1mb89Zy3RhFY+Lc8CQ2Vu21bmNcz2xQsvpP/xDe
	kI4ExppqxGx/1VK3SnP/MklyLGLeZjGpffBcIlzg6lWruhb0txuFIMGHTmk+JpvbVORoNrxIbAn
	13qsR4wgNb7AYjamMcVB67nd5iwcg/r++UyjMiOrBTmtT/3AgXmO6eg==
X-Gm-Gg: AfdE7cnzHoeDgDdSZSYh8M/Bcu/wIc5+C4gJo+LvZYZP/Aagix4g54L60QCD5iosRRo
	6fHzfLrClzBSx4tkz9DgcVGN5T2plr/SeXAv78KBk3JL0RJKJHDWOcDTTBssTELonyDXBQ3YSxF
	ESJogX8Wqd6YIaNZxcKVxzwM7vfNUgJpSoeqcSJEWOVFI/TxA4aTvBA1sWexxxvM6ix2ucCtMZ2
	oSk6MifJz1UFELOkt2kyTmFUjJFRnkufA9OsxyXBQhVO8vZz4Nj60W4mfOU34XTtGWFjQ7tkY6/
	AyKynVhE48/ImUyeUjf2+YKrq8CTfzJjFPnOzfobAQY217gDp5xirtzdk3WsbdyrmuYXyn9Jgzb
	cknCUunsoFAgwg76hYGECLdiKTbP8uO4CAr4Ld+Cv
X-Received: by 2002:a05:6a00:181e:b0:845:c6c3:5e7c with SMTP id d2e1a72fcca58-845c6c36675mr2099903b3a.6.1782467030099;
        Fri, 26 Jun 2026 02:43:50 -0700 (PDT)
X-Received: by 2002:a05:6a00:181e:b0:845:c6c3:5e7c with SMTP id d2e1a72fcca58-845c6c36675mr2099876b3a.6.1782467029665;
        Fri, 26 Jun 2026 02:43:49 -0700 (PDT)
Received: from [10.218.25.225] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845c5d248b4sm1123098b3a.37.2026.06.26.02.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 02:43:49 -0700 (PDT)
Message-ID: <f3f3ab12-d473-4c49-9339-cea53e1ff770@oss.qualcomm.com>
Date: Fri, 26 Jun 2026 15:13:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>,
        linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Lorenzo Stoakes <ljs@kernel.org>,
        Pranjal Shrivastava <praan@google.com>, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mostafa Saleh <smostafa@google.com>, Balbir Singh <balbirs@nvidia.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, Shuah Khan <shuah@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Santosh Shukla <santosh.shukla@amd.com>, Wyes Karny <wkarny@gmail.com>,
        Sudeep Holla <sudeep.holla@kernel.org>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
 <ai3kkIpaR0aT_6q5@casper.infradead.org>
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
In-Reply-To: <ai3kkIpaR0aT_6q5@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI2MDA3OCBTYWx0ZWRfX7ZQIj7dB6FU0
 ulqdRu+ODsxcsPFwToxt3sMfJYaaMhafHbNhI/12VQlRl8nBzGU++spmlb4DtMqU/FfwaIAEc17
 pQjYRAE50KT2/Pbc+hlwpA2iO1R1aXA=
X-Proofpoint-GUID: fSlJichCqTHUYF66FFPXI0ERwus-U7wZ
X-Proofpoint-ORIG-GUID: fSlJichCqTHUYF66FFPXI0ERwus-U7wZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI2MDA3OCBTYWx0ZWRfXw6vXHENs4A+C
 czHiZLNaZ0zcnsj9GwUE+8OJDT9BDWt23wHKyuQZ3OI6vVuib+kMQtMFcuuxKxnAsxt8cT129Fl
 e6Sl3rAt8SADtg3uF22OLBC47+Up/5LpHyza2tLGNiMmijZW2cNcvWJ5wfaHPQpuDhdHX810mGE
 b9avQ0q4ft15/FAk21dmYmsjV2KqtQyJtvl/F3Mu7XvHWVDvIcundI+xU8VDzmjulEa+6xnqiQf
 6n0y1DF01An8CgNkzIADq99B+zhsxtsbnWSMrbnBCDFoaNoKSU2ogesBsPi6f3fDlaT2FLo0XBD
 uabm5csO4RE7yJ8SBTjNKqo7ircNV4GRfGnioWocqFv4+e/BsOgEhYeDuQ/k6tqivCQREh5bAG7
 1LsYlYDuMlBFxrNpUySHM04+nZzKT+D6lEAQZd6GMHRac7KhsWr4/hUMoboikPVXTkD10Yj1CHd
 Q9v+kX0QxsoDRTuCVyQ==
X-Authority-Analysis: v=2.4 cv=Vv0Txe2n c=1 sm=1 tr=0 ts=6a3e49d7 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=QrJ9IbtdTVaOtOl6jMIA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-26_02,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606260078
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8784540008
X-Rspam-User: 
X-Stat-Signature: j9g3pj8568goda391ofjoy8k7ypykgsf
X-HE-Tag: 1782467032-99505
X-HE-Meta: U2FsdGVkX1+ySkOWYS/wY645QQGhUnK+vGM6ZbN9sEyyIHFRD2OO3LQFyAXwCInqQ6H9lj9gXBic4OFDkqWIFe0ppQ3KQnMGjX7N+OriqsbNHjPgZUm9HaZs6JgbeFeikuGPJhTqGrLRIcselPEcqa81UrbWAiioWvPfX1VBii8CfXASNljKX82H1vh6HNNfqP3SLwKv/iZnUzugMPI3LsG1oCJMmOeiu+0PUBSJovFDvpMn7z2dDNyJvcrVFIWnz7st4XSCYKubRE9Z+yQoFXpIBPKJJTPxyo5FuJEzic8D7586AVB1H9mfWBEBObQCG0MG3uHyGEy2+7bR+aVl7qfl5SyyXvCsBwUIDz50kuhVDAcKMeqt/Ide4C8gpl8ZZppZm9RFzONINcwS3UQByVMSVAzaLD5oRKi+15YxhcMfJzf/azHpUeuSInIqJCCQFIT3tf1owGvGNJdYBK362SnELA5FSm0YxlEj+oo64hSWk0k2t3NlqwcvJOgIgnpRyRiLaNrR4+pJ50CijkcBMY3bwru5M5Y/efrwiPCltvsQqO3BI4JJNgTk21Say8HoooNWMcIMD1PUFSDz44eZqXldfXeFpuYl6uP2w9iAbPVALWAq9qD3foBDwsmJ0G4P0i3IJzdHv0MMS++ycu/tbCbG+ZPnDJLEejwNy7g98k0Lg/mc0KYuFQYSKYDNDSGuju0gFrkOkfOfl48wd7RmA9fnffbiJaqkpJCxMfJ1D29dBfc5tsvyQiVRWONmj23sBzRf65Ge2Hzhdeth9Tsg4EN9XV03l9f9+vn37ZNzO9PuYAGlErrDsSWhV0w5Tfxabab66+/8/ackPxZJr7LVto9dyfwanyA4a+ZMcKuwfCW5SIc6dtBZFkbDPsOrRFnQPN5qKgPahWuRMcrW/3VclJYefhO2nuGQ/XMZqAhM7UyhWSZ/593mIl+fKpPELcInk3kZgynbAwUSvr+TLMl
 1kHnWHpj
 BDU72m0sGn/0Y6AogTMr6IhAmUN8S3HH2CYbfn6XGePU3J4XVRe0sORMipIld12Cm3Gj88PMA/juyoB57a0AQcvq9ZxUcqEgOwg9+Z6nMgrFf+3w3qKbX3yYIioosGxGD5iqjoGovsVooIU8bJNUrXdEcZxc3G5IkhKXdAcScIvi+XWrj1YUlGGE+SRoqLBXdPqKc+AxJvq2x2hVruJUXK8LCJ5pM/EfFwrBtrj5kB29RonMKGOS+Qfs6nJaZrgMa19rxjp4f8JvRWWZnbY+f7B9TiCMx0TRz+7CY3xQJrQR7X+GEEBCdvwe00lI4ZnSumHG0FuvHxScKolKmUHcOoyaM7D7+qV/z3cDs989hNf8yJMRKRvMIl+Q64SPDEWd/A5K5nqK7HhlEX7ZlaWjBJKIK2sAU54KZ69Of2z69cSPexk3/4ZuV295tK2zQqQl0F2K0smvClXLjarOAHH2FlKN+CqNyjuJs6MyL+6RJicC5vFemzxndl3DYcdcBw/x/f4qE1p43+npN4OLgo1wKTO9eAtXBhqMG3CeOsnOCvcjeIBn2miVodecgSjODwVZkc5h6UiURN7oMOdcKj8gOSeL3pOB5ECdatyX8O7XBCZ5RsU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/14/2026 4:45 AM, Matthew Wilcox wrote:
> On Sat, Jun 13, 2026 at 10:49:42PM +0530, Pranjal Arya wrote:
>> vmalloc's free/busy/lazy area tracking is one of the last remaining
>> augmented-rb_tree consumers in the core mm allocators. The rest of
>> mm/ has been gradually consolidating range-keyed indexing around
>> maple_tree (notably the per-process VMA tree in mm/mmap.c), and
>> the underlying reason is a structural mismatch between rb_tree and
>> range tracking:
> 
> First, and most importantly, I love this.  The maple tree is undoubtedly
> the right data structure to use for this purpose.
> 
> What I don't understand is why you maintain a separate "free" tree.
> It should not be necessary any more, but maybe you tried removing it
> already and found a performance problem?

Thank you Matthew, that is very encouraging to hear :).  The maple tree's
native range primitives and built in RCU support do make it a much
cleaner fit for vmalloc than the augmented rb tree was.

You are right, and I'm going to remove free tree next patch. Allocation will
use occupied maple tree which will walk the gap space of the
occupied index directly.

The concern that motivated keeping the separate index in the RFC was
lock contention separation. Uladzislau had originally structured things so
that the alloc path could touch the free tree while unrelated readers could
access the occupied tree without blocking each other. Your follow up explanation
of how the maple tree's RCU contract makes a separate free index unnecessary
is the key insight with MT_FLAGS_USE_RCU set on the occupied tree and
call rcu deferred vmap_area free, the same contention reduction is achievable
without maintaining a second index.

BR,
Pranjal

