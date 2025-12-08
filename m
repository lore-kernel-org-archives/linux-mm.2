Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64AB4D3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 08:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D061C6B0007; Mon,  8 Dec 2025 03:51:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB69F6B0008; Mon,  8 Dec 2025 03:51:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCDC6B000A; Mon,  8 Dec 2025 03:51:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFA9B6B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:51:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A0058B1A2
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:51:59 +0000 (UTC)
X-FDA: 84195686358.12.20F20EF
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A4C31C0004
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:51:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3rJE2aQkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3rJE2aQkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765183917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=sDe0xeAjgzNdxwDHvW7PBua6ENMGHlC7KWZQ6HmwjCc=;
	b=ThBHClHuitKK9Ng9c97WB6z+YPJqg1ezMKlJ052lRK/ecnYSGyasyC06iUg/mZ5xEjd0mF
	VoVhSTyJNjlhjgQDZ+L3CnjD39qCbBQIhMSrqBD+TVaYs1t3gwOqMjJD9K8ojBKvcDMXzx
	4sPtWjgepNPR3T2JxKu3TWd2/e58ayE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765183917; a=rsa-sha256;
	cv=none;
	b=HdO/+uXXehESiM54tjZpzSFQ0yzI8FFuKXlT06r36/XOwRCsc7oY4Y3yoqbbTgVkn5Gx84
	seLe0oWNMFK65+MNyz5PG5pkvKPTDCVJcmIV1zI3n0jg1gVVio0FO7LVR3NZ3m66vezWpz
	2akjFReA5PAc7/ZlG40so4uVeo52iB8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3rJE2aQkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3rJE2aQkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6574d3d44f9so5929857eaf.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 00:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765183916; x=1765788716;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sDe0xeAjgzNdxwDHvW7PBua6ENMGHlC7KWZQ6HmwjCc=;
        b=PGQ2FfLoHXc+MfUeQRd5Ha4b83qh8JH0EBYC9/gkOrNEBhDkricoJIJZPM53EPxQoU
         d3JolNq7vqktiwzBWdPGCZIdpiukxAhTJOAjKaUuC3MzioL9bT4Qw4fVQUwPK8f+6Wff
         OtogrNi0romEvYRWNqeT/f17pPUO0BkBjzFdK2VhgIdS8LN33CHK2v/tX6z32bNkMUBA
         gTV/4qxHcpkt36rdJjadsuAx3avCxCclNBorvBQTw0SLYtjwTwmoZt+o6yX5kUs8MjA9
         ctvBXEyKuvdce+XDGrxwANladUQnW6gMDkBkqM5w1nShipjBnbchb3u7aJldyjUlhV3i
         uOoA==
X-Forwarded-Encrypted: i=1; AJvYcCWOBvQkpOljZbYICzyHyRVzlvgWcWJO6FQwQ7CosciUal0Pc1AtqnOIaRxpvEEiT1x27YIGdXEt7w==@kvack.org
X-Gm-Message-State: AOJu0Yw47wPuq4u5TvCKA7+l8Ybt/OInpB51sjitsxfhxUctDINx48A1
	e0a8lipQ6x7F4/aUrEvsPSfGTVLG74iK0sF4J6bL3NCN0zkx1zZhe2kXZC09kMonOnN+1Px1ona
	u27T3vCskrfjJiuCzwQLJzUD/HLBr2l44z6u6Cxx6zG1nSNmK3wlwIBaJ46E=
X-Google-Smtp-Source: AGHT+IGtvwHrx/AkNqeaV2m0nK1GvmPORsu2iOrdNfP1gsPjaxV0kpRKM/+woqeIgtcQqJxd9o9HWJOWGRoxEocNzE2nSi5KErBo
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2293:b0:657:7272:e011 with SMTP id
 006d021491bc7-6599a8c40cemr3736380eaf.5.1765183916719; Mon, 08 Dec 2025
 00:51:56 -0800 (PST)
