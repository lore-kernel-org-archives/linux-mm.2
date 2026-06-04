Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F73CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 13:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A256B008A; Thu,  4 Jun 2026 09:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35BE6B008C; Thu,  4 Jun 2026 09:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC9E6B0092; Thu,  4 Jun 2026 09:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA3B76B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:57:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7351440746
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:57:24 +0000 (UTC)
X-FDA: 84842382408.10.CC40627
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id AA715C001C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:57:14 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780581434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdOeHpgtDPCXpgtRakSCpJbRBMD6e6ZeQ1aGekC0AxI=;
	b=4vjAPz9kBIeYb3s0jlxqNpbxO+uBzyFvLC68qP/RJ+VGxnTOP5Yrs+dDnBBun1tO2cnjiT
	UwPcW4rU/MGNteSYsaYVL6zkywVksmg/ZvAF4ELOvY6KLk8JCyncaZIQFPUv19uvcmy0Fo
	588AVVb1Y5ILgv5hKfYaHekjexR+Nuw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZYtOwj1+;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.42 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780581434;
	b=rpxw15yNlyPVtZBOOvy1y7XirC8GE+lXO6yozB02R+lwhWY7LyZrhLevfqELu3XEdZCipw
	mpgtzPn8gzEOB0JXDFUmpImySO8Juyn64C90+BdKlp1ipYAMDbWuDSejA4b0BcKYnz5Kbn
	AgabtnH4rGgQh/UAcNuBQnYzrR4iIok=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8cceb2ecc03so5938486d6.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 06:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1780581434; x=1781186234; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xdOeHpgtDPCXpgtRakSCpJbRBMD6e6ZeQ1aGekC0AxI=;
        b=ZYtOwj1+XQH4McabalXPMh1MISo9SGgqRr0in11ExdqHUgKRYOsfyAMeBbdgLRSGQL
         jJj//CvYc2wCx1Pkj3U2YgGFkrPxmMC72mM7T9rN7cVqW8KuqUzvcpZopM6JbAk7f8tG
         qsErQsKUphO9EL75/HMx51KM8FwhYzYtST9m5CvexLPwZvq7WnOxBc/zUC5FZOz3A617
         X3s2q8+QA6WzVqO9ITDPFW6zc6mO8Ktvu1YR/Ae/VeGh30/2r7iUQL44HfbPw2Fd8F3A
         NuFy4AnRZ3k4LzR5m9/T+3eIx3HaKWGGssliQCFQCjThsXqmPQy+0pfz788B3nRVFVj6
         3S6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780581434; x=1781186234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xdOeHpgtDPCXpgtRakSCpJbRBMD6e6ZeQ1aGekC0AxI=;
        b=Ex3TZ7vncMQsLJsUURHT5u7r3yTkgY8HLXKOECxoFKM4TfnZN+G6D2GK2mSkHCp2N8
         QL+TG8BXgrINxn6N9mW/kAX0DVlZq/xvNRIik/5OvjwCKXQmdkyoMTXQbhlo0KO+0Q6U
         GBfyFyBFOy426voZqGyKZWUHcLK2xPsDHGd5plY9oQ7IgOfVeY0siPGllklTvI3bk+vi
         E77vHgQdLK7oy2uaX9uIqQrQBeZRgaXn2HX4FTeOMAjAggVNueFwq8h4ZIz9QT/fB9ZQ
         X+RgxoO9z1vC2MKyL80s/plHoeqBu6joslvBcGtug9OoMvq4DxIFrPeDXxyipRU+qZRv
         c08A==
X-Forwarded-Encrypted: i=1; AFNElJ9MZDVZ4TmiuBnP9HZwExcZ1JDR/NF8PlVaJiJWhnDK1kABsU/MsIGOCj53QTwoLEVMzdZc4BQyFQ==@kvack.org
X-Gm-Message-State: AOJu0YyS/fsTcdm2hRzxddj684iCUuSN/N6NX6V5zfVvkSghi1DIa8y5
	Bmp89FgYVOdsOJ5Rvj7IiiiZGw44IK1XnZsoPLyDF07GuKCWxd5WfdxzkxUGPpZzKI4=
X-Gm-Gg: Acq92OFGPgQXF0SC5JZVw9ima/8A6Tvnkd40KAiGxw/U/2uOnUu4dLB+H/kRBK32XmL
	1jXiKmzXw94aEjzOufQNnxusmMUENC3vAjKnpldj4X3jTSSRI5jmxqAyy99hiJUbh8EH4YBkxta
	p5OdbDoZ+2kcz9u2Ouvf+JJd4DFzstUHyqSAORfpbVEV+2nd4H0ornJwS75ctpROADeuIGPVS6z
	XagyKLA6rAZReucLkHsHOUzbmwxhubDCKEdDXVflUorjDmtD83wAnKNINsEbzkdb0+a9NVbyJYs
	1yytBO1bO9VB1s3aZ8mEHw7Ff0yfiZpMY13huIG1FKD36jkILVmoHPqlTOZ7m+L3X1HECBnvghM
	JQ5qFbZpAveMkfjlLlIjHyS2oeHB62yfEeRe0Cu6ovCCh9AtJOMhu8aSe2Hdvu3FyupV8X9ad/q
	mFhmsEZHBivon6mKPg28OHvLAA8GaiKnc2uK3NVjfbgS5vYsDX/yCb57Rbrd9rXcLIAW5oJQrGi
	m3YXMGtPGbteFFktCH9/sl/4mU=
X-Received: by 2002:a05:6214:800c:b0:8ce:e098:d974 with SMTP id 6a1803df08f44-8cee098dc5emr22722786d6.6.1780581433691;
        Thu, 04 Jun 2026 06:57:13 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd07629dsm53598296d6.39.2026.06.04.06.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 06:57:13 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wV8ZM-00000008FiY-2nrt;
	Thu, 04 Jun 2026 10:57:12 -0300
Date: Thu, 4 Jun 2026 10:57:12 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Maxime Ripard <mripard@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
	Christoph Hellwig <hch@infradead.org>,
	"T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, lkp@intel.com,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
Message-ID: <20260604135712.GV2487554@ziepe.ca>
References: <20260522225853.878411-1-tjmercier@google.com>
 <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca>
 <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
 <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
X-HE-Tag: 1780581434-861268
X-HE-Meta: U2FsdGVkX1+uqfSMrZfF6JMR6ZsDLErLhxIpfM9gP6qTEKwn27D90Xjhr2o/ngRvNAcciffg8BtkcfmwRWrGAhEsyRpxWPrIMleV8s/1ANkKoicN82Gi/TrE/Dtk85uPUwHCIPjRgjZ/2AIYYGIm6K2N8aMQKG6HSIr+alSSEWZih3s2GQab0yD6RqHrbCjSmQ+c8pBRI6EXfivnDpPLXWWOb+/XNMzKLQyWqrXGjBaczYpNV+nLP/YMyInMkRZEkjgwzi1lM7hsZ96B4n50mFCUMIVMeju6f1MpNV8FdlAtjhibNtG1XVk/y0b9jPzo4Nc4AZ2imD/kJhmn3uOK1tpG4dy8l96r3qgeln2j1+8XJr90NwJW1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 12:51:49PM +0530, Sumit Semwal wrote:

> Given that Christoph's objection is not really about the modules part,
> but that the set_memory_{encrypted,decrypted} should not be used here,
> one option is to revert 78b30c50a7ac until that issue is sorted out?

Please no, we have stuff already using this so it would be a
functional regression. Revert making heaps into a module since that
doesn't have a functional regression.

Jason

