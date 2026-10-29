Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E968606A336
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aV7gYEOU
Received: by kanga.kvack.org (Postfix)
	id 57F3D6B05B3; Thu, 29 Oct 2026 09:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FDB6B05B4; Thu, 29 Oct 2026 09:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4460A6B05B6; Thu, 29 Oct 2026 09:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 289506B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:21:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD948C03CF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:21:30 +0000 (UTC)
X-FDA: 85375725540.04.BD3D1F1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5F8BE40005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:21:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aV7gYEOU;
	spf=pass (imf01.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793280088;
	b=ZDnXUi6UMO/xP+XBYNs2Yk3Atv6Jga26z9Sn584QOSiOJcfaVkAwaBcgwGlLsbYPFqHPRP
	uDZc6YXyAIn2ue0khE2HYGqcGC264vqoMahJDNOjN1b/HU2UzxO7LwgDuEBGWfdrz43n46
	DcsVrZX059MrN/N9YYiWYtZWrJELs/E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aV7gYEOU;
	spf=pass (imf01.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793280088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdAws15E4boPyFwiZCIHuT2z7R3eozeBP3yjVNgMrMs=;
	b=qIHaX6BwlOEjBK/ELVJUYnFikyW6HGnInPZohgeW1e7u4pKbsARCqCWe+pSqgZ9d2KwPHU
	kSVX3B/k6Osgpwhqy342QxzaPMeJzC2GTO6QFLB0lzH6V0pzQCCD+c1yAPQlia2YbwRz1r
	xRr/I0vi0Rk9yasYzh+wR5CG92XbrW0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793280088; x=1824816088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=tkpV40hGhO5XeSgRXjpBId5i/GBz5co0mYtfaR2uPHc=;
  b=aV7gYEOUjKeV0sRDNXLo9QthErZL/1BlOtqNyz7zsOLoWiusVBHXLD0K
   iy7cxVZ26bIeOQjZhJMz2Xi3zkllHsXNOil7qAm6wKCWe2AYkI64SMYc+
   1ZpN1roAzpEiKTpJcXIvosT8cNhs34oIrH1rD2isCPFqyHQxlmzNJXX/s
   wa5CCiWbqGQ0d4jtPjXNUdyDjRDH9B4zvYuE/CvYy8re0l5FvXpBXcGwK
   RvoFQIyso41xTT+lPnt3JgGcdoLrWLI4x6jD65Ebj/gJmS5vp8I/rfrlh
   AHnntYfgj/J1kAD86QQfd/WZT9G/pygWb5zdAPUuHH6uWalKAU8R+XL6W
   w==;
X-CSE-ConnectionGUID: CCOOnSVvTZGn6FkMF3+72w==
X-CSE-MsgGUID: fwkLONllTa6pnaisv9ZtqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1899927"
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="1899927"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 06:21:26 -0700
X-CSE-ConnectionGUID: lcHCQ8oTT4+RWbV1aJm5jw==
X-CSE-MsgGUID: gd6Ro2tCRA6pOUXdfheN3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="5690610"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.129])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 06:21:17 -0700
Date: Thu, 29 Oct 2026 15:21:15 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
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
Message-ID: <auNIS5n2aUD9t7yB@ashevche-desk.local>
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
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Stat-Signature: qmyhapxskwt4srsyuuz96zt8jnp1te9i
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5F8BE40005
X-Rspam-User: 
X-HE-Tag: 1793280087-185235
X-HE-Meta: U2FsdGVkX18yh+nakaE2PZrBCoTE8ci58SmKH8DYHsYwZhbej7G9LtLBWJj9J96WJWKXHPwFSTYUGafZ51ARsBpMa5pznu8QDMOveLp9lXt1MJfU7n4IEgFjbBQYhbJVI8+Hv6wcFtYexLWiTOFrMrUlA2XZD73b4OqBexh8IDwMu7dOdLEh9aWMVu+GHOCPsF9ViOX7pSnnTuWBjhJCVDXzJBfnkYduXw+k7WkL0UTnV5ChXvrxemFXdfktE79kO5+vzxWqvUZsZKokh6u/rDbCnIoGXZT3GDiZeWzrfXqComcnjRcTZoT77vq9fgU3GHmW6HaPtWDvmZoUILO8hMEJch5YpeDbSueCs7R8cAR1L6F+2T1KwPtxBp9WhdVq4H7JTahdxgwxIw1DjZZApdLnw5MnS4rwnbdjn/bsn7LOnY69FSVU7zSRuK1tZw1XIkfsarboSf2q0GDrI9pPiNT15WFf8nHSwEQNm8/+kjR3B61hrCDFsh8UXVmNY3v0sBt4TfyJLJu+D7CFPJgXzrmzSslhVcB2GqumrizS1ZKOsOP/FK65+pM4GVhLGJhpvopNOA7siMU20aSoRTP6Bp88xD3kAFEwcx1llp9lgkXfjIX7l/FmuBrXZcG0VzXNA3DOaWrSh9iUuvAVw/nWUJTYbQQR1TweOVbx/NXsLXiEl9n5yYQ+xuVTipbKNPwip+lOk2QvIv9KUUXgZJBR+JNZU5K36RUDCVAbyqRuYpE+BjI5eEw7RMBzFmNfJSgEwE7zgPPP7phD8BwKj7MnFagNxf8Pmy5f1qPMFku/x0pZE1J8i8XqjPEUlj46FoxgZ9ALQqR6b3TrvR0x8CRKOBFvV6VvbemRN8W9QUQoS/QBXaUs/7b+sNAHiL3F2EXFreuIoWTIyFl7Ic2BKzVyFtYCke2xlyMzG1S6n42P7edMGRvZkIazzRquYp/J6pA4FzpXi2oETE9LaKYFy14
 YtuBZADy
 yl6X7dUK9XR/JRjC1XDIrVmqT22XVtYaXFL6sPk4Eb/KcBhLDZF6OqKdrfo0H1YQpuOLNHTFoxY2S2P8fmLciRzA03r0YXjxdv2phpvwR5RlT5Y4UCXeVT97/iQUvcaMorPFgLjI/noZpsu/o25MDAS6rzBaDz+NoOcYZfKoSjmNtIvqvjJG4bs3ViHHLdXQhPtldxmRX7ueGK6K5Zmhoq9ZbndRZaRNBl8Us7DjH86QhNuS9toL2fXuz8w07SclzayUaTnRMFhbMYhWPRyRtw422QX9mq8yVlMP/DPVEne2hI73EXogI+NknvB3cojuRgjGOhXPhfJhEPnoIhDCxFKo/6gNLXonZkU/mrOLm1g1+QQsxVaSwhYr1+A==
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

Usually it comes to the mere drivers via types.h, in rare cases (usually some
more generic library headers, we do better granularity as it affects the almost
entire kernel. Just double check that types.h is explicitly included.

-- 
With Best Regards,
Andy Shevchenko



