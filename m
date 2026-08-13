Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F02C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98756B051A; Thu, 13 Aug 2026 11:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F426B051C; Thu, 13 Aug 2026 11:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E046B051D; Thu, 13 Aug 2026 11:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC2B6B051A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:04:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 183ADA1BA8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:04:04 +0000 (UTC)
X-FDA: 85096566408.16.10D3360
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 666B110000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:04:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJJA+LTJ;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786633442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUx/HV/mY8GPcWaJmj2Bcf36M6F/pfZ1KaSoB4Gw+0s=;
	b=NrE/hgmu7qfNk81ToEhsrAFZyFAex4ncQOE/u+RtJPXUw/3NTCGs5Q9n7nM3y6MvX9aa7a
	dwQP580bmbSsvZKNEnBK3wjtvJsR8xQAOcxbkxhwzi3q7rGM85gDFSasF3Q1vDFPNDY2FT
	CrOIpp2waG6H/q2tdCmzcKrfhPTOSW4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJJA+LTJ;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786633442;
	b=FSRzjUdImnBJS6I4pWZzhXjYZcGE8YGPy+76zYdqVte0jodN2GoOqDlyH+kjap5h+EDYQ/
	s1TOTLCc76Qjwww7oOzuDhejtAQw+VRFZJ3JPlYoE3wEyXdo4ZC2vzw3SHuRLuHAdjoL/6
	kHQsmPebDuPLnWYwZ0rJGfetFREDCh0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFD3F61878;
	Thu, 13 Aug 2026 15:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03711F00A3D;
	Thu, 13 Aug 2026 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633441;
	bh=EUx/HV/mY8GPcWaJmj2Bcf36M6F/pfZ1KaSoB4Gw+0s=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=CJJA+LTJ3eAHgzpkzyBDL+mVKOec2R+daIBEuQr8Ehs+16/Col/yJJlFgxht0s8OG
	 gWWlf/fQO3uPbvdQrjnLlQmFqr/mDVFpITKc0RwBvjO8cWRplq8DyJDcaEDHIuf/ga
	 iEXFojuiMwCqQ723FcoMyJQOO6fyQq10klyp6X44APsq73+AY2BClzbui7Gu/M6pM4
	 CJzdMSpark1r1+BYhw7Bg7S309jvBlxdhhIxzSmQ2rCA2aanzG2k9ExxMDkGGTStGP
	 dAsigcIpHCVvcHTOUoBWp+AM1wtPAwQMd+bMbKFjPdkqJv0RoXZ08pKKi3T1SGyWCT
	 +Aa8Gf2BA+u7w==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 04/18] selftests/mm: skip khugepaged page cache
 cases without a PMD folio
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260812132304.199287-5-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-5-kirill@shutemov.name>
Date: Thu, 13 Aug 2026 18:03:34 +0300
Message-Id: <178663341429.2230969.14030646208213550752.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 666B110000F
X-Stat-Signature: g74nf3pk6jssus64my6499mphgpkjr4u
X-Rspam-User: 
X-HE-Tag: 1786633442-573177
X-HE-Meta: U2FsdGVkX1/xM+C34TpmFEkhpFxHSQWue4fKGr2g54q/mqRQEnnlqXafBvaXhAASZ9+Szccb533m4ziulhBK/TMAP+ernRAcqRTQisWkD7PYL6DJXtp0H+XjYyRVGi4GYb0NUS0R9tyE0S47uLPOrvhSJET38u/PAVUKBvzvEztLXzZMJkkDH0INex7u7xZ8czIQyDaRVEK8IwnfasqSJ0isYOATDTOkJKWqmns87pDh207zipSvNnmdBeod7B4p9qVMzEO0rM6htvBVqduml/WF8MOJsaj22yuf5RAF+ZlFcD4yw00nZ4Nd8wRpn2ENpDncn/WBKESKeKYlE6gSHlJ86iguBqBQnDde+g/DjIrls3OBeNhh4D6phe98aQNDLoc11HCbVAuCC/igmDNy65kRJJdPeDNf0o9scX1OMngJIk45UV+OEcZZ8rydf9L1G7xHEqC7KJcj1oN/JgkZx3cv8+Cnyw5icHgPiAIFx0W6af+KFlrIQ0/CmDrjfEUhVKoZflQgmVmjpr715JOQez4EhIAxY6cVTiWjIzoZInZv99/ttXnRhk8QowD/cR4Djm4BgoQuiSAoRQFFbZglJSDbQcbwUm+WnaueNRAbVqexZ88UHHyTQsCEDR+5WORJxcEZV/R+OCReXXtkM380ymuySptFkPa6WxViN1E5bfXHxOaUv3R9uA7feeUE+ZTHYMGzJ+31DneJYddpMECFCP8l8Y+pYywRaTQ+8ieLnkkUtEdhU0xWaySYh9BQyNbEVapis5au2oyducHWecAqaN5CYjZCxiNMwlBN8orkP5DvO37/Z2r2nIR2mOVys7o2VZXRwGD5UovcbOXBYUUswz+doZ5vksNRmL4v4liEWb+SM9DqyUJ3kDo8V29wJpw2H6jFVER1rp7++Pe8WBj9CnvekMlErjuKoymcWaZcrkXkfzq9xVb33gGOP6r2JY2p6if7q/OyD4PrmNkqwS1
 ImboZ+Zc
 jLidCHa22djUBXJmRER6LuFwPuTMKicqPfIr662kquSFD06L0liWAs4DqmVCbiPy/DY78IFHeGoajwWIC29V1sRpAR+7pglBZFVVt0g1uG0bcvSaC4E1j9qqqzh5tHqzAxpm1hZ0tcyz1rMaRhJwhVYRRKtAlpqOUjIrH0rojbMcUA3jybJ/7PmLGxRHTI+GC9Tp8kETXmm6g/eQ3GmDM9+QiQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The page cache caps folio order at MAX_PAGECACHE_ORDER, which sits below
> the PMD order where a PMD is 512M -- arm64 with 64K base pages.  A

"which is smaller than PMD order on arm64 with 64K pages" reads less
ornately ;-)

> PMD-sized page cache folio is then impossible, so MADV_COLLAPSE answers
> -EINVAL and khugepaged passes over the range.  The shmem cases ask for one
> anyway, so four of them fail and the run bails out in the middle.

shmem asks for one who? 

> The cap is one global, so it rules out every file mapping, not just shmem:
> shmem_huge_global_enabled() drops the PMD order from what it allows, and
> file_thp_enabled() refuses a regular file whose mapping cannot hold a PMD
> folio.

I had hard time parsing it beyound "the cap is global".

> Skip both mem types when the PMD order has no per-order
> shmem_enabled control, which is the readable form of the cap: that control
> is created for the orders in THP_ORDERS_ALL_FILE_DEFAULT.  A run left with
> nothing to collapse into skips outright.

This should be a paragraph on its own IMHO.

-- 
Sincerely yours,
Mike.


