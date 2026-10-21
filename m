Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F4E5606A326
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 14:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hI8C9KMt
Received: by kanga.kvack.org (Postfix)
	id AA82C6B0213; Wed, 21 Oct 2026 10:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58536B0713; Wed, 21 Oct 2026 10:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9478A6B0714; Wed, 21 Oct 2026 10:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2756B0213
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:18:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D8BA1C3D38
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:18:18 +0000 (UTC)
X-FDA: 85346838276.26.0944825
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id BF5354000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:18:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hI8C9KMt;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792592296;
	b=7iHBe+Cd/InixZYS733Ox41o+cXSKR7wnM8M+qvmIvIHanpJsDzzevLbnXc7GHfLFcrWHj
	JfiNSLNlOGBe6rcT0dfWn37IN2slB86vRH0EiIRO5ETlZOfp8kT9nJ68UiEtoUHQmX5ZQx
	GWgGsQ+7uzS4X/yxYW0oJapvFocxsXc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hI8C9KMt;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792592296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UB6olZU7ZLzTbxUpiAFh+ywDR7VP8bDfcRYcAe3Rk3o=;
	b=w1p9r9HHJ61+JVXz9H29sfu30Oh97ao1hSe+WwiIITahijuwxPc2vpaBBhC8tk291whpLW
	sY74Sny83sRHr17PvEFo1BerQDn3CvTjY3Mt86z1SUe0j8TZP4DTwKvvnicHn1I1ToT1XB
	//JzznYa5XdF/UNaA5aSfqF8FWWec8A=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1dec056ddso4946545e9.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792592295; x=1793197095; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UB6olZU7ZLzTbxUpiAFh+ywDR7VP8bDfcRYcAe3Rk3o=;
        b=hI8C9KMtl/M6dSO+YaY6s8pqOxodDCeyCnzkfIpsVL0BAO4hqY1howcOnWkwxUpgR0
         k3QGAZkW5rMxHc2Uph1ryies+qkGqfaD1kBhotO4eCSEZY6NGfBiIaiH5lzc4/142HDD
         Lw0Q0j+LWqbH3su5PiSOmbzoDKSBOLKkXHmE/fale1Dff/Ex9WclVZT0NxmQoVg1UJ5W
         DBPyMTtLgdsUInYpNj/k4D7nJRLi78ogWHb9eoG8Wasv/Z4T+/q3WGOztr++3fQpt070
         XIEvpA0jVtmyEByzOIurS184crSHCBXQNa030YIJZY8F1vDQit2BXSHhwWrVrUOacaNF
         kXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792592295; x=1793197095;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UB6olZU7ZLzTbxUpiAFh+ywDR7VP8bDfcRYcAe3Rk3o=;
        b=D3KTwo+irrUfBYiUgXUskBZ9YkuohYg+jRCQXX0igeui9NFdojLH62YLMhkq1bvzP/
         5NNh4aj/qmrTUJRSm6D7thHDN934CnvBGaSLK3igkZ/tBgn7MyrhZFhW5efpADi0k14Q
         NttsKcNQljZQzQKHNSYm0SyHfWTOrYxhA/f0Xx7h7/8x1y2ZJ+6WMlUQMcKzQQQcjwcb
         +JDfOi4zdxLLVuEXXfG7emGZBGjQGRBvRmnqo03yZAIIZIoGASL8cNV4Fqo0ymjhdkr7
         ZdtYIReN3xBiezrelMV8m0gOUlGl7lCjcjJDsk/LSZKP78DWhsar9oiiP+yheYJUBE3U
         +Q0w==
X-Forwarded-Encrypted: i=1; AKwUvBwz9cs0S16wHt8w91NAM0NQBDNGgJxA3NqAQnzXDUlHnbjgXCvG1o9fCKBthshsmYqe5lkb123mFw==@kvack.org
X-Gm-Message-State: AFq9FYK1cw167aRa80WDj2DAQHyqsEZVGlbayv7i1/4S1TB7yQ49pCEU
	4oW1cEA5RiJ6h9WpYRHCCwl6ei9z2xOlSSubFQUjSSQ4wpZyj32k0Tgn
X-Gm-Gg: AYBFou19NSm8TmqX69ZEB4zylOW9xCjgCF2dAP2s1wbEv8yUylLm07eWohf9KPVLrFW
	7YsGMX1gFkdXvznu4pO/PXD3+9D5M1NZMGFfvf66+CZ3The14LhgcXvWvZvESZLfaRClDFE68hy
	87cQvUyCZg2iPQZ5IaOoWL0u4F73vdiN9+cVzUKBxPIPLuS5sPk1dzx8AKBq2aUvryE2mTMygCt
	aBEduX5KSX1YxIOO0uiJypl7AZvP+UWVjCPqIFIhiGDnpX4zebzvpcY+obSpqAESjIEO3mKvXog
	DJm54QItkxJcaQq5D+wM+NbyFBZrqb3vjxSrqkCeoc41vqendFnOaPuhDni15rj2ZmqfRFT5VS+
	n6rFYSTupIOkDxw7IEE6BYJHWUhy5OeoNO5hMwRO5BxRMPc6mYSO5y7dCOiwQtbaaOfy8b1TxTk
	56H/FJaQ5RV0FSokMCDcK7AGgenv7P4sNDctN/+Ix3MZSf5C/voWKAix6xJIKyG8rm6rPcTcCw5
	5ae4eU2PT55ibIUBOeCC1v062VA/Slxo5GNHRWaFxEB8X+/s6xX2ZCmy0BI3D+RThAOdVJXBAi5
	Q7E8TLR41Fj1AtqpF+gX8vKQGiNhpZ0A1LpEU+U=
