Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D13606A333
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=Pmk5lpnV
Received: by kanga.kvack.org (Postfix)
	id CDF476B09EB; Wed, 25 Nov 2026 07:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5006B09EC; Wed, 25 Nov 2026 07:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB346B09ED; Wed, 25 Nov 2026 07:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6226B09EB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:27:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 351C81C49E6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:27:44 +0000 (UTC)
X-FDA: 85473567648.18.468D2E7
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 32A87160007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:27:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Pmk5lpnV;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf08.hostedemail.com: domain of phasta@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=phasta@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795609662;
	b=tVE9mGLUT3CJG75ZVYR0z9pFP+24q8yIdzFis58R/sFDjxb3zE2eqMFam0YapSlgFDBQpd
	he/d5fI1DGbvQNTHa0nYCMdPU4tb3l995C+FoLhXOPYvoEDkSFZgq1oNf/1LMXedfCCH9w
	5lgd/ibBGz8mU7b4+/Y1lEu6nlLvWEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795609662;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJfkmXEGgWlf5jvEyn1umHHyxSpxElVlkFA7f2v9XCQ=;
	b=TlQnaRHLr3ix61FetlOSpW9SYjgbGBOg+e7mJrIjQfGVzBVLMmX9GLTyv7JA0j46kfCrVG
	ObXVv+XOiOY07PuWkAfGolNY0/FEDxDNkKay2sN40YDAdNwD2n5pewFO3D4fy83TPZ0mBG
	RJ56BQRjLjfAXm6gWXJ8zmPZx3ubGRs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Pmk5lpnV;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf08.hostedemail.com: domain of phasta@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=phasta@mailbox.org
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4jZJpy681zzMkyB;
	Wed, 25 Nov 2026 13:27:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1795609658; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lJfkmXEGgWlf5jvEyn1umHHyxSpxElVlkFA7f2v9XCQ=;
	b=Pmk5lpnVtSVS5KU/tqDa4sbjTFfwzYoxGv2RNZvhaFs5SwXW5I883wOvib3tSwb4oUSeZH
	HNcvEgKY8W+OxHB7VqeVjnhrM+T98Q0UsR0u6TeGTiBoemvNhLfL6wrqtupDgciSXzR1Vz
	Zvta/C9slVOa4vZcQk8cnQ3ghz+SJGnfVRlr24vZFV/Oi+hYxjuSb8rubA/FX3GeyEi0XJ
	Isuwsm5RFnFqJAST/CsVvsEiyE1UjP5f8k112jDuLoTlKcKuVglgjSHB5V7doWNZkHHlq5
	cAwrJ1EJkSyeETPpMyXfuIQDG3+7CIOnjyhpsNvqOorjiBnZTe2RYABih6j6Tw==
Message-ID: <1b9bd865e29501ce03c9800eac57fba201a59453.camel@mailbox.org>
Subject: Re: [PATCH v6 03/12] xarray: move xas_result() and
 xa_zero_to_null() to the header
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
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 25 Nov 2026 13:27:33 +0100
In-Reply-To: <20261120-xarray-entry-send-v6-3-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
	 <20261120-xarray-entry-send-v6-3-1f69d7385f70@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MBO-RS-ID: c2d8928b0c20ba3349d
