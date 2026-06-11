Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6CD6CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 21:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182966B0005; Thu, 11 Jun 2026 17:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A246B0088; Thu, 11 Jun 2026 17:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070D96B008C; Thu, 11 Jun 2026 17:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED6666B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:04:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A03F31C39D5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:04:10 +0000 (UTC)
X-FDA: 84868859460.14.87585AA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9456AA0008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:04:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VW6NOXuI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781211848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fcg15guyP3tPZgenXV/wFfqmQJIu5M/lmI4fZ1EqBaA=;
	b=kI5Zjsis2S/0tJLMyrxa921gnUsUlhpprzR4b2QUfu3igpAEgFGY8MhBHfDS+G9m3DtNxC
	Z23wFO6gFdurM3PNXxBnFSSvmxAMHQt5Fz9DsEz1yPI5XVLUPtRfAanO8RjIvxOobtmT33
	FDCvdOMyiv7M7TrXEH6XL8txxr0Zk70=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VW6NOXuI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781211848;
	b=EEGsod+oc2/8zZK5QSm8B2BoykDNSt/cXVWmBNaIgNs3FdvZmEtfi3efjWBxV988RpQwza
	UAa+iKtA/X161xhCP+zB4T9MEe0zMEbsrrQ//RRovETNBvhPhAjUL7Pa/ITwlV69rKBslv
	sBWrUrBLaIJpt+rpPoDlGj2GQ5yr9do=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781211848; x=1812747848;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XDSUbCO16VkgZo3LublOvVmpMgadl7ko2l2nSpzc4+U=;
  b=VW6NOXuIytPpNfAuByuFH1xmHqEYvmyKgsyJVS424iAwd6S9MYYZ+Cro
   +3grpDw8n0dDV5oyXyYbOxrSDNTJSLnMBVdDpt5zea3hkSLmc/I8kTJGt
   /ReEYVZs9xnSVSdDzsagGLuB7h1ZTw9L2/esi6TREXwxSJI5oICl12Rti
   slNPwEdeV0G/MmBYEIylRmXGL5iZ85NVu+Y1sFgexUPma/XYon6xQyQZr
   xYCWjL1xsHxznw7lLaoUAOzwLstzzfXpcgqs0SvZfbYLczp7cRdnA4vqy
   FDFwydVBik/xaDeLhFE7bgieu7FNAYyBu+roNZuc175i1AHuPTUmQ/7em
   A==;
X-CSE-ConnectionGUID: lf/uyN8vR/KC/se2mLNC3w==
X-CSE-MsgGUID: huIzi69vSyGofh+SiJhLMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="82146894"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="82146894"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 14:04:06 -0700
X-CSE-ConnectionGUID: OZ2+virnQjSJjOUxUevWbQ==
X-CSE-MsgGUID: WObkYNGrTeOIkFy3Ag84xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="243673202"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.110.112]) ([10.125.110.112])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 14:04:06 -0700
Message-ID: <8ed21cfe-5114-4002-a53c-af43f337d2aa@intel.com>
Date: Thu, 11 Jun 2026 14:04:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: Add RCU-based VMA lookup helper that waits for
 writers
To: Suren Baghdasaryan <surenb@google.com>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>,
 Vlastimil Babka <vbabka@kernel.org>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230415.C0521C88@davehans-spike.ostc.intel.com>
 <CAJuCfpEu4HfUOVd1dTGdDNxq91Ts59ab_LiVPQEnxRUWUi3WaQ@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAJuCfpEu4HfUOVd1dTGdDNxq91Ts59ab_LiVPQEnxRUWUi3WaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: yjexgb4y5j3y55dpgqmzh6ft1kcukxsq
X-Rspamd-Queue-Id: 9456AA0008
X-HE-Tag: 1781211847-828794
X-HE-Meta: U2FsdGVkX181X2NUpoHgrZSq00U/XwnmoMFifheASH9oF2bUKHEu14Vj2kDhzywBPi9t4+9se9a6yhyyXeTPx/LBh9BnltqGZpPVDDTp2rNNOHNLfSdJTnb+oaYE7Bw/xG7sE4h6mj6OFi879OuSdKZBffrTWvGgGjw/51Vy+mHaD5TxgB0Ce5tXlTpuum40LF1lNyubmaPh/abFsmCFNnd/XtBQ7L2ZhxWNenXQXJRGUfleHkRhD0o47ihzdxOAyhQeKEFpPdUBzvEYQDWMp4/m30x5Itcg75WNmjqzAWmiDVAfbqum0KyerpFfzLS9S/ekZZv9stSvMzkXZh/EJDhrRKhXgQBeaB11k6yODz2oYW+rwg+UMHpMI0LLcpS+FPY0KWlCAbQHRtLRPFu24Z+5wfd8BL7QX5g6OAQ767cJ38vwuncR847IwGibxl/14pcHWm+n4+2aVax3duVDZi0QeSbQc5X22owOGxJ1U7eRk5PcBX8uPy4P2QHftvEZuBAs6xFmLa8dR1jhI7WjUoZ7J6199s0HORi5dnKR+ogK5eCMvjKM0LaKKwTBOqSRhObHUy1V+agb7X3o+5roO5kGiZS4n/qLFR1v9LKXjCGFIHpUsm6ZNrGRzLPpKZ8yrIcmtAYURDMMpTsVbwmBy1UE3ekh87DYnC8eGjmy0gRfyAblnBO8Sdw6CfiXvPq8bqiFZbO/IKJJPDJDFeVLbvh14PmcxmQiW904w+/mSDbcdlnm01XMADDY8sSBtCVl1YKSSunsyw+YcUIPLy5wns7egNrPmXTy1lGw81ChK91MTc0aadzEGwNPi+9wEmwjoHccqbfnwhENNftt4EdoAAs36P1ElMKn4X/hMLyPNQTNRwepk/XrAT0NP+3x6T29cy33id1Wl1qPxS9xct+wZ7BEGfbXOf9cWckv/MryEPs7ypdBtUrXOlBdwQ21n7L/DHikQsi7FsT4ZAwuui2
 LjMAqFD8
 j3JKp25YZX0iFb9x6Hcl32eVNEyaRclMlsual1caeXqcbDTnktYONIOCia4EwmIm5OVZ0206KB/38XgNVGD63Csbl9RwWKFjFpih7sryEC/kDndvh5etwtSwSNaIt5NLjPGU4v1hvPD01tTo8V+kbcuMFHEU7EBWdZrOGyiQ6T6bBGq2NUeCLZW20wvqkn6r0os4pgQ7wyGNoKl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 13:35, Suren Baghdasaryan wrote:
>> +       /* Slow path: preclude VMA writers by getting mmap read lock. */
>> +       guard(rwsem_read)(&mm->mmap_lock);
> guard() is nice but mmap_read_{lock|unlock} has those
> __mmap_lock_trace_* traces which we lose with guard(). Not sure if
> that's a good enough reason to keep using older primitives.

I stole the guard() from Lorenzo's suggestion. I'm totally fine doing it
whichever way you two would prefer.

I'm old school but I personally find guard() harder to read. I tend to
only use it where it is *vastly* superior to explicit lock/unlock. But,
seriously, I'm open to whatever folks want.

