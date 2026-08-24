Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AEC4C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D845D6B0092; Mon, 24 Aug 2026 13:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BA66B0095; Mon, 24 Aug 2026 13:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C715E6B0096; Mon, 24 Aug 2026 13:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DEBB6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:54:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CCD74019E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:54:39 +0000 (UTC)
X-FDA: 85136913078.10.9779738
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB80640008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:54:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=WeNJTZOv;
	spf=pass (imf17.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787594076;
	b=4+bHjoqrI73ARRX/zbX9y/f/jQ+XixmOdvhVfSIir6EyvKHL3kRjnGMm+8w99J8z+ez4XQ
	FG0s8oOqIeJ0G+6UBwbJOtlEp6nwX43t/koVYDgzmSbXBFAcxclSYCtWNIEvRyyEUi+1OS
	XtYjFofWujtBCUG8VEaPfRkLL6Jr1T4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=WeNJTZOv;
	spf=pass (imf17.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787594076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5b7yviA6r+Y09SUjhMLTI6yOv0OMuFn68Auvoc5NDU=;
	b=BojhANNMRxDEQ51Ps5pCiZQ1YOAUlXX1sNSuB7GFxLoPnQP3lvYiQpSE8OULRUrxZeCbV0
	VlShcySDDKIr5gAJjNpWAxzf30L4ZuCQr7egFM7e5NPFckXXzMW3oSsmpb5Zp8LICFnUht
	bDx9ooPekHWjaQiyKsMWAdGi05s1fs8=
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67OFljUx513353;
	Mon, 24 Aug 2026 17:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=R5b7yviA6r+Y09SUjhMLTI6yOv
	0OMuFn68Auvoc5NDU=; b=WeNJTZOvLIQHWi9bOY1KJwCUokZavfPUnNo7tN0fa1
	r39r+POtELXp710qdgPNoBhW4mLfd5iLtjwfaWcPsvrV1Lmga3uJkH3iirt0Ho0g
	hUqmWp6OdcNDpc/y8gSJnm5pS1Z9+TbIBz1bHomGE6CnA4/3z08c1TRffAq03rR4
	pKM6rJ1UUb8XFuJMXq6OtNvTjVG3E+t51kHA5ULCTiSRiLOYO4I6dsZ0ZuEmvDnH
	YSz/j28JMEf50yEVFLNHliVC0OwSzgQ9IVBDxq34hzEb0raoGaUhH9dc6wVGzcbv
	GyAAgBgLSZFTOWDPx+PNdwvdyqpzT2duYNlcmTiHpkGg==
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4g8nf4csjx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 17:53:55 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 7B8D312B74;
	Mon, 24 Aug 2026 17:53:53 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTPS id A30678064A9;
	Mon, 24 Aug 2026 17:53:49 +0000 (UTC)
Date: Mon, 24 Aug 2026 12:53:47 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bp@alien8.de,
        corbet@lwn.net, david@redhat.com, hannes@cmpxchg.org, jack@suse.cz,
        jane.chu@oracle.com, jiaqiyan@google.com, joel.granados@kernel.org,
        laoar.shao@gmail.com, linmiaohe@huawei.com, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        shuah@kernel.org, surenb@google.com, tony.luck@intel.com,
        vbabka@suse.cz
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aoyFK92azAlDAPuF@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <0d2fc2ab-333e-42a1-88a1-6bb85538cbb0@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d2fc2ab-333e-42a1-88a1-6bb85538cbb0@linux.alibaba.com>
X-Authority-Analysis: v=2.4 cv=dLiWXuZb c=1 sm=1 tr=0 ts=6a8c8533 cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=NCWKwCw8Xy9Og0ibBRsL:22 a=VwQbUJbxAAAA:8
 a=PKP6BQZIvgxffBQvtucA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: oEQ8auz5mVTDJWkWyVM5fQfqFdhNLftA
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDE1MCBTYWx0ZWRfX4ZEKKjQBqG2r
 JmDPrBRa2soGDDoYl9vdLLIgHsINRmOfd/7RaeOuHRU17VZMfsd5HIZ/4Z2tXtvnzrLPelTJrjl
 ytm7cr9G+IwisruUICOHfpDE1u4YUtA=
X-Proofpoint-GUID: oEQ8auz5mVTDJWkWyVM5fQfqFdhNLftA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDE1MCBTYWx0ZWRfX7Z4dDOz4ih0G
 Kp7146Vx9iJ3V9judH0qkquGXtnapspnIT3NgiIDnwd12A2OlnSEK7mcCw9SyN84AopOcL3urIC
 4DJe3mQKs1evHuZBurOPOJ+zcOAHK25zl2iyvNDpQ1zwqxsBu2Fu04xqYsO5RexsFDtqvFx6lml
 ocFHEZztSrU8R72+8wpssvAiYa3UMRFKbGdpexzqIFo16P03dqCsPADH/0VPt00xarO00S3Ui5O
 c9AjXZsjTUzHxl0s8s5kKi0CFxFnLqSlH+W2cLaB2gRP2fJqlZOeFjzdIXJ+k+4nEuRPf971YQ4
 sYB3aUBEBFms3GmDJijyQdS/0M/MfpTdBE261vsNGiURDBcZia4S1etEqc1NYbJvUUcGOaLog10
 ULl+QwZFfH80ztafHu7EGx6+mBq1ZYCpSBE9fUK3ENp3gr1W9ZZVJE3dRLnp9JxgeCZZXsmErCP
 hjWsnDNtfRJoktXBmEA==
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_05,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608240150
X-Rspamd-Queue-Id: CB80640008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dwcqgth366k3dndo7g69e4i3qe3pbir1
X-HE-Tag: 1787594075-372381
X-HE-Meta: U2FsdGVkX19oKrafKp2y3mww5CCIj05/p/3p9yTxgMGQWX+F6FNuNvENsAvrzygK4bgwhfqzWau9z3sNzDZSdTQP23UK+XQk0JFxOMOvqbT6HdUsNwgOnP5rKT5QlCcPf4OhjlaDwv+6usj6wIfDS5X65gaHtC3P8AqcPa4eCiJd5QaCsfyzUrpwcpmqahXRK7SBJZRIuD3qXzcskZTGAT9rrxuvESb5hcnA5uIawiTliIDT83I2YV3QZA9sTo1DnGxYyWAXCPGHJtWXD2kzbhlGGjacsVJiYbYuWwXwtzwG2a71tWL1h0v2Y7ymlBUxummLPLtf+MPwpjut59PfnSbhXlSilsBMdOXygEE6OFXHp3ryrDQ7PLyAx8st9E5ABCE1Ytwn9Y+LJPc1eAilzFLCYSu/l//gFidsd1xRz9JgHgNdq476g6454Gqdh6MCas9AibzG5VyYDRBlW6XLF+587YLwkp//uZyzNC92IZe+ZIggBv2VWdOBzghIflhPUx+EYVJwwBAg4749Ia+iMtT7G5EcsCR5sntcShfqWEMuM6nls0+IxD81HRPUWvaEj743dAlBka/ULAssjX3T3FZ4rolgVGsGIQ7kMjyxgnpYzJ4ACRcNB8W172Q4XY6t/MQ/7jcigCifXhVguUe4kyvw1o9T+M3IwDSDAcJj5KRx405KwPFtj0pJgH2wjjURCdDFPqiKR71oQIiUwnULTOuW5+juZOuq0aO60aHweinQnit4tEDh4ty4yciE/NTU23TnoVChE0USXgrI6eqFcFaY+BvZHoNdb2mY+pJK4i3tzAG1vzdnhaD5YDdLrn1mNFFVlEsJD+pFEtH9kKVPGJ1MoIy364EtqRRHmo34SNOBvVXl63tc8AkV9yzNFVEs2ewhi1r7JPUVpnHDeJljWGWPYmE7/muowCC0o3Tl5D/PtbJVowH5LiYL7jdsScxlffKlPRiBiFc/Vs6V+hs
 2y69CPZ6
 2WAFvm2lFSZYtn1/WvvFY/JTmWhjxatxRCZ4rk/tQ9BltqEh46amIYYn8dQ/B7lvd02brhwKFJVupS70Dtl78Y9MUxT4mSGZZlX6P6gEtxAx9+Cq5WDmEoEi6rk54PleQ/ULeRl375iVnbCQ3AHU6cQ3mAYeCOKWHOKQXRtCGEY1Nj0q1446tS/6/HZXRuFaJLy4lvnRVfzVaUxHYFXFi2RGy8IYMgiin5QB6HUMyWR88h06UrwYx4I0oBo8aCV8D4TuGkQgTKVlGin/J28Wu8RPrUMW+WA9DJ8W4SeiSi5S+Mx7LWbyzOo6bR0hm4VBHxqCbgR6u6kEod4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 11:47:11AM +0800, Shuai Xue wrote:
> Hi Kyle,

Hi.
 
> Following up on this thread. The v2 patch once landed in akpm's mm
> tree (9ae6eefa4b6b "mm/memory-failure: support disabling soft
> offline for HugeTLB pages"), but that commit is now not reachable
> from any branch, and mainline as of v7.3-rc1 still only has the 0/1
> switch in /proc/sys/vm/enable_soft_offline.

Thanks for pointing this out.

Looks like this patch was added on 2025-09-16 [1] and dropped on 2025-11-11 [2].

[1] https://lore.kernel.org/all/20250916032512.AE588C4CEEB@smtp.kernel.org
[2] https://lore.kernel.org/all/20251111231818.52A60C16AAE@smtp.kernel.org

I must have missed the second email.

I don't remember discussing a v3. Can someone please remind me what we planned
to change or whether there was another reason it was dropped?

> The underlying issue discussed here is still unresolved for us:
> firmware reporting per-rank corrected error thresholds via GHES
> triggers soft offline of huge pages, which neither addresses the
> failing rank nor is acceptable for workloads that rely on stable
> hugetlb physical layouts.
> 
> Do you still plan to send a v3, e.g. with the disable-bitmask
> layout Anshuman suggested upthread?

I wasn't planning on sending a v3 but I'm happy to revisit if needed.
 
Thanks,
Kyle Meyer

