Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E09A4CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 12:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7536B0098; Sat, 23 May 2026 08:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350C46B0099; Sat, 23 May 2026 08:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FAD6B009B; Sat, 23 May 2026 08:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D89B6B0098
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:11:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E259C2EC1
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:12 +0000 (UTC)
X-FDA: 84798569184.14.E9D4EA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03968C000D
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NNZozP+z;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779538271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZW7uwVrIQv9a3aYpk6kWydCgqe15Gkam/FaIQZo3eZ4=;
	b=YqmxQ/GegS65p8sN967np9l0k6JcbwatAtxcFhK+PnFJ7ZYfpCF02dX4sgdD5Pub4oCl8h
	q7cQWFnunbrJM2R+pwBfp40Kl5XqZl6CNRCXhL3cdhs2hyQfQKREZaDr4dXSsCKADeBRPo
	Rr+8K3Qr0WbVqWYXnkgZcDFOcQR+Aak=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NNZozP+z;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779538271; a=rsa-sha256;
	cv=none;
	b=TfAgUWMJP2TJBNpIrc8UhgeUH3irx/8T+abh6EzehPVlu71kYdFQnuxjoz48oMJOBIbY5t
	viauyFtV1g+sBFDvHY+Ta34PFietCaurM0AXOzwSjTb68loHOytjKHpyEmjVPDSJqnkl4w
	aafMZvxPKymJXBZox7UreaKsaJ5hF6A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7831560210;
	Sat, 23 May 2026 12:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C202F1F000E9;
	Sat, 23 May 2026 12:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779538270;
	bh=ZW7uwVrIQv9a3aYpk6kWydCgqe15Gkam/FaIQZo3eZ4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=NNZozP+zmna4U/70Rd0gTULq7u3DJWRMRYTsC/ecENmKYCV2uo83MqQYNg0/WOBmd
	 A7KMRbz2jr/5fxvo6thhm63RU3RAtyit9snGc/mpMqHwbyyib45OEuScEthTYahiaO
	 W5yDTCpa4g4ismsA/yXklMOKGOUoQ7X2xcenvTTSLm1GW6Bh0AQDksap2J+4FGTpuy
	 JT9Joa9S6a9azdbkh0cSm4x1H/T6Qbt/Ffw92Vi2MQIOQk4W0nS2cdhubw5h8Kb5XB
	 /53vT+Adys6T0I6H4ducJT5Dj7m+tCmdMC3GNjcwxkUF2M0hvLbpGzeINtfe6wlsfM
	 /D7WIS26sqQzg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 3/7] mm: add a template-based fast path for
 zone-device page init
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: apopple@nvidia.com, akpm@linux-foundation.org, arnd@arndb.de, 
 bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, 
 mingo@redhat.com, rppt@kernel.org, tglx@kernel.org, kees@kernel.org, 
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org, linux-hardening@vger.kernel.org
In-Reply-To: <20260521040124.10608-4-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
 <20260521040124.10608-4-lizhe.67@bytedance.com>
Date: Sat, 23 May 2026 15:10:52 +0300
Message-Id: <177953825218.3959652.8194606082469375738.b4-review@b4>
X-Mailer: b4 0.15.2
X-Stat-Signature: 5o51mhy4g3z6fecwq17j4zqi8ouih7zu
X-Rspamd-Queue-Id: 03968C000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779538270-579574
X-HE-Meta: U2FsdGVkX196rME8xYeEd1qdRDJryAlv53b58xeCqfXhxbFrFClU/+oiXkf41vGgcroMk2rFGwreZ0rpRUAgvDr1K/jjDglEq+J3Cn9A6T8Hz9fWm7oWh1aQru2+swOHJXuaNhCXE1nwYEhODMsMVTKT+juZZGnYP8eOSVhdCEwMXNShh+kmqfwO5S1VU1/121uB3sJ68TNMq1ulXM+WZG4v8HQ2Hs85kUahvSLgfTwnOgpJmYnJAYNrpYm444juGxUbAT8QQoomqivpF8+yCuhahC5RIbxA7NpMI/IurS/w5A9axKs6In67m2UEBRPnEsCNd3tBzEkgIizSXxjlLPKJLQtLL1Bqcx6rEfqYH/xT+tIvOxsQSY1459T333Md8cTqLu1eAmGvNvUnB+F8pONWTWNpOSgQTn5AWIvV9K588vL+WtAUHin4v89KPKjaIqjbIzJvXDXFmCxFGEM583WeJcGfmz2JolGZzgJO0JbibwZyZX5zAJdxlAb9W2ul3saOztj33dGFzlsJ/fd0lIFRsNv44CXkIDMUrn8G28soRgNAVnyAmTOZtozb6Ebi6kyK0kfchcMPzN3nmbd4Guo4RET9Q94H1+i0xSxGUxkuX0YGtnPs+SLTXoC0+iKuO5EJ6q5pqqpbokHuPw8DpEn+y/QaIiO7O1rIJjEaRQFPNYDDSmFB3krbgfwXnU7GiuP/yYH5ggWqDAlnThNwItfal4y3p3TkCHzG73BDGHOBG2ROV8jNyySk5tcjKcapp9e2IO2zFuoWn6/veCMJBYhUHDCpBaObSKAQS24uGq6tcirJp8il5lQgda30g7az3z5UzN9zPREpPxbGX2tgByKMShdnJMoc27RVtHEDNJ8jkQ9v+7NJxmSGiw0drUhzp+Itvyma/lNy1mzCo20WqDMl5RfjNxIxov4rlAy6q3b4gBM/uEG6qb/KVkIthd4THVtDOASdy0VOjM38KUL
 yrNRBFkL
 Ed+4j8fe2HiJz1G6RRJTcLoTKvFZN072GWo5gWwS5sLwlNlDbeSpnWaF2kbAkOGmanWfmLxYe6yxVO3b/Famu3bK/CxnCNdmZbJRTwFNlHl5VOIIjI8NnkRx2GGyJXQlEmkDdqD8FDtgKJ7PJuCyIzRMkOevmjMdEAbvC2PKGTaDH+Iu3AJRkJrXdM88/qzbDn2YmKV2/QjEptMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 12:01:20 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 4ba506df93bc..2992711351a0 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1066,6 +1066,63 @@ static void __ref zone_device_page_init_slow(struct page *page,
> [ ... skip 33 lines ... ]
> + * The copied template already provides the PFN-invariant portion of a
> + * ZONE_DEVICE struct page. Fix up the fields that still depend on @pfn
> + * after the copy, namely the section bits and page->virtual when present.
> + */
> +static inline void zone_device_page_init_finish(struct page *page,
> +							unsigned long pfn)

Please align the indentation for the second parameters line like int
zone_device_template_page_init() or use two tabs for indentation
everywhere.

With that fixed:

-- 
Sincerely yours,
Mike.


