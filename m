Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87684D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 13:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75576B0088; Sun, 11 Jan 2026 08:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23006B008A; Sun, 11 Jan 2026 08:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F2D6B008C; Sun, 11 Jan 2026 08:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 904D76B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:48:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40CC11A07EF
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:48:08 +0000 (UTC)
X-FDA: 84319811856.12.79F1C1B
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8776B4000E
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:48:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQ4q5cC8;
	spf=pass (imf04.hostedemail.com: domain of yajun.deng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768139286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhSNGWrwGcmoVHVqufjOsJfDL8qTO4IvvXL+fwvztM0=;
	b=QC7geqrKwMjGDGcCE0ELp3MAEbV2LQvkZWI08ZAAHU9OhioC0Waa03nvQ7mTJfVx1QQ1dT
	/QdCXTTI50aq+EJ9OYt7RD9C/MAxPI/V3GuDkHQ32KYBmy5Vu2//gEO++kvy2OoQnI/EOS
	qHXOgu0ll+kiPkZgKlbiS9ejk8KicoY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQ4q5cC8;
	spf=pass (imf04.hostedemail.com: domain of yajun.deng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768139286; a=rsa-sha256;
	cv=none;
	b=SQKt9c0UW1tuGIZ0dw4PNyU1VSAD0jJFL/QfbNnZ8YbZ/8HmXa+VK4TT554GlGc4uFDd0n
	4TA86zZ4RgidY8YOHGOXi78Zj+nEw/bBKUcq8sdw20v28wF8cUH8KuACumYNL2ZlPqtF0z
	4GinVO4fh5ZBWgn50BVzItc320AUJsA=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768139285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GhSNGWrwGcmoVHVqufjOsJfDL8qTO4IvvXL+fwvztM0=;
	b=eQ4q5cC83tJBvzpKZF3MBf+i+UkKGmguRfiwGzD/h6Rr1i5A9wtCNKWL6nvBroApU4WvpA
	mTXhJ6Mx0y5WJTeqrw8B2LWVE+0/HhFdoy63Ffuo6mLXqjnU7JbNh/VptBel6anu+MElP+
	AKmJH8217YCMU0/04J6gEtQZbBloDtA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in
 move_to_free_list()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yajun Deng <yajun.deng@linux.dev>
In-Reply-To: <20260109163140.1605599-1-joshua.hahnjy@gmail.com>
Date: Sun, 11 Jan 2026 21:47:42 +0800
Cc: akpm@linux-foundation.org,
 vbabka@suse.cz,
 surenb@google.com,
 mhocko@suse.com,
 jackmanb@google.com,
 hannes@cmpxchg.org,
 ziy@nvidia.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EC18DC0D-45BB-40B4-B34F-0AD7DA09EC99@linux.dev>
References: <20260109163140.1605599-1-joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rykedo43yimijw46n9k5xp3un5reutig
X-Rspam-User: 
X-Rspamd-Queue-Id: 8776B4000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768139286-190998
X-HE-Meta: U2FsdGVkX1+X2n1Mvh4ZLki52FvLQ4u0ZEadQ/ZmirQV6ZNCLRBk8yw7pAINC8/4Pdx8wzqWAKslFowWE72AKrC/f8acD3Ht0HUn8L3JvbDeXcs7b9RHdrpRbjBOHwRnyjm5S4gltkyQYrG4gj8mC/IdXjWwcD/+O3/Tf4Y5pbGNE6sX7r1NfT1zTrlnEaDhbXbn5re71WTv8WkkVB8yhCrfjOjclq5unUfiSmi9+Rob5UfGU4hkGo/Ovl7+OXv1jQmS+KbNqqG6EgLrcYXIGP7tEmT6Qz5gAiqmLo7xAO58O25M33yWeh0YtoSJRRbQMQtadf/zGs8M8eHS9NSkWH1nh3mVzptp95LWyCReL1kvb2Nz/GnG6O4LfUx37yagTn4CAFsxKDJ9mOnbm+BUOr/i4dk4RyXZ+e45femIzwOOEjl+LJ6nksZ0WU+3+oXpM5c5FnmOc4yMT5vVy8QUWpLtX3/R8nmB3xh7g5mfWfvomlDlKXDFGMfqZrKUuukVS8aRl2cPJbCDtFA6bML2KqbdBn1KhU6GKmS6UMVixXHAoce22+n5b00pX5Zz8lzt+jzvSu2w8HvHvsMClbh0DA+b5vI21yj4mTYr3I5AJ1BrlhEY8srrPCDtPT5bCvK1uKq00Cgl1+wRvMdBj0VZT5ZYC4rL2zyweBA95xEeaslZ2R+EuU46flzwmwDRJRQpd2NfJ2ljDFOrKty1Re2RYHqOvAGuT6SiRCcWdEOYPINTLRAeZisWv4x6WF6Z7DLbOF1bwOLyyoEejyY/ZgpU2HVhUkPKHpkQIc8gto/NHMtpycocP1xHNBEhVvogv+3eiQu3fIGxGIYMPLRncIVTA7cuijpmvMm3rmT/JkBKwFRtJDnBBZ4zOK1lVSHRXeIj+ZAGxgl/oJ1qhYOEQiZ81dCw9QILR6yC4Dxno2PBNVpqH7nai4nWMx884CKAKvaCNY7up7w84dYhU8PY6l3
 4O0G+s3m
 FgyazdifA6GASNaOsQGZpO8FJ2armg+Vm3W637Fw5CEfS3GCt9LXHngk89hre8icg1pwYeq67KX1bbDBAJXIHyjxUb4n2E3YS7BsnTWz6wZUKVjbFPTXMyIzpwyL/lgmUxt/2GI4T0Ejfajxf9eWO4UQxlzxRoSNF+doqoPPH7rtBz2oKhP1PZgs7m1N3z1vU8yfy/R9Zt1FjkeuU7LsDVVoQjiQPO/Kmr6UTm2PT5tMoaJ0jVMfbyBGDIlAgPElA4i+mnStw4LQV1Cc9B2B3xFA7k6M/gU5/X0thM4cKQNmjtZPFba/OLwez7nkOtgf9X4Hspln9hrmZ16MLN2I+Yr7vgxlTW2GrUPqBCGpF5weekIB2O1+xKkdIdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> 2026=E5=B9=B41=E6=9C=8810=E6=97=A5 00:31=EF=BC=8CJoshua Hahn =
<joshua.hahnjy@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri,  9 Jan 2026 18:51:21 +0800 Yajun Deng <yajun.deng@linux.dev> =
wrote:
>=20
>> In move_to_free_list(), when a page block changes its migration type,
>> we need to update free page counts for both the old and new types.
>> Originally, this was done by two calls to account_freepages(), which
>> updates NR_FREE_PAGES and also type-specific counters. However, this
>> causes NR_FREE_PAGES to be updated twice, while the net change is =
zero
>> in most cases.
>>=20
>> This patch introduces a new function account_freepages_both() that
>> updates the statistics for both old and new migration types in one =
go.
>> It avoids the double update of NR_FREE_PAGES by computing the net =
change
>> only when the isolation status changes.
>>=20
>> The optimization avoid duplicate NR_FREE_PAGES updates in
>> move_to_free_list().
>=20
> Hi Yajun,
>=20
> I hope you are doing well, thank you for the patch! I was hoping to =
better
> understand the motivation behind this patch.
>=20
> =46rom my perspective, I believe that the current state of the code is
> not optimal, but it is also not problematic. account_freepages seems =
like
> a relatively cheap function (at the core, it's just some atomic =
operations).
> Personally I also think that semantically, the code currently makes =
sense;
> we are doing the accounting for the old mounttype, then for the new =
mounttype,
> in a way that cancels out. And given that there is still some cases =
where
> the work doesn't end up canceling out due to one of the mounttypes =
being
> MIGRATE_ISOLATE, I think that there is enough purpose in making the =
two
> calls to do the accounting twice.
>=20
> On the other hand I think there is only one place in the codebase that
> will use account_freepages_both, so it might make the burden to =
understand
> the code a bit higher.
>=20
> What do you think? I don't have a strong stance on whether the =
performance
> effects are big here (if this change indeed has a big performance =
implication,
> then we should definitely go forth with this!) but I do believe the =
current
> code is quite semantically sound and more readable.=20
>=20
Hey Joshua,

Thank you for sharing your thoughts.=20

I currently don=E2=80=99t have any performance data, I just noticed from =
looking at the code
that there may be room for optimization.
You=E2=80=99re right. The original code is indeed more straightforward. =
I think we can add some
comments in the  account_freepages_both to make it easier to understand.

> Thank you again for the patch. I hope you have a great day!
> Joshua


