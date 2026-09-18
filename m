Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDAEC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC066B0088; Fri, 18 Sep 2026 14:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89CFA6B008A; Fri, 18 Sep 2026 14:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B8C6B008C; Fri, 18 Sep 2026 14:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2806B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:39:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6656807C3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:39:05 +0000 (UTC)
X-FDA: 85227745050.24.BFBF37E
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF72910000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:39:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="G/kdftxZ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789756743;
	b=Mr175bE7Hk44JOmzaUB3xnQwFwrJZxfIQNaWSodZDo07jWxZm8QeD7Ibi3qqRjVzSHg4E7
	XdqeDj0G378uJSP/CwDQxQOYM+Ry45vxvMu4LJbr2/H3muOuANt9ffC/nNYjKFYSVJ/vIL
	/Jrd0EI3ZpUC2YJ8cpO3VbzXEjD40cg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="G/kdftxZ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789756743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/PB84d/lutaFknFbosSYBSWvR23ySHWTldZ0AWxcbo=;
	b=Mp8JKLWIR/BOxk23bXZPZyzLiYF1mJJYGFI9zfAtIGUV4eP32AQ1mA6bBT/UvEPHtqnnWc
	hrm238XfrdghiZhlZ/w5nlrf1ESZI49oWgq9ec8azSlKZS8wa4DlViSWBJk5lQzmG2COBz
	kJ9BbHFyd2HjDt8XlZfka4+EtFLu1/E=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so7949445e9.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789756742; cv=none;
        d=google.com; s=arc-20260327;
        b=mx/Uy7TTx6M/hJoWp8G1sh1Qzh11kKpDycFKUij8W5XzUWcvCL8owQ47xEQcgvU9Es
         0s+wb/IjMRQDUCvjKobupj0HAz7wyr9Tk3AOwGFIDu7wHsM0utBfld2mbN4f5aSfQgPG
         BvQh0AJfIo04+3N+wLyEP/hZ1MwkkR0KTRg5DLDRKnnbneQ0p6LU9l92vmZmbRDnusax
         ZnoMcZmNRV/pypatyqtIZTjqCIOQ8U5w2UCp68GCA/rh60/eSvo3dwDPMw9iYR0h03M1
         29Ayx9dExk+CeteG5S3fYqq5o3lvc/Cwb/aOjXRf66y78xqGNzaR6SzOB7uYIf2pNaiQ
         s+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5/PB84d/lutaFknFbosSYBSWvR23ySHWTldZ0AWxcbo=;
        fh=jHoHatj3o38biH+UzuobFmmkzKfzKj/FRgMGjE/K5vk=;
        b=NA5/8/0FNJAAG+pOtPlga99e94xSF/vCumHgz4trsq+1Zac8qxS3eTwTp6xEienKP1
         4DZ0OeaC69Fuzi8E5bvzRyknAEiyXmNgeDNI11VVRiKKIALGSV25g1q9YCQCDC86Ofs9
         IhkE2Dinaxu9NvugJQjXuh62nFt4iyy/dt+KB8lrE2F9SndeEgYKGM5uBya6Skz+5Zf1
         dAeEqAJrTkvUEcGInqJhl6Zrhk03UXaXXUvn1UWEPJGLi13FINtZ4U1HUGkpvOEkDmrV
         bcyLf6jjePtStEf+fe7U6EjKSzAifaJ9ToIcVTksJMtJAGkxMWstilWbKJJh0/JB5TKn
         uM+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789756742; x=1790361542; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5/PB84d/lutaFknFbosSYBSWvR23ySHWTldZ0AWxcbo=;
        b=G/kdftxZnEiSV+A2+8P5U4PP+or3D3QXF9YkNKl/zQjcSn33hZRUQdP/OoUXMRDk1b
         SMNin2bIPuNUNH6KnUAeNEmJwTIsNmS6i6cdPgDN9DhmXo0By60ViYn7u9aD9sB633yT
         eTnbnM6nKOtaacOAK47BqJeJA+dmI5pLGfats8J3Uj6XfjFyh2KUQwmL2z8QMtrQLmWU
         /YY+rRvCUK7UySqdwMsdeAgzxdUvBAAnkQO3rFYtiMhtzJsDYXYfP9GQ0DAj9b69cpmn
         CSi+320PhS2Y5NoZvne9oQiiaVqvKw8BpLJI2w6t31zeplWgx2mF7SozcGKOeKKpNdkT
         YVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789756742; x=1790361542;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5/PB84d/lutaFknFbosSYBSWvR23ySHWTldZ0AWxcbo=;
        b=qeyYa1lRxLpJ2mvQzEyVWpPfEv4rja51UWRlq05x8U6fkqmoeAwuk/RazYvmnSsFJZ
         QMyixUA0YumP/7mTQAFIH1sQPkvaboY8B47zoHbNzSz3kRrjNU/vgJfpxYDZAWILyoU+
         fecKFSij4hBa5NB8YvNnzBK/jPjSl2x9C7roOSyPQMCnCEv0vLhACo3UCeG/vlrqxaoN
         S2WXxs+KiNUW6GKtXkZ/9JQjmx40ygOfupqXK48mqgSGai9LN8ZrUs9tnt8gHiTcRLOn
         gscT6BrKu98ljOPHYLTd+TaQmTnwAYl/+olPxblbO7b00gW3dTOBYoV+4mkX9QvGK6lr
         Gl5g==
