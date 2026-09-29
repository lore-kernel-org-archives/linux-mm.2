Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05263CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E986B008C; Mon, 28 Sep 2026 22:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F436B0092; Mon, 28 Sep 2026 22:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50BC6B0093; Mon, 28 Sep 2026 22:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3BB26B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:01:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 585A81402AC
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:01:37 +0000 (UTC)
X-FDA: 85265148234.10.EFB3542
Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id ABC6DA0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:01:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WgjlagPS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.229.12 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790647295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=0g58I4h4nmwVw9ZB8EVoFTUYEfVp+7fY00zUlya+KGY=;
	b=aN6980LF1BgMiGIszAUsK7PSQum9UkVihuPKZzhF0SXNOdp7nWeYYAdmG6CBC7OOdlbG4s
	AcRcjzA1tC9DjcssVk+BWyAVuQjMvUv8HFb34I3cyUxd88Z3w0Ma21rPM/pXQTeGDs67rJ
	09egcanVBAccq9mxVkMiWqtf8CYD2d8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WgjlagPS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.229.12 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790647295;
	b=fp0+1hhbTXODADhETECnZcVDlUSGYh1+f4neGBEox3H/Qb5JNAKr0YSpFclfqGqaYOqJjP
	JPGGiMZQx6bMqN8VX21aasaEktLElKHqPENWqi+uQUbQdGFYUR68B+Y0meEw3qQY+9nnoR
	Sr0dCr8k+OEjUS/fhkezEs6kQc9YFYU=
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-328664c2da6so3136189eec.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790647294; x=1791252094; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0g58I4h4nmwVw9ZB8EVoFTUYEfVp+7fY00zUlya+KGY=;
        b=WgjlagPSDSqB2y8YyNg2o13jg/ApOYNlulFDBY0qxoZ2OzIYvEBB+GhSY3oZwQdJQ3
         AMpaxqOYvjfpIpj3F7t7NMKpxUM+fDkBAMf951/E9ekS5BzxKuulcBOvAqoTsPAX7k9k
         dEKtGCbsOEZ4myyBQCOoxY/5cZqlx0Rbla3ssT3DGUBsBNQ9M4Qm7VlCQ9neGAa3/v0D
         BwL4pYBP4IfvYdZ+qbd6/I7q8tV6C8JUw0kqxed+C2odFqjT/3kQFLW1dJomIqPVEcae
         i1kODhF/LSk8yr0pQXO6ar548qgkK9Rk9gxE9zVj0ze35p6s2y35/iqDJATc+Ru6uP9r
         BIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790647294; x=1791252094;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0g58I4h4nmwVw9ZB8EVoFTUYEfVp+7fY00zUlya+KGY=;
        b=rFJoLrNTOr6yEXqB6uMaZuv7C7CBXmxCuPk6qk+/dq6kMH+2XIv2mbdTblKY4Ly58j
         Ch9D8P5ewoEiEpCRRH1wWGT5Bg4hRxnVpnDRC83mX+Sam1XFpZEpSRENIo71Lg62t/hu
         XaJLYUPIYlwSk3TfJelz0lXqikjjRcVsTifn8WLjTP808KMtXAnFVykxIYWS9sl5v1fV
         FZR+3aS2kPoSFkd2YVAqd8IQ9JW+twwOdopp+NQrRfaeh60SlxwJvNeiNHP/sINPOZb0
         4sCNliETPWtZdrdv1YgGF4VAiyUqNIDd/kDp4CJEuf/PSoVoDdZVFhgbOl/lvmbQ06x9
         D2+w==
X-Forwarded-Encrypted: i=1; AKwUvByq/6E08/JFShe9nKqYbplKyv9cYix1uShO1E/3Ngz1ctGoErTpucLTDb0LCrsfjznQnQReCc1N4w==@kvack.org
X-Gm-Message-State: AFq9FYJlcIQOinlYY3V6VEJfN4bR1f650QJ8s70JIw7I9nK9CkP2swdF
	uqlpbCIY/3r5x3b4uDYc7S6Vb8zJJLqYg7Bky4wz7/l+00gbAozuEEx+q5dq6ehG
X-Gm-Gg: AYBFou0PaXStEt4VM7GZuOlfglDcoifUo+Tj2nK6OSVEPsluRvyV7Kwd0WNdCLrh3Cx
	mTmX1lToDfj5tLUnCBXB+Yhs7v1jJ+KFwSzyq+zoBIeaGn5tlxLqWF4pzDAUCM2PJbScli/Tk2g
	+BAMpltmJKEbTll/Euer+HrJvPIZODJ3P+HU49KR6UqxGNtnX7AaBChhNxOv/zEfNbHE++eZMoP
	tYwUrPf4R2nesJbSfJo+NM5kevkhvLIQQiHvqIv8kszmoBuzew6SzU3+lZb4kxOZDzOU66Q4dKT
	Z/6uzItI7CsyPtRxBkx/AOiKkoApwonbwkaKYFZzaMig6dix6LIoJ1e8eSFYyd3oyrFradzdLvS
	3Ine18GsrTX6DwVcipAL1OF2N/CG54dxINNxTEOkWklp7dRX/FCEz0qeOmPlTGx+4gztkYV33zt
	kX40akpKsUUjOIBihQj6Sd+yYxqIgdRDUPqXGLvNZFrP5u3YQCB0cc6l/s7fguXBw6vxazIQzhI
	9DANA7bDS8ffxI7TXJwn6Cid5bhkTHk4oV+dUHONV04EO7YBctaBTiOphNhn5vo
