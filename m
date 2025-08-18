Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA22CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AEC8E0011; Mon, 18 Aug 2025 08:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62078E000D; Mon, 18 Aug 2025 08:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78208E0011; Mon, 18 Aug 2025 08:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2ED18E000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:56:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 120E25BB9E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:56:06 +0000 (UTC)
X-FDA: 83789875932.21.376BC97
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf17.hostedemail.com (Postfix) with ESMTP id 64ECF4000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:56:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 34yKjaAkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=34yKjaAkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755521764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=NX93WSBTJ05Ivc6BEiIOWeOPQPiP+fK8Sz0GY/O4zc4=;
	b=HNIIOEISFkf7tdexNvF/v8MnyR4oKNKMfvIY1Dvr88ISVcmuUF6OByC7mtQP08B0eZnRD8
	etFlQuGzxZ1jFW1yk7DI0JCs8jpQTRpzYO9NqfygaSGHPCrircyPn7KqlddwsNWKMhbrcQ
	QJcuLVhQlbD8U4erdbusvhUBDAF7j+Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 34yKjaAkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=34yKjaAkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755521764; a=rsa-sha256;
	cv=none;
	b=RBjhqwubgJ/cu8umr4HvNI0vVIhRLLUxlEf6W5l+xZxAaRXzvdwwMIJLmC3/gjPFXLIYrl
	EkKa0IbCmmwRF2ZZJ7aYABitZQvRkrehbW2rhGkxhih50O0bJIPTULujP8QWXZqiRe39uK
	RHpn1LAUb608ZEG853AAWphswOF/yew=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e56ff1b629so144371035ab.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755521763; x=1756126563;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NX93WSBTJ05Ivc6BEiIOWeOPQPiP+fK8Sz0GY/O4zc4=;
        b=cEXQwvkOLSdrVqfTus7ZBrIFfpHTFujezYq+SjOnShE9x0U/RaXvwh5Hax91ddoY7Z
         PeQUwTtBCxplmj8a8KMwAESHf1L4IMZXnVhyZZn1HC/twzbJuNwPZCbnaNPapHtLNm8+
         JiMo/aljErcYIzLoVTeudOG/oc21Pg0ds5lJT1Ci2ei8xvKY1CIIK8nBt60MPtvvSaas
         SzTGcZsg9U1FQGNOGR885OJJ9hE/NBV247oMqbNYnG94+P/IoZo2d8a12f5Ft48Ki6J3
         9pJjTSn2KeuotTPXpXznHIA692/gujxKH+SlDh3Kz3iHo6zUcWxb8GEL6I1zmyrNY5W2
         U6Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUl6HHyBG3ITIEz4QD2RW+Y50aEQ4YO1se8wS7RY6tg1CNOI/sYtlXI5BW8FYx/5otYOaI/A+iXUg==@kvack.org
X-Gm-Message-State: AOJu0YzlfnfCIL81+ES06w42jU9U8D4/YH1Z9td5olKAE8Q1GVZqWymW
	hjvjN6BeSxPpPhV2N+BobI+jNaGSfG+8RQnCyOSrqZaN+29j/JuohVjsUOR3UgQ94x3OoZkwFpN
	4YWh7oSkxZoLXbGSX5gwLFcZaOH1Ip5QkEX7Xc9HWykiix+8HTlR5Lt3XRVA=
X-Google-Smtp-Source: AGHT+IGkuvlwu4mI8pMZwo9KW6bP24fbad2mbz6Q7pJVSKOoGc9tk+MbhdWW8H05AZ84psWblQe/qSfX+/dxZ09cnb0dwvZVIFZF
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d8e:b0:3e5:5357:6de7 with SMTP id
 e9e14a558f8ab-3e57e82553amr232423835ab.4.1755521763496; Mon, 18 Aug 2025
 05:56:03 -0700 (PDT)
Date: Mon, 18 Aug 2025 05:56:03 -0700
In-Reply-To: <6bd5ffe2-8f28-497e-9092-085e5d1cbc1f@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a322e3.050a0220.e29e5.00a7.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in move_page_tables
From: syzbot <syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, harry.yoo@oracle.com, 
	jannh@google.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, miko.lenczewski@arm.com, 
	peterx@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64ECF4000B
