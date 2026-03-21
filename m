Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A91109448A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458246B00E4; Sat, 21 Mar 2026 13:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408D16B00E5; Sat, 21 Mar 2026 13:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EB26B00E6; Sat, 21 Mar 2026 13:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 216836B00E4
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:32:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B33781B7E8F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:32:45 +0000 (UTC)
X-FDA: 84570765090.04.981441B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10246180004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:32:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOdvYMJq;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774114364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnA3wo2yKejQfhQKP1BfxnSPFb5QMPOOJi4wV5pGe5c=;
	b=NnFQm0OTEGeGPxR3oGwtwcOhW/BcNf2tqKsA5Qfk8eTKuVdwKleWj8ZOly1nPpXJ4jzrej
	loYz3VXTT2zhg/mD6MrKoNQPwBNU/702bLCoBQBmiayFp6wUvIZoSZ15xdxUaA2c4A6d2Z
	kLclCsVG8EEjmQW921sgmOUWhl7yVMg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774114364; a=rsa-sha256;
	cv=none;
	b=SA/1uHkKqdZmmwwdfZW2I1TnMJrhU7pqX9kwI9ioyga5qjN8hmabypuayDaO9ua/Vpp0qa
	LnU9wEruZw/7J68QME2Qob0rJUSCtMfbu6A2kPQZAD8H98m9wcfqi7ru45/J4+dBqhh8lZ
	52b89ord3h5MCoCbjwcAkZLFEJq228U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOdvYMJq;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBB5B4166D;
	Sat, 21 Mar 2026 17:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8882FC19421;
	Sat, 21 Mar 2026 17:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774114362;
	bh=RNtipWs1kS4cmDdgnR52UVmE1qLq9rRjhULJrIQzKkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOdvYMJqLrVMWECCrNBOqMvSded8Kcxo8XcdOsoY1/IxTgooO88jBn9XSq7JK+vLk
	 3Yi41+VOgV55+fC5Drn1Inq08CmdTu/MI+Wr1P8I4qNkezrk7/HmoQVzZFKODOdzHw
	 UKO+0Uk7g54QTWwr8JI9AmeboN8MLYbY+E772XERQd65RUf2ujyNMK4VB/Bc9UpreW
	 2XG4RXsYjfHQaB/83kmXFGFITKJQ1ajpHcWlBynxdOOi4hRXDbXr4P75vGcDs/Ldnk
	 NTImUGgFLftCl+hRMvMFNje4G3bg1Cj+++uL4GBr78Q1Cu9K5pmb+WllD0SOGyyH5r
	 4JDBpW2lbjLxA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v2] mm/damon: add synchronous validation for commit_inputs
Date: Sat, 21 Mar 2026 10:32:34 -0700
Message-ID: <20260321173235.84923-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321140926.22163-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 10246180004
X-Stat-Signature: 5kxcxyp588npjqbnaog895y9o8hp5kiq
X-HE-Tag: 1774114363-589726
X-HE-Meta: U2FsdGVkX1+tLlH/quqe/Ts6P8OcgZQikjhNu5zpSmDYks24rQNesgh878ibdA1CAFeTwYNs+CO8+xnPqB4gmugW30Le0iDiLX4mz1sPByxNWnZ/dzynnp2C+xaYTxj8o1RZy6JG3ENP+8cCF8K8is68R+4499qr+UKLmJJAb93Lm7FntvefcRTHDYE6To++yzwDAwUCycAq2UDxhmDaOtw6WYfoI6XPvJtr47XExplUu4hM38osqsbyetBwdtVQ0rSgxWJVkHorTi+z5/+PkIl4qda5NqRZ3RzoVSaJtRaJgiu7CV9J1haHG6MlJiY41IWxwypgn3MfmtqOgOZSD3NM3ccqlkweODnwcwGGQuuqIXuIMH9gS7oa9MPOe+NwfZniNQZicD7K+0VRfOiOQCJDjXMP9EQLCf9OCoAUoMw8P7Sw1NWYsZmzFokML7wcr/ErJvtI8gWNijpYeM+P5DhY5F0LKI5tBDhZ6dZWp5JhCpE1DGEZSSuWZw7F3BnCswG0AoobN+3q1Y9MUruT0XGKgE7VRBiJxZPGn3Yn7nSlzldwmUiVn4D/yzAMBNOTRoxewxwthZr8R85xrqkS2LntEs0iJvR8qKNkQkyKQzKS/JhYL0XF3sIw8WzHC0U26y2+xAnglbQEqxvclewsSM/WzkAwUv+tyJthxh23K2qDGBGSzFI/SL14SMMXvnoVs+T93Y9vMcGFmRktKVv974o5HqUenrl8F67zDsLxLdngz0athzxPVh4NgXfpCXupk+9PlZEFfekGH5eQ86HQMGVTOu4fZuHndG8cGY4IHEP54y3cOb9WCxFyH+4xhs4iCRVpZMAHLNLVGMRO7T3auBan+D0WUmsVVtq4jJ4kqqVdPQTSILgfoMRjjI0VYejy2rLDyObc/dlNX6H5/yc9ZRmDi1wVjkJ2mt4OLNYgnDb7H5SaS0UjLEfP7YtiYgFNK/WqbAFvx9pIpRDrM3+
 1WD12egZ
 KPPGuVHdBZLRxrs3kKPtCsmvMKtqJ5I7CjC+hd4HxZ/O9SJX+u10QzW10Qp7BCsCkAwO25CORP8e6P5bCygE3vp4IbNfCsATGTrLTRqDDf3BlDdwDUDqqWj95/VHER2tuUCD5R+nI2C4JTH7sH/fqfMBVaFYrQPrpZQwHKgTK8BBnKs+Djfp9LOKhBh4ODBNVn355+llvwnZSYB4q6nm0tdKy5Fc5N/G9wJy+X34RgbhyVe6lriXvw9eVf0KAmokVPp52YeeoQzLUHQ0kbU17PwVSMUXmiDaFnBiLnnE3CbPZ+Yk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,

On Sat, 21 Mar 2026 22:09:26 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
> silently (no error returned to shell), because the validation happens
> aynchronously in the kdamond.
> 
> Solution
> ========
> To fix this, I proposed adding synchronous validation in
> damon_lru_sort_commit_inputs_store() and
> damon_reclaim_commit_inputs_store() before setting the 'commit_inputs'
> flag. This allow users to receive immediate feedback (e.g., -EINVAL) if
> the parameters are invalid.
> 
> Changes
> =======
> 1. Added damon_lru_sort_commit_inputs_store() and
>    damon_reclaim_commit_inputs_store() to handle parameter validation
>    before setting 'commit_inputs'.

Nice idea.  I think we could do even applying parameters in the callback.  It
could be something similar to what DAMON_SYSFS is doing.  The code path for
doing that in DAMON_SYSFS is, state_store() -> damon_sysfs_handle_cmd() ->
damon_sysfs_damon_call() -> damon_call() -> damon_sysfs_commit_input().  In the
damon_sysfs_commit_input(), you can show how DAMON_SYSFS validates input.  You
can also refer to commit 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs
from damon_sysfs_commit_input()") for more details.

> 2. Added damon_validate_attrs() to centralize validation logic.

I think damon_commit_ctx() is a better way for validation.

> 
> This change is motivated from another discussion [1].
> 
> [1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Because this is an RFC and I have a high level comment above, I'm skipping
detailed review of the code.


Thanks,
SJ

[...]

