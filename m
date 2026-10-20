Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F772606A320
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=HTvAwsxx
Received: by kanga.kvack.org (Postfix)
	id E507B6B0486; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD64E6B048A; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03E96B048D; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88FFE6B0489
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EF8DA0120
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:10 +0000 (UTC)
X-FDA: 85342730340.12.1E10334
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf28.hostedemail.com (Postfix) with ESMTP id 68E0FC0008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HTvAwsxx;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of shawnq1@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=shawnq1@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792494488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bOAvUVQJjxk6pZZQVpeKthI9Jctl5WJbGGXL3unzYIk=;
	b=XwjuCdQWK6QUUzC1jrBDKX+AngZodmJK/9UYAleKdTAnSoUOgxLLTrOXAFvFxHDajmsDtX
	L8OYCy4GaXK6EKzIQT2XzE3CEUuOXKKiJ1FNzIze62YxnwHabhP4OOZpfd1+4VRPCVNXo2
	l0fi20/dHoVkYTkhAtNSch0ZoI0VHlM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HTvAwsxx;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of shawnq1@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=shawnq1@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792494488;
	b=utKfeypyufVVGqZmjbgMcgC4HvfA8JG1Jss7NatFOer9zQ1yR6dbgXKhaztOk7+5TDrTVR
	2D9qDLEQEjpfKtgb0e3vLbkAzgSyWEzmBSnlDtRQmnLkYxW7ayHROxwHHKWPvScFB0NxeO
	fVAaMTB5I0KDkYKgcgvRTHggZ3rGHTg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=bO
	AvUVQJjxk6pZZQVpeKthI9Jctl5WJbGGXL3unzYIk=; b=HTvAwsxxKszlhPB3Hk
	XW4tobwBF5Cu8v0mS6S/6A7X8yV8vAdZT5gBQuBy6Q2hjxL+6iTeKmxoO4mTm006
	k2XxcovJGOKKdv6BjgaemQpqr+w2PhmVDVRgIbsEkfVVKh6u93o126Zxw1a91U6C
	+KayN28ns/CfEbcytFYQbo97s=
Received: from shaos.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAHuqGPS9dq_PjsAw--.59886S2;
	Tue, 20 Oct 2026 19:07:59 +0800 (CST)
From: shaos <shawnq1@163.com>
To: akpm@linux-foundation.org
Cc: Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] mm: userfaultfd RWP drops a populated shmem PMD
Date: Tue, 20 Oct 2026 11:07:59 +0000
Message-Id: <20261020110759.960089-1-shawnq1@163.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgAHuqGPS9dq_PjsAw--.59886S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KrWkArW8Ww1xZr1xAFWxtFb_yoW8KF45pr
	Za9w13K3Z7XF18J395tF40q3Wruwn3Gw4UJ3Z5Gwn5Zan8Kr1vkr4xK342g3WxAr1vkFWF
	va1Yva4DCa9rt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkUUUUU=
