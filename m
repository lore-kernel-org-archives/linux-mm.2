Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16B6D232C7
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 01:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06DA86B0005; Thu,  8 Jan 2026 20:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B616B0089; Thu,  8 Jan 2026 20:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F476B008A; Thu,  8 Jan 2026 20:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D31356B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:46:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B031C19D0
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:46:06 +0000 (UTC)
X-FDA: 84310734732.20.C70C2C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC42B180003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:46:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pwWxfoMu;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767923164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQ8DFNoN9le9TZBMx4B8fIsPgTjdjheXyeIfiKr7Al4=;
	b=g6DHWH6B6W2EYbPHKpDDuXw1PPoB84SPWVnEpT5iqWhZCZI8B0PzMQETatphzigNi5pQa4
	2qrW/hKAvvu/PXRi26Q4ciitOmdAxk64XA0Nv9LTjJen9AAcerRIxwMt1+Or3s80pUqLQR
	X17HClaNBQIWrVj4TCwzZh8NgM6H+Lk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pwWxfoMu;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767923164; a=rsa-sha256;
	cv=none;
	b=y6l/dGYIs7GiE8g6vMyVEDLkAjKpSMFiBARvEkRaeowaI2Ab5kHY0D+AMAQmKMOrltll6L
	r0Z/m6wea1usdWzFBoPtprksncuocaKI38C12dxoDaNsTETcSmCdTm/4hlZtK4P/BSG8Vs
	5HKUySrAB7PePvm46++yp+AXZpG1BGc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFBD860136;
	Fri,  9 Jan 2026 01:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFD7C116C6;
	Fri,  9 Jan 2026 01:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767923163;
	bh=HR7001FSUS5rNpOFxSI1vceayRCNk4N5sG9dhwwS6vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwWxfoMuiV6/C2hFWNgALJYvXsfScorunRS6oK52CCl42zDB95MWS2FvpJBCSBh3X
	 JSK5+NjEGrXvmRaM4tSHZq3UdNIoLi1mxkz/8SHQ4ZOxgjMx+Fxp9Dh9Ud6imI3xAB
	 4Fuhl/beerswmv41LYYfITUoF1omTgiYbvWMvH4EUZwcEPYE4YF1xONhcvhcTWG+Z+
	 vNguh6jxQXkQxwc90HnI/Knqc/WdM7P6LfLG8g/ETM194Co8WEwECe35g5Gqj/2eaB
	 M4EI9Jyt5P3UtthKyXBwYjkTOTeL16Zx8RvRwSX133kkwS/atZX+4kO0ER8MWLldJ8
	 QH3ZMjNsWSBYg==
