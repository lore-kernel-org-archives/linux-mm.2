Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 849CACA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6382A6B0088; Tue, 29 Sep 2026 04:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8E16B0092; Tue, 29 Sep 2026 04:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FEFD6B0098; Tue, 29 Sep 2026 04:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9546B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:33:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C69640445
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:33:01 +0000 (UTC)
X-FDA: 85266134562.24.8CE54D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D75F40006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:32:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omxEZyzD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWgQ7PY++KZOODIaGPn/6f7fWLLF6eJjFXK1cuplJqI=;
	b=3znNdlMxGuCp0SNLalQKnvTWtPbN+igrP0sk1142uROKk5tq5AregD4aWSTLkX/YByB0sT
	pCoVN/iexOubtv6iHKZUs9YDDSV/56JQwwMwqLI1f75B7h9pXXRza4ykmkpXemtkwYaILQ
	+RwEYcT2lUPvWOMO6u/K0vFelvxtXfg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omxEZyzD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670780;
	b=ZAnxvRmI05S4wCIIb4Dghvlaqj3c36y2gt9Gv0OifqnigytE4ilWoLNN2SrQwKGZ2mLE/j
	xyXjrNJhxjUmSCaMoy2JyMpc+OvhQ+5Y6EVfiHSECO+3rX/EjK3E14g7OGO28lUoMlW4Wp
	7kAjY52uvaAATydRxdd4wBb0echKDTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93B8660A59;
	Tue, 29 Sep 2026 08:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544F41F00893;
	Tue, 29 Sep 2026 08:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670779;
	bh=kWgQ7PY++KZOODIaGPn/6f7fWLLF6eJjFXK1cuplJqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=omxEZyzDwbTL1f+vpJPwUGu5x3lHd9zjhTmd0ryL+3e6loQf5WiX5DwS1z7MMgsyv
	 fTrf3/ndS/R0PA14bGgvxLxv0SbwcZNsewFfrnwsrqYHBqy4W7DgI2jh+g+Z2sBENM
	 WSDsjjnimLufz3POC8dGk49KDEzfFrokBGbTqCXS/ue9RoO2fs0X5vM5rD+7AgxmWo
	 3+vGXK6ZoYpXJjs2G+5U7ZsfALTGTteeIsNzul6a9ZRdahZMLHcs8lXurzwnHnBx7U
	 frDhAgEr6gdZO7mpoYJEyxvtlDGjveQPqybu+3A8RzsoRKomv8UXAycN5tiftu2R9D
	 iPbBIn2flF0Ww==
Date: Tue, 29 Sep 2026 09:32:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v3 1/2] kselftest: mm: return fail when child test result
 is fail in khugepaged
Message-ID: <art3m_g5OLBTrE4W@gremlin>
References: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
 <20260923-fix_khugepagd_fail-v3-1-b387e92fe1a9@arm.com>
 <1246dd4e-b2a1-42e6-8fcf-7e6b2514cb87@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246dd4e-b2a1-42e6-8fcf-7e6b2514cb87@kernel.org>
