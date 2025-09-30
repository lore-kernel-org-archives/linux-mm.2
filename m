Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C73BCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 18:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB70B8E0007; Tue, 30 Sep 2025 14:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67E88E0002; Tue, 30 Sep 2025 14:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4AF8E0007; Tue, 30 Sep 2025 14:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD5B8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:21:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 131D41A07C6
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:21:31 +0000 (UTC)
X-FDA: 83946734382.12.5871196
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 58662180006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:21:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kmccLfyO;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759256489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwEooso7UB4uvU9qXLs2IsB+imcyTGiJPLUb2CDC4+4=;
	b=OrcoV36D3xuDMsUW+ikiAY3/VxLE3uwyZB7yivJh+D4pRSrL6Tk9j5y4W2AJ7Ffh9FwlVT
	pVFEZ264FcuEfyf4RySUK13a+Ov4sqsXaFYB2lNQqpOIiG982PjLIX10vVRpY/VYYxE7vT
	Pjsn2x5HKSx8APb16r+f4/ERWGoEjao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759256489; a=rsa-sha256;
	cv=none;
	b=4Z8V4pw587mDORN9mtCxVZ5+xYOl2dubtQtmHIo5euwrPgGjMEuYrsBYJDett+WEEQckEf
	f8In/7tlXbIzm40SZdddj41rx9H+NFgzSg2Y8pBh8z+Da0ElNg98Z505bRnPqdLzVBJRyz
	GIv7xH2UGz5hxxFr3LALuJ5g+PeyrVA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kmccLfyO;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EDFDA43B06;
	Tue, 30 Sep 2025 18:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFA1C4CEF0;
	Tue, 30 Sep 2025 18:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759256487;
	bh=kzIru/P5sR9WKJSccU5qPncNb7rq1RbhEqJ6aCJhWG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmccLfyOjnzmP6CGeSAGf3gKD5k1PUKdiwlEWP5nftxk0+LQvNDENjJfXztbHpqqh
	 wSp4bF5DU4vYZcOTtjWTAGGf7oruLiMCFh/2GwhNlNhH1ZJAZ947cfgEr20s5Rdnmd
	 Dz651hgXd2jcMyJYNlKkUtAXdJU9cn1DgCi8/Uj4NZMkjYcjSO82HMiGUArYO0Vcqm
	 nDbVw2fiyU/t60r4EcjllCuuK/E8y9Lg9c543XiD+dUKTOblOpOjplriHL/w2GTuTa
	 YmF24Lg6pBxxajBvg+aRIpwu4ffiQQwu5ZNzmSUC0iEiGNDlGkWi97ZXFB2qATzBlC
	 gtuarc8qI8MzQ==
From: SeongJae Park <sj@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/ptdump: Replace READ_ONCE() with standard page table accessors
Date: Tue, 30 Sep 2025 11:21:25 -0700
Message-Id: <20250930182125.45150-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250930025246.1143340-1-anshuman.khandual@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 58662180006
X-Stat-Signature: xxeu6sz5pn7e7y6qz1fd9tkef31hcmru
X-Rspam-User: 
X-HE-Tag: 1759256489-951440
X-HE-Meta: U2FsdGVkX1/75kisr6fL+oAQp0Oy9SWUr4pgLjME3m5KG3AWGDzC8MKDKCU2Mx1e3riQNWgyTBJ6eLz3X4k4LpVn0nFHvDHP/wZc/zCKKo5BhD3+fZLFEWVW9atlpMhGEg5vCsZ0iqqwqexr9zCCHd+Af/qiUe18Qj/gALtPd6Urz0EGRyE/CB9GIJj2OZCM4DbOYuKsnSx9rmYlCWNk6aYFVbnrDkc9+DOFGS33jYt+7rFLQniw3DBwyQD7wxY6QVGDkPJJA/b5GphPgpjEsuw3eSDZJl9kO5z9fQwMxj9IwrnFPonObimCN5lEL9T3TZDqOXvMx/kMROEaWfAtNpc6YFn6TJ9cpsOdxJgcPwgPfzofdMjeKuKts0TaDq9E+zvkGtFZegiWfN07D6iDnM1Gxb991g/1pGz/Q4Z5r43m0/1Zm1PorMp25ZfzMRvHKyPYko88M9zASWp49wA4nPZmvf+4OXAj7r4SgzpuZV95690Dd+WLlbaY6zURmFbtqTrdSbQicKPLyEoloFa7wn7IXkof8Ik6mMdgHnORZVZ/Jk7OATbVV64o88ykcAcK61BKfSB28Z8qVc6QHPK+KFe+J6vFgZlfFj7MCOneQA/CeTOLKgdgzIKAlI2ooUDNOp6OolldBHm8N6cQepLrz7k1qfqEnJ3nycVnA0KLSRecebNxpbKG5t3cQ+hraWP9svaVBlfNdl05GPGakPQRhfB1kLSAnkkcOl4aS+06rh+OECAP11K9rdbf4hO5rzq9kQptGZtPmCByTFECU4OM1Lib3v+wQ0PuKQJoJwGrIqeGb6p5dfv0i1YJPdN8E48cPu94Djp289OcJ5+4YoEWouZ/24AawfOb7Ah6JxTprlAkERV749iUGphxgfxXPzHXTx7uElX62mEB9KKacZOoZQhOCDVPFyeRYd3BPqex/sCxypQwePtX5sLO5DNiMrIoKCKaemrW91CVfK3X9nj
 nFktWWRb
 G12YVMr2bMuNdtoWesvdzdG+QJOQNG8JhPNesFJ2y00VJVmQ2z8CbvM/axgx+jptDIO+OjLxV9pH9I7XgNyE1XoNI6iNY9u2a3CzF9LRL5D3ZwduWy0akR8gEDXV1nt140ugBJy1IDA3XRb3cufedifbvIZFrWdThYIBh3hvKW8j+JCP97SEY0VQxhOkWvF1dsFhLiFUwO2z+e8nmtmbcv1ncRZQlrgdWOKBIKSqA5iOBq0BBJ/8IwZOkg2xDY8gfULjreyFvFiaLJSpb6Yolgr0bgcCQ7oRDZ7gs1l+L2yQJ0a7nF2UeSMpT3x9tvQD7AVJxJpO2sHFXSHgIP4J1PF8JASk5vx07rOduWQhiNUMXhost18BT9obq4/WKQ5Ys5lULOkWEaDEDWtlaZ83ZmUccRFkS+wBxeS3NvB7JPcvAQAsWb6yRlcw2f6d5LJDIHzVk/XqpoqoWGPI/b4PHl9F1+mwIKNUckEtt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 03:52:46 +0100 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
> anyways default into READ_ONCE() in cases where platform does not override.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

