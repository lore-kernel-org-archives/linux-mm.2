Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65585D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A8C6B0005; Tue, 16 Dec 2025 01:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7016B0089; Tue, 16 Dec 2025 01:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6D16B008A; Tue, 16 Dec 2025 01:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 982E96B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:15:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D85F1603FB
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:15:44 +0000 (UTC)
X-FDA: 84224323008.13.FAA2495
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 932C84000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:15:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gq8h3iTc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765865742; a=rsa-sha256;
	cv=none;
	b=iCx1sGIW5ZCNKZjN1x9uebM1xc5WSYeONj1cQLl0nfJEL40X3jcU478r9fVX/9Fil55FKK
	SF30V1gDN0VkYDBfVnxGwZep20vzBnyfe4GMlXlUIhfQ14vkvSsJ8POqLewSUg3zezPUgR
	nXT0BX53pFwieXoEQh3UJgKoGRjxcI8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gq8h3iTc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765865742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/qoN5qDYTUtQ1d6A9mOIi81CaQpLBjofgeo0xn/aUc=;
	b=zvbz1u1pvmZxdwWaIFGc0ZOAB4MqHX20l824AEM/8kqbms2RybsW1YaOYLUA/U30agXH3l
	wklqKfNkJtKTIwrgaD3zff/sJkCXgAHC1TMdWtnYD7oG6Yh61R5iGkAQzbMAgbZDxQQ56F
	7bwIxVmxTiffMmeyAb5764VUl4Am098=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A3BB43CD0;
	Tue, 16 Dec 2025 06:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8EAC4CEF1;
	Tue, 16 Dec 2025 06:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765865741;
	bh=wvdO8w2J02Po7liRduRPemBeLA5dbDMtI1kfUlC3tGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gq8h3iTcRCuxYUusO3Y4fB/mnBtIQknYCrU2rFzXNytVnEWECHtviN35iqkOiidF/
	 rStM91yoSvzl5uFcGdDwt4saGuOZK1cCRTuvNeHDQwTJXlJbBqt5AzyELBPtN0QauO
	 dW2ocJU0ZI7Zo/E9P42D04VrGth6doxyIrsvVAY0Mqul1pUudP+UBzWnxXUpHuN3AL
	 Nzdr2VFTZ7+jA+/gS/ao9kiQ4bXUj+eHejLOax4AzWqnHl5ETW3ZiiX/nKrc8knrGn
	 KltTV0NZaod/D5WOSiR6UZKSS+QiSA8EMAtBBTV8Q+ac8D+QyA+Gbt6iZNEdvhmq4v
	 S97es6G/c5t2A==