Date: Mon, 08 Dec 2025 00:51:56 -0800
In-Reply-To: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693691ac.a70a0220.38f243.009a.GAE@google.com>
Subject: [syzbot ci] Re: mm/vmalloc: clarify why vmap_range_noflush() might sleep
From: syzbot ci <syzbot+cie262549d3c7e101a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, urezki@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8A4C31C0004
X-Stat-Signature: wp57xd4cjcwbd9sh14k5p436jpjhi65p
X-Rspam-User: 
X-HE-Tag: 1765183917-898995
X-HE-Meta: U2FsdGVkX18OnIRGhUUFuROAhQJ4T1Pn68p8V8KychDwNJBkVBsBe4JlFjSj/AQbZWN2+Za6XqYsg4uSoaTfgS6bD57EUEfZCLyiAoG21Gkv8eBGtVnhQCtGyeen15GJOn04xfpACxR+ceHZkyhOgsLpwpESwHTmsJV5QE97snU7SzfCJy8m2rxpsvEyBuhTXlthKgsxtymybkdhbStiWYRhIyCFlXnoRkxqVXx3aOnBhgbEZvtMU32iJ1yfO9MXYZdErJ86Hh0M02VSY0iAr0GNcN/C7NgYsr2OFMmwnapZMYMd0ffRk/EK0ma6CVsCNJ099xhExN/jucg/Mw5KTd1MDNqtKRR1CXjVI803jmBHo7XDcFQg5QVwJ4kGYyhD5cEoHmWFfOblORbRZVj1Pu8EDNyNkJ36OAi43UixQlvZ6POA/dDujJR6QbDkmLcQPjHu2pSozZ1H4aDwEtnuJaTfxSOTagaSvI3GneLmf9ciojyq9+WMr1cbz1Y1x/kAChEM6PoWpaAogsVHY1nAGrI6OhXvDfEsRdjutQgpopLiF7o1/2HPvTMxJRIpVnrgPojN8OYVicOl8x/xnp3G0M0sCf7kCIUceD0By5Eu/c2hmH/xZFX912mmBKaBU9UgRRcn2NTcS2r2/2UB6PY4H6ydncvbqdvvcrfs1kFOUR1AbInDGA0oP/OVMUzraQCS5WnYxCEGUA8O4/WxpHRMJ1aw9E13Y/iFc20fdhv+3gh9LbeqfB6yGHIOTwDfjSvTRzpdfH+gtKEuTwlcRMpKg+MXdF6g8ejobG2AkxAMvPxkgf7LpWA0UeBOp8bWWeZzu9ZU3SdDW656uemKRbMEfXhKjcfOS7JYuyBdxv0LOBesK5i9bpRWcKcn6iYRDx4atvzeE04Lg5JG7eBIsBnQw2gFy/QiSBxoxg+rZ+sV7EoN31x46wo4qQ3Jz0dLfKy5xt9DsSlDy9sVdKw3IBg
 q6OnG8wk
 xWC/ki6TFvmxZJlL5mdcmd4aMttBUfSEYmFFycPA4MAYjoZvRz0O2pZFViM38hVdqt65SaX5z6MW8esVlYKG0VQrPq7V+l/ae4lm84+3WHLwKlr/8CTN+PEwi0MUTlYuTAXA5G9FQPjxUsUyjmtn6D9MiBe5ok4e+h9obXyIqMS0JhkVM2RiEbbxG7YYYgwjje+rTygnAo8dZ+k9vAxZYdveP6PkhBu93QOnhSdWPpJOvxBTSSyDLs9nfnwikAz9vk6j9ZuhGJbUdHt9nIix1MT834JdhekSU71azaXfYgBaX2aV+/O5r9yO7Ke99ye8j+rDgLd2lgIp4DhalH3Ojx7BV585m/PwBeIx34E5PY8OGfEVNPIN3m7/kz1eztkYr09zXtyl7eQ3Ryn+tB2v2LOxAoX7+9L0VVWshvw1fqIuYFHL01+AJB+Dycve3PfttAVTQCbRA2sTtWPbeBOPpNG594UuengWswQMxWS7qpl6uHKxevNev/hEv+knoq7jSVx6uYg2nRaKFVXwvamBjhGWXbjRQP5xHWYIEIwTlmwoPg2ZBCE5/L0pTo+T9OFqSkE4UuUF3GZy7XR3zsGFBA97/4v4VUxb2sMTi2pmIcew78hh+A1fK9YDvWbrqORCHQWNmYGbKQrwZ9pECK6FqBwXIgIo2w2kHvqDfdOifqDN1I6aclvTV2EvrE6MvLB9PxKHL+zF6hDqKZ1UL7GQhRK6Uf9UPUw777AzX1QTTNCEJAJngw/G0PdUh3DYnv4iTC6D5iKMSChltKPKilfVZGRYiRHSVG7RSuem/bl+0wNwh+fhHUlQNAJ+ur6Y9fhB4/gi1jiWDsRHF8FcNyboKXI8SjMYG2uMg82w1EQ/AdAqtP9+jrCrr26UUbAb08EqMff7Z+XHVjtXsFfRuE02JJtGeAmC9WdRjVRtLWOTBbsiOenO108XGSkpUPwntTdl1acU91UWVJKUlJ2vXKcUn8vB85KSF
 3CXbrXZG
 bHQxe1n6KD6U8iE0k12t/HVgjJD+N8CB8XiocSdjfhzwpAY+dxMtBupCSwGs7Sj6h/0ABecGwB4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/vmalloc: clarify why vmap_range_noflush() might sleep
https://lore.kernel.org/all/20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com
* [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ca5fb0b1-49a4-4066-b78d-d144e56e0d2b

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      3f43be96f919cc611dcb2a4e38dd464831f4513e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/1d630f58-694e-4568-8ac0-62e02ea8a59d/config

mm/vmalloc.c:308:14: error: use of undeclared identifier 'GFP_PGTABLE_KERNEL'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

