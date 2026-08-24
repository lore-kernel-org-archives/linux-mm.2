Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD93C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072B96B008C; Mon, 24 Aug 2026 15:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023886B0095; Mon, 24 Aug 2026 15:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E546E6B0096; Mon, 24 Aug 2026 15:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9F406B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:48:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C843A3147
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:48:12 +0000 (UTC)
X-FDA: 85137199224.09.01696C1
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 648CD20006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:48:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TE5/Ho8l";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787600890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXozA/gR0fE2TcrbGJcWa2WvzWIJ6gIbKhyeaCdATy8=;
	b=LDiwTfHhQxgF2wsAStFwBV28vLpM8ffgIgW80QFV3CNMxKBSBZM0euS+fjta/xLnSb/hsH
	FujKEyYWfNUVr/s9pcafnRJdjMh99JsqllIdvMYN2+BuS+YtePtYzDYElHAPSqrhzFQCgB
	JEmsA/0OGqncr5RFcL3X1HeG8ujl6TA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TE5/Ho8l";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787600890;
	b=6u4bGQMf8ZtvgsToMMh49oaOyQxCd945BTJ8OV0NbURfFvoaAW21V8VK1HImFsYmZtGOo3
	rXdTWFxMBoEQ9BoRc+xrvsP9lcEdkHisr1EILIj/0Jh8mqk8bQ0qM0JtCUODsEER/FH6Jl
	FWtwvKXC+99/cxyZi5iFMeaSjaIFTWQ=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c20fb91ed0fso606270766b.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787600889; x=1788205689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RXozA/gR0fE2TcrbGJcWa2WvzWIJ6gIbKhyeaCdATy8=;
        b=TE5/Ho8lRQIuw4dzHQ+APSntI4rsrUUht1Pg7bRNYUXih4nspsrUjem4O3VFjIlPBp
         VUeLt1GmqSTz3cMOIxAsJvTDjgQepAYg5PBAl8phYRlH36PdaJl+HdLeZ2wv0Mk7bepN
         gkTtzjQnFz9xnQ2udy/nBkYFTkmLgJE7xzaV65RMVE6VdBRfwQVSmKOUfX2Ndmhx1Fjo
         gtGdvI7lnviLypbdpm31/BWggwSoQGRztEqK/Ppe+kvLjUMcbt8JyJ1nlOoJ4/k/0S1S
         tvfgNOccZ5RCBm7UWUIKLgjGsx22rnhpFkIayT1a64lwGX2lcEfxjPUGGCGZobpBaDc3
         4LOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787600889; x=1788205689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RXozA/gR0fE2TcrbGJcWa2WvzWIJ6gIbKhyeaCdATy8=;
        b=nqnYBplCbwQeDLNh5Ac8mYyjwzaCPmX7hcvKoE9l3mF03gixKC+AOq2usdi7WenASD
         8Z/RcoyUUUwAVWwmNxD/Foxag5WpCQxQf8mKFQtd5wFirT28XDIADD1B4jo4I3vmEnio
         r3aIaZbEykvv2OaS/6JClTiXQrWQZmIAsVJLpMYzXuPxq6+98neeqDxj3/7CF6e34WsQ
         38SHLCHcB4PddSZZdUYQhQ/IrilQ2d90jM4sCDgaFez1dlUz53n+yTtnCbokckRhHh6t
         vYMwJxryBYnp7TN8BVrerzABMU1RbHQeOB1WDwXJGo+bX0Z+fJWdIRTDOoYaRYurSayc
         kbpg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7345h9RQiYJxFJ2WxPjbBrITXCBF9eKVMzcvflOHw9GgCNvHwnZl/JzmhFdAP5eNTXu35YUJ6fQ==@kvack.org
X-Gm-Message-State: AFuF++k5Bmc5GQ84khCwOx8zn6yUMh8qZ2QxToHwrH5D5R9H6UXTF4qc
	oZaw24y68LZ6YNuf7TAKYEH/dfLx9n6+W6g+WNL0lBx9OAhbPQrdSOKX
