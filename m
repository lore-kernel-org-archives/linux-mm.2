Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3063606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 055CA6B05B2; Mon, 26 Oct 2026 16:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0055D6B05B4; Mon, 26 Oct 2026 16:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36796B05B8; Mon, 26 Oct 2026 16:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3EE76B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:33:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 488B01208E7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:33:46 +0000 (UTC)
X-FDA: 85365928452.16.740D2AB
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9094E20006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:33:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of 3J7nfagkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3J7nfagkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793046824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=5hqDsNbv3APBSI4mRAAUP+dBuR9Qlkm6bCI1usHEYVg=;
	b=Jjski7XHYKQiGkPslY6ED1t9IseM4GbsmwgwwOTfCwbUgpV9uwxHgpyyg9CK4g2TpHIKLK
	q2ZcdOsi9ypCnmsslwBBPbv1t+XDk1SzssDd82XTfw+A/OuoqFcsz89wNxzxiQ2rBhmgz0
	zUG+/U+O5PJxuygEbls1K194Iq5Ml6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793046824;
	b=r+IgggfZeApnk2NYI9q9+Ha0FxmW+8IrRS5ityeB3DA4s7zKNclaM8lQoZNRwOpO/sJSso
	tTcJkeM7/Z50b8QAJvXw36k9/mih7uP/+B14XUYdlq6TFjqnFBqGwnkfFnRCmM5TckxdP+
	ONcxbuPEg97+VjRTGLfD0RYRT5noBfE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of 3J7nfagkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3J7nfagkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-45ecb9dd589so2302527fac.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793046823; x=1793651623;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5hqDsNbv3APBSI4mRAAUP+dBuR9Qlkm6bCI1usHEYVg=;
        b=yiFg7T5ep8EIzeJgDKngdavsg2zgp4niHITsmOAMdgONANRb6OcNfXiJoyRSTUE3r2
         j+2VraYTNtc/RTxTnwCzOKLRrcKvpATEJrISMeoZqUIyfBlDA0JDq1nv3V2KhpzU/9zh
         blYHz79RnB3RfNfNgPs89fmQjIVN7UGDOsE1eSxUc3oWZq0hzbZ9DpVopvoUbYkQGp9b
         kJ70DO3OvWagtEmKNXJD6s5CvONKA7jw3bc3D4E0FZb3zIKMxUj2NnsDQWjo7qHkRlFu
         X5f6vsXuDQS2T24/ovn9KveIMwxxpG4BqKuXbPXBD+8BcCnekafwNdZMhXmk5ZoPsQhI
         IJPw==
X-Forwarded-Encrypted: i=1; AKwUvBzes4NWwP6it3rBrE/tsncGobzk1lyfk8giLy3dHOKAUCKaKxoQbZPEBk91g59Rzr3RxBW5w8Lhvw==@kvack.org
X-Gm-Message-State: AFq9FYLX1gPX3gTT/zJTsxQuaXxliN1vpe4jzaQC+VioSS267V197L16
	xgBffKyc9BlvIzKSrqXBk1gYD3JVA7U1z+JAzSS+tsrkXTIE1DjusohPgr39hwpflCzpmrL4th8
	En53WvfblbLbBNvu3Y8jxXbliTbI0Yt/mF5Yt3gYazmd+WYs4OQ1mWfq2oZ0=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1786:b0:4c2:5ac:7f9e with SMTP id
 5614622812f47-55c00384e83mr6236870b6e.43.1793046823564; Mon, 26 Oct 2026
 13:33:43 -0700 (PDT)
