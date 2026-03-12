Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA95B106ACFE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 23:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71A16B0005; Thu, 12 Mar 2026 19:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32DF6B0088; Thu, 12 Mar 2026 19:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48386B0089; Thu, 12 Mar 2026 19:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9180A6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:52:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A9B31A0381
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:52:44 +0000 (UTC)
X-FDA: 84539063448.01.A56EA72
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D758140010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:52:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=DTkQwAbC;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773359562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
	b=7eG6bVU8APgTRCiwl20kXmaT0Gcn8dyVdW9wv3l60XcWh7EmPFZiSEH2E2W7OiuGlGdTfG
	nDbwWK81IMySU0FMPMlIi/23K1kb0PMh5xRoe+/aHtOK3T8grKee636wwgvmOgTikIP/jG
	Z9DqDMgwiTKEg1y6DzrBESItcMprNxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773359562; a=rsa-sha256;
	cv=none;
	b=xVhwXT/wqlpESy0Mj+pzCfxeAXQvkgT+JaLN9TAO1+exfwf3XmzHi305Q1iXddw2qIvSdw
	0AiZupqZHL6VJTLaYOZ5XzBTL04Fe/TXn+YCWILMfRjdWewJ0WyA9uj4wAnWuHhvHvEmW/
	Pppk9UDNKQ+w0bJYak3jDqB1Cs1XA+o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=DTkQwAbC;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b976e181895so2674366b.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1773359560; x=1773964360; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=DTkQwAbCezc/kOco6uhauHuyYplJ1hA+RqjDkHiof6/BKxRUV0s77hKWvlp52dyCKR
         NOnlOTNmHdAJwhLFj1vVr+kU9+DHCxJpAdhJSFD25aR4uRXfdZaLwvSjCjcCpCY2W0fj
         OWvYRBGWoOgkoZKjMzrohsw6LlwdYST6DntJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773359560; x=1773964360;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=Yi6DQmLhlJEADEf06fT0T1Fs3zlHarZLMbNfOqr2w4iFB031OraU0yQjTMkvo3Ha7X
         Bi+Y0FV2xDAPAJKbWhHHnrO6d+J5de4RRH62pcOrE5mGBPIFHANPknq54Nriu+qe47EK
         bqOR0Ao1j6aMB1N/VA5hu3bMqiwEvB8J7FePhYGSitO+3TDjGli9DKGXwZvttjfcGbfV
         j6YqbvYkVF3r3ttxclR5ld9+rmZUHfNKbwOtiRJRQmB+IwIXIQn3bCus6kFkaFLyNsnj
         aOdBzm+zElworh0BH5jlpJWNP3Y2QhI9mNNHoeL8xk5ArQmgcaW1eN4lYIWkovBmJfec
         KCxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIiaSPbtwdlxKtQLWjd+AWuTJ6kiIsHbAzzlnM9n73YQDxy3hxAkrLVw6bFxpWYpBx6CtpsbW5Bw==@kvack.org
X-Gm-Message-State: AOJu0Yz3fBvhUppFAntcTxkLHdZTBS4j8Vcp1mxXkO28X2Jke1Qa+vUm
	AnUaVAk9ZJjEeB41i6rdqYqpyBMvW1nWhj1B7Kx/OgfmdVUPShL5U785YrD/Y+Ov3kQA/l+eqA4
	JudVaYQ4=
X-Gm-Gg: ATEYQzxtxl3eh8Ih2s2mS+Ve0nCsQGm45HgHxCcOKq7L+LBRUNd7Qtf2ydagEhq2uMx
	k3PhRst7x+J7SYLwcn5DEmAJEr6IjFB9o4M9sbf+0o8UZFhVMm06/FHgZ517W9GMgQcQ6weqTD+
	Uq1J7mLFAyLJ9WzpWAJyOlamd8eSlJDfVhrThTQfH3ysyZkNX72iyCqtjOQV8QhWhjX0aHgzOPn
	jgaxVSyrvfCCoDdBZ4mc6MYEYLs3XF1tw+x+ZOMrVjrMJCvVhg2QqDjQkeHDF51erJ1X8BvatWz
	59s78CtBLtEuh8FM2WR+bbpHktKOXIS5FuAPUnaFYp+7kmnArH+sz/JJySC5VcT8lUELp/9LjwU
	iBNBTSD2Yl4fYDkbUmCuy2iLIwO26xotrIbH0lNPPYntH4zUSjZ4/bM3kPUJM9sYhT/1Uvie1qU
	Cd9+kjhNvQNK1bRPJwDjdBoYdxXmd5Kd3BuBldttF+KoA1jW/tRNUNbTTd49QLXJU9F0x6qtbm
