Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A15FED2F9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172256B008C; Thu, 12 Mar 2026 05:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120076B0092; Thu, 12 Mar 2026 05:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B6F6B0093; Thu, 12 Mar 2026 05:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E83146B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:44:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 997481CF48
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:44:29 +0000 (UTC)
X-FDA: 84536925858.21.6B2A688
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF35520003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:44:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KQ+donDY;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773308667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojmLxha1deQYdIIhuQcNDyLryvN12h2lBEoniZm93ag=;
	b=1D3ABMlQB6zBtoMPBnrpjhQTEiCV1HoAi3RFHpeyj3EuZhb5hccq6dDJvFm7mKpAe6NGMO
	B0yWoP2/BKrsDbO00cdHkJqp/XhWj9mEWQdm8fdJlkUmcIhGG3MkRb5IQWnBM4H4JR1JE6
	PpxwURSCFG4m4QRz2AN+Eg9EcXJKpHY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KQ+donDY;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773308667; a=rsa-sha256;
	cv=none;
	b=z1qPh+86pADpdTQNcOcteedWRK3uLc/0Sw1QlJI+vud7oU4JH/X0j5MI2x8RT0TP8Bd8HW
	o+QgJQURP9ahhRTio1KtW5SRUzharSRfbyXx+9KyfPlAKH6ySn2j42KIM9mqcGLY8Dt3LN
	Jv6hoUszi+IkSlQdJwh46++THxXrouw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31A8C60131;
	Thu, 12 Mar 2026 09:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A98C4CEF7;
	Thu, 12 Mar 2026 09:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773308666;
	bh=HLyU31S9hJ021HpauT6E9MQ/KG289clmC7qT/amVOJ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KQ+donDYQjFaHp/brCTIbu5qdbGMTuVQVgQn6HRb161dCXNKXrZxG7F6TENzoHDgJ
	 +8WRpKalgfXf6mUngv7VtJYq8L7BtBsem87Zryd1Y6L0MdQQb8m72c5q9Rltqis3jZ
	 OGJclJUd9bV98pA7dcXZmlErgT2iAOZmY4Oex+gCPIyLoLvN4gK7aYoIlw7N5/2xkb
	 iQc24Wd06mPXtaRk06wFpZYTpktook79dfF1rMNlyechAt5tewM5SWCurvm/9KKyMZ
	 3K6noyAlqqDM8irucQwQdxUGoYApxwFvXi4wP2kyolJEyRvxKhM7UPOM4zidRdZojc
	 XykzldYoWkCgw==
Message-ID: <4bfec2c1-9747-49d2-a490-87ab204cec1c@kernel.org>
Date: Thu, 12 Mar 2026 10:44:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 2/6] mm/migrate: skip data copy for already-copied
 folios
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-8-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309120725.308854-8-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF35520003
X-Rspamd-Server: rspam08
X-Stat-Signature: 5njsoccdcx5ay6o46y9j9rys8nmbk1b7
X-HE-Tag: 1773308667-382990
X-HE-Meta: U2FsdGVkX1+VNbMHGgn3Kcc00hcbkhirCI80IOfjAfsVzjVsGI14hVQ5oE2zOgJjLEWT5pKbwIoFFrse1r7DdbPLglkWnqFsFL0Kcl85aT9rupu7F80JDQA4+OHGxMUhDf16aixTXqajQzWTxy/DNhWKqDz9PBuCyBtbfyojRP/+Zv6k5+0iMzD0v9t/z6kxJMeytZ8OjeVL3WfTfR2qh0v+Lg+Q1RY1ULUMxyWRyvfmvTD+fwy914+eo6JvrjrM2X43RG1B9byu43uAvhGaf+3lRQGdq/YAQaO9kkia/7Uh/dRU+pmPchJyYcMeiD3DMSR55u2gAGO59fnAhjui4yZU/pkckfHhFay5QU3lqoOkHnpBNNLZEzK89cm+X/C5SSvCSmRgRpPmm4LWKYklYsCwzr8MwOM2MxvJi/O2n5h++lqBFhMOU/JphsLZBiy2ohvqKfuUA5+rfW6cDR81vcsGuJAi0ur6k4VLbTXTZYWhL5DUBXFjRNERmZq1ZJs0ij1ZnVT2Cc7vkW4DLXHsK94c6/BGgzJMKXXX9HDlsumVOFzhOa0kFLEzKDxXXBt/TQEwl6gMG3zgZu9gNJAT6aIaN1gQ6BLUVrBAQ6sJzzBtpwKum+rpW9o+osksPrWtj90IrToz8Fvbu5JYS/iNDns+BrS6DzkRCh2n0Jty0Fo72Nm7cUlGv419AFdxEn5MFwwPDbnDQzn7c28URz6BLLDPFro9u1jU7oeQIAKVX5yoAHlhX7AFPz6kQ6dl8R7jg5bPYWczkkumjDOSVCpDxYiUbTz/ATlh3oLayo6rVk5Wt0finANMAteZCeCIavm4CkKKRnhvRsRy6dVqSVHhRz6RZTAjU6OgOM+bOy/NNMJtt6SWJUZRvqqNV9rIfpQdgP6AAfzy3rkQEgdcwfxMnPFn4RBZtc//26tpD6P9i0NTRXeQrjqPFFfev4oiDg44gpSnp+WKjXfqjoFxKUe
 4eHFfBAT
 WaIrLAYzIFedQ1jJCw8EBDTZtAZW2cS9KQi7i4e68J6AGf7DGEujxPuGZ9Hz1JYp+EmOuH4bwy/sJ1WboWcbg+nih1ACw4NVmmEf9gW9KDEDvzADInmRDls2NBzJDlN6O2mmBjSw1/2j7vGLDgKns6ciyGg9B35V2FIW//W/ebuRff04zkYJquQH9tVEGcPrvFqvy2cSxjYwwQoX3SFVStpAulREt1Rdal+fcIi4oJUtX9GgD988HoYW4S7YLu20Da/vqAVYmkixMHza0Sa6Hcg7iF9WV0xgwttlwOEZcyZYZSkjiqKHrQkbroM60TNKzdQgBBXpxktuDvEDHiu7Js9sCwuXcux78oZT5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 13:07, Shivank Garg wrote:
> Add a PAGE_ALREADY_COPIED flag to the dst->private migration state.
> When set, __migrate_folio() skips folio_mc_copy() and performs
> metadata-only migration. All callers currently pass
> already_copied=false. The batch-copy path enables it in a later patch.
> 
> Move the dst->private state enum earlier in the file so
> __migrate_folio() and move_to_new_folio() can see PAGE_ALREADY_COPIED.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 52 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 31 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 1bf2cf8c44dd..1d8c1fb627c9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -848,6 +848,18 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  }
>  EXPORT_SYMBOL(folio_migrate_flags);
>  
> +/*
> + * To record some information during migration, we use unused private
> + * field of struct folio of the newly allocated destination folio.
> + * This is safe because nobody is using it except us.
> + */
> +enum {
> +	PAGE_WAS_MAPPED = BIT(0),
> +	PAGE_WAS_MLOCKED = BIT(1),
> +	PAGE_ALREADY_COPIED = BIT(2),
> +	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED | PAGE_ALREADY_COPIED,

All these states really only apply to proper folios (not movable_ops).
So once we complete decoupling movable_ops migration from folio
migration, these flags would only appear in the folio migration part.

Can we convert them first to state it clearly already that these are
folio migration flags?

FOLIO_MF_WAS_MAPPED

...

-- 
Cheers,

David

