Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB41C88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 18:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D257C6B0093; Sun, 13 Sep 2026 14:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5676B0095; Sun, 13 Sep 2026 14:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE3B6B0096; Sun, 13 Sep 2026 14:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD2F6B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 14:49:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30F851C2D7C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:49:35 +0000 (UTC)
X-FDA: 85209627510.29.C96E4E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 995C81C0004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:49:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SFRxiGvj;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789325373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASqH2opBRIlLEsueKOw7/l+ZMjsrPLzg0iHEi3azRhk=;
	b=nW+leU/AZrKhA0TvbO2Hco9RaUu1xsiDdMaUKOQV1ET87za43aEyA64VlrSwxjhctevVLc
	TW9ioKvq+pCMSlJxrwQBhKKqhEEwH6Gu0LulWaCiGi2sz8Rec4jv9v6Iuwm25TR7DGyGMk
	kCW6CGOku8urR7SJupnPRkzoU4wBKK4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789325373;
	b=DDNwZA7D8BBtCbVqvX2Ge8W+BcwkIsfI2OMY88T8ruOZjIHQZrzC39DQ1FHVbb19+N4kWc
	c3AHp+VUTpgAVft+qeOnsTxqGf87u+FEBUNcgXWo2eWSyzUCP0Polv6qKy1eAj4Y7URy5U
	ou55Aqbve9U+cSLsntDaTGO8mHdWe/0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SFRxiGvj;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B209141605;
	Sun, 13 Sep 2026 18:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717231F00893;
	Sun, 13 Sep 2026 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789325372;
	bh=ASqH2opBRIlLEsueKOw7/l+ZMjsrPLzg0iHEi3azRhk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SFRxiGvjwDh+Y+1T2fJ1/aw58TKDIFHaBrbZRrT+UzodT19W1INReS6lIicR23TT2
	 Q0972OJsaAemnju9rB2GkRyKMJkEzlhbpdPs4KEvEcJXeNe/NIC0YVc7stUSSvCyVj
	 2/q8JtOvq5touWQUHq85LonqAym+Q+CrQU9/zvQSkcsrgiGzHOAQ3vOESVenX3h8C0
	 DOaXND6FYi3ljHem6MSczwwBW2UjTPmQw1VqvF55Wf1Qp3HYfD/E36aoK+sYC09n73
	 MaH06+tG3v84lMrCvA6cjKnaUCDIuBvDtySuHpj/DCtTdRheSswI2QrmbMRlSaUb9V
	 g271a4fZWecvw==
Date: Sun, 13 Sep 2026 19:49:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
Message-ID: <aqbwKLwMss-UG4bU@gremlin>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
 <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
 <20260913111700.6de78b5834842f7dd3f12d07@linux-foundation.org>
 <aqbvFtlXd3Jdnfbm@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqbvFtlXd3Jdnfbm@gremlin>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: z3srtz3ps3e48ns5p9cdz8d36j9zc75f
X-Rspamd-Queue-Id: 995C81C0004
X-HE-Tag: 1789325373-850978
X-HE-Meta: U2FsdGVkX18TjnCVkECqQQ8rUOb15D3CnNQ5b+0jO7RGNcvpdp/UHPo1017YKyQXezQdAnAFJ64RXKBsjLhGfkd7ZUDaeaklqZyJSoXUVLvJ3QAelst9eC7zlXmLUa9n0bHsFuDB/SA4z0TdD54aV7bLJoBXHe4R5Efk5Vl6E7d6M/wNoLnGIaop4OU0lk5BKyjIYoSFD/0oEjTy7CKn2KPKz2xR0ufwBQYBoO411AB72sAyDaBtEiYw37/AAYHWX/PT+x1Q0JQzruNv0Z3o8qrtsHkaJD2VZjNfY7DNK0MM81iHaMmflvCsB1tALlKduocazIbBDTN6V10OEz7PA1uhIuWZCOMbDrWOU2fYLtUpRRgLY/HNM02eN384AmJxPempflx2diNbzbdj4p4hXUKCNw6fbuR7lJnnKGaw76/ZmTORH/+SvBOpeHwqVTjHjAnuVcsZfJnVGJlvGBmnct2gJFM1ITiy4WmXTXW5+Mm2HVEpVtY/TvUWX2OoMISxa0W5qLZxMQWbSzb01KyDun9ouA7b4rQas6YMXqJkzQs4KsfAZxu2m/D13JS39o6ltn2q44zoIUi4tU7fZadNf7BwDQ6ySAmSlR8/YSBerXME2KAxJxTqlMVcFTFCNiPznzchZGK2DkAU2txABklbUsU+E9+ghtvEaLc5RNioa5KB6KNCrGSUTssZeP+af5Owjz24ybxZmpIPqMN9Ts07uNbFLJ7mtyEphukSQobtpUBlPOmalh5hyL1jkqUsuN+GvRmbrV2gz4uW4LPxujg02D5DmWLGN8oaER9OytqEpFu7HpZ4LkQ4MuezmnChPVhiLd+7xvFL9JGd9rAlYyD96zdqJNCTYGcZUTKbutOyEAAhpUpl5jQiiyegOkUfqNPOi4AnhyBJvHaykKRY9p5Q7Ct6dYlqTls/qTpKeU6znImBO2bUhncKNrGiDDK2QFyvEzxyDs5MKf5P4LTQRZn
 H2w8Wja3
 ePVodxfJaAeLkBMZmnttZj+0r3iiEFkoZFFmDJwkOoX+tPJainFp82LwZthRhpK/57spB+e6/GLt7QpqD0E1Y23vhyu55bluPLpmvjyczpRHOXKiQOZ8TisjT34QCHy80CSSoyIp3P2rxU9LiJ1ECo3eI9AlDfnz39IOXnEgELf0FAvrGCY2q7W7l8QyOQP4uDckY7a8WXc8CQC6OsCF/OxZ4mjzQRBLLeNfWN3jS1pJmQPJaoH6B428rXawbT4cP/ExexxSF67Gzu64WsJ6sIa05lDwidq2RSYL7FVP6uH8KH0weJhBmq0oFkEH44UaJ1USquxYI0OMa+KSk2PUjMwdP5BIJooexqJSOMdFKdkcO6W4hjLyBHYiZ9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 13, 2026 at 07:48:44PM +0100, Lorenzo Stoakes (ARM) wrote:
> somebody who has a

Ignore this incomplete thought :)

--
Cheers, Lorenzo

