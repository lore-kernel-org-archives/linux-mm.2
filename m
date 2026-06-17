Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E817CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D333C6B009F; Wed, 17 Jun 2026 01:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09416B00A0; Wed, 17 Jun 2026 01:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F7E6B00A1; Wed, 17 Jun 2026 01:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 991996B009F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:45:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17B5D1C1990
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:45:01 +0000 (UTC)
X-FDA: 84888316002.27.4A6D26E
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1A65A80008
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:44:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kj2HQPt9;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781675099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKRmpKmonuyhtIYX9JXaoktO3MKvyjTBa6sH4cggBwI=;
	b=bcReQ0CY0HI/gOpdjmgKLOoh+13gl/Ss64Lq9dsFxphkYiNjXBUyzwy+4MTgAq2CWSTMAZ
	ydkGkWgXicU3YoI7496SnNmvy27K17OefOl08PLpQeQSaPz2ZemqBWPJsWM5DNVWkMgGh0
	8KRh4OlIwxOZfT6JlIehRlmMlI5A3uE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781675099;
	b=TSUEvZL/y9FO+4cYp2y/nKADcznCOqZ+DUgmcOhEDbY0STdxymVqSXXVNWbt7IIE0O877P
	wkECaW4X1R4FPrGIwi9YNFBK8rdZXnNc4XsVrxnxbvK6o3SxzdL+57Edixp7rIjkrxj9xY
	zWOpP2tequPJDaTbF5jxUO8zv33rtLw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kj2HQPt9;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-48673dc56a8so4393764b6e.3
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:44:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781675098; cv=none;
        d=google.com; s=arc-20240605;
        b=kvBHKDZQwZhtBfF2wZe1NClJYHy4bxQEye8Z+A1bOBlIYD1J8uE3f0rGKgOT2MWssG
         jf9hrK1VzmpYZgJlZeC4Eu5FuTMarLL+lKov2xL6CmmbYxKISY6aDlMzjttKbN/267e8
         abdl3AL8WZvJtJ5UwdIBbrTrpjG+hepmhqNfbEc3as0VGWzZfn0h7bgg9LOKKHMAYc9d
         m7wVKvVQnvzc0ZbdBuEBYoWxnQEZLVNDmxsXY6KYfX34Ykcg2xcYY+rEjXvZ2jAKp93n
         8aToJz60H/hhXXMZ6btQ143f3HplmJtBcCmlJ9D83eZNJ4/k3yzROZGPvCZtLx8krvSA
         PT4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lKRmpKmonuyhtIYX9JXaoktO3MKvyjTBa6sH4cggBwI=;
        fh=LdNBRTgQAAJCY6bhyYLHJRM0JGeIsXreO0aYfx+KSXo=;
        b=PqYij+txo+klaU4S9tdVUp5UIMvhKtJcNryaIGl8eD1tB6RD+ztLog0UMx8SRKRRJu
         osefiCQU4XzOw7XoyaBwT3qAvmBTSJKhU0qzOs6dBD753ZfgwkjGjV0veqnwSi3k1CEb
         SqTPWZxhKQvtQlMXH4afy7vmJa3eeXNBIHQMyh/hdFfSYyQWlOVanQc1H55nAXNVTMe/
         VMxXV3mL9jBukcuSShnoFWDMe+7wGct45iRnUPNAp3esiNrbJbQwzO/xU/zeDzDZq5o+
         4CDrF8e2jOCyWN4IE9CfpZz9+zFrZvdWaX96OidZb9K4X8exKQAVvw4K7UjsS/I7EJJf
         gkTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781675098; x=1782279898; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKRmpKmonuyhtIYX9JXaoktO3MKvyjTBa6sH4cggBwI=;
        b=Kj2HQPt9u6tJjAfCbIPf14ivGNFfr2zPwfxKXO5DiH5omza0bvWWeibdwAWJx7gSrH
         NP7fkReDTeLj46JZKcEeDBJwHEWjteQyKATiqfBBr2AcZQbby2xYKeuc9J4FWnnNM5g7
         pHGqDnNmm9W3Psj4mpuUlpBAFtIHnX6vSk1NGxCrJZez3vboFVQDNdRw9tncFiP0OL3V
         tgPv49Nvt61uxb4N1sZaADZGS4l1GH5GTjQlD7Iam3qRyALk0CaRHsR+UHgxTKa17HoB
         +vptektLCOipVKBcRlN8s/tpmqrMtPwJVm94Uc2DXty0Q2dCUyXYNIea57gPFTwu37HA
         YTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781675098; x=1782279898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lKRmpKmonuyhtIYX9JXaoktO3MKvyjTBa6sH4cggBwI=;
        b=XFM5Kvt5QEVF+OjZiwWqt2lYtHiI5H77VhJjRWFHlpytkIMMZWq83D8JFN2dJD3JxI
         g3JQxJnUg2ggD6hkt7HVRuq4Clc67Gc2ufshDL4dVELdUjjKGEZ8bEu+z9C7u8c1DVbE
         WkCVZuKdpes0fQvbJSZI7eUkOoDXmr5ujU2OgTOACOXE29Bc2z1Gz8YHWPfGSMnKQPol
         ryhl6tXeQwMDMCnGGNIwlgWi9tk6EMo4i457hgBIWB/5MKqDy0yo7XrWPe03PKVs5gMc
         z3plV/Jj325JM7DUDEDMYe3KJMzNmi6Cs5U63tFaP6D8+SDnSQtKW2Ix4jQ/0fWjzMIi
         dCOA==
