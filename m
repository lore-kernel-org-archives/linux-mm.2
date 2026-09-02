Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E812C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081236B00EC; Wed,  2 Sep 2026 13:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00ADB6B00ED; Wed,  2 Sep 2026 13:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3BAA6B00EE; Wed,  2 Sep 2026 13:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B21F96B00EC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:08:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57899160300
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:08:57 +0000 (UTC)
X-FDA: 85169457114.10.7E82703
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 83FB1A0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:08:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lgESi8sS;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788368935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQTVimqqf+p1p2NtJSlLzOSP0qFj/dJU9F0ai9FYCBY=;
	b=zcHtux0jtGpJLtztuIl7SsYBJ47t7y+laIYMP92UdLXS1y9ZGMjZce1eqVOjcHR+1f3Y9j
	FGugYoJh6kb6c3sd3ZdfBJu6WYieWJSuGx7/4RkgE4qH8o0MWz6yWEe4X/FVb5j8XzxA6D
	tWZGU2W5RnK9InU1/MrioQibR5xA5eU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788368935;
	b=bZBD+wYjp7XoYhyPS65t0vINHya52ujPZ8M5NjC1DBlXY9XYGFAheQtozG8nb1wKzv5Ai4
	y0soIvnjRRmPTJIEWpP52xxSbvIlKrgj152eXxf1oOcGzhdHdb2POs0kJWJZebUEn7EDuP
	0is+75mfEVjXqPr8D7Sj99xNAVMYKhE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lgESi8sS;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47fe89fb333so879149f8f.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 10:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788368934; x=1788973734; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PQTVimqqf+p1p2NtJSlLzOSP0qFj/dJU9F0ai9FYCBY=;
        b=lgESi8sSE9JJ37wkXjlYPLn7U1NYFG5nybf94PquwwAI0DLf3+l6rCX2IgFOe9N7zE
         EKeVEXY/jAVbQnCYQwBo6J6yZALecaH45qt+osCk88ig/oyJkaJh1Gehn94eNRr4FSHu
         6Tygcar0xv1EmcTOokAdCEPPzaWHvcGdDfWie/EuRu7btF5dub3tirZqFqneeiO7YdnN
         FVvj/oNvgUiR7vkLPTTYvslBm0cwxyHKSN8vwqr7Rp+BcePUX5d4DuiKP+6JY/RkG1Hs
         ppDVcKUqsbEdI8IRBlnS3gEGt+Fpkr1cO+ua+nYOe7HTbuith6nu+ekTKxlrcnSit1DI
         SKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788368934; x=1788973734;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PQTVimqqf+p1p2NtJSlLzOSP0qFj/dJU9F0ai9FYCBY=;
        b=mZ6PYOxxumw1Tu0Zqoo3835nO0QqEgztj2dRHZzCv5dbOAYI6nk1aDvZrX322a8RlG
         FdtNVTcr1OpYOC4q6l8K43agjp50hDMUFiZfrzV9/LMWsW7weOCfp7cKjE5PhThrr1Yb
         Ooe7YFdXrVrgZzkRQinTO/FtVXu2IkC9hcIV/UVuoW/Hx8RnfLqKzdK8ozT7T3MeNxyk
         2b/6tNsrSsoEpZoETPcH1ZOPjBR0P1PeyhPOj5ayMvu4US7iJVyv+2bB4eWUqwcUXU+h
         540ftLLR37WKB3y+lPRcErcJ/O2XbF/0BySMx6hrmq2q0153XspIL85shV5yqcz5wae/
         A2CQ==
X-Forwarded-Encrypted: i=1; AKwUvBycvk4Iw+jTn3FWECPy11RDqGBU7SnENYNBpASeCea4mCin27Z9Yz923OpAlR5cT3CmVrv7nviPFw==@kvack.org
X-Gm-Message-State: AFuF++l3QFFMYBp7v82ramp83LdNG7Yew4xq47D2L0ofjcPFtBrqFAH0
	hRzKHBaxlRr+MEWyNsm9/HupMa+z7KPgTvRxBrJR6nfDOOS0yaK5f8jU
X-Gm-Gg: AYBFou0smQIPgYcFYRgMjSw73yJNlWoSGYI+Bb9sUQ5R6U6U05w/27inKMFRm3tcmID
	5Nx8i6Y/pb1f9kAU4v0oag4+1aFIFB5xuj5raD9spt7+TG11JZVduWsEAvUBGib7nWndi1ZnPEf
	tzC8l7J6M+gkZl0b+vlMqvR+hPssg4ozziRBWHDBcnZ7H4t7hCJbXEtB+ZyITYR9VjTcjTAqW1B
	kMgXooRPMM8cfWpDHxMXf0AYmndRBN+5Q1xGloI6jJC8cMb8t5rls+F365vRstr3gflO3gTpwg/
	+bLDdInw6Qq/1OXhSEXLcp7ZYRH/hmjij2Jaukbkm2/8dphhx/0PIcLmIR/Y+GbGwNnEMhhw9Q3
	n0ftfKttPYnyHu59wAiJGNAXOfW6OJIsDUmOO4JiQQJ8+WIUsvCxfwD5xILaebv1NM0uCRN5QFK
	GMXzEwWb6rB98eFbN5i6lulkRdaLBNwAHQPhUMAwd5Dn2K+zDuXm8YQhUHhLJsw/UgEW6omk4bx
	KbQeAkHoceRe2pZILUuMBeP0Jef5fm9I7hxGUcudW97/AQKN8QhrnhoBOfz23pwcOSZGYZXeuZS
	WPrmeCDrIvKpXCjdIzCt2ENUF8KsHvuxbsg=
