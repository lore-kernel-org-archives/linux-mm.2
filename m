Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F215CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95E78E0020; Mon, 17 Nov 2025 13:44:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45F48E0002; Mon, 17 Nov 2025 13:44:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34F58E0020; Mon, 17 Nov 2025 13:44:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD86D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:44:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7635712DECA
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:44:29 +0000 (UTC)
X-FDA: 84120974658.20.3637279
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7FE701C0004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:44:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NUwCBMMU;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763405067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMrH/ZmNqpYeJLFgobm11jMJ7I0km6rEckJ6Z9B2Uqg=;
	b=lJdOHCIQ87ygOT2JLxyJ5Mr76REJ8BpxNz0eCt+EM2onbX2qEPXdGvxlGeyy/Aw4Te4Foe
	86b3lED3AemRd0LXy8YvB9aQTr+pGDH5/SmtP+EQlW0uF7IoeEF1G6osbXYZ/GpdRERO6k
	qs0m5ujzdJTL2WJnsVpn8jGqhv1QRE0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NUwCBMMU;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763405067; a=rsa-sha256;
	cv=none;
	b=dv6jNo3Mxe3+AzciaxNbx14RnHQnIYj3NRCM1Kz0MJ87ermURe7p/Kd6ApmmdiX/DvrC1w
	xjpzMqrQWhEBY0pihlWQ1G7EzDvB1bb+zBea4GtdF4gdLxVnkvHjG5Vq84fnRDaKGdDc+r
	IlPOn147oQ1cj2s6MjLQZQeYbapDB8I=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso7928729a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763405066; x=1764009866; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMrH/ZmNqpYeJLFgobm11jMJ7I0km6rEckJ6Z9B2Uqg=;
        b=NUwCBMMUUmf5TuBaU+yC9hQuohWrYxHHHA/0IeMopCwmzDlCDAs7YIlep+SICPcjoQ
         zLPZKbmXR+4EohkRZBBZKraUG6+fOTof0iQQfz+KS92y+aeVmfZ8+MLvM/6LxutATTpv
         DwLSjDH9X+h9jg+4K7AqR2LAZ8ZpD2Ar+DiG7PF9Eagi8Pw1CVJBUcL3/iQGgA1z5qs8
         auZ8uUZOeczemGEVopNrmvZFt1xFMzN1lD5xu4sfem/nWFn3TzE8WDJ6TbabQbmiT/Ut
         FgNYyGJD/CkASC9JDd50MUEELMZ1wsxOU66CVF6FUOXjAYxIgn7DKP/lp/+nr5yWBmvx
         Jfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405066; x=1764009866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jMrH/ZmNqpYeJLFgobm11jMJ7I0km6rEckJ6Z9B2Uqg=;
        b=NO439V6tqETqlTDHW9t0X0pM+0R8UIEZCjjCHSQs9VKXduWp8+rhVjJe/uNSHgib/r
         QdG6YxAnsAbiKQCc007auX7KcCaZYHZ5mhUDmgA8BYU7UbU3l/JpaLQgGFpBT0+tyVY5
         QVgyDUYElqJAa5PvlMDPjOq4cLGGnkdEEHfaT96i65yM7yQZ90CEXa8Nmia6LwlbCaoX
         s7R3K+b3PSUiONsCMXBCW70L5olzoa5DeaNdHhZ29doICU1ac4mAH8KtOOib16ZCy23w
         smDihygQ9G19YvRpDLgqJmG1nzwUZqeT6AJlTBlCzfeuDvxg9jr4D2WzwnyfXaKvDXSv
         +pIw==
X-Forwarded-Encrypted: i=1; AJvYcCU1CnQpRE7XygIc7nIoI8WSR0w+zivPViVVe+Di15xzWUjyMFZfl6I8xbA2N4NJyGHH2TcIo5DEIQ==@kvack.org
X-Gm-Message-State: AOJu0YwOWFw3ne2bkKMyM6uFcwr4il4z6/o/Qo5a478OkfTuTi8FzQQ+
	SX1L8FVSVNOZloeU0YJanSdZeNCiDeQHuRVzrRqojQ8r0tF3l2FsrSgJynSb4+NJQkoOl8nGQh3
	OKEH/TkRpBPIsXcxLt+EYc2cY3zqdSwvCmV3gn+u2SQ==
X-Gm-Gg: ASbGncu0lcBdi/Ouz1GqFcq3UxHR49LkBUy5YlDl1TnDjklRrdzXNuR+ZrKAQiHZmDW
	Yu73TusOlTwtvb6T89So8tJhO7WM9b2nChcbL0ugUIQ5wP1anMqH1GtxvDJYzW05k1qfncXqP4C
	IkGarYBFboHdU0NskvuGenUl//djhzkhTvUU90vuuZg15BCjTzCTGYdAMElxBbSyJuCvYOVj5PP
	g9+DESzK91IZUWq/Ke/FgcKimR0KajJqWatHEEYHTpWZng3dm5rMUUjoHSyZ+bjIqwTCZl3ODJ/
	4yc=
