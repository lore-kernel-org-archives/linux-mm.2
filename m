Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A404CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EDD18E000C; Mon, 22 Sep 2025 19:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5028E0001; Mon, 22 Sep 2025 19:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAA08E000C; Mon, 22 Sep 2025 19:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0868E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:08:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E13CD8404B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:08:40 +0000 (UTC)
X-FDA: 83918427600.25.792F656
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 36477160009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:08:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="D/360iHN";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758582519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emhyNRhrBwQ4CdpIHjJ4yJ4POd9IH39xkLLPja2O5AI=;
	b=FDnBqDY8LHW8zLYJHpdWiQIFkUVaKR22VRuUSM5FlW8HnU8tAs47vBixN51Yq7r/U9A/Mm
	jEEf8EyiJGFGRjbJ8BTib0jWuvb83zFz2wH8swhu/lxxPXSdsDVt3AFdO4n38yCt5AZwl7
	tXSPeT+E27EWum6TcdWEJ/ihLSP/ieA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="D/360iHN";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758582519; a=rsa-sha256;
	cv=none;
	b=fbH0/TiQ+Q5lObyFrLcXVTCNTQ6d4tmJLWOAJYDKu5XrZhoB9rZFk9VYarnq9bOp/1QwLK
	6oXXZ1owzARgzpkhB79K5p/4ygQXPphpGqS3PGisxOOEFfj2GahDfTlkU/9hEGdh5w/sI6
	04QcyIqNLWwCxuFuXwWe8x49xmLRI34=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31ABC403F0;
	Mon, 22 Sep 2025 23:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E45C4CEF0;
	Mon, 22 Sep 2025 23:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758582518;
	bh=QmCUwDfXfg4W2Dr+QVycDtLbh1Xl7d+GJAEjUK5WNlY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=D/360iHNLVYROtKeN/fgEBdD6WzJbXBsP73BrcZHpBpzMiIiaUC0Hk6OtLYrHKxkR
	 g0KelA+qBAZXcUXf20lJgWNGk3lxjQzWxbfHU4DooTmBJABrOB53zHebZwUdQgP6mJ
	 Z7XS8B7HCEcpCgWbA971c0C/FER1G6pMwW4fHT9I=
Date: Mon, 22 Sep 2025 16:08:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "yanjun.zhu" <yanjun.zhu@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>,
 Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, Chris
 Li <chrisl@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc
 allocations
Message-Id: <20250922160836.8d0dc984ff0986b3809c9ab0@linux-foundation.org>
In-Reply-To: <8f893019-bd87-4f54-8238-acd8fdeed051@linux.dev>
References: <20250921054458.4043761-1-rppt@kernel.org>
	<20250921054458.4043761-4-rppt@kernel.org>
	<8f893019-bd87-4f54-8238-acd8fdeed051@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 36477160009
X-Stat-Signature: rb6qahywbr3qqrn478wshcef3io4cgmn
X-HE-Tag: 1758582518-17388
X-HE-Meta: U2FsdGVkX1+43eL+sPakyJYzW+lDgaU6zkasi4htbf53Q4Y1L8oefwklbQ6oLM6FY7/aITR+h5u/cf2rt88XLvAbtFoChKCcPAbM+XOti1ojuVIJkdqdHcbhkIJ5VG2nnMgDQH7ogitV507eZIikpJv41aGXQash0CcYkYWUGC1+9b0Hky7uJ9snujs1V72dllTwSBPY3CPzTaV1Ws+t9fhpXALrbZyWc0/ZYrxZc+7gAzOsPJkdfkk0kxDHxpbMkIk0aBJPKDNenNKem/RJC1a7jtx48U57MG0s7m/txivAlBp2auaO9J20soFCEUt4JiliaqKGI0gZ2NAHY2CFzLfFb3EWiUfaUU9+9gM67VcdL/KbwEs6axOHrKGvMiUeQhR8AkB5ogj4+fahVYe+vzpqNH+gEH6A9HkyCXqZBg74haVdM6cI1+t2iI1j8MMcodoaUAOjnh/o5cFi7GJLrRalUxHSE0+s9iw13neFI/KrCRJcLdCgILqUSGfKFOFbI3GoQbif5wUiaKVd7AY/HOsq8ldE8IsOQRPbgwFEMGwUitnNVnBAfi2iZyy7QeQeKZwFJORrVKtcKwXVv/yU0AgjNEXNlUmmKANrqtp1ZoqTHDXTV1HCMuD71oB9IFMg88tf4VQTGsWxeAvSmwi2KaGrqg1G7ZSTqTx3o1+3JvODp3JTNkZooWDJ8b6FAAxJ6cZAstU9LhBTs+gUuWAwpzxqPU1/x7vEnq0lFxRAYFaZtX8oQlR3oYg1mzTa7zP81kHs/+kmGyyXYSM2Fb9lnf8qnlzUUqnR4jiA+8/fWoqCyiagvBWH07Cz2ghvrAp1+yIWDc6osFqUjaOdtKVphqt+8qjxH0C4DGNTU3uG/ThC4As9Zgtr/SN++xTPLhMcy39YYi/D4WBVUABOM2K6LF9gVtFWBD/yvpDBJplb7Bj3BwBGGpJx2RmoVp8hpgwPDqWtAjRA6R3wX2mg1KG
 fCv2WbRe
 rgWXi1SBK+fLlRUCYTCqDy2DS44/hWu9ow8Jk5913PwLr9xYUHa6TGUvu1ok5nRLUwikngUhFHRquGSV/wUKzUgBgHcmHYi6VCO86yMNjLXe/cGy134gkRgYoMyhWJVfvQd6PODcW56RLgAb2C4Vq3PylxhCdDfPgX+7usjRYNxAHpNXUUyFfAvd7W5821WQBG6zg2FNslEUFJK7rcM2wuhYkS7mrKtYqYJBYtg7AMegozY5CwrP567AO0KM/oIzf+/ntFA+Hno0euDKvX6jWcyHpLoPR106ic7jQZ3+cE0GwOSg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 15:31:42 -0700 "yanjun.zhu" <yanjun.zhu@linux.dev> wrote:

> > +int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
> > +{
> > +	struct kho_vmalloc_chunk *chunk;
> > +	struct vm_struct *vm = find_vm_area(ptr);
> > +	unsigned int order, flags, nr_contig_pages;
> > +	unsigned int idx = 0;
> > +	int err;
> 
> This is a trivial issue. I’m not sure whether RCT (Reverse Christmas 
> Trees) is used in the Linux MM mailing list.

Not as far as I know.  Some like it.

If I was to have a preference I'd suggest that things be laid out in a
logical order rather than by column count.  Group like things together,
avoid use of unintialized storage in initializers(!).


