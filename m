Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3E2C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ED026B00A4; Thu,  3 Sep 2026 09:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DA16B00A5; Thu,  3 Sep 2026 09:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2663D6B00A6; Thu,  3 Sep 2026 09:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF6026B00A4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 553BD1204DB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:29:00 +0000 (UTC)
X-FDA: 85172531640.26.1F00857
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 36B4F100005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:28:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p66S+3Lo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788442138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lzGBDpPSFyRzORpVpv5BVqn0OH17bvA2nEL9BC2eGk=;
	b=Lraw5LjBAhAntx4F7FRdWpTV3g7Ji8mfV6jYHwYDI/4Zk30Zh2ivg0XB2oGOKQMESn3l5y
	zwYAwtWuhStM6h5du9AgKGQXO9oP6cH8LPPuuBdPcn8yo83bAApizVaLjzWOjipAROHvbc
	zqHf57m1ywiEyWCJu9xBYYDtCYYEXcg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788442138;
	b=b32oxwpaMx8/riGlOf2u7+YxZbTabcLt9nmrvtlGokBi8a+a9S90vzexfomxITECyGoFru
	G9rJxgdf368pYBB1Ntc27vDxZ91YiqIbrIg5nSeIkRResN0tYJZV8w0FpLf3KT1c4hsM3Z
	c10EAHt+ooglIJwj2OtbvuLS95GWtLA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p66S+3Lo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8542712462cso321731b3a.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 06:28:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788442137; cv=none;
        d=google.com; s=arc-20260327;
        b=ahg9RO/pKTvXe+OMtXOD7vpuWaM3Ao/IImExm7PjOY/iXRvbHePkWNSvvHMmT0HozJ
         dZGLQt1dON2zxGquH+NWLJeF1N0FrwHDN945LksweuNXfldNnciNVKEGZfqc3D7Kt9Xv
         6Ilc86axzuPMxX+T+AgnbH8tUe6hhX6A4eH7RcIHHPR0JsVip5IXWR1pqV1PFepMAC9g
         cgXrBI+poah06a2ZtKpsRXJuUPEjpBS9KTfn7b2+nVa35sBJgzgEn2tno6dk83dJ33m1
         cnN1JrGt3K4m9uOjPVjzx5MHK1lM8Maxic5IJ1MvhikWQ6IALrX6JnyAM4kvxzJMAFTC
         n2Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0lzGBDpPSFyRzORpVpv5BVqn0OH17bvA2nEL9BC2eGk=;
        fh=dw/P9kh+p8TjZjScsUiNgSt9uJUuT9TtspCwPiHYhnU=;
        b=chN/Biq2mqGZTeaK4B/qbL7vv6ncuSn0itqxGnoB4F2VbZbqKwNA53z7Oew0Bk0pSL
         ekEZ5g+tJqq12SdJV5ys73IOt0MTYo1SLKckzQcr5KvvZSXakILJsu8ZXNaX1fYBWkFy
         tgJGsKvs7LEIp/RVUaG21btPC6TYyk5WqQJRr7umqa5ASNzHtgAItv5fHrgSORFg5JcY
         RV0qlFvWApjVEOZWJV4X1yT1geZ9n66p0QiPIoDzTXRQQT+hPZmAnV91ORD28fdh2+oM
         pm434R5MCnYAkC7I5vDeyO47X34oGLfqlCFfOlicx4YfjyBW26O+8YcJB+U9fAx5+6qy
         RiaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788442137; x=1789046937; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0lzGBDpPSFyRzORpVpv5BVqn0OH17bvA2nEL9BC2eGk=;
        b=p66S+3LoS7yfBc5+J1eumiJpzvNzmZHDcD9WPg6E+SNoDzijAILxxzbfld1e06F4j3
         lQuSlVraQbynTu8q8rPzemNE3TDxso31BiezdXExE+4OwCCO2tl1lAlcJA/GhlIDorB2
         6iTn9h6bTZEdIvD2BBstNQTDEPQOZs3S6yBGx3yLhQ8F0tuoVezqe3+8M9INKzvBo83q
         qj/p5fX3E6hXyyriQiJNfhJfqUBBXodPu2ZyooroCpHcYbZntYyVazLl1yAwXJsHcODT
         qG0W3H9p8Q6aFhCSuHvSH0WNSvqT3UZXYAz3JxW+6c3pUOzDvIvCOSWgRf1aRw2x2gNM
         774w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788442137; x=1789046937;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0lzGBDpPSFyRzORpVpv5BVqn0OH17bvA2nEL9BC2eGk=;
        b=g2rTXigsnAwodP4T5W06OfKZqoIH7fMe+JV425XsxMq/SnJPAowNH8cVWwVuUhvSdS
         YSwxurSkauoay1DMRIBpmaFbIaSk1yHaVIbT2M63CXkwh0kfrYz/xp8HnjZjKOlhKRa6
         TB2v3X5VUn/f29IrwK3SDawGS8M1gAnAQurO4QPe8RZngvtCmPg7+fVYsVRCotSk43og
         hGqY4J24YFJQQWd+0pLxR0xbeeZjllkyko7423HRMU/04yvVBqxllKDAgSSKGLFML0To
         wM7lQC8zIOKKrVp3nHrvH3uDrUvaORzfFQbnKtKm0cjLYf4mXDbxgHNLSG2+Vb6QzIbm
         qN+A==
