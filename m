Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3C360A6F44
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1VCve+e
Received: by kanga.kvack.org (Postfix)
	id CE0EB6B05D7; Sat, 21 Nov 2026 20:19:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C914D6B05D8; Sat, 21 Nov 2026 20:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3BE6B05D9; Sat, 21 Nov 2026 20:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 849A66B05D7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED537C064E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:54 +0000 (UTC)
X-FDA: 85460998308.28.628C41D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B02D40009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N1VCve+e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310393;
	b=cby+3Yo4Ro9fhusFWjytk1OjIEaTZ5UCEGYxBdsYPfgLdZ3Ne0+2Lzh4s6DzoVGkAExAI3
	GmDDLg4dko8ge7AAISaoGcwfo++xBQR1MlP2AVXOP/2hhBwITZuRPBGEdBYeIJorKgJJCu
	yXh6GBPvGjZ50mBn2a+YmorkoO2n+dc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIPgrr20qThME/B4ztDpobgpWXK7j1eqlzMAWRvKnKw=;
	b=i3YpPVDoSLijfSFppCi8MY454BGP0MMHPX5V+2Nje4oW4PkEe1UcIHBDMgt6tFsThM7Hn5
	MJ8S9UNrdIM8r/Mf/O/iTAVYQM96dKS6L2Muu+j3d0THqs36vw3yB4Do4D0Q7gVToCEd09
	0A311nLYhEjz5rZznJBDujoRRpb7kuM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N1VCve+e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 966B042E6B;
	Sun, 22 Nov 2026 01:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CBB691F000D4;
	Sun, 22 Nov 2026 01:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310392;
	bh=TIPgrr20qThME/B4ztDpobgpWXK7j1eqlzMAWRvKnKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1VCve+erKOf45/nIxWvFWNngkecpsxl7xxxliFmPo0svHbR1reuTxcspUj4s/hX0
	 UsYnqTPk4NKr5TyNC8uv7wdlSLg3zEo9e8ht3OR6iahdbYJp0N+VsCKiolgjce3Ysq
	 vcyawplXD7pDeiX1T0PpqIdDBVeKfMhBkaBwUTRg5R7ZHMmN20UHRPqHslC97Co3XW
	 AeZFVs7/lzF1J/ofM2ldo19SQhhIZz1b8A6JXkBqdIcu4GLeXKojiP5Fz+zI29Rjtn
	 Yd5itrChtNLuQUuEDcuS0mS147TQVZzwchaveJO9UfUN5HkrxfUJ4F7PuP/AboFsF+
	 t1u5NWkPCndfw==
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
Subject: [RFC PATCH v6 24/26] docs: Document userland uAPI
Date: Sun, 22 Nov 2026 03:18:07 +0200
Message-ID: <20261122011809.2667684-25-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B02D40009
X-Stat-Signature: ddyy4s7c9e7t3mnpga4p1w45ha8t9ucx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795310393-874321
X-HE-Meta: U2FsdGVkX1/PMfhyO3vPxGoeoTD8WdRDPg6ZN3aLMRtzAwp+6WOoWqMFPufZjmi1aO0EUJg5mNhcFK8NqN6WICPEPWtbUX1ujyJ1sjDEDd8RTUCIvBNTBHjdn/2vZui2eiY0ktpIEup+hC0/6LvQfxkFmslhBC9IxoKrrpfj7zGmz7H2Rf4Z2Um16x0CH6wO6bJQtZsAd5b8joAZuTL849FJvW2m+0BiW4o7j77Vj+S9ybjKc5axIBF65q9h0kb+y9ANHy82IzpbiLCzNozWxQjMQ9WTlbofkwkP8bCGYM5dOzp008RHcM6D8fVqflYWtn0sK4LMFKWoxBz3/oe/+qDVp3Odp+2MYPIDZVhPvamJXH4hv6+OPC/1oM5lXT3YfZSbJfKEAFDQ/vXjuPcrJOW6XGXNlJUmb/0dTzynkbihQv8tksSf6hEuJwX3O4ELHXzbsq7Z+L6RdWV1iBXAwYiAzgi2Dg4ZUpcNqTaP2tim+Ik53Gmhp/n5gm4+VCOOi7Le51mThwmjAClfIywd3optrQZ4dzYxLpnPbkME2xPxO6DNBUTVDNfTkGTUgxq9xYhwz+jUuNNVCXiQ4n6bVJi0MXOVc1Qs65FtWdv5INehRkoSGzwTPQnV+7GhwGje07/1ejFWg6+iGCBBZs/hfl8jX49KlpzSY72jRF6ly0bdK68nyONjdxKtPvT9yCzdCQdZb8d/gNDFvYuXX+WRVGGdul8ETezViZW0VrWdCrXlwcC7VHyRL0g61JSdqh/HgZWrg70Yw4hxmnsoU2BxDCQ70DLiDAWaxZoHv9rfK/gl/e1UzmzmJicqgI/ck5pZ7JVepZDzlF8DNolEYBHDZPIKQg55eeF7y9yDkFCc/4rfgpOfuHNsVveXkU1cLap+2YS3IrnhHcWVwFdcngoTgRMaZtMB92Tyew6i8L5e+WbvM0z2eRK1fgel0sCdyhjCFySWaJb6j7wqqmjfOLw
 CRHiIc/y
 xGTvaxpjsrOg43dI/VmtxZNIs2LHQzrXoR8BHzJY4DLvRz7zDWGez2S/eADDkBvQKGOJmLv6j1Lulcwp9ACbX+GC83+sC/QtoHyHXkv3NPAYlsLq1zTVykWYetp08RnW5STutyTzCpJb4dqs5M5/RZ9U16qOE9X1GP8F/OdapYNSPbPo8riu67JpsGXanbMY8dBjPjJCzKSa8FM1klMKYHGnwtcooPoC/pW9f8fwYz41UBZjqtCr8Xsr9H8A6Wrs7gC/Nxqn656v3pAxOHU6I3JHutCvlm+xSPmJAEwOW562zXiBTOHJ2ru5mO+PpGuUfBA9qSbgv1SEODrdy55gF9HeEBhD7jtyxOvhTh0SOZvKRJyusOdEDTEYAEL1FyOE6OX1BmXiZS3mPblYJqDrW9yGKiGKAvm3e3oHDy0/tEP9d4H3dih8X+zvzOt9AnVVQh1v7Gu+cbO/yIBADvvk0lnRE/8ngJVX8DT6V
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

Add Documentation/userspace-api/userland.rst to include the kernel-doc
sections, ioctl descriptions, and system call reference from
kernel/userland.c, kernel/user_namespace.c,
include/uapi/linux/userland.h, include/uapi/linux/nsfs.h, fs/fsopen.c,
and fs/namespace.c, and register the userland ioctl magic in
ioctl-number.rst.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 Documentation/userspace-api/userland.rst      | 73 +++++++++++++++++++
 3 files changed, 75 insertions(+)
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
index 000000000000..47d5c39ccb1c
--- /dev/null
+++ b/Documentation/userspace-api/userland.rst
@@ -0,0 +1,73 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
+userland uAPI
+=============
+
+Overview
+========
+
+A userland is an anonymous-inode control object opened by ``userland_open()`` (not
+an ``nsfs`` namespace) that binds a detached namespace set, an initially empty
+mount namespace, an owning user namespace, and an init process lifecycle across
+build (``USERLAND_INIT``) and live (``USERLAND_RUNNING`` / ``USERLAND_DEAD``) phases.
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


