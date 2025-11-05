Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB07CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352D18E0005; Wed,  5 Nov 2025 12:39:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303C48E0002; Wed,  5 Nov 2025 12:39:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240EB8E0005; Wed,  5 Nov 2025 12:39:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 135B28E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:39:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C568C139A45
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:39:19 +0000 (UTC)
X-FDA: 84077264838.29.DFDC440
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D4311C0006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:39:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KqsEtYSW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762364358; a=rsa-sha256;
	cv=none;
	b=TpLqA4j/kKsOSoAzSOZhI8YFeGAgFbHQ2PfbMxbJJn5Lg+9YBdMAvXt+3HpS9duRpSSxuK
	xf8Ol2j2MZPOm/b3axvKauvAXHEvFZwVKlmzbQUmccWy2vC3JMS+jZlJXlrf+Kl3ffGTYZ
	80rNiPDUbyxSQxkdP/EHiz27y5FPw3E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KqsEtYSW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762364358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bZBUPtzzzev37+uLhtrdVviulgMuIjvC1GY3crWBFA=;
	b=0mbl0VqJNkk6G0X86Odao8GF37z111WuxIfa1gkWR7G+fhbw0K0cWA8dfsPNBojBuInr2A
	FGgAR5rr1w402jXdEXOQdnaMWFL/M8lB2wmn8o5xbBBOQibUPR1u+/cCYirAzp/9H81PjC
	H4HArmmKakneDRZ9JqNN0d5m0akHqPE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AE2F60215;
	Wed,  5 Nov 2025 17:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1058C4CEF5;
	Wed,  5 Nov 2025 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762364357;
	bh=bnh3/CAPolVJG3UKOT5bLfJBBm8bDPtW71CYPwpR/mo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqsEtYSWwRoLiOeSsx3jWqVxakKTAiqjHt3pYO+HqWKIOgMb8Yv//+Q4+L72UVBBh
	 3y5NxBtKZHptCNufrfu4o+4y0RITkyywqH4qoGrzfzjTs58y2KKkTJcQKKU5RGWe0e
	 teyXwwpyWA7Vp3b3rCKTXj+TLa6cPruHE69TBxiMprtcD2sV2VuhNzG685aYPXuj8n
	 qOBGvBKiDh1AKxQ3F7/O4eUnz2HDhRzxyKnl3EzGswJndnPzAImRIu8a1Su0tLd2Or
	 rmpOjTcW7kuYuRDkgB+kGV1av2uWHZ+9vPbiHvs75FsEuC/i0MN8b6hImRNqw+2m97
	 gtxMrrog8iW6g==
Date: Wed, 5 Nov 2025 19:39:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: extend file entry in KHO to include
 subdirectories
Message-ID: <aQuLvVjH12g7L-fY@kernel.org>
References: <20251104143238.119803-1-lukas.bulwahn@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104143238.119803-1-lukas.bulwahn@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D4311C0006
X-Stat-Signature: hr7nhdgiutdh3xawt7hnrzis6n8kang9
X-HE-Tag: 1762364358-334071
X-HE-Meta: U2FsdGVkX1/P5fgwOQB0yIGDtkWaWjoUenTe8gop8cEKOQBaOisj/h3usKER4CkVJWvwYxshbnT86Fvq7IlQ2of5HdKOwfg622WVaE4Sk7H7gRRgCIkz8iHs1w1wDmYBJy7sBUiWtJWuMw10rPKTUEqtLFS3UZOvyY52+ooNFPUvWJDmrOSj5Coz6dHvXt8k5monup12oah6uvwKXEvuXiD6xqfKW+6Ilgh7P56RG+lhr9Nd8bSSTJoT3c1l0rhhVey/JLhnuQVp+d0+k0gz0a3fyq76YpX3wgOL/wu8K4YrCh8ATSvY8R3iyccbjyaPseDtDYnkHKC2nloLTba5xuKzblG459/QiNLQ4EWF+OeGdeSq4AAVq4e9txu6cB2yN4HIOj8FIKKfx+zX+6eEJEe7f2wpA9sk6ePJwAGlEl5E+5338Fw5H2Tf47tL/JqWCCNponry+MuMGziQN/rhv4a0BsS4Npw5KRb6jK1RS9MsxXl06lox6iPKuQ4mQjL46s6cOr0EM9Ifw5FdICb97AekjsBbg0uTyw+F0fEA6S5i1vCnUS8EaPwPeSuVQd+yuHm57YLHFsCycc4Ff2l46MFlvV24Fg/LGQtxFynGikAOTta13WUBRKmLTO0WU9H7d//RBEl+eyHKlek7bolb2hhh0eE6ANZMorK1imT4KvKQtwYTFueXpAYif0X36WAjjsJBAsnR9VIEUq6C9jEfNFcXQtDepSoOMAuqKFCzDdFQBp1/5CRZcTQb31hq/ieelTr8mtB/EUYcxhycv5MWqw5RFbn8gou3WPeQ7n0eT1JWdEgVOZLNvlmU+9ZoqlS7AtFxldCpF/MxBRRHg1WiOkeXaFpqmRVTQTixEhCB8H39aBoUYiglR4Eqa2QQn0UkyzfTPa+wETQ6rt8fgXZfScqpxD/48nOERXoxELCJRbXJL0m84phrVjSVUvVGbWQ8giUng0zpKHpOWFKjO+p
 eXeElI4s
 mq92x8tOeCj5ObL8S2KhtXVLBXZtqS9GiQuuSTd53Ffr81affDbhW2AuqkAp9lQ8zwjWwkklYcKaMwkhnhkgvvqMJ5AXKyxOCxTbU+Tfw8u03aTpyHS0jJ063lWv+iEpgmZ5pK1J4wH8fPhgGnFtgry75Ian5W6pfBoVfbt9G3w7k1bcv4MkUrvcIFAYEij/K+h8w1hoEBO7Muy0UWW6tQoketnUSEvoQREqi7q5jCWnXXDv23gV3O/37OgEKI4+z5xxWFIsc3Mo+qOZ72y0zme/tyL23XOZSlgyKWNOljhN0HmuMgsXPzdtAp/m172qEoofDsmodcgIuvVobWic7+IAj/uSxGz97IxE7pXoa2UjYhAV7aS9hePhLbZI9wsGPeskzuurJvqwqbfRXBCO2Y4VoTU1ZmMCreThj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 03:32:38PM +0100, Lukas Bulwahn wrote:
> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> 
> Commit 3498209ff64e ("Documentation: add documentation for KHO") adds the
> file entry for 'Documentation/core-api/kho/*'. The asterisk in the end
> means that all files in kho are included, but not files in its
> subdirectories below.
> Hence, the files under Documentation/core-api/kho/bindings/ are not
> considered part of KHO, and get_maintainers.pl does not necessarily add the
> KHO maintainers to the recipients of patches to those files. Probably, this
> is not intended, though, and it was simply an oversight of the detailed
> semantics of such file entries.
> 
> Make the file entry to include the subdirectories of
> Documentation/core-api/kho/.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 06ff926c5331..499b52d7793f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13836,7 +13836,7 @@ L:	kexec@lists.infradead.org
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	Documentation/admin-guide/mm/kho.rst
> -F:	Documentation/core-api/kho/*
> +F:	Documentation/core-api/kho/
>  F:	include/linux/kexec_handover.h
>  F:	kernel/kexec_handover.c
>  F:	tools/testing/selftests/kho/
> -- 
> 2.51.1
> 

-- 
Sincerely yours,
Mike.

