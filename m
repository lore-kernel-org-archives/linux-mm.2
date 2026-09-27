Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E2AC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 17:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8163F6B0088; Sun, 27 Sep 2026 13:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C62E6B008A; Sun, 27 Sep 2026 13:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D4C6B008C; Sun, 27 Sep 2026 13:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2206B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 13:01:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACFE340A4F
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:01:22 +0000 (UTC)
X-FDA: 85260158004.12.CFEE79E
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf27.hostedemail.com (Postfix) with ESMTP id BED9E4000A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:01:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b28Fr5OX;
	spf=pass (imf27.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790528480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJaaaQOm8Jhgz0ikWsGNVhGjwuLfM0aODvUhmzSvNY4=;
	b=nxgXlFMPcrhu3pMhWSXoMLfmlcTa/Ahov63zixmqklbPSC4WAyYqRWNipsSbi20bZpcgVX
	vhMFvtBmv+necckESXTiN/T/hmj1GQY37ipHYI3aWekWgWWb/zewtNIFnNazTWfWj9GIpc
	Ngt6d5m8qKfondbG+R+m3KgR2ydrTeA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790528480;
	b=UaUf8QQbhv0dhAZjVd9qoi5mbAjz6VA3ZKraER9FlmIEnHGlD85nJl+D4azXAA2Uem0hgQ
	NAxR1bnB8oqu/dK1ZMYGns88ZbQ3jQ92KgzrdNPXwcwVg5fACIOnk+K140OB32sxRD+7Sq
	gbpI1xPyiVa/zauk9Xf6HrodYsf6Hrs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b28Fr5OX;
	spf=pass (imf27.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48449f62b93so766748f8f.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790528479; x=1791133279; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bJaaaQOm8Jhgz0ikWsGNVhGjwuLfM0aODvUhmzSvNY4=;
        b=b28Fr5OX3fIYf9JA3Jzt1hT75t02EQS0o1lwf/EHK5E6dGnG3clRGtbBYWmyXvp8t/
         z/OOKkn+qKBcaV5YNR31Q0iN06tpCcoxOPrcJqrj2vo/gAOTF05pImSs+I+PUS/YGAT5
         djcoGBoZuzwE5/hnMh4DxJ2GAe/nz24FkJNvZdY/KXPtKk2VDlKoZVG5NKNxOAqRwPas
         l6uQ7DczXY43SRXSh7fJ3bIJJwMEQht6UOALdzpdeJrrSqKoevIamYwG3xBMiZkOkiCT
         zgEHPXQjALt9KH9cWxAV4Am4Olk6i2Mh6S/KmXwY1V8oKZrBd038g8kxh/CgrveykuD2
         iWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790528479; x=1791133279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bJaaaQOm8Jhgz0ikWsGNVhGjwuLfM0aODvUhmzSvNY4=;
        b=BmHcpVmMaPu7q9YgtWngIs35bKPJkZI42reuCQTWvR3S8ivDrmj5gEwRxLysGd3SNA
         k4kZJfw4iBP2/8tpr99drT9fR9CrUkqaDOevrUv+UZ2k7Pguimi+IqBt+rl/uqUExB/T
         1EMW3Yd6XqJG98R36rLiw0tKIjxHofm7Q4+0LdY8eaGu65nEX23DKe7RpwlLgfKDeLEI
         jT/lhmLLkpHCIwaqHryRP9p26uho57LSWNczst1V7r/MFzNCvBodzSeCaPby26XymxUp
         G8KkT93Y7ZuvamzxY2/UbGYnaB4K6FBGSEf4MdLOC2Im3FMizGdLDIAjtNqj21W/OAAB
         cxPQ==
X-Forwarded-Encrypted: i=1; AKwUvBwKsp13BogNS6LfKU7wR69Ijmhp7fRFISg3uEGU5+93DAmuCXDOGCEUpV0mcKK+2Gq/c5FARVyUlQ==@kvack.org
X-Gm-Message-State: AFq9FYL0mLXaHigkLBJDhfni3fF7PNZ5n4hwtQIcu9iYWUAzm+r11wPA
	wFkqjh7+0DCZOi+3AYcv0rlxb/O4Cjm4BLF3BxvYrcsKFIbVe46ErGhJ
X-Gm-Gg: AYBFou1oCJn1SEDSywiZxogvLpfM7abchQGFHmZwkzV8QTaj94DD9UYiBK1vd7PEdRW
	VkvBG8L02e0t8m3jR8H6iDaOPGWAXwNzWxxvcKg80ocGbeRbxRaYZOzp1HE36rQt1RfzpXKYRMR
	TRcF8Id5Ll73RYmnm7ZgzydpVgFES6SXNBA7vujwJX8AtfeUervhpMJ5TU3OvDFssW/VaeBYzuc
	Hvt6FWNXwMg9+RoZaeJgkcAQr0QQ4ZLayEZW2d2jbz8up482AQv22VXRtBuX7DC18jNw8Nk6BuM
	If0T3UrjhtujG+PnWKPRFqgE7K+f5mohKFT60bm+F/vvHsCa8fc9My6RIZx5lwnE1A9HlspeqK3
	ISqlV6Vwkvlvdp2xlHX2NQDKf/rCzdMKnctKyWfFgY9gmlKyzHgXxBr7y9HZneezqv0L8iUGb7y
	kniJwql1iWOwB/higtn7fHtQl9dE3qKEDjkGQJTPwk7OwoOO7z+pl2pfbUz1BQHhca3XPbDOoBI
	ifY6dIy1xNV/0Wj6u/MFJ7ixdfogrqFZ2D3kusMjqIzfyefva4UQ1mtAKVK5YUj3SQddHn+OB+d
	+rwKysM6KUlU1J9O/ZTD8PhZ+ScDmKuBWFc1jh0fyjxuS32yLo6JR9gQCLOMw/uUZidkGo5BSrS
	28SUplqC1R58=
X-Received: by 2002:a05:6000:2892:b0:487:f31:857f with SMTP id ffacd0b85a97d-488716c7093mr22756168f8f.15.1790528478915;
        Sun, 27 Sep 2026 10:01:18 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b2e6-5301-2072-0420-f831-ed4e.310.pool.telefonica.de. [2a02:3100:b2e6:5301:2072:420:f831:ed4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a35fb05sm23651966f8f.20.2026.09.27.10.01.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 27 Sep 2026 10:01:18 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm: hugetlb: Fix out_put_pages subpool reserve calculation
Date: Sun, 27 Sep 2026 19:01:03 +0200
Message-Id: <20260927170103.2381-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260916-hugetlb-subpool-always-track-used-v3-2-38aae9b5ccdd@google.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com> <20260916-hugetlb-subpool-always-track-used-v3-2-38aae9b5ccdd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BED9E4000A
X-Stat-Signature: ck6btmubj1syinnxiqr49p8ii3sxwd1k
X-Rspam-User: 
X-HE-Tag: 1790528480-101313
X-HE-Meta: U2FsdGVkX18waZ5zl7pEoUAsxKS+krpa0B4SgMbLgmc0FkYRZcvvejmC1FqRqH/S62YWcZMWOOTVkv/NQdZnwVhAkiFN5yhbkBFm30rdCJG86FErb1czqpQTbzy/dN8chGOW5vyDj73cSwf2Ayu7Y2GlQYG0OdAI8g/jfySmsTWSFTcjxW02+np5o5qRDBQzaTPfdngSVz1RF/shgWMa5rl5IMY9+zq5uODcBLvm+DiEqcdRrjO2xZKZOk7tGhvh3GZhud1WlA028vFIrKaeQp4v+NVrYmfRNVudBW3wpDxYBsx8vuj/HUMB8gjl8kkcSCUfxobQyAvKT/xRdajHUx/u/Ph4OqaJ/PrexjfovN3Hpjw5tYpEYtEQzj7hRrLAnYx7WUUHJvXynsKkgpkgkbvNI/DL0nRGsptdaw1y84Jt/4JlPg9J8nVAg99BU2ZCZe080V+0KAGa4dcj8wJAyJEjpykLM+2+Dt0d2zp1WaOJu8RhmF9wEikCfLKYPWI16Xm01/iNzfJttuBO70rLeB6p7N8opUZTrh0w3Denhw+TxN69SIvsuNN9wQv7qhzmOg6e8v7BZT/ezwt1p6+MNYz5wUR3QWbOjHi7q9EOgPVtsroZGINKlR9nw6b1YWqDoyAy8K5XQIXTnNoTukr2JONGdHjQG1u/lzHxwFMlJmDUNfVptnIVZ/DRPeCuOytYE5LiyyyIMKNF13EAKWLCAPoEYMmhoy3F0IHo/pXFn3wYwDRj0ianh3826KQu83JfwSSPlzn9jQW9v7uKgCwrsFC743/Nt6DrZ20zIWT9Tpi52d7BEgOqhbZNq+3U9zY6gyZZk2MP8LDmvbLIiVpI5yMlfWhxtNT2YpyPE5JFncUuHjowA1GS8rO3Y0MyI2yvuVtNhZ0c+szHNxZaK8r3fGADUlKoVdpDFMo7d9QK44mj3UFImSlVqKqrPdHD/HDmxS7IFqkWFsUT5AN137o
 zDQx7iWm
 PryYNUkgGDPQ8AJc4mkRmtlwIPsdZyDfcX1WerOmzJNywND9R/7Im9/PqJLLK+Gz9Ao70HLhUsKNg4/y4LPfQShSOREHsc+4QCkndlMayMoyKin9Yz0VBPaco5UfVr2ZgPAIbhIVtBW3of3Er9u3rWYGZ12FJVHPkWMGGLtT80pT5FJs1ZH9ouyw9ekpnKUMwXwAFz/pa+eEjYbb3SwE5RSZwIgiLQM94wUvR216Z6KCn8tgEeu9IR/kk3Z0+FZn27kCEjYv4VtbX0R04xkXw2hsV95Wy5MgzMCBoVkPkd9I+YQ4S+E9yEqxISnkisgmPdMmLFwX/2QrAWppDHT4t6akKa1vNEK4Jgekmx7iHRmzFAzZWQUYoZ6vaJmCd3bANlnsoDo/IRw3K272hNbV0vhq/2ggP6o4BGQ0NGepAapeCDuU0KzBr49czyiKRpmHy4VFVxdP/hTIhOcc7CvdB1RSvncxvRNo9w6QVY30KNFZVvHnlwMCW5FBRJaRNLfWkH9YHCOLEvqlIOdMoNT+PMhViZAmYNX1C0mgfR4N5clp2QfELNgU0da4v3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 16:39:02 -0700, Ackerley Tng wrote:
> +out_put_pages:
> +	gbl_resv_put = hugepage_subpool_put_pages(spool, chg);
> +	/*
> +	 * There may be a difference between the number of
> +	 * reservations to consume and the number to restore now if
> +	 * there are multiple threads interacting with the subpool -
> +	 * restore the difference.
> +	 */
> +	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);

I was able to turn this positive adjustment into a deterministic runtime
failure.

hugetlb_acct_memory() can fail with -ENOMEM, but the subpool's local
state has already been restored and the return value is ignored.

I tested the exact patch prefixes on v7.3-rc3 in x86-64 QEMU with 2 MiB
huge pages, at both one and four vCPUs. A default-off test hook enforced
this ordering:

1. A four-page reservation consumes the two remaining minimum reservations
   of a min_size=8M mount and needs two more globally.
2. Global accounting fails because another mount has filled the global
   pool.
3. Before rollback, two existing reservations are released and a competing
   reservation consumes that newly available capacity.
4. The complete subpool put restores the local four-page minimum, but the
   required +2 global correction fails with -ENOMEM.

Both CPU counts produced the same result:

  Source state  Cleanup result  After file removal / after unmount
  ------------  --------------  ---------------------------------
  v7.3-rc3      old cleanup    4 / 0
  patch 1       old local leak  2 / 2
  patches 1-2   +2, -ENOMEM     2 / ULONG_MAX-1
  patches 1-4   +2, -ENOMEM     2 / ULONG_MAX-1

The expected values are 4 after file removal and 0 after unmount. The
ULONG_MAX-1 value is the resulting HugePages_Rsvd underflow.

So, although the unchecked positive call is an older pattern, this
controlled interleaving is balanced on the rc3 base. Patch 1 makes it
reachable on the minimum-only mount, and patch 2 changes patch 1's local
leak into globally unbacked subpool reservations.

This confirms that checking the return value only after the put would be
too late. I think the get has to remain provisional until global accounting
either commits or aborts, so rollback cannot expose capacity and then need
to reacquire it.

A LLM agent helped me with the tests.

Thanks,
Karl

