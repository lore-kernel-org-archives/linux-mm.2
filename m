Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37607CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C608E0001; Tue,  2 Sep 2025 12:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4456B002E; Tue,  2 Sep 2025 12:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA858E0001; Tue,  2 Sep 2025 12:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 740AA6B002D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:11:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F2CB160263
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:11:33 +0000 (UTC)
X-FDA: 83844800466.10.65CA97F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5776980013
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:11:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eYSnffI3;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756829491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0csqPNy5u9gD2BwZXPafvbUJKxDhZa9/im48R91h8U=;
	b=RFyrWuIwXmq46W4TuUSBoGvKHyHmmsPNwzdWFaZ+LBhXdsCsHbHNjqyN74dopaczKLOK3C
	Ueu1tRHooKZELM/BMPBcXVttOLN7Ra7cc050xtMGrQ8ht0ogUF2xbXQ6ZJh0xvMA4Wib7K
	+O6Na9yNblD4CPKFOy/r58H71uKmAz8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eYSnffI3;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756829491; a=rsa-sha256;
	cv=none;
	b=HOMS8KEb3ta7oGwvsiaE8CozlX4ocwNr+kkg4lwllOJHlxOYYcMwRe9hJbfC/qki5rYFm3
	CuaHoSFwFOgovFlu1F7x6hnSKIw4d5N9oEtC0S5VTZF4S6rftrEoZnEwiZ6XTX3s3/qbr8
	O5k1FmC2spD5bTUGOgRfJIkpwADfDGQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756829490; x=1788365490;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R0csqPNy5u9gD2BwZXPafvbUJKxDhZa9/im48R91h8U=;
  b=eYSnffI3s1sScmgtZN4eEy1jWeg8scHei69nL/B5xFvR5d+XIjtCTdYk
   jfNX86rC7Wu/1NvtCkRFcpyloUKl+rPQwcEG48Q8JSDEKC53+DxgGsMtL
   EBcsW8RpDQG3D5sBQo+KZnLBNLSn8KyRmP2UhIySVLvoj/o64n1nP6UQn
   vdh5TZT8+bMQAOm81Wj/PsbNnFaLXiJf9iaoWCsehXMIZzr+SSz1wA31Q
   VFalwYocK8fkPQkHwMBNToREvDO2/mQgZRcNOXtNUbPYUYFvAX6eexiOe
   ApM19nrv+FKFF0LFm/JnPxggHJ6o771onUzmDbm2dVfVpj2MBFnqfpcPV
   Q==;
X-CSE-ConnectionGUID: 8AblpfCjQ/Kd6UUw6URDbQ==
X-CSE-MsgGUID: 1g892fngSe2fsU4VJHRuPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="59051773"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="59051773"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 09:11:29 -0700
X-CSE-ConnectionGUID: hToPhvxJShGkQthGSfg7bQ==
X-CSE-MsgGUID: IG2s9+2xSSuPPxjuwFh2cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="194966384"
Received: from tslove-mobl4.amr.corp.intel.com (HELO [10.125.109.202]) ([10.125.109.202])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 09:11:27 -0700
Message-ID: <6f71aecb-9a2c-4705-a3f4-71231ef6a831@intel.com>
Date: Tue, 2 Sep 2025 09:11:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Rik van Riel <riel@surriel.com>, the arch/x86 maintainers <x86@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Borislav Petkov <bp@alien8.de>, peterz@infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>, zhengqi.arch@bytedance.com,
 thomas.lendacky@amd.com, kernel-team@meta.com,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>, jackmanb@google.com,
 jannh@google.com, mhklinux@outlook.com, andrew.cooper3@citrix.com,
 Manali.Shukla@amd.com, Ingo Molnar <mingo@kernel.org>, baolu.lu@intel.com,
 david.guckian@intel.com, damian.muszynski@intel.com
