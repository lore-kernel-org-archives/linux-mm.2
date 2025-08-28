Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDEC9CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD918E001A; Thu, 28 Aug 2025 06:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A51D8E0001; Thu, 28 Aug 2025 06:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193B58E001A; Thu, 28 Aug 2025 06:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1308E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:06:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F4EA13A592
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:06:23 +0000 (UTC)
X-FDA: 83825736246.30.CB4CE63
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 25C871A0009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:06:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bdu/+Evn";
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756375581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIuF++MW+9cppH2LcogxBtVCMHjKY7lH5B9a+qhZ5nk=;
	b=2MwhXoGYq73/9fjthLDHAl6vwq1zK7i6bWJZy+hb8PvwANmgaoxV9rwvW+Vg1hZvY41mpE
	ed7p6tTtAgku3tHojC8X6aAOFKxYBEZWm4KryXRD8IGBrKhgqxYXOj9OiyYLsuFV2TJR5B
	izjcVOVYeT9sZSwgKWuoW1Nx294kkGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756375581; a=rsa-sha256;
	cv=none;
	b=TSOGn6Y57wHdNB1501UdZ+Y5m2xtrzSl+V2z32acr6XvyjqWnmwHwnSdtsBU0wDR5hpxGE
	HYywYq6u2EzkHk5DmaMH8pXEE/6J2FG4L4wHJCXvMpLt0m6cvZmPu3md6dr+YlWKE2ut1A
	Z4+8zXWwba3sadYT0WD+5wl0xyK8psw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bdu/+Evn";
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756375580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AIuF++MW+9cppH2LcogxBtVCMHjKY7lH5B9a+qhZ5nk=;
	b=bdu/+EvndH9UhyH0ZtPZs5gvfrDagRlK7thkh+a8MgwcZppz6adUqXtsr+qFWlkLn4jvMU
	EgIidaV4acS53iwtM/B3xPFcDBkU5MLOwg+h7+ghla/2hiMNZlD36tgYRMbIbryjMvFOUQ
	6e8LfP+6H+j7rqCWUMxQ7bYxZc8Fvp4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-dpmb30smNvyj-PTNzbyAZw-1; Thu, 28 Aug 2025 06:06:18 -0400
X-MC-Unique: dpmb30smNvyj-PTNzbyAZw-1
X-Mimecast-MFC-AGG-ID: dpmb30smNvyj-PTNzbyAZw_1756375578
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ccfd90630aso343627f8f.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756375578; x=1756980378;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AIuF++MW+9cppH2LcogxBtVCMHjKY7lH5B9a+qhZ5nk=;
        b=BeegQkcVlwis7mcVSPzDhN7iy8FFhVQrsP44JeZqfeyxBZnxNfrT/B9CgxEjvMKgnY
         ZpAVsXc3oPqaQQYtnjcVdCXGY6RgbIZr6s2YQnm0YhKGW1oIRtxTsQ84i25SUUz6MAKy
         t0QHXkSIi7tQwMhWcWxdw0n0lZlHZslJ/5gnAWnPbILkWQHgccZmlYZfIIhPj8KPxCmt
         +cWlBRt9vstEWyv9jXpYaPIfR37lZQzVZwUeeW+1QbvsXGdNlrmpKlHpFvDXpNQDZmeJ
         55bnReDNwCSv5gfkX3fZYW9PhLWib474kEFSvkrpA+Gs5jYxaS3CT6QU2Ux9VJRTLI16
         eDIw==
X-Forwarded-Encrypted: i=1; AJvYcCUevufrwFblUNzeUt1cpE9z95bh3c+9yEfvCmGs/sgDPFdVvVhFV6d9bDcls/avKtWb23Y0KZxJGQ==@kvack.org
X-Gm-Message-State: AOJu0YxjCXSXR9IlcypJWo9HqOL+PtMVIp98r0MJoTYUNb5Lax+z2/c/
	iGaE0rj2gLn4OTSpEiw47v6x3Ahdsm5Uj3O2AzbyZNBV4UzQYaXvI0YoAQPzLUOZnrh8dFeCFtd
	uXCpg+ibHS7WluJ5gnVWT9f1tBDfnrSwDl0YfFlB/RmcR4Ma5uVun
