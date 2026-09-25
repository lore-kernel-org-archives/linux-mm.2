Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F6EC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BCB6B008C; Fri, 25 Sep 2026 15:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CD36B0092; Fri, 25 Sep 2026 15:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404196B0093; Fri, 25 Sep 2026 15:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5356B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:00:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E09D140773
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:00:52 +0000 (UTC)
X-FDA: 85253201544.27.4DBD021
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf22.hostedemail.com (Postfix) with ESMTP id 61824C000B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:00:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=e9HFQ+PY;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.140 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790362850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyusYEZ6OMCBSOJianrKz0ypKfJejIPeyJrkqXUe7fI=;
	b=nB1GQHtcAq2uMjrQkd9oR+eQlYsBBkYIujSyWBX1dWJuCgkBv3wU9GAGgYasGy1tEr3iH0
	Gc8YTBJCd9Z5UaPo4V8E06inhos0OJL/6z2L08AM5GIG6zLnNCugWzmS4fFX490HlrardC
	9DmWS6nosqs4XkJxt995YxgLgzyeqqs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=e9HFQ+PY;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.140 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790362850;
	b=NI/OduPgobO/aiKo73bxbjvGHNj4obvg4AhOkMr8QsWKGtTFkmsJP/jilos0KKQ1y4iCXX
	ys6wNQ6RjiSE5tfyl5zDHIupqO6ACIdAwyAYoa0qj6PsQLG853kIcDyVZ+fa5r/MekkqFU
	DbCHCY2EYJS6JdofudZb9Cl8VOfYkuA=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c293c683202so182002966b.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1790362849; x=1790967649; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jyusYEZ6OMCBSOJianrKz0ypKfJejIPeyJrkqXUe7fI=;
        b=e9HFQ+PY8HSaupQMmLn/M/iKCQbJ787TZYaLzHF4o6wqYGER1YVQwMWQsmFN67lTjI
         tiq9hDvV+UtZBPTHDK3NqIZDRk+IYutkB6Ua9fO3FnPSgJ3/vufcGnFVN5mMuw57mGpn
         6GquUvwO2AEjMGCqgP5JD+ENC5KIQuqnAEHbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790362849; x=1790967649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jyusYEZ6OMCBSOJianrKz0ypKfJejIPeyJrkqXUe7fI=;
        b=oG6Jm9lNDkCfd2zVVnlUHOTumyTheGuwgt4ol3EomM1ZH5/dxpcvjLUQvWy7qy20Bg
         WIYm71As9Fmux5AWieLFoTN3MKzNey9ZtYjG3477r7D0TCOZukX034m9WnS6O8LslDCX
         f1wO8vFkI4EDWdbnQikNUGu+DsAjRbXsbshPMwyfzA3ldVuvSRK1BHkS7MG6sZVf3h5O
         7rViZmeZrd8hh7POHMUyWBe3KTfCv0XPt7WBiJxMXMr6e1MSN0wQJrjlsYqh0QRGudKJ
         1ZDIfBLT7oZaKCU37uZ0mPGGbWLPkZqE6zNlEqHT1ewlUHHowK3Z2hYVwnn4psGxHt57
         4jqw==
X-Forwarded-Encrypted: i=1; AKwUvBwVqAu9W5zZVGKOT/IxMaV44B59M+EtCsUrmd5QWcNAsGZjug4ei+8oITf9mLnFHDGzd93aoQDFKA==@kvack.org
X-Gm-Message-State: AFuF++nsT6zHqBi6N+UCkxCD33WwkI7ipoWYN/WNLHTChOItHjRSjXMl
	Ngq1ZTMLvTFUo8L1GuLCwP2uUdZkZZLmQoOzcglwKo4Al0s5pCNMdVQOlPNzkCA7ELFT8QeLg31
	3QV72ptg4eQ==
