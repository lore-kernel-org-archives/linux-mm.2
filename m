Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2356ACA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 04:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FEE66B008A; Sat, 10 Oct 2026 00:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFB46B008C; Sat, 10 Oct 2026 00:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877356B0095; Sat, 10 Oct 2026 00:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5543F6B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:55:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5256DA07A3
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:55:44 +0000 (UTC)
X-FDA: 85305503808.18.87F34ED
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7B16F1C0004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:55:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=fwNAbH0+;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=PefVCi64;
	spf=pass (imf18.hostedemail.com: domain of sathvika.vasireddy@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=sathvika.vasireddy@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791608141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/UjQnyjyd81ORZZRpetEWXHeERkdJ5t41qwsd4wMLc=;
	b=uoKBcGkpzKpN/1NVyQiFT+NEyuDJDvmk7G5Vk2Yd9ws1C93DJcJG1r5RYTR6eSWJQ5qeno
	cUwUydgLbcYcwVs3gdYZPAArgUiZrnP/6UY13h0rk026nmSVnL5vqaYSL/beleNd7NQ38a
	/wLFYVht1z+vwVbS7zqVp7HqoM1aEck=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=fwNAbH0+;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=PefVCi64;
	spf=pass (imf18.hostedemail.com: domain of sathvika.vasireddy@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=sathvika.vasireddy@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791608141;
	b=6hbtd/+cEvbrzl4GOfZPFZN56uoXxgnz4PH8VUpx2boxJd/4xOR/pHWwxQkFYUW9ASF3rc
	f0L5IminZRt9ewsM2hVV9lca9EM14Z/ndldA8B4UAeGZI6WTUihzLRp47YeC6Fhi1VEnVz
	aoh0VkL4Zgk4tdASRIJyLUq3Fq0YTk0=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69A3jkZE2721944
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	v/UjQnyjyd81ORZZRpetEWXHeERkdJ5t41qwsd4wMLc=; b=fwNAbH0+OW7rJGeO
	gPTIdNVy2tOVhClZ5DhRO0MxBdVd9m3IUDLFi/3ZBWjmH+V7jv52dafSPUc9H4mc
	xznSRxSWA47u7+4stE2LV7QwQifhjnWK6Tpu4m2lBBoRKuYsDXDcGLFqnSC8MpCK
	vW4zbOmyy1zxsqELCdGg+QMtM3c0UCR9qPA4klKA10STAlbMk98TnP2HPnGOILxg
	UN7fhvqCFLgbeRr/PBnzb8ZFN1+EzI+Sm1LLOeago7c/0HZjWsxwfMTe0KGNDJ12
	rrXZJvhblIQugpOe26yGCUVu9HyhE/6SmEVeqJVxbbMKLpX25ovqY/OPFBb0B5wk
	RWUSkw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7dr7g4jq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:55:39 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-34edae32c04so48054eec.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 21:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791608138; x=1792212938; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v/UjQnyjyd81ORZZRpetEWXHeERkdJ5t41qwsd4wMLc=;
        b=PefVCi648QwKuMu+whmXHVHmpoY6XbWe3cyjIfIAVmfKr3CG7ODovFUJfZX8lbg92I
         Exa4xFuBFZRH9hOkLv05Y53KVo1KQ9tx7foLjRRF5Hq6UJ5+I47SoGXLMEi0EGYsyjyD
         ytU1Yy7Gam/3+Cqt8/tAC+8z9/gRA2zKg/nyZ9hDqLrw/UcKoyAvGxFLTz97/5cPZFQG
         4h8N4Qn8ge3CHfbXnoxMmB3vYM2a3mfuahpUkv/4CpVpD32Pp4H9alip+k+amuvF0X/Q
         gJoCuoyhnfJepBQmLla21Zpgwx2ADArYpPoY7HfMqF9rNm6YVmwJXvXlKt1MQAwdT19G
         PEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791608138; x=1792212938;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v/UjQnyjyd81ORZZRpetEWXHeERkdJ5t41qwsd4wMLc=;
        b=PYiHDMKlRnQxW4TONnQnejAC0DrcFj0KyMi0WVx3tmgQPNJwtmE6DfMNJlEBmUk96U
         Cn6/y8Q7t2f8qm4JVvL4+rYCNk77aIUkoMxm6FsRGbjDPTmAQtbIHFQmF0hXJ5QXgdvg
         /5xIF05qcHdNw1rKzzRFyKJRebb8Bge6GzXJHTJXvMLVNXiPvqBm+OzmBXxHMiq5MG3k
         AFtzjLZNRgT2h4xi7C5U2yS2Edqz2k4i6X0iEFGa+OVQD2BG9KrqlSZR46M8OdqkUwP2
         p1bPY7hYK9wag2TdezkBFvJxA2XQv5ICuL79wsrIDcnYwlHgeJqCN1PospyxyiqY2RA7
         M2DA==
X-Forwarded-Encrypted: i=1; AKwUvBwEx4DLwDiCGxVixL4eHYUwKnk8nHfVLOniaUxB1hvQ+o43PvtuyU/exHrh7tlKtoAGf77+cGOVyQ==@kvack.org
X-Gm-Message-State: AFq9FYK6re/x5LUqlZq5dMH5M+fC+BQAv82PHekKMOlE9Fq8UhRW4Lix
	z4ncp6SIERIH2ef9xTWc32u0vx3FMXO6D9gr+wBFuB21TlPDyiSj9YmYtNrOdmrNgqItfrIwlGb
	kFRl/GiE1sk7VFVEn/VPHr0g2HXVohKWOBle68/fgmj+HwUQzQazVsQ==
X-Gm-Gg: AYBFou2uA0tLUOmnDCiuaGktX12aSIP8INmELUvm7/fdRTcEKc/OG6rsEYiJMjUTIpf
	3u4JiwjAgMa28Nb8Dz2X2vMaejexX+xoMBjEA2nL19KgaBcKs6S5QAhO2h4GTaP2eiBEsUv0mAg
	I++GaIhTmXbHlkpJuFczVwoUAIOCvXqt39zVoXtzKNArG4ZkieV9HOEu4HTBeeLpkdCVmvsm58Y
	TO3Rhm0uuN1kQP2Olmyut4x7Y2ZDPsDCICBqEtf2o3hJwZ9AJNzEJO4g1M1QLm5wczIPaFqXR0W
	19vOvq20X6DPl3OaTEVbib9W+Ns48I2E2IyGyLqt4iwZlkM4fmpVn4qLc/wlM/CWgCir0yPMcMQ
	/GIHsChf2Gs4uba9YP0punuwtH5SeyzlYq3x/3Ro=
X-Received: by 2002:a05:7301:4547:b0:34c:f181:85e4 with SMTP id 5a478bee46e88-3537dfe9152mr8045032eec.1.1791608137786;
        Fri, 09 Oct 2026 21:55:37 -0700 (PDT)
X-Received: by 2002:a05:7301:4547:b0:34c:f181:85e4 with SMTP id 5a478bee46e88-3537dfe9152mr8044958eec.1.1791608137041;
        Fri, 09 Oct 2026 21:55:37 -0700 (PDT)
Received: from [192.168.0.105] ([49.205.200.128])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cab786fsm12376913eec.19.2026.10.09.21.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 21:55:36 -0700 (PDT)
Message-ID: <47c79d45-3545-4f06-b26d-000d8f3e9a4a@oss.qualcomm.com>
Date: Sat, 10 Oct 2026 10:25:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
To: Borislav Petkov <bp@alien8.de>, Shiju Jose <shijujose2008@gmail.com>,
        Ashok Raj <ashok.raj@oss.qualcomm.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
        dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
        Yazen.Ghannam@amd.com, mchehab@kernel.org, jic23@kernel.org,
        linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com,
        Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
        naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
        somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
        duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
        wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
        prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
        kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
        ashoraj@qti.qualcomm.com, sathvika.vasireddy@oss.qualcomm.com
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com>
 <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
 <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com>
 <20261008030603.GAascImzt4cv8Gz49p@fat_crate.local>
 <CAG4KcRLhN9=6xeT4qfqKLFdukiZLUc7akGcWwXJUU1-qrfxTUQ@mail.gmail.com>
 <20261008174114.GAasfVutvsmAk8JGsD@fat_crate.local>
 <CAG4KcRLx69BK+aw+exUzPe+BW8exFM2LLvN9pEr-+1BoGVhFXg@mail.gmail.com>
 <20261010002159.GCasmFJy2F_2S22d4Y@fat_crate.local>
Content-Language: en-US
From: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>
In-Reply-To: <20261010002159.GCasmFJy2F_2S22d4Y@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: PCFmFZpAr5wrAdl9Zl5kxdvq6ea_Ulqc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEwMDAxOSBTYWx0ZWRfX2qEnh57+AEX0
 7QeJoou1NYXVvJxfU4NrYrn2H7fap/zAJs7M8hVsEYqLmvQ0ooGD/ObmiiAUjcize7uCgvz1giC
 8jwA10dUvF4H7fz6m2zGCK2JnLA5Gn0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEwMDAxOSBTYWx0ZWRfX6/vwTNrS0mFJ
 jwulyNdD8CroN05kO4K9OLOHekVN7BEm5ylxw1UwG4uR8ZXlsWbkdbSWI9/FsQ7DAKcat3mx05M
 J9ruCrEiONkfaHgSH56HQ74h5TMW7V3qaweYIQZMDQdRH4FLPja4gDHxw2dewhmX5J7j0uJHyL3
 khub9ty+vySU2EkNK78Ld0uWWHxQCLFbGsfETkqSC5PucOlG0I5ESug4bXr8EC1qSXH9V8qy4GN
 r3XI1cg30PKfah+G9lF1fdh3eC12FK6KMBipALkVIPuEJofzt9wWVKVaqBDumjxOtFv1TwLUYRC
 15CZx2MF8armIKHaq+DsLs2wNYQy1/EcKl6OHGqCFijsScxGsnWhYiGTKba2SwZT3+RPTLnq7bO
 50v8YqPpdZUzokLjcTonEhyrAC6zB+WQiM+bwbqYji1oa7oaXqisI2Ah6KgTW1py8GR7llQtqxr
 JieciURzYa/L7wrWzmA==
X-Proofpoint-GUID: PCFmFZpAr5wrAdl9Zl5kxdvq6ea_Ulqc
X-Authority-Analysis: v=2.4 cv=asknmiZV c=1 sm=1 tr=0 ts=6ac9c54b cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=VHfOeJtQ9mIUWOi2dKYFuw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=MvuuwTCpAAAA:8 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vzhER2c_AAAA:8 a=y63C90UD-jFUcmNyfHwA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=FO4_E8m0qiDe52t0p3_H:22 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-10_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610100019
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7B16F1C0004
X-Stat-Signature: pffixdauw3d99huy4mije5p6uixofn7o
X-HE-Tag: 1791608141-541360
X-HE-Meta: U2FsdGVkX1/kBoOwAHnNexa239zM7q9go/6B+yLYzwE3S2dAXGLPuPdzWYFgNe5tdmX7szvBv8q0ZSktGZpQA40QJ+6PjMNyEn55Pia48ASUUxiU+CvHtS30CRm4I4VlB55TsFqbgw6IxATWlAVmlHOosNRwXiZUNffL7vNHTATQBRj/+8gUZPp7i3QENBAAUpMRCB4QgqYwmF3ac2zfFAqv1sx1lIRSw/kcQ3r8rbVcdL2LrkzP1+0+wdvMjC7mc9tbui2V+Y0JXH2HTxVeHUA7+HaM2aYQZ3h1H7ua2s3QqBCUe8VUx4IgAYdkYqWhY1G+bjlAIgfzIE0spyTyrF/bM/1t2vI6YTYPGoO/AMndYN5RnZ8mXpHVbTiQ7fruFEI9MALAUVGSZzedWZMpvX1tJqZ3eqVw/oZbiMcNn40wLla3M8fVPoInMXDRK6KoFEYPLhbivMMhlDKwlBlPBTKATH663pNIAu2bXeAwTcOMOzPy2W1E8l2y9T063lcB10hw+uyShuI92TfQoeBn9+hILtUR23RnH7uCZYvvfa/YP81mD8nHYjzhKvPU6atcixs0DRsiK8U5KCKegznE5N4HF4vlxPMYsQRXRFQwK6/jemSVuifPNZRiehwXeNz1DzzyLX4frE/RQ2uRSQGMohkK0PTYUEL0O5FT5/9baxFw+6at2AyLscn5/p9z4mWLoLrDHS+r4+fglNS3hb1lZipViC2dOFS9HvQmRSRsYCPw7R7Oi/+AcxeceBzmJsQMUB62uUDxMy/fnYngfM0O6U55LlKICcSXzYTnX+73tlTjh6gpfkR33yDZJv1eAiYLm5fCyFChRNGraapVFMkJfTYxUfc6ctDQ8QwJzRLXhRG87isxUAxburmAweYCRtlVLl+AoLP3PtC1DYLlV/US0egvhAd2xjPSc9K/NQff/sqVR3y8UbsEeSpK5O1AbBguGRgdNyCgRFzOdxp4zj5
 o55V+/5s
 gOddnvik9sZn7rCMdtsG41BWblFzSUaC82YtpLJCJxf8KKwIm/FSODaCqSFZxZli/3Z/9E1jSWUFfgnMT1Q6J3CQt+2kUhMxCAh3n3Rm45nQPc/cQn4StCYBqLGvyHMfZSZDFUahTteBu5seWl2aBTeGGOxL9NJ+EnpIJk1Vo8tdERXgWcXEDuaF+gDCAwkxhJnX0K1V6TaLqs48MrogrcjcxPNvdLqqLwc1UhvhtB6mCZ779Qy8f7Pw8B9BqdeVNnKIfpiby/J/zUagTB/OWOrRY0ADoIIBSyXYmf8gktp9XtbON2nSCeDZuN6e4UhZkYSVMYcxe1eH13O4wCD9gWJr5wXSEG0fvGpoXz6H6MO8gEpL1PwEKhKBwoFjClV+Quac3LT8J8WNYH15dTkG493Nuvbg0CzecR68pXTifHrJwss9KBnkAlMuvPHUOZiUPqNEdPBv/faP1ZstAZoRd/oyDG6/4dHBO3jAH+ixvXZSemeOz83RrCzC5JC3kwn9wCnpUbp2ybulmxZZV4r0ADl3IecNkZR5s9Lhsn2KWeIVBiw93bYkfK+VquFXFlrhaa0+fIJ41nXZOYT4Z/R3wAqa+OJcWBpA03Cbxd7bjUZDgNliCphRgLdulTe2aIdkQLnlW2V6wzSS3DmjIeXtWSqD4WGhwvKth6oX9BkRZGf6o/NzQoLLXcWvxHmSVTo9+En1gRjIGNWVcOHwaHF7DOX8T3dhXKr14tJcY1ca8CQ43BXw2v7lMi2Zxlo/eIdaYTNnO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

On 10-10-2026 05:51, Borislav Petkov wrote:
> On Thu, Oct 08, 2026 at 07:50:07PM +0100, Shiju Jose wrote:
>> Sorry. I meant the issue occurred when setting the PCC signalling mode
>> as polling for the RAS2 PCC
>> (In include/acpi/actbl2.h struct acpi_table_pcct: flags).
> 
> Ok, did this:
> 
> diff --git a/drivers/acpi/ras2.c b/drivers/acpi/ras2.c
> index 24514e2b99e9..c214e40355f4 100644
> --- a/drivers/acpi/ras2.c
> +++ b/drivers/acpi/ras2.c
> @@ -304,6 +304,13 @@ static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
>   	if (!sspcc)
>   		return -ENOMEM;
>   
> +	/*
> +	 * Make sure the binding to the mailbox channel switches to explicit
> +	 * ACKs so that ras2_send_pcc_cmd() can issue the ACK packet with
> +	 * mbox_client_txdone().
> +	 */
> +	sspcc->mbox_client.knows_txdone	= true;
> +
>   	pcc_chan = pcc_mbox_request_channel(&sspcc->mbox_client, pcc_id);
>   	if (IS_ERR(pcc_chan)) {
>   		ret = PTR_ERR(pcc_chan);
> @@ -327,8 +334,6 @@ static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
>   	sspcc->pcc_mrtt		= pcc_chan->min_turnaround_time;
>   	sspcc->pcc_mpar		= pcc_chan->max_access_rate;
>   
> -	sspcc->mbox_client.knows_txdone	= true;
> -
>   	mutex_init(&sspcc->pcc_lock);
>   	kref_init(&sspcc->kref);
>   
> ---
> 
> Here's the new version, pls run it:
> 
>  From fb7d2f51280072c266441b645c81258553f1c968 Mon Sep 17 00:00:00 2001
> From: Shiju Jose <shijujose2008@gmail.com>
> Date: Sun, 26 Jul 2026 22:28:11 +0100
> Subject: [PATCH] ACPI:RAS2: Add a driver for the ACPI RAS2 feature table
> 
> The ACPI 6.5 Specification, section 5.2.21, defines a RAS2 feature table
> (RAS2). Add a driver supporting that RAS2 feature table and which provides
> interfaces for platform RAS features, e.g., for HW-based memory scrubbing, and
> logical to PA translation service. RAS2 uses PCC channel subspace for
> communicating with the ACPI compliant HW platform.
> 
>    [ bp:
>     - Massage commit message
>     - in ras2_send_pcc_cmd():
>      - check check_pcc_chan() retval
>      - remove else assignment to rc = 0 after mbox_send_message() call
>     - Do proper error unwinding in register_pcc_channel()
>     - Do proper error unwinding for auxiliary_device_init() in
>       add_aux_device()
>     - Cleanup parse_ras2_table() some
>     - drop ras2_ prefix from all static functions
>     - unbreak long lines
>     - minor touchups ]
> 
>     [ Ashok: move sspcc->mbox_client.knows_txdone setting before
>       pcc_mbox_request_channel() runs. ]
> 
> Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
> Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
> Co-developed-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Shiju Jose <shijujose2008@gmail.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
> Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
> Link: https://patch.msgid.link/20260726212812.89266-2-shijujose2008@gmail.com
> ---
>   drivers/acpi/Kconfig  |  10 +
>   drivers/acpi/Makefile |   1 +
>   drivers/acpi/bus.c    |   3 +
>   drivers/acpi/ras2.c   | 522 ++++++++++++++++++++++++++++++++++++++++++
>   include/acpi/ras2.h   |  57 +++++
>   5 files changed, 593 insertions(+)
>   create mode 100644 drivers/acpi/ras2.c
>   create mode 100644 include/acpi/ras2.h
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index f165d14cf61a..4be96f42d97c 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -294,6 +294,16 @@ config ACPI_CPPC_LIB
>   	  If your platform does not support CPPC in firmware,
>   	  leave this option disabled.
>   
> +config ACPI_RAS2
> +	bool "ACPI RAS2 driver"
> +	select AUXILIARY_BUS
> +	depends on MAILBOX && PCC
> +	help
> +	  Add support for the RAS2 feature table and provide interfaces for
> +	  platform RAS features, such as hardware-based memory scrubbing.
> +
> +	  If unsure, select N.
> +
>   config ACPI_PROCESSOR
>   	tristate "Processor"
>   	depends on X86 || ARM64 || LOONGARCH || RISCV
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index d1b0affb844f..abfec6745724 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -105,6 +105,7 @@ obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
>   obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
>   obj-$(CONFIG_ACPI_CPPC_LIB)	+= cppc_acpi.o
>   obj-$(CONFIG_ACPI_SPCR_TABLE)	+= spcr.o
> +obj-$(CONFIG_ACPI_RAS2)		+= ras2.o
>   obj-$(CONFIG_ACPI_DEBUGGER_USER) += acpi_dbg.o
>   obj-$(CONFIG_ACPI_PPTT) 	+= pptt.o
>   obj-$(CONFIG_ACPI_PFRUT)	+= pfr_update.o pfr_telemetry.o
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 808c6746be14..2589f46c59f7 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -31,6 +31,7 @@
>   #include <acpi/apei.h>
>   #include <linux/suspend.h>
>   #include <linux/prmt.h>
> +#include <acpi/ras2.h>
>   
>   #include "internal.h"
>   
> @@ -1504,6 +1505,8 @@ static int __init acpi_init(void)
>   	acpi_debugger_init();
>   	acpi_setup_sb_notify_handler();
>   	acpi_viot_init();
> +	acpi_ras2_init();
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/acpi/ras2.c b/drivers/acpi/ras2.c
> new file mode 100644
> index 000000000000..c214e40355f4
> --- /dev/null
> +++ b/drivers/acpi/ras2.c
> @@ -0,0 +1,522 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * ACPI RAS2 feature table driver.
> + *
> + * Copyright (c) 2024-2026 HiSilicon Limited.
> + *
> + * Support for RAS2 table - ACPI 6.5 Specification, section 5.2.21, which
> + * provides interfaces for platform RAS features, e.g., for HW-based memory
> + * scrubbing, and logical to physical address translation service. RAS2 uses
> + * PCC channel subspace for communicating with the ACPI compliant HW platform.
> + */
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) "ACPI RAS2: " fmt
> +
> +#include <linux/delay.h>
> +#include <linux/export.h>
> +#include <linux/iopoll.h>
> +#include <linux/ktime.h>
> +#include <acpi/pcc.h>
> +#include <acpi/ras2.h>
> +
> +/**
> + * struct ras2_sspcc - Data structure for PCC communication
> + * @mbox_client:	struct mbox_client object
> + * @pcc_chan:		Pointer to struct pcc_mbox_chan
> + * @comm_addr:		Pointer to RAS2 PCC shared memory region
> + * @elem:		List for registered RAS2 PCC channel subspaces
> + * @pcc_lock:		PCC lock to provide mutually exclusive access
> + *			to PCC channel subspace
> + * @deadline_us:	Poll PCC status register timeout in microsecs
> + *			for PCC command completion
> + * @pcc_mpar:		Maximum Periodic Access Rate (MPAR) for PCC channel
> + * @pcc_mrtt:		Minimum Request Turnaround Time (MRTT) in microsecs
> + *			OS must wait after completion of a PCC command before
> + *			issuing next command
> + * @last_cmd_cmpl_time: Completion time of last PCC command
> + * @last_mpar_reset:	Time of last MPAR count reset
> + * @mpar_count:		MPAR count
> + * @pcc_id:		Identifier of the RAS2 platform communication channel
> + * @last_cmd:		Last PCC command
> + * @kref:		kref object
> + */
> +struct ras2_sspcc {
> +	struct mbox_client		mbox_client;
> +	struct pcc_mbox_chan		*pcc_chan;
> +	struct acpi_ras2_shmem __iomem	*comm_addr;
> +	struct list_head		elem;
> +	struct mutex			pcc_lock;
> +	u64				deadline_us;
> +	unsigned int			pcc_mpar;
> +	unsigned int			pcc_mrtt;
> +	ktime_t				last_cmd_cmpl_time;
> +	ktime_t				last_mpar_reset;
> +	unsigned int			mpar_count;
> +	int				pcc_id;
> +	u16				last_cmd;
> +	struct kref			kref;
> +};
> +
> +/*
> + * Arbitrary retries for PCC commands because the remote processor could be
> + * much slower to reply. Keep it high enough to cover emulators where the
> + * processors run painfully slow.
> + */
> +#define PCC_NUM_RETRIES 600ULL
> +#define PCC_CHNL_DEFAULT_LATENCY 1000
> +#define PCC_MIN_POLL_USECS 3
> +
> +#define RAS2_MAX_NUM_PCC_DESCS 100
> +#define RAS2_FEAT_TYPE_MEMORY 0x00
> +
> +/* RAS2 PCC subspaces list and guard */
> +static DEFINE_MUTEX(sspcc_lst_lock);
> +static LIST_HEAD(sspcc_lst);
> +
> +static int check_pcc_chan(struct ras2_sspcc *sspcc)
> +{
> +	struct acpi_ras2_shmem __iomem *gen_comm_base = sspcc->comm_addr;
> +	u32 cap_status;
> +	u16 status;
> +	int rc;
> +
> +	/*
> +	 * As per ACPI spec, the PCC space will be initialized by the
> +	 * platform and should have set the command completion bit when
> +	 * PCC can be used by OSPM.
> +	 *
> +	 * Poll PCC status register every PCC_MIN_POLL_USECS for maximum of
> +	 * PCC_NUM_RETRIES * PCC channel latency until PCC command complete
> +	 * bit is set.
> +	 */
> +	rc = readw_relaxed_poll_timeout(&gen_comm_base->status, status,
> +					status & PCC_STATUS_CMD_COMPLETE,
> +					PCC_MIN_POLL_USECS, sspcc->deadline_us);
> +	if (rc) {
> +		pr_warn("PCC ID: 0x%x: PCC check channel timeout for last command: 0x%x rc=%d\n",
> +			sspcc->pcc_id, sspcc->last_cmd, rc);
> +
> +		return rc;
> +	}
> +
> +	if (status & PCC_STATUS_ERROR) {
> +		pr_warn("PCC ID: 0x%x: Error in executing last command: 0x%x\n",
> +			sspcc->pcc_id, sspcc->last_cmd);
> +		status &= ~PCC_STATUS_ERROR;
> +		iowrite16(status, &gen_comm_base->status);
> +		iowrite32(0x0, &gen_comm_base->set_caps_status);
> +		return -EIO;
> +	}
> +
> +	/* Ensure PCC status is up-to-date. */
> +	rmb();
> +	cap_status = ioread32(&gen_comm_base->set_caps_status);
> +	switch (cap_status) {
> +	case ACPI_RAS2_NOT_VALID:
> +	case ACPI_RAS2_NOT_SUPPORTED:
> +		rc = -EPERM;
> +		break;
> +	case ACPI_RAS2_BUSY:
> +		rc = -EBUSY;
> +		break;
> +	case ACPI_RAS2_FAILED:
> +	case ACPI_RAS2_ABORTED:
> +	case ACPI_RAS2_INVALID_DATA:
> +		rc = -EINVAL;
> +		break;
> +	default:
> +		rc = 0;
> +	}
> +
> +	iowrite32(0x0, &gen_comm_base->set_caps_status);
> +
> +	return rc;
> +}
> +
> +/**
> + * ras2_send_pcc_cmd() - Send RAS2 command via PCC channel
> + * @ras2_ctx:	pointer to the RAS2 context structure
> + * @cmd:	RAS2 command to send
> + *
> + * Returns: 0 on success, an error otherwise
> + */
> +int ras2_send_pcc_cmd(struct ras2_mem_ctx *ras2_ctx, u16 cmd)
> +{
> +	struct acpi_ras2_shmem __iomem *gen_comm_base;
> +	struct mbox_chan *pcc_channel;
> +	struct ras2_sspcc *sspcc;
> +	s64 time_delta;
> +	u16 val;
> +	int rc;
> +
> +	/* The ACPI 6.5 Specification supports only PCC_CMD_EXEC_RAS2. */
> +	if (!ras2_ctx || cmd != PCC_CMD_EXEC_RAS2) {
> +		pr_warn("%s: Invalid parameters ras2_ctx: %p command: 0x%x\n",
> +			__func__, ras2_ctx, cmd);
> +		return -EINVAL;
> +	}
> +
> +	lockdep_assert_held(ras2_ctx->pcc_lock);
> +	sspcc = ras2_ctx->sspcc;
> +	gen_comm_base = sspcc->comm_addr;
> +
> +	rc = check_pcc_chan(sspcc);
> +	if (rc < 0)
> +		return rc;
> +
> +	pcc_channel = sspcc->pcc_chan->mchan;
> +
> +	/*
> +	 * Handle the Minimum Request Turnaround Time (MRTT): the minimum
> +	 * amount of time that OSPM must wait after the completion of
> +	 * a command before issuing the next command, in microseconds.
> +	 */
> +	if (sspcc->pcc_mrtt) {
> +		time_delta = ktime_us_delta(ktime_get(), sspcc->last_cmd_cmpl_time);
> +		if (sspcc->pcc_mrtt > time_delta)
> +			fsleep(sspcc->pcc_mrtt - time_delta);
> +	}
> +
> +	/*
> +	 * Handle the non-zero Maximum Periodic Access Rate (MPAR): the
> +	 * maximum number of periodic requests that the subspace channel can
> +	 * support, reported in commands per minute. 0 indicates no
> +	 * limitation.
> +	 *
> +	 * This parameter should be ideally zero or large enough so that it
> +	 * can handle maximum number of requests that all the cores in the
> +	 * system can collectively generate. If it is not, follow the spec and
> +	 * just not send the request to the platform after hitting the MPAR
> +	 * limit in any 60s window.
> +	 */
> +	if (sspcc->pcc_mpar) {
> +		if (!sspcc->mpar_count) {
> +			time_delta = ktime_ms_delta(ktime_get(), sspcc->last_mpar_reset);
> +			if ((time_delta < 60 * MSEC_PER_SEC) && sspcc->last_mpar_reset) {
> +				dev_dbg(ras2_ctx->dev,
> +					"PCC command 0x%x not sent due to MPAR limit", cmd);
> +				return -EIO;
> +			}
> +			sspcc->last_mpar_reset = ktime_get();
> +			sspcc->mpar_count = sspcc->pcc_mpar;
> +		}
> +		sspcc->mpar_count--;
> +	}
> +
> +	/* Write to the shared comm region */
> +	iowrite16(cmd, &gen_comm_base->command);
> +
> +	/* Flip CMD COMPLETE bit */
> +	iowrite16(0, &gen_comm_base->status);
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
> +	}
> +
> +	sspcc->last_cmd = cmd;
> +
> +	/* Wait for completion and check for PCC error bit */
> +	rc = check_pcc_chan(sspcc);
> +	if (rc < 0)
> +		return rc;
> +
> +	/*
> +	 * If Minimum Request Turnaround Time is non-zero, need to record the
> +	 * completion time of both READ and WRITE commands for proper handling
> +	 * of MRTT, so need to check for pcc_mrtt.
> +	 */
> +	if (sspcc->pcc_mrtt)
> +		sspcc->last_cmd_cmpl_time = ktime_get();
> +
> +	if (!pcc_channel->mbox->txdone_irq)
> +		mbox_client_txdone(pcc_channel, rc);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(ras2_send_pcc_cmd, "acpi_ras2");
> +
> +static void sspcc_list_release(struct kref *kref)
> +{
> +	struct ras2_sspcc *sspcc = container_of(kref, struct ras2_sspcc, kref);
> +
> +	guard(mutex)(&sspcc_lst_lock);
> +	list_del(&sspcc->elem);
> +	pcc_mbox_free_channel(sspcc->pcc_chan);
> +	kfree(sspcc);
> +}
> +
> +static void sspcc_put(struct ras2_sspcc *sspcc)
> +{
> +	kref_put(&sspcc->kref, &sspcc_list_release);
> +}
> +
> +static struct ras2_sspcc *sspcc_get(int pcc_id)
> +{
> +	struct ras2_sspcc *sspcc;
> +
> +	guard(mutex)(&sspcc_lst_lock);
> +	list_for_each_entry(sspcc, &sspcc_lst, elem) {
> +		if (sspcc->pcc_id != pcc_id)
> +			continue;
> +
> +		if (!kref_get_unless_zero(&sspcc->kref))
> +			break;
> +
> +		return sspcc;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
> +{
> +	struct pcc_mbox_chan *pcc_chan;
> +	struct ras2_sspcc *sspcc;
> +	int ret;
> +
> +	if (pcc_id < 0)
> +		return -EINVAL;
> +
> +	sspcc = sspcc_get(pcc_id);
> +	if (sspcc) {
> +		ras2_ctx->sspcc	    = sspcc;
> +		ras2_ctx->comm_addr = sspcc->comm_addr;
> +		ras2_ctx->dev	    = sspcc->pcc_chan->mchan->mbox->dev;
> +		ras2_ctx->pcc_lock  = &sspcc->pcc_lock;
> +
> +		return 0;
> +	}
> +
> +	sspcc = kzalloc(sizeof(*sspcc), GFP_KERNEL);
> +	if (!sspcc)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Make sure the binding to the mailbox channel switches to explicit
> +	 * ACKs so that ras2_send_pcc_cmd() can issue the ACK packet with
> +	 * mbox_client_txdone().
> +	 */
> +	sspcc->mbox_client.knows_txdone	= true;
> +
> +	pcc_chan = pcc_mbox_request_channel(&sspcc->mbox_client, pcc_id);
> +	if (IS_ERR(pcc_chan)) {
> +		ret = PTR_ERR(pcc_chan);
> +		goto ret_err_mbox;
> +	}
> +
> +	if (!pcc_chan->shmem || pcc_chan->shmem_size < sizeof(struct acpi_ras2_shmem)) {
> +		ret = -EINVAL;
> +		goto ret_err_shmem;
> +	}
> +
> +	sspcc->pcc_id		= pcc_id;
> +	sspcc->pcc_chan		= pcc_chan;
> +	sspcc->comm_addr	= pcc_chan->shmem;
> +
> +	if (pcc_chan->latency)
> +		sspcc->deadline_us = PCC_NUM_RETRIES * pcc_chan->latency;
> +	else
> +		sspcc->deadline_us = PCC_NUM_RETRIES * PCC_CHNL_DEFAULT_LATENCY;
> +
> +	sspcc->pcc_mrtt		= pcc_chan->min_turnaround_time;
> +	sspcc->pcc_mpar		= pcc_chan->max_access_rate;
> +
> +	mutex_init(&sspcc->pcc_lock);
> +	kref_init(&sspcc->kref);
> +
> +	mutex_lock(&sspcc_lst_lock);
> +	list_add(&sspcc->elem, &sspcc_lst);
> +	mutex_unlock(&sspcc_lst_lock);
> +
> +	ras2_ctx->sspcc		= sspcc;
> +	ras2_ctx->comm_addr	= sspcc->comm_addr;
> +	ras2_ctx->dev		= pcc_chan->mchan->mbox->dev;
> +	ras2_ctx->pcc_lock	= &sspcc->pcc_lock;
> +
> +	return 0;
> +
> +ret_err_shmem:
> +	pcc_mbox_free_channel(pcc_chan);
> +
> +ret_err_mbox:
> +	kfree(sspcc);
> +
> +	return ret;
> +}
> +
> +static DEFINE_IDA(ida);
> +static void release(struct device *device)
> +{
> +	struct auxiliary_device *auxdev = to_auxiliary_dev(device);
> +	struct ras2_mem_ctx *ras2_ctx = container_of(auxdev, struct ras2_mem_ctx, adev);
> +
> +	ida_free(&ida, auxdev->id);
> +	sspcc_put(ras2_ctx->sspcc);
> +	kfree(ras2_ctx);
> +}
> +
> +static struct ras2_mem_ctx *add_aux_device(char *name, int channel, u32 pxm_inst)
> +{
> +	struct ras2_mem_ctx *ras2_ctx;
> +	u32 comp_nid;
> +	int id, rc;
> +
> +	comp_nid = pxm_to_node(pxm_inst);
> +	if (comp_nid == NUMA_NO_NODE) {
> +		pr_debug("Invalid NUMA node, channel=%d pxm_inst=%d\n", channel, pxm_inst);
> +		return ERR_PTR(-ENXIO);
> +	}
> +
> +	ras2_ctx = kzalloc(sizeof(*ras2_ctx), GFP_KERNEL);
> +	if (!ras2_ctx)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ras2_ctx->sys_comp_nid = comp_nid;
> +
> +	rc = register_pcc_channel(ras2_ctx, channel);
> +	if (rc < 0) {
> +		pr_debug("Failed to register PCC channel=%d pxm_inst=%d rc=%d\n", channel,
> +			 pxm_inst, rc);
> +		goto ctx_free;
> +	}
> +
> +	id = ida_alloc(&ida, GFP_KERNEL);
> +	if (id < 0) {
> +		rc = id;
> +		goto pcc_free;
> +	}
> +
> +	ras2_ctx->adev.id		= id;
> +	ras2_ctx->adev.name		= name;
> +	ras2_ctx->adev.dev.release	= release;
> +	ras2_ctx->adev.dev.parent	= ras2_ctx->dev;
> +
> +	rc = auxiliary_device_init(&ras2_ctx->adev);
> +	if (rc)
> +		goto ida_free;
> +
> +	rc = auxiliary_device_add(&ras2_ctx->adev);
> +	if (rc)
> +		goto aux_free;
> +
> +	return ras2_ctx;
> +
> +aux_free:
> +	auxiliary_device_uninit(&ras2_ctx->adev);
> +ida_free:
> +	ida_free(&ida, id);
> +pcc_free:
> +	sspcc_put(ras2_ctx->sspcc);
> +ctx_free:
> +	kfree(ras2_ctx);
> +
> +	return ERR_PTR(rc);
> +}
> +
> +static void remove_aux_device(struct ras2_mem_ctx *ras2_ctx)
> +{
> +	if (!ras2_ctx)
> +		return;
> +
> +	auxiliary_device_delete(&ras2_ctx->adev);
> +	auxiliary_device_uninit(&ras2_ctx->adev);
> +}
> +
> +static int parse_ras2_table(struct acpi_table_ras2 *ras2_tab)
> +{
> +	const size_t ras2_tbl_sz = sizeof(struct acpi_table_ras2);
> +	struct acpi_ras2_pcc_desc *pcc_desc_list;
> +	struct ras2_mem_ctx **pctx_list;
> +	struct ras2_mem_ctx *ras2_ctx;
> +	u16 tot_tbl_len;
> +	u16 i;
> +
> +	if (ras2_tab->header.length < ras2_tbl_sz) {
> +		pr_warn(FW_WARN "ACPI RAS2 table present but broken (too short, size=%u)\n",
> +			ras2_tab->header.length);
> +		return -EINVAL;
> +	}
> +
> +	if (!ras2_tab->num_pcc_descs || ras2_tab->num_pcc_descs > RAS2_MAX_NUM_PCC_DESCS) {
> +		pr_warn(FW_WARN "No/Invalid number of PCC descs(%d) in ACPI RAS2 table\n",
> +			ras2_tab->num_pcc_descs);
> +		return -EINVAL;
> +	}
> +
> +	tot_tbl_len = ras2_tbl_sz + ras2_tab->num_pcc_descs * sizeof(*pcc_desc_list);
> +	if (ras2_tab->header.length < tot_tbl_len) {
> +		pr_warn(FW_WARN "RAS2 table is not large enough to contain PCC descs=%d size=%u)\n",
> +			ras2_tab->num_pcc_descs, ras2_tab->header.length);
> +		return -EINVAL;
> +	}
> +
> +	pctx_list = kcalloc(ras2_tab->num_pcc_descs, sizeof(*pctx_list), GFP_KERNEL);
> +	if (!pctx_list)
> +		return -ENOMEM;
> +
> +	pcc_desc_list = (struct acpi_ras2_pcc_desc *)(ras2_tab + 1);
> +	for (i = 0; i < ras2_tab->num_pcc_descs; i++, pcc_desc_list++) {
> +		if (pcc_desc_list->feature_type != RAS2_FEAT_TYPE_MEMORY)
> +			continue;
> +
> +		ras2_ctx = add_aux_device(RAS2_MEM_DEV_ID_NAME, pcc_desc_list->channel_id,
> +					  pcc_desc_list->instance);
> +		/* Invalid NUMA node, continue parsing next node */
> +		if (PTR_ERR(ras2_ctx) == -ENXIO)
> +			continue;
> +
> +		if (IS_ERR(ras2_ctx)) {
> +			pr_warn("Failed to add RAS2 auxiliary device rc=%ld\n", PTR_ERR(ras2_ctx));
> +			for (; i > 0; i--) {
> +				if (pctx_list[i - 1])
> +					remove_aux_device(pctx_list[i - 1]);
> +			}
> +			kfree(pctx_list);
> +			return PTR_ERR(ras2_ctx);
> +		}
> +		pctx_list[i] = ras2_ctx;
> +	}
> +	kfree(pctx_list);
> +
> +	return 0;
> +}
> +
> +/**
> + * acpi_ras2_init - RAS2 driver initialization function.
> + *
> + * Extracts the ACPI RAS2 table and retrieves ID for the PCC channel subspace
> + * for communicating with the ACPI compliant HW platform. Driver adds an
> + * auxiliary device, which binds to the memory ACPI RAS2 driver, for each RAS2
> + * memory feature.
> + *
> + * Returns: none.
> + */
> +void __init acpi_ras2_init(void)
> +{
> +	struct acpi_table_ras2 *ras2_tab;
> +	acpi_status status;
> +
> +	status = acpi_get_table(ACPI_SIG_RAS2, 0, (struct acpi_table_header **)&ras2_tab);
> +	if (ACPI_FAILURE(status)) {
> +		pr_debug("Failed to get table, %s\n", acpi_format_exception(status));
> +		return;
> +	}
> +
> +	if (parse_ras2_table(ras2_tab))
> +		pr_debug("Failed to parse RAS2 table\n");
> +
> +	acpi_put_table((struct acpi_table_header *)ras2_tab);
> +}
> diff --git a/include/acpi/ras2.h b/include/acpi/ras2.h
> new file mode 100644
> index 000000000000..f4574e8e0a12
> --- /dev/null
> +++ b/include/acpi/ras2.h
> @@ -0,0 +1,57 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * ACPI RAS2 (RAS Feature Table) methods.
> + *
> + * Copyright (c) 2024-2026 HiSilicon Limited
> + */
> +
> +#ifndef _ACPI_RAS2_H
> +#define _ACPI_RAS2_H
> +
> +#include <linux/acpi.h>
> +#include <linux/auxiliary_bus.h>
> +#include <linux/mailbox_client.h>
> +#include <linux/mutex.h>
> +#include <linux/types.h>
> +
> +struct device;
> +
> +/*
> + * ACPI spec 6.5 Table 5.82: PCC command codes used by
> + * RAS2 platform communication channel.
> + */
> +#define PCC_CMD_EXEC_RAS2 0x01
> +
> +#define RAS2_AUX_DEV_NAME "ras2"
> +#define RAS2_MEM_DEV_ID_NAME "acpi_ras2_mem"
> +
> +/**
> + * struct ras2_mem_ctx - Context for RAS2 memory features
> + * @adev:		Auxiliary device object
> + * @comm_addr:		Pointer to RAS2 PCC shared memory region
> + * @dev:		Pointer to device backing struct mbox_controller for PCC
> + * @sspcc:		Pointer to local data structure for PCC communication
> + * @pcc_lock:		Pointer to PCC lock to provide mutually exclusive access
> + *			to PCC channel subspace
> + * @sys_comp_nid:	Node ID of the system component that the RAS feature
> + *			is associated with. See ACPI spec 6.5 Table 5.80: RAS2
> + *			Platform Communication Channel Descriptor format,
> + *			Field: Instance
> + */
> +struct ras2_mem_ctx {
> +	struct auxiliary_device		adev;
> +	struct acpi_ras2_shmem __iomem	*comm_addr;
> +	struct device			*dev;
> +	void				*sspcc;
> +	struct mutex			*pcc_lock;
> +	u32				sys_comp_nid;
> +};
> +
> +#ifdef CONFIG_ACPI_RAS2
> +void __init acpi_ras2_init(void);
> +int ras2_send_pcc_cmd(struct ras2_mem_ctx *ras2_ctx, u16 cmd);
> +#else
> +static inline void acpi_ras2_init(void) { }
> +#endif
> +
> +#endif /* _ACPI_RAS2_H */

The tests passed with the new version, and no issues were observed.

For this series, feel free to add:
Tested-by: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>

Thanks,
Sathvika

