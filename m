Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BB2C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AB36B0099; Tue, 25 Aug 2026 05:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4317F6B009B; Tue, 25 Aug 2026 05:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321046B009D; Tue, 25 Aug 2026 05:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 119326B0099
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:31:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 439D61A0383
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:31:02 +0000 (UTC)
X-FDA: 85139272764.23.4707A2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 89ED2180010
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:31:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AisOGoeM;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787650260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RBv9nbQN0qPNMpdJLaQMOcwKDAd9xBQUKF5Y8V7eBs=;
	b=frFkS2ak//Sw+ECfnfmMf6hVAOQgu7z2wSCuaTeIBbqrUa8pWVeUnSH1GELZi/7MCw2s6n
	c1wcuOIBGCuiC7YQ4a9hiyjSg0j+PDkJe69jDsmM7Ft0iiZyYEGJQ/clyDLs8XDJzDqBRX
	9ZDBlRY6ihm0CFjDR2l7CTTbObR90cs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AisOGoeM;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787650260;
	b=HDKlfdqXnG2L15Mc646ZH98GFZ7muRUi5dryLQHV4lQv2XDYbnUk1WeJnERrsBVolY3pvp
	Z2onzH47aAeDStn0YrZKuGtAUtCY3QvM2bnVFKyImG0ZvLQltZcCkThE9x+qsXxR4SKyey
	nd5tedJ9KSZJxl/dDJngVin5yACgP+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D6B4C43CB2;
	Tue, 25 Aug 2026 09:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751211F000E9;
	Tue, 25 Aug 2026 09:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787650259;
	bh=9RBv9nbQN0qPNMpdJLaQMOcwKDAd9xBQUKF5Y8V7eBs=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=AisOGoeMMs0vMguYVQI1NK8iFHkg86WzsgKc5Ub8xxEL4OuJMqorDRtQ/XP5+OoW3
	 dI4Ac821yhtztStv7qFA9vInolcQHrgDeSmh9HFzL024bNhF2ZRN/9fkl+lNTXYJO/
	 Gzba4FozEzo8BjMA6plxVRKDsfOwcSQedcQV9v5Wb3qlhr2F/SrtS5ZY0sX5xmsZ10
	 Dk9euNeewdcIJpFqkuPfFJ/osTdjsvSSLZOFU+tpWCCu0KxFCIDp9Nfuq1XpbXFTZm
	 iXsA9UNF0nyZ9piK2LtUfWdRcyGyRLCwTWRGH/3A2fjvcxjfcpv/lY7LcJ0BCBuLCd
	 jWKd8zkFzU2Fg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 08/17] mm/sparse-vmemmap: support section-based
 vmemmap optimization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260825084608.47437-9-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-9-songmuchun@bytedance.com>
Date: Tue, 25 Aug 2026 12:30:45 +0300
Message-Id: <178765024512.3691569.2042347193723132995.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: h4586unarrkqqy5ad78qsjes5cexp96o
X-Rspamd-Queue-Id: 89ED2180010
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787650260-796294
X-HE-Meta: U2FsdGVkX18iplHmkSHv4HKbgltsWm+p6S74dWx+oSOl0q0Q0wk7od7Gv5sT6DiFBdC/dHWrO7FZWqzDoRvWwaEjEEA3Qh0C3VTwaIOytIsBqxJz9gu4qYzn9MQXwh6VY/8RQRHeqaEGihaN902XgDN6Hlo/ComS1VZywMjX4TTOiuyOrdNw7Nuv1enSLkXM8M/oUJVhO3wjWlpypQFX5X6Sv5jHm68wECTbtorX32WKl5mvASJC6xcqNHT/OtNRQm6CE2fyzL8LsLW0iYNGCNS2JAJaQOosRR1u2oaDsNf8obQXxhg9L/Ia0MpF03Q67awG0ZHZYtK3j6LcflUlyD3qP0GOCYw0xvfxQDiXeyYrELIr6a4NJ/uMlbgqajdmGQeUz7lW4FmTzpNGnhNh0ov4r0Q2GA51n3ZM11zsANnT3vHSPV/uHqBSuoVzSeBrm8xo+FtzlGw7/rM3iwTSzi8W2kodUMF9bYW0Zhp6FG9QwWtf8sRuIC0rqInlFBF6Po4tSJYflL5h5pt23MPwMHHVg81WhaB0iYZYXj1v/GuMQwtMgjhkYghVdVcHFpSGrQs9CGJzzBydVHFtIDKZCYIWo1zMPg18XJg4/mjthrDwhzT3tTZGbsRyIpagY1UMxb2JVMbOC69Fk7Rlvkoyml1Zeit9qhbueAOXFq6UvEBM+QZtw+e5iqbmIXPLX4psYYWjr3uLgc+mtGvY6UUGbxAinK9vfSRXGSWFaHg4cnBM3lpHVmY3kqoWhtZgngonpFFfPHlxz94kWP+8v2y3CeHfw+GwUw+HI7Z/nZ3o8xGZje3GXC6jLFJRrXFdghcu61Y9/Gl+rPCfjurwFriD/XnaZrIU+7w+NvMKtqgawrhmUKTjUiwYZZsVeQSvkKMzBQPqx4lZjRcxH4RRzcHYxd4vj31MQ3B3pnhSIR4wDUA3QOdPJgixMAo8SFqTQamsM7kYXYUOCH28nW27jiF
 Bq4YAElC
 6a1d908Aarq7RYVjLbCb8R4FqxQASuzE67yqfuWp8eLPlswfny3qyfCvub01T+PmqdGmNzBfnm7QQ4N9Jg9WJIUBxIfFbN9kmywHhk8wysL1J3y5ynJUaeG2MzDjFsh1/Hy3BrKr0L5EYDcD0RSbT3gig92Jhq7HKhL92A3n1KopZxsri7mzJt34uW9Rkn0q6NCQpzqKOG/TlJqcRRAvWb3Zhqk4tGnhN5Z1g1pLDfM/MFMFobpG9fKa61W6nzSok+xF6OutxnGPmwZQN39GtiFCqRW+7O3OO2IrO1vhPrLFzrc4+++BJsN5Axulrke7ImhyzYSK1AWGrBhS6LiqeYwnpjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 16:45:59 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Teach sparse-vmemmap population code to use the compound page order
> when deciding whether a vmemmap page can be optimized.
> 
> With this information, the common sparse-vmemmap population path can
> allocate or reuse shared tail vmemmap pages directly instead of relying
> on HugeTLB-specific handling.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


