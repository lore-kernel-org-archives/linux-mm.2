Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFF8D31A0F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 06:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2A96B0089; Wed, 14 Jan 2026 01:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89A46B008C; Wed, 14 Jan 2026 01:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B69B6B0092; Wed, 14 Jan 2026 01:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88F966B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:05:21 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2697F5891E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:05:21 +0000 (UTC)
X-FDA: 84329532042.30.62996C5
Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id 55E7D1A0004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:05:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iAcRm4jz;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768370719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UuOoBajVj0wkg0g4yo/s1ny3PHf3Yl5+HedHG//0BQQ=;
	b=08oSsGNDN8xi+9VA7O0doym6UfkQVGYGNSw30xb9EpiFTfgNBWMqnZkC0lzL+dnZcQwFKK
	lofkJJkbwtgVTY4nBEY8acO6bzOYE6TrSDZGPVnntpw2YzPLceJWFWMkHiyrT9jdVqNApQ
	uXmDTfsJIij8hnSgeUB3/8xJ50vMyjw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iAcRm4jz;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768370719; a=rsa-sha256;
	cv=none;
	b=sbgYtN2KkZP1ggguS49GpBVDawsqx91tU6Md8WYIGu0M4G6TMAlIt2ETgOp/b+HvPTDjMd
	8AwuqazkX+Vc+odKNeV2H++uyQiAQfAwFxWSn7ad8erK+U8RIJQAlIMHeMFj+eGsrQCBv0
	Z98eruVFAvELkN/FI4DRLwI77/8TDFk=
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-11f1fb91996so78540c88.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768370718; x=1768975518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UuOoBajVj0wkg0g4yo/s1ny3PHf3Yl5+HedHG//0BQQ=;
        b=iAcRm4jza6BiHqazKvw98apnA62KKoCZqA5jrZCRj/KZd1sG7gyJP1rhU4Opp3glKs
         z9+QD80ERfTiZwisu3TQ+h5g4fOWXoEEDy5ryE/FE1X8CvinYMht9dX+LaPkK4Mtdxpc
         cadJIJfggsm1W9WAuU3N0Ddo/X6bvsb89Evn/Nktosw0OFW/k28hJlaUi0HeQV78Zm66
         GJRxg4Ll/a2qpzdBZJkSo4mRcAVB7muNd8nRVxjbZXf/ifeAdu/rEuVuDPpFz9f+7suc
         y81psWo//U5FIYamjy2uRCLVnrulbDBElH78DFVNC/x7nRogpsp+TRgZUyexI2IoTk6l
         eHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768370718; x=1768975518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UuOoBajVj0wkg0g4yo/s1ny3PHf3Yl5+HedHG//0BQQ=;
        b=WAokyBW9LYrpVTWBUqj06uMhC5S39K9rCiI05QhJ5wOQzmjcPppEDjB48UTUuZaOww
         7wsIdheEv70CjWqOVJwKhr/UBdZK2/hL7/vfWil3us8Hw/I5bDKIrugcAx+x1i6jL6xl
         AY+yl7jiVR8rQV8ombB8jEewrFH+ldDgJn7NMjrUw1tyQ9+psdxNEoY1+jgbrEYPuech
         GWfvowvR0/pbOmXbKG8itewU3r8l39arysV9VRS5Kfl1yE/YSWmxeAMPSZ7BbJEjx4n0
         OthovQFmqXk1XoUydaaQFBi4vdrdCNWm4mWlKF/TrSk7TkIFDBbusG+VsUhANkVtMWDd
         Pmnw==
X-Forwarded-Encrypted: i=1; AJvYcCVd2D8gcXB9sE6Ww/vdDWZF13l35Uph+b4jo9MbPzQABS9e8fjKPNPQzGSrVaC2018e54Lbc381gQ==@kvack.org
X-Gm-Message-State: AOJu0YwQ9lvU8Ywuhoce5EQ65uudPzDKQFJ3+Iojc5W8VrEE+wwZNXgA
	Ik+Ukp6turb4ZsOaunwuD3+QpLsQHyq5V0J9Jnlyy226OUvAZZ/VbFAL
X-Gm-Gg: AY/fxX43DYjTePdNEXvdbcS70Y24CHQFT4S7tnj5U8EAHDtNFGnKj/qHndf7+KI6S7c
	XyTJGCr/KLDlcGwqqONxpRsJH7DOAZiAc7shrKZoxtG4ODXQx6H9o+LRD7B1Jd6k0KPzSLVt+5+
	Ou9Z0Lwk0lpJd4Aqa98nxrSpxYbi4vk0Y0kDN1Y2fUtLpw0dFb+uld++9nFe/jqn89YZWO7xK9h
	8RcA6ROOkkAb93oTlv5l4XhRr76XkynXcZwrtNLuPQ8VMW8gZhUKSIUHXFZ/c1FQwh8P5PRLZs0
	jHEOX3XC0U7USiH/Mv1ekkq13qdjjdtuVpKnjqOYoCl8bY9pRVk3aoPbirKOLOFv9QI8z41bzip
	xTQAv6I8AQzfIjtakCBWyAzfJKNHNADQSCFgDjtkDYXcbGQMwJkykGRGkx573TWbmWnS2m0CelM
	C1
