Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1740660A3839
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSEjz7QP
Received: by kanga.kvack.org (Postfix)
	id F03CB6B05D4; Sat, 21 Nov 2026 20:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDA796B05D5; Sat, 21 Nov 2026 20:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF11D6B05D6; Sat, 21 Nov 2026 20:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2A596B05D4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E7231C3DB4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:47 +0000 (UTC)
X-FDA: 85460998014.23.D7E3C11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A927740006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BSEjz7QP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310385;
	b=RAUb6dpxZhBe2Td80Za65ShPB65dVdPzAponP/PiVQObQNjkY9ybsyaGpfEcbWQm3CD6+S
	x/DwowfcRkNHgbae+toyKPMkEXjh1Arz+QS8PYJ/WhAr8RKyDw7oehLFfGJWIKHQA+wLOL
	GfiTh7lHXEC6dhuBtClKcfm6sF39GSw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zs4d8Qildq2fNc6PLk+GUR8ZjIlQZmHZPkOwBRx3+1A=;
	b=pNzWBh6Dgu3Pam8fMtxXr/Ffr2uTm2m3620G8i49u5MooyQjLoFtVfVQF2w5aLQNQcTAZt
	AMC4xbiLJkyi4oOVxSxCf0Vj46d2Ds/Dbfg/7+ccXybaE7yVylRUUuJq9XkBnx4Tvnwtm4
	PKWqqa99o/w+cgvm7aGVR2wZyIiwndc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BSEjz7QP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E6250459C6;
	Sun, 22 Nov 2026 01:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 104E71F0093E;
	Sun, 22 Nov 2026 01:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310384;
	bh=zs4d8Qildq2fNc6PLk+GUR8ZjIlQZmHZPkOwBRx3+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSEjz7QPSFK13UkmPy+FDG1IIq4sF2YeDULrI4kWHtnu0cHVT8BQsyOnCBS1DxbiB
	 T3m9yH7tXkc/Nz3d02zn9FIeiXJOJ0xTdAOD7Z+OK2mcBaQL6VFOEJv6BSXb80J/2s
	 b23k7X0WN4XDBkpAty5H7RkbU5MnMRD5OE7s79xxr9CSR6uLtAqw+0qK3MvnCqboTT
	 Q0pGxvMJ/3KG0PEtlSQ5U2tz/A04upM3hqmPJb2DcHybDQm/K/cvNyAVZ/+5D8BZUH
	 wNUeAorZRDwveWkL8uc1RycN+j4q0tKfqTzt7naCD4eykPD1J5itOD5vYaHKabLL3U
	 we3gzfASKSNtA==
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
Subject: [RFC PATCH v6 22/26] bpf: Register userland LSM hooks
Date: Sun, 22 Nov 2026 03:18:05 +0200
Message-ID: <20261122011809.2667684-23-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A927740006
X-Stat-Signature: tqxx9e7q89jtbpnmdtixxdtna7nt3dkn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795310385-80047
X-HE-Meta: U2FsdGVkX189huZfp9d8hbVC+mHm4X0pBI/WEV9gM8J0gi7W6/TEHNAJEu9g6/dR3sR7gYsHrAJ0HvzveF4+ntD/2W6gkS7JF0uBL1PuOF+xBuNs85PzLn5m78adn9V/pCBzUzl3yJnerFAz1cEo6nAZXG5u5GniSPF1gEprMBpWDy8TvYjPtsxS95N83EJYBoeHrdGT/Kmf4TWayhAMTS4Lf9eGzEjUcw5/JB/CKivEd9p+eK/lXsy4Bg0V0bIiPdHoggV2Qi0cx3WY+L/ZVkrx3QJ2FhzkitObE3Eupl0te5BSradNA7XKRYm8ULcpFe1AlJb9GN8u0UYrJ/sBpu812AmLpMDmDI6bfNtL5SKkMOd957WT5fgVqJnkKjEejGIpDiqRhjAgE6qQzB85ichhvhXMemZto3k2XjhSiCcYBZmR8alwq1zoAEtd6Udvuds1949Cif8suc4Ayu5Xh+6bV27WDDF9UnIzNWSn8r+1eAp6GM9bhWAQK1mE1DomR44oZLikELdhFifEp7CpuRPqUuoVnuczvOPZFSvTTDnIUCYyTyU8psdOd49xT17cPpb2fpmVTC2465wLwnL5pfUx3CrP2zrwFPM82DlU+gvLw9BEMgMm2+tC0ohnupQyqYPfryLbUA5yuswyrjlpGF3Eep9fcHkt+BFKGN4qm+t4aMJpGJAi7GpKQDlqxYBYok9TN3kS8afLCjQP/cl3KqY0dAU5rsQon+/Gf6KQiYaaZ8+uO7lMc5QgVE5KBSbUpbTJuf+tFCmmWVt2EIzwHyp9qnkWXvrtOb7qgdOa1vY3Mioc7cSW2s3RDpUAAOhJOG5TpNmZUN0LFjifFsW6Jg/C2DilQqlleuYd/ke6rCblD+545fmQwiEqmo8U3a3BkyMnG9MpfglhCwrF8wZ/2g9m3Pedu3ftnFQUCnUQKoja0X8gUwnV+Iy5KWORMA/7ariOByfjQlTJsTJfdNF
 s7qSO/fH
 wJRf0ZL5Pre47S68BWk8gXXY2JlXQOIAJqpH1JQff5kmj7cyOBg7N9AdP6cDD33wqPgrnxOE33moc5LBkUZF2gKddWnei6HCYNUCGps+sGtu6GcRlq8CuzYO6OWscdUXVKDiqN9Y1JG9Ay1TKxFFi/nA9YDMnhIiAX6cl5xlUeUoCGbyugtu+CZV9+M0ew5kh4X85kAX266mJEVdnxPiKHXRCbDUUhKg3rbOkszGxgWarVfkw6kw3/RaQsLcsw8EGsZMW2u6UTBZmjE5DKUdqS0Zvtg3BvJaily5uOYPLQis6ORWAnoa4nCKtetO92aux4IYtqU9fMVbG2qi2SEWlV3sphWS8b5+/4d7EQBVKGUBIrs5zvmYnZJhGSxdPisXNfTvgTERTb42SKvA/eDvXZnirGdHRDpRpN2KrFXUDe9DxTI+qQ9OtvLPmDZNfoOElAfYq27thH8uixqw=
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


