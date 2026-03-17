Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF83DF3381F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00FC86B0088; Tue, 17 Mar 2026 05:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBC36B008A; Tue, 17 Mar 2026 05:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCAEA6B008C; Tue, 17 Mar 2026 05:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6A436B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:19:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7545D1C7E6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:19:26 +0000 (UTC)
X-FDA: 84555006732.23.B343534
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id 38B8840006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:19:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="p/gkbFuK";
	spf=pass (imf27.hostedemail.com: domain of changfengnan@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=changfengnan@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773739165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eunUM8JQ172NyXvs2GMpTXA1jV7Ng7SV2a6H7K+qqos=;
	b=v0xPtPJ4jo2ARc+de4tQED/t9x9VijhrpQmeDBzjY7NnLOxZA9PycWfR5tNW+3aDSVvOrJ
	RqsbdkKorlnOhk8AwBZDb+bCl+owBZgI2vGJAVPoxbGnNdzWTVcBdYPYbJ95LZ6eS4EDiF
	AtUan+sIWde3o8qpHry7QHDainTswHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773739165; a=rsa-sha256;
	cv=none;
	b=mJp6afXf1C/iX4zXF2HrDq1b3voBbvLrQryJFOrS/0eATvKn1j2UHSAAY6va8GEEyG3LOf
	PDNuSjKED7Y1rfGSqg9xM0lgdL/Ax/zXknv7ejKldKrx9QjZilld3cN076EuXjmGX8Ava5
	CqgZvEgEf5nBcafHd9fyOl70pNj+9Pg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="p/gkbFuK";
	spf=pass (imf27.hostedemail.com: domain of changfengnan@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=changfengnan@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1773739159; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=eunUM8JQ172NyXvs2GMpTXA1jV7Ng7SV2a6H7K+qqos=;
 b=p/gkbFuKTFo5OjOtKB7SZOwwE8OQ40gBqwNAOscKo8TEwC8dlIoPlJR7ft6kIo3/XSEEiU
 b+g15YoKAOk5NfLViLB3wRqHT+WN8K+3jnS7jtgMSUPmjU5SHIFUn1s1MUEv8Z4JWg05/P
 sUgqL8vHdKr77yyWvOjwY7pif99PXh1axr+MyCSdFYPpFc5YdlVMIRR0AhYSwTZzsxlRv6
 9I5uoJhZvDyMD18/PRqCIU3HG1NOZnG34mKgyVSBIK0CtJ3irAO5YZnaUVigmIeVxM8YLn
 eOYK89PTIuSx84H/pt0JROjj3wx3NHGfTbR0hmiwIE4Wduo7OEFz6UrX7Nnd2g==
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Mar 2026 17:19:14 +0800
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	"Dave Chinner" <david@fromorbit.com>, "Harry Yoo" <harry.yoo@oracle.com>, 
	"Hao Li" <hao.li@linux.dev>, "guzebing" <guzebing1612@gmail.com>, 
	<brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, 
	<syzbot@syzkaller.appspotmail.com>, <linux-mm@kvack.org>
In-Reply-To: <abkbE_zh79iCd5zs@infradead.org>
X-Lms-Return-Path: <lba+169b91c95+3e94c9+kvack.org+changfengnan@bytedance.com>
References: <20260115021108.1913695-1-guzebing1612@gmail.com> <aWh06YoiJrR3-J-X@dread.disaster.area> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com> <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com> <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
	<abkbE_zh79iCd5zs@infradead.org>
Content-Type: text/plain; charset=UTF-8
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.4fcab3f9.8b94.4220.83af.caf2cffbcaa2@bytedance.com>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
From: "changfengnan" <changfengnan@bytedance.com>
Mime-Version: 1.0
X-Stat-Signature: 1iqrdypbrwoo3hrc7xxktpdj1cyb7b64
X-Rspam-User: 
X-Rspamd-Queue-Id: 38B8840006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773739164-161904
X-HE-Meta: U2FsdGVkX1+0yhUDPL4ZYK04EpJIkPwdWMVY6lRPDiQyZjjfpAUQ+CvXsGbdXfyCrTTJu57adokQfK0NbYIKX0hwzmhxBeol6CrxK0VMCaRErv7JGQJvcQK0nx2zwiDLHykpsoXSzFN+Wz9dMQXppNCRO5NHa9ATrWlVzqbPM+2wYUqm7i3cwFXra1ezPbX4aD1wXsg8SX05P5Zw03hhehCwiqDggYHRmetgAgm/QfLdlFdeiDKWtUL+WzUEKAU7Fk81UzgoWzQphvEnHAHhhGayD7UWYLyUqrwkGOluI1+RFhWu0kQrIUzSSxDlaJlP7vMUVMbYS1PzNxZxd4YpXwDikGy6qgkavDImB26BLM6CqLDFpua1fpFUcJl9NGhkfhU8mVh0itisEcvYMr0nXRb8mPhxnSw5i5K2ZTEO87ieHsMonMUteof0zp5nzBdoz0pvU119m7b9mhfJFGjto463rJg32gaEJtBYhXI12bjG0x/Yvr7Gv8XBke+iiUFcBVfiCugnn2MdBcwtgNQVcYU3ucRRdvhyuEXqBarLEKTGJp8ZXWSpAHD2nVUwUVXmu2g5mzcA98FxOzGOha/piKrajj/Ymo/I/DuiwmP/Nsk4K6ri534tmbAIoCFZBWUOJ6qpIarNCQrXVX/tPradQQO4MOuGQAHjsPUlWj0Q2fS/euQJ/FSzuO8ri5hA22kZZ+dc7TMV92FUvjemDhGxCGMEUDhWKhoRzB7a9vQxUqypEAbWzNb6ie/87742DNThAmnC9n17MFLzhizBkB97F8RCNGYwunOd/CJYSj2kx441336RtyEm2YMk8zCS0UqGW9V9e1OoYnzX+zm9YAODFguWmYrx74YyDz5IOFVSQMEqNf3WeEczMTewP9d0EPTzjC31TMqgC/cRHWikUwh6nrVQunLn4mzrPPM7dVeaN/YaFbbksNiotvJlScOmTCooJbW7XJkEeUg8LIEBYwC
 xfKRetkR
 bhNfU0yMBmSnzawOzu/YE8eU/5CWSync2UC76+93kqUDEySMlxHYJsdavgOy8eiYoGotMllOtXJcvuLL8FsGcYUFKrnnd97HIWzoLPQA4w75YHzrEo/UUPqyMNxPBLVEC9lIkim2YN8KDFYkD8AqieNP1QixmLQ7qq722h7jHQdCp0kPk4S3/dSj7ASK3ODxSq88bkAyS69pDjqb9Hcxb+jj/Ygp9OCqNppksQEik7bRWtrdP7N5Wjnd+rwA+DmbvSi6COwARc5tQ3U7w7jWh/BxzO8e12eC5tTDjyMzgvXC31D7f0/KtVW1/+WW+gPwAYT2PIknva0DiD0Z+dE9qRrDE5+IzVzBGJfn8ACk/VfiVmCAsTPQXW/atiFDvh7nTEr5KqCPypWC8YvZSCFn8vtOkOZV/IrSFcHFTeuG3SAGzgBU6iM5/4N7AknnnuCrlNkDdS0l+JtTs+K4b1pu89Aye20Bl8Nob2kczKS7KKH5a+0oeaphHFRTWjmjCUyN2D1+mplaey/vDMPYde2DNh/INrOJ56UK927aFuDsQfXemLCyO92GWL1nggn1LNSUCjyVhNrqyieRLad0e6YJJgRaURfgGSIwbAP3GT5e4HXDiCe8UzUGrdAeOqtlQuV8rbMKPk5DlySY9Mig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> From: "Christoph Hellwig"<hch@infradead.org>
> Date:=C2=A0 Tue, Mar 17, 2026, 17:13
> Subject:=C2=A0 Re: [PATCH v3] iomap: add allocation cache for iomap_dio
> To: "changfengnan"<changfengnan@bytedance.com>
> Cc: "Vlastimil Babka (SUSE)"<vbabka@kernel.org>, "Dave Chinner"<david@fro=
morbit.com>, "Harry Yoo"<harry.yoo@oracle.com>, "Hao Li"<hao.li@linux.dev>,=
 "guzebing"<guzebing1612@gmail.com>, <brauner@kernel.org>, <djwong@kernel.o=
rg>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.=
kernel.org>, <linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, <syz=
bot@syzkaller.appspotmail.com>, <linux-mm@kvack.org>
> On Tue, Mar 17, 2026 at 04:33:24PM +0800, changfengnan wrote:
> > > IO is not my area but getting from 1.19M to 1.20M doesn't look like i=
t's
> > > worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
> > Yes, at least for now, there=E2=80=99s no need for a per-CPU.
> > It might be better to replace kmalloc with a new cache, but my tests so=
 far
> > haven=E2=80=99t shown any performance improvements.=C2=A0 I=E2=80=99ll =
look into it further.
>=C2=A0
> Does using a kmem_cache help? =C2=A0That should generally be a nice win
> anyway due to keeping the objects together.
For now, my test case is just run ./t/io_uring and fio, no other process, n=
ot show
any performance improvements, test case is simple and no other user try to
kmalloc same size object, I think maybe there will be improvements in more
complex case. In theory, yes. I=E2=80=99ll run some tests to verify that.
>=C2=A0

