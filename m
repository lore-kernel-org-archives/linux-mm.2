Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D427FC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF17C6B00A9; Thu, 16 Jul 2026 20:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2746B00BB; Thu, 16 Jul 2026 20:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB0F6B00BC; Thu, 16 Jul 2026 20:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0056B00A9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:33:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 216CE1C03D4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:33:59 +0000 (UTC)
X-FDA: 84996396198.24.F111404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 76A1380004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:33:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0vonKjRH;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gwmmi5eawuUbJV6BP0wCsvRvxdQC0IGif9P1zhEbx9o=;
	b=j0E0eeINP+x4G67UzFiTU/NAYwqUsTu6WElSxKkZ/4bNpzZ0Y8LLs9JqvmvrpOCi2nfhN+
	0oErQiO7cX7x1y0eZUrh3XvAK433umokXWHpxoqyep/zw8tvU8Q2ZQcfmE6oY1eqaylGW5
	y6GJiRFAZW13Uf6KAj0/Nk4Zk4cvc2E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0vonKjRH;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248437;
	b=YoI9dsP4YXQUzcef1e6OZ0bX6CASdEOneANwCtTLnbxEhoNIQoWaOIcnNDwHYwp9Xb3z1c
	ZKyviB+WUzeMTTW10mgSSEqvjXwty4wDw+695wioucp2HC/+1EU5iJlhTCjR5mGNpx9ePe
	n/VTLAk2ZfzS44/Kh8cP3SvWN2tIaYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBB7E60204;
	Fri, 17 Jul 2026 00:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF5A1F000E9;
	Fri, 17 Jul 2026 00:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784248436;
	bh=Gwmmi5eawuUbJV6BP0wCsvRvxdQC0IGif9P1zhEbx9o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0vonKjRHnSaFmxLumz1p2dFMGcVn3PArMNATMyHy9muWt7D4JuBI8uB/uxehh8WrA
	 ps8FLqIgvKZOjpZldfw/ezORCjdioAfwFw75egePDQTCHsqMYMliuvUkGTx9UidPO/
	 E193E7tfwviQggqJCkTMwE0MPAEulYpvF7LH2vi4=
Date: Thu, 16 Jul 2026 17:33:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook
 <kees@kernel.org>, David Hildenbrand <david@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Leon Hwang <leon.hwang@linux.dev>
Subject: Re: [PATCH 3/3] mm/mseal: remove further superfluous comments,
 do_mseal()
Message-Id: <20260716173355.41a98b4e5d5a06772fd7fc12@linux-foundation.org>
In-Reply-To: <20260716-mseal-fixups-v1-3-3a9609bf041b@kernel.org>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
	<20260716-mseal-fixups-v1-3-3a9609bf041b@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76A1380004
X-Stat-Signature: is6pir7ycfud5t7eco7epc7irpyj7f75
X-HE-Tag: 1784248437-926773
X-HE-Meta: U2FsdGVkX1+k5ZO01i6cWckCBAm9RqQhfrSkVzw5aFA/MWiTEq2QchERHJSRCt5BkSAx3zRPUxxEWkmLISmqcaOQxfi4+Z5jWFTEyOsI+/tI3ispx6lIOyKe6qrWx4GC/ELWTAXtGNHYbb8MCCzNrdRgFhDeKq4SuHvs/MjwSK2tBXEuyEO6hZbYNTB+0ekMVBA90eDy3RE2zihAo0QJpDvfTD4Ftv65c77Jgoe1ATq3gGrIc92JmETSGAk4/8Tt4Q4l5/tmM8rOaPIFKs9mgNrTKB6rEAeeZ63fcewHhOufWPxNf8px1utNBxZNXqW27bGvDlbc3qKM2Rz2E4y5tG/gDLXCl6Tc8pDd4a9y/rBbbPC9hYTeZQ1NqZvaxf2TupMDGpejLyYhIYEdvxKDG6fbc8wGKqfdMrYvnUQF009N4qfd/aD2s9h+2iFCT9ZMwLbDqVYrIVbdUGG5nJpD7OitJ53dENmrrpQ2vxQruv/09EsDl5Qm9jHIdcMeLvYxchUwM5R5qh8cBf2uGjR7KO6HDeNlweRhh/VpgXB7OyA76hJa4QrKVi/iRu5leREXyIClOdDZ9xIUVxA1m0PffK0m8s+A5VP5a4trMkC4u5oz4Uszb4os7OIe05zekCO4Z/z3g2RH30OcbQGDs32ErdNGFz+D5ksxUOwgldSrEcFvt6fpC7HYswfR6E2ATquRuuRWm+OTJV3OSvq1fQrtk2+G/2QqPyZz7mFebczKukZmg5FfaIlf0f5H7R0oC9gcsbH+q68Y2jIZyHOiTT9JL7b6lQGqCHwZJsQzpu+ngBjPljzEvIg4csbx4TI5pcV3h4X13v1gZMDx1Uon4DA87IF7rxvDrEXy4MW4wFzbYnc9E+uvNvRe6PeJ1SOFNxo6vp7SGzdo2s1y6IL53cvo4reaiZ2e40qvmsKMK0byoYg60lhX+Pf6VHwxONrneGy2DXY6G3PtOPhiCddCzcH
 ya3xp3at
 lD7iRVjXOL7aMH4Rwnfsj5Tfhx4lTm9SZPuznmisPiuZTfubMawEClKUDA+0RY9gvmQpKIDuXYkt1dDdGG2d0IMz0ytKhYQdduSpkLqNhFYbWPi+s8sFhV4+Fyhyc+Ucl7HNlr7s5CSfC6rheLmzWpMDHJa7208xOqUa4L6h1GdvvP+aPpSV3Fjeujqd3imnxRCuNMDhRKVqjsq8eHYn/sqhKfaAPFaTGkCHiuXHSf0Eg5DG8YE7QoU/zWSFY0DqC/4gkY97fTWAXA8Bsyj7fjfuOa479nvIOei/ISC7hAeT7rmZQDbRZLIEb8p8APfji0U3wWvfK0/bwEh0EX/cHhvHAP0U5uOXsUcI/dT/8G0Kdp/eAuCGumebEKsDd670RjO9TQF6Wjfrs+X2LlObylHZelDljsR1kjoRLd9dLbUyQZlME+4T0PrYgaOjoDgzM9br71kNQIlh3LZNFxH6TZFdfV8A9uyWSWw01+yI7nIJFuOYJm4WU4Wpl+anpvhhEma4zLPUCpTfm682TlhAdfFgLkTcKc4eFvMd/sLbhHfZ2zKXCUHWbRwk3KRCyhC6+9il9M82mehB9hRbCY1XZwADvGEYCjk95Y2aPAT7fV62AzgRblUlvlv8Ozw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 14:43:11 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>=
 wrote:

