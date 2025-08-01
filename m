Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB5CC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB546B008A; Fri,  1 Aug 2025 06:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C29E6B008C; Fri,  1 Aug 2025 06:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FFCE6B0092; Fri,  1 Aug 2025 06:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD006B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:43:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C57A31408F8
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:43:07 +0000 (UTC)
X-FDA: 83727851214.18.21B8560
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf19.hostedemail.com (Postfix) with ESMTP id 210A81A000E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:43:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3OJqMaAkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3OJqMaAkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754044986; a=rsa-sha256;
	cv=none;
	b=KUHFO2c6but7si+kXbjeP7GDvGaDpV+IcPgXx3BDv1n8cwZ7VUvVNfBWUAOeCyesqO1uuq
	aHUpf87uigxDMMZCGDDM/9HUjXANE8kZo6Tm7ezxcpratlZNJNY5EIkWjQKWgY2ZmGOEBe
	dFsHoJccr0pxBAEARc+hBekdZjdyOfA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3OJqMaAkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3OJqMaAkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754044986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=PoQsNyoD90if1Yi5tS33Af8CsMkfK/KVVhqGF8eskKg=;
	b=rztH114HChtjR41j5jI0bg4y7gOddMtaR8OB4vx+OQI1/8HRYF05PBpjm9cOcqckAYLDLg
	Ht2SzRSkSYBclxedmt61vaixcwf5hQ8n3QWn74PjzseZwoHgJYXDE7QU+m/L53oXaDHAJL
	SuiDb2ftu5vmdO2dsQP8Lut43YY+4Mw=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e3f75449b4so11344295ab.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 03:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754044985; x=1754649785;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PoQsNyoD90if1Yi5tS33Af8CsMkfK/KVVhqGF8eskKg=;
        b=EUUDIlg/z/Tg7+R/3nL94egWWyoYNv102jUhhs9nHQpKUswd856tN4FwYyKVqQW4KJ
         lOqAljiU8MRax7yyldFVI/UNAxDbhQp2eEnD1HLavo9xvApDLDxRtV3Q+7CO0lGLxZ5f
         zNemKHFlhcb09mbkGaUDvXKVb1GdXFUs7/v+0kjUX85XIKcmUxntiSmUUX21QsBDP0NM
         37L1Vnm4xpdUveGrOXFuMgLT5iaypC3f8m5eWOlrP3DzL3/Ku0fVZoZnQKcrlGohtwrg
         fTdXmqAGS/A3m+Z1+wcEIMjCxZcWyNAVvXLfv5GYx45g91FxL4GfNi4Rubxu/ZHIrqKJ
         +weQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvWVHwU/W9Gy+Khhfjf6i3FBJTylXlV0LJbssEkh1tcfTlzm2ZedZAYsbSjIRFPORM+6jmmnFsYw==@kvack.org
X-Gm-Message-State: AOJu0YwvUoUUs/Z/3vWiTB4hR3LBh/GjXKfmuKuaK+RrR4xq6x7Xhet1
	3lxzRfkXtOlGUboGWcS/KBxN+y7JQ/qYMP3TK+Dy/hG5je4foVuiHTpESA1MLUe1C/mVYqUUoVx
	Dhhsjornrh35AqGKKE4AndPAJbhE/ZJcBu4HCVZYcLSGPbq5gOviBIPljqFA=
X-Google-Smtp-Source: AGHT+IFn3GqlqczW8Kp3yLnyoOXYouUB0OgxOv/K5MuUj3oqnh8jvj0ofAx18tw0dUCUJ0q0ldnZ1QbnYxPuSzxZXHmarLSHq4TC
MIME-Version: 1.0
X-Received: by 2002:a92:c243:0:b0:3e2:a749:250b with SMTP id
 e9e14a558f8ab-3e3f625d741mr152096705ab.14.1754044984117; Fri, 01 Aug 2025
 03:43:04 -0700 (PDT)
Date: Fri, 01 Aug 2025 03:43:04 -0700
In-Reply-To: <e9f2e391-5c83-481a-9fa4-727c25922f1c@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688c9a38.a00a0220.26d0e1.0069.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in trace_suspend_resume
From: syzbot <syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, 
	bpf@vger.kernel.org, daniel@iogearbox.net, david@redhat.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, rppt@kernel.org, 
	sashal@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: todysqo9b88auz1bnifdr4dps8uqoap3
