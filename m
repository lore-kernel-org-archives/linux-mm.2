Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE0660A5BC6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrRw2VD2
Received: by kanga.kvack.org (Postfix)
	id 9D3ED6B05D6; Sun, 22 Nov 2026 14:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB826B05D7; Sun, 22 Nov 2026 14:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A906B05D8; Sun, 22 Nov 2026 14:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55F436B05D6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:37:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE4AF1A05F0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:41 +0000 (UTC)
X-FDA: 85463764722.26.55B7221
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 41C3B40002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrRw2VD2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376260;
	b=n+s9o9NtsTaDl41BYx/zC2bz4V5Jz3rlPIhl32ibNRcKsPMCbJo5mV+0vyY99wa4wUR2mm
	q6AiIaBwrKDRSpqZC70I1bNIWpp0otcv/8Xu0B35G9XjoJQHJCplU4bQQcirA4Ncsct1u/
	RhhM1VUmS+HDbORwHzjfsiqAbfSMnsI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKuvDTI6FKXAAEbVhrzFDmxnTT5Wc4CNv/2+sIEwHRc=;
	b=iWa9rYe+7ecuTUEssqw/63jVLvl0kLtkpVtuDIGpqfIZHwhpuSa0szysoE2HjfWk/QgEvc
	DMCF0LUCYoQBDyNaeZ2cyxD+x5vOlDahOvGLWyi+PQjJ1zwjQPt6G+PM4LFz6DECjfJkUV
	oUZtsZ6Mpmh48rvB0aFTKmR+IzAy2h0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrRw2VD2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id D6E2160DA8;
	Sun, 22 Nov 2026 19:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B91A51F000C0;
	Sun, 22 Nov 2026 19:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376259;
	bh=lKuvDTI6FKXAAEbVhrzFDmxnTT5Wc4CNv/2+sIEwHRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrRw2VD2LDlpWWnJ443LaoyqYPi4WgdTpxgCBEg8S1X4e6IoUvfRHh2uCryPfjSrB
	 k49cshsGh1pQGyu8+ruFN5d5UZ84WoFrEgLMgZL33GuKh7Brduf4ZFFAMf8oJ5YeVe
	 P5+logxlr1Mggk49m8VIlSPaAsMgwtpUd84l2GYBXS4JQzhRmyU1kB+6TwZ/FwxxFP
	 TpBUzs/TXlv3gs+UJ16Cf0VGW6o7otugSJjLKPf51TNLQRNCN0a4c4ZxiL5bmTIcJA
	 2hkuAJmkIf2j7Bq11dWJG+6VxJu6M2HyIMMaJTql4BEoanz/MSQ6sg6sqBmAtBU/UV
	 E0hG4WNw5gekA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 24/26] docs: Document userland uAPI
Date: Sun, 22 Nov 2026 21:35:37 +0200
Message-ID: <20261122193539.3334213-25-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41C3B40002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: hfowtfosc8tz1ah4cwxzzu74khzr4rte
X-HE-Tag: 1795376260-449759
X-HE-Meta: U2FsdGVkX1+LYA6zvu4na+e1C1e1yNqJdSmC22DrKLckTKesjugBXeEeyTNbtl97YH6d1q7fJsVQI2vVcDQ/pzQmEBWr+RiUljbQMpxRD7u4DxvVR8hWf6RT6YsQLO+ZJ2zAF6VBlWoE+l7HkPAnzAaBJHbZ3DesQQEl4BzHHhUjTWvQpF+RHnBVKgP990BrNXZ11YLSaxLjgyFRhj3BfKUJ8dYXs/uX2uSf0ERCjLGZWJQp9tcMhCkuyhP1QMVhg+AHeQGnIqr7SzLSGe0AG+5gOo66kYtiOvmMocTROXfxS7kVZ6X7h90rd9yLqn8NhbS41ReJbkRM9JozTsp9SCAoolc5AbirveMNqz0vUO0xg7S6tG+vVHr9zsZQ25DMXkim+yy/bEyGktHWt9YIM14DVdpNgyiQtuLDVJm/8OMspyztNjli+xbdSIrEMxmAuKuaLBKPFsJ8c9UTNx0LSby6N7tj/5XFGkhz5hPIyStjwmVA7CTQcwc1kMXtJ2qRkZUEwI3aiDtDFqzn92lJ4fWG00Sb5S+OgjbNzvniuJRqGLGpkKkFMbsyaxnYEPY9hwNegvvcR/nNE29+2IaRWXReKmEM/rmZHQw1DsHf7Y2C75tJCYDTnJUIf+POYiCBdualmEXsk3LMaKipzLGMJzBCCAuD0rFMdEJ2o5KuzDxQyBeDZE1iX4H6yXEYfKhz67bTW4DO8thn7j44JtMQcKmZQGG2E0/6KseRD5k35/YbS9HP6mW6L9SSZfJBKGH++TF7yo5+ndHBTimTopaQUmGCFk1fl9oQVvmmeSiRb2kGiK3fGTRCzYELJOTVCIZHuZzygmBuiYMT2FEyt04i6qWEvMryrHCpWT6pPkrkX5EwFhENB2S17Nv22O7zYCz45Oy+qsYP+ftUhlYbYKYGBZWV7JwkXwvUeahg/bBMe5lAhcaTvBD8nO1mIJMODSy01WtYEcpLzWe8q7I9cMs
 edxk4GOf
 GEA4gj09S2msk4RSsz4qbWFCdMsi/bnB0ZagFnA0Y6+8whEZ3AcFgSDOg2pEoGM/xJyS2oK2ciT3H41njgziZebhI+sgAyQzb+WI4pqdlrtTUHZusId4GF/mYDSlP2AY6Qwx7UeEj8dUeKnCumVQMZBkyS82JTRElQENBNDwpteg33iauGobDTKs6KBrYwH3a9FnLE0kQxQkWmaeAMSWD6PTcw3dNmljKvLIHD042PhW4Y8n9UAclNCWGydHs6sGLIARj+N6JMj1y8TuAf/sVJkdd9AIrqTr+cIlRhyJYXRfwAgutMaNEL4Ju4tCgvtU8FdHL8DlCMefdiNk0wChGnx8gpKvb8Ulq/aWvIGFKgKEkMxNdDn+PQBxKPiKtK1ExS72LHogwmMG+fGzKRTzzxDKRoTzEmMgCeWZb4eByP11BSpHljmdyjQZWnE+22+10mB1LNFlvQlEQz4yKr08tUMYx9lc8XOidgDjg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Userspace orchestrators need a clear specification of what a userland
