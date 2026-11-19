Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E133606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xeY31rJJ
Received: by kanga.kvack.org (Postfix)
	id 6E4516B05B1; Thu, 19 Nov 2026 01:18:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646866B05B2; Thu, 19 Nov 2026 01:18:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512726B05B3; Thu, 19 Nov 2026 01:18:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C86B6B05B1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:18:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EAFC12095F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:18:53 +0000 (UTC)
X-FDA: 85450865346.08.9EED498
Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	by imf13.hostedemail.com (Postfix) with ESMTP id 021A020003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:18:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xeY31rJJ;
	spf=pass (imf13.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795069131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxxDsLY4ljUbTZnycMtaYb8VPGrDn2EGtE3ij7vEDvM=;
	b=eO1Fk61+YwaxBWZj55fqvP+141K03E2XtfHwikI8AZc7wp9RGbGU5nBwqpkmJgGjL+naC9
	is3dpLoBzRL9ICG4oe2aMig/NtjmM157Eue4XCB+kDfoSnEKU7gKIEyEDv/xVQO6eRp9vb
	naugwkZv/C/k2H8wXiRx3ctkqJAyUfw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795069131;
	b=1jdLp9uFP17rbLptpsnanW+UcqKBlyeCySqcrwpbopvDTqEGupP35b8SDYXE5azprY3GqP
	dU6zUZ/Gcqa+8L2zdAtIil87dRF0GZNzxF8qy4HHbPyHMiQtbVvHkql4Ly9Kea31L87FVJ
	GCmHeJwxceBMt2lv1wv4jd9RTXHHH/8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xeY31rJJ;
	spf=pass (imf13.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=t7TRlOq46p8kCi/sZgPthGD6Yx0s98cBlhA2Tr75d94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795069129; v=1; x=1795673929;
 b=xeY31rJJ6iz2DvTlXYboVccvUiS7FH3GIq5UUaSwxQF445dFVWHftLu5fWBrTiJoUZ1oFMn8
 0D8T83DUuQCkPFxA+xvITxngmBVg7FzZLdPmd4XZGJMzf3R/tzih19i5vEfg+hmqQML/2F6aCQa
 mxsxwJzH/5M9phzOu7QSisuI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 26b21a70714591fb;
	Thu, 19 Nov 2026 06:18:49 +0000
X-Mizu-Trace-ID: 26b21a70714591fb
X-Migadu-Flow: FLOW_OUT
Message-ID: <bd475114-6247-4ab8-b6fe-81724cc320ee@linux.dev>
Date: Wed, 18 Nov 2026 23:18:44 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261118212722.3922741-1-usama.arif@linux.dev>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <20261118212722.3922741-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xakyc7zgaca5h3iouxyhit675e6xupan
X-Rspam-User: 
X-Rspamd-Queue-Id: 021A020003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795069130-935011
X-HE-Meta: U2FsdGVkX18BhUtZHd9NWd2MmMB9w6+klzdJ1KfOLZOBNfj2o5m83pBL8nF7AVh7f4F5+nXLEYM+7EBqxOELSLEWvW7Lto0JillVPE1x7H5+yS1gQsKf/fhpBYsehnPr71wyJj5MzNyyAawubtwMgIGGu07nyyYQnekwNInQ4+kSCSr82y5YC/XZR9zvMNW5Q/QSn02AkgcEKGv3JoQCEMn/sLxGy5azEw80zeNPpbRF1Dg1YyvFBq3nIx29N9cZfNexcES+n7p5caiFHDprzfqis2oKyRcuGScurhi05TTLjZLAinvwaNUd61caixKjiReU29oYddlBBA0iKavlFhFlP4OcWxX896XJ+g5Z6KdVyysrWieTV+wVwkWcwolTHFgt30n2kqMwJP9NEwbpeVeL2J4wiNXL8DrXDzQ+WwRx5mNkNVUwPk8gkjymlpBvpx+b+fqArNNZuRdcD5QtJp2QKKrr4jnAimD5i4hiHqRe2QDZGqfLRyQ0w2CqtYzQbKnuVlkvORKTChTLusiz/y+XtPSb0iCAe3OMtt0rw03KsgzaSZkQondNwL8UwZncGbL0Db3nhvksLggTrjB4666If9G5pQL6FUC1g2U10AS9g5JfeTSKr53FG7zPd/XRqQRXaPognX8bhqa5QCYtMtzYHRHMCLGyqhSPFx3rdMYXho8mWqR9ank52yc9HYZA0sCvfa2dqs7D0AGReqM8hBrj5gor3sBksh1/DcRmIfqWOCe195jeuUPJs34BIKICL7v7fibJCsKaqrJUxVfsLpIXh+waQurcTMh9mEBVVefwLpqZ+yIJsVC3MOFeQ1AmxijGZH9hu4WpebIAKg7fF8RbXAZq9A3tSttbkypeNrt72rZLFOn3pNzt3ct4LWEp44ABVcQAE4StbdU2mXUSrPFfmZ+qzMkJ61AvqIoNyiqPVKJfqdlfhUH/7qvjL/sOjWA8eEmII/Gj1IEBvdx
 fffKCg0z
 KxW+XgAjnx6kVLigJpW7swnxPOXRDrX/d6nt154q0YnXIHfPKOFOY6yGnGZaM+bKSiVLl/gkDYaQCzo8ogMHLB2eJd+E0G81UYU1+xXo3VMzgT9fT6N6OEG431ftRKOzNzYvS0z1ugJMqLSwwrSsLppfeRXj+jFuCWpSZIjyzj84JoyuNQveFKiR3Yy4xTEqMQttXyzEUijCWKWFl96p2vaEANspprFxZhhQz4XS8aWGm0GOZ5t9lNFHolUcG3X4wYk7IvtEejgnz1ZDtwzWrjKMMkJHcXDPiXJ0GsNfl6tAjPBNy6GzSwr601kmIxRUUjCsgDMrbsMqSbmUp3Xda6JFBSNwHpWYDnf0i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/18/26 2:27 PM, Usama Arif wrote:
> 
> 
> Hey Nico,

Hey Usama!

> 
> I think I have had this conversation either on the previous revision
> or the mailing list somewhere else before, so sorry for restarting this
> again.
> 
> Isnt above a good thing? KSM is a memory saving feature, and this
> is resulting in 1G being freed instantly?

Not necessarily, for two reason (a), we are ignoring the users defined 
pages_to_scan, and (b), this leads to KSM using way more CPU time than 
the user expected, and in our customers cases, a overall system 
regression (outside of KSM also losing some effectiveness).>
> 
> As an alternate to having this patch, should we just have patch 1
> and users should turn off split_underused_thp when using KSM.

Me and David have been discussing the opposite. I was going to drop 
patch 1 as patch 2 solves the underlying issue in a fairly clean manner.

> 
> If you have a large number of THPs on your machine, using KSM is a very
> bad idea IMO due to all the splits that happen.
> IMO, there are 2 optimum host conditions:
> - A large number of THPs, and KSM disabled, hence shrinker can stay on.
> - Very low number of THPs, KSM can be enabled or disabled, but as there
> are a low number of THPs, the shrinker can be turned off.

This requires the user to be aware of these limitations and properly 
configure this system. With this patch we remove the weird interaction 
without needing any config changes. I think in our previous discussion 
David pushed back saying that it is not uncommon to see MADV_MERGEABLE 
and MADV_HUGEPAGE.

I think the approach in patch #2 is the most sound approach.

Let me know if that clears everything up!
Cheers,
-- Nico

> 


