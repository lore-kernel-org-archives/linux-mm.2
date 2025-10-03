Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28080CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 02:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8777B8E0007; Thu,  2 Oct 2025 22:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828638E0001; Thu,  2 Oct 2025 22:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7657A8E0007; Thu,  2 Oct 2025 22:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65E458E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:18:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED4AB160698
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:18:56 +0000 (UTC)
X-FDA: 83955195072.10.D991BD3
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id D8F1C4000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:18:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="YGB7/SZZ";
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759457935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h4rA1pWaVwccW2L65e2CKo7egOThwbjgA83Oqrmb/+Q=;
	b=QxYavhKIPFmXXFlR+04sIEexiWR/HlombwnFuuRddPzUwBk1COJNc+iBw/h9OryzSWRaP5
	b5CR7Tvds+2P09agcMIehJu0OSMtpivdG05GjGzVBaanSsDFjOBfkZSnbZHyqZWMrE3i4G
	+FzZsH0ldgBpXTgkTrCeRxOKSzH1/7I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759457935; a=rsa-sha256;
	cv=none;
	b=0+tbIsGJGWHtcn4vrh5CpKgsBI1uCDTnqRLWV6vvLV+5BZcEi17lPHnKULMpT6LF5owlYn
	7+eSMR9KgULT5LzZR3+NoYlm2Oxs8SfP2BfC7+9I08dG6qd/+MUtpOq55Uw4jhrX3t6g37
	CLqkk7B4XTc6drRqIIpV5bag5hPI04o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="YGB7/SZZ";
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b3e9d633b78so389231666b.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 19:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759457933; x=1760062733; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h4rA1pWaVwccW2L65e2CKo7egOThwbjgA83Oqrmb/+Q=;
        b=YGB7/SZZj15gph7yj9zrVzWOFkvFY+D5bGUO9y2lQTBwjgG/v4kW3iHgTS0enb+jgI
         SDTRCPRkcG+iDKhD2w0g1hPt6CCUMOpydQhc0hCvHlmVdrVX0h9Dfn/yZ9o3NXkr6CmA
         5Aa8otCpj+XCfcB7eYzbBLO/DyoRlV3lVorqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759457933; x=1760062733;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h4rA1pWaVwccW2L65e2CKo7egOThwbjgA83Oqrmb/+Q=;
        b=VMeLXuCQYVRtEnlfo3vI6LJpy/IVgKKkI9nQ0VFHIEmZaO8NK+2EsRGY6jYSDCzO23
         jP6NJdrymoBoSKy2FHrUK06z7SoDjmZQ+OtTA9KEJN/tWGy7tvtXkcZfwIiafO/yqNxJ
         S8vqbHlix3M1ar8+Ta3DLYOQHHx30yaJzkw42qJjp2u1z2VkDXJXY2qxTnrx37DQy08u
         i/tET36b+gNHwaAOIiKgo4yau4lekPnUrrLQl8D6JRzVwp/nIUWy6gJ0bz24545sPmDb
         SuW/OIDoWg3hC5MQtIUt0ZOluu1t+EjPkJ1ar1KEZSuXvpfwg5aYdB0QBhxvp2m63taS
         Rsdg==
X-Gm-Message-State: AOJu0YyFqXWKWXYgkeC3l9IjtT/EttuA2K/vgUivnrPcdd6+AXU1EFZq
	D4GFYT+KOXOFL1T2g1SsuE0F50jYYxGFq/Mh0q4NB1nKExxTCjo2vHW2dRiC2FjqsIACqrX2LII
	ohNrFrKM=
X-Gm-Gg: ASbGncviww0aNYXq2zygsSkWAcXyGlqMYwRkdIXbokZDSdBze4Qpr8RiEglkdUbtJk1
	wxGPhxf646buDyXlvaqzOPITAasWqu14ppqNmlZnpmLP1RBPh3jWzLHRX7IX5LFQRBetF6GQFh3
	xrb0l70LgJ6f0k8hrvQidbtMvwfV1gNLgVap2mjOMEa35JzPGmBX1WhjAj+bdc7R6hSCBDvrrmC
	inkMja7vQ7U8HsNiem8LXn0w/AYPNTxPizdEogti8S8VOGa5QuYXZkUNQ2IcUYJVlptsngK8PCm
	BbU47PuTkqWXr2MYE5S5sJ/Me6Z7xBsHwQqKzIBpdVcZBGCZbGQFUa7qrYfPxf2I0c7OnGcnhCw
	HorO00r4/R/e/2GPXFb54mFghDTkENkHj0wpsmebpL0B8tEV7WlU+DY6aDXU5bWkAhgSFAHFyNX
	tAQxKgGcKrvkvySNdhEqU/
