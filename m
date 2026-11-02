Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CDB606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBXXKqgE
Received: by kanga.kvack.org (Postfix)
	id 905EE6B05B5; Mon,  2 Nov 2026 04:24:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6DE6B05B6; Mon,  2 Nov 2026 04:24:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD716B05B7; Mon,  2 Nov 2026 04:24:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB1D6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:24:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E329E40CC9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:24:08 +0000 (UTC)
X-FDA: 85389642576.27.B069E62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F44CC0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:24:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZBXXKqgE;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793611447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2W5mYDF5OyICWdxbTulTo2Xs0l8NIvi3HpphFNiK5k=;
	b=TuPgLopnhzKI6KmnM4JaAryvDGqRgnTD1Gu15wxVAYrGlqtDy32Bm7x2yEqgcbitVdMV97
	qAcoO8juOI9NLC1J5TEpcNw5UEEP4pWP2raP9RG5eAIi3MD6E+GtLo1bRTJWSrxntuQUBQ
	1blZopVQwj24VuFQny1vYDQmh3DncOo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZBXXKqgE;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793611447;
	b=m5jRWKfChbSFyvJ45z3KUw+LxBnfuUwpn89qM58rlGyhREjllJJsPLNJuaTCr7DPr58Hla
	/hGRTUXlPhby8mtR/HxyJXyR9/JwJn+cfOn5MGm85m9l552KhWgP2qkvIA2BlLMq/U2OE8
	YSX+6YY4hca101aSOacl+J93EEo6SdM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79EA74388D;
	Mon,  2 Nov 2026 09:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591501F00A02;
	Mon,  2 Nov 2026 09:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793611446;
	bh=f2W5mYDF5OyICWdxbTulTo2Xs0l8NIvi3HpphFNiK5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZBXXKqgEs3cSEuo6JJMv4uQVYjwdPeUgKfOBFx3sGgRKSwaV7jr59rwXU6tl4kL1f
	 UIlGzQEfsGQkHOH/TbbDmLFtZg8Lg5fdSCTziFBdnk6TsVtI5yXd8hryFE0Ipc+XR6
	 jJwyfimv9DUYz/zcOWn3gUb3rQMyTHBdKf3AE1AilwXPZhOf+ikg0TX9pmlQWbt4p3
	 ZxklufKeISTuCfcwr1O/n49giKkDK76NYcCUf7r480LRRgWGND519LzVuzJFnKMhbQ
	 jEx/+S+Q2WxLeS4zw0Vr4+AL7I6IVMMHfFAho+9Ili2hsun175IqIkvSxRP6wDwmZG
	 02nxh+L9gixOw==
Date: Mon, 2 Nov 2026 09:23:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/compaction: stop repeating failed async
 compaction on every THP fault
Message-ID: <auhSzBcVE0M23miL@gremlin>
References: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F44CC0002
X-Stat-Signature: 387uhptpwcdhchtu9446owwuuz149ptd
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793611447-642260
X-HE-Meta: U2FsdGVkX190O0QG4u++kpaUkGN1puKEzWyOPF8FKX2fgU+lHKvO6smQbvjKkq27x3Zla7Gl6EL8H1f5qS18Q7o26/827kOt9xSKpVMGSm8/3wTKDoQ/W6cPPxt9+zaZ/6TWF+HThkXbTx9HFoUhD6mUu5J9jILdPEFP49lYjMio/PIfuS6T2Bpr3eJOda0Osj9rdmozCz5WU6zLHFPLL/oMXb6pC/aNRFUwKil0RNIv3/LvsFRdyIQup2tGyZG/M4nseAoH51+ioAohx/cJCAFDbNWkldrTBKtzzxBCICQzkFljK6biodCGSfwR/3zto56EDcpUfXSXtvLtEtUasJAuDmWrIYeMiWgUFKvzIohgaJRyqibrbRl5z0uBYcFQV9MJk//bkbE+9VcBcU46AvVTyvBPPDd/+p/rk0bjFQ0v/63pvTm4Q5ywgi8vOg3iV32TwlDKy/Og9Ygxa0KEFYnWW2CsvJraMqA9mnj+ESpBPZm7pE2OxWCCvvOLC2KPKtETUXW7fGA5t/n9z7VTefWdZWanR5N0uX5FOc57NfXEAv2fD9SRHGI2mnW582c2zoaNyMQ7U4a/sl4+X8qJ6qD7McGvo+JDTykQwUl4cLPlsr64ry6MZXGgyz+wJdEOyChu/GQK/EF/S5fMvyIgN5+B+kRF7sPYApV7FZB5uEKydydRH581c2r+hLND678Lf/z9e6uCYSip0MBkRfLZDjr+ofFIf3Or14WnkxDR50AZGD96PfSdrN+o6ADzhXt6Zw2NY7i/rpLLTGLR2xz0f+DffHC9W54GtPsxJvRgM7u1kcDFXdIYm015ncTmOmB3aV+8MTMtETMTER7MBSO3p8gPhJAXVgu9Ddm76/DzVy/PSxMhT3MC7XMio2QY1ZR6JN6PfYM6M/dRvQUEL4/4mUQSjj9eelHa0Ajxf2tjcabme6EUIPT0mXd8Florg49+sj4Y76w314r61om/bmj
 UxVry/2d
 l9fV4+Dvg+wlHA8XKJvWZ7YyU0fP7ALA56i0okr7wVN7lPLJt0LDykVp/NJ+pBzBe9Sb9VXqm5dzPTiin34UeEEqWN3aoL0DylwFygP/DxmfW/V8gyBmEs9i7k8hPOo+8xU1B8dbyXyEdHfhsrpG3hNTJ/L9crqpcjIM9GRFGjTww8wos0u0dtjmsc++ae4OTkJOZ4X7fzrrPZJjqZ4oro1U/3UiNCWDO16U+fjbvCVVXqJpKznFCs4PfakLBlSIHW7ypm2+idP1HEiDf5CLZ8aC7C/qsTx7kpxUKvv89lfbxX/7h6VSy1v06hAEMxzf1PrOb+gQZVzNIozOct0h/lxTPANYLu4UyPha4TvAw0+ChgBFusHqbl38R8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

You had 2 maintainers NAK your v1, why on earth are you sending a v2?

For avoidance of doubt:

Nacked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

For this and any future revisions. Stop sending it.

I have no confidence you understand any of this.

--
Cheers, Lorenzo

