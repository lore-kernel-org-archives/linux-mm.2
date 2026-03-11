Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB79104950F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086906B0005; Wed, 11 Mar 2026 05:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0346C6B0089; Wed, 11 Mar 2026 05:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D6E6B008A; Wed, 11 Mar 2026 05:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCEE46B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:15:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C3FA1A06D1
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:15:30 +0000 (UTC)
X-FDA: 84533224020.05.D7DC0C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 924A520002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:15:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgDro3Eo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773220528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GoQUTWPs5uJ9sIVTj3JBtc39v4T/2J1JaJMwIAHWnnE=;
	b=noAFQKlYjnUJNdfBILNPVLwss1qTaw2fbd5QqKr2Undpi+XtxqJ+E1mMGpN982pAr6wXOs
	cSs8ShGg9org9AIFrCMKpX9vxw59D7rJSlmPVu9fzg+0nmaS8mOBYnCSBNanqmyBr3xNdh
	s/c9/vdE2vp3pioAiGT8atT/F9+eAgU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773220528; a=rsa-sha256;
	cv=none;
	b=qR7MHW+3ol6tP4lixOX93wOqQkYAlvAVuXINdY58oBDCO8iRRqGKG0JqvKfjBuqD/A0Pai
	l9ZZDHBD0BadImtyxhFhuCpTW7YJKNDT7yZIkHl4/5pUz8kEfqB8DHpcS1FJZnEEQeipjP
	s64M08iCIPIIH6TgQsJtv+1tNbCtXfA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgDro3Eo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B51E8600B0;
	Wed, 11 Mar 2026 09:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCD9C4CEF7;
	Wed, 11 Mar 2026 09:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773220527;
	bh=/qi/E3sx1wLUyctUK7y+OHXYZPNKh6z9xCAoPwaS9tY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LgDro3Eo6GuEp/c7KpExTwow2lUTl/Pn1bh3kCtPgx5EZkzvkzK56JY3zwHnUDcCc
	 2as2PvShmmr1XG14DpK2Vlg+JLgJPDOEbIdyLQiZA99gO2VhR6aNobJIyS0CqNvQtn
	 yBA+KuKdx+4dfgWg9peWZmhGw4/QosQ2PPXaLIeUrGAHySdhxN3QZSvEY8TJQRF4w5
	 5y2vcF8WS6Vs3oTWyB2qlm1mbS5CYuB5pIK+WazvnWck2cAfQHHfFT1RCTg/MOj6af
	 KpqT4L8GJkV64xMCr6wNACXlhye3na8PI6Nzf9xRvk9/jbbFZy4EGpTLuB6A51j2SG
	 LfTqtyCu5LFfA==
Message-ID: <61df6369-333c-430a-bd18-c5b1acae68ea@kernel.org>
Date: Wed, 11 Mar 2026 10:15:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in
 zap_special_vma_range()
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, "linux-mm @ kvack . org"
 <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>,
 Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Leon Romanovsky <leon@kernel.org>,
 Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-17-david@kernel.org>
 <20260309142954.GM1687929@ziepe.ca>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309142954.GM1687929@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 924A520002
