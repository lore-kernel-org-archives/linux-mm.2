Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F935C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5E16B00B1; Mon,  3 Aug 2026 09:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDD56B00B3; Mon,  3 Aug 2026 09:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710F66B00B4; Mon,  3 Aug 2026 09:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4296B00B1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:49:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F3CF80625
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:34 +0000 (UTC)
X-FDA: 85059362388.07.0893D98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 820C82000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InDa2lOl;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785747632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3TNkOT9vMabBF3bjPGTX+nNF4y4J7Wx1dBGZm5w1zk=;
	b=uyaO8T8/wz53CXdCOHQf0ei/FQ0305XBHD22BiVYZQurOjiJDtAXStzt82G0QcXangj2Ld
	tkeB15cja2VmbJt6YG62VxA8DLC2mBJdIW+SszwJMs0PCJn2Sh1XAVhoN8BZB+oRou636F
	3U/Md4xSVjyZS7RR7xrhFd249NH8I0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785747632;
	b=ZEhxU3WlM2/D4DfS1uap6BLBjMewR04Llz9UvSwg5hH+jjkF1eNzRk1JSWYKpBPUU8UsZp
	RcyQyyFVAq2kbvn59hR2++YaqrfPOQsdph3rmrr7SPdtaL6T/Qf4vQkOBnbF6XMrUTwpRM
	FSortBhY13Semp0oqFnha7WSacQGqTc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InDa2lOl;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B68E240176;
	Mon,  3 Aug 2026 09:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3871F00A3A;
	Mon,  3 Aug 2026 09:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785747631;
	bh=Z3TNkOT9vMabBF3bjPGTX+nNF4y4J7Wx1dBGZm5w1zk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=InDa2lOlOoCz52KomKj4SnDG9kXgGXUPDQlsbI3zxn3XkgfMeSbSpeppsVlo4Dy5+
	 SXPn/k1Kfg/S8YM7eDUMbEQ+ncSz6d89++WAbrULe0wxhhE6MdxtkA+QtnBDwbQ+h/
	 hA5Gv1ndYvGUwet5mAib1GiFr6bRfPLEGsiNo5sIW9GYKgnFnB5DxazpFK6Akl0Qsw
	 gTXZjJdee2MX/2V0d+sHhW77hPrf+YtgMwfIaJvjlhV/8Wpx0IWNDjRWe3eec41c1s
	 lfv4xFhjpBUaa1QQ2HyBsfkRqI+GV06EXoBspxlOYBMM37oWyEOKlGS4rj5itxrDfE
	 7s5ppJV+H3NKw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 3/6] tools/lib/mm: move hugepage_settings out of
 selftests
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260730140825.238130-4-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
 <20260730140825.238130-4-sarthak.sharma@arm.com>
