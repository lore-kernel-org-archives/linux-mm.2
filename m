Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6457606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LPKq8eZX
Received: by kanga.kvack.org (Postfix)
	id BC6186B07C1; Tue, 24 Nov 2026 11:45:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DF36B07C3; Tue, 24 Nov 2026 11:45:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4266B07C4; Tue, 24 Nov 2026 11:45:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74B0E6B07C1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:45:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5653D16037F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:45:58 +0000 (UTC)
X-FDA: 85470589596.04.6720F02
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6EA5180004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:45:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LPKq8eZX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795538756;
	b=f6m5LzqRloWw0453bou4CY++ojct9kBdLxE//GpLIj3WUos0+jf45lTe9S+BAfZf+Q79fO
	N4h+ijcAjFDK/Tq4YarMc+tLQFViVi0+I7XmTbjwMCLJy5OlrcdlTgkSE6GD9wEztz7S0u
	10Z7WIzq/SKiuVuXlNg/0tRKY4Zlsmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795538756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxlTI6rtqiXfcDnT6QcAXm49l+k9ZclkFznvOFdER2U=;
	b=ZJ82Ug0G9dnMP+uwygHJOAYftuFL4+B/csP4Bvd2fHBWof98aTX8UOU64Iwi0ISjbY+u8J
	/34PysOW/c4I+yuhe0B2yKHTDbH0Z7CC2OtVSl9tm/sxpJNhOpe7g/Jc3RlwPMPspJHZQ2
	W6JL/gt7GHkMp3a5/pfTtfXQXEiDcbw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LPKq8eZX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795538755; x=1827074755;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dqY8nqhkGGD+3SKgUz6Wa4A0n3Ozw/v2Bld4NPxmL+s=;
  b=LPKq8eZXXahHWYKi7Nah2O6iSr1vNhdjLkeNCRqkT/ScAzuHQAmBCRlv
   femolmQH/c07Xo67rCEAZpWOarr1uIcPqBhVdMKJTqNnHkM6Wclkr588h
   TayOmoh2wPWssrlk4+0bnjX6UswLR+Qz8Xin5Q7/0aWp9zOmkjIiFOGJJ
   A8Yz3MqSEh9J4UZn780dtwIv28PWY9Gx1PrlR/Cbr7ipvGor0G/TpeKzB
   xNBgB0Cw2kGdmvkBnyhLxfL8doBcT5mypLKJGRKwExrNI0/GgMC6kF444
   cYJe1nHaXhESrW86n41LMLHB9PwyAIt8bOHNESVEoPUMXyI1XPMRvxhxT
   w==;
X-CSE-ConnectionGUID: SaCPeQthT9KGojvZ6nMzLA==
X-CSE-MsgGUID: 0UnjR6MDTA2R1lx55xVmVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4448851"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4448851"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 08:45:53 -0800
X-CSE-ConnectionGUID: 1dmRtA74S/ifTYwj9pWRRw==
X-CSE-MsgGUID: d9RT3lLxT4KMcofXEgsiQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11924916"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.20]) ([10.125.110.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 08:36:46 -0800
Message-ID: <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
Date: Tue, 24 Nov 2026 08:36:45 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
To: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org
Cc: mhocko@suse.com, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Vishal Annapurve <vannapurve@google.com>,
 Kirill Shutemov <kirill.shutemov@linux.intel.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Naveen N Rao (AMD)" <naveen@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>
References: <20261124160025.738362-2-nik.borisov@suse.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20261124160025.738362-2-nik.borisov@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A6EA5180004
X-Stat-Signature: i1qsi78onnfo7kne3qxqzgmau54oanwd
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795538755-798869
X-HE-Meta: U2FsdGVkX19rMnHiA4ZdZh2bph7Uq3TosoOJ49h7Dhcw+CAOruQ6X5CidOhxuzcq1hjQ8YIYBeF2V+RmhV+rchgtoASAyt7qOBvzIULjf4uw++oO2Ajm6uTvu1ktEkWkELUgHIaJ9+l5W6JgkcURnLBIvh7+cvrv5eiRbkTJtCHTc1z/tFV4ZFhx2csvSxG/6Dx2ZP0vj7TdsgnKNVj6lYb22brt845droFcziNbiqakEnSPv/LfntaFqxxqSrgLc6qKmUjhrQfsBfSjTVubjNFlid3nw416Ro2xh+DrWKWOiB1WzL4I/Cu1neLDy+n5uhJvBcO0ZwCUe2HD68iWDQK0MpJ3KykulJBUEmw1k94iVdU2+CMno2PpvnfNoKPW69Muj1fR3dHvgHnKgpaDEmCVYQ8uErp+AJE1jqtaqmaOgXpHcd/ArSLYrI5vlI6ivxoLEDri+/jBqixssTmGKRzxh19E/zhXslKpyEQdlGbQrFDWzu37b9GO8kp7Lv7JOOzosZ3UuDrpkR+1gt1T3fGydbtuzrvmyKm/xIi+rB+u7d5GHni4ulHlTYtF62cVxKYJYi2s0aBLyUNBKxQcgJDo69onbwWNc77qVlZYHMTG4vlGBq22LsiRI8ER5a+fH9TFHGH0lzX1Gg1tsxhHyuIUkV7P7v2LMrmeOu8szg7EeBA6LitHnW+jbuU7X4AloXQuYGrdbLMj+dcBJKjlGzgWYC+pH6yq52qrLKgDvwyqntGpOfXiSsWoOGHhBgcT1KsAc42CCnre5+MEDD4FjJV95sTGlbqBVdkDGdT6+1smE2qEvgwHaEQ42X40XdRv1wh1ew0x1zjFmIwaMO8Nb/oavFsU77iGuP1IuvxCb0sZWAk11/8SgIwq3NIIijeZHbLZ+2kB4X5eTeinQ17f5BF4YCK9vG1XK1pyFpgDqoLuA8yNtTllSYP9ya0wARouoFS/iYZ+Sd3xZBAhc1/
 SeFrBFrs
 OUlklgUXABWQgvloKg98JP62Iea7vbWnGFIFEEtEmdpyeUWV7r2Wode+wzfXSCii5dbLkwehntz+iCiHDZcHLN1uf9S3WzZF7LzxnhoH7WkNaly0xJo5yAQzHWbNJdG/x33N9AJ7sgXNdlwWlK8kbqsyrEIjNkX9U4ruQXlXKJxxKM6R6gbUZTZgXzu/d2m4e3mqpEy5gLi4vvEgvljsWiFMyT3CU2R74DTCoDnjOsXPvejN9gEdVlGN1Fz6mvNfhLtZgQkgePPnyzvS3q4elz5U4uW26o9gVhb9h3cr19lpBPzDHqzdfRhFD8Hgukct26TmpyCNm4oY6W3Ck6X2r0/GZlZoq6miTxeRcHaOt1E/+u+Lxa3o9HHfBNzoRSojeh20+05SewHCQmkLXLmxQpOpIBIf9tgiXX8+mlUv8Nz7J8Q4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 08:00, Nikolay Borisov wrote:
> Resending this with the hope of either getting it accepted or
> arriving at a consensus what exactly is missing so that I can take
> it from there and eventually get something merged. As previously
> mentioned this results in real problems for confidential guests both
> on TDX as well as SEV-SNP.>
>  arch/x86/Kconfig |  4 ++++
>  mm/char-mem.c    | 10 ++++++++++
>  2 files changed, 14 insertions(+)

I'm still OK with doing this.

But I didn't want to sneak an mm/ change in via the tip tree. Any mm
acks or naks on this?

