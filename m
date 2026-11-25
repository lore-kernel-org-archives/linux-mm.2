Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFC1606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=nnB1IeP5
Received: by kanga.kvack.org (Postfix)
	id 47DFA6B0631; Wed, 25 Nov 2026 07:46:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42DCE6B09F5; Wed, 25 Nov 2026 07:46:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31DDB6B09F6; Wed, 25 Nov 2026 07:46:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2516B09F3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:46:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07457120E1E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:46:55 +0000 (UTC)
X-FDA: 85473615990.22.5F4E11F
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf24.hostedemail.com (Postfix) with ESMTP id B28C6180005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:46:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=nnB1IeP5;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf24.hostedemail.com: domain of phasta@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=phasta@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795610813;
	b=a0A9XE3XJY1l3kh9NVkTVU5fOjKA6ZqdYm8vEUsDg48SfBqTRjr308BXbD90LPNGV9Fk0E
	wk0u474z3y4DY10fRfVxHk6p6lAJDQ74umkCECqDeFbXEQ6jCJp0i6ThI4rTjTF26X9rwx
	hNuhu44Ci6oqCVV+IIEp7d+QU7L5pqU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795610813;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3MOwzx9XuXBLF1Dj/6JoALu/Hn/CMkytQ7thbURciM=;
	b=fOHj6381Fn9YPlkD4cnU+Gw9tjr7nmwe0PqI/+UcCo70OM+PnarzoTP+uOP9k2VkiuK1kG
	Pz99bd3cU+QlzHIlAKKTlFBbOSIyQE961oOht267ai8U9cfEhijEfiShJIlWbMHelI868a
	sj+iqKJLtVGx7pxjFwf8/tdveLgIw/s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=nnB1IeP5;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf24.hostedemail.com: domain of phasta@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=phasta@mailbox.org
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4jZKF606zHzKmSh;
	Wed, 25 Nov 2026 13:46:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1795610810; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3MOwzx9XuXBLF1Dj/6JoALu/Hn/CMkytQ7thbURciM=;
	b=nnB1IeP5yjj9ODqIsOpsLIKLZGhjixC8mZZ8P6Pbd4JOz7OCHCf8y8Cxx5uqGFs3mTej4g
	lnCPNfU0kgGQsm4vt2wZKbCI2gQ8oomYEn9KDtInhmY+LMuWVmv64regr2GUW2OdViCx0+
	dlM+SmMzKiMR0AYBXicyIDWEE/BtVnDiKWdX3JxwEWDxiWxwKebFZlbrdbz+ipMw5oGenK
	i6B/BLiUbNqBkCUYMZEV7ghI+uLMHv9v8IiR4zPRTBrt5aiypfIGh2fW/OBesI39Ksbgpd
	3gkCb8qtiQaBbJ9NkCCuSdjAPToBXdDizAkT0aYucntdq/f51divrZwalsinfg==
Message-ID: <a6110f748b76b8773e0b5c9cb449a3bed0b19f36.camel@mailbox.org>
Subject: Re: [PATCH v6 00/12] rust: xarray: add entry API with preloading
From: Philipp Stanner <phasta@mailbox.org>
Reply-To: phasta@kernel.org
To: Andreas Hindborg <a.hindborg@kernel.org>, Tamir Duberstein	
 <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng	
 <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?ISO-8859-1?Q?Bj=F6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Alice Ryhl	 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich	 <dakr@kernel.org>, Daniel Almeida
 <daniel.almeida@collabora.com>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?ISO-8859-1?Q?=D6zkan?= <work@onurozkan.dev>, Matthew Wilcox	
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka	 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Hao Li
 <hao.li@linux.dev>,  Christoph Lameter	 <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin	 <roman.gushchin@linux.dev>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Daniel Gomez	
 <da.gomez@samsung.com>, "Mukesh Kumar Chaurasiya (IBM)"
 <mkchauras@gmail.com>,  Sashiko <sashiko-bot@kernel.org>
