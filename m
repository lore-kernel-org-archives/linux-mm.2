Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7376606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IVVNMxQQ
Received: by kanga.kvack.org (Postfix)
	id 113D46B05BB; Wed, 28 Oct 2026 07:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4206B05BC; Wed, 28 Oct 2026 07:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE436B05BD; Wed, 28 Oct 2026 07:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5CD46B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:33:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EBAE40C60
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:52 +0000 (UTC)
X-FDA: 85371825504.13.8653AEB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9E66B80015
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IVVNMxQQ;
	spf=pass (imf30.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLuXcsrhYze/uot6RAritgtezmvs46B7suAi1iRl0v0=;
	b=rSJQp1xgIDykbCcmEG6h2YKr1NAwnekMTTLUygY73KPeRwQJOwqxT7e/E5N8D+POlJqZRO
	R9nQ0dB9pTqbG1wSD3kI3bnIhuxa4S8SJNmEkSm0c3qLulfavjROFR2QRMFESYL/fEQmwY
	RQ2xtV/psU5DuXUYLkf4/2/+8JHbPBE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IVVNMxQQ;
	spf=pass (imf30.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187230;
	b=eQtfcHE9+XdgGS8ji7RIwbDldqynLOfhQsHlS8lOmnw4/OnHwhc5+iHL9+JXA5ZcVeIcg/
	OV4FR2ik1DhhYWB8j9jh8kIUE8RncPl21r5thcRQIaq16RTvFKTDxHfZ2UUYnNx0oLkmoH
	z9vXlPcsz1mPF9GX8FLe3sBDNeuAphY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793187230; x=1824723230;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=z8y8XV24bROqh0zonAMNAjIZyMJbY12xpb+/fK8m0AI=;
  b=IVVNMxQQqo6fRprueP3x9UMTEHumVFKzrdmky/mkExXlJb7w2SFFjxXX
   /NLDT53XEpbeLXEeS/gGxzM7FjFxrnIsyThFGtVRgg5w1IiSpIqBYJLXM
   05oc8sMSZ2hRsO2aGSU66QdPpdw8ixblIu9JJUkg/wIGAFglPYUveovro
   CpTBuglbqDYb33zKzhmIGGmzRl9pvxoxVIdf64LtQLXjLyXuBKXc9ZBQI
   GBtOBLobOqGn/J5w3CcFT0HT+41kso6oS+1Bq4jLRaitFsmxOFStIc15A
   naApAlA57SGHoy0w5Uzi1njxha9Ixm+AsZ6SFuMMmv5PSjrOcxFj6Lyzn
   Q==;
X-CSE-ConnectionGUID: ZOZZA3ahT0a6JrDxBpFdUA==
X-CSE-MsgGUID: RvnG3qynQR+CDDEn3haVdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1813638"
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="1813638"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 04:33:48 -0700
X-CSE-ConnectionGUID: F9mrBK1+QXS8jOjCv8P8bQ==
X-CSE-MsgGUID: KJ1QgI6jS6ey2L/RLS17LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="6633584"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.146])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 04:33:40 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Joonas
 Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones
 <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, Joel Stanley
 <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, Ryan Chen
 <ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Kees Cook
 <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Andy
 Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy
 Dunlap <rdunlap@infradead.org>
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Dmitry Ilvokhin <d@ilvokhin.com>
Subject: Re: [PATCH 05/10] drm/i915: switch to __nonnull_args() macro
In-Reply-To: <33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <cover.1793027261.git.d@ilvokhin.com>
 <33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com>
