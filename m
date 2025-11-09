Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8BA4CCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 18:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5386A8E000C; Sun,  9 Nov 2025 13:06:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FC98E0002; Sun,  9 Nov 2025 13:06:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44CD08E000C; Sun,  9 Nov 2025 13:06:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE0A8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:06:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBE00899F1
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:06:56 +0000 (UTC)
X-FDA: 84091849632.13.681172E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12CF3100017
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:06:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0GBkoTL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762711615; a=rsa-sha256;
	cv=none;
	b=jBnONpfOAW6lB+4kwq/QmZHshRaEvHUb3Xdf3KJaCLqm2r+k55uRfF5b4t8N7cObj2WARD
	4V2qih/Qceq6cBI2vWJVxhBIw8yoExHTDw/LWwZlw0tTGrosh5nEC+gqGzLR+DGTz6LTsJ
	Fz+i+QaaAfHjcWZHoA04PxrFp5LX8qs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0GBkoTL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762711615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGOxm6IC95Y3Q6Gnvx0OjSMZumaLJKCVTHUwhCeVDoI=;
	b=P82JuFWuHFK8/WDOJlnAcz/lWVaNW0CW1LCmSNrMZEuUv8tH08oa9fuWo99lXP20Fpbsk6
	PF4dN4Ao6FZfYeVTynDsdsQdVb1rwFNPTwekmfGSJNkARo4zG+YGlqa0LVC2mh352n+Usg
	d1Xu+JzbiBBUu3eDTFicQRUTECYlt+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39F5B41980;
	Sun,  9 Nov 2025 18:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5552CC116B1;
	Sun,  9 Nov 2025 18:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762711614;
	bh=Jyr7Advpmrp/1CXXyDKOLNg7W6MBf8xRQAccFc4INxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a0GBkoTLiucisSat+h25ppOAFgAegqvUxdUtTs5Nk0rTPhy15MOS68GznbscGK5rT
	 mi+aEJadB1f7qTq2pjsoXaVgesLIKFdlr2NIExfvOYDCKvc6NJoEqWsLGSCX2Lmjh+
	 2NGQdojgnMGUR2BwCwr41SVkshdRCei2h2KnBeCeRxOHaiz6Vwc0gYJf0KVSkfTXAb
	 2kB7ylipQrRAkYtOFFB+btd7ShBG04R1Reyfh0LAYf1spO2NzfJGh0mrgWSLAB23bs
	 Nffz7yGvfL0urnkkTwWVO4tF0BOf+ZQ6frVykZAY3iWTzxzawWAXnogLuQSdq3qWPd
	 WVwVE6jVwwHtA==
Date: Sun, 9 Nov 2025 19:06:49 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 0/4] Add ARRAY_END(), and use it to fix off-by-one bugs
Message-ID: <cover.1762711279.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758806023.git.alx@kernel.org>
X-Rspamd-Queue-Id: 12CF3100017
X-Rspamd-Server: rspam07
X-Stat-Signature: i49dmkewbcj6ncd5qhdtok7kbcreghos
X-Rspam-User: 
X-HE-Tag: 1762711614-568724
X-HE-Meta: U2FsdGVkX18wo3LDIXsdR/p2EteN6rSpf+iYjGdv7/x6qYFzF3kbG3Q7USHVU2rJm9C4A7QNY7IHtSTG+YkfS5Jt2qO/Zi288WXDjY1p8KA7YG7Zpzl9wyfLNUHUu9gvp3v+wKlnj6MLyhxKQa9/yfG63ByP/AwaQ5JbT/2EscOaaE0WkJVQ6c4sl4souD9txIHZyiZ3lvpiVZgPsdCJfeM86wW1AFXX4TN3UycKDt6f8KOgsgxmCaEQbyWnJ7E4uk1dikIDpVl1Am6ISmHlpy4X4ZBMFU9uTIviSN6rmo5ETh1FD/5x3mR2sHvrI7GU21qKxxjinVDJZbXta7D8EdOGadHir0E0i7RfZ7yWOaZeqtS/u/BBU2xK5F/dW6q8B/KObafX5IiZfrrVt8tdAvuPHhBBIp1P7fzjvkXmLlNv09sc/bWhGB/FteAmYK4hZiip2D+s04sv9SezgHDxzK6b0x/P2Fbx4CLA5vEh6AYcppC7EhAuGAUUYewiMcOEOgclE2f32bsN/T6OsskdkskJORxahCNpt34n/DkFYX5j6Mluef4jf17cyF6S9HujXSpdf99xw9PQZZtPrrAU1zux9G9tKLEQUsJbz0jsYp2qdPuB1p1RdMkmckFoGJILWdmG81gV7ygJkXXeb3555hyuYT+Zp8+f1wVJyOEYqMh5NVrlKGVc9JJBl133voMgY9RuFpnyFGuqliDjjHokDIdIBcso0OPfb0LUhQBJ9s5fHXWC20WJRjOw6FdsaNmw/vCPJagBLh39S52ypW91xCt0m0UjcTGEpK4N2MkA29QiLoTwhD5dRpC8xqH90j/kvXipOxM97ZmxQhXV+uOPdNzHkXNyBwnKoOlVt2WQMpqh/9Z5UghuDzqDXP57e5xFkdOidiErfnO207HayNl3UB376rustip7pygzuACTg3Nuu0984vTX1kowbQlnMo/QQBjlBah3QyDWLJtEzdY
 LY9qnmfm
 eG7TdfXi2FusbXThnIKeBOlziIluz8gW/KWV2s+2+XwAMn0kAmWH9DcJShRTgFu+E9V126O7jWxGLiDO6fQEXc/F57J+3MsOTxagCadzcf49Wm1Czk3MpJgzWsPftUJx859Zfwn3be/bPu7IUnUJymuVG0zpZYONx/HDchSXxid1PdzNZnd+QxzdpYc7V+1wGFT7xWboD6wZzEQiRO/vNv2xgTQgvCwyRMT7n/QkxiVLHYuQlqfsPkRBDlG31tzsT/HDiXQrLedWWHtlOsEgo4mkLpM5pqAA6ufYHmGPTwJ0BQsdGIObvCAFL+rStCuiVQH9yurtzB/d39Vb5qeFhZzWycw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARRAY_END() is a macro to calculate a pointer to one past the last
