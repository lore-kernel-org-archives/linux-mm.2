Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCACF33A61
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 13:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1607F6B0093; Thu,  5 Mar 2026 08:50:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E0A6B0098; Thu,  5 Mar 2026 08:50:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A506B0099; Thu,  5 Mar 2026 08:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E66EF6B0093
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:49:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A5021B65B5
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:49:59 +0000 (UTC)
X-FDA: 84512142918.20.1D609C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E96C3A000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:49:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oH0UVxs4;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772718597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ij9ZQ1SicbX5YaYzcXcuC58JchX9aBxHBrBX4TI2QWA=;
	b=iMMRdGBlegX7hgGfsGUoLb3X12cWMop3zhA/WNskGY47HJFxcCcW6oJvdG/amugWvgorhb
	Iw+AtCI6/Qblgw3T5TuMRKmLXH+RfrlybPXvy6bdoEmoM2djzGolRrkFseIP9K+xRvT+9Q
	N/Z+g4F+nvWpWHksFIyqGRyyA97Wb+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772718597; a=rsa-sha256;
	cv=none;
	b=8KaIuhSzwVfOblOzXX0UXqwQqwmEsPX5WyQ+1dkkReTs+N9JPVOB00Z2FhW9KQtoLAuL9U
	xUnQEglktiFzk2wkU8K5z5H8Cr1Ng12NdBX/PX0AmtQ7Q8QcbsOozNEX8TX5X1QJBXK9zW
	ZxQmN8CQhY6rV+zh0IjeurXsdnNv3/0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oH0UVxs4;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48C3461340;
	Thu,  5 Mar 2026 13:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB46C116C6;
	Thu,  5 Mar 2026 13:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772718597;
	bh=THQH0jwrkcgEmFBbelIzbjWfTDAOwMdA3JscKunt13o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oH0UVxs411+JrTgw2Aqfi06lX96UFFwLn8HhU2unuUYfaWESx4EaoAxv5a/aXFLQb
	 js5x3SCula92ouhUp6X/iksTINxckX1ZCqev7Nb2yVID9SMl04LTTt1RI68vLRr4+j
	 QINbAdIcWeFm5xaR/Hp9/JEwIumpvjdFd+ETtWWHLZEEVujDvFaD3YIYu+AoOHstU5
	 PshSTkqRPdftjziV4KacfRrL+6/9cxQNRPAQKEN6Ayz0wG3/FhffbiHz8T2XWGyNUs
	 dNHd/EeUFreF5Jj6WWHwo2miSP37hQ2RbJ+ogWcjcoH6Br8UTJ/rZtOL70HQoA/wh8
	 3oIR98wTwy5/A==
Message-ID: <f5ce8c6b-d8bc-414d-ac6b-167b59c1174f@kernel.org>
Date: Thu, 5 Mar 2026 14:49:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] mm: reintroduce vma_desc_test() as a singular flag
 test
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <cover.1772704455.git.ljs@kernel.org>
 <3a65ca23defb05060333f0586428fe279a484564.1772704455.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3a65ca23defb05060333f0586428fe279a484564.1772704455.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8gxiaj4116e5szoeqs13m1wjpu454coo
X-Rspamd-Queue-Id: E96C3A000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1772718597-19772
X-HE-Meta: U2FsdGVkX18IzPHz08u3LXwQqYO+/5FNTJFr666uYQvlbLo1ZzazK6qy4faH3H2O+ej3msdTrqzuQ1ixmKQt8DyNcHSeElRZgMndabh6fjJgeado3bfunUjOntkVqZJdxXZE4u5wqQHda0tklDrTZSTJZ6BIRTO4bjIc2gW3ce4ekClhsdiX7T5CNv52V2p2Bbo73c9jvPaAgZM6/0p2KUF8LfYEXQ8swi55gTWCRQz+9xulBtlRO1yb48+Csbr8JqQXSTjG/zhWM/Q+H4ZZD/eInWwEC39p6WrO+SF5RhL1PbROvfMGg85d9L4qfkQSUz2xR/MOMnouYmzXxI6Bd4CTqLv+S0exoS76FcT2XQRmwwH+cO0BiScMPIVAvXNig9jqnz0PpIyqoPEPyc4AB311dQRizttw8QQ4/HV+HzdQzX+IynxXUm36z0gUpX8ODufHZA56Jw0W5L8DW+VAyI7jI4b3cb3+gPS7F8SRXcuk0Xp3TDenu8GWX8FJuWGB14t25OAjaq3S4+UaiZ3GlcA+Rf2ZY1eGN5QPXPnd3JJddNvT2wqcFwTzLz6NQqhcQl3Wad6goIdEQa832IzX83nmCx6o3WAKqAqRc9Wf67M8elRQvJjl6wNV5OxOeXmUoPMsDaCBZGXC33W67W1ZphZxC5WYdOBi1QwpffaZebCqnV+4kNO69GwG1eT3UCpxRqxoajQguetZshJwMaWmIDcUUBRzlcEOmwzWXwsy+HkCgelPAImpnW43kssXkcEpcQfUje1pI13jG3Gm8kuXmSKqoFJlXuw6PziVdtdX/0M7qbB4BlPLpCPqhqZqVEUNad2O5+/+ncHc5uuAgcKF/OxrWBBMC66m7MsWzKrmgBYAeiWt9oe71jWGWF8NfXVOdEK4gySjfss7gQWbKAqFZJTYp/EQ1irKs7l9r+Lewwb0py5w3Va6wUVkXmuq2jsunNJ6Rm710dGAK6TGD99
 mKWki1C1
 lVKUs5Nb0iK1VF5x7s1WjNgx0NuEckbCe5Z3ZWP7cppQVgfjMzxpbtS+wVd4MFdpHseIRk3uWgOtmKE5aTniP8AYD6y62sKZ/k03Y+SC3K6IT+V54Dh65x8USE69oCahRogFNyCono2Oeg8CNbMPZiQ10ltK5QQNNkshyThBE/UkwZUnIdm7gg5njTUm3T+E7QJMvOT6/7hqzmWBtZ7gTcOZGGqy5Sc9alEkaJJzzJhujoeNZFeOzvFdhef/5ORWIOJn52oJjgd4HLWu/YW5xGD4eEOFzQpAOUAP2bA+5XA2PmD9z+IFqlf8WOUbVrXwZUhJj3FlLhxJikYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> Similar to vma_flags_test(), we have previously renamed vma_desc_test() to
> vma_desc_test_any(). Now that is in place, we can reintroduce
> vma_desc_test() to explicitly check for a single VMA flag.
> 
> As with vma_flags_test(), this is useful as often flag tests are against a
> single flag, and vma_desc_test_any(flags, VMA_READ_BIT) reads oddly and
> potentially causes confusion.
> 
> As with vma_flags_test() a combination of sparse and vma_flags_t being a
> struct means that users cannot misuse this function without it getting
> flagged.
> 
> Also update the VMA tests to reflect this change.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

