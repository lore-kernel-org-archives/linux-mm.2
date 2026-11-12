Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B7B606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JtbcxyRu
Received: by kanga.kvack.org (Postfix)
	id ADA1E6B00EF; Thu, 12 Nov 2026 11:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2606B05B7; Thu, 12 Nov 2026 11:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEDF6B05B8; Thu, 12 Nov 2026 11:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7167A6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:37:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8EA0A051F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:37:22 +0000 (UTC)
X-FDA: 85427022324.08.35AEF40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C2305100004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:37:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JtbcxyRu;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501441;
	b=Xw0uj+5F7R1DeRF68QWVGe8K3RBJU8HC3YqOyBGyTmbqXVY2WQ7zgeAOrMBG7mSB70tvCz
	XNEHDLIwSMK8Vouev7EJPTr4uu/RaFebIdDydrlw3jIPG2jOczyvzaTTrfCS44ZtxLzB8K
	VJEP3zKtFkHntW6MknrsNBtpjgGb3Uc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JtbcxyRu;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzpP0vNSGlOAIKMb5RTnXN+svoTiLHllJoO+OViBoJ8=;
	b=MO/eP8bzt+Si09KtuL7LWArH8/FACiZb1sesj9V3PgYTUW4NWT35uk5RGS1ptwc72V+Sp/
	g1FPfHh+6O0mb49+FQqKKQ9PvIn+CBR0zC1oCWixcvBb1rBJx+oQmvaOcn0FffYb0WiNY2
	L+NkYuJX/FoDm0DoemQ0EkEcN30wEV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B95D4461D5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11BD1F000C8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794501439;
	bh=mzpP0vNSGlOAIKMb5RTnXN+svoTiLHllJoO+OViBoJ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JtbcxyRuYUdmpqP5H5BD9F2GgZhQ3X4BFDS9tojC7bnKf0d9LGYXO1gcFPdTGRD0J
	 7c1kBMoBBmA4NJowAK0IDCiDaQTFScXcuVMbLsJoKpB96x6GYiVlvMvwh9ebamLqyI
	 ut4BixsdRbpqSvI9cobILMYxqYd+Cyr2NARHym1+5aOrpEU0dSHwrSj7gT+v6FhUcg
	 R9YgfyBRilIHo8gjhloe8FtnSJhLjJWBJo8lrmT+PBfG0ncHMzu8Q0udOadlwjVk4b
	 5I0oc45+V0hkmrH3Su6AZPTcRcTcOHthAzkzZLY+O96BmlgV3TTMVr3I0GbExcp94C
	 mPO82T8tXdB0w==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4682977f9aso597237466b.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:37:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHR5Fy/ImBN+2nNc2dNqtMPKhVtF/eHiuvN3NUiFvw3X7RZOBAoFT0VTfzyQmG3iYapCzg/Uelr2w==@kvack.org
X-Gm-Message-State: APuU4Z8fm03hKYVNpe7Rm6B2KkKbP5r4JnebeeL5qAiOkOXbHKfZNrSn
	yMqo9maGWZ+O6Dm74EAU+h9MjP5sGFEw/qZavtSNNzl6BmSEdFSBvPi93Zv+S72gm2T9bStaQ2F
	T4nLq1YqVFMYHZkRshsn7+8n/OnFoKKE=
X-Received: by 2002:a17:907:6d18:b0:c41:61b9:6ef6 with SMTP id
 a640c23a62f3a-c5066b44161mr527120066b.27.1794501438515; Thu, 12 Nov 2026
 08:37:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
 <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
 <CAEEBa3VA2vycMaRCe4K-qnO3SGCuvAqhECmjmk6PQC3xxERiLw@mail.gmail.com> <CAKEwX=NVox_NYML-5Gg6W_gDt-j6gquk3sba9hmbvz-U+t=ehA@mail.gmail.com>
