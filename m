Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C43CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5A98E000D; Fri,  3 Oct 2025 13:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6B28E0005; Fri,  3 Oct 2025 13:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC748E000D; Fri,  3 Oct 2025 13:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2323E8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:19:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB503140858
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:19:48 +0000 (UTC)
X-FDA: 83957465256.06.01691DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 22430180011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:19:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1tahpCr;
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759511987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61DBDJbMKe1+3EORcKB24f0U7n8ePLnHufDsIEP/vPM=;
	b=aLFci9+uygQ7MxUaszvTLaC3lQ2irUy0gQkTUu7AemiQ18JQ98e2BU+yUg6OP9weSfz+CT
	M75uWPVI1ytFB+PJ5BTzjAK5SDbEZnEjefogC1PGWR8XmCJQKs1N3z/MDBIVJ/a0anMvh6
	0uIidrQ5NOLFwNw9eHXFu0HC0Nb+eT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759511987; a=rsa-sha256;
	cv=none;
	b=PErdSyi4zHQZeTt6LUuxYg/7YpWIkzPNI343QQpCsrDdOIi78ZAfIkHhQyp663i/z77Cxc
	+zgqkO+R9PwRa/hvo6Awsxz+fo694dGn2QlYcsMGKwB1mwulKZ9LyKJAWuXUVTZKK50/I1
	Fn/Es+dWvOIqohxrjCNmXHGkrml6rpo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1tahpCr;
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F8B661148;
	Fri,  3 Oct 2025 17:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAA0C4CEF9;
	Fri,  3 Oct 2025 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759511986;
	bh=GShFWIQ3nrEgTCifByOJt8FtOhCMkv17vq1x8IjNKfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1tahpCrkVyBq/hq4ygwhyX+rN5XmYCG4Cbhv+cLxQLg69tPDE6WPSDVuzIQmVSMp
	 hoGIUGLh6WEJOfkk6R+ttsqMvJVgziObApVcSVcWUgHRl9oxThjQwGOB+6c0OjWI+O
	 DCFhnklNSs5V+/dgDZTnQBaF4lSxEVB75wQl1VI3zwzJ/wbrRHVkjm8XyHzP8Ry44Y
	 qpryHZyAFVpp4PyaJ5oJOpMGaRKL7OcKxpMUT7ECI94fFgNY4ZbSioZI8fncQ5Ogff
	 WoccmPaRMF4yS1PMjEBSCY0flx7L3y2ZcXMldsR24TGH+frFPcOIQX71quEIpNG7tt
	 xewrc58DrkrZA==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	Gergely Kovacs <Gergely.Kovacs2@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] arm64: mte: Do not flag the zero page as PG_mte_tagged
Date: Fri,  3 Oct 2025 18:19:38 +0100
Message-Id: <175950165527.786497.14310575132704411238.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250924123528.1536835-1-catalin.marinas@arm.com>
References: <20250924123528.1536835-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22430180011
X-Stat-Signature: tut8xytzn1rtu6m7dmbimmm8ueyajy3t
X-Rspam-User: 
X-HE-Tag: 1759511986-924415
X-HE-Meta: U2FsdGVkX1/wwWlT30vAYhwjtX/2bRcjbeP1QGgV88oPPkQiowP2zK410LcbSyJ7qWcpgBybFlbcZchmcEBYgTLswmtP+VRD7eDatt/PS89lEZ6uq5QnwCs4eKHMnTRsfuBGFQVdPvLzkGubcTfLMHbt5IBMX36eYrTFYWgLi6cr1yOcy2YfqstzJ3F5ZI23hm1GBZxDGgv8hI89znKwWfJq6yl2D56Gozn7jORKJyZljLJcEf0uAHNLNFLYdyhpdx4v9IvxbZPBAFoT1gcO/Yj78E1FUd9sM9x9Y63q9jq+JaNgLKG7Ho13LxQUD4aFwfTWAJyEjGnM0lH0TuYgGpRF4W+1QxT1/I2e+CyA9cz0CekQ4gr+2i1OwY+0PbXlq4NMpZoMgiukidmdozw9xuOmLalCP4jesW1/VOKjByVs7HiUQ5XukVlM3PyaBoV4l2VjFFQ38P5N1gVmgLBjrgf6YFYWvf3VonbHQCoXB0YW/3+tfuYiNc033sFkpDaxnyhMRh90LpSEHQQQGM1gu7aifTf67EG+8b+RT/DM+4TpMJ8RZ+igtbq7eQ466AlSOr42dC3Tf5JWYuzCsxkPl3wTKY3/GngosgwHtLVOoxnCExjhOXi+VS79TvnHszEOmt0BNK9B/rcySRG2puTplpSwwmqXhaaE9LOWxZ+MRA86XwgsFqqNlUcvYDjUkRFsR1funziV+tzBwjuZrfVLVxPwsWXq7YTTKKNx+m/Y07nE555lehYPqg94/VKrPTX3t5wWSf2VTrCMMz6BkYML13M0puyzr5T9GY9Jharv4B2aQBIXcsAD7B0u3Cw6T+51+HePrnx/N2AYqXo7B3oPYsMs5B6sFScACMYJgw3w6RWWlKdOucq/JiYBJqeM5Vkf7aAwO8fYjG/Mu32SFBo2VlIkzUG8z65UDDZgApdhAEdyt9RC/IL6B4UF5Se9q26333ky/HdKbCKp33xjE91
 VgsIt+56
 MBF2oCdTrIj0idXOKhrVPQ/WOz0Koo2ztxxSGVToQ/hsDLXfQ/1P9aSrt/6f/d2EJGPHvhnRbSXkfukUPkKKuYxmSAMRk6UFBJbU8TFv7kul6DsAnn5AWSa8vIRVz7R6+nV0fwIZqjo//xPQgwGOGVds8rRiUr4GR0jHbv+4leqz1XVJKtCWsQmMPwveiq3+RrHIxOE7CzYZczB5jrb+5W93VimoOiWuDbk6EZb7QN2PD5AyuxXSQqOdt691skIlUQHYNlBdiqHIXvHuY23WIez5Y+X8cWNqMyJo1YeqCtCuBh9s3L4+FfktHcJB0RC9ne5YeED6yc/BR1SkNLd7/WCrj1gA7cBX1ZD4e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025 13:31:22 +0100, Catalin Marinas wrote:
> Commit 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the
> zero page") attempted to fix ptrace() reading of tags from the zero page
> by marking it as PG_mte_tagged during cpu_enable_mte(). The same commit
> also changed the ptrace() tag access permission check to the VM_MTE vma
> flag while turning the page flag test into a WARN_ON_ONCE().
> 
> Attempting to set the PG_mte_tagged flag early with
> CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled may either hang (after commit
> d77e59a8fccd "arm64: mte: Lock a page for MTE tag initialisation") or
> have the flags cleared later during page_alloc_init_late(). In addition,
> pages_identical() -> memcmp_pages() will reject any comparison with the
> zero page as it is marked as tagged.
> 
> [...]

Applied to arm64 (for-next/core), thanks!

[1/1] arm64: mte: Do not flag the zero page as PG_mte_tagged
      https://git.kernel.org/arm64/c/f620d66af316

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

