Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DAC606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rl8K3keG
Received: by kanga.kvack.org (Postfix)
	id 2E7E66B05C9; Tue, 10 Nov 2026 13:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A1F6B05CA; Tue, 10 Nov 2026 13:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187C26B05CB; Tue, 10 Nov 2026 13:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D60386B05C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:02:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6583BC09F6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:02:06 +0000 (UTC)
X-FDA: 85419978252.23.12B7EF2
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68B3C14001B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:02:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Rl8K3keG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794333724;
	b=QFVX1yt7lNnyTtQsFKObHR1CBARE3r+QI9MHh55zt3OGg5DJmXy2oxUp7VsQMk+Z1crAqQ
	Bwup+nsyybHYVf5pPYKYWri5aAidrClkCrYZC+EAdv0/RTlfTf4ClhZflqyv4ApdjGfxNw
	ALikXA8sv656SntuHayDmRitm0/g/jY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ov9SjO/T2yWWs9oVvwaD92SGckXKvt5IjQ1wTzEwgxg=;
	b=WJOlzEO9idM/8bRPiS1oY4MQhemMVMd7mhQ5D3zZcaMhEIf0NZN55lSocsM1FXFvcYfH4t
	g08JglkaeqSWvTkJBnhzYGNj0bswNP/h+kbg9/Ou51/JfDGKUYnYVMAanEKMZ4sDWnY3zs
	zsPlgmrRm2jO/MermhzDt99t6vHxO4g=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Rl8K3keG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3ada7d53082so25986971fa.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794333723; cv=none;
        d=google.com; s=arc-20260327;
        b=dIg2PyXFg6Pg0Y/DN4AuuQfmO8vkQyONdjinizqEq64C87nvleMxGyANblTnSmsUm1
         1CdfV3Hi5krvTHZ9olxv8txQ4oCnO0OOb+18LOuRP8fOZKp9Z5nzzBEFK5cFfElCaf00
         6Z10kZ0UHbQpUbaZCl4pzqHTYKfo/ox48vICrhJlUVpqlgQzm3n57sZ9Eb3a6NSko7Yu
         Qms2MgdcnVmAig2rr59toxqwV38ZfOVcatCmrMzM9gjA35jDDm9pJHFx+ERrJkTG+WAr
         FLkS46vGNMoZA9ldiUDXs1D6FGn0rFM4+uFihS05qCGiYv/rgMvS3VuUw0GaSQWbtI+L
         empg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ov9SjO/T2yWWs9oVvwaD92SGckXKvt5IjQ1wTzEwgxg=;
        fh=eGiqusEB8w0C9REsYWIK+iWM1peULoAg0dJMt7+0snA=;
        b=WPKxi+hgFd7rUl3eKbdHZxhfbdoMAeakeSuDUz7p7gfNkHtYcuQb6FBydHyXqvqa5S
         Co7PBEv04U4+4ak4qTNfe8teHg/imb1uwJyCV1m65WpiE+OCG7kj0cuGPtsavPwD3E+f
         hNoSjg9S0F99O0In9FUJWALaHkVUyBmA0du5ZuP7cGyOWHYzI1RHs++jdn10jTHZx9/0
         bQ6W/npSwKDyPI67YcQpwKve3AyBemUqgOp/Bjek4Qp1BPdUutk+m2nenwvOMF7+48bx
         dlGZQ/6V80lcj9nkwW16nknNDsAM5KuVFVunjhQ9er1SXzEvy/xBEUJc5ZOmDI6T1Umq
         JPAg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333723; x=1794938523; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ov9SjO/T2yWWs9oVvwaD92SGckXKvt5IjQ1wTzEwgxg=;
        b=Rl8K3keGbcPOx5t2eVOv4IsiAJokj+LXsiOZsNZuyudqmLggWekA7f9h5nfmOUSLfm
         12+bAhuEUECapvv4IgFU/ULPSG4QmKLMT5e4YG2bd2WkWK0N2pAjCezAmVtIOO37EY2K
         2/BknYxNT2y9ct5lRU9u3M1gc2cv4Cl7J2vlxUPUHBVisqbmv/lV//6K5JIVEjCKl0T/
         DUzU3J1t8cVKy+EV84cdFsO4ySOQNbrlHBtnK1m/2Nc3zL0CpoSScybnrYRWEPa9pXFN
         X9U64s9EDZN0Ds56k1jj0xhasN06Gfl3g4+NQNX/brXh0TUn/Te7nW9/44EmJttcfKWm
         wP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333723; x=1794938523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ov9SjO/T2yWWs9oVvwaD92SGckXKvt5IjQ1wTzEwgxg=;
        b=XpfO6i0WvWLJi6sK5gk0lmmjVCo7cvSZAT7OlVKzbn1gO7jg7+zRQNylRhBJY38JaV
         vN7s//amzpo5SOX7MDkKKt1OnwaCAaTkWBDerdNNf2L5uAD45VWO+ma+rsexEVRHsIQ0
         j+b+GxMm7WkghIeH1G8xobQNdqq5lyD57yNZb9t4dczAwWBcT9jSPVtk1e/vCQqD2lDD
         yCmWemNE//OmeGqvfURS9A9oQydXQ4DJ8Fdt8GoP4VEGM6h5LYmQ/RopFZDC4pry2PhY
         Hk2L+YjsBsGzLSN2mSyFk1pxtMh5hidYa1bOO8EPBYyLGm/p6BbcjkVqFbGRR4puMojE
         /g5g==
