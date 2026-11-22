Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0879606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nKgwhf5n
Received: by kanga.kvack.org (Postfix)
	id EEB0D6B05B0; Sun, 22 Nov 2026 13:21:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B606B05B1; Sun, 22 Nov 2026 13:21:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63176B05B2; Sun, 22 Nov 2026 13:21:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A03706B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:21:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3FBB91C412B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:21:58 +0000 (UTC)
X-FDA: 85463573916.17.E8DB367
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74F53180004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:21:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nKgwhf5n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795371716;
	b=TB4UET3rXF1iREqv1TJRljVzPfjkUgW26zyHdUIijXXkA2j8rsLvYo4XQlMraNioinfk3x
	yvQoJUTFsvRCutRoqN7uq+mvo51vXLimmQIke0CxvDD85jmyHNjLKb2Fg1nRarvBOeyS4E
	CTslM03d2JdSS4/gOS6P41pX7FIZc78=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795371716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8vP/MF3oELz3V2/x3tvrxIeCKjNLm5UtpQqetXgg0s=;
	b=5nrs/0+h5bgdupn9jr6CjPJz+Q6Rk7BFO/UVU7FULi8wuwrof0lJfjbR/scl/a3OCg6Jse
	FNVbqzZB2yx8+4FuJcjXivUl4FvZZ8LaBFVq8WNLrEc3exOcl4osjVU1CUtgmBxzK7kgBH
	Ghc4kC/odAEP1eY/+FQspGQMwtwdThk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nKgwhf5n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D652440DDC;
	Sun, 22 Nov 2026 18:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3071F000CA;
	Sun, 22 Nov 2026 18:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795371714;
	bh=i8vP/MF3oELz3V2/x3tvrxIeCKjNLm5UtpQqetXgg0s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nKgwhf5ncCO7LABJzHme8c0tP9v4/5NJ26ATjF3etXPFXNITYo+RVCqcxGRj5sQkj
	 tdiAY/B+iHorLCF19L775lSwGNSBjoBTlnzM61XoRvpC6ew+Tuxt4jTdW5kAK4o3K0
	 8ZWZWdkxBU5mZm9b/B53Xy2XomU3v1h9bec4IT8p8Ma3t/SDe5UcNbxx1NZUts3Olp
	 MWZOSZ2WakxTzd6UgCVGpk9MMqCJ+L8hktQcByY8YLWS5ERmSZeZhEVOWRV7LpDwL9
	 XSVwGD1t7oIHv/BuxgLB9HtypPeG9EBXijexUeZ6rTVffwkU1uvwBVxv//SZhW/lCO
	 kmVvUdAAmvu1g==
