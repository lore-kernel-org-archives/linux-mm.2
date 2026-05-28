Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A4DCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846D96B009F; Thu, 28 May 2026 17:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6C96B00A0; Thu, 28 May 2026 17:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6722D6B00A1; Thu, 28 May 2026 17:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 527D26B009F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:42:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC4DE140950
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:42:35 +0000 (UTC)
X-FDA: 84818153070.16.FEACA00
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id DF39C1C0003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:42:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V002e94e;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780004554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9q/ZTSfTHT3ONJVmwny5oeOHsuAhfuQbux3JGsklk0A=;
	b=g+Jo1RhzO7us4KcUZBkNqCSonYwJbcGQ3bfAs1cc2v4mcEj5vvucdyJc41LHah/MusAH4P
	86hvyWV4b/LK0gAtanEftyNno+GD9cfK0fpWXWM/Q9Th0DI6x9GBk0YggH9Bk9z0I3w7D/
	3qEip5Kcr9MBlt4WRIhqIAF8L4pGZts=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V002e94e;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780004554; a=rsa-sha256;
	cv=pass;
	b=QWzfnSw3MsDRNTshRCC0bbl0SV658SS8IeA9RhB251YpFdhygUXMWSDrtZ8moO8UOSs2ON
	EnF7/vNq0TJDqvxyN9jXlofbzF8QDFgIuABQu37bJ5ZIK74N5iGPGPtxcMm4c/hE7BfgOI
	UZrt0gO5K4+T15Qgf5H08Mt0/E11nH4=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-392445f11c5so136803401fa.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 14:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780004552; cv=none;
        d=google.com; s=arc-20240605;
        b=hSUS1r1O9FBUFsA4SaZhCSFEZCgfFBERyVRYqaLExfiXX+6rNRL2kXWHj9xps0NnqI
         A4WXoU7fF5Iku3rVPmYSPP2gN3J4FdKrLb/eyk+amWO9g14y1PvyQrhK1NOfC3PXSxlG
         cYiMkJ6WdPDHRZd+nCxI0dOBJBB51viBKgPzAfUSQDVWksfMndPrKHAkAhOdMo3Kjk5J
         tHkmx72HATzwhvoxVhFQ5Iv6M7vvFA4d0EzGwrA8eAgLNc05e80eSL2ueyCWzYygk3Bp
         fuHJjpjdohUFuUjeQYVPzujpj+n/iU8643VjS6Oor4rCpuZTBox075N5dzW7uKGtoLii
         i2Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9q/ZTSfTHT3ONJVmwny5oeOHsuAhfuQbux3JGsklk0A=;
        fh=i2zXgSwJcGBAFGBI72IsqRQ+5qJqJAI/9kEPfmiYG+Y=;
        b=WjQmiUnd4e4I/uChe3RQWpAd/OBG0l2fGwsnNKDMrNiaBdf7ntBDxuprexto4qt0hP
         H/+ZFPN8sKgZI+CwgWZZejy1DFJAqE4asc3qNplqcLRAahg+wq/vRJGcapvAKgO07DJa
         szgjpKBG4Gc+N0NqwalrmsHffjqVf0s4T8GI/HSN5Zoaqe1CZlQfJNTGlWrdQvd6BpAi
         GnK8U+KQ3l02X3h+V80pWCqKwgPrMl7nRUiyrJjtkPBnEZfAG39+YeC74GYmLWdTWXMx
         +PRtYuWGtedqyc+el4dfHeuJUSHH0RsM4xC8niABAw1sJqp/X4wzMPymP4MHu1+S7PN3
         5C8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780004552; x=1780609352; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9q/ZTSfTHT3ONJVmwny5oeOHsuAhfuQbux3JGsklk0A=;
        b=V002e94etyFFfUnibKn4nK2rNhzpZUGmFlq9KA1/BirVDA53r3Hj9TfX2OW06Tedp0
         qbzQS8yIo2KjwfAiHddDvDp2OkstoUZRlw1C4QvIOUzTh79b1LjyZO0jFby6UaDXxnH2
         5HQwSt/UB1VZ89GYQZBeS2tn95XP1PPws9+Vm013uaM4KcEa+aUkprUqjMCimjiOPqfN
         Du6AGUhKOS+4pdhEsbhRgapVOcoR9fMxgsBRlLGk+ewdNwKIqSivCEjkJBy4CwXf1/Rl
         3re7eIYUYI2pPNNkBsfUGux6lIwFQsn2b8KdB7j9yFQBW12PPVFj7xEjhGSUpCbn04Yb
         PSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780004552; x=1780609352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9q/ZTSfTHT3ONJVmwny5oeOHsuAhfuQbux3JGsklk0A=;
        b=G7XOsdMKpgJ10TQ2nJZ3t3u1DRHyfTJ0H1ZKlPTxI4Ckgi0re2GVNKJnoa+J9HbMxu
         /vtbDlhGSDDzsBqOLkW+bdCtPnDzM/XWHXbl10dJD4mWf6DbXLeRg57EAFTtHYCoxe8z
         hNYxz2rD9KMEndklLOPp7/yYViI/wxpZj+qZWGYWSATPiNqAQND717vy5IDs+p9GVPmO
         JwSVTh4qnkLXcsLqBx/H97nQ5YH9MPuYBM/y5WBIopI0/y/Pt48b5dCgw29qhRyj/Y6Z
         qAXHq0I7om4siNYaiiBMikY5IPyRdxs2ITONzLGaq/Z0UsIQCIIcp0kvYq+T8QlDk9L4
         c9Cg==
