Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBBBEFD211
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703026B00C9; Wed, 25 Feb 2026 04:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6865E6B00CB; Wed, 25 Feb 2026 04:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5680B6B00CD; Wed, 25 Feb 2026 04:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 403756B00C9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:21:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8DF516047E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:21:53 +0000 (UTC)
X-FDA: 84482436906.16.9B726EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C476740009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:21:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V+Xm/LYt";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772011312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHTzjPAdUXx7aSK1FZkMhpMuawR9OmUc+gARiLeL2lc=;
	b=cr4xgyJbFK6MOFUm3yb+ciQn2tK2MY4In6KRDSu5BHHQq2UIjsknQnMFkoRa7JY/tBUoDN
	sNRiAq5/UMMjvgyNkoM4xZnrJ61Ub4/PSnOBhE1U+Dl6Iw+J675LMGi/cfttd/2UzFzlkv
	EEoPglZdh/oTXTYLj8rIe2PeHztOJco=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V+Xm/LYt";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772011312; a=rsa-sha256;
	cv=none;
	b=FmrSXvfCSRSgx7X09wmeBQf/s6i5oRDkhrfholTbcSIHuRIvbQNWbGdWfJsvnmqemEuLv1
	7Ob3DFTzxLruhrYtqxrn3pvOpTg0O+6vMhENDTKTnIkPoF4lm/h8CKsKmIr8q5N2VSP+Ni
	GSz904x6PsOQHx3syBPp3KBSnr7j43s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB09F44576;
	Wed, 25 Feb 2026 09:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4C1C116D0;
	Wed, 25 Feb 2026 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772011310;
	bh=kx7pq8DDspnaKIfXROIyERaWB0WWO84KzMGW4mlWQSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V+Xm/LYtmxMDUJ5A8US73eDHyRZSl8sIZdld/LxkspZPgqIE9oLO7fLvhnBXQQii3
	 UO6DqoseaIx9fToKO6WQRhPGlraKtDYDKqo1I1N5LawSkpWqfFmMaxer+E2ihHqmk7
	 SAzDu92PidPFo3qpJC1Lh24gvDfAW3bjONnKh3UAW6IfQ6rjHzqU0V4VqSfeH68cAD
	 XjXZkL4TILHLvhOTzPZ7efIYtU1i2C5FueVPt5MPiWbiLj3cKu5ZNmZhv6x7M9u7VB
	 qIlwKMcxK39yIWX0bky32qPHXgTiEMDkdPhuSUalRSfKIycxVq60oSBpm5xR+O3sNs
	 G3bNy3ZjetlSw==
Message-ID: <f6649b09-aa64-4c91-bf3a-ba706f023180@kernel.org>
Date: Wed, 25 Feb 2026 10:21:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory
 allocated on inode
To: Ackerley Tng <ackerleytng@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org,
 seanjc@google.com, shivankg@amd.com, rick.p.edgecombe@intel.com,
 yan.y.zhao@intel.com, rientjes@google.com, fvdl@google.com,
 jthoughton@google.com, vannapurve@google.com, pratyush@kernel.org,
 pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com,
 michael.roth@amd.com
References: <cover.1771826352.git.ackerleytng@google.com>
 <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
 <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com>
 <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org>
 <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
 <CAEvNRgFyRsqhv7CuuDARHTFSanzOHaudM6JMBLwxDwsrjTNCGQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgFyRsqhv7CuuDARHTFSanzOHaudM6JMBLwxDwsrjTNCGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: C476740009
X-Stat-Signature: x7jydcne1acohj6uyoriaj66ycs6gtn9
X-HE-Tag: 1772011311-301448
X-HE-Meta: U2FsdGVkX1+RsOR3yIhfz5rWXW/jSNm2yxU1QQaFgPTfB2AMFk3aym1EvHy2HMULutyY+ZXH4oIZKfHPXexCRAJ7yGXOQ292MYpZRTi77bRWVgb4jBAmGdsVvEL0X2Ooe8CkpZ+t++HFI7+JK2qQxuD+Ljmz0mfhzPS93cXDfn7UBE8RZZpcKOxsrdnqUtVchj8mXpHdA0UAW6w9B8wMPhxJ2Hba+ia9aPKRXU6DDogci+lMEf+yyRS6frJEHnuUatdOkN7JepppPGMzB3P2fneilUBS4YQrS0Z9OYxLGO190CFAY61PxswYLfaz98Y7oTWRQyfaiF8rUigQUcXrC0zJlgPIDZ26tMt7Z92Mvbtq9HIVIeXB9tGUiGqiqZ2gk9YnpTzz1LSbKwkLgQdnZwYKCt4zCLV9St+6LJQWYjYSK0pFerRRwtTXhdPHHDVb0cnWryJgQzB40hcKCS4eZeMyY5M8D/5mdPgWxkLlUUelKNxdRggbrTWxqxskm3Ng7qJVHRndj4a9x8yDXI1XjlusG2muuxR8BQFpITHqWZvLd45EUGfB6WUf+3UMS70x+FDyuF9AZTUC0uQMJ/LqL2K0qgZ+D69IkFxWrolbfQjLtsW36JYJbiLuMf292X+oMLniW08nkdiS7kDjFsgeLzIzFdqY5DV3PN65HUqeYYx6/hnaIi6OiXaNjYnYm8/4znj+EpE9Igfj2HmM+KWm6Rf6yBDAGZVeZqkQAVGaIo2QDk3b+EjxhFVIEHRGATxrvnns462GZ4HNNHYXhh/NFArNJDKuCV0qjsb75KUwLH0MKJmfOf3ZusKNDswp3fmiZnGcxeI+Sc1buFhjr3xFHWFD5eG1kiI2/Z5JZJoyzIcDzW+ufvQ38jOY1nodJlpFYO8aHEq25Umm4FtyACYxvap6jdW0zAGvl51D93hA3TvvfF9FcY2yQSmUMwuGIuF6ZKe9r6IxFD7GJJ3E9Dc
 DezWuoWD
 VYm6AoI+ic+mwVnfqNwR7nQN+/OF4GG6/WTwV5YbaFu5LEwKpTIUuVK9gMySzjroPrMJ59K+idCpiHBKwWx5rcFOdOLUnFI5x3y5VBjbbXh1MKdyiiltt83I+wQhBdh0GDsC1fXz9qKJmSqB6T/wWgKjH/2Y2KQXENUEKFL4GUkYfqNTMzlMcKQTDNt/mlwabhauouwrC2Nf3Rn40TVd2DTHFPRfgE8qcdJSOT5SUGcfKLamM2X632O1HPsmrrHXj79bMQ8ZXrF11Dn1NOdquqf834aA/2aLXe8Z3AnubW84pK1Bf+be1GYo9vEF4fvq7FyEHAeUKsM5qdTLdmt6IrAKk8XQ+bes+LkjH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 08:31, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>
