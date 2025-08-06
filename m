Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA88C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 11:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2242B8E001D; Wed,  6 Aug 2025 07:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBF88E001B; Wed,  6 Aug 2025 07:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139C78E001D; Wed,  6 Aug 2025 07:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01FCF8E001B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:21:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40D8A1A0543
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:21:04 +0000 (UTC)
X-FDA: 83746090848.10.E43A77A
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8C6471C0006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:21:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3nTqTaAkbAKocijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3nTqTaAkbAKocijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754479262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=mBh7Fm82e/83X/4sbQZ9G+dmHp4LzfEOu4jtWqJqSlo=;
	b=U8hN3Reu4Ycwa9PRFUUvzlhDBs1ROpvtQyorCp5fXMdgkwtRb0YIBXZ/9YpTBZH9ynpEDs
	leNcoHQ+adStSCbuNk0HDxaXD9naZXVLVwr1Z5pEvbxvXwzX8k5qjjardGda4yLL7COpqV
	Z1R/rZhHtMR57FskY9ZX95O5vR6yfQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754479262; a=rsa-sha256;
	cv=none;
	b=Sb6EoyjkpTLinduOG5fMUfA6DDXuCUgW7CC6ILYwSVHdOClc8Kh1PkymbmYFtBNNd1USzi
	iGsODZPn8ga297fmBfmTbO04+xRQ6VsPPldcwpT6/nn9EEZjLGBq9VYwz+5UvO1fLv1abW
	eLvyJs89rbJhTpTdsoTcNoQ+U0pHkk0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3nTqTaAkbAKocijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3nTqTaAkbAKocijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-87c1c2a4f9dso1184589139f.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 04:21:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754479261; x=1755084061;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBh7Fm82e/83X/4sbQZ9G+dmHp4LzfEOu4jtWqJqSlo=;
        b=Jq4mtvu3v/2bm7Q9lgR0c2Nan/RAKCcB2Z5jCPIRRBaLnZrk1xFdZVh04y0yu8trhe
         vbsULuIcoBxjiAmcUizGKl6hlVdzZadSp2gxwJkE0daKhe45BDYL7POUSrGrsQYtSiF+
         8FIb71oRUPpSGf11ZGI3KWB8knO5efyadEB1CbTnHioB90JRIazTWMYzYmljvbqfzXlV
         Cbp+Vn2p0UtKSlhq8gmDffRT1ze/a5juz12oAxdpizq9rq9vZI4w+nEAMNcvLp91bPNL
         1RhXN/6OJY6t487/OxD+KLHiGDmfkhGOvwiv3gXX5zLUsJL9VOS7ZdTJpBOSf+rFMosh
         SMBA==
X-Forwarded-Encrypted: i=1; AJvYcCVX3679JLSvFR+S+zBCqJMiUMC6JkFvwk1shaYNMLBgOjyinjmFr7H0tNA2isjSiBXPheGMi66kNQ==@kvack.org
X-Gm-Message-State: AOJu0YzQVsHAPpfjNxi6NabILfmLOp0nqyANV0U+x2itAzHrV+nxRgNo
	EpSRBvmmmcUoXFtFqDXlUDgJeRbrenjUEl4niexwQZVAlKswCjdIkUpQHr89LNpV0VpqNvHse+g
	u0p7pS78c2Y0XpUvPw4Uo1fry+iKpJkhlexX+adrrOXrEXBEOuE4bNyOUHZA=
X-Google-Smtp-Source: AGHT+IEx/DgJCgjIzJR79zgzfgVyQw3lyABlgLRbYTaTNizDWSCd9o/LV1CtahpQZ7i0DAFsFnRtPKyE0y4O80UQXgd2oHAIlNyJ
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3ce:b0:881:8e2c:9995 with SMTP id
 ca18e2360f4ac-8819f113408mr443196639f.11.1754479261627; Wed, 06 Aug 2025
 04:21:01 -0700 (PDT)
Date: Wed, 06 Aug 2025 04:21:01 -0700
In-Reply-To: <68930511.050a0220.7f033.003a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68933a9d.a70a0220.7865.0004.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in follow_page_pte
From: syzbot <syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, dev.jain@arm.com, 
	jgg@ziepe.ca, jhubbard@nvidia.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, peterx@redhat.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8C6471C0006
