Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE0D606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 14:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OdfnivgP
Received: by kanga.kvack.org (Postfix)
	id A661D6B00EF; Sat, 21 Nov 2026 09:49:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17236B05B0; Sat, 21 Nov 2026 09:49:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE866B05B1; Sat, 21 Nov 2026 09:49:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 643EA6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 09:49:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD0F31A04ED
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:49:57 +0000 (UTC)
X-FDA: 85459410834.26.735E9C8
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0091C18000E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:49:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OdfnivgP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of shicenci@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=shicenci@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795272596;
	b=FVGMXAjCh53wx/B6zhJLxLvaJ83MiCNovCO3yYbny02xplq8xo3yvA+cLkV+8bgg3yYXGt
	NdmmXQm+vlV8sfs8TRi2Wi9HV1moz53z/pE5Z2iDmq4cHZ+M9vMOdH4yFdw6B8tuAUVKdc
	WTO2AoziyOpmamqOAa1XN+nNHLqhYsw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795272596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KMleV59mDasfc9ZrDI02cJ4rVcYzhncPH8nN8fIqQw0=;
	b=IPmTgybDVP8GuBuNkHoo0mbvnegMV07WukdRESKJ6YYh8mCdJlrky6AjPVUJCmH6ti0CSA
	5wPJY7DBPUBBk61ttW+sR5MYERB2OKe6DElxmhOBdB6c3ASnq77y41mzNTh1OM0CPVzzx8
	WkTBv5PlY5bT+/6wQkFkS9nbJM+t9JE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OdfnivgP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of shicenci@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=shicenci@gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc751eddf25so1441294a12.3
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 06:49:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795272594; cv=none;
        d=google.com; s=arc-20260327;
        b=OV2ztUY7eoITGqS/7biV8oAJP2aeyxTlGQGfmMqbVxhPUOAx33iJi8BDXwCi1XuU6v
         BPIPbqeuITfWh8WI7PrhOi3TsNBOoFpd994sVMb/S5JA36lVQ5jEX1k9zvSNehTROCDQ
         bwVFdfEqcwGv7P8xxdVzWEgaisL/JH4jxxXNIIuyYNQ3YqD1BRJEqAqfQkshPrQ9olL9
         4IwdIkqhlNWNJnVStpuZU9UdZiXjXhfIGCdWLmyMGNT1OZbvyGV5TyopL1YX/2sVa/+N
         4LfjH5fJVXQUqdPFrXBZVSPWJe07kGeXRhRXs6zw1T/yj2ZJHTOdIMJFv58IpQ2SCqmy
         5K4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=KMleV59mDasfc9ZrDI02cJ4rVcYzhncPH8nN8fIqQw0=;
        fh=FLEhBHNr/epMJyvkz0ShkaKwi8yaG+7OAqQ7MgUW7R0=;
        b=DShRUGembw9y3d+Q+7bF7RfQeEoahHCrraJ7+X87Te9ASemsoJ0X2KfUOQy7e1iMOy
         XvO8afgCzDJcNnPigRqhTagk8pL7hxmhJugn6DtBuga+UbEi9tdI3CDRxhtoLhE3O8SS
         sVKoObZ3bBYJuc7zIxbhjQO28UPJA/Ovb0vqe+0UOe3sbNtxg19/JKBoyLILuJLTu1li
         opiWhkxfaJS68zf5mEZP/EQ4UUl6KbVqvzhvblDSEDfi0nmzB+KxbEJqFeHkLVSTI8mB
         drDQ8e4Ip+MyApnuUJ6gALmhQEVgn5sSSRTxOSKhCXeEvJ/j4tT7qEQnVApofbI4pW2A
         hPYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795272594; x=1795877394; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KMleV59mDasfc9ZrDI02cJ4rVcYzhncPH8nN8fIqQw0=;
        b=OdfnivgPiPY1OnMK5VI46mwg8Rf5lbBgMsuzmn47Sgz0nVxi0NF1qyHJxFydYtCAHe
         MHkBYY87kakNf+7QT6xR9m0H2hZLBowq1/wZmO6Qbb9zwXInrgZFDOc0yEAneYmjjZvM
         Z1ayel+oJ+rfpl8eN65rIqtWuMAwTXShJ7Vixtiod3QYF29nFDfZ0FvDpRByjXK3IfoQ
         GWO0cMJSDfPmwjbFlyqV60n05UtovZcYEfaTFjquk/FqUaquoHHkFgAXX5geJMY+xFom
         G3bbdA/YDWc4KxuICJF++uQItOwXa8Jjxybc9r0quTHjAo+2K1d3KZN4oR+BYgPsSovf
         x2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795272594; x=1795877394;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KMleV59mDasfc9ZrDI02cJ4rVcYzhncPH8nN8fIqQw0=;
        b=CrkXz5OJSf5YkVm/OhA80ccB1/uo3fhCyqHHZlXzw4hke3UD6kJHgyIIHvdCmLl8Xh
         VymF8Dzt57vwjVgdhOwkDmpnTR01HQwCBRRIDWrVyI2BkZkmpijfZoV9E54DsFr415+1
         GlMFIHl1fnmBUjEThPgGos+5G0DRlU84+HST8Jj6ZuAJsJKQ8rdNqcAj0Xcz/uZnEv6n
         zHtvmw6IDO0eXgqILQhcTzSRivGjWW985f6GqdJl4Dn4WTJgrT2PkhpEfyiDapPmStrw
         muUSREQCwq8rsEIkp8c1rLYtEugMzhVOidl2LIxxEm4MHwc8WE3Maog7ANLDGKMH2uLy
         bupQ==
