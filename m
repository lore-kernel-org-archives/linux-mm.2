Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF09CCD1A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 00:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191388E000E; Mon, 20 Oct 2025 20:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168878E0002; Mon, 20 Oct 2025 20:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5F08E000E; Mon, 20 Oct 2025 20:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDC958E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:14:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A363B1DC767
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:14:21 +0000 (UTC)
X-FDA: 84020199522.03.2F585F9
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD2CF1C0007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:14:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g6nhxJ2b;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761005659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ui8DMzsFY6zqaDaV5/75lTx0Gmwu4XTBa5L7MWqUMxQ=;
	b=QONTu6DpOUmY0IN7nvdvL9php79JLubxYzgKteMlikm8r4nP61j1dIMXeG7+UdXz3YtPc3
	s4BzCzn7zx7tx5BlSpRt43QoLRR1rTJwCxOQWxhpfsDkglbHUK0dXPN4cbHnm33f6GEh4b
	SI+cD97PAqT8JN2aYZsGoSpm00LpY8E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g6nhxJ2b;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761005659; a=rsa-sha256;
	cv=none;
	b=xrzsbtt4YfplOVdh9lipjb1tYBFYpFaHDCiK/IetbSTWQAIKcNqfG2OexkSbL7Z18NlGBu
	fNPQNH7SDG0AWnhTvpV7TITcqFEA7QWCIoZ0GBa2sNzJmIU3Z4MI+If2ekyeIhdiM5axhU
	YJz0iGv7YQ5ysJvr6Uanz7KBI5gEZQQ=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-890521c116fso604517685a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761005659; x=1761610459; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ui8DMzsFY6zqaDaV5/75lTx0Gmwu4XTBa5L7MWqUMxQ=;
        b=g6nhxJ2bGgnPs52+1/jwidNHIDDTu1+cNxksMsX51dr6DtIkW9e38J5ZtEjcChXUy6
         JlK16baWzpGLhOEq6JH+tb3ou+NkboYx0CvG4WuLC5MWiTr93OcdFa7ja4u/+QgJihEm
         jA94PyFYnF2AoYleOO7R5tHm/1nrxm0tENtYCHd2T46fyQRetfM91t9FUrdAsifxke+p
         IrFMrM3BJARL1VSafP7NrGj3fHUN1toY5WkFEVlznw63x4pWETYwvbCJtqlOoqK+kzrs
         0tn9xjxS3PbrHSqQzdZLCZgeq/Vt9EQE8sbJzdO7SBDEhnD8GpALUKPSPxn6g3RMkW7B
         8iQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761005659; x=1761610459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ui8DMzsFY6zqaDaV5/75lTx0Gmwu4XTBa5L7MWqUMxQ=;
        b=d4iEHfb+cbCGhFHNUHzidAfoqH2g0BuQT0vmpSlWi1chy5FEzl5nyjg2THkGn1xXwG
         86k0mWl4svS7DWLqWrQnHCs/azpEbOiNs8QAGdiygBGJnuQAHNzQsLV4fCNRWZj8lWGZ
         gp6oMV2lxe1IdMdQT27DfMJCYp+rgHAJi0MYbBgS9tII3c7aiUIO/NDwVBg8EYe7+vUt
         B0boj5XJ032JOhlYJkH8p5wXiAWbpme5efhB07DCCOo4LaJlLv8zNgcbf4x1J3h9gU12
         zcqbal1D9oOArT9OyXzvfSyz8O91eP2dctP0pgI0NsgLvZT3Si2kQFMLNwL6oMIdEb2J
         W+bA==
X-Forwarded-Encrypted: i=1; AJvYcCUggQql1g0h2FLpCw5ou9tHdvNsQMduWA1iwv8/9Qb3aZFZIM2YbKMRuByir9RYGzqPU4Tr582tRA==@kvack.org
X-Gm-Message-State: AOJu0YzESHhPtU9lTGEladnXeGU55BxXVyl6QcG4JyPtZrQlYCDzKN0Y
	uoeNGeVYqHHVDjQPD8vdz4znBUtiCj63bkiKGqo/Xy7OyWGZzhrN+eFUHiEVYRJNs3t4CeUO/BW
	9dKe/K5n52YR7i9AKG7mX7+DcFaaxMuw=