X-Stat-Signature: pt8am491ecsc5hzpd9fe8nnxk4sesnet
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754479262-652564
X-HE-Meta: U2FsdGVkX1+6gNI1ngyvKMcKgVAUh4DccZhF3TBpAGruklx7Kwbz8JFB2vV4AaFJX7kiJAd8C2P9m9MP96UUOZvCKpTEVJ+4QwMhs0NL4loLvOxGMwSsPNoklWsgb9TJBEm3f3klwLE9r0V99h3JCK7juQ67jySTFlztLUNZf4kyJJxCnRmcqqBy990bv+kSSSA+OlDJ9+fl61OaRqaZsYXNQooYem7gSD5NuP8OP7+eRO7yuyicvo+xrwQB4KcVy2HRRK1dpJ9mLpb8PZpZP2Zaf7JbxP7HJJqhwkERKt65iMyLRtj+wg2LCMSJ0D2vmUzADZXfegBtXIkhiRPt/ORozAiwlLyL67padOkc3xPzJOZN4nIxdQ2lgZXnBFmOeCYHPuijpRgxj1HkT6mMyLvsTGEwAJBnGsd1FH7FXPk5OXR55R3Wgugpt/h9eaN8rHgboJzSzFap5osKyxBd0gNjpRz4tMD9RaJOEF7Gqcf+XT4YHnWwT4PEAqtXLtNr3JO+wFsfESM9Nd77F5zUShim7fDDvlNNU8MOLgRUoJC1495near7xMYRod4h88BYxXOX2sd6HxF8dhao2MvllIDwjG0M8Ef0Sz4Hcmutuas7kej+pu0y/OXdDgm0v4UPYJT0TEFPgLhVllR3Vv/W0J+TWlmEUD1O29fqyWntaVlWy45ZHdoW/6I0LbJo/nh+Qb8eKtkYSB7/JQY1giZk2AL2R5Hk1VPCNItGyADEw2js9xRzZ+5ftBVDtEmc4a/iQcCGn+H8+gcu5QbYUS0YctGbYW8lrV9iz9cTM4BLF8neY6jqWrZsBxYW4SKA/ZKgXiIc4RFYLkX/vVltkkRfnLDtPkf0nj4VIq6W7ZuhwQaX+GQpaFuULPU6GxWLZ0HynBJqcRfosM9Hv8Jbl7uiw0scWaZq7gwOtwOo79AzqAnB4xLiPGjXS7RyEwf1e9A3W0q/1nmw+mhcRPldG4/
 WnRtTSJ7
 OQ2h67bxdYzAaM6mZt4CpXERvgOA9chhr7ljrzvkE4THAGEmuLz8JF+WCB8oALBUQaLhqhrN+fyoIrNAfqiA+4Sp5PNVfLTt4Yn61xsEqcrU/u2DxHDwGmMmy+h65j1mwhg/d8cMw8gi/aAiHGUUlKv1S3Urs8fc9eRgoWGTlICVktOvfRISps51aOGK/sosLVKuqp2D27rOkffE3685LS7gXjcvxfBzTwOWFn+4udJCUBokTV+ocNNrmZeV65ybhWQ4NjVJtYIcFNAaop7vEv1hrwFRs4ysQIPnOqyE8dT94B485o2Ccr6PBjYgyNY9OOwsihGQz368py93IuTmnje4Grg6saL5XRnD40iMk+xtjwyBhROa/3CXrO5PfmqTOcbfLPsrRMBascZ6REftrSMWwkae7dibxi2vKSesWQ1nF7OI74myIUqgYiQzuLoU222MLMitT6Zzg579DtZfKP2KJ8NO9ygc/fVC83TWYrLpzhJh2f8njjhi4rU8szW1e1WjtrJWESHqpDsJuIqbtvZgrA7juwcOGSXWh63Rv4jfRyIznXVP60iAXL7X7QCus1BpTdBZoQ/j62nKCnqqhWk/wpwJrLkULFuXg74eJwq5hHn3ms+9uYQRJ1uoJDkGGtOneGPW4q/e3ax9NRNNwSuNgZYQeyku2YJb/J0DlxjufFOn7GcLM0fET6NDF8Ni68xVhT1WHr3BD7Jv0aoFv5U3GJwOvLsYvW/sSjYnxPM22AGoLcLqm4+CZPRloqH6s8urTDSNylf2Wbt9Tb8qnR1DzK4FkoER6uySXSKyGJ+by8PhCHfhwstgOgAw7Nw06WtMZou2ihhaQVvE2HFuFJ63DMqEwMwEfqOf3VDxziS6mil2FbFUK9ArYty3z8LAv/XFJGHpnYP3DD5CFMlpB4eMM+um4RaanipXhX6kmdF/czUN8krZLQ51cWbhZG6F2D3JSJzYCJjuSNt0JWFOHSTUz4nrP
 0QY39XpG
 iL1pJb1aP4mHVO5AdVAxfG9MCjpcm+ZnQU7M4PMcquxJWSX2sQITDX3u2/6GN4cqdA/9MXBmFPzifPdJlCHbZDcHGh0P88Cc1FJUIbKpdVqacqXo+2eoRjm/ltnY+/xASIEDezdpxW+47QWjBufwQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has bisected this issue to:

commit cac1db8c3aad97d6ffb56ced8868d6cbbbd2bfbe
Author: Dev Jain <dev.jain@arm.com>
Date:   Fri Jul 18 09:02:43 2025 +0000

    mm: optimize mprotect() by PTE batching

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13c746a2580000
start commit:   7e161a991ea7 Merge tag 'i2c-for-6.17-rc1-part2' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=102746a2580000
console output: https://syzkaller.appspot.com/x/log.txt?x=17c746a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75e522434dc68cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=57bcc752f0df8bb1365c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126e85bc580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161a22f0580000

Reported-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
Fixes: cac1db8c3aad ("mm: optimize mprotect() by PTE batching")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

