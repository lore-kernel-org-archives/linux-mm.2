Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA76A606A33D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lCmT3vgU
Received: by kanga.kvack.org (Postfix)
	id CFFDA6B00EF; Sun, 15 Nov 2026 09:02:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0BD6B05B0; Sun, 15 Nov 2026 09:02:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78B96B05B1; Sun, 15 Nov 2026 09:02:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89A1F6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08032C0738
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:16 +0000 (UTC)
X-FDA: 85437517872.24.8756E04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 407EF140010
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCmT3vgU;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C0hZCZ1HlArCnNua5WGJXPR4s/dAC6fjh9Brf5xLf/I=;
	b=yAgUH+KXnWJlWi/37yl/OeFYmMXqOjR0g9ZhDwgclqodvuqZM+ckfvLs4mjDfTurUZEHK4
	Ow6VmZojCYgH6YYPZNSjl+MU5pFQYtl/n6OHaTHzNjA/oX5FHWmrTEryW9ZhbHXpka14/N
	Q0/+ZQUFteABLw/M+f4eY1EKa12YbnQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751334;
	b=szkabYa4NDa4ej1UYmzQTeEWkeZ2630znLxnp5R4QAprfIeX7+i3GSP7hyWOc36JsXG84+
	9fwIA34vsPmw6zoFSZte0ykjSKVDgrB9WF1EuyaWrqFU30vbhb7L1e1tlRhfJr8nhG2m5O
	tNh4BI34r3uKjdYlUa2hohPieqCZwhs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCmT3vgU;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 655A160EF2;
	Sun, 15 Nov 2026 14:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7041F000C4;
	Sun, 15 Nov 2026 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751333;
	bh=C0hZCZ1HlArCnNua5WGJXPR4s/dAC6fjh9Brf5xLf/I=;
	h=From:Subject:Date:To:Cc;
	b=lCmT3vgUByzTeA9R757hy9aa0HZE4kCVK0A5FBSbwAooKZHJJK5oK2QqoPEHWyoRJ
	 swdVTlXDdJUVBnvWkHnXkipTzyAaAqAS70tC39ZUzbXkKiiE+btYREERd5StseDTbn
	 zcWzdziNnXo7X8mLYhlfZiPFvM6GhaTPKVNQ4SNKWtudv3284JWjz5NKhzyuvhykbo
	 ovdYHOZj3BYLhEEY0IXslCiJifUqNJRF1mJ/5GrBXZVB7wuVcQMnbQQ4wxPOeBmK1F
	 BFH5jgiZxb185bU/PJcIc3uCfdbR8kKmCpMNI1ltjBdq0NvcTQJfswD215TGXdMxuI
	 HmHiQHeWiNVOg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 00/13] fs: let d_real() fail
Date: Sun, 15 Nov 2026 15:01:30 +0100
Message-Id: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMWw6CMBBA0a2Q+XYaWoJJ3YoxpI9BqqQ1U0UTw
 t5p5fPO46yQiQNluDQrMC0hhxRLyFMDbjLxThh8aVCtOkspe/wmfmJaZvQDk5lRSa271o+aXAf
 l68U0ht9fvN6Ozh/7IPeuTL2wJhNaNtFNdVRBUUBxgKKuYdt2HWulIpoAAAA=
X-Change-ID: 20261115-work-ovl-d_real-219930df9ec3
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3833; i=brauner@kernel.org;
 h=from:subject:message-id; bh=pa24T6yCoOSBNbgGCY6AwfmcBlLS5Ar6zkTbMn0Wgmg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93O2vqVrhsEVk8w8bwRPB9mu2b58txH/6hPzbCzOYZ
 7yfu3bL5Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ7DvK8D+374Hlzv9ipvZl
 Rq1dFcfahVq2mU5V8n4bsrj5WOOGjjhGhnYt3WqWp77Lo13D994t4tVteLmD2d3HMMT838fvTsd
 uMAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7dh1137dkdpcdcree1a3c4dfp7xaau53
