Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9B29ECD6D0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 18:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E7F6B0005; Wed, 11 Feb 2026 13:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E978F6B0089; Wed, 11 Feb 2026 13:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79446B008A; Wed, 11 Feb 2026 13:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6B806B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:20:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58D8DD6BC1
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:20:04 +0000 (UTC)
X-FDA: 84432989928.04.5F2D519
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3F9908000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:20:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KvTv1/JG";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of tamird@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=tamird@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770834002; a=rsa-sha256;
	cv=pass;
	b=VVp2Q2iQAuFWXGVXf8izJIAG0fLeEV8yoYvzIvQvIBFGzMe1IJUK7QoE9hGoEjJujzK42D
	MrElrlk15gGDoj28ycao7ivcxLfqrEq6P93IwI8oMmqe+zs4TzHkTDQbprsBrwRiyL4OmC
	YqDKIloUW9/QnmsA1+0lQ9KjwVDN83g=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KvTv1/JG";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of tamird@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=tamird@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770834002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wwv2MRWJWDelneWXAYXVt+d+rlSAiITbFJ+Xkl4/lko=;
	b=bNuG+VUJm8B0JabHznTVgGLKCFoDnfzZ+HQGVp5pNOzsuuMZNsQSLjzIfrmSff7pyQ9uEg
	wkTz/OL2dJ8bD+asj5a5RRmpdn/9IeajxVz7TvkvNYKU++OcwQsPCzxf+fezYtHGwWxEnO
	3Wb7aR0tRDXpYbLoZ1qH8UOrKq65/KY=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59e57973dbfso1020926e87.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:20:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770834000; cv=none;
        d=google.com; s=arc-20240605;
        b=Ky469Ve1ZseKAlQDKQGRq1mDFcq9MAyvGtItjepv/do0tCA1jDDuyP9YdnwsXPSh5k
         uth4PRabx6nYxQWQ4nDIbV2GDhWGCl4F/d6sLxKAwH5teKhGBqABaKTi8PpDHHSDkg5Z
         7NOnhxTDWr5vj7+3BVSp0HBD0uqYoENGxh6BuUOHKfRctkUqCUPY2/pzOjQRFrrrFTUw
         S0t/OE9SdAbRLZvmHZW99yL1Sgw23wwY+RCK6a9RCtmmwo3il0sgBIBiTrtzcRlLlNcs
         L0BpfRZUIp9Ua35eXflpTuTOAnfG//DzuQWuSou6/9MpKoS2PEMtEaeuUF9+LH2c2ZUP
         T1pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wwv2MRWJWDelneWXAYXVt+d+rlSAiITbFJ+Xkl4/lko=;
        fh=bDAI1/iBm2oY/rNZal+oaVO6tGGmOyoUKi5T/UvX3vU=;
        b=aYYY0MbVZ0+QyK/5oOS3EnWsYKalQFDg7jPSgoDy1qlbewcl+YHySA077QqEUhXica
         yO6IF7Fu33eDD+USMZ9BQxyIkwBWGBCtTGTfRRkDjSEN25U1w4xTwBW7p237yTV+pflb
         5FdZum+FvUxO+mNGNWEGPPLuUy6N/LIW7POGXCxq64UeCHbQiqLIB7dDWezo1Le35fbl
         OT2OynG9AsKZwK5AULeHWt+pKbJBlmfrFlrtczZG5yWJuMyPU3dcXZ7AgaFlzSN02BW4
         0Faoxx4467J/PN+TKClip4116lrovdWxVHq8vvCdT22fx2QbD5DEWTdMADYNkkWOrish
         oWrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770834000; x=1771438800; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wwv2MRWJWDelneWXAYXVt+d+rlSAiITbFJ+Xkl4/lko=;
        b=KvTv1/JGbmXeaYoVBLp2oTw89RnZ87XwILIz4AZF3TaQEtW345qVHotUh+YMqUxkIx
         3vZX0zhc2hK4/VAaDQAkqDTxh5/l+QeV3nex/yPA4YhGdPMPsacakJo8fElN3DHDM2fr
         rX1bvxUdyboBtlvTqYHIqdmDfFXUeH8MDJvZRxcsapsN8hrUZyH6o/GN70/dQjoKN3YX
         r/k3OGFaVxOvXWyX+OwJMon6s4jaD7fZwbdxDc/2erC7SFhIkzoUb2z67dgFQwZ9gNEK
         sIv8W4QYHDEbdlCJ5vhz/2qOj9PG0wIO23szhpBLldLXdRuX2vrz/0cV5cGf/1q2KAmX
         4hOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770834000; x=1771438800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wwv2MRWJWDelneWXAYXVt+d+rlSAiITbFJ+Xkl4/lko=;
        b=qGpnSobQdXMFVnYKcONzSuGATb8I8GurfnFVyRqtQGqnHJgqHmdkdrF9Ioek4Vo1g+
         QoYp2Ip1vU0pAYcieLqpzgB7cU+OmJAOVVSS6oUZnrsIeUaAHzYWOjt+rFYXAQcMvskQ
         wJliRQS7nBLLlD9QJjDM9aH2u/IRdsuSqqOFNd4SnnfvW4usSULZ3Z2U7Nb2I34g/5Qi
         YHqoYt8Bj6Z6aOFSmICyQHSrRxOn2eYpKIMDAWjgEc/u/z277l/3hzPy5H5EBXLkCyz1
         CK80RtKIte2CEsq/lVkKn26A1PNg0xg/Xk8EByAboG3rwIk7DdS1X4w+23ARdZIyvXQX
         9sBA==
