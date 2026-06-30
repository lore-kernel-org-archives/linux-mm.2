Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2FAC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8126B010A; Tue, 30 Jun 2026 10:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995616B010C; Tue, 30 Jun 2026 10:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878426B010D; Tue, 30 Jun 2026 10:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6134A6B010A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:58:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA3D68EDE6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:58:47 +0000 (UTC)
X-FDA: 84936885894.01.6760B1A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id B1688A0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:58:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i1vYbsIY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MfBd6CxZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i1vYbsIY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MfBd6CxZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831526;
	b=BX2/+UQP+kIx5Grd2LGMrick3JLzCB9I49BoUPZeCKv8WmRtXiXGakS5ITOjOgoa6ELYKB
	AgZztAHqPYQ8Ikz1jUJQveqYjhCmhMxWE0FqNmN0GPQhHdqdVSOImm2/9fQPtM3Gzd3RLp
	TQJ3O97UR5E4A8XLUx25VcFlljZkqhg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fp1dLT9aMiZvLKrxaip+Sq91NThQkBLHSya57MdqiZ0=;
	b=2ZUFNguzrQXZBzd7zJgRdvSzgx/MHMbx+UVlG42mzzmvlm1dI29S4I0xLDIYcOBX+t5sYA
	1wjeGHLBwKJ88jA/6041z5q7axTjMGE80tVNNRE/rltuLXXZuaUxe7r0C9AYbR4zThAn0c
	xwbn+DegcdGyVb8UydDXSAUF+Brtsgo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i1vYbsIY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MfBd6CxZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i1vYbsIY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MfBd6CxZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 48B8B75DE7;
	Tue, 30 Jun 2026 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782831524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fp1dLT9aMiZvLKrxaip+Sq91NThQkBLHSya57MdqiZ0=;
	b=i1vYbsIYl7TLTaXt3i7RVi+UEP7OqLfLPJ4SmLGlE6UpLVLLcIwfPh4bNaMsVwl54h4AyR
	ta2NHYbLeEgNfWi+HoVNxtnpvbtl4Sr+Ba0JZy4w/8G61xAjQIFAZku66kaRguzDlw8o11
	Ul1e8EM+JGI4aSkeacw8qblnYPgWa8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782831524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fp1dLT9aMiZvLKrxaip+Sq91NThQkBLHSya57MdqiZ0=;
	b=MfBd6CxZdG/kZci2Lo7SLl/9MFFvNSPaqGCze0WwU7PIpbjukyOQVhLelOdImvCIeryCQ0
	6AlOkmF+94KZZuDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782831524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fp1dLT9aMiZvLKrxaip+Sq91NThQkBLHSya57MdqiZ0=;
	b=i1vYbsIYl7TLTaXt3i7RVi+UEP7OqLfLPJ4SmLGlE6UpLVLLcIwfPh4bNaMsVwl54h4AyR
	ta2NHYbLeEgNfWi+HoVNxtnpvbtl4Sr+Ba0JZy4w/8G61xAjQIFAZku66kaRguzDlw8o11
	Ul1e8EM+JGI4aSkeacw8qblnYPgWa8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782831524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fp1dLT9aMiZvLKrxaip+Sq91NThQkBLHSya57MdqiZ0=;
	b=MfBd6CxZdG/kZci2Lo7SLl/9MFFvNSPaqGCze0WwU7PIpbjukyOQVhLelOdImvCIeryCQ0
	6AlOkmF+94KZZuDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E554D779A8;
	Tue, 30 Jun 2026 14:58:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id k/+RNKLZQ2poHgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 14:58:42 +0000
Date: Tue, 30 Jun 2026 15:58:41 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Dave Hansen <dave.hansen@intel.com>, Xiang Mei <xmei5@asu.edu>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, linux-hardening@vger.kernel.org, 
	Uladzislau Rezki <urezki@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, 
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <akPYNv37BCJXUg8-@pedro-suse.lan>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
 <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
 <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B1688A0009
