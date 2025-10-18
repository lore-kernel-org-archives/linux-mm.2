Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06DB9CCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAC28E0014; Sat, 18 Oct 2025 13:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B3B8E0002; Sat, 18 Oct 2025 13:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52B88E0014; Sat, 18 Oct 2025 13:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0AB48E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:57:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56D1B1A0488
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:57:11 +0000 (UTC)
X-FDA: 84011991462.20.05C2A9C
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 32ABF100005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:57:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=McBRQ7tq;
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760810229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrPVFS9Dd045lBN8JzZ3YytOba9ttGQFMrMdfscWZIk=;
	b=VO800V3tNxIfwHn1a64Z53SI86hfBsj0LvVK1cbLlJTI0gAa6/RKnXhv4/4m+R/xyqSUeE
	YfJVC5V5veHj4WSAjxJB13v7PKfOpprqRMVV45ALd1O+vjLvQdk4FkMaX6UL0E06sl/3wd
	dHkxH7xE6zRS9mka5EtJMi5iyRLZ6D8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=McBRQ7tq;
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760810229; a=rsa-sha256;
	cv=none;
	b=mvbkJEddnbFf2uqkaYJrC3Pi+Aifbd5/YA8jUxJG4MeZkmZcjc05HB6bjSqsDpfnVaYquH
	kFAagJTnxYzCF9dmc8DM51YOz6JjTF2pfEzH1cm3IdHk6Blt3lYqPklZJLSwEwaneQcR7V
	M6MjtC/vfy+OQyMzjoESlObz4aBhw/Q=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b3b27b50090so525819466b.0
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1760810227; x=1761415027; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lrPVFS9Dd045lBN8JzZ3YytOba9ttGQFMrMdfscWZIk=;
        b=McBRQ7tqIoDkEUseC+QrfIQpeeTW0bZb2Zt1/Tiy+wvIcvIBZMIayk1HnSymJGSXYi
         /uDe9+vE1TYj/6eDw5qg31E8nMJiXooick/ph9/rKLFOj8A0VJ4Ifv6cFW885iaw6q3J
         F3gWSSWceSOb7jQDy8q08cM6Zo2jxcmtz6XhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760810227; x=1761415027;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lrPVFS9Dd045lBN8JzZ3YytOba9ttGQFMrMdfscWZIk=;
        b=HTbK9A7nF9Af1sWNRVwRVEvUEgaFUik4pcoUJUOrovyOjxB5QsLzoE8s4xDwvG4aJu
         WLHHJNNIx1e8oQgb1O8AHnNUFqrO0gXqVKchM4RjE7bHtIv4ctSwLhvN7qHjnCudvsth
         D+DOl6523LrBS5UjN8Qs1PRJ1/VMgCS92gD0nUv47aL+6NyQOaK4Ko2DUkYG8SXzKiJq
         ak5UlYk5vYSmXWjf2uVVnISqbRHGax0SkdM4jKuiFVPcdYjVnmQ+QVhWizw6MXIopbI8
         QxkWyHigQBWbBrtT+TmPGBrcKmV0Vjb5iLnhqErq0aVppOHRKKaOgBqiPcm7Zacgrqml
         Yk1g==
X-Forwarded-Encrypted: i=1; AJvYcCUJMhGnur91aI/cXq5wDA5W1W3HmhftWZfg2UdUQfL6D7AvafJZp713oNYUfz2dI1AGjRbq5oBI9g==@kvack.org
X-Gm-Message-State: AOJu0Yw2rRkXhqqi7RuA34+1Rb8df86bRkMmg6Jar91jzuneqD8tSwpN
	gc/OWD0FRs6uZfJfcj69h37yxqJOUHL+9Ao7coELkg/th9tlq5/PvOrD5VnCpd/LveaG6xwfmRR
	nLYyB
X-Gm-Gg: ASbGncsHPyCX9GWUXHtdXMV+x9UGrXS9eqEUHTTpBJDvOkta9Mn2u88O+W90faCKxtS
	IEeSW8NRopGmPU53VFuH4AG4KnDpcSX/DYFPhxJTW9YZKPpLNfUmJZUQqoBsxBq2mv1NTjsAxEg
	0lWHU5ylVZyxEd56xVEkxv88KvY1NUFXywo1viqndihcHd9naZbiOuRn25010CpsbW7rQMmROJ1
	PIV0B9p8yRV3Uj0itToDaJZdf4rQVRZOaPwYMf7kB2yJoYk1FeCrQddkHtg/Vxe3RqoPDbL1TJq
	PDW+ckN8w9lOjuL5nbm2ak3xo1aXTtEsGVWN3LEiIzKFwNwZM957XTo2SOtddMmV3+pceVIFz4a
	sfzA2UF7pB08wiY3F0bQi5qs0edjCq35BJbwoXEkDeRXshlSrctDY8gIEgBNLW5Y+yfdTWsZkOQ
	C4PlkgU4p2bcYQBJBHA6kDDd+SQMWTO74OPWtSvXlHz1435DHH0g==
X-Google-Smtp-Source: AGHT+IH2ruvLfHimgoEYEjAWcsom6FZEtztFWpFlyGQCTVX9kwZtaozUMdKAr6w3vMmYa+DI9mF8+g==
X-Received: by 2002:a17:907:c0d:b0:b3d:200a:bd6e with SMTP id a640c23a62f3a-b647512477cmr774000366b.47.1760810227042;
        Sat, 18 Oct 2025 10:57:07 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb036b2bsm300367166b.49.2025.10.18.10.57.06
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Oct 2025 10:57:06 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c0c9a408aso5261316a12.3
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:57:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVxD9Nw132ZHGUzxN/8nrwSD4bRzh2r5HaXEtKzywzTFhmIcxJqB7WsjVQeBsH+PX+wBxmoE2moGQ==@kvack.org
X-Received: by 2002:a05:6402:524c:b0:639:1ee3:4e83 with SMTP id
 4fb4d7f45d1cf-63c1f64f094mr7116093a12.8.1760810225989; Sat, 18 Oct 2025
 10:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name>
