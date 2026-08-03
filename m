Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C741C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 579626B009B; Mon,  3 Aug 2026 15:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528AB6B009D; Mon,  3 Aug 2026 15:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418686B009E; Mon,  3 Aug 2026 15:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D00B6B009B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:15:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2FC8407EB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:15:05 +0000 (UTC)
X-FDA: 85060910970.10.B8240D5
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0AB9AC0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:15:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BM1D9lWI;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785784504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vx9cs0B64lm0sgfekv6KEXx1UZq4jRor81/CYqaYzQs=;
	b=QFs3d0Q5gQCaJ1brmdXLW02OhtJGfPFHjuqik5HkyjAKcS4uYFXckfJV7ttIR/7f3edbf9
	nTAnprEZ/PdQNZnlSbVM2tYuRHF4KmdhGxjTZpWE6AZJU3sDyGAMsYEwq+s/Hvkw2Mhmul
	zVXeaSjEBzLyVa7rpzRwYC/O1TzhRp8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BM1D9lWI;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785784504;
	b=JLuAhOKfXpEv1hUcnW5IpaYmtmgG5yVQ0nLkFrczY294V5Bc5PcYXU7ctLuVkcEjEzeL3m
	E7nOwRoazL9y96AdOEAj9odIY0yNqNoONdJ1iINaU7OZCSsmBwhtk8HBvTwHmvdKG0KFcB
	tIpIkUSb/l6hZHNqgxqv2Aqm6gKik80=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c01c79467so57921cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:15:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785784503; cv=none;
        d=google.com; s=arc-20260327;
        b=BOnqQrWmuFF3G7EDrR+0ozB9VW2gEC1lqUQfeDKiVgF+Acd7pgr7KkpdKBuAWUewy5
         sLFYumF3n3wu0zDTVkspVGmHtjqbCenxDqt53T67JdBvGpD0/B7zlI4tUpJYQ0gP/Bqz
         /uRlU7QQhpU1nx1XYfTj4xyROZjpbRNsZKLJdpl04ZaUtok8lpeeB7gLSeoF/+8oD+bG
         r20HuLTXp7akUfU8R7NA+LLai8lN2t3RxdRCggybZSzPuRmuRayyH606seuI5LrbNHVZ
         ZqAwhw2xnMayRTfxOV+WxiUemxYGY5d3qNfx3y0U9UD+iUMyGVF8h1/5c4WV5IRc/lbg
         23Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vx9cs0B64lm0sgfekv6KEXx1UZq4jRor81/CYqaYzQs=;
        fh=/hr0HiHbogxX/TT8p1Irmb2iqKsBjO27RtUqmZ6o65Y=;
        b=Ha3gR4JKY4ye/ln08Ni0YOSw9IoCS5f+bAO6gTe2s5XUUrSFXFemkz9DtJBVOR03XE
         8U0DikApbIH9zohfXJz3A1gwdJKMXiQ5Or/HvuzMP9rrQpf/V/+RKVX40FK1z0GPVn+W
         qZ4EgeVc54KL8u2NauVU11uUQhbSjiF+lGLk4KNSQmlueaUS/5KvJHw0HRw5bFtFcl71
         4jwuOJrgU34ENlO6uHKs7J6iL8gOFy0A8GWNa801jPjrL/Kz9rrqEwXlDQ8J3jVRbTTv
         CkTG+uFEWRpqLVF3rGSbU00ivln8DVK1HoL1QbcXast9+TxHPVsa0igvAQHfj1JHL5f5
         4XZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785784503; x=1786389303; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vx9cs0B64lm0sgfekv6KEXx1UZq4jRor81/CYqaYzQs=;
        b=BM1D9lWIswrjZ8qDV9uxMOHNXo8Y4Ysu2qLoiobcfC4Rbm9dNp8mseq7gL0zRk4A0i
         3Z6bJM6RC50YlLMA0tTvVVMONNlJOettWZ9EqC5x3HAZDmsRJ6QIasNaR4BfsHU+PjeG
         oFFPIi//f/tpP4JCdd/bNQ21eMyYZTtBm1qBs6h93Cf+n1BJ/uwBHzSQSEIoEWUGL50C
         eoEM8cfHUwwTYPK1F4/CNVZf2QgAyCE4DLwn6nUDdmVUrIftYtdrpW2fuH9ptQ31Nisn
         8S6g8cNybq6vnmBALhIvBMWA09VKkndR/zBAcXOQd2oiuykr8gojzyfYaUUcH1kQVqbA
         wC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785784503; x=1786389303;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vx9cs0B64lm0sgfekv6KEXx1UZq4jRor81/CYqaYzQs=;
        b=aN8A7DngSp/4i4PijfwkxbeHzNROnlI9vQq15gHJbEFkbAZgmN6G1spyhstgdn5yHo
         YQEd44QloZQfq02+F9yINJBGrUmegFgms2C0zw5Wb//puhaJLlqmR317uAHhmGL2CLeH
         3QzRNRYgi5fF3EhyRxqts8GSVRmGON1uLb6JoIzQoej6McirQhooYJmq73rpKoEJEIls
         W3NMcjvP8NCIqG1fknpi57YU2UGphbM+s2nuBkJFSoL0EbBPpgWwBrc8vvXDWLrvThNF
         Cr3XX78vJ70xSnnPYh6m6itUS/qwqthAhWvocnZpruiO2adYrawSju2jltCSfF25NJ3f
         PmXA==
