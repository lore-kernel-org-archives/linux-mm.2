Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C7FCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 08:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE928E000C; Thu, 16 Oct 2025 04:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5F28E0002; Thu, 16 Oct 2025 04:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03188E000C; Thu, 16 Oct 2025 04:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9A58E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:36:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C2B8C0218
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:36:28 +0000 (UTC)
X-FDA: 84003320856.05.7EFF589
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7E05D180006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:36:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3ia7waAkbAPYqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3ia7waAkbAPYqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760603786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=SblbsSfQCXkxVngmocYPkbkONIPvuCDleLX032/rk8k=;
	b=oEm4KvIlaZagAU78f2aPDdFisDYN8eIT8T6lxIXzMMvqP6RTBJpQXShE5RjbpaeFlbcPC2
	KuwEgxWYZqGAOrI7qz7sNIxiu2EcKXdaB8qm3nWh97JEvOqQXdOwl27mYSgkPsLrVM9hU0
	BkNd9VCa+O6r/G8faMQrU4WYSKQKTqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760603786; a=rsa-sha256;
	cv=none;
	b=xmSAjtsSA7JHlJSNuugy3bXZ5EEL0htWY0pjXcqK0u2x3/NAEFP+erHiuBE1BhCLy7Pzf8
	tIL+UnCMJBrQCh7F8cMNCMhfIwd/QeDaLYRSRzCOj1LuP/M7aAFptHN0kjhC0d2akKBonq
	L5Loq4W7vVHMvZpCgpsyGzssBPeoeh0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3ia7waAkbAPYqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3ia7waAkbAPYqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42f81a589caso14284345ab.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760603785; x=1761208585;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SblbsSfQCXkxVngmocYPkbkONIPvuCDleLX032/rk8k=;
        b=qC6/epIhOEcJEYXvr4zOvljU+0KIqM7hcmLeAVwh2pS9PW+yhtgvQrYyZmG2trxncR
         9Wkd0D8Daw2UHG/DWgrGUu6tkGnqNTB9KgEfNJwXGZXncIdfZd6zLpXSzxf7ZzzJMJ7E
         VSwlA3TZEy1HaLXepek5r4xfInxRDYOsQkIuoG6kJyYi8HWe3NjpQLAlhxmHsscxeRL8
         maNyWcrGQXaFv1VtS3ny61EbmMfgreFL5IH2E1VnUxnTrioBXyu/eqKIYM3ZzewCSajd
         x0KFOy1kkvnB9eMgyyR03q3AYBBkkkrgnG4i7t10H2F9ELL9xcPT/Q3jVcAJ+S1dlp9u
         KYgg==
X-Forwarded-Encrypted: i=1; AJvYcCU5bmxcm7YsfkjuPQLxP2hb2EUgZw1LdzHuUdMDO7IdGL3CMM9/TwQqpE4jcx+lm1XTvOSuJUNjLg==@kvack.org
X-Gm-Message-State: AOJu0YzIEYTHWjxKe0wuRYPGhX/lTiKxWk35KQ7/ex47CoLsSnX0BKE+
	cZgM+an77QexN8xaKJs+d2B86y63Z6zRDgIZkLSyXYUim+bWK4q88MwjDoQvtWh8x6lyWXagLE8
	bZJqmmiRCOuoiNZh/mKBv5dgwxn8s6BHjDbt2CSj7DalDPSbpfGsK6Fot/3I=
X-Google-Smtp-Source: AGHT+IER/95QsMONNzCVxGOjCiO0fm7rIZDRnw0mhgwh/04mcMDIkgzwvi3UqUCSDVnmqA8k0omRNWegCPvSdPod+M4R0UdqZaGm
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a43:b0:430:a5cc:c8e8 with SMTP id
 e9e14a558f8ab-430a5ccc9e1mr106444805ab.28.1760603785612; Thu, 16 Oct 2025
 01:36:25 -0700 (PDT)
