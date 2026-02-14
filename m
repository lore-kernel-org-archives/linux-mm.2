Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E5FAEDF142
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 05:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD856B0005; Sat, 14 Feb 2026 00:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B3D6B0088; Sat, 14 Feb 2026 00:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D836B008A; Sat, 14 Feb 2026 00:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92B5A6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 00:55:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F3AB140788
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 05:55:58 +0000 (UTC)
X-FDA: 84442001196.06.20AD2FD
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED6AAC000C
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 05:55:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AzAYTuja;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771048556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4p7/VLh1Ufevc16x7Gi0b+hrWBvqYZ5XQGRUCeLoNIk=;
	b=WmalUcv3ugSejHQDy4zFIffw8IbI/fzbJey/hemCLX62/lRHUm+dCMcQr9dEKzEPwYELr6
	aB66Q/Gf5uovt1y28cIjGJ+ZpRL3HRUfDnxADn71kLC3coa6FIAX+Me2o6OmStFYu3u2nk
	zAx/kyNRsmVBPyZr/8+wKz3hVMi5jTc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AzAYTuja;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771048556; a=rsa-sha256;
	cv=none;
	b=0AnzMM830snPclzUjcJg8k3BtJpv6nRV3rlfO7AQ4IBZjikL4Z3/Uor85iV7AGoSD7eoDw
	9LalkYEkkLacxnEujvRgZb2wx6YSZJum+oM1KgnrTG0wqr4sgyGvYx1E1Tak4b+ewQDrDH
	4/fYzPb7686OkDZmzbx7tmxwFf5vP4U=
X-Forwarded-Encrypted: i=1; AJvYcCUb+pBp2hgef1h7hv+6WgKDVXwmtTRzsBnlGRfKOz+41kPLnSozORIKFykRrvK56u2QofnhUNP31A==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771048553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4p7/VLh1Ufevc16x7Gi0b+hrWBvqYZ5XQGRUCeLoNIk=;
	b=AzAYTujanog2Sg7wKYUkQO8jIU/bxsAEvk6Xw2ojqQlhbCyTiTUdVvRe0QRUHdM8MT/fp1
	8EYySFDjX7vxvbZSAKl+zc1vshJHFYjk70s1CeVz5SGtTd+qKXHGKL17RLFC/Ahq5vAKzU
	cxqHdFKNDVZtRzwderxUn0+V5IllvzI=
X-Gm-Message-State: AOJu0YwEolVNDU1T6/SmA38Zej7LDVZl1IbfXoJpRngBWcPafrQpiyQd
	hHH4rTk7d6KU6Xl9KJUT9HOhVFR7Ri48eXp3gQ114/UDivmxlBt+0ifVUPIqlnJ5Czll+3rf71s
	aitcPKRHgE2FQG8mipRWN2fixrv9loRU=
X-Received: by 2002:a05:6122:a06:b0:55b:d85:507a with SMTP id
 71dfb90a1353d-5676a8af2fbmr1301332e0c.7.1771048549285; Fri, 13 Feb 2026
 21:55:49 -0800 (PST)
MIME-Version: 1.0
References: <20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com>
In-Reply-To: <20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Fri, 13 Feb 2026 21:55:38 -0800
X-Gmail-Original-Message-ID: <CAGj-7pURg5F_2zMAWseutKTKoAdzn=8fsNSqUsoNCWyurbFyGw@mail.gmail.com>
X-Gm-Features: AaiRm532OGRhhN1nv7-_o6WBJNYSsEZ__DUHnFfvG3RnhRwGE89mcxLD7x9Q6us
Message-ID: <CAGj-7pURg5F_2zMAWseutKTKoAdzn=8fsNSqUsoNCWyurbFyGw@mail.gmail.com>
Subject: Re: [PATCH] memcg: consolidate private id refcount get/put helpers
To: Kairui Song <ryncsn@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: joorneteiwnhyy4ux6hw3i3t7chtnpa1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED6AAC000C
X-HE-Tag: 1771048555-259783
X-HE-Meta: U2FsdGVkX1+E7v6mNZ8nrquYH0SOf2j/5R3M1EqqOpuMhtCnducOWEWeplmC0rdeDXJZ/jww4u6ZsO30Qzr4vnePJ1Wkk1MV4YtdhthFoymCstCRP9Yh6G6luJiKhtRiuKZyJfrgoLeotHWdWvbgmlQhH3B/gUKlZEn0mSmKXhbEFBm18Mbw9aSfTMQIiBU6xrXfZ3w4gtZHRyRWOQzGHADLeb9timf/GKXMF80PRtzSfIurG4P4T//rCmNp91VFDRK7hTWdi4jT1GElAC57jn9fCOiagr/bFoGAvT7oxtx5kX/nUk9Ex7uNKXXLBT3fu3SbYdPAaRmUw8Ifw1LT4XXC9DsN1K0Kuu2zbi9U92y3IxcCfA0YJZUu8g2VaTtzimrLm/u2CYUKtJalTy6SxGA5v4BiLNEdSMEM0ogLGAlha1EGrjsYyYMDkJjKGvTYIO4OPCthcNOx42fEvCHtU48FMXLsSfXD7otQZAzgPAV8xp8ctYcl5dCnadD5xEtDc8B9WN6+kCtBj/7K+invLlpkkvh7tnexLLsmIUScRA8ExB/N56TJX6G+l/eWlY8HKyMQZUIWgcBTE8GQxU3Jm1rRN4kqR1jdY6/xzN7hMNfyV7RTTTRJbUXMZ6QdtWAWvd9isQZHkIWKAAyX+GRJq/WnqptqMVMZgd72xKDHaJ/A1FHi9sZO+4qptRyBJbdRE/kn1Q3OoFIeo0GaEucLh+AJJM+aet4c3Zp3HLaiwZcsS0sUFYG3wxAMY0x0egB+DFOIzFA0/B0IoteqIOnA3OmmyVD8YMEwPmX1jPjrn1OIxGObrrr2LnFbFc63hhIXl8as7Cr8xvVLoBupjY05oI8pk2q/UFT8MYDQJ4qVnx+6Q8wxVUBhQiw/nTi2xJdNPZ+DaTAWWJCb2ibYSmqJZwdLMKr7SXxfADzoJIObmDbi1Tl+MMctDyisczJ6ShcdFU/yWgGg1rjYhCATF5+
 zdxFtmkQ
 +5AIsVmsJ1M3YzI+bpqZ+TiDShm3VWxz6X8IH6eTReeEogU6scWXH/+MMcn+fVEXABLzpqyQreFJMypTzmxnDON6QRmyd9URFwYuhwR460taDy6bRU0kAk2+Yr1pIoRLeoQ0h9R1CZdQkrRmjPId+eHoJZFhxR/1F3sSXG8JK5pEiQdwnynquEwQEa3EZ8/3FQMi/JvLDLE2RJ6gI3vJXsLKMCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 2:03=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> We currently have two different sets of helpers for getting or putting
> the private IDs' refcount for order 0 and large folios. This is
> redundant. Just use one and always acquire the refcount of the swapout
> folio size unless it's zero, and put the refcount using the folio size
> if the charge failed, since the folio size can't change. Then there is
> no need to update the refcount for tail pages.
>
> Same for freeing, then only one pair of get/put helper is needed now.
>
> The performance might be slightly better, too: both "inc unless zero"
> and "add unless zero" use the same cmpxchg implementation. For large
> folios, we saved an atomic operation. And for both order 0 and large
> folios, we saved a branch.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Shakeel Butt <shakeel.butt@gmail.com>

