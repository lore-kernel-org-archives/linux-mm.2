Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BED606A6F8
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 20:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aT5+jo3k
Received: by kanga.kvack.org (Postfix)
	id C41DD6B00EF; Fri, 20 Nov 2026 15:11:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8896B05B0; Fri, 20 Nov 2026 15:11:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1566B05B3; Fri, 20 Nov 2026 15:11:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91B9C6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:11:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DED71C23C1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:11:49 +0000 (UTC)
X-FDA: 85456593138.16.88126F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 79078140006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:11:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aT5+jo3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795205507;
	b=4VstwsVNkNwxHtoylBHC79Jmg9o2H00VYHu4mCIA5mg3/c9TQh/M7DVAU4GtFxTanuaaI9
	Eq7XVRlNlauDzom/f8XdJFtQ5gT8C0KBD4OiGDw3YsVgzfuFUr55gT4qKDti/4iw/UGrJd
	IEaxqzscgnlONbXRXwBYJIRmyOdAF7Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795205507;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSD+v5qtJvl1jtYKfGZE0/A9pPZfPt3HE1Ga1u1oj98=;
	b=ZzVt+/NgZ2bFaE4dbm/79UAuQokKgTwleIAAee4bU3YjnNjdK/V1hxrkOiYGFf9L0f+fsC
	akzDCNQjAVJDLZRCWPrvnyCuoeCOF1xMd7i250VGmuRHNAApVUzVq6mo048BUgs8ogeFtq
	dqduNFbmgc4kZb76mW8g62JPF3PYQp0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aT5+jo3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EC3E625F9;
	Fri, 20 Nov 2026 20:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF821F000C4;
	Fri, 20 Nov 2026 20:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795205506;
	bh=tSD+v5qtJvl1jtYKfGZE0/A9pPZfPt3HE1Ga1u1oj98=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aT5+jo3kkI/RnoMADuI6SYbdGmzwNLFFbSLKmWFftUdoN+VegCdD2tmlE2F3Zny+d
	 5hocedOUvNOKVr84WbY04nTy0DgkUCbUzOFNjxbqzXF6MUTiRWf58oGrpx5i2y3PYm
	 yJPJEnEvSTvqca3fpxhygR7O533gYuCMldpUmM7QxgNzhyBbOSSEonq7S9g8JcD3Eu
	 aRYY2/Y+3jzeBrB9tLemZo24n8TtfxT1PKqvS4MXZjOfolw8kC8FVUG2g2gFTpNkmr
	 NtjbnVGYD3QbNJZeZB0BLHSj8RRSarE0gZZVlZLYQH+mr3JB4uOhydoTyOm5kpLmF+
	 MxspkXwFUHRKQ==
Message-ID: <sashiko-outbox-226008@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 2/5] mm/huge_memory: fix filemap_release_folio()
 interaction with GUP dirty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pedro Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Zi Yan" <ziy@nvidia.com>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Lorenzo Stoakes" <ljs@kernel.org>, "John Hubbard" <jhubbard@nvidia.com>, "Peter
 Xu" <peterx@redhat.com>, "Johannes Weiner" <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, linux-mm@kvack.org, "Kairui Song" <kasong@tencent.com>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Michal
 Hocko" <mhocko@kernel.org>, tytso@mit.edu, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261119-gup-dirty-what-v1-2-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-2-236d69f25c24@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 20:11:43 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79078140006
