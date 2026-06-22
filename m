Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E697ACD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79DB6B0088; Mon, 22 Jun 2026 09:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2ADD6B008A; Mon, 22 Jun 2026 09:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919A66B008C; Mon, 22 Jun 2026 09:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 626616B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:15:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0F9E1A0195
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:15:01 +0000 (UTC)
X-FDA: 84907594002.15.F56B44B
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id D5A3B40005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:14:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IGJil0li;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782134099;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KefHasFuO8oytHQlky2XzelXz+LgqAyeUKiwcFqk/0=;
	b=CEKa1SCCVPSd0aUAlmGsH9u3pH+0oYfw/m2Bg5ClqX7G2gob8+exZCbJDkyeBIWJ17oZwz
	kP2FE2HeXxDzNzWKAvvq+jtP7QHjOPOxuYjybALzcvFw2YhD6iHaPkldMPin7fhkDIxhWH
	GIXyRNqhufPvDB6CIOQJuC/Y6oYNk1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782134099;
	b=zWs+cm1OklBDs565CRlgNQrnrtE64QWz9HhGvC2q2AkvHUlmxeBZa+fsKRfeOx8Np3HwMc
	rP1sY7Yh4PZRNpXng3GqOHvuAqwNJ51BBDuRKRvcr0ErC6SXpoaKokB/9cvBDSU9bapZoA
	lCrijndCTS4UrCDEcT69WQx6WJSk3FE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IGJil0li;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8454160043aso3426909b3a.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782134098; x=1782738898; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KefHasFuO8oytHQlky2XzelXz+LgqAyeUKiwcFqk/0=;
        b=IGJil0liPm4NdsuyFw8WjtP8H1Lx/2+/THi4kPn73PBewp7LweTtTVVdx+dWVN3QsR
         CZe7kkg3wPLXV/3w0fwbno37blF+wJ+ivnl2BxM7mKq0wq80QuZBqoIiK6rxgIS0fUiS
         Ym8lLE0wuDwhCEeRAZUdUrk3ALjUmZt6LVqdVA4gEh0nHdhL8F77J+XspFhmIb3oGD+y
         4zA68qexZrcrzYvHN42Ms3o+Ov0MSkANXvqdBi9ncRMe2Hs7HFUgQyU1hEU4GKJlUb1e
         ZvoOL14L9qWudnPc+Vpvh44QVGXTq1kEj+SGOEg+P+Rxxee7eNbVJe5O+tAd2exH5wdl
         C6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782134098; x=1782738898;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3KefHasFuO8oytHQlky2XzelXz+LgqAyeUKiwcFqk/0=;
        b=dCsYNiJeADSQudjY1H7PP8lrzq2L9LYKQsYtDGCHf2H1bSwCgepyC2KA7vjqPAPO3z
         whvgUSBdmkfqD2eW2LHayrF+9l4iyHIn/Crfm+LgsQ6mqD7I1G+r2t5e+RrlVVe+lEzU
         oZE/LrCEyiLCZS65LdMQWN4UpUbvLGwZ5NXKmsGpeW8MMHneaVz1YeNKnRk8SySJVhvB
         cMN4Bju9/JQdT6QzyZ8A4iz/kCS3k/rdpHXw8SMv6ijP7dzNYBHqhae7I7/BGkFRz9Iw
         GHIAHCuZMKSQqz+PG6i+/BdZMxZ9YTH6+YLJYVagIrEMWiWi2fF3rzb4diu1f6aeXgEH
         +kLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Usnhs/z9xAhtu6SR6WBfqDQzUCTFVtyl4+SOykBzTcAzY9kxTS2bF+HU8zoAv3G42LxexUd3h+g==@kvack.org
X-Gm-Message-State: AOJu0YzfVbkUwM+jAudX8uOY2TmL8HjzJEq9OEU4CmpNIPA410g71E7m
	S7HQ3X2M42Vq3k3SLH35li9K/1B03h39J1hwkIWlIwFNtM+539d7ccL8
X-Gm-Gg: AfdE7ckhEvIo+LoQChWYlwAwyvYKCcEjLMsVJczpzF++6elwrt0gY3x0xcFXVvwp5Zt
	gYu65MBCH+KRqqd/38SC03HqPAymxCmLIksk8R+myuBGHvW5xEqi2qvUickBdRwehqWXVV4i9mU
	/4MWZCfDQk902FgM2F708xUoFRFkLjIvirmejwkj4WA590zJPC8TfjgCXKWLFWVvMbM2ByUCezA
	1QT51/uk4Zkkn6Y0AV0512BaOu8aUydZDYoFMdso4ImfC5w96h7P0SHnOrn97tH0FOKd4Aavd34
	1S+n0Mc1qLD7t4Oll+3NRa+vzdcXHOZwmzi/8V+hzQesD5j3ZPknX5NXblzN4OieOzPJyjcaS2u
	acwCYIq957lNHDtGBU1HYp+gPrgD7XQ2fXr8fHCre07iWqjPJw9ghiF9L30DssBm0Op4uXhth/5
	8q6etVvQBX73g=
X-Received: by 2002:a05:6a00:2e25:b0:842:5a8d:303a with SMTP id d2e1a72fcca58-845508a232fmr15109349b3a.37.1782134098511;
        Mon, 22 Jun 2026 06:14:58 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564d8dddbsm7662685b3a.19.2026.06.22.06.14.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2026 06:14:58 -0700 (PDT)
Date: Mon, 22 Jun 2026 13:14:52 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>, lance.yang@linux.dev
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
	harry@kernel.org, jannh@google.com, sj@kernel.org, ziy@nvidia.com,
	balbirs@nvidia.com, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260622131452.ox6ciole35ojmyd4@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622130651.23359-1-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: zopeq189kx99qmatwxrcx8drrzt51ge6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D5A3B40005
X-HE-Tag: 1782134099-90223
X-HE-Meta: U2FsdGVkX1+4fSVNjh2h+ZJLFNVFVS2ah5hVhIrJQFb3aPuIuvSvHXW60s9Po5sPfRqwzD62gdXnIgqZESH/Nd96yksR4FKdhe7NFdUlNhQPjVODvX9cTsaIfXq2sMqgP2mcl5f5+HQ+/CQcShDdSd1bGbgE0ag+qnCF1Pe40qjABs10ZYJfRS7XQtXszV4nLOvpxKXs9dkH41NW/G4L0S6FruO5ajMZKaGJv3LlCg93C+taHkeJ/C3Q2t2bP+o/2QkfHZlpqdYhSE4HxdY5uy5DukI90VIKiEZ7QAoa3XfHf+U68ekbqvewXB9gkzJic7Q1gKkiCF+HORPerx58PTVfLJYcYGISYEdjYkKOPV+ecMFuEbYQaGKrBMJz9feeekF6UOT6n3BVwqn42OYkTbVGwt3oyvTOCusHgrF+1IvU6KoZ13fsAJ0U9ls5D3D1AHfJm18C43RbMFMX2Tg4f75wGDfDBjzLXLs2VVxBK/UDutbhPWNpVsUMmKJ4xynJS6+A2gX/1YT9iRD+bTqIWpbMAGea3LXxgRua8ceePfVFjbGjcONdIcSW++LQNAYcs8JcMki8YJy5qtWIOH9elr3BavuLon90DZjy2Doje0BUPOsuD00w9OwwONmc2D/pXz84a8z2hHZi8UL9uuyBBk1OTN2/YKb9MfnsHwicM9vD54/+1oY8mX0/P6Y9ZIHUvt71xe5eIhqc36b5D9PAUqVe5Z0KA/vgJo+HAYjEhl1xPdnUyuMSDi0OPXgZSlI/o8XAs3CbdgEwpRDH+0qYrY7NF/NOfAmm6Mfsm4WoZrynuFx+HLJlBt2W9oS/4VKbZO4KHUCE2TWNS4wQwHzCIbntsxAgAj5rhvxMy0rWM3L+dWC5v+6pXXNUb80ILR8EZPNxPaOGu//3LHEPRR8Os+EnMUcxgRUkPUy3E7zxsOX9lMFdoRFupEYM9RbWDtxcwj3GY+O2oYluCTdmUm1
 /C9xyFV6
 igcw3eA/SZaOJRLAaDcs7AAsXDIfBJA1H0JVz4wWNgh7QpuJPAs8I10DWXaH1LO5Dv1zD3x6GCfjLWmTMWNP2otfvIIkfRig70R0SSmgnwxkZljVFzC5Hn8ufBWSPWm17lU4C0305sQjXgC4DqH9nGqHT0rNklZPLhZ3Q3T8qBlATLa3jTNm6Mt5x5u7cc0kGlCosvMfKbLOp2rhhmhSKhlsB2cjCHXwJ3SlPVNVl86Y7bYFF5K0D+VmjVOYSpSEr8fDjFsmgesx0lylMa22NfASRAjV/mLKcV3mJwZuG7GekfyRhsGTlJNBQpsCvwJeB+sEgE0R1YB4F1Gl9T5/oPYd3WzpyW8taZVKsfTfeJL5bPI6pZZY78Eo4Iz6ZqJ7LF2kz0peruoHc6xfoVVVkJnA8xkABJyPseHEM5FU1ZUZJSqbjh5Lso9YfzjkkQyeiWLx3KEZCB72oshNbvRcEwU8OxND3ksXoL1BSZlSm/uH5kbTNnS0pFCjwHdnSsKiEbY9kbxsY5FDSXOmSHjCrq3vtpVbT40M9F3cLknp28qBOSjq3u0yjHz8eBThv9LsKHoJ/x+3uP/JYpJ6MWqmSuQksObo7zFIJJXpr8RFQchjlAbV79Eu+e6fqE87RweGBdGMNzl5c4qdbSFlyrxfZLG1zdeHBvqyOIJquZ0jNbJ7DCGWu5NGmO/nENkshXVO6E1vx6nG7S9N68gmIF0e0dZm5UdLlZXDEnASu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oops, miss the v3 tag.

Also add Lance who gave a lot feedback.

-- 
Wei Yang
Help you, Help me

