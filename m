Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD1A7104BEC5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D538E6B0089; Wed, 11 Mar 2026 06:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35356B008A; Wed, 11 Mar 2026 06:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55376B008C; Wed, 11 Mar 2026 06:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A345C6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:17:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44CA713B923
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:17:06 +0000 (UTC)
X-FDA: 84533379252.13.AAC516C
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id 81BDF40011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:17:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3H0GxaQkbALox34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3H0GxaQkbALox34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=UnHGnobw61SFIXjoQkpFSTWAD2vDTpEuCDpynbfiFco=;
	b=PYArEG3I1bRd8OQymq3P5/1XTJPcihbHUJkAKCN9jrWshljWLLKypdvEsr6tcrC4qJL2++
	5C2jUId7FmwB56AXMl/lpAe9a1G8M+zXHBqg0EYCMMlTnygxaeQglGP8j24GMZHo+G+Zlu
	1Gcrv3q4hG9Yd4sl6OKdSp/MaSdIi/8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3H0GxaQkbALox34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3H0GxaQkbALox34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224224; a=rsa-sha256;
	cv=none;
	b=sUeN87Lj1G0SagFup/593B1Fe+bC63aqj2XyAYpq5un/CC5E00d+yEVCUay2ibsLLYooNy
	hCK5WZPsiX8tPZ9DbW/sSoC0ReIcK0Vf4WaV4/yDURP6YL/Za23ecBszNYajlFfMPt61Qd
	ZIiUR+DqOqYv6dLML55Oxc4UJWuX+as=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679c5ed0942so152880045eaf.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224223; x=1773829023;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnHGnobw61SFIXjoQkpFSTWAD2vDTpEuCDpynbfiFco=;
        b=a3u9AZ21lbgNkMNaTBfbub8m1r2yLm8d2RMr7GbfFTKywkC0ZCmRLJc8FgudPIiTDO
         R0jXuTZVUldtKQJ/bw1qQORs7PDMuvsDzSbjxNEs/ldjXnqfio3To2u4voXQz0K7O2Vg
         vq7ahzN05P7+G49qWnRu6Un6Rrwm5cbhhXLYpQ1BIysXVVCbYnVFCj3q1cxuGRh5X1Eu
         tBzId2Bd+AvmaGeR+GXMnb+BrwAJg7JXRshmWotD+F0GdOvMeMihigpLmvhfdSn1pG7F
         FMOh6fXHYWJU/RfgLJvRXeLfZ65A2rVaUtQV7CRrUyp8RBQC/27Cxuubwt5ORrEwsYM6
         vh6w==
X-Forwarded-Encrypted: i=1; AJvYcCXSMwUaSMT2aGqp2WTBCoSum25mX8C8YBQ5JNEXI5Qc1sduz+u0BYBS8kxa1a8klDKrs7qk9U5xNg==@kvack.org
X-Gm-Message-State: AOJu0YzQBczS/cFPsP+o2ka/2gEcL0v7ngw85Q1SVwczMNbPznBPi8Ai
	axc374xowUGNFLVWQFXdHCkB0imjMwbiRkYyOuwx1uoC56MEpxpBNhK5OvIbyD5YScBdnqn7rxH
	+bvzLGxwkEz1BDRG7s9QkNhAxlLGfO7fmUKUurWcuCsPNVMnNRU++sVUaUxU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c8d:b0:67b:c122:d2a1 with SMTP id
 006d021491bc7-67bc8995cbfmr1247313eaf.37.1773224223623; Wed, 11 Mar 2026
 03:17:03 -0700 (PDT)
Date: Wed, 11 Mar 2026 03:17:03 -0700
In-Reply-To: <20260311095738.4177239-1-wangqing7171@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b1411f.050a0220.209d0e.0000.GAE@google.com>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chao@kernel.org, jaegeuk@kernel.org, 
	jannh@google.com, liam.howlett@oracle.com, linkinjeon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, wangqing7171@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 81BDF40011
