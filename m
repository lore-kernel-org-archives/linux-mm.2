Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61ADB606A33E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854166B05B0; Thu,  5 Nov 2026 11:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8048B6B05B3; Thu,  5 Nov 2026 11:47:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB736B05B4; Thu,  5 Nov 2026 11:47:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1B16B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:47:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3ACAA0B6B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:47:05 +0000 (UTC)
X-FDA: 85401645210.16.4D66436
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf05.hostedemail.com (Postfix) with ESMTP id 40B62100010
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:47:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3B7PsagkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3B7PsagkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793897224;
	b=5gtM4BTw98or18dObyNdiQy3X2jEtMwcnBA6h4ROcqocubQnIGCS95C0zDxyL67wQBSu5L
	grJZbYnlVOYiHMptSZSGlVng76D6X01lhlo0DteexPNECMfSDn6eRx5sUuh4yF6cgC44P3
	cgR9ipL+eMkLs6upLQj/VpKzIQstzY8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3B7PsagkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3B7PsagkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793897224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=hQVqdw1jZnyTvf6HuEzkfI/ea8a/7UEr6wdSrPO21uM=;
	b=RM+MBsZ1sHIYo5CB+RCdCephcDVL7+z5C2q3I3LjcNKZi3XFnMs/i19oqEWQwOnZmeN3VP
	X7K+DpzQ1IXiMgGTYWPqO41Bn4u6/CPi+HFQDTk4SoURAku5GFc+4rAzvK7GbK1aFWvMyu
	Ofo3tbmoPBqkqBhqvNbDHo+hFOEhNAY=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-55bf11583d9so1086483b6e.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:47:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793897223; x=1794502023;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hQVqdw1jZnyTvf6HuEzkfI/ea8a/7UEr6wdSrPO21uM=;
        b=q5Nz0ihO6SySK2WEKeXgLuCOl1U+4GXHn7Dtl94u2y6pKqexoG19T46cjSId1ldH0M
         BtCQdr4quUHbmze4JcrgDSW7eXD4Z/739BXduVoPZUWZ6g0iBix4XBhbegz13zfSeQPx
         yzznK1j5PzuxH4xBeAaFAVs2ttzCmUj6jZZX0IFPkGbAh0QHBbWZ1mZtW4Nfejk+gF9b
         N3CVKOd4borltJPN0a6rgbxdZemNmQkE2acbcaAPjJ9/6HmnvhVjq108tqmQ0JcJHVq/
         5V4H62veSxW6cxjxAuGhMW6bc0WjsE8h+vTrt48rembm6aOpcCzEVMsdQ2qG4vTdnSvn
         34bA==
X-Forwarded-Encrypted: i=1; AKwUvBxPfAyK9OSo08co61XFqWcVDPNWXT/lJERvXzz78hRsI7XkLYmcqwIaWNPXBvRm/Z53hvwK2sQQuA==@kvack.org
X-Gm-Message-State: APuU4Z+gPuB4Nbv2UPoYR64u07YrTGXfxzSOJy5mDBbc5PxsfSvbAxAe
	bMQ2db21HomVMbWt8/R11Vhl61nCDP8/dvNXrLKgOBL5b04TOMm/7LcOAuL+atYniP5YafLklyl
	ostE8Gpa+T8Ks+9+MXV78ezWofiby7NDHDFK5jaDjNq0yY58weXMzn/7yWWI=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2f10:b0:495:f8a5:8797 with SMTP id
 5614622812f47-567bde98696mr1829687b6e.0.1793897223413; Thu, 05 Nov 2026
 08:47:03 -0800 (PST)
Date: Thu, 05 Nov 2026 08:47:03 -0800
In-Reply-To: <20261105082717.c459bb33778fcf27e5675082@linux-foundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aecb307.a24d9935.80af2.0019.GAE@google.com>
Subject: Re: [syzbot] [mm?] [fuse?] WARNING in shmem_initxattrs
From: syzbot <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
	brauner@kernel.org, fuse-devel@lists.linux.dev, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mszeredi@redhat.com, 
	syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: m3pkeq8pdhk7p5p1xzw7zpfggkmjab4x