X-Forwarded-Encrypted: i=1; AL+hErGdmtGv0hZ61XqtC1aqXLBy0ARLpDC+mI4rhNKzWir8XOZHGtZlnQoNIX5DDJqdJ9egCqCMfP8Bag==@kvack.org
X-Gm-Message-State: APuU4Z/JmyHWBpvY9DZqoWctLElZQECs6bqBg1juPYhsyo4JBqmZqZ/i
	NUNlt4wtGPRbac4hNk8H+pE5hlxUftlShHTCf9BErj0MK5i+fmXPUa1ZgVX1337k1NRohut/eJL
	y+lOPmbaHvrvPN8iW2zw/blCYZq7tU0U=
X-Gm-Gg: AZFdTZerUp+b94tsyGv33wkpUIKnlXM9neL+ZMB3zWeckqf1wIjdohJ+riiAzo6Xm1H
	oqLTom19B7T+9sRVYk5N07EEPFDSMfFqSUfm1rtC32VJhIJ7Xk0igSVZhSHMtoCM/bGPxk3bvBT
	ly3lOXMkCrHMvxH28mI07wBhXCerjvxkiyTDF+FJKFtAgM+YtdyrmJxSx8CJ/Xg7UqBug+7AcL0
	mEIczjhAfXDXbikG+Lcc6AylBhSOv8oHXPgjO6pv2fLsjeVHgHz6Yl+FSQJzWpj77/+/x7lpKmh
	io4G0uxfnZKLwU5HajhtYTFvXJpVo5EWEbtmbAXJkhYR6Y5pmCkK3QEapzaDOpxdiiWAiFX/9RC
	wK+er8chA6+FcsOXLgH7nGOI2jpNYj/+FFQIPidg=
X-Received: by 2002:a05:6a21:6e04:b0:3e8:b7fd:6288 with SMTP id
 adf61e73a8af0-4014d159070mr6730389637.41.1795272594392; Sat, 21 Nov 2026
 06:49:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Yi Wen <shicenci@gmail.com>
