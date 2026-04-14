Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48630F9D0C9
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95B96B0092; Tue, 14 Apr 2026 09:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46A56B0093; Tue, 14 Apr 2026 09:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935456B0095; Tue, 14 Apr 2026 09:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8D36B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:05:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13A245922B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:05:35 +0000 (UTC)
X-FDA: 84657183030.24.F0A6A59
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D28D100016
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:05:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XKGQrwyY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776171933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJyMBBDw3QxsO3eB2s7y7REn56kC8A82/2aFbWMGYbQ=;
	b=N+8cm++aXLixlAODJU7nR+W9yhA30dmctQWCKHXgPib1PenUkeI+xWNlYIo2WprYUIvi5o
	SHaNbgZFFLeIdGGnb3peZRj7GPk3iyzhFq7OmC//8LTrYizB4xRcquLbXkWm16ImDOzbH7
	RavVivtiMm6vtJjlAg/NEp4huzZ71bs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776171933; a=rsa-sha256;
	cv=pass;
	b=Kh113eITyCuPU+hKebRoJMMGwBAXnPnBiSN/tVATinmp58J1AudYi00GsirNeOe549jGhk
	x/vDZm4yeJGDN9gCnX/ST0O++gtVf82nvYnXMhGdIL+54BeN00NPema/4YqqpExvbuBIjG
	cGcKdM6eUgJRghKOdBWQrbAJ0JB03Oo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XKGQrwyY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6708cc2d6f6so6223126a12.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776171931; cv=none;
        d=google.com; s=arc-20240605;
        b=Qa9UyWBPXwCms5DLlDehRhZqR8pHt6XuDx4zVIkcxSmckRFwFqa6BkJpsiJ+jCvRr1
         thUJ68l9xEE0SB9rxzSW/QDfk40aiIDK6F2Cwp7vhNKRq0Wer2+t2BMe9628jLkv6s7T
         K/b10Az/tgwzEGjes3Rg13jj/9s25LOzuv3YBeAX4f+AAKmPLyoGP3qkLSImTu7VFgzZ
         /dpMEl//1pKTs+PUKuIGrcHpvcrw2bu3sID30X34Jv3xiwy6PDH4imGJA0abOVB80B7i
         0Cpb93LuLN/AIJKgjnmTES3fTiCc8mvNw9BWdqv+4qFgqJY5JmCE2FfCvqh6deyVGbXI
         +A0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJyMBBDw3QxsO3eB2s7y7REn56kC8A82/2aFbWMGYbQ=;
        fh=Td0I1BDxy7tqVwySR+GFwkyyDvLXV/a4w0HzVLc8iPA=;
        b=WCFjYnrSRDM0lYRxRd1xnNpGyYHdscDqZnqPhVQA6g/tvURaC8Y5rqjKp1/QJFxjXP
         HOEq9ZSBcNFGh6qMEIDdXLT20YfVLZIPVHQDdovEk63fo/S3SH18GL0mDU0VGsaVZwAG
         f1nlvx97p0lL7CMlKkorRCYZcr7Mj7sk86okYZQhb9+0q8YysIH14cYtAfO+HAWMBkOE
         sR8Y560tArSF47a4QjLdC4fyBhU1859NVlXaq6cphzpAojhmUPlPOFk+zFoekLbS1+oj
         pkWY+1C3XUht03gmlGVu/B+E8u5vUR1/IhrOjUl06UPdmFOtaPXN0B2QPaMrLzrOLyZQ
         Trmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776171931; x=1776776731; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJyMBBDw3QxsO3eB2s7y7REn56kC8A82/2aFbWMGYbQ=;
        b=XKGQrwyYSuHf8k9IE+ssjgKu77Phx1e1IO2mcSK5RRUjAGDV6aso+fYLCwwyHoCUBo
         dChYm60/hnhOMSKwmGi99ccCpiQdRbXAzjDdqRJMxXCEp9/xANUFRpcQnpJzSb0PEUDQ
         JqYQYctp7UN4fPkvnOYRiHuUXOd4GWCCfrgB5IkjVIzh++MhP3euW8WNAqYQcOFv9RG1
         RMvEWsArdHoE0kttpOzGiL66XcHtkx/yszw6WBEf9C/XQ8p9JHKLYh1peTXI4Eb0UvG2
         kp10oYL+D1Rtlh9a1aup3ey3zKzAnK9pDni8lpWq7+EZ9rWtWlfH1L8WwRnZnV5DTyHv
         vKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776171931; x=1776776731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJyMBBDw3QxsO3eB2s7y7REn56kC8A82/2aFbWMGYbQ=;
        b=SypR5KpYZfE4qifS5oaWCbwouknaGjz1gW6aJeE+razvcfToakgR11xEV2CLF3RUKF
         0ApMKWb9WnO18XoW7AwPLr3jDklpHhZPfqDzSEFi8/V49MazfrK7QliT5UnT82zXYbNN
         sAxlp4Pbq9zXzD4c77mEdkF/9k59NEqJi2ZxFCM042UNmtJPAv/Y4J+4XGqe270hroAE
         ShpUOMyyaRUGAfYg3syXAJuT1jao7gvNF22+90tYk0YgMF+wkh+eMxxFrdPw+RlHUB5a
         KIuIaUt8z3RQnSxHuNJ47LMQa/V5CwvpYOrKlPzINULvUtpk2gEqye6X0VQL8fsJ2qW8
         eCig==
