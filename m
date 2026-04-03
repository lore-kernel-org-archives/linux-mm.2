Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C04E7E360
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 09:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10E66B0005; Fri,  3 Apr 2026 05:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B326B0089; Fri,  3 Apr 2026 05:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62E76B008A; Fri,  3 Apr 2026 05:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1C2C6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:50:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A0291A0557
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:50:24 +0000 (UTC)
X-FDA: 84616774368.09.47684F1
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 72006140002
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:50:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e3DCqepo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775209822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KReXkppPG3uNOMveoUqnh+3H0YwKOe6D48GuF2fODs=;
	b=Duv/Emv5mgbf7nkDXHrLOBgioMlrYwxlUz9gU2X/Bei7aWcP1K2bDPLhPvBT4nBuSx7+/n
	dYWFcKy2j61oT9CdJxyi5nLe3P9T8eJsubUVj0nzSRRy7bW5N5WvbFJrO8r8yvbVrFu2GA
	HvLwfGzqp9f5Tr+1Nw1EFY53RDGnFlo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775209822; a=rsa-sha256;
	cv=none;
	b=MSDjv+ItpVv5q3FpGPUrmcobfPro73/KMhTMHsH5jGjQNI2y/MtAWm8zSlSk050VqYmbY+
	qhYUKYy6NMnI2FwHtxGOVCp2d5FVcng6hLdrTceW8PfhvUdYj7EOvBPOHx73lWbgqM7NXf
	8gCxIKdnvRClMtYSXw2ocNVat2LUk2Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e3DCqepo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c76c067bc51so669674a12.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 02:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775209821; x=1775814621; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KReXkppPG3uNOMveoUqnh+3H0YwKOe6D48GuF2fODs=;
        b=e3DCqepob0B89kaDDM1MH3mh6VIhxUGwYavuntr/KOLoD63KdOS2JfGDvFGLFuyU0J
         ckEwFzcDarMwcPdfvJPxl7AgoRpe5KM6KgkwnibLDatig0UQF1ztafxW6kaJ6dtko8Eh
         s5ablzMWjgXEvLbIWPonb5/2C8TjCMtFmNjZ+/HJR1Wn/uQCa3xg76P21iLRzMG4qPPn
         qdqYkcyvuK29ORlKra4MErHdTyPWMiWTH70dPxpOHLcNLzYs+IexU5wwIaG+PEY9DoFj
         GufqnjpqBx/FPJL+dZ4S7FBvxXFOnl2afmMCA6rewyl6myGoWgyqmNDxBgU7sKoNXvIa
         YUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775209821; x=1775814621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4KReXkppPG3uNOMveoUqnh+3H0YwKOe6D48GuF2fODs=;
        b=bM5O8AP/sVDJXCjYDaWbv+FxEOwZJUA3aZ+/2sy+fTvU7mhQKMHt6kFIyx1XJSFcfJ
         EYafagwAhVl9dy4YgxWxgxg/XtP4Mx9VDA1rOAbNTQQT6fDXGxt8nHKde+n//zQPQqmQ
         Xde3otnG54TStnjdW62+VzrgY2pkNNqcNkAoeaWSqTRWXuUSjabRI1424D09BCuF00wl
         EhJtw7Wq/M8jgckOjNMWp7F5/zfXKdbNtGykO9GImJyIa3YwoiKtr44yEWE43sUcRg6o
         Mv57IL/YjDjmCSaTbtQajymRAzi4VwdZWo2gZhBLg722v4IwVUxc7iZcr5sovum8TkD4
         QLxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXT8A/v1xMsa1NwXxRVo0W+Y+31QLLBE0x32UhiBeieE4yKBeSNM+o2HstkoQ1bs0mq1JM91mIfpw==@kvack.org
X-Gm-Message-State: AOJu0Yz0uoiwBXyp9tVAOSt00JTbdTB1eEwd4jzfLWylXb/phI/9cbw0
	+OkHKlP5w7Lfjj7MNtoBRt5clti477OpWfiyyYhrT5Q2iQ0N1GZFJl3N
X-Gm-Gg: ATEYQzyqToc6xR46RNREvam9VOm7bFyMN20uqFgYKKbgSdhBhPt92krnBE7Y7IF5bjA
	qYMH6vPwQDj65gn8zUMHtzm6gCFWCiEZzkbGLHNzmQWbssq8suUCOGHHV5scUKkkRb+ugY+XPRj
	r9M6eYMVvMXD/SZL1ayS88/+Vw0FEpvLePK7qSyGlZ6bPHYgjGSEW/xEUPDgchl8Cwmf+dRr2DR
	XoGQI1Gyd62CZUNJ65OH+x2LdlM6NB07DbwyFfExGeTebanjv08fic0XraeYSR7Red7emYmiTgL
	pxNdmDo2JxiMHvOjYvChNla6+ANImRQUOl2XLMFD9T6Xhce4F2OazIQlJDy4KVdMuQy6K4PNvsx
	cmAePKUtR/qWzRG/45lRETN2Rj2x4cQAQAGF16itZe4PUrD3q3tDCSNCWbLbtELoaLWGAwgER0a
	2rPwaF+ZSn+LwO5/MaT9LORHSPBRLzZTDMkPTFso2AfnddI4BtceQ=
