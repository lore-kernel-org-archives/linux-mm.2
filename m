Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733AA606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTkZ9H3k
Received: by kanga.kvack.org (Postfix)
	id 239AA6B05B4; Sat, 14 Nov 2026 07:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126C76B05B5; Sat, 14 Nov 2026 07:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30086B05B6; Sat, 14 Nov 2026 07:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D37AD6B05B4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 592EF803C5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:33 +0000 (UTC)
X-FDA: 85433589906.06.6794D01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B02D52000B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTkZ9H3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657811;
	b=R8e5xwSzF+rdD+T7gZusmwY8CFHZOh0i6ic7/dc4vvd+YnNmzahMzB59w79/vUMaNlnneT
	oz3Zz6rA+dMdKpfdoVxoL+tQoSOaon2KFbAoUtzNot8VYnosn45nDdcV/QDuAr1XaOhQOX
	5WcmuUGHIwssY6zMPY+DCwyjx8sUSsM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657811;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8bjqjOZXXJPj1tfqG9iwnas9qJ8BH37nqepWAHXyz4=;
	b=JhRBXER4BxdQl5AHrKKD49t1Gwg0u0su33BE9GSQz8fGi5fuE96AU7r55QLrg28MG9QQ3a
	RJxvP41xPO9Oi74SztdrLNoT1auJHBhPQrHMvkANyXkcbeUw/XfWVhkHCUj7nRgXW01VQr
	5Tim3Q2Z6fj2n3pNTyw6MaC7m1g4mlc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTkZ9H3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CCF4602D3;
	Sat, 14 Nov 2026 12:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2641F000C4;
	Sat, 14 Nov 2026 12:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657811;
	bh=m8bjqjOZXXJPj1tfqG9iwnas9qJ8BH37nqepWAHXyz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VTkZ9H3kLYaSH+ftQJare6BeAJ35leW2srLLeVqVNkIYufakLwc9qsPh7q6PyK+GQ
	 2ESGn5N0LRUxkvTDHqu/Iodt7hjLHU2IBpfcd6KHkZ4X5RchqdoqPfjR2gvnP7Jzzi
	 v3r7/NXEE33bdYANLq7Kc1uharlCSFFOH1YrAdyf8EjtHgqtSd5DAIGxLsopxrYOA7
	 c5UFB4cjnyUOFj3v6kLAgLIBJGi137K/4UixHmfbUnRHqyoCrZVv17A0U1XRCHd3IW
	 xnyP/lx78ekHV4o2o9rHn12pw/WS+rCrGk1Nvtjm8XCbZZO/7VDsyEf+np+R0r3kEP
	 shGz027E42Ciw==
Message-ID: <sashiko-outbox-214462@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/33] exfat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-11-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-11-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:30 +0000
X-Rspamd-Queue-Id: B02D52000B
X-Rspamd-Server: rspam12
X-Stat-Signature: rnujkuubm8wx14xnmkdxwxjudbnc1aou
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794657811-83737
X-HE-Meta: U2FsdGVkX18oFxEg+Nzr+6zLlvXAzlDHdsD7OZMPJT/jj4G0yMtjMpiEBARrS1108v5mC1VeF4F0gTKB7DSMshVgy5H97pLDzbL25r8HQZN01RMBSCBLjEnc0uQA9EPNicXJm4nc23cRkxYsEaRyOLdBvAa75AxUrILibEQ+NVCssgkg4l5aSnkdvbFuDzZ5rq+51QFEN7AtR/hd2jhC+JAXxiXxIH6suhx57HOEiR7T709sy5I9qAFXmwKeRX66JMBIxS89KcqOCOZZDILxR0+AQFyOPE+9nFmxPMZzMFaCZquJYKVsc06+0CALHv9ie+RJewsr8SdpdkH0yQwmSXMjIvaz6+hC1o3DhMzlFuDDADggBDbAr6aQllFHT8BHbUvBKD7L4Bvjy7G9pyF+Flmf5FvabOigycuo7emtM2KQIBDeRONw9QuVnEu0obT+KOYO4jA+ZxeNO1BU9KLnw8kDvo7duIql1Vey07MDpUXjM3mtIiHEOdtmECu+oiSvhlFb7QlroQh940ZFQNmUT7OOotvfjOr8CtD2S8Bpu3mVfn8mgamzIF8w+Oo8n+VonoKQZA4uoYiiyiv6BB5kZ+7vIlo34MOf6bKkxjmkK6UCZ0RCzaHaH3i0jkyj4dDb1UcQm20LWC/hDoqjBn7sqNRy4aegi1Cfi7dBX7Qa/TcF8i4+FRMbti/XrZb/lOHiY/tS+HTN+uXlojjP7YgqFF1S5jG4B2vKASm7fEN9oqQwmjFz6QnxClhIWIMItjQ6L2fxh4KzKI66daYjLInI4czJ4iaeq+BJRXZSwcrQFZ/S3zRDyWBOppagJO653gZi2yp+umAX3V5TXz9MYum9jqQkOD3YiV7luAk7okEn2hnKnpjETYnAJ0zQjB+KhdlnNIVzQtfyU/Z95Cz4+4uH3jQ1iOm79v+UUEv18nLj4jFg2e0ETW4j9agHGb/xNDFemtI+ces5ZqMlX9lIWc5
 P/RWg3Sg
 hO6l85QoXL+MXDSbYNWPiklvGtJD0QGEIOMT8UaGbnk1LesCFqP9dkf1BZXhfbQdKoXWIyQeP8erUE83+ab00V7tc3ZnDWnbbPPgCX/ObCSlV4Bs8iB4GQhTvYOMG3KyiMqw4mUZzjO6v9JR8i795CVGMCcMGIHnBlprCsskLNLeEJGw218LRCpu04649cmBL0sO18ESW7VBEMqBaRIvqynjRD8cYmxjWqccPVua0R7d3lhsIyefkDj67RsB5VJgDkcNxNnhcI4JP6O0n89TNoa2W5uKUKEKSj4x/iJN2b1pcIf5h8iUpMeOkU4+amqooGWR3aw5pDrvMybLyTf8Fz8Zbme06b7HzVsfjH5V1wHCH87j/3MSlQyksPqIyJHMbrlucfWrkXLt+Z2y01/K2+82p3vM4oQKngmrujalMcA0ePsSfh0LJeV6Dj+0yr77w8p+2PgIY0SX8Ii5AmYT0A4/E2I6FkS1flsadgBjO5GsIc68xA9/K8yNjhfdAk+HIeSWs53csKPUl70/GAlRfcIekpvpi5sb34/404OVpkzDFc3kLpgAh5pfdJUob3TZ3ZhAf/YtXyRFzwO+YlW3tvlJlUxkD9aTeofgYjsWuN+n7448qIKIrc0tBtFWVpQCYb772DbTzt4gVzmc4d91bK5H1fFSjORU+oS/Rd60E0S4WwPgSDdPIWth1VdHJmwpeOPGyxoAwOWsgRENKijsfjFz7SlQuS3I7T5TXizBj2LVAnzvGWlvjRRHaRWzNbhf99kiYcYR7xS8vT3tp0bE1IxfLDoo5I2vZM0Vu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] exfat: exfat_page_mkwrite() checks emergency state and
  dirties before sb_start_pagefault()
