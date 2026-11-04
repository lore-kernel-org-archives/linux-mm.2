Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405D6606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 05:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LCJMNaYH;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dRlBEgMt
Received: by kanga.kvack.org (Postfix)
	id 3EFB16B05B2; Wed,  4 Nov 2026 00:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1086B05B3; Wed,  4 Nov 2026 00:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2682A6B05B4; Wed,  4 Nov 2026 00:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01D5C6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:19:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FF52140562
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:19:49 +0000 (UTC)
X-FDA: 85396284498.21.78B05A0
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE706180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:19:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=LCJMNaYH;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dRlBEgMt;
	spf=pass (imf24.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793769587;
	b=h0KRYkRHMIh9Of9xntpeaf1pl6hoC7+eq1ppYfRaqnIiWgHhRKZnea73YUmN5gxRh0Q4Vc
	L6mtwOXyqs9cHCZaRDKM4IcNYC9yKr17tO1K/DyfV1dLUHIa9NminHySbMw4Sh5E+0KG3v
	jsj0jiFuvLzb4I6VRDcs4mGS+6KzanU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=LCJMNaYH;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dRlBEgMt;
	spf=pass (imf24.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793769587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y66vBh+3OjeC/M09B6lCrJHfyOQPIK6q8FMDKTT+hpU=;
	b=Al3JkI/QY8/C8uWCrorlwSdPoSzrQoakyp2h/k794/jmeZLh3gl2MoTMczEhy1j/n8iVbu
	P69PBBK/7BZBI8J7K1Gx1QO43qIO2VJsG3xAQJ6nXzC6Djij/8mWNN4wrxmawKEv7atPct
	CZnc/9/X6tfG4BhGpz/U/0qUHk8eo7I=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RwRV3868170
	for <linux-mm@kvack.org>; Wed, 4 Nov 2026 05:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Y66vBh+3OjeC/M09B6lCrJHfyOQPIK6q8FMDKTT+hpU=; b=LCJMNaYH6N5a4qfb
	AMsqRxjQ9Sv1D7qbDHZTHjggja1g24ojO+q5ldBJ3fJSp+30pRV7E/SKJpJTVroR
	L6Ul8XGUjYTx7i4v88WZhlzgdXUnJyD4KfQDKNOM5GB3puAjspWmdMR+Dp0flvhc
	OwxwxptqAvh88n/vJErz+pnwXmszu74kDBW/0qA4u9bayIB5jw50RUmtOMkbjagz
	pJzKywW729Y6JF6nzTyuYXNhjXIDflejcSoVXfbg8Hg9CiEyQV6wCMBFDNFK05Bc
	wKJrmlavURCofrB3733yQd3t3f6pq4GNJNo95+7fhlDgyzDSc+ivjYGMjNIXd+2s
	Xd+5Rw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8y21sb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 04 Nov 2026 05:19:45 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-341eff9e381so624025eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 21:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793769585; x=1794374385; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y66vBh+3OjeC/M09B6lCrJHfyOQPIK6q8FMDKTT+hpU=;
        b=dRlBEgMtkhYiuRaXB+5+cApeMRjL4Mi6dEXYd9G1rRoSmYJrpz6g/VtPEwjzw7Xf/z
         qm2oA/2ahWVDQ5ms+pxQr92RTpEgpmTaXa3FgDSgZg8KCb2qcwa6KAgDWBDf4ngC81Kc
         CrgOg/UaqFeyghIjN6NIDR6jqcvQXeyfiosedJSlFhTwvE16buF6ZTjPg5SBEOMC+Krl
         NYxhk+5ihtIiXiT+vs/6ET+e37boFvxc8dxiNZZI9DJDcPvM/Vc/hP+BQEerB0z9ZahR
         Ltdt/dA3RctRr6upgJzUab0jlSyx5XRltjNzKZKetFd/wbYt8jYij7RdI+koa65GEQaD
         1vNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793769585; x=1794374385;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y66vBh+3OjeC/M09B6lCrJHfyOQPIK6q8FMDKTT+hpU=;
        b=Cfybm0MkDFvVv84R59/URbpURyDT1HqEdzOHTBBIfUp12dDpRvWPJtLFDHEpJDTGID
         XzWAZtQOfOVgFR3wyA8uxtUSbSG+aUY4sTRy0Bj8ex/Rl8YKVaGUJENXwLzWaXpLvjuJ
         TWwNz2OIwMmmVHzpMVI/lhmKEIms09ZKL54gEXiKnUb4nLnH+BFRRoe26CuD2XKD34N7
         botwKxymSPFAUmeFt9P1t6AHWxsN4L8AFdLY5EKZCmEQgg7FE/zXa3EmM7ZIrAkgt7rD
         +cv4lFW35PhkcxGIH1TvlQvwUY1iYI9zy1Ki7MsMj3knp4KNO3QjXaKkRl7g3vc7M1EJ
         8+jw==
X-Forwarded-Encrypted: i=1; AKwUvByIHYAbR86h4i0iBjqOAWgZGZHAPZIJgbc5B3z1Q5qxpMDN3J0maJnvVdKrpqoWV8kPe9QRZOFNLg==@kvack.org
X-Gm-Message-State: APuU4Z/qEzxZ4/lrzCiwjniuG8pGBHvqxfb2kGyvrx3Kar3OjQ8nac2x
	XxEbOjD6HjuNtcdH9PuE16UsbfvZHgwRqekvf1qdCPN/+75baNFrr+dTQnT8mz83M8mri5IM4iu
	S3n3I8KkMjHuTqOIovnqodHqaB7AmBIY0aodmJT+A6fka5maqFTBPTQ==
X-Gm-Gg: AYBFou2oHidxJVrOccxtLutpc33jTlaUUHj9vExv6PmPZZaPV0inTm8BEEnhoF+8G9l
	P9Q67ML8icufSa8xVHmLr79uTjcktdFcsWVSUeUy+DNcsj11Elc6DYUX/FUNidrW5H2utZ/g3d8
	OSXhvLmriwJqoeN+UxHb2nnWALYKZ2780hDBXkFSvpjgiPTq2d1lc2ZuC84etp30fh8Yu6AZ8fu
	RelabU85DfEd0ds87ZXaR2/ZW/N53PTzLw8ckRMH/BL4S19zOKEseFLFpUBv4EAeLkHIfsh8THr
	nETbtQsILO2/4PcOuh8tmxF3ro/DTFukt/puDgNWvziC3rVXE6zfTFipFRSYqfXVLVDK13xBkgx
	m6x2FLO6GNdmMs6DhOcXJ0IM2ufGmLhr8GTQiljoAyAtc5TD8t+yqnp41fwYJYt4M8i+ySwttro
	vr
X-Received: by 2002:a05:693c:894e:20b0:368:7c9d:1577 with SMTP id 5a478bee46e88-36a4238420dmr22199201eec.20.1793769584583;
        Tue, 03 Nov 2026 21:19:44 -0800 (PST)
X-Received: by 2002:a05:693c:894e:20b0:368:7c9d:1577 with SMTP id 5a478bee46e88-36a4238420dmr22199169eec.20.1793769583908;
        Tue, 03 Nov 2026 21:19:43 -0800 (PST)
Received: from [10.218.18.30] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca39c5f0csm3356074eec.29.2026.11.03.21.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 21:19:43 -0800 (PST)
Message-ID: <ae386ef8-324c-4704-bc0f-a1eca3280399@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 10:48:48 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] mm/memory_hotplug: panic due to race between compaction and
 memory hot-unplug
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Wei Yang <richard.weiyang@gmail.com>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
        Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        Jason Zeng <jason.zeng@intel.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20260903095543.3752338-1-yuan1.liu@intel.com>
 <1d625a60-9473-4f48-a384-7d756ccb7135@kernel.org>
 <20260910031609.qbn2qcxzbitau5xc@master>
 <12147238-575e-49ea-aa83-ea25c660ee38@kernel.org>
Content-Language: en-US
From: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
In-Reply-To: <12147238-575e-49ea-aa83-ea25c660ee38@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 2louRxRT8gN8_9DsYo2EMCfZvqWV0UOP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMSBTYWx0ZWRfX2LpPNv+LG7Hs
 PAQEiyTQqlFsOD3/lSIruZzPj+++jBgc4cC5WMsCv0E3a2ASgd48Okbi8/OG9D9bIOOeBlXppyF
 2+trYEGTTIAZQF4rr84b6ammP/YycIlZG87ln07mvdwaToffA9QOdkOt7znjjjwqSaRiY7CLr7C
 FjQpjR6xpsjt95eO7FCcgsFZrltAmgnpNWjbwyTSvrC+yKEgB8EJRpYjcw0LOMNdl/tl93Ni9Jx
 pZapeBNGBTkdwZ4imKp3SzU9LSg9vHK2JZIHIIHdBqYGxneBKePfkD/JpuQQ/rehpWp4/gOIEtz
 MWlMMWCfEWrKml4af93AyaMtJf7A2yzieuhbLjNULWcRUWgCiBVgscse/8JZLkvJugPQMnbb/j1
 SHH4wqdH9THOX0vrUjWdtLXwIrFcmPRQCg3FoqPN8DCuGYwmZQQ9CJ4oZHQ+LONoyJcKktNggZq
 FiSp3Z83e76ShnlCAmw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMSBTYWx0ZWRfX5+E1o7Au2aMV
 vaCxfr2XX490d7Vh5abDDCTay6lmYAHSorgTj+2NBm0QlQ14ZrJlWWUVZaH52WMIgVFbnth8dVn
 jyFzmxoSlQu4pTfekkPz7LHNF87xiYI=
X-Proofpoint-ORIG-GUID: 2louRxRT8gN8_9DsYo2EMCfZvqWV0UOP
X-Authority-Analysis: v=2.4 cv=NP5AaE6g c=1 sm=1 tr=0 ts=6aeac071 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=VxVhGbjf2C-XuTbq:21 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=YA6iiL-fw10CvUDPNLYA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040021
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE706180002
X-Stat-Signature: 9xtda1ymojxu7m3cquwqgqo13tmhrgry
X-Rspam-User: 
X-HE-Tag: 1793769586-385884
X-HE-Meta: U2FsdGVkX19T7TFnL6qJN7qw0I4PgoQa0jBAqcwGfTfx+PKmFsXGCBRkb2Z+CVbY3L8NVMvqT1+VHezkzmTW781hxc1ouGz/vybBGe0Zmj/tTC6AyaCGC39cPL1s6QqE7NKrYn2pIPP9j4EDet2rUGAocNvjYf0j4eDRaipGOvaYy6ubMniUwFK66l5vhQ0+WoNYYN1wlP/wlwhuenY7tu5WAKhJsYCrDW2g7vtzGGca0tsiE/fUb5L3/0P62iO63SZnbWBEMmXzVZzwuw8NHfOgpI2uIy/FWVHpk7gFFxlrrcFcGjj1owjVgHeCsmHN8Xwtvxk10ql/1BSVRne1Fo51titW01fn/ZBwD2NuPIyaLo/c98HdREC2t5woMCVzPEcWo+vPDHsT+KDlS/5RXFg5/2RjK4a3TpKU5x7wyh/hNEf3DQgg4s3fysDk6NcRj97QKgvgznghmIzm07C14KVdP4lVnq/4GauXzJ5aIXywISE8hgCZnJ4FDOkqnm6Vy11fsdGFUzVlZ2FXST2DIVULAiVk4RzCF/TIGm5hzd63IDzqbcSbsJwNOZU1JvZtjD4m62b9OTUZuXaHdvlfgxxSbXQbEbNz0E4PybNAGQJOM395uCkwIlgA8dG9mCYSJEzps0dK0NhN/2fspIxOChPowK5VVYSqYMRfXhU9qRugV+mRnQOVzyq0BxEYYGT7OlnibVP7/8/4yPasekfOa/CG0Voy6bbxtfnA0vsAKpKkgZV70yGpF64pcYZ3x4v4/6dr4CTM+4grUNZmyhpOFqv9uAVmmKO1eHbgfeAI+vFCEeVZQHx2+QBvhvcAP4Zj+K7/lo+R9TeHUZPYBB9ohSNmzb8lctcis/wnCiyxueDEbv//5uGRYFueFWkY/JzLPAd8JcJqHI+qR/tpX0ge8DstNd2/kPmf60q/GG5seu0UH+Qq3vIKPb7hvlwde0Aoj4om+KgbDTSBmJBzBWF
 hTthzg3f
 008swzSI6P/j4QkDFmyKcS73wQHzB5USzAIw3f0SoD1BaswUfxFjGdeLqspYcgAQvhtjbsCpB0t6EZRprvYKp0HNyMmu3xxPb7F49UQ3cUkjNwMbk7+31dv7oUTxuU1aeCm952gmbhtampmOm2lVFIkoJQUZgeO+q3xc0JII4Ngu2q3Okewufs5Mi3Vj97Eu/3fwGkg028rwZNrcBonxQg9J/80rcZjRddh3ikZeeHmKv1vdJ2G+CuBAKb/JgxUMfGH5/hxfhPuv8K20GfYzXfRlzhKFhzLFn5YyVvMzGJ/vS1rBRLmF/MUrC7mf9mVu299LKR5fBgrOC+sxefSvr1MBjSeVqyr4mCgR1Q/EORXEnQZ4/BGqn/3Uhg4ofxFtIdd7IpQCW8hmy3Fb60jSHLUSP82dpiCJXOKFHMqTQ37mbSpq+FEylZ/lWjHWhip6yCAMzyCGkdXOmZFoJgOJocm7Vo/1bbHb6G/v43SA3nUHuJ4q2MNUvvIYeWrA1m2jrN5CJpJYpjgYciTOo+MBoqmnpv3Q8Y5UMApn0rAzLQB1rbYc2ivk31jlFq366GLGuoBjCyIMiEo+G31o7USsAq6zPAFUZxv5gXeVQWnsEr4jOIRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 9/10/2026 1:10 PM, David Hildenbrand (Arm) wrote:
> On 9/10/26 05:16, Wei Yang wrote:
>> On Mon, Sep 07, 2026 at 04:27:50PM +0200, David Hildenbrand (Arm) wrote:
>>> On 9/3/26 11:55, Yuan Liu wrote:
>>>> Hi all,
>>>
>>> Hi!
>>>
>>>>
>>>> While stress testing memory hotplug on a VM guest running an
>>>> unmodified vanilla mainline kernel (7.3.0-rc1, as reported by
>>>> uname -r), we hit a kernel panic in the guest when memory
>>>> hot-unplug runs concurrently with memory compaction.
>>>>
>>>> The kernel was built from mainline at commit:
>>>>
>>>>      cee9395acd80 ("Linux 7.3-rc1")
>>>>
>>>> To be more specific, after a large virtio-mem hot-unplug, the guest
>>>> kernel takes a fatal page fault in suitable_migration_target(), called
>>>> from isolate_freepages() during compaction.
>>>
>>> Sounds like a real problem we should tackle.
>>>
>>>>
>>>> We are not sure whether this race is reachable under realistic
>>>> workloads or only under this synthetic stress test. Sharing it here
>>>> in case it is useful, and in case this is already a known issue.
>>>> Thanks.
>>>>
>>>>
>>>> Call trace (top to bottom)
>>>> ==========================
>>>> - RIP: suitable_migration_target+0x5/0x70
>>>>     isolate_freepages() <- compaction_alloc() <-
>>>>     migrate_pages() <- compact_zone() <- compact_node() <-
>>>>     sysctl_compaction_handler().
>>>>
>>>>
>>>> Why the race happens
>>>> ====================
>>>> CPU0 (compaction free-scanner)          CPU1 (virtio-mem hot-unplug)
>>>> ----                                    ----
>>>> page = pageblock_pfn_to_page()
>>>>     /* checks pass, section ONLINE */
>>>>     /* returns valid struct page* */
>>>>
>>>>                                           offline_pages()
>>>>                                             /* section -> offline */
>>>>                                           __remove_pages()
>>>>                                             vmemmap_free()
>>>>                                             /* struct page UNMAPPED */
>>>>
>>>> suitable_migration_target(page)
>>>>     PageBuddy(page)
>>>>       read page->page_type
>>>>       *** not-present fault -> panic ***
>>>>
>>
>> Does it mean, the combination of pfn_to_online_page() / PageBuddy(page) is not
>> safe, when there is hot-remove, even for other users. Not only compaction.
> 
> There is an inherent race between any
> 
> pfn_to_online_page() user that then takes a look at the memmap (PageBuddy,
> whatever).
> 
> Usually, that's not really relevant, because for things to go terrible wrong
> (instead of only being slightly suboptimal :) )
> 
> You have to run both, memory offlining *and* memory removal.
> 

