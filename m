Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1D5D29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53DB6B0292; Mon, 19 Jan 2026 11:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21726B0294; Mon, 19 Jan 2026 11:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9356B0295; Mon, 19 Jan 2026 11:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB7196B0292
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:41:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6576A140110
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:41:33 +0000 (UTC)
X-FDA: 84349279266.05.2C137B9
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5ADA140004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:41:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OS8MArU0;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTdB35vgqJbH8V4J4HP1Mukd5M1Q72aH7//uMfZpgyU=;
	b=TqORHcuF3CzXkimFfensFlar5I1poZ/OH/795VUGBMn19xBTpSq555uzEoT6lpnNHE9vdX
	Vw/ppa808LOSOdVJy58SJ2cHkgFxZOtFC5sGa9pcPPJai0XudmD6RLKJ8sskl9zfztmUIT
	y8AOeDDke3a8/eh1XTo7PsnHgnR6Rf0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768840891; a=rsa-sha256;
	cv=pass;
	b=YYxrC2sO5z4A4JjWHekbnpOTMvof20PhHQ795T5HGBeIB0TeAbnP4X9PkO/mfoQ3c7ptn6
	Q2jwF0F6RdJNJjiND78h8tW4pU3GkGS383HLYGdg0kTQlG7jXJkYrqH2MYLJpoBI4aC54M
	eHYuiforEmLyHS0wArEq7xkQV8DFQkc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OS8MArU0;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64d30dc4ed7so8567425a12.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:41:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768840890; cv=none;
        d=google.com; s=arc-20240605;
        b=ROnAuShK2cRwYssmuR8s2LHlGwrZLGav1o7aLWr/XX7PMq4LPy+vgv0SfrYiZ4LL/o
         P7gSc1sFPDhdWNHCDVLn09wOevZhySWysZMzg+h5VgeG9SvjiJlOuDnegLN4Bn+dRCUn
         mX5Wf5kVJ3YpKHW4bnUmliiugpDjiOQp/SXAyBgFY3yU/oghAldJEI6VE6eoxBamDcd3
         +aQn+ieaJVFyTWO394HRkHpbQf43zCRINYUf3pQHz11vhU7WAGx0ShOp+l3x+FyGTH3/
         Ke5Dn4nZFK2yrjCTWvftR16TWMxbdTUjMFNy8fObMvHYKzUlC1qH+z9cuhGJAs9YouyT
         vxrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fTdB35vgqJbH8V4J4HP1Mukd5M1Q72aH7//uMfZpgyU=;
        fh=HBdQNIbQ+qrXLEl76JckokEu7YTdYzqBxnCLtP8KVVU=;
        b=YBTOO26mLcsLkxtQ2LX72un6bJENlABESIQQkSWWQXq+wGiRhndnFVao987Xh7rHfv
         kmPfmZ5ZJrAYzFIzgmbBIqTJmLTGDUbAogcUtubl7iR/ksu963pjJzznVAMDPnItHbIf
         E03rV/LlxY0PVqPXGKcDrvvU409y0qgmdxhRMAuPPySlv4iwilan5wyemuU9M4/e8uy6
         GvgxmsqCa6pdZ+mwmKpSYudRTyCxHQ+MXSDIVq/1lP9izitnb+92/f1hl4KyL0C6kBHe
         Ym1D5CvBUi9ghJv67y9eZBicUvC9rk6wjWv3XQydH8u2RNQqYXO+XwSJuOor0w+qZFlc
         jtbQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768840890; x=1769445690; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTdB35vgqJbH8V4J4HP1Mukd5M1Q72aH7//uMfZpgyU=;
        b=OS8MArU0hcYhCKUB2j6zQOWRDyIotxZHBiVxyHQmePn8dHOCuYPUBK2KtrerY2S5sk
         lMPGa3RINMFKkOMDq7iEIybkTg+WaP425Fd1VsLb9OFE/LxovPc8IwnXMVNhoToNOZQ5
         xq35ZzYaebfAXTjGzsW+tjW/Pb/h58yBJpksnqJCOhgDgBC/shFn8tjtB/kUdBAgz0HI
         lGLfKB1rAl+Nic02qgHMHpzmuqfEBbmim4Rg8iuBBS+eGWm0ij13FDhkgTglnfOLiCvf
         SIJOcHMxbo/RhjoEx8VtR7WMqTUGqMnsKI2ondqCRqJxtRYJ3rRMdCIhofwfYSwjGFwl
         lusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768840890; x=1769445690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fTdB35vgqJbH8V4J4HP1Mukd5M1Q72aH7//uMfZpgyU=;
        b=AhWW3T+R5yBcy3Jrt341gmBIvur2ANpGvofq8oxWhOVd6GvfU9Z1Wuh7wZBlwVDM8/
         FHuE2TN/yuyt6MzLotJvgBl9s60U0F5fT2a57edGLoAkFrScTlzc1vq/6c0F68pQzD+h
         2c/hoZcnRq7EPBW1xClV0vqhtVSUA6LGcuktPPuOMQLBWt5IAYE/XZNtTaUo01ZIJpl7
         tq2NTtA0bC0uQFxgQVEJh0kojs6Chzw+Sq6u26LI0GSTbYeBc26rcVoQAcm5BtlE9hQf
         0yJx8zbFeUWGINiWBptx15p0q5XMRmSqhG5mFI4E2NbMJjXpKR+Pr+x6zvHlPRx7uxKP
         YvwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDB1YVGE5L99q46owcjkvoWhWnItYK9rKs0Sp4dvgKdWBLaWLKkIYNXxY4AoLwmuQOXGE++vCOTA==@kvack.org
