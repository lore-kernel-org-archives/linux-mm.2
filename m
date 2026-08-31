Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05FCAC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729636B0095; Mon, 31 Aug 2026 06:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D97F6B0096; Mon, 31 Aug 2026 06:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1356B0098; Mon, 31 Aug 2026 06:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8096B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:43:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89EBF160447
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:43:22 +0000 (UTC)
X-FDA: 85161227844.22.8EE5404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F33D1C0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:43:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OxDv0P+y;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788173001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIt3VgCTlKr0UD2zCebrs70lbSFzbpSN9wJEPrwNXAg=;
	b=aZZIc8H8qDdssiurcrkA6tCRxwAhlBpLjar27PyP0hIQgBq0f7gRTCL5l7IUXZsYNRKWsx
	1WsEpqeHJY1C/Lq3IZh2ZcM1DGJp6FoNpmQ7+Ofijxc2uoZHm2Z9L5OnLeLnJnEzKZG/jL
	w+Y96KGz20E+qq9L3EzzyrD1coWPHMI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788173001;
	b=4GwA6k2NpMaKwdkkaoM4Wfj7jTnki/SpKC/KFIWJApyJ9NyhtxPBmIyA5LEZb7kPeNu0se
	BYYWtLmE/0m/AucehgmCJiilvrFOvJayYSsurWkXqpkv0wGpanqq6632HIbKLS8koAnvfm
	4BzWEtEkMZsjwGR1kmpRrHn9Hg5IT2I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OxDv0P+y;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD3BB60219;
	Mon, 31 Aug 2026 10:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1101F000E9;
	Mon, 31 Aug 2026 10:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788173000;
	bh=MIt3VgCTlKr0UD2zCebrs70lbSFzbpSN9wJEPrwNXAg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=OxDv0P+yxaBAXiwD0OBwDSNFCk78n2D5JDu3hoGe5vXjRm0auREjUOoheJKZjVxlH
	 bm7iCMJgN4Ut4WQ00S+ZqAmvjJQufY+5oyRp+Dj8sNVyhxGpq6Dvte+MLKMeUWEE7m
	 KHrlGQZh3uEEMFnQrIn/ZoYp4REMeRnXLVsC6JmlVnb60bstoyVMA9sEvikEXoO3rP
	 PQR7iy3xBGIMsgy7HuvyDtW+pNH/0m2rurgylRPpzhEstCyULSQedmDRQQatLEopq3
	 SRIEei6zEwm07sL9tS6yHypptiM/mZPR80zLABNPkupvc5upoHKU7Ohm8bK0rOEEQh
	 uPiMO4phUbElg==
