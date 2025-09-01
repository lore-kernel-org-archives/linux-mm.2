Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FE2CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8DF8E0020; Mon,  1 Sep 2025 05:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41DB8E0010; Mon,  1 Sep 2025 05:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30FF8E0020; Mon,  1 Sep 2025 05:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB1C58E0010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:02:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5706A140756
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:02:11 +0000 (UTC)
X-FDA: 83840089662.20.3F3FB36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9921DA000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:02:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tt2Q8Tru;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756717329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7iXudYEJdLivhSUtvjdlylXukWYwrnK2N4UTH7yRdE=;
	b=3u1GCdCMo5dAxCtIiSD9WqnfyFuLBtPvzPY2XVvPXYib5w6NgzDTz4JGuXy7czSuXc8wG6
	ssv6LW3zd5YC/Ue+xkQvZvXAYPlw7r1lCNjNbplJ9NjuDc94tD/Eu8nD0VqvDIpidaLN3C
	iYy2TNimuW1IVXDHebHEFV08H45blGU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tt2Q8Tru;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756717329; a=rsa-sha256;
	cv=none;
	b=xT7XntOjQOiWK3zq9PKQksb+gvRx4a1bsbfJeUNf80GSLP+KT1hM/TCNh9eSCxASnhSWdd
	HLTxMDKOE396OSlPxZQHSFkSMgNXIuQ4rZCFAocfEJRkw4A4Fe+kqBhRdTsqW2DXdPyxSi
	qIzaUy2WazBXgrUbhi/PFlM90gLQIZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56BE14417E;
	Mon,  1 Sep 2025 09:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D07AC4CEF4;
	Mon,  1 Sep 2025 09:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756717328;
	bh=dmWftgOYXnwqfimPo5iGk24UkXj0UgScTAHQx516kNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tt2Q8TruNmgq3X52QEd8IDcJOs6iK8kI1BMjyxHwgRPVldf0rLQs+CrnF0ZCB6SSW
	 qibjwepNeMtBuTQ4KjAE/0yaNVPFZlk0w7Kr66pmIhbPfYu+JRSWlk3iCVHynRNw01
	 gZoEzqH/HlOS8b3hrtLNBktSWPdXEmZUTyGeMDj8FMt7MAqa4W5lqCh2fzV+EaQlgh
	 FlInVOCdEk3w06f66JUA5G5X/iWs6JQ1MRslNQ/0yRAvyrtb++ivZ8M+XH84IBreu0
	 ZI2qycGpcxOt14J5/SAwvGJ8jivBZk4Fs3TWopWRnOhcT8e714jpla2JH8Q0CGAZJj
	 +GHyEg4L6PLKQ==
Date: Mon, 1 Sep 2025 12:01:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
	david@redhat.com, axelrasmussen@google.com, yuanchu@google.com,
	willy@infradead.org, hughd@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, vishal.moola@gmail.com
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
Message-ID: <aLVhB4qQMurjS1Ap@kernel.org>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
X-Rspamd-Queue-Id: 9921DA000E
X-Rspam-User: 
X-Stat-Signature: xmwuagufr11uzek6wadqtkbctz378itw
X-Rspamd-Server: rspam09
X-HE-Tag: 1756717329-270262
X-HE-Meta: U2FsdGVkX1+QljqzhxchemyI3ffNnmBp9CJgN4vxNkXoR7rXSqgYhNhDjMxuiDlpUnqFQYbVNEQsG+UXTczzg3GqWdCW22B57++tNgqCOIBHyDyz0FCjrDUv0M40NGl98X57bbMWooOEv2HK8ufbq7d38FY2ISPw28GgBqw377VXhEdrcGeA85g87DRSBmkVEfhp0RUHhwMLsZdrJDh1dOgKGwtq8t4whJ0ofH6nEf9wuUVbk7m5H3H8hg3DTyx0kT6xTSZzsgFzFHmstaKkcA4HZxCotHWH73IpWeTY+GuPnyujxRfDs2GiaEBkzMMrzUKs6I0mcJuzRTUoCNOhSLdNMZtTD82Ct24vu2yTqUUKg5L8Px28lt0ji25sinIIydNQNl07xGTQGQKohYn/rjdd3SyxDZ+T32b9sE7ft+72wioj7nX9NvK8dJJ8xeZSF/YnNbYa6P2eNcRVdj2ml8//1VVIJpSXOoCBS7wNIckEdGSuXvg/Gy0y1JGSq5YERmrvuHpXJ2SBiU3rMFPiTCrJ3AlsFT+rsu/iPWAmxgFY+aHacNtg/r/n1XQ+2RSqoRFfw8x/50qq6RcOeC2rcaxV07DaJX/nD40pMNp6kMSjEFzf+CoapMj4zIeKLfGAQpEVw+W8X48/wgyOoIVB6xiH/AMOFP9Haj64WYkaRQL3zCTPRRZyA7nZSOKdK+OdEkr3Da8QFQ3K4aCIVvNtqRiYMNk16AR8Aq4ffqpJF+qTACE0i7bloqo0vnpU+eugAVzWuK/WJdg1xN3VuU+gU+8We1eJKNrPQvINyCF2CsN70snssH0rTTgqsqRLENu0IEf9csF0qEoUsrx8ah98pa9AGf+9jRmcnp/gGYaHC1E1lPvdgSuhbqJ8RtMaLZjJqKq6J+80K99PzNYbNL3MOWZ/s6xM0lK/fWMJAEiNtXObhPohIf51X9BB+43ZBRvfPk6Gh9bpoZ+OJLct2Z0
 ONoT47t8
 hI3gcifwiyLDMcRKaxyUWC6IpaS0QcFWoif3hRCVdOkf/cgztuB/w+9JwkeGkbTRhQiJY9gJQD6H1/KmzWwSyxY53V/WlN/acR2ZSXUDj38EJgj66FOLS9auDKu5eUHHRA3jmciD2H9sgJCu/1xX8aOqLrenuFYEMTppZhJp/p2yC3AaZKq7Hfatv5xICk8OCb6DnMMm1zQoxm1n+5/Ap7PvnS5t9+haDpEAdRACVTS3tGW1ta5T8uotg7ky4v1Px7drBhlOwRHw1FjDhmxM/oz2D4s3UncXKFpT6C8J54w5H2svyqNu+//eQJ50v2j3KiLhcMllzYZCFhZHJY4nCU8yrEywtwGDkKTvw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 10:05:53AM +0200, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 9:33 AM Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > On Sun, Aug 31, 2025 at 11:39:07AM +0200, Max Kellermann wrote:
> > > For improved const-correctness.
> >
> > It is not a proper commit message.
> 
> I believe it is proper for something as trivial as this. I think
> adding more text would just be noise, only wasting the time of people
> reading it. But that is a matter of perspective: I expect every
> competent C developer to know the concept of const-correctness.

True, but having a brief explanation why it's ok to constify these
parameters helps. Especially in longer patches.
 
> Do you believe the commit message of 29cfe7556bfd ("mm: constify more
> page/folio tests") is "proper"?

-- 
Sincerely yours,
Mike.

