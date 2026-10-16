Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4577ECCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 00:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257146B0096; Thu, 15 Oct 2026 20:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209016B0098; Thu, 15 Oct 2026 20:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149256B0099; Thu, 15 Oct 2026 20:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA4486B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:23:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7031EA0149
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:23:55 +0000 (UTC)
X-FDA: 85326591630.17.2C98D08
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf03.hostedemail.com (Postfix) with ESMTP id 839BA20008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:23:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=l+4BKTQp;
	spf=pass (imf03.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792110233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=btrJprSS194OAW2n6AQnMcqpIUNr9AAzjlrzl1y+2yA=;
	b=IIm8BGg08YIt0qhuxATHUNqEywDMx/fTnM6BbOkzS/iWY3nQC8acu1z74086L4QVk09HTF
	lDoxl3rgonDmVO0BeAhqtt3l96//Lq2MkO75BRPB27MMBNkF0pPn7E89XIwp8xHHIMwe/F
	IXtQELtwK1HOKLlV1UNItaAPJh2DT6c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=l+4BKTQp;
	spf=pass (imf03.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792110233;
	b=zwgJ6Of4nx4/Lvvq57dal/LFCZRIHZ1oiRQyNlVPliqba8GXWIAl2zIn+4fRIF9W0sO90s
	dnawIDbafsoQRIvu0jZixsQLdcahxDsIEaqjlAkAiTWaqEwpZ1h7z9pSlsxcFIyOvMnms5
	u4ZQbmN2O2Myf53vcjTUE4DAZxOaTh8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=bt
	rJprSS194OAW2n6AQnMcqpIUNr9AAzjlrzl1y+2yA=; b=l+4BKTQpNdNlwWQFiu
	BuDVrswfIwfI88pIRVs3W1EgLbZ29agEgU1aGXwpz1Jnxri+Rgj33aJV00sTvJT7
	5C+VfLImKOUxS2JWQpvQPpNb0BoIYZ80y37Klj2qFKNnDP2KeqPJosEy35nFE7kX
	iJF16pDDYx4fB0hLAZS0POZns=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H1+KbtFqgGZ0AQ--.60229S2;
	Fri, 16 Oct 2026 08:23:40 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] mm/memfd_luo: MFD_NOEXEC_SEAL memfd becomes executable after restore
Date: Fri, 16 Oct 2026 08:19:00 +0800
Message-ID: <20261016001900.4722-1-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H1+KbtFqgGZ0AQ--.60229S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF45Wr15Cr1UWF4xXr15CFg_yoWrXrWkp3
	y5Gas8ur1DJrykKw4I9F10qFyfKa1fJr4jvrWSgFyxAan8Wrn2yF4F9FyUWF9xArsrWa1j
	qw4Ykry8A3W7JwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5wIDUUUUU=
X-Originating-IP: [2001:250:5828:4461:5d0:1f3:be4d:bdab]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC9g3NlWrRbo1-AgAA3G
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 839BA20008
X-Stat-Signature: iz1tadmopcy7zjxpxw3ou473jfzzesh9
X-HE-Tag: 1792110232-705028
X-HE-Meta: U2FsdGVkX19nqAPUugpvW2EVEZUmBBiD/LMhrPXkgmhqqD/M+z2QuFNtqEeqId3lFG4OS1/ytlmluisgnICTCskpEVijfTDRx450EMTunSvzJpGy5tZFhXNcjlwZDyzSHMDXMwIbm5wfr2x637UzTfk3D+Ox+dTDyIm7gwPh3UdCljxAkv4KR/qxklyom+bsKkmsYfAtVLDAIq0qQElfi100yWePlDIkOugcx0sS9dhv5EpaaL4vu0U4LZEV0apksy0JLvDWr/XLkrMF1thzwPUfeKCRHWHRofvAOZL+JJl9srETMdiOufyQ/EZYZFUqkit2+2YN8dI8Lz7DnJHT+kbGz1e/hrgGljz9uvyT3nooT8QImScAQ/OTy0vlSAs/9DTMll3+7ig0rfNYuNeDNoOCCZABVx6h4V0GTWXOXxEdbWp1Wzu6Cvim39RGjAU0prAYMo6w+GWmugXGrj81SB5xsxLrA4SPgoL7hjPvHqHo9VgBcan0VbRuP97G5w9LZllM2Ekm4ssTBTs+r54jNTAc42CwzMGAa3qE263JkRJjqgRqfyZwpg5QxxiKU3vf34ibabYbHXJZX8bzdVM5dcqDTKfz9ombvtXP60r6qAMuRyxn7uX0BjPgDQ5RAt3FhWbff6mRE8wX7G/DJAJWSIzEvwEXWzqbMfbL+yV6q8wwLk+tTiY6Ci2lETJ3gfrCIsnjvvg6SzPRipqVRvF9l8WyofSCs8bPqRV3sXb2uSCH6F+7cMdUGVuY41YoGnMvAdZRWoAqPlfRBvb0zXQ0FksODDL8nvBhp/3VDxmM+kiNRpNlA6mNPNebbNPSYPcgm2/AdjZmIwwg8OVcS+ns0rwJLt/vGo17BOl0KpaMEH8UWSmRSMnlvNyMxQWXamMeWD4Ih1KQLG+l4Bcma/DIY5MuYbMZYmKf2CijNH3833pKiDaRK7Wmzi7660BBnyNToZJTiYj8KtQWGWxbj2W
 EgI+cbxC
 0DtW+ogLmR5X/Xz0PeAe4JxU2JkBIqWsZcok/9K5/0MxlmBM3y3l4kz1Jt7lbCxSMyYuwZl5B0Hn8lINtAQgpPhNcPzmV/imQrND0mHxWX57LqNE/kdet4J25oKPabxlRs/ZkgCSXiZAyMs5CXoOTPYxtTBX/xmYQ2SRs8iHwZ7F1Z2NJh/rFqzBjGT0t3Bn2XTFiCVSO57oSyy3ZG3hDLGQmpRtJxoNzmOsuSJrPb9Ul+ZY8w+0YC9Heb+Q9M0ElU/psCPwAyCs+fPehjEzWLwqutwjO5k8B01LtTWOpv6jikjfQGjcgwyYDjszs9ll0Cv4dF767jcN6XAYecON6+nM5zNEIxyurLuggSnL3dvQQ18DlVJRn4FYMb2pG0EyIQfRnhkwelY04r/d0mt0HS7JaKv40Y1+VDsWq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I observed: LUO preserves and restores the seals of a memfd, including
F_SEAL_EXEC, but it does not preserve the inode execute mask protected
by that seal. For a new memfd created with MFD_NOEXEC_SEAL, when it has
not been fchmod'ed, its state before preservation is normally
inode->i_mode & 0777 == 0666, seals = 0x20; however, the new inode
created when LUO restores the memfd has default permission bits 0777,
and the seals also change to 0x3e during restoration.

Although the LUO documentation states that it is not a completely
transparent restoration and that only the listed properties are
guaranteed to be preserved, I think that preserving only F_SEAL_EXEC
without preserving the inode mode, or rather the execute mask, is
somewhat unreasonable. I am not sure whether this matches your intended
design.

To put it somewhat imprecisely, I think the LUO mechanism may bypass
the "no executable memfd may be created" expectation that
vm.memfd_noexec=2 is intended to provide.

The analysis is as follows:

1. If we pass the MFD_NOEXEC_SEAL flag, SYSCALL_DEFINE2 goes through
   the sanitize_flags() check, which may modify flags, and then enters
   memfd_alloc_file().

2. In memfd_alloc_file(), it enters shmem_file_setup() and then
   __shmem_file_setup():

```
	if (flags & MFD_HUGETLB) {
		file = hugetlb_file_setup(name, 0, mk_vma_flags(VMA_NORESERVE_BIT),
					HUGETLB_ANONHUGE_INODE,
					(flags >> MFD_HUGE_SHIFT) &
					MFD_HUGE_MASK);
	} else {
		file = shmem_file_setup(name, 0, mk_vma_flags(VMA_NORESERVE_BIT));
	}
```

3. In __shmem_file_setup(), the inode->i_mode obtained by default is
   0777:

```
	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
				S_IFREG | S_IRWXUGO, 0, flags);
```

4. Back in memfd_alloc_file(), inode->i_mode becomes 0666, and
   F_SEAL_EXEC is set:

```
	if (flags & MFD_NOEXEC_SEAL) {
		inode->i_mode &= ~0111;
		file_seals = memfd_file_seals_ptr(file);
		if (file_seals) {
			*file_seals &= ~F_SEAL_SEAL;
			*file_seals |= F_SEAL_EXEC;
		}
	} else if (flags & MFD_ALLOW_SEALING) {
		/* MFD_EXEC and MFD_ALLOW_SEALING are set */
		file_seals = memfd_file_seals_ptr(file);
		if (file_seals)
			*file_seals &= ~F_SEAL_SEAL;
	}
```

5. In memfd_luo_preserve(), LUO obtains the seals of the original
   memfd through memfd_get_seals() and stores them in ser->seals:

```
	seals = memfd_get_seals(args->file);
	...
	ser->seals = seals;
```

6. After switching kernels and restoring the memfd, in the
   memfd_luo_retrieve() function, memfd_luo_retrieve() directly calls
   memfd_alloc_file("", MFD_ALLOW_SEALING). This call creates a new
   shmem inode with permission bits 0777. Since MFD_NOEXEC_SEAL is not
   passed and only MFD_ALLOW_SEALING is, the execute bits are not
   cleared, and the inode mode still remains 0777:

```
	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
```

7. Then, in the memfd_luo_retrieve() function, it enters memfd_add_seals():

```
	err = memfd_add_seals(file, ser->seals);
```

8. In memfd_add_seals(), ser->seals holds the F_SEAL_EXEC that the
   original memfd has because of MFD_NOEXEC_SEAL. Since the restored
   inode is 0777, inode->i_mode & 0111 is true, and
   SHRINK|GROW|WRITE|FUTURE_WRITE are additionally added -> seals
   becomes 0x3e:

```
	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
```

Meanwhile, I noticed the earlier review discussion about the original
seal-preservation patch:

https://lkml.org/lkml/2026/1/26/843
https://lkml.org/lkml/2026/1/26/1044

I feel that your discussion touched on this issue.

I think Pratyush has already come close to the essence of the problem:
"But I think that should be done by preserving the mode of the inode
directly, and then copying the seals back." Unfortunately, that
requirement did not make it into the final implementation.

Regards,
Haolong Wang


