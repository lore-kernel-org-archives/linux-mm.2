Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51ECE606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=vALBjl5t
Received: by kanga.kvack.org (Postfix)
	id 71CCA6B05B5; Thu, 29 Oct 2026 09:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3B86B05B6; Thu, 29 Oct 2026 09:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E34F6B05B7; Thu, 29 Oct 2026 09:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8346B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:12:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEFEA403E8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:12:11 +0000 (UTC)
X-FDA: 85375702062.16.0382A83
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE7224000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:12:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=vALBjl5t;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793279530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cruogtXfNCOrJCvoodcyrTOzahFlsASVgaus3wd4bs=;
	b=uUUvA7BUlmteDv+fxJRzLtWPKePK5VWU2jQxEjXYza8q5wlp/9T5Wa+CI3xOiAza1fb0P9
	JtYsKhLkz3cGiANounNtSXZ/Cj/SbVqPgInw7hzSRxFynEU5vxcqHNNGIW4t1Uhl0VI7ij
	OQc/crVJVxopmtBw4OfwJXvFCiLnUcI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793279530;
	b=8YYeAZtk+F1tKprHBXFopUXD4glnS0V8eDKdqFh2FY0E1UgM0TtKSdgzWFVih0Xh7Ehwsf
	K7CWdQqBQPPayS+w24EnkvaXH08D8Vx1aVyf4MZsrbnlXw3zs2jrTXsPCIavSinDkJtdt6
	55a2+n5BN8s2KHlUt1LSBpatPC6ZAIc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=vALBjl5t;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793279528;
	bh=4cruogtXfNCOrJCvoodcyrTOzahFlsASVgaus3wd4bs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=vALBjl5tg/HLHwAe5LnWN0I+FZe/ilBHT2lZAbbXATHMbz98KZlNi97W3j84M5MIm
	 EgXRxUJW0KRszvy4pqxbaKoourAWAFiwAZJY+Ct2Jbwg3k04WPlzyGUItH+c8SnyYr
	 SQLCcctV6enovEyNRJB4QlV0k1lXcskW58pkHYoY=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D6809101233;
	Thu, 29 Oct 2026 13:12:07 +0000 (UTC)
Date: Thu, 29 Oct 2026 13:12:06 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>, Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, linux-leds@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
	linux-hardening@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 07/10] drm/gem: Switch to __nonnull_args() macro
Message-ID: <auNGJhSe3tVi7rDy@shell.ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
 <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
 <fb3b6a24-74ca-4da8-8593-352afd515313@suse.de>
 <CANiq72mMm75svCqevd8fHtVoczDpvpo4NwL0SC8=bWy030vQuQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mMm75svCqevd8fHtVoczDpvpo4NwL0SC8=bWy030vQuQ@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE7224000B
X-Stat-Signature: fczywfw5g9gtx4gdtw7hs94eka579arx
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793279529-676224
X-HE-Meta: U2FsdGVkX1/9m1LqiQ8n0PqM5dhUe9jwoX8Icm8QWsF52dvhyarG1+wPJtq4Ui61DLscJjfyM8KA7mhgdZ8j+0E7+xlMihOJ0k8OuJeqt4VgQm4F3UrrOAG2WE0Zi4/cTrCqrM9nIDVCNPUuZdNYY6lOSMWHNKopCP4kC1O5nJJ6Es+X4hlZhEh/l0q3Dj2f3MMk5Gno/KbCrWQmQX4RvXnTdFXIQcx3sM30itu8W8c2wU0CcagZke0wYOMyi3kmTqge7OpXLSWMHnMjBVklVrgnGcc/zKKjkQxrtUHPQ2Kj33RE3nNW6SuIMUUWMi1k+7Ugu9oi6rRCtiEkWCMqrhtCF63RPPsfgqhMGYtZ/6Ke9pe3vCRspErMDMr19PGUQfX2SlQQKmjRQT9KpJTREzCpR6dbKEdT6hNOgA+p6ZM6/4TmaMKIJTfqlrwl2AJNpWB1O5SM1GEIy7c+ssQuAHFm/LMAPVc+OKc5QhPsLL7rwpbFvNwCScNNi4iGonp4huYAWFV6VbLLc8PbMdhyV8BFLMJPzfw42Gf/FzefVCYmBsP/C7tbrXs/zH9r/hlHOa0y8EsL1t+MzcliX5sCTr1c9y9ddRaGX0xjaAwVDmPvaPZYMSFnXG5QPZbYHku4OXgWQgQ1fdZGfNboKfZi9vjMjL1AdbWOPKVPiPlH5DB9lNgg+rYAxbPA/bs2C/MnvJUuQ8K7c2jFN92ZRpEBpPyqV9SIB4Inw0Q/MRnAwEtpwSrRCYu4NyyMDBCQxt1gxdyJ2Z7Q0ZeIsvvXEEobU9aZ59LwGbDnTjGI/IXat5YXCskcgYG9oeSEi+YiqRaD6V+I7b35TxOyrXiBPjgu2dTMLmAo6IvVOSgOVY5MDA228SEYKYviqFzqf4ps28dhjRd7pRLuN+j3m+3vN6m9OWqg0/JDcGKr2LCXYUvNzJoEmTTaW4Y6kt8Hu8HxymSowWLIeLJTwpsYF1LZfTu
 cn/IVnTa
 jtg+MCTDwaSiqnFaOOVuKawgSNGw2IyGhs2ghKgSQJkIMRJ+4pj6Ijlv4UOYVp6j8o7wgt4EQMkcKsPU6R32EAnIlRinzHhG9oKSGgbY79z6lOCK9uxWS/V/IPy0/ZWEezZaD2ZZQNZHLnmmeiCNbvFlsloTJzP+nQBJZKPVLuarBThoaXrDquvmsqY624AGnyG5oYU+PktF+jKxS+fjY7y7zGLcoTbJXfwHLpMhnyxkc1ICcnoOHFvBU7SpATi8wGAaHKSRMO3uTdJa/z3SdPXArfJEUm43J9gIXuclXjutapMzELQLw4Gh7MR1F6aCgqC4i6A56qJZxXCscICx283F03kviyS+USrERLro6ga+4nxvdIeNUVas12iXinOXl0AR/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:00:28PM +0100, Miguel Ojeda wrote:
> On Thu, Oct 29, 2026 at 8:32 AM Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >
> > Should gem.h now include <linux/compiler_attributes.h> ?
> 
> No, it should be included for you (unless you are doing something
> custom with the compiler flags etc.).

Just to add a bit more colour to Miguel's reply.

I believe idea behind include/linux/compiler_attributes.h is to make
attribute wrappers as simple and transparent to use as native compiler
attributes. In particular, this means they should be available in every
kernel compilation unit without any additional effort.

For this reason, all the nessesary plumbing is handled at the build
machinery level (see scripts/Makefile.lib:171), where '-include'
compiler flag is used to pull in include/linux/compiler_types.h, which
in turn pulls include/linux/compiler_attributes.h.

