Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C11E606A335
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 08:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mjqEq3Ve
Received: by kanga.kvack.org (Postfix)
	id 464616B05B1; Thu, 29 Oct 2026 04:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B286B05B2; Thu, 29 Oct 2026 04:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378036B05B3; Thu, 29 Oct 2026 04:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18E986B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:44:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CF201202AE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:44:10 +0000 (UTC)
X-FDA: 85375026660.22.87EB58A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF8DC160002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:44:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mjqEq3Ve;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=jani.nikula@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793263448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDl9p7g5quENVJzD97vvD5OqlYe1ysXU7bQyzl1X/uw=;
	b=F6oQxUeseMfz8e6ragjhO0BLEuyhomkYI+JpHSKeR6OGfbIX7KPKuQsvRVub3Bp/0ahQoj
	RwBekW7ISDd4mfbV1IcMQOFCXjRoV6BU/WQlaw4eZTTvCHAQ/mL3S+Ic4KE9oHEUdqqvAK
	b0pdXy/D+iyfk6Lgn1FuVGheyFUwpz0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mjqEq3Ve;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of jani.nikula@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=jani.nikula@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793263448;
	b=ZX3DEKINIXC5YycDawTutqilpcIxNTT0qNNXJfYjz4bcLNXSOVe35mquSOQ4rhl8w3HddI
	2GpLHZzeyuA2QEjBt9xpog5vBk8vbfQb3d5FJu2Fdv+PY48ghN6XsgEcO/C1acUtsNwZxH
	ESuZ6yYP8YS+S8FAynchhvLS3RofRJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793263448; x=1824799448;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=WP/QAZ7Uc8hCjUk9W10FsuMb7rLn58PCckd869LjBFA=;
  b=mjqEq3VeraslGj9/7vbEe+ZlrEtnNsxV7dHtAAjHEn9FXZ/8raR+4Ccj
   wReKvmYMV4u+bH4P+MAt/88tIWS2q218Jsuc38ui8Iyb1cR5BqJszCvuK
   E4xBrGD/PRs3krMVA7CgonhV4pfsu81D2t2NsIJvB+oSZsVHOhNadSh+E
   MeC+BIuLH+fmEKRbK4z5Eh2IKfQG3iguRSHtOAcl3EkuN0kRJD81Av0s9
   mBofpV+Vz/9vM4tMtWZxkmIDCnEmO8P4qQq4FRhD8tCP0oErXNJ1O4KuN
   wbktK079jz2l24DoZICGBTEFlHH8pzdJAuiUEwuGCCGOucoUYycMnVD62
   Q==;
X-CSE-ConnectionGUID: pzaNd3xSQb6sYDI/K+6ovA==
X-CSE-MsgGUID: nkUw+Q3eQTG6F6M2fP0gIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="2002477"
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="2002477"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 01:44:06 -0700
X-CSE-ConnectionGUID: oDqzyd5cQ0OZV3ZmvaMS7A==
X-CSE-MsgGUID: gVbT5JW4Somf8pxelwKQ+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="5411378"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.74])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 01:43:59 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Andi Shyti <andi.shyti@kernel.org>, Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, Christian =?utf-8?Q?K=C3=B6n?=
 =?utf-8?Q?ig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>, Pavel
 Machek <pavel@kernel.org>, Joel Stanley <joel@jms.id.au>, Andrew Jeffery
 <andrew@codeconstruct.com.au>, Ryan Chen <ryan_chen@aspeedtech.com>, Billy
 Tsai <billy_tsai@aspeedtech.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Kees Cook <kees@kernel.org>, Andy
 Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@canonical.com>,
 Joe Perches <joe@perches.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH 05/10] drm/i915: switch to __nonnull_args() macro
In-Reply-To: <auHf-pdvGkPibgTp@zenone.zhora.eu>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <cover.1793027261.git.d@ilvokhin.com>
 <33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com>
 <auHf-pdvGkPibgTp@zenone.zhora.eu>