X-Received: by 2002:a05:7023:906:b0:11a:4ffb:9825 with SMTP id a92af1059eb24-12336a47f3cmr1905143c88.6.1768370718015;
        Tue, 13 Jan 2026 22:05:18 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f248c239sm24911154c88.9.2026.01.13.22.05.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 22:05:17 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 09/11] Docs/admin-guide/mm/damon/lru_sort: document active_mem_bp parameter
Date: Wed, 14 Jan 2026 14:05:04 +0800
Message-ID: <20260114060504.87119-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152717.70459-10-sj@kernel.org>
References: <20260113152717.70459-10-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ennaags3kueucbnbf7gsw55nitdwampf
X-Rspamd-Queue-Id: 55E7D1A0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768370719-908750
X-HE-Meta: U2FsdGVkX1/i1lfLZd7P1pgkb35e+7iuI9MrAVyI0l2DRm6KNurS7/Ga+/LODqTQ9iz5vpMg8agahqePficl/0mNIqZwcpgo+rnDh42vsLBPSU296B8ZXyHadMflTpWpbm3YmqkBldKypBCc8Z8g9i5nV/FWfTQZQ+T3myslte23jQF1ccFbwF5iOOBLPVa7DvKfl3VYo5s83VsIpxxdqjEqi7XTa1muCzL7z+ZrtU52ZSeY2YI1wyhfO1khDPbQI58KRbI3T6wYarmkEFr1njWXOwVxPRu+2HHx1e70ICLj/Oqy0y+/vzOFn4bjnbf4Ibl8bJ2ceWjl5iTp647ecbKOcsbpl9iMGg9dgT4K9BwVFlUTvz23M3a7AZOYyxeItd9vDa03ttJzVt0VzRlsxL45co89ZMTMCZms02CFuUhtVFr2Ekj9zrqXqlQJ0mRWUeozLq3g9LATeXlydlt6mNExRvk/2Wg14RQE70hTN85uFkOS13WbyuAGRlwOIqgLRqF48AWEkugVOw1tos7oN1IjQjN8wqzaap9myr+HbS5IXPqadb6ZapbP/97WN+JaLFzX9+U4e9ZYD3Dd7qXT9av9XK0Lzs7RhG5OYgVaQbGkrXOnCukuI+mulDtbyLeL7mbHQXMtckFxCALyG27SoTjSbBSlwhhluiDQJY6hH51OGLC+71SiU1PzEZt5wnn57rvIQ9d+Aq29eiQKCqjg4TgVwO87dFIX5zCaEHiSVHXlp4HGQqQy7VF1CqfVSohoNl+V0XbiRsCxZpRQCN+JZ1f40HlMOxL0lbhsDxYNyQLVZVqo2gnWFBKeKACDrkWk0ske/CttlZv9MBy7uSF6BqjOkFFr918wU01cSoljWCtaSp1ADt/BsLRb7gEBvkMTvv3on9fNJlyKi9eAMgSrHEDBiOuEMwQAvWaDTc69mnv3bokbIk9Otpd2qU25lMqTUqsye/7NdnSVGQu01HQ
 6Y1vCCX/
 sk0ORSnbVRZzv04hsRYfzAvrnCRI+PLd4M/bQ/Nssi2U3fGWE8xh/FFC8O3Lmen3wUXWYATjceGIkGm0prhlL6zbkyVaYEpSSZfeQBo9oYHJnI0Zro4eldm6OsTrfAqUftNsleHMKui3YDdaV6YysswFyjczn1U//UdxQRP6moLPA+1B6+gFQ6w3y5nIRcSc8weOeoFamTKRzXYQOvZ0baSzW1X/9FGMa3zK76Su7EZkeDZblyNSicfKf0pTKOoavcN3ML/5dY4exi5xMot4sxtQVVJgr0nUKfj80PFzUn6viR/nftVVyW6hNS2/Mt2MGO1FUh3xYze7VbED0/A29GBji/x4zVeOwWt+OI/564MIx83hDLqdS0h5cxdIaJQ1alFo04VTLbktajN9P3mDKHSvF5MC8EJwguYef8bgN+WoPd+QkOAyWfApHIpkRE3icinwIDnt+eUi50o8d6AB8gIz+A97rWqUpUR5ppuw0f5baAS5cEYvn283+8Nxa+DZ+3fsovGG4d3oWdLTf1oZYUKvN8+hZtXdPv9KgWpgc0wgn4cg30Z8BUq+y2I0Kr4v/GwcBkQGEBVuTHR5yt3HNdaOpdKumLhf6hTwItR4kitxd85TTwxkMB4p06Msl9mK/TaG6/gIKJ6VD87NA1nEAfa7LGEGwk+S2ba1CrISbq6wKEcYTM9srXfDwfBGDZGWlxaoml/Y27BnlVYJpzGG3eaZHN2/glfZ/Yk2r6XIJYXeX8NQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Document a newly added DAMON_LRU_SORT parameter for doing auto-tuning
> aiming an active to inactive memory size ratio.

> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: wang lian <lianux.mm@gmail.com>
--
Best Regards,
wang lian

