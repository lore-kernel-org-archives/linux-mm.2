Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 507D5CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 13:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1E56B0088; Fri, 29 May 2026 09:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682A76B008C; Fri, 29 May 2026 09:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5713C6B0092; Fri, 29 May 2026 09:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 477BA6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:07:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E299540154
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:07:27 +0000 (UTC)
X-FDA: 84820483734.10.CB3A6CA
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf10.hostedemail.com (Postfix) with ESMTP id D06E8C0004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:07:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A qlkbu3";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Vz88yi8a;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780060046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJMpW2hSB+jc3Eyo7jLlqbS5uTNSQSSe1MRVXWkIVGI=;
	b=Ko4giz0MStaGc+YAOlqig72lRBPABec2iulql83U0JBfRV+2hzrz2x09tS/2MH4iHa9Ha8
	7ILwPZxFPvsMwHZVU17Z+l69cefzsrgaqTBrbIdafeUE7wKONpqCrD5WbQoDlh5HGKn24m
	bww7LBI3tnvaFA83GiwESfUXxt7AEDQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A qlkbu3";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Vz88yi8a;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780060046; a=rsa-sha256;
	cv=none;
	b=7xZXxek87/mOPAPc0kdDbxCGK3fQ0wFxuxlwOjbjsAFFtPSoW5SzYQRycg0TRLbcVHF2pI
	NZsYhcPaFwpywWkxA63VpbBqZ0bXYSw88Im42qiOCj+1SC9Pjx0+desZ3oehV2GUqk0QuC
	S5CPagDbPnWZv5P/74w7S84ruNOxRZo=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.stl.internal (Postfix) with ESMTP id B4CE51300170;
	Fri, 29 May 2026 09:07:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Fri, 29 May 2026 09:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1780060043; x=
	1780067243; bh=eJMpW2hSB+jc3Eyo7jLlqbS5uTNSQSSe1MRVXWkIVGI=; b=A
	qlkbu3ntW3+2ZuNtKSO9TYVsaJmJi2Ts/rEd0kAc1N8RQX9IuuBlKtz0SW3t85S7
	5vJQsuzoYGLFukh74IlIeL0+PfIl8ARzT5hamXc8GL9cgN41FhalybVKK8EgiwKV
	ltRKlnSYzCKg4e+QU5gkmSHIU0/ULvKzkm2Dtft00GP6P5m7UGqkXUuG/eJx3rYq
	nVcFCsObnUzGIFcBm/ty7CjlXecbWP7efkd+wWv/9+a1+vEHm4hCUgcW4KpJxTLr
	kOB+bnKC3c4gWhJPhgKJR/kvQfm6FjPEyWepoMJ13pf+V0u50R2+3p4sHn6TAFxa
	Oe6EPRRmNX+1vFDNmCafw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1780060043; x=1780067243; bh=eJMpW2hSB+jc3Eyo7jLlqbS5uTNSQSSe1MR
	VXWkIVGI=; b=Vz88yi8asPzEYqiaJPJVw5TGNG4OkQzmQ6/u5BNSo4OxHHqt8j6
	9lYO7byEMoTTbVcbVSsuBLfCJL4YZ+AtVuJKOxysLbzNlQ19sMwM4GFavLo0fRpY
	hvjBDVCtg3wP4i+dgyLka4Q7lBs47wxwvLkH0Kn8dvyj6RE9vnoWSiITgD9Xb63I
	BEE+hORe7Xf6rchGwZa/2sdHG/Mf7wpN0n+tMk5mc/2CREAyRAJ4g3SqpknFv11r
	QcZ+lJZq3oh9lB7bmbU8fTvimeQnOjGe+WUCHf24JeUOb/+B4ouzrztbCz+xrel+
	GboHAMUT7O6m6JYNaZa07kOLMzXF2CoJbXg==
X-ME-Sender: <xms:i48ZamiyR4TJFCKeETpK0fupcUSI48U-aKFcwl8hdc-yadXIIcEDgQ>
    <xme:i48ZakrxZYHuxXFFTf-wEY9LtxmweZa-ycUy7qdfvVA6tYbg-xz1fSKYCMvpBPSYh
    ex_DIgVl-5ECEjySy8bVx1vVcDckjER-U9zV88SDEnWcow3JQ9jKQ4>
