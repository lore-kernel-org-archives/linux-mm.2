Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C97CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7856B008C; Thu,  1 Oct 2026 04:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A885C6B0092; Thu,  1 Oct 2026 04:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9767B6B0093; Thu,  1 Oct 2026 04:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7CF6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:33:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3009A67D1
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:33:01 +0000 (UTC)
X-FDA: 85273392162.15.673C81D
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf18.hostedemail.com (Postfix) with ESMTP id 337B01C000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:32:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=iLbOe3NO;
	spf=pass (imf18.hostedemail.com: domain of "prvs=72778446d=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=72778446d=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790843579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AcNDqeJqycLPgcWo0w6spdygMY5Og6ep6m0g2qt0Fs=;
	b=FvQPVK39fGRv3+e94sHi/r57th7E68LpJ62YvSA99f7sxpbdmeJ/JKOTgpidRxIttbVYWs
	ryMLNnj1CRKrUZ8eYa+JOXkHJr5PEDjZAsL2u+Njx4CaIuP0GML0gb2A8B4A1m3e0TMRQj
	ZRu0TnJyoO7Wa500h0GbKW+pp6fYfM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790843579;
	b=GXmrV5OiK7WjdSLGDIS76SaJBSF6c2dwHk4e3t8JqdNh4+PLKz99f67Ronko9jjbPqeuHG
	Gb3Bm5U95UY/G7HU1Su9S2LiQYVCdY9A1IGjbHFNZ8nL7Kse3zqR0pTEdxeTDDE22aXJVr
	KXPU5z60tbvWcICgmcJlOfH8t3tfp5I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=iLbOe3NO;
	spf=pass (imf18.hostedemail.com: domain of "prvs=72778446d=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=72778446d=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1790843579; x=1822379579;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1AcNDqeJqycLPgcWo0w6spdygMY5Og6ep6m0g2qt0Fs=;
  b=iLbOe3NOu6l5rxDMiatsNDnsFKSn3+NjpWWcYMeqPCqW+sZwFTj02kOM
   4h730Vpb7z+q3BHwQuciiNpzXm1L7U2TAvizAsgQaD1BDdIQYtuGGA1IQ
   k/svy8TwoFenAgfGZMptaU13Yv0vEmeR89WxAW9sXWGx0dIout7KDWxzF
   TD4lkQ2xTSvGVWUSp2Zp+hf9CPKD8bbBk0O8yvv+cPDbbHwcAZEmzR9Gu
   YFCGMbGOf3awhzE9CVqjRR8E2f3iNZZ4Qvy0LW0tCk7UKXbnW3jIWQDFL
   yoP6NEXSszbAloiFefcXhHzuqTtvi1u32HLIQ3N34Km5AQoBMYlD/mrQc
   A==;
X-CSE-ConnectionGUID: RdSEhq9fSUmEovqNwHA6YA==
X-CSE-MsgGUID: O4aa3J/gRK6q7miLgl890A==
X-IronPort-AV: E=Sophos;i="6.27,134,1787011200"; 
   d="scan'208";a="30023040"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 08:32:55 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:17289]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.157:2525] with esmtp (Farcaster)
 id e186863d-f635-425e-adeb-010d139eebf3; Thu, 1 Oct 2026 08:32:55 +0000 (UTC)
X-Farcaster-Flow-ID: e186863d-f635-425e-adeb-010d139eebf3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 1 Oct 2026 08:32:55 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Thu, 1 Oct 2026
 08:32:51 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
	<ritesh.list@gmail.com>, <rvvandan@amazon.com>, <stable@vger.kernel.org>,
	<surenb@google.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Thu, 1 Oct 2026 08:31:49 +0000
