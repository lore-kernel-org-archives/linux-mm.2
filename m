Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A68606A336
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=foHbyGKl
Received: by kanga.kvack.org (Postfix)
	id BE31F6B05B1; Tue, 10 Nov 2026 03:55:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93786B05B4; Tue, 10 Nov 2026 03:55:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82BF6B05B5; Tue, 10 Nov 2026 03:55:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8582E6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:55:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F6501A08DE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:55:14 +0000 (UTC)
X-FDA: 85418600148.19.9882BE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2D03640007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:55:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=foHbyGKl;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794300912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvaZ/X6Bxi94U7st1FV4Wbd+ol04f5D6i4UgeBkOt8k=;
	b=5La1Fa5bsYGvPWjpw/vHqxYAGxioTPWbLln6y6y/ZQq3PiVPkFlTD0+3b0Lw/Ui1y43MJj
	4TFTwZOCWv+XEDCybJS3GNe53cNVir9SM7fG4kwjnZsAS0yjoX9G8S9VeFjfv7tHrpIgPB
	hwRjgk1W6VSaPOt0A3obDD3w0SuMtyI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794300912;
	b=qSCSX7jIhRTJrPzeYVIBl/FboNXXpILi2jN4cCgsWSqEUmZq1lMdTm96ATC6aKtnEt3cIG
	naqa29eYcpYwXteyvT3NEFCrDgQsLTmvpBi+vMRe9LJg69ny1x5LC1swzvHvtqlE3l5sYQ
	SOtH9//kshCYQ1bc3co4eHdtxIcpllg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=foHbyGKl;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 910D8637F9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A581F008AB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794300911;
	bh=YvaZ/X6Bxi94U7st1FV4Wbd+ol04f5D6i4UgeBkOt8k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=foHbyGKlNQhA22qWcsw8f39vRZnh8X6rhvEmQPRmL+asxuLVOYPVKjljqaBjoE70U
	 WQqgTcQklFoX8MeqhDHQ2bbE8D25XQGe2jqtEl4SXSUU3Wnm3A5cNDVhpvaJiAYofh
	 CGZhgRY4rqjdjNPCqASqs5djpk+V8NoAZKdFrZPRlpJ78HSR65QY9sqMtkYfrEhT72
	 SpGGGY4lBGsrRMoNEoUzurYi2p+AbraBx+EadkBZ53Bn/i/p3ocPEeD72jqPfZxH4X
	 VFkSe1WDPVy+27/0Bg/ckDBnwtdrHqD0XPu1Nvoi01T73zWRBxb+17p9mBMGqkKjkL
	 tNcpR+bLLE9Rg==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-947a6142ca1so13448985a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:55:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFgHYdlofE093Z+feUMvsKCJ4vinGUbS0fl+pB4aHRAeznI8S3xl41SI7+gyXxtQDUNKXZlLRNPhA==@kvack.org
X-Gm-Message-State: APuU4Z8+cZeyBvgM7SYTmtLJQYHT5YOyNkpyrwVbThmoph+At6TLIw/f
	lnK9jlJ6Qx2fbxVRbeKIErDioNwu9cvXCKT+iXaIw8wBFKRA1XtAIVsDvVYmr4Y7WNxkIEOGH5A
	cn4TrRBkyPxKR4vY0pFA+e+FrJ40URw0=
X-Received: by 2002:a05:620a:6491:b0:93e:bcbe:f709 with SMTP id
 af79cd13be357-9479f2f0ec0mr257530885a.16.1794300910593; Tue, 10 Nov 2026
 00:55:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev> <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
 <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com> <CAGsJ_4zHtv7hBCaW=wdfiM7yA4OJS7pcFomSo22bEzWHizYAXQ@mail.gmail.com>
 <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com> <CAGsJ_4zLiwYf6LM_BWoZyiYWxvW2H_siZ0QC7FmEHazF_fLa6g@mail.gmail.com>
 <3c0185d0-ed2c-458e-bbcc-cd35070ec743@linux.alibaba.com> <86856d64-593e-4d10-ad40-c0c4f056332f@linux.alibaba.com>
