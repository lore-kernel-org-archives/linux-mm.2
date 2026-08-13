Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EFDC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA856B02A1; Thu, 13 Aug 2026 11:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A639D6B02A5; Thu, 13 Aug 2026 11:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CAE6B02A7; Thu, 13 Aug 2026 11:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64FCB6B02A1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:49:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB3C5C01DD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:49:45 +0000 (UTC)
X-FDA: 85096681530.08.B0E0FBB
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf10.hostedemail.com (Postfix) with ESMTP id C41EFC0008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:49:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xKKbj0tK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786636184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WogPwlsGGMGx2Gt7+5tyMs7D0F2LPMr0ubWwJmXylk=;
	b=mhPxQcjmoXMQH4BD3n86Ll6VDnKE4JVhxD6t3cPGwAnM/nzj9yAWvC4f+ZjmeU3de2IUdk
	Id+AcDSFZg27KULDYK5nD5pt7bFU1FpzLdNpNROfyTOSJ3FdjJKgHngk2IkP0sBC0koIa+
	XHuyuj7y1QJ86J0wpBH+Yxbx0KrLJUU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xKKbj0tK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786636184;
	b=hplQaSheBeNb7vTDcT6MhjqnAh+8sN0pCihtU5gVCF/dx42sn5IFW0KkBIKIUado72nXM0
	KZUkDYNktEHzGsqCbk/ql0Rgeh7yemSoI4OdC18baLaXWjAQZlPy8siW3LBST2X3uL2u/u
	dIpXmUj+2MlMFeN0h2BGP8vcn4yyCok=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=44TR69x5ZAwBqBOOwd22fnYBam5ymuntq7grA3Sn4D0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786636182; v=1; x=1787240982;
 b=xKKbj0tKLi0NSB6TAgaoQicyHfgBNzS3hxfGkPf7DNOsPu/l/MUGY32z8wHoKYkYkhr/iYkk
 tfKSReXZNkWsSD3Q06H5ImqVk449AEmV2Cmo/B24X5jFaDbgxdzIogkaPL/Xgsh4KC5ND7GILEj
 t0YzHznab2TmQnH6rrtqEhEg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 1965510105143205;
	Thu, 13 Aug 2026 15:49:42 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 16:49:40 +0100
Message-Id: <DKNXO2ODV6AN.C0CFRAHJJUA4@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Patrick
 Bellasi" <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 05/26] x86: move PAE PMD preallocation defines to
 header
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-5-6f5729aa9832@google.com>
 <am02PmF4-lPErIVd@google.com>
