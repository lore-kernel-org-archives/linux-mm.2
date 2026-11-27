Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F0A606A334
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 18:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WB3S9P18
Received: by kanga.kvack.org (Postfix)
	id 288146B05B7; Fri, 27 Nov 2026 13:55:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211836B05B8; Fri, 27 Nov 2026 13:55:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9AC6B05B9; Fri, 27 Nov 2026 13:55:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D13ED6B05B7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:55:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A57112027B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:55:53 +0000 (UTC)
X-FDA: 85481803386.12.AA8E5CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 82C3E1A000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:55:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WB3S9P18;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795805751;
	b=uwdbCrdJYA0S5oQFsNLDpvopf14N5XZmTxiWTnNfzP/mY2TVhjG0GyuH/nn4mCEfBCajFd
	93TDzSL9ukcOkRL2mbbl1slcrtbOzQiZpIvZMqxStOqdySSOzH/BkgTtCVgyUddfmM7SUZ
	Vf1RUARh7l5LrqLOtfWq0RsfvuElk/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795805751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kk0P4RjBnkUANQ7BOgGeFQVkoBHRZ4qGLab3lxHDvm4=;
	b=pRlT9Z35+ZkbOl8DPzwBK4A4hoME6Lan+e5qdw0gx4w0/MxTyyAm/98rRDGjY1HOQYJwKP
	0/xUzFbtUumzc20Y3+Qv4R5doLrO9+3zC6O+f7HP9w0x9YJoKPrlHGmPBsUb/55hXtK7uB
	9Mw+nXO9Oq9Ugl0XNrc4u8RbSXU3+qM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WB3S9P18;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B79E544760;
	Fri, 27 Nov 2026 18:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3B31F00893;
	Fri, 27 Nov 2026 18:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795805750;
	bh=Kk0P4RjBnkUANQ7BOgGeFQVkoBHRZ4qGLab3lxHDvm4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WB3S9P18agvkjXrKDgXBdVcq6JGAoKj/Y9IR/h4TZBJzlQD3BQ2kkykmug6PJ4hFX
	 4lQOchnrxH8zl2WR7eExQFReU0eR6nijOcU+EetFP7ENuUDnXnNE5H8X3ZfvOCp4op
	 0jKsDumzQC4tywsGwl3VFYYwn46d8x+TcKa1bm4Rw5huh1sZv3/APrTQBLYwN+v2Jo
	 vrhN7dBTiJRh/Bv/ONbKmxcIltuMRcjHx4BFjU6JWZD+wATwE5cbVIv6OtLSzQRuz0
	 mptppS6nOjVLkHZX3rOpUXSuPJlv8UgwHNtg8XQaJSTHUBA4pILOp8LB/K91Uq+UG7
	 xevJLqjUQybhg==
Message-ID: <43b57ca6-cffe-4fc8-9622-c3e3645d2976@kernel.org>
Date: Fri, 27 Nov 2026 19:55:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: add a drgn script to show HugeTLB reservations
Content-Language: en-US
To: Aveline Noir <jm5905938@gmail.com>, Muchun Song <muchun.song@linux.dev>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zhao Li <enderaoelyther@gmail.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
 Oscar Salvador <osalvador@suse.de>, Omar Sandoval <osandov@osandov.com>,
 Mike Rapoport <rppt@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Jinmeng Zhou <zhoujinmeng@bytedance.com>
References: <20261126-hugetlb-resv-drgn-v1-1-345a6ee7c08c@gmail.com>
 <FDAF27F6-A5D1-4911-BB86-6645272E2BD3@linux.dev>
 <179578806997.38.3754686117717776990.b4-reply@b4>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <179578806997.38.3754686117717776990.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: x7cs71owuphi5juqt47eb38ezs6hq1k7
