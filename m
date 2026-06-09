Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD8D6CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6326B008A; Tue,  9 Jun 2026 15:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96936B008C; Tue,  9 Jun 2026 15:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC2E6B0092; Tue,  9 Jun 2026 15:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCA3F6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:02:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8223F1406EA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:02:34 +0000 (UTC)
X-FDA: 84861295428.18.0C09F8A
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 59A5E10001B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:02:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aE3DSxvB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781031752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOtMs5rqZfbuAW2ldhtXi46B8R0gj+b3MU1GZP9Re8k=;
	b=sg5t3PrRTVcwzLY1JKPvtb+W+T+lM4x4WT78ZbX8bTPwFC+C/ZTMNJQMeipRNOQ2dDIsiR
	b8ZMHtzgosn/f34eiQERba9oHAVcyMVyzLxiOaXCc6rVW0VyrrUlu8fmWSzYjxyv//EwFA
	qoYtT95pk515j2QFf+KjRSnLJsIe7B4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aE3DSxvB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781031752;
	b=Z4NxZELbqCBL0HgBBYy2fqhmdymKiZlHAwvL9kMdWzVDQCLY2+7LNp0f4inpUmVymcPaND
	6PTC+3khCmhhMWQluSgRy8SeWNR1zV5UfPkfteNbHq3hlVKJHBIB6NHbQrDUJAnuOHu67Y
	C0zOVHW8ijBSQE1eBEjstdHEzZ4l6fE=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781031750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EOtMs5rqZfbuAW2ldhtXi46B8R0gj+b3MU1GZP9Re8k=;
	b=aE3DSxvBnLeIfrzT7nkodC0YGRnfhF5zMrZwdWQC3a48frXDgmu//IgOJTudrhP1JITrok
	YG1aB8ZtQP7yRtP3m+ogEwBcF4CKDDybUJkYtL7MKULedbQcEz0yCWdLxE6gOm0pmtIlbg
	AXDfRrUrhQLuL732pQLGRdld7uJ+Wa4=
Date: Tue, 09 Jun 2026 19:02:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Message-ID: <1b6509a832dba9a7e24ddcdc23fb75247b267c78@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, david@kernel.org,
 foxido@foxido.dev, harry.yoo@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, ziy@nvidia.com, pfalcato@suse.de,
 kirill@shutemov.name, ilya.gladyshev@linux.dev
In-Reply-To: <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 59A5E10001B
X-Stat-Signature: i7t43us85yyd8ohm4nomwt43g55pi6ey
X-Rspam-User: 
X-HE-Tag: 1781031752-172733
X-HE-Meta: U2FsdGVkX18urhpvnhd9zRq9HI525cTBd5I0Sjv/nLePkP1iCpHlBW8S2955gg/Kr4amXNtjhanE03EP+2jniHunevXGLBMKtQZVhr5+nfm81cPR8YPBn1TEm5/bLwg7TaJqkyB3KrmOaTZK5/4UOlaCoS2PCgdcEwRiZu/gqJl9Z8oD9W8DbkgsyZehAPWcr/fbxC8T1kHIw72FSWJrqmGnSe4a8zQOSXnF5T9t3n2pkpSzI36TcxCm4ok3N4gF7KZRvn6E/iyIjwzME8rPMMrXviCRbaAV49V0tp0o794teslnIm8da/oruuylYGLo4xu3mA0z0Io/fHUaeiR9KqPieOEzWsQ5FKE8ctBnmgmurcc0ie0PNt5pTQzvHfZXXYqUXmFyX7dYhPiQ/HDau9V3q6QPuZYQzU7o0eGqvC3tn/KQnVB0ZgOn5voI1Se7SnUflWjrm5O+pFXfd4RfQW7B2CDK/xFzzLAsbaytFjx2QsaX+7PDIUrr5kCiFYOaevTpWG/9c1PAFoM+8Sdg73PCuO79TqvtnrmBmppBg5wmfwtxfMsmc0SXpr1YosVJ7Z0P29e6yvuJmwg8xx4jss60tEA2ecf8AMxNJmfnnuXV9sw7NYw/vYmhdNO3zP9U/55qlaFxHULwWseQHmx7XlLDMyu5I9WONLH5SFiNUA+OjXaXz/ljjWpeiqp8/bZu9v1AB4TS8beMg6NS1keCmiVj2rkGGBqIIosRVv2ZnNN8LzBwqp6j9AlG9m9aV9LaR0bDwXme4aZt8e6vi/OuOaWPII+M4fShYdt2nzX734EhEoqaLBKF16e7bTWpw+i1IEQQEJ5FvJJ2JhAfS2Vdoc2/qKFBBi4WOHBXUWY59gPu98ZybDBDnJ0nJUQ4DtEV1zfQOjWFvkQMh1p/1BW0npRDn63kOS0Gcb12Zh25G7GODit4bdEszyhjp36vfhZZKvguMW3D3t2MK7NrIp5
 vDJXJGAR
 LPFZbSxg/51UfH1fofeWGxI9RnAdV3DR4X74wfPRYULqAuGIfrmiKUZlAEahrD6skHxz8OAUtK8inkVbfMDXE6iquDjwKUn2z/Oag5oJnIylzOFbPHRwM9Y875lS1TgyeARcj2JWCgELidxsvL40IS+hVpCnl64wJKFPr/WrORROreWfDjSVzUVF1hJSIyYV/9NHE4+oPpXeMTARs6DwaWm9fj5FMASmGVVfCX+ahFkvrxaYn2T/fQu7j/xtKHdeYt1xBzBl1JVZA3xE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Mon, 08 Jun 2026 21:53:01 +0000 "Gladyshev Ilya" <ilya.gladyshev@l=
inux.dev> wrote:
>=20
>=20>=20
>=20> This patch optimizes small file read performance and overall folio =
refcount
> >  scalability by refactoring page_ref_add_unless [core of folio_try_ge=
t].
> >  This is alternative approach to previous attempts to fix small read
> >  performance by avoiding refcount bumps [1][2].
> >=20
>=20Thanks. Nice numbers.
>=20
>=20AI review had some things to say:
>  https://sashiko.dev/#/patchset/df26082871b4c65b2bd38d409026237c0857283=
6@linux.dev

Will look into it, thanks

> I'm not sure we want all those new VM_BUG_ON_PAGE() calls in the long
> term. They look like development-time assistance. Perhaps you could
> make those a standalone patch at tail-of-series so we can keep it in
> linux-next for a couple of months then throw it away before any
> upstreaming?

They are cheap and can catch bugs that are very difficult to debug. So
I'd like to keep them, if possible. Maybe change to WARN_ONCE, as David
suggested.