X-Gm-Message-State: AOJu0YxfLqerUXWwSZmuqWtCWQufZgFX/RPMy4QQYiwy8PI0R2USwymF
	oYmvVLaCJt4e9e/FE64KdQsgl8V2b/VU2nY5CUSC5rz7oA7iN8g/Ujr8chofcXrN5ti6PJ+eXgg
	G5lQx0tTNO8U8QgB/2PfVDI5XWHsEkUE=
X-Gm-Gg: AZuq6aJ0KCKgpYM8S/2B+BxhIXiDNkhWnHrs4JQT737T3FjIi9E+LDFeDpTO1izmP/Z
	B0/+GzPIPynzIoSm0UIfoovopoA7vQt/s3/yS1kB3syVI5bAOkDZ3Xgp6drQU0vQCtfpb4DICTF
	AmR3sx7DpLGoIAhi1X8OUjmUfL5HLOCRt1RrKG1X0/U9ax8+kHYY/2LpJkTZiWn02BWnLMmJ4hK
	bHhCnUa232gGT8GsKSdg5Sb9lcmr2rNDfGLBnJDUPNe7foMpwdLFJgOTlfvwfU09KuPEzdGrn17
	PiN8VYcn8MtMnSHfnqjT5mwtfyRKLg==
X-Received: by 2002:a05:6402:518b:b0:64e:f6e1:e517 with SMTP id
 4fb4d7f45d1cf-65452cd98e9mr9387079a12.32.1768840889299; Mon, 19 Jan 2026
 08:41:29 -0800 (PST)
