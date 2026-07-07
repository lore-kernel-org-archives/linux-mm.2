Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E8EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777E16B00A0; Mon,  6 Jul 2026 23:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EE96B00A1; Mon,  6 Jul 2026 23:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F6F6B00A2; Mon,  6 Jul 2026 23:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42EE26B00A0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:29:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B89D8140295
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:29:18 +0000 (UTC)
X-FDA: 84960549996.02.B7E5445
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD6FF100005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:29:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=m8TA+QfD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783394957;
	b=zQ1EZhMM7ondyjv3LKsVmoJi6YstK9FEfanlaRTOd6kG9L4lmnPGCdoyPnfTKo7RWESTpL
	IqLYGImEJM9yATd2+GDLaDlLzX17piR98AFwbQlCWJTm0ua9ApuIkrilbLZEcLRQGOKoOJ
	FmA84fkVjdfZlaxuqxoJTFpLvEN8soo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=m8TA+QfD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783394957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1sc6krzRa7pzyUyfCUHJ+0030uOyisQV8XNxwRymBw=;
	b=Fvh1EitjizHWajyEumvucYKXltzOx/BCf5l+hA/UQ5Ob8YB5yFgiErf1qIbzJXv6gcNJml
	pU52iEla0PdgEfxLUitl/GLF2awlkOEKTtEIS55UuRRF6fJT4WiKEudaKTZFkFbHi/TqeY
	r3y1EeRi/oUTXdq5VPgRWhcfOvk58Lo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783394947; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=V1sc6krzRa7pzyUyfCUHJ+0030uOyisQV8XNxwRymBw=;
 b=m8TA+QfDVC+r9ToFTz/i+blLo5LisA+k5lA0+m/a9epKWGnsxs5r9uu43E1XnVRThXUEru
 qF7ZqKDvIabFtCUyWRbN0qNzsr87h14C5RMnzTYx0943gxc8LLovzzVftHVxnH/PyJ3MAg
 niJzHElcoVYuzUAqJ2RYmMUe8gO2sK0ntmtPQieCdpKGDct4r+yaTK4aGXeNHa7pfVin0y
 YQ/0XSsFAy+cVvaFIIBAPw+FCO00pvbBc8XQd6l3TfgCAzvbCzivt62FrPfEwErVoD2Icf
 0ThtCi7zCX89+n9js5VrvJariM18dXT3XEB5YIWeXQEmNM0PORy3T6WS0I+Pbg==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <d5a9c3b7-fa4c-47b7-9417-4c81b21760b8@kernel.org>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v5 6/8] string: introduce memcpy_nt() helpers