X-Gm-Gg: AR+sD10isxfFP/oiBJFg+um9J7HE/s/g/KFdqoiSd82J8bHZdfS3zIAm9RWxsch9b9z
	dUvxHKaB0Ju9TXoRqeipckdy8qSbkl8toM7LC9ijgAu+H4hW84TdP51zMU4oQNjB1JvN38iiikP
	X4wNfJ1lzsyBU68iYVl6rSnUi0WhkFs/UlwiFipZINFl4xWrQsxjFyxzab8oK/H0vWbPQi67Glb
	7MdUzYZroV/OB9FMgGOiz+F1NEM75GlPz0Tdun2Ci5XigIU2a7OKpiqppfQb+XiIarI+5ThWixn
	Q1pbJUfJQE2/iTGghfyx6uJU6JKNmIWdpw7PKvPnIbXFm03W9YnB5sGAVyyxn7Jwn0uJSYJygBM
	HXSOY8xe1PXQeYIg3njIZ1t1OfRDtAwvLDFXNm3N52FMyZCq5XY2Bu8noCg1gjhl4gjA/nZpKuN
	G9ZqjIHfDMCvS7UYmhxrLLa7N3hSM0mD2BGGQCYQ+wtZdQA1/RCVvuzmg/0HeI/yYqRWazl+Hzd
	e1ZZPwtkR9sD39ysmxiSfpXmnWt3FVbefdzlxJFMs/16VGRcOlMMcz91kpL8QM=
X-Received: by 2002:a17:906:a353:10b0:c1c:5c90:1bb0 with SMTP id a640c23a62f3a-c246a353d2emr2248385766b.8.1787600888761;
        Mon, 24 Aug 2026 12:48:08 -0700 (PDT)
