Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20CD8CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515AA8E0009; Wed, 27 Aug 2025 14:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6EF8E0001; Wed, 27 Aug 2025 14:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DC6D8E0009; Wed, 27 Aug 2025 14:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4A18E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:07:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF3361407CA
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:07:49 +0000 (UTC)
X-FDA: 83823320658.10.9280F4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 00C2A8000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:07:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MCs1vENy;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756318068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxBHO5QHOAFZtf3iYkxDge9jhgfV6wOsD/fh3BpYzKo=;
	b=ctAL7JTk5GvGgBHNWUU3PGQSifY4iGE96fVQ4iAHcAusCPBFx65QXWl4nxZM17Y+atsR28
	0lFkCoSVUY4a8QJlAGhzzxm5NGKbVBaQBW1/pVne2d8FEA4cf7UdldBTTLxf5RylYFYtMP
	A3ZuJG0rTL1qDdK8RHoYIgZ66EgcqsY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756318068; a=rsa-sha256;
	cv=none;
	b=GsvdOzyM9t2kKwZJHd3B+w3w2pKqgd+RFK0yzhpTReYRYtpGmuaBzCxgYZloA7oe9f4M4X
	Wj7E7wrqnJ0svXewGMPb1TX9pw3u8pmwC3iu5lcC4JTrtEpEzy/St9rmUQqEfNX8SIL7jN
	YmnokfWQWE0pObIuSEAW/7+Zg5lse/s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MCs1vENy;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4469560281;
	Wed, 27 Aug 2025 18:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58D2C4CEEB;
	Wed, 27 Aug 2025 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756318067;
	bh=u0yRpz9nPUw7n0Wvbb3I6ZaPCD/6ktT6MO+LuMdPTX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCs1vENyD+rxiJfUXqpEtZd1RAFN/vrf56+/KcrMyqFrwT4Mv6QoI2TNL6LHx+U17
	 +I1v0LPZj//CZDW4TOs9Gzm5hFZFD57vCtXy1R5CIdPjqfR7mFq+RdM3dHqUkUJvUI
	 OcskECestTxoUe1P3i+EYoTOjd/95xKVP5uLM5Ht+v5kns1Jr90cpCt3UMwN5bihcf
	 vYLDA43Gy6L0H5KxjsyqA/0oWuo2uBhVn95swjN3B+JZW72aimIsgDfVxi4jiaQuMl
	 EinZLRr3+Q47NGCVGujNw1sSO3InYaYZlO/MzjqIXmPjCRLtNY3HkHUH49hvz3dp6j
	 2124axhtXs3sw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Wed, 27 Aug 2025 11:07:43 -0700
Message-Id: <20250827180743.47876-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <890b1575-abab-4b3c-8953-110e1dd3f9ed@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00C2A8000D
X-Stat-Signature: m3upe8u91jmo71cfk79r4ya5gys4aak6
X-Rspam-User: 
X-HE-Tag: 1756318067-294380
X-HE-Meta: U2FsdGVkX18AYGeXMfDXrRYXo/zgzU1Xc0QscDfPfCgGlmT3mmhSv9D0cxnG+sipA6UZn6sKEE101yojAnHNwFjNusDe4erFjMb3al6Isoa+KHGbzQyC7CKa0C5qM3pW5hegkQTxnaPoMh3E+1Ykn9Xz3kvFjbKwC69/okPZgpAITn8mt4imehB5h4rLIem1TqhAZyWkiMkQLN/SZe9lyEg0xfI9Ffi3OTb4cRwXeAMc2dsGNYGDMjPnFfHvnXrfftuUzBoQbymgeCkjzLUjqfecaFgIacMCmRjSnSx+6N6npewhtq3z+uNWw5AFdrcI/s16uhPhCh7XbZdW8a3cvJCOjkZFH8wGAwgb1GhjLRq6cBRH9qcHrxoSQJpRRry2kCSW6roEose9OujJq0iZYv/3JOsSjQMy2bGfjhMRymXcuURduFEAMhfd6OPcLZsG6Sx7MKPm4fybuLFNOIbJ88cYC/LFDpBbQ3xZaLw6E/s2n9pFHwMJiz2/OWi+pTv+1ggf2fHVCGRDtx3uSRnmEivkAtkk9LDKi5kfHYPHxyGVqJq38/vb2fIG2DkNnnL7KVJfW8Dxrifb39KQWa5/lEnzOZ4LbBZ8oBHAbctkSIQJV8Jn0swCJSHb1IT7Yj51ZtKsbMY5urdeTrGp3wmzSzxarAAuQR7BfwkYvr1pIBUbqGYOwBLpJODD13VGmOMZ5FRIaYZqj2dn4ekIidVl+kh63QzYd1d97Zl+6uILZVUyRiM4gDXFPnpDZOJolkdYzOn79cTwwTMHELtfyjLd/e1DJg62JUp3+L4o7PdlwXTfcZRoRMy3p6++9Tn3wSdg2lCrFyaoQRrhqX7bVe39O+JaDHaXx75Bvg4ycO9T9QJvwjX03z78aUXaJns6YkPgC49gWLATqQ2KOlP6NBVVSf7uOW2rifWaDT+Rgx3QIqth3D5OWnp1lDNzTFiDvdYveFytLtBud/+oGvB3EXr
 KDBCTWAP
 XA+qojN3vUgbCtHUioY9NmBxpdFk3DmDsPfuy2xqMFD5Nbyi9MvdTVQZxsvnlbKBLQRZL7L93GROkJ5CWHGycO4i8yJBtdxfQDyObGHPmXHy6mDnjBf6HxcW7wiXoQ7uTmaEQlKHFS7v01nOI9SK9DfnsbEZf8HAnh40QksK0e7/f5ZSUHCW6GJVHHSJmxeBkjBQGeTEwfUAmwUdwEi6ZokNb28+F+oh+KXELFp1RaP8OKIi/Jik4SQsgOeiAeOPUefVX/ArTmO1Ts+MUd6CQEBCvIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 19:37:38 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Hi SJ,