Hello

We faced similar issue internally on one of our target's guest VM run,
where kcompactd de-referenced a vmemmap pointer for a PFN after the 
hot-unplug path had already freed that vmemmap,with no lock preventing 
the two from running simultaneously.
Call trace:
   suitable_migration_target+0x0/0x8c (P)
   migrate_pages_batch+0x1b4/0xc74
   migrate_pages+0x150/0x654
   compact_zone+0x5bc/0xb30
   compact_node+0xa0/0x18c
   kcompactd+0x228/0x4d0

Would it be okay to introduce something like "try_get_online_mems" as 
shown below to try a readlock in compaction path for hot-unplug to wait
for kcompactd to complete before freeing the vmemmap?

get_online_mems()
-> percpu_down_read(&mem_hotplug_lock);   /* may sleep */

try_get_online_mems()
-> percpu_down_read_trylock(&mem_hotplug_lock);	/* won't sleep */

   kcompactd / compaction                  memory hot-remove
   ----------------------                  -----------------
   try_get_online_mems() -> true
   holds read lock
   uses PFNs and struct page pointers

                                           mem_hotplug_begin()
                                             percpu_down_write()
                                             waits for readers to leave

   finishes compaction
   put_online_mems()  // releases read lock

                                           writer acquires write lock
                                           offline/remove memory
                                           free vmemmap
                                           mem_hotplug_done()

And to skip compaction if taking the lock is not successful here.

Appreciate any suggestions or feedback.
Thankyou.

> For things like
> 
> page = pfn_to_online_page()
> if (PageBuddy(page))
> 
> That's unlikely to hit (no reports), and we could likely easily fix it with the
> help of RCU.
> 
> It gets more problematic when we do things like
> 
> page = pfn_to_online_page()
> ... do all other kind of stuff
> if (PageBuddy(page))
> 
> (what we have here)
> 
> Using RCU is usually not easily possible. Mostly only comapction does something
> like that.
> 