MIME-Version: 1.0
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org> <20260119-exportfs-nfsd-v2-2-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-2-d93368f903bd@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Jan 2026 17:41:16 +0100
X-Gm-Features: AZwV_QgHvJ6NvIXON-eIYvnT5PkMvN0FHfW-0LujoZ3K-fhpCrZ1N6375iX4_4Y
Message-ID: <CAOQ4uxjX8EcG5XssJ91u8Kn0gY9Rb0qCwnte_7j6Q6knvZ1shw@mail.gmail.com>
Subject: Re: [PATCH v2 02/31] exportfs: add new EXPORT_OP_STABLE_HANDLES flag
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
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
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Laight <david.laight.linux@gmail.com>, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5ADA140004
X-Rspam-User: 
X-Stat-Signature: 4sdnmn3xa1m4kw3m7mn5nntidms5bnfj
X-HE-Tag: 1768840891-532068
X-HE-Meta: U2FsdGVkX1+fIaoPg7HzDXMNHcN5+Jfk29kSKjpAJWj671xUcr7BaK71ygDvRiw1qKNTtLsNZiynYME+LDBMckYy5bbkv0dYCueSmTm5P2cvFuOzPNlwc+j0qgz6ianfiURD/9rwqRwDbFWNvtbWlDgCGh193aRz802fKk5jXrO7aJKNeRInZywq9dM9aJTfk1f4RfCcnk9+7gloGItJYhiWFLhqQwG5j32xF/5/xQcE74+p4MfDn42LmsPCJKZJX7hkeV+/XJOBXNCltKa1vXyqiUmwWiSt75crFjAUjP/MWov1EqK2Q07FBZ+dp+pQf0zwx7LSbcsYVF6AizjP3cCo3YHJezObOy4X3oLU/nIqjCUuXePReCpsmIEVIROT9hgf9h6kYnNFuGiCGK0T4XhrCz3S0oz18vzUtfxjbIlemI6zN1Q68a+QgEmr48j/mr9gCN+nmcbAfgqigEMqzQ1yzzEcIqzrglWPPzxfIIX29zp5LelnCNEd3ba7mEt0sE7EzTexCUHZXlzHAej3UqoagLqTzqaUJYpsCuosItKYHaifflowsE0GFdKR4hZaSlG67Vr3BtXLptrg8nEfJaY4eBefM8tvg4GR8H1VpvSYPaMUKmZOXq8jY34C5jLLdIm+OQzgIXG59JD6JrSkNuL/BzbFQBPwCrXqpwb3twxIzPSQhLLgYaOijeimGDdcC5JKp7FfzYcz7jWU/fEQnTDRbfTGKQk2+VOXIC6VQIb9cZac+IbeIFq6MIWbb6DXGyWcfWp/z5MFvwslYm8YYecgvefjJjpZqb2HXuPSb+MVj/SYgKbSIUM2hxnY2zpV1ckTW1OOItUpp7zj39Ni/WFqI/35FS5iCmQvsIleK30jOcavSz9l1F5fieRMyhXKz48K+XxS5FiUHgNAWQmmIr1k4X5ma9nh7thNPBnXDkeYsl2XEPeTXrj+8dbdwJJhAWvuG1AVizkIKfJHUz8
 gkOaGD6g
 eNuTKEw4uu0oKLsq9/j3AMgnBTPIas2GGWcOAMJd1UyNfBxwS78FkAoNqEyZfw4ybJ4H4lq6XHzMVlIBxMF6VF8VIMjZyHO7lzonvVVCEuzgPkeXEgHOqfZOJKohiD+XIKvckt0GUX352UltGH9Jtsi3BnfNxZfwdQGpyJOoMQkN5Dt8yad0lC/btKs93WOQC4t5lcNov9QSFXpqfJ4Jst5NtIp5svHg9UCBix89WuVpLwUDrO7RsDP7daLJWW9PGiPK6q3Q2I6gjJCl50VnZ7SLrN3MgLFmjqOPxpUzKLqwjMxfEkfgPON1luRUngupyFwzmkuoCB6FzPs5Ywhdeh3j7hqSCwAzUeJv/FocWYmeKUP8IyY1pQpJP6cDCFLhUEQxcargOC/UKjiUFmtzCbaenE0z7kgDpdsJVrzAx3FTd80woCpPy/2pxrxDHE69o2EaGCkYjAVcIiyhFkEFNvxJ7NQSh2q4TebrGXXSr9pDo0AHO2htn5QnJFioNZgVkX7rqcJir2N/ltn7APppK0o1lOVUYT6Crj42IxDVrnP45xzTeKwUHWZWCBZLjPa5vaYqKMqmygyHaXpbmUjvnhaKIUoYxf/5e4JsSh8qVhv0hAPA+HhCy57AP4O/FDKX54G7UGJeApK6Yl5ApTcowiDhjl6JwqTuJXNP3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 5:27=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> At one time, nfsd could take the presence of struct export_operations to
> be an indicator that a filesystem was exportable via NFS. Since then, a
> lot of filesystems have grown export operations in order to provide
> filehandle support. Some of those (e.g. kernfs, pidfs, and nsfs) are not
> suitable for export via NFS since they lack filehandles that are
> stable across reboot.
>
> Add a new EXPORT_OP_STABLE_HANDLES flag that indicates that the
> filesystem supports perisistent filehandles,

