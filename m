Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD12606D056
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AaE1y4q+
Received: by kanga.kvack.org (Postfix)
	id 223696B05C9; Fri, 13 Nov 2026 13:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FAF46B05CA; Fri, 13 Nov 2026 13:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3856B05CB; Fri, 13 Nov 2026 13:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D919F6B05C9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 696C3140204
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:50 +0000 (UTC)
X-FDA: 85431002580.22.CBB7248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F8AC40003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AaE1y4q+;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596208;
	b=MkVrBsK8pJhcF39lfxtNuvKLcSds0zFk3l9dTLI6SfK3tuNd8Orttx6l0X0FIAye3u4kFU
	IYhKcQlAKfIHoCG0HHzNZVEKoeCgRWl54HXcz/Mdv09U/zaJisp7CGuUu4yz77MY4a0PRv
	p2nLx6dKg9hJt8USFOO/dkXkXnUky8M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AaE1y4q+;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaBAv/H8BT4vm7qZdZm8f+J1eyq2A3r6KggVt6sufuE=;
	b=0QvagZOe539bVzpFJ+oIBLFRvlHK6zBZj24JB7kkb4ZRGz62OKsCSY3/GpNVx1qibhUBUV
	bS8VWwZIFPUeVRlcj2c5rzPyLChVgBRcIfha579fLWhG+PTSfV44otksU95d9XzXm8r5z6
	tO3wO8n65n4nKvsgvKKLhYZ0kHI2ELM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0307F46637;
	Fri, 13 Nov 2026 18:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240ED1F000C6;
	Fri, 13 Nov 2026 18:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596207;
	bh=EaBAv/H8BT4vm7qZdZm8f+J1eyq2A3r6KggVt6sufuE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AaE1y4q++14YE+IhwkDHq526uKCelbaOwgasfvvC4nM/4hAhiYAO7UK+ijyX/ar2K
	 RcF9z3EyMuug76TE2MqnPN2zWnCcm8jTzvzD51ZgEqYsfg4/t8IDDX/GqFCDl1vhrC
	 lS03Ce5DsUfiByziqXEoTJGp4FyelH9mFjJ21U3K8rzL71dB1L5jvKvnw29yWtG/k5
	 oYaPu+ChzIYEEiYVssqHg9c1J3lM2qqyA0QQlJtW1QlWTTSRsyYTAN3TebDz5DbyaE
	 mgC+QvXuFWfDMfwcVSWr1BdmY9ZPFHBKLQBXw41STjLTQz9S41ytt6jjSxenfIWl17
	 oTSsNoPlU4QMQ==
Message-ID: <603cd8e0-c2c5-4c1e-85c4-d0a5ceda8d4c@kernel.org>
Date: Fri, 13 Nov 2026 19:56:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] mm: keep writable entries writable on protection
 changes
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-6-clopez@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112142039.907090-6-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ea4nhfacikuqmq7qbnt5je3h8no9a9x4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F8AC40003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794596208-521755
X-HE-Meta: U2FsdGVkX18DLduqqmvxRUxJqMibRnZreWPyDxnYGfYSW/TYe0NHOV1/pa2emE1M22SRFGfYx6i4NE41YY0xMOhKajN9l/W90QKva0fYoJUjnpO9PEBUIWEnOjeAMT8bu2o3ggv4NjwnO3yqcGp3TtG6iD8JIbDP+RgUkQhwR/G/IQk69gXYzl2SyPygrjOoCUhMAUKY+3aBIYFdUt0ZaHsamG6FVsS8qnOEzh9oPBcVUNpP52oArO9Q7g1EltIFNAU/E643xSCYv1L2IfQiL43IYpStvVt0pOKcefqdP0SZTWTkja1GK74ZHt+TBlWo/Lk2nIjnsqnrq3JrKW2TJuYg2mPjBmcBz2Stx31uJcng7cB8L/taJnAvcnR9pXZF2hQIA6HCcfKaopgvAfpIkDLeH0qyj5TKXyz3cDntG1eEa0fxA1VFXj8Q3spPbrimdfwrFlpXA85sF8xDiwCM0mYF3bVU2Q3SFvFXPGnXmk6YLrR3n1umbFY7kU6IXUY5Or9Qr5lYQX7ULrWaPeism+u4WSD9JzhjtZoue1MtLDuGtLI8Uw6Ixyo/gfqOevkPIP/5MU9vy/Skd9osqayx8Ne//xBL8k8iANbGgcC/KvMMc94hQKo4YCXGrFoc9mc8YVmFNZW5eHFTZDuc5voEkGhoOT+DY6zejHkXukYq7wincO2HGMxlXZBkUrV8kyyy+tRbcf6r2mj5a0dTa1YOGjJBxpzp0KArF/ts9eo67IpywQjneSpsmrajh1H/RmPUFjypzMuzFS3NLcCoUDP0Xz761fecCwUeuIc0aYjt7WvofnX0iNnZ7S1MjAMVLPUOz0j6iCcg2gbFlT5bdmJ/NIWWHLnc8IemHFl1nnmCeIC/Qzyz/uT8mZhfA0z6dSRFenkUin+TVi9pF0lZtXcia5fo9o2cu93W1F5hJ6/66rsRxOZl4InJmO85KWlfgiZh/Ql+JZMUQKSRS0pihUF
 B1g6vs9+
 BQOgk0okUireoQwXMAmGqBxw7aZkivVO3kGGCSo5je8RuJO9/7WonD6RLvcgbdDpYtzJbhmB2yzla+myw7pUcZ8uYWUcVpEZvJ7Zt2Q1MvTGtSLBKjIYvGX/xlseZeVOZcZWprmIM87buvpKInZhbrIS9sEHEm5oMx+trkIK9pVrNkGH7zCujfMJv7ai3uBVjCxxJaqiExmqdJ35vfLIsmqw4jGoedI3gI3acsc1PHZPSwVVVLVwoX2C+BX56wM7BVK675Xq+JvuMAsGi7MgUpWFvgM0sRJVnlGug
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 15:20, Carlos López wrote:
> change_protection() applies vma->vm_page_prot, which lacks the write bit
> for CoW and write-notified mappings. MM_CP_TRY_CHANGE_WRITABLE makes
> entries writable again if a write fault would only set the write bit.
> In shared mappings, it relies on the dirty bit for this, as a clean
> entry might still need a write fault to notify the FS.
> 
> However, this misses clean entries that were already writable. For
> example, a uffd-wp unprotect makes shmem PTEs read-only if they were
> mapped by a read fault before uffd-wp was registered, so the next write
> to each of them faults.

See my other reply, adding such optimizations without any motivation why we
should even care is not really what we want.

Drop it from your series and keep the MM changes to a bare minimum please.

Or is there a real dependency for your work?

-- 
Cheers,

David

