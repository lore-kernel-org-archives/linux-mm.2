Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CCB606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZjlZo9Ub
Received: by kanga.kvack.org (Postfix)
	id 2DAD86B05BC; Tue, 17 Nov 2026 10:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264406B05BD; Tue, 17 Nov 2026 10:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156C36B05BE; Tue, 17 Nov 2026 10:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF5DC6B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:37:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 361C0C04B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:37:08 +0000 (UTC)
X-FDA: 85445014536.14.61F73B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36220180007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:37:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZjlZo9Ub;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794929826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bALTgYPfIad1XZTuc45/MCR0LAeKGdtBKZv+egR7pQ=;
	b=fginBi7hk01JSosPlfqPcnQt5fMXQLOVBUoTP2c0mAel20yg9iRO0Vs1rgX1/3WO0n6F4Z
	B4yEXBtk+mHq4H8ZIrhhW5BOF8uQ/7iQTQl9rAok7JSpgESgeLZuAOehObFVSOO5JdCnje
	F4+8zfngFQLfiO686roQmPTEHnQOiS8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794929826;
	b=IxvpqL73Xm/XAnHRskd7orCghKbqg3pfLdOrXhxzl4GJCRukrY3WMYqecTzFNfbn+R26RC
	4mNLP/KOm88y22vkqC+t6S7xQyDduJoQNOHh7n+EfniVwy8Cy/vjy8DOd3Ur5vos8X4b8i
	bnrIxiv7ebH9s27uzOpv0alJW3mzk6E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZjlZo9Ub;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B375562368;
	Tue, 17 Nov 2026 15:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1871F000C4;
	Tue, 17 Nov 2026 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794929825;
	bh=+bALTgYPfIad1XZTuc45/MCR0LAeKGdtBKZv+egR7pQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZjlZo9Ubqff4c93mEcadpNICZynvRDGma8iq4qQhH5ZtClssDYYxMEJmhnIIMv7rH
	 +tSvWJ3smeCCE6UvBQLXxwRZQhdu5Hi1cbrQHTnRwEGZtSvFb4/U9QIK2AAAmFw82+
	 JzTufoKKAbf4PMRbnzKJYo2BOe1BAXvMQtY9UOEdhiAcyGqZbnlvaeFZDDhAFOa4Am
	 h/LD58VRtaGPno2Tqat5p36Yv13S3DyHGucnqaXHJx6Ieq/v4CP4kWzwjawT+bC2zf
	 q0jaQIEz/puFZBofPlJIaO2/YvofxD+7ItBTJaxs48Dd0C8LueDY8pBllWg8vjZZyD
	 GB0kcW4vuRuvw==
Date: Tue, 17 Nov 2026 15:36:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, larips <larips950@gmail.com>, stable@vger.kernel.org, 
	Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jackie Liu <liuyun01@kylinos.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Message-ID: <avx0Ci5uPW_hF0Jk@pazuzu>
References: <20261117142628.3931151-1-arnd@kernel.org>
 <avxnIQTcFni9G4IN@gremlin>
 <541a67af-3b45-4d5d-ac4b-c741850f92e1@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541a67af-3b45-4d5d-ac4b-c741850f92e1@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36220180007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xsi1kcq7a1wnn6wjbgc3cejfe1ud1pkd
