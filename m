Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A09EC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239EE6B0005; Thu,  5 Feb 2026 06:38:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7856B0093; Thu,  5 Feb 2026 06:38:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6E26B0098; Thu,  5 Feb 2026 06:38:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDEB16B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:38:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9101F1C3A1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:38:35 +0000 (UTC)
X-FDA: 84410205390.25.05FA56D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DD32580016
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:38:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3ToISBU;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770291514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+ZQXOfhzgk5ATG5eY5hjfAnjCYI/aZr4E73w/GF57Q=;
	b=pjF2A6nzrNmjyiLq7ZSAuH2arXfxRC8nktSuFg/VLc+Khndff/8YcDWKz654Y2NrYuHycO
	OdHLnqt1LPzf2XVQNkRlPyl2Q+HAkE3nUewG/0oldiLnbEu3TH0j2b6xsldLRW0m4WVDr2
	GyuqcNhEzgk4pYCX0Kg9IV8XVAL8f5o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3ToISBU;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770291514; a=rsa-sha256;
	cv=none;
	b=lWQyGK3F0tc6Kb9JURgl50ofRDQjeHbNJGqyCGchvbcZXcORV41xH46emOLg2tRlWVPzx6
	jP1L+bpfbQxKW4U1mfxC/uWJD9++s2KNze6DQEX2ag6HsDnQ06sAVSZg0u1kzQwJPWD0QT
	8UuoAMtV3ck7xTPWLdBOP0+dP0SzAtU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFA9143F37;
	Thu,  5 Feb 2026 11:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA6BC4CEF7;
	Thu,  5 Feb 2026 11:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770291512;
	bh=PM0XV/uT/jCnIxBlVSrxNfFfXmA4nUroh+I9xLVtYfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d3ToISBU7ApYFyJrR45t52S2cND4hxuUwGAkEz9buEwGEVIxCZ+PwIyX8rw3833IZ
	 1WERE75sN6q3JPGmCueFi683z+0eoY4ewv8urdc+GSU2pMV8VNzRdFkG3UkUUCD9N3
	 Fh4VH8xSR17PHY6j8BLCg3725dqglYRxSI8v5LGmb8RqaZLOOo3Ksnq6FY+29xKNf0
	 /PRYNTM6NOmfUqx6V5pPsdkfOiVTfCK/rwHL9tbRS0b6LKoACHEQqpMRx/CB5cYnIm
	 LYSFlsJw+9nhcK+tK2LFtMwwXjNuc53HZ7vy7kkzft3YkFeoJ1gvhON/v//ieCBr/W
	 PQOP2f8vTuRlA==
