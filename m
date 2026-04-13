Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B705F34C51
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68C66B0092; Mon, 13 Apr 2026 09:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F616B0093; Mon, 13 Apr 2026 09:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C8C6B0095; Mon, 13 Apr 2026 09:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A73866B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:12:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BE3D137CEE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:12:27 +0000 (UTC)
X-FDA: 84653571534.29.5016D0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A293F80012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:12:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKnUFuCl;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776085945; a=rsa-sha256;
	cv=none;
	b=D8Ij1lxR2cnf4A7dlRP2fRrWgfMam3A6ERjpSE9EqPuic72gUzFn+1co/lXBx76CBVvIkQ
	Z4sMS+Wpf5mWdc7lRAiHQQ081DEcXEP1+EgLj1JOcALLgAcKXRXVf6i2UoRAFuRJYrpitx
	KPAHzEX5JyeWpzyfrMZzz9/U2vgAjE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776085945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sk8B83D/FDsvvlgwlqt0y1/UxLLINWzrbisbERlF/A=;
	b=I3B4Im14oEWUeMa7rjutwZ/61HrNCpqUYs34BDktinXY7YN6VzzcnJISxC9vOnnmvz0DyY
	41PzfXmkZlPoG6BESulAntRGsJnAHU83aIqsXOpb6O66M5fgvBVZ8sT7uWHFxg9mZwXgU9
	lgxTsMdOb0XLBUOrGJUVXCgNyrOyDtc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKnUFuCl;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA728409D7;
	Mon, 13 Apr 2026 13:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A980C2BCAF;
	Mon, 13 Apr 2026 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776085944;
	bh=UHZFVzdoCXmQFRk9A/R0zhGTxhJDLka4M03QOaOa4UM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aKnUFuClJm5nwOF+zkveF8qfYQ7Ffsj/x2C9dffwv6qelVzIk1T3nOBpfVSceyx5L
	 wg6hLxRqIP0o+j6c+E9iAlGLwuOkghGx5M8JTgc3p0dMl/p9xhM6PFZCIfQHzEIfDa
	 Tp+3rjWZB9cVV85FvM9CApAW43XsByMcfmYez91QaOMpeQEEmb3IOdZaUVSs+iE5KN
	 FIuNfYTfC7MkhbgVD5rjTwwBHYHSO1TksOhJa1QUqepCvRqz6d6jPc2BPfYo9j6SYP
	 0l8bwCikVLUh7yhf8Vb6QK8vf8LDr8O+g/gd9Y7S+dTxHPiCuCi0QsGqsSsBIVtMVj
	 fJWrzfLGuJa/A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  kernel-team@meta.com,
  stable@vger.kernel.org
