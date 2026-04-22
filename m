Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1A7F94CDE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CACE06B0088; Wed, 22 Apr 2026 03:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D366B008A; Wed, 22 Apr 2026 03:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B739F6B0092; Wed, 22 Apr 2026 03:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A48E26B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:59:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 686A4BEA1F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:59:46 +0000 (UTC)
X-FDA: 84685442772.27.CD8BA86
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf25.hostedemail.com (Postfix) with ESMTP id 97C62A0002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:59:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=iXH+AChG;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf25.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776844784; a=rsa-sha256;
	cv=none;
	b=3vyZH5J37VVaXbinADqEyv0Oh46OCbx99Qswhy7Huxv0IOJOL4Lhzzq/gXKw+NqLtVVmr/
	m1awJXTleNDDYUuwpbIXofPkYCH1Z+xVArbpi/mIE2D8gtg+NlLgCvbI1g+AJ5PkOtmdxH
	Il9G+1sWFaF2AlGvKGqirSBEaZckLbw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=iXH+AChG;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf25.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776844784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKsQz6u8ayP/3L26MgNLWofkJm3W1LTrJTeC6jfaHIY=;
	b=PY4Oob+i/WwWrY7hUS/TFd5o2vFbL0OCmHnZNlt4994Trk5IVLaD0LaRwOE4Vq5sgac57G
	80yeV0k+gcU5KjNWGNZdkulu3rP4fkT0VySW8Ye2YZ2O0hirtRoXASm00wVQFPkmgcxHy+
	CBW67ylKKHnEUWLTxKj0lN7xHUBoG0Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RKsQz6u8ayP/3L26MgNLWofkJm3W1LTrJTeC6jfaHIY=; 
	b=iXH+AChGGdqd+UoRwbmc++bH3laUG3KIj90IutsaOgclyzpxVKonyn5kgxZ6KSMR1owk5BPTjs0
	MV13yYfA1eMURsGQF5OVFZvND2wpBCG+wAYfm3k0TCHgSpX8VkLNTnbw9+Pa5Kei4f0VEGnbdLzfs
	qT5rYL9jOxxNUjSWHPZNQuqUDpxVBv/PUTXNWHuT0lV+HQjq9c3zSu31x5EsnGkeHsNSiruvPQDcj
	BxbCQJOC+xReCIYzCuiFLOO7BGeIU97ogKID/km8D0CPl3EIW5I4vpZx60yeM7I00+8QmVXJWKRuF
	FGe1vyKNW0bwQNmWm7aVJgymGgqffpQojhtQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFSUT-007uVI-0V;
	Wed, 22 Apr 2026 15:59:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 22 Apr 2026 15:59:21 +0800
Date: Wed, 22 Apr 2026 15:59:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Thomas Graf <tgraf@suug.ch>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm]  c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
References: <202604211323.fac1b29e-lkp@intel.com>
 <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au>
 <aeh2Ii9CxtgfsX_p@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeh2Ii9CxtgfsX_p@milan>
X-Rspamd-Server: rspam10
X-Stat-Signature: ds8wfqisbyoyadm5on5khhykqp71mmtp
X-Rspam-User: 
X-Rspamd-Queue-Id: 97C62A0002
X-HE-Tag: 1776844783-756671
X-HE-Meta: U2FsdGVkX1/ZFNJOiQDe2/1A5QKPDyJiFgGb9/GAnm4OLfWpr7og1UShGHLiAVpjUZOjz3gN2XC54aJzA8lahs9HqzvjA7vU8CUf72hNwyW2buC3R6jnNNS1b3RQQsp1k3qeWfvk4G86t/gTbOz3umH4WHmB5e24BKlfXHdOW+CS+jIGfagxYuodoRLCO72icNn1NzyzXuxggh0vFqFRrpBYRvfEgWO802AiHd7dWLQHUi7zMggXys3w0FRVCerU8Y7FW7vIE4QOgzmFBmoT22cPk+eR6h8mhHe4cSnPvxWHrXIAgbHlcqSV72wclDl2bBrD3ZaqVEQNlCf1CZsq8qS5pqK1IbWqwttPRRMl5ACMgrtp3B7slrW0BcjGqa33YO2gt1NSZChAsGLFgF8QoDe9JFCU0Ap6uVl0U6UHx+dERP2MXOWwnkbSnmFGKHYJcJCLd7qlnu+YLrO6DovEzLXH17wZjv+bWMmrXVvC19Pqc8HoMd/miGJFkaixNRKlBhtc+j8H4dpiKLBgL4sMd5RbutCBVWU/LlrBGvsifx5VOxxenzXW9Jww+1Df+Tv8GKd6AICduYAd7y5zhiEch8ODfKvWYIB0CogHrdKwKnnvV8p42mAVS45NNSNhllnJRWJK4Mu/AsU7KGt41VMuPCzn/3MKEkyMIMNoPxaZzDyk8UaH41jqU1Ot1p3ucJ/kCS5iMG+TymWGOdAWgJEshVBBV4fIMi3prnjyJl2DwEycyO32sJb79xU1mjYmxmQD/+77DnUV78W9kuNovfZPTjZjmH0MRND6tdk0B0Jwk0Z0B7jo5KAAClpLDWeypgo/DGty/CdntwdcSNcRqU1iRj82WeuO98aDMVwH7oWIzZaPgsH3VRK/iyHe34gmXQvg1dQaHons8FUsQyaK/EgLvkSSXad9NcEUBvMJ8oYgzbp53zub/iJLAbXwlZ+ER2h0vISlNasuGoPyVzO+FPk
 4nt7gwfW
 Ol6hxUj6Gw9ADX77UKChdKiVntS/UTxpu25w3b48EPoF0S3a7ucgBJJjKXQT9BbJ+gCQ4uGFtdl0f1yJZ9vROnzSwhBx+DZB9LzFB8P7aj7gLYeXq5YU9vmHkyEtwqAwWLgUjvPokmkdIL0ipC7axc3xSwRp/9QXeH6uNcby6uSbGs56LSvnXrMOR4u+9hlDFtjxA5Ql7Gqx4l112R038Z5J2sDf/lnJ04p2ESmpInid4rWxzPzYRILycyQgNq6Fls6xdCRje3F8cps5MLSNQBpTz0XRQPIrYhw+Wy9nvu4/41HDpgS/Rv0ptXr9D/skPCzqukESzCp2cpwRCetI7C7A4oC71nYVlV5srUCQtQnRYkoopUEmz7nXw1byZO6gZSMGVNDkS8jd7hcEp+OknKiJ+Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 09:17:54AM +0200, Uladzislau Rezki wrote:
>
> since your GFP_ATOMIC context allocated chunk of memory using vmalloc()
> sense kvfree() uses vfree(). The simplest fix to free via RCU.

Why is kvmalloc returning vmalloc memory under GFP_ATOMIC?
Is there a new GFP flag to tell it to not return vmalloc memory?

This has been working for over a decade, what changed?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

