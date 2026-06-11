Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BDCCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BAE96B0005; Thu, 11 Jun 2026 11:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B826B009B; Thu, 11 Jun 2026 11:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8CF6B009D; Thu, 11 Jun 2026 11:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE946B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:08:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A21C1C179E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:08:21 +0000 (UTC)
X-FDA: 84867962802.29.AD447F6
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5265B140007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:08:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3Ys8qagkbAAUx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3Ys8qagkbAAUx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781190499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=e9BYqd/TiVfBDllfAFAo9UUiMBctmNP8GPj8BiGaOxg=;
	b=ByoWfp5LWhRnD83JYMfOLhPM7mUH86p6URqySilteM0png3WKUMynZMR/riY7qVK9TV1F0
	NVQ9N5p/aTX0p67To1jKUyK0uBcq0UXbvG4HmbLUni6TIDwPTsO8iKhf0kck6DzQ1tVttU
	ET89UYPBWqKUV7omp9QuWk0XynREkR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781190499;
	b=SmIiKBsJPaO8ayw0O7fybdCau6X+LgLJUj4DnVlRqin3KVVjxFalNLD/+XjjBz2hREb3bi
	xLTSH8HJPrgoGxtb9IPWaQr+0mI8zaaC8KmDilHShK6/co5lxP1EXtBVDhhPNcfTbPCblm
	6lVy91S+fqSXquu5R1SxQ9nfB3AuV7s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3Ys8qagkbAAUx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3Ys8qagkbAAUx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e6d9be94a2so6119458a34.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781190498; x=1781795298;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e9BYqd/TiVfBDllfAFAo9UUiMBctmNP8GPj8BiGaOxg=;
        b=rpBVNRHIyaZG/hvbDZP8otM8EtUnNOLiJZhfNtJD9CDq7bd+CDtE8QyVbns2wicXIv
         tzu1ut0GGNbi7Baupw3N2Pw4iBU0XK05r0hN+7BGijRqSNZPopOkQRo4D8qxBaL1Sr9o
         SSj41XT7bVwHTc7DQLWWXeJQ+LR+iNVY4FDblAX3sfGr9dEubiLY2FNUN7tkMsFh25+a
         c+8r/BXVcuFxZ4kR9VJK7Yr7jktDKQ+q0U1YBwUlahp2z4aPeqA6F5QvCbyN4bIPUGks
         bjCZDKKkAaKcEeKOWc/AlIUo3QV/spYgeFyVIY/iOtl8YrmylBI6XprmVIqhCdVLEYcf
         mNrw==
X-Forwarded-Encrypted: i=1; AFNElJ8RYTo/ApE6eT4wAnj2ceahbQI56R6CVoFqKPNPydgqK+5MRSHcDM+kHer4ySEmugv+ecD1nIh/0Q==@kvack.org
X-Gm-Message-State: AOJu0YxneXrDN1vS8SEzvgQJZOBJYBEZ/qLgZA9wXnWzIWA2lP8+P0nv
	y1C+R6Ifco51HGDT30JEcl1fnzway+lUdNPG9nxRJBeAwo1Zf1vNT82t44zcCh/47qEahknSDyU
	50zyclSFEd9F6cyD9n8fxbY0Yo+dvBxaPFkWtoi5xtS7W03A9xBRgpu4smUA=
MIME-Version: 1.0
X-Received: by 2002:a05:6830:4908:b0:7e6:f7fb:968b with SMTP id
 46e09a7af769-7e773359ed3mr2706887a34.2.1781190498286; Thu, 11 Jun 2026
 08:08:18 -0700 (PDT)
Date: Thu, 11 Jun 2026 08:08:18 -0700
In-Reply-To: <aiq9kD3loZWsfZTN@localhost.localdomain>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2acf62.886d67d6.257b36.0006.GAE@google.com>
Subject: [syzbot ci] Re: Implement a new generic pagewalk API
From: syzbot ci <syzbot+cif8583cab9d33c85e@syzkaller.appspotmail.com>
To: osalvador@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev, 
	osalvador@suse.de, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5265B140007
