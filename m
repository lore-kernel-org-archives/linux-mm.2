Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8F3C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F2D6B0088; Mon, 12 Jan 2026 09:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2D16B0089; Mon, 12 Jan 2026 09:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF7F6B008A; Mon, 12 Jan 2026 09:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D26E6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:53:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F71C58D79
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:53:25 +0000 (UTC)
X-FDA: 84323605170.30.8D1424A
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9258AC000F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:53:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S7ao79aT;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768229603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBTkFNmBBkEQ6ceIfuMijXTnivvV3fEgY8bCnCyu/gw=;
	b=N0CClp6Mlqqg2/wTRWC4Oeiq2w8n35bix4yz95xhH8bKTlniqxVfRQVBrvOnU1R0pLgp7D
	sgfsJQS1bqqDIv9ig3s7XfFnf7/6UETpEsQrn9Iq9Wo36uO+SSFc9V8uifOfSdIouR4Bqq
	OZJdRfVFTNvVycjQo79y43RA3g0ACGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768229603; a=rsa-sha256;
	cv=none;
	b=wzywYvRBoU9X/M2phNtUWg/6epGJjnuoN/w6R3vYqceq2Ynio35dB3fJ/z4PymUN9V9b/7
	hB+/2jumzN6Uvv4bGlHJNVQj0IOYAaHMuEyfnd66E8oZ29SUqFKbOQQwWJwt3fcR6ED9jB
	a4BV45nM+FhNTciQ7MTvAD6tb1DSxDs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S7ao79aT;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6468f0d5b1cso5744515d50.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768229602; x=1768834402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GBTkFNmBBkEQ6ceIfuMijXTnivvV3fEgY8bCnCyu/gw=;
        b=S7ao79aTL8T9Ki/z/dkRYGyXXLIai9ldr+c8buV8pyLhs5CfCb9Gz9s/ungJi21DLB
         sQwf02qITpj0cLr/RrJYWGItYqlSNI/WTFZMVc7EFh624nY4N5FTlyi+fofZJ1WmKCly
         ZSnCOOsmP+yzFnTBHCX3QrUUVAFts5N5zvSiR6K2/ZLbbaFlcca4r8ByDrypLPLFOQ4d
         IrtKJoUhxr0uRZ3X3+2js6WEiBMK+a1mbBw4nl7BzCBwFae1FnrA7eaba4FNMy4GMNPY
         YiRUhYnhPZTk9hZ6kFYLthMhAPjq6vlwmfpQjWA1IUb3QUq4Wyn+dJVVC6RimXA7U91f
         4Hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229602; x=1768834402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GBTkFNmBBkEQ6ceIfuMijXTnivvV3fEgY8bCnCyu/gw=;
        b=GOLysatbIz5tVg7ks3qeqDEMZ3MzJn9INEAaTlF9e8H7xdSZtJfqVuORPi7Yto0SKt
         5C20kz1z7xkEbTr5IPWJX+HkINu7z8UGVtFnajTNnjEdu77iSdwdjb9dWxAlyTPI9aBX
         2dOqFkAGOjAaC/FphzVkxdoFPl5RM03oQJWekTxrQXY19QK2RWR1whiEWfsUEtFB0pGb
         UtCAkCk6w7KbuB2VKmkF8f2iBjuwIr+LmjJrFwjYMcWAuc3TvwNoMCXPjXgvMO5bo+nm
         hC3i0m3VHCRAyqHZmcEyJl7c98dvcnIT0DlCs1cVD5ilzF0K7pYTxGuiV8KiQ2Cx7re7
         8WwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAQmhgTQ+T/J2ZkkFepXBOKyo8CgrhrJqkSkg2VStQZcv4hIxVUmM6agJbbHcqgpiksvftuvGg4Q==@kvack.org
X-Gm-Message-State: AOJu0Yx62Qw4bhYKsEvbLTISBWqB1tIcWDge+H9ZXpGKmbQv6JsfuG+w
	dOhEX7OQZc0PuRs06MOSIK4rvfJKRBLs8aUUVaHkLiOcKRBKGcf0BvpP
X-Gm-Gg: AY/fxX6mPyS2B8lrk/ct4iqDngiR9Krx2IgierLFGeQkKfMXodxagnXS3+QgBeoDEDd
	XllDnUWGzl5/7erWPMDvkoTkg2q3R2kwZBjl3hUb436mExYY32ELpjYH/K3tYBqbGZIKZqIoJZd
	lu4P8b3C7NHXB0XSWLsMzXwIqeM0cDWyEfpXvjNdWCoNZ28F7EPF0yFvbQgqtcNldL3Z/gXYk6A
	frGzzBIWIFMYefkYY+h2pZ1H953BoXw3aOi/87Vux4C2bvURDCydgwloWJMe+jslj4wbHVmV2ZN
	0Sq7cTlxN6biSC3hl+4Jb0ilGNr44kH6kC+zED3ab8UeU/UqLfB2fEExMWw8mHr9Cqlvay8gY1B
	nYV6+n0CAfoyPlyvBdDSDCfhAtxqglkKZ56WjleqbjUDoWzeoYhFm28OIQIDSvcexnWzhDMiuW0
	ZLyEev9yBSuUXniQONNKDG