X-Forwarded-Encrypted: i=1; AL+hErFu9tCogUsYHufw6xNzUdKAsLaiu7BHQlOdGe2H4Bh3iwFaVfIGrDlDqXnM5EY3xOmAjSEjNnxyew==@kvack.org
X-Gm-Message-State: APuU4Z9yMfwKRAQFOi31w2rUstDGg+OKc0KpyotuNIIDyW0JVUpSb8n6
	7sOGKRJ+ZF6xPt0/E6SY6/xT1veNvL74dcucAwlJwFL4cUIfC9EMvCrIRpSiu9ytqb0cuS4qBq5
	WQxDfVL0RZsrmubJ0vQi0kPOkQCGetvs=
X-Gm-Gg: AYBFou1OEtXdjRDh6VnxDGzbg3oa5p6pBuiHmkOaA3kUc1l7c+n/uzTOTnu/wQZzWQR
	TMC3bzlYlUj9tQ5au9R/jt5Vy+lSoxgL0cwdQLg8YKUgHKu5pdEiyxeWdjWnguvhSL5+kYGZvu7
	UM2MQVmn1ZqHQVQ4ZvUr5CpI4dDUhLzUX7s0gX6bBjUOlhSv92HNbajd54LQ8z1LVDVL2cofzZk
	Aviuoc5c3Vhd9CIcSHa4msVaZOqjV7aEtO76cW8pyJR28phn+1TRN6n1vJ2I62DdSe9+SSdIDMt
	g+/RuKbyS8cZbzeZCQPousWVMn2mBLBal1jXu+EP/LiSiofVFOkHGf3DO+63FNAgF+cFdLHN8OP
	ZlFJYxDL4Hq3tKKM726fCxxrvmtEQhpyuye1MFI22Ld7NS8zsjghTcfs6dXLSnqfbdNgyJb6eXZ
	vN5ePlS6RXZCSHHBsw9gwPC9VWgnNUsjGqgs9LscWCQ0sGcX4ka9ow5w==
X-Received: by 2002:a2e:b8c9:0:b0:3a3:61ec:43c7 with SMTP id
 38308e7fff4ca-3ae10a3465bmr680781fa.24.1794333722682; Tue, 10 Nov 2026
 10:02:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110054836.1515030-1-senozhatsky@chromium.org> <20261110054836.1515030-11-senozhatsky@chromium.org>
