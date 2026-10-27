Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC48606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g9zqbCpz
Received: by kanga.kvack.org (Postfix)
	id 3D0466B06AC; Tue, 27 Oct 2026 07:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7426B06AD; Tue, 27 Oct 2026 07:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BFEF6B06AE; Tue, 27 Oct 2026 07:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA846B06AC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:01:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EC4CC09B5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:01:48 +0000 (UTC)
X-FDA: 85368115896.01.28AF8A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E3FEB100014
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:01:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9zqbCpz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793098907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fsla96GJDZgpbBbLI0F7GwJBHuZuy+RtHn6YyA2Pqg4=;
	b=BzMGGaekaCBcJU+uv3uie3J6IGlG0fIKorb0QIeg1QkB69xMQmX6Y4XsjdGSXx3I0Jf3ZI
	TKDq9hWCey7BmUJRkWwZLEUM0gY63DBAP0AL1RFNwPU0MEycdbHel9ODIgiDk5+F+nHNjI
	LruL5L3XfMhFiAZYrHfXV/UzMP1+k/4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9zqbCpz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793098907;
	b=raIU2+o4G6HgCP6TbFBKK5Ha5I+FcHTgF3OiUuMkl06nOlyGyWZvQpc1ntuTr32rbbFg3N
	7ebAnc4TuiNpUiH7CNB0y7y90R1XMuliyopaLaxGh4tFnkyNHEZm3B2a0YXmsnB2czvIm/
	cyESmauDdm8z72eQAsToZwzbXsZjmco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3946240E20;
	Tue, 27 Oct 2026 11:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C31F01828;
	Tue, 27 Oct 2026 11:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793098906;
	bh=Fsla96GJDZgpbBbLI0F7GwJBHuZuy+RtHn6YyA2Pqg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g9zqbCpzE449qSwJ5mBwjwoFWJVIAqIBeY1ypOKL+ctSEXm0PW3l8pTSthbh31Q8U
	 E5jPUW8eYhvT/A26UEvgvjQGzDL0VO3xZ1rtBD8zrUgsTrVihabJWgKL9dZ8gamGdC
	 t5OcDR9GXLvaLbMOSiF9TwrP5sFtjH+dl2XQpba1FrlYLpTY7mqv1aoAS1eULp3gkv
	 74tx0aDaJrlVWAYWpKEc2hZdRMgJBMpGdJduC/AbF5W80RwoWyA6R1bzJerb+PXLD/
	 y8Pz/sMmC2vg61BvDNDxST7GfeAxV1gFelmQOwThW9RKdG73AKhujvrbgdvGUYzbRF
	 U0tJOWmjuAlkQ==
Date: Tue, 27 Oct 2026 11:01:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Li Jinyue <jinyue.li@linux.alibaba.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: reset the VMA iterator when merging a new range
 fails