X-Forwarded-Encrypted: i=1; AKwUvBy9y/fxGu0OCl4cHDlmO/m1fVQN2x9kBVxfzHIbgTHO9C9sK7yZm789DdzWRGcG3fDSShI+eLIyxg==@kvack.org
X-Gm-Message-State: AFuF++lhKE1pP35Jrw5Si0J3J+lck8U2bwkhq3ngGyr/RKVF39XZALh8
	HvF1KkE/XS67wkdlUpqxf8AlHo7rvUu4SQu0h+l9iqLuzlkVy1zmGWqGnTN09PbpjtwA9MkvJG3
	MwGHjULCG1xedz890vuzT3DvD+FydPhk=
X-Gm-Gg: AYBFou0Fmn9vC+vuzqHkln1oUQVna0G2dwWcCxT4CnxwXRtuXo9JNhq/r5IgNpmJgKq
	dVHD5MRdSDEbCPnD1tfJv0heG7FAlGLZEgIVAiMcQ7vSW7zWbyfZo8C0HGObRQEOSOtuvbtbXH/
	6FLVX1+1ak08tIYL/LXgHL0VyXuXHBSDCRNWM+3n8mWeBZqAKn3+NIj7XMu+ozp1axdumOmlBT7
	LDsJDNvtV7w16N7aUUzSv/g0q01ZvJZ6n/BmV/4koyoM3j22R7qleoxKbymDeFsn65JqcatKLXf
	3vAeiAIxnXIhDQm778Tl/PfEPRmFIidxJv0wk6u3s/4At1cfUsXqXd05iBZGwyIjm+JOxz5CKzb
	yWk8qB+EZitnQLOtNYy/cLigIDFcqCAzZAxBzFLleA144Krm+M9NeRPH2fjhU
X-Received: by 2002:a17:90b:1d0d:b0:38e:c140:2a0b with SMTP id
 98e67ed59e1d1-39aee0e6ed8mr12609481a91.3.1788442136905; Thu, 03 Sep 2026
 06:28:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-6-490735672187@kernel.org> <CANiq72mPLrKQMzb37ow2969m5r3Z2Kh_4LHERUun6ALw3ea6tg@mail.gmail.com>
 <87y0dt1b8b.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87y0dt1b8b.fsf@t14s.mail-host-address-is-not-set>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Sep 2026 15:28:43 +0200
X-Gm-Features: AcwNN1XsmuEPyO39jqyvRGfAMw_DGGPMkiDRHtfg1ZEoNlBhpVDCHnmjvBP_pa8
Message-ID: <CANiq72muo8SotJHJQhEe=2kiprbrQTvrEMqd1Uw_7yNSfA3Gpw@mail.gmail.com>
Subject: Re: [PATCH v20 6/8] rust: Add missing SAFETY documentation for `ARef` example
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Ira Weiny <iweiny@kernel.org>, Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, 
	Oliver Mangold <oliver.mangold@pm.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36B4F100005