Subject: Re: [PATCH v2] kho: fix error handling in kho_add_subtree()
In-Reply-To: <20260410-kho_fix_send-v2-1-1b4debf7ee08@debian.org> (Breno
	Leitao's message of "Fri, 10 Apr 2026 02:03:03 -0700")
References: <20260410-kho_fix_send-v2-1-1b4debf7ee08@debian.org>
Date: Mon, 13 Apr 2026 13:12:20 +0000
Message-ID: <2vxzy0ir80nf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A293F80012
X-Stat-Signature: ikca1nwwhmtxk9h3ytef9ukqof8uxdpr
X-HE-Tag: 1776085945-673459
X-HE-Meta: U2FsdGVkX185GPczVIU5LnR8HM/fOP2DcJW4akoa1LfGfCdlkDRPA5XHdSSPjEZtK/ltnvqfl9PY8xtx/h4rGTd8CcuyNAzNbevX3xTv3OcQ+QjJenh1bOLHC8OG3q11NRiKn/16POm4+aXLNcPFw3ak0OH2qDZefZOXV2R/mKQ6RwVUGTV3FXKOOnLtT2yEHGTXUGXa+R1vSdINkiiTfp7ZmHxRwdgXA7IUlf8LMb0Yx7NgtDm5JJ6I4IPXRBKk34SP1ib1+J3OjLPFO7dbiM3LhsMI+u0wvMFGUcFgOsEFjfqIOn0fsfHwCYTe3RSMrw9GoHXyWjAP7P1BztRR6BrJDDUKnsZJABlwW6NKktjCA9Nxn2x0fFsAtKHRx3bTnNWFe3vdq6F6j9yZWcU21UgrBvNBZ7zrslGAOJOgs2o1Me5MflJ0oKIsPo9RNlpSIIBcs2afrjoxy5yZNEDXWabzOPsbqH7h4diHqP3f8OPFk7ZgbtRn9RZCSWoindy4s+18BfuEaDB2AjNI+2QlnzVSgOFwp7gBM3woD6Kg0zf7ephOlG4wP0BvkeZsg//vENE0oUN5PWaPnPLgWucZknsspXvDekbY6SEjIQ4Iz8XZb0hvHFX8q45NqJ98LYnpc7UJywXq1KgeQrvM8QkFAwreZkLWTCRZQhY5p7qzJfkrT5C6eRvPt3ZHzERDmoXwn6c/i00ptgHEVZfo7/A90KE4H6TIGnqHp4GZloWCMft4YCXzJVGrX3fT/opZBIuVEYY7jgAGOeY/dMyVb9HUFz7TE13dC1LybViC6V9qOcsXQ94B6XyDmdQYqiMeoZC/7xciaA573kUp1XuxS5zpUoIb6qLvJrJ0TdJT0aEFabjF4++9XFIVZuzQhvBwdNz2HUOPbszxj61GPCG1AZfSqXw6fUTOeQV54mxxRrhu/vYGD7CXV3c+S4bD70HTH/+k+VnMukRMEhcIUQ9TWjI
 lWP6U9na
 o4rr7eV0aYY4O/GQiXh3htFDRoU3AvuDUoAHs11TjQkN4pQi+8l/qyBBsaga5nyeVBAOvyIzz8y1vRRUs1hIf0L2lV8fcWpr9h8zblhUzv/HaeCrcr9p/9P1pMHzSc+ekndWI2ISnj9D+wDgNtcHtRdGXANQVPATsw0Rz+dHoA4uSCU+68BBviTAouniG8NSnF2zt6os3TWKEYeHsOjdpvY/btcDQtEuidp7ZlKbdW8eZp89xKTAm9FI3+0hFZK+y/brRNIPFLMYQuWXaMMvbtFnX8DdcEv8RabtVCTvVvdrmX98WWS3yWOuC9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10 2026, Breno Leitao wrote:

> Fix two error handling issues in kho_add_subtree(), where it doesn't
> handle the error path correctly.
>
> 1. If fdt_setprop() fails after the subnode has been created, the
>    subnode is not removed. This leaves an incomplete node in the FDT
>    (missing "preserved-data" or "blob-size" properties).
>
> 2. The fdt_setprop() return value (an FDT error code) is stored
>    directly in err and returned to the caller, which expects -errno.
>
> Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
> out_del_node label that removes the subnode on failure, and only setting
> err =3D 0 on the success path, otherwise returning -ENOMEM (instead of
> FDT_ERR_ errors that would come from fdt_setprop).
>
> No user-visible changes. This patch fixes error handling in the KHO
> (Kexec HandOver) subsystem, which is used to preserve data across kexec
> reboots. The fix only affects a rare failure path during kexec
> preparation =E2=80=94 specifically when the kernel runs out of space in t=
he
> Flattened Device Tree buffer while registering preserved memory regions.
>
> In the unlikely event that this error path was triggered, the old code
> would leave a malformed node in the device tree and return an incorrect
> error code to the calling subsystem, which could lead to confusing log
> messages or incorrect recovery decisions. With this fix, the incomplete
> node is properly cleaned up and the appropriate errno value is
> propagated, this error code is not returned to the user.
>
> Cc: stable@vger.kernel.org
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

--=20
Regards,
Pratyush Yadav