X-CM-SenderInfo: pvkd40jtr6il2tof0z/xtbCzw+GlGrXS49JmgAA34
X-Rspamd-Queue-Id: 68E0FC0008
X-Rspam-User: 
X-Stat-Signature: gr9j1jkq7mzy4p3z1kyp48gcd5iqqpmz
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792494486-550966
X-HE-Meta: U2FsdGVkX18GnxDAJ3eSbd3OSN50wBEVTM89tkVXheVUbqUgGyz6/tQCdpBijxrBfg7xGZkzQ7Vk/FaamKAxK/FRo50hYrSa7k2rgeMRxVLnEu7vfEW3A2FnSHair/p3MljseRwQPJoPBC73ljlJapACNPBQqjGsc1HaWpQfADwAijpMzqL0AbSLvD7iEa8KZsumii4pbrjTfyQohkbL+6NbsLElFsJz0LaZVdjGsja0rGVGXAi2y2nEOVNQGv8/3E7JIiB5gOTIDMkvRpZU6sBJ2gEteg8f2gEWHI8T2Ma5SnT0cjvvoUlNdqXNQHl/yD4zmXdxBmwEijTIqZhizRSgYckAzLgbv5tWJp/nh/Gr9VPg/ubaAF1RFachOReTZbWaT15bpgJ0tEbAdY3LQI5N6/XwM//xJ/zergwIThwmmKg9mCwq4e2akSCyZCqhKS6tA38fPG1uQz3wfXrlMp0eQ2n6G2NFawQKDr/TmLgPZi/Tt9H4xNxpsjCF/zk203pDsw47bFycXUD0XcQA9EdH8U+R9rHA/qQvaeZgGiYOzBXiRxlftNe6jp7KUMSL8ABSUuQJyVb/a+LhCB5dvf4nxHDM9WUkGmyLRoOIZfTOHbylWcFZhTC833SGIvhjO1Uku5WfxILw1ar3UGFBkTWDmtamRwU28TbyLKynDUrfKLa4M7IQ/kW7vYse9fUsqNq1zEbdMdDM/uTWFrzPriILEEmsd9FRFuhi0+FcfxhLeF8QbpZvIi/G581q1xB8sP0/dMpJ6w5kSOqDtZGLduRL4jsJamq0+hzKZL/xRwtrpl9THIlzPtg003+kgENErf5Kg6UxK7add4bwNvt0pfwXAdM5QRuQTP4khyvcjLZ0sfzsRSSSAx471rE5fDHmwvzrC5iiz2dY+4fXLg/AzUXK2TEYdyGZz5Gqn8iT/+QoXqLnAUoJMeKSStwFxPcogNm7tYOhyOAPvInBM8F
 VPhSiD84
 ww7WWB/uND+UMNUTw+NnbmHQfUH++f76iwWimhiCLKOdzDpBpod6SFSauRuOihCB3BrCRkyqoRjTlhh8tEU+xIKvmC/HsBrqXndAGAkIx1lB6h1d3HTh0g8WZB+Vt/Du6i7LVkuFEInyPlW83uuQww4gx0dDgpsFONH7D4f+aKb3mGzIYTZXIS9jC254o4ALu21Ty06AQYbIzLJSTDbN4szyydzpyNBq2A2oapLsAC4K+0/sTm+d6ke32Ph6YzwLgW6sX53wq1QO3NYIE3cwJx+KGJYl9cLC/btA5WKORS81twpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

UFFDIO_RWPROTECT_MODE_RWP can return success for a present shmem THP mapping while dropping the PMD mapping instead of leaving the populated page resident and write-protected. The next read refaults the page and completes without a UFFD_PAGEFAULT_FLAG_RWP event.

The PoC verifies ShmemPmdMapped=2048 kB immediately before the ioctl. After the successful ioctl, smaps reports Rss=0 and ShmemPmdMapped=0; the read completes with the original byte and no event. Re-arming the refaulted PTE and a separate 4 KiB shmem control both produce the expected RWP event. The observed issue is loss of the mapping and protection tracking, not corruption of the file contents.

The source path splits and clears the non-anonymous PMD for MM_CP_UFFD_RWP, but the retry does not repopulate a PTE table because pgtable_populate_needed() only recognizes MM_CP_UFFD_WP. The ioctl nevertheless returns success.

HEAD commit:    24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
source version: Linux 7.3.0-rc7
architecture:   x86-64
compiler:       gcc 11.4.0, GNU ld 2.38
QEMU:           6.2.0

console output: https://gist.githubusercontent.com/shaos26/3c336ea98e1e8fe09b5270c3a82ca268/raw/da13df3db0c05df09952f74bedb457f57c53b78b/console-output.txt
kernel config: https://gist.githubusercontent.com/shaos26/3c336ea98e1e8fe09b5270c3a82ca268/raw/baa5ee61ce748667104c480560ab5116a100e3fd/kernel-config.txt
reproducer: https://gist.githubusercontent.com/shaos26/3c336ea98e1e8fe09b5270c3a82ca268/raw/420975783e9d5dd88bc4a69190d8ef194faf5fdc/poc.c

Build the kernel from the revision above with the attached config. Build the static PoC and initramfs from poc.c; the program is /init and creates the shmem mapping itself. A fresh-boot run used:

    timeout 300 qemu-system-x86_64 -m 2G -smp 2 \
        -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
        -append "console=ttyS0 panic=1 oops=panic loglevel=7 kfence.sample_interval=0" \
        -nographic -no-reboot -monitor none

Two fresh boots reported RESULT=RWP_SHMEM_PMD_BYPASS_CONFIRMED and exited cleanly. The affected code appears unchanged in upstream master f47d223627f8; I have only reproduced it on v7.3-rc7. No privilege escalation, memory corruption, or guest escape is claimed.

Thanks,

shaos