Content-Type: multipart/mixed; boundary="===============3851992486102112929=="
MIME-Version: 1.0
Message-Id: <5a28fcf46a2cf6d16bbfc7b814c323b846c8774111393ad02c1b30cac2e66493@mail.kernel.org>
In-Reply-To: <20260831092305.42062-5-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-5-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v3 4/7] bpf: Allow reads through trusted-or-null BTF pointers
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,utilityemal77@gmail.com,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 31 Aug 2026 10:43:19 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F33D1C0003
X-Stat-Signature: wnp9gyeiy95cy3a46sxczgpjpxn9mrro
X-HE-Tag: 1788173000-467292
X-HE-Meta: U2FsdGVkX1+moNzkrHc9ytvxwQdtQkysYOhuqsdA4JxbR7iyjgxX2wbboIPbXj44FO40dinM9n59no1hf3k4XbDVFJtv3Ibkrbtoblr0SptR3gVG0mK8s3YjoCic+Md1oOazTbG0CiJtTGZD/hQ/RisaJPKq15hxWZoPr85zTv33NzVwo88j3Xl4+hSiuYWXvO6mgX6Mic5JAJBZaeGnRLbc06Gwew1pBA0T6lHRHJEO9H10xpG2w7H9Xq5ZSsvQYqDZRImdIXCRxiSO1BVYSS+kZJxpvwNq1dPcvWdpXDlgbVph+KZ8/GTrCjmrTUnfpW7SP5bCVlYonxsn7izkr/hOnFTHIr1Q1cgG9BbxodG9Ivf0n792+YcSfuG9rgUOhG2NgQh7lFdzsGesUDB+IWvmiGthfaDsScnHnVQsslWEbHhTMFhFmyXwdK1L+V0dsM5vR+a+qE/mtjGfQ1WmGOL90xN+8/d+u6Z9JL7pqtK4caHN2TOwhFyRn6pYIPQ8WYnkDmcuWDxzCrIXWmrVyQkoPOjiDvAZQGId+geWQBpYf/nGHeR5oeOm4y3fJ4045MZ5+/VgGMMa0sA6E5purhsNqPOVOZd8FhqgbRejIYJ+yNwB46BC/jR+WpEGutXyrDOEckKRwqrLwB9ZfuMv+4eo3kGwPnKkzKukt1z43bBBkoxzG9HWSH0+DLdOF3A6NAkXI4QQ2i7Gu5BcKyCaC9a+tKaD0DB6qPbtKt/fl+iuzIFWX6xbXSzfycQggxIy7fEA63Dt+tb3Fo20nN/3u4iGoD5+2gF9jCbpP5dFxGsXqWQ0N47JjVtsRPf9aNa8dREO1mFZdKICS7NCFaDhybdqecfU9je8snzmCGppEH1pN5OY3vn/Bxtj5JIPUeSjJGoCv/iT6g2Ll2rpfOQqCjp9ejGKTAR0uBFCKS4+vmRvEWNxpvrUqfgAYuUYIJqrcLyaPBkeKxXjblpAiZ8
 xwDwZJYg
 xUH6xHJJImhkFfUDqzp1FEdxXJKw9fwV7+aJKCLH9kjmUq0+kN59138otQIyf4/vKOlqFGVazdJSyNkpfpg9DIoZ2r9c1ouj+CZ88tMJHgX51bgT4ANT4gaQkxktefbqi4eC74fFY4zn+2caAVG/j5LK9JNPRZVAhLeKk31eECwDIfp0PZ/Usi2M3xEsblQ9yJujL5IBRJlrdydy5dg1quCyi/Qdl6COOPqsd8mrRpncS9Bk4QesSymSAPqFT+EbfSIKYGfs7qYgx4oVjXi3wgvthLMVYBgKgaTSycv6jMWPNRVKTvW6UwNyAnj0pThU6Cidpe8uJpnnI6TQHuqtsQLLKlzxqNgnNOihQ/aF1RuFt9NS0ZqGFDPiwpu2IpPmAjDmZjnl/XYvHNNWQYAQ2femwHsGk+cgnRViL8bSg4jRw7pYnl2ByaOp2Ez1NNGfQb3VW3r2JJFUBXo9Xz7cIJfdPafYoVDT+dhul3EkDs0ERLkthMwrjoom3E3pdsWMk0AvxnV/mPTczN3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3851992486102112929==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Allow reads through trusted-or-null BTF pointers
>
> Currently, a trusted-or-null pointer
> (i.e. PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL) has to be checked
> for NULL before it can be dereferenced. Marking a field from
> PTR_TO_BTF_ID typing to trusted-or-null can reject programs that
> previously dereferenced the pointer directly. This is useful as we
> need to mark new fields as trusted in order to pass those as arguments
> to kfuncs.
>
> This patch adds support to dereference pointers marked as
> PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL without the need for a NULL
> check. We define that those pointers can fault on dereference, so
> reads need to happen through BPF_PROBE_MEM. If the dereferenced pointer
> is another BTF pointer, we clear trusted flags and mark the result as
> PTR_UNTRUSTED.
>
> This applies only to reads. Other cases still require an explicit NULL
> check. After such a check, the pointer retains PTR_TRUSTED and can be
> used normally.
>
> To summarise, before that patch, reads to PTR_TO_BTF_ID|PTR_UNTRUSTED
> are allowed through BPF_PROBE_MEM and reads to
> PTR_TO_BTF_ID|PTR_TRUSTED are normal loads. This patch allows
> PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL to happen through
> BPF_PROBE_MEM.
>
> The unchecked read path has two consequences:
>
> 1. It uses BPF_PROBE_MEM, which is slower than a normal load. An
>    explicit NULL check refines the pointer to PTR_TRUSTED and allows a
>    normal load.
>
> 2. A faulting read returns zero, which is indistinguishable from a
>    legitimately zero-valued field. Programs that need to distinguish
>    those cases must check the pointer before reading the field.
>
> The next patch updates current tests and also introduces more checks to
> ensure this change does not break anything.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>

This isn't a bug, but could the changelog use the imperative mood here
("Allow reads through PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL without a
NULL check") and drop the "To summarise" paragraph, since the preceding
paragraph already states the before/after behaviour?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33379004067
--===============3851992486102112929==--