X-Gm-Gg: ASbGncvaoIY6Z/J7hw/0f/OmzywUAAeinkOUNoTWhV97grUkl6fQY7j2wKz0lsBcUlL
	JWQkTNkiB/JCbv1+gTLG8/Rs7WO8nfhC741lVQicKrkd7zJxelVjg0wTfdJY6BCMUzEOYjbaExi
	rFDlbJCJetLHlCDpBwmHgjqhGfxvCnv8V9vFvTQQp5V9IDljySMKWGm/nuqXrU+gDdBawb0CU1x
	xGGPHDrHz5z2IpaYBP7T2clTs84fGPZIFEa3Qn+kJoty/BgKblPJozHXUfBY9VjKy0dFHYmbUcK
	LG3NEqCy1qenANtZFULTJX0fmD0Zq540O/6lQLkXY7472pk1XExscqpEvoGsjH8QLDGSomFZW/B
	IZ/U2nd14KMgDZPvxFlWcYkKM9IjQhSIZxAYRqHGr8d4n8Bj12WQInOpWs6aS04knzlI=
X-Received: by 2002:a5d:64e1:0:b0:3b6:436:b8ea with SMTP id ffacd0b85a97d-3c5da83c601mr15705096f8f.6.1756375577375;
        Thu, 28 Aug 2025 03:06:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHv6FDhe/e4+uPIRUaF8D2ckX5J+70BvRLKIj3J1sQm8lva6qxwVAKdzmfSmO9HiwptWSyrXw==
X-Received: by 2002:a5d:64e1:0:b0:3b6:436:b8ea with SMTP id ffacd0b85a97d-3c5da83c601mr15705026f8f.6.1756375576743;
        Thu, 28 Aug 2025 03:06:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4b9f8dsm26199961f8f.9.2025.08.28.03.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 03:06:15 -0700 (PDT)
Message-ID: <4db9239a-efe3-43b2-b7b4-af497eb9ee28@redhat.com>
Date: Thu, 28 Aug 2025 12:06:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>,
 willy@infradead.org, akpm@linux-foundation.org, pbonzini@redhat.com,
 shuah@kernel.org, seanjc@google.com, vbabka@suse.cz
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
 xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com,
 josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com,
 jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 tabba@google.com, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com,
 chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
 shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com,
 kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org,
 cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com,
 roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org,
 ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
 gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com,
 papaluri@amd.com, yuzhao@google.com, suzuki.poulose@arm.com,
 quic_eberman@quicinc.com, linux-bcachefs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-7-shivankg@amd.com> <diqztt1sbd2v.fsf@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <diqztt1sbd2v.fsf@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xjuGrZwTgBYp9HSuj5wfwVz0BU0lMpoOKEJPXSzPhCA_1756375578
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25C871A0009
X-Stat-Signature: x16z8jazw9mp9zu9ocyef8ig8s4ojgoc
X-HE-Tag: 1756375580-314713
X-HE-Meta: U2FsdGVkX1/a0rW6OZ2IiCcUa5ou9hY1U/chcz7Nz910vWwaL2y41uiJ+sum5m8x1lwyMOIzVupTQviHCBL7Mjm5fJ2r77qyoY3v8CyHRHtO5PT89lbV1ux9x0DvcMsNhVyqPVhFd/0IU6FWtaCpr5kxFX6Q7716YPV7keQHK8bnW+gksf4jv2wo3kJKQyckZK1VWM7pSdfZh92GOD989/W/or0d8XJ57m8l3hsfPKyGWXvEDyXlzd+1x3hLZXXOBc36nzHGaZUNtHyjUeGAkNBR1a+3Mvp8Csw6+iYKcOLAFa+4JAZ4EMbwDSokv56YI8hcSPHwpTFw6EOCUGgHetfNGXVxkt1tmmaBB7rZsoqY8RmQNKQSckU3I91X2gf+fqdQ1JYHVy2XzLv3bLfvvWx0ficOGOdVh6SWrx9ixe07aSh2bMPIe2EhSsp6g3IDQ71arwo9jh+LoQTNUN8iuPNyNUpPAqjVB9jZH3WdCecmoifovAnYbZrMAW09DtkOayHZ/0WKIOpPNZO3yQW4mKAtUxx1T1F5LXjYCo7Uw0rrVTEKzITWBLmm13iA9BtG+7puNhfxz8hsimXe09yn6+moA2XpwPvlndJgYXzRNEYII/WXsoUozEiYV6KmZStInMAKZX/OATCzcqdr0EEzHixIhRqI94WYBD5N6MIg9Ucs+1xP/t56K2LskeSkPEwIDbo3LfD/WSc3O5kFl+rLYpE3hJjGtT/OmtAdaAC2S+PmMK+TbR9PgeDhS5r47LFze/EdyeuEKDq5IKNQve2ijIVQP/zZieOogd+SaoTAtbLH8OrcgLm65LboptewzAkUFngbktttOpEKoyVOKQOnPIt0s0EH0mM24Yc1GJW2N5yCGEMGWI1FJ+uh/oEv0n8ki3FN/N6N3W2JW3adpoa9tcKfvsbal7c3ecjb2IZ5O7C3I2aB5omRdkr6ocGty+bqVDeKnfhtwvuPGffbTYN
 FsKQl7ti
 cox0KXKG7egfCI/eOBVbDfJzH9mCx8KgJvFJkYFruTPjEwo/hb6iiub7N4ttX45ZSmo+Z4hYNUTg0CMas5OMF3lsPqgOuNlOFkKf7f3Sg6ePN2JXXzJpJ7NzNHWIrs76inK4nIV1XgO45/1TayG5xH3gvJ/pDUCH0fPILwCSP8XyBEwU34dadn7NbnlBQhx1mGnEX7OhCo5Ee9Kl3oyJZzWOyFhxnhzZ9qwWk5uYmGwW/OvpAcV19afxrx1l5DOFfxSbmmjDHu/+V6xptrvW0OnsC017luSoizPH02/zR5XKjk4lQ+8A4FFkKQ7in7n+3DviKRNr43G1rTLGdRv6w4Jz4WO13f4tCip3C3DbvVthxlLHvQ1+n2k1oCcQ5NqloDSDBsZaELJZ2aWo30xlCK+cLMFPVBGa4vhIBRjRVgIGDSIl09cDLvig0a80TmhslL+hM2gBcgltCzmWkzbqns0Uot31aZKCX5RAiq8/9yC/N9MbZ6159vYFgpsns0W6QfVyW8YVNWLzkBgUU86gtbDuAuhPOX5F6mLSARhsz/Go06QZlUed7r9Fe27R+0aHBbWkiLAt4SGAcLrE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 00:43, Ackerley Tng wrote:
