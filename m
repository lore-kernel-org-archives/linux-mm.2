Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE50FCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F188E0041; Mon, 18 Aug 2025 08:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F008E003F; Mon, 18 Aug 2025 08:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E748E0041; Mon, 18 Aug 2025 08:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1988E003F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:36:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE1C41408F1
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:36:09 +0000 (UTC)
X-FDA: 83789825658.20.51F67DF
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3671F18000C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:36:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3Mx6jaAkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3Mx6jaAkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520568; a=rsa-sha256;
	cv=none;
	b=DsAHob5liq5/HCUeYZm6+pK9tBCfrlp99XGZfrIopJiRCGtranWqyEFG42SuFXdm7ieEf9
	J/73fhitjhNg9ArC/R9pHf/QeUgX3Rio0FU3M4ZfW2rUjlRvQFA9L0Hcyk/RZclUtmO4Bn
	X3VKplHIDzLwbfMJ4IQ/ouXc5L3AXZA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3Mx6jaAkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3Mx6jaAkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=zIg2ZRIh/jXrnDPxRoTtBuI34awvrkZLEoipYY5Cc1U=;
	b=x2EfnGzXhWKEp8yCFADU2ojM9YSmi4ZfnJ6cnGWsOnNQUZidNfGLgZXyzXCMmYi/7diQFS
	E8ju0dg9hiJjPBwKkI+KuZWgzTMIZw0PYNKMyhVWS4X0n0Yrj1nXFkkp8U8kQBW9AK27/O
	GjGQCWGSmlvo2JHorB1Q3wFD2C9vnGk=
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e67189ba24so3970025ab.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520567; x=1756125367;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zIg2ZRIh/jXrnDPxRoTtBuI34awvrkZLEoipYY5Cc1U=;
        b=tgsLeiEsDHMR5ibFDmHbd72/PKSZu7Ncmd7Wp1l8vu6RHX6p9O6r5DsCMohdAQB+1t
         UZu/d5dvp0rYpJzbI2bJO26grFgU+Zqn12ThdL+SYtekMXVU5TYbcg2mWorAEnL8JHsg
         hGyOmCJGhDioWZD7ys64FBmCds9TdXrOz8k26tryoTh/N/iX9UivOcNmu3QYFRpMEBEB
         ARHMmGouGiprA+IKGa5azjMwtg+w1uNg459Y08eVTvewZP1JYa9hlZrEh8eH5tBvN+9B
         wH9QGWvol4GibLyaMMAyb5NTcRaBnheewN++3KqKf3QJnC562l4ON1RsM13uv38mqBSZ
         kRbw==
X-Forwarded-Encrypted: i=1; AJvYcCVLkUPiUICbCJ4XynWQ7RC2unG1q2c/ka8S7TRXLkNr1RYr5dgMAUZaAWw4PzujFoa1gw/e9rUO7A==@kvack.org
X-Gm-Message-State: AOJu0Yzy8G6c/A4jh9yfdjhyYHTRrstO2fBfIKaMzyzg3rcqRsFZUbh6
	E1JvecjbJ75Bv/9RGviCOwHGU0upg/ZZ8cGlzbV/v7/a9jvcslR4AxHM7NAoIeqpE3otVdYcZOO
	ewJtJRqWn+r2jAOAA5Nbsq/x9zOc3qltz21OgpyFW+wUSC097UxYmDYfaNqY=
X-Google-Smtp-Source: AGHT+IHEWQDJKEutDrIYMvemuvoFRWNRe97U3MfGE8nq68PKZaijn8SILyAsae9poPv+3/Gxxp+LI5jH72HpL/liU4yd50YkUwMj
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18c5:b0:3e5:5081:eb8f with SMTP id
 e9e14a558f8ab-3e57e9a83cfmr202742425ab.11.1755520563926; Mon, 18 Aug 2025
 05:36:03 -0700 (PDT)
Date: Mon, 18 Aug 2025 05:36:03 -0700
In-Reply-To: <20250818114404.GA18626@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a31e33.050a0220.e29e5.00a6.GAE@google.com>
Subject: Re: [syzbot] [fs?] [mm?] INFO: task hung in v9fs_file_fsync
From: syzbot <syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, brauner@kernel.org, dvyukov@google.com, 
	elver@google.com, glider@google.com, jack@suse.cz, kasan-dev@googlegroups.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, oleg@redhat.com, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3671F18000C
