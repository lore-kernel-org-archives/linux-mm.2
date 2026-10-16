Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05453CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30B26B0088; Fri, 16 Oct 2026 08:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA686B008A; Fri, 16 Oct 2026 08:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83B26B008C; Fri, 16 Oct 2026 08:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC8AE6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:53:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 192E380407
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:53:23 +0000 (UTC)
X-FDA: 85328480286.13.226244D
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E4E51C0005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:53:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qBczlxlW;
	spf=pass (imf21.hostedemail.com: domain of glider@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=glider@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792155201;
	b=i6jcoQhPOQAg22q+DVVXPuX+jm/g7jnBWhb7T8Bhs8cDYvDH2oRYyy7l+hw5IXrwwyyeEe
	q0tN+EQqISgPUwlM8JJPXHU0tsxqCYIU5MvLoUexQd0hbmPXSH99oUy2iOSYtY6lkLewwh
	mK94p6C3OW2N+pDKpCOZlp0jvqxpEgg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qBczlxlW;
	spf=pass (imf21.hostedemail.com: domain of glider@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=glider@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792155201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPfaGV0420qaDB9DFQ7lbSxQyKes9BcBtfe80J3gJ8E=;
	b=yLp8WcOp93/45oHreFagt2bBaFJTn5Po6911S3aSpx6uqz73+19LjzNQYV+hxeO0RV2Iyu
	Hxtpq3d8HctUk1Ddyzm+Tb+Cs6bnTauuVScKc/24f2qrEO7MsIvlx5+N1hxwyZwSiaQePm
	lZG3gXxQ/8YFaOo8wjHvLdzKwc6MIHM=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-15943c9c005so3323626c88.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:53:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792155200; cv=none;
        d=google.com; s=arc-20260327;
        b=SEsmpJWN73Pds+VaLjki3Io764eszqIO23QBxqRX/QUpxkwcQjnifh2YDfFhpcpdbp
         E0emRfKX2ccM65Aw3nxj1UfneQUhKvpEODF1FZUzh6bUVaiGfSIW1i9BOmcKyLCTKKyT
         PZnRQ+TWPF++03KnvF1BbvdttNWVxo0rkOTd0u7SCwC3df6iMlgP5vlTpyHll0GbRvMb
         ZCsb1xj1pSKGWl2bRm1asZ3JIfQPqWHC2kDFDjoeFBGE4Dhvfh1nN5KIkD0eks6Ckaeq
         E44GuD+t1Ok3MFcpXP8eLPTpdzjdPlSww+HV1N+v8bduU9hy0GGQmRG/83tZlkqpN4I8
         bwGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dPfaGV0420qaDB9DFQ7lbSxQyKes9BcBtfe80J3gJ8E=;
        fh=QWCLDb9E8ZyFrztJ3d2YQNP0EZPEBbyuo1dDoUowHFs=;
        b=J7VeMXClDfumJZcipZj/GiT1bkcdfz7qwJC4yFGLl0fX0lMIJXpBE/QXVdQFCPyMPl
         RRbS06hsQdd6SgVbl2caA61RSAaD1ALj77eqLxdX7Ab+oYQq+PwbSB29h/dVhCu9HIwB
         iY6XdDd3iy4ZzctCwPQ0ByZ9NSG9ka1Ijn1/NxXjTyRleQ/E4ioG05Q6bLlMLWQ8sJWc
         0zD79X45g0Y1wkNvSorKamvo6Ah3sVc2CYpefLK4rzqZG3Z75KpIX4MqeMtW3NiDNv92
         L5sJPkQfEpI715C4U4JkdZXvpEKdJKZ3LiPFSU+8LFfYTM2m/W3SCq2kKUhw4wse7IH6
         QwRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792155200; x=1792760000; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dPfaGV0420qaDB9DFQ7lbSxQyKes9BcBtfe80J3gJ8E=;
        b=qBczlxlW0EJZb3eZGJ4JWwYs/GfoC/+wgcXFOnTYtwSvjpsAPtKUpR+qQ4wVFCUtTP
         +q6ow7bZzQGeZu+JJ6Vl7a0FrmDKqSgKRIvhz02r0F1sqvVojvgirgOrZb1CwIa2xn7n
         j/6rcceDt7JeQnjqju03yZG7LxTBBeAJC7EqHocaAZJoJmc8KQfAjeF/McG743Yolk7P
         YbmHY5xUo0OBbdqP0Vmv7UMXQhzshXkeYINH8Riz5Ox9P4Q9nG95uK1RjKgfTuSFBtn8
         hpoU2YWnkUPeUNWS/YQiqRcr9URjeuewGp5dyTR1kADPaLeZxJ9aKOy1pXdRCJtY5cro
         aD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792155200; x=1792760000;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dPfaGV0420qaDB9DFQ7lbSxQyKes9BcBtfe80J3gJ8E=;
        b=yck4/vjgqHMaZFrpA2cZmR27tc/1qkNYFOWyUPoHQBU1qJRpRJGe+9zdgyCXjKEPfo
         H1L+0m5VMyQFVdvyw9P/3Li0k7Uc8w4CsxBFTMASYAJ3OrchpRXunqan+FwTeVsOCLVt
         WGPGaXsCcUQOYMUQ6L1lUEOa+u88L9lkMtX7Jvok+JYBd9wTxE69lmTsp0hALuAvLeNt
         YI2VF+GDTqk9gL02WJfkWGpKdOGP3YilKiG0/T/cImS19Ov6TxwPPr0wq0F/qmHTWWAN
         vYdBad4NH7ynuWwJPSdwOhsAdk4fhPuk2s4DYVwgaZ1iskRjpNHGocE7h4aekpZS+mBx
         0RKQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7EfSndhWHNlt/81d4SPaN9JsjYafRDCT/yiNMtRzx+9g2KupQ8FlV/aFQI5R4FYpPJxft6pfzuQ==@kvack.org
X-Gm-Message-State: AFq9FYK3SyZXFlyopUR1tOTUDi/qSh4o1NE+f+CCc76C9WvQHxsGSnE1
	7lHaQO2GTCdIKFAbQPOX7Z09/vzXf1OMPYo3rxtdqXTsAvcTxN5eiW4WI96JOHrMvSd/5woUgJz
	mk3TwWlFaZRKYGT6qngW1b0hbj5hFeijBZ/EaBkXQ
X-Gm-Gg: AYBFou2+tG7W3BQcVh8WMtqInj3+jDPGcKuwH8U3++ktuw0gNGBaHhog0khq4YKFnty
	F/AWp66oyDfJ4aKhhKgMz4ErTDAvLZlFUbBKLyGk1AZascC6Ehkgv41XGJmE+r5W0GV0s/cDdie
	88MxvIIZ1kgcpWeIfJFm20RKBGAYY57J8YjPM3l5/Tuux0kYiQL+4qgaTZ0ITtzPb5dHPLF0JWZ
	QhxTXd7vk1HutCj4DoiXsndKuAwONKhv+jH+WY8rrY65eue/rGRPnBtLktDIm5HfFFEbjYwAy1k
	50IeA1Gu2ngxQIlr8iIb9GaUegSGIFAFJb50q0007c5l6oYgJ6aTdR8kk7OZl9Cr7Q7YDUGtw5R
	gQxQWv+9u0Q==
X-Received: by 2002:a05:701b:291b:b0:14c:aaa0:941c with SMTP id
 a92af1059eb24-16a64ba421cmr27941452c88.35.1792155198962; Fri, 16 Oct 2026
 05:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20261002200508.546-1-dmytrokoziuk68@gmail.com> <20261002141223.1ab39d5cd2d65b02dce8ab85@linux-foundation.org>
In-Reply-To: <20261002141223.1ab39d5cd2d65b02dce8ab85@linux-foundation.org>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 16 Oct 2026 14:52:42 +0200
X-Gm-Features: AclHuK9Opz0egXeT67wcM1R2TZ-xVIqktmKiQmiUb6_1wVAI0Op1Uc5FEcoAWQ8
Message-ID: <CAG_fn=Uvbk_758njtMR0KOpKNOT5=pwCjLvPU3M_x8ob9Fx8Xg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: kmsan: fix iounmap metadata teardown
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dima Koziuk <dmytrokoziuk68@gmail.com>, elver@google.com, dvyukov@google.com, 
	urezki@gmail.com, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qf4mwxa4r6qhua3ozxxd58xuzggy46pa
X-Rspamd-Queue-Id: 2E4E51C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792155201-676394
X-HE-Meta: U2FsdGVkX1+VMQc+NO+1mc24tNK9iENCGwHSofLifyas6a/Lk6nZi5DB9zpq46pbln5x76h+4pUEDXMxt90F3m1/56nJ+QWTNrAYUjebqDw1fVR34pG8zay7lwTYHVjIZtiXmwQZRNEjCZCOc13B77Hx2kY4zq3Bcuwzg+VQQPmFisXVQq164jP5GfMwHKgaM4YxM+ShjOXa/UACmODLRWgdx9oSPC5Mo8Zpc0j/v5DV0s2AkpQ2GiFlyoR8G8OSQFo/gFjj3eguMpweKlhsRXNkN0fUgFAk64OmsXFuEgz9rRFJgwFCpCfL7BZvqhyfAGtKg0Xefb7MX74cAfGda3pRGM1FCJeVi6byQ2P/kIuL7fzRtA5O18Em2Rw/eH3NGie0PD2XMwjnIuFuSYE7Jrq6mEg+1oFKjnbf2gc8wH+NynPmKCuOqPmG2BJWx/Ivienyj6KkOIlnzXpZQ3nGR+lbU4O5kxVsol4Ibbf5fO0LgBdYNomePDTcANUgpqJeywncve/yBVTz0J3EejXHAkgnEhXSTBMJKBmgNZKP8TjDBMhU+5an2bthTEe22KRDnvx9LOpw7UD8oA/2IneQJ7jAe5S0JQ3g6Dy2Cye/ufUFo7U342TEV1glrfbhaU1PLpQ0pNdE1JlQfQpgaEsg9jIKyp7lnb++1TcxyIf5kdFFVzr21/4Tx1LqtPZreqw4dlSfYIyxa5560kmWwX4F+Hg2pL/VP3BMwxX1UWmZpNk+zYyYJt8JnIFiVIlg1TjmnTKHMUh2T1Rig6hqx7z5s3uFrjhhdxM1F2f7AtiB3+nUil9oB7QgUPZtah4BrbPNFeHMZXeCQvLkptLYo72++QehBHT0vi1ILEGLrbq6tMwjy/dFfKfWEHfE/lWGH2uVzXdznMFcnmLnYisgIKVfykALiAuKnOZVkKGjXQtnlzhn17c9CcFD+PeWKEMCzWaU2HOSgmlkk5R0eWbGmsb
 lCU+yED7
 2nsKde4wuLCQ9g09ghGq5sL2qX6ehFjOgXracdXmMeSkZc1vUsYHbVaialQmIDTHVvs8w8XM5P0Za1oMWuzfF2jLg7yASPgrcFn4aXvOoaGaflMkvkAY1TGqdmynMTPTgbHUnH762cR28Xzu4XMpehL5AHcqVLLCwpaKzV/2s4VQWAevVCz5TpZOceyIsMt/F5O6cAtvrr7Ni94MC89Kz7WQvRusyiqhBcl5zR4Y0vBOkMLYawztMVz0zTVutqV8QEcF6L2IHO7zrc6frGxO23VDHgsUzHdEukfMtCQM4d8EshRokcv0gtdX4NCV/1fCwfTge
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 2, 2026 at 11:12=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri,  2 Oct 2026 23:05:07 +0300 Dima Koziuk <dmytrokoziuk68@gmail.com>=
 wrote:
>
> > kmsan_vmalloc_to_page_or_null() rejects addresses outside the regular
> > vmalloc and module ranges, including the shadow and origin addresses
> > passed by its callers. As a result, iounmap does not free the metadata
> > backing pages. Also, the first iteration of the teardown loop
> > unmaps the entire metadata range, preventing subsequent iterations from
> > finding their pages even if the address lookup is fixed.
> >
> > Factor the page-table walk out of vmalloc_to_page() into
> > __vmalloc_to_page(), keeping the address check in the public wrapper.
> > Use the unchecked helper in kmsan_vmalloc_to_page_or_null() and check
> > for NULL before converting the returned page to a PFN. Mark
> > __vmalloc_to_page() as __always_inline to avoid an additional function
> > call in vmalloc_to_page().
> >
> > Move metadata teardown into kmsan_iounmap_pages(). Free the backing
> > blocks while their mappings are still available, then unmap each
> > metadata range once and flush its TLB entries.
>
> Thanks, I'll queue these for test and further review.
>
> Could people please offer opinions on whether we should backport
> one/both into -stable kernels?
>

This bug is quite old, and it only causes leaks in a KMSAN build. So
stable backports are probably not needed.