> 
> 在 2025/8/27 10:42, SeongJae Park 写道:
> > On Wed, 27 Aug 2025 10:21:41 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> >
> >> 在 2025/8/26 22:21, SeongJae Park 写道:
> >>> On Tue, 26 Aug 2025 12:51:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> >>>
> >>>> Hi SJ,
> >>>>
> >>>> 在 2025/8/26 11:21, SeongJae Park 写道:
[...]
> >> Please consider approving this fix.
> > I'm yet in travel, and I'd like to take more time on thinking about the proper
> > fix.  Quanmin, could you share more details about your test setups, both for
> > the compiling success case and failing case?
> 
> Apologies for disturbing you during your travels. Please allow me to explain:

No worry, I'm the one who would like to apologize, for delayed response :)
I'm back from the travel, btw.

> 
> When CONFIG_PHYS_ADDR_T_64BIT is enabled on "i386" [1], the phys_addr_t type
> becomes 64-bit, requiring the use of the do_div function. We are in agreement
> on this point.
> 
> On arm32, if LPAE (which we intend to support in this series) is enabled,
> CONFIG_PHYS_ADDR_T_64BIT will also be enabled. In this case, pa / addr_unit
> will involve 64-bit division and similarly require the do_div function.
> Obviously, such link errors should normally occur under these circumstances.
> Unfortunately, the expected anomalies did not manifest in my previous tests.
> This may be related to some incorrect adjustments I had made to my local build
> environment quite some time ago — though I cannot be entirely certain. That
> said, I have since cleaned up the old configurations and ensured the current
> environment is clean and normal. For now, we have confirmed the actual problem
> and its root cause, shall we focus on fixing it?

Thank you for sharing the details.  I wanted to better understand where the
issue happens and not, to clearly understand the root cause and make a proper
fix based on that.  I think we can now focusing on fixing it.

> 
> In summary, after introducing addr_unit, we expect that any 32-bit architecture
> should support monitoring of 64-bit phys_addr_t. Therefore, we can consider the
> following adjustment:
> 
> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
> 
> Or at least adjust it to:
> 
> #if defined(__i386__) || (defined(__arm__) && defined(CONFIG_PHYS_ADDR_T_64BIT))
> 
> I have thoroughly re-validated the feature functionality today and confirmed the
> correctness of the aforementioned modifications. Therefore, could I kindly ask
> you to consider the aforementioned modifications when you have some free time?

Thank you for the suggestion and testing, Quanmin!

I was thinking making the change for only i386 is right since I was mistakenly
thinking the issue happens only on i386.  Now it is clear I was wrong and we
have at least two cases.  And I agree your suggestion will fix both cases.

But I'm bit concerned i386 and arm might not all the case, so wannt make the
fix more generalized.  My understanding of the problem, which is enlightened
thanks to you, is that not every config supports dividing 64 bit with 32 bit.
And div_u64() is suggested in general for dividing 64 bit with 32 bit.  So,
what about making the if condition more general but specific to the root cause,
like below?

static unsigned long damon_pa_core_addr(
               phys_addr_t pa, unsigned long addr_unit)
{
       /*
        * Use div_u64() for avoiding linking errors related with __udivdi3,
        * __aeabi_uldivmod, or similar problems.  This should also improve the
        * performance optimization (read div_u64() comment for the detail).
        */
       if (sizeof(pa) == 8 && sizeof(addr_unit) == 4)
               return div_u64(pa, addr_unit);
       return pa / addr_unit;
}

Because the sizeof() result can be known at compile time, I think it shouldn't
cause the linking time error, and I confirmed that by passing the i386 test
case that kernel test robot shared.

Could I ask your opinion, Quanmin?  If you think that works, I could post v3 of
this patch series with the above fix.


Thanks,
SJ

[...]