X-Forwarded-Encrypted: i=1; AKwUvBzLPa0eCYUWhidm1zJ7FJSL2oFdHJ/oMT7yWSNVvorLbAjSadFZvNw1jMxwQNaN8CH1e27ffMlyrA==@kvack.org
X-Gm-Message-State: AFuF++k2z/abzQiUloMmvlvKTHXxSXeEEXLUlfnJ+Kvl4IvjFhcskhVd
	eqHT/fXMoRo4HxuPJtYrLDCmcW+G3/yp/n8iiasqLqLWJ+9jrF1pY7W8xdjAzoZ0XUTfOsEqClX
	NuxbMkbooEeXu8lf7t6tKqU7rD6c9/O4=
X-Gm-Gg: AYBFou0rwn5J03vJv2crPj+ImUUiFl1HQaDurPy6balVeHyuXPBcAgaQhG/PBOFY8m4
	VRzW85kojNp9nIgubC7SG5t/rSt+ZNLPtrdZRED+GvXHR2MMhMZG/TvKO2txmdbmyzteFBTZrWd
	I65doUpRt4VmgBLX7319sTCLbLHYdssFTkWyi77BIQwYepXnyvdayzeIHZTtU1OffOQCe51hnJ0
	v5+2j67Z7HGYSeyHqJSU7wmnqozghpS21EqQLd8SEo1ov65UPMigO+iX9RTUd0KpPJ0DMvSFeT+
	azeSntHUUBNzzVjwPsVhRqxre6WziS2yIKnoDYR+QO4IMD2Hha23fFjLOF6gbAlcfJBIggfHGot
	0uLKBHN26+8M=
