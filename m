Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B8CCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C13C6B0093; Mon, 25 May 2026 11:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299BC6B0095; Mon, 25 May 2026 11:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1875E6B0096; Mon, 25 May 2026 11:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 020456B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:28:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9ED1AA015F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:28:08 +0000 (UTC)
X-FDA: 84806323056.16.175158C
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf07.hostedemail.com (Postfix) with ESMTP id A2E8540014
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:28:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=n1xkldKn;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="r sQkKnh";
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779722886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5sPpgY4pqLUq5Ua2SzOVVUIU5JsKkHbpOqh7qLA5oo=;
	b=M6dVHJyRcYOyV5Q9FT4FFi6NPXgISzcX6duhyIJc9kM838TOjN6JqbbNAFIEHC+CI5OFJn
	ioRNmeSg5FI3Hp2Q7DHx5+nSIHaJOhLt6wOaZzQEcNMXTk7krOnjXJeyr69CaLJwSsm2HF
	MbPBd0LSOxhlbhe+bCjD6IINR/CT0Wg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779722886; a=rsa-sha256;
	cv=none;
	b=xKTyfoSsjGsdoRqtSygYN4SEH7KIr0/V7braRWHkVaDnxQqXO1vBLTyksXpnm1MPZqEyzF
	+Wc+nR3Yb/WhxckBjKp7/kUY3c0eJ5XbfxuLnftM1Pz1gT1aQYbWUXtnuwJ9Y0wnBKSCp1
	Fy4u1iVEh7kM+V8vFmd/VMH4eYSQSbk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=n1xkldKn;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="r sQkKnh";
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id D35F81300655;
	Mon, 25 May 2026 11:28:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 25 May 2026 11:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779722884; x=1779730084; bh=p5sPpgY4pqLUq5Ua2SzOVVUIU5JsKkHb
	pOqh7qLA5oo=; b=n1xkldKnO+UgyyK5WP1utn1ROqplED9tbyhKIfk5Ph2y2E8i
	bh+ioh67uD83q2g9Pl0jSjqnCy/N9RF2z0e3nqXq33TDpPQGzDEC5vEwXt/AExxP
	SXsq11ed91ndigqOU6tkgcFbctlOuF8F6xMdNAdHmLB+5mHP6egItFcm16Br5QkQ
	iCbTx/Vd4/FsoMtzzN53FfVOQmaVfbpoL6G/o8ajKb+UmNph2uSEMgMP+uzUrMgg
	JlprDH2vTiBS1BWaembS30JKSNSdAynSOCn/8AHfAG0GzeFptQRJrxe9ikFzgjJJ
	9pERlEtv48zTc0VJkO8A5iDmvDR+2rrudHIg/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779722884; x=
	1779730084; bh=p5sPpgY4pqLUq5Ua2SzOVVUIU5JsKkHbpOqh7qLA5oo=; b=r
	sQkKnh6mYVYwvJCOyp7U4+WY+3m8/Y8VVP+pkV6Qm9EH66LrCapf/FaJqVpwCIzk
	ykp5M0YnN9pIsjgghK/pM9X2tLXSIsh61I6bgJDHJoGPjnpX69JVAmu5PuqhgXpp
	EntHWm3heubDgKoiS+FJhPsNEoo0QHQ584P9iGj6fOg7hdhjz4AjNGwb7cesrNTO
	m1s9IhoQ0IKT1uLR/gMOQseWMUaQW7NollOEBume0zXtbUhQZGdQnohK+wNK45ap
	1+6IUKtpkjCGNqtvRzKlELxD28DqjF8huP9oQVUIBqUJRkPkrFZ8rHAp8FkrtAkD
	RsooIMu6fosbKj9FcqX4A==
X-ME-Sender: <xms:g2oUamob8-5-jjeeUqVU8JCv57V2wOKwaL6CobOVTSmHTolO7gQ7eA>
    <xme:g2oUatBwOV8vKW0Cvhw_kFm5FhE_pAoiZpHJl-MsujwO5DMj4wb37pqnBJvwHOF7T
    XmtJ761IH6ZO_iqcOvSv4LQ6nzuURM5fY27hxXRRsCVcXS-m-HpOA>
