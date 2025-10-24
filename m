Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C94DFCCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3373D8E0094; Fri, 24 Oct 2025 09:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F1D8E0042; Fri, 24 Oct 2025 09:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224AA8E0094; Fri, 24 Oct 2025 09:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 064FC8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:34:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1A205D9B9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:34:12 +0000 (UTC)
X-FDA: 84033101544.28.5043370
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id B94AC160008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:34:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="QL/FaCpZ";
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761312850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haLaA7lxMDvRDLFEREFCcYqogj0xnH+XSFGC/4Oul/E=;
	b=tKyTi4+qNSChDaJere2mbwAlRFb8/9NXDaXKyIq6XTPFxDWLb04WNsQKOgwwO1ebA3x990
	6dbz/rZu1/skhKEgb/GgO+26/OM8w4nunkVBKUNaPkuh8TpcswvQ2zBc2i367LrLbMv4QI
	uR8c7HRugMNNDo1nAeVXzHv+9gZze6Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="QL/FaCpZ";
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761312850; a=rsa-sha256;
	cv=none;
	b=770L6T1rZTaJx8kte3+x0GAX+pxsuMEPItiIwOb4LNnx2L+SQffoQtO4rEzZoHRS8c42sw
	ZDJ6CRptH8xBHt6QVA6gqJNV0Xi04JfyYfKyrWNV7inM7buvsWccswXOTXYkzbpiHEA4A8
	cZLDsWUNaQSEewkiPs0enUfG8y1BNl4=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63e0abe71a1so4098457a12.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761312849; x=1761917649; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=haLaA7lxMDvRDLFEREFCcYqogj0xnH+XSFGC/4Oul/E=;
        b=QL/FaCpZqWBsih5wa43WaFDkHIiKCAObb29Rw+r0KQNMl3bTpWQpMAbPCM4qilvIO8
         o39IUZBWlfEDBBHffCXjlo2NqYGAO0LtayZMf/POsJLzhC+qSTmL7HjneHeCf4QAb++e
         6pl0649Qp3q6PsgIA9FPvkr5T1xhyJz5zryCSplcKuJnnXK9npEO2UVpCpwRJZC7uJTS
         UCX3pNYc0kOFLfgphQ19d3rOjj5BySXBvkmqeMgNBffYSyVlsOOO1KeQ9CqXWvwLCNUc
         uhDMHklHyxWsLz3QrCFzggggKJDNpZw+OndQ0ay5CB3vQoREjWP0bjPrSeeQc7EtjCJg
         d9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761312849; x=1761917649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haLaA7lxMDvRDLFEREFCcYqogj0xnH+XSFGC/4Oul/E=;
        b=ZPUFpH8Hn/cqZlMSvlmUcmrVvQSTQ7I19iNNFUmVHE3DG5A9qUZHVhgiWV7QWzZvdl
         cyeypGRUy5PN//UCmppeZaMnetzS1W6Yi9Np07M2YpoL6J8M6C85XamuISWF8/cIzE3q
         dpcSs31jfqzEuA3zercc5/RM5Wipy9HsB+Wo/8I1J+1f+XbMdBsmnwn8zAS98pq4KtbG
         S/vs179TwBSm5oupTVv1QXk0oCPMC4M5eBut3J9BrrO23B1Z/9+dO+cWsMKr+fHPrCC4
         YG3CKOmuLhfS0w0mE6LP1ikWeCo/XGdQMPGZRpfEifmWJpVgFqM/88YtIkd4aTTfxUIY
         v8Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXSj+yRg1lMX/f7eCA7AHWYavI6JRzDZQpcs/7ekmUZ7pHi7cNrq7QVOcPuZCLdtG5I0i6xe9ehRQ==@kvack.org
X-Gm-Message-State: AOJu0Yzk2iZMBxAESeYdyfScGwkHMjn3xq2FsprX7htKORNKd8SOb3wj
	/NLqMWC+ydZRVZarsdRc8K5g75yJWjfGP3iQwVK6mmDqIIeR6KEZjTB5rcjXvGiBhaf+qRwAMvZ
	qUqX4om2//H2OIPrXZd/DYgs0e4nzy8vJDglmk8ACrQ==
X-Gm-Gg: ASbGnctEeeGp/qdn+qyX1yuRRotwSxAgXC2VcAzyqvwargxKP1VXXDkGX0d1Trye8yb
	vW8DThfCQ/xGybzlmy9duqQuw5cvdVcSPdSKdeX/GmOcxPNqaSaPBJwKfmZq1o9A6Iz2Q9YxePk
	L+I6+xU7kRY9j0yyrDFsv+gVukpK97BqCWBfY1iDjj8xtkhDq64qYe+t6lrXpgk6gW2/Hr530XO
	wvwv8P1bW1ggG2pZ/WfYIPT3bTKdZts0Omp9RWj7VbHmAl66h8/M2VP5A==
