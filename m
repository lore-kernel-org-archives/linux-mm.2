Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3355EF43841
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 07:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC486B008A; Thu, 16 Apr 2026 03:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D296B008C; Thu, 16 Apr 2026 03:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3186B0092; Thu, 16 Apr 2026 03:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7A76B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE30F5A469
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:39:23 +0000 (UTC)
X-FDA: 84663618606.22.695A5EA
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4166BA000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:39:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=uZU2MU9B;
	spf=pass (imf25.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776325162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCt1bwlr4N4M9lvWO3MK3T376Aq0/1T6MNpyVbtCJeA=;
	b=47QX86MrIpvcX7BsTSj3BKgN8CSojCV4IX6+stT90zXalwvQ1HahvEvMGf9lCRuPsjUsvE
	KqC9megXf4WUoz+D5sOOyybeukXKv3MnK1N0/gUWSrmHl4QONjvlzeyLj6kJ9NEBQGTExF
	0P91NOpmn+NqzBaaPoeYVG50lH6kF3Q=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=uZU2MU9B;
	spf=pass (imf25.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776325162; a=rsa-sha256;
	cv=pass;
	b=LaUQqWnk6Ea1a4oF89AuTHArjajZt/ctWygvsasmdVWrPKQF8jMBdbsM8EP26BNsHsclT6
	3hc7cJZsigEkb/Qg1SN63ovE4C+cjCp73jtHQlDJsTF3sKM9lGUzFLBFkg/RJ8EWVBXRm3
	UCx0lsLdRYdWrytWrG70xyjFUowjyxI=
ARC-Seal: i=1; a=rsa-sha256; t=1776325137; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=GZwQUFonOWEpakPScWBAZyfTsj4R4pYeoGdBsp4h/aSXCqP94pUOgGAiNmkQfAZgsa4Hwtn1lEWzfxdE8A2cB2HP8Lxs9l2CPRh2zpfI/qpHC5wBO2x7qf+N1VAPPW3PqCojiq4/tiTLwr6qX/erGpNzmDWpmNwzGd2O2z3fqiI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1776325137; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=OCt1bwlr4N4M9lvWO3MK3T376Aq0/1T6MNpyVbtCJeA=; 
	b=ACtzG7EXkxi3UPUlEaefUV2wCNMV5UH4wbJGGnmsAe26GLPodEDQAeZO8fxTqG6A2OOgNnwXfOOM0vzqN73HhkFE7ZqidPdnwSvUJGKrQRaqtAKkWlvl7EPA+jZkwkeH1WKRITL5fawAdx1uBmJGNp+LGEy9Qxo5mE/X57Zjig0=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776325137;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=OCt1bwlr4N4M9lvWO3MK3T376Aq0/1T6MNpyVbtCJeA=;
	b=uZU2MU9BcEfuFjtveNpjocKh1fDTvVX7bNcAZqkuEmf5nPJEPZrQuTIXhZRvZJ+6
	63C79C50mXU0F4HGtGyF/z0ejYdsnbGcjprtXExKUf32g5CqFdlDEHk15S2jqp33uyG
	yhZ9S2+2yra1JeKFrVHbNaC70G6je1Q2b1wqnjUA=
Received: by mx.zoho.in with SMTPS id 1776325135428241.04645771779064;
	Thu, 16 Apr 2026 13:08:55 +0530 (IST)
Message-ID: <73c867a4-b2aa-4b5b-871e-d3585ea864d0@zohomail.in>
Date: Thu, 16 Apr 2026 13:08:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc()
 shrink
To: Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
 <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
 <ad5yE0sgV1HJsyaC@google.com> <ad_cpqx38LtQPlX8@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <ad_cpqx38LtQPlX8@milan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Stat-Signature: 5n89bzyjndzdewox4m9x6ynnwg9q7gpz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4166BA000A
X-HE-Tag: 1776325160-813395
X-HE-Meta: U2FsdGVkX18+19PDWJYI11SKgQg3iptIyuOL2IIQvb5p/1t5XP0iAVkD8L51UNeZ06ogA/VVCTGs9NA5YwFCI55K7PNxrksgR+CGwQizdvlKEI5PiVwlBbiA0n/HWb3lNixUHmILxbrYNgD1CDsvX5JmBPJB4llYzFzvO1tAPs4xYL/+0h8QbqhWWElICGzWYCS07+8jGc4TBc+fIsG7KUiR6OyoFMRqWWebE2C3gbKbE+W/rFcAq5Ej7XxVd7BsrHMKqnY9W3BFdwP6Y49Y4oWG6IH4fxktTVTh69jFYNwW15ylV1UNaK547gl5oSxV3ukroH/1KeVmk/N0Oxp0Yud6Hngax5acLVliBltOqRb6fxBXmR/uteTrzIH6+Pb9T/fMSeuWsd+Tui5lUEZ7vu70hDSZXuyxqx8uSSbsNAlEyN98MCzt/dvd80iG1UJiimPEbm5kDVHHrfMqzc9uahm2qdqpmhbUrI9urtRzfv2ODlL3NezJc/GGc7KLBxmQqldv+38FcDOjrK7Gzo3t2TgH1NWawwKjzO8mJUaesTY1vCy4QD5InBLs/JV5sxEQsCxaRHCNt52WB8coT1ciW+G9Jxn0ztsx+daQG53PzFKR159W5iipOuHxqdpCyQjSAT3GIFaFa2bXBCHubehWBrpC/zd4CFT4pEZUAtAL/+q0aURtIu6nXNcJdgvVKbg/GvrHgTys7JmBQsScHv0wkCHYFaIaKnkr/FZtukiawh6TbI9XWUU0HsDOvQjPdgh1EpNaWmX8RX6nYOxIb2Q5BFUhpliKl+a4rbGV5BQVYmr1k6ugj8KqgpmIFv2oJwkjwvZwKpmI6ESkdMohIerzKdzDAC1341/J+wnI+qXLFLfzWQ1oDef38QEUVjPPIokagK2JsxHq/zI43VJp7bmuK2fb7N92KpLjpQi4irrsEG7sY6iW2yhpMhPpiZJL4P74+BBxLh2egM3QzapvzCr
 K8vz9aqn
 8wvWz02u5j2esUmEyGu6RdmoYW8IS5lpb5GTzHivUnyN+YZm6S7jutyHpO5Dmkhj/RxP+aQ4Br/BT4xBOQCOB7GMSg1qjmFv++PACiZ/hXLh6ZxkFwhczlqyoKfsLowfqQpbUxPZ895Vu5SrXS9Nc1i3FtO/9VhepxDpnpNAYPPWcYzSIbJLLXyDDeOAk6OW2adiraLwLjqSzalqWPop+gVvAXscoz7sg8ilD96WzoOghqIBW35dQnE0uq06txJ3BOS0ddGxh31TDd/LCAmUABRwEvj15JnpTtK8q5oJMqIySRa9F6nFuSnog5YDisuJt40zhaP13mVY/TX4BIOiZanEgP6Nw/leXHBXTLByPHnxEIJUumrD3JPRMqSz7PwH+KDaN3nir0irKAaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Alice and Ulad
I will look into this and post my approach for
v11 soon.

