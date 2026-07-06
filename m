Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A46D6C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 00:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4FE6B009E; Sun,  5 Jul 2026 20:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595CC6B009F; Sun,  5 Jul 2026 20:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485066B00A0; Sun,  5 Jul 2026 20:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5366B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:19:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09EC61C1787
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:19:09 +0000 (UTC)
X-FDA: 84956442018.13.244465B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F60414000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:19:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FmtiR9bO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783297147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8L6ft2AOg2RjpM2tYUbetITvDdQkbq3wLtnJ5t5R/wE=;
	b=cheElJbmfKsK5oblOEvNzKj3h/dkZRyn/0jUWDD0ThfpASsKF4xES3b9YmT6fwdFszT6J2
	AGjtL0l5JbgEoT5IkwL9uwNUhNf9F5GjDmVLXP6jqKLAXsYDJYDJQk0xnSNXTzeXFP3PX8
	fjYUDLmtuL+TAkLcD3Vo3aLnjHLqoZk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FmtiR9bO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783297147;
	b=B+PFvo3JuTmCMIFwFSW43cmNpPX9eLCYr4HwZhoE4DbDEPU9V4wmZ94Pm43O+DzEaX6Ygh
	KPSqmz1tiAq0IEX3Tg6+DaOhsFZRw6gRZ8upZnNMIfj+/haNbAE8jqYqS//m5GYlo5M0hw
	8jESQpjgJb5O4DBSPhSyIXGwEegVtqk=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cad4170e8eso27976065ad.3
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 17:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783297146; x=1783901946; darn=kvack.org;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8L6ft2AOg2RjpM2tYUbetITvDdQkbq3wLtnJ5t5R/wE=;
        b=FmtiR9bOgza47ceoZipSo0lnquZikbqkF40fAOhJSA0FN9ZV/jfMN6SRME/v5t2BGh
         WTv5J+5rZr2aP6tBNY4oijQcvTqZ7yE95RR1mAaG2iYdtv4BJxEmqvXovp6jw0od+psy
         WYEnSxedtUg8d9MGaQfzrSvXyT1BcM6gA0c1q5A8d0aAMwG9iAlnzNTjCtj+XpELtiVg
         /uaTIyLmtbuONxy+RaUepE1T3PRTigry/jbYvpjKlTTIv56g00iulotzEIOLq42zlQa/
         1NXKyEntUQAyqQbjiiEU96QyGQnUOJP+fSF7ja/yrMK5RLRQGPrsDCJrNuquskEZ0/8M
         uJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783297146; x=1783901946;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8L6ft2AOg2RjpM2tYUbetITvDdQkbq3wLtnJ5t5R/wE=;
        b=ECVJfCMZoX9CiAW//0WIOsdXAtrFFUGFKzwX/sTUOYKk7hp+jTNNlZIunjxRK133zB
         wm9TYiWEIxDSjNKYBqh1zP+8i3CsS5tgcIB6vRWbirDbW7m8fx6/pQuTc+LTWlntsMEY
         SR6EDgOUwOhSx10pQDYIdpbumRkwqbBYoE1L7oK/O+BsPc+zmLIDNghAu02U+WNBDWRg
         VGEAnqsqh1oWZO1yus1g6ZHMzDdn/zySBbASI7R4/6AFWgyqjh79VhA6Yhf0oek1IOb7
         J0MpqMg5XWEe/NPyahfckK2ar8uNrnwKu58Lm04r4RHe7/cW1BD4pqkAm01o+BT+eg0J
         EpEw==
X-Forwarded-Encrypted: i=1; AHgh+Rp4hgGCrgkJbcrcEwacryP2VDFFO3WIvsMkzeizfIO0qMRjJGCB91vwcyowh/LmkegCAuabJRnQqQ==@kvack.org
X-Gm-Message-State: AOJu0YwjC36CCs/T1tqhhV6U+uMoy+bsl4ymzbNnb6grmnuUaUfHNlMs
	rwDVkhaUt9JRTNDEDZKe5B0F87xNIYiH8MlDg70RVn+mLBP39T3mTmRI
X-Gm-Gg: AfdE7cm9Fkenz2M0/mPyzbsEJgAxyImXWp6f5g9SuVsokwOdJdD0MoVbw1IHvUWaMbI
	lxtRzb9vrvVHRAGLJ6S0ZzH6Oknc1AE4dKf4AzXPtaQ5CBFmXRuFJ+yVRlu6e0MIA6nfkmM31GR
	HVKxdcWv1NgqatDG/u0xfVe25ERx5+EEHM1iZ/KWHgT5V4PG3hz6YBhogod77act8zGtJIeiU0a
	WFPqqpiHzNzH83RN0GQCXOCkQWCn4ZRYWGqFerADRRO6RGKpwKd4foAWiMcw53/HuWf1GVK6Zcs
	EF+xJFy0M5SgYn2F1LJjHe8hljOVz2PwDzssCjRjwuZqoJoE+9qxyAGwl82bkgTquH4WG0jTWz1
	TuCbIMCtgkINRnEmUdVPHy1cSdV1WeaJENQD1P587nzAxsPKf+Apy6eBWgyd2jBAzo60vBt9zQ4
	jo79hfWTGI9kIRB+BtSs01ecEUIPBV2VRfV39UKDCfpzCedEBkAaYf8RVo+qPr/LAba/Wb6TbyB
	bugt7dAaf1rHxouu2E9YfGLRpujf/bDDQ==
