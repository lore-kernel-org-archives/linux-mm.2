Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D69C6C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2ED6B008C; Mon, 24 Aug 2026 15:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB066B0092; Mon, 24 Aug 2026 15:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0646B0095; Mon, 24 Aug 2026 15:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E93A6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:33:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B064BC0266
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:33:19 +0000 (UTC)
X-FDA: 85137161718.17.2A24547
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4480814000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:33:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=EsndiYwM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.169 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787599997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DK1kq+UORspwzlcL44O0F5OA7o6ZQNGRnMf+1R0tFOc=;
	b=5I/s+lqw+ndY6NRqX/1sJmFQG5dQXxtVs1WoghPQSdyBrVGgbUphd4J+Roh7EcjrqO9c4j
	h8JNOvykwHXXp+IpQCDehloSOE9DkMSkmZ1eHebESgfv7wjtxn4JFUHGYdSXY3R4/XmuSp
	WQ1eUFWS1N4iS2nGSaVfCiorSah8wqk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=EsndiYwM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.169 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787599997;
	b=fAkNrfhCPvMPWGX+YazukvPVFRhTE40DsAJA/CML6n2VF5v0WPuaK+G6YYgEvU6yF3kcRA
	FPVFXCrOJJIiSHsQ0PlktwF2/mEQM34KbI2itptVbul8Qs2kLeHqjzsG3VcUkx0LItL/uw
	4JJBPO8AxV6LFcDm6HxbaQPbaNIYevw=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c2a449c57so22430691cf.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:33:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787599996; cv=none;
        d=google.com; s=arc-20260327;
        b=OKxlISsNVv6xH4baD7Qp1RpRPL09q+N4tWpvsqo/44fVyCm3A3wM5b1wl22SHuvvBW
         KqQCHlnATTOgvCCzTQCQapVpqA1bSpYCziEjB+E43FC9LTYbmTlrztp9TQu2QGlMch3X
         D0YQ7OZYHDsRbpYLylmqFIGnm/VeW+4W83DkbLMZV7FIyqY3r/+47OlYo//H9yDOZqYn
         zqmaKwhYWmvh3dJT+UoWanN7aUg9qyXdF1N8fhSLYEy+ijuVIy3qAyGCrqqTR0Poi4TZ
         OKZcNFZYf46h1ga59LQ6981ObQa/CYL3Vo1kWsGx+K6Lzsg4MCZo4aPGl7fIq1avIOg0
         MwYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DK1kq+UORspwzlcL44O0F5OA7o6ZQNGRnMf+1R0tFOc=;
        fh=fwvilWqCxuRJ0e30KoNv/BGhSuoi4716IEJrzYfr5/k=;
        b=MQiCOIhXQ3UKHAeOe86JAsdP/SmmeUkou8geo8SSAmbNS9f3sMl3XJLfAzqMNv0zXa
         hBHbHRWVX9qOa/VYt/78BbvMYiGsyjImOi3kjwXSo9xHvRiM/kOY8FyOvTuZ7MaHSrmL
         VHkxTstj15Vu5eVU+/Y5wBKUAgLV+fK4RHNx8NON4m3PF3l5Bb2o/miIo1K9BM+nIzb2
         oNIEMiZeg7LSihv1wLMH8F8aaRCgDO08NDBukyLJN3S+LD0ow0lLGx1AIbWt7fV37RrP
         rWPUqZt3b16Jtexo4MaYS+5thPEhVSN5KPDlh+P1G4VtiYNibwD4tDP8+P2L160eKMKZ
         X4HA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787599996; x=1788204796; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DK1kq+UORspwzlcL44O0F5OA7o6ZQNGRnMf+1R0tFOc=;
        b=EsndiYwMMQn/aIZe1OyGAmJvLjxwF6TPPQ+Mzva0aI5lhOb/TsCOQbNYSp3bI2/lBc
         qmpSjFybB3n+3nZHwXqFa2tjUTisf8GR5tCT4z4yELPYPlxW6JM6IWtg6hUaaMzraGhz
         HCyuVAprncorv9il9os3unC9Wpgrqk77e5j6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787599996; x=1788204796;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DK1kq+UORspwzlcL44O0F5OA7o6ZQNGRnMf+1R0tFOc=;
        b=TC7IqIRK+CAMMA/HJ11kVCf53oBzU33kI/kX/3u880DCHHeGTcTCl5UxRDoEgbsI/E
         0m0cohzUpwv5g7eOJOMbEyNi3nvkfyzbhdQtgLw2UveJmqQoFhnjQJjB3BMANyLPNkjG
         GY47TZ0HRDMquuP58m4P6HkUZlX8aO6Yad0M5eGhTazs0vQdLd/0nHxgusLoTrHZObIc
         uynA/y3eSTORp2XNP2mwql3cXbmoemajd7b3pARDKueuI5QqcZLdPVXdVhbYYjleZxq2
         xF9IyjBzXxl6RnxbJDv3rRZ7Oy9EHE7gdrPYxfD1A6/qfRPRT6a6gJXx94A7RiYuQedL
         Ru0Q==
