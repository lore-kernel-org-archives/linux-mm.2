Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76049C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 17:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B0E6B0317; Fri, 14 Aug 2026 13:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642A56B0319; Fri, 14 Aug 2026 13:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5313B6B031A; Fri, 14 Aug 2026 13:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21E2C6B0317
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:05:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99C5F1601C9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:05:13 +0000 (UTC)
X-FDA: 85100500506.30.BAAA00F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1027C120002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:05:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebwNvCqU;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786727112;
	b=X0WRW5E5PocsY9lZMpzOlgMdX1I1qDnnarhoDgcaKiGqxAUHsfloCLZ5Yq1vdAM6fzJYvO
	o2YucZzF6oLhKcJDH5okvl4lEB+BEb9m1XBCfRAxML5nPGPsmtm0kDbar+D6DLNoTZqlWD
	TEEgzxzBlw5cxNKjSy+8I3WkrNMsJmM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebwNvCqU;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786727112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/oq0HBoJMRapoD7XWtIdy5xy+Ds8RrmKGd6Lc/Pysc=;
	b=ff979KoQv5HnJJbjohjtd0AlGu59l/wsKFHzcs34goJ4M9dJBiHfS/TpgMew/zPSINL/Zi
	WWRY8SXCt7+644P/QDt6YI4HYar8tvuzsi5cC/ow0yZtXKxFSBv/poCh4T7udKIGGVD1al
	vLOSB/z5q6FMpehmEjfax4rivqGZVAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69D9C601E0;
	Fri, 14 Aug 2026 17:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E461F000E9;
	Fri, 14 Aug 2026 17:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786727111;
	bh=X/oq0HBoJMRapoD7XWtIdy5xy+Ds8RrmKGd6Lc/Pysc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ebwNvCqUju/eAaqKWY2V19wi/U9Lgt/o8wQot0+G2TbFHEvlXiLg0BCdU9eT+x79Y
	 YyWDrqJD1bqXn15z4tYiP2yWmfOxFMSrwUCq+0KgINHhXxRzNnMatX0TyRRB+EVWr3
	 +RDRwR8uLF1gVT4ee1tcNIxVuuzuMdm3Vkn98rX6Y4j/P1eHQqd9CCAgDe0LDC9NXc
	 6Mb8UdJT55rfklnAnJd9Y0Bc78PiZi6kd65v64/v27mEyX429i9ys+xvoeva0cmCrh
	 8iLtVm32WSB26NoDgxdTTWuqNbB89txZW4zVjbp+DF6FIe2oq9B2BC2FxY7CrfVDUK
	 Tg2xmyIrwXcGA==
