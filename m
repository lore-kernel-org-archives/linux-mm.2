Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B94D31A02
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D1E6B008A; Tue, 13 Jan 2026 21:51:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB286B008C; Tue, 13 Jan 2026 21:51:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD686B0092; Tue, 13 Jan 2026 21:51:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAE806B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:51:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 567911AD8A1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:51:34 +0000 (UTC)
X-FDA: 84329043708.03.3FE4F35
Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7AD00160003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:51:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gz0KYTCI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768359092; a=rsa-sha256;
	cv=none;
	b=3FjBZMomCssOYasf6rfw58tn759x01yhWUA3j1Iar68bQ642lfy028GaDI7tig9B4n95wE
	2Nh2qHXoc/Z0nCVjetpN+ADD0NOFgrh/hR+n5+zZX+K7gjfzgLN76Af6h1l0OMAA70Wv2W
	UhVLPsaJB5TwM9I7+IjUHtwi30sePe0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gz0KYTCI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768359092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvu8UPfLlwRF96xOboi7Nid/lju0eRs0SRu/ifxBI60=;
	b=D8Z8HtgNJoy0bamt3PmJAS1wH/dhViHIDegBXqGYjtxPRLspAkbvrK8lKuf+9HthMNBGEn
	eNPYGXfEC/0F4Kao0R3iF53gemG1S4rPCt3r/VLpv4Q6dFw7dV1gwsBNriL2QHXbHXaka4
	fKxaJVsxvlGuNxSQ24Xpwbh6ccXv+V0=
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-2ae53df0be7so13659783eec.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768359091; x=1768963891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvu8UPfLlwRF96xOboi7Nid/lju0eRs0SRu/ifxBI60=;
        b=gz0KYTCIlTE9rg8h7clk2y4+4TpQvi0aLFzkeqiTnllyG15y84RD4ULxCGtd6XoY2U
         9jbSdJiBYZhzgxEJtK48ATM2EWvqgHvX5d6sByOVimpQgjwTXXk2i4HChg4RdBYwoQPI
         KepwNxxGGoilAWCYvaOzgpPcv3xpkAl4DP2/dEeq5jlQWh23SkARTQnnv80pKEdLSNyy
         heQCepiXNABIzhwsj2kx3y7cn2L8gTkolpIUIntLlZOPNfRn9wJ92tRjNfbMJaspM6Qj
         lPsQcU6ZxoUuirkThdqrsJPDFWIoOkf0NIAAbTtQu+B0yfUuOc8BrNjgoF0wrRATzLlD
         FFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768359091; x=1768963891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dvu8UPfLlwRF96xOboi7Nid/lju0eRs0SRu/ifxBI60=;
        b=Zsvz+nA/ABtJZoGmj6FyhaZdeJIrn/Lec/oyo4vpoc7HKmNyVvpOzfU+y5FTRlFGaA
         kOa7EnVdDsrl4gM4UCeS9YSPyIYsD1TWm+E4Mh3BhNWeO9hC97gNpjNFKWbCXgTJWzxU
         aQI/ptJc0z5E2X0QePvE9hDHzmHkpcgK5t98y8arKRtlDx8g18nt4KOyYs6tpSUnq7no
         4XvOkVsIF5H3oDpT+rtGUZpVhP0yjIvMpCQu1LUyn+IrS4RvQymngT4BcSJ27Imar58G
         t+qiNlddcOeW+5FzJgs13sKJUvgye1IqSCjz7h84aSdroWK1xlAyxIeeCeyzQkHxFs95
         hY2A==
X-Forwarded-Encrypted: i=1; AJvYcCXmiqPTlT+nDfEzOxcZwSdkdZB6Nd+39UX1gFIkI3JU8lE+QTsEWr+1oim4/j586zfYdiPAjIBcSw==@kvack.org
X-Gm-Message-State: AOJu0Yx/zbKVqxeyEXPLxNXRiAPH6q2nLv0bksIBmANM4YD72Oh+PJO6
	4DY9IW8wOuBuROXbkegNuySVfSPajAbJ7fPbE+P7vyJFSykgZWNB0uiI
X-Gm-Gg: AY/fxX462ZDU4H82Z9jwv2JeArEc9MiLcKAZYUPhYskt4IdFIRO+heybU3LgDYvwgjx
	2xTureyNs4IM/59ukk/BPQI3IxiDV4gjBLP+P+wXtLYowF98mT6tATcjPRJ3aPG40x3Bq/84PZq
	UWgUUKTh/HFCrnHS9Q8l+GIveMaVS049cD0n07HKfqtSUJALni1BVGHK5GyRcH+RXZ1il5eSn1r
	LRlp9JsLQB7ax6oCVB/+lxT4bfDAmYt0oAolG4RZvK/ELf6NkjhbTj6aDoa7pzI0wIg6yn7CXlp
	QHlteCiVaYcwiYxL1XjMiZ3QpK/5y2LxTupdBHa6V1pN7znMbGvgBH6BRdEe4xvWPY0qlo+csdD
	M/Hzn8amFKt4nUKHWI7FkSs42U5R1uArHZnYdZQ/XincmaUMZtZLisBVENmcFtC4Y2Q7oxFg324
	NIecorEI31jeU=
