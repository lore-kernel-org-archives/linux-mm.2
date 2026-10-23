Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CF3606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QYnnZOAg
Received: by kanga.kvack.org (Postfix)
	id 1A5776B0A99; Thu, 22 Oct 2026 21:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12ECB6B0A9A; Thu, 22 Oct 2026 21:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A686B0A9B; Thu, 22 Oct 2026 21:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA1516B0A99
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:40:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 283C94036A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:40:36 +0000 (UTC)
X-FDA: 85352186472.11.B02D7AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 369C440003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:40:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QYnnZOAg;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792719634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9YYjmGgAaJ7EMORGFSbBsWkUkc9dzDPtiE0Gn+pjLE=;
	b=AVKN6sODbYKzx0tyy4NHJgMu+cADk5AR4jX4FdYm5FClQP3oLI40dgJnYjBZFSYEcbcs1i
	CVt0yQW3+ogfXFZ2WwiDQwE/bKNJEXJ22qMKmD+Rqi0nC56LPuxDAZNFthbuAutd16RfqU
	9m8mJVXIJB10YgHauwjCRNgWRLPs3GM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QYnnZOAg;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792719634;
	b=pGor+yF0i+nEbeWc885KbH3HALXAAC4J9ytiTMHcPAFmTG51OZbNAHV8RyXXLe2i7k+73q
	CEbkhhbMuYSgXUgkLCjJlE8hJhg67IOj/V2LG34M1YQpEho0P8l39Gk8h3KHDeXmB6h+c7
	gnWZGlnFCASfvXD0oE+ABsYXYUqSokI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0A4543DD1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F511F031E0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792719632;
	bh=+9YYjmGgAaJ7EMORGFSbBsWkUkc9dzDPtiE0Gn+pjLE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QYnnZOAgyGqsBpIehYM5tf5nI7sJXhgOSiMb4zOmPoimgBqdJzzyvoI8LkSGeYWD8
	 vt5QxL5ma+/Iw2De45qyIfTpGzhc1HLSQNvREza/WpAo3cZ09ICf1yzlTsgDcHaAcK
	 6pIPgoLldSD8u0Tc1EkUe/h4iiNNozkthNk6VxY6k0EN4r5Oo0veMB3MS3tgYxtYRl
	 firW5GymKP+FSgDfomA12c/G6yIYlpUSqQJVqNHwR5tb/4TqL53r96XM3nIS89Xqdl
	 EV8QSuweFHeWvd/XDP2LcRpcvGcDXlvpXeoP7aRPDMpkXsBwNDQ1L+BgxZQiSEHsc8
	 gfPtfC6GOfUqA==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93a40a9a01aso181977085a.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:40:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxHzJNzL14mcCwfR7pT6ab69BzJSQdkB+cr5irWk+Vnp+kVNP4ZEwU/vatwl0JdP6Q7O2GuK79daA==@kvack.org
X-Gm-Message-State: AFq9FYJG9MJl7ZYFoAzsZZl0UfY6hDAE5iwrE1R4WcH1uDPXI2Bf2fp4
	7e49fGMQKjmWKrBo3Oz0nUNC030FNttb3xTmQp8yL0vR1d3d2TQlVVzFcM7IxDwWZVBTo79w8uc
	XRTZ5Hr4mhDU5zjBAgV1GPMs0zOimlyM=
X-Received: by 2002:a05:620a:6007:b0:93e:60b7:eb1c with SMTP id
 af79cd13be357-93f6f78e722mr201796985a.8.1792719631974; Thu, 22 Oct 2026
 18:40:31 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com>
 <20261022102726.56682-1-baohua@kernel.org> <fc302ca3-6bf6-4bde-b3e8-8d2e93a4e4ac@linux.alibaba.com>
 <CAGsJ_4z9GZkpV+mpoGogma4oSX4cHy+2UDzyUQSjjOLOfekEPg@mail.gmail.com> <4e647816-0b8b-4a75-8777-8580a574d752@linux.alibaba.com>
In-Reply-To: <4e647816-0b8b-4a75-8777-8580a574d752@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 23 Oct 2026 09:40:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xVR53NcKuN3bA6v+O=37PeQ2Vnj-8WHo6ScYH96N4seA@mail.gmail.com>
X-Gm-Features: AclHuK_amfUjgaamNRqs111mMiTPJ2p4pxakjawSZik98l7IETdv3hokn4kCA-k
Message-ID: <CAGsJ_4xVR53NcKuN3bA6v+O=37PeQ2Vnj-8WHo6ScYH96N4seA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache in MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baoquan.he@linux.dev, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, liuxiang.277@bytedance.com, 
	ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 369C440003
