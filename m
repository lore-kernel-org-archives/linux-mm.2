Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EB5C5DF7A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9D1F6B0176; Mon, 17 Aug 2026 15:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27676B024F; Mon, 17 Aug 2026 15:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7F66B03F0; Mon, 17 Aug 2026 15:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA5B6B0176
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:59:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEC561608A4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:59:04 +0000 (UTC)
X-FDA: 85111825008.04.E3132C9
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2FB28100004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:59:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3BmiDagkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3BmiDagkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786996743;
	b=Gsj3QYxPAKljlXtma80MezDE8pXAsEeKBPg/LYV+SWibweXEeW1j7DzrK/JMFPiR2+7ODW
	umIEgDDp+bmboONpE5lWuk0XXsjJEQZaUfIjrqxFuFoyP8zqK/shqsj1PGD9nNd7D/cThn
	IkVM5HzeYzm/wamW9uQzyeNIxv+qwRQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3BmiDagkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3BmiDagkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786996743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=LtBBNJJEL5yAqoKvDxe2xuy3lD27DANuEB/TcNPZans=;
	b=MZhyoxaUNI6MvDUjkb1sOv85I141h7pKUiRTCQdKvvDXmNMx4leY4MzfQfWOvLo4dIGnQd
	k4DRwaXEUUwZkkUr73PVfoTBA71/J0ajP8j1oA+NV89MetQqQjGatiumNDnw8gcIrKddyq
	gKc+traBQ7JJfFvmI+bCb4YNbN07UP4=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a0f261aeb6so4842534eaf.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786996742; x=1787601542;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LtBBNJJEL5yAqoKvDxe2xuy3lD27DANuEB/TcNPZans=;
        b=Hs+7rrUEqinpFt2zK7cJ5CK6715Hhp26qIJQBVVG2M93ClVYCGIvqoMJ40E7+keiPv
         C88x9tAKPkOOW7A6xp8UvtqWA2GKsouXCmiE8sXkLF/6K/oWHLlL5KN32Ywb7M4sjbin
         1gdxxD+N+zNB0pTqPDdVEN4mFEB9ClIja6oScNbFxHBZT9eELJNe/6ilQF9AHNaSolwu
         oaF50uLyA85q3Cb1zNLzG9fy3omtGIBzk7NCc7Ca9v/s6tTyX+JkqJhUMcp/bVaYMHvd
         +VVkirmO+zorjFQCz8VaWMDQJJibvnknNB2xobR/3N/QERimTjqVBn7hMW0EmJoLCshi
         WYCg==
X-Forwarded-Encrypted: i=1; AHgh+RohxEsBGuj69psz2wOo4whLwgL3bWBeas6TG3rEgMuUwadTw4k1wUc7zriZ0+t/JbIpocPM/rZoGw==@kvack.org
X-Gm-Message-State: AOJu0Yx2fM0rurHLoXbMIB+GDKJvGdlEW2gyUUNJS7+0n3w3EDMNJ8A+
	izNl7F1PYfwCnjnGXrxE193KLcE+J+HwWQuO/GEFCvYI8pnbBWJNzGoy7lqKKh3qvyJCIWkwlNO
	tMbcJs8M/iQQOynw+dQzWF+4GZ7XowbVpuGncaCCOmZz1vBx913Kyw53uq7o=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c07:b0:6a1:363d:bc42 with SMTP id
 006d021491bc7-6b0d61bec3dmr25274691eaf.15.1786996742271; Mon, 17 Aug 2026
 12:59:02 -0700 (PDT)
