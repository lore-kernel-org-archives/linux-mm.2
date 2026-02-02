Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A1AAE7FDEE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 21:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5EB6B0088; Mon,  2 Feb 2026 16:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CF76B0089; Mon,  2 Feb 2026 16:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C376B008A; Mon,  2 Feb 2026 16:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9610D6B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:37:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63D3389650
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:37:11 +0000 (UTC)
X-FDA: 84400827462.09.1D8175F
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8A04680005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:37:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mWG2j6r0;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770068229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8laAOVGcrjt3grREBpdlanB8iPI5gP36V5MB+/CpDTw=;
	b=CMtaaXFjH8cJ/a/4ncyJfvt42KrLvJUcXZZrJNKRnovcNRWS6faglcxez4FDJuBy2ISj9K
	8fKQa9NQshCWRhw8RwAmPMxd0BFJeVOKCDkmij6Taiw75WYhRoshQn0mD8lkLAuTqIRHXB
	uIKO8XPFmghvfBgutSpnL5ZFfwtUCCs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mWG2j6r0;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770068229; a=rsa-sha256;
	cv=none;
	b=X7p+clL9WueD91IUhYDaXqKdaeMqhNr0rBbgldmbsurdM36giu7X1L3ShWxk7Dn6ersX9a
	TronGFwVJ/j4MusAvE6eWX/t/JeKlrexdWfOkXMNagndsL5b4yfgvpaK1j8Fn84hYq4oiv
	YUucK4i9R07oY2Khd0T/zgLaJjlWbGw=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8c7146b0854so558812085a.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 13:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770068228; x=1770673028; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8laAOVGcrjt3grREBpdlanB8iPI5gP36V5MB+/CpDTw=;
        b=mWG2j6r0EZL0gwQBCPizG7VwhUvDU4le3AjWCbQATfoaYRFv7GIKvM9bTyD5WXzyUm
         8OhxhhcUEpPVEgMAYJa576PpJU/UMdSev3M8VwN2d4Iy/4csjqlau/3cFhq1xMZaVVzA
         qvbWIjTzGsAC94Z34dbqU5u1jqlJZT+fmFIpDP6bVDutUYTpaHVGPt+PTT71YdHszLlk
         WElx7MhG27EVJED6EVqAggxABl6O+h1Fnyf6LBeo8UVVz4X6gRdfkLYsfWvzUkB33IA1
         KEhp3BW2Ms60NTRzYjb1Cq1wvLwYv3XJmo+ZAmTkBhSdjeRvfib/grnzvKAU/5wK8ZY8
         4grw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770068228; x=1770673028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8laAOVGcrjt3grREBpdlanB8iPI5gP36V5MB+/CpDTw=;
        b=lHpvPwnrD9N3Lr4Ojholjx5lVlStYOAJ3TykQnnDg341o7CDc/rtt+zaxwTaiUaY39
         ZsNr3GNgMWzeZ2nqRWH2siYTxBQudXEY7uliEya3SK6uidF9VyIQT+uWEusF6zi+VQTE
         CC5HPAVWy6lrPi9fkOtU39y37skHWerdzHJD+YDoC7tZssurYZn8Hhnin6UcR0JsRWXJ
         Ukk5G+zzwZMFJloyoWPk6IOsoe+wGCvT7IFhIwLC619wk21B/lnn/Zws6tKx3yWqZ6Uq
         /ErBkIpucD4yJrYQUfUddVgt3ZIG6/DWSjMxyWX4g31oEXPYl+3px265eUt/QO8RpiOQ
         7LvQ==
X-Gm-Message-State: AOJu0YybqipjXfPTN34jCxgQVy58JX4u4KfXSVebZaZtuj1X4Fllw7zv
	jaD4oW0zyaak2X3M4q4NGPp7dgfrHmLMfk2e5xWbTZTgk8QhHDxTVveER0/TNtBZQKM=
X-Gm-Gg: AZuq6aKwxlldtDmIGMV/zTSUJjgcsDePEOpyq0pfjA4U+FKV6xQRCxgAefr7urMiSed
	H3cZzOa6iSmPy5n4SOiC/pMuS4qxXftK+IgIoJI+K/P26+lOnew6MuUfve5k6AoXkh2JFQfSzFJ
	fiEq6h4w/fx1/ojL76+CXyiwOKeHuk/eRMNoWUO/fqAvOwiICstuSNpvOcuRvaudJhIZ/QSebMr
	z6v0DtoswTnARMHSBHIyuuFbqxEm9+yFw8J0alPVShRxiyCXHoCPwBBACeE0nNAoJ4ldwKHz8xZ
	pzAAvnwyfEQKZiKLlO/RYLmUYJIdg++NVX04OrLFsGaTAugw30lEiqa4E2aE29wG09dWmdTbIVU
	zrvKjCkKrnVirbswxza7lXDOXsAN2/+TyqFGWRfRHwQR/InoF9jf3ltPI90KwcVHlOOPKfY9QKP
	X7WRieH0HYdhYXZBTuePMaHAXF4Hf4V6K1KdO7tbvAPh0e+X1uaO4rcuGn03b3Q5qE4e6Vcw==
