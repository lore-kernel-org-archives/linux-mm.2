Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600FD606B527
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AlID3jga
Received: by kanga.kvack.org (Postfix)
	id 6050C6B05BB; Tue, 10 Nov 2026 05:08:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC6F6B05BC; Tue, 10 Nov 2026 05:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F30A6B05BD; Tue, 10 Nov 2026 05:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA506B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:08:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABDDF1404E0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:08:10 +0000 (UTC)
X-FDA: 85418783940.17.7E91AE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 179061A0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:08:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AlID3jga;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794305289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B48kL4WCEYqxwxvpvXJRGvWJeCoK9+ni3AEiglJSAP8=;
	b=JdnPCkHimFJUU1BXtE69OAR/+DO62lEdA4XoEeBWB66zq6bRAP6HF+m0KXhTANB1T1GUM5
	AwIoyPQU0byqIdX1W65/K12k9BgziAdrixmuQjn1tXQFRg+s5zshjf3p06SbkicHMlwhLB
	hzDz9SfjSUAjve+mztI7T7y2vaLHHH4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794305289;
	b=xIw3g6wk3qYW+XviBGoDS04Gs5BYXZK45OBT7gmkLmHn0/XYUa3BCpdthkSwcEUmWQkeqJ
	moxTWVwocGg6zq08lqrH3eX58ArwsvlU1Gly5MhhK7gOjrYXFNqM2WwuCnff9xBvov1ype
	CVJjfdZghw/9/b8ZMB98Rx9S5FAWGH8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AlID3jga;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C5DD470B9;
	Tue, 10 Nov 2026 10:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250681F008A1;
	Tue, 10 Nov 2026 10:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794305287;
	bh=B48kL4WCEYqxwxvpvXJRGvWJeCoK9+ni3AEiglJSAP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AlID3jgam2bE0XzjRIAkHv5Kw4LKHa7v3jRobb3UN2iupex+SPzMdiMgESqD8vIxi
	 Bpt5CdJKUEtbp0Yp7bgApOyN+MPv8BCOrVYL96TAH0ZZvu18390yWHMerUsXxgzLbS
	 tyWW2MTSZ1Gx4rLGCKx5oQJxPPrlhRShYZgbOb/ntXTaOHdJR4K5otOfXWkYdWvLU1
	 kwnsl/U2xFuKdk76yvqjD2i3NK0zQ6PUe2DwJY7V1YRqilMvIu1LbeSDbE92qpvEXr
	 1bqjGQJEu+Ga+w0DkrJRo6iJsM9Rvqp9PAxStQMAXIK6KUKsE/4Kk5MjWOWE1YsRNy
	 t8+datQwT5aEA==
Date: Tue, 10 Nov 2026 10:08:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jinjiang Tu <tujinjiang@huawei.com>, Qiliang Yuan <odys.yuan@gmail.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Huan Yang <link@vivo.com>, Wang Xiao <xiao.wang@vivo.com>
Subject: Re: [PATCH v2 0/4] KSM: introduce only_merge_zero_pages
Message-ID: <avLsbZz0S7sRYIL9@gremlin>
References: <20261110074312.219847-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110074312.219847-1-xu.xin@linux.dev>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ehbp14j5rqr365enrgs8wr8zr4z4fxng
X-Rspamd-Queue-Id: 179061A0006
X-Rspam-User: 
X-HE-Tag: 1794305288-384250
X-HE-Meta: U2FsdGVkX18KW1tmE4WBQN1aqwBQ3bqNcCMxnucophI4lh8rAooC7vNXlEYA7EBosrtGCXcarKzM3JhjaaDUL89Z6AFvjffYalJTgRg8kNdMTcZjdR/4GXahi3lCmXOZc8FAYropyhJVNvYK9e7Kq8O+actlvkdfEbtn0r7ucA/zVcIN+gQ941ayleRKEn2YjmhMvj+TihTxesEodMvbYQPMl0XStPGOadHUlvplIuR7ZRyM9+a6a4AvkywfpQDQgh018/Cn2AiMD3dy1DkHIlfsoKo3jah+q71knjAQ1obyIf/zY2R2QG8CMCZ0Wk8pFszgypJOyREb29wRnv9MdKllRWrohoJxOwB+6PJkerRZ2HzsV0U4ooh4lgkMlDhDHJGFBFPHOfACde23d0JYORpPYtAtmtZmKtz9gbMsAr32N3VScylEXpAsqG2CoEdQ0LQVMSQvQFDHz9c8i26mh9Qic0aC22f9O2QfXcxeSmr83F1e4DwvcW+c8yzeVdCp8P985BMlnjdxHEAkEZMp3QK2Isi3+JSKoV3+++exF4SsRbw/LmsH7kQhWGOsrmtmt4khGCHAPIDwQt3auhFKdbsVsa4Qj0wmAgLFzfqsgYcNfSj3/WdLdoWv5MKbdvSU87jO0EEmNKN8RLJSdAELvjO46l2GyJGjWWj+9H/qhe7w+zyoR2hY0uHT3U+JPczjDk5/uERPEsbcsbzJ1vD6+yxux516P/pHGfjrPXAfTyrZZqy0z0dXWlbkFHeUicmN5b/aHNkslkrO1p1bMxZWAkB8OWbXzMDTHRn3/62gQT/oHeCV5YyXJoauUwgX4wmM9m6yWi9/gi/aWLKzLuLvNao2VIRZ01VnmKR6vYXl4gPMQOpeJsDRb+0MxLTul6ApcurO/TiGlQLmHdLuuPyoMc7lYF1OdOmiYDUdWBzwISWtOr/R862+hmDEjOMz4mbxK90aMX8suy8ZHnMh7K9
 xkEjawDQ
 W3VdQT6oVzj5s/gY/DIyRnEly1lL4ZRATFr8ByZHQV9P5tediDSinnlet92ZR1Nc5sKfKszlGOnEkPhwiMBKx0Bhwtag8yVlvIqgdvqw41wejj8lAPuhO466/xiWhNrESiuB0/LbcQYdExiuzPchGzWHSdls9N/FknXuag6W0i8U3/Gavt1zqHV0E8+U9bkWeIDlj83x4ZBivBegBCXLAknj1bpclFRLYayN9GBEVUcwXGY1G3iCKGYjJASZ5F/aCU2182bYxQERwSjlEEd+ajGeU3cpaLbYTHjKGIBItRuVj1LS2n8g/U/gY7mQocYHai6UcwL0XR8U/GPSR7K6/rPeo2++0ilHg1andlKsawBxZ0jMNGfhmBRN+rvffpP3zHZzm06loIQpKNWYQE9GmjOK4Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

All-in-all this seems to be adding more complexity to a current major AI bugfix
target, in a cycle where we're not really looking for significant new
functionality.

So given [0] I wonder if this could be deferred to the next cycle? David, what
do you think?

In any case the code is pretty rough from a scan (I reviewed one of the commits
to have a mini-dig) and looks very LLM-generated.

It needs _human_ polishing before we could take it regardless.

And additionally, you are shoving yet more logic into already horribly massive
functions in dire need of rework.

Sorry but the technical debt does have to be paid at some point, so I think this
would need some initial patches doing something about that before the rest of it
anyway.

[0]:https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/

--
Cheers, Lorenzo

