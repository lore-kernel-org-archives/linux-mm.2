Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A884BCF58CC
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 19:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D176B00AF; Wed, 19 Nov 2025 14:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954756B00BB; Wed, 19 Nov 2025 14:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869CF6B00BC; Wed, 19 Nov 2025 14:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 77C656B00AF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:12:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CF2C59B63
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:12:51 +0000 (UTC)
X-FDA: 84128303742.15.8669967
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7146A4000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:12:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iRrAZF5f;
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763579569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HTJMZU5A6kXrmWytCxaO95cgtDo5F6WqG5vGLqokbQ=;
	b=tghVBdkJ7KCgdLK0m2tvt7Lvx6VSUWYOk5vQmQxBt++cq96puT9a40KBdN8pXOK/75ylXz
	fmLD6nAnkMoshKTesugoKJ098lHVgHwvCUO/5FaVo+492gjyalJ2bAK2Qjh8FtvcjAyZMG
	9YddX/aMhlMdvu8bgEGlut8VbuiHI+I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iRrAZF5f;
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763579569; a=rsa-sha256;
	cv=none;
	b=Pc2YqjOdmTHTCn2xkqeNPc/+V1gONuMf6rqPLhUzbkKTSdBAlvzncvLobkMhlOMS7tbeL5
	H2Fs4u/WV/gEv0hoHD2f8t5ZsSMH78gU2IIZnOQotyhh6ZCiwXVEGP4nWRRhPUXDjC+B4q
	GXhbqk5HlmDBZIYlOQWkbbdFrP0afeU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D6D743356;
	Wed, 19 Nov 2025 19:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27586C116B1;
	Wed, 19 Nov 2025 19:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763579568;
	bh=bjbS5c6QBCQhMSLNZyiSFoGDxCB/KqDWFIBeYfD831g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRrAZF5fWDGw5ziNk1qW0owFpHkrvRp09md5FyvbC9ox85pQvNPzEpS1JoNkyfS9g
	 UpqNjgL7+gPADjk8FP4QthEcYqrVgR6RPhOlLn6C3ThKqemnbn7qAZmXgHV0E1AF3s
	 jfy83EEkqQNN/XS41AsMPRCgl4Ef3JWTiKbze9LCLMtMTcQUitKnbxZaijlo0a/fcn
	 FWLsZJpb4ruXbXlEf9udvSwGkCcVSsxY2e25Zd2wxHF5wWk4Wqiue1hc7xZMMY/06d
	 RDTey05/00NQPqBR6CAoe64pxxXgyTMJEirB18lU5HSucVfYScd9Fmg9cpd/D2dW+R
	 /bVpmIK8poWtg==
From: Catalin Marinas <cmarinas@kernel.org>
To: Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH -v6 0/2] arm, tlbflush: avoid TLBI broadcast if page reused in write fault
Date: Wed, 19 Nov 2025 19:12:30 +0000
Message-ID: <176357954996.2095484.7552035917547182661.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
References: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7146A4000A
X-Stat-Signature: cshg5f1xpd7ubhcmxw6k91hx8bdm63un
X-Rspam-User: 
X-HE-Tag: 1763579569-877602
X-HE-Meta: U2FsdGVkX1/VfT2C1VLdr1NjkB/XWZthEL88HqYJpkr7ovj7FgaPZGDcttriftuX4MG2T1IdD5vFf1kR+unJNPJNTtjeWRkPcY0DrLLu0GUBI0efU4G8zbzITtA73BvX78rCWDpmQGsQT+oNnEXCuJzABHYEpNR7dLhYHBaFC/ztWXgOFk0ei5JcD3j586lmkjZIVo+sjkte4A21rQbTV40GuEZOQY7BC37lLIp4Ak5siGGNF3XfDo2iqA2cFwaG+5Y1sHa+4XzcVZfjNTjf7wIFQESmbE4FhV7eESW5grOt0OOs35HCm+WViEPdcKqmxwGZBYZ7PMUeMDTcl4DUmAUsYru02Twd1Csl5kHYEdh5iIrjXSPFGRexqaW++4zRgJC5tq0lZ5sP/ctM8XauWQssLZyVQ5dmKTiOVHfXcOpTO2tNSG4NgANcZhU2OjRfOkXUqo3cXDMrAaeKCAzrb6xokjrZJkQBvhHF1ViWtgkOXn9AEDIXBdtwu+Qs3vB+YV4rg0yIgnolti30uS0yB+owBt3MO8zArOJahO36Kb+Y9dmvkX6QmIKAqNFxed5jRTNcaX1tcHbgJ4vgL3GDPDDnG8yJ8aeBpfRyNBdofl3HurOUzxni//AmniqXYWxrdI825xcUhQ/VllIzos6QhsAPg4nOxfT27jkOsK07tH0KTNyZVsE1k87/f/GHjxkJT1eVD9z9HhfX9URq/IOY2d3WySQsgSRKdjaowx9yQAtfo9Qa0736BdJGybJo/YnBt52iQ0CHBg6ReZ16UU5LkYG2UoH3QFoGDmgCv2bRtC4pKz4MhDQXibEyxLVtx6PLI+2hZhIavP9aT9BdboIZPFhrhraB1SrZxHk9W4poqjkC9M4sfMWMbTfbcVssFXbfHqqHHNvFqTfVXExSRG3a51hbJ4/MGzBh120jobFq4WgfdAkune4MgPP/VwzpZ9SWJDCjclVcTemf5uqmEUf
 PeepJWaz
 5I/j4zrHd6NdunltdV5AmWc2YwVtt2E+zE9P1J4REDAzu9O7WZ0xtDw4WzgWrJXHgAN4acXYHEos+SH5/o2n3ESh1tTZYd92ih24N16lV8FA/7ODk5avhiswgK0jLYNITp/FgzmnOhUTnFBx3MhpnJXr8ZEq1qRqpZGi5hpv12InqXofOgKrPH94Yk0HI2ONlTIYAcyj/uZ7MBMCJWd92bxulYLZxJ7ZQ+l+VmYxNiX1sljdLoNOX8V161YIdul6oJq3JuqJ05du+qQE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Catalin Marinas <catalin.marinas@arm.com>

On Fri, 14 Nov 2025 16:54:01 +0800, Huang Ying wrote:
> This series is to optimize the system performance via avoiding TLBI
> broadcast if page is reused in the write protect fault handler.  More
> details of the background and the test results can be found in [2/2].
> 
> Changelog:
> 
> v6:
> 
> [...]

Applied to arm64 (for-next/local-tlbi-page-reused), thanks!

[1/2] mm: add spurious fault fixing support for huge pmd
      https://git.kernel.org/arm64/c/79301c7d605a
[2/2] arm64, tlbflush: don't TLBI broadcast if page reused in write fault
      https://git.kernel.org/arm64/c/cb1fa2e99955

-- 
Catalin


