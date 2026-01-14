Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00290D3CC87
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125876B0005; Wed, 14 Jan 2026 18:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3446B0089; Wed, 14 Jan 2026 18:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7196B008A; Wed, 14 Jan 2026 18:33:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF2D26B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:33:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 695B9160150
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:33:01 +0000 (UTC)
X-FDA: 84332172162.24.6126DBD
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 902D61C0007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:32:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eY+bqi/2";
	spf=pass (imf20.hostedemail.com: domain of nroycea@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=nroycea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768433579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0567rqepLL5XsPD+si1Pj9mYEX8MG0FAhzMdrDzq0/U=;
	b=OmVnQSwAi8eosPdi7EyiNz1fZcQcthbBtevtEB3wZj/ukBiN6KG48EtopZnSKNQSIwKK6N
	Isqo9bh3LrJCAKHy2hE3O4gXMIO8qgXUA6eoncIiJcrRDYiCy7t37nzZ3spgA+4z+ExuFM
	zdyn9ethwW7a8zsrDyx7hVoRjqymb9s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eY+bqi/2";
	spf=pass (imf20.hostedemail.com: domain of nroycea@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=nroycea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768433579; a=rsa-sha256;
	cv=none;
	b=Qp40tcY8xHXr0uBhNiqtrGdhImS5EaT3n7iFC44jN7QGdt23ELldQZSAhzylP7VaJaeF3X
	wG4lHgkPOX3UCfOs2MLLKXi21dtOmmoJEBVVlGL2/QChbBJA2iUknFHBkewQZc/ZnWqGb5
	5uKSUhdxVmGe0S1tsuc6ZOPMMidV1p8=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-121a0bcd364so453901c88.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768433578; x=1769038378; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0567rqepLL5XsPD+si1Pj9mYEX8MG0FAhzMdrDzq0/U=;
        b=eY+bqi/2NCDeF9D8sW4BlIwpQyHAIeklqhFxypFY0DbpY6DEiU4KgCO4vr7M9NjL5/
         3Iyl8h1dJ6SIqhSZkuXq8Jy108Dr2mUA9zrcFNKxuEOT0zQAls98jE+H70eDVah7dtW6
         CKUM8SU5P+KTOicixcfUrSm3HyIc7jdwOUQZzogpKBiEQCXUL1rqR4PX3SBjyvirnMCf
         WHWi6RszZoZTNXKTUVotMxjZhZq2eXTZj+WLLXQMahTdtfLcL9wfdYSEq9BJt7xJFrQD
         b3jnQkQNY0RMhvaVrn4Xzb9BfdH252EPnyi+H8XKHeC4ppZQT/UCVL9hqBhx+aGIRFHC
         QYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768433578; x=1769038378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0567rqepLL5XsPD+si1Pj9mYEX8MG0FAhzMdrDzq0/U=;
        b=BfQgpC0E8Zn8ZvbdsrlTxFnnV1sxkFrZ3T2Ac5/zzC5+RxOSiAwN3DmJfg4WaDRYRQ
         zLH4+QBqr8o7xtNi5FjDON1L5oTk//KJdx1P9hTlphkCZQtTV6eCmsZVZrS/1h9a6ced
         xyh0rtQEkuPA2/6QbQZqwpXuPvJ814GBds02XzB7kC3d/J7g16TRhwdDExuW3obTlYKX
         WbDf+KRrLPeOEEPrLHSk2b/lTB2r+yPPIX78QqiTHDKAl8W8OBhLt4lwi4mG14+Ru5/l
         C1cjRm32rRxmqEGo6d/9pwwtv4fori1cXBtv36mcmGItOkhsmBVwXUgPrI4gDvZsIiys
         bWuA==
X-Forwarded-Encrypted: i=1; AJvYcCXe7IYaW0f6zLF5RBGHXyT8i5+WcsHVLJMIc3zKSO8xWvBugUu6S25R3HmmhtcLPLcyzMaUAgHtKw==@kvack.org
X-Gm-Message-State: AOJu0Yz1GZVEa+/MvVeQgSo8aWIfibL9IOgYPuYWM5tOD8uUTKUomCE0
	5hqrG3Sjxl+IalnwZVL8N99AEBDpZzTCuMojrpLX+Km7n6NDTfOQHT8GFAw4kye8kE6V8yrFMiJ
	ZoCV+gyv2fZE+Vh1MVwhBKAVtDngqIkE=
X-Gm-Gg: AY/fxX4GbNhjvst8Fl0D/mJ5HgWjfvFyG9/iJ4hB934u/UavU42km4O6+bdmdr6pgFq
	WxmdbW4/MTHctSxhoBvFSEY718wraKTvxGtyz0HbEiljB1zb+EtuJg2H7+Mdq70+wcEpGUNfHE1
	7Xzkd/ltA+4WQqlAkkQNigQdL8lee+/oiamG9BEmskc5nIpe5pZ4di0RUWVax8sAH2oj+4VqqCB
	MNxFWyHaRNTNc7hTYYo3AotTmOCypNRMBi8BDG5bFyPnIe1tP0LWp1iqcFC/9uIDgcmWKsjCMX2
	x+7XOvg=
X-Received: by 2002:a05:701a:c964:b0:119:e56c:18ae with SMTP id
 a92af1059eb24-123376fcad1mr3078976c88.22.1768433578218; Wed, 14 Jan 2026
 15:32:58 -0800 (PST)
MIME-Version: 1.0
References: <CALaQ_ho-dx9CTee_-R1VFreX=jB3Zbdjo68fdnnwC1cPoPcjVg@mail.gmail.com>
 <20260114204352.GA19200@macsyma.local>
In-Reply-To: <20260114204352.GA19200@macsyma.local>
From: Nathan Royce <nroycea+kernel@gmail.com>
Date: Wed, 14 Jan 2026 17:32:22 -0600
X-Gm-Features: AZwV_QgYuyVBMu-sOWBdKU5I_Zz4rYxFPJsfGVSZHOkjEDfKpfwo5bJ7U2pT9jo
Message-ID: <CALaQ_hq==FY64FcLedWnpgOXf_aT9g2eNyM6BgWwvTv8r0FR7w@mail.gmail.com>
Subject: Re: TmpFs Incorporation Of FsCrypt?
To: Theodore Tso <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 57gcgo3yjx3ghrjh6xqo7ibkaje4ht7s
X-Rspamd-Queue-Id: 902D61C0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768433579-944593
X-HE-Meta: U2FsdGVkX1/tT0pO8OrCCEGJMfbg3Nf/4YB1gKbprCp6peL/GVAvWCEppAmwIvk0Ys7zVuEm0MX6zB/ypCY0G2QZCTjGJZOtMVx0shqSd9rRPC2M1NgZKT0XBlcxnKaS5BJEzLMS0LIuiTsqg8fhlWOcnQF+dNUYpyY7oalCJyDbf2swae2GzTbOmIN5iPmwbl+EOdQQnlqZaeLZrHy/SxRkhPeWVOhukqF8SL7fyB3TUOohMXuRHQwMG8C3OcoD9DcNJdN7ShlR/c/4Fi4sL7eFzfD4HMNGmTtCvc7nmZlpTodfMtnRgYTPlSpKNHFicwRg1PI94zabuTtt2Oad0a8CJy6szhxYFfJ2UIBq4QuLh+qVkP9aSNJacQhX71mLn5UZ4ZDSZnrKCh+j2Tka4CwxyOZjpYHrdVZCZ+8M6SRMbs5/CXwjvD5b2sP8eZkNCncrjBb6EqITpJ5X4IVxi88Nl57hQatMEJRP9sVIbgc3Vp7uz4QCNjcJSZjUmjbIJinmqGp17zk4ZMdC8k0ZRfS003i1RKk7oV6xMjDb1ru8bebAn+D0HqwvPZLFLjkiRr1osxSMSjMZ10tzPxIssFaRoeS7nf2/JDhdCRLmlVtPvo7TqYVWsuIbN9Sw6WyLE5EBQchAxPBtXUuhNBs1UO76kXy3qqoh2nxGy//tQ1zbyksrqzyaHdF/RrWcHVJ/2acb8UGTetxkwpUqKoZCCGTJ1JMRvmv1Z6siOfsfZ5vl0LHgGy99XswkXDQ+i2Fe+2iB/QXnbKpYLhxbx0hsc88pdJuYxs1Gd/rklU4CMBxvhqJzaZyTeXEIW4wOYsBJzEYShBPJ5FH7uhKAV1QmXRUas7Bez4SMUPToSZeEocYVtX9uPu0pv7/dSgwhe6nW1QLWa5cBAdFRxMAwQSRfYHO/HtcyXYiR9C+sD7mjCRhfb6Q/N+pXslapGJpsiB4Qhjyhwv8Sn9dwHXpIkr4
 BFqzG4MD
 IG8ftHoF2pu+zSdkwdF/PRVI+1bmVHylVhXjHw/25kdjLD19zcPNNffk7btedqtCXh04uEYTnQ4xgp9RbXeVRnE0VQbtgKyNbWyH/D+7CT77H2jCimwcpV9eLPv7AkMelqnz+35BFlZwqjo/p/WRTYTweLRF6k8wFApKMefP8SmMiS6zSWkGAuTMblcSvxb1PtHBwOMPKi3bnWI/NmUBMjMqI+w+PXaRNQBovgFqahD4mxXSOEVgE98dKaZwagTOFSFJTAgyGJQJU0ac4gQVUGIrARuuybtq3DsgNdDimzVaOe3nxQB7INiusfjYgkURW74Jcld0LqzvQLk54D+Voi+efQlk/zlxjz7lBK377PBqHMBNJyFUAgDh/2n8wxI6EgpdGVQcBPmVMYOaNbMJAPW9g6DqFutMFgM6+8rS82u50d3lDOnePEhse+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yeah, I believe I had read that once root has been compromised, it's
game-over. They'd have access to the entire keyring for all sessions.
I think I also understand that if one were to counter kernel
corruption attempts, signed kernels, using a BL key, would be the way
to go.

What I like about fscrypt is it does appear to be session-based, so
compared to LUKS, which just needs a key once to unlock it for
everyone, fscrypt looks like it remains encrypted for everyone except
the user that unlocked the path for that session.
So if a user account maybe shares a path within their user path, with
another user/group, a misconfiguration would supposedly keep an
encrypted path still encrypted to the other shared user, even if the
originating user has it unlocked for themselves.

It was just a mere curiosity, and sounds like I got my answer. I'm
really anxious for BTRFS to implement it, as I expect I may transition
to fscrypt from luks. I'm just not really seeing the issue with not
having metadata encrypted. My view may flip-flop as I try it. I could
always use both I guess, though luks would be limited to 32 key slots.

On Wed, Jan 14, 2026 at 2:43=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
> I'm not aware of anyone considering adding fscrypt to tmpfs.  One
> reason why it might not make sense is that the primary value that
> fscrypt add is encryption at rest.  For example, if you are using
> fscrypt to protect user files on a mobile phone, the file system level
> encryption protects the data from being accessible immediately after
> the phone is rebooted or power cycled.  Many of the attacks which
> require direct access to the flash storage, or attempts to replace the
> kernel with one special "enhancements" courtesy of the NSA, KGB,
> Mossad, or MSS.
>
> However, if there is a zero day vulnerability which allows the
> attacker to compromise the currently running kernel without requiring
> a reboot, and while the encryption keys are in memory because the user
> is logged in --- fscrypt will likely not provide much protection.
> That's because if the keys are loaded, and the decrypted file contents
> are in the page cache, the only thing that prevents the attacker from
> gaining access to the file contents is the Unix permissions, and the
> system's discretionary access controls are very likely going to be
> compromised if the kernel has been compromised.
>
> This is why fscrypt for tmpfs might not be that useful.  Tmpfs is not
> applicable for storage at rest.  So when you copy the encrypted files
> from the persistent storage to the tmpfs, if you use fscrypt with
> tmpfs, the only way it would add value is if you want to remove the
> encryption keys from memory, without actually deleting the files from
> tmpfs.  Otherwise, why not just zero the files and deleting the files
> from tmpfs, and when the user logs back in, just copy the files from
> the persistent storage into tmpfs?
>
> Cheers,
>
>                                         - Ted
>