persistent still here?
"...are stable across the lifetime of a file"?

> a requirement for nfs
> export. While in there, switch to the BIT() macro for defining these
> flags.

Maybe you want to move that cleanup to patch 1 along with the
export.rst sync? not a must.

>
> For now, the flag is not checked anywhere. That will come later after
> we've added it to the existing filesystems that need to remain
> exportable.
>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  Documentation/filesystems/nfs/exporting.rst |  7 +++++++
>  include/linux/exportfs.h                    | 16 +++++++++-------
>  2 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/=
filesystems/nfs/exporting.rst
> index 0583a0516b1e3a3e6a10af95ff88506cf02f7df4..0c29ee44e3484cef84d2d3d47=
819acf172d275a3 100644
> --- a/Documentation/filesystems/nfs/exporting.rst
> +++ b/Documentation/filesystems/nfs/exporting.rst
> @@ -244,3 +244,10 @@ following flags are defined:
>      nfsd. A case in point is reexport of NFS itself, which can't be done
>      safely without coordinating the grace period handling. Other cluster=
ed
>      and networked filesystems can be problematic here as well.
> +
> +  EXPORT_OP_STABLE_HANDLES - This filesystem provides filehandles that a=
re
> +    stable across the lifetime of a file. This is a hard requirement for=
 export
> +    via nfsd. Any filesystem that is eligible to be exported via nfsd mu=
st
> +    indicate this guarantee by setting this flag. Most disk-based filesy=
stems
> +    can do this naturally. Pseudofilesystems that are for local reportin=
g and
> +    control (e.g. kernfs, pidfs, nsfs) usually can't support this.
> diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
> index f0cf2714ec52dd942b8f1c455a25702bd7e412b3..c4e0f083290e7e341342cf0b4=
5b58fddda3af65e 100644
> --- a/include/linux/exportfs.h
> +++ b/include/linux/exportfs.h
> @@ -3,6 +3,7 @@
>  #define LINUX_EXPORTFS_H 1
>
>  #include <linux/types.h>
> +#include <linux/bits.h>
>  #include <linux/path.h>
>
>  struct dentry;
> @@ -277,15 +278,16 @@ struct export_operations {
>                              int nr_iomaps, struct iattr *iattr);
>         int (*permission)(struct handle_to_path_ctx *ctx, unsigned int of=
lags);
>         struct file * (*open)(const struct path *path, unsigned int oflag=
s);
> -#define        EXPORT_OP_NOWCC                 (0x1) /* don't collect v3=
 wcc data */
> -#define        EXPORT_OP_NOSUBTREECHK          (0x2) /* no subtree check=
ing */
> -#define        EXPORT_OP_CLOSE_BEFORE_UNLINK   (0x4) /* close files befo=
re unlink */
> -#define EXPORT_OP_REMOTE_FS            (0x8) /* Filesystem is remote */
> -#define EXPORT_OP_NOATOMIC_ATTR                (0x10) /* Filesystem cann=
ot supply
> +#define EXPORT_OP_NOWCC                        BIT(0) /* don't collect v=
3 wcc data */
> +#define EXPORT_OP_NOSUBTREECHK         BIT(1) /* no subtree checking */
> +#define EXPORT_OP_CLOSE_BEFORE_UNLINK  BIT(2) /* close files before unli=
nk */
> +#define EXPORT_OP_REMOTE_FS            BIT(3) /* Filesystem is remote */
> +#define EXPORT_OP_NOATOMIC_ATTR                BIT(4) /* Filesystem cann=
ot supply
>                                                   atomic attribute update=
s
>                                                 */
> -#define EXPORT_OP_FLUSH_ON_CLOSE       (0x20) /* fs flushes file data on=
 close */
> -#define EXPORT_OP_NOLOCKS              (0x40) /* no file locking support=
 */
> +#define EXPORT_OP_FLUSH_ON_CLOSE       BIT(5) /* fs flushes file data on=
 close */
> +#define EXPORT_OP_NOLOCKS              BIT(6) /* no file locking support=
 */
> +#define EXPORT_OP_STABLE_HANDLES       BIT(7) /* fhs are stable across r=
eboot */
>         unsigned long   flags;
>  };
>
>
> --
> 2.52.0
>

