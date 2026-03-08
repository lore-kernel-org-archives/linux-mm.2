Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A50EA8546
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 21:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8536B0005; Sun,  8 Mar 2026 17:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655806B0089; Sun,  8 Mar 2026 17:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578A56B008A; Sun,  8 Mar 2026 17:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 438426B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 17:05:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E25961A04DC
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 21:05:34 +0000 (UTC)
X-FDA: 84524126988.07.F4F720C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 42D432000C
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 21:05:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rch3nReA;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773003933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fz0hTxYnVaaNaRWjJ2cSwzZsZN1NNo20/O+xaLByYmM=;
	b=kPFIZMzUwxF8tvI7X6yQDACiAq6fXzXPLS3Xary7GLCQHsWO2dMB+UMzfmYS4G4TyhFUaW
	gwa5JPu4i3v6d0gxnQo75EFoROSYbzcCsanMS4QS0YDBfmVJ6sCTGBMBdIQ5toOMhGSTFr
	NNU4NjqvS7AMNBrhV+Mf2M8xJ5cENKk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773003933; a=rsa-sha256;
	cv=none;
	b=j56S3kWQAD8oDEB4t8WkGhMq1APGuUbidJYyYukZCW/byxcQOkxvfLGrMprCV7C5PL+WTJ
	+sY5APYb6EF+SW65175Dsx20RM43uuRwruvLXURHsDSpo0tpTZ4bQx9Ip5Z44OAY4PCWUn
	fdaIDzMDUpwAmt6YZAW/Ft/sXMxFSro=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rch3nReA;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 57FB960008;
	Sun,  8 Mar 2026 21:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DD7C116C6;
	Sun,  8 Mar 2026 21:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773003931;
	bh=X2iWXWJ4ssDw2wUAjr6v8vk50icl4TKzNNwYwDBMJps=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rch3nReATYwOo0Ok5ueUob1xAdZakSjEwbCaa8ER1STIb9ndzWpdaRn8qQqK88g5o
	 AcEba50+wuoLwQ0oAUZCc4FgouCvFbP5biVJlXYb54HVAs70U+CC7gHMILy8wjdOa5
	 DKW9TYM2wZg9y6PXkw/4CxYpMuLV/E8yc0RNlLWc=
Date: Sun, 8 Mar 2026 14:05:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org,
 kernel-team@meta.com, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v3 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-Id: <20260308140530.9ab6d1445d0936467eab4aef@linux-foundation.org>
In-Reply-To: <20260307-thp_logs-v3-2-a45d2c8f3685@debian.org>
References: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
	<20260307-thp_logs-v3-2-a45d2c8f3685@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5uoqy71p4tcgrdg3js3wshgsgndjomye
X-Rspamd-Queue-Id: 42D432000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773003933-983451
X-HE-Meta: U2FsdGVkX1+XFk5IQWhvQQRAs93otR9VGzkfNgJ4IJkzghyUcwYn/MQXgTmF0Nn1aOZkknN/b42BAQpeKVEsdzueGdZCe4nEkZuwt+RlaE+h3tDbWbIJqMij9xoIvI0y2yUAnR1vyA6jLawSqQRhaqHiwxfYRnR34paEFjkNoTsSoZyWT3VpWaLZbkDTIRzx+II/pPtWIrl8jxFeix51UnV7phvJNO2rIhn7mICv3UaR6ec1MWR8TokcHaxpqBNjB2HEPu399RHQe4oJphjRKXXAAZTi3S/0qXUmuQ/6Oa3xf5FVqHb14fotF/eutiHJe0ANdZetkbNNcCgyY3TcxYXPYW+4hbkxlpooGnakA75ti2aXJITOGuBl7/k0ZvhKKNvaRtvnPFMQZijZvZOZDYKdM3G0DwGZYfG1IQLf5rMFUrjvJe77TCQXb9IdbviA4kxgD98RvTW4DZE3/G0WxmclE0PiYaNotwp+JydWcurfa5PZBOdRIabh/WRWqwDoOLB+Vsx4Weneg+WujwWanjd+bKrys8rJhK5y8Xa8TA1KAsTWE6WllF/lkWd/nfEFNg65GqbN0zzoYGyPIiy8igkUnAQFSscKHiAYoMgNSgYXiK/dP0diMm4idEqt23Y3PClYsghrp+Dv7COfE99LjQBEIVVZqY6WxqdWDqBmRBa2RaSFKumfOfqq9lGWE1Jnyd2PO50YxH7SMHb422iqytMqODKQ9re7g3seAOlyH2xqo11wzfMdC0AaVoSN+vbz1jyuEmtOO3+F8bSNYv9dBTl+qE/MepoArOWY6WGBTocGhSyVDvTYOHTSo9YWSksY60Wlg13bv6Xd5JgFOeggD19z8RF+Ny21FrV8om6jsQIVhi7bgh8SlXU+zejz1UQtDsDKEgbKqas0S5XNlwJoGDQtqSZFN+Mq7MbKLSasNU/5gsIIHwymyqgZdKq6m/baUnz4PNUqCtIdZ88J27C
 GFRQQs0W
 8pjMP9Nk2RwnflaO3APwk3+QR3dTmlUo9RsIEROvHyKXrcfBKfiEk5ZV7ruNFDoZ3/lU42ZVEEgAYvvussgjw8J2R67snElEP2dCooHPdHvfeaSTB1VehYuZGp7GTl66gJvyiIqXIubn6bBegRIWkWa5SIDzWKudN90ntw9Tzt/Vh97ZIj1WapgBZIAdxW5aOty6VISGxN1u5S5bJ7P8JksWG6i7+9ZUo+Udl74FfN3AADS/dCwClAmDujqwSXXJ12eQtnmc65Pag9rqnzJ1Bj7Zxrf+MgCeRspioBqqPb03FY9PwTtlp3IcWlsMNAwg8hkei
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 07 Mar 2026 08:08:06 -0800 Breno Leitao <leitao@debian.org> wrote:

> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new change_anon_orders() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
> 
> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
> for the per-order anon THP setting.
> 
> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
> to replace the if/else chain of sysfs_streq() calls.
> 
> The helper uses test_and_set_bit()/test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is
> only called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve
> the watermark recalculation behavior of the original code.
> 
> ...

Somme nitlets, feel free to ignore:

> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
>  
> +enum anon_enabled_mode {
> +	ANON_ENABLED_ALWAYS,
> +	ANON_ENABLED_MADVISE,
> +	ANON_ENABLED_INHERIT,
> +	ANON_ENABLED_NEVER,
> +};

If we're feeling fancy we could use

	ANON_ENABLED_ALWAYS = 0,
	...

here, just to make it clear that we iterate over the enum values with
an integer and we *require* those values.

> +static bool change_anon_orders(int order, enum anon_enabled_mode mode)
> +{
> +	static unsigned long *orders[] = {
> +		&huge_anon_orders_always,
> +		&huge_anon_orders_madvise,
> +		&huge_anon_orders_inherit,
> +	};
> +	bool changed = false;
> +	int i;

	enum anon_enabled_mode m;

might be clearer here?

> +
> +	spin_lock(&huge_anon_orders_lock);
> +	for (i = 0; i < ARRAY_SIZE(orders); i++) {
> +		if (i == mode)
> +			changed |= !test_and_set_bit(order, orders[i]);
> +		else
> +			changed |= test_and_clear_bit(order, orders[i]);
> +	}
> +	spin_unlock(&huge_anon_orders_lock);
> +
> +	return changed;
> +}