X-Received: by 2002:a17:907:708:b0:b8a:f2cb:8088 with SMTP id a640c23a62f3a-b9765392113mr69098166b.33.1773359560155;
        Thu, 12 Mar 2026 16:52:40 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b976cefb9a7sm3217366b.45.2026.03.12.16.52.39
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 16:52:39 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b976e181895so2671466b.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:52:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXwgpkWocuqklt/RQmsclH1JrKbT0h+hzPA48UmMrzXPNrUzHKNBjsVJjCKGUT2FePFYFPmOGDlwg==@kvack.org
X-Received: by 2002:a17:907:c5c9:b0:b96:d802:8b41 with SMTP id
 a640c23a62f3a-b9764fd8722mr66207066b.15.1773359215961; Thu, 12 Mar 2026
 16:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net>
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Mar 2026 16:46:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
X-Gm-Features: AaiRm503fTaccEgKNbxF9h_dDHM9fUsSr52XJuxzTwCI0G9L03uDq8g5di1zchk
Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Tyler Hicks <code@tyhicks.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mxw4smak4mkrr9rdkhu74ohpfd8zoi1x
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D758140010
X-Rspamd-Server: rspam12
X-HE-Tag: 1773359561-231397
X-HE-Meta: U2FsdGVkX19SjvAgCu4qa52t232iwWSYpA3yB24KaHDhCm9XmCdimK8Bp22yzZMtBalmM6WDSWLo7BifglaO8PvB/eYdBxg0twB9ZxKqn4cq6raVJiT90o91Cac+g8tOKXh8CoCgQTqVuNy0C/bySfVTZfMfkU70gNXOHMm8hvwuZqefuwNyCXi2yPdsBfnjG0jV4Q32EP86vfkyx58jKDlZ0zvXeT1FmxyJCIlzUMwLfbagIZ1dxFwCObVny9+6NgwW7GTrhOaiIlDZPLyGXNiHtVCqWzK8QvLVQc1rVO6KKrYokpzJjHmNFpeboL0FqOkOulaM+wSctdziYvHMS5s1yfNha3CQOxvWZPYDrUihNl57ZmxMFsepyKR89EW9aRUdURcpQepHX0oWru6zomnxpPf8cLocMaoyAq4k2eXu/HICuXDDcGqcA8lo1OgjRXUpwa0Iz+PtxkJ+yM+T47hxXTBYgja3qvTDKvGVTQlYssFsZFZCJn5r2QuFuADqw44Iiv5MUlYiLhNqVSlFLx/RJzsgH+y3qAr+yTDt02c3+T7Ji7WAf7YEuLWg5JkKsjHjvZhAeLVPuzmPSJjSBtgbZgZy9IwcWrl9i1r/fT+C8KkXusip3Fr+io+2n8lcjdSQcb0BtUpSDR2cJxfmL2sBpCFT9rLJmKcPI2ir8+8eKryBmXTmSWK/fRiA5EjXApc7yTjRLihZJzrOBnRenbZo2uJNDubd1Cl62iD+OOzBFIC+JLxXHxt89oFji7r/CvRtiYDdMaBKXBM3YC6xSxy9VE5iRfQt465bP7EyEwwwy0IDrfDirKq6sKt82lO+elP4Q/ytX+OoJTbd1FUapmvBE8HHWacNUmhYMIOSrhKXGjKYnwO+PicV7GR/jfYmiJyuWYyIWiDl//A3P9MZ59fmQZ8MYuugyAI58AwtZKhTSqRafmIHMXtGzBlEn9sPQkSyUuxQL+2tCYTsDbn
 vF4AxYun
 kfMT6eoA9y4xkB3j6epqXUXYn3lcGinzPwJNWNQemjRlcKDWcn+bLCy0IZS5SFqgnqFEAW1c5HIrFsn7x5Vv+Bjow3aqHLAa1vsWL9CW0PGg0M0rsTvJLoGfJAAuoWLjxuFxJRy/tRfp9pAYNv7cRu54h/xVejbwy++U/akgr1lPvMF796u+cTazVbLRpQYCK3Y8PaP3zLpSSP6k2yFLUjpktuljjVG42RhZobRlKkCJi6gv3KHjY9mDtm3sGry6iZWnGJQI6EvghcaHMPzm1dQjFHpWDJ4GMRK92DS6pNKJK02G5q3sqAWHnz3dc5qBmXZAHK/CzZRY8yDJ3fWZ+5T0nlQQFp28KzbuHkg0OK03rV8/g985KGasREnQkB7uWrPHcDJ7XygYAvfrOVoRiD41KXiIa1y/ax09L7LWTRv+wztW5hot/dIha6TFuMjw9mUCVWoXy/KPXX2C7lj/MJmKi4jbiPeL5L6YhtiRAt2Yon5vkEf8mq+bDLvepYxZCv5tLBEM+rFsvqfYqlLVzAo8eSknkh6IcVJcTtBkTLVnpiIexrVjaT5t5WylxoEcKu6gtxOWVs9ZnHOj0916LylG/WdeQtJKqF/eCUArUuhZu7ck03PlfQ8mA6pZPOfXIJr2bcVhkQJLQI20wWPyAbhE6iT19dLV/C8vr8bm0n3YCcu0Wi1xbSixQ7+cNL14iZXCH31dMTyI/DwdvP8yquuoouET0mk9avqR0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 at 14:44, NeilBrown <neilb@ownmail.net> wrote:
>
> This patch set progresses my effort to improve concurrency of
> directory operations and specifically to allow concurrent updates
> in a given directory.

I only got about half the patches, but the ones I did get didn't raise
my hackles.

HOWEVER.

This is very much a "absolutely requires ACKs from Al" series. Al?

Also, because I only got about half the patches, and there's 53 of
them total, I'd really like to see a git branch for something like
this. It makes it easier to review for me, and I suspect it makes it
easier for some of the test robots too.

But again - this needs Al to look at it. Iirc he had some fundamental
concern with the last version - hopefully now fixed, but ...

                 Linus

