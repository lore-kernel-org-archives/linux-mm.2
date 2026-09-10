Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC1C0C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 19:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EEF56B0093; Thu, 10 Sep 2026 15:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C66C6B0095; Thu, 10 Sep 2026 15:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD4B6B0096; Thu, 10 Sep 2026 15:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 567686B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:32:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 585A5A066A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:32:56 +0000 (UTC)
X-FDA: 85198850352.13.093AE94
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7469B2000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:32:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qhZKoLMe;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789068774;
	b=zV3GEi4Nwsx7JEQJwqm3GnVsDhnlpeq4A0t/S/Fw8CDn6zbNuVf84GHl4TLAQd5bi9HFhv
	RpKNJi4IYsCcGs4IEP2+b+qTblPnSO+glWn5TFs+PpPhiaMhEI4vUZhVDJMoNSl/Z246dc
	Xuwh4uFwzW6Q23qwRc42QOEwNhB/tds=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qhZKoLMe;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789068774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wx9b/wJps4tZAupT/5Xjb4IrxZENQ2MyTShVT9MLYWc=;
	b=RVy5KF3hGWZ1nEqLVJoyG8jOUjj4TASpTs2Wb0ilPBgohkxfpMWSTcS+MpC8mhfU4uPdzk
	fc7uJkQoAYvwoazoIeTq+WNM4yKRrE9el7OIfg/Fh10Fxsnzv3sgSIcvx40sgRpzg7I3Ba
	jJXEFU0HSRF5YNakiWSKiRsu83Mtuog=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9399daa3d43so2091585a.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789068773; x=1789673573; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wx9b/wJps4tZAupT/5Xjb4IrxZENQ2MyTShVT9MLYWc=;
        b=qhZKoLMelqp+FGt8ScMx5myOFyrH4okTxX7fBGjz54awSxNpfT6YLbFfoGZhG1DlqR
         IKoNI+NSk7esIOcRd3DN/Ku61/fU0ZlCS5uRJDRTf0Gx6PYZEia08CgY10Lgjc1Z6eFu
         i42t8gH4jbI+z3OI5uiQvhA4GaVU7C72rY380nougxgKSOGKYrEyZgwuhjQwe77EJv1a
         Ed6MkHs8pTM+x5ZITSjWiMCP8uq9aFVW/O9trne89iEqTYZpy1Dj+c53HTN+3qmpIZpo
         58tfDD9TIYLXIJ+nPOPLDAoyRJbHWq6BuI7DWj6iKavK0TANeIp0wnOnaCOXZxehcm9v
         PZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789068773; x=1789673573;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wx9b/wJps4tZAupT/5Xjb4IrxZENQ2MyTShVT9MLYWc=;
        b=HeQKtZu8oAbHBjzPtjPJTfBHIS7wmtl+vcti5nDwcKnajc4uAKeCgN20tVBP98S255
         wi2GRYxrQ/IP70SG+6852g8Bf/quv7nAdcNb7Jyq/S3783BEi5x69cwDvF5FiRdt8z4o
         h1DH6HBKGVi53MY+fTpk8FXzK9mjzgsUAp1yPYtlXB+pvafN477Wibb8wOsFOqcnlfOn
         tJh4kMDSQsBdVFcln89Fb5Afj+HztYPcoDuX9tUu5QjKz9MG/P47TI8Y7ZjXh5zNanh6
         UvR9G430EOiwupsw5+dMUR+aXi4qzqTpRRMUTeTg7zPYXewBVxnC9aTbyvv/sDRws4Rw
         an/g==
X-Forwarded-Encrypted: i=1; AKwUvByOAkmdRHOuHn05lTxkgBwONprkRersfD+1OWvNv5Nhirf3lYj3z2CCEb+GpfJd6I1Aj6fLJI9t5Q==@kvack.org
X-Gm-Message-State: AFuF++miJEiNhL28MdTOe43hUDQpHDes6r3xsFIx3odcoSfZup6/Qufh
	iKlK0W5kBy4UgoIaPCvHi9RpdzkowZw6C/PMGkhKTE41I0BGdSnZr+xD39OuZzYraN4=
X-Gm-Gg: AYBFou1X71xG67/OP86DdmBhwVEHPUh6wn8MNbG0xWkNXFDiZXZwLYasl7aTXo4OCVj
	girkys+S961VKGA+7pimNNjRzFGy+v6OD3WDNI1f8f+xx8356GvRjszdle21BzuHqPLK9lh9maf
	05e1YVBlNRg6So6Ds6B627r9KTfNgLu56e9524gJSdaonBUiX7d/Qe5G8FKq3+qfagUWeiuqjqL
	oDbL15VSSiE8aVPsS8lo1Yq96o4fp5eJJLUYNjhKITuf8VF1J/HEaC5Q2VrJM56MTd15Yxs5DqO
	pzIjNUBPLft7hFoD7PvFspnfDm5k3s2qrLldgyf8pPHw7ADjgwpmHShwvr+51Me7SG4phYtwyhV
	aaHUuLnr3oCNn9Ey6MB/m8LU2FP1Fly6/50QOLtzPYCZ3OI91vdsB75KOwWhVCwRI6lF0NqeIkw
	waZKtbxYnI69Hl1NSs1Qihquj7uNlFk5JK0+lCu2JFgs0GsaVZYx2GEI8xeGjvNYELgUaYpUJUk
	DStyxLm
