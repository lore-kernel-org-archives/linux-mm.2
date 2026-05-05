Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF97AFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 23:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A266B0005; Tue,  5 May 2026 19:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2316B0088; Tue,  5 May 2026 19:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0FF6B008A; Tue,  5 May 2026 19:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADD316B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 19:55:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48AD08CBC6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:55:29 +0000 (UTC)
X-FDA: 84735025578.23.FA09C15
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58A69180002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:55:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ERZ05qhf;
	spf=pass (imf24.hostedemail.com: domain of jeffxu@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=jeffxu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778025327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuhyBcGWDRHeBIJeFOOXO2Zi58tk0CDv7lN3uv+zGa4=;
	b=JZEZ+JvkXFtA+F2caxFJM6pth49enWM8Ja0wYDD3EAKTwa/S8eyC575Dz6BzrK8pNM/4xG
	tD11Q3mZkLQL+SNeL5btUnL1tE05zsBnMbIxj2682N/HoegbkZPtfVZmgEUMbSbKhBOR58
	YVLruzD8eLj6oDj1/qO5tijHGeKDu7w=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ERZ05qhf;
	spf=pass (imf24.hostedemail.com: domain of jeffxu@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=jeffxu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778025327; a=rsa-sha256;
	cv=pass;
	b=SKXmPrQwtPnCW2rYjja/IaCln9UdHzQqRkMARTPltW3eMCjqg+Nuox3WGVtrpybdivmq8L
	po4Gem59R6/JylOOcWa/DXbqYOxJqbTfR/m6cZOCFBt/8tF8OjexISpvok6RYdXXgj+H76
	oREL2/n4DzNwtqLclXdRD8Js9SEPfl4=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d6b393d60so243781cf.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 16:55:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778025326; cv=none;
        d=google.com; s=arc-20240605;
        b=PF56BZNcgvV8+Sh4deOsl4Q1Z6m6Fyj7b112WkmB3blYPkKrenWPJ//n/a54g9MlmV
         sGTbrYlAD/mKGLCCuRN2M408lahlsFPMkv7gP4e+iO7lY4xIgOktHVgeM025w3W6O5IT
         SmWxE7iIVR7G60y52w6N+astPw08Yq/u/MoVK+brsRKaWGRjWAO752Ss4+y6trTfg13W
         8HYw5mIxH28RCwwUDyOHBw4o92nwGfZg1jWqjLTofpRk+XI/7NLfn/blv4F/bQfsyyJo
         I5/A8Cx9hqdJckXUe525JigvEOQcCtT9SJs6FIboDBm13ez/8uP+FtO2PVIJvyIEepGt
         G34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wuhyBcGWDRHeBIJeFOOXO2Zi58tk0CDv7lN3uv+zGa4=;
        fh=twYy3sh8FO3WGBLFudx789eHQ6IAd8/SrvEkLdwrkMc=;
        b=fYlZdv80DjcXgnWC3lsvxvEW4C/0JP7tkPw/a/1o3vszE+/XE7ZQxwZ1pKA8yjoSU7
         2dxy20ffPc4OpXNI9z8FjSTeO5sMuCvrOl/C8wjCiEkhcuUryYigCq3zYiw7E9Bu1GwA
         6to7YzTl5YLHSXn1tB1Sod8jQV2SIi31lkSHsK7E89E/jCBVJ8QmRx+GJtsgXO0AxMq7
         OirtkQYYYYHXYfG2sJ4x6zHytyGOh4wd25+yNFyXuQFNlZFczCB8CrsioM23GwEV4ZFZ
         CEK0WoHJ7+V7bS8m5TlyJaZXfC2KQnhy87o5sJ0susMpMc8ffmMU0N7/bMbiNowe4eoO
         /GAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778025326; x=1778630126; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wuhyBcGWDRHeBIJeFOOXO2Zi58tk0CDv7lN3uv+zGa4=;
        b=ERZ05qhfqyD1ag+kJNck80qGU4rQyKhnzp0FHAZ6nWGnMJra5jEjlDKCu9POVJrnhu
         WjXy0Xu3CHjJ5Gulw9iJRSEWqNIVGoUA7EtuJoxzZLyljgQcLKHooafKEE3mAgLnk+Rs
         iyUfbv622avWgGsbPLCFHyKZXgEY8thv26fozY46JAfS/ZXmC5DLeDjSl/T0R6J3448k
         Bo4BK8z68gb5kUj7+vZv20+aBxf1dJasR8lOQZuUPqPrb5/IcWrwiHi+EdjsHn9qoenB
         4H7leZSo/7RsL2garIYkVN44QoFqE8dOoelf5oECOaDe8eEz8+8KeFctjt0OuNdC62E/
         Xu+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778025326; x=1778630126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wuhyBcGWDRHeBIJeFOOXO2Zi58tk0CDv7lN3uv+zGa4=;
        b=P156Nt4PrcnfHycpw2Uf+LA6RU6SFK1vXIdXrX1fZYvTVGTaLwWpjTyQNB04vkFNQy
         C/UmapW/WoTz4s0ghmeWrbctqthplPpxbbwZPgy5YFb9+nd0c1yoj2EmdKJh5ott4w4u
         uOj99rBC0YqV3KFIfXvGuaJbYMCQex7nXHm+Dr+S8VHiCA9JlcyXZPBBBnL5n8jh51OK
         hLkjX1n1zYFMBKzL973e0r+0AIxtq+N45U6JfW/jsQm9LPc4I9eNnCHg5EV1wU9nwcC0
         tvxcwaczMp8AifTwSeYuhix/iqOy4eCKeOmnd9IitLJOycaqegu1uydonhOpNtnKVecF
         uWSg==
X-Forwarded-Encrypted: i=1; AFNElJ/QU7LwYjZHuBUHVq0zOcIjKi7FKcXLAciCUisUd6KynPjJbA1zb+YabKUH89wAmMNt9UGwUsXrzg==@kvack.org
X-Gm-Message-State: AOJu0YzySEZXTkb2FPcv6b9drJ8Mw4IlFRYe3m/fVBBXmN3Ule5G5MeF
	7bTZHbG+Jcsjp0J/6HDeUsYGyJGXTxWC/m9rIM9GxpMOCVyiAQHypMc1HYd6KBvouTYX5bHpeKM
	5P9IVOB9i2gNLW3sZ2unqQ4lJa4HIwcyRmEyPH8Bo
X-Gm-Gg: AeBDiet9qBcDRPhFMhz847Nm4ORJhgA32lKX/o6dmKCTAHGQhMGH3Htc9pSSIPT2qs2
	9lYyuAd1KszIi9ZbUB+sQBXaKj8R6NgoUg+GC2MdKHR8zpXq0L+wLwTWwzCr2Wu7IuQS0QDzJIp
	CSI+HNZx/o1BSbRGiExX2GA36v0t4lQZmnkXekgVJhcpWWkfgJnU5B8y+944RWD267mTVmZaJuK
	wawTN0wIr+h8abFFAJkeGOg9XDUB8pXxpiW4PQnPvA1E7fc3fezbdm1sUZefVmfya2UQ4C7tx1a
	9YorIzRmX9mH7FehOQZ76lOP0BNfjhB5pWUucchReaeD1DH5b29XxlX03stBRST6gTupuMSYtjy
	FHjYqn8evbqMHFWFiiHSmoJWGwOxayKRhJbWnqa3cqBlJjTw6xTbi
X-Received: by 2002:a05:622a:5886:b0:50e:6360:96e with SMTP id
 d75a77b69052e-5145fc87da2mr6668431cf.0.1778025325921; Tue, 05 May 2026
 16:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260505133922.797635-1-pratyush@kernel.org>
In-Reply-To: <20260505133922.797635-1-pratyush@kernel.org>
From: Jeff Xu <jeffxu@google.com>
Date: Tue, 5 May 2026 16:54:49 -0700
X-Gm-Features: AVHnY4JEDWD2VQhA_AgqzBkBpPQ2cvl10s0XbqhfOlUAb7igg2Kifeo9-olJJYY
Message-ID: <CALmYWFvb1aN4-+e6wWEDrv509ELdTwC1tOzPmbCagoZYuBC=Xg@mail.gmail.com>
Subject: Re: [PATCH] memfd: deny writeable mappings when implying SEAL_WRITE
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Brendan Jackman <jackmanb@google.com>, Greg Thelen <gthelen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58A69180002
X-Stat-Signature: 8na6odshmi6fzmhwmpe7ht6kfsqiqt1s
X-HE-Tag: 1778025327-129468
X-HE-Meta: U2FsdGVkX1/lRYiNoalZs25rYznyALAsyQ3PpTkn6Mkio8sA4Gm9SUeiIa+JmKn2lOmmGtM62KInt9gaFdFR5vzlGVWSb5CTDX9aj/AjBOIO/0AuolGfcqryxHbTjw7uqB/Jj6CwE/cEfM6GTxBMK3tPLWjD9mEoRw75cfkVR6Ol+g93j0mWzv/AZnL41lCEKqrqxYhHJvKIGaPsf6pclpoes74CNlh7/GiKaepfnxwdxKjR0NT4K2wAHM7KcyUwlhucIVcQWvzyP3hZHaiiHiKNILb/7gaRduGAxYD1nskb4FHEATeaUsSM3C+bXTsr0cUYu0fhPh+wc45yuc8BF6gZ0hRJK5qF8vLXr/h/OX2cKLaYJenDNgnHUd3GZLVC0iS4B3VFPMRGhX917ZWtERb0dUf/ENWc1c7PIb/PSLaZnfPf0S+dYj8mrVRpQmNe+Lb4nDUEISusYZBgO8hCFit/HUfUknd61Ir6PKxnwmx6DigevnoRR+j2nQNVj7XHJCtz4JM6xbfq/5elb+1m44KGSSiVYd0h07pGaSQbhSJC+IGHau0LtUOI61mU9HpkjJ4fCh1gvOfQxTGf3TFRMPCq2wAJ5SCahq5F6YcAYg5/S/Qo+SeQA5/k901NFfX0RI6c9BSUdQQvPSn6G9yocUsJSEzYmwbDmkuLSl14nv40Y+lN4XGJOZoiD0YsAW2XHGycrIxv8Opff0B1YKGmTDDMhEN0PirwO22qf//hkbV0RaKGxrR8jeid00VnUj0Ftc0t/VhXbaibto6PxZ2CtkvnyZhRKNhwv60fdwipPgyDu5welbcYJ7TuI4oCaUATE140jFXyK+/Cq5YrgS1tdgk5zV4cLGroYITrx2FifjiEv17Bd+s24MhRg7UvTfyeWSdcxYCVyXqTvPjPgqTMYFgRUvPbovOcN7+0g+RzuOvQc63tSNV3wW9Lab/CBPSkQErr3cYaDjCWruah1AU
 uUHhozLH
 a4L6f4EN2P0SPWHcf1ht04SI/0THBleIK4Jp+fF9Z1XWL70CcoFaZ7mfKX36XbBIbl2sPwF80H5FgRycd61A/wp9Y4Ja2Hb/Z69aCy1/BAnoYlxx8PtAYkIOo7GvYJOWqRmRky//p61HjifTFy+KnzJN0VvLpsw6LV81VwEbf9hGF1t4BqOIHBvi4sh6NFJpVk7hVlDvN26zzZ7OE476tezwzi/Dk5rYA/dq9sHZ7ZEDQy8f401hztKNCMKtmJLc5czs3sERXi/XHxe67O4CF00Nq3c3wQFTUyLCHO9TVTK5rZ/x1iqcW1yBT3DT61RB9cn4N5Lrlnm4rOXB8hS/1LNzSd4wLd1+8XLrueLMn8odwtKzrXO62iZqqLGd0Mj3C9wriEZcFz8d3L+2z/zOM1zmj70b0Ca7Xbe23
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

Thank you for fixing this.

On Tue, May 5, 2026 at 6:39=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X. But the
> implied seal is set after the check that makes sure the memfd can not
> have any writable mappings. This means one can use SEAL_EXEC to apply
> SEAL_WRITE while having writeable mappings.
>
> This breaks the contract that SEAL_WRITE provides and can be used by an
> attacker to pass a memfd that appears to be write sealed but can still
> be modified arbitrarily.
>
> Fix this by adding the implied seals before the call for
> mapping_deny_writable() is done.
>
> Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to e=
xecutable memfd")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Jeff Xu <jeffxu@google.com>

-Jeff

> ---
>  mm/memfd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/mm/memfd.c b/mm/memfd.c
> index fb425f4e315f..abe13b291ddc 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -283,6 +283,12 @@ int memfd_add_seals(struct file *file, unsigned int =
seals)
>                 goto unlock;
>         }
>
> +       /*
> +        * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
> +        */
> +       if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
> +               seals |=3D F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_=
FUTURE_WRITE;
> +
>         if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
>                 error =3D mapping_deny_writable(file->f_mapping);
>                 if (error)
> @@ -295,12 +301,6 @@ int memfd_add_seals(struct file *file, unsigned int =
seals)
>                 }
>         }
>
> -       /*
> -        * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
> -        */
> -       if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
> -               seals |=3D F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_=
FUTURE_WRITE;
> -
>         *file_seals |=3D seals;
>         error =3D 0;
>
> --
> 2.54.0.545.g6539524ca2-goog
>

