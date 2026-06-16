Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AED1CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4D86B00C2; Tue, 16 Jun 2026 16:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD5E6B00C4; Tue, 16 Jun 2026 16:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D36A6B00C5; Tue, 16 Jun 2026 16:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0881C6B00C2
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:56:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C0671C3A66
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:56:18 +0000 (UTC)
X-FDA: 84886983636.05.B2448AB
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8B07E18000E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:56:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nc4dClDC;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o82nbH8071ZDGLm0iYK2gdlkX600tsvrzfNh6VLN4Fo=;
	b=yL18WJSAsELQleMkmiIrkF3IrjVGuVUp/6opDn1LtGOUDj3yV2RP9Xpfax2pc9IjxdYZ35
	guctupFn26EgJhX/E1i6KgqMfUxn5yoLTyAnVjqMqcZUY4tKC+uRmPL8OlFG3z6uFLfI2C
	zNOj3y/yV4OG2vYGziEPrwZ/A4auTTM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781643376;
	b=aeTT3cxq0pBQsEcZhCasxav7T88iB69BQfoRI8buZ7IbC6yrwCHMwo8EELcLsXc/ePWGfp
	vBPM7HvaV2NPx8eTKmBYvBjeBpemnvITg+4ocOCxwH6t8VcoP/oJUMBbSSY2OKzGeEInn5
	oIgV38CL0V2LnvjBxE1aiPL2wjhNksM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nc4dClDC;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51778077b28so55368321cf.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:56:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781643375; cv=none;
        d=google.com; s=arc-20240605;
        b=fawYZYtGkM9hUzsrsD9eJl9vqMClT5f2zeUr3mDuGxyrMC3DV0g+m++uipV/6cMdre
         Zc0a86SJJVNmKAA+CQeCrlHLvqyXBc2RnjQErhutPVHMaPH6ObZ4EWeFOGmylkctJHv5
         RCF/Dx19rXNKGIls7WrQuL/ICPgd6VwABVhAXPJtdXouR3UFSWEShjwuMGhv3x4Tk70p
         dCzpRlMyLZ4meh8x/aghRI6pydezH+rO1Mh2ptFXiLMba8h8pmRdIWz+FNzI9dhdb6sm
         X9EH53hfMNnqrZ/nG5aoxPBHtueeqn+Vcq83ApLWmL53qqleQo/mPs3cOFwSlAf7/gcK
         NbEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=o82nbH8071ZDGLm0iYK2gdlkX600tsvrzfNh6VLN4Fo=;
        fh=A5/Nktpqp/9co9EhhiEl5xyGd7zH2xLUXA7stdKZgPc=;
        b=Srw5OapBIyF+uitZoYxKGqo4Mhj8WGvHXRFNJcSY9e41Nxlh0UVBtmsPXq6APpD6/W
         OxA7y/iUew1MwIhZ+yzbFmK6NiFPzGld/MYEZEEcJI0v0ywYhkZNJnlUg3Fge91BkKzh
         QQvdWj4TMcLFY1TI5EmFJyB3kMSyQo2cxR/TTKzfh+uQJ7MZOOcX4x1Ri9CMmPAKXMQn
         vNcvP3fcwqaYm64SveQu8w6yiOVl/ESuT6Nwd7UEpXdMex2ziclV56yYY5GfwqzYsEls
         tCMl+KRt76LIPd2A7q98s+UbKnp4c2fDvD02PZdl7inT7BW8kOoaG792AVsbb9fYv2AG
         53yg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781643375; x=1782248175; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=o82nbH8071ZDGLm0iYK2gdlkX600tsvrzfNh6VLN4Fo=;
        b=Nc4dClDCfO0S3nnW8S18GtTECmUEMkJ/JiQp/yyiDy68r2xfyF18JceBFqzaDnoqDX
         Y1eVClh6/hQIvQJWpuNNpy79GdGGH7yRlK0fEDAJORNr/eDYJ1Kir5apMZUbD3YiXYcw
         uBpbSUMpG4iFYHaxq50J82Bc4tZGivdde7sQlOg6l05sJRn/vBKa2HN50Bq2cOV3UJ4a
         5+12nLSgo8D2JTZmCG3LF7j3nJZJ92ci3NHbJHv2vlbL/+DphPaNXr7pck6rWj+4Jc+3
         ZBvLSl7a1VkF6yrGk3R0Q949/npiACFJLzM/ooMtd6nN1TA4VjaeVdQ9VXvxm0u6wK+x
         zO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781643375; x=1782248175;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o82nbH8071ZDGLm0iYK2gdlkX600tsvrzfNh6VLN4Fo=;
        b=af4XRkVhsIBprrVeceDDP3lp0npM3woUvd2mapB08sZsVBrhLFIzE62YjgNjCQaI4Z
         0KMz9fSFhLrN4MTlLl2I4jujyylnbm/RQiITwioKNmg9TGrtnDVAjG56wBaW8gKhR+aq
         KJhDe72FCAsvuEkTpuwcuU00IEtyRQEOtcwAn5iWdWHvV3BRyfMej0PSWkeCjZD/2BHZ
         27Ht5gBcN6nKQzOoQD5gJRY4yiTpwJ4nhgSq6PbBnKoPxHfD+XnennqbQxeB8X+9Hc4j
         /a7O/cr+os+qrbQxbVTly3TXKKBUGnl5u4v/Qy/wLC4X9yMBj/PohKRiRva1KEgCgTDa
         CxQw==
