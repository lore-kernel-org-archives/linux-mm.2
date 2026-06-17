Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2004ACD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 19:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0762A6B0088; Wed, 17 Jun 2026 15:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F506B008A; Wed, 17 Jun 2026 15:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E6F6B008C; Wed, 17 Jun 2026 15:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B208D6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:57:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1201FA0546
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:57:29 +0000 (UTC)
X-FDA: 84890464218.09.0398025
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0943F180008
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:57:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LajOphUS;
	spf=pass (imf06.hostedemail.com: domain of avagin@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781726247;
	b=fmsNh8JMTx5AVm56W2OGKTs7Bycy9cXmb+7L3piwvbIQWMBI6dy1172ZNTAUOI61aTnjOY
	Ha2sXEpKl9r1/wMf8XOn9WjFqFIi22EexZSjSD04jLzwcO0MEtzbPxwQUJPOgdPelx9Fgj
	ynerD8WgMlBpZrJScZTNUOI7W3x1Huo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LajOphUS;
	spf=pass (imf06.hostedemail.com: domain of avagin@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781726247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
	b=dEUMaFMWk1genymQwQ4DTAkl2h3fqvfeAytC/waEkvSREf5w50IwJj/fjWBtx8NtBkDjNP
	PL3uXPFAcGY2gwkN0x1oMaG7nho4hu8BaaKfIPPF0RbOim73aKT0z2ThmYEI2f82kNjn6y
	RCkx6yNa96mm2SwGlCpq4aKIn57icNk=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-69e4a083687so163106eaf.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781726246; cv=none;
        d=google.com; s=arc-20240605;
        b=HqTOPVu48kOyxRQe1N6yvf0fhn8PySPXHbwYeUfp/nyktka8AExalm9xydWuLVLUvb
         EdN+eZ5mcYG+5U5svcMASn/VEkfnQkOTtXsZU+PdvQZwT9xiVev5WEnYlTYWH2VxW51l
         gVR6cQsXxkC4rfB4cXdo9P/BFrd6HUyJx7jb3HdFVawbtgMPC+ChB6Q6u4wUgO3DSRxs
         eLOfYlulmH1SVw0VSJ//sGKRwpWC3gV5XSKRiIzfCGuVZRzrfnBvSGp1PkffLnpCMLBm
         x+DyRTAXgO0qW9Ao57zVXiYnRr2/lWMETfawXmuxMDRRzXnMFeXqgMJ4OE0xpSOouhuT
         gCtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        fh=Du/P4SAbrYaXl8FbpnvKKBAPbZa+zAz4W/T8RhwPvvI=;
        b=goNkveASLWYYhyPq8CcFf9NNvvPXuRCqFgVbgpNxWFkN40XtK7p3wokq2mc2bs3zov
         S5FGcsXr/jUWqqqW/9iwT3cRkPk26/9vgG0rpyXfNrQAT1P7VaWPWbVaKf/iL3ZJh2lw
         pURkS4OcAC0Q3ZHMZl2mlCJkVHQhJciPYGTTp/P/z68lFaYRTmmCVZFwdzGq3IdFJPxD
         tYVOzpUTXIiwMbhrjAyNnvElpOwj0FqFjmBI+MYArrNBbI6ltcnSeUJhVGJxQinZQXJi
         TdJcIvkdmWcxjJWgJs9FtygWEJRA0Rh2ALvxBEBbiHl4iGdRw1v0fnxkDEvaE0LBG0Tq
         OKfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781726246; x=1782331046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        b=LajOphUSSOPJB6vwwOOxbGkCDNzswAaGfohnhspApnjIC+Er4f90dZ/NObuD0724G2
         v7QsczD/9NXJW6mdznjeXdnL3BHpl0mGWzGuguO7HfKP7BckEqD7OGIV7kKsBOArsr2L
         vNjuMqh9Ir5KNMyIzoDtNPmUOU9vR23PA1cowAhWn16+hsvqbaHlIvv9qucbWFf57nhn
         XdGs/a8nnI+VodasE+EzQgDoBH/p6f6/v2m0DGX7uKrOmhLZu4nd+8RE+UeBQF5akube
         6Nvz9QS3Wb4ERXVp+0eMuyBIQ+6aNjgdb6wG07Du3rmaBq3Z6FDhyFLmEJb9vhjEPeGm
         cyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781726246; x=1782331046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        b=TB+POWU4a8lKmetmVuDghMN/k4+aBM2Wcgxo6BFi4Tq1GgN/eHAp4bupaEEXt4AoUF
         CDnIvd71LMpE4WHr89RZJG7P0ygxG/ZLL2CFvJtGPh2sYuoEsLVo4C/saSYB8LWG1PNo
         swaKE7crooilgjBHsOskFD++Jt1k287WftjNrbMl8Cb6drM7vyREv0Oe0/zyyBuCw9rq
         toLHcCcuwyGGBpgyYQzo42rilUB0d8B0AOUL5Ns0JkDNAvdkSDe/Rl7zvBiiu8MFercJ
         i77jv+tfT0CS2UGE0Vjovp9EM4n701kxQm/lmFEI7DmY5PUnYrBTRiuy8hKYaV8C+NBx
         izGQ==
X-Forwarded-Encrypted: i=1; AFNElJ+bOdKlaiifIYdyvLksaQ2U9dGdwwb8KyJeepSDOPCWEt5IeCUTGfR6R4fVK6U1mM8RYI1s5qykYQ==@kvack.org
X-Gm-Message-State: AOJu0Yyw5jNeWcfEH7mxtPunMyIqeW3MNvEDTvFipdjDgaJ+MMyQ1O5W
	XmwXWCsSnTRjtEKwEGhy/wU3CSuFqU/8eEClmpUzHgs+bVE4n8S64aX1Au/j6P7UGZYktaZdE0k
	E2E05jCXEQUnZqCV55IZDynJak8MzgCg=
X-Gm-Gg: Acq92OG86m1njuo1Y8tPmEHfLhHBteboGR5wiLaVkJowTdepAzxphcv+VTnXcNtBuZq
	eEps/mHGFGWaf0jhMw8s5wmjsOA7YCqRJoGjFGI5ZyzSdlUm+dYiXlo4PpuQ7YMx3lzT/W1GwRb
	jK0aO7Y+d+Vn7ao5ixyyHZWyOBm6Ryr0GFOSAWidlCcW4sEmNRRYPSl+Jg7f7pYzJ/ZIA3RD1us
	9QSX9wbUDEeRmcXlO5eRiPRJFqQxstXo3BGWHUJWhcGQwaNRCqL0JgAUHiJueFUNOhhOqg=
X-Received: by 2002:a05:6820:1c90:b0:68a:f494:e8fc with SMTP id
 006d021491bc7-6a0b60c0b36mr3762306eaf.33.1781726245995; Wed, 17 Jun 2026
 12:57:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
 <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com> <20260617-attest-gewechselt-tragik-7ed473860051@brauner>
In-Reply-To: <20260617-attest-gewechselt-tragik-7ed473860051@brauner>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 17 Jun 2026 12:57:14 -0700
X-Gm-Features: AVVi8CcHFrVPI3Twv4VAYTkdhufN4WGXszz_j2JUYmYPkPtYdrsmDFCM1RURvTg
Message-ID: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Val Packett <val@packett.cool>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	Bernd Schubert <bernd@bsbernd.com>, Aleksandr Mikhalitsyn <alexander@mihalicyn.com>, 
	"criu@lists.linux.dev" <criu@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0943F180008
X-Stat-Signature: i7wfgrx7hzti4go63yyo5aaioj81e8w5
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781726246-949055
X-HE-Meta: U2FsdGVkX1/IqNWFY4XFNovwGdjyarmGjR5LKZ/s9bhI9Ioxd+CcV/ong57D3mCJJAovjQpF2KWqaS4PZeSRpEtFFbfaxG01Hyrz88eJIF70RU8xV8EgJMfv46u24JdT5prHj979bl8GU8M1yNvnecPWf0dev8W1t/yZlL4lF+4zgZ10gP49s2v6/SpgKIKIqEVIhImMy2BQyY7DnXOdO/cKtA+Ojcewgb23VOEbSSKDGRakSZEt90/pjrsaOwUd/Ry3zOxJF7Pv6PcQyxsrOyR1Gd9O6/XTJXy/1PSgxCE/RhXGXVBG3Jm0sY39Q5IxvU2nAC3Py4q8g1c2mkaVefxRaPA338dOL1RIJm1wADq/jMJ2yJvjj8tcIebTGl5I9ftwOn89tCA4F6Uec2GPUfYMYos9PURQgmDgI3RWDpiQZHA3GD+RHEiEaYoOrp3gJ9ZYyjGMjLsl/ojodzkXbdsnmvrFnYsZx3Lc+b+TrGVFm5c9btp8PYJN3WVKDTWzUK/SBLZFWosNrvS81UCV1kjpDp5Z10jNzZ32rclcEQMnuT7bkM+DeuaapAlbLxaL3JMIMrvVzYnQKnnO3d8nQQ6G13cV+iIC1s5gG1dTaC+zMaiNmEWnZRFPeL92k4S76lgTzdkrk90KB1Kr/tOZRuQOeQuKq6+qxn8/OL9s663I+K2AglzZRjKFg9wlFQ+RoVxOwm8oujzFtojbM2JG9V8CNQWDhbi7BJFDyoNiN4GCyfzUnZ0yFO3o9kdk36SCSApQOkZ14mikVD8z96O4JfenFEMwIDlaV2eSy9nIQapwALCoq0LkGUjuYrMfzFMoWGV7UM2874R/yDq3zR3z3l2EWqPTC9S3P3rYy0L5SKL3mTFl0rYpJAzDhVAkujBhuFAajOKFWDmE8zGVpzw8q01fhS8vZ70I/+CUbFiqZSFGYuQ7TppUgqKcoqzq+OnuO/SogFrQfUtqIBPU+qh
 6f4UbCaT
 rsNTs53nGb6PA6giyslF7jU5eZ0UDGy3+N0/Ngd1PqqdrgjOkGUepQ96fiNBder8IENX+QFgD9mpJMKef9NzJNugDPkmPKTuHpD+ztcYzb4ga+Ex4TzMNSErrXhLNqQFEwvMQjGTvN1V1pT1uuAZJqpAA0eP6JCPYMQNOiF9FvY5eeVmbrPwydeV8AH47zcbVHORUwASZOL5M17yDf245tRFA9WMlDHFgQ8LdEjxqiE+ht5um5iTw5wZc9WGs1cpHXxDTE9NTfkfoIIokyhFirsCQJyRsCV6C1JcW/8cFPv58AVmLmfvhUo0rKlDNGoOuNzg+xwRtI7NnmEiswyHqTsAv/UyoBRhN+BDySrIfvsdqny4iSw7kEYlod0weZLgbuZf4qNClhWydL8vCtD+pn+ale/ma60DZoKQPcQM88uPY/hErXAJiGNd6XGUdg5WrcRGxqd7uRVCy5XfYybo+lyQh7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 4:08=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> > After this patch, step b) is a straight copy which means step d)'s
> > fixup doesn't modify what's in the pipe. This could be fixed up in
> > libfuse to not depend on modify-after-vmsplice, but I don't think this
> > helps for applications using already-released libfuse versions. I
> > think this patch needs to be reverted.
>
> Note, nothing was merged. I deliberately kept in -next though for a long
> time to see how quickly we'd see regressions.

The bait worked. CRIU wins a prize in this lottery.

The CRIU fifo test fails with this change. The problem is that vmsplice
with SPLICE_F_NONBLOCK to a fifo file descriptor fails with -EOPNOTSUPP.

It seems we need a fix like this one:

diff --git a/fs/pipe.c b/fs/pipe.c
index 429b0714ec57..6fc49e933727 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1253,6 +1253,7 @@ static int fifo_open(struct inode *inode, struct
file *filp)

        /* We can only do regular read/write on fifos */
        stream_open(inode, filp);
+       filp->f_mode |=3D FMODE_NOWAIT;

        switch (filp->f_mode & (FMODE_READ | FMODE_WRITE)) {
        case FMODE_READ:

