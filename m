Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328B4106ACF2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 23:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583FB6B00B2; Thu, 12 Mar 2026 19:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531946B00B4; Thu, 12 Mar 2026 19:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413146B00B5; Thu, 12 Mar 2026 19:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 301736B00B2
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:15:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4AC11B7F50
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:15:49 +0000 (UTC)
X-FDA: 84538970418.08.05B753C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7257C40008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:15:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="W/09uimW";
	spf=none (imf11.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773357348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjcR94bmvH2oOH8ZUWLFU9TNRvfPfrpZ+1MwNkcZH5I=;
	b=nlAeDrJnCLTtmxkkKRPInITB8sq3LW2v20CANcBNoct2sKq2CUuoNTN19V0ohYRHH9E3/S
	v9KmkksOrdqa+Jk4fH+Tn6mU4choLJHBb0npFWLWYPA5/zZntSpg9gvydFuDh3hB/5LkSq
	3grAxQw0m7koHty6ru5nKk40DajYGC8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773357348; a=rsa-sha256;
	cv=none;
	b=yvi3d5biO53nw0g5G6dy7Q+4LOisdr4sdMToqLFQxnyfkuCjzo1+JVkpgzu665fQZiP68l
	WK0aC0FWrwjM5vAk5UrEo8X8JSmmQoT0BE4iZWIFe2mzWMWKt1wunaARTi5ESszMYlMlT9
	Y7xaiv8KKuHTla860i5GSK9AHn+/ldw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="W/09uimW";
	spf=none (imf11.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=LjcR94bmvH2oOH8ZUWLFU9TNRvfPfrpZ+1MwNkcZH5I=; b=W/09uimWlmT/Ysq3jgNMt1gI7H
	GOweGLT/9vNXsJOPg9hm2zWvmdX3q1Mku+Gp0H9Iy01Esb6LQV5ATBVsFtN7xIiUoagCrBlANpDjy
	LFKllY8nRMXqP5YIQU35yhpjR6xLflNsnx64mvIpAEWYWRWDPhCqNZYr0PnzOZoWDQK+FM4dlVpqj
	nTXMWJe8aCw5gHcb65NFh+tuJVdjDY9IaRhmpRA+PnQPWNf8cS/Xo1D5AhzPt2W5l4FH91HqP8G0U
	kPRc+Y45RDEk4AoFzuVcdgRIIbo7k6atO+7RsPG8yCEeiefwSsO6mHknQo7wHDNJwM391bMo/EMJe
	bffBLL6A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0pFY-0000000FkNf-3iHP;
	Thu, 12 Mar 2026 23:15:28 +0000
Message-ID: <4fd15134-ae1e-4233-8d5a-9d1e0b9f94dc@infradead.org>
Date: Thu, 12 Mar 2026 16:15:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/15] mm: add mmap_action_map_kernel_pages[_full]()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1773346620.git.ljs@kernel.org>
 <21d8899bb1f4db61203072fb3a56a6c98a61e23d.1773346620.git.ljs@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <21d8899bb1f4db61203072fb3a56a6c98a61e23d.1773346620.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7257C40008
X-Stat-Signature: 1a31pi3qfnrpqdikg93o4pq3hx7ndgsi
X-HE-Tag: 1773357347-918563
X-HE-Meta: U2FsdGVkX19UfMKtu0M1fkWPprQ4TE2ODmuy8NKw0PRqd+KVmgMTscgyUf9SuLTzcy5OVp++jMIt8gS1H4KY6QMa5JQIU0jfT5KZYF6jlomouMtO/JGUrDUpclJMEUrZG8bDguOI+BS4FnlF3agWBQFHB+lqOKjbPa8Sdjz2AWIHlc9e5fQQsrjJYAy5Hm11i+M7R8dLT0wHAu2kBz/tqWURqf14EpnmrlrEQVd7J9OXu0skKzr1ier0xZyEQFxvr/l5otsGHqoWdZD/R1RIHcBHhs4N6BWA6Lw2pulttsKixqWNnFOa0uCAy9U0cuwH/bVW4RphIGfINkR+kpdV/ECW/iirceFXMsr92W31ASQATL78m3dpV2f+rtry1xKPFTyRklIxziA8jQmMJ2XRxV66YJ+4zSyvbj5tHfdSwNjPL8KjgLO+3CRXP/N/Mntvq2esoRUWZv1eZwVAWFMYGGO7WdOzymyeple0TeIgXTUU0O9TfB0131PgKXBdIj4s8+Dk1Z3gmZU+NQsmnq2Wq1th8JTOA01GRXc1zD4913dGOd2CGxledcHrz8IfM9g4H/LhzKGGa782V0oiW7AHs20j4VGpiU10jvjAqBjLzrzmdIrL6nUPTovUQtEhWOpFbaBWV8fS5zxRkfUyNOsO27kW1Y2JOz5GKyLuvBMP6O0x0kjlVqxfCvBF88D5KhqYzxikilN3Nqm7n6w29hUHY9d0zvy7yfjAlkUnc9j0UQ3Y4sSiNRkIeRJxcCzvxH537cpVQ+NNduJHfFNnMyDilQgTULwW5tsTogUW1lLCBnboEHeCp8t1+kMOTorcyMX7DJef8LV1+eHFYI1rHLQmEq1ov/rk9WleP3j5hVoIif6esPmNzsyxKmOJAnsONzunjyp+TBU+F62eSxbybgknqIW/G4kfcQBHmuPK72uk93FKZnuAi447vnjBhL54rmrOQ2HcK5avgDwxynw1QfA
 3gX6fTSb
 euKZvrO1CFQsE+1ahvynJm1zrnrwdnzHNdecLkniQFZ/loBbWPCOw01OgPkLTNiRVS6lmF80Th9o7pUABUn7MiENUqkVk7EAnaRrKi2/YgxIsR6Etc+KB6G0A753jWkfpwgRYHNge9X7uNUrLge8io6mWIFTmjLGlzHCGPxhaO3tEgxKSY1RNJznTihbPl7aXdCieE79wUW0Mg1M+gB3dmC3rrC+dtCHb/Rj4acw2AaoYEDBblYiQZ9KYhqRGHVN0dU2ABJnIL2GZKAWgjDspVicjhVn8SoYVlJB1quy5C29795v6Ay5w+i0vLUE1o8YKJHEHpuv2Md7dReTHLU6qq9XlpfBwuO2xVE+RwjLT/q88xhCUBxTUVpJh875b/Hk+qd14ZcWIWW4nOqgk2ogUi9fJ6YINQqMV94I+5uxiEXb6YjtmKqPW6Z6uPx6cNQAIoyaF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/12/26 1:27 PM, Lorenzo Stoakes (Oracle) wrote:

> Finally, we update the VMA tests accordingly to reflect the changes.

IMO we could omit the word "we" 5 times above.
(but no change is required)

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 88f42faeb377..88ad5649c02d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h

> +/**
> + * range_is_subset - Is the specified inner range a subset of the outer range?
> + * @outer_start: The start of the outer range.
> + * @outer_end: The exclusive end of the outer range.
> + * @inner_start: The start of the inner range.
> + * @inner_end: The exclusive end of the inner range.
> + *
> + * Returns %true if [inner_start, inner_end) is a subset of [outer_start,

    * Returns:
(for kernel-doc)

> + * outer_end), otherwise %false.
> + */
> +static inline bool range_is_subset(unsigned long outer_start,
> +				   unsigned long outer_end,
> +				   unsigned long inner_start,
> +				   unsigned long inner_end)
> +{
> +	return outer_start <= inner_start && inner_end <= outer_end;
> +}
> +
> +/**
> + * range_in_vma - is the specified [@start, @end) range a subset of the VMA?
> + * @vma: The VMA against which we want to check [@start, @end).
> + * @start: The start of the range we wish to check.
> + * @end: The exclusive end of the range we wish to check.
> + *
> + * Returns %true if [@start, @end) is a subset of [@vma->vm_start,

    * Returns:

> + * @vma->vm_end), %false otherwise.
> + */
>  static inline bool range_in_vma(const struct vm_area_struct *vma,
>  				unsigned long start, unsigned long end)
>  {
> -	return (vma && vma->vm_start <= start && end <= vma->vm_end);
> +	if (!vma)
> +		return false;
> +
> +	return range_is_subset(vma->vm_start, vma->vm_end, start, end);
> +}
> +
> +/**
> + * range_in_vma_desc - is the specified [@start, @end) range a subset of the VMA
> + * described by @desc, a VMA descriptor?
> + * @desc: The VMA descriptor against which we want to check [@start, @end).
> + * @start: The start of the range we wish to check.
> + * @end: The exclusive end of the range we wish to check.
> + *
> + * Returns %true if [@start, @end) is a subset of [@desc->start, @desc->end),

    * Returns:

> + * %false otherwise.
> + */
> +static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
> +				     unsigned long start, unsigned long end)
> +{
> +	if (!desc)
> +		return false;
> +
> +	return range_is_subset(desc->start, desc->end, start, end);
>  }

-- 
~Randy


