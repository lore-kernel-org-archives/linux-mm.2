Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93761606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YbCqZfuq
Received: by kanga.kvack.org (Postfix)
	id 4B2FD6B00EF; Wed, 18 Nov 2026 11:12:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489A86B05B2; Wed, 18 Nov 2026 11:12:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6876B05B7; Wed, 18 Nov 2026 11:12:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA436B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:12:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A198407D3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:12:05 +0000 (UTC)
X-FDA: 85448731410.11.FA9AC1B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id A50681C0010
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:12:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YbCqZfuq;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018323;
	b=6eql5Z0s3+tPbHDjMe3lJ96MTywfIyWypN86CGbSxNnFJy60BNeE+oX0Yvs4ETgmSAWDxs
	OAfCMkjVecDBb2MO/8dmuOHHmkFpGvJCVBvnLr7VqZADhSaiOrLccdR95lumOYtjnRdJ8h
	v2sFuRnh2S/+k8nkv3Si7BHFSIwryl4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YbCqZfuq;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtOK71mgWL1hJ57ziMdV5/lpR6OIlsIMpvQ29Ztn9ic=;
	b=OEroAHyUvW8HF30bFweAJoDLHd+qoa4UYGrQPCKLU7GYrHBUNju1Y0AIDiQFBfMa2Fo/ja
	oOvUjq8yOqXSYtC7BL5PX3AKKZkOXYOi07EJc/U/i8neZN1ZxgNGFWyoMHN8IIX2DaABMK
	Z40+K7aBaeIsOmgm91bDmLUfmgOfnN8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C574C339;
	Wed, 18 Nov 2026 08:11:59 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35E633F673;
	Wed, 18 Nov 2026 08:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795018322; bh=aYQ0HCEYlkn9BeS1THLapsztaFWJtc0g6BUkMATS0GA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YbCqZfuq9vsdroMTMmDXNL46nZtVMm9VNmLHTjEGcy2irM8ufBsCnBnRV/fVYl15N
	 4A8TlkUJeyswfIKtt74NSDt5rlzv/pIYVVWT98EMm8puIWg5sekv6yzmy/+A0dD3h+
	 1UzoLtCEDx4y9eRTDQ8enHNrj8UvtuZ9G8ANdCuc=
Message-ID: <15d75748-9baa-43d9-96e0-0e49c8e27be3@arm.com>
Date: Wed, 18 Nov 2026 21:41:52 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 1/5] mm: remove unused helpers from pagemap.h
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
 <20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261117-unused-sym-mm-v2-1-2f845e94dd50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b1s1t4detu33uho6i6omsagu5g466sn6
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A50681C0010
X-HE-Tag: 1795018323-252219
X-HE-Meta: U2FsdGVkX18zvbrgXo81uNPDM4x7S85mfSu9gnMKLVA6H3MFprB893ESXH5XJaVSmGcqLYQodXzssber9xSQyDpz4O7Hqg0Wnw58RjM7SMsrkxTBey/T/GqArYSevEJswnmSFUBiznd6BJLG0N0oXBtbcqLzRi0BYICwCzT57yCt0J2sclqHVFufRsDEpzmZJrgHsBdjxnDWn4UpOYPw/C8LAjfNVSbPaDZFUBLuqKR5AHovcS0B98W0q4pNAgGzvSvkDOenfj/JtEArttZ8im42fXHGIh/My3SSw4p/5b1w5ijr0qy/p+LPFfiPNxTi47G1RRKfPGqg6n7FnyjDOO9HqYJNZd85l0HtSXnHt7l/MiyFvRIHyjWR1e650mhH01l2pYFEaetxIoP6dMaLfJdnH63S8CHhGCorh7nQt6kFWMLUTr3vuuyCADNzaeLZfYT6xXfOvUftklHB9It5uggoFaO0LdqccAGviS//TVfbUUftfwpnbYkDt5lMolkVWxIfTP/RKbkxrVqge16vQKG2jWlWBDOzdj0JBNOk3VxMLLoF4PbWTBZdLAJCDnnPL09g6IJVzwsXl4Mmhqv3XcttpjSggNXMqia1GeMpxoY8+n30YjyjX+v8Xh4N6A4t/Uwsuy4AZg3/yeU2CGk8FP8qp9K+hakCUOOm2wJ2/BpMBHpokjHXtOSAXW7pRa+QrkWoz3XvDKBU/cHqd/zI8c5tcqx0KwBMdl/F3RGgiMCf+1+6ls4P2+f4oF/DWcpuNvHyGtqx7r51Kno3SXq6icmdwVucjzt2eWMIXjttgzHJ/noHj53vrLcG2MnFFmBcX1Uxbe4hYT6wlc299e35Gn4a9sNpEnIbhbiv2GBEdWDtrViYj/M7PXL+yE3RhOwHQbT/1aIJ5WcvGI6tG/BNr2i057VHZrMrPvLiPekVtKstfjeCfsUu2Dg7Gm4XaXcV9WbfZbFkv82cvEE0dTI
 xIFqm+P7
 k+9W5bUv/lRAlPDEqn2lquqPlzWou1+m2mJhqG7O4eeZEYpNhe9qHD6u3G0BNazcUtC0GcZURDhvHPDZb0CF75CuxYbHufFHutRYQzri4f3Y+NgXLhoeT0wYWSDLuSkxhDOgiMItGvSJU7Il0TjV4g8g+nIdv2taQVB387gLcqml/nzK6q2cyn4qRUm7AAPwcGCpV+2hf0mByuxZyKeTU9wiGBXWaIGT3rlMMnKo4pfb+UlnIdHX0l+Na3zStpVsD9abjqkzDX6FhhhZWzHwiTdQG/ry+xsB6OZ9OYo72T3qRJfJ2OB5Aac6ut71MlXIOtkMX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 12:46 pm, Shivank Garg wrote:
> invalidate_remote_inode() lost its last user in commit d73065e60dcc
> ("afs: Use alternative invalidation to using launder_folio").
> mapping_clear_release_always() has no callers.

That was added in b4fa966f03b7401ceacd4ffd7227197afb2b8376.

> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  include/linux/pagemap.h | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 73af18a37367..e681a7ba6642 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -20,12 +20,6 @@ struct folio_batch;
>  unsigned long invalidate_mapping_pages(struct address_space *mapping,
>  					pgoff_t start, pgoff_t end);
>  
> -static inline void invalidate_remote_inode(struct inode *inode)
> -{
> -	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> -	    S_ISLNK(inode->i_mode))
> -		invalidate_mapping_pages(inode->i_mapping, 0, -1);
> -}
>  int invalidate_inode_pages2(struct address_space *mapping);
>  int invalidate_inode_pages2_range(struct address_space *mapping,
>  		pgoff_t start, pgoff_t end);
> @@ -298,11 +292,6 @@ static inline void mapping_set_release_always(struct address_space *mapping)
>  	set_bit(AS_RELEASE_ALWAYS, &mapping->flags);
>  }
>  
> -static inline void mapping_clear_release_always(struct address_space *mapping)
> -{
> -	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
> -}
> -
>  static inline bool mapping_stable_writes(const struct address_space *mapping)
>  {
>  	return test_bit(AS_STABLE_WRITES, &mapping->flags);
> 


