Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1949BCA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 03:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A7F8E0005; Sun,  7 Sep 2025 23:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5226A8E0001; Sun,  7 Sep 2025 23:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EA88E0005; Sun,  7 Sep 2025 23:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36EF18E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 23:08:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E62621A0932
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:08:54 +0000 (UTC)
X-FDA: 83864600988.03.1BFEEEE
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf04.hostedemail.com (Postfix) with ESMTP id C7E4240008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:08:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rTzwgXpu;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757300933; a=rsa-sha256;
	cv=none;
	b=sQYje1StS0RIRValspQxxck+ewATbfIak+SovIMLkFwB6O7b7uPYpY7OULoyjRXMVNhJoZ
	T1vfKdG4bXsDHk37rbJODxuYTJceAOyQkkodLT2HWiS2XwO92mh8WPWG8a0J/pQGFHsBH8
	P+AmLxfa8+ujmXHNlS9UrXR3nRRoswA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rTzwgXpu;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757300933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKxx/lX3Bp4VW+ItJ7z/ma4EcEpYpmczHseAhd+atyg=;
	b=pq6aD+yl1kxYpO702B2NIbKvPJc7AjhN/anOkknKjeGyAn5gkXg3cHrr0DcnY7joM/c5xO
	Shnj3ewY4UrpOuguqXDp9nm+u/SP0fCj00qOvhEDesFhkXlZbhDgBZPsrfVZPVcZ0WPoS+
	dWd1xluTtyvCotWQSkvV7PYdqR/UZ3k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757300929; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EKxx/lX3Bp4VW+ItJ7z/ma4EcEpYpmczHseAhd+atyg=;
	b=rTzwgXpuF6wQ6jCQ7lvKPIPDg2fLAGyHaXZFUNv6JipJz5CzRhPf6kq4goHKupdG6G396MxwFY1fccJMq/gc8djTZubrVpBUka+/G31Ii+LH1DkuMiTb2aWcvS7TKh76uN5y+27oxtSQezDob1jQCW64PVhJ4Z1DFw6mroqTdwc=
Received: from 30.74.144.132(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnQW09W_1757300926 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 11:08:47 +0800
Message-ID: <f963d067-f64c-4891-b32f-31449748ace6@linux.alibaba.com>
Date: Mon, 8 Sep 2025 11:08:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] mm, swap: fix swap cahe index error when
 retrying reclaim
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-4-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250905191357.78298-4-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C7E4240008
X-Stat-Signature: gbx73qs4istebqjkhyjsa4nifupb7pbh
X-Rspam-User: 
X-HE-Tag: 1757300932-29647
X-HE-Meta: U2FsdGVkX1+fw50rSSIKzW5nR/IKBzAzcAeFl9tCIiOByD4RR0YH4cH0GkXurvrmsqBqRfRAu8tIxSziVAgRbIHhTwfisPFLquNYNqfeJ0DTSA4W1BJgPd34hvNiHAVZqlj3DGkihKVi3cntNZlqZNW9o711N1FNLSQNJpUxvqQB/wUcrxPy+KEPmVESpGmpQRyDLHDUvBDgz+GkmKNriitKX7DZXlUgpU8P/oA5CKjGtC0HR+fM/nyZi5NRame9tCAO38Us1VNfWKlQ6nBtqoZSkh2U5hzjnZ5GMkkl5Qn0+kzN7r0v7NFQubjkxcQq6LaRQFUcHp6Fluj6b2zsLFtrWca3JymC+NRgB6KBvvH3BjV41rciedBkNCv0LyHMEnCwJWqZ2OgB9rJJaMM0H4HvXjPhyBg3cTubM+1aF604S3U2YSwoqzOtLbLmJ4un9bHWFCLCLwovbRhZxsdk4HFC+Dy37XB9/in22NqNQcsLGy2ZnNuTjGxOVFjvh62WawzcKxMRoTpPZPUnMi7QKZWJ132GlMmeppr5L/F+xpAGoP7hpMMirrXEKRcpTMgyOrZaOxXOjHkmgDz++QZOtfNTjUJMaagGesmcMzVWHZR7OWKUjojpi6aNc7xSuEfdrCJz9nT87ivsO2XaZJDA3sYJFWT0ZXLBEZ7hrwMPRxAMEgq5PRUULMZxu0LaJLTMN4oLovI76zdeKSDx+Rx8Lc0DB3BlwRC62JPw5HvL1uF9/vAyFyRnPzv4+Y7T6mO3jIhBZ2Fvra7cycIh1eRY/pCkBG0DBwvwF6vs/SbGzD/neTfjxmt++nIGWNpHSTv5mveGpyfiXlRgK273BQix30aL1K6FN3Kp3Few5erQiWwwa59nyB2GNcCZp1SNYuOHQgryYnlbraT/CLgomAuErI4ORHVxJx9urZaTv/mVZpBdhAVQuf7olrWUkMaZOKla2nScURpkyP8toTEcnpv
 ElMA0toL
 NaUJm2wgkRA4qmfmlbpAtv0QjHYvZFEyscNMGL/yQTvcmC2xehTc5B9O2Nib4r+ytXTK1YPBcrt54wOchYL+PsYcsd+aFAR/r1rKIcQjnjnPyxWNdMUIsha0Cyt40s9ZuTZl33U7CKYJ1qg+sTYKy2+ml4R7sB4jR4lt2B7RORVtGG9+oUTYInF4d8XBZ48ZdySAJd1lD8KHFvoQu2+gPZJJfttX0mIzmjCqjCzUb9xRgPJ5ELBZOMmTAFRi42IdP1qAiJiUR3RFUeLaSB7Xq3lVyHuh/1aG0Icdn5iG2FY83XGt2hVZ/L25uHa9nVTwhKMBKEBLxcNuGSek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/6 03:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The allocator will reclaim cached slots while scanning. Currently, it
> will try again if the reclaim found a folio that is already removed from
> the swap cache due to a race. But the following lookup will be using the
> wrong index. It won't cause any OOB issue since the swap cache index is
> truncated upon lookup, but it may lead to reclaiming of an irrelevant
> folio.
> 
> This should not cause a measurable issue, but we should fix it.
> 
> Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Good catch. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/swapfile.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4b8ab2cb49ca..4c63fc62f4cb 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -240,13 +240,13 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
>   	 * Offset could point to the middle of a large folio, or folio
>   	 * may no longer point to the expected offset before it's locked.
>   	 */
> -	entry = folio->swap;
> -	if (offset < swp_offset(entry) || offset >= swp_offset(entry) + nr_pages) {
> +	if (offset < swp_offset(folio->swap) ||
> +	    offset >= swp_offset(folio->swap) + nr_pages) {
>   		folio_unlock(folio);
>   		folio_put(folio);
>   		goto again;
>   	}
> -	offset = swp_offset(entry);
> +	offset = swp_offset(folio->swap);
>   
>   	need_reclaim = ((flags & TTRS_ANYWAY) ||
>   			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||