In-Reply-To: <CAKEwX=NVox_NYML-5Gg6W_gDt-j6gquk3sba9hmbvz-U+t=ehA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 12 Nov 2026 08:37:06 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOeR-t6PC2DutwuciVn5S4DYppEEo4Vquqt8gR4SaJ=xg@mail.gmail.com>
X-Gm-Features: AclHuK-7ezWbMPMvWXar6_n0m9b0WYGTxJBkL5D4Vd_p_gB_7rwyr-GwyhfBg60
Message-ID: <CAO9r8zOeR-t6PC2DutwuciVn5S4DYppEEo4Vquqt8gR4SaJ=xg@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: honor zero cgroup limits after successful reclaim
To: Nhat Pham <nphamcs@gmail.com>
Cc: =?UTF-8?Q?Tom=C3=A1s_Senart?= <ts@perfloop.ai>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, roman.gushchin@linux.dev, tj@kernel.org, 
	chengming.zhou@linux.dev, mkoutny@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@kernel.org, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, cerasuolodomenico@gmail.com, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: myfmqjaunxsqbjcc8zwyqnxtfhcenrid
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C2305100004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794501440-617022
X-HE-Meta: U2FsdGVkX1/XHbAS2K1Gk6PwtC20oyeM0q4fogJ2uO8wwhAi5ED0YvgUqSRcguSIoteNOXSuvmyuh62fbbO8d3KAlBxkHVNgceDytCmCYOOkzthG7+z1lDNxd59boJsloUiWurBG3BURtZTEGeyeDuzZEpwpWnb3xj6+prRYFBrDZDP5KhFLvSHDT1d6MNZaDNKIW+ave116PvMwKJwA67h4OfwDSlwOpXd/FKse/bpTenSWWFT911tgLWuJT8mOR3FMU+L09flKe5mtBl5gvfr2bc/Srmpi1RXe42NMInULaHcATQvTF/M7h0RbEu4q0pzw9IRRVzw6LptYkYJM3A/2HE5drEf4k5i6gpDhHzSi4JQcxShkZwRBiPVCA23kw8DR/n3mjtdPfD4cuK4C6vMJSs3skEoGvupcCJMWtdPMDVy/Y15t1qH7sMIegaF/6bsLPGYaEyBK0/MwkYQtd5M70z0Z15bqvzwZYsWaJa1EfsPlQ60H0n2UuJIPKtehlTFf0cLbgQhYb2iV/KQBLCOC2BF6NHrXy6t4VkVhadTKJ4N3WBAjukbuyxW8kP7NGAHP5YgFnwIQ+BaSXClfM4kT6oWzPYNPxj5epJY2hXsyzZcpmLEKK4wtP3FwpbNcD7K6JhljJ0gWWAUBkC0r/f2quv7x9bMe/hQz3Ix66jnHyJYGEgG/f0sykFLv0LVke2VDsfvwco+MJhXjWhd9DUe9cOThkkqcKYmYY0aSUaEtBALEAb0TaDMof6dwC/p98xc8x66IxDVSbs5rx48aBMSSEkprTaNvgVW6u+zf1SOYuh901AgvY4BYg/cNzyPqflgqS4xlRInFC47TbPOH1adhp8fun2MDGnh9mMo4g31OULEPRUobPnoG0EJWy4zIC5MS0rl0G4kE1KiXYe5l7m3uf5I6OkW27qxE+fZ9nOWikNOzY3/w9SLBYR8B4ZfUL/eekSnBIuyGT4Kzp0/
 tz04QZWI
 iQQuJo0wykdtUjxaYe2eqjTS4SwZZY+NW7Dg49DoOz2aY6Z1zlM83B4aoeFaxzFTqq3vqirkFgdFCxl/hYasYSJtQv+zMrT/4oCuBLwHCL0pxS2yAflwM/KoCHnmhxYE+cjEqz3/1AeaUHHkJku9bMx7W+rPOzb1BXijkuAvmcrT8PPrvbdfxnuOq/4I21zEsVtWYW035evBXbn9Wi+LCa0GttBmbK9pdJfovMjFlml0NObKw8Iu6gv2ZoNQVGlohCG8oLu+TaJ32oEmhB2Q1M841ZZfBq6pTMwv8qjIgASbQ85LcUassWIoFkWA98oL7k89GX+nLRVjGKok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 7:45=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Nov 11, 2026 at 5:55=E2=80=AFPM Tom=C3=A1s Senart <ts@perfloop.ai=
> wrote:
> >
> > On Thu, Nov 12, 2026 at 12:28 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > > Why is that a problem? Setting memory.zswap.max to 0 while the cgroup
> > > has active swapping processes is naturally racy. The limit can be set
> > > to 0 right after we check it again anyway?
> >
> > Agreed on the race, this doesn't try to fix it.
> >
> > The case here is different: with the limit already at 0, every store
> > writes back an old entry and then stores the new page anyway, until
> > the pool drains. It's bounded, so if it's not worth a special case,
> > happy to drop it.
>
> Yeah I don't think zswap.max =3D 0 is special here. We can violate the
> limit by changing zswap.max to a value lower than zswap.current. In
> future zswap_store() attempt, we will let it proceed if it shrinks at
> least one page.

Yeah if we will handle this, we should check the limits again instead
of special casing zswap.max =3D 0, but I am not sure if it's worth
fixing. The simple way would be calling obj_cgroup_may_zswap() again,
but more efficiently we can have obj_cgroup_may_zswap() output the
difference between the limit and current usage, or have a "try charge"
API that handles this internally.