X-HE-Tag: 1794929826-682643
X-HE-Meta: U2FsdGVkX1/hHdXe9cppCOqTIlsc/deIOV1qE0nXBc6jqN9fdfHm4qyw71fTL5eEvN46BElOSQEsM2CL6TwiN1ZgVxD6jYeegsyfCdvdDXvXBdYCGiEhhRs1bhQifgFIxYAPArb8lrlbaMNhcAzo2sn2qpBSJo5aUp0dvrQyIR7mJqhdL3Rbk5+gcXPDvrpE6nnu5WQMJjAANUosuStnscSj33gCBcs/2SdRCmoZEl8kjjogwAxsZte6a63VbZmzOIU8FVw6+UZ3IY1RBFPBkL43/imuFd8xcA3ia0QgII9VhBhbgUhgswewnRfhQ61UiyiF+TOLcj0JgH0/Ml2+mqgVG4EW5YIGbEThVBFFowqHT+QdwlhSusjj8y8lNB4TIEP+JJJDzzJkqbGh4y7VdQSPD2MO0L0kxE+T5n8jAg1Q0j5tUID6GlNDiG7SPmW5HyrweUn2J/i8t94xb86d8ZNkwUfP/5F5mLvMRk2CV38OGRWuekpbSxDTk7hKppDhSpkEVfrhUlAMttbFLfiOu5sB24VV5RSLgEkv4XvOvBq2K8KJ0Gz3vymKVOcXqY83ynzsmz3R2eLmh4Ozz3+EKVy+v8JdDPskPSb/p17dCHUSpC7k5gHVT4qBw2AhtmgQ9+4PRjNT1XgH/1tijv/6IxGqpIohjluxrcrERejCBjDX2i95Jq4UB80o/Qs64p6EdPChiRSGGuMB93A0ceRo5ZzhigXhHu4lqzOgbzvfKixjJdrnRsVa7n2Th8GqQdeMoeWvhh70dkHyGKUtNUdGmx/B+GOdHC0X4dAuKXCpJtXYqG6Unr0eTKRNgVSyKr+skaNUApV7FSxn1JL7HrPZp53BDx2itCQ60ZrvKVFUcu2aCQS+8ViSFwy2YIuMn0Lj6TKlc48DRADuFShxlp5x37oNPWz9Xn8VFox+SXRVX0H0eRA/UJHwPWGYtIPAKqVP+IZ1nupF9opyo1CUkDk
 8XHUDZy1
 FjHH2w2stbgKH4u+Kc8Mw2AzYhCJSJpKoaTlTErs1OIdPtMd8VdsmPkU3ynpR+o/uFdGo93cWDhCW+P0PXP+Iyv+XdU6i9UYg5iTpb4n59S/2gSuR8mFi1mdS1hUqkmdsUCLtc02Jd9S80c+xI3p1Knpe9UtBPr1UfAhfGaBSfZj4KmYR/tN38TWg+Y+Q+IXbN8NCDJEqnBpInCGp7P22PSuorIJCxtvB9oxSUaU9lQ82aGcnjElyDA7XKR50kHKmvhF2XS7JqGlcIw4mGriBY/ZxCA7ihu6fTGpmMUXBRItCfUcDMdUsD8RcWCLhfLX520WWQAe1S4tg0ERapvpnwfbLSXxgugJTqrRZTWVm9yvHVrBS7c52ya8TWKK7Qi4wqYIcINscvu9+w1sO7i3bl0tpcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 04:26:48PM +0100, Arnd Bergmann wrote:
> On Tue, Nov 17, 2026, at 15:59, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Nov 17, 2026 at 03:25:53PM +0100, Arnd Bergmann wrote:
> >> From: Arnd Bergmann <arnd@arndb.de>
> >> For compat syscalls, the effect is worse, as the actual calculation for
> >> the size does include the extra word, but the check for the input size
> >> does not take it into account and can leak a word of stack data.
> >>
> >> In addition, the size calculation rounds up to multiples of 64 bits
> >> instead of multiples of word size as documented in the man page and
> >> expected by numactl.
> >>
> >> Fortunately numactl always passes multiples of 64 here, so none of
> >
> > (Claude) went looking at numactl source (e.g. via libnuma) and it seems it
> > passes size + 1 matching the convention?
>
> Ok, I see it now as well. The man page again says "maxnode specifies
> the number of node IDs that can be stored into  nodemask——that is,
> the maximum node ID plus one.", which I'd naïvely interpret as meaning
> that a system with 64 nodes would have a "maximum node ID" of 63 and
> require passing one more (64), but clearly the implementation on
> both sides expects a 65 here.

Yeah which is... special isn't it? :))

>
> >> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> >> index 6d662a9a8c74..f318e1155770 100644
> >> --- a/mm/mempolicy.c
> >> +++ b/mm/mempolicy.c
> >> @@ -1749,12 +1749,12 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
> >>  static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
> >>  			      nodemask_t *nodes)
> >>  {
> >> -	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
> >> +	unsigned long copy = ALIGN(maxnode, BITS_PER_LONG) / 8;
> >
> > This looks like it'll be broken given the convention of passing bits + 1,
> > e.g. ALIGN(1025, 64) / 8 != ALIGN(1024, 64) / 8.
> >
> > Then later that could case a buffer overflow potentially?
>
> Right, this would then overflow the user buffer.
>
> > Overall it seems the issue is that e130242dc351 (understandably!) passes maxnode
> > rather than maxnode-1.
> >
> > So a really small fixup would be something like:
> >
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index fb627b37afcb..051d411c04ee 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1733,12 +1733,12 @@ static int copy_nodes_to_user(unsigned long
> > __user *mask, unsigned long maxnode,
> >  		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
> >  			return -EFAULT;
> >  		copy = nbytes;
> > -		maxnode = nr_node_ids;
> > +		maxnode = nr_node_ids + 1;
> >  	}
> >
> >  	if (compat)
> >  		return compat_put_bitmap((compat_ulong_t __user *)mask,
> > -					 nodes_addr(*nodes), maxnode);
> > +					 nodes_addr(*nodes), maxnode - 1);
> >
> >  	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
> >  }
> >
> > Maybe doing that's the easiest route for this?
>
> I would still try to fix the other mistakes (aligning to 64 instead
> of BITS_PER_LONG/BITS_PER_COMPAT_LONG and the incorrect nbytes).
> Maybe it's clearer to just pass the adjusted maxnode into the
> function directly and keep that extra '-1' in one place?

Yeah it'd be nice to get away from that convention which is... very
confusing :) Especially as 'max' implies to me an inclusive bound.

You could have a wrapper get_nodes() that calls __get_nodes() that has a
'lastnode' parameter for instance?

--
Cheers, Lorenzo

