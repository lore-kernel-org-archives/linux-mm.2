Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BB0F9B5F1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 09:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB8B6B0088; Wed, 22 Apr 2026 05:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C796B008A; Wed, 22 Apr 2026 05:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7925C6B008C; Wed, 22 Apr 2026 05:08:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63FA86B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 05:08:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE807161581
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:08:37 +0000 (UTC)
X-FDA: 84685616274.12.3CE2C66
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf30.hostedemail.com (Postfix) with ESMTP id 43EA580008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:08:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3E5DoaQkbACwaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3E5DoaQkbACwaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776848916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=LYvPI0TiKk2/nz4aem/zoaIZrTQuz8IPh1+Vsu94j+k=;
	b=Y0hZxvxSL8yEzlj9BtZaeYxQ/TJw1AIHso9MRU8my1kfW+sAb7qwInL378DZKndbjwcYbO
	iShayTzWbGQXdvbCCcnh6fkke4Q3CxueXd4SH4hmU9Hj30qI8bAneG2t2Ozhvae7on++lm
	VkunYsr7zwYEIWKhMbxrkBIBJj8mu8g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3E5DoaQkbACwaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3E5DoaQkbACwaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776848916; a=rsa-sha256;
	cv=none;
	b=fzhyEvBdQj4uPVfPcoCNyQwe9nowx1AYAOZl614WBSvpiFvGqOIzDRfIyKxRJyUhOP6YQ/
	lKSGlYMbM4b4GjtE+50IJbWq8jkTDK3pBNNJaAyNCXpVgWbU0WuR2caIDV/tslYgyOKNC3
	faYbQ1rA/7gQzqp9GeuHjNMelWv8JDE=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dcc59fe0d8so3451359a34.2
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776848915; x=1777453715;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LYvPI0TiKk2/nz4aem/zoaIZrTQuz8IPh1+Vsu94j+k=;
        b=Clw603sLHNnPd44SioN5SquTE1c2U+JZsGZQPQ/PhuBivCxr2uRMZwGZeMPE/QRkGu
         Yy7KZ5vi2dC3xBQFo7usqQZYIHCnFaGbNRTAyPhywmBhRU0QUKkHcTUnOSHpho5uCGtf
         2fHoViY/zB92jAp4cTjmrZHKoHtazuwXje2rE2vDXtDc6b83JLW3t2xyhwcONM6tr8Lp
         JexKXgz2sdp28tshOpNQwNo3H8u/7Heh84+I1IJh1PxeO2pWpLHI7AmnwloLjfIshrfK
         z4gTE4qlPxrTq+8D8Be1XYgqgKlTsphq5PtLIoGpUVhq6sqFD6Y5oyyiWPncoBacN/ze
         9Arg==
X-Forwarded-Encrypted: i=1; AFNElJ+0qT/Tw3j6j911gclaNVrbe5MNKkSsEMaaI+W8vPedkV8ZOI4Tgm5lgQz6pMvNp+lJ+p40FlKl2g==@kvack.org
X-Gm-Message-State: AOJu0YypL0vPffSFoRt9k0REyUP0XJfVPcepgA4Ytigp3PpDFOKSdI4O
	zYjmcjxAsopZGGJDaUeRZx3cwICjXm4SOxDH6mAIDslXMXvw3YUdMA2BhoDWQ6Kul9UDc3HfpkR
	e7M6rp9yEkCIhIOzCZb8cQbOYBpOXudruvO6p8/Eq1h4tbzoU3SlIxajeieo=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6702:b0:68d:dfd2:8da9 with SMTP id
 006d021491bc7-69462e21607mr7968924eaf.1.1776848915201; Wed, 22 Apr 2026
 02:08:35 -0700 (PDT)
