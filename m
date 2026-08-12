Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CED8C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 149156B0088; Tue, 11 Aug 2026 21:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9F26B008A; Tue, 11 Aug 2026 21:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03E06B0093; Tue, 11 Aug 2026 21:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2D2C6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:51:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23C51802AD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:51:35 +0000 (UTC)
X-FDA: 85090940550.17.552DE2F
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 639C6140007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:51:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=TAortyfM;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="UvSfGu/n";
	spf=pass (imf09.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786499492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pH2EITf4Eq9akr0q9vn46l3hPHYJbGOhQoINte5CyCM=;
	b=FoCovVkmYXj/Vi9Zw82QLBW9lU5iWtepQ1K+p0zs7HEUmS8jUQfnEN/+vo3dC/eMT6I7DV
	rNFAzdehKjO6I/4kq6mNc/kopVRbGVU3eeHprRDTfZV9S783rycS0ADZcXud1dEGlOcuDG
	EV7tdkgqZOe1vAwJzATjvkz/IfqnyWw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=TAortyfM;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="UvSfGu/n";
	spf=pass (imf09.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786499492;
	b=SrGfH+BMJkJYjCoW4doU0ik1UiD7fvfxHk1vcRczwXo9NovnAyVvSK4/TogRCFAG1AQwoH
	q9yvMshO47Gn0PyJTaophNR2JPNnH5r+2k3HrLVR+iSGx3f16ea3HDiZ/3zjOWeIsp9ojX
	+Q5nR0/D4XFmdfwJ1dTgQSKYpLTV9EY=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67BNGh3L1706229
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=pH2EITf4Eq9akr0q9vn46l3h
	PHYJbGOhQoINte5CyCM=; b=TAortyfMV5Iy8dEk1k+Xn/gsMJEXv9ohxSw1UCLA
	tExP1i4/0z2+/X8r1+KGQLk5WCUFbRFIAiMS82+tUf2UZLCZDNhkmBlL3wwo6jRS
	EBY0aENniSxjNLkhvhDEUxcv+407pqdQhQPNG5jc3h3VTLrA+wVv4e+kGqDskpyX
	7t0U2epbdl37TOWdYcYZYj15ZNz0lyG3Qwl89ZZnwSGsGHGuJcvQKBM+EZsHgVSp
	dUH7/6gss5tKp6KlYxnLHlhDRKX7y/UGP2Q0OIbDprTUm4hEjjZrFd/2mBOMRgtd
	TDYuFEAMtA1+i3RUz92eyKoHFqHfIWTq0Kch4qAU/Nj9+Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g08jrhj0u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:51:31 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cacd6d37edso8309195ad.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786499490; x=1787104290; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pH2EITf4Eq9akr0q9vn46l3hPHYJbGOhQoINte5CyCM=;
        b=UvSfGu/nrZPxwaaB0z+9i36pUtpOQovvy5Sycu4iUpLkXt5FEs4X4jnDHJtz4e3rZk
         ge28UqbW72rs7cQtisTg6aigyEv2V/qNE2zbT1U2HDKGCfr2MP0fxmBG4YNu8D5Jpckn
         g2vtTl2Z0JPashgXRDWKYbsHeWGWPvPAnpMWTEnKqGyufNPmWUXDS9lBTkY6HvEQaIsu
         wR/qUT/JQASXz+oQRpT63wsk9gtUKb5JvBhOY4hnbTIrEamf8zLqYc0Mk+vttW6RiAmv
         J3Bcs5VsVbNoDahnDJmAAIYyCZ9mpBNRrxAAruud0g3frKfkkkPTtCDummYxuMG1uMce
         omwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786499490; x=1787104290;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pH2EITf4Eq9akr0q9vn46l3hPHYJbGOhQoINte5CyCM=;
        b=K04CSCrr2RQkYoGekt0PGxicCJCoLKbnSKbvHXOt0x9piFQkm+8F2ocK360/8pJVeP
         tr/hSpkzZ6LClfTXRCO1XiAlnUV2wHfe+XvjltzgNJcAXLBiAs8gs4fdNrrj3BMUmr5R
         Iq02l3ke9JZ6Wo5ZV5m/zqJmKJFOFlPWTh92m9olq3rDd5S84zp8P770RUuX7yVAg8Cw
         K6G+Z0D66tbKgbBUFYh1O0X8jZ6f8cNfEJWIIHHaUmxEnt4iGEMSbhYeHdPzX16POC8/
         dCvIyYc6ku0rD/sQA4gZDfiGPI/Q1jTTmxC9zTl6p6E2VTCfut3xKvWNu6869wdXhisL
         WIWA==
X-Forwarded-Encrypted: i=1; AHgh+RqCRO6994szH3fk2iZv6/oGS33ZMs/1K2nmFOrEUkostWN+hqXA+T6Wh6djK78BC+aiK9Us2tdynA==@kvack.org
X-Gm-Message-State: AOJu0YyTw6On3A/0ANugCJq3EpuN/RMCOuKKHoOw/sPfOA/m+BWoa3Mi
	nOp1ktmtLJeWdnEry6Emv2LIRk/V7ClSdacHmRjXQnqGIrfPmkp1MuynbLh/16AJp769Om63iEH
	nDhwRtqW+HCC2Gfw8s4JTHpLKPS/rDtLhMMnLBKt/GNVaGuXxk6tdYQ==
X-Gm-Gg: AR+sD11YTL7zuP7MfrpzaJGkwidy4LzZo4kXNCBzZ7CG3zorEsRjCwmiIUqCBL/opxs
	y5dTjkr74ZVKuACHDQSgbGbPrCvazBxScWldLE+kK2RIVhWiJmULjTHuYXbXHUICM53XkjDkuJY
	hH+24WtxM+QcwSW27fwrhWsrwvrKzuS7pqBonpwRYRp5lV/Rg+I6GkVEs2zTEMqZPKzdcK3gzK0
	wsCbG44GChP4N6oZqKYQwGZmzZASnolBRNdNFk0IPjJBFZEYoDoVBqUAGtftygaDLF8DJkbHNKF
	zF1R5Po6JnyWaxOYpwUd7id/8xfY1zFHm+M8SQ1Iz4DOSuSiTVDGdzQFd/T727dACqwEi51wY9c
	vBXvwbgHEDsHOWdUUWrsXsfXyM6PVvh5GiIjPBQTD9g8PcvZ4wg==
X-Received: by 2002:a05:6a20:2445:b0:3bf:6fb1:ce0d with SMTP id adf61e73a8af0-3cc3f73428fmr1392385637.21.1786499490435;
        Tue, 11 Aug 2026 18:51:30 -0700 (PDT)
X-Received: by 2002:a05:6a20:2445:b0:3bf:6fb1:ce0d with SMTP id adf61e73a8af0-3cc3f73428fmr1392349637.21.1786499490016;
        Tue, 11 Aug 2026 18:51:30 -0700 (PDT)
Received: from hu-ashoraj-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf6d7a366sm4645303eec.27.2026.08.11.18.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 18:51:29 -0700 (PDT)
Date: Tue, 11 Aug 2026 18:51:27 -0700
From: Ashok Raj <ashok.raj@oss.qualcomm.com>
To: shijujose2008@gmail.com
Cc: rafael@kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        rppt@kernel.org, dferguson@amperecomputing.com,
        linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, tony.luck@intel.com,
        lenb@kernel.org, Yazen.Ghannam@amd.com, mchehab@kernel.org,
        jic23@kernel.org, linuxarm@huawei.com, rientjes@google.com,
        jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
        naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
        somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
        duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
        wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
        prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
        kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
        Ashok Raj <ashok.raj@oss.qualcomm.com>
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <anvRn4g9Ihn5eyVq@hu-ashoraj-lv.qualcomm.com>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260726212812.89266-2-shijujose2008@gmail.com>
X-Proofpoint-GUID: DXt_Rv55QScftfiPSyfgiVVjdrVWPCU6
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDAxMSBTYWx0ZWRfXwXj7sk1fgrC2
 689HW4lX+jS78mdBN1kVhDhzbJIckfrX/rvHwc/uirBdmawmmpdhSE54NNuDAtbkrIUmih8rjf3
 NYjYfSJKmGTVqdNj48yUKdVdzqhW2Mg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDAxMSBTYWx0ZWRfX4B4x+shOtCyB
 kIJqdeiKO1Q2msEU4ewQylMerM6zu05AYkREKT8fhV0kURhwDpoinKBgX+IDbQNadfYir9Ak4qZ
 IiiMwa6/uP9sIKp6QQw+j4soz2NZQCTZbuYxypm7A6j6ZwV8Sgju5gItdqTG5CHQCYbHLPwA6Pu
 qrsUyuqDi06Otq16OM76t+W5BiL5893tayYu+bu2Z8iWhUgqN9hJj1JPbxr0J3rAsdmuH0dY3bZ
 JxCEq91flOUcky+gR4210+vNr1+rGswWdiPZCMw/egtywzfH7ueXXi8OMxLFHbjc/p5n0wzMSmj
 b7z3VNIxsY1lN3PehJcVsBsEm+3RTqj7fVTKuWPFxyq43p9u6neGvPKDySATc0nolRe2P4OW4s+
 L3tDJpBT6OAUizvpOoxxO8JGttvRAASqxu+Dxb6+LWdDiBpibkgipDeWgjpomVyaz6La+FU5cZM
 XvTiWlylqs6Rqydkobg==
X-Authority-Analysis: v=2.4 cv=Z7Dc2nRA c=1 sm=1 tr=0 ts=6a7bd1a3 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=pGLkceISAAAA:8 a=MvuuwTCpAAAA:8 a=VwQbUJbxAAAA:8 a=vzhER2c_AAAA:8
 a=EUspDBNiAAAA:8 a=O74ldG2G9i_vyk3S-34A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-ORIG-GUID: DXt_Rv55QScftfiPSyfgiVVjdrVWPCU6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-11_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608120011
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 639C6140007
X-Stat-Signature: ji11fy6knqpdx7yowwricek4zjc3nkcq
X-Rspam-User: 
X-HE-Tag: 1786499492-26822
X-HE-Meta: U2FsdGVkX195irnFkZdCnUK3p6f8Bbhw4tzPaZWRIO/HWVP0dJeuvywaNSkbxRvCbYsWhM7NYpU+mHoHASZoqHoIgPXg8CHYKlG24pFLnNvjNvvX6TjwxeZQS9nPDKtycqxmDTXUrTj5ZJ8SZ4CDlCAWHTjh6bfy54pYFBL+DWn6iJRVH9R2V+F+g0mSlHVD/DRd8zYOkt9cISo1t1TOV67+3H/kk/EvmC67WivmRSfdHEX0xJz4waFYnb9zMMwSsOvQY4nahfuxdFKgmF2ZdvYaW9hQyTpaocscGdywmDf1bXvhb+4fQ7rQQp4CwAOEPBcgqBGZCPWir7igCLQPL5D34OAhGXWV1CvaVDFXx6hDro7S7UWSMU9San+/mnYH3KqDUr3m26GvIEFOndqWBT42c2w2Qk0u06x+f+WTP2ABU5Sck0leXVqyAlovj+5To91ufwvY0yEx3qkLlnIRRW+Ed0kf7LWm2S0p/iS6Wzu2qGUBZPoxRLruoeRX/0WUY/TmzfBthhHnZn8bxq3N5j3PYdyG0s2MIFKRRbkdWD2UCz3fAFQN6KdRkPiNh3dyWhKoRQEZ/SOQpZriwkczcp4++4ePrvbv0F8vB6qnHpnCOwlWMjOVqXgb/G5PXjj56224PYAf9vW8ogjkKhqNTonkJTPhxH6jHMuPdZH2BLPMXdls1Ayd+2pT5MC/I0WGlNBa/8BgD6XPJRfnKSYvnA5CNmkWITsrOXsKUL8DQD9HLeHOzMm8ZdTrBOYaNdfyvUs4E/KFUZdaQBChBp9r5bxDbRo1JIsMa2Nh1frDvdlciUKGaFpGn9dKkyoBdyQlwyCRCUthNCDW/5IsnHSf78CoPjP/hIfpIkXteahukzKPrDgmFlfGns/ojLBybZ5a9JbFhkmBaW/f7ozpdQjBtGRd0qAEzF3tBoekchHX7BRNBoWOKjTgSUInAsgz3mA3maMb4UA1sEe7i1cSSvm
 AfkEpAjR
 sFjNZvlvZxqTgKEL06326m2ysAfYH+pyWRVuxbrQaWxxLMR6JcJzlQa5GvoYujzEmn/oCs/WQYVpCGifTuig0pfnCahkoqfeBE7WE30StKmsNRY9VshIl5rIUdcFqdLLYi23DqS6ROlqecEcOuNiDqC22RT4/1GYAhw0d3+T1lgDchN42APNcplNQMajPCMmC/PsyGN2tECklKBIrT3HdwvxkJlRXjr5WECqp1Lpfj7cNvLv75flM1kWfAJnk4NyDZfsU3ElUTjbPnRrT+3Cz6FsDtvPVLpCM43cmhP480Pfb5NfxeDpBXhG481VMXisCTcEy+uoJvPnY/r5TTjYy2Asp+xc26LTifpx+Iuf5TSI7t4mYmNC4CQrYIqlwFi/FHeef+MGHnQTbJ3h0eZ0pFQdqprjd7kEV2A1Fv9ej7o7hPhhyOJdsKRZOyfee6kUG4jcfy9wT9Fru97dmsxojH2h1h3NKTvz6ejPndilv9DP5//xpmPvKP91v+3bEd1+L/e4hTxvY11KscMJVe2HxrzJe7CudOte2NkLyz9EAhgguLqV4rZhXn3D5C2osQMh+fiKgfn7XzHe0y+Fh7ZFyd6s3v3gwrlPRaJi8ImOCt0jz8K1NWpnJJG8OmxAoyBl1cbe9d+LLNw90Yevqp4P+LKfvEgKjaGkvauc8aVTLbIzxF9g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shiju

On Sun, Jul 26, 2026 at 10:28:11PM +0100, shijujose2008@gmail.com wrote:
> From: Shiju Jose <shijujose2008@gmail.com>
> 
> ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS2).
> Driver adds support for RAS2 feature table, which provides interfaces for
> platform RAS features, e.g., for HW-based memory scrubbing, and logical to
> PA translation service. RAS2 uses PCC channel subspace for communicating
> with the ACPI compliant HW platform.
> 
> Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
> Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
> Co-developed-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
> Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
> Signed-off-by: Shiju Jose <shijujose2008@gmail.com>
> ---
>  drivers/acpi/Kconfig  |  11 +
>  drivers/acpi/Makefile |   1 +
>  drivers/acpi/bus.c    |   3 +
>  drivers/acpi/ras2.c   | 509 ++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/ras2.h   |  57 +++++
>  5 files changed, 581 insertions(+)
>  create mode 100644 drivers/acpi/ras2.c
>  create mode 100644 include/acpi/ras2.h
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig

[snip]

> +int ras2_send_pcc_cmd(struct ras2_mem_ctx *ras2_ctx, u16 cmd)
> +{
> +	struct acpi_ras2_shmem __iomem *gen_comm_base;
> +	struct mbox_chan *pcc_channel;
> +	struct ras2_sspcc *sspcc;
> +	s64 time_delta;
> +	u16 val;
> +	int rc;
> +

[snip]

> +
> +	/* Ring doorbell */
> +	rc = mbox_send_message(pcc_channel, &cmd);
> +	/*
> +	 * mbox_send_message() returns a non-negative integer for successful submission
> +	 * and a negative value on failure.
> +	 */
> +	if (rc < 0) {
> +		dev_warn(ras2_ctx->dev,
> +			 "Error sending PCC mbox message command: 0x%x, rc:%d\n", cmd, rc);
> +		/* Restore CMD COMPLETE bit on error */
> +		val = ioread16(&gen_comm_base->status);
> +		val |= PCC_STATUS_CMD_COMPLETE;
> +		iowrite16(val, &gen_comm_base->status);
> +		return rc;
> +	} else {
> +		rc = 0;
> +	}

Minor: 

Sorry, I missed in prior review.

Can the else after return be removed?
just set rc = 0 should be sufficient.

Cheers,
Ashok