X-Forwarded-Encrypted: i=1; AFNElJ9On05joZYuS5Ja+fVHnpbQ+gD1SwMgdEIUI69vx5oHJPPQ5If9TuFSxDcpTnOhSakjDaqssEcWfw==@kvack.org
X-Gm-Message-State: AOJu0YwkLTwoRt75xFXj3wWnn4oc+4C1O+rpUnx0UsDRjKL69dvvrofI
	ThrMMCTwI+ov8ZHmk5mcGCf6G0sA29Vkg3icDzgatxGD4hLF1z/n7dcCcSI5YZ5Of2vGn9NNWdI
	eP6YpSUSsTHV+giYJhs9MujPJPkklBPE=
X-Gm-Gg: Acq92OFoztjgESBvZ+TNyWsckIi3X8Efr8paXX0yJdYSYtdN5ZbfxUQOIcu6g+rxi81
	hLfvE9WnkbaP0miWkBEJkTsAxGOzqB1KAGRyQRuSCyvrjqYPYXACzQfzQ3QUm1GHltlpo9GTw6q
	bbE+Y7cLZKqYUoQgO27etnVZGQktR0UNDOuI+3gRWsydjAwa+oSSNLNHCl2PSTlg6SBTIe3qq8i
	aXYAvJl+tiTqnP4C6VbFt67moRYzfn7jgxahf4qLnC4N5JZ9Zm43jXk8rQ9EEwzXKjxhyerQg/r
	ViDPwERVy6uStHZwVf+kAJ2o9A==
X-Received: by 2002:a05:6809:392:20b0:486:a606:c6b5 with SMTP id
 5614622812f47-489429be925mr1512679b6e.23.1781675098075; Tue, 16 Jun 2026
 22:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
 <20260616123646.GB21024@lst.de> <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com>
 <ajIYFtADxQDq8q1P@google.com>
