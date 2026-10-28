Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D398D606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrWSFKNl
Received: by kanga.kvack.org (Postfix)
	id F35FE6B05B2; Wed, 28 Oct 2026 12:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DA16B05B3; Wed, 28 Oct 2026 12:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC846B05B8; Wed, 28 Oct 2026 12:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE64F6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:40:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F62112013E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:40:43 +0000 (UTC)
X-FDA: 85372598766.13.AC0D045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 20F7A40008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:40:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrWSFKNl;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793205641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3q7TO+ZwaEbqoqmLKPrIUPjIISzIPUN3/sJr3wevERg=;
	b=mChziIuYH0HuaMVAfWRAQvmQMZoBNAvex1j3ZFy4IeaNqusMa/DvOnD6IqpqKzsmkk9rHw
	sWIBA7hRi/gOkd4d2RiEcll7C2oplovumuzFD0WQR+FqoabSRq8m4yMnNa1fC8c1pVF05v
	D5oi3dQKIRtZfKHlamUNhan5KxOEbZU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrWSFKNl;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793205641;
	b=hfJ9LtnpJTZ3cBMu510IaGNguW4qQOcsAX6l7C6FhRwmfwhbL3kiKKOJodqbCHubjAKzSh
	BmkDd3W8LWxSsf8WqeVy8wtbQaTupcCoRPj8MgwJPYH14Qj2EwXVWl98Gnk49en08s6ZMQ
	xo000p7KtZyEJ3bDNOBbhIqbZetdlqU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8DB760136;
	Wed, 28 Oct 2026 16:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B8D1F01825;
	Wed, 28 Oct 2026 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793205640;
	bh=3q7TO+ZwaEbqoqmLKPrIUPjIISzIPUN3/sJr3wevERg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JrWSFKNlihySPv8s4lmAnMXkX/dtX6szCvnGeflYs1hARCipDCoTkDPY/lHrNu1TB
	 ExsFxdXFzSYz8EttGQc73I5P69CU4a8ag5+HKBcv7+bfJyJMMn5VSCeGPZrvUq48Jf
	 +/MdP0lmtieSO3QbGNT09JTEs1HDFgYZ1KeDBk3cy68fzBJhmij0dVkjTvrWea/uvB
	 sA1M7qD9HqqJm/s6dYIEQIb4tp+8zJdJwZ9cSjg/NtNgHQC3bgC4ceoC+GcBmi0LSB
	 T8Q/h5Aod5LXIo4CP6cNwhisJq1R3DzsQ97GK9xhbZMhqT6p28JuwvkZD3/rs0nJKp
	 tPSEwhDqkN9vw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8F8CF198003A;
	Wed, 28 Oct 2026 12:40:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 28 Oct 2026 12:40:34 -0400
X-ME-Sender: <xms:eCXiaqiN7uW55pdnDLmQfMCpgqKssyEAlbg2kEo-5uT2EnxoO4ZuSw>
    <xme:eCXialQiwOxUKOiOgRbMVzuCX901N_ygNZZlIGwGmhUSPEOO024OPL_frpYc5UvRF
    ufzO0DZbg79qizqZNu3oZPsAJjfr-Rc3mcV7MSCwYMa2c4GY3IOmUfF>
X-ME-Received: <xmr:eCXiakFBqwymY7_RFYo0Ad-7d64WPxU19dNbSVic6uXNgnkcXdts2JTSFpw>
X-ME-Proxy-Cause: dmFkZTF9BSIUpdbqdcQtRDBoZ6omZu6gkWuOLh6CEtsiN9GCwL96yShYRR0sGWUfB/BAqE
    WZ64unNfK3Oe0Pmq84aQBKzz6U4bNLPGOt0L+3it1u7lBgkGfJBxf+KgimcC8ODml/Bvs4
    tVarhMXUh7RcWdDG/2JFwnscmJK43/IZh/RFjzDX4hQQAHQgOtEMpiD/6x6mNoabLgV1Uh
    8N833SkC9jtVG28yAz+w/Ea9Sw7TZ1VqhdC4+mQnrllda/7izabJuHYqT4SfvoZvONJ4j5
    MPW1Gk8oi9Trgp5oDcZSI4Pe9o74RJVHkS7lxxR8lsEZd8CIgsegB1KiHE2T7Z5xehGBqQ
    3UynFVkTFHQUjTSucs9dm2AKKwGlYfQ+KZouD3lwtJq+CNgLVrRX8hnysY6WtAmZYn+2FA
    UMKoGHv2nyQcjhytg8JcnhDM5D5FH8oTePRRudgezShXdD3VQZaIwdMFryvIDXfmNdG+xS
    x3FgXxCpjM1Dnx36WNsJr9NZywtGtqeBnpNa2CcH7uZItXr/EJtDkKFaLLDYrmrMYoRZy6
    9WMgAdXyW/auCalGZ898cnS6rzXymDqGbDfabqdqvexVbud3Xyfh83yzVJNAJb/KZJB0Dr
    RwkvxvaWvVMVXraC6fhht0GDpCcItQ8xXgQ8CizyTFww+xm1P2qA5dskCNwg
