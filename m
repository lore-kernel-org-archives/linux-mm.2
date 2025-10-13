Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84973CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 06:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624EC8E0003; Mon, 13 Oct 2025 02:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC6B8E0002; Mon, 13 Oct 2025 02:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5392E8E0003; Mon, 13 Oct 2025 02:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 425478E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:09:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78BAD863E6
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:09:31 +0000 (UTC)
X-FDA: 83992064142.16.E72CE2B
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id B3B2640008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:09:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bZx7JAt+;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760335769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h08dvo8pmGBC5yxJSI174655XZ2nrSROFfs7bn6SAhk=;
	b=wufuzkj0icVgYiOlMc6ixWOvgoPMGwAfKFb6Roqe6IKifVpFWdzFU+vWLqjhr6EiUsN8nR
	ug90T06WvlAxYQZdF2oYlFauKilxWaA06LGYrkEBw8skLDJ9vemduiivvBE5z8ccwvzEtf
	koOpkKZM593QVy1hYxhvmoww+1oxFzI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bZx7JAt+;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760335769; a=rsa-sha256;
	cv=none;
	b=UIVesEX4dMrWHauwBdA38QH8weRHDjtK07mZMWfV5oe0DU4eQtR+F78g27ZutAGffeHw+a
	QQX/gR8b3wRR6ms1T2grXBNn7Rn21jhvLAlegG6SQMrHBYbsB4PAZPNmvOe0Ay8GUm6qj5
	qaQoXlTypg5klmPJaoTyuZ/hzBc7TYU=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-855733c47baso745270885a.0
        for <linux-mm@kvack.org>; Sun, 12 Oct 2025 23:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760335769; x=1760940569; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h08dvo8pmGBC5yxJSI174655XZ2nrSROFfs7bn6SAhk=;
        b=bZx7JAt+IDPaMrmSz6yqNNmNEoIvlQrXwcrCr1Cfo2JWF6vU1aGaVia3uCyiXWrxJ/
         9XMFiMMPXspWHEFFlEPOwEaCgl/HNlatv9w4NdQtnKpMu4X2/xvWmHezihZSlu+kv0l1
         haM307oCqUJDTTGAhFJUW06MCVRdRE3FnWDjgtZ+EtEX/xNqbQDDKqYC0t3laF/0GbbR
         gK7t+ET2WasrnBNRSy6jeDnErM0yzhHqX0fvvB5bYQ8y83VyAzJhrCNcfvotHKXei8qI
         MD+Z2SyR2V5zYN8VqylbrkcnjxR/OYZzMIGWvcjqjarCeH7tk2GC/+EiRfOectkA+rhb
         OFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760335769; x=1760940569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h08dvo8pmGBC5yxJSI174655XZ2nrSROFfs7bn6SAhk=;
        b=h03LlGztDqmkCUo3qmjGOxcctrR3cSAkKLjMTbYo7tkTRE7gFlATjk5mZT6C3sQge1
         egcppl6+FYwa6ESNj+N0UB8fnlwRO3zyWwxMQwThvxeDDjuRdqQoxhieyTOJ+OddFVfK
         itOCKM/gcRcJuXh6tZouldnvyjUYdqP7ApF2+x+ES5gZEQqlcakpitTAHSU5aBc03Wz+
         DOPqNhTRxw0Nw/a4usFLjuR9UTwi6WS2UTaj4vW0K+hSaU9AUH5hInbvSk71CDwIJJI3
         c2uZ6ovoOksD9OoRR/wPyIYlPFTYgA1+THPaAtgeD7J8dZrmqrRV+M4Ua5Vx8Xfb1LVX
         BARw==
X-Gm-Message-State: AOJu0YwABWVHlrGrIWWuh37mSJpsKJ08164jJdBdxvu9f9JXuZrEMNSB
	gGPQ44jI22eiA9MeXX289/N/inMJQnTQBSn8idrIkWMtaqKx1sCEirkAH4CxIX1nSSZ3B5jjEj9
	JJtnvRJiGCWUu+6rsDatv2j3sF3rqLjs=
X-Gm-Gg: ASbGncvAB53VYcPAKO7cFiyTA8RdVzkp7MHPzG0LRdby8db4dnK9R69gex/x/jdpgJ+
	Pyxs+5FJXIlJWlnSSXYkpr7NiiDKdzsUmm6NcKjPSkoTDc/Q0lpwJBf9xiL8lqy+qwL5hibVZMG
	adAdQBVylZj5S2uNEWCB8Ace87XarcPIFKl9xT0/hbM8A/d9Zu+h8lk5MVZokdkTzOan84mRObA
	PqbPvvXbu14ayv7km97CYAZ8t1sJb5+oyxkhYNLfbLXYusz94kSCftbW+HmzW2MID6tAElFiOlM
	sfc=
