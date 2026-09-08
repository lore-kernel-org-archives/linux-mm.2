Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6884C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6C66B0093; Tue,  8 Sep 2026 05:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1512D6B0095; Tue,  8 Sep 2026 05:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F716B0096; Tue,  8 Sep 2026 05:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D33CC6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:55:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53F80C049E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:55:41 +0000 (UTC)
X-FDA: 85190138082.13.0025FC3
Received: from out-zbxj-a76.jellyfish.systems (out-zbxj-a76.jellyfish.systems [198.54.127.76])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7A556180005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:55:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=nIGz0OfO;
	spf=pass (imf24.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.76 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWGFkYcxEIlLaqPllDwjUUW2jFww0HewQT0w18/ydMI=;
	b=656AlpwIEDABQ9T4AsDJ2AzJewTbOm+iU7fQcNVEGE2efYtnzzd7eSwcSJdcPPIBcCxsvw
	OEXJPp6kMCjeOqMExvpyHsqLoqvQMBHvpTnKYYGdqusRaB7MyGo+cEoZOse08Z8O0ha63B
	SSF5B5DwY3f8T7IXo6ZIOWgp6R6GV0Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=nIGz0OfO;
	spf=pass (imf24.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.76 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861339;
	b=IZntPNCDwA6UK2D4Mr5eXtr271VT2+SXwRw9mSAuFitA8SDMprw4UtS+Gi8kLUWckds260
	6Y41PQWD9NUfvKk/KA9vbbt5ocxeHxt/WJ2iFwuF+rcN3KuelmeV8VILWz/LF+9AmyTQVx
	zYXAtyhAILDdI3WE6xuEWK10Mzquz9M=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfK7P1Plwz2xLJ;
	Tue, 08 Sep 2026 09:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788861334;
	bh=hWGFkYcxEIlLaqPllDwjUUW2jFww0HewQT0w18/ydMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIGz0OfOV3SNCEMiAGIXJXLmcg+yjDoGGUT4qvi1zY6IHV3T1pkIq0a8iVsZbVHqj
	 wvzXgql0cZ6A+YKEZvxjCtJDXs1JVsfavFJ4rlTUte2YWJyGX3huaCyxuyLxTYKqKG
	 7UDQgw5fvDTn52U2oQeGOsKwnYkf2n8mj3DOa0le612/jPYh2FuaO9FF6FXqycziXw
	 a1v+HOvoDPemb1Pkjv5ZIR7LiWBCb+bDYsO0gWIczfkV38e3c7vrBsQBZmdmUH3XzH
	 l+I/YTIPss3cEEI8e5Xkopbthy0C1ky1uhtGQ1SvNGDsePb5uOHUSYJfBhoeULIhTl
	 PNSEe1dMf9LZw==
From: Tianyi Chen <hi@tychen.cc>
To: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hi@tychen.cc
Subject: Re: [PATCH] tools/testing/vma: cover hole filling through __mmap_region()
Date: Tue,  8 Sep 2026 17:55:16 +0800
Message-ID: <178886112560.138404.17928228712742724255.vma-review-reply@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ap5pmX-RddQ-c90O@gremlin>
References: <20260906144100.849288-1-hi@tychen.cc> <ap5pmX-RddQ-c90O@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Stat-Signature: yjk45b4gca3ihxof9r78w7h3gy1j9iob
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A556180005
X-Rspam-User: 
X-HE-Tag: 1788861339-406358
X-HE-Meta: U2FsdGVkX192NlBwrdZEqP7aOujZeVKgvIK2teWWUjUzItMLid1vq2u65CHdRUa3YJucN9w3L9FKJrW0PNx4pSJ8StDvmXvVVxSyEx/fMSrLnlla7MYyzSpIcoynwztq+bp8mE2iHZPWD1KeSRk3hCUIevZr3ZNYCI2GKvqDgJ+bagahsZcDRnO5DTfG+oYFpaz+FjZDGTo+IHwrujWJQqcZ/ZifUSN/ygBZWpWmZWQAfNxEyXrduHsqQ8HzMsAdSEgHrFIIp2xDOPO2TDY8hY9usGdSjJD39K24AwyKdlwUd+FpwikHH+jFZ/psrPhnODI0XjyQ6WICVO63SLOQ2NbmA/CMvwyn1/6s7eg4FA5rg5PIKgV6yp5Cm9Hom1gAmyeDgoxW4IQBubVPiASNKzTS0wyFKZXtaJVyUFWqS71r7TYZqNSw/AeeXE1W1p04lMu3oWpvfMSn+r/CeWsFDchH3TKIYcBCzgKqFrrfTZsXX7Z8cD3HinS/6tZwAH/L83tzs5D9iEjpzUpBrfsdRdCPtcX1kfvkRnBRyRuwBtJM43KDQfsF8FKDQWBf5uyCkXEHTRRUNgFFEXac63v7oJiMfg5ZBl8esIv2oFAwBk47/lyc28lgbU0WasUesGYWx6oM9hRNiPep/prjdNpNK7E2qKjAR5ooTXGUzs8SQ3kCMJIu6PoCWJGvygzobceXXWR2JbCUBHsVVJOZWiY8BHajUPY9x5uPhdUFSH8JQnGamMqs8G+1QIoE15CdWUk2x6f9xCpL1SUAiCuLvRsRZL25zOicpmkx+/ad/8xurue6zBI4qgyrtnVgkPU9yxA86syGQKPIINk59bf5ZPV0/FU+Jkg0Hm4gvVcrm1PiqsQ7llcE0KFfDqo0AK1/eTLcW4k+xv25x4hnUFay4t/ZMgn2KK/qqfBunVWvWcm3r9YbFXI0lslS8TOwTxlMIUt8OayXXJUm0PPSbQ97QlL
 uhpp4cu+
 8PanqYC55x+8zxWkjG9gr/a6Lo4XidY45wN+6pUMCRNKmxu/kXipSX6EFwq9vVuCFoM202vja8/BpjIj6+Svtn6m0aiTxNYHMVqZ4KE7JyUl5Rh0OD0/I9hmlN/ybhjiPk2DywLPuI6cU/ie60uJtN+ZaGSXq8kDpgikWoU+6RYTG6ETWb2Q9txmzWWucysh/alffdo0Ts/LUeXndP698zSM4hGPAZv9iiM4rja+NSZsdUYlcOkVokw3TQCriPvaD5SgL87ltDPeJH+4TzoBo1UuVvaxpUk7aKPEBBypjs1epJedAAEAe+wLWtqCLsUkQwLBfKcjIzLVduZzxl3Kg06XEQKAEjlNkl/Zt80Fr2KkMmebou1Wejh+L7jCqI90Er25cmU9P7fMQ0sOSjmPB4oHQUkVN2ElH0M7SdcJZ3SDajygYHA32n9fk/jhnIRs9E1rA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the detailed review.

I have rebased onto mm-unstable and incorporated the requested naming,
comments, const qualifiers and simplifications, while retaining the new
/dev/zero test. All 29 VMA tests pass with ASan and UBSan enabled.

The revised v2 patch is here:
https://lore.kernel.org/r/178886112560.138404.17741948638665342936.vma-v2@tychen.cc

Thanks,
Tianyi

