Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE9ECCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 14:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441DC8E000E; Tue, 30 Sep 2025 10:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F26B8E0002; Tue, 30 Sep 2025 10:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1218E000E; Tue, 30 Sep 2025 10:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 160848E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:32:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEA8E5A95E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:32:23 +0000 (UTC)
X-FDA: 83946156966.27.7F516AF
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B59B140013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:32:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=dXpj7gOA;
	spf=pass (imf23.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759242741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Na77R11NbjgWMZhuIVj8AYAJI1CDT3+izYFOG1w9JTo=;
	b=05BtKpP4XdyucgaZN5KYAi8Yl8sWQez14rVG9uJkpdfOu6OqZ4MCNivAMq17DuU8j8Ibks
	A8WoEt/U9OkdRKBtYrm9DMEukdKxknAprpLp6eXu+pFv8KtMody66lezN1ue7+vLWYaDWa
	VNgYtqLVzTDY1EFyKnO0sngStf9uIRQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=dXpj7gOA;
	spf=pass (imf23.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759242741; a=rsa-sha256;
	cv=none;
	b=3+31ns/kfbyPOcHHHSRAiNV6sf8ClBrPZgxzV5WtzF4Zdwu2OzIGuy0bulSk3gqWO0050z
	hahthqn6UvpF2Jdo3ULf2FqNweNMwWvuVB94N69gT4tXldsKjNcwRyClOx2+9N1XrobfYA
	6w/kNeiw382SC7XlTOfeyjdgUxrtv8Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Na77R11NbjgWMZhuIVj8AYAJI1CDT3+izYFOG1w9JTo=; b=dXpj7gOA3v9harDKKH/oW0XcbY
	+h/uyc6a2+u9EZS9K6NxCe2Prjf7rmfpx1lWPNemsWwepTtZ0iYvKyM7kW4qQQysPLnSUpWCamWh+
	pWLpvwhnL1Hw4YM2+moKz8uxFkJgryPd56GjsTTVWruSda4BQrYwUV7dmu20vJAzDi7yzi/O3qQSA
	uJ88naDRF6KE+VI7qOrlFil2SHAZKueUiTjJRvC2JUy6VEf1Tkae4MQhhk2u+cwV85hftXAvmnHQu
	u5XsZTI1XwTDmMkZMqeu/LRCxfzqgYPkSwzITiU69rN5U3Nmo5F5C/DXH9gZBBX8QtUmdDrQxwlZ4
	plLvqeKw==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v3bOo-002JKb-8u; Tue, 30 Sep 2025 16:32:14 +0200
Received: from webmail.service.igalia.com ([192.168.21.45])
	by mail.igalia.com with esmtp (Exim)
	id 1v3bOm-001fwV-8f; Tue, 30 Sep 2025 16:32:14 +0200
Received: from localhost ([127.0.0.1] helo=webmail.igalia.com)
	by webmail with esmtp (Exim 4.96)
	(envelope-from <mfo@igalia.com>)
	id 1v3bOl-00Chfy-2C;
	Tue, 30 Sep 2025 16:32:12 +0200
MIME-Version: 1.0
Date: Tue, 30 Sep 2025 11:32:12 -0300
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@suse.cz>, Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan
 <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH 0/3] mm/page_owner: add options 'print_handle' and
 'print_stack' for 'show_stacks'
In-Reply-To: <aNvjDsBuw3hqwy31@tiehlicka>
References: <20250924174023.261125-1-mfo@igalia.com>
 <aNVpFn9W0jYYr9vs@tiehlicka> <4c2a467113efd085530eb055e4a4e1fe@igalia.com>
 <aNY49sdoFVe03m_Y@tiehlicka> <d9af42d5cb9d427632087c5f51e50501@igalia.com>
 <aNvjDsBuw3hqwy31@tiehlicka>
Message-ID: <2a1efa8ba183e866ab5c71b3526f64ab@igalia.com>
X-Sender: mfo@igalia.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5B59B140013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: fzkxzhuo3sz6fxbdt4osdctfnzer7wx6
X-HE-Tag: 1759242741-641781
X-HE-Meta: U2FsdGVkX18yHSF+YB1i4fhbwdE4WhDOelcXZB+xfOuz3aNh3TbgvSz4lmgjAN2S4udTggz3CEdGkxfgX66nF+/KcQRleW1eUWc9Cp6S2GHaIXmfZbiQs7v9WrCWN6fC22pQ2HlZtx1yUKUSIkZqpPKZu5SQyfPGrfZQZPNB3nlngpL8y8rYmLwa5S84EekVIWczCn/6O5z6x71ykm4aBqwaxRgx6w99IEch2s6qzB04Agp79E9a0EEWJvH9lkLiD5c8yZ/TNMuUTENGyXahc7+8gqkDrNl4YIHfWUYWBlrrODq3knKLesAP/BkMt00ymNIHGHehhvSRm5WGZQqj5897SDovtduN+522TvHqgagGQGmcef6r6INJTagcRvurmFV+xTGlYPK8ZX+2v3HXDaPzoOdELYglaAERDPcMDSZ4RqerkMeJQmV/Eg0TPwgrXsCA3PlbEb6amYx/qjpAyoEKNrrL6GNu6VNq/xtoV0Z2st/qai3Xd5nZw5+jmH/Zk20iQ4XjC8d2m4ZUMTtRJmjg/MNJHaEa4b1W7y31Q4vSXx1NfuFvP2SuMyRgjUSV1FA0Yt8ElYSlJWhjnY0cdWQv0bxUvutlJKVQMXk8JVcwj95Pl4hnxrlu6hiEwzF7evXXv9RnznubkcsuqSJg2Vc1TUWxRQ/BeM28WMnSuiJAyC/nDtjoxadcZkPHN3PzFaEw89dYVFbnnddR2J71CZXxVUA9Tq8Dm1P2znYvF5Cmy/yu34l3tae8uM9Usfaa37Xj0Fd74BBUqukdIxtnP6JWq/sNkdmJif7ikF7I2MlAPQ5N4JeMl3ogkOYSTdlJ0usUVfr5PjmVHjxX2ogHPuuBHSTS27JgZL3ziVgOR8ReSNfT/jwvafSp+ZscwNDF80pYDGNXh8gxkaxDO4vghir+9pALACENpKoHWWKzENnqMu41O23nZe1RbZYyL8zpvTeUfOhg/F9HQrhTnIM
 4u0q8ZnU
 cqRbva2jnJxOGRLqk8+1bRpNNFRtf4angi1s2Y8T8p28kQmZ/SJthBoB7CX3F8ASJhpFq7rmIcz08ViPD5tJQKcA3EOtnrlnohnPt/crvZvGg25ufWTWwSsaLVwgYKOpX6uZlqri597SFykq0VtE5F3u+iqszqV6Lrtj05XaTB9/4FR5n1WCtX2O4/UP5//+4deBjKbon5shaiGARt7L2bTTxk11xE8XhvdKlNb2tXNv9aZ456vTa8YQfkNtuciriedLxBOpDOsZ8c7ZmCajW1BAUTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-30 11:02, Michal Hocko wrote:
> Sure, I see. The main problem with the option file is that it is
> inherently suited for a single consumer which is a hard assumption to
> make at this stage. So I think it is worth having a separate 2 files
> which provide the missing functionality.

Ack; I'll submit v2 addressing your suggestions. Thanks!

-- 
Mauricio