Date: Sat, 21 Nov 2026 22:49:43 +0800
X-Gm-Features: Aa3M54o-c3umdLG_yLVUlZkiDbL2uREfVKI1Y1odDetEyJ0RRT4OIUMRc1PDQa4
Message-ID: <CAPHJ_V+_=Av8pAM+N+oc4JRmtqBjhcimh3B_pSy_N+5qecm6Mg@mail.gmail.com>
Subject: [BUG] mm/gup: WARNING: mm/page-writeback.c:2678 at __folio_mark_dirty
 on v7.4-rc3
To: David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6rj75ggfrw1k65jkh9wj6fejnpgpjn8s
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0091C18000E
X-HE-Tag: 1795272595-669618
X-HE-Meta: U2FsdGVkX1+GlnKtX6UAaUaOFM9i5LJ6b0xOtmizfHQGNVUn8CAx5TJae5/vh8+xtLOng/2ESZ028G+BPKWWPuqb0Hdqic3JGwwXcmHKChSxkW+zYJJevO9kGSHbs1WWiBQI6PaacxHlCbPchivPiwZXfkNQof5GN4HmhOh/y44PVuTEHKN2tJdD05xrznTSQYRsjT7XV5TeR5xLIUXoRSA5aK/kdi2FNtXbJUHPkOaSIhTc9sf3Qtj2enFJ2qNgCwSJ+FzmSA6WXr/c7Aj8CMbQz2+VLFFP/2RDQ3ptUBCm6vsMcGswCJF8z4hdxG9ZlZ8mdH2czRQ0L5EVJWx0RiR56thDpJJiag2UpAvhkjA1PDS52nL8zBkzmYQ6Un0RxZGXPLWvvRppEhoqNCj6VgxOKywZkhfVZYpjFTx2UhkUdPxt9udDwNmNsJ1RqN+kVL2ZO66NDAhT6N3/BpOYvgtIsONoQE8eP6erMRHZLL4S3JYOWs+GcPfNN9h55CDyAo9vRcAOWhl1Lzq3fm6Deei+qzfdYyBVWcullNnsZpvZQuNedyJlGhH04UimYTwnfETE+5940Jf9LH5BrPtFoh19kWHyqwXZ3z60Hib/OgNy9pyAO+ntczd44z+kuqGBHWFz1QOnfRZ5m/ysrQOsy2o+JKO3jMScxMisGS/m6CCXVIdsMHjs1dbNslznZAt/VeObXxmzFgoezVaJ8Wz+A/LaLaskINeqj+EA08VMYcPKu/Okbr2je/tc6cQoFxB7DNBsfHsrvkM+RvB9Hqk95fSTyyyhxjZzJRVtm+7pNXF+2nKcSrfOxNsZwMAa7S1RIslh5z2tsj5RGz1/cEwxKGBkUU70dONxnDtsUZKKK6g8qxSVwqt83ImA1imtSePa0kC9EAXp2kAultWWv9qZVLq2TeHQ1o4c/8sHtgFJYo5Q3HiTunyIzzvA/U4+lASNw8VBpbWpLmBskRLcamd
 Cy5EXWOO
 sgGfPAYQixrw7OrtChhUJZR/FqhDBcwFI0DWJ47sihotaDPthUimpafWbuoX980ccMs72KqCkzn0MOfwlabYUk0jocAWYZU8QGqihnjwwld4wNWHZmCHMPVWPfkM7XUaI2IhwMfMx4QpSRsFx2XKTiBuxRu0F/noc+mQ6OwhkXV+T1gtJGgMVHGL8GlR/91lDsIJdzAiICDH47oHQ2f7xyGoibwtNGkG5KFDSFXT4L47cHG0txVj6gO5fpLyoLu48EF7QtBmBJN7wRUxx5+rfiwU0Z4PbP75C2o7K+VxyDOfl/BjuU2TbcBm4V7aoiIAYU+LmUgmhiz1Eg+Of2hdXloOiJHRNll9KUdWEEgMs4biiIY7AVydyw5mHys8urKGYyM4CNHvXYTjtq3jkFgkj8j4yRrYxt2k7inYHJiQBC1GFAICqVQ4RKU1bZ000rxeZwCnckyYQPNEg7TPBFHSW2KHf62Q0kURDszp7icoMTbzBTuU5IQUUT8dQoxGdxc70oEmMfCNB9Q54ceyNScM6KSUe+8O2GCxEGywIkrBMTGLAlJtGx63UugZcgzzAFJr2De8aECJIaZMVWQD63TRH0iWwBJ7v8t0+csHf8JEyvwBVq1/s3co1/YQr75G0dVWt7ixquz421utmVcInPqS7A3fICh5a6FDG4m1j1/dPQKlF7zOI/FGLBncLOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

