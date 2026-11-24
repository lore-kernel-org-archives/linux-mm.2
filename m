Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5D9606A69C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mgYIbdsG
Received: by kanga.kvack.org (Postfix)
	id EE1536B088B; Tue, 24 Nov 2026 18:00:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91D66B088D; Tue, 24 Nov 2026 18:00:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A276B088E; Tue, 24 Nov 2026 18:00:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4F0C6B088B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10768120AB4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:11 +0000 (UTC)
X-FDA: 85471532622.27.6A00BEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4808020009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mgYIbdsG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561209;
	b=AnHTUHj/qnLNgKYeLDxzGag2ORRLCBZjMZ/P8ZeaF3CkTyPoJI6+6fOtIRp+QRfB4OpHas
	Nny0asAiSYOocnvNRN0Olu3ZclqvMWh2TD1q/XqpRXXkfepXtH78X/yTz3k2Y63+Uego8F
	4SjKqvdI0KnR0rrdLI90CVj3KyUzBpY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0feYN/R2FDAOMvuuGg2nEIG+B6KetnzfNzJWBWhvWNA=;
	b=X3J+Dm7ZL52ICamUlQYAFesKDaXb1luFCL+ytm7gcy9JCf9W8BKLk8pNxKVmH7UcqLlVaA
	O7O2kDFntQYbQTcixCGEIEHZAtPdW1O/yvfVhOLj/IGlwmyICVtB3L4n3+hvZKdHoONJpo
	b1bstuVmIK8645T6zwWcCm3TAfGH1hg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mgYIbdsG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD560623D0;
	Tue, 24 Nov 2026 23:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFC71F000F2;
	Tue, 24 Nov 2026 23:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561208;
	bh=0feYN/R2FDAOMvuuGg2nEIG+B6KetnzfNzJWBWhvWNA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mgYIbdsGnmPZG2j7TfgnL1OEa62U13cmaepx3KSV+4lKXe217eDzUYnAZNaLQ0RWM
	 NGCSFqkQw7ZjE/j0nc/HlQ6DRTvXsNKdEUOmTgC218oXRkIueIlhfZtGsVC7ysjktm
	 IjVXLUAkItsrs/wDAirdq99jhti2SEHMwozSdM6Y9r4528tl2LY3CenAUmPWPoU1xM
	 clpH2Sjc7cku+WyKPxn22aPsSdeXCUGcuaQd4aAhpY50DcAeorqs/BvmFy2eE55Sq3
	 3oCisH3LAiv4Xk6xwQg7jy/pbMAJo9hFD7tMLUKOzoOwXD8hUa04nKDkNEnvE2Jo09
	 EocHxqYjWyJjw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:33 +0100
Subject: [PATCH RFC 10/19] bpf: mark bprm_revalidate_files as sleepable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-10-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=1083; i=brauner@kernel.org;
 h=from:subject:message-id; bh=bUCL8eOf1z1WRgfbFg/Py5qqAPKAUwIu5FqZ2Hp5GgE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziR2sSl97UIjH5PRsvfQtK5xe/VvJqM++NLCF5eDrq
 Y3/Lvw06yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIm1pGhqVmxrZnd+xcn6rv
 IG342b494rNs7ulVC68wPd/XUeD6fQUjw5ynTEv/rnJ1OCvFM79xepepdH3mrCuqWQGtArEf8oJ
 P8gMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4808020009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: k5f3ypag1geguquyxp88ds1d8c5how7z