X-Stat-Signature: hthrt59g41gqrsib6c5t9whh4ksx3w9c
X-Rspam-User: 
X-HE-Tag: 1755521764-323800
X-HE-Meta: U2FsdGVkX1/OwGqRvz3FSUxHgyNTevwxNk43RBOrqR5UhLzUHc2KNH8c0taEurMy8of3m+Ixrf1fLe7tFeqUGQ+mnf+uZKraUwZrTIKl5nwSemN4v1mk00beu7ufp27AjK1b5XfcnYe80qQ96KG5l0A7t6biXj9wlSYKduWlHSD4o26qbL+tadwL29Vc6w8elWzEEFEI4ImzlxoV1SvkMnovZskZnNZVY9S6f2UYzY9kFyvOu28dRavIzm/lUMMRdA2PhOlD2PyJxVDiSOF/uKLtpwvu0lZFLgh7aY7S0a4/lO005YhiIq/ftHMCcq7lmiArv01OIBI98+sDwHHqFJDHvidbJCX2x7rtfJ6jfPMY0ixdQOPutrc9Miy5L54GCwPSvj48Ns/h4cjF4NHLVFH1ImNmgi4cD3QrvyGJZUNHS734+TH4a7wKRckhOQ2sHr9pCwFkq9vgxW0hQT1bZ+zJXvFWU8ju8wHlP9WgBCCoIBtlmPFIhGYdn4/O06Y5gs05s7GVAa0jkhkvMo7+ME6VRz8mUh1gbG1e4O6xQPYCU3A4Fd1UTX49LBvmsPPbzZTFg/3e0jSsRRE97lpUyAsb9uFrOa9QVbu+HctrBZjVN/dAEWoKi7NzoSJFK2vM+wMCNuNAzrIZaynmcSJGSA8fZ3kCrKL0q14hnKdkkTr8o7EVofz6p6YWIoPGazthARKrkS4Z9DGvbWL7GYysxNUwnU14cu/vibpNUaANxUUaiI8gsHASDEXXHTh6/54JKHlemkaklacJyWSV8mXDcf4Ke4CQZzPqN5Ku95SO8x0y25gcvw6BFaMDr+Gg7B2oriBTEwxldKQfr7zdwbMr5IZ2vLw2edZDVOgsfL11gN7/sgfuETJPnLgLhYcmzz5y+77R+kKu8CwTJ5ALbdsAnH1Aoe7iKhVVdS8zHclEBAufA3u9DnJeT8HhKWix6wA65HJaCQ+1DdkLpW3yzew
 9bLJDkHD
 csYoXY1s4VWhLMQY8o1jzPylETlPn/DVt2263IrzwhNYFuevYUytCq0ySNDBwP1v2e8qWmprQVIPKYY6sFo1WJE2Bv+3WKcavNIfE17P5bpNuoWCHdxMGBbnTld1XQE1RW5q6Pz+O4Vb7YyaUPKWwvI3IF0kYAT4zHAD7peqI9Dznva8silRagQ9MAdf/zRbnAIvXL6ng6qMeVwIPErossOQMXyGBeKg+hwCCetgQvyJcKiH/GbC9te8Knkih/yQrcOa7wcYEpDIDdSkCU5feombID1W4RLi2T8xJdz0+QpHY1P1QwYmrzHa90v45LNyokG1yQqFY+kPqTsJqd+bt4FTwP3fVpZyzZWVEPP3bo4GnK2xxBmvIoLUbIIt2/bqDcLZttKCIazWiIiL5wZTbQMUnV0nnF24cQn4/2DQ80ZBHeEihwkBx1gTmQPgbPW7nMDDs38YykKQ0jM17igeZ+25D1uiD+GAjymRP8OtbnHQn7MOrDQkoBeuVroaFfbiQMrm6NtYxM18JiHvSi0Rpsx/1bFmQe6I+DuWilf3aYXCJbxl1ZExRAGUxAF4wafjqnHqe2AOp0DgQoxOAKJ6VEPI4ny2Wl6b+a28oZpKnW8Y524pBH8C/eXVMHsPM8DHF1x2p8K1/+SHC3hNqOYXBP15Nc7JCXXuKz20wcHSL/xngm2emfMkOuDbrctIMTQzMy/lI3SyzWA3aVoVhQeeMUVgt1aHoJEa3X+L2IFTdIqIYBVIZv4aCPAdVjePxar3hB+u66q3/EjTLF8ch/z7kAIBPhjj7pfxO4Ct6bE1ewuIMimX86KTYDtk31l2CNOrnlFhAaSR2VhCgWkmWZJdl5bOB3wmE/iq990ikUTL5a00xRIEV38R/RKhSQrbM2wmgltpVkbAyx/wMS0d/gwIuBv076cxJQy66nOEhSd6AxWZGeU2MMP7PHEUw9lSV1Fw1TIAsKdkRzRIzuQCnXwWPucCcFV6j
 aJtPW0Rl
 mmmolv46xpUz0mE7kB2f0Bpg+MqIbd2jjJsa1DcfIbysCpUrFErj8o5+bWuL040jB6Lov4eLDfLwmny+wnzmgR2VBERmsTylYDzOLo3Ewow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file mm/mremap.c
Hunk #1 FAILED at 323.
1 out of 5 hunks FAILED



Tested on:

commit:         c17b750b Linux 6.17-rc2
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9319a42cfb3bf57
dashboard link: https://syzkaller.appspot.com/bug?extid=4d9a13f0797c46a29e42
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=107dbba2580000