> Shivank Garg <shivankg@amd.com> writes:
> 
>>
>> [...snip...]
>>
> 
> I meant to send this to you before this version went out but you were
> too quick!
> 
> Here's a new version, Fuad and I reviewed this again internally. The
> changes are:
> 
> + Sort linux/pseudo_fs.h after linux/pagemap.h (alphabetical)
> + Don't set MNT_NOEXEC on the mount, since SB_I_NOEXEC was already set
>    on the superblock
> + Rename kvm_gmem_inode_make_secure_inode() to kvm_gmem_inode_create()
>      + Emphasizes that there is a creation in this function
>      + Remove "secure" from the function name to remove confusion that
>        there may be a "non-secure" version
> + In kvm_gmem_inode_create_getfile()'s error path, return ERR_PTR(err)
>    directly instead of having a goto
> 
> 
>  From ada9814b216eac129ed44dffd3acf76fce2cc08a Mon Sep 17 00:00:00 2001
> From: Ackerley Tng <ackerleytng@google.com>
> Date: Sun, 13 Jul 2025 17:43:35 +0000
> Subject: [PATCH] KVM: guest_memfd: Use guest mem inodes instead of anonymous
>   inodes
> 
> guest_memfd's inode represents memory the guest_memfd is
> providing. guest_memfd's file represents a struct kvm's view of that
> memory.
> 
> Using a custom inode allows customization of the inode teardown
> process via callbacks. For example, ->evict_inode() allows
> customization of the truncation process on file close, and
> ->destroy_inode() and ->free_inode() allow customization of the inode
> freeing process.
> 
> Customizing the truncation process allows flexibility in management of
> guest_memfd memory and customization of the inode freeing process
> allows proper cleanup of memory metadata stored on the inode.
> 
> Memory metadata is more appropriately stored on the inode (as opposed
> to the file), since the metadata is for the memory and is not unique
> to a specific binding and struct kvm.
> 
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


