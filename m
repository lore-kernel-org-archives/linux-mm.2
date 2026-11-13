Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3D6606A881
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mlh/iknC
Received: by kanga.kvack.org (Postfix)
	id F1E8F6B069D; Fri, 13 Nov 2026 05:17:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF66E6B069F; Fri, 13 Nov 2026 05:17:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4F36B06A0; Fri, 13 Nov 2026 05:17:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C24FC6B069D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F494402E8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:17:57 +0000 (UTC)
X-FDA: 85429694994.15.0F87B4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9912D40005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:17:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mlh/iknC";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794565075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZLmD7hsU/6QEyVPCXGzkI+ZZAvpViPfzCZeFeE5hYc=;
	b=i5QttLxYC+jB2HsYGhhoQeqlDok5so9GS/UnCunGHyZT4lUUFI85fXL94J7pBiiCZ8DiRr
	41jy7ZuwZkQhCz7eNHG7d7/PXgRto/iY8jOvek1FTaDjjpdj5mJfXD+JCcEyrN+fCz5T8v
	AGdivCrKdonBzfzDehuRKUZG09B/oFU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794565075;
	b=5wrWi0XA7Lyeg6hYTpMVlO5esXWV2PluY5/LnZQm09Z0ixT0XtptsEeoInwkeOX2OTJMBl
	XUGZA66mzfXFOeNN4lpQ5cpzevC+TUgYQKObSEEKz513f0XGXMzGvO/SoPNgMRBkXj1lyw
	+xPLq1lFR14ifRGMjSiAr3CtMlV10Wo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mlh/iknC";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E0BD62681;
	Fri, 13 Nov 2026 10:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BBC1F000C4;
	Fri, 13 Nov 2026 10:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565074;
	bh=sZLmD7hsU/6QEyVPCXGzkI+ZZAvpViPfzCZeFeE5hYc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Mlh/iknC2FK9BSatYYtrb6t4ST8Cm5jjehZaswXTPr5pAlNcGKwzX2FZoGuo1ouZN
	 m95lpM3urmBlqh9o9LHelgPLM31Iv3JsQSI2DiQ7MeguGWmhN+eU1CVvWjvr8biRWx
	 8V5d4/DbXA4p0h8v1Ne3tgOTBuiUlX9hndMwxyZ6gbKxxY/tkRS6SAumtWNjX+Q5qt
	 iQHaJl583sJf3P+TNZ3M4VNlv9l7crdo9scokax2cT+Xl5azcdoZrTW4mXISMNKPdH
	 tRhEI7NG4e+FxFS9U+05A3MtKdr1BwNB081ybDO92bYdamQToNYRwQ7WBF+NDgbEGi
	 BUtgQwy3lFtCQ==
