Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDDACD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1986B0088; Fri, 19 Jun 2026 10:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C9C6B008A; Fri, 19 Jun 2026 10:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015786B008C; Fri, 19 Jun 2026 10:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6EC16B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:03:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B08B8DEEE
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:03:44 +0000 (UTC)
X-FDA: 84896830368.09.F727428
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5211F2000F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:03:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cVmwjbRV;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781877822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5H2QPFFN8CXrKMI52PmGCQTYysXI1peBXTupsEEeH7s=;
	b=AyrA6MvRpexio7EZBQzMWUMJnXwRyA5kiaMKm9JobuzdWbUyGQpoIRL+l2XqQod98Bv1mr
	6/b3m+Wpwn74zYjvtprFjiwNuYfbpYE52/umpZ+vk0d1IFRNJKRZ/F9swslQOaLnBYHF49
	VwDuTaX9jt3om6XQtRjvOcB6Li1IImk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781877822;
	b=0NcqjCH6F+NhlY4NZ49enSUyd1NJz5Ra5a0Yrd7eFBHgf6nD9A/Kjrfu7a3A9HU1Gl4xGg
	2sbktCOlvdwIUFxvP5/jN+vD7hBEujftKA2awoKsvlCw0amHQN9T4nmaOowA06R27MWDj+
	rC9Fy3NwjmAz4TQp7BzXX+0fcURIdY0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cVmwjbRV;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-519ed52bcc6so180791cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:03:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781877821; cv=none;
        d=google.com; s=arc-20260327;
        b=VKMZKiNjQJpJvEhmYA6r/E970Q2CxhCkt9EXgADItmIoGok5S9aUUT2G6rq1WlJY1C
         NGCDQZbgE0OaB6tJBYy7QP88hCpW4xAkUr2xuq8c8laJ60OzHMfSu8METr+pbeGUnV6T
         6M4S0ZtvdH5thWD/G72y4mjUSsyIimjLtPjBmAOD0etqowwVCKkuMqbviMo0/iblecmf
         7EdCQEWRMqY54wtutdtkHez4hFlcPOerra/ZbUSGlpuznWzZHcjoDPhFLJfNoQJyYpDJ
         +/LGY6An9DfqNNZ69we8CRVEfumINqXPr+80rARg9FBA+V1KWZoeCOWF4OT9Tf0t2VbC
         RYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5H2QPFFN8CXrKMI52PmGCQTYysXI1peBXTupsEEeH7s=;
        fh=fZ1WekxqcwX5fraluMEtJ6z5f/zVOlUKwn1FPf2We5Q=;
        b=iYuOBbvmLUCljA+LyRGWv4ls9WSfZzvxf55HbQrJN0HhagbOEsbb8DQDJLJGzd/wIv
         yn6sDKNJy2nxW56YvxWtGMK2K8DNwNRBn4CKrLr7gzsl7i5cnECtVXlkxQk8n957cht1
         YbTLU3lAdkHMhxknOOeUWLR1mkKAy1rfKKP0WqHCo6tKhh/WZAdn9g+14KQC7bWt932T
         ijJ8zLRxcWtVgCQBOrh/ZnP6QqTVYGP8OWSecePSBG2StOi3vMDhWfz8Rseb/rQShBYc
         d2U7gCFarMUSkLw8Wrttjj+n0iwW+N5KNjuszyZ8pF4QkQbBkej5hLnvWwcf4BBR/hWU
         uWjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781877821; x=1782482621; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5H2QPFFN8CXrKMI52PmGCQTYysXI1peBXTupsEEeH7s=;
        b=cVmwjbRVfwuOXU7baqUD8VFuMNoz520kK8/NKzR2vBgDpj9qGGxQdnB8HliAjynGok
         R/L1ca9Sk9ZJ5uWg0Z7dTVzfrbQ8gLRMWbwRYGF8F73kC4Au8461XPWAB539tG+waTeM
         Nye3XwNQxvz3JEsP+l0tfYqqUdXnDLY4wmPHar5pOgrOk5znDudcrTsznqWdYPLafWp8
         Dtt6oar0WMaOQG7j2WnYeBvNkBYND55ehEBMBHmczUDB/PboZqDNEE1bZbML64MxMnLg
         a09+5KiGxH995Liy2JZOpi1zRHJXxc+NYbJAWCzCN39Exse90D8GwqkeHAw74E/f/OeQ
         cNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781877821; x=1782482621;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5H2QPFFN8CXrKMI52PmGCQTYysXI1peBXTupsEEeH7s=;
        b=nTGbe/rEixUeBYIpx/pmJHV6qwoxUlt1/TVEQhAocOvLR/L+qnBxNVfT3LL5+85SSH
         HaCxWoRgrXyWX7IoexS7+EB/wPi3HeQsPeq0Wtgbp9beEc+AwBv9HAsuSHlVigBSphv5
         exHSPZzbASX9XhLCzjh1vl2bsxyLudonSOtlv0Jxwl0p+4WZG8YbB3bhrEmciJPgCqMb
         uMNHj6Lhdeny5Xa5jZZ9nMLN5w1LZHKb9c5PckpXvsN6JqBJL0J0Of95BetmQAv/bczX
         tqS63pLkRQKF5ak/ghdKpLCAWr+R/KtAVjOlGRYDHjuMJLr3iZGRPPIj5TtMDgBaqIbE
         V71A==
