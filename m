Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DE5D6ACE6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798066B0088; Thu, 18 Dec 2025 06:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7457A6B0089; Thu, 18 Dec 2025 06:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BCE6B008A; Thu, 18 Dec 2025 06:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53F356B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:14:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C3225D6A1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:14:41 +0000 (UTC)
X-FDA: 84232333962.26.9151D60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6ADBBC0016
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:14:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egorarpW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766056479; a=rsa-sha256;
	cv=none;
	b=R5BvEH4zFon4cXzOIOYWHqvX+AK0m6PYc0zhfA/k8xtpZ7Ox8YW3RNflWRG9LGk7E8DgP0
	SLrj7H2JxqZq3NUZxQX2+Y5Jf2EZZvnxH2edr+vJ7cjAecGehju3D6pyciRwSBacbgJdN7
	cSYd3klXFP0mk4mkjrvsx+P5RoD+x/E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egorarpW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766056479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BC+voBklmBncdbz7LgS6tTEuqKvoh47neaxwgNNvFN8=;
	b=6Og04ODiiNBFCTowaiMwo5KmSTLzpxBgkBcK56+WPiZ9MPZd/rCruw38Gscjh/0yWB8Dks
	TjuHsOW/HkkZnb45eB+ZW6SjTmUX878G5SqHMaMPaxkFFy+rnIpS5Ab969mBHBzwXgsslq
	QYpkwHrD5mmu1IuvPxCBS8O5P2ANtS0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C2BA60123;
	Thu, 18 Dec 2025 11:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9754BC116B1;
	Thu, 18 Dec 2025 11:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766056478;
	bh=SFfHw+gNDeL04MTgco6eRs85Hk8QbOOz7cCbU9x2/c4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=egorarpWQXjj5DHb1LTP+iqt8XAowsi//jUM25yDBwoWC2Ddzo79nBvYEzIs6ww9q
	 MX2FJfeiZrkFrmjyOEp8bbpwdVx9nEGjizPaCukXlCdIu4QufyewxPKT/uv+7HZkKP
	 3XsJS+prYpl7Eb5vHpq7sOHdFIzQSsWa9P4ch1+JH/79KXJYMwK6Pa9IOPnYM5RgI5
	 zqZGRdS0+DTCHcso6i8nMv47zEVrNeV3kYT7FnHc2kN0rGmZHTOX25Er3gAhDrX3ka
	 gDWbg27foKRRN6/FKEn1CchUTgpLL6mrvBEs9riDFnKgYN75343GfQHn7VHnrM8AWO
	 k5wBbhCpkYkyA==
Date: Thu, 18 Dec 2025 13:14:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: chengkaitao <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, kevin.brodsky@arm.com, dave.hansen@linux.intel.com,
	ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org,
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
Message-ID: <aUPiFbuaglcjqiB1@kernel.org>
References: <20251217120858.18713-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217120858.18713-1-pilgrimtao@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6ADBBC0016
X-Stat-Signature: 1u554tg5pazqhtnguo5p4u8fapmbwdse
X-Rspam-User: 
X-HE-Tag: 1766056479-604177
X-HE-Meta: U2FsdGVkX1/MYDPBIHkIjzHcKTCyj9kapK7uWP2GSXua02DYGGJZ0Wq5jdigM3nVXNfktLNBIkF+crA11w9v2YhhGtVvUIkxoDby/MPpELfzSxTT2bRRCWTHtln5sseVIUeIUIq3tECUmNPA9cyMWB582DCBnjs1HlOIZLyB+LG4McLjeJQ8epNpFBENh6oH/ZZ5uWgUAZFBHhY7F5MR6G8xxuRAXpEWv0jCjy/aKGnkF7uiY5/Sv0rjXdGcOpvLVpx6r5d3r6YnSq/ZqFEVgfwyAX0jVgLFk3ll1J4zsg9/CSf2ITQC1WRNEAtSE+5t3WH6t3fMYhT2tvwjBmCvvY4ZRCIp0KuiWwfHwAISRZON9I+3VQ4BRPDL2MqQIGVfSImEdkaBHSpBKI6nqbcVBv/pDJAVx35YTwd5ZpXybXNY3zAjf3WjYwGToqAkcTVZ5v+5n8IE2T64PcQ1c2VcdzTQQgQOpsgSsS2XoXpaXpsKHbgPDHRpWiknKRnaPW5EtHbE6WerVQgQVeaWfieRkyElBZ4+ld4n0gki1J054ehKNttFwHiIMdPnEbJvkWsdD51IkT4BM6uxaRpqdbCYdnLSEDzrgv0fsgEG59cKAuqn5C6FcAUFPFllQ33YcO3+rMLFsSvO9LY28CdFtBI05hiq7juHnJE5f0r8JxxI1t2BBkrL95DPER2bQulWelz4zV280yPJZO4PVAtiL25VPAzyrzOQEBllYb31w5OyzQr9BgiajCdp2EEoHO/vpFuzURD4IGkfouMpk+4LEgTXE5IcGnrnAhMVDNlfMTnlk9Logn9bMZfRl1M9ASCo5uT1OMSbQuwBgQE3HjXPQssk626nEmvzyG5fHTD+6DNt7vWBSq4LrObycYZ3IPEXXaLdGv8tVIjA2KM6q3U6A6F+yNdVvvuAjLoc0Ipa7R30eWqhZr57rMdGmI95IgyQTGpUpwWolhEwdbvOA4x9oLW
 CznwgjWn
 41Wif+E2/grt0CGpNNlSPmrGmtUY8kMHU0RenoVdJphzwN7YJSzmCQLlqoqQGIk7s96cAbSVsshbHbA5ejtMeb1Zokw5X7mtCSBMyvrAwZrknvrgZhTrrrnIrVxx08DkGlNbPMYhfFi1BdmTS+lvsFE6xZz4yCQwuUePgdgKDtIF3A8sOEsKiqCLxOuNVLiDmQXziz+x/ebvD4QRTOPfgpNA+/KSrFvBydEhhasrReB8A656dQT4JXswNAlDPFQdC9xjcVM3OdNgypJFuZUcvmXjp9L6E20HhW5guvXWfmkkMXPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 08:08:58PM +0800, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> 1. Added the vmemmap_false_pmd function to accommodate architectures
> that do not support basepages.
> 2. In the SPARC architecture, reimplemented vmemmap_populate using
> vmemmap_populate_hugepages.

What problem this patch is trying to solve?
 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> ---

-- 
Sincerely yours,
Mike.

