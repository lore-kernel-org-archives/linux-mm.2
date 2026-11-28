Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004CD606A33A
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 13:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=C36ShocY
Received: by kanga.kvack.org (Postfix)
	id 222826B05B0; Sat, 28 Nov 2026 08:00:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D21A6B05B1; Sat, 28 Nov 2026 08:00:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C08B6B05B2; Sat, 28 Nov 2026 08:00:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEE46B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:00:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 144EE120653
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 13:00:30 +0000 (UTC)
X-FDA: 85484536620.24.560F397
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1CE604001B
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 13:00:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=C36ShocY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3atAKawkKCJUIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3atAKawkKCJUIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795870828;
	b=tMlnymGQCeKJ2TONhlrORpukYJDReq3OYKw2GUGQy7I08lnWZMYfl9Y+k49zyjehHuVPuw
	fUKVyZbZMUkq7eYEK3Os7vPCQYagoOm79WNho+DZyl466j4QdpFSE9auk3aGMFnD2YpHlN
	0Rfo09wlyGyoGNZo0TobKQIrXgmRw8g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795870828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6BkAp7ECdk7km8IXzswx291+eDVbqVT1bK4nfJre9c=;
	b=k5Jt/aaCxo8EcReHdWRFpsPqBJgcCiSZICFh+jmRxxGLuPC7YIKKGGPn7nUDrbBD9HUnRR
	aFXGUfpmDGZwGcRw12H7vf/FyuxPSNZz1SMl6tJzt9UbnIR3/Kqb/uW886Z3ldIKjDhVv3
	QSRU4je24PkqIM5vFTS5CJby+4HQnOM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=C36ShocY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3atAKawkKCJUIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3atAKawkKCJUIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c429d9d05f0so839998966b.1
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 05:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795870826; x=1796475626; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d6BkAp7ECdk7km8IXzswx291+eDVbqVT1bK4nfJre9c=;
        b=C36ShocYQnicmgd92J/ZPMw8q/Xgaa4/jMpigDIqyoCMWdOboC40iuoSPzDmwSSMtg
         JgHuG7khNN+S3EpTHG5aeh2Hk245UAMngb1oob5f3MzEgW8oVh13sXhuArW1u3TqJHbU
         UvUHqg+SIe4ipT8t5itKdx2XO8Yhmn45LBTxI3un8ZBUNQ/7jZnRtS9XJuLck0ruONA2
         6F02s9dG9IP9iXsxk3Km9DbWix8lXcqakaPEZCTGUNLXUmUf2Ohl/yPx5nB0oGzbHCge
         73ccgXlIZzHje7j0lcbQTuaMX41MUJAzJnzeDKo5pey4wS8Ri1Do4yUtAGworF232xCM
         fWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795870826; x=1796475626;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d6BkAp7ECdk7km8IXzswx291+eDVbqVT1bK4nfJre9c=;
        b=E1rLbmpglLsyRyaizaD/tchDwFa/WAmbpzAeYmnlwYVA7d9wOY7gNiBlO2baJyiK9D
         lK5UcKMcJQVrJgKuq3qX3nVTMuBWMD1EvfmYdl69N6UNO4E0hPaG1gTcj2dF5V+B0BXl
         HojQ1Il01sinyL18XEg0kYq+Dgw4CjRnl/m9N6aovpReBH4aKi6FW1B5KKtRu07N4wpc
         QopfBLf0BzxUcGT0uAUiyYgry6IfxQQkAV+sUdWwFo2enALAtHgln7kkGNzRW7OvfQOZ
         H0bbE1LaVygd2B86feVIZgcdly1oPt0dCFIZhtDd+tbBWrQtxtxwD4pEy1Zm3tPGAyA+
         oULw==
X-Forwarded-Encrypted: i=1; AL+hErGLJ5USpvwi6jhG68UfK3Tx2FLmlGlQI8K5P/8NTMhqqPQ3yMlhvzk8qIPiL4PnBnS/Y+TNEJkRiQ==@kvack.org
X-Gm-Message-State: APuU4Z9FIX+Yd++id9GZe1A50Drgz0pQq4AsKMiYRhF4Hy0vcLSCrL8C
	lZIJf+qs4K0n8pmrsud55EHn9BVM5ocg7btJzBmmdng6mlmhEcueGk7q+5zJiPLlLON6jlloVoX
	y3MxT4i76S8PeHnCf+A==
