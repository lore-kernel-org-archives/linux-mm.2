Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6A8C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FE96B009D; Sun, 20 Sep 2026 08:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FB06B009E; Sun, 20 Sep 2026 08:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F616B009F; Sun, 20 Sep 2026 08:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECF9B6B009D
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:24:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7834A8042E
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:43 +0000 (UTC)
X-FDA: 85234059246.05.6D4C810
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAD1C180005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MzxXbciK;
	spf=pass (imf06.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907081;
	b=jiWUuIISPeo2g8BRSavZ5XPOWQtoLwnT9B96JD7ncT29LTOr6SFG6tzznQB+aaqkg+lHCi
	xd0k9h9YXq4CtFIuApry3FN7G192nfC6wza3g4d2BurnRuvjBcOMvzX54YD8cIUhgXS0bl
	YIURl5c1C3pBeF2rFMDmuEQ+wjABS7M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MzxXbciK;
	spf=pass (imf06.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InRkxGfoq1s0w/ybf166NOP+zAmO71hub0jrhGTfC6U=;
	b=sQdxoUng8V+pVi81ULPUatGQFaAvjSJr6UClHUQeJ39sPw6IAisKkj0SgfEztgOPy72bSV
	AZ+YlKgwB1FTKkOuZnLK/U+BMOS4zgm1o04dvyiV78VhZkFcfVycm1JAj9vL+nzNlLYKOs
	/Lgd8QO9zjKbOVFaIFP7oTjtxluHsVU=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39dacf053eeso1528943a91.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789907080; x=1790511880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=InRkxGfoq1s0w/ybf166NOP+zAmO71hub0jrhGTfC6U=;
        b=MzxXbciKdUvd2btLbDFFJHhfT8i1LSM4W31JZRzjnZoM1fmEu/ZV5VZPzDC0Btqb8o
         xXKFD3HnEqUTp0vDNlITn2MwzRgz6jI2i8294tkmmfJhA4/V3uy8YMtMEFnFziQX7FKJ
         0g6Ip4GVNtnlYmjQ9mox0rFKnzPKOQzNFVj21CDqxE9JWxQubKfqjqeVFulq6BCNajJ8
         G7GEskxVdMMLpnTd/zdhEPDtqtVVTpugIk/2ZcNPpN1bdrdZ0PwDjf039Lytw7QRm7FZ
         l/JMHbG7oCEDxLtp+YTHa8lpnm3sqWcSzBG0+bXjzlRCuans0R+KIuVwJSk/tOqh3Vww
         2LSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789907080; x=1790511880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=InRkxGfoq1s0w/ybf166NOP+zAmO71hub0jrhGTfC6U=;
        b=hpky3Jeqr2aUx0SwcsCso3+LVaa2eCKeyVvAxt6VJllNXfD3IOaZOf7caah1D/LDE+
         7RwOsq2VzTbrQndwS82FltWNQy+hMm5l5GNA+jTZb5RVY7tM8081FFf1/N2R2Xht508Q
         V5minnBRNQdVHUBb9MbekiyQjrlcM4ChI+mGP0XQCwNN/kdf34h05KA1OpJIKHq04SrZ
         yGthIvZ4zVcCrCE3ld17MHDmQG/1OcRNyGENS9Bcn5kAMZDe08C2YgbarP/ogXpqGgB6
         xr3JAHYrgqGi4U2gI9jl1AxwrCWfYwcebrMBoQzUylCLbdzxf9D5V6Qs975seEWVz5Qt
         3qnA==
X-Forwarded-Encrypted: i=1; AKwUvBxQI+/NLzL701UmZvcZxFXoEH/4O3Qn9B8MfuFfrmLdSTVrzjGvRJA5343NoRiTnv+1335mYgoadg==@kvack.org
X-Gm-Message-State: AFuF++lDDOL4MHIRsAzBU8PyPHdw8Hte+rSD1SF+LJpcTZc8z6KZQfZC
	ZS7MJr5N3ZNev+SxRY1QtE+WpZaFyG81a9HCjlq6TXOW8ewG9VlvIvw=
X-Gm-Gg: AYBFou0vTfOwWAvKV0siaPudNsOtoCf5lIyxc8sx7xOKJxa6lQDtuYOHGn8kbrdxV/R
	ZeSGAtmJEF/QMa1VFuWoLEtfqCwS7fr/PAO1StEj0byQlnoFRVwyd6Y1C39dDUbxzFeRnxVgBKW
	a22JP3Jo8nWHbYcFFEK6OMTv6YPxhwY8NA553Z3F5iIc31yKhIKhGvohf4jp7K7cbcfXmMGYJnQ
	ARarTUtuVXWpP4s8ps5qq50nvLrJWf0WL0aQvibWP2DYtOfAQhihDXmrS6Jra/kcfj1Gb2Se/nD
	CIhib0xfIv14pttWNoNrANGvtgaKDNBjDIvRyaHQ7ZA/FPO7fqBxCY6Xeg5X80VHnpQ4QifyKxd
	hCvgCheLvYUwGxFhySuBE9a4GFAD2KPjgvddgH1nOTTRoMtFmgXqLnZN6JV3Ovwr7E3W++ZeZoy
	zvzgRL7CdV77C2xSkBgwATrG3x6ssmRByYY+0I1kq/vOy04qflELs4+p5EOZW8vXc9hOs2qskna
	b0UOs3YQVDXp8z1RN9MrNtBPg9Z
X-Received: by 2002:a17:90b:1e42:b0:3a0:345a:3620 with SMTP id 98e67ed59e1d1-3a0345a48a4mr2499091a91.45.1789907080513;
        Sun, 20 Sep 2026 05:24:40 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:e0d6:4b87:c472:c9ae])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5647c151sm4972754a91.4.2026.09.20.05.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 05:24:40 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: Re: [PATCH v2 2/3] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Sun, 20 Sep 2026 21:24:36 +0900
