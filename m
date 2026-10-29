Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B14606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bBEfEwp6
Received: by kanga.kvack.org (Postfix)
	id EAADB6B05B5; Thu, 29 Oct 2026 09:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B506B05B6; Thu, 29 Oct 2026 09:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D991E6B05B7; Thu, 29 Oct 2026 09:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE5CE6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:23:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44F8D1603B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:23:25 +0000 (UTC)
X-FDA: 85375730370.05.E221714
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf08.hostedemail.com (Postfix) with ESMTP id ED98F160002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:23:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bBEfEwp6;
	spf=pass (imf08.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793280203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+3Crhy2vTaTH2VP8Hqb2z/w7m3gLKgpAXgDIf/pTwE=;
	b=4JEQgbfTriusg0ib1nkxreEM4WGI2y0PirSGnq4VQ4VP2gEjbDHtm1q5zfAHDfIz/On245
	uDiiA8vl6fErgPPAxOLCK9mnC6A9qe7FtTbNm4CxuaLDbeRuGhW2UjkJCRLVW/1dNjeZ5m
	qQVOBrrfNRuaatUaPvKAuF/AdNMVxZg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793280203;
	b=tYpbkkqaLekPKBujhl+eW1BLRL0dJMryfWaYZdy7uwikwKQ2wJ+UMZ5upECH9Yqlo1CChp
	0TeFsI4IxCrw5/iFyKi9acfZEJefzGvRG4fhvDk06mVQH817I19wA/Z8/ZqQv+I7ANBjhS
	+3q1ayIiWdkCXPR/V2ncQoTVmV4BT58=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bBEfEwp6;
	spf=pass (imf08.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793280204; x=1824816204;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9Cz3qGxvThs0rl/GR84Oy3PnSJHjpp3B9x+qw2O+AJs=;
  b=bBEfEwp62aZRZrXveGnyJhR5uNXDNM+ttjPDSER+SS8N4OsQ3hAqMUhe
   4NP3cFsXfM2pBCXGH9vIjqgamoRG8202LQsL/IUsIOY44tIlSEAdAqlzq
   wcYKc5BBg5XUb/ae8IUJ6D14J03BXPMqlgOCL3PSLrIve2GlkSz2C3j54
   JrP6qPAeZQqvm6ILNmPxHah5vk9Q/Z9NcXIgP3YR7pwM4chVwWR/THJKe
   Tdg6aKCl9w4uudd59pz/AzEnJXsk1CW3pXiCkpuxWoWa18XKZ8MEbkEWz
   zm8AVLmixzRGsZVLzjQJTA57hl8tb5qL8F6JP4++YEUtvGcQJ3Ds2me8o
   g==;
X-CSE-ConnectionGUID: QeA0AwDuQmOXJi+yWdjb3g==
X-CSE-MsgGUID: cTp48nSzSpyvR5etN1VphQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1905326"
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="1905326"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 06:23:22 -0700
X-CSE-ConnectionGUID: sK2vSRAjTAqdx5FXxpCvqg==
X-CSE-MsgGUID: o1lYrOQHRt+E7suodbHRNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="5156292"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.129])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 06:23:14 -0700
Date: Thu, 29 Oct 2026 15:23:11 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
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
Message-ID: <auNIv830Zu_1zWE5@ashevche-desk.local>
References: <cover.1793027261.git.d@ilvokhin.com>
 <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
 <fb3b6a24-74ca-4da8-8593-352afd515313@suse.de>
 <CANiq72mMm75svCqevd8fHtVoczDpvpo4NwL0SC8=bWy030vQuQ@mail.gmail.com>
 <auNGJhSe3tVi7rDy@shell.ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <auNGJhSe3tVi7rDy@shell.ilvokhin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED98F160002
