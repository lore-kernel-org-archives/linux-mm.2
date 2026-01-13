Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8474D29DF3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 283096B008C; Tue, 13 Jan 2026 04:33:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D996B0092; Tue, 13 Jan 2026 04:33:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126B16B0093; Tue, 13 Jan 2026 04:33:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0393D6B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:33:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A996E573C3
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:33:10 +0000 (UTC)
X-FDA: 84326426940.01.78F154E
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E4D01C000D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:33:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=fZ0UFaTH;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=GFJhfU1M;
	spf=pass (imf21.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768296788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Eiifu80j52RijGjXr0wmDrto47lICEqQroalzmp67M=;
	b=x5eruFqEJqFzh9htZKBTHBLZVDSC3VPiAtfGsiCyJWQtGqbtiv285fo9kLffMndTJGR0SC
	1Oui4oH3HqPdtiBqHn0szfiePqkdwHnri+LbnyfpPUsTpnBBMui7O2u+dE7XJdg3jLzBn1
	JEtAxH29ffBOP1tgFNnhsvD1Wq4eHiY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=fZ0UFaTH;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=GFJhfU1M;
	spf=pass (imf21.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768296788; a=rsa-sha256;
	cv=none;
	b=Z0ODv7eLKmmf8d3RUnY7le3WiF2kVmhw+Mq/No4pB58pwpXg0f3TORMO6xj1xKfllVYNbN
	m+p+8dGsnHva6eN54DRQBLrNvoI9ggbmwYBJmvCpmexzBwl/hf6eXsur4xuPQQLk0SoAqN
	MdVcB9ExuB0cBXlCO9GbOz5g3L8p6Ok=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D9MKBh2751326
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1Eiifu80j52RijGjXr0wmDrto47lICEqQroalzmp67M=; b=fZ0UFaTHpp3VQxv7
	41/ygaOqURkgS+QcOuMwXCj2F0c9c246Ngcx1OSWcmq1qCZzK5tcoHnIyLARRC9T
	3jZJfrcgqc5z4/WzjW2AVsv6zcONO6gmn6To2XqqZ7EpNYhzJa6z2hpJ1yhk3V/k
	sIJW6ZTLRL81vDA9eLkajoQAgn68yPkHVfXA8Ba9alf4vRU0NhfaNf5wL59ZulQ1
	10IvqCDzb8PWhY4ZEN+qoMPzzUkBkfRQ5ic+NCWUh5xZmBWBP7aF3Mhvnqnb6AqN
	jSlAXHgnm1HD4ew6zEExPlLen8RJ4QjLvHw7aedI7muusxTONUGdRe37kYfe3Tmv
	XzeWPg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bnctjs7e0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:33:07 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a0dabc192eso72834705ad.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768296786; x=1768901586; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Eiifu80j52RijGjXr0wmDrto47lICEqQroalzmp67M=;
        b=GFJhfU1MCW8ZQZdxx68ja5hc6tcJ6fuNhZGCS19rxyJUKVW8UtNjUM7Jz7IkAARPNf
         UsrEL8BsmjW9fhxvLnmK72hAKFUkCymieAPjreDKjeliZ5S2KrxhpqNuV1yA+R72kTvE
         DH2kLyovz7IbIIvuHMefKqYqSARhpcsykymfmfi24EyF7TojnNzxY6uShpVTQzETIVbH
         dongSjclxe4+sROXKbIw1s2rghJ8UcWda2i2JJ5UUowWwiJUYGp7nQmSWhrc1tczLf2z
         gju1t2HO8P2NaJcmUjfXTObpzjxrQa3VeG5HwxCs/tU8tStNwE+XBmj03sgeAgZjGRfU
         RSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768296786; x=1768901586;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Eiifu80j52RijGjXr0wmDrto47lICEqQroalzmp67M=;
        b=F/Vleof5xiff+U4cPpQPZyDDdah433iUFyeTZSrW/n/Wg1c14UuebCpMUgkkmjxZ+C
         3V6/YdiAOCkBhBtrcrIeS4KQhU3f+sHMACciO6yleqnK36+ndK64hOBjQzbJU5f9uafi
         Ov2QSx7eD1Wnxh+fgqxhgU3GJCYEDfAjvPlJlX2aVTHY+oXAeYRVMEFK3cCnXBPbQSKu
         CYaQI+rCy/gv4a8OlM4pHCdZuNRHjsI80qrXeyxMiJOMs5UoP1mo02K7MF8r3gS8BZ+W
         ufGrOutIQ//+09i8pIqTttYF1ioK9PVu0TybpP+1pe9kUPjEWywo5HGBH50qtevPT6ap
         VWQg==
X-Forwarded-Encrypted: i=1; AJvYcCXxrwpizwbkBbHkl/YrEgrIMZQsazp/A+CPoJ0WGpAU6WeRAlW4OpCW0Vun/2LYxO4iaos1oWdCew==@kvack.org
X-Gm-Message-State: AOJu0Yyt7e22V0FFQnVUt9qnbb4qI7Uu0gGGcTEtDMtHwg7uQ+7QlKbe
	km1nFFfPqpDe8Kk86jGPeWcqlzUUP82HMNcNagYoNNrxCeppxVmgkjTp/umdgpr2Yz7TzazxhoH
	2ypmHQ8lh2izxQfCEiG0Gm/L0Rbawthg9Sa8+K23u137DGiWb6591Yw==
X-Gm-Gg: AY/fxX7pSLbDqMTCerdmr+BHcd+oQGNQwl8Gi6SgT+SrOUMvadcA2btOSkwwuxnJU7A
	CQcR98js5HA/UpY7BdO0apaV3SlBeQhmWi//cEHlSSSqcmJp7MzIfjpBjZGPm25n9Yj0lbZITYo
	PFIStn8ZlGoDfW7NObKqWVGn/MjgGjfyrfbcbSdWc2WIJHRVhY0QQm8xwkZ78Zb1i/ppKUbqbQX
	/N8xRF7JjtV0q3iJtbaE7u6QCFKlioaOleO69ZxD0rjBpaJrRLpyIDN/AIPFTwcxfZZTszmsDh+
	5DQTzBD/PFyUi+lY59BCg7iBbAPQTeK+GSDPp55cG8XzYhe+MjFTo1mkc9yIsmPlC7hw0WZ6BVQ
	2xwKTUsliMRcn9uPgvwII4qchHpxX3M1uUOMweK4evA==
X-Received: by 2002:a17:903:2b05:b0:29b:e54f:936d with SMTP id d9443c01a7336-2a3ee433175mr209045455ad.1.1768296786073;
        Tue, 13 Jan 2026 01:33:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFUW+AGHuF4co37Yj2KMp2HJuC+tdM8BWSZSCu/VCAIlvHrWutChuq4ZOgZfyraylsR1ktpNg==
X-Received: by 2002:a17:903:2b05:b0:29b:e54f:936d with SMTP id d9443c01a7336-2a3ee433175mr209045135ad.1.1768296785541;
        Tue, 13 Jan 2026 01:33:05 -0800 (PST)
Received: from [10.218.5.175] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48c75sm199484985ad.35.2026.01.13.01.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 01:33:05 -0800 (PST)
Message-ID: <d23898e5-caec-43db-ae29-2c56a6b83693@oss.qualcomm.com>
Date: Tue, 13 Jan 2026 15:02:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: akinobu.mita@gmail.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com,
        axelrasmussen@google.com, bingjiao@google.com, byungchul@sk.com,
        david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org,
        jonathan.cameron@huawei.com, joshua.hahnjy@gmail.com,
        linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
        matthew.brost@intel.com, mhocko@kernel.org,
        pratyush.brahma@oss.qualcomm.com, rakie.kim@sk.com, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz,
        weixugc@google.com, ying.huang@linux.alibaba.com, yuanchu@google.com,
        zhengqi.arch@bytedance.com, ziy@nvidia.com
References: <20260113081453.8293-3-akinobu.mita@gmail.com>
Subject: Re: [PATCH v4 2/3] mm: numa_emu: add document for NUMA emulation
Content-Language: en-US
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
In-Reply-To: <20260113081453.8293-3-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA4MCBTYWx0ZWRfX66ch1zlJHTC9
 rw9dt9q9G3eqf06mFqdtaEuNjS30KNxVv7r7FcTvTXZW8dhyzCrlOUD3X2wmMs9wV3kSeSxwIgZ
 tpdxJigeIVQHiPkteYx2ys3SFkrd2ZSCxpMHU+j2Ba5FkxnX5wjg3tmZ/hFIjVwXfQZfFUdhU+V
 JuE6tuGE0QcMLjaB0BB4820Isetz855HnjV5rBRDc1RiY47jC+0BcN8sxFUzLJTTz5QRYWKmOlm
 WXDKCu7dA72TPB1PpXKhw1HM5/6oAqPiu01ihSEIZd6irlLV5oSRZQi+//BPthdPuoRm3y1Kf6T
 6m9c+R3NWgtgJPQH9yuMuwyyfWgIeuGKC7G25Odf3hooY+XEszbTVgvbKg0FeaTGEijekVIk9Vy
 5Z4hs96UMXRW7jlvKFwV7F+92JiavcgnPFPLw8QchT4D7FcnrvYPCQyUUNl0IdIGPqPIlNNB+jB
 pBB3vTiKF/efYnfVjLw==
X-Authority-Analysis: v=2.4 cv=Ls2fC3dc c=1 sm=1 tr=0 ts=69661153 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=UdPnmgDXQIG4_xgNs28A:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: d6_fCtUmRUIfL_4R9yFhr16gLMhNYQIF
X-Proofpoint-GUID: d6_fCtUmRUIfL_4R9yFhr16gLMhNYQIF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601130080
X-Rspam-User: 
X-Stat-Signature: rx6ziguhw4geb997yooczp7xwre6fehi
X-Rspamd-Queue-Id: 2E4D01C000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768296788-420889
X-HE-Meta: U2FsdGVkX19FI1ug3TjpIohVjDbIiFCg/qGlGXU2gGatUMsIyXyJsGTFxj0GqQFs5wW4WMh/hVR3/y+zn3yvMbXDdpu9APyxdE9LRvCwURzCcZZC9J7CNoZEq61bLbG1d4YKczTWZCDsN+9oe/9O6Pxnjk/yArlx2NqXPPwHOx7344WUhkSWp+LVXrTTLzaEOwVjq821kwR7R/MFKmrittxBNilaeo8Hl45RAZTZ7bgKEltZ/z3C5BmYjUjTtt4BxsB3MDlbs2E0Y51oG/E+a+ytm/a4xrIp7JjhbgefezV5wYpcVIZmbGuM4XZXkVl2P4RD0+CifXCGhSYSFrKegW8n750kISNmnB7APF9wZLTv0FVWsPN2w2wl4gldZ+GsenlN1txhEg711w57IwT+36uQiTmYphkWoUvV4j261E1S9a9YU1tG0fNGn0Wv8JBiW5ipt2yF/slo3M+uTRbXyr4wFUOv+NFcAlm7IXOuCFp0zXOXbz9f7Q36BpUGfPM9+Ju1xGW7Qw0M0eNSwYizBKOAuIvlpWRHMGOosVlQ+Jz0RI0bg0lMJwRIGldAN3BoPrI+Pu+T9sSG8GcLXXCeNZGb6iQPpR2tIy01O7ISs7b0r3g1S72Kkn4+mEpbIrvKo4Za0UXwdU5cQ8rlpXr4cajak6ak5fpwY1w097BXG45CGfBmAvd/95Mgf9kA0nbinWTJqc8nXG2k8uU7UAxvCMxuf+f6S1cFCqe1/FLOb0cECdyhcBDkwtAB4AXHAYaNMgoPombzs0/kprVWqE+QRXuti1czYKMHziBMXKpslJkIHMt2S4P+bgWDAkNsnsET5yD7D5DhTR60ZhDOp/dz45GV+M3iUi8VjXivDr9VY6Nl5SWkW1J1ZLJMt6XfynGUVO91XBXxuyPuYimXucF6nwRNm08Q/5/8tD9FVip4TRl1KvXBXeq002wJeechMe/sVkzIoGoXwRx9G5y61JW
 37KtSNkt
 Xd1cnG5QsJUq2MR0DBFh27vO8izNvZVl59YrkQMRq92kj6DUmGuhCsfoYhEQyzD51gkS3uaMgle5lzIlLqzHklla5FUgQAUWttJuwugLyD1VSM5fjkUweWHSW8QI0TDc2VVwfmez5CdqXm6iQmdhh5QJEasYgEjcRXf6KAufPtfXTZslWSB+QZzT6NhS4WHmIUF3cTQ3Id3OmKmykNtn09CV0FsWBxbpUWy4kt8vZS+Y9BRRfbqZXdFwek9M0JjafBmQwFTPraiAsHniFQBhp5/BJpuKB/dj+jt2Vu5vYSHsDTPnp+02BGcLOysRICo0bH6qHkmcKf7k1ly19npK4oXYE0Oib9eynYOWAiSjm3R6qbUJGgd+v/ZCYydp2TRZRNcLw9BZ31u1tmfIBHTDb3QUk5sYotB9PBgVtuEZKaMB6Eqi3h2SIq/ng6M7ckf2D6+GQnyRn5vTnvM6Np8XGiKpbte53VSnYkbnBbrwjeFVzALnuTO9y4wEOvvp4lJi7Y2f2qXHV5Lf08d1Y6IwnIr+DtCTcZJMBqQNoLzvrCVAKs1/DRpcCVmc7opumADrINDXYJZDQ9CnlvzLPamDeF1GsylG/XZPamryeKA37p4Bb92H05wei+8VkiHUJs0abHL9CT2gevKzKOdCh0pTjtJazPj3BbSsxgAGYthrSmMsiQttxZACpqax+6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>