X-Stat-Signature: 1bcabnj1uwkmgo9oi4ytpgew7e31n1ny
X-Rspam-User: 
X-HE-Tag: 1773220528-357569
X-HE-Meta: U2FsdGVkX1+lgRaAB2CBFApntgCXWUL3CY3GvI7U7D71iZmg5AVJxgj7058U6fl9nu9WiIPhl7UTuCsFe7PbikbEfB/Vk5CjpRZOTEyraB2b1A0khKZsxON+pu0WwhDLgaiDyjhBBtTX2V6HoKKMtNKTjEISGgQdg4QwsxzeasgUwW3MyVF+qX69Fs1EDNxnY2Q4FKwavp7W0BOlUMPjz9A1s7HY5XJXoqzK3zovJd8FaLgCNXGaEOCVRfe0K1A9Ur79qv8gdEjqqor+ky+GICN2wRJ6udBwSDEJZjIAgGKH5avQRRqQJrpbSWuUWu0pfjax/pck6+G/A/Vs9BULV8wMW6+oVBnUIefUTHtZfR5h5+GsRoTzTr5uouxYxW/Nr0MitvZOBIE/1WzSrgTqgNXTUzjj7M77oZEzwPBHTKcT0diBBItFfIK5a4q5P/UscUmR8lAqsDfnPbNvyyOihb3MvDC4XeS+Y5e9egmhc1C7MK0mZBDHGPAeX/+uIdfXaJ/bks0SfSarrYCqtYfUFM2qBAhGQjhx/lrMPfm6a/v1L1ogDDmYAzYull96KcnHxG8XDcbJ+HH6sZuxdFHqVP5GKB98QWbpfHLCjUZO+ieD/QXVk+/6mq4AO7UJ5SLMK9dkfciE/ofqV/op8ulNJeKVpT0AoMym+MKc5B/gEpuxOUjHKs0gpNAHFs5mKx17twTY7D7wj1zktk3eS6iSPuOLT6+aeBd5p4YhWegXqPOBCChVIZywQhUPgAjNWRHUGQa9xRY4/J7dR2fqkrYnFWHwMUmd12iy6QB6NMUZnRXNqZb/5bC6oddOPAdkqe6HfP2xbHEnlXQHhLHaJLRgmR+no4C7lixBWa51BOr33Md8HnP1rWrn2UgA52ZVe1FTkrp/tqldZ0y9bbcvpKUfpiLFpD2ZIkmJ6WF0EPeuz3iocCvH95Q4Bz/KcURrevNUwK/3d6G8REGQMujPeJT
 JzoSNBwB
 HNy4Ugw6D/VahZhz5s1DOE0GCI7N8Z7okRcxk+jFHLg37B7rjghao25bGAW1KJyT5lJ7u9v0IXGZnqtAowYAQFzDZ+zZjrW6qxqLTh9ZPxbae6CMiZtEoUo7HpXv0CMn7sakAJku60eg8vaumYBuZvM8vN7LPLwm1jfG22i8Zqw87XPAZbW0a8gMlowUAhKjA7TSL67UOKIYoOy3PN1oiOHVg/A4MPId9z6coovK2fwdmPMN5ysSN8JVpwB8sQUCTJgaMRc9t74Ezx9Y6OuLaWB0VOWBnPgL7uqjAPf3PyEu/PPkcgjBfPvA4bxIreRkASzWkfmymaogG+6Kepge7VS+3fC0V2MGPepPY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 15:29, Jason Gunthorpe wrote:
> On Fri, Feb 27, 2026 at 09:08:47PM +0100, David Hildenbrand (Arm) wrote:
>> There is demand for also zapping page table entries by drivers in
>> VM_MIXEDMAP VMAs[1].
>>
>> Nothing really speaks against supporting VM_MIXEDMAP for driver use. We
>> just don't want arbitrary drivers to zap in ordinary (non-special) VMAs.
>>
>> [1] https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com
> 
> Are we sure about this?

Yes, I don't think relaxing this for drivers to use it on VM_MIXEDMAP is
a problem.

> 
> This whole function seems like a hack to support drivers that are not
> using an address_space.

I assume, then using
unmap_mapping_folio()/unmap_mapping_pages()/unmap_mapping_range() instead.

> 
> I say that as one of the five driver authors who have made this
> mistake.
> 
> The locking to safely use this function is really hard to do properly,
> IDK if binder can shift to use address_space ??
I cannot really tell.

Skimming over the code, it looks like it really always handles "single
VMA" stuff ("Since a binder_alloc can only be mapped once, we ensure the
vma corresponds to this mapping by checking whether the binder_alloc is
still mapped"), which makes the locking rather trivial.

It does seem to mostly allocate/free pages in a single VMA, where I
think the existing usage of zap_vma_range() makes sense.

So I'm not sure if using address_space would really be an improvement there.

Having that said, maybe binder folks can be motivated to look into that.
But I would consider that future work.

-- 
Cheers,

David