X-Received: by 2002:a05:693c:3104:b0:2ae:5b88:3499 with SMTP id 5a478bee46e88-2b48f6d41b6mr882336eec.37.1768359091038;
        Tue, 13 Jan 2026 18:51:31 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b4549fc8e9sm3001123eec.28.2026.01.13.18.51.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 18:51:30 -0800 (PST)
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
Subject: Re: [PATCH 03/11] Docs/mm/damon/design: document DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Wed, 14 Jan 2026 10:51:06 +0800
Message-ID: <20260114025106.81183-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152717.70459-4-sj@kernel.org>
References: <20260113152717.70459-4-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7AD00160003
X-Stat-Signature: tt6o879op6xtt146irbwc6ny9bipcsp1
X-Rspam-User: 
X-HE-Tag: 1768359092-211381
X-HE-Meta: U2FsdGVkX19n5fHQeyeNHl8uS8LYvfIIU2o0X2V1iK1Vk8Ni9tvqVLb60HyzV9oERK6GkDHhKex/KOjPGGM2h9oA4flG+TDa2wYEeHrx7OggUG6GILv1a77sTPNsR3sA+P2YwMtoQHqjA/Zmqdj5D39cm3ucHgFil2J2Qf0OGSoV3vI/5COFs7okd6b4UYdcyciy+JJdkSISHrSR6QDQ8Y8jFGQS+Upusvbw1peAt24gyMiKfwAgbPuIjLI3KgitTsO9qjiSwnjoFTeuZnbn3pejuhEe2N4og1qttKw5zIJkHyymkPttAochlcPIo6baVLGQM3h7CELC5lJmSfv71XJYqTWPG1vy+nqXiJKp7yYAV5+ID18ry5oCUzuBMG4lm55seviOIh2X3qKOF6PzsDOG9WkqirnOxwZ/tEBx49TJCrfGV5CYG2qOQ9bQdzHh0hbD/NL9cQ2w/kRnJw/yY6FMIB03wdxHn3W0/EYHLOiQv7trD5zWhDcNTE3jTihllQLH00at/8aDSDfUy3RJNuG/+B2pMRAkV3fJytn+gXz5msC1PRnH72F5K2cfKw4MpCQiatM6xvu4tkUc/Xzc3yABdCtVnTAYPi5YMbopdb9uPauGbs/sHjlh8lWjEvPRS/inmnzf+8qgLsIZSgqHgD67MbYS0bRVYOmOYAGJ9ejjPvoE9pQUawW9NrHgPxAQcNDjsShOv07swAI9cHoYCnYZyhM0zq707M6T4uxIjhW9WDQCYyW00j7JXrg1YmrwQE100LOT01KM+uXnCs2np/ta3aSl9Os7Ased18eknCpXDi2f813RHqBmFfYiQ1v65VJIR9Z/5gthz7dgrowEyPHcb83a+xpDi230fA7+kXLjMcDWAuYcfxqOgoljepqVPGT/qoluZdCyP27TLuL/Aak3laWwSAM0DNEjri439U6ELzRNDSBPVUrvYrmeGhN7Gl/YRaL50GXiXoWMtaD
 pYhQKHJI
 UKf0e9YcDEMeKdWvqxktQMy2XSVU5TRVwPIQKykNnedZTe+wv9B11sENA/6SN/GWc8v++vP+Y22dtJq6HNCxx0tYxRfWEjXq3WfX/tUW/u+nqx7kITXEitWXyJG0ttbqbVNjALr6nxTrbSvc8aSc0WDjBwttLJdDL7V4oZmNymOns8eDBM5yK1T8J/2vtgqSuO4EQx83RvsPJ03EasXThgcSV5DDvAoYv1y49c5jB9YrWSojF7ZvKg/SepofcKvhw0Fbs41kSWNQLKmb/6brdNe/2RAs+mmujOWZSWQ0b3i67wkTYrLBei+VZPgft3qCtfCPM5tSFY78SExe55UbjZl78T89ckaWsX5xvchYlwxoBPh0yBfVHOHhQfqP9PpZRG3Jx90r9SCwxO0GeAEjdJ/JiCadNqXch/1JxUFUMY45cZAwGIGJvso36ACh7bG8dapg28kC/CZuUc+bE3m9f8Wc0q2lfuslAWcRpWpGfq3OLg47IiTv+6zjbQMrB8ci01Ce9FrvvTb1ERVFbbPZdGWPSl2BSHOqo/cUH9HTfBjdQvKXvMGhJXq0uMpcSEF6LGdVRAvpQM+ixs0byzrjPsuKtimn5FUFbiq9kge6CyAuSfCJN6SFe7npWg7ZXfP6AhPExOt5vQf3i0in3HjngUReIuqYvKEvgiv2mZ/iU9a5X8FiwMrDwEcwIfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Update design document for newly added DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
> metrics.  Note that API document is automatically updated by kernel-doc
> comment, and the usage document points to the design document which uses
> keywords same to that for sysfs inputs.  Hence updating only design
> document is sufficient.

> Signed-off-by: SeongJae Park <sj@kernel.org>

Hi SeongJae,

The documentation clearly reflects the definition implemented in patch 1.

Acked-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

