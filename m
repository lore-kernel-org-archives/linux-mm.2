Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B1B606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=dcMdfPXn
Received: by kanga.kvack.org (Postfix)
	id DAC8D6B05B1; Thu,  5 Nov 2026 14:12:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E416B05B2; Thu,  5 Nov 2026 14:12:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C906B05B3; Thu,  5 Nov 2026 14:12:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A358F6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:12:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7B9CA8B26
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:12:36 +0000 (UTC)
X-FDA: 85402011912.09.A862152
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	by imf18.hostedemail.com (Postfix) with ESMTP id 695AD1C000F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:12:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=dcMdfPXn;
	spf=pass (imf18.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793905954;
	b=ulYQJ12eUEJzZmRped/c86/U4YWdoZfEhaMWjzdE6pSfymao5kw4ikXfRei9rvK9WsqLNZ
	XZt+6Ug4woFgrq+Wn5ZkwlBk0F5GsfedhBbwh/1x4dPRZdOO21qdyYg6zyoLb2wN1dtOjm
	XTtqwAneKBcQdMYay3SSNTDWE8/Y5BI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=dcMdfPXn;
	spf=pass (imf18.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793905954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CeXz8onmx0GjUbQmMDjhDtvEqqOc02tfY/WFEpYS+U=;
	b=YV/dSku5Haz2XVCHWvksWKxkBvjxZjIXpI6fyyJgW7QcTZ+P1Tm8d11F64C3vf4wbtDtTA
	XRefSpxxlnReQmHqpqEgeStYCCbuW5SF9EuaDakZsQ4uMLIdfyiyrXYFwwWDsZR1C1psqs
	aZ5jyEhClAKettp41fiYDf9/C2RIlQ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793905954; x=1825441954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5CeXz8onmx0GjUbQmMDjhDtvEqqOc02tfY/WFEpYS+U=;
  b=dcMdfPXnLn/SC6rORMMoxv2RPoHXSE7jgiMKKNmF4gII4B0JsKq4B4cr
   H2y7RKSLmji4iFeLrB8liFzBg9OHII7K1vEIj0qsd5+oP3H+40RYWkI41
   AMOSw2Edgmc36FxHAES//1sLBUP9ACMJOODg2nt1Tvdob3vO9c63WfYBj
   X2hCwD13Xpu0UItMbnAxNiCaTgl5aQbO3jkE3LbiEFQP8H79XelmlblHm
   DqlSCQEbztyzk9bb4D9hFCYEiLp+Q8YQOlJtwY9jhwLF8aYzHuDC1u2xD
   UFxPUBxlEf6w8gXqdPG+STNAumymtAbl82owpR0VaOTupNqJ4kmpDySaH
   g==;
X-CSE-ConnectionGUID: QNV2v3RwToC2Q34F/9Phbg==
X-CSE-MsgGUID: iAvjnRKrRjG3vygHqo3ljw==
X-IronPort-AV: E=Sophos;i="6.27,197,1787011200"; 
   d="scan'208";a="33006063"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 19:12:32 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:27964]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.208:2525] with esmtp (Farcaster)
 id 5c580cd9-511c-44d4-9ff9-4e168f6574bc; Thu, 5 Nov 2026 19:12:32 +0000 (UTC)
