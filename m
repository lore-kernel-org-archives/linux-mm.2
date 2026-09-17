Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464C1C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53CC66B008A; Thu, 17 Sep 2026 10:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC3B6B0092; Thu, 17 Sep 2026 10:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA536B00A5; Thu, 17 Sep 2026 10:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15B0C6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:24:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9144FA5451
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:24:35 +0000 (UTC)
X-FDA: 85223474910.17.A8733FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 74FCD4000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:24:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AHIQSD+h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789655073;
	b=GFsLJmCdN3vu//+nijUnb04l7c/ZuJhi8S/82AXDbecCz653pua5y1KBczPM7/IwotelW0
	4MCDdpiCr/ZuT6OZSOqMz30VKGi/TTNiZWqHT7wLE1IVVvvC6fUOy2rsiivGwcMP6bF4pc
	6mwIs733ut62cmOLiWrspIrtvLb3cRU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AHIQSD+h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789655073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jvbgmg7xBtScoD3A0f2vhmMoi9r4XqdACuqMBZf3Ck=;
	b=FRtF283GE76fNMP5O2B7cgam246YmTBTTVPP6ik1D6Fw+8qcPGrHyXljjonQSUTwWJXcNO
	n5/2O6dSg/kDcAY0/8YdUXG9FL58/H9pnazankFczaTvw8tHxiTP+80Rq6YsG4Y+JurkPa
	vyD6tNAaCph8pfhp3kuo6r9M/QZLpNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1609160210;
	Thu, 17 Sep 2026 14:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C985E1F00893;
	Thu, 17 Sep 2026 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789655072;
	bh=6jvbgmg7xBtScoD3A0f2vhmMoi9r4XqdACuqMBZf3Ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AHIQSD+h1jIAoULc5w1mw2MyZqWiLrZtHAKmAcoKDntOnOeV0+yqpesaoOoMR7eVi
	 IpMHSZCG+c+ok3HLCcdLj4pWkmSj5+lcRf494LfPj5Th6eCASKd0UJEZJNd1OG6w9Z
	 B9rzrsy5CWHQANyIY7pgE6rwi7SuFoG/71O9vpD5E6RaCfRAduztW8rodtLhcSf6Cl
	 q5zPbZL+OamuWhIv4/BuI6c86ck139ABhqwv9BHZfszpLen41pzoFP8ghmtYnDpTvh
	 aY9g6XKoMfWhlVwpJASX933yAbx49rH8e5fKGxeRFXHeyOZnCEGCZDjKouhgRM7QGm
	 vy3lzx1yBVMvQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6F5261980058;
	Thu, 17 Sep 2026 10:24:28 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 17 Sep 2026 10:24:30 -0400
X-ME-Sender: <xms:G_iram7feomC7yHwoinUmV_EtURuOT0zCp1oq-VywvzhfxAriT5yoQ>
    <xme:G_iravx0WGzz525s18ZiaN_-9RCEPwRrPcGsb5-Pqd0s90r6kz8_b3jjIBEhiQg_J
    OteLnfpvNC1KosPmBSxjs8qlEwdV6HmaRVjtL7LfqqL2MNDtuZ6TQNQ>
X-ME-Received: <xmr:G_iraiw-7FGHmDWJxUNTC9kcBQNFuNMNLeA-qWZRyrZ9IaPP3rYnTd03ZyY>
X-ME-Proxy-Cause: dmFkZTFiJne9d7ut4379TdaEhOYJEfhNk6de6RP62W62P6FcjK5SF6md/cm+0pDsJ25MrT
    /q6b15+QdXJ4Q1HGGR/b3YzO/kHRjEJgJEiAF+bLeugjD8pgFSavNNW5zgHiVI/booYvZf
    kqEKROzApTaL7eavowumjxtah55MGiGQyJ0/sMX7tH7eTbOYHPwAAaPYo6WH8oB7SLZdNv
    s8uL89t5P21QtKRiN+SY57IOX8vl4IdH8LZbaBXCWmf80ijDQCW/BPea8fNAamtw/cwwt7
    DvTEPOpwvT3NLW8y1fDd58r+ope38dheM434OKaEhZ27no1CzKhT/lnNIik1REnIdS/Qnx
    mi8Z25zrHV6+kn79/GCdIQnPr6oqUUU67MmaMLSYY7Z4GH7aWCZkGwpB/+1CA4NVjY6omy
    CYFOfJgyetf9iqIM7ckIEs8i7/rc8+uid6ArZcOZAIsIcr6QbiGTwp1ceBl/3GvbPM3lZg
    Fw7oCJ/gsWpzA3/CGZ6QM5Qz+m3JAIU//z2KpUpI4YfwRLYNdHnc6Tfp54d652QoQtVwYN
    +GzoXKTcu55PdT3fa7PR8bYTLWlixiEOYX5J8DqT9Ae76+kAd+YLBBkZgcfi0EyL9YTdVG
    ST5pzni+bfMhUA8V+D2XS6NHTccps8iMVuAs0gRAptXOgIZvxUbVVn9keTnQ
