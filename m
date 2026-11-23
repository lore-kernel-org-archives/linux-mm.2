Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21643606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ULeZ994e
Received: by kanga.kvack.org (Postfix)
	id 472646B05B6; Mon, 23 Nov 2026 06:44:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423946B05B7; Mon, 23 Nov 2026 06:44:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312166B05B8; Mon, 23 Nov 2026 06:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3706B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:44:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F25540892
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:02 +0000 (UTC)
X-FDA: 85466199924.03.BB09A75
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id BBC4A40004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=ULeZ994e;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.173 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434241;
	b=ISbtwkaVpu9chUYx7ST5Dcs5JXD8b6sDcwY56lWZWOZg4bQoGw2E3SiCPyCGIPEfGmAzpD
	tilKECJrncPRt9YaZYojjLzdDlH2acQVbq9GKdqTErN5u0CafcMjB6JlarUSH35zxQonDz
	3eCF9/AUL9AJpt9qKtY7sUddOXouu+Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CUCPhF26O34G5hnc4b0my/OnjDHNH9LBcPnQRfSJOAE=;
	b=Wwm3JcRXM1x33h0uyujGwWBefsQ+ykUIqYdjE1Mwbb33VtdDAIoZ5RVDSO1tE9rSIS0CH0
	caSzlmUafpaQKr89BASH5kTFOq9SugYdFrVs2bKLTCoWM0GHCqc5urpA6MIKRNg6DW2XUZ
	xZ6IDUMy2P5ZtJ8vk9P7/1//ZcpumXE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=ULeZ994e;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.173 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-385c497bf94so1821894eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1795434239; x=1796039039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CUCPhF26O34G5hnc4b0my/OnjDHNH9LBcPnQRfSJOAE=;
        b=ULeZ994eNdHn1+kSeB6aJv8CdtI86mFpPHWFtPTFUWT8iKgiT6dduXzMGzX4gRBQjj
         YRv1/W1vy3VwVCgd2emiyqSFpb2hVQR52QD49rDLZh5JPoP7x9O7XDtiERVAqdLNMErR
         HNOqU7nUh+UHb03YKfut/g8lvNxGmDUzRmIE9cRHpXpLWUHbbQK6xVyKz4rMPN6S69IU
         qhdW+p5H+LLTh7dvs637eDmPJn1aTSeN48n+YB8f0SEgnHaREAf0083bsRoEd3iU4G98
         eenbegEixVEWKZDgyckUWldeFvdXWVbJ5V/hKRqIM3sp0CvNkxOXQ1uwFmhV9To3BS+/
         MF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434239; x=1796039039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CUCPhF26O34G5hnc4b0my/OnjDHNH9LBcPnQRfSJOAE=;
        b=eoIGZyEvi7ZlCZBz0X3vXdLKfKbHVH7NEu2QisrOoGxdO50YJgaHA8Y7q93/zpeIG7
         gKCyxXyD9nnUIoyUO/Xordu/zf5F9e+ejgyPqcnADvUA2Kss8k9Te4Oe4UckcrMjLQpn
         eF9PqPoYnZD1ELUlVJkT/vBLFk1AA4JZO0OIPI3IoOcUK62bJXNcLV/Kx+dpUJY3xK1z
         ZvLFyJVjBcCPrcY5RToQ31OtJR7fJGGSggFnPMy5TLHr//a3AwTXtaPwxxaH5a5hn+7G
         SLjZpSlh6602rIO7Hih4aMSyK+AVosde7CsSDGMFtiML6BcAgsGfiG7KZjPlgKr8nBdQ
         gbMQ==
X-Forwarded-Encrypted: i=1; AL+hErF8M53vO/xU3MMFrS0Wb7tMPN7R5iJ5zwA16hUJ1wPnXDk/dMoKjHPVr1jWYRWIXUgum5Y4tkPk2A==@kvack.org
X-Gm-Message-State: APuU4Z/a3R4/ETnYn238QnG2tPSMVBWrWAvwG/kr44C9569hdxxNVlZl
	QN0D+E5LLE2QgEaDIhUqg2Y6yZi7xmPMhslusgUsPWsf33a6YS3WYYrPwPRkOT+sDpVk