X-Forwarded-Encrypted: i=1; AHgh+RqSgtrFyPc8Q9cYQ6bMb95IKU6gT4DbWT5hq8gZ9zWGz0EDBPBgK7IrVQ/1eSLqxri1/9jzHt8U6w==@kvack.org
X-Gm-Message-State: AOJu0YwJKrf95RYkDAeQ7tDO6jnC1KEs59RsxhHLE87FmoPPf30CpGpV
	+UaU9YbRhoVqhq8NKR1ZQJVUhnfZ6KlgJ4fnn2Zpujgd6sVosxQ0zaD5IgzHkAtjVXQZPCEALO/
	vLqvcUsh+H/V0ZkUwppPoC7N3qopaPWUcSW4chg0h
X-Gm-Gg: AR+sD13eRZu2lHc2bzT6aP0vb39RR3MKtp+y75x3QUcogGkw9Y+IdgrsOUw9nR3yOgz
	pD7stL4FJwWZhvnw8GFuYRD//TIkqaMuEoDdI+nOO4/2E+zEmIV7Stj1/UhhXlQiBBXxmhJ6NCZ
	8ONW4n38iXllbWxpqlAUt4Op6OVEXSbvtEpgK811SgOU1zUDa3MF6wTfA71vmLpim7DlPB7cqjP
	3jRVt7hbSj+lFUimACszt3jC8lv1xctQt7zt0DZbFx6gnFc2HUrs+jLFKvUAphpu59DkWqMntSU
	Pux/AcakeI8dZ86B7ByhXeL68eP4bQxrSuktsqG7w1mgeqksMUhqA5M=
X-Received: by 2002:a05:622a:98c:b0:51c:ad5:93be with SMTP id
 d75a77b69052e-52cd4df7d70mr2079611cf.8.1785784502537; Mon, 03 Aug 2026
 12:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-5-surenb@google.com>
 <anBuwuiOBKXJwnhT@google.com>