Date: Mon, 17 Aug 2026 12:59:02 -0700
In-Reply-To: <DKRH6MEVABEQ.28CPBZM86HRGF@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a836806.f7a79266.2f965f.002a.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
From: syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, gregkh@linuxfoundation.org, 
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2FB28100004
X-Stat-Signature: 1n119bekuwf1p41ezbkai7dwf7peo3rn
X-HE-Tag: 1786996743-913786
X-HE-Meta: U2FsdGVkX1/Axijr54ZKuk1qc3eGGLZfjdTH3qAHxJDxh7uTkHs3LuuG57mTCtrJ4MkNkT9ndEs2AloUjthM15i4a5R9TkBXux1xFzgHG978SZpNyVP+N020z7gfNK4d1XwdNACkuyw/8blWdtR5GbAD7TsofLEYMG1aQGVmIH0nPo/bgWEmO8Va0f1Bo0SVGpp6ir0kBemJqsTD5MdF8qr9hqhV1W5vVQ9Yv3vOOqvqPb8h1Nz5H984NVO936CxFohrxUM3RjLyV75NXr8WtodZ97IJqrA9SoMmYEbGGYF6wDzOm//KdEfJPqI2jEFalzR0onGJUK7l/ivZ42yiznTkqPTytT8cbVk2jahLrWgvQqx0n5zE4qnH5XjquvdBdzDR/nnC6oUElk6sUEa9ei1JFdJ+SwG/yau8XyC0tgvSY99/o2VRGHIDI9miF1Pz0utrvumqUDWP4RTYmsNBYTSgvAooWZv/eOyapW3PbMt1GCXTF1Di4H3QuWgt5hXH0EbJ5auXTBBFzeyaWWSecXgyevV1BPNWqypd8iUPepLfdeL/c1y72wcQXooEO1S6hNRS0yDTAWW13cEsXicHHtYmN4wa49WDqqd6OmFxb1F7pt1A8ZJci5hpUuersU+TyNOXTEgdruV3rhu3Zi18xliXpsRX4wJ2ZgBJTXwOFV88MCuQw73ybsv8rswsm2rLZcg+l4b+XDwK4GjRWBeDior0UfFf/6AWEjBq1/q+Fv/UMJo5ymIK30KoGyl9Y1F5WrVEyyV1+m3aKQY0uT/4GtrNuNhi0CkDWGv4xDtONi/NiYw1ok2Dp+JAPpTV21Vu+dBJvWtssM2M5A0VWk0zxdBUCGbtml6OlFLh498EHxdHsW7qFaZX7SfzSbbinzXFiAP1g/SUuFeDpVZ570draG2yov64bVDXEoeogaeh8gPK5rVkl+QnWP0/JvjMUxOC9LHdFNgFjlFWNFqKpXk
 Nv6mZszo
 AvNQSNpCuGRpMPc8UymTi80QocsMhcAJ+dwx4CbRW0h8l6epFlANxrlfDazpe+3hwPuS2EX40etgthiHBQQR9rsiWQzytLAucFaoVPA7ud5lasJ4hh+Dnsw0s2YQbhGAZeEzI1CsHXgtoPRKFm2+30Kdq1mEZ7dbAvz4VrMpwoiVAQot/UpqFoAmz7lDRBYOsl7Hiy5e7RsnrJhwlGvPD2Ewh79zKWw5SErQQqMepCJxgbTPDoVyJvVs9upwJnj9YicpvVdtc4rBchVQz4ZjtlQplGlsUDEPbAmqv94ayAgHGM8OPqunA1FifPLfZz4qygytlUWLJTd/EEPbbkLcdPRCY7igz3gkfVdd5x+59MC/bux/4aeb6ZrQuV5TZ4ChHLt0W3+D1iHMe0NH63sRESgpExS3S2GzWEGZ1CG9ND8gbf4vpA3JF2G/g6mYR9LkXJJY48JZsHPBIZG4fY1tBdvS0+ss0hIxzost10p/WHobmBrN11h7xNvryT1euQecNfbLtmuNPTPEXq/kGUO4SQI95KNAjCK/52xQsas6CNKNFV37v2cdCZPl0dUgjMcF6rsPhehTPeYtGHp/e9SktgpRPludCOGaPHRHP/LaKI5uKyMH8diRVp1sqJh1vLwklderxjnUbHMcz055THNFwpEz/ms6u5llX1faQHRp0bJMjj0wmzYCzaAtfDo40s+YXxzOGWFEOOTZIfDiqM4ffVnz/bbk9fegJU/oKidBrgPkpxN7qRXEOKEdczvQjiGJ2op7JSwWGjZExk+GfM1S/scpkqlof+LWm5QrFm+miFTwrp/5SEXB0XJq/0rqkKx1cDmb/zxeGGEqIPshksv+uQQwWFp6PWDxucYk+uT5jpme/f32aNMMz4UDE4eWW8rqQK6WAAWl8zkeDGZ+ehkSHEhtVoQbu/DjwF35pnjEHhI5YtL407neC2ub3+X3FaHRm5PEWa0GOeNyRAsF6EAZQ45VJJbX8
 u6v55K3y
 TBNdSR7++bfC7+xyJbApzy521QKLrt8WVGNumbLTgywULEOjFiCS5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com

Tested on:

commit:         8d3ae592 Linux 7.2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17008679580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d67342c314f228d
dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15a7d69e580000

Note: testing is done by a robot and is best-effort only.

