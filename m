Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4CE606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NRrXzMPm
Received: by kanga.kvack.org (Postfix)
	id 3D8FE6B07CF; Tue, 24 Nov 2026 12:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0696B07D1; Tue, 24 Nov 2026 12:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29EFE6B07D2; Tue, 24 Nov 2026 12:03:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 032C46B07CF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:03:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09BDE40C90
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:03:32 +0000 (UTC)
X-FDA: 85470633864.15.50A0667
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D19A40009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:03:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NRrXzMPm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795539810;
	b=2t1Ybk/gRKCT+g4htMPZmyOuqAAVPhyy+3Ut5nVb5jrTgoKqphn+Rl2hUkewQsgNxkweF+
	TCswuV7lDJWMrWZ9IFMRS5pF5/a2zL4c2S9R9T1SKLEZPmr58Wi2vKL/HwhKnzyqcWOxR1
	VT+vsJN1k0Sh2V5cwyrjMsGrQTKq20Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795539810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHHJEpclenvhL4xmnZUmc9+yes2wNXZb3V1dO29rWao=;
	b=TI4KS4Km7q9vGpSvssUtPX0we1uO1jPPwazjMv37d7gRfX998qRlt7MmiuLlbFEInZEZ2z
	L6SHTlNEnzwlPGSaoJQwRZD2ARKt6v3uCntQ8mMLGUiuNeL15t+ACXOwY0wdhgREVfSh+3
	bshCvDIQwChlg8sqwxXzhEf1+CtxuwA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NRrXzMPm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795539809; x=1827075809;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jHHJEpclenvhL4xmnZUmc9+yes2wNXZb3V1dO29rWao=;
  b=NRrXzMPmVY+utehI/XFJjaNxIUrp6VT6Lo/7TCtTFugcDvOqgcch/3c9
   fNAAwEp6h3Mbejb2Wt8hAEcxibGGSdxURWlsnGZUvVoM+/i9uM4tvNeDB
   kKvieBzDHPwzwB0Itno/ezOVI4ASwqQiLqfyhxMIwtJ+v1+HIb9NUrI0R
   klnndEtO5cgVrUSBJKeTBE5FxOIMP5R6ZerW8jK/Soh+bHGdwxjqQHNxC
   L73Y16uVrw5As6VDtaQsyDLkj5IqiLUYDWZ2MCBonZJb67XL4OTQ+0EH3
   lsMRRvjAVi2R4VBlNVJqLMiZFYIQhEXLm8kCAeRJOeWSCDXZH09WLKLF3
   w==;
X-CSE-ConnectionGUID: Yrn0Bu31QFizR0tdPqMZ2w==
X-CSE-MsgGUID: 9XyMqHP/RGuKjWnn1MqD+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4393391"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4393391"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 08:41:15 -0800
X-CSE-ConnectionGUID: 4POPJdNPSY+//fLB9GhGBw==
X-CSE-MsgGUID: q4Y3RdbdT9SCvGtwj9x0Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11727878"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.20]) ([10.125.110.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 08:32:04 -0800
Message-ID: <96be8f5a-8f65-48ff-8263-1d5d5f706354@intel.com>
Date: Tue, 24 Nov 2026 08:32:03 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential
 guests
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org,
 Pankaj.gupta.linux@gmail.com
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
 <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
 <awW31hUpXuujSAXA@kernel.org>
 <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 4D19A40009
X-Stat-Signature: p1gffdb73yhoz3xc4ry8yukuzd5gfnr5
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795539809-748843
X-HE-Meta: U2FsdGVkX18YifoNR7gAI3T5H19PEMV8tiAsDPlqP+v7D9Wbepc5qnQB4Fxwaen5g3/yO7KMpPqkfJbuuCKFY42Ts0ftzlGMj92TE6wQum9J4c5q0awvU/8WiTeo0n8qIJbrPu/bKJIZKDujjiyLMgIpaFreeUh0ghFZASKUI5evVZf53gpZ+xvyZJhHuWk8MfUmNdPY4FJa1Yedknuwkhpk8lcbM8D92gJYbqkvvK3zFkWzqjHG6fJyNtKlyPPOvzkGpVEumGNl4GcgR+TQo9hyJqL+THBdC0/i3yK3gMm2WzYpudXTgQdXVmTqv1bc9Zb2et6P19nTtXaKMrlEALm9ZdX3DGUIX/GdNVDs9XwcJv9pwtTGRpsnPC6c+6VfFy+pA/NMvgfk/jMwdIhrkVUjsS5+5pomrGNW2mUUqvVozlNH1T02eLWluFWeQDhfmy3FNhgkyfMjMAvkKNfL3y5scoIZXl+3Y3jeEUQivtta6kdreMn+oENpX9vvuvmOKpdZHBGw2R/IYS4IPalgXCMH/Fzawe9RQ6pdExUZPsTR212qNRAEcU53c39fOGs6ZBsEREecSeeP6K6TNhjnC637DR2MI5EGtXO2yNV1dboVG0OYX9YZoFkEPRBzznEpm2xKlN7+3ekNAQpNheaZBVw9LaXRDsrQOiyQL8kRKF1bIBrkXoVyuHTK6uvMTQ+ubU7/0kodLOWHp1d6T8xAAiRsRTLdTtGTuI6HUn599xDMpBZOKmyIo7mipvqIxbgf4+nlGU9U6gPo1s2LdFGJOmRYC05ZDIN+A5Acq4WJtn+XCt68XSaCfw6762/O6nGzrN9gQF/u7yR+VyJGgoxwVojww20o/qVv5JDvDG3QMlil3uEM1UxQdOP4hnb4d+2MMaEyryTEKE3o4+cBSBl0L00tKU04snU2xiULGrNmzLXPCAYXr4vck5rqYReAM008KikFmaR8Oc3rXntgXld
 7y56EdXc
 OKcsXFoQYxqIrj2sa8CXHRreEZ/v+UqdxZX2MiAeGHgilHZ3EclY+yjaJcDtgdIBm0tAwC1FU5P9zG1s9lJ5mD3AfvKa6kI1gZShB95kNLVVPiRC1OFK8wLOd5GNilOBmK6E3z7+Gyi6fXyyomX0YwLePczgqiXwma/MFUribqpxPNI7KbRBFD0R8FiqPeYLLIr9p4HVbNcbL/tVJjsr71RgEK+twyjGJD/OrhoFmt7c+eE6ciYo7Kf8dw0Ef5tCkmZqEwDP0VExj4FKyOIBhTlBXiAvqSIBrodCtW/R78BwjGPMzsq4SY71lj5ac5V7OtUqiIACmkAo8N9i6c0GiCuuuHTYQLd5H5CHuNCdjlFnjEsV6gVkg+XlSa/dspfWCB/oTiK8rXXRmPW7XNmK0xyu+Gg+yNih7kFlRivIprzgCJ6q17SJ2GzyoyXXymtKSKKC4wtFpQv991w4+0yiVcZy1GA9zBlijiuFS0yPquIAoPvaSherDEqAHFo55S5CXo28tmIGOFAyTnuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 08:26, Ard Biesheuvel wrote:
>> They shouldn't but you can't guarantee that.
>>
>> But I don't mind letting them crash if they do 🙂
>>
> I'm fine with either approach (i.e. disallowing it or doing nothing
> at all), as long as we don't pretend that this is something that is
> expected to work.

Yeah, it's not supposed to work. I'd rather document "don't poke the
sharp stick in your eye" versus trying to make the stick less sharp.

