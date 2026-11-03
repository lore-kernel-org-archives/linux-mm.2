Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1873606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jfGbh/HO
Received: by kanga.kvack.org (Postfix)
	id E0AE06B00EF; Tue,  3 Nov 2026 16:54:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2846B05B1; Tue,  3 Nov 2026 16:54:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8186B05B2; Tue,  3 Nov 2026 16:54:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA5176B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:54:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47630140532
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:54:34 +0000 (UTC)
X-FDA: 85395162468.27.669007C
Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1BC73140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:54:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jfGbh/HO";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793742872;
	b=BPOwIkMNLSjSU0z7su3fwOuniesUiqh8yomiHei9Ve6bg2TZoPBDpH+bmx+9aBgjNDPt9m
	LnKHhTzDjwShBtpw33Nd9FnUu4lVBgKp9P3at+jw7xm7g2K40ssNyH2zt1QPA50KXziYrV
	XMhELiUjSVFqDIBkckTYGs1sx0pdq30=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jfGbh/HO";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793742872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNIYfgovfeYUTnUWQVAULaUQM12WfGegAeKvV0ijU6k=;
	b=pMcDUI9EQHsVfSkjBMFREo18aZyLpt0pMcRCAED+9NhwE8xzfUzS75o6r1ItFFKDFdrp+m
	mRT1vvaN7E3KizznRixBUtn7mQirlOKC4AdWqB5/ZpURnGYMHMf3PHz/Y5VJB6IN8wvPBg
	DJIWfvRm+zGEXKDTruhILD/hUVwXzN0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lzvO4MZjJaBVQmlohMoJ2wbpUm50n891PebbguUdryA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793742870; v=1; x=1794347670;
 b=jfGbh/HOsOxsUSry2IPwFxi6NWyrWkFH+e42+sVp/RFdXSh06V1SmbSthalzB3AIH8ca9D66
 vF9TykAblu8zQ2IAx8XCnn3bFD/jvEMWy2QIL/pPdATwExO3oGsf314SYjMFfA4ha1s0Ml1Lo0L
 srd6w/fYsWxBAeHqu3MyTPE4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 608ed53c19633f31;
	Tue, 03 Nov 2026 21:54:30 +0000
X-Mizu-Trace-ID: 608ed53c19633f31
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Zi Yan" <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	"Baoquan He" <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	"Nico Pache" <nico.pache@linux.dev>,
	"Liam R.Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	"Vlastimil Babka" <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	x86@kernel.org