X-Google-Smtp-Source: AGHT+IE/CAPsPXo4VdvMbt8GmLfeEhBOFMQ/1/FTJgGezY9plAvU3FQ56R7K0wcVY2kQ2ic2JL54Qg==
X-Received: by 2002:a17:907:c29:b0:b0e:83e7:f6e1 with SMTP id a640c23a62f3a-b49c3350340mr190112966b.15.1759457933130;
        Thu, 02 Oct 2025 19:18:53 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486a173b4csm318649366b.86.2025.10.02.19.18.52
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 19:18:52 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-636535e4b1aso4797393a12.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 19:18:52 -0700 (PDT)
X-Received: by 2002:a17:907:d48c:b0:b3d:6645:a6f1 with SMTP id
 a640c23a62f3a-b485bdda370mr667211966b.29.1759457931978; Thu, 02 Oct 2025
 19:18:51 -0700 (PDT)
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Oct 2025 19:18:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
X-Gm-Features: AS18NWB_duJVs-WmGN5_62t_38hzoDBa_oL2O0OM3TDXCOqiziHVd3yxMsb9DNs
Message-ID: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
Subject: Optimizing small reads
To: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>
Content-Type: multipart/mixed; boundary="00000000000008ad14064037b90c"
X-Rspamd-Queue-Id: D8F1C4000E
X-Stat-Signature: typua47bqijhuq79jfffyt1315guaf5u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759457934-56364
X-HE-Meta: U2FsdGVkX18NhGQOJLgk16hdBWTWl3ULe3M4m/zEfDnRedtiVYhHLqhz3rYBz/qe63lfudr4QD0P/fD1rcLgNcB8wbOdTtBcsgYsG84yaMjC/n4eGJcFl36yFJV1u4k1zIN1k1LlgmgQ7z7/3kPM9w/yrS/2sNE/IDtC0U79OA88MmuSniZ+zonNEAB9Hs5WJELTnOF9+bfxSqttYfJs4xw0wJ8dsSOw7lsaoW3Y91gOlDK0NN3LbKB0Mqx934RcS5r4W6YqsHMYKCg7I2PK2rAZ02Xm61dteJTdi+nr+tCOsGGYZ1fQ35zB0cIy6+DvvB8DPR2C0ZPc3kI1JZsSLm07gCaOwUw1PGuvUjudahsPCcBHcY2UXZM3JAm4MOVFcSDY78UoaYwTV62m+yGMznr2XHvw8xJezi0oNerrLb6vBfixjbnqj19E6x3fDxR7JbiXwgH62OQAFWM0lmTUpozSCEAVPSHM9yB5tkfnRzIxAQ/gFBriO1Zo3Y53z3FnOf6Ox1E8KaXgekInh2DFbKaN7Q7vN8TqcglXl6ln12TfSZ7a+XSQdjge5k3jfn6YdTHr7O7a+GcoVkQVvM+G/rOphFebgesBNVS3CYGpXP3slbPj9vkfMoR1ztuenGxz2d/rBjz1ERjbRcK8Jdjt542kTlJ8p3AkodOJ/qpEfx4abIvxoU+pScL+2boaYrjyk8W9SWJvz3GpsM3L5gmpFd4dwXKOghRFJSWvI7vZhiKFgNCTGcGmxaJVvG3cub9KOO9sfc7nJrE6zt+CAG1gTqkXKgCa4rpTBlrRTNAq9eDofhSIfvut5iP9sCaKvWIZ42/Ih8bLzpQtZhSq5NMSXreLInO+LRiI8skEh3M6iKWnaGNqUv7hzEtZSf+M/IxtAAOh05mzOgPuFL3kaTbxd5kTfJ/kpNRk9EUI/9MumnF0/0Uvv/B5kTZQjSypgZkjmmtNlBSWRuTCoPKxrRH
 oJjC1dns
 ES5WsChDqNnpGmSCSxz2VO/knOkEf7az5ZQkLQ9SqE/UQaajRxW6Ehimlek6EkPrDOeTG5+BMtNA7zprNgSPIrqYVrfwu6IBY1HakC4IPrImNCXClOxYcWQlnxCGYi1MXt8AC5F0gUTlpRMY+6EjM3DstUWIg527viHTWxvkqLBjHEssnN4aUTM46W6ejxd6IWEEg8AUBSTl+4rE/jMJhoz7xfdbuoR159Q9RDmUiU7Z+JT0VGi3rGfVFtyLAUbv4vSykPgti1F8wZj3hfvS6U1T9Izrf5isxPssnybsMS67jUKVDPblNE/c2q3lxwjc4rZgzabMi+rnpB1MBnzmEIv70nZ9gY0hQj0lMooA3yHj1akZCJXZJ7xZCOLgVk60zRFgu10UHKAfBjXzag6+Swu0E+y5l+tuA/rKUjGZMfixBJXMUSOcT80ieupEvd3X5KcAZC87DKyeyKdRkVMv+I/dD7PNDg++muYy85pBUz39ewHWFirc5TzQvcHFBb6+CxvmC14yYQ83JQGbj2P1bVsZQeVTHe1b+QU+cx2oHbeAPJowBpTsSJg89c1Jon2KL3qBFxobHuqpTyTwFwBcys9cYM0jkqfM4SDcheXkhKOHkC9vvuzslRFEMWkcFN4Trqf5sWVZty9Bq8xzN6GXXPTYLKLyDmiQIY0BhfJEGqZPZdOn/TGhMULrjmd3pdJJven2PUBEArMVPL+SfKI5AwMY7RDWjr632QZi4m+BNQbiOCy8xTjj/SXXwKLKcJDXZ8C2LhrLoxiZIt9k619Vxhtbmqd4LI8jKzS2cyw0p2b3q92AAZNCBSuvlX5tB8NdRvqeZ7tNDvGi8IPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000008ad14064037b90c
