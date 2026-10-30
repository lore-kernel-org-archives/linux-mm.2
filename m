Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862AD606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 06:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=o2R7dIvZ
Received: by kanga.kvack.org (Postfix)
	id 79C266B05B4; Fri, 30 Oct 2026 02:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C7F6B05B5; Fri, 30 Oct 2026 02:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F1A6B05B6; Fri, 30 Oct 2026 02:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7A946B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:23:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE714A81F9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:23:25 +0000 (UTC)
X-FDA: 85378300770.16.9F73E51
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8FC80C0006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:23:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o2R7dIvZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793341404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FR6kDtuhUl2pZ2hlAM7s92sn5MsoPj+x/vo721Jg2CE=;
	b=yIkgIH0DaJcyfxB4FUXjVF70dJm6tOF2Vl8lnBy8LUnScLwDFLC+DXn889qAnP6iMkYi8O
	HAsw1qj9ZelsjfLJgL4ug8DJtcXxV8SRZ0upC8o9sNZIYyascZvTYMqHzs5rrc8cMd40NM
	MDJHeqNxJQ+qV5vEyqX6MWRpFi+i01s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o2R7dIvZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793341404;
	b=5kgwAQj6s63uI9uOTjVOQEwLb/XwWXpbXyqjP5Q+sbehvVz156uTnD+bdIRzkA8yZxYMrC
	YIL7kns95qu7xvs1Ooo2sn24eL9HRRdSoDG+ad+MXIzWGXlW6YwQxCZZnKbUuNhtOwdLco
	Qsn5EgG4b6fAjVz0AZnCWIzw1vPF+Rw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37F561E8D;
	Thu, 29 Oct 2026 23:23:19 -0700 (PDT)
