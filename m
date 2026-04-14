Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B13FF9D0DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B68A6B0088; Tue, 14 Apr 2026 19:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340A86B0089; Tue, 14 Apr 2026 19:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2081A6B0092; Tue, 14 Apr 2026 19:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBCA6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:02:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8009FE3790
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:02:39 +0000 (UTC)
X-FDA: 84658687638.29.9233790
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 978CC4000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:02:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=taNZ5vB0;
	spf=pass (imf07.hostedemail.com: domain of wyihan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776207757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYhIIDY1BBnC9l/Uqt+TOwqFCFA2hfXSopa3Cxt9ADI=;
	b=A8br9ieqU4CcK+NLUDcMKmNaWOR1snNnPff4UUd3X6Yy0SwKN8g5QRM1cMUaTf+TkchyJq
	d2sNRP8MW4SSS42WD00g+qTvKYA01DWUaojzRYNWDeJXaSeF2yuKs9+njyQLaiA+VJtYn4
	G2IevJAm6DA9icuZ1+ZK6GdFviWHeGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776207757; a=rsa-sha256;
	cv=none;
	b=JMGsEA4LnqAXVTUUKd44KCysl43vZ1VHze837ean9m39CeA32xXSB9CXP43OUA7SJAe0lf
	cbzuhPovSKFG53rxmjtE+s9oqFM93Qbom9dOyB6VnCfE1MtCwzuiqRpj1v9xtYOiFPt3gc
	BrGjxShCwsDN6RmS3XtjNQHp2A0F7Zg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=taNZ5vB0;
	spf=pass (imf07.hostedemail.com: domain of wyihan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso278385ad.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776207756; x=1776812556; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hYhIIDY1BBnC9l/Uqt+TOwqFCFA2hfXSopa3Cxt9ADI=;
        b=taNZ5vB08HTwdU02j/wU0BFIa6w6gh4tZxyXLN3Lrn+CJ4qa/amvuboVZouNpxGJyQ
         54hK4Ri9u5f52aNbtCthRA5h6FNNp/Hu7BsgHBpJSI3kfiLhcufA6YTV9XFlqkuoeDsC
         1L7dZ/8LCtdoLB8NDr4Dz/4NRzyZeKRdJl1YHIAhQpEef457lfkMgioBVbm8hcsOIiXA
         DoxjN0bJdvuX9FDEsf8jKeHrxejsuqk/apmoVmy7Tdx3KzFRb7OdNYxIC57jr1mx9pJ1
         1LInYfPjiTZun7llyU3nKa7NVdLl410ZJ/fz7Zr+ukcREkqB9Q/cvrwy8b/d2bGZD/iN
         6YAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776207756; x=1776812556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYhIIDY1BBnC9l/Uqt+TOwqFCFA2hfXSopa3Cxt9ADI=;
        b=Z6Sx8eoML8cOfAfpb1c351CaqTTFoNp44ACUfbsOuI4UkznCXK8s/iCGHtUbqDTUGe
         hQFnZsZVTW+aJDMkt4pmEPcJEOMoSqhhdy8Y9z0PB1XnOMzy8Le4FFclyQAsbuMIXs3A
         840KN1BBBbPvBUPrN/EOuaCbBh1XsVEGv4E24Q7EiYCpwAP0Er5s9FgaAnKR7QtF5Uyu
         diS9PAwBfsA0ONr4qhWUSjM+ueyiGCPVnFN/MGglVoNtQFXMRd9LzaMKFaY6tW7owFJz
         6e9GG7W7rPIhUzWeQ3Lm058+wF510y8gYveqOal6h6GEuly6xFQNHOr+Y1xOVVsYanru
         Tw/Q==
X-Forwarded-Encrypted: i=1; AFNElJ8iDEJmvGWoeptsElLCpDo9fwlCu0Fahbiyi6iWZam8okds0g0DoPlNEvuUXIWRQLrlwwCJmspQvA==@kvack.org
X-Gm-Message-State: AOJu0YycH2v+fk0S8WxQB7A03tgoznSfLUKC7DlaJwUgxeFEP60zliJQ
	zZnhLe0cftdeYBuzHL7rjrypVCO3bR3fOlxE/Wei7r9huCS/kdR6nxzMw8mM9P7X+A==
X-Gm-Gg: AeBDieu/uiH2VEtfPrIfCF+L8mIxQ5ALvngoCEDyHVwuuaban7fHYkhzYCHVrQ2QK/6
	GRtFkyRBGvM6hXt0bl/25Db+Jf2wXRCQw9sQcHSPPGLeVhfenM+jxXsLjsE43x3wv/UKjWKhIhq
	BKFJtWIWO2RTFJwzBZJ18MyMHOUZy/seW5EYJsaaYCMLyYIP7qLrMe2VVTMSNpEzKe8aD0rqlCX
	+yfKdoj7RftlIhausaJDeYfrbz7AAlsSEdr5PXpQsENZq+aMdnNCS/0/cqO5yJ785/skPS8FgLy
	F5x14pNUk6qEDy6hwi1Em4rbjHe42anzJrhZHviyJxEyEqp90REDj7H7xPQljsOo8MtACuykaNw
	zn39EC2XgN8vaT46uIIlh60/Ukmphx6CM/ZbgJw19qUJsDmIgvVah5sTKae5K3NKAUmikQTsGXN
	lQ408phczueCVJA3sFU4xU63t2Ia+ABm81kuCbEc7k/c2Ytd6OqA/e/2bhO1KqSNUSmWTklTZbR
	monFxfBBhx4TA==
X-Received: by 2002:a17:902:d50d:b0:2a9:5ef5:399b with SMTP id d9443c01a7336-2b476bcdeb8mr642005ad.19.1776207755684;
        Tue, 14 Apr 2026 16:02:35 -0700 (PDT)
Received: from google.com (115.112.199.104.bc.googleusercontent.com. [104.199.112.115])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e38ccsm64574b3a.33.2026.04.14.16.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 16:02:34 -0700 (PDT)
Date: Tue, 14 Apr 2026 23:02:31 +0000
From: Lisa Wang <wyihan@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, rientjes@google.com,
	seanjc@google.com, ackerleytng@google.com, vannapurve@google.com,
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com,
	dave.hansen@linux.intel.com,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/7] mm: memory_failure: Allow
 truncate_error_folio to return MF_DELAYED
Message-ID: <ad7Hh_kz2aIOeZFI@google.com>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-2-92c596402a7a@google.com>
 <2f177e0f-2eb0-48d0-b48c-7a0a340caf5d@huawei.com>
 <adA_1zXLUBqmSHFl@google.com>
 <5c5dfa85-baab-5c0f-6f6d-b71abbe10ed8@huawei.com>
 <4d38d333-d446-40a3-b6f4-c4890bfd24cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d38d333-d446-40a3-b6f4-c4890bfd24cf@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: eqiz5akgpcc17pnw7tj6tne1974kjadw
X-Rspamd-Queue-Id: 978CC4000B
X-Rspam-User: 
X-HE-Tag: 1776207757-856242
X-HE-Meta: U2FsdGVkX1+rUvyQ8LhGCZ/clZrQnapjUkb7XAJaOeD9uy/+MQl5QI8JRXz8OUo4ZcVq0Njp9IxV0TLJ5HATkkiOx+jupwcod0M/ltPQUey0d0H6fB8JcuwJRBoYD4Nl77Hr4fq3a1VQcY0uMNoOOyVDxXVyw8NClDsqNg6UZPgY22hwL2TJLudSvNrhQethDP2SqitA1oIWhnf1AHoJZlsJ81LEnuGIRHrlI919le7YW8AhoJ5hLFKGuaNgfgXkuys1wLV51r+HqemY9PwHneVulxlhFqPESSzlLU7AZcfC1BbUz30D3oz7cp14e9W+iuTlS0W8k1YV8k/AukMfrtzVKFo4r2HH2w4RxER0wNKQZTs4PXU7AQkL2JE+HIuEeWJU9dwdqOrDs85CzmCFmhAOvr7FtpsAaKtYqVe+TBe8AX5dvCsBHDwpMne3QhTR7J5s3IiZ3UJ4Ryt8MV58c7GTsvEVBBTa09jyQ/NJb7K9Cfpg9VuTr0na1AUDvH8uUHoS8uYcNaWFGVWq3n8jHdECc2c2V0613gu6aAkJnhmos9567hhMTyvo5bX70rCoMjU7sgWtAD22+tirlPJ6ETM2SQQBrTVTRtNBYNnVNL/NImfbhCtwn3wzpuyGbWSOz3XkxTguA9UTQjHK9FLtyWhXF9vQHXCyXcPCcO3FLj3C1TJlrLDk96PJErvLlhgu4GDQ1nUCnVh4RMMX5iCr4GThvi2jc2cMezV/S7dAmeSv/0OsjhmSVvQ/hXXhOCQorJHgBTAiYlwpt4nKcf1c2/NZchCQXZIRyGHTsds6thx6gcOLpDsPLxoH/DaQBUP2Hkq9CwNYn9fN/NNmmlLNe44lYq+h4dTpJsFFZB1bv+vnXr5hVJ1B4ZtBRIRiMKLGobzC61KblNATbak2yEZs86Sw1WzhBwM9jeXpTJQ/Ve/a1Avo03bYoJzDamWWVai+8fmLUS67TVZPIIPPx3L
 hzt8KTt2
 EQKm5d8nopiEDIoDDOe/CS1mQcrXNqWWoaEAD0fpag9ZnrhJRLrUKV6wu4RivoLeAVnTAmvzU6bqWe0sz4p9tacjsPlBett/AeRTUJ2rIjie0H7bI0xft2Su8LamJYQ8xEJgQc7/pllIE3FDv7yKZm7q8F2ZNKqaTk4P2GBTewWxvMTcwTsYMHm8SQuvg/ek3i3ExQtGPwmA4I12Pbz9tq7QJwRQsNPrROG+hcLmXAnfTo6jzEERYxFafDTnSmvz+pN1p6AMu8UxOij33s2JzOvv+ldVWhYbCk5+xKYezOg02f9juLIlIPzITrz0T/YrL1lNUHhz0fox/oqzqbEPyjp7pyvmEiHZmIPKzykS01vQtbcKcMbLiv0zNdb7YUAbT9rHdIGX4sxz6PCE+zB80mw8DGSMiuoGVjBW8681CotaauZFKNQ6rWr2/yleZLXa6bFK6sSWI8NssJTUh3HufGU54PI4oUN8cxjrc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 09:18:13PM +0200, David Hildenbrand (Arm) wrote:
> On 4/7/26 05:55, Miaohe Lin wrote:
> > On 2026/4/4 6:31, Lisa Wang wrote:
> >> [...snip...]
> >>>
> >>> Will it be better to add a pr_info here to provide some information for users?
> >>>
> >>> Thanks.
> >>> .
> >> I think we don't need to add pr_info here; truncate_error_folio() always
> >> leads to action_result, which already logs the recovery status.
> > 
> > No strong opinion but I want to make code style more consistent with sth. like below:
> > 
> 
> Yeah, would be cleaner.
> 
> > if (err == MF_DELAYED)
> > 	pr_info xxx
> > else if (err != 0)
> > 	pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
> > else if (!filemap_release_folio(folio, GFP_NOIO))
> > 	pr_info("%#lx: failed to release buffers\n", pfn);
> 
> Maybe we can even make the failed here a "Failed" ;)

Noted. Will update in V4.

Lisa
> -- 
> Cheers,
> 
> David

