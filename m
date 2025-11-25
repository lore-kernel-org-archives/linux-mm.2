Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE5DD0E6EE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8876D6B0012; Tue, 25 Nov 2025 08:59:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85EC26B008A; Tue, 25 Nov 2025 08:59:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79BE06B008C; Tue, 25 Nov 2025 08:59:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0BA6B0012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21E7116014A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:59:47 +0000 (UTC)
X-FDA: 84149287614.21.DE62F74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 631691C0004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:59:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AUYHZp7q;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764079185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6WUpsAE4DbwkYT+GcvGTSSw7MPoqI4hU0iG5qDxcBs=;
	b=7gjlALnG7Q9PDbpWoFWMC9zAinI8Ym9QDKdemb/su+sohrUdwHgvm6dAaSCccmjSB7HYMR
	98F9rLbC1NxHXnLIVSpEmZMGrR2zJUNOFqj9G87do7/3ZTJRbNvqoCu/od+243w5dd+uWA
	AKMfefJ4GVqBBfeeSMMIcRoEhsEIMa4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AUYHZp7q;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764079185; a=rsa-sha256;
	cv=none;
	b=0jBgPFvFIPBcBcFs/r795L3XAO0fYOKVTxKRju6a1HTyRG0VKqyG1dEg3hH2u2I3bS91yo
	27NzzpHtZLg50YEBWmPlG5oIkSIdXI+wJ/FLgeVaABkZHgZQWOtoE71LqwsABQvXToTx9G
	AM1QirloSNDjPxrv2/QDKbG3FmkM8KI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFC616011E;
	Tue, 25 Nov 2025 13:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ED6C19422;
	Tue, 25 Nov 2025 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764079184;
	bh=HU2cQmh287jRL3SGkngKFjVwSQS8Ul6W18amQuuzAdI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AUYHZp7quVDqEXVNM4aYlyQu0Ic4NPFrB1+cGdaIdVG0m+wV/6UNvoBHY7g73cjb4
	 WwdxsoQCrrJUPqkoQKJN+wVDzYgyYCA4dxAwe5BgX4Q+vZU975J1SIGJwZ5KkWialu
	 uaXIjMQMdIegXra1cCgjfum6Mi+yQgOXecr5fqufn0LBW93LZZaPr9lUMdphMTZM3d
	 YJvu1hTOizDo+nLJ0a3GyU93eg2SC/KbWV/rPXsWIAQnCrDJzzFEueH/WNLYBs18+P
	 Kq2gys7mrKUQAtDoM5LgWg5KF5MJAuKK5XrQNi5ykK1wa/IFYrXNSAxvACpB1j+hzK
	 TbjlOCzPbsLAg==
Message-ID: <a291a55b-8671-422c-bbe0-f11439c5b41b@kernel.org>
Date: Tue, 25 Nov 2025 14:59:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add Mike Rapoport as maintainer for
 userfaultfd
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251125132908.847055-1-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251125132908.847055-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 631691C0004
X-Stat-Signature: qx8om9iw4e8ewoku4xm33cyq1qz9hqmb
X-Rspam-User: 
X-HE-Tag: 1764079185-635528
X-HE-Meta: U2FsdGVkX1/MLHPZCJCr8LgC7AAUqfnEA4BLj+nronzLH8ifLpJkWVG1udWZ9CI0Hw/iG6iichNlgaN0DmcYdejb7Gn4gCo75Giku7opUYNvJnGmM4Inw92wqHvO0ZEIJcjEE6LSHs59DubVmUO1sERY00P1UhfDKcWykWnTP5Y/qYLJpVYCgjiVgEs5kDrEbSRjXrdnkel0hzM8ZxfOjbiePlaADksUkLfxTkcDnjsvkpSKGWTMJXzBSk51Dd5WvgjHhGPxKAqouulMeCR/az0EPtBMWzr87V7Zy9B6GVPO09zp3IN20o5q7T2crTZDoKXS/X3Ck4AKGc5v0a7kCA9ySfWG4nyjsu1cXvdNIA5D9oovJrKKYMifObVKSRJWBspeJk3HaDyxnZEqnOphjrKo6L9jh0B4aC/rK0647lRxoiEAc9vDG8wrEC+u1IysbLUwqlGytWIH6Xzf3EDPIk5cLCBXO4+QOIGjP8y+cJX0gZwQNCtcPDplZsqa53EfJMKC3unsp/9kGil1IXD9KzdC7jWXhEpKZHKkLtVlmtIab0tWAs8wRRz4nSLbR69Do52q8hMeEbt6KV5HwHDr91wGUV8JTkaSoacugZJVsJbrUa87YoZu2+DUr4ZUEAry/PJew5bhRUEnvc4ayNH4RbHHtm6U1GxJSzJhXG0w4rs7hN7HmJwHd4tIGm7AqkZSzD7vmT9XpRhHtn9E/dhMyd61gi872+qiIWw64/IVhRotQ31cboUOuwc9Pv5eDkCUrmIULU+taiwR041BBvmXUH34soHMG1tIDmA+M9TLSGELDfcOmLTVdQrWwhzsdfcqSWnMEEa49fDjL+V/WwMpYWSgaQOz/IVy6/1WFkxfaHPaDucXUm3pxVQzjc8JruyHG5asHOSFIvbDQa5lcsRzLI6O0p/z/0AYwyM4MfFDgfu/+s/uqyZjWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 14:29, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6df89b14b521..5243fd0eca74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16547,6 +16547,7 @@ F:	tools/testing/selftests/mm/transhuge-stress.c
>   
>   MEMORY MANAGEMENT - USERFAULTFD
>   M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	Mike Rapoport <rppt@kernel.org>
>   R:	Peter Xu <peterx@redhat.com>
>   L:	linux-mm@kvack.org
>   S:	Maintained

Thanks Mike!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

