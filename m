Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1772D20698
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A636B002C; Thu,  4 Dec 2025 08:55:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEAC76B002D; Thu,  4 Dec 2025 08:55:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00D76B0030; Thu,  4 Dec 2025 08:55:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD0846B002C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:55:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D031F160196
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:55:20 +0000 (UTC)
X-FDA: 84181935600.26.D98FF05
Received: from mail-106120.protonmail.ch (mail-106120.protonmail.ch [79.135.106.120])
	by imf22.hostedemail.com (Postfix) with ESMTP id DCB98C0007
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:55:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Qcn4Mz1Q;
	spf=pass (imf22.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764856519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VqP9yp4hG0Ar5q/skyCmb0EwxkUlO46my0VVgJ5cvP8=;
	b=myAfmZcRQxdwtNSSHD4jLjhlMk5mCc56k6dLnPFIbh+kcVfA45B37fALDdIyj2aJFbCQtW
	X2h2uEmHP252wW7iiVsDPv1H/9rVSe9FJgTIYaYJwxQ6P3qkQ+pjm8e3i1H2EdhYfPD9VB
	80qX9krKVpCZBUQvJwZurBkZ1RDf25s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764856519; a=rsa-sha256;
	cv=none;
	b=5zxQDwH7MPEVGEs8kW1FrCLtIj1JF6U5zKUiuJP3bajUY20B+sAJ/IdCepTOfArbOWCgkh
	6rwYQGll0rab/KNyOzhxYe9YxygTWZUCVnsip9eOmFC1TP4ANcpF38PDspT3mY/1oGL0oc
	DuTTRrW5HKTGggwZPEELYVhaAycy95c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Qcn4Mz1Q;
	spf=pass (imf22.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764856516; x=1765115716;
	bh=VqP9yp4hG0Ar5q/skyCmb0EwxkUlO46my0VVgJ5cvP8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Qcn4Mz1QBAZU4uWSD+EaCWYDE44OdqZTNI4HUnYZuv06w89OG1T/trXdrydhwGNjh
	 QEn71qpJN2oQcdL8qPres5nQBMz2/DOh59TiIlpwo5USvRRljEt4Nlcv07CdiptVQ0
	 imr2neQZyEMH8cwI1UPRzjOUwSEZcMKa/4JLenzuEGX59vaiblOpMTArTbqVakbhMm
	 1DsqKmYuubc209DzSAp0DAvnUpcWCdWrvROHm6SSdN5G+QTZ9/78ygyOaA8bGprfly
	 1uVpzq15c0hQpTYSp2KaeDn8Q7mSnUufcwxclFyrjNlnlnrNSTyn/wv1GoA9BNZOyC
	 vMQ6+ttPyO2CA==
Date: Thu, 04 Dec 2025 13:55:09 +0000
To: Jiayuan Chen <jiayuan.chen@linux.dev>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-mm@kvack.org, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, Kees Cook <kees@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for KASAN
Message-ID: <5o7owlr4ap5fridqlkerrnuvwwlgldr35gvkcf6df4fufatrr6@yn5rmfn54i62>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 03c4801ace3dadbee77e720f608d8e3c32b2382c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DCB98C0007
X-Stat-Signature: 3cywt9yiuz1867hcc5hsczwt5hxq7wga
X-Rspam-User: 
X-HE-Tag: 1764856518-871230
X-HE-Meta: U2FsdGVkX19/uJAyu0VZOSGQU7+GM3TnN5/l4D3ZSaT+ccIRFtfsMIzv3efMUq78dPILQiveAwP8blI2BlqjpVyQjFmzPu+i84+713aXLQyZCFtoih8DR9MyM9kO2o3Wbd3BH3K+RII4Hr3U5Ho1g9o5xWqEjsJaeLf5l/b+L7znLQ30WrLD2bmxWg88sZkqVhv6BR0U6f26ORagDoWXa4YCRrUlDL1Z1m7BhbGuIBJOKKctRrVV9AnUcIQMjUVd1Oioh+YbCKVHauKftT32m+yTlw0xg8e6V4sGP8/YkOf+OHF6APEyUUt9UVSVcSLFDItygZM4Pf7ZO6UScZKAp4sWdItu+2Kh4JwO8GexSN8w2WgNJU6uJUKJ3ssr/LkMD2kmwWb1mbzTt6+jtRFXaoAG//87CFXQeePWHmkd4+KjgbA9ydP5moj3ZlEtY3AusLsmoomjM7Xgqw5v/pmkPrTOOSjEUcMExSdqEYZ7ee0RNz6jjpTzYiutoD4g8BYD8TXFUQLER4P/JwjnRnQV9EGUMz6bwTx7nVaMPjCmU5znixFGTbH4aq3u6PzDE4F51m+QLBKY50ZHD5nkoKugKtBVWncg+twofRZ4WDoakpF+xBVCeZwaANTjWQnulbPpsJ6koyY4s6MKK+duqT7FPIxeWj9cjheYNjZuiYr3gHgzfYth7m/NxJlxgFTUPh4Rvk1+jSbCadQUfGdrPHdNO4o0DMzWBXK+EW+GLPm1YTlIx7wVQtxZCsC3hU3bGRT01AeVCsMgimtGfM6wqTBR9xL/r6HwspBrfs56swDb03QIT2ulMaOICvielev5Xws8qmJ9bWn509WoTtgRrr3cVUdGVGd97kmpWmfvWSzOCNDbnvwVvKWXKOF/I63pdOEinaqQ4zWxO1W6x6rsI9ASvojeKJYSjm1IaEoZ/omygxUUUtYK37u24dW+Pe8MgZAvKBDiYugnmeNwzJvrGre
 z/ZFGu6z
 jxtiYxaBnUkpMlq4zHVd6LopiTeeSMM9QyzfQEQtERHE0gf7vFcBkfTHIWJrfNUKBKZtrFS/UAujamTG1tAb00N2q6hNyGbzEvq/xdAmybDVP/GEJtbws6VwimoP7VdCFnmG7+kQ2YVpGWckAQklpk8G5nOjxhx2zNmg1o6J4VQN+D1ZvbgPoE0B3nL7M4BUcwM0MrFOVgwdeGd/wOYzQovX0hVJvpGwwRI/qkRSZa0dz+Yo+DsYGQdFk8W4ka4olDd/0s1MUzw2sWGNDQ0GRHB6LHirY8u2xZqvo10/JRzEwjSd6oF8YFdLM6U4f3llqxsQS/INx08gA/wL/R2aed/ctm02BN/bLvGDM6YoAQ2lthNHSDP4rwVupILaAshPaqQZH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-03 at 02:05:11 +0000, Jiayuan Chen wrote:
>December 3, 2025 at 04:48, "Maciej Wieczor-Retman" <maciej.wieczor-retman@=
intel.com mailto:maciej.wieczor-retman@intel.com?to=3D%22Maciej%20Wieczor-R=
etman%22%20%3Cmaciej.wieczor-retman%40intel.com%3E > wrote:
>>=20
>> Hi, I'm working on [1]. As Andrew pointed out to me the patches are quit=
e
>> similar. I was wondering if you mind if the reuse_tag was an actual tag =
value?
>> Instead of just bool toggling the usage of kasan_random_tag()?
>>=20
>> I tested the problem I'm seeing, with your patch and the tags end up bei=
ng reset.
>> That's because the vms[area] pointers that I want to unpoison don't have=
 a tag
>> set, but generating a different random tag for each vms[] pointer crashe=
s the
>> kernel down the line. So __kasan_unpoison_vmalloc() needs to be called o=
n each
>> one but with the same tag.
>>=20
>> Arguably I noticed my series also just resets the tags right now, but I'=
m
>> working to correct it at the moment. I can send a fixed version tomorrow=
. Just
>> wanted to ask if having __kasan_unpoison_vmalloc() set an actual predefi=
ned tag
>> is a problem from your point of view?
>>=20
>> [1] https://lore.kernel.org/all/cover.1764685296.git.m.wieczorretman@pm.=
me/
>>=20
>
>Hi Maciej,
>
>It seems we're focusing on different issues, but feel free to reuse or mod=
ify the 'reuse_tag'.
>It's intended to preserve the tag in one 'vma'.
>
>I'd also be happy to help reproduce and test your changes to ensure the is=
sue I encountered
>isn't regressed once you send a patch based on mine.=20
>
>Thanks.

After reading Andrey's comments on your patches and mine I tried applying a=
ll
the changes to test the flag approach. Now my patches don't modify any vrea=
lloc
related code. I came up with something like this below from your patch. Jus=
t
tested it and it works fine on my end, does it look okay to you?

---
 include/linux/kasan.h | 1 +
 mm/kasan/hw_tags.c    | 3 ++-
 mm/kasan/shadow.c     | 4 +++-
 mm/vmalloc.c          | 6 ++++--
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 03e263fb9fa1..068f62d07122 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -28,6 +28,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 #define KASAN_VMALLOC_INIT=09=09((__force kasan_vmalloc_flags_t)0x01u)
 #define KASAN_VMALLOC_VM_ALLOC=09=09((__force kasan_vmalloc_flags_t)0x02u)
 #define KASAN_VMALLOC_PROT_NORMAL=09((__force kasan_vmalloc_flags_t)0x04u)
+#define KASAN_VMALLOC_KEEP_TAG=09=09((__force kasan_vmalloc_flags_t)0x08u)
=20
 #define KASAN_VMALLOC_PAGE_RANGE 0x1 /* Apply exsiting page range */
 #define KASAN_VMALLOC_TLB_FLUSH  0x2 /* TLB flush */
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 1c373cc4b3fa..e6d7ee544c28 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -361,7 +361,8 @@ void *__kasan_unpoison_vmalloc(const void *start, unsig=
ned long size,
 =09=09return (void *)start;
 =09}
=20
-=09tag =3D kasan_random_tag();
+=09tag =3D (flags & KASAN_VMALLOC_KEEP_TAG) ? get_tag(start) :
+=09=09=09=09=09=09 kasan_random_tag();
 =09start =3D set_tag(start, tag);
=20
 =09/* Unpoison and initialize memory up to size. */
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 5d2a876035d6..6dd61093d1d5 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -648,7 +648,9 @@ void *__kasan_unpoison_vmalloc(const void *start, unsig=
ned long size,
 =09    !(flags & KASAN_VMALLOC_PROT_NORMAL))
 =09=09return (void *)start;
=20
-=09start =3D set_tag(start, kasan_random_tag());
+=09if (!(flags & KASAN_VMALLOC_KEEP_TAG))
+=09=09start =3D set_tag(start, kasan_random_tag());
+
 =09kasan_unpoison(start, size, false);
 =09return (void *)start;
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ead22a610b18..c939dc04baa5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4180,8 +4180,10 @@ void *vrealloc_node_align_noprof(const void *p, size=
_t size, unsigned long align
 =09 * We already have the bytes available in the allocation; use them.
 =09 */
 =09if (size <=3D alloced_size) {
-=09=09kasan_unpoison_vmalloc(p + old_size, size - old_size,
-=09=09=09=09       KASAN_VMALLOC_PROT_NORMAL);
+=09=09kasan_unpoison_vmalloc(p, size,
+=09=09=09=09       KASAN_VMALLOC_PROT_NORMAL |
+=09=09=09=09       KASAN_VMALLOC_VM_ALLOC |
+=09=09=09=09       KASAN_VMALLOC_KEEP_TAG);
 =09=09/*
 =09=09 * No need to zero memory here, as unused memory will have
 =09=09 * already been zeroed at initial allocation time or during

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


