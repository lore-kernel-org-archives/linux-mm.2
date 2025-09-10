Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA48CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B17F8E000B; Wed, 10 Sep 2025 12:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789808E0002; Wed, 10 Sep 2025 12:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FEB8E000B; Wed, 10 Sep 2025 12:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58BB48E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:38:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB65A1D6E3E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:38:04 +0000 (UTC)
X-FDA: 83873897688.10.EF223B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EACD214001C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:38:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WIm/Ujgb";
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757522283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldXWcdmE13ah6lBxgKqVw4wJH+fE6gBrhvUZKKZw/r4=;
	b=gLEkhopnzpDEaPe8K/0gd0JprRQHFi1RsU4WAJuCKW2bibVn+H7juj21XCvbnEkPAArCjA
	z/ZJqyB3cI1b8IF0wFMoZ6NmBYJ2jLypcD+oaRFXysEsDeZRQ5LvNxKram7SEB9DOT3OUv
	+gVK82tqFbQsrEuWsiSQyDfIz3IlDG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757522283; a=rsa-sha256;
	cv=none;
	b=K6Tkrz8khFU9l+aszHxD/6eo5w9TM6Y83XBOllhmvBWMUJnAOKHsnRH0eYzlH2eH7+LFlZ
	gbibq51UeI/ts+pQ79ZIPD3Q3WFCUbqYEFvNOEEP0uJMIY2XSD6Q3xQJunuG69+fML6Q2I
	c+CL2FEPkhdn/53C8/etUQgkSAewJvc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WIm/Ujgb";
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85AC8443F9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6013DC4CEF9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757522281;
	bh=ldXWcdmE13ah6lBxgKqVw4wJH+fE6gBrhvUZKKZw/r4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WIm/Ujgbf718kx21gbL2DeYQbNbSuzmw0RrnMIzAFC7+nIyV6HXBDDkyi56Pp4YWR
	 TSrinyh/piAyYQCqh2pSE/q/Xz6rYZ0yO5ViM7vVG7pVyVzP0TY4jTUf1N/Pctr1oW
	 0V2elYdB0RTIfb6kF7AxC982txzB3uGmCPcxl6p1Wmd0cZtyQmJNEwIBxe/mIgCjC8
	 SBs6K7PxFs4AmqLCkFhSwiLhtPcnSRRJCtQdGJuG7MCcJHbC6hMdHL01BNBOra0v0r
	 A5H5K6vhIvPUHYnV68FFKNFX20URxA5u3aFuLEZz6bgbihjYb+Vb42jdLCiQjHjYxQ
	 Ds1+cCxSENLeA==
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45ddca76f22so67025e9.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:38:01 -0700 (PDT)
X-Gm-Message-State: AOJu0YxqEMiU53kmwqSWQVkG3IZzKuJ8QEIe4CzEv17G767+rqrE6wBS
	5ssdsD6qWjvB5z5VfLkZefLIYp9KBjUpTAQIQ64cYdv1miHu/OHtJDa39ZRisPVolEq8i1ggsDs
	tNvoF1sOzRC2lRPEcLFanme5g7yRzzBys6xQbggAm
X-Google-Smtp-Source: AGHT+IHIcZSYVf5Ghq8ZCt7fBSe6Jk0JycWud/uY2Ua6Qwb3BTtv2K2VfdajQ80Prrk17CPuEPzgVIj/KEesxMsohO0=
X-Received: by 2002:a05:600c:4614:b0:45b:9a6e:ceaf with SMTP id
 5b1f17b1804b1-45df73f78camr1353545e9.0.1757522280029; Wed, 10 Sep 2025
 09:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-2-ryncsn@gmail.com>
 <CAMgjq7Db_DbZosWrUUAGfObDYA2e34zB=RtUpRZc2u4RJBiSxg@mail.gmail.com>
