Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03A7D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5354A6B03EC; Tue, 20 Jan 2026 08:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF536B03EE; Tue, 20 Jan 2026 08:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1936B03EF; Tue, 20 Jan 2026 08:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0F36B03EC
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:06:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9183F1601EC
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:06:37 +0000 (UTC)
X-FDA: 84352366434.10.5FCEEBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 07E1B4000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:06:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z+19VGW6;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768914396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HTjNG1Xvuo8jqOgb9lzEtQALllJNhz/Zohl7pFn+bU=;
	b=TTsExG1CnhiHMghZa/lC8E/jwJ4IUS1DTI5Fk8r+8lDdbimj1j09LCGSM0q+fYmDW95ekm
	JQ4w3wEeDhVagbU/UrZGyuexZDKg7oayBNjdZe0BjybYFJDseAhf9LnottlbE3wIXyq4yA
	JqNq8oyW4Ue/RlhQ69VSraD2rvxDIq0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z+19VGW6;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768914396; a=rsa-sha256;
	cv=none;
	b=CcCfVyhhUjvxoTAIs3G6SGXJ1x1hxItJ6xzx35WzADiKo4u2ZBU8f55YVx0R5nDy8eKiqN
	F9WHd15RRZVhBakdKe/pnlq8VyEvVnXvL0NEQCQMDAYDydf5MztHQVd7j5vp3H0U/o5q78
	TAzyTBxySn4h1oc+UcbRGsa/DIj2OO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 74FCF60018;
	Tue, 20 Jan 2026 13:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23520C16AAE;
	Tue, 20 Jan 2026 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768914395;
	bh=rERhQa1jZykoq4PB899x/lK9oiqVu+OrztuGSTog//s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z+19VGW689YQmfWzj3ws0xOaW1zvWCBaLeDwyOtrCW/QsH7JreF9icWorSeBkmMLm
	 wHoxMCxl8Dg3oIpmElK2vJr74pnxB2DA/ebUS0FIepbIVXKfAZTy0IyCznsd6sY7a9
	 4SO5+2Je1YUSglE89KLJdEGJUdp+SuFt5KDobPMjIxamW3ol4YyJCmzghmcmUWc0tp
	 HEW+Joe4fGhn0gfxKC6TkO/vdylolOqcDsta2xp8IZ3UqJlcA/4Q5B3573slxqg0Cv
	 TmXA0ah/tHDPUAfB090eZhZfGcZJ6fFNAw7BoxQNFsmVtENhB0quEZPwr8ghmHKVQV
	 Pm/SLNhnO0E3A==
Date: Tue, 20 Jan 2026 15:06:28 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2 1/2] kho: use unsigned long for nr_pages
Message-ID: <aW991CRBJ3QlNG2i@kernel.org>
References: <20260116112217.915803-1-pratyush@kernel.org>
 <20260116112217.915803-2-pratyush@kernel.org>
 <20260116142635.b90464ed9772c146a9842370@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116142635.b90464ed9772c146a9842370@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: mnkkycu1kze81ofi6p1snnzuinjqh5no
X-Rspamd-Queue-Id: 07E1B4000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1768914395-8365
X-HE-Meta: U2FsdGVkX18AtaVTROtTLkJRM+u0igf+d1LnojW5NWOpYT5hTZFkctP0DgQy2STaT+QI+3+rw/qScB9MtoDT4cmqchwN/apQxc4bB3EWR6B7Y26E7RUtVvivxNXOEhwhebmt6dn747XEhmay9dq4hBG5pd+ArZschdxQGQVpB6/82w3bdZ8mvxO9/THNy6tQNSbK51+YCrcRU52LzvcMvCz2TY15Jpu9IH3ebugRlgOEuX2i0l5y5AlWs+/vEbW3E1uC5LC54GcpTX2oIFiY4g9aagZ4kPwt/71eZ+1KEqEG8TtlAFubKUrGVndg0DsIB0L2r94SR48xo7a5382uxCo5cymM7619k2f3HxeAhq4UsQ7C+rTKG+m2jm/6Y50Bs9XrM3sL2BrnSJDMvuCnuOOcSCIzfSD7YFT7JEeiK6GY370DqkZM6KhJVq2Cbrrt/zf/RbhCkBfXsCEP2ET3Lry9mJivAxRekc5UpFCLXkfz0tM+/1uq00kpfrLci7Q6DPrsEEYIvgCtokRV8gCu1Hj4v1SrF6e37+pjZ9snRiqgjw2Z9Vf3yyR6K/Cuc5iJbtf/hLo/abreY4WdQ7azVMUpoM7j1FByohb/QSQlQRQxLjVX48uy4HfPq/5x7bFqS1Cikw0fZtit1qZq3E5+NeFC9qrdmtSRigGmS5yZwypzYaOkTbnhXvY1oI7j3NsANpe5kzhBe1RRn+NLoBz2YIyfZ8DRkhW+yCg1S7MjUEaVtR+0i5ILW4M2d6qGTiiMhwg+GDjkYFQliK7bCz7bu/l2R2CixoPiwcMhmkX+x6vQnRtdtyKF5HwJ6+J1cu5wDJDOOMICeohLE7RwliGLM2Pi131bsbgdTxfQ3XetxcQXVgDq1/l0ndBMuuGFjAQnDNVlbNPAT7mYcVpGxw/qKIN9/dZWtMfvx4dDgOWQ4IqGp6w1giliFviVUUq4c4YsY645SUCWCQZ0+G+OQvi
 FMKxFuRP
 MzhHg2PDrc9FOvPIixfhyiQfaOQ9mM1RzICMeFFequSw+Sppb6bZ2ah95zKuRn5UFbIG3ntyeTwg+h3pKL+andJbSeZsO6fs3hL8dbEALJwiZWcVpL7ik0Y8bBBGFd0sw4c3oxN6GzynrsFgnIexBMu3lIquFIz/rM+nSLUVUKfzgQwPJ2WWx9SFkBsfON/yazyxFMMLGyw6+AcN+ksR12jEffzk6/5uwazxiDP32EUdLI2pdXK5bM+VUWZx558IKcr9dY8zrDcg05HnZgz/wXx7hByRUM3CNx15hBUecWFdiPg21fajrwuzyOl2DU827aJK+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 02:26:35PM -0800, Andrew Morton wrote:
> On Fri, 16 Jan 2026 11:22:14 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:
> 
> > With 4k pages, a 32-bit nr_pages can span up to 16 TiB. While it is a
> > lot, there exist systems with terabytes of RAM. gup is also moving to
> > using long for nr_pages. Use unsigned long and make KHO future-proof.
> 
> We can expect people to be using LTS kernel five years from now,
> perhaps much longer.  Machines will be bigger then!
> 
> IOW, shouldn't we backport this?

The latest LTS is 6.12 that still does not have KHO, I don't think it makes
sense to backport this to 6.18.

-- 
Sincerely yours,
Mike.

