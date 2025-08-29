Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428D7CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 12:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DA68E000C; Fri, 29 Aug 2025 08:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DF08E0001; Fri, 29 Aug 2025 08:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FCA98E000C; Fri, 29 Aug 2025 08:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2C88E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:18:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02EB0140705
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:18:55 +0000 (UTC)
X-FDA: 83829699072.28.F6AA0C7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C1C020002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:18:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IgB+14uY;
	spf=pass (imf03.hostedemail.com: domain of jani.nikula@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756469934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkTpztyu5K0pji7lFFHFbR3zLFIlVYGSxPUV/Ti6gpY=;
	b=EUzqVEljvTC0eqmR1vtEekQ0+uCcy3e9794GJR/J9d8uhRDrq4ejzEf6+PzStM9cB2e/8y
	wfXAWpLEn86z0H9sEPNPxKNo+IvudO8R8q5hX49lDOKLOZTNJn1AaDCVP2gMHIei6IdpVH
	Htvm6X83uNEHiZqZXWUOcjdBQj1I68Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IgB+14uY;
	spf=pass (imf03.hostedemail.com: domain of jani.nikula@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=jani.nikula@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756469934; a=rsa-sha256;
	cv=none;
	b=qdTW1zcR1Q//t9q/fBbwQ+invRgl+jzNCTF7h+DIXMdAJBoZlq70IgG5oSteKng/ruGR9m
	eGUhfpF0RoMNf7RduDYROZzgx8MvoppUADzhhdOpalfICo20x9bBlORT2M+oIFUyaKYBq0
	yQD67d+xiOdqzQtAZHid/j2HwJE0z8Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756469934; x=1788005934;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=lmOaDJrWsALHNdIkFkPEn+1/tHhvy8ASz+0CpcTOxMQ=;
  b=IgB+14uYP4tZN+czHEnQpRSK6P+o4VapnrSuSBxeH31w2BWKJWrjJVBl
   xl2hJJXj9Tf7brn4/+q1FzF/WL39oxxUqPtrnRwaOts73UkPENPJ/fpSJ
   Q8BauYujvXapbi997BVNTlT/Yjsxfycx1KFVzbplWEj7kj30ErHshRktY
   +rFn0uKz2AV7N/XQcJFBgvVhSWfXyBqXxA7aE5cz3oK7YhMV2LQcsGLMJ
   wy4AgcqjVbQKrbovsaKnxpoggT9h+qyhkl+SYuGgEUd+C/ZSnCZ+UG4qP
   UoW2gFOBtM/3r/Sau4Lh+pqm9xvtY9Xmr2Lzjf/R3iDXjQ89p+Bp8z3XK
   g==;
X-CSE-ConnectionGUID: 69LGFw4oRBSLfgkKbLfLdA==
X-CSE-MsgGUID: ZCP3ubo2RriGy5dDr0fmGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58603837"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58603837"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 05:18:51 -0700
X-CSE-ConnectionGUID: FceyOGKfTMK8J/ArNXLz6w==
X-CSE-MsgGUID: nahg4MG6QSGDgmwgF/j0Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170753940"
Received: from hrotuna-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.246.58])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 05:18:22 -0700
From: Jani Nikula <jani.nikula@intel.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Documentation
 <linux-doc@vger.kernel.org>, Linux DAMON <damon@lists.linux.dev>, Linux
 Memory Management List <linux-mm@kvack.org>, Linux Power Management
 <linux-pm@vger.kernel.org>, Linux Block Devices
 <linux-block@vger.kernel.org>, Linux BPF <bpf@vger.kernel.org>, Linux
 Kernel Workflows <workflows@vger.kernel.org>, Linux KASAN
 <kasan-dev@googlegroups.com>, Linux Devicetree
 <devicetree@vger.kernel.org>, Linux fsverity <fsverity@lists.linux.dev>,
 Linux MTD <linux-mtd@lists.infradead.org>, Linux DRI Development
 <dri-devel@lists.freedesktop.org>, Linux Kernel Build System
 <linux-lbuild@vger.kernel.org>, Linux Networking <netdev@vger.kernel.org>,
 Linux Sound <linux-sound@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Jonathan Corbet <corbet@lwn.net>, SeongJae Park <sj@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy"
 <gautham.shenoy@amd.com>, Mario Limonciello <mario.limonciello@amd.com>,
 Perry Yuan <perry.yuan@amd.com>, Jens Axboe <axboe@kernel.dk>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, John Fastabend
 <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, Jiri Olsa
 <jolsa@kernel.org>, Dwaipayan Ray <dwaipayanray1@gmail.com>, Lukas Bulwahn
 <lukas.bulwahn@gmail.com>, Joe Perches <joe@perches.com>, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey
 Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Rob Herring
 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Eric Biggers <ebiggers@kernel.org>, tytso@mit.edu,
 Richard Weinberger <richard@nod.at>, Zhihao Cheng
 <chengzhihao1@huawei.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Nathan Chancellor <nathan@kernel.org>, Nicolas
 Schier <nicolas.schier@linux.dev>, Ingo Molnar <mingo@redhat.com>, Will
 Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Waiman Long
 <longman@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Shay Agroskin
 <shayagr@amazon.com>, Arthur Kiyanovski <akiyano@amazon.com>, David
 Arinzon <darinzon@amazon.com>, Saeed Bishara <saeedb@amazon.com>, Andrew
 Lunn <andrew@lunn.ch>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown
 <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, Alexandru Ciobotaru <alcioa@amazon.com>, The AWS Nitro
 Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, Jesper Dangaard
 Brouer <hawk@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>, Laurent
 Pinchart <laurent.pinchart@ideasonboard.com>, Steve French
 <stfrench@microsoft.com>, Meetakshi Setiya <msetiya@microsoft.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, Thomas
 =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>, Masahiro Yamada
 <masahiroy@kernel.org>
