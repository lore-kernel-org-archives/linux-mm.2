Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C0D606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QCcCJ8x/
Received: by kanga.kvack.org (Postfix)
	id 9EFAD6B05B1; Thu, 12 Nov 2026 02:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A06C6B05B2; Thu, 12 Nov 2026 02:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A8D6B05B3; Thu, 12 Nov 2026 02:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8506B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:54:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4F2814028F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:54:11 +0000 (UTC)
X-FDA: 85425703902.15.906D25C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 430871C0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:54:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QCcCJ8x/";
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794470050;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srOQgDgWOAX6/I0jdHPGkFLTExl16V3iCD3iaXGFZbc=;
	b=rCD1ebtqSx22wkQCZT5Bjc0Jd48cu4semnKMc4XLUKbLgwELp4BHd5nTXWXw1r6dET05bh
	yV4KUNWz8tbVUWSMS5vZoYfIAQPuIvBc9s6CmHLb0zRryXfzCVa5/I1hXOu1kEE3wuqFnJ
	8+w8tx4YHWt19HMNKYcPQTK+cVnlpDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794470050;
	b=OknGxCmHMdqESAFKNYB3gMCoT9eNXEVia5MPtCzZwypbR/DSqQpmJkBn9isMH9dBeQ9SDD
	TuIijSlNBhCoKSdOpmsEj0l9FvXI5wgr1aTZmuAIx4lGbbgwWZD1wLmcfdF374YfXmnxau
	XaBGyzu9lyFsI1oLQSIooUP9iw1VpmI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QCcCJ8x/";
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91C8041FE2;
	Thu, 12 Nov 2026 07:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5741F00A05;
	Thu, 12 Nov 2026 07:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794470049;
	bh=srOQgDgWOAX6/I0jdHPGkFLTExl16V3iCD3iaXGFZbc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QCcCJ8x/RCBqNneH4WLnogtIy8nJ+mADSpqmiS2iU2yt3Xw6Xs6MXkn82gym9ZfmP
	 SX1G7oQyisadY4glTOtkD1xYymXtm1VcBG5OxSLGm9kQvyKsLhKzECxIra+OnMFcnb
	 pT8kFGSjTdDi89bK1GGi4+LgTX4UTKdcCBZGnRzYKnNHKQlY8w5GLm6HNS56oY+Onk
	 dlXUpnsJiaJPethe3oXSPeKhUNGvEXwPrOJnuRZexggndWle5qryODtfXOcFqFiin0
	 uPZBR12WOn43THE4p+5sdS1b+WNVQwlAxsoZrAe3v+w29UgtSN7RODONuyfCSCRB7i
	 OMeEYVQtST4cQ==
Message-ID: <sashiko-outbox-210639@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] liveupdate: Make failed retrieves distinguishable
 from dropped files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Down" <chris@chrisdown.name>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>
Cc: "Alexander Graf" <graf@amazon.com>, "Baoquan He" <baoquan.he@linux.dev>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <772c150d0a90139a327803cecf087f6865702753.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
 <772c150d0a90139a327803cecf087f6865702753.1794383544.git.chris@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 07:54:08 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 430871C0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: pm6zhzwa13z5m1zajwcas3hkiqrtjm51
X-Rspam-User: 
X-HE-Tag: 1794470050-949818
X-HE-Meta: U2FsdGVkX1/Iyp36Ly5SXd9qHG/JHx1+yvKxp5ZntGEcRRAwJEsrhezfG/vWaWaekpwxDzsXKjX02zaCmLAXAh5X5uOFMKnxyrfSbLCxUdXhu/TwjODOqFlvezdyj9oK+Po0ywe09FrTMkyF2+zPtNH1cIwBk99r5rdE5WLeJnxGEodUeuQkwwMut8FhHOroeMtyoTgRSqhgWObGH0PesAY46WL0klIOTFJ0cESlHgMOvv3Zfjn+OcVgbhYL+H6Xn+SOFYKfSsT2sYLpSBEovOLiyVPW8GfbVujLLMrHG7gxYTm+CgoC65rwpre2WVd3SqzYyKUfqBQDXSM3LHKk3UvBL2CobaKFUe06vxPvhSNqkkQY/+vU8oHIqwQFGGh3rk3VWeWjd+gAxafTURNabapN6pwTo00kojWlefhCZFlOEcQrwt2hippyCSbrATLZS888yGN+oNH8LImjJMPnsH7unnf9pSqMJTqOW/BhPmQdcaethMn1KvhcKCfs8V2bQYGtn7C/nJqMawwnp5SuaQlGO2IthU4Vm3GYZXpRMQi+Eifutvcy8NmqJA+tKoYdr8EFg9NkUStLuBldny0CqhyKumTDh4rPcG/ObTh9S2rgIMyNUCGqdpDndVuVXBzhYD8cFEwxIyKeukRRunZheNpt9I41CamyUau7nH6Hk2dBcpe5WfkGvmCkfbDD99Mk/8m1NrsYB8/ghUcGIB1SyuCReEJKSo+xZqb8iUE6V98s/QhNu2/MXgVFdIJp5gLFtN8EKx3dZtKcUgawnyZfkWNXKZYDTexxaizAyv9CHXKz0TRyVc9aH+4N1Rb8s9pjhwToUr1GlIpM5HXhYXpmvUzQaeYZwZ2Byb3EzLdRRJ9vAGR0mm3shJJPjr/8pQ/o0NKHFJf27w9tBedvXH//cYn7+uAhgYZ5uMvmIjITraKZL6u9k3FYjFfjZJlodOvFjpOe0Nx4m2bJ+KuVo6Z
 Ss26lpog
 zLmXuKd4RYjCpXKaEpBWa90Ajto/ICSCc5J/JC1n69ZvI3NC1IJorkBoLP0doTKtctzMharqtf8/QqqUSHzmTpQlOckIaDkOTx1c+/t0//0b9SW40+CMv3jHpuIyx0o1SC0mC1sJO/Oj8+7vQo4uR6S90R9t3J5e53FKDC0ifaH4qnHO077MlqALehhUnxcKajMq5FU6pxFRXDvdElny2tiVbAL/c8G/+dYUjYGO8uIH0GduJK+7N0izLRYYNz9+stiaDx54p4184D7RUAr0Y0eGH7bfIykifA+qcGCI8vOr2HJ0GlVTVU8Zu0jmpua88BZqOLMjaTmfE5dShAixOECjKzap62bGNB+VkdOWdGyVIcIB62k7qYmX46+c/o5ksPXxmIDDDNa/RYdA/mFUo3lMv1VzFmYrs9M8FWxjsSED9xsjLtkyUI5kCgWBSVyfQX35uH8NXOLHUIHkjhZFdbirZ7ES3rFRgVR+oJaN50XOl6kWhFQJ/9Cq7ieJbXk+ma0/96noYdHde0oM7kl1SCewSyWrpPZzGLwb67FXHbheTiAiYDs+rz6TkoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 2 related pre-existing issues it does not
