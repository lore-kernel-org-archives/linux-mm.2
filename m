Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4043CC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 18:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0306B008C; Tue, 13 Oct 2026 14:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781316B0092; Tue, 13 Oct 2026 14:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6724F6B0095; Tue, 13 Oct 2026 14:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3509C6B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:43:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 245D31601CF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:43:36 +0000 (UTC)
X-FDA: 85318476432.27.BBF3142
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14F21C0002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:43:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NcRB3S4q;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791917014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FyhhS++ZDZ4710D8q9ospxwrx6gZ9CGyXuRa92NSCGw=;
	b=BGlU/IVS5B8f/0Q+fJIuAr/ZoPIDM9VW8VvCcwgpbHXQf4lfDzp1Qt+hPI680x2Pxu3cf9
	4QqWl3fwCpHqkbMaCS7xJHwa63eXgLdpTdzUTWUKvq3nbA+qD1r4csdUZBYh2XRjty9J4o
	Fc2F6ddly2YhQnlElHGkwTAvhNRlJb4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NcRB3S4q;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791917014;
	b=RHpJHDv9WcP6Y+pAdW0HweWSXYay5A7z5+3e4z/hgQMso1gxyYcK650XmW/QqCCc0/Y1Hb
	05BHmWcRTWGT6wbP6dsu8jljWqhhZQZk0MHbr88t28MvkBTa1pNYmC0xLHhCj0jDsOFUoe
	OVk/HIgpT0cd0BnZwz7WjhyG9cb01ZQ=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2055573c8cso397577166b.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1791917012; x=1792521812; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FyhhS++ZDZ4710D8q9ospxwrx6gZ9CGyXuRa92NSCGw=;
        b=NcRB3S4qnWCyfsCPrjXDC8sm1drHZc9VKjHavUI7d/ykoiIwT74fue8/+FPJ9qv4F7
         gEjCUkinC6CseHBvdDzmePOKN7IQxjhmXe13vEOoUtn0fEx6pM3WBv27i5E8x/sOR5Sn
         kM4sfHd7O/pE1KAu/hIIIK83YwsbKCtRhXcVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791917012; x=1792521812;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FyhhS++ZDZ4710D8q9ospxwrx6gZ9CGyXuRa92NSCGw=;
        b=yr8hMUsTsa3o9od270bXKr2zCmU/bjlJF02QeDuAszD4hrzCn7Xykk44+fKcqF6gzu
         ivToXvpQcqRGxptshZ/szMbH+za6T2fsoxsXP176TBBQezP6fzT2d274mVGes8UIEZ/g
         MnNUNfUD5EaFOrEIw66wPNb+BItcI4lwZgjxmGQ5ARjpw/fzfJR+RnCbC6CbI8Sa/1At
         mOkcR0naDJkfCnLhr/V6lde9wNqveGe0tfryFF/9UAWTj0T+2Q0Ij9cbL6lsJonBqHGw
         TCS/s1gE5nGfLYF+aoFMTS4gxPQB+uVh0N9XF9YgTxeKjYGDtRVUg4zrJwOeg2wnGaq9
         oXrA==
X-Forwarded-Encrypted: i=1; AKwUvBzyXJ+3rkL1Uvqp0kEobIOrH4QGokxmG6X5nF1lUTZKav2Zo8f4joDs/giPwbDAsZcwS9rPbtlJwQ==@kvack.org
X-Gm-Message-State: AFq9FYJFxfw8OCc0L8CStgnDt/wskVepkSH6ZCXvAK7rEOnSOkuqw68o
	YfJJx1aQsLVsCYfeu32kfoHBq/npwN79jZRAoMb7jvT8cpQqnRWMArQ49nfvw/lKhV9k2k86D+S
	n8uhxlmY=
X-Gm-Gg: AYBFou1SphEWcNB6e7xW+0XNWIk04YH7IQ33KQJmaVrxzRCsKTzX0tYJfcWABsV8lV1
	67vnW59ryJchzYamzOSyu31uPPSVhjzumkS07fDbuChLHvRQIAvTfGl61MqCh5vbS3SRIhkIdW8
	5bcntKvzpbudpRzl8hbqKiHO6Ach3eIitRZEh1mvM3SxdLRQZzAajXHzvWAwut+OFaRDxcglc8H
	IzsvXYNUqyDw99OFaIEUp9cVC0C55jCTqB7e8aJegrQtxSmEqm+xFlt6aLS7LQ5eev1m/FQjOE0
	drDc1lnJzZjahHyiQn+mK4tNox+c0J7zPX0hPY4UcVwyppCbGlfb6X8yaiz3tSyv0UuCOwfquuH
	Jbj52gfRPKL6CLpvFroTfy40lJUyqpwGaO7VYIGMkZxaDo22ez46JFrmHKGHMV/kLugLmOTqG6o
	gDHgO0p6+7B/0rLjEjXnVMTUMDMSL6gblgP1BMGKbgTHPszzNQuSrpXnUs1HywFynvCwwcsqp84
	2oi0C30dDFKFISdJkcxMzBo7GRRS0DyFYegmPt/L8ju9Yf8
