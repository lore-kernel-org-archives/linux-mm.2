Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C755C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 18:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4CF6B008C; Mon, 24 Aug 2026 14:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC926B0092; Mon, 24 Aug 2026 14:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B586B0095; Mon, 24 Aug 2026 14:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 392E46B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:31:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A06C0C01E6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:31:56 +0000 (UTC)
X-FDA: 85137007032.25.5BFCE90
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf27.hostedemail.com (Postfix) with ESMTP id 31C7140012
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:31:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b="jwd4kc+/";
	spf=pass (imf27.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787596314;
	b=i6FMOcpunsSK1x5MkCip75YMAplOUeEQ78KTO8YcThQZMI2y8F/Xwnx42Nes3+gePIe0vZ
	s48qcel++STTU6Jj0s6MJeVq7T5ZM8eRLxwT9V6fQcKa6RDG0RWBXmw1yetPeZJbvkETHI
	wwi6ieoS1S+a1d5hRxsSGcclal7L1KM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b="jwd4kc+/";
	spf=pass (imf27.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787596314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTgLwMTzne+xNna2gstnLVyAmcVmelz+lcqZmF36Kqs=;
	b=IfzfCjXYJj/HddEtTpr+Prwip5wtwYzb9MY7UGxMozQ5yFktvXDRa3nquAZhtnuS8+X50A
	dMHHqVb7DKEyATxZk1gD0aZOViigvKaQf/DJaDaXJPKsT6yp3U4rQFoem9PVz5XjEDnD37
	hsDttxR+FRaFjVA7BnoxGLnV9G3Phyg=
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67OFllYu3126801;
	Mon, 24 Aug 2026 18:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=dTgLwMTzne+xNna2gstnLVyAmc
	Vmelz+lcqZmF36Kqs=; b=jwd4kc+/A/6y5lqMApvXmdgJCE6xM2XPgZrxohHn3V
	vDpxNRSdhzMZHSyyti6m7bUEwW4mx93exJbJ5qKurygrzxgWdsnVNbSYaogvxfyb
	Xi8GMfzEvR9SnxZqV0bHQqwZ5YKTEN37stj6aUw1h3ugoxtNT0OQ7GYFxXj7dgew
	LaPxmbUc8OR1wZl201FewYq2mlHI1T3g9HD3Glc+PlPCITOjj0+amZ2nujSm3QKh
	GXL8RpkjgYkuY+Wx6cUyMjWzj69NUoPkCXXWjhtQCuMnUT2Bm8FrTpm8wDkjGgSN
	ZjUO6FvLKuWwE7QYwwBRgA5+6bAF5cTb4ix96KCfac5A==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4g8q2nv49f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 18:31:21 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 66225800236;
	Mon, 24 Aug 2026 18:31:20 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 7B7C9800EF7;
	Mon, 24 Aug 2026 18:31:17 +0000 (UTC)
Date: Mon, 24 Aug 2026 13:31:15 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>, Liam.Howlett@oracle.com,
        bp@alien8.de, corbet@lwn.net, david@redhat.com, hannes@cmpxchg.org,
        jack@suse.cz, jane.chu@oracle.com, jiaqiyan@google.com,
        joel.granados@kernel.org, laoar.shao@gmail.com, linmiaohe@huawei.com,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mclapinski@google.com,
        mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
        shawn.fan@intel.com, shuah@kernel.org, surenb@google.com,
        tony.luck@intel.com, vbabka@suse.cz
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aoyN8-ak5MdMIwRn@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <0d2fc2ab-333e-42a1-88a1-6bb85538cbb0@linux.alibaba.com>
 <aoyFK92azAlDAPuF@hpe.com>
 <20260824112005.856732bac3094b62a430d17c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824112005.856732bac3094b62a430d17c@linux-foundation.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDE1NiBTYWx0ZWRfX4POZUMYyd648
 PXlE5egxtKLsgB5kDgcaXQqcmlk8D41x5iJMetT5e/wAilsXl2C9G/Rl4vHqpAV4xnd6oFSLimd
 P8EvBvONjQg8gzrY6Q7jK+ydmGl3dr+ET31iWSvGIV/MyaTXQhCTc7xdSNOsqw70xR6Mlp5fzHl
 58AKF3k/3JAcPv+gVqZjhojSQ6XZf/+ydPGgX8YvxL1CGdK0sdagR7c9TWuYSgofb/Nj381wnsI
 uIeLHcrxwUpQ14Gli4jrBfHZHrC4kHikhY0NLDGEIDCbYGRoHa1dZO1hOQ0lvMbC5Ojp/Q44v3m
 QrqhUGzvBeHUYnrHAKvfggxWwKkFIHT9KPP4M8/AStaN6sSUFieCxFvFbmPtmRwm8Oyafg2KF43
 wCtakXil2LeWtXIirTCTu9NfKrLfAAIZhMN4x+rYOYD9gXp79M7GFtMkiKzUOYu/AV6teTiEmdf
 4rH2+KyZNxe+h8xf1dA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDE1NiBTYWx0ZWRfX6uJwKZTqlCCt
 aAMwZuLwgEvQ2nA4oj2lQf2s+6p4Llk+ODrr613WTamS5s5RPx5nX2EHyXLHTkSHRpbnDSXXPla
 w8OYJzpKv6ZRiX8aXgB540JvLUIlqKs=
X-Authority-Analysis: v=2.4 cv=FbUHAp+6 c=1 sm=1 tr=0 ts=6a8c8df9 cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=g3u0LPWLDYfGfufhFw6-:22 a=VwQbUJbxAAAA:8
 a=MvuuwTCpAAAA:8 a=mUo24Y9Byt_vt3lN3ZMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: DJZXb0Uwd6wLKdcdI_s2ylsQLCyv5-HC
X-Proofpoint-GUID: DJZXb0Uwd6wLKdcdI_s2ylsQLCyv5-HC
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_05,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608240156
X-Rspamd-Queue-Id: 31C7140012
X-Rspam-User: 
X-Stat-Signature: ak3mg63y8m37eo4km5scmkgz9zit49x9
X-Rspamd-Server: rspam06
X-HE-Tag: 1787596310-618466
X-HE-Meta: U2FsdGVkX1/teT7ODp8lBRhU/pOA9qVZ43Gt7KdiVKRk3jv8sI2kd8WMRVU54dhfqsNs6dO3GicCEKKvHjjhy3pSJhWRZGzVwlyC4Rte09iswkAq+h/mB7WDvJgo59GDm2lL3enJahJxkfZNnrvvEKVe6kG0CSRsHpNUdDx5XwXBXsylvMpohdGeCz2KaCaZgrADoleCaz7CUG6LoXITqeQJCMoRY7ZHmosXuT0B9xMHe2TfygBBNaoRAVwAqAthrnPkOb+mZao9ZVLxFdDI0P5169IJBrRhOa9AflCVmayLEC7gNQb/PEqiUCltaVpanrglq2gXoJ/2X4dD1877HWb3aj+t/V1tSCjME3e4DAM990Us0lvERUZp0RBSDQHkVzY6a+kgkbclbF3Z8DW5QrwmcrE98JtUq3iSCw79kTC2GBgNRRXGtXiulo12Oa0nXH06h+jk2+mJz50E2eoDitkrVR3kcPvg8/38RbjJzhB6UxW6IPrj6XIrM1iQNvHTluMMPtujn++6TLWRKjEydBu5jxeoLYJ/EvZMO1QbyRBh0s3yPn2gkAK++YPNL+r2MRGkROcJgiQM+jKu+R5h1gzfVRBCdeJXToyI/7Wwc4ZtSnLYJB+J49cKbXtV3Q1tT9Gp/f2EqY08Zd5xqdPEPA0wQiy10h2eWBs8VqfkhgYtUj+Cnjo3JyeWX45wE42dtoJ5Og5ebeCanFU+oBSwfoJLJIuZcoLt3StDXD6NtHyV0GrLGUb2MZWE07B+HrilO8bCgE1v5lE2iUeAjU+0AQSRDYeye3OyUc5FfqSWJmk4dz3sY+IzKNmxdtNQctHOWPagoBUm5rsK5wSvz2+IM9GP8LJanOXuZ0Uzom9J0WHcI8b2xQy2kznjasuFHJaOcaGuW6RO81tvyVoPRkohDh2DhJ1SLYd6xGcOaigS758m0fE8pgkiB3PdONOfsMMgtMHfrH5V/FEuwz891bI
 jfs3LpJ2
 AU3zfUSNr5Fyk2pORJJiP3rwEYEZ4N+BjxVPbzFVboWLPtTqzG9Sy8wjXfALy01U0wJgr+2OgC0IFDQGHc+0yjJPbD+V062uhZhFlaR8tsAS7eww5W68E8V/x1xzHroCY00P4U79aHtq4Rwqcb0eEXx1QBmDIikwXRBJnpVXMdamNQm/aorNA1Rdvl8QFAsSkfi0Q6IFdDLMM+8R4BAVuqf3n3KEPg8QqRsNr/MFMgm04hF7J43EYVrU7Imxr4LmrD/7gdpBYP54FMzcI2JyB3yCU8VUGdyMP8vQ8P4srqR/7t2GpbOFjLG9llYFUzO5Ybu7TMsVHMzWPgy0kWJt2F/NjapAMhFaaOfZd4CVDqNZI6bU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 11:20:05AM -0700, Andrew Morton wrote:
> On Mon, 24 Aug 2026 12:53:47 -0500 Kyle Meyer <kyle.meyer@hpe.com> wrote:
> 
> > On Thu, Aug 20, 2026 at 11:47:11AM +0800, Shuai Xue wrote:
> > > Hi Kyle,
> > 
> > Hi.
> >  
> > > Following up on this thread. The v2 patch once landed in akpm's mm
> > > tree (9ae6eefa4b6b "mm/memory-failure: support disabling soft
> > > offline for HugeTLB pages"), but that commit is now not reachable
> > > from any branch, and mainline as of v7.3-rc1 still only has the 0/1
> > > switch in /proc/sys/vm/enable_soft_offline.
> > 
> > Thanks for pointing this out.
> > 
> > Looks like this patch was added on 2025-09-16 [1] and dropped on 2025-11-11 [2].
> > 
> > [1] https://lore.kernel.org/all/20250916032512.AE588C4CEEB@smtp.kernel.org 
> > [2] https://lore.kernel.org/all/20251111231818.52A60C16AAE@smtp.kernel.org 
> > 
> > I must have missed the second email.
> > 
> > I don't remember discussing a v3. Can someone please remind me what we planned
> > to change or whether there was another reason it was dropped?
> 
> I interpreted the (lengthy) review discussion to mean that a new
> version was to be sent out.
> 
> > > The underlying issue discussed here is still unresolved for us:
> > > firmware reporting per-rank corrected error thresholds via GHES
> > > triggers soft offline of huge pages, which neither addresses the
> > > failing rank nor is acceptable for workloads that rely on stable
> > > hugetlb physical layouts.
> > > 
> > > Do you still plan to send a v3, e.g. with the disable-bitmask
> > > layout Anshuman suggested upthread?
> > 
> > I wasn't planning on sending a v3 but I'm happy to revisit if needed.
> 
> That would be best at this stage - please review the changelog to see
> if additional details should be added to cover the considerations which
> were discussed.

Thank you for the clarification. I'll review everything and send a v3.

Thanks,
Kyle Meyer

