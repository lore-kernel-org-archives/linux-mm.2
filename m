Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDD5606A895
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=X90VZJBR;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=MpGwh5MC
Received: by kanga.kvack.org (Postfix)
	id E8C576B05B1; Mon, 16 Nov 2026 17:27:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15E16B05B2; Mon, 16 Nov 2026 17:27:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE296B05B7; Mon, 16 Nov 2026 17:27:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 891686B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:27:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA98A40255
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:27:21 +0000 (UTC)
X-FDA: 85442419482.10.F1A6A2D
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 259A51A000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:27:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=X90VZJBR;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=MpGwh5MC;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794868039;
	b=FVCjL6HS808kYnTaLvWynQtS0fv61AsR6qkEITBrcAF0QggEwd1q/VejnWTZun5I3dUCXi
	8Xk/tj2ekPXf/tHp67jm3l5q1qzgfPxv8qpIJdmnEQPYEAZ4JZkvnANRIVdq8bX0STJKEf
	ix6iRacn+wwfhkiyP6eYHyArF1sMeQY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=X90VZJBR;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=MpGwh5MC;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794868039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vyYjn5UPo/7vDc4ZQ9k3Cq0mbqo2jzpmjoiYSVxIwk=;
	b=qL2lR2xsUHfe816FHYsczL5+tjcf+63i4dBoi/Ltcu9nqplQekt9O9BlNSVGRe+06KD8Vj
	sC7DaXxkBZ1zjYOZQEb/OzMFKaE+DF+EOffGnd3BLoJ+2NHlgZgd+SPoGJrpBFMX5/KJ3N
	Kzu/C5Pls5z/o8o7h6N0/a7LFJM145A=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGLZ1nT1764042
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=4vyY
	jn5UPo/7vDc4ZQ9k3Cq0mbqo2jzpmjoiYSVxIwk=; b=X90VZJBRvXvcQtWvtSML
	cYnBp83zg3R4X+C8UXFrR/0ste+aFkHEr5U77ylXLx4BUEcLYtTW6B1yLY5tikag
	7hbIrco84ujOdJmB2/epEniEGsLrXYXe1ogsWavEfw24C3fPqOCdzA4WKEAhAoyl
	W+BiUtmuvDa6x3vhdpUGfQ5zewpasoXg2DTVzpK9IPd5mjYO/hG+kBfhrQrDAV0h
	TUtAwtC3EWjhSAGNAofYPlS0P3Hgb+oa8+ffNiiYvUKtYpZ8PZri4s2OAy1x1STh
	BOsI2Jk34RJ5O2MDTpfuwmsMD70Zy63yJ+SR5N0pc/kQZMhE9m5dnWGWEc5XOo47
	cw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059hk91m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:27:17 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-55d33f412b1so36530701cf.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794868036; x=1795472836; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4vyYjn5UPo/7vDc4ZQ9k3Cq0mbqo2jzpmjoiYSVxIwk=;
        b=MpGwh5MCmNCzoo3IJarWbP5EKxtDDwTEplmZEmaZMbGE1YBF1GHYupnJFUonAm7Jnj
         +WLOqhFNmkkj6WTBMEr5Vdp4Fn7Mmuf24wYTtYsXjAfE/+9HvkxsoE07CQS2FdGFkSzY
         s6GQTbHQM7bxF71thXzkInvJeln2Bsz/0zHndYXbTx6V2cdJ6w/Sv/ew5PdQ5ojBgBQS
         2HQXY3DXEXjpkpLYbmZ6j9KBF7a2JY94k1hyjFyKDUt63QuK/2uelHIDBTcMpSeHPrb9
         8Qsq0lgA67Jw4osq+WDdof1oe4fc8Bd6cJsujTAdjsbYkEIo0oraUIEt2U35bS5TVW22
         Bm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868036; x=1795472836;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4vyYjn5UPo/7vDc4ZQ9k3Cq0mbqo2jzpmjoiYSVxIwk=;
        b=Men1kaQAEI9aOnJM89HesDO+l80arwqLHV8pKp8nUOzeW+jX6MDlLxTC0350ciRHv9
         mIHjt/5Ok0ET1gdtYmqTaIH/Mwsy7HQ6ewwCOISsBNcq0IOoY0cnPLuhC9hyymsWOcFh
         Xv1RSdRhioYgTONuxin1+YKcTotiHhC9RY3MHhuumWZMBwLtRdp0bMupyVlsyM42QDFo
         fBNSzIjTODTqKxIDwoDM7B5mzFQLidrjM7bj6htXQ86CBaEX6k1iA4B/OMVj6N58bTn/
         +hHRR+PZUJziE/uCaR09pbe4CVlpN49PD+21ILLXy2EHU8nupHY3kLv7D8MwG8T1hwKI
         USxQ==