Date: Thu, 5 Feb 2026 12:38:22 +0100
From: Christian Brauner <brauner@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Carlos Llamas <cmllamas@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] export file_close_fd and task_work_add
Message-ID: <20260205-mitschnitt-pfirsich-148a5026fc36@brauner>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-1-dfc947c35d35@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260205-binder-tristate-v1-1-dfc947c35d35@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD32580016
X-Stat-Signature: gybfi8ykomi99qswoc5efumktzcbncj8
X-Rspam-User: 
X-HE-Tag: 1770291513-817614
X-HE-Meta: U2FsdGVkX189eSfHS848wMpLQmI/XUneSKgwmKkYTFNc0V+kvTuWHJ6RNgKwnXSEzBMfxiYfKdqJRTcQiINxbDyR4FwZsO41VpssTCbkefFXsoZesBFlKTtGPxPbVxoICcMEvPZdTnP6N43KtHNNVOzyc/2yZ94ZAvr9anmmj3rgwg0FS6N2mDQaHerBUq/2gyPRoJ75tSmnqNAoQ0cQjjlJm0DQ1UcgyDtgGtOJ1GIeWixf2WcQpeDbnliQAgDG1kEqBj30TY7MM44v1yN6n473eOgO5BgMfXazfnd/rdylJ4s4avLZPNUivEDKzgwjun4vyf+2tMhSfR+jw+cqBvRy43QuyJlBKGz4TURCm+W8uTE2WRUqoIh9Xh401e9KemNDgE+9QkIycH+b+VI1TVQmuONr1FkiwO8TDb2OYX5LfaP43EElhGdAud//o06XJvSQFVdagbp79WNzDBloanQyvZvvYfJ4jsQxE0hUH+EAR2Tw17pqW6QAA9Nt/E5qNG9pMxJPHcrudqm7ZbCEz7z5SZHm7Xlpsj7VNtOcrEYcC9WLTPl8W4veACkkJ6DT2D5md0VySHkmaoSOjLAziSVyXUjWfueS2r/02VCWggiPYAopZHRHQWAp8GxrTqVx0dWqMGFK8edUtVYVb2yFd8gyXOIDcqtjlQmISMr5yC4szPrdWgQjzxa/s5tiuEpxkxYaEkrJ8nyh1/PhupAcjvx6ZDn59JRO1hnnHwyfzM+QrHltBPCV2xSQCbUBOz6SbgU3FtLUua+Ix+D20/V3BVH7RM4jRUL4bXxCiugVZKZUA73X1bQbWQQtZ9UqDCOdfrz9I88kcssknbWu9PmVGTZJSkDpL6eqCKH1Lgy63lQAP54D4c+YWUTzAORCzEdGtVwO8BhYD6ph0OK+hSTZb/vEdVSBPGZCnp4TCbinRh4Vi4mhvo1vsE41m4CkdG/XaFWQrr39jSotfkPMFsk
 oiCuBFbi
 TbF+exi/EA232yUruT1pXq7oxdIX0IKXkZI93MMmtUNJH4yhZU84VbVn6dJsvTGNUjrnY1JMnKy2OOB4nKLKjpp5RtV8bm6gFQICKu5a7cLeysDqf2AdzO3b/Y88ph+JC2RkVMNpfiFx0rNQ6BLOOX2C5Ex4NXXZ1PElFL3WrGkHiNyLt5KlcQgvJZ0EynrWw8H0ZAhbx+WnmLUFIr9F9FTOJ7g2F5D9Cg57Qm9wjE3l2uwikFJPyqOzOz9PJ62CAaYw8gvb3vgULS/l0W56Ekx6grA/Aj9V5dGM2D52wynOTMoC8QlIzKGpF4b7YLh1VKfmHTg8OMgweasDf+DEFitsfTolaZOb4NaiO704N2+fDIddFVxU2i80MZ7V+rcGqrcmjNNmObKoqEHIBPDI8vfYy/hX7s7nvVbnfA8qVEzLcozg0svgB4X0temCL0ea+/mNCK9CXYtNVGorg+adDIzgOO1U+jhtlux+01q4t475NsgC07KqfH0/DQ7l+ySxYhYnHiumYXp4dudsFrDmpyDBu0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 10:51:26AM +0000, Alice Ryhl wrote:
> This exports the functionality needed by Binder to close file
> descriptors.
> 
> When you send a fd over Binder, what happens is this:
> 
> 1. The sending process turns the fd into a struct file and stores it in
>    the transaction object.
> 2. When the receiving process gets the message, the fd is installed as a
>    fd into the current process.
> 3. When the receiving process is done handling the message, it tells
>    Binder to clean up the transaction. As part of this, fds embedded in
>    the transaction are closed.
> 
> Note that it was not always implemented like this. Previously the
> sending process would install the fd directly into the receiving proc in
> step 1, but as discussed previously [1] this is not ideal and has since
> been changed so that fd install happens during receive.
> 
> The functions being exported here are for closing the fd in step 3. They
> are required because closing a fd from an ioctl is in general not safe.
> This is to meet the requirements for using fdget(), which is used by the
> ioctl framework code before calling into the driver's implementation of
> the ioctl. Binder works around this with this sequence of operations:
> 
> 1. file_close_fd()
> 2. get_file()
> 3. filp_close()
> 4. task_work_add(current, TWA_RESUME)
> 5. <binder returns from ioctl>
> 6. fput()
> 
> This ensures that when fput() is called in the task work, the fdget()
> that the ioctl framework code uses has already been fdput(), so if the
> fd being closed happens to be the same fd, then the fd is not closed
> in violation of the fdget() rules.
> 
> Link: https://lore.kernel.org/all/20180730203633.GC12962@bombadil.infradead.org/ [1]
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  fs/file.c          | 1 +
>  kernel/task_work.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 0a4f3bdb2dec6284a0c7b9687213137f2eecb250..0046d0034bf16270cdea7e30a86866ebea3a5a81 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -881,6 +881,7 @@ struct file *file_close_fd(unsigned int fd)
>  
>  	return file;
>  }
> +EXPORT_SYMBOL(file_close_fd);
>  
>  void do_close_on_exec(struct files_struct *files)
>  {
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 0f7519f8e7c93f9a4536c26a341255799c320432..08eb29abaea6b98cc443d1087ddb1d0f1a38c9ae 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -102,6 +102,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(task_work_add);

Uhm, no. We're not going to export task_work_add() to let random drivers
queue up work for a task when it returns to userspace. That just screams
bugs and deadlocks at full capacity. Sorry, no.

