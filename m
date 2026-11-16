Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C903B606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlABBZ7I
Received: by kanga.kvack.org (Postfix)
	id D1DFD6B00EF; Mon, 16 Nov 2026 04:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7AD6B05B0; Mon, 16 Nov 2026 04:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F746B05B1; Mon, 16 Nov 2026 04:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 840306B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:44:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A13A12053F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:40 +0000 (UTC)
X-FDA: 85440497520.24.B27989D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35CDEA0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlABBZ7I;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822278;
	b=jisPq8wF9r0pwzztUETG/liYptTVKTByxEPatXfnvZyaZbHp5b1+bCy4uwbgUKg34NI0AW
	2Bho9P7mlZ6mKYiCb3wT6Jd0OWgVywPVqIVjsJXpth/ubsZlXqPMCDnMhe00Ho27+s2f2G
	ni9CpZlOANusqgSFoYmQFn8yvjOwQ7E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlABBZ7I;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hgAtcboDPL4W6fp361vuNgNH6+9aIO13zK6GxzA5b0w=;
	b=fMc5Z5BLEMmRWkQM2kvyNXODEhcsdio8ro2xNFFY5CJCwmg7jHdALuKlWqr/qKDtdog7FK
	pB0neATpj8lYyGS9Tdm8t0sZ8ek/6Lx6s1JKCXTREKIeGGKQ8gvJ5jXuOOdSrk0eGXm1za
	hbgNSgcDNH6WjYnMr3ruiOY7WMLXrco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 172E7408A9;
	Mon, 16 Nov 2026 09:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0C01F000C4;
	Mon, 16 Nov 2026 09:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822276;
	bh=hgAtcboDPL4W6fp361vuNgNH6+9aIO13zK6GxzA5b0w=;
	h=From:Subject:Date:To:Cc;
	b=YlABBZ7ISyY8j9P4gftvIQ5fQX3zDPKib7Xm2Dt4ZAhPRcGr+/KKlsHo/3tOVOal8
	 umF+AfHn881H4gGHyQN8o6pBKilCFGTV8WGl8O54Gzsoe52282VhJ8IohFXYzjILeM
	 Let/7ORvD2U4VNGTjZ62YCYccjeKWpE4tjn+M7eBrWMbQLXcsp/coEvxLhRAydF8Qt
	 O58FMbiYeMX+2voIsP9thDz4sR4bxAa7U6nSggyQFkgKv97uk0tUgDno7ZuSnIHRAl
	 cLJWQF4d53VBcI3pFOVos3Ff6CwRk91RoPBANnUL3EmQTBdtN4B+XLy+HRqNOAMy/H
	 6T9wmN4DB3ovg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 00/13] fs: let d_real() fail
Date: Mon, 16 Nov 2026 10:43:57 +0100
Message-Id: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WOQQ6CMBBFr0K6dhpaggmuvIchpi0DVEhrplg1h
 Lvbwtrlm/n/5a8sIFkM7FKsjDDaYL1LIE8FM6NyA4LtEjNZyrMQooa3pwl8nKG7E6oZpGiaquz
 6Bk3FUutJ2NvPbry1B4eXfqBZsiYntAoImpQzYz5lIU9Cfgh5fufYaMPi6bsviyLr/o+IAkowS
 tQ19tpoidcJyeHMPQ2s3bbtB2HccVPoAAAA
X-Change-ID: 20261115-work-ovl-d_real-219930df9ec3
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Fan Wu <wufan@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4516; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FpAJ8KCoIs10Y+5ts8jOVO0UnpzoDHqYPZv0TdThKa0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9upD3SNq0pzY55Vzy72eZf51fdBpUzJKr4e5eVP+F8
 3ic7q/EjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInsS2D4KzK7arksS08gw+99
 c9d5rrl0U1OwwGFl8U7lEyFLTyx48oThn+rPlE+RWx+uM/7D9GSh1cfUCMlTd1cKLFOfEFLqsDn
 sIzMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ugm4ofyh8pnshsrmwg7ra7zhkbzuf5e6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35CDEA0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794822278-220561
X-HE-Meta: U2FsdGVkX1/cFE57RzviDKBCxsYKX6wLJbqYHo8u0aBM8RBlxAR7qfqia7NQA24L2c3NwD86vlcTIoR75raUh7Bs+/U0XybYrLZOKBqgMxp8oxvTjORPw4kVm1d6GBLEYziTKpUX0rUSGKApPoTQW2SInqxEBq9+yHrnnHc1xa3hU5p1uXFSw+1UdMu1T/X9GaQyfj8ML7HKdAkAzzVAkTR7CeIkhRLa03BqvlqsFS5bTWg2z6o/Y/UO6Z4OuFm4RGg9S/nTz8RFYNh8zY4dJmwt+48Xl0bcrr02jPmbYDU6efThvu620gdogtLGbeHiXMO3JGzg/0xQF38/KHuRHEnQkoUgzIPsUDpXUEBQEHeNQnh8GY6Byso5FweF9x+r2aPmT3YQtuXuh0WVO0I2SZTyyYKoRTD9AGQOcYaOEEkOSQX/kP4h5XaHJyJeEV7Yx1Zmt9JGBYV86m2NLN+gQhrcoHWFiICcxRxPM2b7GTUuMLZRA39wwEkL/KfyuNrTn5L1I4liaEJGzrixoRgaMG5QNKhN0GNecvJTQM8xHaM1/xwaI6mcskQJIdDOFPtOd7QOxtIiGf51DWMCClH9h3YAZvU6nrSbqVoEeIvmFBUMtXJCG+tuf/5hfy9gl5YX9V0D5fXARCakRNrp2fEEbiUvei8WSKE01jVMR35B9jtk/GfHxLi3DpFMea3aAfVx6/7mDD2W5SSUwOE+AoOAPmX7PKGRBRi17E9BxLtVtwnmHhJJkdsctafci+m2vP7d1vuuKiLIU17zQOcevSufyeAn66U19D/czZDA9GiI+HNET1iXyopYT5Ho2CTztKIa8p50/Ez5bpAPa8wK50/STm36JOogqgtvfdigXqxaAwgIuk5n9uBqs/+QEA8SKEjNm17h5XGQ3+7+Nl7ouS97DuhfNJLMmtJAj7wjWVO/FZAKmXGV1Bv4wZMKCl/MnoGHRaA2XRVYqTt562+SvhQ
 lKXWQFfo
 /c/H5fUwRktyMMNtz7L66klFfsu/WAmS6YpQU2McsqaafibGX+rputDUCumpbSPpaC8ng8nR5saMnRLTjCXPTidGgAT2EvaFJ5IzKr+y62DU6qLjF7ul7XsDhtYdhgBH4g46XyLZDY0ldKmwCuJXhmaJEiRH1S9Shb86CP9cDtXmi0LBNc7tvYy8v+Zm+tVoQ0/OmgmVn7X/5UVxeG2dhXqkv8A7GdYB4IQtcD12a+9sXGJH76DDr2FZTd32VItb2nqR2gaD8xvISF9V0pvu8FKMNkPb3tx9Qybnp/2r9mcUiULJIAqbiE18Qu/eBFjdkeX0b9MjPvQKmuz7JINgiTYQWXCDi9s9d2u1fNt5x6dLYY7Hwryk1ddN/uCUtJIoSrzQe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

