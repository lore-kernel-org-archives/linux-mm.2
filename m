Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E64606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FFFc0E0O
Received: by kanga.kvack.org (Postfix)
	id 30C036B0A39; Wed, 25 Nov 2026 09:40:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD0E6B0A3F; Wed, 25 Nov 2026 09:40:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC316B0A40; Wed, 25 Nov 2026 09:40:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA7236B0A39
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:40:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86182A0E92
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:40:16 +0000 (UTC)
X-FDA: 85473901632.26.391233C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BD4354000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:40:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FFFc0E0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795617614;
	b=LapWXxFyVLtDrIaY3/KUdnRoJ7pZp48B1Dn1AcPY772yQAYYcj/buro4VjejZDCW97Su7e
	isJaOSvPknOdTGAGqFeRLcpP/V84Qous1vhpm+tBpel/8zmxnSfwMXSEsMURQ6xum8F2Ug
	zO+1sw7r8axVBpJ3tgrijIKhtig9an4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795617614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XSIg7ua6momXpoo7cMrnHxsFP8Rs6WyWvGuAYSf2Xc=;
	b=0H6HvQWQVhJG1h8ygNOIJ/Eqm3dwThwsqUX0tIJDCp6tenPaedmantsxcQpug75Du5p3Uy
	xQ8spo46CpoORGuyHc/syJxAaNpkDlSemx5vpFZYKkTWcr1jI/y53AS7cVuZBCX0bUS6Ge
	Lphhhm9fvngnl60YXUSzSjRCQSrbvKY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FFFc0E0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4058D62C13;
	Wed, 25 Nov 2026 14:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC5A1F000C4;
	Wed, 25 Nov 2026 14:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795617613;
	bh=7XSIg7ua6momXpoo7cMrnHxsFP8Rs6WyWvGuAYSf2Xc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FFFc0E0O+7iq9lDrh1yiGJu47ytobVDxLjBucl4vHjfuLyeI4CRgyPJ3PywNt8HnB
	 biuiLsmAEsT/LZBFSkb/yWGhEZ0leaiBzXrPRm/63BogOSbsQ7VqwBct5pcI6kFlQy
	 OhBkqepdLxKVH6WSArXX9R+9HC5KVzEDxpWW62xedzq7KkispmzeTlCYoKWXUxWbCM
	 TG0n6/V40+eRqnW7qv95XGv84FhUE//tNIqpyXgYSoKrv8QvJEVFJbjaonwaoEcydz
	 rXq0Lf0Fla0DzmFyF0tSPJ+9S+0qHdxXcRz17qTeyOD8Vr1lZL8+pd1xWQVWDzgk2S
	 5cmX+d+Rie4ZQ==
Message-ID: <5f9f68d5-9a7c-45fd-a4b2-5736ce20831c@kernel.org>
Date: Wed, 25 Nov 2026 15:39:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
To: Christoph Hellwig <hch@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, John Hubbard <jhubbard@nvidia.com>,
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
 <away88BuU8ibcTA5@infradead.org>
 <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
 <awbv55FryMamHvVP@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <awbv55FryMamHvVP@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD4354000F
