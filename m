Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD6B7E9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A2F6B00A5; Tue, 17 Feb 2026 15:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB3B6B00A6; Tue, 17 Feb 2026 15:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F936B00A7; Tue, 17 Feb 2026 15:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E03ED6B00A5
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:18:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D0911402E7
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:18:56 +0000 (UTC)
X-FDA: 84455062272.10.60FFE09
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8BB9A1A0013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:18:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NYs7+0Sh;
	spf=pass (imf19.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771359534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vK9s4etaIZI06AAYTaChD+/CCire3dXzgUTAeE6s7Q8=;
	b=t7o9ManDUjYldoQtaZ1z5kQ0J5ySNHzpZwmOx8JQpOM3z1NCEAt/yLMmPrw1EayfaxsRdm
	rb8ybvSX3YE34T1dvfQhYpel2KmYg+vgb2i+iDIp1I4LMf9rxNxr7mEh0EcQfzFrXPtEAR
	9DcvikF1ItX6vXqiiwkZyjHwv/hK1ug=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NYs7+0Sh;
	spf=pass (imf19.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771359534; a=rsa-sha256;
	cv=pass;
	b=NhGO1jCJvu43+ekgF5fnpeBpNCAXD4ojrMeImN/9SIylkWRyqddT4OB2KUSB+s6PqAJQk1
	myNEifElodJQAmfuK5DuwSaWBM00gUpmzj2maHq5scmYTkpBGpeSmhSNliyWb0QS+H80++
	ft8r83ux3Xt9Nq1NZXoq95iGtHw3Yho=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2ba76d64d14so181404eec.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771359533; cv=none;
        d=google.com; s=arc-20240605;
        b=B05PH4o0HA3D3UDAjQWcUJJ1LdrIM7aKfHTeHYdJSdMoQvteYpAHLO0GssjBOAMEY5
         NGYgQWemBu6MaHiHeq7ftjDDOWz7tF23SlBDxebFQkVw5jClEHf/vQbuueLe+bc+767H
         Xr6DEcA71zc34CzI8raA+xduyF9PwgH5JC4NPfQmkVpYsO9+JKM9Ikz6lRtcFOj2Sui8
         sIaR/lciSh6+rX9pqJYqW7b1ySuavmUu/EU5lWixWQAwe3DaG+fkgj9BdYaCmummv8rX
         JUBpUlhb9iURhmth4K9d4RrWA+W2QK3UTX9QKmU01X++nDlTIxqe+U5jJaGGWElrsGDD
         kVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vK9s4etaIZI06AAYTaChD+/CCire3dXzgUTAeE6s7Q8=;
        fh=VAC2+QsRzUJGXnYG/DZ/vTmJX5cQzC/qfcGrldLsy80=;
        b=bW7qQBZ1tLhGmwlrwbpThjY+C6Mi3IgZWnOdTnUHvXkedQEmzf1ZOm8rAI4QhiL0mg
         yiCGttmoBuQESB64ZRWh09oTUySMXOt9FQuvdqPIHFDw+e/bMS3Z2H/bUCw/gB2ILNgA
         k8oeoTFreWXEKAEzmc5FDYjvzXp6+3urBcvvTTtp9qM3wQwfaBfGqnsQazpltGIvMvNV
         zz/Wyd+GXWrtk0DRxv3CFhhApAd4M1vhWK++/cIHs6sFrvcinDfRYAUdPXvocQGJaqkF
         ntTdh69zL0i5U5LclDwUeEZ9yOYq2dVyeqIhEZYjc70e/PDR3mJtLcC+NLEG6gfx3mCI
         RwZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771359533; x=1771964333; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vK9s4etaIZI06AAYTaChD+/CCire3dXzgUTAeE6s7Q8=;
        b=NYs7+0Sh3Cr8lUuAhpKvhV3ELazZw+66VPwndsurnY/wU3ZtUeOlDnhXy9tEV58ySx
         R0gxIwqwYcUT8H6KMSh/OGqbXpEUt1r+G3boCWX7+2D3gYg8ihGew80d80G3GV1l1ni+
         vEm7SQUhYQSWCsTlEZbmy9g/k2rXfp7urVR+OiOjP6SSJr6PBKDkWxgngppsOJoVYYxb
         2rZJGD3/ek9+v3Hdl1RVe1wc4odF+L1n1LzxXNHXMGntNQf4RBCnMGbO/XdY/0gnQJhp
         Pn7gw1Ap11xFeIQrGnhUiMYLKOiQ+j2Bwk84nHvZFlfxveqKrUYYnJ0vaRSZE5sdCtyV
         nPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771359533; x=1771964333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vK9s4etaIZI06AAYTaChD+/CCire3dXzgUTAeE6s7Q8=;
        b=JfuJNOzTSTqMeujTd30c6g0HBlj2ri2wV/o3cyAoVBxOAEJs7slEQNVrVILrIuzdio
         pP5P/X9Gc+zV6NNJTOI5FJnNcDJgux58YNCm5uxSVZoa4DX1jl+qSulYr/REkPn5N78w
         LDj9Sg2pkDolRO70SqGNgdzsU2PUWdQDct4yQJwz+Z2IOmtlc00nKTgpymLlpqY7R9qJ
         KfKo0Hnx/jvT89ex3IO1LVFeoGcp7ef60ijeoQW2MrF78vJ906K/ZL0Hhf9Qzixrs6+8
         2mF2vJd5ld1xJ8B+58+oo2Evw2vRe1WfeCL1vfIISYsyqFoRnqIS6zSQ+fPLm7xSmFzh
         Q2fQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPglB1SP+sfTYXJnW9hwVw7XGoftoyh69BfrBqqlgoFshpMBGcqSL9e8YzoCUufg/saU//ilIjww==@kvack.org
X-Gm-Message-State: AOJu0YzDMlF11imuSZBFDF7FOyk1MaNh/MqvhAoex9oxTds1f5CH6X5n
	wMsa9QCWVsIbf6zvoS1OHGwKXgQ+UKVqm7CXoR2/P4LOXnMff/hnmZ7Noxz82Nrflg91/OXUCR4
	E/lFrj6HGi195oy4ibNY88h6LfDVP1NU=
X-Gm-Gg: AZuq6aImF15fhZg0j3SuLJ1iYyATcYc5hE6lKzR50mSrXelCG072PqhDmPE7hLpomM3
	PUdGXFeraouCX5NJ6wyAqpyA9HohtuaWxdmdQ7EK+fJ/B0APnUZRM7FTTfioieOSFjdfRTKRRxL
	8dN1AHCC9Zz2TRucnLT0ugtypEePdpQcgjbRh16VVPAEHxiucL+rpYR03k1iutx4l2IvVB/Ufre
	kbhf1AY42CoWuYKI7LIagNtJoQHatJYCLiwZ5FA5F2UjCBFI/PyNaElHnx2yhhEBxtvg4qWAd9i
	EEZCJu1xN8SGHdu/mpZ+Q8B0hxcj4epzCjXpYAmThownHybvsFD45NYkAX/pmwklNYsuqwd1wMQ
	X63JA03Y/FBppcS561xGKby4hDrWe1yz+MDE=
X-Received: by 2002:a05:7300:cc10:b0:2ba:7783:d1d1 with SMTP id
 5a478bee46e88-2bab9fec7aemr3553191eec.2.1771359533224; Tue, 17 Feb 2026
 12:18:53 -0800 (PST)
MIME-Version: 1.0
References: <aZRncP-sKLLS2K1U@macos> <ix0mR76G9a_ieuQUUkkfHMJIviAsrFaO859172fuFx9Goj7QdIfz1jtnv3ptubGEC7uEFCvVfEoWxcisUnTi1g==@protonmail.internalid>
 <aZR-ItMBkiqyBdKd@casper.infradead.org> <87bjhncl7j.fsf@kernel.org>
In-Reply-To: <87bjhncl7j.fsf@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 17 Feb 2026 21:18:41 +0100
X-Gm-Features: AaiRm520MoJ6hmcU5chh_nVw-0fKbng0IAp03Scu3RON2NXDzLsrCJHJ9boYNKA
Message-ID: <CANiq72naQfG=nSiPJdCXgqM1M_7ynDE5Stt-jiBGPqS9pipQtw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Evaluating Rust for XArray
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Daniel Gomez <da.gomez@kernel.org>, linux-mm@kvack.org, 
	lsf-pc@lists.linux-foundation.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Daniel Gomez <da.gomez@samsung.com>, gost.dev@samsung.com, 
	Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@inria.fr>, 
	Kairui Song <kasong@tencent.com>, Luis Chamberlain <mcgrof@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	rust-for-linux@vger.kernel.org, Tamir Duberstein <tamird@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BB9A1A0013
X-Stat-Signature: rbghxbziawi3bda7ekejzm6tp4ey3b81
X-Rspam-User: 
X-HE-Tag: 1771359534-30098
X-HE-Meta: U2FsdGVkX19g1UIE5Oy5cq91bYvhhTC0kZXD2WcqJDpRYVaRYwQjuR505/fL+Yl0+Ho5qjvP1/IOSBnQUr/CfI/roBfcH8cIf6oE+19mgAJp0XOG2AeNzh6OjPc0D+aXCUMZ4mtO+BDg4wBJZ0hOPtnQ4WmsfFd/aGXkVFOyjGbYT64kQD0Q0+zGpdwbmOe8RRiX698oh7u2G3mPMc9IMe2358I+PqA2vG+tlHObRbjhKKpqz4hjKqHr29ZqMBW1nFY8nBZn6wAFyFzSb/vmw6P5A7Ug3fGUes42ndhU8x9MaCdedlVPnmGC5g1QHkJE0/eDZ+QM2+Hjg+G2J5RFW0spbW+VidIMIFUqVFB52NfbmrQTkhm54FBKcGIpzvabgHKEI5oXRcDAYKqnNS/2qYF/pcgdl7k3a2SqINuqllYVuVBjGqAPoVQANZ5C560PhcUq9kVVchqAo0LUHYwTBgAloKiy+LpY8n0HJIaNHQxe/zuU10jPvVVe8vsMvZbGnai6oUTnfJdOmdM2NAoh6WjLbcLdGsXUacOor6K5MnHDi2BXfPkwQZ3kKZYbHPomemxOFc8pmAwxk7y76qhuwKTmlKyvPw81Dw9wb2lUr1vm4VJLsPZctrpzDy/r9V2ULC0k0eFqwy7+9vDfuwYlROFBO5C90Htjk2aDtONLLjRHH3E9YYSJOHOzLRiK3lbyxeAq5FQf/KKdmg1GNEUXGGjs3PmA92A6gFUY+QFgySIx8AfXOx9+PhHzT4i++htGxJ8WQSUmNFvRRvHqmYwvk2c9TwHwprXYWWeyllCdtp1udA6dd2VXzYDqwfIFa2LuW1ZuEqiQ0cIWuyrB3hAYYF/gQvbZMTG5xdmtIDgIpdKiDfTZj+uiOzWPRU2x0+q7ebHQ9wXrri1gw/UthUjcs2tBS8DAnjHdl2jc8LUL8jo+LjHPKwNGuRwD5jPggX9BG8w+N5SMosXYsD0c9KM
 sUPCAOyp
 lzhc2Vffa0dhszviKpnYJW+rhv00Tx9jPy12GAN8R5LRiiz/1+XdKiiBgTCe7ZkTY9WNpe9K3oBWH2CSZoduzX/bHQYm3eRy601uDzPxK9W5sce09W2h6S9afLGpIP+Z8dv2Oc9kkzy7f4wkpXOHFd6IWwVSZjsE5Tdmnq57CNMF01D1uJIReGauwLeJqjuDpL60hBPMY54NnHggUIrHkX87noeIdvpxBTJDI2KCSL1VuOCDa601n4r4iI1CHPUSRnzrb0Xcb3T1SolnOxttYY/8YRIne29cf9SuCAH4R3u6IJ7gWP4PSHDfjZvxzx/BYusXgJJF+7kGxTsjkoNmGgsbl5qCoJrrY7YniEAI1Ch5IAeUcfRTCalvLqgbj++XEj9cHHFpBLdKEnu4CM4jqLrWV4RgixYvVsJj+rE8uJl3VfY2l9Ggofmy3QIC3+AwwJniYekHYSL9TO5ANya7bMERN+kdJXyTs+ljbK7MinsarJgK1SZ28nalVun/Mk4PhdX37csyTasKVvWn5NFypuEW8yYWaiXnTIOs9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 6:51=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> We don't have to wait 5-10 years for gcc to fully support Rust, before
> we start playing with this.

By the way, I don't think we will need that many years to use GCC if
companies are interested on it and support projects like GCC Rust
and/or `rustc_codegen_gcc`, given their current state (for context,
the latter is able to boot a kernel with Rust enabled for x86_64, and
the former is prioritizing Rust for Linux).

Let me use this opportunity to say: if anyone wants to support that
work, e.g. hardware companies for their architecture, then please ping
me and I am happy to help getting in touch with them and figuring
funding and things like that.

Cheers,
Miguel

