Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B26DBC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3236B00A4; Mon, 21 Sep 2026 22:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9636B00A6; Mon, 21 Sep 2026 22:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07AF6B00A7; Mon, 21 Sep 2026 22:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80AF56B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:34:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FCECA036B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:34:18 +0000 (UTC)
X-FDA: 85239828996.15.767BE5A
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	by imf24.hostedemail.com (Postfix) with ESMTP id D96BB180006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:34:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IQDyPBvy;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790044456;
	b=niNWXTqZhlz3TLwY2Yd9Lx6QmGh1P5El83lb0myq0uECOIE/U5GAzWxlmyH6brABZAInXt
	TGinxRuqaUSYHQG7zbFAaKs43KOMVBzZrAqQw9n9wEUPWXZY8sHpUp4V8LW7QfCE0dqY2B
	j/rbAAFLwc+8E94inI05dGl5gonpdAo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IQDyPBvy;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790044456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmvXUaUh0x7Iq7a1F/nNLaoOJ/x9bsxphrerv34hNIk=;
	b=gdZMfy+jpnErVHDjiv1CeU7PwGiGnoGhKZco4f/coESQJZbnIeGWhAubH92oduwlLYkpMt
	ACLMVRCJBhYp02o1rbGt6S2GoX8b86YEa2NoK3oATsQ0CEnwlktjTasPsY5bCS97Wx2DUO
	vD0x0rmsHUov2Akztozga3qDcp2m3sg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zmvXUaUh0x7Iq7a1F/nNLaoOJ/x9bsxphrerv34hNIk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790044453; v=1; x=1790649253;
 b=IQDyPBvytySjDtCrm0L/kZS6IT9oghsQWxh6du6fIYDq/Vs2yd5ecuSKT8bRupknQYcDeszY
 RsEseuz9+szDTReT2pIAcA2IgIbVqlFTF+Mx80+zcO0A9HjbVmEQJYtTKxQsEA2iFK2K0J5nQFA
 uUofquzRY22nEVeQaGHLX3DI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 8af55bfa8c8b6846;
	Tue, 22 Sep 2026 02:34:11 +0000
X-Mizu-Trace-ID: 8af55bfa8c8b6846
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/4] nvdimm/pmem: avoid HWPoison flag updates for clean
 pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <arEovvqEpquODZ6X@localhost.localdomain>
Date: Tue, 22 Sep 2026 10:33:54 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Ira Weiny <iweiny@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E55DD139-7B33-4269-8854-3469375AD587@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-3-songmuchun@bytedance.com>
 <arEovvqEpquODZ6X@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D96BB180006
X-Stat-Signature: wcritesrm4ymsqmgcfp49n6fret73jmu
X-Rspam-User: 
X-HE-Tag: 1790044455-110869
X-HE-Meta: U2FsdGVkX1+Q4rsJEnmZ1OqJEIjKSp4a5EU2VZT/qMT6nHPbrz6rn+2BqB4aaQgBEnu0ESm/PPWvqnjDA/PTbJqKK2LsNxzCG6Ga3iJ444nY2c6xZAhYGRmU8xDIs9pDJHonPkI8Ucp4Pux4HryEHf7ZBhmuQvqd4COeS4rA0Cq+Uni7HIfEslG2xjNI9QMvI2IC7jIF0e1HxxzcBz1UPmNVCDfrPCU/urbzdAZXQj3vcjDdNqMWh7o9jfa+bGrcp5AfVQYvSuy8HfeoD7TUo/I6n0AFQsJfNwEicCxkEvTpxl0R+paKhbjCXEBU2W1EFDqJWgRPpr3QOL0IMGkcaZDIevfyrpbU0dlsQ4aBFKNNRTgXG01SfUYEANXetELL/EXxnCVwSnlU4SpLMrp6AzpBMb1pTPq7+b9ZDhPx8i8vWvC6NK1ysQXGsG6LJ9JQyGHQttx5k87Ny3d6eeMn60N3dbJFlkH3IJwW8JNEe3YR/Qk/CT7i2aqvNGPWqRn4AdFzHHHaZH5PEE0NP9yvHdE2ZzrJZVDdfnl+NvJaokI+2GRv7hECMAMHH/VkF6rImCprRxfQ8DWkQwvP8DCtYmWWtskhMXcqCqehfGeXaoCvWh3xyCTjwNpX65VV9iRrhEUidd0skdDRTDZqOXlmq/D6NbvplGdRdp7Jl2slvX257nW/yCcoExIrpXoygWj5BhUp/F/QYokVgcghfKT25H3gfl3hfDzg+1CrY7C/mENOzMWt1od2Cf2IbFTFxYAxXGc/UzAV5ZuX67AC5RflxYVWQ9UEW98IQ3yFMIc9Pvbxi8jXYElMytABriwhQz1/xUZK6D1IoMDQ/szrMRznXTlBqWLL+X8kX4NHoW8RWa+EvpqEe5jlL77gIgnblzJU5Vs2KnpLBAN0V5FUNsxEczlgeDo/AKNyYK1SaZV2/dAGk3hXVdZZRWfGuA9m65ndUxLU8MLs6Cea9OOaO6Y
 cCKt2/gj
 16bgjSIm+ML2SdwIwVWck0iYoOtVY/xj3QJ19JLFhxhchr3nWQIWBHNVwCFqUSeGq4Y+7knZID3EIYuZN2vRMWKr579doI03+oupMZBrJfrTpV/e6MpAWd031YtPtFYsAdzE0YcfWDAXpvx64f4eaLD19XW0EYEUyNYdq7CMR9p6vkulkHqTVQ7Rvj6WYv8Tnrg8cO/ADXLSgARIH3ZCbARryAduwt/bgWtjZe1dBpfenaE4TUHt343JptWYY32yAbKEbqdNhFjQU0tuI36oOkWZYhnTnB5eIxl85iUdl5tvoeoQnaGPtEVvwjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 21, 2026, at 20:53, Oscar Salvador (SUSE) =
<osalvador@kernel.org> wrote:
>=20
> On Thu, Sep 03, 2026 at 08:21:25PM +0800, Muchun Song wrote:
>> pmem_mkpage_present() is called after persistent-memory poison has =
been
>> cleared. It only needs to clear PG_hwpoison and undo the MCE nospec =
state
>> for PFNs that are still marked poisoned.
>>=20
>> For clean PFNs, test_and_clear_pmem_poison() has no semantic effect, =
but it
>> still performs an atomic clear operation against struct page flags. =
That is
>> unnecessary today and conflicts with the FS-DAX vmemmap optimization =
added
>> later in the series, where clean PFNs may be backed by shared =
read-only
>> metadata.
>>=20
>> Check PageHWPoison() first so only poisoned PFNs update the page =
state.
>> Poison recovery keeps the same behavior, while clean PFNs no longer =
require
>> writable per-PFN metadata.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> Then change itself looks good to me, so
>=20
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks for your review.

>=20
> but any reason not to hide the PageHWPoison check within =
test_and_clear_pmem_poison()?

I indeed hadn't considered this point before. But now I find it
unnecessary, because a patch [1] has already removed =
test_and_clear_pmem_poison().

[1] =
https://lore.kernel.org/all/20260903053535.17611-3-kaitao.cheng@linux.dev/=


Thanks,
Muchun

>=20
>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs



