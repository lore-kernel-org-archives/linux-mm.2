Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A638CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 10:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC0CB8E001F; Fri, 10 Oct 2025 06:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D981C8E0018; Fri, 10 Oct 2025 06:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADFC8E001F; Fri, 10 Oct 2025 06:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3EB08E0018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:10:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EECC119227
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:10:53 +0000 (UTC)
X-FDA: 83981785986.24.E1F313B
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E019180010
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:10:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y /gMdJQ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=sXhKftPZ;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760091051; a=rsa-sha256;
	cv=none;
	b=pZ1nXQ5jBP2douP4eXJsxIftVDG5r1pOhRJV6D0kR/hTh09E7Vf3FJFe5Z3qsayCdANYcl
	nYZCYutfYulQlR2EBYAW+rfgdkdeAqG3LH6XNO+YKcSL57BDy97mkmP8kbkmyDvY11zGEV
	bFewQ6l8OalsCmMoi5AZ2N4uzGDq1MU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y /gMdJQ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=sXhKftPZ;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760091051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfIFhXkqL2PFnCgdILYUcOyv0W/EfJPQuh46n0RKDcg=;
	b=NiAzC5x2W3uDzij5aggBlScwrO+ib9NryJDNbDyUNQOaA37Hu79A4KOICT0TFeyuZrRyqk
	rYk6ycVNfpjM7hWNhEuRk2BhnOcTmU4y5fCa//zCV481ExTjiFoxHRjsOQFCp18QITNdZw
	pUMFN/M6KNkuxWJ2XZU3nHzkDKxqnOE=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 072E77A0030;
	Fri, 10 Oct 2025 06:10:50 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Fri, 10 Oct 2025 06:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1760091049; x=
	1760177449; bh=XfIFhXkqL2PFnCgdILYUcOyv0W/EfJPQuh46n0RKDcg=; b=Y
	/gMdJQ7dmpRjmxhGyjGVTvs+cMiTiVrBW3nVQ9p1Y2S++vPFL8oFpl51HWPnMZRN
	jHc2hKABIujbKs5Equp0lGTYxsgKJ+3rNUCK4V49nEpNWRfQOaWjZlUTBFKRoyLc
	xYTpc6uT/+/1yUk2K5biHstrf+zOYicuvAq251pcn1g8WtGjsjMmH4GZKZpB0AvI
	tzYm9EJjO95PehQ9tLmRGqmeP2g7PdhXNV6OrTDSjwZOPvpbdZVAsKXX7rAkgJop
	vA8dPytPMXZA1RUtuWgbVjOLFeiKvXXwirMUS0CW/mdLRLkrXuPQILPkWl5UfdZc
	lwnS26/V+3zbwwQKXmx/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760091049; x=1760177449; bh=XfIFhXkqL2PFnCgdILYUcOyv0W/EfJPQuh4
	6n0RKDcg=; b=sXhKftPZZQZuAqpgzn7uqlV9dsaBAyflc0xFVZwUDMUN3KP1KDE
	pcLP8r05ZPWL6q9JoEw/I4ZG2sQzzMtyrVtG80NceRqYVZDoiBg6oOoeEBaTUKgT
	crJnLSZThPN+LI7l5YgUnyvqwvcYFStAqvt98Q1Jge4iU7c+AGPsL3a7L4dbqgk6
	Jtj8OYbALjj07qzIWK2ZQz41LtikEEBz98hSRQryQQ6hbLlWz/s4c/wz6e/Spil6
	xL46C6zF4BfAXKBEpBBm0Ww1QhzbdJaWs0XGZJv0gPWPvb9br8D4nvUezP3eRRt4
	ofZom/XoszK9wtWhnfOHJFUjp8gnj3QPm6g==
X-ME-Sender: <xms:qdvoaLTA0DmiR3A3Jimuzh4CNm1ic2qaQP6iJQL25his8fzI1Agnng>
    <xme:qdvoaP3FaBkHrNo4e_y5HdYfbmBKBH99pcwA0vPGN9nmSPP293zgLOTxpSKfE88rz
    VJx-OQkwsYhHZiYcwLfWUyT33MBnPLYYp_eKce4zJx0lFDc8O6RBic>
X-ME-Received: <xmr:qdvoaLdy1zoJHdAIGUOBYLCDmzZVNPeeiFiEzl2fr5CrGBKeb1sSHkNYcVLIdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddutdekjeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhorhhvrghlughssehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgr
    uggvrggurdhorhhgpdhrtghpthhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:qdvoaHO5gur1DQ1oEMhP4W-DDHCjRSZEF0BneZVG0LWmjdiOg1u75g>
    <xmx:qdvoaPWwCpB4MOxR9IlBV3-7164wSNVyyjNrQ-mTkM7QXyQNhc-Nqw>
    <xmx:qdvoaPyG10ko6xwXsU6aZtRSlHpwkA0Dj3hjZyoCXerPdpDx9luIaQ>
    <xmx:qdvoaG-j1ZUNz8qfhIA0LAVA1xy5okBB7R6Z22jOcWIEcn27Y23Vhg>
    <xmx:qdvoaP2TgJhEvd9Z6dnWteQPHeb02xh6RqJCVwIcmM8eDZyxlparZvbP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Oct 2025 06:10:48 -0400 (EDT)
Date: Fri, 10 Oct 2025 11:10:46 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Optimizing small reads
Message-ID: <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
References: <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
 <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
 <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
 <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E019180010