X-Received: by 2002:a05:620a:27d4:b0:939:5ab4:e6ab with SMTP id af79cd13be357-939ea107106mr50396685a.5.1789068773404;
        Thu, 10 Sep 2026 12:32:53 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80bfc90sm54889785a.37.2026.09.10.12.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 12:32:52 -0700 (PDT)
Date: Thu, 10 Sep 2026 15:32:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 2/3] mm: zswap: skip xarray walk in zswap_invalidate()
 when zswap is unused
Message-ID: <aqMF5Ar5qPoX0LHh@cmpxchg.org>
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
 <20260910123544.818146-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910123544.818146-3-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7469B2000E
X-Stat-Signature: mt7t5ck814yj5kk5sdwstsdne3cihyn6
X-HE-Tag: 1789068774-308641
X-HE-Meta: U2FsdGVkX1/E4fOpyIZzRaQzH0Lbdity4SGuWkTzzM2gVp2N4ZLRQnL7226evsCc3IfC7t44CVDBUXTlFhuSFn/UeWS4huNIuIVEiAVJ4M88QJLXB7sVqhNmlU8Q1LNiNJsrDfGWpRzjMhNJLG+TzKelg0SkrTwYTYlwBQvFXNiYTivPw+M7LQ0Y4KyQbg2EzD2jM9tNYLEkvPpjo8gN9MJjY/UUbLTDirEEYMcdlGnT4VyWbCe3azGjexlhLOatOHSe25HVvLrPc4YibjdxLWpJl/4yShBxoPU4EagKXbAlpmVw/cUER+wwgJYrxtgCd2zMFTSZQppqu9lmX7eIVfR37hZYR8L90eVziwOB8KS+yHqPSkFJ//PeSQbAUlJmsKGakuFGaQaIy3jr1BEu4MCFA2Th0XOqR9pM9GscM73nJccp0gBRxAd8k7SnBO1XgNab1A5xeYRBHfgPz0DGz+O4+l9OCl73kMrtTIvrtsJIFOoIUYL0NRPfBjFROBBlLl1t/wZglZkpJ7SMRGwzgnGWBQhA7WN8yS06+FTB7Ezf0tepx5DXxVNi138AF6DolutH6n2YMhYQA/TEPLWd04csrDSn+pfVcvW4Qzl7XZ54ILR/49nAPbJkiTKwmfnpGI8OznJJVHABhwPQCJc9L3LzkIbpOuRbrO5izeZfig7BaoTVXHazantPKP+sHw5v6wW0krm3nSwN7LGM8Qkb04jKGZrgUDkWqL750RW/StemSuvV7cTxLqCzFe5tcWbSzLhgbNWbYzWyWtj/KH8NVgjZyFzrHp6Bfa/By73MQcpS9+WJFGlIbCn7XQVVR8txq9TnIVP185G09AjjlnpYiwomPVeYkXXAfj1fhM91uwwuJKoUE90xLM20GWeGNZzsasYxtRvoacDvoIqWGqxFVijEB8UlwSaWlWBQqgd+nGaKKHW7xN+J74FgInlmQrkkOckHaxPxiiZ7yD8XLSy
 gEZqaIw5
 zyTwl5MZXcfgX65v+pbZzD0JBSIkLZq5JozeJkbNv5g/HhHB9Kg2LwT8kAaZ4DX7xfLD4NTGEyHtY8/zoLPsw1OLHeqwMyrhqbD80AHVL8c+A27J/t3qi+gxIfx6ZV6uuNVSsp75P+S+wtd1+pjPPaMT63gqr18ScPTadQoaXCpKkoZMVLmg+Hhg2ut+HlOxr7jn2I1+tLkZ3vG4/hOKVlGDcxP8BG983gTj/CpL6xz4X/oTCoOsUZ/APvh4WaSKsDkHe/x0QL+P8Ba0tJeUOs8JAvHf3YGCJDTTed8YknZNdTmgQ0PvdP6lwKTUGxmPgHT0SAqpSAxukGF11s8S4hlEGOVWvw0k24DD9Hfr2j+G9w+PXJcgYHJL8M0JzKsPEWvcvxeBY+rR+D4tCykxVEs0LHxrQH3TKIUxNVkfITev1iotv17g3JbnFamleH9vDQQGsV64ipL27nif57CknxOK/nLUQ2DCSg9ZkLH/Am+F4+6TZ5h626l2lEZxN5I3AuFKEkfx9Uk/wnDlWL1c/EEe0SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 08:35:43PM +0800, Kefeng Wang wrote:
> zswap_invalidate() still walks the per-area xarray even when zswap has
> never been enabled. Add a zswap_never_enabled() to skip it.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