Received: from localhost.localdomain (46-138-191-2.dynamic.spd-mgts.ru. [46.138.191.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249629929dsm1432835866b.23.2026.08.24.12.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:48:08 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] Extend xas_split* to support splitting arbitrarily large entries
Date: Mon, 24 Aug 2026 22:47:55 +0300
Message-ID: <20260824194755.216000-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251117224701.1279139-1-ackerleytng@google.com>
References: <20251117224701.1279139-1-ackerleytng@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 648CD20006
X-Stat-Signature: pnphqc5c8bifd8bgtqgownigigiyz3b3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787600890-255507
X-HE-Meta: U2FsdGVkX1+IIBY+TAF0OptHgmqgwcm1n/SJGNnFNbp82aUUZ149OaTe3KK1xG6kgkOLubi0aZh49SqOr8/chPYgVh1O9iRWecwOYFWOoO6O8Csxvifty7UbMeBHqljjkaH9C/p1/hB6yWHWsnSNMzKl4oZy/xMr+Kka5PDiIV/egVdlCUfJLKfPef0b05Njob+ILzx1plBmRr7rr8d92I6SEFaqofDZ7WyLn641/uJsCpUryQdTOb6ZVOgH2kyJjzKEhp5xoeWrSDqLCQ19ARChQ0TeO1plJaj+m/3Kzdm1Rn6H5cFadtJ9Grl5FzRmIX3Aw2RkGFMdMLDp7FTQWHupdvNrpjDb37bqEWNWAn0ox/G3trRWajLr4WIA6kPtktnFvDk/STxTLecA6/YzqnFsy+S80GJsTUBEWAfuFfnvKLzjzE5yVpzVqGoVR/mky4qvSOCxmsNrGVuHF8AunrQe2A+m9EjCNcAlBCvpw4RrQuitiP88ZB0eqVESqyFKbrJtdtQH1Is97Dr8pjU9HmdUuhigOJVTdKjzJgjcvIZc1GgPT431GHcQYKdYRtZoxpqeca9AYoHtx0VaE3LsdAyDvQ3SdydWt2ZM17eg7eWLHinqdVoHmhWylAEh1w0l+q26haCgVxgtIrtmqL6KQKkMRGxxUjxHXKZiShBd8d/kYT03M+CXSzDdGJDLYlMIsePybb2xzMfqVRJC4vg3r4jbk+NikiHS4FlVivL1pg3SKkQbgSmiBHScV1/BBS3Lab5Wj38AEJcmwL2jTwUaP/yJAe4NWr0JUDxaxaRpbRwom9wbHGW6yP2NPYi82epmVV3zLKGhqPgE6eDXfcuwWFksTkVhNkumyWi7mTPasiKVA04Nva+CVGf+hMll2xOA/HmQTQOF+JIrYuDt7Ik95r7lZ915IBNXrgLfzhbW1ww7JSGY298pAS10yQZEvWZavtSIuv0qTpNCZiWF5fz
 X1yR6HDV
 dcaux/44mS2bidxbgxlkudbMng1sdLls4EdqeCLyJtpeN/pA9Jg+86ajaYGxXgyOTNkQ7Yv2VYAQ8EigiyAoBV8ZJThK36Qg2Ub8s2RvceMvErcTCTx8YbLU4WfYVc3FrAslT3XMmhdDJ1pP2w7NSLuWsfD5Am+3hrK8ECviSWKO8D2kzX9vIadiPt78/ZZ/oZOSPChJO0OysJh1FXViwyZk01EZvumRz1+PqrGkkSKfS8oHfbL48XJE04bLPde82+Lme+eYCwzerG4wJa2aQ6F7vrP4/ODUkznBtgzPmvOEMpMcWgXg60OvX3uvTk6X6dhWmLYelcTchiOonHE8FVl5qyUKSfAcjHtet/+mhnKo8gP/EKdz39IXQhIfxWn/NW88NBoQiONedC8tKYgY8OJ+eDwD2NmRjvmkbA6wB7S6vEX52l9pA3dBEBKeeW+A2gHzaR5M8vOBcOY6FQPGiz641oieNuXPRVLwwdv/0lTjFExzXvpzvl6XZOTWrkl5ntmbwe0kShbS8F3uEqf8AoMs09g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 02:46:57PM -0800, Ackerley Tng wrote:
> This patch series extends xas_split_alloc() to allocate enough nodes
> for splitting an XArray node beyond 2 levels, and extends xas_split()
> to use the allocated nodes in a split beyond 2 levels.

Ackerley, are you still planning a v2 of this?

I'm asking because there is a second user for it that has nothing to do
with guest_memfd. On arm64 with 64K pages HPAGE_PMD_ORDER is 13 and
MAX_XAS_ORDER is 11, so MAX_PAGECACHE_ORDER clamps to 11 and shmem never
offers a PMD order. MADV_COLLAPSE on tmpfs returns -EINVAL there, and
huge=always hands out order-11 folios at best, so ShmemPmdMapped never
leaves zero. Every other page cache file system tops out at order 11 as
well, which is 128M and not PMD-mappable. pagemap.h admits it outright:
"xas_split_alloc() does not support arbitrary orders. This implies no
512MB THP on ARM64 with 64KB base page size." Kiryl's khugepaged
selftest series skips the shmem and file cases altogether for exactly
this reason, and on 6 August he confirmed in that thread that uniform
splits still go through xas_split_alloc(), so xas_try_split() on its
own does not lift the cap.

That case needs two new levels of nodes rather than one: 130 nodes,
73 KiB, a long way from the 1G to 4K split Matthew was worried about.
Raising MAX_XAS_ORDER to 3 * XA_CHUNK_SHIFT - 1 covers it, and
MAX_PAGECACHE_ORDER stays min()'d with HPAGE_PMD_ORDER, so no page cache
caller can ask for the order-17 worst case that cap admits.

If you would rather not carry the series further, I'd like to pick it
up: rebase on current xarray (2/4 collides with the XA_FLAGS_ACCOUNT
fix, 88f0adba8aa1c, and 3/4 falls over behind it), keep your authorship
on what survives, extend check_split() past order 11, and post it with
the arm64 motivation. Happy either way, I just don't want two of us
rebasing the same patches.

Artem

