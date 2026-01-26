Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E523CD19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 18:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D336B0089; Mon, 26 Jan 2026 13:57:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB746B008A; Mon, 26 Jan 2026 13:57:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9D66B008C; Mon, 26 Jan 2026 13:57:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4676B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:57:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDC321608AA
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:57:32 +0000 (UTC)
X-FDA: 84375023544.12.28B9BD6
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id DD6371C0016
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:57:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QrCeF2lv;
	spf=pass (imf18.hostedemail.com: domain of sudipm.mukherjee@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=sudipm.mukherjee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769453851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2Nt6k2L4eZl/SWEw98vmqFsh/LJST5rQhrTBW6429k=;
	b=s/IGIkDsuMWPEOG6NYOXsvPRgFTVu9Xv8G/H1it1CvT3wkzcZtc9ZosLAueD9E5GmwfQGB
	Bz8DSxqbiR3obxfl44TIlodhDXMSewogygKaDfYnW8Opd8w3i5hJBE/80xgKQfXJvuF3/d
	xjmVkKyyerXwoVrvgs86KD/6u4s8a5U=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QrCeF2lv;
	spf=pass (imf18.hostedemail.com: domain of sudipm.mukherjee@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=sudipm.mukherjee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769453851; a=rsa-sha256;
	cv=pass;
	b=GNVxtQTIJs3FI/oYlKwg1lF/WBfN7sEH53NEj7sXkFyUIYdTvztTKfTNT24dU2aSVq7Dhr
	yhwt6FFGhyr34Kv8b4D9cCGJgZV+g+SRQ/Gmh9XONJdSZggkFS2D6BTZX05rk886qpsx0g
	1cVzlKHMO0BsFIbKhDoG1A52eOWXm58=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b872cfd35cfso69121066b.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:57:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769453849; cv=none;
        d=google.com; s=arc-20240605;
        b=T/VF67MHpEstYwAjHjiD8rHYC7aOJvmKijWVdFJLz+T+MChRPO4kzqhx8ELgXdpgDr
         NPrlFHnjyGAScAtPf/NlnCS31Jjew/UJzRc/ZAoz0jFJd8mBXdl2dj6DFp9jkHWb6wJG
         y+/MIL85YwjbLsWTquRwwl7+uxoAIZPz3KoUOl6FPRbVdL2iuLgGdInJ7RRnI5iC61CC
         TUDnD1rlF7AM2bZ8LBFu3egz9srnXWzvUZtRqy3DuKXvk7/MgpfXhZpQuHUlyP28gPnt
         I4KpguGkYgxkwdwdE0x40M5XESrdZy4Aj3AUc1rcRRYmXY6Oc8GBYep1elYZ2Ea4y0kT
         NkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=X2Nt6k2L4eZl/SWEw98vmqFsh/LJST5rQhrTBW6429k=;
        fh=IBfPfWDovVTTveeyU5qbgaarhCZEqIUFAZBCAf7e6bE=;
        b=hXt+ZIKGiOpEuEBxJ49nPnWk68p/1pv3P+n0VfxQHUguZqY50Flf2P7YQZkmf3w/vu
         qw4dCjVaTxHA8Tx2lmMROFoX5pOTh1T/C58A1kPBHxFlS/4nnTf1TFQHgXGQXfcv7J73
         EhmxpxUI5sFfit48MEfb1IgvMxFuaYkETJlNPKQGm1oadzbE9TsRs/plFRAgiLPfduqP
         1j3M9NzbCQD59MWum1njY5CAROJQlB6vcfJqVmW69MPdQkHkV6ww6B3em5poqlUq3S2D
         klZNHlf15KH6rTzWUgXETFxr+K6fenZCeXQ5srw1fPlGXchQ5NOp12hhPjITkC/BckzQ
         JFfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769453849; x=1770058649; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X2Nt6k2L4eZl/SWEw98vmqFsh/LJST5rQhrTBW6429k=;
        b=QrCeF2lvSXMtz/SFuF4Lmr+rwMYcqhF2x5BpVakwnccG5sS8NGZzsteiJdz2lr3eOX
         r2EY8xJ61pOe0sPjib5jEyvaQoWq30TO/35mku1033cqDc28rBIbCuyyMryvCvajrgn6
         E5G7isR6lvqulYydf456vYZouRY13CKqFH4piQLfNqRRC05u6eP7usuwxrOvCpX14wP2
         CDi72EtW1k2hx80LnPC9ZCysnZaq8fAaD13ReRq83PVf9NSJt+2PTeUMVPuyHqk271ya
         48K7CnOCsMg+BDaudZ5aeVu4CtYRBJW1EyRCEVPAWvwIKIw73GcxzrXhc9NpZ+5k4rnK
         sG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769453849; x=1770058649;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2Nt6k2L4eZl/SWEw98vmqFsh/LJST5rQhrTBW6429k=;
        b=xGYn0C1JIfXwwI8khW5vyz/6Sh9kITPpOMoe+iMzPGdZdWjsE7PX9TSk7rI8j32wGA
         LVqZFSgh5IV4Y+vnoVUTkAXqGs2j1PfQ7QkHJ4CMYO9ArdKcqAC5Y0WGV7VoRhK8QMY4
         jy9JZbR717SyeG+tErLhpSmbFYU2CMvhQ/q/F0dW4fW32uVvjZvwKS6iBzpRdli5Yr8B
         rkRlm2Lz274otbh6uqGO6x4xu0/UpyuPW//1OBB45J+PwieNseR9FejB5kK9FV9AhOkT
         T2GfeF2dEW7EhB1GHZ0GVwi96sZWANXAw/wIJlDw6Ef0sGbCjz4puqEQ6p4vsPIcm2Xg
         CDvw==
X-Forwarded-Encrypted: i=1; AJvYcCU99dpq+ZdyVQi9LpFwOhbviXzn6qC2b5MGUVsCXyme8svLEaO2z6tM/AytMg5xIsQe0Gy8hxJROw==@kvack.org
X-Gm-Message-State: AOJu0YzNLFzpCMTW1lJHzaJsRr3tICJy0o/1ShDlhKAP8iBXA16s044B
	1jUj/4cv0OkSJzmG+wbKesT9T1dM/K+csLYU+clbHVjtriAmPd5Hjw3t4BeCe6t+wVIEf2YyjbE
	j9ZoZZ0I0g2uJQh/1pOqnMGKX2+GrPiQ=
X-Gm-Gg: AZuq6aJZYrqvKHexQou0tEKTO11sIFp3vpSJ2g7BT1qY4zSpCYfKqZWIBbIwPnsexpW
	DBvMnslI7J2tgXeJOcoOMIgOYtKoWzZz9k/PwoaR+CcgcrVfOCG3iKjQ+7bokKmuFRrtdqu8Z8F
	u9SasZ4M/tPlTMIbxgtz+mWjv1r4g6n25Jyl8ILrLvDnCz/SRGuZ8rpCl+YWAwYdPDuJ7sydJYv
	GQiyQHJDkwO2KIF2JpfRXN6E/9DW4n3DXo58PstYtKIeLW+xsRCMw0UIcpqGmh85AtlIVA=
X-Received: by 2002:a17:907:7fa6:b0:b8a:f365:f2f4 with SMTP id
 a640c23a62f3a-b8d20b42330mr228465366b.0.1769453849055; Mon, 26 Jan 2026
 10:57:29 -0800 (PST)
MIME-Version: 1.0
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de>
 <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de> <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
 <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de> <aVgjpWaIRkerdgCa@eldamar.lan>
 <49cdd663-bcbd-48b4-ac38-77ce94ef0c8d@molgen.mpg.de> <aVj-mz8vaw53TWtX@debian>
 <aXHeLGr1n-W-Ay44@eldamar.lan>
In-Reply-To: <aXHeLGr1n-W-Ay44@eldamar.lan>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Mon, 26 Jan 2026 18:56:52 +0000
X-Gm-Features: AZwV_QhUnyzIrspUJHMl5wxPaQZIKc2UPXxov3UABxIDoJiLKH6ZmgxeZIssq8Y
Message-ID: <CADVatmNzTyUAr8UBvm6pHFsKz8xZpqUXh5NQR641JXsCWaPg8g@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, 
	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, regressions@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Hans de Goede <hansg@kernel.org>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Giuseppe Sacco <eppesuig@debian.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: fod3kg8r7ex1p4g9brn68yymfh4ox3ws
X-Rspamd-Queue-Id: DD6371C0016
X-Rspam-User: 
X-HE-Tag: 1769453850-649148
X-HE-Meta: U2FsdGVkX18EiNBBkwMyL3vyIbKh35nrI8PRnprLcQfP0NjCWTbxIl7TnlXX0PD4Bwb0ufauWWpUP1DIwE1AyZH+loF2cW7hugUHI12vXxvk2OM4s8DoPengqES3BEXoAr63ZOK1RNY0Fh1ILSfqtnQO1k4vod+Lnay4je6AeyI6KQ5WkRzw4eL+oHZWtdoWj36yfp+SCwC395sj5aBlbDCtJW09Bh64Arjs4Fm3uXKiuGXbeLu8DOGPHR0vDEaHwOeeSFB8U7fZDHesbqUqbUgkhql9gl7ZcixXwbdq/zK5xoe5++vRlS+LN6Xfh+ScXTA7QX2fUPj0Nz34gzIWu8pro1EiRun42J3Nxb1ktKgPl0AGyLtF3A/xOf4ccY3y2b78iFqE9vs1SnKWRJFRo6RFm1nC6D/hfyXNJ76JgYfUJFFcmHdio4yjKgFcgsBbwZaCWQrBFegkyYQMn6WnjW38UTXrml4B1eKajqjNzrodo8QwFLvWnV0G9crte1pzJngXv0afJ9DPt74Yg8f5W253iNricLIWtX8RektE+s5d9Wj00LSXTH+VXp2v2iYVe0YYd1Iiu68U2lLx1c/5Jbw9/M4q6aKFJbl3HarloeOSuumW0Zh8iTuHCw1T5nHy5pEA/lRJdeoCpopjQmUWaj4qqjK3qEcJy4mEc5gFrYm87XXlF56b35Ky3aARGKTXXhNQUwFM3FKLZPges6zqVrIE+IMerU0vwMjSigDAqVgqDOYaoLoF7xMDcIxo7+8xyW/dDkjV53edvTrVma6TB1YVdJHdEJqhY6MrboQQWKuTO5Koxb96D0NvIkmdDJV+g+yZYfTbEXgQ2Ugq3kweU5p6htFpYPJwrDizrtlgIGrjRaPH4e12JuiYXaKRgwEk0RcvE5OihAC9UEzmfrY2UybiSGQRYEJ8Lu1ACLHEY28RdvKQXfwaLnTjt5CFbHcll1izaEn25P8wumXf9e3
 FSGvnGjh
 x7yeoZ9bzG60lDJvH953Yu9qu3xup9AB36/EZHMB1vGB17YR2tfklxQk0+Sf0MphyTCXuJtbjYtiMYkVLKZ10h0xWw+ia1yOZEzxkqPXnhqpK0HbI7wwOHoz1aPw1ioKWELkTALMRJKc/oVxYBO2aBqlq3A+4TqzGe6YeiNOM6MxO6hX3eYCMsqqvE9jSjZlXbCSjFkmQNJ0mhLdrnsF1y65D/WgLRQ19cIAdXH6qFh8GNQGeY9GqI4jXF12gbuvHmBUaUf7nj76zkZqczozJxpqYMMmRt3rQzsWcRgiJupxwAtONUWTBSwsOT5rafs5lxqHXBjamfW/+9BdsgH7g1uUWbAA9rMSnG6DXl+5f0sMc41v5GtttuXwGjugXz6G+Q+N6js2erlgubdS3l4E2qD7jR3RjMDBZ0y74Kd32nKmeOGJmc+r0NI3/U6O+RxeNPgfnyZFxDVLSph0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Salvatore,

On Thu, 22 Jan 2026 at 09:59, Salvatore Bonaccorso <carnil@debian.org> wrote:
>
> Hi Sudip,
>
> On Sat, Jan 03, 2026 at 11:33:47AM +0000, Sudip Mukherjee wrote:
> > On Sat, Jan 03, 2026 at 12:01:19PM +0600, Paul Menzel wrote:
> > > Dear Salvatore,
> > >
> > >
> > > Thank you for the follow-up.
> > >
<snip>
>
> We had another report (https://bugs.debian.org/1126128_ but the
> problem remains here as well the reproducibilty. Uppon several reboots
> only the first one so far showed the problem and was not reproducible
> afterwards.

I was going to post the patch today but since you have asked the
reporter of the last bug to test it so lets wait for few more days.

About the problem showing on the first boot, does that mean that its
only seen on a cold boot ? and not seen on reboots (reboots without
power cycle) ?
Can it be reproduced if the system is powered-off and then powering it on ?


-- 
Regards
Sudip

