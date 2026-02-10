Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8613AEA8118
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 14:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FDF6B0005; Tue, 10 Feb 2026 09:18:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFDBF6B0088; Tue, 10 Feb 2026 09:18:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5A86B0089; Tue, 10 Feb 2026 09:18:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99B626B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:18:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E4DA1A0553
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:18:21 +0000 (UTC)
X-FDA: 84428752002.10.37222D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 763A61C0011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:18:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uon8PRAl;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770733099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmI0UXKkMOQV+CMq3AVJ7aplrsmXCWsJNwFaN98WL9M=;
	b=18ML8QFSzzI1Sf3BtUANoGJIVRpXVlWKpQ7IHBRIZfOWV7swvvpY7xOh8+IhJML7DOykep
	X1DWxlhKGNYhlsDo50Y+8kNwVoOEPKwKml57L/26OuYoq78EygUVvi3YhP51fmYMIMx5tc
	Icl6GfGgadbsN/EraNlEjQceYFnEc6c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uon8PRAl;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770733099; a=rsa-sha256;
	cv=none;
	b=nKlMaW52VDB016oTHuWUUC6hVRHyCoF2g5WzW15tROYFYOBkcI8kB2wTHRsKRtbxf+ZlwD
	cBW9ZckzdOHe1vdo8/Hdu2L7LENj0TO6zUf52YxNf3TeSyMCN+XcqYcvDAIHD/cGu3+ij5
	CjUbii5gXhnAQeOeU30uFG4A2ZcgSvA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB5CC60137;
	Tue, 10 Feb 2026 14:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC69AC116C6;
	Tue, 10 Feb 2026 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770733098;
	bh=pBi1oKngaOkxk1hANba66yN+MosIZrEJ5L5a3Ah1fog=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uon8PRAl13Fa3vEQRmHpfRyf9phQEjfFuJbA6AOZCVymgZbQLjGTWyyJ4ZosY1EsI
	 8nEfOr4oKvrV1BoHw9pl1Xhm6fd3HyMQ0sFwHpKjO2+sYtzpaY9yOUk8s9QuVsw7qe
	 ikJOJVlUe9GnLLL9MjdnjsHUmtslI9/OK1fzr5UBb8mLwHbdifX/zx9b0MmV7sYGeu
	 nWRenqSsitNmamtxhr1i327bvgW9tP2zku1Q2BRk+qKPFreVt3apNe8EIuiBBFCxKI
	 2IHqerhyf7LbFk7qwXI8KJYkyFrZJ6Ww6hh1u6bbyn7g7HFugpTppCc9yyZmGfxgbh
	 NTG4raCC0aAtw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jordan Richards <jordanrichards@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,  Shuah
 Khan <shuah@kernel.org>,  Jason Miu <jasonmiu@google.com>,  David Matlack
 <dmatlack@google.com>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/liveupdate: add end to end test
 infrastructure and scripts
