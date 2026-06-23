Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A491CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61A56B0088; Mon, 22 Jun 2026 22:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12926B008A; Mon, 22 Jun 2026 22:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2AEC6B008C; Mon, 22 Jun 2026 22:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD416B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:39:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 055D640360
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:39:35 +0000 (UTC)
X-FDA: 84909621552.21.941AF3B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 02437100002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:39:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jW6WODSB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782182374;
	b=vHQLRJJErqUHYBrwQiMowvQFtjka5b0gULGPN1AYmkOG3yzyYvmM2TjLdtUBE7CX6BWPLw
	sRT8RY4g4yhaDrAAbN3sQyeALF6MSJ7rZhTRRMYuLBZ7qc6nctW3UiMY7WDlxWyGRfL7nx
	nk4wjRRVKqeu2ezZVbMaUcEBhRYLyyk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782182374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzvB8g1T/a284WOGnvYsStebwn5aGi0+beh7T+/4S7k=;
	b=i7W8oWhXFlzueGn0JjLlOwWpQkIJUAjD9LxeZnOzFuCceG31P/fcYL7sVPODHBObr8TKwh
	MzemsEi2a4Wiq10b+ywm/cYG1xMJOkezkSw9VwYK3bBU8agH28I4Dmzt/0dw1BS4xf4MLu
	lewEM0PF95OAds9AAszrZGdr86zF7tk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jW6WODSB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782182373; x=1813718373;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/A0PS1KBXecicXMwu0KgF5PdNmPIby5wsNW8nHW++bE=;
  b=jW6WODSBHcVcEEOtqrkwSKg1uV888raWg9tfhpaaeGrduNBX1iwo3Ya4
   tvUgWVW2av9oUaBktpCgZSaTarbJaNxRR5uDLaJkxMmjFNqQZ7vvSPhmD
   dsHnK5oqxrFuo46rT00fy7TBGo+rPEDsy4p2J7ISMHdyZdgGjMWMu4DOw
   EnlYHJLEjVD87CbpoHUjYkjVeyJ8w8dvfOsE4OXDIT90nXRVxGLnQIfsB
   RDzTfDek+y2n+MfhoP79clFdbOM/fHi3w37KrU2lTsJvaCIqzP9Dfg1/M
   5fvlEwy94YUH2DSPjhrYeoccDrw5dvE0uc7Pd76/jEgMHglZughTY7AqG
   A==;
X-CSE-ConnectionGUID: LWePrdKzT0qQqDqWpO+/ng==
X-CSE-MsgGUID: 2+S+l0gVT7iwrWkk3vjdTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="93281955"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="93281955"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:39:31 -0700
X-CSE-ConnectionGUID: bAXEwp5sTTeAhs29D3ojQQ==
X-CSE-MsgGUID: arY23Fs/TOybNGBssQOy7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="245254055"
Received: from unknown (HELO [10.239.158.46]) ([10.239.158.46])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:39:17 -0700
Message-ID: <9f81ea12-98c4-4ce6-a95e-233851dfe8dd@intel.com>
Date: Tue, 23 Jun 2026 10:39:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/46] guest_memfd: In-place conversion support
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02437100002
X-Rspam-User: 
X-Stat-Signature: j4moq4ghoeiupyy334rhwmpwdrbhioaa
X-HE-Tag: 1782182372-699269
X-HE-Meta: U2FsdGVkX19m5XuGAXS6aWuW1NuptCfwioQeBXVKiJM4nOkDMhXnLEPn0e2grOcf6gvgl6/83+Ly4L0ey6J9PlOsYf56A+sNr6DkNlNP21RK795sw2goxlt1LfG/C7WZl43yCAVzUfdFAybJMbENaLI3KU/64cH02B2/Jj7xoyWqMVGX6mWsx6mxZPKYCLcnC+A2eAl0v6WHRvomH56Dp7lElOdDypfnKpPRzBob2Jcx4wNbDY88s9R+0317tjGP1sMHc8ZHafq9/wbpKBpK7jOeqCKMt3r18nAqvOlHpB4Qj9L6f7G7DTo4bpTPYpxm4fB7eE1ThRUdhYzz093Lvc/lWv7U17fsjqO6kF0Yrk6kJk+VtWkNiY8LeGi7yZtuV8egLNWZWa8s8Hicw+78iCb5/5/TIhdj3wlwyTTbpyacruhkwa6Xk0tpuvtzkmg/fWUol936W57iv4u30NaqLHpFJTkyKYaZNc/Yix1RQ/sah+7tmCvLno2DIabzQ0hmbayX+iZawdaDNyk9WZOFwng2K48r+xsAmWQuJd6l06tI9sBFS6adzwAv3yYPNC49VrdD2tarsCix2nMm9vcVmYusvFF2fM0Cwz9dVZB+u31naV+Z2d6YG5SxWwfBTpr5nBHX3PtNZDqXdSibmJYb1/aBkhDnaG7r6gDkBGkoHSmfX5jIjyX0/jST+bM/VOTza9RFFHLKvHz2tY2E/Q3r3lsgqpxYZuBe/5HVm1F6pYhmfvjTn2jCjHCdcm2Kp1miq1zegXqjucd9kGHxC45bTuSb/YZp/U9U0nXS6f+1oI7eRcXmw3tYfZCVc6tq0LyTVmq+2cRvPj+gEjWNhSfA6e3ilBBBS8qrHsO3WwDfeK784r/qN2r+p5Z0kzuh34pr7lKYxG8v60t89Bcrk2WrCSlDXi6AXJHw3wHHUhs1qyhZ6aBgobsvklD/VrKhiXrbjgyde0kYiK23htgr4La
 XDTzmUSP
 H7xaPJlmvtlzuXuE3ct2CtpJi6rfOLsf6W9iSYms3/owaQ57IfyvxqdyBPeKc+Cb5+H8d8P2Bew8BAO59sTjUmwI+2tlLWko4H5JAZvh7eSymDPlOAfJpDEd85T5Vibz8nduEXdBRqSUkLo41zMMsswgPpCF/RBU3igME+yO8A2dIKk9RVUXwyMPe5FtwYzG/qcq9nC6dlSCP/H/h34DVRiB6b2OXs0nCsRDLA62sMRuYzQAGbys2Qkr7P3KbVyO4RPLZC6nJp3dWewX4PHkzG0RYyg1PUOHOu7NRrAJDt7gO4pM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> TODOs
> 
> + Retest with TDX selftests. v7 was tested with TDX [12], but the setup there was
>    wrong. Conversions were successful (no errors), but the shared memory being
>    tested is actually in a completely different host physical page.

Glad to see you knew it already (I was going to report this to the 
original POC TDX patch)

