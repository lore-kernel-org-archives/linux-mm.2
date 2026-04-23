Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43666FDEE3F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 18:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5156B0099; Thu, 23 Apr 2026 14:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75916B009D; Thu, 23 Apr 2026 14:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DA46B00A1; Thu, 23 Apr 2026 14:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6FD6B0099
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:08:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F5F5A0432
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:08:07 +0000 (UTC)
X-FDA: 84690604614.28.13B3DA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id ECFF180010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:08:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hAP3ZIAR;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776967685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTyz05cN84VAyj7t55vPTNR2jBwrLs0b2GxUfIxcqIY=;
	b=6QZhMJMfQLw3EJew6UNo5HrkYn7dPNVUBchTY4+imVBVH+tPBD2Qw/cr8I5g8rTkgWMLYL
	igkZl9E8Ef8BodDtt7e4SF+oJKkhq8huFkQfkXD003khDViNDBdvi5ZKKSdUQtbFfTzGPL
	nzzp/CeSzFOH2DKmQNXOsfCTr6z/4hA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hAP3ZIAR;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776967685; a=rsa-sha256;
	cv=none;
	b=g2w5U6nE/J6j3EZlt/n1VsIOweislr52c5PKg5xE45wwrfSM778vm4ugjIVO88np8lJs1h
	3vQ0Ps9HXML1ciKz7l8IW6q1SWc/qn0+PXiRNz3ddCgoHeZDGRxlYAzI9HWtrj1Hvagi5g
	MbtCs+Dm20hc4a9QcyGmNR3lEt8x6zo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F12B2443E5;
	Thu, 23 Apr 2026 18:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55978C4AF0B;
	Thu, 23 Apr 2026 18:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776967683;
	bh=fUtnL9qRpoANwM3bPHlOiGowL2i2i1ePLUkXdrCF8M8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hAP3ZIARBqueoN9RFilIOZs+UJq6a6x9Enmg84t8Usw7oQUBeSKkK4ZPIb7xzSUYu
	 oUIsnNj65y6jrspk5WdGMHIoY5kg4ytXH1NL33s66LoxvcJvd+cx8tdqpQBX93pZvp
	 LCNNdUgwNNPyVaZ4S7d232awap213vIhzXg1e+DvNFkUksTZGXboF1Xax3jdyoNbjR
	 jvLeaT5nf3App95sC5MiAbOi8IVTGruuKLoVADY3xUDaQqAWXrdU8c2Wd56lVfyWee
	 wSkDxYDdmdrZizKwNW0eqIkLU1akChNOaQts8wFZQ/SLsBX7u57LnVxkkFu7Ezv5N2
	 Fi7VP3VTfO/UA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 618A6F4006B;
	Thu, 23 Apr 2026 14:08:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 23 Apr 2026 14:08:02 -0400
X-ME-Sender: <xms:AmDqafKne51c23t3lOUfwu3m9Jat5CujNgYxp6RC3pVv8n1E5ApPhg>
    <xme:AmDqaSaPnjQM5JuaZTSQ7uK_5VTA28rKQMlnqvZXZWf--t9BbghNabwV-_s1AV9Hx
    3AREOoCahoWWPLLRniuN8x1J2BrT2C-zrldhyy7PEvNwOT2cydEMw>
X-ME-Received: <xmr:AmDqaT6shwVvN1bYvTKiFRpp--F0ku9VmqAT3BGObH8t1GaOQCMYWgum0DBytQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeijeekfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeffffekgeffjefgkedvjeeggedttdeljeekhffhudeiudfhiefgudeugffhheffuden
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrd
    gtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    rghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehljh
    hssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsg
    grsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthht
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:AmDqaTJDnWhOA6Lo5VS3-3zpSTgB3bAOxPGZpGcQWjdEIwFuZdcZSQ>
    <xmx:AmDqaZY0sSALVtS7asmIB8MYX0nPAO4sjU53qds5bVXfXSrKC7Ur7w>
    <xmx:AmDqabxGOc2JRHlMYEDYv15bQ-MaKvilloF3PHIY3GW_bvq3v5r5IA>
    <xmx:AmDqaVUM8UDa_Zh5-pPT75bjmmW8iNzLWo2YmuCcUZxlgN1lsXJlKg>
    <xmx:AmDqafblfb_m5kSp-CjhTquEbv5wDlCyHGQsZxMnJDje3tAR6gHC6Kz1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Apr 2026 14:08:01 -0400 (EDT)
Date: Thu, 23 Apr 2026 19:08:00 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aeo5IPpQi7onyjTF@thinkstation>
References: <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation>
 <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeoxnuGKO3uqS2kG@x1.local>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECFF180010