Date: Wed, 25 Nov 2026 13:46:44 +0100
In-Reply-To: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MBO-RS-ID: 4eed8370bf969ed1124
X-MBO-RS-META: ssgee3yfec9ykzuo1a3ycdtcq3w1izm3
X-Rspamd-Queue-Id: B28C6180005
X-Stat-Signature: uh4ue7gto65qx1gpb7x9yu8r9mmr75a6
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795610812-331862
X-HE-Meta: U2FsdGVkX1/tYHiEpl9tVK89Ec02LGIVLbhWI2MY1+miSvYFQ3xm+xmjfasgFcD1lUvoTm04iORJDUhApAxHEJngDTGBf7NdUerZrk4w2bY6ffyd9Q/VXI6xVQXpftlviQVLlqxIvmDVadQ9k6F3CYJK5tIoc/5ZNgMbJiThnNlNZck0vTqTso1R/B///74coBK5O1mpQmWVnQDob9aOdjwy2mjMIqr6AlpciIgk8/uwfcdZF60JCEWuDk24qs64FFqi8SeZzWNZQc/kZu0enPFG2RPI3WNjZgagWsScVic5tBhLlrsMSZvTZAmaqprqkbikwgWH8fqeeGUr8lVlbtYgX7HhnChflnTnUwZosdKQw3dMPqpkpSnDloya4yxCOd5+PV3A63PNpb3KFY+gk9soOJ8U9JV6WaYxZN8WY5l4rE7V0WAseAjkjGiBEGQaFtd0vn7I8TKMIPg5xQIMsZ74oCtUFRwtkxDdYmTdCYu6j8twtnINdQPCrY23RWqBIOl/TSTUSwJRIhCD8TM+SRe0rdqazu0kEH5H1m/Fq1o4p8xlIHMW+iySgJ7VYlrlPhQS/CelJStVZ71zSbsQvNYBHbHfrVlgggYZd/EEOQTSF4PoaBcmebcaZ7uyzU8whbyaVqzyIYZkboJlom11UGsXF8TmLUil9wO2woek4SuV0NWwrdeuRGI7n6HP//96l7fuVm+4Z/2eUCrITXf/RqU3tITpFBqjfJ9wXY9L9AWdIQq/dB8Tv1U98Q31oTwpPKtee2hiImCk80oudn/wQtiCUhHUjibz7Ob4mIGE/LxiEuFzJy/W0y6wsQDmi1U+LSPI075KjE6j5677oxPgOQ43zNI5z89BIabSDkyRg8eDlDkJcgz/BqhH1+CyNBlzx/m8La6HKvF2Ir1PrhJt/gDkE4fgpW5b7Z1OE4RvBvxwEoDzJ6M6QnogoTBQb/rG5zUp0oEMD5AbqDzuEIC
 SNkSDW6q
 g/DmUzsgAjrGlhX4gs1O77aUXT8K0gpc+FP1q9IfJ7Z8uByABQwXhiCCN/YxqURUoHQ0jmmH9rrsQVpvD/pTWuGK6YWyw4JQABfpgIeaCprrRvRGNd9DlIhLxSurmDhS+e0EBGZZ0IZRBBDvCVKWZCUY1PvtWpG+2XU52jNwnMl8UVKZ6ROu19dHdjCI5gqmIoynRrNFYwYZcpnh/qK2vjL6kfQa8AEwSN7SPww3QB2QhA7zvTk5Zb0cgGVQ3ujb/hy9auEm+7v/NIadnI4nvmMJm7cRAXO42GIyoirh9Vh1ZEqIm072s9/BfR5vshLstfrkj7H+GrpdpMorkuAFUPrNP4lIo9CveCp5cv1duuhnf+8zTe0Th92ZzolPybEmBFs4i84gstxkchgxfRG/cZ6UnP+E6YpyI12QMD4+07zLtvYknyV6J+lYCPrn4Tk3CLUlqT2NEAfJPYsfRpdTN1dpm1RppPLl01i7QkwbPLkIHqXiys7+AV89ohk5rS4L4S7LXQvPEwoOPqUwzD2FUb5N2OKJ9OwNWEwL/70/iRKPSn/6OMnWNBUam+qFiY94luYr/ewDcM0aXRT/9RfdPCq90SDISygOnrWd9KIDkIaQq/Sy0as8juTtsqntdtmqnoKh8kXw6l14Of2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-11-20 at 14:10 +0100, Andreas Hindborg wrote:
> =C2=A0- Patches 8-9 add support for sheaf-based object caches.
>=20
> =C2=A0- Patch 10 enables sheaf support for the xarray kmem_cache.
>=20
> =C2=A0- Patch 11 adds preloading to the new entry API.

Sorry for my ignorance, I was out of the loop here. What's actually the
purpose of this series? What's your user, and what is it going to do?


P.