In-Reply-To: <86856d64-593e-4d10-ad40-c0c4f056332f@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 10 Nov 2026 16:54:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xjDmc=s42sSEPYwxaGXGU1zZY0308UbQ5m87pkBZJZCw@mail.gmail.com>
X-Gm-Features: AclHuK-w2Nldkmtvma1Bg9jGFHQDQ_8lpB_b8E1LSzfXJV4rkN8Crf47apRDLJA
Message-ID: <CAGsJ_4xjDmc=s42sSEPYwxaGXGU1zZY0308UbQ5m87pkBZJZCw@mail.gmail.com>
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, 
	ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D03640007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ixe1frhd9e1fdpkq3fxji366tqq1aw9e
X-Rspam-User: 
X-HE-Tag: 1794300912-134134
X-HE-Meta: U2FsdGVkX19YGhsmvVtfYwqb29r3xvVuEvBIKtSsmCKia1G++wma3GcY9N+00uacQUpGRsR+XKyYRsL86vxa9DEWpcVZjmmLSmdCxeyEjtuFvOt0BKjZv7XFsf5GdKBgo12/ovCAYtqnnCPy8e3nS/j+UkLE/e3bk1yUCZB9U9nDliogJToABshQPO0OeHDiIr2PTn/G+EsV4v9AagmSJJzsIDSavOgbq5t0HuHGrnP4/lRNebCG68YX2X3O1K9B025gJDtDvP0HPeuMYDT4JGNZdptBpAzuMWGW8ne6cmaVHcfxpNRR4Uj0evMBZQVLHSwvFEFp0nQEHnraHsqxNUhRL0o+uv3DRnzoV2j7O52JlLvXYqAtUTugUZB2kZd5l22K4ZkgUkou5uauDypWItwBF4tUX+oCeYuVMaAeWUCmiTyJqFUYuf5iOWczYokwQ1eB86RR6vnGvv2CJPwf5zQXWxOJQhyiLvf+CTYs7UN75ZAYyLNffaMX9F8g6mnVraQ/yv1OPTi7AHJzH7Z1nhzV5A9rZmLUsIT38J1QCT4h0PFqKhK3GzTm5YKC/KojJn/cAGDuvJp6oWHhyUXfA2TS/FcSZjqqYl5M4ixDidFoFWP+7fXmM+K561DD82ChGiz8z4jRgwQ0Q5bQ376GNAVp7vgQQ6HO68P+uT4lH8B6+qPq/c8mzmAygYtbVpI6NvtjK6EeT8WVOy7BeraClOd8CUEbjr0GPpDMEdBvC2Hkk8iT3e32svEnOwbur4oCvQvNfJOMpntoYzY4TTvleJyT/S1oMmvfEdBFduRk7Fsp5luvkA5qI4oGesarFXoM4U5RQgon3sABNQOE5oU5MCrShZS+HmtAVe/JGt8lmvG8ts1C94P2MS35AWpni5V8z4RuSF/j5dlK0qZpcsljxnMB+OHFZHpAdJlzcke+eiA/88pdqlWMpn65VbNmritJ0IASLYd+kkAy6f9ajkq
 cpEBRlC2
 iCz2O9Q0wI5vE1g0tMsLTloHNln6qOIhQlmU0rfw9ooM3lE4QOUFSnZegr9qTcX/phL3W7qS+QXes7oZslA+PmODvH6aPqNsvtq742ifi7yom6OrlN324OIYxHZQ9AaW9w1Sun/E7zKXW5NOK++RgAEXcMMZ7A8MAx8iijyWvQLQt+FNxH5kWN9ULno/6nCWQseT3QcWLUdned4Nt14faFEhC+S8LDvOK91VleMOfaq/gfhtaNZGqwa0k3AjAbCHtYIuYUphtQCoOUdQXKPHZvwYeHQGYG06v1jL2heqmSKruthUa3rv/dwGcDTUk4fwxQjIJ8rHV17aD6Jk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 2:24=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Hi Barry,
[...]
>
> Sorry for the rough quick measurement last Friday :(.
>
> I found the first memory.reclaim() trigger has high variance because
> folio_check_references() activates folios. After the folios' reference
> flag are consumed, memory.reclaim() shows no regression with or without
> the TTU_SYNC flag, and the data is relatively stable.
>

We have MADV_PAGEOUT, which bypasses
folio_check_references(). Could it help make the test more stable?

mm: madvise: pageout: ignore references rather than clearing young
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D2864f3d0f5831a


> However, my testing is simple and doesn't cover concurrent stress
> scenarios. Whether to set the TTU_SYNC flag for small folios can be
> discussed in a separate patch, along with how to evaluate the impact.

Thanks,
Barry

