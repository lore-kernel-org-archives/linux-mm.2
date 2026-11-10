Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CED0606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E3iMyEM+
Received: by kanga.kvack.org (Postfix)
	id 92FA66B05C0; Tue, 10 Nov 2026 11:02:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906946B05C2; Tue, 10 Nov 2026 11:02:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8449B6B05C3; Tue, 10 Nov 2026 11:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 670E06B05C0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E95C4A0992
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:49 +0000 (UTC)
X-FDA: 85419677658.24.C84A384
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2AB15160004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E3iMyEM+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326568;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXq8PDNIQrZeyWBnmLP8bhjWVYFr4ZgQ1bg8o/V0OUI=;
	b=c6pbN0eeTQvQhFfk3qXtIz3dvptxRuoFnKuZ1/ExSKTk27QBtfLiRW8hbcPzBWrZAZ9hzf
	21iByEzCGL2vkYQgVYYrm2Vf1vkG5YZgOHfho3LMHQT5/zHN8yFX/u/7PTtalYOSJnkK61
	Y9kz8Pg739iqeblWDzfftil5Nt0B9qY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326568;
	b=ULZbQrX9tmIfBaS3CLZM1t9lde+YzVd5tmD4pxciuEYc6wet3Nk0bON0UlgZdeKF8CZe1v
	nFAw/njay/IrMeNMn9s6eYhhvS7qpQTJhYH81I2+dyvtnqDnZ5GTkoekY7s/3geTNCVmZ/
	240WUMOo+1xFOvL2Y85u4AqeSrjNZ/I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E3iMyEM+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 159C0411DF;
	Tue, 10 Nov 2026 16:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6765C1F0089F;
	Tue, 10 Nov 2026 16:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326567;
	bh=DXq8PDNIQrZeyWBnmLP8bhjWVYFr4ZgQ1bg8o/V0OUI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E3iMyEM++8A/YraFrygM+SpA2oJaibi92VQ9t7HskiO9vJDagsvpk6fe5ECIaFfOl
	 62PmTJr2kModstUVUCWrML/VVvfJdcWbmHoPT32ORhYJpAPTMJW860p3KECVtBGRGM
	 e2a2sB2CFIMDn20uZFnohMqs7kzrKH1d/CKJoaUoBlO1r5kkdYPZ3VdVJt+S2Lqfuw
	 UfLm5T749CskwTnoQJxyR76fCkrmSnCNgbK/mHzn27LJcp3bVPAA+SxmNrB34RMavn
	 jNg4B+tTqcgluAFcIo2g74s2UI5t+qJS59JdUwqjE5NRXBc9CnrM13qIfgBAqYwytZ
	 jtJjuQJ/BiRIg==
Message-ID: <sashiko-outbox-207315@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 01/22] mm: Introduce kpkeys
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kevin Brodsky" <kevin.brodsky@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb+git@google.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>, "Jann Horn" <jannh@google.com>, "Jeff
 Xu" <jeffxu@chromium.org>, "Joey Gouly" <joey.gouly@arm.com>, "Kees Cook" <kees@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Linus Walleij" <linusw@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Mark Brown" <broonie@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Maxwell Bland" <mbland@motorola.com>,
 =?utf-8?b?TWlrZSBSYXBvcG9ydCAoSUJNKQ==?= <rppt@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Pierre
 Langlois" <pierre.langlois@arm.com>, =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRv?=
 =?utf-8?b?c2k=?= <ptosi@google.com>, "Quentin Perret" <qperret@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Yeoreum
 Yun" <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org, "Ira Weiny" <iweiny@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>
