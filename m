Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0475606A336
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEIbKzUz
Received: by kanga.kvack.org (Postfix)
	id 947066B05B5; Sun, 22 Nov 2026 15:28:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CFC46B05B6; Sun, 22 Nov 2026 15:28:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE286B05B7; Sun, 22 Nov 2026 15:28:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 343566B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:28:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EAE6C037B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:23 +0000 (UTC)
X-FDA: 85463892486.08.2745BF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9D1CF40002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XEIbKzUz;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795379301;
	b=qJSxPAouxQLn9TAC4dtviXdIrL2Eri26oj8DkER+H0DRKMxL+3vK+MZwzKlrm06cdujJI7
	qs8PTZlsEfnjqSPxx+QY8+U7lWKB71K7H0N2Hu61ly+Ky3IqemsrJv82R3nxQoH38VWamq
	8VfCztQHSimj/oO2IhCoS0H2y77/Ew8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795379301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hegAlsfKZhGkTRmWASsRIi51iE3yTycidmKuYA20sM=;
	b=VEBf1OiB7RrSEtzd7vuk0Gijzi582OhF4EBH5pD/WBPdqOu8rou6AMyqRMJNSTFCopvjC4
	r+jL8Lc7Oj/xWx1/7DWd00RA9r5WDLq7d3x5DfDqW6dRMFASvL8KTwFweelDFHcMWKM3LH
	nK0R9OM4ORAI3Kwci9pE0sw08PDUL9Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XEIbKzUz;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0549443649;
	Sun, 22 Nov 2026 20:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F59C1F00A3E;
	Sun, 22 Nov 2026 20:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379300;
	bh=7hegAlsfKZhGkTRmWASsRIi51iE3yTycidmKuYA20sM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=XEIbKzUzCQiRB2aZCrqF5hQW2qtt10VuVYBK2N4JJ/ApWzC1L0LdBsmpNL5+eZmL1
	 OdiaZbs0zfoeU6QqofekKjKxfcM/YQQMSHUZal367Ej+w9pNIMB+1hs9gM5ZvIltFL
	 oC6OyVwx+RN+4O/6LDboojpptdkoctQ+IBmLy6OF/gNO6dd6QFSo+j0u8hBjYhbcVr
	 wICJBLBiXqLV9j4oyPONK7UprRaIjuNvC4ElGXMxMIRfhz5h7PcT6C9AdNDeJ4i3jc
	 U51fRTVhFgIhiS+n0m4gXUvYnlx5v/g3p8+luyiPmfWi/0qx9dhG+jVcym6U3Y2C+U
	 bl906gaOALZEw==
Content-Type: multipart/mixed; boundary="===============7729801098175105974=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <1b6e8842feb8995df8e17c6145e3d543e00124f866912e10a952a9609af79112@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-18-jarkko@kernel.org>
References: <20261122193539.3334213-18-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 17/26] fork: Support CLONE_INTO_USERLAND in clone3()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:17 +0000 (UTC)
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9D1CF40002
X-Stat-Signature: c9mc5a1axxcdh7pdewrgibqcjoap4eib
X-Rspam-User:
X-HE-Tag: 1795379301-154907
X-HE-Meta: U2FsdGVkX19s2dc8fLPVb1IsMihT8icD2pzL6oTY/s8HufD42nZswvHmgrhq2swNHdD+lef8uFIsPfGevKvweee4W+qLbpOmRGBKkDcgaGZtxs0vrdKjFqP66eTJQQv8kXGFrABP4PHZrrWP1LXPZ7LAoNQ7CRuM8aQgMCy5vQ+sXxta0Rf90B3SG/LCBB8n+U+f6nLNmM6AQ+49pOGVgQH9QteQl1Q6z73SX/8V7Xb7RGIYSV08yA76Vsh/cOX4SUKaqiNNjjqBph47znLEyHDpAcdlzYYi4sZOF2UdpFpYzZYribek2wyFV8fnUk4YU8/KefUdism7+2mlc2sjxaplcBTj1B/rrbBy4axYzotEbILOckCGpCXoEPxazCzPttCkwi2vG/hHvoLo89G0eNnGaYozlcBabxrMJHtAknGGpu4tfUnIwPcq2FjoSp23FtbLKWr0QdxIWq6IpfMZ0LyUH7ExT7M0H8ChXXsZuuoC1rVi6z5UPcN70tpJhTOr4JmvNFd2U31rdyY3aIF9EQoKkpQ/e+N8TGs6HN5OCWXs4mHNO8zGz2MLuZs0F1ENU2UQXk96D6eAIwvrFGLkWu9VkEGzlEpiiKuVD2IZ4cIsy5f9hSgCxV4Y0kEVTFe4OnxgcSUV+kpH2u+kRthTXUt0/Fjh+T010HH8mmmKq2blLirznU/O44HHHX3kZB8CR8MbpihZkhKWoHsYXCTgg1VhpSoWMMtQOJEhMNX2dsjXpbwegucn6BftgC0pccoxoEQeioLD/XNL0Cek7VVulJ4Dp46v6HWmY8EoH9AQYnYh1STs0RZqEpPp1DJkvALuG3xhP+/SLHTx/oJj2D16QS2So5V/kK+/360Tv4jhuwlpgdUlzZ8i32ukwP6h+IsQjVKnv4mtgve9ClzGkvfCY9dTHNhxOl7zaW9BkyQmlWorzJH/nVuhtUv2dTRck7++f4aWGIAItiBj7J6Ayn3
 5A5XStDo
 2L8rYjs9TD01ESz095j55Ki9PPWOBDkRzDwww6lfarEMxf1n2cVVojre8eHiNfhgUCrm8vMPcaJEglRnBy8zVZBo8TwWKfIBinNPwjv0IWOcR1bkRACGvEqnGPZ1aFMgFJOhDg0TFuPY4H42G+5cgs8Z1R6rAi4EOdlOpSGneKEEGAV+Qm4etM5DJiyj72YtxGZzJDSKCQFCOWOxoQrYfaO/7mO61q0AScsDjVOhTK3+/WXtz8xNh5tsZL+TyI0C68qOtezTRhJzVri/jn9JdygJa73uwqCvUiwsSUc860vzsz9xrNUHgsWNu+byM1uBpdJmKyQUmDAFvG9LN9ZDD4RklHo/ONzVM/i6fxY12t9caVzJSeYkEv0+r4O4eUuyLy+LxjWauY6G77c896DLvhIDCp93UlA56ETpvSZuzrVr1PuRUVtnoj0c/J6QtJnsq/4yJ+URTESgmkKl6qc2T0DXrpKD/gzS06pH1vuPi1kww2hob7rrWUvpSx8TzyiXmtZiJ+dOwveUisMMhQcdovo3ImeDZBqvlwiDW/fwwvcKIT9qC8qy6pa95q6MaFtrpOVeqgUbSxdzQ26VFPHTpkpORhBm+NXk2ZEaew1L12qLTRss6yNzw59HUDNiJ00DiNUMVwEdFbtWJphhaLrzCQhOKnWwGgBTMb06SyQi4yKnsi93oKvCXLFfnecLrg4jMSjf2K0uZ0BI99P4V7ZFiJZ+7UCAso2ls9eRC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7729801098175105974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fork: Support CLONE_INTO_USERLAND in clone3()