X-Received: by 2002:a05:6a20:7d8a:b0:39b:81bf:15ed with SMTP id adf61e73a8af0-39f2f3358c6mr2215246637.52.1775209821060;
        Fri, 03 Apr 2026 02:50:21 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6561fe9sm4612331a12.15.2026.04.03.02.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 02:50:20 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: yanquanmin1@huawei.com
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 17:50:19 +0800
Message-ID: <20260403095019.29222-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8a902208-675d-4564-bb31-fdefcaebb752@huawei.com>
References: <8a902208-675d-4564-bb31-fdefcaebb752@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72006140002
X-Stat-Signature: w86a14b4qtzcnxb6mfyognfwsa6u6um1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775209822-143726
X-HE-Meta: U2FsdGVkX1+1xeDtUNySNbtVYasXz1LDyGt/AGMvuaCoTJR3Kv3zEC93WztWo5fybUlXXTx6wkaz+xxGENdasBeTPVhLUtWLi6NW9D3B7/oHqO7oNp9HGB2ZfM+l6woNvG22SZ50SO0pF7F4UoTULiSmKCuJEe3KZ8P128Kf6/+7r/FcH2By+fLEaUHrr9ngnLPgR6JQnYzg2nOQf6eZA5hvJjwvCa2z9MlFtmLQY+cs+ZKoY4uyh532wse5t6ZH7bD5GFyjYTX4krpOsDxgRx7HCv+t4qq0nD3JWiAEvHuJ4vPngvy8FNe0rIXPnjn2g1AAbuBsm3T35GMV0l2MGxN9lffM0N/1bbcqyrFWYNBSAsemGXGiuVPTJFTxi5lzIVQfN5z/RdArrXhahSkcEB890hb9xUT3V3Ns++vIVBIp2qaTVT+8LABKJ8468mA4ZkezVjgFr/tyDbajGTGbT82KC1ZtANz6N31Aed7EZjzZnjsVyaJyj5gIc8TNsiFRJxf6fnhP6T5dmeewJ+ZAocQ7Lazy3kksiMnZLCw4ZsOFeX2zacNHYz03Wqrp9Z/zDwuhYgVB9vtyp7zIE1ZRFir4sok2egPaFPYNVMYoIb6R+9HDYsGqXmgkqVH0j9VOREsNOZycswvri3b6nB5obT+e+P1xcgfn9U5DtCXzrOAIpVr0UasEwcZCjq8xN57koByZTRy0SZCWKv3F3ogRCZjtlpr3IR67YE2n4E1r2dyJs0FTdLRZvGAbfXRcqmIeuBsSiL8KAE+JrWPcbU0rQ3cq+qYTttpAqglkuqgNMoeJo2LO8FciqiiyKJ8ujBnKHlPNHnlMY5km/x+YYGWABs/2I4HebnK4xtFdVDczyoRdCxGzLf+hR2beQIPhg9envwe3FTsEFOxHJ6ADvg1gG9vkywyC1Jaj3jBaWiMUMMBUxv8FS5OkZCEdUpxeJ3K6sK6VMQ9VqqJ+B2TRzId
 SiE4Ql9i
 y1UJCQECxgJmez2VenOUNJbFY7kT+Z8AxlfjJTJK6QkQ+V7pHNywkQpoEtIZbh+I4pu59GlfuvkeUqrHb0E8qjC0FsaEYHlTRnra3B8TvbEe20eVYVa3qhJWMxV8eHFrMTLNoi85T2SfUaEHerroBU1beX8KXQ7ag7tQi2pGr97q+lH3kMDTPBFnwANIxsBLct9YzNhWW5pbXPXKw8SicLqZYCGaZ8hMbWCy9twONk9goJBJ6AvfExkNokXvg80oD0gIKAeSbLmjfrPPqqlvBTutGY1n+zb8bsSIh6VyYO4QU46XgSofE5LmV3R1HHkMUfvGKWudVdDuxm5LFp430210SKqBf58Jrlmaydq4xuNbdDln65SLT7onodV1obTq4SjEHTXwLrvyaz6aIW8TZsWcqSAGoN1feSHSk7eU2POy9mAMcgFusfs/KWwt9f7hdvE98dIMDphSZR9Zq2H+7lZjSKauPo6iawB5+yETf8OmORWZv7WGom7sTdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Quanmin,

On Fri, 3 Apr 2026 16:59:38 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> [...]
> 
> I'm a little confused, what does "causing kdamond to terminate
> unexpectedly" mean? The damon_lru_sort_apply_parameters function will
> eventually call damon_commit_ctx, and the power-of-2 check is always
> performed. Is the early check here to prevent some more broken case
> or am I missing something?

terminate unexpectedly means - termination not initiated by the user.
(e.g., not by echo N > enabled)

The issue is not about whether the check exists, but about when it
happens.

In damon_commit_ctx():

    dst->maybe_corrupted = true;
    if (!is_power_of_2(src->min_region_sz))
        return -EINVAL;

Even though -EINVAL is returned, the 'maybe_corrupted' flag has already
been set. When kdamond sees this flag, it terminates.

My patch prevents this by rejecting invalid 'min_region_sz' before
damon_commit_ctx() is called, so 'maybe_corrupted' never gets set for
invalid inputs.

Best regards,
Rui Yan

