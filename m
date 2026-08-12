Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B16C5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 03:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842196B008A; Tue, 11 Aug 2026 23:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818666B0092; Tue, 11 Aug 2026 23:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730586B0096; Tue, 11 Aug 2026 23:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3DA6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:13:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB34B1602AA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:13:13 +0000 (UTC)
X-FDA: 85091146266.22.A766828
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id BB9971A0003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:13:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TnMfDSKr;
	spf=pass (imf19.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786504391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIkb+oNCQB6v+cDYDKk4WBWm0waP5vQ78vq/F2O7yiY=;
	b=Ru3GUyHYe5gdfh6nXEPenk+coCoECdCHt2Yfs7fQ5YYgTfW9l3NsTpwFiae8reZPPchi93
	cSirA2wDtOqpkB5UAJ5i2zafOTmhs0osK9i5hrQvnxItjoBFIZ06MZrTNrFw2oN1Cpy1Z+
	B8h0n57hwCxpKIjHZ646gXEdq6Svmvg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TnMfDSKr;
	spf=pass (imf19.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786504391;
	b=AG7LQmaSDVCW2PCjTDjp+tr65VHOzfISczy4JWwxq0KasN5P2056zphDFSxj0rstV4aSI3
	M3C1WFCXvt3P/uzT25PiKLwu3XQzkRnDHGYXmp2CA72ayA/Q+TycV1idOuswJHvLvMfWXc
	qTmx3SQxPTQvrzD104srhwr/bXu21Xo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786504390; x=1818040390;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AkKijx+yhl0VzD/BsT+PyE6ekz5n9cwWuOOi+c1ujAc=;
  b=TnMfDSKr548TJGD8PuteND1I/uTXa4UjUYFZJ6ippm3R/scduuHmxGV/
   8mOjngGXt6eJBCGlV+lhkcWWnJV9v8GkezVEmaZZ6xSEmF9nmNZz846Vc
   tBcy3I9O/M6FNw6ndxKMjX9gjizdYNYxYfKDeojb4q6BzP6SfhuzJb/kn
   /kz0Q9vl4C/NMQRUe0yh5G3ELUrRBezN/jmlZ7AxnbQv0L/HdFLr7fhB2
   J4VaYO0W+d8Ubfy/83KhcehJk53CB+Rxb5hGBjOTaY4ovOzrwrcVrFgg0
   srz6SNtb0rs7GoxsHFi35fEgc0/boKLs02fecsG+IxeyBb0HdDIVMM5XK
   A==;
X-CSE-ConnectionGUID: z9JgBdF9RZGgSoPfPO7/jg==
X-CSE-MsgGUID: hpRrSmRXTs6VwanGo5xxkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="87069590"
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="87069590"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 20:13:09 -0700
X-CSE-ConnectionGUID: +2b0w5VQSvqkwpgU/D8G6w==
X-CSE-MsgGUID: /572NDDhT8KJyc2EdBGfOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="267358694"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 20:12:55 -0700
Message-ID: <06f8fbe4-80b3-4d5b-a8cd-2144087e3dbe@linux.intel.com>
Date: Wed, 12 Aug 2026 11:12:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/41] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-1-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-1-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB9971A0003
X-Stat-Signature: 9mtwywi98w8k6dnx1tif8taxz3gzimjt
X-Rspam-User: 
X-HE-Tag: 1786504390-536829
X-HE-Meta: U2FsdGVkX1+FVncnDaMIa7tybI2Zjg3FPx57NNwjeI065MEbu1fLM3jR/A1Hy1ey0GnRiEg+fq9RGh+HDFA568nrSx9/edTjq8d9QiDTQAe+GP9jU3wrt+ILELi+y3o9dX/wwQ2pHP8aY9rP/yOA1KsLMl247CrYOgJdVrex8mYWTLqPOOtJh51rNBrJPcfdpVNTX16c7J/4Fha8Qrx3W35oWpup0azUdC5w1AJSkiQ7enNzhtNjsrWo6/hVCzfp/MCSF2tDekkWUTd0LmkVTq4SWrDkYwkXnWXZK8YBHoulKUwLYKEG4ePayTR7oEStIbzV9owv9LUgRp3BPEsBOIRfEksmuvncNYQDwXszaJ9z0mfs+OPSQq7BFNOLAgLuTncJnO/ZttM+NOfqmkoDlUKHAZm4SE9f5Gog5RJ64WCyrGtXewd8C7uSoFD8qOqBUjxzjx2efK6Rd8C2eTw9TeiYOycgISmUSAUU4WyHY354o+lzQId4L/uGWKTG6wsAKOD3Hi7zdP3BQ1AWUk8AxTKuPRdoeHJunKAdGAMExTi8eWyW7L0g/2x5mtKFTmiNGl1x9Oyv1IunYoxgCkdwGVrVhrFEpHsNB9/26PPP8syoCeGNMFZ24bKZcT0bnvwid9anprVwyCL4XuZQMIUb1sBhbUgLXNY2ksNEzunSEmaYT9cJs101eqh/1gLOKkAz3Gk5oTr/V/nj68KWZYZ63heFmpcxAtxPWMOwCDFl/UoSe8RCHfIaTgY+LVKSxww95IbhGLWLoRzl5MvHi5Z2URout+dZcKaruWCnyipbiS/2ADumIZTu+3k+EzLuobWBc/CufHotpsLE45pirmfoAeKTRc+/tvl/s7vCpdJRzIWwkosvCEYbztoSftUK8pKcmoCgGXxbthrFwUmZB8/09Zi0fHGCHE0l0WCajQguVhSvCt72JFsIFo4H5uqAgfr159gnTLxmT3akixZEPUo
 zJRJfCQU
 1/hCRKD5312NjJhYAIQearQrMj0/LASdP2SxVXEcXjXM0DFONcBI7ox8kOvCob2EKD8lQqztNIm4k4fezt8hEhSUVKoswZC7X/4nR+NQBIC0qcLXB9pbsj2RTzDwd+v3wXDIFsKeXWrlK58rUPej2b4G18cMuTo+TceEW0PFQGf0VzyX0cHsm4LFZQmYo+FVM56xAw1mDikJK0vlJ2T2HsmaH3Ij1hFkQX43mpsjynF+MejWcta2rp8lQ/IZrUI12RrUP9O2xaNtxvphv88Phe4Uzt3VlIMdW9gEXt2VDQP3Pk+QxVuJdtgFD3joSZ7tPZ482gvTGBI2oXiIyHtQbXyf9eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Using kvm_mem_is_private() when populating guest_memfd instead of using an

Nit:
Using -> Use?
> open coded equivalent.  In addition to simplifying the populate code *now*,
> this avoids the need to provide a range-based gmem lookup API in the future
> as well.
> 
> No functional change intended.
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>  virt/kvm/guest_memfd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b596486d184ca..a11cf6dc785da 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -811,9 +811,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>  
>  	folio_unlock(folio);
>  
> -	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> -					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +	if (!kvm_mem_is_private(kvm, gfn)) {
>  		ret = -EINVAL;
>  		goto out_put_folio;
>  	}
> 


