Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E45DC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4870A6B00F5; Mon, 29 Jun 2026 14:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F4B6B00F6; Mon, 29 Jun 2026 14:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C066B00FA; Mon, 29 Jun 2026 14:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14B926B00F5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:17:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82855120243
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:17:57 +0000 (UTC)
X-FDA: 84933758994.08.F8440DE
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id AE683120006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:17:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F3MqQiTl;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782757075;
	b=CtBYsykWDVjiSvEihT3FJzbJjS4bt+zB/lRbBRY+37/qnz7fNt3yA3hbpCl7NJAuvrX1S9
	Mco1SlMzFkllRc/qqIQ3HtGA8dKYI/bJjw7OZEW65AWL1cxnIEZwwAhhO3QeXjf7jXW1LH
	Hi0WSwAe9nUC1A9cC1fCIsoBUkjL5Rg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782757075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfUxWLWQvY9mB/81AVkSpyLi8QxfdBiALIQMC7mv16k=;
	b=XxRGu7U3M/DGsMZWTwYfdevMOBO2Q/Uf1m/yEeZmQVdWT8iQcafNcfviMDYxxHUSIT/GqH
	6kVNDN4HjMhcIBrrxMKZlANFFv3GkOGVJZn+/IFfb02C1oIxfFYwrgn0up/4uqH1LiCv9Y
	Un4ojP68ZjutbCH3BjB5FVCwKHxoLyQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F3MqQiTl;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-13986d61b4eso8626613c88.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782757074; x=1783361874; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VfUxWLWQvY9mB/81AVkSpyLi8QxfdBiALIQMC7mv16k=;
        b=F3MqQiTlqgkrGFSrL3e4WqEb3wPc8ruIE/JfMt/4wIRxfhd92a1OF/lFodviVreDzb
         /6sLLC/3FxT4GfLMA/vbapRBIp6l22c0RcnO9c6HyfZSAx1Y+TNeq6VHa6PtzpEHPz7u
         2Vk58MmI9CGEfAQ50dSkivtImxM4N4n+EPWFm0vqI/AvAkBB0pDXe2Z4wagNurdLq0oc
         q8oV7F14voOUkEnaavcbgmmKTIvxuAFG/xtt7+vT2NQd87jeglY+c97OnTD185BMOTSh
         FA0w+nTEWA3sUm09+VckcL13qCeeN3aeRRbam2Hxs82n8nuLq0xKyGrC4vlwKG8Tz7A0
         j0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782757074; x=1783361874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VfUxWLWQvY9mB/81AVkSpyLi8QxfdBiALIQMC7mv16k=;
        b=tFUFpF2Xu40NxPFuUyxq2cpJDnbosLm1uelTstqrf62WOBlL2lF3gR+Z3SB76gb0Ua
         4qM7cYcHQY7usNAEpfJbBMk8LUth8oGOJmQ8vVBuip0co+7cpL2HE6PQ6+sY0vH5hqHy
         uIK0Wfz8JIp1jpWOdZ0/noO4aIlFErAMO8/4yst3WFs3Nq0vzTcs0P2EgjB8WFF8XYBh
         LoYLJlWY7myRXepZq6n6HKQeRHw2Dr0yx4hOx49BSfsR1lsH54Mh6Vx5vbc0JDSh6f3l
         /amO7NLjOcfWRx6HjRIjJDEsLu5Y6MPFdDv7gfBCE5gYfzPTWs7fwSQA/INspbdiDtWz
         viYg==
X-Forwarded-Encrypted: i=1; AHgh+RorEcky8WXukZ5oxtDad4Eeu0DB0CYZpw8H8z9pRg4gMy+1/H5igDLZ3MauJUT222Oz7o/0hqNhsQ==@kvack.org
X-Gm-Message-State: AOJu0YyfNeGf5rlKksE9et8r3QokGK0GhRfD+7TnN/sLq4+Sn5ZFgI9e
	UzplClybSdcK+pxda6ok4jYW0j7saG5WegYJwIUgJoZrGr/tVY/gxnkj
X-Gm-Gg: AfdE7ckdWIYW+6MjhwKACDu6oGibare2BAo1j0HZk0pSq+4kSY+/FaIjSRFcyo5Yevt
	WljkX7tVBvnKCNIi8oBGJoL+jRSXUu47IoM2bMUYc+rudFgIJVDucUSH5V26ryfOseQ694JR/Vx
	jqkGY3E2fImE+kNO4pUE8o8I6m+gTBtUb02Sdpf626SxSuYCOFim3ays3JSV0m/+LbYA4R00Fpq
	kfJeE5w5lQQX0bQbBilxiOcB4HSgc70A5KyrYb2fv6ky+Ture/bOgktYoi85fsbG/hbDIqXQvZo
	TmW60ZEmD1ZljP5sYNWA5gAGw72nhSotBp2J5jcRK1CWL1q6hdAtr0dxThyMDu7jL7Amnv53pda
	WwMSVjvGrWuU/0ygZCSdLro9rYbGf3HVFAA0/gObmBckhBtoYA9MhGol4IX/Q+Nhms3zNU3pi1d
	/9n85JK/U2FhS0z/wxR20DrjSCyIVD9HHyxgiK38BKcOmg
