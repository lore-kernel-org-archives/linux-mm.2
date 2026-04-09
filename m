Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 955AEE9DE62
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AFD6B0088; Thu,  9 Apr 2026 04:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33366B008A; Thu,  9 Apr 2026 04:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48AB6B008C; Thu,  9 Apr 2026 04:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C64DC6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:22:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F11F140446
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:22:22 +0000 (UTC)
X-FDA: 84638325324.08.66F405F
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id A4AE9180005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:22:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZtE+lgE1;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775722940; a=rsa-sha256;
	cv=none;
	b=7j9N7M1db9C9FLv8OnOr0Z/BQJc1mDO+gjp/j17fWOrV69HnMgGovY506DXJSSsZ4BljFp
	+2JryaufzTuAFE/cgB/agfLeP1LRUI86BvUHzXWYqtnBNjyA9kq+CVX5CN4ATRIhmOZUH+
	I+QlHnsX4t0nhKKEbgKHVC3sxPgFNv4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775722940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOlZqbKz0soyeFsp+SRDEq8smfLI1S2gYBgZ/02VudA=;
	b=tXmMMNS0RVf3bnbMsBMq488pEKqZd+OI0W6OXZ6HHk5QxCpr6UJ5eLJZPrAUH9Mvls6mZh
	KDTG3VufiG0NKs7BMzHwlZv9ufQ1QMVEK3NkELgTeL+LgOO3AlcRRAqpmLkOm4JiJMDP5R
	TdSr3Bnaa1OCiWzGaiNmBscqfVtJxgU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZtE+lgE1;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d17bb1c1dso480822f8f.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 01:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775722939; x=1776327739; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOlZqbKz0soyeFsp+SRDEq8smfLI1S2gYBgZ/02VudA=;
        b=ZtE+lgE1pjE8f1Ef/whyAJeVTgCw9uLoSkhHTmdRPu1mdaLL/cOPemx39rDDqin+Cr
         Ow2djwcYzYWogBZb+3baXgMkvWFFTsbRTLG8CzPHRX3nU1/JmgtZuvK9gp3IT+dmdSMg
         pTjllyH2XP8FC2XbU2INjlfff4mGey/nUssP8loYK5oMG4CsGzui9fch4JLOsxScYc8i
         UdWQh6ommSVnL9JUJuftmzp5lKBVEk3bLdoEbe+XSW8/zSe8zERtO1atAlX09TxJl3tR
         XuvZQfc1a66eSfYwiiBP5Br0XIKPoVyK0yJ37LA5038JfMC8LpWH92GDSMvZGa8y66bv
         wslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775722939; x=1776327739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOlZqbKz0soyeFsp+SRDEq8smfLI1S2gYBgZ/02VudA=;
        b=PsLith2+NMzfmDHxPmnKST15wOKCInbWd+GBqEqHhNjPMbnJ63B4ZQOXMx9cMHyKLt
         376nLqyY6SiwdV1ZO04Rh7rpBzBZD2lMsj2NJFIw6HjelOsqW6n7C2pgywP8720fD13V
         RoHEMsJl/IvGC/DGU26tpXABwXS9ClpCJFLK6rObkr6eQzUgeq8GgxnceOzRtVTdHqkL
         DS/ke1W3dTQTtILpu9diPLKd+3tyVtZTQtzAXvhMFzy8qgT20ctYvmW+7wHCywDHQ3d6
         3vBztAutVU0sqJiD35MOTCRvCE9kdRNsbfRC7DE4IJIltMzPC/zijzuwLJ2oN6oMocVI
         O7zA==
X-Forwarded-Encrypted: i=1; AJvYcCVnNMep+EjG2Uh8drOSXb0E6ZmzsPolBqV0MLiezPOCbPHRlRYJZt5GeFvkj9aDluAY3hScF+my1g==@kvack.org
X-Gm-Message-State: AOJu0YxpMEr4FzWoypoKE6fAViA/FbbckLlXqvlkKbIIDaVzO0+r73RJ
	QEyuP9c//6gr/z7tVgAYKCt/p3Y0tDU2LZ2YIQryA5AOwRFKfnySQVc3lrJvPTTv3nE=
