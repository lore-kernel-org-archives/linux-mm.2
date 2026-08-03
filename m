Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E071BC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92AF6B00CB; Mon,  3 Aug 2026 09:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43C26B00CC; Mon,  3 Aug 2026 09:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D806F6B00CD; Mon,  3 Aug 2026 09:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A61996B00CB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:34:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB2DDC06B8
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:07 +0000 (UTC)
X-FDA: 85059676254.10.D08452E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 07666100019
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHOAih4y;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycZI+dP9lyNyUvbZGErQYkVbB2SU/4cSINSvONZ92RQ=;
	b=lk5HBuD6/oYyUQO8nB8SgqY1tIM07wj9OGS7Whf6I+TsAshtVOlJWtbVpPWh+e/GlsbFl/
	LmeI6OANFMuydKY33INCLmBo/TBx0xOrhyQd4obUw/UifnU0tp+m+4x1SIkPSt1yDnMX0L
	2KbD3Kme2CrGZYIGiDuuBWlwnaS2qK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755106;
	b=2bPZ7BodvLivGnCMtX9rz2qY94v0wmCoK9+rhs1KPbRvff2W2bM3+AwVwXKvlEvcgXddHD
	7G3iuPrSIYxRcO5qZp/JEre52EcwBxpr1LkrI7X/I2NLBm/hLgMddIL6Wh2Mi3A3+rKs+L
	eOZ8hk9MpqMYMQyf2k5ia/DbefBRv2w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHOAih4y;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5256843BF4;
	Mon,  3 Aug 2026 11:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD391F00A3D;
	Mon,  3 Aug 2026 11:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755105;
	bh=ycZI+dP9lyNyUvbZGErQYkVbB2SU/4cSINSvONZ92RQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=FHOAih4yfEX5WHe52OXAdLKXQDI666arpJC0SoTN86Q/ZAp2XD+qubZr2xAGFOUoS
	 jz4bVfp1yAfJU4gobIyhaKUG3A7Y+9DtT5S1Bfn39WnoIBXDnUSihrenRoQohyvOqv
	 i4c3mZ37h4lzcUMDK0nRAnJOcPSFekmk8BcYMUPsJX9NwvdJmqBtx1r0VCLjwXuvx4
	 gRtUHGCgVEvgHfMor0VDs5byhv2igUTSIup9DNpQMQ4L1cprg8hoLxuSPIdH6D3D2D
	 7FauQf7kXNeJd9ITREI2CRNTp7VUc9BVsU2KQ/I5qjKT5S/WqU2J86WRtkzh8xJCHA
	 AcB7G0kmraZyg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 05/16] selftests/mm: add khugepaged completion barrier
 helper
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
In-Reply-To: <20260802195254.1937477-6-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <20260802195254.1937477-6-kirill@shutemov.name>
Date: Mon, 03 Aug 2026 14:04:23 +0300
Message-Id: <178575506331.1561566.4863322190872953233.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: feqp1fins1m57q7pw75ddd83ngfg3458
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07666100019
X-HE-Tag: 1785755105-423438
X-HE-Meta: U2FsdGVkX1/Z4zc9qdbZXuBJwyl51zl8WoESJtMP7lEGrOz4wXOLBXv5rUELl4uyXShiKrNp8exGAHaHopa08QpOBCXrMZirVUxRBb7cV8aUeUXBr/vSEcUJUZHDmBBXgQSsG5lUN9fzIcEfKQrfdBTOJWHA35fOZrtn3q+XS+JveroqXYGnVAKQRvMaOtoPgRPYVjfXcltVa8dtGog6BGB9wmNpsnZwJ54FZZfGzDe1LHJpfJ/Vgq1j46/TX0l9tjuDbeTvqo0vTOKTmOtDYvzx+RXiLylkHJxD10wtl5KpPdD5jeO8oFq/6ylpSS4fXnF+zV+T/Gs0OVOg5WuUxTIDma6cpNHI3hWuRfv1rozYYrnipfbs3fSL7JkqiwJqndVyvGMIDH6NX5R2Zc6U5NvB0A52jnpAmlohtJg+itTzciw8q0IEpTGupoVBpjXpITPH0PNJkqHGpF9osUOK/a6JTRTtZMqQXo1h7TFRAIs0Mm8O5Ka+egvIF8ymtFLyxjULBpid6JRumeza/loV3JvVyQJ1t+v0Y13t55/rG1iehN9SKgkoDVhg9PlacsCRiKhc378IcmMcTPZRSbNjdSae1Bz6vdlw5cRr5eEbE/4LHPBm9cCsWRz5NwIonbalWbmB5JvoEnra3SLvbP5Jm7D2+eGewmAlSmyETDfJr3KqPpSKnryW33+k9kkT5T/+H+Ea3s6fbf3Gg4KoMKDGm08goDeaDxKw6jiGC1YOQrLVHoNTHUok4SoVc5GGFrTWcAw6PFYFUUjowLZQlCw+wes81KrGOz5HO55u3Jz8P3Q3xDds3qi5TUnxyBbO5F5skiwx69Ml91HfsM/znt+Bxz2rRmlqpQsFko8lLYjTu+z2BxNKeLeYDPaSAkAkTf00QopuB0N1NhIW+4dUulmi+dVOPhj6Pm+sizj/aOALkDpoDR2lG/Q5ZoeeSKYoweTu1XPOaIFTBA3ooHY0+JB
 u2NcO1K3
 FcUi1yg1RZs/SAgoab39zrr6zYFJHRgDX2cx45ySKtZBwiZqUQ6yZ+0RyaYNe+T7C93GslYCMWZu/Q0nQEcxJ+fIa2/6nT2Omjj1rjNbsMx8LCwzm5hAxAvamT8cttcCy1J8P+nLKlCoXRMX0RCuZHCf8qkYh2HiYgnw/Idu0srFr/Bl/j0DfrmcJDdx9hW+2Au4QVPNWKMceovPA3FVp2iN/oaLlB09iPFL6X+WJMimtr7l86YjHxZYKb7RKteDeLvc3oLjenOwRCeM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Race and functional tests need to drive khugepaged synchronously: set
