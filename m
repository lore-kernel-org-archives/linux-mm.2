Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCD8EFCE44
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 20:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF846B0005; Wed,  4 Mar 2026 15:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7BC6B0088; Wed,  4 Mar 2026 15:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5346B0089; Wed,  4 Mar 2026 15:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6116B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:23:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 390AA1C94A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:23:00 +0000 (UTC)
X-FDA: 84509504520.03.5093F80
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E71D40004
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:22:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FTMkYtJ3;
	spf=pass (imf17.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772655776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfZm5vSB1vPzvk7DU/3ZCqj4liPErRh64IDVyat3SkU=;
	b=H/ik9HBw/WtBEGV6eVjGj/Ti1X0p+2abI1jBY+sWQqREg4m/hkilPK4g6annetgZ6Gp0Kh
	aLzUA4kDPyCwG4jVqGwpONhWFmMl9VGV+iMI6DpEgrwPVarVoRHYZFdnUOTsERimdGr1I9
	T3UdIbPxpzQC3Sx5NS05oSqK61eX9J0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FTMkYtJ3;
	spf=pass (imf17.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772655776; a=rsa-sha256;
	cv=none;
	b=XkLz+jcq9yjjngabhttxU9+9/SpmuVJ8u7lAg6OeDp2Q9/b8VPHH06l8+yrmX+Jx+wOPwn
	95plSBtO+fWH4yK1Awj2N6Z6CIKKojflOfWcFPAWhpeEAkQTNIRH0M8Z6k2N1CR2/VJ828
	qT3vhxSI1RHmW9wZlGQHnrRGAXR9lLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772655774; x=1804191774;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jfZm5vSB1vPzvk7DU/3ZCqj4liPErRh64IDVyat3SkU=;
  b=FTMkYtJ3iz4jOdpBgc+RwyllSaBWMV9NBEue2mouBs3zzTmC3YUFHVlz
   M5HDlhoGVNgeoZmkb4yMU4MOM3YkkqW85f1V8bIdzGAT6qcKVIJ8a3/H4
   37r0bS3QKxYAE1F9B05FDch7jnvydLE0nqjQBB6bWIqE3C+DzOLppZxVf
   +iV5aUD4PKH78aqPOEj1fMPFdgIOeEqI9HLfSGgxitZNlFuha6IIYUQiF
   rz9F9/7VNLgqe0Dkt+VXuGagqxIdmzFZfWL/1HAnHmCJtqa/T7H+47RhL
   LO1WwogecVoDKeMPEwUol0xs0zn6EhYeJp8Q2tPdc9rTem3fxAoSujvsO
   w==;
X-CSE-ConnectionGUID: AbqoP+d2QEqzFWIaRbk/Jg==
X-CSE-MsgGUID: vej4zB5FQcKRP0wc+nCd7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="85077238"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="85077238"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 12:22:52 -0800
X-CSE-ConnectionGUID: OzPxF9lORb+fO3kerP7c3w==
X-CSE-MsgGUID: BRuPXwfQRGms1xwwyAoOWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="217688413"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 12:22:52 -0800
Date: Wed, 4 Mar 2026 12:22:51 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH v1] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
Message-ID: <aaiUmx8yRsn2LBMW@tassilo>
References: <20260304155636.77433-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304155636.77433-1-david@kernel.org>
X-Rspamd-Queue-Id: 6E71D40004
X-Stat-Signature: ezysz7xpg1yp641z1sny47esx46juqfd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772655774-664973
X-HE-Meta: U2FsdGVkX19bY0lmIwaDMkPVaIIjGcABXsRdd1TgLP/xWKWy+Jy9FK2a2T4qsI4bonXxWVqdfsn86EjQDok1Fj88kYTgPbuYyfmAkCWnltDaavjAnOukmj63eTmzAubl5S6hbcp//2ZVHoqIFeB911HwocKpf6q+2iWmZYAY5gmX4ecOVTsTNss91CWtqomPymO1jzdFej0hctCnY2fQDw8ObPijk5xP/8SFnbVKnCGQqj5tSC1QYG80ZZjET0tVQP8w5VhWP4H1CqZvezvR3ADP20vM2RQyXS9b3jp5xQkpRyHBz4M7Rbt9qN5zMUgVz936rTkg1trsKDyOqyztdQ9FJWuky0hP338zB7Cuqo7hPMrGzCJm0ohj7i3eTVkPqQOAsW5YL03wSBKgHoHRIKCu8vKIXDe5QMnh7ulaD/rpPBFAyTfsW906plvOuICL5tnWYeEt8DZ67WZ16Jq+Qvl6hLJRNVN9vRC0MLbfXjzuExBDuIMxsuIzCChWBHLsyKtAKoAvHg/qi2RaNpl8NOeLcavwJc/ErgfApdNwSCzl7VXxWWSbvEjv+mPsn052Pt+an+PoOQrjodfTR/WhFa7TTuCursm/kxUENOhApdryJTfX/oaO0QvsR60jiH1jFvU6mggBAtPqx1AlQZ6YcikGCI+gkjUPcTfMQGBf4itBmxCdKEfkOePstHuHhR2HwFYw7HmHPr7iOrCaJhllCPFN8K9DYgOvVq4y+OcQ4lhg67FHr5zfCCu4fI4c40hqzRzhI8WwkpgQL7426PDhnJPGqvOGwXdbKef1WfEP1aZByUEqYTqy4Q6sR9AiQrRiuYL2uxoyMORV0lF+ilGTEsVijnYzevhGVLFkV6knlbiEwqd2BwBwAnih/XYkuM0seIfIQYGfHXgW88OivvYvcIrukuqk5WwGyA3xrYpMcCQpqh8Sxt+4yt3lS4ZfVFq0D9zeaR5DquyMJQSHQPT
 GV6BwDHc
 ruKDhadWNMChr3VlWRwON3pJsJx0qwi75sQCuFZkk8hnTBub8v4tkm37BIQ7At/+p4gBHXfcfN490ThytLHKMGl4Fygjvr8ydqDnmvvNN6H17B/7F5lVmxVwBw+nuExLlb7gQRU3ryY1hlDA012ZljHVCj9WQGlsyx3aHiJxIcDn/wxZ6jW92QK1/W2kGJs6HzDB1/Kc2GUITSoM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 04:56:36PM +0100, David Hildenbrand (Arm) wrote:
> There was recently some confusion around THPs and the interaction with
> KernelPageSize / MMUPageSize. Historically, these entries always
> correspond to the smallest size we could encounter, not any current
> usage of transparent huge pages or larger sizes used by the MMU.

It still seems like a bug to me, only documented now, but seems
I'm in the minority on that.

But anyways if you change this file you should probably remove
the duplicated KernelPageSize/MMUPageSize entries in the example
too. That triped me up the last time.

-Andi

