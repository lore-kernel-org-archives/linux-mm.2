Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42202C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A0A6B00E0; Tue, 30 Jun 2026 03:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3315C6B00E1; Tue, 30 Jun 2026 03:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26FA96B00E2; Tue, 30 Jun 2026 03:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7D676B00E0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:55:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CC4040402
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:55:59 +0000 (UTC)
X-FDA: 84935820438.18.5ED4CD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 96344C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:55:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V4CwXk6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782806157;
	b=uLkOkrNtlvOd9sJdPMX7n12kvF2ad3NzsWMuMksrRQqIfvxtBMToeVMoNibwz6I5afG2vq
	xJ2wV9qIe6EwTg3fqk3ci78zYdU75TUlag9KnmicxIYSsqhuMt9NZOAozpOmtkLBxnxwkU
	UH/EH+sPiPc8KUCjCYHu1IWvZ+cGa88=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782806157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2dS4VqRw/Em0OvDV2StfeJ9DlNgRzJR6JUzBHHof/0=;
	b=FFnYxyxmPYJytl8tdjPL1aWm6stlDHSSI400nDtnVNJKCDgHfF6ork0XVKUeWPnQGfuwP8
	1hDqYK+ab6WuT35y+v75ST/mJBiv8uE+TWVmC/3paLODWrM+DVYSwhKqpJhBZEhbpylP1W
	gVE2vptCqb4XdSvEK+LiA69Sc+Mhd3Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V4CwXk6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0A4F41E68;
	Tue, 30 Jun 2026 07:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52031F000E9;
	Tue, 30 Jun 2026 07:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782806156;
	bh=w2dS4VqRw/Em0OvDV2StfeJ9DlNgRzJR6JUzBHHof/0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=V4CwXk6YKnkYyH5J826DwWWvxDBFMYJsBkeZ0jSkUuMCi7MRUOwPXrQIs0ZHNDKTe
	 2ephx8Dr1Na5hqDsI++k6XEZ7iCni7ECvJYyTPYqj3g2lXsipul+IGD/QTusb1vOTm
	 OAqqQxxkgt0xfx9VoWOeskdhoVrsyyJ450FyZnKwxmnnIWvfbkDizSNP3kFvy9Ob+W
	 sLw0QaG9BhNasKCuFOOhQclfgqewrbO1QbkwMCqFsPukzl/hosk5V6ICSYZFcwKbFH
	 5z5sjJV2t/O1coQ0RxG+9M7fpfWNHyh8S9q8n8Sv8Yc5JFX2ToBAYBkY3yLAQsYxUr
	 kntxXfArnl0VA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
In-Reply-To: <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
 <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com>
 <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
 <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner>
 <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
Date: Tue, 30 Jun 2026 09:55:50 +0200
Message-Id: <20260630-tierisch-ehrbaren-errichten-bed402a0a26c@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3948; i=brauner@kernel.org;
 h=from:subject:message-id; bh=akQT6JRfJ1Zkbm0d13uEQPaH8NlEtNJnfMROgJGxvXM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5l3WEHDrovNv1wMy7DPHbGI4bei2/3jc3L9d3/brdP
 qJvp1nYd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk34GR4Ybbp8jPbOuYjn14
 0nyR4VK4ZUDq6amfGTtvldl4p3+yKWH4763BU/ipx7TfP8TdQ8Wx8fuNS5bxvaenzZovVnl2+oo
 gFgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96344C0002
