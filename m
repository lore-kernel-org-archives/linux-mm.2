Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5E5606A8A5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=V/y+WaSC
Received: by kanga.kvack.org (Postfix)
	id 36DFA6B05B3; Thu, 12 Nov 2026 13:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31CFE6B05B4; Thu, 12 Nov 2026 13:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE506B05B5; Thu, 12 Nov 2026 13:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6EB06B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:30:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5451D40740
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:30:45 +0000 (UTC)
X-FDA: 85427308050.17.5F333D7
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 59A811C000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:30:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="V/y+WaSC";
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794508243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8heaxWBSFkRNUlviiZ9nDMXdRG+6YAFJsY4iZ/iCCrE=;
	b=5yCmaXpT/iNAexhbvJOrQzrMq2sOrDB11/Apa7gPbbTbSZBk52pYAyL0G+ff9DaENRqcw7
	tKAjtZIHQ8B6hl4pFQndd6PC/KhhABTFVtZ634ge76i4deLxKsaPMQV8ADnHRGG9aT+PXs
	70laFMgPNNzpLUetZ4R2vIaqHGXcY/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794508243;
	b=omtr+flgJBkk0L/PXouQpY6cuOFa8Nt1tcBLAFXvmfOSoOo/Ds5z+/6IGym52m9svIMZAb
	VKfX1fS0lXpq7KR9e6Sgto0kN5ti1+hb/92+KmeDxGC17AYL2gCBSRWZ8A1saYEPg6R9hu
	/ONy0Kxbxqelv9TTmeBfTL86j6cDkSY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="V/y+WaSC";
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91ea5600c9cso1578876d6.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794508242; x=1795113042; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8heaxWBSFkRNUlviiZ9nDMXdRG+6YAFJsY4iZ/iCCrE=;
        b=V/y+WaSCIQT4/0Be1ka/MUBjz1Ehmt5ZoPLi204blmQDuGQ16/DhpDWtA9vFPXkU46
         PtlabXp5vuBrCKywE9diFBgik0+VxtswH1ltkOrKgbygoibKJvLZzQDEq91pQ/0YgN2x
         39kaPk0Gtj8klXb3Xa7r1IIJIrNtAW5EOe8ksMBxqjD/iwUx1exWBZGoGqlk0BL9WJ5m
         n1bIFc3gcIZ5Wr4BLhde/BdjLCf/skNS+mXtvl7Xn+Xg+FzwvwVvpIJKSR61viDJFF5t
         l2+BmFcYG6npvWZkxwbIZU39jI6BvhD2BEvz2DAJoHHzeTKxh/RaKH5upyaBoulOqGBe
         1iqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794508242; x=1795113042;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8heaxWBSFkRNUlviiZ9nDMXdRG+6YAFJsY4iZ/iCCrE=;
        b=inp9XfIBatTQLFuSg7Z+5W3D76mRiDaY0gQVlfiEYW1znihMjfFbWIZn/999E18YuN
         fH7HNWENwdnW3kFbuS84tsNZYY0XTNYy6mRR1z8+Tax/iBq/ixfHbdX96aG89Lmt5p83
         7jFJy7xC6FX4S5n5KVSmc9Ui4sKEoiLsFvXKr0AJKPzUC8VNU+127n90hEML+jxJ4Hv7
         oTCJgvfAzXtVvyOHhrOLLPFVl8XFtzsmalGftvKpuvbGYG+8eGJNmKt5u/f72apZnMC5
         vZSK6+u9sJBMs1dB/dhjylU9D0dQq9kYR+pJLKWAGWlC7S257a+snJvi4hMRBN6lMNjn
         2Ktg==
X-Forwarded-Encrypted: i=1; AL+hErEgKjG6lG6QNodjZa18ZgSebAMH8GmUcbNKzFxG98mC8bYJB8UQNe4trFJq6RmZdBoKVHL9nlM1Yw==@kvack.org
X-Gm-Message-State: APuU4Z/4sTa24XxU7uOc7PRfxdnn8L8PVOqAi9rKPtAcO8hNIzRLRhVS
	fSc06h+0mFZGhu9K1naKAkEJJvF2gtQCLHDDGb3IsLGI0RV4N6yfKvJtpxtp9dmvW5E=