X-Stat-Signature: b4ba6gm1gnxx588gao9k5zkmx4i3zqyq
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792719634-924313
X-HE-Meta: U2FsdGVkX19wncNM6zdkuZS+gAsAnTik5ZrXe3uDsZkCrvm/FMlEfTzM9ujHUoISnzfdEYyK2cSGQiA6iQYna/zPxUYQ+qgDQFDMC4TQFGOSljteNIjoMlDDeKsj4GwzTH5YruHc/+cqZAB+sM+ZrnblpskTFRmVZgW1p9Af2nPefQ9C4A0fTmhwvhwlDosbYuiz28rtJDo+czL2qJgsVp+6gRHsSZbxRDE+gO7werahNPydigge650XYbta2cLFvo7Q2b1cKre7FWPHzHgC2s3W570Oq0wdN4p9wPCs2xMBEuJ17ro9iDOVJK4732ifUZr8TGZevB2w3zAFx4zC1xNhGlNTvNGnV9+jQ99yC0gq2xUEyXZj2MqcEj55uvicp95oi44j7CPGrCHDM39EYvrhkZobcVBqTXiFk5Ad5SZp+ndC3zOukgwxRV0o7mdNWQIi2PMtu1dvLACAd67bvzuoTckrheEsZwbbBNWJ3ZmvECTLjx6rD4viV9JsEh3QoY1xfGA0h+IsMQPFP1Lsrh0EkOFQjWtlxhs1yHxrrMHmQZZWn1y1fjBC1sEAEdPpbKsyP1o4Q1qeBzAZpwFZnd19NRglVYaNzI2nyhK/4TjEgS+m8NHAf2qAdpKD9WviQfTtwDH4Rv6OpirxcfxYDTQcuBUn9uUY2nhrBsdAo++cy1MViFmCCrVkSOT+PoB8xNmjqrzVn2umziw+xDMUPJzbY2yWX1+O1qi40XmV4HdzRfG98fsKw5bB+1dz1Bv7a7JRuus+/DybDQgrezuV50+fuCl2s1RcK53yp6NEaAQCpUgvYVKf2ycc3L6uaMi5RF1Cyw7xK+qmJFEO3tsZ6SahRYYQpRES8abPLvCKTUwsindl9Up4SkWJumTmHpr82YFAfeR1+e/00qlutJ4HQnriiLqrgwSahYBnJAO2LaNGfVDK7iAp0okJVOsCFtgYYTJWLR0kpxQ4M9CjjE9
 EJjh7TSg
 C4fZ3SAkJx5pHN0zpcS0T0xuvKqVNBA1Bo6tRGqlH3KnS/upeaE8Ah23VoLawlZfvM7QyoHDJMMwqRRVW3Zp6qiuGFMkV8c6noBDA0esyN+zRpg15MemeCYg03zeie47gSBwx6HootqNncFYSV0AEE5OxhBmDAs3tih13JLhmX4cSKdf6g+qOu/cls2liSn40/UMocv9SZqs9IblQgRzuqISQSSHYoIQyMigMjnrQOZK3jvn1zHzkb1HRwvmiKt5cUBzDeW0UJsOrG2VbOnioNxg02kUvEdBfnk1/CsmqJIWTaTgEkO730ge6Oy/3IL+dKywN+jznfVmF5fGodvkrN2PC8fd3aW7JvYSe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 9:36=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 10/23/26 5:19 AM, Barry Song wrote:
> > On Thu, Oct 22, 2026 at 7:26=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> > [...]
> >
> >>>>                    }
> >>>>
> >>>>                    if (should_run_aging(lruvec, max_seq, sc, swappin=
ess)) {
> >>>> -                       if (try_to_inc_max_seq(lruvec, max_seq,
> >>>> swappiness, false))
> >>>
> >>> This is quite tricky. If we pass swappiness=3D0, anon aging will be
> >>> skipped. Do we want that for GFP_NOIO cases? I mean, these are not
> >>> real cases where anon aging should be disabled.
> >>
> >> No, we have real use cases where 'vm_swappiness' is set to 0, which
> >> means the workload never reclaims anon folios. So in this case we don'=
t
> >> need to age anon folios.
> >
> > My concern is that setting swappiness to 0 for GFP_NOIO also skips
> > anon aging, making it behave the same as a real swappiness=3D0.
>
> It will not. We will force anon aging for GFP_NOIO case.

This is fine. but what I am saying is that the walk.swappiness and anon vma=
s
are all skipped :-)

>
> > However, GFP_NOIO is only a temporary state, and subsequent
> > allocations may not use GFP_NOIO.
>

