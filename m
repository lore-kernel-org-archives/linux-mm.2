Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4940CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37066B00F0; Mon, 29 Jun 2026 14:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE68E6B00F1; Mon, 29 Jun 2026 14:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD816B00F2; Mon, 29 Jun 2026 14:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC64E6B00F0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:48:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A81A12025A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:48:09 +0000 (UTC)
X-FDA: 84933835098.29.4BCA85C
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf26.hostedemail.com (Postfix) with ESMTP id 067D6140009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:48:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b="hr/8LVFX";
	spf=pass (imf26.hostedemail.com: domain of steve.wahl@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=steve.wahl@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782758886;
	b=x885J9S16G5Q7IndhQxtp0vQklPwguoI+4uLhdOHeAPB/8J7Awg/SgpZviOQNn81I2iX6+
	RLZz2Nkn9xvqdDPwsBik3A06CCKFZdBeF1ZJ+s+m+6NvahGZmcOMqmebMVOz3QEAq4E/+m
	R1RJyT/HbmJZLNEskwjBgloj4G0wOBU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782758886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6grvcm5OGpU1yotvwOUMnvDfjQUFC5kGrd/zcVEo6w=;
	b=aVJVOcJy2lVbNZG+bCmUNJgMJlpAWDwS/TB02i8XuxJpjeA7HvJ85ZabF9OG+3rCCs/zv/
	lGQX3twaxt0/1UczgXZQpQEL6mzwLZpUtSUk3uVc0NK7Bnnps6oTND8FavUxbi0CEniAaU
	smpzYyDJCTfgbWnqPff1SUzcAZ9au6A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b="hr/8LVFX";
	spf=pass (imf26.hostedemail.com: domain of steve.wahl@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=steve.wahl@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65TGOQkG4133301;
	Mon, 29 Jun 2026 18:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=b6grvcm5OGpU1yotvwOUMnvDfj
	QUFC5kGrd/zcVEo6w=; b=hr/8LVFXPUgVv1E5w7E72LHD1lUZpnGwKxOD/qMd7d
	mhLsua0tMqEjK5DVhygd5w9nR4Ro+T3TU5xRbULJbfgaopuEuvKY0uB1mdYLscQy
	4r34dGwkUqAkdX5/qg1j8EZpTLcdSNCeXu199aZuZDThMRKKXVJIwJ7QnQb7w8Fk
	3A1sff0bwnEHGuJwSyUHMtseQ/7CPSb7/LKox+aaZf4gN3QLlSCZ3IWCSGd4cJ8b
	wdEhR/YF+CjHwf76fQFu7cvnaaswaDJRWeOnKIabijExIU+69KQXfB83rpmC+wNg
	UfboKobtHnL2BmMkp3aGn0KyC96ivmMkvDDVb5BDnfEQ==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4f3tcw4uj1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Jun 2026 18:47:31 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id AFFFB8005EB;
	Mon, 29 Jun 2026 18:47:28 +0000 (UTC)
Received: from ilogsc-qemu.local (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id D3553800DBB;
	Mon, 29 Jun 2026 18:47:21 +0000 (UTC)
Date: Mon, 29 Jun 2026 13:47:19 -0500
From: Steve Wahl <steve.wahl@hpe.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Harry Yoo (Oracle)" <harry@kernel.org>,
        Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Robin Holt <robinmholt@gmail.com>,
        Steve Wahl <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 11/16] sgi-xp: Use higher-level allocator API
Message-ID: <akK9tyvmlxteOIEE@ilogsc-qemu.local>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-11-57bef0eadbc2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629-alloc-trylock-v3-11-57bef0eadbc2@google.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDE1NyBTYWx0ZWRfX4oaEEQu+svmh
 0jQDLkECSkLwUn9O+GVSj9ncpGy0ldhn9YZNf7JNtMco1kMowk9dekwegGksnr1GOVydqunPA+W
 896kaunTIng1vV7ykQtNfH628d+QAoU=
X-Proofpoint-GUID: DIIV3Dhu-pescEAUPkMHsSecUf7k0d_D
X-Proofpoint-ORIG-GUID: DIIV3Dhu-pescEAUPkMHsSecUf7k0d_D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDE1NyBTYWx0ZWRfX79YLrz1gyDlD
 uC0D9FOuiDClqFB7aXc9EGCr21byWM+1L9a6GCi2dcRjXPZbQDqg0ch3QKWHUg7rbMXUAE+KD67
 R7tbqZQBCPqGCfw9T9flkIvSuemRunrcIHAmfompNuuxmvF6m5e1QJkdKGzrJqXUOQdjYeJJKte
 AzqVAxLxCS+EnQLh56QT86ctyRUwmVNyuPzDD7XQheODs3u5SxwmgqzLjuaj/+gti852ws1S4Zz
 cLIChd3Q6MLUGO7iCVVMHpT1MiDIQu+O4Tb05RfaW1gNYADcIGr/pB+/7YaT8+FdtTW59/499CA
 JXmrozO1CoHBmL03re8aEtG/S6a7J6DJEF8758+eLH+rFJEmWUXRAPT7KBFi+h9jwNlM2zaCiAU
 /G4KWigHXXH/KyWENqbXoT1MYtds8YXfZt8ovEgY5HWnIatXZQB/EAGoZx23a0UCke0TDcfbVZ2
 OvtaOWQiYvlJtyjZfoQ==
X-Authority-Analysis: v=2.4 cv=f6t4wuyM c=1 sm=1 tr=0 ts=6a42bdc3 cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=_ZmgHqWwjZUDpi_pur5s:22 a=MvuuwTCpAAAA:8
 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=1XWaLZrsAAAA:8 a=g10eFjkI4RNaiMiBvy0A:9
 a=CjuIK1q_8ugA:10 a=Yupwre4RP9_Eg_Bd0iYG:22
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_04,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1011 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290157
X-Rspam-User: 
X-Stat-Signature: n3se5cr1xwaemypma6urqyousk7p5nuu
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 067D6140009
X-HE-Tag: 1782758885-939191
X-HE-Meta: U2FsdGVkX183H8Djm3XsygfdrKUIBOC7F/bGw1eNbpLAQISUFDDHKtMx2ac9Et9qv6sSX7PlgegNQfs8oePoHS85D8HXcGtAc0+hNB/7hf5j9YjGq2I5Py0vCdgG1iy0Z5/fGNBC0RoAK9Y6n8LXbyWj3f50u4evLxkkgmP910Trml6cQJZA3dJBw9N2idCRRdK4OHcFizyzW5hqNsLBVyYi/Y+I1u6G9Mwsz/6/0uay3SzjTm/h1dYbOZupzqJ8qhxFhFtEJT+0bSGHwPt91ZyfQTwywUOZ37dOgERFRwfjr/sAYXUfyovFzI87qAIG1sotVLjsmqKoiWlm0xmp/OLqb28+TsWULT4otWmoeLDap/rBnteg4NY9jS4aUSmHZXITIuFNpgyyoC9PUNfmOGCDZGDd1OmOmETC4giTMfaoZCt10JOxI+c8SvslbRGOoqSfqaLK4wiNichxP4zc3hbBHD1H6z7yxquklkOcdd3P0FxlHgvZutzeveeRjuFIdLo4CjPPa163ohAQ8BI23Xt0vYG1F57x3gvai3XpXOGMzgN2p+Lr/gXgkJcIRFhiyc61vW2XgSRsMAUqBbWdt48KtVxcSV4roIZHqLc0PZllv0b/cbmVkEO4lDPRoxhWRgH42ppRWIWjFB7VdwM+qs1CV/A5ZqLeF3fY4Oz2C2ww2BD0pgyL6ykRfW49Ky+PvjsGtEbmsBxutghFHKJF3guCE/X9VCjwneFcwG2fecMjT3viFmyk19EMiBB/EV7bodFBMgKE9R1E/zxC6p8ysO/L14cmy9EIal/4rKc3kr+aGECJaEotYeUTe3bQtkgknB5Uz5C2M2Z6v3n48/tlfzNlOkStbdujMsXYQT/qBgr+9pIs5vDJ9qC1/OVYiA8aOTofPVcBSKyKNvlgUe5PVOx3aEbLeNrJ9/qVKkHwjxNSoETc3Ym+mqZJRq2N9iTD75kkAi4hB0Mn68tjJaR
 wvVtRxR3
 014RtIp0bz70/V6REf+NK5p4ENAJLwpakGYa3Gf7oeAMg9ayK+pqTKw4Zb7g0sHfYUZKduOQZCIEVoTKPayMNcWyhi8019irmCa2tgmXV/dl7X4sXPtRkz3hYNBpgsiiIlFwXl7Db/iTa1jN722lq1eTmX25NddJc5tsMdvsVptedKPwkuV5b5pqvAvz6NNWKLSWSTOhEQEbtXCm5HjjmUEmydVfndPvOS2wDH8x6Yc7OT8O2pnu+3s8mOUCWSBQgATESeB17/2fabbR9tredOrNuKabX/3edO/SSLlTjriFGIsKHrNpoiXfgCvQecPRrkT7AKQRYxmE2MSpXG7ScoVhqa6Z3Ldgdf8XvobTRvDRqMthxeRah00wbS3lk8dr8t0MJLtGM5KUrzEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Steve Wahl <steve.wahl@hpe.com>

On Mon, Jun 29, 2026 at 01:12:00PM +0000, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
> 
> The former is going away and the latter works fine here so switch over.
> 
> No functional change intended.
> 
> Cc: Robin Holt <robinmholt@gmail.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Assisted-by: Gemini:unknown-model
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  drivers/misc/sgi-xp/xpc_uv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
> index 772c787268932..aacff70204241 100644
> --- a/drivers/misc/sgi-xp/xpc_uv.c
> +++ b/drivers/misc/sgi-xp/xpc_uv.c
> @@ -170,7 +170,7 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, char *irq_name,
>  	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
>  
>  	nid = cpu_to_node(cpu);
> -	page = __alloc_pages_node(nid,
> +	page = alloc_pages_node(nid,
>  				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
>  				      pg_order);
>  	if (page == NULL) {
> 
> -- 
> 2.54.0
> 

-- 
Steve Wahl, Hewlett Packard Enterprise