> up a layout, let exactly one full scan pass over it, check the result.
> The khugepaged selftest already waits on full_scans advancing by two —
> a completion barrier for one pass that started after setup — but it
> relies on a short configured scan_sleep_millisecs to make progress.
> 
> Lift the pattern into a library helper, khugepaged_full_pass(), and
> drive it by the sysfs wake path: any store to scan_sleep_millisecs
> wakes the daemon, so the barrier completes promptly regardless of the
> configured scan cadence. Wake exactly once per missing pass:
> over-waking would queue a straggler pass behind the barrier that
> overlaps and perturbs whatever the caller sets up next. One wake
> completes one full pass only when the whole mm list fits in a single
> scan batch, so callers must pair the helper with a large pages_to_scan.
> 
> Settings pushes and pops must not start passes nobody asked for
> either, so thp_write_settings() now writes each khugepaged knob only
> when it changes. Switch the khugepaged selftest order-parameterized
> cases to the helper.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index d7917dce3aba..a26a0cffa9c5 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -183,6 +183,17 @@ void thp_read_settings(struct thp_settings *settings)
>  	}
>  }
>  
> +/*
> + * Write only on change: any store to a khugepaged sysfs knob wakes the
> + * daemon, and settings pushes/pops must not start scan passes nobody
> + * asked for — khugepaged_full_pass() is the only sanctioned wake.
> + */
> +static void thp_update_num(const char *name, unsigned long num)
> +{
> +	if (thp_read_num(name) != num)
> +		thp_write_num(name, num);
> +}

Don't you want to expose this to the users?

