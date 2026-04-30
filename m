Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E644FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 09:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F4D6B0005; Thu, 30 Apr 2026 05:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF476B008A; Thu, 30 Apr 2026 05:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD3D6B008C; Thu, 30 Apr 2026 05:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2F96B0005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:56:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12101A056B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:56:00 +0000 (UTC)
X-FDA: 84714766080.20.84065EE
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 027E5140006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:55:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AwJ0XhXC;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777542958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+mCPnhobn1Shg1eHQXCbaDaEjG124ocTnpLUhaGbSk=;
	b=iti7HSgFd2RB8SDGF9ddGozWyDq5RVYb80TJ9hNMEzMBlOkfdGHk7rgm2aDlvQKGudt2yz
	9eZaSAz0g83vYkb7SR/fVXsZZjMEO/Ry8zw9sqRH3sh8qeeO05302Mykd7gA8VMhQEUiRn
	GEokkXZZdyWfsy9E6Lw0nhhzM1DEtqc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AwJ0XhXC;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777542958; a=rsa-sha256;
	cv=none;
	b=fkWv5gyQc3/o6E4pfnGGXyIogETQ/liNrta6elxK1mEbhv9IesDMnT1dJQqrZYHPvdfyH/
	oAqsCBZWOqk0+6gRixLC/pIJGMvxwCB/GeUpxDoLeBFeRcYtfLwB4WjWhFwweSFsY6JTsP
	jIfsp7mNTIVlvXTuGoZVf7eqZSN0yvM=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so4389055e9.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777542956; x=1778147756; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/+mCPnhobn1Shg1eHQXCbaDaEjG124ocTnpLUhaGbSk=;
        b=AwJ0XhXCK1TPmEIZkBEMYXUPk7ULI8Y7FrS5wzAc8L7RQNa5iHpwRfszYX0oa2iiBU
         1h2iRxvseKJEOfg4uaM7Rv49ISd3nGA7NXghZxRNKDIIM75aH51aixK4H3VqezjvNPmM
         6vX9+nWimzBJ5OuPik9uMa1T3lKR+NnEuwlfjLETprUtfjy+fO56kt2zQkdESeFVOCk0
         0UmhFok51S2S6PjD4OHr4SjsHMuTwSkQoXftsf4QvrVbDOw4Mje8J6neGIIlAUELndGy
         77rk3tn9Llv2YrkDgDoe2A1kV78nzzTFyWuOoDvsEZlwvOT8bhOd32i4L01GoB9NacD7
         eeQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777542956; x=1778147756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+mCPnhobn1Shg1eHQXCbaDaEjG124ocTnpLUhaGbSk=;
        b=kOSmJSNJr+4oQW99YKdNtmjvJZl1h152tdxZG6ponhIbC3ga10z8w7d0lI6fyLWjwC
         wl+/9PE2zXDq7RmGeeH173KuW6ooNiIxVGoncT3lgsCW+4yn9VMRP3soGTEoRm5Gk0m7
         oWQLRyBeXQXWM5KICi6ol2a1sVlPa3NJRYaLyXjigkwUaaOrcMx2XGxAlBmdJ2jMvxbo
         yzH2mtPdvbs8Q2XiZpw/bxxkSszvUkKDMYWcCUcXhrIHyxIjR4S/ieNzz2ZhFf54J6UG
         ikEtZ+/PuLe8rDbqwx/zcS3OXzqG3YtbBDI0CBnJRLYPIiyH8KIHpI6PlznY4pT0/9fd
         1HhA==
X-Forwarded-Encrypted: i=1; AFNElJ/hU+grzl3rpznvL+34NcRPuY2pGul23fYbJ5qwjR8+5ZJkhkQ7WepCe5x16o903EW5R6Z31Wh+Gg==@kvack.org
X-Gm-Message-State: AOJu0YzPnM1wwzGMSE9r88aLbgphNX0lViAO2YJZGHHhZIpNR2bPmqKh
	GV/DmV3hYI21HZEivquOz1Jkb2hF0WuAJcWxBC+52o0xaNi9CN4ZSA0c17tfe4VPEK0=
X-Gm-Gg: AeBDietEjnzX3PPYM1SY8n5NrkbQVLPletbE65nwoJpU7yg0ov1f/fBW1F2VLOPRipb
	RoIwfsrOZZFO1jwVadZviWcu+leNfSytxkaQKIOBzsrOY9BaxU+qbBMZi1A9zYroURnayyDR6oH
	i9am4LfPeN8Vgid2wqU/2fxFNcqayzOTwMmgm2SteXD+QNnE55XElN3lfAdfMYi8OAZgjSozIrT
	MA6w4arUqpeVKD/mOt5BS1+nqLWxNGz0MQhqQi8bVtrb+8mZyh7DvIK1/+gFY1HUuE3NWcTlm8s
	Sp1B59N0RKyC+S9ICbEavHw4gC1I1c8BBZPBnIEAvnonYYIkH/v/VWBid3CcGo94w5YcWpmGFwd
	aiL/Q39gxePDQZT1rVRXJQ4aB/W4XS/Y0F0ATeMnPlTeOn7bH2LkHohRdnpWlWNC4QH9E/IZSZ1
	CFSOBTnU1NWPaoT9j8t5g4hepLv+lusXtEUnJTQHdcXauaNo0=
