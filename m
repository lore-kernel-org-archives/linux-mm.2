Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B00C606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=J+b8SDUi
Received: by kanga.kvack.org (Postfix)
	id 385CD6B05B5; Wed,  4 Nov 2026 09:32:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D016B05B6; Wed,  4 Nov 2026 09:32:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274376B05B7; Wed,  4 Nov 2026 09:32:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07B8B6B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:32:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8864E1A0744
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:32:39 +0000 (UTC)
X-FDA: 85397677638.27.C2ED2C7
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB0A4160007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:32:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=J+b8SDUi;
	spf=pass (imf08.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793802757;
	b=5lCofCluUnWP4Rzu6sN5BDDKY2Dg/f2h/pUzjJ/Ghd0/hYuNmpotWg62PxV504Qhpe8FeX
	MAglLr+H5ujzF4a1EyrCUsviQ61uK2S41RFf58T3LuFMQH5wnra2NOMfJ+pBbbHcUnZthj
	oRexjQ8GFSys6kZz5beU00pX4cwW27k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=J+b8SDUi;
	spf=pass (imf08.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793802757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=nQeS5Lk1UtDT47XmIqhRscqhps77QOPDmfqkTQTRxLI=;
	b=IMwzMnnLq0A19NyajGQ1YM+ujjvLZn7hhLRWwWSt1CxlwGDQB1HSaIq+oQf35vhZKjKw6V
	iotjwoBetS5FztWQkBfKMsSvGt+Ulr1I5Is+tfn/E29NqfNng1xLALMcjkOAnq+pOTbXsk
	XNZF3x4SC48kQ0fNjvmlDKsY+g7JEr8=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7a6e560f580so523281137.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 06:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793802757; x=1794407557; darn=kvack.org;
        h=references:in-reply-to:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nQeS5Lk1UtDT47XmIqhRscqhps77QOPDmfqkTQTRxLI=;
        b=J+b8SDUiFHlFWeE6QPOIm4fpYFsrKSIGYnMYcBk7tM7heNsc83W4ID2TgPRRlAkxnp
         K4P6IgqTS9/sMSPqW5vCyN4701J2KNSVFvWLZvbyNvFOYmXyDx0DT/9XcznZW8q3gbJg
         pg+unj80W3z9OeI4S3EUMej98S1yRIwPRr+ppKXK8M3Wfl07RX0DEM4S0j89gXKzVq3i
         hKu534SvLkPLtYQOjaqqdVr0Gs3sSk03ZnYns9gN6ym0xIBKLl4ReAUQ5RhqRF9DkKkJ
         qUAnawHixGYmK1C3odtehgYJ0VnFfYuXMiTzvPq637AZKI/BP8i9+Z+L3d1OvZhFtQD+
         iomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793802757; x=1794407557;
        h=references:in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nQeS5Lk1UtDT47XmIqhRscqhps77QOPDmfqkTQTRxLI=;
        b=B0uNYIh4oAVs4Q+AZ9VdL9W0voWfyNAQw9eLnpJ42Y4vs99pQu6aob/3YAfXhWo4JW
         iyCX32aSJGuSojWoUkjnlTIDgqLfjEdmuXMDPeMMTkyQ3Vdg/l0209d3w5P4zc+9P3lQ
         wHEYxcMyPKGDEf36qaeMINZsHcaUfqdNSoZNjU8RjMq5isqBMZqP8AzrTUo8Ogy1252o
         74YRws7BrTnZNibDqtz3gVZVCJNCR1kUXPu+S5W1HcFCElikNerUS0dIdblzfbWtHXow
         M8Xv+gb7u2rfzwDYY+7BQRtzZjP28MyHJTJPbrJdWZYXB1V6RqyTG38i0X5CqZQSihum
         WFXw==
X-Forwarded-Encrypted: i=1; AKwUvBxbh6keRNu4oAUpW7J40SH2wO7L3TuINYjEHDNOS8XiTFfaXiOAaYhcqP5W/gaNVCI/FAmA0N+dug==@kvack.org
X-Gm-Message-State: APuU4Z+cKr2UfwD2KxppvX2etnu3WbEfR20cukR9BqgC6ZXmGl3RD6ff
	r3elIHcrUF47W/iwrBkWOdvP0zvHPu/DEflIudYDn7hNiU8VyLPkFfm4bgGH7Ca0JDZC5XBhIis
	FSfauSVXWsw==
X-Gm-Gg: AYBFou2OUnqO90r2AuqnKKDRylY5idlDdBlFXYmnw/EZUlvHZ9AFPQ5pKc9iTYUgz/4
	e/yc4xpJ7BnlyFIQSl0q0MIiLQcJLgcc2JHwBR8UWqPePWHJ3To/wAsKFvWabH4v9Zmd9JaO7Ks
	UxarLmJ0cigiMi6mTSL3QmauCrvsC+gIy/Ix5FrgmuvLRT82Fh2nI149QS04e4dqDBoQOIez7tp
	fkn6LueLFnGCnJCRGYi6NfOJnUUmrV52mTb5DAYm0Z/Eh+Us8DlmGlfnjiHUTiR9aMaLObrQl20
	EgqbJob0+fpMbDdWhygyhfGpvS4laPf/c5Icknr91hX+J5NvGgw8JXYfSZMKUq4S87RVgtegTMf
	EnHC6VOXXuOdhL/m4dM66ATmuSe1Nf2qFWxu7YYeRv+dGJyEr/3G/3wpGz87SbuXfZvp4g5jfH1
	l+iclOAD9VeDOCoHb+/6bMgdODvYj58Kr9zEQo50dnanbupdWMtpJtlvhhKKGtf1AHZsUmpBP5+
	S+1SM2AVYrdqXZL53eAftj47dmIoesFJxgEQpFARWOPDi7YwvzEWtS20YjwvIx0eeLOtQ89NtH/
	OTm6MFvkeIuv1Iov7gB2bp/uZHpkX4c=
X-Received: by 2002:a05:6102:6107:20b0:7d2:7be1:271f with SMTP id ada2fe7eead31-7d27be12fabmr472050137.31.1793802756625;
        Wed, 04 Nov 2026 06:32:36 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7e75b24asm20104976d6.39.2026.11.04.06.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 06:32:36 -0800 (PST)
Date: Wed, 04 Nov 2026 14:32:35 +0000
Message-ID: <d2efe4f22fe0ed9390e4d9224b81d78f.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
    "Liam R. Howlett" <liam@infradead.org>,
    David Hildenbrand <david@kernel.org>,
    Vlastimil Babka <vbabka@kernel.org>,
    Jann Horn <jannh@google.com>,
    Pedro Falcato <pfalcato@suse.de>,
    Muchun Song <muchun.song@linux.dev>,
    Oscar Salvador <osalvador@suse.de>,
    "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
    linux-mm@kvack.org,
    stable@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm/mremap: fix accounting on a partial move
In-Reply-To: <20261102162304.c3585fc3fb88644118c152d7@linux-foundation.org>
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com> <20261102162304.c3585fc3fb88644118c152d7@linux-foundation.org>
X-Stat-Signature: gytrn89snpt4ehhkryxxdegjasw9sa5u
X-Rspamd-Queue-Id: CB0A4160007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793802757-72370
X-HE-Meta: U2FsdGVkX19ZN9jaekfLUTO0dQ76uq2pc5f8Ez68oFBrq0BOV7obl+8MeXMQt4RlKquK0fCVCaTvmd5kCK114U8tbUj+Rz/tkRrUB2J6NWO008p3Nkhvkm1rLwPUEkbAa9nAwHGCFk8vCyH8LAmF7DWw7Eyj3yTQLX1nW2qR2ERs5PlyCFeAQ6DaGgn6vQVYtVxgkLVGvQbUz7uZPI/JcO17tbUfV1TzQjgrBgxXDaIr25EouQs+P69nr/+OLhrab1VGi702oUSYnaLTnqqkXedcBfk6j1uMJ62fiXjD8+pUvMD52eLbXblNP1Pr5GUbmuW/zJJ40JveLt8V1/LL/zLGypjMnJAtS/N2idOzO9zyfnQb41Ykd1PRE4WBFDnW6a2PFdli8mOxDi6lfnfOmx9Wr6OFIm6g06WfUn7DgM2rMgaUHhhtRk1V422Kb6wKs6ht1LRjKykpKlv4KU6kIVZj+8sgkKp1we4OC7hzWauJH9hZN2bF2sMXhBsfUCy0FwD1xbhI3ET4K/8LWwxnFz82mJaguQEaeIqAzqABR4WJLc6rTkMI4H+DLqZFYJVSlBY5JF9Wy+KomxEmHeB5nMM6MkkOEh4WyyuJZgohY0AhYAWUkZ5wGMbujI7JgvvN7o9QwQf9/lQCOmqI871X4Ot6QUnFHLncta9KqsVpiCrNMjuZx3jNWeVRzC3hijDcRDcCVmfi3DJa1S+RrvIFjnC/QI/vWRNHwT5/9J3942+6QymA0v8UZ3LWdS+z0i2OAX5ZSC6h/+9qxrksvUjdxIQ6KtAJL0xUUS7gSHIDASTrfSmvNDG1UMUxx27+QX4Fa7vs+ONcaIypaBtCYfD5I4/4o7g1Rt8RW9P73HJeUqY7NdZyA3EFqjA2sIblHqpI5z/PgJRYBtCW7BiUykjNdwSB1/cWW4j4Z0tSxJIgeEtzVu0+P0R7qhMCRcyDdwiuyLW4TO6fsyt4AWQl8kM
 kOsq8e0Y
 Fr8MZo9TUvFeo3EFbWtH+CWy6rtzZGP83wqDZrimm2ZtvoX4UuN/eW7029dWlKgvXKR6jQ4Nqb9e1Z2DJGPBj95T77oqo+Z5AAHVrY7+Xmt9M2+z8mjLxakVAc6H0pmn6z0O24c9FuvBXObyUZJ1f4m0pNZAGFo8mB60sxDTeqJDCQVKzhU3Bb5DTpA+ahVzEw9xpXE3FbiZxJWdF7Fcf90B9ncgHKa7KLtzVvcPsaU2Udj4qLXdSx16ZvJVAgxqZJiFnHuaAH67iLP3IDNVVHOQpUk+yuvmqqXIsDFbAky5I8e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

On Mon, Nov 02, 2026 at 04:23:04PM -0800, Andrew Morton wrote:
> So we have two userspace-visible accounting fixups: htlb reservation
> leak, Committed_AS if mremap's unmap failed.  Yes?

Yes, though the Committed_AS part is two bugs, patch 3 charges memory
that was never accounted and patch 4 loses the charge for the whole VMA.

The text you quoted is the v1 cover, which I kept below the changelog.
The "last patch" it talks about is dropped in v2, so only hugetlb splits
ahead of the move now.

> How come the first is cc:stable and the second is not?

The reservation leak happens on any partial move of a private hugetlb
mapping, nothing has to go wrong, and the huge pages stay reserved after
the process exits.

The Committed_AS bugs need an allocation to fail during the unmap at the
end of the move.  mremap() checks the map count and sealing before it
gets there, so what's left is small GFP_KERNEL allocations, which in
practice means a process that is already being OOM killed.  I only hit
it with fault injection, so I left those with just Fixes and let the
stable folks decide. If you want them cc'ed it's no problem to add.
Thanks,

Josef

