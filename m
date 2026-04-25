Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04808FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 13:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27E9B6B0005; Sat, 25 Apr 2026 09:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F566B008A; Sat, 25 Apr 2026 09:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145F16B008C; Sat, 25 Apr 2026 09:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 038BE6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:53:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FF088B0C7
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:53:10 +0000 (UTC)
X-FDA: 84697219740.22.9FC9E92
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC9334000C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:53:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BJMoP8GQ;
	spf=pass (imf04.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777125188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqiP47VwxYnYrJlsTn439Gu2RrPtIy2CXWplvb/r+wE=;
	b=5Tb4P7SCLIGmUxOySiL/tuHlNohwEzOgOZ3mXfaCpJdSbyj8btMNu+LDunws53IabWAgE0
	KdsLPOgjhbWBAiZCba6aupVU7EsyLqOQqqHi7LgvBd/kyaomsbLDYznCxV5mC9ZLmDzJdW
	2N+/NVGQnowQbcgz/FtEpeCSXxbzJJc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BJMoP8GQ;
	spf=pass (imf04.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777125188; a=rsa-sha256;
	cv=none;
	b=xNwdg/IWpkg07mUL1GyGljLGOgG6q4oYL0gNUVoXTrr2HEpNKNYOa4t/KUkyVVXYPCXAVi
	aHTPJA7q7w7LVuwYa2fIHCS2sLDCO1DSjkNpUf58Zh0VD0KI881K8rh9dNc2BXYLmawbVc
	1PGX1ID/9rd0A4WlvvM643KDarIPfBo=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82f8893bff3so4154946b3a.2
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777125188; x=1777729988; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqiP47VwxYnYrJlsTn439Gu2RrPtIy2CXWplvb/r+wE=;
        b=BJMoP8GQCs6DRb60VDfLclu2xNFkfNjbEPlewvclQn7iiJG41liumbL3Hi/08GoTC4
         4BWSh4xB75kYb3CkXULl0YkXlfCS7XjxuTGDS7V5yv90NXPWrtTrOxVQruZKWDaH55rE
         sqkXFbQHi3DvRunPLLFL10r/NsI2chjqHmzRgOmms6PnrqMygYyoXtsAtdY/w3HoUW5k
         ZXJ02eWeC4VUHvlP6NTU6vGKYb+i7lIFPh3iHJp/G3TtkjgR3B/kBoXoByH5A43v2kNm
         uE6M8Z6xIVoNZZDiMMAmp4J5MAl+NEzLUA27b0yOaKOmtJdmFR5nUCdphsCmi/l3mJOM
         ZG3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777125188; x=1777729988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OqiP47VwxYnYrJlsTn439Gu2RrPtIy2CXWplvb/r+wE=;
        b=nNMBcWI8Tks18HkDBJQ/M8d5V2KsgPkwCGb0vE4YHPK7E64I7V67fI2GBSStQo2e/t
         c+/QlaYVovW4oDRtgMzPDLYVC8BLrQxu8FLG6cJti/D6bkKs611hcKqyA9/FzTAcAHv+
         aMuZPTaF79b894KEeKw0mxV7QxECxYjViosI/MMCrPwR4fturGelJaL+trtNEcDdgEVM
         AhYb9IOK/wVlKlSTPSu3ClE7EJWonEbYnLDZVMS4Tgl018bmgMuq7DXCm16An4dvpxuV
         rodw2kS6VQ/Abmffxd4FSoSpE9L6LikUMh84ydN7As3HeIt8yknIA8/UXQ3IJy5MpDyO
         l17w==
X-Forwarded-Encrypted: i=1; AFNElJ+mh9Vm32fKPWmaxY/fr3i+nW3Vm/PV2EZCpinM4xcsQ7Lshx1CT3vswpk9bEIqX2yMYXZApvICqw==@kvack.org
X-Gm-Message-State: AOJu0YydhI31QiPgBfmpHS4L1xOiJ9Pp+cVPJlnx6k9Kfoqq4/i5SADB
	f1JwiqAj+7R63P0g+rljcforWfi/P6vBtiwN1XENN55zwocil8I9QX66
X-Gm-Gg: AeBDietG+EUihDpcuKS4VK3YXBMhiD6BPsY20DNuSHu4OKiOblgqe7StLrefaHJ2ghN
	8xHRsa3h+tr4t8hVlk2HjWNSBpx86of39NA/0VrgCTbqVDxNK693ane+5sbedpq4Mq8fqtAMBxx
	Tb5YWFsJLdWWkPRvNNfbZvEoUuT40OuHmfsWHsfBlUBcu36vwBSisvlHbg7N6edILBj2X5/OnI9
	3uJv4wCzZSIXI+li98Ed1NnOLWH9aL1qYqfV8J/3NWcnA4f4uyH623/gMQxDaI/gCnjPrlBTsdn
	Qd2T2gfdqXHSvpBBlNSuyO4YWfoLgODRSzolAQF3cKStuWoVAgcefSij9JiVQVkOxR+M6Hkyxb9
	CCt/qPRxru/rXVP0Rhz9UxU4AAsF3F3AahlSBaw2t8YLfDhkpUbHD34VOZ5GgslXfireW3mE3/C
	FrmsMBrTzsIOR+eJORYFZCDvRnDluEbMGhi5t7A4VqHywh+4dSNoA4hXMYOQBBobf5034=
X-Received: by 2002:a05:6a00:1da1:b0:82f:2319:7d4a with SMTP id d2e1a72fcca58-82f8c91a5d1mr33328722b3a.31.1777125187592;
        Sat, 25 Apr 2026 06:53:07 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.21.105])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec04448sm31761931b3a.55.2026.04.25.06.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 06:53:07 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	apopple@nvidia.com,
	byungchul@sk.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	nueralspacetech@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [PATCH v2] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Sat, 25 Apr 2026 19:22:59 +0530
