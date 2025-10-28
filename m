Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9389CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2667880183; Tue, 28 Oct 2025 12:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DC08013F; Tue, 28 Oct 2025 12:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A8580183; Tue, 28 Oct 2025 12:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 071D98013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:56:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D46F13B236
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:56:07 +0000 (UTC)
X-FDA: 84048125574.23.6263C21
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf14.hostedemail.com (Postfix) with ESMTP id DF32B100010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:56:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3pPUAaQkbAOEVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3pPUAaQkbAOEVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761670566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ozi99NcD6xWnvKgmrhFFCgg+4Pg8D/jR1dayURp6JBo=;
	b=JbxTM04cnw5k0gIadjDVlcAwbBuomT7BgRTmhwkA+59QxhndvjrT40r+4RRg9yUJpvV7Yq
	n5FwbjI6l3qXPr80Emu2qzS8vn3d5qTWiwlv+oKZSYkvDSfSnQK5yAgZYMgJqxmNYkTOEa
	fwhraX6lsSztA47MgR/mtg/Lt1cOLKg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3pPUAaQkbAOEVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3pPUAaQkbAOEVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761670566; a=rsa-sha256;
	cv=none;
	b=PONSSC1NgVp/Oi09mIg8IAvWdRSb3VH91hBbHDNazQ0nXavBW+N7NI9p0e7a0X7fgvieZd
	tpIxSLwWBaDjUvJJzwZH3eQP2S52I5HcwRyy6Ta/mCh3oeb905L92On2WcF+8k8OsFl13W
	itb5iQIcmYb5ZI75j+NLrPC3hF/hMeE=
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430c684035eso844695ab.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761670565; x=1762275365;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozi99NcD6xWnvKgmrhFFCgg+4Pg8D/jR1dayURp6JBo=;
        b=P3jvuPXVPJrQRNcXISp17iP+k66bbkGuxEejjfu31/CA1usD4BQ1aeAREDfUt4h15H
         QHDQ9i0sr7u2yctE2p9D9KMqiq/AUE42ifr3n/7Ze1WCoiPt6LltycwuQan6Oq9YTkFH
         HIwQZFcBgr2dvA0W2AI79Ric/2Lg6tuk1kixzPr8kGpZuZytRcn3GWq81TCo/O5pSUs3
         /0NQQ6qLeByPYTHjGwhJEh2OUOKYA4vnX6OCUq7WYyHTGDYG6MBvuaHxvxy/3MPTdLg2
         T8dgomKQtibFIAQuHhsfcH/mnZAVrx8R0gDX8QSdsA08Vfx7pGMp6Zkw3Sz7nLaDrCCu
         Erdg==
X-Forwarded-Encrypted: i=1; AJvYcCWUzhZ+08lvFiClg/KHZ2j49TnxePY8zVtKbYNMWz2jDk1j72Dejdo3mVof0I3ULh+xzv6iWAsYCg==@kvack.org
X-Gm-Message-State: AOJu0YyBQ4sFEgdc7MgrbOh8hnGYvTzc1dsSp5hdUmK3apko5C9dBxdc
	0qgRFcDAw2gjdbjdf8U6rfCvALyYMRgWlKEeAcTvt6hrv6mQxXaOH4XCUjkYdYktZTHgDZtLoyc
	nwSPAg84Tl8HMYZR8MdKmN6U1RGAfICCd5z5YO6ENxEtxdjRyQpFn+ir1+No=
X-Google-Smtp-Source: AGHT+IFiQGALKQurVTu5wG2hAEJP6OUmrWfCn08tcDbl9qt42SjOPgZEk4NpsRvpGGqPip1lUjaE8YBq03SuXQx+t8SYee3wGWIm
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:9:b0:430:cafc:df6a with SMTP id
 e9e14a558f8ab-43210445659mr47064715ab.15.1761670564976; Tue, 28 Oct 2025
 09:56:04 -0700 (PDT)
