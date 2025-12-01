Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F17C0D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343DD6B0031; Mon,  1 Dec 2025 03:59:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F40B6B0032; Mon,  1 Dec 2025 03:59:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E37E6B0062; Mon,  1 Dec 2025 03:59:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9136B0031
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:59:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70C2813239C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:59:33 +0000 (UTC)
X-FDA: 84170303826.19.8602716
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id A107820008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:59:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xrl+CGqt;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764579571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIanSllFqG33Sgl7Ezxh92IDocVsN6LhPgRC6hyS9uI=;
	b=Fs58YdfzUzvTcc2GfSHOi/dQuJg6iZFPEffEjiil7RyqCBAXHOA+dKLdxl4z94DogIzNL+
	mM548LqW0UMkYXaRnR6v5bFmgGykoFU5Q6cn6MPeEEWsjqPLouypVF3kU/zKmCQs/GPiYB
	MbqmzWGkxD4Ta6Fon6+Rv7MUUxmONw0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xrl+CGqt;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764579571; a=rsa-sha256;
	cv=none;
	b=7C1UkhXsxfcUB1j4Wz/svg2djuuHyDOSvAuabfdqKHM/QdivRO1Vkx1fHgshsbl/1+2JTq
	6/nfgz4MS09DOOgNJNOn6LWG3+2qmYnhAAToMEfj3VJJtASzAtKV3svYi+egt0EYgWzxKt
	rvMoqa7aPkMbbymsRGroELTKAbDWSlo=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b2f2c5ec36so401463185a.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 00:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764579571; x=1765184371; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIanSllFqG33Sgl7Ezxh92IDocVsN6LhPgRC6hyS9uI=;
        b=Xrl+CGqtu7BPIsG/FqPEkelCACInC2BVYWEn3o9Iq/sGvVwBc9JM8rye1d8gNwhe1B
         sMPBj6hfwzxYyGiKfru+b0BNYhyo4TTJSp2kUiCy9oWXCIDzshe6qUUPTJDLROz4DFD3
         xGJp5qLsaImtlqTj7g32jdl4DjKVmMb84hwv41fWZVavUZAeX6/W9oOsNXRAofYX8XTA
         FjHCu4VFWxi6j2SKjkKhexqIvTcLaQrKnGtBWDOUYj6iD1zyECHxArJp+85L6lgaTrad
         9y7nP/HQMgKUwDtBQ0z0zi9vRNWInLGOCbe7Hl+MKxLaWXI888vjyxt9DFwNNuuBprV3
         alSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764579571; x=1765184371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nIanSllFqG33Sgl7Ezxh92IDocVsN6LhPgRC6hyS9uI=;
        b=N9yjGo9WBIfB8jetoXHw5GTPpM3kis3KyJxW1DljMGVg8O5Xjb2Y7bqzhcjHna3Cf8
         NR6bCsXWgqh6r4nwQGKFK6ZoiJObHoaAODF5aavslImQsQzudpm0v7mkdD9PsuVeqHh4
         C3d86+5GJHoXxgOQw3QKvd0CtW69U4Y/oXeX0fVx/K4HR6xClsERssbBjEO+gAl6IMiH
         hrL9+SbE94ZArGO2ukRrs/ZQKZsDOB2HtQqKVXORikHKojhQEnAFLNoRkX4zg9e/pF5H
         ZmGw5SBmVVQNSWZ6L6ChZzJxtPZrBtXGaAGsqyE9YBcPgT5wV477a9XParWZf7FCv4Yf
         zPlg==
X-Forwarded-Encrypted: i=1; AJvYcCWDSocqgKgP+M67/z+HOCHcQ4AgvGggND1hpvIfqaLt7r5gCNLVC+/C8gppkMRNSA5WpxN3GwxUsw==@kvack.org
X-Gm-Message-State: AOJu0YwOPYjPNUBdOvkKWE9uybJNOC01JTn0+hMLc8MbvDE0+BlZCw+L
	yC2lS5++Qj/Vg96DL1A3mnL1sLeBYSOrktXZoBO9KUXkaOJGijiw1O8fKBsxd3GEg8QE8IMVMDy
	+iIGtrh1E1pER1+3cWgmNGZTMOTg2EGg=
X-Gm-Gg: ASbGncvFGBQ7k1RSq8M7PjtelHjqcb4JXga9wDD+5I9Abw24myTaNrB5R0stb7DCAKg
	O4vS9Gtds+xCvKn82X7ykooAjWJE0yHbcWqzg5NKtVOg2I/bo9TykgklzsRvC+9vOpZa/xW175s
	W7tr/7+5GA4vIFvnuCpjqnClVP1zwi91M+CsNK1wGQ/wEpB1bTVBcBC03cG2i+ggns784dLpaz6
	zznH+SYgO3gwtvFjX+9GCHMYsv2FlRtVW46y3d60QLNVyzQamHG0ZnM5KGga/IxqgLZ+sIt3Ud6
	jKar
X-Google-Smtp-Source: AGHT+IGtLr3Nq4rRMA1kWvJ23/JQGdN/w3P80vB49a36eyFlSN2VSyqO5InE1vq6DOeQouP27k8n6K4eGa5Bo1kqhjk=
X-Received: by 2002:a05:620a:450d:b0:8b2:f26e:3226 with SMTP id
 af79cd13be357-8b33d23c358mr4556062185a.2.1764579570507; Mon, 01 Dec 2025
 00:59:30 -0800 (PST)