X-Forwarded-Encrypted: i=1; AHgh+RpYRnYrjCSdclCeqv5+1MW3OEdUdff0u8qjX+hB/znQPpsD7B7VUJNN/J4zYeLe6OAgX7dkgPvsXQ==@kvack.org
X-Gm-Message-State: AFuF++nOh/GWxUeR76yUhKrk0u8TLOk0VFUwji0KAiDs4D5nu5Zlj8OS
	qGZpcr7GW+QN/1RRdAYPFcXxCZxNPb40W7dXQVrCMbzbFozTITFLREvHSu/bt1KPiLBWDEFDAd6
	92S1yePtUjZjEHfa813tDFSRBlwsN0yluShTd0WvyzA==
X-Gm-Gg: AR+sD11IytqrreNa9LwS9MYYPojKiaDJC7+B0o1/vNboMqHGkdgG5VWSIP3f4+Fc0uJ
	tyRLhqPaW9u5TstH2E6xlxQxLvSnXLwOs7743vUCsiuZ12GQbxMBbN38pO+iqKP472/cQ/V2uSp
	P/MupNXlCKg2ZcH1TeqFNivnzZk6FM7Dm6ka8tvUtlHj55vJQ3cfxPiGXs/ZrGYga+gINUnGzAu
	okzO6V93lZTb07azQGp4XFK0cPrBQjGIo7a5g6KXatNkfNw4CWAaQYyLAEMBOosfa12qjab+cuA
	9ksDIkShE/h9s6rl3mWOMDKYzbJSCoHI3ct7MdLMnd8LPyIbxsyMrwwXVxbKnFcWxjIcmnb1TPW
	yUZk=
X-Received: by 2002:a05:622a:411b:b0:517:78c7:d93a with SMTP id
 d75a77b69052e-52df57324bamr286714031cf.16.1787599995881; Mon, 24 Aug 2026
 12:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260820193343.3852967-1-willy@infradead.org> <20260820193343.3852967-3-willy@infradead.org>
 <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
 <aoxHOSC9kTPbKeNq@casper.infradead.org> <CAJfpegv3Ak+qNLb=fTSCSz7-taQ3Ui-Hkmqgn4PaGPe=CR4cbQ@mail.gmail.com>
 <aoyKxvdQdeJQfPHj@casper.infradead.org>
