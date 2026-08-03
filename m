Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F09DC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600106B00AE; Mon,  3 Aug 2026 09:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D79D6B00AF; Mon,  3 Aug 2026 09:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F756B00B0; Mon,  3 Aug 2026 09:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22F9C6B00AE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:49:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6775C0693
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:13:35 +0000 (UTC)
X-FDA: 85059546390.04.0ACC5E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2DA2E1C000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:13:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LBnsXI1z;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785752014;
	b=4/t6Zeqqw1zUp+KH8yv1cLpBVSSnNwm/OJRCA/6zwO315QTC14iVi8uHpEf7XWrlmpos1J
	cWWxvOXsEHyCB0msQbNo1Ydz7BKx3ex/pC66fpFsOuV4dBPzE2ykYWvlXZUAUUi8HS0C4P
	4f8BaMppOylm4Ddx4187VaOntRvE2JQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LBnsXI1z;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785752014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avyOmjvyQonHxvBu4LC6bxN7dVZH+praK/SydX29h6s=;
	b=Og40b4exg3K+++dhhT+pwS+D0CJYSLTpm3DygTo1jil196Db5yXUdxGFtpMXq367WXRSC2
	1ES5Cnb0A56IlY9bKvWf8xF1VWjQJVrcwhmajOGXXqMqeABvXSXFV2ki78BdjuVjyW12nY
	0wP0pvIEHqXlLhKNC0yS2eANQtSnmU8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3284F438BF;
	Mon,  3 Aug 2026 10:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D771F000E9;
	Mon,  3 Aug 2026 10:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785752013;
	bh=avyOmjvyQonHxvBu4LC6bxN7dVZH+praK/SydX29h6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LBnsXI1zzy8U5QQIUHC/Mos03wpfdQVKtDBqc4faBMfEsjWNtpruxYt/PNp3Jzqae
	 KDa4U5rsiIS7KR208wO4M5NvFyflHjlhKFi+RpkpEmckGrjvUamhlSVlJaJr6W/RXH
	 eP7H/ibrWz1deWm1abIQXzJDyiclABNBC+rLA4De4NM3CPqtHDZflZbixp/BSq+98p
	 3nAI1BEmHwb93dj27p+qI3KPc6ppCUfNRGlXar3lZ3008Ew1e/mf0DE24XJMjjYUPv
	 fkDBKUNIyhGY1YvaoYvKfLieMTvuY4tBipkAGxJZmbjdblYuU+cwNIiSqbPlmsH/eJ
	 5ZG5Wn8J2ppNQ==
Date: Mon, 3 Aug 2026 11:13:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 01/15] mm/vma: introduce VMA anon page offset field
 and add helpers
Message-ID: <anBpLadvsoCcKzqU@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
 <2ac2746f-18b4-4960-8628-82e87c2140ce@kernel.org>
 <anBjLV4CvmpBzEiw@lucifer>
 <1d84f43f-6f59-4685-bd4d-ac7a724bff5a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d84f43f-6f59-4685-bd4d-ac7a724bff5a@kernel.org>
X-Stat-Signature: 115w778afthz8xfeoozsag6nidf6d94n
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2DA2E1C000C
X-Rspam-User: 
X-HE-Tag: 1785752014-52649
X-HE-Meta: U2FsdGVkX191ttWYfbu8/v/IASCynV32G5xCdYMDSL2z0XlQdeAFEM7iwtvBOuPFLKfJZTgYZeh23zENIk+bYdNmyu0P2vtsl5sZuGoJDxDJ+L3cXA4zjVaS6U7gfbhSFlifoslcsQ7Qpas+g8erNcxhUCj6g3PkhwnZKdCXtgXmMLYrzCYQXcY+DIyqaCQGm9Z2bBnXZ96fin9V8zQDPeRmHEPRkddSIj6tPbwO0Jsm0bRySd3zXbZmL18XMQi4R9ybnrpSWPkvsrvH+sfPJNeoTmGDJat3qVM3PWAwNjRc5oJpk4bzZAyJyMSLTlw/0U14gJrxBdZfIddqYmB40ZsvEqpO3sEanbnd3AKbRaXqH3UXiiyx5fIaa0rS4reSfoH0SQp4KFr2bO4niEBRa2RTzeL05fkO3vcOHJuaL+4mXWxoGk4CA3UvZGoKojFcb8xBPNY+7mbjFbYkKnigq+q8wsVYcTArfXlIIp50qWOfuSiCL//sICGYz0t6aVw8ihn5eCohjR0xsbKDXlQ0VqnAlbnJCxOP2RRdLEOByZmygTdvfG6ugl++TVT0BMV4DarJukgVz9aG8Ctegn19NtNmoGx8Ru4JtRZwMzDTHP+5pUmLcs3B1ZHcmIF/KYIQtDMI3rbPLJS4Q+1WHzEGiY3TUwdmpB+X+eFRIjJZBYxt/XBr9Z/xa9lYh9L5MjX8BUeLsARL+X0czLVr6+V4/3RCoTLxLv2VHSYLB1WF0vXxCFsFaIOGFcNTEi3XF/PMgLq89G2LqEtDI80ua6BKVGe649vF5YkcKz+0strj9leEptGw/Kxs3Dg/NDziL8E46yJtm+MaX8cQ/VyFwHnIq5EHGwudbzBmrvJZFfXgt3iU3wJrcN0Z5jCsiYNyMai2Y9wQ4MGIj4L3W/yLzNWRk6s4KKwZ2U7nacbzYgkfMBI2mFL+LoTQ62SBNmYyXH/cQkGp6Om+qrL5n9fH9zc
 u55aNmEs
 PkxoIuJA2EwXYgM4tls4AhY4hM1crfDryAxB94jQJkLI0svasmIjK4VlWsW4pkRV149x+1CgzTHWnaRI8MyIj+Pxmiab7Qrax2JUzR5LpOXlC1aSF+Jld86QOMZsA3rHGYSzMP7KTg/DFbhWhq4njDDtDq53QCydV7VJxEQIsTYqybcMGcgL/lCpgUiHGduNSsttInETik5vBtytysLUS1wUlFhB7niuMROAgCRPeDzOPPG7Lkq1b7FNFOfJJJxKBNh1lt2ukxDX1lp9cbL/R0uYwxCQtnmYE6GWe1ROkiGSFb1Fsm4DRl8pdiZny0uN4rysU7NxlHF3nt+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:58:02AM +0200, David Hildenbrand (Arm) wrote:
>
> >> The former would be better
> >>
> >> 	__vma_set_start_anon_pgoff(dest, vma_start_anon_pgoff(src));
> >
> > Ack that's fair, will update it.
>
> But looking at the existing code
>
> vma_set_pgoff(vma, vma_start_pgoff(vma) - delta);
>
> etc, maybe we can keep it as is for symmetry.

Sure.

I mean putting start here is valid because you are setting the _start_ page
offset of the VMA, but then the field itself kinda has that implied.

Obviously could rename vma_set_pgoff() too but then it gets churny and adds
noise so makes sense leaving it as it is also... :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

