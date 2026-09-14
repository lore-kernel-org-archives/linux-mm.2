Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA51C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 06:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88846B0088; Mon, 14 Sep 2026 02:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA946B0092; Mon, 14 Sep 2026 02:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92646B0093; Mon, 14 Sep 2026 02:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9116B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:33:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA427810FF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:33:37 +0000 (UTC)
X-FDA: 85211401674.14.259B702
Received: from mta0.migadu.com (out-99.mta0.migadu.com [91.218.175.99])
	by imf30.hostedemail.com (Postfix) with ESMTP id 87BC780007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:33:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wtt6Q5TQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.99 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wtt6Q5TQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.99 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789367615;
	b=Kgv4UH5XbI3zL8xgV93PCpxTdxOQtXks/xUsP748OzsJb+PNR+nXKl/7JOS06TpIXl5JqP
	3T3AanPGaemSfkFevtXT8Zh12jUgjQLUtQDx3L7MTy2X9+kS2kslEHnUcYuZHPJB2+YdjO
	nBFZ6eOyj6/RVlnJAgfQgEifjIBexQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789367615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkK6YXyG0BbIDE5HmXiBkMtNNwpGFm+QCTqmNoHtfz8=;
	b=266sYASdx1LiDB+czthDEFek5kBj4m2nFUvIeb3F+WyaAJ8SGN7m4VRz8tR9NL8pq0Dkpz
	WcdhVTqrL2UkIIO8qs9csuF5JMCBSG6Xpm5c4rCRBUijjWwMOARmUkvkQ14jFNLCYZXscK
	+V0sYz+SvH/m0+cJqLxZZjwAQNtCp4U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lNz9DH9e6AnUZooDBSooza8NOTOURgctjC5wmMiwXvE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789367614; v=1; x=1789972414;
 b=wtt6Q5TQ892Gzj/x1j7Yh0bdZp9xKG4y+EjUb2IXcQfd8kmO4z/EoXp2zp/8wtdvKYIcjDkT
 k31IOL3Ki1mp0BeR4rEnesuAn4ajGDE6IQ9gn5aYaMA6oKGpqXxkjWDP+JO9ixxvUhInkL9s6gH
 a2y1KJWKCNhVXuDufVaMOLe4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4202f23c312eafcc;
	Mon, 14 Sep 2026 06:33:32 +0000
X-Mizu-Trace-ID: 4202f23c312eafcc
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm: Remove unused exact_nid parameter from memmap_alloc()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260914055130.44543-1-kaitao.cheng@linux.dev>
Date: Mon, 14 Sep 2026 14:33:14 +0800
Cc: Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <271883C6-95AA-4C60-B99D-FF93BEE695EE@linux.dev>
References: <20260914055130.44543-1-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Queue-Id: 87BC780007
X-Stat-Signature: yc5pbi7azg6h7bjcsoe4r99urzqo1tne
X-Rspamd-Server: rspam01
X-HE-Tag: 1789367615-223676
X-HE-Meta: U2FsdGVkX19T+a6Gc6IH8bMEWLqajeC9nR1FUzlxjt9m9PbTpGi4sCuhi9iS8/BXDxP9WrKsNSWmv6NQHolC9MZrFGoj6hfNIrQGx6vgLpTXeksGogUg67hXibaK/2Je/0k7j1zRwJk9PDmZlNEHlFtlVVhKfG/gNQBZYOhMs32OZonBj9rn4QrhCbOIs+k3+MfE+Aai1ZOJwgHRNAMSTWr6FZVEP+Vs+RIgESyIOcopJsE5FxJsG1Y3cPc5GitNFx7vwjryhrdFaxVu+XsEztPwqiyt50YuZ+YCce2kGImdqXmXhzawmfxRfjGAgkSpD5x1hnWvazwCbT7NnxlMp2urM+4F/zGx6skTxMLUDEP+PUi460q7vZKoaoQ4UkBVBgQU23kxhzrdagUDA5TGRWqV40avuy44WPR2ImYdOlaB97flEiq8iR2cDwoAjZQ9dEtaaT3SdbizGgKFIEBjt2wjnc1VFKOck8gp8wY2VU7NT3+NLS+2hBfqHPvxQqi7F+kD0+ewYlO0cU+x6bhIaPQ683faLfyCXkh5VytYZSBBRPptAne57iFR21wtjBxkSH7VDDrkDiOZryAad7+14iw/61CJdsK0E2LHtX1lSc9iu1KzjSky8Ocu7UbgU3lNtEhLhZGydrdPAdKtZLhP2KlJoEYN1a8uhwTKtirzfMaxT4ABdREQ2neLohNLyf7+OIoIJRqECsIKRSiaZ+n7mtVLuc2KL6Fir52lB440TRnOj3sfkh0eHROijimmBkCJxUN1gu9P7IjYMr7gLVE3fFo86ftEZpUHULCZwIhuEc7ZCyt5hZTZobjHv/MA5WsFf+dTI1QJ+6wc9lWg+sqPlHhVORTBSCb9d3tLOm+VPn3aQBl9ZrB8KINtLsc9N692sR4PKHgse5TXW2YwE9Lz0pxuK8+5ikhbcPxAYuv7hzjVl+SimG5MCOmYhwT7bhlyBw7/vbXlglaP7ahFMii
 xlvi+uMG
 7a4r9czfa1X7nWhlNqLnoprHzK+1Y+IN1QGMx6LOAoeHq4XzNDcwx9fHS94LQRMwrPKGVwwAIlnw2kvwclE9bMnY5ROsoTr91xaW53eTWSU1c4FGW6Kal8bLrQhRGdQ7y283VzJSq6sIN9j1lcD+wydd/CkEisZ+W3FZ7ZcrACpnqY168Qp5ljZIXl+fzPXj5nwl6rl5gVPRUhCWxHfj7x37URBd4zL5O+9t82mmwYo4qoRFYBe7UpBtqzb0MP8sTrB+oYlLgD0FbaENqK0JCFN5aZnulqD7pr45peCqH408yHPKdxVil/aiDGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 14, 2026, at 13:51, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
> mechanism") removed sparse_buffer_init(), which was the only caller of
> memmap_alloc() that passed true for exact_nid.
> 
> All remaining callers pass false, leaving the exact-node allocation
> branch unreachable. Remove the exact_nid parameter and unconditionally
> use memblock_alloc_try_nid_raw().
> 
> This has no functional impact.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


