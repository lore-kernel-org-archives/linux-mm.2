Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE58C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 01:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6C446B0095; Thu,  9 Jul 2026 21:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42766B0096; Thu,  9 Jul 2026 21:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31786B009B; Thu,  9 Jul 2026 21:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3EE46B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:11:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39D95402FD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:11:54 +0000 (UTC)
X-FDA: 84971090148.01.BA55043
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 60E3220002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:11:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enCPjBu5;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783645912;
	b=Q/DvX89J/AfBcIxPmO5QZfVAZ0DaCfBxlmZxxBsiV6V2CsODlF7LJuI3eC2NhLgHKaBdKo
	2zZC44KAe9b9sqAKTbv59VlQ2fMUSQFeuvrqFEFAum/xReHEOqlem0j/4nx5T/KlhbVE4p
	RwlXu6f0XMczEX66pO+HEWK3VkJ4xvA=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enCPjBu5;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783645912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvh68en6h3cwV0D13QvwNBmnJVlb0MOOE2TgUptIizo=;
	b=Njrct7nJUjBWyYGUeR3DF3i9F/pZcVoGnhRVxjZ7mCFLAPh1fe2HRJfCU+/nspuasT6vHa
	gZ6LvIQorX2FTQulTOlGINcoScMK1KCO0M/x6fUJCq2NECmLAsAieOGzFN17eVK8DNMTA0
	PaOURXd58jRsbWvDA+Vo8MFwZrhoyvo=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c52cde9eso2831925e9.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 18:11:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783645911; cv=none;
        d=google.com; s=arc-20260327;
        b=DB4aHVNe0ZYVXFyfbYXWVNdUTi6TyzN/lF/BLqvBXSTlrfXnaMr/NILsEqzCT7w5vM
         M7mMPQTV/6mqOuIz9c+XO/tMhjG6nrgTPFwvlJFFGVFDr6xuma1mVQlWQ7heWGHjn9B3
         ya89wrEccadiQudZL0PPf8UmDoK8/H+eN7d5hChDlnVuEY+jl/zgTYM3aidKGvJrTKwU
         lwaNkGZ5BsPJCuuB7eS3lL7M27wrJzxRBwC2zOptGGUfPTDlvhlWFus1zUU5OAVTlDnQ
         2Ro3X1jS8xR9CT6DsQYnEdi4kmcr58pvXlmDE4uiV7PKBZDgUxOE6NTWERvBlFuezSmd
         HVUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xvh68en6h3cwV0D13QvwNBmnJVlb0MOOE2TgUptIizo=;
        fh=vaecG6QtO6r12GzAj38pAxqRjsWQrAnjzLyMhvd9eFw=;
        b=r+jxpWMMl924gts3y0LOmabinVEGsxiJKCaXdlAt+ud5U3aPlidMIyllNcO57Y/5En
         91WLQBgUEGPt2F8pcq7OFsih1e9ozkNpWVkxiXcWv7lWirEBVpRHfN3RintKWoQvESbv
         QwqgeiZtHNjkuam5UCHidpU1r84pI4RH62VAyItqLN0Xpsvhc16eRe4UKKaD6f9icmXw
         AeXzROMNqAfL7hNIln/whJpFkCyWuWP1ooRkKTn8CJTNKqF/t8UkEXN5Nik2oxtinwmP
         5palhnHCz+fyR81ehZWyyoQXE/vRJQbM7+uiPp4SXF+Qe6DTz/FW9+Zl0T876oUXAlE2
         mbug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783645911; x=1784250711; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xvh68en6h3cwV0D13QvwNBmnJVlb0MOOE2TgUptIizo=;
        b=enCPjBu5dlT+23nMb8vFD8HKHOIWR7+6RSp7ZzSZz8uSbNMQo2/LB/9/fWJ0c2RR5Y
         yAzewkl7+b5/1bitwUY4WfgBDjbMHhqyIYu+b2naM7udOPAe0Bx//P/8XcNE45FEbojQ
         Zzek2hesw8eVBDpK6MEvPyXrmBOa7mrQXEe/eYeenKYgDxzMd++uu/ZIFYd+x7n5q8DC
         jeOekjEO0RGqNxQisELsvN6b0YUc3BjReHfhLTSQDwKEceOlpeWFC7G2pogP0mYSr4Ru
         e41AtDNSzYN4qhX6ISMTaI352FUqee8vS2vH5S44Dllwa1mwENO8Nm1tL97I/LclKgcG
         pkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783645911; x=1784250711;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xvh68en6h3cwV0D13QvwNBmnJVlb0MOOE2TgUptIizo=;
        b=BXrmvoMYsUf9Du39g9EiYrV0h79Te0dh19WAaIK72P5krlY6vUmkhutuJeKfe5crZY
         4vtPlYJd1sshUQOTNt/mdS4M2G+f1dUglOzgQdEIeBQdeK2eNxfd9tSa3SQ48XX0rcAd
         6DNd+OCvhP1xNS7OVZt3eoO4UK0m0tD8uuhn+8JewaK2SIw0mV7eHASylgu4QzZPvNmz
         ja8Ydus5KOb0RNL6jyMb295zg7xqR0i1S1UkH7f3cDLkfQoJsBpSuhGtTVSNBKrQw13I
         6+j7IfsLJ+1FGQAi0MpGlE5R5bQ9ghAgoh4lRcsefga/prLWNw+ZcEM5UZZQNGbIGBbO
         4d5g==
