Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4E4606A8A5
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnZy2toz
Received: by kanga.kvack.org (Postfix)
	id 5FD616B05B1; Mon, 16 Nov 2026 07:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4186B05B3; Mon, 16 Nov 2026 07:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5115E6B05B4; Mon, 16 Nov 2026 07:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7616B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:00:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B545A1408DE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:00:18 +0000 (UTC)
X-FDA: 85440839316.14.80F748F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1378020009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:00:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hnZy2toz;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794830417;
	b=22xsEG3df+LCezTHJ4LgCVpPgEsy8/cKToNKrjt7j1lqzDmmKPBa6QlBpp6w6CyUHeXKPT
	FH/YD26FEdws3VbUF0kNCkv6OVmkMXFENaZ67wcNFeNxGVkVvaz6oZHDFqU9YlhxGlqeID
	0bFG6LyT7EYA5+qgrYcvB1D+mSo1yOc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hnZy2toz;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794830417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gm216H5g8yPIS0hPFinwHy6mVVrhGulY+53WmPc6rN0=;
	b=Cs0ym/3v2C+oF4CdrQoG8XCvC52GkKfdUMlbjcqpxMOXKWWu3kizLs8wYVCodgvvtpuLrX
	CU3rZeZC7+JEjBYAJeodgYIhEqpPgf/gxmDzwBFHYwnVTpEh5ph840y0kEPr6tattsgr/r
	ncYD5yckl/1I/3Qx7nskYZECYZPqgHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86E6662928;
	Mon, 16 Nov 2026 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04FD1F000C4;
	Mon, 16 Nov 2026 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830416;
	bh=gm216H5g8yPIS0hPFinwHy6mVVrhGulY+53WmPc6rN0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=hnZy2tozWrqXpWLl+o5+qP9GJB7maIdtKambAdlwVeTUYSiv1MRn2/JyDHmnbWh9z
	 9WDgZMPWzEFJyZJLu9/wsHqC4IslySPV7y2m6l1l6Pr8NgVibCFxmyKogUiorVMDDs
	 oSUXCyKp79VfkW+5dB+6SUIEC6UIXRKMD5lFDe0TpDOweWXRS/8hWTozfLGQIQW1P3
	 PpqAtsruCxsT/ZGQgn4L2ujm+ycdGpwnf6KZ9ATazwCNfMJ3LvW1RLCzk2tHDAf+iS
	 l45B1JKOto718M05wX+oTkpRye0x56eTuMcf1pJlfnKjWSS9tECKCjPVeZoo9oaT6o
	 l+RQ5GFUaEe7w==
