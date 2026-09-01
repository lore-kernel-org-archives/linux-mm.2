Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43137C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380E16B00A7; Tue,  1 Sep 2026 04:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358796B00B4; Tue,  1 Sep 2026 04:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E446B00B7; Tue,  1 Sep 2026 04:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 079816B00A7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:56:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CC8AA02DB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:56:25 +0000 (UTC)
X-FDA: 85164587130.26.5BB5663
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 88184C000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:56:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SmFACr0S;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788252983;
	b=P17Jcdj0GvnecO5zXfQ2Y6a4h78rlX9R1vXCTyiJRx4gprHsJoJn29rMadDWwCGLipNZlz
	ZgS8+zMWC5k7Fvabyhuhr6NEAF3RMXVxFF8ZdbHcvoEZfEgDCvebNSmk5wNE6id/twI/F8
	w9I1+rOEL98m82+Kd8q8dVqBVAt0AkA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SmFACr0S;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0cVoKLvyKRi4arSpTI3Loc6vRV6gV/RZyzB2+ewkXs=;
	b=sVAWkpWdVhFcnnXkUxEnLBBEnUX5DXd9BisvZYCRYqIhE10CAI/jRARVz8j/p8+aiFVS2N
	sqUg+1ioywQzi5rKtKwP7OvSfQDkUFrpkNWpnWj3yEMVXO0ND7CcK+jgSYyulyRDdjqtvD
	jOgy7CJPdafwtGeqW+XThm4qQ1v5QXs=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66e5e33a9d0so964533d50.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:56:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788252982; cv=none;
        d=google.com; s=arc-20260327;
        b=l1AWFjDR209py6i1+PGj9EF2gYyUMwNBoo7I9Tws+ZljPc0OdYUNk7V45kqs06w9LV
         O01J9AqLmFNRkKgzBJZR48m0eZ4AWtwlZOegsnk9AkyBhp7Md+XO8Odl/XWL/euIJd/F
         oFmRG5pqrimt6pvtUM6FfWluUr0yAjb6X/V6js5htXjNMxdolQc5mlURju/2rUtMeA4g
         sBEy2ykdEy8vtGUPHxgOd+DKx/lQKdaUJBrjxqOIlkTvjOMT2F5CrMTPie9KnUSlxQ/j
         3cBNeObZ1OA1yfSZInywXnlDz2sji1bvnGmQqwZQFYGermVqjGw08BX/0ftCs0rrk3rr
         ZPPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b0cVoKLvyKRi4arSpTI3Loc6vRV6gV/RZyzB2+ewkXs=;
        fh=5JuOlmeVarfmGO6EYS5WzLjKwTAmlGz6XKECYaHuS4U=;
        b=IfG+Ss54c7VfokaRCfao77G4jZ6JA3LBWCtbwekVjFo7x1MdXlPd3gkZRQCQMQAZIs
         FuDYQpsG3IRPGtpFj7+1CgmOc90qX8d7o7pc8UaTgy5YTqwjo8UOOBnnKWur+F64CBLe
         6I7d992KsR5IFx7Kr6ZEit0N55C/wulJboTggbd2SgV9vYKpwVJGZZPXz16fHqiTVvv3
         PmLxjgD3QEzbXRIgbQbD5g3EIJj8+Jz0PA7grxqnL2pLKqa79EOauRuJQy87fgJbf6wF
         rXYY5+9/ktmd6jPw+1vo/7jgMizHrJ21EYeHZfqnYl5vhaV/vEFY3XuMyc2C/IyzoKNE
         Peww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788252982; x=1788857782; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b0cVoKLvyKRi4arSpTI3Loc6vRV6gV/RZyzB2+ewkXs=;
        b=SmFACr0SP9QMneArokDhpoO9bsIo3cp3gOIS4dyw/u5y3LJEkWEwzcCb+SLt1tLSyb
         4Cdc9GO1rXa1PzrXRQ0VXlxwiRDl2lWV2++zyDb5F7C/YRkHecQdZsBeL6jHBxBlKxuf
         2zlKP3jfpvYT992nxQjAQF9mMeUq2OU9lzGQcQQlqczWaxxC3SFZu2tQHEKydUYeNfaE
         hC5Ci6s8y7l86nwYKisIu2ysngI9y2g5ekERmPqYHwPBAtJuLeh8bD0wduzxzfDEWU/D
         anMM5MfBMo1aoWaxHm5AKxk4IpBpTFYuhXfoGVIcRzaa3TxXT7QORvkwkWwhuw8m8tqa
         qQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788252982; x=1788857782;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b0cVoKLvyKRi4arSpTI3Loc6vRV6gV/RZyzB2+ewkXs=;
        b=fcdwX1NV7+M3lRi6JfbkJBKGRFQPzwzEMgap4GjEji5Lp/lNiAI5X26BR5jmgLdyTa
         HJzZujZO0lZv+fjW8Y+jR2aVFM62Fd+fIsp0B6dhm9TPMdUlJchTbVhV0fBELF8Qrduq
         5DD+zar36xmRM6WbY44HxFrqbWp0BrhQar5cCmOOJE3yv8BwKSTC4ymV25zCrAz62RlJ
         tJN5qOraMyTeqj66r6UKVmBiggX1Wemh39srSGiKX+sOsS1WMUr7BWMfyJRZ6efgcBS1
         eJFuE46K1QkqjInLkZLXJUdqY0L3QfHhsIsffWrLXbn2OqNzs/xY0y/pCTthgWXmDdWB
         cdvQ==
