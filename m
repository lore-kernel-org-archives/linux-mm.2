Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FFE606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=et37q7q4
Received: by kanga.kvack.org (Postfix)
	id 9AE556B05D8; Thu, 26 Nov 2026 06:17:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E6B6B05D9; Thu, 26 Nov 2026 06:17:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8740E6B05DA; Thu, 26 Nov 2026 06:17:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55A4D6B05D8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:17:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D96F41603B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:17:31 +0000 (UTC)
X-FDA: 85477019502.19.A03F361
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 11D84180003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:17:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=et37q7q4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691850;
	b=cnK7ETQugKIhyQjqHXKAS7iaXhJfX9HN24Z1z3oNtISWIXxEfc79H0hgENOKNGwuUB9bM7
	AL+glZ7tEwbAxqnTL4SVzhYbgtpt5EJzBYjuhVmW8iTgx+F1VrO692lDT5Q5i27BedNheo
	4Vqdrfn/ihDmP+aU9Cxp0/DoVseBCMQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8anWI4wnghqDwMT8IkGpbFVOQpbY6mA/D0RVRsfG7w8=;
	b=0vrxuQMi8IYfea88aLaWYW3yePLIZcUIOVEPxfhXnLE3v9x1TWa05TWCuoLqYmsXvHmKED
	DxE8mS+1aVtTcrbKAq4kKh6wP6uDWea64+vHXSsGXWX2MfBgtadlFLrBeIkeKtji0jttrr
	A4DNagwTZbQL1ej0WYFvu8R3AEJW6YI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=et37q7q4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D37E2630B6;
	Thu, 26 Nov 2026 11:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5901F01568;
	Thu, 26 Nov 2026 11:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691848;
	bh=8anWI4wnghqDwMT8IkGpbFVOQpbY6mA/D0RVRsfG7w8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=et37q7q4eqHRyyOeiojSHRmMB0v7Cm5o63xhU9cRdI0CehXFULk9kBGbiudTHTVr/
	 o9Kg/vmbbCShoj3ZrKfkdz7XeqUP91dWb2DaKuJvJyXkuHx6PpzX8sEIjPcJTAg5JC
	 2ppBzlDgGdkvE0rcMUUQ8tccZ+SypPeCnDj38kL9NTMXVKAWj7/2/FijXE0xhMmkn/
	 TZ46HKa0gexKebuz8NPxghK1wtRqUTIGrY6dfburH7t4T77fVCr66J7mZVmxU68oqw
	 /uYkDtNR99xnqcqQN7qc3ObNwhrmn+CV3DQuLdLfEZIAlobrGpBOqC0oWKIYsJiJ0J
	 7NPmzMzUGzdbg==
Message-ID: <3ee0f274-0089-4450-9888-7be659af9d63@kernel.org>
Date: Thu, 26 Nov 2026 12:17:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: stop hashing address_space pointers for fault
 mutexes
To: Zhengchuan Liang <zcliangcn@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Davidlohr Bueso
 <davidlohr@hp.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9a97a64f7e7aabc668499c426a2417a77d13a2f4.1795587203.git.zcliangcn@gmail.com>
 <4ffa6613-119b-4eae-abbf-26134bd60177@kernel.org>
 <CAOny8psx408zqVv1xt7DHN8yYkQksjKZFDQCJ+AGFB-CDN9SmA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAOny8psx408zqVv1xt7DHN8yYkQksjKZFDQCJ+AGFB-CDN9SmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: w85daiysbcrodjwi8mhimabbehb5niub