Date: Mon, 03 Aug 2026 12:00:01 +0300
Message-Id: <178574760162.1561566.5251738533303087247.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: pmadx3yysjjcrfrn7bb8fcugf4du9iwn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 820C82000F
X-HE-Tag: 1785747632-151332
X-HE-Meta: U2FsdGVkX18qHEark6JHzF3/VO2mfcU65MsqKOk33Am7zjw0GI3R/qYmUDxGzq/7QxPq+ocX8qoP87ytNGbDeXOz5f+fmv5DGu6O6L5RXd3BrI5J6fTIJwj3x8Dh+YfExkD0RTK6QpYvM+SZuNtNus7EyigOr4bqdc6+fuumpz4MzWVrAsc4s4wgL85v4dHmt+vfswQqPlCJz5tSjUy20Y57LF2NBfu/M7Drh7KS5owr46pK+k9K19+05rs9dbjCx0HlTkA/86XuF1CFj2yMZkFIdcTj4toe8l2Pvssy/T42jNodWCKKjhJTuRaM/ArafhNKik0A/2ED0GOB/NlWC0YOiRvp2JNoZPTGkbs+Vf8IOFbzXcecxyeHNtUP/WXQwptJtfH9ehxvQHXIUFfqRjML7rxdxZMdDA06vjdjw6S45Qae3HkCz68BSO7+NJtUCph2PMFdsy7x73yVwKpxwZAW0Hn5HmQ3KuqxNJo5ivs4ILXj3IA/xrEM56B+2q2B2GLMkiRrGYc97Bde2sW7ScuqpFm541+aSTocleOwiBcr3to1RO2Ep9b5tBKYi04/f5QE1Trol1ci+4eQZCN5gUSw+ybo6h0xkKOcveV7Rgl2UBfktq2ign0zt+yrDTRFOU8p8hU3NFx/biC4aY6/e6ZFhzmkLtw55iuoJtPGYmexJ/7/uK13Sfsti5XocURX3QLp5fKzQsqpRkB5+R4ieAifVSoNj5fXnS6esWd0qHnQOImGqJ1Un8qXHpCvcOnFiFDdYo55mnaQ5ab5JlqRUuJo2Pkc1ZLzwTV8SpOlRPHMHhOOdDGlwleZUQTJ4JA8TkCuDvFHMzwmLEbjCL1GZUhg36LJY0hb/ejvu6bcZYU+PSkGyfu6gKf+dB7UN0RJRFNYtbfWNJngLBwOkQfCjqkdahNIjG09RPMqb8472JU9N8rcTAawolpdjaKwP+T1jZSUh8ByghEPHdMi7WD
 UwkIzE5C
 5ruiX3Hg2y7391Q6QDZZX7vI5VVz+NoK8PJe4q5KgY5NsRJ5+sgRqK6ZO+FMdnrwLY5DMp58dS1piWsZmjpSmXVLR4dBr17Wsg+FqgLbtUWt/kHx8G7MSCfYSp6ULkNbVULg8n0OgE2AxgA5qRKeTa6A6JWQa42FP9KOrw1e/yDVEJ6oj93ZkF6Idm1tVcgXdIdP1uv7Q+IVZmOgmx3aGxcRc1TjsKgS18URcIVU2cj2rPD6D0obRkQvYjEhUHtI118Ef33xI5I16FM1tWsDjP3GQnRIJruECG+wwHlcOEMfyAyD095yJEAetI3bRxYS6pLlDiNL+oxKeYmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Move hugepage_settings.[ch] from tools/testing/selftests/mm/ to
> tools/lib/mm/ so the THP and HugeTLB helpers can be shared more easily
> between selftests and other tools.
> 
> Keep the helpers exposed to mm selftests through vm_util.h where possible,
> and use direct <mm/hugepage_settings.h> includes for files that do not
> include vm_util.h. Adjust the selftests/mm build to compile the moved
> implementation from its new location.
> 
> Remove the remaining kselftest dependency from hugepage_settings.c.
> Replace ksft_perror() with a new print_file_error() helper and
> ksft_print_msg() with printf(). Prefix both with a # to keep them
> TAP compatible.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
> similarity index 94%
> rename from tools/testing/selftests/mm/hugepage_settings.c
> rename to tools/lib/mm/hugepage_settings.c
> index db0db8a3df7c..4471f4989dbb 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/lib/mm/hugepage_settings.c
> @@ -10,11 +10,16 @@
>  #include <unistd.h>
>  #include <errno.h>
>  
> -#include "vm_util.h"
> +#include "file_utils.h"
>  #include "hugepage_settings.h"
>  
>  #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
>  #define MAX_SETTINGS_DEPTH 4
> +
> +#ifndef ARRAY_SIZE
> +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
> +#endif
> +

We already have ~20 of those in tools, so one more won't hurt :)

But really definition of ARRAY_SIZE() belogs to a header, maybe
something to cleanup later.

>  static struct thp_settings settings_stack[MAX_SETTINGS_DEPTH];
>  static int settings_index;
>  static struct thp_settings saved_settings;
> @@ -49,6 +54,13 @@ static const char * const shmem_enabled_strings[] = {
>  	NULL
>  };
>  
> +static void print_file_error(const char *path, int ret)

Maybe print_file_access_error()?

> +{
> +	int err = -ret;
> +
> +	printf("# %s: %s (%d)\n", path, strerror(err), err);
> +}
> +

You cooud add this at the first patch and avoid errno dance there and
all the changes for printing below.

-- 
Sincerely yours,
Mike.


