Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1901BCCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 14:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58F048E0003; Sun,  9 Nov 2025 09:11:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FDE8E0002; Sun,  9 Nov 2025 09:11:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D058E0003; Sun,  9 Nov 2025 09:11:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3338F8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 09:11:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9A251408BF
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:11:04 +0000 (UTC)
X-FDA: 84091255248.05.CCF7DE2
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1E5B01C000B
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:11:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 39qAQaQkbAMk7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=39qAQaQkbAMk7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762697463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=m02kWE5lhyrzZgApWthbB6kQBtAUB+gmZPn3Dt1ZsD4=;
	b=tZtm7GrWnbiWVA5XTPU+FE1tkbbsiOaGbW3GmM36eIwXMl8kmie9XFI8fuDFrR8sjnS0Ak
	MM7p1R0z5dZK9G1NNzQ1IBfn+PnohsHH0Jf4uS7rzdX5XlwzBYweHTRloczdLxvsVn/2bb
	MoaDAeIR+eNEnHd1NQH18fjkwiGJU3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762697463; a=rsa-sha256;
	cv=none;
	b=3N3hip4fPhPFF7ipisgoH9+BCVnciCAxGj5nRC96u9nKaikbG3dx6IRgNVsmfnclKv4dR0
	Gy7u3VYwx/JGaJMOrts0uIi1uOUuQXZ36IJZqZTUqR9kptLYJ5CXkxlUPeBx+1BdacFcng
	P1AKbFIqRO/bmeLzvOGypD9jNiTh7NE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 39qAQaQkbAMk7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=39qAQaQkbAMk7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-433270dad0dso19162965ab.0
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 06:11:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762697462; x=1763302262;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m02kWE5lhyrzZgApWthbB6kQBtAUB+gmZPn3Dt1ZsD4=;
        b=oov5MctppakKtEib+tlNg/2XSv4h9TMCB+KgRo/Igd/9kQ7Bmp4F5EwZnKF5gvo3DQ
         Kx3kPgeWO436Nwvu20tdZhKvkM3lj3ErcxOoqq/Kzw9H+JSs/bZjRF3QFlp4sFFz7UbV
         xf/LUEIJtvWrpk9NC91j66Xay7aruMnu5eJ6C48j6NgvH8rTc657/gqb8O1Dkn7803Pk
         dgIfOC4wpMacSfUrVYLhBXml6CdFXmlWFlkJrGT/KbRRS6Mmrb5fjBYfZZPm02owCPt7
         BK7f3IzO/jhwvTdR7TnURbFS7AUfhs69M/4OedkP5WE+w7/cAhLjuBNC6c7Dtg9dpOaV
         c69A==
X-Forwarded-Encrypted: i=1; AJvYcCUCI2Y5GYLsEj/0djLSjYYRCPiZ/cyWBPZMyP7oz07bVVmflupbwcxkP3LKCNCIm3nkZMquPTTEEA==@kvack.org
X-Gm-Message-State: AOJu0YxCP6qqbk25LHDgiuGBI6VNhiU+NYFxR/cjnhLS3SZD4qdE+iFR
	zuDvxdFp65IIcKx9Su0NOH4KD6mv9z3MveT5vPfY5949kJoUBDhRO8yxBP/b6D9qI2SKQZILrWr
	5olzFuWZBy7k+X4K6FiD4DZK72vJDj9bu63DTpYZ3bTuTptAL1CKVX+UUHEg=
X-Google-Smtp-Source: AGHT+IEw+SyBMcsmvsru2ydmWiAer57ckBKlQAwl2f1WWyRnepHiN7uVkkXdan4vghsxm/ZOPYzm213l8SerzWDt7Il3Poc2ozLJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4417:20b0:433:7d0b:b377 with SMTP id
 e9e14a558f8ab-4337d0bb530mr14752975ab.15.1762697462239; Sun, 09 Nov 2025
 06:11:02 -0800 (PST)