X-Gm-Message-State: APuU4Z/3bF96Kk/ALTLJ4H3M4EwltqoefQFYFm8V5xGLyR/ZRngZhLa9
	sIA9BET93uvePH961PbT9FC/Lap0d8r1lE72e0tl3siVjUQsnqajKXMdiDHGyHbp9FWI2dILf5d
	i9iSK82JvN6/OC7ZU8WtNYBPwcdxjY7AMrxyxX4vFeUhxxzw0
X-Gm-Gg: AYBFou3lbaZ28mqqMNSSvp06ZCPkFXRi1I1JF5qRGBM3oNHyZW5BWTMJtGCI8LgBukz
	noc8KkH6g0bBHm76/7x4BTQwfcIAmky2+jyZmDIbZ5AoclqVX7jjnb2+nGcaF40j9x2ToOx+fKb
	ucKdzml+aIaMoN2p/VDoFqu/IwXOcYkC2Mn/HkB3M3eRh7X1RdKfibNhp0lXTw1OKIKDGbe4a0w
	y/GK2Q6ngOuVTmH+LSzFgSd9IVrJsNV7c5YlHTtLa/8qSQA/GkZIv5YBR6pGHoWD2sgXbEocue6
	16Et1yiP+j+4bfHWv8A9OmtzBsSWS/O2ENTi+cphaxWC/VUoAdv7figBLmU14UlNZb03KHr60CE
	Ywl5PacNvsN6iknqfCLC5M7vLGqKy7RdW76pFXUyEi209G1PdnlYzO9pmsOfp48TQ+06KfUOHTb
	wVA0BbtX5evwliZwiGsAbmzFRd
X-Received: by 2002:a05:622a:4188:b0:55d:34d4:12f1 with SMTP id d75a77b69052e-55d34d41f99mr93205731cf.34.1794868035991;
        Mon, 16 Nov 2026 14:27:15 -0800 (PST)
X-Received: by 2002:a05:622a:4188:b0:55d:34d4:12f1 with SMTP id d75a77b69052e-55d34d41f99mr93205151cf.34.1794868035325;
        Mon, 16 Nov 2026 14:27:15 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55c3b7a4adbsm66513611cf.19.2026.11.16.14.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:27:14 -0800 (PST)
Message-ID: <eba4fb71-6baa-455f-8899-87567af898aa@columbia.edu>
Date: Mon, 16 Nov 2026 17:27:13 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] userfaultfd: use anonymous memory for
 UFFDIO_ZEROPAGE on private file mappings
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-1-4397a0196479@columbia.edu>
 <cc865bc8-b96f-4385-97b1-976de4465ca1@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <cc865bc8-b96f-4385-97b1-976de4465ca1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: sTn_g2atD_GjGlbvW2STkv80GJdSAL_6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4OSBTYWx0ZWRfXzlH/vVsTKpgp
 79B1W+WwD96+sYysTXPvWYf+Kc1UbYRiwVyz1iq5k3EG0VnIuDCRbEYiSU72CoSYBSX5tg5IK2W
 vI5UEPovp9yTjq3ccvM+mrL2y26Poy+jN7zBhQI8IT6q9nqmVQv7
X-Proofpoint-GUID: sTn_g2atD_GjGlbvW2STkv80GJdSAL_6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4OSBTYWx0ZWRfXzoAokOwVCcOY
 hZkfZB67mD6eTU4sLN5s3Zo4vRqWQgOheOjNFZVcS5EYASleQAFKE4iqjzinsIGu5K27xeOtVtf
 Q38PaEaoHDh5Sbl3nluJbbFMJjl2PXJeUPeqIso/5QBICbgon3pENQgQs/e4kpkXzPITsXPCwT/
 fMhsyd90AsnZ0hIsYJKvGiwkLO14qT+eeBdcxeMsb6H1NHbB1gnXOGG89PVIHQb5GgJahJdGznn
 G/0GChGOp0PDDwzHs5/RZl14HOZX+JpZwT8Kqojvb+qbv2dKRNJtDrQEEvkftJA0WL0HNzm+sMO
 9hQJYTMrAorm3tMS7NTsjWtnMw9+a6ymuouOJtwOT+19QxQesGtMR4roAfaKyccuGmAi4oFDI2t
 gsbYyG5Rq4Prs/sZCoIDaE9X9F351QbJ4J8c8IXhFKuZc/Y0lps5vJ/tryGvJs3Q0QV/rNuiPaE
 jXTXZmpeWvcFefQAJuw==
