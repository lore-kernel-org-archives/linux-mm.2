Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F294E94617
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E5E6B00B7; Mon,  9 Feb 2026 17:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5626B00BA; Mon,  9 Feb 2026 17:50:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7228D6B00BB; Mon,  9 Feb 2026 17:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 616246B00B7
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:50:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 099C913A7D1
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:50:35 +0000 (UTC)
X-FDA: 84426414030.21.36DFA6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C3D42000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:50:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qxrNPhhu;
	spf=pass (imf13.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770677433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9MKdhFtpSULQjsDpvbhBccI+DmenJD+Gpy8FqQR0p4=;
	b=FeSE5LmJl+GbOkmL9oj7z+oWd/nsVch8Wb+nhruuwGhnvOQt7+5qU3dUkAto7NCn3JY1W2
	K8Gl6Wwt3JpegIzmdCgF5emQdDLW8Et5RrhPRUBYlMKmG+oROMd2nYapb710XFqdes8NHO
	xOP6gyY4lnoU3LYzyT9230s2gzO23EU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qxrNPhhu;
	spf=pass (imf13.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770677433; a=rsa-sha256;
	cv=none;
	b=Q+l2g3HsvyNsl6fhl8cR8ehx6Kvya8jqi89dsDw2XAIHbjj3VaMmVVfcgZ/LjGpjLZpT8Y
	+R6/JPB8aQibKvpPF3LPMGGRWW7CdmPOWZmV6zDySn/cY/jWqwG5URodcRe8HScT2LJypf
	9peXbgrlWy/dzl5Uv9ecNnODSIlkNMU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F761600CB
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D7BC2BC86
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770677432;
	bh=R9MKdhFtpSULQjsDpvbhBccI+DmenJD+Gpy8FqQR0p4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qxrNPhhuAu5eF1PoOhG8dUedHlgPNoW4PUCNrobCBqS5NTmc7hX7yljaDxBrcQ6Lx
	 UYaPnzz4ZBm/n/mvsgQzN44ATdJWC3D1c9t8oOud1K9mOAmO2SeTUlNstBCAPSHmeN
	 yq+KHTUik68qouxxHFNv7u7d+uJWVfLim/jkTEO7gkaGQZCt6Xr4+W6z2UKVYihmYy
	 ec2Ugfd5R7t1jytnUxBZ3KgaWFYJbv4z9rBOHTXcYTGWOoubfafIjVi0Y7d7WPqnHk
	 hFeQHCyE1QNLVSM1Z+9zy5gkBf+4OLrIJXha8x0cPCdAK4eteNDSwBUvnwOD52DuL3
	 GzD9QIDyNJwNw==
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-649e456e8a2so273696d50.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 14:50:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWAskSrChfXGT7Fs2uiZLOtZg9l1lrOKfvrzKscmuZJjyoBxmw2YU1+1+AikONv4scfQyzpCcYQJg==@kvack.org
X-Gm-Message-State: AOJu0YxvkBLekFzaEzuiHwyGcZ/Mb4kBkWLPh0c6nMfbvnTCiUnuRFxt
	hO2UYGwbrfZJpdTk9KOuimh43qRtyieXkTosXM6jTPDjyBr2qeQfEnw3QYLFv4O2uYMOpehoaeE
	ELqSsrnTO43ZVdTdvhHo3oikVtShnTvA=
X-Received: by 2002:a05:690c:9b01:b0:794:71b7:2adb with SMTP id
 00721157ae682-7952ab24f48mr245741577b3.38.1770677431642; Mon, 09 Feb 2026
 14:50:31 -0800 (PST)
MIME-Version: 1.0
References: <20260209145603.96664-1-chmh0624@gmail.com>
In-Reply-To: <20260209145603.96664-1-chmh0624@gmail.com>
From: Linus Walleij <linusw@kernel.org>
Date: Mon, 9 Feb 2026 23:50:20 +0100
X-Gmail-Original-Message-ID: <CAD++jLmrjE1nybNxEKq7V8_qKTBMSVGzpSj09H=ZtWdgaShRHg@mail.gmail.com>
X-Gm-Features: AZwV_QiO2NIubg8cGJdgLEZDlv2-SClkZ8UoxzwH3YBxo3o0_74mGBqwpMzKsBo
Message-ID: <CAD++jLmrjE1nybNxEKq7V8_qKTBMSVGzpSj09H=ZtWdgaShRHg@mail.gmail.com>
Subject: Re: [PATCH v2] Docs/mm: fix typos and grammar in page_tables.rst
To: Min-Hsun Chang <chmh0624@gmail.com>
Cc: corbet@lwn.net, akpm@linux-foundation.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: efbyun8awnfyc6yo1txut7rx45fnneh7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C3D42000A
X-HE-Tag: 1770677433-293423
X-HE-Meta: U2FsdGVkX198ZH2EA5tUxQA2lbO1HVH8SAbhXBNohkba3Juq/EuUPKiVQ0a9Xjc72zZ8BeOcPOypPZzgWgA//wiyxnsTZqblflf1O2Ny4LP7J18MhOZInsVo1qUxAS1XsxGPLKVTSsOp/rYqP1zMZSPIn4vaWDcWoHQi+yCD45HhP4I1t6W+PI3jPno360EnudpBxqpZXMq/horCskuKELixiPrETO9CenSBrcmetTg9yP1/Q+O+j6p6ZoB4aQkr0ApviUXnjXEToU/Q91XUXd8oyE4+30rBah5nVQaAov95HmBCtnjsEMSNt2hBFhCgMxhT3HPCInvmr2DlWPX+gXZo8E6EzDc70J1TToQUyVZrce3XdlUcsh8MJfd+JEBmwR/Cs+x/KPW7a19FXtKn0t2LrVkxeax3XsnQ3KKtRBjWPrmqr/vskrW6FKnfz268AOAVkolhddiKecX3InAC8gWhGCHCGo7jHFG1+H7yN02xNOeEqljet1UREEzPxoO0rC4UHpgaY5W/0jNYrA6P18m/KblH4GiCslweA6Gi8p678vcZ8Hx81lYqHGE7JwVTLkRHAT9HG8GbQbft7HUgB1nIiu+fY6Xp359AsIjUkbOgcN6jOJqW5bzErRKlGWVu/igqYSZeiV7RZ3SbjPKOCCmM6vWfoaPawgW9DOuqTer/wQrkSmoqup2Ld/VcX3bPUWKbMz7rokyL6fmwxSUJcA3zZsgqLtfeEkZlsgbJzRxc19kFoh0jhvDb1In8/GEpXaTfPKIT9XUdaibaSw0dekPnZk3HDPrnhFFe8CD1ewQE4D0slh/UEIHO1vvWE6eWIb7SKR0/CRWHnIEFhHiDT78iHAv5vrt0yGuIpwiaxpJpkqbhfW0HSmydUjg7u6BIUVVP+QtcaGigwqipUMGeadj2JHLddZGlsNLcvsZJjrB2xbxUe5eXj/zyI7TBdw9XGqv42sxTaZuY0/958Ew
 eLAqRnOg
 1h+PmakdwCThgE1RfcbAevwmx9CcajiQ+FlHh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 3:56=E2=80=AFPM Min-Hsun Chang <chmh0624@gmail.com> =
wrote:

> Correct several spelling and grammatical errors in the page tables
> documentation. This includes:
> - Fixing "a address" to "an address"
> - Fixing "pfs" to "pfns"
> - Correcting the possessive "Torvald's" to "Torvalds's"
> - Fixing "instruction that want" to "instruction that wants"
> - Fixing "code path" to "code paths"
>
> Signed-off-by: Min-Hsun Chang <chmh0624@gmail.com>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

