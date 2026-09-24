Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42912C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298896B008A; Thu, 24 Sep 2026 13:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FF46B008C; Thu, 24 Sep 2026 13:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185BF6B0092; Thu, 24 Sep 2026 13:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA4546B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:54:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBB49C0465
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:54:51 +0000 (UTC)
X-FDA: 85249406382.06.BA7C1BA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id B9E7740002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:54:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1dabzC96;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5V+Xm0Lm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Zmc8otqh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vaGP2Q23;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790272489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPoUMczHVknhsJ12DVLSqidzCMjk30NE8xDC/mrh66A=;
	b=PEcTC3dPvYp88V4YqekARRiEu16N870Mko5USpPvQvk+eahZ+aSdAjPmBNGT/axyLU7OAx
	ultdzaixxPDHVI/bZS1MtTO2EDafUi0EWHQ0D7RVAyqnXrn0v45v1zVca57SgaEzwQm0xQ
	wrCdsPAhtIARxPipT9mUYSOlkRzHTlg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1dabzC96;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5V+Xm0Lm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Zmc8otqh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vaGP2Q23;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790272489;
	b=wZkjF1iqGVm5tM1ow6tXBuk718xkgvQ+8BA7rNw60wnhZvtEM6N8DoSdvnuZtBZJxyOjbP
	Ut+0lw/SVmW3Suaqcl4c5T28HmHLdrr7g8PM2nYnQEi8TRnSzg8M+7Vexx1EBYEOfWOPQG
	MvxNRNUeLwHvsWbUWDJWwRyRgBCKY3s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C7CA200DD;
	Thu, 24 Sep 2026 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790272484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sPoUMczHVknhsJ12DVLSqidzCMjk30NE8xDC/mrh66A=;
	b=1dabzC96kiSPOb63TTR6AAp1dpdu7gunvuVBRLLT2fpTucld5nJctSSp+DME5uod//vvqJ
	B9pHXrCHS+1/qVpO0YN/QxuLzmVpGp0l7Hzq8kz/XsAk5VnpDi6dauTGMvDeLI9iwiR8Oo
	HfZFxDIBeh6QjfN+3zxY+11lkrFthas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790272484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sPoUMczHVknhsJ12DVLSqidzCMjk30NE8xDC/mrh66A=;
	b=5V+Xm0LmlqvboqghMvAbW68fmUrJPPnoxXkXBT824xC1P1mtYRMYrN6UmTnTf4RTFvw0z1
	P4nriVTBHg+1rwBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790272480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sPoUMczHVknhsJ12DVLSqidzCMjk30NE8xDC/mrh66A=;
	b=Zmc8otqhfK23cSsnuGcgYqZ2cbJGbbvydGGnX4+fHtcLbTP7EoF7vmVFOV7M5GS/kJXnDf
	Fc1incyjRSDfPxQrNa66YDOdPRHfiYvl6UtsZJocmjC+vtsgCvYn/cDjNxs+r9eb4Wpub5
	mmtatN8s2LT5TNdC+4IgMw9ie1ijGVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790272480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sPoUMczHVknhsJ12DVLSqidzCMjk30NE8xDC/mrh66A=;
	b=vaGP2Q23vAtxEh2j4xsiSqIYkKc6px4rHblnOzMDrUNhseJE5faein5S8mcXPQqbdFhLOU
	adfZcT3GgZGeRKCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12C2E13354;
	Thu, 24 Sep 2026 17:54:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5LwkNd5jtWq1YgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 24 Sep 2026 17:54:39 +0000
Date: Thu, 24 Sep 2026 18:54:37 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Toshi Kani <toshi.kani@hpe.com>, linux-mm@kvack.org, 
	regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm: Drop the page allocation from
 pud_free_pmd_page()
Message-ID: <arVjbTpD45MiXM6B@pedro-suse.tail5790ac.ts.net>
References: <20260923223116.20090-1-mikhail.v.gavrilov@gmail.com>
 <arVV9WLXQOwR8Hy8@pedro-suse.tail5790ac.ts.net>
 <d8b502f7-a552-4600-b348-614d1d62afa5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8b502f7-a552-4600-b348-614d1d62afa5@intel.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 5p33jq3ce9q5be7qxze9iup54tjquez9
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9E7740002
X-HE-Tag: 1790272489-60125
X-HE-Meta: U2FsdGVkX18+tRV8jqqonJVaXSBAYV1W3DX1pk+olmMW0TRaMsB857EkXlUZttRpXnwU8XgpS+Edb4UHiITkYg45NlSWIYQMwygmD09od/m+KoO/7ylKdfwBhooawIaqtcx6Wymgugq6I/I8uEs855qdc0eiYwCr+5kltkd4HQftKFxTIzfuYeDvAXB+5QGNZJZBU1TTtXMfKEO2gV9yJLoubW2zT+Vzw4CM0RJo3vEoBFqm+ZPOcseMtOCy+iiIRyLP+gWhQJYV+2VdCGxbV+Ps8ugu9g8WpSPqmHCN0rKeQSMOZsu6SnUfsi0T37X3AAwMT45I0AO2g8bMRJZfVaLwcFd0ldI6q+C0dN/BrLL4g59ROaexFM6dvsqIGDHtUSvOXAAoEWmH6ZfR/QZ4KCtBY5iJcgxPVcz+r76BLs/2k6ULUqmYlDUYj35r69fO2o/iKRMWBeEYnnx+BIGYjXk1PO8XeqZ614b1A10sVWANhk0MSvrICluK4wgq36y8t0RxPGKmAfYb3iZ2ZunEQ2VbjQq/Rf18UegVFD8mqG1RV7na052iRqv3eEDfeXxaC/oGE+y1Q0eX8d3wBtd84q2BASZpz4k4+tQPyczz1lXv8x9iUdKiAcqGpaou9J5MLIuEziePNpRgHgMPrN6O67N0l8lk7cDLiaBzx6gMZ8DgoEBa7uweFTqo+GQ2ISDlVvYf4uoM3tMb69f1nFXUTG+ei4wWPxIY0ujWTZJAEu2PKFi1m576MxSODhe5NeUHtinss+XPpvBrfy3f/NO2UWsTXTnjFio1GB/aRjChZ5/A7gF/1hQGujVKCSZZCLAcX6ygGjIFUhocNQTLwcatqY02lq1/jK4ud2p4OcJ32IJIXG5HfQmBwhuV8NfbyLqa2i/vsPdR+5GV0U0gI08nBQxf2lzMBUXipdCtdhkx912Vb9u++oOPIetBpyayCzW6ykxovUdtvYqj9xurPj8
 FaCVIzB8
 b6DMFDynPQgeg8s1ftwawuiKBGAzvwLkX1BdJJuRa9bIW+Jd1g/ul4vd+vVhbNcp0uOlc4bRqW62F4bV8Xw7yUjr/kFSXLnwyFbkKOidmgMBN/CIuPZWhaR5Ysa3hSci8LJHWippXZRCdI+2WI+E5hAl6WsOX0Mx/WzZW3BhZIpixeBiCHZh7/zthJile6RHrAL8wF53FLxXGK8j7PoAwyp0SMcYMaeZOGgWS4ZpKB/DfDP7t+g43sQcZVN6zNDB5Zuk8vu5PkwZjfW+d1rhqNafzfYZ76LIlFFIzkebBljakgR7jZdeCQPUljE0YUUqAgEaZxAznoRcMGcUE2In9S0ze/Hqk9yQIZLzQGaCW7yVPSanybHyQbjOa8cv8w2BlKYdsC7kpJHJvXiSk7jfBnpPqZYMs//1LmcTD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 10:21:03AM -0700, Dave Hansen wrote:
> OK, I've got a version of Mikhail's fix with a changelog and comments
> I've munged a bit:
> 
> > https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=pmdfree
> 
> Does that look OK to everyone?


LGTM. This is where we find out if we have a solid understanding of x86
paging caching guarantees :)

-- 
Pedro

