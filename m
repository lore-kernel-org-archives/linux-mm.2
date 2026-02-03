Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EC7E87852
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 18:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6B46B0098; Tue,  3 Feb 2026 13:24:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EDA6B00A4; Tue,  3 Feb 2026 13:24:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7356B00AB; Tue,  3 Feb 2026 13:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7E86B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:24:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FF8AD4FB9
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:24:54 +0000 (UTC)
X-FDA: 84403971708.07.241CFF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8ACD0180010
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:24:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=obdfKwqp;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770143092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKKI6PY63fQVoyAUERW2J6saZRA3PRM7S8DEXwPlXx8=;
	b=vUQ8y13PYISaZE0K45RVSBmFrcCe8Y1oFgaXUMfU6FW24CrobY7aMnlAXv9QakxJL6S0ZD
	iTv0n5jQN567x0Y0OvhWq9HXHO+03OcyTKhB/A49cPSI9ZyRuALFZbrQD0DdsBxZsXt9A6
	90W8D0A5XL6uFy5R0nP6mJAcqiDdJcA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=obdfKwqp;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770143092; a=rsa-sha256;
	cv=none;
	b=XxtlBl9FiGlO8nTNCJBpZ7u53+2FrUME8kjkVNJFFYstnTNhqnYR+8EA7wzYdt7cD10/YY
	mDBTfKoz2Zl/q8/v3+XUAXLKCZdgjB1PO6NHR/JC9c6uIYUvhAwpqEkLxtgy4/GbWNwLWI
	6KHWPuldcWHOZWc8QFXsdMghcRjt+Lk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08A64601E4;
	Tue,  3 Feb 2026 18:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDE4C116D0;
	Tue,  3 Feb 2026 18:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770143091;
	bh=YzTjrZJbH8OeyKLaisUTbTaoykM0RuGcnlbNDerd3Ws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=obdfKwqpZsX/GP+rmROdAhoiPpdQEdBr9Jj7Rl06Nfa127mXROHBHWLvwnp50YwGI
	 /YZ+UsX7cEGVrA/NlsN/ZmrphOIrXjK7JrEmAmFBRWAgN8uW5s/x50anYbX74Sn/gl
	 f2gB+7AhCDKUc+iCIEM7ITUzOg1M+lyGNNmIelCOCNR/JtiLvJZdWy8sFih5IdiJr7
	 1w+cmIkB5rBHrfI/BsQ+1KYZ5BCKORWAsmNjLP5rgpFHpKY1l4quPqXzaibN6sdmgx
	 gvmf86im7mIGJm1Fr3umwigcl56+qHWMYtXHq9ixoF2EMEzalm0fJbiS9ZGdw59n6t
	 E5/+z6oD5w3FA==
Date: Tue, 3 Feb 2026 20:24:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jordan Richards <jordanrichards@google.com>
Cc: dmatlack@google.com, jasonmiu@google.com, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org, shuah@kernel.org
Subject: Re: [PATCH] selftests/liveupdate: add end to end test infrastructure
 and scripts
Message-ID: <aYI9bUEodBEU6Zq3@kernel.org>
References: <aXj28ZAsPhp7s5sm@kernel.org>
 <20260202214859.662889-1-jordanrichards@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202214859.662889-1-jordanrichards@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8ACD0180010
X-Stat-Signature: go3jega1s9nr7wqes87ekzyghpknbspr
X-Rspam-User: 
X-HE-Tag: 1770143092-644416
X-HE-Meta: U2FsdGVkX18QXRn6XeiLfwdTguduKq0VorWqZfaqmq9K0fRUioSRhvE/l6LDcfC3Eqo5u4ASJQTQaOMP7EBQLkJTmR5/3y9QBBxcxZMH+HkcRyULCUE78tWnA9+ygR/JCTg8Fu2He0Vpgv+OLKo7GkA8LApZKYLOMwVb+Yv/NtZQYIVi1ceHK2EQF4udwehxrb0793pdC5Wk8RNNBVa+J65c6VwuiiGdBs4lNjwa+DBeyLtLfidunfcN5HfuGkcy//xFhx+i5zHT/07QxvM6HSvQTiMM/R2toy8IJWm6YMTIrIKAqiaVAX5VOoFN5wXGLqXibZCrhrZBewxMhrkANYJHC8Ev/krYlsS5vmQubB678Us1PWhUuScoMkJe3Irn5NMghhEc2tx26Y6DuQcQzxDlpfRW7fxoqpM4X6VaH+BJv/TBniwIZ2fguCyzZyZp88l8Bm8GzrvKkV5Pnak8UVTLUlGtIL/xF6qhEkvrOb/ClXPjtLDWbZPi0soM/hpLEHKIP9RdhQaqdxxdvwMidi/Q9LCCfDERIYm1bFIbwPpiivlDmecIZCMVi5386Y0RxoYXwaFisUbQQ8JvMPyEb8t9EluJDXjduskWik9fABV25tBAMNSwcbvkITxu41NVSyUHOjQkY0JxHFct01lJOLRIYjto4lxz87S+kBEdfOe3cMMU3fgqb9h5ySM/mdJBRlxcpQn7PLjj3tJS28DEPu09/JqllNnh7b4Xvidq3L1SnxJ9c4sQiRzArlQYdqAWc/BpvLUSJSWF3+mU7/euUCChXk9Ixa1B3hzEjZDN1kBFoy3T5mruXwG0quh8foawIupZOCNmMmakrCvkJpYhWMb4/xpT5eXm8dO7sBBRPlpaCRWMrDqy+oN+pbuGRE3+JzIXJbDpS2YpLUS0/gT4tZHjcTUOimwDcIXGgcB1zYYl9bPVdou7rfXAUfpDU/Dmd2wkVhR9NGr9r+XtOeR
 kj4mnSrR
 5ZATrTqYxDX2HXjwLVwpHK+TXHlzh6CTG2bbT6EzJFeD8NwRoclhnvoVp7rjalU5IxZZkVrDtfJF0oztCLWUoTJymmPEhQlbOZRzEBxWDOb3fl/bwutd7oO+zylvV0I60PsbcFP2JFiYUcpPqdZDaH3g9YuWuNIT7GEroQqpfzMurk8XQ8Yk4JXYPpiAPBn9+/D4wUFdDEGRxmkJWiNvz/f2LVaaYxMgVz18tTLbncVP6O3WuJayVkI+dwtN34znyCOIRbZ9gunU21j57zyeBpfsvkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 09:48:59PM +0000, Jordan Richards wrote:
> Hi Mike,
> 
> Thanks for the feedback.
> 
> >> +int sys_ftruncate(int fd, off_t length)
> >> +{
> >> +     return my_syscall2(__NR_ftruncate, fd, length);
> >> +}
> >> +
> >> +int ftruncate(int fd, off_t length)
> >> +{
> >> +     return __sysret(sys_ftruncate(fd, length));
> >> +}
> >
> > These should be added to nolibc I suppose.
> 
> I notice that nolibc has its own tree. If I patch nolibc/sys.h,
> will those changes make their way there? Or should I avoid modifying
> nolibc/sys.h and keep this local copy for now, to be removed if/when
> ftruncate is added to nolibc?

I think you can make this a set of two patches: the first that adds
ftruncate to nolibc and the second with LUO test.

Then with an Ack from nolibc maintainer both can be merged via Andrew's tree.

-- 
Sincerely yours,
Mike.

