Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16DB606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ajLm0KeB
Received: by kanga.kvack.org (Postfix)
	id A4C336B05C2; Tue,  3 Nov 2026 11:29:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCD56B05C7; Tue,  3 Nov 2026 11:29:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915816B05C8; Tue,  3 Nov 2026 11:29:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5D86B05C2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:29:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1DE8A8028
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:29:57 +0000 (UTC)
X-FDA: 85394344434.25.6F757BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3A505180009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:29:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ajLm0KeB;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XP0ozVk9+CRaYdZkDjrlK4V/5HSBcJ6GFrBwej+PFtA=;
	b=H7RB6252yCxMx8v6sllQhM6jJulqq2lS8O0OtphfwvcUNtC4sG4BmN7ABn9oSWM5n/SThG
	rVPvrxs90r5RxPivHc+O1PLHtYkFprHseAp5ZLh3PaHsCxIizo19mrTce5C8RK7b5iB730
	6/teyVIkXSJvNgTnbmHSalmDMWv9tNU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793723396;
	b=H4SedVid/+IHPmHoaRp0x/KVLgj4nOYiENFUVYzSU//ENH/cJBfYbQj8czyTbz2nkCI6lk
	j3jKlNlQ02p4ng+uM+Bgmt2MKLUlg0hw4zaUbe65bANcUzA4RRpBIGMkdSYwWU1C+YlsfK
	DDhAoEFx3MtFkw6dTc9iGKR4WcFCTl8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ajLm0KeB;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A58E608FA;
	Tue,  3 Nov 2026 16:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772D11F00919;
	Tue,  3 Nov 2026 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723395;
	bh=XP0ozVk9+CRaYdZkDjrlK4V/5HSBcJ6GFrBwej+PFtA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ajLm0KeBDWIea2Y0ancKBrYORerT1THMaXy4jFvdxErxcwgHfh+0oiYOveUkK9Nic
	 XDAFGUviaQL/b0kNaroGvMJMqoLUZcayGQsdxlhhKJxTYSIUrnZsBKzGU4wv4rNf7r
	 3CBPCl+Ey1fm96csxww1HLjXlVEsssmjSz/rMlAZZgy7+5Nhk2XccA3BneAUCBtfaf
	 2QgZDOqG6J1xT7AHzWRKG9bzb6tKo3BhHqX7f2/GxXJ4qnCbEovQlZj91NtWbCJUGd
	 zpk6sZlD0x7hC77KXkvSqgUw9O6xVoAVxA8jXsTPtgtNxonUYjtEccrALxOXWNnR36
	 dBwXxiyDg6Utw==
Message-ID: <fd6094d5-50d3-4e73-8c09-91b0769476ab@kernel.org>
Date: Tue, 3 Nov 2026 17:29:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/6] virtio-mem: support memmap_on_memory
To: Nikolaos Karaolidis <nick@karaolidis.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@suse.com>, Hui Zhu <teawater@gmail.com>,
 Georgi Djakov <georgi.djakov@oss.qualcomm.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org
References: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ksk6z97iwci3dbzaa9jjh9gmiwow55ro
X-Rspamd-Queue-Id: 3A505180009
X-Rspam-User: 
X-HE-Tag: 1793723396-487417
X-HE-Meta: U2FsdGVkX198R5BMd0kpSYfGzh2deSEZiUEDrbctfNekkYug2DYwTlkbhzDeF/gnEguGKpcNFx404R0lknSNEI/jb7T5vlA5XvNfdLAj67Fdu22E1sEjZw/GUvCHRGDXGfIFexXu2N7RtJuBeZgrTt8iQfz+RZyYmv9PwVTlJmksJ34VtDX1uJOARkyoyIFWq6DffG6JsEoPO/i3iQ2b2+CneQojbSyKMQNNmcwW+tZ0tFJx9ZLrEfyi8qH6YXSrl9zcnyqcALrFLYZF6ZfUsuv+sKWPDf/kYUoEefbk+MhfPG6D4SK/bVDzuCrj1uYH+J8PrhSBbhEONjNbrIPJ8mr7r6aoMkudYFAEsCktH++u/Sb5A6MZHoMV80Ifx+k5qA48NFnnCtB9eoDLzRUgAjG14nPQ89FSeiQXMW6+G5M/8+jx9piU6iCqvgvLxHjjLVUtBfln8pBNog+QegO17y+re9LL1x1oUJvV72IAUJTPZgpFeryPEuhp555Ejw5qLSQPZzLOR5rYYYrKSFiKw4Iyl9z8WWL0wS+yj0Jw5hx4yOsC3pdpY11n7siK0Uy1R3KayHS5wP66dS1wCO4CtW1g5u8uYfmPpdBS7UuagxId1YRLNh+p8LoyUeCW0OkOiQwLM40FI8EwH7Gj1FCId+C0HGyOKQHXhRq9s7AYUeP/kUXjny2PDIcbHJEGrv6IrmZikXSWsu637VHeNQWQFS+GZltSXgOMZgxPcJsOIX/71MdTrIdr01F67t12KE8Bq0ZY3gk4criUr4YS5Oqrr1uvJHkyTQpXUxI88iwRZbbyvxBcsXnwYnNMwkVnFtaqbDEb/xvnEUdjNLsOcYOgSNgKl8u7zIPgI5NvmxHNV2rMKAFRfHoj71wcD7QMMwdwOWml/uJrdtxc3vDcqiy03/5ojiC3MZU19M5KUFZ4iIVszDHps4hCLVvm/RxgkUa0ij+i/Ic5A2SmAzJkjyf
 Q+7FKLJf
 DaxnCHE+B+Zs6/DPeI3lT8KnRdSrr4GiSoxJiy5ZeTpllyXSMOWUR7f2Cg3Hj7/Pkd3c0yKkiICptoiABc/WavSYDV4o/Q2cRzYmiYu55UD9wABZLEwikmPIZ7x/fRQb8fYHyTMdN7BF3EhZ+frLRjr8Z60a1jUYGe2hJFGOIlNQbAocJ2iJRnxycUfaDp3Fzg1nO3HLlFRuaNX8II/I+YhXwMiC0PGS2iIpueE05R6hfegqtfet4uuQC3pKeWiAXqiZwVG6Kxq88vntjMtWXBXWyImPvZvcmIMGaDx6u2Z0vAVmc2C51087oew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 10:50, Nikolaos Karaolidis wrote:
> virtio-mem adds memory without MHP_MEMMAP_ON_MEMORY. With the memory
> onlined to ZONE_MOVABLE, a VM that grows to many times its boot size
> can run short of unmovable memory. I ran into this while working on
> a guest-initiated memory negotiation project.

Care to pitch the use case to me?

I'm all for making virtio-mem better suitable for some workloads, but my time is
limited.

Is this something that your use case would actually benefit from, or was that
project already discarded?

Why so much MOVABLE memory, and how do other kernel allocations (page tables
etc) cope with that?

-- 
Cheers,

David

