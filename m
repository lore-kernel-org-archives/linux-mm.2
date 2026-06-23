Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E529CCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1976B008A; Tue, 23 Jun 2026 13:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92E06B008C; Tue, 23 Jun 2026 13:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9236B0092; Tue, 23 Jun 2026 13:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9344B6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:12:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CB7A1A058D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:12:44 +0000 (UTC)
X-FDA: 84911821848.21.A0BB7E0
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FD82140022
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:12:34 +0000 (UTC)
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782234754;
	b=MQii/Om+1iLBsG5rSj4mUCA7Cdr7iDugmBh2wUkVA53oe60urA1gvaWdC0ctfG7Zu5j3jI
	dObEOJf4GVAYUCsfxr2OAmGG23gaq5tBnxYC2Ron3ovXxmgEUzQThLmI32Fv32s8hJZVGG
	jczpLSD4ukQkV2JNtVt7KottrG3VxkI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782234754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQis8KO7+Cr37wQe2wy0qBtYljKSNFAIw/U+lZxu9Bk=;
	b=jHvoNGIuZ3QqpLNST8NLLpWZnCqliEpGH6nmcp6r0OMwor1wE7YlvmqyZ3f6LctRIdoNHd
	fYCauBKb74sjijmt/0AOXfPGEeALFTd6l75rmLRY9+24Oa8e5V0z5AJHgMwAcsPOCyXcwx
	AdHQ0QPn78DGtXlapVJC6dDvfHIGOxQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LatViBSF;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-463f1165e16so166746f8f.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:12:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782234753; cv=none;
        d=google.com; s=arc-20240605;
        b=hDixjJnj03GgG0PcplBsq/PIMyuoo8zdjHXSkSOH8pJ7Oz2XIveISWEu2ij3MWhJsR
         h589/C2SPQgMkrP/yk8jUpA0rbFYCpbwehHVGRs5HCl2LlRyQUdbELgQcEExblLLQuPC
         HZTeyZyn2Npo/E2mncDCvxMqcWKq5CzDlKVp0bbU6gBJgbx0VDKVtZ2WYRAkqs/ms4wz
         1dpm2T315FxyBW67/pMIloO2xvvyauykP9xNxgn7Cp5d78VKQjjWfvSt+BPXpNCH7NGp
         +ba9SDnImAk7OL32C+HYUlbhXdaekMuXkywBKCsMe29vgi/6BA3q6S4b0BMrQYXiblGM
         2OjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GQis8KO7+Cr37wQe2wy0qBtYljKSNFAIw/U+lZxu9Bk=;
        fh=i/aoGPUn8XI9veObcOYelgSzrzsavfQ8gYdgr5ewU6Q=;
        b=b0Rhp1o979Qmxv9WoMiwSuLsbU1y6heeVtGD17VAd/61+Dh6NrDRq4lFekjcwa0BR+
         +ou0vrZ++eua4Pvq2D3mzwSQeG0gp7r//aGLASTwJrgQbJzTZt/92cWmeEBmoUd2Nw1C
         ZRplA/TqeWi5OZ02NXzIHzyzdSG8Q9o5t3ekcl4xv5pIU8OXsf8gxSI7rjWUO+c+gGxG
         sjimfzxEX0VizLm3pYIwqrQ8KN+mHhp3o0YhJ2xIE6w2U2BKhTGBvW4ICchgNvctYuHu
         gkf2xk23VNFuT4UDoRS8Z/S8nJlxUOpooGy6pG7EF7+N8tU9f94uTja5B/6OVmqWiCKJ
         424g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782234753; x=1782839553; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQis8KO7+Cr37wQe2wy0qBtYljKSNFAIw/U+lZxu9Bk=;
        b=LatViBSFkTXnRslMKXZcgpsIGThoJ1aUCNb1U0ezGQaUeZDMNMzu9jiB29aiCpSNBP
         rnha+5eoKOptqqBFreplc5p+XqkMgzMF0OMLeq/koqdnc0MLpSc7oqBm19V5wyAVWaQY
         JwqZ5g//Z3lXVdjzPdSy/9I2Y7a9JL9HVNf+K/9yEPZ+/vv/pzQM+osFv75oLr36NGur
         FXQytQUVvG9kmqXa1F9eEWjfrDjY3/0gKnz6g/f71fhj21/TDYQQFf1IolEOynjBIvyn
         N8dYDyi7BdJl39oTJmCXaLEoQXs/p+DOHaU9BQXqYuYrtbI8LrBa647wL8339X4NAmbb
         3OJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782234753; x=1782839553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GQis8KO7+Cr37wQe2wy0qBtYljKSNFAIw/U+lZxu9Bk=;
        b=V877YzIemW8jsrksu6wvC8P6MrAEsGEWjeIrq/Hn69Gz7G4okNXsbDn7EMQ0BnWWsb
         NyqVrJnevGhlwv+rw5jseX3oIcj76tN1hAnfDIiRF92tLNCJ5vbWliKkFJA5pGS6T9PI
         oM3FUWMRge60AB8+dabmR+iIUAZx38Uc1NUQf8HPzlJ9I5KQpigg7cTrLwpXaNE6SYgC
         CzuUXj40Bag0A+RlXy1xalK8UbnQLdc8VsIiqOp1Nn+L9wuHn+mOhWs3NR3IP6nEq5FA
         8YhCpEbEzSXQhzOWAUxlDGs6JmFz4GdZ3FT1206Cuz32n22g+JqZYl+j5r7EjklrH00R
         Pzkw==
