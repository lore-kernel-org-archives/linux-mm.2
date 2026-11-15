Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 858C2606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F/8qSbuo
Received: by kanga.kvack.org (Postfix)
	id 8609B6B05B0; Sun, 15 Nov 2026 09:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811386B05B1; Sun, 15 Nov 2026 09:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728A26B05B2; Sun, 15 Nov 2026 09:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53C886B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:37:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8677C0783
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:37:50 +0000 (UTC)
X-FDA: 85437607500.10.9D4F615
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2CCC51C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:37:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F/8qSbuo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aQpD+5wOwFw2m2I7/vgi2Nycby2o3K9U9x+kyRBQZ4=;
	b=kmA7xGLaMF44Vd4IR8y9s4+kPjxyvjYl7YFuKPk1jwfniZ9mr8akbdBH41haoCA+4Etbgc
	Wq9Z/1JarCpslxZmKjkFFKsDiOzuZV6kzcecC4gOVZAwyLtQ/kqV2/VMHZ4RD6KyqaaKe7
	g45srBICBX6+sccSooRsHj/ri5EFIz0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F/8qSbuo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753469;
	b=fPcKvgPcZy9AmNzAmylkdJMfs8TCFoX6I1hOlvsH55YbyJCv8BUA16FuDru/ge2ucsIOHL
	SjdpHZAzU7ugXUq3/wyjwJXodBUnOQHHfFNCFjY+++/VOKmKobpYJ9iOM9+Tjho/SOOdoW
	f4ATwl8kBfnqcm4ck3Wr9I4F0snkieE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 794576242E;
	Sun, 15 Nov 2026 14:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A461F000C5;
	Sun, 15 Nov 2026 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794753468;
	bh=2aQpD+5wOwFw2m2I7/vgi2Nycby2o3K9U9x+kyRBQZ4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=F/8qSbuoGQZGQtgBxIr6B2ueFpU95+7qJMwmm8INX1xDHRlTUaSD8BFdbq4CbOxrR
	 ox1qNccLa8/HK300SOpQmBbk5Qvso5s0ej0nnLzfaw7woW9fsTRsB3fn8XKtg4GZi2
	 mkIHuNrdV77fS3AS7HGyBsRW6r1I1TVsLts0dAY635e5VsCW997Apri30eUILQ8DE8
	 6QT8gY4VS7IF4+z6kjL7VWLQ7z0W25C7ZhfXYsY6RHZAfw5JKq52esd/VilnzZerDm
	 yfh9vV8t3VLyXsXWrgdekBNeTMfP6B4g7EKPziGoUoo9vqTOsFrf/z8rys1tdDFec/
	 iXGUcM50BmJSQ==