X-Gm-Gg: AeBDietwRhNzSgyPodZilf/MUGjgfTMp2HHpig55Hs/AeMWnHJXEpAFtWC9bQRDDWpr
	sVeBGUYvJHFfpi/rg1THgB1Uce4bLuFJfbzkUc2/svp62SBNDYvKdr/WufulIU3zaAeqOx756W4
	HCSOe5dSBTN0hXQu0A397R/fxVIzr6pEOsGinIKNc90ryFPl2nFLwsn0wL+6/PhB72MnqpTlL7G
	A5wJg0Klem8Ia+Y4Qphmho7EqYMa3ITq37so1aghpQBeDu3WiJdVj1O1j7B98zAJkho/0o9XP2z
	QUxfM9PA1y1LQXkyyK0b2TKtLp7hYxzJZEScRVCzaBIvrHWCDiO+DcRQSCuJHWTXpg88wrgfdDW
	KgNVYO7LRC0PkfAAHFEAbQUdn4NSwmLZbhptFaRA3QvEzmctBsl44fGU3OknwVZMqdganRLg6P/
	JEUEIaGekSgJguMaK/uVvbKdwc8qoSx5q+Cg==
X-Received: by 2002:a05:6000:400e:b0:43d:1c39:534f with SMTP id ffacd0b85a97d-43d29295ef1mr36340143f8f.11.1775722938997;
        Thu, 09 Apr 2026 01:22:18 -0700 (PDT)
Received: from localhost (109-81-92-28.rct.o2.cz. [109.81.92.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4e52a0sm62165656f8f.30.2026.04.09.01.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 01:22:18 -0700 (PDT)
Date: Thu, 9 Apr 2026 10:22:17 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <addhuRqrB-u7oDp8@tiehlicka>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4AE9180005
X-Stat-Signature: uwpjdh8bxbyppw9a7zokdw8roong36ex
X-HE-Tag: 1775722940-636142
X-HE-Meta: U2FsdGVkX1/vU5CZlBrAuut1wcr6uVyqFYxJJsTQYGYzvWkms3mMnl2wjNHNQ/XzipoaClkXVM220SqPAei+vmwLDYwyLRnXM9jSaWkjr8XJIjkUXTNgO2t/H80mVBm2wR01CzUIHz51eoL0/g2Tyf3nKU8YN0uYtdbkaBv786sIfipKiI27+2hjIvhhYDce8OMRDc08n6ZEzEkFEDCbTJr4hq2xIWTtqWY1atZvg1wHMILPaIdMLY72zXVbSX367zPHIkZQk7Hmvagvh6jVO8nRQzzdZtKCCUvoQ64OoupF13+HzPHeQN8RoHgO5Y7iTfxXDqQCLxFTvl1f9RybDlqU7AkeMcUZdUYITplcAy03M1c/YcU5MJDL402ua/mdkTbEjVEb/1/8/h9JK6GlJjd/zdSU4ajmZ7cNXcEnJhczNgwV7kYqfk3QubKejXqndpL/TOvl9wsOBz6nLc3/yYy0yiHAwptGe8NKsXSUn3XPh55AH60eWo5H2fwt8kEI+wCSpFQsNch/NNoH2cLxnhhnmgcuC0qEV41i4T/NyjMvVEI2cBPVCAsIbj1p/wpstrSnNaEtpFR0ExPDOCEqvAYS807MGwC3A1AEPj3dSraRCAx4dLwWAywLh0SuWiCZOMfdwG/r498it2lnk0v340l97Jus5aJOdIjrgg85OKHRFdiUGLTIGrPpgoNg4CJS1FDwXM4HUEqOQQ9mBiCd7Ehl0vFlRvQv/HX74AsHXnirB+NYy0zVFE80UlJD2OVR3SiNOIhbnFl0TUa8Sr5DMgRkjdDunZeJOrbwHVhmLtk0tpTEeyhG236Zt+NuZ++cRj+FouYmQ9xC55tIqeo3wRPVVpQPly/oAwCvuABK0OW9cNkVQ5vRgb7CmnvVYX7ucbd/4uzP/NKZiij5FEzKqhL5JOl6vYcW8nEXXezgMqw3G8h966PggzltcoE+XxjsAlDwSeyLKoksWN9hiCi
 EN3oLXFM
 ZTbUmquLynJisdgZZ9+Liyu0UEfLfsPfFmfguOzd+SqLNl37vwpH5Xp3WUu8lj8l6BCxZ/sFgpmIhP5Btiq4RokgPTE575Fx5HklViBYedeUhGaW1BYhPwHB5JhwX23NqFu0Bul4li/P60pqaHhnXV9WwsAwFhVnZsIcyOo21Q7Dsb1mhsoJA1U8K5TdRk/tSUb1r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 16:08:37, Kefeng Wang wrote:
[...]
> To use the reclaim interface, there are two differences,
> 
> 1) we need to input the reclaim numbers and swappiness, this is not a big
> problem
> 2) for reclaim, it supports swappiness=max to only reclaim anonymous pages,
> but cannot only reclaim file pages,

Why is 2) a real constrain?

-- 
Michal Hocko
SUSE Labs