Message-ID: <auB2uBW-EWvfNgzZ@gremlin>
References: <20261025093921.1011927-1-jinyue.li@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025093921.1011927-1-jinyue.li@linux.alibaba.com>
X-Rspamd-Queue-Id: E3FEB100014
X-Rspam-User: 
X-Stat-Signature: iziicoujgwqbx3bxcrnzytheeadt8zx4
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793098906-617878
X-HE-Meta: U2FsdGVkX1/nbx+yAFylxMdC0aSfcmMIAUTnZEwTN6Oh+etQDXmo2f4ur0kDeGHaOsR8gRgzWsoUXXCla9cI+nJATs/nzlkOckponK+USN/bfdrY+p9JVyXsDfP8FD22VVgtNzUB79pvjXvDowPgD7BJxWYfnmSBmMDGduxrhBoLRSKBpIq5Heh1YHSbcD7wZobyw4NSUO8GYzTkokGiddvBhTYXoR3YnMSXlaNuEK3qiCo7yXbtfKPUWElkX/IOIK03bOIGOwkiRQRG70wPnOu+7b0kivz9/8a5cbWU1G/FJXw3ysxlZYNA3IE4h7mG0iOEeIMz9O4rHYOPr4ovVyTmfAna1ckouesgFCxLrkYxLffhlLsLhzvOMKx2767JwLXL+g4+6vvn55IfvTdWlkSVtZ/Fc0WtjACr6tv8qwO4HTrVihnlUCTkv/lpygV47Ke2lD4WqdAN1KuE1onfxHDkfQYyc+GXRr4gBHGG0NwWI3n7MWa73CRJl2Mwt0Jf35rf0T8VPHUenYVabBzrhfy39rbWz6r/bgI6Xta6VK9NOj4DLauZOKNo5Z9U06BPZRKGpt+9x8yM3R7d71A22MKpw95Dm5klU+Yh7GcESTxAaK51x/kPQKXwTevqLbl2SwtQfrZ0QepUjc3DaGtw4PNUtDPmYYy8aGSKknDuSRJOx4vMoT0ORxgHhP3Sadi6gPLJ1oT7645cEu8/IQHEXDsHBKTH7s/5dCzYJVIDOlsvT7YSU/LIOR+KXy7bOM7pGD1TWFzsnt241kEOz8jX3FqFQDbgyr6LDxZPIS++GJwTNa7J+9t9SqnbrKZmVhXb3b2WjzhWJB0ynug/I3GTU5U/NmBJFSkYM5Q2o4zO7c39aAZZwVJeZQK8xKIRRGpatMcVUkUrmeAKCzxU1UFBCuTEnBrX4ktctoMSOdEjC32jZv5UFklaG3oFYVyRuG2LwVwCfkekDgTEEsRQnYs
 rqJhIXsx
 fE+eVBlhy+VbVMLd1/hdnwWbyPGGJkqLx17AO7iYdwERiIrxwo9ogvARpFZ+JfLSRDloJ940zO0MEMpOxpXOZYryI07Gg+k8ZDf87kYdqAzR92MRt8nAChiFEIKHIivdOMLwejz11uxTjoG9XS3BsY6riqQA0e0ca0jiQPZOp5yGSN0nwn4ENAK04Npw6kFedHbpR71MjyW/bIVLxQeCLBqKvOxLFYizSy0ZcqEKtF8AupBRrlPaX/Y1S1Y/7ra6S1i+6HTdsIWGZH9FslTdm7RJKwvh+sXc4hQdZhqvO2JOnqnwKD7zeRYIysSYpGOlC24qj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 09:39:21AM +0000, Li Jinyue wrote:
> When the new range can be merged with prev, vma_merge_new_range() moves
> the VMA iterator back to prev with vma_prev() before calling
> vma_expand(). If vma_expand() then fails, NULL is returned with the
> iterator still covering prev. __mmap_region() falls back to
> __mmap_new_vma(), whose vma_iter_config() requires the iterator to
> already contain the new address and warns:
>
>   WARNING: ./include/linux/maple_tree.h:796 at __mmap_region+0x1a04/0x2398
>   ...
>    __mmap_region+0x1a04/0x2398
>    mmap_region+0x304/0x466
>    do_mmap+0xe7c/0x162c
>    vm_mmap_pgoff+0x1e8/0x362
>    ksys_mmap_pgoff+0x76/0x402
>
> This is easy to hit with fault injection when the new range sits
> between an unfaulted prev and a faulted next, so that dup_anon_vma()
> has to run and fails on allocation before the iterator is
> reconfigured.
>
> mmap_region() used to reposition the iterator itself in this case, but
> that was lost when it was converted to vma_merge_new_range(). Restore
> it in vma_merge_new_range(), and only when the iterator was moved, so
> that the common no-merge path is unchanged.
>
> Found by syzkaller.
>
> Fixes: cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs")
> Link: https://lore.kernel.org/linux-mm/CAGfhM4AaEygReogOAmkmu5UfRYwoBXAMdLMBi4jbakNONbpsMw@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Li Jinyue <jinyue.li@linux.alibaba.com>

Thanks for the report, I'd rather solve this a different way, so will send
a patch with a Reported-by: and Closes: to this one.

--
Cheers, Lorenzo

