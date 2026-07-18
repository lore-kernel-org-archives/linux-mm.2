Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BC6C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 10:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610646B009D; Sat, 18 Jul 2026 06:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8AE6B009E; Sat, 18 Jul 2026 06:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6A26B00A2; Sat, 18 Jul 2026 06:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 152986B009D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 06:21:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24436A037E
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:21:23 +0000 (UTC)
X-FDA: 85001505246.06.47A4306
Received: from mail-ej2-f0.google.com (mail-ej2-f0.google.com [74.125.228.128])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41407140009
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:21:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LJFbFCLs;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of roxy520tt@gmail.com designates 74.125.228.128 as permitted sender) smtp.mailfrom=roxy520tt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784370081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uo1ihkeGek36vQJ9pDyNG3LMQEuP/HvtsD85zM3z/8A=;
	b=yk5sI6xFOOrKiftfJ0BjrI/IER6Py9Vr/QDRU/1tGd+9FyFss1tMmHAXjkP+KfB65ALOLW
	B2JjlLMTMmwNfim/jJfbOzbstDRRmi5YovGrxuf4jGBxulb4440fJKoXdXyWB0kQGRcLPj
	nRnsgg/ZQQjYg4t/yIyB0NioXojEnag=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LJFbFCLs;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of roxy520tt@gmail.com designates 74.125.228.128 as permitted sender) smtp.mailfrom=roxy520tt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784370081;
	b=FOap404lTLG2hONbvJEf88lJ5vmi+UPbTN7wSH35KclwRJPeGxT3T1lYlqvdKKuXO+m2ID
	HEuDEQH0bep0DcvoIqElBsCWXsqnJ/+WesfvzCjGN0DitAe5kxCZzY0Ej2OvUZx+Ym3mQy
	g5NUVHPlErDHbUkdqGod9utxhaqBTA8=
Received: by mail-ej2-f0.google.com with SMTP id a640c23a62f3a-c15e57b7128so556831766b.0
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 03:21:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784370080; cv=none;
        d=google.com; s=arc-20260327;
        b=BeEKgZxmESbgE0c1YVZCh0XS7qp8+VwNYssMW21ClX32TlRagGJOu87VLt91Yz7Fe9
         97xIGr3rs0x91E1bWH4vImZ+XdF1HFs/9neFNIzBgCgr7ZeJ+SGDDmclW91JVN/ElDSi
         DdtCeTzOp8rEES7V+QubrUuLtbFPHeGAU/0oQqKboEiv0Jz3MPp5hHLLjG/Uks6XmKKX
         n+U+i73Mvvfvvg8beOHdY+iWCKXYf+fNRiwtrZod7/afxPL1BhNt1u9RWhWlGmGYbgeM
         XntyGgB4I4e8Zylu9/PSXNQWXXz32yknVJE6lnmdqsUAfPfmfq6+vVJX8kI7FFOxuNTE
         PNkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uo1ihkeGek36vQJ9pDyNG3LMQEuP/HvtsD85zM3z/8A=;
        fh=y6Tmwb+1XLXFnB0m3I2/Yqw2tt1ejTcB8KPGzwUwV6o=;
        b=GgoEivv7ZER+UZmiKxsKVkjumPRK3ECIz8frQXFos+9tfJ4bNjVu+XDKESca/33gZD
         AYlLvIPgxIFwZMnu+yZMAD5wVTN/MJeYXS5OgpWpKQNRBWd3UmLR/2lXyimC5dazYrHt
         8pAMV4uKi81YT7SSvwgJWTuwwvD/1/YVfWw8gv0s4OPbeQpy8HIiSR7TWvWv1v1BM+YD
         mCuil1vHDWq7GyXZvTGm1DPormei8VFzE/Cnc+2u8C5/Ah2tnUsrhGQ6T2CY6SRYXESM
         mlOb6uV4qK8w/iMhjq9RsNKNJRXYSQ99jWnK9jXwnZo3nWm7DGuRsDHT5wPBf8k7m1VA
         Vpig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784370080; x=1784974880; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uo1ihkeGek36vQJ9pDyNG3LMQEuP/HvtsD85zM3z/8A=;
        b=LJFbFCLsm0I+Ax3s231L9ebFfqL/kR44ZUyDuUILf5hryQDXyte4qc9zQ30RfGfCM2
         tsls8VPC5pBSgf8DfyiRBcbAqGJp9NoX6JQmb8TFO06hJ73NV12iyF5hpnyFI8p8rmtv
         CS8UUzkmfAuKFNm7gvlrqWkGschEjN+Ie4Etdd4w0hS6J84P/2T9m3ZZpEvhPtIZc0Ci
         RTrd7QxVTTnDrXO+i+2pXtmOnr5o0bJUnloidRGNe3qTPTDjvZUDbtwa/ggu3KrqrJb4
         A1Oh7dbijMTR4U1v31ZvMtJ9Y2O6sPzbNiFSYgPFWAGpb3exYExiNBTlIrF4FnF4NKj0
         hkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784370080; x=1784974880;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uo1ihkeGek36vQJ9pDyNG3LMQEuP/HvtsD85zM3z/8A=;
        b=nLBw2ii13++19NCSc2i1TBsVJSkv6ydnluCe7s7KXQvKXVNHn08GK76ppnlM/jc+8+
         dLI3w2TBW7BIZ8jzv9kmz9+2fI446W39qxyB9Auiqki9uC/nlpXnLtOz+QHIio7NSX0I
         yq6s5G4fRfBb3rNlYbDliR/+QaIc+ThGSJPWzoAkVtS3uCkCcjZQk2wyxUTslWjO4ttg
         hZPqX8pSfyJ0xHAyKrq1jKQQtwUNOppqp8RQ68Cf93g+ZmyeyxQSIJTdxMzTXCEcWVWL
         +OFBqZ+tfe6DhMpRBbgHaj3KlLhBhDOQNI4CWo/fvVxhC+UMv1GqOgmiZ6uv3n95nyOU
         L5Hg==
