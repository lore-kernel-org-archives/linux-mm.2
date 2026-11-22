Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095EB606A690
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8nWhqyY
Received: by kanga.kvack.org (Postfix)
	id 2A79F6B05D4; Sun, 22 Nov 2026 14:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FDF6B05D5; Sun, 22 Nov 2026 14:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E396B05D6; Sun, 22 Nov 2026 14:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECEAB6B05D4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:37:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C6C91A0673
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:33 +0000 (UTC)
X-FDA: 85463764386.30.A516485
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C98144000B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8nWhqyY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376252;
	b=FxrxHGyduLo+X7k7bn3NrT/tchEXxp7zXtvizesoGZxFw27DWuppnqi2EDL9O5IEfBRZut
	EwlSjUBFxCj+Hj3MtEuQ3pTxBl+ktPjo1lPh0x51/ylaKsBaOetKALEEHI3YgzDO08bF2c
	wGca62tvlmvRdVZMUvEJLNWpxAjntao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zs4d8Qildq2fNc6PLk+GUR8ZjIlQZmHZPkOwBRx3+1A=;
	b=WX9FaAk+n4zwvuk6PhoCW5qUmVVzNJz4Ji1sO1dnsivVMXdKjrcA+Fup+dtfFcuuaqm6hZ
	c6YL4uGbSsscXLSkiIzgDAV0N40JpI6arI0vyxMzJJuljsL0gpXinoVD9f+PfH3aAxAXeW
	JFM7sxxeFxPzHOLFY3pF67QnyOouBQw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8nWhqyY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 1FE7B40B8A;
	Sun, 22 Nov 2026 19:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 193F91F000C0;
	Sun, 22 Nov 2026 19:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376250;
	bh=zs4d8Qildq2fNc6PLk+GUR8ZjIlQZmHZPkOwBRx3+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8nWhqyY1l/5oIhxo9AusbNPDS7pNe2c7jdlfibiK9O4J7YFbmrpPsuK6dub2ROAe
	 rn9773eP+vZgMLsdrGpMNtNwUR97O+i7Ymi7QxvdMtYxyu/B5vZtW0/SSzz9CikZZG
	 zz2so70cW+rNG9k2mcDrKZFtWEFpUpG1MUttpQAI7FZabGlKL8TGb/tF7vF0ZmWO80
	 Hm87LXNBNvD3YulVza7xOlYl39k1q+U50EdgVJtvNyOJtHreMMEnqffEYjwpr841I8
	 Iu4gBtD2Cfw8Lt+5t4n478r/phiivzEwhQSTNlPRapp8t/upmoP72EBoqdD5BcfafY
	 ZTCS4Or2D4EEA==
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
Subject: [RFC PATCH v7 22/26] bpf: Register userland LSM hooks
Date: Sun, 22 Nov 2026 21:35:35 +0200
Message-ID: <20261122193539.3334213-23-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C98144000B
X-Stat-Signature: 8afcwq8k86zd5bdubothhjb8npa6k48d
X-HE-Tag: 1795376251-393043
X-HE-Meta: U2FsdGVkX1+cWwb0zNhIArPp+5u+RssYOVWlsEo+2oClVf5qHictBfpEyVoBs0bcmBk+Z5Zmriec5QcwyOj5RE25ypgwd0dGGUzYbcFZAiLtpkA0d8CpE3okr6AU24SaF98hoWU5ybswfLcMxR50l6ChbpfONsyWZdzg+LbVkHW+VgE7+xc5BDDtMKZnjaZ55470GsLFltekCo90XjtYLBMFDxP34dpkefEXKj1iWBEkUV7l1RyHwaj+BvcGhBoBw3QTQqCGXlqKznD0SNX3aFzC9dIN6rb0FdxM5OVY6OXQF+1YGLeiO040g3cIwplbwqQ8zk6wqlX1u0CRGg9YB0WB2mkcfLPwooeSkAoVjV2DrG1nkOFtlfl4fQQmJBT+vuHg9r+PQvIQIGd1bNmmxbNocMP573depUVAg09GufZy8si5uPCvxUbE8cRIIfpIyxxBZBA+Re/trGnCBGtuypADSOichtTmDlxSwNRzRVwSih1oef3tVcS8Anldiqn2dWP/ToZPVLSAWK2wL0N8q4E9hkOoIq1fEmaCcCXcDFpHKAX85ioy/5xme6TKb6829kELnzavQiBrBlJWqhY15l3MFEvGMswUUO864tG272KHDIbahWBeymAWLfpqIAv1aM5MowWcgUwQvrBZpnabIoMPIR264frZqha7f1woKNgLf8CTUPY3chV6hzIvkLnEJRNVwZ5ytNpBeydU1eP8XqzE2iZqbFMRxjhxJXbr/61MDVkorUEX3RhHlmTRDfvF3L9MSkWv9Gf8wiPAIwxvcoopDN8aP4nvPRhV82i3RbU8Q4UkcUg/x6hknedP8Z1oRl/XaCXXYmH02VvOLbZBzh8SdaDHAGh1rNGRpr3rF4abppOngzzw1Vq47L9O4UaJo19FwyCHJh/6trbqGwrvInheC4pdaCddoohtizju5mZ4UL2UaQtFKCTNJZ31ZlrpruH4T+7RB/qAy2lz5UQ
 yLHXb16c
 us3UGJXAnFwjBqMlKyhoN6K9cTg4MMWml/WcvZXdsYb4FEJCVBWut8z5vxauNbgfBIQNZC2KebFO0n+X4kuVoEKqk8xeNFnN2i8RUzWiwBBrkKbmozxZ0TA8lHvRiNYr/RwQOoyPuEj7XluRqwdbwp0Lqdn1r3LvyH1t7Z3p3FxSaHFW/gKNy8CA45KL8s/7+XB2Jt7a0W8IGHQBy7XzWsOgX6bLYT+zx0XXpgYjsDrjVnXVHL1lpXiYYWdF1+Cp4XRVp07ivI++mRmCCAb4nxak5C0vQkJFDYUAwOE2jvfv7tJNqceDInIAx4bsYcoYJGcX6iide2hYOjPnx3w6IIoswdbB/bUNQmnBZ6ClRW+t4/QJP7+C+2dYXgN57wnDM0qrjgM77dtb8o9FvyoBvI8HopCykfjhrdv0FbIWeQypFnkk9uyiKxAKzCDlCadLKh/atsga8BVrjfMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

