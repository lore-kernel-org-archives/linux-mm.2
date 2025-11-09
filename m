Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496C0CCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 08:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2858E0010; Sun,  9 Nov 2025 03:24:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A3B8E0003; Sun,  9 Nov 2025 03:24:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB74A8E0010; Sun,  9 Nov 2025 03:24:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B73808E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 03:24:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E2121608DE
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 08:24:05 +0000 (UTC)
X-FDA: 84090380850.07.96B7B96
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7AE3120002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 08:24:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3ok8QaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3ok8QaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762676643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=mL3FxTXejtzhr5abhLD58XcrwrPM61KGMnvXhlFjr4E=;
	b=ZuYLQseMyjcyulw08d2hMZo6WLRiYrhKuc7/Vnzy3vFQFlg+e+zKUCb61DlfeKV9OgsgT+
	4lpVxNu0urem6HpgbUSt8nGSYdMDo3SKraSb+GGMC2s0/j4UCwliKfIGrHuqssRHQIZJfg
	I0iZoIDSgtznfxSaCZTBSz0RCbz6aA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762676643; a=rsa-sha256;
	cv=none;
	b=ZJ/NuSvDznybgXkBfXDmtYWUf5GC5kO5Imf1zmSztQe8KfegeNXaa3bpCL2RPLGNoVL47q
	o/hAMjynDseMu74+Dk3U1ouIV9hBdf2kMwNlzDiRCD1LptJjfaZRVgi6j3GFRMZppKYdRY
	SdaDXVXmL/RQzHsrwJs6PwM3QZ3N6pU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3ok8QaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3ok8QaQkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4337b5c3388so10568265ab.2
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 00:24:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762676642; x=1763281442;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mL3FxTXejtzhr5abhLD58XcrwrPM61KGMnvXhlFjr4E=;
        b=H/GwYhQeylL+C6LRJvAU3GNAKP2Crs67yW6w+500safM2y91skyOetdfayZOd4rcLl
         gE12Ih4GujUd6iCjGyCvXlA1hdrFYN0Df8suL0KCt/aFL7wlDTpzsPbKQqfwGQBsv607
         wTb9lDcv5rFySBZEoObifuIuu983c+5luQHSG5/sHWxyYyvNSoSKO1MR1WYg3i52TmyY
         iwLUIK30s1xAK1n13ObfGQenh+QyaZbzNBPkvE693nogdznO2nK73Yt8C/y+Rb4Mu7Ql
         wxPkV+dCSwpy1ckkZhc/QT+0h6NeA4Armimk9LblwObaWoazNCu+GmvnFQ879w+oAJVz
         nZnw==
X-Forwarded-Encrypted: i=1; AJvYcCV1FCdzeVrHT+yLFW0vo2FWbEmoNzUoQYm/kmZXlVMSK382VV6pM7r+0e4iDvgE7/79HNJGkk5stg==@kvack.org
X-Gm-Message-State: AOJu0YybvlocCGiRfxJea6OEY9j8o4gP3eKXaP+7SIMXGIFUuY3GFsea
	FWxS97RFNYId5QKMG9uMTCVtjXTA/5ypAS+OS6meRrlq9blKiwXhp/2EMXc4qeWxNJ3T2lb7rM4
	WArRLVG8OFUEvJMm9FV4OJIV/p2jCEHA/GUcBs158AWNPb75qlKJUqywikpY=
X-Google-Smtp-Source: AGHT+IHOqUl2FIWzqMdoU47l5Gxi7c0kUdVzP4da94Ci7TzBLeLq0JKA4Ol0t1W4WTRGmKRyGXfPx3vt9pTfOQ1/fi74ObEhuKjW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2388:b0:433:7728:b17e with SMTP id
 e9e14a558f8ab-4337728b3damr42151785ab.17.1762676642611; Sun, 09 Nov 2025
 00:24:02 -0800 (PST)
Date: Sun, 09 Nov 2025 00:24:02 -0800
In-Reply-To: <690bfb9e.050a0220.2e3c35.0013.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69104fa2.a70a0220.22f260.00a5.GAE@google.com>
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
From: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
To: Liam.Howlett@Oracle.com, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, bpf@vger.kernel.org, brauner@kernel.org, 
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com, jack@suse.cz, 
	jsavitz@redhat.com, juri.lelli@redhat.com, kartikey406@gmail.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, mjguzik@gmail.com, oleg@redhat.com, paul@paul-moore.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7AE3120002