overlayfs looks up the data of a metacopy file in a data-only layer
lazily and validates its verity digest when it's first needed. Both can
fail but d_real() has no way to report it. So ovl_d_real() warns and
hands back the overlayfs dentry and every caller silently works with an
inode that doesn't host the data:

- uprobes get created just fine and fail later with a bogus -EIO. Every
  new uprobe warns again for each of them. With panic_on_warn that's a
  panic.
- IMA skips detecting changes to the backing file and hands out a cached
  verdict.
- IPE evaluates its policy against an inode that has none of the
  dm-verity or fs-verity properties of the real file.

And that's not limited to files nobody opened yet. A metadata-only
copy-up of an open file makes overlayfs validate the digest again.

As Amir pointed out the correct fix is to teach the callers to deal with
an error. So d_real() may now fail for D_REAL_DATA and all callers
handle it: uprobes fail when they're created, IMA treats it like failing
to hash the file, IPE evaluates the file without verity state and the
bpf kfunc returns NULL. Then d_real_inode() goes away so nobody can
ignore the error again. The first patch only drops the WARN.

This came out of the same work as the freeze protection fixes for
backing files (cf. [1]). I ran into it with the pseudo filesystem
series (cf. [2]) where file_check_backing() looks at the file hosting
the data of O_PATH files registered for fuse passthrough. With this
series it can just return the error. But this stands on its own.

[1]: https://lore.kernel.org/r/20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org
[2]: https://lore.kernel.org/r/20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Drop the second Fixes: tag from the first patch as per Amir's
  suggestion.
- Let d_real_metadata_inode() fail too and handle that in IMA and EVM
  as per Amir's suggestion.
- Evaluate a file whose data can't be resolved without any verity state
  in IPE instead of denying it as per Fan's suggestion.
- Disable the events before removing the uprobes in the ftrace selftest
  cleanup, skip it without tmpfs xattr support and add the config
  options it needs.
- Link to v1: https://patch.msgid.link/20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org

---
Christian Brauner (13):
      ovl: don't warn when the lazy lowerdata lookup fails in ovl_d_real()
      fs: add d_real_data_inode() and d_real_metadata_inode()
      tracing/uprobes: handle errors from resolving the real inode
      bpf: handle errors from resolving the real inode in uprobe_multi
      selftests/bpf: handle d_real_data_inode() errors in bpf_testmod
      ima: handle errors from resolving the real inode
      ima,evm: use d_real_metadata_inode()
      ipe: handle errors from resolving the real inode
      bpf: return NULL from bpf_real_data_inode() on errors
      ovl: return the error from the lazy lowerdata lookup in ovl_d_real()
      fs: remove d_real_inode()
      selftests/ftrace: add uprobe tests on overlayfs
      selftests/bpf: add uprobe_multi test on overlayfs without data

 Documentation/filesystems/porting.rst              |  10 ++
 Documentation/filesystems/vfs.rst                  |   7 +
 fs/bpf_fs_kfuncs.c                                 |  13 +-
 fs/overlayfs/super.c                               |  19 ++-
 include/linux/dcache.h                             |  50 +++++++-
 kernel/trace/bpf_trace.c                           |   9 +-
 kernel/trace/trace_probe.h                         |   1 +
 kernel/trace/trace_uprobe.c                        |  57 +++++++--
 security/integrity/evm/evm_crypto.c                |   5 +-
 security/integrity/evm/evm_main.c                  |   9 +-
 security/integrity/ima/ima_api.c                   |  17 ++-
 security/integrity/ima/ima_main.c                  |  14 +-
 security/ipe/eval.c                                |  13 +-
 .../selftests/bpf/prog_tests/uprobe_multi_test.c   | 141 +++++++++++++++++++++
 .../testing/selftests/bpf/test_kmods/bpf_testmod.c |  11 +-
 tools/testing/selftests/ftrace/config              |   3 +
 .../test.d/dynevent/add_remove_uprobe_overlayfs.tc |  96 ++++++++++++++
 17 files changed, 423 insertions(+), 52 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261115-work-ovl-d_real-219930df9ec3