X-Forwarded-Encrypted: i=1; AFNElJ+iLuRQD1TzSC5v3lyNacq/UnwdhWREa3rfKL0SF+itp9k1dVmO1LDETU43ITCOJD0kjlDRg09vCA==@kvack.org
X-Gm-Message-State: AOJu0Yyb1bRK/A5QDeGALswYUViRGyqm3L2mIOsPEIzkoX01Br3v/2Gm
	p2QqsPXFEIIpqKdvDysizAAagezJscthwrco+uQMd2+m1z2uo6JuCqZPCaeVheb5gQMRqCdYL99
	prLUe+rF6nTyPy7pc5KhlEhK6MvD1BSBdr5HTWL7z6ShjR7Pb9rRfSQX32ds=
X-Gm-Gg: Acq92OHFdAdLotuZcS8xqD8Rs6NKQ+owZbzKYYoPYIKcVCakBuSJyGJXcdtI4iVEWUT
	TDni0GCbxXWcJDdwUCeBqwZDMjBj23gWQKJd0POyk7Lb3hJnYh8O5hz1sieHzRLPBAsBna/6ZFZ
	kFN4etyY4tQudoxip1PmBDviTBPQJObhCUN8aYryuix62hfRrUWo7yfngL/v7/ojN0hi6CBjgVm
	l5pxXtzXrUt7UcNIZAP57+lS/KXNVDtZuABN+8w+B4/15uRAndHU5zR/uEYDXFEeyv7XG1z6F4K
	/9W5wB5ajIE18OtATI5xtQupDqAzNZOrXa7ixYa+jpmg1Aoc36FJ/fqCMxMpaNocjbKl/A==
X-Received: by 2002:a05:7022:622:b0:137:9399:fc59 with SMTP id
 a92af1059eb24-1398f69626amr23221c88.21.1781633399141; Tue, 16 Jun 2026
 11:09:59 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 11:09:58 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 11:09:58 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <1e77f24d-315a-4f68-a109-2f4520343c0c@kernel.org>
References: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
 <ai_XK__RTXMCEcCG@raptor> <ai_aczmeH2IA6JaB@raptor> <ajA4z_Wkb93cTW4m@google.com>
 <1e77f24d-315a-4f68-a109-2f4520343c0c@kernel.org>
MIME-Version: 1.0
Date: Tue, 16 Jun 2026 11:09:58 -0700
X-Gm-Features: AVVi8Cfci2aZVOJMaXs8XbxR0646nJUtiwZFbcmm9wi2jMlpzFimiOSyoy_glyY
Message-ID: <CAEvNRgFQLEsKanKrj=ePHoShiY2cgQgxtGs_2CJcZHP=JOjidg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] KVM: guest_memfd: folio migration for
 non-confidential VMs
To: "David Hildenbrand (Arm)" <david@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Shivank Garg <shivankg@amd.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>, Fuad Tabba <tabba@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, 
	Patrick Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, 
	Ashish Kalra <Ashish.Kalra@amd.com>, linux-fsdevel@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B07E18000E
