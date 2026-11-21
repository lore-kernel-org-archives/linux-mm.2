Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 195C7606C3F4
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJXqL47u
Received: by kanga.kvack.org (Postfix)
	id C9B4E6B05D4; Fri, 20 Nov 2026 19:10:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4BC06B05D5; Fri, 20 Nov 2026 19:10:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3B836B05D6; Fri, 20 Nov 2026 19:10:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE566B05D4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:10:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7D8AA0177
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:37 +0000 (UTC)
X-FDA: 85457194914.16.F951988
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 275FB80009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VJXqL47u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219836;
	b=2yu0Pia/w5LZwL9QFiDRsi52JiVDXF84pIF1QF4sV8piuWTjcf5mMszpVLZC4j7+rwxPwr
	GVdD2VwziY9gPcqhkGD1JJLg530Qh0MShfRHO8EQo0mbrSRxBCCtEx1ptEqKG8uBZNGsFu
	qMkJZqGzrlxR+LuLBO+em2GCDq7fKcY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Q7Qhps4lRxBhkSd6Kom85Mw9Dpsf9pUqdpKPK8/kYc=;
	b=WrcRCO31yJQAAyLH/7fzl+ofrQAaF6wjXQq6ZGyHbBaAfGR7V3K+8ATAsO92YKCZEx9w3O
	DbzVAfZMA7AYo6wmZZDAlp3PL8OeHs4T2Nj0zuZkHm16ttbECZfOv46XEonLptUK+f/+yP
	1EcBc9NyQ3wZqgOXvWv/PwYgaa+JFp0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VJXqL47u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id A120D6217E;
	Sat, 21 Nov 2026 00:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 322BC1F000C6;
	Sat, 21 Nov 2026 00:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219834;
	bh=6Q7Qhps4lRxBhkSd6Kom85Mw9Dpsf9pUqdpKPK8/kYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJXqL47uM2nuAkyXuX/WrsdOfWCmf8ItRmVzZem6KUkRCUxP25227080tQqnBLJHu
	 VYL/laPTxmBa5X70DiTE88IuBzetX7HPW4xhAPYYuHeIjEcp7bFoOD/Hv0yCGjkUeY
	 o+H/r1msu0Y/IPXR0zjZvPSyDhj/AJVSK8ThNIbAI32kMsc3w2WhzwH573c3SM99ml
	 U844otOTOoTQgp1hY/7NdmdcOU4nLvV2Cuz3FanBroxCulGHuL9BJXzamMvHQLSMZB
	 Z7sKkUjDnd8OCuyHN18Oi1rMtYlQLM5WZATUPr0ft1Z4HB2H6fdF/3bnN4CVs3XNZn
	 2b0wx0ay85CUQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 23/25] docs: Document root namespace uAPI
