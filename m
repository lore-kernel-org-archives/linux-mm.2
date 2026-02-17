Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1CBE9A030
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31D86B0089; Tue, 17 Feb 2026 13:08:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09806B008C; Tue, 17 Feb 2026 13:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08F56B0095; Tue, 17 Feb 2026 13:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF24C6B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:08:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 806E71C163
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:08:11 +0000 (UTC)
X-FDA: 84454732782.27.84FC4F9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 21AC32000F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:08:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YxYtXcYk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pzmoYeS5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YxYtXcYk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pzmoYeS5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771351689; a=rsa-sha256;
	cv=none;
	b=L9441dUgjnpV3wg165eS7m/4ispbf+3hnUNHyD/9nhcZWnzfihPS4RSfuj+BjLwRlPpmJK
	dP0DzfLfr0CaN17OTb9nur64fUzKPC/BF6QTOIbYEk4Luha5/0vzfK1F8992kKibtLvcru
	931i3IByWZEg4ueBNm6KP6q+7nBKiLM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YxYtXcYk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pzmoYeS5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YxYtXcYk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pzmoYeS5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771351689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMRBRqEy5Lt71d0fi6QbtK9GcOPq3qLGoaGEImEdO7Y=;
	b=AyWuDOM3E2AtSBBpNC3Go0DuuNd9plSdNWfjoDQEplG4GkmsH2ipmRAJUxpa0kag4h93bp
	0LamyknLdzIvY2FVtNwpgyfyj0ioK43fg29QRVQipnOwz+3R7MtmCXwHy0H+qonDN7W5du
	5xt5RuGbKLuOaKMMPSj2Emfp81IhNl0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5525B5BCC4;
	Tue, 17 Feb 2026 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771351687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMRBRqEy5Lt71d0fi6QbtK9GcOPq3qLGoaGEImEdO7Y=;
	b=YxYtXcYkJWDtvuaFj0p3ijzqB+XZhjdeAeC4SGGkWhswNKWv028vPwrcGZF623yiHeU9zc
	xLd1PcsxcHSPq9WLB+0pOson3OtIws5TvdrzVAr2zn8gw+IgXzf4Oc3YrQm1B8R7J5Az37
	KX0CRgWQrdWz/prYy9BMY5wD7OgaXkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771351687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMRBRqEy5Lt71d0fi6QbtK9GcOPq3qLGoaGEImEdO7Y=;
	b=pzmoYeS5kJ5i988mFmNJmrBvVx727S9NK/PP1BFDrlkikkYRDKnsobZpv6RuKn12iepnls
	MBKSSLK/uyzqGMAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771351687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMRBRqEy5Lt71d0fi6QbtK9GcOPq3qLGoaGEImEdO7Y=;
	b=YxYtXcYkJWDtvuaFj0p3ijzqB+XZhjdeAeC4SGGkWhswNKWv028vPwrcGZF623yiHeU9zc
	xLd1PcsxcHSPq9WLB+0pOson3OtIws5TvdrzVAr2zn8gw+IgXzf4Oc3YrQm1B8R7J5Az37
	KX0CRgWQrdWz/prYy9BMY5wD7OgaXkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771351687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMRBRqEy5Lt71d0fi6QbtK9GcOPq3qLGoaGEImEdO7Y=;
	b=pzmoYeS5kJ5i988mFmNJmrBvVx727S9NK/PP1BFDrlkikkYRDKnsobZpv6RuKn12iepnls
	MBKSSLK/uyzqGMAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C7B93EA65;
	Tue, 17 Feb 2026 18:08:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EGLpGoaulGlzQwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 17 Feb 2026 18:08:06 +0000
Date: Tue, 17 Feb 2026 18:08:04 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Luke Yang <luyang@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, david@kernel.org, surenb@google.com, 
	jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 21AC32000F
