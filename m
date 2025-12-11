Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5C1D41C17
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3005F6B0005; Thu, 11 Dec 2025 05:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D86C6B0007; Thu, 11 Dec 2025 05:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE706B0008; Thu, 11 Dec 2025 05:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5436B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:43:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD86BC0839
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:43:52 +0000 (UTC)
X-FDA: 84206854704.21.5721CA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E10CE4000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:43:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TzCWGhmc;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765449831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyqfIo8VyN4wBnDpFgoy4kAvS0TY6gHlzsTyhAeK3Lw=;
	b=SrvRv/cwOUFqwa/+WWYiNuJKt2vPFWF3JPmmkIUTpdVNwY2x1HjkF/+FWSCT20qI0FZY7G
	vgYn0cZddw5b5tVKWxOf47JKf/mwgckSURYDDY+IcU6Dp1vn9nBFD2sVhppyqr4Jp6Gpyx
	SpzvEIBoZKrlc02Gu9HPvICIZMnHY78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765449831; a=rsa-sha256;
	cv=none;
	b=PqP3epQd9wKMI48oqS6J+LZiBuk2k8g0Uho64HtEoU3mTg6NAr8tJYNmfIln9J2+WFWnYN
	d4udpbhUkmvL3P/x9Yy0hbMGdhZ2dqy/zehLhuvaDZOYK8EIm1SZBsHDVoIsppx68rZuQ5
	c6QyQkve5sXBcDiQlx0KNu40w+NvHK8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TzCWGhmc;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D7C84441D;
	Thu, 11 Dec 2025 10:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51356C113D0;
	Thu, 11 Dec 2025 10:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765449829;
	bh=SL08egAf+JvLRJMamE3oqe4gonfUljQf3NQhumvhwxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TzCWGhmcsJOVikxD/0Atui8lv1QE9lu4h0KgG/QaQR9zJE+7ul8zV7he575FLyPQ3
	 AiDhS0jeb6Na3e94u6aqGPn562eEQjeCbhP80Ni75E/RJgsGIoRR1k8Ff/TGv+W7dU
	 iFxP1pVv7KpzBOFmbTpC8fQIPjiA3fXCox2jPXglZVDW4pfdTU53yq9ISKAotNWsyE
	 Bn6TOfQ+SplfouSyUtDo3Wy859GE+oKN8iVel/6WF7SDgfswCOcSbx3/Wa6iGkdaHy
	 1vRvbeJK0pdYIvXcPCRn0Jbrfs/hDh8oJk8KGPnJ0SNeU8VFBxeulR5vKqARjztXXS
	 MDVxnbvEig62g==
