Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857AACD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AABCB6B0092; Tue, 19 May 2026 11:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82DD6B0095; Tue, 19 May 2026 11:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999B26B00B2; Tue, 19 May 2026 11:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8326B0092
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:24:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DFF51405F5
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:24:00 +0000 (UTC)
X-FDA: 84784539840.16.F0B2C90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F3E740009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:23:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KYZnYUNq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779204238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOD0s3+Nm7YrRVW4EuyNWoyOgd63/WffAsBvv24U6I0=;
	b=Omc6yl9zyiPS0urGzu/0uFFoEDkZW16qFcvcRDYtUOWAVtF2BMmJyFich71QPc/JKEhMoK
	PwgsQIgOynV2SPoxWdDEqjga3rlcqvbNL0nIHjLfSRCvGk6aq2xZxdXuUp4D/F9DbVEiAx
	x1eiOUn47E1wEc2+2h2qVQjMCNfMeDg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779204238; a=rsa-sha256;
	cv=none;
	b=GE8xkcrJPqQhdUUcFK3IpWe/WAWjH7MdXIfDB4BxZTL0DbFluQeab7skNV06g8RXDVJZqf
	sCzk/8VTRUgEd3FzgBg800PHtIjxxwbsFo5VbhkdWoAa2YoH9NaD5ujeyZc4yckYqWeKdb
	fxja9EavH8eRN2hhSm+etIC3sfToV6I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KYZnYUNq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 108AE60221;
	Tue, 19 May 2026 15:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39324C2BCB3;
	Tue, 19 May 2026 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779204237;
	bh=I+IjMYlDv1l4GPKm44lgcCi3BwfRmTlX+eKtPHhhqsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYZnYUNq9Tu1sJ42jVFYrVmNjc4OMw6j4rHkWc8RCHgSKRCcftXwoeNUIWSz9+OS0
	 r0c02nrsnqNc6/JQjsTHsaeU37UrpfA8nClHDw5XOtuH5Kvf56lKMLFliBfQlkLWRY
	 rOnOly7/E/NAF2d3srHRek71+aoEYVHDdMQWp6krJsvzXg66vIfvRxx5RA6asbk2CJ
	 cGHQ0O/3wJY3ev9zpJ5G2P4UdLdtdWLML8qCUsnXmR/PIxXpQ740UUg7yaVjVlgxjm
	 OEkCYc8tl/MiNQl1JgFj77G3Ko+KFlK1zIH03Olc8YqjhtuFhozw9FJ7ZutA73ebha
	 sEYUKk1vNmAWQ==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Kevin Brodsky <kevin.brodsky@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] POE sigreturn fix and extra tests
Date: Tue, 19 May 2026 16:23:00 +0100
Message-ID: <177918804505.746149.6023931077901684027.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
References: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F3E740009
X-Rspamd-Server: rspam04
X-Stat-Signature: 1hbr5xniz96x4wuei6scwsa81sjhnskd
X-HE-Tag: 1779204238-621120
X-HE-Meta: U2FsdGVkX1/YxUvIVIfmd9wPvSBqQcmSGSD2ae0O9Qs+jcIrmJYXMyjViCl0uogwVYtPr/lLUwbqbd8k87CuWetUp1SShML4wQaxQLS38+ZAbrSjeIFlkwcuuf00pBJ3ZTL0aBcyPvkQbJfQOqbVQYJlkxGRu40excE3sqcl6hx/v8GxkCLw+WXbwk/kTe6JTpVO3UQuFr5eay13CpLOfiNrn6+ZwCmmUThdTNR2RJmgPxmQn8CuacuLB5yNtHNyDyeBw/V75v9+kNnJNwmClCphREVx0d2cvyWO4KZn5U7CyRybViXZZow0bkECol0R+IqZP+DKd/sB0+58hsov+69xh4BQgnkFlzROAJRgFyn3HIOoIdPOxfFgypNP1smMI/pnELVdLEhD5YPZ4P9UpYBYKrakQ2654sT4Nm9QH4oPKJtreOy8AUjwpZQ78c3ISmEP06hwexxa3QR4j8A1D/qqMthE3ERVMOvAHMcWeFqtl6xULRmaDBD7aWr74SK/3o/0cRcFpyR+OCURW68cKWjL3kl0jj5p0AE+UEQNJo/gpeISOfjFHcyRVMEH+ZGsyz2ZYHBEB8LoQsrWLzs/nclVQcRnBL9si1YnXU288etLcvDNKhujsfHiONfF90uw1kQd7dFP41u7nU8FfaFRhuru8MhDHZ2Pj3vGtZJL/aOI/enj012tuy3lPi42rE0uYbANG98VxDzVtpBmpnKF+I0zg1HxkxSMrBj/1gJGCqdLBF2E2riYo7eCadu19O660I3j9hd3GGXpdNiHEcqzs+SGDLDwuMMmxNTDhpCeGhxpwdQzkngbj44l20P6WRGBZNBJxqZDju8lkHv1JFA2iZ0/KX3TFGltJT550xfmzrjtYyWrSWJGxSu6xfccot43gtdtDWiNnWaoBinoSK7oPmM5bGLYBIqyOAqq6V8jn3dYOyt4bCA7ERdWPR0oRZQg5AEfWcUZ7BS5W14LDjE
 mUfS8DFM
 x2uNyW7qsx1rTkuOShW/2OwHQ0zhuz/pGA6U6EsO3qynbC6mi4Ayje8jjvrqb4QW/f0YkNPPZMYRse9JIIAq5i8hDW6Kk9kjQKfaY3GVZ8CEVNyEMlj/473kPMASIwZ92ZMMyGerVdFEVbm+13fib983Lj8ISPzJhl4dxiKjHRU4p0Hqd9AxYujpS0vhrIbowhJQPfbVX0bUx3US6X6+8Q5PMza/aTsriyvAnKzQHXQGJ29fS7ARhOuHNyK5+HGsb1pVXJ70WcvXLGcpJhB9YG5d+LRTNcuniGLNwTsaexq652tA9TxNU7VY1hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 13:03:32 +0100, Kevin Brodsky wrote:
> Commit 2e8a1acea859 ("arm64: signal: Improve POR_EL0 handling to
> avoid uaccess failures") introduced special handling for EL0 registers
> that impact uaccess. This did not however handle the case where a signal
> handler removes the relevant record (poe_context for POE) from the
> signal frame; this is clearly not typical behaviour but it is legal.
> That commit resulted in arbitrary data from the kernel stack being
> written to POR_EL0 in that case.
> 
> [...]

Applied selftest updates to arm64 (for-next/selftests), thanks!

[2/5] selftests/mm: Fix resv_sz when parsing arm64 signal frame
      https://git.kernel.org/arm64/c/c364aa56d673
[3/5] kselftest/arm64: Add POE as a feature in the signal tests
      https://git.kernel.org/arm64/c/42c21954063e
[4/5] kselftest/arm64: Move/add POE helpers to test_signals_utils.h
      https://git.kernel.org/arm64/c/925a082ec2a0
[5/5] kselftest/arm64: Add tests for POR_EL0 save/reset/restore
      https://git.kernel.org/arm64/c/f2db075234c8

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

