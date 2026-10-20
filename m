Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B70606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=YdxpoT1C
Received: by kanga.kvack.org (Postfix)
	id A07636B048A; Tue, 20 Oct 2026 07:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF056B048D; Tue, 20 Oct 2026 07:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDDF6B048F; Tue, 20 Oct 2026 07:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 637CF6B048A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:08:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4BCC4011D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:13 +0000 (UTC)
X-FDA: 85342730466.13.6836D41
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf27.hostedemail.com (Postfix) with ESMTP id 707574000C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YdxpoT1C;
	spf=pass (imf27.hostedemail.com: domain of shawnq1@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=shawnq1@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792494492;
	b=C/6mTaJzC3fpNeh52jPuzV0ebvJfb77C7YCYPLQmzHewv9rtqGSSnlBKXZh6/jpWWos+RI
	8CWMFW4QHbXZTN5/UOPg1gKy3BKA9sFuTJjkv+xBvuyC8vVw0yLR+l+dW46L8F9moca5De
	+uOl0pYpNFIiZWypOeV2YR7AiqysjAg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YdxpoT1C;
	spf=pass (imf27.hostedemail.com: domain of shawnq1@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=shawnq1@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792494492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K7fwwiQB/zWnok5poPdrINg9tw/c644NfMqHbW+4WN4=;
	b=3jpuTx96Ra1YgXej0fqE5AG3Yxs0aBIS6dbVPJdZuMa/jge/YcCHxdOpdT1Nke7UHe4+ch
	/cl9XY9UbBoJf4F2tA1Z9k1RpGeK8NSzZDj5Vj+xpuwA8Ugm0YvYduvy0MXUcjloy3wbEU
	3NdxbFMDG5EvxN7VmAl1qVJTXkbnjz4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=K7
	fwwiQB/zWnok5poPdrINg9tw/c644NfMqHbW+4WN4=; b=YdxpoT1CyvCeMSv+jB
	cZycIkvJMGE4BE+0PM+3oBZy+Jupg/gibadotxbUltpkbdUWuuL0T6R7RywnIJTN
	kAqKxh+42X9qe3mCHEhenk4yl37lICoBsaZ541QgYTDjVkNg9EkpymAMlkfO98j4
	+YXgKh4ulF8/ezCGGUC0B0zBc=
Received: from shaos.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD393GES9dqIxTHBA--.10263S2;
	Tue, 20 Oct 2026 19:07:49 +0800 (CST)
From: shaos <shawnq1@163.com>
To: akpm@linux-foundation.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Liam Howlett <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] mm: mremap merge clears RWP state from an untouched neighbor
Date: Tue, 20 Oct 2026 11:07:48 +0000
Message-Id: <20261020110748.959870-1-shawnq1@163.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD393GES9dqIxTHBA--.10263S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF45ur48Xr4kuFWfGryrtFb_yoW8KF4Dp3
	92y3yY9asFva15tasava18Z34F93Z5Jw17Xas8Xr48ZrW3Kw1jyryfKa4jkFy3ZFs7uFWr
	twn8JFn7XFn0qF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYzuAUUUUU=
X-CM-SenderInfo: pvkd40jtr6il2tof0z/xtbC8QWEkmrXS4WdhAAA3I
X-Rspam-User: 
X-Rspamd-Queue-Id: 707574000C
X-Stat-Signature: x7i41gidx98m87hhc73aqax5syw3b84s
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792494490-886840
X-HE-Meta: U2FsdGVkX19f6BK/b11K1j25oJWkHaZtCogGxBCj/MLhXWh6ik5SKd271MBOnBfaMg7timhG03GTyB8wOp8vj0DvHNh6qLKrLELd1gnZVErZzxXRDYLW0UxE+LKQ1T1ihTeRY6IDp/2v1vcLAyKAFUfMK2LKJmBzfjSqsTQ2NB1z2QcoRXxCrh1SUa5Z6aUSfj1C9gIfKpOhN0vayYyPlTDnS7HILNHsoOguZxrDbvGIGW2Gf16T6yM7sswzxDDR4vK1q4ktle7Isf1UYYm3mCI0xAyVVKyr57t2xHWeq2/NpCFKExH4Ob2ofeJzkdN1BJtQmnbdA+IyN9edveHuS7J0m4gDVgX6ncRPKVG0p73EXGJNojU/PvCNFVDzxKH800nLX+U+4en7LvTt6Jj790MwDfmOX/lzLw9ge6+ntnQeWlTKu48M6cTtL4pQNx16JpmjHPM8MJDHwHjtctYfygafI9jdeMIkwXXnOE3I2AC2kpWR8TUODt8Q32OqL1eWZZDUsBNaOxZ8/ieuUnm4+NhaAbuRVcDC9Ceap22JE7H1mzDHmqK7vjkDa/6Vrgl1H9G3UDka6XaTJ19m2drM6/Er8Sz5SY3EmmU/JIPD6AjRoTzcD/MA+RO0fpsSrtwOljpryV5cz5kSqzWhJ9556KkOQ9dt2tWiN3hBh1yV+jGA4ATYaQkG+o0XS2e3kETp7H9RLvhvVI09N8z3ermQ0lpQhyokP2Ca2LzwkF4PTKwgUdYyWT8Hb4Ch3KhCIKWqMYbxEf4GXz+wnJ8Fu3EtLLr0bs1G72S2wjbXsoJ/lhTWWXWUM3uWNE7CObQNLfbqZfoiiV7PddICmyIso81xA/kfamiIlMua6u0H/draYNCU/on9RN4hWa1IGuPeKaR0mQLeSKZgZVYMXjtnOl+wn8M0msl5TOPb6YWRylhuCP2XSGBa2BLadJLdE8/+cV7awaRdOX3Q/1veaoPrutu
 THvSyZeJ
 cC4vO+IFpPEMQ7XYC0rYUfymGZjFWSsl6oXquGnRtoBcQUYhZqnJGqKseg2wwu2ElxEHr74kPVNJsSn0zaUEAbi77l/GCVuUoBJPUHtues3BokiwvHxRQOpxsEhQZC0Y0+Qu9q9AjDOHKsUf41WHz/SflHGZ9U0sdN8bB9p0KFNMCSVtPMu5N3Q/zodax7dXhzVhWeuOnutx6yWZyKWTQgT/FijODZD3uOUnq1o6ZxEjRUZxmZmKuF6kNOUvQ4kN4aR4Nl9ggnJuUn0skvItGIGyaVU+0cT67fs4tIcNBXnLcYGo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

An adjacent mremap() can remove userfaultfd RWP handling from a neighboring VMA that was not moved. The moved VMA and the existing neighbor use the same userfaultfd context, and UFFD_FEATURE_EVENT_REMAP is not negotiated. When the destination merges into the neighbor, mremap_userfaultfd_prep() resets the context on the expanded VMA, including the neighbor.

The neighbor's PTE remains PAGE_NONE with _PAGE_UFFD, but the VMA loses VM_UFFD_RWP. A read that delivered UFFD_PAGEFAULT_FLAG_RWP before the move then completes without an event. The same-mm PoC reproduces this on two fresh boots. No-move and nonadjacent-move controls retain the RWP event.

HEAD commit:    24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
source version: Linux 7.3.0-rc7
architecture:   x86-64
compiler:       gcc 11.4.0, GNU ld 2.38
QEMU:           6.2.0

console output: https://gist.githubusercontent.com/shaos26/3b44971d9385a0cd18cfbf2e9bd730c6/raw/368568c2dd47417b54a957c8d9cc09f77f28b236/console-output.txt
kernel config: https://gist.githubusercontent.com/shaos26/3b44971d9385a0cd18cfbf2e9bd730c6/raw/4989bc843fa61b5eaaaa53422238ec39e4356b70/kernel-config.txt
reproducer: https://gist.githubusercontent.com/shaos26/3b44971d9385a0cd18cfbf2e9bd730c6/raw/109dc86c28debcaca07aedb2d450ed1e95ae5edf/poc.c

Build the kernel from the revision above with the attached config. Build poc.c statically with pthread support and place it at /init in a minimal initramfs. The positive run and controls use:

    timeout 180 qemu-system-x86_64 -accel tcg,thread=multi -cpu max \
        -m 1024 -smp 2 -machine q35 -nodefaults \
        -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
        -append "console=ttyS0 panic=-1 oops=panic loglevel=7 rwp.mode=positive" \
        -display none -serial stdio -monitor none -no-reboot

Use rwp.mode=no_move and rwp.mode=nonadjacent for the controls. The positive oracle is PRECHECK fault flags=0x8 followed by POST no_event value=0x41 and RESULT=RWP_NEIGHBOR_ESCAPE_CONFIRMED. This is a userfaultfd tracking defect; no privilege escalation or cross-process access is demonstrated. I checked upstream master f47d223627f8; the relevant mremap/userfaultfd logic is unchanged there, but runtime validation was on v7.3-rc7.

Thanks,

shaos