X-Forwarded-Encrypted: i=1; AFNElJ9IOOyJpnLuSSL7hiVNK3ViVekOLSjYfpchrmGV12JZIHhlmzzVKy6nVTN6xywOMdbgN6D2BNuKag==@kvack.org
X-Gm-Message-State: AOJu0Yywhhu/V6I8D+Jstk/N7BZhXWdQt6tjTE93lPKnN/qrGvZRyIJT
	Wrrhv7MPu6QZqWr6HJqaqCtrfOkqO7P6R/InDOtgcMjYFIL2cHuhXTzIfYhpdLMG5oTXMMjtKAT
	DAvdh+gupoeBrZp2SqE90Bay0Pf6qBzdH8zE4tCsP5A==
X-Gm-Gg: AeBDietw/87Sy8tAdC6Qb1ueu0K7mSufhY8kktbAW82zq5LZNJxQmF9xLghTpbwuoiS
	1cqaqRotcbokGvl2B7MQ29d6ZkiQHEkKtUVVZNYq9fgZ5P4RiYVmRp4WSGuk9rPfjZ3Llz5k4Aj
	Zl/ZL9hpw2QRbQMSxnMsiAGTUq2KFHmo5R5gddia5zLjcdJPuwGNrJEPb6TRm/9z7IJuy7ULH+c
	c9VqyeTj8sO+ojYqyCXyi+t29TDu1IDdRP8ynnQ3KsDKl76ixdbnaqiA/GXwWcw8v4TjJLuN+ci
	fj45xao6elKCzOQe3TWnWpXo57k/N6EvpWNVZQ==
X-Received: by 2002:a17:907:94d3:b0:b9b:207c:f7b7 with SMTP id
 a640c23a62f3a-b9d7267af85mr950887466b.3.1776171931398; Tue, 14 Apr 2026
 06:05:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260414121752.1912847-1-pratyush@kernel.org> <20260414121752.1912847-4-pratyush@kernel.org>
