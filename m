Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 390C2C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147036B00A9; Mon, 27 Jul 2026 06:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F86A6B00AB; Mon, 27 Jul 2026 06:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28FB6B00AC; Mon, 27 Jul 2026 06:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBDE36B00A9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:16:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44CF31206AC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:16:18 +0000 (UTC)
X-FDA: 85034151636.02.9DCD0C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id A3B7D40002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:16:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeXLGKxn;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785147376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPvuz+aL88c21S8YC4GLGVYZg37SgTBgz+cPgSwl5YY=;
	b=ltSS7qnjSS03SDh/+IrImpUEK5EjKLZPn6hMbTXApAm4RdAgUDx1rc1TbtEkuS3kmA3J4N
	Iwq+GHJgIOzs212ESJUx5HgoTfY0Y/cEEKGl78WjCb3sGsVcJl39rPlpqwYft0Hv3ouAwB
	eI9cUSLcR8WWUlyrcWI41COWKyQF1YY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeXLGKxn;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785147376;
	b=5ZPvShrzNjj5Jw4/L0XhU4rHMmi1XCMCCJtEZYPwtONzpXcOhb0563P04nJXGGtXyye8MV
	Lb8cUyYxv4yyWaA5lbKMKi0e+tDr1VkGjyWOeK+lnEPrQbKiOAh8vBiFkAUUBPuCd2zRKk
	4mb4UBKksWMZSk4mudDS+JE8C30tYsE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2746F601ED;
	Mon, 27 Jul 2026 10:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0021F000E9;
	Mon, 27 Jul 2026 10:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785147375;
	bh=aPvuz+aL88c21S8YC4GLGVYZg37SgTBgz+cPgSwl5YY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aeXLGKxn+RhuEpjDFbt/ECV2BxYK5diVi7xVn6tULU7vDF7IK7Nil1nVqd/uTLs0a
	 j54JY+fifjoQHmXB9CR+jCM4rvP6pUcAJpAIgW91yTz1VWA8cFXD1DZoURmpEUqlBo
	 Tq8KvwKyQ4fOEXf51Jdb/5lt35sWrjNBv7X3ON5nEjg++ndjFL8fdwh7RQt7DAiufK
	 NEu++wGQ+modaUWU4wmPBGb6eEqXBiiWFcOGq4t079CkA4z0301GVt3RVtw+hHhHy4
	 jlT37q6tmmybvVR0a4m6cIFpSFH0potJvfTJYgzoIW0uyrUmfcVfT1diLwjHu9fMt5
	 gbvr2kjjgFHYQ==
Date: Mon, 27 Jul 2026 13:16:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
	Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
Message-ID: <amcv4Q_jxriraFzU@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <amDe_3KFBc9CcIbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amDe_3KFBc9CcIbo@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3B7D40002
X-Stat-Signature: onoyikhgdochngkhsjz9zwtkhhddbhbn
X-HE-Tag: 1785147376-768706
X-HE-Meta: U2FsdGVkX1/pDFswieu2LbjpzCBAaLan/xBNLu36PSzmvbge0ef9ixaA2mWDKPbzcXmSAIhjz/qaQxZ6Lb901BTiQc8v3CNMsbPHzv111P4vMNrt2/FQeoZf0cvQco4TCVg+yjcBp7pKIpuky0FvD1efha5Whb1QDZ3F2oCT0VooIjcQzUCgazg5PRZshws+0LZvBOCn2zBwN7YDEBrYMGj3SkGDeGaFgCYkK9NkljlSxgDf/XjfcMvB3o227N5xnyYgeIPS908EWq8rQoXDqvPOr++jFWyJ5b/sXkJFNKk0PRsmtdybc51Twc53EVXFf87f9u1umw97X8m38cU2IRv49CrAKODHdOnpn0jkT8Ob+dLAtIRhp0CGD13sqdOrQbzi5rit5UnIqWBjrVYgUiUOMmyHV7RdBE9xyW3dOcFJbLSC6Cp5xemrQxVDsjUlNUicZexVvKY8MJom/2UMKecDtUcMSnZLZG1lR2I65/IIzGFCKVMc+gOl+nXQI8mWeyUIJXsVNk7dj5QUqbizYGbRRNqAdfZrLsMa0zf6Grp1WnFOYeto1Fj3rKJaNm/d2hjynmK2cdW3cdQvjiT5Y1X/As9LkCpaaBgdUszGtzS41+RSWXEq0Lkajmr9kQS/ZVpqm0r0H5CWeSM77XCbfrEdx68sIckujAngrEmgF2oIuJ8usD5Pty3mf0jJTiABNaT62bO2pTmmuw25wScLwOjtqZSESlErCcstc+M+O1TqbScwIze2rn1Y1oqdEDIEb7BWMpROU2zjpHUm5lz+b/brmuYIBRVH5UeLIMDg8dUe8jd1Hdl4qOAeVq0Iw7uBMz9Msn/TdtZs8tMR4RKyMllAOLdeyL11vkTpNgM5DtTIL30J35+nYk4fPmQOkxT7wsFbIRr6hbOE33Pgvsj+B57/CFURdpdxDvoI+V8vdO1BUe/ElkJQjXmkAlPIUYhXK2OIY6B6xaNl/gN4tLm
 KtSDFe4r
 Y24mPnnIdLTlkflIQ8WH7x6358B1ITYVbli4V4LbTkfd+GwJPcwWcZbVOAIYmyt5NAnXlENtL+Z/qFOo6VXFO5s9yo20LTpEtT5bP7l8NrpTC5fLfymX4Lbq5xb7O0qEsjq+SbuI74BBw7SwB5A4JfeHJm7bZ7G+0wH/WLzzaRZoxShtfesmhQj7tGfLn7m6Z9UHXMb2FkTcw+Tl2ENse+ic3Om/Ln28rjy3nF98V1QoubQ7kv9iAfSBPhYMaXm8oayJx5QsN9a3eJhJkAmC/g8GlEvuN0oqFsbtZqGJI2NrKadPu56uL97QcDeNS8sTRfPP0rvjqvM8foAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,

On Wed, Jul 22, 2026 at 03:17:19PM +0000, Adrian Barnaś wrote:
> On Tue, Jul 21, 2026 at 07:23:23PM +0300, Mike Rapoport (Microsoft) wrote:
> 
> Hi Mike,
> 
> > Once this settles, the next step I'm planning is to convert arm64. This
> > would be much more involved than loongarch and riscv together, so I
> > didn't even aspire to include arm64 in the first RFC. That said, I have
> > a very ugly arm64 prototype that rewrites arch/arm64/pageattr.c to use
> > the generic CPA infrastructure and replaces the existing implementation
> > of page table splits for systems that support bbml2. But there's a lot
> > of yak shaving there to get from a PoC to actual patches.
> 
> Could you share your PoC for ARM64. I can help you with that and align my
> execmem rox cache for ARM64  changes to the desired shape of this API.

It's too ugly and more importantly it cuts too many edges. 
I'll try to bring it into a better shape and will share then Really Soon :)
 
> Best regards,
> Adrian

-- 
Sincerely yours,
Mike.

