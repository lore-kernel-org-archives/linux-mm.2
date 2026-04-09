Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B57AEA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12826B0005; Thu,  9 Apr 2026 08:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9566B0088; Thu,  9 Apr 2026 08:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A265A6B008A; Thu,  9 Apr 2026 08:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93A876B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:04:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F46513B965
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:04:39 +0000 (UTC)
X-FDA: 84638885478.25.1EB129E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5E4140018
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:04:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRcRzH4E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775736277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwTHIJxjIYpNKNbKPjX5z2YBlngCSlDhVOBalB65o7I=;
	b=2p2bFMXwRmM26qxIPiYrlIWu+5EJvaQVXHpQJn6McOK6dHY7XLHh8dL8UBEg6Ghwj50UXI
	6xXAWohokhsj8/0e+P2rZJCZdwCCtXqPn2jn3Baer5ruYGvPRnsraWzC4m30vPdE3hO3xV
	y9jsfzYItS0xwEgzn4Q3WQ1svxdUuFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775736277; a=rsa-sha256;
	cv=none;
	b=eoHmSY54+4OynCcmeEW5wUrHHhhtvEPhr/YdsGex2WydP6o7qEUhecoIWISz6JHPle5yzD
	igeKL9H7aNiE3+LBj8r03hwxUnrq/iWmiftt+FoiHYjbVtkO4W5OOeLgdZPSlOaW12G6Z0
	U1Hdu15g3QjCypnEQZNlXXXWFRwoSb0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRcRzH4E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2106F600CB;
	Thu,  9 Apr 2026 12:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDE3C4CEF7;
	Thu,  9 Apr 2026 12:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775736276;
	bh=gcZxvku11NmaM/oQN+7sEkPtzgRgmTY51fejdl+f4iQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QRcRzH4ElTvkUK2UDiRPGgoHkPhNfpWtUwSuoa2hKEqYP6G2IulpGTGcXh78j7Unb
	 cv+2aeZFfqDHIYyM9ycPVHx5TbzOLMGI1syCd95GAdtXD+UUu0LIZeDeMSyX+QSOvE
	 lXSrFoSKNinfh4EE8/oSmIMXCg/B08rp04y85z8LUK4Yp4ydsPDBfEZOEWeTf4QRlR
	 kcI+zCjQNk2qkzg58EoMQS4nvuvPkg/X1PWkzbOgH8D1Vm6QV3mOAKj9H923tZP+HX
	 ldNqn/12cjl6IfK6hkex3+Q463rRVVL/tk05/l60JHkk6uUbs1L6UWNmDcEb84JELG
	 PfVMXLtN5Y2+Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  SeongJae Park <sj@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  kernel-team@meta.com
Subject: Re: [PATCH] kho: call kho_kexec_metadata_init() for both boot paths
In-Reply-To: <20260409-kho_fix_merge_issue-v1-1-710c84ceaa85@debian.org>
	(Breno Leitao's message of "Thu, 09 Apr 2026 03:31:40 -0700")
References: <20260409-kho_fix_merge_issue-v1-1-710c84ceaa85@debian.org>
Date: Thu, 09 Apr 2026 12:04:32 +0000
Message-ID: <2vxzjyug9w6n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: B5E4140018
X-Stat-Signature: ixj3fkms9kpnqs39efsoxggkigmpdw9n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775736277-615483
X-HE-Meta: U2FsdGVkX1+NaSmIaZz/C0z4GtTscC32/EMX3DKUA7moueHohMsNeDeT0WiUvBtnRn3GY0aNPxSc2iQfvS1QgfS32dXeca83YLqxIL3WvJ9Nlj1Etluf0cIA1/C+PZf3y0XILy0EmDCkrHrREZANHoUsb8KRyXGY6tt/UV8csseqJhrebZ3M+YRVL2Tujx33/VBRs5CUOvXxWHN2rmTzldj7GnwuUfwUvqSpR4JcqhWXLEE27S97i01vB2lWoVZ124KGQ3rt1UxT0mWnn58ukx+ekN35XG0Tbx2xTXlqHFj5VocLyxdUkkH424iciM8Qi1EJf3HkmyyMhx5U/AWekFuKU1xkzvHMEmQTFrYjJjLbjjlx40wZ418sRV8utVvzasTD/vHUEmaxiXGmhf+P9jWtraM7zsoFHmrssq38T3mOBQ/Xi7Sk7CV8sjEk0++9qtUYjFd+aNcRIaKcAp0665zbvjqW2+pDGkEJ24jIrdyFqsC2Z3haODpHhxLdl4iRMYWOToSEWsXMd5Vx4D0h7GVZfIYDnLTeSVNwMDx7s0dqdA2Z+rAtE3UD3A8/sCpCPIQIcgJxkb9dQNlhjCb7IzakxMXF8K/9IahGyWpYXK+OfjXyBvSMBAWcETIXgVf4PXehVK+nqmdPJAE1VWyIwOufNPpP2c5O56YjjSa/JhYZIlyDhLFdm/g5S/KbBJZnS4F8QUg0bNREGWZirPGCEQpqJh6VU3G/p6cP53jG8a8F8gSP9AoCQUSf36mjGJeKbY20Ng23nIeNN6Adw8eEcHCI8qaVApHBixkBHa9M/iVoWvwEHFvHVtCzScl5x2OEEzR63adxJCNGrKgFePG2zwFDV4LMKQ/uzldWlanlKtv1KxX0ESdLhKlAIa5htstTl2wibO+pGpR8IfNjbF8bgOCMkbyxBwdQ+THzbmAYvkvyJT0gQZy8oIZJ/bktDjezdhMpycyswZ397ApZlh/
 tTU3JSRB
 SUJhPABJY2/G/f6GdrlfaUGdB1j3tAtbgx3EHPdoGpD8Cn+ktGItnWdAyMV7YJGNY+SfjB02Hy8OasaLlvTyuX2JYxkiKaidWNUz8hKvGUQnJH2D+Sap3UetQ3qE2uEmQQqCyv/A1aGMbMhStJ2KfzHuBE/Ke7mdPnrS946Ak2z7w2pYyggavp+h9gUnsYdUO1qZXJYNPpT7/CD9895x9KvoY6k7jRerH2yEAs6KxY+u+GXUV0gPjIHCg783DmNoWpbTTR/+8bfC2t1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09 2026, Breno Leitao wrote:

> kho_kexec_metadata_init() was placed after the fdt check, causing it to
> run only on the fresh boot path (no incoming FDT) and skipping metadata
> initialization on the KHO restore path.
>
> The original patch[1] was based on commit 5c9e55fecf93658 ("Add linux-next
> specific files for 20260312"), which included commit d7176a010afce8
> ("kho: fix deferred init of kho scratch"). That commit has since been
> rebased and reworked in linux-next, changing the code flow so that
> kho_kexec_metadata_init() is no longer reached on the restore path.
>
> Fix this by moving the call before the fdt check so it runs regardless
> of whether an incoming FDT is present.
>
> Link: https://lore.kernel.org/all/20260309-kho-v8-5-c3abcf4ac750@debian.org/ [1]
> Fixes: 047117e78331a ("kho: kexec-metadata: track previous kernel chain")
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Pratyush Yadav <pratyush@kernel.org>

Andrew, since the patch "kho: kexec-metadata: track previous kernel
chain" is still in mm-unstable, please meld this patch into it if
possible.

[...]

-- 
Regards,
Pratyush Yadav

