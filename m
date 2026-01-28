Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD63D46BFB
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 21:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA3E6B0005; Wed, 28 Jan 2026 16:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274356B0089; Wed, 28 Jan 2026 16:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1736B008A; Wed, 28 Jan 2026 16:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2926B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:15:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9B97BB58A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:15:11 +0000 (UTC)
X-FDA: 84382628022.27.F513ECC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65A3616000C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:15:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OilXT9Om;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769634909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fWpnvbu18FRlZukZYR3Pn1iiV0UIlI/SPk2HOEtmus=;
	b=m28wNjU80d+TiV0W79dnfh3nf5xAzvWuI+bn4wevLEbaJFiaKYbmDvFV0uuaj/48fXIZpz
	/hU66/pm4fN9BOe57paefXuxEkLywakMPpeYDi3TVdbDSDGvEm9/ao/wpgCne4DO6KSaLD
	FS6tf1raayB/QzabXLCTSJGtG61R9Qk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OilXT9Om;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769634909; a=rsa-sha256;
	cv=none;
	b=y8L8MIPUEBQDUT9+JjKX5luFwMdTMb9/m1GqeOo60LVbEk2L9FseFsUj3f9uZ4E3bebFb/
	Ywd3Yh/fYSGXBEbD02I+o7i7tkRsId0Y6+Hkg4HsqZIehjtqLMjiQ/os0xa9dhPCi7ZeLw
	+jXbOOlgpJDMlqR6Am5Jpg2Nz2rAclY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769634909; x=1801170909;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kYnNMET+0XVroY/Dhwum7UNruwrnQ+q9SltsegGPXqY=;
  b=OilXT9OmcOGEaKXREzKYd91hesOXm88f29lgmToRidXJl8u3g4YCR5F+
   gi/RUNJtr8bvQ6JSggTdxjBJ1zzFHOagpi+poiODSSXf46Lac806CVh6g
   X75noRR2phEQX+6Bd6L0Zfn/c4lHzitW/OTNmqe3+tK4/Dxbi1+yhWK7A
   8Ocy7sYYpkKuXARshaS5RD4jNLqIi0JNZgZHHozDPo98PS2wyJnCDuDYu
   UlgFR6zsnK1qwcvDWwDdEblX9L3CnL973ZTli/kvSPDM5vprEcrmOZ54G
   hHl3WMRK8PfxIK4r0O/vNTR9yh24Q2Gt5HepuX6yudMGTMbgxyDjmX+1Z
   w==;
X-CSE-ConnectionGUID: 2UwW5bphS6638Z4DLxP7qg==
X-CSE-MsgGUID: SYhuTyefSUmzyYyW+UU+TA==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="96323488"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="96323488"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 13:15:08 -0800
X-CSE-ConnectionGUID: 7ekzL47tRwyyuMokzGRHCQ==
X-CSE-MsgGUID: 324L8ylVQ1qUgOvxGpki4A==
X-ExtLoop1: 1
Received: from kcaccard-desk.amr.corp.intel.com (HELO [10.125.109.190]) ([10.125.109.190])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 13:15:07 -0800
Message-ID: <16aa84a9-83ce-4748-bc73-ccf5cb6ce376@intel.com>
Date: Wed, 28 Jan 2026 13:15:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] x86/sev: Add support to unaccept memory after
 hot-remove
To: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de,
 thomas.lendacky@amd.com, michael.roth@amd.com
References: <20260128204105.508855-1-prsampat@amd.com>
 <20260128204105.508855-3-prsampat@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260128204105.508855-3-prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b88e63me61wkagp5ymdznzezt5d1ps9a
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 65A3616000C
X-HE-Tag: 1769634909-688513
X-HE-Meta: U2FsdGVkX199st+K3ORnWbbAYUfUiRLd1MMr5Iuoigc41tk1xtMkYEgDo+f6aw8Jm5geDF+9VUPCvf6Pi11sKzuhQAN7kbKmypdvYrWwFiN/6gdCYtRou9p58hj9W4rMo3LJ+zqnKXb2qMyqqmWCeL8K51cUHf344bshYowjfSehreZA2tVW46SB1yxqWHWcLbxlOXVcfoK2FS9U1xpcmyKDcdm1LSFt79wVovm3LoXhi8GK5d6Guh5Tg1NKKXHVxTzF3FpD6vmRBpwjh9ERxis9yzUBHU/CO5w9Cx/u1cju9zuJX15jvWehIsLNKo+Bg0q11CHNgLEpr2XE2GYF+6M0HyFVueizEdzVZRc347Oo7RQJi8OZJksXy4ScTO+7HDXNyYVX+vTLur4PWo3TA56p5xk187aX7DNyqtimp1JGYy9aMTP48SdFus8aoYKczQFGGkpFRQtEceChTDxPZJOM8/0iCXQalCipfPzNV+7HqNKhHrYX2KxbaTj/fHRc4io/dLGmuHnJeT81phEsCx38OCyrhUYNYLeUDxTWfI8DBsf6axHKExdrsav+lTuLusyOFg+jC+pTwVUPFYka05KWEdJ3HicUr6vwwEsgD/4FN30f2oR8H+4nk+mbEI7AJxatIXoydubcR+vKbiVydPWdQyq4yM5iw+kCFmAUCl3lDhBE3mp/+G3LwdTbbrfX6Smi5f+8xonnsdezyj6groI8LTxIAZlTLQ3L8iDvJ2qlUnw0e4EB9ai2IgrTU6Wa8DqTmS4paISDB4aQyxbFl0CS5zvj0S2FHWcGGd+pkPjRHGotufnoUhvNkE+q7v/FZ+iP8oRfxwquzt4RGkQBu2jXoEX1mpM+VWmA3iBve+EWHRLlZHUFBSaFOEVb3cT9n68WqWJEPJgDwE9oXHDQehPCEeucbB607az3LeH4+GOQXOFllHoVRRgjSmBBQGMnYjqyAjxj8xAhxFyd9gl
 kGuLa745
 uSlVWyb+HBNe5NTp2aZgLGohfgxUA2nds2U/VhjvLszoRpFEajtPnBa7WSYwu+2C67uKoJ0eWJ5/WuFiHMXjBQ/w/OfMTMRmGk5Hz66NsHHcw912POaImA2Z4EsS0Od/05D09dTXfHTpdkj96S0GFtECLHpLkFgp320JyH2LymKSEUj3yqju55GDr5Q4MbVI7UtQX2GzHqDrGBbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/28/26 12:41, Pratik R. Sampat wrote:
> +static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
> +{
> +	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
> +		snp_unaccept_memory(start, end);
> +	} else {
> +		panic("Cannot unaccept memory: unknown platform\n");
> +	}
> +}

This panic() is pretty nasty.

Can't we just disable memory hotplug up front if it's:

	!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)

?

