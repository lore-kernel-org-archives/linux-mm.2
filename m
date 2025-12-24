Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DFCE6B279
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 02:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748A16B0005; Tue, 23 Dec 2025 21:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5646B0088; Tue, 23 Dec 2025 21:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601926B008A; Tue, 23 Dec 2025 21:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7B56B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:48:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB524C1398
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:48:45 +0000 (UTC)
X-FDA: 84252831810.29.9BACF34
Received: from mail3-165.sinamail.sina.com.cn (mail3-165.sinamail.sina.com.cn [202.108.3.165])
	by imf09.hostedemail.com (Postfix) with ESMTP id B478614000D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:48:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=QeaZNOib;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf09.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.165 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766544523; a=rsa-sha256;
	cv=none;
	b=b8C03p2m+d6isDxN/7bfDvbeolgBeoeBNbXNA66uMgYHf6iShWvrUa3d7Az9tYoFT9HRJl
	I2lDUjXihkOjMQc4la6J7WpVBqNeqnOwBDKfGb6IbbirSYs7o2ZUgTV5BJSPJVSiW+4Px1
	F3xcUeNcIUGcbu06QAQQWtcti61AkNE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=QeaZNOib;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf09.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.165 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766544523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2L2iMFnLjxnuQkYAiC+sUNqNsivueBCtwr2xnlZi+A=;
	b=hT4EOD4xS86fLQmWKaSSObVo0dpm20UGQnMgvkzN9tCUv2YxT94HwBIfD9hkfJMG/65gWC
	spT5nvrFqN2p+3oBwQikYY8KGLq/Ds8darKqIbgq+qtSWp+Tt98ZRKvlXXm34zUFqNuEyU
	7TPY5Db8M2LJeG0+BaeOS/RSuNU74kQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1766544523;
	bh=i2L2iMFnLjxnuQkYAiC+sUNqNsivueBCtwr2xnlZi+A=;
	h=From:Subject:Date:Message-ID;
	b=QeaZNOibm+nehL02Kn88nhQwQPHR+WGC5DmL8m6leFvPl/iPlsBJ2vzeGos6M5sBT
	 CzD4V/O3DOVGH6LaPWAA4b+YRdROJyj4UTuHUxNJDCT1udLnTbScVnC7MqqkcmBZGf
	 bOIFsHgW0FpJSWABEM09fDZo3gQ4OS3H2Q2utCR4=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.57.85])
	by sina.com (10.54.253.33) with ESMTP
	id 694B5481000005CF; Wed, 24 Dec 2025 10:48:36 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 5629116685667
X-SMAIL-UIID: 80498A0643AA460DBABBC8D725F63214-20251224-104836-1
From: Hillf Danton <hdanton@sina.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: syzbot <syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com>,
	harry.yoo@oracle.com,
	jannh@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Date: Wed, 24 Dec 2025 10:48:27 +0800