X-ME-Received: <xmr:g2oUalcuxydW_q0PcB43Pd-U4l0eZWoCrS8Ek1aWnbPbKrJrw6KlPz72w2PNSA>
X-ME-Proxy-Cause: dmFkZTGXLYgz2/5cvkQ8YOUtgjiSVz3J+9ImrgeJIW0/3ROMrwzEaSSHOx7KIOSgYiHDEY
    NT5qr4GwcU+hQVbqBcRP64Trk2rAAQKYWKvqyq63fviDvjzNhw7gjZOqttQ4zj3NO8xpuu
    xZRzrkFxrIPiCAx0dtQ++u/KifT00VuJQkwjlD8MUzsDBrqYNAZA5Xo3ZDvu6nVv/5Bx0u
    i7hdnuOij6YYWkpIpHhP27CBcoX+k5d1uygQStSEPTqSC6DIQ/wVTIPhLkvWWeyEDnaLmt
    V1IRjTA5IqqrEzomoekCXRcktA1GJtLxGZpLYagD7rk+xa4f9FwpBoi0M09uo36Gqn3LbY
    o4Al6LDEsOMosIdcXLmH3skHumIaUAe1qk4Xp+HHVxXcF5dNfaAfuzur7+i8tzKXo9S/xM
    ENwiCdGi/VJ+Z4jOaJm+5sa7uAr8Oqen811PiPux//4OZigp0jwIa0ctjJRFPPR+nW7pn3
    +WJRQ6tRvXpWBDT0VS3Eo3ME1O5Zc9C0TE1Trc7gGVLKXlhU0KY36o9KvbnnXSo1Q0XQXy
    Zze3D17t1YtNnacPlFC+XTW/C61QYrUqltlqs/L8WrNuh/Iq20lWy1aU1x+seN8CjBwH5t
    9jYuuUFEc+JPuzsjZinTuRV0xHFyCaB+0yRe2ziRc67Vh9n46NOpQ5fSq5eQ
X-ME-Proxy: <xmx:hGoUaqfugyXqy_2RB6OPa2ucfdABJDomM8umT2F4k-zisZ9LuC2sZA>
    <xmx:hGoUajMmkivHeHRs2r5KgEnxioJWWmMCh7NftciAXPk4C0BNvoO3Xw>
    <xmx:hGoUarr16_W8YPaW1gm2938Fz_p9a--xpl61NepI6Se8PJWdePJncw>
    <xmx:hGoUaqWjQ_ZCG8SXWeC4pDw5Npvt-EY1TdwRqGpOVKXmBrwIM_wv9g>
    <xmx:hGoUapLIfcPlEgw5DuQtp2BSJAFSn_SDSB8h7vEDFHAZj-hFV5Qe5VO8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:28:01 -0400 (EDT)
Date: Mon, 25 May 2026 16:27:55 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 09/14] mm/userfaultfd: add RWP fault delivery and
 expose UFFDIO_REGISTER_MODE_RWP
Message-ID: <ahRoqRfvEHGl1UNE@thinkstation>
References: <20260525113737.1942478-10-kas@kernel.org>
 <20260525121858.57D0B1F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525121858.57D0B1F000E9@smtp.kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: tq874wm9gtasoafh8i53ht641ufakdnc
