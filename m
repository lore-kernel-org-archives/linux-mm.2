Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9788AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 22:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2937C6B0088; Fri, 26 Jun 2026 18:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AE36B008A; Fri, 26 Jun 2026 18:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8936B0092; Fri, 26 Jun 2026 18:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D93506B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:55:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 358CFC2C33
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:55:49 +0000 (UTC)
X-FDA: 84923572818.08.4F3F6AC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf28.hostedemail.com (Postfix) with ESMTP id 756D1C0004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:55:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=mE8PYRYM;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782514547;
	b=X6c2cUL71YVttbX5Jv89qw78ozgta89NCzbWDK8+9HDTU91JPxdxXFVKKw2K30E9MLqI7s
	V0TBXqUtEAwFw/3sgOQ+LtO1Lr2j90rtdy19k+lCSu9/psOaE3sFCmBZ5JAv2PMYvnPdzt
	+5+3xeJQbTLbg++cwrLp47nD3TXGK8M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782514547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4MWx4i2lvzH/DEBrra22DMLVY6iLophr31au/eJdxY=;
	b=bc5yDa/0vWtOfD9E6k4rYwIkcSzJeOriwnrvwfZouM3dCz76w6QUtDRP7G1G2fhs0Ap5h5
	IfyUkuywxyWjrizccXnMBYpLzUDLtumflmBLvwRbJCzv1PFXDLiZz2Nd2W17Oi5aadqKwT
	h+kd7+ddlcF+5ixOaEXxkXOK2S5KjXw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=mE8PYRYM;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g4MWx4i2lvzH/DEBrra22DMLVY6iLophr31au/eJdxY=; b=mE8PYRYMCcttqIRT2V8+76Oz6x
	Fkm/q4vBvb+5wwEdCazP0AuXgT4kyQ+ozl1tmbf5OcsxYv0ljFCbXMW1kSp6J6KrFrRKKsLE6s1HI
	PLuiLmY9QY4iEzDbx71sdPacdARFq10pM9bSPM3OQ/nzUCZc7LG91NoFqbMhKv+q2OTS27NFgZ8p9
	mlXt1aJ73U3IFQJGqKDWrz3nANKe0M3wmyAIpjoQLLM/dwr82I/6oaZNUCaQB+mix/6xkHfiIOm+v
	bRDtpkYJA5363pK69F8FopyeVZpgT1JEH3mY/MD35GyPWI0qatZ0QuY8YQ9njJqwIm8+SYsRN/q1J
	d4ThBFCQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wdFSR-000000003km-1Ev2;
	Fri, 26 Jun 2026 18:55:35 -0400
Message-ID: <ec196457675cf2feb65cc729090f958080cca052.camel@surriel.com>
Subject: Re: [PATCH v2 0/3] mm: __access_remote_vm with per-VMA lock
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Andrew
 Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, 	kernel-team@meta.com
Date: Fri, 26 Jun 2026 18:55:35 -0400
In-Reply-To: <05538f68-c3ec-422d-babb-7427068f79f4@kernel.org>
References: <20260625015053.2445008-1-riel@surriel.com>
	 <b0d9ce70-ebb7-4b79-9a35-257b69daff7a@kernel.org>
	 <5a4ff628c1b947f9cd4da53e1e64b3934a1f2d9a.camel@surriel.com>
	 <05538f68-c3ec-422d-babb-7427068f79f4@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 756D1C0004
X-Stat-Signature: w3d6p1giapeqqd3mk97jdywgpyebse33
X-HE-Tag: 1782514547-153543
X-HE-Meta: U2FsdGVkX1+YPligZoqiVIn+XAzF30F1CexyHWslqT+d5h0BlaLdcEgQY4YqpZvQw1nF2CMsUiHBd1YsGOutHudcc1pSD8Aa3CAwfhwiOCWkJIb06Eh262+TYPiTASQIc0DnjVqDqAYso/wgLuD+j9boWe8Rl9G0TqxTmpJ9ODK19rlU82POp26Y/CdSC8ezvTRs2fiHEKSy7cGpvP1mwNBbLaOSGISI9tkH41vSltQLd/c4XZUnE/eBgf2JZVtGUJIUCeAvk1y2+7avq63QWkt73KPkGNmO7gJEcWlcJhs/1Y8omhnW0aVJk3PVjGqjZtb8WA+jUjJ/M1DUciAFBtACeeVM8RM7DmUzOKQDwMvoDlN/bScr2LiYLojKxZMKug92ajSqq4l9mSe4rjYsAql2wlA2dX+u7GcxlIw04e0tqym0FuTaUo1G5sOJfz6Mgx7sERNXWUkzr1dP0D502wx9MO0ssQSUrxIXL6pBGu2K4wXqPS+WFd89gGNspKMEQqVAVUwTk7VMC26X1MLDPLTCndlEUw3VTXeNBc8g7X6wJivsEwkz+6dSqKA8snXRtG22LFAWbQy7GcnaSfdSxAWydGdP2Ss64I3bIlT8fqOocs9j+/7PciTrR6n8KxAfTOzLMZUzmV0kSxryVtYuDnTOW4HrYwxr4fuaxhnDSihidDKXESadllPHhYHrepvWe6B+kg4LNmwSSvQVL6xSozh+ZJe2x+rc1vHOxc43jKXVaFLW7tdnLEzW4eygXL8tjbIAVbXSLg1RdvCRxZjVx8PWopYVJ6/Kzj63j/raudOcbTKpP0tJC08O7BaMd39N9Jt8AdcQwlE4sryNa/YdykeS/KG9Isn1l+g8w3oDA+fXiDtJIYRNLbr/BnafH8N1ofnhcKXcSL6Moa8dOOMDCVpWUprjntUwYQhCL04Zb3hInOdagBe7i4SLWI1kUwf3I9WCyVNFaXCtrKvaEfM
 mcDlyBFu
 6Fq9ucDmzldE1B4YbzGU+745gXp2FJaYR6i4aXbyfc3oEt4DX0dumCFLWARU7uFouJVaEN2i9mcOBIokQyDjouIqsgpsMDd9FWgyEqJbGHU7cMqis2k41VNwUV00c5HAP7tjMhcXYKKitaaAHkAavuhPOMRAOaszKoE4ml/Px4JVkN364UCG3ir1fNoLOthKjU7anZUdhWmECllyhGwWChqeQcTtl7ouLsi8/EAYFpXgIaDpAqJf3rDejvxArKDym0f+UsGQ9RATehybt38HoqRglZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-06-26 at 22:33 +0200, David Hildenbrand (Arm) wrote:
>=20
> We really need someone to look into this with some GUP experience or
> the
> willingness to properly think the GUP lookup+fault path through,
> instead of
> adding some creative workarounds to selective GUP user.
>=20
> I will try to find some time to think it through, but my time would
> be better
> spent guiding someone (and definitely not someones LLM) to understand
>=20
> (1) which interface we could start with (as I said, a GUP interface
> where we
> pass a VMA-lcoked / mm-read-lcoked VMA instead of the MM)

__access_remote_vm seems like a decent place to start,
since that is a pain point for several people, and also
the path into remote get_user_pages with the most callers.

After that there are a few more callers in performance
sensitive paths:
- execve / argv setup -> new mm, no lock contention?
- KVM async pagefault path -> most/all of these to the same VMA?
- make_device_exclusive -> ???
- pin_user_pages_remote -> probably a good target?

>=20
> (2) which faults we could automatically resolve under VMA lock (I
> mentioned
> userfaultfd is tricky but the existing GUP call already doesn't
> trigger uffd)

It looks like for normal pages, any access that
does not require expanding the stack could be
done using just the per-VMA locks.

That might allow us to implement a locking
function for __access_remote_vm() that
takes the appropriate lock for the situation,
and also takes care of the expand_stack()=20
calls, if needed.

We could also take the slow path for an
access that spans multiple VMAs.

Then we could have an inner loop that does
only the page accessing and copying, with
no calls to expand_stack() in the while (len)
loop.

At the end of __access_remote_vm() we can
then unlock according to the way we locked.

Adjusting the locking assertions in __get_user_pages_locked
and untagged_addr_remote to allow the per-VMA lock seem
fairly straightforward.

Passing the starting vma all the way into __get_user_pages
would also allow us to skip looking up the VMA a second
time after the first lookup in __access_remote_vm().

>=20
> (3) whether gup-fast could be reused to some degree, or what it would
> take in
> order to do that.

If an access is entirely inside a single VMA,
it looks like using gup-fast could be possible?

The whole "look up VMA permissions" thing inside
get_user_pages() should not be necessary for callers
like __access_remote_vm() that have already done
that.

That could be a nice speedup for thing like
ptrace, BPF copy_from_user_task, etc

Another question is whether switching right
to gup-fast would be cleaner than trying to
elide the first VMA lookup from __get_user_pages,
but answering that may require looking at some
prototype code and figuring out more of the
details.

Thank you for asking the questions above.
Looking into those made things a little
clearer.

This looks a whole lot more manageable now.

Are there any major things I overlooked?

Are there any pending patches in -mm or
elsewhere that I should pull into my tree
before starting?

--=20
All Rights Reversed.