X-Received: from ejtf9.prod.google.com ([2002:a17:906:4949:b0:c31:8840:5c0c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:3d21:b0:c51:24a4:1dfb with SMTP id a640c23a62f3a-c513ac7edecmr1624478866b.40.1795870826056;
 Sat, 28 Nov 2026 05:00:26 -0800 (PST)
Date: Sat, 28 Nov 2026 13:00:25 +0000
In-Reply-To: <avnuP7SWE2BdBFBL@kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-3-tarunsahu@google.com>
 <avnuP7SWE2BdBFBL@kernel.org>
Message-ID: <9huzpkvpglg6.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block header
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, robin.murphy@arm.com, maz@kernel.org, 
	will@kernel.org, David Matlack <dmatlack@google.com>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, jgg@nvidia.com, loganodell@google.com, arnd@arndb.de, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1CE604001B
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: wpxr9e3j41gr638bpf45das9oeqtgch9
X-HE-Tag: 1795870827-899377
X-HE-Meta: U2FsdGVkX1+vTN91zEhVHzLouu5XJGnnu0/DxQYtv/E1VLPxIt6y9PYrZLpXa8HdjhO2qviczZCAwflPVll3zBRf/L9+PYF/H3aYuXUJt5Kk5TUWQzqQBBMN+6YGtU6PbMBv4xoPh7yhvxWA7NySMXRtNzQxpH9Ql34UFGnKgz3s7xbTXs861abCSTwxlzJghlEAujwVSYuLLTD9SDRWmf8ixGp6pFEOFXb1GgEM7FPAPr/QitbJBdZUAIkKyYODAX+op8ElL/6pxOlnYTxbKU/iqgOCOlK5c7jiTv2cwluPndpLx0Gt6LPnqzbvtys3t8yvvXqY/yXHHnD5pRmdrP6HpBVCfC54iw6a9/2Ugrt1Z1R2rbHreTynuRK737f9o/ekIyvdBLIvR1QENAoG0XkCp7eX+YEoGvp7FWhzk4ktzxB4fomUJJw3OBBwxD42uTj7/IB3u28Ap6bhZokVtWV+NfX7q7TZLXZpZBYGjgscWAtsxP8JRAejmrL6OIx+3O11ZPaURKCOY+doakck7jiRf67JZhkZ0ugow61H1VgSaVkC5MxgEtCAOrgqFaRs7Y5oa5j36+/DGb405sTD9POkj4Avwi2aPzO7tp9f1NAfpYA6AUnQNM9gIsSylyjmZynK5mEF0VDJT2Fq9beHJnxlhUO+221pPFJjXIevO9tyw6RUOoctCGjfkNiHHStokUCalHL87pIX34D3s0Uy65itGzW8CQEym7a2DKs/+FAiejIT9vvtjCwfmSk8TU48tq63ZGAYhuKh2b3SwlVEgAGtPVMK3gAiBuZobir04jDGJka13BPXd7Sg00FvaD3u6DwDz3O95w/Eijl8ZmgwVJ77xunutX7bo8dVreN+7hC+9nCKqmKTtA1iA2TvbF/EmIDI9yLrZowu6jjMCECKhDVs1VFlGFJFZX2yGXZeGuMJv66f9Hm78maOqLSCnZ0g++/zx7CjQeFD5NVTQ3t
 3rHA/roW
 4Ys/Vnviwovbj2covuiOMx06kV9TpeQ5KQA7GfQXTnu8Sk7LCwGWtKvOalBBBkwjeyxHizd3a6O55fYGgjBQwNnSvcftdb2svzLLBECo7ZsDdPp4R7NeIkrBVRp6vbLWSOHQNOZ5U930W7mIrpFf8rdRkmlbgZhuM8aP8ViDOkkr//i/Ca5tkMD6vSR3uqCx4xQvi9CAP60fXvqpobRyA7KLBCcYlCix9tzbZAGxni23gxX/lR0Sv2bRoFHIB+LNuFH56gcOibVvJe2EJSgWP6nBi2Pry8ySSTlrrzsNkthEIs6P85aadm2fiXQJqDhqRy6IXddTOvAPXYgamKU8YDGyPYAD89eru9NrHmM7E9xi8bPzL2CDJT5rnjnZ6NygfnxgnJ3CuxAZo+2ud0igbOlq6LFVfmVUBZ12c8tJauRQUQX2d1/LYJH4Rz6w8FfiulFCYOCw5NQsjmrBAevDt3CqbpixzsbUpe2MWsNGODPFs4DoDOzqOG5gGsZMX4JoXKe6r/C6+Me8dfvaU7Ss5wx0rH98GfCHQ/+MkO2hCZjoiBsDKI4QFEjT76xnUw3vBdftSTZn0/i0JN+9w7/EFqpGhZTbIwXjHDWEj/DH1bMejdGqDHfXcLMgCF0ufY6QCT5MlZmB9bYgruCaY3fKkMfpjGv5eeiUNhqqXeiG1XhhJNh+P/DU5nUWSmD826PZBnofCzFW0WtY98qAaBCdSzZ0LVb9oSqUJ+p4nRUkRnerwRNYTZuPrTIKZwtbDEG+8kPAKL8uMyCZ1Zoe10uyD0YMb3DhLLtFOA9/d+bMOTonr+eU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mike Rapoport <rppt@kernel.org> writes:

> On Tue, Nov 10, 2026 at 05:01:45AM +0000, Tarun Sahu wrote:
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
>
> Imperative voice please.


Okay, Will take care of that everywhere. Thanks
>
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
>
> Nit: can't we just initialize bs->count_per_block directly and drop
> 'capacity' and the change of the following line?
>
> We are not very strict with 80-chars limit in kho/luo anyway.
>
Sounds good. I will update it.

~Tarun
>> +
>> +		if (!ser->count || ser->count > capacity) {
>>  			pr_warn("Block contains invalid entry count: %llu\n",
>>  				ser->count);
>>  			err = -EINVAL;
>
> -- 
> Sincerely yours,
> Mike.