X-Gm-Gg: AYBFou1/P1lRcv27dU8aTE3H2V9Rr0MpX7psU2glupUnEmFQJiDPrmB16gC3nuobxsJ
	B2sRTp0h0kh53kDoVK1lglja2Ek9u2w4/TFSKwZYmzUR+FXcp2rleVyc0NNeMjGeRq4LPlSXmN8
	s9ZmdHz9GweduGPGcseeb2qPtWkFK3eXDIMjlsnyF/KKLuHu4zWKgi/YumOqn2k0wrM5nqjVza/
	U/KXRNGP5CuDJHRGsBQ2STcuXCCd5sqqx3l9hWSpblFcdw5sbcRfWzNuusF7DmI8AJuegV7sfJB
	jl/q+bZvHz9Yj/u9CBWbH25Pi/h96NzyPPgclgdbABumbIevUMHHBqRQCp51O4SFLUiwjZ/5mIM
	zVX9knUqJaqvsMBgn9eRMIRpBHMrVTU5y1bT/i9/Fg32XKxzYUtpb7h7DjOwSOBE2lKjhXvy0V0
	FnUdN/14mVrtmNBH2QqEPTYHq893JEU0D11k5glJP7dQy7i2UJlmd2wHEbXSmXpMwT2Siuin6EW
	8bU/7NWd41zd6eABGSyRYN7E6U4dhoIhN6AlqtvTn5Wj8tNnkooO4/uqLXAejMI9aFYCK0QhJPo
	nBD1RjkBxuYL2v15/d9V7JL2cwp6JyICcN8OwNKSmCd6tbmPVSTKyRHlb0GJC6A3uYA5T8cjteS
	WBlF3c7Y=
