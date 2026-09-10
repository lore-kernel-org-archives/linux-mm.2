Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEA9C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA4D6B0092; Thu, 10 Sep 2026 06:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CE86B0093; Thu, 10 Sep 2026 06:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201106B0095; Thu, 10 Sep 2026 06:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1CFD6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:05:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A87E12043F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:05:32 +0000 (UTC)
X-FDA: 85197420504.28.A9A61AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 750D4140005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:05:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QzBHpLL7;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034730;
	b=fFQlqFh37Sw4IWNK7KV6VhLy3lH8z/5tFbV67KRAxqoee6aoozq/uOgpJQzC7mEJ70Zyz3
	tijDzeU177yN/NHvwtpvlZR09tAu6xzMt+h1V+xHEt1YIawbUciI4w5HvPUhV47jqGwVvu
	SxE/t9ti/D5IjBme1nGKEQTTLg6pdbM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QzBHpLL7;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foN56LOD6/Sr9Fuua4UGrrARCTUwXc66j3xzHR63FGE=;
	b=4eImy9R8yitWO/Eszoll70FbiyheiqiZGVNGHd/OcSPaO8yR+IZB7d02FhjA8QdPdSlmOk
	41CQSg/TwUgifHSZuko8EztQIuHW3gU1bbXV9t04vghgOlgbYBOk8WfYMOuy4sNNc1huEL
	x/wID3rC83UwU1E4wm+SYhl6aFPkUik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08014600D4;
	Thu, 10 Sep 2026 10:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A3C1F000FF;
	Thu, 10 Sep 2026 10:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789034729;
	bh=foN56LOD6/Sr9Fuua4UGrrARCTUwXc66j3xzHR63FGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QzBHpLL73o0QRHBq1BtDWHfKhjgH7vYQlOQTmd/7CsBCnteHkCGmQ//nhe1xBe+XC
	 B+J/EOTATm18+r68ByFk08E1DHO/jGR+rAnUx1rseFVGhpIozwzwFhzDF7sOLJLeQ+
	 I9XUGlHlf+t7B+P5tn0YTppgcLchcfIELLFXodhjEkX4ufh+VLtkzkBdboHmg+39OE
	 6g/BYc6mcelHh8Dvj1YRbZL2cncQvh7KDpBKn2qNLUqTx/qsd0Ozx7Dp6POJfFAdiR
	 tfvp/PiJB/ZsLE17ZTAn6ACIgPYGEels8eKnoLC09LSAs9Q4EgK8NWvE4szHuqmUUQ
	 HqOFKQ1qoF9QQ==
Message-ID: <e0120f1a-d53b-46a3-9542-030212250135@kernel.org>
Date: Thu, 10 Sep 2026 12:05:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] KVM: guest_memfd: implement folio migration for
 non-confidential VMs
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Chao Peng <chao.p.peng@linux.intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Pankaj Gupta <pankaj.gupta@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Nikita Kalyazin <nikita.kalyazin@linux.dev>,
 Patrick Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Peter Shier <pshier@google.com>,
 Jim Mattson <jmattson@google.com>, Ricardo Koller <ricarkol@google.com>,
 Ira Weiny <iweiny@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
 <20260805-shivank-gmem-migrate-v3-3-00d8bdec4e1d@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805-shivank-gmem-migrate-v3-3-00d8bdec4e1d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 750D4140005