MIME-Version: 1.0
References: <20251128170442.2988502-1-senozhatsky@chromium.org>
 <20251128170442.2988502-2-senozhatsky@chromium.org> <CAGsJ_4yUAw_tzX7z8iizToMB8SDJPNOhFRZNXva_ae46q5vRwg@mail.gmail.com>
 <hgk3zp5hwlcxo6ufiqasvte3hoksy2wb2kta3fime5rprq4org@xaprrqdabvgh>
In-Reply-To: <hgk3zp5hwlcxo6ufiqasvte3hoksy2wb2kta3fime5rprq4org@xaprrqdabvgh>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 1 Dec 2025 16:59:19 +0800
X-Gm-Features: AWmQ_blOS7Nucw2YNUQvfG1rNrEP4YVyGX1irEsw0vGItmVtTPTGRytfhTT1B2o
Message-ID: <CAGsJ_4z6kSvA+Yzqx=JQ4n3jhQRWn4zYMr364-V2Wjyb2wXE0A@mail.gmail.com>
Subject: Re: [PATCH 1/2] zram: introduce compressed data writeback
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, 
	Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A107820008
X-Stat-Signature: 7oisfc7s1ypphjofb8prwwofnku83xi9
X-Rspam-User: 
X-HE-Tag: 1764579571-573270
X-HE-Meta: U2FsdGVkX1/whLEANdo5OvrSVOyjUCWUVytWW6vnTlYgidd/2xouTAL8WYEOXZtgptPcyCHfKYL3py4QcOsBXrQx5KHcMtn8G00VQEr641D6nE25dl27YSt4w7R56qURqusLHbiSl/N0jq6l7S8Bjr+zIyK43Mz25ehkhcw2WpVGMl7rarx1FLdol7zh9kBiedvXM14TUt0fnFtL5YhNZTRiV8dSPgjlBIubcWOyMeAsLh7aBqcvNl/R4raCfo9j0c3ChtS/UqXTFxs39CNLvETFQzv6ZALGfnmd0EKm43lR+htdHide6CXF0wRQ14oUbnBYp8YvA+zg2KfVZR3R0vStId4pfFATwUHxgZ0fVT3oZPy67yWnl3S6ifkMTrrgbxftqXqzdFqLr8ZT1WW2qFI4ss6hp5ObvdI0kEJ3XZcJhLYuJmV7XtABhJ6keVfx/Z0lVGR7LUfQLf2Os7o+qLgf3RFGHCxLMSEr5jxVe3hjBbfZHWLQBPhtyh6WdI0NIsayU0j9nFyBXvgbnRSGcs3N+n4J6dkSO/qvkGQFWT7VUQcqKhluLBB31MOj3D6ZAVkdq0S4DDsaGp9LNiDRIkYWT+SVIRwQxGy1obap24MwblEeCMP4hK8WzzFZGQTAKdf5ottB2Yl71cBU1UVQBZicx6jHoGNorwr/GGPlnkVueiK5eSul7qVH8mTw0C1AaHopE/bMUH1DI0qZ4J68mxAdi0vGPnbyTmHVapdviTCSJjrlmASYbG6BeSX/HzpMxD+ssXRz+tdzWoiTAznOzJQk1V0unkIuRfj1Dl6mnXTv45vzsPUFSeNe+PRj76TOxS+6crXOKVVf33xlmmYz6Ms7YnzlMBO+o1hecUi+Fbr/VaIi9PKzyUg9/UdxyYWLvntOJrUUQwQcoRuelfnvokQJ4Hg0AX/wfWTUzR/89uaMzQ5eIXwOVJUHOTh5eIZ3/OplyNLxgRAA0+kfGGC
 GFtnkFMO
 K57oYRYxvJSliESf3cohUDS04CKUMdVKtCyzxlEhehuroidfivKd6b4wQhYzNAKqTnkC8SC4vI4CS7WmuE2xxfEtKipvwoP3KY/w9JUVUeVmm2E0Gi03cb+dVJOQ5FQo+9Sq4Apv/8ji533/mzN7PmzTwHgYiwEStjyTXuDzSRyfaZQjGKz94IRkB0SFm59VyXsIOdXMIZtebErObexchVosO+CdAIPambxCbpLpnXCuSt713r93sW6/ehY08blZaL4VBhDGGL4QvocqDyDyNcYh5qlk3Hi2uU7QAzwp4Dcc8tZqnAjXxljjeN3+QsEPBwxmtTzF7VWX8Jf9GlNAoYLn9X74vwb44QkOmDCOJR56Zlbcr9avCgGm17p1GEjp1jD3n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 11:56=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
[...]
> > > zram stores all written back slots raw, which implies that
> > > during writeback zram first has to decompress slots (except
> > > for ZRAM_HUGE slots, which are raw already).  The problem
> > > with this approach is that not every written back page gets
> > > read back (either via read() or via page-fault), which means
> > > that zram basically wastes CPU cycles and battery decompressing
> > > such slots.  This changes with introduction of decompression
> >
> > If a page is swapped out and never read again, does that actually indic=
ate
> > a memory leak in userspace?
>
> No, it just means that there is no page-fault on that page.  E.g. we
> swapped out an unused browser tab and never come back to it within the
> session: e.g. user closed the tab/app, or logged out of session, or
> rebooted the device, or simply powered off (desktop/laptop).

Thanks, Sergey. That makes sense to me. On Android, users don=E2=80=99t hav=
e a
close button, yet apps can still be OOM-killed; those pages are never
swapped in.

Thanks
Barry