X-Rspam-User: 
X-Stat-Signature: xwfb4ec3anaqyjuybibofkt1mwb75dz6
X-HE-Tag: 1782831525-869141
X-HE-Meta: U2FsdGVkX1+z39pKOUso2mfKdWxFN5HXwrxYqJ7XNAuly0vuLIcMGOQ1DoHUuw7K+Wb86uPuZDlnegxnLb9P+pBE1KnK0fbtp19RmS5/z6f1kInr7EEgKlfRKlfUQTJoOIwz8JLY/P0rtOsctV56ocyCWJyzi1q7a56GltUAgy4BTQ3/qTRwcn6s84FOwVx4Fp9V1lShKjrfQDTx/p5v5aTTAJaiP0H+gk+Q9qp9z1FWMXITGI7w6kedfOWTX7gfm2DPNxIntj+ubYWdJH0LJxUBnIJRZWNHl2Ir3WUZKof9ifYqgiHZGhIXAFxN6jKPkGUjabVrUDGsOASEqrIlws/Ih+OLw3CGGYE+AVNysA6LlyEMjERJv1vvZLeNzVJb/ansWvYk5UelxWiAFvIAZfUg3O/sJvdPEhdy+tjfqAjnuC8mYevEvPm6fwIK5ws3aEmRzqdRtesDDSFjDuaRdK1ZTuzNq1UOLv39k7Btu85X5syThR03dPYAOpAT5/1aEV+GM1xv1opqm28FHko+XTQARLqJWR+dR5TSj4XVSUWORmEO1DNxGlA+hY3nVFBLl1fGwueiR+ZtsNYvxB7NuckJhGf8Gh+jPS+eZpmVpznunWGvsvkTx9qA9gJ9lqnxAecb+iyFDFwTeW8ciLqTmZrS+llI0jzsdAglachPfJoU3lUixh6Sltpizvq5UUSTC1L3TOrJpCYsYP7C+GDU/SBbrZW7fe69hVFjmrnHbonNjYPCpcSq+WXyyV4UPRqsuPhpCtzboWusxm/2oXVMuKAKFbCqa1RWWDzuXW4+e8Q1kj2p8075coE7ofpf8cxRN+8t7IqrqxsRn4WXBoeBR2fNJ7C2O7+VnJUIYpuRF4YuKKjsoWi8GeS6W0zVpp+HGaRZmdwqZ/eymt/fR0k2eb82/uRUUNHpNEe4yGSOO021cNJ69WeN6G+Z/92T7MH8JWkS0mBOXM7I7ZoAixt
 IScF0YnX
 pJtUuTNhGqyWmKZFCysoOhj0LvfCFsnmryaIDhQTW9WunTxIrFequrHDW9mMGH75DMTumcpYtlOcAPl4mKbdQJ3up7or/ZojsteGECWQVu57xjPL06zqPwRd+2/VlWZ+nC43P+u3KVvyV8bfZsSLZ5nXzg2qtcVh77mcukEyPXn6XioryBzakqN+bDc9u29F9sfYnBGgvt1+qy/UyUdd20p2g4kJZmEtO8srChATY1wPfAI+GdnEHKvl9Arxx4Pd0gdMTQb0x10UvTg0MZFx5fXT1AXiAxtt+S8F1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 07:01:48AM -0700, Dave Hansen wrote:
> On 6/29/26 18:22, Xiang Mei wrote:
> >> Please don't even try to send a v3 without addressing this.
> > This is a demo exploiting CVE-2026-31419 with this technique:
> > https://github.com/google/security-research/pull/397
> 
> Thanks for sharing that. That's really good info.
> 
> But what I want to hear a bit more about is why this new guard region is
> a good, generic mitigation. Does it help mitigate a whole class of
> vulnerabilities?

I guess, to add to the questions (to Xiang and/or x86 people):
1) Aren't initiatives like kCFI/CET/shadow stack supposed to mitigate these
issues? Is this mitigation supposed to be applied in spite of these features?
2) Aren't you screwed by the time the attacker gets kernel remote code
execution anyway?

> 
> I think you're making the claim that this ENTER technique takes what
> would normally just be a DoS and makes it fully exploitable. Does this
> happen for a lot of DoS bugs? Or is CVE-2026-31419 very unusual and this
> stack guard gunk won't ever be useful again?

I suspect it's just the typical UAF with a function pointer table, that leads
into remote code execution. I know that for our (SUSE) CVE scoring, we tend
to treat these kinds of UAFs a lot more seriously than others. But I didn't
look closely.

-- 
Pedro