introduce:
- [Critical] liveupdate: uninitialized file pointer in
  luo_session_retrieve_fd() [1]
- [High] liveupdate: pointer used as XArray index in luo_preserve_file()
  [2]
--

commit acd081aa3a5ef33bac09be5e151d1de15512ea3e
Author: Chris Down <chris@chrisdown.name>

liveupdate: Make failed retrieves distinguishable from dropped files

This commit exposes incoming live update deserialization state and session
and file retrieval counters under /sys/class/misc/liveupdate/incoming/.

> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a39992da504fb..3aac1afa05c09 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -543,6 +543,16 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
>  	memset(file_set_ser, 0, sizeof(*file_set_ser));
>  }
> =20
> +/* Record the first retrieve result. A negative status is permanent. */
> +static void luo_file_set_retrieve_status(struct luo_file *luo_file, int =
status)
> +{
> +	luo_file->retrieve_status =3D status;
> +	if (status > 0)
> +		atomic_long_inc(&luo_incoming_stats.files_retrieved);
> +	else
> +		atomic_long_inc(&luo_incoming_stats.files_failed);
> +}
> +
>  /**
>   * luo_retrieve_file - Restores a preserved file from a file_set by its =
token.
>   * @file_set: The file_set from which to retrieve the file.
> @@ -611,7 +621,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, =
u64 token,
>  	err =3D luo_file->fh->ops->retrieve(&args);
>  	if (err) {
>  		/* Keep the error code for later use. */
> -		luo_file->retrieve_status =3D err;
> +		luo_file_set_retrieve_status(luo_file, err);
>  		return err;
>  	}

[Severity: Critical]
This problem wasn't introduced by this patch, but can a positive return from
fh->ops->retrieve() cause luo_session_retrieve_fd() to pass an uninitialized
struct file pointer to fd_install() [1]?

If fh->ops->retrieve() returns a positive value, luo_retrieve_file() returns
without initializing *filep (and luo_file_set_retrieve_status() records it =
as
a retrieved file with status > 0).  luo_session_retrieve_fd() only checks
for negative errors before installing the stack variable into the process
file descriptor table:

kernel/liveupdate/luo_session.c:luo_session_retrieve_fd() {
	...
	struct file *file;
	...
	err =3D luo_retrieve_file(&session->file_set, argp->token, &file);
	mutex_unlock(&session->mutex);
	if (err < 0)
		goto err_put_fd;

	err =3D luo_ucmd_respond(ucmd, sizeof(*argp));
	if (err)
		goto err_put_file;

	fd_install(argp->fd, file);
}

luo_ioctl_retrieve_session() has the same pattern with luo_session_retrieve=
().
Any subsequent syscall on the installed fd dereferences the uninitialized
stack pointer.

> @@ -624,7 +634,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, =
u64 token,
>  			  luo_file->file, GFP_KERNEL));
> =20
>  	*filep =3D luo_file->file;
> -	luo_file->retrieve_status =3D 1;
> +	luo_file_set_retrieve_status(luo_file, 1);
> =20
>  	return 0;
>  }

[Severity: High]
This problem wasn't introduced by this patch, but why does
luo_preserved_files use raw kernel pointers from luo_get_id() as XArray
indices [2]?

kernel/liveupdate/luo_file.c:luo_get_id() {
	return fh->ops->get_id ? fh->ops->get_id(file) : (unsigned long)file;
}

Both luo_preserve_file() and luo_retrieve_file() pass luo_get_id() directly
as the index to xa_insert(&luo_preserved_files, ...).  Because XArray is a
radix tree designed for dense small integer indices, indexing it by sparse
64-bit pointer values forces the allocation of up to 11 levels of
intermediate tree nodes per entry, wasting memory and risking OOM.

[1] https://sashiko.dev/#/bug/linux-65e3446e-27d6-4415-82bb-0036dcc7aa0b
[2] https://sashiko.dev/#/bug/linux-80cdb953-2e71-4aca-9067-108b66f83aaa

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794383544.gi=
t.chris@chrisdown.name?part=3D3