BPF LSM programs need sleepable and untrusted hook classifications for
the userland LSM hooks in order to attach policies to userland
allocation, namespace sharing, cloning, signaling, and release.

Register bpf_lsm_userland_alloc, bpf_lsm_userland_share,
bpf_lsm_userland_clone, and bpf_lsm_userland_kill in
sleepable_lsm_hooks, and bpf_lsm_userland_alloc and
bpf_lsm_userland_free in untrusted_lsm_hooks under CONFIG_USERLAND.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 468e63dbd922..ac8508a6b242 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/userland.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached. Notably, we qualify each with
@@ -404,6 +405,12 @@ BTF_ID(func, bpf_lsm_task_setscheduler)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_setintegrity)
+#ifdef CONFIG_USERLAND
+BTF_ID(func, bpf_lsm_userland_alloc)
+BTF_ID(func, bpf_lsm_userland_share)
+BTF_ID(func, bpf_lsm_userland_clone)
+BTF_ID(func, bpf_lsm_userland_kill)
+#endif /* CONFIG_USERLAND */
 BTF_SET_END(sleepable_lsm_hooks)
 
 BTF_SET_START(untrusted_lsm_hooks)
@@ -420,6 +427,10 @@ BTF_ID(func, bpf_lsm_sk_free_security)
 BTF_ID(func, bpf_lsm_task_free)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_free_security)
+#ifdef CONFIG_USERLAND
+BTF_ID(func, bpf_lsm_userland_alloc)
+BTF_ID(func, bpf_lsm_userland_free)
+#endif /* CONFIG_USERLAND */
 BTF_SET_END(untrusted_lsm_hooks)
 
 bool bpf_lsm_is_sleepable_hook(u32 btf_id)
-- 
2.47.3