X-HE-Tag: 1795561209-722700
X-HE-Meta: U2FsdGVkX18NgqjVVsgTvR4dpoKYtEOhxwq0dsCoj7ay0yPf2zi8A7v09s6xt4bQKz913RwbTLPZh3ET6OMudbSW4AaT3Hei1IcO/tBIfXRxJQwn/P2NQ0TGxaG+0tFTfqYZ66LM8f10g/iStQrYXSZ96JeBNMb9lGODZBReG10yYCe+m71bvaVWUnQ5CdXn9WmdXo4pzuw0CDQDEqGX+ZLN6tAuDF6G05rFD03dZnr5Oj6+zCVUVCvOyLJWZ25GLylKI2ko5GYzlwOKtiHG5NXC7nTAi/+UknOOpKhQTUYmL1ZysYRzpiBoho6Pb/y6UfYP2iKBJR1brzHV8vTD6sd1t+JUVAyMqmQmaAJSXvmbOW5ShmzOkpVYtI3qoFQRlcyGNFYb0eViP2K/faMR6uaLv0/cQDQ1B3B2PsKKx4TTrPp1vEH4B+LDk4CI52ZauXjKcxgjniAjnPtOhSSJ0hX1g3w3Kw/H+36U6IwK89NoAIGp9cSK6VUcsAtGmuj8E4BhRNNjB1fX3niB9ER9o2YYs3J546NBZVGX1MDDmQfXTmLxZkLNq2QVky7IL+zlXhTc4MFqgcfW47gUXKEZ06Wp/yLD3r/qx8jO+DLw+wJOi0Cr015t2Sq2DpG3eA6tIPB7tw5DlT1Bt73ywZgWAYbqwvGMe523V5btUtrWFkqylUiqMyMdihj4eknIruvAR/hsfQ+NEX0vkIfa4i0lEZXT9fgAhhaXZF4+pb7H3HWQzycCEtj4WLiLifaNXZV42uBzOKfyFFS/0P7vKX7LWx1E+f+jeTg6i/N8OPJuIsQAhNxJp7B7KN2FdWTJyYNZoHPqAQaILKtcnBKzhVqlY5DVFFuvrH0L2VhcPKrrvxTDwxGAD5r1RIFgctCU/9OvNpHKLmNBpvYjGr4SZ1dABIQ+OMxeMshYL9zgqmI/32b+Djg2rfj1BaDng2E98EO0+MVL621qp47N9pYgxz5
 6C4RLjB7
 IFOj7LDBO7z0f6CYk0NRIwBHBbw5VvyznB9wGygYBw8Ywj2uEcAjsWVXQtUKh8uoNwnul6fzAhV0F5bbsY1TV+5wLNkTpdlhN6MFHuSfTGQ3O7FebUl5LnZBWI/PCWCV7wSyOZjBsgAmTJhFOYzkn7KsFUhs0nBcUN+ipVthL8ocAohNCCHx4SCw8t1FI7pOx4A8X37YL9Ys0F/8l196UAg/X5UpFvvckEs/M/ZM05iCy7J5pWhjFHuXM7y3aUg7uhveGciVxq1l8Hc46jGkN8ZCzR4ACXCgg38hkK2OnDYFTYkRZzrT5gLyUCcXwzoC/EreLaUaMsVUYGczA2Ob6BYOahag6JJWmelvcXzpw3Qu4+WTz2odjepmamw/Waz8INpy0/DXt+JMq705p4aKzTMoKDJucKBFqgguttFHTov/wdjcATAdBvxCbGZSZO/S77puKiKU4/hYavb1OMOGVtTPbIcrE6mELtw8Aw6Sl0TGREIt6EW2GgX8V3V5NTXGIfhQtaAihfXnUHx75V4T/WWHchAFI3Kg6uGbm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The bprm_revalidate_files hook is called from begin_new_exec() right
after the close-on-exec files have been closed. It only exists so that
an LSM can revoke inherited files before exec_update_lock is taken as
that may block on the filesystem. So it's always called from sleepable
context.

Add it to sleepable_lsm_hooks so that sleepable bpf lsm programs can
attach to it. All the other bprm hooks are sleepable already.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 468e63dbd922d..df6ee6e3674dd 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -324,6 +324,7 @@ BTF_ID(func, bpf_lsm_bprm_committed_creds)
 BTF_ID(func, bpf_lsm_bprm_committing_creds)
 BTF_ID(func, bpf_lsm_bprm_creds_for_exec)
 BTF_ID(func, bpf_lsm_bprm_creds_from_file)
+BTF_ID(func, bpf_lsm_bprm_revalidate_files)
 BTF_ID(func, bpf_lsm_capget)
 BTF_ID(func, bpf_lsm_capset)
 BTF_ID(func, bpf_lsm_cred_prepare)

-- 
2.53.0