In-Reply-To: <CAMgjq7Db_DbZosWrUUAGfObDYA2e34zB=RtUpRZc2u4RJBiSxg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 10 Sep 2025 09:37:48 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPd10FosK=CQbrw3ZPF+ckJO7-_1eLKY87_MX8sZ5YYUQ@mail.gmail.com>
X-Gm-Features: AS18NWA9yRquM3BelDzwSg3xc3yiEw69xvVtEIQURHSBoX4G2NvJ0Z9YpOqdPN8
Message-ID: <CAF8kJuPd10FosK=CQbrw3ZPF+ckJO7-_1eLKY87_MX8sZ5YYUQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/15] docs/mm: add document for swap table
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EACD214001C
X-Stat-Signature: x48eo1fbxd69y1uy4a6wc5ss3f9fpkte
X-Rspam-User: 
X-HE-Tag: 1757522282-72941
X-HE-Meta: U2FsdGVkX1/l/4v4s8vwVLMLJmEKF+mIbWmxonnEiE0NPNpOrPbmlUKHwq8mP10Y0iJAAsScKT2Ka5ffGEUEB92laGUnCVt2BKz3uyTiwwnZf92etI1tNxzcOqQSNVDW8LcqCFvlKHONmNQI9nGeljnsTkSv3HzJyiYtTww8Ary0RzyFHFE3ozv8Q4fAjtHK6U3PcrzZnZyuv/ELgyVdJwUrVFIc+5iJw+zdjSm18paPUj8InH6dbvRM7CDUwHf/bP6h6MosM1RrsGkmj5jKGcc8AC8oJDSeiVhfQz9xwh75+m1PDuLg6P4kxsgumK4qnb2DNOTshHxPXepS9W6biy7I3CQKGayU0uMWfHacqPVGvMmVIcGJHaJIXAfuyHeVIE92gTLwcjXu6plO1leUWHRFDv4YZQpjqagX/sLtfhDrDqPyWTxYo8IN7H9nkwvdEmiOjKvh66malco12Cjec4HoiiEtTSHQwa+pWzlWrt1wTsRSngSHfgYFdKIfPtjlBByNht9342DYnclFDyFtrFbL7Y7aK5guFuwa4dPdL8lzgVQUiV4WQTRzQVat4vBriYClFCkjRKOpl75gCmzBM7YSeOTrg5wcWScV86O6sM08dxb7t5rL0mpOzDgbx2KYAbjApohE99m82TDAa3JM6ClV1JQoaTHQdoqsmoRMfTffOt8fFW9t2QVzZ35tO2F2M5BUPUpJrvfDG8EfjLj9CEc4KM8yp5K5+pZsxshe9SSs85QGfZFCoagrfZdQLMF6twKStVrR+4acHKo6eRBynSRu4lXHNso02ofhBLgiWR6kbukYvOvMQyyDKB3GdLkQRa3ubFls84YRKfssOHwcXfHDBSzz2iMvr7KFnsk60yBsbXn2OZl5Cye+QVVJfC366mdbZr5/igdQxHrbOGc0+f9y0qexrTkl4Z7FaSKDILuKyAdmG4A4yEmd5Wxv6lVAroAKVNXx6/mXZFjwoSX
 S3rnImkR
 0R65SSU/W4XcWcwyjP5CYUurEE3PCNMQP+ip71QaMl9IuivBCu18vmhHpfFNwD4RGT/zSrBQ39B7F0o35ZFmOZehp7RDLA6R8K85GGJsZyAIGEEMRxKn7ljqIu5dyVSiPwYYjOYbrNJuKzV1OZFqJE8nVi5MTOZ712pMSOLtbAI8gafosbJFEHWp0n8qskO/6WdKbduPbgEo3D8L4w4zCusbSyNbdG6MyYXZdKa2N8n5ITBmcC/UKsKBSPbd6BaFS4ihnEI60SOJmkI53uQtEEoQqKrs94qQVhaCRmpJG3rIJUlc2GGZ6cLA2haicn8DjloMEZROyHLGPQDeaG0t59ubO9nHrr7qx/wAT7rmKoPPLPMw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 9:14=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Sep 11, 2025 at 12:08=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > From: Chris Li <chrisl@kernel.org>
>
> So sorry about this. I did fix my git config and verified that, but
> sent the email on another machine that still having a broken config :/
>
> Hi Andrew, can you help fix the Author to be Chris here?
>
> BTW I saw the current version in mm-new, the author is already Chris,
> which is correct.

If the mm-new got it right, you have nothing to worry about. I assume
Andrew's tooling already takes care of this common issue.

Chris

