Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D77F531DB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A90A6B0098; Mon, 13 Apr 2026 18:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659846B0099; Mon, 13 Apr 2026 18:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F6A6B009B; Mon, 13 Apr 2026 18:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 486366B0098
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:21:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB23F140302
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:21:54 +0000 (UTC)
X-FDA: 84654956148.23.54916EF
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFE4140005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:21:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mYg60nY6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776118912; a=rsa-sha256;
	cv=none;
	b=gr8WtO5zr9sBQ97YcYDVHrCp0Tc5gvKdY9HSFD2izmo443X9ELsumx8m/KbHR7nWNcQ9eR
	i7ZYwiLCoHTebQJnRv09q2z9j2C8vbg5gf7rYv8FvOsOKSWWRTVGacboJVifTxHnL6+l94
	M7ZbNzlrJHJbTChc2AISOQvWwWAA8D0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mYg60nY6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776118912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwLpBaCZIwWb6cQdHpW7oJ819o8OWj5rIFCXB94lyHs=;
	b=hy7i/AANYfWuOhN6V0reO1WRR2ijUgsFuWICJaMgB59Y1ONdpgCtIrs/XnNDOWS3tRCWZk
	5pEzPEJnHAGA3QIY/DRMZF0MgKMN8BGrFTHk6qwENMin9MYbHBn6cXkFsbA9VUNtb+d0HM
	QrDhc8wMi4TOUxy5k3/IpleP7KIT1Nk=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82f4a53ae20so711424b3a.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776118912; x=1776723712; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwLpBaCZIwWb6cQdHpW7oJ819o8OWj5rIFCXB94lyHs=;
        b=mYg60nY647ujB/K1JpL8P4w+UaQZM+AZNRnsDoREfqy36oBZGcYd+OwU4Aa/SpqlZr
         aUEx2/MOoDOO2aW4DjEZSnIT+Qg7rj4AHLmADNwXl+mXqnLdBN2XH7ZrOzyhq0msnqin
         X0pwYbIhU9nehwvnwQOMICbCXOmkSVXcVDvTSoOgK/XnOZrkXYpqHgAn+ykNUI4ijXlz
         HHo0He5KSBQ8Ajw/tz1PgNOCKRGiyY3GsHKEco7AQXdbtgV5xaUNuU7dhUfHjQff6zqI
         Pz/6r6Z6UGkxhytMtzPtSVWT6eZHirotk53mhu+FDHBrWgsZ31sqZvy7Fu1z0UeMZgpX
         6+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776118912; x=1776723712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DwLpBaCZIwWb6cQdHpW7oJ819o8OWj5rIFCXB94lyHs=;
        b=EomKTOFelZ4ffQz0saIGpAJGEHbpcNhE2p1DwdwiCyrq8CoxEwzPmwoVawvOrLyyzS
         /tGf+Ym3ZP2sccVe0ohEiwkiFJB+k4XO+g6UhG8GB1xpDb+HusBn7LSsUJ6sCIDRUoB2
         CTxhQH8ctk4k1HeQwnj/wVSEnhpcCZamZBSWaR9RvYIldNzjDW1GyURpRrKU5dCMzeZ1
         YPPkgtoQxJljtB7PNMWPDxLHGddIjEc4SfDBlGqEbZ6ZgA77dCmcONFO1ksXFoRVULnz
         pcf1+nCjHsJkoN/znFV7K2xAqYf69zrN89NqXIUMykb68apZgJT5Ix1ZthUX1ci4KJP3
         Tk9A==
X-Forwarded-Encrypted: i=1; AFNElJ8sVkE04VO3AbsNreCWIMKc+tKY2IXY6+qQaqBh8ABtkyHfVcO2Bvp7xzCpgsSGQn7mt8GTOD/MKA==@kvack.org
X-Gm-Message-State: AOJu0YziW1CV43cr30ED+zKBH2ir0pyuyCIgln0HuE17+A4GyAJZRUPN
	gSs1VLVuzHmUnF6U72/ypxZPF20ujds01dyChNLmel9jhWA57zhYuT/I
X-Gm-Gg: AeBDieuxLd1r9nJ13V74UHlOcwmBAjyklbNUoni0ZZkw4ba5lRCW0juUaAe56KtHqUk
	pEVdXsYWHNst28ZA9Vlce6Cr6Q3Utj8FX2MCb673pB1xfRPy3edrbRBWsOGPp+pEti5/MfWH/ft
	zMA0ZxxZobv67LyO4cQ5n76/5toPoHRrFhgflONzbvdTmVFu0rHF+B+XJ4A1u4y30SEhoKHVXK0
	33n0GwR0gAF7yvxSOhHksWQO1kiDIcqXJcQc1JOYpf2iQWIuU8ooUmNDgmxhdXRbbccHbNn7Ecz
	d7EzZ3Z4BG0nAOSCoU2od+NVDJFZe+FPqh1IF0LpmVT2zx7Ow9bP03uujs5mlLXR0CfM3eUdARp
	wQupMVJapufwqjEVrPQg0OFSbnM208V8cvDrLoe1koLFW72GFL/BGD7bppUxvONIzpUG2qDPWS4
	Av81+7MdrPjx36VIXjEGXGK4r527IHNQuHoiURIFfjzBTz