Message-ID: <5ca50c99-8dfb-42b1-b593-16bf264581e8@kernel.org>
Date: Fri, 13 Nov 2026 11:17:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/folio_batch: document missing struct members
To: =?UTF-8?Q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261112-folio-batch-doc-v1-1-e5a1c013e4d6@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112-folio-batch-doc-v1-1-e5a1c013e4d6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: stuqenxesakrp7iamc46izq5oe9f6f6n
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9912D40005
X-Rspam-User: 
X-HE-Tag: 1794565075-477646
X-HE-Meta: U2FsdGVkX18CczRpMb1gAXmic7xs5pZu9PJlsfZsjbkWgeTK/LGO/vLYyAiW0QgFL9y3QvYmqC+KSfyJzVmfJIwgySgiCq0L91xW5BtJ/7NlixJOLFFtH/M8EgDb8lk/9C3icg8CCeqYYaFqNEMRoVEbz4J1BsXEY28iyhs3QsLHfi9RgCOrtL5i6pFmjIDYD69rVIleKWBCsF8W12udnAejx9noClx0M6iCgV9VeQUPgLMKhU7L+3l8m74KSey4fJm2WvQ8CBnHCBzkk+/SB9gFwA2nGbjYoVVq8vhdZHmxSrEHooy5CRM+3i4qIFiaHGuSXVstTsHMwuj3Hcc2ITEAvuLmi7aESm/4lthz0mVsSxuHEBqpg0yrpQfAPJZhP1hBgg1xLxxKRarVc2IQfKZ9P15TQwze38rz7NtUTEUywTVqTUMzzP6QHBOzI2avzGYhy4kWDNOUz0XrShfw+3OMCHjByku0GEOVIVTT9irswNxxJJw37tSKMuvA8hkW3HqQWfW6oGed/XoltX3z+/6eEBSJQjjqtZP2ZZqC8VnvGolIL5mZTHErGxE3joRRN3u+VtsGn3PGO/541LC2fWunvNdGRMhtS5BXgp6J88bM5A4i/maiIin19TIYT8XcHqxwI2ag5WGtnF+NiGuyAtq/fRfupyb1339BtEw665OhJHD836loQWLJx9a1D5qjw2e0lQYTHIiqDS20PL6ZB+u1uOJ8+7YWnlPOanUNUCK6ZnSv2YwqAbk2E8mSDGm6cpBqrD+OBjfu8zH1T16bTJ7mv+MhbCs4QieHoNOKGJTcufMW7lz+gTKbCu3E8lGMrpH0Z9eHMAikDO1cDCXGqac9JtADEpwzMwB3NpO3o3QH3MiKNaEfpSUMBEVoKrKsQzSv/sQ462QT93eObvCUG9IJqJoduCz0eLv0llvHhwGadnX+kZs189GEoOHOOwbGTnGjpEXwoY8xvmg/qqu
 2ttgX2HD
 7+hUF5TwcbOmsINQdgfeyD3G7ocPYIpweGvwuAf3rSsjxWAdPoFtL6x9tb+gGv3ADMSCJgOxdLd85jpC2XWNDxSABtg2CRSXfZoBWw111gMbMylDDYDhBkntklH7bVlq7Zfb4IMDQTdujrLMPZOZe7dDa9Z3PjSXkjoRrDOgeQG8Orgjm3q04J7mtTRVFs/ml9YAZHHqAjeCzMMJBJtBLp63fYl+78cP1fkFLfHpECJQgcvYCfv+tjHLSftgTAaCh/L+NQSVB5+WR6qNL9MMKLS0MvechjhoTpMU0LKQjph8rJa81PIebBiwFP9ko/yitDrTdMylqL+lUZ0qdgQjrxKKTLFvVufGAER7p3MYJMUYoSjpfucVadCiMRQ9zGaaXAP9C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 05:10, Oscar Alejandro Sánchez Lucero wrote:
> Add missing kernel-doc descriptions for @nr, @i, @percpu_pvec_drained,
> and @folios in struct folio_batch to fix warnings.
> 
> Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
> ---
>  include/linux/folio_batch.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
> index b45946adc50b..7731dcd249a8 100644
> --- a/include/linux/folio_batch.h
> +++ b/include/linux/folio_batch.h
> @@ -18,6 +18,11 @@ struct folio;
>  
>  /**
>   * struct folio_batch - A collection of folios.
> + * @nr: Number of folios currently in the batch.
> + * @i: Index of the next folio to process in folio_batch_next().
> + * @percpu_pvec_drained: Whether the per-CPU deferred LRU queues have already
> + *                       been drained during __folio_batch_release().
> + * @folios: Array of pointers to the folios in the batch.
>   *
>   * The folio_batch is used to amortise the cost of retrieving and
>   * operating on a set of folios.  The order of folios in the batch may be
> 
> ---
> base-commit: 9d66f26fefacebfeed15de31c1123451a17ff119
> change-id: 20261112-folio-batch-doc-fa4f7e18ec85
> 
> Best regards,

Waiting for more review before queuing this.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

