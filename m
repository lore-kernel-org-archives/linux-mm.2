Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8512B606A33A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Be6YHjgh
Received: by kanga.kvack.org (Postfix)
	id 904476B05C8; Tue,  3 Nov 2026 03:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DB8F6B05C9; Tue,  3 Nov 2026 03:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8195F6B05CA; Tue,  3 Nov 2026 03:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 622486B05C8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:36:37 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F19611A034D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:36:36 +0000 (UTC)
X-FDA: 85393151592.20.931D5FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4AC0E1C000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:36:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Be6YHjgh;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=of6BOSsOI/Xiz9OzswHQFf111MtWWN9/gW/+S2R1v+c=;
	b=lfIO2cvnrf8oTsPvqmyCoDZEY2NWH40F8vvhiPXavSw3OccKvHm5ib060Cz7NMD+k8zvKq
	XRdVIJ0uruS2MLV3HdE/u0ssq0uqU8Vdw41kVQSuGe5vzxz0+D8q8fAomBkUnLEFy3cAVg
	03MRIPN5ascXcuXamtfDNMc4l0PZ+KU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694995;
	b=JYZ8V71CzDJ8TISiSU3qTJ4hzpLAjOjBGkvvvfzN3dkxAyyQeU45Dp2OyEijLOniXbg07g
	tXUk+n/YGBt2s8R3wdaxo1yFyr8dkKs0unBH282MqTfl1K/WJMdHvcv48oUEq+qgZj/CC3
	QYlYef+A9sR1mO/gtQSfz/PsahOAPmQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Be6YHjgh;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D166760008;
	Tue,  3 Nov 2026 08:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B0D1F000C1;
	Tue,  3 Nov 2026 08:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694994;
	bh=of6BOSsOI/Xiz9OzswHQFf111MtWWN9/gW/+S2R1v+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Be6YHjghGzdvhgIjQNRaWKGkvThokD5XwStMhOy/X4/2WeAxQUxmXqeQqTr2q1W0s
	 K3BhntXqko+gaOnnd+3YhoJOAsosGn55owJ3OjiuH8UkcC4Ck/XcCf7FIwTly/U7dR
	 i/NaE/q0HOVeZUYjeDVzOt2NwpXM9EUjoexg5sVlo2MCmEyITv2+HsIcLqLIAAF6XL
	 kUT/uozqyuUM0p8vbGhaFrQ5d1xStDKRGaxIezMfytZuhaYZ5u79yhdmntHtGX6IJg
	 Ic9SjLSnMuIprFl3Qa702HL+f+YZ8+hQVs1LKXp9Gnh6ht9+C7hcsEO87TxBdWGJUu
	 L5NL5J2dN3USw==
Date: Tue, 3 Nov 2026 08:36:26 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] mm: remove find_lock_page()
Message-ID: <aumc3fnNg1PK9wXP@gremlin>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-6-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-6-e7280bdb31f6@columbia.edu>
X-Stat-Signature: o9qu9hfctcwmb973kba3hy1ix44o4mbj
X-Rspamd-Queue-Id: 4AC0E1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793694995-266345
X-HE-Meta: U2FsdGVkX1+F8RhmHtgp6vW3e5hCzvwj4IcWf8zHvZtQEvqrGB5D91K0VcvhNF/C9zij9CY0d4lOGlwIt/SzDgrCeKF/CTfjCvBKIqeMUBxcyCUwukYpiH7IYmOVrC9l0nBxMYIXTQKDw2rkabwBPyDrIHaw0dzkCDOczm18Rcd9VOharr7WstQJU9cCXt8zhNcMYXQ7QOhutwGX+jUf1qiWMmkA+aUF9owpKcy0hFmXb1uFiqwZ6ybniC7V/GbEf1lQVZ/Fe5t/OctrJxIFWCP6At0Y5VbXRGVVfpSi5IG4Vq+WgR2Gmc93iSTOvXLo08pjUujIav18rNLChL1F+74d19bjvx1ln4y5gcP2teqg7ONfXp4Lk7EUhFaWkqJoBwuc/L/uQJ4kDyBZIjVhjpJHPBinS+uDWV/HCVs6bxli9Fp3vwDSe1RImSLLbLujnCQTN+rhD3mDy6Yec3BXU0hELe0qTThjEIQlamdivllRaPqSEsx0FMQc4pCZQqqG0Ma79M1m30w82QTVgly5J2IAKOdWN3UK0coA+nIYGydzLUCj6y3cAwH/5dZFJdKT9HfRTFDxL/bQp3oTSCdb+kzI6K/ge0sOms50cOOxg31gRwuxjLpMAxpTGJZCZsVygqTLsc0IqDTGY66WI+4jKixW7nlgPRJgbg45h/cKPEdnosMed+kmoox/82UeJnSZqU5Lbzw2XoMR4Js97DF8Fjv/FfHN9vXeBmcAUmITKsAGlzbOgRX/Fa9SkNVHNPSckWhV+5+xgQr/bmm+pYqYmmxrvunWvCTo2tboSGxVnCDg4KjpThRLzpZsaScYLTnU3R7X66G8IDK2oiK9OKyY30uuYYjiyQR/aFK955heMwC+veU2D8XFlPUqiCnK9y69+ubzFopeOD6m7TQwimA28Qg/XvKdUM9LoztLQ9/p59A21XhCPzL4KdMZFMXtQwkPD5VnejAxS1HY/hNjwpd
 7A1ft3aD
 /VA0OzNoz9XT9oCx++QndhLHguW96OGjXThMTpp8oWLA3smRenS+Bi9vFcNX5197S3ZJXUVVpw78Xo77cdPfzoWDVsDF+sVHA2VQS6HuZOAynS3z7ljbnmoL7XxQohj3QNEfnP3GWtXrlEV79RA/tLDcAf3pxilA4ZknZifLV6BVpkOD/B6lx1ht57ddjZ08rd0nEWXusxQVC8V6E/wa4Qd3CRRal+d81QFDncT7V7u/oUU6sPpoMgeAuFEoUqqjwgJDFlz4sjIF7/TwdWc6xCwFxMV9FdHkYYCRN8qAf5YXb9r3wiLYCUamOZ2IivTfcpA9nP1ZApcyO4oQJWLhal8JhqSt2WmpZv787BVCNUaxpheKvQZ2md9DY6XPEtKZyP6VE57drwIbgmY/1krK/pdBuCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:11PM -0500, Tal Zussman wrote:
> There are no callers left. Remove it. The name still appears in a
> sample function graph trace in Documentation/trace/ftrace.rst, which
> is recorded output and is left as it is.

Yeah that's fair enough :)

>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pagemap.h | 19 -------------------
>  1 file changed, 19 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 00e32f96b459..a92329805acd 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -846,25 +846,6 @@ static inline struct page *find_get_page(struct address_space *mapping,
>  	return pagecache_get_page(mapping, offset, 0, 0);
>  }
>
> -/**
> - * find_lock_page - locate, pin and lock a pagecache page
> - * @mapping: the address_space to search
> - * @index: the page index
> - *
> - * Looks up the page cache entry at @mapping & @index.  If there is a
> - * page cache page, it is returned locked and with an increased
> - * refcount.
> - *
> - * Context: May sleep.
> - * Return: A struct page or %NULL if there is no page in the cache for this
> - * index.
> - */
> -static inline struct page *find_lock_page(struct address_space *mapping,
> -					pgoff_t index)
> -{
> -	return pagecache_get_page(mapping, index, FGP_LOCK, 0);
> -}
> -
>  /**
>   * find_or_create_page - locate or add a pagecache page
>   * @mapping: the page's address_space
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

