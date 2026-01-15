Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00859D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6181A6B00B7; Thu, 15 Jan 2026 14:14:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE8A6B00BA; Thu, 15 Jan 2026 14:14:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3306B00BD; Thu, 15 Jan 2026 14:14:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37E036B00B7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:14:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAD66160478
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:14:24 +0000 (UTC)
X-FDA: 84335149248.03.11155AA
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id C209F4000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:14:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ru5riX47;
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768504462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpVL1RB5I8PR85y4mxEedr9T/Q0DYVA2jeDelSaqSc8=;
	b=u3ILCX8EobVojNvdkHnW0VNpKtYwJ61Vmp+U74LajLluoVnilstYe4swkjHepOmrgi7PFx
	D2XXNL4+Ih5pGRNhlQSL2mfNp82nOn+TnBubx0YQL+tU7kU4olaKv737A+GjESuKQqtLc3
	T0FwRYekIvY4QyMs8Sh/HuaGqiB++0c=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ru5riX47;
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768504462; a=rsa-sha256;
	cv=pass;
	b=3MBYHunX7fJT6KjBrrxS3DkTdFG0Waz1gP5uPw/1e78FvidYLaIjvRLMjZwjzFN12UHZau
	4BDbmsNUrtjHussjGO3kyfQenmMjFOqsy3txKtze5hrbzr9rYuHBGcygNzRoY5CdkqFYLN
	eda9ZxZb34oWUUDMhHf/TRpChwWLqSM=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so7961055e9.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:14:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768504461; cv=none;
        d=google.com; s=arc-20240605;
        b=Kn8QL97WGG3pWbYiMr159BE7kx4dwg8Fx+uYHMAZgoVVu1ulW/5u7z3flxFYuGcEgY
         IPPr3FTKfF4IKL6+e1+CFOE4lvo9Q8bdLeYtBXWDDrxPUeazmn9y0+att3PRoVZhWacy
         ueYPRcLwPgHTZr+CvvHxXGIfUXocv2MIbE85SlRl0WyRP6aRrSI6UpcUnKoArKWAr2T+
         FMBx76tMKaoFQT+tCrBB7jQ8bzn4TSS2Y1fIdc3OdwUafm2X1x6Xg7Ky6JH2TX0h6TFb
         YuchKdLMU3XfuacAJYqQVtZPlDZ/E93lcIT4ZiFIE3EGCOaTC8/dACZy2VAHyKUbAE+F
         2dNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bpVL1RB5I8PR85y4mxEedr9T/Q0DYVA2jeDelSaqSc8=;
        fh=T/ZR409+g2fHdhCmxtk8sW9VIXieF4rdIx8FoiItaDs=;
        b=KXYIZcDsCoHt7mWd0/obgTJP76jGF0e7SJKmrnzPorDMWw2ryKjK4lqTnsGgGloV3A
         si6bgik6T89mOMrD/0Xknb7BcTjaM5OEuRdCtGopethgeiFLtsH+SWHHq4lywgtrIxNG
         DyV+jqJR2paN5PQwzPUcoyjoSzJBVbxdY90/aI4ec23OsBMfbXP6epTCRVf10XHQTEMn
         s1kGgevBYo+ZPAZhY0FX7Ef5ZgaH1wFfjGmFHZYfstnZzDAso8moBBgkVkXnfzWx1CTi
         nOmqQD8AX7dbu/Z4/m2wvjMTc9Cxe2Pw5n3gQrIwEgCmsObZCVApP/GEwkIXeoTRkSva
         UYQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768504461; x=1769109261; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpVL1RB5I8PR85y4mxEedr9T/Q0DYVA2jeDelSaqSc8=;
        b=Ru5riX47yEiUnV0v8DfSGEqx7/gdC02BPvPrluc9nLwVY5xltTAOxc3ylvOC8x+xnn
         nyA7KSoWGuDFQZ4Ncwn3IRWHfIIBOkS5deZ5AwLsXcSuxEKoWmGyfS8hVs7adoiB4aan
         ZD/LFJKX1q3BmCaHJTfYJCi8NPzoxk6rguXuN/q5G33OW6OxuP7oZK/cgFehpLxdzkzY
         PtKMeCO0s2VwZ94Xr2/efkEmK8VzfYQeQsqfuSHEswZmJBVlEHvC9QhQRxNf7/EYEWcU
         1S5eT5MB1PAX/KFr3VHHoV8nQ54IZ+rUlrnUlFcyWWqEHaoS+Vl4wlKyJhDQcgp8KPgU
         1TPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768504461; x=1769109261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bpVL1RB5I8PR85y4mxEedr9T/Q0DYVA2jeDelSaqSc8=;
        b=wvNzvykz0DBHD2qrYCXjhlhMjwSvhBGTzgd+2Kfp42wZA69f3qT6WZRBW6Mu/Jn84N
         RlRUoi0kv+qyTxqbhvKFxxr0Dt4aQabPiOIsGGzY6v/0KKaE0YjycJgfj1Dwkj79bbLi
         JOwjPW+GNqyNZHsU6J4VVRYPEAvukyP6HecZX47FKM9qrkb6fLmKsGGHC/1DmJYDT9q+
         7wdOoe32tVFHtgJ6FwiEgbRJ3X7nDlCdszHhjwXWXdW2LCr9oaiWmQ8SDssJrmcxOm/p
         sOI+UsjFH62lq2nV8/a+I2z7V4eDMujBvZjG9donb/n4Pog13qhK3Thx9Pjp2IVfrMJc
         svLQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7SJU93FAACcIbT6ffTioPdCVTbFlR0vv5PPkhhlGhrFIcbx2bhfTz79XLIQnNvhn+ioJgx3TX6w==@kvack.org