Date: Thu, 29 Oct 2026 10:43:56 +0200
Message-ID: <b3045bc3ae77ef78a1f479448a5dc780d89bf38d@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF8DC160002
X-Stat-Signature: j11o9i6f8htgtq75fxr8mjw6noqbdssc
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793263447-882426
X-HE-Meta: U2FsdGVkX1/ZsPb4RCbnNXvPfPLYUVKkmyfeQUH+rqSI6cM/npLJrpS75JiJVT1575Nw6KkMQYLNwKTD0MYGnTJUe076nkPGoK0ctYSiUD+D4r4ECqDXNQgHU/e9b0O4J13bMUtFMwH7F1LzuRC78uTWqvgG1YKSnFEv7B+RQl1ry0ZN5TQfDJxNIvzTCKACB+2A1APmKJRdkNXXrkTR/dyJEGK2AoNKS/dImbtAMQ04ZGILJXDZ0iEMM3ow/XajvxPOpj1EREKFiTPi7QTeTvM8DVAdgy3zrJhb/tqv2g7XUzMMcYUr3ncO3VaxdI8GHfKoI2Eo5RG6Rzs1TMAnJuXQGwgMop3foHk24D5CchWYp/e1aZLg/SxiSuBQr13dopp3DdYjDn3ro9dMnAuMYLhN7AttZESf2fLByElrTAYqXXh+peu2eBYaG3V/jvuRM+cI86G0PBh80rayixGIgpnKRJfSMNcIe2gTwBlhLIgOODZ7Ka62Bh2SFW6YwSO9I29+BmrCxBlapiMlRqzqBOUQX5/9BAGR5Ck2yJQjb8zjX0ZRKzH0WMjGJWKVsjc5x1cTZzK9yUX4HM723MVhviBOeRSN/5hI7dsEbgcVR11gsHkp10XxHX+1EFPcsitzIDu6dEibRs++oZNtUlxnlY+V40mdfRdA2i1YgM12a6C/ywhJ4mpJzTDHWYSqBG+/I7QPG0pPLluKnlTLN1SCiIJ8hbtZ3uy1k2YFhrfF45IuG+3uUdrUU5AePkm6R5Kqci2aZto75yPADh8dlN+65vbh3Z8T7nr13WoL0jJmeKCeYi6DSzt4PJ7sQJWZLLp0EIXTA89Uc8ad1AUZ1if6+jvp0zV4XBFZbG58nM9eR5NeztfyeXMpQeuQzNzLgy61UsKiuWUlGjS1ZRAf3d9XEFaUuAwibnLLTzPgC9h1mFaFZxaDUVEjGBSyzDsAnaECEF9eAI9Fa6Xz3o6elxL
 VA2vah7r
 ihvQkP4X82aRRzHEOQA1dTmTu5vT7aDoqfVI+oSki49HYaXCk93c0tgdlJ4aWnMoIU/U7wpKv9OjeuBSmlYeM6jJO12b+gRzynRXZDcbhOvJ91FqmFwq9h7E4QzYTAEI2mT1sChrBKydtxcEwjvQSEzpZXa0wN3CxxTUh3hAw5SOqi0aSeSfmyxCx6MV9DllMu+02b/B/8OWlkQSgvtwU7j7tYYihm0ESzdjvvkw83nrda9JU/9K6898687hlpH/N2Fjpjnb3EqTkvnvGcyztoVW4GG+cSnq53+em19JDGOsDZTA5zmfee5Ey4zo6Dgfr/cOhxG03Fg6WY2I0E46vmwuD+P1byMEz+HMKS3pyHyW4q/lwR+1xBu7RGhyfGlfZrye76OLfAAsUda9Wkhb0HMURnTnszNwfSACMYnAFXKV8XnejwxJIvgKKYVRLIuuQSmiXCmoeKj3OWfW+ELcYPFqCMO9UB58qy7eE59hzmJlfaYc2hagAnGLmf6ipPB9CLld1HLAuZxs7P8xz1WBSSqViuAL5FnrwVXbzQH8AeCXtOt/2QpBcj458k2fTFx3Nu6hUnteRGDgYQVLYuTGCad+CRHZAsOQ7cJqnoj41Z29mcj1lq5t2EhIzI/0HNc9JWLZ8Rfg6XvqZseU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026, Andi Shyti <andi.shyti@kernel.org> wrote:
> Hi Dmitry,
>
> On Wed, Oct 28, 2026 at 08:19:44AM +0000, Dmitry Ilvokhin wrote:
>> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
>> nonnull") added the macro __nonnull_args() to wrap raw compiler
>> attribute.
>> 
>> Replace __attribute__((nonnull)) with __nonnull_args() to standardize
>> nonnull attribute usage across the tree and keep the attribute's quirks
>> in one place rather than open-coded at every call site.
>> 
>> Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
>> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Pushed this patch to drm-intel-next, thanks for the patch and review.

BR,
Jani.


-- 
Jani Nikula, Intel

