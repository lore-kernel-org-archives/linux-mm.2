Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327CFFD8763
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 13:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3216B0088; Tue, 17 Mar 2026 09:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753CF6B0089; Tue, 17 Mar 2026 09:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6429F6B008A; Tue, 17 Mar 2026 09:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5507A6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:04:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3561160157
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:04:33 +0000 (UTC)
X-FDA: 84555574026.05.AC062E7
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id C881A100003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:04:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AyZSetfk;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773752672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysuLlj+wUK3hDLUIv/hpeGMF0lK81wTkavGvi0NT4w8=;
	b=j56ZhK5SYCAvKuiEQb31jJHkZqZog7vMWuK3s01EFLSD9TUhRhLEdrjL6p1ZVQAeOPSK+F
	+tSsyggt1NHCXYcj+iqkUV1qFl3EErwlNPPaUUfkOojRHU1Bm0MiUm1YjDA2LKhHOwoDez
	SmjzrMWtxy7MARR8ESEQMpyLoti6TnY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773752672; a=rsa-sha256;
	cv=pass;
	b=VX5ilQwvBOUlm3caXgNgdGaJhT3rICzP0+deqQ+n3nOqBgiosn3Bfjq/YWCtmtFAxWRs4d
	8+xMdlxyX2wxrZkf4zovcA6401Eleb4qGXe+7HfiMgPaOzMwyJ53l73y76VDCSkXAw8EMB
	rPT6PfA4xa1p8zTfbGj4Bnx5VYtuViY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AyZSetfk;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6631e0edcf1so8109373a12.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:04:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773752670; cv=none;
        d=google.com; s=arc-20240605;
        b=iOTU4mMrK/H5fzM4/dQ+4numBDCaQbEtebzA6BjbdbGK5q8X3NKhEXgbW44nuyTFP+
         vRY3yUJbQ2Dgrr4iWZOw1R+jJNWSRE9a4zd/iWIlZ7LJ8VnQpqYnzHl6c5wzrp/l5fvN
         sgfw6FRmo9BbILnRQoyhhgca24vfboxn5+NSmCly9gfTlmDl2/N7wMeAz6a0/lObatlD
         OvP+O7/XoEnbvkgZNLhtgdrQlB4iaRt2nUjyu4EfZTqDrN3uVeLA791IaNr3JTJAO06u
         hEfBT85UqpT5AaIV3f5rjaMadJBbaFtYKYmJsk4RZLIEUZEozR/0bz6EwNi5nuORpdFA
         szxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ysuLlj+wUK3hDLUIv/hpeGMF0lK81wTkavGvi0NT4w8=;
        fh=yFbpDCBC5PehKzE7lERK74iQz8htNdh0tXyFWPCP7XM=;
        b=KX/TLUNU9dlbG87yv9n52njzk3sXVySjeBy2tZx42azdd5zI13XEDVE2al8/A1TNLQ
         zJ1PTkrLsRZe+yeMMf7bE+vjnOfQtSASrk9KznDZkvh76okki7L28M0oKACMmZAnHF6h
         yOEiHzY7URMY84E42Svb+OOP4VPM92NSC3VyNfpiVq3CujFIBXVDLqHHCYfAx3mxTk/4
         Taepq/khTkJok5mTdukTWngdHe1NPaGaM+WUErOzsmKCXHg5F6yrmMkbiwt405JvIGyQ
         FXNX7Gh7rPm8CPqXREkTaOng2VW9kPdcJnEmOkSyVmcLoetu+CpssShqnbC7fCwvlPrR
         w+MA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773752670; x=1774357470; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysuLlj+wUK3hDLUIv/hpeGMF0lK81wTkavGvi0NT4w8=;
        b=AyZSetfk0P7xvU4NuLztxqUNL6dgmLSKPdIAxDhV17UAw/Or7fO6cKho86K27+ArWY
         uPYYnJu475O+iukzwhsFahNyUy8ysbKuWtJ9q4JWrKQzk90NDhDQWazPDoD/ytuyw5le
         5i/VP/YtSovAHhjqNyH/pOiQRwn3B9rkC19CdJlFyoXMnj8IG1XXW/QPV3pK4aHcs08U
         5Iu0n0K7WItN7ko39aapKNDo3FbD+zZC2WG4b32XG4p+FCGqVG0kxGtABiSt/YRxiZbr
         Nq36q4Vo5cw3o3zv1CrvPL/1gKbilZ8ZqoP4r51lFY6Ka9Vu+emaqTtzutYNxRYuaI5b
         C+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773752670; x=1774357470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ysuLlj+wUK3hDLUIv/hpeGMF0lK81wTkavGvi0NT4w8=;
        b=nA9RnMYvHyFylR5WG3cB0imEIkPCktyHZ63pAtwLxQU5CmnGtbwAB7fzSDR51znxnF
         K3OBXZyOq2Dkx8+4d8TXUIfrA9IUQacOkJXywGZiUTw6sD8o7yXVJnK9Adp4IgkTAZ2a
         Ravcf1RQvWjnxwW3Zql/4ZiBQisao55M1OaXJk44lWhlhLWRsXoKMvyHsA29kwz8FHXF
         h4hrQjecLcAI+V3ZGzAkcPHpQXOLMdM9MA8DObYCN+B/FxQyhxExvaVtrsimTyIeklB0
         jawmL/xxcyXGucxznKX4H6fqvNx2t8ppZFdQOEG1oGG83ALNMPEONFHYDlEr1NH8bwyl
         Pd6w==