To: <david@kernel.org>
Date: Tue,  7 Jul 2026 11:28:39 +0800
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260707032839.22683-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a4c7281+6a0cac+kvack.org+lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <d5a9c3b7-fa4c-47b7-9417-4c81b21760b8@kernel.org>
X-Rspamd-Queue-Id: DD6FF100005
X-Rspam-User: 
X-Stat-Signature: fepspfm3ee99jptkiw3441bpj55aen9g
X-Rspamd-Server: rspam03
X-HE-Tag: 1783394956-837011
X-HE-Meta: U2FsdGVkX1+oONCwSuK1i9QErCmHIuaG2qWBzh+Hf+IEH8994a4N5n9Vqd2bOwkQ/6wQRFoQnQc+F8yOKkrdr05Q4POjsq4FWdQ8RXExko8tpnimrmXQju2/XKgE0SZdlhUnx1ZTOM6BAlrgXf8B+pX+lGFbkTCZBtdQFGduLV3GMSN52auC1ICOSD9VCVK4UjxuRZNwinGonNDc9jSO6C+qCJZjzKFZQuC8eE7bLx05+Oclx1QqhN3pZaTSQMk3TBQz8bn7+DxKROxNEf1LqUC2cvUw5DruP552GAf7BIeEqLtCWk2x1bn4XhQSfN8tQBsjRP2Oeo38gHds3inTaOtl4W4GOgL16b7k9oCdqX4fhHupK1c9PEqukk0OH9La+Es780Wdv052kXKZIBXCP7DfQEiiOlFrPm4HtNDnpI3YQgrhF2fkPWfhSmkU7hlxmwk6QESITfwrBVvFXbl3Jq17FZpRheeMvPB7VxJmoeXAKqzK6F/IEobWKGsR0gvpeG/ia0rSWnfqWX8b9TSA1yrvqBR3fytM9WivFwgWjTMZR2hPkrZYxu6bBtl8v67fDoAiPLpvF3r1ufbq993e+Wr/6NDmyTU/uaYX07GTk25KARNqSWvOk06clsFKheQ24FLe1HazVIvzTz6YvBHROK8Os1Hh7J9UKBIkRiBtsSTskB5EZ5zhyTch+7Pck2nZBANYHLWZdNr7eu7P8+MhFC6VDv3UBIdNzHxE/fdrN2PhxCIr8FQA2kzof99kQCvR/5SrqJk/Y24jnn4ohJjoS8kJ658TSd9pnOu11Sf/xpeq05kMY/1Z7MtiwF9bP1gh8abxZ4T1U+1NUxPbgI03NmgnFBKGhGjCVckm1rdpToUNeAwgquZkZmMkQU4Yq3ECrprRMaCej+KaLP4kKx6RN/bmTORtBDEFPvtLzqEuxeH5xXe8VlWC39hf8q7Oyu2V+E0K+a5OFZW3i+a4JA9
 SDoDfQgn
 zGtD42hDpgIDYtLgnxcKpkWRU1SC8r0YxTAxvkQOcGx1TVkhkTQvdbNnaKVvvWUWVS+JJm6yZs0QWVSq0CcU+5O5Umx+ByJwqAkXBZd0daI/1ij5Ffj1fguRCTWhHZtAY2+QPC2wwi1zZ9cuFTV6by0iLrJ8X/NkkkzFGj7I7lueoCutnhqMHbONhoew6Gdd1Yp9GDWpP4UWdOPsPKZuovNciBrxGBOxM584J/15R4A6Cd+rZ5aBjZf3dcVjg2aCr+FP6ctIsxGGX8yT0ATE8oFvWqbPDjHTwNQoYtM9kN4hWa+X8uB2iyhl/TgjN7uAOZuAq9IaZT7lOBFQRFhgZ1kEQU5JOKcY70o8QdtSTA6QCEE13F0pG5XEr+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Jul 2026 15:49:21 +0200, david@kernel.org wrote:

> >>> +
> >>> +#define __HAVE_ARCH_MEMCPY_NT 1
> >>> +/*
> >>> + * Reuse the existing x86 flushcache backend as the nt copy primitive.
> >>> + * Callers pair it with memcpy_nt_drain() when later stores must be
> >>> + * ordered after the copy.
> >>> + */
> >>> +static __always_inline void memcpy_nt(void *dst, const void *src, size_t cnt)
> >>> +{
> >>> +	memcpy_flushcache(dst, src, cnt);
> >>> +}
> >>
> >> In particular if you end up with a single function (that jsut requires a write
> >> memory barrier afterwards), please make this
> >>
> >> #define memcpy_nt memcpy_nt
> >>
> >> instead.
> >
> > Thanks for the review.
> >
> > Just to make sure I understood this correctly: do you mean that, rather
> > than using a separate __HAVE_ARCH_MEMCPY_NT feature macro, you would
> > prefer the usual self-macro override pattern, with
> >
> >     #define memcpy_nt memcpy_nt
> >
> > in arch/x86/include/asm/string_64.h and the generic fallback kept under
> > #ifndef memcpy_nt in include/linux/string.h?
> 
> Yes, that's what Linus suggested as the preferred way for single functions when
> it came up in different context recently.

Thanks for confirming. I will switch v6 to that self-macro override
pattern for memcpy_nt(), and I used the same style for
memcpy_nt_drain().

Thanks,
Zhe

