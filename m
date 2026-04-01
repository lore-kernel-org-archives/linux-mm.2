Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C11810FCAC0
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00526B0093; Wed,  1 Apr 2026 15:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1F86B0096; Wed,  1 Apr 2026 15:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79226B0098; Wed,  1 Apr 2026 15:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B225F6B0093
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:15:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 583D11B6F7B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:15:36 +0000 (UTC)
X-FDA: 84610941072.06.8B93E78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2CBF64000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:15:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lzjqgOm+;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775070934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jheveB+eu4gNmVSrKdv1Jq5Kb8fEY+iux5CovZfs8PA=;
	b=7DF52BNZKZCzS14uLQ4ID1rkNW8E68btLltDNR6wovxV1PkJfwRnQKEW/g6X/C5EC0+rfP
	oF7Xh1Q0NP6K+KtriLplUjOe4dse3AhFJmz5olorcXTqFlNK5edkQsoiylONOQgudAjviU
	Rwre+bS8z+naM49K63Howpog0BMWfGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775070934; a=rsa-sha256;
	cv=none;
	b=RzNTP6RiI9/yQ9d1asZVLY6w4RfO9Dtc2r89SjlwFOViHB5R5cijDVfurKZPneDEYZ80fc
	L0nIn5h+KMmSVZmF0Xd4gOEn4S44CJxq2GZFEDYTbB53frh2hQPG3xkl00is1edm+L5nxh
	Io7o4IaxbnygBJcJ2C6ApwYffOIzjHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lzjqgOm+;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4401543E8E;
	Wed,  1 Apr 2026 19:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD10AC4CEF7;
	Wed,  1 Apr 2026 19:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775070933;
	bh=1Dfy8STCS29Dd/L8IzAykKpCipm+hEQa8viNiYyzGfU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lzjqgOm+wFCzIALJBVhPXdFb/bNnvF5NnNteJFDvPa5LDOk2vBC0AmwqvDuBIROnJ
	 UroG3YHrw2asdYXECNtFGj38U5CqTjXdTjDrnleArISDl1om4LGTKYSpGfuzP3b1OL
	 SnXo7byHAudebm6kZyhIN2UJuzDNoyzSr2+OWTXvKQnv+/bfLEEeNnY79duBu9CAXS
	 y/hT1dupJK6YHXvSf2tOLCJAqf48L2OhF/Kh6GLG6JpbeA231aLBvCjw+DYI0VC9kR
	 aRbB4G1PdoLXTI41OoyjMF4O2MWtSUU4ceYsWS9EdeJYYu6AKEIJRdjdZRooNuMXMb
	 4SEYQ1KwNLBAw==
Message-ID: <f7e1bdbf-cb88-42f0-ac48-1a273bda2455@kernel.org>
Date: Wed, 1 Apr 2026 21:15:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
 <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
 <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
 <25899F67-955D-44DC-935E-D7F234BD335A@nvidia.com>
 <cd36fe49-56b6-4ec6-8dc7-9c793f939bb5@kernel.org>
 <EF04F17A-89ED-40EB-BA91-7A82713E28F8@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <EF04F17A-89ED-40EB-BA91-7A82713E28F8@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 8kwsazmcfmnh96ynmsyppayziwidzoxi