X-Forwarded-Encrypted: i=1; AJvYcCWveXLETTZi4IHooEIJUcOE63ppMqCbo5XG3wPtr4y5Mo7cOKzUEbZnyOXUmg7g9S9nqD5Nseb6rg==@kvack.org
X-Gm-Message-State: AOJu0YyW7tcQxxSElU5MQFWNncaB9tyGCcznCPZz/7g0iLXQwSZ0z9BM
	6KFJvWBYU6r/hit2GLKOvu9RZ+wKuhgc8ofnj0L34XpB1fspmdL21ldhW/sH6RfnqxZ0MHng9OZ
	ez+MyXMFHwhzM2KjhET9HbkSbvnBmcBwuk8Kg4QIJAA==
X-Gm-Gg: ATEYQzyghP7mHX+TRP7NbTNqqeYyHHk+98dIeiFBq/yW7N/OWEmQoYnMDNvfEdG7nLC
	xBnwG+rfXSTHMLqEKl52JJne9ZFe5G20rBaFB4ThjwsRQQermJA+/bHxkERAM9+4p/tKCXYnOwW
	ZVRwICcWIJMzBA9CjqZWaHBZIQny1itBlyL6BP16cblajVKq/mbuJJbxQfF2oYO3PcMWGnUkIJf
	IyejgURTNHn8gBG5puFyAgb/qI/umpijAlWbHPhtPChJbDdv2BhipUtHM/OUcuWjJDuwDmK1wmh
	fvPnSJ8qdt0uupBUmEL1+EnXEjrgX6g65ZR+3w==
X-Received: by 2002:a05:6402:f01:b0:658:d1b0:9970 with SMTP id
 4fb4d7f45d1cf-663ba0ffedemr7428895a12.5.1773752669881; Tue, 17 Mar 2026
 06:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260317025049.494931-6-pasha.tatashin@soleen.com> <202603171111.YBKWkKnp-lkp@intel.com>