X-Rspamd-Queue-Id: 82C3E1A000B
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795805751-777050
X-HE-Meta: U2FsdGVkX1+KXbTAEGRxcSU/yic3ewAp29g2FOKEw+DH9EvJKpHxnL0FeTKcnwYB+UW8OKXrP/EzQ3AP6m8srrx7dUwPOleGOXIzs07AQzJ78uz3lqGshwgJUybwf+5KBa32oq9aiB93362du5K335Ts4jguO3RWJfrHWOI2EeIg7dEUBsUFYJipEw5lUx9iMzgvGSw2qC39TwBcnpDm244iJ67Q2pGJvn9FHweAu4lBslOW1tNZwngqEZYe35uwQIGL2qmYp2yWhTK7okTyYIw6NcnOGQhWOk39YiuvVgtdA+rgPw6hkswwvT7oBSMNgESqPIDsZT5upIzyor0dnhIeFuOErjpiZjrQLIe2QbopxZENuuZeJvmr6iBo386D9b824cWKzEhzVWM/Ou8JdQ8ZlvIOXf0PHRUbMS8eoUDx5IwE7IWF3x8ceAuA5Snsy+EwyJsmvcQ8CNM4oDfC1sNJtjPOeEFn7J1NsJR1n+BByr2smZaapDWiqNjR6rEwwpCA0Cc+JiUSiPdLLW1pYxngCxiioM1C+faFPGJYxvDDKbeM04GIKe4z67ASbWJmLXQm86RwmvhYCgTKX9FN8s0ukoFxjbY936ApmKP69mAklkM+kXzhWgfASJgH1YtVdy9P4IldOIQxzoOx09HwUgyZRUU97oBrfQLD2dt6GkOevm5k/v2HOlFE1vi5hoZ4kxcYFylksZDGAmiYxGDpjaHuwNWmSM+SDUIc6jvZhgsa5lx5vzs57f186MOwOImHVh9MbDMyqwG3rcGQ0bSwrQuZZgU7mnX6CrI6jkJIjdTiDkHJmBI3CGrCBYkt3YHJ3759ar7Vbsj+jYzh2S2mzoDHvbbOjHthGITqkK+ca5hzPC8AF7UPNm80vvlNWwSPsCOGIijfL36bXf6fZJpT8i3Ax1xxLwAOjrX9aRYSAGX2gV9gH6xUkEoLjJJyvEEZ6imILr4/c7ZWqjXefhj
 zo9KheI+
 ieBe/0s8V1Ygjek6hE5iKfuXhuMfzQ6WrH+PJmHwrNyhxWBjvFJPTqqJkdjL1LidfgpdpgRAcLJq1S0sygUvIDFQeOG+BL1OSdMj9SVRNcTA98iXc4NJzrm0Gy2TlQp4JvJcOydv+vzoj7xHBpiCFSg0Bw1JrXodh2WBs2M5NM2nJUZ3nBbaR9gRTXJAhhBXcSFydZt6x10FL4CdaaeyugMjd21gEaYviyW/OEpPPqvDxhjNlCiibU7F3OlWhoEBO0cM0nzU3vzPtHN8h8488pC2T22kC2cLqTpoqFU6Bc5MQSlEb5pujGPbotOOiLRw37I/ZKs07EGYulmD3rCCo6xD6F+R198C0yTvtY+4D6Thy4TOUnHNpj/SG00v89+FGU2y0LtLG/KS+yAbGdkOtU32c4oAwoH0x3tMhCmFv0/QbK9TV6zBX5+RETe8H9B97DB4bUul7KPffLJlCEV7fclkqTie7sq9qg4cEljK+Ijh1nhODy7lUI8HdERzZ8qhaH2Gnr/mNstL90eEOgmKxaqpO0sl+hgws0NxGRzyqdnbRIz2k6I7elnKcrxnLY35Wns6VGhn9Vc3JoEvx4rFN+ILwCNNOxfn1uZJM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/27/26 15:01, Aveline Noir wrote:
> Hi Muchun,
> 
> On Fri, 27 Nov 2026 19:30:04 +0800 Muchun Song wrote:
> 
>> The Dragon project itself probably belongs to this type of script? See
>> here:
>>
>>     https://github.com/osandov/drgn/tree/main/scripts
> 
> Thanks for the suggestion! There was a similar discussion when
> show_page_info.py was proposed for tools/mm/:
> 
> https://lore.kernel.org/r/aACaf4_molKromnT@telecaster
> 
> That's mainly why I sent it to the kernel tree instead. Having it close
> to the code it inspects should make it easier to keep the checks in sync
> as HugeTLB reservation accounting changes, so it felt like a better fit
> here. What do you think?

IMHO it's better if the support is part of drgn itself and can be adjusted
with kernel changes while still supporting older kernels at the same time,
and automatically detecting which scheme applies (not from version, but from
what fields exist or not in the relevant structs, etc). Like e.g. the crash
tool does. Yeah the scripts are then more complex, but it's much easier for
the user, who doesn't need to fish for the right kernel version's scripts.
Which may anyway become out of sync because nobody notices, and are only
fixed in a later version.

> Thanks,
> Aveline Noir