In-Reply-To: <anBuwuiOBKXJwnhT@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 12:14:50 -0700
X-Gm-Features: AUfX_mycQo4q9-oh_NeNxMl4F_bQ3PUY4_eZSLYeXtHNhrEF3IZz0lhXsltZXzE
Message-ID: <CAJuCfpG0wNiOcBmdANjL2Z8x_DPPgfh8dXsYVCeeHHtCfgHSSg@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] binder: Remove mmap_lock fallback
To: Alice Ryhl <aliceryhl@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0AB9AC0002
X-Rspam-User: 
X-Stat-Signature: bsxj4bznizpe85gh9aq9t8mdhxz9konn
X-HE-Tag: 1785784503-405662
X-HE-Meta: U2FsdGVkX18sub4MdkwSOd1jLswsyh8spUYtgWwnOnrC4KOBfOzKzNjkTzS3TXd5miS8K3KvyplKUidbyrALPPT/Xideeo7jHvBXEtznV5uA7K1MRdFSPk/GSzn9HUzGUJOasBHUJEac2Xv32XVKQWvjn1NpGSa+3TYIoA41mtcC6RWFVDrYRSxrMRMbkVGbRLgJjg9YAmKnZTdIv+rcx7J1BOmRl/OOkeCFSsZfUF50LZ2c0xf1L5ooLGrG58mF0LPGUmG0nl1pR7PT5DroM7EzFRx2KaZhkXgvfplogIG8gpcTRvBn6prGg+LTAYqxn+/+97CauLIuvogKmySmUhQTeRAaM2DIhioZXjUl6up7npnaTArq2tSAIYeiLvDLznaWlGvJspESD+pznZKw6hJHOzrNYAtUv5DDKRiYHD+s+ELMA6LbfkaIq+jH6473wonz0RkKbqOYDKDtu7u3q8jC9azhl5Z3287LDf0HbA4rCptEciCsgvJclOPoEDEAAbZbtAAqEVAxsSsU5arsco8TENgGxlHUihB/GMRDignSAKo85grvyzDCKLulnJEjMiKl1Cup0Vms3vviaFYvoGnSZOfi5paArxFQNRGm4OPF79iASwhK03CFyl2mIFZV7x4RR/1fX0nUOTkE5hsGf72ZmiP+ah1vJdWtdyWZVnjL1saryqwBJrVbzMZralsxOU1290eEjJ1S0+iKIs+qGzXNuCvoWcCoTpCmaERyInRN6D8KxAraIH6QmeS+iQq89CPKymB98rjbee8hTY2N+GaYpZ0rXDWxd8R2hFutKUcefLcn1yWIEOgHJ8EzjzQlxdOCJ4bEr7XyaEQ9ovdU1PNdJ5kXhGpObnEWoJU8o6yRG0F/MEJdLDz3yqX6lAqTmPKIz92whEYYobcjfO8DEMxq2eCupgrGrR+V+ZSofZoUH9JU8GspI1tkKQCIRzguHuayY7W0i76zpbUp7gf
 Q5Nj1F4/
 Rzac9suXb+/1jNh8KaiOBxyK7X7/LvK//mQmdYy0Y1CKWLi8OfCYRio1rkPVF4cBQxVezyd/t2qUqpD/r9d17leHyI1Gnsq3UcADth3D4UoG75MEIJY7SknVD0Omwd5M7OUufNRbavIFnUTgNiCDCtwHNHGhzj0uTjELurD9Tk8/1QpVaIdMdOGXLi8YW39MYPspy4F/vbBn0nw/pyhlZd6E7ty2GM6yOXYppixC5O+lwu0SU09ndAiLH6lqxW5soGDZamjX0ZwfDuWaDpJC7Gl4lhYD4mo7b3tOQuYa++VsattfS8/uzu3bQitiTizZ/I7Th4uNLhuJ11m5vGJZcl0KrEt27jxKM1CtI9klOIUrMDdMRm6UwTqIhqNFxzssiDviSb1Ls9+L5OKjiWWeuk2aDGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 3:34=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> On Sun, Aug 02, 2026 at 02:54:58PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > Previously, the per-VMA locking could fail in the face of writers
> > which necessitate a fallback to mmap_lock. The new
> > vma_start_read_unlocked() will wait for writers instead of failing.
> >
> > Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Thanks!