X-Rspamd-Server: rspam08
X-Stat-Signature: e8yzhtx3h1oiuuoewqysie9nueybh7df
X-HE-Tag: 1773224224-836213
X-HE-Meta: U2FsdGVkX18uzQ7Xaf9lE+twjiaoRka1C6+2ABcSMPA5pALdxEH/lXBg1XYzFnpRv0yxW5WYr8aFfIrodDnRHlb1NQyh7THxhQYQvIOjoB4AgPqoz3eWCzzJv07FoyPJqaVo99fodyyJkU/v0mLdfHs5Rpdu7Kz2kvKU/DKMEoCHEVjnttgMeBEmbrfKTA2HibU1QcRSYhp+3vv6aU0ZNwFTyEyO+OOBLIoiFPxnETM8aCe7vaxogasy9AHxcm969YEX0kPzVEKtQ2v9h9AbCdqEKI6qUa0Dvg5gUgvGZN6iXO42Otoqll293Nt5PW20cFykaW8LuNJgGrXL/WmtW+iWBaEwrvhwEzlMlj2Fqoy3qmBBf59u+GjNd9qVKpqkdkQUElWiWwVKyhXTadnYaPt+H6zRowhCc8frdx84NuYiHlz8Ai511qXldab1wGEp/5bbNBPPEBqFpIlI7qzCVFE1YW1pwpdfx69BCgOuXQhkvgkCb2KF6FzXKJO9qqTaObwXzxC6q0dRs6HIXwtYwIdePbkFdiNHXB8pmb4ss5KQrUICLdi88HqII6CyaxqRi7QGL382QM9x9NoLlylqhenlQCFr03/ORMCBUnQH0nZavJcQZ+dDxJzgeJcLGs03OjWY6kateIKIyqkOs4/LOcK/AI6yap4HmwNpwr8UrhFUed7Zt0EiN0aIS0N0ZsYtz1mm4FB+G/AsIIV+YItVnfkbRGkX8yDbkcYyy2D9y1IbaX/RO7zA8mcmM+xmtaYiJkT+i55uXTzM3IEOG8OGt2S5G3/Oadwpy/ytIgCOBsevtJVNtwz9+IYrg5hDG+HbqCK5/7GDNjSy4RyXW52o5YjdpKtR+k/1OVcueGQ4k6I38TyfRrSQfn+AM330nuDsD5/8Ii1q5gBUulIB7i4nqjalzm96GPzO25CO/NGdiniyyuFcCGxgH8iuTlWmSk4DWTTVbxlxF9Pj8i6ZO7K
 1I/dz7zO
 FcJdyzT59TO4do7Xp5rz2tr4UQRunDGUWObYvb45VPKJQ3pPelOlB4rD9ZCrFLQ3LSiCb4KBf1uAeYkPi4qEfvqyGiiNAydbNGUh6mo9QXqojLbXt/DRNmsEiy3MhzL7hXiJIUnwhvnw+/D7ydAd4UmWpNQsUzM7J9xFLRBQ4mDoTCREm6rzfvSbSnVMoU9ApQdrFWq5+hLiPz0S28bKsMSjqnqB7q2hnaMD7RihgMFQ2HMTqWIz1kQpVHAPJegB0LBFZaSVKBYRJq5++PubPPTZ/GX+BHmrvR8Xd/9kKjf8e2xrHq2smoH3sNyDAgQqSRlZb6zzIHK46u8opn3qGgta07Ldu8rV5/JwXd2Bk0gDNhGfIoydurPWfvt/bhdzhPWQSQHJR0At2jCaSAmgh5JCK6ZYPVziSj90smfvNskAJ3kT+L9l1KM0GFcayAbDS5dJLJv+oXRTPY2rxf4SKxHFE3zQ0d5SFRbUZYTblgwJthGF8OQmDoDCZVsoLOcGfA8nI02k0vZSPF+iDMOQ3JM1QFdpCP5Uiym+c7+85XBWrhzaA2ULv7fcqLQVSNuYcUh9O4/liav8yJOL20u4d0DCCoGe0e+Vc6oFzf3ZCLfC17oA5ZBkpD0BJiShFLkDq5AFMooAgNUtj+V1wcpIGRWErC8vNjOni0A1VUbcpr8UtjvmqwlYAqrXF4Dmtk2n5PEDVfuBZUjn2Q2dD7umdjOJFfGAlfZBScjj5KNfLtuk09yoTfZu0205jU7FMPLg5GBzaTAISYZ7hZSCV8G1i4A/kmDnW4A+PyWSYWULfAFwKndH2H+lkb+cptBOlVdTsXH41C/I2fs2JUzR4QB2BkUimm9xExQyi7qeJrTwzoN2TG0eZgezREUO2l3fsFk/QOSZoiNNn6+IBTQAH4Bi6X8bdtSM0uHrYRtPD9+sOpl1GHuDgfNE6Lat7mYyILFY7HRsdZAJE/51+MYAEcdW6hRoWl/SX
 0ulygIOo
 csUd5Rh89D8lXFuOao1Cn/CzCWe8RzB6Tr6+aUraWv/AGPZzHqe/Bzu0aYG6Ynu2JR13dwQOpIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file mm/slub.c
Hunk #1 FAILED at 2629.
Hunk #2 succeeded at 2828 (offset 168 lines).
Hunk #3 FAILED at 2670.
Hunk #4 succeeded at 4624 (offset -404 lines).
2 out of 4 hunks FAILED



Tested on:

commit:         b29fb882 Merge tag 'v7.0-rc3-ksmbd-server-fixes' of gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7d0fbecb37bff8
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14156f5a580000