X-Rspam-User: 
X-Stat-Signature: 8xbz4ice1kswwcmk34ucd8z3j6eg9gs9
X-HE-Tag: 1782806157-207500
X-HE-Meta: U2FsdGVkX19PFk9KVVfsOOk5AWxviGIgUNVTINH6ZbVjM4JDrFofb0RmaKz8c5/rJ/S2gzKSWRVYnLqIEgXN2MSke5FCbtzaUvmJyC2MGw+FsXdkI4MbK+R9usIOkpSMHmqsuEP8hAuU9b1wDPC7hDqqMiNLjvV2Av4CypYdmPXZskXfmBxYCirBpJVtVZBzghbrVqKlvG78rqm6zyxnQbyRPPmzkA4ofWEuY1FWDEU+/BKfpjkV9bPxVv/2ktJqUYCTWEfqsgdef8DXlFm/rLJM+Tm9/ACbSJFI+jSjBh9Opq7AOsmG5S9mWiCK8HbRAXidc4MG0BMD0WXuX05tFYh0/tCipA2DKbgDgge7IvxiiN84O1bSNDzJNdF+b1uA67tTZc/dNtK5g28MfDsKpbj5IMTarOYwNk8q41FDRxmRbN/ysdVVn4C102+vjDPmximagONrkME9pS9bVaVlc1CSwyoSOCdq2YsfpyVomlGOjzbGwbnsnfiXoqmvkXLrHLSxvhys9osnXcRjZb3IYOYe4vR+8obtOHd/4ICgrV62ihD4AgLunLvj7lA69+1posq5GfZqtanvi//y09DeIw1EijkMd9k/SIxUl994XXZSbOWSp5Ou4Cs6+nqZL2Gt+Sq+LQ/mOOiGSNN+4zHozBsmKan+QmdUP+qZSfGWmAYpKATUMd5kecaHdIf1+jZCoT6+9Np2YVZCAsMqqg9ynMDjPNMUm8zW8jamr6ldXzhT9l/BlpVmnDx4dsTKsO9boBA+qePh4FrJPjL3NMcnZjjyQ8kNWLzYWl8CN/VFVoGrI2GsfGQMlUn4dFVYuR7HZ1C2A48If9Ulhz1DoHkc5mkfy8Yp/Oa3Do8vXIPHCO0UTkVdCdz33ecx0R7zZsX6fE7WC/L/oPRcnzc0itG099QHykS30xE2r373wbqx58wHdBcN3A0bu3oiye6eMvspsT0vZDgG5ASiFmouQC4
 jH+3BBMy
 GrqcEsnhPAmD4na6eZiSvWkeZXQ54uVypKcgxqnH/HmJuk1vnJrpcNMHbGb17WVo6tLV6SaWka7x9BHeOU5+TVP8VfaEd68eDJ2SfkEd8ezLc075+Dk/YsC9WZwLrechttK0SdAV1Ym+pDBfikcRqZgnqYnZHF24lpiBELB7sPu9Al+Ai4U2UEXntbaellI0sWA31AsNItAktioQqn05F3xmQhJIl2dXMSGhn34OArmJX3b8AP7+75bxkrVJLKlpvag4uIBl6oJMzgT5Cl4nHcg3eFO0IuSaZwEs+dW+pZITzaoPGs97s2/8Z32SEkHhek3I4E02+PDTtJjQU2r7FaYOwHIn0XRdTOQlJxE5bue9U/pgFThc1aTXNJawFIljhJoP1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-26 17:18 +0200, Amir Goldstein wrote:
> On Thu, Jun 25, 2026 at 12:36 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On 2026-06-23 17:34:47+02:00, Amir Goldstein wrote:
> > > On Tue, Jun 23, 2026 at 4:55 PM Pavel Tikhomirov
> > > <ptikhomirov@virtuozzo.com> wrote:
> > >
> > > > On 6/23/26 15:48, Johannes Weiner wrote:
> > > >
> > > > Yes, AFAIU in overlay when we use realfile we should always use it
> > > > with_ovl_creds(), even though I don't think there is anything cred related
> > > > in filemap_cachestat(), I still think we should follow the common pattern
> > > > other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
> > > >
> > > > note: Actually some places get ovl_real_file() and use it without
> > > > with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_read,
> > > > ovl_splice_write. But those look more of an exception than the general
> > > > rule. All other instances use with_ovl_creds().
> > >
> > > Use with_ovl_creds() is a good practice to keep the mental security model,
> > > but it is useless if the security check (can_do_cachestat) is not in the
> > > vfs helper (vfs_cachestat), so please move it there.
> > >
> > > Also it kind of makes more sense to check (flags != 0) in sys_cachestats
> > > before checking permissions.
> > >
> > > > Also there are simingly no other file_operations which return "realfile"
> > > > for further processing, mostly the operation from fsops simply replaces
> > > > general operation with its own logic completely.
> > > >
> > > > Thanks for your review!
> > > >
> > > > ps: Hope overlay maintainers will correctly if I'm getting this wrong.
> > >
> > > I don't think this is wrong per-se, except for can_do_cachestat().
> > >
> > > Just be aware that the real file could change from one cachestat
> > > call to the next (i.e. due to copy up).
> >
> > I'm really grump about adding a new file operation just for a
> > special-sauce system call which is under a CONFIG_* option even. We're
> > not going to set the precedent of piling on custom file operations for a
> > single filesystem everytime someone adds a new system call unless
> > absolutely necessary.
> 
> I had a similar reaction.
> 
> > This looks like it could just use a new helper in
> > fs/backing_file.c that the cachestat thing can call to use the correct
> > file.
> >
> 
> I was considering suggesting this as well.
> Having f_real_file() complement
> 
> but technically, can_do_cachestat() should be checked against
> the overlayfs file/inode AND also against the real file/inode with
> ovl_creds.
> 
> I'd love to be able to provide a backing_file "template" for
> operations, but I don't have a good idea how to do that.
> Do you?

diff --git a/fs/file_table.c b/fs/file_table.c
index c68b8c0a4097..d93059d53e88 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -57,6 +57,8 @@ struct backing_file {
 #ifdef CONFIG_SECURITY
        void *security;
 #endif
+       unsigned int flags;
+       struct cred *backing_cred;
 };

 diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 27cc07738f33..64e07ebc43b0 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -50,6 +50,12 @@ static struct file *ovl_open_realfile(const struct file *file,

                        realfile = backing_file_open(file,
                                                     flags, realpath, current_cred());
+
+                       // Raises ->flags |= BACKING_FILE_CREDS and sets ->creds to ->backing_cred.
+                       backing_file_set_creds(file, ovl_creds(file_inode(file)->i_sb));
+                       // Now add a helper that performs permission checks on
+                       // both creds for that cachestat() thing and returns
+                       // the actual file to operate on.
                }
        }

something like that?


