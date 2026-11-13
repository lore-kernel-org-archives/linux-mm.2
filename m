Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786A8606A891
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RUFy9rPv
Received: by kanga.kvack.org (Postfix)
	id 948406B05D2; Fri, 13 Nov 2026 12:49:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9208D6B05D3; Fri, 13 Nov 2026 12:49:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8602D6B05D4; Fri, 13 Nov 2026 12:49:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 627236B05D2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:49:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D96D012018A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:49:57 +0000 (UTC)
X-FDA: 85430834034.28.DD3A8F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1AA841C000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:49:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RUFy9rPv;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794592196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6b1wIRKunjyQ1hiIK3+XdFgdL1MzFhXjhe9HykORHEA=;
	b=VETMRLI/uHhROdG6Lpha9dNwoLXyiFRHgiswQyxtKsycHxwL3yyRPOZcNeMpxHz4Z9cZ5Y
	drGLIxO5RwE2pc/LGMjMDO/ueVX4lYOaLYsQqDw0YiTb6a3Z9tjhydKIcR2P6iVIf++RvW
	9Sf7yNf5cklIgJ7x9NIiY5+/4xXbW3A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RUFy9rPv;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794592196;
	b=eP6BnAjcM7x58ci1MpBUEdZQV0s1wbUXpJ9PCAkj6+EZK3GOr945KbtFlVodqBS/SNdj0H
	/yThm/UNXYO/UKyuGNV+MAe9FxoQI5lEJC2tDr1hkyPYCbeoWMlvDWYphCWM619pWCnYOo
	lXhnYJ6rIeer0RctCjKf4JQSTtHw3rc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CC0345077;
	Fri, 13 Nov 2026 17:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE3D1F000C4;
	Fri, 13 Nov 2026 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794592195;
	bh=6b1wIRKunjyQ1hiIK3+XdFgdL1MzFhXjhe9HykORHEA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RUFy9rPvpTRwPT6FsdEmCi20+t5KpAW1p8oTtPXA/HHeEkvrgW5mO+MUHPKier68r
	 qDjP1lLtnT4/zUzy40QFQM17dtB70izVROV+7Dpj0P1dsTW5ozs94iw7tFsNC16Usb
	 xOIJHJNNkYw1gb0boeRZExlerm6EX2tF05jeHdls=
Date: Fri, 13 Nov 2026 09:49:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, =?ISO-8859-1?Q?J=E9r=E9my?= Jean
 <Jeremy.Jean@oss.cyber.gouv.fr>, Zi Yan <ziy@nvidia.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond
 i_size
Message-Id: <20261113094954.942014a255165efc812fb2a5@linux-foundation.org>
In-Reply-To: <5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org>
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
	<sashiko-outbox-212974@kernel.org>
	<5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1AA841C000A
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 35q1ba6t85ouwp4mhdfgxi7ntix5omru
X-HE-Tag: 1794592195-708685
X-HE-Meta: U2FsdGVkX1+TB0eL2sMNgChPJhV2vR56873VfUpvtHgL+UzaPpDy7n5/pbiFIxCKNfnOEFoHvoB2WcVOIYZ7qNij5HxL2Dq8ZkIly0rbaOr+jFVpLrF4kL+wPEUGcEeUm/1sYGh0hpB8DPilYLN9BIr+5YU6t8O7W8YyibtgkNAkZtNe3yTxjZj8ztLXyrI5mvUuJpKwlujetAHgcOf6wom1XRxEzf7/ThW0PLscGhn061OKswwD1Yh4WVTHCNqKlwoePeD5Zkcxf8X7FJQwo90R2tpd4fh42TUcPYMaIoi9ALwBT1fGc0QqG3P+wjgebc27xz/TeF9IY/M59qDDzZhFy6vlxuxoxMAR/jQ51p/gXYC89Zkwv62RWW/oJpRxDnbDETRJsG4uxpAPTVJIt9iDmnGzhlEdRMplP+jo2PdLyetLckFpY5btNMxV0dXnoWlQP8DruloSU5slfXkHcCloCaDJHTY6JK1FBzLHGpSsTo0qDqI2GNmCNsouRCBCdNqZjv5Sr1+NSiLo7W3suKxrJONUQnJWxTWanDyaJL89k9RfzlVphd55cDog6gujU1TKCNM3iAli140cZ66P0ldaLgpwX2KuynhMADdKn4YF7jKvvpNPhcen9z4jZG78NfTl2YmvyQZE3IN7P+LJnmZsSPRZZ4YfVy279Brlx+9GubHHRWE8kXrei3UhkExGSTqvYtLnOFcJ2ibDFV+GXZ7eJSaJhhE9g+arkOH9NzBz4ztVRjPuDtCp+CxBg4zF4OaaGJae/lUxOpnUywGsrBbqOk1lAwZFzL/GDXiV1jvNSWH8q7cHYUwtZ/JbD/2VD5MznLj6pYvSml5n/IRsQvr29xYfOjrjuA0iavrLkmlYnF0bNtJNV8g6IoLB3nUBt2whnDFZjFdQoZ1bHUGX9kTDTs19gxjIiwkBZjYFbc4QJRuCSCrSlWQm000CgVenRdezOdWvUIo5SIXkilx
 dSgD9IHz
 /LAgL5x+9NBxLsRU7fBWJa/wH7EwNQY7ySh1BTSS76DIW3ny208WV+JniVVCNAdYmd4lApGtjq8MSWJp4PKOKv2/fzLFlc15v1DUqOp8A7eDxPKHu4unavkfgR9XUTjQhhiNHVlWnJUxK6kfWgvqFv547JuQ71Ls6bZsU6GsGbggA4t3qmwTMMUHjnh34JWiuYyZ2teq3NDRNvlYX0aLQPgzp5xwu3VDdYV/dSbnluzm875j37zvRCk+VFi5SyIWiUUG8F2d2x2UL/FUY7H/fndvbRnBm3xnqAablOHwT+rcvMIwP+ImpRfTXrdyyB7Pp6qbuRgJqxtLx54LccPDwRDHJrIjCx+zWGoYLng9AB2aDBDQ/3H1XEBpZZcs4thpsH02B96Gy14kFWo4foy3BCvEWfg8MSz4gj266SSUnNYwNP756p6xDeNztu5RhHDqVU9E5SYq1AG1AbMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 15:56:50 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 11/13/26 15:25, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found no new issues
> > in this patch, but noticed 1 related pre-existing issue it does not
> > introduce:
> > - [Medium] mm: xarray node memory leak in collapse_file() [1]
> Ignore this shit from Sashiko.

There was some ball-dropping with this bug.  Shardul posted a fix last
year:

https://lore.kernel.org/20251204142625.1763372-1-shardul.b@mpiricsoftware.com

various ackings happened, suggestions made, other fixes developed, etc.
I guess Shardul gave up and went away, who could blame.

I'll add all this to my backlog pile and shall figure something out.