In-Reply-To: <ajIYFtADxQDq8q1P@google.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 17 Jun 2026 13:44:45 +0800
X-Gm-Features: AVVi8CezmHOQc6ccEaHRKEOgVGFkbymHQDWys_oD7V4L8KIfGzy5Bi0-OqnliFw
Message-ID: <CAJxJ_jiM_-a52EOm896FXkdH+wRxjSHJx+MW6b-ewNLVkp4uSw@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-doc@vger.kernel.org, Brian Geffon <bgeffon@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A65A80008
X-Stat-Signature: xx149tpba4tfhfdywemrwhaxmidf8guj
X-HE-Tag: 1781675098-352487
X-HE-Meta: U2FsdGVkX1+9bgwiyCZlNqjZZjHN9BCQD0puZBF1ouZTez+kmIFilcmrManpMs7bcv1S6AKZgaecH7+nG7OX4PxNUcA9JhVoW5BSWdsocnW0alOyIFYX9Ft4mTQNR6xB6e7GFuRQs9clYn8Tg2xBCcNP3iCZlKQubye16aubJ0HEdlKgqtTQlBE/GLHxh9R9uQnqKU3Ht9h1hEXRHT99yePdIMuj4/3av940hu6zRfUV3fDhheG9q7ljs3ZaU99pkAOBvq1iKEoiirhNJ7l1QbB5psCnX3cpztVn8bVGRBMeNiloBxhbSWSYu6FEiJ7QqQQOPItBX/UfQWx4CdDGD9FN9b6ETthhdBv9d6LYKsC2lic1AsxXbkJvUX8AIYR3rFUC46tpsc7g6bY53McTtUHGtqaE7CLs7E8IXrI7RLxGvqc6o+SOzczA7BVu0gLERvU/vYLTgKyxe1iIda7mrp1KZebieo4XVwoJG9rIN48VX73FY9JnZqy6RT755tkK1srYITjgUQ8lxcci2c1XAau+RBL435kJWSJPILLXK9bc61tRUsQiRQWmjk0UV8zv960vWNvSGhMyiUd/w1fej1GCl+LEXk6MDgbt1lN/plYSteZw1tRG73jZGYQv2hKPeGuRH0BRvT9b3UgZ/9QJ1p8USvVSfCRY+I2ID+J9PIMavpMic0/abuzkpINIFMqSSaGFBsoHBds3U/Ui04LnXjBuVGdPet4cnzf+l9HHnGq1ccwhddxcoUmjizaJMOi50rysJZJANFsCwsNmW1TqCgbGSeYJAUlYa2T8UZyjkyIoWSfGfO50sYZEG7galAt2Cy7nmoZ2P5cAkAncNuXw18wSBHfnCcuj3L8G5sNBkNtHAeQh2P/js9w002vZsVJHqm+xJ4pKvySeuDEjCOpw+EbcFww5fF3VqZqyK68y4qLGEdQFLeJBBCcX1aldM9SXnUBp0al7QR6ak9rJPB/
 oep5VeYr
 S/gjkcNNlGlYxvYmDLpBdHpGEZJZ54noCWZYIdXfaMAolw8Y5fOee8eFUqOUItbdlrQab7J+wY5Xicj1qvyMGzRO43Z2ATB/o1gQlKQvcbvd2giYPSYk6nXxjkMznr8JD4lvAZQwl/S9BpmFSVloticyA2MNUmGcFCjckWIcX2tpUNYLR90Zp6uWCRo/5DvgaAcitN9APfgaASLFHTsfbyZ5/Fa1xtrKmuq5DehkEGB46LTnSiEgCgAGXTAVFjTjoJSZezjKt9YV/V7dxLNchVIDOs8L8ZIMyG6LrOOye+l9utGj/xbI7xv31rGz/Ck+Cr6nju8l4v0kyBzZPmcx2eiFGX8lhGzEuKJ3TqFBHo31Q/qwKLiad22Cj848qlov7anqZ0c8XppeZwB2T+xGHtR3PkfOrYGb4wFkjMjzx6wGFB0S/CtlwFa2NID/gtcmbbfISdQxOwJMAfX2aLYCiRXlodrgF9ljln4d0oxW43/VbZvOONlJ16ohiiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sergey,

On Wed, Jun 17, 2026 at 11:46=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
> Can we elaborate on zram being a "legacy interface"?
My previous wording was ambiguous. Actually I didn't mean it is a
legacy interface.
Previously I just compared the new compressed swap implementation.
AFAIK, zram is widely used in many products like Android, automotive and Io=
T.
Its usage and interface should remain unchanged, as the impact would
be significant.

Thanks,
Jianyue

