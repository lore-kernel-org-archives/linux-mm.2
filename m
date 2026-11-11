Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C31E60A3802
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGumbhOm
Received: by kanga.kvack.org (Postfix)
	id 4EBF86B00EF; Wed, 11 Nov 2026 16:54:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C666B05B0; Wed, 11 Nov 2026 16:54:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389F26B05B1; Wed, 11 Nov 2026 16:54:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 109666B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:54:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88568A03F7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:54:20 +0000 (UTC)
X-FDA: 85424192280.26.D7DF4F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id BDE371C0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:54:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QGumbhOm;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434058;
	b=pEAcjwQgpheK3OYsX8BWQ6GrClSQadbMKTdK6i2RikkVMd/Q+9GfO377ixuQBllWBedYS4
	uPpWgRmnT8T4eahxMar0P1ZEuJ+jBI4VgrWDDepURXYf2JB8AQ/ILsxigIP1Q+zODPDi+0
	MVHMJvWIFm//pdeFjy1kmu6+2/l7rSI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QGumbhOm;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dB9rG3yxI/9KOZZCGEA3D79pSB6yMsbFsQ1L/4AJU4A=;
	b=fojGp0Eh6quCwaX5gMd73pofRvojJRmE5HFs3KSG2jGzGwa792vYDwEhU7lazIjH/DGMbs
	xUCf2uXLwezcKKjTtZPrzzqB8mcZTrDvDIM8VKAHSVjfgJ8GrDDX1xVSoGr64uU66daxni
	V1AJK+R8VrvTZcH+DtWKUVfxpcY+KSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 410A663548;
	Wed, 11 Nov 2026 21:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E80D1F00A05;
	Wed, 11 Nov 2026 21:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434058;
	bh=dB9rG3yxI/9KOZZCGEA3D79pSB6yMsbFsQ1L/4AJU4A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QGumbhOm6Cq5mQ4GhXcM1bIeSh2FhKu6qAGcjDV91fS7iPZ1RM+bqTK+9qusyOlEP
	 uZUwH7N9LRXmKtCCbdrv6Hc6eyFJjbQuURmNZ2Kyc6N9tKgp4yAL9cEfJWzRkokhQ7
	 iCK/6ESLicH/EM+mOCGRT4FtsroZCGpwwFbtuZkdiQNcFOvgpkjHXu2yh5BULMJlnE
	 3ODMwqBHd93qMF9obH11mwpm2BbMeIxmGElOwh7c8/L5rYWNMz0uRA+t01H4ynbtR9
	 xE+Dxv+Xuuu+mbUCpYbYU88eoL8iaSLYtSSxz0Oxl/yHaGXeV4KqLeutclY2kPzIoW
	 X6fAR1OYdseFw==
Message-ID: <ef0432fc-2d00-4568-8087-cb39264620c1@kernel.org>
Date: Wed, 11 Nov 2026 22:54:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/13] mm/migrate_device: fix ksmd oops on a migrated KSM
 page
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
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
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-8-3d2454362e8d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-8-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q5qorcb7awrupopfjtgi1bczfqtwsusx
X-Rspamd-Queue-Id: BDE371C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794434058-135509
X-HE-Meta: U2FsdGVkX18ypsLXFO3gEHvvVK3Z+olg3F2cOstbxQ7YVyCBdQ47ewcTGG9FxlGRi47Ok8GGeBntBBZliYMh3oT3kbwWlGh/U7yJonhBjYVcty8AGa0hpgl52Hb4xUr0WGhDpmRttXJnl9p4fmVv4JY7t+0ZPQUJsc6nfZIEfLnM2Ni5hqduz3ihvKIWCI/a6mdIJ/3L1Y5cblWL/lBYOPYl5B0WGF4XZdbQj8BJOEBzJCVNf1r1Ga4OIZDW1ew3WlWHOeqzX9kxtpG+U51yI6xorj7+KK4lu+M2ZagzrID5yEKI1AdLLa6C77fYj5OJDnY0UCyudmMY5BOcVyw4ekZqKdIS9WgMeChl7f0zisfXngF90HebmLCtKFbHw7nlqF7Yo9sd02Oa8gLBdfe4ddu0mRmn08DsbIEbxNGWbiiC72v+PljlUWEbhAMHoqhG01dNb+ptgChxl2mg6MffdyK4OOldfxhQHDawNN/Oo7sq6pw3auDzGsJJKdI6QegRxT4shjmmPh4b24GppiEG1Kosuzd60jNZA+uN1aticcChD8EpWr/lzUgsrbxnjcohJFmZ+yzwlbLX3QYrqP8yIwngDIlB618EA2KhSduPzqDwqU/zQhWsRaOoTIpUN44VmXXTQVXn4ItXozJvESd+FJHBRmAnDDOi2RqDRjUw5xSrEzhPFPfJfbhy8FovpXNDlQIlJxVG678Uz6Wl0LstDE/TiFuNtl64PyaTXA01JNOBoAhY3qDnp47Ynse9/9jHCjipe+jMryQtRSZJkNdaZlGOhMbRz1HkO52v30r4KkOe3Ye8nPtEMt2K8H7laSgnSCyLv1VQ+qXCEYQqtWpcpAkYs4vKodmvshEvhpVl2Wd0pnXFOjEmL4QE5WNs9TyPrKRTNmyEKol4HS7XHaCiN597/22K5Y75oKigiklP3acztcPCchAsO9nrPBsdWNEcs16Qz8yFxYZri0dHunN
 6i3NfWxC
 SOKugtLL2epteKsiZjPDPQJQezOBQ3IdFwxauLyi1OuBx1XC/eg/WrSuVyse6phb8vAFTbDNPWOkO3aMmBuGfXYJbd4l7/t/i8XDYPMPkXBoLGobhSZipSF9OHz3Fy/rAT6LZerKzvyYD17qJPVWgczJjK+1Eio8e98Q/zH2YQwZj2/rlhYGa2YHCXe44PkpwEg8E1ZsD884dW9SjRoFmbaXIeHX0YQX150yK/NSsAv9vgmLck7RLADgCSDk3uT1IWFY0gzwlCCrZP259zzaVwO5tP0gaseC5o/AJbqr9wpgmbFS9mhnRBtK5W0aQo3BKoEdoXje4poLy+9IhPtQ6+U9uRA1oP43+3ULyqFEgqyDpKyUkYqIK5HJjfpbe9wnmEaDB7AIewZUFHvKJul7UNfa7rYSM4HXoi7tNNmF072WqgL3igK7JYAVhqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 19:13, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> After a KSM page is migrated to device private memory, ksmd can oops,
> and KSM then stops until reboot. A process that maps the page can also
> loop in page faults when it next accesses the page.
> 
> The problem arises because KSM doesn't know not to try to look at device
> private memory that does not exist in the direct map.
> 
> Disallow this from happening by explicitly testing for this scenario in
> __migrate_device_pages().
> 
> Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: tweak commit message, comment ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 45e571dbfb4c..7ebd02ec303b 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1205,6 +1205,15 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  		}
>  
>  
> +		/*
> +		 * KSM doesn't know not to try to read device private pages, so
> +		 * disallow the combination.
> +		 */
> +		if (folio_is_device_private(newfolio) && folio_test_ksm(folio)) {
> +			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
> +			goto next;

In general, LGTM. I was just wondering if we could reject that earlier. because
apparently we already allocated a destination folio :)

-- 
Cheers,

David