In-Reply-To: <aoyKxvdQdeJQfPHj@casper.infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 21:33:03 +0200
X-Gm-Features: AcwNN1WHKWPg-gulrL_ybc1YuKIIGquGv3tDzpc2zs94XwMFk4U-dS3q1iLbtfs
Message-ID: <CAJfpegtgenUaudDcvecJuV2_WkkVw=gdcB0Eqg=UFKPMZP1uKQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4480814000A
X-Stat-Signature: ktsyie4wkyso1cuutjno5mycenyjucam
X-Rspam-User: 
X-HE-Tag: 1787599997-275753
X-HE-Meta: U2FsdGVkX1/l6bw5QAOfKcZd0Izh989h1kLv1tYUo0AvlXG32RxhxMWsqbm9TfAKMG/+x274+RyqHmJj980qMQScq9HMTeeGMOdrRpN/NAi3VYBAZiC5mhGZTWHGbvrumSpqD1zSyaC7kpasFwFyqgnWKNN6Z/Am6dbA0UAU9NuYrt9YQfqhmwqH9Q2yUmvoxyV1diBZVcKlySYByuedSVNwRIGVmKnjFsv/kP5nx4Y76KlSgaPfwETyqy8XUE/SQxrBxBFyqATucyhWD/k8pTnl3Rfq9xZA44+35cI8flNJUYkV+HIivMfpULwgsIBoqlKDcsjRzQjCI25RvOmW6ZalSg2Q7wbWIH6NRmE93aeAJBTW6ZmaflEkmXdqHfuKPPLB4nd+z3IvHYgLM37aZRuDKboJV4vjEd06tl2dFTS7LieFLo3ugcCtgVpm7coLiMMtuuoXP7kQaSMss93Tsw2caK9iuzpf1oXkbqdRGyMfanbhP4+seAW0ceR0favGQRsjMFkhekGvrCNcv9cQ3nhHaDsXQSWw5NZ2OAPTbc9jBGTnx3eEvL27DSAHKqQZq4wbYtDNWg2YdltEld4SpCHiu4bLzq/EcfH7xRr+qY4Cc1qgwMTdgQCcJleGn3h+rQv16Hy+7eilpJqioJJIoANtehenunY8aiWOvkuLOYpl6eVg3xT8501k17OgaMnUc3Hpr9C8MgrJkGvESb7ZQI4lJW5yJdrr+4LXhGQqBVqkUsnB45uNGHSjl6Z0heDDVdKioqf1+gTP/KlYNjxtzqOm3V6W6oU7/9fGP71A44BSHzBGV21JujtXR87PFARWmi0OX0SERgPOAjA2OEjUBUzr5gKx0OT/Tpvivxdl76692wKKAd2at7bCIG62od+0WywT2n05q0knH2a2MxNVDDPzzBNzLvYHmr9Ig86BuJPF5LMx35Pd3qg/ZapWfnLdan94hG64dV9YplZ4fMG
 7BeCFsuN
 DsPAyV7aHsO6tqzXgKkfVKdLKvQyAXrVsmm41p5Xi7rE2PNxAPTcbr51dYON2Gufv4uXWkhBubuJlwp1viWXil/ERKSXproqUGVMrvoQqaldOtPQvmpXGiP915wtOO1l43krrs7ZVyYqx98Qq1Tmkxy1YIxhp/tZpd6/SsSpWG1HTyp99A5DfxwfvSX44R3n++2wYcN1KRJDsk8MfM09m/aniDQsby3JmddmLZx8LJntxmz0j5r/N7hix+FNu7nqVvFlq/vN6WT+2P9tWrqys0zLSy3czZQUuO7tvUrC+WJ95STzMQkwa8sBvtqf+YLE8hyOrmv1PFMGzIZm7FUcbS7G6BwBEOHJ5zQ7DCWZP7UVkBfdfMhGm8NbPS+Go+V3aU8pjHgXc20a/Vm6/MoUoPlXmWArhBP2+vfTJlF6LPO61kpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 at 20:17, Matthew Wilcox <willy@infradead.org> wrote:

> Before:
>
> fuse_open()
>         invalidate_inode_pages2()
>                 folio_lock()
>                 folio_unmap_invalidate()
>                         folio_launder()
>                 folio_unlock()
>
> After:
>
> fuse_open()
>         filemap_invalidate_pages()
>                 filemap_write_and_wait_range()
>                 invalidate_inode_pages2_range()
>                         folio_lock()
>                         folio_unmap_invalidate()
>                                 folio_test_dirty()
>                         folio_unlock()
>
> so what's the serialisation that the filesystem can perform in the first
> case that it can't perform in the second case?

In the second case filemap_write_and_wait_range() won't write protect
or unmap the page, so it may become dirty after the writeback.

That can't happen in the first case, since the page is written and
unmapped while under page lock.

> or alternatively, what's the serialisation that would be useful by
> adding a lock/unlock of the invalidate_lock inside
> filemap_invalidate_pages()?

Nothing.

What would prevent this if we'd have writeback + unmap + writeback.

Thanks,
Miklos