Content-Type: multipart/mixed; boundary="===============3060449598212239265=="
MIME-Version: 1.0
Message-Id: <a13e1c45f40c04350b700e6b2ad5bae5dc72c8402ec59b0edbfb7907e90ca13e@mail.kernel.org>
In-Reply-To: <20260814075054.507089-4-ziyang.meme@gmail.com>
References: <20260814075054.507089-4-ziyang.meme@gmail.com>
Subject: Re: [PATCH v3 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 14 Aug 2026 17:05:09 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1027C120002
X-Stat-Signature: e71migm3zqrs5ou1x7rr6kjp56knrugi
X-HE-Tag: 1786727111-177495
X-HE-Meta: U2FsdGVkX1/0DfvyOnZAGc52Q7YFeMBBwDiJgwZ8QnpSrVh+u76yur0Z3Bxs9I3jjVy21szj65RulQcGzO1NIM1/IWwECp3qJKrQvS8G3/6QhZtD7xPMub8Y2i3bimhlS/sarZf7J6joVQzPIEihISKmKFEz9zGrnvQqcNYbuHyeeaM/Z+IUTDHGMlp+w1CTCpz/mC01KKIVn9tIZI0dRKQF4dQu+zMoTPDUj0UPFQnxPzd8wDOVyOMfD7/aohpDTqoyzhmvpZK1fGtfj9qjRBfEiI8mqBEzlRpXjSYt6iViBk+4hl45yl6d6eZZP8YVSX2AMmRtPz0xhI2tdX2KhGzD1txryyGZqECDymtsjxTYxKP2wgD8bCqXsq4aw0XxPz6JuxNDEVFXH7nPWcdH07eookKcHnrrOv/8qpcKmXehyeVvNDhTidIy52if42DvrJqKf+V89TDZFxACpS1sqxuyIbICZqN5MQQy/eTCUbjRyYC/GmeN8B3cv1CWlO5eqdE3pXgRyETghuRTAguuoYL90Lb6v+s3SYhf9iDanz9cyzqRzUMoWgduFmzNYOgvBGVqusPsZb3Di2SAcCHkzSVXub6nYflEiMylfQCViljltqFkU6A0EjXBTnVpZuQ/Vc/peB3zESmhFqo1etBR2V1vg8dh9vxca9GgMxdHgHnZaDWHTa12zyFtjqzTwwuZQKcV6fpA2Yhu+4RApV4vMPZTiZCn1k99aJWe/WUuWrxBIVAcKTUwfBrwVoUzxNzqXIFubydu1BGjcREl+l0jNoyoJpwH3W1NKybmFaXsu/q2IclrT03JsDK9Uy+ZnOZPRqa/ZRU5YDZaalPu4Vy+RbxiU99tkQAMZnfN4bH44On3png+hXnflPrOqiVYqNVLZIe7vnSwl91glmbg1zyvGloEy5DvRDF/fjTFObcnsf3aX4iSUOEAUiG2z+Ms3qYnCMfKM0ta9ep9Bqao600
 3EXoBfzF
 4Wfbu9bpEIlZxHe4slcjm+w4ccDp9XyJWJOPZxl49tLyPZ2DDvf0CmtsEzby/qJE3DBEqzrRibZUJDpomQ3COvlYIBaUa4TJuUVmUUJfe+bRvqtRllsnehH4oJ79kbkrxA1gR89FBHoZKIyv6I9RMCZRzSCvNmbr5Q8cadkf+gPdsyuNFepWuLqSNdewu6K3F4Xctj4YQm0t+IZvP6m07rNlNRxQfS5LUZc+mDGXcSNdB1cooj3QYtT+lcRat91IVelndgmQJZa4SIdFiMds7skTVHNAMux2IpsLcjxou33WE2qR2K37ec02EAgB1hJqw6ojC6+xfjITxyXYESiSuEgYW3J3tRARYzoJyIQE/sMPOb9bXkoCWb6aV2oOQ8QiHmmHHuppznOJectvqt0wBHTEq+bpF62vt5wW5tQ26cYYVIGagAEFyWiBJ7CnlS4saRKdSlTKhxG+BcnzjsapzBTVkbgX2ccXhhcRG+OSHuPaBmMV+QMSqipxmrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3060449598212239265==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> The generated hid.skel.h public API is same before and after, hid_bpf
> and hidraw are built and linked the same way.

This isn't a bug, but could the changelog mention that the BPF compile
flags change with the shared fragment (added -Wall/-std=gnu11/
-fno-strict-aliasing, added include paths, auto-detected -mcpu instead
of a hardcoded v3) rather than describing the build as unchanged?

The flags used to compile progs/hid.c do change: the shared BPF_CFLAGS
add -Wall, -std=gnu11, -fno-strict-aliasing, -I$(APIDIR)
-I$(TOOLSINCDIR) and the clang system-include set (which the old
Makefile computed into CLANG_SYS_INCLUDES but never passed), and -mcpu
becomes auto-detected (v3/v2) instead of hardcoded -mcpu=v3. The
-Wno-unused-variable line the patch has to add is direct evidence that
the compile flags are not identical.

> diff --git a/tools/testing/selftests/hid/.gitignore b/tools/testing/selftests/hid/.gitignore

[ ... ]

> diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
> index 2f423de83147..1d7c64ec992c 100644
> --- a/tools/testing/selftests/hid/Makefile
> +++ b/tools/testing/selftests/hid/Makefile

[ ... ]

> +# progs/hid.c is built into a skeleton by ../lib.bpf.mk.  hid keeps the legacy
> +# progs/<name>.c layout, hence BPF_PROG_EXT.  BPF_EXTRA_HDRS is deferred: it
> +# uses $(BPFDIR), which lib.bpf.mk defines.
> +BPF_SRCS       := $(wildcard progs/*.c)
> +BPF_PROG_EXT   := .c
> +BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
> +		  $(wildcard $(BPFDIR)/*.bpf.h)
> +# hid.c predates the shared -Wall and has a few unused locals.
> +BPF_EXTRA_CFLAGS := -Wno-unused-variable

This isn't a bug, but would dropping the four unused locals in
progs/hid.c (the `int i` in the three hid_user_* syscall programs and
the unused `int ret` in hid_test_hidraw_output_report) let this
directory build without the -Wno-unused-variable override?

The shared lib.bpf.mk compiles BPF objects with -Wall -Werror, and this
patch reacts by permanently disabling -Wunused-variable for every BPF
program in this directory. The trigger is exactly four dead locals:
`int i` in hid_user_raw_request(), hid_user_output_report() and
hid_user_input_report(), plus an `int ret;` in
hid_test_hidraw_output_report() that is never assigned or read.
Deleting those four declarations would let the directory build with the
shared warning set unmodified, and would keep the suppression from
silently hiding unused locals in BPF programs added here later.

[ ... ]

> +EXTRA_CLEAN += feature bpftool $(addprefix $(OUTPUT)/,*.o no_alu32)

This isn't a bug, but since the no_alu32 build rule goes away in this
patch, is the `no_alu32` (and `feature`) entry in EXTRA_CLEAN still
needed, or could this line shrink to just `$(OUTPUT)/*.o`?

The rewritten EXTRA_CLEAN keeps the `no_alu32` entry, but this patch
removes the only thing that could ever have produced such an artifact:
the CLANG_NOALU32_BPF_BUILD_RULE definition (and hid never had the
selftests/bpf per-flavor subdirectory machinery that creates a
no_alu32/ tree in the first place). Now that the flavor rule is gone,
nothing in this directory can create $(OUTPUT)/no_alu32. The `feature`
entry is in a similar position - libbpf/bpftool feature-detection
output lands under $(BUILD_DIR)/libbpf/, which is already covered by
the $(SCRATCH_DIR) entry that lib.bpf.mk adds.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31820214629
--===============3060449598212239265==--

