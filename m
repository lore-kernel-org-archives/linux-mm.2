Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2207CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 04:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDEEA8E0008; Mon,  8 Sep 2025 00:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB62F8E0001; Mon,  8 Sep 2025 00:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2F08E0008; Mon,  8 Sep 2025 00:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC3C08E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:30:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38D951A093E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:30:05 +0000 (UTC)
X-FDA: 83864805570.12.1AE8430
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA4A41C0004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:30:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3ylu-aAkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3ylu-aAkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757305803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=iKg/g/XoJErvdToiWX/Q27vZTqTfinN/J6yC7CugODI=;
	b=HWypMSwngWwFJ5OVzMKTsbrEUrLn8r2qqt+0f0YFnjvJYzKFAkHKHDYv/+bHwrh0J31YiX
	uEDEX73pBmBOqtXy/Dba067wiFeBXSjoQrDJVsjRyERjbkiqnXX47j1oQjuuppLUbC5S2x
	dZvww4TGA8+ee4C+y3YF4T5O3ayaCG8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3ylu-aAkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3ylu-aAkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757305803; a=rsa-sha256;
	cv=none;
	b=0ZJexSGyS0oSe58v2UQ9tiVYIDD4uF5m7Hz6QA0o4SRIxPXdMyvPLzITBfnLFlC1LWLNzY
	0WdGmXwOxE+LvmzqF+VFfISa+XLSYBh5mYcCrUDnpjMD2Xn+f7ObCXb/Qk0NI9UBSQkWnT
	B7EZCJXw8jr8DR8fQHUXg6cvIiOCM28=
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3f66546ad68so38496255ab.0
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 21:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757305803; x=1757910603;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iKg/g/XoJErvdToiWX/Q27vZTqTfinN/J6yC7CugODI=;
        b=M3ukWIjNbuBzUOsN+SaUBZjyVFt+98rVdqesDeN11y8nlauuBaFNJl56fZ2egp6oz6
         8/zwNUXC6bRFzYB5ZaiTz4jB+8fJVzidFf2FwXHusLX67vYZFobg/dvFourIL2C2wfzA
         DmgeWVwDxOJ+fh+kBF3WLC6ScRkdJqRpPbL/NI0jmyK/w0fOW+KMpwUWTjO3LvpFWSlC
         z/K69sX4sQXkM0qEU05Mzmgsu0JSKWv8eCmWyIolPFME2f3RDI4th5WSKdMbGvT73UHL
         UjUeGuPJ02pSvzqNY/i5L4NiJZnNwbyoP18CzZyoOTt4dGY/OGZLi2lhpwxfDpDvP3C2
         8pgw==
X-Forwarded-Encrypted: i=1; AJvYcCWTaR6qK+AbfpXL6As0XJlSz2IStF8oA38/RP+FH351voYRuIFbqbZ9aMrhpHJLGL15QmcfhMzeUg==@kvack.org
X-Gm-Message-State: AOJu0YyDYmRfNZeeXlchhTxnSf2HHAYEdoH2Ob5ePjQuex263QtOZ12W
	pIHdg9fapC56eVK40hbsCaGOkRyJeFPVCJzpGyGqp/tvIqLuvlphWRQAaVO5HCVxnr0RdGKa15y
	LCHxDLLzlqoX0Z50iMAZ4/nejfZRs+/7P2DwG/NteiJvXb5irwX/Ry5XArzs=
X-Google-Smtp-Source: AGHT+IGPKdo6XGzXWRxs8GK3AjURBkNRBzmNdwt1tAD0uRVr1AmOZCv3S4NUzRIjrDq90pmE/Ak2fuHxXW+LtPKeKZplQof/1f3p
MIME-Version: 1.0
X-Received: by 2002:a92:cd88:0:b0:3f3:cd20:d7e4 with SMTP id
 e9e14a558f8ab-3fdfaf2e158mr94576065ab.1.1757305802594; Sun, 07 Sep 2025
 21:30:02 -0700 (PDT)
Date: Sun, 07 Sep 2025 21:30:02 -0700
In-Reply-To: <68b9b200.a00a0220.eb3d.0006.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68be5bca.050a0220.192772.0831.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in io_sqe_buffer_register
From: syzbot <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, david@redhat.com, 
	io-uring@vger.kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA4A41C0004