X-Rspam-User: 
X-Stat-Signature: jrr9mpgoksbqo43qgezy83sge9ht71mf
X-HE-Tag: 1789034730-974309
X-HE-Meta: U2FsdGVkX1/d6anPcic2TN3AwDROWUuhYqjI9Eb/TgZwdlbfYgz0fV8Te7rwFpLAxkdGl0lf4Vd3eQduxbt4XLq4Z7pfFaIlYnM8HzQwM3HUWvyEXovA6wDKCWwCguKQqwuJHjpKWnRqNvzE6rD/x0+DKXJzvf6671bdz7c9BexeYN51rcooVXYFHZgfrBGMGjy29Ik79LjeEIUHpRbNL0oRTMWF9oDwZYpBhhblJKy1U3E2keeN69AAexHFiOiYNp5rHsJqzUm5DcB3Og1xoO19yapna+Xifg2RMMlsB3TTxKhLhe6Wi1GLpbcD+7O/1aWKlEf+MFEWMVQzA2jj3wmzYQZvi4BSLZ0TNPwc9XuRdfMNvBA3Qvcm8JRpVr7LjSF9evpYAXubNvoQ6ApFhx5VFz+w87Q8H1u7S6KgkvpaxjOMXYgpruQrebbLdN9DjJV+1D5bSJNk7MZ2tXvBPMxBxiQe8jd1044gzMcTRzSPHiRiD9gg0+1xN3BpgOM4XeEwNY0Jx051ko+NNwtC1BdCxryeezjstndr+TqCh3H1IreVZ1Ng3C/lhVz5rto3JDkktppKoMVARb7PxVWReE7zMSM0ST3s+nL5c/WQfXBYJMw20r8N1rxJRtdXX+6Gr51ktVF3JIQFcqWtHPp7zmm0MMeG7gEyvBAdJJ/6vmumT8X3zgpNcWo0auvk5Z/RqvdDJFoBmphrEr/fcOCIywc8sRa/77atwZUCi1lCh4t5hrog9PoQKM/fv/KMfUXeBdnbNoNFMvM+hjch6a05NXIsJdRFE1LLfS/JT/+TKdHjlkkVdqHdZvQa+ajjqnWORI4n+MMRAzozcJ3oCEehST2u72zaoAgVhufe6plYBG8BpY7Ar9koAmALYM9frvPSIC/SBCpDQkKGBitnlmSmMjFjeegIckkD4DsnkGwvMnMsnHvMOS49OJl5FvOlE3FkhB1BeYJN+xGZlOQ48td
 jHkwed2u
 t+Rwa0HPkAYosDFRWxGzgyHjfyZSNNmJm7/zOs1i5oa+ZbZbCteFcWVP6ZyWqU6aWmFOI/cxLTd+qCkcg+ze1FS5J34L4wIei8lBTdKkDVER3IPToddHzmPyIodQvtKLLioy4oCQwHERD+sMlzvKHPRcd3U2GuWvq/InLKNVRHhQsfiENDYTepkxN4Ztl6CI9Ws2hETAvEUSTuekxj4XxOouqNsWoJWodernPhi4WHuLAF3hTbVeLudA2jVOn/1RIjxUrIBv7xcybjYcZkU15HEd4ZaXwIciDpkGn2PLtUr1GL8pcG9vWnNldaul1Gkslees0NjCIaAiJ5D5QsskRFyMmYIQF3rQkaC0W+1R0Jw1Ja8qeSTTRdHhfPRDZ1iYNpLBvGnGnJA2CXpaDDjmqUwh26g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 08:40, Shivank Garg wrote:
> Implement kvm_gmem_migrate_folio() using filemap_migrate_folio() for
> non-confidential VMs but don't enable it yet. guest_memfd mappings
> are still marked unmovable, so MM never calls it.
> 
> MM invokes ->migrate_folio() callback with folios already locked and
> acquires the invalidate lock afterwards. kvm_gmem_punch_hole() takes
> the invalidate lock before locking folios during truncation, so
> taking invalidate lock in migration callback can cause an ABBA-deadlock
> situation. Use filemap_invalidate_trylock_shared() to avoid this.
> 
> A subsequent patch adds an opt-in flag to change the mapping to
> movable and enable migration. Non-confidential VMs can use
> host-side copy via folio_mc_copy(), whereas confidential VMs will
> require firmware-assisted copying before they can opt in.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 169f75f95433..583341d593c9 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -488,13 +488,45 @@ static struct file_operations kvm_gmem_fops = {
>  	.fallocate	= kvm_gmem_fallocate,
>  };
>  
> +#ifdef CONFIG_MIGRATION
>  static int kvm_gmem_migrate_folio(struct address_space *mapping,
>  				  struct folio *dst, struct folio *src,
>  				  enum migrate_mode mode)
>  {
> -	WARN_ON_ONCE(1);
> -	return -EINVAL;
> +	struct inode *inode = mapping->host;
> +	pgoff_t start, end;
> +	int ret;
> +
> +	/*
> +	 * Migration invokes ->migrate_folio() while holding the folio lock.
> +	 * Use a non-blocking trylock to avoid inverting the lock order with
> +	 * truncation, which takes the invalidate lock before locking the
> +	 * folios.
> +	 */
> +	if (!filemap_invalidate_trylock_shared(mapping))
> +		return -EAGAIN;
> +
> +	start = src->index;
> +	end = start + folio_nr_pages(src);
> +
> +	kvm_gmem_invalidate_start(inode, start, end);
> +
> +	/*
> +	 * For non-confidential guests the folio is host-readable, so
> +	 * filemap_migrate_folio() can copy the contents itself via
> +	 * folio_mc_copy().
> +	 * For confidential guests, this would need firmware assistance.
> +	 */

I think this is all more closely related to mapping_inaccessible().

If accessible, this is just trivially true that we can support this.

So I would not comment on what to do for confidential VMs for now, and limit it
only to the shared-only case where pages are accessible.

-- 
Cheers,

David

