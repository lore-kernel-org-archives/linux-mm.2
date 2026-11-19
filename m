Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE67D606A336
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HutGURtX
Received: by kanga.kvack.org (Postfix)
	id C008C6B05B3; Thu, 19 Nov 2026 02:11:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1196B05B4; Thu, 19 Nov 2026 02:11:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC82D6B05B5; Thu, 19 Nov 2026 02:11:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 821616B05B3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:11:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A0EAA806E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:11:22 +0000 (UTC)
X-FDA: 85450997604.21.9034484
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 33FF780005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:11:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HutGURtX;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pv4D+oSBbj13nSy5FVEyYVmO1wSsAmwa8GeyhZBw1sQ=;
	b=nBPrl/PcaUhUYb2P3qPtUZch5sXWsJ1q//ZtwzV1TlfAxH6EQkvol8RBRrjvklSeh0aByy
	0JMgln4Oy+jFfASmkEcqFg8eifKa/28ZmC+kmwDp09A2RRspvaOR5sz4SdMkBlS856yXXi
	/ddCAWuCplJ3ZsUnPbR3xDixDncfLs4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HutGURtX;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795072280;
	b=NBAaHQ7qYnAybKWSFcB9n9OVR/5qGv9P4z+4ln/Ae+3JTh/MClr+4IfQ1fzXVgyTBUwj9a
	syTe4l3fYe8Pl8vQeGKajtAholPW65J/kHuDkQ0VDFaZhpuDPOBaMAim2qjxn6p6Q2F2ix
	VKYbt7ZoFXF3srL6aKkw8pO5eAf8B/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52A6E40454;
	Thu, 19 Nov 2026 07:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD661F000C4;
	Thu, 19 Nov 2026 07:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795072279;
	bh=Pv4D+oSBbj13nSy5FVEyYVmO1wSsAmwa8GeyhZBw1sQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HutGURtXfVynAu6rB0e+Pp6CijsEHIvVbwW+biDVcVeMMZJbC2Xnt0bAOgzvu9oRQ
	 Hzi5JLqa1W+DlUL1Ya0hCI+NM6hAGhIL2mglmDNnH8OSiKkSuqDeuMjX5COQjzxxr3
	 bbSx7C6ffdKu7MRPVTFD6pwvXgzkELPB+2LXv9OU=
Date: Wed, 18 Nov 2026 23:11:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: <mt4022@columbia.edu>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Jane Chu <jane.chu@oracle.com>, Zi
 Yan <ziy@nvidia.com>, Kaitao Cheng <kaitao.cheng@linux.dev>, Mike Rapoport
 <rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Yu Zhao
 <yuzhao@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <tz2294@columbia.edu>, <stable@vger.kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory-failure: don't unpoison a leaked
 raw_hwp_unreliable folio
Message-Id: <20261118231118.ca2d773881cd953d1efee4ca@linux-foundation.org>
In-Reply-To: <11f434ce-58c4-ff16-9c93-946a1e83eb10@huawei.com>
References: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
	<20261103-hugetlb-hwpoison-leak-v2-1-98085750c145@columbia.edu>
	<11f434ce-58c4-ff16-9c93-946a1e83eb10@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 33FF780005
