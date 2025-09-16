Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0CABCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017178E0010; Tue, 16 Sep 2025 14:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F313B8E0001; Tue, 16 Sep 2025 14:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E205A8E0010; Tue, 16 Sep 2025 14:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D41878E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:00:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A6701401C4
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:00:25 +0000 (UTC)
X-FDA: 83895878010.12.3B366D2
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2228818000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:00:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=FWNkANcf;
	spf=pass (imf16.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758045623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xWs40zs4LLj/t8X8LdM1V8hVhjivA2n6F7OPpYtRV0=;
	b=iTkImQM7SzbP5mzcuCa18h+Aq6DJVg9iP6svdZO/omKqZrGYH9xSdkWzE1ypG+W06gL3JE
	RgxmJad2MXz+ZrwRzJkBsFcXR9McyvdBhvx8H8uOxKNve1R+IEpQ6sZoLDYR4hAROQDkfN
	LR3ZZc/AuJOF55DsmiVP6F9Mo5952yg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=FWNkANcf;
	spf=pass (imf16.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758045623; a=rsa-sha256;
	cv=none;
	b=IPkjL2hAAUbow0D1sHRJIKJE+hw/10HY/gwFViETHuPeR6K76U5RVXMTNs0mC4Pj556ZiS
	aHY0fGpr/YbRQPuMfwExJTkTWwHuCK8yggnXtuv0hukE4+bXAChTXoYLBbPamhBUJ0Oj/I
	TKJEQz77k7mesnqF3ddLj4wKGA5qpgU=
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GGWQ0u021477;
	Tue, 16 Sep 2025 17:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=6xWs40zs4LLj/t8X8LdM1V8hVh
	jivA2n6F7OPpYtRV0=; b=FWNkANcfHlJCaoS2LFWDFRqfMi7MUlRktev1xzCpRu
	Vbpz+2FUKa7b0Xa52j948oIwMLUv77ekaeXbKhTCMEL0G+sK9OIHDgjhfUG/0SrL
	mP+RqLYcWq2ZfvbReJjbRxURQslY1S72vY+icA8kydnwsKGv1QcQiy/21zgsZw6Z
	cnCbg9QjYItmPPLlV5YZSTuxTsjfP8Q++akSoKlpfg7vBKiS8m+Cjdw4kqg7Gu+4
	+R9z7dh9jQTpc2GucXb7WZKSwzFW4LWKMX2E8JSXijf8lEu7SoJYR3rQKV6i7noK
	iGwaEVKKPymCxdAxUWTiISsLgeuRnLJ+9aEDOaWxaCrw==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4972u8n96f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:59:45 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 61D5F805E2F;
	Tue, 16 Sep 2025 17:59:44 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTPS id A42F3800EE4;
	Tue, 16 Sep 2025 17:59:40 +0000 (UTC)
Date: Tue, 16 Sep 2025 12:59:32 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
        "Fan, Shawn" <shawn.fan@intel.com>,
        "surenb@google.com" <surenb@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aMmlhPghbpnlCZ09@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <20250915201618.7d9d294a6b22e0f71540884b@linux-foundation.org>
 <aMkOCmGBhZKhKPrI@hpe.com>
 <SJ1PR11MB60831F028E2FEB6B5A3390D9FC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB60831F028E2FEB6B5A3390D9FC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
X-Proofpoint-GUID: Q7Cf_oIk6h3gAbSjKmPOmUD-fW7GlGMm
X-Proofpoint-ORIG-GUID: Q7Cf_oIk6h3gAbSjKmPOmUD-fW7GlGMm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDA2MyBTYWx0ZWRfX2QHb884MSCLw
 Mr0AHfkH2X4MplkHMZzSH28hLGQTwuYPWJqLUHhlqtNwCwZSlrEzOEU6/g2IvlwXwjdnzKvQX4b
 mITesEa2x7XS/A51soK6REZMUCKl642UneGW6ml44Ic6QSSFFVkpjbJYPEMoyeJdrZnCFmtMM2J
 8+lrVcukOZ/2uo9SOABl6+U8MOtcnLlkwY3f9NI8doesg+QnQmp9ge1Ak3FGSENu1JdBl2DUDP4
 IHKwYtzzCAPAC1buR5DiHXq1Qq61+yphJRLwUSE0qkQev9alawSZXi6XUzPvndAgfgckglvKGed
 15PtdtZ+B0J/mEYx1PbVNzmE9MM7o6iUlXeM7wRKqW6Kh4rDq+AOAGagJZkDlcxcsL+LBJKKmp6
 KnOfRC1v
X-Authority-Analysis: v=2.4 cv=T+GMT+KQ c=1 sm=1 tr=0 ts=68c9a591 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=QyXUC8HyAAAA:8 a=vcrsxdLqD5ATI8kw6fUA:9
 a=CjuIK1q_8ugA:10
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 phishscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509160063
X-Rspamd-Queue-Id: 2228818000A
X-Stat-Signature: taox8djdxgiimngqh387riwpu1ys9171
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758045616-931974
X-HE-Meta: U2FsdGVkX1/6PYfw44TLuVScsgY9Nrz+s4TCb/XwvGz89emQa5sNIq4PL+R09q80eki3Ww/XpgpblFsIOnqMtiJiIv+FV6TPGrf+Wep7lFBWRKm1gMaFSeVApV1T8SKwPeS6lqerKDiqNAAehHj5O/TDxr99YVQhwf1a/SQUL2ikWmT6q75eq9LhwUqzBWpPdX3G3x24XH8gIqAXZb1lZuX/vWm3iLs5M8kMlus86wJVOlaxlB13MNRo9vXzYIeD4L1nSf8lIjZ2MZJLKwcTEkKINLNgqLGmWW5HBI9QC6edaTHiWKt9UT9u9rFeizTPXUTVOxQhB2CHcyi5Sb89Yg1XftEsiKRYyVQEFUIxgHwwsT8Yl85WapwcXv0ZZNmYp5m8fPR1LEPG/I29O6CzgnKr2DupYxtmMTb2tfWSIYBy+yQ3D4wl9ek6oFU3EQPWZr/HPKkGGr49U+4L8VDONWlbkkPAFiE/RwXI9e37l95bjtWxhTOpb2Y+hDQTRJ3fx1WKaiK/waXX5AspdUf/dpDDxs6p15n74iy7bSXDlLICdgw9kUvAAASR25Mj3NPcvq3wmQ6z3ngeeeFN1V/t2GvSOxJtyeSegw8eYBIkIlJ/tezuZAj/7+g57wlSqyz+4T0eF2XI1oeXTEq7MZGIOX7/8E4yy8wlPFx0wFGFZ+fYKoPvhRwH4cE48pd/vH36Xb55yn91WfV19xMaf7QXwmXjUob4pnypBtdfCTdYVYgpHJ+exBWs+BKJNMAhKikrmkyIjriJGtkD7GwRyHH7S8mpY5/42erzdLl55RxavZB4jAiYFpK3bKBXhb+0lv697E4KLTpv7cEi37yTat+E8QUiAAbiMVs1eMfSLMHn6Pb8EvHhVaZEu63caZzQ4NuviC0thL/kQitiSH7paZUgNXjooN/gC+9O9OO9R5Zkc/1xP9YAcRSaxY2Fl4wpYhuTJxeSf69xwgT4/wtxN5o
 zK4Z4iPP
 WblmPugiO6IHF4D0iWfa8HLZDKyTerEwaatSl77Nb9RT6CRkxGaoPDrUvoQS3UySd1bJh2Pu/+YMhzR60cmRLhRBlqDfZOTJ/MvnCjWmZRvnzGu2jcc4x9/2LtbK+G7kuqT1g9c21WM98PRBgsUNdVWAexyiZw4lqfGWnJxwSXcnAv26KqeBxccNlfE7ljxSa0foyH+MA3MazV19j444O0vyWnNeBd4ZIaC5/BNlgJs9vowIOT/ZyiWzMF9obFGniJQkS706riNt/nsbuj6dlQv1K1DjhKGMGDI0bFhByRC3zoX5I75NyoNaCE+o8Wun+tc5sZhVAsXlUvnzPAxCv3ehG1Fpel1JEmY4bhAMsSMQAiz7s+/jyoa6uHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:20:49PM +0000, Luck, Tony wrote:
> >> > Reported-by: Shawn Fan <shawn.fan@intel.com>
> >> 
> >> Interesting.  What did Shawn report? (Closes:!).
> >
> > Tony or Shawn, could you please point me to the original report? Thanks!
> 
> Original report is internal to Intel, so no useful link for the community (but
> I still wanted to give credit).
> 
> Recap of original problem is that some BIOS keep track of error threshold
> per-rank and use this GHES mechanism to report threshold exceeded on
> the rank.
> 
> Systems that stay up a long time can accumulate enough soft errors
> to trigger this threshold. But the action of taking a page offline isn't
> going to help. For a 4K page this is merely annoying. For 1G page
> it can mess things up badly.
> 
> My original patch for this just skipped the GHES->offline process
> for huge pages. But I wasn't aware of the sysctl control. That provides
> a better solution.

Tony, does that mean you're OK with using the existing sysctl interface? If
so, I'll just send a separate patch to update the sysfs-memory-page-offline
documentation and drop the rest.

Thanks,
Kyle Meyer