X-Received: by 2002:a05:6a00:4b43:b0:81f:3f03:6838 with SMTP id d2e1a72fcca58-82f0c219501mr15642444b3a.15.1776118911684;
        Mon, 13 Apr 2026 15:21:51 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.18.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e1a2dsm12737206b3a.44.2026.04.13.15.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 15:21:51 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/migrate_device: fix double unlock and remove dead code
Date: Tue, 14 Apr 2026 03:51:43 +0530
Message-ID: <20260413222143.39312-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7579105a-1261-45db-90ba-5e660d202b80@kernel.org>
References: <7579105a-1261-45db-90ba-5e660d202b80@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DFE4140005
X-Stat-Signature: jb1uu1fw1nmw1hnydrm6sbaxpgdi7rnh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776118912-79419
X-HE-Meta: U2FsdGVkX19a4KTMvroEgj0EG/BjAHPzMH/NJ3AHp3RhUwNo7jTfQUYBzKSEbnlUH7ZRzY5TnwbSEbpjLyaTVUOezS1Z0w078RxyykKS7gvaHc/sxTcVzSH1s0zzkfD8aVq3jBHLtAvkBk46brFyhvJ/YqoOqqBdg1zOezEofAHQmqcgU+7vpswxNr20UXmht8tUmPC4dAOQb5dPwnxt3l1GT7SmK/NyYnAgUylu7aUahAKaloO5hO727akRc6k8fRX+8XhOSxcDah+gqmOjGYIO2szLxdr9ZvTX8LjeZqtwJEuR2AmuEoNmZKfQ/axUOekKf5M9LAePLr1Wlat7604OatBCSpexzTPWTfmTCLWUqZtUa2afno78vlMQAlOavfFwEWo4uwqk+WS7hl7/WY+wH2YBEnUsdVhOiInEI4tsGUpivbNy7JP9BSDfF8FH6Pp5gmgoa2dVANXXA2OUw2wHFP78t+e4RuFjOxiL2EJ2CkmgemNZakQk4l3tllW8LgMV65dVstvjPnJteJ22ltoblBKVqX0h5nVcdmYsNJsuD/FWlWY77Ptx5T8bL6MODAjeMIow1bq0hLFo+eAzXqy6GnDW92P0KQLR2M9+OdICZyaPEZ9ogwWYNEBfC5g6tSnmGcUJbYtyCvfeATQsGx5FOBxO6hhuFu2uXDY8kChYvtyvyDMJhIeYA69lKSMe7JpXWlOCnNRwFC81E3dZw5NtJjQICMtLHQyXaC/sFAIotKb5Wj1aVEPCAtdvHpp5Oqksb4SdUreTClkg2izyzQpQn8iHmsaQEmnKlGJdoovrv80UFtF5Cr7fph1SHpZTC021ytLm0e8kj2MaSd+J02hZ8B4A9PIcfiTklgew7ubTJrXWDixLEAm3xZkFPBkaTRDgt861wpYTHa007HXdLg6lh/yQPXENlPU48UbHsJel8KbET8EamEKorrT1aEME14B4+OT8A9xKULmnND3
 TdB3wWVV
 wnjNJ72YBvpE6n/KBy24AJ0yTc6j2m1a0f7U5rfz94ps9qmt/rkGZ91PNJV4Av6wMQlXmvLPo8hqnApsys3/l2w/aToGn0pgoPwTmt6C9P8lf0Ei6ZBc5vw9XqQAvyJlLp4SVY3Hh5jjfzBEbid/SsuYHC7vl9aki3e/iznU4CTUqHUG1KsYPZ3zMhz1XkwWNIZWeRjWy2P3linq7cSxGUZGayKDyrr7PJV9vnfumzj544ALUVcwrc3pac8uvSnpjCFy0BCE0Pe1GHJQRp8BCobkUm8Z1CiB/TjBe9AkiJr7bX+bSCeqd5A5wgGbaR+ADBKRnZ6uWm6QxrxW9hqiuR1r41CiYQRNfDz2TCFGW5RIIXLelgQUOwmPVH3iTAwvQj5F1AmzU33DqCfIoOZ3R1nDok2DlWrkgvj0HFoaMxrBMT4wxFFydp2HcVfSRHhobBxzKZhPuM1/CPMFmbWcWQxZU+0FICycAOHsfeIToXWr8NLZT8yFuME/jnq2VMxBzDr4jANPGrUAXr0BmCJ4dBKVifDUeA3exxtKPVd4o4SWz9EE2IIifN86b3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 15:09:00 +0000, David Hildenbrand wrote:
> Can you move 1) into a separate patch, add a Fixes: tag and CC stable?
> I think it is
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of
> zone device pages")

Agreed, and please refer below link for new patch
https://lore.kernel.org/linux-mm/20260413211559.20969-1-nueralspacetech@gmail.com/T/#u

> 2) will then be a pure cleanup patch.

Will send cleanup patch shortly.

Thanks,
Sunny Patel