Date: Sat, 21 Nov 2026 02:08:42 +0200
Message-ID: <20261121000844.1863324-24-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nghihipdfd3qwtwy47ek7zz5135whfnw
X-Rspam-User:
X-Rspamd-Queue-Id: 275FB80009
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795219835-960756
X-HE-Meta: U2FsdGVkX1/OFkolWs3fRbO5GpA9tCX4NNblvKRz8HZeQecTslX0YoMIhWDEwjjKpu4Qln49nW46RmWDP0sngDn3Rtx06ZG65SdhGzxtFd+LvidyNLbmgBW9Vsax9ZKpTR9YWuy26OmjnB0XR6YrXJx75ze1/xQY/qDLxdZDcxH/ClFQ6RGwm+Gr4kmKqaS5PdLeygOYmAK0qdJtELkiNKFvbmB9Ppj7KwPtCpZHiRE1j97kvSwnjEnKSBlEu6jalHv+suZ8mVCyexh+wIfaqNuDLCnuYmRJMQ5bgTWs99pLMCDnPM79AHrhanMCYVOJzQiU+FptIwdibgVDwBA1OeiM5ZbFm2r+RagTSquB5DrHcTnJjvtQNO8ueI/uTKeySlyJVMKYicuv6BQkgxTNg7MdzTSchgqQX0wjNblGMFqM8zoG/vNupFkiCwf5sI5T5Vxsya1F3/uSsAzvpO5M0vp6EWMJTEu4aNBdtR99qFdoXuVvY4eeBFRgeJgvpzbtEKGQuucewG9eoQn6PnFrWcVwlVCICNYMKsb3PHq9jkIOSKJwLtpnEG/55Dd8DAdY9t3nyXgsFTRLLhAHwNoheheX/h3050bVuzzcnVEtB849yHpJrRPvmXZUEZfuSzuJdCZDePkvRtDj2i4X74Zlf9EAcTPjwNkekwdajrx5rQ0hcLz6tNRX7W4Y9fWZylyhxw4/RNIlKHJhOxysDN/YH67BywTszfQHjtz0FUjKYXzpvw/nBNjFRSWy2ubEnxJfDy/nHHogDQUiopqJM7CA5BZY9jluRGZ/Yyr+IfWwPsMfN+VqF3WRAG/CR+vsZB+MhG9n/TCtN8sDp7IW8yW1SVZ/SNEFzBt1vifMlTCtwbtmLjhqRN/a0eVdmyQtL0f3bFoJJFkvae2Vj5PTp6un+og/HvWlVcLKPwlokw/XBrMakEq3TNLTqLIk0iypMRK4LeQkPzoXq7Uav7D32U2
 czY2jRe9
 jHBCJE+nA2/7UgDUAkYa2IcZbUDEt5hJGaTa5+U93KtfLWJi7VUv+0zKrhKrEwSnIUyQujzpgkyF1CvIr+dkq4IMkh04gG9hbR4v0zOp1afAcLjMOkF9MKXaj41UpRngsvbaFTifMJVDzaPpM7QFnpWZb5DfJvCaBz6/owQIw2o+92Xqjw4msxrytZOkoxm7AQ3jhp/LfO6ff3JynM5yH6Td3gjH2WlXViUemMzgvvYvcwg9lt1YyAsn638KUhqHybCwB6oTo1WC1qSrDPjiEJnf5AVojvOwqHafm2IUhvVGpvbQiVs6NzO1i+c/GDctC7+aBLcmabiZjXpXS4EkGpnAgPJdI9pGCOUvq8Nexquc8PVN4hkAdjG3KaZmHWo8imKjzz5ni8BHA3lq2DpqK0noGbkNg3egqGdG+Gfb54JVqLKSBllXr9dlSwwv5L4DsRYkehwAYQD09THhdRVePQZ9qNsNyiH+hVZONONtDk9wNynLJ1Xvg88u4QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Userspace container managers need a clear specification of rootns state
transitions, control ioctls, mount-tree construction, user namespace ID
mapping, credential rules, and process creation semantics.

Add Documentation/userspace-api/rootns.rst to include the kernel-doc
sections, ioctl descriptions, and system call reference from
kernel/rootns.c, kernel/user_namespace.c, include/uapi/linux/rootns.h,
include/uapi/linux/nsfs.h, fs/fsopen.c, and fs/namespace.c, and register
the rootns ioctl magic in ioctl-number.rst.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 Documentation/userspace-api/rootns.rst        | 65 +++++++++++++++++++
 3 files changed, 67 insertions(+)
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
index 000000000000..ef18ed59ba4a
--- /dev/null
+++ b/Documentation/userspace-api/rootns.rst
@@ -0,0 +1,65 @@
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
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :identifiers: rootns_wait_args
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_WAIT
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_KILL
+
+System calls
+============
+
+.. kernel-doc:: kernel/rootns.c
+   :identifiers: sys_rootns
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
+
+User namespace ID mapping
+=========================
+
+.. kernel-doc:: include/uapi/linux/nsfs.h
+   :identifiers: userns_idmap_extent userns_idmap_flags userns_idmap
+
+.. kernel-doc:: kernel/user_namespace.c
+   :identifiers: sys_userns_set_idmap
-- 
2.47.3


