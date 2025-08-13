Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAD9CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 05:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26EF8E01B9; Wed, 13 Aug 2025 01:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD76C8E01B6; Wed, 13 Aug 2025 01:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE868E01B9; Wed, 13 Aug 2025 01:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3C88E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:08:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 543421A0249
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:08:05 +0000 (UTC)
X-FDA: 83770552530.04.52D1992
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by imf17.hostedemail.com (Postfix) with ESMTP id A06B840007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:08:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of 3sh2caAkbAKkbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3sh2caAkbAKkbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755061683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=5aRgnC8pdaqi1WtoctxrdtHCiSuRrurqcXKWjYUn/gQ=;
	b=BLkYPdS9f4T5LT202AV0aRS2u6hiyKDAT2hGLnI06OKLXsRAtRFiX39upt+CGfI47o7Z04
	l63qDA6MvbK5DDbVta73hjgOacuAhXt3J70DA7avdAUEeYw6WA8i1rG6O8r76IdLFY3p7z
	uOBHRWzgCtTlzY4XiUICrOnUrP7lgRw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of 3sh2caAkbAKkbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3sh2caAkbAKkbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755061683; a=rsa-sha256;
	cv=none;
	b=ZhNHOW2+V1eNpL686TLChJxQNujBaUQTlp0gbLPL3Ke1pZy8W6uwtt4SN5el1Fel6M7CAG
	BySRKqLAmG/5lJRHDxkeZjrNBNFsPZ7ii0echOtsjYL19uQBCpnFrQCqwebojx0ZZOONj6
	imEHr7zLtm9Pzi1Za/Kc39xoIzTUu9k=
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8818b1512c2so607144739f.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755061683; x=1755666483;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5aRgnC8pdaqi1WtoctxrdtHCiSuRrurqcXKWjYUn/gQ=;
        b=oB5t0CW6OA6Tf3qvTvK6NBGyVWd8PTwpILqe6BXbSVOUaH+L9hV6QzX48GSe+5dFoW
         ZxIZTJBE0A6PmB6EDATXYEopKQqfOQHTAZlBlbLS/cYi3nAgKnFNzpYRGmkhwherTZUG
         5WpIPCMkqIkVhInNb0lvplmVc01ARsKpbr5krWd3qsETGffldkbYWrCShwj4ZWKcR3TW
         d6mxul6OEPwILRDSs8pfgmG/RQUiW3c40RUXKKXG3Sds8GUOR2G1ZMoxJ7T/PmLWBP8C
         IVMQkCroZM/+EMZzdg64lL103UQqH/J3M0TP1f2ld2uRlLCLkJRGi9Dh6EOlGVcp8HeY
         KVhA==
X-Forwarded-Encrypted: i=1; AJvYcCWQTJBP4jMe4xharnXe2aI1jOpRc1NkSSU3C6t9rGkQs2Oz/UGdwGX5ErPzj/1iuRCJ4K/rUp47Dw==@kvack.org
X-Gm-Message-State: AOJu0YzggSgSdswVD1cvazfpJtDK43nZLSIQNz+DHr0NUazR2wpiIbm5
	RiYHh9C6xtBOpHwpUe88HBFJXyOwxm9d7zR2aUcWeTI2baVS9RqojTFQFm1yfqg8TIcU/frD4J4
	HjacSQGwTCuTLVouEjfwtCBZSyk+6deu1i4UsG9CJCfHZNyH5M8Jfac8Agy0=
X-Google-Smtp-Source: AGHT+IFdU16hTe+3rTRLdmhnvw9e/HlyKqPC9f3x1xVy47/8w1RwlLxU0GFUaP4N329O77Izh/5Qii96T9yfgP56raMbWWyjaUlr
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c0e:b0:879:674e:2c73 with SMTP id
 ca18e2360f4ac-8842963a8f9mr303580839f.4.1755061682744; Tue, 12 Aug 2025
 22:08:02 -0700 (PDT)
