Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732D0C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A088A6B00DB; Tue,  4 Aug 2026 10:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0376B00E1; Tue,  4 Aug 2026 10:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5906B00E2; Tue,  4 Aug 2026 10:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 672106B00DB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:03:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E68471201B4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:03:51 +0000 (UTC)
X-FDA: 85063755462.18.DDB3913
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1B59C000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:03:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=nvgrDBBu;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785852230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQLAwY3UYTrW1CuxnS039wimawpHMLMZBSc//OfzCPs=;
	b=a5ztlzOA2RqJsH80BtRtRkVu/l8+WaEJvVL8nHyTDzximu5qSFQvxDc5IwKRdze1y/Ft8N
	y8OkOjh7Qcs0BcZJzL766QH699HFhfFXLLcqcYvK393vpHBNDoQ3VYccWqWHSUiFk3gNc3
	yZEFr9FRS6TagkfdNT40sNrsX+MqM6U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=nvgrDBBu;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785852230;
	b=ll2fX0LwuwfiZzlovc5VyikiEsVai3bPdR5kYg39Jsqn8fPerz3b1zSzmaW1YljTuICPuo
	B4ZKMcKRwN9tepT913mDbZZPyKsYuIcB513xKQNictchQhr5F4HW/8r4cg8L0CtBS9d9my
	afKzFI3PQpzTd31KEx6v2NXwlkwe9ZM=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c04bf4711so40653261cf.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785852228; x=1786457028; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CQLAwY3UYTrW1CuxnS039wimawpHMLMZBSc//OfzCPs=;
        b=nvgrDBBugLbV3bHD1E7gEGm+Sm0a4T+FKjqUd7fJtNiVVwBOKZwunte0XPD1FpEdWI
         3JIOG5eJp5+WuPEgVrRezgb7wVCugFOkAgH2zAguEFyE7pNo5o6jh0CxnZw4P9+3O87m
         q+SvxKPd1E7yjborCvZPNs2mSfO9PQ3U6HziXD6jTG0EWcjz08NlgHmH1OoDUY8M9Lbb
         hwdOYUqZwsPGeEK22k0l6MHQ1c4ebGvLe3ZnqxZ2X/6ivdpLPIZdGbxE3Mpud0LchPL+
         3/vx8nA6DVdvzDsh9AKqz9C52bCwclCg5ZrUgHuTiab9YVvlzdnCwUEjrW5mfHIvwuR3
         yQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785852228; x=1786457028;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CQLAwY3UYTrW1CuxnS039wimawpHMLMZBSc//OfzCPs=;
        b=VrzimVga+Q8yydqRDkWn8ZwzA1RVd9+ZEompUF5RyevPR98W4Qc2yFakktCOfrohPa
         PegM/O0kjl98VvwOXXK4zMPMGxzdjzavfDGbx38SdahEMxIzZixCQ0nTaXOvv7GUjIH9
         7opa4xg/mbEGmUIgxtCDcnkgnNrN9h3sCZ7EBK86tWegY5NegsvY/vvrANdYmtKfPNPT
         8VfhnawW0rjrFS/RnISjRknXymoB2YjzIB1GI73dzV11HRfc4L3ODvXUttndPZkDmwhy
         e42Nr4+mOI+lLotkQH4BF5MEaBCes1VKjMsIw+DZ8HXP7pHXoNgHQnn4Ym7xWM7jt97I
         JAXg==
X-Forwarded-Encrypted: i=1; AHgh+RrBHwNoKmlNlhunw9i6dJLvfeTdlgvJ1+qedZXFVxNcoei2PicOgd/bhMq433zVOYJxoqmwwyjv0w==@kvack.org
X-Gm-Message-State: AOJu0Ywaej8c5cuqghGCe2cOTtWd5RKjJ7ssiyxNOPpOnd8CTeqdyboz
	ENrz8Y+UekUZXQwqJXoMrFpx6StROxHPSlCGzrt3cDriGReGow3Zbhg1+0eCuCdRel0=
X-Gm-Gg: AR+sD10MA7NRP+JsLaZvf6j3WZpGRD7rPggJ8GO8svFaEozBaxY8hyozWLHsF8vbVAl
	FkxMArVuSlhjROPo/OcLfG2y8kVi4MjHqts2CMHHp21tlXlVVsno+aLjiP1AHpJhWe3YXbwT992
	PUiNTxS0iNDY7nIU4na0gvFvJAa2KawrpArz2JvZp2RtdG0FPbySk+3wESzisswP+50hJEGFevO
	Wsja5EMv/VFCMYFFnDZ3z0bWx6MqW5Tk746eVSisHV8pfkTFMbUBrFc16+RVQlxzM7sIVVKohjD
	xdvaNZO6pX0ZRaq1Ls051ms69Dy6Au8i4DPzoVvAfSO13xhhQeKa2jwhODYgrSNbJrYQZPyE9qj
	FusTC2n0wncIZkFY0fd3EHx+BoU0S/e66i5mEDferrfOdkzKfXUH4P/KsRM6FwK3+f9PUEHINyk
	Oe/5m4lUN8+5LgGsfGgLT2Zj/FmVRZiwwwTUmoq9HiC8sjdVyEEkKA/RLszmM=
X-Received: by 2002:a05:622a:5916:b0:517:9f43:4732 with SMTP id d75a77b69052e-52b566952admr275629741cf.11.1785852228405;
        Tue, 04 Aug 2026 07:03:48 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4e81fc41sm82193021cf.10.2026.08.04.07.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:03:46 -0700 (PDT)