Message-ID: <45997a78-95bd-4e50-b433-f64237f9ec1a@kernel.org>
Date: Sun, 22 Nov 2026 19:21:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/15] mm/hugetlb: account temporary folios separately
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, stable@kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-4-4dd9e94ea9ac@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-fixes_hugetlb-v2-4-4dd9e94ea9ac@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74F53180004
X-Stat-Signature: k935sciygimbjr3icgbidwjk4bropnwf
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795371716-722227
X-HE-Meta: U2FsdGVkX18uH9lHnv6Jsn0R1vyjotXoIiOweMvoP2QnoRHmGIRThtS6Ji/0c3jWq2hTQd1bF/HZBYzxrqUrZqKKBp+KGWSboh4Q0PiPRnKEkxdFZLABtrM+HJI2VAFRMEXtH2NHSWQ33TIM1LuOmCCyMXDwd5tA4WWSO+NKEVWZMGUXQIxIz4wJN4hCchwxHNyONPG4bgJPBbIztAQPc4kXM5QO8RpmgQBgdyTUiMmcZc8hl9W7f3DpdrncCOP71i6eYzcmRkrGI7NgcdPsPY6qjSXwhpiB1qRJnvqbsxyDTx/UERSv9K++btvci96hCLnzzQKMMYhGD7jx1gzVfKnDoAjplmITuoHfJoH8CbjVgGyKHIWqJqQkC1jIPho3eprfiK79QWjbdGW/PZwAE20EJBSHK9R5E0PzzVjFBZL8wMUZj0wVuWOR7iInPrxdv9/BdIa6XCcHR+T+Jat8RVXLBSeEk+vywtFi2h9xoFkSUAlQDiihnRu0w3nyaLoAtpkWpYSSH/XmtDZXVI9PDieU3s4xhvC07VJuxmIe3mzdsUzb1SPcje+cmqgZUY78RinI/ZqImlYpjjgJ6up0ltpH70sa/xFDfpv/MfAhT8328hiSaTe9UsJnxzbtvv7Bl+C/VYlWlDY5qRA+Kp2uyvxWl+HoAlDwdf/0hqCVIG0C6Vn5ms4gmhDi1g27HPENqbgxA27FKHbhEwx83cpcw1NHc7qrlJ3zmke1MNfMMyM8kGrMo74M9ImJ3K6OlUGnSg+I0M1DFRmx5iC8v4W/cUWZq60P67kq/6BGG0mB0sstiHG7uBbwMpyPYuoh4fXGSsCSrzoNPSn+8/tPfG3kXJR8ae+1tGQmeRlR2iDxxi4F3/IKhROesBbQi1afEf6T+bXlTi7pFEtI+1uWOsM/hHpnhH5VRbKrKU7yIh8f7G8XuJENdIj4xspTYuSQYjF0HctYmfDVW9DC/qVxzfb
 8BHIvkFD
 0ByHit7McTVaMoYrbhd9i4mnnjOC0y506jPB/D20ftzCyrk4mVTgEM4ebHlh7P2WFKuzQmlMAwX/f3f8XO/li092xvn4z34sHGR51GqOC7Dw59GWlaCurE0sJYGcTw+4seZA4d83a5EwvpSDQGlwoW+sB5p5UjGfqE08y/9bJANVcPRvdc3JY0dZE77u+pN2dilSa3NO5KLDkw9RKuK3Ui7DN+KRIVCI97xoMOd92UUNcxa7o2qzVTj7PlOa+GdprjQK8LBH6Nzb+31g3PJ0jSCf6+iZcalGZJWQuxyX/+tjJXZwXhnpuit4sOcf4wgK4zkVYUNO93BBvn9Ld8fN9DmwiNdlY4GBjeY2N2aFWuXkvMDWOYdm5gQYtd8dz2b6lc7qhxZh0VNAJ16GrWGS+NvBBEoosNZp3kJar1te1/r+gjxc2L8V6kwuF6LKaEP6ozKb8UGhS1Pupj7aH74loOR5rgKNRVDGBz3z9AmT99Z63jvdn+XCOBXY/LuZtrv4u9ibhKqZ1uEm1v+lIsPk6rf0X4WMnOlHYGlNiZ85Ggz1mybtW3cirX9a0RaGBRvaRMWdSza4cHjLws0hCbEA2ebLWB1TZKfjwZUZ3R69IY8rV7YTdOwcGMONgyiItiJbxQN+W3fBO+MLEzOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 19:29, David Hildenbrand (Arm) wrote:
> Hugetlb migration might have to allocate a temporary folio through
> alloc_migrate_hugetlb_folio(). Such folios are currently accounted in
> "nr_huge_pages" but not in "surplus_huge_pages". persistent_huge_pages()
> can mistake them as persistent huge pages, as it merely calculates the
> difference.
> 
> If set_max_huge_pages() shrinks the pool at the wrong time, it will turn
> hugetlb folios into surplus folios until persistent_huge_pages() returns
> the desired number.
> 
> After the migration (successful or unsuccessful) either the new (temporary)
> folio or the old folio gets freed: this will reduce "nr_huge_pages" but
> not "surplus_huge_pages", to undo what was done when allocating a
> temporary folio.
> 
> This can result in having more surplus folios than actually allocated
> folios:
> 
>   HugePages_Total:       0
>   HugePages_Surp:        1
> 
> From then on persistent_huge_pages() returns garbage.
> 
> To fix it, add internal temporary counters and subtract them when
> calculating persistent pool sizes. Update persistent_huge_pages() and add
> persistent_huge_pages_node() to make the code easier to read.
> 
> Count migration targets and rejected surplus allocations as temporary.
> Transfer the per-node temporary count along with the temporary flag on
> migration, such that folio freeing will always do the right thing.
> 
> Take care of calling account_new_hugetlb_folio() only after setting the
> folios to be temporary.
> 
> For now, keep temporary folios in nr_huge_pages, so HugePages_Total and
> Hugetlb continue to include them and overcommit accounting remains
> unchanged. The new temporary counters are internal for now and are not
> exported to userspace.
> 
> Fixes: ab5ac90aecf5 ("mm, hugetlb: do not rely on overcommit limit during migration")
> Cc: stable@kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

In combination with

	mm/hugetlb: preserve persistent flags when returning folios to the pool

This results in an issue during boot.

I think the following is required:

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bfc88d42ef0d..aa6ad8d93266 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1804,8 +1804,8 @@ void free_huge_folio(struct folio *folio)
                h->resv_huge_pages++;

        if (folio_test_hugetlb_temporary(folio)) {
-               folio_clear_hugetlb_temporary(folio);
                remove_hugetlb_folio(h, folio, false);
+               folio_clear_hugetlb_temporary(folio);
                spin_unlock_irqrestore(&hugetlb_lock, flags);
                update_and_free_hugetlb_folio(h, folio, true);
        } else if (h->surplus_huge_pages_node[nid] &&

I'll test real quick whether that resolves CI issues ...

-- 
Cheers,

David