X-Stat-Signature: 9xt9we74kf7474stz1xr4a7557ey3n8i
X-HE-Tag: 1781190499-297999
X-HE-Meta: U2FsdGVkX1/TDy3f8XRoA7NG3x7/fFeR4K/MnrotI1Tg8A3drytYQeG6lkLMuQAI4WROLfHQ9NG6b1S2JII3xZVolKECBEr+OwG7eX5QC+i3BgeTxPJd+ZZ0uBVyH6tGttndWskLMbQHXuex9RL3xKXGKrCuxzCy6ZzJdZ6zAmOhsQhFP8rKo3Ix/ust9f+38ZThz/h+T5i6kQXq0XQ3ExSl8ZW5r73tkW1XDkvoeFPagOv8QGxgDO5YnjLdDWu5rH8e0iWc/A+vEx5y+sVhBarZWV3YOZ5b9enUmhNmPu2gJjby5W5UOd0dalkRsoZEUhLZ/eYMdq9uc5tmp9Tn9pMfyTSCVznVuJWYuWeiMjMsFz4T+NnGyrZhNKADMULjpSNsbJ07KjvFFGtmRU+tNcHme0Z4apZtgjrYOcfBhzkkKmRQLrz7faUtOm/kecIs3BLXZPAHr4ucG07OLR79Qk8oUSDvEtoE0qrtJ/Z2UduQj2N9MaT7qoTLWWAOTorTH/NLOlGy7MR6BIEoPNIHi+jdMLe9drIHqmzM2byEeD9K4HH/CrG79RwEqVilDD+Ia2gT76mPZeEr0XplUCEYOfwydYqMYIRmGQ9Dlg07sMOZMZko5998ZqBNMDLILM0hjE6Tffqk80YtEif9ATbAtDVQi7PdeSJdMhv+UkTtytv/vy4ef0L7xxlLHPBptWR2KQyeLUWZMi7PfgJSTAvLB14QS5rGHCTUApKaX1JkccYOdP1QMZHR+BHVgRWMgvAPAbJnSQjP5qvlVJBfaaHglbG+qhUqiqS5MEhXxScmOCLM9znJl1eBF1N9Kg5w9fV+loke+/JfjM6W39HZyfthnSdieXvk+8jgbFoMGd1+lN7Trufb7fkpW/vVYLyd0zozMUna8vKhV5rOGisZPGWgHa+Ee39RSV+cO2+//z0FrNJ2lrFPpU25ZA93xSPaQV6oXAhd/8DVNPt6nPab34n
 1OWLDQaT
 Xny/UD6bsi/+N+cKf5U1/sFOwiOxJvH3QvojtkPNba+qf/D/X8wtO9eM2C5R0yVni7BNgmh1DmbhZwFAR8I33vK/4pGP8sgDdJoElFpnhHsjeCAeitpmG0v73lvE2zpAb+uwkgg7tpoC8RIOqDQCHHm7bDGr+ebTNXVqQxRqUXxP0CggpIzd1YcuqDaFqAqetRzq8nyk4Of9aQTU2y96xN5ffdERxuzxVgIUMZiW/NmmrxLpovc+WAUXP63iyKgcjIVWFJ4ZT7Ui4O2UrceFdtH3lBac+ms4rdTnIIXG7QMyeyd3g2E2wgBIobva2NxDNP/R8ugxAeZyL/VzYtQyroZG+a1l/hxOPAPHOu0J/BBjx+1quEZdo2GmmqeSsB7LAah9pwiInuwYaRHy/qhVLExG82lFoF4bvEemARwLi85T/53ApUzcfh1BnpB7OIypZvW1d/Im49whJsnVZw6pupkCZPGJbt+Wx32sh5ntaEuLFGoyPtYuLGs6ysj5bYY+HAoMPEo6/x4Lm5JWnzlWn5P4b5tmS5yySFei0j9TuRp1aAgKHt020HKD/BlPjvO8SGoFGbS0QO4ejH4efv7BK6yceFHn0KCvs7ivr8pnhq+HA215r5y8LKf5HZy4P+wuwEdqigPvuPpOy58P2caAy4r4JaE+bD8ADg1JsC2RjrgJMZv4wmAA7JMJ+PRUrjpxTWohasqP95Lou+58BkxNOTQd6poeLjKrfcHfk7Qi1zT0oU32GxlEUh0aRlZbVMu63EJMcOU01vpYJLmHAdhcQ75xUtn1AxRh/dJa9am/RIo3DBlVH1vk4yyceyqf8q/FARCHnXPKKe9Yc/mJgytiTmqmCf7pO+G2Q4/gGAAKLUiRvmKgTrEMJQegwhezIfHLktU+KOa2oikKS0yTsFV8FVA9o4kLjjrPmk70WH7dgSd3TRIU23a0JNSeUwlFiQF2Ojs+R+hgnntWrbMcdhS7yY+nY6nlb
 aQl0ZZlw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the suggested fix patch on top of the following series:

[v3] Implement a new generic pagewalk API
https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de

Patch: https://ci.syzbot.org/jobs/73cb101f-23d1-4b01-a2fa-2bb80c75788a/patch
Testing results:
* [build 0] Build Patched: passed
* [build 0] Boot test: Patched: passed

Full report is available here:
https://ci.syzbot.org/session/98c0ca07-99bd-49e1-8b0d-a47659fee85b

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

