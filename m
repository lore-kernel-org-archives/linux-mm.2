Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D42BCD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 12:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02076B0092; Sat, 23 May 2026 08:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2EF6B0095; Sat, 23 May 2026 08:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8956B0096; Sat, 23 May 2026 08:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD386B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:32:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F55D936FE
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:32:46 +0000 (UTC)
X-FDA: 84798623532.08.2C462C4
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67CEAA0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:32:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 3a54RagkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3a54RagkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779539564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=vRnEdcUd3I9P/PQ/ttUn9QBxGIe++AqYlsBjwYN87MA=;
	b=KHWpB84M0NbQof11e+JbQDTe9plwoDiBVMr0uTAx1fyZK6Fue8ENRE3L9JIRxkjH4XWiXP
	pXiGKy1cNjUOveonHq8sbhdoTdB9cTBfvuAfM6ZbmLbTR39olw7N6csslIA8nn73UzmsKp
	ay/C/h9UDfRNA8Efl4I2NVL52g6DOZE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 3a54RagkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3a54RagkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779539564; a=rsa-sha256;
	cv=none;
	b=YhpGZHIrZYgy5Kz3+cfD4IOw1ZXUyMnFdIUrkAfY5ShNQawKgWfX+JetDvmxzdv8uzMTgI
	+vJ8JO37xus5Hc0KZ6zMpDHk4g1Z7aqN8SBs3Q1tbRnDHrK8veXgvIqSRF+rw9sHOYPO/1
	hgppT1NkbGRilTj3V+zNtR3hboBZzek=
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e06cbc08d6so7595995a34.2
        for <linux-mm@kvack.org>; Sat, 23 May 2026 05:32:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779539563; x=1780144363;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vRnEdcUd3I9P/PQ/ttUn9QBxGIe++AqYlsBjwYN87MA=;
        b=Q30+3V2upS/oN82sPWCpv0XmPzlaMsm6Dbj+ySVLubcP55dPiar5A26wF6P1Re8tq9
         rMvMmACpjmQraDaryfQB95Jo9N8L8PFOZ/Wtzdbt3VbiPMOx7iPyrPkP9o+WwR9fZIQr
         ot2qP5JYqujm2rP94l88k+L25bdmtmdE+AJsBHCzTJph1KZjK/WADAMTbdopdKVH96X5
         aqGtp8UJVgssedGaao0a6ZSFNz1otJ0O/XzHVvXpm8sZ4YZvFwfaOvtjWBUIIPZY2IxX
         IFvBvq1MigjV77qKgtAkIjyIrvmMwkTePpWytencP0XaQsDp31gigxV895bEBp3cC8lH
         980g==
X-Forwarded-Encrypted: i=1; AFNElJ9PDIIYGWM63wj50l4t7lcw4KRAdBgYncadf+yJ4TpN2bxRqwMikQQo9IQPN0ElgH7oG2fjPNvh9A==@kvack.org
X-Gm-Message-State: AOJu0YylE9Ah0DW/gZV5+hSAOE5Ox6KWhspQcFaDsgRDtmXHFK5r234V
	uI61pgYPJ1EnzY8k+Q1KMJAFluTKkhyie/jNtwqArdhWOe/urd4tspGg6MEPQdOhbEnT9uRlwyR
	Ox6U4L4lgNSJC/5xAZYLyOiCKhKdiV5pS8/u2pIrn6XhQnjyV/SEVEYOHKmU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1a0d:b0:69b:569b:e64b with SMTP id
 006d021491bc7-69d7ec62b36mr4036256eaf.40.1779539563490; Sat, 23 May 2026
 05:32:43 -0700 (PDT)
