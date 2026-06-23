Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1EAECD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEFE96B0093; Tue, 23 Jun 2026 02:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79F16B0095; Tue, 23 Jun 2026 02:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40826B0096; Tue, 23 Jun 2026 02:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD7A6B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:19:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 129AA1C2894
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:19:54 +0000 (UTC)
X-FDA: 84910176708.22.9C61916
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A6F38000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:19:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ngwieh2g;
	spf=pass (imf02.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782195592;
	b=mL6x4U71a77g81Y7zADdEktd+6aNS4d5/p/ai93cR+0tKneidcrrCqjANvb4EQtI1rUcBH
	luDWv2KEv3fMs2ujCgtraPvVlYgxT6atLg4lyJMNgMTNsCo855067a2HJi/c84Q4pWlX2s
	jF36hVpdzotsYIBlfITOJzZlNrW3n3s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782195592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbevwidXsiQP7SQ0MevxthNZxWNCXvmcji7X+6yWk30=;
	b=vkJchI/69mSrLeQo7ApBYSOfN2iO0lyY4ICkN33Jq95MgHOLt55fiVcqDDKfw4/K1y68PG
	UpCF+nviFCqgwzdKG+5dHExMhKmCKU5wkVxi1d0oAY5YAqnlOzBhY+4P/HKsrvSv81xypH
	YXWBMrmj5RA3bhHSO6xmFsomKQJvmug=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ngwieh2g;
	spf=pass (imf02.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782195591; x=1813731591;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OVl0lauamZ9UP82xgjaUBVhU9XMWc3+GnTCVk+DPPMA=;
  b=ngwieh2g/ibknlakFSLzWJYIsSecsvswIbgB3lERbm2+RIlr0y6Af1dM
   JXJE8fGaydZMvsffWevfq6MJQyOQBRRoTf04ITpwxyza6fImuRA0CBCWB
   5NBdXrKHBAaDJkdFjSMX3j8PjX+twqFn/jnO+p3ddGXgQ8Fhlhvvsr64G
   SkkT2qAkOtWLlMUVLgO4++9QZWwq3X0kHstj+S1Nbo68AEs9x86icpYM+
   ESHEeX3GlgOYKOMZTi9tbn7by2ciBRzcijc4zgjRP4BVY5vBWiCAMl+bv
   ImBM1LRmF6ZrsR/k83nAy7Ph6VNcaGUB9W8iLa7FHDdXf53dUMXN/9uWv
   A==;
X-CSE-ConnectionGUID: Ln4+7RmfSkas90kJzxYGaQ==
X-CSE-MsgGUID: REoKvGTzQ5OdklyWa7W73Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="93293815"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="93293815"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 23:19:49 -0700
X-CSE-ConnectionGUID: 7CTGyGSsSQeyst4z2E8mrA==
X-CSE-MsgGUID: 3FFN9xRISGGDv0urrvE/jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="248279937"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 23:19:36 -0700
Message-ID: <49cee70e-86a4-46b6-b690-0d48aeb94221@linux.intel.com>
Date: Tue, 23 Jun 2026 14:19:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 11/46] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
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
 <20260618-gmem-inplace-conversion-v8-11-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-11-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A6F38000A
X-Stat-Signature: wpg99bn7imemfstb34r8ghxegx7xdmb9
X-HE-Tag: 1782195590-945051
X-HE-Meta: U2FsdGVkX198edybwG/4kpJK6LBsKAhygL9c7SeIlWTj6GF3At0HS3vmcEJFV4O5dcE8kUrF19h5OOYnoKe/cfzXhdnjv7YAnReQEBVOd5oTpa5ECF4+nQpIUKIzwz1fwhCYNgEb5lCYohyK+Afc1pf7xs2LcbF5G4//2NtLmDBIyvMVjLNr8/jpR6f1qWEQ3O+dnqu1Zh35z9PFD0nvxqriJg22SiekSEO7t2tQdJDsoMIJRg7ovVSQry0GGpiDG0or6yps32PSHOX40poziiT9UP0TbT1V4tdi4YeB/vFHE7ElLHkIttTf/uVmTKaG5VB/3MM/B2h+pY4vXAAw4EQrAoJHB2XcBT3O8vzRxLqYIrNkbHhUA8WCq2YF+HTo/P7jgGNf1WSZc0bjGqreqxgG97sNNzYJMjYDA30onNn616SU6u/1g5EYZ8fSD6GUeDelIENOlYDrljVUPeKrDSRD9WuEbM751C1pkEWuHzJdpaVl7hijVKGnxs1JW1LuYkDe1tLezCyBLpgsw3yk62jUD62DE9VlcI5XS+9WXs0N52rXRzl8JANIJsKKdN6Noj7Q7U8skIDVgqfLtQQjlGtBMtQkZ8tA3gNuHSELL/Knc7pVKXnVcBuJ55Q9swuvA+I+R/7WRn5CevyAk8cXpWb4DeCpl6uXdCw+dl6jjQ500Rukx1Up2iosGzo9GE3/3ZJ14xtsYzLj/WRUMl0BmZLDnvHeH/VBSmyAyC0hSId0DqOszSeZaR6qM/5Sd0Lh3aEEAvh9F7iQXCVgHd+9GNyoNDKwHzquoc1XF4vGVqQByjn1nZq+VGuWJUmUBraYT1Ag0Q6pcbvr4mWMk/SG7fcKyOBVwIDDNLD2yUN2SZYO3gRr+HWV1BcCWXcH7bnjoVrczwq7xBd0iK1QS+45T4Ta8O3PRYtkCzdAwHcB+fFhZc8uoJoaknARyiyjzDoTNv9QS1/Lo3j5xYzdWhx
 /cdCMntm
 9A1oCVR9wxoZzXLnodNi0McvNn0nJ89JGUIJJf6Xv/UR3MoxsWgQ27cZdestuSj78arbrVZdGG7G/oddzqqcsIuaAQ3mYq7epXoLtaLhnyoqvYS6lgO+KjkIGoTgy7mfStA4TVzE9YfqSTZBYXqlyxraxqKYseb7gfcKqTsvTefbuN4UOc9RwPyyp6qng3TZ5DgVIHS0ra3VEjMeHuVoLKIYiFwNOyUnupjhGC76aKwJRfPGWL8aBSFKdq+4LKdiUzhKJZfo7ojPrYraHQ5MRrlblW+ZG9K49Y3T7ha+4F65PlQEvCeMQcCwIk8EoQrK96HGy39vqcJ8PwR9vohuPZZZijg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
> definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
> and so that related code is clustered together.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

After fixing SoB ...

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


