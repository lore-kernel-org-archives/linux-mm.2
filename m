Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0862310ED661
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76CD66B0095; Fri, 27 Mar 2026 09:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DFB6B0098; Fri, 27 Mar 2026 09:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C906B0099; Fri, 27 Mar 2026 09:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C18B6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:46:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6B0C1610C9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:46:54 +0000 (UTC)
X-FDA: 84591968748.10.2D719F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D4A3D80014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:46:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Skms378B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774619213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWAw0CsHYqSDWe4efm4Eod3arXmDkUR/GwfpXxf4AHM=;
	b=UaWLruZ2t945fWnukZOn5zRe8OXW0CjuRexhkHmDEwSXQlMulEXxSbAS9v2qAylrFXuJ5x
	tfLH5OyzoyeB9By5s5KC/FN1WB1P5ZtJ+Q09to4aOJftNt9Auo0+G5v4lEwbTtoEwagYf3
	y9qfmrSFEtANI0l3AKM268s5mTMw098=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774619213; a=rsa-sha256;
	cv=none;
	b=Ry/JrRowZVVKlF5PAGUYXhmr8FUOLWLBfLvebaVGm6m7Gvda2xkdXzUOy+LmvVRHyexF0v
	J2h+o7N7AFRSwqpvrvKDftGGv8fHkLEjAFKaUIVpzK9Tqc2RfCe1vAY3i/WH2BTnfMF3rY
	sPslrTRpw469ilZ/UcrNLg8HqDkPVNQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Skms378B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B542C43D69;
	Fri, 27 Mar 2026 13:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF860C19423;
	Fri, 27 Mar 2026 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774619211;
	bh=89JE0t0W4FzLVyP23bqYBnuh2CwNsQQKIZIl2xYaLfE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Skms378BzmiA/D6UoHZMqFCDd/CdHEEeQBcQchaLRjwdim+s1GgnWl+5JBVLnpAMm
	 cbKPDmx9DTssIsoBKVJeAC7+kNgElYmmVK7JgRDodZkwSptrE86un0zAtc0bTn6jOc
	 vcaZ98vrotoVY3/Zl0SAML8PJUSqBwzszdZ5kRSvUf6dBPVT8n6TUUG2IB6BYpVc5S
	 B5wEhPs1jJHndVr/z3zFczH1US1IiU1N49vPmISYYMajrebZEUy/9IdXqOWnrdvy7x
	 aLXGcR/Jc+/laB6lvrpF6TKPPOYQPc154t7HIr7SI+Ewc4XgEgCOwUu/9QnAztP6AY
	 YAv8isoHSvaOA==
Message-ID: <10748785-08a9-41c7-bacd-88f05fdf1a88@kernel.org>
Date: Fri, 27 Mar 2026 14:46:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D4A3D80014
X-Stat-Signature: azfur9e8cdihydih6dj8crakutnr7m1p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774619212-517873
X-HE-Meta: U2FsdGVkX18xECD3cZ+xz7g+sKIEg+AjxNHYFxKa1Bmxj6txb6H0TL1ASH4rdIk9RwevVM6V/IZeovRzFNE4eczzxxTt5xeD4t1WzOF2a+QhDnZPccUJJ5V2ahvgal4zO/LurTSo3lZOsbHL9uSZCynyFPCbkddH25LoOZcH0pxU6IYqeDew0yS3rTbqMfpjMpRubByoyA/S7m59d+QO50oqgmYeIl6zJsVfSdq6WXTGBJ5V4lzI4cogx9SeXYxEKWrg4D1nALhbIXHRAMNQcWwd8SJdVEXf9WqWecx0EZ+XRMN0WGPTa7Ikui5XbVwM6vCmGCRs7P+IMq7+CsWnHvsBmc5x5j4kZx+IKeW8YOLXD/kjNRmHtzlQ1VA5T8hMhqZt+9WCnPXLaZ+pfGWlmjAAi9weU4ptQFMHBoQN0160GJlnGKgQXWaeajcQZbLPE9IZiLFXZQ/2GJBMnvXrXD/EXbCPFCh7auxEFlLWK4uAuGUowDo5H5rWp5WwQlby3CKanH4XNGeFef5E8B11be3c7N5Nd5BvjjIH4LjWTxqL0DgEP/ayYKuWOCGGqa9IAV3TCTWjx8lOBopVsobnbEoZ1zX3WJ2yUKw9gm8uNUmn2+y85JVmLTYtTgFy+S0XdH23AFKdgpmJcBzSS5+frQ04NTFil77bv8UaBStjIC4bDrMiA+h5CnCnsG1GEA5aMVtHKJUPFDLOxnyzWna4hBbesJEPJQUX4XMVdC5DR1LfVW2ZfLU8tzqvGS8//q6lH/P99+Pu17FiQVrxVfkY+FzKDm8ac77qlnCop9wqLedfw3O5xWw6szR3bCvdc04Muw7rqy2fHoGIGtfHOOTyEyrLvzBgq7M1AMhyWkE3azqeOrgrX/s221rblr9SwF1PcOFrJ2vsLx0wskDGEErl1U14j3P9bGHpdKA3ZXTZGK5hhmIyYsFjYyJWrNlh0ZNBdWV8d2c+R3l1cvcfJnl
 ZGTM0gos
 HdcngMlH/PwHzCE9QykIo+Wyk5CZFqPeq5N4/EvThSMrDcNH62ccaq2wW31yoR4M6eIHayZBxi3IRZ5e7h88/MtQ7PEc63ML2qax4/NyX3jaBr9bxngB/80lLIrOgPD1c/tNJFCwyP4esmf8Fx6hULckkS2lNZWOaoFH55d+WhlRwNRlqGbjQMJ4w4Kfni8d/hd0tPXJYeMo3wKgz/VEpuXsll/VSn1DM1H5mPgfc7kkUsPMFal+qZWRVuZHVtP56n2zogrjXx23h1OA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 02:42, Zi Yan wrote:
> Hi all,
> 
> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> read-only THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default.
> 
> The changes are:
> 1. collapse_file() from mm/khugepaged.c, instead of checking
>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
>    of struct address_space of the file is at least PMD_ORDER.
> 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
> 3. truncate_inode_partial_folio() calls folio_split() directly instead
>    of the removed try_folio_split_to_order(), since large folios can
>    only show up on a FS with large folio support.
> 4. nr_thps is removed from struct address_space, since it is no longer
>    needed to drop all read-only THPs from a FS without large folio
>    support when the fd becomes writable. Its related filemap_nr_thps*()
>    are removed too.
> 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
> 6. Updated comments in various places.
> 
> Changelog
> ===
> From RFC[1]:
> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
>    on by default for all FSes with large folio support and the supported
>    orders includes PMD_ORDER.
> 
> Suggestions and comments are welcome.

Hi! :)

The patch set might be better structured by

1) Teaching code paths to not only respect READ_ONLY_THP_FOR_FS but also
filesystems with large folios. At that point, READ_ONLY_THP_FOR_FS would
have no effect.

2) Removing READ_ONLY_THP_FOR_FS along with all the old cruft that is no
longer required

MADV_COLLAPSE will keep working the whole time.

-- 
Cheers,

David

