Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C499CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4BD8E000B; Tue,  2 Sep 2025 09:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555AF8E0001; Tue,  2 Sep 2025 09:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444AE8E000B; Tue,  2 Sep 2025 09:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA7F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:50:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2CC1841A5
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:50:40 +0000 (UTC)
X-FDA: 83844445440.08.1E8ADE2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4A5E0120009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:50:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eRgAjFqj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756821038; a=rsa-sha256;
	cv=none;
	b=1B2+okmyK8j8jRYjQCgrNZ2j31bR0uLsic5BJC+KoAX7fuznoei91Mln7+vIb8wsHBKGeg
	mY6gCO/UHTTW4K2efeJHLX767Id+q4UUSQaOZ5s4JvJaosStv3/pfI0LQteGbWnm7MlPsa
	ZYwUFtr7u86pnjSQ9VExbZysElFFvZY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eRgAjFqj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756821038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRQ10qRNRmzAf6GZKpqv2GmmEnSMmDjPlw/asGr06Ss=;
	b=oSlaniZELNAPqK76q3dUnNsjDKsq+UvHAWCqRqVBoMsoaE+GfvhPZZsFYfBY2c6oia7xEg
	JfNeUgdulWdqk+0A+4DPmg8io2s8w6rKfEpAuVl9ncDHUm8wnwFi5sENCNhcRaxJv6edFc
	C0TpR3pWupdDE4vfvNWFXblGRdijI8E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756821038; x=1788357038;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=pxx41/VBJwEQCpU5u+vMOlc6AdRXauTq/XBO/2b9BuM=;
  b=eRgAjFqjrvlk3rcCDhqI43ucdTkT/uOXlKMyRfYBSbsfxy7wKMiCYiU4
   rRH6X5fWqrUvQSc6tyv0mZhHxPGjPLVLZd7iowQYgLqC/PPwXDi96UHQq
   YmUA38gVUu5waT7H/8HpHvB+aNzX2xavUHd+ObEBZ5pAr5HSyu6IFqK7r
   yUi14fqD5BlqhnklO+lBigcehHsn7YXZq5Z9jUfQTAD2E9WG0LpQLQ3ux
   YfGbn4A6wfw5RGN1VMFlIZENAfKJVXzk1aYUWI/RL241J93Xd/2787EVi
   3jDjd3EH8nZj1WCowwDa5vwdFubZEtufUfinT7tF+1aLKLnbXTCp8MXBG
   g==;
X-CSE-ConnectionGUID: fEpgnxsfQvaZy/AfysZd4w==
X-CSE-MsgGUID: tsD9VZziQbCmxBFO9h3dwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="62738126"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="62738126"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:50:37 -0700
X-CSE-ConnectionGUID: ZHIE/dHOSB+FAZRCRRCs4Q==
X-CSE-MsgGUID: 2IiLBKTERdG7VU87j86+iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="176590815"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:50:25 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1utROu-0000000AhyY-2NM3;
	Tue, 02 Sep 2025 16:50:20 +0300
Date: Tue, 2 Sep 2025 16:50:20 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sean Wang <sean.wang@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dong Aisheng <aisheng.dong@nxp.com>,
	Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
	Jacky Bai <ping.bai@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	NXP S32 Linux Team <s32@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	imx@lists.linux.dev, linux-omap@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v7 01/16] pinctrl: check the return value of
 pinmux_ops::get_function_name()
Message-ID: <aLb2HH5zgxdbDiPo@smile.fi.intel.com>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-1-bb091daedc52@linaro.org>
 <aLbrz5DYS5Yxx_UE@smile.fi.intel.com>
 <CAMRc=Mfx5czDM=vfEYhFtVO3MviYaW4wKBYjGZ9ZnMbr-+T4mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=Mfx5czDM=vfEYhFtVO3MviYaW4wKBYjGZ9ZnMbr-+T4mg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A5E0120009