X-Forwarded-Encrypted: i=1; AJvYcCVvQd3TU6aGnTStynqCKSaTGBwrnkPte2bvUWARzVx4KQA8pRLGxn4vSXsVNRgFdMUThN1q85dNMA==@kvack.org
X-Gm-Message-State: AOJu0YxK5pz/S8L23VkUf1AZstvtgic9tA83YQ6g+SyCczeSvQUxTiNl
	e2FqiKH+8eMr49TDyNabo2cfnXNhGc+CuDXuajSQ7OBpZlkXX8rMdBH3t40XSm5NppLHtbkyMnZ
	qbqBl315q2mwjNzN0qNXHc/VdCX9jNcE=
X-Gm-Gg: AZuq6aLNFPUdXSopXq8Ai02VwNeIs0fRdYvzftK64bkXHQDu2Gv5xaBWydwC1Bi5U6G
	TFxKQdZT3Ucr1Y1cJ0Ghn/U9PY44Wf6X9O7fHXSUUmIrJofdA5hyHkSIcsaGquIW6xaB9wc2Jmo
	7Upz7cnu6zHCGZnyVchpVl8x2CxMyhnkfar57YaM6KNlNCr0sof5GJkRTMHjW91R5tWBPLDG8Or
	GmzJbugvteEFufCNolBzinMtOrenOzLGWgbUZMku4j0PEokQIkUVC7QGkfSusE9yZt4adJAkyhW
	46qEc9oHmqbx+H7+Yt3unIFIUOMbgy4yY6ovqBob3kaxFqlZy91gihagysRr6xszccazbLT4aMn
	LPR6pt0atDOSNUCfgzCFQi/RbJrtS424=
X-Received: by 2002:a05:6512:39d4:b0:59d:dffb:cd70 with SMTP id
 2adb3069b0e04-59e5570b02amr2705121e87.21.1770833999963; Wed, 11 Feb 2026
 10:19:59 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org> <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
 <CAJ-ks9njGhT85pgUSahki989Y9vn3XOBNO5wxB8wE+KvbL00wA@mail.gmail.com>
 <6sd4numrxigibwynr2lfmtdj5uabggrx2l57igtjbnq4uwddrm@wipmwcmqbkjn>
 <CAJ-ks9knC3pKpiMaG6f3C1Kr6su9p26hM7YvVMzsVwYVHGtm2Q@mail.gmail.com>
 <CAH5fLghKwNEdVeRi3H3LQ9NTPYprpAeY41-jgfq8YEST9PaGdw@mail.gmail.com>
 <hq46fcdy6zvwcwlbtbjynqadiwy3wjs7raxioime2et5amzez6@wvzzlkiijwvf> <aYzDzeh1cTN2TEVz@tardis.local>
