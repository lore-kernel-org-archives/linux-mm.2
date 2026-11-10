Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0754A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onyVj77v
Received: by kanga.kvack.org (Postfix)
	id A98BB6B05BC; Tue, 10 Nov 2026 00:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A216D6B05C4; Tue, 10 Nov 2026 00:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E276B05CB; Tue, 10 Nov 2026 00:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 782966B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:58:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 235BD14087F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:05 +0000 (UTC)
X-FDA: 85418153730.10.C1D134C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 87A211C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=onyVj77v;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290283;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftN8clTyx7M0uKnbE5qzzg/XNyWcJ/PQXvDRxAVfxQ0=;
	b=2eskWmKrASNGUpOh15mILW6G0c8ZmhxJwstpcpwzqfNFJ1YkTCwTE0KRFrPcRDy0UFS5yA
	J0KoJkPgnT8R4jjmWj8g3YlplReq01qVQrwdarv8Ga4mvG5VwNXuKVScePb+pDMhR1TKlr
	aa90X6pmKP+j/BjD05CIIGsdoL/jm+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290283;
	b=OYNQmhd0BZF34gc6vvzXmYkzvf56YBGniQOXiYksTgwpc8sEVc4bQUwwgZ3e+wTfg21hsR
	Y1FtP0bfS96QsWSnAxx0AjI8go0EYPjWIzebF8Qj/27fKWfWi20v+dzv/umCBcXgKBq3V9
	fyK7gkySaneyGr18DcDAGijtWLmiS+E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=onyVj77v;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC74446974;
	Tue, 10 Nov 2026 05:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068D01F008A1;
	Tue, 10 Nov 2026 05:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290282;
	bh=ftN8clTyx7M0uKnbE5qzzg/XNyWcJ/PQXvDRxAVfxQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=onyVj77veORD7XJ0xbFeeWnlI832hoPOrLcxxgeAsT9EWPPWtirMDUaLCqV/WOUXy
	 /AL0RDTLO5YZ/as/eaayO43S4/50SI9QP0I46ZJ/HVB1dvRbrQWQ8ZvOhZChl1VDLM
	 pKtQFd8rzLzixHXcgyrc8jccCBndMUF9r789WRBx/LVYdQvUYNn8BNVC/GjszQm86/
	 sCfC+IemK+/EtkhfjmNDoi9KgRA3+UduJryKOFBGbzVuUF8ilimMxmBJg6OUWnjBVR
	 cMv61Bd7Y5mpqZd6G6CMcCgDosLv1ius8v1DcQj71xTn82YGsto9gBbECD8Ji1GRJI
	 taQ8nx/wK0h6g==