X-Received: by 2002:a17:907:3fa9:b0:c26:1649:47af with SMTP id a640c23a62f3a-c31a9fb6451mr1302210266b.37.1791917012265;
        Tue, 13 Oct 2026 11:43:32 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a7b976sm620307666b.36.2026.10.13.11.43.31
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 11:43:31 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2055573c8cso397573266b.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:43:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwy69EJBwYGPhTXWxLFsldTc34ifMQQsChPiBIPIJR7/oI1BRW93p2MBVz+tlBa/CSCchaHlpZyXw==@kvack.org
X-Received: by 2002:a17:907:9447:b0:c2e:3307:b922 with SMTP id
 a640c23a62f3a-c31a9d569c2mr1372708566b.28.1791917010978; Tue, 13 Oct 2026
 11:43:30 -0700 (PDT)
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Oct 2026 11:43:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
X-Gm-Features: AclHuK984DPKXU2i8Zcxsi7Djqyw0wlLXBmXlyYPPwMugYSu0i2ce2acTA9g9MI
Message-ID: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
Subject: Improve page refcount scalability
To: David Hildenbrand <david@kernel.org>, Kiryl Shutsemau <kirill@shutemov.name>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 14F21C0002
X-Rspam-User: 
X-Stat-Signature: 5eorppnjxor9rsxfaskok4fg6tj9fqtf
X-HE-Tag: 1791917013-527731
X-HE-Meta: U2FsdGVkX19EuzuXVoYmP12BQ9bweN/4W51waUb6FH473QvWXFDXBwxUASltm7C0R2X0bk4AUC3Nk3L0RyzAFtN6dFKDH0nhrpNDAo+tvPoUFn5UuKtaDwazwvfRoHEoQYrXcqrzYIlZqaykZXUWKzs934e4fXabepRQ5il9WTXLMK05CU+QY1ikuYFl9xSK1x6q4s5NEZCzD4ejU9sbm1l+6xjqIQ8MGny+QoAcRh/m1jRbAdv/NaRcbb2jOip+E2HtTHZGj4+aPNRDffjAUj9XqioITu/jHwUKR/Kp8RtZoDcSkrfENMegSnLcGMxXoS77Inp6xjgXzUWpesasxHfGLIvuEh9itB0vgw/yODR0/YraBhmEsKQeJe12JB9pLAl6Hpfy1yRF7eOafpM+U2LTvFlnUU4vuQIyDI74JQvtEtme9jYJ18nWSVnrUVEWvcWiv3XdDGdzGReM2bf3CUDHYESB1pRl7NvO4Xmqt+bIbhtbXOKqU3WIRh8vDz2cSmMFbsjdK0mvyZ+kE5Tw2t3ZT6b9mbytUigShh/hKYt4tUcdhlLXT43XTmwZLjGnEGSktdQrWjn90aLbWNuzC5k0h1hcMr+JXw2z6P3SRU4tiv6WZWRyVtfrVrA71V0qhQcMTus3nDVvJwYJgCecCF59QSHUUbi25OvTpUgAmny6aiG4T23CdlGHI2UD/2K2b6t07Gao+orQw56T62rdqRb7aXSMrl3rf0Jcwuu27jZd2tRg9IJ7FIdzseARwXJPW+4hSlyRfGyTaixgaJWpMm+dQD/6PXFFohiQwKppOpTCNGbUf7e54BOGgOxtJTzWSr7j1RnTEk1MaOsMlIpD5s62uFwbUquB422fhxMT7JoQDIspRCudAJMR8ZswCF0j5ToHXIE4PB3nSD8kEfDSfwGOb6aBsl1k6NDXlbkWx4PoQ0Hda+GoYMsfQCusJ71InOG9moMX5J35vKMXjiV
 bBZ9rnAp
 B53F4J4mdFQrWxV66eHVEzHGexI7whBh5zNFmrY8IJRFOoi8Q9sroj8KRzZielhZEuxtKzUDGLVe8Fjvj8AIdzpE6eFJLfYPWAqo0Envdzrj0QHGO261+aFlH/g4FUrw+cObRjZvk+ybjfZvCnbYPdZH564liFmt03FuycxZvY8LftjxS25qITOXu9Tl72CK67c/chse1idLviytgfPOpxqJi7VzHvW1foI5ndP4rngcZq75Ah5UnjQWZ9T4QkF+qznhjrsm0dC7Lxhy9+MYRbAvBpI9SlLt8Asx4nEHd4fj4XmvH9UnBA/zoN+e7TaWvtbfM8cYu6p3Z8XDC6kH5GTOYxaLIwXGeeqnB3YM0x4EKVwB4qhazUv+j6e2hsJckJr1r/lXskJqFoRVRWNZQDI6ZQrFupf0pRzW+xBTGf9frweXNedFSNJQeT4KVzlHS2QmaXvyBYsHluvvevKKPaHNTnpDYtvxNkSpI2OQi+uANCUjt5W13eH7TIk+AKK8rPAjTuYuR89Giy4YAEpO0LAXKAtmGVNprHNsoSAGUSQiYVVz6hrC9/fHsGdMR1bo4jVHoCG+PruU2fsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So I've shown this series to people in private and talked about it at
