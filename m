Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DC9C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98A056B00C9; Tue, 14 Jul 2026 13:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A586B00CA; Tue, 14 Jul 2026 13:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A626B00CC; Tue, 14 Jul 2026 13:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 487916B00C9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:29:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C97D5C043F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:29:52 +0000 (UTC)
X-FDA: 84988069824.23.8065EFA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf19.hostedemail.com (Postfix) with ESMTP id E9A3A1A000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:29:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OQVTwuBi;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784050190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9nDWMGUUMYK4zdgmduf9ZJ/16QHCvDwhtGJVdrnzuY=;
	b=U+XBa8cLxgsIr6/wj+CXJoEA6RBC5WEThhoDPnnWY3YSfpeqV8qGdaKIEeJJgceN83QpE/
	zwYTP4MxxmLBp46+YUjhkx353DB0XRIWU1lXGShALEQGyeouCcxH/vHljoxG/A+hrQH3nx
	HpiTMcl3dxTD7Nbcqu2ht7R4IBTPV60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784050190;
	b=8AZesJG8N5tLEjeRqVzWed+b3l0gglGMiDzeelIUricE7Ma2IOqslFpwF/jhJELLsPSwj0
	3H+8/1JncxS+Z9HIB/+/op3yAblN2Z+VTQ1zTOVwWtqe0v/r7XuDxSbz6FX2fZmEq3SiSF
	fsJZ5cK2aAcgJtiEhCcBb2PBMLzT4AU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OQVTwuBi;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784050190; x=1815586190;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T9nDWMGUUMYK4zdgmduf9ZJ/16QHCvDwhtGJVdrnzuY=;
  b=OQVTwuBiH8pGI+8zsuOfzvbJMEaT2vHBdiHrf6izxTsdCilwAZjFuxTp
   wKuz5+eVvYM9jrsLHd8xz7FmZi1BL7uIo8vyWIzXV/HVt2dbePaRifrWZ
   2ASwgNxDxqHF+Oo+4rAMeTzt8SwUpxdb8AV/qm6Fk7cJ1gNauRAArQpzH
   QAE+DAEbh/3iyZdLGAHRs+ITqXqMhtmM2V1OdcwNV7bpgejrcqQD2kBkQ
   tbbktxCxF3+3PSYHuIUA6u6abba/tYNRTo+XRWpQin8YuoPGuyAbUs6OH
   LeETekGfTxwYWufTM8cMI+LGNxwXAqVb8/2BqcTD1HDfQBrWvZG87dh6I
   Q==;
X-CSE-ConnectionGUID: TPIYzt25TniBS37PRn5SXQ==
X-CSE-MsgGUID: y1/k0hY0Tx+mdg7RywdK7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84463062"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84463062"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 10:29:49 -0700
X-CSE-ConnectionGUID: JVAk0EKWSyOAbtmWxbWciQ==
X-CSE-MsgGUID: gb3gmc2+RamLrgmELZSMvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="259497092"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.120]) ([10.125.108.120])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 10:29:48 -0700
Message-ID: <13fcd4d7-0efc-4aa5-9425-8f4fa05c8eee@intel.com>
Date: Tue, 14 Jul 2026 10:29:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes v3 2/4] x86/mm/pat: acquire mmap lock on page
 table free to avoid ptdump UAF
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
 <20260714-series-vmap-race-fix-v3-2-b812eccfa0f9@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260714-series-vmap-race-fix-v3-2-b812eccfa0f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E9A3A1A000B
X-Stat-Signature: nmo44ipiouj5zrn7f9brsauam867a7un
X-HE-Tag: 1784050189-936154
X-HE-Meta: U2FsdGVkX1+c/27vE+sjFE+mUMFscQ1Fj2qXVIqVoS5tuZap5IjEnb7r12zy90+1U7xik98/5M0vMjRD9CI+6rqdAYs+la39VRxn1mF1WCI05HR4TRfg0BpSY9QqJQXQVUVoL4DT0301AygpHQoUikP0aEw6d2XUUZtD2HXJXv/qGO6I3Le/rSBopVEDRbZ/UPGaRl6c3nymFQMlE6Gc2qP/FJ5E+IzWUGZ17YiyqKI2U4I2vTjC2HbxnAR2xRA7MFdBDBBM2BqWFyObSc4O0nZOKJV/S16JvKlK+izFKy/4UjuJrfepSjdhUdjcFjo5IuYrlSgL/Kz0Mk1Q8vkjYv0dEy2S3nwmnJpczhJiVacsV5QIkhH8XX1zmcHDSn2k6nej7ExX9VBbxt2C5kRgeZXrt9CWFVE/TOcqrVEuYwbDl3JJUIlL6Dto5dJCvlxZZiFL70Hm5/rK3j3kPqkVnN7Zj2arAvyqdyRjL/Q7T74InijStIUPR0CCipdJj+zUhvhs3qp6N+u13pXfnoJmO9TX+l6jGcPxL/bCsdVBws+Su4JVf6Z9+NvolcFD9VnQPbh9Qp0D95m78/iLrf7SDSe8p9bWeE4F9MBH3Cm3fEhACiwKx1qkeHuNTJukKMHo8afv5sOje4cPxBamk5YIug6kweox+Rs0eZ+i/GsGF3Ugxk/vUTghtNvJj1WdovAW3R4k7uQ9iGKoxFVgzNasgexhEHYOPhpFZHKgTxQ7pYvo8YtI1cWQHMwtzXNYBjOiiIPoXfw4NfeXQHt12NBE033jnpvxu4CE5vVIyiX/fWR/2crzrOKHwDJDA1rGAPz4P7Ek4GlhYZQLOMiwNxXabH03AniLLU32z7uLt5TbLZp3EGzXhpfISB6ZOlBaG5QAZuQNFnuhfODkTUy03a4dQ/zjzywjvIH3N5ABgz/svmlIZQZFsfUp0Sl8dB9qPFVf39Sg9vrihFIQh98dqym
 BUamiDt7
 lGMng5v/aL0H4YRKxUJAmLpj3D8XjCQ5kJuoy+gxs/H1h2FblYeyiVlspEUuUdVKDgOEIQ09g6zjD/AmCP5rZibe4saFhpQYi6V1BgpEUEmTSoODutoH3KgT+kJnLTeaJ+1BKzCF7/8cA1101r4S55IsND7aec81r14FglQnbO1xFiWcQGl2GHqAnBAqZPFYfWYqb/iQc2GAz4h+Zakx0TKx7fImvZgf8Py3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 10:24, Lorenzo Stoakes wrote:
...
> Resolve the issue by acquiring the mmap read lock on init_mm which prevents
> a concurrent ptdump as it acquires the write lock.

The move over to locking on init_mm instead of current->mm fixes the
earlier issues I saw with this. Thanks for doing that!

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>