X-Forwarded-Encrypted: i=1; AHgh+Rr7NwVLTLYr6wdQtriljlgVNPPoNp3VSJ1C+wha6etMIwotsSr+U9So6njYWPRaVSX9yL9+ReNKww==@kvack.org
X-Gm-Message-State: AOJu0Ywfx8T4DTafleutQcFq9rkfcSfjvaf872Xyuidf7WOQ4dHa3OIL
	gSBugT43LJlac+ED9bh2TQqZXrvVi8pXm0maNNo+P6HtMRp9ZpJnCHn79+ucMUTV7w550A/cnZA
	08k1XDknqpCWy8RfBZKN1J3mdczgyew8=
X-Gm-Gg: AfdE7ckCJ0i93s2+f7QQu6stIfLmrt7JSLqq080Et2YXHZuoZbxJ3KyvV5/UTxmsN07
	5DRNaqV2HFVNhLxdcdd0rBGi3MSL4Jrb6m7WtGEvMt3qarshSOzgjyYIeOqK9epKVV/CETARdpO
	5LlWAad+YIE8uRjRuwslkaKKl5wCXLx9LHaoWNQIGjaadyTWaxpq18M6BNltSxs0sh0RDjQLNRs
	u8ZZMZrG6pfTJkPUnevWcUKnXW+6BX4/us2LKEwwOnYgg31r1sMRBGsSka3DQ==
X-Received: by 2002:a17:907:c0b:b0:c15:f6b6:18f4 with SMTP id
 a640c23a62f3a-c16b46fd782mr292493066b.24.1784370079593; Sat, 18 Jul 2026
 03:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784337674.git.roxy520tt@gmail.com> <b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
 <20260717221108.c6caf7dd11a47bd7c32aa6ff@linux-foundation.org> <20260717223112.ba8646377b103cae717580c8@linux-foundation.org>
