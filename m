Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359A5C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 22:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCBDE6B0175; Wed, 12 Aug 2026 18:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56536B0179; Wed, 12 Aug 2026 18:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5F16B017C; Wed, 12 Aug 2026 18:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C95B6B0175
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:20:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9181FA2B05
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:20:29 +0000 (UTC)
X-FDA: 85094037378.18.68CFB91
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id AA698140009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:20:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ccFKTMqT;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786573227;
	b=8g2MjnCIRupn8r1ZDL/fyYjIM7SoVKDj83TTHQwDLArc3zFCAps+KUF6t3vqoEKTyKFKu+
	nrgVGFj220pbGBPBex2DywFoMNA4GsDBvTETCZnql/go39A9T2qxuyrmjij9Mh/c9RHYXn
	p4ycnQDch8iIOL3Whc0iRj92cGROi9M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ccFKTMqT;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786573227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ars4TNtE3G929byYxEDQqHsyHn58hMZcpdS4Sv71JWc=;
	b=1pelIEDR80TI1ILF+8djx6MjG1qlzRkfTOEgMbFOu0H+HwE8Jui/9qVdicCVi7dIuXYR7P
	/9tiBm492MNMEebgnftT23mMoxlE3Z5DHzLrPp5Be4DtXoKmCf80iwbZr2sgD7dotMNJNa
	qUOmD/JOs+tULRvGRVZf9JwenrRHZV4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786573227; x=1818109227;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YxLZ64E1GdPvRZ5LGKEPY82I3i1UumiSn75DwWCccUE=;
  b=ccFKTMqTaagxycVGl1yLqZq5nej3pJVx3iiz18eUu7gPHVx8kjjP4ivb
   c2q/oKCGhTHlRnasnWX4CRWp3s5IPX1Y4NfHx3jXKIN0xYBa/kz1xZr5r
   cdp50x7XPN9t/nwM0YzXpGeSNwLFcoqofLaCOVs80nfwQwrnSxdaiC+s5
   K2JchcJxySrw/dzoVaHCowqBmmH4gojErqbsLEcvFHjVPD6d+p1KzEZCX
   BmaxowIznSu4lfNSo9+K10VgI+qjhgSrtSCiou9pmO1HfavXUV1drIsbi
   LvX9uTtMfSoFW/eAhceVf7SsqBo91AqSlmkC+Q4E/whe3xil/jjsMWNcY
   w==;
X-CSE-ConnectionGUID: VrqrH4Z7T+CugAWju4eiDg==
X-CSE-MsgGUID: hYgEkDZnRomERfvOZAu0qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11873"; a="87021715"
X-IronPort-AV: E=Sophos;i="6.25,220,1779174000"; 
   d="scan'208";a="87021715"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 15:20:25 -0700
X-CSE-ConnectionGUID: xCREYhKvSy+NW7YeZdCQJA==
X-CSE-MsgGUID: fIo+W2OsS7C3mtlsNHZK4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,220,1779174000"; 
   d="scan'208";a="262456670"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.110.206]) ([10.125.110.206])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 15:20:24 -0700
Message-ID: <90c2be6e-fe03-4da9-88d2-fe4d4f745cf2@intel.com>
Date: Wed, 12 Aug 2026 15:20:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
 Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, x86@kernel.org, syzbot@syzkaller.appspotmail.com
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <anCwUb9lV18v6mfN@kernel.org> <anXp--mLLEE2Qo0g@lucifer>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <anXp--mLLEE2Qo0g@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA698140009
X-Rspam-User: 
X-Stat-Signature: 5c8gwt51m34h61x9rjwofnf1dtjyxjfp
X-Rspamd-Server: rspam06
X-HE-Tag: 1786573226-958187
X-HE-Meta: U2FsdGVkX188/kQFVtEDqmzJ+xxGmju9VSxZye6YyvCmc1cyJ9wL6yx5TCC57+XUJS4YI+xetP3E3F8QKwyXVYGiHVop51JdG2s8olsTnaRRrX3qqzVemkh2DOXSe7M5iCgIkZAc9jn9+m22YHkLw2l77nEkreTmeMRizFDH0uISkV78xycd15doEw3Lxms7fUNWa0eGTNS0HnpwfUcOR5at0/bTutLNGJrCEymyaNAs+st8PYa4Fo0OE6bmQCwEToSGSxH4WCJ0Qk1W2njlpjsl7cFV/mm/+QHvWDGFYRgeWjZQNfGlZuflWfcNj++tlJbOyTh66f+hfds/dk/F/U1rcgzlioL3ojaMwTGE73jkUz8pfnx9xUSZA9YAAGsmVJ9rhwCiP5AeZ8g0VWm5ebGxGlI9P/5unEdl1wuf5ypAtUvIcvO/ZXzhpV4imfA4nEDAMmSSRt6i5bo9phGiZkU5zJH5aEfr9yXm0LH1Gp46vrVn3N1tRqf/UqccsX8UkCkOp7m2jvNBqnRBGqXVh658zeGcwIn3LKAU7tAPT7x5O5B5fUtYgfQA7Y/FprkjBfJoOYV72la2J10/PVQoTM1fHRpGvjngf+gf6Nf7EIEdCbMocND4YGApGofeGTrJTaitf9sftuxE2DbIsYmbcLJxXvWAokiMOBktY/6rbhHxsmjz3bpl21IEqUwzdbNqD2GRNrk6OXDbtzWEM7Z/uYR713E6xvqvRBWhya0gSCdCGghxZ/0ZJmVOyi8YTnRDIGvd60jTyUKJoOfNSV0Vc3gz4xN9XuIwJ2ZRtaWdHmy4kDwsaKDMCb+fWNkCAJFmemyeid4+KDAvuwLhVTgTLIDvwbVqJhwz5hKwh6jvrmsEU82r4nN2Z++G7jf/tFx0/zBCbT8smDqkWC21EkIJEJl/cTz55hhlnVNrR4Jk/yQd9mQorl6YYGBq9j+UdHgJFzNWFsqmKeKfjjN8pcJ
 gkMl84KL
 XWSXHEJrgB390Uk4A2fElVX2zroj+9LR4tG+mzfFIqPQrF8TGX4UQUTJ9y6WZqAFO0tBoz36hDYeQagTIQRAT5qO4NUiWYXwJdoHukXMjSnmd4FntIg5qzXIHF4LoqfSqXiqL84Uy8Rqqp2RTED4HaKzcA58+6ClwcAnedkOprCy3wM5YZJy8UJzNbXc3Yl2y4kzPqnsLHbH2ly6PtpD9OcnIP0l5JOE4K4FmOGs5FdnUFgqGIk3KiIcxGncQTn66/iS8pHBcX0sKW/88kMQ1/BCpvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 07:34, Lorenzo Stoakes (ARM) wrote:
> In any case - Mike - I think you probably need to respin this on tip
> x86/mm anyway?
> 
> Maybe worth doing that and seeing if that makes life a little easier for
> the x86 folks.

Yes, please. If it interacts with things in there, a rebase would be
much appreciated.

Also, please do send things separately if they are fixing active
regressions or bugs that folks are hitting in the real world. We'll send
those urgently and not through the normal tip/x86/mm process.

