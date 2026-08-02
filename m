Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D6EEC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 17:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF5A6B007B; Sun,  2 Aug 2026 13:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497F86B0088; Sun,  2 Aug 2026 13:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD696B008A; Sun,  2 Aug 2026 13:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 152FD6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 13:07:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AECDA051B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:07:04 +0000 (UTC)
X-FDA: 85056959568.28.9D269C8
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD25E100015
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:07:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3NnlvagkbAEEv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3NnlvagkbAEEv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785690422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=zxFXnSoB4KgiBC0T5VAyA9bBTcGnRnLoGoYzvYWvSBw=;
	b=c3VwjQTsH4/ouGMcaaGrC+Ez/wrDNQGi0r7zLz/2ayY1G8H6CJVtBMGwuuyhEd/WA9dMUB
	bRpsuOFepFDOo/SH2TNbd6V3/kXrkVtAVLB8cZnWrqazx6BRaoLpOOxzYRpSW2AZ/wncFp
	1bc9s17EOOD6weCXO/9xaU716iPy1DU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785690422;
	b=19MCNHbtsWfz0ybJzWJcRfbYiy1vOsYPjeIek/7P/heDkxlaTnJjTv1DjF0gCDB6OcVxE8
	1FYfkIJR1/HJ9/CJyEtgv2qm69vCvhfWwQ3l+pI/Xl4vsEO5za5wwE3t9k2/c/lNdUFB7y
	J9mDutyQ3267vnky73fv+rsn6ADR1B0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3NnlvagkbAEEv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3NnlvagkbAEEv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49d4cb3ca23so3734033b6e.3
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 10:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785690422; x=1786295222;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zxFXnSoB4KgiBC0T5VAyA9bBTcGnRnLoGoYzvYWvSBw=;
        b=KzGImHKJDKcQnqcCsRvn0qPDcBMW7eiS3DCQ1GlJPkWx5zRczo1X8Lf7stPsrGby7e
         8oR/g7cdDD03Eud6CnYImweakWh84ZCpDziPAZ/WFfTM6xbtuuoAqF65LIMSmO9vJOc9
         VnAly5rS/nYajt2vJQMpsWCtnXjnu6k/EYDmdLT2Pesod+plLgSZT8cjlXtOvVBuhIOf
         8HduCG6dEEg1EQX2eKNuMcx9RMevgyqsjYEvrlukYhDaun5EdcFQQDoNpRwwE25Z/zN7
         qvfn1luDIZmYOWcccs5uafrDfIZGBno1UPBFfXHECyxw1vddUeH3ECXf8qHd3lwbckg6
         89BA==
X-Forwarded-Encrypted: i=1; AHgh+RrnuywUEmM0s8Edrs6dT4cTOO96d3FknB2vKqgC1/ekMLJZLi7Hxrx/XNFsa2AzZngiKWO9uj3/DQ==@kvack.org
X-Gm-Message-State: AOJu0Yzyo8i5k15ZO4rCeNZMWy1P7C+snm5o1Be4AQxzRNv4WZqvS5xj
	75+e2eDWeAKLXOdKqNF+BSB2NjC+8KuxQfo1XyQyhy7DzC0XEvQvrOqDyG3Co9IPeETJv+ahacC
	FpyDCwy2dp8SwbPcJ6NPZmTCKxjl21tgvz8B9r3//zPi3yHN8KiFfV7+iBmo=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2228:b0:48b:5dcb:85ab with SMTP id
 5614622812f47-4af5e07d704mr12408667b6e.8.1785690422033; Sun, 02 Aug 2026
 10:07:02 -0700 (PDT)
Date: Sun, 02 Aug 2026 10:07:02 -0700
In-Reply-To: <68dc3ade.a70a0220.10c4b.015b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6f7936.13bfb6d0.1ecdd5.0272.GAE@google.com>
Subject: Re: [syzbot] [fs?] [mm?] WARNING in path_noexec (2)
From: syzbot <syzbot+a9391462075ffb9f77c6@syzkaller.appspotmail.com>
To: brauner@kernel.org, christian.koenig@amd.com, 
	dri-devel@lists.freedesktop.org, hch@infradead.org, jack@suse.cz, 
	jhubbard@nvidia.com, kees@kernel.org, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, 
	sumit.semwal@linaro.org, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DD25E100015
