Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FB9CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8D36B00A0; Tue, 26 May 2026 13:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179DF6B00A2; Tue, 26 May 2026 13:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0686C6B00A3; Tue, 26 May 2026 13:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBCE06B00A0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:54:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 975048E751
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:54:34 +0000 (UTC)
X-FDA: 84810320868.08.BAF615A
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9CF5420002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:54:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VmsXeCn/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puC9SJLHTM2cpEQVaMH58VO+otGA57OyLdV5XOHij4E=;
	b=SS9wnEdmus5f1GpXVAS7E6ynz7+twtSDHTWjTPnSHQ2M5uF4JzemQ0/5RU2zfUTJp4vYpC
	yJb01d4gNaZ/exdTtAVhDREaJBOZGBhsG25PR/gnO/E15YutAFCnXZO58bCxfchzVefRaf
	eY2z0q4f0J0HFEQlIhbxiy9bvf6hCLY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779818072; a=rsa-sha256;
	cv=pass;
	b=Uv2GXe4GQXXf1yjRe1N3msp4FKjB040Ck4I9OAlTB11dIajEreta4Iv+RKOlvoJhVd8pFD
	CDaoYMVhVpfn2ZlXtxgaArPBCq8e4jZi19s/2rKasVFj/ZTGwQlNj0tDCTeI2wi7LboKfo
	LLod1fXLBKbiqA7zJgaN/Mt7GmotwOs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VmsXeCn/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2f24905306dso1139280eec.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:54:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779818071; cv=none;
        d=google.com; s=arc-20240605;
        b=FkSf7XuahyyJzyhN+o2kaYSdagk3bXKvte46b41Y8cUUdRMjBs98paN/m2ODxOGC1I
         1C6pN2fzDTAJ0wRILyoCnqMyMclVr2pPmunDeCWFIal+iiMlfNA3Z4cj2Fchztj/DGJk
         S3FDLXYSRMNIUHywUgc8vIpvtci+W7vT+IbEnOXrZQ18qPB/qD9e7I+xkHNNj4v/j7VO
         RoXZQzkiDYJkupAl77oELuyoQhPCnFTzlw3tUZvs3QT6QZWY2Ga5SnrUJrtJ1JpCF40Y
         BtR1xAiDugjhqVVq4PQQVSQt0utPnFbvyYD8H5pTzPvdG7Q5QcDci+t7h9brHh0GJXYP
         kZwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=puC9SJLHTM2cpEQVaMH58VO+otGA57OyLdV5XOHij4E=;
        fh=Hmn2LedMNup0XspQ5HvZN8M/hwNxsFML3J2L6gvw7o4=;
        b=ARdYzXE0H8lrtIiN1p/YT9hIAxbFw1Cg+Qd9HJuizHdddUnyxx6GrTWzCPWz5fbXWH
         +ttGBk1YfLNtXQT6o9Lf7Ccsarn8gCdug8Bs/c3l398guV6mTbN2fKN+kOBrSMIdXiaq
         +1EcXMOgVMrVJGpPW+J1UO9GvuSflZPZLcZzuTbh5x9j+xxp9xAIdI3dyjjlDXi95P/D
         +rxGcEuXG5QRE2oL5cKvQwUrJqUBUObv0IcJ2gypZoL+Zin11lOOVqF1MSjMpjytxNSr
         nTaXDF2oInVF7NK/fQRQPXghh0lHtD5F/n/D6cQxsXi25H+RE9xGHXYml/dp0UXwaBEX
         g7IA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779818071; x=1780422871; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=puC9SJLHTM2cpEQVaMH58VO+otGA57OyLdV5XOHij4E=;
        b=VmsXeCn/KQ09UpdKclSQXJn5J2ZV6thct2t8wh61h9wvpHaF2/T41g4ED6Z+xHNNNj
         8J4QDiRb9BG84YEshzuiVJMLwbqK6Kcbs4cADPYePl2/PkNL6mhasAkSt304awn/q8xF
         GclU6DPiFnOiSDyjw1hwTsQCPY3yKYl4Q05e09N929gruRSoeHQYWgE5CsR9KGyJ48gK
         Jy3xtbwnpBImx/3CzBxgtSAnox1+Gikbh2y7yfj6ieSQ6xnOXgOY+enM/XHTeWaGs51c
         NwxGwFk06XpwW3i+UVb1LwqYU1oF8bjt60Bi++elAyqQ4MvMXB1EwDqdZ3CCMl/o7rkU
         djMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818071; x=1780422871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=puC9SJLHTM2cpEQVaMH58VO+otGA57OyLdV5XOHij4E=;
        b=DHejeMp4SJ+kVUy9p9R6CCdzSf2Sv415nrj5F6Pqrvv8tYa8WutAJgnrPfiSsYH4Ky
         rV+qTlW+LVSuMjHt3aUz4qmOWYjN2o86FI3PhccCzD48FUXjmetmPs1+iHehJI/VHqec
         FheL20XgJOHhA1fFEQEh/GFcwjLMnek0AeC7SbYZnkqB+mDfidVsAeHUW/Ll/ev7x1w0
         QH7WZP/L52lkPSWDlp6YZOsJL7jSkdjDzGLgzpaw/zDmTOQQeeBtvXHNnDw5o5N5HnqA
         +8KLlLR9mmdW5e6wy3S04i1fis3XYpqMDmOe1xtjITfPRLHVOZbMWph6lP4mLXZ+F5Fb
         pR9g==