Message-ID: <sashiko-outbox-206368@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/19] mm, swap: use a stable id for xswap devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261109055455.536925-10-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
 <20261109055455.536925-10-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:58:01 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: ti7pmgxq7xogqsekatm4x47xbw97im1b
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 87A211C0004
X-Rspam-User: 
X-HE-Tag: 1794290283-213390
X-HE-Meta: U2FsdGVkX1+yTqKBPza7qVFp3izjeQXP7VgTPvDbAWaHli1sMIQ+Yd+AQjD2iAMPOyd9C1nIubEQqlnRNJbUBiFsXKJRFn2oVNc0lD1PxJqpWn8SdefCYNhmYOCpwob2J8VfaRyaIDn5rIbmk4a5m/WnphVakHvbCwVU1ccN6y8ZmWIkfDhoUy+BmeEhBHq5ytj12i133sG5h6yDHlLpbE5b26ZUv+jUOKLJ3Z96HoiJMM+sWKuPX7gEQs1EYmYbkRN3TGkIf97eRWRSIHrq3NMUMarvOpU+ft++FUY7exK2i8V3Dx1fVhOWkgVnTqBXmPmbVK3O7WECs+lw01bOt6yNo3FaxKQxRAZ+YB+xRVuzETwqQ/EhyVjR81IqK/RNjj+c1Tq1Kh7lyRJMAIM4d95M5lF9Lsh2CxPSzVdbOlvDbXFoaeChKylwR+zHFyEBaueTH1BUk5znQ0GiYc0fzvvnjU9h5HwkJcfon+DrcMUCu8ZQavUmph+EvQYYCj6xxCwgZQll6as/2KgF5kTrIOGMoaqBqZdhhOhqcULHn58KU5OEF4S6FQsgLwoquatOMt8yp1plmCkXJtyRCwSyOdo5dFgGbqB2gELsKRDS+vpxfEAQ8s7QIhGRhAZncPYBB1WFygLjT6kYTjaMJm5uwTl/Sw5WfMdsjLjEa7Dikb2dhRpEri4JjpMKXcgKxqgMdlD0ciqXedewhyCrYZ5TtEQeSX5rlwU7vNcfNQCO8kTu9cPBFiyUGK39XMF1LwEsVnNZIkWANAQgRkYrkY3acs5bCK8NkBj0GmYZ7vEq75GOQ42YD2GucYH3NwTeUbGQve1v8AYzDiVTWMJZtHm4ZD2ueSZumpIqdbpqQOHnMex1B9IO9Vf+CSBM2EwLonooVuYRDzccs0FSdQ0G1XVb5q7eja3oFyWu3I6K573xUzlai02uRNBYIhO9v0fZ01YtcuoVnmzDbpVO+KvIFtj
 3P8XTSVN
 tLU5ZVb3w+nIeGGa31CxzQoAjLSApkQuhlRTQcxwR0A0sIoFK6/3pcf9eXVV5EjbSCPfccNTRkdi/mfQr1B01FbxENP0e4aufIs5SI1QvyDgKkVLvLS7h8lAT7pu/GzDiCTfiA23HAeVlRth7jQRp1W556LLbhfDsRw0v2otHA63CX1EjjhPvXXOkpicYO5s//2ydjCpGhOi4unDS5c0xOIc1zbSm9gXz8AOurzMMpIX3gKSPck1Mvl47VNK9u3ghXKHlKilunrAWIZS6FjZBkwW/IOsVKQv0cErYRvotmgiy1mA+IebJlcgyPOroEnRkPxgYLpJb6fo38Fd9R97DsRhylnx1fY7YtLLLpVWbc+i8FwSdtlPZCwYY6KMw809EQa5wm7n0gpRa9AXitDCjd0/BZ2gJMsPcjJ/og0ugwgH5mq2UqRCuyHTTCCfe8/J3zsoZmzQONz6LX1zUzleZHkwLQTk08ayhwm5fTpq/kl4h7dg6RuHJkLRfHR4haBDtuunkkGUoFsaJyianAduubkNErKnqXZVbU+fdbjFlY/NRoh5Nytl8gbXzdma0WcxWFMQ/pBZ88HELladf7Y22h2rZfyZb9BnOmn06zWHRMZ3x0biSpHsLWkiMcsoA6RBa+Xhd/pgh4GHvmg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm: commit message claim about swap type in dmesg contradicts
  xswap_create()
--

commit 46956dad40c329833b6eaa3cc452fe974e0d5929
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: use a stable id for xswap devices

This commit assigns a monotonic 64-bit xswap_id to each xswap device for
use in /proc/swaps, debugfs, and xswap_destroy() instead of the reusable
swap type.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 35c8aac1e25d2..44b54118d10a5 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -4316,8 +4328,8 @@ static int xswap_create(int prio)
>  	si->list.prio =3D -si->prio;
>  	si->avail_list.prio =3D -si->prio;
>  	enable_swap_info(si);
> -	pr_info("xswap: adding extendable swap type %d (prio %d, %lu pages)\n",
> -		si->type, prio, si->pages);
> +	pr_info("xswap: adding extendable swap device xswap%llu (prio %d, %lu p=
ages)\n",
> +		(unsigned long long)si->xswap_id, prio, si->pages);
>  	mutex_unlock(&swapon_mutex);
>  	atomic_inc(&proc_poll_event);
>  	wake_up_interruptible(&proc_poll_wait);

[Severity: Low]
Is the commit message statement that "The swap type is still used inside
the kernel and in dmesg" accurate?  Here xswap_create() switches the dmesg
output from si->type to si->xswap_id.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109055455.5369=
25-1-baoquan.he@linux.dev?part=3D9

