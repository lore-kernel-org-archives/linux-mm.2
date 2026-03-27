Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F86910ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBD36B009B; Fri, 27 Mar 2026 10:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B8B6B009F; Fri, 27 Mar 2026 10:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934526B00A1; Fri, 27 Mar 2026 10:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD326B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:56:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40633161120
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:56:35 +0000 (UTC)
X-FDA: 84592144350.22.40E4070
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5DE47180009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:56:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DGZS+7Pp;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774623393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uHKUylf8tYMP1/PZy5NB6UDbuv5S6RUBHBilQ5ozM4=;
	b=O5b5cwDPLDB/Sw3VrXfpHoQ6L2mB5AWfGjIsiyPv8Lk1eTMbEQy6rugm1R0/nmUEwq47Lx
	6j7weDPdsnbJotbhEiQeQ75DhrY/vCcyGrBPgQOYoDz9osrJ6T2HkW45EqyS5hTbMIfMTP
	XATa32smH29dY1qDZ+ua4dn7VYtRxqM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DGZS+7Pp;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774623393; a=rsa-sha256;
	cv=none;
	b=WAKRFd1V6qKlxwEXlg6cw/Y7BH+X4Hff8ilJOhWBaedtwoO49/KrfPX6KGOk3uaoyqC9e/
	/QCzIxoKHwGJbBVHjMR9aKaso6rZNlRoNTuMMGiasv2P6IMsAXvVkxfLy7dIjxkdgFl9BI
	SWwTWKud4+72KBSpjDV633zHDOFMv5o=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35c16db1b53so1267748a91.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774623391; x=1775228191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1uHKUylf8tYMP1/PZy5NB6UDbuv5S6RUBHBilQ5ozM4=;
        b=DGZS+7Pp/q17ZL8G1YANh8Xw5ie3PH0xO6iU3Dt7mkxbxeoixVEx5nxBh9rA6x6fCT
         rsGKDmLtxMuSxiFZKMpQaVgiaY2LUbANerPB4jWW/Ik7HEEihIroKLq9qjg/bxPbi5e9
         ESENPbimUXEEnVpnZ8ZuVH/tbe5abEXRiNwBFL6Z3R/UCAyol/jy33oT4IuZKF8dUY6C
         uI+YKaLpsBtnY8IUYnsUk9tUHDkaq1RitWK49MIUjF7SDPoO1+gwZzw1GLP554U8E6Qk
         0pCF2RAqd/LjZ+SB7n8+fwgiZ2DUTVebXH4NPSGpTa5aaH9tsy9C2M0FymuIUDkEY/3U
         8Ccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774623391; x=1775228191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1uHKUylf8tYMP1/PZy5NB6UDbuv5S6RUBHBilQ5ozM4=;
        b=dNr/FXiR7X6XLSb2CC+/PX678OanIzB9NrXi199fdpFE6/cYWbGkhW7Z24Dbolxyyf
         jEbkYkjYprwuzn+Im19EyaiJJu0cO5REfhEuDn1tMLJAXaW7l9qFSNOeRbTDAYoHSP8P
         yjmidCBnICLu+LEk7ghk8I8sHVtbnYZI6B24PLDh4g3zqZdD6hTh8ko1V3S2iL/SWj/B
         XJWQvgTlJkCkGo91pXxYTKq/zbsPNlAO0wwUZXjhZwOPNwRhFLRziK0YnmlazJR5Zizb
         JPg2iNAXixzRxqYVL7COxA52S14vfJc4dQ2Zi0FGa9INQZ78L1T/WI54Z3Cb9XpRj5lQ
         NwgA==
X-Forwarded-Encrypted: i=1; AJvYcCVDFxQgBn0sno6iwfc2vnUq/2rWCRoTac5PEkV59s7v5m8m7FJ0UBHjdjlaUgfi8/2HlepxVqgxRw==@kvack.org
X-Gm-Message-State: AOJu0YzMAYMSjpTxgDojAyxqL2JhOZeSSQfI9BUOHIBN7HZ8ZHZPxawm
	8KIlVbIsUFPwIBMHbBaaiuXS2Os1EI1oMviB68D0Mlij1RPvtQmknVDH
X-Gm-Gg: ATEYQzzdt6baxeIl8DvHaO0flwFDjAzKlv85Xc6g1WbpDLG7HQd2y13mfZeb1qbn9X+
	RXpD+Y36H6m+9M8zrbLtLch7nyecE2C78pk7gW3GyJbFpYtfHNKv8NG2S1JxdpErwDlqnw+ZX+r
	Vn0sXirQmINhJDt05Ss51ZZPlvJPZuvcZBoDE/3QIGtRfP04eE5+bwtgKdYHWQRt7A515UUTZ/K
	wNEnPws3rxaglLmE3VRMoKheTATQ/SCkKwDHOvJAxBIKwVJLeH43EzWAPFD6jxdOvrbxAro+dEj
	dtmHh0ozfdBv/Y3V5s39DPKYkcvLAs9OG883B162pISKUy+33aV21ElGRVzpv5ZyViaooBnVory
	Tu9QJ/OYJzM+IFePsjZcGAjowWSPeYdRUsAtgEwWLE05X6ylPFHJaoxl2ZCnhumfinGkDgR0iP/
	pkAQ5rb8D1feq78IwuLbGRh4k6THScd9jvOimHqcG4msuULLvcVCw=