X-Forwarded-Encrypted: i=1; AFNElJ+r7h9CVZdH0GhyusVjaX6KkxvOxjqFocNwYquombeTj8mzPhd/n0o7+POjc18r/Gokusl1qd8HSQ==@kvack.org
X-Gm-Message-State: AOJu0YwXZjx7ZINdBz+Y6ZiFn2kMbXrF3YjZ9e6/J0Qyy+QC/WRK5DYa
	p8L8uvii/2PNnWAlb7WuYRDLz0s7gku+pRokWLbL3PyzgS48Xy6b6yVgF1yX7gBXpLtGkuDjs1v
	zuU/1nJfTzjsDrOWa5bWBEyR6YB2hC8M=
X-Gm-Gg: Acq92OEAwYLHh5WqLIso7f7INNwfX91Abta5Io2XM5v6dkgdFVYjTqOk492fxbsrXki
	M2+JsdeMEwXt0/fukaMOlJt1wuXY+zAJvN0KlkvDwDnWQx7DhKR6UA5KVK9XyURjeNVCPzdjE3E
	4jT47I4y3pwaOj4CvVzYvr8GZHPlsCBLNaHZexOoWeD3XGirteU97/gGzGk8OcDZbdefVdMroX/
	/E1Qdk4ovEO+nJ11se4tYlE9BN0s43e1nvwrcjiPMS+MeTkAb2ZYMCzhQJOdo1SCuZhetGG0YKx
	JRYkBlUjNTKeM2gtCHZOnVnOTWqSoANLr6xGBTG3RrVtaNpQ8wCJT3QAWg5DfXAbkWtBQUlxvTA
	vEN5FtOZ1xlciBn9Nu5vZjuvjwTxv9a+I1A==
X-Received: by 2002:a05:7301:2092:b0:304:4f23:4823 with SMTP id
 5a478bee46e88-3044f23c523mr2709812eec.7.1779818071249; Tue, 26 May 2026
 10:54:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1779286416.git.d@ilvokhin.com> <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
 <20260523084901.GF3102624@noisy.programming.kicks-ass.net> <ahW4fyZ6j9YvJho9@shell.ilvokhin.com>