Content-Type: text/plain; charset="UTF-8"

Willy,
 I've literally been running this patch in my tree now for 18 months,
and have never seen any issues. However back when I posted it
originally, Luis reported that it caused failures on xfstest

  * generic/095
  * generic/741

although I still have no idea how that could happen. I've looked at
the patch occasionally over the months I've been carrying it, trying
to figure out how it could possibly matter, and have never figured it
out.

I'm not planning on moving it to my mainline tree now either, but I
decided I might as well at least repost it to see if somebody else has
any interest or comments on it. The impetus for this patch is
obviously from your posting back in early 2024 about some real user
that did a lot of really small reads. It still sounds like a very odd
load to me, but apparently there was a good real-life reason for it.

I still think this patch actually looks quite nice - which surprised
me when I wrote it originally. I started out writing it as a "let's
see what this hacky thing results in", but it didn't turn out very
hacky at all.

And it looks ridiculously good on some strange small-read benchmarks,
although I say that purely from memory, since I've long since lost the
code that tested this. Now it's been "tested" purely by virtue of
basically being something I've been running on my own machine for a
long time.

Anyway, feel free to ignore it. I can keep carrying this patch in my
local tree forever or until it actually causes more conflicts than I
feel comfortable keeping around. But so far in the last 18+ months it
has never caused any real pain (I have my own tree that contains a few
random patches for other reasons anyway, although lately this has
actually been the biggest of that little lot).

             Linus

--00000000000008ad14064037b90c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-mm-filemap-do-small-reads-in-RCU-mode-read-without-r.patch"
Content-Disposition: attachment; 
	filename="0001-mm-filemap-do-small-reads-in-RCU-mode-read-without-r.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mga7r3kg0>
X-Attachment-Id: f_mga7r3kg0

