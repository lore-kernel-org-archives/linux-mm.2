Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3DD606A326
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hReMojH2
Received: by kanga.kvack.org (Postfix)
	id 4BD5F6B04B9; Tue, 20 Oct 2026 09:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494B16B04BB; Tue, 20 Oct 2026 09:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA466B04BC; Tue, 20 Oct 2026 09:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10A496B04B9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:00:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E26CA016B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:00:06 +0000 (UTC)
X-FDA: 85343012412.13.F1863A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C809740005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:00:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hReMojH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792501204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeB9r41aTDoKdoA+kCZsJ2XWnJK4z4zZ4MkuJKrc1ow=;
	b=48wCRX1AQ5Dz487C/2C2hhkbLEwySu4jbrRs8N7vbFi/EJkU8MbN3QHW3Jk8rvL3KBF1zY
	ILN+Tn3mosx/CdbmgGYAXjM4jJfO40Q4l5fkYy/dyJVByuaFTdQmQpkLaTrXZ5ZVFQyn4B
	xccE/Bq4QsQXv5TfOPQH6ydeZCvmyJI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hReMojH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792501204;
	b=SeNhHnzCgFB3XCZK5+6LJG7h74aIgsH8urfSQ3vfxy70DspjIQKR/Sed7eky1tB7+gE9Ti
	k5E/5A7aF5pPG3A7ZPL/zpmgpClPFnu167qGxneAx/yPKmF82YFE3h+5OH4rXubopkl28a
	s0KP8NFQ4BuONrVkMlCcUg8K9otneMU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E6C743B12;
	Tue, 20 Oct 2026 13:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236841F000C5;
	Tue, 20 Oct 2026 13:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792501203;
	bh=jeB9r41aTDoKdoA+kCZsJ2XWnJK4z4zZ4MkuJKrc1ow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hReMojH2z5Fv4dGLKyixYESLgoxtiRUynJpJtAzqb3shE2lLmDBlTNCspH7vqWj9A
	 1/SZWmKQ2msnYMUGK/lWSQ5oA+Y1R9OwOqLSCK8K9UVdb6aCqmVCJCf+/NymzwB7n0
	 C2yK7DXZQjGkC+zl8iAm+PJs1PgejmG03zuerPFL92asiWatcLfJ1b12UuKTGLkEUs
	 hIS/PTom6O+tCIPTSF4h47w7Vx1hfb3JfAb9AKJ1wKbGIE0FY0NdO4M/DXvzqteRtF
	 440MPGH8lyFxY5XjzwgERy1jwMGoxpdSPgqytq6SRdI+kMCgiX+IVjZsR36tauwcI+
	 i7f1E4IJ0ryPQ==
Message-ID: <3a3e48b1-b5ea-4d73-806b-3c2801484b66@kernel.org>
Date: Tue, 20 Oct 2026 15:00:00 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] mm/ksm: KSM merge clears soft-dirty tracking
To: shaos <shawnq1@163.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261020110758.960048-1-shawnq1@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261020110758.960048-1-shawnq1@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C809740005
X-Rspam-User: 
X-Stat-Signature: hqes53f1fej3mm8kpx6ng8hesjbajqzr
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792501204-429609
X-HE-Meta: U2FsdGVkX18KcEYLHMbz+qlLf9ryrnEIKFX3HrsYNE4VK45ffvbtWjH8bJLGe0JDTVCABP8DbRlOcB4HQsexlo+HOQT628hIh8jMKeD9IlciYKJySZ1VjmuKIbvPiLWVXFtiNrWhZ+MZqbjwU1BGpVkI9ib/FP9pqzZ9/2biBnRuaa6U7/4p0OOlHrj1SdwK5qz/CWEse39780YBAvJ3b6yNmGzBpb/RSQstie3TKncTrrwd15dslIGD2CeyfZZa60sQ+ukrQ2nrRgTvd21IlCEliBsLpsPMPSZh0WUmgI1AAZu78S7dpHUdGqfx+gk1zluWFuJ1uHy0ft0/jmXnSgZLYyVsvlN5L2dNRr4a1ZMz19miZZTyUFELWsTtZ4bi78+w68F+RKjV29A5cgy4NNVTWGCSbzodUyVdXqujV7Hv4bZzZohSa+Op0zw7Yt+Pxuu1u3jP8yZqXMGQl0R8OTzo4XS+bWyu7nDwCokEfeUMXVL8omA00sy/RPofNioRofL0Kjc5goUGdEAUfVfbMQTtnf8HA6Xv1kvpdXEW4L5l4N47TeLW3p874SJRQh0eF8/zhPWPdBkEfM5FKXXEMZgFxttmCLTlW99fOvttBBOwtOAVBF0YfKD+TWKrxVJ+xfkl5OB4qd6uleOrU6YmvJmffxARJWN1fP6KxRUCmaeMgngkpGo/kmDZddolrwF8abxd97xpY3fIb37jvUn6fzumIGqy5CMZ28adTb+2/KzZlFn3GTT3B/TghIl+3fsyJRKpK2fQ6TGN/fdIfjn2lB2Cbh8/rOb0JKcUBPfkzzPTT59w/19ffOQG1pOVviW+LPaqDl4/rr0ZF6gSQdXt3oe/KFKIQdsXqbN2vQ8jl2dE5LD0enJGFR1INMSYZYFT3YN7K7mysJ6jky4wIQkzxIJTETRwVOTB7BTRcCbjekF7TOsMQv/eAKM9FsSlhXgDKKA5xL/sRtUrXXhaDA4
 HkbOzYOK
 H4HZQ5hYSbYWSBQaIfQnpl3KgxJA1iR/QXlB9ew7N3i5ysZoLgB3DKDE+0GUliOtzUGnJ9QXfy4wPgSwqXWFxinJzvY+V4OnkaYKsYc6LV8U4JeX+iLiEw3JKNc2q2Ox/fu8fk6sp3HKVB7hzkmVLBDJon5eQmejIoKcEC6f6apBpXSDRsSkGjachJMvgbEcBOstVMtuYgD16n92Qgk7C04YNgGfSXWTUXUFX98OnmH9HgZHT6T/fiMamNwW3k266cjl8FNXUG3d0bBurmFF74XYdpsEMLPJhA+djIT6jOuiTPHvEsTZF+TiQWhJoyyfE45IOuZ15LQosx1q7AGMJl9jTONzjcEUjcfiquoYRpGc0o78y3DRLpYwv2ztJzwJoe5GT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 13:07, shaos wrote:
> Hello,
> 
> KSM can clear the soft-dirty state of a page when it replaces a PTE with a shared KSM page. After clearing soft-dirty state through /proc/self/clear_refs and writing to two identical MADV_MERGEABLE pages, both pagemap entries show bit 55 set. Once KSM merges them and their PFNs become equal, one entry has bit 55 cleared even though that mapping was written since the last clear_refs operation.
> 
> replace_page() builds the new PTE with mk_pte(kpage, vma->vm_page_prot) and does not preserve pte_soft_dirty(orig_pte). The marker loss can make userspace dirty-page trackers miss a page modified since their last checkpoint. The PoC makes both pages dirty before merging, so the result does not depend on which page KSM keeps as the stable page.
> 
> The same replacement path also loses userfaultfd RWP markers; that separate observable is documented at https://gist.github.com/shaos26/e887665d7868dc323d73a1d678cacd3d. This report focuses on soft-dirty tracking.
> 
> HEAD commit:    24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> source version: Linux 7.3.0-rc7
> architecture:   x86-64
> compiler:       gcc 11.4.0, GNU ld 2.38
> QEMU:           6.2.0
> 
> console output: https://gist.githubusercontent.com/shaos26/9db36768f01eb83c6aa14ee9fc057388/raw/59077135f035791493d6d487c9e619c16380518f/console-output.txt
> kernel config: https://gist.githubusercontent.com/shaos26/9db36768f01eb83c6aa14ee9fc057388/raw/baa5ee61ce748667104c480560ab5116a100e3fd/kernel-config.txt
> reproducer: https://gist.githubusercontent.com/shaos26/9db36768f01eb83c6aa14ee9fc057388/raw/06005564982eab5cbcec26c5d62ad86c7261a155/poc.c
> 
> Build the kernel from the revision above with the attached config. Build the static PoC with:
> 
>     gcc -static -O2 -Wall -Wextra -Werror -o poc poc.c
> 
> Place it at /init in an initramfs and boot a fresh QEMU guest:
> 
>     timeout 300 qemu-system-x86_64 -machine pc -cpu max -smp 1 -m 2048 \
>         -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
>         -append "console=ttyS0,115200 rdinit=/init panic=-1 oops=panic loglevel=7 vivid.n_devs=1 dummy_hcd.num=1 netrom.nr_ndevs=1 rose.rose_ndevs=1 max_loop=1 comedi.comedi_num_legacy_minors=0" \
>         -display none -serial stdio -monitor none -no-reboot
> 
> Two positive boots reported RESULT=KSM_SOFTDIRTY_LOSS_CONFIRMED with equal PFNs and one soft-dirty bit cleared. The non-merging control kept distinct PFNs and both bits set. No privilege escalation or memory corruption is claimed. The affected KSM replacement logic appears unchanged in upstream master f47d223627f8; runtime validation was on v7.3-rc7.

https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/

-- 
Cheers,

David