Date: Sun, 09 Nov 2025 06:11:02 -0800
In-Reply-To: <20251109-lesung-erkaufen-476f6fb00b1b@brauner>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6910a0f6.a70a0220.22f260.00b8.GAE@google.com>
Subject: Re: [syzbot] [fs?] WARNING in destroy_super_work
From: syzbot <syzbot+1957b26299cf3ff7890c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, anna-maria@linutronix.de, bpf@vger.kernel.org, 
	brauner@kernel.org, bsegall@google.com, cgroups@vger.kernel.org, 
	david@redhat.com, dietmar.eggemann@arm.com, frederic@kernel.org, 
	hannes@cmpxchg.org, jack@suse.cz, jsavitz@redhat.com, juri.lelli@redhat.com, 
	kees@kernel.org, liam.howlett@oracle.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, mjguzik@gmail.com, 
	mkoutny@suse.com, oleg@redhat.com, paul@paul-moore.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org, 
	vbabka@suse.cz, vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, 
	vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 19uzrekg3qwdu9jwpfeqfypyf8bq8gwb
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E5B01C000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762697462-869364
X-HE-Meta: U2FsdGVkX18qDqBs6j6HahodmbTs5Yvb0Pmadd3UEGzmfMHnAuL6ZbG9XoXjNUSHNKNyGazSmAu8JfPFT2gVVfABWH1i9hIML7ZqT9IcKakf7vhD89ywdTIqb9Jdq9ZLlZzHUWf549edZTjZtL+TMncY4ffsESheDDuUv05+4oOmkYUKq8ArUUDGgr6XRDh/06KhdcL3JsaAIQHf/PyWaQRFU15t+2GIsJC9uFOZqoLSI8X6eVwm3nsn68/ylq7f/ARBvQ8FS3UFm8myFrMsnTLWKljQfBZxDwQzo0k0R6aUl6Bxc6vBJXiS/nPtwUQpCcQ/D9c7GFBKfnacL1iAB3I1uuiML4dchgHFi1sXyIt8uAw8MmeitYBD3zwdq+5ziUzP7RY1E09XzKffCKiErTWDgj4lJB4eQ5RSWktXAWYxiU7bb+I6hQJvbxSPhHhpGMtgROK1hbWfgDoH+P2TU+mC3JzDUptQWHrF4ceAF7LUULWxj3VWKRy7wx0u/02zZhz7GhiKWEg99EiU+moRG3JkmVwAzm2UwShKDcea7ncSI5U388115HccXnT+attR1YKrMh8WuzvERBxdylmrqbm6Gi8JyylEXMlmHkUekhzwTIwIzFGrRJKfI4XAac66FqUFhnScH7Eakg2wxoE5cj9KbhIofXaI0bXF0OJIY/HkGf32wyN7VoR5IzaX+3ZwUyIRgtF8VfejBadtNnRTYcnxamIFHsCSqB6IB4oGAcNvdiur43xiRRLUDcx2bZJ0a7qQT5ekhiXLzqRUSBcLO1L3E0kq1/Gmw1IcN4Gp42PybW53EvN+nJOlQb7GKgRkdHnTQMalV1w1XQLJQ1GKg0NqIRnmEXFS3a4dKUSgxqmH6UWup1fqGhMOz8tIajVH7wzy5wiEOtY9W5IfXy9xvLTTLYLQ4p4APDW/yoEWJUPOKDwb9RiaiHlK6EogGXEt3kt17WEQ1gcoTLD6rsg
 7RfxZF3h
 ZPenRgBL+ZkKiIxgGhBm9adH8ZNnITBGZ74oYXl2fv+uqzXd8iwWXYS9ha+WcPHI7MjVpMBgH+OcAnvI3znZ8I7nHzNQMoNRNL61gM3Js15G581+GMddTDlyouGd08bhnB4eOudLwj9pFNDN2I5C5AJVd8ocPK10/AnrM1UdSSPBcvEcxF3IHhLsC64Fslce7oJPfwSDJfm/hr6ys4CnjxaEiQhZELUEfDDdyaL5PA0SBoClLOe4X5LmAr9zdt+y8EKHk7InwuHgqCqWgr/xAT/jb+P1U4fI8kumeTsVh5dYNu9rBepzgDi4sL4D9pu8FMOCHQIBe3007A7jG/xT4NSbW7GxmqUwAzYEv1Wz4pKf0thc/ccmekKTU/uaUL7iUNq8pUv3kah3MXVFfyemh6/IqrJoIwPvw1/8WhWzjmT06jTME7Palv3w/d6dyxG40flyGtxtUCM9g07UEheShdkmXy9UCgS3djsuHyCYOdGwiyvLP1aNvGhlBDQ+WjwmszJqsZwTdFrJ+NZIWaAUsSYhXkfoBRLBcQ+XuAoUpY2ruC/HKvTPihaq1FsN+Bz3mfHVGwwe/OQYp7P21zCPmQuJuDyLXYxE1qFMUhPuUrWIvQO73cfZsqtQNU1Hk0m5VO/zR02CI8G2F4zTASvXXTq0Oic/iBVUN++RR5sxMGcIQ9QiOlfye1TfgzlWy91BeQJ8avQpAeIvTxJSzYxQt/HQ9QQIS0bGsU1dctZQ3G8hAEi/aXG2lvv6A/Uh++1moUcM+WyG0IgS1MRpdyhS0oxZhGmhN4NVzPj0kQT5HsGp4vkTcoxbBPZeOnr0k+MPL+/8VE0J4NiCsQONOUDF8cl0b2b7OiJoIzUkPfw2w8zjcNE/2kJnsX9b8tnBsCv4UtAZ+ejlqsu1M3hw3XX4Io8xIFOijdJHp/G30a0RpdS5PMqrLABoygs/IjdddRR3F55HNraug6ZF35I9NuIG6gaCQ00jI
 QkTabr8y
 N7uEmZzJ4NehJLF33qQc+ZcO8Uc9DydSy2yH2HI8Y2MWaUqX2ExuaSEPxltAOhKAcU1RQWACErrlND8jbojrhNoCKNNQZc4VVhjk9Qyuy6cj/MJVTwp5LZ9jPB2YL5d3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+1957b26299cf3ff7890c@syzkaller.appspotmail.com
Tested-by: syzbot+1957b26299cf3ff7890c@syzkaller.appspotmail.com

Tested on:

commit:         241462cd ns: fixes for namespace iteration and active ..
git tree:       https://github.com/brauner/linux.git namespace-6.19.fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=11e1517c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1b1a45727d1f117
dashboard link: https://syzkaller.appspot.com/bug?extid=1957b26299cf3ff7890c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