Received: from [10.163.152.232] (unknown [10.163.152.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2FDB13F673;
	Thu, 29 Oct 2026 23:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793341402; bh=P5Zy0xZQya3Jb54eLwCnE+O+Yw3rp01J117IsN1L6JQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o2R7dIvZvwWJxI4hKtEGR0Ax8UZ3wC+rA1T7+1AKR2QCQwRhZPUi5IS/R3uXlRd9W
	 8p1ZVKZzFAc5qfLKGHFQOHm1CZNm21azSP0HlBfV/2KkcmyyjvI1H3/tHM/wOuxsYM
	 I22XH1bYRCgfDCNJlnHPePjV82hwwO03z+iyqNfw=
Message-ID: <9ac25d32-4f2f-4e91-92e6-7ecea7a8ffb8@arm.com>
Date: Fri, 30 Oct 2026 11:53:15 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmalloc: reject overflowing vm_map_ram page counts
To: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>,
 Shubhang Kaushik <shubhang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8FC80C0006
X-Stat-Signature: 3rq9ffy31ow577nzhrbrzqhn1o59hda7
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793341403-9772
X-HE-Meta: U2FsdGVkX1+Y5hf5uMVZcg0GEi/zUNKpQQo0mQxAUyA4GIzxkY21I4adthpX/yve9NkQaaHApbOT9cg9vYTHkpuMBe7VtgA8ITmeNiGtoJqolv+FN8L+xrX01HXGwAv/pOo5LLB/Lyyr03mt86ma2wKdPVS5Msd5BikEz1uyxBhVJh6nXw5ws3gFhS3iA7InPbj/NyVZaUb5IPtIq7Ayepi9Gu/nLY9HboIUPVi2MynvpFb2/nVZpbYia87Z4P7rTHgsmthpflhbxYKoGnFH+YZq+Tgv+exdc/QolsEWrHOg4Lx2QGyneSTsWA8sB2Yld5FOxCuH5gtouIq7jOZNmWUAd63MuukxUsTcQhLKdYrHVloRyaUL4/9BussE5ICc3T2EdFMjxTF0FzeENzpLxgzGVk80WqY5R/qSVM3r/Pauu5eyy/D9DR3kPjb/6TgZTO9bjim6qeOb9IYYA2obliLWKF/Blr8EtcRkGYzJVxSl4yq0a80i2wnf9paj/LZQk7aG39L7hBHaQV4wkTlLRZF5kbPl2bnxL9+vAEuPCEp5i28LzA/s4fj+4Lr7izMd13G2fjiSbnyV/Az4ZpDTj4O6XAmcl2R/V74ur1wcjshLSw8CuVs1KwLOS0tjd1JnKBGcXxPA2Kp5MxZnEDBoraAVB7Pce0cd2wKd0EF76AmtGD6eBf6hqmb/ORukZ6WI4FedvjWePGLdq/8g3LgKK8B6ht5fKYw5DOjrYKsbfxaAxu3TgKf9EAlEqQ/byIBgtFDeJmvVo6NzrX31yJyYXgqkr/H47SmgmjDws6pGjmXwy8JgOC62nMOC4HtIhhsdBh2Wl2D5a+J5FoqyNHxNBIwwAEN8QfTfPEl5j4WZRNMeQRyh+XuVoqnF/It/7IN5T90VZ93LvS3qxxDic+ci0NnssAV3ALSCCLs7rrYgAPlbcVpH+WnMUelYjOcC7iKOZqCEtA+qEWK0KGXL7id
 +IUNj3Vr
 tSsmmtLynjnHvDtdoRoyObboxH+jLdrTSjI6CjunFqz7/XsHAX4iwMmEyboSAmW4X2X1F4ayMIjtXwq0nITzL5MQFFhH22WJzHR1AmRwvHKba4FDYHu1hyTUf7oZ2cvUeLK7tWrw1xy97Mm7SZqB47HlIyj3WA+nHKAzanf2sIiDbvH7XMKsOHxq75zN81bjY2FJYG0Fwl4GrgdUM3pdwtP2a9zueBFaBKNRKmZL1UFddPR8PGgZ7W3dm3d8u3ztsf4iDkE+Faq0c5x8yxEnlDaKGNcdeJuM+hd8zvQqfeH/71FlbRg94wmujGt2iIQaQc38BsZ9wiYGRLB8QX4MnuecPjut50TXhJ1Cs30bTNu6YAfBEcbeVAI06KTppitOzHIpJoMqAMcmXscuL+clU4pKKEiM/ILQ0aZRKLOoxH+uqxjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 23/10/26 12:13 pm, Shubhang Kaushik (Ampere) wrote:
> vm_map_ram() accepts a page count and must either map that many pages or
> fail. It currently converts the count to a byte size with:
> 
>         (unsigned long)count << PAGE_SHIFT
> 
> On 32-bit kernels, this conversion overflows when count is greater than
> ULONG_MAX >> PAGE_SHIFT. vm_map_ram() then allocates and maps only the
> wrapped byte size, but returns a non-NULL address to its caller.
> 
> For example, with 4 KiB pages, a count of 1048577 wraps to PAGE_SIZE.
> vm_map_ram() therefore returns a mapping containing one page instead of
> the requested 1048577 pages.
> 
> If a caller uses the successful result as a mapping of all requested
> pages, it can access beyond the allocated mapping. Such an access can
> fault. If the accessed virtual address is occupied by another vmalloc
> mapping, it can instead access and corrupt unrelated kernel memory. In a
> userspace-reachable call path, this can result in a failed operation, a
> kernel oops or panic, or the effects of corrupted kernel data.
> 
> Return NULL before allocating or mapping anything when count * PAGE_SIZE
> cannot be represented in an unsigned long.
> 
> Fixes: db64fe02258f ("mm: rewrite vmap layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
> ---

I don't have much knowledge about 32-bit stuff but upon some discussion with LLM
the problem seems legit, maybe just hard to reproduce. Also there are sufficient
users of vm_map_ram() to care about this:

Reviewed-by: Dev Jain <dev.jain@arm.com>


> Changes in v2:
>   - Use check_mul_overflow() to validate the page-count-to-byte conversion.
>   - Describe the short-mapping failure mode and its worst-case effects.
> 
> Link to v1: https://lore.kernel.org/r/20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org
> ---
>  mm/vmalloc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e74247d4ce919250c2f02dd5c36483..8a056e424a4f2c037c10f736002839014f1f57dc 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3083,10 +3083,13 @@ EXPORT_SYMBOL(vm_unmap_ram);
>   */
>  void *vm_map_ram(struct page **pages, unsigned int count, int node)
>  {
> -	unsigned long size = (unsigned long)count << PAGE_SHIFT;
> +	unsigned long size;
>  	unsigned long addr;
>  	void *mem;
>  
> +	if (check_mul_overflow((unsigned long)count, PAGE_SIZE, &size))
> +		return NULL;
> +
>  	if (likely(count <= VMAP_MAX_ALLOC)) {
>  		mem = vb_alloc(size, GFP_KERNEL);
>  		if (IS_ERR(mem))
> 
> ---
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> change-id: 20261022-vmalloc-reject-overflow-e532c556f3fa
> 
> Best regards,