X-Stat-Signature: ezcm4e6ou3b5m3egi7oy6irfgk5fzsyb
X-Rspam-User: 
X-HE-Tag: 1788442138-907833
X-HE-Meta: U2FsdGVkX19N1XqFr3/EJs4KE5w5kWcT7XCGyWxEYAjKA32qkoGS/vyNo6Kjjk3K46d1wV9VPzowtSW3M3qvQhAaWqp0XA/LneUTo5l7Sg1N2+Qany5ZF+6CngKfrVJlH0q1vkacUhUWypq4oL/4TtE9vrDBJuIwaBz3zlRtTNz8qLGBEZYk9hLl6VxSDvW98YdUdkOyz8zZvO0lIT8HSGtbNIbkg26h/6phMiAkN1YfiNbakDCvLP7RT1dwJpsIrCMHKQJdEIkLfBbS+89RU5BOvf6OgdbmCq7zJPnqtjS+XpClS3w1J8/pD7N/E4Mc9H5dPkvhVtC/aL1UGGliNpx47rkd0vMf6WM4v/DQ4FxQ0WUBBGd6x1d+snxaly4dMKJb9h/G1Q91fe31LZkUkgDNLVDqUTpdLsfnqRDxAhda5KsSHm4BpUOHr7cxQZhXzD4+Lp7aT4hxt/ZVEw34wgXACpbKYwZSN2Odg3ilnYTI9Xunc4hDg/C6L7K1yeW6QlK3L3r9gHVR+J01ZUuvLFSmQin9jPW43AUtVVUVi00A98wpLO79nSTEL5Tq90Qe8wKPyXUNg23HkfUAWEw+r+q3POkfucIcsnpt42YHR9kVFSzg7W7oLkZ3fVNpAI6FDBeHMC3fpdCN+Hbrikjbd0Fiz9eLDidvupLlY6+pTaG2t2fyoLj6bpVWiCi9f/pPVDSsGW45SlJz/p8TDQiozbX2OL+z9GV8Tl087PEu+agQuyMooJGIOs1QRfsgGCAJzVVXSgj9/Me3iprsEuNIxTky8yGsRxF1h2uVX9HmBliQ9xutMF3NH9yCHIQxnrKDSV9fm8EU0o5uDy9zVRzJseZ9ky1v3kLCuvGFxwxqOffp7Q+b7/rQJsKQOzSCNzpR2NBBZ/dZ0+VlZsNPKHUOfhn6fZSDZLJskcyGsyEEpbBjczt2dwgFIB/tIlRxfZtwbX74rBRqAs57RFtEE45
 KqAGcyyP
 cR6BrmMIye4upnWfIkQbskRLfNRLYspeGiQQQYg8Ypvf7W1rV13gvd6i8mu59Q+ia2FqVtjdVlcL59+5AoZJdG8+6SGLtvAndcpUfWlkmzOzLvhEN+q52Ibn9qn7ZsW/QNT2k8U4lA4DxMisdbQxKoqXWHZ5Jb/7L6AClik+n7Q9YXzpD0rLwBFsk1smQuycPL+kOzcI3Kn6rnQfS/VMOrfQq8bwGLbkU7AYzlyBgzm1ntDX+il3Zj7Wmo5qEsqlBi2fYW8XCJ1CkqjO6fN1GR6e4F68TZLr22tcgbeqfjRaXG6Q/Pc2EoJNqisLqwffnuCVoVNgxpRlWVU2GIyI+A3Hn+oDOpEpi7jfUWzyieBN/8vXjzGFxTSb6+JXoclwFLd6uBxIu2eyFjXUbnzcKmFcyhcmRlUYJ8F+Y8MeQPNo9Z32BO6hwvmobtORHwxA2+HDucNdZvlcvZ1D1lqoxU7zstAcUD/LgoxSAwbcdO4kQ4SZ+vttUlxPwzLr86BaDlmumZbuSxO86uuK47U8orjER1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 11:29=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> Do you want a link to this issue with a regular `Link:` tag?

Yeah, thanks!

Cheers,
Miguel

