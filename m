Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E5DC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 17:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C356B007B; Sat, 18 Jul 2026 13:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CB16B0088; Sat, 18 Jul 2026 13:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84EA6B008A; Sat, 18 Jul 2026 13:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BABD66B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:49:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E580120426
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 17:49:33 +0000 (UTC)
X-FDA: 85002634626.15.2BB2FC4
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5CA19C000D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 17:49:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jAbsRuyO;
	spf=pass (imf10.hostedemail.com: domain of shermanpauldylan@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=shermanpauldylan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784396971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcwkJLIQsf0/CI87Bxbyrtcx4ZYXnGqIjF8LqDWHRQw=;
	b=3VuUgDbpL7Z9t6JCqQIKq44FJtph/IxmYUvExLvR6m7RB/2ECnSpMFldNab9oBl7wVzsuZ
	/zj/klxYG7Uxcv6kbLofSoFFsdYSStRgmlDCu4uksK/Y6YHpt+XrkBhUgSTAoF6BWR4y36
	c2McIPhR0zS52Vg0SIBEAXNr4SSliHs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784396971;
	b=pa+ZvRkAaB2Lygb0wAehVmnsx1FjVp2qzHe6UsLDtta5L/AoIKIV8qpOgyj/Wb8guHs1B2
	zW3+qfBUQ8rojiygdniOMyzf2LisiRLlMbH+NzlUF6sUtxFY2CI9MZ7Ft2pNPwNgUTneIP
	z84d9mfy1fCcFAxDM0EweNAQlIuM81U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jAbsRuyO;
	spf=pass (imf10.hostedemail.com: domain of shermanpauldylan@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=shermanpauldylan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81ee41aaec1so32137357b3.3
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784396970; x=1785001770; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qcwkJLIQsf0/CI87Bxbyrtcx4ZYXnGqIjF8LqDWHRQw=;
        b=jAbsRuyOYiifqh3QXMyhu6ME8IwqYzNLeo5ckb5keOrAGOh+53MHbs039pKlo9Xifv
         FEbKPhhHDyfy6dWV3OMetXGXS124TXw1Ve0jDmmImDPlu5KLkEogxv3ObsW1JPjrSbnq
         CVQMq35YF18ZCEXfwqbgRjUJzwYvlcrKehRJO9g7eXK9qY4kK+a2kgX5ed9Vx95Y10xU
         NRU08m1KDSz3BJwpY+6k8ffjXkGHYI+x0N13nXG4bJ0ktEHkjJdTkiF4mOI3zZDeNCOo
         AFtBIadlqQcAxyT/D6NHzqYHNDQzgRj3Aqj5NQGcakihVb2OCeZNO3At0gR8KkPsunx4
         RXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784396970; x=1785001770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qcwkJLIQsf0/CI87Bxbyrtcx4ZYXnGqIjF8LqDWHRQw=;
        b=hc0ghh1qsXONAVpftpaxssdkxtqxTDjY+7pd02uJkfx4faKRfFkLVAUbouElvBehoK
         GuZDp8TWc8CUeqmSNCNpmNdtMcbG89I1Ws4rHmkxJP02JXN7NPS+cRwo+QzD435MLzdV
         6Y2COc6TXHW6WdRqGAvOeYgSHIumyUakzyHmzMPDJzL0N9ilkZPBoq8MR3so7y1zPdtb
         YZd2wu9ID2ewHRO3I1u3qkQRF93mb6XixDKmFIraIpq/AInuvoBKxOObyXeKjMETetlG
         owplMJPOql45jO/syiPp7NE3pWCv9D5HrXRRcrK7qVx3IdvEJ7k1QyohDYrQOQIwz23R
         /H9g==
X-Gm-Message-State: AOJu0Yy49WOQ4ZpzLcyTzdMfSLG8I9Hj11RocL9lYdPRsHdE8qbW33zR
	4MzsRE8ULBiQewWS6yipwkdjHS6Un3iSNkYwIokxb8gmoRWHwJ1Zvmlp
X-Gm-Gg: AfdE7ck0sdD/6zYNVBrLC1VnL+funbdvvLeboeulnDhYEw4Mk6A4Ri2dGPLfMDwgsry
	OVZmROcucRYc4/4ZwslCf9FnvMTYdyFdWxV28c7MgDOmUW2zMzdNjggkWoTUapZ7DmmfrDQeWV7
	oK1njO43gKGk48b5urAR0OJVNqSe6fMjhlCPmxfdRb3dgEKM5Z9BHRyjS2Xq8ou0ys/Ysc9OT/P
	sOq81UY0635pNGT77GJVm6HmQGZKj20uaZBjXjYelBaFwsXfQYvPs9PJ7qJdj2rizsdaPI46WpP
	zhae8YgpOu5MGbsa9QDFnd5UkzWgtXV5PBM0kzrLo8KlVNuVKtIE5bDZqijuzxDwyBtYS7Ur8sX
	DJ7G46vEpqRFqLz5ydMa38lHYn+/ILmAd+gkCIebPb/kue4uuSnX3tnJfHNRShPOzFyXUTGBpIG
	4tNq6uVSrI3W/4XfyU6q8Geo4nxQDbTLedSfMGNX1IwRYbI4rT4mpmJok=
X-Received: by 2002:a05:690c:b98:b0:814:651e:a553 with SMTP id 00721157ae682-81ef25b8234mr24658197b3.28.1784396970407;
        Sat, 18 Jul 2026 10:49:30 -0700 (PDT)
Received: from localhost.localdomain ([107.198.84.185])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef405c91bsm33564397b3.21.2026.07.18.10.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 10:49:29 -0700 (PDT)
From: Paul Sherman <shermanpauldylan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	tj@kernel.org,
	vbabka@suse.cz,
	dennis@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/percpu: allow embed allocator when total size fits in vmalloc
Date: Sat, 18 Jul 2026 10:49:27 -0700
Message-ID: <20260718174927.5387-1-shermanpauldylan@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260717172347.18b3c01b7553da75f6344c65@linux-foundation.org>
References: <20260717172347.18b3c01b7553da75f6344c65@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CA19C000D
X-Stat-Signature: xq97jngyazb36awcibb8i9y7m7fbzui7
X-HE-Tag: 1784396971-199912
X-HE-Meta: U2FsdGVkX1++Azr70MlTof9fARL93FuhsYJq+hCDyAsvU1nydaC4wiuPC8ymtfg8uNthdVN7zFGPsJtypSsLEKr3eozwRLwM0J3WKfl5IOBBJrya27stjgteATmTQb1p8Zz3phkUVXx8kE+3AwFT02q3YKLD0YMgq0/OGN9o/+tRALH5naIOwsXcty/IQkFaF13IdX/rzQQcfavtzJCX7B1k9SThuUkWoXw38ZOmRSfuhznLAmXNJZik9yAAF1aOyLsNlRzUI8fTTVP3o6zRnO1oqX5s4m8XnJwF3W5mbP1XZNHIAprxfpQljR0jsYK5icJgtpqSbaolJClBE2a3b8DMhT7vDhbYB2Jm42KGRaMAjZwPo8DFd2H/dpi5ZPNEgrGwz6CVn5Rsh/y5D+C5GmJZb65yvJSWDdz9P2+v4hqhUj6Gdb4Dg2Yw7tRG939IjmU6aXjNkf8wMStYzXsilWroMFDRh8cu/ydS6JkFY7d2nExLW3yrLlf8yfHYtPyd8DmWQxMl0UJIrGkrqkbxNl5pf1d/2Fjgim7AIobO8QTjZO97kPsruDXL2xl9RH1QVEU7JykpFWPppLlP8HDBKzsk4t3JMpDAR0yPDQ9NfYSdYT5y2ORXIG9TfiadOctle+wsW62y8KgpaYw2J4T4xgUOCCaIK+Z604XK/Q9+JJGH4TVxQ51ZrMzgxVBnB0LvvFdlD/9HjBO/ngk+lkms1OGJSW6ZEWTaS0L2l2e09S2iU2JpPK4RLyFUfJwUsTwoIcX8Dpvm7hcHhZjI4OLGBGUEXwhqw0VkOqsSVAY3keg0/Nwh/McF8aYtynLmt+1f4iqdZmKdLEtlWvlvCKOxvBpp3i+kFThDaShv2+lO1JVOhgy5VzFpU/n3s/KDJfVjpdpnsRO2Q426rZ3yMHKuiFlJuqhIONlwMKIjuNlNwBhykvM4ngZy+OwTdIlTWj8Ncgo4/e5M7kzgYO59UK4
 w/eEyuq6
 iVQE8oAQYPDXR/MWCE6ASTwWWerd09XBgIxHcdeObO7KdNqvD3bvo0RP+KybY8MkyYh0KlGNaU11dI1R81oHBY1ZotKGVz9DkHbEJar/s+g2cgUhgga8YcA3QI7TLEQNUR9a8mon08Fv7DDvJvaEArVmA6WTWLxAZOO+4b9La64uwLs2aLnJb3iSyveJfxJ9xUH7GP0S89iXMhHtHUopWJbVYRwfm1abG81FExO6azlzjFMcan4xvewiiD+4ZJlWXSmcgcUjP1b7ZUPB69WAaLHec3596VemZU+yr3KR5wt10TtA5NcqrSdyBEGJiFJkPayu95vldRDhN9afhcZ7AfKNeqH1lMH6CTN+aq5ui2IRFTRc6kY/C03z18W43LmlGHDxrBMIv2H8kSA3jfS9zaaQ1JViVQr77puBZDHTHHI/daIU/SgGyadm9UyaFTHrKL8mHmmR6811paCE12bhJ3Y06ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew,

Thank you. v2 will incorporate your formatting suggestions.

The Sashiko concern is valid and matches a WARN_ON() we observed in our
boot logs during dynamic percpu chunk allocation. It appears related to
the sparse physical group offsets reused after embed initialization, and
I'll address it in v2.

Thanks,
Paul Sherman

On Fri, 17 Jul 2026, Andrew Morton wrote:
> I suggest all the above be moved above the "---" separator.  It's
> useful info for the permanent record.  (And replace "[Link]" with "[1]"
> in the usual fashion).
>
> AI review asked a question:
>         https://sashiko.dev/#/patchset/20260717231616.9126-1-shermanpauldylan@gmail.com

