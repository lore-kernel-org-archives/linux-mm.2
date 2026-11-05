Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983C2606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=fPFwJ55z
Received: by kanga.kvack.org (Postfix)
	id 81D236B05B0; Wed,  4 Nov 2026 23:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDE66B05B1; Wed,  4 Nov 2026 23:04:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD356B05B2; Wed,  4 Nov 2026 23:04:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 406AC6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:04:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77C13C0916
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:04:16 +0000 (UTC)
X-FDA: 85399722912.29.0EA761B
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8C87620006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:04:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fPFwJ55z;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793851454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYu4vf+Y1xQk0GWAYhYxqZeXAZ+RYHgD2MH4lwu/i9M=;
	b=bcI2unf1HgTvZAaVginC1WoKIcxpKLwSQKZ7Q8fFfiLzy0hMS4pSZM+K+HkAKo6LSc/sQX
	LkjH9Rkt23CUzC/A32PQk4W9Zs99wQ0wQ7cfw5mmvqO0r6lld/QvMHTnN7R+69S/e5chfb
	Cgj3zhUWYqPHBiBRz9ymdG+Ci+IIB+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793851454;
	b=CseEBJKMRbwP5jHYDa/kAdjVURUpjr67ao7yu9ncjSC8ynXvwj3bFKQXE0ej9xcP+W2CFE
	x6LhqE6PaWAOWiiwmcySv0TOokjF04PoQHlPimR3QcsO3Z6A7m5OulB8HUajpGER6DCuLj
	8sl2ulstWksCCBOFIWreXYXryvarris=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fPFwJ55z;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793851448; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ZYu4vf+Y1xQk0GWAYhYxqZeXAZ+RYHgD2MH4lwu/i9M=;
 b=fPFwJ55ztN6xnQ8J5bfVkdvSYtJ34KITPGNICbCHajpoK+N+mKdNsnnBhKwx5cgAn9JaUX
 Jx8eBwZZtB3WNCp+pC3lyVAzToRVQXo5ICo8+BrGZU6N95KXLHO3E8g4kyRc/psrd7JWd0
 a+y+zAZy5SS+oTMTqt60Q65LBJHQmRAvIvcO5sbBak82mnPgAhTfhOnkp9qVe3Yw91wQFP
 ZOMjTFKVQyldfzQsLBLFgN/8RJQNq9bzfv0dTorXlz7iLFmqhJkp2xStqNMnF3KDY3x5b+
 pxeT1l2EqW3tkOwL4g6G4HstHS/YY8hjKOd08tC9vRQK+w8XR/n7Bcw/QKiXSg==
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-2-lizhe.67@bytedance.com> <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com> <010b2b6c-8f1b-4c3b-913f-cc2e8b957759@bytedance.com> <a6bcd771-fcf7-4fe4-8c21-5e65bd579de7@amd.com> <1bab234e-8914-4694-b0aa-f265fa49c6d3@bytedance.com> <c9cf96bf-f3b1-47da-b22a-9600b5fb01be@amd.com> <3318a7f7-4dec-431b-9284-ec7c2807151c@bytedance.com> <aurO98PC4TTweJs0@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion bypass configurable
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
In-Reply-To: <aurO98PC4TTweJs0@gourry-fedora-PF4VCD3F>
X-Lms-Return-Path: <lba+26aec0036+c202ed+kvack.org+lizhe.67@bytedance.com>
Date: Thu, 5 Nov 2026 12:03:43 +0800
Message-Id: <519e6126-e4c3-4267-91a8-ff81174aaa5a@bytedance.com>
To: "Gregory Price" <gourry@gourry.net>
Cc: "Bharata B Rao" <bharata@amd.com>, <akpm@linux-foundation.org>, 
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>, 
	<joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <rostedt@goodmis.org>, 
	<vincent.guittot@linaro.org>, <vschneid@redhat.com>, <ziy@nvidia.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