X-Rspamd-Queue-Id: 0D75F40006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: da8o7wjnbr8a7xo4cf1a99t63t6fx8ye
X-HE-Tag: 1790670779-39385
X-HE-Meta: U2FsdGVkX19Y2gQLJysHL2qzCAusLBc+Kij4tWGdrlm1xE+ZV5ld8NlxmJAywHc6iO/iO8JvCeAkXrSBqYPH4KxeGURf/K+gfychkg7UZpHjfNcMensfEYUHbii1r8fJURQicIPJ4ZMifUhmjvln/uUha5qR4H8d+PoMG72NIXckPk0nATxWEQcCyoSjMNiVu+SrdD7f7g+dnwusjV7loqeQS+fbgja+7KEP/i5J5mbfFvduJ2XMChuNj9GxUwdplaLUtixzmWd+B+ZVgi1oMZgn4ACf/1QWmd4ntmGF+dxH2J8DT8ibakN6RRMuE4YAZenTL8Fl9LaImiTbh9LhFhuVfbRWekSiLCi8IU5pnypq1kCqIVtuH5vZrMSTmNAaVDIMrp1yl21pwWO/3PP4GER7NHA+e8sCoErf9MjPiJGQOcqA5/9xQirQ1KEcSAEayJP1eJUOpj/fIVjRA4GHyof0DAmTP5+X27/IRhX2cAn8MTz1LFl8datQagl6vOzNN9kHD4a/x/3GnUK7W4i4CeIIZHNmu3jjgTdxKhowSA3FQ8A+0SHEHS0+i5jkJfltX5Hdahj8OEM77Ahy+XcG8yM+2TrAbJa5vIYKOHkL7dGuWuNsrPrp2m8VUsIxapVSlzD7D8Hu949GK4O5u+/rhB7R2XzY/mBMuxzz+Ds7tmOXOEPtViH8Ojl4pNrSRQhI05X6lAqvH4zUxyBmjBRYItL6O7LCaeAJvNAxhOnxlRprC05ydJD5/nKGIM7+fZqPteWFhix+iurjQ9c0JJ54V8o3kuwrTAA8NPyq0MPvzPUK9xnDucsOEadxiKPCNaZ7EjGNFEAa6nubej8kjHzJKwO08k7kyv2wsKgdE3xN9MQ8qetKoC4BVG2dEQhZdUUpIaPpLgz7bEoqlckaDqALyyKUHatJXpngPV7fX/ExPrWUSXcjyoOTROonLtsFzrm4fUDP1wSF1j4WDNghFf0
 O9vBOctx
 PQhJXeg+iJ+i82h35GHYy/o9k+NvrOfAJF7nJX0ahsxtg3Yp770zW+sn5uFLoX2zakdXYQEj/Het8CAVKVYPapmP0RXTdgBMEqaJYUskzGsT8slVHpBf5ljNygDakM/YYFj53sY+wHbi2Gq0EmcpvmS/v/yLEsMsu2Q0G0NTIR41NmhZYLZ3JFMoTKydWoxZlLFA/GieZGNHvbm4aCtiJam+uh5kRShawE2zWQMTu0q9SeEmanAKbXE4BUl0bBtQVCxdqDo9SntWt69ocEv3DTU35XgMF77bR8JtkD/fymz9tS50fZ/E1/biP+GySPvL2I2yYBzu6F7Avwj831yVAKAdVdmUQvWVcXp02aKaSVmKTA8YDuq+ahKTd/fcvaEa+N4K0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:21:53AM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 17:29, Yeoreum Yun wrote:
> > Although the child process in collapse_fork*() or collapse_max_ptes_shared()
> > reports `KSFT_FAIL`, the result is ignored because the test only checks
> > whether the parent’s page was collapsed into a huge page.
> >
> > As a result, the test is considered successful whenever the parent’s page
> > is a huge page, even if the child test fails, as shown below:
> >
> >   #
> >   # Run test: collapse_max_ptes_shared (khugepaged:anon)
> >   # Allocate huge page... OK
> >   # Share huge page over fork()... OK
> >   # Trigger CoW on page 1023 of 2048... OK
> >   # Maybe collapse with max_ptes_shared exceeded.... OK
> >   # Trigger CoW on page 1024 of 2048... Fail
> >   Bail out! Unexpected huge page
> >   # Planned tests != run tests (26 != 23)
> >   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
> >   # Check if parent still has huge page... OK              // parent hpage success
> >   ok 24 collapse_max_ptes_shared                           // considered as success
> >   ...
> >   # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > To address this, propagate the child’s failure and skip the subsequent
> > check in the parent.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
>
> That test implementation is rather messy ... :)

Yeah, I wish we could just convert more and more tests to the harness. Makes
everything easier...!

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Patch LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

