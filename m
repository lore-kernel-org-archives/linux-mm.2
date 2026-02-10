Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8957EB26EA
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0CE6B0005; Tue, 10 Feb 2026 11:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3881C6B0089; Tue, 10 Feb 2026 11:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4C86B008A; Tue, 10 Feb 2026 11:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0436B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:57:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6FB91B37CF
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:57:05 +0000 (UTC)
X-FDA: 84429152010.28.B334160
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id B12BA80005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:57:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dlOrvZvM;
	spf=pass (imf02.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770742623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NM8yzmMo0YvFNuzUYh1WtYxgc6x1N2Dyjb0Z3/nF1tA=;
	b=MZ/7WFOswbOG4qjloN2dcngHVH9MACEnMqtqaJcuNCvYQaCJcIammTzWF2l1JX3dGG6kmj
	21r/RVJ1YBFnzBzkl65MT7nOp3szJHRU9tRpgVcmGst+Si/iqSSwBNc6oSnqJ6pZY6Z9UP
	643UhG2Yvgaml0FJJz78xJyVxm1HAoE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dlOrvZvM;
	spf=pass (imf02.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770742623; a=rsa-sha256;
	cv=pass;
	b=Z4FCdj/opRVg0JCnpiAIuwrSw5/aM/34bjuxI7EPCHl8WgRWJQODWEsgVZPUh+cPhwJuPD
	5X/scyj/FueA8lnuZUDDQayQ5o6CZVkuWlDYEh0caSMCid3Ckf1432wzRo4gMtILP1r1//
	M/zMUfeVdVUqm61rExhe6yC5Dfy6bss=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-382fb275271so43787201fa.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:57:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770742622; cv=none;
        d=google.com; s=arc-20240605;
        b=cS5VsYiH7VCpVhO0MbKG/PNJzJlXjGd6EVI6rWHfqgYkcEALyv7JwR4NxzIA73xKtD
         dcO8Y10KC4flrjm4eQEfJnlyxebo3nzzph/aPMki6jBy0epr8W/SlDawKu2mzM/2XAki
         yi3tY7cYb/zZVl+lmskZD++6rjoY5qo+RbE8BsP3wgQ05zYIa92DMuaw3Iy32FSe0sH0
         mEct8ju75Tr4YPOQEDPOwxTl+26MFOOG5GKvC2+PaTbPuaDD4jkze/Em3MnFVHq2v2w0
         jbw6XcCWWxDB0QnGIo3qiI9SdmGnNBDB04QA9avVxxVmR4lDARTusaJzDry+HwoprZot
         PBCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NM8yzmMo0YvFNuzUYh1WtYxgc6x1N2Dyjb0Z3/nF1tA=;
        fh=pIiqZwVm47APITnp9jPFJXk+XLANRr47knqZZTCTq5E=;
        b=Hk4URgfE1ZSXbq0d71/EZQOgOiEnCI1PpLec3zt4YictTcRHUToLo3wVJQLQvDxB7J
         jeVO2hjdBABBQ5EsM/Qt0hK7UTgm62mMt5nH4REI+ET4+2cdU02+JrzCg92fyuAuo7St
         2NG1fUKDMvqietaX6wbl0QISv8cQnk+hfhNGHYy+/F9A8hyb8R6Z/P/6YWQ3h1khphId
         9tqPNKoK+LKWM2Oy2dh5GJpYWg572VXRfWFIotta5fu7gOdFpJiXFZ0TlReDYpQUh1zl
         jZtDE42Y/lil/IQbA3yN7Y1qkfaivJtmsgA3+75KSXg+gCa4dQh+cVd2qyzAcAE3KX01
         LogA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770742622; x=1771347422; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NM8yzmMo0YvFNuzUYh1WtYxgc6x1N2Dyjb0Z3/nF1tA=;
        b=dlOrvZvMB+Ie2PV3ftlKHCI3OvY2XpdkXz98WP7oZ9OB/VmTJTbsu2U13K+cvkHsZJ
         PuOjfFkSRRZa0D4oDEcuQdWXSE3V2XhAxtml8Wkk9DZUCV3ybD0uk+fXhrI7h89GEnYQ
         qkqy+VWxeQQqHsdeKtGyxKOsOGXyfKf0nDA+UynulCFNW9hSW9DebIML2zfCJIZGxjLl
         46Qot2532IjIzwpI/pxk7b6P1xzGRxV9uLlzXQOjl4rtXuWiM06twbzYG6G85g50843x
         c32uoSxYjGJfu1sEq4NOn+fvJZJOoHZyys9G5RzzmSyOtFaAtJuYb25WEFpq9qN3cJq4
         oPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770742622; x=1771347422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NM8yzmMo0YvFNuzUYh1WtYxgc6x1N2Dyjb0Z3/nF1tA=;
        b=O0vpl0gxR7RFLRBVlo0+iCo3RZKqf5lRi3hfqkR2Hc02gjrL+oy0NpldmGkj21Afca
         7/E8oG1n7/gJ6i8JwFHZuevByjECgR6Fzl/tpu+rWjbfvWS3KPSsYC/p8HRbuzrUgdp7
         1qQMS4DNhpQv4cXzEPHQnYBj0IpKkF9b6BPj3+xE4+mKDu5JjIUzzKkOQZVkpyA+cXaL
         Qf7r4ND2C3wx4yKAU6/3F71Z/RZ0LpjGRvjkt5aNPi5ipB+mQpdByZ3fKzenSeNG9x85
         P96GlxKGIzj7FnHRxmWvUHL9zYDXuO9Kao1sZFbnrflIxgU7M8B+OqYp+ih85GhfJV7N
         7Csw==
X-Forwarded-Encrypted: i=1; AJvYcCW66Po2/Vrcg+OW/yodxLEjR7f/hO2tePaEkKjwfJjVD676x8GS6aevNs1zQfja7aIJYbizavHX5w==@kvack.org
X-Gm-Message-State: AOJu0YyRGcVxL91Lqw49sGlmXdxQf8MJ5iUC9bHs42R6DdXIsJdXf9dU
	keXUFqm+8eciWKA5BnP9FKKdiCjI3muEGTjC+NHdCjmOkTItIZyZ63AJlsGaCAN1DtObVxAt8HR
	wGOY/EPblm5wcNaYc9F3BSA/SsvDbSSc=
X-Gm-Gg: AZuq6aJ0jQXHmcM99vn4AF3VC+INitEX9DsDfv2P4sGcvXmOHOZ2h9wCPqmt6Yjg4p3
	gKJ1aPkPXm0G23cmfXIVxAEEtHJ4ld2WuTHm603wkQ2XIrSvrFLE83xpwwoD2B+OqaRyRCa1ynj
	jt9XcgfbVLa7vbrYtY4V+Ng3BQ1PEN+qQyvBjSb42JoGVOSr+MpCqUOYqPmCwprSNpfi9wDBV5U
	D6zbFhlC8cWQ3L0P267V9u3PhPVfgicKmkOGuJ0yb6J2Ga5C8/pYL7nEcteZ0eGFibskXHXCUu0
	TQN+PCSkBY/Nv4os4Oho9hoYgFKm+arYBjqNTO3BPQ2uY+Tq/1qeQ4fFjwIMRtqpaCNHwoMyetd
	we47JPCtR23/b5zzZUkqt
X-Received: by 2002:a2e:a58b:0:b0:385:f7ce:f31a with SMTP id
 38308e7fff4ca-386b4edd477mr50694621fa.10.1770742621694; Tue, 10 Feb 2026
 08:57:01 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org> <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 10 Feb 2026 11:56:25 -0500
X-Gm-Features: AZwV_QhGTu-A3iYfBvY7CEYwEttuJWC6gRlgajiCgkGLDyHNWBy2jB23t8hDt-Y
Message-ID: <CAJ-ks9mF5x5mAUcfN6dWN-NWoaE=j-8h0y_F5AM2Pnfn8RcV6g@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B12BA80005
X-Stat-Signature: w5h8emfk59bd7figa36c5gsuo7foi5ca
X-Rspam-User: 
X-HE-Tag: 1770742623-771727
X-HE-Meta: U2FsdGVkX1/gCYcphHaYr0JxJU9YHq0BiYPU+OGbjzyp4WMqmDWaZfGQyftQE5yAkgFfTBbZgnG1lytheF+Rq4psFvEX3oxI8DaBIo44UAcF5bEA9rBgcaeT8I31r3WGfUehmuT/JNXFjwGyxvsweaj0vgVO2AKFULuSw0Ll7PLHHFfpp189QerfY+5Q5qF1fGYUSA2rFkYMkKr35Ekvv2ZiKJIrYZUwzTCwbzcdJWqP4IB+WbLbacf8BA8QQIKkFG9Yr2DOzly3g7ETTRF1CbRh7brG5SmkMGtrJy00PXvtiw/x7VNgrzewCtN0bYJnADp/JzulncHkik6/H5LY2lVksJHUsfHGZkcGNHMNB+o1WOvqwrxibzH2bVKWTxXnx2dLa2WKPOMJcyVBbv9UepKO3mfvv2iDLOiBh3ggHUt3OFX+HB3/hSNNMIiRyqIZzaHXQMeep5DhHy82t7Xs3vZ+5aNSQsjBroJ7UBu9MlVQnwJwl07/NnsvILGrMzG4ql37r2uQ8BN4cydTPcvmNdIKe7SkhLdCgzKfzzx79eMLaEQ7cg46zqLdnqm7j/0M2Nz5AtbNG2FeVGxCwcWXeQBQmb8knvfUpjYrnmKfCsOH6GXFN/S2QxC1LQLlfwLu5XrqnaxAsqOxDKU9ydIWAD90LoYwzdP2pfIkamoqkDKxCpybq7tMgnIY69AdgQHAP4nO1My8HHpL2mcw1slw5uODKC2KB/8y92PtIiEYQZoSyqIz4mrz2Nr9E1ub/xaU/eVYwNJyNVvJSRbY2Ei9IzCwInCDKsAyWDBP/bY8V/u7mnjSpHb/+Mi4tf2CVAGK7hjzOz4Kd2zcu2owqLhccNS3jnb9Bh8v4QMxtQ5kvlIi1vkkGQKSXuXdQLE/0NtRk2yiuySqSGNl2EwbtpV9+6WwOLWvaGNJCem77PD4/MczV0mQZSsRs+XOOPogK3bEves0RMC3OMEMri4+NFX
 XKng9yZB
 K5UmJrF56b5ktZvy0MqDH7BSZDN34oAot2+FeYrfoAGsP0q2HVjF2tZqPvycF6dw8X4JDH+WNT+7bIQSCGAg31C07uNWyucYblvUT82d+OvwTNlT5LcrvHU42D42Gb/KtLOMdEc5hJ4ui/JKqCSUlLmUVu6DAw4nVmIP25t75eBQ3L2PqR+6ywoJ5pzpiXMdCDmjVkEafJUohWBUqaK6puiRMD9tds5DzKk4EfYriiJucc6Q5Z/OoWCiAbbbcU5r09fz2xmi6ZTi3oFPHtXrFfruKV+1MqwknamHtKh0SdVnlxJvf6jNQvpD6X5lMvSYaIRazWwVCpUWdD+Ucm8MlncVA2QLEOaw+Uv90pUvZ2U5wpTXqK/Z0CGFlrDdEU+PRWDeboDJKRvs+xA/yNNqaAtLOrBFfJznpqGLay9ihLBPiOk8kMycc2bCX6yyYYHCPSHi22crms4VWA3DGTyZu+35gB/trUM+2vKKnxwNjUzJFWNOZq/kcBepwQk/Ewget8Si5ykQIEYvefC6JbRs7YVFX2yI53/nBB1fsxovcTk+HVYM+EEsmSvcuDyPcvC2Pslt0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 6:38=E2=80=AFAM Andreas Hindborg <a.hindborg@kernel.=
org> wrote:
>
> Add a convenience method `contains_index` to check whether an element
> exists at a given index in the XArray. This method provides a more
> ergonomic API compared to calling `get` and checking for `Some`.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

As I said in v1 I'm -1 on this change. As gregkh would say: it's hard
to review a new API without seeing its user.

