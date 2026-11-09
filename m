Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C412F606EEB0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DlgVS065
Received: by kanga.kvack.org (Postfix)
	id EF9AB6B05BE; Mon,  9 Nov 2026 07:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1036B05CB; Mon,  9 Nov 2026 07:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E686B05CC; Mon,  9 Nov 2026 07:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD9006B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:32:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D4341205E5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:27 +0000 (UTC)
X-FDA: 85415518734.03.BF50622
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B81991C0008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlgVS065;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlFyDRL68yzv0Vgmoy9MTx56r7nZBApHYwIR8O8rV2s=;
	b=diu8kPOO9LTUm3Q4LTCK4AED0FkhBYGrk0TDfYfeF8Gft/w7P/ivT2eeqdr5dILwx/sqDJ
	dRBadIaCMFY1JPdBEaPB8odGR40Ozs26TU0J4LeAPq9wzmNm+FGIoQUwyT8sbLJei9eBI4
	DINMYz1+2nsCRKw1jxiFk0B8MjaWYQk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227545;
	b=AOTOE6y1JP//I4Q/v4tswdk94IZ42Pa0RDefGq4kSf8zhCeMY8s/Cx9H8ghkeK4vJGKIyR
	KJIOUe0lN18XwNAUVkkehqEmmIgP1L5ssko5JoIpdv883Bbx2bB86yU9Lja7hFaJiC83l+
	kTPeCEl+BJRXhapLkkaazUW1RvIRIPY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlgVS065;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E45B6323B;
	Mon,  9 Nov 2026 12:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C9E1F008A4;
	Mon,  9 Nov 2026 12:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794227545;
	bh=VlFyDRL68yzv0Vgmoy9MTx56r7nZBApHYwIR8O8rV2s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DlgVS065/RaB7JFKsxLb9aYRFBXW7o5Mem6V+HH2grHzdJ6C5lnB8eUrr3CXAXqme
	 DIzI4EtymtHbwc/qRn7tVb7xeGsRexOug7H8m/0trqdMVwGvYBhXvwkEC0CL9Q3mex
	 H28978Cpee/AkyYlRtxWk7BxlDpPXBhpO614sBIL+1KQfFLJBrdObJcviV2J5pITtJ
	 leZDeZr0SoWajOuwiRbc7wAs44/HtwyxwY3qrTQLIr1MOLR5WPfkXhAin865dA7FCD
	 JBX1pxx6OOwsGV7QxFDPhRh1Z64lyASChkg4QoVpWuddtaIJ0RKdDS7wFrPvXftIGM
	 m5F8JB+dm4Udw==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Qiliang Yuan <odys.yuan@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
Subject: Re: [PATCH v4 0/5] mm/ksm: keep smart scan from losing duplicate
 pages
Message-Id: <179422753967.4976.7051945485845554420.b4-ty@b4>
Date: Mon, 09 Nov 2026 13:32:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8htdkw3rr37hwtup5dh5kbbf4h978mkk
X-Rspamd-Queue-Id: B81991C0008
X-Rspam-User: 
X-HE-Tag: 1794227545-563175
X-HE-Meta: U2FsdGVkX19bozS4/feCzk+5nJ3+kDUlRTJHfvD/tHE+VqTrtdiVJHZdzLVc3ncxInmCLtzJNaEQax6yVdwjK9WX7JNeI5pkZRZHbEHq8XKV7ip4sT2XDhGaDMG/mDsi8FBOetT31gDalz/j5x7SyIX2NeJqrXqHNETPIkobmzZVDbDV4b2ThtYjzbmwPEW5oXhTAUV5pZHObT2eblM8fS2A3F8V0m+TCxIhhA9HTD+zx32pNZfIeBDdp7XxXrmAeiXRuKN7aAytwPa9MTDjNWvcMpjlAQTHFc/YY/nvl/vVtLtAxeEYR4hi9/EnD3jJX6IozyOI+CL1sYx6pPVQo2dYAWMYGbjHic0Cyh39TMAQR8KytsRNC6ADgNAsr9Qf2/3CHk7gmPBpIS2BpTTSjh7ej87eX/g6lUgjL3GHIiGft6i9nNTT4VBjLcP5wPqwX9rdPOY9rp4JCW1A8u1Bho1S/rC6pwKXPOjsX5vaB1VeKYJ6kM7SVE0IttFc2qx9ANhAUhHCBxitlylgiv6mscOkq2bEDAkSoTMl6Toc/3q1XNpSb2FsxWdaxM+YuoOcIPba+erWQ0DxZ5Fag2ojvPYl0DllBTCStDKpGF+RUGmDP8DEYr+xFfF1MNb2GqKKyxhYQ/2SGx6nMIuQq+NQMr2v6ZfoNkmZK3TWTlB8x2AwN5oWBdaaSrbzwIFvrQARDAQ66ZmqTY50HRAPOc6F13b81R+L0W8guqOdZbfSfkvBghT22T8RyYJZZ5GwkRdxO5+l6zjZaQgFt/MsWUNydEakbGlupkCyUjCJuPwmaDofdJi+bY5A36TzmtySFnG3PVL+3EfNbdXM30HRnkeC3SklRv6tOJV/ydn4g6A9sxL9AaKQkqtsbNWBN7pkCFNJRz/mmc2NCFI+c7SD4ARj4mY7SF353capPSFZ5FwSWwAwDynMJeO5MWXZo70hd8wRnRKFv2DqGhFNM1j54lC
 M0+vqG76
 1ufevqX0L+N0E4PFXc5R/iXjPXvGkf3jAK7U8atK3ROoD/fCQknLPpdsVAdZn365gk6FpB3//eRoIropAjfY5YBM8AVT+0fHNM0Ovpi6Nzdxga+HJDVV6udyZMUcQ6tMWeIrD+y7gSw8vUzOp8hBEQ3PJfSBHXEkPW3zDColtPxiPKOH6P4pW1w+WiR5+Ejtr7UC/CF3JnJOkZFT2a1byfk85/JVDP4mVm2XNCKmUmIZMFdO7pj58IhuZyZFLJFCqRUzRYyZliB/KeWb8kJ7L4BfbwoyVGfD7PcZRAfNRbZt4wwBKYnqGmn4iU4ur45ePrSSA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 20:22:49 -0500, Qiliang Yuan wrote:
> With smart scan, which is on by default, two identical pages that become
> mergeable some scans apart can stay unmerged for as long as they live:
> each page times its skipped scans on its own, and once both are old they
> may never be looked at in the same scan, which merging through the
> unstable tree requires. This was first noticed as intermittent failures
> of ksm_tests "KSM NUMA merging" in run_vmtests.sh.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: ksm-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/5] mm/ksm: align smart scan skips with the scan number
      https://git.kernel.org/mm/core/c/2b86234b
[2/5] docs/mm: ksm: describe how smart scan picks the scans to skip
      https://git.kernel.org/mm/core/c/53ee57e0
[3/5] selftests/mm: fail KSM helpers on short reads and writes
      https://git.kernel.org/mm/core/c/78509845
[4/5] selftests/mm: move waiting for KSM full scans into a helper
      https://git.kernel.org/mm/core/c/579d9b5a
[5/5] selftests/mm: cover merging KSM pages aged by smart scan
      https://git.kernel.org/mm/core/c/1c3db177

-- 
Cheers,

David


