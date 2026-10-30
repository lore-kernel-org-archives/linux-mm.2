Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EBD606A329
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JJXR4YGe
Received: by kanga.kvack.org (Postfix)
	id 8026C6B05B1; Fri, 30 Oct 2026 10:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B30F6B05B2; Fri, 30 Oct 2026 10:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9F46B05B3; Fri, 30 Oct 2026 10:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43FFB6B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:33:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAB671C091F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:33:56 +0000 (UTC)
X-FDA: 85379536872.25.7CE5B61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20F68120007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:33:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJXR4YGe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793370835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JFYFF+XVqmPJXdW9AOcrcS6NT5ie/xJlSuvhelbXCs=;
	b=oGEpjz3+9JRNEuPiOnkuye3CJZWbCd0RIK/AvG7qZmuPBek4yTpeHkM1vsZp3IDN7f8gMW
	enWQmlfL54l4GnNvSSHbJP3iWPD7i0grWAYuWKCqAOtO9IotQ0sVfuNO7uCkkrdaMINX+a
	KlTtaVvbh2mVaP8UdyUaWl5xDhKGtb0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJXR4YGe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793370835;
	b=TIev36X6IrcfrkDuCsR84Lutr+4Geq27XmU3XouYWQuiWs3z6s+Y3xqnU/ggxCHsZcvOMF
	8U5Yg95QfrTQlp1WWnkASzBtsMNVrn01VNdFcpxTg0J+a+iVDtjcT4i55hqVq1+P15sTTf
	r+7Cbjc+9phOl7NqztTdk85Mth5V53U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56C3940987;
	Fri, 30 Oct 2026 14:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E3E1F000C1;
	Fri, 30 Oct 2026 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793370834;
	bh=4JFYFF+XVqmPJXdW9AOcrcS6NT5ie/xJlSuvhelbXCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JJXR4YGeMIsV8u/Etct0mCvf4yMo7V6OVh7Ci1ML8Bg3oxb2WuWNHhHpLkR4ZyoKp
	 qS9ynCkTW2BAJGEBM4upnkFvoYiw3ZwkIwYXV2G9s57/vWCu7LAmnqdHPx0+5sy7LX
	 4MsZbYhquDQfvSz74E6k24KF5pW/vZ10wa+3sPWyj8yiA3vKUHQ08NyUFBJUaI37sc
	 ZBVz9A8zEc1C8I4Ff0wtJP0QFAHuOMXxMUcK4aJvb6A4sKevlDkrwe/92xNfLl1r54
	 BY62xoFCo9MQ7YYizD/5FdtuBXKofnRVB7VjTzs7OU03Oi0adZI80mFS2B7tN0T14k
	 PWOvrQL+AzBIQ==
Date: Fri, 30 Oct 2026 14:33:48 +0000
From: Will Deacon <will@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>, Karl Mehltretter <kmehltretter@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
Message-ID: <auSqzHVKRktkrtQC@willie-the-truck>
References: <20260901131823.15799-1-kmehltretter@gmail.com>
 <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
 <aplP1oUjx96O_I69@willie-the-truck>
 <78638e8a-4919-4c2b-b6d8-dadc7a981709@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78638e8a-4919-4c2b-b6d8-dadc7a981709@arm.com>
X-Rspamd-Queue-Id: 20F68120007
X-Rspam-User: 
X-Stat-Signature: 4ktnjssdruy9do5zkjyu7b31aa619faf
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793370834-293133
X-HE-Meta: U2FsdGVkX18fD/we7GB8f5nbIaEVNm69H7299TIfLhhFJEA1P2ApawIput50XN8daE8mdEzd5wncJ6OrtS8ZpZvxdOmR6vsXSSY+VIzL3Gl2jL61vaNc168u0yZjUIGO90HIyIhZcbbeUZwbmOUAHBvcfgxPO3mV2R5g69ZmkphTdsFyaZAsRt4blR6ps3FmhRX6e2fqk72O9/+4+/aXkZNDqxaWUHHiuijGYDlW/CPUCPPvPbrwN0X7fqGySW3IIFkQeCO26PaN5Ypow2BXAV7mTlaSeyoT206VUOI7kfW5e4IFjwBRHjDQCcV/iXoiwUavMdSm7otYVglCZ/CXF2DStFswCGdVjlq8+OiPD6KKW9ChSWeGtkri17LCZgL2hfyaawlfiFkbBD+c44uij/NAZOoWhl55qdCPUgn8ZMu/KntgKiI/x5ADoGxAdkEOzLi+Q3m58rAyqHmFMhHJk4f0DflMKfZ5YhKU2g7yQ8oT3UzI8wC6bzpI0zB0laF0PfW8e1+uDTcUDP3jMFvT8qyUKouYUdoIzK4iDCVEUZYcLEEq+YmAKyanDRGofv6IVhlDuOq5t96ec6QiVdSLElfcRRcUbNyF2A32WcE0VoPApoQoX+HGhyhlLH84Nlge4Us9OSqpGllNwg/niZmsczQn+0Dh5QHYl+SzUqr08PnPOXRpWQC64xzrZUpxv8OVxhtQ1HZkRBhYdmOD7BJdwdMiZ9YIVNEThHfs90Z4yZwVEL68qnKWeJ4i1JR0bfcAT1d/yerUpjZZAAXdefsxzXiq8RzNG9iD2psUMgli5o2EbF38SIperRWHJ6qrw+wM5vpo2Jr0/AjNa/EYoQQrKPVuixziqC/9NxueVo0wLWfsUx8njcvC0gW4vPvB2T9juz1JrB1yhkUQ0VUzpjfcPi2umepIkbm/wcArEPZXBbd6AYpRY6qb+HrbeHVR1PCINRtQnkpEcXeoTaXCHMs
 CFkE+gem
 +DnL2vXNFqC718uEuHxJC9KWJfTl+9X7V9MO0XRjPu3hdmnmh7cWLiE06pzbNXpfvgYExaR1sBQamEXcQREysr+hhGBy2JbiwhJSuazQkD8SPscnAgDDxpo6xL+WgKJXSduq9Xzu4uO0poXPORSJnPns3zYoIFh0Em1r7fHCNHuQQ0vlsjtAFQWQmOxpfTXvPNgkhLzjJ9qEnyCIAs1rCH2W9wQInd/xWeQYjU9Br9H8CpwdY/prhy4n9EMT603aMtH3J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ryan,

