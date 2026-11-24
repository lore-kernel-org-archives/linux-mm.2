Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB177606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JWH0qSAZ
Received: by kanga.kvack.org (Postfix)
	id 11C2F6B08B0; Tue, 24 Nov 2026 18:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC866B08B1; Tue, 24 Nov 2026 18:49:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24666B08B2; Tue, 24 Nov 2026 18:49:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4F576B08B0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:49:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65BB1C0DB2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:49:16 +0000 (UTC)
X-FDA: 85471656312.03.53F01B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B56BB40003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:49:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWH0qSAZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795564154;
	b=IrH/fRXVggFFMcv9VWxIroznoThKBDtjSTeeYKnN8fzg2Gk/2zgbgyxsveGERUhcqeKg/g
	3eYpfmMOOUJ6w9uuLi20Mq3fBON5tLySKarIKvip76YH2ib02qXmx23XrxT3MMdZyxySGX
	iKvafLs853PTVvfztf2ZNlnp6U5HAT4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795564154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzVCyim1+gn9POglvsFKaOvJSiB4wTMgOv/rH14HWB0=;
	b=EBb22JLv+JSZTbWlrJbaRD2WleFSLJbGkWseKpGUwVq81hi8GFr9eXBzgMWAtYO44CpRes
	JV5d4QJ3juTFeHAizft4AT5Bm1aX1cPxZHk5r9UQPr3mN7rq+/QxOA1QmAwHV8FzwVed04
	d4mdyfWRigpOOeoqrUzOxMPhdTzvip4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWH0qSAZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD4EB44145;
	Tue, 24 Nov 2026 23:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878B41F000D0;
	Tue, 24 Nov 2026 23:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795564153;
	bh=DzVCyim1+gn9POglvsFKaOvJSiB4wTMgOv/rH14HWB0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=JWH0qSAZTjFl6LjnHlO8g82S70LK9uxvihtFlxNyDhhs5nY326gdIHYnixSjHmfaj
	 8Vd+Cbxr1IGXcnzxBME7sk4u4ky3aYbDxOzVkOdcqxsDaymjVYRqMXQadD05pB9kV8
	 2ez1Axbs/sYM180DOmkFOSY5XTSgMglcfSs+Qnaevf7h+kmZZW2hTEuMBPTaTumHht
	 fat1cYvsxmv5C8j+TzgeGNHb/kcNZ138P5eZgLX+3d5UTChnqU1MS6oNG03z1vZDy+
	 OIZK4tk7e015n63m+Nb2xcSnz6tIcKV+EQisMwZYd7Tkc39xqCcfnYhcpXU/NrC7uP
	 PVSxLH3y9+AEg==
