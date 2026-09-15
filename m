Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BC90C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC676B0092; Tue, 15 Sep 2026 13:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1649F6B0093; Tue, 15 Sep 2026 13:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04EC66B0095; Tue, 15 Sep 2026 13:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D006B6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:52:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DA6E14051A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:52:10 +0000 (UTC)
X-FDA: 85216740420.20.A5D074C
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3F53080003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:52:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xfbhk5Ft;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of jannh@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789494728;
	b=EqG46s7DanzJYOZ61M1AJ7f7CzAby77g28Jp57je2VNk5PONXqQgahoFp+tIjEMlMejEN/
	VlgoWYT+asSgHr8K+kWMLhDAkD42aaYDsHc/Hko/p6V2hr0XjDOYUyhSJSi/EYVvjNZint
	A+7PIeQFKYq+2ZaoTUR0w3C1wwd/ywk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xfbhk5Ft;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of jannh@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789494728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4G5uXJmB7HF3o1L37WqbjganRxVa3Gn0saA7lTxNiM=;
	b=h+8pNRJ2VKhCOXws7JNOPPIDtrCmQCBJjK6pW1u1CPpQAXn9Xm8o5ce3j5AHvDGmB+B0sJ
	A4lFcuSVr4rAkhyCKFB1kYk74jx4TXF3WOWibtedguYoEHndwvuuMTU+k1sB9iiq/IzbbK
	h5ED3dhypvk0bC+CIVHzH9dM1iLXD+g=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4b917769so6945ad.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:52:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789494727; cv=none;
        d=google.com; s=arc-20260327;
        b=MQ9YOAYPqyskNKg+Zya9PBk/jBGq1PuLWS74v2Mom6An2ZPftok+hdyO4AzWa+n64D
         MiMZ3f/IRA0ZA02XZBqJL3yjuCb95xYFRDwM0PplPSQooyemaHA05M6xpL42E0bcd7LE
         ueASWuMbhmiFOwmuOwxhEKNMeArBnz/g/2yXQVfudfEcAJ5Phm/hIq+bWXbicQAKHu0p
         p8NNKpMjoC0smiJJS1DGcyQZ+nz8rZzEF4goYeaxuYzmtE3UFpimkyqwqduM9W0T6Y9f
         JoOePsFpM8nYuVdzclKUuES0wpdMjeHr8UhAvsXEOKm/jJYBd5TAnmhsXYIyxJrF2nWW
         94dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+4G5uXJmB7HF3o1L37WqbjganRxVa3Gn0saA7lTxNiM=;
        fh=81JxZgTCO9sSLYDT0/rKxrKip+4fYcMacu4QMXNPAiI=;
        b=IEjot/vgyUa23QACzcCaw5W422zlqIb6mLOYbh2xR29h3En0qPiMEhPuSUH/+tDuIo
         GPP1qYHlWU9jsgANbD73wnhg6puH6nXQ0/0xkVqBigina7q3PZUtoo5R7yT1I23jgZxa
         IY6GD22CAHIo1jOl9NWcQb11n3oydr7c5fNLEbsGNO2m2VEVWM3GvsuRouOER6zXTv37
         r6EQYQkvR7nPH5JPBJPzBQ+KTBjSMTN1pDkbI1fLNLqOrFbqXKUWOHggrM8SCJ/YBaSf
         UfJqX2+p7cVfCps+PlS48GYD+Xe7MK5mCYb1G3EN9kL6wD6LiquSJpxAuroMfTOLqVKx
         r7ng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789494727; x=1790099527; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+4G5uXJmB7HF3o1L37WqbjganRxVa3Gn0saA7lTxNiM=;
        b=Xfbhk5Ftm9YmkIYhoCQusg+vHbMbNL+cPVhgwUxl6ASs87REcN+AJGTCTzCU2jQhS1
         N/7nHG+3MQcBxFmTGrVOoAC7uwJgVj6jJQJjWNKA31C7QdlbeElwI7fkMrkebR0ifamO
         VROSFiFydvDM7TSKO58CWNR474UQUfdIvJPl+MXvIa/OtWwFfMcIrG4RYmVnO8B5J9lp
         PnTaLCwrg69jbY/28vYO76sv73GzHp1aQgEF6TUqY6lE5CpIE3GJQQWPuNzcz9feW/zj
         o7YJ6cDpZaaSB0DTo0boIrj9g1GSjcc828upTDV0d3rf8GS0fX4hKMynQ0KWNBbs15de
         o+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789494727; x=1790099527;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+4G5uXJmB7HF3o1L37WqbjganRxVa3Gn0saA7lTxNiM=;
        b=lMIXBuJtzVT/4nA7c58MBAzHSf18hHTYXapelST/Iv8diOlwmiXHi5HrFPp4Toui1b
         Pe6Vffoor0Dii3sQqatkXEoPuEsV1538R+DAVtKHy7YMQPstWRaANtvtDI7YNJPJqoHB
         4HsLE7TATQmEpjVtp6npmqG/07JpG+OVwKHNvg9/j2GZ8vksMRNqmUyNLJYHA6phvwNd
         jgSQEpfdiEi4GvsYK2D/892Mx3TIFgKN7/yanBTHb+aNMhH7DqNpSTDsybObARhk/vn6
         OXwmEzIPzi9ltotlU1OXRZDPeT8RKjP9VDpykNWRgvXuj88Z3zyCxjT2B0wOt1uOCx+4
         3NTg==
