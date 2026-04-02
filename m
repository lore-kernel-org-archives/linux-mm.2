Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB3ED39427
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F1C6B0089; Thu,  2 Apr 2026 09:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC02A6B008A; Thu,  2 Apr 2026 09:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D65D6B008C; Thu,  2 Apr 2026 09:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC516B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:47:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EDA613B7E7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:47:44 +0000 (UTC)
X-FDA: 84613743648.08.97DE06D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5FF6940007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:47:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPX8t+va;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775137662; a=rsa-sha256;
	cv=none;
	b=Llf5Rh3ns0CHqpoAYr2ZOu+/rZ6Bg9M+Cyo8o7411l3ovpXzE1/ccdW+ar55JSLCosP4JG
	XFDijneiHGJz+nrdAjGsNlPZdzuRYYLEhq4Htz3gx274hkMrd9UFLAqYbesACmRMVcaRQ7
	cBOm2YQOsyrc7r/ha4BAwlLsbzV9czU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPX8t+va;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775137662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPpgzaz9N4llFZdjjOqvYrMp5USKeOWR6G/eknmi2F0=;
	b=w5Z62923WkUdZiqIT5Y+T9HveVfl3ZUzUNe1dBTb4P8IiplPK2+t7rVMI7BsFJBfZXDH/d
	Ajhc331D2WGIpOIHZ18xR16Im661vEtIbDH1rae5CHmZR+y1UKB+0m7d3NVTIq8DaFtDOJ
	jEoY+bLWf3xx9WiPpc+kV8yUlg7erBs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3004440A9F;
	Thu,  2 Apr 2026 13:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93135C116C6;
	Thu,  2 Apr 2026 13:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775137661;
	bh=LAu2eve5d40LPtMFRUfSuD6GUgpv9j8UkuT3bPR2L5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TPX8t+vaywKlBFPjhiAJSEPq9JqJXSnDJGTjoLCQr9bsJVcqeh0t9l8Ekh9B1Vyww
	 46kiK5HAiXJIeWs/EYTNRSikJka+SfXoDBMUaLdn8ArBAfmP2TSQ/uubYGR40Pq6zV
	 a6VQJQ+odfmnUPlM1AT48ylZmf9s99Yt8SeBu0ENcnQ0cWdtGuqJ4JIJtkDVxtZc2B
	 SNv7jkf6OZMDfrduV4N57zbBRHBicOs4cMwvPJb7MiT4vlD9BAaIo9ZO/sssigcA7c
	 xsY/nCAhBbZnPf+ZW5Ny5TULfVb8RndY5PWcJt+bkSn//Otfbq5W1WzV8jwjAHwKWt
	 CkdMDnZSZ20qA==
Date: Thu, 2 Apr 2026 16:47:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 11/15] userfaultfd: mfill_atomic(): remove retry logic
Message-ID: <ac5zcDUY8CFHr6Lw@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
 <20260402041156.1377214-12-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402041156.1377214-12-rppt@kernel.org>
X-Rspamd-Queue-Id: 5FF6940007
X-Stat-Signature: yzgxgi61twkpn66dty9ocq4y7z9b5159
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775137662-804229
X-HE-Meta: U2FsdGVkX1+mZKfId7LocWBwsNEsDbtizGWIe6XdKBXazL1thfZp89wZueydG993/kq3+wBJ5AXRSAxuHy4Q/oFuLTPnx1cKcz8bo0R3WTFDhf2D/rBAkBSyv7cHLF7jRFX6nvy1GFH7S/t3XSYi1QCEkpXlf4/WYluQfavvkzNiHXU/MZ7rcIvA+DlBAazZt/3hAw0w8VMKmvcSPtf1Z6NuoBU8zncgKHFEUQa13w4HPZnZN90mwNwXnXOy640ZhPuj+EGxAGruK1//RF4/FPwJ9HOmWyn5XzLiNYJei7BmpVu9v9cK5botFvCClOribg4yUmj4yEmA85h6IoZY522v4g7ijUS14/KdaJDTIuosF2Z8QAd2Lf4afvjNkThu+e445Bqd+OVg+3K/rt8+/kY1JTF0gJ0x+vp6Sy5eBf48bY/L7hdERUImleRgZNlr4Bpwj78EWdwyRQAT/xVNOI+KZHsxOlgYu1rGPyOEfFxSu8XftaTEKowKLFVAbW1wuTNi/W68yFArR2ZSHT5kIRpimXUjilYoP7TpF633LaDEkOhkU2n62bqdfK9DTHsTWfZq1/fHK9D3itkG6029VQmi/aV2zMOIzJmKOUEMvgOGwob2NAQmPqi84t06NbG6Z0nXq805br5E94BhJcGygX6eEqSIHBcQR+PcwNt4FEUPj5yFazfS4dDrs/Rq/HCkl3GBqO7p+p+bu7KxreMDiuK0QHa3TUJs2S8YwQ408ZVS274zQ+bbu69BJZqrN0R4tW0ZOrH815YIRF/S/ZLAjnH0Cu3jeDMUZSQkN8+FmOnEwWDEuFoaD3+l19+0XJWf1Oc5+1W7yUnkwqNwUVhJumM4lRAuwm67/c18XxXyvi8cATzt3lva00TYi/JZahOfaRjRMnoJU0XC9O3MpmQSnt3um0OOsWvjXmqhiKbAwFcZGierlOpSfw7jKpbtf2/Edvv1VFv+LMksMvNbpPz
 n27E6Q+7
 AwmF+Lsis8hOGZhuKp1VQWaNRnFtIPkMxcxM3a/mBACa13ynYcCamtsNN1ha8oii1CabfqEoBVNrdzyWmEnBWXPAJ8y7d7OXOWZ17CbMOjEYSwUdN8Twi83YYEzj6mWt1K/gfyZWrNEfzeXB+J6Nul6jxjtWO6/mfnkHOtWquDiOeCIbUkCGh9F3vGmVpXOfA6f+9e+YlaahGX6P9PrsyLb7kSdz2Nl2CZzIPfsbIl+2MojHica3SbNCM8yGj6NBde8FWFTj24LsE+DM/0ZdQGGpyg8eA8VVaavf8FTtRSsp6F765Xq/r1ey3hpnsqogWY2KDLvik+pU9qKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 07:11:52AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Since __mfill_atomic_pte() handles the retry for both anonymous and shmem,
> there is no need to retry copying the date from the userspace in the loop
> in mfill_atomic().
> 
> Drop the retry logic from mfill_atomic().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 24 ------------------------
>  1 file changed, 24 deletions(-)

After discussion with David Carlier about potential replacement of VMA in
mfill_copy_folio_retry(), I looked again in the code and realized that
after all the rebases I didn't remove the bit that temporarily prevented
returning ENOENT from __mfill_atomic_pte().

Andrew, can you please fold this into "userfaultfd: mfill_atomic(): remove
retry logic"?

For a change it applies cleanly :)

commit 5173c8f4fd32f314907b3804217ef57d4e3a2220
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>
Date:   Thu Apr 2 16:38:39 2026 +0300

    userfaultfd: remove safety mesaure of not returning ENOENT from _copy
    
    Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 935a3f6ebeed..dfd7094b1c40 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -530,9 +530,6 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 		ops->filemap_remove(folio, state->vma);
 err_folio_put:
 	folio_put(folio);
-	/* Don't return -ENOENT so that our caller won't retry */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
 	return ret;
 }
 
 

-- 
Sincerely yours,
Mike.

