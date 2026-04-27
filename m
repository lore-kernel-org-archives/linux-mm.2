Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A84FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 06:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850606B0005; Mon, 27 Apr 2026 02:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8019E6B0088; Mon, 27 Apr 2026 02:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0456B008A; Mon, 27 Apr 2026 02:45:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBE16B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 02:45:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE3431A07C4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:45:28 +0000 (UTC)
X-FDA: 84703399536.08.7848BA3
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 251CBA0003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:45:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RXwBNA7j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777272327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6692yq/cQ0USHN6DFzItmBiouuwHI1/l/PPRlXLNKmM=;
	b=CdU4UkzkEa/qCcYhu4sKbZywYd32vQNEmqgJywZgNAa7GAe1WGovAvWnKDEKoWXdShEPn/
	FNepSpU3QvkXPnaOHt8g9Y7B8WYCW2hDbMv2YMCmwPVkeLSAvlZYlXM9JIDtEsoQA7pvro
	bMUFSfVNoAf46UU60WrbCED5psEOia0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777272327; a=rsa-sha256;
	cv=none;
	b=hb/jj6fvovRFBP+wflMrlXlZ8u2pXFKxzNnTbk2zqmwgK7VvwesX9+AkFcwdjQOeS5V9vz
	ZQcGI8YPdVNGhFv7KILGOInhJciPqsDC5f2cRSlc5gAwGENJ7jJxDGY7egxkQoamVnDD/W
	AmU1ahH5eaYpZgMO00OVBStwxo0jkf4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RXwBNA7j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b45cb89f7eso61086155ad.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777272326; x=1777877126; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6692yq/cQ0USHN6DFzItmBiouuwHI1/l/PPRlXLNKmM=;
        b=RXwBNA7j6ntijavNLDeNYwDumpgBymBTxEBPEjj/2YJjnpYe6P2h3d4Y3+NIDbKUo3
         qntdUFzSkCDsSfRh1XF1jWZicQFZjIqini7Bhlfi/JLPwiyzjRIFFTqmdVCzyvLxmgJJ
         uolOQsn/Sls/hg6sSNjo93esL5kr+lNxJPKCFiff7hk1ia1m3EbIjlj6E+iUuFP+IiP7
         pcYUm5Tr/ZpVcRNFE5wloEKShCyY2eHpMEcl8THNERXUf+CCNwRLq9RnazZDywf0zfAt
         7egrq8/Ty9JaBIQWKLgQbVRAPu2CQYTjsQZhxNAMmAGXXVFIglnoFCd/qG6kTi/Pia/r
         BSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777272326; x=1777877126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6692yq/cQ0USHN6DFzItmBiouuwHI1/l/PPRlXLNKmM=;
        b=ivz7UttN65nu2ZuOW+B9/JUssbY5cf6QgtEatHzXTO0+Yvw1bpzfeDIuoAnBAWOUdF
         T4wsF0QiD+W3KVf3jUtugMG4f1r3yS/gRNr9K4bWQk64JqTIE0kSG1iV1RQExtz9u+HD
         fL9YjGBww5k294DoAdy3mNP0QJNO5a/iywDngxc94nO7/ujvgybTTQ+uoTTodt7njrIJ
         /25QQQYXTlHf1G5Ty4UtVTmz517mOmvkKIlUg1ZTomTxnW/U3qUFR0LHbEC1MrBUYZAY
         TME1d1HbD5mb0tjK9jbAuQpIX6KEuht0Po1BlnuNmvVqhIeOVbQL1ORJ/B73mAt92tKu
         nxdA==
X-Forwarded-Encrypted: i=1; AFNElJ/lptQe1OvtCXnYVdryUYX+c3ZSISkn8T06YkTOCwHUkuYCTJqI5f5cK7sQobIiQ20oWvB0wa9M5Q==@kvack.org
X-Gm-Message-State: AOJu0YwMOyJqX/hueFUtbR7bpprs4JOEov1CTCSPx9JKobmqkWun7Zf+
	O96uNNIPQL8sbdFJuw3V9FjdLA5koP88Bi47/RQ7YVxwyZtp9qY9yWFA
X-Gm-Gg: AeBDies+TuuWpj5DtkUD7ZGCgQJQvR16u0XLWC+Iw2JkxnaSdo6oSgfoAvtBeL1SNmY
	ka6FWejl27kcfCp3t9Ku6hFG5HoP6fuXoMKIi4vy9c45FE//jXvt4Pet+mj2Y87VThX13UpffAi
	6HIN98Liy95SzpTm/g5tJuP0pblTEk6Pd9yaph+WXWQGZOJiP23sTFP0OA5MW4ZZ8Qu2EBNrYOX
	9ZeZPF/EZrTuSwGGjelFNgiMHNfiOfTuydjKcM2qTzO14NlERwscjsCTFAJlCBYz6KpJozlqAGQ
	Du/fgUHroYwF4bO0viNO2B2PDCEKj3WTfJF059kz4ZMNihNkLzEzjYaawrFpfbJ8rW1j8DeusXh
	ex8uxQKh8tTin2ye96iXe9Da5YhfAB3DAzClLaaxTP+EnkXhv7mpJ9q3Xd+M7F9II6ct789ivdM
	lfbu1s3YXncKWWslXRCCzIqWm9ex/j0EdhkIOcD3w5cfVvEyMyLVu/A22W