Subject: Re: [PATCH v8 07/30] x86: mm: add PMD swap-exclusive helpers
Date: Tue,  3 Nov 2026 13:54:22 -0800
Message-ID: <20261103215423.104469-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DLX6HZQ71WVN.1AIA7V63XWARY@nvidia.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: um3ogukmwbfd4569qfpaehftjrxus8rq
X-Rspamd-Queue-Id: 1BC73140006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793742871-774754
X-HE-Meta: U2FsdGVkX1+Hujrg1CzdK3kBGIGSPgQkqaT2d0KRaHom0V8pr1g9l4Coz71PN+3QiAtP4fFBufb0JO1oAEvlQmBUb3GxtLY1rfiAvYku4gx1V43kvwQbdTI3RCaCJY8ZjLz6burJF2OL739a1gPmeFm7/zDX/yPv3+do16aW3HU5+8x6ORZmEjQ8lUAYEfnBb62H1VqHUt/1Vhn/QS3NeUnPkx08f6LqKq98MoHvjjclXN/UVBb1hgmzgQEdGqC0M9u1hpwgWnXCAYo28QNzNEqoGaIvvPQWH1Z6Z/YqI1CfmDjd3lOAOobdnftpMezIsheQqWSiJv6uN/iobHQabOqchS3SH9rbpZIWWQwjzkt5zObXY3Xs3QruvDNpX767+g8WWHtjNrMx2q9qQwdPrd1Lwn1YKMGR0or5n7//yZZzitcyICRq9cAWvhipqPB70/tbw0tri85UBBsOUHTW0SXuYLfqhtgWh0JWdcI7mq+ZsWiZKOEdrdEdQ6qFR9iMljhLtuaWSsV4AESkzQBQYc0K42JUcQgYcIKdcSwQ2FMbzrARbNYrvn489R+N5176dt5Ole4D4p7oSLyePGhRcykBPq/OI595mjF9w4IOHEgQdCKIFCjeNU7kPSeS/11czwhlgZ1Mgl6D/XoY+KhkCydJGdcL4iPybfXnz0DOVfHEzByjwqY5dgxD2DoNe/rY4CNXnJtmeCkdKfGedq+GmcBglgQJ0OWZq1yDXZaKPeHLTm05h9V7cZxjwBdIomaXTtboXryvoQPABMQ2AK2RlZszhgwlqG2Xw70W8P/YAgcPbqEgRDCEmP3GkAl4QfRpiqJuq3wDDSQrb5DYUkNIF8DugmW/UfEK94xuiVDPcPLAK92V7SgxNK56QcfdEtEpEn2k47n0nPEq2whBCS5G6+8lJ2Duc/+lWgZQCnN7RDWhqyGAqn2jzEvaTWCJMWzEL303cv25/VacA8gsTZC
 +ZPxJSps
 9Vx+hbuSwgWkJi6TqkY+uuAAkbZt2s+ks5O3oowALmbi7/bQuW20IkRyWy+dtHvE2KemVPXOXUZvDlo2xaOP4zI2SpW1fqmmxCU79/3gUMtsts2d8ouHCJVDiSzYoa5Q5q6b9jg3QsfMy+xJTwotA6n6ENqQUbRZ20X4iaaZ0dW/JG2AN/veEyScGpE9ssaGk9o9ISthTT4EzNETBbG2M7jn/bvzxl+aSHH/+xfEZ3zSEU8o5ktEuvFep2NuwAxF0xVd1o/KERfF+UhAJDM8idwA1YMX6leXlTjp1n0zQwUqkivjLJjMlbWxRAOJrMXtrtGwA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 05 Oct 2026 16:14:52 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> On Fri Oct 2, 2026 at 5:52 AM EDT, Usama Arif wrote:
> > Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
> > swap round-trip, which makes PG_anon_exclusive have to survive in a swap
> > PMD and not just in a swap PTE.
> >
> > x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reuse
> > _PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
> > for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
> > not select ARCH_HAS_PMD_SOFTLEAVES; assert that, because an exclusive swap
> > PMD would otherwise be pmd_present().
> >
> > Cc: Thomas Gleixner <tglx@kernel.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: x86@kernel.org
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> >  arch/x86/include/asm/pgtable.h | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> > index d551120a7c889..c35dfa6ceda05 100644
> > --- a/arch/x86/include/asm/pgtable.h
> > +++ b/arch/x86/include/asm/pgtable.h
> > @@ -1525,6 +1525,26 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
> >  	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
> >  }
> >  
> > +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> > +/* 32-bit aliases this to _PAGE_PSE, making an exclusive swap PMD present. */
> 
> Is it better to say? Since the above comment sounds like 32-bit
> specific, but the actual constraint is about not being _PAGE_PSE.
> 
> _PAGE_SWP_EXCLUSIVE cannot be _PAGE_PSE, otherwise making an exclusive
> swap PMD present.

Updated the comment to:

/*
 * _PAGE_SWP_EXCLUSIVE must not alias _PAGE_PSE, which would make an
 * exclusive swap PMD present.
 */

which I think is clearer.

> 
> > +static_assert(_PAGE_SWP_EXCLUSIVE != _PAGE_PSE);
> > +
> > +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> > +{
> > +	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
> > +}
> > +
> > +static inline bool pmd_swp_exclusive(pmd_t pmd)
> > +{
> > +	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
> > +}
> > +
> > +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> > +{
> > +	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> >  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
> >  {
> 
> Otherwise, LGTM.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks for the review! And apologies for the late reply, I was away.

> 
> 
> -- 
> Best Regards,
> Yan, Zi
> 
> 