X-Gm-Message-State: AOJu0YwOsZSetPAINhEeVlcNm6CwcAA5m1mKTjscV/p4ni3pCjsmSFff
	7NXTYK0I0ScBxP1Jl89fema4jzStf7IdHoZDoDcpA6wpZ3V1e+Sf/VmObEbZPNxhK34Zz4WFEeR
	Qxwe1dF/F/T0WazoQKWpCJL0sYS2TJ/k=
X-Gm-Gg: AY/fxX6LAxfvNK2ntqbcTpDR2a1HIbyZsZxR33pdQ1QDjYersrv/IxBsXJ9doWuvbUO
	yFrigPVPmBz4El+r+BMRWLKX35H8nfq7LozIZp3DNCywIahG9d/fQOx15R6a7Mb+q+cklk9QV0G
	bWTT6EyAAzL5DmSO4EKF8caGU11zt6Nm3dlAmpXrCQGbKB/wBVdX7LoEyi+jnCQaybJaai8JQSZ
	O1lHtXwLAwzWKu5N0LamiyP7Dibhm20CA8TrAnjUR97TtvCwyVyj15ibHZ7uf6EqbWnL9cjsKtb
	2geH2Cu0QAfiza0EcGqcp+loKH9rMA==
X-Received: by 2002:a05:600c:5487:b0:46f:d682:3c3d with SMTP id
 5b1f17b1804b1-4801e30d482mr9929055e9.13.1768504460920; Thu, 15 Jan 2026
 11:14:20 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com> <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
