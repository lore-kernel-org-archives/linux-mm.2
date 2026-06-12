Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCF9CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3A16B0098; Fri, 12 Jun 2026 12:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B346B0099; Fri, 12 Jun 2026 12:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1186B009D; Fri, 12 Jun 2026 12:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F29796B0098
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:55:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0F2B8BF98
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:55:03 +0000 (UTC)
X-FDA: 84871860486.01.FD26C96
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id BFDA4120009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:55:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g+xyIQS8;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781283301;
	b=KzI6X74P+2evKKA1xT1db7XJ0pgcGUieRd7aoRjUzgX2matISWZM1uOrmjAzY8VYiaZcdq
	jtRvl5dsSSGSTM5WHeRr50hzZjE14A6K7I+jy7lkl9P6aRwKS9mzJMeHHtgn5+7HrIUW71
	nlSYcn7NXzr4gO+NsrMhzWUD6PfVVlw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g+xyIQS8;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781283301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpenbBgdlmZ2ajTxCH9U4XWfF3aS9xJiwsU2Ue/VpZk=;
	b=3zaAmR02KaGJHKc9KVFyE/aS2XM1Z2v0XsfhLPX/WzNaPYW2yYNidgrdO/QsJ7aafeHJ+b
	EjvwupfudXpe9WecpWMokQLBarx33XxLgZnAwcDtX2mMHWfZOCidet7+jSaP2cuaQcW4di
	CRo/QQJ1Ng+A6AQK7mSVt3iTxzWMlnk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781283301; x=1812819301;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=e6ixytDpLguoEakheN4Up3xdflDoM25R4uRWBtGH4OI=;
  b=g+xyIQS8a8PezDGQA/RjgxAxUwjONH1hmYLJlS1dblFQlf+WmWzoHAHO
   fD6sNq64CZajzStKBrn2T2Xn64OtKtdz/Pk+VvnYqs+RYyjzcO0qwPfvQ
   +ZN6C+HIGcRSkql+K4Bnr0+cP8JsATYM2aRmm0nCJuakROcWPz/07s8gw
   fApvWFKRegBtCVOUCq6jV5On9L4fl7W6CTm8wplvck/VuVlIm8dryDtZK
   rGZBXexLR2lCJ608gsi7MyTC+xpF5v42XmlPxx0C0gcMtQaJTtiMUwmso
   Jxc/BXmDxLdvNyc9ox4ud3XuIjjE5bovNo65qtSL/lXJprYUo0bG8wYNV
   w==;
X-CSE-ConnectionGUID: o/n0RIp/Tq+tFBD3EypiUQ==
X-CSE-MsgGUID: 743/Jc1nTkm6XxykHkoThg==
X-IronPort-AV: E=McAfee;i="6800,10657,11815"; a="82179446"
X-IronPort-AV: E=Sophos;i="6.24,200,1774335600"; 
   d="scan'208";a="82179446"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 09:55:00 -0700
X-CSE-ConnectionGUID: jY8TTeikSn6Rb6V2QdPK+A==
X-CSE-MsgGUID: slPvLSOfSHCA1ejaigTHAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,200,1774335600"; 
   d="scan'208";a="277064747"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.161]) ([10.125.110.161])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 09:54:59 -0700
Message-ID: <e9e196ff-7428-43bd-8e06-dc2cf0628c9e@intel.com>
Date: Fri, 12 Jun 2026 09:54:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com>
 <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
 <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org>
 <876077cc-db6a-4517-9d81-cdfbb43e599e@intel.com>
 <CAJuCfpFh60wULMkFc7hzxWNg+qmZ2R_HMw_QZe5CNcDRFuoN6A@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAJuCfpFh60wULMkFc7hzxWNg+qmZ2R_HMw_QZe5CNcDRFuoN6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFDA4120009
