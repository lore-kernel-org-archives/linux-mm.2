Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB7C3CA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 09:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D9C6B008C; Sun,  4 Oct 2026 05:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E446B0092; Sun,  4 Oct 2026 05:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CC46B0093; Sun,  4 Oct 2026 05:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45E756B008C
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 05:15:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7E8840B17
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:15:12 +0000 (UTC)
X-FDA: 85284384864.25.D124408
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE9CBC0008
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:15:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mjM1hrtt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of rizzo.unipi@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rizzo.unipi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791105310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaMhgqh0cNyzIJvdM7MdSJL/gkpQL52j+U/jEExbMjs=;
	b=WrsgNMuUbo2w4rBQASOM+jAQkEetfrLjhPv6RBik87NvwN5nMcmhIQTJmRtSQ4dPFZEMwn
	N3N54ELCHaGai3cXg0+jisa654SwRVmX6OGrBduJRXn90e061+tf1VD5WeahrDL/oW5ugL
	+ebI9LOaBd0MhnNk/rnmy7cOPQVLY88=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mjM1hrtt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of rizzo.unipi@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rizzo.unipi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791105310;
	b=dunxo+jhW+FEYyNtvHez2Qu3s/zb7jpjdfp0jzngVwW+8UHOwGVHM8fAgCNMwsPX5jF4D5
	4HMMYU45qWkbj0GzAlr//3VzShJfYuuYrUJ+Do70Dt2wPSkqufa7KSwhHfzDFZxHosM141
	tIMRMOElGA3ACMdDMGQi/lg9z1jgqkE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2dd76b1361dso5286535ad.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 02:15:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791105310; cv=none;
        d=google.com; s=arc-20260327;
        b=Tn1aqch3HeLncSdaQahg85MaxTkFXFUZ8+FRaBaBQyo7C/LPO3oB9xjl+HQ2vy9Tv3
         kw1LP3VzvYHdGfowWpOnPJArO/ohi/XHMJSDyfGGmEsLgs7aTC6xDw9K1L1caepc7wWM
         n2aAUAvfzCAP3YPXdsQsL4/98X2VRXw2MwkXfbjv35UF+450OcBEzgxZ2gppvhPBJ76C
         yPaKwcH1Kt6gvlExkS4SP9VuJm6JHIgBUqTF17S6+7zbNj8EMsSx38NCu5E9tLBUEd2O
         M1pdaWILaZLihkLTIONgAmNqflok6e+Izj34QHU4Giza1MskYFGH4eP8ntDGbDFHYHCQ
         PnUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kaMhgqh0cNyzIJvdM7MdSJL/gkpQL52j+U/jEExbMjs=;
        fh=IWHOKRwqqNJ5Jcl1HP9bswys5m5BXPgTlpz8bnjjfgo=;
        b=AbczHAxzVr1kd6XeQ/y56GAOHuFeh/r9iiCIAi+ox9xpfXEL7tXetGfgYcIGn9oWqQ
         /9DCvtSvLt2NmoCdALuuoKFloxWsVahazDWXR6AcRylgK3VuNYAAjQfhbbQMjCjogF82
         HaTJ8jhrZlyVu0gKLQJ3d8SLp0MYPLZhA45J+GQmmrxv9oZQbkcA7DI2U0aDvSPgz+pS
         BgSSvzEyYL0aQ/A8+/S0LIQ47vOzKBW/YVxj+bzCbJge8zX2LsMP/uh3knIeMruc9RG1
         yRCphNRa1lBXGaq1lybwyh4A/AiAu+uLVyYUvjlFPAPZ8CGqRREyvBB2YNPOkh0nmkUS
         /v8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791105310; x=1791710110; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kaMhgqh0cNyzIJvdM7MdSJL/gkpQL52j+U/jEExbMjs=;
        b=mjM1hrttXMTvFsN+0YmhfmNHpCP2GOFcj/Hr27xkQcL/6o4REUqUjQt2IKu1Iz+/tY
         b/oU2xw6wz0QUdks4nYDmyHnTO0a9yDPl006fr3wx3oTFikLAGMsuQw/Dzm8vYkcEBom
         ricGH66OUi9zgDGNtK2brhRpkr7SizW3AJZknDU/5djZHEz1R+0uiXJWB65zcNBu+K9v
         Zzf/959RvOsA87tGAbZvh21VmIJRtWSS6aK85mFhr9UlBMoWjxSx+Cdzd+luhUE389WL
         usHMmOc5kqpQwOD2lmlurijAb219ZHkO22+8Ln/EjmuEuIx2IP9Qf5cd3xIHz5saJuTM
         3IJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791105310; x=1791710110;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kaMhgqh0cNyzIJvdM7MdSJL/gkpQL52j+U/jEExbMjs=;
        b=B6qrZDDLGoKYC2P7ldjrG3pFwZpvQZgcXIxlnpS3iEogRIgv1+DNPQGLsJdOVifNah
         xKOPO/cHtxLbhaKlBB1pcU0+4pkFBkOoBHhwMpdQN6ITqWOgY/oFyS4vp0/Yr4QX/a+l
         8hji4p1zWwy1rOpAQS20QHt6nTJKwQuj+uRvLO5M0YtVmmwASZCo95FbSTDrJK+khjo5
         OVEQmLmx2GZqYdkqrTQm1UqdJi8rP/GWfCKcymMdTyiPIhE5myJZs/SvWV+C3fpRaE9i
         HKcus7c/5gvwRYI7Q7FJL90ULOv7dHEgCeaXuWzoFsOu5aPFBFNuNO25utLuvSnNB6ND
         FV7A==
