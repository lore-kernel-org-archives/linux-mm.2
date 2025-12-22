Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEE8E674B5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3746B008A; Mon, 22 Dec 2025 10:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E766B008C; Mon, 22 Dec 2025 10:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A2F6B0092; Mon, 22 Dec 2025 10:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 686B76B008A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:19:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DD4114021E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:19:47 +0000 (UTC)
X-FDA: 84247466814.07.8274B78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E52120012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:19:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=Hk+GEhYg;
	dmarc=pass (policy=quarantine) header.from=zx2c4.com;
	spf=pass (imf03.hostedemail.com: domain of "SRS0=JxEM=64=zx2c4.com=Jason@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=JxEM=64=zx2c4.com=Jason@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766416785; a=rsa-sha256;
	cv=none;
	b=m+ijkypLSDVfyOFzieqgC3TeMPjY8CctD2GDiME8193vqp88A9LyWXfLVKx7jsfQbVC+GD
	KBrYgUwG97FRXVwErcT4TJSO756eNN5L/vjD9hWAR8lY98Lq6Reum/solupdsbJpQ8lI7k
	k5WRUWrlb8u62bf1xmdbrGneDXrTkUo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=Hk+GEhYg;
	dmarc=pass (policy=quarantine) header.from=zx2c4.com;
	spf=pass (imf03.hostedemail.com: domain of "SRS0=JxEM=64=zx2c4.com=Jason@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=JxEM=64=zx2c4.com=Jason@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766416785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1N6OPvReLWVo4Y3HlBVQADg2v3sQNDdO6tiD1MFCF8=;
	b=VZgLDpWYraEaX/1X6yqv7S9j9ZHoOE8yNXwXOJA6ropmeHGXIeoSSM90mgAHgjaPm0JWqc
	IS0rkkYvEJc30l3F6wrvbFPJE8MNfHUfTmxkbJ0m8CvrZDocozhUyAJMF2+4B0iLP/bgss
	MxKBzLpc+DRBqtETDyrje/SadxUdO+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C96E6015F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199F3C113D0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1766416780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1N6OPvReLWVo4Y3HlBVQADg2v3sQNDdO6tiD1MFCF8=;
	b=Hk+GEhYgxh+Le4p/cXAv00+EdZcjZ4gJhldfzXfEhkGHKWzYxbQ/4bXNbjazRwNfWjz4HW
	DYqnK67XBLJVGiSVYsT5t2u+bnso9qq2JBiJ0/Lgzy0EtBTblsCHrgUJII3dmumCwsCYUl
	NAYHfIdQszIupLfIEmXZVSjrgWwnC08=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2b008776 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-mm@kvack.org>;
	Mon, 22 Dec 2025 15:19:39 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7c75a5cb752so2768000a34.2
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:19:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWqumSQhFkv5eOL9d3o22GPbjDTJA69NCE3uzW5NWqGHU2RHQOJE04Nrzb0O+bbX/fFQsF/FTjRMA==@kvack.org
X-Gm-Message-State: AOJu0Yy/mrvFCIZ0ztAQg24zrP+1QVPKvBoxHw/UJvq3sb1RlA8jie/h
	YMxW1wznad5sj5MJAT1tCXbmygTsMHOsyM72epGRR6/47VDBkwX7Ee8yyhj5yopmLpo8M/ImgeN
	X3bunKww8HkP9hMi64Pe2jLAwIyj/6Kk=
X-Google-Smtp-Source: AGHT+IHOQuCaxf4n5p+wAid+BYz3qdzHpljcEYV51JCemx6N7QnRC7Q5juxP+bLrbJGEFRCXhizeiHE7nUb/fX45eW0=
X-Received: by 2002:a05:6830:44aa:b0:7c7:6977:17cb with SMTP id
 46e09a7af769-7cc66a0eb4amr4713164a34.21.1766416778319; Mon, 22 Dec 2025
 07:19:38 -0800 (PST)
MIME-Version: 1.0
References: <20251222144646.1426256-1-vkuznets@redhat.com> <CAHmME9o1oJXjt4=5qqGDdBbiK75dvea_e=Z4ceStmk=Z5AYgjQ@mail.gmail.com>
 <87jyye35qb.fsf@redhat.com>
In-Reply-To: <87jyye35qb.fsf@redhat.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 22 Dec 2025 16:19:28 +0100
X-Gmail-Original-Message-ID: <CAHmME9pj470-RTCsOV+AfncAJn7_zmLzbWpswJif-JN7cbBEFA@mail.gmail.com>
X-Gm-Features: AQt7F2qbGtQgpwA0_t-BAJNUmjHoXch3hDS6bKqLNa2lVd7VF9NbN4M5FK3uX2Y
Message-ID: <CAHmME9pj470-RTCsOV+AfncAJn7_zmLzbWpswJif-JN7cbBEFA@mail.gmail.com>
Subject: Re: [PATCH] vmgenid: Remap memory as decrypted
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Pradipta Banerjee <prbanerj@redhat.com>, Frank Liang <xiliang@redhat.com>, 
	Alexander Graf <graf@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2E52120012
X-Stat-Signature: zkwm7bgsueif5ehya9m1pd1wdh4p7ah7
X-Rspam-User: 
X-HE-Tag: 1766416785-860876
X-HE-Meta: U2FsdGVkX18rMz04Lko3WH7At/WNP7Tzdn5hJ4Q8bK2QzSMTufbPm54sPnebuiqEXVYN6F+GaPR3HsKLV1PzsUP/MSPbG5bkxirDg31jhdl8Po5CRb+uSRTaU4+0WJS8o8/wknVQpXyFoEaf1eE8/t2efq28zY90sVxOO4PMF2dxh+e7rA7NnDnhJtbBBB/dfxtzTlomZ7mE25U2xy+/CRbAgwyViCXgzJBVQ8J/LLcpdB3Mr4YTWfoKn0YC3ueMXB9cbmwDc9l1Pb3Os5ywfo6QwcNCOZVXL5V6IMmvVOStEB2J5yV3mEfGnFdua9E2luDCRDb56RedfYwp3aOB/2W6o17h66UiYi1BRnNFHTgmidjithtvsZ9l6NebR27c6YwHZ9WIHBnTphQkPS6ne4lw/wpuWYl1VvUQ/RXBkLsmqbKGqFd9gEyf0Ui+vFViKoJCrF2doQoflxJBHJHNIsTELvriZKG6st+j4G8eNsKMcga8NhtnUVGSaJWJe9PVEdDnMDZvQXW66w6WL/gmd3uHpTHWC8Cjwpcbm/0kUg6yWsY0Q0S24pJoTRnw4/9OvkUXsGQ6cxh7eqmcQYQWBzZdsL6Hf4sQsU0GOUvK2QgtVRxIiA1Eh6TEHyZwQG5+Fj/2W3vqoVVWVUaFl9++HAeoxc5h458J243vCl5lNxNVbKl3cfGm+z9jXlOgTOmWfCGw34XtWcYmKmzMBy3jiuhdYtFD8cpTw+vOs6QSIYziyfTOPG54shJnLzhc4iTFzSBCQJ+yylBmY92/r4cS8hcup9mFu3kZNNlf5q5jH00gwyq4VcgpY0RVsZZxQlkMPLqMZ0GnedU7+ZrOuTmzeS7pBQDATk0x/Bin5i0AVULxXB9eudi2vJG+GDIdccN0a4YBQCucEMa4ZwIRcRANZd3kCXfhnNgcqx2EhWWCTenDGQsaYozSPoD4p/R9Ed7A/oMqOuCJcGam765lhR7
 Mfn6bkzv
 hYz6o8GqWeKxB/zsrTS6eA0z4MvnkauSGIiEZKiEJoJU75LHA09i9Y+/wcrYiG/fVQq1rnhbcN0Lb9MuduMMAd3UPEGZSZySFnzNSDZg0ocX65odVIMkD/MCYog+X/SqyKT6TXJwKUXublfYMUUQMqtpqFBdBBhLPw0AgL8QWyggcQsdNhKRtgG3VyU4Fc3MAm8de5/vwJEZq2HuFyOfzIwrBlqSU2s8v9BC2hNU5OiquzRym9ircSq5we8PiIoGZy+jyYF3TWNUr5DJKZUrwvynh2zbCmmN8lyAJAHMcy9JcP6Ej09rguCLZrLEEYOj+Oos3A6xv8LglN0EorcN+LY96N4rW2IQnumNTjj/HtUjJH0tkgUhhNob0KgmrN6xnZNvPR1efcl/8P4exS9WG45WT+ZLla38agf+j48x7sqHb5DAdbqNdhcPgFc1gSWLNqwj/Mq+Xp7VbfuxKvVmpWO7hsvhw+oesjS1IZR625MT1FhPCelOLl7uWwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 4:18=E2=80=AFPM Vitaly Kuznetsov <vkuznets@redhat.c=
om> wrote:
> I'm not sure how common the configuration (SEV-SNP/(TDX?) + vmgenid) is
> but I guess AWS SEV-SNP config is significant enough to justify stable@
> as all kernels 6.15+ don't boot there at all.

Okay, will add:

Cc: stable@vger.kernel.org # 6.15+