Date: Wed, 22 Apr 2026 02:08:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e89013.a00a0220.17a17.0029.GAE@google.com>
Subject: [syzbot] Monthly mm report (Apr 2026)
From: syzbot <syzbot+listaebfd2e176cddedda623@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: u3es4u7pc75ij6o53b39njt7mmg87khr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43EA580008
X-HE-Tag: 1776848916-663272
X-HE-Meta: U2FsdGVkX19iPvhgYbngk40RcyAwlzh865Q/8YUSqVof1rmN64EHdnphXhqURupBkDp7QCoUdbwp0o8WNiC+tkNr/U6SR/Bm2mBLPA9nUMqTmf6GGSx9JakTGDnA/vIX2nIXo1pSN8LpLxw7WJzVKeok13PUxzkbbQzKFYYoMCxHqoR2fdt7DeTn324UzF7Ftu7k3RQZriJ/GELpilR5iRgXNDMDcXdY5dlnHl8VvmYe+cBefs9UL6IvRWStB/j+KP0HY5HVAu7AoQnqi2r0Q2NXR6av5Kab8uzQEloQR2kd1kuBD+E3S5lJFawXo5u1t+FVajbfZETteraoQgHOb9eKmBxbwtmRj0XY3CJhBLARs0Nr75KUuirxEFLBlvqX1D8tCMocWF6dzModabS71XPGhPPnK+it3FnmzQTMN546MpeOs0nIWm75dAX4gy8E14h0jx3yHAJ5nyNSeS5GQXEAtSWn8SNic2tWCoLGzkimMSjiQVJGPZXfk774hGNJH3YbFmIz7+W79l/vCi5gyV98h89njhlV4d/NRxvL0x+yO+NeM7hPKDxd5bQGEzThANmw8+kH3lcFdUNmXcF493E/Q1soydnukhaFUykw5PDYxfccpzCPcxO4PzaLQWNbT2q9oeq/R41b9gVTbgQZVIoml59Nj2zooYna6AGS1MPi1uLmjFiYKvSTQlLLTa/Yrb8yOURx5MlaywZldKb+kEWNxXREqwYD17EyftpKqO3HmcW3E1k1QKn4Sx1DKSxptCrOcKTarnZqWPpiYTwC2hT/KGKpnw2G5tXcngZvjHJbmfUaruONdKkO8HJKL1tsL0t7dkXJCKSZhKRsn7a3eJd+40cizMQUtusxD8Ej7klj1MqiO2WbA0oKn69T7Hon8gt7u5rNOnxmlHFDNX1ZJeuQl448ycZYwKxS+iNdLQk6yAEP+7iY88zgbZGrKKDOpllAy7tnSG6qzMXW21v
 8Ab81AUP
 OAClKlSj9lq3pwL2bQ2jJP3QKqwwLVThX9IKP8tWTJhixf9XRLUMbYjFu/x0Mqc0xZd1tMoD3PDIgxqK51uW4a+b9Vh7CjK6DvL1lUgdHiDoDNh1ZM/LYXRIzjk+Paz9SPw9+cxgddNgLkFnmkJkXfzW4npC9tHwc69MdtB8/8RhIVrpk6cB80y33EyF40WBeGEV5D8VbD/Uj2wWHJTaif7e4HcLGhooUsuR0M2xSzDXrhNmqq44qfZEAzpV36eOQ8gcxOVtdGr69hx4r/CSsdC4WrBO9rRiQEn4TBw2LrUkRjHZ6IrhpO2VnT/iKPCd5p8NfRwviqIkry4PEHiGtp0WhZoLWo+EJb5wZOsBUgc8qRahDVXw4eyH3XDS/w/W9oqeL8R3gE7n7Uisq7be4ymNy2ye//cAnX0xQg3ObA4SUOVDdreyrALJcQW4DHhz3HkYATOXywdhiNqlH7VESuSN4ee1R6qSc74LsDGIarAv41N2JkFDmny+FEIxUnXsjvGlvhUGGhBHH27M3ceV3H5RpkUnQjAHe61Yoief727Ja8EAMOkyKFF6WalwcadrFtZVm6ZQqh18nhcmwkcqbjIBtj9n/UdG06AT0Z+6aIz56UUSGtAvsGyKvpx0gRYuV0bEwzBuWcGqOdIM2bdHxs+WLzH/SUA8IY0qy7ApCIcb6eunY4pT1vYMK85HwTmbjnZbnL3WvBXlsTnXtZU3cn5D7SzSbpVg/pPjr10L5c1zVYjB0PS/YgH3xxEaAu4DRUBMFOhxibw6VO/OrhXLoUUGJqYh971Q0ztaNkP0isExLZUat6+tBlRCZgb47uVpSLOcIV0mdayMfOzXNJYi6s3wJPTZ3l1zfTqhccIvgYGj4PcTNRHADTfF0YdUevytZVopVa5K9u3YHEJjPlosMXb7HnjqAEyMVzo50vaJdrftf48/2604/jWnRaOnQPDyIJr5RZPTuG3iVRU4jCyFw3KhzvZRX
 tkdMdG/a
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

During the period, 7 new issues were detected and 1 were fixed.
In total, 130 issues are still open and 369 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  24253   Yes   WARNING in path_noexec (2)
                   https://syzkaller.appspot.com/bug?extid=a9391462075ffb9f77c6
<2>  7462    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<3>  1919    Yes   kernel BUG in __filemap_add_folio
                   https://syzkaller.appspot.com/bug?extid=4d3cc33ef7a77041efa6
<4>  1762    Yes   KASAN: use-after-free Read in copy_folio_from_iter_atomic (2)
                   https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
<5>  976     No    KCSAN: data-race in __filemap_remove_folio / folio_mapping (2)
                   https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
<6>  927     No    possible deadlock in lock_mm_and_find_vma (4)
                   https://syzkaller.appspot.com/bug?extid=709f5ab0e03871dec50a
<7>  701     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                   https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<8>  689     Yes   INFO: task hung in _vm_unmap_aliases (3)
                   https://syzkaller.appspot.com/bug?extid=fe8f8efd070d727de971
<9>  571     Yes   INFO: rcu detected stall in sys_openat (3)
                   https://syzkaller.appspot.com/bug?extid=23d96fb466ad56cbb5e5
<10> 529     Yes   INFO: rcu detected stall in x64_sys_call
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

