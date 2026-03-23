Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97C4EC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31CC96B0088; Mon, 23 Mar 2026 04:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDAD6B0089; Mon, 23 Mar 2026 04:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20AE46B008A; Mon, 23 Mar 2026 04:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10C936B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:58:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0B9A5BB78
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:58:24 +0000 (UTC)
X-FDA: 84576726528.16.1A1E49B
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E6E9140003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:58:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3rgDBaQkbAAk178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3rgDBaQkbAAk178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774256303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=c/5gNwsqZ6keKvAL3MpFis8D2ewLBqrP4VvO1VUdDqw=;
	b=OWlcwLQS8cTVRpRY+FZgxD1xr/bsz3f3wkSqy7v8/wFghSMk2o/a01dP5XAgmECrgAGyVl
	MCtIV9afKvnpD4xyVnUXwWl6pYr+hhTstNkp/XSRO7Xf4iSIasC68gAZr5mRyo++hLeWAg
	hWsfnlmxdsqYaXWREjT5VAz8D9bEyaA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3rgDBaQkbAAk178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3rgDBaQkbAAk178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774256303; a=rsa-sha256;
	cv=none;
	b=fmkUWECvqMIgvlhoD4TYuPLzF+afSIN/RjZMofzuqAE91ZXNEsD1JO02/Jp7FNeqynejzu
	pvbdtYlH7Kze7+gGA6dpEFEDNH5GcPof0UPOnSeFoxBBr1vC2G8Fk47BuLutHrBALnw+IL
	yRigzoSYfrwoUaet2Bma5+F4pRXVQjY=
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67defd9e300so4607123eaf.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774256302; x=1774861102;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c/5gNwsqZ6keKvAL3MpFis8D2ewLBqrP4VvO1VUdDqw=;
        b=f3/jE+eVpoK7erC7yG4lC6FrzjlUNPGiSqBfA92cMes5oDOd701ZDaRhO1nLgKfGBz
         knp8W89LgmTUAXJgW+dGMlVOBJQyq3xNuPb8hG83QX0uI8qSKUbUKCoaKdnNKo3s0Ih/
         FIXBhlDmca16VLLcJeSn8zAA+cJfZSiIJZPhcdVQdiOgjUt49HcIonifMrPq3xfETbNe
         sLwni/eUjZz9M0fhl58FB0M5KQrws7dCKSmj6AWB1WIllPyhis5yBCzJ2Fcmfvtd6NW9
         YUa92nMHf4hEKYdPfWyBUMhXD2n3AD2Sb+jHm+4PfNFtT5ZpWGjqBeybQIACp6h1IWB9
         TI1g==
X-Forwarded-Encrypted: i=1; AJvYcCX1aKm6nq8g6zQ3OOmwrltTFbcG6DM4KcIumu8p3j0XYd155B2TmCLdtNLQH6tWNJltVW5uuanuKA==@kvack.org
X-Gm-Message-State: AOJu0YwGDyCHN170oFdEEShBANabQxULa/hkfpu1zEt0Q2RxbP/g3Pme
	SWX0O/UBMS15ifVOsduxSRQvgouiCKu1MlFr2ZnDcCYgyFWPyvHdVHSwI3XmA2i0WU3qfNpcX3K
	1PfA/g0u6le8TOUIIudW7WUjrt+26kUv4j+tj7wLus8u5kX5/p+6VNMRzLdg=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:827:b0:67d:95bf:b51c with SMTP id
 006d021491bc7-67d95bfb7f5mr4632012eaf.2.1774256302129; Mon, 23 Mar 2026
 01:58:22 -0700 (PDT)
