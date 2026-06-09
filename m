Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4ADCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 21:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8C586B00DD; Tue,  9 Jun 2026 17:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D406B00DE; Tue,  9 Jun 2026 17:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C446B00DF; Tue,  9 Jun 2026 17:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4396B00DD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:12:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B79514073B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:12:40 +0000 (UTC)
X-FDA: 84861623280.28.F528E53
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id E76B31C0012
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:12:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uBE4ogiS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmTSAtbU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uBE4ogiS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmTSAtbU;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781039558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnlPumnoP1QUrRfMOMDX/uOPlORxRhIf1SgZh5OHpg8=;
	b=ZRTaAoRbpJkACRCCa4IvJDllnNtIieA1/r1yqIU+pJveDNOoO189sgddn4zS3oU9ItS+M0
	IEw/NJbMw+FRCm90PFikg5ATbc7BhjvuVompCSSKVqAZg6wRkRdoUOS9pSKTxdydrhxI3S
	IFaqJLkoVmMf+ce04dLpuv/SG9lScxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781039558;
	b=A3EFTcndh+YLkfmU/+gWYr17gyd8A7vFLYnsDUx+kVJU/iwAj+Yn8E/EgFu55e/Q7jEX5R
	uF47IQnJm0v42A8u5KMNu+Hi94A0zVEfp6DI+PlgkhW2Wim5Dk2oDU+ZAUfjc5NFCjkrOk
	VRfeEVHf6IPDMyjOLXqX8fIt2YfXpmk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uBE4ogiS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmTSAtbU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uBE4ogiS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmTSAtbU;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E6946AC18;
	Tue,  9 Jun 2026 21:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781039556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FnlPumnoP1QUrRfMOMDX/uOPlORxRhIf1SgZh5OHpg8=;
	b=uBE4ogiSo6YE0QfRRL8um+PL/x62b3GSQrz/YeaqqV3QuXgw9zhlycGbetDodUe1HKhJPS
	VHigpgrTuqSLgOSw7bPC1M21SFQNdqObOvQsFKc0PXerveiwPbK1HParc2WFW1qTZ4HeoV
	lskFl8WV3WIyWOOSqxzbvuuS1DAjrxQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781039556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FnlPumnoP1QUrRfMOMDX/uOPlORxRhIf1SgZh5OHpg8=;
	b=zmTSAtbUzRhxaUBZ/Ax2qkGNeJtY3RVllL3tAEjcYcqwDz/+/tBJimg+jzp0lb0zUeg6Xo
	nt1ve/6yjNFqecCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781039556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FnlPumnoP1QUrRfMOMDX/uOPlORxRhIf1SgZh5OHpg8=;
	b=uBE4ogiSo6YE0QfRRL8um+PL/x62b3GSQrz/YeaqqV3QuXgw9zhlycGbetDodUe1HKhJPS
	VHigpgrTuqSLgOSw7bPC1M21SFQNdqObOvQsFKc0PXerveiwPbK1HParc2WFW1qTZ4HeoV
	lskFl8WV3WIyWOOSqxzbvuuS1DAjrxQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781039556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FnlPumnoP1QUrRfMOMDX/uOPlORxRhIf1SgZh5OHpg8=;
	b=zmTSAtbUzRhxaUBZ/Ax2qkGNeJtY3RVllL3tAEjcYcqwDz/+/tBJimg+jzp0lb0zUeg6Xo
	nt1ve/6yjNFqecCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28EDA779A7;
	Tue,  9 Jun 2026 21:12:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dHWeBsOBKGrlWAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 09 Jun 2026 21:12:35 +0000
Date: Tue, 9 Jun 2026 22:12:33 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chengfeng Lin <chengfenglin@stu.xmu.edu.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [RFC] mm/mincore: present-PTE scan cost after pte_batch_hint()
 batching
Message-ID: <aih_dIMqIeKzvFh2@pedro-suse.lan>
References: <5fb8bead.17483.19eab4626f5.Coremail.chengfenglin@stu.xmu.edu.cn>
 <74cdec57-67aa-4ae3-a416-e39846049ab1@kernel.org>
 <2780f0f6.176fd.19eacba49bb.Coremail.chengfenglin@stu.xmu.edu.cn>
 <106e71e4-975c-4337-aaff-a00628827477@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <106e71e4-975c-4337-aaff-a00628827477@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E76B31C0012