Message-ID: <20251224024828.1792-1-hdanton@sina.com>
In-Reply-To: <fa4d76aa-e5cc-41c7-81d5-d1c0024ffcbb@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B478614000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 6hgyzdwjdapeexp7mm4g3kmgckrxp1ur
X-Rspam-User: 
X-HE-Tag: 1766544522-163676
X-HE-Meta: U2FsdGVkX1+lTECTUVd1jwslli48+DBFDvU03I3KjDyvbEZJISOqZD5+xM6rKbikGIr0HyZG1sFPnxRTy1Er7LOvX+hjS1Xzr1Z/Ufk1fn4zTBZeDyzRCU3qp3k8ljwq7U/yUdR3IDahF7MbwnQ/4rqQu8s42cvGjvyUKoMkz9fjJcFw0/bIskEoWgfwz40DotwUXjffbWDI/VZZqrXLXcYVxLEfE9J1cZy9aDctjV804vz0y/gxwhG4nmHUpYSH+lzmT1YODlgkpbwDPbgvjFKchlsRozfzIs3QNVTOOEKcH84hAWpB09BJpjQ7dMo3Lj6ibnDhVkP+CU6z+m0LyhlSb05UBKsUA+2ehHHZzdH3CSmWO3Ehw8irBsz8h8PY1qnUoQnjlol4QqahvX5QQo/7fluIRsDDV8/t3kEBko6sKA5d8PHSuEvyzxjQhPT/8/7NbG/u9xp9u+HuV2F/xJA080IdU6pTidgWVslyD93c2ZeUTJGvcdrrS/OPtWNPKeSUljQ9FcXpmwclZKblSAf0CBCvFKLinbeH3r4a5BSxNfD4sp78Ples6O6Cqhl9WVficdmhpn4ZKFJ23GxV5tYfdyiJJyd+Byw4bB4LjHg2cEIFzTyseGz9Ui+tHQ3nxgCeBSzJbNkzvqhxHIl5yNhVPIiJfl4B8XDpo7FrSIgODykJ+MgxfuOhrS9/XEh+UzwjZi/30hn9k8nl8dZNaOraavlvH3zDkBSPc5CYkjZMae5d0HVZ2Ezr69KVaLWVPQTsT7EwItpdIne4qL7BR6c3Q/5OQDOQdKsogv9B5su/ljhjvvfA2TsQOxZuzpL0Cag7QgEpntTnybQMfkOZ544pTJqgvWAwyYMznlzH02cf4p2buV2z8noa7B+G4GjpUK92bPHSephxsb5vdgQ3ZXSN2FTLg+x3m48c5fyHmnZXt3CU8vuarVDCNWo1xn8GWRXwOo4HlwaR3KHvtDb
 ECJRwwUZ
 LS6id5VDcg3D8refUvxNcz5nR08f4gLGf2mL3fhkgGQ0fPx/JK+XeniXVHmsZcoj3yke6MODNsPRl/tQMDxW7N+SnOcoEAN72c9QMJQjIyknpRRYzYGW/6VjSaKwtu1yG6pF1zFUR1nsZvyg3FsbGEeeu0o8kcvinJBHgN2tZahnuby/Ow52p1bO9HVCo3Y5AqYs9DDspbUSIx9U35/h9+kRZ20+d54GlGXVdJfftj2rBjHJAHmGfE38HRIlzIAkejdqhwoVow+WBBfKRyTCHPdWkO8SprBxaqSQtfLOES+X1HyJlQh31vcSTqECc4Z9DdWFbVg/1CXVMuq2QHocvsj0AipB4zUBXT3YPOitvYBWWFS80zJ8rCR4K7jIefRoaW2nKdjVnS8atHcTN26wdaZy4zaDFQujvn2oo8c6Vn4h3bBIkMPfu1XwpPe1Q7Yc0SuGk75jt7fba2t/QTjkwbnu4uju8pXRSiSQE+G2cfsHgd9hKSF/L4UPHp2uSHzIKKYjV6j+SgktXSen8vwEhC8So9wga3yMR9IZwPEyGw36HrW5i1JNSR3w7DP3nLrcKT6rMMIgR4YrS8j/eVSAlGh/x74l4sGjFD+ewANKFwSbpUkK63GJpfGdLY6PXVhNembNSozxhfDTYSqM9NyOD3IpUFKnkg7BwVGG0+jrH7Z2A6grkXV+Zm2dkguxBmkGE/k+q3JWm/q9NtTp6AmKDR8Ire0zenzQ1YMXnNwa2hvX41N+mbZPZspk0DbMP/tfr5WF3elf79HBuTMGB2amVxks5dFqaavIhxCr+g1206wn563RqNOxu1vHwDoQBtzdaPNHva4F/kd+zwPz+SVJ9SZEW10KruI7zPlUR6TO8uynPFCilAxOOOpuSusADOa4pG51U3nsDpbPY05m1K9H9lS2tThitiWltNPBsiflIFXg3IxpELsNEoNrCVmLv7qz1Lcsv4c85CMMZltlGdFnG+quYuDAQ
 3+gNWddF
 xaUq0dcFHkWXdiivoVS+UrB1/P6JYu+D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 09:24:05 +0100 "David Hildenbrand (Red Hat)" wrote:
> On 12/23/25 06:23, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    9094662f6707 Merge tag 'ata-6.19-rc2' of git://git.kernel...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1411f77c580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b165fc2e11771c66d8ba
> > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11998b1a580000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128cdb1a580000
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9094662f.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/5bec9d32a91c/vmlinux-9094662f.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/3df82e1a3cec/bzImage-9094662f.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> > 
> >   handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
> >   do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
> >   handle_page_fault arch/x86/mm/fault.c:1476 [inline]
> >   exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
> >   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > ------------[ cut here ]------------
> > WARNING: ./include/linux/rmap.h:462 at __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline], CPU#1: syz.0.18/6090
> 
> IIUC, that's the
> 
> if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
> 	...
> 	VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
> }
> 
> Seems to indicate that the anon_vma is no longer alive :/
> 
> Fortunately we have a reproducer.
> 
> CCing Jann who addded that check "recently".
>
That check looks incorrect given the atomic_inc_not_zero in folio_get_anon_vma().