>>>
>>> [...snip...]
>>>
>>>
>>> If that avoids having to implement truncation completely ourselves, that might be one
>>> option we could discuss, yes.
>>>
>>> Something like:
>>>
>>> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
>>> index 7c753148af88..94f8bb81f017 100644
>>> --- a/Documentation/filesystems/vfs.rst
>>> +++ b/Documentation/filesystems/vfs.rst
>>> @@ -764,6 +764,7 @@ cache in your filesystem.  The following members are defined:
>>>                 sector_t (*bmap)(struct address_space *, sector_t);
>>>                 void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>>>                 bool (*release_folio)(struct folio *, gfp_t);
>>> +               void (*remove_folio)(struct folio *folio);
>>>                 void (*free_folio)(struct folio *);
>>>                 ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>>                 int (*migrate_folio)(struct mapping *, struct folio *dst,
>>> @@ -922,6 +923,11 @@ cache in your filesystem.  The following members are defined:
>>>         its release_folio will need to ensure this.  Possibly it can
>>>         clear the uptodate flag if it cannot free private data yet.
>>>
>>> +``remove_folio``
>>> +       remove_folio is called just before the folio is removed from the
>>> +       page cache in order to allow the cleanup of properties (e.g.,
>>> +       accounting) that needs the address_space mapping.
>>> +
>>>  ``free_folio``
>>>         free_folio is called once the folio is no longer visible in the
>>>         page cache in order to allow the cleanup of any private data.
>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>> index 8b3dd145b25e..f7f6930977a1 100644
>>> --- a/include/linux/fs.h
>>> +++ b/include/linux/fs.h
>>> @@ -422,6 +422,7 @@ struct address_space_operations {
>>>         sector_t (*bmap)(struct address_space *, sector_t);
>>>         void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>>>         bool (*release_folio)(struct folio *, gfp_t);
>>> +       void (*remove_folio)(struct folio *folio);
>>>         void (*free_folio)(struct folio *folio);
>>>         ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>>         /*
>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>> index 6cd7974d4ada..5a810eaacab2 100644
>>> --- a/mm/filemap.c
>>> +++ b/mm/filemap.c
>>> @@ -250,8 +250,14 @@ void filemap_free_folio(struct address_space *mapping, struct folio *folio)
>>>  void filemap_remove_folio(struct folio *folio)
>>>  {
>>>         struct address_space *mapping = folio->mapping;
>>> +       void (*remove_folio)(struct folio *);
>>>
>>>         BUG_ON(!folio_test_locked(folio));
>>> +
>>> +       remove_folio = mapping->a_ops->remove_folio;
>>> +       if (unlikely(remove_folio))
>>> +               remove_folio(folio);
>>> +
>>>         spin_lock(&mapping->host->i_lock);
>>>         xa_lock_irq(&mapping->i_pages);
>>>         __filemap_remove_folio(folio, NULL);
>>>
>>
>> Thanks for this suggestion, I'll try this out and send another revision.
>>
>>>
>>> Ideally we'd perform it under the lock just after clearing folio->mapping, but I guess that
>>> might be more controversial.
>>>
> 
> I'm not sure which lock you were referring to, I hope it's not the
> inode's i_lock? Why is calling the callback under lock frowned upon?

I meant the two locks: mapping->host->i_lock and mapping->i_pages.

I'd assume new callbacks that might result in holding these precious
locks longer might be a problem for some people. Well, maybe, maybe not.

I guess .free_folio() is called outside the lock because it's assumed to
possibly do more expensive operations.

-- 
Cheers,

David

