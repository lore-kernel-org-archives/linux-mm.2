Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB4ECCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 22:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CBB08E0006; Mon, 20 Oct 2025 18:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954F98E0005; Mon, 20 Oct 2025 18:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5A08E0006; Mon, 20 Oct 2025 18:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9E58E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:10:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0421785C3C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:10:36 +0000 (UTC)
X-FDA: 84019887714.07.731D826
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11F19C0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:10:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VVpTNzZd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760998235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilx2DzwdWn0Eb7pbCFulmV8VsnS7KdZoAGThUj0Ef9U=;
	b=YH3o/b5ATHzHsdUe/msZ/0ORZhjVYmsY1QdNEFJDC4A+rKXMCXn4N7FXlEkIevW1FMSya+
	W9LNmtnggPFYCC19T3hUcxpBDeHkeK8VijdXRB+RTKgWn3lwlZ+L1wJJ8csOtkwOUdraNU
	Lhif2xUez1qPZbk8qdMo+rBReYBtde4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VVpTNzZd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760998235; a=rsa-sha256;
	cv=none;
	b=l9GLV/5g0cmuiloGoJCHIf/0xLqoJsm52Rynx9jSv4pVA/FMyMQ9pzIiQy6EJdCz7UmIec
	TWcgUawyjqaKkf30OBWeJ5s8M06EctxSVDeE+vnqaNYnBqLXF/5dlh5Hx6CXdbaKY3Z5dB
	pwZjmp2D+kmP1B6UMHiq4GuzRP5cWSs=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-63d6ee383bdso827210a12.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760998233; x=1761603033; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilx2DzwdWn0Eb7pbCFulmV8VsnS7KdZoAGThUj0Ef9U=;
        b=VVpTNzZdCDH0JiWU6Q0vEP/KZZIUTFv0LEsbBc2iyVqE5uO/e9+E3DZ6pM2UAqSzau
         pd+Dmfis+y9zAv1zeg28NRm96jdbkZPWA+bGq588RbPRXDalN6oaqV8T2ZnQj+qGv8IU
         EetRvIl692MkO50PIQcKb69rdlt55xctBT43gXzDapeLFOqcY7UOWsheam8chv4mtCLW
         mK314LW1DI8hB149jys4zJFSv/3KWc4ztizvLQTggbpgB6U3eU4lA2gQKmXOXnHuFRg9
         TSV6TE/BsbtRBK6JSSvlbsXFTD1dlmsIiGqUBnUsrUMIm0lEcqw3GegKOAT5I0w9zNw+
         j3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760998233; x=1761603033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilx2DzwdWn0Eb7pbCFulmV8VsnS7KdZoAGThUj0Ef9U=;
        b=IdRIwF+PJMSRJjN3dGFRih/BFXBUfhiKnobFiQkrnGhrJB73BJgSmAcKvWtt/pmnLg
         r9Q487YRI4eGaW7N3w29nmkZq8LeBR1HZuWHo8WpuUiSWxx0ohrICJNkBVC+++7ux0Jw
         TWwNFcamQ5GYFWqlDED9cxs1HoFcqyKMhUiIiIGJMSTtmYGCuYmCi5DE1Zw5QsfIotQ0
         HJUwWK3UYNQlj0tBt1FWFB2pijMCKvrcakVdho5Y1Q8954o2G4YmOOv3S1fxBohxoIaG
         hmgfu034ZkpLu0Y4cN70EyKpBnTafpyUW31ib5wiaT5zLbBa7EN6m99IGdqVsesF/fom
         7Hdg==
X-Forwarded-Encrypted: i=1; AJvYcCXP8vmCa8OqfflmrPNjyZbb1iupgCapE7cvGpX/wk/1oo+cWI0T+acwpw2k+9R9thF+yoZBa0Jeaw==@kvack.org
X-Gm-Message-State: AOJu0YyqwEguxSkjgmRqWRRoc6nsEK2JEP0n3OcdAHAwe8ME+75NbQIM
	toPF99WLu2EIBWyIJsLJexJNTEF1D5EIi4OSyCPEIXx68+NaW5JIdiDj6w/r2nAew7pqhLluxrd
	zSaRZT02eZ+i4TcTw9VHZ8VWuBH4d1gWKBugn6dOGOg==
X-Gm-Gg: ASbGncuwPAcwBmCGROgDvxtNrpESEOWLp/Y7JY/MkQel6UFTahroEzkbcRoneuAmwVT
	odYhjcfIWzqDdefFLrQSWXCcnJ7xiyC7RV5F2p2uRQk897cxc5cChMPd3xtpEoejoF911n0ZgBP
	BWp+DnZ/K0hhV3GaPDrFgwXpnllOG67qCelAB/qfCcfq7YnPGvF5s2534T39OJy5HyGLJiEhsUh
	AFeUp/fzuAtNSkYMz8OyvOaSXeR6q3kI1a9tYC11xBFJjQK/Ogoq790SImnF07h3KR7
X-Google-Smtp-Source: AGHT+IHXgN2A3la0YJxyyXqBd0MasNf9JRFf1RqDDAA3OQ+yqvWzJtnk8lJzn/WVj6Q3Gweop1jcYJMwQr5SF/i4N7Y=
X-Received: by 2002:a05:6402:518c:b0:63c:5eef:c8eb with SMTP id
 4fb4d7f45d1cf-63c5eefccb8mr7887864a12.31.1760998233475; Mon, 20 Oct 2025
 15:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <20251018171756.1724191-10-pasha.tatashin@soleen.com> <aPXszzdehAbkPOAh@kernel.org>