X-Gm-Message-State: AOJu0Yyv+sNFOAzfxPn1qfzxxONaLRMF3G5dC3/84wwfw08Vewwl2Px8
	bDxB3CXDyVPX2DVeizl0+5ijQRn4a1ay7CS3Ka5zh2gRcT5Dv+6IESg6ydJC+Bb3oI0g+aP+vTJ
	h/ttkhzN9kSy78fFh7HN/l9An1ZpBhQw=
X-Gm-Gg: AfdE7cmP6pAxVNFyra39x8JYBai4n4njL6VzIVETn9cUet2GTYGHi2I/H2zTiRSQA7K
	Zhc57vx0FO59GddLcTcWaqnRYR8yjUIQIyDPY87spzin0HUuGtQtx1sbjJT9SBRUWqKlA5iMCdl
	C2ykPxO6BBZwlOXtLY11bHYLR1aafG3zsj9NUmO+bkzQGMaXR0Z2mK0GwLraVp+u/S9fatMwsFw
	xiM+6T1ZOLkDBiOyDJ0ry6D+wxvaI7viY1hX/dAQlk6GAYhashkTofTi+JIqPKk5iUg5sUPyc0u
	XCBa+T847pxmCQnDao+iW22/9KYGi4eEd3TvQdAvttrfH4Xei7CTDY4=
X-Received: by 2002:adf:e19e:0:b0:473:24e3:fa8f with SMTP id
 ffacd0b85a97d-47df07b5f05mr9714452f8f.47.1783645910736; Thu, 09 Jul 2026
 18:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <20260707082614.95030-10-baoquan.he@linux.dev>
 <CAKEwX=OygNR_5iD+FbWKhMD9Z7fxU3+VOfqn48aRGqZzYF2e_g@mail.gmail.com> <ak-1y8poqzPEhXtQ@MiWiFi-R3L-srv>