the kernel maintainer summit, so some of you have seen earlier
versions of this already.

This was triggered by several attempts at improving on the scalability
of page ref handling over the last couple of years, particularly for
the common case of normal [p]read() system calls. Willy reported real
users having scalability issues in that area a couple of years ago in
a discussion about buffereed IO scalability limits:

  https://lore.kernel.org/all/Zds8T9O4AYAmdS9d@casper.infradead.org/

and I had a very rough first draft in that discussion:

  https://lore.kernel.org/all/CAHk-=wjOogaW0yLoUqQ0WfQ=etPA4cOFLy56VYCnHVU_DOMLrg@mail.gmail.com/

and it was broken but close enough to working that I kept using it
locally in my own use for a year and a half:

  https://lore.kernel.org/all/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/

until people pointed out just how broken it was.

Then Kiryl had a slightly fixed-up version of that approach almost
exactly a year ago:

  https://lore.kernel.org/all/20251017141536.577466-1-kirill@shutemov.name/

but that too had problems.

After that, Ilya Gladyshev stepped into the ring with a very different
approach to it, which is now up to version 6:

  https://lore.kernel.org/all/cover.1789239015.git.ilya.gladyshev@linux.dev/

and still has some outstanding known fundamental issues.

So for the kernel maintainer summit this year, where one of the big
topics was going to be LLM use in kernel development, I decided that
hey, I will try to actually *solve* this thing using an LLM to help
with the issues these things have had.

[ I also did another series for a problem with the assoc-array
library. I'll post that separately - that was a lot more pedestrian
"just clean up the code in order to fix a bug" kind of case - not at
all as interesting, but a fallback in case this more interesting
problem were to not pan out. ]

Anyway, the end result is in my kernel tree in the 'rcu-free-v3'
branch in my public git tree. My 'v2' never saw the light of day
because I kept cleaning it up, but an earlier version with some more
background is available under the name 'noref-filemap-read-with-llm'
and has an empty commit with more commentary and background at the
top. I didn't do that cover-letter for this v3 version, and it talks
about some issues that already got resolved (and others that I don't
think are actual real problems, but should be discussed).

The fairly short series of ten patches basically enhances folio lookup
by noticing when folios are hot, and setting a "delay relasing this
folio until after a RCU period", and then using that RCU delay it does
not just the folio lookup itself under RCU (which we've done forever),
but also the actual folio data accesses themselves under RCU. No
refcount taking needed for the fastpath where we can just read the
data from the folio entirely in an RCU-protected region when the user
copy doesn't cause page faults.

Unlike my original approach - because it now actually delays the
freeing of the underlying folio data - there's no need for any double
buffering, and a lot of the original limitations of my original patch
go away too. That improves performance quite a lot. And by "quite a
lot"  I mean "I see a 23x performance increase on my Ryzen
threadripper". Admittedly that is a very artificial case of reading
the same small part of a page over and over in a threaded loop on all
CPUs, so any real life impact will be much much less.

Anyway, I wasn't planning on posting the individual patches, I think
we all use git by now and probably find it easier than fetching
patches from the list. So it's all at

    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux rcu-free-v3

and the commit messages are a bit more verbose than I would have done
it myself without tool use, but maybe it's better that way.

The showcase number is in the "mm/filemap: read from the page cache
without folio references" commit:

                               reads/s     cycles    instructions
                                          per read     per read
   ...
  64 threads,           before   13.3 M  19857-19939   1094-1101
  64 threads,           after    304 M     735-736        959

ie the number of reads per second had plateaued at 13.3M due to the
cacheline contention on the folio reference count (and the cycles per
read had ballooned up to 20k).

And with that scalability limiter gone, it zooms up to 304M.

And again - that's not a real number in the sense that no real load
will ever see it, but the takeaway is that it basically scales
perfectly with no writes to shared cachelines. And honestly, the
patches don't look bad, and it's possible that other cases might find
use for this RCU-delayed page freeing.

Comments?

                Linus