Date: Sat, 23 May 2026 05:32:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a119e6b.170a0220.35b2b7.000b.GAE@google.com>
Subject: [syzbot] Monthly mm report (May 2026)
From: syzbot <syzbot+list6b89f8f9cf475b7afecf@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: eu3fj6s9q9tpx1m3bj9eey8or7pinrut
X-Rspamd-Queue-Id: 67CEAA0005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779539564-832482
X-HE-Meta: U2FsdGVkX18iX05qP5eWH64YuytctrUgtavBoUEc0F4HPiceB2Zxq4Oac9TGmWqHyCfaSbsQX8Q9PAG9+M1stc9WAXTsmjIT8Ain4h5paVywbeFIq4BjQM72ft12j3MDG/ep6fX/do7NFFEAzKsxrbIKaAlS+YWTuaOwhLSoQvs10U/OgG6h36CRXiCsVpHNPvVIIkRFu4DuiZ4E58yJWXZwzgSz5GjgVlZ0bRs5G2A81WjYDwhCUACFa9L6utz4EzCp4gCTKV9LE2/HDAHSLLgmB1qF+sgjJPQsicJnIquGMguQT91USYr18518VLW+4rXHgbweB/t/hvWQMQUNlGzXYOE9nCUV2aJVilZSo2oWx60aFoPy7Xpwha/xLM04gjq0zdnoJFJPBCQMSKPV0hvVM/ZRwnhh3HkiMw5CDFQo8sURMz8WZlBFV//XzAnz27xrE799AYpZeB/aUpBtwpEbiJDE9SQUtvTgeoif7Q+Zu9z7ufyzbaQaEsE7tMoCl3kDQvBBhNfH3MIRFzpi+IweEmFB+HG4z/LLd1WUFOyAxjTsHcdtx7Z2tJGxeV/nq4EePuPz+ocnghbm9ROtrQ9feABV+LtZqYpl1Dp/nF6Gmr2xPuUep2nWbJmhDCKB40Rv3QJgrRNz2RX7TrYMXSDBuOusF7sWyk5uqt6Lf8XFl4+gFOiNmllXUHqQU04AlN1o9aMM6BPc4E1wD4GmU1hOtey/66+fGHXsNECMOiByTcpHQcapaUDTqYHOwm9EDd2oyrNiUScx7utACP6hFPufHrLgzC5FBq3gEXptqPsgh/0nUdK++M1KCwW6mzXSuvHaCf1wUaBOLOYkmbhJmMzJVhGg1U8D5a27t7aRS7ZF6TH9DwbUMnDFh7Gy7HKIwzuyxqPkxpvuVa711EppbhOCQYeNAv1VxtoyDJKbYf4K+09YL8Dsc/AT/99utjhb9F1S3i9tR9APyATk6DG
 Ic06h5Nq
 0oGhWsUNpVd5lBb3a6kBt44FKFNDHia2N9Jsw4S07OLI9ulYf1YqXJu84OpPv/1ZDdwldwCeS+s8Yir/TQZojHigLv6qEe9JoacqjMEt+G70HehsWTyB9UDcD3u+5PdSuOCFionQovdqOxBciF/AmMxjCgjjvfXYZ65ZVBSSInyjLchhJyi/TwsEUIpGUsoz6C47Ie0wuNH+PDC6N23WWTeeQGEQFCTnjQucbu0mFl9aOE3oOcrHaipht1t3ZmYBn83SKWhV6BFelNKrrPo/IlVlfv4I1CM1Vbhjb6htm1gEGzm8A1es4dbvKLCitSfCp3LbGmZ/xwoUzfFvMxB3aW0VwdOWF+ZqcGOb63eqwXfRahPCFnfIZLclfecPOoWhRr3Drq9ZNxCVUN4cf4IeRlXevm86Y4snCO/vsFb38Hw2m9NB9ETBtTppIEVWbqnufnOiNJMYL9jivZDzCO68m+j7g2lr8NBbG0oer1a0e8ofYNWT47fCWRgrYutx96VKMh1cKLAvpETv2KburnP1BGbIKXzqmgFoDvmiTHR9ue0Pg3TBsjI7iOljxh3bkTIim2EHQ7CzWpzWLQIt5BAjKIWRyByfxlf5s9uA1pvA8iP/kRBlzHphYy3HMGfPzDZXd0ZV/RVezeKFemx2rzYoqxFwDPr7caqrRF4sH9uoAGOTB7z6+jFJ/dixxEBg4zobnouKPceZYgQ50VB4Wa93rycvH8IR9O9ZcL2EgJXj2WrjetJUZxSyfZ/6JC8HzAXlQz6kN2kwygfZpGJn/AW44LIFNLsR7+u9ojfnr3S+tb7thrUr597yrS1fH6eyonFsd84HP4spB+xShpC5Zd09SAknac0WVQfVdjw4sX3XTsmZ6h5TGiDYwiYaUqp+GezxpkDGwyPGz+Z/KeGiM6omfVISx3Zz+i2cyCj1br8iB73s7vV8JAQQA90xB+QHkiMu9xaPL
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

During the period, 10 new issues were detected and 0 were fixed.
In total, 108 issues are still open and 370 have already been fixed.
There are also 14 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  3645    Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<2>  1005    No    KCSAN: data-race in __filemap_remove_folio / folio_mapping (2)
                   https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
<3>  144     Yes   INFO: rcu detected stall in sys_unshare (9)
                   https://syzkaller.appspot.com/bug?extid=872bccd9a68c6ba47718
<4>  74      Yes   INFO: rcu detected stall in sys_setsockopt (4)
                   https://syzkaller.appspot.com/bug?extid=6e61d59e9d2150c8492b
<5>  45      Yes   memory leak in xas_create
                   https://syzkaller.appspot.com/bug?extid=a785d07959bc94837d51
<6>  8       Yes   INFO: rcu detected stall in kernfs_fop_open (7)
                   https://syzkaller.appspot.com/bug?extid=19d01f6082ec61dd45b2
<7>  6       Yes   INFO: rcu detected stall in sys_symlink (6)
                   https://syzkaller.appspot.com/bug?extid=e538d3da32f1c0337b01
<8>  10396   Yes   KASAN: use-after-free Read in copy_folio_from_iter_atomic (2)
                   https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
<9>  7470    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<10> 1667    No    possible deadlock in lock_mm_and_find_vma (4)
                   https://syzkaller.appspot.com/bug?extid=709f5ab0e03871dec50a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

