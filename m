Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93CF607B5B2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mzk1.dev header.i=@mzk1.dev header.a=rsa-sha256 header.s=purelymail1 header.b=V9KuuWcN;
	dkim=pass (2048-bit key, unprotected) header.d=purelymail.com header.i=@purelymail.com header.a=rsa-sha256 header.s=purelymail1 header.b=oBQ+mx6w
Received: by kanga.kvack.org (Postfix)
	id 9DF336B05C3; Fri, 13 Nov 2026 12:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968336B05C4; Fri, 13 Nov 2026 12:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856A86B05C5; Fri, 13 Nov 2026 12:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EFFB6B05C3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:25:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAEF41201A3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:25:39 +0000 (UTC)
X-FDA: 85430772798.23.D1E2CAD
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	by imf16.hostedemail.com (Postfix) with ESMTP id B1FC618000D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:25:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=mzk1.dev header.s=purelymail1 header.b=V9KuuWcN;
	dkim=pass header.d=purelymail.com header.s=purelymail1 header.b=oBQ+mx6w;
	spf=pass (imf16.hostedemail.com: domain of mizuk1@mzk1.dev designates 34.202.193.197 as permitted sender) smtp.mailfrom=mizuk1@mzk1.dev;
	dmarc=pass (policy=reject) header.from=mzk1.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794590738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5VCnw1Fvtd/Gip4papkzUmc4LWV8dOqyxkMmZU8NKA=;
	b=pKNuTJcXVQZPVDKFjD6YAZ4O6ENuAcXlBECaBUBptouU8eSQ3zZ5I7tZRDHT+LToEJuGp7
	+t3hDh0ACGOYjxdCs38jTDDCrMqVaMvBVGSauyblCQ6kcPwTCOGRurVsrohyXykc7gp1jZ
	CquJ7y1IRTsynEdKjqnv7U35W6nPh1w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794590738;
	b=uxaAVdMtkp2B5SyspOE7KdgOfoRoblB4ZoH8uoPwvShet6NNyc+ulqVQqVKuh/Dof/KFOb
	5BhjmJnzL7bnTHPfECY5TeUjPyZ8cM9ZPaBo4Oak+HDulEAHwuyRhSSucUQyf5JH3sBn5O
	ZT0S+73AMVTDjHB/qmmALAnNURGPPDA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=mzk1.dev header.s=purelymail1 header.b=V9KuuWcN;
	dkim=pass header.d=purelymail.com header.s=purelymail1 header.b=oBQ+mx6w;
	spf=pass (imf16.hostedemail.com: domain of mizuk1@mzk1.dev designates 34.202.193.197 as permitted sender) smtp.mailfrom=mizuk1@mzk1.dev;
	dmarc=pass (policy=reject) header.from=mzk1.dev
DKIM-Signature: a=rsa-sha256; b=V9KuuWcNuAVuhSLxrM/zeH0iiGGKN10vfTI0UZhwRvvAXLJHa//5AtkMwwsG3gCGAovoNsfB6hpYEgc8leoXQUGc3/8p26yo2AbMKr4N8FW/LOA31BXHMALHMZndryJ2bRblSLKlBru7/L/NZbQLm8yERMaTSjveV29YKeCTjzf+qjX7/x6JEcIHE9QwVm3ZDkAZS7rWi8D/Qznheaq0uy5AgjiKPmroDRTyP9YEz18ufg+fiHWGBH7IAOQ17MbVpb87Se1RL/+ZtlaB87gz6kg6Ds4oy7V6p30VvgaGUuylpVDc7+iuQMOhq16oi1WZpPlYZWcX3X7mn//U+cIbng==; s=purelymail1; d=mzk1.dev; v=1; bh=ynwczMvkRVmR6wZnOkUfy2B4rEh3V7zlSMQ4smUy/aE=; h=Received:Message-ID:Date:Subject:To:From;
DKIM-Signature: a=rsa-sha256; b=oBQ+mx6wIpb4CdkjkexxCs/iwcIZEOxTo+I8V5tlwLba+APf1rElu5WKFdEKmnjGvdpqlSSej2wWvTauBnYzXLqM79/MZEufKvzA6xs0v2VZuhX2FXil5DWPzI50R7Q4u5YpNMBA/h6LC4P0SI8GTn0zm4nKzUZGXswVt1cLxlg+thzmy3PEVlJFZO3hbOq1K1U1ODu2dVfCz02GpjItX7O58AXnyF2ClmSKz3YSxMxXvMH5ARUVFy1NZztWH/HAPKhtjeu0PrnjzJXt2JyRVzidyuPZ+E5JjJIWM0tfmotnFkx1WINmVcIJWMovcO0H/GvvKj2+JeSXvK6QXkbvUw==; s=purelymail1; d=purelymail.com; v=1; bh=ynwczMvkRVmR6wZnOkUfy2B4rEh3V7zlSMQ4smUy/aE=; h=Feedback-ID:Received:Message-ID:Date:Subject:To:From;
Feedback-ID: 1682458:65466:null:purelymail
X-Pm-Original-To: linux-mm@kvack.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id 2110463954;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Fri, 13 Nov 2026 17:24:17 +0000 (UTC)
Message-ID: <3246e50d-2489-4a79-8a72-550bd90fbd90@mzk1.dev>
Date: Sat, 14 Nov 2026 01:24:08 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 83/83] block: rnull: add zone offline and readonly
 configfs files