Message-ID: <20260425135259.26122-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <b3176027-a1b0-4aea-8401-18cbdad9bc44@kernel.org>
References: <b3176027-a1b0-4aea-8401-18cbdad9bc44@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC9334000C
X-Stat-Signature: c11w7afzp66hytqfpt7nu53jujk9dqmd
X-HE-Tag: 1777125188-176125
X-HE-Meta: U2FsdGVkX19Y+aD4QD6QodBZJEdEyw2+igMY0nutjaX4TC4AvCU7UkTvx3gjwoQ2wRBnFtAGknLBcgeTY+zJMe6pMPLGVJ7p9ZKq9qz3LaphPu6XIAi32wwnH9Z2kHH5hPXQSyc932nQZms26gsT2XpFBVgccWnEZHq/13TFz0xkXMhfjsVzNSr6l44NMalXTHxcZF5AhdkkIcHqD0P54bolIoMlasBz3WI0IBiX6KlFVAvNzUBmoWUhxiLuOFxMukEEszyHC9Gn6IMvi3mcit+NxDDSty3NSlJlQAFJ74kG5RKo8Y/QBI7yALA3+8ERVQMDyOzjz8fd1xy4WBnLBwM4LEyjmEaXCs53Kr4gvIy5Md3pm5GSrcyoRzLU45VFZTDfeGDjwBBgmgeZg0SZGptoKi3xgt8ylo7PrfTS3/5pGYZmjByy5oGNN5eEaRHd8lMDgYo7q1XLZia6TapfzmHa5l161OCA7jlbX+mlXKZAJxMlTCis6y+ayTdBjgj6qntYvG/bvrEpGxkV8GV7RlLRMSWkqJjbawAhEeqxfMjV5MQr5uIRMRtUSwBf2brFdpRmhC78E+X7in6x+Pb+xqVLctLRXFpri67lqd8b4nnIdGA78pJtNdJZ65C8nYxD6qZ9mkPRCwYBjxC8QkSMOy/ORwPUSt/VcQZydbE7ztSXvDOJQeERtcSH7Lh4jgGq7FIyDU252xr9YdNyjh3jwlzqwrKkM7ShcvX7wlLDhYM4IbiiCo1/DYPz8NaL2CtX/6Y6Nw5m2UFVn3N7TmlKOCDUuHDXEdncfF2zJhkEfO+5hFezCkN40CvbL9Jsy8eFqm2ctvCgB1OxNQFEZFrhMKQv54xy+3VwmzUmUQ21IS3BUlqdePSwKhkX0dyY6cjp6JYMg30ZvaZ4Y8/bhB2iLDzfsRiXXU+4Sj1/5lrvuFYy84hnf2Cz12pUlUJjboUof1t4AI97IhkWmdaS1MQ
 RkqP7LP5
 L+OXAyeeWC+nVtzDcW+eN/P3Wp5CktwGC9SooH7WFV5oRru22jaVf1EqCB4vpybIOZwK/QI59/xk2C1zOOZ9nE30k0qqpZDltYILyQ75kYmsXaLC1kzpSFmEUlJk0C+XINZwYdzeKC1fctwuytaMTZsN0/MFDQmuS4f8RDH25rgJEURE4+8/rf7ZrhyPGNpIa8thoP2GMqKrJOOZuuFxNYD+HLhzOgAYfgWLEWBuL0ybdfCdj94struOTTiikx3zGC3uF05xTAYtOIP6R/kekD3SyVt6H3dAXLJ8K1+t7jDelHI3yWMKVOhSDNvntfJl4YQOrMvJ9Ss5OFz5rjAgiWboTMNW9QVEX4yi5Be60LsrTfegsfw1V9Q6D8DEAH31Me+F5rHNUWhW6o9y9gXxOvhv95jjXOzo0IUPbufMWDUo2PPpZgscsxa+IIAGcn/i7i7q3KEdZor+aIQmD9aWM4I4/NrilDRDs3xb59BqzTYenxdUP1s5/yY4YLPKO2/ek+FxZ8zbVFgAK6nd9DSGanAvBsVbX18UOQJCniJrnyJADKJ49E4Pj/fsOow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 20:25:06 +0200, David Hildenbrand wrote:
> No, independent issues -> independent patches :)

Sent two individual patches for review as discussed.

1. https://lore.kernel.org/linux-mm/20260425134453.23769-1-nueralspacetech@gmail.com/T/#u
2. https://lore.kernel.org/linux-mm/20260425133537.17463-1-nueralspacetech@gmail.com/T/#u

Thanks,
Sunny Patel