X-Stat-Signature: 46gjyrk9fdt5qwsbsk11o6dzdfwh76bw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755520568-586353
X-HE-Meta: U2FsdGVkX18+Ja+UxG8f8s2hbt+EdHtPdJEVABgebQJAo6WNJsDvjwptQh8C8bZtB/b6Q+md1tyu+k5s6IRAOomi/icqqdl8f3HOP/BQ7fU5Ezh3d/TuyNHj+dExGyWp0EwFxj2EhbrZNn2mn0kW6ttsPwtsmDuRVpEPLQ9yAlYtfGKiQtZkXlEl5g85ZrNoo2e/Tjwa6dpUgW+OQs0jgM0rBLNjg8yPBNjNfp49vDn+b9dy8TJ4lC6+QiDEDBtbjmK52C5/4ZHJLZlIElnN6LYpwSnydKS22LVlyGRwkHSaeKfPQgezFtZ2qdCCKWiQQQ1evWmyQ0RYajAoIiFIIUulN0hY/4CfMXltb51Dp85Jo/jgcCqYA2cW3vUrlnAuda9UYwBBbxWK9EEpJO320dPV3uZqtXbZmUmM1n/9U+T/DNwNTJqAEguwpREiMC7Ozf/0+lPxVQQBv9vF5JTqAe6WsduRDtsULk0rrOgGVHwkqyyKJ0UIsFMm1wyGNwaltGztuK2tBT2gjlRJXRBBiRzCalGHkUVoqNTrU1boRETRL/6pQeR/KVO9aYuZnPgnIEFpQcwk3xB0rAooCZaVjMwsOcFMe5WMM7oyMEwGip1K3tkfwzRv5eaLzU9eu15gOaZ0CLycgfwq8uxW4OqRKRoJ5MAi767pk1WMDkAFQyPEKYfx3tXWT+6boO8ZouQlPW5et05eIXxmGuMMBFkcFrHJRPn+lLb+c9wtD+PkMvI1H130pnzvUHLgKamyj/2cAK0peJTcmCGEMKaoAtfOFvRiTviVcV84lsxUZNFLMggu2XBJWbNX7mly8KyNVQAA8QI8UPgwGmFI0wRKQBuxUhnf1/+fVyvKbXf8i9G4KwxOsTFcrlZXsRmewA6JDSH6KyvPAvO5llUQJwX0g7tVl5uhzV568dwCrWv/1sUtucS7cVzo5Fzd9lz1xx2ulxln93ss3k4ndPTBMOpC6ka
 mH86mXdv
 n9pXe0S5UmExZLeA/PP/bkpRtbkFvijvwnb2s5VMW2ETTPD7kyTcz4aVwFhdyMMXrwvc4K0a06tdyBmXV+5+N9/Kavyz9z+RffOhC+iOhqU4DNyy+ZpoyfLC1QY9PVZXKlEveT4gS34h28Un3e6CsmAH4PwUj0prMvzdm0M2e4jydLur8CaeJ5Zly3WJPvgVazz8FiO1DaYPTktOl1csntZQkCtTPb497vPdZ6pV8nHkO19Ga3gRfJAdqjZDnCre/qG1GakDzx4LENkcbkBQBORde9pMlgweqBOai9OD+Otr80tgJwvqSRU1jR2OYVZkEcN5a3WUZdpEUx+8IGN01/KMUSJsQzJElJ4e+/IpQDV7P9UMpp5l4LFhlbqzSxWvNuXBBTnxyH+Rzi0DFPwvElcab9oPUShN4wV36ruBl7L9/oAWnJCqFnxhpVAh/l7Mr3GDvGiL5zjixyD2FPL07s/tWUddwe8Vl6hGQDHpk7yZ6Zm9uj/qMBHzm+I60ApEjEYqZPlheuUpfnzWx6UQDYOG7nmq+egEmqChHFz/4rBxWcoJIUNP0iBgQHXk0HOaZ8i+G+yNYRna6dkQYcjMlTYywmKIko40xUeIP6tD4kHtMjVvKycxcguXpRxOKy36Y2n/OmKxSGROl2SqCK/gz4y3AAgpP1K6n1dItl4HMZaN37Eit6dcNttX7aKcsf3R1ksBytsMKy7FCsMpQHuJlMR8vSvNOam15KfpOndfk+xB3qmFRVePFey9WOii+tmB+quCrk51uMBaePiJxrb1hRnUKnSuzMlH7UCaTdy5IdU8LLp3/BNqCUs4gUJrzJv16EoO5voa4XaoshYT4GCtnEuEWdVHdCyBrE3OUNLlzqfCFTCLfaVZu7RhFYm5AZWWAbj/lmb3vnie1ipf66t+J6E0vM8vFhFaA6yocgF513Csu3gW8doeX/4iFvIWrsqo1GbumdG0X/KS1U4/BNJa/9m0Bysfn
 a1qF8/i0
 /rw2fNMvp4R7Fu7VNBCOMVA8yZ9i1RgAb99/9lTAIEInJ6VV4dxuiFnDJ1L4xa8djXWY7UyJ5uivxCQWuyqpZ0IlaC0HHlLldm/bOwWYd3JZhZ08zww9MxiP9OaEUcPU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
Tested-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com

Tested on:

commit:         038d61fd Linux 6.16
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1317eba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=515ec0b49771bcd1
dashboard link: https://syzkaller.appspot.com/bug?extid=d1b5dace43896bc386c3
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15806442580000

Note: testing is done by a robot and is best-effort only.