element of an array argument.  This is a very common pointer, which is
used to iterate over all elements of an array:

        for (T *p = a; p < ARRAY_END(a); p++)
                ...

Of course, this pointer should never be dereferenced.  A pointer one
past the last element of an array should not be dereferenced; it's
perfectly fine to hold such a pointer --and a good thing to do--, but
the only thing it should be used for is comparing it with other pointers
derived from the same array.

Due to how special these pointers are, it would be good to use
consistent naming.  It's common to name such a pointer 'end' --in fact,
we have many such cases in the kernel--.  C++ even standardized this
name with std::end().  Let's try naming such pointers 'end', and try
also avoid using 'end' for pointers that are not the result of
ARRAY_END().

It has been incorrectly suggested that these pointers are dangerous, and
that they should never be used, suggesting to use something like

	#define ARRAY_LAST(a)  ((a) + ARRAY_SIZE(a) - 1)

	for (T *p = a; p <= ARRAY_LAST(a); p++)
		...

This is bogus, as it doesn't scale down to arrays of 0 elements.  In the
case of an array of 0 elements, ARRAY_LAST() would underflow the
pointer, which not only it can't be dereferenced, it can't even be held.
That would be a footgun.  Such arrays don't exist per the C standard;
however, GCC supports them as an extension (with partial support,
though; GCC has a few bugs which need to be fixed).

This patch set fixes a few places where it was intended to use the array
end (that is, one past the last element), but accidentally a pointer to
the last element was used instead, thus wasting one byte.

It also replaces other places where the array end was correctly
calculated with ARRAY_SIZE(), by using the simpler ARRAY_END().

Also, there was one drivers/ file that already defined this macro.  We
remove that definition, to not conflict with this one.

---

Hi!

Changes in v3:

-  Fix commit message.
-  Remove old definition from "drivers/block/floppy.c".
   [Reported-by: kernel test robot <lkp@intel.com>]
-  Use definition of ARRAY_END() with array notation.  There's work in
   the C committee to make array notation slightly safer than pointer
   arithmetic.


Have a lovely night!
Alex


Alejandro Colomar (4):
  array_size.h: Add ARRAY_END()
  mm: Fix benign off-by-one bugs
  kernel: Fix off-by-one benign bugs
  mm: Use ARRAY_END() instead of open-coding it

 drivers/block/floppy.c     | 2 --
 include/linux/array_size.h | 6 ++++++
 kernel/kcsan/kcsan_test.c  | 4 ++--
 mm/kfence/kfence_test.c    | 4 ++--
 mm/kmemleak.c              | 2 +-
 mm/kmsan/kmsan_test.c      | 2 +-
 mm/memcontrol-v1.c         | 4 ++--
 7 files changed, 14 insertions(+), 10 deletions(-)

Range-diff against v2:
1:  35255c1ceb54 ! 1:  2cb4ddff93b3 array_size.h: Add ARRAY_END()
    @@ Commit message
         the array argument.  This pointer is useful for iterating over the
         elements of an array:
     
    -            for (T *p = a, p < ENDOF(a); p++)
    +            for (T *p = a, p < ARRAY_END(a); p++)
                         ...
     
         Cc: Kees Cook <kees@kernel.org>
    @@ Commit message
         Signed-off-by: Alejandro Colomar <alx@kernel.org>
         Message-ID: <37b1088dbd01a21d2f9d460aa510726119b3bcb0.1752193588.git.alx@kernel.org>
     
    + ## drivers/block/floppy.c ##
    +@@ drivers/block/floppy.c: static void floppy_release_allocated_regions(int fdc, const struct io_region *p)
    + 	}
    + }
    + 
    +-#define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
    +-
    + static int floppy_request_regions(int fdc)
    + {
    + 	const struct io_region *p;
    +
      ## include/linux/array_size.h ##
     @@
       */
    @@ include/linux/array_size.h
     + * ARRAY_END - get a pointer to one past the last element in array @a
     + * @a: array
     + */
    -+#define ARRAY_END(a)  (a + ARRAY_SIZE(a))
    ++#define ARRAY_END(a)  (&(a)[ARRAY_SIZE(a)])
     +
      #endif  /* _LINUX_ARRAY_SIZE_H */
2:  acd8bcbb05d3 = 2:  831155f02bec mm: Fix benign off-by-one bugs
3:  781cce547eb2 = 3:  d8128f0c8b9f kernel: Fix off-by-one benign bugs
4:  094878542457 = 4:  9646a1d194a5 mm: Use ARRAY_END() instead of open-coding it
-- 
2.51.0


