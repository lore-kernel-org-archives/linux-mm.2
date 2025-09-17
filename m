Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B5BCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA552280012; Wed, 17 Sep 2025 14:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7C11280002; Wed, 17 Sep 2025 14:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92AE280012; Wed, 17 Sep 2025 14:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7DBE280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:59:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89D3411AABA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:59:37 +0000 (UTC)
X-FDA: 83899655994.13.6672F5F
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf29.hostedemail.com (Postfix) with ESMTP id 41E0E120009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:59:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=OToBLxFj;
	spf=pass (imf29.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758135575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HssRRRBcK1dSQW061f4MB6eTx2lTTiHMP1LCQG7zdSo=;
	b=UxQb/5M5ONP06pZte+wJHtKDTBuJLh1jvoUP9VS4rNAVC1FuhbMZtGsyjP0vI+ha/vFfZ7
	OeKLWSBsORCGQN/GEDJaib8Ne7MFGYcgoZZAZULuLWVQQjH+/4XwavZZD+KPH56x1nkkuR
	ijF6jkQCCd0JH2MziZYARFe7oOXl8Kg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=OToBLxFj;
	spf=pass (imf29.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758135575; a=rsa-sha256;
	cv=none;
	b=DSy0ZZ/Nxcui63jbvVvddFnqTMZTUUi1787uKCrRwFacW64HXeqJPUaC3Dxma7WyFzmu/V
	LrEJAfg9iBe8mO6I3T6nGHLXrbiXNUQqzbfqIzlGknFGq0OFy2ExAb9DGPVln9UG5UbZkO
	eRO0Q0LVHSAaO65KmXwd9OWJ8pa9oRg=
Received: from pps.filterd (m0134420.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAXTk4006258;
	Wed, 17 Sep 2025 18:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=HssRRRBcK1dSQW061f4MB6eTx2
	lTTiHMP1LCQG7zdSo=; b=OToBLxFjEcd5kH8Uyo7U+CadNhycCE4W8Bkk4OK9LN
	IePdhI56cNYa6kVFxo17gtsdUigMdlu+z5R8Ji+e7FIuOtWIPjFOi5VrrzphVzaU
	H92whtryST6hkoeLuh+kgGALowjUZlWDtLktYp1ySurbp2hBCl5uK1YT3ThAVLxA
	UcT+VKn4rk8jacbl24LAose/ac1kutcJfX4uTL3Y5vaKNjJr7T0mnQ3YeYVaaAXg
	80Wi+hr3OtXVxSLDWXoyeD3cLB7O9zieqlqN3+oBmCTE4J6M9C/KB2ZxN9JXzmim
	gqF3RHZe2ye08v5BGvE6aZKsSBR7k3GPAv1bOc+YGAeQ==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 497kq6qhb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 18:59:11 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 12B3F800373;
	Wed, 17 Sep 2025 18:59:09 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 019948123C5;
	Wed, 17 Sep 2025 18:59:06 +0000 (UTC)
Date: Wed, 17 Sep 2025 13:59:01 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: "Fan, Shawn" <shawn.fan@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "david@redhat.com" <david@redhat.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "jiaqiyan@google.com" <jiaqiyan@google.com>,
        "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "joel.granados@kernel.org" <joel.granados@kernel.org>,
        "laoar.shao@gmail.com" <laoar.shao@gmail.com>,
        "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
        "mclapinski@google.com" <mclapinski@google.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "Anderson, Russ" <russ.anderson@hpe.com>,
        "surenb@google.com" <surenb@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aMsE9XjWKEYTIQyV@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <20250915201618.7d9d294a6b22e0f71540884b@linux-foundation.org>
 <aMkOCmGBhZKhKPrI@hpe.com>
 <SJ1PR11MB60831F028E2FEB6B5A3390D9FC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <aMmlhPghbpnlCZ09@hpe.com>
 <SJ1PR11MB60833884799B6AA2BC18ECE7FC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <LV4PR11MB9513A6EFA88B082E554CB8D6EB17A@LV4PR11MB9513.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LV4PR11MB9513A6EFA88B082E554CB8D6EB17A@LV4PR11MB9513.namprd11.prod.outlook.com>
X-Authority-Analysis: v=2.4 cv=YogPR5YX c=1 sm=1 tr=0 ts=68cb04ff cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=RcxEoRTqGeSLHFrOZFgA:9
 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: cayg6L7CXNT87CvmSwj5bA13oK1OZF1P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE3MDAxNyBTYWx0ZWRfX4HHF3Wa86bUJ
 qXs0LRZQoHnueXV2tvopiwEMlBCKn2g8H5SMzoQWnS7r/deZ3PZ8Cc/dz5G8Pv5vL7Z/uKGKi6C
 O+RnbJtFmwHUb6e6vcWIUsscmh5HeBMmpKGJSUK2Nt7A33CN8x+MymIAYLVJtkC8hPz3VladTlR
 YD7fORBKIFjCjIGEs/Fr8pPxd7cxtm753o1z/+ce9PFmT3YWeU7xGiQdGszI/zU8Ba/hs6cLdjz
 r/xglELMqZor3DK19MVyrr5LEbvDpEAs9shlePnIEaWXMWQAfszmTZ71/FUmiQChIUVExl7Rriz
 ANa+cXATBkcFWv+LectqWF68+8TgHKXDdfwvpg64yZ1xhSTqN1MPpLRWwnZr/CZPkezDtOd6Fa0
 Nd+FDhBx
X-Proofpoint-GUID: cayg6L7CXNT87CvmSwj5bA13oK1OZF1P
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509170017
X-Rspamd-Queue-Id: 41E0E120009
X-Stat-Signature: 3hrbrfqsbomjxprmxept9cpas6y3qzfm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758135574-757878
X-HE-Meta: U2FsdGVkX1/byPhx0H5WhCmSMttgzqLaJleoSDuBKLrsyWNCwXjog9BeY7+J3hgybrFAVQqyUB/LvfFesmxGEsqyW5hg07odXLUA/aD9UrXFFouwR41gIBrerVF6UCW06g6/MZrvyl0ivsCglo71RHOyxXgEUfdkppzVwdDVw0XYGEZRqvG1GtleAc9aCJ2qHq4j2NJcTdzn39hDPL+ekq/zuX1Xaa6Rfd/BOPGPDygz2v62Ya07x8M1C76twQ7rnuT52x0FSlrIWWcCkqaIpIYkRhrvorGNQpkQhuYktyJIkET42aBrBs/SDkTzt+q5bm2l+I64teiLzcqClT9c6nKNWngxnTMe3zMRCOt6f9ntQsx07igdqNtrWV4Vrh3tXPTznPJOAi93dTX/WPhtxLrbHcYwsvFmKZlw4oB4WBV9Iyf/6XaRdDq4l2AIaNDYhGVCAAjrbdV7yoRe3WIXqLvF9Lz0zQAtfcL1RAGzPm9rd5oNevzPp58u3AQ1e5UkYYzvjJCHRNrCYsCun3hxiSnX4xsUCUCrHLCtssfYEfPcc6tnIonUsdRNICbvQjxIh0zTSOAjMMUkgCO81lbTXvjDCXhAcBOY67CeBPUUgB/KjC879+cSoO6Kr1a1YNrEi/MzZ83nW0ESV5yrk26cYPXQsYMAyxhbuuneLOj+RZkFgUM9AAmBQ1jY54f+sGg5EHixEg48rA16LbTyz/xVo1AVAva4xex3ynYworQOvnkh73dCmAOrguhNOt4OrD4Nc0hTISGNbS8FZTEsJO8vpkaPBpt3ACF4T50ACLPER1qnGthENscR9VVcQdwDDsUI3v9o7SUEAgZsy72BR5KmPxIk2wHLB4TEksLI7qZ8lKlTCXzzcCqvzVNBdxu1uJsYc43TA/KK0/+4YDWVOIWVtmj8IfBBtwZKkfQb+14iw5/naAmSua+r0brKchrkJ3lOdqOp49BA5k5to+b/xIQ
 hRIbX24+
 UN8ziIclW0Ih48S1gsZCn296av+r20p+ag/lHnyW3QI8D3gNn45UdQSdXumRDyJ5/KtRA5zlnvLAk39G8bhVoe/+wMhq8QbPtHRHg23620mKIu5ohtfxKozuisRbnD6BSB0LUQYEIR310tlL7X2D9TtTzwqJD0iVPoHgYecSJ7enoRcDM2hUfhPB5g6F83ce638BTAszfGiawGT66LgFEPRXIkGOjcfGMHoHNcDBL9zkP+teGD2RRERxmvcCEcudGEPhyHQ23PssiFGC7m4rXE8MjsVLXYT5A85TqCUH1v8IiH5y13azm6m/g84jPbZXsbBOYR1Gr2zLaLvWcQ8U3fF5ou/X2F6jEPaNy7uPDsk3wSmpSO84eEIQoxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 06:35:14AM +0000, Fan, Shawn wrote:
> >> My original patch for this just skipped the GHES->offline process
> >> for huge pages. But I wasn't aware of the sysctl control. That provides
> >> a better solution.
> >
> > Tony, does that mean you're OK with using the existing sysctl interface? If
> > so, I'll just send a separate patch to update the sysfs-memory-page-offline
> > documentation and drop the rest.
> 
> Kyle,
> 
> It depends on which camp the external customer that reported this
> falls into:
> 
> 1) "I'm OK disabling all soft offline requests".
> 
> or the:
> 
> 2) "I'd like 4K pages to still go offline if the BIOS asks, just not any huge pages".
> 
> Shawn: Can you please find out?
> 
> 
> -> Prefer the 2nd option,  "4K pages still go offline if the BIOS asks, just not any huge pages."

OK, thank you.

Does that mean they want to avoid offlining transparent huge pages as well?

Thanks,
Kyle Meyer