To: Andreas Hindborg <a.hindborg@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Benno Lossin <lossin@kernel.org>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Boqun Feng <boqun@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 FUJITA Tomonori <fujita.tomonori@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>,
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
 <20260609-rnull-v6-19-rc5-send-v2-83-82c7404542e2@kernel.org>
Content-Language: en-US
From: =?UTF-8?B?5pyd5YCJ5rC05biM?= <mizuk1@mzk1.dev>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-83-82c7404542e2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by Purelymail
X-Rspamd-Server: rspam06
X-Stat-Signature: 39txn3hxifyah8knnh3rtqe9txrxr8od
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B1FC618000D
X-Rspam-User: 
X-HE-Tag: 1794590737-542903
X-HE-Meta: U2FsdGVkX1+IPIEfe2mxortk8hRM+nA03lZChTTepYtxRo+Ee4PG5SwQpwaKXrwGhFiFza0kzbcJVXEboMRAUCnLRgTaKd2W9pF0FJJop+l+7/jTIvoysEnoS6aojnKgjuU/ELHIbgF8l9n4KAATNrPLaIQOUznlCnyBhmUYDTSjePWzE8XCrfX9dWUW5vKdeojZkEmcueF4VTphn+/0xyWXz95YvLmZD2UfACHnvUxX+OUyVva44vufD8HQXF3BkJI3h7/kqSH6PcsbeNYHEpHgLXHky0FcJG5odgcdy2MSJS/oFC8yxetobuqGu6I73Q4CXcYRkX+9eTQhdY1aN1b/+ohYLb0eVTLjzMxX+OFdjI+9OhGtruaztUuS+Kv7clZH9n2b4tUZUWonTd3GihgiW/4cFiP+FLClMuI5wff1C9fg0xLZl/ZbAPi+FEugYylrtR8OkkQ6IYU4dfNcK1mj02iKYjNsqq3wdI+hnvvky0JX8mrIK51SxwB7v4syuZ4KDMfOTg9IwoRXHo/PeinT2yzMauDD3gT0IfO8XE7Un8vMG1d0S2rtv99wZppVucM1KcIYAxKqx2YMwLD+SkwcJcBMPc/hGinsZ00qoIbC0QncgISvpfLc1ds+XDziClaUf9tP99lIuTBlnyK6AHIGS6eIxEHRiO0M8oqkvFGfSX8VBt4DPqUrGoZJpHaYB0Y6z7cciuTa40lIOSdJTwd5ayXrFIWJ9NZSagRpJGjBXbzwrncf4Mw6uNh/sOlia0iJdug/36mZfjexiYzq0RvMj3KGzPK7LEy//Wxxfq75YYPvR9xzupc8cwYwFeL2GWNuaNGRa2WURmdRDsPLIOa0WjhL1OPea1zzwU3hUk/7Bn2vNSkySXGUqQszLBq6PtOjirLF6dA7prAdA9R4atdp8BY5b8mvmkzAon7guIEyFtfWOmz1eYMdU4U2BI64UVn406TJz6S2+pmmqdy
 abljIUbf
 KWJvQZzwfNw5/heqeSxkDJwm/EWLPa1fSHNUaT6iWOVoJ5lA+HSKHLQlJW4kScVjXMTlsTfF97knJOI7K18EyCz0T5Uti9lYdJqpJx4E+pIr+7ZRvXJelgIpAN32DAmIsJ6pVJzuoef4hOjJ5YH/gynrJ/DxfalG6lW1UmVymnJMqbkEQ11qVZ3J5vAZg8BmxORb0XHmQjaxDHFBTPeTSZ397TZD7doV/2xhR319PrWr1e6WEQheBgl5p+aS4hzT0VbwcQtRTM2ekwwKlogNYlFTulgyyeH79lk+IoKKKroUSLtdXAKmOXQSOFVMtNACQtMw82JjBbylmxoPcNQ2NX9zbrx04sJgoH38XZCpjH9ZmNm8+B/LRST0hjVGo01d+f/ZYeluGqfAAap3YU3hHzdb0wBC6DX82dB4MkgekB+f+fkSsNkXYu2HMh5UAf0pSs8EPXYPpdyygeEUvk7eTxdr1uLjavlgDaUoKrerAvoWhr87AKL8MCoc1q6bQQzcbs0b+Ctto+0M23fz0v7/BiFTDj+sgLUS9MobeVKWMGRy7Q4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/6/10 03:09, Andreas Hindborg wrote:
> +        let mut cache_guard =3D tree_guard.cache_tree.lock();
> +        let mut disk_guard =3D tree_guard.cache_tree.lock();

This takes cache_tree twice; the second one should be disk_tree.

Best regards,
=E6=9C=9D=E5=80=89=E6=B0=B4=E5=B8=8C

