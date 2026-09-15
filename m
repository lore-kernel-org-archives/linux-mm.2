Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88848C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FC46B0095; Tue, 15 Sep 2026 13:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907876B0096; Tue, 15 Sep 2026 13:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81CF36B0098; Tue, 15 Sep 2026 13:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E05C6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:56:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A46FCA04E8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:56:03 +0000 (UTC)
X-FDA: 85216750206.19.3B5B14E
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf06.hostedemail.com (Postfix) with ESMTP id A3C1318000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:55:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=JtkvPdj9;
	dmarc=temperror reason="query timed out" header.from=hpe.com (policy=temperror);
	spf=pass (imf06.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FHsVqr2942025;
	Tue, 15 Sep 2026 17:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=PNlXKXX5IyXBrJN4ylgfbuPEUG
	zQwPHtOwfHhk/bIe4=; b=JtkvPdj9EgRpDPcHrWl7UiRg4FD51sG7bJwVBqU6NW
	Uf9ZBrOUOIdWZdWKf3O6D1LdCvuCCfHBVsothhkDzcEQvQqpUa+X3DE2tXlkrmaq
	TwHA1tHiyDDO39sk9SEBf3lo8SVxRGAdRe/PmOH1oG2U32Ew1HRH3/0SvQnq+ooO
	K2eGSGVE35K+NtUNjDt9OOnemYoYORplPC7JhdkdpeH9DTdCYMi3Gziqdeq3MRUw
	O5s18X3g6ws5CMnEnGIjZAuhE5rAO37Xlpzok4myiSzSteUdQL3O4OYsdgwNOqRJ
	wJibhZ7YuJ/A1lYAxITpmgTpsQD3Am432oLyRbNyZ3hw==
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4gq95pstj8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 17:55:12 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 6BD1312EB9;
	Tue, 15 Sep 2026 17:55:11 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTPS id B4FBC805E88;
	Tue, 15 Sep 2026 17:55:06 +0000 (UTC)
Date: Tue, 15 Sep 2026 12:55:03 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
        jane.chu@oracle.com, jiaqiyan@google.com, Liam.Howlett@oracle.com,
        bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
        joel.granados@kernel.org, laoar.shao@gmail.com,
        lorenzo.stoakes@oracle.com, mclapinski@google.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aqmGd0GGUCkbZpkZ@hpe.com>
References: <aqiIEkrc6aDBOqRg@hpe.com>
 <aqkCbgHmMGxI_GLG@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkCbgHmMGxI_GLG@tiehlicka>
X-Proofpoint-ORIG-GUID: ZGyhASJQPrkZtald6s-qe-XaJzb3rLwu
X-Authority-Analysis: v=2.4 cv=SJ3Xx+vH c=1 sm=1 tr=0 ts=6aa98681 cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=_ZmgHqWwjZUDpi_pur5s:22 a=VwQbUJbxAAAA:8
 a=MvuuwTCpAAAA:8 a=OCHxr62PC90mTwIpeikA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDI2MCBTYWx0ZWRfX/bF3jfMe5L2R
 j63mU1nIBKQUtxaBXijRxEhjpUkMVc4zIvOsjeAo1gXa6d8EaQ3zY67L76NuqyOpj1PqfHtArmO
 2vl0Zj/ywj1xKqs1a/mzZMNwlkOXYrqejAwJQ505r93PdMuHej9YKGoy+OOhjdgIGcbnHU5kPaU
 yvvrSCWy5ejLgHtdaE3GjSon0dkRbhoyLPGlPM5ivm10iaII7ndWeW/6v4Wb+WicsOGN6iGbq5y
 TmACnEazHYCmP+PBiUKK1AlL2cSjGIx6qbmqEPScHv5nRJqfghhw+WYCVTjioKj934H6QVwbEyn
 +l7ofYSeMOrVz1JhspzsrFr1N4lD/2CI+O885v1QKv5nzT3CrROQPCxW5DGn1rcxZV1AAEnv7EB
 8HBx6GOAVf7DeSMdD7b3ATQFGeRAgDSkWYdpFHxj64RkQev4NJH17HwCiED+iffIRQ5Flebq0JV
 zWia0hniMaXW7l/WWHg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDI2MCBTYWx0ZWRfX63h0+WaHo6KX
 o28u0TT4xIFnPPwvxBVPnt73ZCm6PXqMR4K+TANuw3CaFV5L9FIl2AQlI4GVDKvAEj81K9dRKGJ
 DaYbaSq0UXlb+dnZCcP9Cbxr0DS1x+w=
X-Proofpoint-GUID: ZGyhASJQPrkZtald6s-qe-XaJzb3rLwu
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 phishscore=0 adultscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150260
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3C1318000C
X-Stat-Signature: zmg865p99yqxonuuejqjnfex3x7r9w78
X-HE-Tag: 1789494953-644716
X-HE-Meta: U2FsdGVkX19m5uWBHf08524bIBdj9uCckobS68xTFToCxMlRwh21DT+MFn0sO7H9APrChu+Lo8GSDrGlBovFhH/3CYoGcb4w+NfxHJI9ycI0qycFd2vURu3b5NQA9g4uwrMR1uaZL01rSWGpnlINsPXpYphbeJudnIQIIzNbOnPjHpRr9QZLpcydosrD/LHYgVLWLUFu0sKbCQ2He6VHzBuacw0d8yX5ccLPEVuufiTIl6GXw9D9l6XTx7EuzjVTHfo8LB7pdphyRj3AD2i2WK86kyURZqP1LJVcT6zmGC/aS04BQrqnFL1Kbp7v7TNwDnvYpOe1XhNL51A4u6lW+3UyMxteGTByG12c17K0LRMeB4MQvjHEKAL7pntKBwRyos+tZlmkiHurlvrKI9I+8xGz/qLG8Z3EnP2j1p6F2MvkCyP7SQ2qk7XE3vz39hVBeo3cPRmXYPv6P5HqQihtLapuEZdbuvpfEQG2uOgJlSwZuoBx2qt5f9S9xeZLNJmuTdEROJ3kF8uagA0gYOkAuS0IrST/gg3Pmt/WB0hjCFdUp6MuHgAlLen6Yr+W3iYg3Q3tv4sIwWQs4bLeTVAVx4iMGQZKGdXLlcoufHfG0JkeS+nMwpMyt3WZ1hJfpxa8eGRyQ8PhSwPGn3IADyWMHjlDhqk4q7PZjzqICllBmuMIWTKJ79+KsSC68Rk8Vueayq/dR/nYBJPTFg5zvvtW87yTODnBSI8OajFZDPDe7XLJCxPKSxo5RX627MgAbg8AKz10Y/jK5nnv/Fze9a7UtOiextgGI0MVJfffiT2ey8q236TvPgWfEGIyuz2Ay+fIcz5yHjiMbUUmMuvxqEVmLecNKk0Sdp1mOy+Q5vSvCyWtkpmuaU4IKA2ubAKM4aRO6PixUpwqSn3Ap0p7IlhDAClH0CTXidK5q3OxSpBY1p70VC0DB9A9eJbA6awrZyj8i14bUkTL+bCo94PG+7r
 G+6QB9Z7
 aFKhdOHBROr5Ss89w6EL8rKwmHZJLI6TDEnQe3FfL3lvM1zI1/gFjrSumgl+7dZdyNuI7NEuKkJZo2L4RK/rOyWLT5p6g+5JhxZ6S9pgvBIxmD/dCR/Tu2TQjkppiktmYVdJGRKEbynGqSLqS3FrmY2Rt7QPmMwP/2eId1fghN13S76LWDGLruucaIdjaDHHrMoM0tlZMUUWFpQdCVFnKLuKKaXXBmCXREWwc4WCVJY1XCJFfF1Psa0yTSaAzTvc2YAhtXALA7qK8NO5Gilk+wylVOnm5rptwICPz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 10:31:42AM +0200, Michal Hocko wrote:
> On Mon 14-09-26 18:49:38, Kyle Meyer wrote:
> > Soft offlining a HugeTLB page dissolves it, permanently reducing the
> > HugeTLB page pool. This can be problematic for workloads that depend on
> > a fixed number of HugeTLB pages.
> > 
> > Currently, soft offline must be disabled to prevent HugeTLB pages from
> > being soft offlined.
> > 
> > This patch allows soft offline to be disabled for HugeTLB pages while
> > remaining enabled for non-HugeTLB pages.
> > 
> > Commit 56374430c5dfc ("mm/memory-failure: userspace controls
> > soft-offlining pages") introduced the following sysctl interface to
> > control soft offline:
> > 
> > /proc/sys/vm/enable_soft_offline
> > 
> > The interface does not distinguish between page types:
> > 
> >     0 - Soft offline is disabled
> >     1 - Soft offline is enabled
> > 
> > Convert enable_soft_offline to a bitmask and support disabling soft
> > offline for HugeTLB pages:
> > 
> > Bits:
> > 
> >     0 - Enable soft offline
> >     1 - Disable soft offline for HugeTLB pages
> > 
> > Supported values:
> > 
> >     0 - Soft offline is disabled
> >     1 - Soft offline is enabled
> >     3 - Soft offline is enabled (disabled for HugeTLB pages)
> > 
> > Existing behavior is preserved.
> > 
> > Update documentation and HugeTLB soft offline selftests.
> 
> This is adding a lot of user interfaces to control something you can
> disable by config option for an admin only functionality.

I may be missing it, but I'm not aware of a config option that disables soft
offline specifically for HugeTLB pages.

> I fail to to see any actual justification for all of that. If an admin
> can disolve a hugetlb page it has power to allocate a new one as well.

Allocating HugeTLB pages after boot is not guaranteed.

> Not to menation that the whole soft offlining is mostly a testing
> feature so adding a lot of fine grained configuration space seems
> excessive to me.

Can you elaborate on "mostly a testing feature"? For example, how does that
apply to the BIOS/GHES path discussed here?

https://lore.kernel.org/all/aMkOCmGBhZKhKPrI@hpe.com

If you think this should be handled differently, I'm open to suggestions.

Thanks for the feedback,
Kyle Meyer