In-Reply-To: <aYzDzeh1cTN2TEVz@tardis.local>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 11 Feb 2026 13:19:23 -0500
X-Gm-Features: AZwV_Qgt8SodEZVfr_PtxY7GRLgT7F5bLlBbZTxAcShbVYjdlk2aQQu3bD7qBRI
Message-ID: <CAJ-ks9n0-Uy0n7CsZwPr37PSc_wo5qYG2YGVsGN50oPZN4MrSg@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
To: Boqun Feng <boqun@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3F9908000D
X-Stat-Signature: 3c5c5dg7ctbou5cqzsw449o7rg1o8r9u
X-HE-Tag: 1770834001-271264
X-HE-Meta: U2FsdGVkX1/v9m9HiViq9nVVxknJkkEAHTSoj82jsXho+h3qQonsbzCRpDEvgtj90SzSk7Ef3wuxUERF7Br6CArFexbgLKnL1pI0+0YG7d9kwzVKx8aQ9guR1gm7PECZnfaRg+cap+LkCSU1q+JsRp7VyRDhBFRNBuf+50bAsUsyUQQMzjzhgEOANu7j8xPnz1ZQ3Cb0KD7nbEDz/34kb/Rk1s1hE98Nz075IAQ/Oy0TdtDiH+DbQh9IdjJ8yMB6i5lDkk415DBwDCoEGTmXr+HVQL8ub+Aggg7LlgDZBGUkMu3ZaMboQP/LuHyb1GaxoDdhu+vqwykN6bqqpzfe2nsEvGJTmtC3FY7v66xfG00hhx+43PsZhlsZHn03Oj4lUhSRDlUMrcBoB/G6BpGCL2L0Q/e0fN/iWYz1Qh9IN9ks4rHulczrKkQQFbjpsOWuRPZWgaQfCfmdvl340DBuBLr9KerGFdlfw6KPW4R7PnAGzMlKJclNvFArBOl8Gl/uCIu8sKr6wWU70P9FDzReUTGcIEc69W5quzkmPaBoNSzbwS10XcCDcIolKwWrUYz+iWuuSvUOKoDE4hyqW4bAS1J6CBy/sUTraDLjAl1EWa/A/sYQFe/ryZZLSZ3Nm/T5PMYlaOaV1pdSn3PHby9Kw8uvreZikzPZ9tDv7JtWIPjdVw29E25gvV3gyNzyQ8ipgh268Kv4EujxjFGvMcmXtPmU0DozVEVratbmjTs1yXfh2UuxJTtfxjsQHsiqu0Dq0O6g7VvvwSPgStDoXowHBOojWCulUURuDMDszC5krdCToDSIOs1X3a3nJUa21dlNqfyOMMfej6Sl/Caz7q27F2QN7Du0G6T4XkQR7bbu4zhMUmNVPM5Uw2UWQN4tYWP9WYT93Sq50gSCVPAVr14D32+HfRqlJgV5LxitiNLZr8/uLflL79mFnxcTUFMVJUgNzG/hhGrOTuZqzAaWcMp
 MReRPfrk
 za1zisW0ZZhItYb84ykr+MSZ4ircbT0UJRz2tCQPbPM7e6PyYDmXIvlBYTM675ZySTSPNk4YkfgGW2efATSz1VyLYZogFN9RD6ORdA1A/xYq2cV8UvdHmIs+KZt+1m1w/EIi+aSUxoRJKPQqwXdU4rd/NauO6JROgA+jxM6pYOcrgkmLX03RzBXFqL7n8Qj7TNY8H0ub37rmGuGvq/TX8mdNAYwprxUOwqeixD6CDXKeKhy0msHmixDPFHyl3zq7JdvTmp2qWYAMQYsW8bHSVoWjiKhVa6Y8RfymJso8+YDsJcAfAOGfoonqxkTfWixXkh8rEBCsjVtmrz+uXcBgtMJYy/K/uWbq+VYlclWLmWISVFSMIo5Rhp9kywclV6Tcp4cUYEXoHyg1qvG7mQhhHs7+V2m7vI/tiwYQL6RhmxJeHJkvC+gki7VjbVowWtjfL/U6WZ9WVee/Wk9HoYeMNbV/K6xW02HohcgsP2oqYKX4aVLhwA51v8GLJmZgYXmDtlnCDLxlj/anFGadgV5lsBlr7bLPyDQAIYWxm4AU50bJxzL63m7akm2BdZimAFXGAbJ/jgwOdM53+lPBRPcucP8JM4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 10:00=E2=80=AFAM Boqun Feng <boqun@kernel.org> wrot=