X-ME-Proxy: <xmx:eCXial92jNgSBQTxWlBjZMWgmR6TBvKzWaFSBoP-VAqjL0ukcNqioQ>
    <xmx:eCXiaiF9yjc9digKd5Ya1GDuxp2814mB5aHgvCvd4OHzLNuho0A7Aw>
    <xmx:eCXiarjoMRi8d9X-XM92nD_cnaj5ysHGPELtUq4mL-3Vs4NwrN19_g>
    <xmx:eCXiauHvY_LuyMcaATsWdR4V2wsHPU2Pnegr0ayYJWcc1st6zamU_g>
    <xmx:eCXiav1OXfLSRm-Vd5XTlOvlVQyXslpANnXfV-qVihMApMQBeiD5C2MX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 12:40:22 -0400 (EDT)
Date: Wed, 28 Oct 2026 16:40:21 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
Message-ID: <auIlVgNRuGsBrRso@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 20F7A40008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: yds89ragcog4sjqya9oqyidg8t8kisqf
X-HE-Tag: 1793205640-194695
X-HE-Meta: U2FsdGVkX1/apRfO4CJ/FLwpsGpYJD3JFHnYtLWpAIktTdQY6DgV/ykNtST610ePKPZlUWYhvnFrcZSBzYj5obuOBwZyQ/U12g4U3edOEiC0X4SVsDpBuxonKM9pN5ZqArPhzunATZdPuwruhiorJZOBGMabbMUcVqMTIwPJ8ZRrYAHAWIkWNDX7YNOpKZ1qqj9ETtm+chVHZQAwWf7Hi0rtBleYNpKmWggOVwNSmQsdtRD27nmHy/YANMBmB3ro1sGPa3zJ0ggfq//IhfY9epuTrac/29Skc8RRObCv+Yl3Kxy0pZlFeLeQWAm7v2piCp81HfIMM3jXyDxp2A47EYtA0fqy7fOlmEUWC+6YsWanYhIAs0T0skw8xEPcY6nt0uyzAX0dN1cDb3RB5fgamoJ9ikeBe2iLkcCqW5fjl5e3Zo/EX+1T7ugYuPd9+I9U0SnX26ZASd92PFVr7L5usE1keVokxum/gnoSI0Ds74XiZZiesTNtQNetIo4GDJUzzQbBj2FWHa071ex/LNNee//P1y0Lv468VgDfOb75W698qXMg69iFUbyGARi6d+ttnr6gelf5nJgTsiYhql6g4PNN4fWnDEP5agbb40tSsjLZI9tyZtFafbsd4os/tiAcswOhnCejo0WweHA4bCLXHX8Jbv4htNuzniDd8ZJYzjX1sFGrUtlOXz+c95HgRuEm1qeECBZTw9lcFlj/rmV0S+s0orKo4PdP04y+Mm7JzEfm2mFEtdMn0amnU4nnH55lIW84v9l9c7CZcIO4kClQmB8KNlA+mGDJrbDqT/gGmE4lt2AY7hNXqXJ4GR7pUeq93FiYCXE2wM2w13OggDgRJZw4a5cwBH+HQhxIs6C3sf+6PtEDs4kww6E/IiQ6mUaS2zPXYmvVcAHPgeqvYNnCEvW9zSYV9b6lt02Bvm28nkQcYT50VWJJyE1CL+rSNnll+9VkNg4Y88MG3ql9xRO
 z057Lnmt
 RHVoQasgWWlEsxhicbIZw6h6Y1K7pPVwBsjL3zKKr6XuIBn6P8KNrMcCo4530Uu3OsVUzJxALfYGpBTqoOpmQ3eEHe+5wDVDqNWIJKL4CPbIuD6rqTAPCk16EX8iBRzpLgcB2GQtGKcN07VOXcrRqp2C8hrz2elUk6KByZZgDKBr3Rx2Nyke3ja8m6P4al8dX+pQlHzHho5171ZzDb8nsk9Vh1VT0oZsj0QT243FkLZ5Uxjgw9HTnkpaarBFX/M8Pn6wgs+3f3df7ZELNXLZTKQXaPU7m6/QkqrJZID5csYdt1z1pcSqwqqM0GECqSFX5PqS6TGoxcI136ZgT8gKfUrYcsl28kN3pizyaO6RRiYA9Ph4cHGp5680CZFVwtXCvhHEH+BiGn0Fd6ee/0uBtOdC/RqQMEdR08U64bjTjwnT7TWJy7s0D1dOvuTcV+oBn45hEPYVzJpcHt8SJCbC+8ndpA4rOx0sjA74x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:24AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
> read(), write() and lseek() on a shared open file description of a regular
> file serialize on ->f_pos_lock.  The flag that asks for it,
> FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
> too, but its struct file comes from alloc_file_pseudo() and never passes
> through do_dentry_open(), so it does not get the flag:
> 
>   CPU0                                CPU1
>   write(memfd, "a", 1)                write(memfd, "b", 1)
>     pos = file->f_pos  (= 0)
>                                         pos = file->f_pos  (= 0)
>     vfs_write(..., &pos)
>                                         vfs_write(..., &pos)
>     file->f_pos = pos  (= 1)
>                                         file->f_pos = pos  (= 1)
> 
> One of the two bytes is overwritten.  Two threads writing 100000 bytes
> each, one at a time, to a memfd end up with a file that is far shorter than
> 200000 bytes, while the same program on a tmpfs file never loses a byte.
> 
> Set the flag when the memfd is created.  As for any other regular file the
> lock is only taken if the file is reachable in more than one way, and
> nothing a memfd does in read or write waits for another operation on the
> same file.  This cannot be done for all alloc_file_pseudo() files: anon
> inode files such as eventfd are S_IFREG as well, and a blocked read holding
> ->f_pos_lock would lock out the write that is supposed to wake it.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: minor description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