X-Stat-Signature: dtqstwtnpb67nyxmzargqfc4q9puugxb
X-HE-Tag: 1781039557-244736
X-HE-Meta: U2FsdGVkX1/V8412G7KVSH8j+LfOzGssL4wtIIuy4OOMte7XGpc0w7jJ/ipqIHzke82B5cWuiheihi5b0Zfqaxh8G4F9uS4Dz+ET/DGOFgkWGh5sPWo0Xu3sZPEQRpelv0AliWzsWCwI1zfgcyl5d6J1BJwqURenhl/t8HwZy+HIEIc4Yc8q0R+G5Zy4YhhIFIMiB0zrYJX+TllGIheumHWFW0kCHrZwYPRkfon1EMKDLpioG+VmYNliG4n2c/nDtlPNkwleK6nk5nYvHq4f+PLseCze3ND0nZhd6LrcgCcf/MJX8HqibUjBEzWS29pBLUomHkTUE/Scfhz9CkkHSo4o/U16b+rejCfR+TFcCrr01iFOSsv360GQn/tLO/fIw0Yv02mT0A7i1pVUrcZicBuuakFCMkqBfeVHWd6ZwchG8E9kfBwuwMuqgGMsIllmYcxwECbiVZkWtLphzivCg131D92OdhG0cmmP1+31S0h28CdqY/v7LaaVUFEeZP5r0t6uPc6CSy0npyvYBy+b20YMLgpeohSSuTL8ERAfXtH6ij2FkIdtLximYgqVIUpjLakshW1BUmJqOXcD5FdOIduCHWd0d+7oWK67v6qjRlGyii2mRjEBlnkx40YnMstARLhlm7Wj7yNPwT98f0dI/AvJEZFBs59f/yfmzTi/teMQzkds4P11F/UMFbf/J8oTNDvh6quUCF8wIYxmVTawjO6vKlmeEYdxHXtA/LIECrtfAbsocPwbF29ErAQHrRYKAJZtY7oziCB4+qkCY5Ij2jmfp58h3gV9eIgrEM547TfCGI1me1s76XOFb9FGpKrWnrHOIujmKfNihtnpMZBj+Rgg7W6k2W/Q0431/sRUvjbuwYTfa6zqm4VO5ewLLeg0vAOCVcA/xnyjtj/AxpC9msMvdT+hKv7tH7V+RiMou2oizSg+OO6qoAk15yPhGEsLDuA8lt2mycsaNukeBop
 O1OfIy2c
 kFwOTdzUQVpFc7R/EIB/JPmvGSCmV/acsDBTudraLxqWckoXT9wiCetSIwl5vzFP5G8PE74G927/y2Toa+3WqMrsAqpSRZzU+rYxlqZ1GzisEUSKnCVEd2sfrvFvQKqRJ/Yqsxp4laRZ+FTyC/nuS7yBBLJRGVw4LWbdR968VcwML2jQ/Qd3r05cZwRktGZ87VYTIbg158LzrLZtLyK/TQePpX6rjMOuxJzzjCcbRdTL6QJfelVdA7Fl1XcKb1087GriwCKkZMOQvAIZXCD0lxsBiqZCcUUW9OBu8yAJY6lMe6OVtxcqxraY/gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 04:27:50PM +0200, David Hildenbrand (Arm) wrote:
> On 6/9/26 16:12, Chengfeng Lin wrote:
> > Hi David,
> 
> Hi,
> 
> > Thanks, and sorry for the confusing wording.  The plain statement is: I
> > observed a performance difference in a narrow x86/QEMU synthetic mincore()
> > case, and after your comment I checked whether this is really a codegen issue.
> > 
> > The wording in my first mail was too abstract.  What I was trying to say is
> > only that the benchmark focuses on one specific case:
> > 
> >   private anonymous memory
> >   MADV_NOHUGEPAGE
> >   faulted/resident base pages
> >   repeated mincore() over the range
> > 
> > so the measured path should mostly be the present-PTE scan in
> > mincore_pte_range().  I agree that the 8/16 CPU rows are not very useful for
> > this path; please treat them as extra context only.  The useful data is the
> > single-threaded / low-CPU v6.15 -> v6.16 A/B and the patched variants.
> > 
> > The compiler used for the lab kernels was:
> > 
> >   gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
> 
> Okay, GCC 13 was released 3 years ago.
> 
> >   GNU ld (GNU Binutils for Ubuntu) 2.42
> > 
> > Your point about x86 pte_batch_hint() is exactly the right thing to check.
> > Since pte_batch_hint() returns 1 on x86, I agree that the expectation would be
> > for the compiler to optimize the batching logic back down to something very
> > close to the old base-page path.
> > 
> > I checked the generated mincore_pte_range() code with the same GCC/config setup.
> > The function sizes from nm are:
> > 
> >   v6.15 original:              0x1fb
> >   v6.16 original:              0x245
> >   v6.16 batch<=1 fastpath:     0x1ec
> >   v6.16 with batching removed: 0x1ec
> > 
> > So, with GCC 13.3, the v6.16 original build does not look optimized back to the
> > old x86 base-page shape.  The v6.16 batch<=1 fastpath and the v6.16 nobatch
> > variant produce the same mincore_pte_range() objdump output in my build.
> > 
> > I also checked Clang 18.1.3 as a cross-check.  With Clang, v6.15 original,
> > v6.16 original, v6.16 batch<=1 fastpath and v6.16 nobatch all produce the same
> > mincore_pte_range() size, 0x1f9, and the objdump output is byte-identical.
> > 
> > So your expectation does hold with Clang, but not with the GCC 13.3 build I used
> > for the original lab runs.  This does not prove a compiler bug, and it means my
> > original report should be narrowed: it is not a generic x86 mincore()
> > regression claim.  In this check, GCC 13.3 generates a different
> > mincore_pte_range() shape for v6.16 original, while Clang 18.1.3 generates
> > byte-identical output for all checked variants.  The timing signal I reported
> > came from the GCC-built QEMU lab kernels.
> 
> It's probably a good idea to
> 
> 1) Try with newer GCC
> 
> 2) Take a look at the actual difference in the generated code
> 
> Is it some inlining decisions? E.g., if the function is larger, other code is
> likely to get inlined?
> 
> The function is not particularly large, so it's a bit unexpected.
> 

FWIW, I don't see anything costly in the linked commit. The compiler /should/
be able to inline and constant fold everything (for near byte-identical output).
Though I vaguely recall that GCC uses pseudo-metrics (probably not LOC?) when
figuring out what to inline, not necessarily something that maps to machine
instructions directly.

So I am curious as to whether this is a compiler issue as well. Or if this
particular build just happens to hit the issue due to some random limit.

This could be worth a test, however:

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..0e0ac7138d8c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -373,7 +373,7 @@ static inline void lazy_mmu_mode_resume(void) {}
  *
  * May be overridden by the architecture, else pte_batch_hint is always 1.
  */
-static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
+static __always_inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
 {
        return 1;
 }


-- 
Pedro

