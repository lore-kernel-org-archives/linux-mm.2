Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4676CCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534CC6B0005; Thu, 11 Jun 2026 08:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EAB36B0088; Thu, 11 Jun 2026 08:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FAFB6B008C; Thu, 11 Jun 2026 08:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF646B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:29:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0974140431
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:29:14 +0000 (UTC)
X-FDA: 84867561828.23.29687C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 13CC9180003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:29:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j00Y7bwR;
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781180953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0z4pr43PxyDVhLeWa0I6E5NY+WUc0qjuvzihQzFaRs=;
	b=io/jzY21bYzrT8qq4eqsBmrNz7eoCpj+cghE+SVz62sdzKOmB8Kwbdq4BkGU2429hTRHIY
	W88KKmNmR4hKGYVaZfOItSgao2NWRIKqnx1O4A/r/Eco6IjNsd5dL0MH6IzWhz73GAv9Vy
	mAmAUW/SvjHYyMWB71+0rb4gpu07SHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781180953;
	b=SUAhB7EewgxPrPW7xbQRm3wbmvPu4FLcu9l5UnOfvI+IE4c/eRFbEXRjaC5AaR5Cdy6evl
	Y+GJkfsNgOm4jEMYe99g9+PH5v59BEReV1eg8UP/bp9xH8GOm6agLozRm/SC3w7/iCc2f0
	YHzqfYrU5YhyyHNmgeC38GnoIWGVFlY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j00Y7bwR;
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D6C5741A36;
	Thu, 11 Jun 2026 12:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830C01F00893;
	Thu, 11 Jun 2026 12:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781180951;
	bh=+0z4pr43PxyDVhLeWa0I6E5NY+WUc0qjuvzihQzFaRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j00Y7bwRXoZfkM4syvRrXIUw6cfIj3GM1yQ8yHuN/nov5Ls3NzT6vbMDIRQgq29Q6
	 k9Q1S03Gd6nROdR/vRoK2sdXZYIVcFtCJyTJtRhgOZmGkAO3xL7/ZeScqnFxlFqES2
	 lvp2Yy9zHchlLy1LHkQx9ZdGlNBaLNmJ6gOnARPvwbGcMpz1ZoK7depBTNnYy6jD6D
	 Z+uHu7UhceB6ipKzKqBTemrO72xZ5s7ShOPnw/PeSVzeuzkLjgYasf8XQgj0j5OkLS
	 2dEV83Wz5IMqOqY2zTQTgNhiYbX9lAoOEl9Z3Qx+vSfb62U/RO+G6Y3S2AF4/IMQxq
	 esU+yIWQyLR4Q==
Date: Thu, 11 Jun 2026 14:29:05 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/8] Implement a new generic pagewalk API
Message-ID: <aiqqEQCo2UiWDY1l@localhost.localdomain>
References: <20260525165528.184397-1-osalvador@suse.de>
 <aiqkyOCy2rf99wxg@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiqkyOCy2rf99wxg@lucifer>
X-Rspamd-Queue-Id: 13CC9180003
X-Rspam-User: 
X-Stat-Signature: ygtpk33mxknyaao7unejbcoaq3ort83p
X-Rspamd-Server: rspam08
X-HE-Tag: 1781180952-562609
X-HE-Meta: U2FsdGVkX18rMgxlu4Gxbky9zOKna7GdGv15UUboSL7bmAsTLTrJNxGsxWDyqgIPbMYpnaw4Qpu1M2TyYLSA8YxO0Gi6NRQbjXPJXnyx9oYM97ykygQfhUj869KXCyYRVkwS1JEF3mKtz7FAz8wgTrtRJ9A6fkPlrl20gGv0jgTsotvhzGQ3fRdx7r4tze2Vrnv9ElHJK1FgXQxNE3rkMghmpg57dB9zgezLNYs9yikrWDTi0IuRzotQE5s/oCsHxsjgobYJN8+bZPjoEjd7dQX0tDlIMiIGqUOqa19M7SfVN8BN57hg7WpsbaK9IGrHtpfAQ4Rrc1O68aGjP+08ljJlXV310KGa72DE2D/kEqkAufkKBL9KOXoSmicVj/qBN8a7gxv6qTzsTQaBEqEKlx/JNvVUXgeqQ/gv2O7gUtWVx9fhOPeiHGo1W+UvkL8bm2xaXA+UZaolU1Z9CweHgFNk7xeNoEI/lOY7Ar5ifzntW9Mn6hG0MIifmeVNc5CPXprD+VhnAu0YqW1qcurL56sN0PQifczoo2ZR1I0nvWnymk4ulfxDe7qF6jTQEGiEVw0z8KcPKmAJKtxe/FG0hqdUaHPTiOihKU0Nf8si6PMfF0qp6khKCfZ+uRtOt2oWpCjTUwRDPRpd5U5pzl2RNdFIBUveRHn4NOKHrfTS6l5wea/QjwWhtopiIcZyckVmehIiBLw7ftHBBc/RLcv7Fy3Q5q20LqBWqxuXyxauE0HaEvcxtFwTA7TdvBNKTyyjtDjZtHGScONVTQynjb0bRAwzSVorjWHegBLTA/sn0OCbYUz1ivNf1UZ484+AwCRL2tclRSwfoKpW23S7tBeilacR/5q/mW0otc9EWHQnZRb/9CDIDxO5ftyRQrgYsu/7wB8DH+bMHqVTndOMOdWBBQmsoZdwHck6ZvX5lHutfXGmTbqt5xi7GP0b2eDvUu3YgiCCTiSClAk3ulpdfF8
 Ex5mgoQ5
 Vw4O0MBqguQ7AcIt3i3AvIGgDNE7DhNsA/DbKAJM9rNi0QWGGxx0PB90SdM+BXlAVKHuBiroBHk0Ye6S38zKtBBh9Bc/N+19+pRKJf4q4W3CjRE5bOBK+3YeE30QLhy/hS1xa4SKakHqFTDr4lCUi8Q29TSW7Y2u05pwDfZtA+GEjsm5upphNezOYgmgKqKLnciU+0KFGRTVJFG09aWGAyy0VeAJDxyKWrBRsG7YqulcsXik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 01:07:21PM +0100, Lorenzo Stoakes wrote:
> -cc wrong email
> 
> Sorry to be a pain but I only just noticed this because it's going to the
> wrong email address :)
> 
> Could you make sure to send future revisions to ljs@kernel.org?

I would have sworn that I used 'ljs@kernel.org' but I guess I did not.

FWIW, I did use the right one here [1], so it might have just spaced
out :-)

[1] https://lore.kernel.org/linux-mm/20260606035003.529685-1-osalvador@suse.de/


-- 
Oscar Salvador
SUSE Labs

