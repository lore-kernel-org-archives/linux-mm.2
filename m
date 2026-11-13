Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B03606A8A8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=v2J4x8w4
Received: by kanga.kvack.org (Postfix)
	id 33D336B064C; Thu, 12 Nov 2026 21:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314736B064D; Thu, 12 Nov 2026 21:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229C56B064E; Thu, 12 Nov 2026 21:42:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 023806B064C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:42:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C3D11C3BCE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:42:51 +0000 (UTC)
X-FDA: 85428548142.15.BDF0C84
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf19.hostedemail.com (Postfix) with ESMTP id CADC71A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:42:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v2J4x8w4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794537769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpfqaLD/s0aZ2I2qPUV8mwprDsWG5GFsyO34/kwcrmE=;
	b=Pr4J6jkqZce7FzloQ1B5U3UVFEcs7WCC+WP1GSlH8Hu+b1tZHbOYIA8zsxCAfzNfMCMzKT
	fUcy0YVxR2EYaD+nyXWd5owX+hMUMYEM0frad6bLZ5o+8v/0dSlis4dPQZYFdzJ5/J5NnI
	Q5QMMpHNKOvk8SG2c/ZPOLZJU+YegwQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v2J4x8w4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794537769;
	b=Ow9kX1S+4buoe3lZPGt8lOYWcT5sl7x6zqf6bDyyVTz2eiervSDgMGeR+RaBLBWC3zln3K
	LUZTwwaOobhxHkSl7qbZuVb/FX7cp45JPff2X3laJudcnCD96tU8zLiw0PO6cnCDLTyLZh
	cW8Sj8zNzETt2kdiEaGWOa6yAZLTQY8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794537765; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rpfqaLD/s0aZ2I2qPUV8mwprDsWG5GFsyO34/kwcrmE=;
	b=v2J4x8w4xEhBnkI2KXUn9Obj2RPAX7Pm0AMMy1kLpWiU10VOmZmULFBcgr9nLPL6XyBojG03lx+TyWpUnuo9dhfVQxUM/fWx+m4kDo+3HAo1cXY16nG3LvB5VEvEG88b9fl0VUKNPUm8gcrhVwtvUSppvcUk8rAw5vErkQDIHgM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XEdeb.M_1794537762;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEdeb.M_1794537762 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 10:42:43 +0800
Message-ID: <795b8d8a-4f6f-451f-9274-ccb8380e03dd@linux.alibaba.com>
Date: Fri, 13 Nov 2026 10:42:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
To: Andrew Morton <akpm@linux-foundation.org>,
 Pedro Falcato <pfalcato@suse.de>
Cc: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <avYBFPhB46XWAG4A@pedro-suse.tail5790ac.ts.net>
 <20261112145036.97f74a828755d5b9178a3e3a@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261112145036.97f74a828755d5b9178a3e3a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CADC71A0002