X-ME-Received: <xmr:i48Zajr-3qIMUyu-uNsOwWWoSqBazgcXkx5WnJ2jq80zD419GT_ybLALc1Ho7Q>
X-ME-Proxy-Cause: dmFkZTFAXH2AA1V/nISjcsAHVnuN9A/cQtlMi1fzE7O/cA4ypeDmxnBZg5TurfVPS8S9kH
    Idl7mOQ4mUWF2+2rvs6jrb6+USWJ0MtALSt9jwsgBx77XOdTRlP7hRKPWBegpWUy5GnWer
    4+wQXjC8oPOgHVotJfpOUQ16S/F9UDKdcLc/fcMT0mWO/KXvKDKqsLRI+8X2bYSzRnmDOU
    Sq5ftV09IsALoNh+0FN2cRDZLExI+uJ2rexuYMdXqXaZkXoXNhectZPiD8FLweTqpPjgsk
    ko2t82X3OzqjmCYsiBobOxzorIkY2aqwC64JMJjxNPUrstmZdeTN7JV5Tu5xu2AwEUfnqT
    nX93nkxbELa2TRjXls66dn/U8GzhVZw8Nl8f67bc/BtP5PSMQv+GHqYmSSGi/043BQMQId
    xviimONmYUxkj1LxzIOFcW3J6AqfcXotjvb6Dmw+kKPejcc8njSynM/VUy4TsZo1pmQ/Zm
    4f4aodsJY6KcIAtsyx2DqkFHVrh7np8+yISvUWnMyQ0xQcVuP4A4J4LUTmuY9Gyh7Q77g8
    z4VXYmgF/P4qRCns/dVxXMygSMcnkeZMslpOssUT0pCxbHbGVkUavIfAKVe9WbAXp0BTJN
    2RYrh2aEmIJuHgsmd2q/gmZU0hfplp9qFxauv/2ylXJoaNEYkSjb+N47tY8w
X-ME-Proxy: <xmx:i48Zai5urxGJdMaLkU4r3LI_qyZUePtIDRLjlRTMhsJMgE9KwheOMQ>
    <xmx:i48Zai2NY78TgeDjWcTkzKJi_NDZV648qPCl1wv2L1NcjvJoPX50pA>
    <xmx:i48ZammmfNsu5jHXs56eaiX5cXKHzeNSGPxiHjEPt5RFiwpWZxAbXA>
    <xmx:i48Zaji_eZ0GBm2G6k_pQO8yjvYG3ER1uLLZLiITJ1ZeB0pznqqI7Q>
    <xmx:i48ZajEc6-EeZGZcEN-13USyozFkGPZZ3I05AHPwXixJzrItS6EuK2_K>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 09:07:21 -0400 (EDT)
Date: Fri, 29 May 2026 14:07:16 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 08/18] mm: add VM_UFFD_RWP VMA flag
Message-ID: <ahmM8LzrzX-qP_5s@thinkstation>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-9-kirill@shutemov.name>
 <ahk60ViRq4q2g4uz@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahk60ViRq4q2g4uz@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D06E8C0004
X-Stat-Signature: bkptd5i9ngio3ye79oum4gy7chpw786x
X-HE-Tag: 1780060045-978034
X-HE-Meta: U2FsdGVkX1+fbl/OGAMXHU1WxcpRtLoILASuBR8O1BJ58ZSgmaTYx+P+CyxujkyTSPGGPbvIxFE8HkELV68D/YxVnHdyatDloHOI9Sab5bcVjtWSRcsVa1F9TioIti1pfWopEVDFQtsCmI7RLvXgqPCvaEIbQPaeZhaoTZT08EoMcZ9A5KCbqjlCdlb14cOFQqe8zcINwxU0c0SLlDCrUfR3XkUalhns4wWbSdyaChGXY3vPxJB9YnDJrEApyQTaeYCkXOCDUL1C++AGrVvCIQSBAB3N7EngPXelLJb3Yku9ZMvxA0rAPyglmZflI1H4prhatHeSYu+NSB0fDrZ13+yUgKqkvDjhHJ2XubrREHCAvwxH2RsyBRZ9WyaYm3r9otGRq/p9TVhUQl+mp9iHbgV1hwXgP0ekmQE6zQh/bkMx1oK+JlqPw9s9AshQGRdvs2XobgELelHfteQBElQ8nx8RW52SPaM8qeRKt/bayb+6GazMmdxgm5nI1vO9qP8h8tIXtomTcc6LWJqM/h/Rx7lIiROpURsOnts+nB7KsxHlo2ONC2pELeCF2rljRea81iPIyWVgpfuGWZfntv7l36bOgu6FjvyjW+EXRxmIIH36SB9DVsGfJjDZoSZJohJ1Wz4YQ+PsHbmf7Xv1yqd7AX4SCAaa6VKQbMB6xwlQUscT8p9J9QGggB7x8C7BupecdelDgSf7cZMzHjddB0tfOERbzR8X67dtAJyPEDi/WlDEjyV4RmoNpriEChPclld8Q+p7KShEplDOFb9rV0iA640DWFTT23om9lpj8tY42CLheaqAs1C7duyJbfJRfaXO6pQudm8MiLd3PcLf8qsLmA7AuUPRcI66jH+zY9V4xilEvsqGwydaRkdGGNHtdNcb1uCML7zuGsYs3Q60o/j3hVgrHZPuBBogpQPTq34FW1LRnpaUTy8OqagrcLGRkaqgyoDvMNXIOgQkFO4jXpp
 nesBYsEq
 +09OBAoQgSvgf4O97qsPbOhtJBKZ6fanL4XewBd5ztwH7WxhyGADrGINNo7EYMw7ZmyONH/Q8c3D1vIg7jkP45p2MTMtNLwLvqNaHU0X/pZ4FwMhcaIRCp5Dm87z68Ou4649p4AXRNSagWW6PQEdiKQADTEW6bKit0wPzDnTG5jcaKNzodKdDdbBohwVmQ0CHyLhoHtkkTOHEcAiOnXonqrQTD9qOxbbW+eBOZFzXiV987Hq+TcrPa+rJY3R4NHSxYDZ7kzE8PulaJ/Vied0FH2IIhp+7/Wdy2ELr2PDvB88UCELMZ9oAr0wBA0vKk3DIE6Wx0iAViQNQCCulwpdeS9R2vVoRjzY9K71+OuZK03vQegZBXz+pIybxZ9iqG5CQkt8yuEyXu0sR01+bJysi6uX22BLyENtduJSUCltCW0AJhwc4qRs59fNYjIxD/9q4X58WHrvsu9sHsyOFo60QEBIk+Tf7PGRmtGzKFQ4o088q4uVJoKv0aR5BKDACPokU6tuqw9UwvZBX8Dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 08:24:55AM +0100, Lorenzo Stoakes wrote:
> On Tue, May 26, 2026 at 02:04:56PM +0100, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > Preparatory patch for userfaultfd read-write protection (RWP). RWP
> > extends userfaultfd protection from plain write-protection (WP) to
> > full read-write protection: accesses to an RWP-protected range --
> > reads as well as writes -- trap through userfaultfd.
> >
> > Reserve VM_UFFD_RWP, add the userfaultfd_rwp() and
> > userfaultfd_protected() helpers, and wire up the smaps "ur" entry and
> > the trace-flag table the rest of the series will use. The flag is
> > gated on CONFIG_USERFAULTFD_RWP, which is introduced together with the
> > UAPI in a later patch; until then VM_UFFD_RWP aliases VM_NONE and
> > every downstream check folds to dead code.
> >
> > Nothing sets or queries the flag yet.
> >
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> 
> Hm, if you've just used claude to bounce ideas off, I'm really not sure if
> it's necessary to disclose, though I respect your thoroughness for doing so
> :)

I've elaborated on how I used Claude in reply to Andrew:

https://lore.kernel.org/all/af5eALk9yO8pPcHv@thinkstation

It is more than bouncing ideas.

> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 71b11945e4fc..6499cfb61dc4 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -362,6 +362,7 @@ enum {
> >  #endif
> >  	DECLARE_VMA_BIT(UFFD_MINOR, 41),
> >  	DECLARE_VMA_BIT(SEALED, 42),
> > +	DECLARE_VMA_BIT(UFFD_RWP, 43),
> 
> I'm guessing CONFIG_USERFAULTFD_RWP is predicated on CONFIG_64BIT?

Yes:
	depends on 64BIT && ARCH_HAS_PTE_PROTNONE && HAVE_ARCH_USERFAULTFD_WP
> 
> It's a silly situation and once my VMA flags stuff is done it'll be
> eliminated but for now... :)

Yeah. I actually would appreciate your take on 04/18. It is related.

> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index f4cf5763f92c..0aef628514df 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -21,10 +21,11 @@
> >  #include <linux/hugetlb_inline.h>
> >
> >  /* The set of all possible UFFD-related VM flags. */
> > -#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
> > +#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
> > +			 VM_UFFD_WP | VM_UFFD_RWP)
> >
> >  #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
> > -				      VMA_UFFD_MINOR_BIT)
> > +				      VMA_UFFD_MINOR_BIT, VMA_UFFD_RWP_BIT)
> >
> >  /*
> >   * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
> > @@ -178,7 +179,7 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
> >   */
> >  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
> >  {
> > -	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
> > +	return vma->vm_flags & (VM_UFFD_MINOR | VM_UFFD_WP | VM_UFFD_RWP);
> 
> While we're here we might as well switch to using the new API?
> 
> Can do:
> 
> 	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
> 
> One unfortunate thing is using bit values means we can't do the VM_NONE
> trick, but if !CONFIG_USERFAULTFD_RWP then VMA_UFFD_RWP_BIT wouldn't be set
> anyway, same for minor so this should be fine?

I think we need to decide first if the 04/18 direction is right.
We can define VMA_UFFD_RWP_BIT to VMA_NO_BIT if !CONFIG_USERFAULTFD_RWP.

> >  }
> >
> >  /*
> > @@ -208,6 +209,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
> >  	return vma->vm_flags & VM_UFFD_MINOR;
> >  }
> >
> > +static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
> > +{
> > +	return vma->vm_flags & VM_UFFD_RWP;
> > +}
> 
> Can be:
> 
> 	return vma_test(vma, VMA_UFFD_RWP_BIT);

Yep.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