X-ME-Proxy: <xmx:G_iravW3soFWJBvmG4AbpX0rIC0cOvK6wD7ei3yKMjZXYvRACs4Ssw>
    <xmx:G_iranRGwgxnIUqS_DVePtf7AhH_7oEw7inC343PgTqXMCytVCSnQA>
    <xmx:G_iramN9zte4BK_h9dAAH_-WqYZoVXN0xLZWha1S8k6UHPzWX6Dung>
    <xmx:G_iraswQJ_c-x_GaCZD00s3uuePekcUo5PCaf9FRyGLseDdTP07Iqg>
    <xmx:HPiraooHDiMj3vUXgdjlUgDQvalcmd_5bMD4uWYPym_kQj2ncEaytHCU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Sep 2026 10:24:27 -0400 (EDT)
Date: Thu, 17 Sep 2026 15:24:26 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/huge_memory: simplify pgtable deposit detection
Message-ID: <aqv1gZso6EwHEcoI@thinkstation>
References: <20260917054015.23553-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917054015.23553-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 74FCD4000C
X-Stat-Signature: 7rapo7daum84e8tqumgmgd496rrg5zfp
X-HE-Tag: 1789655073-786556
X-HE-Meta: U2FsdGVkX1+T0NzfZ0E3JIqGX+ZWLSmhC1QY5J7ZQVPhFxvjQ6XsjkWE/2DcSMB+TS9s81FbEEskkbFuL7yo/UKboZuOJKFgPwFf6mlDkZItpop1LVjpFc9iAmneXQnkVnIhfUE6TZkVzIVt2sZEv4AJ9qQlTDzRn5lgDnlbKTAyLHJdIrouZCPD+A7r6jCxMWrD5N8+4H8Zl2Qms+8FvuWucXcPh/T4unjXJIRvConue/oKNQVSGKCYkWv/Lmigy6Enx+sBt7V/v6QfmibXs+J1ukYRZfZuDTolSLuJqLsfLcq7bdmhT19isEoHFSjPmxl3IM5EqRDpHeVJXOn3Evm4shbgFmXUcTXKMkq6eB/qCR8U+hizwmwzE2VtVpOOEM87cn2StiHQ0z7wgQE8k8qR11A4KNAw5vTLSu+UzXq/fqaYfdWrivEQkwx9cF9nGaahFnNkoOg/59Bwq/apRp8Vjm1rY8ayegv8dcIqN/xdHK8MDrdkIMhDDoQvt4ZnpWkiY/XbLL81/B7PZjFBivzOpJ+BoQzcV0gNGG93vsCp74aPp3C7LNipF+Hf2+3huWEBTlwZYCcZsepGCYK//pmRaBtzP2i8UXiZoX2KEZZ7daBAMcrB2Fxw9vMXZPqTWf3usl45M5i4shEZQQAAn25LUTg3ncv53whJXMibmoKJbOee3iW+p6d6qUHEfKB+9cwPq+XBLPVyNI1+skoDgmcAQms2BKhF+xEFVbFuIsSAtHc7q9AJKLEtV8kmI7Mi5IWSJogyJVpEa+vtVmDabDSUDwbil9xmSNm6Xu41oDGgeOq7WxKE6uuG5bDJs1qz0l7mv8fb9uALPwIKoXNKi1ay2PmxG+lwkqHPWui6rgwMUc5pYOmBVYYFjIaApHHlHpjzprhVA6GJUOJp4HKVvn2h9pzSOTrbSYFlvaPRxlmCaaXIrfUp5Gy/R5EzkurWvq7NNrndAX+gdNCwvlW
 buUFVxzh
 9lNzU96xHGQWAJnWFz7G1brdUqBV7v9eHcDTa5/sc85TlGNgWdiEvwoxsos8yfMdYCyvd2Pl6hzuadczqVVW9WJmBYyvu9FSBxhMyjGfy0UOhwQzOwY4XUFI6Gtt9J52sfAnhIAOUcpm/G9yicVVuTDfDkUBZ3nVjc7WiHbmOn3NvI/0ALRftdseIa1THaaRd6NDfWf69RCLYJFSoVRXFaGyUY95ZsC8ZjQS4zVPEc/jZotz2KIz7Dp3Qy141z/Qqn20QpcwHw9EoljoLf0XSGLv1X7lV66d083uaaGp9Ipq43bEWrSdzIfL/+v8r5R+WWWPZ6URHeo49KV2JhYShJCSXey1wxL/iYKYS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 01:40:15PM +0800, Lance Yang wrote:
> Whether a PMD has a deposited PTE page table only depends on whether the
> architecture requires deposits or the VMA is anonymous.
> 
> Implement this rule directly in vma_has_deposited_pgtable(), avoiding
> mistaking a non-anonymous raw PFN PMD for one with a deposit and attempting
> to withdraw a page table that was never deposited.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

