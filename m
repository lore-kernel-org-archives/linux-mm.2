Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFB2C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5700A6B00AF; Tue,  1 Sep 2026 02:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521146B00B0; Tue,  1 Sep 2026 02:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436876B00B1; Tue,  1 Sep 2026 02:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22C416B00AF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:28:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A53571C1C78
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:28:02 +0000 (UTC)
X-FDA: 85164213204.04.1EE601C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 122BB1C0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:28:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSsf3AHs;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788244081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIJ9WnD/mIUV7NkTxdiSuUPVKAHvvjtPu+au55/iZio=;
	b=EzQNNkc5wUgCZBKwszReJuII5bQMLf93Z7lz7SbyWccdyeWBfHs5BRW9VrbZAspoFQ1c32
	exNTlR4NQ6Q54oXnF2RewlVL07asKSHmHuAJVDHirwzLiYj84Sl8NloOr6bGc4dNlnxwtY
	Jh3ufx2UAzgKcy5JOpbONAnQqHb8XrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788244081;
	b=NB1IzyjyLnRb1Ap4WRLt639CJcrkh0fu0cFlw5qGpJh025LCv2X8gQd422avoEs///5SYl
	oqp4uyyk3+x2NzyLc+O/6sxYQ9IJ0pAiSDlWs37CprgZqsQo5W/UCV0z262jKRy8a2Ryv6
	K7muUJzDZBedi44JrN1pi6ETLdqT0tc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSsf3AHs;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C55A1600D1;
	Tue,  1 Sep 2026 06:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74F01F000E9;
	Tue,  1 Sep 2026 06:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788244079;
	bh=QIJ9WnD/mIUV7NkTxdiSuUPVKAHvvjtPu+au55/iZio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GSsf3AHsu9HSL2zagjPF2vAc+Fn16ULqmVlE4aK3n1ZtU1MRzfxXt1BfMmgJYJg9h
	 OeGoWxLiB3NzysWXngOnJRx6LML8YWteJDEy/H5oAz4Xv1vuPdHBhv7BCj6RUg9YTo
	 HEWbi/o5BdEjqcLggfg+7uX7+pE+oN/MXqad966PkVTGuPRAvgP+KyGis01nCJswDT
	 VpT66ikYzckXnQFJiZOEjhfMmddYYPti5NP5hqyPPAda5oCTipX5bzmTQhOS4HkRHn
	 aSv+ihiYh4GXNxxhc7KbgNsuYTqF5tbVmKfc+BaU/8KOxhtOHh/LX9zrOfY6RXA5PA
	 75le3IEYnh66w==
Date: Tue, 1 Sep 2026 09:27:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mm_init: remove zone_absent_pages_in_node()
Message-ID: <apZwagtACFXu5vev@kernel.org>
References: <20260827144151.486192-1-ekffu200098@gmail.com>
 <178816183737.3691663.7482057515031348878.b4-review@b4>
 <CABFDxMHQjXUhbkUs_5Ki7Q6ZpQkF6Y-fDCS+LfxERFv09UgOrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxMHQjXUhbkUs_5Ki7Q6ZpQkF6Y-fDCS+LfxERFv09UgOrA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 122BB1C0006
X-Stat-Signature: xfi9wmr3umin1y4hpdobj3fr47r1j93a
X-HE-Tag: 1788244080-618957
X-HE-Meta: U2FsdGVkX19fjgyBUVxDZDRYhCwmFl7fLrKqyH27zw+9LuWWnKYjoae+pgUBB3A69qIQNI1maV0ySScBYUscxXqQ8iYvsfCV19UQa5gu/Znr/5scEB+ZZl9/FLjLmXpcWs5YXORpwADWXTK9l6weDwEFjpZn40N1i2A6sPUKJ4uj95wV8vthcerXfXG78vMB6bMJQZoDUfBTbjGIoxNY1UAvF4j8rN8CctjlhLt+0fLxXjSlAk0q3bCTEgaf/2qBPPEQLfj3fpuyebxg9W8a3vSPQe37qwjA0JH7RmuT/y4j4tMzNczHrqxpQW/LteEwvSN5f7YoPcUBAW+QjcDlbFD92ef143GhhaeYglN2QJ25XKL6S6NfVY0c7OC6o1B65Syiga8xkU1rF+QOZF95WIIGP1TWI6EZmOMziDl7UDX+c3J7N1DfiIS6qhVbpphyw6tQyeF3KpE7kS2aavYtiY+RJ8meaKPrGwkAOe9JaUL4kdj3twzmWcSu6S1s9WmAWrYcGQuAPbbKOMwmBRxJ2+XmU+DFjF+hteO4pUPbbYWlirYdmQWLZ3HEr1V3ljqO9xT/2/NeA4YTnXx+wl4rtDeu5eukBSy4dyYfdgNxB4fijXs6YXKknel7IikZUDCOje33I/lMlFHnETq6TucDLIUvpiApfFPUeVtgNG86hIGg3GRZ3eq8dxTGXlD2PdIA6sdfcHYJaGoLzac/BDuDCQGLhfq7ZAGi5QKqW8tPIVnhoPcAvv/7Fby0WNyZt+cRH2RGN2R9o2l7b/KdTx/VO234jLDp8ycdFdMtJXuUQTYABLUJv42003+YDwV8Bqtt8J8w8wq+yLhWmmt/trDyrsGqvtcTic237FPrj+Uo36HpnVGQJfEf1/e1w+1er7zviCxy1WYCLgxFM/GBdeIi6wu9smXiKUnFuxRYFuK6Yx2X2f+Otk5THYH/HlX5xDVFbSMFZHr7mEd54Vx21rL
 dVJybkGh
 tjystTgsuTXjWRJlwMGjQJDN96z8YZFm54J1OMoedB6I7wm849+YcgyYMVUaXWiyxk0x9HDQVjj8/Qe1myHccWXbJRegVLWDYy4hkdxX0UNVixyN6mhsgWv3M1XQ1SZAjz2L9hYFPWMRVanMcMm41/NiKdUff2+S2cnRt9ltDjzZbRAlbOEGPT/8d5ehcZwrUMRSwm6/sw4qJEjgyEHgqXVTuNutu6z+SgL6I87NwMBQxmIpTMPoFkXBsrktFtmHbHjByRXDxfTFtPyAlqi6jta9DZ4Hp/KpPxzBFThPq8iIFi3rWA0kc9pulDp9v3wVQtKEIxb5PheyL/0JP9YMYL2yccLUJIJ7Lmd9w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 08:30:40PM +0900, Sang-Heon Jeon wrote:
> Hi,
> 
> On Mon, Aug 31, 2026 at 4:37 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > > zone_absent_pages_in_node() returns 0 when the zone is empty and
> > > otherwise calls __absent_pages_in_range(), which already returns 0 for
> > > an empty range.
> >
> > Right, but it loops over memblock memory for an empty zone to get that 0
> 
> Indeed. How about adding an early return in __absent_pages_in_range()
> to avoid unnecessary iteration? I just want to remove the wrapper,
> which never uses its zone_type argument since eb0e5b61369f
> ("mm/mm_init: don't overlap NORMAL and MOVABLE zones with
> kernelcore=mirror")
> 
>         unsigned long nr_absent = range_end_pfn - range_start_pfn;
>         unsigned long start_pfn, end_pfn;
>         int i;
> 
> +       if (!nr_absent)

Yes, just please add a comment:
	
	/* range is empty, nothing to do */

> +               return 0;
> +
>         for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
>                 start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
>                 end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> 
> > --
> > Sincerely yours,
> > Mike.
> >

-- 
Sincerely yours,
Mike.