X-Gm-Gg: ASbGncsZ3HgATHMDTUGCfZP1pdRp/ZZqoLhclGxhjy6/98DX/LDrlDSXos+hB50zvug
	y1urR+xMgYbQgzqf5jTiwiwUmo5bOdCz52e+cqG6kTIYevHhMwM8GGjo+GPjaQG0JXnaI8kmWYP
	XUy4za3irkLut/dAIwIQf9R5W6z5Lwlp68c10kBKhQ25MiuGNaG2oxoonANdXC2Ot8FUQ44HsDT
	zqOoDn/7mWSdJ6GENnC3aOhbTaCWp7ec7gh9xXfKdSRXJHm8NEJC/thxxX+7W2HHskdI2H071hY
	744GVBjTvDRtIIQDn1MVGpW5PbU=
X-Google-Smtp-Source: AGHT+IFbi7roFVVLG3VRbRv2vUoOUhhzYMKWJpmCLVGWc6aaAHXM4zeW9tJOWQsYfgHBUQ85Ghk6YK2OfSr/WKJb5FA=
X-Received: by 2002:ac8:4249:0:b0:4e8:a464:1083 with SMTP id
 d75a77b69052e-4e8a46411a5mr114717011cf.54.1761005658930; Mon, 20 Oct 2025
 17:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <20251003134642.604736-1-bfoster@redhat.com> <20251007-kittel-tiefbau-c3cc06b09439@brauner>
In-Reply-To: <20251007-kittel-tiefbau-c3cc06b09439@brauner>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 20 Oct 2025 17:14:07 -0700
X-Gm-Features: AS18NWBZPYaiU7LDy5QEDqgaPTc4fOwEctpwqOwtUrXF3pD2hGNbq7TTOushC1w
Message-ID: <CAJnrk1Yp-z8U7WjH81Eh3wrvuc5erZ2fUjZZa2urb-OhAe_nig@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] iomap: zero range folio batch support
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, hch@infradead.org, 
	djwong@kernel.org, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD2CF1C0007
X-Stat-Signature: gsgaxgmwxwhyzt6njf7fwkaeuo7bp85j
X-Rspam-User: 
X-HE-Tag: 1761005659-104036
X-HE-Meta: U2FsdGVkX192paD1tkAa2nrksp63WDrJORcb0/EA3nP0m/EwuG5JTvwkkjdyFCW3uATk1JJtMc6/lZ9lA7TbfO+XIgi6JFHSidirE/BNOo++lNtgG+bXB8pkPQly8c+RipIST6WAx4Ctd5o96xSPvlx+ODIIdM/GmWQ83DwcVfiGEIm7Zb/MDtz6CXpk7FbJ6YrqeRoTrhyUaCb24Heo/xiNSBZddVUcep3/z7uM7c7wbnZg9w4BQikxdwsAMXl2v3BBre8md/6MofPeLeg5OmHRz7rghafwcuuCSyzZKvT2fP+DO3+u+YrKEhC0PSwpwHQSyvbwT9/+L5d3Wbw6ixZWTLaJ4vCQrNs5orEEjrpA3rspEAHkWO9tD3ldlYVEqRbdDosbLEhHF2M3sGsTpQMxWsiQDJE+otWN4yF03/EjhcRtUaEzHbMKRGqdoDzR85McfXXY6/ISVbkUiJthd5uJPlQHhYWmJUA3rgmHkFwbEsowjIeNF3bFQdgujQmlxsOQ+a16RIDqqB1sf3KCYrFoa6LzuJcUM1kvlP53KsivVXHiBm4QrKj9zM1Z55VPdgZIR3AveOAPvMjdDkVn8JHXCZqsh6HY4cGFEeyLqR1d4N/ac6PqRosuqFC3zzW2NvcXHHiyCgJ13Y+yobtPGMcXvVyf25iXw0U53RIOzGKq7cEIJA+C/ShdnvsEQ2nsFRxB2rsMarQ6Lefo/A/gvhpAcaHRX8IlHshsnsT0YXPgHd0rpq94O0ydh1GBVUPybVZMvkmf37h1XTf7gBGD+WL1Hrk7vT4bHe6t0Rd6uiZ5TbUDNoiE5oToXhLgSj7TzA6eHIYKMM1nVjP5gaBgvmv/UvDRBMOjZg3xB9AtoMOj3lKgRI/vtVtNqwO2S4fIPooeRdbSH9lXlHipQ5d9LZTz0LVNjUYX6INNbzgmCGMYwBNeSeF5Sb80DzMZqgn/yVhq3vUTN/3cWG7RJ0M
 5aWEY6c2
 XluIjZaGSF5DHBfNyjUex1p3SfnVIjz+Gdr+mxHT0eIQ9O7jHziKi8iBF5VnpHod9wCW3BvxcqaaGFwuHBGa+AsHciLJQsJyHejaIjBsjuL/58vzapqA7++GzkN1+hXkoHXKC5m7KnPMFzLlW/ybZGl6kYAjC+EM/ULr8dbw+4TSqmwZ1dNazXKtPNh+ql4J/3fr53wHZFeZmYg/aZD7z/rgmfr4NGeVOdcMHcyIYoivCgf2lvKkN/45PY0wlESH0kVsWR9jQpVOiQzRy+KThL65CK0YcFlE/FS7YqWvNBkAA9R2pRa8GHOKPwwlTvO5vPkNaBvxVQJe6suYbtVenzhpdGaytvNgJFLG6uEsDti4zHng=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 4:12=E2=80=AFAM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Fri, 03 Oct 2025 09:46:34 -0400, Brian Foster wrote:
> > Only minor changes in v5 to the XFS errortag patch. I've kept the R-b
> > tags because the fundamental logic is the same, but the errortag
> > mechanism has been reworked and so that one needed a rebase (which turn=
s
> > out much simpler). A second look certainly couldn't hurt, but otherwise
> > the associated fstest still works as expected.
> >
> > Note that the force zeroing fstests test has since been merged as
> > xfs/131. Otherwise I still have some followup patches to this work re:
> > the ext4 on iomap work, but it would be nice to move this along before
> > getting too far ahead with that.
> >
> > [...]
>
> Applied to the vfs-6.19.iomap branch of the vfs/vfs.git tree.
> Patches in the vfs-6.19.iomap branch should appear in linux-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-6.19.iomap
>
> [1/7] filemap: add helper to look up dirty folios in a range
>       https://git.kernel.org/vfs/vfs/c/757f5ca76903
> [2/7] iomap: remove pos+len BUG_ON() to after folio lookup
>       https://git.kernel.org/vfs/vfs/c/e027b6ecb710
> [3/7] iomap: optional zero range dirty folio processing
>       https://git.kernel.org/vfs/vfs/c/5a9a21cb7706

Hi Christian,

Thanks for all your work with managing the vfs iomap branch. I noticed
for vfs-6.19.iomap, this series was merged after a prior patch in the
branch that had changed the iomap_iter_advance() interface [1]. As
such for the merging ordering, I think this 3rd patch needs this minor
patch-up to be compatible with the change made in [1], if you're able
to fold this in:

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 72196e5021b1..36ee3290669a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -867,7 +867,8 @@ static int iomap_write_begin(struct iomap_iter *iter,
        if (folio_pos(folio) > iter->pos) {
                len =3D min_t(u64, folio_pos(folio) - iter->pos,
                                 iomap_length(iter));
-               status =3D iomap_iter_advance(iter, &len);
+               status =3D iomap_iter_advance(iter, len);
+               len =3D iomap_length(iter);
                if (status || !len)
                        goto out_unlock;
        }

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1aJf1cgpzmDz0d+8K5gOFBpk5wh=
qPRFsWtQ0M3dpOOJ2Q@mail.gmail.com/T/#u

> [4/7] xfs: always trim mapping to requested range for zero range
>       https://git.kernel.org/vfs/vfs/c/50dc360fa097
> [5/7] xfs: fill dirty folios on zero range of unwritten mappings
>       https://git.kernel.org/vfs/vfs/c/492258e4508a
> [6/7] iomap: remove old partial eof zeroing optimization
>       https://git.kernel.org/vfs/vfs/c/47520b756355
> [7/7] xfs: error tag to force zeroing on debug kernels
>       https://git.kernel.org/vfs/vfs/c/87a5ca9f6c56
>