X-Forwarded-Encrypted: i=1; AFNElJ9uDMDnihkb3SH4YYssPjo0qU2QMc5yHgZrfJu7GccHDnc6FE2ZfbxpL+66RZHtYCk8dYOpD1kNkg==@kvack.org
X-Gm-Message-State: AOJu0YwVCXeArmJw02Tijvecpego7OY1OEilqNoESYJSWDaxXcWG5YKM
	rJlgkfD1oXE4qxMiCeRFK0iIEp/msF6Osy+oNHpd1zkrs3xg/CNNHoZ5Jbd5sNq5+GFHr68eKoC
	YBRqRoQyvLjZN9zG0Db/Q3JH40yDWrLzGixyx+Ld7
X-Gm-Gg: AfdE7clOzF/13ErAr1EJchWTP3p7VANcrfgG9y7F1GGnvJvhp5q7Rx1Ls99eM0b3A3u
	ag3gErfx5qzXqWoxRbuECf5FLiTnyGpKsvO5K5BOfncEanuEcZT93GVmzxjVxr1zQLzKJ9x4EdZ
	cv+SO9lGtVAxXPbm0pMKpu9dUHPHGrdn7R+NUqsaMaa69gZoT0sBmFY7K5aDDPKMxROfwlW0mG9
	ao2hffekxvzLHZMy7gBa23v3LwfNiT4wAM8feQ7Kg2vy/LxMrN5aRdpr9tFkekVInwhiaUaVumh
	VxdvtA==
X-Received: by 2002:a05:622a:4c19:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-519e891c738mr6591571cf.13.1781877820579; Fri, 19 Jun 2026
 07:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260616190300.1509639-1-riel@surriel.com> <20260616190300.1509639-4-riel@surriel.com>
 <CAJuCfpHHkQyj7MMoH++RGraZgQ1Hr+4=T4PfbBn-minUCZyuOQ@mail.gmail.com> <af82cd43ef0c5bd4a5337942650fba3b8bccd94b.camel@surriel.com>