In-Reply-To: <ak-1y8poqzPEhXtQ@MiWiFi-R3L-srv>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 9 Jul 2026 18:11:37 -0700
X-Gm-Features: AUfX_mxUmmxF4jRmfrgGZDKxD-h7V8UDIrigGSS6AGfQIWPN15EOxX6m2A0fjAI
Message-ID: <CAKEwX=PbexxwebXdVdeP7sdX2UR9TZTg8A3X=7X=vCsXfC0JLA@mail.gmail.com>
Subject: Re: [RFC PATCH 09/10] mm/swapfile: implement swap_ghost_extend_max()
 for dynamic growth
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60E3220002
X-Stat-Signature: hy9kqdaghnjb94x5guyuff5n55zkichi
X-HE-Tag: 1783645912-908185
X-HE-Meta: U2FsdGVkX1/hepgv7gCT4B6ZobhsTmYJz9voJHwD/xtNzDoImiswdjifQflorTDVmVzyCMlJSr2p0iAOCP6r6LXj04xUn8FqynkcOTx7lGZFDQQJ5kROu5J+mSqPjgGb+wwpnKMU04TYVfa74WlW71V8tTFeNGkUBDb4dZktTBlvU0+jlokEdKGAWcquPsdJfd3zew5JEjdNipo18diY1/R4Y8iHjeWxNu7U8hYMVdjoiGtY8E/GHmd97RkGcrc/cMyjqd/9+Q4t1SjzbczZGARjuq7mv3dLvfvaYB6haT+Rcr9AOYlY4jcq+7RUum05ha5lEWyL8OftsWnt9NJ6CRPsu8RHfvi/gzoG8e79pEHRkipcyOf5f0Feul9WQuubPqADySsi1rgn6lVCA7rNaawDyRdBLcQg2/zM5g0jXwyRlxAm5x34c1u/vRSkpD/WUsaT6qzLOjagSBfoOQbiKiX4n3jUMPBgn3/s+76C44+Xe20VsO3V2XFUdapQaLk7gg93akk2guiWnOiuFVbGfE7M8gdBLXPiY89rWWks0Qw3dvTDZNdRWKaj2TntSwERThWu0F0MeibzWEkLijvrF5wbCNXpAvdmnnA+D8totejeTZmac0ytkqKZBgDls4V2IlCH2nVSlPrcyCLU5zZuoQPG5Oo5gOoMSQ06qtfXXC8fZQ5An/xPhxpmrgeVc1DwDxXI2YTTvzCrEytJSnM1Lk900DSIKwuiAyvWyGpm9HAsQw2G2lIBW6Sgmy2/gMmKIOlXCxibwYPW4O7wUAUe2LN8K+ZAfr76xEGOIFgwL5YIZWp0E8tWoWhhQzUioS9GGx+Spmr37CUbc50v7vyRon5yfn25Zu6HbyJastN4dE9Vr4r/2n6uWk9Eqra955oN/nTsGhybkZfHbacWn+HAx3fRuPogdv1g7Wg5Yn5NnrXpfjDYEjYATanvy9T1MSjTG9yaSl2Px+/uWvfuspC
 DB0qIu4O
 Y+uUxowfkA7XRWDSW7ISUgl4CR9ZCFgVpt5CV8hABntQOEFCW0ajwhIeE9xnQqOYFWtaWS+X6QUejPD492B6CDsR/nqYkwQlYD8szGE12o9e5OEjdlw7Iwf5mU4yowDMg0o43CAwqipIue12PZKW3DHg7ILiId6Nckc7gEQm/UVzYKyoZTG5zIwPmU3qSv2zVnB3gEW5o7rRssncjpRc607MqWjlUZVsFt7PgFVYSu0u4ZsLCDvplO68IOrFeS2ku63MPDSSh0cgGySxwEhfN+uPvyP6iuqUPj/BnH8n05XY712YQQsFbMy8EFBLwbnHCzs9Ns3g40YI4drmzwvwz4G1Hm+z+Ued/4mcPudmQ0NjIPiNVs8UfBPJYQbA7xs1YxUMWK4rJobZObHa0XdzJHHE+eeC5Ykdlxh6t/Jvy8aXw4BvvgjoL0Vll8FrR1dVfN/nU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 7:53=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> On 07/07/26 at 03:36pm, Nhat Pham wrote:
>
> Yes, it is grow-only for now.  The metadata overhead of an extended
> ghost device is very small: cluster_info[] costs ~32 MB per TB of
> capacity.  For a 64 GB machine, 1 TB of ghost swap space costs about
> 0.05% of RAM in metadata.  This is not a resource that needs urgent
> reclamation after a spike subsides.
>
> If it does need to be reclaimed =E2=80=94 for instance, after a one-time =
spike
> pushed capacity far beyond normal needs =E2=80=94 ghost swap supports swa=
poff.
> The admin can swapoff the ghost device and swapon a new one at a
> smaller size.  No swap type in the kernel today supports online
> shrinking (not block devices, not swapfiles, not zram), so this is the
> standard mechanism.

Except for my virtual swap design, which does support dynamic growth
AND shrinking of capacity on demand ;)

If it cannot grow (and furthermore, if it requires userspace operation
to trigger swapfile growth), why do we need this at all? Might as well
create a new swapfile with swapon? That was my point.

