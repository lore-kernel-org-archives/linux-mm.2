Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87222C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 21:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234796B007B; Mon, 27 Jul 2026 17:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E55F6B0088; Mon, 27 Jul 2026 17:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBC76B008A; Mon, 27 Jul 2026 17:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D579C6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:50:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43B29C012C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:50:03 +0000 (UTC)
X-FDA: 85035899886.15.9F3E939
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7936C1C000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:50:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVWTMr2c;
	spf=pass (imf18.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785189001;
	b=5Tv0tW+UM6IX4J3BNDhiLq+gw+T8aOD0eY6a4EsweaZ0/DZOQ7qZdKAVgJMGSaK9F1qz74
	ucbi1kGjFNEA/kHIfdweQhIt5F6xvGcafYCFbiQhMbrBm3youKLe1DhuMGBdUA0mt95UBm
	rkkyJk6K4qmbDdzROl0z1p9LiQJW9EY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVWTMr2c;
	spf=pass (imf18.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785189001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMfeYsP5GdnuDCfgJKEm3wwcc5Ecr2dv1YHRl9juiCI=;
	b=Wj8o+Y+f5lWivuuipmPyOKwIGBTkPr5qh55FZVPoHwW1NEOL12SO5BqWa9JPFRoZix3cLa
	+C91rOofIQgdS8EnfDgMAtrZnFve9Qq/KQyM3+nyvDpOGgiIeOS/zaroiKISMYr81SMTKD
	Ak4gjTQx2veM3w7KNUdpS+1apLyV77E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FE5B4150A;
	Mon, 27 Jul 2026 21:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7541F000E9;
	Mon, 27 Jul 2026 21:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785189000;
	bh=rMfeYsP5GdnuDCfgJKEm3wwcc5Ecr2dv1YHRl9juiCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YVWTMr2cX4ewrBWHXUcAbrlt/cYMv2t1rAY6OmzwAk0jxEusNqzHhIvI+IFi8gusK
	 jeVo2x71CzuTqqbU9a+WJJEvzb73ShnQO3gqhTrXt7a2TPzCUTVkNh3hhVBylazW4/
	 4CeRyCI/IFRdnNyAJZiu6XWl0fPPuPV/CAOpVXlO5mgkBjqTvlCxPdL58ayHHdjWJ5
	 RjdQn+7QE6cmJ2wIBqxj7yx5OPwo/Ife3L3H08yQxcj+ptQNRXXCFsaXSPJmOUv/8M
	 z+lqEfGJ6x5P9pMufpzSSTCyZsvQVy0wiah9b9n0VGDo1ovNXxn8YJv2O47SoUwgEy
	 X3/tWKU4SI1CQ==
Date: Mon, 27 Jul 2026 22:49:52 +0100
From: Will Deacon <will@kernel.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Hongyan Xia <hongyan.xia@transsion.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
	Naveen N Rao <naveen@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jiazi Li <jiazi.li@transsion.com>, Pu Hu <hupu@transsion.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>
Subject: Re: [RFC PATCH 9/9] arm64/debug: Mark debug exception helpers
 __always_inline
Message-ID: <amfSgECpzET7JHTr@willie-the-truck>
References: <cover.1785153469.git.hongyan.xia@transsion.com>
 <eb38b41ae1b3216ec69fb45555ef5df57efd7b8d.1785153469.git.hongyan.xia@transsion.com>
 <CAKwvOd=HeG=z1j2qB-SX3NQ=62ERr=KpQNZyqqp2Qy4kZ54RLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOd=HeG=z1j2qB-SX3NQ=62ERr=KpQNZyqqp2Qy4kZ54RLw@mail.gmail.com>
X-Stat-Signature: iidp6y6afsadpow3q691mmjbptzqyxtc
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7936C1C000C
X-Rspam-User: 
X-HE-Tag: 1785189001-544788
X-HE-Meta: U2FsdGVkX1+UoVdqUmY4Ca2T/OnN8tdGk8lbB7DOKguVsD+osK/NGZajQ6boqb1RSmLU6FzDR/NaxsQ8iglrfisZGfmseMiCkDZheMrQXst7tZGFJJOKGDy+EUB31dBPNjMsVN3EU9l1US6yQ5aXoc41KJaO8UbPcC8rD6IMQ+/GFf5rombaXbQxVsLhpZQDimgcmR4LgJXUP4YlCg0e+hCWf+VVjkDnyRiV02iBWSqaPtihkRybKQQYSbT2mct9u+mtgmEPt2I2Av9JM4mT1Pad1QicFi+vRLBGYpWocQLrK+LjveY2OPHg9rKyjgUOtUsWxRBP+iShmWT84qh40lGGoUG6f5O2NpM998PQSWwiRv3fsuHuzkIullTaW6YCdFUUlfv89zdPgpZ3ZcSneIWFy9vWr2Rw8KIaOE4C6KHD6VfjXMGzi6pBlYQVHAd3DXGZkxd1952Cj9iUt9Qs2EuTxQtXY7yP6e2P2p1PNrBj7VEot7O6LGuoty9Hzs38VmOlGdPGBAnjU+txnfHWkuUbsiRHPUnFhmoW3Vrx48zhVP7/1GY4r8dEgQdHJDN3BmrR/J7ACHPEXkV3Ba922glq5pNUjhzS+uUli0jm3Zjp5CPbrq7Ki9GrCr0ekyArIOstxCIAzqFCr2YnYJ3m9VH8K46UZu1H7x7cEb4Tg3vYPwa8xlmal1Dr/F+PuZ3htKlV2trbFuVs+Tt9Oa5qllokRFaVy0Lngss/oYcViX8b6HlIwLwqRxoBy1OgnHM2IAxQ7akM/tmM7rvHiSJ7bhwmhObo8CXJgeVj+Mlp2wi1VIEg0uEX2wyxK5vnoZ9YbKzKBVuup64PqgBjpuriZtTHJwQ/1RVKxXHEj1O6fcKy/oqiUrLfhFn1QcWQOD0VtjDCiCTwAqkaZgTUY+yoq2uAeujs/1V8zVcoe/sjf22Z5ZBrOA7WxpfmMpwiOkaXjqUzGz3HolE2YF0OoR7
 FhYrvqQv
 nCuVtsbU9eqNQnNdEAbqNFXbcUSOuy9m7+qXgx/52fGdQInNmaKJ6IIkMzTDiSn4lCUXBcdRRuEjue98sqXqcPJ7bbAymWNiqD+NthjWUF7pqA4uEGzxW2/lOo3TdxHeSYA8iv6Y5z2I2wIi5dl5IZ+mBtVxxwYsp5xLMH5J/8BpEk7u39y1HmX6v5ya/OHHqlDwQGEh12BfEeVwkcdzcB686Ex6OaCDrGYMimM1fDHYLO8I684ngEi3xhtsjiZxwpJRJRaoPXspMJwla3MVO43GReqgnBObxW6816CPxPVfLM4eKNhXv7sUxhKYO3DwANurWLJyNQ33qS751oGSI3kkEejEYhztNnW6xuSTHrj6ctd97+ERFZ5RtFvq5EWaq5dTFqOZtaqVEs3SzyIG/8fZvQ6kSzvhzmgGLjvZ3rK6K9Co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 12:22:32PM -0700, Nick Desaulniers wrote:
> On Mon, Jul 27, 2026 at 5:25 AM Hongyan Xia <hongyan.xia@transsion.com> wrote:
> >  arch/arm64/include/asm/esr.h       | 2 +-
> >  arch/arm64/include/asm/percpu.h    | 2 +-
> >  arch/arm64/include/asm/preempt.h   | 4 ++--
> >  arch/arm64/include/asm/ptrace.h    | 4 ++--
> >  arch/arm64/kernel/debug-monitors.c | 2 +-
> >  include/linux/kprobes.h            | 8 ++++----
> 
> It might not be appropriate for the changes to kprobes.h to go through
> the arm64 tree, but maybe it is?

They look pretty trivial, so we can take 'em with Masami's Ack once the
rest of the series has been reviewed.

Will