In-Reply-To: <20261110054836.1515030-11-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 11:01:50 -0700
X-Gm-Features: AclHuK9ip-psjuIqgfh78sIFIsL_WvHPuXVercH_1RHZcH6UZnfeuVyaxOhmKcM
Message-ID: <CAKEwX=PJObB4gDPtsOWGjW6FJD4dtoz0qDu9KpK9jzP0=N=d_w@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] zsmalloc: fold zs_obj_write() into zs_store()
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 68B3C14001B
X-Rspamd-Server: rspam12
X-Stat-Signature: ppkbmc5xiiut5p6nr6ro6gbaobd4h98x
X-Rspam-User:
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794333724-945794
X-HE-Meta: U2FsdGVkX188YNydEP2RMqFwARJNxHvnLYsX0FsqRNsLD5VeXOnse6WWp0c7QjiCUsu7R9g6kFxh+0Bb50+jqil6J4652s6cxUBDd5KRxgT6nJ6vxZ2YzZBABECQqHoMvdUiwZajgHY1P/BPX7edTsk2/3ZcbnsfVwwz5eSAfPyOxrumvwzbkSTEucL8vMLcjWV6qkn9wqWCm0GZvCdmTeRnBRvwUI+/PUYoYjH973kjyx5TmZfaYWTsAcYYrcvwoKwGnLqk7zVULYbOUM5L1bUUrqrkgBAO2kNhMn6P/inodsAleDZTnVm7EiKWOzzW5nvAIq66Xm2bw9LaxMabxKDWj05KMuD/Yty0oXjeXfPWbDsBokLMIJAA172KobkpMLUwUsPqC6VLyZ3wNWBlxVLyJIV+7qBpYbHkJGa1olY9d1OVVhK7+fp1CRKU4DToPM4CsybQPVFNg0U1iUcdYCDZpzauw326+YIdBAUaMh/XUcHOCTrKLiaJgQmHuNDDELcqAMV5vGZaOWtwpJ+a15O1hLhK1dh3iiPl6Gbae7JC6O8ipgElmyPNeQQfQ4yfyverOEY1Pxnof9LOb0F8K8QolB9QbgXM3vxsnh6da0x3k3jAHDqxdGWjma6pxQlFzfR/xkpzEIsUIEEV9Cl/F1KrWAmhMPUR6Mou3c13EOSBBbEba+N0gUdfuQu1EWFMiYP8igOgB06rX8BquQ+KBUD2BRf8vK6hACglY3uEfLFEhdVz9xd4qikSNiC0BtlAgCzUaYCfIt/QEEJlF2dSYMR44hohOGa2z07KE3Vz+6jgYFcOOyi6i2ges1CSwwWyvOlaG3xFqxGtO2lHJ+ULD5B39VUJqn9JCsY61jQDq7/OxnkhcBmAYaqugOLrKDIDqLf/P6gJS61APxt0x1BBVlStbddGsB72ehTDA98Jd+Rd9h88W9+JAtbSnoFBLHtZnsJYQG3I+ae1xIi7atn
 Zf0XseXA
 9I20pU2yItoH+aHGJuC0Fuwse08wuL7P9KXjHMx71nXGQ1d6jB12AJmi+Nn7fbeEMR6x9pVGufmDY/dNpxq7sqOrQNc484MANLkX7JzSnLXEAus/YA0a8lniiKo5V/vIg6wGPeY8a0GzLYFl8TPG+1Rf9Y5XUz6eOUTgiUbL/n0CwvAovtTv9/cxKoPwMaQ38Uwm0fG3SVO3oVoPgF8ufnoqaJDJxK56VwwLx62VyokJ7WGdTFQlRIi0IOXgicyFKRoyGelhPjZcn3d4ZtukP7n+//wHnslJ0JGQvigh8mNkdjXQCGz/wM87tCpfKW6yBJCaD2drMUBCDFFd0fIOZApo2jo8HH0lbLjfLk2e/eCRqjw+mwca3VktHzMmEpNHXLOFThi3/eYRDq5vw2oFWFei+0swoT7cOHzT839aVLh3W/X7hIGI23iQj1HI6u47rdB0nlNi4rWN97ClAkukc+dJMPz4iJzwUApiFTUK9t3EESbTB/zBt2Mf9zNfe5pTtBghB74pAbBLdJmaopQ2lN6q0gkhrYxkSc+PmhMrGldp/OR9KkKeZ2KjPeFtVMIsUUXwUNexbmrTOzFbQMYms0lG7PW3/BohF/aepCezjl1mafvv4aX0xs1nE5l6t1Lz7Ly8tQFfn+JXOuP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 10:49=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> zram and zswap always call zs_obj_write() right after zs_malloc(), and
> zs_obj_write() has to take pool->lock and look up object location
> again, which zs_malloc() just did.
>
> Replace zs_malloc() and zs_obj_write() with one single zs_store()
> call.
>
> zs_store() takes zspage read lock under class->lock, before it drops
> class->lock to copy the data, while zs_obj_write() used to take it
> under pool->lock.  Compaction and page migration already take zspage
> lock under class->lock, so this follows the existing pool->lock ->
> class->lock -> zspage->lock order.  We don't need pool->lock there,
> zs_store() doesn't look up the object via the handle, it already has
> the zspage from the allocation.

Oh nice, this looks like it'd save a pool lock acquisition?

That (effectively global) lock can be quite contend-y under memory
fragmentation, etc...

>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