Date: Mon, 23 Mar 2026 01:58:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c100ae.050a0220.3bf4de.0095.GAE@google.com>
Subject: [syzbot] Monthly mm report (Mar 2026)
From: syzbot <syzbot+listb3c21fa3be7ade49d06c@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8zq7comzywajg5ya6hr1iaeupfxhgzsh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E6E9140003
X-HE-Tag: 1774256302-913490
X-HE-Meta: U2FsdGVkX1/WpIFcq0350kKF7jx7+OXkBMzhdG1bcu36meV39Rt7RiQfRvM1LT3DFTnlnNVvCMQmuV61hfkvFbHr+HksWxSciPszYnr+niZsjgIrdAumCVtuhtLiXw/NufJgVHfOq55ntV/f0lzlqlKAXv4v5KKu/K4ttzKG4x5aUktqmCu4e/TTXEG8K6fCBBVomJFe2y6ZpwQ3uXieMqUzNJi1aYzdctL7jrP1NSZop7yQdRM0SpCU+9uKTa5zKZPK1Nu38HplryBRI4SLu3sntWdFG5UHenF55yJhyNa/kzOoHN1k34PcoqxrsTHMj/BmT0Y3jLnIBrid+3CLw2NRWJX81LBJedZiqtusGNkKL9oSlaVCU29QSrLJ7Fo9EStBpY0U50Qz4210A789EkiZ87V4xqvzjsdvcKWKc+GVPjgIOWv5JXkOE+ZyBlPpgtcePmjQdmesjwjHxfWX1JhHVqWwOPMtvzBJVN9DM8Jl4EymBvNBPAuczTzL4eS/0GqBAQhGFOspN0kFoFtALyChKo1/klIunca3EAY5FAiq4iQdSo3HeCiQA7YWVU4BkkCM8SicsehKkcvQLXTMmyqA4de3jhkeuO1lzsyu7OlaSOcR429lgvHilkbTKhKE6eXXmDTLVui+I9DlJaL6UE3YWZSk/C3munUt28ROrrxByvp3NQ7+N0qKddysKahGKg+nvz8oMogLRgBkIC9WnKAM6Xg6Mng1w4Izu1DnIyTwWiKShhsq7Ufoh2NyIUI7mohxgfVu4xwEKP6yypozZi8QnV8ddWV4cB2pIPPZG4NBjFqDvHAV6qJvLCFZnXiwcdrPiZIKBNYeK7F5CIum1v5r9HeQVr1Wu4ocKYXSkWp3OZpyk2r67JnfBf6FBqHM+AbqRdj+Oi8P8kpZ/cr5ZpmguCXUBqIv+YiqVrzwdIeDn2cii8E81Z4KIq1igdsdkRUhlO2PioTAPfBbN1U
 813Zlf1U
 AJcSMzTdbwLsf2AEhbwM9uEtVURqZc9bxq+xMOzhLBwDZq/HO0YnNfQhBVV6S9e6t7hwKltCAIvy3NRLO0NYL78YZ3zxct/OAJSBwpN3C84Akz+d8NqXRGblxJmU7A1WvjR80Z2OXD8ObOEBrr+sQ2ck+zIkaveYv3njS5QUVeqjLImDbOYUOly25GaizodqkNesGxhX59ismlGMAa9Fre6polP+aXlhOmxGHZRCLkc8oprcp/WccdD93eB+zvs+BfaymsJurO6ovhxwUiTxY+Mc9haDXuF5dUwiXabm9g+Eh8Ki7HUbINR1MS0a+iGAQt3CigqOgnukiezYHADyAKwH5gXzJLO9A4Akx70vMFbQ7sNR2BhlwFqEXCtmeAz3PwunPf/+mQ2juilLfN4Q39vQH+fFUNFdBr1zu+seyepUryqRJAp2JRn4oqLEB9aY9PI9Att0EEZ1YU1L5SViuMTXc5fkeuW0J9+1dOZh0RecceIfeV/P1UgOzVWiLuAz0nTWJj0lJ4bpWNX/dSKf7lThzFFQycVgw3uTOFIhQW0SFIMYW3PKcFA4d/Ga0qGxVHr5lI9yRoq5I8K8A9dnoqu0hhKg7Sf/KPguF1bOFBjkJJndVcOoJ6ea5GwABLI9BfwdQszAURQy4tooicuERaqmQppQxDeyI2eWoD7Fdtnq09f/NAHeyMeW40Nt/cWlazjIfCN6BKdDc3VrPWlJyz8/itCrbMMpDr2KQ27zDPNls0X10lc5vqwP2c5R95UGegv2+nzM63dqCCVhg9TuA9r0DQAGD14xlXhb2yPjfc65oLJX8wvYLzpbMsXCKALJUT+tI26jI5B6j/dbwR5xlWsN/z2MKuP0QsANnKT560PJWb/rl17aMa+4gJLfS5VL7/tU2Kdf+256FlGgjwj+ACWjxr26QJROByGrCgJSndzl/Y+rYsApA9HLzIm5B6tAYkq6sxuJltK942zct2SsmHvsgKaXz
 TuEm4dQ2
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

During the period, 9 new issues were detected and 0 were fixed.
In total, 129 issues are still open and 364 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  20661   Yes   WARNING in path_noexec (2)
                   https://syzkaller.appspot.com/bug?extid=a9391462075ffb9f77c6
<2>  17139   Yes   kernel BUG in hpage_collapse_scan_file (2)
                   https://syzkaller.appspot.com/bug?extid=bf6e6a6ca143afea5ca2
<3>  7455    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<4>  3032    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<5>  1717    Yes   kernel BUG in __filemap_add_folio
                   https://syzkaller.appspot.com/bug?extid=4d3cc33ef7a77041efa6
<6>  946     No    KCSAN: data-race in __filemap_remove_folio / folio_mapping (2)
                   https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
<7>  687     Yes   INFO: task hung in _vm_unmap_aliases (3)
                   https://syzkaller.appspot.com/bug?extid=fe8f8efd070d727de971
<8>  686     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                   https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<9>  555     Yes   INFO: rcu detected stall in sys_openat (3)
                   https://syzkaller.appspot.com/bug?extid=23d96fb466ad56cbb5e5
<10> 512     Yes   INFO: rcu detected stall in x64_sys_call
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

