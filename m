Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05185606A91E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ewhSuFsJ
Received: by kanga.kvack.org (Postfix)
	id 027226B05B9; Tue, 10 Nov 2026 13:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4476B05BF; Tue, 10 Nov 2026 13:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB1F6B05C2; Tue, 10 Nov 2026 13:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B69A36B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:42:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51873A872F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:42:11 +0000 (UTC)
X-FDA: 85420079262.22.7D8C0B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2AC4A0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:42:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewhSuFsJ;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794336129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXb0XqFsaTNiAdOf5/i8uXOS/3ZPKLdeB/CQNiCWj+k=;
	b=tMtpZ1j2S5R2puh7zF17CikK68F6YsUHyjl3e9xcVfP/SGJBUJUzPW/aeQESdSf0z11s0f
	8uKfJzuqiGdP6POJSXT5jgVhXk3PxDH/5wDiYLsf5HptUqAYGmPQtjnf8yyYzQan3uu12w
	ElafF8GvxMpR1to3qaESYFUQGVr0s7Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewhSuFsJ;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794336129;
	b=jkEy1VVzKI+gGLeGYl9lgswEZWV03ZJkw2Xq0BHzGlQMavmwoR6uSG47t13WUfQyImH/R9
	IA8Wlesx/BnI4+DPHXXulNEiqOHqjVBCf8t4UnahAZ2Je2FVBQkfZ/rp48+mevgYmmW5In
	E/x1Aw0m1p/HMbhGRFLSgqgFwVF6vjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB7CD41152;
	Tue, 10 Nov 2026 18:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BEE1F008A2;
	Tue, 10 Nov 2026 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794336128;
	bh=fXb0XqFsaTNiAdOf5/i8uXOS/3ZPKLdeB/CQNiCWj+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ewhSuFsJrfdYDpTE/gonu8E6tArNmgjYOFlesKdqqHlo9EJhF1P0yqHueTRP5fiYF
	 Ci0PPLTIqzrOxvuo8gD28UuP9pHzCo0nU833MFNsrp9SWpnxjoARHj7PplWlGenn0Z
	 nlXV0tuVN13TtMkp/5b1j2HczDsnnGWp+lbFeOCgiu6yqKjgsSLHpnLl3kyOgqRAxU
	 /2WXNLjUDTLy4e0l0KsJYI8T0I/fd8axw2litjT8/xP6fdIkREfxjkYydwsPyPwgeS
	 RfKo451W9Yv+oVn9DdWQ4rHLhf4Id0Tj9g18U04ADRyqpLl24vPEgpOoqgmpUvg+uL
	 FPnjI28WRZbdw==
Date: Tue, 10 Nov 2026 20:41:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Message-ID: <avNlcudgk5N0cH6P@kernel.org>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
X-Stat-Signature: 7sf77hauuy4sm3q54wrwpntfyo4ywykp
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A2AC4A0009
X-HE-Tag: 1794336129-282028
X-HE-Meta: U2FsdGVkX1+pGCXcnDsektK2Niyu60bLjx6JfoL/mrBpkEimNrwSqKzoWkp8KBvxq0ZL6cbI2+rQePNSui56d91/BR6xiPzxvC13DJER+VkEB7RxQcThBjYpaKinOADgsvDYdv6jvrrZaAoWN/KI02X6ujRLYutbp3fW164rvAXi2VmHXxMUdOVD9Z5zxSdJhPt4idCUWSuj788ZhfPKFhUviz9F8ZzkHYnmQZ1kgdHKtmdzcKNcPumeDSsCyP39B1bJYskdyNj41rSqrwJ/xc9d0dw2qtz9UBqVEWTg/YYYaY2pkVZ5WGAZsUf9E4nvB3AxulEhMeC9PP0kDidJ2H/AFVhnnSv5VsduTMiM1x8ls9tpnw2NMl7cVCHyNQm6Jaup06M877hfl3pmPC6keStFFA5f6fVWXT9LugQIHYZnfuFk/C27fS1/h2vGhNdbfip6VzI20O3a0tYLTEuCb8aiyRfV13o+ntiZcxxN6rJglOIStywsZLGRtqc8EgEoC0/sJMktVBD8x8D+VbdptaHVcCRNdOzODoKq7OT8eMgH5pMUkJszCLbU36ftWJdjRbA0TCWzOvwtBOTJPVDvFPTIqoZ55N5JhyGQpQhDFqV5UiXFRXtJ4daBOF+CST3gYgrNpSMaZ0jOqbZPKM1OvLC9cPAkJnGG9ep6gjaTsQJngaS0tQQxUjnzBYMb1yOI9fX68y0VyTxwtyG3WG61d7NmkGjABh2W8yWzjtu93JsWbC8RmzHr7bp/HkOoesvr8WwqmVVUWE2wyg88rwqF8soSax/lrp3iR1UBKi2n7EoXQkV8e5+nRWRkym1PK2oSSQjy+Ly0oSH4UNGH4rYUBHEF/SUEskrMC8P3xvFcxEEmjbmqi8VLqcMEqZOrEknQ6hXPCLMHHqhrqy5BZZfBdZc5mp/32T6WatwgmcOJkWmQBy/5qtyKsXRrQvo+gKyho4sdRf2O89Sk9a9eO9K
 3u7IEhOz
 t79GnmhbQ9t9/ydoqX5YVUFtQhneWWmPba704gVZilMWoZczepA+72VY0ih06NLRjugwmhfO8PVCYLty/vI76kZN3LCbHoW0BZqvKUufd8TQkNr0HNXBcIRC5fWOg4xVMBc19H4NEY90wZRED1D2IzLoA37fFpLPnrPX29kYwJO+4CHJ4TmDb7Bg49FJsZm6dk5u9yfCghJbf3U0oTw9p3omsxW0k1rCYbIhgTwPzdH7BrfUL0ipJmQEE++mQKLDZueM/MCn6cF31wdQT1ZvEhNWNtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 12:03:06PM +0000, Lorenzo Stoakes (ARM) wrote:
> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.
> 
> I have separated the patches into areas maintained by David, Andrew, and
> Alice + Danilo, so each can take the patches relevant to the subsystems,
> for convenience.
> 
> Apologies for doing this, but given the current trends I'd like to do
> something to make my inbox a little more manageable :)

Yeah, I hear your pain!

Thanks a lot for your work, mate :)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

