Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF64D0D17D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 23:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2496B0092; Wed,  7 Jan 2026 18:21:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9116B0093; Wed,  7 Jan 2026 18:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD58E6B0095; Wed,  7 Jan 2026 18:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAAE6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:21:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1176B8BEA5
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:21:02 +0000 (UTC)
X-FDA: 84306740364.18.A16E804
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3B1EF4000A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:21:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hvUt2Zmt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767828060; a=rsa-sha256;
	cv=none;
	b=LrZQz/wHPoEEfG1MG2bCmrA88CSLrEP8yQ9MU+Ejo/ThDaucDhW9kIsQp9s3qyPu+N+Yxw
	O2/npmAUBMxb5q0OABt8vqJhTfaUw1i+mkYhgB47oekY26/D1uR9RrVt4LidI7Q7D5p6Fg
	xKDXNR//5jp+nVNyg+9yK6uKE5+rIpo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hvUt2Zmt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767828060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCrjzEZQwv01G+U0WIfJQs+VO9PryBUCb3CgwRj0lP0=;
	b=T8vqsXZuKrTG8d9alf5qsNOPzW0IsdEobIRmuFmbDmpbKt7ZyRk7gsidBILf5nXWFus6nM
	QhsUm3HRusC1UYArUK2m8KD0nMH97mPImt4tFvdGTZOiFDava4Q9rp5GdqcapcLo7EUXYp
	JdMHJps7i92GAZLumyYpqnm3EK05laY=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ffbc2b861eso8862351cf.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 15:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767828059; x=1768432859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCrjzEZQwv01G+U0WIfJQs+VO9PryBUCb3CgwRj0lP0=;
        b=hvUt2ZmtpIs0XKr7wJfDbKYlgEO7Z7pS+op5TVPZUmenu6n7MkwkodRgbyEhjRtz/7
         715YpcdbpmcKmEkoWJEFMj3kvXWdRdWUQUlcXXgjoRnHMh5sziaf/nxYhEm25lAdvsZr
         3QUTUPRRZOymD0LsQ4+FTto4uYt3frbsSz8E1zh6BCXClaT7HoNtWn8nWGt3pVQCfVTp
         YyGN2QIHwgkkRhHl+R5cMzyP9KZ7fdKSurFEdfDhALAofxQ12w04UhJaiJcLcjv60pqr
         iGq7loxacfk8fApGUgPVBIw6/gXiVeaAP46XuopUELzlqA1OXVPL52phjnqBT9JU8zFo
         cWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767828059; x=1768432859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dCrjzEZQwv01G+U0WIfJQs+VO9PryBUCb3CgwRj0lP0=;
        b=O4HSE93vVb0mYL6e2+eaMHSC5+Up+GGrS5F6ZFmKzgBtabJ+O/U7ORn1qBsjgNov25
         5aSbnUl8KzKFoIjr8i7MbVNmjcODWNovOGNgoiHFFevCixvQImIxu9PJ5UIpD7UrChKh
         2UC5928Xi/Ulp9SIKIUaIyCJPVdbT1xZ4pbO+Lp3DSHfaiF71SBBBkmEonqSpN3eIDFQ
         GhwOfdSsMIO+J7rTQv9o0Jn74lvnS9xaCwahC4JRjQxDhGwBafNjwuC2TKWREhA6R512
         m+fFKKMUQuf35G8XjAd2yjS4Q6evdUOLj1U9qUVXKvOAvsy8GnWUyEyK7boIheR88mY9
         BWAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp/gtfYn+iT+AukJEs1Xne40bajczBtFOKdo5iBX6BXfRcrDtgoy+CPqFYtDUPURwWfjAUVb42zA==@kvack.org
X-Gm-Message-State: AOJu0YyORYTNclz/DdU+wr1Izm7el09S+kAVXVsirssd072M+Pm+7dCd
	oZrwlUFjPe+aE6MfSMbcouChT9UGUTMI0FGWxx4GELsgI+u2e6SsS4cKhz0p8Ss0ezSpBG/oOSD
	vIhD2ZClgogcI7Lvmwgh0vkqXtjZpznY=
