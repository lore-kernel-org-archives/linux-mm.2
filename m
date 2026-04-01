Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BA3107637F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24BB46B0005; Wed,  1 Apr 2026 10:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222EF6B0089; Wed,  1 Apr 2026 10:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB566B008A; Wed,  1 Apr 2026 10:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF2466B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:35:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B1B35B8C1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:35:25 +0000 (UTC)
X-FDA: 84610235010.09.2380914
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BD7C2100013
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:35:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YJJhGtI9;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775054123; a=rsa-sha256;
	cv=none;
	b=Hl8mAUyeOu6t2Q1cNS78ZFuygJkxhy/a0tUIh8Jt9iigXvD2Uh0wSRgMq7ukc4c1+qTPka
	SdP1+SbJvYb/wTo8TVDiQ8QSqux8PcEQOI1cBAXtOrgJMkV/jm9B7BaqZ0mLbqMrqA2EYs
	km6buEbdaD/X2PKzTGWjvlNbPE54kZs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775054123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsuaJggPJGRJFR8J9on8seMW50aa+Y4/5qPXMJ7I3/s=;
	b=QCke0wmpScT5xsFS7hZJ8+wN0VYiD+cmex0aqDArccFCWSUJwS0XG1LynzzflKsru4Tszt
	dxHxaR2oPlO/w3NmstE66Zp3us/2OmkdxoVRCo/5Bd//KidPT4H1iiH9Ed9bJT7l7FdDf7
	bqaK9UVVrUHLV9270y6yhx8XnmDJKIo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YJJhGtI9;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E1F060125;
	Wed,  1 Apr 2026 14:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8489C4CEF7;
	Wed,  1 Apr 2026 14:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775054122;
	bh=8L15mk7uBbIcb7Tq2K1XChKVrDaUFFZb9Sv7JfqIHto=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YJJhGtI9LqaXWQGbRVZsPCUbXFlAgkfoX4ONmNboth4EOEPZ/BavQQ76K3894U6UB
	 o4e7o4BAATRZ8R3zHDRokeuqDK+++QlmsrEtiFtENF3l6Xr4yce6xsquadb55zT+ZV
	 S3QgbVdUGD2S+OTVwVxuRaB0p98IpDkit7XG2XsPRkTcGWwzN6/Cvyrys7jiHKpTrJ
	 zZr1KX1PsRCo+vzPxmj9IolWPJMLgx5+x3O9Jtm3i82jP5VrpwOR/r0f4kOl27syp/
	 DUaRPDO008259oUk3rrNfXm5o8c8cwGeOFbDTrwdQKVIPjt3mFJ5J9Nu1wr+ANUAqb
	 w/mSd6j0BrhxQ==