X-Stat-Signature: iincyxtn3czngn16tc8kiruf3fcybytw
X-Rspam-User: 
X-HE-Tag: 1757305803-630622
X-HE-Meta: U2FsdGVkX1+Mo02TOztS5eH27rIVs6oEWTeKm1r5n4YX9/BUFuzTmFA4qYRFHNjmwkdkt0x4iPjStIFroQpyE6xX+Vt3wzUbKgH5zoI1gWjYLRz/YcHfe/FlBQp/Xy9rG4qAL9M/LUF/xycalCghBVYDZ4ZQRVXyKRkJSi/Wp2G3pf63PEkSI6vnnjBXnHDJq8ZpLA2sLGG2wm3F0yRii1XXsr8s2utUKjTcIxnzHAysqW73Eq9iv1MoZ9z/3ogKfBbewbxWZ4ezYiukZmk+Vf7uW7ikIFwVLAO+vY3QzDLhWz1+3rQpY3SIbHUPl+PIIEWOEa/PSeJM6DirE1GoR9+m5w850Q7OUnN/rimUeonEAR7oXVNbQh7G6ZpQx77/kLsH3W+8pM5Zzm8rD08kffOwHpysLdFT8kexiedl1xREiNCClvmjLKJui0eRX/SxUJZ1U/w6XewiN2t89XXK6ZdutisRJuVWLPpl5RFpF+dvvkkhqdnubVqZxli5q97o7W7wRzBHOll8oaJqBBmHYUaqWadxypJAbcnLt9uTVGXbduv9L4TQPkbAy2lX/bUxJdIu56JmwAm9xtbp/yWA7KRoKwraoWJQzMBL7K0rMcGpnTe25hlkHzsXwqQCw9WmV+M8Cf55nW6TFs2XCoioyHrAQaUcpH3C4jy96u2rPECvl281EttfX6aJeSqXAIdFDXAhfCYKg09qC1t46I5AY7XThK4dPf6a9yYXjmx/UuPHE0leYyh03neaZZQkln8bPY1c2zqAMnIpuJtsNcCRZSpzOcHGFzjl28vSkgmQ9FzYeDPAhy7cmFXqOWi9xHcxEA3tOnnkgenwpkzcahTbaef/61Pybw8LAdhuLSIChKYjHxE7rqCvWNTabkQoj+WucMXCRs8eJ/cjHyF4Xj1pqXyxfQlXy7y95Oz1T86c8GErB8GcB8NdiV2JMUl8il5EgSeSHwuQVLpvcJe0obf
 YEznUHxo
 ezskCdB/Ul9EYUAN57x9CWrMitx5zlLcFgvsrKx/wX+grr3cZ0s7M14B8/4WSlXPZ+YdJd0esbU/G2qCPZ7PCjQOYVBAquBBPWaAtYnnUFBVkTFr29u+H5z0iDTgGYHxvz8JN3qvspeMS5AAkTa18Pgl8kpZqv0bEXB7ucrcnbVG4/5TsthCZ/Gw9z5Tu9g4AAOx1PxncXjUKgYV9obFDFkeOtfyQ3h+O8pZcunNIYdwOKdQSRoOnwxYSSkmfaPBb0GaIVwCbhzhqlEJ5f2tgsjy3yx3sMZp1q4/sqmyx13IVk8i+J/rCO4ZdPKmJsfVLFok3DLFDDOIC5bcmc0ABJssH14JIT8J+7LgTh46GNlxgivWbL5R6hWMN+Egopwi/TAx93GGVswt2hPV9bD2ROlUds+0p66GpypXw4GxTuVbu1peqxc9ssowi3d11bW5wk/p5JegwRby6A2h+GSF6Iy31+s1gDDt/8ZElLGNGOrDRewEP70AWtTsZXixP9no+z++LE99ko2HAXOpoMXgAaov3zJn3SRIuorlTQH30jWyQwa+V4OqeAc/EzXXpskVnbdBN4XpBM0Rcuhmd+fHSk/nx87s/dgy2NFFAinwS9Hwp/bRA11PHp9NdTDYPlgh8c3MgiuKs0gv6X2W++0/IHnn++CYPKrKDjKq6NaGm6ljDOPyjds+qLPMnsA/Hk21/f3/xHtTTrBRdbBR0AgB4i3lh8u0Zk7P6Q6nsnLcdO9GDNF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has bisected this issue to:

commit da6b34293ff8dbb78f8b9278c9a492925bbf1f87
Author: David Hildenbrand <david@redhat.com>
Date:   Mon Sep 1 15:03:40 2025 +0000

    mm/gup: remove record_subpages()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1240f962580000
start commit:   4ac65880ebca Add linux-next specific files for 20250904
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1140f962580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1640f962580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
dashboard link: https://syzkaller.appspot.com/bug?extid=1ab243d3eebb2aabf4a4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a0e312580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101e3e62580000

Reported-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
Fixes: da6b34293ff8 ("mm/gup: remove record_subpages()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