X-Google-Smtp-Source: AGHT+IGK6kUSIj141SyOnUNq/Jxe6bA1JVXsDPSfqUWC2b854QU8LWv8Y0yujycD3noFuSD+YB5vdH6syx5pOuVx+XU=
X-Received: by 2002:a05:620a:294c:b0:85b:e8ca:8ad8 with SMTP id
 af79cd13be357-88352f84ac9mr2458294585a.70.1760335768601; Sun, 12 Oct 2025
 23:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-2-bhe@redhat.com>
In-Reply-To: <20251011081624.224202-2-bhe@redhat.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 13 Oct 2025 14:09:17 +0800
X-Gm-Features: AS18NWAj8948aB_MhL5CO9kDMYJam5ed1bptMDX4uv0ZstNvgjmLd726kvSne2I
Message-ID: <CAGsJ_4zvtdqzvBNmQjMy0L6JAz_XpvR=rGgNC_Xdo36QVW-g4g@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3B2640008
X-Stat-Signature: 5pbz6uayfwyo3hbxrn43zxozr669mtby
X-Rspam-User: 
X-HE-Tag: 1760335769-846801
X-HE-Meta: U2FsdGVkX18uo1ABvfmw2lz8EpPFUknMhdgkgnPdzdDriq1fspBPD02+hUaibYeSB27gDLDbL68zYNouh1bP4+E1xLr3VoEYdq7exl8uymenLFpymv1H3MvoRLLQHGNvY8l7omyssVBZ7INj3aO4jQWB4KzFmXefB3751XfKXX8QP/kb5GyUEoHo3LHP7uR/CASYfQnZO0SQDeLhOmcz6VXdXg6u/Gv5nAcpCWfrJPcq8ctaGxzhjIO3Ien2sIxdgrujlEFoXtJYGCa7EKRtXOi7v1fccpX4hFhoF9T9DwALNF+eWU69B5qAdQbNSFMebqvonMlwOXtMVdDm2CWXrXDRcF84mW9S2cVQmnmxRAxbBeXEbbAfUGhV4Dt2pkC5cYqfd6bZC12/jEIFyw3emenwCPA4rJHeSgYTBecavs/JLENMzgiJIyp070AOM/wF8kr0M0MajrsbJDY11lURX+9k62xcZU2YD0i9vnvikLDpEgUeeIB6uziOjKWfuaawrp4O7DQFdt7RjVKBzgppHeokz/r0WENywq+iqysg3f0YCKhGJtjydC6Blz1VLlVpM3BkvBp1VYDnJbKUf8cGAa/MD3LuHFqtqh9ki06AaTTNm4xIWIYC4V8bqoz4nzQLpfWwUUelZKROTYSrXZWWo8aSKgXRq8WPmUEVtNkmn26O6Arh4h+oQ2Of8CFl0S3z6hCQ97NWxkUSz/CuMHvo1R2rOaKpqJSrmvURHBPDQTC9k5tdACyHcEfqed4rxi8V5CEUFrMhtJ4UAQDJgVlmBRIDhvqWLiYybgDVmRAJr0gOSakSD5/umrO3vfW0h54tDFUIoltNGU+Zz6wLj4c9TYDBangMzQw6jmVowublKXF+TPl7k7HYJ//xR4RIJiLDnQy/o8daqke4b6SatWg750r6WLMEGeZcSjpAStSDbk1axGLI5p+yGuZ8jILjqaYuurgmZxH+zhaxFNvXG/e
 Ad4Kwq1w
 w3D7wZ827diy0Le0Sp+OohIqzszov2Xf3HNlfki3l9N7p680/B02Sw22LiHW2Mdx8rvQ85oLvetC6+vmPRBKOGEiDx32dydHFFP1r8V+HE6XFBHWM1pHiveeqMBE42rpHv8nqMoCNqRSa18UMMg6SSPU36J3lZgCsNG9U8CEwIJp2cYN2Sn5RzC0STfLJiucDn087ziXlFKCIAANAmOWLF2bA/NXxZ3QVTz5AtZxZkLwGZdlFchS40JmX+GcX4TyBkhYrixfp/Bh7pyk4ENR0JfxuDSCI/fOxYCJjScmlB7lMCTloAz7NS0h4EP0hEMQhbkQgkDJoEzqm5H0huuTzbSyYPooi1uRQiR6e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -static int swap_node(struct swap_info_struct *si)
> -{
> -       struct block_device *bdev;
> -
> -       if (si->bdev)
> -               bdev =3D si->bdev;
> -       else
> -               bdev =3D si->swap_file->f_inode->i_sb->s_bdev;
> -
> -       return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
> -}
> -

Looking at the code, it seems to have some hardware affinity awareness,
as it uses the swapfile=E2=80=99s bdev=E2=80=99s node_id. Are we regressing=
 cases where
each node has a closer block device?

Thanks
Barry