Content-Type: multipart/mixed; boundary="===============4896982406480640730=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <cd715ed46deb14d0a7becc6defb029b6862024758c2392d1cd203e806446fdca@mail.kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-11-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-11-e489035395b8@kernel.org>
Subject: Re: [PATCH RFC 11/19] selinux: revalidate inherited files before taking exec_update_lock
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,jannh@google.com
Cc: torvalds@linux-foundation.org,linux-fsdevel@vger.kernel.org,acme@kernel.org,linux-perf-users@vger.kernel.org,bpf@vger.kernel.org,selinux@vger.kernel.org,kees@kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,apparmor@lists.ubuntu.com,david@kernel.org,brauner@kernel.org,stable@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue, 24 Nov 2026 23:49:11 +0000 (UTC)
X-Rspamd-Queue-Id: B56BB40003
X-Stat-Signature: i6s5oihdzgkfz96nnigfn86ptcf6ri3m
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795564154-553301
X-HE-Meta: U2FsdGVkX1+3M2AqynSi4We6ViYmeqwhALaEDOZGM/qqZrCrtvImD8y4dn8mRldJSoosmY6sYHXRhh1oeIP4VWzeFlbaNQ3nDsrDoLtCB5DQtyF9nPXPi2byMSWkbiGTUxbuoa72kHySYDlA0YPebSEK/HI78YlVf12Pri8jQdToVIYBe0OTe1sZkZ6eP/FYb/Z9qnFIJsfj8kwgKVW3qAbY7oIk3c15iYPWNtDGVS6mkiNRiVaqMuqBPe2Fgm8atZq+bKvOhoa2Rs1dUsDpzp12U32YaDnZHgfPZb2HruKa6Ekc4K0Gb3vtx+QduvmKFB5lE272ICY//qOK37z0XT8ahh301dKR/xzt01jlVekAFlCmNw9C+03aZLVW9AtMDULR9U4a+d9n5rZQnl65hLJrSL5IYl+sUMPlYADfozHCgKUAzdRI3e3hUgXiR0ldQyyy9SiadIj7Z1PnCDuthZBNods8uOtr1b5PrMByIOGUooEjAXPt7oMw8SE1cGvQ5p55GUQUK94DLxEjNBX5FgDSFIZ7fGL2ifgIf8JWSX/ZmDjIrxYHKiDnBfA9Pp+NXZ6w/pF8st3EpQk3IRPCl5ihRJHbNwiPUc1VueCJCCdGUvhR1Svma2K6Zus8ShwxJ+VsnIT9boCLNq4V14AqGkyOkQqweOoRu5eJa99qMLwu5GlC3cPKeucobQqeVxUHngGOtBQBLxW6DX+PcDAxxi8HbIgCFORVUBMmnPQ1ceT8iLYwAekJ1ZHLRPEunYemp9+xRHXjWqLp2yQJNM4yZcTYxCXpqqu8Urj3+esNL5YbzmjN32fbD/mzycoP0ofzliOi7nwvTG2JusKpXuPmVLGiixXTxhRFKexrJK1WEjSRIAVBhuS/NcMpoqLjzou9S4TxW40vU53v1DxgXPvh/PX6bLUKn9iixoSWMXXYJuz//9B/nM6LzZE4bNn2g6xDeexrdtZrMA+xqxpY8Tg
 fnNWGkqv
 qcPP1j3dn/6PhbZgIB4nXHkurhbLNI4dZBdV/LhpnH11kcz/uuwLM1+L65lnk2GS5NFQHVEOS2uDXbWXqH5LjoruYVPpRMVLF/LL1So7/zzIt/hUPssNwDjc23OcAiVfw2hdBX4vdj3GxE1LDoqL9Rr5dAGQlfkgjklMfb6BiPadmDy2gkWDORkqV0bOnPRXnplSBtvJHWDXgPaDgBy+iwbjJbZOhb8m+3fVc9xb65bkvGbgx5eSpsBh5eiWfey4HqDNk4VDfRcEKler/x6fFejIlyWVSCC4fBfYbblm6LRV7lyVVy8Q5f0RnHdSL/Vi6xZNemB/ZHYCjUZUKMZ08CDgYUSCDxQ2ZieQnSlTx3wtLJ6bw/PcO6bSpqmj8cc4MQAS30oI1JgzWxIXEC32xxX2LWmtnIuwe2W8dl6jnuz8YCE3XMtsGxc0ioig9lLdZ/Ha1AFQW6YoK4WIAgb/hSRNkINJQGaYLy/gQEJZHIuFns8TSpkkol50n51Jkunn8luyBS6MlrKr3/1oq/xzhEnyNkW5c8Y1AIrEINh7jbJFU0EdHLXHm2pnAciqfxPi5qyB6ARCqWas5UY/06BjnjVdXtrgYXLoCzYXC6Pl02UacDWELY5OcRSvPsMKUDXw84K+eeHUNWJJJA0LJGSm0HjFWHWcKLX3p5wtH5p/kd1xM+B4Ee2btT2QeXD4dDCuG/DD30pYQZh83I7I18aXEU94kqdC43AgYkvDgiuh69xlwnRweBr6AE+Fsh4f8H9uZ8Qc+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============4896982406480640730==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selinux: revalidate inherited files before taking exec_update_lock

TL;DR: Moving flush_unauthorized_files() earlier changes the comm logged in
SELinux AVC denials to the pre-exec name instead of the new program's; asks
whether that is intended and, if so, to note it in the commit message.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c

[ ... ]

> +/*
> + * Close files for which the new task SID is not authorized. Called before
> + * exec_update_lock is taken as closing files may block in the filesystem.
> + */
> +static void selinux_bprm_revalidate_files(const struct linux_binprm *bprm)
> +{
> +	const struct cred_security_struct *new_crsec = selinux_cred(bprm->cred);
> +
> +	if (new_crsec->sid == new_crsec->osid)
> +		return;
> +
> +	flush_unauthorized_files(bprm->cred, current->files);
> +}

Moving this call changes what the resulting AVC denial records contain.
Denials from flush_unauthorized_files() go through match_file() ->
file_has_perm() -> avc_has_perm() and are formatted by
dump_common_audit_data(), which logs the program name from current->comm:

    audit_log_format(ab, " pid=%d comm=", task_tgid_nr(current));
    audit_log_untrustedstring(ab, get_task_comm(comm, current));

Previously this ran from selinux_bprm_committing_creds() in
begin_new_exec(), after __set_task_comm(me, kbasename(bprm->filename), true),
so the record carried the new program's comm together with the new
scontext.

The new hook is called right after close_cloexec_files(), well before
__set_task_comm(), so a denial for a revoked fd or controlling tty now
reports the pre-exec comm (for a fork+exec, the parent's name such as "sh")
while scontext is already the new domain.

Is this change in the logged comm intended?  The commit message does not
mention it.  If it is acceptable, could it be noted in the changelog?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45508356147
--===============4896982406480640730==--

