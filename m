Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6866C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFA46B009D; Thu, 20 Aug 2026 09:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96AA6B009F; Thu, 20 Aug 2026 09:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB9D6B00A0; Thu, 20 Aug 2026 09:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67EE86B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:30:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5837C012D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:30:04 +0000 (UTC)
X-FDA: 85121731128.06.18BFACB
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf30.hostedemail.com (Postfix) with ESMTP id 53B198000E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:30:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3WgGHagkbANMHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3WgGHagkbANMHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787232603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Zuse5bKsrwNJaMXcn2vwRNpL06e4Ab7iDiF20cDAlPk=;
	b=bA4A0lVTiBmb0rKW3swal22DFQnpEL/beY51Z6Kupnnzyxq4pUXvOF38x1FZ48HAPptSA9
	5icbJXeCa7XCkdCUSuSORjZwEo51mCpCEa4fZrscpk5QPLqW2QiHW2iuqZ7OXLdJiixA0u
	hS5bOXBWI8hC+eL1AEkdovqd/s6wq28=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3WgGHagkbANMHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3WgGHagkbANMHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787232603;
	b=6HPQjXU8jhpvwzCq8vcAQzNzRu9Pau8uW+TfyMRoAhpP8YShQJFeR9eJrroAhrPsxgFZSx
	+4049bN34fFf/Gp4I5qLYxH11tQrdbUBBOOfhpajf/NO+Lhg+k5DwmuPulZ9L7+Bl1MYon
	CHY5mICxC9xaR00D1jSsxYuBf+lm4oU=
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6b13533f948so2192565eaf.3
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787232602; x=1787837402;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Zuse5bKsrwNJaMXcn2vwRNpL06e4Ab7iDiF20cDAlPk=;
        b=SOAAl/CN+KSFi1HW1rjehRZ8pKyuvT9ek1b/Yfv+xYmg7MCC24MwcIG00oAIGX3yIZ
         w10bX7K4fFjdyxVC+GmvzfF7XYf3pgqYTfQvVcvDgDh+o11Jm00I8QsU4QN3NHXPqJMB
         o3rKVNiU006LdAJKrCJNg0j8H122byddSHcuYqcQdZM31MN7Bq/Q065OKoVT0oaqtYO4
         CEjQAZ6O1SDtIwJaL4EBseaohPheNah45tOWSASvnUS6dBdCmogf7bWZT/FQVET9BIQm
         p65wgKc6wD0Mg6i2I5UsKtm3BkPg8XgtMLz06in7eFmh0zwwK4zCfy/X8XkvC94GXg7a
         rl1w==
X-Forwarded-Encrypted: i=1; AHgh+RpG6Cne0swMNAYQdp+j3+ZolU7B/SAJKXFkkzhkyxHBT7xB2X9iFjTAPK3Iyb3Yy7E1jo6B3REAnQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/lCFcYEs79KaqXpz2TdW5j70qL6ufMILSYK53XciRNqc8z9lC
	cv+srU3/EZ2ej/MGG9zuc62syev/Orq7dSC0jV0nPLmlH5eMzRQtXSBE3TTmQ9TJ19/rEeScPE0
	wGxULfX69EwtDHtNuW/WSLy3TEF86+vwYeLjUW0veHpxTWLaSBUCjYaP1iFQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9c:b0:6ac:b6c0:2c09 with SMTP id
 006d021491bc7-6b13c2fd483mr11301174eaf.1.1787232602265; Thu, 20 Aug 2026
 06:30:02 -0700 (PDT)
