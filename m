Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74254CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D222E8E0014; Tue,  2 Sep 2025 07:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF93B8E0001; Tue,  2 Sep 2025 07:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36B48E0014; Tue,  2 Sep 2025 07:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B15DE8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:15:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B8BFC0C22
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:15:17 +0000 (UTC)
X-FDA: 83844053874.24.1690945
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 743E24000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:15:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OgdMf5mj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756811715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Muuy3gEexhv4NL/zAMIombmXpD1vHKRCvPTAbu3qpWM=;
	b=MkUc1OhR3RKD07wacGjmbNDUtWUZLPRrSra2rEYS3yIQoeZqFjOj4COSgy9MiDsh/+a3Y4
	rbK/zr34BXMLI/gV6g3ixgi7vzrtevCPgX0wjSQqhJmDbNpMwZnocvxszu76vWOkkN9dxq
	aVMzBNxs9KfRQHOwZHzz3Z80YlmDlUs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OgdMf5mj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756811715; a=rsa-sha256;
	cv=none;
	b=yvgx4r0Nk2ZfyBQMbbYwkkCM5OEqRb5A60uv0bJ+1i7fs5nlAP6/wysdMnFQcUCix607uN
	lm2nkN9Bun1URT/UJk2T2QlRkdS6G2JAdfv7OIgj3vMC1id/D30aBU5KEYt99Gg7A6XzLo
	CUhNYWuh8hwR+FrD6HLYPqXhDqv0YCw=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7f04816589bso484015585a.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756811714; x=1757416514; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Muuy3gEexhv4NL/zAMIombmXpD1vHKRCvPTAbu3qpWM=;
        b=OgdMf5mjv+q7xeTLV3HXT8I92dclbrcY10v3cyTpHkiLYRtbva/9FdXDpTmdEDyY7B
         wR9plfyzIwicHgb3bFjZx29reZ0LBysEGhZAps5jQia6oZ1xRvSLskdHULRnnAiuzSYX
         cIGJBozQHLuoFdmXxV2s5foB+s31vCcyXlNTb8RuSVF3vIgpbcdBJ6Wg11Va9clYb5i/
         CYPJfKJiVV5n49PgxrgP9t3Tc24aCWyiS24Mqe9YmPt2eVmIHIYCGhzgTygX5W+Zzk6N
         yj/BZIzGTaMhmxc3Zgn4bPt+GCqaMRSth8xaBlfXSTRhJdlavVVe2X371V/KtwCC2KK9
         x5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756811714; x=1757416514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Muuy3gEexhv4NL/zAMIombmXpD1vHKRCvPTAbu3qpWM=;
        b=w9AcvNc8NBfhV2sYltypVLHLf/IzQywsLIUD1EMTk201LpQIY4lMFqtETzfqq1Dgfp
         CZqiQiIG0Mm4TKZxbML6vCCaSZLoO3EYn5JT8FZ47dwo+zSbHpAwF2q3dLKvsqJU2WQ0
         dn77c24b+JVbfdsjWCWQw1kCXOH1LiQcETxj5JarGAE8X1UiwlURQLQd4ra1S+O8Iiir
         w2fv+gqJ7nfZxPquB3x5f7+EmFbM4FveHCPKZ8LXEqZAQoW/mah9H1CxvUfhvOEEH0bT
         OVBWczAxaP+RUNPs3GAE1CZwsO7PgTUq0KbJODPlNCma0c/low/DGIbNCqnHkk4Ou4hh
         C03w==
X-Gm-Message-State: AOJu0YztKxORsIjBiWJZuslk2LW0R5DlDGdJXjFd4BWAzXsU0pwzssvf
	nWJ42IvQhsZYopZFUJlA8k1mZvHxkm8NY2r+V1M1IU8LUXIyZhDntxgeSDP2kehBzk1VoxRhabb
	/t0TgBcC3XhobpA0YceAt5GplumHUq+U=
X-Gm-Gg: ASbGncul32JPcKx7oG1LIEAuYupL9AE52e6DOecmKH1CJm7rFS4r8h5HEQsDixKLBsz
	HHo95br/euDdHrrDIjNYwv+55Syb664cnlFRSGWSuJhfgGeicj3GeadDZCwkJW1UGVZWfIuKtRI
	YG24Yi087bhaN500z/eHwlI91JM7arxHQB4dkbWQMbwX3/hSsmjzU2wVZS4sIVudNQt6/YmV2rb
	zaPte8=
X-Google-Smtp-Source: AGHT+IHihVMu7J0wGiafdqLPHYOzKjh1lKiFbzfZm/I7Nqpsl5xFXzGFk/zni3xJLjNUvadYSQXM7c2LuSeGdRQDC08=
X-Received: by 2002:a05:620a:19a7:b0:7e6:8f41:2047 with SMTP id
 af79cd13be357-7ff26eab696mr1231276785a.6.1756811714293; Tue, 02 Sep 2025
 04:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-9-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Sep 2025 19:15:01 +0800