X-Received: by 2002:a17:902:d508:b0:2c9:abe1:c352 with SMTP id d9443c01a7336-2cbb9e36f68mr76138015ad.13.1783297146144;
        Sun, 05 Jul 2026 17:19:06 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad77651c2sm39542415ad.49.2026.07.05.17.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 17:19:05 -0700 (PDT)
Date: Mon, 06 Jul 2026 09:19:02 +0900
Message-ID: <m2se5xt1ft.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: add sysctl_max_map_count() check for do_mmap()
In-Reply-To: <20260705151512.5edabd9bb5d11cb6f1c6309f@linux-foundation.org>
References: <20260702012830.667205-1-thehajime@gmail.com>
	<20260705151512.5edabd9bb5d11cb6f1c6309f@linux-foundation.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F60414000A
X-Stat-Signature: prc3k9sy885gmcdz8uzwfjgj4mikc9ce
X-HE-Tag: 1783297147-421895
X-HE-Meta: U2FsdGVkX18c7mCmpGFY7m58Zdrg13lvRgaU6jnERqwbOOx6sELbzZd1vmXYvexK9xKd8Y+JM4sF/3f0b7XT2lEbxnsoVhaNhoQv5PT/vE+r3L6jZzk3wU0XKFe1ejnB7ZbxbFRuggkQ3DstxZKyHdPObkWjTNeE3vMHcF+VhnIoG4itGnHjz95atYin31XVLD4g/K5RJkFjSDeKyjMtYeybh14lGkmn0YqhNOTKNMoH/VyomcUD5gLaXVFQWgqhukpzAKnr76Li8C9/w8lp9Cwh+o74PsbWoE8dSix+JJ8Wau8pp8/WdQJXYKbwFSxvJ4KnTSmDXMlRJ7u3I0QOv0oqoGkhywU4A+I4mg0li3PBudg9Tg9Ryethw7CqS6R5ly2Kr0zU9Y3oeg2B9dsuovFxawKTk3zSf+BhnELG9Lbwwr/2mjQ0zFnSP6n2Ipihu3Is4ELBVu2ehGJHQsxdRQIocnhDfrJhR4/GMuH07cH0H2kaAfO3OSK1BV45DzqitfWELo/53mWjfK7s1488MV3x9bfq3ZB7yynJ4Ds2Q7bIbNmTqqnQjdIWCuE007NeXJzPePlXxEqJYft6xp3TfT8788JUh1MjhRFo3ziTdzPWf8XtAwByYTvNX5h9Y8fCl+ne+WlcNATRLd5flvz4m9K2wLQ6S2l8I9ro63j+BO22gZbameQUOEF5mRD1t2OHgCAGmIJKFzqbgoMW9KwAlZ8bzvfWPCwZDPA/21dcj21ipbRlFrg/wkBpTmvYXvFJmsYy+4x7ypeFvGd8Crx7xjS3vRbZzJ14NszhdUE3RZPhXfmk5TL6ejCE0udNZxqVuhKy0C3ce9xdbehiivQu/hjff8WaV0h5iTVXW5m9a7comoN+UFBAkY9MbX2e48e0PVG9kUeW5pRfyxP3h4+sx1eyUgaIo15uM/KJB9qa8BdxqhJZB8LOAPR0cEGio76pDBXWOqRE3ToR1xvYH6D
 Am4w+rz5
 pMgqvEj8TZwghwbcUbNKkx9QpG05V8+7LtrAuPH3VuEKBti2soKp8Dq2PPTirioskiWFCnD40wZkmMVjpwK2hdGFweTm57Ul3DI79H3RXpLL5OZZt9gHwm8rtv8WsRlvpUgvMJoc4P1VHFfCeq1BLwJ84WHGhGPVq1XcKxS/g3KykmIts+1n6cEGpymnxHrSlgPKijS0F3h/PKeCoD1Yhcp5UWmt8Zmy35kLcuUZ//++aaafLBxBsMYE5G7w1TKRFiHUOHSnqkZE1gXTfzrcgKruQbO0ZAYYopBoJHjehpF8CKE0JEQTyhCNcshF8GcR4pUm4vW+SDiPImzNs0QPCSSRqIrncHn+3Mk2TNpa3Uf2Sc6hzqQsTt6UDJex0kuvcchUY7Js1H7B/Y4GVSXB2Bb/92qI+CqjmD1tAKQpsUokIx8m9LXq2R3vFOoYltorGTRQtbab2g/ukFjRe1FyXgzrRBY1mx4cB4QSGpZO7IWuMxhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 06 Jul 2026 07:15:12 +0900,
Andrew Morton wrote:
> 
> On Thu,  2 Jul 2026 10:28:30 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:
> 
> > The sysctl variable vm.max_map_count (sysctl_max_map_count) is not
> > expose under !MMU case but used it wit the default vaule
> > DEFAULT_MAX_MAP_COUNT as a limit of count.  This is currently used when
> > a vma entry is split into two chunks (split_vma()) but not used when
> > allocated (do_mmap()).  As a result, even if users request a large
> > number of allocate memory, it will keep allocating until OOM happens.
> > 
> > This commit introduces a check at the begining of do_mmap in nommu.c to
> > prevent this situation.
> > 
> > This is detected with a LTP (Linux Test Project) test, which linked
> > below.
> 
> AI review flagged a couple of issues in the current code, one quite
> serious:
> 
> https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime@gmail.com

I will follow up with another patch for the issue detected here.

btw, I found (and sashiko also detected) several typos for this
particular patch.  Can I send v2 patch with the additional fix, or do
you prefer that I'll only send the additional patch ?

anyway, thanks for your time to look at this.

-- Hajime