X-Stat-Signature: 45i5688ebtox3hhx8e57xxgnq177a3z9
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793280202-116175
X-HE-Meta: U2FsdGVkX1+kqe811+Odn9pyBvylq0ns7i0Yxpq45TXnlqrraj7nX4/1ANAIGIURkHshMcb+KVnwiF1SHrZ90uUY4Z9hDZA/Idg9c25AavJ7Ruo5/ZcpSJlzIy0PF7f36i7mRkPauizsMT2PM5g9dkyqjbL8WdHlQTvK7CAs8/w4GQAvumGvEu3fPyrY0djG3jD88UJAWK0Y8+4CZfO1f0DOpHSUnG++szumGgDqmBjMVnSpiSPyVOZH11vg0k3yX6PB/rG+bn5GmS5JIO1VR3CucIGxB97FScm+y3e2gaH2fyC6KTMLAZaSoKEssufva7PukMj+TvjGHc/+Onj/EAmZgC6UfDKyprzloSVfmR3InqQYS0tg459bEalJnXMuX4Zq28Ox1PzkTOwHyC+wsujje9Hod+CRR24PmBtYiGF9SRVXbzr5WWkcmvOiR/GExWFzZ9UZmQPixyhU9zuGtQgHGeuzgyKV/1SqUsUg4oI+TivCo5upL01yTB2JnX2rskFu9jKiLmj4rragTA2/C66bQETGQQROm3YgcbERtKroxUjYp+CiTvyj0Cb9HdG1YwnroKeQzKy2wB2W1ZXEQtGdlVZuIE1IBrBnXlhR+lHbs3v6ulnx/HF1gNJ/QgOlfVP8NOrwEsa6DxPuZoYNYj7SlBOinzFVEHqz8b88LA75lkkoKElRF80pJvS9+vg0QkXbvQSPd3PHzyxVrbG/CAFLcWW/2CONMvqRRf39q3v7cvZ4RBwXdiDQ3b22G69tXBFAZQkxceAusudGdP/N8ZvpNHcb7J6OkSNDf5NZ+I/LVeb7jViMK/foQIu5PlwaEabBtrWS5I9bFWb3aidu3N/9WNE5ERl82p9QvJCwTJheM/n0gp/27BK2ulwDKiy4hxbibt/7W57e9mrPClYmOIaIMiK7FZ7mLgBoG8P7Fxpg3wFKrIKpETyWWB61F2SyyOx76WUuL8yQrY/eVgQ
 PUYYGfZW
 By1zlfKS7tzm9Kn6W+IYsck7RnQHK1rN7MIwgyFSSP2U7GXLbmBw+1eV38LbGoY6UlCYkH2KRKPbO+K/jWoHMCi11EuMnAp1BQn+bmU41RHaAbJ0PDyfRU1RwK5su3EamDPP9u7REAs3ypNmcd/mhXzu/iVDMqD8DhwTxQFE1DQ9eRbPcAPMV+CFCpVareIERr2wBSL3OKfYCA98kba0/uXsZ4Y/Ama2VWLVl0v1B9HumtQY/NUxN1x/ZtlmRpxMIPDPx0TPS+3T7iwCTI6OO4nj+t0b8pgD/1FL5239GcqgCARdyb/ZBiXqBJPR+h56+YGwa387aP/TtkGSn0Z/hapctWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 01:12:06PM +0000, Dmitry Ilvokhin wrote:
> On Thu, Oct 29, 2026 at 02:00:28PM +0100, Miguel Ojeda wrote:
> > On Thu, Oct 29, 2026 at 8:32 AM Thomas Zimmermann <tzimmermann@suse.de> wrote:
> > >
> > > Should gem.h now include <linux/compiler_attributes.h> ?
> > 
> > No, it should be included for you (unless you are doing something
> > custom with the compiler flags etc.).
> 
> Just to add a bit more colour to Miguel's reply.
> 
> I believe idea behind include/linux/compiler_attributes.h is to make
> attribute wrappers as simple and transparent to use as native compiler
> attributes. In particular, this means they should be available in every
> kernel compilation unit without any additional effort.
> 
> For this reason, all the nessesary plumbing is handled at the build
> machinery level (see scripts/Makefile.lib:171), where '-include'
> compiler flag is used to pull in include/linux/compiler_types.h, which
> in turn pulls include/linux/compiler_attributes.h.

Ah, TIL! Please, discard my comment then. Perhaps we need to clean up all
headers that pull compiler_types/compile_attributes directly (the same way
we do for kconfig.h).

-- 
With Best Regards,
Andy Shevchenko