X-Rspam-User: 
X-Stat-Signature: 7jpc3qk3i1hhzz13cp7qgfzr13frhkyy
X-HE-Tag: 1781283300-156667
X-HE-Meta: U2FsdGVkX1/F63dubZPGEyGKkQAFpI5cFJHIZYrUacghifQafgG1N6Xng+Ob5jGiqXxI0f6FnmrtW4GSefvJAlurDiJDYW0Tj9JJr/CfOVNX7+0dzG0tPTqfFatuhDWILKdL7GiIrmin8GQ7TQhGmH+ZJE7oTAg3WlNTklKZglpICS6hHm0/U7MXKVVQKgOEX6MLgfL6tdL4DVaTv88pA0SCaTEiJu0zkQmspV1NALsP0HbF9vzjOZVPbiWF064quFWu/b5QFBhb2pda6Ej66c+78RcqqDw/QjJD1xqOeUkgogt347BO66IjJVmI0w9kcYHlFiwkUUeU70mICQlb+19a9dKv79OX0u8Mhrw/DFm26Xqj/cFscV6SpW3xmm9wl5YFyWrVdplJOmjGPlzgorMdNJr1Mivzg/eHtwGeIccqrX36dg73aFG/etu0bfZHbk1r0b5Y6T7wyOsVBm104tkA8NLFxKohI5RBtQhE/FwNQZz/DtCt3hSMyXDPKCg5mb+5nB6EIhCok2cv2m0e1Q1n85eP0/nIE+LAZAXJMz0ic5Le1BRoLQfRigVtEA3NxyVcWH7Ku8TOJz7hVuFO1ObTBJNltPZb6u1LG0pbx+MJ3KWeJbZWm7GqrjvI5odCKQcluNVAdf/J0yICjZep38VurtM6UvAf4XmOCClNB3yD4IbxuXZ9QJFrklBPVN3lHrtZylLQ6XdC1r0HWi3dyPMTO1gAVdNUiw8eWBLy5LRTAKci3KzTDHjUZtVKb0vCPn90Fl3cwIotg0vyfHxMH+thUIGncZ8RtIuSidmoLq256GVPT/ABtp2l2YqW1cOgOjmSRuLivv2ycv8qDMNG1FIHZ1ECUBOBK+VQUM9+efz4xslNlcKTHndZAOxWbaCzI79tbJ+iH9MydjJBptu16lVrbqPSBkFqn4QD2KJ2D+ippsGk5/OKfl6lGHpl9eO+fuRmx5qYZpS1UjH7AZT
 T2mCgTZD
 1kDUZfMIyGhK6antUi0xo4VEBnSloeZTF47KE3tXr70XC5zSEHU7eLyt7NmzbEaqW/stBQMdkIQBJZtq1hV4Z2XzvZtwrUBiyBS4A2tG4dANoBdUnD9ZtdLRH6Eo1f5Vj8hGIErg3cWRpbP+TbTcrgCgnOG8jGBuG6tzTd8EPEp6enndd5CWiAw0qz9VLeSWWiUzmtIfEZDVw/AY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 09:41, Suren Baghdasaryan wrote:
>> I think the key to distinguishing between:
>>
>>         vma==NULL because there's no VMA
>> and
>>         vma==NULL because of a trylock failure
>>
>> is binder_alloc_is_mapped(). It won't return false until vm_ops->close()
>> finishes. vm_ops->close() shouldn't be able to happen while
>> lock_vma_under_rcu() is held. So if you've got a non-NULL VMA, you've
>> also got a stable is binder_alloc_is_mapped().
> By "stable binder_alloc_is_mapped()" do you mean it would always be
> true?

By stable, I meant that it can't change.

	vma = lock_vma_under_rcu()
	mapped = binder_alloc_is_mapped();
	<window>
	vma_end_read(vma);

During <window> it can't go from true=>false or false=>true.

false=>true never happens from what I can tell. It's just plain
impossible given the current code.

true=>false is locked out because when lock_vma_under_rcu() is held.

> Asking because in your patch you removed this condition:
> 
> -         if (vma && !binder_alloc_is_mapped(alloc))
> -                  goto err_invalid_vma;
> 
> So, previously if we found the VMA but binder_alloc_is_mapped()==false
> we would bail out and now we don't. Are you reasoning that this
> combination is impossible?

It's not impossible, but I do think it is irrelevant. Or at least that
the *VMA* is irrelevant in this case. binder_alloc_is_mapped()==false
means that the binder VMA is gone. It's not in the maple tree, and it's
not coming back. If a VMA is found, it's an impostor.

That's why I did:

-        if (vma) {
+        if (mapped) {

The question isn't whether a VMA was found. The question is whether the
binder VMA is still mapped at page_addr. *That* is best inferred from
binder_alloc_is_mapped(), not the VMA lookup.

At least that's what I decided after staring at it for far too long.

