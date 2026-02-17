Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2928CE9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8F36B00A5; Tue, 17 Feb 2026 15:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8688D6B00A7; Tue, 17 Feb 2026 15:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795156B00A8; Tue, 17 Feb 2026 15:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 643F06B00A5
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:15:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02686B81B8
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:15:08 +0000 (UTC)
X-FDA: 84455052738.16.41F745A
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id EE6F140002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:15:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="d66ki/bc";
	spf=pass (imf17.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771359307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAYO4SE+uXRQFqS02L09YZE3aUET5DXvetwhztMDmzU=;
	b=vsDbwa71jzfqZ3zmzTmjOMV8TYVJA+5bbgh4orDMt+JlHk12WXtruLtPmnuZTq+YzePLIG
	XKu3jd/je2kyqB4pCZ7owMAyxPKTcu60PIL9Gb9Q52H1FNQLPZ0ODMyCfukJgOhNBhSP0r
	HflrPa+bjZHgSkKiE6QSOfUU3u61JKQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771359307; a=rsa-sha256;
	cv=pass;
	b=H4S7JEXpGMD8iogexaoX6UHE6fU8/MDsZC3mO8JmQGAon5o2P6AlsWvUeEwSWMEg45avrK
	O0UvcJbE34ECHsb2ZXY+SBay9+Xm3Fuw9FRrn9GtW97yrEpRKGOSQWIUjBT5moEZSyfYNk
	sZ/Ue/8roaycVhXnq9l3SlrahFT4CVo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="d66ki/bc";
	spf=pass (imf17.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2ba7eb6022eso194513eec.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:15:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771359306; cv=none;
        d=google.com; s=arc-20240605;
        b=W2IX4RwLQ9Vp7EuDlYFv+nWJhraQBOOndZaUwyGQTu8X5qFoClzAzpevYI3iIhDYXD
         sGKvNsezRPggpCBNuuWW7jtRyxYZ4lSllwGSJdzvffP+kQytqAOl+uZfeaQcflILveiY
         IYHoWxYRkGs+2D7YOb8b0Dc7xGdHXFxyLvIRqMVwmNoD/xddeLx4Hi+qJVDLqaGwauey
         0CPqs5Kt/ojulpLrVXX9/3FT7JDAejUGAYzhdCESO5sWHB4MTFnqOpmzmudshg88Xe4h
         OQjp2XuwBmDZqjg1tBjT6dTr/uAAgWFFH7eWCwDFh2CLMOeVf7NDoPOL0G/Du2MXmGUU
         iTTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dAYO4SE+uXRQFqS02L09YZE3aUET5DXvetwhztMDmzU=;
        fh=d16yPFYJd5+mSCzgOlwBY6YSi/nqXUEf8Awv+L2Yvt4=;
        b=fK61BBgJhf58AVFqLzlVY0H+KCI33alKi6S9IuxZtOaq+PKM7/BbTCf/9hkG+iKACH
         7np1JA3TIQRT72eftb3cwuTsukRvqfJVPtcc1TV2Pn3+SYWwIpReiDHcMRSyxoBlDbBE
         gsmvE4ae5qlGo30gWJGIYZxqkpJReEBsQl+C01m/ZlnpFc4CIUnqBJXD5CIhdBY4aI0J
         j25GjDomTtVSnnecphphOcDA2HdGws77QIbOa+lSZV3iTLVHxjEuP5Mq2nsXS1PH5DZy
         8nW4KzDAxeLKMAnls47gyP+uHMSbd4y3Q29luFqnxH163V9VuJhTKNS9DEXQVjwPxyl7
         yKog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771359306; x=1771964106; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dAYO4SE+uXRQFqS02L09YZE3aUET5DXvetwhztMDmzU=;
        b=d66ki/bcxu7Kshx11PFNgPkcbQZXIIZRPBz1VU5UjiXkidlYI5qlTUAQPxwqaQexOJ
         PrUmxgIie7dVxTuIK/iT+VxZj5oMfE2kCGuaqfWFu0l+5rPq/yFZywX3PvuhBamYCZlN
         Z6dfRQMy/wRsPUsExZA3pxzdtva76BvE9uR6h19EmxrRvMGW3ziILs1X55qZB9ob00mR
         oY13+J43kjvthngxU/yEU32klA0T2uRcosUkvu64VLiSmBcpn3QmHJoH1Z4btDMW1BfI
         RdtmdGiRJG3CCylKkqka8MWJrQizIU2ZLQhvqJ6r+5ceUULYIazD2OxrOaVh/tAByu14
         qWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771359306; x=1771964106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dAYO4SE+uXRQFqS02L09YZE3aUET5DXvetwhztMDmzU=;
        b=AkBzSG2RSLQYJtkJRA9DqCdk+NIw52HtbHddeme3DK6453WipeUaKIaS63lPPrHnww
         1UMNI0TLxgq5KiYSl49INgTTNR9QnlSQNKDcKst/MmAHrPmcEzSub+Mkz3xHGJHvQRQx
         bJodrV7nGWTR/jwff3aSoiPBqyuCAGoDgtgFt5DeS7uRv4pmZvbZZ4PwKmTgHe4Px+JJ
         pLy0BKI8losBo1MiHCJJ4IMKbNqNb5ET90d2e1ss60AGlRg5SUevmCh1aa2O5s2japUw
         M6KVGyJvgih/EiqFPt4LpfuFyFuk5KsG3/p2DDgCmaermQoFQ21hA8wOHL/UjL//onFg
         VFCA==
X-Forwarded-Encrypted: i=1; AJvYcCWwr53TLnNahLzdg0IhDpYZNFX6xwhi1pztrOvA1SUgraJ5R5XovB+KR7QS60r1iabOhQdoKPucDQ==@kvack.org
X-Gm-Message-State: AOJu0YwPp4H7mTFXkPoiCYCZuUZ+HxDFrLnePK3EpSeugFeJVRultZue
	R9UqJo0/6PS/HxkEH8lTa/gZJpR0NuwqBh9xOzb6jhrmZQx4ivWPHQcYxHxRnJkOud5qBmDjlcw
	Oo0qFfyRYnUVYx1m2Sys83dsAh4oUSZ4=
X-Gm-Gg: AZuq6aIa0cUJcl4QNNJMf9BjtHsVvXFvOPV2/9Ru5fjupqys7YHRxKAQSDIrJyHFqIq
	rLjp/J9OMGkXLZaGMw09syf4Q04hhCNBamNdeqh7QtPsMfpqWNSN6v9+dt7TJ50MwP6pQdf+4k3
	RfccZ0rwNVmqPAVFRvWcgc4U5R60yC5+YL9VRyC0YMoWwsYHBNSANFubvHwFgBeJy/w+m5J3PJJ
	Y4j3+vncw68aEFuJKmoeRZoxLvKzD8gzlMS4sSC2d9IlXypLSulciv2dEdfFKs/3jfNdtCwcPx6
	eH2UmYgBT9I9xIKqDuvlUX+ApSEbzP2UF1wJhw23TqskWbwk3rpJJRX4NlOqYVVe5jx3NrX+3Ab
	hfeesUax5urA+UMbybTAKfHXz
X-Received: by 2002:a05:7300:3b04:b0:2ba:673b:e328 with SMTP id
 5a478bee46e88-2baba13781amr3352534eec.9.1771359305469; Tue, 17 Feb 2026
 12:15:05 -0800 (PST)
MIME-Version: 1.0
References: <aZRncP-sKLLS2K1U@macos> <ix0mR76G9a_ieuQUUkkfHMJIviAsrFaO859172fuFx9Goj7QdIfz1jtnv3ptubGEC7uEFCvVfEoWxcisUnTi1g==@protonmail.internalid>
 <aZR-ItMBkiqyBdKd@casper.infradead.org> <87bjhncl7j.fsf@kernel.org>
In-Reply-To: <87bjhncl7j.fsf@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 17 Feb 2026 21:14:52 +0100
X-Gm-Features: AaiRm52VYhrU4cs6R8w700gaQvNkNfHgVUmjPtJwdjGBU7D0DnMLnJVDQ4-mO04
Message-ID: <CANiq72nTOpGw6JhrMLK47+7TCJjrLRdNebctrmj5xO6yqAqSuQ@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: bjbc3rezkgpsedtfxkwq4oodoctqaobu
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE6F140002
X-HE-Tag: 1771359306-210455
X-HE-Meta: U2FsdGVkX182YGERZ/hU5nU2Vx8a5iIggQXIbj7GRWpRnUOE5OM+SOKFffr/vm5tITm58uI9nIVr0+/q81SyP4t4vF5VvMwN1LoNWUMBFBUMqkuMTKXs2N7S1tu8jnK3Krvqsr5aD3ZshTN05NrmTfcrBgVJ2ajrLX7V8C0ZO6+/lVdGmHQ9bzYVFKYob0mjHM4wiWAmX3KtarGkI53cBVs9o7HUR0U7R/SwOZS3lIgDzbpMxHzAR94YYGJXewxVA7Oh6EwZZ8OWR2k7vpYcmG7s1ra1w04zbh+2XHHmnHho9Hjg4I54Sb3Sx8T3F/lhym+L6NyHj1UxK5evh9nnT0BQxsEziDn1/nltEWfmyyquESOcRzxxdDuXDBcBC35Dz219IvnQaSFNIZyrWKdyOe54XJ2OGzRIj/+MQ2u5vlQKcIJ/if7e3ciEbnBom+3FBm4i8vrrAAGrhTWlgSO8yFEBlLS6GKYsKLyDNKMQIJ0gNDeD5dRXEaCRgfgUzMi6sYgU4wa8BX3x3pxl/5+zzKuoRwkOE4/y4/JSUr7HcCw+/iKmQ9Bzx9CC0Ah4g7P5F3IWaG/ITsv+LGITS274kwXh6LLq4b9NiKEcaYvSaZZNsjO7ZmjoiqRH2PDUf/PEvCe0vWTuA8we11UXmBHFKjnit9bNx0i8oiznnKLlizHReJtu5meIvQQy33dBzJ6qR3e+6LDN4hHEYF1VK8dCnZSPTl/3Q2XlH34mA652TUihKqZlcM7gipeSts5Or9MoxhcgwV0z0QZTJm8zrlAAie8l9ifNo4uJe9Ki3VaFwUySV2qJRkoCzCtdQs1fK+2iOPHF7LJR67PMnb3+7BwcuJPnp3bdxUiw7pIBrvS9QWTk8HLzQ3aNuBbAdBgNhN/iQwERgAUaq8YB2vlcKR5aJomY5poESqKB8QCGhhIb4DDgGOfJIhouoHcINvuYCiHwU3jKE/gdhQxPA3iwNeF
 7BMoLuBs
 xyGEDQ1HsmhSnvJnCDq/bjjZs6oI2UGQvgzLrHQWbr3ZuIahjiHFc/5c56ZeaOLPDAe9iq4lVD2ctnbgXHGpkaHEWMezOACCL4D03TAjGjBra1HBzyej4DKkWlIlFH+Gnv9YuXwZ1y0ZhqNy5kpWEYvqhz/oKoKnQFRyZElKU6AUZAcU/KmOacnOTIKxz1kY41q7lcxcTBEk5vNdEZjHcRn30H0Ueom/9I2mq2sH98jxVx3tYef8Jpl/B66nVWR/Z4yh5sMn02gryucgwfy3pu1sGubwh9Z/5e9G/h+XWqU75ZDiRjEBkKl0KKXqAnE0iqY3MaTCiLpOmvs0EgHxyIsB+vEH6rJFQdHp2j2EkDKOrVbO/ygqIgtDZ4AWcIlUxVLlr03DFuY269vz6OJiGbU1al4RqO/GmFqPzoamu7jvp8wn0Rg74dR93kXI2WJFwVSYzRMFsseEbZOhNe9WakqrNkYoZV4hLkZ2Ylp+BgKVJqpmKU2iiga1kOZPQC0vpaE7l/KndMMe1Mr6S/h8XzmNaMWIodDp041WUzGR1ixMOOijSJWHysUGSH1Y+/pFweOnBLbyvFAvGPuwLmUAm/36x4+5HRGypLWkI
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
> We can, and should, start evaluating if we
> can deploy Rust in this area now. We might find that we are lacking
> something from the Rust language to do what we want. We can work with
> the Rust developers to make sure that the Rust language gets all the
> bells and whistles that it needs, to support the use cases we have for
> the Linux kernel.

To clarify for others that may not have the context...

We are already working with upstream Rust (and have been for years
now) on improving the Rust language for the Linux kernel. We have
regular meetings with them every two weeks, and have a shared roadmap.

To give a sense of the collaboration status, some major language
features are getting developed with/for/by the Linux kernel and the
kernel is even built in their pre-merge CI.

In terms of discovering features needed, I don't think there will be
big surprises there, given all the work done so far. But if the plan
is to expose a C API, then we may actually find we want new things
from the C language instead! :)

Technically, adding Rust "core" code can be done today, whether for
Rust callers only (which as Tamir says is where a lot of advantages
really show) or for C callers too (where a "native Rust"
implementation can be simpler than dealing with "abstractions" of C
APIs).

So it is all a matter of maintainers being OK with the costs. To me,
this is similar to the "Rust reference drivers" proposal, but for
currently non-configurable parts of the kernel:

    https://rust-for-linux.com/rust-reference-drivers

Cheers,
Miguel

