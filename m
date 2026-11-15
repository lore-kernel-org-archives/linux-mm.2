Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388C5606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=XvrNMgnd
Received: by kanga.kvack.org (Postfix)
	id 3959A6B00EF; Sun, 15 Nov 2026 15:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EE76B05B0; Sun, 15 Nov 2026 15:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6716B05B1; Sun, 15 Nov 2026 15:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5EA56B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:21:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 670BE80825
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:21:45 +0000 (UTC)
X-FDA: 85438474170.10.79934BD
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf23.hostedemail.com (Postfix) with ESMTP id E083D140002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:21:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=XvrNMgnd;
	spf=pass (imf23.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774103;
	b=O1oDUse5xvJQrK5UjUdf6u4FAgs4KQeuAD/ip9t6As19/hHrdm/oFRkjFFC/8xc+Lya19y
	1qyMMDe/8kZU9QDnxvfe0JXeWf0CaVOKUxcShAh7NpC4hLzMxtemlVx9QOG6YgyhK7+l0X
	cHgbTblcU5q2eGMef7fX+/08kTUERkI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=XvrNMgnd;
	spf=pass (imf23.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0PsfBl18AWyK4iQSGjFIhiNJ5cYD9CJo88yPJo17Sw=;
	b=hntjQ3Kc8+5QeJ6KwdSjgikCY2HBG5+3AMzlqQ1sYGb5OL3nHWUKcbc+ayIu/UO8BumOHF
	p4pr+vTuur1Hae3iMIgv37gxelCwaHebEb9GuKmN1VR/F8EehxRr3hXKQvs1FVpBe8yVHl
	Sim2AxV/jseRhUe5GveHfRwUpG3fRJQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=u0PsfBl18AWyK4iQSGjFIhiNJ5cYD9CJo88yPJo17Sw=; b=XvrNMgndHaNpZ6nydqFHt5ym3I
	JoO6LfNPmqvNLCvCUtifefbs196ApVghVh+ssI8jAiqOxccoeJTLFfV7Eythu/RswNAKG3qs92MRZ
	TqZh3qJ5g16usg7xcFH2pdIGn15MMB1kK2fGyE3Ik4Se/WXqpHCYfR65QrJmTCAhIDbj4dg9tDUM1
	0Gu2sN9xI87vKJJVwCXn0K5OCJShN/bXqKgL3lF7xcijbGCDAbRvcO1nF57pzjSjQQZyD0Xdw0xvX
	Zom1Ye3XPrS64aYtqiSq0py8QIMNrvXzV+usP4aBPkzll3p49qfPkBMXb0GV2kDxr86UHqUKXyBRR
	XWxyxKog==;
Received: from [::1] (port=43856 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xSgjN-00000002LVQ-29rC;
	Sun, 15 Nov 2026 21:21:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Sun, 15 Nov 2026 21:21:39 +0100
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato
 <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, Nico Pache
 <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau
 <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
In-Reply-To: <795b8d8a-4f6f-451f-9274-ccb8380e03dd@linux.alibaba.com>
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <avYBFPhB46XWAG4A@pedro-suse.tail5790ac.ts.net>
 <20261112145036.97f74a828755d5b9178a3e3a@linux-foundation.org>
 <795b8d8a-4f6f-451f-9274-ccb8380e03dd@linux.alibaba.com>
User-Agent: Roundcube Webmail/1.6.20
Message-ID: <824c33ead7a2baf08715fe01a4c88714@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Stat-Signature: g3gdgyoez5itg1831d8h67qa9rnngsk9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E083D140002
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794774102-962429
X-HE-Meta: U2FsdGVkX19mD/oKCsM0QNCCj75igXfkJhqse9WA4HFVI1ZEDb2yEV6fEtLpaFTe+c0bj4z1tI9pCjVpJFbCZzdSq0GA2PGvdO4XEPkVaILzYdr3v/oMh+HFZTUruZqXhyv3DuJKqrSJtEJphRMfJyi8QDc6Cuc2sYHDKE3QsQR25gj0oGP68/cRC7bZxJ82BZtWC1qfTbrNlnMM33NodtZ4ve+W0Qpd4zCpH0l3wUxl1/3erdCyPFjCmhL+kp0+2vFt1TvG7oFPqm3qVS53vWqtsft0tBRN25jTIIIa0l9cIs06zXhcVd068GIngS4jTk1V0p1BvRmumXsCJTUrBStTayAMf17nAEydENCPFJoEKBVLYYT6dQv8sVDQs8w+moeNgdWMAim/mNZdZIJ0C2bn5T4nV/RvYT8Lh2EdyXlJUOO8sWinDVSq6Ful3ogGOGjzl0RxXdcKRFuSUp3wrrXyrpnV9HLgFb8ZEDlbaHmUnjnzo/jRg97dmenWuqkMo6LFNO3upoJPoorDz4SPI1pc1nrmfToWX2dUrnCqwD/+B4LD5pyjDFK+Lw5sw0O8Zi+vZZc33CslYgak4L+LOzwqIV8jakOZ1/cR+fhdoTGWCynkX9IF2Z8Qa9U3RHMgtjlA0xcjZeKv6CRBSeNGoEbO3T3dkKHG1adLoyIA4GTsZ1YIXmqXR4InRzUdZL3+wG+6EXG4Ys0H59U8/+LovjubTHHcjpCNTqKwfszj50zYYx3Pg5LF7NUqejz9yA2VZ6XWSPCaUZG9uMHTr7pJWRjeYYjr5d6xCzp9wsEDHIi6jpxmb0va2Cr824fv88oIG5lS1ZxqBuKaGiuXLHm9w+JtUK0+Wd0PTCRVG5wvSWmiQn8kt5kWh2enFBo9zQGttqoRNiUzT4JzZMogtyOpclQ/2Dsa+Vzmh17zmH38q/zUwybzvjVtO78NZZ0TXQimpkXh2OBHz+gqIx3i/X1
 vbqZU/Qb
 YzVmvNVc80wKW/rXP5HR6qh/hqcaodBt1zKtiLM+TIZPQsoTrUkVwH6KXw7ofTLW/omKeyN7MOgjEptTHX3WPm7Sk2AvbGNZz89BDTxAEf/1vGqoTQOIrqroGQ0si/yZd5iDAPA7AXH7QPnre6mDfVZCbYoV/TK5hHQgtXc0zSqjqg+GXZ4YPPG1OKD/5MYQvsOXTDM3uz1myBblMulM01paf0a6SKhzISKNcfLFPfKuQAnSQLnKTKOIhUtJYnH5/yXumQq7XangWuZzIDttyyX9OhcYoZbHQpuYYBSGA9eBjZVRrXbSkrT46HpV+W826tbr/gDnB+UulHZfxtf8BN2e+5cftT25oCk0CfgyBLRq22h+42+heUgf/cvIBWC7bytEJoF56OoDYB0Wxr47A0laEPtYw5Jbru7NcszpgOHZMaV6GOIvEoagnZRDjBArobBrg8BwOa+sXTDb7//oWgP84ei4LYNasPz7eJC7VJl/NDYrMbeLefcq5G0lyiixf4u3PGTciWvyNYQz3gqJzBjYQFpsJiTJWG0JM6s4v8FEmYqbjffgKzy0i5BL9aDZ9/nrwQFb+qCQNwEz4ZInpSrMtS9NoNLvuU1XTLcpdaeij7YhTzno9xH+Ah88hQ0476D2FsYCTkINxhw6jGf3+4fd4Syy8Z83tR1K9kULBtvFvsUoHO4RhOvrfrWdbpOPb4rxgj9WqwXy5V5/+N6xi2C3eEdmXvX42V1kI8FLGo6pzpj0sn5ZQE8vth5GnxEeqAsXY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 03:42, Baolin Wang wrote:
> On 11/13/26 6:50 AM, Andrew Morton wrote:
>> On Thu, 12 Nov 2026 18:11:35 +0000 Pedro Falcato <pfalcato@suse.de> 
>> wrote:
>> 
>>> On Thu, Nov 12, 2026 at 02:23:35PM +0000, Jérémy Jean wrote:
>>>> MADV_COLLAPSE lets collapse_file() treat absent shmem pages as holes
>>>> filled with zeros. It does not check i_size, which allows one 
>>>> present
>>>> page to become a huge mapping that covers the whole collapse range,
>>>> including pages beyond EOF. This makes those pages writable. A later
>>>> file extension can expose their contents after F_SEAL_WRITE.
>>>> 
>>>> Hold inode i_rwsem in read mode while collapsing shmem so i_size
>>>> cannot change. Reject a collapse if its page range extends past
>>>> i_size rounded up to PAGE_SIZE. Keep i_size_read() outside the
>>>> page-cache XArray lock because its 32-bit SMP reader is not IRQ
>>>> safe.
>>> 
>>> I don't think this is an issue. shmem/tmpfs purposefully maps with 
>>> large pages
>>> across i_size, and collapsing across i_size is a feature, not a bug.
> 
> Yes. finish_fault() even has comments explaining the special case for 
> shmem/tmpfs.
> 
> 	/*
> 	 * Do not allow to map with PTEs beyond i_size and with PMD
> 	 * across i_size to preserve SIGBUS semantics.
> 	 *
> 	 * Make an exception for shmem/tmpfs that for long time
> 	 * intentionally mapped with PMDs across i_size.
> 	 */
> 	needs_fallback = !shmem_mapping(mapping) &&
> 		file_end < folio_next_index(folio);
> 
>> hoo boy, this again, See
>> https://lore-kernel.gnuweeb.org/linux-mm/nwkpojnictbg6jicccpxyfi63ol4tmfajrlx24u5xxoxx7lv5f@jkw3o7j6tlfs/T/
>> and enjoy.
>> 
>> It's not good that this sequence permits non-zero data to be exposed 
>> in
>> areas which ftruncate() created - the ftruncate() contract says it
>> doesn't do that.
> 
> That's a valid concern and this is a known issue for shmem/tmpfs. Brian 
> previously posted a patchset to fix it:
> https://lore.kernel.org/all/20251112162522.412295-1-bfoster@redhat.com/

Hello,

Thank you all for the quick feedbacks. I unfortunately did not find
and read the links you shared nor the historical discussions before I
prepared the patch. I'm sorry for reheating what it seems to me like
a sensitive subject; it was definitely not my intention.

> Jérémy , you haven't explained why this matters.  Is there some
> userspace code which is encountering problems because of this?
> Why did you propose cc:stable backporting?

My initial understanding was that there was a security boundary
crossed, and that's why I submitted the patch and added stable in the
exchange, so that it could get backported. While I'm now a bit
confused about the situation, I have no problem in accepting that I
was wrong and I'm totally fine with just dropping the patch if there
was already a discussion and suggest patches.

Regards,
Jérémy

