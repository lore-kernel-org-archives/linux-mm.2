Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961F260A2625
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=obv9eQjp
Received: by kanga.kvack.org (Postfix)
	id 5962C6B05CC; Tue, 17 Nov 2026 18:14:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5681C6B05CD; Tue, 17 Nov 2026 18:14:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E496B05CE; Tue, 17 Nov 2026 18:14:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2598F6B05CC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C38291C3CDF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:55 +0000 (UTC)
X-FDA: 85446168150.29.6446FFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2BA7F40005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=obv9eQjp;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957294;
	b=wkZZDLN6xIMnN8NByADKhKAZoBX2DoIfSnmAQuxERX8Vf/1Zbl6v21FF5DsgqozoWK1Wwr
	7Ub1U1HYJIooA0R4b59dydkJ8xQ7suFEoea0MrAAUOiQnC1sXZa8mG52rM/R767Le//4tv
	9avWEAjPxFDpI+2gvW5KS5AShmfHQrA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiMfC8WxBlUbYWytaJ1DOt79UawEGEAXEtAPiyGHVrA=;
	b=57kWmLx/iICqlK8M/7kXfEBz/y6FaZlwT3WxLRpZTzlydn3YmlT3mER6e/KatUR/CTjlfC
	Xk31gHBYM8FoRSFdmoxpmfvOggNg5jArY15RtDwC+C2voioE8jaJt/Hjdl/W+YhFXaDjjV
	mYEk4+Ahohngwz1mYZF0NV+fHWXrGmY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=obv9eQjp;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 7B6E7458CF;
	Tue, 17 Nov 2026 23:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F7131F000CA;
	Tue, 17 Nov 2026 23:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957293;
	bh=CiMfC8WxBlUbYWytaJ1DOt79UawEGEAXEtAPiyGHVrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obv9eQjpBu2XlVQo5Y/t+VKK7Ro9uJlqNt3aW/t9KyS7o2vo5BqDhS2zq1sbQpqMW
	 r5ofIesgTcSu2dr2azXda2SqWaX0YVuyeKlxlz1g0djzEsNLG8KaKnv5E2nktmxTxK
	 kOjurxnHrQroLbRJ//FllbJ/1N598SSRV7KV1IUx9P+MC1HoUUJvyT9S+Wn/7Tv6CX
	 gfNzgQE1wyeI9a0xSPW8/rjsaVtAMpby4zq349GOd09NjPzz8h7LUM1O4K9TOCWk0n
	 9UxevL+PACtYmaKICzIvr2Ftw8XLfVLUEeQLzxUN3bqb7m5WUDA+IYs1c6z8axEVM0
	 jFTa41POnFgZw==
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
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 11/13] docs: Document root namespace uAPI
Date: Wed, 18 Nov 2026 01:13:50 +0200
Message-ID: <20261117231352.3816603-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2BA7F40005
X-Rspam-User:
X-Stat-Signature: kg7qqdweemuuhqzx5wkgd7yptgykck6r
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794957293-172979
X-HE-Meta: U2FsdGVkX19HQWCnKGZbYc/OL3RfFk6z0F1VwIxpaRYOaHvEjk8anBSb5HRizXgHClmMSObahnl4MPVctiOqTIsTt2TcnqQxcD6pph/H1Vn1BDSPa2mbqDHCOyv/OdlWl/iTtJ/V4fpPRUF1Asgm1uOP+yTpEB4MSJGS+z+TbKV5x461HrxtweP2e0D/d/RtMOXsa9drpomP92TnHE92Kd2JRdoqra6pbkyH9316SsyzbwVKqzTpkYGzcES73Oo3v78nkR4O5FZTejGAym2hpTFyQAs5gMNxHY5HDuad8dgfWpmhk45cNvBtcg4KoaWO/Epm7fyl2evu5taVzr0NquQFEOk/iIbrqT8BB94MetcBm703URn1O/ZN1K4RwKo2XLemfoIJWJKc9bnLEBdbsOLyO9z4Q33QqE5kz6dokJJ0LLPGy4KkKRyawvMLo3e+mNtJfFmyowg6bfYQQXMZ8gfEd34XASbCgXGMUQnGu/aW4JKI5Ex4SSqkeG/qvCLmFmiG09ecG2+9rguP3v4FJFOZXwa1A0RdsCkK6AfFX4FUT10phsqxl2lTNvvEFEJbFKuiYMfdxguetBHtMM7ta/wNFDGIsfv1/b/kc7eSX+q+SfwIYsN65Pf7wO7qkUHLy2U8KcCYxIPblhBRVjNoBhal6efO2puFdApaIR8Vj3zZOOROuER2YMBs+an/+G4AEcQI+OZffQRsihIxN8zgagxdr5Z2g1JZzVNiDu1YtQymIkHi/QyFO/A1B40lCWPks2oxJKfpYdHS+V0vgbSrxZ7ocUgKPe6G+CqHjU7Wt+2vFnWgMzLlWfX7tkaw/HE01p8UB1ODVbst5KZisj++gKoawxq0oam/mTsIBcAw+Mf//Jp006nHbkW4HtA/KQ2vqLh1buAxFL/K3ZsNX54ylvk4lbMTUilmFl4WEx1XANk8tDG/FfPYF5CSzJ//BG8FnVadermUv6NiINshIbi
 kmhwM0Oc
 AVvyvvQMDpkmZlAwPMa2aMPqdS53oF7lpn/Am3XOnCvlOdHs/lAZbY7qwCfTTQSC0X5KIhjpXN5i60hVNGmtuDOfPVc8Lbe36DN8cXw5V+qFaznc/BSSX+KJvfhm0xu5BeZ3QaV2rmALH3Ezk3i78dpM5aBQNZvwAoWXeAmJCj0iwrSTlzaBygNDb9K3huOI2fHnr0sqZzJx6lJog92C750BlgT5Nmv9uDHn5cxkWsrTy1FSz69YxlxnlSKNzU1Kv9oxv0t7PO/KJrYqtPNBw3GQLra2g1uVkQ/raVpxldnebTiqgOZBCpMSKDgdElZDhWiiVbRrM2YSMbAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Userspace container managers need a clear specification of rootns state
transitions, mount-tree construction, credential rules, and process
creation semantics.

Add Documentation/userspace-api/rootns.rst to include the kernel-doc
sections and system call reference from kernel/rootns.c,
include/uapi/linux/rootns.h, fs/fsopen.c, and fs/namespace.c.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst  |  1 +
 Documentation/userspace-api/rootns.rst | 40 ++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)
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
index 000000000000..46b40f5fb29b
--- /dev/null
+++ b/Documentation/userspace-api/rootns.rst
@@ -0,0 +1,40 @@
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
+   :doc: MOVE_MOUNT_T_ROOTNS_ROOT
-- 
2.47.3


