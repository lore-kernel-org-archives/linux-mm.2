Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B36F43698
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E80F6B00EE; Fri, 17 Apr 2026 08:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BFB46B00EF; Fri, 17 Apr 2026 08:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D66B6B00F0; Fri, 17 Apr 2026 08:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5D96B00EE
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:33:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF882E276B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:33:43 +0000 (UTC)
X-FDA: 84667989126.05.72B2CB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 18812180002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:33:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NiHFQsFJ;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776429222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVi2OosZIDjN0CWEeqrjWTUINoPWYfAg26511zqWrSU=;
	b=M0KGW5q5CDgT7LkO+LXqZ2d1kr5fsf5HPIQGfS+FzQyyxx4/kno5vuiBWYpIZ91wMSaJgn
	0tfHxDlpn/rAhEXRgTkC9vVQPgvwzQNiMcHfxMrphtMIXvXHDQV3JGljqNUq1okGmLJjNA
	pF2EhPCXAX2YAW/JXttxgMdGeecM0OY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NiHFQsFJ;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776429222; a=rsa-sha256;
	cv=none;
	b=WczAhYHSnaGfpApEbj8JkNUZi44MI51/4GYybjP8p3/Y6eBkfJGj2cl3ziKvDiRIgsmW9w
	9aHQkskhttRxICJC153+gQ3eETI+SqiKfxcKxvlDNh7A0iM+K3OPfzMIJj3EFdVUxbi/11
	WvdZ6Y/s9NccQ4o/6StHNVDyaDRFn4M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E5E360128;
	Fri, 17 Apr 2026 12:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2159C19425;
	Fri, 17 Apr 2026 12:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776429221;
	bh=Wsq49SzVrd9M5pMBi3guh4m0X172usecXFug1UEbII0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NiHFQsFJ0JSQH92aJZGAJjmwTvmp/lA9hLkHsMmeXEd0LGYrnyK8jqjqOq69LASPO
	 n9I0HsFk/komPoc4QCYRarbGd+dlffjTZ0Byx5fMQ/u+/Z0fGFUnZ+/KaCRhM6WJ+z
	 VJGLdWC+/JjnLvihVk8ts9eg4qGGv1nQwbPunKnF8aRcxEDAEUE1HZ6TLx8fJZnjhr
	 BFghOIzcXt6S1iO4G0HKWA8hKvm5rEI1cpmKQHYCoN7FxUnUtZ5aHuchwpjC/B4lV/
	 vFLqOuQh4EjNmtKmCcG5R2XBl0L7rpFXPrx39mioKZJXoOkpmf+yvBMXf4LuZQYmtx
	 jEBe6zjDMA4Wg==
Date: Fri, 17 Apr 2026 15:33:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
Message-ID: <aeIonE2r89VdTJZt@kernel.org>
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
 <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
 <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
 <aeE4XSuXY8RfphVs@kernel.org>
 <8260f624-7ed8-4766-8f80-0d0d4dbb5cb1@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8260f624-7ed8-4766-8f80-0d0d4dbb5cb1@sirena.org.uk>
X-Stat-Signature: aj1qcpj4s3c9xj7hhe8yawd3899spwbf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18812180002
X-HE-Tag: 1776429221-304711
X-HE-Meta: U2FsdGVkX18rIA8VwAqRwGRKfVbjWFYmKgRwHOZTPgjs6OV3RI+AH1ggb78HEYrMVkysu3qyZJkoEWucbdiiXg1OSa1h0lhPRxpSuppbjrGZ7+BOdnYDcgQE+f7RdMSYhkwKTq4uaFHR+WxwsUYnuPkHb+MFcSH10co2Ue9rEMOOLNvcuvX1TYWSL9D/HCkgUgaKT3Rg1CzaIwXpjAthDVmhic0dGbyuNuOTYSMq2rVRfYPc8z1mi5oJwfnTws/QfQ6wHeYO2MiiIiRIGnRcTgyBclfGJsM4F7TpHw9WPxnt/cURZbaODMD/b0C443bOzieAN9jMziCNgybobmGzW1EdN9n7gTFyNW66fUYysZFX+1/4nWHPgz3p5ZR9kmovUrbS51XLg0JBv49zc9XaN1xBIBKmzpOYLNRNgVT4i4apOl4d3RTI6Ckj84zCPQEqQ6C0PhfcFeQA3bAg5JfpR1l70lePGKeeTSw8uSRxa3/wSNNDjv5DTJRVMnUkJN+PlU6RZ1cnJkfc+I0aVSsgsBMh9rfy0S8Imqvw/yjfgp+QmfN5+VeyMGUQZlABdxRtP07mdKq9Kks6pU34uefMyh1kCf6WfR9BGQpJqePLjxpfQ7NP4ZdSQniy6XwN9boDFVThFjq9xxgxtV7Vy1McZIJJ6qBnoD3WMIQjD665mW1QzsRFeiY6R3vevjYl91ZuLfSLyQ/bcsljCt6y5dvqvaI+HLprUdbrwvQPHb4NkJcUEgeyNskCBCIXP8uSHFVa8mBvq+KVqfVK5XIY04GhUsb9+IJ3thI3SWeG0h1hvCEUu1shawMptZpYfVQh/Fw0kvfnfbFEN/dPM0eBlZw3iMbGOM5zN7sHqjRbxiLiVbkGnjcQGsausuJ7bCJkfIQhhmOtzIRKrWpF0FgFFvgqLl5DJ4ih7J/8TOFzFNIpWrHO4538tLiazTy+cGETxTRrJUB3XVwa5mFKVzy605A
 anvzWkOf
 arcM20zbFJh1dE+f/K4WsJt7+ldPvPbKpPDakumL0FHTVl0V694AStyP6NItIGh+fchGf1/5pFyUZpp9Q11Q81lYaZz22xfRq1uL/eKbX+QCuSlulaQC624lND/U6zgCRmIL8MT4HAO96rea7zGSFReLVXlspsOw+SsvzlbKnb/Uggjyc4ynMHm05lbgBCzl334tIC2XjlLt3yevzcl6eC4RoiZQpeHyiDaQTdXjrDfoArIm2n+kxnI7oN7NRltXPxBnKiiA5rsAqxegXkfvSSymj0WZGdjpubRjHpVN5Cr/zz/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 12:24:25PM +0100, Mark Brown wrote:
> On Thu, Apr 16, 2026 at 10:28:29PM +0300, Mike Rapoport wrote:
> 
> > But sure graceful skips are better than failing the entire tests. Would be
> > something like this:
> 
> > @@ -622,10 +621,17 @@ static void test_prot_none(void)
> 
> > +	mem_fd = open("/proc/self/mem", O_RDWR);
> > +	if (mem_fd < 0) {
> > +		ksft_test_result_skip("opening /proc/self/mem failed\n");
> > +		return;
> > +	}
> > +
> 
> The string reported in ksft_test_result_*() is the name of the test, it
> should be the same name as is used for pass or fail.  This is used to
> correlate test results between runs.  The error should be logged with a
> separate print, in this case ksft_perror() is probably a good choice.

This should be probably added to kselftest.h because it's not obvious.
 
> >  {
> > -	mem_fd = open("/proc/self/mem", O_RDWR);
> > -	if (mem_fd < 0)
> > -		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
> 
> Yes, this is a preexisting bug in the test which I see there are more
> instances of :(
 
Do you mean that ksft_exit_fail_msg() should also print the test name and
the actual failure message should be ksft_perror() before?

-- 
Sincerely yours,
Mike.