is, its build and live state transitions, USERLAND_GET_NSFD,
USERLAND_SHARE_NSFD, waitid(P_USERLAND), pidfd_send_signal(), mount-tree
construction, user namespace ID mapping, credential rules, and process
creation semantics.

Add Documentation/userspace-api/userland.rst including the kernel-doc
sections, type definitions, ioctl descriptions, and system call
reference from include/linux/userland.h, include/uapi/linux/userland.h,
include/uapi/linux/nsfs.h, kernel/userland.c, kernel/user_namespace.c,
fs/fsopen.c, and fs/namespace.c, and register the userland ioctl magic
in ioctl-number.rst.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 Documentation/userspace-api/userland.rst      | 77 +++++++++++++++++++
 3 files changed, 79 insertions(+)
 create mode 100644 Documentation/userspace-api/userland.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..ac665b8fea72 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -17,6 +17,7 @@ System calls
    :maxdepth: 1
 
    unshare
+   userland
    futex2
    ebpf/index
    ioctl/index
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040999..4cf194e7b648 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -385,6 +385,7 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xB9  00-0F  uapi/linux/userland.h                                     userland uAPI
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
diff --git a/Documentation/userspace-api/userland.rst b/Documentation/userspace-api/userland.rst
new file mode 100644
index 000000000000..e32ea3501472
--- /dev/null
+++ b/Documentation/userspace-api/userland.rst
@@ -0,0 +1,77 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
+userland uAPI
+=============
+
+Overview
+========
+
+.. kernel-doc:: kernel/userland.c
+   :doc: Overview
+
+Lifecycle
+=========
+
+.. kernel-doc:: include/linux/userland.h
+   :identifiers: userland_state
+
+Flags
+=====
+
+.. kernel-doc:: include/uapi/linux/userland.h
+   :identifiers: userland_flags
+
+Ioctls
+======
+
+.. kernel-doc:: include/uapi/linux/userland.h
+   :doc: USERLAND_GET_NSFD
+
+.. kernel-doc:: include/uapi/linux/userland.h
+   :doc: USERLAND_SHARE_NSFD
+
+System calls
+============
+
+.. kernel-doc:: kernel/userland.c
+   :identifiers: sys_userland_open
+
+Process creation
+================
+
+.. kernel-doc:: kernel/userland.c
+   :doc: CLONE_INTO_USERLAND
+
+Process waiting
+===============
+
+.. kernel-doc:: kernel/userland.c
+   :doc: P_USERLAND
+
+Signal delivery
+===============
+
+.. kernel-doc:: kernel/userland.c
+   :doc: pidfd_send_signal
+
+Filesystem configuration
+========================
+
+.. kernel-doc:: fs/fsopen.c
+   :doc: FSCONFIG_SET_USERLAND
+
+Mount tree installation
+=======================
+
+.. kernel-doc:: fs/namespace.c
+   :doc: MOVE_MOUNT_T_MNTNS
+
+User namespace ID mapping
+=========================
+
+.. kernel-doc:: include/uapi/linux/nsfs.h
+   :identifiers: userns_idmap_extent userns_flags userns_idmap
+
+.. kernel-doc:: kernel/user_namespace.c
+   :identifiers: sys_userns_set_idmap
-- 
2.47.3