--

commit e1275d4c04928c834a6a34f6b3133c89c272c085
Author: Christian Brauner <brauner@kernel.org>

exfat: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY on runtime filesystem errors with an
EXFAT_FLAGS_EMERGENCY_RO flag and checks exfat_emergency_state() across wri=
te
and modification paths so frozen filesystems can thaw cleanly.

> diff --git a/fs/exfat/file.c b/fs/exfat/file.c
> index 1386149916bbe..dddedf6e75da6 100644
> --- a/fs/exfat/file.c
> +++ b/fs/exfat/file.c
[ ... ]
> @@ -974,6 +987,11 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault=
 *vmf)
>  	struct exfat_inode_info *ei =3D EXFAT_I(inode);
>  	vm_fault_t ret;
>  	loff_t new_valid_size, mmap_valid_size, fault_page_start;
> +	int err;
> +
> +	err =3D exfat_emergency_state(inode->i_sb);
> +	if (unlikely(err))
> +		return vmf_fs_error(err);
> =20
>  	if (!inode_trylock(inode))
>  		return VM_FAULT_RETRY;

[Severity: Medium]
Can a write fault that blocks in sb_start_pagefault() bypass
exfat_emergency_state() if a filesystem error or shutdown happens while the
filesystem is frozen?

CPU0                                    CPU1
exfat_page_mkwrite()
  exfat_emergency_state(sb) -> 0
  inode_trylock(inode)
                                        bdev_freeze()
                                        ...
                                        __exfat_fs_error()
                                          set_bit(EXFAT_FLAGS_EMERGENCY_RO,=
 ...)
  sb_start_pagefault(sb)
    /* waits for thaw */
                                        bdev_thaw()
  file_update_time(...)
  iomap_page_mkwrite(...)               <-- installs writable PTE after err=
or

Because sb_start_pagefault() is called near the bottom of
exfat_page_mkwrite(), after exfat_prepare_valid_range() and
mark_inode_dirty(), a fault arriving on an already-frozen filesystem can
also dirty gap folios and the inode while frozen and then sleep in
sb_start_pagefault() while holding inode->i_rwsem:

fs/exfat/file.c:exfat_page_mkwrite() {
    ...
		exfat_advance_zeroed_size(ei,
				round_up(new_valid_size, i_blocksize(inode)));
		exfat_set_valid_size(ei, new_valid_size);
		mark_inode_dirty(inode);
	}

	sb_start_pagefault(inode->i_sb);
	file_update_time(vmf->vma->vm_file);

	filemap_invalidate_lock_shared(inode->i_mapping);
	ret =3D iomap_page_mkwrite(vmf, &exfat_iomap_ops, NULL);
    ...
}

Calling sb_start_pagefault() before inode_trylock() and checking
exfat_emergency_state() after acquiring freeze protection would avoid both
dirtying state while frozen and missing an error that occurred during the
freeze.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D11

