Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC0CC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594F86B009E; Wed, 23 Sep 2026 12:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B2C6B00A0; Wed, 23 Sep 2026 12:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4832C6B00A1; Wed, 23 Sep 2026 12:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 235936B009E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:02:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD5E51407B3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:02:24 +0000 (UTC)
X-FDA: 85245494208.14.9458D81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1CBE6140007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:02:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7AZCEg9;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790179343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M79vYD/0NuECTzxyn7/SZqwo9o47/DciXWmBgqiAck0=;
	b=2C6Ol43WN+tIo/3SQuYy/oGfUBh4/Ipoj/HLNGOF4QGx/xN831QB9uL2ODPwnXL6cWKwLW
	uV8Uw51ASi4LNTjl3Izydqn1wDLykdPghgoEqZf3Refuupvtt+RwD+IMhi4dA/12X9+vze
	cvtaakWj7Jl2NjYFNv8YFZ8lHG6jKr8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7AZCEg9;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790179343;
	b=FMF0j6MBonyasEMzN97De9ZluxgCp8+6go13UQDCSU2pXoVi6h8tircoiaIFK1Dmj8JBRy
	0zpbGtKtOe2r4EWFIvMLfGgvn6A7y0MBt60Qml6Da10rwo0kQvTwZs/p5dgG1lZMHAbhdl
	f4gRAn/z+QBvHGJfNrWnR+zRYlf3A0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A82B600D4;
	Wed, 23 Sep 2026 16:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BD61F000FF;
	Wed, 23 Sep 2026 16:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790179342;
	bh=M79vYD/0NuECTzxyn7/SZqwo9o47/DciXWmBgqiAck0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a7AZCEg9mOmHObnvA6Cd0w4EdnEq+L4JOd8/1X2w6uLUJmT/gz12kXC0xstpbdArm
	 kGeuthW09HYW/H6Fdrt9wc4dFYLNa9e0wu22KaoBM7BA2oHqxgvQoTj8GovlqUgqMm
	 quuGaVBMDYG7nHhIZ8Ahha/OkYJ/Os5nVsocdQX4uzHzJf9s6U118rGXeSreVB7uPt
	 I8yS+8MAJETkVczEa/DFshgYSeWE6MU4It0nCjcZhRm+cLNQrxS7dhrx/saoTEOp3D
	 MTCzBghnbZHkGSFIbJfBbk/HRte3LPwdrJ1cAlNx5E0t1sfqbXaMQfBu1oSzcjiLBp
	 itLnd8vHyFtAA==
Date: Wed, 23 Sep 2026 17:02:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 04/10] mm/madvise: use the PMD softleaf validity helper
Message-ID: <arP3wI7qe7-eA7J1@gremlin>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-5-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922235830.2350770-5-gourry@gourry.net>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1CBE6140007
X-Rspam-User: 
X-Stat-Signature: 8xmqcsb8gso4t8x4zd1yn8b1kkpuxrp7
X-HE-Tag: 1790179342-231031
X-HE-Meta: U2FsdGVkX1/5Z7rzdjqeSNUndMuH29RmkUlsKCQ54Brg8DcxDQTrVIBq6ZsRlwE2Ncj2hOZcfrjUO3pVDsgO2QSz30O6ZRFsOkGfOT0c61tk7hx5wIc0zV+IfkAQd0NzDe6rRXWza5mrjeVz7erqvJNaYsvKWi8qKyVX+QOaEF1KYV+UG0sg7bP4UVD5EV61pknYFNr78e4hsHrKjQPg0t++w6FNc2UbTlHuuUJPIN1CBDc9N3xbpKzjaCTWrX5BpkarDfVgFA66XhypnimbQjzyTTanZD+jK32XQkS2x3r3f2X3wYmyofDsD35PBoSkeFVei+NNckyQ4oFOcd3zLWbML9sj3zOuy93pF+AT9f87QGlLbIvDDe5VDAqp3hUkeemNRhMDy+nBxydkVJIVsN7gQsE7767HuyO1mfVoVTPicKbKDwo46vY8jJ4TWIOn88imSJwRIf/nVq4TWHB4rzr+XTIBoSspDTRYPqE9gRGu28G6IYky6OncskU/ICM4uXrRFKKANnmf+tSslzORCo74S43rXJShYD5ggY9nbkVs5WNNX9ynEQao6tgckyqjZASrny9HYh6MfNO+UURM94dmTiwXFOOw22p7IerhG7VUd2M8NVhhYEouV2G8MXpRx6ZZ6NARBH1c7VD1y7MeLdaC4prCyJSdjUfRvTm6V54KQ0BsK/0x625EsjlDFkI8ME2fhr0ZUaw4GM2Mh3fQqgn/0HcJREyzLf3dLOW2Yq+nOTK9h5HM+IyumJjeCjNaLw5x8Bx3tHOwJpBwZNsHBT6OFA/lch9sMEG0lUgUS83ZQEorUfYuEWJbaPsVoXlJmiMcfmeKykLmcvork5w7nvRBZ5BH6TosusxUTub2I/yNLuG1a+WAsTwYRfqOGRQ5YE7vtVcZeRYd8ozfFNZ7THI53G2BO60Yym7G6gtUUD77Osq/yhXT+xJOcvsk56jytDUdxNmGH3mrzRfw7Tp
 fiKdvXUJ
 xxJ4lvTZaNOc30cNNBrcDM4KhLKuxBsVDzZcEi321ZcHxJNSgKvNBAoNproALSifVpl7Szs4xP0nKLYoMktoooQp/dWfyivqIolZ+AkZYDyrED8wcid7zYfIEyhwNfMDnS09zof0mvFGsmH5R5z/MjUl791muh8Sh732xWOssERFtZteUEtXl1dTzj16LMW+n3yL9ZuDjw9hzzdXNpi/2xJkoYvvSSBBMe9g27J7ZH0THnzbqeWhomD52rOV4OuMBzSu1ItFrAcyz3I7+PeTvjJ2XMdENkPWYGDmaEa9fKer3wVetPtLMx9sOW+x55Acx67GLDHc+hU8xG58wdCMI2iSI4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:58:24PM -0400, Gregory Price wrote:
> A non-present huge PMD must contain a software leaf type supported at
> PMD level. The open-coded check names the currently supported migration
> and device-private entries instead of expressing that invariant.
>
> Use pmd_is_valid_softleaf() so the validation follows the central
> definition of valid PMD softleaf entries.
>
> No functional change intended.
>
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

LGTM and I like the use of softlaf obviously :)

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/madvise.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index c345fef23f15d..b31b877c2c130 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -427,8 +427,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>
>  		orig_pmd = *pmd;
>  		if (unlikely(!pmd_present(orig_pmd))) {
> -			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
> -					!pmd_is_device_private_entry(orig_pmd));
> +			VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(orig_pmd));
>  			goto huge_unlock;
>  		}
>
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

