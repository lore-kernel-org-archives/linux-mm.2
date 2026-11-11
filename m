Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04CF4606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f+WADTlC
Received: by kanga.kvack.org (Postfix)
	id 172036B05B5; Tue, 10 Nov 2026 20:31:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149486B05B6; Tue, 10 Nov 2026 20:31:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037FF6B05B7; Tue, 10 Nov 2026 20:31:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D82846B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:31:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF46D80148
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:31:28 +0000 (UTC)
X-FDA: 85421110656.10.54B27C9
Received: from mail-pj2-f6.google.com (mail-pj2-f6.google.com [74.125.227.134])
	by imf27.hostedemail.com (Postfix) with ESMTP id B8B954000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:31:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f+WADTlC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794360686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvimweWXdTkslV51aQTQuVA5EhGHU7gBJImiZfr2+Uo=;
	b=hg/nxFhWh29QtYKhUshaLu3WE63xz9e1f7Fw3U8QaSYta02VDR5gmh5imRqBOCkofhEWQw
	NisbgxGncBy6t1g8zDmo3v+QyHvzT8SvzvQSvHflm375J+2v52YKeQiJhckXiZfhVqU9ru
	Zm8NlQt4uyXSiQYmFcHPGo997gQEINc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794360686;
	b=1MP4C67822dQBhtK2yfV4rPJ+8vq1DP6qKs6QnYIpsfwXLE1/kFWO5MRp34HlW7TPnZz8b
	xXclim+mYBSbVIj+r+WoyVu+jsKWskBrbLnLhi4jVAC/QghPibPrVA/qC1E08AnD6wC850
	7zOZX6Q8zwVY/1mbclxbzeOVSfwjdi4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f+WADTlC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f6.google.com with SMTP id 98e67ed59e1d1-3ad211ad92bso980627a91.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794360685; x=1794965485; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vvimweWXdTkslV51aQTQuVA5EhGHU7gBJImiZfr2+Uo=;
        b=f+WADTlCLoNLc3Qy+nAi//HHXydbcN99AYypZ8OoRX6+8OPvM3yDjevt7g/dsCpsA+
         OlnxR0EMoUpRNltUYNJLgCzXhGgTkJux80T2T7E31ow3loy1j7SDbgms4ZsSdBIO0vdK
         DbCrIETC006Hfm6SbLLBCLbbxvJFfY+AVXDS0gK8we+IeXKrCIhtOfTWs12YYDUS61xy
         4ssw+4rrwjQ3XcWApekVh5IbmyZ5nJ8Xwj4Yhnt4fGdnkVOVR/kZe7LpqVWbuqmyY12u
         rCvrnB/feN8VwVjprmZhBV1PKxLhqmfKs9mtViL/etVLaADai8U3fBClbadSEZr8CeZ+
         Ed+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794360685; x=1794965485;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vvimweWXdTkslV51aQTQuVA5EhGHU7gBJImiZfr2+Uo=;
        b=CiSP3YGvwRESqv5/XLhDIDn/WfKJTmlvT9dp13jEVmr2+kCsed8wOD0H2yQ6ojErRH
         SSfimCAgcR7zPImGRCFvIwoDEYdM0JeCIN80gv9ayEfIPfv5XVHkUfHoSE3CFpMXPQez
         PdQlFKbJuUzy1MDx5/PBawO6+fWJMXxEtN0OP6c3fGMf//LIYF7PysPDASaJS+T8tZBC
         3ELUE10ksgidTHzj1QXPrk8N63PDmkoRJX7WTFwVYkLg5C5xcBQMMbKTb/Na9gewxbZA
         utuGZfwOK1cjajAC1FyoFVM8xW9fjQgnNdBTeEnr+y7KnPj8842K96X2/GuFj/KGBRD3
         hjqQ==
X-Forwarded-Encrypted: i=1; AL+hErFmUziaXF0rGXsEJYepMmNfZY1XnACkVpAMJKHnPl2atEJTvnT+0k5Q97Vu42wHGTb7++yTMXVsaw==@kvack.org
X-Gm-Message-State: APuU4Z+GvSkSz0HRjYGCAjYN6lS5FQjfzrmvRdc3rq/aEzPpZjM1IdMY
	9iNB5cf9udXp/Hlha/Uc1uFtTb1WUd5u4yq8WSDcr7eF4EHXhQnDOcTa
