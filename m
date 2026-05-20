Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C780CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05C06B0005; Wed, 20 May 2026 04:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6356B0088; Wed, 20 May 2026 04:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACBB56B008A; Wed, 20 May 2026 04:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C28D6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:13:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F63C1C010D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:13:54 +0000 (UTC)
X-FDA: 84787084788.11.FDF04BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89CEA1C0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:13:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TfwXQElo;
	spf=pass (imf21.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779264832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCQt92sZnLpz6/MMNIMsDZndfozm7C4EUpvW4TEtXNw=;
	b=c4jwUPwhT3upWUGhXoiRbIUuJ2jPqIUcMmKCKWWFfa/HvC0GOdUBS0ChvmpyAuogLmT8Vc
	4fHb7sdFcdo2DkSqGicGJ+Tpqc5Ug1yiuSVMArhKuTdahTXJSOU2q2Gd0IOgKKl9H1/TLw
	r1QReqHwgKnz3ZdwJkh7KtetHjB30F8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TfwXQElo;
	spf=pass (imf21.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779264832; a=rsa-sha256;
	cv=none;
	b=SFRB1wnVE5B/pjTKSxZ6UWMtUN1lrZqlJbcOAeBUTZVWcOq59hYjUMp4KTm6OwWQTXMlJ6
	I0bwAS0rTp0NJeoS/rorUxXifzRUg60aeLpdMMsEF+P/MCySqRI6K2+z1RtfMS6NqCPIck
	sZCOjybJLky1c7eJ2JhUI3EIxJaCEwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB2F26014B;
	Wed, 20 May 2026 08:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5421F000E9;
	Wed, 20 May 2026 08:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779264831;
	bh=HCQt92sZnLpz6/MMNIMsDZndfozm7C4EUpvW4TEtXNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TfwXQEloIp7hzqgCsIq5nPEkWoivA6fOgkIr0TAwADyYtMMQmHN92tMOq1Jrx/RAo
	 eq0xfV5fjg+nNHdOd9y5qaIqVhp990WKyaCEYRmvs0LIy/EONqaP85Nhfm/asKIHCq
	 Sm7ZC3nhjw0HfK2lYb2O4H14LD7Zaziw+gdCD9VWoe0t1hjya+YikgaLj4AkPQv4ld
	 pHDTbOeWGmCyRXzohpNx3ykW49Ox3cVtF3L1DxKV4UNnsljqp2Nhi2wiDqDtQsIiX1
	 7PP1Yhzy+nNRx5PEPGgInqynLR5vgUUkOtKDy5NcxGJemIGY60IHlg8aaoeuIpWvXs
	 n+TgYak3zAfpw==
Date: Wed, 20 May 2026 10:13:42 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Wupeng Ma <mawupeng1@huawei.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	mike.kravetz@oracle.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
Message-ID: <ag1tNtzmjNlrj4Xm@localhost.localdomain>
References: <20260520020128.3506168-1-mawupeng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520020128.3506168-1-mawupeng1@huawei.com>
X-Stat-Signature: mta99swqc7dgd5nwx9mk6qutpatywhnc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 89CEA1C0009
X-Rspam-User: 
X-HE-Tag: 1779264832-62762
X-HE-Meta: U2FsdGVkX18Wrb9VIzStBGEQGIBzIxYMJjqEUyGgV6/+oMs3GnYx8P5ho084klrU4ZrTJ9Lb5C+yHZ1bTI3A3p0RBWE8wvSx97mDM+r734WoTUmSg/2AjFA5sRZgp41HT4x83q1TYsrBZUI7m8MCnH+/IDPfCpvpV6dOve88oAnfVhEPhBpZbBrsxThJud12c7E7bFWs9tIJ0FO+CyYW/mYHkriAffsPRPxntOir0fibPFQ3sYbOqkUrTUgmB/vdPIcYWU1MLThDDFO5RVlWxzPHHj7+qmJAgnlXqPH4w50sv7zpITiJUivvwFTSh5lUj2PpZfWMntktRswBxpKoMIY1gjx109I9SjD9zNEWSXTK9XnXw03QO4qfKeAl0J4a9DfTZVjTQ67BHC4jy8Cf7HDZ8/TMFPZyR75wMXaXW7+vNP9/+6Vf18+8tAhpv/scchLAdtOEM04rI0b3tMlVGqtzTaT1tVucjaMlaEBgAUQmwBNsRJE1T6I+TnU2azymxhrwmC6qzUIui79zTziWu0YbT38+qZcXIk4QZZc+j+hRrAAnuMEP7wDoEMFIepmhI7Y8LMORLa5sK8Tno003cMSf15oRiAhe+8mRIdzj+wNWjDD0T8cFdv5Zh5RVC5jmeq52Eman2Jtw68bW6vUoNTZGgajLPd5a/l2CjgFCoNiXZ1ruDTgX7IwY5f61BRQ+U+g1vlpSKIKElzp0ocnguWysEgyoz5eLGye53er241GcLJ2Iz+3UCh+NZoRZ+teoal3E1LsBna4AAyqhWPSw1KDdcD68kYbxEVfgaDci1VVstUmMilcVggeh5pErkRR/oxSM5KQ4z0Sp3u5gGpED4k5Z0wsn/jyTyC4S9CQEd4qY2Bf7BJTwFIxSvC9qc0lvm+CxWr7Fv89qVuinUcY1KZl0NqJHm1hAPmbaHIaYqSg8eBtMXeusV42cKxfQ7+qNbHr8Cr55Mll9L206qjP
 d/9aGU9+
 aCAmpJD/5Vu76OMC/PmbFkwshcxOjOWkBZoR+VJwApzSW5geEADQze3yQSt84sgsfTC8c9du5FCwH5ThT8QHYqwplthSkyhGSgFZIELwixVMvHoG6oGUwsk3yOHcYGCBHwF8uBb+2w2SaQDrqKexvsm28QD1CPexgoL6JVuuLKx1VRxsTk+24jgjACyon81OZ2eh5swJTKhBJO8/HSevjBbFCyreOFuawplwCiXFJX39Wxnjqt0s/QVSte7TUikfWtVOy697LlqBsdclq/s8JdTX/ndKCpnqc72wza+K7mKCXj1jVi8Lroisi9qlsuWU9gKN1AKVb7gE7Fxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 10:01:28AM +0800, Wupeng Ma wrote:
> madvise(MADV_HWPOISON) can trigger a recursive spinlock self-deadlock
> (AA deadlock) on hugetlb_lock due to a race with concurrent folio
> unmapping.  The race scenario:
> 
>   Thread 1 (madvise MADV_HWPOISON)          Thread 2 (unmap)
>   -------------------------------          -----------------
>   madvise_inject_error()
>     get_user_pages_fast()  <- refcount++
>     memory_failure(MF_COUNT_INCREASED)
>       get_huge_page_for_hwpoison()
>         spin_lock_irq(&hugetlb_lock)
>         // refcount == 2 (gup + map)
>         // MF_COUNT_INCREASED path:
>         count_increased = true
>                                            zap_pte_range()
>                                              page_remove_rmap()
>                                              put_page()  <- drops map ref
>                                              // refcount: 2 -> 1

Ok, bear with me.
I am not saying the change itself is wrong (maybe it is not), but how we ended
up in zap_pte_range() for a hugetlb folio?
The stacktrace does not seem to have much sense?


 

-- 
Oscar Salvador
SUSE Labs

