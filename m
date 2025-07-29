Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19680C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 07:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADEFB6B008C; Tue, 29 Jul 2025 03:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F8C6B0092; Tue, 29 Jul 2025 03:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E826B0093; Tue, 29 Jul 2025 03:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE966B008C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:52:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10AF7133D5A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:52:43 +0000 (UTC)
X-FDA: 83716535406.08.3D04046
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 034631C000D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:52:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D0kuKukJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753775561; a=rsa-sha256;
	cv=none;
	b=JJpKdRY586Xd8nF1VA/V6+mGki51eJb8zat6RMyw8LY/kj+CEmy48uc3f/5XuKC0Bf8nqR
	bCna9iKGveO9VTu3xvR96z1wSxbIFU+de+N2xCF7zUDCwPJ6/W8hkOlRZc6p549cY1i3Pw
	CZL8/LFVHSH87eSDTwjkiiOmpxKr8hw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D0kuKukJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753775561;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smgFHrQGxmFhyoF2rRGKiX2BsEmUYdFGX1JZMpUcdm4=;
	b=H+jg1LwA4AY+pIzxPXRvBUdNqpBZeB+lcywyb9iWctz72WTiUT6eUC1mN+AWO/g6dvQNec
	QERlidLxAoQ9LgtNL3yvl4+4f8aSQTx4SuPuLC7RCg7Gv51okq6dEPcCIDqQsb3V2YFjgb
	X56xfoYgvnI7BtTh/mzMvjTzWN5M/J0=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ae0df6f5758so884556466b.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753775559; x=1754380359; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smgFHrQGxmFhyoF2rRGKiX2BsEmUYdFGX1JZMpUcdm4=;
        b=D0kuKukJ42A4VgQM21+/xPt4X1jlLqVNyVaagxeRFy4Zib+m/B4ZPr1Yh2FRSo9l2E
         PEKX5rOdXRmiTiQg3hkoKeLSf6+ti1DUfIal36Hyt7bboQ0nWdg4CXrk83y8kmegVzJG
         rfnooojtKtDI1Oh5+hiP0OftiC1whGy4cieYM9JQOOj/GNst+DA7GQj9GeJCNdBYVpTe
         0TPw0oZ1dhUL8y2siYiJcLC3vFcHIFc1inGPGzL9SVLUNl36oytQHrMsp49+MbC46h7E
         E8ppCz9xrknwsMnJIFbQveh4uIeUqIf46o7/BM5zQGA6e6FiNbYKQq/za+8kGFI+yxZg
         qqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753775559; x=1754380359;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=smgFHrQGxmFhyoF2rRGKiX2BsEmUYdFGX1JZMpUcdm4=;
        b=ZmdlTg5MCdpIlmeUmCXndq/JEIjUnqOM5Gk+BaoSOJxNf+kVR5Y6vF/JXQRUjtPicr
         StLV6hPe/moIuhml7q1ja2wY+BFE+LHgJLSQUgryr8thgydIwwB1juAObvISwot2SwFU
         UEML4FJOb+M6lhXZ1XXtwRA3+74h/8tT0w30jqZ7aiNokNzLlt14xKugJP0rVP+GGtE+
         jlFrD4Wamn9WSnV1GMwAiZhEHyvdUy97GnajZjAq50KxkhzZHNg4aw8W44qiQFZkSVxF
         u1ZkbXAlimpeOl1X1raoy0+vxmN6Ylah78LUTQw/4X2UkUXsvzUizqZWyiv+8Vg3ASI/
         xCbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRprUMWO6Ob52OLdZlwRPncL89IUlWZavSUrl0GdUrkPJ9z3dhGTOjKLNEpfVanxwXaF8RvaYNAw==@kvack.org
X-Gm-Message-State: AOJu0YweQd8FDj2mNHVmE79dPpTeO3o4SO1w69S6s2HfIRSlRQCqfTJ8
	pQHRUnw3sua7tce3fjLi48w3MgtJ0UM/aNfg1dD/GPYeC91q1x5V5XoO
X-Gm-Gg: ASbGncu8ZTYAI9YOgUMaNkc9kzj/usifvKjvxZ8otuTMDselooSqGhkK8h2pFypI8Ek
	AlSjv8ZioCzB9CXPYhKz/cnIZAhdIl7MHlqX0cnQbJCQvnLyyiCYEE3puLW6h2kINaQDngwtnRt
	QgOFawZDL0wtbGWeGJ6TzIxNlFneeGCJTnfqlmnlkJj+ct1d16++c3G28cnmjKvGkuDLWcxOyQR
	5KwMBo0b8e0QCK9aIpLWjS89+eGiqTipcCs9eyHwJYN/aO76puW1RRRfZJjmKfRp+3FIvT8t9gI
	henU6TaS90YRaRXtmjslSroJD9IMnS7nICRABb712Vh64ItO2PB3W/SjfcvC324TC8MS6gVJW1H
	8vdbi/4P0+ZTkAY/m9FLf0A==
X-Google-Smtp-Source: AGHT+IEV6FhS7BcuKiy2mmCmExHdPH8UplQNL1+hlnfx7GXoYFJTZHp4rwskMVqcf+8guTBozWXdIg==
X-Received: by 2002:a17:907:6094:b0:aec:5a33:1573 with SMTP id a640c23a62f3a-af619aff33bmr1645989666b.41.1753775559042;
        Tue, 29 Jul 2025 00:52:39 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af6358a1aacsm549963466b.49.2025.07.29.00.52.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jul 2025 00:52:38 -0700 (PDT)
