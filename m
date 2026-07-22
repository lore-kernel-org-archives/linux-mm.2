Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C1F0C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476796B00C5; Wed, 22 Jul 2026 13:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427FF6B00C6; Wed, 22 Jul 2026 13:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F02F6B00C7; Wed, 22 Jul 2026 13:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC2456B00C5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 720DE1C0241
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:03:08 +0000 (UTC)
X-FDA: 85017032856.21.177D50D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf26.hostedemail.com (Postfix) with ESMTP id C73AE140004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:03:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NuKdz8PH;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784739786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAtp/f0KBNYnxuK/vjVMyjiM1pa+SortZzj8/0++AQw=;
	b=T4GsVEH49ejwcvKWQUoxH8LL1H/iciUcSgqhcd+TVhIC2/YtD0w4roqPePGd5eSMDoPi5O
	6NXBMyzjNDUyuFB2iCeLS2mC171jU+ajDPJml5e9LrWRgjoa4GxVp8w4KPa0LoB31o5ZhY
	KJZ/qaYOVpfQ4vIqMfNJoNIUNLKjRp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784739786;
	b=tJ3I66RgUoUIUflyRPJt0DpdD9siJEkBykwV0pNSiR7VbLyIHAWACY54n6zuQ1AAXIpSKG
	3A6lHZJLGNxxvvfQXZNQTCNhZnD+vbJNY0RosdB33sceH5v7IYLvPfHhXdoKReQyLxZwUn
	774e7jnaJ3IDIQFEFgfxzYUq/EOuVM4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NuKdz8PH;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784739786; x=1816275786;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CIbTX8ulngl06DGA3pmHrz2wPzRWMpkv2qZDGCPMo1Q=;
  b=NuKdz8PHYl3mihpHcHollSUO+e4m4h87tW0ZbANhx9mO/L0h5u1mF5k5
   aQ1U4WfxAGwPDf/8xZdIz4CoJIPfiNIpmukZSI//iKWKWtJISb2J1AkWR
   SlPKKOKGI830zgj0WhkOeRsBeNl8VwSSxxXjNeFhU2VIK7sksvNtFYs8W
   7QNOZA6RnwrZEDpqq0uFzaAQvzS8OWi7d9f6q8OTiJ3/rwiwqnEE2nDjo
   C0JFzuH+TWfIrai1T2EPRzAcL5xlxtzQiR0A6HMwHeKlABGOlLywbCeyC
   jjN0y9EG1ETHVIz3DmvmSooJnaHjZ+tIlNK9+8HQ4mUl9/42CBaNopSGa
   g==;
X-CSE-ConnectionGUID: QGs68AQ0Tairion+cDew7w==
X-CSE-MsgGUID: uWo0Jv/+RAup2HCnAZPyKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="108172611"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="108172611"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 10:03:05 -0700
X-CSE-ConnectionGUID: afbeSCRhSV+tqhS/W9bvyg==
X-CSE-MsgGUID: vb5o0ZCkTXmWUXF0lRl15A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="257603458"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.58]) ([10.125.110.58])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 10:03:04 -0700
Message-ID: <fa75382e-878a-4064-a9b1-43bd2c9dedce@intel.com>
Date: Wed, 22 Jul 2026 10:03:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
To: Borislav Petkov <bp@alien8.de>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 loongarch@lists.linux.dev, x86@kernel.org, Juergen Gross <jgross@suse.com>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <20260721171943.GEal-qLx4p5YbocQNV@fat_crate.local>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260721171943.GEal-qLx4p5YbocQNV@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C73AE140004
X-Stat-Signature: pituw1qb1t7y18yiz3f6ru51ro9ujbnp
X-Rspam-User: 
X-HE-Tag: 1784739785-570328
X-HE-Meta: U2FsdGVkX19hMFQH0NXpSwhyTVuCGsM2kUyqj3vLv8wTdizlrvVMQb7A4vDVZAPv7/jMN5kD7I9TAIqJKhHxQdofOvzu5Tker28z1QrPtltn9RN6i4Sj+vPa1gbTOl/zJimPqilByz+FVc/IbaOhBr8EXWnfn9+4iN2kbSzYx6q3PtowMn/qqVvgJ9u3S2acnb+fk7KzyOLcgdNF1KtFSxNp+CrvRisolBLrYL904MzBYIjZnPNUNNXUzh+8Pnjo38C86Uwx1OPXYWi8Dsq4O2gmFCI14ptX6N3U1tIwtALHrG9F6pHkVgixBs00slqDXib7HZqHZQVQTuARcAWDGdYjw5frcB/kuXzfSHrc9/H57PezOfsf4Vbig42Xx1PXeZae3NlhIbpALEfE7pm+3xJ/Hi39Q0oTJBQQc3ABYQzYIGETBtm5ccD+ZmNyAHyXmVgCMG6D66FtyMDVnoe2qlz+zLqlrIflxFkIItfs3x32ZoISU8J4xA4dglRZUsriK9jRZIaOpZbmmcqq1Xj8KcN02MGJ9Gg0vfV6dWT2uQPCkXm5E+ktk/92FiyDE/vE1eV5dusevNWTXgKmrqroAfwnqDfoG59dbcIvZCu7ie4hFvj/LBTDAZ0OPBQx9RQ9/jJQTq0oTaskkK9eRZSNuRFTEGF/LocC9lzKMI8X9ybnrIlKUNRtUXg3g2wkOYA/efDJ0H5jMk4+W5J+P0htsIDLMl52b5XW+Akl1CaoY0L0E2g8KXKvHWrrJpYz6UAIUxSx/1Qb6UBZ8FCoSh+tkk2+O4K+0L0IcEgJKhzvCmnUv4hHGQY69wKecWWCdkINmwr+eP9sIOM+rZiqp6lJEsACEcBlClJkDzvX1InppqlUqjwB2TRT8sQkmWtEvj/bA9a+fjeW4c1bfS3FPOpe8Q4ZIkLo13rat68MlsNMfjPAyMpViGCK7ifkV7Ht3WDwJTzDo3Gv8CjP7VnojwZ
 H13HJhWa
 t4wFYgrlowGF510rYzx3hFzuDsgNHBgWAb5BJgxU7wN+LrSkf9bbS+jY1M4GKyFbtDUg56EkylJjF1pBe+Vgu5Poc+nxoj08mVCp8YbpLE+xZfqoRaWpePiFEs0dBCkG2XTtUYahHdB88+KqLIuTrNyKPmCHTzmeREUNdLgYfZ+EbhG8H9lsmP2ryKR4TARVNDUtaQL9tBU9ZYKb6TRfzkRjeJOIRLJvxXDDO7Pl40EgkMBvp0OVc7eNXyNu8jZFkJgY4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 10:19, Borislav Petkov wrote:
> On Tue, Jul 21, 2026 at 07:23:23PM +0300, Mike Rapoport (Microsoft) wrote:
>> Currently there are 6 independent implementations for set_memory and
>> set_direct_map APIs.
> So with all mm/x86/CPA patches flying around, can we first agree on which tree
> is going to collect everything?
> 
> And if I want to review patches in that area, what am I applying it ontop?
> linux-next perhaps...
> 
> Let's sort out the workflow first so that we don't get lost on fruitless bug
> chases and fingerpointing.

Just practically, I think this series needs to be ignored for a bit. Bug
fixes first, features and cleanups second.

When the time is right, it probably needs to get get acks from all the
affected architectures and go through mm. Folks can ack it now, but I
don't think anyone should even consider merging it until ~7.3-rc1.

