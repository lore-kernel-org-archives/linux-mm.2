Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3380B607635B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FDZ1T56E
Received: by kanga.kvack.org (Postfix)
	id F3AB76B05B0; Fri, 20 Nov 2026 13:17:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA4D6B0612; Fri, 20 Nov 2026 13:17:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9386B0613; Fri, 20 Nov 2026 13:17:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC4C26B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:17:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21C38160153
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:17:07 +0000 (UTC)
X-FDA: 85456304094.03.BFCD8ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8201740002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:17:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FDZ1T56E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795198625;
	b=YLBqp7A1y9urSg2uAHKSKFsEh9I3c2fi9WVopGrsNq9ywrFElRERDPBSe/v5ulp/aqsPOH
	iQFj/Ic7RuxcTZRJv7r/YP91zEMHT2h8+AyZqn7BGhqavz0NZkkrFH8nGINOiZaduVRIye
	uiu7gNCVjTWF4hHzbl5a3qWnA9TBVkw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHnPkHdygJLWUd6Raio1OZlzrSr7Mg2iPFJR6vcJsn0=;
	b=r1jZSaV+vJF/jPT23KtpUXee45KZlm2yXCuZRZw5cjJTNBbLd+Z0lDnm2eQXBp6bXCC4RF
	Q0EN7SBsnVyCVpBqVNUpbmWpq91uyc3G3fV4IlOnxWYdUOoDTx7pfX5wxTrnMevhCeQKWS
	CzErmw2BeDpdnvnbjkattYPB1EWzHyA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FDZ1T56E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA01146CC6;
	Fri, 20 Nov 2026 18:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22F71F00A3D;
	Fri, 20 Nov 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198624;
	bh=kHnPkHdygJLWUd6Raio1OZlzrSr7Mg2iPFJR6vcJsn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FDZ1T56EY/NGSZoTmntCLex0+4xeE8PucuiZ4OpXHfBdGoiLzo9IrSDqKpJcWcAEx
	 HknAu50zTJt9dXHaiwcX0LMuj3DCFHLZKTlZ0YSp49BB1UazfGAdNiorcEbNBdAlE0
	 Jm9XmV45fyiwhBKVkrrMsFJuZMkH80dEj76iDZAD5W2/MMLs8dD601KcImYLSCmqnA
	 RsuHa3JuDXI8q0CnuESnUy9+uoR0ap/AR56Kh1DZuL9oQd9rYo460sqP0G7aiGVMdG
	 ikxyOkxyt/pNSE1U3xl1nLM3UxG/UnmmNBmnk44dmqDb2p3sgftQKUtl/+bp4ieAy4
	 ZzkCSKckENgFA==
Date: Fri, 20 Nov 2026 18:16:52 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luigi Rizzo <lrizzo@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <awCOitDwwIoz632b@gremlin>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <awBYFhnpFGtEXZ6r@gremlin>
 <8c9bd441-db5e-4857-8e39-79f147422454@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c9bd441-db5e-4857-8e39-79f147422454@kernel.org>
X-Stat-Signature: fegc6ogz1mru66wjai8a4qp8brqoyohb
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8201740002
X-HE-Tag: 1795198625-905885
X-HE-Meta: U2FsdGVkX19ILQlRro+lkyRRZ0iTEFXeAO2qWHZ10YOxBzkb3n/R+1YoO00n1H4V2pBuXJZX6sMxqqdBoWljS2TRSRZ/esMFX+bSY3J0e34CbxacE4dw95uHvoIBEk8YCVu/u90tCZBcfNU7rllXT63YcMfJPhE0oiY/C0tX1boMzxWKSuI2oEaRgXh0qGFrpz/XewxXmB9nJNwLnd/ry2xA8jSTKpxIGFO75pO4XPsir6HwkDKJBj6TV6Yx10jVL/3chrnYPlWKdh9G28fYXHbrmpk42dZUUxNbiG/qP/CnyDndLqQ1MpL23jnywA/66W0qyXYm37oKR+QcbKHnERKFXOHNwT3gZtByuX20aIwZCkcZSBGTkEpENk1jN+sduTVX+Lovx/8IHPtLH/5Fr7bz3fCxmvHYLukhgm/Mwaj1AACM6VJt5LnoNAB9WLMBtgE/mB8NuuHz9qI5u7EE45/iJtFczdP33pCn0KDjaMupgQ/XN3Mk/yNGxyQIWkEwKu1B6rGxKgO+70SpFtQYeYGuzEXxP0rsvTH6/yG0G2jE0WivMB5KF8NHVlrv8lDSF2rr9Qs2jjO2uTeMirijkqtctKtwmSMUsGyPzEd2EdcY7CUrRsu1+SBMpZQDTyciYnjB4IXAMYzCwlT+qEWS8YK23lWwqjLZuby0imNXdPuPAW2t5pzgd+TiTa7EAMLqmicB1UOOY15+08zd0v8nEKON/hANe+EEHZNKlEXOl0+/dEPS1Q2LZZlizsOnii/h2aFWakkeHpFnPEjgWfa2Q1DW5fI7pjLrzuviyH9pB04s4n+HCGsJachZiI9W8wQg0MiOBk0aIdFDxvp5Awl3/PKbMFF90K55pMt70OScwsAQGcG+W42w0ynkJdZXR7AkrZjrMu6slUgRB2am6JdYrQWSB6CKMcAVNhyw1Z474Jd6OpM3mD83l9mLuXt+UpvSjKIFfNnqiLsEyvgw7pk
 x7mSW5oT
 Wv11+tlC+3myepMXzviju0v18hv+IXlwbKQiP+O9W189MbQthfVFXOR1YtBmeoHd9lNLaX1j9WUrEIqFhtbQt+6fgJqhz9ibziSb4NQFBh/oyue+Q92y3Z3CSA81zIauLE+w+An/XE+rWVylGYcaQHf/VUmW2dcVNkDyPmz7LWmYmLfKOKsfBM7S1EaVi0wjDcJtJxMkbUfv2h15YbsLtApscF6JE8hhhR+UHtS0CPRb0wixq03tQe8hTOJPmG9g5ttEBosKDbnWqYHjL9NtFSG5fTifug3vWypzfhKTUZ1eWmizUrcbGXK1ehaEc54MjBWjut1SZFF88DodVqnnIIjeBBb63O8Z6HShhGUrbxFMX3YFVE3e/fTcX7TAHAGuwWuqXz9/ARC6tGET2CTKdhWt1Cj60o0m3Cn/wmr1+QGBTc31FVrnNfJkVgR99EwfmRuyjVfWrLiLgRDamwx/krRQObs/pPqnlLwzmZ+C45ja4lo9piauSvk2mPzS5kSf2NZ7siQun89Ae+pL84zG8a78ynf+Mp950Ud2yhEi4mlF7c88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 05:12:25PM +0100, David Hildenbrand (Arm) wrote:
> On 11/20/26 15:54, Lorenzo Stoakes (ARM) wrote:
> > TL;DR: NAK. All of it. (And yeah, I'm steeling myself for the inevitable 'oh
> > Lorenzo' :)
>
> Oh Lorenzo ... you are absolutely right.

:)))

--
Cheers, Lorenzo