In-Reply-To: <af82cd43ef0c5bd4a5337942650fba3b8bccd94b.camel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 19 Jun 2026 07:03:28 -0700
X-Gm-Features: AVVi8CfpJcQTB6G3nuHmlsBh3RSEA0Ns1M3RTmfmgiu2XzuG3p_QqdR9P0LoDFU
Message-ID: <CAJuCfpHa_1G+krJJDOS6z8QakngaV9jpns9Psu0zUJ=wb6rJQA@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where possible
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5211F2000F
X-Rspam-User: 
X-Stat-Signature: 199f36j97889hrpum5fzukd58j9mjuqi
X-HE-Tag: 1781877822-670606
X-HE-Meta: U2FsdGVkX19f9Eymj/xAq5kelENwQE50YxpEUmLQl2YJrL2E24oje7G7qLRP5OjPisFpvEo55FDn+0QLT41Scqy23C9Z+yWbVT4rrIkEX7ga/bNF3XUxddvqYSHWH85gj1t1fJJ5pvfd9cVnqDJVOw6i54ynLp2TGBGQW2uxhEHoufWpjJG9U2uXMmFRXSqR5rllopl2VoxTqr4lzjk18EES8VfayepFPwIcerioWn6TMg6LTVhstI8PX9eFOu7YY9chyfJb1PitfypRvTmf+aLF9dmOim/JCgHro7UmSlF3Dk63GQ2dac6nhvXKTR01TmW4ihCNmXUIyo8BXjAc6b6DK6ySu/5uEfDP7vvQpHiqU7llP+Z/UkYznBWNnawY4YQe2M30s2FRpcZXME+5GqhWAgfvVobqB0ilKAOGys5WsZv4BDzv0XE5DybxFNhQamFaQ0pUJ58KExpB23s80xJ0C5lfG/MC1vkRnay/6xTH8ouC0oxP7tova0Vwe3fBrzwo4yYgrcwhT4mYAWxFP8FIY6YdBOopIil/v6RrC1dSYjQzJggQdedtCNU+9pxcLVdCbDQufg+vECcCR//Mkn33PLaEmPVw7K247PCyG1QvlPl8MVSt2uG2JsKJ3Gu4k/r1+tJVJ33KLpFOjUZ8CcYqP0dcjZ6SN6GosL15oeJfL31xFVSayKEDgRUemo/rn3OzAWrkTXTGMVpP4Wu/JFFT3K+7RMcvV7gR9tkFQjijYteteHI5nEhv8WOoxFGZWCjYtLKdG+V2eSd0FjfPJwQqd0h1LY7RgseeJB73GZpr2e3f2w6imqzpfJcVIPLdVbxzxTMHdyogb5A+5Wtt4IDhVy5BdDyIkZQamK4rJuSeLrl3I6i7WqZoFBWE41lYnWtDqdbcaLQTuAZ6lZB3ibBUr8+S+ThkuT5ofFa/d9lY6gbIyd0v8mjRTmN03YdPKjm1qPuVgIXHtTP5/WK
 nrHuEJ93
 yLFestBg3K+k1g0zCUGyZgteiTTrrTSFc2wYbSMiVXiEIyYlBaN8+arlvrZPXqhx/jDoB/Voszc+vOHLDkiI3uZy0KFDfGeFOYwv8Ldhk2gyuMpFuzd8k4e/kEzJwj2OMrj8G4YNRWMDDfJYHU4Y77A4sCzHARlyL9OUwQsyLYiPfmTbliKSk0oOz0TpRHW+woJDpGgogfq7uk69XCf1K4/KcibbhilpuT63VXVIYRQSM8T9VOY2EnrYGqXYtW8xcOX3nQ9+3K0Ogsrwj5zgWXBlaglM7TrQ7ZqoceDNueTWWwfQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 6:47=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-06-16 at 23:19 -0700, Suren Baghdasaryan wrote:
> >
> > I don't think we should be using per-VMA locks if the read spans
> > multiple VMAs. Doing that would risk a possibility of reading
> > inconsistent data since we are locking one VMA at a time. While we
> > load and read VMA, its neighboring VMA can be unmapped and another
> > one
> > can be mapped in its place.
>
> How is that different from userspace overwriting
> data while we are reading it, and us reading half
> new, and half old contents?
>
> We already have nothing synchronizing the contents
> today.
>
> All our locking does is protect the metadata we
> use to find the memory.

Current locking ensures that when reading across VMAs, the structure
of the VMA tree stays consistent during that read. I think that
*structural consistency* of the area we are reading is important to
preserve. Someone can be overriding the data while we are reading it,
but that's *content consistency* and yes, we don't have protection
against that both before and after your change.

>
> --
> All Rights Reversed.