X-Stat-Signature: fkh6ixq4m315dzwrmg4c8o4aej9gyaez
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C87620006
X-HE-Tag: 1793851453-413196
X-HE-Meta: U2FsdGVkX1/K50DwfgO4cjiD+bbci/sc7Ma7ZIb2mfmN3z1ODs8RF2H0merLOKftLnK3CXq5xNfXZYTAAysVYv5FoLTPmkijiG1jkum9dPJdcMDnEUGN88d6LP8xrNQZJZB4QzwXRR7xd1faRxhCBQWtqvJVfgPcRD3DWGa5JwyP5Z+bUR6Sr4yYOfX57gTiexCoXkGIO3uNWglPfq7CtLO2rfacjeYa00/cKZxDP3F8IAEWwynpvMweZpRxEfgS14LrddQdQ3yHTRTlg5Suv/1FbJ5rJxtLNnetR+yAgq0RNbwEuPCdjt/Xph5uJaQWOcsExuijlJTipqu6oO/a0Iuu8KB3qaQVSs0XWocz3FEGAiga2I1CBeO5rgqPzVz2PbZDsZTqg/QtSm1LipfdffYnfbEua4o7IDz2C1kAaEw6UjzgPRPGTTd72ZZdMwuXrElHl2vAJkJ3FsF7uwL3kWaK/h0spwtg704YhB5r/jnqCJyGf2Qg/3FZi/VFiSQgQr1iQ2YtLoh1vi7VXvn++ln9Y0if8Av1b+AMZumTLA1NqgCnICLwctXh96vvvTEs4hcEFqld4N9Ly6pQzmZ19bvXXZ1WgBNIxcs8Kg4DqRt/jugbGviLsH+OW1NjWKNQ6vc8oJq7O91VfCaXxVpR8XO72IXZwQZV09PEmMKl7tHarA5tXxRZM2iQwYhDdtWo54csVrWfWdUNxdzzgQF3GPAa/i7FrtUhN+lSBdvpSaFVxbMN0P1uUilhuBK88OZ1tK77h6G/L2LYHhO0FxkrFb7DkQvgEXGVhMfZerV4indSWKYOr2egE6K821GHBv5E3TFROe4KvGDK/zTj3uIsi5B8bN3JuioDY59cSEMaVokaHDuSpHzYscyD3raWBoLAzdUz4AcG/RbyZaD42PrsG3M/UG8iu9dbVKFMjjYsPhRuGvhV5GPgbqbIuTkYbiLJDlLGpkTW/N5jqQI+1CU
 4XOREkuN
 t972TbT+TkZ/S6jZb3UPciPrR8RCklQ/3XDdQqGGxfMJNwBACpSIrjzT5RfSpCgPvz5E2DNuKChGBBRU9QCwSCwbU+lz2prNZPMIqxxtboVqSth4CA/PdvwNGaTWtgr6zSsqHD+751jDvp55JuOixnRYtCAaVaIQEqxFt8DNDXxFnFksjiUA2SUkWzDzsLJjvB0Ffh9Bn+WEKLDe6OX7GhDu/6epVdiCB7gp4wpzApnyFPzxqVugf8cK/V4QZ7bKCiu/rXp0gPZI/cGdKL/qoDhR/kRmfw0WibrUosPdMYRv8OeG2/T1SV4WdPPrYFdjSvRYtzIbmov6tLwCXrsviky+9BWzevD5Bqy1l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 2:21 PM, Gregory Price wrote:
> On Mon, Nov 02, 2026 at 10:56:27AM +0800, Li Zhe wrote:
>> On 10/30/26 11:44 AM, Bharata B Rao wrote:
>> Thanks, Bharata.
>>
>> I would appreciate further maintainer feedback on whether this series
>> looks acceptable.
>>
> I will give it some additional time when I get back to normal next week.


Thanks, Gregory.

Thanks,
Zhe

>
> ~Gregory

