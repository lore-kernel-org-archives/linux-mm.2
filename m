Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF68EC1EB2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714E46B0089; Thu,  5 Feb 2026 08:45:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2296B0092; Thu,  5 Feb 2026 08:45:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0A26B0093; Thu,  5 Feb 2026 08:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7BC6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:45:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E35891B285D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:45:45 +0000 (UTC)
X-FDA: 84410525850.24.3FE70E9
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04585120019
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:45:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FGrXsuHi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3BZ-EaQkKCKgITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3BZ-EaQkKCKgITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LAmLG57j8Rj3itBaST86JcST4zg6YUNTubfQVh5YLWw=;
	b=xZAiTEl6RCt1jSuMtqmvOL2IsQ2eyErjf2h5mgC/z4tyKloOZKII+95I8o1289bkPpsNbp
	fieDSRB4lr7sJc/0RSY/RwUedlzlG3UEFERCudaNcL+Qd5kjLta7mO1ERjpLAwxuBUaAxz
	HD55hXur0bEWM4p9r2UljDo1i+5tT18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299144; a=rsa-sha256;
	cv=none;
	b=P5jCmb5Mh/rcBUV89pD9PovvCPlubiEWQHm8/a9WKSBWBDp+XcCc/qgaOvnHegk2xz7enU
	q6heeh0rSTHyWYv44ePqKYLQqoiUEb8eyF3t4MQ4s74lYD8csYt6O+cWReXFPC7zMmxFFA
	x3jvko29kB1IA+U7kMRpHPepNZ168vM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FGrXsuHi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3BZ-EaQkKCKgITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3BZ-EaQkKCKgITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4362197d1easo1049149f8f.2
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 05:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770299142; x=1770903942; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LAmLG57j8Rj3itBaST86JcST4zg6YUNTubfQVh5YLWw=;
        b=FGrXsuHiO509VjGgJZsA9R8oAMUplhykgRuIG7r6XKoVdB6HH5/S72B2l7PsKi2WOT
         Xda6vCOGu4P9ZCjudwOBQ8WhOrMwZ/Yl9rS66JWiS6u260bMHS/o/+7rCJ7xllB8uM5G
         FnaIW5wJVdbZCvY42MAhmZP/rKYxs7+iWW39UWkYN/j/Jb1x+GdLO8e0CA90nCKsFdab
         ZN3nA594vAVVq4MYBr7uCuac7GEz7tHRWhN6Y5MXhSnNzpv7Pfrz90RwaYqPoDIdWFh0
         dUbFeADHccoUuCb8SFAEYoTVodanMDIaSEMRsKW6S9+xcI+iZlqMky1IffPWDr2eIPfZ
         clpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770299142; x=1770903942;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAmLG57j8Rj3itBaST86JcST4zg6YUNTubfQVh5YLWw=;
        b=VvA4ZVmOJxNAMxC85UPNYS0N/K6HGTVvaUh9qcqVZ6mNiTAZkAHxXuPvr/z/oHSGLb
         GW5XNuWgew8vulpHS6Ene1JTxU42BlKuU3ZARNOnK/j+dV0AD9mo9K+JclWSCPxSIod+
         3FAqs5abAndXYkkvZc88K0b4yc0nBXmArc9NfMIYMVWg3vWkwnPhdrA6X3wLRnj/p2hC
         jQ2TF8XuRrU1vHqoiOtMFCE9mNEK/lw3zK93pOIVkskTHNAx26CXc9kCOD9iukP5TOaM
         6n+awkpOTscaJDNsi27+svjGfKq7MRRj1ZjtuT+RY+ayxJ7fTBLBJuwYpyUJ8nLfimsH
         r8Jg==
X-Forwarded-Encrypted: i=1; AJvYcCV0NzMvVt6eyE1R3BJuWHg+yKf83zsmvR7gUdHUjVyu+mypLuQ9m3WHwlOfb4e/s73rbtph6ERHUA==@kvack.org
X-Gm-Message-State: AOJu0YxEQENL816D893CsBNhC6ohVnO2KS6rRdoT2K5ASweAsSi/8tEq
	I01QrF8UwyDlsdAOerant570E1iQWF20X1oD4ynOOoaNb3+JtZWZfU4zRCj3TDed/fHMDMdBA1z
	T/WcG0ndVTWnI1Z5eSg==
X-Received: from wrbfq11.prod.google.com ([2002:a05:6000:2a0b:b0:430:f303:97d3])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4283:b0:431:48f:f78f with SMTP id ffacd0b85a97d-43617e387a3mr8591141f8f.1.1770299141977;
 Thu, 05 Feb 2026 05:45:41 -0800 (PST)