Date: Tue, 29 Jul 2025 07:52:38 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 8/9] mm: introduce and use vm_normal_page_pud()
Message-ID: <20250729075238.44l3jgz2l6fbss2j@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-9-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-9-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 034631C000D
X-Stat-Signature: 1od18rww15pzhc4bo6jgqp7frf1ausum
X-HE-Tag: 1753775560-213383
X-HE-Meta: U2FsdGVkX1/Tw5tpYQQQtBEkEYKTqx90pO6KjwNEPQLwa+4UmLYq1veTYrkjhHZOgeTH5khnCvxmoG3nAiMv6bNQJO879YEWAm/F2bmqanMKicyi5QDXbDgUcQ4cS8XSUsvYrMHfNXGMbZ49LV4OIKhg2UdbS0XVvcne7ZhsrlBwxRR72hs13CJGj7om5PNN451TgNOySrP2dws3kjUsorsKQbvsw5cF1NsFMy002/WwWLWskdZ3QnEQV2Kob85Vwvyf5Qq8AYufR95QLc1mCiUTYj2sNp/Mmw/4rZmogt4EoHqInIoLVPGlxNVtDH6OcbXsEIesVQXvLi4BNUq5RvlyoaQwOfZBGINw1szcJiXCCJIqp9IZVDn2tgYcnU04RjT9tBFYgiXHsdmw8I13ks7gbFoBvyxzyZbwKJ5PAjW09sZfMhwLV7STJDb/Pdg6URpd5d3X9h3anmyjyjnYiQLrEAHogGwjxmjP+b8DWIcqk5sM1HinaXEJpno/bD4dWyJZ3EvBdKiKsw96czQi6/MRX6kuwbj6e7ikCSeJMHYSq7Hig+EYKAB+vLZc2IfD0uEx96Got2WxdTcX735JtbAaXs1/M9Z/+2pmxmGxgq+ZmUnri8xhh2W+o4FImSwBRqEJfFWCh/iN89KdN5JWRGczxsTvMwIk7N65yQgPzWrxX8iF6KJDF4wZmpaOHkogA3VTEAycF5q1jiHeiDyTALqLulFvVk+nWQAxf4BV7JOY+iBdU3jL/LTeOcZxDk0/ZLLcHGNhgysfP3AYwNuGN4GCSQUvkZrC8FE0DCEg+kvGdcNg8DqdSXpQ3DImda8PLxQDJNSxRYkbXi2b+1YcG7oPh1ZJqwLLeqgtn9ZQlWgyM5u5OCbE15N5xFic/KKy9PPI3uUuqMk2+/HC+GKGSw55ckUKoUYft4cmZ0YRtm8RBmnOvUKUeh9CIr+F76xRu313JHEszowL2Ycx3qx
 0IxvsWyV
 53Gal4sGflkitkyCZlHJlxM5teb0K6Drt0IQi23/Vuh8aHs618ZOOehTVXpjx6tZyaXJmHxHd8fKvg5OCCH4t2mrCS/qyp9yWZIUY3v2mHyByAIQqAnXoJDDcAbH4blX4nmYzwvs5Ti0Vuiv2QC+C8JGDkEGIQ+zU+xfthsdFkD9rzZ2/DbDAqkc/fnzQ7xyTx6oiqjmgn3VMpsldapkfklNXJR3jeTBQC/PIAPliLFRt6+x5F9yIbrzkY5cMYfIxUXCgJ4eyIDb26d/faiW55ozHWDshojH2EIMCNJAR9nZyyxLbKDpZSTNmHCnpv1JqoI74wszyCVYKxX8Z//yw2UHTMy4RpJCYy0YBML7d14z7OEB2x0y0tcKDtQi2RizjgUPTl3hDOZ2SwzUvSp95+Mhq/+9IVnTwzsqAPlp3Muu0yHjc9AjCUQY804E7qRovkj9LhJ/SFcZN4JInTVSmqNxEpZCjU0HB8aPjqmYJs34kHEH3xhhalDCisTpk1VsLWcSnsJpcTrv0QQyN2XXoMvfrEUl9ntQpZ7c8mbcvNYomUzdhMe7Xxwhs6t12ujK6/oDTV3tEh3x0BRBZ+Ekr3fo7PD3YlsdvxDCbCIaHfvqYSn5X+oQ1ic4Oe+p8Kg/kpE3Nf4p7IPyyF1jMXOJ6WJXBSI5K37RlN0c3QHGMkSgIHxPmNM7cnm2gJgQ4EYb81QAQhvYEVdr7HXpm2pInh3myROWHLV26B3sN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17, 2025 at 01:52:11PM +0200, David Hildenbrand wrote:
>Let's introduce vm_normal_page_pud(), which ends up being fairly simple
>because of our new common helpers and there not being a PUD-sized zero
>folio.
>
>Use vm_normal_page_pud() in folio_walk_start() to resolve a TODO,
>structuring the code like the other (pmd/pte) cases. Defer
>introducing vm_normal_folio_pud() until really used.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

