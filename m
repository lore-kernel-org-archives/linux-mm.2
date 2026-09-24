Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F224C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B1E6B008A; Thu, 24 Sep 2026 16:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B036B008C; Thu, 24 Sep 2026 16:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F99D6B0093; Thu, 24 Sep 2026 16:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB666B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:50:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B33C88045B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:50:13 +0000 (UTC)
X-FDA: 85249848306.26.B964473
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id BDAF910000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:50:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FnZtoxDG;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790283011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+5hSUgLRco8Y6SztQmttTVOAj16Ju9U76wx3kQ59ho=;
	b=I3LGPlTBbrRuZUTpWFrgVvOf2Q4C/MHxieyi1pKDsk80dTUM6WNJ+dPAO0FzWwRJDOg/Z0
	eblJQG6TrJjADOYsfBXT5A/ZlPFtMfzTKjkPhoVOysQFeD3HjmNFu/JJejh2xutcB4sS9s
	qfTgy8GwOX0GUjhvtypW9jexLuBoHp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790283011;
	b=q3NBksIp4n/pt+gURiQgPg5FIpiE0IVQVmGRmfOngz1+Sf1cmcbIQgydvT/to//pQYdzcj
	1kVj7VhnnF4e9KT7vxyNcZXEweMO2zFgs3ifKF9hSSMkJ3dmtd5ntpsrPTD2wTkQMD/RBi
	mMhjtLkTCqTDbTMq8mScKa6576b2Pwo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FnZtoxDG;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E241E44782
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7981F0089E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790283010;
	bh=Q+5hSUgLRco8Y6SztQmttTVOAj16Ju9U76wx3kQ59ho=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FnZtoxDGh/uBvSnm9FYLg5Ef8RadgMeHyJbMn3WuO2kLW/CtOiBSM7pUwNfkJ7pSa
	 gtctJh3CvDnUWO8YQttG8hbx26uR4xKKDHQWnpk+7bWEB/elSbZjAWmju0yWZxuewQ
	 zKrN3gbVz4e1+6uoOAcYAQnypQNrEGk+4pmnCJoJHev2Kalsunga5gSjanl11GqCkV
	 DPlVCdzgA7Ue5rh/wrUkA5DRST49Y8l2k2fAX8EeeYtpjG+q8YBK4PaoD2Xr468UKT
	 wiVhwqRNWjPcQMar4L8seIPtzVrmq8RtZMfs1m4+bB4NnGH6RCuz/V28v2NKrXZUnR
	 GWWJGBWofs0Ag==
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93bfa7b2093so25739885a.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:50:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwrpG2+LEur8R7SwxYPI9Wdi8FtO5HIElpj8x8vY+FMcnmemmUDz0eA3ZKt1+CNnRGIuZNsh427gA==@kvack.org
X-Gm-Message-State: AFuF++m9t0EI9fZKGdA7xdhO/yaCqqwHz4Iq5TaVrg5VIhrhh2Bkm+x9
	2daQ+KPrM3pvZd9JFlmgvMZ4JC8WCgeWccXqCyWzwT51lIA+LchL4K8LBssfVALW6uo8gY3C2S/
	lSbAfB3EHDGzK24PlFws1Lbg20gNyIhQ=
X-Received: by 2002:a05:620a:4506:b0:939:9d06:e997 with SMTP id
 af79cd13be357-93c43c95edemr89967185a.26.1790283009873; Thu, 24 Sep 2026
 13:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260924191103.3475117-1-usama.arif@linux.dev>
In-Reply-To: <20260924191103.3475117-1-usama.arif@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 25 Sep 2026 04:49:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yiSp_9R5Bc4WR3UF7th03c+FsNyDPK6cyHfpiEGHveyg@mail.gmail.com>
X-Gm-Features: AclHuK9L9SJ1j1Bl7NzcGznD7Wnm5jocUxdYyhg7nXWVX1BHCFN_NNxlXTqkJLg
Message-ID: <CAGsJ_4yiSp_9R5Bc4WR3UF7th03c+FsNyDPK6cyHfpiEGHveyg@mail.gmail.com>
Subject: Re: [PATCH] mm: remove the unused zone->unaccepted_cleanup
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, david@kernel.org, 
	kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, vbabka@kernel.org, 
	weixugc@google.com, yuanchu@google.com, hannes@cmpxchg.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BDAF910000C