Date: Thu, 5 Feb 2026 13:45:40 +0000
In-Reply-To: <9a037fdf-1a98-437f-8b80-7fdc53d5b0fa@lucifer.local>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-1-dfc947c35d35@google.com> <9d0d6edd-eab4-4f31-9691-78ed48e7ad5b@lucifer.local>
 <aYSCNur71BJJeB2Q@google.com> <9a037fdf-1a98-437f-8b80-7fdc53d5b0fa@lucifer.local>
Message-ID: <aYSfBJA4hR4shPfI@google.com>
Subject: Re: [PATCH 1/5] export file_close_fd and task_work_add
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 04585120019
X-Stat-Signature: fyb36bpagieeomyq3tp5t6ku7jgd7hj8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770299143-381014
X-HE-Meta: U2FsdGVkX19KtslSqCsJfSOTPFUwVY6ZgA4ypPCkTslxKzRf8kjlbcScZDV8kz5QFcMo0RqvZPCaGlEszo1+IWHsgjjvIu3THKzt0x+usfyUtUT2TpyagMGj3G5iPcEHWNhSW+iwpm+RUN3Er0wG3jxFmusXH8Tk99msTvs3exq/NnndmV0BIs/gZfYq5Dzscwfkf/qnHVs83gt5pNNrqHU7jL3GCXvfSqunVcHwhRBlBp5Efs0OnKTBvxZCIRNvVYN3oSwAPoK/3YTCpvJHC0CgYBCk7Ac71aG+YPDKZefvSRP6YS6ekxrb9piM/tPt16HHVk9EOrtLtOvv+nxG/LC0FxwcS9W4snodU9G5W7T6PphA2evZ/Bo8WkO0glrRCJw5I1ousmrmpnOWPUKOO9X0QJ+VOUZoyZMXWh7JwRmT9h5PRXxSyhkRtUI/lH1Q87sy5SzTLNcufXFUHpbgAelHs6shy/O+rXQm3OrJdSZFLF1NcUdAjD5BtVME5fzY+Zv+tMnat5a7J0BLawsGcFrR7eLpbdL8YFgqKwqVsrUPzYLsDAemFLagpB/uy7Rq7KyAtNn4XA7vUfvy0wSSLnTf4k8tAW74j/UH8ZeB7+S8z50Q2sf4YIMDiuXywcqlUTg5D6ynCO7Hu3xT2biUTuvP9qB966uXyXrI7otpCSt5w3cjovr2tPay1wDRlaC5J3s4qkLf1i7+/JJwXMfnPw2GUv37L7ifiaNTTIJy3pKrWpXHtMWZ3Uk5R2mUK/GhhsnUPd6OhbxJo/DaVHlSZGyxkgBQeigVAhcffmUyChVHpqqG2BSVb02MpAKE4vQ1s4EmB0slcqdBO+MOqiSF3KwHxzkKJgrkgEaEsjkFwyl62MBwy5AEt1zLj1ULJgiouo1iCXjUWd5rD6V61YBOx1yXLW8K9Eo96/3KDBgmuy7+kOC/lpaRDVYGkfN/QDZMK8jGuQHaQH0qRakDIfB
 r+Foqal3
 40kbJF2xSFJvsRVnzz4CKZUwBHPyKDQz8qsFUEVq1kCpaMfLQHOjZ410X6f4gUjD0HBDPiCAPn0VHO6HY4QzR/cf9S6XImLjp1yhakHzHSTjXCHJwj4D4ifLJqUvHxbUUcVrzbipfAk0KvzSCgIODeqmllA7rCxmuS5ywfN76SgM2xwyFzZfffhUiU9RlLZSP7Yxrjq5KIKKXzAsYOiJeyWGQMw6Rxsw+otRYSK3DQo3v/mrOEJIf86eXGvnrJZk67BVqvHowAGSEXomg0wuGqGytoi+7vfeKAsNKVn3eM9j8govxx8LxX31Py9qwWfNFxMW6NMgK+YrOwwYN4FNLbjwxPhYevN8KMJ8QB9lSushuWU+fFYbYj5vTzLODaMy38Oc16JCItF/nKKCLEwo8XtpAogtbJPox9rbE9beQgP3xadQXjLPwsAHx41DBaBGqmIdX/DQWnKm+Q3WIiSN8CS4S0AkWCkt6J7VUeeg+gyH1aG8u+6WAUnAopxVM2mJySWhmJ+jpD73q5nfnRIXXIZfaoI0LFpELOX7VxS3SU6y3sZYL4CC55Xv+jp3IchpKH972GGZYBcYmfLosmoYKx2o+XBoJFlqlyaSe6bdQYEA03XbfCYeb4bXDvHSi+1WKyKXODuaqFgcGlFaVEgaBqoFpA+/43v0ud6gM2MPt+jzxhoLA3bLHZBi4JOR59R/gkPzcYmyNtFSwfBeqd3Z2oR3ryQNVhxKjBfKR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 11:53:19AM +0000, Lorenzo Stoakes wrote:
> On Thu, Feb 05, 2026 at 11:42:46AM +0000, Alice Ryhl wrote:
> > On Thu, Feb 05, 2026 at 11:20:33AM +0000, Lorenzo Stoakes wrote:
> > > On Thu, Feb 05, 2026 at 10:51:26AM +0000, Alice Ryhl wrote:
> > > > This exports the functionality needed by Binder to close file
> > > > descriptors.
> > > >
> > > > When you send a fd over Binder, what happens is this:
> > > >
> > > > 1. The sending process turns the fd into a struct file and stores it in
> > > >    the transaction object.
> > > > 2. When the receiving process gets the message, the fd is installed as a
> > > >    fd into the current process.
> > > > 3. When the receiving process is done handling the message, it tells
> > > >    Binder to clean up the transaction. As part of this, fds embedded in
> > > >    the transaction are closed.
> > > >
> > > > Note that it was not always implemented like this. Previously the
> > > > sending process would install the fd directly into the receiving proc in
> > > > step 1, but as discussed previously [1] this is not ideal and has since
> > > > been changed so that fd install happens during receive.
> > > >
> > > > The functions being exported here are for closing the fd in step 3. They
> > > > are required because closing a fd from an ioctl is in general not safe.
> > > > This is to meet the requirements for using fdget(), which is used by the
> > > > ioctl framework code before calling into the driver's implementation of
> > > > the ioctl. Binder works around this with this sequence of operations:
> > > >
> > > > 1. file_close_fd()
> > > > 2. get_file()
> > > > 3. filp_close()
> > > > 4. task_work_add(current, TWA_RESUME)
> > > > 5. <binder returns from ioctl>
> > > > 6. fput()
> > > >
> > > > This ensures that when fput() is called in the task work, the fdget()
> > > > that the ioctl framework code uses has already been fdput(), so if the
> > > > fd being closed happens to be the same fd, then the fd is not closed
> > > > in violation of the fdget() rules.
> > >
> > > I'm not really familiar with this mechanism but you're already talking about
> > > this being a workaround so strikes me the correct thing to do is to find a way
> > > to do this in the kernel sensibly rather than exporting internal implementation
> > > details and doing it in binder.
> >
> > I did previously submit a patch that implemented this logic outside of
> > Binder, but I was advised to move it into Binder.
> 
> Right yeah that's just odd to me, we really do not want to be adding internal
> implementation details to drivers.
> 
> This is based on bitter experience of bugs being caused by drivers abusing every
> interface they get, which is basically exactly what always happens, sadly.
> 
> And out-of-tree is heavily discouraged.
> 
> Also can we use EXPORT_SYMBOL_FOR_MODULES() for anything we do need to export to
> make it explicitly only for binder, perhaps?
> 
> >
> > But I'm happy to submit a patch to extract this logic into some sort of
> > close_fd_safe() method that can be called even if said fd is currently
> > held using fdget().
> 
> Yup, especially given Christian's view on the kernel task export here I think
> that's a more sensible approach.
> 
> But obviously I defer the sensible-ness of this to him as I am but an mm dev :)

Quick sketch of how this would look:

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index adde1e40cccd..6fb7175ff69b 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -64,7 +64,6 @@
 #include <linux/spinlock.h>
 #include <linux/ratelimit.h>
 #include <linux/syscalls.h>
-#include <linux/task_work.h>
 #include <linux/sizes.h>
 #include <linux/ktime.h>
 
@@ -1962,68 +1961,6 @@ static bool binder_validate_fixup(struct binder_proc *proc,
 	return (fixup_offset >= last_min_offset);
 }
 
