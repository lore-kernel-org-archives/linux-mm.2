Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10CABEB4907
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BBF6B0005; Thu, 12 Feb 2026 06:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549786B0089; Thu, 12 Feb 2026 06:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B146B008A; Thu, 12 Feb 2026 06:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 333356B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:28:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B53931407B8
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:28:09 +0000 (UTC)
X-FDA: 84435580698.04.CB6E1D8
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 965F8C000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:28:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FbZ6NIqI;
	spf=pass (imf22.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770895687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWsHrY3nSaAV8Uk/Fw453PhvLxz3Wx17ky2P0NRI7jE=;
	b=DMBfniURwvsecXazERgxUArOJJBOTqPLVJ7PibZJlyQwRc839Oui91eXUOYQw0SRNKV11c
	CSn+ofhINtUY9H57Gugm0YU6mxOBHUHU91+eqZFHyBy9psCCpJZSk2jOH4oflDp85i9axY
	5Uhh0ckqX5ct8l0AH1rm7TAW5wodnBs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FbZ6NIqI;
	spf=pass (imf22.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770895687; a=rsa-sha256;
	cv=pass;
	b=vzoj4oq3WF78c80kUnkAr1X7RovVhW8VSa/bSjPV/3X64PgUQPds3qI0t8b7wxyj7MZCVk
	Jl5XApm/T8XgSc/VzbE8hSv1IPBzJBJ8gNHC3lINshbXMPIEtvmAQeqe6fFNP3VecJci/1
	EtJhZSDUkiihzj3pqp/+0OFfgec1cAw=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2ba4f9df1b4so294658eec.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:28:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770895686; cv=none;
        d=google.com; s=arc-20240605;
        b=bYOZGvFS+KkqMz8U3tzFk/TQ6HKD3HTBgcEqMzoKpKtr6U3g6ks/KxvS6g3RH/cWNS
         MsOt9MR57B9q9f1FOHNijGnI9N6Kjt7Ghtypasv2rZORBDJu1UoXgR42/LCeX1YdvhZk
         RAmfroZqeyb92UbT0QpWrx1tsRmRPL/zQPPM/YkELTD+C3jQPQtR53sb8PVvl9Mx/AcG
         RDvvZuYGYVj5vhjxYprAx1r/f56LfqnNv6joD5GzzAT57EMg7RcRbqBBJpNLhY3apknU
         kefS6z7Zv6OBFfry/kPhAD25nsIVjw1r+pBGvkw6zVM8/hbzs9ILhg8MDNvzJ4GaF+Y0
         DvcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tWsHrY3nSaAV8Uk/Fw453PhvLxz3Wx17ky2P0NRI7jE=;
        fh=BJMW7BR58HYbZ+uTK0F/igCaTaJdH3q3hOQhuuDWsMk=;
        b=XBYgrAMhhBbZ+tADp8N6cubsiIrNzGdzv/Q8rn99OGpgMoth15pn7gdHrMn0RRws8K
         4Vdu8LE4BeC32eMij0TRsSrl2OCy/QvHnEwtxZZ7GODw0PXf/BARW0Te0HMCw6DGSIN/
         ZV5l8Sb3CpjEO9xcixaIdiag2JYSCQ/aBzTjL5uPvU3G05x9so2woO/nlzgRY8XJtzvj
         fBMEszEvVoQZAXmsiYDp04h45PjzFDkNLV6LuMPrrmazf2L0r6G4qp3I9rxayzZg7JBk
         bAL6zfFJkTbi1z3H7z0ymYz0f5OEldLqxmya0xeShvOWgFiVgenp9ilwXZMscB7W0v3r
         20iA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770895686; x=1771500486; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWsHrY3nSaAV8Uk/Fw453PhvLxz3Wx17ky2P0NRI7jE=;
        b=FbZ6NIqI/YW0TZtUmD/OEb7wv7UDY18NvHLePupgR9oGkMJwNc1fLbPoOcEUKa/pqq
         Gq3g7pCSvTwFq0aXXvm4wpuhIMNYZ1cmwXyWAZLKHNNUEopyDrc/Rm2NM16+zYlQYhNm
         BtYIabphPrgGhhnyyaZyJWiVsuP/sAAJBOEymdipPuhs0yOtxVTNd0Jz6NnyO4iHHlgm
         gF3Wo5OGxhipPon4dMok98e2xxX+P4TqF2pLmbrKoCQDFh58Tkyu3DOTL3FgnwH5I02P
         xf72Kixw4x52bt1sWLHNkH9naILdHIAStiyYuzpHrxuI5EcO5SNDqXS4zX1OMSw+Prh5
         IHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770895686; x=1771500486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tWsHrY3nSaAV8Uk/Fw453PhvLxz3Wx17ky2P0NRI7jE=;
        b=g+gxBNAWmMNn+vbU3besMBpd8brI98paGXFKuiTWVAqrvvLjYJV0Kt/aiuKwFZTXG6
         Zm5VbaLjaKXGa6BQ4mkwLEyl1Ys727RckuqQENmF9hSf5O5wwmn7i4aExDVjehGwF+bm
         ilabLva7EczPinoOp8Qotr6OqrIMWGyLLV8L/s35xwyRvEfYL2OAnUsK6CIn1iItpVaG
         7vw1csVjpVR0l+CWDa3KI3HH9rwQkElqlsisVCxHqQbRVACHLy4/q3laY2nNH3JaPCvt
         52NProB3bXJBIOPIhpi7pvEi/kQww/wwH/Q0S+XGO5bd7WM7Ihn4aD2mxIj8905YYaeX
         03tA==
X-Forwarded-Encrypted: i=1; AJvYcCWM0WRIIpPEgGvQTIQq4l2otU+jfHL5SCtsafyvzFI3dK7HS5Gy2n4mu+2UDmNG7Y8HgDGzWyD0ZQ==@kvack.org
X-Gm-Message-State: AOJu0YyDwIlvUO74khusYRLGq6eAYkCv+IBu5IYoJtMz8CKBGgfbbqIQ
	ZTzAtGO8du5AAdZlKpbAp0wICguNiuAY7/xqgXmZ1knH3ZKkBROS2NFE0XGDWtgidZmFEo5gble
	uyDiKQnM8yu2fPTpWXNtoSiNOj5hdxn0=
X-Gm-Gg: AZuq6aJ8vwf5YiuMfg/gR/PwlAhAILWAupcxwHmTvNL52dgp6+GwjzDUh1q+R4QTjcV
	cPbZaIK5ScZayV7x0TVs8putkkd+c8SFD4acGKyz72ZFf5xc+JNSq/oBUE8CoTP1Zy/UbnrSkqD
	0XugQMANpPH8czYW6em0eFuLdqpEY7Mz8ntnq5LBPLSxb6b/13Z0VTbhMl9vFwTA3SirZEr6zDH
	Z4NR4KX9ViCIFFkOtXPtra1PN2TJnY751J8vMOblQh7hb8WEkDw4MdBGFWAFZkFxXstS5jfZRcV
	ac/DD+JpDkJL3O7RUdRMDyD4/XDaVmoTTlJHhPHgYjql9XDsMygiGMVrpL4PwBxPl+UqZtEtRQL
	hBBVZFMpViD1/kz7wTOlKpdVC
X-Received: by 2002:a05:7300:e60e:b0:2b7:3678:2d1a with SMTP id
 5a478bee46e88-2baa808b83dmr526893eec.6.1770895686256; Thu, 12 Feb 2026
 03:28:06 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org> <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set> <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org> <87v7g2tesf.fsf@kernel.org>
In-Reply-To: <87v7g2tesf.fsf@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 12 Feb 2026 12:27:53 +0100
X-Gm-Features: AZwV_QiVAsOQVZ7ynC7mIB3Js3gb3mIw3gC3Oks3wXHa118YtPgoZ9fhYfCQAQw
Message-ID: <CANiq72=n2=96dvcLXF05Ta4+h7CyUTQNn2b64U4j=VB0xO-0GQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 965F8C000D
X-Stat-Signature: zpu5m3tnytkfzfwdusyemu96rzoto7i3
X-Rspam-User: 
X-HE-Tag: 1770895687-832691
X-HE-Meta: U2FsdGVkX18M3cCp+qdarcdyjobsWzGEFWXyDxtdccGjDhj+pUHI+hydQgyD/PJabw1bH01Z0f8upr3AsvqhqtiS5xUzK2SYhtYW1K/k9vytsa2a6GA02k88mmLEinO8KIXMUGvenoxo6CL/Pv/5PVWHkgiJWa8Tl8l9deZMIA/amLvMPeg5omo4NiglbVKXEHvV0i2EwVg4+L7/RCwz7bVEUqAj2v12hfQoB9wxAAG/dap43f51vz/eGWcSEiPhllYmwzq1VNa7MaNVy0KbhtKsuAFiJWT54HY8q0oCOO9U7QRSVERb81SX4Oxji2OXLp61ieskAwvnu3zhRz3FGRh3MSR9M491lw2VBS1yDF0+AZITTYQkC3GAzPpymS4lWVVqDCvhJP5kNz9N9WKHAZsctACyXfYaMZ2nzeee9zs+dHYarhqczeUSZJqWF0fuuaDZ9qoLitW0qjUjMsr2s9Ob3jCkmsYV6WThSe3ofrjHxjlimMO+1rJHiK8fB5lXq6IVfVWg3ji8NnF+O7wu0kW7W7GFG1y61N7QnRrXnXiHbE9hnZCKyej+qvWm2mUAeN/P21vzEa/91mpBobH8Sq5+WTabKew7vK6oUH33HpBqjJSVoxvJERyNQbPYbZMmUCJXn1LsjX6oaQBmPlGvWHpa/seaIXA5Qj9iAafUipVlOymoomq5Zk2obxauLuZP7jcxUHZjAI4z2dOIBXL1KcjBdp64VKGeumuiQLvsJPfbIt1Dqfw3xiWNMTUqIIycV9WqRiecbi2mvr/ot7EoL7nMnfcBqpxTMcl7U2w1SdBJneMCFnjgQHb7fYowa2GzvayOj4lsYAvEblhVQ9AcAe6xbuqaHEWzVI1O3J8b/LgG9tIYJf5uo6ITBZcMzfqqkZkv2nP1LNDgXQXsW1le5A2tcjOQk6CBIjtIDFw+piSwJTE/vMGRLh4UR2uFWOrfkq/cg5gqOACM8SXBcCd
 W9OOMIEO
 UaH8nPbhFuxE+Pp+Niys4K5qvF5lEPDcJ1A6o5H8UbQQegEa06v9EufWXWfk90LKe7oz1f7RnPMDGU4BrZlEnQCT3eHZhLoPqQPcdboPFsRMxcXKjSdL7HuUE0ujtKZ5AXpjZ67CenAw1Q+vPdDdWoc9Y3x0fSkaC+QT/HbA2TVJtdQVtxYc8jq3nYSILMGnDs1cLKQmxaxSxjxCl3VYl0qsLNhHJMGYbl3P61ukJ4vo0gGNydHE3MQXniPnWnKNCV9Y6I+V3ETgDW1qimD0vUpwsN6ri8h4PeU4uE4EZgMDKEY1G8xVRRE4lvE3AtYbdZmA+eJyfrjlXd3n8ecNX/jQ51uSe0+YhiapfHDRQBpDqdWPOXeehCaHhw/Cbp3m4pyaiACRnp3Kd6aKnkgnMPd+d8sqqZXMHNAK7xvFtZcZtI4s+Mj4zwhu/OygxSDejHf71E5G7CBixs257UcqzefcJi25yoFEZhs5bE9Zn/So0LGHUOx1Fvy+88bmFNU2f8ag9RgrWpkv21fPqGRR8GwP7kuzBslNfzhtFz8Zx5Kr5P6Sf44/KYibE4GVduk4kMlbumU0pHyjs0brNNlvYu6W3U8vJKr1BM2pWX4FjQy8npMer1zccyqseGyWUzV2+KnscFGXug1GqfBaMHmG74/SNrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 11:52=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> Apparently this kind of code used to be OK [1] but the Rust devs decided

I don't think it used to be OK -- I think that issue was talking about
code that required non-lexical lifetimes, which was an unstable
feature back then, and the behavior changed while they worked on it.

When NLLs became stable later on (years later), the feature never
allowed the code.

Cheers,
Miguel