X-Authority-Analysis: v=2.4 cv=NLlAaE6g c=1 sm=1 tr=0 ts=6afb8345 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=U30RilsMMHCo0eZBjZ0A:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=10 clxscore=1015 spamscore=0
 suspectscore=0 bulkscore=10 lowpriorityscore=10 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160089
X-Stat-Signature: 31ydnbmwc9mha9k6p8hij94kzyb1j5kn
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 259A51A000F
X-HE-Tag: 1794868038-136496
X-HE-Meta: U2FsdGVkX19NZKlzUdrJeE791TKYv6uxQCxARG65DDjRT9PRFXhiz6OLfRY39bbNX+W61THo7JXzNHtZUXWvY8PfdxsdQVPCPgFxxpRigPAChe8SC/OjkJfdycDN20LLV+XtJSuaLuBDsmjispLd149/8Coo6kV7w1/LyuOxLktTvbYTW+6/aY+R3CEFWTuBHwncQqGbLwEsCTnGlzgiCaaBqaGgwN6K2DQ5JROMeT/nG8R5hhSJMNL4rYWm4fxOquV+shxKV8gP582CCBfIvSZhqaB10o/xakeQl+6TKoJy/sJe/L1Q1NwNocW+ykIYP0A/t3/qH1eprcwm8irBm50gL5sofTYDOa9t8VLszKpFDH5alvBJARbYvCiA14z+IQqQi+JjO+EPucioP8wKxaNGTo8dFdw7QsRt8gkQcKHxKIOqlEZUSWHEVb3YyNydxQuV3K1NzGOBq+PPk2dOwrpuRMLSzaAUW3vJWAfrU903qZiZ9endirl5x4eHNAIpPwq9DopXilKFTPBuo50ipiJCsnijHFTONQY6O6teVw+RJpsTTU8nIDgkCULhqg2SMD4IS26dWa1IXS2btkhVy8ziPNU0YnWf8Llzha2hCYkmU1nWnxq1fSWWkU2iP5gGNt++nUQJjPJ+cyCRQjQv3h+snbQJZw14wt/VOZO82s8KcNJj3nHZkVskNlP6i0OJM+4ibFgR8AVBcQDD2hw4csS8d083HJpm+l6KQrHT/w1FLOA3GMWhHR00T7Lslip0N8uYCEgApGR0ThhceSvtHxG72ytshWO8N5rSb8R4yVJD7If+0IvULshvwESyu4j5J53ozgpxTvRLkfXwE/+ynztN9v/tVKDjucvWQsibJ9+TkecUrEX7NWC7d8M8uPjCz943rqBeRjLlJQyHp8bo257FRPI4ScPlHHeyAJYqqa/0EfHDKgR/LMNO0SOedrFnQ/Q4lywjCVhhoUd4ipk
 cARkqfQy
 Zk9G58s2l51Tap+fVLFlLMRPN+J3qVhGfXVZcNAoh/Sb8PJmTImMLQTmbBQ4ct93RcULpbNfSTVtSV4CH+pDOnHJvCa7BhZsWLc8yW8ZeWEcJN/OCChDfzJHDDBYFgMbUCByWek4bwaNiGTIQNcnwMmBJDUIMknYdPWQ4v7I17MXU5cCU4T+lcDtkmByXTYDqrqldWCwNVGRI22s7xw9RnoFivkPkROgzNWRhRFwSSmRMDtaKE0nrPsJ3DLhLlM4ZLgFSSrqo3qc6MBoF/uN8ELFuxGWrUjwoc37iwDgDvw+fnnkhpNHE0QuhQS0YUxaqgSaINZaHiEuuxnzu8HP+u8JJ0KAEGnFC5/KT/0eSF6TTusj4ThTyoKXZWDSg38uUAxMma2XbvTi8b74w7fNUBdXte29HCrdAJNUpI/kmZ/O13pJ8uBE60t/F7QqkkKQgxeo53/SxarRq2VEOFttY60ieo4ki/3yic/mFm/QC0m0Rg4i/XmysiHPylYyz8POeKKnKDA0YRTJ94f7Rbr/CEMnYWgfvYK3sDxJ8CysRbJ8p2pHFGr54AZ3ADw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 3:16 PM, David Hildenbrand (Arm) wrote:
> On 11/16/26 21:02, Tal Zussman wrote:
>> If the mm cannot map the shared zero page, UFFDIO_ZEROPAGE falls back to
>> mfill_atomic_pte_zeroed_folio(), which allocates a zeroed folio and
>> installs it through vma_uffd_ops(), no matter what kind of mapping it
>> is. An s390 KVM guest with storage keys or protected virtualization is
>> such an mm.
>> 
>> For a MAP_PRIVATE shmem mapping, that adds the zeroed folio to the page
>> cache of the file. That is wrong: a private mapping must never modify
>> the file it maps, and the file might even be mapped from a read-only fd.
>> 
>> The ioctl can also fail where it should succeed. A missing fault is only
>> delivered for a hole in the file, but UFFDIO_ZEROPAGE can be called on
>> an address that did not fault, or can race with a write to the file. If
>> the file has a page at that offset by then, inserting the zeroed folio
>> fails and the ioctl returns -EEXIST although nothing is mapped at the
>> destination address.
>> 
>> What we want is what UFFDIO_ZEROPAGE does on a private mapping when the
>> shared zero page can be used, and what UFFDIO_COPY does: only check that
>> nothing is mapped at the destination address, map zeroed memory there,
>> and leave the page cache alone. The zeroed folio path did that before it
>> was moved to vm_uffd_ops.
>> 
>> To fix it, pick the ops in the common folio path, as
>> mfill_atomic_pte_copy() did for UFFDIO_COPY: anon_uffd_ops for a private
>> mapping, the ops of the VMA otherwise. That makes
>> mfill_atomic_pte_copy() and mfill_atomic_pte_zeroed_folio() redundant,
>> so remove them and rename __mfill_atomic_pte() to
>> mfill_atomic_pte_folio().
>> 
>> UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
>> if something is already mapped at the destination address.
>> 
>> Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
>> Cc: stable@vger.kernel.org
>> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  mm/userfaultfd.c | 46 ++++++++++++++++------------------------------
>>  1 file changed, 16 insertions(+), 30 deletions(-)
>> 
>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>> index d65184d9a480..61a712e1f9f5 100644
>> --- a/mm/userfaultfd.c
>> +++ b/mm/userfaultfd.c
>> @@ -531,15 +531,27 @@ static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
>>  	return 0;
>>  }
>>  
>> -static int __mfill_atomic_pte(struct mfill_state *state,
>> -			      const struct vm_uffd_ops *ops)
>> +static int mfill_atomic_pte_folio(struct mfill_state *state)
>>  {
>> +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>>  	unsigned long dst_addr = state->dst_addr;
>>  	unsigned long src_addr = state->src_addr;
>>  	uffd_flags_t flags = state->flags;
>>  	struct folio *folio;
>>  	int ret;
>>  
>> +	/*
>> +	 * The normal page fault path for a MAP_PRIVATE mapping in a
>> +	 * file-backed VMA will invoke the fault, fill the hole in the file and
>> +	 * COW it right away. The result generates plain anonymous memory.
>> +	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
>> +	 * generate anonymous memory directly without actually filling the
>> +	 * hole. For the MAP_PRIVATE case the robustness check only happens in
>> +	 * the pagetable (to verify it's still none) and not in the page cache.
>> +	 */
>> +	if (!(state->vma->vm_flags & VM_SHARED))
>> +		ops = &anon_uffd_ops;
> 
> Oh, but one comment: why not check for actual cow mappings?
> 
> 	vma_is_cow_mapping()
> 
> is your friend :)
> 

Probably because I didn't know about it :)

This is already equivalent since uffd registration rejects VMAs without
VM_MAYWRITE, but I can switch it over for consistency.

> -- 
> Cheers,
> 
> David
> 


