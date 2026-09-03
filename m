Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5437C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A506B00C9; Thu,  3 Sep 2026 07:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3E46B00CB; Thu,  3 Sep 2026 07:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1FF6B00CC; Thu,  3 Sep 2026 07:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 851B36B00C9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:54:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B44212043E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:54:47 +0000 (UTC)
X-FDA: 85172294214.29.4A9AA08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B1A5C0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:54:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZwBmM0T;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788436485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrsApyRAlrAEXb8oYNM0e4ki57YGn/dS7fq9ucKxGg0=;
	b=mGfHzkoe0prlnQIE/pqsoM52LuNe7nF4WOC60Gj9evBI9ygV4IOxxfLaRQug6Xad0mo92N
	Szf3K/zN47Cu1WVul9unwLby0vjq7B2VE8qF2Di+/Tf3oof8phFUvBg1UkYAdcf7caM8BK
	AAFEHKqVJHI5M5WDoNI7nTB4DWY/wyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788436485;
	b=HpcNtsfR5IbHEYLJ2tDlm87pfwi7beT+jk1txS7H9Mblkqc4sPvl0RbRea6hdIbdkX8FOU
	tGs1cKNGGR5iWf9S+pKu1qrxpXUN1GDeXnNpZCafmtSNC7h7MCXsqnt5vL+i2fa4dKELcC
	oawOjwBSYoxL+Ct5aOK1LMC6bv7VhY0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZwBmM0T;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB0CD602CC;
	Thu,  3 Sep 2026 11:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D121F00A3D;
	Thu,  3 Sep 2026 11:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788436483;
	bh=lrsApyRAlrAEXb8oYNM0e4ki57YGn/dS7fq9ucKxGg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JZwBmM0T8rEezI81rzPOtSKsc80CaL0qZizFtL+7BYIla5SMnNJZL1ZxJjRMEwgqb
	 gR4JmwhGNnvMat1WcDCGZqu7ugwvVJniCdnA6UhbsOMP9uqja/6lqWPA5P0+bTISZ2
	 iYoC9SwyK9kQeJxNYiAA40wW0wHu2XS+FjcP3KT8B0uJj5nqmZpICVU9QWKONsL/Y3
	 paVGcie002Aj4ei1NEzGgFXNeJytaSUITaXeUQIHuwISBbexfo5nkDtfxHgItV1Uy1
	 71giNJZPbXLuwvmZAmOD8nVNFOaOIb2w/nO5gDXg49SeKvBzyniUe7DWM0U9QA6hJ2
	 aw5YXbYyerxvA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id C09CB1980050;
	Thu,  3 Sep 2026 07:54:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 03 Sep 2026 07:54:41 -0400
X-ME-Sender: <xms:_V-Zaq-oLXG_tbRV5SL17ux8ZZWIWBI5lch0m-ICKJSNYjW1Kqxdcw>
    <xme:_V-Zam649lsVdZSxRBe8Y4Fkv8iPQl4xoKF8yi7-uhpSI4N_82rXYncBjTcOcrgdl
    jru2YnK1iltr_y3MKD6_bDjGKrjFVmUrmke9Ez28f6iFIpVUGTzVKo>
X-ME-Received: <xmr:_V-ZanLB9z9pZZPNfG871FvzpdzBWebIxdafXCmQk9tqTj5p2-gfcwKhRxA>
X-ME-Proxy-Cause: dmFkZTGRROi4E2jYkPmHGn8HmsKJK+DNhzW0iFBovk5qrcANvc/cyAdiFz8Bf10UjHIIr2
    OCiNRxEcjH1fCCFWSCLqPb2F/nchosJWO+1x6Hoz+5AHWYM5O+CqFcxplyHcG2m0w7RAOJ
    RUZ+jd9/a47JGJrOI5YRYubkQnZiRkL/W1JEXFNtY6qVzb0v768ExU2eXwalE45ySiF3R2
    U4Z7aVpbGLrcxzX2HU/qf4+p9hJ62k5bAdwGbkZvc5vvqB0dtHm9E81ImbEPYAPyYZDO3Z
    xZhLFBqWVSekOwAehorhA1EfjVwqRxpVeLw0fgGTvb/gfBm6l0b+TMrVkfw0ctulats7oK
    wGlwKgXrS8Ti3z540MLDbn7ePC2qI/c2MtU5JUF+dLTMXiRyJivzXiYAn/9wsa0PY1oHXu
    JzW2v+S/SSoVTcbO1JuhD4Nyd0FGNc3o4UObcbk6f1jbDrRJpNJ0EXmUmTp1mwjyGtksB+
    E2wuRcH8c/rtBeyz+MDkuxCE+hb+/e2KAncEfo3PsPYjNhQU6LKaewoSsGySzAeR3lLM5U
    GWx4Tu8ac0h3jZKjFsfGmSSulZ+hKt7eqz9x9VzuosBEqTQAVTDsESwXOF2SwVzeHoF5VZ
    xwz0bboXiq1kvRifcmh7pN2ZbSSOgVvpoezUhaLz0B8RRjYLfKmMTOap1iWA
