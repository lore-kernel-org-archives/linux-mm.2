Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9F5D14890
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 02:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177C66B0092; Wed,  7 Jan 2026 21:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB306B0093; Wed,  7 Jan 2026 21:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3FC26B0095; Wed,  7 Jan 2026 21:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E00EC6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:12:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82A7D1AA2A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:12:53 +0000 (UTC)
X-FDA: 84307173426.10.FA4D9CB
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id A841D1A0006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:12:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F0LqkPrl;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767838371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dc8PyghtvdlRSO9tPpEj5myMC/2Orvga0lvG2eJ2slA=;
	b=0g4hLJgrD6xqdzix9QUJsznrioCC1D2k9zZtztK1ivHhC5JAhGR1n7nIPuvc0hpRkknkjD
	ICXpkqFDRhlKXJXr/izTkfhhFqcur8og5X6V9OEwxxk/Lla7HId6YSErOeh7Im4kXBIAvL
	6xYu7DbL+vfLBJpkKWhDl3Vnik/zzds=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F0LqkPrl;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767838371; a=rsa-sha256;
	cv=none;
	b=2xTrAOineABm/ogga0Z2rzIJb8v8VLH7Z0GSLRHj7/OxMLmWHy1pVfxBTPmPKelGZIByWn
	zrXPfm85E9hMblaembqz/+jdCNTbXlpEAhQ6SoslqKIFMBvjJFxkuzMWNqhmN6oENMcj5Z
	amKJDREBqqGrmKMZnp9yiYBgWgR2jZs=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2af41f558f5so2199947eec.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 18:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767838370; x=1768443170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dc8PyghtvdlRSO9tPpEj5myMC/2Orvga0lvG2eJ2slA=;
        b=F0LqkPrlwA4K8ev9r1i9bm8/aj5a44Cxb2oO7nUhuaJ23W6wkTZrgKdCp152y7uBFs
         QrgnFS3vF6tSlmukILxj7lMIhOZLLGipTOCahfPzIKu54vxPnbVVKNnsN4EVGV6fIW7O
         7q7QYelhYoW5pi+Xm31PnnXNHwE1ChAos3wvkPgaQWFxWdOcAa18rViJd9CJLFSxmeuH
         o0FNLS5OUwXP4LRCp2r7uG9uANyjKaKyHc9OYUUeuMZS+mXEw1UoJN/ZGkVfxxH93JJY
         MgNjcU5g4B4+msCaZjsoYkB9CaDrJArRUP9htq2cQPy3zxuBFUOcEaoXyA7y08y+cfT4
         WQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767838370; x=1768443170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dc8PyghtvdlRSO9tPpEj5myMC/2Orvga0lvG2eJ2slA=;
        b=p8mBHirZTJl/ZOXy1M/AxcORzR58gC21IeZKb82GfCSLLv6fFnxdqTZiVbUAZlWU6o
         oN4w144P9dNuRWebxyrZ2TfbA2sS65ImM7Riger9IaMyf2OEuU5X3BPb4j9/UjcBNdJa
         ttjI0+VdBGgS50pmOLviejMOF15HkbPY4TQAMvSo1wZwBytE0v4IYYKvc6BwLDTX9fyC
         J+9jucetj67+D23LAGnThY09Mgf3U9DktdG7jtKSAhfxIeQ+7Lgf6prluIPSPGoZ5lKD
         LM91qgR5WbEMncHTjJ8z6JgGsPbmuXynXjYU+FxIuBU3Gpr75zVN3W9PfEaBQm2hPMRh
         f6cA==
X-Forwarded-Encrypted: i=1; AJvYcCU6AWkyXRQvA3131wLJF/lvQcVKGaplbrXd6+5Fc5Mnq0igGOuUsAkpyDxR8ci6IQ0G146BVuFejA==@kvack.org
X-Gm-Message-State: AOJu0YxnR6sZS8MyvTaI+fdHpOi/3esWg2C0a7Ve4oCqOU6GPt3oUa6x
	EbZShnae6sRcM0hCoNMyqRkdW2xD+YoxSNuTyHuzlR+59HML2HYZvUXr
X-Gm-Gg: AY/fxX6LHyxwdYdQy0QyxNVXN/yCh7mnF7e33HVIunvuHj+JC2iaa6pCrbrG6NeGmb/
	iiofz+dmgMuYC+Oq0HyrvJPeeqxzkxA/toj6fPbUFAmQ2ONeTTj1IwCO4gF0E2TuaiPaPuQD9du
	fBD8/kWUnvPSF8QUf16IvgVkoUCTFNbHZbKz5MwN/KEwVuK2MbyY1TQpP2+jCYwgTA1Lq2HtRSA
	7+rLriDqiZ1T+td2vgONsAgNvfK0lAMAoOYodrPZBmSxTn5TAjueG2vpXX9D9ww/WFsc9/lZrQ2
	QiL9YkmzbzgjfCRlaXfup1jZT2Ih/9S0vZFA1XCOurkyyczEwQjJkhSvn89dAijz3MMY6RIxlG8
	Szuq7AD/lXT2M3NlqWJQEDqax6yrj1bgaE8AbVGoClRw/9Sfek/ZHojhVQPsBVG3cNGUJTSAeOU
	Ej
