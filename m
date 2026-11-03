Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87870606A328
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Lceh6Plx
Received: by kanga.kvack.org (Postfix)
	id AFE0D6B05B4; Tue,  3 Nov 2026 14:50:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEB16B05B5; Tue,  3 Nov 2026 14:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC426B05BB; Tue,  3 Nov 2026 14:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F69A6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:50:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F9BEC053F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:50:33 +0000 (UTC)
X-FDA: 85394849946.29.6942AB3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7C69D180003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:50:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Lceh6Plx;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793735431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUcFaW0QlGFes0C2J7AwtNc1g9u3PZm7aB62qqNYgAQ=;
	b=JnBCuZwxumOhlwBEJNVrSP4v9UhmcUh6vHNIWnA0LPtxZDX37gk/PD8pW5Snmo3bxczP0y
	PleQ5ejv4IMwbtvoGSC3kQUs7JLOp+CErs8CpO1iGdHoMjau+gMivjzy/j5EUiu2BfUWDt
	bhjfYwmkrWMggr/22/scEZW8TyFLCxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793735431;
	b=OXOiYcAB8og9vL3/rDGvmfMJUhOEJZskXhJWqmVC3RjnoOiETiAvonyhtM3JJRgtN4NluJ
	q8M1rr/1gpeVrnNKCaCL6DTU51S27cbRCOP4GFWDWPzNVOqUvnXeRQHlUCmZaD69/uoKmU
	lZxCXNj6QMX93cWZsVw7pbErbI8YKfs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Lceh6Plx;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GUcFaW0QlGFes0C2J7AwtNc1g9u3PZm7aB62qqNYgAQ=; b=Lceh6PlxsEJklOoM0MsQOhPEBu
	iWoM4NWNkSqK6+mJblh//PkPt9UHzWD8Dp0s9P/i/Mxx3AKaKefvHrfEFvXqTTv7D4heLJ1TV7+DF
	rWCW1KyaAsKhQaP4hn+ntUYPwKgO4CbcjHYw9VGzGK7X+4Nn8UYTh0sOwOhTj7GM7I134azSS/8sp
	CZs97Jqi3SmdnVecHq2zKqiWP9Tup1YJfMylxOBzHY0NpRdzMQKtpiErN2xNVontWr3co6udl6PSm
	CV5IxUZZUtmLZCx653c4XuwlTNnEwVbL8kvVAwsgW63CgFx1aSREEeBM+lMVDv+IWIwQ+g00uaGn6
	zxg0XPmw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOKW2-007Aup-1U;
	Tue, 03 Nov 2026 19:49:54 +0000
Date: Tue, 3 Nov 2026 11:49:44 -0800
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
	kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, shakeel.butt@linux.dev, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <auo3ScXy6dk0Gr3-@gmail.com>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
 <aumvVjoHo4KeuyEp@gmail.com>
 <auovL7i1rEcXCeGS@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auovL7i1rEcXCeGS@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C69D180003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: c9ba6b9idtsmx9whtqqupnc3om8pr1m7
X-Rspam-User: 
X-HE-Tag: 1793735431-814578
X-HE-Meta: U2FsdGVkX18rxijv26+7vv6yf/4SkrBdXix3VvttIANHXHrzvK8UqOmtUBKMZHYrDB8XarIU+ofGJ+vBDBY18tYaxBvXC2OB7xyRsd4eXcSgft7jQYrTaoK/T03Sa02yMQmLxd4qV1Go1lBLhIhvE86iiwFa+WmiG5LEPdDR1K38MXJGtSu54ZCmCJGkj1RyqlLIx9yqYUhtHQQuRGDiMmfmuMmlddLtD2ttwgH3hR213H61DEFhQwtrkqh6VDozgqW3VlRm/Ue4cZBblKPkYBgg8Gw2j7m80xzT51CvNcUG5TBFW23TnSygLVS9ATDwp47pv38ZONxvZ4rH8zDpdQ/z278ZVv0Agj1apE0uYagDRnWcoC/uvOdCt0byH8+rjsm4hWZXza46fnqf6Zu+zgzdlyHrlbPBhsirWwZr+tq8/uNGopYmcuSjc61sawO7pxqw7e5DRqyANSH+D2337BqHp8nLDgMV8SqiQs35k8jF8UP3LGd6Pzp1uAWWrOvfevnr2lHl4YIxW62oA/Z/k8Zw+h5yrZcBAaLf1xibSmSj1LJX5IYwj2iu8FAW+CPhyN/aI9sW1Xfcz8Xk4VT4h70KuOJNHvr21HS76n7hBk/LPL45wK42Ckfa8XF+IcNShLUn7PY+fZhEpu52gnv4lrBXwOqIFxhQ6z7EJdA/+2OSENxjWiCgJQnus7RRckQNxFzZ+MTVHvwRKX6EsgL6Djw2R+Z2wbS6krgTLtm2rCqwVZMZMH7rLmqIcXJmowSisyFcpu6RJJbj0GqFK1uRN0RqqRWXQxIRdpqCBezhB1bFQHCJmpfhfDf2X/dLF/fAvHuyChQe2mGlXnVSUf/NI4AcSLpYmszuFHpW3/XbHa/xOcI2RYsfmwadZqWRlmmbTCRNzNZiYg4yxp0twS9P39ITGE2MRhx6LtzEmOMhVYteI/z1JGzGP0+ef0VQ1ib7NZKyQPC+P5rdArIqt2W
 gMAT0KA4
 7+4SGlt73rVAdffoy+7vD9k/m5cwHQDtSRGf2XrdWJHETkwn9h319xOcLhUkYAtuZS8Gea671dPpx4rA+FPhNbHOpby3VpQX62o38HGPp7SQK8ko2hA5ns8K80h8ccqddTDN7cRa6n9ZyZdgAfpyM0mOcu1TkJKMkLTURELaztv+ZM81vyGi/IpLjAW6Td3e2To6V+0mNOkRq5BimhPveI62bTCwwUms+xs8UOsZf1keQbZPXtMYT2cJ1SOMgZqVUEEzsBaKyD4WKSE345uJFwzAMcVlSdZBbSUXqEmOg+K30XvWTCfjK9NvAYk3tre41bsjT8T1l8wrUokU/Se3rOFdTsnnCr5jadSyVbEzfIAhCkNPdOOJ1GR+zQ5f0gzW6ZO3j/smDqZuY3ceL87RJS3FPvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:59:59PM +0200, Mike Rapoport wrote:
> On Tue, Nov 03, 2026 at 02:06:17AM -0800, Breno Leitao wrote:
> > On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > > > --- a/mm/internal.h
> > > > +++ b/mm/internal.h
> > > 
> > > We've been splitting internal.h to smaller headers, maybe it's time to add
> > > "memory-faulure.h"?
> > 
> > Ack. I'm happy to move the "mm/memory-failure.c" section out of
> > mm/internal.h into a new mm/memory-failure.h, as preparation for this
> > patch.
> > 
> > Since this patchset is moving slowly, I'll start the header split in
> > parallel as a separate series, and rebase this patchset on top of it
> > when I respin. Is it this ok?
> 
> Sounds good to me.
> 
> Just be aware that MM folks are knee deep into fixes this cycle, so both
> sets could be moving slowly :)

Appreciate the heads up. In that case, should I hold off on the header
split until the next cycle instead of starting it now?

Thanks,
--breno