X-Google-Smtp-Source: AGHT+IGuvNw77dXDtTPV0AYardMXM6grq7vkCAHZp53MffW9vtH9Ev6zRMSce2XWGa9IMF6cKfb7xBeYsNCCNwLKBNY=
X-Received: by 2002:a05:6402:5213:b0:641:72a8:c91c with SMTP id
 4fb4d7f45d1cf-64350e9b333mr11717643a12.27.1763405065655; Mon, 17 Nov 2025
 10:44:25 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-14-pasha.tatashin@soleen.com> <aRr1aw45EYSFTCw9@kernel.org>
In-Reply-To: <aRr1aw45EYSFTCw9@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 13:43:47 -0500
X-Gm-Features: AWmQ_bny7bEklZsVXOjnwEc2I8Kpi65plOcoXCf1e7YrheuK91-BqnEf_WUIt4k
Message-ID: <CA+CK2bDpLfxLZMwNZLmg+K+uU4YaUefJx+xfD+kQchKpkHping@mail.gmail.com>
Subject: Re: [PATCH v6 13/20] mm: shmem: export some functions to internal.h
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7FE701C0004
X-Stat-Signature: c3mdc9ahqa74wspgpty5ea4k4cbde4x4
X-Rspam-User: 
X-HE-Tag: 1763405067-314581
X-HE-Meta: U2FsdGVkX1+TufDVSAaw9M1G9uMpvHSnsTASEsdYASC2PDBgsuoPUTQd/aWDUdu+kOZrOQmAfWBZBXIwaQSFMm5BOOFBdtoeAbGWaZBHs49hQEsPZN5rZQqeFh8fnm19SLHCFlXaO88EsjIqEAIfGdbfbLJEu4OFCqwR3K0/TLG4PZWeKkPOMedxrbSAuepJpw4pwQD1lPyiLATKIfe72z2y8oN0vqmgKBckddZVpCmLmL5moOzODPjKSkEXXNcScD00nH9Nw95YCFHj3XXu1ai+wdg72JUt9GN9BZE5vDsRdPjLt9FAtszgWkQ/TDefsuPQevhdnHn9FzAMT1PaJsLWHS2s5jaA8zFUZ5ZlNF9Ne0yM/kyZTXxv04VmUGwF9nQZhzcmuip/P7r2IbWlkkSYfw/VjHVMfCW8W15ds9pvsYv61OYMpiN470mRLiT72q3mmKJ9AdKYroymdFzin3T6z8ossqqHpNLCXfUTuCiP6yRF03QZZ4qKPvw8ynG4NaqdwwKYHzVdj8PMp1GGJu33NHcnGrtlouKBCKcw3SQiTENpzbkVY/YZ7mL6fmFt0XqL9aVksYaDrkTaBkszLYyvLZKFyMcklQ58OJ9XTSKyJ2NEjb0TiPjlDvbMH9GOclvgAeUhQN9aqyI5HcgG7SwTbA6ebTuIK80MPEOL0FhCuv3nra/UhFzeNSyllKsci6glhVVHQPFXbMWRHw8OVuyJaoNwI9rhGnVI6nVb1v0f6uldvypae16GHtVo/JZeh8CHDvEjm46rQ4LP7bGk1D27Sz7NonuWVLA4az7KlSPBV+9Zd9Tx8CEzQaxE20P3RPoxFfcQ7oXDtzuu/8fJaO9O//ZfqpwLUMgzzJH2XLcIkiHtdGva69tQkI7r0qoh62/T2DEYyNqCtZEPGHbfHtNZxu/FkEMgylq33Hed8gPsjhG8YRLj8S6T8x56WhumpmxHnx5GCEFCtN4tLoE
 sN8KOe7X
 jQdDiogMtq4dFFJxwVI5A0BJAjmEhztI4l/VroA7F82m5jJnqFP/Poyf8yJsMTR0LzgFQhGwX3gSnaID15jc78CrCRzaEhP7dXKyTM9ykL2otBj4JOnlgBepheDvcquIudbGT7ZxGcDrXf0PGfEHIUn0c3w5rqSvHPKL7IkF9WS+iP3IO2nc2IOwGKFAfgWZHsmPvtUX+eX7IThuq3axZS31+tG+bu+kmBSmzjDkohwDoLT6HTyWuEoTL0am2gNF4COnbO25Ow7E80YhhEOkSSiE4JuOxZrX6O9E+bdHGrhh11YhgTSOtJusfjcjBVgLMV9p8XA2hScZzx3byp5eqfvDryHyPZjm8NJuz1kqnzGKC7g6pyUma8U9QiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 5:14=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 15, 2025 at 06:33:59PM -0500, Pasha Tatashin wrote:
> > From: Pratyush Yadav <ptyadav@amazon.de>
> >
> > shmem_inode_acct_blocks(), shmem_recalc_inode(), and
> > shmem_add_to_page_cache() are used by shmem_alloc_and_add_folio(). This
> > functionality will also be used in the future by Live Update
> > Orchestrator (LUO) to recreate memfd files after a live update.
>
> I'd rephrase this a bit to say that it will be used by memfd integration
> into LUO to emphasize this stays inside mm.

Done

>
> Other than that


>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thank you.