X-Forwarded-Encrypted: i=1; AKwUvBxCSiet74CL1KZO4nYVr3+XUOXMhhjbGnpWUUMxZOs9WmHptQ/cbHxukYmqReRFeT3X1X4OVZ9zRg==@kvack.org
X-Gm-Message-State: AFq9FYIyJosxF0Ueg8u7MmpQHvWP3vFlUliwdfPQBV4cpZwqn5nOoGEF
	oDU6lDtB0moS9jNcFrI40t0itxwPP/ouNlCZEKcV6JppUt0oXgUS5fkEB9FB4ZvmyevaLtg2Enw
	CvYUL2bdbjfaqfHVYsfrVu9HHArnb0Uo=
X-Gm-Gg: AYBFou1JRK0mll/K45OE703E0ouFMCRv6ZtFT6HZZFlalSuqw+mFMt6q0O9gYOrzUS1
	8gDIK6r8uqSMRFa81NMGRfFFRlcpAvi08JT6EVp2IbLse+19mzr+RdIiZV7rlaGu+rzHEsjrJON
	Nl9eMKBfYpdwZMQUjzdNwDgDgdgxLOEcuHHNLSEk5hJoSA6OS2N3E2HteLJVtUpGFEL0dzBp56T
	aj4erMWRwZw1yQNHQw/EMyjMw1KN4uAVaNAaEuN8H6zLTR7927zGlNJYguuHA3uHhCmOLkJp+9X
	LcKqn4xjdWyPlJHawBTl8RfXokZ8Dizl2F6/CezQbRSq42a+U2v2wg==
X-Received: by 2002:a17:90b:2548:b0:3a0:d651:3957 with SMTP id
 98e67ed59e1d1-3a7873ac66fmr3158501a91.35.1791105309539; Sun, 04 Oct 2026
 02:15:09 -0700 (PDT)
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <20261003212241.3432303-2-lrizzo@google.com>
 <7ce092a4-5c85-4391-809a-3d04b638a722@infradead.org>