Date: Tue, 28 Oct 2025 09:56:04 -0700
In-Reply-To: <njddimio6m6pi3bcfyixizrfzjfflqvqe32xlfwn24vtzk67j4@3cijvucydtb5>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6900f5a4.050a0220.32483.01c7.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
From: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	krishnagopi487@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DF32B100010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: t3botebqupt853cm351bhyunujzjpqqq
X-HE-Tag: 1761670565-495627
X-HE-Meta: U2FsdGVkX18xcE53DbhljFKEgdaOJkMnOTgD8CVg/Eli/EvcVBBLrQ4fM55DL0O5yBRPLGl7gfXdx0TgqyJzRDhwH0DhcqzpoD+icmkkDiMMma3pbi3SUXZbaQkNAXDf2w04QnAuXoJL9n7SqtLlqamcn2+IgXxUKv+tc1aVr6K+Itu9H/yUblFdwOcgaJN4/WnBMB9bikdpqpwx4j1yTG9z4Pq7a2vvuhwxoa4nY+8ykOoYkVF/4j3ch74Uop29MueRCGuaFYL5DDuSypi0F1R3p5qtNsqmtm/Qn+eZ2wXFez52rWcsq6qLv8s0JeeHUY5OCxz4NjFgUECA3R5wgCD1AZPOwx46PHQsFXSAQ6T0DqgpeqHvsShbTJeYNP2apabaciW48/RFkb/wpl+d064N0lV5+4TP8pOuOR1KAlyA5dOlGodXE3ctx6W37Q4PDilwhBjWMdqOKee+9pLeFFUiBca1m3BE9fi4fsbGbAa7B+1Wv5KuxEicXNxFMUntU45D0iYOlIcX+frfafH9I4HuVw7UKRDDLuNF/LCuMgTT788MvbQnVcvD4U4GWf04jHzpbrBtO+v8MZk2JOkGDw3bKu6TYVJJgoGIaMNneNb+iPfFgDbKyYSHC/hMHHfnjaGkz4+kErU0/duONBCzeTlaD1taz7VGNgiMYEjukTihwrBCCTaRaveFo1W1HPmEkH2k6PoEl5q/qeCHdbKC4AlDk9uAX1nAlS9wLT4u3ywYKIBOYcWFbP9uJP8vAxypSMj4lS6vNZWKBWrKzUGTGlmW2379fOyWZYi/xHwIv3ifu/KAu1Nh5RaqbahZgIGW8EdjCWRv3iVaH6m1eJynHa1FlNQkzMCo9jgWN7atnmqMmOGopmnzyia4wZmrPNA1MC2YbwlDB45XRkNVnMHgdyToOk7ttOw7vF7BqRHVqZM6RYKzcWpBdyMthds6VWNY/FrLkWxwU5ozK/eO6Kr
 wbFlxlzO
 TUdKDpgKLxgL6FIPAYV8METJdIYTs0N+IV01EhptjLdbPUx5hlV5cxqyoZ8AxakPRAlfwRshGejETTdVMfhnGCIYTvTYItWKkdZHweng3/tc6IlyGDbmLgQTdG7R1Ro5elq3hhEiECiWzWzRRi6eNw+CMCKkrizaucjf4j0iN4rTnwUUytKeEi/0kHSx6S4w1NxMZaIgJXouZf5SguJC3cMvpdCOMX5X+Bgq0Dy1ZuSkI4ULOv2oz8JoKcrz2lPTgrPpjWnEF6UnaPqLEx4rhNcivfVZxFWzcYkwhScyCISD4Dq82dzaEMgxR9p1DO2nJzY9U1LvbROK713unt0COPmnwlkXOjeLA2nBuLJX3fbpw+FL3gmsA0O+IwqyPb9BLwGy2HGmjTuGpNYbEh/1MRKOguHwhKDnHBtYCLJVc1tcTh8Kj7NxXbVUZ6PS/6y8OWY44qkH6bNQaTrtI0IoayKTe589+qqORXiqXs0Yz4xVssITPAMEj1oS2eYgSxA6VBo+Y4Yn7uorwIaM/HLjghN0y/3IJsHIPYh5xTF4Wt+yxP2CpUl6HB2kJ+vGm7oLqzQR8rvVN5K+Wfmf4DQROD61CCeuMlS+A9qX19O35QH2USfUgKV8BGZSP86KeTyq64G5jgtA8qSxkqXVMLUSRIJXGPV2MKlacH53b23mHErFZu9Rx+YzquW/c0TcAwhruNvtaRa9UTcVUnpVK7aSEOoTdwAWBDD8wGiIfZfIh2hrX5LOjVVQZNHozmTzbBbYJF1Q9FSHHIkiNkrg3/gAwKAccnTtW9JomIeKvnDVYXIzl/LZXoi58fEhh/3ygPHAE17Tv0wbCHaRq4vOoN60ip/NZoHg4thdWiY1hP8NYSmpNAeAWv8ecHLVJzrH1aZJp2dr6HXPf0+HwDf6a6hS6IJk+HnnM3WAchJtqcsl/WC2snLO2GgAMhe6zv/khFQnzq6yF1ZrHDO6bqx0d7J4Y6cco9hsj
 rYM51rpP
 W1yJ+pyYPY03mgnnsHv1V3gf6xzE3DwOrW+6csqcZQAtbwLswehTcWfLvrN1JP+i9HQ93hOZgcvQGbiGg+aqZWcTVOWc6tliejqh+iyDHP81wF7XqOMIDUOCZnCdql3bFLbbNhzxKdn336YzxN2wC2W8AYbAvdxXDuxwrtlML5mi6oENSBH+LA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
Tested-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com

Tested on:

commit:         f7d2388e Add linux-next specific files for 20251028
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1244432f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0af39d067deaba8
dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14461f34580000

Note: testing is done by a robot and is best-effort only.