X-Stat-Signature: s3p3hpnrwwytfd6exsb83y4ktsjzto1u
X-HE-Tag: 1771351688-816534
X-HE-Meta: U2FsdGVkX18Zx5ecnPR16I0+kxytFkVhi5QiJxMCdJhLytdSKqCAg2GDRT2sqsTfg0o0H5Aje4jiIztDNoCGUFg9cucClyA0uIYsuQMRyYF55Zvx6GTl5iVQqMbow1TM499cnEzNNewXKJKkLZBHv7e0+KKCXLAJX2oSExNUMYU/zJtZ+OS5bxbUA7o5K2Pa6rXnRBbuiSlPYTsPHIpXJrdJNKPgpt858kecVK1rCVy+fjsJ0Ys5StlMBg1ysJs4LCwE/PdTyudsqRy0NY5vvsJn8Oc8GVbGkdM/ZgC+xOJLfBexfJic5IXh92usu89FsvcX0LhbZbKVoDlTqrVELweEfFad0xQHwnc/2Z237a5nxtLEPCtVMRoZCgHiMnK23ZIha6yjzTEg+XZxe4cgIeueVMbgKgNukq9ZrqDBaWfXTpUMJfEYi2KBopA9ip0F1Pkll+dGEKyVXYi4y40aYJOjHqrTBwARL4nzQalipq+ixV6ZoWkPS5fLKEq9U11iCO9jzbH15Updvdn1TWPmNgwnPNk4kMnQg33XPtmIkywV7fSW8+27loqtJMlcNz1clnFfmQrUi8uLwsx13/FP+Z3Ou0q7PDjlstttBxP4CSKiLyU9fD2tgO2pdF0O8sEZJWtY8VFMIdpGq0muL32Hc8sHhwl7JyirMHzdNxRMCdOymUOub73tU45R4S8ycIK1v6/pMA8eyVHwMlcha5vlRkn+Vf4NldISvg4aEC6Ao9Z9FSzWuTeCkCiUs+4w99znVfGecrqD7Ca5Ul+tRLyXv0beCUqow4b78YvK1stTKsvZlZdmE8wlT3X3HSAiPHiOgUNlcGZwxukTPm+iUx7LTxe7pC3KfA8hy3uwY23OVNvJOjrg8DMqSIDOOKzckG+RdG9iCWQgMGFRZC569gS9p44nFEawELRaBFW+dFtiB75H9h8zkzlGN7jzOMJaMF/kFY/7E6dANtoISQCF6tc
 BPytQJVH
 3y/1O7yzn0IUrV1ev2tEKkbYnvKE0BeqFTtTzqn5WPWA3N8XuFdKxYOu1U/+g++mqgpSPFq88NpPPxFjyCGhH7XZg9AySTxCPLMZvfpLGdYn74m1ogoBU9fZnF4VAQwC607qZeCFku4YnpoOsi/SGkFA3Y1thSRQ5bseAyCwKL3VlOClRCoyrccYa+tiR+em+/dXClRNZtZBoykWn758SvKcKbiuRdEMnpHX38Wuwjr3ztJgYCK7SrJpmpFtC7OqeWdk/VfEgNp2Jf7zbNtKVFWH/+vupmp/9y5/IjIaT6Cm05GecUwAN4/PWZ6pyyHk2+z16ydiC873bPNzOLWls8ZSeKkUhE4+5g90NoBOc+i//bibqkX7/yI7hyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:43:38PM -0500, Luke Yang wrote:
> On Mon, Feb 16, 2026 at 03:42:08PM +0530, Dev Jain wrote:
> > 
> > On 13/02/26 10:56 pm, David Hildenbrand (Arm) wrote:
> > > On 2/13/26 18:16, Suren Baghdasaryan wrote:
> > >> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
> > >>>
> > >>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
> > >>>>
> > >>>> Hi!
> > >>>>
> > >>>>
> > >>>> Micro-benchmark results are nice. But what is the real word impact?
> > >>>> IOW, why
> > >>>> should we care?
> > >>>
> > >>> Well, mprotect is widely used in thread spawning, code JITting,
> > >>> and even process startup. And we don't want to pay for a feature we can't
> > >>> even use (on x86).
> > >>
> > >> I agree. When I straced Android's zygote a while ago, mprotect() came
> > >> up #30 in the list of most frequently used syscalls and one of the
> > >> most used mm-related syscalls due to its use during process creation.
> > >> However, I don't know how often it's used on VMAs of size >=400KiB.
> > >
> > > See my point? :) If this is apparently so widespread then finding a real
> > > reproducer is likely not a problem. Otherwise it's just speculation.
> > >
> > > It would also be interesting to know whether the reproducer ran with any
> > > sort of mTHP enabled or not. 
> > 
> > Yes. Luke, can you experiment with the following microbenchmark:
> > 
> > https://pastebin.com/3hNtYirT
> > 
> > and see if there is an optimization for pte-mapped 2M folios, before and
> > after the commit?
> > 
> > (set transparent_hugepages/enabled=always, hugepages-2048Kb/enabled=always)
> 

Since you're testing stuff, could you please test the changes in:
https://github.com/heatd/linux/tree/mprotect-opt ?

Not posting them yet since merge window, etc. Plus I think there's some
further optimization work we can pull off.

With the benchmark in https://gist.github.com/heatd/25eb2edb601719d22bfb514bcf06a132
(compiled with g++ -O2 file.cpp -lbenchmark, needs google/benchmark) I've measured
about an 18% speedup between original vs with patches.

-- 
Pedro