X-Google-Smtp-Source: AGHT+IGdu6VmZnIPKWkx6NXDLXAf5b71hWdgf0gteyqFBNplDYTNuYVytmH61SR9H9IGtnHEZB9O4g==
X-Received: by 2002:a05:7300:fb09:b0:2a4:3593:466d with SMTP id 5a478bee46e88-2b17d226c06mr2746197eec.9.1767838370366;
        Wed, 07 Jan 2026 18:12:50 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b17052dbc7sm7933292eec.0.2026.01.07.18.12.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 18:12:50 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: kevin.brodsky@arm.com
Cc: Usama.Anjum@arm.com,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH v2 7/8] selftests/mm: fix exit code in pagemap_ioctl
Date: Thu,  8 Jan 2026 10:12:37 +0800
Message-ID: <20260108021238.46605-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107164842.3289559-8-kevin.brodsky@arm.com>
References: <20260107164842.3289559-8-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A841D1A0006
X-Stat-Signature: eckitq14bksmyh9k7hjm4nqedt3hptoy
X-Rspam-User: 
X-HE-Tag: 1767838371-983245
X-HE-Meta: U2FsdGVkX19IOaZy+/z57OdoFqczDoTIiVm4hCemBVwKUGdRLH/E5h//JGeNdd2by5q4y+GoM9BUb4z/er2M1ew75D4zLW+olnXpi8WCCcQEQI3KV/3D3yhKESTUBsQQTWB1Hl8fbYIKNH2N1iPeKq8w3ob2P+dhwsE1P2ok4yudLHueWj5EcjMju6lajIViQ7svDJXddT2pSYzlGAx/WinXhLmowwlNxOqRoJ4LJU1ULx4AviKTX7gU2wBt2b0JMX9FPAIdhJQd83poYIQIFuMqlFeX05auU0rUnajFLTKkuNd9qL+Vdw50U8pPxgGxgyPZm0scrgkZqihm9UlbqmLe/L99/3rOnDyQb2TlayzTSqlUA5QO5pxGEAVjSp5KI6W2cB7ciP8e2rcjUbFLLGhDW+ep+61F48Kl83oVp56xKM8KDzkVhzbPU4NjcaBNUeTW1tLmgXoH5DfG7v3GwvIQeBEeTru6VEwmEKcefhVMaHNc9wlfFbr0XllxCkHwKQQFKRLhKbIxhl//BmO8du0K0tEbfRgUO5UHNSUzxE3tEYsoU7obPZCxTS0NlsuvXb3jdV8JbiEn97uX07NJ+BDwsyQAkM9J2tkhICXOCYucJdbYvVyfL8Ap2pCTsUGaOQwc5+iXHDKfCl/634/p3NbqFeddtPEBuA3CD/2e2sdV5fYWSu67ozCCAR99USeuDGVX3/vUwoV3gu44PHe5lVbo+7OvOZscpNIj0PCra43f78P2l5HZ+QvdTr8TrHXu/eV4ebAir8iZoKwdSasRtEbICzQyEnEVb5fU9/TrY2rcAcYikXn3DXcWy4//DY6h6YVILRqY3aTqswjW+gN7zCmrJQgux14plGfSdy9yjQ93KG0i1dcWcDFlsR/cqWwRigZdxIGTrKgtzEm4+v24wQU8JzIDDkva6UAzlTC4K484zucg4bYOb2PSq2zdNNCWeJlcS8Sbf1A3HrFf7J8
 fvcLYK0h
 OiMU89SUuZGUccdccjw8JC4MR/hqRFQdTbVVuMNA0xGBRdEE+kBDHj9lJGRlQzx6u1qBIK0gl/hA1RKnGIfWkhW6QDl99492vt7aiaFOP5Gz570Xmi1L3mhomFbIwhQgngJa7QII+hNU5NyNz5eQwWqfGTfdIPSAHcFZlydq8MyNi6JCF0s9kEWlrpdPaMQw8i2sytlX93lsSlIPrUinOfjoUqwxHdGtcElTF1dxFrW1SuC6qtaoRJ/kqRDVRH0f7PFMBeXov1u+M91yejkO/F86Y4xq67qd/uNE5vfkJS0zRT3pFmttDWgdfdw0O0+mesMtGCpdT0pc6RpN8qLpV/fusKcUs6TV5E8AFrfJ5OI8i1EzreWz0LJYt9Yvq/TOJyxDFyxoa5wbAtydPjSPv789364wNfDTvkgS9yHDdlgjAbGAN9/XoQkrho98qUu7QIjVLUsoyqMY6I+6K9RW3EI1itNba2c/OvLHVB+Ih0Hz5c5DX3URN20lBb7VyBBX1S0Jnc5qCGbiNidBeAaIyv4v0IFA9cP+PHoFredwYMiFOQZlLZvoqbgms9GfHATwZFV1sxKAFEfgNrZl6iFxsVZvhFsVo3a1qE2QIsnuMYDU+YQpKuvV5T0YGD3i52B/5ZPDre/Vi67bfU1Ne/eT5fa+Hiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Make sure pagemap_ioctl exits with an appropriate value:
> 
> * If the tests are run, call ksft_finished() to report the right
>   status instead of reporting PASS unconditionally.
> 
> * Report SKIP if userfaultfd isn't available (in line with other
>   tests)
> 
> * Report FAIL if we failed to open /proc/self/pagemap, as this file
>   has been added a long time ago and doesn't depend on any CONFIG
>   option (returning -EINVAL from main() is meaningless)
> 
> Cc: Usama Anjum <Usama.Anjum@arm.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Reviewed-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