X-Rspamd-Queue-Id: 40B62100010
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793897224-56028
X-HE-Meta: U2FsdGVkX1/eNsLYE36UYDRyyhmzCvnPEDcJk/bNCq5d6SqUePs/4YtSORdlCHukRQWpRg4OvEVs7+x6paq8iGVnctRc4+Txlun07zKCWgMRMY65ofoZPPYl2mV4jAuNEnAJI+oUBmg16QDGgTF/EoWNgynJQ29n9mAvOzk/COELhTc+cTl6RuQSBASiHuabegG/JEew7s0Ng8iqdlJtybuCm/zTfoNFjwESanaBfWBm6CtY7H9TW8idZoialAhkMOYScGeveGRXebXNnf286UQhGJuMq5Hz5jygmMw9Lx9HDc/wyw+iGUZYUETo7HO5lyhn+MOKrvTMaP7tbPFxQOVdlcYT4n2AD/ZSdCMWs8u5keyvLah3ZbMK5aaFhAlToBtrJGrHGs5lj711lO5jJT3SnjDkrsunj+FO4NtJTuJ1pftZTVtP2hWj6+zONGBjoaOktu/f9u3Qfr9UZDibhUBsw2CNvR6AbHpOlTDBVj6bXSaIkxkAw/yOAhzB8POEhh1hL032qSjntF0RAkClv3jjAEaWZhcZ5D5TCzWamt2FmSIFaAfnqR+xHr7TM0bufFZcx+pET5B4FURTshOjck4R9ydJOfXA3yHh8AnXlmKZRw29OibGchfEdrh+OlrvwWlYdNjZowlSW2L0m/NUZqgN2kbdnc+0Uk6jn4h5hG+GhPmXgX5Lq16Ey+iE8Ll0e7iqE8GMf0Xc/LxaEevs8WrAzkVZZxZIWwOlrcOamX9+n1ksYPOsNT10iR9+WLqb/DneulXq98WBMLs6Dz/bu0OSUp7GQNFpuvHygj10ZV6WDug6vmXv2/hpcdK/3lZGMJBlY4LbefNIXprr1zQResKl3NGVvJHnyy/odxzBAjydXEelrCQxwfCV2PHq/QCQoiR5fWnA8hM+4JUo9dSEo7um5+QOv0gGazq023ZEjvhfs5cPoTo9fM5tV8r9KlcZt74B+I7RIktCpTe7/Tk
 WWX/ii/D
 r+5SFD5+cAinbvOtOzqT6hH57LeIkwUTr1HvIgN6+QtdIM5WeLpFVtOxUWtvqxjuXUEWEOup3Kp4Rf5/8fGFsxSbl9BFJwW9e1g0Tb8Td1yKy56RZuwe7SkfWdvPPCG8EPlPTsjE0eix2DeDn9G0CQp+aGT/wOPfo5BinY59vtg66NGg7UysXBWvjdxTU9N6CEf6eT6tMC/q2ZlCV5dCk9JO/RFMectIzrrmyGVJXuytN8H1+1SpcQLC3lazmbX4wQ6pQj+hhiMGvpRy5Kwyn4iZB+VHvBUNd+b4hczs2XAY/8BFeWI7tw4S5sshoZMC64yrdNbk5lLMZzpnk5CmTOpRZRL5Qr5P8co8nYKvJX7EhgIX2Enc/FiPoW6BDSUUw/nxxm7YY3k9JPVuxREzjP/Vzmkv+3xScp8wMNf2pok8Rc3tk44eCIfBNNutjDkQlAVEz7mkZuM5R5kr1zIgtBdYZ8lUCbxHLDWtXFCAy+qnxXm9ImoTekSVi2nncUuo5PUfBduw8yeQUX1wqtJlHAXV+pczygQbmtGbJc7+lTGqZp0ViOhTWIzoQBQhg+Y+nQ9tv2Rkx/z/OMugy3LP2fJZRNjR2L3gKSXfPP5j2ml1eDIsYx0KCeSb9NM8UO26FDqSDZu3Ad/9rAmI/9VpNSuaC2ozvZOXkbVc5YjqMbmkdaOuNvdf0GsmQhYpnJxlc0AdNJCtYHkOrt9ZrwpCpgv0h7N2p8Yy9aSqZ6DMMFPBjWdWkH1OqgWknjrBsdaRJ9Y8UK5o5EYvxNSiVQhVemk4OmxWQJXWm2Y9xuLqqI0F1JJi+jcNp9vwQb/rmapn6BfKyzLavQr9Zu6xifVMaGkgenTs0b+QYfgXiRX7TYbkMgd/Jl+ERq4TlqPUaPkLHwMDmHrnmbAhhPlyyU5vDHHGMO3qPf8qaUbTypfctgdVYqg9u4HzYdmaiBUWU3NdneS9DtY3yrlM2Sh3prrkQgee7Iwxs
 5oIJFu5s
 g0Gl17dAT2Ik+WdRxK3KoXsD81pKC270pNycBt6UimzXhYKTDf/e3vkUbdywKAZzfvlGKahj6kgswbK/C/UsI84GSGFsjqv0zNoz8jWaMJ/y0PNF3KZgDiIY/spN+RzUxn2UwiF0z9bNY6wkH8kp63ofP1MrzBjMw7tRmwoL1+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com
Tested-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com

Tested on:

commit:         05441d69 Merge tag 'cocci-7.4-rc1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11953cbe580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=4324f771847cecb27c54
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1624c98d580000

Note: testing is done by a robot and is best-effort only.

