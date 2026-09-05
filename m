Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05534C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3426B0088; Sat,  5 Sep 2026 10:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7CBF6B008A; Sat,  5 Sep 2026 10:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B2A6B0092; Sat,  5 Sep 2026 10:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B22B36B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:26:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39C7E1C1F65
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:26:26 +0000 (UTC)
X-FDA: 85179933972.21.2B54C5B
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id 85ED8140004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:26:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3jyacagkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3jyacagkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788618384;
	b=28nh/Q1N9n1dt3jtuCS0vh/Zig4Svns9fXevA/i6MhqSA+UKupBhR5oM2t0GRLF0a4e+6A
	xTFt7uK6QOnvJlRVMWOi5dC9R2blXecaPA2Ays6SRgPVCXo2jNZGdLWmq61N8Brmo3fhNn
	/fYpZRlyjbl9qM8YNNuJmkURL2xXO5g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3jyacagkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3jyacagkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788618384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=1ETkXqycGRjohhEM+siMcRzRNo0ykM9QCfZj8kTd0Fk=;
	b=JqdwcmEczdXre+uiEreYfcrcEFrikxIHQH0DXWjY/M5jSe/xxH+1E5Q9MP6MRxsn7XRpu4
	EvfgE1lBC2P++Td0cogadEvM2tVdEKdDA07qVqN1uNgPM8fnWnll9rdg9ZbMwpZtGTFLmk
	NTE9j7sTa7BYCsIJ8ODBN0pvxMXmHQc=
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7f8931a803cso1842296a34.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788618383; x=1789223183;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1ETkXqycGRjohhEM+siMcRzRNo0ykM9QCfZj8kTd0Fk=;
        b=I/iHotqXWdS8kpMVqKl4FFEvjJ3pNGgKaXShLkOjn0OCf4JDAmgmEHJVnApwE1IUcl
         LUTVCqiVM/Jcl4dZXHakWYhdb5cJRQz0h1v/x5ZlY8cODFcS9G9+oD/GI9ARx1U7BFKb
         aIF8uLcKDOFoNsWiYnECTmwvXhEdnbyxVUXr9MwKjiiBU6zbg1KI/kfYUraYSv2yJ7IE
         dBE0gBwklI42x+HpDO2SdJEw7JAJJOpfYToxwe8KxcHOLA8+bYOObJIUSo4sA3hE7WlJ
         b9Ul3rWH5pUp4SKQnO5iY6jENTqcZtKNGL+5tk/UT7aaS1dn3SnTKEfZcs1o4gKR6Ifr
         lp0w==
X-Forwarded-Encrypted: i=1; AKwUvBxxfzVd03Kjm/8XqfpL5szC5mZT3KgP6AZIuUH4NnZxDvVTmD47/us/NR3jJ2QIeDy7d1e2t4ACMw==@kvack.org
X-Gm-Message-State: AFuF++ntRs1PEGSa0nhb02/UnwT68nnJMwJvqC6JjpnWdUb4Bn4taGE7
	3LSMWzLWgmoWsKDv8D7ZnS+h3lHc8nOHTFSAsLBqJZFtXDNvBECMY5rYNpU/IHxrpu3qEATiCVj
	1QLTPxW9zKDdg+mqW44LH9NPUmeD0qJ4QCs2hmstfErGcMxnaTeMU9OE1Q/E=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:617:b0:6b3:506e:b484 with SMTP id
 006d021491bc7-6b6fc9d0782mr8242414eaf.16.1788618383574; Sat, 05 Sep 2026
 07:26:23 -0700 (PDT)