X-Stat-Signature: o418urj6dbp719tku83hts8ismz81gca
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795617614-540312
X-HE-Meta: U2FsdGVkX1+xVuFfU85Ddrz7zg323csmk+D4COBt+3EROGr+CmZD8YQGReNm4oiRqE6JXnFVCVU4Nz9ay9DxXjzlPMrlmkyP4Iw+d1qWwi865shvZO0okhodo+16Aunh/oEfXDVmnjEtL8Bz0k5Sbhp5hYNWG3YfQWhHwbds2iV+wlQ58Xn6jg4BGXZZB8lZkdZnc8wcYjvbSfJm1sWQJX3IgpEF3MANgQCOdly/+Xxi2T8xDuvUNP0RY7izF3hcaBCL7tC3WORMf2tOEpjCztDeg0jSI/arqAI8g9JLxcL9oVbsW0J5WTrlbViX+Qa4ETeFFxWwEorMYK2U5INwScQjhY7pftdXFJ1V97c4qSmrrNvXoklZjy2Q/BgBGTkaF7DEofHGQHqjaeGCXG9YmX2eC6NWVow89kQ9aeBHtH5J3Lv78Ij2/zotoewWpxG6a209cZ8CgTAfdFZ+ssgBJ9Own868IKl+4E+Jn8TdFcq74YgmnZMOE9BmZr8ej5J65pVIFKmhKYhdl+OypkajXs34x+xE9bTz3izkkTwbFbEsPDb4oYHi/mSFAUDgRcFNlEd2neKgMirKZ4oDGm0iOz2sSDmhonv/HsQ6QR+h4QcCCESmRtIkpUUL9e4Bi2ToMqjN7KTO6l2XIXGI2NnFpUhAfsNFlCP6MT1tQlALQcgR+s7Uows5aY6Ix18FRMDmTBDqiMq1HwNV51BLWoG4F3GOmZJbSixJq5lKpKyEFz3ox2l6E0OJLMfE+yjx8/DUM+wRDb3a5a1Ssx1DUgJjCBOrXeouLb5Qgn5njFIXBfTVhLW6SgTSfXlsetPYZtHjF/x2HI4JZzood0fZW2xso2O5oFmJItOAL1u/vxbL5JODe4sinOERfKd2SzncYPA47CU6rM/hW/dF76Zj7m7il2J2GLg9m6SMdprBro5pFdOpDG/SGBiQwqwDGySQf2UL4Cfz002JwtPRIoNHESF
 zh+68VHh
 KppDCe03q83oiTiVb2M6otTFZ20aJC/T//lUA7QWUCHb3NdkWZd1G8PDJTsFb+uDNxfiBsbYDCtnzPzYswOEY+OgkR4gbWcrb9CXzb+fK5Qwuok2vHxm4o2Vuf3kJjI5WHf/YpPOUU4pRAhS+g/TKaIMTRmKJtAi/Ulg39QbETqBc4a+mKk2yY0gj0KBnz3IJI8sGUBt76xFMCKK4CTN7e7m4vKsFyfi6A50KTNcAAYHxCXObRNMRhJbWh7YdaOh6mD4OOOdNE7GSXbKQRdVQgcypGYbB79aGTCjt+guBaTuY8A7YSJ5pVNE/Fzi3lt81LtV+0Hrp2l0bD4tOZkkctTDt3eqB3wcquavmSHUo/WyKiSsromo4PhonfMrlS8Y+vtX0S/t5cxyOPVFd5HoWgxRXZPIdxvtnKR5Y8/6XSXv/8TIaAU+tR8lAvGgVKxWecXI4cy/BnLs71wh49LoYlj2xXkdCbCsua1tiD8+zionzUqeDwCs+O442zeHiKAD3CV9Xd4pykh+d2hQn0ASuPEzflw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 15:25, Christoph Hellwig wrote:
> On Wed, Nov 25, 2026 at 11:19:18AM +0100, David Hildenbrand (Arm) wrote:
>>> I don't think that is a good reason.  For file system backed VMAs we
>>> really need the pin to be able to do someting sane, DMA or not.
>>>
>>>
>>> We need to, if not for this series then for all the other outstanding
>>> issues with GUP writes.
>>
>> Cool, and I agree (that's why I placed it at 1).
>>
>> But who is "we"? Because I recall that "we" wanted to do that a while ago.
>>
>> (I won't be "we" ;) Pedro, can you take a look? I'm afraid the fuse thing might
>> be the harder nut to crack)
> 
> The collective of MM/FS integrity interested people (for which the
> recipient list is a good proxy) plus the maintainers of the code
> still writing through FOLL_GET.

I'm afraid if we don't throw out names we'll end up in another 3 years with the
same result ;)

Thanks Pedro for looking into it. @Pedro feel free to ping relevant maintainers
when you struggle with the fixes.

-- 
Cheers,

David

