Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F04FA3727
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 23:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5076B0088; Fri,  2 Jan 2026 18:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969426B0089; Fri,  2 Jan 2026 18:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A1D6B008A; Fri,  2 Jan 2026 18:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7296D6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:01:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C25331C4F5
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 23:01:17 +0000 (UTC)
X-FDA: 84288546594.08.3197570
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id F28E7140014
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 23:01:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YRo+3b1Z;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="QBNa/jao";
	spf=pass (imf23.hostedemail.com: domain of oreoluwa.babatunde@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=oreoluwa.babatunde@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767394875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3OTeFOaQb58wR8asUs+5Bv3nru7hCHc4Esj5jAEU4c=;
	b=sH5LlGrDLHO1FL7fkhn7LvH5AcpLM/+6mEStzJY4IrIqpww0j8Ks+zSQ31NYpuqKgtNWtw
	SX1CAiNpNbRcAo0c7jYB+Evcw9qGRn6PEmUyetmV7r3411Jkh0UwnoUGmYzKUMg39/vSfX
	7Dnq7qJbaJkYwmcABTNOWX8ZbR9tDAE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YRo+3b1Z;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="QBNa/jao";
	spf=pass (imf23.hostedemail.com: domain of oreoluwa.babatunde@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=oreoluwa.babatunde@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767394875; a=rsa-sha256;
	cv=none;
	b=aZNe0K/sFsb06ZxWTkXu8VwqNIcCgTfld7A8FaGDACrfYxWPe/kPvhISz9Bn3RjkstJ+4N
	99/mVkyMVCutLYfky8fUpc1w/MrhkL0o/UYHwnTzML2kzVzM+ap+ZuvzVkR34QutXXctXa
	yaYKTzHVvL28mxXQIKJVNfFBuoFmeaE=
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6029WCgh504776
	for <linux-mm@kvack.org>; Fri, 2 Jan 2026 23:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b3OTeFOaQb58wR8asUs+5Bv3nru7hCHc4Esj5jAEU4c=; b=YRo+3b1Z/m5Dylux
	5EVsknToCHHRGPAJTTZ1vBLvbQMowmL35UG4cWnn4hONsdjTfQM8X2wmoAGqbUwO
	fxDGIKKohHpO+telDUjlLSzXhTMZ3qI99wxYjZ/TUrAI7kzzCYp5M6h1Me00iz6p
	ZPW8hzScB1jnHo2euHRl1eFl1Uy2OmeZ8wy2xawxLckUoh4dVJy3s4bgP035YnJn
	xruoT+pzIz4jrD257IunTBS6WusABcKgC/raBvCzeGoidhWRRvVPm9bKHI/UBNVF
	2UHK/3EjnqttNTNYDedoaH9/M9ftlyzfyn6Rn/WeHP8HCtOcISnfPEyqycZ3h4gE
	uPPb7w==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4be8bk9ssq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 02 Jan 2026 23:01:13 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b98e6ff908aso33891132a12.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 15:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767394872; x=1767999672; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b3OTeFOaQb58wR8asUs+5Bv3nru7hCHc4Esj5jAEU4c=;
        b=QBNa/jaoom73xUiP+GMVJZDPky5PpfLiH3OSxgFs/8yoqMqBJ7knG+kVvqd2yKeWSd
         IC7vTHrSl6eMXuGGSI3r8No0XjGFN+r5bFcODsaM6n3tBGR2FDFmYNvvfttDngNtE2jE
         LizBIWi1Ji/hJXZHFfIR1uNlyDIfSDiSauCaWqh4/AH062vzYSALpLI/Luy/KCt99SiZ
         Kzx0Dvvp6vWN/UZApd691TGdF7RQWomIzpYTMWGyOLzziWvIFk6f+9kpNd+5FcpfwMpy
         ez3TUNurVbSZAAihLJTU9c/LZmdwJNX9/V2Tr8MTq79S8r2UF8VDxSIXwZ+B32lmkb4o
         JS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767394872; x=1767999672;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b3OTeFOaQb58wR8asUs+5Bv3nru7hCHc4Esj5jAEU4c=;
        b=XBcQvZHhgsr0h6bP+AME3i3Tm7ekDV60Uahq1KirtSg0tO1VZSsyQxe6u9tS8/O8GL
         C8ty7OpeVp2+65KtiwVZU6sW9XhihQ3uKk8GoH40+DFuvV9+RRPIYZL6Sbl7paFmQjOi
         03BOxLQ9o4+QlQwbGEn3W/imiskPYuXT4Ql5MFTXH5NoHbKNm7v7lk9hM4MfIm4Qj1Lx
         JVdIxeN3zgQWmpeoSonBJSUvyw+xxyYQdEZAttpjeYTA95cDUrNjs+9Wuq9SgvdF87oK
         PDw0n9YPpaSnjito0bppML6z9ASfwr1IZAJZf+uDRlFsLYzteioun4UljRlui5gn6S5H
         sGIg==
X-Forwarded-Encrypted: i=1; AJvYcCWu+F3pgcDbQbNDAIECS4n1hKs64XrFR4epp7UO6jYxuFb3M/xQbq4OJJ+NvY+hxiXw3PtMVIJOCg==@kvack.org
X-Gm-Message-State: AOJu0Yy/WibQv0pGCj8EuIWI4h7pq0ze+UjwzCOeXEzX4mpFKNxXxPMe
	HfgGw/CihPEnWRZQZJbA6xpJvfgWdI1dfz59rLl1QNQ5ZnFXNvAAEcEC8rP22lBVOZPmODEM1za
	azLkaGPluJuKKt8IxcfV09oywCZgCEJN7Lor+x69ZxOeoCGALYEZRnw==
X-Gm-Gg: AY/fxX6bhSJsAEX2fTAowrvlbKc87EL3EwPPEkrsIYN4e8Ag8thdMYI5lfrZf9pLDGN
	DAPdch6zFSI254A2ciiMrRKAGo1CPYaKrxmrC805er+SVdQBBDBwxBqb5QG6qY4Ab90LNVKMUWV
	OXr9jwbH3HOMkTMYJnQzHJmJPypNE8iDfFY2R5xmW4F9/Dz2/aS1EK0F1jKzwN1RBoKDST1crDH
	vnjRu4Cv0wRd4Oxf682sSdCY7Y2NV/tu7ailGb4z9D9JrYcf/oN2MtGDO8YqKexeqxUsItOye/b
	6FOAQdGaZdIqaJ2wn8nrcvEcpevzzWJh9ixtKzhFZz46C2ulcsxIsR14baDRO3iSl7mpYUVeOBE
	Xg7H/Jg2qo2UMl91LxeRQQxBCr0aRX9cf2jBuNwxU9QnE0LpFSzVz4jaL8gWgp2aDKaAp5v+jag
	==
X-Received: by 2002:a05:7301:2aaf:b0:2ae:506b:4b05 with SMTP id 5a478bee46e88-2b05ec6f3c4mr25270510eec.27.1767394872476;
        Fri, 02 Jan 2026 15:01:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5EitizlliS+rSAvKNLC290H+9iTiSCypg+98RCwq2Jc/ptsUK+jo6pJwm9qtXZHoXSeq46Q==
X-Received: by 2002:a05:7301:2aaf:b0:2ae:506b:4b05 with SMTP id 5a478bee46e88-2b05ec6f3c4mr25270481eec.27.1767394871826;
        Fri, 02 Jan 2026 15:01:11 -0800 (PST)
Received: from [10.71.110.87] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05fe5653esm93661329eec.1.2026.01.02.15.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 15:01:11 -0800 (PST)
Message-ID: <d513960f-59aa-496f-95fa-28a01b419fc0@oss.qualcomm.com>
Date: Fri, 2 Jan 2026 15:01:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
To: Rob Herring <robh@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: ye.li@oss.nxp.com, kernel@oss.qualcomm.com, saravanak@google.com,
        akpm@linux-foundation.org, david@redhat.com,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        robin.murphy@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, quic_c_gdjako@quicinc.com
References: <CGME20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395@eucas1p1.samsung.com>
 <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
 <X-TH#1.CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
 <99dc91c9-59fd-47c5-b1d9-157bda86ad59@samsung.com>
 <CAL_JsqK5QEZfyRTDY4z88mX_eYENibea1ZM8H_bEfCCsOOwY4A@mail.gmail.com>
Content-Language: en-US
From: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
In-Reply-To: <CAL_JsqK5QEZfyRTDY4z88mX_eYENibea1ZM8H_bEfCCsOOwY4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDIwOCBTYWx0ZWRfX1k3aOd3MXvqS
 aybmsuykl0JrEIjixYzmv5Y1v2YqQoN7dJtTVN5vUSSgxcAVp+z4zIVvbnOWbaum+4ZhvkDK+52
 QjKzDvWUY9FOLwFz57c1lzJokKkqxpazi6Lqe9+PDPzflOARUjioSV4K+WXpTJ+bK2M962exvR/
 CEICiirdojzm1v37HG8EP1Gnh9gh3GspCYZ3jYkCp2vVQxQq2buryrpVqqcEmxCulUYgDjipx/L
 UydImUI8QUXOkBydZgoWNLgBHqeX1T7DREi4XsaUoKn7ZcaCxwhKKYKcSmUrg6DLj6aXspV+41p
 qlEQwwbBV2JTLWZUx1e6VrAy7+lYAj/OLcNfcaMMtkeb0kUoXu9+c+RzSjqEBLHlub0wnm5olhK
 0gfWK+EEiWAAjfcsYIKvmjNH7jxK18oRCgESLcPCrsX7HI56wcAKNq2OIyXfsG3PeX2dsucT9op
 MBZ8bve2aJMW4lLmh+Q==
X-Proofpoint-ORIG-GUID: Bs4I2uM2afxxeKYt3Xv8i5SSgwxu631s
X-Authority-Analysis: v=2.4 cv=d5/4CBjE c=1 sm=1 tr=0 ts=69584e39 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=hD80L64hAAAA:8 a=COk6AnOGAAAA:8
 a=EUspDBNiAAAA:8 a=f-5fy8xPqO0yBxf2x6wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: Bs4I2uM2afxxeKYt3Xv8i5SSgwxu631s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_04,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601020208
X-Rspamd-Server: rspam02
X-Stat-Signature: whzsa586oqftd1y6b4cjez7ojj3jw31o
X-Rspam-User: 
X-Rspamd-Queue-Id: F28E7140014
X-HE-Tag: 1767394874-885755
X-HE-Meta: U2FsdGVkX199+nSzqa/bFg2Ge45/W4jDkG9jB1LiV310tI55749B3Hj0R+JScOA8hlHLKjk5awkdZUAN5eMd37v5WahQC89hkLguD7W1NA8P/B+cbcCEBRq88mvxQAlAeI0NTKb9LetjcoHrFtDlz6N7aAgx1RysJa1aLBH9+Vdq7cSthJTXaUwfJfUTgRXznqNdwv4e1A/fNI2e+UHzNLkzuy/+oPxrhgqE2HVKLuK8fi1c5tpM5sMSF5wJdSR6AJ4eE0oxy7nfh9f1OHA+FklJtF5LTRaUaFvp0opanYchv3GAX8pGo2DAy0wORey9OxyeNdsduXt+kvVk6ztWdls+QL2fSvVTjgo8LAua7BZNhlI86vAh/JhIzEUFnT6pSF2UAIbrgnRzfUJoTBHpsU/bUzrwlq9t7PYE58T4TlKACsU2wnSo8uxflONY8Kkr4XpRf5adaiUkU+E/ZY7nOxyA/u/NVz+j2C/aZbSjF+p6qmLn9ee7L9lh0S8b1BVFeG3eRlTMhLUdd+6LlqGOjvS3O7758WQbU/Y/fpOySObvY1mz2ELgGyM3ldfdvxJ8iic30WNWMwmCUfhVZFE5czr/IbWKftjS8alBvCCGOxxMBtZE4CZeSgR5R2HMIqMtEzWFG/Q64msHT6aIx8CqbVZAAlmNakJT/xirKzlpfIhTSjlPpAJZcPliS0SNut7wTUWWyNkLR7E24Olu9c9xAHjvjkFsKRAhDWQ+hJLAarIQ3t9eipjG7C8HQpk3DwwDr3y33/YS4OOyTbJt6e+SlCSjoEUp1lK7xtK9OFw23KINjcTEQkScAXxETxqOe8pyBwk+ZuO6Z2L9oipMmG9ZJEw6kbmCTA/Sol9CWHNMBumZ2pVAC1WfZdHtU7fZJa0kM/MSmwJNptqOTa31jWQ/STmEyb8NjTMW8xZc7kUETqoQvMhgtUtIQmtivtB5FsQtyKWcjS3uGCF8X5x2BIw
 Xpq/lanR
 kX05qdJRlMOdw30a/ltRCzqbUw2y9lzpWK3YzXmI9z8YbSZlZ6RNkcYzMsc7GOktOH7ukX28GdHIJBc7JADpp9oCp58/qZt1v/jB5YtobJqcup1OnkdXvFSyNmeXyVX4nuS/sR5twOH0o2vP2I8n/xfHAa345TXmYnbd9MtypjRkYFcYlhZkVJqA1qpf63gKSOeC8LREW7bcZeuCT36D+5ndbI5IE9DJ99d7JwFgugNT8YrlNCtwshx1UeV0NSxIbJ+5YD+hBiQtQFcFjP4loh9ILmOlRhQ4Z3+77DhGvMhO+MSJ2GVbHLMJeclptlxtrxAU1xEXP4PnIyhYm4HqUu8s5nCTj2GrIB1nXNIfO5rfKXC1cTCtpsGgzyn+yzF/JBVzpyGKGupsea03YF27tCyLKaz04ha9UDCHqUIJLk8DfW3UECY8rks+9hIODlubvKvTbheWCeL/DhdvYW9GYbCHnhnNgVXh61FmcJCStG93jDyjCzntum6icc2tMUAQ88GkVQjY/SEf0cfuv50E08M0AAYWHcFFuuhy4QoeDMF3+SENOg31Qs84peWOlsEXw8uJ6fdaDcQSo7grn1DmnKBwLVljuq7aCmZwK8HJ+/bexIYvzvWCwBzwIZDzo0ArL4+3RZlQa2VG+oxjHPgYeQOeaTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/2025 6:42 AM, Rob Herring wrote:
> On Thu, Dec 18, 2025 at 3:55 AM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>>
>> On 10.12.2025 15:07, Rob Herring wrote:
>>> On Tue, Dec 9, 2025 at 6:20 PM Oreoluwa Babatunde
>>> <oreoluwa.babatunde@oss.qualcomm.com> wrote:
>>>> When initializing the default cma region, the "cma=" kernel parameter
>>>> takes priority over a DT defined linux,cma-default region. Hence, give
>>>> the reserved_mem framework the ability to detect this so that the DT
>>>> defined cma region can skip initialization accordingly.
>>> Please explain here why this is a new problem. Presumably the
>>> RESERVEDMEM_OF_DECLARE hook after commit xxxx gets called before the
>>> early_param hook. And why is it now earlier?
>>>
>>> I don't really like the state/ordering having to be worried about in 2 places.
>>
>> I also don't like this spaghetti, but it originates from
>> commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
>> memory regions are processed") and the first fixup for it: 2c223f7239f3
>> ("of: reserved_mem: Restructure call site for
>> dma_contiguous_early_fixup()").
> 
> Honestly, this code wasn't great before. Every time it is touched it
> breaks someone.
> 
>> It looks that it is really hard to make reserved memory
>> initialization fully dynamic assuming that the cma related fixups have
>> to be known before populating kernel memory pages tables. I also advised
>> in
>> https://lore.kernel.org/all/be70bdc4-bddd-4afe-8574-7e0889fd381c@samsung.com/
>> to simply increase the size of the static table to make it large enough for the sane use cases, but
>> it turned out that this approach was already discussed and rejected:
>> https://lore.kernel.org/all/1650488954-26662-1-git-send-email-quic_pdaly@quicinc.com/
> 
> I guess the question is what's a sane limit? After 128, are we going
> to accept 256? I really suspect we are just enabling some further
> abuse of /reserved-memory downstream. For example, I could imagine
> there's micromanaging the location of media/graphics buffers so they
> end up in specific DRAM banks to optimize accesses. No one ever wants
> to detail why they want/need more regions.

An earlier patch which requested an increase to the static size of the
reserved_mem array did include some breakdown as to why a larger size
could be needed. Eg: cma regions, dma-buf heaps, Guest VMs, hypervisors, etc.
https://lore.kernel.org/all/1650488954-26662-1-git-send-email-quic_pdaly@quicinc.com/

I also see the same problem of if we are using a static size and just increase
it to 128, what happens when someone else needs 256? This is why some form of dynamic
sizing makes sense to me.

> 
>> Maybe it would make sense to revert the mentioned changes and get back
>> to such simple approach - to make the size of the static table
>> configurable in the Kconfig?
> 
> I'd rather not resort to a kconfig option.
>  
What issues do you see with using a Kconfig as a solution for this?


Regards,
Oreoluwa