In-Reply-To: <20260414121752.1912847-4-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 14 Apr 2026 09:04:53 -0400
X-Gm-Features: AQROBzBIJmRCcFUKFu6XCUoUK5JAm0Xcfc0lfBbPIbj0avBkGkF-wVt1ru4Jrgs
Message-ID: <CA+CK2bDL9Pc1AyKE1DBc=FTBwCV5-p3A+-O_WrgB0CYOhF=GYQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: tr6nnrn3qrubai9bswonsma7mtqgbe61
X-Rspamd-Queue-Id: 0D28D100016
X-Rspam-User: 
X-HE-Tag: 1776171932-938849
X-HE-Meta: U2FsdGVkX18GOxe2FkY3XlzuQGFMcx6jjDdFL/LVXl/3czojfhaEpQHidkbFG7Se2fZ40V2bkIv7r+ynxKtsau51LAUc2EH4dT935+afw1k42KocAOprM443T7YgWKWKlYohswwzXXWAxAbOBrypW/Z9bWTAK4A5p3wJPi2d7IjNUAjKytdn7UAGvIY/04jAX+aClyJE01Gcql/5ihmkRJuhKFqZiBZ6GCeUbLjr1t+s/s0ska6WGbM1d5bQCfAZPv1a+5nwC60DuYSRgGYK738e1UbbjekDEFxgOu0RRhmE03/urW76RbB6xSd07Jwh6B10sqpLGYkVmRExiOZqZQXqbfb23ARmr57s8qxnIyMMwYO9LZTEWnebBSeMj3j9F95yhIvgKAxGjtwuYdAAw15tWkfUWxKA4J4phs37urTIjXJJ6OjyJYkDtslFP59lOnMk8UlqvMrkXLVqRHvFoHevqNZe2/2D+Q2WQDpHL/gugcRJE5LUPsPyrUKg86G/mremtvm/hCUkn61NnZuu74jlj5SO94j277wnv/idnypzjL5XKjOcFIWFzZ/+nwbI4YzOPXLY8QflXSCotOIZGJSxFigfqoNr2x5YTMXFo2rZ2K7nt3HTyfBegekChpHU7yPTw187uKHWoSpaFB9curTa8g86Dx+iZYgwu7pH+CDZbANX6X9Nmuq+OgjnutH1/JF+EaQqTpjIGLnUH04ZSRNLJiN7G6tXv8VMwzx06HeeKnx1yFaeizfq4NzzI50taAWjgBFPXI2CRGKUTcR9Tyv/tULc4tEtQB3dEvuOSv6tUl0UjkDpTZUQ0KSxRQmWxjH8CwW+ONl9fyWcqKN4tFi86geSwKkYrOTqACYlcLztOrkJbxf777oiBqgSK5ObR+TFipwLAQh0QC+wrpVw8xODCGjLhX7ALjbyOLgSICrKkFnI3+s571Ek0NiQBax/Sx9/3uvLSMhSpC8xFKX
 NGgQtyeo
 uABp3KOPlsF7RlwKStIpwhopFH/WYlq8y/5FBJ8LKtFPsxQITNj/zxOPlX6LRM7oZNZ5OaFnPLATOTuqhckz/qQzjQvLzfhqorfpY2e1WAILY+bvvvYQUxm8qcTlYHWw+SXb12q03S3zZyZxbccBR/Zb1mYa+na9DwTk7OLvxosuStFc7Vpu9ijCa3f56qhFrhQTDi0Q1w9Ww+zm7OBwFygkaDU1E7Wvrt4+kOm3HCa+abcgm6PiN0OIuUtqi17UP2sfcHtLaC8LWLmAbySZyNlTrmD/qLcNNAJIJJZtOwVV0aBQegaSeb93aijo7qxIaIn2Zpw4Tk+WzKF3HfIqyqg+1axgiKOCWUyorDXixzKxNJirYeTYwyaDWmLEkNjXAcU0CWCUzQ8ky2KT3D+1El6PxHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 8:18=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> The directory does not exist any more.
>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c1e2cefb4493..bb588928533f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14811,7 +14811,6 @@ F:      Documentation/mm/memfd_preservation.rst
>  F:     Documentation/userspace-api/liveupdate.rst
>  F:     include/linux/kho/abi/
>  F:     include/linux/liveupdate.h
> -F:     include/linux/liveupdate/
>  F:     include/uapi/linux/liveupdate.h
>  F:     kernel/liveupdate/
>  F:     lib/tests/liveupdate.c
> --
> 2.54.0.rc0.605.g598a273b03-goog
>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