From: SeongJae Park <sj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: SeongJae Park <sj@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	usamaarif642@gmail.com,
	rmikey@meta.com,
	clm@fb.com,
	riel@surriel.com,
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] kho: history: track previous kernel version and kexec boot count
Date: Thu,  8 Jan 2026 17:45:58 -0800
Message-ID: <20260109014559.68677-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC42B180003
X-Stat-Signature: 4k1bsyx56k3br4cjuoep8dcoae39rmtm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767923164-763946
X-HE-Meta: U2FsdGVkX19S/28y1Jb9b5VWwCcSXP8NkzhH1eKLnHCPHrlBAZQzm7hzB+H0iLjAO4zHkeQQle7tKv1QkO5Z6DD/iaz1ikeZTLQMj75+XqdgNuHvL9x4E4hwOry8js+OgVkUhWedCUFK9syqVBRtaUbagrXX8I+qp+nJBq9klojfJSifVgFWpWXU0zKm/AK8E9WvYO1Xzl+yahbK/b3JyludmRwG9EwhbfWlwfoDKFjVutIzbjJY8WQ+7zKlN4Rm85ahQIE7Oxp2DXCW37MkmW2ZHQhkuCOplNFdU0yUKZ9Pi2WwqjgZXr10y4VOacdkwK1DI88qzLWMc6NzzS3a5M6DSyJnSz+jDyCc2gK4Q9CxQS4AS/AkQrekVm1g4/X2TpIGAc5W74Z2Eaeg376ICwjNPyIuYpTYQL+vTYj/fP0jdB75gfGbrhUcCNVuybe4lg2vmIQ/aHENw4LebR/2sw6dRUq9T3mjtE+9vNXfa+M7mW9585fBi0DpIQUjPoh3NvLpS9phOYXzKQDtFQFCBd1Cj5To0CiiR84bTDuGYcOY3krQv3TBWr4KaQMhk+3SOa8KojN06w6feBrRKC//zxTMqqOdaf3E7hG/XPMYlBXBNMhW3hy9Az7UVIBanF06Z7N9nhxSuk8oR5JhfJxztrZseei8NnlDZ70aM9xZLpbocFjeO6f1dSXnsL3+E2TdXR6zvBaGTq+A4ZGtpqiKuYmdBR07Bo2sZYWG2rz75cfv7mQjLQSTmyImKZeFpnN/Uyl97uzhwgGHzeGJRX+xfLDECaW8j2atICikTbgA6vRpvJE+RYy9Ya/XUIoUnI0XrDZxXKczQq4lgo1GzEl+vOJVEV24vDX7lscBFF+DTJGEeSnVJLJk6vVN1uNuEsw2K/Cpy9gpOWartLW1VVi0Qd336UF0E2/AQnci+XTw5aqcLmYDoVSQ9I7RzXGVcKQAsK8aalFlmADbfh/yMKj
 gSV9yvco
 oomFjuRP6CuNFYRZMWlQRwMD/AxfG2ZcdFv7DGpdc/IM54vt3Uowv17aAa5kgEF0stiE/AxqonBs6xpvjxxy/BZfYvcyFkmH9/gwQrFIK1hHZn248sTJ0IKeYJ6EB1evn8NavGvxABye8S2j0Vo3HqaizH9RR8jW/5i0mRGEkj642Is1duKEHDwE43XyVUJ9+XrWwLUdadW8k84KGE8HcH+yM4yAALSLRqEsh7Yx/kbUMp44Uuep4uQF336thrD+tq/z+oA2jozzPR7xOyZUMO2ORvOTjkd74WONPQ/W1M2NFek1lHMT2/vjnNQh4ptDWPIA6Xf/bXeraDaJXWdObtQVDwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 08 Jan 2026 08:40:57 -0800 Breno Leitao <leitao@debian.org> wrote:

> Use Kexec Handover (KHO) to pass the previous kernel's version string
> and the number of kexec reboots since the last cold boot to the next
> kernel, and print it at boot time.
> 
> Example
> =======
> 	[    0.000000] Linux version 6.19.0-rc3-upstream-00047-ge5d992347849
> 	...
>         [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107upstream-00004-g3071b0dc4498 (count 1)

Nit.  The above snippet uses tabs for first two lines, while the third line
uses spaces.  I don't really mind this of course, please feel free to ignore.
I just wanted to prove I did read your cover letter ;)

> 
> Motivation
> ==========
> 
> Bugs that only reproduce when kexecing from specific kernel versions
> are difficult to diagnose. These issues occur when a buggy kernel
> kexecs into a new kernel, with the bug manifesting only in the second
> kernel.
> 
> Recent examples include:
> 
>  * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
>  * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
>  * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")
> 
> As kexec-based reboots become more common, these version-dependent bugs
> are appearing more frequently. At scale, correlating crashes to the
> previous kernel version is challenging, especially when issues only
> occur in specific transition scenarios.
> 
> Some bugs manifest only after multiple consecutive kexec reboots.
> Tracking the kexec count helps identify these cases (this metric is
> already used by live update sub-system).
> 
> KHO provides a reliable mechanism to pass information between kernels.
> By carrying the previous kernel's release string and kexec count
> forward, we can print this context at boot time to aid debugging.
> 
> The goal of this feature is to have this information being printed in
> early boot, so, users can trace back kernel releases in kexec. Systemd
> is not helpful because we cannot assume that the previous kernel has
> systemd or even write access to the disk (common when using Linux as
> bootloaders)

Sounds this feature will be useful!  Thank you for detailed cover letter.

> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

The patches also look good to me.  For the series,

Acked-by: SeongJae Park <sj@kernel.org>

> ---
> Changes from v1 to RFC

Nit.  You mean "from RFC (v1) to v2"?  Again, I don't really mind this trivial
thing, so please feel free to ignore.

> - Track the number of kexecs since cold boot (Pasha)
> - Change the printk() order compared to KHO
> - Rewording of the commit summary
> - Link to RFC: https://patch.msgid.link/20251230-kho-v1-1-4d795a24da9e@debian.org
> 
> ---
> Changes in v3:
> - Remove the extra CONFIG for this feature.
> - Reworded some identifiers, properties and printks.
> - Better documented the questions raised during v2.
> - Link to v2: https://patch.msgid.link/20260102-kho-v2-0-1747b1a3a1d6@debian.org


Thanks,
SJ

[...]

