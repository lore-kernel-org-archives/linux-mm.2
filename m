Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27746CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 18:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442696B0007; Sat, 23 Aug 2025 14:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A586B0008; Sat, 23 Aug 2025 14:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357C06B000A; Sat, 23 Aug 2025 14:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 215536B0007
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 14:18:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 898241DDE01
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 18:18:06 +0000 (UTC)
X-FDA: 83808831372.22.9777577
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6A2940008
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 18:18:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 32wWqaAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=32wWqaAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755973084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=AvrGI5lO0JIHO5yIhJ25utXK+qOPL1vuXZ2aqhdEn0Q=;
	b=PyaVXUXWSCZqdBkOUHPcPyVxA5PzUGLQ/HhIMlwIbv0R6oHvWC9/fLMq3w/Dhouw6iG9ns
	bCDaIt6P3lRM4IDf1TqawXhwVLERh9PdlEHzMQ/eIjemTbXU3rWwUaWOFmM0jD0XRIIlN3
	31G+w8M1b+PrFnRnB7H4aYUk2TT33Wg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 32wWqaAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=32wWqaAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755973084; a=rsa-sha256;
	cv=none;
	b=DZ9jcbmLrYw7Mpo9Q40X2FIorOLuG4ExBJ2g1e4igyz+lkK+rftYPbtckIef4TQ6hYmbzm
	LaUEwJGMqLXALv12GcSRDqxtNlu6OjIEV0A3aZLbMs9+AJdEcPnwCfkAMm1PzwRkn8hrMu
	y4+U7Bc/EGWw0Az3Tos85SgWyIdENgU=
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88432d88f64so724055239f.1
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 11:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755973084; x=1756577884;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AvrGI5lO0JIHO5yIhJ25utXK+qOPL1vuXZ2aqhdEn0Q=;
        b=dL9F2q1jDR6JbKk0Bh6+k9xNxpSAmtLt4HI66uIB1Khql30ZstX25/SXgCQTqPbllk
         33q2g6JVgUaHpKKa3ip347gJLvkTzVRE439XyMJ38NOVrfw/hrUuqbsBAyabKAfGgcHS
         6oBiqsNBPBwDcot/LW9ASDschCAfpkhZUM7roYrtFZhAAnu/CWOOSpiHIrGscMkXBTbe
         ot1qfQ+cU34lF6Ie1sjdaCHyYGZsbbHajBCVLBQOKlLSKq9kexQGwl+P5jLmwSgA6dKx
         idoR91JJdzO8xn2bncFo5uyNdapM+8Hub927L80tiZSkxjJTrcgtjyt8FblpjqtiUcDx
         z+jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOCOxOAEWosGO/tb2sHYfmBwPSxvXFb8TTvvK9u6fFQRmff/zTKMHytxdZK5QaUlBu3nLzes/LuA==@kvack.org
X-Gm-Message-State: AOJu0YzI6oE8CS8ubgUKR0t40onu8gkcaY5C/D/YoAOHqyWGgoBEJ0/V
	PKlfYe/wtfZ3U9pwkYdYGTjYxwMRzxrERXi1Jb6qE7/Obn6I+4HOP3v5G1NRVtLpv76BgshdfhU
	ot76hL+dMEay87ykvFRpgalg5v/WGZMvBASwW6UnJjk2u7Lko94dubO3nDVk=
X-Google-Smtp-Source: AGHT+IFVwc7hI9obtt58xxmeGlSqaexaNaLEJlVyz/6DHUm5aTWR3nDdjKIhdaWkxLxfEoeiFurMgXW4Mo4jsyqrFY4PSYwGOcQk
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184f:b0:3eb:5862:7cea with SMTP id
 e9e14a558f8ab-3eb586280a4mr20689245ab.15.1755973083974; Sat, 23 Aug 2025
 11:18:03 -0700 (PDT)
