Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37038606A33E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 05:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fnkQJRbn
Received: by kanga.kvack.org (Postfix)
	id 484D16B05B3; Wed, 11 Nov 2026 00:46:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435BD6B05B4; Wed, 11 Nov 2026 00:46:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324236B05B5; Wed, 11 Nov 2026 00:46:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9D56B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:46:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 780DA120206
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:46:04 +0000 (UTC)
X-FDA: 85421752248.25.8101EE9
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE2B0180002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:46:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fnkQJRbn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3GAH0agkKCEk4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3GAH0agkKCEk4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794375962;
	b=073jXPWTIFcG5OnXUeSNMX+ny/X0qdz+hatv+sZjDtxHb367k+2yBzcuZaY60AM6fYZdzz
	TtXbJ8LLY3bs3A8Nr3Ocpn9vTlgCeI4sGhWmFADj5ZdFbSBjKQ8HZAZ5einVpvhzcLvR+n
	zYgQ/rRKsBHdNLmuPStbxFkhj6BIp0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794375962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhosHtg8wPbXMxrTNQaWwGDOdBWHTWddIh+Zj1SEb0g=;
	b=MCvxySsoSpHqh7FbkgZ3WbCXniAgOJAG8cHnrO6vVujnp4OFuF86TZyi4NQC/iQIY1ffB2
	auWvesSPU55as3FiGVbSUfD72BBgmQCHjLuobBE9ifu1mt+ChkQeobgb8k7HPJz+AJoI1p
	XMdHaUEIieDBfZmOCsP7cua7F+NLKyw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fnkQJRbn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3GAH0agkKCEk4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3GAH0agkKCEk4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b6723180baso2988401a12.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794375961; x=1794980761; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lhosHtg8wPbXMxrTNQaWwGDOdBWHTWddIh+Zj1SEb0g=;
        b=fnkQJRbnaZMr9vUuxqZln/IeyVdvcQHekUO1WDECR8a+XNC4pa99oKg3xnpRBO4A9y
         8bI45FLLSVM/P0KWwu0zJECVnhyBDqhZhvaCYbwDqtDNkeNPXjxZaWKs4pUWGkDBCwfM
         xollX00dE2xjxq8aXc4TuorckmHkxPLl5UkKBAptP0+lhkn8KV2TeVtVUzZuf/rYBQWm
         9iBHt5C9124Ri8kRJ6b2KfrmuFUuN79bkzSdVEFJh10VZHzribUGzyMg8wYBYj6cPDbJ
         vpN/OriehXCdHRHIoVQX/aRQ2/s9143t/3brpwLqNQuEiedVsNSqNSoAWBdA8Rf/Z7C5
         +wlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794375961; x=1794980761;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lhosHtg8wPbXMxrTNQaWwGDOdBWHTWddIh+Zj1SEb0g=;
        b=UOVKOaQuyc1LASwkG9JLpWZ83sW5LeKb8oVH38K9Ei3Mej7Y8gD6c08qhPYnNTZMG9
         QfoIhyWGGkY3i/kvP89wyCMxetVFXHUGZLcZORkWoiop6d/dmjXNjkbWBT1ybYl3y0jf
         83H5ahRkij/JV3Cj5mVIRZwXR4k/vKmnuh/7Udbgiep+YpZFGe61fVuzjnOsc0Y5I8d9
         VwZ7cTIUJd0rPKLfI2J7zERUySW1Qlrkor0f7c5K+8iSulgGKF/2y1tOFwjoUAg1fWdx
         MwMl382tSgeosW1EE0gwHmnpI0lfvL31o9D3ykw4fkl32f6lIXdwI5g4F5Z/877srk+s
         4oog==
X-Forwarded-Encrypted: i=1; AL+hErHSjKxGqh3AGnNmP/9Bv8LI2dstSvrNB6oCPeo2ZxiT+YQXyXbcTl9dIibV8FUErgEPjeeDtVCW/g==@kvack.org
X-Gm-Message-State: APuU4Z/Pq9y/qRhW1NNiuS2p9GIEB2aDtHMKs0R7vAGJQhZcH/EczzHf
	hxxEIvsdGaLDyL38Zn11EfzFKhcvOaJwUccPSJ8Rtx5PGlzaNUtBB+p9cvpWqBgPM7zbaqKKhZc
	nqih/wPWin8KVCzz1KA==
