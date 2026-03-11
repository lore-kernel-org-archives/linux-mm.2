Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E931125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9312C6B00A2; Wed, 11 Mar 2026 16:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA1B6B00A3; Wed, 11 Mar 2026 16:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9E26B00A4; Wed, 11 Mar 2026 16:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4756B00A2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:12:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1209058766
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:12:53 +0000 (UTC)
X-FDA: 84534880626.18.930F975
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id E6B861C0011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:12:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QusrqI4P;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773259971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nP1NvqOc/BLsjRSt4bs81fPcPn+FsTL/JnkWtwig9r0=;
	b=r8izcGm8agKnq1w2pcDbcAJpfsQTDpX/i2jzMpHRFqeb0tA1uzfwBS1Swpib5oLR7QS9sb
	CZnbfdObcsrwFoo2jju89iPCach2MGythh1R03NHPaWbxn1O97e26ZndFgGf0R3gCT5sfz
	Zgopsx8KLjxoowBz64UoEoJFoywJYyU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773259971; a=rsa-sha256;
	cv=pass;
	b=5d9JSew5C98eNcWXl6jA8E9VigNHYhyWIiuMvxHhRXPipxcvfA+N0HAGf7gLKp70JMs9Sz
	ZgL60a/5jpgmcPitMaXxpQb6edMBUX2q9/EgGN0WYjuhS672ZTS79WCxHo0hwZuvdO9e6/
	GswCMN9riqgaytR2KlXWDiTkNrnp3+E=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QusrqI4P;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439baf33150so270073f8f.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:12:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773259969; cv=none;
        d=google.com; s=arc-20240605;
        b=crNyo3W2yWWAvvmRY5LsayscVdVPBs+lZoNm3+tTJWPZ+BbReclIATNAMT47xPAhGm
         XjaXP7PVNZGCSNjtKPhT6jwzB+CRkbzaW9Xv7EKlro6X5XQBFxhyo89SRuY/G510mrY0
         qquVtrr+LsjDB/WPGjdcbh4+Bb7YfZS9yXFl/Ou63LuqcTMIdLDxyeXVjJaBa75khBFo
         6VrSYQwLX8s07Xeru9DvrNecGIUg4D+HHPOzvmtqV6K0Du7lC5H7Zk7skTJbHQb/yGD6
         lcO/1jQqjKaCuiEHffmAdft4lam0ix+38iLZ9Lc1IUjcNG5briVlHQAzaMYtxeU6Ugwu
         gypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nP1NvqOc/BLsjRSt4bs81fPcPn+FsTL/JnkWtwig9r0=;
        fh=6E+Ri/WZir/tg/H7fJzWqAjOn+tRuKdJZprZhdjsN7M=;
        b=MHPcI9GGeJhS7hfxQ7AllO3F72lAQOZjgJxaNIdDBuY1S26cAq2IAq0nMvxn1crWI5
         arzy3x0J4m9mgc9llxhS9nJrSKfGK9viDAWlkHS/QAjbirFBZr0LOVJo9RIUDDpNdrdF
         IWJVa8g9Ajk6fuBQyRkjvveOPTte5M/TvX9iyywDsQ/1+6TaBfqOCe7V5cPUJtuvnjSG
         eOHlb7bFinNuyYx0fzQ1YzDmHvBm2bG2kw/pcVRaRR3ZvpyZBaKdV2u+i8AVKMJhALC4
         7RpxSzS05h7bFwyQcbMfhBB/C+tmOMc1hHkHfWncnSe+j89Fg/Y3edSe5WFgLt2TAo8V
         SIIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773259969; x=1773864769; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nP1NvqOc/BLsjRSt4bs81fPcPn+FsTL/JnkWtwig9r0=;
        b=QusrqI4PgpTZfcwZT8X+n3fJjFFwphuO86w+mOrjVlkeRFgf88w8aNz8bKzwn8enR7
         UosyU9kevWaOHT25tL+sdvcCimx8jEPFFsPXVwiHSpJxsMksN+7LeQbDiUqU2ulUw+I+
         NYPR8ynTBr32BGv+XV52r6FzaO+SPn89BvB/EmUDEd4GnpI96og8l8LpcbV3zteO4+iZ
         QrhkmPbz4IqHFrXXsURI3dZEWWrFGVSEOfniiYyQ/0+UOVpwXMTS5KSXuFpRXnTk5cfo
         AiyIXZHa1LitiQ/bD8fYvKG7G9G/6SIyTWyhPsqyvXuM9Rbj/REhrkL5bGiR9SqHu4KK
         rOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773259969; x=1773864769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nP1NvqOc/BLsjRSt4bs81fPcPn+FsTL/JnkWtwig9r0=;
        b=rgzDuRWlc1dsK/+bVyk1kezOFln/KNesLuOn/3LnnxJpPr/BBoOI8ABvYlfUejNxFe
         ylQhfm7Fs/0/oVrN5znURp8bABexNIohmTXnf0yUU13aFQT+fsC1otukkcFNrtbXht5j
         DwAaMvzftI8ku5qgTo2vJ6PBEN7MFnFOdZFKCUCu4lnIu1ewTCQ4ftWzSyLdmXNYYNFm
         7tODjcrQlRNCZCmSroHoUPiym9EI725gyOGCrdKlR02hOk8WAAo5EYub6lzGnQq+/ykV
         dDCBQ6e9beCKhcPs5KepsQgJV/8/UywtkhQnPm/BONjz7LeKU0zFbCgwFz9i6A6c1knn
         Curw==
