Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9708C606A8B3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=YXO++lUh
Received: by kanga.kvack.org (Postfix)
	id BE1466B05CE; Tue, 10 Nov 2026 15:23:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8586B05CF; Tue, 10 Nov 2026 15:23:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACDBF6B05D1; Tue, 10 Nov 2026 15:23:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9A56B05CE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:23:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4549CA8652
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:23 +0000 (UTC)
X-FDA: 85420334286.25.8265252
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 634084000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=YXO++lUh;
	spf=pass (imf11.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.175 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aNTBUVcEjSCanLMfEBKZfMTj70g+Fn7VorpJWkJr3sM=;
	b=7+pn1Navkfdw70OC7wf0ToCQlvvLz4/SQ+yQjrHSGW4e2xJWYLktZkEHCYr6mBhQOVJzj+
	9ZPvO77J1pUxX+CkUzyOAYZMXtEhHH8FVWzITzC1Zv2qGK1Ok8fNFP6ZkZN2d1HkO9NaG2
	azq5lW/KjqAdj+3ekXadw3avTDEPPVU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342201;
	b=79AsJX8YLQnoFeNRqFrTs6S9SaXianw1xydrYB1ErJ4ud5yA12+JVT/UA/WWYPYlomQdGq
	TrbXcD4B/0FvUnzLySzjuMwRI1X5LWuebPql8ac0VeYd4QcoUjCZM1ck14oNHHH6qwFlBP
	x56qfJMsN3l/mHc/bOeq/LBieUCIpw4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=YXO++lUh;
	spf=pass (imf11.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.175 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io;
	dmarc=none
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-33fb4680717so1835997eec.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1794342200; x=1794947000; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aNTBUVcEjSCanLMfEBKZfMTj70g+Fn7VorpJWkJr3sM=;
        b=YXO++lUhjluViDSWpe4ihJIzT8gIbUcB/+U1cd8FYsSsKQ/6fNsAJyDTUnHLeWWCuT
         wTu/tZ3UqG2qbBN/wlyHFZxAXLF3/ns0G9z+Bir6MhyqKCTa5aW1MZ90ISITPk7ggGH3
         KutDSWHAiMXRmjfeqNiE5YINiQ8rkzSJYsDu6DVMmzOKLa96h1hofcnqW+/HR3lnh3DM
         YD/wUzrFh2eXBqXMcQxuwILLH4CkGpEg1OUQHsxtCFAR38GjrLSFY3X7CA3DWO+KY2/8
         +9K+YzZd6D5v2XVpCAGr1Oh7mKXTruS1q1R4gAnv+dmAzqZYr2EAuL2Scezw8HuJkByw
         4HsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794342200; x=1794947000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aNTBUVcEjSCanLMfEBKZfMTj70g+Fn7VorpJWkJr3sM=;
        b=YQC+BDPr9hF+Gkot8vw5I+x82qy3SR80yUrtwz/qO5sT/Kvo8h7kxJ/7uwjwfvimVC
         sgkRCpUjFX3E+I1sl+y18Q+wjGN2AW+iW8L6WGUD1hhGfpupFbECYDychAKOorR3D3m6
         UHws8AX1hx6Y8B1g8AK0Wu8InQuFmZfubsh6nDvP/E0JdXZz+T7nvNt8uMVhZDPinOyq
         KeKEPEEyig1hj6JK9ScdLDJTSDs5XAUtfu8zE+oZ9gK015nEuelmVpZf9V/1uHsqIP0A
         HtZQzJjWOUO7GEe6G1HGh9aIUaifUqcxD6/zZ0YGya2jB2Wu1UwMuZtQ1mqtL9Np04QB
         hm/A==
X-Forwarded-Encrypted: i=1; AL+hErH+5YWaKXYF2IqFm0DA9WVwPEQHRWo7afx0QRWOqKkW0bJ+ImhSrSHoPAwk9hhCqGfqFD8xNBgDcg==@kvack.org
X-Gm-Message-State: APuU4Z+GdZ0Pdzian+qAHfpic+1fgmSVCnv42hb4h5ctunnquRM+Q9wZ
	JVjYm+Vn7D8+i4fG63zGScUpYu/lsNkLiwqhuHGu19qHJ2q/um4ScJH8SPXzARq20jkY
X-Gm-Gg: AYBFou21u/BJehreGivz8Phvmo7JpS1q7sJv69RlzJl5UwsIg42nCOG+HlpXdFsnmW0
	lV0zz9+YALPgZCPGf9GDbuoxHyxwil3jOeRkFMpUj65+Gfptvq59s3/CUaHAtSkiFnkeKgn/E6z
	eavU+Jsc2tAwFxiLnVtTQG/HDDqwsp2yVNW+HFWovcSybly5pngMo9GyiXEAsUX8HLDI/wWPteK
	ALc/4UWH85vPUIaGLEoj2t6ZveEz7Jtnx5JgDKlUhDOh7qGkc+bC9V3S2egcyPL4RTX4+Z7k1OE
	XEmUAJ1e01FliH7tskqIsdO1JbQLzX9nVL/vUZmHnPIqcQ9JdT96QWjQTGjUzwOBP6XzIDwcjYN
	ZyY3jhHc7NnLc9+2+lr9XPhe7FVHEgMD3MwzLq084CDtMfULWRGE0LCakYKlqUYINv3sJb/7hAK
	wayciKcDZAmjtSEeY8WqsnehkAoTmFc4G8DiNzfUlP+JsGaxPGBQCz02FQGA1RUgBKXhf+M1FMc
	MrsdiOTrfaav3p0UgB4Cb5OOhP83J+FF581PDMVroc4VdpEPQxx6M+uso4unuVCTJE+TXfpmZ15
	3OX0Rkb2v17ByUoO5QAVD9sc2yYUWJ/qfXdAEU4OJmAPwfMPBFnAbM9CxGs5haIXzXoF75V1yFR
	ALeVvdJT07ilt/Xh/EeqUZqRXXCHk/1Md+EsLvI1K7q27D+3thoLDlw==
X-Received: by 2002:a05:693c:8955:20b0:36f:26a7:968e with SMTP id 5a478bee46e88-37686a4510dmr514261eec.40.1794342199582;
        Tue, 10 Nov 2026 12:23:19 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:147:2742:6545:702a:2431:7dca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfe29fsm10076615eec.21.2026.11.10.12.23.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 12:23:19 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>,
	Kees Cook <kees@kernel.org>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mel Gorman <mgorman@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>
Subject: [RFC PATCH v3 0/6] security: introduce Kernel Assurance Plane
Date: Wed, 11 Nov 2026 01:52:40 +0530
Message-ID: <20261110202246.274-1-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: h6qma1xpzh6ktjyjcy17j7zc67umstye
X-Rspamd-Queue-Id: 634084000B
X-Rspam-User: 
X-HE-Tag: 1794342201-806111
X-HE-Meta: U2FsdGVkX18t4/PGtvEki2M9XlKMM1eeHrh1SxStomPVEXi3gzawYsEziy/ZCv0bDwSmj7ZbbsRL9PqXG+REeHgv/DRNTrTtmB9xjVhFQzt2uY0a2H+Xq6nRbt43z6FG5SAvftycJVip7oZd7kTc+6YHgoGm7obnoBMs1y07peRddjuL2Pyo2PfOe867JiUfaMwrsI8BiDSZrBwf9hXYnXgtBU//2jQ9rf8zqZzKlnLSBvGdlN0Q9QLQNciDrpoTXnLA1viEAH7E2jS7bE7v89w2nCVzo24H7TsTdMd5p/It+HxNw232vsS3b2NI1vO4hIcQbE4AsOegUb1O6THszyk4ufNq5piACHB8dgyzkV1T6N2NjLtu+ixcf6WS7r2CQ2o9UxVitCxcsTJX8rfauuM4u/ixLEKfa727W5pSoGODnuYU3yXpL+Ebx6rVUuS6kL1/ymgnum79kLNw5cHppb27aEYkpc0o3I8UR7+4LEG0W4qpop76STwqMG0hPMCeOWVSM6+VYib4Hqu3P1HLh+R8qukGD+ve67zcYuSDlvr5DuKjkW7tZQLmV3+j5PAwtYgEkVu4lQQmV56ysWhre1TqHnoQrro0uSRx5CoV9aQ79Ev8TSU6du1wJYo3DKCDI5sbznpHL7lpYnI2zqpSeRbkndGIqFHnUTrbpssiMB5w/PGZGVKDDQ4AFgXiMqseKEmTIuQYrEExbq9h2FvDppevPEZQckCLXmbOeQuqVX1VlihQaYvBQEtwQsIYVxe+tCWEzmfhUhssMoSrMfNvV/DkhXo/b66nchXUD/Ic0ctZP1pqSeu/H4+8MuZzkwsBcPEqkwfhDVpQ0T5ZybKDte6y/nEdXGcy4sCuOi+JlcMrPkHnbu45ey3nnCMTSr49oeXDG8d1wvV3ooDPoDNFiK01s95JbbmZmjzKuSKdd1mCA3RClZWfUfwRg1TRJR6fmNwR5U+MMDvSx+W/ii7
 1LArvK2Q
 fDB8+GJ2QDFeRMEqx7qkCmEVMnXmSX35PmJGYzY9JUA0/bEwZQDqCrhbhpha7MAtYcs581djBgmw3ElpSjdP9PrP/vXqbRc+6700y23h78qh5f33afuG5DX28KyzK9wJupxSEu2OMX0pdzf33bfahKdsdIhtAQD2S4KCp0jbWPZmNxI14jQvJgqcKWkkghWXwnYP2YPZbwiWpgPN5/hyLeSJBVtkTohg9z/mSNP/kaQI/PHnNGsxPKr0xyJR1mQSatNt7eia89VLz2+RG/mJwfyVrzOy+hGpfdEflFBmFs+TrZnzgJZXownhb6+alGc5f9VQBzmR0qy071Jv70bLvAQxQhQNHoxvpgnme4JN8NtTTmjKmDGw02bXEzDirENWoaF74byxnOdfXBGx4oQEG5ORm5SroXwtontRpeE910KcxIlorIYPbm+/SsjBArQAVF7J05TpfM2uOT+fRB0G4yz+/WuBd0XxVwTTR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Kernel Assurance Plane (KAP) adds an objective-scoped authority context as a
kernel object. An Intent Lineage Group (igroup) is that object: an externally
managed authority whose lifetime is tied to an objective rather than to a
process, a thread group or a sandbox, that a trusted controller can update or
revoke in place while unmodified worker tasks keep running.

v1 [1] was the design document. v2 added the implementation and moved the
control plane under securityfs. This version answers the v2 review.

The review asked, in several forms, why this needs a new LSM rather than
Landlock or a BPF LSM. The short answer, now the spine of the design document,
is that path and syscall mediation is not the distinction: Landlock and seccomp
already do that, often better. What they do not provide is an authority context
that an outside controller can narrow or revoke, per objective, for a task that
is already running, while a second objective beside it is untouched. The
document opens with that and gives a two-objective example.

Changes since v2:

* Design document (1/6) reworked to answer the review:
  - leads with the authority-lifecycle distinction and the two-objective
    example, and states plainly that the mediation overlaps Landlock;
  - raises the central question (question 1): should KAP be a minimal
    authority-lifecycle facility that composes with Landlock and existing hooks
    for enforcement, rather than a self-contained LSM with its own mediation;
  - drops the incorrect "cgroup membership cannot follow setns" claim and
    reframes the cgroup and BPF-LSM rationales around which lifecycle semantics
    should be a shared contract, not which mechanism enforces;
  - states the JSON subset is a prototype wire form, not the model;
  - narrows the net (connect only), ipc (coarse Unix, no SysV confinement),
    descriptor (file_receive only), procfs and io_uring claims to what is
    implemented;
  - adds the deployment and privilege model and the lineage-root trust
    boundary (opaque, not kernel-verified in this version);
  - reframes question 5 to prefer existing namespace-transition hooks where
    the target tree has them.
* Code (4/6): the only code change is removing an unused securityfs dentry that
  the kernel test robot flagged (-Wunused-but-set-global). The code is otherwise
  identical to v2.

The prototype runs as the guest kernel of Kata microVMs (Linux 6.18) and of
Docker Sandboxes (Linux 7.0). In a Kata guest under nested virtualization,
running the same binary unbound and then bound, enforcement adds 154 ns to a
read and 787 ns to an open, while the unhooked getpid control does not move. On
Docker Sandboxes, allow, deny and revoke were exercised on a real agent.

Known gaps, where feedback is welcome:

* Whether KAP should keep its own mediation or compose with Landlock and
  existing hooks is open and is question 1; the current series is the
  self-contained form.
* The authority wire form is a strict subset of JSON and is experimental.
* Decisions are serialized by one spinlock, and those that resolve a path
  allocate a PATH_MAX buffer before taking it. Both are prototype choices.
* igroups cannot be removed yet, and kap.procs keeps the pids written to it
  after those tasks exit. A task's binding lives in its task blob and is
  released with it.
* A thread created while its process is being bound can miss the binding.
  cgroups closes the same race with cgroup_threadgroup_rwsem; KAP does not yet.
* Control writes need CAP_SYS_ADMIN. CAP_MAC_ADMIN may be the better fit.
* unshare and setns call KAP directly because they have no LSM hook in this
  base (question 5 in the document).
* There are no selftests in this series yet. It was built with and without KAP
  and with networking, namespaces and io_uring disabled, and boot tested in
  QEMU with lock debugging: the control plane, file and exec decisions, epoch
  revocation of a running task and kap.default.
* The LSM ID is provisional and is for the LSM maintainers to confirm.

[1] https://lore.kernel.org/linux-security-module/20261021165748.19304-1-ketan@armoriq.io/

Base commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907 (Linux 7.3-rc7)

