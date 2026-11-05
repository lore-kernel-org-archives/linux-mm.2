Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F554606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X23c9kWV
Received: by kanga.kvack.org (Postfix)
	id 25D3F6B05B6; Thu,  5 Nov 2026 05:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5516B05B7; Thu,  5 Nov 2026 05:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFE26B05BA; Thu,  5 Nov 2026 05:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD9826B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:03:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B279A8567
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:03:12 +0000 (UTC)
X-FDA: 85400627424.29.AF79C94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D9921C0007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:03:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X23c9kWV;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872990;
	b=xSW1Ak0zqS4KAJ/fSKVuZiHnLFTf09+NtpGxX8gyr9D1YRADqQ7CDvQr6u+FyADN4NJEma
	QMy58j9NluhUTwqMWk2O+jpq5Yd8L9s0oQHFQHiELynVk3mzXhAqXh/N+jLY+Qq+te55qS
	kHrI2Zse98q8n57bGCi8ZNDo6szJaRw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X23c9kWV;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGxMLGOpmO21KJ2mjD9khBg9SC63tjkRy41YsLQwOKA=;
	b=n922n+trUKImVt2GWSPkeG9+AO/TwTvUnEOXvWtvsYTc9p+/koyw9svaYRDpxqCtNR8ysa
	6iwYdYlLkH1HtTEXd2N2whzrf9wc2y2A5c1Z8CuvtkwyoZ7DkHyP0xo5QD8tmCySMHxbt7
	UlwEncBqhDn5knoQADjll8cS9esJQ50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 298CB601DE;
	Thu,  5 Nov 2026 10:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8C11F000C1;
	Thu,  5 Nov 2026 10:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793872989;
	bh=YGxMLGOpmO21KJ2mjD9khBg9SC63tjkRy41YsLQwOKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X23c9kWVkPgMqf9QyBhUBCMJnR9wXAEOhBgM4zA+aaLN25UZaS72McMQVN0/qvLUj
	 gyk5MOm29CmrgYJH9yay9R0doiqzvqabiwazIkyDlhKcCIJ8plw01qp3O1I61UTMb2
	 4sDnNnTwzudp4tadLZyxoi3npf+TTtP02nBBVgnX6ZEX+80DAIf/GFQwwsOf2R8b+Z
	 hlvrM8pjyLZtfwgzHKBPb+KT/mu5ORHSRwxL/NWD+/twyME/sINzijVNN8QeVMy0SY
	 SkJJrq4ukXNq1AAh4nbKw54nZ/nmzNeR2PTlSjc9shb0e57kDG9CxL0ftVLrYYgdTM
	 MLp33ObuR7rRg==
Message-ID: <e6be27d9-6cf1-476e-9d8c-8e91664b95e2@kernel.org>
Date: Thu, 5 Nov 2026 11:03:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: cover merging KSM pages aged by
 smart scan
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com>
 <20261105-bug-mm-ksm-smart-scan-align-skips-v2-2-8a9780b6844e@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-2-8a9780b6844e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5pnwn4j57rbpsteirfdcfnucweji5zxf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D9921C0007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793872990-951595
