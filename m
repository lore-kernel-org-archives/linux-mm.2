Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945ADE92FDA
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 20:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BBC6B0088; Mon, 29 Dec 2025 15:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38F66B0089; Mon, 29 Dec 2025 15:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45266B008A; Mon, 29 Dec 2025 15:52:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94D636B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:52:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64DF7160912
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:52:05 +0000 (UTC)
X-FDA: 84273705810.13.9E5A67F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD7ACA000D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:52:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uYxC0MuI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767041523; a=rsa-sha256;
	cv=none;
	b=nnqiiBPpQnGcNFyRui4kJJDvy0+Ms2CLUi4HN3WKVbKL93L3AAHIG+v5bgO29d6LGD0f2/
	Zxr4Aa1obglTSeLV1gieTUfsDK99LsemHEBtQLaXTc6Lsyg/MaGH4NSindEZzVMnYvHYIN
	6HOF3yAwZJjvO+OpnmlPmUwW5uHnXME=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uYxC0MuI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767041523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hi0GrJZ4YN29uQ9QPqmJPPpE3C5k4tOGQyy0CnsR7TM=;
	b=v7kojhIiP6h3qB/H7RwlhckLU00wM51CSL8CO1Q0I7E8rGwvlDjYqqauC64UbEeDTdN5EZ
	QeVdLv68i1QPARpNcR5ryqle/8TEBYyBwY/OFgCr+Sl2r8OT/7byEKZgIZoB0W2IDrtcIr
	b2cf6cVFZ21ui+haKVSFZs3djrLZCII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A01FC4068A;
	Mon, 29 Dec 2025 20:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BDAC4CEF7;
	Mon, 29 Dec 2025 20:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767041522;
	bh=gf2adx8UouOcindZNtVGcyMEXzTGy6Y2QNMT5Xw5+SU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uYxC0MuINO52iJzXziNfZI64f+MTuXZFbhFN9xjylM7RjK/84ceUORZtERiR8dJZb
	 mdicwdgM7i+9koMC2IPgyFSxjh81NuvI/CEWHrBxljB9aVWrFoV8JrnaYi8WdcPFNk
	 u4K+TlqT5LHUo/S/DFLKTpIZO/cI92UOJFtmbhZ2+0HdH0Zd0zP67DstJeV5UjyCg1
	 0czwSMk03iF0LQv18fkXUw1jsXklS4BWFnX3vPo7y69CKrcDgU5a50xMDX10CFY9+O
	 9M9+n0kZRMd23zHxh9fVQPiYvCGartDQtVel/cj82Y5NZ/LPv7sNoMxTXhPTLHNcan
	 Gcrn7tVFS2t6Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  rppt@kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  pratyush@kernel.org
Subject: Re: [PATCH v1] liveupdate: separate memfd support into
 LIVEUPDATE_MEMFD
In-Reply-To: <20251223201506.2334991-1-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 23 Dec 2025 15:15:06 -0500")
References: <20251223201506.2334991-1-pasha.tatashin@soleen.com>
Date: Mon, 29 Dec 2025 21:51:56 +0100
Message-ID: <86cy3x9fkj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: AD7ACA000D
X-Rspamd-Server: rspam10
X-Stat-Signature: nofps3zuuzkdh5jna48fndxqd85f5oks
X-HE-Tag: 1767041523-170099
X-HE-Meta: U2FsdGVkX1/SLYT8hBaCBD7WjYIw6JJECUp1vGlqUn3zWve414r3InwO9cW47ko6IjDUtRyLIVM9aDFx2qcgrI4SxAFb2EVgUDwdtcvaJRfbDVKfSZN4LYs4mpJcsZU60aHwIjI0Rq0B/oaJAhTPx6SRCwmvhgXZXLxCBUmtwJ6VA3Cg4E08agpUqEuKgLvxjj3+9mVZQGE4If4NvHUCH88cXIwP3zgrgHPUFjNVRGYgf4YI8p7wuIiPvHjAF6nx+fg7yznHvAbxDbJ7LYFhhiz0ZdazK1I5ZD5TdHjD0LTZJwCWGbEcOfBRG6sN1wmti3I1Y7vCCKbXUqdaaibDwKkaYfplfK0xfkaS6d3CkSRwfcnYCRgV7WN4T6ViTKdsldk9vCrcmV+Tyo7JRplvooamqquDI/G2qp6uVRihQMiiS0JJ2zeLaMW7UZRkFgFb9jkbihMxA9m2meK2coUi54yopBe3zkM4KDvJFLiLbPCBMdTp+zT+O454w2wYz3cq/71DVOjbW5rBQ4c9y5SoWQsA6bwspYNqsaH7Dj80UoC0I4Sntm08nT25WEft0cRDM3/aqgletpeulb++fMBIUM3Lu7MM1CWBjaTse/nBXEHexF0+DLfUM8L73sP3YoeW7zx5AwfYlCjeVZxJ8gG4Lz/JpDW2H9ndWKWqUjAroNqKI7MuK7duLreqYWNz1Yf7EHh0PCiir7WfW1zaWjrJNYW6NQuRJEbq/9+ZGPIlRQhbGOfbwxMSWiJEfyVfb13nr4OV2LGkdr0B5SNG3e1En4Us5qxdJDtrEL/zUQlAWGzAHnV6fyAuREqxSwTFuL4ZwygSixm1zFv+Svx/yKJNjTrPSY7+xkFW/eopKSZAKbhKdWTjpr+/RzlIaluLl33axbDN25HcAenv5gVoPqwO2SdZ7+raszMq5/dGvdjb62A8lNpLNW3sam1ZaiY38Ws7xEjO0AJObMiARU3RINq
 868mB1YV
 5z1pJ2eJqeRZmxiIL7VXpCYUjkEHyixJwL6h3oYxvF7sCKWa+gvtapXk5Ih32ufvcPvJ22fuSqgGmougnSv2DpQDGSDlfwukXdJNzA4j4vKlVh5zDmbZ9wihCMDeD1y+fUsUwyVPLhx+nuSgON8zBnsb/9hXCyBgViLH0osDx/O2rhhd1RXomdVWc21oG0gv21jlh3iZozJ4fdNGEX8ArQSUHwIy218WyN/V6FxngP3yyljbPQHmh/mYAEyjLJRMo03ECwUAvypv5t49C7+mszBfmAV8eXCwaSeTLLXfTmOSpjA8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Tue, Dec 23 2025, Pasha Tatashin wrote:

> Decouple memfd preservation support from the core Live Update
> Orchestrator configuration.
>
> Previously, enabling CONFIG_LIVEUPDATE forced a dependency on
> CONFIG_SHMEM and unconditionally compiled memfd_luo.o. However, Live
> Update may be used for purposes that do not require memfd-backed memory
> preservation.

I initially didn't add a new config mainly because there was no other
user of LUO. So disabling LIVEUPDATE_MEMFD makes LUO entirely useless.

Anyway, we will eventually get other subsystems and this config will
start making sense then. Might as well do it now.

>
> Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o. This moves the
> SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
> them, allowing the base LIVEUPDATE option to be selected independently
> of shared memory support.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/Kconfig | 16 +++++++++++++++-
>  mm/Makefile               |  2 +-

I think you should also update tools/testing/selftests/liveupdate/config
to enable this config.

With that,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>  2 files changed, 16 insertions(+), 2 deletions(-)
>
[...]

-- 
Regards,
Pratyush Yadav

