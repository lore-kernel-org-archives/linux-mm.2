Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85751CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86C96B008A; Tue, 19 May 2026 17:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37E26B008C; Tue, 19 May 2026 17:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D273B6B0092; Tue, 19 May 2026 17:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C212A6B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:34:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F9D8140B7B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:34:39 +0000 (UTC)
X-FDA: 84785473878.06.2A2C03B
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id BA81440004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:34:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=FPDGbx0T;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VI5bNerb;
	spf=pass (imf12.hostedemail.com: domain of georgi.djakov@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=georgi.djakov@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779226477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDn4qGggayMUbM2m3q+lfb9GiCRfeMM4D3/Bti+Y/68=;
	b=hFffTWYPPwTaN6T383BVBNfeXWyqlYVLXRc3o7igb06TUmidBRwbtIR44TY3DSA/Af5R/t
	mUZDDD6DtqOMTxujGA6DmHuNmzlL+G3HvxpGYlLlloFu+Inp0mQByaJj7gtyr0oSg7jeSm
	mJirmE1tgJ/OdIEE7bcDjRnNgaenvw0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=FPDGbx0T;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VI5bNerb;
	spf=pass (imf12.hostedemail.com: domain of georgi.djakov@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=georgi.djakov@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779226477; a=rsa-sha256;
	cv=none;
	b=jpprtsM9v5g1iAehPr8/JCTMiPfCkuW1F11Ooa1IUDeBegt9YreactWiDsDfNF3nd3u4+5
	trb1e/fMDJzyKGEb4iZJUX11TyvHZe5sBUf0JJLO5l696X+ibK70JaDtUzw2cw5FAYfiKs
	1nAXkki4QkJAApQHj/y2BrS9Wz/8u/A=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64JEx4ue2867829
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VDn4qGggayMUbM2m3q+lfb9GiCRfeMM4D3/Bti+Y/68=; b=FPDGbx0TuXRy5ByC
	aCnLH69AqWtqKU0ZeYV2Mz1Ff+ymL1ypchmygcp/NXSBhhcbVOHDdrujTXkaTnQu
	QTG27uEWjq/j0GPled3OiBWUk3Mff18opD4MMsyt3p7wE4mdv/fEDGSjXYmMKM11
	KZKZVgGDN6N2+N5Qw0Rlv/RlU3YNXN2FAXZWC2CV6oAGgUM8jljG9qUM3QPouv+9
	a3OslV8v0u6xIs12ZxpO4AlGGc9iCySIeDXMLWU6N7h4R8Ja1E8+koWYHIwqqTH7
	7x9wOHwSA/VAxMC0UbejwlQ3wEeNs7v2Y7dEmIFzVEpzsPwr6woMSVr6k44gd3e/
	zHyBLg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e8t3w9kdh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:34:35 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2efc342ef15so5468359eec.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 14:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779226474; x=1779831274; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VDn4qGggayMUbM2m3q+lfb9GiCRfeMM4D3/Bti+Y/68=;
        b=VI5bNerb9ON5wrRPCyI57IHyN6z4dWTWXqwzJdgcx//CVh5VUVuO9gmxltRS2sVWaE
         dllYOZFj/+RQ6kMcojbxj2yrTMahhbA6/l+3yenWuK1KRrXis3Taz/Pt6jrajtR0ZosH
         keqke2IRHQNWq9NWVjmnYd0vDoNFluhnxsbiAY7B+ptvya3ROgR7IJSRLrsSahoSQ1m2
         6gKoB3ucKBm55/yYE87OZLyXKwuRwtLabufCywBvs9DcKyatUYBa1UXNVHgerCNGo8uy
         wmnhaW0bfJX9uLl2RXLJrHamiSoQjer5On7b3Mrt4NuzjPfuz6Gd7SNgPnBN+Xxyp+4d
         jFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779226474; x=1779831274;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VDn4qGggayMUbM2m3q+lfb9GiCRfeMM4D3/Bti+Y/68=;
        b=J3pyqbhB+D9EvIgV03VzXR9/nv1CW1XdXUKs5tfEXOge7dS/FGOiyUfxt1zJuI2lZQ
         lXoILAQjR/rKYjpBefLuvs+6VtPv4SIrLbWR4KQEZQXbFzM9OwV+9oA7utQOfsM6bxnj
         6QyLBMhHmgKdga+cbFWETl8J+CpujNoTL8EEDHpYXPd/936oX4w6F9sARev//RAG8ord
         HL4q/fobhE71IJPneLuyXVm9hgKmhQzK2E1o6hS/oLKN7Y9Kp/k6rT16+nOZLHzAi6hg
         6r+3SydN31G6HYI+uwhUmLTObiQ0gouBxEmVf3DB3hfi/JIc9+fqO0w0CPs/DjUDnqcV
         OLEg==
X-Forwarded-Encrypted: i=1; AFNElJ99Vt2vsy0t+odPslxGYeT0UWGx8t4OpuUjTT6EJvPLamIN+FsmNl2vYLo/IBgg/CqpZhe+TAZMsQ==@kvack.org
X-Gm-Message-State: AOJu0YxlYHrPbiXX966pUvzzTJtwRa6+4/UfGRkKnJmLY6/o7MaSpLEU
	t8QPCNB8prso82F907p7uOGXpKERYf+pOgFdf1Em8bziXiSQwKprVvlxbwOjuULx75Q4M9++dvE
	eS7jiva2WmbHL1QiLcNGm9o9i/VYTk3P35Qlj4Py8ZZK/nM1LSMh+nw==
X-Gm-Gg: Acq92OEFszEdZS+LxVoDTVwRu9qmawRYWmtQ3C1kaP9ZhkfzrWdP8fcz+Zo6p+VCJBi
	Ifplw26eHeNYOLkU6Yejd/+huE3YuKYQnMTtPzSJ5XqDfuDeiGaCcI2fAbf5WHh9ciyHH3RwpCQ
	bF5vPJxK4y9yGbopbhOuEMmWgU5BNHm0w0RgQ8+erOYBT4+PlNIKNxQA7SFsVtOOW7CxQvjanwu
	19hGbwHETCIOvZqXq3p3ZiXu/WsIaCp/yV6nc51II+W3fJIuhrVSnD3ZbioU9F1yQoeIX/shRMN
	4+Gdhjw1vTDnMUdfniMlCfw2vj3dK2AZ6AWDupZ1f820lB0N8+9saLUZPgOOz4kjeQo78qOKVf+
	XooHPLX27T7vABiboyrUFXa4iY4I5lnpAsGsspBRwhbcwxrP2mBww
X-Received: by 2002:a05:7301:19ae:b0:304:13f3:e461 with SMTP id 5a478bee46e88-30413f4159bmr584063eec.3.1779226474496;
        Tue, 19 May 2026 14:34:34 -0700 (PDT)
X-Received: by 2002:a05:7301:19ae:b0:304:13f3:e461 with SMTP id 5a478bee46e88-30413f4159bmr584047eec.3.1779226473901;
        Tue, 19 May 2026 14:34:33 -0700 (PDT)
Received: from [192.168.0.31] ([212.5.153.243])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302973bc9d4sm16873423eec.23.2026.05.19.14.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 14:34:33 -0700 (PDT)
Message-ID: <35028dcc-3bb1-4e76-b471-183f319a7f46@oss.qualcomm.com>
Date: Wed, 20 May 2026 00:34:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/6] mm/memory_hotplug: Fix incorrect altmap passing in
 error path
To: Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
        joao.m.martins@oracle.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
 <20260428081855.1249045-3-songmuchun@bytedance.com>
Content-Language: en-US
From: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
In-Reply-To: <20260428081855.1249045-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDIxNCBTYWx0ZWRfX6ri6yzCbWnRv
 dR8zC0pXJeDPUlYMhFgKNjlxtSBU5ElQTeCD4yqx1O9c5c626qN6CwGSahJO8xbjw4gFYmetmom
 Kh9QGi9hN2q0TC/odxCjBEqfUGRzyXqWt0QVOrJXKf2q3+vCsFyKazk9/fi4nwcVtRmRdYggpY1
 e3gy6wwIrw3APEXWwzQhv/ih5g4qHDsLgCf5CkxmOYiOh+wCrZ5uSDLlawTUs+j5cR+U7a9jjWm
 Q5Cznjo4QmFCecaCbnzTSUFUX6Qo8kmP8sBBdEEfaOUEG8FQp6vKR2sDxZhdKAWrZf+k/boI9Cl
 RN95L3isPqHuzpK9xHtr9t6/W3mV6MVVNv8Cjsc33C1HTlD1cJT68P5b2RyyEFyd8KaGgYJs5q2
 EAqdtwN1NyZb0abtAwNQ2Ho8qrs1ijheMEQCx++0qnflaR+CtNy7yZ9nDlz67DC4E7o5xE9teAF
 mPrqmvm3Eefu7pLY63w==
X-Authority-Analysis: v=2.4 cv=Q/viJY2a c=1 sm=1 tr=0 ts=6a0cd76b cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=douLNevBrtimd63D7eljNA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8 a=EUspDBNiAAAA:8 a=cJIYO2twRcDUUobFbVwA:9
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: 0jPE-1TWGX4sCt5x0cOfnkbHKHvXW4Vy
X-Proofpoint-ORIG-GUID: 0jPE-1TWGX4sCt5x0cOfnkbHKHvXW4Vy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_05,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190214
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA81440004
X-Stat-Signature: mw6ozdptuqugdxmifg3fe8g9996ydgzc
X-HE-Tag: 1779226476-192028
X-HE-Meta: U2FsdGVkX1/i3DMMtH/gOgtXjiI8KrqQSIYaw8SRxhmPZg4dfT12wcdRA1+R5IO0cX5cMDFx+3AzcnU2/abACFLHtR3t7JmyGjeg2Ci/3uOSB+AR7lMeQt6bXtmSd1eKHunsegOjSKqFzsplXlFh5bpyoud03FAkjBS3fDhrtlmPQ5hL5X82wzA2zuOAfSlrl90CWCzSQ/TywNKNOIhQ2lfDnie3n69SfZNyJXV/rH/e6NHjtoGB4VBrwPmQM0sJzwzqFLu33ToiHgbHjKGeQyQZpRsO1ME3xQ8DDLrBX49Aub1qoRk+fez8ZD5J8YkULhQTNCDMEW90D8fxUFIMAvBSKJdc+mKLLc9bmKhH+0jH9GicBnUbzfLJrrmB6QI/+1c6EMgTy2VDcrsmn1wQWINx7jJ284au/oqZih04GdH6Cw/ALm7pDxXJ/uBBG/YAmIas2mBxO9Cuw/rfRElkXrCD27U2BTwIcTO7Twp9unGUJxUoyWZglhiRDiJiFiw8V9bxOkefw4W17ZymOP0m6ODAWj7ApXy1YQv6PybV3uVhQ+Eic6QNoAhwWcfg9xkFJTvFwXBxB6Du5p0upmIBVUi/GrQvD10kQXqB6hIiqwoh0XVK4jEgqpm5ee2PHRUFPHHu5jFuHQieRWELy8hjXX9Lg+4Pi3bLcH128yzbCxaPqZt0H57TdJDEP/1dIW1M8hE64ivSjFprWtIJO0ZBqMR1DpeR5f9hLsqGJNQn5yIcTV200L8iJDd5eYn3aGdgoAe0+dXpKTKISAwmnYJIIe5fRIf92h8Mt1U56YyCqHG0B6rdLd9O8JP4ZR8IAQKYUSg9oYarMyRJONNlpz4daWapM5RiSd7i44cqzXha9DNPfu1IgLz/xX6UuHl0oLrQmWwnzy++sQ79Bqw+P3AbXSAwBTpZqx15VgY5ID+Q/LHTvsCyKVgiM2f/L1mBtG0k8vVh+dQ/GIx97tX3IAU
 81wNWd97
 NNsIvo3vLjMIA51/tuGevYyF3n+C6Vzo4tVxQ+n5PsGr/+iCZcwSDUY2hijSlM4Z2of7e9trUBE3M3hoQH3WrMR68Bj87QwjjtB8okkGDvpqrQe1hbdKvgzNKERH6likDAl4bwcOIeYRL8HEG6IASqb+RkzB+nfnv310WKaocKXJ69mNLhHJn6TssE7CgikOWH8B3zRBfVDwOknDDwdVW3rYSuMD18fau/lviEoOTx814hxVSVxGYs6oHbTgVQhnB+hZjNiqKeBI7GHg9As9Hb9rzVTo5RKExjKLV7RgPmosrY1GLpSHTyHs4UKmbkfzyp80Fz22oZit3RY6xTp7vCam4yDXsbuWAUEtsQGPsavygSkYyh0xC6NQTp4iV8MOpePqIuQN1LPe6kBAlOkfV5lO5/liS6rRFaiX4O+XooVEQBBuIl+DPfysZQfA/bBeT+5yQ6Qjiz0F36uxT8E3Uk5pw7F9i18xPxlkHVYfdQxyrUsVHOoXH1JAS3j81rvzR/KNFA1uh1XfUzOg/MyV0ztiztaCxS18T3LqIlvL0epUCx7y2JViEWMdUEuh+rvzLCLxAtO6vlS/d5A4LrFECc1EACKDBXWihPuWpWu3zen3REW1CWWss3bmJtQz694sKzvgzQJfZQWSzMAbq8LqFnE0E3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/2026 11:18 AM, Muchun Song wrote:
> In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
> with memmap_on_memory enabled, the vmemmap pages are allocated from
> params.altmap. If create_memory_block_devices() subsequently fails, the
> error path calls arch_remove_memory() with a NULL altmap instead of
> params.altmap.
> 
> This is a bug that could lead to memory corruption. Since altmap is
> NULL, vmemmap_free() falls back to freeing the vmemmap pages into the
> system buddy allocator via free_pages() instead of the altmap.
> arch_remove_memory() then immediately destroys the physical linear
> mapping for this memory. This injects unowned pages into the buddy
> allocator, causing machine checks or memory corruption if the system
> later attempts to allocate and use those freed pages.
> 
> Fix this by passing params.altmap to arch_remove_memory() in the error
> path.
> 
> Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>

> ---
>  mm/memory_hotplug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 4426abb05655..e3352284f635 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1469,7 +1469,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>  		ret = create_memory_block_devices(cur_start, memblock_size, nid,
>  						  params.altmap, group);
>  		if (ret) {
> -			arch_remove_memory(cur_start, memblock_size, NULL);
> +			arch_remove_memory(cur_start, memblock_size, params.altmap);
>  			kfree(params.altmap);
>  			goto out;
>  		}