Date: Tue, 4 Aug 2026 10:03:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, willy@infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
Message-ID: <anHxPU17Ui4MTcCb@cmpxchg.org>
References: <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
 <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org>
 <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org>
 <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
 <anE27CtvCFx7sAuO@cmpxchg.org>
 <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
X-Rspamd-Queue-Id: B1B59C000F
X-Stat-Signature: tycofoigxu7qwqhgdbam41x7pf3cn1b3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785852229-684366
X-HE-Meta: U2FsdGVkX180Lk8C/hgLa20WahycBEX9T78SNOwnNtGB5LUVo2eakHBZyKsjOluCgCdRO+JX6yi+iTzTmDrtHGq3hZPAtKMe7WJ+HDvrjER1FndLfW12YZvwa1N9s+pTRNZjt9s61n6YoerYpZ/VOBDdDwco8BZANTCxsqX+rQSng5bb08tKuHgS/6US9ccypIMC/VLVlsDRspwQtX2htkOgE5MUDlx4YcOCD9dd6VujQUbre9QFszOqrKufhAVLL/bMKIcbrpmG3TylaQl8S34fycbqdE1px9VQLH4BfijMLeMERV4Y22i57xhRl1RDsNVtjEJDWyYF3j9QQDEB1CxVmndZIWRCFMVyFca9cbFF35GnvFIEyIkO2eRpwsLtddZxHjhLAo9P83xOqcUnrvU8o7CGR7Bb9BqiVVVt+bGRhTVw7wQq0nbtgbtwCTVDahh065AUeSEZXBr4z0VJFOGNqj66CJ+RnVyPgC0sRNsbfNr3wDBWRLCfZGFB3uaVbEiIHRmnLmhrujB9RMzZ4zD0/MbiZvL/GyboCs3usNaISmrnSrhvW7uBMo055b8pGYpps7510eFSlPk65S0zQbfcsCy/O0cOEGb450ns7BO/D4VERQB//Cq8lcGC7mZ61EJR9EGael5/aHJJMFvNT87kW2AeukwZUphUMDdaZGZe74ttsTi9+6cTssw3vkSjYuT7AQmogQe3jYlNnm1qmQHPzd05cgv5YyYw+xoXVeJiZJ5X5Ed+DDzd7EZ6hy6ReWLq8PE6KA9H9ZWRrLjaT01iz8mu5EZadEP44otytMSvmUYVVkmWqx1FcXqmVCYuONgpZU1OHt/U48Ar/xrNLs65F3VB09H39rwkToGpVeNwf0TEw4E8rVrs6wMJw9P83RubdncdisaA/bFsAFo86y7y/XzN5xJ39PMilIHfhkCBZ+0BzDDC11pe2Je1PT8OnueCB63SInDYuj4pvyh
 i/M53L6i
 SDqE921s+TpDGWvBNO97McKd08rE0TwQmZusqh4FS0/kuMnp5yObAW960vR10bUnni45LKCXWmJcR8Fi6w2M5A7qXeOQApfCCCkZS1RlC6SV5CoD5KB152XcZoMiRajLxYkKQOfaPqNEfVE2xsm1vX9q2XlTSzmm65TSNg8zkOesm8kapkPUWSo3wQ/7N/bbYLJ/h+iWiu9BoJTtFlmRRGi0+0cN8lQUpIdR6aZEkdMyuhvODhBFm8fYwR6jN3aOSg9JUuGGsggjXMuXjlA4X/LS1+fKyMOwDEuLTDXGk0m8736dAVMmUfFjwtDODsO7SrGWvydLnE3FyGLVyNlip3xqtqhiqnqckpWQH/WvUc3mzXn4TPPRwVgrxgjWEg64SVp+iCR+kfOpLArXxMtnw8usjypkW6MrkITc9aaTkYhk3jExVspsE4wnT5sPIpG2f1c6K+wBLYVBGdhJne+/neBv/K28eptrFyfuG8wjxeB3zvWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 10:03:14AM +0800, Barry Song wrote:
> On Tue, Aug 4, 2026 at 8:48 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> [...]
> > >
> > > #define LARGE_FOLIO_ZERO_SCAN_MIN_SIZE SZ_2M
> > >
> > > if (folio_size(folio) >= LARGE_FOLIO_ZERO_SCAN_MIN_SIZE)
> > >      deferred_split_folio(folio, false);
> > >
> > > If, someday, people find that 1 MiB also helps, they can provide
> > > data to support it.
> >
> > I am very confused. Did you not see my proposal above?
> >
> > Why not this?
> 
> Hi Johannes,
> 
> For arm64, if the base page size is 64KB, a PMD would be 512MB,
> and PMD-1 would be 256MB. Usama mentioned 2MB, which is just
> order-5, not PMD-1 on arm64.
> 
> BTW, I assume khugepaged_max_ptes_none is intended for collapse,
> not splitting. I am a bit concerned that reusing it for this
> purpose would be quite disruptive.

It already is:

static bool thp_underused(struct folio *folio)
{
	int num_zero_pages = 0, num_filled_pages = 0;
	int i;

	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
		return false;

	if (folio_contain_hwpoisoned_page(folio))
		return false;

	for (i = 0; i < folio_nr_pages(folio); i++) {
		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
			if (++num_zero_pages > khugepaged_max_ptes_none)
				return true;
		} else {
			/*
			 * Another path for early exit once the number
			 * of non-zero filled pages exceeds threshold.
			 */
			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
				return false;
		}
	}
	return false;
}

That's ABI and setups are relying on it.

All I'm proposing is to only queue pages that the shrinker would
actually split under currently existing rules. That's a mostly
transparent optimization, not a new policy.

No new sysctls. No new policy hardcoded in kernel code. Default
behavior remains unchanged.