X-Received: by 2002:a17:90b:4a8a:b0:356:35a5:4a64 with SMTP id 98e67ed59e1d1-35c2ff1e0f2mr2817674a91.4.1774623390988;
        Fri, 27 Mar 2026 07:56:30 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22db12f7sm5156025a91.13.2026.03.27.07.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 07:56:30 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Fri, 27 Mar 2026 22:56:27 +0800
Message-ID: <20260327145627.10419-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327141450.4345-1-sj@kernel.org>
References: <20260327141450.4345-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DE47180009
X-Stat-Signature: bgupnd9yr91ze1mrkueoujj73dqk6k7k
X-Rspamd-Server: rspam06
X-HE-Tag: 1774623393-238784
X-HE-Meta: U2FsdGVkX18RscA5gxS6UxAUOr0WpeoVnd6KH4vSA3PXLjVns5Uv2dS8KLP1C7+NK7Ago/x66Pt+QIuZ9atRaALoJarstw9fDUg70Y6eBYCAQ8PcmFsSJ84KkAWqf3v0yr8fV5+Iy1Kla8czkBrTyfT64JJa6O44G8qHb5TX3Kv3FE2hEHgWWdCOZU+WrQOTvH+wsLiCmsQB4HaAUD2mzTYi7BSoGEPVtrkYsZRxT1OUS1u7SAWW4EjlBclJTapVlEUY7aK6vhQ4R0wp2wrxZ7RujMdXjxdZMAnZAyU/Z8+aG5rdiTJtEzjMeNHv3H5uSew6gDe99dKGqPKh5SzY/Yi3HxQPm7f0eBNU0CB+XaLmH+Z9ubbn+pdvh1sRB/IvQ0c3g+tFjzKBxOXUDPjGL55KQXZQWZH+j+KC0ExJHd9GNGGzdMe1HiUvvl+GOWXnEdHEtcYbuaOSyhIIr8QDIk90Hd5eLUGMeMiTFCA0c17qPZH+1CtrLWaWcKGdG5eo0JcvLQMjAZTa+aG2QNR4czARTU9jEgNwRuDXDrvB5KLDE4kJzN4NQ1UEErrEl/hXK7BX1nHwEMkVENcaZC62aow7wesb6drZuVF7Sb1vTCuJWjh0nhNTu2Jw2mbO6vsN55PgNkqr6Bmc/y5U1q0CyR4F+pxh6msOYHrTKqDT8aoR/U7Dl5NvsqvprHvXtK72fmUIAK7Rq4mQKU4ZOT3RpOz3k9w8/A6ce9ZKpmpmnQo/Qz8EEpP1LfvshHWHGPRLZcRwalWoMz1Fi+2nVsZUQ+C9DNY9xLZEyBF4bcgtWlCcZCZNxoITag5AWZQDhrzyykuTxb+hp0+G12lhmorfd5fdWzK+UNe+PWWR7+1fi2kq/Cmvks2qW1Rl51xQQJb1jccoSbzT5wK3DrhiUCh7FbXK2uUwCn8VKVIoDnhhvnZorO015FQeVbogFNAM4lwfm+Wkk8vZ8dMhfeEJvns
 9ACilCNT
 Ey5bBxufzjjJVJHlniyhuTDYBdWdrP2hjFz9L2cH9HAUSQS3KTdq3KGeP+Ao7ZACcw56+uJWDvJHkSJ4SinJWafvh6YS91GolZw3DSdtJLCMzsdc1Sz9S+ooO/WQFLxupoGuBcbFFgtokeibBzBqtBBcnS7HQQWI0aYKhwR3glr5rj5wylce3rqg4YrKSdvIYq/EQcw0gpSFEdbl/PMTAbdSD1d4k4s/fSpMgIJ2RhqLJpV622ozc5L9NjFTQu3iDvLUknZxtiNrU1IIo+akhvnz2/VnW2V6CIuThAKx+q24YTTsNT+3URtZmZXZRK21QWKxiSZQ4L/E8GmncwXnMAXFdqkKDLOEosHBPCUnxuRZzfcs/kdfG500JfQ8239VgUPChe873MWr2kWyFdO8mHl/CY9I+llRSM+nQH0OiOQtFDPEUYJevZixCMmRy4RfYG8+kNGFv5ow6YVLGYxga/ZrR6BLVGqMIynFd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Thank you for the detailed explaination and for pointing out the
'PAGE_SIZE' limitation. You are right; and I should have accounted for
that.

However, I performend further testing to address your confusion
regarding kdamond's termination. My patch didn't fix anything.

Here is my reproduction:

# Log (Both with and without this patch):

	# cd /sys/module/damon_lru_sort/parameters/
	# echo Y > enabled 
	# echo 3 > addr_unit 
	# ps aux | rg "[k]damond"
	root    71  0.0 0.0 0   0   ?   I   22:26   0:00 [kdamond.0]
	# echo Y > commit_inputs 
	bash: echo: write error: Invalid argument
	# cat kdamond_pid 
	71
	# ps aux | rg "[k]damond"
	# ... kdamond terminated

I am very sorry for the noise caused by my misunderstanding of the
sashiko review.

The real question I am facing now is:
Should kdamond terminate itself when damon_commit_ctx() fails due to
invalid user inputs?

Best regards,
Rui Yan

