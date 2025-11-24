Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157B3CFD356
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 21:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DCD6B0030; Mon, 24 Nov 2025 16:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545736B0031; Mon, 24 Nov 2025 16:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481846B0062; Mon, 24 Nov 2025 16:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37B6B6B0030
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:06:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 211D0BA312
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:06:31 +0000 (UTC)
X-FDA: 84146734182.23.3AE2A66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6338A18000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:06:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MneGRE5Y;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764018389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7qYtJrYJRKGxi8ghkSrcwvZjZx1So4i4QZ/eIheda8=;
	b=RwD7E0q/+04vJWqfFpRb2h5LF4FTOpKzW0EljQQl7yLo9Ofh5mgqeqTMSgf6Uf7odMPS/o
	Oo7NxKbhOHqu9tMpz1Kh41Nis9ik/cStUu65bcxf8i836bekPE72zGOX9srwhzAA7n8LVg
	y9PKfE/E6ja7fohhgj4rIRRxEKeTh6M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MneGRE5Y;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764018389; a=rsa-sha256;
	cv=none;
	b=6mlYkK7+xOuQNNeSxDaySyGTh3vUT5ibjOsdz2Kb4XixYivmS7VEcEB3aKUL/ErUkwgjXU
	Acd4lIx/VDIcQlhD9c+cGbgz0InZcMhi0Ste0VgUQV3amok6FFM5SZ3fGmKuzVN2KrQ2xX
	tDH7g1LHyDlRXwLZrAnMqhTf4NwLXUc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 704EA40526;
	Mon, 24 Nov 2025 21:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44062C4CEF1;
	Mon, 24 Nov 2025 21:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764018388;
	bh=5ZpbdBOEme5Ef7yD8vxuIFpt/rRhKUZ4HY8PVU4Fpo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MneGRE5YfqloYRWYJ2L43A3dMy6bQMkj7pqpMXSmicTWkMJ5kfBym8XFudRcYX1TZ
	 dfrifPk9s8kNFw5Gz+tHGOuonOz6/ok9phUhrrW4aOY9LlVHuHTkSRSxH9HHWVDUvy
	 9tBZPzDEnDB6d3cw3eCiCnxe67B43BAZK+x18CiXY+ZojbNPy6IMp5sWISMjryaT1Y
	 i8SqeV+0wTyFb8ZLi5IMMmwCdScm7Yr7qFPSC6LjomBpY7Tyw3YY5ViZ1RtS42UwEC
	 Rk9nmqQVVWF95lepBqNkbk0GAwPSgELQmPrUUxbH2ixDwrJbbn1lfxAo6L4L2nL8xR
	 yivTaa1MknR8w==
Date: Mon, 24 Nov 2025 13:06:27 -0800
From: Kees Cook <kees@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 13/16] usercopy: Remove folio references from
 check_heap_object()
Message-ID: <202511241306.525D3248@keescook>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-14-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-14-willy@infradead.org>
X-Rspamd-Queue-Id: 6338A18000C
X-Stat-Signature: 4y7p3kjonbihcgpa7grip64tb1axz53k
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1764018389-550496
X-HE-Meta: U2FsdGVkX19n3EUEWtQqU47EDLzTNGMbaFZtcnUlZw+xfHZT/eeAoT+t4Tw9BW4xEE/G6bncyGMOWbOa1WxZ1voG+l8gnmEEEJBo1z9557CCChqFDF7Xd1JZ4ReTIUzulNqRqDRiDUJLv6D6wHorLtGm2JcX6ZtrEMmn78oKYObd/03c8aaHeCA1pKrK61NRkvjOkmqt3CKT/b20/HIm7yiayKtFdJ6AUuRQeQpsH3/89GSAtNv4imrFP0S2pyj1DDjMLCsQbKkWX4nxlPK6w8zPxnUpYkS1OAhE8Hnb1npct2PnJHaIPbI/g3oVLnz7+fw0YmomhHwSJvZDhCBciKy/7fi7C3dTkZdIqXSkyNEPyIxzHmnH+lKxSNiRGtoXj6RujaK48sMIH8lX35SkZDLDMy9grdPWOdSUkvd8mvqQRcJRlRbk19rdDNjtoyCakAYg5qiCzaHX6AQN+LeqpbWOd6SW0E9VUmpUi58QbqyqxfBD35HYp5PwSsRuDLhefCgR6NCdqcRW0Mqs+VAzdPzptTv/otk4A0J0O0dazUzkXsIB/GvKpKRyaRPJ2wuKwN/zW74dccsfup2nuOw51yLK/jB2N+Zu30xnEIOIlHnSviP1gmTP+9uRkd7MmiHNggn0ynIQUk2NNcARVnKbXzjwh6iJM4OeeoN88a6VhfDRSE6xNpspdeMMmlOmBqZy98ax8dGz6bINhrpF8F3NXf4MKGsHm2Vr9OheB7UcffvrJqmzxCOCb9oI/Nm/fwwCTt/o7kb5e/U7eFR+H2hL4mlpoZGdD0QIM+wDcs56JiM9jB6/HzuyJzhUqgoF0snM9+C+2ojyK4U/DNQwLPFAcK0hUam9agPQkGOTkXUbSCInkT3FrzLlWcMeSKBzbFVGGAYZc0DJu8TqauylVXYWrihjBeWdgt9INI8RzXruu4x528e3I1t95ojXK+fw9lt0CzvcJ62CXC/IxmYqjd0
 dpoAIpF3
 t/rrqM6Z7eYxM7QHTYUNf0YSo//JHkMA+zP+oe90cSqXzsDrgNMCZRwy9nmvytfxxiw1nWsyA0WN30wB7URwhtLkPnGcH7c4l0qdkkQU2WzzDX7VAz3mO6YVhFB6fyx8u/Te8pstQQ2m2RKoW7jrBJoZesIoglwMmEN3U3e0huvmS8LIxa7DosklNH9XA44Ki+ibn1widwAFcGeLwGCqnzpTPviBsxFWYrXXpeXog0E0g0WxoB8VK4til8qAj3N0B//KZI6EgXL+NNI5HEsVTFoBLn1pXT2ENQM+0za+bZu0HqQD4SmPlZmSUQCqjA3GbqHFsRFykvtBtPq6woRrC1LOmNw3J3iAjbccOM0eqZEHdQ3mFyMBU+ILA6LYmWu9ugnwv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:27AM +0000, Matthew Wilcox (Oracle) wrote:
> Use page_slab() instead of virt_to_folio() followed by folio_slab().
> We do end up calling compound_head() twice for non-slab copies, but that
> will not be a problem once we allocate memdescs separately.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