Date: Sat, 23 Aug 2025 11:18:03 -0700
In-Reply-To: <20250823100703.0a0239d204ca2487363d2adf@linux-foundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68aa05db.050a0220.37038e.0069.GAE@google.com>
Subject: Re: [syzbot] [mm?] kernel BUG in page_table_check_set
From: syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com>
To: ajd@linux.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, ritesh.list@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D6A2940008
X-Rspam-User: 
X-Stat-Signature: dk96qtuqxo659wwq3q8aguqss6abjsj5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755973084-510448
X-HE-Meta: U2FsdGVkX19lFUF/X+L43TUnsX5G6AI7B5xsDHwJ9ORqFJaxRupcee7DgHqDmGOQmspLu/8rBuvWE7Ln2adDzU6qyLCCDC3OY4liIMkWyLW03+6l2kw2lBn4gKCzZp/I+GVt4YViOdCb2vMOCXO+Jwdp1adSCESxu+HS0SZdht6QluqOfR8gkHSVnevZpJa7kykamg1xA1sWqC2lK6BvDi7EeXi/Tqx+6VQo9fvMOjK7QykKilzT7cHB3enxJ8sKjat1S8yp9pBlEXORVleTi45xhyY1O37G8aFGx/F8SU+c3BqXze5AYTEE40cMKNhd4r2jPH5VBklYTJPSsAMRdddgudMg0YYm8guukv5gngp1nMDavET6H9P+twT+hWgn2APoZO+WHKblBrzmIvH1aGWQHmnUwsmm7uREEeh+LhaepgclpF9roigEOfpmbaNizdkn3wdzXfc3fkcdHLiuvRM9aGxtmRmH5dGCA308R98YmAFChtxXzKJS9h2PkSozyUAYXNz/NHNP9+xeD1x1v2ffXJc+RvU1vaX1FY4qD2LI/ADlLFwPyur5VY+vrpohSfxA8Y5wl8a8PnOha6NprUc9N4T1udN4Rz+VN0G1zIwCUQkTVgUgKMD8he9SjxqeCc/C7Ks3kV/QJ5yTOr5QzmkjEdtTtvwvPkbBYIVxipQ8pTYnwIjRO7IENylPYBEBVXHMkRlxQE+5i2Q9GmJPHrURpd4uuPhvXRK5hERlEcLKHQlqvWpZF+BeHU53vSH5j+7s7JCIqBAWr8wOkgwcT1MiW9myha+DmAD+Oewohkhp3O3WHtbH3fizrPJACreGK0aE61f4hTj3vJFHjycYHQ1o8RN9msuRZFUQeUygw8UhMSEZqeitM3+X7gmuLQxGIOO8waoENizEYg730aoPRpL3kCiH0/S91TnaukOtrLzO2Uhpb0jiJ+yymi/k0Y/rMYr/S5G7S4SqKnUWLP6
 n6Z6CowU
 tqw93g7v+WyVrTspOoJma+tHgqAblvRG2xrWVoT+IB5v7/qaIOKf144bW/ecUXRD1XTvxr7EEM3p6TDMxiYIgINp+edKjpwGQMIm9N/ulUh1hrKfeqopAdElc7vLm1XSTknr2Da5MJMarg0H8MiAG/7H8/iR6FInEXwzzodTHcGpMdtbEK8a97BCBGlmreCAlkdaAiywxrGjdLMp7GYEmSDyABYo186xv5DCy1ylyKfZslPeq80bR0BEvtl1SaHragwRN+oOzPZsF6MwWItJi0xj2OwWFGmemDACHoC1McCUWMGgsUTEs1B7ufmTGgaw1JxDQIoW3kOsmqMoDbRp2ZkGdkYY8QwdyZkGRHEBfpUt6ea1pXeKh/c9iCOcaUAH4WDpttCwB2+HZnPmlyACFnDudUTLUshEJJGDaFZmF1sRTM7DWu+B8Hkla4TblZHPRu/6+EXupRHqgCj6WJgxuaZPUkLMfTkHIWs9ZjPdZ4lVwNxLkXoBRRB4Vc/0v6LVwgLCNoIrr7ZpMd16AdlPRGV9e7ywFxqSSeWu2hSXvZne/r5ezmGL79l0Yu9ehpVbV4ka5vGBNa76gcW+uBu1PA62NJEWztn2C0dK5/hCp8b+3ot/r6JLrdVZQ23QIDBx6TpH8p5rgFmxyoSfOe+KsisqALGllt9KJR2eIDTrAmlhAD5Dj6gRSTkGlbg4VyUB99B6ppuRa3aaOfGdsIKlcr1r6hCpIj20+B6g9oJcfN+Kj725lnlL/FQvr549Co79gSYFI2Dt+nuq6hGIj6hZJejKSrEYe9+ZxSnotUeOE597pPOR8uvvHiIF2jaaOAddGP4dCZ0jt0/IkabSGG+lGyoRjUAlO1nD9WdX4w+93I55NyqJYkJUeBmm+tek+Hq/JcFr7VgGZAkJMGxocQUajqPtVjG7Vm8o1FP6DM/Dz7I6mR+UqBCGjJvRXvAiO1GsZVqGVYl3utv2wS9tr/vIMy1MONMi/
 lQQY+q29
 3LDTpqiqeE+m8zdyhcQp8cecjqmhZC660PsN90r5xfYJtqXNLAG8H9LOrfat8zp6YAeITKdSb38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com
Tested-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com

Tested on:

commit:         c17b750b Linux 6.17-rc2
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1058a7bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=34aa432f9050e15d
dashboard link: https://syzkaller.appspot.com/bug?extid=49a796ed2c9709652f1e
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