Content-Type: multipart/mixed; boundary="===============5766711597295612734=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <9bacf710b101058735f399d44953a18d1630aec3b6b176fe96215cdd2f0eb7ac@mail.kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
Subject: Re: [PATCH 08/13] ipe: handle errors from resolving the real inode
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,amir73il@gmail.com,linux-fsdevel@vger.kernel.org
Cc: chris@chrisdown.name,mszeredi@redhat.com,linux-unionfs@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-integrity@vger.kernel.org,linux-security-module@vger.kernel.org,linux-mm@kvack.org,brauner@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 15 Nov 2026 14:37:46 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2CCC51C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c5i876j8crwox4pofpdywcgrrai171up
X-HE-Tag: 1794753469-128866
X-HE-Meta: U2FsdGVkX18YOrOzi+i0XhtU/ZmQ2ukkGjOmm9hxyrUzWr8GHCmbmaUsPpo9elIQDqfp/wloAEiKmK4t+d5gTHBhV4uc+aKJcfjdo6LWMs4B2ONwEAbIuLXIdBoXaw3Knqph4i88oZ8Wt5/q/X8gaD+XE01HAIG8C6xA3XhB9ubQs1w2uRYGVvBA13ZDQ0DPQ3YlAIqowXXlQHmxRbFrRbkR7QlxpCDfGNBNzRQsOxVPrIfVW8c16RN4s70VFg5HnkEvbFoBFg6SN2PGaHAHevGMrcSW3TMe46rAcyRI0MNN/5qsEvlucR+hA8L2gjTczNWXWsr+dNUdYXxPQ/qbBUn9MdBufus5dNn8B2SQP6erLimSUKNPJvT9X6eJw3xzVY27OT+PNQ1AEdhOZYUBJQkjc20eeChJ437XV3kC7tQRxNK35Xy7XNk/LDuwXOj/3tt9QLzh9uQYPj35qHfRPS/S/PvDPR9ZmtuRDMkwUVMeJrYAR+XUksB1RAuqFBxZI8cKEo0Ss8Y0Hlsk+gDvuovJs05//AiCiAeYqm4tRxd2oC4xOPE95YQDtjcJ8U1vjt/wwKOCkcdV5cNuJCCbfeY0ybxO9zFYK1OQv7xd8JSTw3SfVYmSS4DHd5V30oHVx+0Swa/PlVwn23ktVr+HJBmm2LFnSILgcFdJHHT6HZSUKVPhSmf1Qh13MbQ72Lrw8XwO2jXkdT95BmngeZkyTwwOJF1/bWjGhe8pCtmTxk14798/QMFf0CjNCPD3Fu/xTssyWpTyyhMt9KMXjDJPyLCPNUAhpApKjrBT2DyoZEvsbdL1V8zEwpLNBcJVPqjjuKBqOH1lUWAV387l+NFz8fk6mboafYC7Zy/POL5pLGe+VMaCmO7V4hBwSLSiPtSZ9za6PhpJz7R/x0x9BVhvbg9Xk5F2ww1DJcfWQ3RZAf8O1NnS8Ignj3L0M67p6NmjQani6Z4D/gAChtaUGwr
 l1qYG4oh
 Dd46mDasqfTtgBGbNBwF68rd5mJXLpkvAjJ5nKD+Oqhjg0gNrKGWN/hiVbTjImRN8f0WYnezlBCKqKgmdEciIQOBMVzFlSgO3D9wEuTYbwWymBL2ks2axvgM0c2CYp0P+XF0Evod1NDfD240ol/OdREnSnmXApcXvauXOZE/N0SC9gugdDufv4KjdsR/U1bqEkEcZpEuEMDaCSZa+tAaruUeeIKO4KGuz6NQI990WscvP0EF6AjxNdCS2KW6g6DGVDBpYAd7F8+dcewsRYWLAQx2GsN0Nsrd/ymvckxjqg9BilrfzT0TQczPYJS1vZyca3SE3lZRTWGakkSv/9eqx3cTKgVn5mA/c59z9R04LvQibK5cRlmST7ysUz/S8v6d39XfLkSYoMBVJNBAyDKVUOaA3NqUbTmEOi0ULVcVAcIcGYMoamDNiYaUGyB5LXxzsEmaNJLQfGkyg8PQsIngvGZNHdXq7MDq/pPWsB6qOTtzI5wQc73vrDPgmsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============5766711597295612734==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> ipe: handle errors from resolving the real inode

TL;DR: Behaviour question: the new ipe_evaluate_event() early return for an
unresolvable real inode skips ipe_audit_match(), so enforce-mode -EACCES and
permissive-mode allows may leave no IPE audit record. Should it audit?

> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c

[ ... ]

> @@ -335,6 +339,15 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
>  		return 0;
>  	}
>  
> +	/*
> +	 * Without the inode hosting the data none of the properties of the
> +	 * file can be evaluated. Refuse it unless IPE is permissive.
> +	 */
> +	if (ctx->file_err) {
> +		rcu_read_unlock();
> +		return READ_ONCE(enforce) ? -EACCES : 0;
> +	}
> +

Should this path emit an AUDIT_IPE_ACCESS record?

This early return skips the eval: label, so ipe_audit_match() is never
called.  Every other way ipe_evaluate_event() ends in a denial goes through:

eval:
	ipe_audit_match(ctx, match_type, action, rule);
	rcu_read_unlock();

	if (action == IPE_ACTION_DENY)
		rc = -EACCES;

	if (!READ_ONCE(enforce))
		rc = 0;

With this patch, in permissive mode a file whose data cannot be resolved
returns 0 and leaves no record at all, even though
Documentation/admin-guide/LSM/ipe.rst says that in permissive mode policy
violations are logged.  In enforce mode the -EACCES has no IPE audit record
to explain it.  The commit message says "Permissive mode allows it like any
other denial", but other denials are audited and this one is not.

This path can be reached for an already open file.  ovl_open() verifies
lowerdata and sets OVL_VERIFIED_DIGEST, but a metacopy copy-up clears that
flag (ovl_clear_flag(OVL_VERIFIED_DIGEST, inode) in fs/overlayfs/copy_up.c).
A later mmap(PROT_EXEC) on the open fd then goes:

vm_mmap_pgoff()
  security_mmap_file()
    ipe_mmap_file()
      ipe_build_eval_ctx()
        d_real_data_inode()
          ovl_d_real()
            ovl_verify_lowerdata()
              ovl_maybe_validate_verity()

which can fail with -EINTR from ovl_inode_lock_interruptible() or with an
error from ovl_validate_verity(), setting ctx->file_err.  The IMA patch in
this series (c9952f8fed84) describes the same scenario, and its error path
in ima_collect_measurement() still calls integrity_audit_msg().

Could this set action = IPE_ACTION_DENY with a suitable match type and jump
to eval:, or use a dedicated audit helper that records the error, so that
denials and permissive-mode would-be denials are still logged?  No later
commit in the series touches security/ipe.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43723438893
--===============5766711597295612734==--