X-Received: by 2002:a05:6000:460f:b0:482:fd9c:5d25 with SMTP id ffacd0b85a97d-484913ba763mr13387018f8f.16.1788368933900;
        Wed, 02 Sep 2026 10:08:53 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-077-007-017-232.77.7.pool.telefonica.de. [77.7.17.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-484492cf550sm7547096f8f.37.2026.09.02.10.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 10:08:53 -0700 (PDT)
Date: Wed, 2 Sep 2026 19:06:56 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
Message-ID: <aphV0wtGqn_EJHjB@gmail.com>
References: <20260901131823.15799-1-kmehltretter@gmail.com>
 <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83FB1A0006
X-Stat-Signature: tckra4sunr3nmgdjs1q86b7thmsu1fx6
X-HE-Tag: 1788368935-210673
X-HE-Meta: U2FsdGVkX1/cUCFcLHxeNNwSU6mLrxfXVPs6hFST9w8+ZRCcCDd46g87+uVknVu0YtsHJY8fMAVLykM7eZ/dZt3yMM6+t1eCmdqIlARlTQwUdZzvdYcpqX/4gQhXFFx/IAUUaK8f1KmVAh2PfQhpRFZvvxHb6DhBmEjlDQEwBEsZknaiquIfeecf4Ccxmgcf3vh/tw7agKIlwpT3T7t4u9S1YywpO3Lf0H6X2Jdf8BK3HVFpoXqpWeS4vqgYi56SB/3dfL1/v6r1aBkMGsfCoqI7v07Y4Z0DZkZeK24OOnzq6kF+4j53Hulbazrq4rRyRpqYXMjL+e4044uO9FCRINCmNQ0RqrtLHYaGkksOCXKpv2bWkY7guXE4Afdzi6MqWHvVD3CMbb54CNzx9sNGBBs16zAO0tMy4z+2Be77mvXJqv49xCtoy7e8vsl4b4cmQZI6pt7xd6PTJcmaq7UzA7rPjJMTxMUHFoRrIJP0U/O7UeEHGFM7Bb5WsX2VIsINEPlf7i9ouIFIAXSov4ulw/9mHCHcJ0iL2i7pLwxXWxCZR2GjmXnQTJiK91ACgVxZru1CLGPFJnHZUj2PAemPyXmKYPz8NFdFPpomFxAQct69oUshlxcpCONkCmvusHFNUSjmJuyScodYZwQ3VFQykO81B9OSIvqFG53YPda8hlBOCuQbe2JAlQYSXELXeyoFgDTQwjCJrAgmXGqkIYWO05qO9nbP2lhpZm84Zq+dXBHf+xuuQMupaYTLU/SDO7QGT4L2iJR2ykcJLb+NAGkIH2KPHBMacSfwED1U4jwMnNQmuPrprnLSqHhZgAm38XGYhKRc7Z0l0bR43zAtDHp8G4bk/ydT4PvhtO5fdxkV8bL0JEK6SB8XLVHcjQE1QygwaOhJgsSF/2j+J2IgDkN3bOKn5oPfn2HE0EPFPYSIfx+MzF5aoZVGu1OUNSO4jBJfvnyW7PdARm78E5bGU2i
 iPb4g1y6
 KF2cDisQVNeSld0JFg7/vbEa4nsREqJZQEqeAppvA1f/P4cVbCCVyW4dBzBepZvgsj+y/IQU8VHMBb8817s4WdHpmtNG1MWU51W8iqV9rsNk9ditDAk+YI7Zw3y8fUist9KxwkfQwNA8/cB11Szz1pD89BnFd99jJCt54sPqwr+yZJiAe7Q0Z9lZ1hGQ4B4mQsNnp4GH3x6AGw9c4/xD2/8i8Qu5/MOrxZDGgO7yJTF9ethSDZNoj5JKrVRV1pK3aXWAdwcgD9KgfPs4PmLpryUhG7CzXP40NK25NnM4pcpSLRTO3TrZcRvvF0izIb8wB3RTRl5i6mhzkvEzd4lZcWo9Y64E3bebRlxs3HmFw98hc6OM8FUyLzgFlvubxmhdpN6dPvtR2quJd6iE46nmgHBoT6xi7+RUkK7Ltbdv0shhntqL4A3AP3Q2mRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 08:16:36PM +0100, Dev Jain wrote:
> Upon discussing with Ryan I got to know, he was implementing the
> contpte stuff for non-hugetlb user mappings and that basically
> drove a clarification on the semantics of contiguous bit and
> this rule was added.
> 
> If you see currently for non-hugetlb mprotect() we do not flush
> during contpte teardown.
> 
> So if the above reasoning makes sense, I can infact audit and
> remove the flushes in the hugetlb helpers.
> 

Well, that's quite a turn of events! I wasn't aware of R_JQQTC or the
architectural clarification behind contpte_wrprotect_ptes(). 

My QEMU checker was based on the older assumption in commit
410982303772 and the existing hugetlb comments, so it treated a
clear and remake without an intermediate TLBI as a violation. 

So... Please consider this patch withdrawn.

It's good that this may have uncovered an opportunity to remove
the flushes in the hugetlb helpers.

Thanks,
Karl

