Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1925DC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 22:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D116B008A; Tue,  4 Aug 2026 18:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DE66B0092; Tue,  4 Aug 2026 18:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BA66B0093; Tue,  4 Aug 2026 18:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD4E76B008A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:22:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4822612031F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:22:08 +0000 (UTC)
X-FDA: 85065011136.04.B9A792F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 77B7740008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:22:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6CJ6zNe;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785882126;
	b=PajR7rHn1LFITtalT1FRwcIFq2ReiUFxvbaSW1vXq4liqTvGAXnycgOrXisW4sYHOhuAqt
	IRV32nnjnXNEQjDGqoBunkR4JOhWzexpKUM145OYchMn0T4ZHn4y5r0f9HpVp2bCWLtvZq
	Vy2UdOaoPs4nfEdK/Xfg9OcJIp0JK6I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6CJ6zNe;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785882126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W12dzO7vgZVNKvjV4g3A7AtcxuECvisYvjLVJtUwhC0=;
	b=N0UVNz1HxDMh8mCmIc6bWB9//NlhRLarH5WLKBRL3Cm09SsCYE0CEwJqhinZIZ5fElRLzm
	A504geVGn/h5qzOjUbuoRGflJXPXN65SI6vJ6kR/Zg+oxZHNaBCQF7mnJsvxPjMhRwHQ4W
	NzCtc3juynxx15zZQmroHLGZU38EzUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B98C60A60
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CDA1F00ADB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785882125;
	bh=W12dzO7vgZVNKvjV4g3A7AtcxuECvisYvjLVJtUwhC0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H6CJ6zNeAtAQ3czxPb2+pbEEI6hmiHWxWv9RE5aFyKKFrXkKk+QrAgTCmb/NTP43z
	 8skLFk45BzQAwII5zXNbFtzkiI5KeiqBsA8YUczb7d+eonBtZdhWYWTri0hDsvO/B9
	 Mb+saXeYdywjEhFHAWDWmuckw3XThl9b81viZbaX1Du+HSI71ByigszndUe3mD+ZqP
	 NvKafAExsCN+oyB8rx6WASiBVqNfUEgF9hi8txdRXH3t5st5cWq5k7YxLHRTLLQRe4
	 Qyc3S/02UY/2P9T56jF88VOFc3P3ecqLJnrSgwnKsKOt2JJBDIK4BXxLuE/qRPZ6v5
	 BcD4KfKTAqSHA==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e533aacf2so23486085a.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 15:22:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrcrH/p7U02+ejnm7gZSinl7gSdwAQKNwyaijReucunyQViR0oG1lo7NR/bPeThGta0seKHOghz2A==@kvack.org
X-Gm-Message-State: AOJu0YzxU1d9L9l38nqnyvkZW/L7rDSoZWPhfc+2Dr9QibRxJkHawcIM
	Ag3T0u9bdXF2d3UvYvytGkBzgwzUj9VcHlSS8FjqKYBCzjA2h7E6osMif4B5SYY0+VSVcOnnaUO
	aiBzjXp7kbQ0Cnt/XDeXAN8yPnwmcJas=
X-Received: by 2002:a05:620a:270c:b0:92e:7cc9:a888 with SMTP id
 af79cd13be357-93649119b9bmr199237785a.2.1785882124377; Tue, 04 Aug 2026
 15:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
In-Reply-To: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 5 Aug 2026 06:21:53 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wcq5UXq1RAoD8iygnKV95o=D+nOd01ncz4GQJ8Bge3ow@mail.gmail.com>
X-Gm-Features: AUfX_mybQ80Lx8PwialdKxVIhIqHFVhcCtwxrLLGtSQkGb3zGfEQ2A4Kq4si_Ec
Message-ID: <CAGsJ_4wcq5UXq1RAoD8iygnKV95o=D+nOd01ncz4GQJ8Bge3ow@mail.gmail.com>
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77B7740008
X-Stat-Signature: 17grmwq71igh84a7kuxoyqgxu39c4p7s
X-Rspam-User: 
X-HE-Tag: 1785882126-319588
X-HE-Meta: U2FsdGVkX19W5K71hGtJ24uzfc7be/L/omR8Wxf+n6VQhGNBo1c2/taQrHvW7fRbeZqXyTJ5HbIJu/mn+Jnv3rQaCdUPigvYsgJvPP6LoX3CPDayk5pAHEZtCtW8diBLm3sunRbtmIyNUH3qKOShqeo0S3vKf3RbZ5olRxsMxG5Li0+0GFdrS9VvtXmpjhM54J79AGEOQIbsPtCm30Xd4iKy3tVKjH5/t8bdQnclSB9LrnphJJXTh0FYHBJTRJn9S2Pa73yiMXGDVps2jciTZTqTwW3olknfUDrMPqFodxQ19yQPILg3IN0Ho877j88Kh9XBipIOTj1gffMk7EVILmQfPSIoWKpZa6BgjfOXnUOwYgZE8L1YVNcS29TInM+q6vyKhzLVcmR5bVGNuEVJIqkE/rZUSVwMCaF1qzDN/rHuKdpLDV6OK7wNr7x+B06scIiHDlxaC8jfvFERdcAVjHHLu8cAXnsO1qjNffsmWWwiVBkq5gMJsaUNtrcPGj6zvIFc/NNNTAnnuL6926MEq6ZLqxpsb77vLwfQO0h5/WN5zXhBE5s1297QPYmZRZr6gixVGABKMlC7SqenYWBEnJhZXY3qucreeFXwWn3sb0RV8JvWb7sCThYhcBax4DvGWsC+no2DfruFTxu1g6tVusew29gdHZipKIpiLVfSROgPNx+pwxFK8wgi/0heVE4Yx7YmhJTSM+O488NwzHSv8H8AfXjW5HuksqupNLfXXccKSzm9TYQjROhhBTkX1bi8Pup0QJxzQJ1MvUodR8eqDYMZgHevShgdxQ/Lr2ZpBqS5ZpJ0aIgtah7svmY1TZ/jcTD5QAstBr7+QwW8Ty+T7A6we/If0mh6wQnv75ATjBBhBZanbzqkcRyJuF8IKz5UUHreC9MoMe2n1W9IAT/82YJMF7igNuUqdpNXtvU6AQbGdbVBB/yEHit1Ntkt3c89DuHx4mQg+JyesVPWZH1
 uDbd7nmc
 IKvWhRUqQiQ51irtKgv7HWDdwUdPwEzha9kDWgQ+SIEjZsbK0Q90sGHHrnzlKff09VkDpYaZeSYTx+Tv3Kx3My/rb6RIi/RNnkIfxqhU5qJz8unosXIQ2vqiAJc0VVkhy6KUB2yJUPWf0IBgrJ4y8gBjCnUmtKiMMqnayAIngD3Ey65bsuCc0of4MWSAjOzsFHs5sxUwrt00fEiJuWI+z8DQ9a4J+BHtrQX01WejBGjfRzo8EUQs0MEaUeXCKm7oPKweVMrWF4vTckP+9FHCZFtvTRgxBY7Rm5vk+0rJORBred3QQ6q3o3f310g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 6:09=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> There are a number of internal headers local to mm/ which reference
> functions and data types without including the relevant headers.
>
> mm/vma.h is a special case that intentionally does not include additional
> headers, but the others are not.
>
> This breaks tooling like clangd (which is where I noticed this), though t=
he
> build is OK due to the C files including the headers happening to include
> required dependencies.
>
> It's better to be explicit about dependencies anyway, so add the missing
> includes and fix clangd as a bonus.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