Date: Thu, 20 Aug 2026 06:30:02 -0700
In-Reply-To: <DKTSRH54U1QQ.994L7IJ2TT3I@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a87015a.4d75e56a.c9a88.003f.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
From: syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, gregkh@linuxfoundation.org, 
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: pjbhz8bhc4sxbt83dz4rehow91gkc5gk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 53B198000E
X-HE-Tag: 1787232603-429213
X-HE-Meta: U2FsdGVkX1+z+WgPkJj/94q/249be+WHF31DjksXIHLAgQUFicDGkGNYTh5U1L7EU4iNGwaS7wiLToANgLLw0Tz1XVIwKoAiYDBE1gNBsqmsLqRmGNabewMr6yrCDN2mgrX1pkpVXhPxFRviwtK9js7OwHxX33jjxVAOpeX//sk8dW3SnF5oGSd0Y/ZsP8q0dkZG60fjGppPB2Yl8gCmVM0KOU0fGyl7eLfDxtuGihPtvUExKEL/NIDr8TONxpcjjCrsLBDs/+9X0F8gelCj8NoTCG/PxKVK3Rr973HhzdsXHsjMESZirLdyQ4CtF1WmiVBXV3GUuDl5Q6INAZ0+amDryZa2N9Aa2Dety6I9uI3D8NNM33JeRsL8KbF53jgPtrIbZbUDrUxHbzYer2OFS/XzIo50rvKH5jL92vwbV+obsi5zkoouYrpQazkisDMHzze25vhzvizCs7ozAOBqoN3ik0V5oXPmsKWry6uj/7HMTLrtDgxN3sBGjecZmHggB9L3OYrrfYa1GGmjJkb/mSM/ook2VnaGHKYdwl/AzM8S0G5h36o2ttbYcBbMUUJ0acfyvD4KFYxl0XbPTICRTSeXkAlXCuVZy1oc9rwE/jqjYm8SR6rZ+wMn1wR1jGlNZtTEmYsfQ6Vo5+txfmQbUpQHU8xQIveFROqRfxraj5kELoealvKhgMJbE9LaHYQFurrIKmjHPgjyM9aOb14RNvCWiSgZv4gf1Mp2b3iPUImDBXIhu01YGS8Hx9nuxHQsxfAWbrztpGQlSi4nCPdqKTv8H3wAMRYGJ0zVxRfZ/+aczfBeBP9MTBxMRC0XBFmbNXHsqEWEiKn0rsVu+/JqUt1iUZQIyZusjffJlg49AdHK6pxH+a0DZgfv9SjBWgmjnwdMkA8DY6gwIf/yYe2cL8IZw1mUPo+T5ISyJPNrW/uuW4nKpqKndBECwdienGYhMHpaRHwvSz26YB47io5
 AWhxATBp
 lpsHIOzCD5vTS+0mefOh2z+CrQGaaEjtyEOsjBNGMnXYO5nkKMPRRowoB6SeG8G3MRnmZ0Pt5hifapo+SIEMbnNVcONoilFj1R9SH7SVg/LGpvTLF+HIzskqK5mSLLuOnRaNnh0/3d+kymnjguK62wyFNP/vHmlsxGvt+hU88SZIfINdj64FgYaMkidRpTxZi4u5S8RxR6IaJPxOBuZNtLcdiKMwtCFhQlhz/F4FQWIlArSmpIeNI7bEnY591yPDvdee2OOgyLMPItKyieZbySJQ5qle1/ljb83wDKA7jf2g6sZ3VZ9Bjg2x/JB9NllKcTC6vZUo5LB3PKyMoCm3yxhUrxXB4VOx9rSrRFeNogCbIioFDJQNOkWcBjVXXdacGbjgEPRHVXosqHbRvgrz05jzbLCxW/iuhvzFJ9VNZ2rvEbKVsrpSim5laO/7kA7Z8HLATnHaUa/8R3/BZiF4yWq3DrFsqn/jasPeMtnQ3yemor27TeJ9Z//oAKxzkQ+0Tmac0WJh85y/i8JEA6oLDx8GDZXjFNvxl536EHSbMbpdZDixWE2gchTsqMCcUodsHDDFP4bQlinzbSfocsMZvSz0Nxq2cv63zLFnoJVv2uW2qaZKo/ZEykeqqLTjgmDA57nUvnWZbvdmQRYa+UCA5D/5u6Z1k6UAHSstbnprgVJJfluXxVyi+epFf0lH1YjWDBebB7K/pPq/cHMWSO/jnZi7pRRa2tvXaBah9IcSy5lKOBUy7vRpGUldG/ifDpT+nA6aE0Kzr78MKZNoGAbv6ZZ+I3d1YZkYI/ffKY8mDFoLsmQk60eebQ3Bb8hgmiduzs+gID81tquZKFodRPlqzIwyhQpF+DQ8wQBj1dQsR7P27QfWF94mBN91h8/crXYhYj0apAuqAPIYCN1hXQ85SpVbH9GlP0UNRn+dlRS7YGGFOCPzTiZz0G+T6yU85CGjudMWKxMXHDR6p0lmhS9LOQpwMz4xI
 1fo0dBld
 P1uHVWhAdE1CeZp5IFQSo9u1Czq+rBHIkb4J5/pT8zGc+jGYXIDX03KUAPdcoUd1Ovhwu72v6bthKDDG5Tj+gpOmoAAhwxRdCfTP80U1MT8A1y5kzBmx4CCOiaQ/Fzt1RgDBcoSQK8IOEiua4TgQfSNgaB5n7I2OZe9BNGdpFl/hGP6srxLTPRkWhrOIuAXLcY8JiLjuzS1UBGKD4zq8AYf1wZEHjMo8UKfv6wpFmpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com

Tested on:

commit:         a4ff2be3 Merge tag 'v7.3-p1' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=176bd679580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=29686c02180e4e86
dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1455f815580000

Note: testing is done by a robot and is best-effort only.

