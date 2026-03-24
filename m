Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4B5E9A77F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6546D6B0089; Tue, 24 Mar 2026 08:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604A56B008A; Tue, 24 Mar 2026 08:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A736B008C; Tue, 24 Mar 2026 08:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 400A16B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:46:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEBFD13CF8D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:46:56 +0000 (UTC)
X-FDA: 84580931232.09.EEFFDA5
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id F3F281C000A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:46:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lMciNFTJ;
	spf=pass (imf20.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774356415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/C9WCnEhXvf0l7tq+woCUl0FI5DDJcGSAgyx1F3ZOc=;
	b=TLHW0uEKYhP9nrRiam+3iITf+J9j+yQP+EBs8+Kxl5ImuxCOFTovQfLGQqW2Dwn9I+FaxA
	nrNskGp4MOMUDPrnbOVIIeli1mKexlHDhTNcetQ5Eq26d5g7dYkK/UVUkYQF/9b/J21Jz5
	byZHeEjbdo/J7/SXFbBiuzPJQlGA/qg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lMciNFTJ;
	spf=pass (imf20.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774356415; a=rsa-sha256;
	cv=none;
	b=AOSzvVXJGhzRQNEIAHrRTxginH0ta5GidYIPNGFqTvtE/Jt8VwySAV14l9/vY52NqbqzgJ
	ewYLbcrUsuHDV+njE7x5WFzZEoPem5DI3wgMkRbHXmDSOPauARf4hAdpfVS5Uq1jO3OiJd
	3wRYT9KgPM7rXTFKew4xdo6B0KjPW14=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-486fb14227cso12770485e9.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774356413; x=1774961213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/C9WCnEhXvf0l7tq+woCUl0FI5DDJcGSAgyx1F3ZOc=;
        b=lMciNFTJHHcDrQoSbEbRE6x9dmddn1u9YvNm3tCTov6J6H1RGKikBXndvJmcTakvAh
         sSFLNzoe0G5VWicjCistlg7RW8SCpLfg2gbyb48JWzOHRHQgB3Mnm0D6feBT1C8N9Uv8
         GwHvbiviFeps8K1davwO2BJ0wd/oal1lY2U46vA+gLuxQQrd7Fy/i6J8hA3MhowyoGK+
         BCDcvWGKQf7mUSSsp7Dd0s/jtgaT7dvT3nvvroVhkvvnPjdYiDqomv4AJUrVeoNlM6FS
         lwOc/LkMXU8y4QdZ1TS7fezhaG71wN36w7g1m2KJoZH6YBuNr8zeC1geLcX7f5SyRJy3
         ArpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774356413; x=1774961213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C/C9WCnEhXvf0l7tq+woCUl0FI5DDJcGSAgyx1F3ZOc=;
        b=At90co9W874zOuIkyc7ZTWoBvSgc3GVIRGdfaTwchug4ldqRoCNfDJbM2Kb4XLlYKJ
         nLvKJRKnnl1JfKgClJXP41hsQTo5Mc1uZNRd1b+XoYPQK7K+DAoPCH02UR672JHlW3M8
         UKM6xZBUT+E5DHyrBht3MIyRQfI6lckjUQJyLUvrrZOn8DC3wUVKrbKrPQMZasmbR4gL
         QxCvbRDQJvF2HooZ2yOGxovOH+QE7w0hoTPlZkDYkNgAbE68/8TR/a86/1/4I7RWtbgY
         h3tI2waDXzBIxiuBDDn68dwCkoZuXYkRGlFjAgX2rhMgs+yluP090q1eB1+A0IljLCyf
         xiEA==
X-Forwarded-Encrypted: i=1; AJvYcCWLDMyQw/1i/lRbcBlUyMcbx6RypijVqRddK0i9VKlXl3hHh5DhKoIfaUhm58slhgkFg8jM9TrzqA==@kvack.org
X-Gm-Message-State: AOJu0YxkFzSnAge8HiGRql6+K+3Daa4yjvdWyEDIGb3fDNgMe0EbrmhE
	pV+FWP8vg47IoS7k1Y25uHY6xWDLGFTj9UYtg3QocplTlx/xZJeuS1TA
X-Gm-Gg: ATEYQzyuLuVIrArrC2xPHDvM6ac6aiP7KjJXZJZacF/4SC9OL66ivyt3YOs/vtblc95
	fLoQo7gi5jRy3rA/Jf9NEwf/oCxmqMUciSN9nb+UmmKENLu80Nwkfa5RVB7JV/9dsnAsOJfAe7H
	NUuxCaXAaxaCQUVDieIhn8nvEGVIp1fM4nFW9dVw11bg0vWPirLbybGhdjLip6R0fEbB1+Gk8KN
	enWkBnSbPGBwY9e2MlvbTGOCcCEHfVBRImEYdQ44dtto7aqt6q3Yix5QxB81BLM26hZjkfmYQgH
	6vN6cP524SweP/rI3gFg2kUkp9+Dko8xmokApd+++AAl+kmV66dSaWp9te++d6PuUcEHC5iQyZw
	g07RY7U8OXGJl3yguNl07Vh3vec1dqRDVjepcOcsK0Zqg08FOFV8u2YFysrlIvg1/VDrLQAIXxk
	S243GeEUxPKE4jlpYy5tc=
X-Received: by 2002:a05:600c:474f:b0:485:3b34:2f62 with SMTP id 5b1f17b1804b1-486feddb659mr230374315e9.14.1774356412943;
        Tue, 24 Mar 2026 05:46:52 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-487116ee514sm58753725e9.13.2026.03.24.05.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 05:46:52 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: bhe@redhat.com
Cc: 21cnbao@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org,
	youngjun.park@lge.com,
	Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] swap_ops and plugable swap back end
Date: Tue, 24 Mar 2026 15:46:45 +0300
Message-ID: <20260324124645.3944104-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aZiFvzlBJiYBUDre@MiWiFi-R3L-srv>
References: <aZiFvzlBJiYBUDre@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F3F281C000A
X-Stat-Signature: it4jq6ch745w4atq5pfp796qn1k5jpsy
X-Rspamd-Server: rspam06
X-HE-Tag: 1774356414-426514
X-HE-Meta: U2FsdGVkX1+v2qZFWTd3/8fBOqmGjeq262CHKfdukagFNprw7eVfNGmxmbrsyslg/gm+8IW+gbEawf/erNmK/ITlloJg4xLvriOR0szB0xWnPUIeOe1avMSQOmayi2Lm3IBJh/POvkt7j0IGIOAZ7VAL+7e1JT/9ky2LWtDZxDwcH9ePoyYtvcfRlqthd6xxUa8/ySVJOyzY4to7EFce1GA1+OKQFsXCtJQFoQKN99rjIpEwh7b2LhecL2LvmOarmygtXVHLek3uL5JgvgJtctQ5lGxN6DEWC2G0NAlpk3lgpex/WQs3wKit8+5kK8tTKKYJjbNi4B+NU1XPRKnsMYJABfH+Q2S4A0oDuDI0C1meZmS+vsqrxlAoyCc1r0Q/zekvB5KAApa+gUQcjqzzTU+s2G6z7mJAaJcZ52ovDtMjLLeI28JrgtS5dkiicJPmLF6Y3lwuxx7lrttzGOV2UkVNJbrT6xQ7wTRbV1Zlik3LSKqg9GednXqu5NaaqketdFXUgqevHrR8rNs6kox5+IGAMyjKZl25oQ8aLjMI1zjH2AO5tjuYh1h/TIDfjMduvGhmA/vsL98omDNZjN5u+podvChtPsaXnmOeagOI0qniGnCHbFMizRsD0I+XoOedk8OEzgy2wbNcDdvulrCLcxiFsPUyk8ZkNDL6zwBq/QZZfIox+sb4Uew54FaSU6gH/ylWqsHv5cekOFECEjpCXFidiqThEr+QogGIngUodWtjljHTPUInPz2MgS4fEZ0EyNnU4D+ndPZhNRSI/KeeIYQekslWi9MAn5yVU7meE1iP75yxealdrOTirStpB/7utYX8ZP0JObLaeafOm0QQ3f1BabLCu9QrnMONVRMpTuKYhLWPqEhKI8jGqu/ORX/EaH4J5jdjSS1X+/Jh3OnXoCfwJN8bYuPisnf2OwlaVmxiz8jl7saP9pmMJbyuk037xFMwjPj55KtjVaCfsEN
 JAYvaeCI
 OeOlwsDtJxBJVU0X782bcLrF09GViv1z5DfkFz61jUy98SnkAqdLvkdlsQqUPvaSwrx1XuR8wklrJKkRyC6ASTFSSUQUGOVOEOMVdW5b3tE73a+Nouu2h89rEpiLGUsz78tR+d5uWU3byCizeSPz3VQHQ5xdSau8uPwg3yqkc0vWcLw9oJmW2t1J/NDoLCRCesOoswkpCONszST3TT3xp4FW3y5FAbYbw8eMNqqLpz2+Ca4vE9PQQhiLlxo5y9YGufpsOWf0tu6f2HD1sGHV11j6/e07/zN2uxubVyMtdT+o3OTqyKXzCPAkqeIa3BNqjNVEQcxds1eVUuVIV13aKZ+0KKVFl9r4K/kWEYvlyNcAMdxr/EquUfe/FX379gJnFJAkJ75ZpLIFDxx+VDGWeHdzdje+rR+JZQiBAnspWJom+9GrY2HOoQzIJAxtKvE2/64+PSErY1x5s4eR9Mqegxx03XBokkl3Npr/0PfQWuiPJ9aj9nEV5Rjl2XKcHsguDMnqC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Baoquan He <bhe@redhat.com>:
> How to handle storing compressed data. e.g. data from zram directly
> write to the swap backend without uncompressing.

This is already implemented here: https://lore.kernel.org/all/20251201094754.4149975-1-senozhatsky@chromium.org/ .
The patch is already in mainline.

-- 
Askar Safin