In-Reply-To: <aPXszzdehAbkPOAh@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 20 Oct 2025 18:09:57 -0400
X-Gm-Features: AS18NWCJ1e_UpQW7FijpabJLDoZps9ZGHn4yCdktBVEdTDDj_pM8M4yk7V0Wg8M
Message-ID: <CA+CK2bCqZFY3HWNj6o2MS4+dz4Re+ekdY_GG1V4GL1Xq1NX_Ug@mail.gmail.com>
Subject: Re: [PATCH v6 09/10] liveupdate: kho: Increase metadata bitmap size
 to PAGE_SIZE
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 11F19C0006
X-Rspamd-Server: rspam03
X-Stat-Signature: z53se6ibrxsmofe7gpbhsbdwcheur8u5
X-HE-Tag: 1760998234-855346
X-HE-Meta: U2FsdGVkX1/gquRSg3bMhWRqfl27dnLyCn4TcpFDo+ahRxzuz4BFSOgXyAOqVRdthtqwGEHfP+lIf+mLfM4nduVIdLMoR7nm74bssuOZk3cdeGGunWVPDtbXXTOzsfQC5eXOnVajk3N/ArVbzGFRKJuUtqHvoou2YK+yPfmaJ+RfBw3Be14jx407PjX5KfSzAg/1UBhMU5cpw279HcFdWs1QIIjoywc0Tmqj0UAvusTjV5JN/iokFqQQ4MUKcy0gqWrxfp+FnLWIg8o4GzGGNczzwjkSAa4fDEoZcJk6/SCuVi1JU8TYPupfKuOc5lxgsnfe0Zwk8V4/lVcI/eXfOwzrEMrBPksh4cPvdH1eq95YF9UwYSZJuPnxEEH9PGrh12smT3960r6sG9PUED5BMKKFQwsBAMROXI/qNpI72YDzu9ncm43lyBgTnkrGYOfaM/tMoTMLOu1Yo6ipGutAxe9HPoVBm99tXy3t7+4XOOrnB4XSSMGvyEe22Fzps2m3+7jwBYvFxs6cjynQXpy9LOJy3jLBHzxP0rE971J9odvt2XpGKVCQcRHP8qwXi+A9To+6IUlPPqoJN5O5VVZJX7WkZ1lTWOEevX+vumUXNjgae3O/kLTDwHcxJhZG3wA6Amql6y5I5L+MaOW0znwaS4CaRMkZGhwwhLevMGirJ9lfEJrTETX2xMnw18jY7dW9O5QQH3vCLm4+0lV2N3rfSpArRuFbp7rjEJCfd7sbAtsql90nBmlQGP5dU7ZKwXxcuGNFjaKaAsY2IY51yST9nenHXbSyneskqwijDkCtcca/T0fkPCNTQI1u8ayqlJkB4/s+cVJUsjCbnPOo3LRFu0PdriBSbmw7PaoW7vcz9VELmT4JzwFsJoODtwfy3D+PKqBYhIiRvAjaRB+Yk8GrFUw/EhpzvpL60NZQknUpU8+xXUSH0/9Jwr0XWC3XciRl4fKSIc049A7MegCAOAr
 Rv6dplby
 1gcMzAARf+Wn67PrLA1QOEoUvPHfYOkDXAkZiVvGJ9WS7fOm76fGG4GN2oyurusODqYSpwVW4LP2SSlFQCKeXkubWPlc7uV622m4t7o62k3PuX/OcE3tQp1l7mCJpIHxrWb6YjOkN5AxuSrMEIvfiyuonbXFiq+cPXKnQjMwMyPNRVCRLwFye3RVOWA76FQ5HQhS0xtjpQnjiss2uT/9BPUxurZj37sJCT2NJZy5HYY+VxUwLd3xJEAdhqT5h8hXzAU7cbdtkNF8/ufQd8yQxUDMWDB93KMGD21ebnbrAe3OTOh8HcEEEkgrhVZ0NpwY6+hzl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 4:03=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Oct 18, 2025 at 01:17:55PM -0400, Pasha Tatashin wrote:
> > Metadata is preserved via 512-bytes, which requires using slabs. Slabs
>
> KHO memory preservation metadata is preserved in 512 byte chunks which
> requires their allocation from slab allocator.

done

>
> > are not safe to be used with KHO because of kfence, and because partial
>
> Please add more details why kfence is not safe here.

Done.

>
> > slabs may lead leaks to the next kernel. Change the size to be
> > PAGE_SIZE.
> >
> > While this change could potentially increase metadata overhead on
> > systems with sparsely preserved memory, this is being mitigated by
> > ongoing work to reduce sparseness during preservation via 1G guest
> > pages. Furthermore, this change aligns with future work on a stateless
> > KHO, which will also use page-sized bitmaps for its radix tree metadata=
.
>
> With the stateless memory preservation there would be no problem with
> kfence, right?
> Maybe we should accelerate the stateless preservation work?

They are orthogonal, theoretically radix tree could still use the
512-bit bitmaps, but we chose to use page size. Also, Statless KHO
still requires some work, and because it requires removing the
notifiers, it is better if it is based it on top of the other LUO prep
patches.

>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> --
> Sincerely yours,
> Mike.