I am reporting a kernel WARNING triggered by a syzkaller reproducer on
Linux v7.4-rc3.

The reproducer triggers a WARNING in ext4_dirty_folio() when
process_vm_writev() writes to a file-backed mapping.

The call trace shows that the warning occurs during the GUP page
unpinning and dirtying path:

process_vm_writev()
  -> process_vm_rw_core()
    -> unpin_user_pages_dirty_lock()
      -> folio_mark_dirty()
        -> ext4_dirty_folio()

A second WARNING is subsequently triggered in __folio_mark_dirty() in
mm/page-writeback.c.

This appears to be related to the interaction between GUP-based page
dirtying and filesystem-managed folio metadata. In particular, the GUP
dirtying path may mark a file-backed folio dirty without ensuring that
the filesystem-specific metadata required by its dirty_folio()
implementation remains available.

This may be related to the known issue where GUP-based page dirtying
does not properly notify the filesystem through page_mkwrite(), as
well as the interaction between GUP dirtying and
filemap_release_folio().

Before these warnings, all four ext4 loop devices also report delayed
block allocation errors and abnormal free block accounting. These
errors may indicate an additional filesystem inconsistency and are
included in the console log for further investigation.

Reproducer:

C reproducer: https://pastebin.com/raw/VMwNSqrp
console output: https://pastebin.com/raw/43Ne65Vu
kernel config: https://pastebin.com/raw/dG24GcY1


Kernel:

HEAD commit: aebb7274476403040d582c61478df8f4a7bf9cd3

Kernel version: Linux v7.4-rc3

Environment: QEMU virtual machine

WARNING 1:

WARNING: fs/ext4/inode.c:4527 at ext4_dirty_folio+0xe3/0x110

Call Trace:

  ext4_dirty_folio+0xe3/0x110
  folio_mark_dirty+0xb9/0x120
  unpin_user_pages_dirty_lock+0x588/0x6e0
  process_vm_rw_core.isra.0+0x7ad/0x960
  process_vm_rw+0x1c1/0x260
  __x64_sys_process_vm_writev+0xe3/0x1b0
  do_syscall_64+0xee/0x4f0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

WARNING 2:

WARNING: mm/page-writeback.c:2678 at __folio_mark_dirty+0x644/0x780

Call Trace:

  __folio_mark_dirty+0x644/0x780
  block_dirty_folio+0x149/0x1a0
  folio_mark_dirty+0xb9/0x120
  unpin_user_pages_dirty_lock+0x588/0x6e0
  process_vm_rw_core.isra.0+0x7ad/0x960
  process_vm_rw+0x1c1/0x260
  __x64_sys_process_vm_writev+0xe3/0x1b0
  do_syscall_64+0xee/0x4f0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Relevant ext4 messages:

EXT4-fs error (device loopX): ...
EXT4-fs (loopX): Delayed block allocation failed
EXT4-fs (loopX): This should not happen!
EXT4-fs (loopX): Total free blocks count 0
EXT4-fs (loopX): free_blocks=2415919104

The issue is reproducible on Linux v7.4-rc3.

The full console output and C reproducer are attached.

Best regards