X-Gm-Gg: AYBFou3fZId+eHLCRo3jNBIbXPYwe2WEAxNxKJv+zcrqZG2fFH1TBhG58i3FwSX+b/y
	DFSQ/UoOX3/3sN/NMUsaW3s6YbKuXFuJiEn4miAYca6XQfNjSJF5lPuuFV2X9CM2NCFlZf+gZPt
	XQIYGtZPYaPuSsLwS6yAJRGYSJ4PSJ/JRrFIS2L9+qR2yuXtUcvN3u8Od6nFQ3w2iLOBtrYbf9f
	QCxwf6d3FiPb+kuVRALCRv6uJ5yWroFcSDzJpg34JGxEr1F2h+H6yTzSaUPatUpxjbThkeS5IJX
	s5GK/Z51p7/xi/wcfXTVI1qZmaUazBTnAe3+aHpgfo2aQVgMxEGh6gxBz0imeT4x7QQZVVHwar2
	OqMPtJeQtr3e8Ge6pRR/VIqyGJEwRUNfDZXbpr2JVPda3TGS6uxKROSph7ov4sEd4lkW5aLD4ax
	sDIQUmNXiKK9dlnDbAaBuLruLzIxLZYznMxyMWtYJZjAkWHJ3Bw2hC9yhHAX4Dr9x0ODjSR1QuI
	zFiWHpqQga5FkQMM/ScdV25gqwhrPVyohcgMLK7yfeU880v
X-Received: by 2002:a17:907:7283:b0:c29:22cf:b0f5 with SMTP id a640c23a62f3a-c2aea05f3dcmr292945466b.33.1790362848738;
        Fri, 25 Sep 2026 12:00:48 -0700 (PDT)
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com. [74.125.228.171])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae76a68aasm157119466b.35.2026.09.25.12.00.48
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 12:00:48 -0700 (PDT)
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c264788fd58so181571966b.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:00:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz7L0jnEtUukFFnhaBCxIRb86NjnbiV5ENQur3OUmgS/IWziC/ucr0H+l9xocT+9oPqwIPEzA6mzw==@kvack.org
X-Received: by 2002:a17:907:971a:b0:c29:d525:72a9 with SMTP id
 a640c23a62f3a-c2aea0c733amr303710766b.49.1790362848349; Fri, 25 Sep 2026
 12:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com> <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
 <570cf649-a8bf-4073-be71-207fbb2bef40@kernel.org> <CAHk-=wh3LLDV2AMZn1PZcU1o3Na-BNcQtP=LPXouLKPZWaiRdQ@mail.gmail.com>
 <DLO1WIACYFWF.3N01DXYFJLMD0@nvidia.com> <a1d5881926dbf4b16dc796fb1da939f32dd42f18@linux.dev>
In-Reply-To: <a1d5881926dbf4b16dc796fb1da939f32dd42f18@linux.dev>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Fri, 25 Sep 2026 12:00:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=widZMoVwT+to2PKPfy-y2gERYWdLsZCZvXcz0ZbXYpt9w@mail.gmail.com>
X-Gm-Features: AclHuK84xe3uYtoS3qkT2jpKdwnf58NHL9DKtWnMUTEyzhDeLLiMiURHSpbJsHU
Message-ID: <CAHk-=widZMoVwT+to2PKPfy-y2gERYWdLsZCZvXcz0ZbXYpt9w@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated bit
To: Ilya Gladyshev <ilya.gladyshev@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, 
	andrew+netdev@lunn.ch, apopple@nvidia.com, artem.kuzin@huawei.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, edumazet@google.com, 
	harry.yoo@oracle.com, hramamurthy@google.com, ivgorbunov@me.com, 
	joshwash@google.com, kirill@shutemov.name, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61824C000B