X-Google-Smtp-Source: AGHT+IEiVkX5JSBHCP0DgJ5mM3XaCn+4iei4lNICvN+Do6alENtz3Jm/zPI+xQjk/43RjBi+/xhScw==
X-Received: by 2002:a05:690e:1516:b0:645:5467:29e7 with SMTP id 956f58d0204a3-64716b74e68mr15365862d50.24.1768229602464;
        Mon, 12 Jan 2026 06:53:22 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4e::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d8b246fsm8044371d50.17.2026.01.12.06.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:53:22 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in move_to_free_list()
Date: Mon, 12 Jan 2026 06:53:19 -0800
Message-ID: <20260112145320.3748979-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260112121614.1840607-1-yajun.deng@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9258AC000F
X-Rspam-User: 
X-Stat-Signature: jyk3kec8363eygsefrtwexohbismc697
X-HE-Tag: 1768229603-798693
X-HE-Meta: U2FsdGVkX18ju9TrEdoZlZg6gA6BS2rEJVlAu41uCHDP/5KqEvk0cs7k4y4P5k6BHIQfijQ/+0gHoQVWh7NsPPp2Yl+svWcVYUQB2fx8rm6vME10gObLL7epUXgBhV450oo2rn7gdn5Su6ApjTy1sXVW7ePUr+vZkl2xENEx6gr231XsAXCsHTDjg5khemIIsddfj4PeSvRmyAKJnbZesqd9V2DQ66W+SocLQfdkafT6JphE6gIV6Hprq986Eq+oPA322thpdwY8ZRWpEqAUUp3aLVZoz1YbyNmCITPukWSK4vZSjGVvVkhkr7CZSn8wrd4tOEkcX/iYC4P7UQdy/tzM3uAdaVf64I8yudyUeZ7XvSiuBgFd/A6qfC32YDOkdtq+M7EiPw0pT8rMgouluTj/Ne/A+6RKugjXO7VDbyanZiWmnEG1s+p3c1ogxzTJmjvnOHClobJifuJqWA5ZwURZaF+NBVje2OW/4ZoUCueDDvyUgwMufh6ywEe2k/qjdvy96qDAFVtOb0wVLBWw+fQMwigd+zQLbRXQRCIvRomcLYyU76Qq4Eohuhmsb3TfFO2B/uEEYaHHGI+5E6j4dMkQdzGerOxVffrwd6YJyi3uregOvd79f34UhX7cbtmeKdLiX+Atl/lBuwJzbpUU77/Pyg0qrSWhq/aBRivL5ALHQZy0ZBrejDfj08pgFKW37LXbctthEPVM/YKIS3nrx+ftbIFILkJoOGH5M+lpG2+b6pOx/7p2WcGJfMMjxjqcSTPRH7aGnKPGWlPZhGWNyqRlOOxNyhMs8YtsWAb82uiR/m+M1rcsnR0/ff20kTZfTT4YJU/dPnFx1OPnUfaTfKH5qrktretXdeWKH6grp9NGKnvwfaKAcz3rY5r9srHqVxK+f05nj+rsA2CF3qqodCkRjzo55J3MhLZ9cDx5Hzf051su+gmUICS1HY3S3zKeli4gWIBSgb13KOuoMLV
 5D1Z71Sa
 y4mbCmXNsPRwUar4FSOav/r+BVSQdvPlFu1vMBOH0NModF21+8elpo/mpCfSPiZjScm4GIn9kfgrz4cz5xFMTna6d3DbRB4sve0AHYhK5pwCGobbA4JCeKKtIf8/aigSrDJwwg7ViV1Iqpxyf18CiHDVB3CBuIu1DaN2AxfXo7oOZKDkNcFLYz2VMFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 20:16:14 +0800 Yajun Deng <yajun.deng@linux.dev> wrote:

> In move_to_free_list(), when a page block changes its migration type,
> we need to update free page counts for both the old and new types.
> Originally, this was done by two calls to account_freepages(), which
> updates NR_FREE_PAGES and also type-specific counters. However, this
> causes NR_FREE_PAGES to be updated twice, while the net change is zero
> in most cases.
> 
> This patch adds a condition that updates the NR_FREE_PAGES only if one of
> the two types is the isolate type. This avoids NR_FREE_PAGES being
> updates twice.
> 
> The optimization avoid duplicate NR_FREE_PAGES updates in
> move_to_free_list().
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> Suggested-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Hello Yajun,

LGTM. Thank you for kindly accepting my suggestion!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