e:
>
> On Wed, Feb 11, 2026 at 09:32:36AM -0500, Liam R. Howlett wrote:
> > * Alice Ryhl <aliceryhl@google.com> [260210 16:34]:
> > > On Tue, Feb 10, 2026 at 10:23=E2=80=AFPM Tamir Duberstein <tamird@ker=
nel.org> wrote:
> > > >
> > > > On Tue, Feb 10, 2026 at 12:59=E2=80=AFPM Liam R. Howlett
> > > > <Liam.Howlett@oracle.com> wrote:
> > > > > Is this a temporary limitation?
> > > >
> > > > Maybe? I don't think RfL has good abstractions for RCU yet. For
> > > > example, exposing load directly on the xarray using xa_load would
> > > > require a way to guarantee that the returned pointer's target isn't
>
> Well, if we only return a pointer, we don't need to guarantee that,
> right? Because it's up to the user to provide that guarantee. So we
> could have XArray::load() (not Guard::load()) that just calls xa_load().
> Also see below.
>
> > > > being concurrently mutated (e.g. under the xarray lock). I'm not aw=
are
> > > > of anyone asking for this, though.
> > >
> > > It's relatively easy to add an rcu-backed load using the RCU
> > > abstractions we have today. I already shared an RFC containing such a
> > > method for the maple tree, and it would not be much different for
> > > xarray.
> > > https://lore.kernel.org/all/20260116-rcu-box-v1-0-38ebfbcd53f0@google=
.com/
>
> I need to point out a difference between xas_load() and Alice's usage
> (also what Tamir mentioned above) there, what Alice needs (at least from
> her patchset) is the existence of the object is protected by RCU, i.e.
> if there is someone else dropping the object, a RCU read lock would
> still guarantee the access to the object is valid.
>
> However, the internal RCU usage of both xarray and maple tree is to
> protect the *internal* data structure if I'm not missing anything, i.e.
> an writer may change the array or the tree while a reader is reading,
> the internal structure itself is still consistent and valid. But the
> nothing guarantees the object you read is still valid. For example, you
> can have an xa_erase() racing with an xa_load():
>
>         <writer>                        <reader>
>         ptr =3D xa_erase(xa, idx);
>                                         ptr =3D xa_load(xa, idx);
>         reclaim(ptr);
>                                         use(ptr); // <- object may be gon=
e
>
> the users of xarray needs to use other mechanism to guarantee the
> existence of the object.
>
> In Alice's case, she in fact used an RCU read side critical section with
> a larger scope to protect the object as well, which is definitely nice
> to have, but not only way of using maple/xarray.
>
> > >
> >
> > It would probably be worth having two loads then, one that does
> > rcu_read_lock()/unlock() and one for writer/advanced users like we have
> > on the C side of things.
> >
>
> Agreed. But we may need more ;-)
>
> Here IIUC that Andreas does is adding a `load()` for `Guard` of
> `XArray`, which is the load for a writer and most certainly you won't
> need to take an RCU read lock for that. The load of a reader can be
> added as I suggested above (similar as your "rcu_read_lock()/unlock()"
> suggestion above), but no object existence guarantee. We likely
> need a third API that can provide the object existence similar to what
> Alice had in maple tree.
>
> > Or at least name the load() function to indicate which is implemented
> > today?
> >
>
> It's a namespace thing ;-) , the function in this patch is
> kernel::xarray::Guard::load(), and as I suggest here
> kernel::xarray::XArray::load() should be the same as xa_load().

Just to clarify: `kernel::xarray::XArray::load()` does not currently
exist and no one has yet asked for it.

>
> Regards,
> Boqun
>
> > At least on the maple tree side, we have both interfaces and users for
> > both.  I just found the change to remove the rcu safety odd because I
> > assumed both are needed.
> >
> > Thanks,
> > Liam
>

