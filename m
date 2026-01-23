Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF03AD7236D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 10:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D48C56B04A3; Fri, 23 Jan 2026 05:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20D86B04A4; Fri, 23 Jan 2026 05:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56BB6B04A5; Fri, 23 Jan 2026 05:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1AE66B04A3
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:16:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CA9B1A01C5
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:16:25 +0000 (UTC)
X-FDA: 84362823930.25.E99965C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AEDFEA0003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:16:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pirA/R+/";
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769163383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3EPlpUGJunQoUGaaZM9trGxfnzW3diVZbJ43F4q9L0=;
	b=qX5UiJYkCMfXSUK8hxzLFvF7M14M25bfIHy9Znq5TE7JnzNimaW3Fh78oDeH76P6gN6yc1
	3RdFdip84NaISuxY7SGp1OQUs3uc0oPv+AkUYPzcL+RLZMquveg60G//NL1EK+LFGvu5s9
	iUTHZVaFnl74d971Is+DH6CQT2nvvhE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pirA/R+/";
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769163383; a=rsa-sha256;
	cv=none;
	b=l6JEagtjuFG69LilMpqAhEDhZoCfOZ3tLXKBPOGWOuX3a/YpdtfSB7ub4FvvmZo624XkA+
	sldcoMXgvfahClP1QEeoYd7ES7yWlCvVzpa0uuzL07fowoVaexd0u5GSc9mt41sQEKb8rM
	pwmLNPCnRFKOOycyK5q5KzrYrwplmb8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D49260136;
	Fri, 23 Jan 2026 10:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B969C116D0;
	Fri, 23 Jan 2026 10:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769163382;
	bh=dV7OD68w4lvCtztzozVMpLB/2SClOxfAXtVQLTQ5gXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pirA/R+/2zZgeVASEHCvXJwdGfbcUhC/QEgvd4O6omiCCGSmej7CWGKARHZz93p0o
	 Hu+pwhUc+Q7HNGRU9x/u4IeyvNf7yyVpI/p1pvrANlSj0EkVexzyJoV5tNraPP+yYW
	 KDOesYJYyjdieoPLbcUbeS35UyO8A6mOYhMn/3qO7IP/NNL204fSii3deyrSaSieEa
	 Fk4XdbvOwBo/R4SFPulWYmVwaxbCZDE5DYeoTstZCsJplKcwrnRVJmnfrbThOkHu3l
	 Vlq2addVfCkNUBzg5NoLy85a04sbN5Mx4IOpJLQ27wyxWaMBJF5rNQzAqqkQuQQwLj
	 XgkVIHS/LzbgA==
Date: Fri, 23 Jan 2026 11:16:17 +0100
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260123-tapir-perspektive-e6466483739a@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260122032209.GE3183987@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260122032209.GE3183987@ZenIV>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AEDFEA0003
X-Stat-Signature: 1j1uxsnxdjtkqgf5wf67y3qmmyfqexqo
X-Rspam-User: 
X-HE-Tag: 1769163383-55025
X-HE-Meta: U2FsdGVkX19w0gO2BEo8qDKjCVCWnGhdnEi2Mp3qn0bVdVrQBFBbmCx5ig7UuW3NJoY28qXTerAfNDu0CGWtXDwJ/JDkrm3ILG5c0j4jd6KvL4gcuLLXrKbhgLvY3+KZ6ONvbZBSU05/V3F+NmWE2fXvnwHr0ORn0CY/zSTWvs5k1mH57k0OVfXdKcCrvgftOXjNPpoa+Ox+uIivbdXQinwxdXOgyTq+sLd1AcLTTxu9zrmJXzPjdKzb5iIEq+s/6Z4kwIA1WQO8L17MqiUEmzIlrtaSR49SWX3U7rx2gDKaz84jv6mrnejitIUPto2l1iOhpRHjD7Ml1o5B32jOQ75lk06VeB6QHcQv5bs/tyruZjxyWeozqrXYm9brhdUxN/9lw5iRrJ4dezxCiHK+u4H4YU9YBiWQ8GlSvf5yiIto1v8XbuT2mw09ukC3emfr7Vtr30WJgfEecYyPS7vFUTXf+OIiX8cpOAYH1nI/VxojwQ7zhhlQUHscgtRgiECtVu4P3WBBuYAFHWpXnDmCNEaW0S6084hc9yG8YPXcF8H4lrOt2so3Fbh7IQhZB+tcaYVWBrkwJkmjdvPQjBQXRW7TZcVTP7DqkeVhKx2RAkbxDZmWbkvC4lK5RRo4166J7ORPlRLQsb1jTE95qAZF23U3Db2IBHP/ZQszoQQshqEHLsLtFLR/9KW35JvOvRAIte5ARmPcNeXECj2xb6vIj6D5OmI8ijp3016umd0RZXGAFIWixYvtFa1ljrwq74d7ep6cMgEumksv7M+3xAwfQr/FiSjNsLKCSQbfsQdcBfgl/7PVABai8oWsQM6uLJlfbt65ZEB2AGtVcdBOZsxIDF+GYNTEHZSeuwHuFjj7LH3ww165seqSIFrCjkxoSbpUQOhe1SB2ach0rVHb0e7u+63BvumbXaOYenl1zwqkl6BFUoCq9F5STirVF7cxBtrK8Or6x5y3sFE68eWkg5C
 ItXtbolA
 Gw+F8G9DSjuNE0cqEng5RhaTVThVQfeH8w8osWqENxYy6wINyVK4t3Pez+L3OKItx6mVmW8yThLsh2N4ySOZH5b7q0r8duTFWfKZRfR/Dyclm1VjQraftsjVYThdKERMTqLJt6DrqT+gt48Kgcsd0nTls4MebkEhSTn53lUSUsbRn0hJFbCOaZ9bFB1VbcUyU4sblOTVmPrQKbe7GqBbhRF4Huibj0UHF4esoEEVzcfmA2ZCRVOqaf+2b0SqXOrXAjeK876khPKgWPeA8FQ0CnZ7gqp7H+NrhbCTBAAFBOXYXUxK441UzrFnQQw6oTE1MLvHO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 03:22:09AM +0000, Al Viro wrote:
> On Sat, Jan 10, 2026 at 02:24:17PM +0100, Christian Brauner wrote:
> > The annual Linux Storage, Filesystem, Memory Management, and BPF
> > (LSF/MM/BPF) Summit for 2026 will be held May 4–6, 2026 in Zagreb,
> > Croatia.
> > 
> > LSF/MM/BPF is an invitation-only technical workshop to map out
> > improvements to the Linux storage, filesystem, BPF, and memory
> > management subsystems that will make their way into the mainline
> > kernel within the coming years.
> > 
> > LSF/MM/BPF 2026 will be a three-day, stand-alone conference with four
> > subsystem-specific tracks, cross-track discussions, as well as BoF and
> > hacking sessions.
> 
> Will there be an option for remote participation this year?

I did already have you in mind as a remote attendee and we will have a
solution for such cases. But we do not provide a general first-class
"virtual experience" as some tracks do not even want any remote
attendeeds.

TL;DR you're good.