X-Farcaster-Flow-ID: 5c580cd9-511c-44d4-9ff9-4e168f6574bc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 19:12:32 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 19:12:31 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <jiaqiyan@google.com>
CC: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: add htlb_dissolve vmstat event
Date: Thu, 5 Nov 2026 19:12:21 +0000
Message-ID: <20261105191221.1010676-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CACw3F50bfsm0pZoEYL=y_9yiQ2XEQTjCE=496D-=MJbRnXGhQQ@mail.gmail.com>
References: <CACw3F50bfsm0pZoEYL=y_9yiQ2XEQTjCE=496D-=MJbRnXGhQQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: aiq9tqrj7d53u71ni1e7z3873j3nchcs
X-Rspamd-Queue-Id: 695AD1C000F
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793905954-944973
X-HE-Meta: U2FsdGVkX18L98vrBOTxOi2hcUgp9shNkdShYuRFUL4JiXgaW9Rc1V9ZmcEdBdaC2LPWZamqLRdpErduFpGzRq1TGiVkWdw2jmq3g09DlYTakffyWL8O2yn+52tCnqFOGX2p5T2tFcdLUJkqPI3PBMroi920dQrEhaBPBEgSTKhR74XLMH3PSj8c5oxVqS+/WWPqlkCZyo5mFPBTCmzSPuFy8VY4nXDIbRUvshk4dz6JcwtCP5ezaOUVmkh5956vSa+J5Y/Y39JflEFLXoqWqY0V/XR0wU/XqN/LzXiDPhLy/d1NMWNUkbJ7V0B3O43pspyYc19FAjhB1kjsRzzai2Cm4PYaEsbn7BtdSbAddzU8tWUgUUaTM0OQKA3ETfv3udj3w/2GZXNWJg0DSTKmLGOVkhxZEhLVRW3ycDUN+vtbMJC+lUB9RjgGrPB1fTd99vrk2qxkCcmQqA07SttTLFLyXqycv6I1Y4JKMhCYKKDolkynpZjEq6tEzCFCo3v67bXPqJinkFIsKc7sjbpxzeF7Sa7YU+E30NiXclxouhESO4RNCfEkgHXjPRGCO30AneEyYBs6mDmMp30xak0j+U63LFoT+Huj+QBy/wRJSLTxPeaCfgv+GmNuzgMPUPYLoj4sfkcw+9hQniUGl3sh8Pklpt5D5ts44DFpTOKM8k0oXbm9+u2ZK8TLNQUTCKZ96D9fUj5hBmJwlDIxBWRzdsJ8c79oMrEUzQ2pkFTGZBxOjMHZ9/qJAps0znj714QylCwphxowbQApqCwgQu7ATyBeKquw+FYeWdFr1PWqYuYP2DwaMOjHoM1oELqo1eIxzlPcq6HPPjGGBjbGt01ces2WqTtH5CGiAToLWLCR8sqNqdTKs940H3beVMWpNfZsTGa34Ie2kHUVBFWc+HDuNldOKYUpO/sbyx5rUKYaZDRCj4sfLveLw5E7NJE69d4f9QBH5+H/UgrKlshr+Ww
 8immPDZ7
 AGswbxlJKRBGzfJKL4CxRIXEad0/N499//zzumvNpRecW5KjgxLjuIbJew0cMgbz9txagu0tP1rC5gZuB7nNOcEXary5ZIJxBEle9OEKnQkWsS+ULCb18cmjh9Ya/4iQeAX9WOKfoil+VYwbSiCbEpNKfA0XL3VpL4qWOUOV+lX9L3xoVa0IEzJOkSVk0LD3ZHNhr0OsMPMITcX8yGyV4/eQElX3Sj0ABP+MCJkiiESqZeUiQBpMEnKnD3G3vHCr5Q2R3/7z3ZBiCF2AsfE9M1e6hKg5FRhICVTwRRdmHRblvPrHBYcNAPiEpEmT2Gd7WPNl1sIas9mQQjGBi4PU97rpU3nedib42bpRfUg1ITtmCtVkFhJDVit8KYhMmQDNDXmRCB5XHA37Ju1YJNGNL/1kYrImATC2pjlJ758/sprkaryFylYuPZwgkj2Eq2KMFRrQCh+MYdB4J1d4LJUOpN3vXY9dmeo1CongD1FzL4mYBAVOZJflabDCrW0lZPhoiANx6UKIjwecCg3+mIGc71KK7OFBdbV3lNbVRl7xGz1UK/Pf+4tip06XZpz+iPCnGpuQBnwr44AOOQq9z8B5R618Mzus5HCgByedc9/RPZOikcRpi5xz3J0Kmjqt1nw/w5WhCDNhwIN5vhg9rFXBXYimpPDE19vn8j8yHhdc/5a+njCwsyo23acg8H/mijvpmbojp86LPZAOdOnY+NQQPvgpODj+itle9eeqg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 09:46:58AM -0800, Jiaqi Yan wrote:
> >                 update_and_free_hugetlb_folio(h, folio, false);
> > +               count_vm_event(HTLB_DISSOLVE);
>
> What if update_and_free_hugetlb_folio() failed / bailed out?

dissolve_free_hugetlb_folio() already rejects gigantic folios without
runtime support, and restores the vmemmap itself before calling it, so
the only bail out left is a folio with unreliable raw hwpoison, which is
leaked on purpose. That folio still leaves the pool, so I think it should
be counted. "frees" in the commit message is misleading though, I'll fix
that in v2.

