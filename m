Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CD4C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 05:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD896B0088; Wed, 15 Jul 2026 01:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EC86B0095; Wed, 15 Jul 2026 01:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950596B0096; Wed, 15 Jul 2026 01:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 707726B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:08:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D34018057B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:51 +0000 (UTC)
X-FDA: 84989831262.17.D581A7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3C17D40002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTCyj648;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784092130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzYuCV5uNPBNgG8UwLvTze/n4tjKM9lyxr5rl5XEZXc=;
	b=tB31eXIORIOT5kQEB96gucGSEKzCpjIyze20kRqwUN6LdQwZ6FtqwYHdH90SBOQ6iTp5dt
	VKCEp9ENGu/7YtKiJdPsKBFiRRte5CqCqoBnL3EXRJFsU+wMQCcOAmjfzDfWE0AgA17gby
	b9JVH790PVReF0u6sDFtsHTWqfWYixs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTCyj648;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784092130;
	b=ZVbV/FS8pNDDpo/VRu+8Zo5m9CkxoGJ/5zZ2bebIo2myXD2r32I0W9rMuotFprXRnsZXvr
	u7d7G98+cEZ5P1yyQDlSP1X+J5rGSTUb8LyjejNthM+PFn/j2keftXj45CBDuAZ9JKnrTp
	RyAjOAMH+eW3GYD+Vgk/niW37ecZaIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6994243A4E;
	Wed, 15 Jul 2026 05:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24141F000E9;
	Wed, 15 Jul 2026 05:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784092129;
	bh=XzYuCV5uNPBNgG8UwLvTze/n4tjKM9lyxr5rl5XEZXc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=fTCyj648Aq1McQIitI0Z2l0OH/LkG5rBJzoqdsYEpSAJq89QJdfFD1q1Uf+bC/ZTh
	 GGBhuj4oTXV6IHFGZj9TVdqptwOTCEOxtQiSwA3tO1BpWk3vMry5jPU3XQoUUjgDw6
	 fXlrjihnkv0qAaBwU5IAzstoNHU7+nkXXKBwL8dxKlzICEwlqG0VDvFh2+Mc977Lrl
	 7+BOcqAI53ldAztLKhCKAZXJmHOctnfe98tH8jceD3sUNRIPpIMD7qTkkcTdqDE+4Q
	 Zw6dpqxCu1XK54vB3EHnzRmHJ60saAxEEH4k5jeIdHnC6QxFOzKu838I6DuAbk7dw0
	 m7pKGgbMwsdWA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/17] mm/sparse: drop power-of-2 size requirement for
 struct mem_section
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
 muchun.song@linux.dev
In-Reply-To: <20260702093821.2740183-2-songmuchun@bytedance.com>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-2-songmuchun@bytedance.com>
Date: Wed, 15 Jul 2026 08:08:42 +0300
Message-Id: <178409212283.638342.3417101488436415116.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: cz4cociqzhcm5c7ssb5b5jdn5rbfox8n
X-Rspamd-Queue-Id: 3C17D40002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784092130-824731
X-HE-Meta: U2FsdGVkX18GwG0tW8TrB9df/yJRS8AQfAbPAOHH0u98kwctAksJ1Q5YKe1eqLBZQDN5t9X1F7CyySQr2NOijG5NMLqXqHzng197UEIq/LOTKH8kQsP3W703Q760WGN6PG1wWqh87iha3YJ76QUmi7UJPeCs2XDSfWAdY2XdB3EslUJmsPjO94udMQBDB//fblF7CID0uAVvRMeDuHTSbZd6zvNRJbokfLDHiaDVEa+DKYR3/mTMXiE5d2CaN/EsP79QzEu/YVqBgpHmU7KB0o5MQ4PbBqhx3v4Hh6MP3M2q9z+7UFQMUa9EpRXNsnxb1qVDlIb0Dk/gSpFde/uMTcd7I9eqtWhYkNiG6IHu9ioDuXMOxmfVaJRLryC/RZrm1J5aba/Pp0PlEEsjxvc+2UynAQ3IGa+9bf/jKQYnTML5GK4roEs0VEzv0aFM6x8EiMtl4QghyvjAjQWOR7rPXYRCfWqQgUAigUOaTHUlxjqZMl+oZq3Cgold/V59QSd3XY+5FU9L1XFLgHdhSlxsqYsbazOK+BCypV1bZpg2fBhnVwU7C6HOiB1efpmcQVJNp93ya45biUrMljSaToK8PpYoz7VuTqfatzx7ZLvgZVFZY7zKJZ5aflB5WFCie2le0KwcrlM3zT1cTp/QtzsBWrCk0No41j2tySasMGeZtErBxEBbeGJE8mCiks1Vnci4epVrz92j119Kh2RQxh9omFX++p9kwwtMopvK/jtvjQJaH7RfHM0M3cZLaM6drOhJcb1A9fKK0U3LCu3jsKlvJgV7MyAzC+VmMsrnx4JC9bKVtxZorPNdUXY6p7FXXhfxYeKTjCzGOJ6r1ICwA0fucrN9LXtz1EhL2VqCOd277x2tSdAOwTGls2Kz361wBndUCKmmZIWTCYwDIb0iGler0GuhvJczxOxX/utrz4+McqWiWVc2iRYxlkCJY7tWWPxp98nHbu/kplRhVfSlnPd
 wxyf+ESQ
 FqkMiNTp/DM0dyyQZSt/BDofbzwW27SFvNezVYqKJY3OrDNnvTsEu2chaV446TovUbm/4l+f8/5qZgomxwdbV4FEKcJcc5fDbJKrdiYYV24SCATnIF5SFjcYr3OBvu7KTxLjOX3hJUsO9YHkspPrAbBxLo+ldG+jpuzjMFlq2JodjSmOtKXfmW1aUIBCNLZ7V58u2hjPrJnPeEruvY8h6Mmv/Qml6cFJ0EDx9S2QDF50DtdqJI3nKJmiXeccfIsWo3FxG/TOcI7BfDxCU8jiK3xjha/7BmZbhwIDQJszWA7CIKWxdUx/nhObBfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Jul 2026 17:38:05 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> struct mem_section is currently forced to a power-of-2 size so the
> section-to-root lookup can use a mask instead of a modulo.
> 
> That requirement adds configuration-dependent padding, especially with
> CONFIG_PAGE_EXTENSION, just to preserve the lookup scheme.
> 
> Drop the constraint and use a plain modulo for the lookup instead. The
> divisor is constant, so the generated code remains cheap while avoiding
> the extra padding. It also removes an unnecessary layout constraint
> from the type.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


