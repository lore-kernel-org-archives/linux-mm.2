Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94715C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 04:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709A26B0095; Tue,  8 Sep 2026 00:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA566B0096; Tue,  8 Sep 2026 00:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0496B0098; Tue,  8 Sep 2026 00:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 434896B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 00:15:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3497D16035B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:15:05 +0000 (UTC)
X-FDA: 85189279770.24.FCF23D5
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 904F340002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:15:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3xoufagkbALcpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3xoufagkbALcpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788840903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=OJeGxfQ1cnO4KfojSL4gJl33/1+VNF6TUeyMxAp1vaQ=;
	b=YcBNNfHNVU4hnglTQdXEC95GqVWkpPBUxZHL66adBSffKFyg+n4/6hd+UihMn6Z+4wF7Pr
	NbUOBhcAeNb+8xTckzmKfLeh6EN0TNAs7UHAMeAonKOTVc4WOfuWmBqvBmBLxDzPnZJhLg
	7T0HnBZ0UNcLsxY53h+I+eYol6c9byk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3xoufagkbALcpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3xoufagkbALcpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788840903;
	b=1djZLSG/lBoQ2a3BTHKFcSlB+xcomVU1PwwX8K4sgHbeJsvgmo9/7RcSHkDYhyN2KwlBRJ
	1Kon8xMd6p8cUKGIoxbIc8R0EApk3E7LO8lIqdOgiG/Nzuk3DUnfaGUtDoBQPTaug4DmXv
	slYRGgkxF1sVlTDEnRsUf9SM8hOftww=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b28db6c77aso5003438b6e.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 21:15:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788840902; x=1789445702;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OJeGxfQ1cnO4KfojSL4gJl33/1+VNF6TUeyMxAp1vaQ=;
        b=n5QcT+MklYf9M2XfYjkF1t7RY+gj/WkCFE464DVY6SKxrTxYwCJTYyH14aNJtMtu4B
         tYjL3YPrxKUX7Zj61xF6BOgPBqMOGwO9NthwXR3GH0QBqXkALMQB9byBHVR+HNc9IVHd
         m0NdTEsHF57Zu4uhcziM/eIIXO6K+fLNtkHFbTvz1iyxbQl6xdhcaXQfmi48VlX37n9H
         fDNr0MWbCjma1fFhTu0yIM/FagLN62VnSYrXljpFwHrli4oCeKd6LFxJtr5kmtyCrdd1
         RZDNJE/m4FgjirfMj+avK9tw4s8Y6+t1MYx2sEWoVL9uietIvRXeTW8+YCYA/DnZxGsU
         chkQ==
X-Forwarded-Encrypted: i=1; AKwUvBy9AwPssWT3xmcqLh8gHiJu0jYq00fJqShcX+JArTPSVdlGjQMc1L7tSgSU0qUZgi1tFXh6zbUs4g==@kvack.org
X-Gm-Message-State: AFuF++mx3VL3siz3nuw+R/jh/aHzHVw1OsD+2bfd+CFMQYCB+5z0nMd1
	XQUzRCPeq3cvRhWNZ4b4nEqLE0g4z9dWKgnYeftJuzoC//CGrdExzqHRnBQFFp/iSyTq3c4RKE8
	7VPK51JgjO021AxRfG1PZmCPuxwG5SFo0EDs1/K53araJIwWzjaLhGEiKDGY=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:603:b0:6b7:8415:d784 with SMTP id
 006d021491bc7-6b78415d7fdmr12916161eaf.47.1788840902666; Mon, 07 Sep 2026
 21:15:02 -0700 (PDT)
