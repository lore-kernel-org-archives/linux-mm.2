Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54AAECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7C06B0095; Wed, 27 Aug 2025 10:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF1B6B0096; Wed, 27 Aug 2025 10:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C296B0098; Wed, 27 Aug 2025 10:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 822466B0095
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:08:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AF151A0680
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:08:07 +0000 (UTC)
X-FDA: 83822716614.17.B96E6B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D944C0013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:08:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756303685; a=rsa-sha256;
	cv=none;
	b=eAjWrxdnZnjp/asnnnUP/JqBhI7JGrOQJWJWVVexn++5TpycVBD3+mE9t9PmnzdI7usYj5
	m66LK/4cCVZbTgbxihcQfLUTWUPtOkLlJhBi64bsmb+1ipRn6uD4LhwuLuK2eZdKVe1SSz
	RzbH1oixquGZi8ka1E+uAJlKelVyC1Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756303685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fm9OFQpJ8TNdll93XAozvKaYprxV2bU9eecmF9rjYNE=;
	b=goROrS0zSaMluN9klEfG55J7Vf1D7xKXphdxNqBhGV+orYz9E0WWbbfD8gxQ3cBZackkdp
	NUCUPUXQfE8AgZrmjSGhMPyVDZ9nQel1874kYk2Ku6cYB/Pm8/2PP2dVQPzsA7XKGT5Ide
	9BF+7U0HDQdc1YhhCvVJ7esb7qYdGmk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29BEB40193;
	Wed, 27 Aug 2025 14:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF39C4CEEB;
	Wed, 27 Aug 2025 14:08:02 +0000 (UTC)
Date: Wed, 27 Aug 2025 15:08:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 6/7] arm64: Stop calling page_address() in free_pages()
Message-ID: <aK8RQCvXKPQVEccl@arm.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
 <20250826205617.1032945-7-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826205617.1032945-7-vishal.moola@gmail.com>
X-Rspamd-Queue-Id: 7D944C0013
X-Stat-Signature: nb9w8ezbcqdj9g8btpznahz7gyex3hgg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756303685-847429
X-HE-Meta: U2FsdGVkX1/D9rLFPKQ2yGchByAeCOwoIw5tPSpeeCusr0g4GVyDfDll6nExh/vCC5SolPPQtzcnhjXd/1VS8L1YV34Cd886/eUWwakoZa2FEuddzB0rlk5vYlOub+lKT9vUVvDXCTmnBuqcSsdG4pjJ4FGm9tENwffAVvzdKenVGivCEHbSoNjT4w/0Xj184OkI7xS9wDL38eKm8NmJGXWWY/ohIO4WU25uhf0J1YryGpyIKJmcwMVm6IY771v1WhgZcYpcsedqJS6gnvuvtKGRnM5Mp3k1fs1ch4rAVhaBFTJwMAZXdN7mlXtRxT2X0TcmlwMWeIXWxV6LByj1mXYyMQ/tjwOg8z9Jhkmu3SusedoVyFAdZPjDQiuop9+RKyMZKSvEZHjJOLFNaYAuHDw1hHe9ddopIATeABeILXAPWaBBWAsg9RVhD1X7RdUHamee4gzshw1wQ6mCftGBRo2N4DSy9xRWByovzagNvK25uxcpEzQ59RINu962VcTc7Jt8Z4Zv3VbW8KTeRl8SFTGVxQ3499ImH89s+zfrx400ha6bxeYm/HnFokvOf/h0ZuuvypcWMRZjBn1U/7GGamzB+U1yt2N7xiWx4cRJz9q2bvNA/fp89V+3qxMwuQyS3ogrT/krnCGtb8CQOB6I+SbCiwUY3EJTeMfwAx3RLig1wxrd8DFZe2+WbAUD67au97sMSWhTk2Cj7btW3ca4beVL1SEaCGl0IcInVx8XlJvMWsTmLbdiOKX7nrNTI96mUtGDDPF/6V7v3QxOUSPIMBOlCcZOfoZFgylJjJp+IZu5+SvCNJyFbEFVT/MUIJutetjsVHkjaisMVn4vmp+ZYCYnn/thkEZyPJg7LuHzpImhOO6VoVX+4qW/1fRaJAQqQfSK0TVohtmAB9CA4OS27EbG9TVTC9ukvF+HCJmqqWxcWM7/M5iQHns3Cf6QZXSsme/l7soW3PPfQIaNvfd
 m98qobex
 GpzuDsCzi7wQNbGBfLPTawpSgT1gs7LARAs/51DeagfRvB94GK0ej6zFDBfvXBvFQPNLzjupE0fSBMQG5UcNXjVaRXiUgEZ17osSdPwTVORIh/rcpqaKYPjXTZvkO996yRQEdWce3iTPEie/jcNSwWr0WpdDQ5V4GRMz6OQf5equh1828li3ffV21oMWwNu600QxlVWZEOY459cP4zmrBKIRMwjqbClzXBBcwl1FOtkDzzY5LfpApYH3ZlXEWsoU059cwdIkprS62F7+FUw6oEfiC6lDTeZAz6oBEitpkK7CHKG9cqvxcZH+flph+0WuFtuCWsBg1DMldBWHtXDl4AOp4wmREBV/Ev+UqElsP7gBMKeCZCDTfKkztMI6OB0ALYSKvfEaE2dxJXt/cmhRlKBAu/f4EAeycV+nc7FN1vcDDQ+6ISaYvH4vVnFiywqlK+d/fG7TWaQFyHB5eJaS+Z+p6jCbcoQzM3yvR6IcLUwKzBpWAPv40+DGMF8uANWdP7R5UIx5vsI730ZcEVZfwAEZPPsQPis7a/LTp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 01:56:16PM -0700, Vishal Moola (Oracle) wrote:
> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