X-Received: by 2002:a05:7300:16a8:b0:342:4a2f:49eb with SMTP id 5a478bee46e88-34272b4bc8cmr11854243eec.38.1790647294257;
        Mon, 28 Sep 2026 19:01:34 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm22818699eec.11.2026.09.28.19.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 19:01:32 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Muchun Song <songmuchun@bytedance.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/6] mm: Unify device DAX and HugeTLB vmemmap population paths
In-Reply-To: <655A7615-5885-4733-9E4E-3BDA1FE39362@linux.dev>
Date: Tue, 29 Sep 2026 07:27:09 +0530
Message-ID: <o6dgkefe.ritesh.list@gmail.com>
References: <20260924075259.2013039-1-songmuchun@bytedance.com> <607759bf-59f2-4ad6-b95b-e780ed2acba3@kernel.org> <8385F749-0F72-494E-9CA2-2E433A066712@linux.dev> <se2tjmpk.ritesh.list@gmail.com> <655A7615-5885-4733-9E4E-3BDA1FE39362@linux.dev>
X-Rspam-User: 
X-Stat-Signature: jtespdqnnwqbykkeyf4egfk5jzt16nye
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABC6DA0006
X-HE-Tag: 1790647295-58354
X-HE-Meta: U2FsdGVkX1+a28hLewNiloluwQCzzpmEofocPYA4xTz05hgdMqgW+8af8czN7MumiPPL2GjQWr37r06zsguub5sG5V1Ducj11f1yZaj5JD9OApDD2glAtNeRJexm4iVJUXQEW4Gxt5U4b9sBMg4xd1wiOMdQK7NljCz7gOVmo2BfqD/QqXB4o+Jq8/IgmNds/iV937sNNR5ZHDs98/lTvFr9CxE60pIvvYtWMDexVMk1Xwcuk5L4iYvwgxKFCSjCLrbzdVuTw2QYZQjBo0jdVjCwfudXY7QRzx7Q+vdCU1IaJ8Mr3giL3qLIr/DtiF7wQDnO9rVMbOtHuxEuhSjU7Euya9UXFSe3oggvXXRttQRAoRxXyKjrNJjxhc8np8LWTtY778feYR3QYceKa/fY1jZ1nWbPH97yFiORIp5MVbrTbOViep14NFs62XS2NOkVFdD6sahzJBRNkpBNz8TmzNG1zdZzUHIUXWoMFwTp9ATemq4GvoFnvMzlX6cdy2guC7adDjzEM0xqDq4c63Pzax/7NwI50EBTQ3pX+rVSHET2qt5heEYnv4JEZrJ0OdYri/wLQICFPN4000NtWthteou3Y4NV2E3DSf/xPWKAIJ04BKOZRSEkAlhjsJBuO67ahGFoYysgGo1cRMa3mKQrX1Ikll/024QDjy5IWy1mRUPmbDAkLYQIJVaFXKMlaN5fOdpw8zCNfVyiyWDKGxalkX2sXcN/VqJFg181dacEus2ZM87V4isyB/LPvN2uGxgaslQN6jQBzwbwQVxSY8LvG0ymlNgW/eStgpg2+4R2ob1AZDp4AzXAMaKfwh+kggZVKSkK2aF4aJq6vq4fboNZPXGACnCcnmmj0mWb2w7xrsn3DcodGjoRl8zh3tg+wi0Ma4kinNTdFOePQM5KnGZzspF7HWdd0u3DCJ0HQrzKfjHvNFC62aTaaPGwo7JrR/cwmJzy4OaXgsQHyzv+joC
 fw8wyDCq
 zvPIEbrg9MkUKXhc3I8uVJXPQ0cmHuh35nk7UXRhwwMfX2fTOhxdpdb5fRIv0Xz73C/GzFLTZYU33lnjI1yu1WK6UvkDb+nej6z2MzKHVSOQ83Ewe7Wru9o3YXQM5eL6z3arK/fHfkSwiXbrbILTE+RLE+7D1W0U6BoH9ksTb3sKKN8c093lCFVqfp5t3rYx6gveLMUvA4tn3gWBxw9Ueo6gAjDQGfk1mXEWSgmSrXeQ4lci/4EsF5qWtVilpxgrhIrninna3b0DH6ujHDnYakz+7xGzbrNTV6bsY9OLKMF/QcdwlT2sYcSsXdCmmG2vCqihnrWKq2F/CCegjrbRasG/CvixMHvpZ+apxk3TxPDPEYM30IkoaBg0SwVfOdkuHfKJlyzOTxzz5Vkb6Cm8vLRFvSbXV2ZU4jeC7yTmx/xtRD334XmUU8XB6F4gbfMStB3kxdeemBscysp/8H1cdmIW5j/JMfJi84qVW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song <muchun.song@linux.dev> writes:

>> On Sep 29, 2026, at 01:43, Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:
>> 
>> Muchun Song <muchun.song@linux.dev> writes:
>> 
>>> 
>>> If you're planning to review this series, I'd suggest waiting for my rebased
>>> version.
>>> 
>> 
>> Hello Muchun,
>
> Hi,
>
>> 
>> Thanks for taking care of powerpc side of the changes. Is it possible to
>> share your git/github tree somewhere? Sorry, but it's hard to follow
>> which series is based on which and the overall multi-series is based on
>> which upstream tree. If you could share your updated tree somewhere -
>> that would make my life simpler.
>
> Thanks. For now I'll follow David's suggestion and explicitly note which
> MM branch each series is based on. That should make things clearer early on.
>
> I'll also try to set up a tree later and share it once it's ready. Until
> then, let me know if a written summary of the branch/dependency order would
> help.
>

Written summary should be good too! Earlier I tried applying on few
trees, but I wasn't able to - hence checked for it. If you can share
which tree and/or tag/commit-id should I apply and the order of your
multi-series - that would help.

> Thanks for bearing with me while I get that sorted out.
>

Thanks a lot!

-ritesh