X-Stat-Signature: ugchmyox7upcxd9tujqqm4jo6ygcm5j4
X-HE-Tag: 1756821038-579470
X-HE-Meta: U2FsdGVkX18RfoAk4eNY2RtHGbd56mBBO/jNuar0FpjS1QC7sppBrceGvKZjEw+HEhhS9sOvnMPBC6jkmaoIfb50CDghtR1z34H83eB1NW60DbDaaaDyOIEFxHqQ4hO6/KRmYaiix5KbiP4ce8xcVhYOZtxE1ThZB3Y/oDBgAOqVdQ8h5FKjOYAil6QSNOp4ne53ThOGiJje+oNZlUb10wE4FN4hZmVZ1/6GFK1B5Y7ZhKJ8+w9I0lsiSUEWuiX9sMvRIvWcO3eKtqFBhOVZRh8B2zRrN51+nOXNuxdBVlwqvjfEeIEBUqH6P3dS9M8/o/ILbzpPm/gkZ8tMLh24jpLv7PsL0/ODcgdKUd8w1OX38ADl5FlJVXc7OD/aCZ5CdLwEhAF7PpwGUuwXTjdplpHNdPoFSOXgzRDKpVqziITLX5HNNv+um2j0ChXJ+pPiDqkdACDb5JIAtnxShv/B+B0nTaf49QYZ+b3OqJLWuUoI4NbZwkHj5EKvNuSpU17hYZIPDlKbqgWk1rVUhbWlA6RHDFm1LxH28PLPriue+SaMDPmNF4SKyQzfdvIAfW9Azn4IXjxnJkAEwCoaRIEYjzn2kpRbd8DliCX345hzyUh+nYzm6iNXRS2ZTL67wSWRzuAZOqJZS+7SDCFs/Gc1cFxlcEWJbRoAWxBPaudXD3ppGUEq+YFj872Sig3xuhYY620Ua4qrWQLSrOoCiS0orziFWQk+Qg+7KT1vuljomCEl5SNoE9Y9+ltOcIknESG7yDDTv1vxu4BbFaiFQok7XqmWWN3JPYOsf7oaTNoVLlT4YbCB/ppsShPNhU65dnFdGl8DPsM55EdnxOdaLocoi8H667YKsNBZQGafZ2CV/xTrqOnXOF0Hss91xT5QodWCZoBelswZfiJhRiDc+18MzXIEna8sZD2JlJYHIau7wCT7GohNFnakcQJCazYRAiflpstmuOmFc3XWJ/R/3Tv
 hSP4M/zO
 Z8i6WV4sC7mtGfujp/K+B7BQIX1J6q3rrE+XtFYcj0EXfc1pVqr3Jw50zqSAWk+6/flTZSVe1pmSz+QKea5QoPQallGu/KBi4D4IfEJqhvml8ON8bBZsc30MdG84ZHev3ndUxbaifB5DyKcXCBDXF7IPF3TMD5HQmURtA2V9CrerJFRi5xQ0rHbaHF6WY6PEmq8ARpXyAM4ITQJLX5wMFABYtqQ+dUHfvhl/G7GC0FH6k/JifJnuJcIVILZn1+V6a+Npn9coutcdu5W3c0woKNBOVWt/zZNctc6Tmj9Y8n7dsKl5LGEbFuTmUDCosTPqQub33NL8QwAGxXVmdb5UYvmTtBdI+22TB0bsBYZg2ceEzd6ICIsyaz/OkF7KPLRLDk0NaTBe3cbGBm7M+6zx9U16EpsJD1jH6fWFa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 03:29:31PM +0200, Bartosz Golaszewski wrote:
> On Tue, Sep 2, 2025 at 3:06 PM Andy Shevchenko
> <andriy.shevchenko@intel.com> wrote:
> > On Tue, Sep 02, 2025 at 01:59:10PM +0200, Bartosz Golaszewski wrote:
> > >
> > > While the API contract in docs doesn't specify it explicitly,
> >
> > So, why not to amend the doc at the same time?
> 
> Because this series is already big as is. That would be another commit
> that can be separate.

I meant _in the same_ patch.

> > > the generic implementation of the get_function_name() callback from struct
> > > pinmux_ops - pinmux_generic_get_function_name() - can fail and return
> > > NULL. This is already checked in pinmux_check_ops() so add a similar
> > > check in pinmux_func_name_to_selector() instead of passing the returned
> > > pointer right down to strcmp() where the NULL can get dereferenced. This
> > > is normal operation when adding new pinfunctions.

> > Fixes?
> 
> This has always been like that.
> 
> > Reported?
> 
> I mean, technically Mark Brown reported my previous patch failing but
> I don't think we do this if we're still within the same series just
> another iteration?
> 
> > Closes?
> 
> Ditto.

I meant that this fixes a potential issue disregard to your series, right?

...

> > >       while (selector < nfuncs) {
> > >               const char *fname = ops->get_function_name(pctldev, selector);
> > >
> > > -             if (!strcmp(function, fname))
> > > +             if (fname && !strcmp(function, fname))
> > >                       return selector;
> >
> > I would slightly refactor this:
> >
> >                 const char *fname;
> >
> >                 fname = ops->get_function_name(pctldev, selector);
> >                 if (fname && !strcmp(function, fname))
> >                         return selector;
> >
> > >               selector++;
> >
> 
> You can do this in a subsequent patch, I prefer a smaller diff personally.

Sure.

-- 
With Best Regards,
Andy Shevchenko



