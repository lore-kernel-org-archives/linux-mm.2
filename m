Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289EDCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 18:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1FF6B0258; Fri,  8 May 2026 14:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8626B6B0259; Fri,  8 May 2026 14:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778396B025A; Fri,  8 May 2026 14:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66F916B0258
	for <linux-mm@kvack.org>; Fri,  8 May 2026 14:34:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 173A21C0189
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:34:17 +0000 (UTC)
X-FDA: 84745102554.22.0614349
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 28F9D4000D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:34:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a5zKg8TY;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778265255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEJ9Fh2AWUxXw9PAG8YhIlPQniJqorwmdhhK4SdqJmE=;
	b=BG5tu4+ZW1kUrkVPebJcXe0XLI6T4fMwJ+YorRn9ONalcu/RUdc0yueue9CgcJvFI+K6tb
	TNX8rSiIBbit8WTke0h6IbsWgxVh/6HLLdBIHUaw3UtEZAm07NNuIFqAJf9gD5wOz6j1h0
	rj6sg3WpQAhviLjzbgOSoKlyWml2AmY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a5zKg8TY;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778265255; a=rsa-sha256;
	cv=none;
	b=ALONcT4KfTX9jdwwPsuAJS2yIzBKvu67EcDavtIOCOS7HpskAp0Xld/PkY6CpInJE8vhih
	pf4bUisZ107ba1SL1y0wCMlW1yoCJ8f7tZoTjikHlM+6q2sZP9ZQUUYAdaTzufbFDxmInf
	4TVPA4aBwWnsgqA/kmQaA4s3Ks0GYAo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39DCB4427C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17882C2BCF7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778265254;
	bh=NEJ9Fh2AWUxXw9PAG8YhIlPQniJqorwmdhhK4SdqJmE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=a5zKg8TYmPfxZaDlC+m6nxhtQF6rGdoRA6FntLDUz7UspcQwoFgZ4izmrIVHYzuT7
	 nTy/+UIAOPChWM+8IxsVUOyABIRhOrfgGo2fOqcLkEIETE/pvnv4SFwkLe/5VHQjbk
	 euf09+9GYRlPb9WXO2xIHCMEIEjYwdlCXYMUr3Gq8cICXbGA89mAu+bh14lpkmT9zz
	 LohS7dwZRvJ4B7z6skL2RswKEOVPFtBkkNciN2tcSUO8lbRwJYze8599oKNy1Uo4ut
	 nlfYLeZANuq+gFgVrYyMeRB40jWXbmhXppFloA43E4sLSnc6t4P4PS2uXqvCsyzXh2
	 6WtTcwk37MM1w==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b936331786dso287347166b.3
        for <linux-mm@kvack.org>; Fri, 08 May 2026 11:34:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8/7k8KQuc1N6mgJmHj5MSysaMK9/0eYLUjiOXjRBzT44clpYtpo/EGibjPDLfO8ejKoXG604OSvg==@kvack.org
X-Gm-Message-State: AOJu0YwkQiDe52qTv5zZBiBDifp8RDUd7h8QsAShllWoE47OwRabEuNG
	CXaqpjU9QEzAbT1/SPz+aRHFR7j6m89zV2dWO2xO5/BhPcWU7faa0C+armfpm1SaPPEG3R/44Io
	3LymDVy1YcPsN27quYE4jv+NNO8aRBp8=
X-Received: by 2002:a17:907:3f0f:b0:bc7:efc0:9624 with SMTP id
 a640c23a62f3a-bc7efc09813mr541896466b.44.1778265252918; Fri, 08 May 2026
 11:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260505152228.124065-1-pratmal@google.com>
