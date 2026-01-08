Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9499CD1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D858B6B0088; Thu,  8 Jan 2026 10:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CAE6B0089; Thu,  8 Jan 2026 10:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB37C6B0092; Thu,  8 Jan 2026 10:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC11E6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:18:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 661171AAEF
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:18:06 +0000 (UTC)
X-FDA: 84309152172.06.AB5DDC5
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id ADB844000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:18:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3q8pfaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3q8pfaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767885484; a=rsa-sha256;
	cv=none;
	b=lrOix3ijTemdPzVVCEmHHNMcx6dWvYYpthqAMuWvnIIGZEObLUEDNzrYYM293s/gwCV0SA
	pj2mg1UF/eC5czarRzkRo5nXmoQg0Ld+z7FsrtawJxHdMQBsbCArj1Jw1JjCvFmEktI9W4
	45ZLz56zG6XzmuTMfcGYZ6EYhdZk60o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3q8pfaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3q8pfaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767885484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=hMtKSxagJ7fPc9Vyu3YcWP2X27nXblqxClZPeCdhI2I=;
	b=LPTO5trXuX2pz7vHfNlzNo/+FRo8/oJUmJeyVSn0nurjobcmd4NWuHHT4OSVsoRlPMUjOv
	8aJaM8CA8iCtIx/zrbNA2HzAB2Af616Xe8yrKnip65YsWbn7YSM71JPB6YpJUAu6O1JZEv
	oH5IJDrDAnnqnZ13kVNTEVoCV3uigG4=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-656ceb0c967so3732123eaf.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 07:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767885484; x=1768490284;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hMtKSxagJ7fPc9Vyu3YcWP2X27nXblqxClZPeCdhI2I=;
        b=A35mUIl8rDCaI9K/sPJmh9QjaBDvx8eUS+KV0Nhz0kiHDKA7a3DjsTiYE2toLR+huP
         +VoNBFaqJOh3KfxBNGGqA8g+CEnlkZtCLGnoaIPCWSqwn9f1wgJe8lKnnv30IRfo6zEM
         P1I5H9fjPk/nxrwp86y8D78cKsqMmXcSu0/bKLUVE1A0Tx6nR4vdwF/VDRf1x4CL3F00
         Invq1dWMFYAJihF6Rb/VZzKHugGm1GkEwCZEQQAl7CZaq6JYIMn4KTnoCDh8WWnMYVXQ
         T1ZAgxRt6Lpsx2xZxbYos0a94086SzY3KuPgTzisaHrnL3RgAHRULKPvdZZbf0rygaBb
         FOUA==
X-Forwarded-Encrypted: i=1; AJvYcCVUDePISi7PUykc4tmprsBzCJ5gj/Ia7i+/KM/xxJOx8KN6lBPI/i/XPYD9noUb8F7scHSSQAPZLQ==@kvack.org
X-Gm-Message-State: AOJu0YyyGDiq75iaoypYkqUIKV1I+vWOf8DKv35Rt3pP9jvnB107S1QZ
	EegFGopoQ3O6vmhTxH/Fn0p0XHsR+BGL37kjHhngjNdQRQ/OsJfV/coNCmNLyUDzZe8FIZRqSmF
	ASFLjk59ncOZw8J92meekK6Gem6x8/O9e+MHfowMeqYqWyGL9C+sHW9VkW+A=
X-Google-Smtp-Source: AGHT+IHbc77QJfggjKHR96I9EwwIHfaQwT1qa+JgiWZh85mlXkTqiAGAItRL7bdXqL5mVNaQedgelLHwCAcwVit/iA+GwSB+Dbar
MIME-Version: 1.0
X-Received: by 2002:a05:6820:a117:b0:659:9a49:8def with SMTP id
 006d021491bc7-65f54f602afmr2284080eaf.49.1767885483756; Thu, 08 Jan 2026
 07:18:03 -0800 (PST)
Date: Thu, 08 Jan 2026 07:18:03 -0800
In-Reply-To: <aV_BoaOogKt3fGGI@casper.infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695fcaab.050a0220.1c677c.03a2.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: task hung in __rmap_walk_file
From: syzbot <syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, harry.yoo@oracle.com, 
	jannh@google.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 8hg6um4we316kx5abeq31sq7q378aq1s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADB844000B