X-Stat-Signature: ttico3rxrerib3qdw1uzfxwi87ok1aze
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794537767-672210
X-HE-Meta: U2FsdGVkX19gEbCO7+JniIkuyScAnFjLSH66yA8tZ2CiZAFaOWXyQIBF/fLIGqUGeOx1nmo6CTQx3UcCsdgt3GgubAQHY7RYNPY/3uRFdRtKUAcEloK9w1NbgZpoMUvFsDAVuN+yEUPVQK6LnPUGMiNORv8fSCcRWCcIEvV7Zqz+PF5nIby0cHMKy3IBorzilPhgwAuUpcOYgzYu/fWh/zkOXDZwthkM56jxh9cKDtPwrDC5fDwiC81oYDxm0+btzei6V5d0LExdcZfl62v0W0IhzOf4gexhOvJ7MocxVcQVMJ/nrBX7hwuKiSiVUeGXbONPLqd45jELW4DHY7lvav7eYAXLZsNXB5tXxdDUkmiXpYCQKTaa/qth6bgyCzQgRVog0Ybzrmxaftvn8elIfH5Ozl+HQlp2nXm8l964i1Y13NX5uSP8IRB6HTNUnaxhVM8NoOjhT/4AauSGdtOW6SSlEjbr3wjn9gOQtnLddaMLzMEczYNbomfv3+Y1hn7ObJl9w0KYZdn5cKddECFEsuDeL9TzamJB7sS3Jhjeqs2fjO2u8vM7pCsu8np+bL6JlHvnTW9vqPC5y9v4PhCvC3/hhkRFT+Q3EA0MOtP0ZdIfrobelZ4ATOy/+YLaOSHuOCLVx4i4ikeGXoK2sKPWnGwFB7pKOlYSPnRB6AUYR/ju5eoA2uHLny+ot8K5ir6FpEywpqJquJPKZToK/DZNAFVWg6zUREfjOKwhoEbnRz6zoAASSWuJq1VBXRiVLFdD3DcYGUpMVgCcdzSrcS0Mx1o5vll0puYIQK0AfMwzpu++ELbTaP6qbqgfgMW3vAFMBrXCfr9m47SAYBOyAZouV0uIceicQx6J2+XIa5enFWG/4xdSRcVulOYQkMROvie4zEnhcD6egN57m+C4SshXBtjL87LH9U4GTAyOlqiqrWLtQtB6F38Cs4+A1DHMvSTKvRUmhabHunvKmqhqCQi
 WQf8QqRI
 WSaVyn2kGYyW01mhtZALPY54/WlpXllKN9WVnPAANI9kKAWaPhFqDX8S8InGOc1M0DDt2jTbEOHafnWdv39H13+C/Yw/qc+D1nTi7grf0MmkZUDWDmUWCYwsaTI6S+axtJrzf1uR9a1YtwpXrrmVnLkjqro8t0RvRnUDr8VoAXpCqVixzxotkfzYxkIH9f8NGQ63EmSFWdqurTnpQxAb5Ic8GduLBcLAWiH04QXW9hVbScpBOJiCjAwmNXoOi4ipYnRuJMmMJ48P1JWXaWLnI4rVHTj/PqRqDTVly1MB6lmNze5YAyjVEUvXVfK7L2b1WHCMZs9Sy+KeKT9ByhRYxcYg+PV1rvfOFPJL7/DAPQIqY0H/NzgZLvjYX2lgWNrtm6TymTXYw5qesxDIFK+fjWJbIdrPlYtmylY3pwwchA2bp1mfbjRCJ3I3hAMqLvhaJeFuq0U+rXUEnGhK3geoA8c5UB/D6VeXktWmMYXSD9vykrmS1/e+Ia7Q+yd1bXKAUhp7T3IlD1aMaVqEnEn4/F0gTW4URxgMr4bcKT1svRxxbVloAId0AJMs0sNHEsdXYQ9Kg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/26 6:50 AM, Andrew Morton wrote:
> On Thu, 12 Nov 2026 18:11:35 +0000 Pedro Falcato <pfalcato@suse.de> wrote:
> 
>> On Thu, Nov 12, 2026 at 02:23:35PM +0000, Jérémy Jean wrote:
>>> MADV_COLLAPSE lets collapse_file() treat absent shmem pages as holes
>>> filled with zeros. It does not check i_size, which allows one present
>>> page to become a huge mapping that covers the whole collapse range,
>>> including pages beyond EOF. This makes those pages writable. A later
>>> file extension can expose their contents after F_SEAL_WRITE.
>>>
>>> Hold inode i_rwsem in read mode while collapsing shmem so i_size
>>> cannot change. Reject a collapse if its page range extends past
>>> i_size rounded up to PAGE_SIZE. Keep i_size_read() outside the
>>> page-cache XArray lock because its 32-bit SMP reader is not IRQ
>>> safe.
>>
>> I don't think this is an issue. shmem/tmpfs purposefully maps with large pages
>> across i_size, and collapsing across i_size is a feature, not a bug.

Yes. finish_fault() even has comments explaining the special case for 
shmem/tmpfs.

	/*
	 * Do not allow to map with PTEs beyond i_size and with PMD
	 * across i_size to preserve SIGBUS semantics.
	 *
	 * Make an exception for shmem/tmpfs that for long time
	 * intentionally mapped with PMDs across i_size.
	 */
	needs_fallback = !shmem_mapping(mapping) &&
		file_end < folio_next_index(folio);

> hoo boy, this again, See
> https://lore-kernel.gnuweeb.org/linux-mm/nwkpojnictbg6jicccpxyfi63ol4tmfajrlx24u5xxoxx7lv5f@jkw3o7j6tlfs/T/
> and enjoy.
> 
> It's not good that this sequence permits non-zero data to be exposed in
> areas which ftruncate() created - the ftruncate() contract says it
> doesn't do that.

That's a valid concern and this is a known issue for shmem/tmpfs. Brian 
previously posted a patchset to fix it:
https://lore.kernel.org/all/20251112162522.412295-1-bfoster@redhat.com/