Date: Mon, 26 Oct 2026 13:33:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adfb927.3a3d6196.2ecadf.0021.GAE@google.com>
Subject: [syzbot] Monthly mm report (Oct 2026)
From: syzbot <syzbot+list72238feb199a0257ca76@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9094E20006
X-Stat-Signature: dwougij83rye3qxwnuzdfnqrmdrkbjo8
X-Rspam-User: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793046824-578649
X-HE-Meta: U2FsdGVkX1/wFQD0dLFM3z4aPpaOv6ZvnZh05g4vBivJVdAFQ0bxKaVgRvPoVDrRt7hXSgXvk6sC15XcZYLobUYGGioPdaGvWDYCV2rDVblrCpzsx3G96xgEiQ97rnEwjN6GTxlRnh1VZ5uAWuCJtCmqkX2KzDc8voW5tA86YdDWnye+Zcc+iFzV+l818cP2Rjin5KUbEAjMi7v0HePJtALLy2ytcwXagj4ebPZvzbcp7RXa6yQNF9I5M0Zv3sBby5fxWe+XSFIh7csPzIcBv7l5jUxgaGwxIonokPJZW3hi4MAr4D+7FeE+JlKNemyR6Gll9AVukpoKFp+m9hfSoF/Rg6SZ8NOeQnnHcu4LzfPWsFKzgx3PSsfMPM1EDONmN0kJSWssulwENYsJZVtsmybN/khkm0bQ8NIvJmh9emiqS1ZYqLM8JLDf3VNvMTa/YCi1CKGy0XDMkdATR/ogvfK/3awM21z4LCeaL5bNf2yJl+pUdo/ENC5udU7mgk13mFrShhPF9B0vm8eKWHhDq+1nYHGcHXfM2ZfU+exX3NyUH2sbE6FvTBRoIa6txJLb89kgOxpG5vIAVAJS+cvT46wGH1Re6Nwsgjq9TE313PL9rDSX4LzeJiKbvqWD8/i/8Qk5ECNtuMGrQvTWXWzkHHi5L06bwjXYe+6uPB9/Id+Z3HlJVS/crZPfkMNwSN5c3U/t+XMGXgvccHfkQV6ZNo6UNY7Uze11lmOZRDOAziOQgoHeaItE0i/wgYAJxA7PE0E+D35c+NZTQt1Bh6soNCJFVyFBV/e9tYlesuXyFlpcnJClB1FeBTpHqV0xndnAh3VnreM97gSIUhu6aAK/TZ6coprsMENf5/kWYgRHiHkP13llx8Ks/17gp0YB70wUSQclDMoe8j2Do5yvcBQWjTkQCSaXf8YlL+cixRmFIv+rZDveKnU0lB+GR47qAxZs4a0YAYCNumAS3CRbr2a
 fI6Z1xiH
 TQ2xyBdyHca4j2mvbMT3UNGftPglS/5eNs7JIxL2+DYuvkkuqBOzQKQsGdE0n8xYHChKvc23RURrKS2A1+pExVR25y/iDYMc2ERuf0PFghHtTqPHe6OQpOPYrx5wLs7sG4WP4DojqSQp+g+qdDBWH7Cz7IpD0cdATD3LM4VltgazeOypWLtaqN6qrmt5z5KiwAQJvBqEg6LmtysuL7jA1lNCdasl6bqW/9EYyFA/qRFpO1RTI3+2P5nyGaRPs+rt2uqGPc+iFQSUu6eK0kqayjfLS18YwmAhEjCjehtcs3isVJRhDq/xpnZP5ymJVMraJ9myOXFDIQzanarwneP2LSdeBLyoKjl7/2MLTgbQTXKP9TTrIpug7DCLaXYVY4f8X4ZKvFa4cm9ghJUs4RJXEmOFNWEM2UVZD03eSkwpVjQ9xUl1lzT1t8eGaDt3KSME1qFSd90vhxbaV/8NPZ2v3O3dos4cTv5BkgPTm12aWUQErKxkW5fqlbWJPsHY87Qb9Lp9znDoILyc9WvB6I1jH2yRA1023H2ZSGdNpSBcHR+OuN5Aszr1bcFJRgVQvvlbRWN3UfgsV7r+XHGvwTrlnzNZNsJL4ogxikvUIaSGYd2dy8TEIeEeAIHQjJXndNZlm20l85jhIz7auTXw/r+WO13RsSaOSy+KvG05wDxfIKEDycDBtdt16gQkDUQHgCOnjjJd1aAmdS3NkEBzYo2OmPsPUM4j8rgu2ImMqoNggngBieCOypUWCaeVOLI6pih8bp1YHsEWsSWsxzIbKFC4QDhn3GTSbEv4+sWEZCKoFPFQh61AGeLvae0EJqmc8IB15bD9g34DTeHWVjkR7AJYVnb0RAzyA95HxdNdggDticwRpFue5mbrQpYVs+RTvy/CKBdgy3rEN/iICdByaCVJyhfT3SroojgN8kcXU+J84rhbqiEA83YLyK07cdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello mm maintainers/developers,

This is a 31-day syzbot report for the mm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/mm

During the period, 4 new issues were detected and 0 were fixed.
In total, 79 issues are still open and 386 have already been fixed.
There are also 37 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  45812   Yes   KASAN: use-after-free Read in copy_folio_from_iter_atomic (2)
                   https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
<2>  4126    Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<3>  648     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c
<4>  536     Yes   kernel BUG in filemap_unaccount_folio
                   https://syzkaller.appspot.com/bug?extid=17a207d226b8a5fb0fd9
<5>  444     Yes   WARNING in ext4_mb_load_buddy_gfp
                   https://syzkaller.appspot.com/bug?extid=fd3f70a4509fca8c265d
<6>  361     No    kernel BUG in __page_table_check_zero (3)
                   https://syzkaller.appspot.com/bug?extid=2b5fe617654be3d8848b
<7>  324     Yes   kernel panic: System is deadlocked on memory (2)
                   https://syzkaller.appspot.com/bug?extid=c61d6962d0b7e698439e
<8>  189     Yes   INFO: rcu detected stall in sys_unshare (9)
                   https://syzkaller.appspot.com/bug?extid=872bccd9a68c6ba47718
<9>  126     Yes   INFO: rcu detected stall in dentry_kill
                   https://syzkaller.appspot.com/bug?extid=0635dc2e2c3c21a6aa04
<10> 124     Yes   INFO: rcu detected stall in sys_setsockopt (4)
                   https://syzkaller.appspot.com/bug?extid=6e61d59e9d2150c8492b

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

