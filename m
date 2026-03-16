Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10EB2F53D9B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBAF6B03A6; Mon, 16 Mar 2026 17:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BE66B03A8; Mon, 16 Mar 2026 17:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A92F6B03A9; Mon, 16 Mar 2026 17:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 476B76B03A6
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:34:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F33BB1B8365
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:34:50 +0000 (UTC)
X-FDA: 84553231140.26.30F1702
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 689A6180004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:34:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u0p7TT1q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773696889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iuM8P49ooLQhwFHGIboUc001d9wKc/WAa+BKrlTGQa8=;
	b=GUtAjhHBQzT4TRXgIEjd8F0SToW+sBY8dAu8aeWfFK20G3foE/3571rZDxyTfKAdrgc6Q3
	0ZKwTulXKlusDCis6hFEqelXXJvv5IqA446r1BlnKveh8VkKJq6e4C4UjAtTxYO0SaqFzu
	9aFk9OaRcrlxymEyACrrJEenQpPFB5o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773696889; a=rsa-sha256;
	cv=none;
	b=5Q6BeFcMwZB58FDmb9NJMKyv7Z4+fl32NF3kY8n2XgR3cJK7ptJmM3gmJETMkicOjr9xM+
	QPhtbF8VFGUN76Uo63ZsZguCptTYXLZ0w+Iy3knUMNQJRxwON9DMtf3G+KVUcxdCORvGIm
	QtdWa7SdTzoZD9kTxucnX3mDUJgb11w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u0p7TT1q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AC28560097;
	Mon, 16 Mar 2026 21:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99E3C19421;
	Mon, 16 Mar 2026 21:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773696888;
	bh=L40tdksrN1YZ5CgQIu1l+Y9mS/QU8B6BSrvIBIK2t6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u0p7TT1qUbZLWBdRbihT+dDRmijQhxCcwKQ2s+MQGH3d1CLBmTadAETV3GfeExwBB
	 0yZz7LNpCcZT1gLjX5H8P5H6HPlcBVgbGnrP7l0DFqY5NqzBb6s1GMYAZWedY7yYFE
	 WaJUN4WGR9Fc6BQLXQZ+gRG1y2qOPh/qANXDADZoLVHcGjvmCTksznSAaAawEFKn3M
	 Xt9SNOrIp/mBUOktVJ82kR6/M5e9iWt/EsA82JYxGM9BX1v8+kPcpvnHlcFLrO1ukR
	 4i4+Ly7w6H1DxNTo6LbkdvjBLSMM7oWMIsP4nWMpaP+1c1EG5iRDO8eur0UbFodXcX
	 XQF0TBjpzSbhA==
Date: Mon, 16 Mar 2026 14:34:40 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH v2 3/3] build: rust: provide an option to inline C
 helpers into Rust
Message-ID: <20260316213440.GB1329928@ax162>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-3-beb8547a03c9@google.com>
 <aasPsbMEsX6iGUl8@google.com>
 <20260314004012.GD534169@ax162>
 <abVE6VWCzZfyMEsu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abVE6VWCzZfyMEsu@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 689A6180004
