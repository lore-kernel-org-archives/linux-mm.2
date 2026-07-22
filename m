Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3217DC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7446B00B0; Wed, 22 Jul 2026 11:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DFE6B00B2; Wed, 22 Jul 2026 11:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7596B00B3; Wed, 22 Jul 2026 11:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C64396B00B0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:17:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AFAA120200
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:17:27 +0000 (UTC)
X-FDA: 85016766534.03.8ED376D
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7CE5720012
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:17:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJkzkAKq;
	spf=pass (imf03.hostedemail.com: domain of abarnas@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Upjmrh5JJYyxIf1oGA8lLlYd9DJQLFwgC7+8SiJQqeY=;
	b=TFujT645UAeZSGSVsXSsvnn8l9hfhnYniYBN1vrRvfbhP6L7CjGisijNEr6l+7d2MI22T2
	onv2xQkgKwj1pUS/e7koDcwpRzNOiEIdQCN9Fqpl8s1aGMAYyIgtnCOjX0trZOqB+4Rjcs
	bOD522IuUD+op0YtiORW/PVdn1/SEqw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJkzkAKq;
	spf=pass (imf03.hostedemail.com: domain of abarnas@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733445;
	b=wjg3f8FnYlo3lo9CDQR3fE2qwoRV+Nq+7VGZzfvgYLYqxoIB5mfYAzTiyfSiV1oQlcHm1/
	IJDnzprCqWzlFlW+UkxnTdGzpBo2A0X+TUabyLROh6D/1X7anxQ71KCDisbpK+Ihhenq/+
	xdUEauyInLFZjw5vJSwapldwND6yZB4=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69a5ecbbfb2so15146202a12.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784733444; x=1785338244; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Upjmrh5JJYyxIf1oGA8lLlYd9DJQLFwgC7+8SiJQqeY=;
        b=JJkzkAKqO2Ff6F2yDn+yKxgBU2vKy9cMxuNw0adQqrel8SB1Ptef34bUKrrOlEev9a
         yc1s4oWYD8UI1GmFDvQfePaM9N0C6LX3bfAti0j4rcb7woHvWAEqy1qNM3xkBVLl9u85
         26PbvsIo6NWeW81d4PJ7ga4ssnUbPpui424EQVbcCq0I5z0PlcrI3JurEArlw6x6XW0R
         be1x2RZs1p6oaNd4ujsVd1cVmTj7qziAGC7jihnX1xeobAh8sJXU029cNQ4N0h5Pa8I+
         76ppNSWE5KlXZdEDLtEevukoHo8nsoNAFoDKXMDPTtX0yJfjLAIJVm0+TTw0cWwKca0h
         FG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784733444; x=1785338244;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Upjmrh5JJYyxIf1oGA8lLlYd9DJQLFwgC7+8SiJQqeY=;
        b=lN7Qd5FJam/55NPA5YbB/ZzdEZEi+iCp6fxbJIhz4yUl8qjrxr0eVGZe85d1CseXhe
         qIg3hs/pQvkwDCC9iHhfifoyHyeAfFIOfUnLwb0f8kGelM0c+c4zrrw+w5/Aty3zS6dt
         VZ6dr6q8kdlYjkj/M956C1Yj1s108I9lEOVi9EJZm2v/DPeq3Dx/c9Jj05RwOZGEPTcn
         QfaEipAr26l7eqmMiFYb2kfwVHiFuNN+FgpU71K2d224vK8WdCI+5wnE9zG3K7hdJZfU
         2CCCtAozMW/SVC4Wk0WCH8jKYnX07nMCuRClGWRhtI7UVJ0Csrp7RciVcnGICeMj31ZS
         TCbw==
X-Gm-Message-State: AOJu0Yz7/rxnH/2dACFJ4zVdbzTZ5Ivau6SeT3eNuZLf6YbGjb6V5qYQ
	uA4Tfh47313c6D0P4AhwaVNVx3CU7iQpp0pEgXPxtK7YUwrhE61l7xDAzR4TGIGn+g==
X-Gm-Gg: AR+sD12feGg4X0Hag/Yp5QRCpJRohZUeYtx/jPkzeQ4QzW7TUhz8DFHD0KQKu+1VfmW
	t9iu837A7YK49CQ/eUrHd8PXOrHWrzqp3aUtuUxtcuIsx1Fu3TZdrTIai+ihU1sWa8nFJV4dLhJ
	2cQvmxyjYDAE3IoD+QJZpsfz2WDJmCaACiutGA8AS7dbDmC1XIW0ZvriPd/BYNvcDEUt+T/o5d0
	QrslMRa1rBoXQUJRyeVyt0u09Lzek89G3gYITDjlPkQPFxbAPLi0ZfCkwqfioV9MbXiTrclF47p
	BTL+HwfiS6++XgELoh/pjqJLjo3mcxvHqfsfYUHMHmXP/sEXdD6JZlT+oqaNbu/D24hTBbZxzru
	0Ns60M++et+8rUF6i+igkP2Z2xR4Fvo4r/gsRFQHDS5kzjEawl+qcETAGpDTUzGfoejkzRuiBlq
	yG5KzkZGecYjB8nTpsxkSWCnsYcCAOBn1jCccO1Z+7GNgv
X-Received: by 2002:a17:907:d5a4:b0:c16:a484:90df with SMTP id a640c23a62f3a-c16b485513emr815970066b.35.1784733443140;
        Wed, 22 Jul 2026 08:17:23 -0700 (PDT)
Received: from google.com (152.118.155.104.bc.googleusercontent.com. [104.155.118.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32a78229sm131383566b.1.2026.07.22.08.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 08:17:22 -0700 (PDT)
Date: Wed, 22 Jul 2026 15:17:19 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
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
Message-ID: <amDe_3KFBc9CcIbo@google.com>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CE5720012
X-Rspamd-Server: rspam01
X-Stat-Signature: i4g8nktt77ff3jzui9om1p39axhpwua9
X-HE-Tag: 1784733445-511499
X-HE-Meta: U2FsdGVkX19CbjJAx0ugxz/mkyAEcfv+6eQp20AXsR5FzDyk0ud1AGQyOQRlNT57PDwN+HkfNcSO4vWttULta+bGRFE2hPKtTpsCMUUIFGSEnE+2AwKoCFkLfkNIFnaFRymiMC/OxILtoVXtq5hTI/PO3CVVP3Uok7eBVJWKjtEy2PRjL2SH2ogXHTm0+QKlWr2B4FhJndwqpIlegik0MGQYIf1iBri3lrPvv+LbHNFI03kevo9n9ijOroHzqifimc4xSFwSIqAbcHMHgI6iC8TU/uVO9/9N0EXD4iVUeXgPSUHwuUkiR0gXjrL4BBmqMCTr5OUx6JeN1G+Pb0LzuYfiCYeOdyzrdBykJ1BofuS9fKPTEqlrlXmHUh4Z6Q33rvWLFtKqSwgCuLSICR+Y3g856HeoUh8gYwWF36ziYOPrADLpn7roZGjz/sEo+bdwnb1FwZWlbEvVDuENaCUS0K3tzMcAD0p0+QKk8D0fb82Ip6Vs+GQ5v9GpVJ26oVqAQbw+CHCPQNL7PodLbn6QoolzF3rISGw4Hdhl3KpJM7eMgJj0P8t0aqod5Hb4/dd/XQKQ2fCB7DjOmPKbZkZ/WfMQOrEN1d8cSnVtpT/Ll5wlbuV9uis4fYv0TF370gJ7OSmTL0dStMNqRKA/HP/n6yiNKFWeB5PCWNZgtJv2OuN1WnsjBBxUFXEa81/ykATShn6ggavY70XkJ5HWLtMF6cHk8UQuz9PaA2hbQ4BAGvy1v/JHFwaoeYBVlEx+wEaM3/EZc4YU03FGjyfaMQrp2Ev6Egbr8UYBYgJWNkr8Af7S/GP1NmaHTmG0jc8Obul+uo0B/Bf+wNhmnod7gWzLknsbUfEReLEfGY0iazWZUD1EhOpIqw/6sS8rQQA8fEuHhew+DuSxVJ0r2BPbMybSmSAbvWK1kc7To9aBIUoaIIvE4ODHMm+2sD/WIBphaslkz4CV0qjGgTmFLu2FH+Y
 ZHbp85+i
 7V3i7pE88lBVGmSxpAD0ksCrUsoiftF4IOVblmfxEdaTxH0LjID433X82gxlHJrhsUUASj7gsybcWB8UW4AvMTuW/LQXxoOR/saBF1bDg+M6M6AGF/brcDTX/DRqx/lNMNnwnO66gUkH+XBP9inCempV9ydI9i9kTgm21syM/pYfN+8tn68abeCekBLrnYnKxzvt+9gIR8huJtlD+jTXwNegT+cjWfU5FyqOuCiOzuK4lopAP81unaCYPXEcjssz/aC4mhdK42xIbn0R/yJXi92Of32z6kQDgX/leDf05t50A9icfkW5nlOiA/B6hy4DLaRnZ2kxZG3HzfKOVQsLugwykO4RkIwPcVYFIK0cDA8iHhAj3qxcsMgUktJtNULj9BcTMh3hU/UML03tkygbC5QUyX23rg0gjRGTfsNWuQ6Dpdt9/FCo5GRYmDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 07:23:23PM +0300, Mike Rapoport (Microsoft) wrote:

Hi Mike,

>Once this settles, the next step I'm planning is to convert arm64. This
>would be much more involved than loongarch and riscv together, so I
>didn't even aspire to include arm64 in the first RFC. That said, I have
>a very ugly arm64 prototype that rewrites arch/arm64/pageattr.c to use
>the generic CPA infrastructure and replaces the existing implementation
>of page table splits for systems that support bbml2. But there's a lot
>of yak shaving there to get from a PoC to actual patches.

Could you share your PoC for ARM64. I can help you with that and align my 
execmem rox cache for ARM64  changes to the desired shape of this API.    

Best regards,
Adrian