In-Reply-To: <ahW4fyZ6j9YvJho9@shell.ilvokhin.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 26 May 2026 19:54:16 +0200
X-Gm-Features: AVHnY4K9vBisDpVZJMVTzCi8T3wy9swOj3IeT-5P4_v-UNE6ALKXLqpstbxL-rg
Message-ID: <CANiq72mZn7GZ6TbNoSuVUXsprJSrpPWA9oAcUQrYzzCj-dFnew@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with __nonnull()
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco Elver <elver@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: kg3exfbicotkxu17jt1e8p4p44uk691a
X-Rspamd-Queue-Id: 9CF5420002
X-Rspam-User: 
X-HE-Tag: 1779818072-178188
X-HE-Meta: U2FsdGVkX1/v7ucNAihldjWK3iVzXCW/GjOuTHOpV/5VO0CO65+OvqW94sY5h0nXQfTRUxORdORnvo3KlI5ECqF6N2wPVPFBWyh4RYpf/pMEvrBC8BmILpVWcsGNXgUqwn76X2RWnacoXHHUxVRqrjjUgHvxfq6IpOnPdCc/CwhxUM6C2OnFJXhQLPrgGdmtakARTa98kyrCWSLHgo4JKnYOl21n5qKrLber7cNccZcnj1+Q/JxVy9slpe6Xh1UKOQoW1Wi4sYkZ68Cw/O7p/U/A3ZUYt4S4LmYirSA1Pm1QAs3nTxttZt8Zcou7o4PIJSV18XtvciIcZlC90AHgUNrIqgJL5jsI/hsyTAE6IqwIhbvc1HzoZdYK1yu6e2N18YFAfd/krZwpiaU919gX7rfsdXIEWP7pDqr3b9HfiQWcHKGsm+ZZSmb3QJg4W4HsVrvBWd6mEQ8YJQmoRmIjGEve2kQ48qcOJdLc5VQ2pb3IYA87HsDjDq2kNfoSD0wZj+K1bixfYZn3lgLVzMiEOHs5oHBspmV4LDMr4oNNu1i9rZKkzCoOzIftZPPZp+Fabc9bhTd7yHSXdnMGNci9tpQTfgP3nxcG5jT7Q/kYcqcSFos3J1ZatjJu0Dgts0JqDCHYI2Rmp/I6A7bCIEXjkLSMbJlL+CZlS/xAkejhed8/NFlUvEjHbNmu0/RTjpv0bTJK/RBPZH+K7EUDdV6FMw/d2o6+mzn/0b8LwdIX1tL4XpwdxgRALSExn1CvPXUXOuM/vc/l3RCp8WZH9fStfVpKyc52w8EdZgtUNK9glS/xkg5gM+U3Clepx2ObshHarrUo2Xvl3B+UyNSP8fvwqb++Ap6ZLbcX5Yh8O/BYyRVjmsVvp7cfg0T5H3FIJa+tF9S/bw3f5ADeeb09oJ3ixme6pV6qGxlPLGGxYBcsYpwGOGQxi82VMyimkvBcoBzqWRJ9EYGbW4BPu+m/Ov2
 jtEu3JgB
 UMXot1DplT2WtEJcz40k2XzMJh+Q2eZ+71H8+AqY4L8xLOxnmOF25ucfiUncrOJBiMQl9L2xWSbqQRquM9rEG5XFMYLl07yPFejN/5iiRjX9cHqJzvXQ3PohSlnbmW8E97kcRBv5Wmi+timbP+X71yPYLxVmoYIGvBKuw771LO26unGmBkNS1nZJxvV4//xYaHJCXOdY4WhiKM/hZN+kkIgR4VaW3n/lj6Rt0u+FFI25a1HT82AKEXoYMjWJd1OJTi6CvhVkP0BxoI/TlF6S5iOCx2wADiiilPFdipwGz/4fJ5fQACJtiO+bjLUBUYP85D0APgc01Ak720dw7RQFRGrqQcAKvGJlJgp1N70zDnPRMCqauH+aUOGyObAssJ2HKPlThBjbn1xmFuCknvPDWNr327m2NEO/NYaF7Ir414lhU5T3mfttBGlZIjabkzmgs3iLB2HL6AVS8yu864TIWYCHoNHBPfsiomKgcE4DW7S48sLs2qo+zLD0J4ChQqZS/K2/zG5lrGqS5DV2fYyHAEYbInCldWWA+o0rWvxSuoZ7PLn2UKSdu3ICAiMLtmyGQmEs4B15IimKcAqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 5:13=E2=80=AFPM Dmitry Ilvokhin <d@ilvokhin.com> wr=
ote:
>
> They usually don't collide, except for User Mode Linux builds, which
> include both kernel and userspace headers.

:(

What about other similar names? i.e. a variation of your option 2,
e.g. just `nonnull` (we also have others like that, i.e. no
underscore, e.g. `noinline`), or `___nonnull` (triple underscore, but
may be confusing), or a suffix/prefix letter, e.g. `__knonnull` (for
kernel nonnull)...

i.e. it would be nice to have a "standard" spelling for ourselves, and
also replace the existing `__attribute__((nonnull))`s we have
elsewhere in the tree.

Cheers,
Miguel

