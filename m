Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF73CA9EBD
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561CD6B0088; Tue, 13 Oct 2026 23:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC226B008A; Tue, 13 Oct 2026 23:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38ED26B008C; Tue, 13 Oct 2026 23:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 114E26B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:52:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 572FD140211
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:40 +0000 (UTC)
X-FDA: 85319860080.11.2B01CE8
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 357D980007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Buev6srr;
	spf=pass (imf30.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791949958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2++tFfM9B8L7twSBvgop9sHGqKoD1BT9lh1zNIeJBBg=;
	b=m42HSYJ4fsDQR9w3byH49KnsXxEKosni3Iru7gXSBMQqPVQzn3O7BWg2Q0gQ/I+L62Mf6q
	UQYn1q7ER5IaoabuImSVqMVrUCcdKMZfcG50Yqu/wC6dcvNUJ5pyE9P9tBkPyIdN1Sh/Zj
	jzmNBvONTDAXgS8gwmRZGtKHh4XCZmk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791949958;
	b=I+QEVYDz97HAPGmVoE6M4FA9AyIqM3Iokufs0y73t0lAf65ECClFPlaNFHU7cEfYszDLo1
	U3rwpRNfNXDQgwmXO9OBdErlHRoJ7olFIRNw7cA37pxjxkTr7M3AVrpPo8b3QR1xnb7b/Q
	0QBX0/rwYyYdg6plAt5BZQCSTBfmC14=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Buev6srr;
	spf=pass (imf30.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=2+
	+tFfM9B8L7twSBvgop9sHGqKoD1BT9lh1zNIeJBBg=; b=Buev6srrsrHKqgNz9E
	/fOv9uryMc/p8/yAe/VdQ81Zdprd7NeHqXFG+hFNoUGzmDx6nb8zurDhJakvoQgO
	B7n54YhLIEbGB5on+Fz+EH5E1dS1tReAasLh72KCB/uQ4O/Ox754YpQfS5KB6u0y
	cR407qnB3jlasjaACtf6XD7Lo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDnhW54_M5qIvm3EQ--.3735S2;
	Wed, 14 Oct 2026 11:52:25 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2 1/2] mm/memfd_luo: carry the sealed exec-bit state in the preserved record
Date: Wed, 14 Oct 2026 11:52:16 +0800
Message-ID: <20261014035216.473794-1-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <sashiko-outbox-170776@kernel.org>
References: <sashiko-outbox-170776@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnhW54_M5qIvm3EQ--.3735S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXr47Wr4ktr18tF1kGF17Wrg_yoW5Ww4Upr
	Z8ta45tFWkKFyIv3yxAr18ZFyrAa1fAr4ak3s0grs5AFn8urn2vF1IgFyqv3WDJFZ7Wa90
	yw4Uury7Kw4UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07US_M-UUUUU=
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC9hmrc2rO-HkpgwAA38
X-Rspamd-Queue-Id: 357D980007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qoztaqzzbp9h4kub6z6f6zzhmecg9kgb
X-HE-Tag: 1791949956-415349
X-HE-Meta: U2FsdGVkX1/C0BXUs3Ss2Nd6+B4bD+mOuG06ni9TT8/VUaePIqSiA5Nku0sWOBXc8I9DdiB3unBh7xQjHm8b9w/DsFSLItNtesrbPvrt2hZ32QvqwpGO/KbJDa96oJYB+bIiVC7wtHyTSXTrx5hdztMElpHQ7dVtVkJHnN9uzZ+tAfRFsfdc+occPTzvyttTnwXVJrZHSSPFBUmSTKUedL5nlbJjbC7rfzsGoC3KR0AA7SIFTygTLgmwGTFm9EeibweFR6FpvRKF0y+zJM9oyzCyHzYOx+nlFLCp3ir2lMHP6uM1CC/WbOaNWkxewSjFmNh1Qf0N8n9bPVSlSNRft79WFWsYxRUzBoCbmBqUuP5sv8QUtcEqmcnu7Ufp89e2eDO1CrW1zMMQTgPOnJlXaUiZOevamXJuL0G+bedIIukw0pHKNg+tZMeOD7hIpzBVaJGhj6LRPIoOwXrgnFIgRenAy2e39r71rQtYooQqX1YfLkYcqlconPnq05mEC9ltt6tDaw+m6vStYciz+0+dhNMbW7/DhadsnaoxYJ7z+dD5bHRdDvqCLfiVKHWB/NMmjyvJ9RDtJDppAOAShpH+JfN6rQeVUhTlrAC5A32sViR/uKv2w1jeBpZhe/rBp6m9GrwFxovpGg++0qQ5NHlgljS4t5+XQjnQHEJ3v4UhM9H98OLNOHmUzORUY3b/xLQy4BxZGaVNxF8bh20+E2PyuUmaupUvBZQDrV83gOkjbK53afrcsSnyQ6L/NmHj7N33/T0qAjnFFHO1Nt9v6F8PwnkYucwqUqakxX7F41vFQfojR36SthI168zrMwFWxF3pKz66ziaXTcorwMbWV1ONv4OFjX9raEdb1h1YWaZ+UwySu1jCWgXAq6hxpDneoyh4UDyFu24mIHwO09tiz8pess7eyU40fbxOyEYHb7ZRLMqbez74k92zVE89Cx0awz7rYPppsDWACb1acMg3HKp
 hdynxDfv
 7rdp8P3F5ujbhdlLZGAZoILhyF+wktTAfZ4JyzkedxrbjtdvHIbGy0gz+5zJC8WNSvcakjvu9tbEJryzwICO53juaKDBCsZJodtJZb+K64kQZVMTU0nM4VSXLfIHmsTdnesE1yYNAaBXwdoqMtcY0zM88SMo08A0vwcTwuwFFxxkqiAHevNbeMl3tP9eO6vMoKyvJKBc9+Ovjf6eK5qcYSSnZQ9iidIrrHRyr9mpJ6VznmdSzNYD5V7WfH0dY/LBZRdxm4v9TUOktb831NS9s8Qn2QRUsEaM929npUPw2Stfhcx3GS1XAeq1WrHD86Esoxzkk7ZJnKqSs61gfTtXDDLK49gSIKdqFOagS4/VlcjPclqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks, this is valid, and it covers the pre-existing bit as well.

SysV SHM is created through shmem_kernel_file_setup(), which is the wrapper
that passes S_PRIVATE down to __shmem_file_setup():

    shmem_kernel_file_setup() -> __shmem_file_setup(..., S_PRIVATE)
    shmem_file_setup()        -> __shmem_file_setup(..., 0)

Both end in clear_nlink(), so the inode is unlinked either way and the
existing predicate

    return shmem_file(file) && !inode->i_nlink;

admits the segment.  A descriptor obtained through /proc/<pid>/map_files/
refers to the same inode, so it reaches the preserve ioctl, and the flags
word it then shares is the one SHMEM_F_LOCKED lives in: shmem_lock() states
it itself ("What serializes the accesses to info->flags?  ipc_lock_object()
when called from shmctl_do_lock()"), while the LUO side holds the inode
lock.  That mismatch is older than this series -- SHMEM_F_MAPPING_FROZEN
was already updated the same way, so the new seal-state freeze only adds
another bit to it.

I will add a preparatory patch that rejects kernel-private shmem inodes
from the memfd LUO handler:

    return shmem_file(file) && !IS_PRIVATE(inode) && !inode->i_nlink;

Real memfds come from shmem_file_setup() without S_PRIVATE, so memfd
support is untouched.  What the check removes is exactly the
shmem_kernel_file_setup() set: SysV SHM, big_key payloads, the XFS buffer
and scrub files, and the anonymous /dev/zero mapping file.  Because
SHMEM_F_LOCKED is only maintained for SysV segments, dropping those also
removes the handler's only concurrent writer of that word.  That is why
this does not need the flags word synchronized or the shmem_lock()
read-modify-writes turned into atomic bit operations: both sides would have
to change for that to help (one atomic side still loses against one plain
read-modify-write side), and it would be a patch for the shmem and ipc
maintainers rather than for this series.

One thing I am not claiming: this does not narrow the handler to
memfd_create() objects.  Unlinked non-private shmem files, a deleted tmpfs
file for example, keep being accepted; they are simply not part of this
race.

Measured on the same tree, with CONFIG_CHECKPOINT_RESTORE and CONFIG_SYSVIPC
enabled so that a segment descriptor is reachable, running the preserve
ioctl on the descriptor taken from /proc/self/map_files (memfd_luo is the
only file handler registered in that configuration):

  kernel                SysV SHM fd        memfd     unlinked tmpfs
  without the patch     accepted (0)       accepted  accepted
  with the patch        -ENOENT (errno 2)  accepted  accepted

The sysv descriptor reads back as "/SYSV00000000 (deleted)"; the two other
objects are the controls that show the ioctl path still works and that the
check is limited to kernel-private files.

v3 will follow as a separate thread: the new patch first, then the two
patches of v2 unchanged.