In-Reply-To: <20260717223112.ba8646377b103cae717580c8@linux-foundation.org>
From: tt roxy <roxy520tt@gmail.com>
Date: Sat, 18 Jul 2026 18:21:07 +0800
X-Gm-Features: AUfX_mzHYHduPKveomuj73m1U2BOh7DiDUsa4neI0oVpEwk85DBJN8shz30SzIo
Message-ID: <CALMqdkTUm=MBStkk85y=YAnQfHB_Jxis-BMZhcxfz=-YJfQDcg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/page_table_check: widen map counters
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ren Wei <enjou1224z@gmail.com>, linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	vega@nebusec.ai, Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 41407140009
X-Stat-Signature: azqijpxrho71a4k8ytmyti3szczs7ad4
X-HE-Tag: 1784370081-776847
X-HE-Meta: U2FsdGVkX19nfRBT4cay86CBICCQ+0H/xmUvkLjxaad274syE6qKLv9K4flHOeSdr/Tpgr0Vdue+yKuW4Ny1wcYmnpKhfNbrNsf4OdoVZ5AI4qqRn9UsCqEvfODH90rJ922AGHtmw9i7oZKCI+YS7ziYEqrFJnIUkJG3j7bNqK+b36iNjXr44q+QN8EDAJwyihVW4jry2eutT+qj37FZEucKsG/8O8usAvN5GaKYdsIM5Nx6Qg2PJ6llveq0pVljfc9qIimM5Mi08B4kv8e10XJmXYO3YhXBz3dqByo+IQcL58f6Ul90Rn7mT3iJHfzEPXwAVV0H9bgXdwo6TbepEMAaDZ08Sv517FDrMU4bS3b0BnZSHBgovJP9Z6fE80+7cExNFmagIuxBmbMTQw8tHTlXup+t2UadM6ptQcfLOBUh3YETpJ46e0HlF6Juo67ITNbHVY21Xk3zsog/o8h/2IjSPmwFHnt8Upmggmw8lD2tCLteGxj3f2dbvjawnNX7S7KUbZnDX0VWldJwcoWt3k5mY0amx7gT9HiP3ioddlLE1BwZJfhTKCWiS9cFs/BFrjUAkuGdmlIoWDhpYew8NgcBxpagUO1MgN6mRM21nMKYgxB7OE1UPtyU4j+VnhYD0d3VXUxbWIH4Mx6n04/29ZnZ8+xUF1ncPIXUNmqQ+Qp40Fz+9uD+yMSnwSnla7qJNjAXIAgokcXzjS/O/D7t9EZBUHo7EVPTERCsPg1sSP5oCLLaMIc3QZ3yeaQS3mWHC8aHqtO4cewaydxgbE30pS+gRl1LI7nlGCj/wLJ/zIClJrSsBUML/bcr3s/3UqmNcJfGcWuLmeJEMzlhJ+Rmtyk0jnKK4h+QmkoFlyOrGP4gLqb+9uttVeb572h8CPqjpGk+g9gsYjXW3pKb59wDedEWdjyB1q6X/C0+TkAdjnlRw7KMO4y7wVTiCtNJEPGiI7RZH/xF7N8hbrNZPzg
 M3LVhHkK
 Jrcp8wo8Hr1/Dak0FYCT2tcvIOIcsVV3iRmYkK5MDhhESJI5LjuylYgtKacu7LIDI4W+fS+Cp3plAaxunDCTR3NwK4NyCVl6uvWjH3VXZQ47UpxWxaZZsKw6cLcz6rlxwiq2BhyZbP0xgj+b/HKYBcIXr8e2xV57TE2Hn518EoXzfVRTMM2SHNzHRTeQdShbBya7Hfsjx3xcpOSsH6F/u5VoH9tPvu7Pa0J/WoEmAWl5JGAGJKMPiBAb3yPEFBrKZvUuOLi7NkmOChzRdvAf9ydy8nrEUYfiyy4CmmhO6d4u+1GIxf6Lwq6E2wbR/9wXb970YrUiSahfWdKROGtCKSMq1L79/bQRuxPuW2iV1FKx7VrLQpCT/TaOV7sDRKtLGsEq6vdrpCTR0y/VYBUwGeJvToZFride25lIfs+O+8aMbNAm7m/0Nrn3v71QIJ3wmhKicHDa5IC2Gy/hdeb3vJN9rnIEKD2mCCLBhAafKClose0r1IUO78sPnwSV8PK1KZPIKmHUc3hgf7J7bA9eFqN3mlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 1:31=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 17 Jul 2026 22:11:08 -0700 Andrew Morton <akpm@linux-foundation.o=
rg> wrote:
>
> > Probably adding __aligned(sizeof(atomic64_t)) will address?
>
> err, no.  I think page_ext code will need alteration for this.

Thanks Andrew and Matthew.

Agreed. Widening the counters is not the right direction: it changes the
page_ext storage/alignment requirements, and normal page mapcount is still
32-bit as Matthew pointed out.

I'll rework this around a zero-page-specific fix and send v2 after checking
the exact page_table_check paths.

Thanks for the review.