In-Reply-To: <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:14:09 +0100
X-Gm-Features: AZwV_QgZJLcC_-bQ-_VIrtnGFnLgmiVjy_ytBB44u2cGVyBOwKNqVyWt_Jfm7Ds
Message-ID: <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C209F4000E
X-Stat-Signature: qi7mjoezyjgu49unoeh6df5ps5q8nu8f
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768504462-634841
X-HE-Meta: U2FsdGVkX1+ywLVDT27LJkdqAC9xptSulGoRwrSWyGmdAaFryogOGhhQAN8XQjzzrV7X5fUP4f9sH+Z6lh6ows2Jih3VtG3tmf1LZ75LxIjgSZCbBhBtftgCJ7q7+aaoDpqAI1phduagejj0xWI+kc0+LdO9KBvNN/aOMYOufNNd9iwN2LJXCnIdEyLVSHpbfF8R5XqD/nkE7f/H6lNtuVtFFriwKEawUxiG8yyILiG3gtBsaG/XuDFUgWsaeJrCPJgu6t17QqqK8brSYfZgHPcQfY1AsIcOIu4vOiU+uAT2NT6Xui5erpOmG+QEHmDxyxtQQXUkzhSmCCPVR0rEq5alOVvckMNZ9iz8t8rAcVoUC+22Bd+33kWtVqaEgmthU10LGVBIDSH0BBHAzB4oX8PVw6RtYwhwMpNf7NAMhQs9nTtFYhYsaiVBLGo8gtzrkD+8Sb3cG2mm96XKXVIepD+xcmt+gbaBvnJz5ohXh9G13bTZrPM6ewTJHlojk9COZlCeJRhKp02ZFNHXkbsj/CI7xIIffhDTKxDz1FWeV8Q3+65WiaLh5fzNlZLGV0KTycnqUkO4UMcgg9BSuljFzhj8dtFymJTq+InwpW+VrEB8So7d80tfVXE/Bmw2N8Wx5kKXYJDu05jAkXZLRrNPKx4ZKVsO5znCiP/0jvIUagCmCamI5rDMFkMQaqJqCnKapPe8AVtDYVubRAFMTc9TtTHv+Y3e2GdrFxGwqtfars5sEtI6sPHnoNhdCZwe0KCYIEQaT2gYMG2MqeqRPdzShdheWG77W2KkhKotN6KzGyfeS2MdqQbCwq8pFXYDK1mpJ4SLsaD6tgr7q29UG04fzxrEFXNmFEM5T1jIov7I9F7RhoJCQJGCvFAMBtSBllIdcn9AZ6rlSHqMlg0tqgXshqZyRbAulIZJQE24hRaYZyGSn6WfNcvAs78EEi5E5QAnD2LUy618v4OJz9e7oQY
 WzUYG9yV
 aocU1n8p++9Kj5OSNzDFMi5UaoD0qxBRwEyK5/OQYAYds77ZiodValvBy9Iu6HI0gBiJM4JsnGBi6t1eI4KUh0FlXHjqdtvri56KqW63W86HuZCMPkSNJtt+7MrP0Cy6M9HlunivY7S9kSGUWtEtplqCPu05PFMHy1EAjimnXvugPPXTfpUqOztvvJqVDWtQWoEmzxl/WSmaGEtFsO1e8NikniLUMuDcUv9NYsi0AQ3NHFIHMbrnCE745CqjOlttOIOCHZo6CZY/YtHKl6ZBrZ5wP0SxZ72OpbOqQ0PQNc5kGUH3ANGqtErehMLe31gIuf1bm8KURs87f35iDN88cZIrCp1zLST0DMdRUeuC++0ulL0Ki7viBLbn04ITFU+wMfzA+CIhAtcyWN2bCg2jW13GS2Y6OpEPoKOh9qbAJuJU+qrtZ3GxR7hH2AmT/zYfPh334KQdDsYMLc/vkUJO8XOxhWAd5C1Os4uco11G73G7a4pY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 7:32=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote:
> > On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org=
> wrote:
> >>
> >> In recent years, a number of filesystems that can't present stable
> >> filehandles have grown struct export_operations. They've mostly done
> >> this for local use-cases (enabling open_by_handle_at() and the like).
> >> Unfortunately, having export_operations is generally sufficient to mak=
e
> >> a filesystem be considered exportable via nfsd, but that requires that
> >> the server present stable filehandles.
> >
> > Where does the term "stable file handles" come from? and what does it m=
ean?
> > Why not "persistent handles", which is described in NFS and SMB specs?
> >
> > Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> > by both Christoph and Christian:
> >
> > https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e=
93c00c@brauner/
> >
> > Am I missing anything?
>
> PERSISTENT generally implies that the file handle is saved on
> persistent storage. This is not true of tmpfs.

That's one way of interpreting "persistent".
Another way is "continuing to exist or occur over a prolonged period."
which works well for tmpfs that is mounted for a long time.

But I am confused, because I went looking for where Jeff said that
you suggested stable file handles and this is what I found that you wrote:

"tmpfs filehandles align quite well with the traditional definition
 of persistent filehandles. tmpfs filehandles live as long as tmpfs files d=
o,
 and that is all that is required to be considered "persistent".

>
> The use of "stable" means that the file handle is stable for
> the life of the file. This /is/ true of tmpfs.

I can live with STABLE_HANDLES I don't mind as much,
I understand what it means, but the definition above is invented,
whereas the term persistent handles is well known and well defined.

Thanks,
Amir.

