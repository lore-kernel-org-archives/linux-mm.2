Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C56CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0106B008C; Mon, 18 May 2026 02:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7EF6B0092; Mon, 18 May 2026 02:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBDF36B0093; Mon, 18 May 2026 02:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACE066B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:48:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4720991AC8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:48:44 +0000 (UTC)
X-FDA: 84779612568.18.21B9D05
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E04F2000F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:48:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PON0prUw;
	spf=pass (imf03.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PoiDoK8M6j6FsedFAWDKtIpLcH7JcI7+8jnu9DTvP0M=;
	b=nIPQoHge+XRDfO4yzmPl406YSx6lgQI7sPjPutiqvFkQqhYhDrqzqBvwEI+Jy+MJWYebAk
	l+QxQK7fd0DGzszO6cGxDX55UOtGs8TyxYDnxskUTOHEV8aguCijIxrDaT0WgpmHxIDgKg
	Jz5LS40eyG3lA2qqVoIDP19XoOcxJNE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086922; a=rsa-sha256;
	cv=none;
	b=HQ88l8weHhnIKfTyY4LVY30agNTU2uTDGkI0BCwaxIun8TdacBZtLCbAUiOG+VgAwjhqgz
	zJRPV6veafGnyjR/Qccr/9JnA+KXhDWeyG4FoEh9agozqoqtlU8noCaM0L5GCMrsH/sBRx
	KKIYHyVLNCdt4P24+AO87o6/kGgkqIs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PON0prUw;
	spf=pass (imf03.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779086921; x=1810622921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=68oh7MoDXG2jiewSSJwZIj2wCYdOD9gbvXhDJNYTEAE=;
  b=PON0prUwoKRL5lWbH1lEmGRfCmOVNZJM5+fCcY+RJWG4RYifqfhY99Wg
   KKs3MN9v9FVdxF6aT1A1xSuMwUDjc3O/rbpsuuU/38zOuuOhgGRHTnCkC
   x3NOe1yuyMN8l7+GOpDnuQonMlK7feBnhdEIYvBbuOfuqODCqu30im6ki
   QlLpMaS+/ftJe8l7tzaPmpGpk2z5xHh2molZ7LHlPE4ivfx5ZoZygVbq0
   QZ2iwmp9YtpH98iUPPeu9QbGTVbUlPBIGcylpJcCadh/NcLqhN3U0VW+o
   /rzuTJpIjEYThWBFXcyyd3tqWG4o2PNgMeQyVhG/f4Pbm/HrQaBowJlwp
   A==;
X-CSE-ConnectionGUID: vYu53CS3T16KRftyLZtOZw==
X-CSE-MsgGUID: LFLed6EnTq6ribRWq2nErQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11789"; a="67460906"
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="67460906"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 23:48:38 -0700
X-CSE-ConnectionGUID: Vwjz4fVGTpCw3EyTdoxdBg==
X-CSE-MsgGUID: 3UJUEIaVT7+plwBYSj214A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="244318315"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO localhost) ([10.245.244.3])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 23:48:35 -0700
Date: Mon, 18 May 2026 09:48:32 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
Message-ID: <agq2QNwd0n6OK6fN@ashevche-desk.local>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
 <20260517123428.1181981-5-thorsten.blum@linux.dev>
 <agnehRPd6SeoO9ie@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agnehRPd6SeoO9ie@yury>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E04F2000F
X-Rspam-User: 
X-Stat-Signature: iypwr8nckwxqm5psygw1na5m1hu14zdt
X-HE-Tag: 1779086920-424952
X-HE-Meta: U2FsdGVkX1/naQh5ZzlEWBdL2U2lD4d87QNDTHLloghIyQ6LQ3swgMsuKGCgo5lEPMF6eIqk7AIjabPPwo/41G9fzWRdle9emGcbHE7cAq5Ut8ZMSY5Jet7SlOgl0DdO0HjOgYihE4gWdGrrBMfdX0muvd3TSP69Me7J4dGDPK6HCZ5wacvLTavj+JaOZUO4fkciTBazdJALKK903bn1TfTadM5+CAzuuZfX9+YgM9UaGWLCNmlY9fIzzBQI6d6tCwGhODFoB0c0UP1GUnhctEamrxPJPSWP43CxeFLNOL4JsjroV7SnfcZ4WADfLWc2a3EDLT+a0Z7NJfgnIQ46XcKYfqLbuLS+i0mwIy3d9T0HuO+prAGmqcGiqjXAMqk2sZIN7M9NcP6Nq8aMXD3DkYFiPFeLUwNiAhAc8DumXWUD9ZTblQMqtEIhuyCYLYbdLPgWc6cmW8CVoMNEkTlwgTfKzguyhqbGxtPslkfVgSkIN/5ZlWksnddC+Jn3Lx1F5BeqQ3t8ZQX0XZsfIrGkdAyYBK+jE6yr1iZDEl7d6ZjxgjeySZJ5vWNMyQlDr5ausgEsmBH7m8v+9CKGATH0QhK2QKAliEUpukAo1Q6BNkL5816zyzy88itnqytQpfcpzCMpf1KmFh3mh63QM7xDDQ7ChObLOaJVf/YQqIUpMEokC6RQoell+Y6IY8g+wMnj0pm0gONcA/HbD0SNQPrbHwKxCFScrxf1mItQbCHraKHC3rKKd+9N/RrRCG5yRf7NRFAaq2QyAPA9zoINug4YuZD1q6JifAXFB5YYEvDcHTk/RjGxobxkvtfhtCos7V1Att5lK6Jy4xVXYuO0DTegqQ7/GTCXeyfG59TOjBFT25JJne34kQ8CSKPqkABXZckynXpVv1aBzM9Q8CEir0cb7mWqrCct+lGSoeDJofmPHBkKZQiRpk7b63Jd1PsTsfkgsj1qt2GMwVp4wvhnBMQ
 r1HoUe1u
 eMudrra2bjdfNosOwcsQc1I7zFnes0sgBRGuK2oD0g1nNeYfjjyor++ZhHlBbIjsj1NtZt/WcDyTw/UAcZCVWCaxh7mMXd4dUqFpSSfn6R5zX1+R2zcosd4eiMQluP9ioPdl6Kp/7m0dPQnG4j99UyptoJ9hRsGABzcGe3jKZcA21PMdssKn13zmxcSHjdSJthyiRcuCCOrBmoAXgwCtkk5GZvwGoE7Si8/DXiTjOxLDG4LM8fuKont0mP6G/cYb5vfwd7VzHDJ2yFD3NgaoEdDNKzAXijwnGrcjvS3tus+EwqRLgGrYmdn3DwG1yjIwLUBbuLOFmy7lIoVJN1TmZKYdtfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 11:28:05AM -0400, Yury Norov wrote:
> On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:

...

> I've got a series for this
> 
> https://lore.kernel.org/all/20260303182845.250bb2de@kernel.org/
> 
> The feedback is surprisingly negative. Please add people from that
> thread. Maybe you'll be more successful convincing them.

We always can simply fork, but I truly do not understand the pushback.
These are simple macros that are way spread in the kernel, "include everything"
kinda linux/mm.h is not needed in vast majority of the users, hence the
split is logical step.

I'm in favour of this series.

-- 
With Best Regards,
Andy Shevchenko



