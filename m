Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B6AD4662B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214E16B00C4; Thu, 15 Jan 2026 16:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2596B00C5; Thu, 15 Jan 2026 16:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4696B00C6; Thu, 15 Jan 2026 16:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED3736B00C4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:57:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8111B13B138
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:57:37 +0000 (UTC)
X-FDA: 84335560554.23.92272B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA8C2C000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:57:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="VFBjGK/T";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768514255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PQtFpfasUJZPyqcLywyf5xnr8JHR8X/Z8+P6UmrHSY=;
	b=0Ea+7+AiiaKC4if9UYsFR+VzHQBbKhmqjhaOvRvrulgjSoieSId1ojEZeRjuf38gwIRKcz
	DyHiDS37gllRH7q2/Nbj6Tcf8LHAvLo6zaq5dOSLOt1/ZxupwrIyFRZ4nt+7vlQ4AIFdmK
	WInYEHEeojvW/MGr7GxdwzVNnfVmSOA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="VFBjGK/T";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768514255; a=rsa-sha256;
	cv=none;
	b=Y97b4VhpJjwDSHsEAfgyn3y3jtpnAYWTu+dEE8z0VYYGVqLFemP4+TlSnpcJ1/awXwJ0YM
	gyPu9UOMWPPVtnMnK+5nq8y0raLSDJjgbhsTqFX+hb7Y8PakdNVzb0jp0N3ueZHYOcEpDL
	R+OdayqDtotbNvZi/xTAfcu6X8LwV1k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71B6843985;
	Thu, 15 Jan 2026 21:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFD1C116D0;
	Thu, 15 Jan 2026 21:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768514254;
	bh=FojpOiLAXUy8PRO6EnBczv5H+af01sTZZJr44RU5hig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VFBjGK/ThAVVKbG1zjNk4C+8Sw40IM0eslRG7Ea92qvFMUa95KS+YydlkyayI99xH
	 cDawAoePrHk+EdhNFx54QW5+LSbF/7ExaRuwVNAlvlOOi7aXSBJk+5bTuTLMheq7A8
	 QFhLedJthc6ACUZM2VON6iVGAuSe68HiXszWBSrc=
Date: Thu, 15 Jan 2026 13:57:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm/hugetlb: Enforce brace style
Message-Id: <20260115135733.27537586dc0716620c6b1180@linux-foundation.org>
In-Reply-To: <20260115211446.1429024-1-joshua.hahnjy@gmail.com>
References: <a0760613-5c57-4f04-848b-a0a6ff05c0e8@kernel.org>
	<20260115211446.1429024-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: py8j5ww4mc5rf4nn5ja8uk4eni5m5dto
X-Rspam-User: 
X-Rspamd-Queue-Id: AA8C2C000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768514255-171051
X-HE-Meta: U2FsdGVkX18o+5CfQo+jTvHpBgEu/uAT+QfG3YJfm4sXZCD0tjYRKq3wYgJO7rz//NkbKhLcBPO3bOry2gSenaZLzEDQN6yeN8BVWKVBz/6i1sksQnLcn1PuwT+I5rIbRyM9kGI9EHepWS9HrXtyyvIzMKOP1D5qXRF+FITfSDrVkthcPR8HZOaIwUH0horQW9mp4A9MOX9zrbiVQ0wIo62O73dSkxK7FAxEzoxycCpx2VOakQCvgshij9NMVdcHa2vwXx3Iiors5faW4nSCWgsRELZMFB6nCIU0fpsFBHvk1IxUV48t3RhkyvAabdn7EQH+ElZOC+3KqxUHAno+VxjtjOe+Md9yIX3U8yMio5ckv6A1qQxefS0nFLo3r5NGO8d9zd+903Un1Ohjt0gSRqJXidbK+3SXhB13MH9qQ9B4QSlaNkCp1CzX3XkLq++Zdzed7A1jMVaS+0hZKKZMPp7+UPu0vxDI1PXH9/gV9ae6zgmjg5Wg37FJNrKs61eGMa9sWEz/xqDs4zoBvCmI/MNzKNlW435aEFhS7ZGITEjRqMjRP5dbff9AoPHc+29Og4jcJELDyqochOqggUxE0popRq6KtbbCs+1la8qqT4liYJezIPJivuDxJ9pPT/54zFu7aacdcWVlFnT2gCyRpK7glvdrN/QWfvffHEKTDF7yle45Ld4LOSxUPGb1zOxuJRkuvPQjR0NS2St5VFSmxy9lvSgClq1ns7eL+utbQKvybI8p8nezqySeggU6tuHGkOEHsc73VLSLFNDbrMOjCQio8vNNHceQ/qlbtr/30aMTqTQV9dO3a/KLjelgFEUuq3Im6ijinFwvxjPRZq9aHn51//62E5UgVL9HARYV8YFyUT1jbgeXTHYn6vYIj6gtme8i00VWzxKT4pVsTFv3Bujsf1BPBTDdVLhGNrRY/pmDJNRpH56qvJ5bwGWMBBXjSlOskyvMK58o2gOCkIv
 gfAzdOYN
 4/hQttQApI50OVXwkp0+mFQyEUlAE34+1WHo8c+SB0TjuTP1Z/jW+2UMywjXVebMWpVHI5kIFhG2hpraJwx/i1aSUANCdUQQRlu5tqcMZEo+2W/sGb7qT04VhvOyyZSieDWGs2ejQ51iNEB4gGyNWE8g5UCTgm8xxlKbCHKhL2eGMEDCTo044IQYHUGOSv04OWr+TPYoqw9f4/HkhoweKgKFLpyW+DT59XAv0fZU0G3fCfRvktqHphgfi9lZG2slwXanjRrjoGBTZtqHAVQ2Bzh8xSk3JVHe+ZnD/6Ns5NJeoFRXTQqugSPs0NYqiBXhf1jLbJ0YeGnmo5C1+A2Pl+A4AZdqn3Cd1ZoajXoqsQYw7xM0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 16:14:46 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Thu, 15 Jan 2026 21:10:41 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
> > On 1/15/26 19:14, Joshua Hahn wrote:
> > > Documentation/process/coding-style.rst explicitly notes that if only one
> > > branch of a conditional statement is a single statement, braces should
> > > be used in both branches. Enforce this in mm/hugetlb.c.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > ---
> > 
> > [...]
> > 
> > >   		update_and_free_hugetlb_folio(h, folio, false);
> > >   		return rc;
> > > @@ -2672,11 +2675,13 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
> > >   				 * be consumed on a subsequent allocation.
> > >   				 */
> > >   				folio_set_hugetlb_restore_reserve(folio);
> > > -		} else
> > > +		} else {
> > >   			/*
> > >   			 * No reservation present, do nothing
> > >   			 */
> > >   			 vma_end_reservation(h, vma, address);
> > > +
> > 
> > But why the empty line? :)
> 
> Hello David,
> 
> Whoops, I totally forgot to run checkpatch on this one. I think Andrew
> also noticed this, he sent a fixlet for it.

I did.

> Sorry for this! I'll fix it up in v2. 

I'm not actually seeing a need for a v2, unless something else changed?