Date: Tue, 12 Aug 2025 22:08:02 -0700
In-Reply-To: <664ea661-081a-4040-96c4-26307ba020ed@lucifer.local>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689c1db2.a70a0220.7865.0047.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in move_page_tables
From: syzbot <syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A06B840007
X-Rspam-User: 
X-Stat-Signature: ug97pxotry9iwai5ftf9upy7tmu8q595
X-Rspamd-Server: rspam09
X-HE-Tag: 1755061683-680093
X-HE-Meta: U2FsdGVkX1/dTMFgejN+3Xn5oAI4UXekiU8QHf+DdFIzBjnkIOsTonmHzFb7c7Z/cBoasxYYml918iaGwA0fp0Osa26KT7e+AYqxeGqktg1+lfnbYQ4qL0ZO1te3xWxO66dhAjuaBWbzvs12v9VLzdY6QaGr4SnmQ0V4f+q3t2GCjUbqY+YY1ydsY9ky3JD2ZLO7w9QlezJq6aAKGpJdD826xDKjCUzKtjS334B+ubhWYXhQG+iY9LTu7UWdg0Ksw8bAJZ7q+eKUEcuAmKN2hR0TYFDeyqqmxqwMNO71lhowwlpJ8hu6xJflK1hrW1vvc/P3X1onjLyxZMtlBSzrYpY+9olsvFQ4897QuDC0JaKy9H9Waihefa2wughgZW81SBxE+cC/klIK/iRCGpPuD7Z5oIx/WjNBYFe2iMk2hCXHjy+0cEARVmWUWD/CbCtbW37kBfbcIENvlc8GPGVV3SSx3rtikSuUaJKbSWn3P/6EasY+m1WAjU6s5hfgrQIdbyWeTTdqctuSQ359OdMFM0e7Iw9kYLLsCKQ9b2ZMsqD6UN6abtTnLMmvVkKaFTtPfoPNh7hAdhwH+NPqt6UPqZTlQvs2KWyJqIlbvzFeOPcMYHWIxlK2SCqgLPcBzcTaa5sO5Gw05sGkhpI8FFh7Q1Wu7HPSfoBPi0SV/hG8L+ahc0SXL13VsdLe0ejg7z8yqvsTntIUK+wsh+R5WKapun2cW64jOaBQm8cXViaY/Qmy5zLWsQfoHL/Cu+laNIif4exYp+oQKgVNUb0SICuhGB+41pbPL8sgv8k4XTfB48h5XPs22sR9/EaahUJ76TmiEUKI1UbejWR2O+5KaYVOpbFu5i8Vk9mMhdErCDEMIBjh1TLxYBUzj/UciFJdOzTilAV6ijL+nDC+wYOggrOe5thrUZbbEorZE6EQ7GuXODFGcPrwEgKi0deM9fy3JjpZ++p+3F5ONYzntaYvhXo
 XCc5F90B
 1Ce8y1Qgvxod9iDjzX3DtR63MxZoU42/PtNJcoyQd0cnW7j4LgzOZMwTH0H18kMF3EfDCdeBzxW0i7fA6xZICq0G++uqk9HZis52JjJ0mj+hoM4rGFp/4SlBfODeqBc+OgAVC8TzR3v6gWUczbyMMPLukyBd/wq2j3TY2qroty7gKgADE/Mfnm+O4V2kLtJ/80mqw73UQo25DQLGtu21SmMYFcRFHgtQqwG6+O3LOEzPB7cqACaqiax69dfWY/isjvgloBpFCZvYRCkzKRGo9z8H1ySoVr02uYx8XJtArrFDH+h1u67YhPOD+3auUIsxr33bZKvjUd3hEaCbU27MXN+LWl9foNIeh0BDF/jQ7gyQ1hdICQskbq8oiSvbPi3FB6/5dtjr8h+nuZx6YFlok+JOiiTSE2VWnnj10rZYgUXPPGMhLI7e7oxlnafKhV0CuOa6/gUgi7hPutoSc4RxL1iayMsudRrLJxbgKXlBZDiBAcL8+odoihkRh6cBKAYl28RpG/x5eRmUPvUGkXW3yvM29Vh49/z0aG0ePsPjBMil3pKYyeHMD7YZfDsS7eWGJYisUv42oBRDa09J9YJX9Cqc4fOoHwROaRGD2R0fYpEHUqf5l52unsj3y6d3kmvPaRcA3AT/psaxPDL4jy9BMpch0wmQvXjtyq7BfN0e61n0WD4PPPIGwrdR7aFOvXiPnZ5+j9MqaUEbHTxurKTtfNZbNSnhfCYlTVk2u/WGR2p5/17k5hT+q223Ghe42fueVomN8ML1YZS2K/uwv5l9X+WNEjWbBXreWxjXMTIG/n613CY+UqtZ2dSbGhUYjMPXzQbuoVoUQETq/CxqEs/sODMrnysPVLxr5Haasp0KvMA0xmphqBHZdVmOuZOihaxYcYVqVxB73czdOGeSVW2rZ8imYniaWww3JI+8f/l5gMK8RnvqrendD/qS1YBol+yAA2VAE2M+jrkFcwBjI6QRobhriUsXV
 rqqHtQ6x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
Tested-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com

Tested on:

commit:         0db9b72d mm/userfaultfd: fix kmap_local LIFO ordering ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-hotfixes-unstable
console output: https://syzkaller.appspot.com/x/log.txt?x=128fb5a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2323b2d6038203a5
dashboard link: https://syzkaller.appspot.com/bug?extid=4d9a13f0797c46a29e42
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