In-Reply-To: <202603171111.YBKWkKnp-lkp@intel.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 17 Mar 2026 09:03:52 -0400
X-Gm-Features: AaiRm53BOiJuI_VHcpORXajPgafrQwkAny2SxrdtOShKer-_ZbanQn5yTzxfajY
Message-ID: <CA+CK2bALxiExWL3LuF_+fhctKGYmdBQejjFiw09jFiV1UtPZ3A@mail.gmail.com>
Subject: Re: [PATCH 5/6] liveupdate: Make unregister functions return void
To: kernel test robot <lkp@intel.com>
Cc: rppt@kernel.org, pratyush@kernel.org, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C881A100003
X-Stat-Signature: y4kbdghonz9snuyino6xudxaa888cjjm
X-HE-Tag: 1773752671-106435
X-HE-Meta: U2FsdGVkX18l/X5rkp6hdHxMlTdOgWKRrfuoinKINGue4akzErDDvld8hKcMsMlP7yu4KSaHG89XcINwwqsAS0NLAC/9g8tc5iEzEfZ7XwzMZlYAstrle43slXfuc36oNbzMBnEHZUr4njoowc58PHdB8WRTNS1i8XBN3eCunwDPtYkcr8QEeAmkRJ6tuLTZ7zFjkkO+wrhO7ozjzWH6K8BT1SxeY0KOUHM11cnhvdYdm2c/qEFBlhLJ8vf31CisZAaKJp/bDhmuliv5PDnlHbw0okU/BZEuhhUFknNstKe3EMKlJ4+p2f9hfy8/VdGeHBdA1ZXXVeNWxZktCa2/UkmNUNgLXRsIbLEiQKG6PoDKQeHgxHcq2epGNzzN39mRj9Ednu5CmavzbARfDaMUVYtB+1PYMmVeZ9Tm9Y9koAitcZyUuHo4LBAevcwcSBKDqSwtq2y3HQbzJx1DxWFjX7CjpJvhIkwy8MwM0YI2QjP7MFbzoiVhkOHfFiiIyAvziELuQJOCeuAUSLfEkfIfFEcFFWXefWbCVA1Lw7ZdHBMdL12JwlKhv7S3Eu8Umj237XzIjCWAOGO4LWdW1nj/mDjfMEsh+X3Jzv3Sz7arNYS+RkUxlD3e6BfbPE+lipApEXGIMhxZqqRJMhjUH12qC1SDcb+iv+/XAXsJQy4Lw7Y496VGd9BzP36OYXgvNmkC5ZLufs0us/VCpXzu1x7PxtjZyOvxcc6zrfFIi93vbYgtoGxDFwfOLCOHjeeBc/oytG3LIU0CEqBpYjanYtqddPwlwQ/AJykPfAor3URY7gb8FHyljU8wP5W9xBApRb5VGsrgB1L5Yuy3BtKONRKfyA3kG1cTWitLCykmQfiX5Awf2mjUFTNnSd7kzogPcNAuuPMT7VZPhGv2xL0W3yc+nNu8hLKE0E2Lm6BxvKo2mmvf7xOaM3I37WqrgQBSm/qhM0TvCHznIdAgRB+sjU/
 jxhF+RTr
 898PyJV8naWYfu5SiJ0hyXSche0w+V1uEqo9pnJNqcrVII6qQgP25AVZm5cRc+f9ddDO356nr5fXBhpVtfg8XBw5Phpd3bXZaPOAUAZfP2cavGeq09KI36U3VY3BOCmKGEE2I/QSS+Qp0iXuKm0haqXe8zyVWtK2qtFPB1u9Cq8KNwa+t0nt+K2AfCaKE/p2ZVy2JpcOfhlukvx6TeH1vvtDZFmGViPhodvmF52fkde0arf5FOkMDcH+62YsQr4P6hFBYuQQRhn6WgTdO4jMPsL5RnzExHfsejUzXhKKA/irxS+ou7m5jq9gRPN28e3pxTDqgx431aVifY9zvgJNQsTXsLWFnGcZNDThyDUP6OfNTDP3Q5J6K0JYVI/6JZGL4ef/SNdxtJz9EopWXYdviU4fjYqLhiofGRf7kz6nYXusscawtybTqN5NqiJr5pM5ntkhecNv5FNEh7dfAQIFpo4uCwiAKx0vwMirXsvDwzfmbjSW2XT3NRFqUqC9ibqC0yiK3pA5498UzlPKCB3zapSoJBwNLAiJBJ799okcOqnoXt88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 6:11=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Pasha,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-nonmm-unstable]
> [also build test WARNING on akpm-mm/mm-everything linus/master v7.0-rc4 n=
ext-20260316]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Pasha-Tatashin/liv=
eupdate-Protect-file-handler-list-with-rwsem/20260317-105522
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-no=
nmm-unstable
> patch link:    https://lore.kernel.org/r/20260317025049.494931-6-pasha.ta=
tashin%40soleen.com
> patch subject: [PATCH 5/6] liveupdate: Make unregister functions return v=
oid
> config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260317/20=
2603171111.YBKWkKnp-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0=
227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260317/202603171111.YBKWkKnp-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603171111.YBKWkKnp-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    In file included from kernel/kexec_core.c:18:
> >> include/linux/liveupdate.h:274:2: warning: void function 'liveupdate_u=
nregister_flb' should not return a value [-Wreturn-mismatch]
>      274 |         return -EOPNOTSUPP;
>          |         ^      ~~~~~~~~~~~
>    1 warning generated.

Ah, forgot to update these. Will send v2 soon.

Pasha

>
>
> vim +/liveupdate_unregister_flb +274 include/linux/liveupdate.h
>
> cab056f2aae725 Pasha Tatashin 2025-12-18  270
> e62bd1ab0687a1 Pasha Tatashin 2026-03-16  271  static inline void liveupd=
ate_unregister_flb(struct liveupdate_file_handler *fh,
> cab056f2aae725 Pasha Tatashin 2025-12-18  272                            =
            struct liveupdate_flb *flb)
> cab056f2aae725 Pasha Tatashin 2025-12-18  273  {
> cab056f2aae725 Pasha Tatashin 2025-12-18 @274   return -EOPNOTSUPP;
> cab056f2aae725 Pasha Tatashin 2025-12-18  275  }
> cab056f2aae725 Pasha Tatashin 2025-12-18  276
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

