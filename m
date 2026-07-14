Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A137C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958D36B00AB; Tue, 14 Jul 2026 08:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F8E6B00AC; Tue, 14 Jul 2026 08:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7966B00AD; Tue, 14 Jul 2026 08:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF9B6B00AB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:26:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C24F9A033E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:26:28 +0000 (UTC)
X-FDA: 84987305256.25.C3AF6D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3285820002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:26:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/43HVnA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGk1WxQeIjy8TXxnkr72i3ixVNdguqRlqFJcS5wfXts=;
	b=FLbn9CEiwPMftev+gqSEVAkG2P/Yfz98oWpTWOVnzRO/856TlRf3MeWhCnUOg1++G1ToHn
	C+69jCf8lYsdMgiZ70YE1J4jH3EPQX3EV7suK5khzVuiTVccOhVWqOAxkBRfJ0Nx9XoDqL
	jZdLqPwK6iMQFutWvEMqQ1Su/HeAa38=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/43HVnA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031987;
	b=pl20yjMi9/3s0SOOxlSP452VhnTdAXUdkD7/AWoZQPOc3mqOjFZvgkqrLwtEJiH2pGrM3A
	gb/cH31niz6vMN//0e6me77DmdZWZu+cX3ZPbSjBZASPLdxTWZXe9OGmw8pkxWpQoiFl4+
	9smEW1GtoTiaEiMezJQRbE5cwOl16fA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6DA960120;
	Tue, 14 Jul 2026 12:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19F21F000E9;
	Tue, 14 Jul 2026 12:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031986;
	bh=mGk1WxQeIjy8TXxnkr72i3ixVNdguqRlqFJcS5wfXts=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=d/43HVnAk7/FJSfqTj5xPz9u7OIgJtrLN5hKMCb2FWagDN2HMlJti7jLHQXFwtYFY
	 UInW9HOmx+m5UEb3lc4W8EUlLakzhEfewyYo3bWFc+aqt0RWPbjQwVnsPZgO14nvka
	 Pka70MqwZmt6lszXW0R534MSEcoD7NE38iOKc7wCJoeq5Qwil2yxBJwwGigzAaKrhj
	 qN0kPwPnAxhKpEs5HYpFBfUbjd3t3H7RAu4SrH55t291VHsYv45Yhauf7Lgk38OoUN
	 DmHtVL++ue2LbRreljwCMORN2W/HyIPvdEQcMj7dIEmHuO3S9noT1f0yg0OxJbPX8/
	 2tpQJRrjVJO+A==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-rdma@vger.kernel.org
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
Subject: Re: [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with
 kmalloc()
Message-Id: <178403198364.107074.8884062475078285923.b4-ty@kernel.org>
Date: Tue, 14 Jul 2026 08:26:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3285820002
X-Stat-Signature: 1f77jjj9m6jjj6aaxg3x6rocnsc37i6k
X-HE-Tag: 1784031987-687248
X-HE-Meta: U2FsdGVkX1+2OIX2jOxBqqjrLEQVnf6tZTj094V9mxmhTgeaYZDzAJGAnIgqJixNSu4+QC16xCet2l2uE9SzKIO73VtEhhqwbf2JymwbJSDTHp5XGl9N1cSIo9z9dKdKLpUZPJR8yy4FQSucxiPj4Zv1Ki0qGd4j3jf42NHwA6Y7cZhYcOmIJDYMwbRFs11z/jFuHm2Imua5Xg3RbdBuaIMVdeAS0Xg9QB8Ine/QdZ5Ub/DVfME//w69mIJOCV4Umzhk3hgqy8Y9Az8vyslYqT3IeV2XW2b/ANQrP55kiV1TvMhPGp70vNDNX3GPrSv30RhXwcouQEZRlPYicMcstLUpC6yYJPmooxRguvh8PmHrN/27nLNlhmj73kpCPhLB8C2KwS1hZvCKUe1RWTU3Di+GGS46H19hmZQCHr9YtAIe1nKCRmic+j8bWclCn3ElznQd6qiFLuQ6TlKVPPk08Qk3nCa1FPhjkDssa3dyETGpyVHYlBTObAY3jHspT3PVtueGv1TOM2au7Z+Ptipiv8Iml4E8K0NEBZ9X0SDRzzpDs6bE2bMkAI0lgsTN5PY2AEvcFOlrTcgl8jie1Sna5kv0ev66n1FY/CdrEOOV4+aodkro1ZFxbjR03DbQlrnFfYCa4FfVY7mKB/dW7YQ818MD/POyNnO5eBKvphPwNVIZSHQwI45DNqzGzZhugKwgFC9qT7Nbx03eaNSzo1VgL30IkjMxVTtQtULXbrgjnLpw0KvPyx0ege/nYe6xdX5YQTtMfDFFxkmGNrZ7qphxb6iH6zTN9UOuAokV9rJB0TUX3nV+FTKcD4d6WnCrB8uH1yoa5/zIKWOOTLtL8RjCDBuxcXuEIMRT6/cz4dykymhea5F0NzESWyQG8HGtXxk6sWyhbnobVP84kLqIbWUzkqyMDh3hKmliQHxWFwlQETgLTuxQEW8VdS+07W4L3/vdDhRZxLepklbvYv/P3cE
 Q58Jd+12
 /+XV6rfTEV88Na4b/j9Wc+tBJgvVGKjAoM/mF4UJebEJkCgZmeO7DetNrmaYttVIvOPXpDZTooWCSZHjopGas0U27RavKSRTYf7oaKDDi+g505ROlW3SIHL5dsOUgbkkIk6lT1z7XeYsE5zT4cfSkttnH7JnZ2uS4DtY/GE3ntiOIJ1iIG+9F+gsuWH1w7FKsaoPcpgn1zFVGC7Tt9TO7UE6dWJJ8T0iMqrAMgb31qCg34qLJYpdq29BWMCb6JNOTSmF/bCL8g+U/FH3kvGE+KJpTDWc/jjmGc5lr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 13 Jul 2026 10:17:21 +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> [...]

Applied, thanks!

[1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate page array
      https://git.kernel.org/rdma/rdma/c/66073100a7b857
[2/5] RDMA/mlx5: replace __get_free_page() with kmalloc()
      https://git.kernel.org/rdma/rdma/c/e3d8c413e2e9e8
[3/5] IB/mthca: mthca_reg_user_mr(): use kmalloc() to allocate addresses array
      https://git.kernel.org/rdma/rdma/c/5036553f0e39e2
[4/5] IB/mthca: allocate mthca_array memory with kzalloc()
      https://git.kernel.org/rdma/rdma/c/45bf0b3da47d75
[5/5] IB/rdmavt: use kzalloc() to allocate QPN-map pages
      https://git.kernel.org/rdma/rdma/c/f8d04b0c74e989

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