In-Reply-To: <7ce092a4-5c85-4391-809a-3d04b638a722@infradead.org>
From: Luigi Rizzo <rizzo.unipi@gmail.com>
Date: Sun, 4 Oct 2026 11:14:58 +0200
X-Gm-Features: AclHuK-h1jLN5HUM25V1KDJrvXlK_1XFkjlYVZ2OmcSjQmXYi39ZO7A1D8RAYWw
Message-ID: <CA+hQ2+ieCiXpnRzv7t003cHKG-YL+jSOSgVO_KavGEkbKfOeuw@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 01/22] iommu/dma: introduce CONFIG_DMA_PMD and
 metadata table
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Luigi Rizzo <lrizzo@google.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE9CBC0008
X-Stat-Signature: 6bcy1b4m9n3oknnshzqkauo9e3pfxg4y
X-Rspam-User: 
X-HE-Tag: 1791105310-632044
X-HE-Meta: U2FsdGVkX189m1IfPsIjI4/ZACxVM8rOwK8mZwZZVpVkNtpGuR1P3FMiGcBL9xImKG2AFxW3XQsoxgGVvCMaVTo8rdIZXa9rzXGHUmnx2lybC6cARRdtE4Ri1CeZV2Hst8INrOFOBGYz+kHBgZrFGoKEKYkCNbVLLnbOBKZK4VODEQmM0vK79N11yz+AuxLQfYdaVMzaLnziTuYA6pqeNQPnxv2enG5zhJ6FIUUNxDpN524G39fPJt1Cagfanyt9ovsx6jqlWafF2tfZJmzZeGb6zDXcq2PO93hB8oYSk1z/LJgmXbJBUk5AHUEgVDqxiHTwUsouc8hA0I417/g/0BCDjJGlid5grLt0nmzSELlQEhIZZpyi3DjwJxr9Jnyb8fk4mb9YthKCfG21zrUE5nKNAWnhyora/yddtX/HHu2inFavrFcYmtxibXgF7cdMyJQ4kE7vrKuGiCk/wLs2mBuRgAw/aOKXzXikPESxp4cTRsfmozytcHf5gbRIUR+TxdkPTFf3U/uA7rpYIQjxI3rU7OMR1IFvvfzm11XYFtps5LRkz+zMTFAopGlEMJD3UPDAqEXC7WK1AjmIQAzIFnppI7WRrI0ztL1fk3oCqkC6r48D+55W6zWVK0mTPQDzNm+L+dDXBNZWRcjWh92XCkDp3GBpBqEUZWC7Nb6uEA5dwmtEOico5CtpcrrMfrsWePFq6XM8q/oz/tRhBc41xEElhfZQ9Qz7w7JCNtJhNvQ84zNQL9O5zEOZCZ+uT0+aevfvzmxvmXJxkz38mAJ7gldt1jQNByjdTM5X/jq3vgZVAb9HGg+P6a+XJ9MNAj1hRCopHyGh9W/1wbqQ9MaFQ/tKafuANYjSKEpDoAnFTQl0tKmFz7GgKx/leCcAlUIih127TcQ/xTBsUN350tjwZmI1V5g0xOVSPjqTEEA+Y0Erf1qpwI4k7Op0r49sR0X2ll+qltmlRWEjfX+cNUz
 zRjoup1o
 JGAND89FGxJ9b24XWOzSqOP+XpbDuRwDM1nSiLmdpYBOskF4AsLfpFuhmNIBU3pPxXlCq/Q7cD/5qfQ8W7+vo2UDDo5+u5qdsRUaf47LIpfqh1lGszjOwdkPJSAjMZpQ1NmVyvza2v4wz02hERCLx9/cphE1Nz+A37kbAz12b3Ijt3iE3SCTIVMS0jBh386znxTelnM/9nzYn0nAlME4KT7Z37/Uq3cDgrwcwnpPUnOxXbKxzENkLHvIZU16YKq2yKXiPayEsa3+fHv6kHM/GWDjDHKbcXChJyYQ0TSw2JCHsaV0dLISM56qm6PfwJhxHP1kkqBnCpWCVN+SSPUNfYFO3bp3YE658SzQMVbr5+1VGYvAspKiwx6JV//xkyIsisqjojRi9E2+AyUjE/Vdc8MiK4y3I3PUaK9NwlgiEIfpwAp5sksdxdCJ9F6hsa7CAM5jv5tMlIcPNRL1HFacvOh+kejn9/IzGQfZTpDe8XWwL7NExVQpHFu8YcmJTh/JUVTWP7nlMPh4ihe/ZcvY54QxnFHNxp9PBayYX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 11:44=E2=80=AFPM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
>
>
> On 10/3/26 2:22 PM, Luigi Rizzo wrote:
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index 6e07bd69467a3..1bb347fd9da4a 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -158,6 +158,38 @@ config IOMMU_DMA
> >       select NEED_SG_DMA_LENGTH
> >       select NEED_SG_DMA_FLAGS if SWIOTLB
> >
> > +# PMD_SIZE IOMMU backing for DMA-coherent devices
> > +config DMA_PMD
...
> > +       Costs 128KB of metadata per GB of DMA_PMD buffers, allocated on=
 demand.
>
> Paragraph 1 of the patch description says 64KB per 1GB, not 128KB.
> Or am I mixing things up?

256B per 2MB page, 128KB per 1GB is the correct version.
The number in the patch description is a leftover from an earlier
version, I will update.

cheers
luigi

