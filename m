Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC65FC6175
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 17:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41076B008A; Sat,  3 Jan 2026 12:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8816B008C; Sat,  3 Jan 2026 12:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1346B0092; Sat,  3 Jan 2026 12:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9C66B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 12:06:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0906A8B9F1
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 17:06:38 +0000 (UTC)
X-FDA: 84291281676.28.4EF01F4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id B6BDD2000B
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 17:06:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ANtfuVAz;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767459995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4bFIQUG4z+9kNR1Toi6xoGQJ3a/5IO2YbbqYrXfoR4=;
	b=3HUQqALreD94bynpxjixi/nEFEIZpfd/iRPWoHo87MrMXM1sDnm52Zdifte7V3Nqa31b5l
	QqEtXZimCBqqS9jxYicMxYS6Xw28sHX1Sf15F47x8+RWkVMx6YBzcYs2xMABzBBw1N0tXj
	SF+mtBEwt2ft00IXiUS/cBvyN2c8TPU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ANtfuVAz;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767459995; a=rsa-sha256;
	cv=none;
	b=eAM3opSIEoCIoPEe3+2j/ivnWCLsQ5TTjf6LREyKpsCjvI6B7WuWc9xFkemDmChnXiMdzf
	XxwEtye5PCOGVVD4szsFnq2rWrFdIWgcxN9sSAcuulolegqm4HgirAY0BKcAYBLw4nKN6p
	4/YX3Zyz5ocSph/79+XOB4PACIiB5s0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767459995; x=1798995995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uI8wwW7bUlQiECVDPThWp+BxYtLWVDhrvNTPPeRYzqg=;
  b=ANtfuVAzt12rvuDbY8vHU+HUAbWgQlJYH3amfpBsXs6M1fxpPXlq2jfh
   1m6Y+gpG9Avyp9BfTX37oMV7pWyvwJbKUzMpyCs/cooz9D4KmzLyq0o+l
   1RZ/ng3WR+Ry0dDYwVO8N1KSRDUwhI4TQVd9NjHINiuCqPMX1vrg1IXB9
   gYDiQ/SAZqAdD36RThlUJf7bFxmYmp/s+QXk7GTNdvD3C/P4jOroukhIo
   H3SCl3Z+PmgbmU+yHvgqA7QHELJOGRxcJ6qPsmPvxgE//pfOmbZkI5CZu
   2o1dAE+1/3EHjGpS4hiYMx6RNyBgJqwePinhfxPmkUWYKpcOdSesVUrCf
   A==;
X-CSE-ConnectionGUID: CygayAifSua+3TZTQRaeJw==
X-CSE-MsgGUID: IarUrnGkRo2hihpkIq02uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="69061897"
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="69061897"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2026 09:06:33 -0800
X-CSE-ConnectionGUID: WDoP2JgATO+WJHK50upKRA==
X-CSE-MsgGUID: O5Ym+/x0QLOsXPLtcUC9jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="202499243"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.1]) ([10.125.109.1])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2026 09:06:31 -0800
Message-ID: <f920487a-632c-407b-b092-7de87f66f4bb@intel.com>
Date: Sat, 3 Jan 2026 09:06:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] skip redundant TLB sync IPIs
To: Lance Yang <lance.yang@linux.dev>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <f81b98e5-87c0-4c21-9a75-ad5f9b6af6aa@intel.com>
 <1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org>
 <cea71c01-68e7-4f7f-9931-017109d95ef0@intel.com>
 <fc3c20a9-69a2-41eb-9f22-8df262717348@linux.dev>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <fc3c20a9-69a2-41eb-9f22-8df262717348@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: zy1998oz4n85j5hjokti1fh55aj97ica
X-Rspam-User: 
X-Rspamd-Queue-Id: B6BDD2000B
X-HE-Tag: 1767459994-952079
X-HE-Meta: U2FsdGVkX183Uc/6Owr+1ikKvq6JQxULu8jzBChNMXu5AJZ9pSfRNxuQ6UbdaW0LmWsSFdtAZYsmFz59Ue399LmGLseBY5LNkjRckT6NapobdD3jZFq8fXLt0+gW0K31EWf+AWRSy0pNGV5DjLeMjwWiInshdq8+4hhGpUALkrIvulJZJ0IB/xb6P63EwOCYELFbegMzUQM2K4FlNBXZHl26Riz6MFNUUwQKto2MXpenxMUbt3ETqGX+vrrTA5JnVCG0oN9pjuXlhTYA9pjqk6suF1uBTjGHFN/HxuUT+iPLGeLUwjMddLg5eyp4cx2tXzUvsUFx8Uk5Zs2EysDxmVbuQ8eTnQnPecjDeZwCF9MoU7Q9xQxVABbkyWQGEhXN8R+wn2/VhtjMiZO6M5KzwfZ7PHq9leV2xtv/q+w3CevvvTRF5Gii8cz0mXpyWgTQqd0KsFnfaEJgxnnImXsnidkpTCwNccxXjWxpwcSQYRWC6OWTud489eAH31TujzYkdTHt3hdjbRPNa53vF4bXvWMB9dn7fqctYukpOeBvFihFLaeHQd84gphRZtRGquRjrOhdSVbWgeyteKXOCfWSgx18RUj0ZX/bonO4xe5vyMYq9A34T0eKh50MM5JXtfFlg4/C63rKVDsaRj2nIAfOjK2MLI4Q8VdbFOGdRoSh+nAdJaXGlalkoCk0orkx0/Hi6/bzMiUK826MyH62ETXUGjn56uBU2QmmKjXvXyDw+BEDgyMtJoICj0G752vNFSKVA2Vuyqwgus1V6AUQI2EP176u7osQIeBvVNli817vJY1tThrS2K6X1chmE7efAWZXaE08Unhkz2Yn5ccNVf3l7QKMjztMy18tdiZD1txKg80e3PfjAG1edWoC65EubwQPgZRorBvQ832lwDGs9+NI0iJ/gTuv+Fhwl/aYzCl3X5huBiNLGRggKEQQEnbJN8xLUUbxr1VxSZ9KGn+zXCP
 FVJfsCqC
 qhL7nzvBCt4VEVRxqWN8w5pSxb61p5rSAT0m6Dax/zeJKd4GbwAX6X/PajhUX5qo5JOlAkJGCkrRV9bgSXGpBSn3VvuOe7PwIx3pszeLlIVOOZsQf3QnIASSUuC3P0GqV9ANM541fjCMub/rvw+OC3LyyCYQlUadHexTjIiyCaVnSlq2iq5HTicTcC2qHn8oMLIi8RrwrY4dz0VY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/3/26 00:39, Lance Yang wrote:
...
> Maybe we could do that as a follow-up. I'd like to keep things simple
> for now, so we just add a bool property to skip redundant TLB sync IPIs
> on systems without INVLPGB support.

It's not just INVLPGB support. Take a look at hyperv_flush_tlb_multi(),
for instance. It can eventually land back in native_flush_tlb_multi(),
but would also "fail" the pv_ops check in all cases.

It's not that Hyper-V performance is super important, it just that the
semantics of the chosen approach here are rather complicated.

> Then we could add the mm->context (or something similar) tracking later
> to handle things more precisely.
> 
> Anyway, I'm open to going straight to the mm->context approach as well
> and happy to do that instead :D

I'd really like to see what an mm->context approach looks like before we
go forward with what is being proposed here.

Is there some kind of hurry to get this done immediately?