X-Received: by 2002:a05:6214:4187:b0:91e:b592:ee15 with SMTP id 6a1803df08f44-91f13978bd6mr53482146d6.15.1794508242079;
        Thu, 12 Nov 2026 10:30:42 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23da1023sm1861256d6.34.2026.11.12.10.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 10:30:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 11/13] percpu: fix contig hints that are too low
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-11-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-11-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 13:30:40 -0500
Message-Id: <179450824041.482102.13630289942269263315.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: r4ug5e35t5sjnfhmyfqxcx5qzrhjgkjr
X-Rspamd-Queue-Id: 59A811C000E
X-Rspam-User: 
X-HE-Tag: 1794508243-824198
X-HE-Meta: U2FsdGVkX1/kEl7DB/gradTBiqZbm3dDzJN2zJ/G8FWGYUrp7vQO6VK+xeVrcrpa9HVR5HzJuKmr6NIvUboQBSooCEB+paTH/uTpXMt2EuWuPlEkCUXUB6Ilu0wzpf8eBIKsTbj3FJzipHoe0GZ5nWY/UxZSSdebJVtqubVMbVX6yy86i+tsw95GOLNABMO74ZcT5jUeVTMQth5VCiBGwEC5aS+oCqcXuumqKbzO9volZ2PRNhUINdfERohic5G1Q9feYdOV//gYL8okcbsaImHlR/R8mxCt6OuN6B/lh082o19vMv3XRasO23G54o7yaCFipnEOwPYQS1XIwXlyNtiElWBSKKLEPP8deOkU3bIeWhT+IPq7KHwVie2WY2ATkOyJw26bA8OP8A/00h6shsr59VU4kr24AHfA2zc5W0Boqt94Km7uOG6ShuvhN7OEjhCBXIdsZfVX6PhZEP+HgGgcHOP0DLTF/5vrTmWCso/K4dNrWveX/RIpUE6xlC4Vk0jLTiVe0LfNlVI3E8KKrfn97cPytrRyYU49x4Th2bj8IgFKt9kUPQ+r/VwqrBWa3ndqtgk36q3WtJ6dTUvPODa1cKtYT70IUyXPvHuzM0jcH7VOh1ojN4lyFc6PYcTxL2yVz9UkQ4iAINSKnxg5eAA0c4S8UbITnL6Y6m0HPTDUelbiCA3CV9H9o6Dxrm5DMtm+GLMqKXfX/A1v9a4K+KhyV5aRTzSjpU7q63L994yb5Q9IlzWCnh2FHI3OPiGqReFqAT1KdkWAF5Jv6E1zzyTwdR3AgtfV/gfukVj7k7MeqS+igctqYTxW+jY8dM+8pEVA+fMoccGY3q8aEYtwaui5i+/XvMeWElRmiSyYDNUNL1zBCfoIwrX+rxbJtLm6bVFeR0bG22KMq4LvwkWdA24sijBnx6Yl01F9CKtjxQds5VbNcTjgZwNLpcVbG7YgE4sjhvopL+GaGGR+5jl
 AXY5a7ef
 zXfyE7qvWpXW9/wMfKCWt248K3IT3rLe1ZkXg8brJxsV+uJPEaSKTCJuszc3mfc07x7wJslt/YtIr9tBh1YzdrXW/K61GNFQRbENp6ukXSvbDmu97540I+DR/EtAbQMybvTN9JS2olyi3KwXz+eVuHN5/CPulvpRyLH8Xg2Pw/wF/5DBLp3zD1XpKtNlKb/O5DuPXwE82nkUx/Jz64X4aKl1uheZONzdWmN5RJpvrz3kmIm5xj82MCwsG18lyP3ii9366Begh3ejMBg8JfsnNdZY5ie3yQrYqCXPUWWJ4aBH2wYzvUY3AcJJLWBV19GGzAyAZx8W0Szfw4dgVnir25JwDeIlAGsJJJGrc14Znba8f75IZscrBGNTYUrVjRSYHoC28Uknhl+9CiPgTYh+5M5gjoB/7lxtKAv96
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> pcpu_find_block_fit() skips a chunk or block whose contig_hint is too
> small for the request, so a contig_hint must never be smaller than the
> largest free area.
> 
> If it is, atomic and reserved chunk allocations can fail spuriously, and
> others can create a chunk which is not needed.
> 
> There are three ways in which this can happen:
> 
> Firstly, when an allocation breaks a contig_hint, both
> pcpu_block_refresh_hint() and pcpu_chunk_refresh_hint() promote the
> scan_hint to contig_hint and scan only what follows it. However a free
> can set the scan_hint regardless of what precedes it:
> 
>     free areas    A = 10 bits, then C = 50 bits
>     hints         contig_hint = C
>                   scan_hint = 0, cleared by an earlier allocation
>     free B        5 bits between A and C: scan_hint = B
>     allocate C    contig_hint = B, the scan starts after B
>     result        contig_hint = 5, but A has 10 bits
> 
> Secondly, when a free stays within one block,
> pcpu_block_update_hint_free() passes the end of the free area to the
> chunk hints as a block offset rather than a chunk offset, so in any block
> but the first the chunk hints are not updated at all.
> 
> Thirdly, that free area stops at the block boundary, even if the free
> bits continue into a neighbouring block.
> 
> Fix these by always rescanning when a contig_hint is broken, passing the
> correct offset, and refreshing the chunk hints whenever a free area
> reaches a block boundary.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: da3afdd5bb54 ("percpu: use block scan_hint to only scan forward")
> Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
> Fixes: d33d9f3dd96b ("percpu: use chunk scan_hint to skip some scanning")
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

I was able to reproduce all three conditions and show the pcp allocator
will over-consume memory and in some cases fail allocations.

The change otherwise looks reasonable to me, falls into the class of
"Avoid doing clever things" camp, which i like.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