TL;DR: In copy_creds() for CLONE_INTO_USERLAND, the dumpable-reset condition
looks redundant with a user namespace change, so the cred_cap_issubset() term
and init_task_exec_state check may be removable. Not a bug.

> diff --git a/kernel/cred.c b/kernel/cred.c
> --- a/kernel/cred.c
> +++ b/kernel/cred.c

[ ... ]

> @@ -251,6 +254,9 @@ struct cred *prepare_exec_creds(void)
>  	return new;
>  }
>  
> +static bool cred_cap_issubset(const struct cred *set,
> +			      const struct cred *subset);
> +

[ ... ]

> @@ -287,6 +294,24 @@ int copy_creds(struct task_struct *p, u64 clone_flags)
>  	if (!new)
>  		return -ENOMEM;
>  
> +	if (userland) {
> +		const struct cred *old = current_cred();
> +
> +		if (new->user_ns != userland->user_ns) {
> +			ret = install_user_ns_cred(new, userland->user_ns);
> +			if (ret < 0)
> +				goto error_put;
> +		}
> +		if (!cred_cap_issubset(old, new) ||
> +		    old->user_ns != new->user_ns) {
> +			struct task_exec_state *exec_state;
> +
> +			exec_state = rcu_dereference_protected(p->exec_state, true);
> +			if (exec_state != &init_task_exec_state)
> +				WRITE_ONCE(exec_state->dumpable, suid_dumpable);
> +		}
> +	}
> +

this isn't a bug, but does the !cred_cap_issubset(old, new) term ever
change the result here?

new is a prepare_creds() copy of current->cred, so there are two cases:

  - same user namespace: install_user_ns_cred() is skipped, the
    capability sets are unchanged, cred_cap_issubset() returns true, and
    old->user_ns != new->user_ns is false, so no reset happens.

  - different user namespace: install_user_ns_cred() switched
    new->user_ns, so old->user_ns != new->user_ns is true regardless of
    cred_cap_issubset().

The condition looks equivalent to old->user_ns != new->user_ns, which is
the same as "install_user_ns_cred() ran".  It reads as if it follows the
commit_creds() rule that skips the reset when old->euid owns the target
namespace, but the reset always happens on a namespace change, which
matches the "dumpability reset to suid_dumpable" text in the kernel/userland.c
documentation comment.

Also, is the exec_state != &init_task_exec_state test ever false on this
path?  For CLONE_INTO_USERLAND, copy_exec_state() runs before copy_creds()
and always takes the task_exec_state_copy() branch, which allocates a fresh
exec_state.

Could the dumpable reset move into the
if (new->user_ns != userland->user_ns) block, which would let the
cred_cap_issubset() forward declaration and the init_task_exec_state test
go away?  If commit_creds()-like semantics were intended instead, then the
old->user_ns != new->user_ns operand and the documentation comment would
need to change.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============7729801098175105974==--

