Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8FFACCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80BD6B009B; Thu, 15 Oct 2026 18:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A328A6B009D; Thu, 15 Oct 2026 18:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FE86B009E; Thu, 15 Oct 2026 18:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 679FE6B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:12:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1EEA1201B9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:12:09 +0000 (UTC)
X-FDA: 85326259578.02.34B3CE7
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9EA93180004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:12:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=DE1WeW4c;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792102328;
	b=pgpkU3k70+ipWwLHK8ik+/JiVcu6bj9bKQw3/dA3O+EGoQFy2Bbt2JI6gJTgIPBDwACtyK
	Z10G7D2tzFFwNONcTjUK/EYbiz0tB1BbMJK+6wBikA/LgNaGIh6DfWCW9DQYv7O1X8aeew
	j7ryAXrAmfV1HBWWPx50qeJanP9V9b0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=DE1WeW4c;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792102328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpxWfmVKtXS1BlKwnI0WNl/SWpgwJ6zFtQ3+EFhe0K8=;
	b=jJ+t/2l9Ksy5G0MF9koL0VlPiXYtsdbkQHY2bRJtmzTKETSOlQhxmSW7eyzQ1yFXmLi3nT
	necGBK15wjF76ZD5kKZGRXaUINckh/9YFZKxy3jgIcuiBMjsPIj8CrY0Ldvb8CzSGIBKH9
	RTp0jzToiMu+Gke6Hv2GYT3JhZXeG8I=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1A6D540E0496;
	Thu, 15 Oct 2026 22:12:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id WZRZIFICunmD; Thu, 15 Oct 2026 22:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792102321; bh=Q4zdkBmCJkwaNcqIWMyNxUTg7txukjH0ImGpHvk01HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DE1WeW4c21ddS0G2EJm9nTmj+Ap1mfPM3cNEpil3tS7BjwoK3de0oLFrOBnE5s4Xe
	 otDlPSe4Qp7EKf3+uATAmamRUnw/aVRLh4VUcr3zRng46zwX5jRag0CaM2O9PFRrrd
	 2ffc25i9ikziYt8v1yraB5kAeZtDb4TFRadTyh/Cs+shDhFyCQs5rU4ICVKhGA3y98
	 ftetSmicF/70TGyLuRM5wEe9UMXCnBWBQfqjvZNWBn99flmKLB1NOuROSaZwU3j6ap
	 XUG18THI9XL5SpuulnsZqYHG2aB1lw0qG6/h6jjxMoOT1epD7YRLvB8CBX2jnKlW5w
	 sfjmUKt2phPVMRdDsCi24vH6JrHNnodZ0BxMXZf2krwK60vogdEGIgIyN7b9GC+fbe
	 aSWrPzYskFDbE5YqooVwMgZmqc9iYU/x7mbtxhPXUOiCyuc5FRAh2Ce+VS5SJhyHjl
	 7Jel/N7EL+ECp1bFwxmod+agJ7D5N1rhA4BVEk46wKqq61e7cH1RmYujXFJ7YmoKNc
	 xywkY5uCT0ByT/xkXgrC7Oca2OnOjs8lNZdsUkpdUQi5DU7CKlGpTm7/U3M96gBF4D
	 JQQHYsNIhOSwhZAWOMmTaof5kkRiAzo76KstNij1P2PdY+kVRmPcGVcbl9OcXicM3Q
	 SbKrT+MG6sCieCZPLrbFTc8k=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 29F3940E02B3;
	Thu, 15 Oct 2026 22:11:44 +0000 (UTC)
Date: Thu, 15 Oct 2026 15:11:41 -0700
From: Borislav Petkov <bp@alien8.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: David Laight <david.laight.linux@gmail.com>,
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>,
	Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261015221141.GAatFPnVQafErlDX8v@fat_crate.local>
References: <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
 <20261014235356.GBatAWFNsWaIA2HQ4M@fat_crate.local>
 <atCYcsfB4s5Anf1m@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atCYcsfB4s5Anf1m@pcnci.linuxbox.cz>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9EA93180004