References: <20250226030129.530345-1-riel@surriel.com>
 <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
 <913a509d-d985-4520-a879-538a1198b946@intel.com>
 <3990BE94-FB14-4D33-BEC3-07EB487A2490@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <3990BE94-FB14-4D33-BEC3-07EB487A2490@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3wapjn6qamnj7hr3ukw7wutxm4pxhpyo
X-Rspam-User: 
X-Rspamd-Queue-Id: 5776980013
X-Rspamd-Server: rspam01
X-HE-Tag: 1756829490-135258
X-HE-Meta: U2FsdGVkX19aaSvDXhw+p1XgaVKMdvTcJ+iMACshLToE+4+Lx3oa1wMIM/Mn5Gp9IWI6lfPFWISecFC4bbimolcClLyzIJJLiPMpybAyVDjYvtR8rhc+WQZSPxkamXfGYE9QMwwicAsMAgbcs5K0kNV3pb42UfkLz2t0VybBAzLAtVDYomjSVDtinywfvDY/Cg3s2wweFzf1KA8Z8lX3mQBgREuMum5TR9lvG/A01bY1IpBpkOuVD7W5i6B8bpao8MpL8VmzAwqde8Vop7IAixS9ijVZ7e6/5hGFIHcz0NXKKq5cObRdRWYkNgfHUTY/YVasgvuaKYrmboxSBzw97+YgEzjfLldlbPHBAzxCKik9mjWGLM7O012EiriSpum5dYypYeM9k2JlGtuOckfqE69ih0gQRJ+rvKskP1rut1ONxtzEbin+RQbdDSxBbiKAGIH7G5mTV6vMaK8rENxCazpG99QFQRdnilzFxsvXZAOy06oZ+X2owf5ryl8FowGIPf0yXJxBNtFRvwNcFCwNU1aSFBmRXaITfnMWlIzoSSzEoHKjctpC+bJSOP7QaGwJy5Uiqd6Tch6zRib1bWanxaZXhofmyAwH6QlLJrOM1XA74FD8oJXLjFs1Gon2ta6Gu6W9pYDliNckMOVxq09skDxGv/YgEbzt4KQ4EYoeWFxfc3KRp7ZXbJ0ugb7GzAbHAS0ihmqTkQrHfwSFZOJKeo1cWZfj7A7hz1vSYzyIH4EWc+t8R8NCszw2WyBkb71evx0a6dKzXO8zipin3igAWIC/534jebDio6FOL+1lg8hzWPSHx4be7QoxX+LaLKwLSKQE/jMiRAHc+xJfRhOdCD3RNZQKSqSSjIl5z9L9G8KQrNhl4do2VKI96dSe3ROsosNXEOtU9aSrjyq8+vvJs/UMGwt19fbyG7J3StPBOHRAjfx7FTw3N4vmHx5UYXDiss3ySGOaFH2mdTOqO88
 TTJGSXRo
 wTeHbP51HKur6Vbut/5JvRhof8mWz28atwfGQe/RA6CDpI3tab7HBmj+zVbCywl18TgqGcepSxs459PEUgVslC/KwzV1TQplZF720U2B8FHpbfV1PLuaj/1Z/8bLCL6l1uni/NawvXVzeBaHM9hFKW4hVaAFZr8AC4xuHvaYInKDBtFuUs8mut6oZ+WVZZSro3FX0So/vHIZ1sjAzAnfZ8Z0T7i2lvjlrwv3cEervOEA1HgH6VT8RVhHpDv5IUcfmNIur01d7F/ZpNfROQ9dNFqD+cU2bxP4jOv4m3v95HFw+NBM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 09:08, Nadav Amit wrote:
> It would be nice (if possible) that callees like broadcast_tlb_flush()
> would constify flush_tlb_info (I’m not encouraging lots of consification,
> but maybe it’s appropriate here) to prevent the misuse of flush_tlb_info.

Yeah, agreed. It would be nice if there was a clear and enforced line
between producers and consumers here.

