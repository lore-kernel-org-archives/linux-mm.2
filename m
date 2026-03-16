Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1529EF53D6D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791DD6B0308; Mon, 16 Mar 2026 12:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715836B030A; Mon, 16 Mar 2026 12:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621656B030B; Mon, 16 Mar 2026 12:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 513106B0308
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:21:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF0301A0251
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:21:48 +0000 (UTC)
X-FDA: 84552442296.13.DE29E03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 440F91C0018
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:21:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C78b3RIn;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773678107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfGtXfbpPdwas3QjdGehFHPv4zwj1YVVlL17/dmAXWY=;
	b=DVSBXW4Gv9uMoXDKneR+fyvv8eWhHeB7rhSwTATWFqD3vWoq96R3+5ms4ysPenaqTwuBE/
	XnCO5/Wt2qdxvcX7xyb8CuvrdSluRIFJKciQdUitmdeSOXYBnKRuBqDAtlIEyKFENKWPT+
	gpnTBQ5/Dahr7mfjF19Ghwv/3Wg/Qhg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C78b3RIn;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773678107; a=rsa-sha256;
	cv=none;
	b=CkQ5QDBGmWw3exjlVy7hMBKjP3Q+HdC70qO+uFnwVXth+XxaXcYxDjZmlFQKzvZ6B9Pzh7
	Blc23GkMdpU4eFCOPpsS6W5BnAknJEBx5cYvZhJiiDffHF7MLXz1SzI4ImBi06JH/7tiPb
	hD9TDETMAX89yyGFYFqcILKMCob/1IY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76B8260097;
	Mon, 16 Mar 2026 16:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D22C19421;
	Mon, 16 Mar 2026 16:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773678106;
	bh=T+QCEG7rS4slK+eGQWKuSmiAa6E+o4G10P1NpOZ/x3k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C78b3RInQ6E9r2o5eQWhKAKKyMjBu8BuYuFLtQb2c4U384vA029N6GED42iVwexvs
	 Qy02HSzj4wC9NG5ChI3KVHgChg8X9Mmh5uG9/p43xcgZK3sY2KpRjz4FNz2ddxVAic
	 WH+xVUhU8+zr+WxlOE3+Sik0WbkV22WKcpegZwQQ=
Date: Mon, 16 Mar 2026 09:21:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Kees Cook
 <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vineet
 Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian
 Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh
 Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"
 <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Michal
 Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 selinux@vger.kernel.org
Subject: Re: [PATCH v2 00/23] mm/vma: convert vm_flags_t to vma_flags_t in
 vma code
Message-Id: <20260316092143.8b21650c803eb99511395b83@linux-foundation.org>
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7xynedqw6t67fr5szydss4wpp3z5593r
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 440F91C0018
X-HE-Tag: 1773678107-760290
X-HE-Meta: U2FsdGVkX19juX8URrAKroE/JR+aw51I2Dt2NhVxDcBwQEqSKLd1JR11KFHKMmoKfWXm4Cyjc66a3DAhP0iQ/gyOHiAHLv49R9vEsxZaUIqHGvnyxEmNuuh020R+IXCEl0w8S0m7W7tVUzvzUH35MuaWckyUVQsF54Mq6PXi18e/g0J7sYZTSPxkvXzhwpSMTOe6AB3ZQW/KHV0yl3hf3G6aQ1CAKLpp0NYGfnyHR1n0LjC37DPlDwt2SgDOMF+GaawDVrbUWwKRWw6sr2NTkvNb1sRnFgFpG1Bs8um+9/J+HC75dJd5JnqZxpxV80xfZQAIZdfADJig+wlT9kQOrfcNT3WnMnWhnOCXsYwRKXsHrPAufc+PhL7ifAnT6PwmuvMfv9toS0VlRD/jNBivGfPDToJ/6InodgrDUZoVVyVW+d/vQGwLdr9GR6SXd2MiBzOuMuHlpHIPApu/kxMUkoU/MqSjDR3t3esnFjkPqwkrL/ECtjJan45iY5cIdHucaaIP1Rvbre2oAeIim5LQCZI6fJB2wZLTMr666w69MKKCiOBBZ8otbMEwyzTy6KU60qPT1mHBici1nGArIFf3aErpi1URusumjB8kO+TUN003nSCH+kuBhHsZawUP5lGdSkeD+2ZTzfcpl03TCgVYS3SfIe7eHLdJXx519vTQf7UaoTtR/BbCBJE7BnYgP98p+ujwuZSZDUAh6AF72K89EoqPLm6JwbWzo9d7GISUsLm4UJegw4vHwYREU9xG9eToB2Q4ijHXrxtkHRIzhaVXFIliLdRuHZ27IxQnn0Trc4KxJmAt6N9rLiaZj18WEajY6TGU3C8J7ZqN0foKZfJLYeLto3uwpprwCvNGvfsm/wNOz9Rac/hkRJ8Vh583A/tJT+ZSjqjMwzf51uFxYTFkZq8ppTqp2/UCVF6SVocEFCCWXrLhWVrYdg4O6mFOWlKNEpGmdt652qYT2ZcUdok
 QKZwE5S7
 /Rsy28lx8xo+lZxs8v4BMZnKFnE9uAihZLgstmx12rw1q4yLkcNQuJgrS8FdKDzTDWbCU29MlziX3DiLnOKEhf92jZCIWpk897yHvx5xVn+oQVlFLHipG/BmrOurkfB/G/Y6E5xVubYc9a9MCCuHkjSnqCIYq0AXyRf0bNF36MLEO7CdnxfMZ62jE3QLgQv+vw8AOOouiLNyMIDXgiTHl6/5NmaDcHMLviXAGkoQNb63itCQvlY8SN0T2WJ/F33qmZuklxiNqfpg3QGGbonyJ1UtHUXLaBsYfqgAHE8FAfSaxqb7NMhGaD09lVYqZ3Am6+a8faF12oZqvIjhphhnH1x5alBDV7327P9ao8bn89dBYNgB9HGuBjlnQ0il1laj8aGS4uGHFH93DOcaF26JXqrDIMXEtYPg4ze/L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 13:07:49 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> This series converts a lot of the existing use of the legacy vm_flags_t
> data type to the new vma_flags_t type which replaces it.

Thanks, added to mm-new.  I suppressed the usual email storm.