X-Stat-Signature: xms9j8331jnc53c1in9d875mi6j3rid4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785690422-408809
X-HE-Meta: U2FsdGVkX1/QwR5ZnCFPoiHMEQjo79Avl15lWSSxuPKtQYb0HKXZEKIx9R0o7y6NdLWWfJ3Y6pG/0FbMS+ljNEfycSs0hkTUetK16/kHpGQ1znRYbUsr5Sy+ItdPX+Y+ALJYptB1c1W152ReQZAz9zfG0rOXDgYPA/yoliC6pJpVEK24GIDFmEKIDAQ85vOAQAGZnJNprP+JQGpbHGowgRenZlCpDRug26vILFVbJUCKDSQjtyCGXY+3nIQG+5TOdGHFHXMyYN6ARWzkxkHy5wOSPtQutgv581kkqb71YTfiPamiar9cZagxY1PATiKYqRDkxOJ8HWqIdRmlj4YcSGx1oPs9Czh5N/v7rkMccfkPKUi96UjuKXQfS8PEOvYU94kikn/0ZZwRpm4ivnQQyXGHE4MjQXjS3NGhfRLiZIXHcD0DyMgkcLQVXtJ2RCS8ivu6zLmijQnkVQ6qRb73ADNpvOY5l1Wu29e9Q0gMizJpgK9TgWO/K4qqsjN/H0ah9sbioU1RnNRR85b1ROxrOLgY9T+MlRVYvongULokYxkVTJrM/AxKa6tH2xklnega+O1KmDZ3Epujkd4uOkxtXtaTRGD5NECBGKqecQvRP1V47KpY1KtjpR4B5Hx87f1x93Ct7MZSjagcpziQn5MHDCxivkEuFTH5T0scOcldxEJyQJuuiHQnFfPhVzEZLAOMcNpGRPzV+4JrF3nggQ2IqgwRePNc45bGFPzRDGW34kguCQ+YznPCuIpgkFbFZ77EMKQ7HmsuiSzyL6d66vwLYmCQeCxmwccSO5HtHIgWCA+IGu5OYtsKk/X8dXw+VqmK5Ue/uXNPof8hVXXEZzL9ysFa45kYkjICSVyTjfQiKb+0wxIeABI+w6Qd3gVRIuyFhWZZWDGrlnIyNnjndDl1Mk440BqeyQNCn3tmG03vq4m/J21t+tzF7G2zREIAGaqTdHaoE4JTZoXVTtnTjwQ
 2bHciRrX
 nqlWtuncImGmqBz4p/FSFz8Rj2NHd/xIyW3PXdAKaAkQ5XLMEL3kVEZ3c5+PtU4gK70sTUzurR17MO75CIcHqPPB16dTBAe4HMRmDAnVzz9zLyKgJzAL5ObnM/zPYUKDy2efNqgJp/3alRw20MszoHjLOfZyjgQTWndDV15nc9igOtCXXkq/nv140AUTCtQVDXKOl9g5+P9URwNsq4lFwy3+GbB+CtN9+ytG3T2iOicxxOXTgqD2yIIFrjQdPeGjVFq7PGtQIWlPx5UXg/pK2zeWDkHrYAbFTpdC1pQvXO0pc7E28128I0dioyOQc/6v4qY8EvPKxXbXF7j2vbV1cOXjcD2rmSSqcEg29AHtKKDOJHBP0J11NJH5hN3NiHAZs9b71npiVqCTEXBPwGDMl9VxItAI0f9NSjxYWG02L9oMQwpwQbUo7d0vXEOZDFBFSaJSa5gTAYEW3fVxsqpoEA/eAE+Ce7HwEqwdTdJLbzOSdAn3+dHnQL+kYtQzE4aQns7b4K+7mrbsxUuhANt+6UCtSV2/uF6pwBejwkGorKDQ1LioHS/sCT+Xi8WaXrX5zQENoG4ViCg1+VfHJjKJMLzh1td6BsGBuOPdY6b4HUVJ0tfwre9nsfw4JuUy3tDKxiqoqUEYxpQH0r9T0Z2oVwcrqPIaxotxGy7+ZbH6vx55fH/LoHw7EFuJGNRwxrefbBzR6JqtELh2UF39kLlxTs1+YtU1Bo36trPt2AqGLGRlyz+2y8nZlBjKtgMIKgMXmbgB+cu9aDqZ1lb0AGLf8EezBvP0CYFDwx/8ZgtpgErSr/3KAJEavYS3CNvQ9Vu6//UwesArokR241oexmKFKLt7LtnhSpZ+Izuf/quY1riPxNkwi25mOf/QvIS514ZVPJ8W1zdxB8F+ueQEtlvn4/kSTq3tre+FZV9d6K2Qv1PM6KuLFqSzm0LhAoL0yI4Nx8qmZXi5VZmo6YpTmo88FtUoTUKeL
 lmpRC3LO
 F+/0w9cQdVfJTCHyEk6AB5H/goOPmirINHMklWbbIUhNyEaBiawl3uSmWE86K/bv2aqGI19Yioxd0mYpUsrs3NR3V3VAiaW4j/oKdQpfLbS31aFOssdKdETv7LvG/nhy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot suspects this issue was fixed by commit:

commit 6de2aeffabaafaeda819e60ec8d04f199711e11a
Author: John Hubbard <jhubbard@nvidia.com>
Date:   Thu Jun 4 02:53:14 2026 +0000

    libfs: set SB_I_NOEXEC and SB_I_NODEV by default in init_pseudo()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c53db9580000
start commit:   ba3e43a9e601 Merge tag 'soc-fixes-7.1-2' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=65472e27d1590a04
dashboard link: https://syzkaller.appspot.com/bug?extid=a9391462075ffb9f77c6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a08f2e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1697af2e580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: libfs: set SB_I_NOEXEC and SB_I_NODEV by default in init_pseudo()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