Message-ID: <20261001083149.2918529-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260918143502.b4fb3587b64e260e14485348@linux-foundation.org>
References: <20260918143502.b4fb3587b64e260e14485348@linux-foundation.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D037UWB004.ant.amazon.com (10.13.138.84) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7wa8xg5pukyegm7pnstmgiywzttzrpy7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 337B01C000A
X-HE-Tag: 1790843578-533704
X-HE-Meta: U2FsdGVkX1/x2N5M01qVVXaWgnpu0ox02LTqZO52fcEIVPK7oyGOKMc1LeIaypa6goPrxm1I5vT/b1rwt7l6vKGzFM7XRTOKGh0i/B270ddEAQMQ1JC0xPFhghSt3Mj3vxFb30w00M2HIWuY1w1aIf4ibfHIe4C7fVl8Ojto/yBW7G3wYIHIKqAbEDlQB2XmFIlfmnLSJ+TvwZq/8ibghKmdQSTcpbSs/ueb3T5YOuNj2HB0NTeaElzdeR+/PPv1GFzqL/z8ZgyiKP16Iv0Viy0RGYiLOEH7ryOXZWIn1BXymKjDL+aTnQbedSeXo/Q0DV/7rx3zxlMjz4W5oyOqWxIN9UcC3eLpDlA0oRcooUL98KcLF+Q/gnY07PQnVcOC+JZvulxSgj6EYfI5LhBR8EAaq1uJaQfrSNkjOk0ma36hq0p9NRPVN06ECGpXffmk6SjT2U9m1hX2A69qIAlyC+FnQkOHlIiethYxEevz0ovIyuH9FhS1abvrVNwWyyLzdo9tuAZO3w0cMEIuuQ64/gG20dbjpkq/qNhJ3Ff8+49cEHAQbTYoTU2+2Zn1kJy4HnPvaxs4ulb2FyI4WJCuGjLNPLo1bdrbPVGvxn479+1wmLQODTAFQTh0kpsD6H0AK0GyiJqKLhjdcpxyujjBUSkXA/CFl01IIBmoFOgJvx6GLibBym0ri2P6oYEs65maXSwUDE+k7VaM/e6vmasqp1h+YYTQOPQrV0llJ+0PEHejdl38MMcTC0HeWdur7uKtoQZTsEYMFvW8OuY+6mDnaRAtaI1aee4z5oJ3uZ7ItJLppYkwgaMt5G2l4MQSXPe9hXeMB+eILzDSjbTxhhyAj9IRRFtNvze5o19p+gX6qPWRvlI6yPCD84oZz/6ihG4tD43Oo0cuPOkLQiLgPAM4Fzs3+UmH3NNkbzfAXSypLFQJRXZrIiEgDhVfdX/MhU2RhAMm41sCqrf7u4IN8Ml
 SsGnBN/M
 Qne3aACjIK9Vwphdm7RnYwKQfwAw5pGgIaBJ7dLY+WvuDLjt0W+dS3CKXWUFPQnd+boAHr2hN94u+anW43JBbnNfJnLXHno6kXAX2az98jeHfRdEkCNcvU/DmmO3IrS8/LwT0I4osjnbiwVK1reM39JNxJUaNUqrayv0Uof8BOc5CeVD0/jKY34eBvD0dheHvHlL5D0tjmqvmhvRH86T86BnJNvlO8a9lfr8xLSh27ztwqbi65dKynWqud2mMf98P47u8oO+sYCHvUNVVsKXoJ3kVN8aCYXYln293gAV1zd2NOyaqWtX7i+qsdfi9EIGT9yjGM3nnpe4ZUJlUdeVBh2QahfBPqdVvHQhHwcliTPNXdhTFcVcCKcUt7EPxlDBkg9eZfoEwrX5ITIZfnO5zdun/5HUhyBdM2ynN5w54cj+aYJrjokdWJbxWeY27niNbm0mtvMYbXO7YlIKpk25H2Dux0Nz1CUoHjtNhtY6Nl8W5kKmG/oJ1mPUVx5lVDjclaMiEoagjAgw59Ahzt3gIuFqJ0zmjZdzFYgB4tKiK7mtvnBrfO+WCKPc5w7G5zB6C9h+WftT5yp9Zczkw2cyDyRpZJvrZ9aW7RWVkLJPBW3a07F6D7Jhhwku2PkHi7HNMXgDsW0i9w4esDCmwV19Rw816NoXC5OsiVDq8Jl7YAn4QrJzxti81bUBNA2eRK3DsF5ss7O7LgX7HYK97vVK1dxoxUom07NVuxtYB7CpAhdvF21vHwSlm18vdKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 18 Sep 2026 14:35:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> So a clean v6 would be best now, please.

Done, v6 is here:

https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/T/#u


Thanks,
Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




