Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65747C5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 05:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356066B0092; Wed, 12 Aug 2026 01:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308B06B0093; Wed, 12 Aug 2026 01:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEBB6B0095; Wed, 12 Aug 2026 01:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6BA46B0092
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:23:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6093E1401A8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:23:39 +0000 (UTC)
X-FDA: 85091474958.07.7452BA2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf24.hostedemail.com (Postfix) with ESMTP id C1388180008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:23:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nOU+bDHr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786512217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MRR1sD/tt7yZkFJEqu+9wLuGs5eII0ImDAAOpbgLmg=;
	b=anqG2vz1cTo4Rd1TWjhPHIR5+ZofDZ2pVmJwoxojskNxzrQZ80Et/YvKL1lkvO2LuFUoiL
	/e0c89NYqQ6BBSFwxj2wY7CBD0rT0Xk8OZfff3RJ8upGuI/ZcGK4LvOgu0bN1GvnNLbeI4
	1HWOTtnKb0uwXdKi414vmZNW79uTh7Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nOU+bDHr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786512217;
	b=Bs1Z7EcJu7iL/O5Qy+IbGYLU+m9dP4FbOFDtm+O/Qz3HT2EOAmiNm2AaDTgEC1GYIy1Bg/
	2bq3JBCuLu2CXkUBIiyQ+UFBhOlt1n+liEVCDQYJ5x9A2U//pjE4O8+c6ag0S61IPKNDu0
	q61XWQctCtezcMYxYAVQb/zYYsP6I1k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786512217; x=1818048217;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iE7WD9cC5Zp1jYTzEd47muCzZZ8TB+7wVvVGgHiezK0=;
  b=nOU+bDHrWwJ7Szki4K7EKltw76KaJderPgWRE8r3cQiZVZHbUqH1BuzN
   NvyyXE8OmZ7D5Y/87b2ToPL0fjJugoGawjqYKEytAt+4LdDO2XQgHWiyf
   tjK+QU20Bx9gT3J2dMNPxzswLk/29rPram1zbGc02skgTIhvEGE1rHsFo
   43hNzccYb2SbaqPFV8e4BPwI+x/oORQl89alZi1iBP6PGNz+dFIt5C418
   XjowrGTb/dcGuUrxe7kXGRAMW+Sty+EtvHOuR8dLRUdcUwCvJ5SdAYLQj
   N+MbCjhIVOAC1T7pyEd/7M82yuZzfH3Px+o5F4o7ZjBa6NjCBFKMC6RFh
   A==;
X-CSE-ConnectionGUID: 1nN4j3Z8ToKU/3NB9J5B/g==
X-CSE-MsgGUID: lY9gxH4ZQo+1dx1gu9ZDJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="112600175"
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="112600175"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 22:23:35 -0700
X-CSE-ConnectionGUID: 1SnU3e7vSsmcahYLs71EJQ==
X-CSE-MsgGUID: KGD9BSXaRIiKAaUKOK5hpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="261785396"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 22:23:22 -0700
Message-ID: <3722b4d2-ef2a-4ab8-9a24-7d61a776b05e@linux.intel.com>
Date: Wed, 12 Aug 2026 13:23:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/41] KVM: Rename memory attribute APIs to prepare
 for in-place gmem conversion
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
 <20260807-gmem-inplace-conversion-v10-5-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-5-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C1388180008
X-Stat-Signature: 9yyht37upjsa5skpzwyfzku1qsjf95g3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786512216-295501
X-HE-Meta: U2FsdGVkX1+mxsfNB+OO/iAY6lwOfVv0i5+7lRPPtI8Whk2Q+Mew+PW7hN8g43WBPl19VhgnbdxiHw0n0q1OGmJOLKm4ekC0iEzfFiK2uCbfUI9xA9l/g6edU4Gx7VyWg6szXaIv78+xKGeVH/ifHd7ZQ6DUPZU8JlEuUmvE7243AZHni6V4nuAUa9BFO5m2fYCZLRbrdaA1FgNJY1uN+yo1/azJVT0cqM5ulcZpgFl3dXQfYeHoFebzzdYxOeJlNeCod05SZoeL4Vjmhnh+eVkCGM5eYb2gi8ThkS9gL5V6tep/eIYaLRADCG/2FQWuDo93bI7qMLB6MvIuCqJC0Qfsfz0+U28KUssH7I1Rm0s5YAnb9XNYB85ACMDrKZYWvHUkIobZHRQ+cfD4sLLwN7zzHf6z/6RSJEkq8Lldy3owZUWRcCebeEvkHHA+JGxwXVh2CY1XFl49loo3e/BOffD6nDLfZkznO1UVR0pLgrU5/86hfBkuGdG47/bAlr/7rswFicHo+8ouYxe4Wk6NW3zr/k+BOxYe1y+QxdjpoVc121QpT4oyzhADyAmm+AdRSoFvy9vcnwB3tHQ/X3iAfrkFWWq8JxCHZDtbwFFnjEK9p71aWL/bkH0YsphAJmDQLin2D4PQOHjFtVKfy6gc+HXTESDbO3/9/A1Bo1Nk+9NtmxVTz0gTWUv7jxcD0nZ/H4SOgr2ReDen7Nvl0m4leajLuuqyzVKaGKORXNBYyOgD2ZNxl9MAb96Z03fHHrEDHgQZsFIopLDvRpNuE99ZD3yM5IM0qR1il0AK8edSxYTnEQAZaZBq4mAHR4W0P6WdcuyxRGRTaJ8hq13OPzRI3eaZc/KAEPltxfufXULmavKDj2vf9c+dkMqMjxLY1G+UFJDVDoZ8GKoNe9viFOSVU3lwz+e5nPUfEZCR3tnjDfR0ggSBtMctrDy0zB3QBtJa7FHn81VlAB0/94UR7wm
 I2UCC4FM
 b8c4mQ73oJ+qe7oxLHt+8wD0G+fJXpkpSmJo4dVdc9+s0pP1wAbfwWN/Zl9DhEG4V9bNoSTdYa0p8p+I5SuV6d2RFCjEMuTzjrA1ql9OKOPV99pyJlkStKHUPZ15WpweItldQApC4J7O6twgSpKxRTvZGOyrivwE086H6+65Df5foUZE3sDPRuFUlIOD34AOWNAv4/atcKSe0eH0gBsZHt6iq9uZUOUkqJmtlId8qkmKvuZyNrt0fyjMdRuc8NslzIhMXPxyPcfzp/oUXzV4DJCWIvaoIOvJ5Khcd/x1ckzaCABtcmCurQttmzOFoGUFDIemm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Rename memory attribute APIs to add a "vm_" in the name in anticipation of
> moving PRIVATE tracking into guest_memfd, to allow in-place conversion
> between SHARED and PRIVATE.  At that point, there will effectively be two
> (potential) sources of memory attributes: the VM and guest_memfd.
> 
> kvm_vm_set_mem_attributes() already has "vm" in the name to indicate that
> it is a VM ioctl. Rename it to kvm_set_vm_mem_attributes() to show that it
> is setting the VM's memory attributes. (Drop the VM-ioctl scoping since it
> is a helper local to the file.) Update the accompanying trace function to
> match.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

