Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F01DFCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE156B0088; Tue, 23 Jun 2026 02:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58286B008A; Tue, 23 Jun 2026 02:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21416B008C; Tue, 23 Jun 2026 02:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 775A56B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:49:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEA39166DE6
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:49:06 +0000 (UTC)
X-FDA: 84910250292.22.42E9C0A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf29.hostedemail.com (Postfix) with ESMTP id 22D02120002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:49:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NngwbWmc;
	spf=pass (imf29.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197344;
	b=pb2G+LKkgSikurKOOpibell0eODk83dOWhfgzjNFnoKn3JkvVPIYcPPtqeFpqXqdSE2uLi
	y5Gpe1KlKM/2yWK2DnKQwfTJCMNiaFqLOk5Kd0uX9L+xwAwuvdviRFiUwXzmMAAfoGsjT/
	PnDs8YHhWPKcUou68kUxIqNOD0TyP+E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jX6JDeUZhnv3+qZ3cVd0Yjxu9DI0rIGeFr0gUjtNfFI=;
	b=WnFCFcKfP8zOZQ57wlobbok+pfydJsG1bGdgb6yxeVmfO4IRVjJea3xGWnBb8lw5di03O7
	KUgTLYeM1JZ/OyNeyzv7OOuoErG2oCGh/phEXZixv259l5Mk680BCVFylaJcARftdzVKQe
	c1i48atAgFfJKmKeclI8ZTkWmp8fT/I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NngwbWmc;
	spf=pass (imf29.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782197345; x=1813733345;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h8AQJDX3UfNiJ86zepeJMtjP8yPCQGflfnfOwDXysvw=;
  b=NngwbWmc7OG8UbGHLcli/sFBNfuqyRLi39FbVJK4VlJWGVb20Pc2f9h9
   LCkWfST1ZtvQvmaf0LSBIfFeiGb36myyXQzrcA+0HKK0LgXsGgyT0rwUb
   rNCSpYBENfqaF4gUOn6ATH+gloEyrqlzqYoFmCPDB9Fe6I12KJ50n/5y7
   I1i1yHlqgiajbUrvJv4eD1LVfsnv/1qHVPVQcLEQXOxTtKMC4ZLvi5/jv
   1MbU2zvXThO1JsbcVWsW1cWPtvWYWha+76b5MtU1mzM2fkl2waNfQ+FhS
   2WQOGjBxzZzA6p+micNK9PaAy0ipe/OJgdgqGQH0PKyZ0f0l7WuKNc/cX
   A==;
X-CSE-ConnectionGUID: fZfN2zBORDW+KCg1+Q85GA==
X-CSE-MsgGUID: 55oapOVaQ86mmQAwrC0KEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="82701954"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="82701954"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 23:49:03 -0700
X-CSE-ConnectionGUID: UQ6n62bSSPGTWfszTIj7Fw==
X-CSE-MsgGUID: AN4e/MmzQW2EM/WlHV3RkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="243076433"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 23:48:50 -0700
Message-ID: <120b6d16-4218-4ba6-824e-54c62dd3d74f@linux.intel.com>
Date: Tue, 23 Jun 2026 14:48:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/46] KVM: guest_memfd: Only prepare folios for
 private pages
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-12-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-12-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kdp9wgynzp1pef485i3c7ie4crguuzcw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 22D02120002
X-HE-Tag: 1782197343-651117
X-HE-Meta: U2FsdGVkX1/o812E/f8eht6Vf7btmzWlWSRzGK543lLQWjjScMxnJZKhVFAdfM4CIakt+NmPYhEs/DHqz9PmhxpnqBrSZFiuYp9BcErZ6WUj/p8TJYNY/wsUxUELOeUMst85GtWWd1Qbmht65/gKNTWfxEOiC/NhpWIPAiu6ASUXbG4t13dIqfofb1qNx7apydKE/HDy0O0aETNpJCQqgDyCaULJaGVEleBkOm3lvsJtdrf+eQMeZoC8vI+txyb23948rKja83eL0G04gI2io2z4fsBaBHsBebIFNnYX0jApkwJ1OrFESfT1HZW4NowlDnf4wWluWifjT2zvnqIaUDaReCUapu4ERjGkoe5ZAzg8z0c/xijpAyxjdmCofgWRzxdyWVv3kqZq/nIaEJ4Yg93x56b+Ajr8vlRlSSgKESr22Qi3IfyJ+pkkMdEJd/jmXMdPTLxRlNzqmuDITe3dlTjMXR/s4xFV2fWS+vod8dbXZllEs1xlFeTQ+M0fX/cn8XSei3vJOht7mRFYxZXvUfzW4r3y5z6KN5l1L0ZeIFYogBJ8m4Q32VLhDKJYY0TODGFC7tay9IRCKQdq58PE/n2acPGsrFdMg/YTV4VVDa/zsowCU90YyCbXkb7kc3XZ8XMR+kS9dWzXkkP5TCKNZkCXAkY4xDAl21gCJiX7qPqsUT2ofSJtVQFwo0yHnkkM4r61OczHdx+YivwltAjJCmGcZ5uspXs8HZ61YpBZEDC+Dgt7sqi+KRkC8nBMblBBQHBHiJaItjxF7XFmI0G4W0n6I2TSMN0WS5K83+CwSx55XNfYesDu9zlJKhXxGLRmSgm7Qqe9avaQtcZnm7BdClhw5E1iukmsz9YDy+uqzn9OA8SLRVoqbOMQaQ16o/YOEPM6z/cGTOq4OETOvFEK7MxF0pLjDTV5VIWVwB9tQnXXCvm7P8f1NuBoeI08gp15E1lnoEeih+wVasu14e6
 hZ8o9p09
 ktP0uxvSvswy6pr8P80swtBW+5Dgf19vq7OCSEWmw8ZDaggVCU2fVEUVKqdaETP75E57H6+1kaRc3Ly8OgzVeKb6nUICokhY0YAs0f/U+cNuPzHMb6wLlvVpupvR7014Xeil9ZciWpBkak5cPAQKk0Fa/ElMTSXvbEQuESPRdJOEPSPz/Sbr/8ZWYDR7iPuZUjZmFL8UIjK9kj1gozisN2FYlH1IE8mQoAMP181epPy2Ch01rT9PhKzHveN512maJEwa/BTTI+9q3nt/RXYvCypfBraFj6/jgFESQrwFSEKGToli7BGl2b75+5ppncaP8XJyZePyQAwnuiZ7XAzbQ17cJ2ejnHyImAAc1T83zna9lpMEPHvk5bmLZWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> All-shared guest_memfd used to be only supported for non-CoCo VMs where
> preparation doesn't apply. INIT_SHARED is about to be supported for CoCo
> VMs in a later patch in this series.
> 
> In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
> guest_memfd in a later patch in this series.
> 
> This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
> shared folio for a CoCo VM where preparation applies.
> 
> Add a check to make sure that preparation is only performed for private
> folios.
> 
> Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
> conversion to shared.
> 
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