In-Reply-To: <20260505152228.124065-1-pratmal@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 8 May 2026 11:34:01 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMWmk3HdJOW=DbtCoZrTjjFJ-ErAwOvG=8qG9bL00Xwyw@mail.gmail.com>
X-Gm-Features: AVHnY4LJlDj7BVfDj2mmsuAiQvedaub0NNdj5hn8vKWDan1KM4zX78oocFXMTC0
Message-ID: <CAO9r8zMWmk3HdJOW=DbtCoZrTjjFJ-ErAwOvG=8qG9bL00Xwyw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/mm: use pattern matching in .gitignore
To: pratmal@google.com
Cc: akpm@linux-foundation.org, shuah@kernel.org, yosryahmed@google.com, 
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fmjm5khtb3e3nfamr9gcc58e79rqp76m
X-Rspamd-Queue-Id: 28F9D4000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778265254-113490
X-HE-Meta: U2FsdGVkX1/NtEWxLSwT3GUfsXj/fmxTEThT+cette3v6ahsMHHlR628sy2G+dLUcEAeJEEsTvX6aN3e8Z2f8TVfmaanBNSqHSzzALHmuCOOyOsglnph5Pv9QMgNxaghEqz/O9UoO8qeN1GwzOOFJzeqAkwwnU7CZYLYzAdmUwYJP5jAuQGn5RTLUwjt4i4/+ccDC3/r1mCpkNCdqjLev2HF7t8DBQTS4puJ/Ad12V5bD9rCF04VO7YMzsMEwDTCmvVhJKLILF9gYXXLxf7EC/UhG4hGYjrobBOtAQkbe2rznb/CIknhiRCTSvLUFqtQkNEsUehCvXcN+GAdOK5Tq+1vn10CPcKAjze3hA6EmP7k0bKeJgZakgVEyruPdAUBP0zAfC4Q3FwhUbWjawqCEZOTmMwrWdCA7UKXtRJkShmPZLGG9rUUM449SB10y7GGcfzJ3unLVuhp1CyR2w5pzTVnl8XMUs3k9b+BBhlE6ZDnH8CZnrzaIOhrwjfPn7yCrVff9v8wdmWm07MEBlm/LDfg5UkNMLfTnL6qqRhssvdIwjVwcrbpThah1r7sSmc1Pynek3dFPd7ppMukacXDPYIxUEwX270V+Cn9OZjdf1NhMbnVw8cZLp4aeRp0wfbVnDNsHjV+gSYj6NibqJMr2t+rtXqlMRIto8okjFtvt2nfLsfTlQ5oeMtba3vmQu1gGb73WBHal2yQALJvFG6b0msD1n+snoPRBgHl1gUAh/IlYpTGWe/q9MG6ZTJ95aYfcCwgndQ/Wa1EqM8F7OCMQ9B9JXMoqTQCvoCdyNGmULIApKzpHMGmXjZyMxxeukAFqszudwUksmttx5En0q616RSSgKh1iel2q2f++4D1RxVOQ1WITQ4pGZh4b5k3cnvVYXbTMy8k886FmwwPidLRf6m++l8veFizkr/Y1HoPf+Bl9+9Z82Y2t30QTTQuWo5IzXJmrnzqKyXe9uACMiU
 Y3vD4myP
 zvPLuIl+CAR/e5Umh/blqgxNOFI1mwPLJgEVS/VS7aysZJGpv94fPeZ+P4qCMp2d9t3Hi/aWjy/LunCds2CeDRGfcRUvD6OLPWHnxACgHQWtotuAr8NmVOMSUJ8TT9QhaPjtN7njLrSIwr/exgRztTmjaI8sW5B2e3vbxq2QqbQACDmfClOCpYZytm2BCOabKv4TVGdtco9jLFj4gF3myqgtQp+HtaTYRswkzNwTnaLH2g6M8BqljoGMo+80F271rb3Jr4Qf4XdUI1x5Z9gwl9vV6Ij9qutregAIdrIWXHNeO5MfUGLr13ueFJbNelAH/adW9ahNgSFBvYvWIr6PrUEunHx/njCxXet9shhFT9c3t+JQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026 at 8:22=E2=80=AFAM <pratmal@google.com> wrote:
>
> From: Pratyush Mallick <pratmal@google.com>
>
> The current .gitignore hardcodes each generated test binary by name,
> requiring updates every time a new test is added.
>
> Switch to the patten-matching approach similar to KVM:selftests.
> Ignore everything by default and then allow source extensions (.c, .h, .s=
h)
> and tracked non-source files.
>
> To avoid un-ignoring the generated headers, rename local_config.h to
> local_config.h_gen.
>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: David Hildenbrand <david@kernel.org>

I think these need to be sorted out (as I mentioned privately).

Also, we probably need to split this into two patches: one renaming
local_config.h and one updating .gitignore.

