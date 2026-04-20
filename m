Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9492AF5A8BC
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 22:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B9C6B0088; Mon, 20 Apr 2026 18:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C596B0089; Mon, 20 Apr 2026 18:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04B26B008A; Mon, 20 Apr 2026 18:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC0D86B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:01:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45A1D5C378
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:01:42 +0000 (UTC)
X-FDA: 84680306844.27.777FF17
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id 41C59180014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:01:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=OrK2czLL;
	spf=pass (imf24.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776722500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPga7OWVWK9CPNc1ExRbZ12sx0lmboJVe6WZzRlIwEA=;
	b=5urzaCexzQhVUZ0v3RgKpmoFWaKvFtGtv+3S6MhDx9beLUtEgPYzaiMlcQE88oblD6DbjK
	R33nxf/kK4V/afcd0DESL4SBl7XrnHsAUvWNXGx3Ikeq/yn8LdEzT14aNIHHTDorvjd6E+
	YaOCYLo+AuTd8BNPSCclIA0Vj3VCaq4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=OrK2czLL;
	spf=pass (imf24.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776722500; a=rsa-sha256;
	cv=pass;
	b=iCfIO5XwHXYOkbOCSEkeYM85hcL6SIoyymD5iNhy5zOfKdWHrEHyODIwWL2Dixyb1bwfur
	EN5ki+BEhii089D25K5dDwuS8s07ZbWvK+QgF0p9ngCoqFrl3pjfxjYn7VlC81UAO5Q1cP
	xShjgLuVRx05h5IBB82eQ1Is9Nd4WOY=
ARC-Seal: i=1; a=rsa-sha256; t=1776722462; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QQeklhOmcfQhHpOqeaUrQlrqN5TpzD2cen8E28/xq6H2D15Mxc0X4wPRWgh9KBoF3wqGDo0eADFzBDu30roffMVKJ4HNumzf2bHuA9MsAhMXqauQvwwJzkgFbIixv8Xf1EB45Y0AQ2cHiaou3cthT5yidDEZsJi/egTXBJsBJOM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1776722462; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=TPga7OWVWK9CPNc1ExRbZ12sx0lmboJVe6WZzRlIwEA=; 
	b=jitmWlwk0j7ZXbuKE97fyK+apf4tGpUAYU6LvTt9HCmPbYcsQ2guUA8n0Q18LKTB4zRAFFa/X8ssRF56VuDGqTj9G1cT2PAhcnmCcjcpwyOe6gocDX5MLsymPTAXebrgBE35pgrmBisc0oZtLmm2R7ZmgQ2HkwulqIFv7Wk764I=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776722462;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=TPga7OWVWK9CPNc1ExRbZ12sx0lmboJVe6WZzRlIwEA=;
	b=OrK2czLLpJYU1niTRrDc8XSf7Zqz0lh5XicgKJ0zfc66Qn/xgK4pulG2ZmsmC/Kq
	2khVp8yluTwHsUHDT7G+x73kMh3IYFOtB6U0UqrKq/iIArvZEfudrHhsn82yLVK2aB4
	bzaHkSe51YMSo1vFgbEjUxQUzNyN4jJsqlAfP+Ws=
Received: by mx.zohomail.com with SMTPS id 1776722459538816.0848615690371;
	Mon, 20 Apr 2026 15:00:59 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH RFC] rust: maple_tree: implement Send and Sync for
 MapleTree
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260420201040.1894760-1-joelagnelf@nvidia.com>
Date: Mon, 20 Apr 2026 19:00:42 -0300
Cc: linux-kernel@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Alice Ryhl <aliceryhl@google.com>,
 Andrew Ballance <andrewjballance@gmail.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 maple-tree@lists.infradead.org,
 linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <81F4369C-358A-40B5-81F9-24D84483D00B@collabora.com>
References: <20260420201040.1894760-1-joelagnelf@nvidia.com>
To: Joel Fernandes <joelagnelf@nvidia.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Stat-Signature: 6bxi6wmim1bgkrw61npt71376p8ytpx5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41C59180014
X-HE-Tag: 1776722499-281168
X-HE-Meta: U2FsdGVkX1+ns/FoFp5jciwchgotNh7zBaKmhiKeJa7GMHcr45tI6Cl6GVfIXtokAcoZ9QS5sb0Ew8RedoFOw4U8KBr6d0Ir47iPcEiYrUnJbwyySszce9Bcdhzz1yNp4YLoIE+LakKQ8c4XrlSMXFqWKHHRO6hagyJqi+dYZjbuBUNWDoZ2xdgOXeewqjXNARX6ZGSlQ8dqCyfLn8CXZaiKaf24XCGnOrPD3QDALjNHaO32yotZzGng1qGnRNVQdNai7dSS2yHUkx33TRzGvUR+k6ywc4KSo3eqdBafGrvlEQhY8ylKNtlkVEUdiRvxwlYS3hcRag9uXhALmMAERl4HMFTCGHkANg6Kq0y9QzUdv5VsAxS+RLoXZGA9F5QsW6Gj5kDH9densRFbQe1IexFfoCDbA4bZ5Q22qWWqscvpmDKoTdJmYTm1DWLQgoP1c7JqvPIG/vEcRq2WfWiLXJ9WhLj+FJ0uN9Lsyxz1OB/dObvUvzQZ/KX/uUqWcTMYJiZLQkagKtCTO2JlCZ5ElGPV+kP2ww7lAh91VwHKJzFv3Zr+4ywIkqWLdt6N8QL6t1li+JzkLa1YhrUPiv8GKMVItcC+76arjVYEf5wtuM2M3TmZ4rewEg099DB/utvqY+JPk41pu9LcJ3Rp8yfsuE0k27Jfw2n8MlQXNz1lK4SgbQasnm2ewQp0ZiFZoS2FObxRT7fGAlfCtoxDUcT8IiyTbst/j++709Y+dO6PevrA4nouUufWptZdz7tYrjkRH9K4QpFrQh6rRZv4SmmPqnofKj7R3PcoCpFwd7hU/HrNbgxXLuo+zpcSfWfQ9WDpV3RFoaj43r6JT+wn7cQlJSwAP9qBxX+OK8gD4KN4tf6Y9spgyLiLSZ89mM/TQUTV0QykOBBAwGl08TosglQ+MoR1ubbPE+KoeS+SPitLFNy9SDkwiK165P9HGQ30CzX1iFCRVz3uXLXNtrYcB7B
 mMdZOslT
 QF9mRNhtVf8sZKCoWYhcg+WsW57A3j6tm/VYMgDaCaa+98+RRTgcVYPWMX1muD/6ILHT+e5uxekFklqRjP28L3+IA0KicmJgKMwJHn6C66blN5Q97LAydStrtP55qubuEaT4TH/f6sc1OnnZ8cMZEOEsnZJNbZLD7xptG7p1uIfYN/4ihjylaUBumy1QSTs8sYW2GffDKsigHjEuKjGL8Ips305ngnMPER1Z1lLPu7CX3B2dGialcvNpKPoI4eHVrzmMlZbEVlmUe7cUUlYkrDbWOS0+YZ8erW0qP3S69BvvLPbrSWe1+YJ0K3UOstIRyazk6H4rF+z0bwgPncxtJ7zAXuZMvnQsTDbtnomM8VHgaHkw/9+EiFWCRd4NplhR11H1KlNUAvJk3ueLwzZCZnwx3sTCZesA6yOZnDaAq1ds6/gZxXQ25tgtON1z2PvwS9lmb91lSyO3yOOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joel,

I think there are others in a better position to review this than me,=20
however, while reading this patch, I noticed this:
>=20
>     #[inline]
> @@ -302,19 +305,31 @@ fn drop(mut self: Pin<&mut Self>) {
>     }
> }
>=20
> +// SAFETY: `MapleTree<T>` is `Send` iff `T` is `Send`.  All access to =
the tree
> +// goes through the internal `ma_lock` spinlock or via `&mut =
MapleTree`.
> +unsafe impl<T: ForeignOwnable + Send> Send for MapleTree<T> {}
> +// SAFETY: All shared access through `&MapleTree` either acquires =
`ma_lock`.

^ Missing something here? Either =E2=80=A6 or?=20

=E2=80=94 Daniel=