RnJvbSBiZjExZDY1N2UxZjlhMDEwYWUwMjUzZmViMjdjMjQ3MWI4OTdkMjVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IE1vbiwgMjYgRmViIDIwMjQgMTU6MTg6NDQgLTA4MDAKU3ViamVjdDog
W1BBVENIXSBtbS9maWxlbWFwOiBkbyBzbWFsbCByZWFkcyBpbiBSQ1UtbW9kZSByZWFkIHdpdGhv
dXQgcmVmY291bnRzCgpIYWNrZXR5IGhhY2sgaGFjayBjb25jZXB0IGZyb20gcmVwb3J0IGJ5IFdp
bGx5LgoKTW9tbXksIEknbSBzY2FyZWQuCgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9h
bGwvWmR1dG8zMExVRXFJSGc0aEBjYXNwZXIuaW5mcmFkZWFkLm9yZy8KTm90LXlldC1zaWduZWQt
b2ZmLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+Ci0t
LQogbW0vZmlsZW1hcC5jIHwgMTM3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEyNyBpbnNlcnRpb25zKCspLCAxMCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tbS9maWxlbWFwLmMgYi9tbS9maWxlbWFwLmMKaW5k
ZXggYTUyZGQzOGQyYjRhLi5mMTViYzExMDg1ODUgMTAwNjQ0Ci0tLSBhL21tL2ZpbGVtYXAuYwor
KysgYi9tbS9maWxlbWFwLmMKQEAgLTI2NzcsNiArMjY3Nyw5NiBAQCBzdGF0aWMgdm9pZCBmaWxl
bWFwX2VuZF9kcm9wYmVoaW5kX3JlYWQoc3RydWN0IGZvbGlvICpmb2xpbykKIAl9CiB9CiAKKy8q
CisgKiBJIGNhbid0IGJlIGJvdGhlcmVkIHRvIGNhcmUgYWJvdXQgSElHSE1FTSBmb3IgdGhlIGZh
c3QgcmVhZCBjYXNlCisgKi8KKyNpZmRlZiBDT05GSUdfSElHSE1FTQorI2RlZmluZSBmaWxlbWFw
X2Zhc3RfcmVhZChtYXBwaW5nLCBwb3MsIGJ1ZmZlciwgc2l6ZSkgMAorI2Vsc2UKKworLyoKKyAq
IENhbGxlZCB1bmRlciBSQ1Ugd2l0aCBzaXplIGxpbWl0ZWQgdG8gdGhlIGZpbGUgc2l6ZSBhbmQg
b25lIHBhZ2UKKyAqLworc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGZpbGVtYXBfZm9saW9f
Y29weV9yY3Uoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsIGxvZmZfdCBwb3MsIGNoYXIg
KmJ1ZmZlciwgc2l6ZV90IHNpemUpCit7CisJc3RydWN0IGlub2RlICppbm9kZTsKKwlsb2ZmX3Qg
ZmlsZV9zaXplOworCVhBX1NUQVRFKHhhcywgJm1hcHBpbmctPmlfcGFnZXMsIHBvcyA+PiBQQUdF
X1NISUZUKTsKKwlzdHJ1Y3QgZm9saW8gKmZvbGlvOworCXNpemVfdCBvZmZzZXQ7CisKKwkvKiBM
aW1pdCBpdCB0byB0aGUgZmlsZSBzaXplICovCisJaW5vZGUgPSBtYXBwaW5nLT5ob3N0OworCWZp
bGVfc2l6ZSA9IGlfc2l6ZV9yZWFkKGlub2RlKTsKKwlpZiAodW5saWtlbHkocG9zID49IGZpbGVf
c2l6ZSkpCisJCXJldHVybiAwOworCWlmIChzaXplID4gZmlsZV9zaXplIC0gcG9zKQorCQlzaXpl
ID0gZmlsZV9zaXplIC0gcG9zOworCisJeGFzX3Jlc2V0KCZ4YXMpOworCWZvbGlvID0geGFzX2xv
YWQoJnhhcyk7CisJaWYgKHhhc19yZXRyeSgmeGFzLCBmb2xpbykpCisJCXJldHVybiAwOworCisJ
aWYgKCFmb2xpbyB8fCB4YV9pc192YWx1ZShmb2xpbykpCisJCXJldHVybiAwOworCisJaWYgKCFm
b2xpb190ZXN0X3VwdG9kYXRlKGZvbGlvKSkKKwkJcmV0dXJuIDA7CisKKwkvKiBObyBmYXN0LWNh
c2UgaWYgd2UgYXJlIHN1cHBvc2VkIHRvIHN0YXJ0IHJlYWRhaGVhZCAqLworCWlmIChmb2xpb190
ZXN0X3JlYWRhaGVhZChmb2xpbykpCisJCXJldHVybiAwOworCS8qIC4uIG9yIG1hcmsgaXQgYWNj
ZXNzZWQgKi8KKwlpZiAoIWZvbGlvX3Rlc3RfcmVmZXJlbmNlZChmb2xpbykpCisJCXJldHVybiAw
OworCisJLyogRG8gdGhlIGRhdGEgY29weSAqLworCW9mZnNldCA9IHBvcyAmIChmb2xpb19zaXpl
KGZvbGlvKSAtIDEpOworCW1lbWNweShidWZmZXIsIGZvbGlvX2FkZHJlc3MoZm9saW8pICsgb2Zm
c2V0LCBzaXplKTsKKworCS8qCisJICogQWZ0ZXIgd2UndmUgY29waWVkIHRoZSBkYXRhIGZyb20g
dGhlIGZvbGlvLAorCSAqIGRvIHNvbWUgZmluYWwgc2FuaXR5IGNoZWNrcy4KKwkgKi8KKwlzbXBf
cm1iKCk7CisKKwlpZiAodW5saWtlbHkoZm9saW8gIT0geGFzX3JlbG9hZCgmeGFzKSkpCisJCXJl
dHVybiAwOworCisJLyoKKwkgKiBUaGlzIGlzIGp1c3QgYSBoZXVyaXN0aWM6IHNvbWVib2R5IGNv
dWxkIHN0aWxsIHRydW5jYXRlIGFuZCB0aGVuCisJICogd3JpdGUgdG8gZXh0ZW5kIGl0IHRvIHRo
ZSBzYW1lIHNpemUuLgorCSAqLworCWlmIChmaWxlX3NpemUgIT0gaW5vZGUtPmlfc2l6ZSkKKwkJ
cmV0dXJuIDA7CisKKwlyZXR1cm4gc2l6ZTsKK30KKworLyoKKyAqIElmZiB3ZSBjYW4gY29tcGxl
dGUgdGhlIHJlYWQgY29tcGxldGVseSBpbiBvbmUgYXRvbWljIGdvIHVuZGVyIFJDVSwKKyAqIGRv
IHNvIGhlcmUuIE90aGVyd2lzZSByZXR1cm4gMCAobm8gcGFydGlhbCByZWFkcywgcGxlYXNlIC0g
dGhpcyBpcworICogcHVyZWx5IGZvciB0aGUgdHJpdmlhbCBmYXN0IGNhc2UpLgorICovCitzdGF0
aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgZmlsZW1hcF9mYXN0X3JlYWQoc3RydWN0IGFkZHJlc3Nf
c3BhY2UgKm1hcHBpbmcsIGxvZmZfdCBwb3MsIGNoYXIgKmJ1ZmZlciwgc2l6ZV90IHNpemUpCit7
CisJdW5zaWduZWQgbG9uZyBwZ29mZjsKKworCS8qIERvbid0IGV2ZW4gdHJ5IGZvciBwYWdlLWNy
b3NzZXJzICovCisJcGdvZmYgPSBwb3MgJiB+UEFHRV9NQVNLOworCWlmIChwZ29mZiArIHNpemUg
PiBQQUdFX1NJWkUpCisJCXJldHVybiAwOworCisJLyogTGV0J3Mgc2VlIGlmIHdlIGNhbiBqdXN0
IGRvIHRoZSByZWFkIHVuZGVyIFJDVSAqLworCXJjdV9yZWFkX2xvY2soKTsKKwlzaXplID0gZmls
ZW1hcF9mb2xpb19jb3B5X3JjdShtYXBwaW5nLCBwb3MsIGJ1ZmZlciwgc2l6ZSk7CisJcmN1X3Jl
YWRfdW5sb2NrKCk7CisKKwlyZXR1cm4gc2l6ZTsKK30KKyNlbmRpZiAvKiAhSElHSE1FTSAqLwor
CiAvKioKICAqIGZpbGVtYXBfcmVhZCAtIFJlYWQgZGF0YSBmcm9tIHRoZSBwYWdlIGNhY2hlLgog
ICogQGlvY2I6IFRoZSBpb2NiIHRvIHJlYWQuCkBAIC0yNjk3LDcgKzI3ODcsMTAgQEAgc3NpemVf
dCBmaWxlbWFwX3JlYWQoc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIs
CiAJc3RydWN0IGZpbGVfcmFfc3RhdGUgKnJhID0gJmZpbHAtPmZfcmE7CiAJc3RydWN0IGFkZHJl
c3Nfc3BhY2UgKm1hcHBpbmcgPSBmaWxwLT5mX21hcHBpbmc7CiAJc3RydWN0IGlub2RlICppbm9k
ZSA9IG1hcHBpbmctPmhvc3Q7Ci0Jc3RydWN0IGZvbGlvX2JhdGNoIGZiYXRjaDsKKwl1bmlvbiB7
CisJCXN0cnVjdCBmb2xpb19iYXRjaCBmYmF0Y2g7CisJCV9fREVDTEFSRV9GTEVYX0FSUkFZKGNo
YXIsIGJ1ZmZlcik7CisJfSBhcmVhIF9fdW5pbml0aWFsaXplZDsKIAlpbnQgaSwgZXJyb3IgPSAw
OwogCWJvb2wgd3JpdGFibHlfbWFwcGVkOwogCWxvZmZfdCBpc2l6ZSwgZW5kX29mZnNldDsKQEAg
LTI3MTEsNyArMjgwNCwzMSBAQCBzc2l6ZV90IGZpbGVtYXBfcmVhZChzdHJ1Y3Qga2lvY2IgKmlv
Y2IsIHN0cnVjdCBpb3ZfaXRlciAqaXRlciwKIAkJcmV0dXJuIDA7CiAKIAlpb3ZfaXRlcl90cnVu
Y2F0ZShpdGVyLCBpbm9kZS0+aV9zYi0+c19tYXhieXRlcyAtIGlvY2ItPmtpX3Bvcyk7Ci0JZm9s
aW9fYmF0Y2hfaW5pdCgmZmJhdGNoKTsKKworCS8qCisJICogVHJ5IGEgcXVpY2sgbG9ja2xlc3Mg
cmVhZCBpbnRvIHRoZSAnYXJlYScgdW5pb24uIE5vdGUgdGhhdAorCSAqIHRoaXMgdW5pb24gaXMg
aW50ZW50aW9uYWxseSBtYXJrZWQgIl9fdW5pbml0aWFsaXplZCIsIGJlY2F1c2UKKwkgKiBhbnkg
Y29tcGlsZXIgaW5pdGlhbGl6YXRpb24gd291bGQgYmUgcG9pbnRsZXNzIHNpbmNlIHRoaXMKKwkg
KiBjYW4gZmlsbCBpdCB3aWxsIGdhcmJhZ2UuCisJICovCisJaWYgKGlvdl9pdGVyX2NvdW50KGl0
ZXIpIDw9IHNpemVvZihhcmVhKSkgeworCQl1bnNpZ25lZCBsb25nIGNvdW50ID0gaW92X2l0ZXJf
Y291bnQoaXRlcik7CisKKwkJY291bnQgPSBmaWxlbWFwX2Zhc3RfcmVhZChtYXBwaW5nLCBpb2Ni
LT5raV9wb3MsIGFyZWEuYnVmZmVyLCBjb3VudCk7CisJCWlmIChjb3VudCkgeworCQkJc2l6ZV90
IGNvcGllZCA9IGNvcHlfdG9faXRlcihhcmVhLmJ1ZmZlciwgY291bnQsIGl0ZXIpOworCQkJaWYg
KHVubGlrZWx5KCFjb3BpZWQpKQorCQkJCXJldHVybiBhbHJlYWR5X3JlYWQgPyBhbHJlYWR5X3Jl
YWQgOiAtRUZBVUxUOworCQkJcmEtPnByZXZfcG9zID0gaW9jYi0+a2lfcG9zICs9IGNvcGllZDsK
KwkJCWZpbGVfYWNjZXNzZWQoZmlscCk7CisJCQlyZXR1cm4gY29waWVkICsgYWxyZWFkeV9yZWFk
OworCQl9CisJfQorCisJLyoKKwkgKiBUaGlzIGFjdHVhbGx5IHByb3Blcmx5IGluaXRpYWxpemVz
IHRoZSBmYmF0Y2ggZm9yIHRoZSBzbG93IGNhc2UKKwkgKi8KKwlmb2xpb19iYXRjaF9pbml0KCZh
cmVhLmZiYXRjaCk7CiAKIAlkbyB7CiAJCWNvbmRfcmVzY2hlZCgpOwpAQCAtMjcyNyw3ICsyODQ0
LDcgQEAgc3NpemVfdCBmaWxlbWFwX3JlYWQoc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3QgaW92
X2l0ZXIgKml0ZXIsCiAJCWlmICh1bmxpa2VseShpb2NiLT5raV9wb3MgPj0gaV9zaXplX3JlYWQo
aW5vZGUpKSkKIAkJCWJyZWFrOwogCi0JCWVycm9yID0gZmlsZW1hcF9nZXRfcGFnZXMoaW9jYiwg
aXRlci0+Y291bnQsICZmYmF0Y2gsIGZhbHNlKTsKKwkJZXJyb3IgPSBmaWxlbWFwX2dldF9wYWdl
cyhpb2NiLCBpdGVyLT5jb3VudCwgJmFyZWEuZmJhdGNoLCBmYWxzZSk7CiAJCWlmIChlcnJvciA8
IDApCiAJCQlicmVhazsKIApAQCAtMjc1NSwxMSArMjg3MiwxMSBAQCBzc2l6ZV90IGZpbGVtYXBf
cmVhZChzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqaXRlciwKIAkJICogbWFy
ayBpdCBhcyBhY2Nlc3NlZCB0aGUgZmlyc3QgdGltZS4KIAkJICovCiAJCWlmICghcG9zX3NhbWVf
Zm9saW8oaW9jYi0+a2lfcG9zLCBsYXN0X3BvcyAtIDEsCi0JCQkJICAgIGZiYXRjaC5mb2xpb3Nb
MF0pKQotCQkJZm9saW9fbWFya19hY2Nlc3NlZChmYmF0Y2guZm9saW9zWzBdKTsKKwkJCQkgICAg
YXJlYS5mYmF0Y2guZm9saW9zWzBdKSkKKwkJCWZvbGlvX21hcmtfYWNjZXNzZWQoYXJlYS5mYmF0
Y2guZm9saW9zWzBdKTsKIAotCQlmb3IgKGkgPSAwOyBpIDwgZm9saW9fYmF0Y2hfY291bnQoJmZi
YXRjaCk7IGkrKykgewotCQkJc3RydWN0IGZvbGlvICpmb2xpbyA9IGZiYXRjaC5mb2xpb3NbaV07
CisJCWZvciAoaSA9IDA7IGkgPCBmb2xpb19iYXRjaF9jb3VudCgmYXJlYS5mYmF0Y2gpOyBpKysp
IHsKKwkJCXN0cnVjdCBmb2xpbyAqZm9saW8gPSBhcmVhLmZiYXRjaC5mb2xpb3NbaV07CiAJCQlz
aXplX3QgZnNpemUgPSBmb2xpb19zaXplKGZvbGlvKTsKIAkJCXNpemVfdCBvZmZzZXQgPSBpb2Ni
LT5raV9wb3MgJiAoZnNpemUgLSAxKTsKIAkJCXNpemVfdCBieXRlcyA9IG1pbl90KGxvZmZfdCwg
ZW5kX29mZnNldCAtIGlvY2ItPmtpX3BvcywKQEAgLTI3OTAsMTMgKzI5MDcsMTMgQEAgc3NpemVf
dCBmaWxlbWFwX3JlYWQoc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIs
CiAJCQl9CiAJCX0KIHB1dF9mb2xpb3M6Ci0JCWZvciAoaSA9IDA7IGkgPCBmb2xpb19iYXRjaF9j
b3VudCgmZmJhdGNoKTsgaSsrKSB7Ci0JCQlzdHJ1Y3QgZm9saW8gKmZvbGlvID0gZmJhdGNoLmZv
bGlvc1tpXTsKKwkJZm9yIChpID0gMDsgaSA8IGZvbGlvX2JhdGNoX2NvdW50KCZhcmVhLmZiYXRj
aCk7IGkrKykgeworCQkJc3RydWN0IGZvbGlvICpmb2xpbyA9IGFyZWEuZmJhdGNoLmZvbGlvc1tp
XTsKIAogCQkJZmlsZW1hcF9lbmRfZHJvcGJlaGluZF9yZWFkKGZvbGlvKTsKIAkJCWZvbGlvX3B1
dChmb2xpbyk7CiAJCX0KLQkJZm9saW9fYmF0Y2hfaW5pdCgmZmJhdGNoKTsKKwkJZm9saW9fYmF0
Y2hfaW5pdCgmYXJlYS5mYmF0Y2gpOwogCX0gd2hpbGUgKGlvdl9pdGVyX2NvdW50KGl0ZXIpICYm
IGlvY2ItPmtpX3BvcyA8IGlzaXplICYmICFlcnJvcik7CiAKIAlmaWxlX2FjY2Vzc2VkKGZpbHAp
OwotLSAKMi41MS4wLjQxOS5nZjcwMzYyZGRmNAoK
--00000000000008ad14064037b90c--

