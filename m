Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F989C8303F
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 01:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A978E0089; Mon, 25 Aug 2025 21:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAFA8E0038; Mon, 25 Aug 2025 21:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9B48E0089; Mon, 25 Aug 2025 21:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE788E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:57:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6B35118804
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:57:51 +0000 (UTC)
X-FDA: 83817247542.27.0855145
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf03.hostedemail.com (Postfix) with ESMTP id 44B1B20004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:57:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=OdestZrw;
	spf=pass (imf03.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756173469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3e2ypT3Kx6Yk73bwvacvSvu/yuGOsKJ/34CpZyahLM=;
	b=SF+ALHMntjLDBJjBmKj9UBHf2KX5WAkEsIR0qfSjroY6e6IfMBhATBCOjK5MG05E3j+6vt
	VNAG+JHcqc8w5+q5a/FgIr6s1s1nBVc7ybvyRcgx4Bzc1ocO7T+k0Uk+1eK7GKQoN1DPBl
	VUc30iCo1ynTmK5g2NImsn7nm3usDaE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=OdestZrw;
	spf=pass (imf03.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756173469; a=rsa-sha256;
	cv=none;
	b=xYFaBaD30/AGt9NJHfS8HHk2Xjq6Yi3rotL/T2YACjouRhMfkQKEA2jkzqRNFjSVE5MIoz
	Mxd0IFqe/Jsx/3RGEMVTe6U85H4WfB9XZd4BSnUnJ6o/N4unel4PKo5i4MUK5vmpYYxG2W
	gZGRrzLrLNmI2ILV6WjP7z8vry5AVK8=
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PIhYOX010998;
	Tue, 26 Aug 2025 01:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=q3
	e2ypT3Kx6Yk73bwvacvSvu/yuGOsKJ/34CpZyahLM=; b=OdestZrwhcBNQMcaOB
	NuxwGYIa/nrXisiL9KNmm877OTiNmM1AKTmg/0rCGWxm9WQGMdWKoXNObrxbu30O
	GN+kSa2pLDgTdczlN+3FXkpmfJ1mdZNodesZ4wRyr8/xAl4DTMitRxZF+sMjoqK2
	0tGa2sP+0yytiriXLLO2Gp0rTUUhwbkABQPth2IEYwhIzfevqEBIXWL0qOAijBI+
	vJTXM08nhOkCF8t+ZEIHEdhKvX9rkXw7MCokl7Tx5F1f7C5yDURteWoaJLHu5lvU
	wNh6i7DSgFKR7l2jAxvvM1xtEHe5ZjSDWGkzX5iiEqYyIDFl1dDBgIWLQ18MpQ0E
	2qIQ==
Received: from p1lg14878.it.hpe.com ([16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 48rwc12t1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 01:56:56 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id E061C130EC;
	Tue, 26 Aug 2025 01:56:35 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id D1FEF8014CE;
	Tue, 26 Aug 2025 01:56:32 +0000 (UTC)
Date: Mon, 25 Aug 2025 20:56:30 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: jane.chu@oracle.com
Cc: Miaohe Lin <linmiaohe@huawei.com>, Jiaqi Yan <jiaqiyan@google.com>,
        akpm@linux-foundation.org, david@redhat.com, tony.luck@intel.com,
        bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, nao.horiguchi@gmail.com,
        osalvador@suse.de
Subject: Re: [PATCH] mm/memory-failure: Do not call action_result() on
 already poisoned pages
Message-ID: <aK0UTovxnKfjPwXs@hpe.com>
References: <20250821164445.14467-1-kyle.meyer@hpe.com>
 <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
 <aKd1K3ueTacGTf1W@hpe.com>
 <CACw3F527M-x=UeB0tN_sjCgp_YP_8yLkVRCLP2dLO2bzXrqWsA@mail.gmail.com>
 <14a0dd45-388d-7a32-5ee5-44e60277271a@huawei.com>
 <aKyKort2opfQYqgA@hpe.com>
 <2bd5c32b-dfc4-4345-8cc8-bbda5acdc596@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2bd5c32b-dfc4-4345-8cc8-bbda5acdc596@oracle.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI2MDAxNCBTYWx0ZWRfX77CJDoR4U+bo
 adA0Byap4kY4QNffTn/8w4l6Y0Di6CfcyCKXwdkK/7sIZTalDyO7Dw8qfIb06flAOD/C+dbK4Ck
 4KVI/94bV+VSbzwhWpZFvrAR9DUBi4ji1MoCYrvZwL+t9huiE0bzbQY54MH739HWD/T2oRiNnYY
 5eRrgWIU+JnxELLMgWyDNSm9l+NhFWtVbv+xHOVM8TOeocNGJf29+1S/LKNSW8+6V8tTHwASige
 Kj/xsvL/wtZOhiZ2Gsfmv/vM8rJ95FQgDoNCcmsoHMqe0VueEmMc1ouQMg2bqZxUjxflBnicEM1
 emquCn8wvGd+X3wdDi3h7utZk+5i/kSqfiazPzit/6sjnOYWeZZ6WjkyHxq34ny3H/byvoy9kOG
 5JFbqAP8RKyGnOlcROihqSby3nWxHPBkfEDFAEvVB6NpmRecJ+4G+Th2/RDuZQ3OiJ7bW/I6
X-Authority-Analysis: v=2.4 cv=EMYG00ZC c=1 sm=1 tr=0 ts=68ad1468 cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=MvuuwTCpAAAA:8
 a=1XWaLZrsAAAA:8 a=VzHv1wIHhfcjo_lpb9wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: sIWRHfsPa6103QyDutpgkX3sUVCctQYx
X-Proofpoint-GUID: sIWRHfsPa6103QyDutpgkX3sUVCctQYx
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 malwarescore=0 phishscore=0 bulkscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508260014
X-Rspamd-Queue-Id: 44B1B20004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 74dwst7dxexecyz7kpid1a3eazqikfqr
X-HE-Tag: 1756173465-187170
X-HE-Meta: U2FsdGVkX1+anctFqhlo/U8x0zlk+jV/4ABnu1pIpa1VOM2n8M9TDSFk264Jh5MKGpm9mSmAyxf5llQNFuagMzA+ipgsHE1MvCGaeHq/HTh9TMf1xk/pjsm58cs0c/M1WTzaT2wYisPFC060rgPoNr2PNgkWvqDgFHstN2fF0nazd5Gd4PmogbeCaLXJgCq4q14m7dGQa3BuQ2q+8k+98nl0KEsOi+WDHdS+77C7AQZp5lB0Jrhb216JYZCtUZl+3QrGoeI0yIxaJ/W1CF5NDfllaBwr8tzO4SYiuLqANGEs/w+Ipaeu0CGM10RmuXuK50NmmWtbBvkwR8ZZ71aEMHNHDjsozxQ/ivnzj2Jf4UZk/yaFYd48L/RdFflzlkXdPYNEnmWT0ScTJ065rc3QU2PipEHJTqzmPYEH0cvXduJFK1C1+PqbfDHVpqON3biqch5ZmAtEMHEBlDK7+AHbpzN8ooeKI8YdtE+2cRk7OwSC2oAHAs5srdqw3IGxfSXhLWRMIn2+lJhO65AaOvWWWy+E8iV/cY0o9kKwTc0nDtUsXMcKBvnM5LW64k3FUXJvGae1i+n6GTbu7G07G1SHO+f95wSEJHsCAY7fyTqfcPXMIuE1CdxtzuwHgsu9JT+i7mi4S7T675wSZFnGx1XqVTv15vCinCTyYJuyLOTpr+HHPaN7C59kfXbe4uVNpnrHqHW2eAtYLarYUvnS+jaGcJ4MC4Iq41f8LYVRQtD8akLkMuW+rDvVMuG2MjCRxxthIr/zA0JPeYlQPiJDCgikld5o6NyL4A5qMZjHG2QkkEO4wfgns3ZekvRo/I8gRKvL580F44dVYl5lLFsUZqjl1YvUAwL6UvKkgN9bsvygmbUdD0jF9PKDdRSnYZ1yWYbX4krj+vyy6SWXLkQsMznqbnjiHwZSHXPauaamXuDY42qTulDD2+jiF/yU4ZdrZeWJKsYFgcm7uAGn4MHzyvs
 ywjXdyBv
 Rs1Sx11AV5i2tOuj1MHdUesZ/Ur6sdwoiNvD3AEnHDzdiLsA7f5EwsAacU0q6TOznmehnz/Xkc+XNnSSXEJchQ6x5tMAxC/1uOdX7sM1AvSkzK3kt2DIcWeNOvUeNFCTDGOAxfuRqU0XbJeJ8gEeKjjcw48qo7smEzZjcem4Im9XXqaNIf5DRqQGRlU+yFo2E4HgG3YoKNnqKkVJotMN3xKhKekQtJ8b76wRTykFgPSrjOGyZ+kQGNgm5RWM32LEE10Ruoqu7M3e4wEfjQETJVZl6jxUCkuPnuahxVIogW+kZAKK1uNry4a3rXeiDqxOfl39+TJl6qPhnLBX6M542m4Dt34V0bRj8efLoX66+4QhqwRehoRNPw+xhD8561AOPiejrTnX9fkhO0Nc6PAxb3O/I5BlAU1ofbdE6tiUIefmLo25i6GavfunEntdvrxn9/rn4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 03:36:54PM -0700, jane.chu@oracle.com wrote:
> On 8/25/2025 9:09 AM, Kyle Meyer wrote:
> > On Mon, Aug 25, 2025 at 11:04:43AM +0800, Miaohe Lin wrote:
> > > On 2025/8/22 8:24, Jiaqi Yan wrote:
> > > > On Thu, Aug 21, 2025 at 12:36 PM Kyle Meyer <kyle.meyer@hpe.com> wrote:
> > > > > 
> > > > > On Thu, Aug 21, 2025 at 11:23:48AM -0700, Jiaqi Yan wrote:
> > > > > > On Thu, Aug 21, 2025 at 9:46 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
> > > > > > > 
> > > > > > > Calling action_result() on already poisoned pages causes issues:
> > > > > > > 
> > > > > > > * The amount of hardware corrupted memory is incorrectly incremented.
> > > > > > > * NUMA node memory failure statistics are incorrectly updated.
> > > > > > > * Redundant "already poisoned" messages are printed.
> 
> Assuming this means that the numbers reported from
>   /sys/devices/system/node/node*/memory_failure/*
> do not match certain expectation, right?
> 
> If so, could you clarify what is the expectation?

Sure, and please let me know if I'm mistaken.

Here's the description of total:

What:		/sys/devices/system/node/nodeX/memory_failure/total
Date:		January 2023
Contact:	Jiaqi Yan <jiaqiyan@google.com>
Description:
		The total number of raw poisoned pages (pages containing
		corrupted data due to memory errors) on a NUMA node.

That should emit the number of poisoned pages on NUMA node X. That's
incremented each time update_per_node_mf_stats() is called.

Here's the description of failed:

What:		/sys/devices/system/node/nodeX/memory_failure/failed
Date:		January 2023
Contact:	Jiaqi Yan <jiaqiyan@google.com>
Description:
		Of the raw poisoned pages on a NUMA node, how many pages are
		failed by memory error recovery attempt. This usually means
		a key recovery operation failed.

That should emit the number of poisoned pages on NUMA node X that could
not be recovered because the attempt failed. That's incremented each time
update_per_node_mf_stats() is called with MF_FAILED.

We're currently calling action_result() with MF_FAILED each time we encounter
a poisoned page (note: the huge page path is a bit different, we only call
action_result() with MF_FAILED when MF_ACTION_REQUIRED is set). That, IMO,
breaks the descriptions. We already incremented the per NUMA node MF statistics
to account for that poisoned page.

> > > > > > 
> > > > > > All agreed.
> > > > > > 
> > > > > > > 
> > > > > > > Do not call action_result() on already poisoned pages and drop unused
> > > > > > > MF_MSG_ALREADY_POISONED.
> > > > > > 
> > > > > > Hi Kyle,
> > > > > > 
> > > > > > Patch looks great to me, just one thought...
> > > 
> > > Thanks both.
> > > 
> > > > > > 
> > > > > > Alternatively, have you thought about keeping MF_MSG_ALREADY_POISONED
> > > > > > but changing action_result for MF_MSG_ALREADY_POISONED?
> > > > > > - don't num_poisoned_pages_inc(pfn)
> > > > > > - don't update_per_node_mf_stats(pfn, result)
> > > > > > - still pr_err("%#lx: recovery action for %s: %s\n", ...)
> > > > > > - meanwhile remove "pr_err("%#lx: already hardware poisoned\n", pfn)"
> > > > > > in memory_failure and try_memory_failure_hugetlb
> > > > > 
> > > > > I did consider that approach but I was concerned about passing
> > > > > MF_MSG_ALREADY_POISONED to action_result() with MF_FAILED. The message is a
> > > > > bit misleading.
> > > > 
> > > > Based on my reading the documentation for MF_* in static const char
> > > > *action_name[]...
> > > > 
> > > > Yeah, for file mapped pages, kernel may not have hole-punched or
> > > > truncated it from the file mapping (shmem and hugetlbfs for example)
> > > > but that still considered as MF_RECOVERED, so touching a page with
> > > > HWPoison flag doesn't mean that page was failed to be recovered
> > > > previously.
> > > > 
> > > > For pages intended to be taken out of the buddy system, touching a
> > > > page with HWPoison flag does imply it isn't isolated and hence
> > > > MF_FAILED.
> > > 
> > > There should be other cases that memory_failure failed to isolate the
> > > hwpoisoned pages at first time due to various reasons.
> > > 
> > > > 
> > > > In summary, seeing the HWPoison flag again doesn't necessarily
> > > > indicate what the recovery result was previously; it only indicate
> > > > kernel won't re-attempt to recover?
> > > 
> > > Yes, kernel won't re-attempt to or just cannot recover.
> > > 
> > > > 
> > > > > 
> > > > > How about introducing a new MF action result? Maybe MF_NONE? The message could
> > > > > look something like:
> > > > 
> > > > Adding MF_NONE sounds fine to me, as long as we correctly document its
> > > > meaning, which can be subtle.
> > > 
> > > Adding a new MF action result sounds good to me. But IMHO MF_NONE might not be that suitable
> > > as kill_accessing_process might be called to kill proc in this case, so it's not "NONE".
> > 
> > OK, would you like a separate MF action result for each case? Maybe
> > MF_ALREADY_POISONED and MF_ALREADY_POISONED_KILLED?
> > 
> > MF_ALREADY_POISONED can be the default and MF_ALREADY_POISONED_KILLED can be
> > used when kill_accessing_process() returns -EHWPOISON.
> > 
> > The log messages could look like...
> > 
> > Memory failure: 0xXXXXXXXX: recovery action for already poisoned page: None
> > 	and
> > Memory failure: 0xXXXXXXXX: recovery action for already poisoned page: Process killed
> 
> Agreed with Miaohe that "None" won't work.

What action is M-F() taking to recover already poisoned pages that don't have
MF_ACTION_REQUIRED set?

> "Process killed" sounds okay for MF_MSG_ALREADY_POISONED, but
> we need to understand why "Failed" doesn't work for your usecase.
> "Failed" means process is killed but page is not successfully isolated which
> applies to MF_MSG_ALREADY_POISONED case as well.

So that accessing process is killed. Why call action_result() with MF_FAILED?
Doesn't that indicate we poisoned another page and the recovery attempt failed?

Thanks,
Kyle Meyer

