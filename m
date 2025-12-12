Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC4BD49236
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 15:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1056B0005; Fri, 12 Dec 2025 10:10:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5989C6B0007; Fri, 12 Dec 2025 10:10:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5696B0008; Fri, 12 Dec 2025 10:10:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9806B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:10:07 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B53CF88237
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 15:10:06 +0000 (UTC)
X-FDA: 84211154412.09.B252107
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf27.hostedemail.com (Postfix) with ESMTP id 112664000F
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 15:10:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CEwVI4pB;
	spf=pass (imf27.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765552204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VKDfy+K1GgUhNW5FkCqib+stquGwqC7Rcl/vg0Asqw=;
	b=LpOuZFP/pbF8slSvYdDg1f093w+l59zci6auImkIZRBwdfQLcE/X7VcAcOBfqI6N4T12eg
	+AkvWljqvc2UEVNfmvSbO1O1HNiU+tPrXmJVdYYNE3G0UbRxoNsXRYiLgSc13V063lTR6X
	yLMw+eH1h2+iISoRS7ONqYAwULTt22M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CEwVI4pB;
	spf=pass (imf27.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765552204; a=rsa-sha256;
	cv=none;
	b=dfgqxwA8S2aR5A24m8l3iD6i02rEqnq6QcjlhoaEYuAGEfYnrJDy9qb4J9aMCBFL248Dkr
	fhDo5XUyjpgqrO4OdzPQ4s+UfZ3ANQK3gvIDhbWGHqp65iXHE2O42I0WE9rrx1/fcRattQ
	Bn8lwsPzcMDJvXY1ZslQIZsPgRZtnZY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765552204; x=1797088204;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/PV0STkfCTyJm8MYDNV3QyZprEtTCeBMOcB7Z0OOTeA=;
  b=CEwVI4pBP+VPsvXgENewHst00y0dU4/3m3LWqmM+DxbUTK5mC6ZQgcxa
   QRHmhBIlqJAC4TvzWYrcjOshtZ5iD/ZQ3UMAAmouNkE/s62Ii7rSuHE8J
   o1tpGAOwcsAfO8+QD5Y9Ns+ojvO7FYlCY3W1PPH0+UZo2gWmIaAvmTFDK
   2gujwIfCaamvAu/5Q3IOHQECsw4fMuthb+o+OveNsc2UWFZY8iGirGJpc
   42jfxBe8hMrk6bc6L1bbJvIY5O7bNeki66man88iWYh/gBRNniiiUdGPw
   flGRDtI3qd5AXG8XyGX/AW5Ce958LBkYgHTY2DqYK067mxF9k4r4Qws48
   A==;
X-CSE-ConnectionGUID: mguxnWzTRn+W6KZGg/wyfg==
X-CSE-MsgGUID: Ab+t1nJxQ/Kp/AKdbtwkfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="67430971"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="67430971"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 07:10:02 -0800
X-CSE-ConnectionGUID: RL4aPco+TpyRA01jwc33Yw==
X-CSE-MsgGUID: w9WQhZahTXmmhDgvv8vikQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="197380979"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.181])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 07:09:55 -0800
Date: Fri, 12 Dec 2025 17:09:52 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com,
	andreyknvl@gmail.com, andy@kernel.org, andy.shevchenko@gmail.com,
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com,
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com, da.gomez@kernel.org, julia.lawall@inria.fr
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
Message-ID: <aTwwQLc0HjR_GbTY@smile.fi.intel.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <aTvLyFsE55MR0kHo@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTvLyFsE55MR0kHo@bombadil.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 112664000F
X-Stat-Signature: ifcphmk3ejriwzppnixzqr8pwet9r45y
X-HE-Tag: 1765552203-950779
X-HE-Meta: U2FsdGVkX18pNaLgmZzSRpduurzcq1F7AkWGqXSVYt6gcF7WOwk94yPrwLYzE3mAfrGOlh5ibLGg0Y9+v+YQcJxw/7WcRk0m7eVJvOytsAOlEdw73Vayk4sRFH493Syb9V7xTAbvM+jjO981HzNeGhbt2dHO3DbtwvaqzZpz8PmHm17t4I9IY7x/TDRWlxaan6SCjVkivKZnRc7QsBJMD5skE7pVDKDdYta7+P6/9j54wDMHCxzU5gUlUMFbsJQI0JZNedJsGAyv90JFrYLHfkE2qKd4KzSMZAFdmTXGVgi0ESBYCxYfdBtZOHiy0AFUdAJoFA5SdW7L4mmfjO7ZqHyQ8c9vy0LrP5J1xPk24bPZMhrqSrgFDEIMByjHIp7iFNM/cvHYH1HlTlJrGhpWvTaBj1wJS9s1BWYZyLYJS80281R+Zx2hDd40vKOA5R7FZ6Q7WCnIYIknGlBSD+uuDr0lIfVQKkn0LdqB/XPws+hfja4rO23y8q2hs5aO6UGI5IsI6IxajyxYGb17WmrnqTKPIkzSZqTJWi8j03a8OTon/bl75bssfM9WH58ZP5ikblR3CanKq7ovMYEu2UI4VL1YSYjilXw3Lym5NYCFXe2Vm7hSgrVRdPyd6i3t1VCHmIcoNPeOFIFQEOizUeR8EDAj9U7+CY5GPIXcCx+NQGxARCBrUD1bO1Wn4BxFvjVzbYS75X4kysPl8PPritgG85655iH1FLMzzkL3DfLn1hC4lo0AmSwy15n9byW2l5BYoQxGzBpWwmnOVN41uNxt37aJ39E8KlAaPqcr4KCcuOlBbfUk0lTOkzjTbQyJWOhW5uvjAOMfJYZvnSUdJiLsDnPkPn9l1aMaTGxIpqus5rjOLtsVasRJjRudXTqsxzEQA0mxM2oEZ1l6C9cdDwhVL1B1HHuxAPCUh6fLmjdJAsqVQDzVlnHHfFOXxodyxH42b5WIob12cYoDtxxCQ6N
 MkfwZ/Wn
 fLH/RvGHfoHNfn7bvQg9RdMqKcDAfTPcCuhJxMVnCzuk/x/8WY3ZML3U7Pq1vvGVQfubm4j0I0CgM5DSqyGRCYkD5ntdvDd3X0PQ2G1OgU9h+eqJ8x51EAONVuTlhxeniVm6vyzt2AztBbUp0XAcZY4Mcu6Q/DVPDtTGUhbbnKnwi/nsImyCrLfDhEMeS5nVOdpknn50MjFPs8QEkmVaSCAJxP0utEOeBjZreWWPlugbNkZtUTLaPLwPjIRGdWUBSpDyWRnb83mJ6LxSxq3FEf9uHHuml/5zrkuIWO8Qq+Hc2ZpUf+z0qB9zjwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 12:01:12AM -0800, Luis Chamberlain wrote:
> On Thu, Dec 04, 2025 at 03:12:39PM +0100, Ethan Graham wrote:
> > This patch series introduces KFuzzTest, a lightweight framework for
> > creating in-kernel fuzz targets for internal kernel functions.
> 
> As discussed just now at LPC, I suspected we could simplify this with
> Cocccinelle. The below patch applies on top of this series to prove
> that and lets us scale out fuzzing targets with Coccinelle.

That's nice! Much better than having tons of files being developed and
stitched in Makefile:s.

-- 
With Best Regards,
Andy Shevchenko