X-Gm-Features: Ac12FXw2zVbOlTxPFwozdYEN2QUi5dTUOC897UqRY3jmRoZMs6j8v_WyCXaaD5I
Message-ID: <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 743E24000F
X-Stat-Signature: u1dxre94soc9umc4q1kyyb3sim6inp6a
X-Rspam-User: 
X-HE-Tag: 1756811715-313420
X-HE-Meta: U2FsdGVkX19XS5pkNXQIqnq1SyNHdRXe187tuTbwDwruH9OX3/70tleMMPZoaQo/1SakatO8dgaK1XoCR9f/UGgHdgWwTVjoJFXBge2wDKhuY8tPH+8r0PWU/ImYrRpAe+M4TDittmmPLEt4CsR1QtZG6Z4pPq1FuS6F2t0RE8j6XaiVEdq2hcTKt0aAlAx7xsOFWNu4LZhIDM7xXkXLY2XyAE6AknGfkJIMEJnGsYsBHi3XpI+YR/88lSgnjisAaLQqJCKj66Y6qIcZHIpQJ4NzeXegq1pAVBn0J1axFo48H0v7+gPcAGzYbI4uMASiHe6chirPYLZPEtriWFlfyue8uzyWnQOlMIq9P2jCK2K/IBMUj/pr6x7PooLRHdzjQoRasszczCSNMn6RWfkOBKIzrsc7KRmZ6X6pmaOGRypwmb85n/0ALr8TThRJwCBxlxWDce+otubxaQF0mPycrhetI21bPR6h5PMkhtJRLfkUQOd74zrVAYY1aGP56oqBxnDkfFa85cL7wKWs2Dyo2FAkYutjfPXHqXRhQ75RDIEJ02E3lfCOxryUvaOXVZ75mCV4LU6s4H/To+sYKb6naVPgdxwkgYworECAxMsuYTJT7dKdI7DmH7GI3qhJa7kackJRCLgXOqaD3evRP2qPbe57BG9XNILJZlE4/3U3tE7cBUdXuunETrIGNb3LS+HNyW/Tt+ZRIfXQoWELhdXcpwe0UAV05tzil7kfegQPy9q6N/3lHxZEVKL1Ffgq+fQXmHi3RFdpXgDhD5xjlC1dbGkls70X53wy9rCg7AbODndnALAuN8QSm2cjkuJzWA+eV3vEAqxqIZczmbKk4do0GTS0/WfSsP6K6vaRrnpi7m81mRai8PWyAAo7vGwrWss6ruE4EFGEESV96pebVurfMfY3HoGYLn8fJdcTDr5yk9WZFSUdjT3YvochGl45ti+tsqhKnjrnt8L9xVOX+vt
 +5XtkI7e
 j5XMYjeI/zowLuSExrvsNa2Gji+OV3tDKlps0ZUEPyaSsNBFymc7h84zCzZhnCszwqIKKgb3xBDFcryGETgoj6K3EfkfcvYwJyprAVeg5PBNAcQWOe4Euqt5skGEYgz447xymWRToioRwEhod1CbLRKF0fbOuTJsjdGu1hYuefUxM+j9dyQpaSf/xOmVq8y+w6DqVX0B7t9MmFpzSsoP8vtnH1El5pyeoPrGC168BVzLeRAH9mjTjbGm9y+JK3haAVBBJpe8U33di+uQwwRnlIJozGBSFiFHFmKHD8KGi/pksCB/EBoA1Sd+LuW0/ZEgkc+41ZzH7GGgoKwd11tak9VelmXfYp+hpdZgoJqIl2QWVYBgdjXXLYXSXaeDGNU9ABQ+lpMoGFK34Gy+2R+FIKqyfEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Now swap table is cluster based, which means free clusters can free its
> table since no one should modify it.
>
> There could be speculative readers, like swap cache look up, protect
> them by making them RCU safe. All swap table should be filled with null
> entries before free, so such readers will either see a NULL pointer or
> a null filled table being lazy freed.
>
> On allocation, allocate the table when a cluster is used by any order.
>

Might be a silly question.

Just curious=E2=80=94what happens if the allocation fails? Does the swap-ou=
t
operation also fail? We sometimes encounter strange issues when memory is
very limited, especially if the reclamation path itself needs to allocate
memory.

Assume a case where we want to swap out a folio using clusterN. We then
attempt to swap out the following folios with the same clusterN. But if
the allocation of the swap_table keeps failing, what will happen?

> This way, we can reduce the memory usage of large swap device
> significantly.
>
> This idea to dynamically release unused swap cluster data was initially
> suggested by Chris Li while proposing the cluster swap allocator and
> I found it suits the swap table idea very well.
>

Thanks
Barry

