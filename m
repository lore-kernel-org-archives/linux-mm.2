Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF096607E703
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rn4NJ9AI
Received: by kanga.kvack.org (Postfix)
	id 5AAFC6B05C7; Wed, 18 Nov 2026 14:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C296B05C8; Wed, 18 Nov 2026 14:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC7E6B05C9; Wed, 18 Nov 2026 14:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 145406B05C7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A185CA84D9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:34 +0000 (UTC)
X-FDA: 85449246708.16.3F98D8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1102940006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rn4NJ9AI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emvb8auKFt8ReD/7cfPOhlXVG+92MMR8s3O3PK6mxX4=;
	b=yiwqH15aF+6cYK4DyIly7SBhK0b8e99F77pors3yN0DgLMc4M2sgOiGp7erRsxAs9zPzXG
	73ar3Z+GvK6EOaNxWnkCdmBF0rpWIHdcWc1nrpiqjvqv+RflVwA2llTzrFZYc/HvDD9tT2
	Td0hSvICALCW6h1eu0H19zlK34y87QI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rn4NJ9AI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030593;
	b=vUj+74dxt+Icuihid8r2HkVm4T5z2oLmEbnML5+6ooIrD8MEGwY6twGAti8+RFywAKAGk3
	U3Y7LujRkHlJxXRm3RxwhTEwJmjulcDylaDsi0ea5vH74edTMfQH0Po5Asi3/gc49orf9m
	pJVv4YlzjGtZH/qFXzGOhGY+AklwMC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 860A963982;
	Wed, 18 Nov 2026 19:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7FD931F000C5;
	Wed, 18 Nov 2026 19:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030592;
	bh=emvb8auKFt8ReD/7cfPOhlXVG+92MMR8s3O3PK6mxX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rn4NJ9AI6YGF8PVWQXBRv1FiBYfqpDSxzELVRGBk54g25p1QGmG0kbWwjkVW4w2D8
	 lNzUuvLqiYY70zuklWvAlaaxGRUO2cvanIC+l4rtHSr6wjBsvkeFQH2zeKwkHM/2HR
	 1E03wIpBV8/JESxYLAq9/dbhxN92LOjVYCvST4kDso8ClYV5rrMrTwrfyh/ubHS4pd
	 29LnkBtPFVtNdP00rXXeNWtMptKSanngC+X7c0JwyXA6ykEmc4izrUQaAGbXjt3Ifd
	 lmma7UFXxVsvv8DqOK1WIAvb8JCmLv/h9lHWZ8WxweV0E5ESZyMRyrlmlwsmYGXN4M
	 kayuyeKN8AOxA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 11/13] docs: Document root namespace uAPI