Subject: Re: [PATCH 00/14] Internalize www.kernel.org/doc cross-reference
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20250829075524.45635-1-bagasdotme@gmail.com>
Date: Fri, 29 Aug 2025 15:18:20 +0300
Message-ID: <437912a24e94673c2355a2b7b50c3c4b6f68fcc6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C1C020002
X-Stat-Signature: 8o35awr69qs56r534f5bixqdzs84r8md
X-Rspam-User: 
X-HE-Tag: 1756469933-738267
X-HE-Meta: U2FsdGVkX19cWGNprIC5aJrsgiIrqA3/fMyiW5hKA/QeJikXeoMRhk54GHAjQON8YjOV+JgjrKD04+vjxiJqSvVSFeTzU8+Hg3ICMbI5kKKY4sR3i28tzOj6G5LTCbxo/VaM3i0t2uJmN+joew0qgUwOLqHUeRqdvHpuaTklOzRHAQM/Ms5GDVLFC67HXjUWnLTi9J3YbQVpL/+3GBo6ycAsoY25VA17cWoOBlEUd9Iwh0+rkcz2VfZpp59Iw5FTVV+BRQF6n7EDsLEpjbGuPWL74Nzn2h04Fko+vJetPqmLxBpSoS3gOwRlegNu2pHQrktTVYqjNnakHypHRr/t5GwXRC0rAGfN/4HgBGZH4BW1ACiv1OpTZNw4kSpUXSkUBQuiThzv2+8qylsBvimMeHDeaoupzFHTrweTPLGaqZvHtMiWAMz/nyTY9AgOLLBEOs7ZQ6PNe9+7ISrWbSjTWldojmckZGhuzxDgeBFjMpkEMN+GEeL0fyIezgDTHDhu0F3TvahnTFnsy+zipauPYACGn54LlWBCVT3y3mQ9bk1+i/TwgUXxxo+VxEqYss8SSwXs4GLL2Dyegs9VlJzSW1qiz73f9CYUTy8PPYqidHIriKqH022IXLoOUseMKy2L0NZfrZOp54k6oZISGlbiIzBBDqPACa0YnfgPIO3XJI5/5Ino0lhouWaOX65HpCewF19OVnBEAlC2JUUkvk4dEtSJrCt61vVPsk0llFRlLXNifA8/Xrw8ujDtcWt3vfIQFFrAsXL5xtHT24JYXCh5b9LnvMzKw/cRQohzNxVtXSHJ3nqIcmxAJmGxKraGE26adb/Jx7j6WiZi8K28If67WXFMTcuEbRiEEtKuaDUHp3gc+9n3wF8BEjXsJYdrnukcyKSp30+EWwIvLR5YJPPdu3SZQ+0aJF7HKfmjiau7tpzXDjs18Rp4Ko27up0R+ZUh8JV+TjAGE6XFFA4lmrA
 /5lwyLac
 IoheYTGlYySoJiCfVfA4vKHFIfZZwzQ5sCXCM97RWCHrIU5KUSVUOl0mRwjhjkv4QAuIVGhz2VOsCFHrBeaSqV1hrpKzpijGy5OAueTUI0xNWyFPYqn45X15GnVRAlJNVxiEgslRQK0fjo+KLOjpyOWIA2pQmL6L/JpzZolass7MbqoMwi69rKP1DwghDt0tDJklQHE3YpQh1M3psNvsDT9ZPpEFcprWOtvFg8HzHwAlU15O0LY093eeca7m9jRKvim3iGxFrRjfzGGCTwxqbvJolkV1LsnrNjQA5x0aHKK288cGpy4W9al6JC443ChN+hTUT6FzVhDKcD9o9T2mxQYZ4M3Pa0PGPpxL36/fJ4bJNBqE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 Aug 2025, Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> Cross-references to other docs (so-called internal links) are typically
> done following Documentation/doc-guide/sphinx.rst: either simply
> write the target docs (preferred) or use :doc: or :ref: reST directives
> (for use-cases like having anchor text or cross-referencing sections).
> In some places, however, links to https://www.kernel.org/doc
> are used instead (outgoing, external links), owing inconsistency as
> these requires Internet connection only to see docs that otherwise
> can be accessed locally (after building with ``make htmldocs``).
>
> Convert such external links to internal links. Note that this does not
> cover docs.kernel.org links nor touching Documentation/tools (as
> docs containing external links are in manpages).

FWIW, I'd much prefer using :ref: on rst anchors (that automatically
pick the link text from the target heading) instead of manually adding
link texts and file references.

i.e.

.. _some_target:

Heading After Some Target
=========================

See :ref:`some_target`.

Will generate "See Heading After Some Target".


BR,
Jani.


-- 
Jani Nikula, Intel