X-Forwarded-Encrypted: i=1; AHgh+RrA7BqM6tF5p5A7QYjHGoSMI1rzKTheUmKdPLOvMh21Az2HENJ/zxf8V0ejUwBPcuOW9dZFNqD78A==@kvack.org
X-Gm-Message-State: AOJu0Yx2DEfaqF2tHj5g9wFSSXIqjOdU7nygRKrZrsWyjrBUvUQgzAfy
	vQOxuFBW5Ww624DPPeypWjkPR/eT/173Awm/PfS3mrQf9YFt9IE+C/cFUo+o4PnrOGJCa0FsVKQ
	NMIvzuD5xpxDTT1gkuZe44XLSEErdPEc=
X-Gm-Gg: AfdE7cmoBnUQrm4sIjKeqJQjP+L7E76sfGOy7hUQ5U53R7ccVf+Yz6K37y4+cdWsziF
	5hAZqomTw3DE7jD91xKbauaR7EPWyk7m5iUC28qqElQEKQbEb/Ag8Vyuqp9OY8LVUrlSsvQ5sCV
	Iv0F9DxMh/IDCFCWYe4mpSMSz+La43+Ew+YX9l3rCNfpH5ddITslV/preuovJlluP54xy3lfNUg
	8Tkqn1g03T1nER6wGajbbLbk3SqknGy9W8wkeJtdNveIyQSuckko6VlwTT/PtXHeiOEZ2KL0jTF
	gpwy1he5xi/kzLzCKckVUR8/rVQL5Ow0gJdFhNE=
X-Received: by 2002:adf:f182:0:b0:460:6b0e:a75e with SMTP id
 ffacd0b85a97d-46506c35d0cmr25528866f8f.16.1782234752678; Tue, 23 Jun 2026
 10:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com> <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 23 Jun 2026 10:12:20 -0700
X-Gm-Features: AVVi8CdfcxG5r5FMFto7l_ai_RfkpnO9NQCVALwgDokVA4D7LTvynw9skPuPn8c
Message-ID: <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1782234754-617036
X-HE-Meta: U2FsdGVkX1/qOxw3hFVGtOorIZNqk1emd78y1+HW6pc0M244KXo+gh/p3dgVn12UuR4Q6Ndk327as2wwogzeh9+UAB0Gvvacw63tZkZz5pmIzaQJmB5yISJ7Ip8A3sttUNmJatXHqMsYAQObtN5MCCPahckWkmRarVXJPdKQlYmVBqEy+JU5l3XC0Upn9ZAvrYZlcFIdDXc5y/Qz+7a9lHzylVm6uYTu6c/jWllMD4ft7pDAhRZbCqOTG46o7PqOD5/9SDoSoceZIcFg6nehfmJSs0wjboCCkwlsPVzBowPuGA16dJw6G1dRSEqKqVIRFZBYoUQspeiJmtvbm6TNn4b1dc1ecaWEd/u1VIfnGiHHsc6/UYT2c8OqIQW7eNpRx8tyYLwv9Z6NkU+9A1R20br3sejM1wkDKyqbg/zmxiNxHtSSqe5KQpP4Sn2SIzkuLtI/1bSV+6HIDy4I+w3GzaY1HgKJYwrh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 4:15=E2=80=AFAM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> Overlayfs forwards data I/O to the real (upper/lower) file, so the page
> cache lives in the real inode's mapping and cachestat() on an overlay
> fd returned all zeroes.
>
> Implement the ->cachestat() file operation by forwarding to the real
> file via vfs_cachestat(), the same way ovl_fadvise() forwards
> for fadvise.
>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>  fs/overlayfs/file.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 27cc07738f33b..a7e252a91ea43 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_t off=
set, loff_t len, int advice)
>                 return vfs_fadvise(realfile, offset, len, advice);
>  }
>
> +#ifdef CONFIG_CACHESTAT_SYSCALL
> +static int ovl_cachestat(struct file *file, struct cachestat_range *csr,
> +                        struct cachestat *cs)
> +{
> +       struct file *realfile;
> +
> +       realfile =3D ovl_real_file(file);
> +       if (IS_ERR(realfile))
> +               return PTR_ERR(realfile);

We're propagating the error of ovl_real_file() all the way to
userspace right? I think we need to handle this.

For example, we might get -EIO here, which is unexpected and
undocumented from cachestat's POV.

Maybe handle it and just return -EBADF or sth like that (with some
updated documentations, etc.)

The rest LGTM, but I'll let overlayfs maintainers check the
overlayfs-specific bits :)

> +
> +       with_ovl_creds(file_inode(file)->i_sb)
> +               return vfs_cachestat(realfile, csr, cs);
> +}