X-Rspam-User: 
X-Stat-Signature: yys4654sy5j79b9ssrxtpqkto3uz5dg5
X-HE-Tag: 1792102327-243662
X-HE-Meta: U2FsdGVkX1+ZAlScPzxX0xqAQiNSiq5IdhLsI3C1YSHwL88mc+oLzmiMHrYQtkS3s4kRQko/vKQrGoj+c60e9KBCuCBCmV0FuwkxQ/rfn7exm4XDsps+vZOzo+iGVCXq6GPm9O/yalNJEzHBzMDfQDqeFCTqKSARfbRpTnf5S4S0+g8w7dLDbFOQec+9HtRd6kw90T3i22b/UM9CA5+/WxhrhKvK1rz0WBoUjDmsOn9K7A3LxvRNDUhJtLgWqnLVTuybV/Jfqlqo4r697zpd4UpKU2vjASteZUVBv9+bzhmVs5fyVebBEi9ZfEdM8zsCryS79EgeapA1RDSLTQ+NbNg1bM5qkir0PEIBpePvAaOTPS86k5vyZ8FukhNkDRYXmIgvDsX9jnv9clhYIe3ow0q76pLF4IK4qFMuszl8vdGzCOPUM/rLqxFZ7cVwLGASUnT6+uJi/CZrbCDsAHFWv979+BFw/viiP56UAN38w0ZAv2KBj91qpbtJYtdAl2TiqKU7SGp+9zK+G28Liv7thzFAHbELnl/LDzhqP+2reRCP4QzNCxjCyhEEx0KvICUb0Sfc60TBFpFVmblgiBlOvx6FVGcaxsEVzHxDqI2hX5HJkHzxKWYXXZjHXVucFWIRzYMFltth8i0LKUq/CJrWXqZVq4dpo/1Hh0PhjlOtvVqnFty+3zKnt6lonl74vS/G0B7sklzWCxCfq99yRHiuW1wz2UBzZaiB8oSUQkk64DccRqYFP+ERCEG/aOFK6O61g6y4EUNIc+nf1dH0Apcg6kjec+iprH8rr9Qg4o2WN0IkwoXdf8VRUjLMwHDF4N113KfvJvVU+dX+DIJaknx8XpAHh3a2QjKY6u4aZXbZlfNRV4vZpIbkvDKLP1mkDOan8LI5i/ttVTsyrUx5t+9IF12IloPcMkQ5Wh/EVhrBU26hXBxHfuxEyFI8rep/tSuDyD7248hi0aA7LucXguW
 XpSNgxB1
 qw/Dzb8ilP0gpwDcmex5EvrlC3GwTPLdzPNZBp9yghsjhtHd2JWTJjT08KUEL2QO6I/QILc2KvQAAzi12MOlH/yo58Ty9DyiJwQ+KJVTWk9nJGrnikxO/5jqH+DZVDCmMz3HYMFBgWUjF0S4aUBB0YX9tT3Mx1neiVu6qqHh2+f4cQn5V8sdgvNyudytOwHJFeYuznUSMbFe1OtaiqgWgKDl6FhpLrf8CBnwOznly9xtPh8gtbymCtLRbLDEla70UELaHlRKeI+vzfI/xKn6ZGofy6rCjoc0YPsC5nYH3UMrxQgKyKK+++mKo8b99LnqSwobcbZtfJIwPkEzqc1lW8xOzpNl60Hvqfx1PrPmKD+bdfRacBdzQqfdtBJ/yQfp7425RkRqHKbEK2Emx0YPTOJ/RiskIKXn0fVmzyDJqV7mQlNMxzugXpJSLmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 11:10:24AM +0200, Nikola Ciprich wrote:
> I don=E2=80=99t have the vmcore for 20261008-lbxv1f (that box got fence=
d), but I have
> a full vmcore for 20260930-flev1c, which is the same bug: same crash in=
 the
> dcache hash walk, and the same bad value =E2=80=94 flev1c has 0x0ffffff=
f0c930020
> (top byte sheared),

Bah, I'm looking at the dmesg from that one:

[378185.135721] Oops: general protection fault, probably for non-canonica=
l address 0xfffffff0c930038: 0000 [#1] SMP NOPTI

and that says non-canonical but I cannot see that there are 7 leading f-s=
, not
8. :)

The register dump shows it better:

[378185.223709] RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 00000000=
0000000b
		     ^

...

> So on flev1c it looks less like =E2=80=9Ca dentry pointer went funky=E2=
=80=9D and more like
> =E2=80=9Csome other structure=E2=80=99s content got written into dcache=
 (and other) frames,
> one copy landing in a hash bucket.=E2=80=9D Does that header signature
> (0x00ff00ff00100010 / 0xbdcc802700060042) ring a bell for any structure=
?

No idea. It looks like some weird corruption happened somewhere and then =
that
propagated into the hash list... but what do I know.

> Happy to run anything else against this vmcore =E2=80=94 struct page du=
mps for the
> affected frames, the full record contents, the physical-search hit list=
, etc.

What you can do is, have AI go over all crash dumps you have and ask it t=
o
scour and find patterns in the dumps and perhaps give you theories how th=
at
corruption might've happen. And compare the dumps and see if there are co=
mmon
patterns...

From all the gibberish it would spit, sometimes there are interesting hin=
ts
there to chase forward.

Other than that, this looks really weird.

And I don't see any MCEs getting logged..., or? Anything related to hw er=
rors?


The 20261009-lbxv1g one looks even weirder:

[  938.693886] BUG: unable to handle page fault for address: 00068fff008b=
0058

Some funky pattern got eaten...

The top nybble zeroed is also present in the 20260905-adav2i case.

Strange...

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

