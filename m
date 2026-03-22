Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 970B9D58CA0
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 19:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61D06B0005; Sun, 22 Mar 2026 15:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12AB6B0088; Sun, 22 Mar 2026 15:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C289B6B0089; Sun, 22 Mar 2026 15:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B03D66B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:40:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5583E8C6E0
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:40:11 +0000 (UTC)
X-FDA: 84574715022.25.A9B2577
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A02F012000D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:40:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oLbPcWiI;
	spf=pass (imf29.hostedemail.com: domain of ojeda@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774208409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdPp+W0A0jpYkd/sH8q/7VCeNvsL6+/RsGobTkgjUSs=;
	b=gqregz78k58nTIMBB3flca52n2cLncORBzP0ypAgwjEe2y4WGz8sWwTZgKkOFOjvAdYcvk
	XoQWShBtYC+/b+JglN5yNmSx/De06hS9ig7VQq20GWjaxnCiQy3KYftEo4L7OIrJBYAI5B
	kOT3pZajS//+WDIWSGt8l/tNZjpshe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774208409; a=rsa-sha256;
	cv=none;
	b=Nhg92LjAJEuWWPJ5nLuqCmLt6Hl1iIcRa0uULOovaYAWRq/qREHRzUmY+i2gjps7pWPutV
	YSfvr5hJmI+WK7MdccCFZH/gMmKTrQTdUqyOTwf+aRNKKFZ5EhPWJtnSxImP3H5abh6cXw
	dAuC/X3+Svg3SmV2QXXTj48+6zCkWKw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oLbPcWiI;
	spf=pass (imf29.hostedemail.com: domain of ojeda@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B5F34449F;
	Sun, 22 Mar 2026 19:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773E3C19424;
	Sun, 22 Mar 2026 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774208408;
	bh=LmSsPswxZJyi7uyr8x6P1FPNjN1VACNlrBgkCkSkAP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLbPcWiIbbxn7OdK2L+WCXVhbxqwQdPh2l75KmHFLZfVu+hn4dywhz3ud4tx6qJl7
	 7a/Mi90Abm1OGSp1kBwcpD9waRFSX9kZ1r9O+DIdQ+XYgcDIwgHdW68Nj9GYLyNGmf
	 I4q8LNcPUOQ+lENOSwv36knt9/YDorltIFC5qKtT/R6NhePAJsSRV3B02BJsEc1Cu4
	 S8acANr+Be+hA9NKIhNcJ5CdalqY+U8Ayjuq1iqAQTSOhugvvvb7705mNARXeJ3EvP
	 XmfSiLR6esl4sZQwU6w5jNugUfMg2qWrsNHmzi3Vd9sac20+v/tBNdVllME6U7cCHp
	 E7Z1uW68ZN+qA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Jean Delvare <khali@linux-fr.org>,
	ojeda@kernel.org
Cc: linux-kernel@vger.kernel.org,
	a.hindborg@kernel.org,
	acourbot@nvidia.com,
	akpm@linux-foundation.org,
	aliceryhl@google.com,
	anton.ivanov@cambridgegreys.com,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	dakr@kernel.org,
	david@davidgow.net,
	gary@garyguo.net,
	johannes@sipsolutions.net,
	justinstitt@google.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kbuild@vger.kernel.org,
	linux-mm@kvack.org,
	linux-um@lists.infradead.org,
	linux@armlinux.org.uk,
	llvm@lists.linux.dev,
	lossin@kernel.org,
	mark.rutland@arm.com,
	mmaurer@google.com,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev,
	nsc@kernel.org,
	peterz@infradead.org,
	richard@nod.at,
	rust-for-linux@vger.kernel.org,
	tmgross@umich.edu,
	urezki@gmail.com,
	will@kernel.org
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Date: Sun, 22 Mar 2026 20:38:30 +0100
Message-ID: <20260322193830.89324-1-ojeda@kernel.org>
In-Reply-To: <20260322192159.88138-1-ojeda@kernel.org>
References: <20260322192159.88138-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n3q7sk7r6owqzousjimettsyyhwghi77
X-Rspamd-Queue-Id: A02F012000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1774208409-284920
X-HE-Meta: U2FsdGVkX19rTPFlkquLr4y0SjE+uOn2/knyXOVMw4xbNbqwMUZyypIocYMIXd0ottOSMr9DA1Q6yxPBmC3d8/F9iU8THTsEEAt7YgzfIQ/QvUh/un9niEGE+484PYkLx3EYz2dJrspkOkJ1DhOpvd6T8ZkI5t0MTwrwifai8zyvoBRAL/VoT6ZaF94OMtfsWfaWiHu+X609sEoCGek8fF6iqbxZbqY/ODttVM19bRlE6+qn1lDM9dosWi0f3JCEH+8BNVO096QFGR7YCFsuokhnEoYip+6Awp+1aT/ffr2FN3krV6Hk67tDTEYsREwByKo/cQNl2caFuKGVgc4xYn6rias9+xoKg5lBvumhy5WDi4VZpgbKDCxxsSBFUwfKC/sEA1ktSTfwmMmnc96iJk4rIzDGR+/NpgUQ7Xu7CrPUBpiEClm0OnjsBI+wDRHEqzQ8WrtgqE/hHyloeLKpfYE/DlX7OFuxcxD7np0+/SUnen6WA2zxR1YIRYw60ygQnbNwEZ30J5U8MnuDLY2SYZq4QRCtm+RUP6/IXnWHrpvQHHvQIPBLsyj9Rh2N23LqWhTEGXLupYxFZeZLqziz82N7z3Lfa1xozwhzl22RWZsxfoOxAFCxmElmNuAs8gGzLT44o+FvfM7YYQuR1GX8VoNyaAUDYmuQesfLH/X/8EcNZ464Sl7DsXlwFVPyecJI/1ThgBY5oooMRbDc6lIgLr1uG35xn4dxGBOfeqsuchjsubDDBYKcgNbrB0JLFecXWazahVSGFDAJcqSTKzUmqWO+LSM54iaU7bpiFklDIo6AkK/Ls6whAvAl1g64txUoV3ypqFwifO04QYzGPG3NPHHNgmvVVoYHTPeMmeW+GLBb5lUWkDK1zPSUdzxjcSIjZerGorDMXQdVsyXMSoqfhCw4CHzj3nNwpbEKFmzxfNQZA+ZdQTB7SBcUW0g8M1hatSFP+R4MVEZBShUZU2L
 3gRD3DwF
 dZ/KfZSqGxOvYaaVIjIOvK91m8YOYgfs4uSetpZ+2kRBMnWa6N5f/TJw426aCia0q/++MNTnLmHFORggm1GuTmO+zo+PjoYw26MojKwmwfJGDRcBtZcOaFLQjaPE0qkzxVbsWHC52KRuN+J54ASe6QWS9FbOOsRI3b/8puWxdUiFf2Q41QIoltAJLixu9otnd3PVUr5ELIsPJO8jCTqWB4nPMNYG7F+rYMTKP0ydbCmXok4hu3KfpqtUKSwbKQdIFFwv+1djAQW8v4OoMIJEfDx90uxxUX1M1vZsHRTdY8E2n89M29BJQH/zJEmxXXtGU4AZg+IbKoJfTtGAXDZn4EG6YYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 20:21:59 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
>
> I will reply to a couple other bindings in separate emails to avoid
> spamming people too much.

In a series of tests, in some cases, I noticed an `objtool` warning for
x86_64:

    rust/kernel.o: warning: objtool: _R..._9RegulatorNtB5_8DisabledE3get() is missing an ELF size annotation
    rust/kernel.o: warning: objtool: _R..._9RegulatorNtB5_7EnabledE3get() is missing an ELF size annotation

I noticed that it only happened when `CONFIG_REGULATOR` was disabled. It
seems that we have undefined behavior in `regulator.rs`...

We have `Regulator<Enabled/Disabled>::get()` which calls
`get_internal()` which calls the `regulator_get()` helper, which returns
`NULL` when `CONFIG_REGULATOR` is not set. Then the return value is
passed to `from_err_ptr` which checks `IS_ERR`, which returns false
(unlike `IS_ERR_OR_NULL`), and thus we return an `Ok(NULL)`, which we
then pass to `NonNull::new_unchecked`:

    // SAFETY: We can safely trust `inner` to be a pointer to a valid
    // regulator if `ERR_PTR` was not returned.
    let inner = unsafe { NonNull::new_unchecked(inner) };

So we should fix that -- it is there since its introduction in commit
9b614ceada7c ("rust: regulator: add a bare minimum regulator
abstraction"). How to fix that depends on whether the Rust abstraction
supposed to work transparently like the C API, I assume.

Now, two improvements I think we should independently do too:

  - The docs on `regulator_get()` don't say it may return `NULL`. It
    originally that case, but commit be1a50d4eba4 ("regulator: Let
    drivers know when they use the stub API") changed that without
    changing the docs.

    I mean, the "docs" are on the real function, but still, one may look
    into those and not realize the stub does something different.

    The implementation comment on the stub is also a bit contradictory.
    The original sentence (which still is there) says that nothing
    should look at the value, but then it goes onto say that drivers may
    actually look at the value.

  - On the Rust general infrastructure side, we should document more
    prominently that `from_err_ptr` may return `Ok(NULL)` just fine,
    since it calls `IS_ERR`. It may be obvious, since `NULL` is not an
    error value, but still, it could have perhaps prevented this issue.

    We should also include an example to the doctest showing and testing
    that particular case to drive the point home.

    I can add that as a "good first issue".

Cc'ing Liam, Mark, Daniel, Jean.

I hope that helps.

Cheers,
Miguel