X-Stat-Signature: 4cgkf6djdis9wrz3cjick6p173wg4uqy
X-HE-Tag: 1760091050-806468
X-HE-Meta: U2FsdGVkX18NyCPu5bqicgKNA1vhuptOm9qo5Gm24MT+N10FCNjWfM9NFl3vZNTVfeAixtKVFXNn0AQtgP0botBRCy9r8FprrRleEg9wmHm9okE8dfzx4TymgaWrNhqDgXcwN2gdTYGlI8JPB8j2+AaLKtSyO5JSTGCyvOUL6I0Zy8AKtDptdPjiy5z7L3+T5QktfMCFRFS2f5F887XuqAWH0b1iFuoiq0N2/zc62zfC3Kj3cnTP0tXdYUPF5CCStbeR3prD05ue18/rJAmWUu6+rniWr/kiztCzoRRJFfvtfKkCjtnMrk8U/YRlCx5MwY2OATV0qlkENQ/jjb98Se8MEj6dszwmrhfewvmMmOolx+WHz+0X05MkCKIcPIcU3OHEMLDfbWGiaxCGU8vfwbo9x+TLGjv3uU81DGYqV5PHJpJ/ymjuX9WTjlBmEoK73tXkzv4vXaFbgOUajTySZmxvy0iobl0dX3yX/0SZ2gca485h4/ByPSmjmB2kLVVh9FQVbSygn9mIzEq8GIIpbgvFiwd0ebf9oMqGLoPbYNZSxu+DEXGqjKYzaf2DLhMHwLO7li505VQKu8niX6qmgh9RWBSAoSNWBqoEW/+CL3HbKDGus9Hd2rkYQStMI2Hqs94G4rbnmrI8EDfS7v1q7Wopt9SjYQAxU2qw3xL58ck9II9pdBTt1YZL4m0A9Txe021d9vtyaY6CSeFH9STlqDGGBBcP18HdH1byJVX4PAKImF9h/H7upSU0sGpTX33bkhi+r6iMsLdE4G2cLLkUy4Rb1puDHIukT4l204PgDLE0qm50r7tUpyvBkq4DTea4ChcdEtPt/kYyAyZhjNktTh60tfV2e4HWKoJWsni/Zy6XUznyU+ngbQE9RcRuwNoGn4x42tRIRWvMu83fxaTfXF3U2SC2btO/0MO2YP8rHD0J808Ot2/TKqyc7kZdxtQ1iKsrS9i0L+KXp2IW7t8
 BwmzThsW
 Q1ckbTqcqBStm/HFW5ezz4/2xc/cGgRhOLtTe29Erh8/modXLOV/8W9Fihf91lgpqMUQuhLeig0zKf67S0i1pFv/6HDPSC8cbD0UebrJw0eo6gzNkLDQPp8iHsEtcMfiJn5RG20AGf5f0uHH8UfL0QWBzCQTm1HBtNRPwqDVkbb2pEGn7iDzxNV4XX3yPs1oUFKtDs/4+EabbR93+QRA8HyPTNzlFLVeEOaO/Ysccyypu0LsAOOrCyag30tHioEldB2PZpzXFaplZiIT+xBHAXgZ2UkOyIRufzrjZto+Z+V0GN6JPadhA6+nav7mOlYhFRv4cmmizp/3c1oAxbKTnKc7LLtTMG7W1X1d5Bmc/a2ySB8V8qgZs5hdoHxOD/RBdYX3mXvWF49p9bsCDEETIQmqumw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 10:29:12AM -0700, Linus Torvalds wrote:
> On Thu, 9 Oct 2025 at 09:22, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > Objtool is not happy about calling random stuff within UACCESS. I
> > ignored it for now.
> 
> Yeah, that needs to be done inside the other stuff - including, very
> much, the folio lookup.
> 
> > I am not sure if I use user_access_begin()/_end() correctly. Let me know
> > if I misunderstood or misimplemented your idea.
> 
> Close. Except I'd have gotten rid of the iov stuff by making the inner
> helper just get a 'void __user *' pointer and a length, and then
> updating the iov state outside that helper.
> 
> > This patch brings 4k reads from 512k files to ~60GiB/s. Making the
> > buffer 4k, brings it ~95GiB/s (baseline is 100GiB/s).
> 
> Note that right now, 'unsafe_copy_to_user()' is a horrible thing. It's
> almost entirely unoptimized, see the hacky unsafe_copy_loop
> implementation in <asm/uaccess.h>.

Right. The patch below brings numbers to to 64GiB/s with 256 bytes
buffer and 109GiB/s with 4k buffer. 1k buffer breaks even with
unpatched kernel at ~100GiB/s.

> So honestly I'd be inclined to go back to "just deal with the
> trivially small reads", and scratch this extra complexity.

I will play with it a bit more, but, yes, this my feel too.

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 3a7755c1a441..ae09777d96d7 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -612,10 +612,12 @@ do {									\
 	char __user *__ucu_dst = (_dst);				\
 	const char *__ucu_src = (_src);					\
 	size_t __ucu_len = (_len);					\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
+	asm goto(							\
+		     "1:	rep movsb\n"				\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : "+D" (__ucu_dst), "+S" (__ucu_src),		\
+		       "+c" (__ucu_len)					\
+		     : : "memory" : label);				\
 } while (0)
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