X-Gm-Gg: AYBFou0jHiSaiPOeVZqWRtoxhces8yGz8xbFdNQrurdRZcZa2QBCoTZAFKnVcaHpsEj
	3KoDJfLZxLMK4niJm2fh1YYY0SsHzosDA+kV6yiJGlUyZriWp8yJuRdw4ewasakJed1ZzSCqvpN
	T0LGdPNZEWomC+9lawM83SAmRAHtR6H+diPPhlPUgEjePEpuczDb+n+hnY0AgXeGMg9HodvSfI4
	SKtS4XS2bE+sl5iWCvUICRPakWN5B2b7YJ0Gw6vzslIIO4QbNpnjdFEGQImJrDl+sPbKdaQ297A
	j+/fihHKEi1mZhLxffpIBPZIdQG20RDz3yvikh9ewK3zOftmE1ELu5xfb5HIxh/1/MZ+lLZN+i8
	nhILFCZMD3uv95Uo/21xmPA17OosEQv+PbcOhzPAarbfHHONVtcFafQYztQvHIo6QTo+h/z1To5
	lI6zkWlMMbumFpkHvv6BrvI57/UwEeCKa+Gv1rzcI+lPhyIq862LMwblFXJDFxl3hgXEx40is12
	JD4YqBzYIhlSBMMtvCQyjw2R7Yzg1ui0mF2tPnJ9bKgIe8frorimpAVPx6H3uZRityMDWhc2JSb
	sKo0S1Cg15qP72zFj8Kc9Jtf7Xl1T2NlcPjd
X-Received: by 2002:a17:90b:5487:b0:3a0:516d:9f88 with SMTP id 98e67ed59e1d1-3b182eac822mr798734a91.26.1794360685246;
        Tue, 10 Nov 2026 17:31:25 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b182e0ecd3sm441451a91.3.2026.11.10.17.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 17:31:24 -0800 (PST)
Message-ID: <e83df8e0-f48c-4262-b96a-6f99a53df9d9@gmail.com>
Date: Wed, 11 Nov 2026 09:31:14 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: improve mlock tracking for PTE-mapped
 large folios