In-Reply-To: <20261109-kpkeys-v10-1-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-1-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:02:44 +0000
X-Stat-Signature: c6s79jhc3drbhmfic9knbgmbp5aeubka
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2AB15160004
X-HE-Tag: 1794326567-988948
X-HE-Meta: U2FsdGVkX19WWt6FF9S6A6Gi7emoXfHxHBB6fR0I11NK0Uzywe6k8BUdkhOPmTtmmhOmEkmdmD9lWXng+jvchsvh/s3XE7jxtX/yj5qRqU33h1iyKrxocThhQHlCzjKW88In5gpQsG+3gt/2JpsAPJWH1SzC/cqmP2OI2T2/b6j6ycqauGe2oB6/JVCkQCIQEtwypAzzoT1gxRgTL8t9eMdmHyQTdF5jg4DqCF9ivMsGkxiLiPoSTAAAQ+2oX3xDuEKeRklREvMHirVFr4NQdO3oNruRp7o/IwMN/bHSoAJOo0SOxVferQMF9xl1w0vCSBsidmja47ZFriMW6iaACNdMdQNq9Eog025REaTtQEuuaXYGa3Usy8zzjr1bImQrAqD1hn1Fa0R6l8vwPgAaxjQjImnZQKw6LvavQVuqOW+MnNlM5675rWYzcZqG7nBqcHegiD42LuBcZQcbisK5GFe8QP+KrI84XWx7VZeQzfj/3GV8iztO+7POPY5yv8lMHXYqDzkqn8DD3CcgGqhAFCTvtlr3HE58IbO5XgmG9bxUNyBf074UNqwRQthNFFPv1wsukuijBHL3dxkPgqPW5iqpFCE4laCAWUf6aiPe+UpDwaYvczVjpjbJ4QjiDF3vKLje6+GF7uXF91yi35PD77Gj2k9FEvEbMk4+yZlpw2/H+chw240q+c99BnxchbifwMnz6Gs1rVZgjp+8/Uicdc+rJglc8rBQQa0/PBhdlC7D9Il/pb7CeGlZOwkOV7UaX7XWdyBww638JXsJNKgK/yAgOu4wnvgccOpqgbFMX+/uKi6F6oH/ANo8p4veBMJbKJsxQZO/7LQgAfhwbFNeBLsFDvN7yWHHDqpOKYifof4q6nJRlQHv1IqNZAvJ1l+GxYdjikS3v/g6ufMaCJz2f+0038Lk9+cooMQPIu/merWy+aVk8gFuhVlDPpMdbcY8GDaKq2gDenjqRyBtvrl
 sJvprSx8
 aaMoarxhjOVbjorRWVX5I/TcJ6I6IsSHHUPyp/kzeZm6fZVmmsaCtPBWERIwP9tS+xCyu029kO25LyFDpswcfoMVdETpJN0h7k3SqKSgL5jlmSvvZFsjclKh6cmUKC970h4bynJ4agdkC/S1EeJJ+V8Pznj35iWOprLmAo2FS8fR4drQayq4x5+4fFjma6cp7yPLHicfy4bvYiMH1ZRcgMecv0JGNJxIOKHdwfBqk76eoDBZ2EbZG9AFE/i5zoWs9i2SYS/c8ihRz+XlKeXX1eiIo81WArNYPXBfnqoYSgks8jAI1gi1e0pzAmOcGK5xB8Hq6Gf8PCCvR55x9Q8sCqaUJLSipwuG+z4ku0CuwjlLOatml/+0QMS+ddTQtvixkF34XbJ6DdY6mszfe4hrhDlf+KGzXS8s8ilDou/MLgw31uyGgd6at1iMkMvK0CzDqbYJUPh2MoGBGrHhEjSVItt+kJlxcNGVBO7nV7FEZHVKiNjyM8316RXtu7yEEcJgsKq21cqS4OP7IjXJquqEvhMTypiq92erRzbp0xF/bfaBQwMZXoaOSHK928tOxlGlH5JZhoz902dWd7/IDZRr3fya+fHbRsVs4Xs9TO4vFMOFVDb2xTrKGO0+qqDB7ZBoMulv0wSEQd1/lOFvnKMRo5/RGxKSNIQN/fD7bkJfaL9XmgpFI2sqjcTQfzD900ONEqA46z+vZ4XOfaPmAtOUGpV+VSUpN5JCTDpbqd5Q28gztVfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm: kpkeys: use DEFINE_CLASS_IS_UNCONDITIONAL() in KPKEYS_GUARD
  macros
--

commit fedb14faa9a0bdbbf2b6d66e78122c92692259b9
Author: Kevin Brodsky <kevin.brodsky@arm.com>

mm: Introduce kpkeys

This commit introduces the kpkeys header API, context switching helpers,
and guard class macros for kernel protection keys.

> diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
> new file mode 100644
> index 0000000000000..69ec4808d850d
> --- /dev/null
> +++ b/include/linux/kpkeys.h
> @@ -0,0 +1,107 @@
[ ... ]
> +#define KPKEYS_GUARD_NOOP(name)						\
> +	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
> +	DEFINE_CLASS(name, bool, (void)_T, false, void);		\
> +	static inline void *class_##name##_lock_ptr(bool *_T)		\
> +	{ return _T; }
> +
> +#ifdef CONFIG_ARCH_HAS_KPKEYS
> +
> +#include <asm/kpkeys.h>
> +
> +/**
> + * KPKEYS_GUARD_COND() - helper to define a guard type that conditionally
> + *                       switches to a given kpkeys context
> + * @name: the name of the guard type
> + * @ctx: the kpkeys context to switch to
> + * @cond: an expression that is evaluated as condition
> + *
> + * Define a guard type that switches to @ctx if @cond evaluates to true,
> + * and does nothing otherwise.
> + */
> +#define KPKEYS_GUARD_COND(name, ctx, cond)				\
> +	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
> +	DEFINE_CLASS(name, struct kpkeys_state,				\
> +		     kpkeys_leave_context(&_T),				\
> +		     (cond) ? kpkeys_enter_context(ctx) :		\
> +			      (struct kpkeys_state) {}, void);		\
> +	static inline							\
> +	void *class_##name##_lock_ptr(struct kpkeys_state *_T)		\
> +	{ return _T; }

[Severity: Low]
Could KPKEYS_GUARD_NOOP() and KPKEYS_GUARD_COND() use
DEFINE_CLASS_IS_UNCONDITIONAL(name) after DEFINE_CLASS() instead of
open-coding __DEFINE_CLASS_IS_CONDITIONAL() and class_##name##_lock_ptr()?
include/linux/cleanup.h already provides DEFINE_CLASS_IS_UNCONDITIONAL() for
this purpose, avoiding reliance on internal cleanup.h helpers.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D1

