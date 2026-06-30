Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B055C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC146B00AC; Tue, 30 Jun 2026 10:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5831B6B00B2; Tue, 30 Jun 2026 10:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4729C6B00B4; Tue, 30 Jun 2026 10:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 081FA6B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:01:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75BE58EE7C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:01:53 +0000 (UTC)
X-FDA: 84936742506.28.C69F9B6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id B4BD84001F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:01:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RGxhdnsq;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782828111;
	b=JVthrQfO8E1vlSUZdij1uiJK8RLfu4UfHRCOPhpj/KIk4t3MwiUd9FtMJ3FJO2BbLHs5zx
	zq9vj0tfzs3hU126r+jw0sWgMJ42yoJtKVkZMx91s25hVkutAalzWpSpeRlwD45xw/MFbO
	HGPE2m44K9IBVNabr5LY7oaDzIgS5pg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782828111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBtju5jSXS3akgVuSZvzF4MAUIhwFQ3WLXvzruilUb4=;
	b=BApRXSEQRg4JjTa2A4gB2oUyYTicFexWEbAgJqQ8zSmb9I+D9ZpcWNLRe71mmaKTvMCiYU
	vgX8KndNoAvncJwq3K2ZCuA35sg+iz+TfovkPldorgPcXPdCkO7ytA5GmCfPn2gWQzUMr/
	wE2q+34BjRa223IJ0yXrUtYZgy40odA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RGxhdnsq;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782828111; x=1814364111;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dBtju5jSXS3akgVuSZvzF4MAUIhwFQ3WLXvzruilUb4=;
  b=RGxhdnsqS6z8VP5+XZ14apOZuLW8wHA9THivNnQKJVi8g4+yY6zC/0W5
   CqFyuO0fvpgJJKfWWbhrNQ7AFi9OCVhIxqDdcEQiwO9FMdWDer3mGvYsa
   D+qBcxFiDJLU+8xPYPIILgQShaZJFIpxjDcI5RA87k+3lUKTP0vmHJc9O
   kfZJqMXVg4AyhnSPLH62yDkZNqJnsNixvzXUXMeR5MSBIbuLpdYKlSwfZ
   HLUOxvwVVeW4gcxz6OdzsO5EpAC+qjiDglLuHOHZ/TRKcGU99qhnttWUD
   H3GylkFVPSSNdvq9gxw6yC4JVekQPxGrv5Pc4QpS7EqLTovwH8cCGSaQ0
   g==;
X-CSE-ConnectionGUID: ytOM28YbQ5WKolsAbpPkLQ==
X-CSE-MsgGUID: cXIEiW6CR2WVC9bijHh20A==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="94195122"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="94195122"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 07:01:49 -0700
X-CSE-ConnectionGUID: USP1doKgT/ywYsRCKxlNMQ==
X-CSE-MsgGUID: 5xDkm+YiShSHFXX7zIDABA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="245932529"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.109.240]) ([10.125.109.240])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 07:01:48 -0700
Message-ID: <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
Date: Tue, 30 Jun 2026 07:01:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Xiang Mei <xmei5@asu.edu>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, linux-hardening@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
 Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
 Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
 Yan Shoshitaishvili <yans@asu.edu>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
 <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q7wowmg9hxd184prsqrxxwqaqjw88bey
X-Rspam-User: 
X-Rspamd-Queue-Id: B4BD84001F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782828110-153563
X-HE-Meta: U2FsdGVkX1/5XWJxQ1OnKFA6CpCtEGFx/ahCqAKrLNNyv2Vdil0IO9qcXG7GBzzeC6axOoj43ZOUJS2WYKZ1JB4la9colPnoZmvJNfjgQANFuZ+bU6Fd1WX5WOcbhnfSXiyepoNM2/uXp/ufwFF6kQFYyiuj1y1MVzWcG///rkkpF+IYkxQZlmxOpdmV7G9Un8iXg2tLWG4DVkgo89nZY2fv1tiwKAXGrfJU8p9b20r6EpJxmFh3aMvv6AbIWTOSeG8LZtXXxNDrQG1jfZpsYYh5+2RBXgN2ciUXj42c+8xYP2+/OAVFMwAIKkVT+bgoe2KSWYAXrfsgNx87rBHIzshlwFSCX3aKoMjBoH7r7yjQu+tPLycCGfS0p0WXkGbbY588J3uMXbsmH65lxfNc1e5Jx/VYftrLwWSyHi4Cwf92MbVOEfQi+2gOuL7b/JkmWRHKDgIGQeZenv+YJ7hGcp0GCkdacgY9LdH9y7JTfkHDdJglWp7k3djhlU9pm+PLgOdDsKj4KUpVgx7qRLAoaBxmUDNvm0Sc5fogRGH46orRQCrMgHq9u9JrrNg3fVfP/Sb0LQIW3DHd8Fqod/ksMoSumpoYIbs2OE9lcMpCWD5Rt5YzMb90NVl+jkpgCeatgS1IPtIg+UBKsmz6BSAU/bzG41+mkPRB+rLnczrLsi5zzE2GBPkuPhYVm3/DAcG0MrVFXhyMXlRmiLYlYLGb0fQNY2NZlahogb5S8VvkrdJU1SVa7ApWBLA9pd2Fj/CfWYFfeYxJvHlHHUZPG54UWbQchQAll8TEqs8J6Us/2MbxJWa65XBpqLgWIRlsoLpXOPZJ6U5NX8qdde64hPgcrQRUznquE1CwRu0PUXCDnFXgU+NxI3jMWaNVZFFcZQ8ZbWCbaFORM6PWzgUPRjtD5w8yOJtCGt9gdulic7XUil3vHzv4AcMgRhuUyss38wRj2/c3VPAxln2WXKyRylv
 QUbGL/Qw
 vgv3mGTRlIMswZFwVJI21p1QBYLZZIuVOiP+5x+AlUcC5LlMH7Tm6URT1RGQS27kkU6wC2jtr6jTZb/37AKi5XwpbIBgqWgXqVl4CmK5egjLhpfvJXI5ENI7sBlx7q2lPQDa0zcThYloWKhnytAtEb7K7HMVqh+RGs52YYJSP3rxsdGnXJz6v5K85R9tgecqaiagdFZ1uS9CNbShu/KOC3Zr3QaGKEOcoxGNfdvlJqkoSXKQuzDbeuN7CUNwHqS3rx3oNJyjo50vXD6cmzoGLnQH4NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 18:22, Xiang Mei wrote:
>> Please don't even try to send a v3 without addressing this.
> This is a demo exploiting CVE-2026-31419 with this technique:
> https://github.com/google/security-research/pull/397

Thanks for sharing that. That's really good info.

But what I want to hear a bit more about is why this new guard region is
a good, generic mitigation. Does it help mitigate a whole class of
vulnerabilities?

I think you're making the claim that this ENTER technique takes what
would normally just be a DoS and makes it fully exploitable. Does this
happen for a lot of DoS bugs? Or is CVE-2026-31419 very unusual and this
stack guard gunk won't ever be useful again?