Date: Thu, 11 Dec 2025 11:43:44 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v6 0/4] Add ARRAY_END(), and use it to fix off-by-one bugs
Message-ID: <cover.1765449750.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758806023.git.alx@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E10CE4000A
X-Stat-Signature: itpu4776neyywk8u5i6sw961fuop7s9d
X-Rspam-User: 
X-HE-Tag: 1765449830-956385
X-HE-Meta: U2FsdGVkX1+fZjuB4mK6b/LQ++xkfmjyfj3Agh666iXQ5r2Gutlzg8LF0bFrmaiTbWm1We+4obY1hblBuv/OUiFyDThlQblq31PJtHoSxbbrCi6aS1XJ4LG3pCgCNWdysO0xOaAuTY5bVRZDtE/eUSN8WY6t0CcD4bp/3RIkN8Ncxp8szZ0qxqKeqZWYoHcdHzSCYyNeAyJ5kqrQ6K45zRpllqMfdfdRtWElX4vF29qrnpN2feGUCSZWx7KwXYPgMUTvi3PCcXKTxVczWPhZ6kI7g5hjAmA0a+8Dkb/Z/sBgs3p+piml1tOIRF8f/SJejquCrjtzooXEUzybZ9hEyqAz/HHW1FsDrOD9VNLSSQlzJyr9f71jUbPVw6xE2+y124U6i8gherJ3IYkMGhfKChbOo6E5JCPGzgskiYjDPqcpcBEuznMfud8EyRUPaBZotFKeO8alSoHsMUIZnzbyJmnCQ+9X5xcllK4ucYRvPUb7KW+k8nAzKx4u1cOIyBPBd72b4q98fZ5QuwAXygJIb4Di9jrS6lrWDSbML4xuFDuClxvPgjKaam//NF8tYp8HXVHGSNNl/olRzIqhQ5JumHVbbCj2VDJ4U26SB1hBu44+QQnYOI6x5qazwILHEOG+vmuliwXjkb9CXwjEcbMyf7vjvBP14zoWVGdypM3pk3kEvgTbVXC6XFr2aYbknSR8K5bkirjMbSrNTF2JPXWaJL48a4tr7XyYRZxTOIbHinhwK7d53bFqEWlZfdTVhKO5yuC9y6RXr84rv6xvEE0GcQ7MkfJFhD30U5sqPTPwV8JG7WUDiX2JmMvIqbcZ08GoXaaUH93bAgsjqtBc6Ec7DT53ydffrzvrmLVXkFhMD1zoPiyAv92D2aYLZIgVNPzC3rjqmI2LT532s6RVWjNr6cJA4F0ALvCrrx6ULurlCbFaA1J8wWosThVrJ6GJ8Ieq8w4OAODUsectCTmB5lh
 Rc+/RZqJ
 D6AN2lXEhd3sg4GhsXGyIhIRZMkXc/0O9Oa1v5OF0NnAmn9seKYWVCQXqhyxXHmK4pqnBLSu4c51fZXTel0aUDQRilaolFCgvwhy/YClF7T2pn3byTMlxin1yKkdxGTLIi4bbWtmO9ZXds1SeMNUVRtrd/Ye+3rJox7jgeNKeNFlzBlZoU+OYCIeKgk6wCisgfz5VFcgg9DwbwfTqDI1rgr8HvEJRF+Ew3jpysi/ANcvIgD1tmZcIE0X9xLZ8cLeSE+ww8j8ONKa0VH7VN7hXnT0l4KxmTzJTz0ccPgj2yfTybBLgOE/2goWiet9/P0+9bu5wNQbZXvy4ywgw4zqArdoqY5MzQWGd89IbABciaH5+FIqnYKuHnfljFmUlxYObtd6Wmbbg034TSfPpzsewNbkpiS4E19oklK/VROurUpgM0b29x3rqRmRRFChTMsPj08Poxhnp+GlBSi7EXUKGHzd01NqQ4W3U2MUJeR9vUjFCzORhcd2kTiKtpND7kJ/eJQocTSyMwT3TZEeRPhhCZDNyU3byqupOqDBxnrwYwYLdThnpRsP4+xhANBSPlv2ARx3jylQrB1PulMBICkSyns0PBcGohIdEuV4c7PmN4FwHzmBVSWRPGRsf7V8GKNwyd6yjIgDn82wnFRQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ARRAY_END(), and use it to fix off-by-one bugs

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
pointer, which not only it can't be dereferenced, it can't even be held
(it produces Undefined Behavior).  That would be a footgun.  Such arrays
don't exist per the ISO C standard; however, GCC supports them as an
extension (with partial support, though; GCC has a few bugs which need
to be fixed).

This patch set fixes a few places where it was intended to use the array
end (that is, one past the last element), but accidentally a pointer to
the last element was used instead, thus wasting one byte.

It also replaces other places where the array end was correctly
calculated with ARRAY_SIZE(), by using the simpler ARRAY_END().

Also, there was one drivers/ file that already defined this macro.  We
remove that definition, to not conflict with this one.

Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
In-Reply-To: <cover.1758806023.git.alx@kernel.org>

---

Hi,

v6 adds a commit log to the last commit.  Everything else is unchanged.
See range-diff below.


Have a lovely day!
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

Range-diff against v5:
1:  5973cfb67419 = 1:  5973cfb67419 array_size.h: Add ARRAY_END()
2:  9c38dd009c17 = 2:  9c38dd009c17 mm: Fix benign off-by-one bugs
3:  b4a945a4d40b = 3:  b4a945a4d40b kernel: Fix off-by-one benign bugs
4:  e7bde864b039 ! 4:  2335917d1238 mm: Use ARRAY_END() instead of open-coding it
    @@ Metadata
      ## Commit message ##
         mm: Use ARRAY_END() instead of open-coding it
     
    +    There aren't any bugs in this code; it's purely cosmetic.
    +
    +    By using ARRAY_END(), we prevent future issues, in case the code is
    +    modified; it has less moving parts.  Also, it should be more readable
    +    (and perhaps more importantly, greppable), as there are several ways of
    +    writing an expression that gets the end of an array, which are unified
    +    by this API name.
    +
         Cc: Kees Cook <kees@kernel.org>
         Cc: Linus Torvalds <torvalds@linux-foundation.org>
         Signed-off-by: Alejandro Colomar <alx@kernel.org>
-- 
2.51.0