X-Stat-Signature: dk5f5wkrmhu1jmygsttmabkuor4f7byn
X-Rspam-User: 
X-HE-Tag: 1773696889-252366
X-HE-Meta: U2FsdGVkX1++NLNLsK2k1YG9/4FfYUiYZpuXE3wWaFxoSVGwviX9plcYxC1DeJBMvvv4b6CdBeqQhCL5GAgpnBAflVRFEZIflcNrAGGBW8PvyE0bPDYX19qTZBlvvYjBGaszF1CDqKsYFwuXLJG6D30wmm8CovJqXGTs3U5p9YUSB3U7hqhc5vtkNNGtfLxRPWH/GP1fSpksSvB4WXuKkEkYGQzBrXucINuCRcRaJ3yyYN0v0Vt6cH/gpmy4uUZeOIiZfZVP/uSvx4TdPZNS9ciyNAmG29FpYRart5OUK9eMCM0xiVolWLgfDUkngm2ldvXe6cSIqRCwzEEDREzGJzvdU5lNDJfRqwSc/eXjA7M2kXlXtg19jCLFtVwa3hkZqXufjjDoVSJC58AeQHB7pAQQ4ZTPstKjPzzD9aaOgneD2DNaAYr+n+CYI4wyBkB0VJZOqQRfhcOZm7qsHaa4yAvW4SyNHDcvar5jWeYpe5dh6ujeq4q0rQKu/Re6ALFi8bPctHW5YAA+0Kd7qx325j5xrmPB0K5e7sW7xOdSmnm5R0jyngAUunmCLPi8365kraozpXXyHqFvdWIyMQfe26xZGj07kl60LDXtoQhi3Roe45U+UTspUlo+dDC2WHvwh+Rh4dQA3egUB2st/sTEpt8sugE3glfu0d3Q+JQ6pXpufIBi934YlhN+l0pARByTgxLQtkBOpntiJKLCehlTBO2qUK0PrOUu+qhdpSTxG8zB/bzQEL/uT3XbpKQGbKc8bPKcByBZQbzuurv+3NVIbsBUC+L69OJmlk5wrmXZ4lxp4q6Mxmh0JrnyESmJ+WQG7u7UafG7Z/uXEq6I74D19pSrEuE40HYzhtUScjwuu0f2Au0Tu68hV/VXJ3Eyki9AbOFbmToQhnmBsCFRQHtN3pzKL7vfag2vcylGCnyGaLep7UrMAACSllZWXquQrpyUZMf/mrvyEmxzQmN9eSb
 UAyW7WAg
 kkRdZXLuColpm3ZTcEMzjnInDUGFiTB37BNFq0l6qT+MpVGTuRyeFFguhKT1It+KjedL8UuoTA9B8tsozovl+4D0x+O0qKZHrTDCPcfvBy7BFSQ1N09npVlWH9viPqJPRYZtb+6UHhVHUZEZ1oWggoUpjuJueb/kBwq1VWJgg1qVJnAl4t+eK7bJ+WxYnkP+qiFFyJZFr7xztOvSCazlJTaLLFsRhkny+Do/scXvibKQ9ERVDLr3CSVYSwBl9RmdVo6qyIePEV8/eRov86JZqP1VOOBkyvYBaKYk8Ek6cUa1b+oU0ToRnn1otb/jWRGG/5KFBIVmiYV30z2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 11:22:17AM +0000, Alice Ryhl wrote:
> On Fri, Mar 13, 2026 at 05:40:12PM -0700, Nathan Chancellor wrote:
> > On Fri, Mar 06, 2026 at 05:32:33PM +0000, Alice Ryhl wrote:
> > > On Tue, Feb 03, 2026 at 11:34:10AM +0000, Alice Ryhl wrote:
> > > >  $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers/helpers.c FORCE
> > > >  	$(call if_changed_dep,bindgen)
> > > >  
> > > > +quiet_cmd_rust_helper = HELPER  $@
> > > > +      cmd_rust_helper = \
> > > > +	$(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)) \
> > > > +		-c -g0 $< $(if $(filter %_module.bc,$@),-DMODULE) -emit-llvm -o $@
> > > > +
> > > > +$(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: $(src)/helpers/helpers.c FORCE
> > > > +	+$(call if_changed_dep,rust_helper)
> > > 
> > > I think this needs:
> > > 
> > > $(obj)/helpers/helpers.bc: private part-of-builtin := y
> > > $(obj)/helpers/helpers_module.bc: private part-of-module := y
> > > 
> > > at least it seems to make a difference for AutoFDO.
> > 
> > Would
> > 
> >   $(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: private is-kernel-object := y
> > 
> > work as well? Presumably, this is because c_flags only has the AutoFDO
> > flags when is-kernel-object is set, which is only true when
> > helpers/helpers.o is a part of obj-y.
> 
> I assume so, but isn't it more correct to set part-of-builtin and
> part-of-module? I don't see any make rules making use of those directly
> (instead of is-kernel-object) right now, but if someone adds such uses,
> then this could become wrong, right?

Hmmm, yeah, I suppose so. Actually, adding those would allow you to drop
the manual inclusion of -DMODULE in cmd_rust_helper because it will be
included via modkern_cflags.

Cheers,
Nathan