In-Reply-To: <am02PmF4-lPErIVd@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C41EFC0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 436m9q13p7hot469erwj6e98s5nted95
X-HE-Tag: 1786636183-679936
X-HE-Meta: U2FsdGVkX18B0P+KZ2Zyfp8b2wp2s6rFXY8CHGI968ekaOBB284McZ8V410CTCFj2FqhN6sfECqphPrSJgYdFE6XrCcHtR/igGHKsEZdTcKgxqC5ikSQniSw25c4w7uwv/bbzwnIKREv9Zyd5sBW/x5JqfeHsUxkB2Tuts+Uuo1DjgqS4jc/uMmSTfdmGJ3LaWGBDwoPEG0zV/upRyj44xoeE6UG5QFOupjLUF8l/hVN8fHDsIGZU9ljsDc3mODhWtI9O5k7Irgc5THeKblwxLINApGLXMzCid3zUta7YroK1yax3VUyTHZTd/zcUG6vrAiLrZLpY/a1KgNd0vJ4WOhe084frYmB+MC7UYG7HrU248I9Eqdnv6A6WJRq16d/AYNEMvuLCXkIYISIDcxi2maMxc9wJnTpNCm0KJnAo+Biy+wjYstPvCvnGEkPvMuzBBcZg9sBqGhe3++2a1A7xwarb+7czu1dA9dssifYJeiJXgpkptYBUlCqLgesclDVHzhYAskrwVYnO2ITbWvISQ9VhkymxX6CUiqarXcTETrkLG1rNibsrDX5NwipfqsSys62FK8sFWk7xJUSxOGUfb9wLfPfGq3PbjnwAx4e+/vt06Pqbzzn0DOZstcTrnZm4CbXFuT+J6j553TlaFK6g9nh4khie9IbMsTBEHJNvYUzDsQlpOI6tQ9/wm75JndkdUFLLiYhG+X7F81+qgRm3u56REudj1jdzWYr8nv054Ba69A2Ij5i3uKTu1OFmvB2q/9e6wc3YBODCrlXsnTjqNqoO8WJGMvq/X3A1Sio/CK30i0MDnnbNVt6HXawZCL91JLdtVJN5OebscZ0ZHLiyVmwlWvodcsT6OCdY1bXLXIjHodZIHoTNMTXFzLIszyPZL/8/HBrzZ3JnBVk2HKAWqgweZIX7LEq03L/9B+KylVTC80myOXnpEv2fXz6T02I5/MvUXma6pe7U9CixCD
 nxSL4tXa
 9WzP2PemAxogAkWmyJIieEZwhSuJafJyQJ+0ClameRxdPJanBqR90/VS6D8ZQmaG6pWBbrJpbW+pPW+ynHV3CtRTSMgiNa2oxZQ36XI2vLLtOYjYoOE07+hyBsUyKSlOsyjPAzEuAiPrEvZzcjVzTyoDL/Zed6zY904gHLnu7Fdxxf9uR8+zF9t89LvdO2UcLt7cC9pl6o6HC+pD71Lm6FWcXuIe5E9vMx+vduBRUWeoBSYkzStQ4eh6LRlrRJIjLKuI16HrBlOS5dg0bY+doek+9edJDas4u3/hP/qEQiN+eY/NzAO3wuWPI1oc+vtK95yCdeE+LkUzh2WY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 12:59 AM BST, Yosry Ahmed wrote:
> On Sun, Jul 26, 2026 at 10:22:38PM +0000, Brendan Jackman wrote:
>> In a subsequent patch these defines will need to be referenced from a ne=
w
>> file, move them as a separate patch for easy review.
>>=20
>> The comments have style violations (personal pronouns etc), do not fix
>> them as this is just code movement.
>>=20
>> No functional change intended.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> AFAICT, this is only needed to expose PREALLOCATED_PMDS for
> mm_local_map_to_user() in patch #7. The only usage is a BUILD_BUG_ON().
>
> I wonder if it would be more preferrable to keep the definitions in
> pgtable.c and add a runtime check instead in mm_local_map_to_user(),
> something like:
>
> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mm=
u_context.h
> index 09b8d8e6a56ea..15055cb80092c 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -268,7 +268,6 @@ static inline pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsi=
gned long va)
>
>  static inline int mm_local_map_to_user(struct mm_struct *mm)
>  {
> -       BUILD_BUG_ON(!PREALLOCATED_PMDS);
>         pgd_t *k_pgd =3D pgd_offset(mm, MM_LOCAL_BASE_ADDR);
>         pgd_t *u_pgd =3D kernel_to_user_pgdp(k_pgd);
>         pmd_t *k_pmd, *u_pmd;
> @@ -277,6 +276,9 @@ static inline int mm_local_map_to_user(struct mm_stru=
ct *mm)
>         k_pmd =3D pgd_to_pmd_walk(k_pgd, MM_LOCAL_BASE_ADDR);
>         u_pmd =3D pgd_to_pmd_walk(u_pgd, MM_LOCAL_BASE_ADDR);
>
> +       if (WARN_ON_ONCE(!k_pmd || !u_pmd))
> +               return -EINVAL;
> +
>         BUILD_BUG_ON(MM_LOCAL_END_ADDR - MM_LOCAL_BASE_ADDR > PMD_SIZE);
>
>         /* Preallocate the PTE table so it can be shared. */

Yeah, I'd say that's fine. Will get back to you if I find another reason
why I thought the move was necessary...

