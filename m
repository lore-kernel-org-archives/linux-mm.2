Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E753D37E3A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C637B6B0089; Wed, 14 Jan 2026 09:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38F06B008C; Wed, 14 Jan 2026 09:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A656B0093; Wed, 14 Jan 2026 09:14:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A02186B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:14:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 608511AE214
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:14:30 +0000 (UTC)
X-FDA: 84330764700.26.9026156
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7573B120006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:14:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aePCoea8;
	spf=pass (imf29.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768400068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXI/JsxBbKF9LcEy7WQN83dkdhDN53l6d1BjVlfpBx8=;
	b=jq1gZPnJlb7lJdVnMDFy3z/B1TVTLE/WQHT8VZ+pTInzuvahy/rh2ZFjEgNDAdvCGd/Fkt
	nXOz1oK4Cr8JCiGHTdHFU7Hmz1RIf9BMdOppwVuxB3OieIMnTFbC10MYYG4IWuN0qT0WHV
	UHOzX310XczBDwAdJFVhZmbm//T6+I4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aePCoea8;
	spf=pass (imf29.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768400068; a=rsa-sha256;
	cv=none;
	b=cucW2xpPSLKu8PCCym5gAKzego7F0Lg3RonzxXbINyJzXenStetPgZKGMFOoCd21agxtlK
	CSZNi1xlpN3+buuhfPwpbDwZ8i5nynbEdIa3oIcNcWqZVCzoLdIoggigJXtuOR2E95vqIZ
	g0fIvaKkVVtufjqjaKGGaRPZdbkewRc=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so12669070a12.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768400067; x=1769004867; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXI/JsxBbKF9LcEy7WQN83dkdhDN53l6d1BjVlfpBx8=;
        b=aePCoea8acruTkm31ncWl+V2TtQIBukZt2GHc3Jcu4qShFZaJhodpTC0KZHCS0HCwj
         RxfXMSerBEFBc1v32do8fcwHcGagcY/POPH4w8F+e+FMYSl81biR3qY7K5izqmqyE+fP
         al7qMsH4T38UQEoLyNetw4Qj3USrg/fv3CjRmzSrzsPY33ES4h93g1TlgItyvnLnUfTv
         4wTUllUcm6BTlTwmx4/Hp63u97eKEAB6E2dGohRwNIquIHnD+NDSWnsIv86mL9aOWeI9
         KhFI28M1KsiXBbpojdXOaMWZsjUWU/1vUA7Z/YK8iRAG8foRR2wVfXb7mVaSX0xYm79N
         8SSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768400067; x=1769004867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LXI/JsxBbKF9LcEy7WQN83dkdhDN53l6d1BjVlfpBx8=;
        b=m2czP32v3bWFKf+ur+k+HXdsDdIKj4x/6h3cXoKgiyLrrhkWz10TxLVkjuydioOom9
         lMoGv+5eWbMBu9rCXJ4Y83z8B2jveinFc5eQPGSZBiTkXI72SvA7aUc9xlwk3JM6DLdO
         mw0IUhs9w2IktJX2AZfcT/4iZNoWzdknqh40BjIhBdfQFtCaaRrkmyRcjFGI3fpCQP53
         L+6jR8IP26fxfWRMhm8y7shUy1mZ5rKmAw/nowJ1G3dBFY3duS61otb//6vpr9uvULzR
         AmUeWrb4Jj8PRz+IXYIHOBWB+eYh3RKgBpdrZSi+ldO2QzklDg/zssc108oG78JrNnX3
         6cAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8cKRygbHmU+nwOw+kYumR2uSaTl9b9IRT3U1lSPDliwU3+R5VhcbCz+YBY3CKCVF74rn3yF7hqA==@kvack.org
X-Gm-Message-State: AOJu0Yzc7DZMKcpKYxq2HF6x0fUPp6NKRGqpwMvjATWgh32T+Homq9lc
	qIuRGRF3iqNDUAyX7sFmS7l3vON+lrFer+afxneOM/RITdXGTBa4bjNJeP26bLxsGaXXyXPY+Hl
	4RezbxCBlNV6UO7STY9fU/m6Sg5QoPSk=
X-Gm-Gg: AY/fxX7mKmj22/YwXMBjBUeAhH0Rb7NPPc5SBM5a5p4q0SJhziz4ktMMTN2KSpBdfIj
	qniDerxUNsqMayT6cqwPDjQn3SGaWmNwDrjadw7GgvE8Qomwn8nvxz0kWGbCmRXu2WbfpasXWgf
	mobt4539N6c/Ghko+c8gAA4+tl2Z03NwGY4vLbyXNxpN4Rq28yYShOoltCE2xuBy7lM2Lhr2Ci7
	B1N/T59h2kR8ngcurBeqfwmPGyhaLg5H1kOf0eRfXvjWczscpb17V7+I3ZV86s69LAiMWcsQrW+
	fJTuP8b2HBne8UsIsoeiiSxsIjpOHg==
X-Received: by 2002:a05:6402:210c:b0:64b:42a6:3946 with SMTP id
 4fb4d7f45d1cf-653ec10b2c1mr2391600a12.7.1768400066360; Wed, 14 Jan 2026
 06:14:26 -0800 (PST)
MIME-Version: 1.0
References: <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
 <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
 <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com> <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner> <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
 <aWc3mwBNs8LNFN4W@infradead.org> <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
 <aWeUv2UUJ_NdgozS@infradead.org> <c40862cd65a059ad45fa88f5473722ea5c5f70a5.camel@kernel.org>
In-Reply-To: <c40862cd65a059ad45fa88f5473722ea5c5f70a5.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 14 Jan 2026 15:14:13 +0100
X-Gm-Features: AZwV_QgcgdaBnds1gv_V4-TD2P8OEmx8uWYCKQoKmrAoITMmwNZxXsYhEeLI48A
Message-ID: <CAOQ4uxhDwR7dteLaqURX+9CooGM1hA7PL6KnVmSwX11ZdKxZTA@mail.gmail.com>
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Alexander Aring <alex.aring@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	gfs2@lists.linux.dev, linux-doc@vger.kernel.org, v9fs@lists.linux.dev, 
	ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7573B120006
X-Stat-Signature: 6nirfucp7jc19adjzzgccfsz5ozxcb7z
X-HE-Tag: 1768400068-396040
X-HE-Meta: U2FsdGVkX19+KjET7qqlPIsM3jwCAtNsihLebD5t/FTuEfeyWLUnD0ECnClJm8ogA7JN2xZr0H7pAErldN50m9AY+eg7kftPb587ZHBAp6so72jqBwotOxyUJl/mh+1zfBpm86a3FhNqZOD+iojcIrtqotEjqfJ/bcFlnM4ULMMl+/aTiukfYYpalLrlbIYH7pitZlgJONdrFWE1pzwPdnFWeJX7bHUrkcDot7TjVv0GQDksDK108Hzzgiy0TfWhorYiJ9WgKp/1boh7Fwxuqy87/lIO7+g8i6dl588dD3kMJmmexeCUKD9UVldVX08F3NyMYHy0nMkpFGigL0hgO6KtWn+1FJbQwxZ2FWPqhEYHNKHpHxT3+IPAAGo7OdvUAzOukN3dmacOJrwqqAj+hbmRpHx4KOIexQtIZPySI8YofAgxFKxswMT9LNbqJpJfoz5TsRqwH+JzmHEQ/LFrfsWNoRRxuumxFjcJjHQccgst6py1ZMAVziVqdfJno60bsTjHRVroS7R6HYmYEDQe2RWXp+fjwKDsXvBpyqrPh24Kvzji6d6j8VY9QUNcthaeln+zaXT4BSF0Mjt0VoGpd3c20jEK6BAOV2VOvhG5C7qmOEGcDdK1ukJpEPc7YXvyWfQbALcvnFC0VBgJfJggL4YJuhRkAn6h2EUafJzQvBfehfbd6Ma18uynKU8Jfd9kIGEQQBQ0pH3OSLctk1hHU5Y79RirzCIHtjDkhf19Wth5nyhVNDGmaorZ5PafeYwXxs+yVVQv7NFbegotvDgiRY572RKqvUEPoLmAsNCgBmZf1PawCNFrbEyyd8orXc8MqBlwCVDN06PnUR+WhmswtVpOAyJG+sVj8IS3qvu0yWlbAjDTJZ7/LamCQ2h32tD579/moNYVf/ksyxk6d3EBC9k+JAJ182t/RUQxRWKe0aaSwTpYZ2mPVx7a1CpIlX3sCVvNsAzie/ylu/VpMY/
 Jkm1tDPk
 1VuUa/5S3LkymdyfxnlZ362qqWlIuEelJAW+RacAWkCplWfzmaGB8FBCSF/ldYhx8d8jx7Y5IpuQWu0z0b/V5m+ce1oKVxeQ67rCTlkqC5itPDhdQyBCB6yPCT5NfNh4muo0IT8zbgTwDT6UxDBQoPEGXzFl/L37/MItopLQHhuSatqePlhZf+VA/yjlxTnGvAuww8lPWK9nuD19h7sD7dfcB6MVFN3XgXIppMnW+IM5otLlTwCYJ6jPOBKhC7r0aeRI/rNykxuEATWRgr/1P2dzazqoKmkh3iFg8s1hYWeUVO7XM0I6k5jGqcrzUfB8oHxXir5OCHZzFWR2SCPP84iWqnzh87z9CsH1+PC47PUb095o/Pq35K3nMQwxXGDcQTDiceiFEK0dkGLzxlqJVvcUqK6/KfhzUexc+jMeEQuQml6Gn33ulq40hVD4S33LnKehnXUeLyjXWasid+3t90JOd/1pFLCuA3H1+pvUxBmzKRaolhfEmoh4Qa+zcPkInN0GVsL+NJlJuKnFshTIWEwChHlFnaE8So8PQx1MdRurkbHoHT+WmczfYDU+aVD9Gs322iPRlXXUBqE6oRBUU2MCdOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 2:41=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Wed, 2026-01-14 at 05:06 -0800, Christoph Hellwig wrote:
> > On Wed, Jan 14, 2026 at 10:34:04AM +0100, Amir Goldstein wrote:
> > > On Wed, Jan 14, 2026 at 7:28=E2=80=AFAM Christoph Hellwig <hch@infrad=
ead.org> wrote:
> > > >
> > > > On Tue, Jan 13, 2026 at 12:06:42PM -0500, Jeff Layton wrote:
> > > > > Fair point, but it's not that hard to conceive of a situation whe=
re
> > > > > someone inadvertantly exports cgroupfs or some similar filesystem=
:
> > > >
> > > > Sure.  But how is this worse than accidentally exporting private da=
ta
> > > > or any other misconfiguration?
> > > >
> > >
> > > My POV is that it is less about security (as your question implies), =
and
> > > more about correctness.
> >
> > I was just replying to Jeff.
> >
> > > The special thing about NFS export, as opposed to, say, ksmbd, is
> > > open by file handle, IOW, the export_operations.
> > >
> > > I perceive this as a very strange and undesired situation when NFS
> > > file handles do not behave as persistent file handles.
> >
> > That is not just very strange, but actually broken (discounting the
> > obscure volatile file handles features not implemented in Linux NFS
> > and NFSD).  And the export ops always worked under the assumption
> > that these file handles are indeed persistent.  If they're not we
> > do have a problem.
> >
> > >
> > > cgroupfs, pidfs, nsfs, all gained open_by_handle_at() capability for
> > > a known reason, which was NOT NFS export.
> > >
> > > If the author of open_by_handle_at() support (i.e. brauner) does not
> > > wish to imply that those fs should be exported to NFS, why object?
> >
> > Because "want to export" is a stupid category.
> >
> > OTOH "NFS exporting doesn't actually properly work because someone
> > overloaded export_ops with different semantics" is a valid category.
> >
>
> cgroupfs definitely doesn't behave as expected when exported via NFS.
> The files aren't readable, at least. I'd also be surprised if the
> filehandles were stable across a reboot, which is sort of necessary for
> proper operation. I didn't test writing, but who knows whether that
> might also just not work, crash the box, or do something else entirely.
>
> I imagine this is the case for all sorts of filesystems like /proc,
> /sys, etc. Those aren't exportable today (to my knowledge), but we're
> growing export_operations across a wide range of fs's these days.
>
> I'd prefer that we require someone to take the deliberate step to say
> "yes, allow nfsd to access this type of filesystem".
>
> > > We could have the opt-in/out of NFS export fixes per EXPORT_OP_
> > > flags and we could even think of allowing admin to make this decision
> > > per vfsmount (e.g. for cgroupfs).
> > >
> > > In any case, I fail to see how objecting to the possibility of NFS ex=
port
> > > opt-out serves anyone.
> >
> > You're still think of it the wrong way.  If we do have file systems
> > that break the original exportfs semantics we need to fix that, and
> > something like a "stable handles" flag will work well for that.  But
> > a totally arbitrary "is exportable" flag is total nonsense.
>

Very well then.
How about EXPORT_OP_PERSISTENT_HANDLES?

This terminology is from the NFS protocol spec and it is also used
to describe the same trait in SMB protocol.

> The problem there is that we very much do want to keep tmpfs
> exportable, but it doesn't have stable handles (per-se).

Thinking out loud -
It would be misguided to declare tmpfs as
EXPORT_OP_PERSISTENT_HANDLES
and regressing exports of tmpfs will surely not go unnoticed.

How about adding an exportfs option "persistent_handles",
use it as default IFF neither options fsid=3D, uuid=3D are used,
so that at least when exporting tmpfs, exportfs -v will show
"no_persistent_handles" explicitly?

Thanks,
Amir.