Date: Wed, 18 Nov 2026 21:35:37 +0200
Message-ID: <20261118193539.240065-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1102940006
X-Stat-Signature: w4psnrbkaucroikysf84g39d4mnr7sj7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795030592-881818
X-HE-Meta: U2FsdGVkX19zGJT1ajV8IAuZom2/lxZIHtAqrd1l6Gplp6zJih1dqxBq+vhtrmiwdgQCcDcvyL9EZV6bhchqM/ZUeXAdeAnT3Ta4FO/Ft1APRZf4+sUt+Asr8SJhyUrF7fbVNya0950m7YMWTYuvYJyE94Iep3R2VSdptsz4EvTpnuYx8hfR0Oktuxl3ct3QfUWq24sdElQ2CfBR63wjULGuDcN3n9VLCHvLjmrRpXKSOIneO7Ps3XwqNasW6xDEFwkpksut3EWbXGWz6/VckPNv7c1NNsCiY/ZZy6NqO96wDPmV5r9dr4KCF0sWMaP1PEbYxkedk1tmeMh+idw3VU6ihFb43L3VZUS1XuuWUDqGvgprTx5r/ldX01aKY5cvBj4YXFCDJ2LxJfsOe85ZELWCMEIrZdUwWl6PiV0F/q3tTFmbWCg90i0NhUGdi1PkkdU3xyPU1KjqFUtNFPXtY8fwZ7+zQ4KL118rUIBeTDCuclQfd0YMoAJdNo9ZlEzcPAiyvd5ZsPimWLgceCCFyWwtt0C+KPI1BLyumMshQBwn/4oNygFLHmq0gDm/utwOo/6UO3kq0NHVvDuLoGi/qfZbNoN4Sydy09N4eXJaMYl515q1vMoyO2YdFa2PO1ZaukD47ki8qM17s76Z3foLYYAiYAcHz/cUFV6woT+6nrYo8fYAhZ7y4UBqBbNYddXcvLHbyA2fetgvqH3Oy5mZCFjKPDwxvupgbZVC+TpGEh6lf6rZbqD43ZgSA7IkYx7ZKgvoC2BvsNY4COENmYmQ/Ske6ayKdNEnXn7dDwoYBuBfO1fT7GfLsHoLzX+som0MHwy+/iwvRwtKKZFh6uHNQqrNnBE/Q2ppR+aG3sJYWlt03x+i+PCKIov03hAXcec+ixnUAo/UsDSooZl1orEDsB2B5gf3T3fS21Gx+k34KLMehiVoMd1RR+UmAOCwo8llr1JQw9yTVnHbE5rX9Sv
 fprWDiTc
 NI7DIQ+YiEHlLSzuL4QXwXnYPOz/ISZOvJy0nRJsywzMo5Gz9hvCJgyqukCpPmRsAjDE5JnFWFKeewSnfNBFHjqeoxit5Z+JdFEb2Lh8YeE1blKk6AEaoRPeSl/y4A6eGFd4ND4JExNalyO82kgSavuA75bmGwesvh/oThrZTxYCQb/ExCg+Eueqnl+USe0aIadGVY+QdbjUvzyAcAXJojxU4mLkDIFRZwdw/Lmu8z5LrtEcCxVNZKhkKPfqNsv2ZXXbRKxNMzJLETPH1704ZjzlyXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Userspace container managers need a clear specification of rootns state
transitions, namespace fd ioctls, mount-tree construction, credential
rules, and process creation semantics.

Add Documentation/userspace-api/rootns.rst to include the kernel-doc
sections and system call reference from kernel/rootns.c,
include/uapi/linux/rootns.h, fs/fsopen.c, and fs/namespace.c, and
register the rootns ioctl magic in ioctl-number.rst.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 Documentation/userspace-api/rootns.rst        | 47 +++++++++++++++++++
 3 files changed, 49 insertions(+)
 create mode 100644 Documentation/userspace-api/rootns.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..56d0ac4eb087 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -17,6 +17,7 @@ System calls
    :maxdepth: 1
 
    unshare
+   rootns
    futex2
    ebpf/index
    ioctl/index
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040999..d8dc926ea283 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -385,6 +385,7 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xB9  00-0F  uapi/linux/rootns.h                                       Root namespace uAPI
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
diff --git a/Documentation/userspace-api/rootns.rst b/Documentation/userspace-api/rootns.rst
new file mode 100644
index 000000000000..a7724539a9fe
--- /dev/null
+++ b/Documentation/userspace-api/rootns.rst
@@ -0,0 +1,47 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+Root namespace uAPI
+===================
+
+Overview
+========
+
+.. kernel-doc:: kernel/rootns.c
+   :doc: Overview
+
+Flags
+=====
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :identifiers: rootns_flags
+
+Ioctls
+======
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_GET_NSFD
+
+System calls
+============
+
+.. kernel-doc:: kernel/rootns.c
+   :identifiers: sys_rootns_create sys_rootns_wait sys_rootns_kill
+
+Process creation
+================
+
+.. kernel-doc:: kernel/rootns.c
+   :doc: CLONE_INTO_ROOTNS
+
+Filesystem configuration
+========================
+
+.. kernel-doc:: fs/fsopen.c
+   :doc: FSCONFIG_SET_ROOTNS
+
+Mount tree installation
+=======================
+
+.. kernel-doc:: fs/namespace.c
+   :doc: MOVE_MOUNT_T_MNTNS
-- 
2.47.3