Content-Type: multipart/mixed; boundary="===============5220694122544816000=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <cb28f09c85a473a23f14c9bd6ef135950197c9fbf966c1f7055d791977d29286@mail.kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-38-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-38-8cbbea1cf34f@kernel.org>
Subject: Re: [PATCH RFC v3 38/44] nvmet: refuse files on pseudo filesystems as namespace backing files
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,chris@chrisdown.name,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 16 Nov 2026 12:00:14 +0000 (UTC)
X-Stat-Signature: tuh6tmaysnxx7fm3d6hz761jfzmzjd6q
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1378020009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794830416-878836
X-HE-Meta: U2FsdGVkX19Fa/42FS2sb2dFnJeTPvtQdO9MfC2wFRS6VtM9vD8nuJMpjgiGY2QWB5tEKZ3nYSZrwuszUjFDw7OCh8zpvFwOAxvusUDXSRV6IZrgtviIMOlhzDxM+yENvTOzXTC3Nck3vWgMINf8Y5glGQStlud/NWsXgfmEnvkmg5sNU7Apo1QGfCxcNcU0pBWJMaO4glBkAcPmv+t5t0AMei35jpMRXsQWk0yZMeNJWf/5rFkr4BE89VFB6P1bDPVBn5ekGYvO/ZOsGPyGV9I0hTxQellY3OjUmBffJWD74TuBpfCdMhwnyKyV85qJig/cNBEblj45TChqdWzI88BEIfW/4STGWJTVSBkYTCKgxdwCYdaQk5Cl0J9vGNThthDjFTO99SEgxdihrWoazgCEgU/26fK/SY+xBR07a55qyG/V5gdsf8tEjIKBljIVlJQc0y3UMaLl0jByHUU/cCy9p7hUBX8J9mTodFFz9t6fVs41PuGEkGB4lx6K1olmmbGF00dd0kYi1pBBV6SDh7PxplyuS6Cr6Hr8JrKB6kQaEiDKfhgV/LFlxCek5dZUYh5F0aXhOVXd4kq5Y5uJ9gBjT1bIXoeoIrCEoElE4Npky7nCwY3vVqax96rB9RARq6PLRHtrLgjGXYdQsuWVtD0gt5QlcaiMF8ZwEmO6edfeWcMaAt6DVPxuk9i0BlRJQdlZnLEEBDPZPcYkAY3OCFWi1UzzGrEmNvymyt9ZritjlYuZJ0hVuwFh27KSwCCRwH0KvYPLAHgeXf1xgCzxzC0sD0/UE05WcShxKqh8Tbilq8Ft0P/hTBcR01wPbqF1eyJuu8+Y28oC5P5gM+rbcF2MxtMOriOXpj7z3RuAAO4Qqa8gtq6EfTegQrkDYf4W5cIUiD1QNK2Tvt04yUOmxPXgvsZegbPcDjpjngLSVNXRQfF5RLbmbrm78Q3uF9u2KADxurXEpvENPJiJYF8
 i8zwsO+A
 CznpDfIVNBKk/9JoLMYvE7ERO70PMs5V7QqNvZDo0oLPq5E6Phy5b0xFKu6scvgxLa2uxgJ1duJJSm+8x4GARfoS9iiUxwhlMrkyhPsL3HaOYoAVpR2RJCfBTWwWlHK+4CM5+0Ljj/75sAPye0PvE6WWk4jlIpM2QphEcJs3G8VWlFk4XGxboo7CdyA7GMOdtS17lUzzdaRddcrWzj0XLwzCRR2E2PvSjUYIPQQq4ARMd5A6asBDxogTb3jyp+Q9EosdDP5hgULXm6W40UPEogcJ6BJjGzjq7W6eTq6T7UQlBm0XGcfo2yXiOWl5cSwA2tVPQ3bgawrQJNgm6HzO/nobnfmjG9in0k2Pvuo+3WAwBu7qFPfE51W9I3I5eAL6xWbm35AbP67ILH9zVuXX/TTFDFBU4U6YiCwWdi3O/CvpJGG4zxPne8Q1PBNL7I7hl+iqMsGexX7meNOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============5220694122544816000==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> nvmet: refuse files on pseudo filesystems as namespace backing files

TL;DR: The series may not build: file_check_backing() in fs/read_write.c calls
d_real_data_inode(), which seems undefined anywhere in the tree, so a
prerequisite patch may be missing.

> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,10 +47,9 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		return ret;
>  	}
>  
> -	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
> -		ret = -EINVAL;
> +	ret = file_check_backing(ns->file, FMODE_READ | FMODE_WRITE, S_IFBLK);
> +	if (ret)
>  		goto err;
> -	}

Can this be built?  nvmet_file_ns_enable() now depends on
file_check_backing() from f66083ed0be9, which does:

fs/read_write.c:file_check_backing() {
    ...
	/* Look through stacking filesystems at the inode with the data. */
	real_inode = d_real_data_inode(file->f_path.dentry);
	if (IS_ERR(real_inode))
    ...
}

d_real_data_inode() is not defined or declared anywhere in the tree, and
no commit up to the end of the series adds it.  Only d_real_inode() exists
in include/linux/dcache.h, so fs/read_write.c looks like it fails with an
implicit function declaration.

If d_real_inode() was intended, it does d_inode(d_real(...)) without any
ERR_PTR handling, so the IS_ERR() check would never trigger the error path
the f66083ed0be9 commit message describes.

Is a prerequisite patch adding d_real_data_inode() missing from the series?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43858134663
--===============5220694122544816000==--

