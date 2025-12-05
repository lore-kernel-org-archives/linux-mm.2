Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326B9D116F1
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 03:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8E16B00F2; Thu,  4 Dec 2025 22:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7916A6B00F3; Thu,  4 Dec 2025 22:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A75E6B00F4; Thu,  4 Dec 2025 22:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 557BB6B00F2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:22:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E148B9313
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:22:41 +0000 (UTC)
X-FDA: 84183970122.01.3DDC1A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57B51180008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:22:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AXGCPgWd;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764904959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCpWv9z+Wh8E9Cjxw/WIGZUdAlO+CTPRHuUi67T4JWg=;
	b=Zv3w9ColZivzXxdNJfHGgAHxswjZincgIB22GFN9OS70ri7ZEcYQ1Il3Cx/SATo4M1YEcW
	wWYeBejeoMf8yS2yzByphIr+SavSvUy3g4gR2WoGoGviXG6iF7EGsKQZztQ5cRwjp8ezbk
	S+5OhxgOjCe7jr5wGz5eYP9e2n4EKjQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AXGCPgWd;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764904959; a=rsa-sha256;
	cv=none;
	b=5zgi1vmFaACE4AnN9mOxNrey+Snmwrhji7fbeJwF0Rh0Ni/PUbAI4p1FxZR+fHQUvs6lGt
	sxa2zBGBmoIPGYrfh/Ve+Dxvez+E5C0Qo3J62P5U9QeMi9x9gj9BI7w7+vvENEmJ5rmxZd
	++GcfWUdkPfvzQB4Vx1Y6whyl8iAGfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8426B60206;
	Fri,  5 Dec 2025 03:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C737FC4CEFB;
	Fri,  5 Dec 2025 03:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764904958;
	bh=QBrTDsRqo/yw2j45O40D+5dX5EYnM1bJwpbdQGzAzdQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AXGCPgWd4mydusswaGZKqx4kEvlENRvG/I3+tUFWa0XByeiLMpFRYIlajA9z/nRJr
	 OlYuonufde9e5Fdl6T5Jf96rlSRlq5NLs/fKAvUS2+aIDY2nF+a4qvHLrT5ZwCgzld
	 q4v4GbSKtg0dLAjab3P3ybv7nvWbSbKQ2XgDr0YM=
Date: Thu, 4 Dec 2025 19:22:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Marco Elver <elver@google.com>, jiayuan.chen@linux.dev,
 stable@vger.kernel.org, Maciej Wieczor-Retman
 <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] kasan: Unpoison vms[area] addresses with a
 common tag
Message-Id: <20251204192237.0d7a07c9961843503c08ebab@linux-foundation.org>
In-Reply-To: <CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com>
References: <cover.1764874575.git.m.wieczorretman@pm.me>
	<873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me>
	<CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9g3yk16h3cprind3p8nmfyjh4on98f5i
X-Rspam-User: 
X-Rspamd-Queue-Id: 57B51180008
X-Rspamd-Server: rspam09
X-HE-Tag: 1764904959-164144
X-HE-Meta: U2FsdGVkX1/nf0mJweQ6vL6rxQK4BE08PZHlgjuWRKNRJtlfDLAymYdiV1g3pQMfaOltf2VJTFtSzleO0J7KZ0XsLt8U44YivzPZ0+G7BWAnxJ+g0YIucFNTJKkqXH+csZrx14BX1C1yX9RCazdCh+8KGS1VXWyVrueR6/Nljj9E8m9m0SLXFLXu/PMTvOvdluyoOfe7Acl7pr7V0UnsLfC4ITeB94JOKFBOBa9maS3oqRIJwMnrv2WySF0ZrTWjzhKbK+Y22d7waP6EUaNsvPVHeV70EAt+Bhw/EAfa8NIBLwRDumXqjJ+0mHdVVGDjU6LSs+q+l+T4Xo6lOkaqZrbZV7NFiFwgHytSNk3sJoH7dGrMllPOzRfI8FV7jtSWYM/nghOZN7l2djagNMH03J1cR6DeNIpmEz+dSFgoQk3tulkpK+5tcQ2RX0vB/nhcdvFX0BHbIHLhi7dbR0TV3U2BlVEXq9jp9vPm9uC4k6NG2t3Fbjl6UBZMCte0HOMaZ1IshJ+9bDubQ5MQHtt68VfE4+p6dGxHMPbTfgt/U5to9uaF6kZEQAfLGkEdv+v2xtVDzk3o9ccM+rMVuQ9IpZKTvqPKnRHz5wTS0ggBqP4WypgRrR/ZhOFHtVDZWwibsCi01gzxKPiElXjS9Ploa0cGV52Aq1fS8/YSTlN0FMIGKlNfGp2xbRx13u3VLCmoWvG+8aoBaw23UQE8jwByoqAIo+enGpMi2bdLbUkddPRqhoOiYkVEfjxJycWfsDHBahw/VurbRpegcARrC5ZYGTF/QuKdo2rcQZ6Tuu6Oo5pRwtOSOL2+WCnPabzWnzyfdQGVxtj5zJ7i5+4ReUv1iAk4d9DNT16uXtf/8Agdix9NdeEHGwwl3eFFK7CQYpHcamioY4yar6ZTrgLMFLnLCX45mmabKfh+n5qiKoBm1CnZEIACTFXG8+l7jaR+UQZGXQ3ClwwYe+o3qF/7zNP
 uZbFApKo
 MSlEExKb+qKu4SaKXJqd9CvaxNxzcYR6e4l3IJwKkuhVwreUQ8zMEtfrvI40NECjXeYHsUastt7pWHhVVl8QrvnQOAEHrAJrRieNEu0SnfHcbKighUphoQWhZxloBKxotzBJ2VGTaLfdCvjlsLJmJu2+KgsAV9HwiPJHPcFlRHR5KsEDmwYBADAgRHSy+Xfi6Lg8zGJNUk7lnu4WZf5sEXL7dL5LRdtb2GxnnAFFApyIhIE04GQyOyzl7KaAvwvZAXp5RN6QTnn3LXgk1suNk1rHgUYVPh07M0zTj/AVXLf4CwwhfiqyG2YbVRIUPZKGezUuSsQ623mnr85GXm1s75spIsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Dec 2025 02:09:06 +0100 Andrey Konovalov <andreyknvl@gmail.com> wrote:

> > --- a/mm/kasan/common.c
> > +++ b/mm/kasan/common.c
> > @@ -591,11 +591,28 @@ void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
> >         unsigned long size;
> >         void *addr;
> >         int area;
> > +       u8 tag;
> > +
> > +       /*
> > +        * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[] pointers
> > +        * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
> > +        * KASAN checks down the line.
> > +        */
> > +       if (flags & KASAN_VMALLOC_KEEP_TAG) {
> 
> I think we can do a WARN_ON() here: passing KASAN_VMALLOC_KEEP_TAG to
> this function would be a bug in KASAN annotations and thus a kernel
> bug. Therefore, printing a WARNING seems justified.

This?

--- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag-fix
+++ a/mm/kasan/common.c
@@ -598,7 +598,7 @@ void __kasan_unpoison_vmap_areas(struct
 	 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
 	 * KASAN checks down the line.
 	 */
-	if (flags & KASAN_VMALLOC_KEEP_TAG) {
+	if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG)) {
 		pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be already set!\n");
 		return;
 	}
_


