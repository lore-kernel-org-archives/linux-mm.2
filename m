Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52038606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=uwiMqCzW
Received: by kanga.kvack.org (Postfix)
	id 6C7076B05BD; Wed, 28 Oct 2026 16:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679416B05BE; Wed, 28 Oct 2026 16:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D0D6B05BF; Wed, 28 Oct 2026 16:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 375DF6B05BD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:45:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C21011A02BF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:45:24 +0000 (UTC)
X-FDA: 85373215368.19.6E4F917
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id BBCA51C0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:45:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uwiMqCzW;
	spf=pass (imf21.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793220322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhSU0Ll/YflHcbTsaPvMuTReTRNyw9O7ljUv0SFKW4A=;
	b=W2iAmEllRNubnLSALwN6S7io5EvNjrU/nvz45lO0RntHUexbJvhtBEjofaJqceEhOxJI7Z
	dpei/GOiOT+h6wDAtSJVUr32VFGfBGiL5v6RZLJKPfryR/VxBervVYE4p9Kp/skp8YXMSG
	eT2VkMMmVrWpk6hrWzd1thmIdwfPPCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793220322;
	b=A1gjYOQsLoTPKf+/bG4LDpPRywHmQtT+IgAqDwYW/ApqcuFXm3HEEYesE0iFU+r7lhcJV9
	/lkoNG35EDKqJs6DpDArkN3/52PoPSoSRaiZBa8wUDwH+g2y54xzYuawatnettr+f3rn1W
	RQOYt/xU9kcJrVi5iqYANpoU199x+NI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uwiMqCzW;
	spf=pass (imf21.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=xhSU0Ll/YflHcbTsaPvMuTReTRNyw9O7ljUv0SFKW4A=; b=uwiMqCzWxlSLOyvJWx1EpAyUkI
	8btbBfprVdCDyHYW3PydxYRJfRc+kFnuoObOoozn1rwW58Vj2BVWhqh0F+wlp8xlwih90BYwI51Em
	K1iI2tMdxPVFIWoitj5UhzFd4b/5QNlPTbdXz9zJMTATbRVGeZUbYvxryNKsjaEpApTR2/Y1wym5S
	RWkAgUP9MihkaliXEWdKo6u9MyrEOFdwTO3LSL1qUppz7BzJah7zzT1oZKKj6Mf9SU1NRxYMWkfbQ
	WLJ0+6zjDTz5RuWWZ/Qmx/h26GtaT+lmVMT47+gjluaxiNFrhSxl9AUI43A4wXxL3uIkD/jLlvX82
	Gvlz4IVw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMAW5-00000007wax-2Fqn;
	Wed, 28 Oct 2026 20:45:01 +0000
Message-ID: <cce30180-c1c4-4b10-b681-8944057bc698@infradead.org>
Date: Wed, 28 Oct 2026 13:44:59 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] treewide: switch to __nonnull_args() macro
To: Dmitry Ilvokhin <d@ilvokhin.com>, Alex Deucher
 <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Joel Stanley <joel@jms.id.au>,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai
 <billy_tsai@aspeedtech.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft
 <apw@canonical.com>, Joe Perches <joe@perches.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
References: <cover.1793027261.git.d@ilvokhin.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BBCA51C0004
X-Stat-Signature: xzctt4grj7tbfgazx5bsdbj93nwpyiiw
X-Rspam-User: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793220322-132088
X-HE-Meta: U2FsdGVkX1+UDdBov4qTW6/a3pVVlkpPxT7ziHOAjPkLnF61A+YSJ8EJkLla2GxTGtjD+QVOBDJvdyQWb/jnbDZRZvNWQWWWnTPFCjNdeQ1HXgtQFIIl/ROy/dw0yugwGxoTpyaVn4+YbpElEzoXv6amiJG5V/PYQf5P9PiR2VXnuAD57iTRMtqZ3ZbcCeVa1DYo7bIx6BPv3AgR1axN2bsPN/XSDD9eDpixdz3RY2PwGAEzJrgBCAJBlTpkahRcK16FAVFZx7j0CkKKhpFobDNsVvGiSS4E7Wuc0JVyJq3pWsaUGD5tHLgGUW419Vp5v+AnGTxzXdMKp/u87QJWBFeAhbn8VRog+CH0LDN5cP7FGmrCWFfKMer+iNy8tNRm5ZyrWQjkzSY8QX6v1S8V/j7MmSFxp9u01sr62vbXroQqIh4oidxFewh8P+4mvLS4/InENJUe7QA5BwQu2bqUfq5eDrIx0tiqDTOJAKTG4l/W4/BMg65PcEBWa+mtQqY6kAPU7VPx61g+lBC5iWsCqIB4kofKafFfMnmlZXTIofER+v+4n/sv4phzTcidw4E0N0tXhS8Ip/n3X2aR2tRFqR09x5XcNZOAuNY6cOiqi+7qS/AFKG+VOIKeg3/JnjFMCewPH4JXuLBnNZ+xm/570mHfYmAaUEKM3ut9Omhg5V5Yv0n/e/8BXz0mfwujxjKpsXFJnUykdOrCoTt1dbGe1NY8+vTavvnLnpzWmGAjJk6rd4ldfG87Gse7t12NNeuUIVP85rHnQLO/vwYbmNyf1SzwiIeO5PZJA0qrfKcQFZ82U6bvy4DRwE8JZQk/DKtnOLFWhzyUKgVCBKiT9vpUq2RFEjTATBXdpnYwC/UYcTfzyyNaTcoQ/XqDN0t6+TxS0pUTdbhBIeP5108cENKxjlxSWNeK/RwbRqJXoAPqKDxvIrPstK1VYTE74BcSXNiVUnbEtsIPyB7NwEgD623
 0JJ37/l2
 TfV0WNYTFUUNoosWMx6d+lnCIIt86PkVGktUvNdpw3kLXqfKpM4sNcfk9PdtHhMJOSB85YU/6EALrZbAzX8AT3HpoIcW1Lwqd1xeuA7T+/gPgVyXHVS8kpRNerd7KsqD/uZT+w2tKKxHbi1pT2o2w8P5YrXOrMjM3khW/bJ577U8O9eCPLE9t+/qXKfRiWIH8Au0nF8PvANZPxhtgJ7yt84QvWHt8U4JiHNxoau7nrj06TAYIjNDpSII+wCUk4P8Z6xo6ASDC31ph6lHHK3Qvmuq5o5cvcPIBqjXMvCFI4ncDAGAiJ1ePFuz+IJ7N4+EzMwWrOyPeJ70fJWTqL4DngpZhcpY2oV6fGBkCPscbgbJbjfXjSoVL8hB8fd14s1PA61Iw4j7dgb9GA4aDMwSMQaMywqvaG3GoOPN35d+H12v4fl0eg/7FwqwpQjjX+7iPitPasNc5bVzay2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/28/26 1:19 AM, Dmitry Ilvokhin wrote:
> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the __nonnull_args() macro to wrap the raw compiler
> attribute, keeping the attribute's quirks in one place rather than
> open-coded at every call site.
> 
> This series replaces the remaining open-coded __attribute__((nonnull))
> users with __nonnull_args() to standardize nonnull attribute usage
> across the tree.
> 
> Each patch can be applied separately by the respective maintainers. The
> only dependency is kernel-doc: the string and lib/list_sort patches need
> patch 1 ("docs: xforms_lists: support __nonnull_args()") in the same
> release, otherwise strends() and list_sort() drop out of the generated
> documentation.
> 
> Latest Sparse release could not properly parse __nonnull_args() without
> arguments. Fix was proposed [1] and merged, but until updated version of
> Sparse will reach wide masses it might trip on __nonnull_args() without
> arguments.
> 
> There are few more instances of __attribute__((nonnull)) usages left in
> the tools subdirectory, they are perf related copied files and can
> (should?) be updated separately after this patchset lands.
> 
> Build-tested allmodconfig with GCC 11.5.0 and clang 22.1.8.

What ARCH(es)?

Did you mean to use such an "old" version of GCC?

thanks.

> 
> [1]: https://lore.kernel.org/all/20261019175633.415493-19-bvanassche@acm.org/
> 
> Dmitry Ilvokhin (10):
>   docs: xforms_lists: support __nonnull_args()
>   string: Switch to __nonnull_args() macro
>   lib/list_sort: Switch to __nonnull_args() macro
>   xarray: switch to __nonnull_args() macro
>   drm/i915: switch to __nonnull_args() macro
>   drm/amdgpu: switch to __nonnull_args() macro
>   drm/gem: Switch to __nonnull_args() macro
>   leds: pwm: Switch to __nonnull_args() macro
>   soc: aspeed: lpc-snoop: Switch to __nonnull_args() macro
>   checkpatch: suggest nonnull attribute conversion
> 
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c    | 2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_object.h | 4 ++--
>  drivers/gpu/drm/i915/i915_request.h        | 4 ++--
>  drivers/leds/leds-pwm.c                    | 2 +-
>  drivers/soc/aspeed/aspeed-lpc-snoop.c      | 4 ++--
>  include/drm/drm_gem.h                      | 2 +-
>  include/linux/list_sort.h                  | 4 ++--
>  include/linux/string.h                     | 2 +-
>  include/linux/xarray.h                     | 4 ++--
>  lib/list_sort.c                            | 6 +++---
>  scripts/checkpatch.pl                      | 3 +++
>  tools/include/linux/compiler.h             | 4 ++++
>  tools/lib/python/kdoc/xforms_lists.py      | 1 +
>  13 files changed, 25 insertions(+), 17 deletions(-)
> 
> 
> base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a

-- 
~Randy