X-ME-Proxy: <xmx:_V-ZauAr7fM7WQUuNYCB2wNA2X60UGgz1puUga-gXmYLooLrqGZshg>
    <xmx:_V-ZagiOWoUgQIkkfpkSxwqFHXG16Z4VbZnV2_hDIOY49EB37rOr7Q>
    <xmx:_V-ZaiN_RjR92LznnJrMHPgOIsfRfnKwP9OeVFLO-_u5WtWMYA1ElA>
    <xmx:_V-ZasXGbsML7uAsQ1LEveq9goQh64MBgn9PW56oEWw-3GsSNWHk-w>
    <xmx:_V-ZanCiw98vjCVwwHH4u5kXCgv2ETVbsI4nOpwXxgN_C3BUMY9LCzWE>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 07:54:36 -0400 (EDT)
Date: Thu, 3 Sep 2026 12:54:35 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>, rick.p.edgecombe@intel.com
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, akpm@linux-foundation.org, david@kernel.org, hpa@zytor.com, 
	rmclure@linux.ibm.com, andrew+kernel@donnellan.id.au, pasha.tatashin@soleen.com, 
	tj@kernel.org, rppt@kernel.org, yu-cheng.yu@intel.com, orsonpeters@gmail.com, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
Message-ID: <aplfcTfjeQUgnrvH@thinkstation>
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903031608.1194238-1-vernon2gm@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B1A5C0003
X-Stat-Signature: sztfaeq3yuxyicsgjhpn7y6sx8xeyppn
X-HE-Tag: 1788436484-37853
X-HE-Meta: U2FsdGVkX19U/ArnFz1T3y32kxp0gczgyens/3fbzhfV/Zsl94wP7fPAuJDBSkh5j5eUN/q8wWMXbXkzfe7Qc2rPlE4Yx/56JiQhJ9Q5UjlFZAhHNRmiZTU92+SUb4XDBscZwjcFOs+uNjqxQ9gTZDcvwfHtwK/ToVyLtl0DPG3wBtS8J0He0XRF+nKgqSNRMBhL9xy96tLlrSJ38XI5NCVBWaDirKgfgi1NrN4Y+fzoyYQiF2hiXbe9DsSgNS48OHvtnR94k3gcs/k0+wJ8h0gDr6tmc0KXHl0lIOJCPOpCWeiwt1+Rbt9BhzuwLm6PiSHj4MFyb0/R2fwl9eRq/OFa4t/k/vbuLSbAZWCOb3NA2T/maM6/VH9j4yMnFmXoGfcsFXy7YC4nnA9UnRbx81SQ/rgBGKoFqMphoyxdHm7lXE/rnudWbYB3qiEF6HIgBtLrY9YytTQ4ViQ9d6F7/iJ5am/vCXvX+7n2+mLoCQeWHpqYYrt7LqJEQBXR+l66T6UpDcJWYyYIfrcr2JRloPZCT0NWLTkLPUha2gUvckA5MIVL9MrpzIFYAR2rAwcYF6zxeZ7NPIGzBGANxPCXAdCqOuy5eDXQLH8gTmcvs2b4V4e1azW7F5EslM4sB0TDRlOhyB0S5AfICGKYJ+uukmbl64k4JsrjqN+S+1cJcwJGREepQ+i+ZXpJFgtR2vyhNeryKC8XVnxe0HfZn+F+L1IWL3byT1Zv7brGfIj3jaGNq2zNHAknZz82sJRah+Qi8mMJVwoQ07KyLzcWGzvhbVjxfsp6YKhcULxDPWoGTEjNCHbV8lvjG92mXEcMcuw+x+VJS35b1fLdrsYUjhTFx3nFc1JfEtUzVVAne5yNif8imlX87PF0CjRR5ua1WsTgy2qRTORf5do9wQGl9vabQbMbWU8qK4ejrN14xqxCYr4CDtIKmFafM9YAvfzJ8034gCSajqpfLlUFDTIcvQo
 0eiEOfRu
 tgrmlWWOqWvQE3ePfphP33Sj2wjD5vn5Z6MPsuqEHU4Q2VrZOA2kIuq17ap05vnDVHKeczJM+lAyKHNqEEGYKKfT+dkRu2YZcSjeD2GH8n7vyDNj6WqDygGnW+gv0VU57KcICVg9IMo9XP0JbZDaEWTqJJ8SnaT251UQnvmx1HPDxswn6vbk/kVf1aLH6BM14gPCV+TkUHVJ07f0T/kKi0RqwOVP9n0pokNIQBVojdnd271yGktpN3/0fnHROAGIfvGGOiaUoh4eefW3xoKdu2Z+QIR/ufQMjzTSX3ohLRd4S3zWR8krxG65PADGOpscEpr/nxXBOjX3MbPZr1aWm4kAWlaGPT2gasEZ5fqOMdpQVatTPCbYVvSNjxQ3b/YU8dcMcLWgnnTnJT7qCrGlJUmjI0Y9V4DiivbO+Z7e/OJ4ro5u3bDNIFJCOIrLvT+ntR7UixTYBCnpLXUA6MFuwlIaHhDlbyghgv/MA78JqwXtVkAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 11:16:08AM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> pmd_modify() masks the old value with (_HPAGE_CHG_MASK & ~_PAGE_DIRTY),
