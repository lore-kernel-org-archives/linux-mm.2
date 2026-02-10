Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CAA3EA3F26
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 08:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B657A6B0088; Tue, 10 Feb 2026 03:47:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A0A6B0089; Tue, 10 Feb 2026 03:47:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3CAC6B008A; Tue, 10 Feb 2026 03:47:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 938F76B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:47:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3450AB94FC
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:47:57 +0000 (UTC)
X-FDA: 84427919394.05.9016C88
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70F12C0004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:47:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TSNB2YXV;
	spf=pass (imf10.hostedemail.com: domain of 3ufCKaQkKCBo0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3ufCKaQkKCBo0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770713275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULYjWWC903FxjlaA/DfXcj/bqj7W1j7W1eSCTHW/xkw=;
	b=2+UQNdCa6SaBXQs4y7m+5uQ7Wy07m6ZWzb3+p7Z2anb13JWKEyqpko2Ol5EL/OhIe/hinI
	8CFiF7l1c00OCpevTGnZXf/yuBrGJ58yMTJGuKNNPyxA6WJjkST7ZwHbVCDZN1XrLDoMsX
	5X0EmFlpcsGy7ibxMOOLJqnWZttFX9o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TSNB2YXV;
	spf=pass (imf10.hostedemail.com: domain of 3ufCKaQkKCBo0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3ufCKaQkKCBo0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770713275; a=rsa-sha256;
	cv=none;
	b=Cbz7FKSk71kJsFAxbi/v40WWqgtRRaJJTrqW+8OvXminYcKL9IuNKqb4uVMHSzcSaZQE5P
	xVJ2tzJ2YB8P79/9GoChyDtkC9mLnehSPPyfiGpCWQp/66n5Dl8KxYxh4N4knZCrdOM8by
	Uk3SlLT/FvItijFq8IRSefBbh/ClUtQ=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-658b7a088e5so657409a12.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 00:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770713274; x=1771318074; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ULYjWWC903FxjlaA/DfXcj/bqj7W1j7W1eSCTHW/xkw=;
        b=TSNB2YXVtq115RIwuKc8o8rbGzLQre/91ADTr6EwVs04MHy0S4fOOejxIooKdmdc0L
         do+A4D9PdAL0mw0ksDFIg5bM79GjWbg3+Tcn8fiV4JD8+nVYQJ83R8hCqyV35eoNyMkD
         Y8G1X+kIqezLwrqR+8eV/aTt9So9pNF7Pr7ms+thrhcxWVBoFtO765SVVYSS6uZANIAw
         74hXyVEIm+LmP/PmKPNC1E1g59JhtzBOAEaddlgo+QUw4pg53auuH+3Q+AJiY7xu02Xs
         dRhMY455YyCUuolIr3Kd2fyRqBbY/WEJA98k9MBiCSBH4Kzj3d9LjjBmRro55/WFDkyW
         y87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770713274; x=1771318074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ULYjWWC903FxjlaA/DfXcj/bqj7W1j7W1eSCTHW/xkw=;
        b=k9qrktzZGGQ4psbimtaBJeVDngyn7rLc357bMOg2guu0YA2lTIz3ahznI731zVh3Zu
         MbA/lkFeCa2m2Kw5uGLrmJlPxrCpDX0vbSe01/d6uX7WEKCWXRfYQTdUAR3Dxx90chNr
         0aBVcNh5oXC/x7mAXeaYbC8V2ZjCtKV5itcm1sfLM7bpOqP09uEaxBywRVZkEpE8AJTK
         1fugJuGBVOhlKJgc0Qpr5dF6rsDWbR4WT1CRt2GDdpNJuLoJ8VbG3d91bWPaJmOmWXl8
         0mg1FFnCAsn0d1nwdd0V7QOaeFAJBBhCmSiVD3WqCEgd4FTnc+Rojg7QHVufdPp7Lccw
         byrw==
X-Forwarded-Encrypted: i=1; AJvYcCU9hN2nVfGid95CCBEdcKBaSYk55SDB+U+o/1feHDiw95SjWbVK+r8HzVmbDNrSzTi4l5JgXXA0qA==@kvack.org
X-Gm-Message-State: AOJu0YydHZt3YMyBMH9hc10BsDWH/ETB1jYTQC+6mfsh8s81u0CkYWM3
	k3T13Z4W1hFCDROQI6Us3CeuT0L04/iQmMqeKyIebJC013pfbjdXsY1jNPTgUduwtsBO7zRgRBi
	nLGnU4kJydhbzQxQYBA==
X-Received: from ejdai24.prod.google.com ([2002:a17:907:e158:b0:b8e:b3d3:3838])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d16:b0:b88:510a:59b3 with SMTP id a640c23a62f3a-b8edf40a6a6mr848568966b.48.1770713273356;
 Tue, 10 Feb 2026 00:47:53 -0800 (PST)
Date: Tue, 10 Feb 2026 08:47:52 +0000
In-Reply-To: <df876a6e-013c-4566-890d-7c1d662fced3@lucifer.local>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-1-dfc947c35d35@google.com> <9d0d6edd-eab4-4f31-9691-78ed48e7ad5b@lucifer.local>
 <aYSCNur71BJJeB2Q@google.com> <9a037fdf-1a98-437f-8b80-7fdc53d5b0fa@lucifer.local>
 <aYSfBJA4hR4shPfI@google.com> <df876a6e-013c-4566-890d-7c1d662fced3@lucifer.local>
Message-ID: <aYrwuPus_cOyumGo@google.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 70F12C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: gry1u94r3tojbxfo449dbq4egog7h44s
X-HE-Tag: 1770713275-158774
X-HE-Meta: U2FsdGVkX19ZSQ2aGp2Uy0hRWtJVZ3q7u8SjhqzD2H4Ic+P1Sci7tKec22hCXOR24xOwlKCM9DdrBh3VKQ+KcS3opY57rJDp7pjnAZs+zJMwc7wylmyI2uGihIOt+OTjJVdSqHg27iWopR83CTHsm4/1qxtboEpizzvBFtcxn6kEoBo2FnePGPKdYNKNMe6jbHWLq9AqefdC7LR6pahE8j8T2xKRsfhny4pU3nqTf9CdKd1lF4WPsV0DcBhCHvQ/5Leh5cMHe1dnXZEQe3yjajrIGjoafRPQKWRo1cEOHE+j3cHy4mUKkSnc1XwjNyLOvGOpaU03ap1MqhH/497hiKy3ejVC5edXDKaXoRbXn8gZnlAqhYaio+ZdMFrDhZFuAjQA5z+JO9lBLMabv2jaURGXVfAd6hqWEpZFlsVwAe1jDdodmSTXn1TTMsJE9nL9NP33z4RzTA3LfBN5piM93l3ZDC7QMkZcPZpQph5hZqxnkscyZOojYswzG3PBleJ3kANJ2/Sj3h5qG19b/UQoASw6ydz+2i48dPhQc+IaNb+g7N7My4WS2WFNZcNZl47pxBnm6ae+sgMtXn9J9xgHZ9j2UVaJf7vKO0zmOgUG9s1OD3v04AM6xMRzIGu2A5UcFIJOJQ3M8FuP7QKMzgKAT+QwWwBclB3esj2AlsBGoLoTQQoberF6PVpncI3E5MzhUzMFzBWnEGM3QP8Dcq8vokP6i3rH4YHFmkSERGuz+m3eH15KEj0lVyYPTLkb0UuWvBk6Gp8o7BYFptI+MTi4+JsUp4+TKZnj1NKB5f4BrHqaYnytPcm7Azmb6FhcJTINrnXdV6z1lYF+OjQ2/CHj71z69SQdQtDqY0Ad7eTvQtLar4ItFdr/iTUhYQNW/Jkpu5GkgmSODNTx+KsGZP/1mnzQBO1xDWbmXSjBe3XuEBLs2j/B+lxKbSYClY4GmyyaPp/hLY8ZJCiopttwcpa
 PydmXxcF
 Pu0LJLMGxVrYELqeva08S28g9X7H/FDJWn1n9NKK9Pon1UrIpf8IjQBofBQyHxcgXDcStaOlCd17ItlyGLt0lE/UgCIstCC205Icvan2wr9AdCwhlBfwd2jBe7vPC8bvTjzREUGgYg8xOM9PfGE7Hd1mLF7DaeagiF5fKIe26C8CL88PeZ01IB8+VBvdScQfbuFPqc6SpJQ7ASVGkrsZTHeNeNREtScXsftUdsM0G4FSJLlesItxOJCO9mPxixh0sG3HGZNbEfPuRVN68Q2/Kra/Cz4NoSgLRlvZd3tv+laemxCg2jQGMVRQDI9NQxi5xoeJngFIeP+YsgIDDGiJqZSYf8M7HY4v4o2ZnsD00G1EPCI+gYYYjK1RGSMzdf71uBP0f4Hz+PSBZzDC3FlUG49baRL3zVyM152XX1tiNQx5Yx+ikWFJfF0QdJCwFyWlkzqPskBz7CxInvA//1ulNvoEMj0YwjoyKE24f+VNFmu8k77G04ES+EexUWHMLW7WD4k4HnKV/MJ1mguFlunig9ZLzlRoGHYNgikOKavPK+Usifns3j7k6E51a9OT+gFxHyKFGl0Ch67e3+S1CnmeAcXi2wYcZTta086YPQ1dL3tPDlKJR8q9NxPT89I4CjrZSM9kuARRGq349WXuKbp8RpQXf/qPL8RoP5klMz5duONWOfClFguCUIC8+zFAdV233dvwRuNdlYN2I0mPBktUZ0fOb9JL46GI8+qO5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 03:21:58PM +0000, Lorenzo Stoakes wrote:
> On Thu, Feb 05, 2026 at 01:45:40PM +0000, Alice Ryhl wrote:
> > +/**
> > + * close_fd_safe - close the given fd
> > + * @fd: file descriptor to close
> > + * @flags: gfp flags for allocation of task work
> > + *
> > + * This closes an fd. Unlike close_fd(), this may be used even if the fd is
> > + * currently held with fdget().
> > + *
> > + * Returns: 0 or an error code
> > + */
> > +int close_fd_safe(unsigned int fd, gfp_t flags)
> > +{
> > +	struct close_fd_safe_task_work *twcb;
> > +
> > +	twcb = kzalloc(sizeof(*twcb), flags);
> > +	if (!twcb)
> > +		return -ENOMEM;
> > +	init_task_work(&twcb->twork, close_fd_safe_callback);
> > +	twcb->file = file_close_fd(fd);
> > +	if (!twcb->file) {
> > +		kfree(twcb);
> > +		return -EBADF;
> > +	}
> > +
> > +	get_file(twcb->file);
> > +	filp_close(twcb->file, current->files);
> > +	task_work_add(current, &twcb->twork, TWA_RESUME);
> > +	return 0;
> > +}
> 
> Would need an EXPORT_SYMBOL_FOR_MODULES(...) here right?

Ah yeah, for Binder to become a module it would need to be exported.
(Though maybe it's worth moving this logic even if Binder is not made
into a module?)

> > diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
> > index c45306a9f007..1c99a56c0cdf 100644
> > --- a/include/linux/fdtable.h
> > +++ b/include/linux/fdtable.h
> > @@ -111,6 +111,7 @@ int iterate_fd(struct files_struct *, unsigned,
> >  		const void *);
> >
> >  extern int close_fd(unsigned int fd);
> > +extern int close_fd_safe(unsigned int fd, gfp_t flags);
> 
> One nit, generally well in mm anyway we avoid the 'extern' and remove them as we
> go. Not sure about vfs actually though?

Right. Not sure about this.

> >  extern struct file *file_close_fd(unsigned int fd);
> >
> >  extern struct kmem_cache *files_cachep;
> 
> I mean this is essentially taking what's in binder and making it a general
> thing, so needs Christian's input on whether this is sensible I think :)

Yeah.

Alice