X-Rspamd-Queue-Id: 407EF140010
X-Rspam-User: 
X-HE-Tag: 1794751334-386850
X-HE-Meta: U2FsdGVkX1+f0MmgUO/qPHtJ6Cd8LpsEbkP1AbURnkQ3Wh40cwaraawAqRlbmm5pWH0EFWq9yyHMP9y6/SRk3t/yxnMrGVZZFvF7dvA3boiYLPPydK2DMDZAwlMFl40mNe06Njgw1a2m//l62MjhKdqBkTTR055N71LXYa7hao+h1IMuSZb+PioItw0UiP8DH9TwBRFJEJZakSbbd3p1ULxjxI7/kjhBrqP9qTnZvebEvtAcXocHPOUYJSAY2b6wFbvXB1h4RXt9qZzlGT9g9UhrUSawMIO0jeF5UDzanhcq3ycBHIv1Dzj+qYavR/ilhoPGLy5Kr8DMXfP1U2cQ7Iu4TsJkuhG7sBoryT0F4rZtljFifX6usQayiQwlnVOs2LyhalTkARyoVe3zZNKSzL0Sp0kGFsDKrjy3ahVLQdJmf46r/QBEpSpRfxOyOE0Thbl864XTyy7nGvvaqWQqEnwIs3RnCS2+pJnNXLaN49T9dR7ueONN0OgV93dZPi7hewEoGUDCMKEwsOAD+LdQuhnozxOgLMu5tcOeXfasOFOAELEG2CpB5PAGd3O+Bp6/j2BhUEhun22VA4RVeo55GtQag4mbaalI7ybhOpSacFyyqFNY9U1YIEKXsskxsIGlZYETIG5Lv5h2obdNMN7cvd093yvYv0I4ZrISUQNxEsuwFVdExxrsCREOQshCw8VYttCPsZR/70UWBdrPDL/u0LrGG/MuWndQyzzsfINT2H4JkYtuiR5fpL70TlMCs1P/nxpz4Acg8PCdAHSF8Kua5CYGcpgTnlGJEqz+1KbKL4xUJjL65BxodAii+c4JFEYFF7tD2+q5MGWX5pb7+rNATd7K2K8zSd8KkXviiQWo4srcCVNMMX71GkljVc5vFAI/7t3/yPiZs4X9ulrJlRy2nOdY4aoJDnWa1Dshh6RryLnAz2TTZ91VbsLgcsbi1hOY/IN9CT+HbBx1/cWEC4c
 uka+kuLd
 oCJhNyvrsZPZ6xPTt+lI/ncRNi5Pcz79F1085N5Hl5KbbGxYRyb9J3WlXmjyZSllq7cfFLInxK0FPbDEezX+GSJeyXWBor+N/EozaB+7Bx2hCL8inW6aIy1DH37DM8Rj2eJKsIXqFeO6r6LWM2KSBwXNiEVwS7JvI5355mN/jsBcTWo9QpQY2xDeLAT7bN90T07JyLrWC8t9gslU1mLeCZAfudBx5TlIMyzFpw2h/7/fIDBXVL8XSHsNYjoRWiHQaw36Cn8ExGpyG39NNA7b/2D3QA5DTJOpoDqIq
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
to hash the file, IPE denies and the bpf kfunc returns NULL. Then
d_real_inode() goes away so nobody can ignore the error again. The first
patch only drops the WARN.

This came out of the same work as the freeze protection fixes for
backing files (cf. [1]). I ran into it with the pseudo filesystem
series (cf. [2]) where file_check_backing() looks at the file hosting
the data of O_PATH files registered for fuse passthrough. With this
series it can just return the error. But this stands on its own.

[1]: https://lore.kernel.org/r/20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org
[2]: https://lore.kernel.org/r/20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
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
 Documentation/filesystems/vfs.rst                  |   6 +
 fs/bpf_fs_kfuncs.c                                 |  13 +-
 fs/overlayfs/super.c                               |  19 ++-
 include/linux/dcache.h                             |  47 ++++++-
 kernel/trace/bpf_trace.c                           |   9 +-
 kernel/trace/trace_probe.h                         |   1 +
 kernel/trace/trace_uprobe.c                        |  57 +++++++--
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima_api.c                   |  17 ++-
 security/integrity/ima/ima_main.c                  |  11 +-
 security/ipe/eval.c                                |  15 ++-
 security/ipe/eval.h                                |   1 +
 .../selftests/bpf/prog_tests/uprobe_multi_test.c   | 141 +++++++++++++++++++++
 .../testing/selftests/bpf/test_kmods/bpf_testmod.c |  11 +-
 .../test.d/dynevent/add_remove_uprobe_overlayfs.tc |  92 ++++++++++++++
 16 files changed, 408 insertions(+), 44 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261115-work-ovl-d_real-219930df9ec3