X-Forwarded-Encrypted: i=1; AJvYcCUxcaZnlsR+yH3KrTlzc99PhklnT1DCypJkV7osWM+i5q9O5C5otoOFGU2yCUT3bMJj4ivmZ4k4vw==@kvack.org
X-Gm-Message-State: AOJu0YwfKjtj+EW0Yw+FngZjJa0SZLqzgbBZCLPCqsBkIl9K7t94SYaP
	ifjEf7/kM5PPbFy8wZnAr6LixDQjiINieW24hi5zzz/wpdF4rLry+IQQ23nqi1d1F0UgvVL3z8X
	pyfNlBCQifMAIFi/TxACYMMw1vNeBtao=
X-Gm-Gg: ATEYQzwK3n0zfwyXmulT4k+BMr+P59voR2SQs0h7q/IJpvyyx1G7q3FH4K0lGj45omZ
	JTl+GMcFSOvLqqCAPSw+zQgcsJYqtJdQ5NiWepP2fPQXASnrHsYfntK766ekgiQdqy9lgxsdTAj
	dy6ycAQD/SZUsOXaxWSKFWPRKX28gX2/sfLwESHRwpQCEoIf/4ujl7diuqCfda9SkzNCYjGfkmn
	NfGRL76ZCw87A+FqQ239VSJfCQ+ia3QyE8Yyx+jzjQ6CpKdGFAt75tVfhgmc1DrrH+rtQtB/Qag
	KwEAiVvmWxlPPFglm2UAiaHH+boI26xhFF6XMX0=
X-Received: by 2002:a05:6000:200d:b0:436:3761:583b with SMTP id
 ffacd0b85a97d-439fe1ae114mr1772929f8f.27.1773259969202; Wed, 11 Mar 2026
 13:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com> <20260311195153.4013476-4-joshua.hahnjy@gmail.com>