X-Stat-Signature: guirg4xeh6fh8e9wmyf1xd8ojj4j9udc
X-Rspam-User: 
X-HE-Tag: 1790283011-793435
X-HE-Meta: U2FsdGVkX1/DkXvTCoVA/QoVUFpydmc/RCIqiYzfaL4i4HOUKwaQaI7TUH/u0osZYmBhf2FImrYu47BQBVMAEOjUnpK+T0+6sIiIOTfn9YSLXef8BHHtDvCKjoPQDOyCE8Loq1XHWwffg00CT3zezQFYT2Yocbm6PjMJPiH9F0V7c5X2ChPhsmP0JwYyQaijfVyxCDij8zqaenRTsAhDAMSluIIB6XBF97x5/GWrSqfXp6c6C3OjTUQ8D26VYu50KVW9VvQ2r9tnRWC/HEcKgislsA6ieLzIP9kYDYxFqAqMtHOB+aiL7b6yEhlJEdujuB/dmZu1k9OZ1CCqhiA2krJ0pll215xGvhf+aLHI1gjp7XD+MeEyloOlCt1Fxd4sMyLOsTMdtuNNd8z6QbwzRnfli3glTI/kxFeV4Q8h/qRaxu243telLt8G/Jqm3fZJSl6ysD25QgH66i6juVrKfOZtJGKNFgNSq0MN9O5ti7jCvbV4luq2vlk65AQXXvN8SlXcNm5vNa+w0xqa7i13NxDXGviECkXXKkVag03D6BiyK8Z6i6YxEYIynMsmu6CBBB0RGckqVD871As4oqmYtmIIVTA0h204wzeDC16M7H0rn89pY79W+pPCXzLv56h+4lq4nbROua3alaP+zPaK9hAWJpShV410WCaBumLJfXcns1n5xACaxflVZT/WcLaEz/Rpo7H5Ppu66PFTrGl3F4dWuZYy5AVK8Vrt9EGVul7DsiZq6eP/8ScoJerCpWMOE+N9mgm3o4eGE/WrsmlvUYnF4QEs271rbQ72rOtIGAC8+i6mTCCv6n0xhYuk18aUnNolFz1UYF0ZrDsh06p2HvWoENyUNdSNNpBYe+xl7jfAHCLu078Nwb5isYPRz3bv86sfRXctDH3wPcuaj6Dn4dkSF8ZFpvrpk2EVX/gJQ9qBYx89PwRN7gRdQA84Od7z7atFCA3TOo8Bxlsy9DJ
 7zzp2mSU
 7ttkQ2Uhbz/HX77Ea9DGFl/OK3N95tgexqXocW3TvY38puumYHIc/J2uPkHWBKJxNQUIhXtearpL7jted/OKw9QgrUoZKoJoHaSt6xPQHwSbMsc5douo27uwQdSNZNMvIOOZX76n3yl+UrXHvM+twW4CpGQL/BJGMADeO9vjY7VG1EF3o8k+eA1b/+gWjHyozOoUF3jItrzNF17zjHR+C1ab/GH6QUMzaovYx7qtxFPr6Doq+ruSPrkZkNsWlgDLvFQ7Wbw3/6AJtnVKlA7o2+671z6J3cmiBOsQ67mTTbKebKF96WWvbd1+9mBAYFzdcWpz0tr45F8dYRox6EYsO5jzB91EwDhJnpgMa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 3:11=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
> memory handling") removed the zones_with_unaccepted_pages static key and
> the work that decremented it, but left the work_struct behind in struct
> zone. Nothing uses it anymore, so let's remove it.
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Nice catch.

Reviewed-by: Barry Song <baohua@kernel.org>

