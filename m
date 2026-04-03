Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 140E6E7E36C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A66B6B0005; Fri,  3 Apr 2026 07:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D436B0089; Fri,  3 Apr 2026 07:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BAE46B008A; Fri,  3 Apr 2026 07:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7F96B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:21:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18ED11B8573
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:21:24 +0000 (UTC)
X-FDA: 84617003688.22.4C35C1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 88A9D18000F
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:21:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KnOMtt0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775215282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdLkX+T+geuPxnAcCrsQTc83eke1BcvJBuYuVeCU424=;
	b=EwC4j7m2NulK/Fop5jskNtV7ckRWivRRyDttUz8ngMsE6hyEGY3mQQS/KOZCnEpShb/TmK
	peZwAoWZsB3bTvk1Ap8XowG666Zv9OtBTENAs33uM13hX+qwkqGxzgwr2V/mKynarKbQjl
	Ayflunw4BDSeMrJo502/Jz5k9Hd2e9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775215282; a=rsa-sha256;
	cv=none;
	b=Nd5JJoFDPtCLpO3dGtt+/hNlvHsx9Mt6KxsE3KKFFRjTcfQgWqmj7rQiZoPcJfyr3a7Av8
	5olwhEIQGuZNhaJ5wvKxkzDWrZp9gDb+algGSj8OUsIjZCdBGimuVTYEOQCTG/qVkDla9P
	xBxwoSqDgGzIldBlp+uEe4YU9MQfgxI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KnOMtt0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4A1960121;
	Fri,  3 Apr 2026 11:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C78C4CEF7;
	Fri,  3 Apr 2026 11:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775215281;
	bh=C2PE0QSFewGyAGB7w24PL7F8mQ26TmpseXExWlTHEWY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=KnOMtt0Y7qhdjpMeGPoOcoZzqzzIQ8bv9ED6tBakBnpMTCVr5t/aZUH/yShW+kwBO
	 /E2OZ019G6iRF3IQ792ESCtxHs8GPQZBq562VKyr4/bxj2976VMZNZ07swz+bUe1Qa
	 ZtzRE2+6UfFy+gOhX20mXNwcHni8iH0Rejl0Cs2vUZZx5gnYtDdLPdfLmtmJ69IyMs
	 N2PwyydrgIkOPhcG/BkRqLSiTDjIATePGlYEMu1bajcReeOZmit3q3LXmhAo09TpHW
	 d1MH+pIx1nfc5NNBB+Rm2S97U8CFTy3i+QuA1YH3xdXmB2cfpux78gF0vPlJMVL9yN
	 a5wtgMCfecICQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usama.arif@linux.dev,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v9 1/6] kho: add size parameter to kho_add_subtree()
In-Reply-To: <20260316-kho-v9-1-ed6dcd951988@debian.org> (Breno Leitao's
	message of "Mon, 16 Mar 2026 04:54:31 -0700")
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
	<20260316-kho-v9-1-ed6dcd951988@debian.org>
Date: Fri, 03 Apr 2026 11:21:17 +0000
Message-ID: <2vxz1pgwe1ci.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 88A9D18000F
X-Stat-Signature: x64nr8pret1u9tsz9sre9ag47z11zhjp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775215282-210788
X-HE-Meta: U2FsdGVkX18mC2ei1SwA+2abfemOuO+BISJqjZBN+MPlbJ6Ya7RKd0iCwetd8fT5uEMHQ2H/SM5tFPi3unKYZOWYeCoV2wD4LYtOVDQMEgSznbcUSOWE9/wOfCm4h5ptnOeBseqxKP74r29+ptD9UY9gNZ0EQ4MrQYTlakVJcA+i/TALZuKuT7hNvmZCZVa0pKO+PWANWGnumrcbTI5LSBKBEBlGmmAjspB/dKOBIjwg1F3ucCICx1FbGN2BV3IkPNej1BfS2x/I2f9ZXJiSpr/ngM3lzGIQUFEwseS/taTy5JnnXJHJ7NgRD1LLwCnR41NDqtTaQY3sQXucyAxUE4otiB2149UDyCzXyFRQ2WyJZRwGdxsAnl4yxDdaPwzCiDMQkghDBNF978aFeKsnTAaN2y2d2iJ4hIOZzIbi1VGBGMUuURMJxbnJolN1OtaiIYCcsFzK97sLnKZ6xpPGePDAmUdquchQgrMqGPb82ai6R9t8nzqNOn1aE2AELrcgwVe9aFwvXk2fjmxdao7Id0RRJZs3SbFGnkZNxsBQ1CxlB6trz1ZdZZXK4txLpivEOHonnZzEiBcaLRX7xvBQ6Cp0pyANjv/ba4a2RaKv5aE3nuUfh5VK3FKzKBBEa2NS5dgQKC+tW2UI34Vs/JrSAFSYv+Gy2+DNTwtnler9stLrCVXsBdtGmdx3sY4fEA1Yft9jJXImku2dOMEjaISER/DjzW9at4ylhhkMtkUsV45fdA/gymDm/M0mnczzaLuwLhvVn9i0kCbmtC8UqmBSwJ3qjejL5rUjnPJeQhAUIxNeD/aQ0WPjusIgUpm8u3QftWfoExsITWk8ASYiFRuMLd+YoxahtDGXkD1MOiO8v+1TTec1aE19MbWEuMdtWxIszq5yiP1knipTUJPbjB4Z1NQW+/K+/q9tjOhjug0BBhiuQFtV8uFFh4gHmm6quph86nDdEJA0PByw/+8Ufh+
 FFrEA01O
 aLhJAWG+Y+NzloBSYHoQzCuXSCKof3fFW+ME5VHU5NWmXRO9uz2wYSXHyFiZXjUEfyV2oBbv10zOV02EnKrhu5B/9sMz1eJkR7jHOKthPZUXUKTkOJ8ORS+RVvhyTvOAAv6t9LvM0QJ5qPbjwU77mQCsZSBb0CVObhEYRU8TgKu8KAqtGxKSvnOgAn7IknRqf+na8PvPbrDx0qQPDmThG613iUfPOrjp7USOTnc+lrGBXdbldMLjD03f5pbP1WSzIpcd3BJ/nNekiKIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16 2026, Breno Leitao wrote:

> kho_add_subtree() assumes the fdt argument is always an FDT and calls
> fdt_totalsize() on it in the debugfs code path. This assumption will
> break if a caller passes arbitrary data instead of an FDT.
>
> When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add()
> calls __kho_debugfs_fdt_add(), which executes:
>
>     f->wrapper.size = fdt_totalsize(fdt);
>
> Fix this by adding an explicit size parameter to kho_add_subtree() so
> callers specify the blob size. This allows subtrees to contain
> arbitrary data formats, not just FDTs. Update all callers:
>
>   - memblock.c: use fdt_totalsize(fdt)
>   - luo_core.c: use fdt_totalsize(fdt_out)
>   - test_kho.c: use fdt_totalsize()
>   - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)
>
> Also update __kho_debugfs_fdt_add() to receive the size explicitly
> instead of computing it internally via fdt_totalsize(). In
> kho_in_debugfs_init(), pass fdt_totalsize() for the root FDT and
> sub-blobs since all current users are FDTs. A subsequent patch will
> persist the size in the KHO FDT so the incoming side can handle
> non-FDT blobs correctly.
>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

