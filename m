Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BF51CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 10:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA6D6B008C; Tue,  6 Oct 2026 06:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433F96B0092; Tue,  6 Oct 2026 06:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32D466B0093; Tue,  6 Oct 2026 06:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE3236B008C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:55:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4632FA00F9
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:55:40 +0000 (UTC)
X-FDA: 85291895640.09.11A7776
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9FA14180002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:55:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkLF6Z6y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791284138;
	b=gHk7xa/YBmr0HJk5m8peZsUdaGOT2LlrE7HAm8jbvgQJqBZi9ZSnx7c/U33T94jATzehKb
	m7EPp8UCuHcjRLhK9yUwJ3MZWPBbuBju5pSYsdMdLDy24djfATjAmSW4OXFoGh6HIBHNCc
	q54XoSr13vLppAWN09GtHzpa7H1GWzg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkLF6Z6y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791284138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcCKnJg82xr9zF1ktKP69bSPFjVHrRcr9zQM04SRH+o=;
	b=lApuhnJqFrCp+QDoFKP7vLxRBWwx0ZnoA28DwKwjd5NqsyCuPyTPmJL1DRO5x8tGAvJA9p
	wYSvfUj241Fb0IBRIeoaqsxkxSMdLDx/IHaUzgpPzO3hthzU34lQZma0hal344TGp3hgla
	PEENkIpWUMN8zHiyTzgDQHfqcQACYm0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CC2C43740;
	Tue,  6 Oct 2026 10:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D441F000FF;
	Tue,  6 Oct 2026 10:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791284137;
	bh=OcCKnJg82xr9zF1ktKP69bSPFjVHrRcr9zQM04SRH+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZkLF6Z6yRuA0I5reP8kGotSor41YH90MFptgbXyAQyRUjxpBD9oMtj1zSV/FNC2oU
	 CYDRJLmfE4I71/SvJCnM/5akyVm4xTTU9VMpw7g+zdp+5oKKh3eWgttV9+uBZZpmJM
	 o0bSBlzKt+adSFrWTHVI+x/xlptnB309hbakpFO+7pfXxIvAWVDZkrctXR5mG/ov/4
	 0M15a1mbjvAENfjS7v4PuhgZWg2ozzW0zLI4G/Ym6r2namKefZDDNtPpJxKA/UpwK3
	 dIaLltqn9eMi1gDxQWZakHU/r9wTW2vww3kQ5AcJFAxff/hTSNmNUxZN+bUt6NJB4f
	 mMq7B9LO5riaA==
Date: Tue, 6 Oct 2026 12:55:31 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Bainbridge <chris.bainbridge@canonical.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Miu <jasonmiu@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [BUG] KHO handover hangs when memmap reserves PMEM
Message-ID: <asTTo3AFzQoqZLoP@kernel.org>
References: <asE0R_f2r2TL-3Sy@px13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asE0R_f2r2TL-3Sy@px13>
X-Stat-Signature: w7r11k4znqx4jupfk37oqj187gdnkpnn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9FA14180002
X-HE-Tag: 1791284138-967300
X-HE-Meta: U2FsdGVkX1+vSIoi9UJ2gnCAdfIKpbbhQlkUVlquRcNSOPHWHxI/5ZEgkSNSPVNE8tsRXfbj9a7079JNDVZ6WrWvduybhWwE/H7Wk1zd5sJcVcSbxk02Y75KA1DnsZ/u6KABGNxaCj+jtWZTcZDzrBRAaI6kdTOJR+AYbOHtFdf7zqutr9hE+e5DROM3y4Vevpy0Bre4gluBlViegsfj+vEq/eglK64unJH9eaqcdfhZqMdhGY3217mYJvAip6vKwlKQ6v4ZkHF2ki0UKhsGDYov6bXPFgAsdcDiast2SV7UQu9F3WBnK4Hqk/2i5uuSVajEG/5sCXVUfNu+he8jzG9hf9e5MAdv9SZ9MnKwMt90jKvSo5oba7YIZbbtOj8gdzFbfIUWn/fQuN9VgPhNKKtKzDafYBtZz/NVtpY2hylo/Mnz83eT3zaPJIGiWfPHQ5Iw1ejuj8ipzFsVp4Fk6buSYFaupLkUVnhN28AeoKhk9YC8dk13njceErAlGQ4DzVJ7Hmt3igYUJ7S08cvowQnJUxqQoxoFO/XmMaJXEAM2h3nbv2FjTrYnpmgu/dJpsT6OOoSBiM3VrD+R7Rts3oszwE6/MzHfBX5WwREQ/wb95Y3FDwBHsQVmHl30wc4XTkBjxt93RxbPRtv5pLGA9wD2Jav2LKHcbytL6ib1d393ezuyJkwq4Z4SMqEDUTZSK+Qe9kwix2sx6Jb26MrZll9dHdcYgblQ0xWgSR9Yu/stmytQMN1zFQYiLRkMn/ucJyow6BvSzjcsPEQF5/KuTmmOjiT/GE3hyvYpuFq/Z9lYS1gHXdDQa7QlTRW5Y8byKFyVKCNSFrR8tV2S8Lx6iIjiE7gqA9Q/mRdz/soD5AE4wb4k3xY2yPP8Z53vhk/zM8eWhC+BLlQtnt3/REOUB1+Gx0IcsNh/okuV11B88XU0LCMw0GynVPLg8weN5swWYTFKghjjeNCt0+QtdCG
 uBl3MkRc
 zmoGxLH/SgRFM7VrSc0zfBrkzWAGph5HiwTH2eDPa+W4KMS1R4g069cuKS4L61qJzWu7RijRTAYut3/g354YDp7zD4NvveYI3lSVwYtNEdx6VnwVr/isCcfQOw6MRJecAO6p7K4KSJaCMNc7907SZrljGHP1t1ASQXLE/G+06OjUQVg0tI38N/nvtLWM/RGJQ3IckmHBcqrQ6x13Cw5iqSYu3Er2NYMOVznRbTGDQWJ/Z6DjHZcFao28cdgq/9INJGiJm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 06:02:27PM +0100, Chris Bainbridge wrote:
> Hello,
> 
> I am reporting a regression in KHO handover.
> 
> In the most recent Ubuntu 26.10 beta mini-ISO releases (2026-09-18 onwards),
> the first kernel reserves RAM for the downloaded ISO with a memmap directive
> such as memmap=<size>!4G, then kexecs a second kernel. On affected kernels, the
> first kernel reaches "kexec_core: Starting new kernel", but the second kernel
> produces no further output and QEMU spins at 100% CPU. On unaffected kernels,
> the second kernel starts and finds /dev/pmem0 with the expected "Persistent
> Memory (legacy)" range in /proc/iomem.

TO make sure I understand this correctly, you enable KHO in the builds of
the installer kernel and then the installer command line explicitly enables
KHO.

Is there anything you actually preserve with KHO when kexec'ing the second
kernel?
 
> A source bisect identified 3f2ad90060f6 ("kho: adopt radix tree for preserved
> memory tracking") as the first bad commit; reverting it at the bisected
> revision restored the handover. The regression appears related to KHO metadata
> being accessed after the receiving kernel's memmap directive changes how the
> metadata's physical range is mapped.
> 
> #regzbot introduced: 3f2ad90060f6
> 
> I have an AI-generated candidate fix that changes 22 files. I have not attached
> or published it: although the AI did extensive verification on both x64 and
> arm64, I cannot review or explain the complete change, so I am not submitting
> it as a fix. If one of you thinks an unreviewed candidate would be useful for
> further analysis, please let me know.
> 

-- 
Sincerely yours,
Mike.