X-Rspam-User: 
X-Rspamd-Queue-Id: 210A81A000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1754044985-994582
X-HE-Meta: U2FsdGVkX19P+vClua6Jy2J17Z0kHFFhYSLr9zK9xa3cAm+PZzox9N2kjxV38AT9YGzACNxJT5R8IyceeZCm64oU8bWLeuG4UVINcv1Ib4+7xNbF2pkutHolHwFrz+fHt14Ia+S/iyyLQTosgTE6uwqDonhJ8wSkSpdlaTwGEfYCWQGMVO9JqCWedg7IFEcNyVeQX0yIWCBTP1y/avaQio5cfnndszd6HZ19rV96D2J8dmQeasNuSlmCCVZDEXLiTuCAJczTSmJgROVvCKJw+GCdhw14zfYHNY/o2v+s1rSpo5RxedzHcOtZ1UOjUcaWnbNlVDfd3ffkOCJ1/RV/ysJd5h7PKoOTCmIkoASOcCm6sMiEVz/ucbp0ZPgUfoAI3G07hk88KNaDWEzsk4GUn/LtrcYFfozHrh/nA2CZXDFlv4xnHFC1kaMIuXHVEC85kXN9r3jcuS0XhMf7SevzbodanM2M3TbBL8maOiAoUwVfcCVzZV0JNLJNVr5/kYLIiWXWjG48sLg52J0i8AwHLBQoCgR1RpR9zpMZKKfOhd/QUZLxxigA+Zy+71tV6fccjbBnYdGz/Og0yrLyKySqiO0UCoyzeli8/qmKEq1QL/SEmOyYOoG4VW9ye/87UkIKPdGyvNqZx/Wx7OiGqL6jLLECu6fhvLdmoehca7irGA+XbX8I8vpWkmgpbVCWBmr9AZK4IjxTjIhtQGBmCe2GH25TexOHw/FusLJQvbifjj63gKj/50Ejj42lrtG5vHJ9lItxWWcLoc5rdT6cyJkrdFRqX7pE2CCUzmwrQsNqnpjAXs1iQ4Cg+Lj2KIF2xhhehuQKvTnXLsIgqrFOgra1v31mWwE6+hCGHJAG2atds6P/SCSs/ESYNGc4dbuiyb2PcFBLZrmtAzqIWNCOsh7b1X+ETLKGJbn5nWsmuu+otL6pvBGBDV+Kg3H0MUrjLHNZh7vD8402rT1EqRV6j+Q
 GRd+/XEj
 ihXqkSJTH+qSjVNzS9NcHbfb8AP8RBLY5arS8SKCXs/SPuwZ7+2etQGL7rQsstohwaxGSEp+pzKamHi9e5ue2MVCtR0v595Dx0IB1yTm9nA7d7GoAPuSqz2PC5/X9VNzMBwy1B+NUNu8zjpy/8TIR2cZywQePiOYgT/nfVEVqAWWNPnbCoEUpt8IC8VJ4hLDWPyNRdqb1nZidbzTYJ0cI0Amul0gYOSfw7jLVB0xNQvUS7EZZFLVcJicTxTrD92ffxS2P2p/mHztPmA4ch+JzHTwLfbsG/39FOzeoNA0S6XmD8A8uR8xOt/fwnHU80U75QqOW8785ldpUwWlS2SfjLdLVeNXvujBW13VElqxvUX6csCL21emoStTh4R5e0UJEvnm8O0xZ51QfGmFtWPU/oMz0AXeELeZd6xT/SYok8lZFm+ZOF7xVn3mI68ZjW0w4HvgjlQh9P6j//9RlrHbTvPgy75NPdLoTvpMipEIEhOJELFD3tk3wj4T633hgKmmzgbhVtHCLuScbWy19ePzdBfe4vwlwLlX9Rql+QtWS/IiCfFGGwfi2EJrGgfuxTA7uFsPR9iADFVoZeRdt4kVesygYZeMoCwn2rdlXYHsU++a0TI83MsiKJ5ojZ8A7lE8CgeYThj6CILrXATOeUJy0TQAMxvZOvYi59mfrAXPbhun+2dWBD/NdcpIX6hPn9y8oyvVuT8h2us1dSXlDx70CMZ8PGgFAP9ZdXjspzPRR7xsWpjo1oc4tYipul81W3+atqvou+sgOd0/Y7aIv9mxzEjwo5JajdIdwpaReGlvoKmoSQx8oc35FMU12tKHjoPxdxb4gjZFTsY2qBP8D1maYGhJ8Ie7L3UoPOsz75p/CXfmI3HXcbFCPc1Lz1x5tj2K7lCx+jROl7OComhGiB6HDcxs0JWz+OIe2fQt76IHyNXuPsP5Xl4TftXFJ4wLMuIaU1kBObxXal11UhSV7Y41Jcg9hLx5l
 aCKT7AEI
 riNkp3efn7GBR2r4LqY09Vk4VRPa8e5MogWeGtMgGVx1/OE51l6nedtg1LhMoLxtTpKLFHCIknSxs20+rl9d65QpA3/xDnx7dxfuQh8F5e4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com
Tested-by: syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com

Tested on:

commit:         89748acd Merge tag 'drm-next-2025-08-01' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=114c39bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e4e0e50eb954bc80
dashboard link: https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm
patch:          https://syzkaller.appspot.com/x/patch.diff?x=135daf82580000

Note: testing is done by a robot and is best-effort only.

