Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92497CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7F98E0012; Tue, 21 Oct 2025 03:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88748E0002; Tue, 21 Oct 2025 03:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5BD8E0012; Tue, 21 Oct 2025 03:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B922E8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:35:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76A50480F8
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:35:11 +0000 (UTC)
X-FDA: 84021310422.20.E236833
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE7261C0010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:35:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=oGm9Zg6Q;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761032110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25o7WWHA5S2HB9VWqZSJvidUjoO4V602Cgi4E9Pb6CI=;
	b=jXAS7PGR8T7v2VIi4H3tBLGqDJhtNhsMB5rsrSDpKKPACQW02JlMk+9Ckm3HJTj+lTnp6O
	uhyIEbX6+tS/2zJUlG2ySZ5aUBI/2hlrk6v4KT4/VKXeW4SpgADMaH5SD6itfgSGdagzdX
	1TJ2R1X1BV5iEZo2lpzuHHvsMUIk3ys=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=oGm9Zg6Q;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761032110; a=rsa-sha256;
	cv=none;
	b=iS29cML0nkyZ2aJm97NjGWreHAi/VWhh3CThGfL4MTq6Q8+KzLXL+4ztu3cAIevm1v+snq
	TncYwOIcygYWEtL3ETV42Xpo198CAbxgGfgA56UgHzSlrbghPRzdksjWIOQ7CL7JzCpIoQ
	KaI4yXjTvPZ6NRUT2rJMrR2NhGjztoo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE08E43C34;
	Tue, 21 Oct 2025 07:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B579C4CEF1;
	Tue, 21 Oct 2025 07:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761032108;
	bh=OwWy/3ZyBvLhFE9XTope3GptLHE7g08KOIFUWZ8LOy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGm9Zg6QNmBnyYDKSNuh+6126gcu3ZMM6EpoP1L1PuAkqeV8G/boG3UPhStUiPMZ1
	 8E2dt2anosX9UlipJg6yUoon4DMlSs/l/I7K0/PjFpojYP0UpFuPGxN7KiYP8emIwx
	 a9kvCFnBDWMfKrg3pTa6raPQNOUAMunC4qrf/cgQ=
Date: Tue, 21 Oct 2025 09:35:05 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech, acarmina@redhat.com,
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
Subject: Re: [RFC v2 PATCH 3/3] selftests/devmem: initial testset
Message-ID: <2025102151-distill-operate-a748@gregkh>
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <20250910170000.6475-4-gpaoloni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910170000.6475-4-gpaoloni@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE7261C0010
X-Stat-Signature: 9oeh5msjfg5833beqbpsdetf6fqcy1qq
X-Rspam-User: 
X-HE-Tag: 1761032109-886564
X-HE-Meta: U2FsdGVkX1916ZpEj+hJ+6otVnJs1K/i9swaMLwi5sIRDUPEjYUc1WoB3ilHwerigbORSNBmkEnCZuXSSvqo1n3Scg+8bgzMVTheOsfYfaCdlflNZUnpqQSbOg9CDbTFKfzJA50QB47MIhYXp20p04GRESuX6Fn2ZLKLStefMDW8QkhVRbongY2jczOTXftdQsg+OiL4PNormmENs6LRjzlBLqqty8fUlgWJmD/YvGMnszx7f2lTDfORn/gd6W8/uLI9cv4r3NwJ3gqMF2rd2Rrf6pDuZDG7ulZjl3iDns7f1bFU/LRBU2vruNGpQESTCe9COR0Ie4MUDfLdvc00R6qkPVKrtlKvqACaxpqRUOT3S1RscaGX16RZiIr4MdmfurOboN51zWWY1wm939kFiQB1NnzFJWNtAXDZdtHSzGBWWS8r1wE+dT+NtWHvZuf6iqS3sCPZ2EjB+5Yc3KD2BpVPFY05Hh+I/mLnoYY+lb5flQ0HKXMa72FQ7HjWTa9Ivj1NMJZo2OexNRP+eSuNCKqrOlMik3VF4XCxC1hXX54XoixsrzTHYjT1YV4JelMwDQZhGNo6deUl56rS8m3RoCMUpPFxCan7naX8IbvmsTAiSQMbdeSYTozGQk+2t2CWzzd+2HIop/xUytBlIwjme0ihXVObYgOQZWEtYAAiZ6AFBvPkhM3peCqFP1zdWkOuAz0A+NybFxpV4zl4+2DaSQdzsICHAomZerglZNzDwkuAuxBcWMq5+gIsmmrFlN0iacFIm4FmhZGjehxnBA4DORC3SUEmUkOe/eJAsJQoQDAThAn2jnZMaL/5j4OgN54TaiDN9ZIZBD3sg6xY7/b6bCcNWqCAtrc1MNi9/A0tny2bLIwzO1V4j9IKiPuIUk4tmAt/hGVYP1JPyC0HPwFd5QDDkkXBGNmmkI41XEVYSNmKZwgNCB4MdvNz0E3ufWcxWa6EYYvesuF0NjeNoO4
 +n1o9l3h
 vxjuH/PCCCANVimDl+4k/p+bcnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 07:00:00PM +0200, Gabriele Paoloni wrote:
> From: Alessandro Carminati <acarmina@redhat.com>
> 
> This patch introduces a new series of tests for devmem.
> Test cases are mapped against the tested Function's expectations
> defined in /drivers/char/mem.c.

Cool, but:

> 
> Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
> ---
>  tools/testing/selftests/Makefile         |   1 +
>  tools/testing/selftests/devmem/Makefile  |  13 +
>  tools/testing/selftests/devmem/debug.c   |  25 +
>  tools/testing/selftests/devmem/debug.h   |  14 +
>  tools/testing/selftests/devmem/devmem.c  | 200 ++++++++
>  tools/testing/selftests/devmem/ram_map.c | 250 ++++++++++
>  tools/testing/selftests/devmem/ram_map.h |  38 ++
>  tools/testing/selftests/devmem/secret.c  |  46 ++
>  tools/testing/selftests/devmem/secret.h  |  13 +
>  tools/testing/selftests/devmem/tests.c   | 569 +++++++++++++++++++++++
>  tools/testing/selftests/devmem/tests.h   |  45 ++
>  tools/testing/selftests/devmem/utils.c   | 379 +++++++++++++++
>  tools/testing/selftests/devmem/utils.h   | 119 +++++

That's a lot of files for a "simple" test.  Doesn't LTP have tests for
this api already?  Why not use that here instead?

Also, this is userspace testing, not kunit testing, right, is that
intentional?  You are documenting internal apis and then writing
userspace tests for those apis, which feels a bit odd.

Also /dev/mem should not be used on "modern" systems, so how was this
tested?

> +// SPDX-License-Identifier: GPL-2.0+

Are you _sure_ you want GPLv2+?  I have to ask, sorry.

> +/*
> + * devmem test debug.c
> + *
> + * Copyright (C) 2025 Red Hat, Inc. All Rights Reserved.
> + * Written by Alessandro Carminati (acarmina@redhat.com)
> + */
> +
> +#include <stdio.h>
> +#include <stdarg.h>
> +
> +#define DEBUG_FLAG 0
> +int pdebug = DEBUG_FLAG;

That's a funny define that is never used elsewhere.  I'm guessing this
was cut/pasted from some other userspace code somewhere?

> +
> +void deb_printf(const char *fmt, ...)

Who is "deb"?  You have more letters, always use them :)

Also, why debugging for just this one set of tests?  Don't kselftests
already have debugging logic?  if not, why is this unique to require it?

And am I missing something, or does this new tool not tie into the
kselftest framework properly?  I see lots of printing to output, but not
in the proper test framework format, am I just missing that somewhere?

thanks,

greg k-h