> There's no need to abstract do_mseal() any longer so put the system call
> implementation in the system call declaration.
>=20
> The comment around do_mseal() is strangely formatted, overly long and adds
> a lot of superfluous information that the code already provides, so boil =
it
> down to the essentials.
>=20

This patch
(https://lore.kernel.org/20260716-mseal-fixups-v1-3-3a9609bf041b@kernel.org)
overlaps muchly with Leon's "mm/mseal: fix mseal documentation for
32-bit kernels"
(https://lore.kernel.org/20260715131258.55499-1-leon.hwang@linux.dev).

I'll remove the mseal.c changes from Leon's patch and I'll retain the
rest of that patch, after adjusting its changelog.  Please check all of
this!


Here's what's left of Leon's patch:

From: Leon Hwang <leon.hwang@linux.dev>
Subject: mm/mseal: fix mseal documentation for 32-bit kernels
Date: Wed, 15 Jul 2026 21:12:58 +0800

mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back to
sys_ni_syscall() and return -ENOSYS rather than -EPERM.

Drop architecture description in mseal.rst, since the arch feature doc has
the latest state of mseal for each architecture.

Fix the CONFIG_MSEAL_SYSTEM_MAPPINGS typo in init/Kconfig.

Link: https://lore.kernel.org/20260715131258.55499-1-leon.hwang@linux.dev
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Anand Moon <linux.amoon@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leon Hwang <leon.hwang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Wei=DFschuh <thomas.weissschuh@linutronix.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |   14 ++++++--------
 init/Kconfig                          |    2 +-
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/Documentation/userspace-api/mseal.rst~mm-mseal-fix-mseal-documentatio=
n-for-32-bit-kernels
+++ a/Documentation/userspace-api/mseal.rst
@@ -50,8 +50,8 @@ mseal syscall signature
          * The start address (``addr``) is not allocated.
          * The end address (``addr`` + ``len``) is not allocated.
          * A gap (unallocated memory) between start and end address.
-      - **-EPERM**:
-         * sealing is supported only on 64-bit CPUs, 32-bit is not support=
ed.
+      - **-ENOSYS**:
+         * The kernel does not implement ``mseal()``.
=20
    **Note about error return**:
       - For above error cases, users can expect the given memory range is
@@ -62,7 +62,8 @@ mseal syscall signature
         memory range could happen. However, those cases should be rare.
=20
    **Architecture support**:
-      mseal only works on 64-bit CPUs, not 32-bit CPUs.
+      mseal is built only for 64-bit kernels. 32-bit kernels return
+      ``-ENOSYS``.
=20
    **Idempotent**:
       users can call mseal multiple times. mseal on an already sealed memo=
ry
@@ -131,11 +132,11 @@ Use cases
 - Chrome browser: protect some security sensitive data structures.
=20
 - System mappings:
-  The system mappings are created by the kernel and includes vdso, vvar,
+  The system mappings are created by the kernel and include vdso, vvar,
   vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprob=
es.
=20
   Those system mappings are readonly only or execute only, memory sealing =
can
-  protect them from ever changing to writable or unmmap/remapped as differ=
ent
+  protect them from ever changing to writable or unmapped/remapped as diff=
erent
   attributes. This is useful to mitigate memory corruption issues where a
   corrupted pointer is passed to a memory management system.
=20
@@ -143,9 +144,6 @@ Use cases
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
   architecture.
=20
-  The following architectures currently support this feature: x86-64, arm6=
4,
-  loongarch and s390.
-
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
   of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
--- a/init/Kconfig~mm-mseal-fix-mseal-documentation-for-32-bit-kernels
+++ a/init/Kconfig
@@ -2120,7 +2120,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPIN
 	  from a kernel perspective.
=20
 	  After the architecture enables this, a distribution can set
-	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
+	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.
=20
 	  For complete descriptions of memory sealing, please see
 	  Documentation/userspace-api/mseal.rst
_


