Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E87860A2614
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mBRIO+Eo
Received: by kanga.kvack.org (Postfix)
	id B7B4B6B05B1; Tue, 10 Nov 2026 19:24:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53516B05B2; Tue, 10 Nov 2026 19:24:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A697B6B05B3; Tue, 10 Nov 2026 19:24:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 766D36B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11DD6A6CA1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:10 +0000 (UTC)
X-FDA: 85420941060.20.477B308
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf21.hostedemail.com (Postfix) with ESMTP id 60E531C0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mBRIO+Eo;
	spf=pass (imf21.hostedemail.com: domain of 3prXzaggKCD8enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3prXzaggKCD8enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LybfooOZFr/ZxceoY2G/oKZxTKcGOCYNwMjM25zJ0mU=;
	b=zkjNd1uv86x2IHXpgBTFGcp7quyw+sVZHY8gWbhtHnPndRfTC1usoE9T4NgunRwr4CYnMV
	qTbHbSNNiSU1MMcW8fZjplipPUx/SH/U8e/gGqB1G2wopbUAtPmANAXiGvjOhCVOKimy8b
	S+MqfDK4r/6eK6O0jr4SSvJ+BsDmaO0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mBRIO+Eo;
	spf=pass (imf21.hostedemail.com: domain of 3prXzaggKCD8enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3prXzaggKCD8enbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356648;
	b=O5uddjjbrHHpkhsyGHf6OvUJhiAfrsJru2+w2rTjAFiJRBAImG8T0j8UDYHu5hiEmW5xBC
	MuXPXi+OyJlJIzQzHzff9QRX2cc89xBrwtLWNvlf9LpME5MaKWZ8fbmh2F0QHoRiZsfYx2
	rMRlcuDMOsZ7C3Yl8NrQ/2RCm5PSESo=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4e778acdbc6so3131369b6e.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356647; x=1794961447; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LybfooOZFr/ZxceoY2G/oKZxTKcGOCYNwMjM25zJ0mU=;
        b=mBRIO+Eo5ft5XF/zC050p+99JyNtxp+8v+2t3mOvA/t7OMiqcJo2tA9ZNjHuBTPW58
         qfvGrE+wswW6yQqNDQmbWNE6w1NRNhPMAL02ojFbo/AXvJ6tkttu089t96yHkPmuu2Th
         Yjt3aqN78CfGR/Y/8kjB4/yk+uluFkkyjlS4wn5ajYiEqLM7lD99kuC0CSHpIdKaTQuT
         ekDqdrJCx1zbwJpqK/ZfQshDOW8ZvKQrXej6JpY8jeK8AbwYdpD8COLBDl0QZhXNsYPF
         zuC3csegclWqI5x4VRGCVnFmoBb975bW3LuQvekbrl/tmN6V4KgxmbUjz7WX5tE9zoQz
         o6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356647; x=1794961447;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LybfooOZFr/ZxceoY2G/oKZxTKcGOCYNwMjM25zJ0mU=;
        b=zxoFnKG8cL6AMLBWaGBTqbIlmnYWZMtYuUTKRO1ZAq67h3NigK0UWTFJsG4M4FL6p2
         SD0VXxeNosmfrMyo2Y3HHKXm37X414T588wbSdqyfaIxyVLVTwhK7dB0bog56iNnhzN3
         kX1qGLrVlcznNil39o4hXa3gHfc13tnvuQzvXETl1auZNDBIVE7SzlYESp4QwYD0xKLX
         H+pz3YSuHRNVWncYU98wgEspih09/52kqB6ElwLeocZCx3qLYWZb9mehoNYDB/EAV8Tg
         JlCo5HJJsjcLCGgmPf+JpGOaSXuHrlrbHW721flAPboddOjNh2FjnNEV7XNvc8RJATni
         XHQA==
X-Forwarded-Encrypted: i=1; AL+hErEyxsBfh5J72WiHXHmnf+jPf6DZDDg4g5+J1GYJ1Qll7dF3jiazd+t5xuYjpkaIHuUZuffpZqIxww==@kvack.org
X-Gm-Message-State: APuU4Z8YldGLIzGd/V0uJgkVWg4ANbmRET7oq7Z+7X1KMyo6PhQiXSxg
	fOiexsc4oz0o0uKyKa36sp2sFPujPZGsY2Fhfa1Svyo7y7y+1CD0PQE+X3JpyVleGxB5Raiw4WG
	E7UY61YOGBHqoxQ==
X-Received: from iobh26.prod.google.com ([2002:a05:6602:9a:b0:9c4:bd6e:a838])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:238a:b0:55b:ea1c:3ce8 with SMTP id 5614622812f47-56b95163a2cmr557277b6e.21.1794356646841;
 Tue, 10 Nov 2026 16:24:06 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:38 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-1-dmatlack@google.com>
Subject: [PATCH v4 00/19] liveupdate: Preserve tmpfs files across Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: aqsmza4n4xzgxrqh7iei4z7fz46p1pqy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 60E531C0007
X-HE-Tag: 1794356648-611390
X-HE-Meta: U2FsdGVkX1+mFvGyibrItEkhsQHqcEA+S+CDJuT6yc/8ilPrUcULVBonrCf79v4+THLXzkphz7FL4D5Ruvf1cpBlraMHrj07q04gQnKN1hFVqCwPgtg/3oWE8Tr/2uSbq1ztf+i0LZv6ZbIX1gAh9nQ0XJTKBkKe+XyHRtePWqsH7yXTvDUJmw9sA4y3TS0TjaFlQ2jW7He9p97LG54PNEcZLy3Xw4XauTIfZVMt00ce7SFqj+IXDj2TKvcc4g/lfs2ZuwDBMIYFndzNeT+W2mP2o4a+e8MX2Sx01zLD1aQFW8XbtaIp0ffLT2tS1FHvM4+w7TUe8i4osicwPapPrhqfxNcVnCXU0qA95CpGx+4lGVPcLkXjg9CuGtgLcBLUuN4pAuAAZXZBFqPiyEOtYZ5QkcM9wfzwBwI5D5hZ5akHGeCU0NFoCF4oQjjTJrsXnMOxMrl4AqGzpX4gw5xRbhTVDJ3e/VQhT5RY3FeuSqqhdQQFDIGL3cWv8HPdeFFirHplc1xs3SFa5kzNRj1PV+//bgFjVEBNWO9fySR64Gb81zpWAUl/C3fK03z9GjDoeB1RleD62Ip0F5a2FsjBaZ3wSHp1LvJ5V1CyqFoMKfr5CIJsF92keeeIreEH01THfTd0132N7QdRiP7bS4ft5jN4U8aoMrzKw5OgkRe4SuPEjxgXlQQnOwz7XKmVpwVnr2ajG87Czd5oaPL7l+aiXjAAa1DonR6FXF0PTY6dNfXyFFWLXwRzXEKgdpGX4fgPTa23tPA143xOS8+iHCIbEzMm+eQfWDQkiJrunLgFGwomSNnUG3bR9vjXSfGQJm0mvYkVNJwbQP0JMHD6/y1jFOB6qlEMgDjak4yV+hpp5pGdpJ5ryX4fwYFgwt6k6NEYcrrzsdkpqAHOha2d70oTykyCzRPAS1hYcJuABYtu0qg+8bWi82R/YfC/sKkAjJZ6tEdiLvnA1Penf9Gh9nV
 70PGVMZQ
 1KsTwXrJDx9eq99P+a5OONH9TC/jz1eVWEqAePCwMbt4V8lLBgWA2hEaSQP6MQkXjEt19zay9ke1uutyVXwjVLPjgCd6mb3k41v8PpnGPu46u2IZyeeRZNwlp6S/eX8pBTzkJNPOOduhRHD2fadx5VmZERSJYhNBonP8cjZ5/pDfGcv9OpkAV1Ff61k8XjHEUExp19up+bTVAqYRxTnD633UCzRv4Pzb5+iGNT78K1OrayDDMiUj0HLa0pVzS5ruXYYZqZKOop7sDji4deEQQS8kQ9FdQ7/CF/JKRBLlT6Bb92koSmOvPftTjM1B1KniCIZ0SYvUWzUKRkiUihw9bAiCfzAxcu/M3bzaa/5PntL6pbGSr9gmvw1F16h+boRq4Gt5eh59j2nzyPbJocr512nSwdlo0aHBrNqkp+G489KHh11nJOQG2+Ta9M/1Hsjmy+7GOusgo/FVONIH2R/cHMwM5T5bLnREP063P9s6lqBv7bPOVbRXnnbwMB8cBw0nCa7ke0yMR8Nhnwh9BRZ9mNKBku40s2qVVw1yR7S5INm9fdD7xBHKAvWAzCKR0zUUCc0BZ/XbPW893mD/20D2GmU1wHnXgoLa/Rl3jdll/D1iFKi9TO43IfQ1wVH2GSwSP7deb1wfXeoFc9Cd65MGX2JMG1PV47wwUGAaSmTPtXUmxYfz4gS/tF0jFF91tJfDGqOLNCva1klhZcc1s1sI3L1rFZvTsJjq/ODsb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/tmpfs/v4

This series allows userspace to preserve files on tmpfs mounts across a
Live Update, in addition to memfds. Today only memfds are supported, so
userspace has to put every in-memory file it wants to preserve in a
memfd, which works for VM guest memory but not for other files that live
on tmpfs mounts and need a path, owner and mode, such as in-memory logs,
binaries, and configuration files.

The kernel preserves the contents and size of each file, and the file
position and seals of memfds. After the Live Update, userspace creates
an empty file on a tmpfs mount of its choice, with the owner, mode and
other metadata it wants, e.g. with O_TMPFILE, and the kernel restores
the contents of a preserved tmpfs file into it. Userspace then links the
file at the path of its choice, so userspace decides the directory
structure, names, owners and permissions of the restored files.

Patches 2-4 come from v1 of this series [1], posted by Pasha. They add
a file-handler-specific argument to LIVEUPDATE_SESSION_PRESERVE_FD and
LIVEUPDATE_SESSION_RETRIEVE_FD, as suggested on the RFC [2]. The design
of retrieving tmpfs files was discussed on v1 [3] and on v3 [4].

[1] https://lore.kernel.org/kexec/20261015093816.2438942-1-pasha.tatashin@soleen.com/
[2] https://lore.kernel.org/kexec/2vxz7bjmkjeu.fsf@kernel.org/
[3] https://lore.kernel.org/kexec/atE53vmlDeA4cWD2@google.com/
[4] https://lore.kernel.org/kexec/20261105-sitzordnung-nahkampf-ausbleiben-6db911d0333e@brauner/

Series Overview
---------------

This series implements the following:

  1. Remove an outdated list of steps from the comment of
     luo_preserve_file() (patch 1).

  2. Let userspace pass a file-handler-specific argument to
     LIVEUPDATE_SESSION_PRESERVE_FD and LIVEUPDATE_SESSION_RETRIEVE_FD,
     and let file handlers mark retrieve failures as retryable, so that
     userspace can fix a bad argument and try again without losing the
     preserved file (patches 2-4).

  3. Rename memfd_luo to shmem_luo, since it will also handle tmpfs
     files (patch 5).

  4. Fix two existing problems in the retrieve path: a WARN_ON() that
     userspace can trigger when tracking a retrieved file fails, and a
     leak of the preserved folios when a retrieve fails before it
     restores them (patches 6 and 9). Then let shmem_luo retrieves that
     fail before they restore the folios be retried (patch 10).

  5. Let file handlers retrieve into an existing file: They claim the
     file before they restore the preserved state into it, so that LUO
     can reject a file that it already manages before the preserved
     state is consumed, and LIVEUPDATE_SESSION_RETRIEVE_FD returns the
     file descriptor of that file instead of a new one (patches 7-8).

  6. Require permission to preserve a file, since preserving a file
     freezes its size for all of its users (patch 11).

  7. Retrieve files preserved from a tmpfs mount into an empty file that
     userspace created on a tmpfs mount, passed in the new struct
     liveupdate_shmem_retrieve_arg (patch 12).

  8. Allow preserving tmpfs files (patch 13).

  9. Add tests for which tmpfs files can be preserved to the liveupdate
     selftest, which doesn't need a kexec (patch 14), and add a kexec
     selftest for retrieving tmpfs files, split by feature into several
     patches (patches 15-19).

uAPI Changes
------------

  - struct liveupdate_session_preserve_fd and struct
    liveupdate_session_retrieve_fd gain a 64-bit @arg field, a pointer
    to a handler-specific argument that starts with a 32-bit size
    field. Callers that pass the old struct size are not affected.

  - Passing a non-zero @arg when retrieving a token that was already
    retrieved fails with -EBUSY.

  - A file handler can leave a token intact when a retrieve fails
    before it consumes the preserved state, e.g. because of an invalid
    @arg, so that the retrieve can be retried.

  - New struct liveupdate_shmem_retrieve_arg, with @fd, the file to
    restore a preserved tmpfs file into. It must be an empty regular
    file on a tmpfs mount, opened for writing, and is returned in the
    @fd field of struct liveupdate_session_retrieve_fd instead of a new
    file descriptor. Files that were preserved from a tmpfs mount can
    only be retrieved with it, and memfds can only be retrieved without
    it. Before this series, the memfd file handler accepted unlinked
    tmpfs files (e.g. created with O_TMPFILE) by mistake and retrieved
    them as memfds. That was a bug, and such files now require the
    argument like all other tmpfs files.

  - Preserving a file now requires the file to be opened for reading
    and the caller to have permission to write to it, and append-only
    files can't be preserved (see Permission Model).

ABI Changes
-----------

  - struct shmem_luo_ser (formerly struct memfd_luo_ser) gains a
    SHMEM_LUO_FLAG_TMPFS flag in its existing @flags field, which
    records that a file was on a tmpfs mount rather than the internal
    shmem mount that memfds use.

Permission Model
----------------

Preserving a file freezes its size until it is unpreserved: For all
users of the file, truncating it, fallocate() and writes past its end
fail with -EPERM, and the owner of the file can't undo that. Without a
permission check, anyone with a session fd could preserve e.g. a
world-readable file in /dev/shm through a read-only fd and break the
owner's use of the file.

Patch 11 therefore requires the file to be opened for reading, since the
retrieved file can be read, and the caller to have permission to write
to the file (inode_permission(MAY_WRITE)), but not a file opened for
writing or a writable mount. The owner may also preserve a file that is
immutable or on a read-only superblock, since its size can't change
anyway. Append-only files are rejected.

The checks apply to memfds too. They only reject memfds that are opened
write-only, or whose mode was changed to deny the caller write
permission, since memfds are created with mode 0777 (0666 with
MFD_NOEXEC_SEAL).

Retrieving a tmpfs file needs no permission check beyond a file opened
for writing, since restoring the contents is a write to that file.

Open Questions
--------------

  - Should LUO enforce the permission model for preserving files for
    every file handler, rather than only shmem_luo?

Merge Plan
----------

This series applies on top of the next branch of liveupdate.git
(commit a0dc8eddbfdb ("Merge branch 'lu-pci-preservation' into
next")) and is targeting Linux 7.5.

The series will be merged through liveupdate.git.

This series conflicts with Pratyush's "mm: allow freezing mappings"
series [5], which also changes mm/memfd_luo.c and replaces
shmem_freeze() with mapping_set_frozen(). Whichever series lands second
will need to be rebased. Keeping retrieved files frozen until the
session is finished, as suggested in [6], is left for Pratyush's series,
since it needs the AS_FROZEN mapping flag that series adds.

[5] https://lore.kernel.org/kexec/20261027173031.763213-1-pratyush@kernel.org/
[6] https://lore.kernel.org/kexec/179322496574.1894369.544573858973645958.b4-review@b4/

Testing
-------

All patches were build-tested individually. The series was tested on
x86_64 in QEMU using the Live Update selftests:

  - luo_tmpfs (new): kexec test cases covering the contents, size and
    holes of restored files; that only the contents and size of the
    target change; which targets are accepted (open for writing, empty,
    regular, on a tmpfs mount, not immutable, not managed by LUO);
    executing restored binaries after the session is finished;
    retrieving files that were preserved through read-only fds, on
    read-only mounts and superblocks, and immutable files; block
    accounting on the target mount, including large folios that extend
    past the end of the file; mount and memcg limits; memfds; invalid
    arguments; retrieving a token twice; and that no kernel warnings are
    triggered.

  - liveupdate, including the new preserve_memfd_with_arg test and the
    new tests for which tmpfs files can be preserved (permissions,
    read-only and append-only files) and the frozen size of preserved
    files.

  - luo_kexec_simple, luo_multi_session, luo_stress_files and
    luo_stress_sessions.

The selftests were run with vmtest.sh:

  $ tools/testing/selftests/liveupdate/vmtest.sh -T luo_tmpfs

luo_tmpfs was also run on bare-metal x86_64.

Changelog
---------

v4:
 - Rebase onto liveupdate/next, which is now based on v7.4-rc1.
 - Collect Reviewed-by and Acked-by tags from Pratyush and Pasha.
 - Add patch 1, which removes the list of steps from the comment of
   luo_preserve_file() (Pratyush).
 - Patch 2: Pass the argument to luo_preserve_file() and
   luo_retrieve_file() as a __user pointer (Pratyush).
 - Patch 5: Update the Kconfig prompt and help text (Pratyush).
 - Patch 6: Keep a WARN_ON_ONCE() for -EBUSY, which userspace can't
   trigger (Pratyush).
 - Add patches 7-8, which let file handlers claim the file they
   retrieve into, and return its file descriptor instead of a new one
   (Pratyush).
 - Add patch 9, which leaves freeing the preserved state to finish(),
   since the preserved folios may be in use until the session is
   finished. The fix for leaking the preserved folios when a retrieve
   fails early moves into this patch.
 - Patch 10: Fail the retrieve of a preserved file that this kernel
   can't restore, e.g. one with unsupported seals, permanently instead
   of letting userspace retry it (Pratyush).
 - Split the permission checks for preserving a file into patch 11,
   which also applies them to memfds (Pratyush).
 - Patch 12: Go back to retrieving tmpfs files into a file created by
   userspace, like the RFC and v1, instead of having the kernel create
   the file like openat(O_TMPFILE). struct liveupdate_shmem_retrieve_arg
   now only has @fd. The file position is no longer restored for tmpfs
   files, and retrieving with O_RDONLY (v3 patch 9) is dropped
   (Christian). Reject preserved tmpfs files with seals other than
   F_SEAL_SEAL instead of applying them (Pratyush). Describe the
   handling of unlinked tmpfs files before this series as a bug that
   this patch fixes, not as supported behavior, since the LUO uAPI is
   stable (Pratyush). Document which retrieve errors can be retried
   (Pratyush).
 - Patch 13: Retitle it to "Allow preserving tmpfs files", and describe
   it as adding support for tmpfs files (Pratyush).
 - Rewrite the changelogs and comments to be shorter and clearer, and
   drop leftovers from earlier designs (Pratyush).
 - Move the tests for which tmpfs files can be preserved into
   non-kexec tests in liveupdate.c (Pasha), and split luo_tmpfs into
   several patches by feature (Pratyush, Pasha). Update luo_tmpfs for
   retrieving into a file created by userspace, and add test cases for
   the target file.

v3: https://lore.kernel.org/kexec/20261103010216.3447716-1-dmatlack@google.com/
v2: https://lore.kernel.org/kexec/20261022225035.377445-1-dmatlack@google.com/
v1: https://lore.kernel.org/kexec/20261015093816.2438942-1-pasha.tatashin@soleen.com/
rfc: https://lore.kernel.org/kexec/20260901180713.4185641-1-dmatlack@google.com/


David Matlack (16):
  liveupdate: Remove the list of steps from luo_preserve_file()'s
    comment
  mm: Rename memfd_luo to shmem_luo
  liveupdate: Don't WARN if tracking a retrieved file fails
  liveupdate: Add helpers to track the files that LUO manages
  liveupdate: Let file handlers retrieve into an existing file
  mm/shmem_luo: Leave freeing the preserved state to finish()
  mm/shmem_luo: Don't make early retrieve failures permanent
  mm/shmem_luo: Require permission to preserve a file
  mm/shmem_luo: Retrieve tmpfs files into a file created by userspace
  mm/shmem_luo: Allow preserving tmpfs files
  selftests/liveupdate: Test which tmpfs files can be preserved
  selftests/liveupdate: Add a test for retrieving tmpfs files
  selftests/liveupdate: Test memfds and LUO interactions in luo_tmpfs
  selftests/liveupdate: Test the targets of retrieved tmpfs files
  selftests/liveupdate: Test retrieving tmpfs files preserved read-only
  selftests/liveupdate: Test block accounting of retrieved tmpfs files

Pasha Tatashin (3):
  liveupdate: Pass user argument to file preserve and retrieve
  selftests/liveupdate: Add tests for preserve and retrieve user
    argument
  liveupdate: Allow file handlers to mark retrieve failures as retryable

 Documentation/core-api/liveupdate.rst         |    2 +-
 Documentation/mm/index.rst                    |    2 +-
 Documentation/mm/memfd_preservation.rst       |   23 -
 Documentation/mm/shmem_preservation.rst       |   23 +
 MAINTAINERS                                   |    4 +-
 include/linux/kho/abi/{memfd.h => shmem.h}    |   57 +-
 include/linux/liveupdate.h                    |   81 +-
 include/uapi/linux/liveupdate.h               |   59 +-
 kernel/liveupdate/Kconfig                     |    9 +-
 kernel/liveupdate/luo_file.c                  |  213 +-
 kernel/liveupdate/luo_internal.h              |    5 +-
 kernel/liveupdate/luo_session.c               |   29 +-
 mm/Makefile                                   |    2 +-
 mm/internal.h                                 |    1 +
 mm/shmem.c                                    |    9 +
 mm/{memfd_luo.c => shmem_luo.c}               |  369 ++-
 tools/testing/selftests/liveupdate/Makefile   |    1 +
 tools/testing/selftests/liveupdate/config     |    4 +
 .../liveupdate/lib/include/libliveupdate.h    |    3 +
 .../selftests/liveupdate/lib/lu_utils.c       |   17 +-
 .../testing/selftests/liveupdate/liveupdate.c |  347 +++
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 2103 +++++++++++++++++
 .../selftests/liveupdate/run-vmtests.sh       |    1 +
 23 files changed, 3162 insertions(+), 202 deletions(-)
 delete mode 100644 Documentation/mm/memfd_preservation.rst
 create mode 100644 Documentation/mm/shmem_preservation.rst
 rename include/linux/kho/abi/{memfd.h => shmem.h} (53%)
 rename mm/{memfd_luo.c => shmem_luo.c} (54%)
 create mode 100644 tools/testing/selftests/liveupdate/luo_tmpfs.c


base-commit: a0dc8eddbfdb6dd9c5c2b70eb66ab49cb1978425
-- 
2.56.0.542.g3ef89b7020-goog


