Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E76606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jUbivFcs
Received: by kanga.kvack.org (Postfix)
	id 85EF56B05B3; Sat, 21 Nov 2026 08:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836556B05B4; Sat, 21 Nov 2026 08:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C126B05B5; Sat, 21 Nov 2026 08:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF406B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:01:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B70A9A65D2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:01:08 +0000 (UTC)
X-FDA: 85459136616.10.4254B8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E09FEC0008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:01:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUbivFcs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795266067;
	b=QmtLRe3dnTlcwtOzqY0+VrN+yNtQ+qP213swdX2YQEUT6ii/CRWDOfOjeMTeQ8X47foyVy
	gwV14S5gDDEjogV50UhRt6NxmEh+EDZH6Y5rSzqcSsjdXCa4hc5HhJ6mpXV1xb1WM0ooDg
	QbxwrCxuq6WRPW5mqSMmRVf8RCwgQ+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795266067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBTcxjD/jP+a0J14fwq37AGdaxbLVWZgFPI61idAJ0Q=;
	b=QSMwHOuBMEOoE7zVCpFsnDHhQH8LujVVmR4AG3U6z/6DoDZf8lxcw3rMTPoAULg1g8yJaK
	RhJSrSkbH3mdnBIe4r2sqxz9oeRhbEqIQj3WuTkuV4Pi2+7M2gF6rFjJ3njzksphaSVzJc
	SsMCR88nyJrJVzjAJVjJ5NYr/ogFjZ4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUbivFcs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEECD4086F;
	Sat, 21 Nov 2026 13:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634321F000C0;
	Sat, 21 Nov 2026 13:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795266065;
	bh=LBTcxjD/jP+a0J14fwq37AGdaxbLVWZgFPI61idAJ0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jUbivFcs9cry91XPTkbT/185do1RnL/TsUv2YpsKCeGHMENOPk5uOtW2fKgEn6LGX
	 RSBA2skOWiqcl0JNo4ebQjVsqRa51JHe7MyLNvwcnLtYysT3vRpOcAYqGDJEoVYoEm
	 nJTVlMtRQcFUNfcdulMWSAc+77f63HfGakiwjzDVQKbXxBc5XBShcFJKwmndyhbGAf
	 Ct3QTLhAG4UJdConrNgEwZ36H16ygilJ9DQvg6dMUoR/APkIuJFecFMwXbhHgNUTrK
	 lHG+9GZBtWf3SG8CoxkFSbSXii8qLXlATOlxi6cgKsj6cLD7Q6pnZB98b7DlwmFK4I
	 yokHJT3Ysh2oA==
Message-ID: <960b4568-9d20-4eb0-b0e4-67e60f8274d4@kernel.org>
Date: Sat, 21 Nov 2026 14:00:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/shmem: don't use the memcg of an uncharged
 folio
To: "Gregory Price (Meta)" <gourry@gourry.net>, Chris Mason <mason@kernel.org>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, qi.zheng@linux.dev, qinyuntan@linux.alibaba.com,
 shakeel.butt@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120195057.50031-1-mason@kernel.org>
 <20261120195057.50031-2-mason@kernel.org>
 <179526598180.412063.14973682472309530978.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179526598180.412063.14973682472309530978.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E09FEC0008
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gmif6nzsjnhqpw8qgbeffeyi6yqgjs7z
X-Rspam-User:
X-HE-Tag: 1795266066-163188
X-HE-Meta: U2FsdGVkX18064JZaRRxAEJ556roR1zcLFJBQs6BiH8hJdOBk83NTDHQ3Nj7eOaMj5P+/ZxfN1uDQIARzEqZk7H5hSOFr09hjVwgc0LImCiZLs39PQBQcnBye5TWdpde0hpE7wN/x3XUHok1v3zxfDYQIXWhHZzGYrvhsyAO32PwhWsMb2Fp5R8dTn7mCnd4e/yaoYpUvqGXSCQnlzX/1kqaf0zJ8wjYxkAvnyRrKi26K4kzI0TPYClUHeXGTt/UTfGq9wuWTapIxnm16Ewx+UTwhBlvtS9qWeW+KcEKj+xonqeFfA3YS7HDgAAI4elDVYHfK6KByw3UVM+uZOm6veerZ9M9oycUVL/ffZEgQDv4j6zInZCa7IRvpGgzzewfAvxTJb42EZUYZ2BcgGxJRBQuqQR4BTYsHyMPnEGHIghubp1+n8f4gSQsS+oDJe9q8c8YB1iHgSjrDQ5Dt0eDZ5M91Lcsb/fsSgdCKTQrEurHz77enFbN0zgQYtOwg8m6Yn0YX6U/pLGp+155kWKuQYlwLNSQW0egKhLzYsbuG40lrWeK7nP/tFBZYzNwCRGT79uKh7sjNd6PuXeus0ctYSvBycXmtxbEnGzPQ9HhkfEQpnMKHQ3zdbzHxrxBs1tKnd4kLGakncScq9Vna5l975//LKem9c5k4mjxp/RPc+GP9MsOK3XzIGgKLn2Q+lwKfGvGR5MMA9+Y5pBxIqEsv4KqdjETrKvPECGVlwn8u52KOFbRh9IGJrScCGlIyrasVl6Vgb8aZAbLyiExCyMvJm3Ky6WLSy6Hcur9NsONCNGaWdtnYaaB+481jjnmArlgwFW/t2joxWP922O6/+zp1Q2nB58nHrnXTxk7crVuHCepNjqXcZl5QBGUa2h/w3hMd7my884URzgD3eiqaBljULaPczAjfdCiqoxusfHq90qqrXsiYbnHu0FHc31kbtXXsTd3mq1+sUW8A1wEt5t
 KiTz9H7T
 B1o5kBA6v3/5iC3n9WV3DOXKgBLqddq1MRkooZi3+AvI8J0hIrRrjYhcI6Fw7ccB3cDf17H5k6jB/5FIGdzxIRwVlvGAntYO4vtCotR9RnngldzJF1aPIxjh7VK1Xznatg5YzJ+tY8N4CurnpWtv5Pv29TugdVA8uT/VMjqxeLHi76wMRo2LJ0Kvjved/66OGaj/+jvu2BW/e4rwOO6atrAsCH+gOBcNqS4vTltY9weVDTXID13tqXBAHoVQ5uug3DG7jdgHSiG0Mk5PVOzzX7iZ5Kj+vuhtU9uWsePZKJFY/ssTUTcyJrKEGx/rWTA0goI2vDi/woDSjuPtAw8orKcVWneT3J+nzPUkQDLiKatKLwxcSPsd/P0tl+L4ln6KEhdip9HIbOusyQBF49PUzTdU4lB34m4pLtQznfzKRR9dys39AVnqil2aKFKtzbMvNYTQlkegY1hnRreUAHqyXypWUa+eELXh9Pk5sgW7SVLrUqRzDCj3/K0QjQZ7q0DOcz6zP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 13:59, Gregory Price (Meta) wrote:
> On 2026-11-20 14:50 -0500, Chris Mason wrote:
>> The shrinker for unused huge tmpfs folios can dereference a NULL memcg
>> if it races with the migration of the folio at the end of a file.
>>
>> folio_memcg_list_lru_alloc() assumes that folio_memcg() is never NULL.
>> But it is NULL until the folio is charged, and a migration target can be
>> in the page cache before charging.
>>
>> shmem_unused_huge_shrink() looks the folio up without the folio lock,
>> so we can race with migration:
>>
>>     __migrate_folio()               shmem_unused_huge_shrink()
>>     =================               ==========================
>>     __folio_migrate_mapping()
>>       xas_store(newfolio)
>>                                     filemap_get_entry()
>>                                       returns newfolio
>>                                     folio_trylock() fails
>>                                     shmem_unused_huge_requeue()
>>                                       folio_memcg_list_lru_alloc()
>>                                         folio_memcg() is NULL
>>                                         memcg->kmemcg_id
>>     folio_migrate_flags()
>>       mem_cgroup_migrate()
>>         commit_charge(newfolio)
>>
>> Fix it by keeping the original objcg around while the inode is isolated.
>>
>> Fixes: 743e7d025d2f ("mm: shmem: make unused huge shrinker memcg aware")
>> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
>> Signed-off-by: Chris Mason <mason@kernel.org>
> 
> Reproduced and validated the fix. Changes look ok.

Thanks, I'll throw this into for-next-fixes right away and cc stable.

-- 
Cheers,

David

