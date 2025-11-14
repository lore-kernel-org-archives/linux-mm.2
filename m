Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC25ECE8D50
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A54B8E001E; Fri, 14 Nov 2025 11:17:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D3F8E0005; Fri, 14 Nov 2025 11:17:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA348E001E; Fri, 14 Nov 2025 11:17:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7078E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:17:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B61471403B3
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:17:37 +0000 (UTC)
X-FDA: 84109718154.18.13155F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2C55A40008
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:17:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bwrPhz/H";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763137056; a=rsa-sha256;
	cv=none;
	b=GCgbbALU3cL+ESe+W/+hi0bJX62l3RB72IgaEuxk/WVtdB/+G00lkzEVitCevXstLQiHmf
	V2U62Rr+fA+OsSAPnMoDKROOzfW1VM/m2TknhSvshIpM1xtxiAN1WucdOGVGajEaB6JvLH
	m83YgIGa/s0Tu7mg/ojOH3TZD7G6wdA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bwrPhz/H";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763137056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzmaurRwXd/FUfjWlIvyc9JKRHbFyjNcTaJdND6zQwk=;
	b=A/sfqMj6/UH3SmOoQZ9thZHxj5aCUkkhzvjrPhM0X/Crh+omOG728BKRhsBrpEFqll7fqq
	iZ7zGXsWRxP9NIqiTU9wIjb/lfKIhNfrBOZpC77nt0lDOLnmqGx+d2VJMny86TfSKH0yNa
	iQQll9Cipir7w5WIXN17p6mabs8sz2M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFFA960150;
	Fri, 14 Nov 2025 16:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFD7C4CEF5;
	Fri, 14 Nov 2025 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763137055;
	bh=1TP2PBihBm/xACDWaGTPWhNWAdDdBhE5Owp0RpW0KBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bwrPhz/H4pWI6GRx+uoYSdBmXA78z+aVv88xUzOIT17tPfm2Ur79PxBbmFmETirvN
	 6/z2xXhyZKz1WEYyTa9ySylU39jBcxrcd/LaesSsiSgm4WZeP5HMBWX76VJ2mMVnlV
	 3HVMlBc9re1Z4MtzUQv3z5aLXfQ6beeJ7DdK6fPjtwRoTDJaSFg4Tv1P0K365g6Xnz
	 lL5wkoVXSMH235A+WDbEaMuUz7+vSIAbl8IqCGrTyxL+ATr3C2IxBwOLW2pnNP+C31
	 TyvqXGWFVQiKzXHNB8RLx5qPpjPiSbEfZvQ7k5koLM845Ed7SdKJFdjXQ9df1LX8I1
	 j0YEIpr35ql2w==
Date: Fri, 14 Nov 2025 18:17:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com,
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca,
	ebiggers@google.com, graf@amazon.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1 00/13] kho: simplify state machine and enable dynamic
 updates
Message-ID: <aRdWF8ck4iq1hc0B@kernel.org>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2C55A40008
X-Stat-Signature: ija5fag14wy5ust1wgqdsiybxq49hzpx
X-Rspam-User: 
X-HE-Tag: 1763137056-276674
X-HE-Meta: U2FsdGVkX191Tz7IlK3eVmT1aPoukHzpO7dClckAtWBH/BfJAIZHcCrJVF8dTFYD97BWR/zVJlya1FNgpGK3tWrrOiZasAAt4EQf3AqjDdvo+UN705eq7WAQ2w8gXmbx/tn+j3ecSRwLmJuONA3I8puvtGRMu033PVCPTxr7oSdNItfzyfFSXVhEGx8ZFK4HsW6U8yoxNcy4UGfl6nfzt7hG5Ps8NyaJZkBIO91KNmRuGowi4jtGdTwZgHRLleNqYU1W1TxFPBJuY85Nl9QXbpg61ObIYjvGUN0DmaOfq2FQ5ySsy5dviJ01r9o/bDnQ+z+lEzjXPOAG8aVg/xf8lvkECGsbTlcwu67A7k+T18N3hXzbK337fKTa2ypuuQxah/fnC+S4repCfOa3pIhuA4yCFHPApZjukVm0G93q23cIAXrg86AtIREGPsbaj49Ny6JyvVUCo1qxWh/5WXfTHXkI0q2gxIDFKMKBjR4BsCMKbq3Bi2ot4Nwbe+aBDI/qFjlamd9H67YbhR8Uosp//8XVVCrRe9cJLBYC1Lo1mZpdCm8WJoh0ZfiGQ4MNTfzRB2NW/TYus3wIxdpDUv5hQqg7reQ8+IZ5KRBicYZNgD3nXEeCmSC0Ht28gKyjLPE+UDIX/+0xWTmdayHcMxApT6Qjic71/e/6HDPDf1MVH48b7giqO9Wxjw/N5K3k/zikKNz+XAWCTBFTWoOGUlo6BNL3WL1bQKTbHSlSefNucHg7c0N0BgNKi2hJgjNYfooPalJnhf/uaSB+QFbG7lbESBccpa+ZqnN+euafKPBd92ezOr20ve6cIt/sjFrDpswwGnNUitwjLCSFRdsQtcNefcXxbYtzY9N7bkVpfV48SgdK/9+3OiL8nkDRXkBhSq9jy0A6N5BFo75yWKzmFC0Tq0hiIl1/kOJgVNy515f06XdknYyQL5wJcuynpuRhEH2QfDIhsHpm5WeFnDUzrOM
 ZAEBWjUX
 bwwBV8sIa3qvQXteftmT8VI/BON7qmAj9X2jyNKlsC3VzzzFUXShsP9YQN36k632QMl48niGJJ2bHP9T2/WSmrOkVuLCNMV2L7HbCUZ/H4zBNZe2w+hlVMb1HBTqtdQhufd9Q40GGCz0w64gczb1tlvSbjokObrGBHMco8NVGBP4EPfL89VvgQq1aAbwufjfXCne4bVFESQOxf+Dwmgkwu6lML9UVW3cuF2QtizmeViQlPVuavdukTyOE07ipZ71ShbEoxrMaB04wM7k9UQxS8c27JA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 10:53:45AM -0500, Pasha Tatashin wrote:
> 
> This patch series refactors the Kexec Handover subsystem to transition
> from a rigid, state-locked model to a dynamic, re-entrant architecture.
> It also introduces usability improvements.
> 
> Pasha Tatashin (13):
>   kho: Fix misleading log message in kho_populate()
>   kho: Convert __kho_abort() to return void
>   kho: Preserve FDT folio only once during initialization
>   kho: Verify deserialization status and fix FDT alignment access
>   kho: Always expose output FDT in debugfs
>   kho: Simplify serialization and remove __kho_abort
>   kho: Remove global preserved_mem_map and store state in FDT
>   kho: Remove abort functionality and support state refresh
>   kho: Update FDT dynamically for subtree addition/removal
>   kho: Allow kexec load before KHO finalization
>   kho: Allow memory preservation state updates after finalization
>   kho: Add Kconfig option to enable KHO by default
>   kho: Introduce high-level memory allocation API

For the series:

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with small nits in patches 9 and 13 in replies to them.

> 
>  include/linux/kexec_handover.h              |  22 +-
>  kernel/liveupdate/Kconfig                   |  14 +
>  kernel/liveupdate/kexec_handover.c          | 338 ++++++++++++--------
>  kernel/liveupdate/kexec_handover_debugfs.c  |   2 +-
>  kernel/liveupdate/kexec_handover_internal.h |   1 -
>  5 files changed, 232 insertions(+), 145 deletions(-)
> 
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

-- 
Sincerely yours,
Mike.