Message-ID: <cd36fe49-56b6-4ec6-8dc7-9c793f939bb5@kernel.org>
Date: Wed, 1 Apr 2026 16:35:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
To: Zi Yan <ziy@nvidia.com>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <25899F67-955D-44DC-935E-D7F234BD335A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD7C2100013
X-Stat-Signature: txi3pg7sfiqdjgq7wwtsskxp34k6ypfo
X-HE-Tag: 1775054123-879271
X-HE-Meta: U2FsdGVkX1+djvWvloWLqJD75owP/6HltvTApM35h6vLGss32vIuaVMVtqa4yppkU409CP6oF5OLmJdw6ZLQUp1yXz/7XmMbMBZZMIllEj2uVk4Y2jrPRFiYD5JTJ0Y5VMiSnZijnFbH8BdCPDjpazcLgrBUhmgAfByUJzvrrvcV5KJdVdVbz3qfeVmGDmYMmscJjf67pF3IAAiPDhHeAtfjCdwBhNIGMIbcnnmkL2yEuC+XwolVqIzg9tRZajrf8vmYOUbpkjbw0dyNXQENdi4pqyuvrVvxCq+kmvM27GoaAM+nmpw50a5yx571tLkDFQwIqfwdyzY3XL50xxVQ1YwEdJQC9EZ6evheG2Sro65K7TNhU7QMXehEblu4bXHXCdkrdCe18BnhLrH2jIXk67xZcS13WhHq+7KsoXpvDap4kEkyYRSGF+/9P/Ue1zev5UUIvUIAv3HIF0889cpVOUVRKh80RCgQ6YhxJWMUdAzz/sS8rj95UqK36nnQgFKQD7gjYwtZOjd24C6lyB+L34BUutWjN90us5den3d/0b4frUs64GPZXjcUQmxx57JkERZW4jUw7LxUxxXGFUHtJPERDHA7IkN95/3/gKhWlj7W1ERo+Kujca/ZVCTCi7p7XN/WnFQ7l7Ykw2z5fTSb9+aAMfD0gA5NvvIYvPNaAC9b2JhkCs0keXAmS8q0qCxzPR8n0gj5dZeisBmk55hwZ1EbpIddOUTPuCP4ghajGR8TCVTvd/h9wYi4sI+jLpO6H2r1JZrBoRx0VGwgfOshFbAROJM76Cg2fu4zSknbhjfCJdP0Hiu+ipqxCPgvzED/oJ+LmlswQvT4I8nxm8E5Z1CER0W9xCHNjXYirdiolr+S8ucO46f3XCG89MK34JPTawZhdt5E/6X3W21+3RyV74WoREDnWa1YKmVIDCmZNwbO2zQ0nRj3QNiRTqLyn7JGpF6wNZe0ClotODBw3Kn
 pt3CdLjj
 KU92AM83qJpOtMm8XGfLvKTS262t1ZI1j35a2VNWUc0OcsuXJb7gNxvQi/aJQIC5FgxOTN7HUE9hNiKp74piRaZOnQLPKK/EcCxrBFe0ZBt+AP7LzV9lZz5hpUOBQl+n9NFfXp7IRZBnGixTu5JHFvEC2MHci/JPfjwOiX3DqXLGgy0X0DCgBFULFDrwT9wgN4AsOMcM+iE9lAZmC1okq8jIJ2gtvO+dkhfToungS3fWYyNUVurF4y3/RaEG5yjUtGOc6vsemgesx6eCREsWEdf3T19auuTo6mxQnxzr5V3hvhWLS+5rAUY/IHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 16:05, Zi Yan wrote:
> On 27 Mar 2026, at 10:23, Lorenzo Stoakes (Oracle) wrote:
> 
>> On Fri, Mar 27, 2026 at 02:58:12PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> There could now be a race between collapsing and the file getting opened
>>> r/w.
>>>
>>> Are we sure that all code can really deal with that?
>>>
>>> IOW, "they already had to handle it separately" -- is that true?
>>> khugepaged would have never collapse in writable files, so I wonder if
>>> all code paths are prepared for that.
>>
>> OK I guess I overlooked a part of this code... :) see below.
>>
>> This is fine and would be a no-op anyway
>>
>> -       if (f->f_mode & FMODE_WRITE) {
>> -               /*
>> -                * Depends on full fence from get_write_access() to synchronize
>> -                * against collapse_file() regarding i_writecount and nr_thps
>> -                * updates. Ensures subsequent insertion of THPs into the page
>> -                * cache will fail.
>> -                */
>> -               if (filemap_nr_thps(inode->i_mapping)) {
>>
>> But this:
>>
>> -       if (!is_shmem) {
>> -               filemap_nr_thps_inc(mapping);
>> -               /*
>> -                * Paired with the fence in do_dentry_open() -> get_write_access()
>> -                * to ensure i_writecount is up to date and the update to nr_thps
>> -                * is visible. Ensures the page cache will be truncated if the
>> -                * file is opened writable.
>> -                */
>> -               smp_mb();
>>
>> We can drop barrier
>>
>> -               if (inode_is_open_for_write(mapping->host)) {
>> -                       result = SCAN_FAIL;
>>
>> But this is a functional change!
>>
>> Yup missed this.
> 
> But I added
> 
> +	if (!is_shmem && inode_is_open_for_write(mapping->host))
> +		result = SCAN_FAIL;
> 
> That keeps the original bail out, right?

Independent of that, are we sure that the possible race we allow is ok?

-- 
Cheers,

David