In-Reply-To: <aYjVkb8qOA6yHDA7@kernel.org> (Mike Rapoport's message of "Sun, 8
	Feb 2026 20:27:29 +0200")
References: <20260205222329.2419035-1-jordanrichards@google.com>
	<20260205222329.2419035-3-jordanrichards@google.com>
	<aYjVkb8qOA6yHDA7@kernel.org>
Date: Tue, 10 Feb 2026 15:18:15 +0100
Message-ID: <2vxz3438smvs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: rzh7g4rwz43d8a15gftyaq4j51cojbj8
X-Rspamd-Queue-Id: 763A61C0011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770733099-65749
X-HE-Meta: U2FsdGVkX19K95a3+C7aftzIZtaIPfeUqTu/WH6l62zxODZVQ57IVRHemv4wO+M1IdxBZ5UNDpFUMusP7+zQhyNITby/OMwVbnYqTihjI43hevfnwvT/kZklnwlD1VTX2FP4sBx+j4uIRIjriTJ0Ked5SXo7LiKbsbzJP5Cbw4jthI9+GXk/1I7IsUBdbEi/QRAmFJQCN9fAJDcldCErUdMqPyAkhVApqkbokNv/lORlO8FVuS0WaxsAXgFfSMQXMmG9b+Qi9JtBR4RMUa4OfpReelYNzqHCvIS+fGa5ZGi0kTJNuVdMK0q/UKh/wZaE8VU1YckPSD6skiFcHRoWpWHzdM43iobsIpjRt3ZQYQ3nC3h7GJYi3E8BGbAPvy+jr243ozYxO0I5PIBoqG4TQC0YZV6cTPnWwzKZH48ooAb1N9nDTreHo6nvvQ4WxM3s2v9CNC186nBkVk3MrFpeho2AzXGBFBeqjpksO3dsf4DzJ/AFEufMRuR8DHGDIKDEaJctuguudCm/T2htagNHOUeZdRZK57OcEZW3mOHxtETfFk+Zk3y2ra7D7Fo8FTBTsinxRpn5pW+pZQ+e6p+LGMx8wbn14A8DoAyJNSd6jfszoMMTh2E72TO2jfxgWX/QKLHOmv+aEpLPZ3HTsaQLDKAkTbbCtHY15pf/0VEZKxAmtR0jVvyWU0AbqAK1+hZG3qdI02IESWBRGTNdyoCjaH4jzrhkHJaei0QzC35QOiy+uB2DkLx2Cbpl0DeZH/j8V9sV7/ziKeboQ2a5RvoAWqIjaGF/QdPfuKzXWeVkmK02Fr+j2KtAuuEEVm9qp5sGT0Zq/kjD5GauBjxhbzmK9C6QANdctXAORAVxbdpTtHrTHUxnRDKZyo4bUoNLPgA8/7CFM2Fl8pBfcMHJM0fI3LoxSbSckUW2OewwbKPfHHKQCVfU78hipGEcI0R+JE4J4+m39m4A36LCzf+AS1D
 jEuwI/Jt
 iZbwc2olsLDY+qlCo5g5C8JhwI6yMb0lXFaSLftYWrGwTPUuQmyaiSg48YPdG59dcb6sJsPLn2myLwkKj3ocX0+95m/mxqLIIkP70XPGXU8Rntf7hVcaA5PJJIm7iEfpmKRX9TWrJuZKoFmBBE5HtUa0lgjJZrpcVENqTuiq8AzIyFb1UC23CzywhV8it4baoFeMalOBiKqotc4cluINyQbjAugfb9f5winO6GHEpNj4cGwKUn7GWfAo9/LnzTLTLlzwT85RfZK4c6WyUzXiIVDgzFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 08 2026, Mike Rapoport wrote:

> Hi Jordan,
>
> On Thu, Feb 05, 2026 at 10:23:29PM +0000, Jordan Richards wrote:
>> From: Pasha Tatashin <pasha.tatashin@soleen.com>
>> 
>> Add the end to end testing infrastructure required to verify the
>> liveupdate feature. This includes a custom init process, a test
>> orchestration script, and a batch runner.
>> 
>> The framework consists of:
>> 
>> init.c:
>> A lightweight init process that manages the kexec lifecycle.
>> It mounts necessary filesystems, determines the current execution
>> stage (1 or 2) via the kernel command line, and handles the
>> kexec_file_load() sequence to transition between kernels.
>> 
>> luo_test.sh:
>> The primary KTAP-compliant test driver. It handles:
>> - Kernel configuration merging and building.
>> - Cross-compilation detection for x86_64 and arm64.
>> - Generation of the initrd containing the test binary and init.
>> - QEMU execution with automatic accelerator detection (KVM, HVF,
>>  or TCG).
>> 
>> run.sh:
>> A wrapper script to discover and execute all `luo_*.c`
>> tests across supported architectures, providing a summary of
>> pass/fail/skip results.
>> 
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> I think you also need 
> Co-developed-by: Jordan Richards <jordanrichards@google.com>
>
>> Signed-off-by: Jordan Richards <jordanrichards@google.com>
>
> With nolibc fixes Thomas requested:
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I didn't look too closely, but at a quick skim, LGTM.

Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