X-Stat-Signature: 7o3mptfu9ysizt15xuh4ynihq718psmp
X-HE-Tag: 1781643376-36510
X-HE-Meta: U2FsdGVkX1/a9VUkguXEglzhgrP+sK+pTGpcYH/+HZPbFmW5oZHSBYUXvg8CTz/aybUJRwGXapjf8Wnp9bw5yW62mbohxH1lJY9P2A+Fbmvtz8Poe4Ij3UYAfaQTv/MoqTDyrr7Qaeq43e3vznava4KEexqr4Q5POe8DiEOEOHATQki54XAFRJ6IG4UTunaCK3+ojOT6Ha5xsB//wMTzVK/ariXhYS2hmVWvTHhgiahSC2TRomeG/VUyo+Uixs3GwAl0BhwsFD3LKeP0bz6Tlk665ZWeXVtx9PG0oTSArbuCKQwjvxCytI8siM5nMh2rAmrEijk+Q5MlFMkMY89HXvtWxTJzfwTWEA9+nsHUxp6PwtJEWnxIqsMRLAo6fV7kOSB3lr0XN80vIUzW4JyVoKHIrvUHvYEH6JBVx7Nitm2Ha2IFXxFqiH0c2OYOSqYdua3HFMKtGvRCB8KiwDrGjSTyZMiUx6CMadEw/E/3RQXuaiTNZwCpZIAnEJlYCLHiwgwo9I4U0HPKtHwFSMTasgKpK9pr3Z7EK4zEjKPwaICgg4c5NKUcvHA2MpCKhLiqeYbUxREoO71OOfqtcev3xiC6qUJ8cy90Qo5eZDLJurXDjHWb9EGN0w8WC4QZXK/oHS4+6ilQRmiQv7CZwhfK29TC4NY9qg2yr5T8bj5fiJmDcdKWBniFrOQYu6wDpnGrASD30bBUx1Wt9hL3yvfllsCcA56OV7VWKhP2fc0o3QShjYhO6nYN+eDjfyJzJ1uOmYMK1OU6x3jVyvuJWZw1NEBJlP1uN0tvh7gyfDNmuloxK3VCrRdEZWut6ybXCJj39I7XVxb3Pig45HL0pWjTiunjiTnzEDkPvaSZbrFTEzpEHvoIgpzgCGBLTAoroy7o+pr39qxwHKc0f1Hws5QzXzWo0ee3sgIDveGqBIW53dHrTPsyj5iiyyggIs7+aYx+s/6dfZI/R08ZNk1V+7l
 jqjrVKvj
 7hLXV9/fzeDV7855lJNH5WnGuwjPAAvK9oCBiP6lq8Z5zZf2uOEPDmB8fRt8Ji+WDD+GiGKWjrV4n9z9ev3D2TMm4yPAHrTjIyqc21HJ+XREOc/6GqqThYxTftEAtV8OVNr6++FPH2Xc+C47fn89fknfxBmMLRzG4JgWfz02Z0r33Vgsm7QRsmuROxDdfTb+V9kbaxVryIcDNmIgAK+kjErOnJgQfbLcAjlSPaegbXvLNy59KW4w+21xC8ArbZvfAW6lHWZCUyJABDBn4JNTglltkrnwW3CxrzSy263UZHJ3AgLvHtbvR1u8NIfLmu+bZITyrVkv0fGKv2UpR0S8zdkVUBqKFVYI7/fZFYj3IJGvNtO4ooOMEcWjb7dTLHmeaZtU1u2ZOrBTkyMvKOWPb3y+bSUGJcVfmq8c/inT0zOFCmIk5WlhPP7AHIKvCrqRNxW6jlFRY4fgezClqbPNxlaYMDvVA8s/HjhmOpvOFTkDaviU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 6/15/26 19:39, Sean Christopherson wrote:
>> On Mon, Jun 15, 2026, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> On Mon, Jun 15, 2026 at 11:43:14AM +0100, Alexandru Elisei wrote:
>>>> Hi,
>>>>
>>>>
>>>> I always thought that one of the nice things about using guest_memfd as a
>>>> memory backend, as opposed to host userspace mappings, is that the host
>>>> cannot unmap VM memory because of KSM, automatic NUMA balancing, hugepage
>>>> collapse, compaction, etc, acting on the host userspace mapping of the
>>>> VM memory, and outside of the VMM's or KVM's control.
>>
>> +1000.  It's not just "nice to have", it's a core design principle of guest_memfd.
>
> Right, and I raised in the guest_memfd call also the rough idea of Alexandru's
> use case of having non-movable guest_memfd pages such that we can support use
> cases where we can hopefully guarantee that a stage-2 mapping will not just
> randomly go away.
>
>>
>>>> I think it would be useful to preserve this behaviour, even in the absence
>>>> of confidential VMs (i.e, guest_memfd file descriptor created with
>>>> GUEST_MEMFD_FLAG_MMAP).
>>>
>>> Just to be clear, I was thinking that it might be useful for both
>>> behaviours to exist (migratable and non-migratable) for non-confidential
>>> VMs, and allow KVM or userspace to decide which they prefer for a
>>> guest_memfd.

More concretely, are y'all pointing towards a
GUEST_MEMFD_FLAG_MIGRATABLE, which will set .migrate =
kvm_gmem_migrate_folio, and for now, error out for CoCo VMs?

>>
>> For the purposes of this discussion, we should separate the physical act of
>> migrating pages from the features that trigger migration.  As I said in last week's
>> guest-memfd call, I am a-ok with supporting page migration as a mechanism, but I
>> am dead set against supporting NUMA balancing, KSM, LRU-based swap/reclaim, and
>> anything else that goes against the goal of guest-first memory.
>
> Right. Page migration for supporting ZONE_MOVABLE/CMA, compaction, memory
> offlining, virtio-mem and possibly some collapse mechanism if we were to support
> THP of some sorts in guest_memfd would are all reasonable.
>

Background question: how would virtio-mem use migration in the host/guest_memfd?

> As soon as we mix in access/lru semantics, we're going into the wrong direction.
>
> Fortunately KSM is anon-only and not even worth a rant here :)
>
>
>
> --
> Cheers,
>
> David

