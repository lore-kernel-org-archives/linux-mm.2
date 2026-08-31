Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA870C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B8B6B0096; Mon, 31 Aug 2026 19:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82BA26B0098; Mon, 31 Aug 2026 19:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F716B0099; Mon, 31 Aug 2026 19:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1AD6B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:34:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3AB4802A5
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:34:31 +0000 (UTC)
X-FDA: 85163171142.13.1DEA559
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E87EE40004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:34:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2mLKBaJ;
	spf=pass (imf07.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788219270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAVWsBwACx+IpWMY6PFdTt/YVw93rBRGG3Ku2i4nYdQ=;
	b=XA/jtC2tOPxLP2WbHpeoxJLVIup3WtNuAp1MyymWYrbgO2QhdsfhYWunOVVeDC4TJ03J4r
	3wC4qMmfzqYKw9dWj7OcYQgoT8J+mK5YkU8/bvuqvQLPurHWCZ3Z5hiv1q5uqdKT9eYmPs
	2ssllkL3I9HAHf9djiISSd51hN0fMOg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788219270;
	b=x4paON4seBDhJlUQ1xoC+Fp1+WNtOO3NYvusUd36YwrgANpSdDCpECWg9QMAWZI7Wq1U4m
	p8LbZi740PX+SgjipcSCBnlKPGVB45j2jcFIInl48ZCB0yb4fWD1wT4ojc8mFDBrrvR9kM
	mZGP65iCxUKBrg/oqAJlhrv7VYgAoOo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2mLKBaJ;
	spf=pass (imf07.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1471E404C9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBD31F0155E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788219269;
	bh=tAVWsBwACx+IpWMY6PFdTt/YVw93rBRGG3Ku2i4nYdQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=R2mLKBaJIt1LzWR0V0TjNUPUtImXik5BxuQM5K7ehXNP1UMZMf7jQOR5oBFVUpHVg
	 ErfrhJa96d3agy06drbJ8deA1ZThRetlAS6lJsgf8N9xX/VgCel/c9nX2RPsIbk+Vl
	 mZQ4MLUXXNiD5buS5hI4Maw+XeiXbFz5FhA18C/coXBRl/n+bLpfKd06U+vNCQu8h1
	 nY7TFJZADOwRT9YklDkbOoEb/kaSD3kKZP5MeSySq8npkFBuKXxRFIMi1/moKTPHsy
	 qZiLY8SW2Ixim8bMwIMGsf80Y9ayQVg3pFcCp3LyrRCqDGlycLx4ftJnvzACzVWxu5
	 oOzf74WtBZbmA==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a6108734d5so6037562a12.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:34:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByXx06A7esMj9EbJu6DU9eVDkIWQEcSQrpJQZT1HcFs/sa1BweptRFP99WCTr5iVGkphIHAlfG2vA==@kvack.org
X-Gm-Message-State: AFuF++lC0MVptPcaRRDWYInamSE+CyDYLFyb/nX7rzRPDvjHA/Lj7cW4
	MfgYHYfm3zOTAS0QwpUoywLNOXmEHjiSifQ3ca8ca+Qyf9v93M3wixB9pQBGlkntSwCUQyVOPm9
	VaCI4T8jfvwhctqgjUMy1pqG9t/IOXOk=
X-Received: by 2002:a05:6402:3245:b0:6a5:f44e:a009 with SMTP id
 4fb4d7f45d1cf-6a663a4a9dfmr2170192a12.7.1788219267560; Mon, 31 Aug 2026
 16:34:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260830041901.2668-1-willy@infradead.org> <20260830041901.2668-6-willy@infradead.org>
In-Reply-To: <20260830041901.2668-6-willy@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 1 Sep 2026 08:34:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8qgCe0Kt_Pmpd+228LP+hCtF2shmVqftazX1+xrSCkFQ@mail.gmail.com>
X-Gm-Features: AcwNN1WHItk-3z0F1xUEgtAcqL_7gSvlVk8E7QxJwHtI0RZzvTtB9qGbIwZCYNg
Message-ID: <CAKYAXd8qgCe0Kt_Pmpd+228LP+hCtF2shmVqftazX1+xrSCkFQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E87EE40004
X-Stat-Signature: acbo9whekqhomixz198szo3gswrrofgh
X-HE-Tag: 1788219269-499808
X-HE-Meta: U2FsdGVkX19+u2iAlmkZ1DqPzSmDp2UZN/JQJH713J9+DX0v1umY2aoSx4xK4IAKxWbX+T6++eVEfY+8Ixl8zP3CfMGoYMfEsGvvusJ+pckb9KRJ7ZafHlnAwxD/qpj8uRkTSm4Fbf0a6kh80qpf6a2sIUIM2KuhSxqrBAIJqja2o55NJ5EQhBaOidIHr3fkY029WMZO13HqCGZeWphg/sipLKoOa3qOBZOv3aq0x+TS2TF1YjyMtdUHMfTtVHNFi9h/BwFtjYvt4xBU97Yh/bZhwWCO9iepjNbGEgg+tfIXAXljiWA6ZjqPT9M5CJh8+F16pjvSU23pZy4PaYU+yi6aY6qLxt8Mk840ceKwb7t0Df8PakAP5c3qrsHWZnVIMLvfXXRTmEskhIehffWBnppO7eoRJY6Go+RycbomLmSQbEXEVz7o+RIz6iue1NKZkFf+O9HPPTnSQ2fFv9PGmJXE1omhrRGzpZzUyf9wg4JslHLogJpL2tixISPw2B5UQIA6Kjt24LCUTGsjusdz5S3WtO7cfyKyQnsn6tHbWtgFG68oBF5YD5o9HgWcBvrU3Pl+lLGLs8p0n12m5ci/W6f/D2nxi1M2SiaBEog85XGDRB2rG9YrUPQ0EE4V4RlUHFZuwRmjS9K4fkRO39TgEuGkbyTWmRGmGddR2WqMuw2DJZbs+qxIAUZL0tRUtTDAdx8aB6sngXwdrkL3TAebn6wScty2OJGC1bm8M2HgbT9TV/lH2bhnOjIgvt3MiskYk8SrblCvzKDL6ZZrIPNfREtHqdOqrmUL/x1v+kvljrHE5bT3cczGqcbjsy3SHXLy8+JJ6/27UyAhMnh2J8P60ZCcF2X9T2qPPGVxOPBdtMTd7nZekKP9KhFSRfGnD98h1mgc0GcJhO+TgG6a1TD2DV4tgbVoksIl6z5+ARh/f0H6htd0fzR5sUhtcEYS2cQ7oJDyOtLmm+V0kHNrLUC
 1li1/K0L
 Z7stR+TnBuBdHLSzXRMCn3P4lvXrdMTnPykaVpAc8lBh6w53NHdU/+6ZxvXIhBVHbmJ+4B4fMkITpYiSBrBo1Yr7r1WNaCbHOkThDqBEv73ZsObYsXAk/KP99pX+ApgsuG3j2inWJsUa6dKD85PtWUidpEgfU9PLewDGa+q39mVFlpcB5xiFQDuJ4jSRWQSN0YW+ay4lP9IsQjgearD3B4oNpVDn5cPq8BjP0biDmNhfpWeGyHwn5R67rzzZX024ojfZF9g01qtHizC1DrM5ZMZnjuepVQvIzil40FTjsjM5cALlCPvNvEMEEgPIbE4JF+c/r598prIxJ4gqz3JQhTPECsiWIrs1GDdJe8PHKewA9FIYEPbc+U55bVmRaAbFOqa7OkoMTxhgFzePPWDDQiD0NJKhcuJBotyUamiajxruMu79iHOXh8CiTv6scRq3HCYITCqkPlC3bjXE3MDo9sIn0TqDSyx1gMSHXOjAFCBoY+tk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 1:19=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> I do not believe that FGP_NOFS is needed here.  This function is called
> from one place (ntfs_inode_attr_pwrite) which calls either this function
> or __ntfs_inode_non_resident_attr_pwrite().  The latter function does not
> use FGP_NOFS in its calls to allocate pagecaache memory, so it should not
> be needed here either.  If it turns out to be needed by both functions,
> then we should use memalloc_nofs_save at a higher level to protect both
> of them.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

