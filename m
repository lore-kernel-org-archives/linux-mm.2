Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D7B606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OzEu8UrK
Received: by kanga.kvack.org (Postfix)
	id 207876B05BD; Wed, 18 Nov 2026 11:01:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEEB6B05BF; Wed, 18 Nov 2026 11:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89906B05C0; Wed, 18 Nov 2026 11:01:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DBF96B05BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:01:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A8751207D8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:01:44 +0000 (UTC)
X-FDA: 85448705328.23.F678D95
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id D321D1C0013
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:01:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OzEu8UrK;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017702;
	b=SUB3c9AfnH38BOsh0VBlfISK+vFSLV7g3ehJax5zHS7MXGhfC1Hp9QCkoaNlDQd6bKnd5j
	2M76/BD/hYZ1t1bro9UntZ6SNyjzEIs7s/k9p+K5kcxbMs7+gMSm5J1ZztQD/zOPAWYP6B
	qY9/SM/eogCCpoGGSmYvA6VBzGfyf6g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OzEu8UrK;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LY5KnYEg62Pp1LvL2umBEQ+TtbgoJI72sal+2fBuBKo=;
	b=23Rwwxf0Ii31Es9W8UD8jCAB1P3hzA5MTg6Mcobjkdl09B2Np2yAE2DYdt2CeF+7g//zaK
	ax6L+qKQKQnLshOFzB/qGrpchJtSJeNvh4GDzI9eLmXZQDHyZ2PPWx0rCcX1qn+5gX9FFi
	TMZt4zsQlPPW5l3zzP3I2OGhbloy9LM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C135339;
	Wed, 18 Nov 2026 08:01:38 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 214843F632;
	Wed, 18 Nov 2026 08:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795017701; bh=hkXZYgY3e5AOogVCwFiSPcIssJ7tU5GIgVmY2/vcSPw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OzEu8UrKkTwbKYrQaFm5nAwdhmP5LhADhtVLtftu+FWwlL+6u/SoOj/j2smR5D+qY
	 Hm6S3yq97wLpReP+9UdpiZXJtzV/jJrmpfIL7OgwVDEA7it3Ox58btH8isXP0rCtIR
	 ptUOeqN8o0c9d5YHL/MQuUOz20H8BVhdms3QcOuQ=
Message-ID: <8cc96362-462e-4033-8e37-f9fc9128f6b0@arm.com>
Date: Wed, 18 Nov 2026 21:31:32 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_ext: remove unused page_ext_iter_get()
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Luiz Capitulino <luizcap@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D321D1C0013
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8dwu1p4raqs6yfj15iuq56e6p3wctgaf
X-Rspam-User: 
X-HE-Tag: 1795017701-443569
X-HE-Meta: U2FsdGVkX1+PzAfctzWMo8SPiIIEx2U59n3wLOShx04zlGseQyQ0St+Cuxid6ep4WqYRJJJhXJkQ5W2/dA9zwncoGIQDg757sV+p9ltY6bmJxVqSSB0A4nMHJUo54yHpIIbtzmALw/sLbOrVnNd6cJxT/V6tCildq5X2sqvej1woVRYP6/ATYeJCZLgXxEhf06dqNtWWzrRe0Ph3ukHXPaVtMSvlxqXnVXV6hjggyLKXI+IvL6vOIv9GbkvvoaJ5VHWX8W5P0IMYh+MbsBrnc6s7S286GExfc2yR1ZllrvxBcK9DSVzOtrYR8Y2brHexkyd8noVVGeBnR/9wNY92ePbn38+Tf9g1N78RhAbXf0kDcxEAZRk07Tbl5N8fY+y1EBPfzwDCndreE0koUKV31w/gAJIip1PYX/EmgmDk0jIOgV8IaFpxHXvSSVeKEk7Kc+uQ3KTx58oRH4aRhhYsBm3X8RZ9cW7P9q36jdLCV3PPLxaOCbnZxCL2/3WHDj5ab6GDB7h8/qk7SvKpBZt/k6PWKjgw8A0FwfmOCfmgYkFyo+J1qpLYNJM5vTCjJBVBIvjng5RPPT7XkH9gWAz2CE/FoU0OkAaAdwdo7We2GZaxqBXy6194Bn7ZUb6qCXa3Acs/T1qQYkxlD/5sb2br1Hw+HqllBS+m10P+OiiQh3SxWUB1emJBz9FNY+ShVzom+sms9/+ICzm3akwR0q6AQGZAE3xVVvMKdRc4Jb7ajYTG9RLCn70VFVTg9GcNs3+hieOaOr/TxHe0QjEMKiDXs0d90XMpXWkZg6IIv+e4m9zZAyNqlVLQ5n8KJjV1gIu4vRT7AaYRDuNZySWoSsgtlm7mjW3jNiP1xIleNashlLIUZuZkrSEKZW4sv10+iyerlnpqQ3YpuLEzQYprUYQoXRS68bzPbiLFfYTzFhef+vkzCOwXsJ5U4wogWcA0sCtJijUD4l/lSW6uMtk2RZA
 Y84PVcyK
 Uva8a8obOJoFvyT0v4/xMCqKCLEypE80vs9g1KewbvYcbYtdCTC6PQJXjZjx+dfrrBStsXnOkBn9jVeNwCbvX6otW77uBWtC5hHT/L3/m5EFcwkmCI7KqCCFN9S1oysDKI7lZBJCUIlaXAyxgzxt1av070awvbzXZLf9Zj4iWNRzga9lzsZDzL0RXcOah6P8fIe1W6573YrSk87QJyUQZVydN3dV9kqBabwMKFKat0uTT5wv7T/QnK1wrz/m418z7DbeQqW0lO00jCB0eB6GUAW6xy/JocnCD9mIl/tgPXtE4XuNl6rBYXwdEmJ2iyEXxMk3WLt9ktChEzRtoSBBW+8Dn9VzaYpr3DJiFWbfAkgPBVNYgDQnLnD+9zlJH5zQS5CZdWJPn7jNBNC25YnZXtY2aAKT/kzQb+Abz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 9:56 pm, Shivank Garg wrote:
> It was added in commit 9039b9096ea2 ("mm: page_ext: add an iteration API
> for page extensions") but has never had a caller.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> I found this with the kunused scripts [1], which I wrote with LLM's
> help. The v1 cover letter [2] has more details on the scripts and
> how LLM was used.
> 
> Changes in v2:
> - Split out of v1 [1], as David suggested, and based on
>   page_alloc/for-next. No changes to the patch itself.
> 
> [1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
> [2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>



>  include/linux/page_ext.h | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index 79c53ec45dfa..52a8b70c525a 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -167,17 +167,6 @@ static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
>  	return iter->page_ext;
>  }
>  
> -/**
> - * page_ext_iter_get() - Get current page extension
> - * @iter: page extension iterator.
> - *
> - * Return: NULL if no page_ext exists for this iterator.
> - */
> -static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *iter)
> -{
> -	return iter->page_ext;
> -}
> -
>  /**
>   * for_each_page_ext(): iterate through page_ext objects.
>   * @__page: the page we're interested in
> 
> ---
> base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40
> change-id: 20261109-unused-sym-page-ext-3fb8316ac777
> 
> Best regards,


