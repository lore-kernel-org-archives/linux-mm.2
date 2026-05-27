Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FABCCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82D336B0005; Wed, 27 May 2026 14:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7956B0088; Wed, 27 May 2026 14:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658116B008A; Wed, 27 May 2026 14:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 504B16B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:32:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C4E9161CB1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:32:11 +0000 (UTC)
X-FDA: 84814044462.09.C2E312D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf02.hostedemail.com (Postfix) with ESMTP id F1A5A80008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:32:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R4eNaA8Q;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779906728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xvGL9opZP5afwmIgWWy6OW0RbAc5h8+AB+3QNjQSHA=;
	b=vYG0MNfjm1Vmy+2nzEVX08dHwvgz0s6brWHGkp/wyyyu3e7lRyIazgjyZTQtzoEgUTK4rM
	kPqq8wl+BG3iB5S1p5TyD5OqX+75fu2bVp85LiaJNoAx8hKVFl0sHUzBjub06FciAihete
	nNDR9G6cB6TlxdKZfvYLvGqWnyUNTS8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779906728; a=rsa-sha256;
	cv=none;
	b=lg1YZSpvrXO6+IxHV31uruQ8bb5qLEzzD31fzY7/3A4bN3vuwmGAg4K+g/ZhIi2T3Jdi8h
	hKfIBH4exUF6KcPClihfXYzL8jmKfPhAhm5zEONApsy+0MSRYBXzmxyD3rsa+h/ZTDmSjF
	BQut10evvRlHKlSOPr+DkPqteOyN/6w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R4eNaA8Q;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779906728; x=1811442728;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TPkih+ROJOD6MaT1XvmEsIY7B0ozsddGUPnGC2Ju+bc=;
  b=R4eNaA8QmWzHEG9mRhS20tQ0wfDoiaurjHGEHxMfx1vS/gcHwgvULUgt
   2uQ+mtmH6vaBK2onhBDCwFOS5URhEOsWQX4WRGAa5Nw7aYy0etSKzT5XN
   Ph9oR8Jdy7KEzr3x5bMd9TBjstsku0HkvPW9o+zJnVlWrVBUXYPF5qP0u
   bR7mVKphnF2bv8VXe2oKWcQPoYz7L4vmdq8EoFmRPpBUzD3XIknaDqnBH
   NWuYUNG+iJh370E3uwyFUGcUZQfbDYID/uR+onYLj71RDy3R8HX7XqcPK
   i0giAmNESEnxA9+3QdrwDbRMHLASLT2NCz40bs21BcP9Z2GuKVvtvc9Py
   w==;
X-CSE-ConnectionGUID: GUKAITQBRW2XZodSBAM/Hw==
X-CSE-MsgGUID: yfO3PXqwRAyGKvpRzSPWHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80473918"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80473918"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 11:32:07 -0700
X-CSE-ConnectionGUID: 6M4cEhyrQ4mGvqZaAjtA1w==
X-CSE-MsgGUID: fCMuuXCTQ9aZCRqYg8RMJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="241488628"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.27]) ([10.125.111.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 11:32:06 -0700
Message-ID: <bedd3f11-9077-4ddc-89dc-e21ee7aaab48@intel.com>
Date: Wed, 27 May 2026 11:31:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
 <0c20d1e6-1a39-42c5-8c94-9bd2222fb6b3@kernel.org>
 <20260508092341.GP3126523@noisy.programming.kicks-ass.net>
 <32fc4c35-acdb-4202-8369-ac0fe00c5b86@kernel.org>
 <20260521173549.d5aa510a710b4d77c3f7afeb@linux-foundation.org>
 <db4b46c4-823d-4756-a439-058199a9116e@kernel.org>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <db4b46c4-823d-4756-a439-058199a9116e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: x6hwb7psesymmgya6w75fg3rt8kp3dhu
X-Rspamd-Queue-Id: F1A5A80008
X-Rspam-User: 
X-HE-Tag: 1779906727-805095
X-HE-Meta: U2FsdGVkX1+pjodyFFw2ouZCCxRaioMzk6+Phm+oVDV9CaOkz3k0Pc1VERDvnEfTigDwvf49WnnsO6XQhy4CtLciVLkOxDet8x1NFu1LvKpW9Ql5x6a3q+h93nQUbbqD3AzBFM3oXDHoFMs1N9WGN+ocDpUlCnAGgzQdNSGjonuriFjpG1XGqwPJB+oEMeR5MBs1HzbkTHatIHv4r8lbefkf3nZcTJM2dzf7q4zcInaf6BzDKJkx/OBpUFV5pIE3oS5KsDaP8wbElVqoaiDdzl0wOVmMYFC+fC/+VpPwkZqhPKeMahrYwz1zqL32C/1Xv+DjKSSd+KbH7p1JC2BLqiRmnwpb1hj661TdvqnF/6NdkXqk7rqrkt1a6/Wd7aJH0iUee9rmzp9SQTdL/Y+tovW4fYvbZsNV0eRn+s7uQ6YsiUJOz3LcCgpnj+PaQUMpuvqqb756zzLFmTaChI2JTF7XNFPF4nWuQBBblGL2dbV+Kwru3onTaJly2Uzlb7iwmHviSts14dwAeVeo+U9xwiE7CKURDbjSIpZZV2xIHbayKlJGJtm+ITjZbETG2oNNHULakYeMC6BSVUh+z75dnyrW9OnbMGYmDyRdtEorwcxHooAgKGDdLnX6qRKRRrXNYx6n6k7x0iOh4JjTAgyAF2k8v9BzaCKqA6LGXV850CvCpW7e239TFROpwMXFHVwbpmjN/LgiA+mcb55fNf5ehTiVWI+wwGkFE23P0hrUXbhG4fG/wspXCoivbyJ3wZcf4UjTNkkFqA2L6CX93IrBINUwbFtNsD2pn34KwucN8ftZVOSIn8hSM0VVSVuOEdsp6DW8KirVrMWr8ZpbDpOFQUAC9CHhXuUFHidoNTFNxyRcr+P06phASRTHfOMgbHrp/CbJxxDRjl8S6LeIvF6BR4ZjxA7yOZYx8GnpLSfseQlu8IZYG2rFSIqDpGoMp0gwM2vvo2Sr3grnbT15FfK
 U3WCNtBB
 YH5IvJhBR1lCylq/HBNfKRQgWqEZWSEJK4SD5hzen9ZpJqDzyKuG56K9fhmXHsWCnwf6+lcYZ/vNtGBPqdPlC8+Z1EgHBtsvPfqAC1/FU/mDs6+HwK/IF3d+KcUttlUKJKpOkV8QGDEN6zY2/iwvyKpR9nSSMfle+vRh49jo7DgUGf2i8PVMpQ0zOyofcOB86ncZv4lN6/xWf7MI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 15:35, David Hildenbrand (Arm) wrote:
>> I'm not seeing this in linux-next so I (re) queued it in mm.git's
>> mm-hotfixes-unstble queue, for a 7.1-rcX merge.
> Thanks. Dave is aware and didn't get to it yet.
> 
> So I'll let him speak up if he wants to let this sit a bit longer here.

This isn't a new bug and it's getting a bit late in the -rc's. I'll
queue it for the next merge window.

Thanks for the reminder.