Date: Tue, 16 Dec 2025 08:15:31 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Wake Liu <wakel@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] selftests/mm: Fix thread state check in uffd-unit-tests
Message-ID: <aUD5A/jNwW1g7wDJ@kernel.org>
References: <20251210091408.3781445-1-wakel@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210091408.3781445-1-wakel@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 932C84000C
X-Rspamd-Server: rspam10
X-Stat-Signature: 5xodx3dfnyx5cs7uycjf7uxd96k436ri
X-HE-Tag: 1765865742-554058
X-HE-Meta: U2FsdGVkX18hB2/rFDdDDGkmSi8tmZoHXfoT08zMSEDLqkyFJthJgWPtunNKOGPDmSTrPuFoVKqoJlypcT5ioBmhfsjP9CzZWUMhWtUtkryb2R6E6Sj+6p+0LbTkJVjQSK5MpkLTLL3sUnNHzyTp9OkSqsDHLwSqEHK8md6QMrGSA/bP+silrvKbTlYswIMPgHi7Oha9jGAcBC0iAL6zR5Z1YUEI/0bHnvFZ8uJOYIf4Iyy7e080Qy3X/+7/+8aF8NBd7mo1azymKDj4QeR2336c/r0qGXtI1yatlKW+WKOC3hug79ucyik0jdxFeayK24b8Hm2oRnU9+1gZcEap+0f9/X8LdhY+H9+1sYofZAfIh1I4rxSOlY6B7mrI79kTJTdb8J2nN6pkYX7eIv3AlsTUTY7LH+74mvXoATAcrbBOlsItm+HULKNlpnq6HxkP4Hd43wfQHDKM8oan8WIdXy2iPVGeCEFsBI7R+F0JwjibdaGPNYjZ+UATu2f4eU+cdCs6y6iI9wFA4QL1CUQ2G4E7f8xFAJvenNS0izOsH/g/62Im7G6W4xCCUNpOFwgfiCqK3zUrebo5jRpD0evfhWzSzY0/FbdLlQIAAjdmqJCPowQZXdOXJchw6NX4Pn95UCr1NIDemOvE8Xi1q8j53Q/aQjAe5iC83LBg40WuaFTRQnMhSAgMChT07NYY/MdpFM63ecQsDWPB2bCnuk5OirqFcCdrpB+aygAznV8ORKnJj3+cL72vv7n0a9sCPIzxecdtUNL8EefCCRKzufGRVHfUL5ZKXAo+XU0/fZEL8JlAYZWlvmu5KDNlPLOy/mGmbg3fCMe5BKCjcTjCoSXvtXZG3NJzd456MJqL+pXkNIas4dRgBm3i5Ywvfnug7Xu0bR3MY93ObAACvGeuxftX7K00MHITTvOJZNKl3FjzGZAVkf3Von0ekbbFz2xqZW5oZFS1+qXn6BCoeEVhrIE
 Hv0m0O7R
 cJKTK0UX1pCCrTy5wr6FsyqBOWBUIdRDKrVSWDUfPzu5iBzWSgOIghVhFXOuXl4ahkvvZpDLdiLQ27rfxDMSbvfEbudm7CtvkWiGE0FvlLnbehAeDoSNt8MR+mt/bQQxxo6U/tvlPM02o8zvZcZ2/IEatwz0YhLOi84f2wzfDC+RRnQU5W4dzPe+a7uqhbv2UaiDVwI4KYhIb9Kwb0ndgiUDNdMLEVA24awhieBzv2vbpJeZ98tG7SoEpg65f5pEOUaT9gqcd54Z3POEb7QzDSimYyofr3HfJsSOeoCFg5vTYw1iOkgJi1HRnVnzcEPz8wJgdaThE847ssZN+akUUaIMCW9yKHNbyFC6yX1fvfu9BUJkR0CmRiwCVjllgRTf11tIR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 05:14:08PM +0800, Wake Liu wrote:
> In the thread_state_get() function, the logic to find the thread's state
> character was using `sizeof(header) - 1` to calculate the offset from
> the "State:\t" string.
> 
> The `header` variable is a `const char *` pointer. `sizeof()` on a
> pointer returns the size of the pointer itself, not the length of the
> string literal it points to. This makes the code's behavior dependent
> on the architecture's pointer size.
> 
> This bug was identified on a 32-bit ARM build (`gsi_tv_arm`) for
> Android, running on an ARMv8-based device, compiled with Clang 19.0.1.
> 
> On this 32-bit architecture, `sizeof(char *)` is 4. The expression
> `sizeof(header) - 1` resulted in an incorrect offset of 3, causing the
> test to read the wrong character from `/proc/[tid]/status` and fail.
> 
> On 64-bit architectures, `sizeof(char *)` is 8, so the expression
> coincidentally evaluates to 7, which matches the length of "State:\t".
> This is why the bug likely remained hidden on 64-bit builds.
> 
> To fix this and make the code portable and correct across all
> architectures, this patch replaces `sizeof(header) - 1` with
> `strlen(header)`. The `strlen()` function correctly calculates the
> string's length, ensuring the correct offset is always used.
> 
> Signed-off-by: Wake Liu <wakel@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index f4807242c5b2..6f5e404a446c 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -1317,7 +1317,7 @@ static thread_state thread_state_get(pid_t tid)
>  		p = strstr(tmp, header);
>  		if (p) {
>  			/* For example, "State:\tD (disk sleep)" */
> -			c = *(p + sizeof(header) - 1);
> +			c = *(p + strlen(header));
>  			return c == 'D' ?
>  			    THR_STATE_UNINTERRUPTIBLE : THR_STATE_UNKNOWN;
>  		}
> -- 
> 2.52.0.223.gf5cc29aaa4-goog
> 

-- 
Sincerely yours,
Mike.