Message-ID: <20260920122436.610279-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920104054.47877-1-sj@kernel.org>
References: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com> <20260920023111.2466265-3-donggeunyoo.kernel@gmail.com> <20260920104054.47877-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAD1C180005
X-Stat-Signature: dmm9dnr8pfotku6gciuw3rmwmd814np1
X-Rspam-User: 
X-HE-Tag: 1789907081-106228
X-HE-Meta: U2FsdGVkX1+KfyzMDgmy8oC7c8thckkj9uqp12fgCWlGnWUtFJGLaoluLGb5DAinyQVZY7NJyat8nffpItWuk5JuyJaNQklGHW78dbol/F/Ezwc4DGDUegwZCwsRBT15LXXZRILL75/OqgHzrUzwb9V6oyuBpS29XM04g0CyRxnzbpYAIXyv+ifjb42hmptXsNz3TokD8vCvB4O1prrygib/Ez357hCYE5hMxp0WayTAEjVVKF1sW/LXHu6d61erXKh7z8BCBMC9HKWtNPMA3tQJW0RyQ/0Bb5xQEYwdgGyHNBnwvncYzP6sII+F0LIwfGXkGsQsguRsLXUBZTfceNYA95VoRDUokGIW6mSJuWj8//iYWWBNJ3hkoR1iyYBA8ZL0Q84gyGSNQMjvWSIW7NFoXfYpqPoI/bl7E6PWJt+NY5zjFONANjqHSlV/DaAtQ10sLPj0IU67aTg9gdHpI/DmMyeVM25Y7hwP3wZOOhmZWpfPz7ZM8R1x8KLmkAzNu0SZUaWBMXw5iVFCQwkQBY876bRVFfZs0OLU4LeMlIVXQ38BDQtUElRYLiLNsPM2qJymCtx+b83RUKvnkIik5jlWE/YDdaCVngQkaWd3QBLlONcRVoxmnhxZ1Jp6QsLTrBHgKgf7CmnP/KqH4ui4hrWaYNzjA0osJC8YFq136/1H7pB9xPd5w0W+d3IOWZwFf1a7Gj8zKM1/WEW4+PR2Ed7yw2TuEAYvTha8P+i/ziacwcqoQboBud5YVrG4o0ie6/mKy364vKjVlltRO2R41he5GvkD27a10xDvu0DJMNPC3UOceU8FmscYCb9/Db+pLf6mxjm5r4UaCwXknz4VE6ipZpztUNqrCOyL/wbylGHVDC8ViLwPF14FqK3bCV4nbNxjUJtN5rDW65LiQht0wkDugBIyAa1fTEoKwiKcyhxW8BE5C0WEvhozH+u2mQDIKx1ugobJNvFbc966kq7
 HC0cHvvR
 DsvnAMnNOKRwAGhwqemooakuocjSfpIRVIK4NnuRma6ffLB4qT2g+6hzKigNHzcueqdwprgD9YAy6netXUU+GEJJBChyQsTQ/APd0/JSzfX2Cpc9YQkZ7kskkZTVCdJTjMaLpZkhzE2Q9UdmG5fe4JC+BEJWthm4tOEd21ioQCCijl6jEWzzZaAVViIj/DChNZVzMHLcDpVNYZlsysk/rOMI9pf/BX3Lit6jysrTugAAfmvsyN3CPTz9kUJL9j572h3Rh4XVwl7otL+hkieheE9pnj+LjpcTbPDiV7Ez9h60t0WZenXtet5ON6xTeVUsMlGY3t7tLrm9+qhuHuva7kHqzzSm5yRB+eDqFcHuNArN6ftwHQypiKBqFT8xMfFTOMJm1VOESqq7DlOanUrGWWDV28F2loK/Rvso3K/LjdkLhzsseU6skq/9PXwsWGX7MmS//fFiXImbOUL+MJfYGLJPDaVscgkgOJIVdZ77B2cFpON2iD/zWc9aDk4pj45oN4BIJFi81kbtfw6ARErNjd470TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for the review.

On Sun, 20 Sep 2026 03:40:53 -0700 SJ Park <sj@kernel.org> wrote:
> Please wrap commit message lines with 72 columns limit.

Done in v3.

> Other than the above column limit,
>
> Reviewed-by: SJ Park <sj@kernel.org>

Thanks, added.  The code is unchanged in v3.

Thanks,
Donggeun

