Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C5A7C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A066B00A9; Mon,  3 Aug 2026 09:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009CC6B00AA; Mon,  3 Aug 2026 09:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E898F6B00AC; Mon,  3 Aug 2026 09:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCEA26B00A9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:49:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 477AB1A0715
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:49:12 +0000 (UTC)
X-FDA: 85060089744.24.8C9BD78
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 903AC100002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:49:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jP6M2uYn;
	spf=pass (imf14.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vppcNem+/uo+BdpWJOuNKXnTzyQ2gSSWLfWfUyzhk50=;
	b=E8L1sVEF2+7spmyInHnvYJLMBAl6pOQkV+9Fbx8VKDI2JIg7LB7jCKKsaH36bw4uMO3W8H
	ocRthwij4xboO4v/KzNz2xwZ9KoW5nYyG1IdDePXbEjtzotst+tvelfds0BbIkieWzYD9Q
	MjKAeob8s5vT3uyLOJWlhdRE+eIvuHE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jP6M2uYn;
	spf=pass (imf14.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764950;
	b=DLsVVT6ysThPRtAUPSai0HrLMuhkqe+rG0FQDG3ilJuEBn5300hbUvH38LqmInSoytnfV1
	dkL3Tew+QzYP89rwUY9777n4xnpKi2S6HBgfsOiXIRPSbuBuAjztL+/MYiUOCkMnCUQenQ
	fzGg9andqQ6HwTz0VM+rCjnlFW4sQJI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 896BD1476;
	Mon,  3 Aug 2026 06:49:05 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07E273F66F;
	Mon,  3 Aug 2026 06:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764949; bh=juW1OU3jkHQCumb5fbsLvS42OPNvrGm8Yt7XMEkLCtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jP6M2uYnNSCailFRCzB1MJKX+alMEwSoixfhNakZq1H8HBFCmDK0obThnTPn94fxQ
	 AYEHO3Jqp90eU1CKlgK4K9bN9MUrXxq+9yQSkRjzhSHgeU4KCTSyPbdFw+jPkMOnko
	 dNLC6NAkXfVXpOriJT0hpzWTc1KqsK5gSchCXb2Y=
Date: Mon, 3 Aug 2026 14:49:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/3] Documentation: kmemleak: document the conditional
 min_unref_scans default
Message-ID: <anCcTycVzQcYUjVz@arm.com>
References: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
 <20260731-kmemleak_hardened-v2-2-7b9689ac77cb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731-kmemleak_hardened-v2-2-7b9689ac77cb@debian.org>
X-Rspamd-Queue-Id: 903AC100002
X-Rspam-User: 
X-Stat-Signature: 7c6cqng5hsdj7539ec5oys6sizmwqcka
X-Rspamd-Server: rspam04
X-HE-Tag: 1785764950-691888
X-HE-Meta: U2FsdGVkX18IuOlUx5nHauWsfGhyGGB4EeJgqP3wxdpz5M2aLv+UPcqjeiluIAFOXehc6ysuUZcYj6x3ldyHNTfBByvvaUjoWuA6KZuMXFDrodJMuTWXPWvyX4G9xeiUuckv+mRhsX2wC0O3AuajxA71hirp6uI7+20/E/OrZOkGHQ6DLEhQ9L78zaQ9jXNjB+nON8yrYZkYi71LKTruPmOpUbjIbtzSk8DBQs9qVS8i/Tu49REUkKykVdxM7PVYINAM3seT7mZCX5XPbSEgz81mUz1yOhd2AbdcmQE1zyGBuFr4QRNjotUtBZdcHXeX1fm6sEq6dPCwQSlDjmTTFQNFChiyMNJhzpAA8Ohbjj8qOBvxTOImkMQtDZV6d9/KNFLE11xFeQaXyjscxWjSPmZGJ0ArE2iHlOK4OSCcSzPeEjaluF6u49E/j4cCecC0NgMHke89CQRYCgZuk6JfEktqNoNAF1C7eTJWY88CAdTpahTW+AeMyCCiVanw/PBFn5MBApAzYK+OFx754kH1Q8ydQnb8eNyNHAqSqPJ6F+NGcmTMfR5Ep9FYybI9K4XkE101cSr+QZpHcj8iWOpj9vS0Rr4mEimfjr+MNrqG1bnER7bEB9k0JuKpVvQ8zUS7YWdaFhU09xItT5k+rQpM91B2XMlgX/sblO3m5AakDmtWV/xurXZh7ERzjLmDa963XAFGRGzGFhFRwnK/piC20AT/3cbsuerbc3suQqTvmzXDRgndVoF7ruPBgHWUIc6pPnYIRF3hTN4gfBh9lMqcjrEUPjlBam0mrVi4JOHtSCxfkMzlCTkEwschtjs3Nx6kG4eGkSjwAxnz61wURQnSUh/Nk3cjukD+UGa4wfqlquVS5rpwb6FlS8AzGL3Dts2X/6b0QfHSNVk0toAO3Jkd6twAF0aniMj7oP661peHkLmaVHHXmdj6pWiXLF7GumlTk5ZEJ3RhXGZgfEx/SnB
 +s4gLihZ
 +YygOGOla4VhaBxN3V8UG/tsVQCtjetJc1rlE6xntRybGmKjat7rg1T55U0xI/Ix0Zidb/lJI4fpuWW0itWCT9KjVXA00rsgGXii0Uh30KrFhs5CQCOM/Bc1DYrNSvqfrtLSr4HLQWgrnnjGgFKI4kjed2mobGNKcCKznOvmsozsG4XviOB9emNWCNwt574vgg0jKTog7MdQYIlHs2NK2ZTP5Y4ckVYKJ8E3uo1Ipp/GpuNvSI2dTUjj8Aq7fxc0HQx3f50rX6czRkALPZxF3kHcJdjLvtgzF5tMNR5C7Pa+Clt52M0kGtgFrj99VXNOUL1XfJsPOcVlkoaU4cDNfNVt6Pq0L0+EvBGRzFh7BpR6Lt0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 03:13:05AM -0700, Breno Leitao wrote:
> min_unref_scans now defaults to 2 when CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN and
> CONFIG_DEBUG_KMEMLEAK_VERBOSE are both enabled, but the documentation still
> states that the default is unconditionally 1.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