X-MBO-RS-META: 5e8fjf3t8zfir3d7ux8zr8gc3j8uwr8w
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3hwbkc3ygedm6yjgfmecpgfidm8a58rc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32A87160007
X-Rspam-User:
X-HE-Tag: 1795609662-402919
X-HE-Meta: U2FsdGVkX1+FPNcAG7wizSnG0LCBbJvA57xu6TovylBbqZmNQ6oFrRALCZkwitZ6bX1sKiLopq1K37cUr/tHOKljsK3baMpya54Cv1fD3QdGG1dvx20eoe83FxLvP2yB1yX/Z6WJ8OVk5LNtOE2UQ+Brz0rKrwAGgmgxCNRQWE1F7v/KEbKPMjc2zr+no4iKTBB8J7kFWv9J45ICQYeitHbWCVnk6j4C2oOwySXi1Ui5FoSu/Y+HYuIy+8iBfqgN/mHUhsnyEh8aXBua70Lcw4wO3Jz4s5J8A7HfXp1Xe8j+zi2KC3YoBn/tw35vu+Ck6fT/8kZyByAv/yqK/PTD4JawMvn6PIT0AXuLCYccGaj1a+/l65rZZQDSueasd5LOmp5IdXJyCfZAuqaTxbYZdWrNEsxIIDwcBZUfW60J5vqo1bEkEDjr4NSlcMWwnt7lR3/dPHBSyMA/wM9XnVg00e/sSZH9k8Vz9Zwdnn1JD9iHYBiaMSOOf9e/Z8WyRxZqmu91Py77E1z22ACFvk3uRb6ZGw9LMj7odPVmp8A8OnPwxS88G5m/h6K38Kzj7moZLTe+OR0AMkW8lmz9XEXM1DojsXG+JyL2ynV05mXUpnzrGF5uefUpKsT+MFbdR42mZJvDK9M+egGLebF0JEGZDTemHxGLlV6bCV4uuC9TcX1Pm8uLQp6k33mQCXWrsic8UoasLklfHCP7Z7GJBX0cQN4hY3+EoUlm/A3CWDpLil5YRKkAVmXk9pZ644pxMIeD0+9YO/HDWrfsVe6Sr1B6ScE5PWJ1oECjVertDibbhLWC88A8YCUbYmMTThReIaB5w6yo2zkCdjWQCzl8YMi7fr1dj3s22agXy/ja7wayd1zmPpci78To9T0S5xZLFr8zGumtS8msBAY+316bJRaw0gzZmqmEd/vS7K05zljoeWvNt3XSG6rXdiBAIlC/gCUO/zDc2c5MM+c2jz1AEXI
 QWYvsqRN
 LiDvNhtVPRiy5vtbIb4qcGwX/6NaBivzVnZfpoGF0mfer6mu/Cz9PUNGHIt7N1rVr/CxVqvR5X7fh+ZZa8fX7VIFrInWS7om41h4x6S/kPnQbCiD+bpZ1Q02MFyaO76bakfjSZ4gGnYUb4sTAwxLwUnG6xgOAls/Cj2R7Xp1Zm4tkE9lx11F5ni9a5XR4VFslL1ggLk64eb0Bn4nyO/DRiLzl2dV59NVVxPd4jgh8zlIUd36MeKKt6PTAL2g/uX3pOZOmgkbSM+VPW8AeFRPpEGwJaQQwG16xlGGCn6T9+3LApG3Y4QVBreMX9AJ6CteNFjSTuZ0m4sM63D/ONgwCDaj5AqriQHao3m8E2HgHTcg5C4ntDev0yHPMjz3gw2SYLv8IeH9TjekR7B5zxx1XUZ14dt/2/mXe6H+CbfYlHn4ddyz0nybcXKq13sBTPlpSuwO/jUDMt03hxwqzT/v9pFgfEtUFCqP1IupJesl/h7PW4lAWAN4XwY/6COFcC+D0Xd7IFln8t9eabSQSKSiEUnoA+gnLPQo9uUC8vZqcaliUbQ7koikvZ7ZYxecUj8ICObYh63CW5hufofyT8GBqbM1Xg4bS5y/4fNxI1X+h8J5tcvxPCflf8wC/33qGOKSudwyMoEe3say6O5NJJeb1rfafsLgpNAr1wdSj9GXWgf4HMJ98VZ86Hnlu4YvkGJSB3e/Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-11-20 at 14:10 +0100, Andreas Hindborg wrote:
> The functions xas_result() and xa_zero_to_null() are static in
> lib/xarray.c. Upcoming Rust XArray changes need to call them from
> Rust helper functions. Move them to include/linux/xarray.h as static
> inline functions, following the approach of commit 79ada2ae6615
> ("xarray: extract helper from __xa_{insert,cmpxchg}").
>=20
> No functional change.
>=20
> Suggested-by: Tamir Duberstein <tamird@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Philipp Stanner <phasta@kernel.org>