X-Received: by 2002:a05:600c:3f07:b0:49c:ee01:8c53 with SMTP id
 5b1f17b1804b1-49fc56713c5mr46641755e9.2.1789756742167; Fri, 18 Sep 2026
 11:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com>
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 18 Sep 2026 11:38:50 -0700
X-Gm-Features: AcwNN1Wvf5cok67nfOV01MjLnEAhXsQL9tKGdT3-XrD1J_-pQ2FeWcoNTuL8dyQ
Message-ID: <CAKEwX=MO7JjfTQU4NP_L6Uepk_WL0jYBKEB1woK-8brvQqCT=g@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] Virtual Swap Space (Swap Table Edition)
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BF72910000A
X-Stat-Signature: 1hdstfwkikz3arcfseqb8sibn6xcrq99
X-HE-Tag: 1789756743-994399
X-HE-Meta: U2FsdGVkX19aknDwbUmTMDwMNGs2S2vs3tTqLPMqRHkaQcBOGzzMvLlKOiB9EkyY0e2dGR+Ib7n28Ec7utDg9DzWytMz01S0s6M4E7wQkysrNIda2xg3gShy+EgHgGvKZ+5hzQ2WsirHMUvyA4F+HgPxi5RZspl+hST+EbrMWms0pHtcW0JKjKPwBQoxrcFqpe5Ay0PGxbkogvkeFQ08kkqJ6mgMnMx8dM/cUY32/ZiVZ+RHGLXeAWoiCkXQsumelloSdfdkmdjqiSVspJuHUTpgWrRLkLJ3aNtVQViQUN1RHBDxVjuG6QlnlTGWRi76ck35NRB3EazIKHv8hwnsOtUTEHmqIclNNiyHGkHASvHM8/Tw9/LhMqHBmkkTaJLlF/b+AMpE71HeflitW6XBNhvCJD8Ct5yg8JIdVdHFMhrU8i7ZSvEkHXsDdWSJNI6HRdDW+W6T0rqY4nfQX9UV7LfXTnpTBjHTcsj818mxCHTCu7lgUal7a6eSF5/FGvHf2gxjsFtVYiTjzH4uBf7VJGoBZZo8IFAOSvhVMJDFsTt3z80ITyfdMuSGLexpoQUbbHiEojJB+lLrorqK9zzSVIZ1rsVzJpZG+fmXwJMCSN/tqx68a1qx5/CSB1fmG1+Hzfc8NVGqcDrykVlR8AS2Jt6+94Ht5+eR0mZuV8dHmlyCBGklM3GqgLeFDmafzUDOGt1/UTRS8dTyGDDrUw6yl+UDE3LfhdsVkjEXvZFH14KfY/3mVCNISlzAlYddc3ZFswrF5LXrN5DtnkYbriScOS4Wev+WZW/T/nagGpGKwD2n8TaPGClF4M4KNVOTOPpP+l4YzM/Qp8HncK+drbzASp0gZkOkbQmOAUwb3miUOnDUG/Pw2N2IeW7dgeglZCHYXJG6SnmMpkPO3gDXg/SdNtMV0vyZ5VdlQM0vtkwgrdgH1jpTbdzq0W654cmfrMKPPcO6N+GyEJq51aQFeYM
 0tcgWNYG
 2nUzBtD8X/QEFet98/y5CPf5rjZkPzTZaczpH+rVXjZMbyZoptZ3GxDATKa/neDJ20B6IrFwvVQyJGxbU9d6fA3hZFFN7ULcfdjvEpcFzXdPndfLdScnhJXgCaBaG2gv9Wq9v8LrzLWNcohDZUQubcqu++QC9Ms6ZzAh95K7iAIfmq7wkRgA39qv2f50K2lGZQc8qrpHSMbSZ1/ZYPzjv80WbLYc0DFDeleSOue6zDjD6PZ59mYieBAywVGgAPwfqlS4mDaMhQpeCaFGWB8H6/ZeoXGMIMjQv9+j2B8Ur/0sDOtL92uP/1GLgKck7V5mijJggRp9nPEdh9Y7X1YWfJAh7xUZhUoQbPeS5Dca96TEBc7BsrADBWBKSc/5AU4la/k84jb6TLtxMmn0EgCJWWEy8R/Z7PWZfZQ4qIO215kwFtdLKh+b9SfRw1mKJ7Y3C9plN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:02=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> Patch 11 is an RFC. It swaps vswap's cluster xarray for the VM_SPARSE
> vmalloc array Baoquan He designed for xswap, to show that the data
> structure and the device model are separable: moving to his is one
> self-contained patch that adds no userspace interface. Note that
> per Baoquan's commentary (see [5]), I have skipped shrink for now, only
> freeing vtable when the cluster becomes free to minimize metadata
> overhead while keeping the skeleton in the free list. I have not done
> performance testing on this patch yet (the number is from the old design)=
,
> but I have run a suite of simple stress tests.
>
> It is adapted almost entirely from Baoquan's code (see [6]), so I have
> kept Baoquan's Co-developed-by and Signed-off-by tag.

To clarify a bit on the motivation of this exercise: Kairui and
Baoquan raised the concerns (for e.g in [1]) that if we were to go
with the xarray as a data structure first, switching it to the
VM_SPARSE vmalloc array would be difficult. I want to check this claim
by prototyping such a conversion. It is fairly straightforward and
simple to me. So it is not a valid concern to block the landing of
vswap.

If we are to actually switch to such a data structure, Baoquan should
be the one driving this, by showing that there are performance wins to
the switch :) It is his proposal, so the onus is on him to drive it to
completion. I'm happy to assist with the reviewing and testing!

[1]: https://lore.kernel.org/all/CAMgjq7AHRzBsbmGOx0s=3DTQFBwcn=3DDEU1naR44=
3sO6x+pJd6hAg@mail.gmail.com/