X-Gm-Gg: AY/fxX5JqJv7NrK8qjTU+be+st1rJwcG9zfMdwX/kTCGttIothxZmqWJt1EVtJtCPQA
	jNYd2UHDv/NUkjg4Lab8OcNOxtg2c7duCOFzuLX+v1cKENj4UQACE5mS1t33+BNdimFlnA1/itV
	DRhmc4Mq5p8RpirayQ3Xh9q0sam2vqtHJphhCKh0NY2ZLPeubMaTEkhuHgN7oxc8O1S5Cs1aYFc
	BP+ptCsfUdd4nZ7h2uDn77Zv8eG5Qz+NSRXplrkCRY2D+X8D8EsfSeHt8s/DP5MVCe3aQ==
X-Google-Smtp-Source: AGHT+IEiFeqiqTBVau2o0UwF1CseRs5J2I2K15YUqe72E1rmIA/k0t28m+0gQwUsMjLpxytNmWX8UDtYFxSJ2+hi2Ac=
X-Received: by 2002:a05:622a:64a:b0:4ee:1f5b:73bc with SMTP id
 d75a77b69052e-4ffb4a76ceemr59244041cf.66.1767828059316; Wed, 07 Jan 2026
 15:20:59 -0800 (PST)
MIME-Version: 1.0
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com> <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <CAJnrk1aYpcDpm8MpN5Emb8qNOn34-qEiARLH0RudySKFtEZVpA@mail.gmail.com> <ucnvcqbmxsiszobzzkjrgekle2nabf3w5omnfbitmotgujas4e@4f5ct4ot4mup>
In-Reply-To: <ucnvcqbmxsiszobzzkjrgekle2nabf3w5omnfbitmotgujas4e@4f5ct4ot4mup>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 7 Jan 2026 15:20:48 -0800
X-Gm-Features: AQt7F2rD2bYE74fC-BJPB9hchw_T0Hhn5OrF8uZDPNCgSz0wuN8d7B-9zslHZs4
Message-ID: <CAJnrk1b-77uK2JuQaHz8KUCBnZfnQZ6M_nQQqFNWLvPDDdy4+Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org, david@redhat.com, miklos@szeredi.hu, 
	linux-mm@kvack.org, athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, 
	carnil@debian.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B1EF4000A
X-Rspamd-Server: rspam10
X-Stat-Signature: gi91pqpm5m1u9t1ko1xkj1gybx1wro9t
X-HE-Tag: 1767828060-68170
X-HE-Meta: U2FsdGVkX18zaoE/cD0Nd/4Mr2CXtSDinZi1zWPpibemHzQ90kzkHj8HvmoWgc5W2vev6DQd4AI4+uUmkLaG5azSqr7AKJm0cuVqasZB+Q98GRWkPNqkRkEjoQyY26B4LABSradCc5hmyD0Vgx5qAF7Rkjc64R53MTqBahxlxUgmdMsk1xuG8Nfr7/nUkVglEOYFQjDGwhuNgGF1PCXr9AL4Xj9iI5hp3rLLffCh84kWANNxYzMv6Cw8zZxjs0iFs05jnRJO4D778HGDHxotqqqdvAVw01UB/BjANVvf2Su7Z2C8Fhz8Vy5ZtiVS5LmRKrM/ZcqXAONyICurJpClQ8ss4uB0xQtkgU2J6KYIRNCizbMILPRCYuTe9sH0OXwQ7JPtalXvn3d8oSkj6i2wHDtQ37ApiOeh3eeoxbuDc0ljUhA1zpzkqI8S/Fm5FfA4hZ2L1pLFkxHAKM1Y+3nm6faFw4Zzp8uI1TbtlvnKWNtZD5y7zh4LlZKqxOgpYWCyoswhaOzKsQXkeJVDQjsY+h1ynfkhcSGqIku2RIkYFFfQXZyiLjdiR//8ReDw/R6+vnrA2BBEJFgkn030o9uXoaVElalgKwBs/eZRPhRxKi+zdLJ2w0QEy0X/NVySY1drkMlY3ZF32XJONNnxLJPjOJE3ObfNrlNQ1AC3EhPyLK8PTHO7DlSAo4Lvb5afhfr0v7f22FtLs/fnxczOIk04A0qC4kge+9SXXBfXuh/W3VbNBrf+jrmUtmnGej/mfTGTN7pVYkZ0Qh4Ho1nOqQxJvGzdecqYcjDyVxsmVkm5sTM8qWvh9rF/onqbmcgt9VVBpfwfFJpjcKE3ph1uibG+x6SBrV4FLR04WIh7FH0HbgFnw3n65UXRaJYeQOrrf3uWwyf2dGot2QYMWfpqUZ1DnHX2sRaZJ/k68moWJ14I98L9iWIryaimy+mWFM4bERvRCSuJEUw+rMM0z5PX6sy
 IsNpbBWd
 QdAsyWhlX9SBQt/gNCEcJcBcZ1UbVhov5a3tUJ3/XoCzcRlktjGwZWSTI7SB16Frwxj82kKxNqRPs46Fl1oQ2X2Pwkc5RSTyX7aY8mJ7kUEeAmFYVbuyJrSGLKRUgfr3zMWrJXvPMnUpD4Gpi4m7nEBt9ytAWIjWyf0ufbwi+Ljho8A1hOQuyX9ih54W7m4BZnSpeYu/KTKafm76rsztrf5BFRxcCqjcIx1TIp6YwV6OxCaiTb1yViLSwlwAmHfUQw5POJ0/Eye9EVV3IzAN5jCnyYd/hhBR6j6iWBazy2gD3K/BMThLkuZD8TMYt7Nu86xuB1tU4WiCfXJg76SPuQ1rBPHLQSe0Q5bYcaeNNgRF0QJYuJRmTcGgnXZElrr9PLcne+sLyUt95hpCGHiWJ1g0pokF+d6mP9/Tlh8dqqyN5wyJRGXVJYJoqFYeBXjVmTR5F02TjfLI+fVtBajOMkeU6DmouHP3PYheX87sN8djVyzM+luQZebhLzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 7, 2026 at 2:12=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 06-01-26 15:30:05, Joanne Koong wrote:
> > On Tue, Jan 6, 2026 at 1:34=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> > > [Thanks to Andrew for CCing me on patch commit]
> >
> > Sorry, I didn't mean to exclude you. I hadn't realized the
> > fs-writeback.c file had maintainers/reviewers listed for it. I'll make
> > sure to cc you next time.
>
> No problem, I don't think it's formally spelled out anywhere. It's just
> that for changes in fs/*.c people tend to CC VFS maintainers / reviewers.
>
> Thanks for the historical perspective, it does put some more peace into m=
y
> mind that things were considered :)
>
> > For the fsync() and truncate() examples you mentioned, I don't think
> > it's an issue that these now wait for the server to finish the I/O and
> > hang if the server doesn't. I think it's actually more correct
> > behavior than what we had with temp pages, eg imo these actually ought
> > to wait for the writeback to have been completed by the server. If the
> > server is malicious / buggy and fsync/truncate hangs, I think that's
> > fine given that fsync/truncate is initiated by the user on a specific
> > file descriptor (as opposed to the generic sync()) (and imo it should
> > hang if it can't actually be executed correctly because the server is
> > malfunctioning).
>
> Here, I have a comment. The hang in truncate is not as innocent as you
> might think. It will happen in truncate_inode_pages() and as such it will
> also end up hanging inode reclaim. Thus kswapd (or other arbitrary proces=
s
> entering direct reclaim) may hang in inode reclaim waiting for
> truncate_inode_pages() to finish. And at that point you are between a roc=
k
> and a hard place - truncate_inode_pages() cannot fail because the inode i=
s
> at the point of no return. You cannot just detach the folio under writeba=
ck
> from the mapping because if the writeback ever completes, the IO end
> handlers will get seriously confused - at least in the generic case, mayb=
e
> specifically for FUSE there would be some solution possible - like a
> special handler in fuse_evict_inode() walking all the pages under writeba=
ck
> and tearing them down in a clean way (properly synchronizing with IO
> completion) before truncate_inode_pages() is called.

Hmm... I looked into this path a bit when I was investigating a
deadlock that was unrelated to this. The ->evict_inode() callback gets
invoked only if the ref count on an inode has dropped to zero. In
fuse, in the .release() callback (fuse_release()), if writeback
caching is enabled, write_inode_now() is called on the inode with
sync=3D1 (WB_SYNC_ALL). This does synchronous writeback and returns (and
drops the inode ref) only after all the dirty pages have been written
out. When ->evict_inode() -> fuse_evict_inode() is called, I don't
think there can be any lingering dirty pages to write out in
trunate_inode_pages().

Thanks,
Joanne

>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