X-Received: by 2002:a05:620a:46a6:b0:8c6:e22b:25f7 with SMTP id af79cd13be357-8c9eb1fc204mr1562950785a.18.1770068228565;
        Mon, 02 Feb 2026 13:37:08 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d61c6fsm1317392985a.47.2026.02.02.13.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 13:37:08 -0800 (PST)
Date: Mon, 2 Feb 2026 16:37:05 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed()
 with online_type arg
Message-ID: <aYEZAUJMLWvaug50@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-3-gourry@gourry.net>
 <20260202172524.00000c6d@huawei.com>
 <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
 <20260202184609.00004a02@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202184609.00004a02@huawei.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A04680005
X-Stat-Signature: uzoi6aqytq4mgdzgkkeh5rxqquimbjx4
X-Rspam-User: 
X-HE-Tag: 1770068229-5762
X-HE-Meta: U2FsdGVkX1/n9iKzLKNh08kSbpbyc/Mb2saIKEzc3sY2gGKcwhK6L7+olzuH4uLyqNeCILqe2XiCAQzC2dE+WCSwhxvVUUJAzNXY9kxapShzqTeVCRNP3sKUfINDXGhIbCOyo5oiVh1a2NNRWt342WhkwsIvy04Z5E2vTzAPgkHdrnuC/bR2s+XWevt4BI7PcWDNh9A0ATNleBx/6k0fg/xM0NYxrBfufrf2L7jA22o4mVFV+vCEkzombWCPt1X9l/xAlpVT7iN7WRw+quKSu0U0lKolKt1HRsybzQxOjptQMMtmVqkj7lkmSuJusCMSzdH1XEdioQ4iBtp+S4tj2La44VYD1fVX+18BNwgOTUvBULUqQbDC9xKZnqA1PtTD5JqEvm9F/cTkFTNRXqnrssdsRBU4Wz524Qdg7hFyXmtwkBSI03ZQBesh1gFUBFNdNuaJVpyXZgBMBZfhe6Oc0eGCh95mMif1Kez3Est1mbU9ckxZBveAMUd5rxamWK9HauKvJ6vRuPj58e92jC86Gvk+BU5Ys5vba7UF7r2QxquClKnEZHIBXwAQdrbVeQzLDVmb4YQlBFpB64KhYd85Y4f6jxm44XJniTkedxgxbfbVd62CpwTB0iGH7FEitwB1poub1uUu6mnNwV9/KQ9qi7PtzdwIrnN5sNIkajvW+K2qGZA7MDlMGmo++rogde7K6q/8oBUurqg+kOH11v/QIpOgz7MXFsY8bFNBrD+ZXOiezug8dE5S90JHwU+p0FRkIvIjPxCaCcebX3Uo0rfE5bL+FUGe2HYvjJ+09lKh+DuXxlyCr0w4Aoq+upuGawEX8CbzaJGfCs3+grAww9dddl2L17YAqF2tCyy7r9/qcK5yQNwd1fa3Hiv6y5je4r+7GTXZm87TZLfwIsOzELrGlivVL4TnintpMV3lhiZ9Phg+UxUmxHqu3JuLQp85aNWs43/WFnbnfupKIKB8HA7
 k7PYTXMi
 RfwUHx9ZUsFICH3unqX6KJFp/RulFOK0C9mjwi0n5QgENnz6q3bOXSnSTH3XZhEE5echZHimb3uclRxiKJHzBDuIOqSHXK+2Rb1UESDBkwgC2eKOgYy42PKXRBF9WH++e1rAjMsCLnlvFuNcVYFg56MeIy1Xiy9GO1MvRf0HeBl65yaHOZG81u0Jro8pGFGJvaDmUdPwk+vNJ1g2YLybJZXwKKrafRup2FVl02pTz+8o2yyXa7Iryf3AAVFjXILTfo1Sc6Z+knJr1oOw1PCSUmLvUhf4A8lXMdEiE2piDq/TBO8y44OY0WgDVLcinj8jmiQHDV+pEJ52ukTDJWdV9LhT8y9qzXzuUa2ldzrvgOylNb00rRCmd4WUVQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 06:46:09PM +0000, Jonathan Cameron wrote:
> > 
> > I can add a cleanup-patch prior to use the enum, but i don't think this
> > actually enables the compiler to do anything new at the moment?
> 
> Good point. More coffee needed (or sleep)
> 
> It lets sparse do some checking, but sadly only for wrong enum assignment.
> (Gcc has -Wenum-conversion as well which I think is effectively the same)
> I.e. you can't assign a value from a different enum without casting.
> 
> It can't do anything if people just pass in an out of range int.
> 

Which, after looking a bit... mm/memory_hotplug.c does this quite a bit
internally - except it uses a uint8_t

Example:

static int try_offline_memory_block(struct memory_block *mem, void *arg)
{
        uint8_t online_type = MMOP_ONLINE_KERNEL;
        uint8_t **online_types = arg;
	... snip ...
}

int offline_and_remove_memory(u64 start, u64 size)
{
        uint8_t *online_types, *tmp;
	... snip ...
        online_types = kmalloc_array(mb_count, sizeof(*online_types),
                                     GFP_KERNEL);
}

So that's fun.

I'm not sure it's worth the churn here, but happy to do it if there are
strong opinions.

---

David do you have thoughts here?

~Gregory