X-Rspamd-Queue-Id: A2E8540014
X-Rspam-User: 
X-HE-Tag: 1779722886-349306
X-HE-Meta: U2FsdGVkX1/8QCSxXBjNjI/BaNyjcX1lr03ipuuaVVr59Z0QJaaDVQP7zP4PYClwE6Ydq42eXtazJ5TIveFLN9EDEWwOmJhnGkoqoEyNSTpnBMFtUVt+7KgMhqa8c+Fmu7XWncIaGhOArBKQ2yzXDSlSV4m6XGrHLIDwSyEHQvCJx3mnjKBQEm8NCM5KLIcXHlv/m1jmD1R9IZEFHUuzZeNCOGmSBCi8CNHlS2EweTzFNhLwfAS9a9v98Xq46/EOiO1l3G0g3h3IiIiHMqiY369zBaeJC3+tByFKxDNxMJMqYbij5e4TLxP+YM3OghWVS+56ymfWGGQc2CjMDR3pvtBzw6PLAjLYi2uSAwJAa0/HMucRZhvEqWINDpzaRkzprGhBHF9X/s/jGj3X7Z6l/iMxbwkq2vO+Xlne0lcOHxVLE9sJG3jyR/sh9mTDjkcBuQ16MgBhM93e+63LhsPZxxzNpGwwJlFTj2K8vgLFZMFTEqy6oVJ2S6Bq9RIINTx5GKTGiCfZWS+B5V5kEjQrTza8845/vgkiBiYdOc07wA3sCUMs/DtLeSSHymrDaHL5NmVNSezZYV1cbg1/7GeuzO9bc7lDb/0kuJZ0h7uEtBm8cpqy3k82aMSnEJwOfyz5WJOUZy92js1+NceJfJpSAVIf3eDwa6pyIJ28GTmJAUMjGxn2X1yGJJutTOD8dQM9pH7hof+OAfGqMiS9yei2xeV1WMCmpAqF4ZPedERsIPwvppWLNdtjycdE8DEPBSlcKUVuHXlFr5wRpmqU4vpa2ZaXohAbFrDEQQbEfMcct5smIOF6SCFmN9xAiOxGNRASO6r3LGxsFdIRa73fK3/5dKBjoOQSPm6virEBElq0gHEDBTm1k3dtUswcMgSWdH3wWew3mY3+ad25bKGI0Qe6Hux3zlGynB+65qGNml4CZERjDClT5sYJYbhQmv443T17++9NghOlhWIbVSa4Ojw
 +TaqR0wV
 HQ60SF5jXzhKEFwXvcifffii2nQ2bYG+58jjaltw24p3Pu5blMxIXC5Dq9GM8vUH/kw2Zct3TffWgOLtvS6174sm1hpWwBJPM5bTGLtc7DO2cNb3AnH9dQAO8lhg1DGxTRTYGBVjLDQVLOeIN9zR0sNfphq58YtZE8FNpcWlf2uBBzordBNWWwt1EEd9aUgkwnUxmFVFJjjYq2vsJxZbx4W46QVYTXN24wvnMedp8nuPOWmTSPIRU5zOO+QNP8SPQ5Ldt5/E4HhGgxGgOBGcTiSFvShwEA0sDtUtcVPh7wmNOwO6leOyKfkx7MX0Y1w4K/MZ1PvtcFJkg3fMEI37CDcXqWvIYpjlhLNAnfyfXBO87ggVj4sfvaARgzg5BnaorI3klSixKNfhVcvvbbPMGjIGIimG59euqzNgMdE6KH4kZVajQ+pi0w7pEr5kXyPMADGJpfp7/AuYjC8rTTIeUTQuhNgVG7QmM4qVUZt2BInSye9MT4Xmzq9kuJPjYlSUySSqJuI3Nkzy3JHLrTWi+WyhdhspY1mOCyZbNPc6r1BVEmX30PDovR6ROAw8Ljh0mpLGhXxoGcsWSkWrqcGIpJAenkFCp2gICxqs/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:18:57PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> 
> New issues:
> - [High] UFFD RWP tracking is bypassed or causes an infinite loop
> during GUP FOLL_FORCE accesses on PROT_NONE VMAs.


Will fix in v5 by rejecting UFFDIO_REGISTER_MODE_RWP on PROT_NONE VMAs
in vma_can_userfault(), so this state can't be set up to begin with.

> - [High] Orphaned RWP-protected PTEs cause an unrecoverable infinite
> page fault loop in hugetlb_fault().

Fork goes through copy_hugetlb_page_range() with the pte_uffd gate I'm
adding for the 06/14 finding) the orphan state isn't produced.

> - [High] NUMA balancing silently strips userfaultfd RWP protection from adjacent PTEs within a large folio.

Confirmed. NUMA scanning already skips RWP-armed PTEs (the
pte_protnone() guard in change_pte_range()), so the two never coexist
on a given folio at apply time -- but numa_rebuild_large_mapping() is
the one place they can meet. Will fix in v5 by gating the rebuild on
pte_uffd():

      +       if (pte_uffd(ptent))
      +               continue;

> - [Medium] Missing feature capability check in userfaultfd_register
> allows enabling RWP without negotiating the feature.

The check is there -- mm/userfaultfd.c:

      if (uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP) {
              if (!pgtable_supports_uffd() || VM_UFFD_RWP == VM_NONE)
                      goto out;
              if (!(ctx->features & UFFD_FEATURE_RWP))
                      goto out;
              vm_flags |= VM_UFFD_RWP;
      }

> Pre-existing issues:
> - [High] Calling present-PTE accessors on potentially non-present swap or migration entries in must_wait() handlers.

Confirmed and pre-existing -- userfaultfd_must_wait() reads the PTE
locklessly and applies pte_write() / pte_protnone() / pte_uffd()
without checking pte_present(). The pre-patch pte_write() path has the
same shape on master. Will address in a separate fix.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=9

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