X-Stat-Signature: mnsk71uybc6z17wb94bnogpfh487npje
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795072280-983775
X-HE-Meta: U2FsdGVkX19rzSwv1AbSPIdo8XE4NBMMzzoctjxqQYKdYb5QVUiOliiB6XvGKnyuTOu9iWyhSqxvcp4kWgKl5mb7S9MfaKaYwILIWT5rcp6VquEZ9BjA++/YO/i1MJf/+2ND60u12x7paWtcsDmQVy5bmT5azqpxC7Ha8Caucm9nLeMWh2uYQfiqa/vYYyPsvIum/Cx5b039JxSU/sU6gcL6WUSnHKzJ+DO/ev9z8vgOpUR9W7s5HU1OQ+nYXUvogpIKpPVlbInGynB6XmixTYNeSS8eG5tjlZspCw3gjIuhkqJuCsCtPUC3GHJjYghgcxktIE3KkQDvysWdCQ58bWCheBYVyUu4dgunxJTulsENkWRr3CS2W3FIUqzJ4U2yF5DZm+6GGFvJHdSppBStoit0FTc5eKDbUgYt5cvTrahK5dyv6K/B5ik7I9b1H8e3KD9CdroHOsrd3F4vVWbDbd0SUeVZ/edaWkZ1l/1i5rPc1g6GVpshDOjZxlkDskklf5gqSR5e6E4LJD7lpm1b5m90JWS7zdFPxYSaJm4ungYG6N6JjJyS/iB5cjEyW3dhBp1u/UMtNfGtb5UcwAkTftd9wfG28FTBgN1+NYLhNMpIKK6nalYUtmx/fnAjkSgaQARQbkYvUO5DOfABdNAdptd/cEqXPHZ7Sx6b7rlsuKMyWYb2Kz+jFxyZylW/z0jKI4xd1l66OWc9DIkuniX27878wvdtFwfEsbiB8z8xC53zVxWxBZsG07iDoWKPg18EZEnfO+XBw6C9lTKDARgsVmFpxY03yLR0TxU9i8iir5e9+dGQQBOTY+BzPliRdKS/ysG6rJioA4FKZeWeLqFRCv5PE2cB+CxRWCd5fzStN7a0MrZCM4SROvB6Wi6HbjEim8/2QmWiYSgf9MNYUT/SjOWftLzCvJ0nqc8lIzNu7GGwxVi6ztYo3FbgX/CyMNmzTtejiYhNqphrZCIOEMa
 pyWmzxmM
 aVCnEgS6XK7Prya7sIB26gajQIA2mSykZc4gEjz4LWx7sgDDczdb7TDngJR9rJihVfelSqq7QqP3bF0leQS0xM9i5QJx48Ma1TwpGqWDbPxzwXilxZaw0gxIzOJblEPv6ybB1dNjMs4sAhjWLyS3Sy2lnKCTQz5itXYxXV8Npcx+h5naG0zhtc9i9J73zLYvhrkWVDb53XEcC4lZPgP5+pzjdMhXmre4h2rAXUCyqxgnBUqbFLSRunIwrwi1SohwCYBCx0AY3rFq6u6nH6KoOMWxdT6a8+GPsR7FC6/kVi8Y5KYUjGP/bUJnRg69jiFlsfksXBUjCr7gdgwoILxPbjEUDHrEVHK2sirf6rAwyDgPn5bYwMKNc5rHv8ki3waKIQBElCUeKOtKbWeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 14:39:24 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:

> > +	/*
> > +	 * A hugetlb folio without reliable raw error info is leaked once it
> > +	 * is freed, and its hugetlb flag may be cleared by then.  Check the
> > +	 * flag in folio->private, which stays set on the leaked folio.
> > +	 */
> > +	if (folio_test_large(folio) &&
> > +	    folio_test_hugetlb_raw_hwp_unreliable(folio))
> 
> It might be better to add a unpoison_pr_info here?

How does this look?

--- a/mm/memory-failure.c~mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix
+++ a/mm/memory-failure.c
@@ -2818,8 +2818,12 @@ int unpoison_memory(unsigned long pfn)
 	 * flag in folio->private, which stays set on the leaked folio.
 	 */
 	if (folio_test_large(folio) &&
-	    folio_test_hugetlb_raw_hwp_unreliable(folio))
+	    folio_test_hugetlb_raw_hwp_unreliable(folio)) {
+		unpoison_pr_info("%#lx: cannot unpoison, poisoned subpages are unknown\n",
+				 pfn, &unpoison_rs);
+					
 		goto unlock_mutex;
+	}
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
_