> +
>  void thp_write_settings(struct thp_settings *settings)
>  {
>  	struct khugepaged_settings *khugepaged = &settings->khugepaged;
> @@ -198,15 +209,15 @@ void thp_write_settings(struct thp_settings *settings)
>  			shmem_enabled_strings[settings->shmem_enabled]);
>  	thp_write_num("use_zero_page", settings->use_zero_page);
>  
> -	thp_write_num("khugepaged/defrag", khugepaged->defrag);
> -	thp_write_num("khugepaged/alloc_sleep_millisecs",
> -			khugepaged->alloc_sleep_millisecs);
> -	thp_write_num("khugepaged/scan_sleep_millisecs",
> -			khugepaged->scan_sleep_millisecs);
> -	thp_write_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
> -	thp_write_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
> -	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
> -	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
> +	thp_update_num("khugepaged/defrag", khugepaged->defrag);
> +	thp_update_num("khugepaged/alloc_sleep_millisecs",
> +		       khugepaged->alloc_sleep_millisecs);
> +	thp_update_num("khugepaged/scan_sleep_millisecs",
> +		       khugepaged->scan_sleep_millisecs);
> +	thp_update_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
> +	thp_update_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
> +	thp_update_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
> +	thp_update_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
>  
>  	if (dev_queue_read_ahead_path[0])
>  		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
> @@ -230,6 +241,43 @@ void thp_write_settings(struct thp_settings *settings)
>  	}
>  }
>  
> +/*
> + * Completion barrier for khugepaged: wait until a full scan pass that
> + * started after this call has finished. full_scans must advance by two;
> + * a +1 step may complete a pass that examined this mm before the
> + * caller's setup was in place.
> + *
> + * Any store to scan_sleep_millisecs wakes the daemon, so the barrier
> + * works regardless of the configured scan cadence. It wakes exactly
> + * once per missing pass — over-waking would queue a straggler pass
> + * behind the barrier, perturbing whatever the caller sets up next.
> + * One wake completes one full pass only if the whole mm list fits in
> + * one scan batch, so callers must pair this with a large
> + * pages_to_scan.
> + */
> +bool khugepaged_full_pass(unsigned int timeout_s)
> +{
> +	unsigned long deadline_ms = timeout_s * 1000UL;
> +	unsigned long sleep_ms =
> +		thp_read_num("khugepaged/scan_sleep_millisecs");
> +	unsigned long elapsed_ms = 0;
> +	int pass;
> +
> +	for (pass = 0; pass < 2; pass++) {
> +		unsigned long target =
> +			thp_read_num("khugepaged/full_scans") + 1;
> +
> +		thp_write_num("khugepaged/scan_sleep_millisecs", sleep_ms);
> +		while (thp_read_num("khugepaged/full_scans") < target) {
> +			if (elapsed_ms >= deadline_ms)
> +				return false;
> +			usleep(10 * 1000);
> +			elapsed_ms += 10;
> +		}
> +	}
> +	return true;
> +}
> +
>  struct thp_settings *thp_current_settings(void)
>  {
>  	if (!settings_index) {
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index 726c73c43c05..8de446affeec 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.h
> +++ b/tools/testing/selftests/mm/hugepage_settings.h
> @@ -83,6 +83,8 @@ static inline void thp_save_settings(void)
>  	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
>  }
>  
> +bool khugepaged_full_pass(unsigned int timeout_s);
> +
>  void thp_set_read_ahead_path(char *path);
>  unsigned long thp_supported_orders(void);
>  unsigned long thp_shmem_supported_orders(void);
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 971e97a7330a..65fafab06410 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1126,23 +1126,10 @@ static bool range_not_collapsed(void *p, size_t len)
>  	return true;
>  }
>  
> -/*
> - * Completion barrier: one full khugepaged pass that started after this
> - * call. Waiting for full_scans to advance by two guarantees it; a +1
> - * step might complete a pass that scanned our mm before the setup.
> - */
>  static bool khugepaged_wait_full_pass(void)
>  {
> -	int full_scans = thp_read_num("khugepaged/full_scans") + 2;
> -	int timeout = 60; /* 30 seconds */
> -
> -	while (timeout--) {
> -		if (thp_read_num("khugepaged/full_scans") >= full_scans)
> -			return true;
> -		printf(".");
> -		usleep(TICK);
> -	}
> -	return false;
> +	/* Wait up to 30 seconds for the pass to complete. */
> +	return khugepaged_full_pass(30);

This implies that _full_pass() helper should be in a patch before its
users :)

-- 
Sincerely yours,
Mike.