X-Stat-Signature: y8ijmiwmwp18zyjg913gn4ddnibmdob1
X-Rspam-User: 
X-HE-Tag: 1790362850-380134
X-HE-Meta: U2FsdGVkX18LHXNCQnryVtsXTTpDgohHIZPlMfOtyGV4qKeC+v8atQ2iKycvLaPH+VBKLWqATDlDMaTeuTVe924lo9VQ5GrbM7jPVnghr2l4Jg2HEGYFmtGo9K9yXErf0tyNkhOWQ7BlJKxL39pSpaM2ITosxuZ6U7QvtdSQEgnXZK6hGz/76P9fWYmmB02TUMY/D+WU49rvy3Q4iEjl47kt0KQUZupZiXolLkREjGfbWxEp6Wb2YHl+uxqgfd8cUI/y0KhD9DePCH4iAQENlO8y48mTJVxuQx6qBAGWD4EBekHo9z1Pybc16EIpFBIRIoLEairjnLGUnH7DdBsHR4ZZ611Ri/1H15xL2LUZU2wdXQQbPKVitfLs809uA+oWo9qUT2zJdL6m8UHKp/r7qDPuDqGSbmuFoOa2uxBTvmnTu8ykc+V/6nsuuOJ9FkEuac1CfNHuReZ+IpRk0owRDRj5Ga9u1Klg83vYSndWZUevR2eShIJNj5Vn3UgCk6Z1uI6Val4eXARyXvhJtZulHXKkPhOzXQvOgef6XMv3IOJ/3KLIIo7rLbs66Bstq2TbdL5eTnYBXn+4R5fAyFNz2SH187AnxKLwiu2Vjtrm4RMz7qRTdTGClv5sgsLRP0EeY7lyBh7knQKlxuhKWkZGMWhY7EEfUmO9dbD5r6HkvIX2/jGswprxmVVk8jkA1HsSrf4ooBL+Ys1vL163+fMrFSfqG4+LrKMuNrH/qmnnL9QpWVH/g3pPdymcjzg2lH5Zqh1tnOsH4plbuxavq2jF9kVLLR9x4+T13jMtwYOh0cSzu4UBItbBhFvvsDPzn5OyQabqUoRwUrqJ95uXv7aMLltt6pSG4nYk6cfalRL6b5mTcz08Rx91yEmb7lN+H5zHMG6Ov/fDqh0iIWF6oOXBrXQwz4mYoSPCnWqwgtH5GvCtrPzDYVipdCZUbA/GX9hMQ4RpvU30g1YOecgB015
 dhfAXZ/3
 LYfrxtCgBEX0IVemuMN/zKtXhlWE2B20efcmCcbfOCWIWZMY69UFRomJ2IBkIxmLxYxE/68HVvKfR1lN7UlgXkh7Udd1rIixG5S5zf+QMREDMTLCoWaFBgDWPN6wpPsPLH5NJcfxH/7FLbbiV+0mgbTrxPV2BoTbsZ+IsqRWIV7Vv6hSms+80TQEkfrAVBK9Z4Mb+opV8dayzx6y95l0dW0ZCFaPMffSUpLz3JOjABcip6wEbJ5lILaFpYPfZfKvF65Ok3n70LeX7UM7gzUv4tMmzhZGVcFPbpz98ZLPEoDtVgQCSmvU7Q83cpDzXBUp0DIkGpTc8xZt6U+DZSGeECYQE3FVGfm3u/8uQSVvS10FsrDVUIjV6RTtce21yQYE0RuAL3Y6qjftH8b3H7T06+OrKw93X8G5mWYoa1MPkZ1toK52mmhTlCwh7fNyhY19Ewh9gqWCzuCayeXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sept 2026 at 00:03, Ilya Gladyshev <ilya.gladyshev@linux.dev> wr=
ote:
>
> Hmmm, I=E2=80=99m afraid that since you need CAS for a safe 1->FR transit=
ion,
> it will result in a CAS loop for the decrement itself (like in
> atomic_sub_unless). And this will introduce scalability issues just like
> in folio_try_get(), but this time for everyone...

Note that we could make that CAS case be the thing that only the
special cases do.

IOW, maybe only do that slow sequence in compaction_free() and the
memory offlining.

So we'd have two different cases:

 - the high-performance case is ready and willing to accept the "sees
zero" window and the extra 0->FR state that can race with somebody
else taking an optimistic ref

 - the unusual slow cases that are *not* willing to deal with
optimistic ref takers do the "CAS 1 -> FR" state atomically and always
use compare-and-exchange for their freeing path

That actually sounds like a good approach to me.

But maybe I'm missing something obvious and it doesn't really solve the iss=
ue.

              Linus