Date: Wed, 28 Oct 2026 13:33:37 +0200
Message-ID: <3b839373c03f6b8aeafa8e4801a486ece68b0815@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E66B80015
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kswf77kbc4euwgqji3abjds5jh1o7nss
X-HE-Tag: 1793187229-462307
X-HE-Meta: U2FsdGVkX18wTDxrhauFSvOhc0iIZIuQDYehmeHQSNQXpLsNVIJnqIHi88/vCIjqYrh/ekOKP7ERVYHUMYkgViJONaZyMa3B+mjV6Ta3AdLAPcrAEDlwMbStdtLCiQlI/2p7kCjDfV+KQCDUKpLocRbdL4WKSBhZU7tFWZe0DzQjjuz8FVZfEqWqnz1uZuJxdnhUbX1WAUrAQXIigpq7RQ+OISsmx0CPGBelEzTZacyTEPyoOSjGHEXqhL5/l022abZG3pJ5vsnULatYZUgxr3cwEU4GGsVvYGbRtCeLH1OQsrLwatv/Q2tiWq2bBMjQ/iDvF3GtbPEMq657puyXyJXHlzshENxVn+GDQeIDKNBV9WjHUn1kF3rWObWIBobb+yTQwAADNojDBWkH38+7qq8PN0uNbSW2zQAdHfy+glvbpOHTst89wvfE0R7RElECOk+RLMTYMckHqXlhui+XDX2Z5O1zlxclJbYsIONKEp86TVE2Fw5f2bO3Co8iwnyKM1PDFJCXlBKK5bYxjFH17rVX11duVie+zNWJdZQITeYMG9yCY+NwH4URaH1PuEU89s3XsuQIsbEaf3EEzrxL2XebxNa+4w0yZc68T8uuC7KFz0PxwoZUPftxhxlSakUyLKd+SFE3PkEz55HD5ZgozsL5L8eGBfkffGQsK/TfzxybFD1zubZNs18FTiFrzhrMBmJbKZqjW6G1bdMk+7+16CJypVIE6L4a+NCOTC3247iNXSZo3lNk3mt3tC4jG03H7VnJK9FL4INZUO3sphURoo4t3B5xZImZ5LiyERkEiUUTfCVpgTV4pjdHK4p/BivmE68TAB543AqOSfWEtNikG3whqHCv6ZbxRtBz5sLEJH8Hj0UBi5Y/J12VJQ17XJpw3H76dzBZpNxyJz9ZhJfLd6Jj/aYHhrWjHlftbbpHe4uA1P3hwyk2rCq67uhSXO/BpbsRVjGws9Ze0Xd5AJE
 v/VoGkwI
 bqCc2pmJDRuIt+Z3pEFGhj3aLgQ8XzXR2ipURhZASjM1R2dHt3DV7QfhrWP3NBSombHbJCJY9coIYYbkXwcYLHXtnBZdEhrPCN6dZyIMO6x1Mfe7QhSRFbJI8InKplwvJkwSd32LMy0xAQwj4jt+QWPiYFZpVYdD9nhjjIN0bfY1zOiASutaFMD0uq+Gp/qYLbCngpEvyytjH/AFlj+Z8jTkamAo4ynCzrkfohojoAexaW85WwxmVWBtKUZbRYGmpge9aKppdQ49WfKdSvtFwkjijczeb3Lv4Tro8ofzz22kCM70LD06No26+MhTxpOrZKgvkyx2/FRjuIXtp+PUvTkZOF7ujEYefbF0/djR4yuZZYEcD8kxWyg37a+tnqLXAPyf34eUjGLRolwTZDPXisVfrRQMOXI4JIioS8qSb+wTj4wqObP2nHvuG6qL60qCbb/5iGR4Q3hnkwUABPxZnHPwWLz4FQbZJ/LEM6xZjtt19oXlmd94c2OREsL7Ak/3NTuTY2sV5NW0WxH3wJOfss71aElfB1ObqAexai+M1tN/O2KKI1rl7a2XJG2M4wlY7avLDgVNguoYKAtDwAychnFmtd5ujvF/fiDDknLmKKsbGUVjEKE9Kz50E8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026, Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the macro __nonnull_args() to wrap raw compiler
> attribute.
>
> Replace __attribute__((nonnull)) with __nonnull_args() to standardize
> nonnull attribute usage across the tree and keep the attribute's quirks
> in one place rather than open-coded at every call site.
>
> Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/i915/gem/i915_gem_object.h | 4 ++--
>  drivers/gpu/drm/i915/i915_request.h        | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.h b/drivers/gpu/drm/i915/gem/i915_gem_object.h
> index a2f4b6758a65..648d0b4139cf 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
> @@ -127,7 +127,7 @@ __deprecated
>  struct drm_gem_object *
>  drm_gem_object_lookup(struct drm_file *file, u32 handle);
>  
> -__attribute__((nonnull))
> +__nonnull_args()
>  static inline struct drm_i915_gem_object *
>  i915_gem_object_get(struct drm_i915_gem_object *obj)
>  {
> @@ -135,7 +135,7 @@ i915_gem_object_get(struct drm_i915_gem_object *obj)
>  	return obj;
>  }
>  
> -__attribute__((nonnull))
> +__nonnull_args()
>  static inline void
>  i915_gem_object_put(struct drm_i915_gem_object *obj)
>  {
> diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
> index b09135301f39..f559203c332d 100644
> --- a/drivers/gpu/drm/i915/i915_request.h
> +++ b/drivers/gpu/drm/i915/i915_request.h
> @@ -437,12 +437,12 @@ void i915_request_cancel(struct i915_request *rq, int error);
>  long i915_request_wait_timeout(struct i915_request *rq,
>  			       unsigned int flags,
>  			       long timeout)
> -	__attribute__((nonnull(1)));
> +	__nonnull_args(1);
>  
>  long i915_request_wait(struct i915_request *rq,
>  		       unsigned int flags,
>  		       long timeout)
> -	__attribute__((nonnull(1)));
> +	__nonnull_args(1);
>  #define I915_WAIT_INTERRUPTIBLE	BIT(0)
>  #define I915_WAIT_PRIORITY	BIT(1) /* small priority bump for the request */
>  #define I915_WAIT_ALL		BIT(2) /* used by i915_gem_object_wait() */

-- 
Jani Nikula, Intel