X-HE-Meta: U2FsdGVkX1/NR4U4eUq/EJH6vJ+yHCy8bDUHRJQSAMARNx6xFw0s0kidLegDgjDiXnNt7XDTxlR/uNcujlqSbTJjZPuSqlXWEXW7fRlVeMHuSv5OxG6hP6B9DWW8bddJ+linfc06g3AgGU3Z8O9muYvmuWE8oQ0oUil9FgQZmcdFLmQUstMwy8u2JTAYZZ4GZyLjUl+3OtWj0aSgGchDcH3+Kb6V5gctnHEQt5lGLN4bAtwMdeR/4BL7mvsp41Wt+Tyx48IEVi4q0jMYw0XhohPvMsOekXfANtJxFci+6jNt3dgJuZYdonJ1MVGJfYku9hPHjwEGYIggyFCX5FyYauTOZkdioJZYjE+x1jq17Y4e7Ey1Hpj6DzoAuDGzCJk+cC+Pmo1simeFLbjljkjCY1tKXPjycmWXMTrwq2dh9xSbogCuLM3845ooziQ9WBH3tacn6ho0Nlivi9AjdiTxTbQ9jptMEGxaTAjg/fetaJZSMc6jOHcyAdWIsCheiCqa8Bp8BlGyTg4inJMgSIr0nY4bLnW0f/uZBdDhB7nbe/bZNK08bc+sHZj2WE4B17ZgNxTJAyzBp6EQT/93JAA185mnz6FXljpXcLr5Pw/eTB5IEh5MtCsdsK3E1D0kUvnqqbPQ9D4Jz/bZOLxLFddJG4sJccBBT2vhcB34YquLdAOMRo0X44x4tWDbJadwxXFyLeaBHGGOIvajz9CBjGutPYI2LQqNJKjaxluh/0tpegkJPzAnUAEnR/HPEY9IyXsHKj/qpVtb9IMFY5h9ET8LJRiSj6BnkzJ1ESYy7GtKZ8TA/e0g6NcGuz2y+MjPb/mUWgSrmTbpHDK9yt7YRNERlx+Xu2VZ3zA+hbigy41n30LOjSJhJ1ytkoFB/u3DukUBujx4jgB21QqNlRZ4Y8lG2rs0W4thgkR56kjFwIvZqEP4VIsLOCcKqAf6B8x9IQr/1nuGi3zP7mC2vPxg3Kg
 pIByClmj
 f9W20aZy+1zNmAubcVGO/yDGHBq0wisigW8Z+Y2kW/3DVulGp+a4BCOpqHMBb0uOaG4KriFjs0guDOPPC0zieG8TJ4laf49X4ZnrjswiAy78NeuIgtOoX5pX9MQbz/dD152dStnDHs3NoTXR3BabMtryCxNX5r0/T+JWvF2a9+mOd/lEaqRrlzMBoPCLaNrI93dB4kd+dpq0ETG1lsor0vTVwTc7HGIsmnmUY+lIp9C3R4bQBMrJxFtgKa8PapYYbhNx0wzV2ROgbikJsC3epGVVApi0xOFW6cPOEqlkVDJB75Jf15P2E/5g6hrUfzJP+rOfvMi09cbpw43BUGCMWSMtk1PQk9PwXt6GhH1kvOXK7Yeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 10:36, Qiliang Yuan wrote:
> ksm_functional_tests checks merging and unmerging with ksmd's default
> settings, but nothing there exercises smart scan, which skips pages KSM
> has failed to merge for a while.
> 
> Smart scan used to time those skips per page, so two identical pages
> that became mergeable some scans apart could end up never being looked
> at in the same scan, and were never merged. "mm/ksm: align smart scan
> skips with the scan number" fixed that.
> 
> Add a case that lets sixteen unique pages age for a dozen scans, then
> makes a duplicate of each mergeable one scan apart, and expects every
> pair to be merged 32 scans later:
> 
>   kernel               failures, two boots
>   before the fix       20/20, 20/20
>   with the fix          0/20,  0/20
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  tools/testing/selftests/mm/ksm_functional_tests.c | 108 +++++++++++++++++++++-
>  1 file changed, 107 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 31c06c72203fd..71d9b3cbdb8c1 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -695,6 +695,111 @@ static void test_fork_ksm_merging_page_count(void)
>  	munmap(map, size);
>  }
>  
> +static int ksm_wait_full_scans(long nr)
> +{
> +	long start, cur;
> +
> +	start = ksm_get_full_scans();
> +	if (start < 0)
> +		return start;
> +	do {
> +		cur = ksm_get_full_scans();
> +		if (cur < 0)
> +			return cur;
> +	} while (cur < start + nr);
> +
> +	return 0;
> +}
> +

This looks a lot like the logic we have in ksm_start().

Likely that logic there should be factored out into a common helper.

> +static void test_merge_aged_pairs(void)
> +{
> +	const unsigned int pairs = 16;
> +	const unsigned long size = 2 * pairs * pagesize;
> +	char *map, old_smart_scan = '1';
> +	int smart_scan_fd;
> +	unsigned int i;
> +
> +	ksft_print_msg("[RUN] %s\n", __func__);
> +
> +	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_RDWR);
> +	if (smart_scan_fd < 0) {
> +		ksft_test_result_skip("smart_scan not supported\n");
> +		return;
> +	}
> +	if (pread(smart_scan_fd, &old_smart_scan, 1, 0) != 1 ||
> +	    pwrite(smart_scan_fd, "1", 1, 0) != 1) {
> +		ksft_test_result_fail("Enabling smart_scan failed\n");
> +		goto close_fd;
> +	}

Can we have a helper to enable/disable smart scan? Likely belongs into utils as
well.


-- 
Cheers,

David