X-Gm-Gg: AZFdTZdYLANdaNxEwFmETEub091VBmXWNLZahyu9VgtRor+T9I0mh1N0wGa2GblIaKB
	+qei+k2sB+oNb9qtaVYCDqAtjdDOzY03ihOpJw5RQTDgz1v0SmTZd32mGtVCzwga32iWoj2ULay
	zynTqqIdgywh0i5BdS0t1Dz2u1J0W4w0bOMQgU4Q8V5uo9/pHF0I1fAhL9tGKrgfiiVYPradkvD
	HiiKtIva8lgDCFouKeAijetxJlrY4UlrH6r8HzqOLLu1VGD1FTNoeTddAFhHL0tR6WU5e6jwD5w
	lF1PEimuolDtsw4SmA54xpJNC32SUoS9ayfEgA1uCXZLI5mk4LXOCJpM4l1hMnNW9vNEA0zoFXX
	IM+9WoF5OWW0MODBg2qykXK6cvgwbPwI4U9SGv4NF1/QkTcrRB7XvwvU1sS7QzrL9je3WDfhcPV
	FFqExetkgOn73dNmB0wRDXrDoFhm3owHhwNZ6hB4Wf470iQVBDgowtmyi5sQZs0GPDvn+EsulgH
	6zKQI7Ih+1Hjn7qox/jZ8rbtOnbgUQMLWIwEoNfTlaLevCCuRrTggjG+N5VcoWzTKcniEe1zEnO
	Kq4dfZv+ArD0Sxy3ixzgy03eeeCWFvDnoqxWTyOIhHZOCB2Z1ggdrVRXev0ULaugDLotDxoR/MY
	hkeChgUvxmLrruqCKYG3sOFw6Rm9fFG6e5IcaACCTjWXcUeHQjr8MAA==
X-Received: by 2002:a05:7300:26a2:b0:386:b0ea:3263 with SMTP id 5a478bee46e88-386b0ea340cmr2766188eec.40.1795434239138;
        Mon, 23 Nov 2026 03:43:59 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:14e:94e0:654e:d7ff:13d2:447d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm41943583eec.10.2026.11.23.03.43.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:43:58 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Cc: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH v4 0/6] security: introduce Kernel Assurance Plane
Date: Mon, 23 Nov 2026 17:13:02 +0530
Message-ID: <20261123114308.8103-1-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BBC4A40004
X-Rspam-User:
X-Stat-Signature: pwehuxd1gdw4zxwitfu31ogo41fhi3k6
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795434240-987328
X-HE-Meta: U2FsdGVkX1+q3dFF4/mOEfvA2S+xpwqPnbiZF4g1xa8wXvIOW46LGhLCZBfQHCzWZ7XAxKeEGHnbQPmGuVl/Lp/0EwQ3oRvDYr9OoTYysTfuGEiyjSp6vxcxmR6CVBMG32gVXZfAuR+oFNTrrFOWcLR1tNuZcjxDU/iTZrnuYMLf9gcHEuUaTeXLxp8sAJDcODRv1aibREjSmmBP6EnQXcOH5Dv9ZSiyieU3lT+DEpMz3/ND4hgGoVXffEizUtOAhIxHPqQEB1hvEc8ZqhaXN+dLhnlUvSLx4fob5x2MKQNPBvGkYjyFBHpqwt9YtC1JKb3S97LH9qGmy0Pzmi1RnTarMDGEzkMpYXY8Z4Z9ZkpkPkHmL+dcscmtlSmPHW5s4wHZMjlMwbGbu4AcZG5mYfrh4z8lsB7JfQPRz2E+P74BffRLvUAVB6ZCOE5onC95bEtl57Ii5An3Kt9SB03H/XKtO7caPBvZDuG/XBACR79nSwHSmmtEs6VAyu+w88qTvlZncSqOXobSpmWOqVeGt2swIMpKzDLaNGFLUFK39ZscPqIdaTtDa0GxHea27Lu/+nT09BVamZa/HAD7EVqDqxwW2nCnIr+SJx7KXAVk51T7sbapISVUnyn9UNx5wHJfLtbSjYQJjvn3FSfU48cI684XxhnAv4DsgGT3b2H7JHNSlEuVXzKAVqiU2KATfOcedP+UoYP/WufK5n25FTMCd3te00JRk7ihzO63iF38GgH14K+W3XartOzQpIvyP9Ore/Ul1xkOTkVDk1Nsykw69Ls1kQmM1Lm5tz/fUByS6id/3pkteUzhbgywmq05zRL17oqynqoY9UDkbID8OBqc+yMgXW+QnwraQmF5yMGND+0/sktMDilK2z7KpBYu4IbUqqATZPtKVpeVPuwI0LX+qUqlyye0qMh/GH80zHKcOb9bmTMLAk9nuXmJqJLrsQq/QKV1NKFdrc+4IUH+gdM
 0CVLNzDA
 9A6kTz9Q/AVEHTeA9oyWHtXX5p1nNSC5ys64wmmVDw6RlbQm1UYmcTuGH9nQzO6rn7FFv9vxq0OCXFnOm3JPNCMVhDgGi3WuF9DkAK/KaVZMxNynFLGGFTH86xcMjsVsN8y9gL3pVzjrk4Yrpl2nZE9Ojhh4mYAOiTYGGxzB8s6UDEhceQQLgtN/Ko4QidaqO8Z9Tv+r1UkvxX4BppVQ8TgFoB8DKOlV2uoF7NotKKXjlzkHrW0OPIQQFOiaeJ6+bDJ/7eRbjFAufS1DS9R1Tz57fkHKTZZyQS9joRPECp0KNiXwySf3BohXMdoGBU8T1IrLEh+mAd3a+J6xYUwMXPS7qnWsKxtwB3zAa/OIydOUWl17JKM53Frzzcs1lzN68/yRTOP8Y2fZrYG7TA2phb29jUxTbMMzLpVqyD8a8J54d6RmcRVRicdQ1D8FWFJKtoVdPMt5MmU5nGz4KUcSDjRq4eCf6Ssmd9aHxj3BHNsvQhxQuSjKESJB2x8etHi8KQnHhD5x9TLB986RTxriormi0SqnWNZxr8Gun6+Ryk17pAzhPNuUKEp7CzbgS5zFNwFC5/L9xetW3MTnEmxvhR/kgGBz5JTUM02nge1LcIXb5PiQ=
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
control plane under securityfs. v3 [2] reworked the design document to answer
the v2 review. This version folds in the v3 review: automated review findings
and a request to put a diffstat on the cover letter. The design and the model
are unchanged from v3.

