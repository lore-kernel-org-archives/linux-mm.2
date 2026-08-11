Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28AA5C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C096B007B; Tue, 11 Aug 2026 09:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCDF6B008A; Tue, 11 Aug 2026 09:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C199E6B008C; Tue, 11 Aug 2026 09:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAF06B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:43:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BC80C03F3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:43:56 +0000 (UTC)
X-FDA: 85089106872.16.4B73EF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05DDA10000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:43:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y3RiJeIY;
	spf=pass (imf05.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786455835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gz0q4Bj/jbKLsxjzDjzW6S4zyUlfaGH8U1N9wJqf3Pk=;
	b=pC9ixHlXoYdFaSP8afBSL9fWdWdIabJUVWrmQ4CR/EYPI9iOwjjcq0jkx8uMq1MlpLQPJe
	BnxTpYSpddwSLrGI3NSU7zwkm8iiBqQJr24w3/lAnTMzCQoJPBA7zDSJZtKuXzcTcCYE/5
	raf/j0MYuXO3y0zYlBu0CZ3FUEShzWA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786455835;
	b=RegNgJygjTUdrBQKOJI1Zz4g4MXkl/i2iwNIBox0SpnUv1F/RiMMAzuKIUsId/10btUX0I
	qyr4E5RnDuxRUDg+FI+Hf9AQIWK/6tfVPBW3D43ZitpYi0uD+lYdS+XarOSRkWMUJnFVGh
	/z5GMmGq/duSTUrgMXdWStbipHFWqGY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y3RiJeIY;
	spf=pass (imf05.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 512E8600AD;
	Tue, 11 Aug 2026 13:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21F21F000E9;
	Tue, 11 Aug 2026 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786455833;
	bh=Gz0q4Bj/jbKLsxjzDjzW6S4zyUlfaGH8U1N9wJqf3Pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y3RiJeIYaWN4UnbzDTXg4ul0AsSy6cgnOcwgiqOsY9P1fZUaTPg4F3Wa3okQup8eb
	 pWRp7XGcWRCz4oCSZ8Fy1UUTZ1tYsaUJ3tt4a7UsJrlqJcjJbzoj4EHnW12V3F+ljx
	 M3Ogs68K4RA92eE897opZbff48XNAYuEAKJOY1D43SaGopLzR6R6yNV3+iZQX4uUQF
	 kKNIc1Sq1FqDfzd7Y6eMzVsNS6yeT7hNsLP8rfcuXyQxUXbcSys1w2pKYrjZIDxQA6
	 cJO9Schn6EhfR55koqs93qaKSc9h1hfto6sAdlorjc3T9WBVYOXZ9sc/GhLpQoAMsF
	 QQDjkEJQn3+lA==
Date: Tue, 11 Aug 2026 08:43:52 -0500
From: Rob Herring <robh@kernel.org>
To: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, keyrings@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org
Subject: Re: [PATCH 1/4] of/kexec: fix typo in comment (usable-memory-range)
Message-ID: <20260811134352.GA2054339-robh@kernel.org>
References: <20260731162739.158320-1-linux@jaseg.de>
 <20260731162739.158320-2-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260731162739.158320-2-linux@jaseg.de>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1t9o17g3jquocf8gf6fmyh133ogfcte6
X-Rspamd-Queue-Id: 05DDA10000F
X-HE-Tag: 1786455834-14504
X-HE-Meta: U2FsdGVkX18CGkKe2RALA0AL94XsgiYTlPiVkhRKBVBNPpdW4MV1tvuT9szlO4fX4eIpNH7vzYatpYiFODfH13UODQEx3KGa2+7w8yY9C/eo775Wf9ZqFG+qoJlXe+yQ9hJF2nIqZJPdeArQglMEYiZrU77sWdI8yj+adzuBEx5b6g/7YBOuVZX7Mc/4i7D074jaAg2wSyC7LO/SUSPC98Ds341mNDIxPs1ni7Rq0hE8vtBqsP15WTt3uIqZ7yZ5CUQDjBO83LogVcziQ7lF+iiCm1UYjw6TYMZ4DfTzCM5WsBOnld0ANkaIEqOEOLCd/ib6FUZ2nn8yCrmZjFekWUMcs0pXP/oc735X1xlSCnnQUZZhTfQ16kcCeUKJ6XLS1U9dvsyTToeuc6wAmP0Egh/69f+3BGUbP65mmzgPf4e9p3Ab3i9aTNmEjlW9d8gxJ0UNse/3ADvM4KXE6xoDIMW2sOI5yF7y4Qfhm3/4VGPWmjH019ch+Xp5ufltG0+4Zn56et8x4ggl1CVmTBV8xaUCEqABDOzf8WyI88zLeW6FhUNBV4RqUqjAFRAMAWEH1ZuR3WthHI0MWkRt2rrY4rm3N7kM0wGjEwSp+p62N6NjLVU2MnlWm4y6peQR3xGate5l8e8yV4bYEtTmxqvRpG94c9ZEAFDySVLe+pIqsnKBcD7FL0S/FM93YwBAGKbwYKCjq96mDw4GnsraChX/Y9fpl2Y277Hr9DuTX7/uRGUJFHSe4vcsxwEUIKQ4sn7WOqBnrSnvxg1J/kcNJXig8IHk51NIqGvXwR7x+8h/UuSDbPd7IPb6ufts0fJ2/Qp5HkhOH4JpghrE86Epfo9D2GgtlE5y9J4yOFSy08X10Rcizzf8beufWC5+7GyJvEGMXH0MyHBCRjfxO6bCCBRRKaUkOoYVSYFvC46MFJKmitwOHuhMnA8a93JB2EXVlV43snTP2VEkyMGRzwOXZf+
 AnTBhz7B
 JjnwHZpRCBqwpyWn8ampwjPVBgX8Q30eQJvVuI0Hvu6YvLb/G164ZWO3YoilF/tPP9ZB/SmnVWwF45DHPKQGqb1HH0+fD+mC5vH4xgwz7nIpxdnd7KZHoOgAIEGrwOXHQgnwp42a8BtSSevKJ/lKBDr/JIguawSc6/YMsgJSjUBGiPcf5w3m5cYXXxOivWvoUmzMxglyw3GLAYPGxziMseRtUiXSdf9jpUCr6Bmg9CEt21O9RDaPnZlWygGCQ8bAnHLkOJ8hZyJ2NgBMA4hAx4L61wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 06:27:36PM +0200, Jan Sebastian Götte wrote:
> Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
> ---
>  drivers/of/kexec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
> index 029903b986cb..36635f6cb900 100644
> --- a/drivers/of/kexec.c
> +++ b/drivers/of/kexec.c
> @@ -24,7 +24,7 @@
>  
>  /*
>   * Additional space needed for the FDT buffer so that we can add initrd,
> - * bootargs, kaslr-seed, rng-seed, useable-memory-range and elfcorehdr.
> + * bootargs, kaslr-seed, rng-seed, usable-memory-range and elfcorehdr.

If we're going to fix it, really it is "linux,usable-memory-range" and 
"linux,elfcorehdr".

Rob