X-Forwarded-Encrypted: i=1; AFNElJ9OCso+4aMcshsge9vd4GMU4HndYwevHYwqSyunY/mSdu3zuiFkZ6BMHBIMDzBb6qI+gmqYjhIoJw==@kvack.org
X-Gm-Message-State: AOJu0YxzxH1bcvT8CKDyP4EtX4yDaT2XJaOYulapPHMNt7ZTnJ0eypdR
	ZO1799ilkIjzniyP2PZ4q8jvgGT9+EIKtdvjUkm8j3eyWCPcSQtTONnUxdz82NkUVs7qEyHL14v
	lp6cFgoxIlshcjEUU6NAYKi93+auSPCY=
X-Gm-Gg: Acq92OFNYAC3Ih1HgOVvEYX3CK2/Ruo9jLencpkE0y02OFqaPNohY0S0sz2SRivkbCG
	0hhYrnEykVx3EQ515m+I43o3nTAcYemM2QNFM17AcD1Gu/tyqvcxEUpRPdUedhjRd7ioP9K4LJd
	Xh2cuIAaIfDERAGyiBjXHB9GCB94h8zZeQYFG+KCHzj5iAZ70kclErxoKMAzj/Lz4S7S/3Ugd6q
	4xf8eylFwYVi1rqlq04i1iUVQ8P5+obiupE17qqPFxF6TxHwgbpQ7xVjDcV5PljpZkcRRKZYBTg
	3t9PxG4Ix6hQI9xDgrfsyYZHFTjb6JICE0OLzvjQiDX3/mi1ow==
X-Received: by 2002:a2e:a695:0:b0:38a:2a56:9546 with SMTP id
 38308e7fff4ca-396536f3de0mr174701fa.13.1780004551665; Thu, 28 May 2026
 14:42:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260505153854.1612033-1-nphamcs@gmail.com> <20260505153854.1612033-2-nphamcs@gmail.com>
 <agJcCZuLqWwU_sSR@google.com>