Date: Mon, 07 Sep 2026 21:15:02 -0700
In-Reply-To: <20260907192517.564ea15aa8c9d47669b3a81f@linux-foundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9f8bc6.f614420e.2bf292.0005.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in vma_add_pgoff
From: syzbot <syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8wou8qs5qsadf1dhjafd7w97nzrb58gq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 904F340002
X-Rspam-User: 
X-HE-Tag: 1788840903-352734
X-HE-Meta: U2FsdGVkX192GZlMjLmBFOWJimiENJmraHWcrMSCN2tSdZfgwEy/L5GRXj9AaJDwXEDpuHLYh6RgjkIaLjzL4QCVWNM9+G/SMZ3zOQ6PEcLox8R06+GqFPc7Q4p6dlTgXhkNYv90C2hojftDTH7bD/xu3QJKdxCakAqTPlI+3Y5zWhx1759Cm7Fpnam9qayd34sLVa9Ac40C6Fa3f2noVMkYHflhpcF3cwoU4ImI57GZ2o3+eGxahGvESHxc1s6OHtXhZTaYAaA3u3ZfLFeEh3xnYwCsXO9zU0S2bVq0zt1N//prgnf7pNJfHFfsfw330a9Bp1MKU2lb+N3UDm6pzY+OIVLyrb/r+LvnPf8vMJCMCIQR+SK/iuiWecz9we3lO995OWpapJYRFh6aiFp5xc5GI39pTJbLvysXq0gMAgbhfszIGUcXMnVUDXTv/BVihBSRmHKcCfNtvdyDYCYNDdf8ONERH88+jzph/BNmgxbYvds07boa/3xp4MnP8FYiOhXYNJEro/BzonWxU9SMqkv+P+/ecyC7qmwKYNNyR1sa4re0uNDQ5aqPi/s1/z+wSN2NA2LZErvwZoPE9gOqhsNi+x0m5NqKg+Aj4rweXYJDtYXUXmIpGmY2H9otMOkyu+QyNEKeHZurfykjDL+QOM9Zw/C5VvNm8hEzZf4kckY0Vz/SSw0f1ySTa+/jEessbbZNDsYv/OolR8shaDMtQ8z3wIMo9uC3eetIBHmzimBxQqIKsaMkxuMairwB/UfyBNNfw8GacC9L9OYM+6EowMMxuoo5UdGTjl5OVh1qVvrMHAMTYVVW0bP/S54Ajt64OU+f9IqvaIFsEE6FEP3ntThBsRdraBdgbpt6r7Y4ZDfp5HhlFXzdOM7hY8E8PbY7vliYQEV4BvXy3qWXqCBJEUz5rGEJHwH0lsWsUkKQNwyaxZhWd1wEbBGBJnqCdMI1NF16UjtC71/J7z2zqhC
 VN30MWlr
 UNu9CjRMUtQ4jeYKKvIplIyG7//964luyBGUTfSr6C4nnauLBKT2MQ/x3mx+tpgRauy715Aj7pgzuotRjr/gCxQZjGNKBHj6+YRKH6uotI2K5nwpomJ3qGgcfWTs75XxFXQ766aq7KMajFF0oz500vp4IttVbsY/57jue7R72H53ivQsRMLC5kDI2q+1Bku7TzRkdF9fPsMWV54ib5M4Cxuf+XltjUXqFW1j8A6w/NiwKkx3SORC5FFUgxZY7xnKpoL3IRnMK2ahphyml4J1+l2oZm1x2Xnesu+tjP95sn7loZomzzFlUmETxXLktg/TSI/37laFgWfd8ANvWEjOqteSgl9fQY4/AGsTWQEFUAiTPeYESTsfQVEU5WhxMQ4HFN260CI8fRrEe2/3zk54Ro+gPPfmdkC6I23xWuQfY3pK67QR9FWKN518ZYmwdjmnkFZtpyWfqUC8vM6JikqMmJBnaGwUzT00PxpboMsbBNHq4C2iCCZ4W3Ja5ehYqCsBKLSZf4qnfhaY/5Rwiu+6DPgTNtedC9a7XRmaQhDyllaWxczK/yVi2HX7NH2IyDvGQlSBqMBmlbJntRyRMQMSGwrItqm5orxWX49DVq7Wj9BL34LdlAQzvmkiOzibxV9RcE+tdYxxH9aJorZebSYTAKOfxVFPKIBH3bg/pxBe8lFsmF5leC+dXOaKda9laoJAPUHydV1uoDTDoct5HeKddM+e1LAbhGFjCBs64I4yggLwR8MGeqMweK/HAdGRBRe19LL1gCS3n1MW1/E9Uun4XoQLYyQD5z/8A2ht8NuVLS0QZWkAnmv77ISy+EoeoWAOQLZFQC8CV/dyd+NgefDMIgZKStMGG2DvANMtdIW1qJIRPlzSI3a7npksBDWZeMrw4B9R06ige0HIrAMIM18q8o+IANyJpX2udS3wis4uR48RyHMf9tX8+O8wuoJfNaoP6G0TZNoABiW97r6V7Wfl1lSHaNjPp
 RZVtI7j8
 UoJMusOoKAHaVFiAQ1YWQDYCxs8slt5l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com
Tested-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com

Tested on:

commit:         35b0fb39 mm/mremap: reset unfaulted VMA page offset fo..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=15e13af9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
dashboard link: https://syzkaller.appspot.com/bug?extid=c6879dc677a017f0a21b
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