X-Received: by 2002:a05:600c:3b82:b0:4a0:108:3b48 with SMTP id 5b1f17b1804b1-4a1fdaf7464mr51669615e9.7.1792592295070;
        Wed, 21 Oct 2026 07:18:15 -0700 (PDT)
Received: from C422HJQPQG-Fractile ([150.251.170.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc1060f3sm48926635e9.1.2026.10.21.07.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:18:14 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:18:12 +0100
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: Enze Li <lienze@kylinos.cn>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/hugetlb: drop unused mm parameter from
 unmap_ref_private()
Message-ID: <atjJpB8d1DkMev_R@C422HJQPQG-Fractile>
References: <20261021061901.376104-1-lienze@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021061901.376104-1-lienze@kylinos.cn>
X-Stat-Signature: xodu4gyg8naeqwbc81947exgsntetueq
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF5354000B
X-Rspam-User: 
X-HE-Tag: 1792592296-54154
X-HE-Meta: U2FsdGVkX19uOXbhPnpfN0Vv7IO6Uy4fNW1hA+qUzExXGgbVhVm4/SWqOMhz7VRAGbzrTp+gmEbUS/6SOHPXfo5PZNEEiEaHlUv5oocWMszyOYhiIBpDUWxHcVLwbicz7fEwZ65lCH6jtASA3xpwJoAf54FgiboV7Yh3Et+MjZoADLtbtVyOt1z/bOXfAutdThSfPyd143otpZvvd/41No5wBGKLFJFBzZQUw96CyqK7tIxWfdxwihZZKZiTe9NS88819sesBpACs9kT/lAyoGy1vXGaYlRVTH1/aQBEyxz9K/qBG6gSf6CdNb1h8C1xjkIsdM09n7XZjORFOrE6w7KAekbzZbReqjth3WxTJA65Y8vXgYdebAwVHhHVmtW9rcsC9CLShCQG4PXJKrI82e6TymTcP7zBytno8UhDdLGI0DlbpxOVWpgRRc1vdNrpTByECRISmlgmCaW+tN2kFxP5DBCuyDsKs/MwbS35yLhazHHawbHilUefpZLRMnnZG4bx4xiiyldoOLHfUL7KhiUVD2z2e65BEJk8miWhIOrSTCC1MJ2pfARtaUniqx01+uenmhFdXq7MLtCXC1zmngfY5Ua8+DBMOeH5Q5ULls2KMKOr/dA7YK12ceOX/Ip+ZcIWr6hPmdk95V1534ov50J2QVNyPHIJOkBNP33dkpj9vIlbXHlUnMCwhz2Rdl7DuBNErpbwkAIqXDx3zYD45b3UeJBANZ+zAjm/v8Box1bUxaeCIAeyVW8CTqsLtDSXkeaKHSLm6ytcR2L5mR5FTlx10aVtydHL9L4G/NcHpW64Rg/MfvwHcGF9R5C/QRL494uUsECqXHtdSbkmA0BfPTNVdbtYO/8UEJJThNtfh4KEiuTKwur7w5UxramyOJB/xKL89PLCUoS7ravV7PWA5JIED109afPxeyIa243PkKdbP3TOmEzIFSjgkCLR6FgM4tcrF1XNoP6/pfBvwFb
 yq9+k4bi
 8gl7n8cPer01EUcJht0IWSUk8H2Yq9yPKmCCXI+WCdP7Mr0EBZx8vu3uHWGbkM2jwnFmYoSS78+TqMRL7Tb6jB0tuu3kIfLHPWlCF1DaaZlpNWeqAzZe+qvnzf9BrE58eCEZ8bMTz54ISmebm7hS/oJz97yYkzZ5w2oYvoZyZoCyxB5Lbnrb6jWgnMcNUnp8Olq5ZU4WJTkcxsLuyN313h8AXa4bFqrRgrCvC2YiANinZkMUGSgzoFyZXO4EJPc6RCYvv0ZeO8VFqyER8yhtVwQuDFsc1S6DJ2A15TmiDvEjoBUculChdZLLu1pFipCt2cDQcj9FBrJ6aLb1OE4pOglDqmJ7BQvnaaMBS53/xr17BwlQEVHA9l2D6zd8JVdQanYHPlHYhPVDGdI2wT+5Dv5ly6xqICL4XLYlkoTCp7984MRPYDzXWDD/d4MzhGid5bWq0hWCJM4vGllKR+bZGTvzbRR5hZXG1s6Glh0ZTc/C/6lOqUzaSmqbETHwhpu9dSovkln1VC6hYF7k9io51Dv+ds5mzQKD/h54fIURbM8NE/rkzzZhzeyItKRdwgltoPU4kU3kRf/alvws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 02:19:01PM +0800, Enze Li wrote:
> The mm parameter has never been used since the helper was introduced in
> commit 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that
> called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  Remove it and drop
> it at the sole call site.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Quite interesting that this has been sitting around for so long.

Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>