X-Received: from eduw9.prod.google.com ([2002:aa7:dcc9:0:b0:6aa:448f:b887])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:b18:b0:6b1:c1e5:a85b with SMTP id 4fb4d7f45d1cf-6b777342a32mr753053a12.3.1794375960798;
 Tue, 10 Nov 2026 21:46:00 -0800 (PST)
Date: Wed, 11 Nov 2026 05:45:59 +0000
In-Reply-To: <DMRK0PU0VCN3.15F59WLOQ05P4@soleen.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-3-tarunsahu@google.com>
 <DMRK0PU0VCN3.15F59WLOQ05P4@soleen.com>
Message-ID: <9huz1p8rrkdk.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block header
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BE2B0180002
X-Rspamd-Server: rspam12
X-Stat-Signature: fy6t554ojiim3irt7u1bgr63fjmz7xkz
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794375962-705443
X-HE-Meta: U2FsdGVkX1/fzE1TlN9kK7jffrfP6Eu36XsP6cquEnS7/O3X1KHtcnQifv51/5I36SuGNDXTo/PjwHgBYJ92MMeVN0lNCxsLJOEpqpP77Zp7Vcfw/P9I9AIx260xN3gQmCHMtfuaYBe2OXfKOiYvJod+u2k+k4Jbd7xcSGQU0by9jUe7SUvpsVX77HfCEZN56K63hawiSY6auG5smHjHG+xi41mpwlNnQ/9k5TFyVpXeIeyHQ7IsHiiJJvGHCSsfPlbkPn5N+8jJYUz36pCZFhNnKtWX0o+RKx0shYpAZAoSf7zZjtnr7vqkzK/pErO+UmXV5UcT96rZ0Zd0mDnuRBxW9Yi+GXZe2E2E/rAeIkqgRGOQikLqB8MScU5wsqJZ9xLDTUKo1pPGKhAIvIzp6T1wFP4zfUozK78rqHMMhvtD2PmoGiiEIucaKe3r3H2w1FyWbyY4U7NjEeDE82mW8RtCC11pNcOA9uv4SEQpBq3xxuElEEFgF4nXAWdLdC5PyuhMaroP0zBv4jlweOcJbXS6APgh26d8L+cIkjC9jqCGjg6hcdBD2J4r8cSy2TCiJzVwwWpdP9Xtiv75VFWMa5LzRXEzYFwgilw+/kBtOx03V/Aad719EtiwDoPSvjwTMt2DMhGQl3nw9nWORRR6xqZWZQzX8LTccu1X9rvRsEgIiclR1rP1gcChMie/5kD8YqH3FJFe+jHcnDzotex7h2g7l6i6Cfnl7/yqAIZ2/rrYELdbO+w+CvyjSzGw3Ln4Ybq5tQqih3no4AM0sqFB5D4rXwYdXUzQI0G5keJkvUJpVdwt/rEl2HyeMiM2jetN+EYGvkQDuZRm7xNGppcpbVpk8Xnz8u8aqxVz39A19eHEJe+0vbHAbXI8m71QKPK9PfA0dN97iq4T8+nPeNX99z/f7zcyf3FST7JQgay2jbRUsYS1jSyogbFlqekvvCmhcsscoBAtY2ruCkUN0+j
 E+2/+REi
 xG7QMXQuN2/0tbwLHgLT+cRAkSk1G3GF2/WYnYvgYn6aes3Yd5MDpsts2OGwcmoutG/xqYshPht5TFV63Jb4/9FmumoZ2jHDxnpjQxCJ5L1EdBJkHqciGf3xjTykyRYLnPs1sKw/xWdOEk6m1NtxvzHNrPxTTM+vkItYhKgE4N4n0kpOWZ/V1pPX098tWKQp+Xo+TCyTRyqrbzDZbdm/SEoSO2+OMA4RD6RoloAEgcQTpQbR9Hpk4/qzE40g8qOOC37iCv9SYgbOdDMU6KRncInhZl6Q4+t/9+zjQW2Kgg0zx0VcQTbAvKvAsZ9w55nY+TrwtKWcsD+3rNDLEVUZMfqA6Niya7rWDA/VKPBxgefPRsXk+MN3n5bWcmZeOy6vhYUHp/whP8Y2ntJmZjQZVoCTqQ1DF60hr91T59WN7tReW1SH1cnPjay9YaHKqnwCB5wVYwfGZuXMv8OGMBNyhTNl+qkUk/fqzDg0DMPN/A0Ru2Mhgajx+lC0tRxM0od6ozTVFKCWc8tbVYyzoplNgGATx6JO8Q5axJ7X3FGaGaEJfalKSk7g3sbaoil2bsUIvF66Imy/GixijFO77ddbM36NxJ9X1LPvytrmbe8/FvGzwSWCNaZoySYlOxWzFUWgf4dxi74vAYLv2jGgVPplvBy/4lfIDD2kG1vHKKdaoPtMFCm5th+RMNQGVTE6BzM2ttb9VSbtfSWDB7BPJqmZFz5sW9eHFZ1ezFk564+hsLK4Oth2zte3xnxCDUjlJmHVQo1h0q/hGQBhzu+9VDafzybuFhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Pasha Tatashin" <pasha.tatashin@soleen.com> writes:

> On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
>> Subsystems using the KHO Serialization Blocks framework currently do
>> not record the serialized entry size in the block header. The entry size
>> is only known to individual callers, which must track and store it in an
>> owning serialized data structure. If a newer source kernel adds fields
>> to an entry, the changed entry size breaks the stride when an older
>> target kernel iterates over blocks.
>>
>> Add an entry_size field to struct kho_block_header_ser. On the outgoing
>> side, record bs->entry_size into every block header during allocation.
>> During restoration, derive the entry stride directly from the block
>> header instead of relying on caller-supplied dimensions. The
>> kho_block_set_init() interface remains unchanged. A zero entry size,
>> or one that differs between blocks of a set, is rejected during
>> restoration.
>>
>> This change modifies the serialized layout of struct kho_block_header_ser
>> and shifts the offset of serialized entries within preserved blocks.
>> Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
>> kernels cleanly reject mismatched handover state during boot. Also
>> update the stale compatible string example in the documentation.
>>
>> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  include/linux/kho/abi/block.h          | 10 ++++----
>>  include/linux/kho/abi/kexec_handover.h |  6 ++---
>>  kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
>>  3 files changed, 38 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
>> index 36bdbaf9b3b8..a40b0906c821 100644
>> --- a/include/linux/kho/abi/block.h
>> +++ b/include/linux/kho/abi/block.h
>> @@ -40,9 +40,10 @@
>>  
>>  /**
>>   * struct kho_block_header_ser - Header for the serialized data block.
>> - * @next:  Physical address of the next struct kho_block_header_ser.
>> - * @count: The number of entries that immediately follow this header in the
>> - *         memory block.
>> + * @next:       Physical address of the next struct kho_block_header_ser.
>> + * @count:      The number of entries that immediately follow this header in the
>> + *              memory block.
>> + * @entry_size: The size in bytes of each serialized entry in the block.
>>   *
>>   * This structure is located at the beginning of a block of physical memory
>>   * preserved across a kexec. It provides the necessary metadata to interpret
>> @@ -51,9 +52,10 @@
>>  struct kho_block_header_ser {
>>  	u64 next;
>>  	u64 count;
>> +	u64 entry_size;
>>  };
>>  
>> -static_assert(sizeof(struct kho_block_header_ser) == 16);
>> +static_assert(sizeof(struct kho_block_header_ser) == 24);
>>  static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>>  	      __alignof__(struct kho_block_header_ser) == 8);
>
> The above change goes away once my comment on the previous patch 
> is addressed.

Ack.

>
>>  
>> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
>> index 2f4fb9c63942..6f12f5037ea5 100644
>> --- a/include/linux/kho/abi/kexec_handover.h
>> +++ b/include/linux/kho/abi/kexec_handover.h
>> @@ -41,7 +41,7 @@
>>   *   restore the preserved data.::
>>   *
>>   *     / {
>> - *         compatible = "kho-v3";
>> + *         compatible = "kho-v5";
>>   *
>>   *         preserved-memory-map = <0x...>;
>>   *
>> @@ -62,7 +62,7 @@
>>   *     };
>>   *
>>   *   Root KHO Node (/):
>> - *     - compatible: "kho-v3"
>> + *     - compatible: "kho-v5"
>
> These are just examples, don't update them.
>
Got it.

>>   *
>>   *       Identifies the overall KHO ABI version.
>>   *
>> @@ -90,7 +90,7 @@
>>   */
>>  
>>  /* The compatible string for the KHO FDT root node. */
>> -#define KHO_FDT_COMPATIBLE "kho-v4"
>> +#define KHO_FDT_COMPATIBLE "kho-v5"
>>  
>>  /* The FDT property for the preserved memory map. */
>>  #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
>> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
>> index 0d2a342ef422..9b148009085e 100644
>> --- a/kernel/liveupdate/kho_block.c
>> +++ b/kernel/liveupdate/kho_block.c
>> @@ -16,6 +16,12 @@
>>   * array of serialized entries. Multiple blocks are linked together via a
>>   * physical pointer in the header, forming a linked list that can be easily
>>   * traversed in both the current and the next kernel.
>> + *
>> + * Each block header also records the size of its entries. A newer kernel may
>
> "newer kernel" does not make sense in the documentation comment, as any 
> kernel can do that. I would suggest "outgoing kernel." By the way, in 
> this series you use the terms "source" and "destination" kernel, whereas 
> traditionally we have used "outgoing" and "incoming." While both 
> conventions work, it would be preferable to maintain consistency.
>

