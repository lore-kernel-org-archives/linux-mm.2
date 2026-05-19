Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F175CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2DD46B0005; Tue, 19 May 2026 14:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05346B0088; Tue, 19 May 2026 14:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BBD6B008A; Tue, 19 May 2026 14:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A204D6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:47:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4693591B9F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:47:40 +0000 (UTC)
X-FDA: 84785053080.14.0553D6E
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 55120180005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:47:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KCfm37aL;
	spf=pass (imf24.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779216458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bDFKloV9wCzA7ym/ab7C+z4oYqNZXRFYLSn9rPO1gY=;
	b=ii1M3LIE4qwaQdyc9HsT+ZJn6qXCwzePZ+Ac1k1Vtbij5vkaW63NIldD5CK40SdiMqMajD
	K4xwkZDsnwtahzapfdSRd2qt6taw/3yJsHob2AF/aP2gTiF0khJjNvQ2ASFoS/X3/wfPTk
	RA1zYAnPQzttuYI9ZufyhAEyYHiy9h8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779216458; a=rsa-sha256;
	cv=none;
	b=DzgUvfu0rVOjHqWegqPI2/HL4+SEbjp890IGqzAzvobLJdePxNJj/ZTSJURI9w08D9YL0C
	HrSYMPSJecwV9JiVHS30ALamLCnHd+tDRYLOzgWDVYUinx3rHAMDlAii3lIo2UNkuxPSNu
	ykCcD9fAUnpwFklaM31wIHLNPL3UYaA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KCfm37aL;
	spf=pass (imf24.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ba3b9bcf69so1345ad.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779216457; x=1779821257; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6bDFKloV9wCzA7ym/ab7C+z4oYqNZXRFYLSn9rPO1gY=;
        b=KCfm37aLs07ROVo1Zi1S2+uVzXPDLOL6b7nxykxDUdbdTAQvlWOUAW04s/YLStqFDT
         3MtvzdEswsLklcIaHi7Y2LBc409EhfLxpBv7kBJ2iGOTUxSV+gdcQkjDqW4ulEoocnOb
         SgzG9s3qw5hAnxW4ajnpVVrAp9BufLeoSW4ay13xCyTOC4MWkW1HZYHmteModspKr0le
         WZPkjHITqQM+R/HVgTCt+l7TfuQhbsTd1b+7gADA7sUoMYme3Nns9+5UAVJIOhZjhy8r
         KOpUhC3FaEThdXKMzTXqW04tQU5zaq+RmN+IwPFjc/uimcZID7Y8Io8FyCRm4uGMFAPn
         f7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779216457; x=1779821257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6bDFKloV9wCzA7ym/ab7C+z4oYqNZXRFYLSn9rPO1gY=;
        b=dDEORJes0ZDQ5uwPTGBPu4Tfx+N8CQSpGpolcH5k9UsgRm3VglP8RPEimqw067IsgB
         I8e3hLB7i2nhy/zqGp2/8/T9yovuSJr80nFA/tm0b5+RM4kQUng3ssM/D5UB/uiTXu/x
         m7YyATtgle4K7CvUU84pwODmHRWCFw3O0PqqV35j+1cLUY+qCoEPJjwpkBHDQQnwa91b
         SdXy3VO7GbHil8LoIhsotofb0iTX+na0QtVSCBf9s+46IUqRl9bEMxdB+pa/9dFkNp8e
         fZzvDZyPkfDjCQr/8RaLz2wLxEvAJWDnXunLYO0cWsYwBCGL6zw0tA8xBSietQfSXhXu
         +u4Q==
X-Forwarded-Encrypted: i=1; AFNElJ85nH/w+W/0U76ClLAF4coYSpTBCcbzh9XbQPVLkANZkryE6123tp5ho+bJFWKrzZj3whuZOJsRmQ==@kvack.org
X-Gm-Message-State: AOJu0YzdyBc9+qQt12of4yKKUjyhbIx/sQUU2V73Z2lNhwfLHcGmQcqn
	vp/Afmnodgde5t+qa7RReR79Ayyb9Q5IXPaeYEmCRTwCuGcZqGozORLmT4J7Nx96Tg==
X-Gm-Gg: Acq92OFRyyWeBRBCyX6cvw1NmcBoMx3qj8NZorqbBB+4T1S7s3/sSOCyHR4wLHZNdm4
	v2R3M8wWUd8FnLo2TOHaB+Rgm5c2fsJir6lRBc0sDq/9EUGNKwNjccrbaijnMxl8rZ6Ym9fw60j
	vSrqKlSZDT1fyQeDModYfZz4M1wBVYQ/E3OF9Htgef+LWx9HK/L+UymZVJ8S9YguilsGEtwBFqw
	hTli9aMiYxrY3ZHonQwgyB3vg4WxJx0/n2pTygEXfbywXmSTJ5/yKQPZgJJgj+6S6Lq+4As3G9B
	HDZk0BxBKXJVR+lCSEOvGRkXxhMvFeOfQdtUJ+FQ+GwPgeeadcSBkodVdToSE8tFkzH4rgKQjBY
	00JlSrkrgBRb71mVXjLpRidJViAeq+HP+IAuq/IPrhXPpEcoJZa7wHbnvtuWGnCTlFECzWg5r9t
	2/xx6aGytS00xGcn36ctzdLMFz5HhhGXK25YwXytcZlj+fP48MB9pRof7iuIDb7tsG1ODTBA==
X-Received: by 2002:a17:903:1983:b0:2bd:6dad:3dfc with SMTP id d9443c01a7336-2bdb041156emr6226085ad.26.1779216456323;
        Tue, 19 May 2026 11:47:36 -0700 (PDT)
Received: from google.com (153.46.83.34.bc.googleusercontent.com. [34.83.46.153])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d11ce67sm198205895ad.74.2026.05.19.11.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 11:47:35 -0700 (PDT)
Date: Tue, 19 May 2026 18:47:32 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] kho: fix order calculation for kho_unpreserve_pages()
Message-ID: <agyvXfrf6aX8LE19@google.com>
References: <20260519133332.2498092-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260519133332.2498092-1-pratyush@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55120180005
X-Stat-Signature: obdm3ykpd1q1o738idm9q57338rxwu44
X-Rspam-User: 
X-HE-Tag: 1779216458-79799
X-HE-Meta: U2FsdGVkX19mzCsZZV/vJOaxAKkNK4ravlJOPRmQze2MkqNFXzpYq2n0n1nW2ibIoP2GgVkPVZaP6Us3MdzBQdRyWnyzhZV2/19LzPaHE5RI06x0IalvwFrA9kMhzSGik3UMqkHYB4iqt6WOEHuHmkJ9cUMYuttiZWmzBehWjuUAmfkvezADVhYJ4KVfTgYwjdoK2hkSlum9Ag1ZAqFQQigroYouZ68Ex0L3zfdyJ8tub1AjocT+ke7FNRimxxfC5kS/wHbz0aZUyhPtV1D5sHte4qEprpSA2b9/cNUWTKAaZIBGv4ii1CRthbXPNOWgtEfFjObvVFdvv/cnaDL1chVBmK7IiHHAlTgjq+sNw0CXeXr5owfHbCZXTa3NO1Uy1Lu94oZ0gJAy2DSnLcgQfObFhSl+yKSVAQcd9DEet5uS71eaddkQFy5h+k9AyenvsbEBfZsEIYTlVlkIKDQF1sgU2jETqTF/REuoW8jjcEGEgwXrjNoVZrea9wviQ0VTYr/H+q9sMkycll3e5874ZlIVCX/sHhhZCY9zvuYDotKC50CvlmKKudr2V98YWAacvOfGsfcinO/wjoEh5UyOa5/uB/XB61TpPGhW6Zyk24tRqgRz2+D+6UxWdSw72ye23IT6VOnnE7oQZ10m5mZBGUn2XMvCg2RXxYxl4sPS/QxtirOJv5Hj32pMoj6UEAo3nIuyuKmJGKYtML7Bg9KklPNfsewHiyddyDujcF3i6v27Ao1rGSk1onZMExZQmG+EqL4gpuKB8yXr2d9fsc4nL6YU9aIRhnziXPRm5LcYCbFTz4SxLnzKl5FBksye0JsD60InThEVXsvmb7uRV3HLNFUjbIRQHeP/Ca3ZDGmVzZl1YVsCDkBizvTEqZxt04mmWD3F/HZJp9zUP1CHHCuzkXbqgGdHBacKeGgO3o5EbMfqxwDAZJcQKxkqthdOdZnq3GWAlIYI3OlrUqjwnUj
 l2uNZNEr
 16TeH+myJEcwZcUKKc/mDH7bUkBgE/JxjMw5DnOsdMKHVKsbyxmQC8d/LtqLCX6XPmlmICIKrF2E+FUWnuYOEnTK76W2MvvfIHYQpcKtCqUlaN1iZ7cwEU4EsZodhw7OFI3DQcOlTzz5IrWoKLvPrxcnoTHd07XfO5159ldoODuFY/hmOGxpk0PiMPjjQ/rWKVRSAj9vIhsdTAqcS0yiiq0t7NjQv7JmzPJDtLTzA06VNu9XAV6+RS8xSASle9f4O43QRUDKLTY8A4JH6tu2nzpilka8PGumMSruH0hDECI3LUI3dXAHoDqyFoliEL3DZjBSCIO3T4v0XoeJG/XecJHkKytYpGqy04WTLbRyCrM3MrIqcQoYQXCf0vhYq7SvURscTyDQR23tkRtrs/PiWuqD03kjA9L1MAKWWv15eK2Th4Xx705VDOpFQ8jU1CQOZMh4f7lpHX7D6kOkSILfhzCnPmJdzHVxYz6NNoUj4Z9eX02j8ZDy0muSj8MAlTkQc89MIaf102jRIwqyW+uJF8I0yFs4Y+l2D1fzNZQ/mnu1vvUiXtxBFdzu68g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 03:33:30PM +0200, Pratyush Yadav wrote:
>From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
>Commit 91e74fa8b1bc ("kho: make sure preservations do not span multiple
>NUMA nodes") made sure preservations from kho_preserve_pages() do not
>span multiple NUMA nodes. If they do, the order is reduced and tried
>again.
>
>The same logic was not implemented for kho_unpreserve_pages(). This can
>result in unpreserve calculating a different order than preserve, and
>thus not actually unpreserving the pages.
>
>Fix this by moving the order calculation logic to
>__kho_preserve_pages_order() and use it from both preserve and
>unpreserve paths.
>
>Move __kho_unpreserve() down to avoid having a forward declaration. Its
>users are further down in the file anyway. Also, it results in grouping
>for all the page-level preservation and unpreservation functions. This
>unfortunately makes the diff hard to read, but the main change in
>__kho_unpreserve() is to call __kho_preserve_pages_order() instead of
>open-coding the order calculation.
>
>Fixes: 91e74fa8b1bc ("kho: make sure preservations do not span multiple NUMA nodes")
>Cc: stable@vger.kernel.org
>Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Nice find, sashiko was also complaining about same on my kunit series:
https://sashiko.dev/#/patchset/20260512195135.804833-1-skhawaja%40google.com

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