X-Google-Smtp-Source: AGHT+IEzIAcc3Ex0g+fxYGjBqIzlBf1vJcJLTWbeACMQemDEhzKA6K/edpqUysNPgOqtGsZaZRYXJAcNxrPf4tFjkag=
X-Received: by 2002:a05:6402:51c6:b0:63c:1745:a5cf with SMTP id
 4fb4d7f45d1cf-63e3e10b6f1mr5434005a12.12.1761312848891; Fri, 24 Oct 2025
 06:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-8-pasha.tatashin@soleen.com> <aPnaDxwkvEKAFlRO@kernel.org>
In-Reply-To: <aPnaDxwkvEKAFlRO@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 09:33:32 -0400
X-Gm-Features: AWmQ_bl_g5ZmeO-lTP-LhDGMe93IbEIGbMAHW9grfT3etU4xtd3jfQfdW6oYRhY
Message-ID: <CA+CK2bDUNfHBX=VpCww8ERa__+CUM5-a7pEi=hSu-W+S_-JXng@mail.gmail.com>
Subject: Re: [PATCHv7 7/7] liveupdate: kho: move kho debugfs directory to liveupdate
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 81fma5t3yrrsu7ybuzjyrfaqmugf6dy7
X-Rspamd-Queue-Id: B94AC160008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761312850-144616
X-HE-Meta: U2FsdGVkX1+d2Ul87ePwg8bId2PzQUVH1E3EIk7yvJ8SmvIZb0VJqB9PvYA488hVfKMds4I9YmFf3ssLq3k00tPMLFY8zNLm9HQPX2e2M/E58/8BEmP4mzc5bZVqqsilmphJbQxWYAhyXrKZLZSyVirbh1k3ceQAWJPK03iyu7QY0pHucpVGEEiXvrzMy2Gv6qbhq0r1kxPxX9IwvJ/f1kjD6zk3/fPw9eznM1DeZ4ZxFjMsHzZdjnihmTCe/VXSmtOyZPbgaKlI6oOjjevXbgG3rlFwypbxdji9ZExjHUz/hh6GWoOf9YN2vcCMkkQfgLgR6wFyxfN1MbENHygNPmHzsaIuTFUHpmfge4oNTZ0OluDNQg6MuwwLpPnAlVber/XhY5pD0F/aqXY9Of+mu6HFxmLjLzdi53hJiQCdaTpiV+M/NatmVyO9A7Z4apJimtFWP+Vr1W1n0RkAOzcZ2lSK8p5+haRwozdO3Krh5Xa+m0uTLnMI2T5Qd+aJZy+RnMBiIwm8redeWQXanYTg04BvPniIEZWcoS91Yky+1be3OvA2KsalU+sCxQIjtpPdqVMZ5wr8eZuL0Zb+G2pehprGxDrQxD+pCftifhD0SJnYSiLFY02kOe9yWhSD1tmPJQ5eU6OEJA7vHUpPlhcR7HNp74o6WovokncuI4L6MO812wUVzdjdDPS+yf7WnjAIi8gG3JcD4/+vP8hYypb9Wkiez7piaheIWbG/RKcZPJisZjK1f7z88+xWt8UITh+9/lAv7rBy6GGG33AGh8lgSjKEVzWD+tWmnJPPZvQfaR9lYYAiP4UhbaZQ/mtV1a0cCDf8TfUnq+JBtFPT7TCy1iIRvgHT251Sc4xgMjzEdoUuFXAmFKxXiWFkeP4HjFbzR+VtVQXxuG+gN5XBors6CUoMq3y3X3qGrXIBNtzOs0l6NBPDtqDVjixaBJATxUYb85+kVVFttN1MUqR7iz8
 200MWCdL
 AZ8vROExqAk8+/W3iuCokNyBoN5rBfBl2K3kEjGXZt1MF63VGIirNU86KZgykeV0oXgw4HvHxqfZ1eGtX9eNkVwSk7L4wmqs9vXbhQFE5hOuULvov890+3DmLoiRTSXqutY/vwtl2vMouDKbpQStt8WwoaB4ZEt5rYNgbMYZe1nmqq/cpGg3qIya1aXYaj3Gprm3jUNQQ/SprVHJuLfvOwAGSCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 3:32=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Oct 21, 2025 at 08:57:19PM -0400, Pasha Tatashin wrote:
> > Now, that LUO and KHO both live under kernel/liveupdate, it makes
> > sense to also move the kho debugfs files to liveupdate/
>
> But we don't have LUO yet :/

Yes, I need to update the comment :-)

>
> > The old names:
> > /sys/kernel/debug/kho/out/
> > /sys/kernel/debug/kho/in/
> >
> > The new names:
> > /sys/kernel/debug/liveupdate/kho_out/
> > /sys/kernel/debug/liveupdate/kho_in/
> >
> > Also, export the liveupdate_debufs_root, so future LUO selftests could
> > use it as well.
>
> Let's postpone this change until then.
> TBH, I don't see anything wrong with KHO and LUO selftest debugfs files l=
iving at the top
> level, i.e

It is not only about selftests, we are planning to add kexec telemetry
that is going to be using KHO, and that should also be placed in the
same directory. Let's keep them neatly in the same root directory, so
we can use them for LUO/KHO/Telemetry and perhaps for other reasons.

I also think, this patch is small, so it would be beneficial to land
it now, and make it easier for LUO, and soon to be sent out the
Telemetry series.

Pasha

