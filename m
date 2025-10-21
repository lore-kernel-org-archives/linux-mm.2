Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D237CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 20:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439BE8E000E; Tue, 21 Oct 2025 16:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411598E0002; Tue, 21 Oct 2025 16:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EC98E000E; Tue, 21 Oct 2025 16:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24C6A8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:53:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1A9D4880D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:53:36 +0000 (UTC)
X-FDA: 84023322432.30.152A814
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7B9018000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:53:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NaqmZhs9;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761080015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMD2Mt+Aax/FXSPhrfnndxDQXVlOHNDW4iZC9SKXRCg=;
	b=xoVwJITOfTt/vZa17g5qnLDEEnSZlQQs+0HEgcesy+WlNC86L0sQrHSfDM4gqiUincxr6P
	c+t7eHgV9zaanOB9BCYb7uUg7XgZw8ycBrpKJmUWYbXCta358CG2HXXgUEGF0qNWydILet
	QlcbL1YKZMWWefBvnu3cE0f842twlQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761080015; a=rsa-sha256;
	cv=none;
	b=ZxApEpRihwEiKRQzs+mPElRoGBqwB2MneqWAC7ws4zd3t/FTHVEz7LVnBmHNY9IK+tC2+5
	YdsTt9K6ap1KlYuHVtuH7ziF6sFFfnYDdfrzjc++RNzl4EERcILpfQoqyHB0xJ2XQFk/oc
	ARWjm6cl1ym10K1MOMi1tMJFKQP80co=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NaqmZhs9;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2987416DA;
	Tue, 21 Oct 2025 20:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1330C4CEF1;
	Tue, 21 Oct 2025 20:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761080013;
	bh=fI+yNyL288oWuuAQXpDX1oeqM1MuN31aastcVe2xSe0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NaqmZhs9s1YlmtvVI28BxFJ2yKuSAVgnxi9HuDWs+o9qn+J9FaCTxHYWqazwysrO2
	 swjyZvmX4vEjQbufrh+1Z1Lsn7JNmpzMP3YTVAbD5B9PNppdLLLdPfNyOrFYjGnPOa
	 u7bH6DvBPMHNDngTkwER1bydv9MHMeXRrNPdE9ZY=
Date: Tue, 21 Oct 2025 13:53:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, brauner@kernel.org, corbet@lwn.net,
 graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org,
 ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org,
 tj@kernel.org, jasonmiu@google.com, dmatlack@google.com,
 skhawaja@google.com
Subject: Re: [PATCH v3 0/3] KHO: kfence + KHO memory corruption fix
Message-Id: <20251021135331.8e0185a173a5fa40add60802@linux-foundation.org>
In-Reply-To: <CA+CK2bAHH1tzMEGxAwbmrLnLTzJANMntRu=cp0J8-n101ER7Pw@mail.gmail.com>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
	<aPchmxfh4ACM0vY2@kernel.org>
	<CA+CK2bAHH1tzMEGxAwbmrLnLTzJANMntRu=cp0J8-n101ER7Pw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: uph5cummfzag4neueg8jqx7az57wmg76
X-Rspam-User: 
X-Rspamd-Queue-Id: D7B9018000A
X-HE-Tag: 1761080014-895113
X-HE-Meta: U2FsdGVkX1+OPTYIIq9EZG7Y7cNdFdbv4pSHBROTLa3NETvIP2V0tuoosX1Gb/O35VgB244tUY4dQujp8ARdU8jiDE0OZHi3NSsqoRlVHDvfTpybFFAsgyAhsdrTfaL0OqE9TkNQl1jOrZzR3Y0DmLzGqOMGwIJBPA0OWwyD2237ZAVcOKyFdpDMNQP1PpZJjTnS4A/7V9mkZG8A4BQSUFp7moOo4eXZuJ1/lZRUpuDUH0F4upG7QgoiSkGInQTLIlPoeDbtxUtny/Z8uE1/6FQAkFk+qxSm9+rPk8hGGBc7aI/ANGrvm45uohtOnWgJu89u1v8oKBmmp9Ka7jgaq4j5BfgL0OQff+h64QFPNCdoRi+7grRZEG2TZU9L7Rpz6XcA6Sa7Ad65eRq8I8DDTfr5z6xPuSBtyK1SVTLunx5Cf27U0QNGRZsEtQNwLY2eHkEsy7aZoS6SQB+AzR4SFMcZdR5Q9btJ1ZEnKjIOph8X4+u+lvrke5l/oLFJbrcwTDugBvC84KMTt742lEyZgVjiLlQjMiEpP23HR1dMlILA7Y6W1yaWa0x5p7IdVrSIfD4A08+so9YCf9Eap1OMGmCBFzQAZcyG/NoUAET34NzFqeCqD+r0uY0M4K1l0s7bldohNa9+uL5K6IsvSNLSNzm6eaUq/V4WUTq7yHzxoh2sReyeCWevg/2WqkH8afV/2TgvS29J/mEHw5IgXXUtrZqr+/N3dQKNkrWdmW+FGed9DmNF8OUdI65SzKQWCL/iE08pKZiHms06hkxYjnfws9RD+ywmLj1MWweIg2+MUKqFbWRxOrOL6JXCW6VjiHHvwq7SI8nlFYsOnL4ZnVjUYFs44k3NtVN12BJxz2s5aNboRAaKqB5podXtiIlfCFWvYlvMVsDrvkq2mRFDTZ0tSdhhkN0LXNNB7uBdSllsD7LLhJFPZNlyC9KsSBPPs4PKIe8N+3BQOrB/Nux8AV7
 SNbPmQft
 +mBGZwAMknQhfBMRSYtdHscc7QQR1gv6d6m9JFKw/GwatumJr0g77L7yExhUERxkqwoAbbrXTnJw6oxO1Bld7EgcHCOf/3HWcE0sDwCwJUxADPLj5ijXWqsJlpMb43oSm18vdFRAb3wDfYQd+ZL9fYScfTioBUJjhIJ3V3btffpJzH96hEYtw5HD0O9ZEMMNMaNtIdFe6PL7n++oM86qmMvCOLMw7uFKp1r0ksWUl57OwAsQIR8iHOPuNKETQ1QY6BXC2FmDqgxnsKnQIWMyk0yg6JXVbdzJBMzySx+cBMrRtGyZk9tUo3tZX4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 12:04:47 -0400 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> > With liveupdate: dropped from the subjects
> 
> I noticed "liveupdate: " subject prefix left over only after sending
> these patches. Andrew, would you like me to resend them, or could you
> remove the prefix from these patches?

No problem.

What should we do about -stable kernels?

It doesn't seem worthwhile to backport a 3-patch series for a pretty
obscure bug.  Perhaps we could merge a patch which disables this
combination in Kconfig, as a 6.18-rcX hotfix with a cc:stable.

Then for 6.19-rc1 we add this series and a fourth patch which undoes
that Kconfig change?