> silently discarding the hardware dirty bit.  The subsequent
> pmd_mksaveddirty() call is supposed to transfer _PAGE_DIRTY into
> _PAGE_SAVED_DIRTY when write-protecting, but the dirty bit was already
> stripped from the value, so there is nothing left to transfer.
> 
> Contrast with pte_modify(), which keeps _PAGE_DIRTY_BITS in its mask,
> and pud_modify(), which keeps _HPAGE_CHG_MASK untouched: pmd_modify()
> is the odd one out.  Any pmd_modify() on a writable, dirty PMD loses
> the dirty state.
> 
> One visible consequence is data loss with MADV_FREE on PMD-mapped THP:
> 
>     memset(buf, 0x5A, size);          // PMD-mapped THP, PMD dirty
>     madvise(buf, size, MADV_FREE);    // PMD cleaned but left writable,
>                                       // folio marked lazyfree
>     memset(buf, 0x5A, size);          // hardware sets _PAGE_DIRTY again
>     mprotect(buf, size, PROT_READ);   // pmd_modify() drops the dirty bit
>     mprotect(buf, size, PROT_READ|PROT_WRITE);
>     // ... memory pressure ...
> 
> Reclaim (e.g. under memcg pressure) then finds the lazyfree folio with
> no dirty bit set anywhere and frees it in
> __discard_anon_folio_pmd_locked(), even though the data was rewritten
> after MADV_FREE; subsequent reads fault in fresh zero pages.  NUMA
> hinting alone can trigger the same loss, as do_huge_pmd_numa_page()
> restores the PMD through pmd_modify() as well.
> 
> PMD-mapped file THPs are affected too: mprotect()/NUMA hinting dropping
> the dirty bit means rewritten data is never written back.
> 
> Fix it by keeping _PAGE_DIRTY in the preserved mask, exactly like
> pte_modify() and pud_modify() do.  The existing
> pmd_mksaveddirty()/pmd_clear_saveddirty() pair then performs the
> hardware-dirty <-> saved-dirty transition based on the write bit,
> preserving the shadow-stack encoding rules.
> 
> Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
> Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")

Hm. I don't understand why would this commit explicitly exclude
_PAGE_DIRTY from the mask:

-       val &= _HPAGE_CHG_MASK;
+       val &= (_HPAGE_CHG_MASK & ~_PAGE_DIRTY);

Rick, could you comment? It doesn't look like a typo.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

