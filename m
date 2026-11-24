Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7451B606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=KXPeIeNR
Received: by kanga.kvack.org (Postfix)
	id 9AC866B0797; Tue, 24 Nov 2026 10:58:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D3C6B0799; Tue, 24 Nov 2026 10:58:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826876B079A; Tue, 24 Nov 2026 10:58:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4056B0797
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:58:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4DBA140C36
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:58:36 +0000 (UTC)
X-FDA: 85470470232.17.080EEE0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7EF97180003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:58:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KXPeIeNR;
	spf=pass (imf06.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795535914;
	b=xCXH4tfrG/QlesvXUpHWS3mQRlbf5LbV7BmggjKOrDmMX/mfB1pwWAK5oCJeFMfEpAs4Oj
	M5PgosXWLtsAf98+IfkkfXZqddANZRGlQA+8BSWylDGyVp5RHAQN5M+IPcHbvrFklKlH30
	j5r5ZCctJuZT9yenVMrbx1godSII65g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795535914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGW1pesUgBXQRVvPeLaAto75CWDUmEXOH2vREiIu1hI=;
	b=XdltcJaTR+aTIuwKuNrb+DF2wQLxRZsJQxHhnZHoS/PuYe43qY32mrVBo6wTeyqlXBHaUF
	OYT3j+NutzthyC6QT4x70Ydi/awH+GbL2wQowaexhn5zDDjx2ck+X/RX1Ej10c3sJhVfCF
	63dUdcK6MZbHRmnNoAwRrmA19+Zn2Ic=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KXPeIeNR;
	spf=pass (imf06.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795535915; x=1827071915;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u2cm4iCPSe9XdaKEcS9x2ZNPfXRScR7FSXj0COT09zI=;
  b=KXPeIeNRU5TH9W/8GOMjlYsZTcF1/j94FzarUxyk9teG6bteZqo8A0Ah
   qbJaDBYBhIs7TqjKNyCzA1OkMxvld9OyoWdf1m4EmCzTlWgjc4MyEBxnN
   jNFIpNcy9gvMAhia4b8k0WEiKVj6r6qPrHkHdnFtwMmShsS1yOrsvs53w
   XRXQwouqlakVuJLPPYFPKiq7XeMYTF931SXunyWZdEqNw/6tE6GSo8PJk
   kaA7+J+7uHppqZbyT1HAZcmBgCTNRIU8Sb3QxS5vwFdh/TmS38mpFu+h/
   gki8JQBqdsCspyEBD0lM+N1z3ki1NNs/q4DFiKvvxPy8JF4UQ4UJIhIKp
   g==;
X-CSE-ConnectionGUID: dA/O9a7tRBi4/PVeevG97g==
X-CSE-MsgGUID: THnv3acjSXOD1WT5lV5K4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4441245"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4441245"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 07:58:34 -0800
X-CSE-ConnectionGUID: 0Htf26JWQYCdoBHrJ102Wg==
X-CSE-MsgGUID: dXHu2Wf3RyGLbGT7u9pJkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11577700"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.20]) ([10.125.110.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 07:58:32 -0800
Message-ID: <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
Date: Tue, 24 Nov 2026 07:58:31 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential
 guests
To: Mike Rapoport <rppt@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org,
 Pankaj.gupta.linux@gmail.com
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <awWzrkLxfQ2_ODKe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8pup6dc86c38xp1ufs5zqauuisn7w73r
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7EF97180003
X-HE-Tag: 1795535914-149085
X-HE-Meta: U2FsdGVkX18/s0ukxGSwjuuMg42/w70Jg0LIcdHglBgD+xh9uFPzs6+wie5U8mV6r63lhigvEVvXRGau+L1GlrKF+ivOx66FvP+OHbdV5iiBC39cpAV2c5fKEwJ1+uydUpZyQCPTQHqcOkYBiEZYoOHsbsYvaGCDuEUXvwomfIs1GLombFzOBlfSFqXBvh+20KkJyzs/fh3uh/v3gcd9xIMh7Aaf5xTJGKppsTavYTP4Jp58iNdGeDjg83VRh6SFXMR96c+8AFEAWn/X/oV7K9DXmhb4o6DfNJEketSu5GkiORrDdAJf1PrHWF/XzVnpH2AcP6b58BhrZUvlOGeWBRAp6gYTBtqVpiwUzi9xye1QHfVcPu3kETzXt+19fvVgU9PgxUUwUAeYAl1GJGkMONit1vg2c/fH9dw4WOhiK4UgPX1yBeMkS8C4gig5m7BRJW37wrGFULaG1GoPh/tAmVHQhWavg6mX0wtKyd1VYmgh0cEsGt7klhdQKissQXsRQz+gNuLr+5RxuigPighnvBAFZH22Phuc3Ywzo1AFbpqO/g3RH2S0G1AlL6y+EH9rGMhwQmO408UowJleF0UZwN/rEQWMVwXakNi5xftSc+jl5hdyVu8SobohBIWh5bAKTaNES3q2l5qLtqTcW13hAx5CDEevzcq3UDGtTdkIJGF5BVO8WcRa0uoNvzUdU1cWUs2KH+kkpNKdEWVGdT7n9wtLLOvJzpHpqF+nxgI2bSuhIIyt+V7Uki7YBTtaS0/cKyurUgPx0AZIjydbLApfaaNjBnvKXqWnrhLXUVgwzwExXuV16KBm/dkNWoW2fA4Vw6lpyEFPd9HcD7zgzWmOtg0DXSu8she2rGkBuFNGzA0OgM5tsjUqU5SWCOIerIyqhgEQ5I4kOelZgtuPvfZd6XxkM0Ty7jHhZnnZNPwAaoMh4bb/Mp05DP84vViqLsl0OEQnaoINY0XkpVhfCk+
 98jI1fV8
 t8u1Gkn3NxD9zlmUIq7OyuIBWMeny8MSzZMXx7qabFQVdwB1M0wS6cI/Tm2vrf6H5qwiPkEk0eC7hWpnVDvIRKpkUnyD+3RfttGH1N0IAV1McZjOAlkub77igwZw66Chdh0tZESSD3429ZG2lbAMxvzekzswjOPS/lgr2fUMRgc0U3FVkJtUqpDV1snnlliMPWJmRXh79V3nxevdcgeh2fpDgM/mAspj521HLdXlAsneJZ2m01s7AxoAvVWjDAXIFcdPyDH1SOxNlOibM2grK8+awy8NTjcf6B1cZtytEuoy3OzSzuvgt9LTjZJm1mHqdCXrAtl0EILEszu15oJ1E6SNw/1VPGTtxWLTymjB1EOzhrbLSxw+qCl2C9oOcFC2DN4lNSJWLYIuTSo0t4TFQ/obdYwtkx8/ZmPkDBXkfOhCEC/vLceChVNvuTkiet9V3Cy27sjLa4i3MQSuWnd48FJAJy8IFQ16zvDfa6OR6NZ71Zz6P4WP7NaVXGWsBqwOJ7gL3udqh4QvKtbAc8zN65dlJHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 07:56, Mike Rapoport wrote:
> On Tue, Nov 24, 2026 at 07:09:42AM -0800, Dave Hansen wrote:
>> On 11/24/26 05:32, Pankaj Gupta wrote:
>>> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
>>> memory bitmap before the command line is parsed. memmap= and mem= edit
>>> e820_table only afterwards.
>> memmap= and mem= are debugging tools, right? 
> I wish they were 🙂
> But AFAIU they are used to carve out "pmem" or PFN-mapped memory.

I've used them that way for development, but production pmem systems
always had persistent memory in their BIOS-provided memory maps.

How are folks depending on these in production in confidential guests?