X-Stat-Signature: bcxdo9ddcds16cj5qqpn6wfnyfk5g6qk
X-Rspam-User: 
X-HE-Tag: 1762676643-937383
X-HE-Meta: U2FsdGVkX1/vOwAH05AD7m/Kp3iRsx8J8hPSChEWQyvfsYtuU0+rJDL9N+0iJIQ1tuPL7IroRDM9PQgpk6O+u8nxoiUEQUwPfUk38E8gCcWvORopQhc+FzvN0L1nv0nHYYN9hGYCEUz0DKq+WIsi2K+Ie66Pdz2BIqV/Dy6gtaww7TIOVEmmYuOAB6YzD9NWBokegO90YcwjfAP9bJGaRH2D13Zx4s7OSZVjWFES3ocplaADP4x6olGMeIAYioICTV/VbO1bLJCcnllUiG3P4slm/4+HLyaVqVSCxmXeFX/WLOLGmtPMZzSoiwJpipAFwZRmXpcJ4il8lqdI1I6HLIiqoKpwig80VSU75UJGYs4X5AuqViNwjA/7XOoYCFJLNjnwl/ad1PTaC/X9MZRkUv8u60lPsEwQJCpg68Za7CEGR23VnrLm1FUN2pBwxPSeiiCklieFyfExy0zfLb+sSJzFeyi/yejGCXWPIUVA+xC27EOaoRntfooHR3KdpUzSxeKURLItCsj7Kzxzu1KAUB1WQtRNs2YhSj+vvQZVWHvJoZ89bdzaSUyjKhubb6rjmZW5ZDl7/bKaRS4FTDA/6T1oknQKQ6z0M4RdS41NFLRvgbTHwJd1HKvFAZNZyHm6CUPZlgShQjpCIqbQ6bridLK4B/Wkj4OfaUB5NCxKnNh1yoOoYK/uzEiKeXBiwY0ifahdCELXKdrMiK2N1raw6uDwZZswun5rUXBZUH/x/RK+jGQmCVef6QdASLzo1kDztdbBf41JTh+ZJneQD6Pk1DBhwQCnKBjXV6qbzwB1P7ouwC25DcwuxG8ihIyVsMXohE0I2ZiKF4fkZgG7kITIgHtT+5borNT/pu1xfTzksWieecqmG21Bcg2s+Wx/Grdpmg/twACJrF5hth4iXkBZC9i/p4vzxHCkYgRz6zUzPCowKtLH5Yaz4Y3gOfPBy6VKSkFx29DW2IsPbRVtzyk
 xLKJFl9m
 XUC/gAxkgHVVzVjms9k7l80lZ546QI/L+5jcIILWOs/Afkti/LBLTe1XkTit3mz7+Xebg35mwQ+M3YpC6wjcdFj/16MROAnARehmBxS/105beHMHC90qJ7yQULTKHTc/VWeI/lm8LLkgMpjAgjXN8gwWjKewc2RjKaLzmDZFYhU5RzMiclcuwYXouhcTc/CE7JoB3Yf6hKFirj0rQ31Yxenw7wdzZIP/TTd4ksPa5AAmECtiIrjiz81kj+U024QSobFstjr3uGL3Tp64kfY/WVTjbq7+IFQXKIkMaqKBQ4PTuKB/iRtOzjQjm6o2dVjGAhb0j7RmNcnPBAUo8blBtIcj0T92Djc78aSxndgbkZMkth9flGt9HzzgnvXgp9T4bKarPFwqDCSNPl0QwRrGB5/gwUaDOskWQXva7aLOlpkpZfy1pBZ+ZAV1PFgr6zTQ1ybZ9qapvp/83bgw+J/v6M5tRYLbO2rUugyR7JDxG0we1tG8aFdbwqA/bZMvqE4/6v3pogvw/skREbvYNJn3wzt/Sxz/UxVOVU9imWxvrWn+qKnz/2cs5/7eDWddOZTSU6jwI0tnU15gMrNQ2DtXPgYT/AywGMwx6KFyQAmVqSCzSqJGM/BzL5CVZEnz4lqq1NTyA7s95ayY5LBCvcc7vH3WvIF0JNRNsj3sDRGxU3+DwUGwAJasjVGj/e32HO6Gmj2HlXW6t/VmDhgMFRDVpo7WcACsfUNWT8bGnqFHjIgAxxmbd4K9dIUfAMsDjFXdsPpeq8BsKFdY+zfr5JnWLciBYiqZ5oNTLcb1KC6SBWws+FEYzJaTVcOLgU0Ntfuv0n84vgDz8i10x8+Ub7qIVy7v9655FwJ/rpAefcbAE7bTs0cOykOMmVkopVTe2KJAXgAyxfwb/PB1+KM5vwNQYHHyAjQ1U9R2DbhC5RE6xRSAtq5NMAnhm0lJFqJPFknUYOXmskshiQl5a5anGBWvwCoCE4Wey
 IVRbzIFm
 mi42Q0pHvakSj/+39LUdg5tJqviW+8g/l7S0EuveMaoe1XBUKX52/UbPfRTvESOaVWPjuvC2auAQcwt430DnyW9Y+96wCzh9HKKRPhQqhLE1yOaiOerwk1lFrW8L/blVMKMkppB7BFbRlmpU/pOOjlvZ0tf+EcIjLbSClyHx5s5SYpLJRTfRIiaU3YPu0PAa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has bisected this issue to:

commit 3a18f809184bc5a1cfad7cde5b8b026e2ff61587
Author: Christian Brauner <brauner@kernel.org>
Date:   Wed Oct 29 12:20:24 2025 +0000

    ns: add active reference count

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11a350b4580000
start commit:   9c0826a5d9aa Add linux-next specific files for 20251107
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13a350b4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15a350b4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2ebeee52bf052b8
dashboard link: https://syzkaller.appspot.com/bug?extid=0b2e79f91ff6579bfa5b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1639d084580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1625aa92580000

Reported-by: syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com
Fixes: 3a18f809184b ("ns: add active reference count")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

