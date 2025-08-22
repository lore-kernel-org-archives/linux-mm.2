Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48481CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E48F440158; Fri, 22 Aug 2025 13:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8912D8E009D; Fri, 22 Aug 2025 13:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E9C440158; Fri, 22 Aug 2025 13:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 459718E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:09:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 116DBB6BD5
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:09:56 +0000 (UTC)
X-FDA: 83805030792.20.1C70151
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 702E64000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:09:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmWBU4Vz;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755882594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJaCLxCq3XCnWLFFwVYzAYFNIZQDOhDO2V5KPJHlnOY=;
	b=3OMu8jD6pjdWT/N8ejPzdCMW2ow39BFJS53k1Jf03+EfGgb1XlcEDU7G7tqPPeQ+EPwmFC
	Qx/JUyb45d9INypP8ZF0McdCGIevo8e20NfcBgOJwNH1zC81iVQGYbeBgaTIPv3mdumOk7
	3VW+AhsJyA+JS2tYEbeQtJ3lTJsCBWE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmWBU4Vz;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755882594; a=rsa-sha256;
	cv=none;
	b=OyM0I5Ehkv2gnO/YXKFM9TTFL9iu02rjY/nmviXpyzvWeqxQbbEYCEfE+4QUzoPM8HcCEJ
	byzI7OPbbbO9EcLr5cBwPJxgmmXxj6IyzHdUXk27lOeBQTUAVUsOHjEkjwXp/n0j/PqTsP
	S0ORCPJaeqKyx+6097TdKyuFEtuKQH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE2F160203;
	Fri, 22 Aug 2025 17:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506C3C4CEED;
	Fri, 22 Aug 2025 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755882593;
	bh=NEyazjWgDDK3Y8sTMLiPKtOTS94IEzEQJlr1MXdW648=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmWBU4VzSCcAnl6Zdrhjx6ksjldQdRyRt8SGGJHoy1Xwe7M0wFFiAnOgc7AY/DT0q
	 lyqL/1TbY9lw6Mk6ofMnsxQa0R5tG+ekC6WUSLcyfnxUCURU/dBA0VxXY7c6IJ9LBi
	 dspILvQPKUlPvqhEvwNtu+fRhuKR7/IUmABwpf10OfXceruEb+htOjuVlClrNaqJfU
	 QZNtMHJYtlsQdWeTBL2WlQglN7zceCD+RoTlZDKPvwA5Fz0NZs4QmCTFXTFDq7ZuUg
	 eXWdY/p99/aQ44iT5rRcus/JttgHgvk0uE55mO5Gfzz0M9Zot8coHQnhPz2Tn/edlI
	 y9z5UNwm6HZrw==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 07/35] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Fri, 22 Aug 2025 10:09:51 -0700
Message-Id: <20250822170951.53418-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821200701.1329277-8-david@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nco1yrbiy5xchqtp733th387yygtionm
X-Rspam-User: 
X-Rspamd-Queue-Id: 702E64000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755882594-236230
X-HE-Meta: U2FsdGVkX1/wfgP8bBA3gPVT7LMqByfNYZthiJJhQsBnVM4Fy0Y6LDZh58NL8ckKDfsA4GEc24x+pPyEdEUTTEDHppPjDePLVdl2uZ5YlVaUotsn8aRQFEg7wjKm0WpC5KptX3FvYGzi9fAZGqhpft+O5uTxcuNJvfZKiK2S0aMi6e/q0d6HsbpxHo3hBDSW+0mBLdMqaZgwsJtsylDfb81FQUyo9OojeAUXez6nIrV2cKCHQ9LVDqHrw+2lws7TctgWNHUMvoARheTQyV7/ZLs6hmsjtkSPTJpDgr9rWxBsqZvCcFSatfH3zAdt44PjlqQDF+UfA10+2Z5ypOdVqQwjC3Z70sCXAIJJ3E4oYdVymi42FSBKVF7mQYkcD4FdEwI6c83wUD3kCjqDW1slntF85rS450qOpaP8k5c42BLp3PsmNaMVou/S84mX6YhSUk2R4Ge5dLxDTzmDAr/mNMrUt+fvWk8SUOKRLs9f35UkhQR2/JRynh4SSb4vZOua6C92i2gKHYTwX5HZQzRs6cnIBM9DMyna0tsoeBgNf2nEy5BHSeAsjB9YM11QZS5kQhOMRVNLw7+I0WCVLEXd+WGJSbke/iJg8Lkju8fEc8K50xw/wHujORPfxWxCaRgrsc99i2bUa5ecOTcBth5QSo+hZ9q9kboU5uFm2dngp3anpXlPQXxOSA3xzOwgK9dKA4MY8GelXgnb/+NtOBwjoiH3XHp5A2QWl0B3x2du1wQCGOIk4QW5/diJPdl6EDQwLe+Y1pHuIP2ZVqllm1Gxc52lv5GVAE4XNqRFG1viplAhn7vpOrFiLRsjDmZGl5ib34uy8FQAWUK6ACeA2j9JEcyO74bjD+HT/EhHyWkI8d9n5yK7zaUxiYUIc9folZorE3Z98YlZOHB7JpPdnnV8wnSxJ76sZGldVqUGm3GYa8l9ptxH3kWCobjzYTjpeBc4AZ0dYqNe8STMzoW+OVS
 MAyw41gu
 ThXix6W9lPfXpttFNssYN52NNxfT+J3r6ycp91pBOZAH1CQCmp/+361U95tgGXeQkypXfSpEpVXkckDBaPGT9mH+DvveZ2r4JouHM1p8xwispKxa6tlcZZL7d+m6Firg0eOYMm9iYww6FfgaaPzG/aUd4W36K3hnubqNNBVpGNW/vpdlI40vwQkti1d65XRcAQKJW3waB/Oa/CBOoeohlZLeujxPyOQ9gJAnT310WIoqCeLt7UzMklab8W0B6++Vs/ObI6vLIvp4Oo/rKDZ3wqx4VjnACmmM6rMeZ0749H2lUgxDCaKnLiusUEG9iyyezyye3rUfEgMuVLaw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 22:06:33 +0200 David Hildenbrand <david@redhat.com> wrote:

> Let's reject unreasonable folio sizes early, where we can still fail.
> We'll add sanity checks to prepare_compound_head/prepare_compound_page
> next.
> 
> Is there a way to configure a system such that unreasonable folio sizes
> would be possible? It would already be rather questionable.
> 
> If so, we'd probably want to bail out earlier, where we can avoid a
> WARN and just report a proper error message that indicates where
> something went wrong such that we messed up.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