In-Reply-To: <20251017141536.577466-1-kirill@shutemov.name>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Oct 2025 07:56:48 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgijo0ThKoYZeypuZb2YHCL_3vdyzjALnONdQoubRmN3A@mail.gmail.com>
X-Gm-Features: AS18NWBhMhgs4_s15aKV87bAatc3jK6By6Ho8BjAuIc9dhonJUNbnDV1fLJr0qc
Message-ID: <CAHk-=wgijo0ThKoYZeypuZb2YHCL_3vdyzjALnONdQoubRmN3A@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 32ABF100005
X-Stat-Signature: aae89atxjic39iu9e9trcduz65mj8kuz
X-Rspam-User: 
X-HE-Tag: 1760810228-396101
X-HE-Meta: U2FsdGVkX19GYq91iV6Wp0HtrtViNJgVk6V4oL8zHCPljOPLJ6Bz0oH24Ehqv2xE+bsNVharUeKHJd6bvISUkOHk6flmZBAbB7x1Ybv34wskUP3JpPEbKRz2AdkB4ja497Qf7JfVtJ8QAZQ1hXv8BajDcMUQDLNsRjj5eYYbMkuCxC/o4JZBlO3G6SehqNgbHLGkVjszzoS8aNJreNS1JFbB7qxvlAHJ5dFVdJaFzFbEeKAhQHRQO0byaZalWljCsri03TFl2GCBLQ6dKMaTHKiSL5OtXrGHqev+HB+WMftmLN4TdrrqU/RyiLLnZyXmrveVR/VA8s5o7vmaPdhBXerjKx8EPD7wf/uv2MW7H+UPZuGIdN8zZo0Vnqv2loNWHk7XFr9f6PIP43myKJXXmL5sOTkIc1eXqqCqmYFRQfMHmNTId4D60hDoeOuRe6n+BwVF8zmZTuBfYwN2AOJ+dzf58cEYCjXQ5redZesi6KMMthtuzxIPFqIYb9xxG7i90n9JdH3yIzMSfzgSuFyl2yNEJPg1S8jrRfnOWj/G+MjEc9g5zLn9RBLbpMb01UNCm3HjjgmS6pGYitzS+G0FWe+EvKvDGA31pDtGb8+GnwEfLq+Z/FE1QAzdBDN1pneuXGNVj0D4ztzbt1PCVkM7bLd/lBaQkuj2JqDfmA26CNxbnjH0pkYFhEAMrAfrH2wMNAtl7lFpEfKpyAhNM8E9JqZ1vUpZmvruZR/XKAu/FX7g+BGIwa4x/nibmQ4hmWiLpkqQ9PrHYTLRK5rPjg8iTFu75F7jAcMngYLdCos0rTaLwlGrvxH99jfGUB8B/Jdr5aQRc1G4pTI+hoZ5PnndOeTJ3POHw3IheDewwnYqPj0S0O/EKLiu8uWYio6fZmnI79IkBJaUSa63xltWs3cMhDASQ3/HApp0OyBz3uOPrF74xEUkkFvR2fm+2MnOdX7OWVnhcstg3J2gI4Yn2F4
 q60xPOJJ
 dxwP4+tB49U12YsVfhB7Et3uKQLgh6N5sz+Fmc73D4aVk7yVYuzKpuMGgLCNKS9IIbocGYrNZRHDiSfujlGfbj2fLmANAv4/jyPOl7HVjGFyKUsf3iE4z+mv78NmQ6pxdgwbBgVbFqfMH4X8MMCq7+XMXThXJgkiHIauVKFpzHL17nGlQlXXyo47niqSMeuVrfjrCldv96yDf6b03BVVBBaAnMzQKdbAdlp9F8+89/HJdUdskzDpwf3wW4G1wWNAZMw/DfjTOnDVi7aXBzPAgoOiXfwcxZhfE3YrS0ZzNGQpovCqFf9wwzA2pxOXVynUebv3u/HhYEzk385L4gDmCsRJE/cTu3v5gSO7c3+WSxcKuDa07q3WiRTyqU34n6G4+LNy8nUc2+kM6tCrmgZQILT4DE2b8tPVaiF2gGWX3fiV4VIPdVU4wY8WyM/Oqx8uV7cFSXGf/vzWmQGjNuHtuBp+0vwGwjAq503bHloj7wKrAEb1LmzG6qLVCxZmS46aoGEwMNpWwsd/oUYqZHiyqz85IQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 at 04:15, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> To address this issue, introduce i_pages_delete_seqcnt, which increments
> each time a folio is deleted from the page cache and implement a modified
> page cache lookup protocol for short reads:

So this patch looks good to me, but to avoid the stack size warnings,
let's just make FAST_READ_BUF_SIZE be 768 bytes or something like
that, not the full 1k.

It really shouldn't make much of a difference, and we do have that
stack size limit check for a reason.

And obviously

> --- a/fs/inode.c
> +++ b/fs/inode.c
> +       seqcount_spinlock_init(&mapping->i_pages_delete_seqcnt,
> +                              &mapping->i_pages->xa_lock);

will need to use '&mapping->i_pages.xa_lock', since mapping->i_pages
is the embedded xarray, not a pointer to it.

But I do think the patch looks quite good.

               Linus

