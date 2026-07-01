Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C853C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 19:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E891C6B00A8; Wed,  1 Jul 2026 15:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60976B00A9; Wed,  1 Jul 2026 15:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D773F6B00AB; Wed,  1 Jul 2026 15:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5BDD6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:17:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AB981C6FAD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:17:11 +0000 (UTC)
X-FDA: 84941165862.09.B08D07F
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6560B8000F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:17:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ATORFMJX;
	spf=pass (imf02.hostedemail.com: domain of avagin@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782933429;
	b=Lqnnd2Vz0hVeBkKfriGCxwXM+N54X+XtYPG9vXvxizv++hoqw96veW0IXRH/qvBYVSwBqK
	NTIlbERcIux2UI6b5r5opwePX+xZvxqZ8EmhOoRGAuAGuR0DDgPbX3BxXJ45yjfyPhL41f
	5lRU8IE7YZ5W67dlJsfFXCb3EP8pG9c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782933429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+NletA3FmRDG/GD5IvXS5VhekYurTM15nt1C3iy2LU=;
	b=nYfuoLXp2saBfQAYcxwryY8VW0vJAXVhAKjGZwEn+c+E/HtQKpSR+vvzvjHbb1LpEuvBaC
	/Pf2bh0kzEp6VClYlCvetQKVePaY4aTdX6ZKCWzD0EiF2isnxLoa+ciUF3rJKmK/tllh80
	9vvF73p8V60807s9NGN86ZziWNaZQYg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ATORFMJX;
	spf=pass (imf02.hostedemail.com: domain of avagin@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-448cf99c133so1337148fac.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 12:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782933428; cv=none;
        d=google.com; s=arc-20260327;
        b=BGdmmS3btUA/rgcyBGahlVDBG3G++SGlOm18oj4ZYCfSGcLwCcAT7xKwqyjgnpM78p
         Pui0N1pOiuKKO1/Izq5rebhtBcQcGObnmdHSM+W3kNIzrbcsE0HYuYDTneDjEVS8SMBa
         gQuXMxQfAAqFx0AcgOsaoRrrDgLXUsyfYDwuAdNwI7JOiOTJTYJ3zIPuAVPcb340eWwG
         fixVJjG+Cv6A7oT8TtX19AdoH8TdJmL9uYUglouwSu5LrgVMJB10Baitpr5fuYSvJQjI
         Ra1CkxuMmX/MnF7BpcVVQzQE83glE6j/nsgtY4lV5+lPJtL8rrY3Ul1d1kxMz09xlbHE
         qoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r+NletA3FmRDG/GD5IvXS5VhekYurTM15nt1C3iy2LU=;
        fh=MOTH8H/iF9Lw56L2MosK7KR6zOfTX9xUsCxtyWuoWrM=;
        b=MLsT4b0/bi0lsy/n4mtdG32klU5HssJuw+EJahhSr9D04+DGHoNQp2I3N5n9SwqWSx
         CsIScOdmZzKmIXWCoA1pM2bVA2iBi8pPgMVXoXZC17m72wpjcESddnN+WTxOpLtl7+iW
         VVQ/KcYj/nnpaup45vENm2s/IRq6PCJM7mi3pNzJmsoyw4Sr896UscrzuBOvraqZmgf2
         W0ggTs9hVstJWz3SD5VKF6tzPRF3Hhsch+N701nnKuSUv5fzPFkuhjWa81QXGP+HXSgE
         mUPtg51DexIUuxqS3wdt1Fhf2APqBLhfre72ESZSkbHxHlPWM1Tbks5sdtdvVnIKSmDw
         f7AA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782933428; x=1783538228; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+NletA3FmRDG/GD5IvXS5VhekYurTM15nt1C3iy2LU=;
        b=ATORFMJXM9yYsIWUAzEqLSztLji0WGxaLDsR/NRjNvWXzRR/yCK1UJ2T2vKYRUEBYf
         KGxzw5EuidsVbDVHOZgLWPa0sHEkyifIYLj/ikXRPlliYbjnmTRZ8jlxOdzJHDHrlr4L
         iZuUsGGFvP6VHjHvPuOfdBjbsE+BnbjwgY8ENrv7e7aCdtxUpKWjo96Nu3w+8JX/5kKT
         nFlgt4jMY91ZnSSIxTr74qyzEgZ6BdfHM6//bOArSYF5xDWN6l1fB8WIHEVq62TMKris
         pCf7xEJuFGkpyKkMQRPtAUZBojSo82WNOqx5H9K6pre5AmLMb7NxW8NKc/byIOPPCooG
         B7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782933428; x=1783538228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+NletA3FmRDG/GD5IvXS5VhekYurTM15nt1C3iy2LU=;
        b=XM9ZhOhsoC3HAOy5mCzkiKGhKmCSDXWRro+LJHuXDvQqTv3yZ/b4/ynaEWMqdmd7XV
         GhRH1QIBUn8FRr08xJOHF1JSEu/bwJ8e0TOosqd+OalLSZb3maIuWws557NvFGi9VVM6
         g6VhoI+Ke1z8Hld0NEQ7LNTUw7u5McKREsg37UHoe3/mRRwnR1LuD62KGR38gRQqL8EM
         FCVFwAgaDOx5SF45/NE1ArToJB3EfSCZ6I99VBPIt5Wrva3SxMVEWjizo56OAmSgL34M
         eryMSaYMhpnWXY4WnC46pVt/7ONywBxqayKlxWJHpInr/gtIsd7BAEbTs1O+OCa3bKNW
         hECQ==
X-Forwarded-Encrypted: i=1; AHgh+RqxQ0/vOeMYA8qeUssZIxJyvNR1Nx0RpEkpK7392cojmGjBS6+rqHCwf8EVqc5wBzEodwCTdOXZ8A==@kvack.org
X-Gm-Message-State: AOJu0YzQx5N7nkZJICP1EVrjswExfF0QCcVeI9BKsUj7V2NEj6DnJmyg
	79HnfsQkawRLd4lWlFPK0AJhr0aIzJn83uQKOEYHutXRcfNgur8rNFsGhXxhrzYjugzp05RSSrA
	5VWrO3kQ5QjdNWbXZC1jHZHm/oN48X/8=
X-Gm-Gg: AfdE7ck/3tIQ80pl5LLyV/NP6pnvHkONy1dJxq8Rx3VDjksFWgejQIuumAqX0+NzXY2
	aJK2NzbWwYXoI/b8SmghcCI9lqgSo1gQJe+Lt456Pb3FNS0YroObJPkA1LIhH0TAhlYdWCzsuq4
	zE+fuElKxVj9eAs1e3GpVBkYF/ztNGxUtw7SLt7SWsw14ad7ErKl4/eeN+n46UAAwa1HuyvMzLO
	mYbPPeKY8qjGyq7YaPu6CsCJu2Qkaq+P0kLHyHxv/VQQAQhTzG5IvPvNSxl23OVI2Xkx4I=
X-Received: by 2002:a05:6871:c8c7:b0:439:ecb3:52bb with SMTP id
 586e51a60fabf-44ae2b77260mr4418100fac.2.1782933428320; Wed, 01 Jul 2026
 12:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
 <20260625101132.3859505-1-safinaskar@gmail.com> <63f7860c-4f5c-4682-8914-27978b9fbfe1@kernel.org>
 <20260629-bauland-knabbern-abgeladen-c0acbfa62cc2@brauner> <CAPnZJGAJROqfCWSeeBu31HsE6nmgxVqHTNeC554S5y1Y-VN19w@mail.gmail.com>
In-Reply-To: <CAPnZJGAJROqfCWSeeBu31HsE6nmgxVqHTNeC554S5y1Y-VN19w@mail.gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 1 Jul 2026 12:16:55 -0700
X-Gm-Features: AVVi8Cfr-c-MwbiVa4Na7Gy64V9E0QAPHBSr0wHsSXCEVpPyigPKnVtNTDOprcQ
Message-ID: <CANaxB-wewdUnxApVU3yn7hqbztNJFQfN6Y8r_XZk-TZRXpOQ=w@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous
 vmsplice patchset
To: Askar Safin <safinaskar@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, 
	axboe@kernel.dk, collin.funk1@gmail.com, david.laight.linux@gmail.com, 
	dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org, 
	jack@suse.cz, joannelkoong@gmail.com, kernel@infinite-source.de, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@amacapital.net, 
	metze@samba.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, torvalds@linux-foundation.org, 
	val@packett.cool, viro@zeniv.linux.org.uk, w@1wt.eu, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6560B8000F
X-Stat-Signature: tuyyer6zabpmr7bbt39drsor4qg9buhz
X-HE-Tag: 1782933429-446722
X-HE-Meta: U2FsdGVkX1+K/JqgWICPZoTpn3kziHqclwMpPTn071zgWG6wfbRaMITzYMIsKb4gdmNtBiKrmHx0IJHMZh13zBB6G46hgOvWBgkiEUBufhBwBIAkoPiONdu3qD8+9OTfVE8aaDlrCRmH3cZCYAFQhh9A/Ufi3IWI+LqkE4K/or0JzEY91qSVOGTUBzYd9JUbuBwwe6pKbFf4em8csfw8SaXOi1Ck1UiLxPu2z9CCOiDO8S24HAjdoy675J6dcR85fe5qBmIy+AQdqFSQTzBpn7k1PaRghWRUKM9IuGhSXcu3HWKeX48D7yssNBa5UbSWBwupkCTAwC45OBOZpLdNtRiNwmwjTrfhX7oYoA6hXdpknw7kmC5RFcMedmQ7AJ2LLeCk/DeHcV2NN+itM4kxxESTFaVkSjxK3jOKyhTU1avW19kKhdMM3T0X7PrYCC4Rj4DkUYuitdycdJ+90jOZwQIinY3IyMqs/GUIBclpaTre0OzN8Sx3auKEUPsNgaNOvs5t8+hTqnIjb/hm0l1Ii3nEHUbvo3n6BW5S+UMH+VNBCDWPM9rOfqAwFLFa/bIwQ3GhkqKIFB8UpgCNgEF6JKyiAII1dHCdawu+EM0Aa64QCHkGQWAh1VLOcb+r5w7g+uAXxq99OHwZpGfz4fNRXKhFYa5+HEEF6ENUnpHS8XLfmdmmcN3Kvtw+l4joHBxu+XxPH84JHFCDlEJiOfcuysSbosLwObx98QQ3IT0/ENF87dZcSluQ2umSzl5VzSM+OfRUmj0uJp5hzMwl26OYzt77rVOFYhaDqM8Mr9Ydq/WgNGn5lzn122GEGv+hPQzkDZio+tENsDLrU7/TAUw3+UhLSAcnzJZWpHKeDap55N2zrxG4UP079xp/9HXDyhPL7bXYHuolnYq7fk66r13vSs2bQGOQ5CND6RA+WG/cNOlt1yUyhP0EvMAHueNPOBa8pdbROdFJeK3TkT2B7k2
 N8odIqzb
 ZsLrqd7gvP9th6MuVUzz/iGWqhWonQeIsO/jnBJUk1SqItOxVVMvG/aIVozVFSEJVyJKl2iSpznAy13gQoj/tRu5+r7Kn/uAHB/+QIgd6sTPeAVlE7OxvtR/teGAa2cqYh+alxLlHQizAjA2MbJJQgALCenD3jpvDoeKHYOwZGw7qWuCFjdqNTZAaKken30/IG5TVWVOlSVa4fAG/hqrqU0S3HXwD6epg7a5Fo7JhQKo2vAgXs9Kc5Yth0FIXi2izMP8hB+DFgpTPqXQIGXyf9muBj2lVVP6Slq6l2Y0Mk8RfaGWC+Na5WIvfBoSSXi3gfhNjU0JVhTwqFDZBWptDlsIUavTzR87UCLBPqnS6n6soKcIhClMD7NJ8QqpLYTrwUpWOB1kI5Ed1IXWSczJlk96PzvoNTsaKCLOip42VRBGNuKqnJYH6pZnWN1GU7QSC+Azve5DbGnxoHAFZBkdfbKGhP4oqv8P0N7/aMidNkW6peJpRsO/kxnUalpR7/RuFQ9XMdhkSwGlqn9i65FlAY1j1Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 9:01=E2=80=AFPM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> On Mon, Jun 29, 2026 at 11:56=E2=80=AFAM Christian Brauner <brauner@kerne=
l.org> wrote:
> > The amount of regression reports that we got in short succession doesn'=
t
> > make it likely that we can merge a plain degradation.
>
> Let me repeat: this v2 patchset fixes all regressions found so far,
> except for major CRIU performance regression

Askar,

As previously mentioned, this isn't just a major performance issue for
CRIU; it completely breaks the current pre-dump implementation.

The other proposed fixes look like workarounds that target specific
projects. Since few projects run tests on linux-next kernels, we should
expect more projects to be affected by these changes.

Thanks,
Andrei

