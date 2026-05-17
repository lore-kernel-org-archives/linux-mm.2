Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D697CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 08:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819966B0088; Sun, 17 May 2026 04:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB286B008C; Sun, 17 May 2026 04:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0E46B0092; Sun, 17 May 2026 04:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F54C6B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 04:45:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0684C2162
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:45:37 +0000 (UTC)
X-FDA: 84776278314.02.49CEBB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4023B140005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:45:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GaCdPL4f;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779007536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV3jgbyH9XBcRPcM33so+RcELZzU2CRVJYi7aLJHaXs=;
	b=cgK/iV4NrEuoLbIrwbwy7WBU4RqcfAgN+XOLqmGeMpf1Fdl8UJptaqcG5wAq9yJmi4AdHn
	vm/WFtD5Oy2hxR+itXjDQzzSVC8+jG772dRlQUoT3CN6gQaJ7WVA1V4wIHnXNgzk5xXaRg
	r6atonczGYzjB6nlGidJk4doltYuLgI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779007536; a=rsa-sha256;
	cv=none;
	b=mzBAQfGNK1j1GoVzLFOP4jJkGXvxggVbIF8+181ywBapPd2yNmV2kyxWZXQaQgo5AfEkED
	NsYWDbLeZcZlCWIgQptRQIgYT4w322viviMt2aLT6jdo/3XXRQMRkV/xLzq0fFriuIf1PH
	16t41bzGMNbQZBbljmNfmAHQn6jkDk8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GaCdPL4f;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9256E60141;
	Sun, 17 May 2026 08:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EB8C2BCC9;
	Sun, 17 May 2026 08:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779007535;
	bh=LVzeahNDHZ1WvAmPSQ8GPJ8xKeGAguvAQRUr2DznCm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GaCdPL4fOfAkwVPsyjkMALDCbw2efJ9jdDmWVk6urIWoAhsRIpVsbYQcYBxwmwZ1Z
	 ofKhSjKK7d2I6+NtrQxKNccw8MlYhKWdmtyW7vW+cpdKxWCV9YCI/dErQEiDSinBF+
	 cuSbEXZd6WkNvLuQkf5SkDUVzozx83ZSP73oOrmtjz2+jmi14cz8QU2/GP7h7v92Xz
	 hvyU/GXrUf1hpT6HHRAVY6Dvx1bgORLRJWJL+kQLWeeED/FvHWK94EZlWsQ784hZ+8
	 OM2rCDE4V8yPdYxugG36yJb8Xf3kvCdoeZ+zFErIMKyxvlc2hyWkPjpNA+RCvEjwPq
	 WO3HEVNTXABVQ==
Date: Sun, 17 May 2026 11:45:26 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sakurai Shun <ssh1326@icloud.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] design: fix typos in design.rst
Message-ID: <agmAJnMaRyyd-MEc@kernel.org>
References: <20260517073433.3015-1-ssh1326@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517073433.3015-1-ssh1326@icloud.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4023B140005
X-Stat-Signature: hcm31ejtqynnrd4cmhddipzfk5qbwm45
X-Rspam-User: 
X-HE-Tag: 1779007536-882021
X-HE-Meta: U2FsdGVkX1/TpwscrQCyFwUZa8pzGBY6wEmno+iIdCiZYR2/jlr5LscofOxh0M9iLZ9WO4c5TzTJSHM8jSxOcjy1Xj99aOGvoBD5kUOKKHaBNQL2TrwbnHQzLEGBnNZumwSlQw60DUuoQNanqT8Xh9fEzKhLiNRqeDR7Ekk6NPhyyCljnMflwZM5ddotCH5CJ6d2IZXob0JdorDpRq5rTxsCSUlVFOine6oI44OIYIdkggLRTur7vVvvWdRxH2emi0uiVn3ZYjsooyF5j//c3pGMjiaC5FShMe4Lopw2cq6og2ow+LdJTP0cPdbLLXKegdGlgv7LWIIBigaRu+pfwChdllqX17TnBFjByau84avDFVLfsHxq8yqnJdRqMPZ2tkyxPQ/rz01GggGmF65q7a9L1va6ZibWv45a2staogiMU03rWSJNF3JaI792sLNXLDT+QicGq2B8N3sfAsmYeUatO0lwTqfYQ9TYuApZHZqw9ecmy2dopI3GBAgNIXZoMhCsN9ODCHt+lUuaCXLyQN+DOtyhoMQYjSvndxSUEouhqx80rCCQmC3t8QygEJ12o6Gia0ezNWNav0sBs3f+2U8V4vb2GMv+vib3Wj72xBWL2sSKHZSopMCoYdCQmsJ+vWVSqZeI9PRw1kI1CzLMCpawV+Lshbw8VNLYn0iuzOzNk5bIGzK5I6BH35ebroFmEpfZf5/NjmhwN9/LPZEB0GZGwapt5ncPwUbSalWYmZXDjCT4RmXYn1ZoxW9XSsLoMMP6eujkpuWVRkHcW2XXo6e4NXiuZpzco567cO5RRtYn2+/gPkVyQpElYkfqNI4V5vYP+D63QYjuUnCAcfOuGk8NWjb60LJxENqiCUNS/f6KuKg0oQffjTx8Hvhbm8LlxgoVbG9OMTl6ZuCVNtFQfhENykkycHjZAr3JQqmbgfqcdkymA6fMFB/2E7z0uR3YvNdTTdTcuY+a/Wj/q36
 a/TQie/P
 uZhM8mCyWVP+pnnrt8D+/9wBuDSh1nJpJmxOlAaqY+vUsK4aGzdyDL2ydA2C82N92pf73FBNMONeRWPrMv5y3vaxI3ASnd+9/uXiGQUzq5uONby4HxlsCbSQMQ9sbpHHR4fDp/b/b6TUXlurqfpiz/8VY6G1aLdPyAifTTnxU7R2UtUsgjlJuRFAdwisqCR6R4J7HO5Hy1480cHAa1uF/4GbbQeks5eCQid+JQI6TGOi8BOGKgmLNzBRpWch3RcJV7lmrsNcB+F7XJsvF2HXvq8RlUk64epnsSlNkn6FSC7uRzPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, May 17, 2026 at 04:34:26PM +0900, Sakurai Shun wrote:
> Subject: [PATCH v2 RESEND] design: fix typos in design.rst

Please use more descriptive prefix next time, like SJ suggested
Docs/mm/damon/design

"design" is too vague and gives zero clues about what subsystem it is.

> L140: "unsinged" -> "unsigned"
> L371: "sampleing" -> "sampling"
> L387: "multipled" -> "multiplied"
> 
> Signed-off-by: Sakurai Shun <ssh1326@icloud.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/mm/damon/design.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

-- 
Sincerely yours,
Mike.

