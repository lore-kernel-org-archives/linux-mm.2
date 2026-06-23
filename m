Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56484CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1086D6B008A; Tue, 23 Jun 2026 05:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF3A6B008C; Tue, 23 Jun 2026 05:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39D06B0092; Tue, 23 Jun 2026 05:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDA4C6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:10:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 678B6166766
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:10:25 +0000 (UTC)
X-FDA: 84910606410.07.CB6DDB8
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7819D40003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:10:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sCxk8wFD;
	spf=pass (imf07.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782205823;
	b=eI0vhZ26NAQhlJF1Vs3B5LIHC5pILLfkEBS8CDNw+4zpLwwEmcnPOY0SGvW0LwnyUGzFLu
	PUVMi/eCIBYrbzE7tvgSKWKNO8ybO8+vxotgqJ+rtC/jV4Jqlgs2TZeDbHY9wjX4k8E6fD
	0wieqdO4ahMqLu9D9gyRC7InLnnNWkU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782205823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmkBF/F+ufBgZMZn6F7DXZ929zTCk8KNdKVzQpVyQ8s=;
	b=ppWlBlr2mmB2GXs8behxOKOn0QX+zi9ZYiSvCVB4rDaGIzvC5/vHBUA/Nl4Igs/pLMlRs2
	5kEVEEvtbj5tDFJkfCllCtrNJ/vJBy+/eQO7CiNZo2cbdY4w2LkMvm6iRtncwn7/q4wnaF
	ldMA1HDQNP476hlXdy8SVjEcOOUnBbc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sCxk8wFD;
	spf=pass (imf07.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49249072f03so16157125e9.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782205822; x=1782810622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmkBF/F+ufBgZMZn6F7DXZ929zTCk8KNdKVzQpVyQ8s=;
        b=sCxk8wFDt9K6oZbn/isea9BghkdDQtZpYwAgR7BOgNGyXcIwTLiT9K94c7L0XV1J2q
         k48w344563vkeo6Lm5D2tZT0WorQCKWw9qUNhNdqJQ5PB3rIpk3+yh+QFFLyMFpbMm8O
         VUAKFnUeVU+jEazS9IaaINueolRi4OIjkvIt3Ts75sd7V+gFHCc28OJbBo0szLjnJ/zG
         4UN+Qltnu5WO4rIlJsGY0RkflNcL8E64V0cojH+HmaIZz+zC3o+coALjtlbx8iz9XvGZ
         D0JuWFAP4PS+eL2UsolUb8s/+8tW8PonWREIbFqTXyw+czTnlOU8K7LICdrU1JFfeA44
         OQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782205822; x=1782810622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RmkBF/F+ufBgZMZn6F7DXZ929zTCk8KNdKVzQpVyQ8s=;
        b=SFh5joQnIit7DiD2g57mP2IW3ZwdnRuuVr4wr2bQfku5Oh173GqXcWeuK2Wm+30Lzh
         QXwkIxjVsGgEV13at4Ca64HRtQYhux8kayVe6srflTTiSSEIhQ0aJGofXI95j0P96Gme
         76mZ5U1lHUv8+3pbDDGFpSpFK2NZps2G5l8U+MJXAEsZafiK/Rb3c+g75Jlpcd++3t83
         526u6zPCb0FAKKvXV044T95MKRDhlj9/Uul+8P6nU6rF8vf6eb/GYpy31ymlERuQlL5/
         td/0W+pkJvOvve7UjnaGJ96dMAATGwm3AM0mEuP7HMBY+bP0eE6AtsegR7NY62BDaApM
         oBoA==
X-Forwarded-Encrypted: i=1; AFNElJ8x83cjhhKaUC1MYBwcQoP2vkTDWAhHMGyElnmt7yI0a+RKd2kcLzU+jNMp7hZGz0jGJuHW7ML9DQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/4qtIwdrtJtwrdxsa09nbQZWOWGVupZsRSCpIn1h6Dal9O27D
	RfhwNyyDWUNZLzbYVN8iaJzvGpx1t98tk9PPiT9Ku4W55ywVbfwh7KRp
X-Gm-Gg: AfdE7ckJayE8GOg1GddrLZjiYVvs0BDoaZvoje5fIDKYqnNvBqhwzwN98Sp6Lko4IaB
	DVOlwX3BAMIkUlL/y+qUTW88YK35F+xBQW/5+wnRD3VLqANr+Zd7VWkzu3/JaNDWzHrjNPDoA23
	sQ+0IeuZOodvdjyPRfFu5a59PsG/yyex7bi7ndQD4OzRJ3H3yO0+J9dpbVMfcyafXsv5Ty/w+IW
	jnTjVHVML71nYrWu+3n8ncxCs+pMEsg4ut9uBazLiwQLxzHzs+FLH8YkIIXwRQovJjODtftZNPZ
	Cc5/W1v4KQMTwt/L97H2WLMe8g3VaVGewXeQmYml7QOwhcOHk4hAs/dacombGT86kTrMnyOAohE
	o+3x8CpA7Wjzsck4j9UaqXPc/w/fkmCcZ6kpe67v2eWegYWYY0R4ZmF+YVJYgJ6n9baCoKgf843
	KMclRaDMDEKmlaTzpo5OAQ8ZiJvMa+jGpkfLAhrdqj+7vcgFEgKQ==
X-Received: by 2002:a05:600d:844f:10b0:490:b2c9:e284 with SMTP id 5b1f17b1804b1-4925b3b4744mr21760465e9.30.1782205821796;
        Tue, 23 Jun 2026 02:10:21 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49245bba787sm226309215e9.1.2026.06.23.02.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 02:10:20 -0700 (PDT)
Date: Tue, 23 Jun 2026 10:10:18 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, Will
 Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Andy Lutomirski
 <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <20260623101018.789a4094@pumpkin>
In-Reply-To: <d4926c7a-32e4-498d-be6c-ab2969c8f672@kernel.org>
References: <20260424191456.2679717-1-stevensd@google.com>
	<da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
	<6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
	<dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
	<CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
	<c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
	<87pl1md7h0.ffs@fw13>
	<CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
	<87qzm2b39k.ffs@fw13>
	<CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
	<87mrwon5uw.ffs@fw13>
	<CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
	<d4926c7a-32e4-498d-be6c-ab2969c8f672@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wx19egdtyshk5imks7ehiy8effte8bz5
X-Rspamd-Queue-Id: 7819D40003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782205823-813946
X-HE-Meta: U2FsdGVkX18afYOYZozee9Cd15ub+3bXOWkA19RiUIhbWLDSyf0Q4qaJ9d9bJeUVWJRUynDA675ic0EavrrMdTuljE136TfE/m8/x4f9ADz9oc9LRwoTSZiemnPEN8Wl7lDWQtcSqBGcb5RRoyRyrOW0agthvcizlUm65ietlz/uxbc93I+Jr0Yng5RoX+5yd0heRflOhgj5I6C6CzDXPhDiSo5ZqOkDLTkwPHOxACHF2MDUaqjkyDQZoo0yqrld5Z9aqg2reDRd4g4868xw6F0Ke8NhmC/QycGJjKkxumfomMwLzd1AJR0WM77qBSbXgRTyCBd6VbMUK0xzigItT3NopA7kA6FriZucW8/X6ly8CWl6c5BlBATIl3uPaGY+gO9teGEJrsjJM9QMor3cOpVHzsWXoUzhUAciGOK2X+FvRYU4cRNsM81JWS2ZcidYHIgnFXcRoJuXYCOAdUQChREdDmltTL7dx1Gsj+Xuc4m97ZH84IXTTdrBzSZn9rLd86ayh8hQagA+zAdfMIx1LrWIXd6l/V6qtFP8Y6iZjmc/z/j+l4a9yM1o0m082Uv/ahDwclUA8hDcax97T7O4iv2e0b/bq0oAlMOhPNdYXBMeh8wyfOcnh5uvabVPXTxGcFYhHriBXnFa1/YMHipupadU1SDmholzFsV9GmDe94Ky1QgtjGWXCK6RiC2tzYS0R9kPq/vDqpmnCr8HvqBb7yZTQ49am8863R9XEJR24KvBeaGI71wabxe6j6VhuCfLgWtjEXBaM6e5JSP+x/q2LVk8sOysnLeg8zOJzE3xZbc74fU9/gKzJw8wP0wKHVVomv65sTUWDObDG8oBp5aP8/jn9KDUnTQG/qO4N1Lc3R7TncuZ2qGq9tAKFFHrGcAQGgjIkI/xoZi5ONfzSLNCILUkBlVKB1OBWksxnTVtUAVB2QnbTt3osRF7nxxH7p3sX73HCkS4O+EG7NHrTXP
 YdehtI33
 +BRmldXW57msgqNi7CiQP2EkWadrA3DpyDMrV3g0AZ7yUkgzXxsUucn7/vc+2v8kw0iiHgZxpHP4a62Lo53TpK6QfQkUzNjvhdCezVeG5G6rcZkIw1ewU3cabSfk8Ewnf7/DdoXAsHT/b5iBMRIzZcCkimV+Ko1n6KAFXxq9M5moL8JGYCdIl/lHSBCAi7f1ZSHuSqoDcpGyknplzfq9YWL3obnbK54bm55fCf8NIQEwyD/k8MXyCooTDYcHKoEPXV8+YO7fX77WoD/R+7N/+yQMQ1Yh3F/LxYCePgERAlS0tHUfCXRAuTRk16ov9Pl7RT7R60Iyn/BSnmrd7UrvBQZSh8ukSM6MxvnI+F0p13OjvR6BGRZK8RfAPRM3AaWNJMLOlxkIX23+/1bUTpJNzp0lR7DN1FQeFgYNxlg9zMx2hC/p28ZowRw6W2wgUjwb2UIhbCmP7hPx6oHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 09:50:00 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

...
> There was some (hallway?) talk at LSF/MM about possibly removing direct reclaim,
> similar to how other operating systems handle it. Now, I don't know how feasible
> it is (I guess devil is in the detail ;) ), or any details how that would work,
> but direct reclaim was repeatedly called out as one of the main reasons we can
> get huge stacks.
> 
> So I guess direct reclaim (incl. compaction) is one of the main problematic
> pieces. Are we aware of other scenarios where we (easily) trigger consumption of
> larger stacks?

I suspect some printk in error paths could get problematic.
Especially if they involve direct writes to a non-trivial console
(does that happen any more??).
How much stack does dump_stack() need?

> Wild idea: as a first step to test the waters, use smaller stacks on selected
> kernel threads and disallow direct reclaim/compaction if the stack for the
> thread is small?

Or if there isn't much stack space left?

Isn't reclaim one of the places that is actually likely to exceed the stack
limit because it is unusual and won't be exercised at most of the kmalloc()
call sites?
One you get to the slow bits (especially ones that do IO) it is unlikely
that a context-switch to a special worker thread will make much difference.
(You might need to boost the thread priority based on the priority of the
waiting process.)

	David