X-Stat-Signature: s78g1dwb3s59iqmpz9bnugmpn6jtwnaw
X-Rspam-User: 
X-HE-Tag: 1776967684-197724
X-HE-Meta: U2FsdGVkX19HZqSF3s8VrwGcrCH8Fw6VH4cWhZLS1P4aKQLGS6QdzGT7e5Up04BzdAWUk9D9DOknyKi85/a+EhgI/cgF+hjSfUt2eqpp52htJYGkeJQSAIpjOX5A2u7iDqKxMYv9r9m45s9r49OY9hHmgq2qXcPpJRzYBxZaXq+KfxGOcpXQWK9woCHhYX+kxzj2b9UbnBMLChlzs8O9Rv+mQSD1J0BgXNm0LVLQAmnWK2XWVyV3abX9WHw48rtlUvJGAgAgUTbi25go1IFTiPq8rdWCek7XSgcOLhKdpT7TbgzZMb+uCuBXT6RkYQFJoHn2X15WAvzQuZJJNz7zQR/hfRzi+1G/KgOBUvRs5q/iH1bCWQcY7wswZ7Ak9kVGR3MIWVrNK1HF282QQtPtjW6L42aE8cRdGLcI9mELR2KnTRm5ytHt99DtAN8qCoNK57w2IHixEs2KvuEiQMLEkA9qvjbR2nfmGEnk1VVo7KYMC/UVIUbpz/z/cjvDECGhVYoMv+CDYHB2WQucvtESU6Iq3M8Q26ww6PiVRm8WQJAtRF3QUsLa/+IqOYA6H5IDiycErdE3urAGbYiSPPG3S/YlLU220pmzdxAsEteQL5KBkWWGFHKLTmJ3URTq2rZMpMLQsdkWpNLHqiNY7YDk3hW26Bnwjke6xkU0Ns69bDq3402QrCobTKYzLgreQeqgkvwOjuVJHdBAxvs53R/AVkMk90T7AIzfQpKib8ouzdvyhC5suljz3p1DGcvs0+eiMVcflTRt9MC2YoWQN3OAZ5XoX4E7IP1fisMOGTHyiJFIdb36eY+pezt6JgaWe9q//scYImNby2l3lQlprhtWAHV68S1+Z7aw+yk7VId2Z3E6jY/52naOEYX7Krjz9PuIkWnpp3s+z8z43CuFLdj0051b89Tzu3J8bmRlO0WWN8rNYCyih2qTd0J85dxG/4Ru92LL+ap/xqevhXIQ5hk
 Tm/sZbby
 VJpp1QJSTu1OWe8y7z5OA9efbq15QJK4PEDcHIKsjrZQP1mJgW/5czW+i3+QvFWpnhtxId5qbdaAMaSsvrZeHV+E2n0IUkGQ3fqkysFG6xe49yusOlI8KtqchkRMQJa1y4kDmcEwXBa3IOqyKfM78TTg92gCeRDiZ6EhckqFJki12UELYtrYYO6EH0xQ07Nl3RNPQLH/uPY0V64jzSY1OMxsrh1VyaxBNkKT2V62OgMqzHz1fpwVpPTNkTn8QmlZfIBrnQGeBlP/78Wyq8TVDUkyb/aNA2F1uW8NqDTQ58mdY7yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 10:50:06AM -0400, Peter Xu wrote:
> Hello, Kiryl,
> 
> On Thu, Apr 23, 2026 at 03:27:11PM +0100, Kiryl Shutsemau wrote:
> > The patchet is pretty good shape in my eyes and will probably drop RFC
> > tag.
> 
> I still have some high level questions not yet got answered.  Do you want
> to answer them?
> 
> https://lore.kernel.org/all/ad59TxAHNwFWH7Cc@x1.local/

Sorry, reply to this got lost in my TODO list.

> In summary, it's about:
> 
> - Whether we have explored other approaches on page hotness tracking

So, for read/write tracking we have clear_refs=1, page_idle and DAMON.
Did I miss something?

clear_refs is process-wide hammer. And you can miss a hot page if it
races with LRU rotation.

page_idle needs rmap. It will not scale.

DAMON is built around sampling. It is good for working set estimation,
but I don't think it is directly useful for eviction decision. It can
miss hot pages. LRU rotation will also loose info.

None of them gives comparable capabilities.

We also need a mechanism to atomically evict pages.

> - Whether read protection is required for an userspace swap system
>   (e.g. did you get time to have a look at umap?)

I looked at it briefly, so I can miss details.

IIUC, in absence of read tracking it doesn't collect hotness information
at all. The eviction is based on fault-in time: the oldest faulted-in
page gets evicted first. I guess it is fine if you don't care much about
refault cost. Like, if your workload fits into memory completely and
refaults are rare.

That's not my case.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