X-Rspamd-Queue-Id: 11D84180003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795691849-973152
X-HE-Meta: U2FsdGVkX1/d0cu5HjHSLRZw4ASxbu+jx20gl8miv789kIqOscHyGuoKctDvp3tG1Wwo2ShUqwVGRCgrAxLUCZOFFbEy88AySgFBCajmqPaxffN93KKO6g9d8MmD2KxHhVl7ewMDCfnv0QWTMD9Aj+E/rhRg21Ohn94HV6Ox0EKuj5oCK2RhIvySBvt8QtMiP5ull8qYYIbS2zLn2pddzVhuJVT0Cf5auwYc9kByyf1HICSZS5Nci1PD66hYZlaT1ACEKtaG0CWk7gOQywgpHc+JxT4MM9Z4Yf/tqCLDPBGMlGX3O6uEslCk+c+HhMJzdv7NGiI85mGg1MwD4SFKL/LV38oGNsRY8VIjTdTotEYD8YeRYE62TyKwKxxy6UtPOskDDI6tYLYuVpqstDm5O+k+oicyG5HsGYeZ1hekxxBiNTGoD/ep/SHPVhRmd49568eFrNibMxokBx/17t4v4AdafwVRdbQB0rEfCwPGpBozlUeB3F6hs0TzmFzutEc8gO48a+7/KqLji9ZhqqF/G95au4I53VaC8yFQVCym4lu0KFMK2Y6N6N9OYxOfkqwvhQHVoNlFZhYd2ifK0AmdkM8oWeX1Ckf9cFiPBtvcjaof+FUoJjW5SZNh2EajLl0SSADlov2+8mugDeGoFZVf5fn0PC3fFlCFyttqbU2vLYNJP0gRzjR1ODw0Ds2nY9w/quOuNT8T3S2jVQSOX3MCctqv5OialAx7wkIHQ5fy1XhbFpR3u13alIGGuBuABVAjeGi52J8qStpSINBH6o53wskGaK8jrPI1gBQYKvDIEpqGC/b9oC/gT3FZe5pSXc6CFmCLq9rjalVbbUh1uE1gK2M3ADaiChPqRb8hziK2I/KkjHof1+t6WgNjGnZ8kRLyAVrJ+80D+aLdP4wKr7QTojcE/b2rx191QqtEKs9FI7D5vkilqukkAKSdhrjHuTevXiJwW/9JWNn8DlkcPTM
 c9U4PWeM
 Pvv4OuV5ZSrcsvjMKc65fSvJ3w9zswv065+/3r22nZiCHmBYYT8QPlAOXYHNtCciAbZUNFfg9sXn7gF6GkfQO3jJkEY9dQLWfjAwzlg/X1sYPrrx+5VSOFvNjn5yEiaoaThUsbI9zld0OVdFufiGmHi08umeZ4jb4zPEi6iFCoL/0UHzhPiB5Q6Tr6aEiMtrSlPkyPhZEX8kwfsAWKxU4hiDXZ4+yaW6yPM4r4wAIkebo8saCKR5Ca32VGJbP2cxl+a6RG7s8ntBchWmLez03UHlPZUIKhcad9x518fchfMiCvWPTk5EjtYAVuqqhV5095x3Y3m3bEhyuJgbf7fQOPyEUIvVyAHqi+6n5pXeACYmrb1SBkPQSUsEpQWVmYtImsNfyRct0aPywWcY6kV+Oio8jMVORqFcHMamdOCQomXitegUQREirm31lQ+Wlq7TYzH90WP9HpzFuJ0Hw6Rg8HKYHww5xj7t5ueG/k7nwAc5DIk32zBdUkwHsj9N+IHRWd57XNwzWqvvAsvqPMzfYyfIPLBKFNetxKfrN39WZGh25P8RRHvzTMS6YvFsXdFe/D0Gm1/6FNq7JzzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 19:59, Zhengchuan Liang wrote:
>> I'm not sure we care about this problem. I'll let other speak up.
>>
>> Attacking hugetlb users is stupid. This doesn't matter in practice.
> 
> Thanks. To clarify the threat model, this is an exact kernel heap
> address leak. 

Ah, sorry. I was jumping to conclusions that this is about harming other hugetlb
users.

> The attack does not target another HugeTLB user or their
> mapping. An unprivileged process creates and operates only on its own
> no-reserve HugeTLB memfd, even with an empty huge-page pool, and recovers
> the exact address of its embedded address_space. 

Interesting.

> Since that object has a
> fixed offset within struct hugetlbfs_inode_info, this also gives the
> exact address of the hugetlbfs_inode_cache allocation.
> 
> KernelSnitch (NDSS 2025) demonstrated why the address of an
> attacker-created object can be useful. It recovered an mm_struct address,
> freed all objects in the corresponding slab, reclaimed the slab pages
> with msg_msg objects, and thereby learned the addresses of those
> replacement objects. Here an attacker can similarly allocate and release
> hugetlbfs_inode_cache objects by creating and closing HugeTLB memfds. I
> have not demonstrated full-slab reclamation or cross-cache reuse for this
> case.

Right. Do we have any gut feeling how exploitable this is?

> 
> https://www.ndss-symposium.org/ndss-paper/kernelsnitch-side-channel-attacks-on-kernel-data-structures/
> 
>> Can't we still end up with the same problem, just slightly different,
>> afterwards?
> 
> Yes, the timing channel may allow the per-inode seed to be recovered as
> well. That does not recreate the address disclosure: the seed is neither
> derived from a kernel address nor used anywhere else, so recovering it
> reveals only this inode's bucket distribution.
> 
> A simpler fix would be to replace the mapping pointer in the existing key
> with mapping->host->i_ino. The inode number is stable for the inode's
> lifetime and is already exposed through fstat(). This would preserve
> separate per-inode distributions without adding a new field.
> 
> I understand if this particular address disclosure is not considered
> worth fixing.

Oh I just have 0 experience with these types of (let's call it) address leaks. I
know that we, in general, try to not expose PFNs/pointers to user space because
of rowhammer.

So this probably should be fixed.

Using a random number looks good to me.

Just not sure about the severity.

-- 
Cheers,

David