Date: Sat, 05 Sep 2026 07:26:23 -0700
In-Reply-To: <5fdd4d960a6b47ab7cfa6ef0f44fb575fc45d1ca.1788611415.git.qiwenjie@xiaomi.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9c268f.a6639fcc.23b8b0.0003.GAE@google.com>
Subject: [syzbot ci] Re: f2fs: enable buffered RWF_DONTCACHE
From: syzbot ci <syzbot+ci2f6618cc34ef3809@syzkaller.appspotmail.com>
To: qwjhust@gmail.com, axboe@kernel.dk, baohua@kernel.org, chao@kernel.org, 
	hch@lst.de, jack@suse.cz, jaegeuk@kernel.org, linux-block@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, qiwenjie@xiaomi.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, tz2294@columbia.edu
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: g86rjgka6zabdj8668n6jpd5uwtxg9bw
X-Rspamd-Queue-Id: 85ED8140004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788618384-231692
X-HE-Meta: U2FsdGVkX195D4EQs+yPNPmfZfANr6hM20QnSNM6125UE3S9KkuMjtvVVqpGguZlX2ldD2SVcdD3/pkx65SCm9GtU6P/rgkeUhNMgI9eS7g37rTnJ6i2LMyE1WmgmU+JGmNsoQ/GRuCFN1xNRUmAFKHH/QPk1w72BpF0GDOXbf6sTKKGNpv38cdGmrggvruanPySuStwRwBphUYPgpeiu+869QH9xVst+d2ws56e8lvHQw9m0+RKdV4QjmLMKjA6g/p74Op44Mv/6kCooWVz5rt5eL8eICUvBgqGxIAaToCHMt2u27r1VMjyb+xyCE+bSPljHk+stAoRN18w9X5QviBQYyiTNIXHW+HjsbAHxs0g2BGGCwjenZqM6Jg3is+x3wh4SICF2BcJeWuEtFBlugvkqBZfZ3toHN1bug+Lq24GO6wVYQr5dDWToV/rt94F83Har+k5yFIOHHQYF4Hlh+2JowgQRsouDnLVjOR9ge+80E0BTVtEFIB9GeVl9CHJ/m/FujOKYEvEdqCT0knqZ8Seuf9/LSkYnJW22sOZEjVmwQoOUMgjvwQtorAreBObqa0NqK5+d+dNmSdv/g4epxxM+EDgbVHx9UoO5kuSXfzXkyNU0C28XpQFW3tKVY/G+Mtz6/6RRkZQJerPVe1TDJ/0sAufsKw1c/rywXkVF7NUYp/Neo1ge6UxHE9FTOU/0G6Qggl28eE7K6FuJ96rRo1maQOgj7JITc3V7q/3P4PqxGzlN5QZ4ykG303FqjlZnR+O5XBM+XSP5KZOgykDFle0r1JQlzx8yfsrYdqARS+25R/eTJrAfqlSjHz2gI+/g6wpAF4bCk7orfQ5/UeQkLbuyLU5DN5SEJZr2W/O8jCNIyUn1nT+nU+jWvboONpLLsZhpe0hITTcLEFEyldbJREIxDT4fCg+Nvq5vTEZtHPVjkjvYUXZo1fIyfu/21cILb0l3vixRq0eDDb5tVa
 F5XOCXHc
 2h8lcoNlcyY1PERfsi6KMPm9wVEI8B8tqfseJAo2YKBpNRZYeD97LQ3jJRKYdXzsqjoGe2weBsvhiTyb6ltoG4meAkjDq26kkb6aA+8Hvy0tb5np+RhCrAVHOnZiaBM72HFgBRUhqmXVDKx9QZJFG2kBcBs+hKTISBBCqNkYkucWhFZ2hob2Suy8YLsYwWvO3QaxiSW+XUG/9NSyDZAd7J3+n9fhbo9yL5HPdMe1OfauKA3zjirm0B0weqrr4ZNBTE2Lm1dh1TntAyI1xyHPtNX49N4wHEgi0hFNiaoS384tcXKpbvIAwvyXh4rJj6YAI+BdfGWjHAEWLcgrRj/kEAfULIXVQJEWII8ZJkIm31YYr+POXj1UGMimjxBIWJlXaQIjTd+7uSZNP6+nb+x5nXh7VrxTZtzuC3gZ9xxQg7R77ca+tHLH6dDgiR8YeLJo1kC/0+s+WEIg0iVV/O46dgeIT74bc54ELn8hUKJEs17X4+O0bYJU/HbiYe2XD6VEG6Q11QFW+Ips8Y0OOKlHYsifmeZHIOCfrENGgcci3V8q2/64ULpZDNzArxOURXio/AKT1sC5LqCY9PYFhQSRv+DZXv27bp+1C7HeXXJyGaG+JaG/Kn3e+ss9Wc4O2hM2gpssXUcTdA8O0zfcK/FE/wG4f4AI/siOB66uRGjhJER37u0FWWpkgxgmrqUAXjsf8zF8hJne9CQ7uNaQibL6tZQ+ZJb1GGIYk+kJpOBmjIE1jFBrAyt+/488OZZ9Np7/KDkrGj8xQJGOkl5YbexdAQiCe+Afg3BWWkQ/fHFJH6ON3Ed/2O+olFHYI/n297mOX8whT3ISFBBf+R/3d129B+fzfI755TtefGFoGNoV2f7rbFQ1ijc2FmtDQbdqGTugo59ISB6Swz26NYkEVB3L8aeiqUt/U0+qcXSUuSeslRLKrkds5vkJNxdB3bLs4ODTRsruYw3SoQT+P5lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the suggested fix patch on top of the following series:

[v4] f2fs: enable buffered RWF_DONTCACHE
https://lore.kernel.org/all/cover.1788438786.git.qiwenjie@xiaomi.com

Patch: https://ci.syzbot.org/jobs/279baf88-89a3-4cb8-93c2-4bd86aa5092e/patch
Testing results:
* [build 0] Build Patched: passed
* [build 0] Boot test: Patched: passed
* [build 0] Previous reproducers: passed
  - general protection fault in f2fs_write_begin (patched) - passed

Full report is available here:
https://ci.syzbot.org/session/7e05d54c-8b9e-4e22-a746-48153ea42a60

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