X-Forwarded-Encrypted: i=1; AKwUvBx64iUz/mqd2h+fhSAy3tDTzj/BYneha11x6qN91tcknP8OTWQiUOl2oYXrR7FZi+7HAnGf1rVkbg==@kvack.org
X-Gm-Message-State: AFuF++mOc4dHiyA7gA3ikb4y8NlyW5DvnVNgTihuQNwyu9errbn7/+4Q
	UZrVeplCaW3ez/TAEB8tLrzau28OM3TlYOu3FTt7F8Gs0zhxk1jz0whdbQU0ldGwRrtTDuvmDho
	3zUcQk+UbrnfFlfsmFkCOUY3czVkCuuqO2jXkrjaZ
X-Gm-Gg: AYBFou17/hcBlYvCEPB4YYU27YsHy8s2yzMmcKPuM29zukyg7WW7XjxsLIRITB24PAg
	WMkZcBx4UK6rX35edz8H9xfuTGiqiEfKrJf1mkKEdHZ7wUJrhOt3Nl1oZ9UFjekUgepysMXmway
	1Xwlt5CfuDnMuBGdy2D5ePnZHkVJdyCsiD3DhfK8hKbtRzmKBt6INIji6pjCLdtgc88Xj5L/5rj
	V9VLI1lu9BuUyBnBRFlZkdqdlthORyCo309gcyritNVywOlnG0QN0TXLlVcxtgk+Ds6dAu5PAn/
	AVNMVSc3rxEYARTRDDOVkvP6zogdyKDMRoCXwSqTvcxKH1NanRgoQBaYmlgjr8ISBqsAuPHgwki
	6Rk9bfnAHcaeEd/RRwMlweB+/r20Yn475jmnkZqvM1YC14CH1G5Q=
X-Received: by 2002:a17:902:f612:b0:2dd:5363:31ec with SMTP id
 d9443c01a7336-2dd89c0c38amr177395ad.14.1789494726332; Tue, 15 Sep 2026
 10:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 15 Sep 2026 19:51:27 +0200
X-Gm-Features: AcwNN1Vhgv53PI2-XyXtJBbVzCNkGiiWjtvOE2b-8zHim7-UybJ3H2xniPj1VUE
Message-ID: <CAG48ez1RsdT=O=-0city3vjgWhDvY424KtTmrCJntWy5ds3HBQ@mail.gmail.com>
Subject: Re: [PATCH RFC POC 00/50] file: handle files on syscall exit
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, 
	David Airlie <airlied@redhat.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	kexec@lists.infradead.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F53080003