X-Rspamd-Queue-Id: 2CBF64000F
X-Rspam-User: 
X-HE-Tag: 1775070933-512638
X-HE-Meta: U2FsdGVkX1+dtfJsrl3aUB9IEDib/MQUc7aCDaDC9egXwJV0StQCPDKWs8BT5fYMYj4mBldpbWnkQzc+x2SBL46uS99b04mPRKhmC/lIRICug7p6SxEgsn5dFBgVBFT5j7aEXdbXd7HxadGOpYbkBxpkuE5Qlv+6aXRb0lm5qErE+2s04YJTQaFc8UtOTeBD5H5UVc3nsc+F9FgSqo1BF7tiXh3mQGVTS9bMIFYY9qG/1M97s/3xlSlQJL7WsIrAtssBRn7Zi39+b7nOSdfsgTxrP4B+dwqJi+ATmqVJDoHiFuGo0tB5u+Ubqq1K56EDVozzj73J9xW+aSUYJ1cbKN1pTyB/rqePxF9cupSYtOaP0GoucwhCAJhQ+k0kQ8YrSEw7nGnIH318AsbyW5wmsvPb8UGS5aIfAkoX2ddSUBKcAoptdGGYergWHYbUdNMVwJOvQYDXAnWY5k8AFMCcqN6MHBCKY5YTy+rghyS9yICVFwWnDFh+n5DPCxL2pErpobgwiyZAiHIxxi2AIMh1TII/z71IA5lHEUMQADhpC/nYYeW8s3dQzO39SiiQpsYFJRFIXvaQiqkW3iyKeBR8Sd8wPD1opjmlDbX5U+9OJx0rNFiGEimvmWwTozuTOYHAgMPjxz4bUBTAnG5wXB3n+hMv4O5vNoCv96oc8tx1dxP6xyNJnescgMilBJDfg3IXYSACsUKhop0XuRrw3NsYnCLauXX1d4CKncjKCCBULpF38bEtht5hZpovqJBliX13d5cpCIL8USZD9a5mfZmdsOvLSphWWRZhrV2y7It9G6nVaTRikQWob7L2XxAHvo8J9S2gAoDwZga441oOvhJYca4evYoLllPhnRRNx32Jrjec42e+wa2j8kbgL7lbU3k2endyIdZ5s8QRz1UUPC81lQgNrGEaHez/emkD6PuWcwkc+SPAsTj7TCylSQiDo5MIfdF3bmsBoz8SfdgIISx
 fqywAv74
 +p7F5jocCbQ0q0Z1/i3BTyeX0Z4zU3xbv9xai9ua8kwC1i5N+yp5ugU8V4WeeNHqaLVAkpeFMRNnBpYNpGK3D8yhY7mW8B3HN3uJNeHp11PIQc41/EQH+wMJMFxv0HnG8bBjGYQqB4NB2l86kyzknQnxpettGNup8cDHXfjDiOeqxKpKJccYfAMH7l4tEEHP2QGoASvkRj57Rc1//VZNa0+HxOwdPktn/VJiCMpa6rEuX+BeJqze90B47SGmSGWZ+dSnxvA2RVYrErPGCSXpD3r5bDIvcwY9s8KNaW8gV87Ghwh0kXwzmsLuUuUaX0dEFGsJdaGZ53Dc4c44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 17:32, Zi Yan wrote:
> On 1 Apr 2026, at 10:35, David Hildenbrand (Arm) wrote:
> 
>> On 3/27/26 16:05, Zi Yan wrote:
>>>
>>>
>>> But I added
>>>
>>> +	if (!is_shmem && inode_is_open_for_write(mapping->host))
>>> +		result = SCAN_FAIL;
>>>
>>> That keeps the original bail out, right?
>>
>> Independent of that, are we sure that the possible race we allow is ok?
> 
> Let me think.
> 
> do_dentry_open() -> file_get_write_access() -> get_write_access() bumps
> inode->i_writecount atomically and it turns inode_is_open_for_write()
> to true. Then, do_dentry_open() also truncates all pages
> if filemap_nr_thps() is not zero. This pairs with khugepaged’s first
> filemap_nr_thps_inc() then inode_is_open_for_write() to prevent opening
> a fd with write when there is a read-only THP.
> 
> After removing READ_ONLY_THP_FOR_FS, khugepaged only creates read-only THPs
> on FSes with large folio support (to be precise THP support). If a fd
> is opened for write before inode_is_open_for_write() check, khugepaged
> will stop. It is fine. But if a fd is opened for write after
> inode_is_open_for_write() check, khugepaged will try to collapse a read-only
> THP and the fd can be written at the same time.

Exactly, that's the race I mean.

> 
> I notice that fd write requires locking the to-be-written folio first
> (I see it from f_ops->write_iter() -> write_begin_get_folio() and assume
> f_ops->write() has the same locking requirement) and khugepaged has already
> locked the to-be-collapsed folio before inode_is_open_for_write(). So if the
> fd is opened for write after inode_is_open_for_write() check, its write
> will wait for khugepaged collapse and see a new THP. Since the FS
> supports THP, writing to the new THP should be fine.
> 
> Let me know if my analysis above makes sense. If yes, I will add it
> to the commit message and add a succinct comment about it before
> inode_is_open_for_write().

khugepaged code is the only code that replaces folios in the pagecache
by other folios. So my main concern is if that is problematic on
concurrent write access.

You argue that the folio lock is sufficient. That's certainly true for
individual folios, but I am more concerned about the replacement part.

I don't have anything concrete, primarily just pointing out that this is
a change that might unlock some code paths that could not have been
triggered before.

-- 
Cheers,

David

