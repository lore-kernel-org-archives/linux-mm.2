Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4DD3606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eltAhv4l
Received: by kanga.kvack.org (Postfix)
	id EBF746B05C7; Tue, 17 Nov 2026 00:09:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F1E6B05C8; Tue, 17 Nov 2026 00:09:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DF16B05C9; Tue, 17 Nov 2026 00:09:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A479A6B05C7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 381AB1C2B63
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:34 +0000 (UTC)
X-FDA: 85443433068.28.AB889FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9BACB180007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eltAhv4l;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892172;
	b=Zbo3hzgAYeqKLexS9IWqzdpMFGGMnUi+jUY1XP3Ayckpxql+tzoM7SU+ntWJuiUiaxfj+d
	JIz4xin44tAcriD0pLIczRQcOKUGTOcvThDzxzTn2ubXP/IFF/kRmxKccQNsLwimKuhnW0
	f2UNAj0MeNA/eJcJVbzPunFlsWqrpAk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eltAhv4l;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6eIobs5D9XmHWrYFhdj7cW0/x/RnlZNFsdojclJewE=;
	b=RrHDNHGYOwBEG20rQscgb5T/K5hdm1UEJNEhf2Qe65xNTntlB/l9v7Pj9u4YQugnGpcc+c
	XhOb5mHpv05uMMxGODAGRfJtpIGi9yvmDtc3EnS3lTwhG35sP9eEuhs3TGzC6fYPqkQLaE
	QVABke61eDrfd8p9m7PJXE+9VdNBzqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 502EA626AF;
	Tue, 17 Nov 2026 05:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 71EFC1F000C5;
	Tue, 17 Nov 2026 05:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892172;
	bh=T6eIobs5D9XmHWrYFhdj7cW0/x/RnlZNFsdojclJewE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eltAhv4lO1ELFXOfm97cs3eTtAy14zpxN7frA5zDTXljNuj4XDHZRC+HKOwcHYfZq
	 aPgKgW3mho2K57IVLnM3hZ1ogp5RNP1UdB5PuBBeaMJ70ENJxggJNl8RmRt3Qu/ZKR
	 YxN7DbLGmOwScWCab2mUCGewxHbkAe6k2mKsdo3IblwchimDILQDwD6xmjKpdfv0hl
	 sG2rcAPDonSz/l+efsK+nd4bG4cs1PoUswRJS0A8Ro4I8M1SOnRJGJR8tDlUOqsXr5
	 ioNt1Z77jisG+XdgfWf+tCd0OXKdpVTIIybUTE/rk2XCuTylFWSfBteeEVyCuev3hI
	 QRLJOxxlJRksg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
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
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 11/13] docs: Document root namespace uAPI
Date: Tue, 17 Nov 2026 07:08:39 +0200
Message-ID: <20261117050841.3289652-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9BACB180007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fgjftgdwbeds6c8edp5yzito7hswh9k1
X-Rspam-User: 
X-HE-Tag: 1794892172-623022
X-HE-Meta: U2FsdGVkX1//4JGcKVj6Hza7miR70F3GilM3gpZQyfazRYbz8B3G3glzGb3MEGauiwIJI2mWi0pdAdEHmtR9KdIX4o7RNeNEC7bb/hlEZJJQnc4w7jsh9y3hUm0E77vHvd339ZnRkwpDVvA2viCEJfPUkMmVglLZyPmigU8rhmDDjCjJqqZjilcQlp0HgqbBcdQomTvP/RMGCxw6yICChQK7/w01iVkf8eugwN8Scp4sCL13pbHh7pJkc6joHKZm6j/cUovkNMl6Z5+Ia4oKaWdNoYGwOvc55r/7TkitiMvF6VW2S94E2yq3j2+yFu7OrRHIxRqsdPWfcMlOCBpSIsHziUMMlZyE0S6ASwYFMpLNwh2H7/hM2Nw3760summR8uZ2zTAzFYRW3nlTlYKJAkkoB6eAAVAyRtlITnhLCSes5u6iutXtoMd6u4oQrnM1mU0XlftDev0unu+GV560XVtKSbBz0ZxXK7cfKjGlK78jWtp3lBx0tWq4K5rdsuPEygyfz7hwRxGNTPftp8TFLjBljRUnvdmLEzWVKWkaKWpyl0TIUU6nyXUJEeamnnSn6rae3kiYYN935I/qvFNl93yV7nNSscCvZnd3TjLbA1xMnVL9j52ReC0UaBotlrgLqGOyPzLFQdcUZFtZ5JxzUs/fUIMpMxzxND4viV6eBWOGeawkm+gx0TXRxEt5+fl/d7b2LG6j8/HFpuFIkDuIzfUzFzNKiVBWHEstsL4BEw//emDflrXpOhwFqVo9coHZumSlOwTVJVi7MpA6xhG1iU66W+ZGnW/rQJgINXJPjqSnaAsheqh9RJ2/SHjC1At78j/VFvBDCpvDO0u5LO4E3c91pIGiKUF6ZJfqPpw5WfvrHp2AlqsKmL6Zzp2RBK3DzXHBZHnzQrZKDFDSXnC5P1+QgcAEfKT+d5b/s2HU66B6beU63IuPbc9ooob8IsnIognk6VzUpwet0SAzmtx
 q1nXNB0y
 SVCeEDWH1rAEdl4xstuAbXLiK2CyxTpOXugxsFW634huJeXergWkIN+JlbGv81gSHvnoeygHlFebggcaPQ/GaPsQaDgjxMelCQcgmwerf69AZPplPC0C2prlU9hD24fCGy6QWtvFGDKNXcWbWY3+NSwMNs/eRizDg5Zavb1caM/e8uq2jJaeotEGdS6d6Bo8/vB+FlXZDu7Qh2aBDEDbelNyI2d4Fpy5poR4U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Userspace container managers need a clear specification of rootns state
transitions, mount-tree construction, credential rules, and namespace
isolation guarantees.

Add Documentation/userspace-api/rootns.rst to include the kernel-doc
sections and system call reference from kernel/rootns.c,
include/uapi/linux/rootns.h, fs/fsopen.c, and fs/namespace.c.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst  |  1 +
 Documentation/userspace-api/rootns.rst | 35 ++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
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
diff --git a/Documentation/userspace-api/rootns.rst b/Documentation/userspace-api/rootns.rst
new file mode 100644
index 000000000000..66c6dbc0e937
--- /dev/null
+++ b/Documentation/userspace-api/rootns.rst
@@ -0,0 +1,35 @@
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
+
+System calls
+============
+
+.. kernel-doc:: kernel/rootns.c
+   :identifiers: sys_rootns_create sys_rootns_enter sys_rootns_wait
+                 sys_rootns_kill
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
+   :doc: MOVE_MOUNT_T_ROOTNS_ROOT
-- 
2.47.3