From: Wandun <chenwandun1@gmail.com>
To: david@kernel.org, hughd@google.com, akpm@linux-foundation.org
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261110123218.1579490-1-chenwandun1@gmail.com>
Content-Language: en-US
In-Reply-To: <20261110123218.1579490-1-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 55mmkmypgij4xmz9hj64ot6a4nszc4nh
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8B954000A
X-HE-Tag: 1794360686-47961
X-HE-Meta: U2FsdGVkX18IfJB29TX6IsIrIAve3w60jgobom9vxVF/fluQ9Q5u9bZKGQFOsz3qRCegpg5nMHpwjImCvqLUn72Qwg0m37LKEI8Xnf1IB3ByWDPlakRpcQw+AIIpVvzwNojoA0uWgcE1x02jubvKnLdX0XASPPooWzN9CfYSXg+bmcwGP14ouombfCC1TOFmFZjdzkBH99HTqabYQoDORW/7oZHvLQmM7vKQEsR30JKnkQAJvCpB7vowzCTOpAG5BLhM2F9tmfutulDYZPNWQ69V11JbHoQbRI4W3MDCdWKVlDZpUoEBwR+At2OCWCvBSrEzuSL3yEGVKAxZr1MMPBR41CnBGv45cz1rnbhb96MwwvG8RCw+lPS1eSGPeSO79rvJjorFQg94gVRQvEg9Tb2KO99XeTmYxAEGDhy6PTGj6YnVHjt9WRezr1/5s8op5LQvIfhnbZhMjcyVTSyBG8lKiDDDhFK11gZdGGiPYSlJdcw5jvWfHjZVX3rVZvhBkRDx9b0MMwZnbH5F5JztQ7IPdivYjsTv39k73FJCSMHUTTflBVlENuqzA/8CtjhV9t84q+Ea87sf7ZLbCAtlPGUyNc8bConI2XPw1zvtJOeLpa7xwFEGScYDg/9MyNTxypBp5o94Uxjy+JcnPZ/t1QQ/kUcoG7p9zPG3KyWGhWep/l5W+O5yfsOF01LkuE4Hz+jhVl6sL2CZmiYDcHseIT8f7UFrZo4UqAYbM3Hby+ev70PdvSTp735UhudNWR+LTo4bdaPpmEd/b49FmzbijiSzuXk+9n7y7FOY8HYLsHeITAREy2PWK87IAYDCPluW79UJyJN6XpTymMTtW3dxonJ0bqvrMnlG71Mm7Qiod1jo8iVFfMLWEnBqKMCKPpjWfri/+KkCSGCI2M9Kfl1lT8ZJDL1ZcnVu9FVt66CStmgWRD+vUf7LusoM8smQsmLcJUhYct7mxxQbmtnFK5m
 7O53g77U
 WL857UBLQCIj5Cx2rvHnYGT25NDRHCEMw8mDF1tDudVp4OECpHuWijitB80l/kDsW52drd6tDdeTsJuqeqzeALgOhIoonhtEs7BVLpjBUM8u5q6OsI0vUbAJKipM1hyXhrFOH8KMWnFlxMoyQBBOOvppqND1YaeuS7WPomDgE/VXg5i6z1EYpkoDQ2aaPUMiEH9/pIGPylvVVzWIAFaepzBaOmod65RuUMQU0fnM1eXukhaYEbnNep8zUsL11a49ZWbXZxIS+EnC2INbWprDIHTeQZdaUKMbgnlpLISpqUxUW4XSaM6kEfMhnxGyOuKokbJbc1j4loJhwCh7/ckGi/d5TLOaeOGlLPEnzLv04vR0d9qr56hvM4KHaWvRSKSYRushCTK8quAkwW2hYy60lJVQXxgtWS+Y4WMvfwIZVjvS0BBmM4WDepjAeGEDxgvRJGAplg68vhovXBOAprZMHUkvF4raWgZTPBbYQCHyZU3KTsb1J6eDdwzB70ht3L34qoo0dmjjn5uWJLImNbgwWVU8WKGnO72s8aBQnI3QRTxUUhfD7d80udS4gJAHu+WvDjkUv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/26 20:32, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Commit ab521b4142aa ("mm/rmap: improve mlock tracking for large folios")
> mlocks a large folio when all its pages are added in one rmap operation.
> However, when a PTE-mapped large folio is migrated, remove_migration_pte()
> restores PTEs individually, passing nr_pages = 1 to the rmap helpers. As a
> result, PG_mlocked is not set on the destination folio.
> 
> Reclaim can restore mlock in try_to_unmap(), but Mlocked in /proc/meminfo
> remains undercounted until that scan occurs.
> 
> Restore mlock once the full mapping has been restored in a locked VMA
> under one page table lock, rather than waiting for try_to_unmap() to
> restore the mlock state.

I forgot to include the v1-to-v2 changelog:

Changes in v2:
1. Reword the subject and commit message.
2. Drop the Fixes tag.

Best regards,
Wandun

> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> ---
>  mm/migrate.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 94033c222e04..140e291d4587 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
>  {
>  	struct rmap_walk_arg *rmap_walk_arg = arg;
>  	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
> +	unsigned long nr_ptes = 0;
>  
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		rmap_t rmap_flags = RMAP_NONE;
> @@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
>  			else
>  				folio_add_file_rmap_pte(folio, new, vma);
>  			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
> +
> +			nr_ptes++;
>  		}
> -		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
> +		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
> +			if (folio_test_large(folio) &&
> +			    nr_ptes == folio_nr_pages(folio) &&
> +			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
> +				mlock_vma_folio(folio, vma);
>  			mlock_drain_local();
> +		}
>  
>  		trace_remove_migration_pte(pvmw.address, pte_val(pte),
>  					   compound_order(new));