X-Forwarded-Encrypted: i=1; AKwUvBxwJ7KQSC6AXvUCpYc7SYfdM4ZYhPDrSSXdwnX+btQ/Sl8QAeMjCvTbGvk7vYP5HDPxBPazjlHW2Q==@kvack.org
X-Gm-Message-State: AFuF++msWNM7XB9fpaA7qnaRMNkQk9CEAkQn2MgKH+P5na00FHwMtGr1
	0QPL2svRB/xs2fhW9CDM5OWdcEnpP99XNznDHQtDWQ3nbnbY/8ew3Mesih0EDyHWWXfiFzg1sy/
	0tQ6XsfYQwtIZ63C+LLOIRFRKGHSD/os=
X-Gm-Gg: AYBFou1MSCJVv/nvoVHbr4miVlpybtO7bPfwy47RiAxWwZJn/0Ds4RrU2U3TJ1myKpU
	jdNXNlVPIDQWsoJgfh7VYw2vuk2xClkujon4zsS5hANjWjIWREM2MET+b4RqcVWtR4YqfWGN5mP
	uwjP92FJ5mpQ1kkV0FP+1XzZg/ytOpaH8uD53ZLRw4KgxZOGWVuU++OBch2/EMfrufItEEYiugs
	r59u4+pTsiPob7d7GB8r86lOTMTtjSS0jpO57YiSAybnYQ693XyVX1YBUWVG8iihWuj/anjTlzC
	TeKH2EKt5YrXCqWvHoliZi1N7V/rWHihdtZdTbSgz4BYTez9N4HJvKmHTAtIDqRwzt9qcukAVCe
	lVGYWtc0BGMjSnB8coCQbx2M=
X-Received: by 2002:a53:d7c1:0:b0:66c:85e3:7f28 with SMTP id
 956f58d0204a3-66e4c7cb058mr7321594d50.48.1788252982426; Tue, 01 Sep 2026
 01:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com> <20260831092305.42062-4-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260831092305.42062-4-tasos.papagiannnis@gmail.com>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Tue, 1 Sep 2026 16:56:17 +0800
X-Gm-Features: AcwNN1XIzpApr53ZwDAkoriLyAfCiPBC9rJXu6HlLdHYqQbCNPiAd7kuMexr5Xk
Message-ID: <CABFUUZHEJ0Bbu9QvT3AVkxAY=kgFzSA6fDj0hOwgQJ==bEaA=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/7] exec: Clear bprm->mm before dropping its reference
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, 
	kpsingh@kernel.org, matt@bobrowski.net, song@kernel.org, 
	utilityemal77@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88184C000B
