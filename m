Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 745AEEFB816
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38306B0088; Tue, 24 Feb 2026 03:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5F06B0089; Tue, 24 Feb 2026 03:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6F16B008A; Tue, 24 Feb 2026 03:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 994E06B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:48:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D345C17E5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:48:12 +0000 (UTC)
X-FDA: 84478723224.04.C6EA9AD
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id A43D620007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:48:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=jtAfpbVT;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771922890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPwMTZWQmzw+6Xa3CNcGXsn5offzw2jIHRKSeIEW9o8=;
	b=y725KmQT3ho0Kz5djbqKhKEBIqUeqv9WNLBH8PmgDLJtzEYK7sG/5eHd7ZWn1fYBKashOm
	9HGaxyBzrsJkWw/CifoHUEIG2xaP3CSY/CgF7iXIVaIffSRNuMeuNaf8+O2Pvx9KIJgvRV
	uO1DBollg25D1NRUoe7QZ2DDQa4PEEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771922890; a=rsa-sha256;
	cv=none;
	b=bJ2A/YTCZSyDNEXsSefzZqeYWVzHmpsmJSxKnLP3GPX87EOUPPoDMsI11ndEJO/Gr0NEhH
	awDaroTQkEVVld5X4JOYxHTLtgS0+IbrSxvS+JtcwhFpdULbj6tOx1DadzuXEs4G9pCTES
	nDRj347vIZPGYxHtBeth8cF2JZV/dc8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=jtAfpbVT;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OPwMTZWQmzw+6Xa3CNcGXsn5offzw2jIHRKSeIEW9o8=; b=jtAfpbVToV5pGfAUIriftlmEtd
	grhIHAD2SR3tLyqTldmXkDaSTrIl4xvbwgOceVOAFcqLDFtpLzDbV0tkUhmy2SL6zZDc+dX3fkfTO
	nlSz5M6CUcfD1q6LTSX6P76TUpfzB1fR/Cc0eX/Jbl8CS9/KACpkB/hVfTxB0fJRs8UNQqIGbSmuv
	wZUtZ4V3PgZJ/Yzjyt0c67S9ovhN1ovWwe8cLzxk/lygrx2usidPXqsTma9wMSABdUbL9Ri1xIMd+
	59ehPIuFVTtRwyvuZJArnuKZjDSZ5ZLKh2o6K4PS0RxAY9EKhtRVJGxObSv+aNjgWy9J6qmK1jg65
	cz7+U6PQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuo5N-00000006hUZ-3Wje;
	Tue, 24 Feb 2026 08:48:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 48CEF30095A; Tue, 24 Feb 2026 09:48:04 +0100 (CET)
Date: Tue, 24 Feb 2026 09:48:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC V1 04/16] perf/events: Replace READ_ONCE() with standard
 pgtable accessors
Message-ID: <20260224084804.GU1282955@noisy.programming.kicks-ass.net>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-5-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224051153.3150613-5-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Stat-Signature: kuyfm7jwntgm6frz68embbsmsihyjcqi
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A43D620007
X-HE-Tag: 1771922889-898187
X-HE-Meta: U2FsdGVkX1/um+sgnafIKY42CD6RR0vX+9JrA/JsmQ8w/YZ5upryGwtYyVK4c282bu7Pelg2JhPffDTpNQjJJZ6r4uynX3E9SlbH7xILHWsUNSk9wCn8B/2IEw+GpXOJzqi/a04DyQ9qy0Uo5Plan4f7f/hbTjGNAOn+XUenTFrHJRVVYWIDpWxHqrQAeVIFxoN5vbjhzyK4cEQY9vjKolMIBFL5OrdfXKZr7ZN2zgbgAjlKXYza2PGGxAnQRNNizWCqnq+//BQkQeYXyhiHVWoZbD/nntFVU5mUF6VZM6BzegSynm5j0P4sNRfErdmTsISBLTjBeoR3n/vK4VlFuUY5FQ3Rvq19J2WIndX8dwlgELxRPOyOxwGgQsaWNq6ArY70t3OXuG8yQLyQxCFYctsr3kG8PlybQ09SvTNLi71l0bwDCfL7PaioJwStbk46ezX0KAMpzG6gy5T4V3LNy3r+CoHhaf8G31sUhoKUGbArjdtLmx26AHsn2mAOu2x2iXaskQeLD4dLQQ1D+E+VaYEqS2rESDLqUYITIfimwkEvPb/X6p5DIJHZLxzop8wSY7YQ/8F2LDKe4nnaDNTz/2zex0hO5wy5MDgD7bBd8JRZo0whTIDsQgsprfMccbUzRLE7sDYEzWuRMxicGNJvYTkM++ikZJHa1SEwTp73msQWG4B8UQe5wresMbF/N+WldnlpEvDux5WFl/YHqtl4D/9PuVd8U+uT1EgElrj2FEUhu/+iojIV9aLOaKjvCCFmP+wi63SdWXlRhRGeYXUJ1nR76FmJZjjrf3AjiA7ooTbtok9Eh5k9i3oiqC1WQiCma8glwjP02KtSHfU6n5vIS9iS+nejvud6lYjMLHEp2USUhA3mScNOUiIKyb/54D5S+Lt6ezMs89vZSIe5LDsBv87mYzj3XEDNJXka3HNsZCl/1XEc87p6uX0p96P0uyTAT+lyTFttF5qqCnA/dVL
 oJu3o+RD
 GkcCkXi4Y7kbyhN4Lk60Yq92gN2PnNpgQ9HPL65af0gBPiF80Og3hvnOn3Gb+sR6Ix4FwkcHTJ0dv4DO+a17FbRzjBBOU8jnU6KTiGCGGrm6UWKaI/yG0es0G2oehZDHVZQ9UuAorDbkMZLLJDxTe/YKLg5csDVQQ01lwqnzgK4IxbS6VK+j7W4Skr9vNjvC9d9G0I3HnDEFxfPH0Rh0pswEsoz+GnFMQjkRs2VDNmQVVJULhP1Lob2NVu03WqQamahAXEzFJZS2o634=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:41:41AM +0530, Anshuman Khandual wrote:
> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
> anyways default into READ_ONCE() in cases where platform do not override.

This is a bit silly, no? All of them should always be READ_ONCE(), with
the exception of pte_get() on PAE like scenarios.