X-Stat-Signature: tapzobhnbbcomeacxmcikiujid9pbdj5
X-HE-Tag: 1789494728-746956
X-HE-Meta: U2FsdGVkX1/KnzrUzrK5guZ0FkfgGHfs03b9xL6uAWIRE5DIpq0bbSPAFF4IoEwLyZ62dD7dUv0I9V/vqu+XmkDSO7fwU2oJHv7of4d9+h56Zn5QLoKBrTtPSNE9cHNEg3jObnmZQ/zeHE3ZTp8yIbrsNWqYhsDo0YSwjow3+TvRqubHsavirEYV5zGZazX+zD55fJ/wSwHlMZ0phx9gKXvSXuq3danwV1w+sHnXB65jZLMgOLzUSq5+1Cthm/W3R1Vwcs6iP49V+H2n3husZltIM1R9mcWYt71I8jT4Vwd/lKHB7t/v8q7G7t7n6HxWycteiimlWE/t1M8uF8kcxC4mcSATjUvA+HohbJw0rXUUf+im40un0668iSicyYPWj2Ele6FTt7MGrA3Ru7eQrz5AofOhxDPHzmFgLkYOcM5rjruNIZIhohxLTzSkZy/gXSjiIRM/2191fpQqEAi4lfRER+zSdmw/O//sREnOkh5x8FqV+M+YMFZywZEa4kpau4INlaLi4NVlfNQ+XC6EjOAssUELMT7OAd4cDxWWR6YQ52qA46QakMoFAjRmunxBHgUUUAxrl+XDvADFafL6vznaVhlAMa3YWC14s9AS43DrlXgoO2U/zbaqu7XqXfczTWDYbtJOCquXRxGzroWZYT8LOjse1gvHrtNJgkY1LvQFq0IVOTRrGvxaqozi9m6xHTUGNGbWUWHgtlL/a1EfIs8lAZYIJs/9X8NrZCzCcRlAkrUnZC8SHD7Rr9AR10Z6L65NuLjBPRUl3t1dOkORzCIJjvwtmVqQkybgaW0y4VgEJOtxTmYMT8431gCYI35vUChYlOmkr88X/HRNLg1th2frFMFX82dXiYffwlPYxiTb27H/l+jnLJnB4YiP5NdTxTsU/APveZac28TW10D+ScbLT03HtfSvsNPS3qplw2H4unbjZ60Up0AxZMDnzylCZxsw6XYLsM/y1zJzv1E
 LVZBipKA
 Ilhl45OyhywSIkmaPMERhsJQj+FVO04l7sUCuhlJ90gMO26bR4/It8d8oMHrB4ePFP+a/aMQ03oGicjGQQL6aZRQxGAykTg4+2GZXzObz/604avM+KcFC6+HchfjmUVhsu+8O6apO348hGQHqYSUVickYOt6n6TuQVtbp2FA6ejTIZiuvYonUBKMmX5zXSWbfORmvG0B4OTXNB9K2/FCK7pNm4S8Yc2GuGtg/vKKvfyH1kGyuoQDgtlW6BWKiQ8mUoUs/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 1:31=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> TL;DR, this lets arch code handle fd install and cleanup. fd_prepare()
> allocates a descriptor like get_unused_fd_flags() does and records it in
> a slot on the task. fd_stage() attaches the file to that slot and
> returns the number.

I'm not really a fan but I feel like if you want to do this, you
should be using task_work so you don't have to touch the entry/exit
paths directly? (And if task_work is too inefficient somehow, you
could tinker with the task_work implementation.)

> When the syscall returns success the exit path installs every staged
> file. When it returns an error it drops the descriptors and the files.

Is this mainly about stuff like "we installed a file descriptor and
then the following put_user() failed"? Because if so, I think a nicer
fix would be to have a policy of "if userspace provides unwritable
memory to a syscall, just keep going and pretend the access worked",
and maybe have a sysctl that kills the process when this happens to
emphasize that userspace should not be doing this.

