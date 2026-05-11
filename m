Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74788CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0776B0105; Mon, 11 May 2026 05:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C919B6B0107; Mon, 11 May 2026 05:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7736B0108; Mon, 11 May 2026 05:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC25F6B0105
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:12:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 485D740688
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:12:51 +0000 (UTC)
X-FDA: 84754574142.04.C1B6CEE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id E10684000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:12:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Dhd0esCf;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Zcp0kWb+Anwe2WoWtnjD3EG2vBXgnnNuj3KIcfeAAM=;
	b=W2BRzYs0W3LN8/zJTesRNdMOSmAkwtkkqnZZUEs5pk27FHIPHV2+wT2bdcqEwao5PuHN2K
	CScVF4JSNPMO78wlFUaGxy6noWZus9rDWpWzF+x4y73X6J24LKIXuuIWl3LFiPViZyh6IJ
	k+mW3z48VpipO1sVM21/kB2TxYJwSPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490769; a=rsa-sha256;
	cv=none;
	b=GbUbZ2PLLHpIyocV2Ac+mrHTsCXSNRNWSPcJNjHWr0GBzxYP9zy2uyubUgJDSmJN5+Xu5x
	3fWE8wOOk5d8UcCIvo78RIYSYFRJJR3TmUjqO1Ougazh36qp3swZTpBVpsBLz6jHN10nzl
	WddVPGGEELsywSYT71uZgUpI0vROoGw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Dhd0esCf;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64B5J9RQ2454484;
	Mon, 11 May 2026 09:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7Zcp0k
	Wb+Anwe2WoWtnjD3EG2vBXgnnNuj3KIcfeAAM=; b=Dhd0esCf1iXuiU/vzkh1iY
	sm9iZRZm5mb83web4eqRkiZES1bqScKUuBM7huhXAaNpyQHmzFsy9pP15mV7c1XA
	yLFU7zv/HoO7sYheoXuqwV+8iM/hFFKVh+nsWLebceVlS4U06QUVIJNIvt8kATp6
	gvFiQf2uTE8GP0NUbQ+PMnDfyZUzwbJYe2T5OFux1SXNAtEXX+st5VQjaBq9iBf2
	1fkCq1HauNrmCRjhCCiB91eJ9v8rhIuTFt+8y+mennvxGj56tioGjE8NQjYcVETF
	F/h0DLBJvYVKeAXUChxFdpnr2d+T478v12kk56HkbZdc5L0hgT4UnAJkDlXaj4mQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e1ubdq34c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 09:12:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64B8sPXF016793;
	Mon, 11 May 2026 09:12:31 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e2f8q4pdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 09:12:31 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64B9CUWC33620644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 09:12:30 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E585958067;
	Mon, 11 May 2026 09:12:29 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65B0258065;
	Mon, 11 May 2026 09:12:27 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 May 2026 09:12:27 +0000 (GMT)
Message-ID: <67f5b175-7a9e-4693-95ce-84d4b42e6b45@linux.ibm.com>
Date: Mon, 11 May 2026 14:42:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: Factor out altmap freeing checks
To: Muchun Song <songmuchun@bytedance.com>,
        David Hildenbrand <david@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: muchun.song@linux.dev, linux-cxl@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260511084307.1827127-1-songmuchun@bytedance.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260511084307.1827127-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BezoFLt2 c=1 sm=1 tr=0 ts=6a019d7f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=968KyxNXAAAA:8 a=VnNF1IyMAAAA:8 a=Uail7pCi9VyjTqRTir0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: fdcB4qRrTqLF4DtyW6B9LVSZHJfAxZTf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDEwMCBTYWx0ZWRfX2eRwCj+7uMQ5
 v4MWT3UjCyTxnkpX5VQqYC2W6PoVj8rr4nO4raC+au2LCS/78p8LRvXsy4BK9Sdc8H/230Vpclh
 KAnCZ0CVm9NsfgE3+r/amdhaFDcyepqwKORgXidpkRIHcQiyDvoj8xvaXKDtdLAqz87/O/1n3pF
 Yq2HiZSPwcOtya14p4K1r/8qgWsKtHLbm+RpHUVJVPPHFYdHy98eVm0izUj1iIA89F+8sOFObPT
 lDRgAM09w4ZEc+/PrBRMk9EY3jrBn0tJk4jlzwtb+SZViMiRU6L3pG6AGXDbbTHYYNzqkWtFW88
 fZyKrTAnBt8KBmM7E1JaflYz6e13NmJcceRviG6KAI3ZTE7JZQz+I76i/iTxztMARb5oCeWuspC
 tShFtx6ep4nFPs5m+6iO4X8hao4qLdYlPJzW+b6o6joqBgpMOqSw2CBcO4JmtLNdNFwmfYnNgnd
 YAqBu8qeBZ+H+LZ9fKw==