X-HE-Tag: 1767885484-260024
X-HE-Meta: U2FsdGVkX18XDH8GwsMQ0Adq+tmDoZUtfMlaOUSk+ZuC60UpZzyDzAdJ+z1qfhVutMxcvnKOEQ8aFL6OtPT6cPT0HW+I16k5zg+6VhCTGHVKheHiENelDs2s4U9VhcRGysqBdjdWAkzkZDeB1ejiEuYnYveriMXPFa2GU+A8T0FB0E4ZSPZAWHCBUrSYzIpNjWQhHXG+R4hO/55J0VU74KNf+KgLapbQZwur69Lcsfa5ljBB9nQGfl4Aar4OaXbDcPonu4wx9AmECet61YIEQxo4N+nNs85YjXGDDpYc/ORpRgFqp7aBwNUD5JHLkWFm0lQHwRL2z45mYnU4DVktWA2OnFOd/D9aYODhe99z7JzkZgLs2fE8SFJf2XZ0CW3RwIQivoO4lxmrusWMDbb9Nas3Ri6YMNFavne3IlUUk7rxICuvfvSXanwBjvX2wdcCONiOjN99f4eKoghqQ/i7bRF02B7SMa52Eh+rCheP3O/aQs3TQaw0F9P/WL7L3kQzte0Pw9zWAdlXgRMUF6fPuucfvc0PC0kvkyCI5i+DYINC0VoAz4h+SiAVc5UxWC0Zn3dmF/zc9sotqp4Pd663B+U3n/qRB3L58zjxzjlYlR6zPIic1hv7R1c1UVvr8WZQF7bcGpvL0FnHTxdi6Xwi+WbEbL4z8O+6ZZMkQDebxMLJkY9uHa6P8spmYta0bs5Pr+CNZ7xV6yXLsVIs34WIGH6fD00TpVgDiAn3flzKr/ULIN2z/oJEeMi5r8cqsVz2kfcFDhdBFku1tx6wbERJGz5sLuPXdcGt+WbBtWTprEqfdnD/HKRFSzIVxfdRZU5OQC0weHfhYZStEZUQJ/tkmCD5Uo+hMn9tUN0JgXAizqcaF6LQUq/mcOUUWE1vvKfJkV7MImcCgIVaGCwiZdDBbTaJu1P05O7sLQcYGiovlFjR7lT0DE9/rXUBzwzeP6MpfqtDYUn1Su98qr00U2X
 Oanh0Rt5
 le9tY2I+EmLcWzBjngOw+NchJW8pbuURDa8RKftvHVlCkKcG5r96gsJrtu11yev1JM8kxQYtqwnynyU3jgRumTxbLa4VWzJBI8AmkBsIMPgKlshIcmDcGYbH1bG6Rf3xTvRlIuqY+v2ViTxG6Y8YhHhsm9VY+5l62yz3N+kvMN2FeU5QWVFB8n70Dg1ivw9DFFGF9jRyIolpv8QGKZId83j7s+ajXrmvrTVzA2LdJeDq5jDKhmBKDS1GeaVe/VvbcvTMflGyJaGHUEBvB+sGtdmiwnIIp9mfvQuAFGKS+J02Unz73VBe26YTvjOOGlOa2rcesWOAo506edjle298JTiaOQ4JDdD7Mou9xF2ETCZ5z0U5Vu4CXeA7OnCiv7hnZMC1fGhst7ZT2zbKBBdVJp0j+FszTQdkm46DNdTgBUFi1BT+/K0GLi2uFYFplNrBKflqhv52Eb69JrxlkPiQDVZG3ZyW1cYKsL+qEXEMmRNkuy8RtlW2+Tbo+hG241jg9VbhY5Re3qm2QbDiTsR0Q17S+skFSYLY3A5h2DOnL2BrWHeohv5nw3zTYVgQ/sWCXAUgHpVRcZZUnLLUn5pQtvakz0+arcwd71Zhz+TY0C78lQ8WMG0JrCz2Deqb/kw5MJKoCc0gjoLW72JWr0ix2UOvOU8EK9kSWKulF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Tested-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com

Tested on:

commit:         f0b9d8eb Merge tag 'nfsd-6.19-3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13df11fc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5a01f6352682866
dashboard link: https://syzkaller.appspot.com/bug?extid=2d9c96466c978346b55f
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=159dc19a580000

Note: testing is done by a robot and is best-effort only.