Date: Thu, 16 Oct 2025 01:36:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f0ae89.050a0220.91a22.03e2.GAE@google.com>
Subject: [syzbot] Monthly mm report (Oct 2025)
From: syzbot <syzbot+list1a8ee4d1ea17f2fbcfa5@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: 84ado8j47djxuqnyrp6m4muz7etwrs48
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E05D180006
X-HE-Tag: 1760603786-699048
X-HE-Meta: U2FsdGVkX1/50hox+I2xyD/SOPmchgzvtpo/p9FbdGD6dNHK9bht/xKljaVZGUonPw+pQGZmsSUqgDGtbzJ4HrabP1qWmEJ8eWOwclE+NpfdnnRQXbn9uDxpJcwI2Flskv6jdRZ7XqUPjppvM6HuJJLOzT2YIAYn1y49EnBPK2xnnnayyLmZQSb8OJBfeUquvI34VjgMfaofbxsL1aKvG0BvlQGAJptQVrHP6HeAV2f+y/FMocMVcz8+pJjwqN6nTuJaOLzNY5KTH+XfxD7VmhqUZ13ovXY+zQ8UqgMTJTiyWWBW+MB/umz/If//itgFWz8U1b8PSTqa8qKGxsfxucYSnhoXzh2OELvD5JBpLmmSpfsi8UrG76TgH9eMdNuAPkG+a5pGj4sRsKUMG8h+1ZrVaMhMWfPBKcvy1epAfIP9ZoW/+uZbmIlj5GV4Jhww5MLeWbrMVkFo17kIA6HxWFdT9Cmv511EEqO+kRaaR2YC8kBgqfUAa1E8Dhlr1awOkFvMgpj+1BgeSXnThyl0w5G19FczpLxj5WR5v+jPZDatb4QgF0XleSMO4zuspuengCt9xDoqXntb78yXaX5MzEAHMs813/JUk4NTCf+kysCuQ+flu6ML1P6vsMIMGx7tWYP5SRvZCX94foanoD/73nVpqbJRbIrjQSdcY65Vh2t//S8dCiSghfQjA7vWoKLXLfJvGKlAQB+ZxpOrKpIK6zfUtscIxuzIcWJw8djSarQnjvRM0QxgyXA538a8F018uhXH6BZzg+k8vNsEm5CRwG3H4f5GxTcHDGFr266ll5CkgIfJhatRtXrNGBONoTB+atTsALnm4RV3yD3SsUUIYW2+ZyC38q0VprpbT5a1FSk1ZZ6bBCr7ARgImmi1EbyMwd86ZGocrRtb/jatkK21TZp4+ivSVOBxkIRONdI+eda2PXtmGzMvl/6zhy8ftO4eRDQVpIICV7RdnaS6kPc
 iSgcYXwg
 aG+XeWE7L9xmZPK0lRdNPOQ42DnbyXzOyhx8NWFNNV/RLHwMwG3ztCsLr5XEMVPkq8o2+kxgcej6UflAFMh8ZtF8bFYr/Ows1TGoGx5INVVPkhe37AZg+e6VtYZ22i/rCeEwssijjHooy/GYmIWdA1r5NRYelhjRx7bSGT+GDU4eDKl/dAWKGEtukb+rQlx72PcdlQqVUO4KmM3vLyfj7kp3bvB8AumpcyUlUt8Cediarn5K/jCe6hOEO+wSSkMIF4JnUFUmhtJPfuLnEeXxnucQMeNdJY/a/L6UhQen44UKW8Rwq0APoSicRlAy5LrX/mjjzWd93l9ZE5yhAZ2eVxshdOVFV7iLK7sB4n1/tDoF1Rz8mL6PtJgXwV3MXytjrLgWEKqNi61YkRXXMeVIpSQpMENAtpR9s9lMzafz31RGRfJfhjv3SbBHCbEMvJGeT7rqTNb4FK4QisD1xPOPImCwrv2+mpPhGW3wpXxWv7Re1vdD5HR/fByR8Z3xyuxFvjOWAci1qu5HpQf233CXNB2FfindpnMvX5VpPXVTZZdxDJHCQFUUU/eba9vYaK1pr6tg5iA/cu7/9nSk9bWgOYhHWHGtd3ysFBoll6P0ILd2zXlr8XLjCaKgxpcYkqstXP204PdYPmWhhIyxAc+vSzzppanJoafu/tOO/0x3nY/p4xJB0ZtvN3cNDsxSIdocQHDM0HnORK0c5KGdf2u2TMrHUsJdXnjN5q2W4BTIuoisnFHmpXzxo4gjbpImvciSX2QQ3FJBNNIXD3qxF1vtCms//f5mEOKzCAID9H3+z4ZIOnnxRWrzGSW8WQmr7E+8BcDY2bOEhnf9sUx0fWKBP97doyrNp41ll8BgiBgQyMkw8tvLjDluEUTF9zkeoc5UdD5CJKK1cJ/ZDle1BkbESO5wTmpS01X+gdM2nBHH65sB3xeelo3f8eb66nKSk63V85Bc/01pv7wo1ozI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello mm maintainers/developers,

This is a 31-day syzbot report for the mm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/mm

During the period, 7 new issues were detected and 5 were fixed.
In total, 117 issues are still open and 349 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  7428    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<2>  5678    Yes   WARNING in v9fs_fid_get_acl
                   https://syzkaller.appspot.com/bug?extid=a83dc51a78f0f4cf20da
<3>  2930    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<4>  761     Yes   kernel BUG in __filemap_add_folio
                   https://syzkaller.appspot.com/bug?extid=4d3cc33ef7a77041efa6
<5>  589     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                   https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<6>  582     Yes   INFO: task hung in _vm_unmap_aliases (3)
                   https://syzkaller.appspot.com/bug?extid=fe8f8efd070d727de971
<7>  485     Yes   kernel BUG in filemap_unaccount_folio
                   https://syzkaller.appspot.com/bug?extid=17a207d226b8a5fb0fd9
<8>  469     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c
<9>  457     Yes   INFO: rcu detected stall in sys_openat (3)
                   https://syzkaller.appspot.com/bug?extid=23d96fb466ad56cbb5e5
<10> 390     Yes   INFO: rcu detected stall in x64_sys_call
                   https://syzkaller.appspot.com/bug?extid=65203730e781d98f23a0

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