Sorry for the slow reply here.

On Fri, Sep 04, 2026 at 11:56:25AM +0100, Ryan Roberts wrote:
> On 03/09/2026 11:45, Will Deacon wrote:
> > On Wed, Sep 02, 2026 at 08:16:36PM +0530, Dev Jain wrote:
> >> The transition happening here is:
> >>
> >> old_prot+cont -> zero -> new_prot+cont ... (i)
> >> and then TLB flush.
> >>
> >> Arm Arm rule R_JQQTC says:
> >> "For a TLB lookup in a contiguous region mapped by translation table entries
> >> that have consistent values for the Contiguous bit, but have the OA, attributes,
> >> or permissions misprogrammed, that TLB lookup is permitted to produce an OA,
> >> access permissions, and memory attributes that are consistent with any one
> >> of the programmed translation table values."
> >>
> >> This implies that a live update like
> >> old_prot+cont -> new_prot+cont then TLB flush ... (ii)
> >>
> >> is safe. Which should also imply that the transition (i) is safe,
> >> since the configurations the PE can observe for (ii) is the same
> >> for (i), except that in (ii) the PE can fault too, which is fine.
> > 
> > I'm not sure I agree. As written, the text above says that if the
> > permissions are misprogrammed (which they are in this case) then the TLB
> > can produce an OA consistent with any of the entries. Hopefully it just
> > needs some further clarification.
> 
> I'm not sure I understand your concern here. Is your concern that the OA could
> be pulled from one of the invalid entries? The intent is that any entry that
> does not have the VALID bit set is not considered an "entry" within the
> "contiguous range" for the purposes of this. (because it is invalid).

Not invalid, no, but from the old_prot+cont. There hasn't been an
invalidation, so that could still be reachable.

> That's implied (if you squint) from:
> 
> IPGVGZ: The Contiguous bit is present only in valid Block and Page translation
> table descriptors, and therefore neither of the following configurations are
> considered as misprogramming of the Contiguous bit:
>   - A contiguous range of descriptors that are each either invalid, or valid
>     with Contiguous set to 1.
>   - A contiguous range of descriptors that are each either invalid, or valid
>     with Contiguous set to 0.
> 
> In general I am of the opinion that the rules around contiguous mappings are not
> as clear as they could be and the VMSA architect has indicated that he hopes to
> clean them up over time. Bit I don't quite see your concern in this case.

I'm happy to review any proposed cleanups to the wording, fwiw.

> > There are probably also cases where we're changing the attributes and the
> > permissions at the same time, so it's not clear to me that it's safe to
> > allow those to be inconsistent (e.g. tagged/guarded vs read/write). If
> > I was going from untagged read/write -> tagged read-only then I presumably
> > wouldn't expect to see a tag check fault on a write?
> 
> Again, I'm not sure I follow, but I'll take a stab. I think you're implying that
> a write permission fault should take precedence over a tag check fault? (I have
> no idea off the top of my head). And you're further implying that with this
> transition the HW might see an intermediate "tagged read/write" entry, and if it
> does then it will raise a tag check fault, not a write fault for an attempted
> write. But I don't see how R_JQQTC permits that because it says "consistent with
> any one of the programmed translation table values" so the HW can't pick
> attributes from one entry and permissions from another. It will either see the
> old "untagged read/write" or the new "tagged read-only".

ah, I think that's where we read it differently. You're interpreting "ANY
any one of the programmed translation table values" as "EXACTLY one of the
programmed translation table value"; i.e. OA, perms and attrs are read
atomically from the same pte. Maybe (hopefully!) that's the intention,
but it's not how I read it. Now that I see how you're reading it, I can
convince myself either way!

Will