X-Proofpoint-ORIG-GUID: fdcB4qRrTqLF4DtyW6B9LVSZHJfAxZTf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605110100
X-Rspam-User: 
X-Rspamd-Queue-Id: E10684000D
X-Rspamd-Server: rspam04
X-Stat-Signature: jrw3ri98jpgcz756qq6ozhki9ozf5qah
X-HE-Tag: 1778490768-267873
X-HE-Meta: U2FsdGVkX18mdkLz1TNCP6cjgesY0ZUkF1a0LKO7lYuVwfnYxaEZK4pV2PeLSbnHHrT6x1Iu7xw3zqkj0iZ8XDfYDwoFHy/zxv5vK1GjjQUNIxZh5bP5k2CEuZMroZfK2SAAUDUTdGVyoQx0LS22wv/eYTVs9lg+CvWwunRSQ+JUvG8IIBSvZ+bE8oocmRzHaIvAjmVyKs7oPmX/a7njnx3kVtdOFlNSg7VSYA6IkUskpwHfN0ke4i+ODReWTUkb3Ul72np5g29Ylqsha9E+BpnY5ypFe+wr9JLVPb/4B6m08lc01mO4H+6MNnYI6Jk7HvTL2OiEPjf/oO7iKRzRW0kzs0h065lzpP3RyNWG8nNq0t4Pu5Yr8zNLDDKL/Q8MERlL6mFPYBpMmgl4k7Wmydr/wYjZUDF1MzWq3+sfDrL9J+oY/UPEpFNLDG7wzqhNc9J2Ons873qUxJwN7gQeDX1I4l57rowllQmXpdLxhX8JjPOvtGX+9pnnL+DorDmOWB9nwMglEGmVRXls1jIBRA4hJsh1Am8Kt5AI/xrSv75vH2eyodxJUlLpgb/iYCUYnURx7jsj1o/cjWFx5Wbpe6HA36ITmM2WBif7auO5EA2BMFUT8V1NVCzXh4wosjKUcS9wVaBuqHM3CfKr2CEWtVnevPDur3X6zlq3luzY3Olbyy5IF63Ot70vpXYtQbZJ+hKqY1awS3YdFE+jwfvq/FuWAzalPGtsF5ljaKxE7KsX8Ieg+lgY9N4QerPZccGFINH1ZxZm/zknpHJ9sVa3xZgm+P4vA9kobuGnAUClWZPC5Gv8A9sVsdIcCZ66KaYAxtlB34ejinbdHX7y0Yf5MCxCJXJPlm73h2RE0oGr86PKCfwBqbXDdVK2378SHS4kdNzLITJO8y0vYm+nZjYsWS85iEvehLQ7asQECFuPOHluGRYqBi8GT6DRVHXGkCzZ3j7pZqmL9zE/xK4khEo
 ZXHlH4bN
 SST+8FmILBdmF5sMsE8avQaYsv1PQ5dtQW8X2KvgnuqooCD4lwas/7u/P8vovQT8CRx5Ezu//c2NFVVqlg8GT4QuCNHPUFv08acbEK6X5FhqVNPq62BL35FEgls8Hhn3kQNTpY4Le6U1ZCoO2v6Re63y2WpZtvJQPCumbbLTDDrZGtLq681IxlduXX1EXgS8HInt7413teVIMmJZD5ke5vPg1oL+MjK/gCJVjnAHF7aIOUrgeVBSC+XdnfI2Cji/1tBU+RekOEGrzrUgWhrJdGdmfgrzpRUWUIsQFdi6DgsPnR4ebowdutr5mIPhXGU5wtuFwUgkBAJJd8HVTY33n7bWfZLiIEDGBG8SENuzILiLIGMyYG5Uhsvm5TcP/Z5PlaVjRJUbl3YsZq54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/11/26 2:13 PM, Muchun Song wrote:
> Use a small helper to centralize altmap freeing after verifying that all
> vmemmap pages were released. This keeps the check consistent between the
> normal teardown path and the memory hotplug error paths.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>


looks good to me.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>

-Donet

> ---
>   mm/memory_hotplug.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 462d8dcd636d..af5489f03771 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1403,6 +1403,12 @@ bool mhp_supports_memmap_on_memory(void)
>   }
>   EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>   
> +static void altmap_free(struct vmem_altmap *altmap)
> +{
> +	WARN_ONCE(altmap->alloc, "Altmap not fully unmapped");
> +	kfree(altmap);
> +}
> +
>   static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
>   {
>   	unsigned long memblock_size = memory_block_size_bytes();
> @@ -1427,12 +1433,8 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
>   		put_device(&mem->dev);
>   
>   		remove_memory_block_devices(cur_start, memblock_size);
> -
>   		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
> -
> -		/* Verify that all vmemmap pages have actually been freed. */
> -		WARN(altmap->alloc, "Altmap not fully unmapped");
> -		kfree(altmap);
> +		altmap_free(altmap);
>   	}
>   }
>   
> @@ -1463,7 +1465,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>   		/* call arch's memory hotadd */
>   		ret = arch_add_memory(nid, cur_start, memblock_size, &params);
>   		if (ret < 0) {
> -			kfree(params.altmap);
> +			altmap_free(params.altmap);
>   			goto out;
>   		}
>   
> @@ -1472,7 +1474,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>   						  params.altmap, group);
>   		if (ret) {
>   			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
> -			kfree(params.altmap);
> +			altmap_free(params.altmap);
>   			goto out;
>   		}
>   	}
>
> base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83