In-Reply-To: <20260311195153.4013476-4-joshua.hahnjy@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 11 Mar 2026 13:12:37 -0700
X-Gm-Features: AaiRm50vmWrxfv-dA9KM1wtlJ0teEFH6Vv3NdFfrMyDjG2cjIu8lXoUvFKbqS94
Message-ID: <CAKEwX=MJwk0_zqtfkfgUcyBytedYNzSWP=tSA7JotApenSA4Dw@mail.gmail.com>
Subject: Re: [PATCH 03/11] mm/zsmalloc: Introduce conditional memcg awareness
 to zs_pool
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4zcf6k5inbnu7pc4t5k76bip5my5fu5d
X-Rspamd-Queue-Id: E6B861C0011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773259970-154538
X-HE-Meta: U2FsdGVkX1+sIBYco7dcJcuJGSxgULvECstfHc32iNMOhJqaaOJVtaX86kPM2UjdgD7fGIJxbSC9++wvCHCO/LKTie1mda9pVBBykc+c3TZJoxpbezOXXkK1mjte2dNV08Vcntg+1GPRVD5rABd5Zj7Y0rVIAMtVADiPFhea1igeq2s8ngmVHkmfNfyvHas17ez9WObPUDad07hQbvMc/X2Zgh/76MNPHlpBhZN79Vn/SdZxkriBmtRTDZYiNybqSWNT8OhHABl0DDDKkdRR9/hKcfi7idfmPKFZEMNHuloIzSd7e1FzkYwleozXB749tC+tqpvhAGjmSvStUh2Gd0dDCFqSSZtRAaWTWyu9zDO1YzJu6vfBb6SFHBOBMuO9JbDEc4Kyqk+x1W8xiGRs76pu+8J1iENNN64zaBPIgMEopR8HcDQRbxLypwhiVCNQKfU9JHmOjrsP9M5dPyc6slpfmALrs4RxqRBSPDLxLoPnzouiXH7YitkJvulCl2P8UyrrUhf/Fl1kIrnk6+eYaOCIOuOp4lekub8mYbL2hFdzqR6UnlxMfTGZQmH+wWvCt73ILGqbiIpDH8OoomueCc9sNJp77G7M+n7M5XxYLha2OfGHbp2D7LCP6BFWxkFz28h7cHQ1ZsnPb5lUb2SGJlzpLOFK+cbqj61t3DgA9fUog6Oe6WygbqLP73SsR1R0b9qZg3tJRSCCYwAbDKde/KYpqZ1IC/gjUVicG0prQeICMqbmJNkuxQSzTzvw8MVv2k440Tiu+QM5e43CNxQlXnv5gNbRfq9LOOw3rfsVqiTrwEYPY0IH1hTDp0ldU6VNt9NYJ8tHGakE9ACvpBsnUBSu29ZZLhnFVwt1Qd+wpGe4H9qb8LRhcYkYE4t2bCxCVdStTtAz16MwnD7vLO3n26un+spWafMgdJV+BOUaxnTOW/Xa5a43eny6CSrTWvAhDLz1sOyg40wN+TrCfAG
 9oY/jLE+
 E0YE51Jx9ZaugUJw365XDecSn6l0sb72oSWW/DAgl4yljE7giFQZhCRmHuGBFR391srtDhuuLy8I2WET76RhS4vjcF83k/Q+UNJFmh0xp+Ikx8vS83PW4AxC7BUdVLoEdo1m38OxL1580u2KGJWw6itzvR6FSArkn3FhBu3z6DjgXdkK+zpQzJAoARVnCbV0G0BCIjlmmVMa3xpO5zwK379jqW1257VO4e1SIYDUaclDpSpNLVRzidz6dCIW1rA46zaBDNXzRJJvk31enwnqxFjbrkfweIGbWeuuR873BzBPbfexw/IblOukVGbqTFI1jdkxnVHORmbDN/Vv2Rd/ngazXJUoLoOppXeXgMqTlnX39hu3sZvZrCYm3hUZgN17NxP0oSdxylTXq48kmKehPici83D032CHUxD3DooJu9g1x1Ds8eU9zFAzgtvloACWS8MwEHzk43esa9NjCZkZf+udXi0Pvh1GhGuHu+wCGylNO1rtdnK71API6Zh6l2AZV8gQHF35zlBwC0djt2LC5o9RG7DEm22/nFcZvzrc7EsYdwVtDSioAZkKw4TOFNbdNsKq1gLIYNhIBE0u0w7Htn+v1ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:51=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> Introduce 3 new fields to struct zs_pool to allow individual zpools to
> be "memcg-aware": memcg_aware, compressed_stat, and uncompressed_stat.
>
> memcg_aware is used in later patches to determine whether memory
> should be allocated to keep track of per-compresed object objgs.
> compressed_stat and uncompressed_stat are enum indices that point into
> memcg (node) stats that zsmalloc will account towards.
>
> In reality, these fields help distinguish between the two users of
> zsmalloc, zswap and zram. The enum indices compressed_stat and
> uncompressed_stat are parametrized to minimize zswap-specific hardcoding
> in zsmalloc.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Zswap side LGTM :) And for that:

Acked-by: Nhat Pham <nphamcs@gmail.com>