I used source and target, based one of the discussion we had in
hypervisor liveupdate meeting. But, for consistency, I agree, I will
change it to outgoing and incoming.

~Tarun

>> + * append fields to an entry, so the kernel that writes a block and the kernel
>> + * that reads it can use different entry sizes. The reader steps through the
>> + * entries with the recorded size, so every entry is found, and it does not read
>> + * beyond the recorded size of an entry.
>>   */
>>  
>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> @@ -110,6 +116,8 @@ static int kho_block_set_grow_one(struct kho_block_set *bs)
>>  	if (IS_ERR(ser))
>>  		return PTR_ERR(ser);
>>  
>> +	ser->entry_size = bs->entry_size;
>> +
>>  	err = kho_block_add(bs, ser);
>>  	if (err) {
>>  		kho_block_free_ser(bs, ser);
>> @@ -242,7 +250,8 @@ static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
>>   *
>>   * Restores a serialized block set from a given physical address. The caller is
>>   * responsible for ensuring that the block set @bs has been allocated and
>> - * initialized prior to calling this function.
>> + * initialized prior to calling this function. The entry size and the number
>> + * of entries per block are taken from the restored block headers.
>>   *
>>   * Return: 0 on success, or a negative errno on failure.
>>   */
>> @@ -250,6 +259,7 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
>>  {
>>  	struct kho_block_header_ser *ser;
>>  	u64 next_pa = head_pa;
>> +	u64 entry_size = 0;
>>  	int err;
>>  
>>  	/* Restored block sets use size from the previous kernel */
>> @@ -264,8 +274,21 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
>>  	}
>>  
>>  	while (next_pa) {
>> +		u64 capacity;
>> +
>>  		ser = phys_to_virt(next_pa);
>> -		if (!ser->count || ser->count > bs->count_per_block) {
>> +		if (!ser->entry_size || (entry_size && ser->entry_size != entry_size)) {
>> +			pr_warn("Block contains invalid entry size: %llu\n",
>> +				ser->entry_size);
>> +			err = -EINVAL;
>> +			goto err_destroy;
>> +		}
>> +		entry_size = ser->entry_size;
>> +		bs->entry_size = entry_size;
>> +		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
>> +		bs->count_per_block = capacity;
>> +
>> +		if (!ser->count || ser->count > capacity) {
>>  			pr_warn("Block contains invalid entry count: %llu\n",
>>  				ser->count);
>>  			err = -EINVAL;
>> @@ -370,7 +393,10 @@ void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
>>   * @it: The block iterator.
>>   *
>>   * Iterates through previously written entries during state deserialization,
>> - * respecting the actual count stored in each block's header.
>> + * respecting the actual count stored in each block's header. Entries are
>> + * spaced by the entry size recorded by the kernel that wrote them, which can
>> + * be smaller or larger than the caller's structure. Fields beyond that size
>> + * are not present in the entry.
>>   *
>>   * Return: A pointer to the next serialized entry, or NULL if all serialized
>>   * entries have been read.
>
>
>
>
>
> -- 
> Pasha