Changes since v3:

* Fixes from automated review (3/6, the LSM). Each was checked against the
  source; findings that did not reproduce were left alone.
  - Fix a use-after-free in the link check: the source parent dentry was read
    and then used across a sleeping allocation and d_path, where a concurrent
    rename could free it. Pin it with dget_parent and release it after.
  - Fix an uninitialised-stack infoleak on a short connect(): the target
    render read the address and port before addrlen was known to cover them.
    Require a family-sized addrlen and otherwise leave the address for the
    protocol layer to reject.
  - Close a fail-open path: when a mapping's backing path cannot be resolved,
    mmap and mprotect now run the execmem predicate with an unresolved target,
    so a revoked or expired igroup still denies rather than allowing the map.
  - Normalise /proc/self to the thread-group leader in the current PID
    namespace (task_tgid_vnr) rather than this thread's global PID.
  - Do not let an exact-path deny be slipped by unlinking the file first:
    d_path renders an unlinked file as "<path> (deleted)", so strip that
    suffix before matching.
  - Match a user-namespace create as "user:create" so a "user:*" allow or
    deny applies, rather than a bare "user" that only matched a wildcard.
  - Guard the transition-sequence parser against u64 overflow.
  - Reject a lineage root that carries control characters or the JSON string
    metacharacters, since it is written verbatim into the kap.events JSON.
* Control plane (4/6, securityfs).
  - kapfs now sets its superblock operations (simple_statfs), block size and
    time granularity.
  - Validate the lineage-root write the same way as above.
* Design document (1/6).
  - Clarify the epoch semantics, which were contradictory: a running task is
    narrowed by installing a new authority at the same epoch, which re-points
    the bound task without interrupting it; raising the epoch is what revokes
    a task, failing its checks closed until it is bound again.
* Cover letter: add the diffstat (thanks, Lorenzo).

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
  QEMU with lock debugging (PROVE_LOCKING and DEBUG_ATOMIC_SLEEP): the control
  plane, file and exec decisions, epoch revocation of a running task and
  kap.default.
* The LSM ID is provisional and is for the LSM maintainers to confirm.

[1] https://lore.kernel.org/linux-security-module/20261021165748.19304-1-ketan@armoriq.io/
[2] https://lore.kernel.org/linux-security-module/20261110202246.274-1-harisudhan@armoriq.io/


HARIHARA SUDHAN. R (6):
  docs: security: Describe the Kernel Assurance Plane design
  security: kap: add the LSM ID and internal headers
  security: add the Kernel Assurance Plane LSM
  security: kap: add the securityfs control plane
  kernel: add KAP checks for unshare and setns
  MAINTAINERS: add an entry for the Kernel Assurance Plane

 Documentation/ABI/testing/securityfs-kap | 111 +++
 Documentation/security/index.rst         |   1 +
 Documentation/security/kap.rst           | 341 ++++++++
 MAINTAINERS                              |  10 +
 include/linux/kap.h                      |  16 +
 include/linux/lsm_count.h                |   9 +-
 include/uapi/linux/lsm.h                 |   1 +
 kernel/fork.c                            |   4 +
 kernel/nsproxy.c                         |   5 +
 security/Kconfig                         |   1 +
 security/Makefile                        |   1 +
 security/kap/Kconfig                     |  14 +
 security/kap/Makefile                    |   2 +
 security/kap/igroup.c                    | 976 +++++++++++++++++++++++
 security/kap/kap.h                       | 160 ++++
 security/kap/kap_lsm.c                   | 903 +++++++++++++++++++++
 security/kap/kapfs.c                     | 530 ++++++++++++
 17 files changed, 3084 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/securityfs-kap
 create mode 100644 Documentation/security/kap.rst
 create mode 100644 include/linux/kap.h
 create mode 100644 security/kap/Kconfig
 create mode 100644 security/kap/Makefile
 create mode 100644 security/kap/igroup.c
 create mode 100644 security/kap/kap.h
 create mode 100644 security/kap/kap_lsm.c
 create mode 100644 security/kap/kapfs.c


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0