In-Reply-To: <agJcCZuLqWwU_sSR@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 28 May 2026 14:42:19 -0700
X-Gm-Features: AVHnY4IQjMrNxr5cCHgyMIwBGAESeNQ717suquaX-CqDf9_dL7Z_N08muuwMcik
Message-ID: <CAKEwX=PZnKqfriUsPV2whZyqxfCRNy67z7gyrHObEvztDF0_zg@mail.gmail.com>
Subject: Re: [PATCH v6 01/22] mm/swap: decouple swap cache from physical swap infrastructure
To: Yosry Ahmed <yosry@kernel.org>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ytq6cwq4cbx6194uasixg5nt86babdcu
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF39C1C0003
X-Rspam-User: 
X-HE-Tag: 1780004553-33903
X-HE-Meta: U2FsdGVkX1+PtiHF0ah1LDRXv9ZwBqLqKPVj4FOB0iBN7qRLfBHq0bgg7u/tfc8VtFjDOimIjHWc0LPcy/Kor1t3Jb8xWYQGBJw2l/xnG+ZxSasynspiyIZrT2e4SaXjOG7BuG9hd3l/l8E48I53GkT28KwokPRbPkEkO8dAvLh5qzBOeEHxX8cmHmhWUufIHbJpz0na4y2Ee0hMiPk6N9lB0GRnVj7Pc/5NbpES09kb/zJoE/3OLXioVo+1AruxHg0sP2rIT2Kf36fosBjeu3sA+JnXPudfcu7mol4nx98/OkLkJbhV/nis0vrdFCJUcpdFDvGRQz0UEzK17JAkjeHPDBbNFX97WcsEl1NMm/kPSSkv7Cils0uBiIdU3m/kXGpylVbDHd5domCDR/lZ+cXSfl+kmPaAgwM1y2XbXwejh9ijkYfK+GdqdX7YwYdbFu3ur174mBGTzpqSLcOwhCLkKhngku1E3fWs0DbUghRZfgy/0X1iqXs2Uji6B+1rKlhYZhRLZ2y8NB/kEau7BmxgeK+fWiDTNLHm441XpM1SmwHlDK+k0mywtZNfVVZLawrpgVNgrWYBS83FxCcChujn+Z5tLH7Il9hnyJOnQRxi0B30t7aNWNtZMFgZn4GYtwkfE7QSteLimf91oVleXKmno9ff0jOQG3QCjTtJ3iVjTVW0W5WAiiRBigiB2OhpQZr6TN5WoxwXlxmY3gY6ay6+Q8fUYJr0usPbnTvl4JYxag7pyf76pE09Nq/DV8bzYb/igfJfU35nmfCVHcl/ysYjduCWoiZxWoRZJ8JPY7By0BtKyOVEAYRK9Qr5JL86C059n2SdgTADebPzOZY7+AhBpLaR2Gaz1r58VbbOSRX7Bl/4+Qe988TYhcT8BrvDyF70OD4IhTqceNhBLph6Kxg67wIesj8HK7xsxvue3mRj1a50gf9+rBsIzjxpYfFt3BZDbysLb0osuKmb5Be
 TiCRMc1h
 hhh6F7gNns+GVW4jkBztVZO/ekUqgRYX1qKJlrBY/y03XZYmUsItV09x799ARxednjGN+oemje0maPeJ7hyx+OjNp0oVMRD71Td+prYDPdETtEcict0r27fz48Y2ObVYJ831lCjCDwxQwQFsWa38c5KDiPBF+WOp+uMxllYBtVqZoyh7pmqXjFMCpsQhRXjX7SDgLkHLL7+F7oCnWRnog5ihGmNc02vdk7UclnkdRRQESJ2p9mfJap0KzsDtQwN6NU5r9JArLp4vv33eJBdebKoew1I3IJMOkirvr5rkWYXVjUsZLhe0CM8KNDLPuQpe4ZiUQgMy7nQfSlOudwkJf8vRHP7BW8u4Dl8u+ewkSA2itt3K7PWa1cjUJbipHC65JOw8ZcO+M0L4AMpYpq4Pu4XLuT8EXjNgM84Ru5N1WgD8GRRv8pTFlq2So8A0OWy5aAR9mSYaehSkoaIWpCU8w86AAb17S9MtYdAG+6GH9z08cyCO713tJbjC0qs/ReyQilleOXRb+lEXOo5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 3:46=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, May 05, 2026 at 08:38:30AM -0700, Nhat Pham wrote:
> > When we virtualize the swap space, we will manage swap cache at the
> > virtual swap layer. To prepare for this, decouple swap cache from
> > physical swap infrastructure.
> >
> > We will also remove all the swap cache related helpers of swap table. W=
e
> > will keep the rest of the swap table infrastructure, which will be
> > repurposed to serve as the rmap (physical -> virtual swap mapping)
> > later.
>
> I didn't look through the entire series, but let me ask the same
> high-level question I asked before. Instead of moving things out of the
> swap table, why not reuse the swap table as the representation of the
> virtual swap space? Seems like most/all metadata is already moved there
> in a nice concise format.

The honest answer is I wasn't sure it would work, so I was hacking
quietly a prototype on my own time :)

I finally got something that survives stress-ng and constant
memory.reclaim thrown at it though. I figured I should send it out to
get feedback before digging myself deeper into that hole:

https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/

There is still a small problem left (the metadata duplication issue
that Johannes brought up). It is potentially fixable, but I haven't
actually tried it out yet, so I don't want to overstate here. But take
a look at it and let me know how you feel about this alternative
approach!