X-Stat-Signature: 5dm1jx8tpwcpa4dbfch8cn3xgrcxzsr6
X-Rspam-User: 
X-HE-Tag: 1788252983-388849
X-HE-Meta: U2FsdGVkX1/mVorGBYHgp6sPjrQsYmbFp3NbTcyKM7Fw0YjNeOq05UFKCMZvdmHwBpgD9vcDcx3GKu2okp5XmYaDctSNoBasH+9SHlYFBt+AAimboD5+1/w3e3GhTH9rfWPiLyupZGtGR8ifQ8CuiQhwspMmMwdUEsJ4DOR+vNpZN77KUzw5bGIkRFZ41ev6bBcxcLIoSWVVbC8SS+F6TQ+KZYgAVKvcduIM7Uc67nxRMBjZ0g1Uejj1YEO3asmPsCAlzzDxPogtQCKzSTFlGWR69CVHX6vKxXxerceqIZ6jaF6ORGgbL3lcdsQ13kZOxIGeR1d8zrDlxRS41QL07IBHPyV8Iun27+4sazjXAB8cg7lZStxnzsrwWu+u7vdP31AKoQkfl5wl6i4IrHafWR/vJr3isWsVN3DD8dJzwGD5RNzpSZX9iF4L0Abe9bXntQQS8fv5KErU8pIQE2RIv7oAGyLSWxDfS8//0NsUhe92Oc66A27eQ1dSRM9YKgBdIKf3Ili7LuVI/XBx7CnHG6JOrrKvyu1o9/ET9AoK4iGD/DGRsvfz+m4oY90Ak0THOXfn8zBVvecY77sfo+F5MZKeqNNlvX8PVn6j+1LD6aPq5zmYnA+kEqUr20mSjXq1Cv6OV0gjNxKrA9uDPdzKM4Rxm0FGKEUuysHV+zBRWt46bnATyy/IF4lC1oqOvEeUmIvxNlJ8JJkVRwTnlIkTuXwtDmfknznoqZTzphnlaOqJ03Z6Lq0hjYcMUdFJ58l79cRjE6jmFLSmSYx0hzOdOLqu8oK+bDh7eoVh/kr1AKojEywKO3LzHvcn3HZYb0eRAMkajl5tp424fRv/9ZeTx8obi2FwkD2vRLvVTieqQBV9o8gr87uNxgMRE2ut5RRN5sJ2sCl8IwlxSTsBpnHNY/bjULatDuc2jyqBUODgsS2F0U6oLm2/V+uY+dDj8aZlujAe8nKkfnUdEGF6KhR
 pIMi9WZ7
 R/mHhNB14YzYoiJ0J3LPEXMDbAYZiLyt0KF7MfaX4quJCjj2rqkBMwRVj/NQoeGuEUddJIeA/fqlHxLoLo//YHnkCsMc1n2XWkq2uYNIQUZ26A+BLpkipSG9nrdI7F604+KBc/SmcydY5J4exGNsYnwkmIeiidR9t6oKKXwiIAaHiNEm9tB968Y4XBxVSE1IZsDUuCgZzBi69ccWP78IiNzmo0+JhQm6UIbC/XaQqbZQMqC/fXS/f0YDdSawkhBW6CbEdQXPP1zK6D+axln8SfnFkHrYA0TSfnaffadpmA54UMsQetNEwSN3tIBqJQsy3ErhwbPjeUxPRH3MhSGIFMTX70Nxs+jIZv3Kjy5Iu6C/9RTQ33EiKGQeB6CZLiPQIzZtRHkx1lnP4VSsOHA/6+nOvi7C2AApMK3vVgvj4OLfCyj7uhMDNSjNfWWJvef1nlDdpUi5fLNbOrrgo8eP4sgWOwEUAtFXMLmxNtL2nDHYCBBXS5d1nzbH7XfQRFFNDGdu2GoFOuI/YAf7YeqKtZD4nBf8rWMuSWqo7grmmLVekPzgyNvRjf2v1fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 5:52=E2=80=AFPM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> Once mmput() drops the final reference to bprm->mm, the pointer must no
> longer remain accessible through struct linux_binprm.
>
> The successful exec path and the bprm initialization error path already
> clear bprm->mm when ownership is transferred or released. Do the same in
> free_bprm() before calling mmput().
>
> This is required for eBPF kfuncs where bprm->mm is either NULL or points
> to a live mm_struct to ensure safe access.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  fs/exec.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index a14f28b15607..4b4d8f0627a7 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1453,9 +1453,12 @@ void bprm_drop_loader(struct linux_binprm *bprm)
>
>  static void free_bprm(struct linux_binprm *bprm)
>  {
> -       if (bprm->mm) {
> +       struct mm_struct *mm =3D bprm->mm;
> +
> +       if (mm) {
>                 acct_arg_size(bprm, 0);
> -               mmput(bprm->mm);
> +               bprm->mm =3D NULL;
> +               mmput(mm);
>         }
>         if (bprm->user_ns)
>                 put_user_ns(bprm->user_ns);
> --
> 2.55.0
>
>

An automated review by Sashiko [1] reported a potential UAF involving
bprm->file. The report identifies a real but narrower lifetime issue.

The specific PF_KTHREAD/delayed-fput scenario is not reachable through
the current in-tree path: kernel_execve() rejects PF_KTHREAD before
alloc_bprm(), and usermode helpers use user_mode_thread(). In
addition, bpf_get_file_xattr() is not available to TRACING/fentry
programs.

However, free_bprm() still drops the reference held by bprm->file
before calling bprm_drop_loader(), which is instrumentable.
linux_binprm->file is marked BTF_TYPE_SAFE_TRUSTED, so a tracing
program attached to bprm_drop_loader() can pass it to the common
bpf_dynptr_from_file() kfunc. Once the reference has been dropped,
bprm->file is an unowned raw pointer; the dynptr retains that pointer
without acquiring a file reference, and later reads dereference
file->f_mapping.

This is independent of the bprm->mm change in this patch. I plan to
send a separate fs/exec patch against the current bpf-next tree for
this issue.

[1] https://sashiko.dev/#/patchset/20260831092305.42062-1-tasos.papagiannni=
s@gmail.com?part=3D3