-/**
- * struct binder_task_work_cb - for deferred close
- *
- * @twork:                callback_head for task work
- * @file:                 file to close
- *
- * Structure to pass task work to be handled after
- * returning from binder_ioctl() via task_work_add().
- */
-struct binder_task_work_cb {
-	struct callback_head twork;
-	struct file *file;
-};
-
-/**
- * binder_do_fd_close() - close list of file descriptors
- * @twork:	callback head for task work
- *
- * It is not safe to call ksys_close() during the binder_ioctl()
- * function if there is a chance that binder's own file descriptor
- * might be closed. This is to meet the requirements for using
- * fdget() (see comments for __fget_light()). Therefore use
- * task_work_add() to schedule the close operation once we have
- * returned from binder_ioctl(). This function is a callback
- * for that mechanism and does the actual ksys_close() on the
- * given file descriptor.
- */
-static void binder_do_fd_close(struct callback_head *twork)
-{
-	struct binder_task_work_cb *twcb = container_of(twork,
-			struct binder_task_work_cb, twork);
-
-	fput(twcb->file);
-	kfree(twcb);
-}
-
-/**
- * binder_deferred_fd_close() - schedule a close for the given file-descriptor
- * @fd:		file-descriptor to close
- *
- * See comments in binder_do_fd_close(). This function is used to schedule
- * a file-descriptor to be closed after returning from binder_ioctl().
- */
-static void binder_deferred_fd_close(int fd)
-{
-	struct binder_task_work_cb *twcb;
-
-	twcb = kzalloc(sizeof(*twcb), GFP_KERNEL);
-	if (!twcb)
-		return;
-	init_task_work(&twcb->twork, binder_do_fd_close);
-	twcb->file = file_close_fd(fd);
-	if (twcb->file) {
-		// pin it until binder_do_fd_close(); see comments there
-		get_file(twcb->file);
-		filp_close(twcb->file, current->files);
-		task_work_add(current, &twcb->twork, TWA_RESUME);
-	} else {
-		kfree(twcb);
-	}
-}
-
 static void binder_transaction_buffer_release(struct binder_proc *proc,
 					      struct binder_thread *thread,
 					      struct binder_buffer *buffer,
@@ -2183,7 +2120,10 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 						offset, sizeof(fd));
 				WARN_ON(err);
 				if (!err) {
-					binder_deferred_fd_close(fd);
+					/*
+					 * Intentionally ignore EBADF errors here.
+					 */
+					close_fd_safe(fd, GFP_KERNEL | __GFP_NOFAIL);
 					/*
 					 * Need to make sure the thread goes
 					 * back to userspace to complete the
diff --git a/fs/file.c b/fs/file.c
index 0a4f3bdb2dec..58e3825e846c 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/close_range.h>
 #include <linux/file_ref.h>
+#include <linux/task_work.h>
 #include <net/sock.h>
 #include <linux/init_task.h>
 
@@ -1525,3 +1526,47 @@ int iterate_fd(struct files_struct *files, unsigned n,
 	return res;
 }
 EXPORT_SYMBOL(iterate_fd);
+
+struct close_fd_safe_task_work {
+	struct callback_head twork;
+	struct file *file;
+};
+
+static void close_fd_safe_callback(struct callback_head *twork)
+{
+	struct close_fd_safe_task_work *twcb = container_of(twork,
+			struct close_fd_safe_task_work, twork);
+
+	fput(twcb->file);
+	kfree(twcb);
+}
+
+/**
+ * close_fd_safe - close the given fd
+ * @fd: file descriptor to close
+ * @flags: gfp flags for allocation of task work
+ *
+ * This closes an fd. Unlike close_fd(), this may be used even if the fd is
+ * currently held with fdget().
+ *
+ * Returns: 0 or an error code
+ */
+int close_fd_safe(unsigned int fd, gfp_t flags)
+{
+	struct close_fd_safe_task_work *twcb;
+
+	twcb = kzalloc(sizeof(*twcb), flags);
+	if (!twcb)
+		return -ENOMEM;
+	init_task_work(&twcb->twork, close_fd_safe_callback);
+	twcb->file = file_close_fd(fd);
+	if (!twcb->file) {
+		kfree(twcb);
+		return -EBADF;
+	}
+
+	get_file(twcb->file);
+	filp_close(twcb->file, current->files);
+	task_work_add(current, &twcb->twork, TWA_RESUME);
+	return 0;
+}
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index c45306a9f007..1c99a56c0cdf 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -111,6 +111,7 @@ int iterate_fd(struct files_struct *, unsigned,
 		const void *);
 
 extern int close_fd(unsigned int fd);
+extern int close_fd_safe(unsigned int fd, gfp_t flags);
 extern struct file *file_close_fd(unsigned int fd);
 
 extern struct kmem_cache *files_cachep;