X-Stat-Signature: 1y4upcsah7n91groyqsahuxifce4prnu
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795205507-319128
X-HE-Meta: U2FsdGVkX1+pujsPG+mqUHXRV38A9zvSmlCp/TnR4efSB3DGMSg6DBhzSBx3dcXcyyRcr9TGK1v3qDVn8hvz1eDIagXJXX1f/+vrdnjQWCe43mhAuLGgfwMwz8fLWLg87MtySLU0xks0/yjS2BTdjPjJVVxtcF0peF4QJYehzqol5ySUEPQ55Sq/jfwvuugxywumVlNvLfCfqWvea2DH1O94jlsr2F3SNO9Ad3deeLxSZJ4+S1974jzPf2BUjglxXQZvkXotOKjyzyJ0CpJ8M3LoXEOoBT7PYMwjb/Zv5kYU8dsM/9B8T6WHOgqWeLcpS0rgM4TgFTOM5i3lZQd8LDiLjvEj0U45PcaqtT9FwShrjLificxDrkjdrKJdeoxA4SY0fSR9vlxLjeSMn1JaAdeUGgRfONWO7oh/Chhe+us5K4PcJCwr2i/+KnjtwsJ6t3LTXARrqwiUo4E/XDuUdxQYcUsY0/xJBP0hXWeTQkawktzr97VQX14eIpdfBUVdgBnnZIKGnpq/3zDnvRElqL6AgMRaBm2UafcaHAI9AfxRBcDmKBdutaFuf+GtOXysZpTzgSthdJWKH+oSvfRbLjiB3NllCGH7uCnxYFxb+tLFl7KxsDCZDP6EzyOAx3FGSD+5HF+0p/GMy8SJ2iyMAvUg6IEwxk2ILH/NRVPrvZmqvispqnXqU7bTXHWsaS6rIkYSaUNgFY0i71GB+2R4lEqqxxllqWzwIWJs5FQpA9pYJokFpAuN4r1sCSmOz0C6M2oIBSr1jgErLt5NocpJe8mV5qx0H1N6tCyIZ4Ckb1fqYDWFYPqYnqR6UgdVRdhgu8gOrkhIW5XJKJFlz2PolZMimljl+q3b6txSINGMLyIwLOvop8jOncEYzzo0W7zY8HZ/prm01q4xSAHWJjOeiesXfBunv0xSZ15IWEzpKuAAMUNcg+v5NHYdvK0w7wveotPdLspt+MwSXPewNIa
 Kp7Y+bXV
 W8+J17cH/k1Asu+PUBrZW/juusSpKQ5LOL/AkxGPeHSMNbkKfIEyIxXCmCGXVRHIpSjQGsHd/FJFuIw/PI0jmP7+oE9tzf1C+aY7gKdZlgxb8+7o4223INKNjiSPhNDMu0dNFeb6NFXMRDtjXT038O6vLEG4Ug/e/yyPTluhZqZoUoKx2CrafmA6k2SRE61jJe0nzyMi4Fw2poFtP8wlnZy3YtUMu2s84v1nYoNYahdtFm2ha9VZzMRt4LX3oaGZiK4N6tANJoCW7T4rL+WcWn9iNJT27U2/sG5UW8nN+Wy7g7athiLVC8zR/eAPHUCxsP3zJtP1GLA9NlFK0X0/iu1gsu81hHKq6dJxMjDSDScF6MkJaYMeP0G2UdYbQUO+j/2imGpEA2XOLo3E2cl1lQDt928uPnjoFNeuKr9qvmxxX1C9lsBaIos1+1zAikwKw8xNoFDAguGRn+E4cPOxkds0kgzpVUiCUXdZeZizwKOhkzLRTHXgRoeF/5ibbZ9otEaERP05FWrJUOw7SnFjeXEtSZgdjEiNsMaizEYm22JHD91gawdkh1QT2Na0ETYW8tl5KySaDXjHkE6Z+40A/ho+ylSJrLrWvtRnvQfszIMO++bYVs/vNI/M0DUv+jV2DwdLUnVSe/ChLrz0Bj5R7Zs91/0lJGWWbsoL4KeyQ7oh9t+nMj5CifbPMGjJb7/147sx0c4co6iQcmpJWBUS0A2SWDHF5eMfhBEbSEzIS0fQHk/rGsKTNlpCwrRzCrCHOFH6JdTbu6QeGIIuB/dIVzfPi5WrJxCtDYZu+AwpHwB85gipNL7g2aTyAR0vUFc/fz/3euwArchu6+PjVSEqne8cmIe1KN8AaFq3+RHxUY/CXo9Nr9deBnviBQQYA2LL7Xh7ohszwGz5/L3sP6/Htb1x+Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/huge_memory: Fixes trailer cites d824ec2a1546 instead of
  6a3edd293956
--

commit 30321b8e2452fd3a099b0078bb5c7a8478e790ce
Author: Pedro Falcato <pfalcato@suse.de>

> mm/huge_memory: fix filemap_release_folio() interaction with GUP dirty
>
> filemap_release_folio() can only be called safely on:
>  - folios that are unmapped and
>  - folios are not dirty and
>  - folios that don't have elevated refcounts
>
> Anything else can plausibly be pinned for DMA/writing, which interacts
> very poorly with ->release_folio().
>
> Fix it by adding a filemap_may_release_folio() check, plus move unmap_fol=
io()
> outside the i_mmap_read_lock(). unmap_folio() does not need the
> i_mmap_read_lock, since the folio is locked anyway.
>
> Reported-by: David Hildenbrand <david@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

[Severity: Low]
d824ec2a1546 ("mm: do not reclaim private data from pinned page") only
modified shrink_folio_list() in mm/vmscan.c, whereas the
filemap_release_folio() call in the THP split path was added by
6a3edd293956 ("mm: release private data before split THP").  Should the
Fixes tag be:

  Fixes: 6a3edd293956 ("mm: release private data before split THP")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-gup-dirty-=
what-v1-0-236d69f25c24@suse.de?part=3D2

