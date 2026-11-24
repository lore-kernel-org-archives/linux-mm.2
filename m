Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AD5606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ep6nvdu1
Received: by kanga.kvack.org (Postfix)
	id 307846B0641; Tue, 24 Nov 2026 03:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8186B0643; Tue, 24 Nov 2026 03:34:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5086B0644; Tue, 24 Nov 2026 03:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F09C46B0641
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:34:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E14D5A0B22
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:34:20 +0000 (UTC)
X-FDA: 85469350680.16.F4B3DD2
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8F5C100002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:34:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ep6nvdu1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795509259;
	b=fdM3hV9FJ+5gE6fQ2tkdhXufzAgtVZEfJa4btN9bcUNzfCM3QirIALPu2WTPThMklHJu6T
	/9VqZTHb6ZPdLJNbpQY17ckKzalxGuv/nFaVqdhKZdrhYYLp4HNPKtywZl4lBnLw17mhJI
	LL3NEUosmXZnboWOD2sRWwzSX5m0DFY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795509259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7WfdCMMRCOuD5ycNmdQ5yCGlPPSWFzHbHH6Cd/QbH0=;
	b=3Wah0gXYq5ED053Uhj1h5Umvs8BW1wpugyeVp7PLDnVGGe8Pjx4VJgrxQ8Ts59ZgsyN7db
	8lx9RYWumbkpCMO0Ub+EaCqOUfpV24ljQxgbqfhmCu53oGvIJV3QFQT5Leavv2zxVoQYZs
	XDPXZ5cgMLzFGHuiw+u4hLBjJ+A1i7E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ep6nvdu1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qoHhrk9Sl3EhFD+MHGeYcSOXmqUjqg0h5hTx5ClbPdc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795509257; v=1; x=1796114057;
 b=ep6nvdu125Y+SWS4EygrYlF4UkJIQhlLmKCYXAu3v3dUyX+iffpoS77NN+4FiO+Whf4sEtza
 jw9kNX2wENhqiuiAMJtgDSKy6YrR2M5QN3rU4pzW/v2kIgf2BQ9kMEWPDUFm4+E9FVJiaujvJlL
 8sGNpNa7LG0MnkFf0qZYs4Vo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 23c9c215f8cde8b8;
	Tue, 24 Nov 2026 08:34:17 +0000
X-Mizu-Trace-ID: 23c9c215f8cde8b8
X-Migadu-Flow: FLOW_OUT
Message-ID: <d5b7be4a-0137-4fe7-88ef-5cbcc23d0855@linux.dev>
Date: Tue, 24 Nov 2026 16:34:08 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Docs/mm: fix stale split page table lock references
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)"
 <david@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
References: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A8F5C100002
X-Stat-Signature: hbp6pqdzm43m93wypjpnr8o8heo6zbjq
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795509258-767915
X-HE-Meta: U2FsdGVkX1+HsSEcxHJAvXNcCaq95oVudZFk81rQWIfVE16x/4FNWmZbMcPFAUpZf8Zc012wFDvGm4dDDAYfJsl+J1sMzwAF23OvxJnSDZIYcfomBXQAQbPyChpxuUOELWJckKQwJcCPqfzULJECHoBgkSkNXQ5hS+rFM0AFTsmFc+iq0o4y1ecqckjJlJ9QRmbg1bvXa3JYV/9pmll+YPY0NHX0QaUE0SkRI3Vk51QgzFHJw9+M4FhupKiZpIKM9r/fftx6jpxmBvXm1h7dZBzZivIafpJUyIGDu7/glVrK42qf264r/NGPDxxhNtjgwJ3ATzOb04hb/gkMf7t6uSywDCPk2wMfBSGzVNW+/SH9q+FcLeh8y69GKTIzwwKNOGyA2nWmz3C679/WJxhUj06PG4tLMQJoK3kv0b76dfqDVAgmo9jYfGQ/K9wWXvRfgrvgPhXsgRxeEJr5JPFTi2LTcqWXQ/j8VetVAnfBdr4zyq9GE27jV6lTpQU17t/6WIKA3j326oK9I+Z6Gepio6TUTLfLxgqmeAMwrf+e+Fz5H+BHazzoFETD8ajV9GYPBfFRF8Y1wsAfeIWWEtoRnT41RzZbO0/ZPrjfhsmDE9qXQaouQ7fEnaMQAqx3J+HOD0CHkBpUVe0x8Mgn9zfJVKZ2YM6hqMGnQGFgMBA0CNlVEqJHkOY5NMEn6PBOFz/MmlsBJpWhSj524Xn9yYkw+r3DGQD0C6TlT5ceG5jyKTwKfz7OEpcqn6HEnMgGqNKBJIBQAYUzQKJX5EGijWOV641JHlDa+kkX5rzGeSdlUYfaiKfCfyyTvyhZ0ReOCqcssavEpcNVO3+vi+htoKATRYmHsbzEw6S387dv+G8cG6KudMjUHPiM8Lr6EELmIMPsFe8Q0gpC2RbfeEXrZ3FKKPdcKNl0M0AxKZxK2FKjt8kp+iOpcrwHrouwschpHDAXp2B5VbcjZaC+aTk2+9f
 KisWx4jN
 nB4IF9Riv9ibVK+a2QaK0E7wWkBdFBzmMdQE0vyS0m0JOtngbMfaUdXcQsr4rjhHUb82ORXer0lC4tEzO4wfNtxyk38ij6TpeJSHIN0AdSFCeJ/BZrJyuesGtkFx3jtyr2z2sDsAl5Lt99BnrCaXatW1mm8ro6fJjq3q51CjhfYbJ58TOARtCIjc39lQe6af1ZG6QVBC7dMTrmhVdAeC8wnBUM3NsCEUi0O+GxSspL50pOQ29/Ld/tiVUQkSP0T0bujQG2CTTAr71And/SWQ61DlnjBL8BQL1iAJEdTwWn2B6jybGAUxKD63G+zY3uUldLZBjzbuL3soR15hYumRPzZryaomyy2O2cf2gowiT+hLIZCDP+xwlVF+1jfOtT2iD6dpjvCoQeaT6RPyL7J2v6XwHhUAJNGH3vnfNGaeNMuweqhKhIWkRHUXH9b5LlNba7vDkUTLpOgEwh5CSVxZYq02oA8AJ8SR9Gc+5GbmSNCwnI8/voWneYT6td8KLNb5kPd6EX4YIDe7MubZF8ByclhcGKsIi5Xg9PdTP1WMqwvMq6322REdJfnKdh2ESWrdiXW4a3SMRfkEUZr6Qkz0yXU9VDMRBvGOyTpykSIuxU8oMKi9As7EXF2fkLmjWYmDBUvX7LzSEZKt8uNtOBMLIsVJ/9gdgpgmx+Zz+6Yc1qY3DmN7nveNBdaSoQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/23/26 11:09 AM, zhaozhengzhuo wrote:
> The USE_SPLIT_PTE_PTLOCKS and USE_SPLIT_PMD_PTLOCKS macros were turned
> into Kconfig options, and CONFIG_SPLIT_PTLOCK_CPUS was replaced, but two
> Documentation/mm files still refer to the old names.
> 
> Update both references.  Point readers to mm/Kconfig for the dependencies
> instead of restating information that can become stale.
> 
> Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> ---
> Changes in v2:
>   - Point to mm/Kconfig instead of restating SPLIT_PTE_PTLOCKS dependencies,
>     as suggested by David.
> 
>   Documentation/mm/process_addrs.rst         | 2 +-
>   Documentation/mm/split_page_table_lock.rst | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

