Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D4FCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8518E005D; Thu, 21 Aug 2025 17:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA94E8E0056; Thu, 21 Aug 2025 17:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98758E005D; Thu, 21 Aug 2025 17:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C203C8E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:13:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B78C1DD3DF
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:13:07 +0000 (UTC)
X-FDA: 83802014814.14.515DDA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8CEC44000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:13:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BZTKWrar;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755810785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6xqj4lW5B/6fVlg5EVJxHpexkHl9OFsO840gKJrwo4=;
	b=sdqDiubh/UnSqJrF/4esAD0aPkC21K7Ll/Wg5hdeVfe+TJyQpP+UC862UVSAujo57vyenC
	MyqvxX2e8Jh8Ue6GGlQOsRtALPB/2B0lun7iOu0SXRDXzombtDDAlfC/7eQcALKrFk2xrp
	IqFnjhflEUnquhXvzyWYIEqvn23hOBs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BZTKWrar;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755810785; a=rsa-sha256;
	cv=none;
	b=oNL06pt4iERBP5RO714IE7JR4v0XteMhgLTKgHQ93sQgTLc+ehPLF9Djg//W/IrxMPsFJ3
	nzrGj0HcvWw9yj/O/yZhjJ2zvOFGqXO+ozIzo3F9u3TiIKBRQdzr9V9TmcigFNLsrCUnS1
	YMbqu/bn2R0tjb8k0C4w9ftaHyV8puc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D914360241
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A98C19424
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810784;
	bh=d4LvZt2aqV3dFzac86Byv4m6KNuAQDtZesHFxEyue/g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BZTKWrarz+FjcikzzA1VRYISyCwmmVs7q36u6GQ5nLj9rMp/6XDxRrX2yEcN6Qi60
	 vE2iwGEapgUoT6jo9NBGg/sFy8TlAqwRqYkNq/lYbmXGpXNqOfGqIX4b+OfhlupjPt
	 Pq9rWFXiKZcofJV+a9khr5a/F6D/t8D06iKjyM9LHeuwDn3MnUTir2JVyXftsnFF5b
	 /C+xOBsWw5Zoi3RslBsV4LEtTjToptKyG2jRG/xVafKlJyVnPPvmhJOBRsPRHmcMH9
	 hc82BmzhACWboRl8bGmN/p24RUprdE8U5N58RrIUkTgAzFkfut3RKkt6cuwVAX2TR/
	 bubme2TfdJeVw==
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so7755e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:13:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVuA0p9BrWhz2SxO7TIhV0w6XqqHTRsaF9T42aHRky1ns9WIur2Yj7UZwHS+n2kHcPtrXvgnqrUbA==@kvack.org
X-Gm-Message-State: AOJu0Yy492O/2nMzlY+Nmhigy6R8GTRD4prT9/5Z9GSit01ogvwlTzbi
	BxE9pczYtKr39P1bXKPkkTyCC1J1wgyW4w752v0FHbSwCOhTZqHOy8CE/P48pa4gXO4e4IU3yyy
	ZcZfucn1dkpukgF2Vc/JTj/C5fQdKJnI3mT6h20dP
X-Google-Smtp-Source: AGHT+IHwAslQYh3tct59quajnnFXnOJIh7Dx/F1xRgBrh+DxXFUL4O7TIP/4OJCF7vgKU/9zH2fA6BUTYK6TqvAM2Ck=
X-Received: by 2002:a05:600c:2d47:b0:45b:4acd:836d with SMTP id
 5b1f17b1804b1-45b52128850mr39305e9.5.1755810783115; Thu, 21 Aug 2025 14:13:03
 -0700 (PDT)
MIME-Version: 1.0
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com> <20250815191031.3769540-2-Liam.Howlett@oracle.com>
In-Reply-To: <20250815191031.3769540-2-Liam.Howlett@oracle.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 21 Aug 2025 14:12:51 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPs4FBQ3x8Z_ME3vjwJHaAtHeE8jmn9pBqz8cau72e_+w@mail.gmail.com>
X-Gm-Features: Ac12FXyAKFIrA1ANsgy3Dp9wOcjESjPU68j7zxxmQrp3w0J6Atw6ZDtuSNed-Ek
Message-ID: <CAF8kJuPs4FBQ3x8Z_ME3vjwJHaAtHeE8jmn9pBqz8cau72e_+w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] mm/mmap: Move exit_mmap() trace point
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CEC44000A
X-Stat-Signature: hiiyhatsiibwncpsijqa6juoi5prby4m
X-Rspam-User: 
X-HE-Tag: 1755810785-56778
X-HE-Meta: U2FsdGVkX1/75vzL7pUEZsdHyL1GHhv1MzZRz3qjjjvzNf6F6hw1ahwD/u9wgvq1nkWIwPqX7FWI69lsmMAeS+Oy5YXni6o2ZDtkajDtqpXmVyFPVjjqgKxMcUE/MqKSWo0NqLds+WFdzX7OXUP57jVV/DXLdz3gZofOvkT631EPkeDA0XrSLFi3G6qIBzHZLtuMgaAMGBS3L/fN393r2yPVm9fE9ZodTgoZwtnxwya+DQpnTRu49neeYpmoRkXxTXqpj3Ci0UXDzFr0NUPKX9W2RJeqnhJEw58Kx2OKyBG24v2d/hLsrnl0Lz7JOP8UjGT3JL9kxYO9yukO+lL9qYYQDILuaKoB3KJf1T+8nGNZHhEdFnXofsDbARAvHXsgv6xLFkROIEcJg3A4bBbq1nt3Yzkpj9Pq96dnEv4PXnKhoE7e6preU/IsC+JnwaHUPc1aOBtTIOYt97+A9n+7osn2fFHfd0Z86ECJoyf1g4uBgIYPThdEBAT19RJNJR2WbFf5G8ZQAbF/0WxF6jgDUR7S60nYIBDQGgZKtZnV06IGgqDhbDUYEj6LBLh7a1tHzSGE8DEWXHPoCuV986NkmCQEuPYglM4bTsPiTnlg40Z+OpQIkDi/2TkUU2FvZcezrIMdZZdEPl2iP+cmGys7vDZ9c3IsxkTW6pFkZh8COw0efYig4eR2MBvyffaeEuIibe5Iciy8GehwaBi8QNpK0P+mqqGiQTwEx8OQZ8BHOppmLAvW5UxuZM7SFyJN/1t71Itd8cauf6Du9/UoF6kAzEsR4UtjujUUQbHIEd4m3XQnYzvLfjceaze6fn9V5uK/NddQq6w0qiMEPl6tSvt0o8f5ngjAasDuAlo5gImPWSirSlZkaYP02p1ROJE81bNTakoHznQfLtuuk0VTCqSqKbcpu0pm6RgGS37YgOuVldeSCauHqKRxcLdK/D0Cb2n1gAWThG2ZK4BsUzVWRPy
 uqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris


Chris

On Fri, Aug 15, 2025 at 12:11=E2=80=AFPM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> Move the trace point later in the function so that it is not skipped in
> the event of a failed fork.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7306253cc3b57..c4c315b480af7 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1310,9 +1310,9 @@ void exit_mmap(struct mm_struct *mm)
>
>         BUG_ON(count !=3D mm->map_count);
>
> -       trace_exit_mmap(mm);
>  destroy:
>         __mt_destroy(&mm->mm_mt);
> +       trace_exit_mmap(mm);
>         mmap_write_unlock(mm);
>         vm_unacct_memory(nr_accounted);
>  }
> --
> 2.47.2
>
>