X-Received: by 2002:a05:7300:72cd:b0:30b:f5c1:4484 with SMTP id 5a478bee46e88-30ee13a2040mr379952eec.35.1782757074358;
        Mon, 29 Jun 2026 11:17:54 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2fc12e7sm70363eec.8.2026.06.29.11.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:17:53 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:17:51 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] docs/mm: Fix braces
Message-ID: <akK2z2q_OWiNBpYO@fedora>
References: <20260629161156.90213-2-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629161156.90213-2-manuelebner@mailbox.org>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AE683120006
X-Stat-Signature: dppui36xnqzn3gs994fi4bwjetirqaab
X-HE-Tag: 1782757075-303432
X-HE-Meta: U2FsdGVkX1++y1pxWxFnLhkh9AYM+DUJk2rUjDc+r5vKg8L+qS9cLYyBhK5wo83nCp0yAkobqNkLw0pi6dQU2UVruwTbl8Xz6JeaJbwtjZpLhIWW7Z8xWTTdwz8frhnTLsJwN3d45MOdPj6ndVSLQeVK0ldjGxihQiqqPUgzM7OwYQCz0DY3UvB4zGsET8Y+30dPovD42tB6odP1krYZu/EMFjnJ4PrR61h/c1Y5ybBQFxNfhI8n1FGRc+JfWT1O78LtZkFaXc3blYTMQ2q6/AYCfgIK3fV6GhHRzsl8iUBL6WtC46xAFp/WKSdf664h681GZs2Bs/IueQtHPCkNwfWDYgiKcTJ8cDWK6pVo7Jc4SVxdV2mmwJAFGUdSBBqpDHExNyvmdhqmY+Sd+OQG2BEWBjN5oN9WO9HNEep14WRft3UyItRiDMHw3MzAf35vWoDTpu1I/50tzS4otsujerDx2jFQocC5zZCWGVH7OGcxjlF6r88moXbFxkIB6O1SUT1LdDBzAkn3lIK1zwx+wrCrKw9RLNQShOQkjgnEVcKo5pPirii68S4MRl9O/I+bgOr5oRF16kZcR3h3yBDWH9QkuhNqmFbukesDm6LpztiMclagVkm6GNCoQhBBSTEmtD0jupztXJcq0oWG3G7OMGzScEYVTkg46YQ7NI3ecttLKE4KTwljM+PDYeJXGsaTpjWEKqFbiXOw+7/NScD6EN1unnLREespfaHn1Kcj1zo/PFNZvkbWyRhjibWLqhCDuMdmtnWEP6rRBs4rdq+gP984rnK0c1YJrid/k7mK5lo2jrpoXhgXFbs+ctKVVzBYQqixS0/AJpkobAfzzoH9qSrHTTHoIZ/s0GgFhhECk7cfwRAENPrSut/vC2HXa+lxCg4rVKaGTr8llh25xySQbOAGvZTtsrKcvToWQmPp2BOOVf/pTa/XBSGlnpedYcxzrhJ8bsCZq9EntAieyGm
 nS3jCSkV
 qgtj0Xt+ahczOA7C7G5n7fMb4Wktf0TSUCQd+0ssLN3XstfZxCdRKC56uPzo4sEw6xJu6cDfUwSaswDrClOUh39T6ICDkMTpDgg9HBX12ZNEln8N1a7Dd0J/rWcCVmbIQa/QC5niyGs6ssT7jOahD1RbNLheGfE5pIjNYXp1PhzCD6OrhZlnTDCTB1AJvWpQJVgooHYwqkBP6+7Qey7YjkqAk00ibokN70t3dsI13B+Qe7AbWtWI7ubIrE1Ckpf1lzl+E5Ag4tkn5r0Ntvst1UtFBs/bzG+JMN8dcBOuB4U+g7+T6J500zLXqgdWGzpgRnbZLb/9yQbfM4c1ruReMOD71z2ylxXEid4+p1FQYD2nGqtrKafvMOa6RxkQtXXuWn4bj8ygJUzABfgVEWxU9GXYtrYwmEzQYWDZBzS1AErieFBRaF/A73No0nkWLeJVWXpDdM6C7KVKwdimwH+2ii+6VfYvi5M4/Ym38Ye63hrTR5elnKc5ldiv2A4tJlKxcw7vnFQyPkSEB+I/CTlg09W4lpQzLoCctlNppw4/YHc8ZHwwsxQrOmQ6UqUMWs6blJqkmw3YbCUkMu+xCM+oeo+eFsNqVk7h8BE9QhkmoYCvFRoftGUF22+81VTCXo8PGkFF9oFoGYwRnw38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 06:11:56PM +0200, Manuel Ebner wrote:
> Correct typos in mm documentation by balancing parentheses.
> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