X-Received: by 2002:a05:600c:4f52:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-48a85e684a8mr27887335e9.6.1777542956173;
        Thu, 30 Apr 2026 02:55:56 -0700 (PDT)
Received: from localhost (109-81-16-145.rct.o2.cz. [109.81.16.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c3235b0sm38663215e9.31.2026.04.30.02.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 02:55:55 -0700 (PDT)
Date: Thu, 30 Apr 2026 11:55:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afMnKrYT0xG_a-b3@tiehlicka>
References: <20260429211359.3829683-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429211359.3829683-1-minchan@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 027E5140006
X-Stat-Signature: byt3ordg37hq85uxqipwrz6u9o48e8um
X-HE-Tag: 1777542957-319390
X-HE-Meta: U2FsdGVkX19fl1q16kylH2ZEPWCdeLHtjb67BikJM4EDjgrJaozXPK5BF045/Rn7aOMzJ65FQlZEbm8BgMbffkmjzYFMALjZbJu1RTabMaDp6icFUnAbVw7ySnWlx8XGFcTjlq5xB+33HG9xXVD3gjYtmHvw8w3riXAD3B+5XJulrVkPfxzPsJdSIjqTmBW0VkNJM7Y6JTXoCagFczOB0bQ64wobisxDDULqlQnCViaCYdUTUciEF2bSAjljPmJdQ3lvhg1WImax0q2LJCO9FS5+wMadC7rSel5x0AIgkrKRWAyLoZJMon6ay4mFXv5KcVqi+b7StU6B745RYXozGVQbSRhg1TRvccVWnQDBPzYQ4PzmUMuih2P1F/Cbx+juzs10pyXDe8GZRCBedVDLm+Il52XsK/j9TeoWiWKpAo3in2zCDvKImIF5AT7mQBqBZvan1YY9hIz6Sqk+sJHn7ERqUNsFaLEmpQTaGCOuk0P7VKWXBaXB4kjnxvrC0jewLKxYbXnlHYEqP2gjm9nv69Txv8RXpGmqxkZVrRPgPExIzQpj+PSgX5mLeb7ErxrpTkdzfenZ7DjWEX3YvuNngxffP/uVSDahMjYuBHOUQVGht6Td1QKkwGQE6Mrb/rRTz6YxrkMSZlOgNeGCKvgk2/WN8Jj/kS0+enpYX7vk+tOVepcRSrhRtUH9LknLV4e2Jy+j/9dTLdQcDIHM8mGQYrvN76b1sNixJHPo9JEUELT73cYXuLplAI8OEnDUaPoldw0Aik9pKJzc2XllMO5XbRt33qPZfd+4VIkdMDT9AU350jI9qPqiNNVRXm5pSu4dANq4CYoc/44Cwr7KOVP5gG5HLs74RJy2gcr8DklS3MNJa6GFQByOOeqh+MfMK4JYIlNzzQ3eijyUoAIiR4pi5OUWRtmlDMlapMlpA1LXWnIFioh/FGi5OVKda5hcYvuFi7vZoiYzSGCatl262e3
 4+77nCfH
 muvyKlF2Uenwq3OP7aW9g86DXAXLNxFg+yd0EHysQfDal/88r7q0GqtAKV0yl8qkkg7ABegRqc7Er+eDb+w3diy8Y9Q6bPXAq1MeVPRCmAHd7g8S4gzTSrmqL8IF9tjYKzcaFwibwmNR5rnm7JIRfe+u96h5FjBZo1QId3Kn1IWJUm9utHIWL33cnu870gLrvayRQ/BHJ2p3daF0WH+sbM+hUqez8sdbt977UgWQbavazcsdN2lgefDA4g5N2Hbd/11/O5q3pqX1tb5WvgM1xGB4mtuJJv+Hrai6jaVy0+S1u8Ys7A4vzXSVXH0eq/5wvo6cr1LiO+c8oZbUm+cD3DKGcx++qCw/+lUQ2TTJkewMjxawjDdBGPSNBR1QWI+TcTjUDxUtPBgYm85AWjSQZIAp1qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 29-04-26 14:13:59, Minchan Kim wrote:
> This policy differs from the global OOM killer, which kills all processes
> sharing the same mm to guarantee memory reclamation at all costs (preventing
> system hangs).

Incorrect, we do the same for memcg OOM killer as well. This is not
about preventing system hands. But rather to 

> However, process_mrelease() is invoked by userspace policy.
> If it fails due to sharing, userspace can simply adapt and select another
> victim process (such as another background app in Android case) to release
> memory. We do not need to force success or affect processes that were not
> targeted.

This is a wrong justification for the proposed semantic. You seem to be
assuming this is just fine rather than this would be problematic for
reasons a), b) and c). If there are no strong reasons _against_
following the global policy then we should stick with it. There are very
good reasons why we are doing that on the global level.

If for no other reasons then the proposed semantic severly criples the
shared MM case. You are left with a racy kill and call process_mrelease
approach. You certainly do not want to allow a simple way for tasks to
evade your LMK, do you? So just choose something else is a very bad
approach.

So unless you are aware of a specific reason(s) where collective kill is a
clearly an incorrect behavior then I believe the proper way is to kill
all processes sharing the mm (unless you are crossing any security
boundary when doing that).
-- 
Michal Hocko
SUSE Labs

