Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E25606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Jc8DaRNR
Received: by kanga.kvack.org (Postfix)
	id 452676B00EF; Thu, 29 Oct 2026 03:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403906B05B1; Thu, 29 Oct 2026 03:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2306B05B2; Thu, 29 Oct 2026 03:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 045F76B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:31:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78AD11A0314
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:31:45 +0000 (UTC)
X-FDA: 85374844170.17.FE27C13
Received: from mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1EA9A20009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:31:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jc8DaRNR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793259103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SjP7vXEfBmu5GFwxYK7lYChg0d8nniaqmFaSK+SgEpk=;
	b=2vD9SIlJ8iv4jtf7DS+F9mV4uSnUPauptMlwj6iSPZVTnzWt+X8aoSgarKZGzgA7kWEXgd
	phmIB9Tdn19RLiOEB978ZJ7x0IRmrw3lUmJ+bF9XjV54isxGMcwcdRIEVd+wGTAooQpmJ2
	FP9h+O36D3cBSgLQJwHfPysNEk29ViU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jc8DaRNR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793259103;
	b=f1rd4Q3fhiC5DX1wvuvLOOD6c0c3lFm7W2X9zTlPdCc5Uq04VkzQkJw0GEHLLT038OBAK5
	wAIo1J8L0tKwqkVMDF0LEWO5KqLeWg5tWJLt3TdaXjjckmeDv3+anMWgRX5fvWJFSUGtsg
	ulrVG8P+GlEI6829wJY47gUHtp5yCY0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DXEk7qFnkBiqsaHKOXTg9XIqQu7fTyhLlV1PlmWC7w4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793259100; v=1; x=1793863900;
 b=Jc8DaRNRuV7sUsRRCf29I0aef6P7zPJYdi3W115kdfpYv4v5EgWorsqy5pjSISuh6odkhk3x
 dXEoSiVXt6tvM2W0GxvQzDOcHJp2eLioFEW60AAkr4mjGrVEvOsK1ZqZ6w/hUSn4lBb6BHufaTe
 iTEoujkDldKZ6aWbKnyx4UKw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id bb58316c57a2d4df;
	Thu, 29 Oct 2026 07:31:40 +0000
X-Mizu-Trace-ID: bb58316c57a2d4df
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261029071206.19059-1-trilith.zheng@gmail.com>
Date: Thu, 29 Oct 2026 15:31:20 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Pankaj Gupta <pankaj.gupta@amd.com>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 Ira Weiny <iweiny@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>
Content-Transfer-Encoding: 7bit
Message-Id: <F2127C8C-BBA5-4AC5-8F12-577346FB7F31@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <20261027065723.66564-1-trilith.zheng@gmail.com>
 <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev>
 <20261029030511.12004-1-trilith.zheng@gmail.com>
 <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
 <20261029071206.19059-1-trilith.zheng@gmail.com>
To: Yilei Zheng <trilith.zheng@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 1EA9A20009
X-Stat-Signature: cnru3eewn95h3r5h5btbgskek3ybtq4o
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793259102-426966
X-HE-Meta: U2FsdGVkX1/VdXFNyttFeezJ12Tp3oIqWu5kIc8khEWsjewDeYjrMe45cTdMzkno0yW+nT2+UQOiTaBjxttRG6OhfB6F9s0JvnG1D+dx1UOJWy1SwHBVEa2BW4QjuvUtpA17bSk0Tg4fkVezBx8Lz2hmZDkF4GSCtOqIDTIfysIa6d1wm/fwiZw99aYxfYaDRnBZmnsmoYSclVTx6HtYX8ZFjE7CXGGfnEDGOpO0ztYL/8pRvYAd3qUHU9/K4/XPfZLsfsOQB2yUfI+AlWGDfKqAAmgtgacpu3B6UwZAqIiusuwVnl82sHbggU9zAGkc5K4WvaJL/oD1jhn0sRDZ4e6MKQls7w/j6+tGfSDbyzTRP7hP3BuhptoMF+tRJLCgOilAJDnovlaZcdam/6PXBe+fCuEk18yrsNYul0UTLVJz7C9fYkGQn29SIS0fov5nDMoj3hm1O7H34Lldw8lbB6QKV4kW0Qkf73CeefGitkr0IWcFmk84dirWhajQRp3p/wR6dLa0c742J0zW/PBh2jbbtFlqRovQUXLYT5rvFRSqJZu1rBI5J9vDe37JPnIKbB3C7sOrJfqub/xY9fWA9btgc1AknS+EJkMvjs1/9fb1JyraiuGPlg02Sg4Sx6JdaMMpa0RP4P6+llwGLH+Kotamdjfh/n9fLK00VSE4lK7N9BzlnFj0QS9jTokxxeiOG2t2qhaFe716tt5aGHnVfmXS2Snicjn9Pgq4XBawZxzPJxeNy8KQqcOyBrLPA/Vz19ULhSQi2uhX0DI3U/i32ydtTDUJ7AfgpZzW9nV3gpNYvb1qOi61aUlM/CltWqNmlHY7X1l2pmd3JVxmHpFXhzSv++dG+ScJ9ffeNlMQj1PL5yrExd4f+xDQMqdrNo0eh3tDN+GbzAyZu7nXfmEWhCA3dDijGE1pH83a/6orxdvXHwaGei67y17t4wqyVdfvWnB6D2DxmMS5nRTls5P
 htqUnYg9
 SrjXAlVO+/pLtieTGRWr/5ReYNc5Hk9iu7fFI4kChzTNxRmNd8bE0GDmY5r1zIU/61kTws6wgGePKj4xl8RlMkzamOK0nqy42Z8xFdbvRJfdP4q98DLIuviWxhZaJaRT0HdDiKyhium/AiAn4wbo9HpCOhVLi9YGTlsY2/3zexGaAtyPrqLP7vQ2qrPk4JFBW0THOw3CaUZQZjW/qlPmclQTMP/+1n4jMLWorUcpUAJeeqLN7pIyKHRtm0uvibPzjYQBXzDWXyt8+UxZwTN3+fLRYE5Ba3ShPbjDPwZdKe0yWS39SbGTYZXhJ2uLIsouvJGWbgVWuHujZSiajZEEy3Bt2O0Lc7wpt7m3Sw7O/T7MnXrE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 15:12, Yilei Zheng <trilith.zheng@gmail.com> wrote:
> 
> I forgot to mention the tool execution case in my last mail. Those
> microVMs start, run a small task, and exit. DAX is there to save
> memory, but the vmemmap is allocated for the whole image. A 2 GiB
> image pays 32 MiB of vmemmap even if a microVM only reads a few MB, so
> for those microVMs the DAX setup can use more memory than the same
> image on virtio-blk. That is also a case this series fixes for us.

Thanks for sharing. I think in this scenario it also saves boot time.
I'm not sure how significant that is, though, since the number of
vmemmap pages isn't large enough to be noticeable.

Thanks.