X-Received: by 2002:a17:903:384c:b0:2b0:7e4d:f390 with SMTP id d9443c01a7336-2b5f9fb1b9cmr406146105ad.41.1777272325956;
        Sun, 26 Apr 2026 23:45:25 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.21.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa14487sm311671955ad.18.2026.04.26.23.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 23:45:25 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	nueralspacetech@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com
Subject: Re: [PATCH] mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
Date: Mon, 27 Apr 2026 12:15:17 +0530
Message-ID: <20260427064517.19784-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <5D99B763-2544-4130-9117-9E6BEFE6A2CB@nvidia.com>
References: <5D99B763-2544-4130-9117-9E6BEFE6A2CB@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 251CBA0003
X-Rspamd-Server: rspam04
X-Stat-Signature: w33h6ofutgcufp3ig5jdxg9b75uztwcw
X-HE-Tag: 1777272326-454477
X-HE-Meta: U2FsdGVkX1/TyHxAh+Dc4AbDLyfi7mIHNbXYm9gGnwAD1tKtR0Ab/4V/7ymotyQ0tEqCqKSS5xDAn1Ol8XGat1xb+5OoAIWLLOcP9e85PER3NKV3QZ/RtkUmVCHLfx3LnVfuMF6Vmb4rjWOod5Vxv3cWiLrSVD+cV3a+o2TxaIvfRF2V6ZnH3R1OXphSq1HVfzgE16nHGoXDWrIZjytGssiYForSX2+7tNH16ksAUAgbkXLVww7nqRw/sDr3ogCrQHksS46q1FQM7r/MzEyjDKUu72kCGFDHTSagFDzAn4pCZc7KFc4UamK02j+toDI75j+7OsfUqwMpem9jnqElPKtiTnRCj24aL2aVYYsZRbux58QEfzUgpnAlPoWktilP8FFe6hncEAcHqGTrKAWuP1o93lzzf4aUVSsx2mRj01aPbK7XkFFMqV8HIhAaSiRQzXnl0eLkm713KZJiHSzHj1FLVsHntBU0Be0+YB6ZFa8MxfkEXmXdQF6O5VeqWQxG97Gy+uM0SxAMlBiK5u2URS2QzAdachKIzyR3xkjbe8E+ZkfznhI4VCaiL7c4BSTPg+JUlOJmHQ7WIyVvNeDSIbRYd0/trUqLmsnGOL+R4Kl7wsk7qfNk5xGhBbo3EUAhBekJvgM7IVXGC5h4oXUjSmo6J/DFBVH39RiwD1voYuadBm9weORk5sFKSh5K3vuxr7cUXn6eVke4zedzy4qxl6kdg+RgW6xnVJD2N1qYrGtmx+ZxS7ffPuit0bKhzEpaAZCrKyG/aIyFoB6M/hAoQpPXhcEXxJU2cuYiCc1XqbEFIJp7ldE46N1CEfvRMi/XWxLxmOvgdmGHUJQ+oKPest6WlPlDjnkBpGVMp22oUWF3gqqIz8TnlNGfSXwWA3ZPNHlXVpM+4Yye5MRM4PBl+4IGZwL2XKoCJjMLSsRlSzv6KpBySWheSPzVvwKj0LH+jsOmy7lB2Vc3momDeh3
 1M5pT43O
 rRaCP4f2TiC4dYeMMhRK9tAUz5zLRmTagtHAHSjBuWc8FrxqYkxhBGrgrf4h87s9tShEmxMMf/ZCF1UdHqZaZZT+gifDR7dX7dHPhXQ6QY14CIujGmAS8ji6B/XC+Zfn/qdV+JqDE0a3bDr7pZyxMWcykoyj8TRIsoivkmUlKWC8HXNHuJX+mWy0HjXheVShytJfeCQp6yIYtency/Cu+WUi5wiKkFibeaWvRNe8eu3lgnR03zhkrmajbp5f1B10UR4DgmnSRQR24tzdVmCXSeM3YISn9BvCH431RmGSufmmMgms2TWU1r8Tc1KVl79EmyqGLF8R91h7MqfleJnxMDrUWRuIR5UbWgV2w1x41+eAWxs9k0ocnZqtcU/Xyq+gGiObvLpbq/3UZu14OH0qjkHx1Z3gtmkumwpdzkvfkL9yI7LyaNviqH83cebuNX0oEAyRyCXmm3pFy1ThUXjGoiKvobY1SpRSdqw6/eolzRutEQ+3viwHdEHj5bdZ/hqw/VkjAthe+nmZS0EWQzlVy9CJk33ZKrljIiNtLmEMb2yqNY4TPcbZo3heAHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 10:21:01 -0400, Zi Yan wrote:
> I think the "goto abort" above pmd_lock() need to do pte_free():
>
>         if (folio_is_device_private(folio)) {
>                         ...
>         } else {
>                 if (folio_is_zone_device(folio) &&
>                     !folio_is_device_coherent(folio)) {
>                         goto abort; <-- this one
>                 }
>                         ...
>         }
>
> The lock is not taken yet, so you might need to add a pte_free()
> before goto abort.

You are right. The pgtable is allocated before this check and
the lock has not been taken yet at this point, so goto
unlock_abort would be incorrect here. A pte_free() call is
needed before this goto abort.

Sent v2 with the changes.
https://lore.kernel.org/linux-mm/20260427063729.17294-1-nueralspacetech@gmail.com/

Thanks for catching this.

Regards,
Sunny Patel

