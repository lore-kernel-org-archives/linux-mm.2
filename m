Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2732DCAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 00:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AB26B0008; Thu, 11 Sep 2025 20:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C108E0001; Thu, 11 Sep 2025 20:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A3B6B000E; Thu, 11 Sep 2025 20:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4DB46B0008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:25:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 585061A0618
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:25:27 +0000 (UTC)
X-FDA: 83878704294.28.5959BF6
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B3D31C0009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:25:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0HpualqK;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757636725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBEQ8ZTMn3TZxAlSy9fAiaDOr1I2tmTY9zRoUUHxCNg=;
	b=KN3UNeywAvZiAUcfmk6T3hs2G1D5/2P3IsmSR2OeKGe50WVeEJX9MynmHYtHVc/BW1jHRu
	O8GGMrYos4aI7EGUsO/zUfhIDzLj7DmKPm5flAs6DW/cTzzke2Gk6yaGYIxVrKo0HBpMhA
	BIkh2EweoU6B0WfFqlUewMEgDD0sMGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757636725; a=rsa-sha256;
	cv=none;
	b=Z3BxSCScn7ExPvUhIXvL5YFc3QpxtdPzRsDmxdvs57AT++zaeKBO+a1Y/ZmY7gQ1FUYQ5x
	la+k5I5LAiFyTzNEKqRrj+z6zrDc3969V1T7HpD0VrIB4xqwJo9AI4nA15Mhmy5sTUj76T
	92q42UwpvkPdNuUwTqYlCBgFJAb1QIs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0HpualqK;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b48fc1d998so72161cf.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757636725; x=1758241525; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBEQ8ZTMn3TZxAlSy9fAiaDOr1I2tmTY9zRoUUHxCNg=;
        b=0HpualqKzHqqpPBIuRZB/s/bwdjy/Oc21TkUUSD1nJ7VtM1DxRQzFeh0jJwYeuxhjt
         L+Kxo36DO/4x8t6Tx2TYPkuwc0RmyM+JsCHP4+nKHViChOf2ysZV8Ur4R9Mq+CXOWdXe
         aWRjLhFTyeXNYYG50sPLETOFAtwMHI20rQ8oawapJHbqjkKxC8n1L6WnpGRt2+WHNDur
         LCSHYvK6hj4gMrcsjo97rDK6Bj3IHrKnkE+zFkl64qo9peRP9WnCLxLZBqa2C/WnGXmm
         SwFAvi3JiY1F0jNFZ1V+YU32FILmvJj6T8erPpI21oaqqjh53jJiGhs7w4k828YQGVM/
         K+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757636725; x=1758241525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBEQ8ZTMn3TZxAlSy9fAiaDOr1I2tmTY9zRoUUHxCNg=;
        b=F6VT+0XjLLlrfPLh/BKMrT6LBCaXjCZ+9Mgi06IOlVA9Q2zipaALjsc34Ti/ZHeiGK
         7rXZ98PML7zfeuXZMnOY+HdiiZv9XMKUvVrWD0PDrhUGhStJftwpGsEwauoJOwU7Npc7
         tfP3zwRE1EwnNWFEalDJo6buPE3NTs/EWIC6a2hxVEZsgT8k2+pYIaquVuLMYnpydGNe
         vugBKZurycINVaVL6kvVt1GDZbyqsgUDzbNo+bTiu/3pVGDHV1Q0lo5zI06K7y2lO3j/
         pD0OC7NXE3u4HP9/53p3epc/wX8IsJvfEXB8tNrljh31Rdulb9tSH7kUNhQ2omuwx+d9
         dDUw==
X-Forwarded-Encrypted: i=1; AJvYcCVLw50TaOPbKM5xaTulGzE3qrT01R95q9ubdWTb/AlY/Qy55YkmkA//TdkYTw1/5cBCxdWrw94Z0Q==@kvack.org
X-Gm-Message-State: AOJu0YwjWD9KV1t9GKje36ZPqrfmpmdQTsCbsA9f+0CcUIgYGGRgIirI
	gomGFhdOrggjFnNPmTQob7KD7eapoMsH0wKuVrClinLU/6mkDkvFGC5m36mQwqonGq3kAvhA0yK
	rLcfzPZSR0ZQlMfvv4yYdnSvmMaK0e3h+cVbDz8Ng
X-Gm-Gg: ASbGncv7/G8wcG/Wzd31juC0vbhE7LvO3E1hjPQOzzJIleW/dwZtQFFa84uup86RA8s
	nrNhBJGQKGnuzAgW1jajetukBMdlSsc35AeKV6xxuwBu05RecFWsCEtvPx13VwvNAX3PejF8ZEx
	Gm5sLlGOYZ4HAAHScZMtQ4+TSv/AApT9taYCSmbpZxW+zITugwmN2Pvy0ntJKQQtS2hLKfoseGR
	6zRbzfu6Zgtmxgl4pJS0+ol3JfSGhTcwiMkPNCddis7
X-Google-Smtp-Source: AGHT+IE+0Ikv6ZmClRprAjJ7En2Cf/iJ3MovNG6j9LOKINd4JOerL1B8XHmC6+uwh0xdO946ixKIpCb4kUZ9Dkji5K0=
X-Received: by 2002:a05:622a:4a:b0:4b3:4781:bf2f with SMTP id
 d75a77b69052e-4b626eb8e4dmr17807611cf.9.1757636724078; Thu, 11 Sep 2025
 17:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250909234942.1104356-1-surenb@google.com> <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com> <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
In-Reply-To: <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 17:25:12 -0700
X-Gm-Features: AS18NWCtHRQfQeopObePXdwXorxorF9mUB9KiM1id21GcnnHiYfUjUroiM7mNYg
Message-ID: <CAJuCfpEoWtgv8k4vApkGsNNUYFBnvS-N2DPQu2JrreCUPbT5dA@mail.gmail.com>
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>, Yueyang Pan <pyyjason@gmail.com>, 
	David Wang <00107082@163.com>, kent.overstreet@linux.dev, vbabka@suse.cz, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8B3D31C0009
X-Stat-Signature: pkhcqd589ezdaxhqaqtptpizpoctm3qp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757636725-874566
X-HE-Meta: U2FsdGVkX18rFY/F/3+rwTc5iOPlQsUon9CI4kk6sM7IDxG/+fwgj/oZMeYfHbu5tSq/fe4b/cAHNAKX29aKsznDAbEPtQ5GNc8GRjZewz1w3kn2N3sCePgFgBOQK3sOfcx22eiUouoX0aDdtbw4vWBFq1ZpdOUjEKHxaUcHe0TSJT5lWJGkzznWaPP8QeW8THvKV5NgoTKeKyFMfo0aixXM2TI/CVulcwtOwpn7kKYByovmWK1cPHeuRf+0LFeKbypgi2H0EIXY0DQPpo3d52AhhyCPv7narD961vZIqdO1wr696qkGhnvHBH/C7ty9L4l/c4s1NUKScBUgjeN/RSXy8LiYF3l9E7+I68BWQJMKHa3eGaO2euqv+zKe2q9MV7WO0/nsiOK5AYWotHmST8e8aebyATidnLg+0N1wMeTGv2ahe8Sz9V6I62UZP41F3UA+CRJxeEdtyGbC0aJyx9TI8OozQckUVBQedQE0411efq2O4HaGploR1knUS+syQJIbf/617ThMFs3E096EDEjLFimjXbrQI3AeMff9NkQ99i+JpEIJQP+feZiSFvF9nPN7Pxe3IJm23Gsy/uHWk4tkjtMcTWCqkdeQGlxKr4+nQ/rTjHRYCvnD1X3avplJkokoeQprslm+4MAIQlfDOH0vT6p9NMOElrVFOtOzRV8Oqd3YssDabWW3wlBL1ad6b1S6VabHiqxu6Y5Nk90E8mJdC6gL6cDrd32Zi3zDAeiGUUhXRSQlvrjN+qv+jK1dJ0HlcUWlDUn/ttvGfIDzOzCSzSqkHXSzwQ69p1bhCObxLeJdadN1LDOPW8cN6nF2pE+Cl0mEruwLY3hDoR4nfHMfZ1GWjamN8yaSbp6qCzFaKAecdQB/kvAFU+fu1WdpLkCTmWIqO3BMEsF42fsPqNbxwZqcL4MidQhAnyXCJwFhlelDtFBrlxrlrFgp7MuYK9eQ4vJ6PuU0Mxw8NOA
 ht7Kfaoc
 0vClOwQBuawTLvpZbZVGkSKqh3Jf1CK71lRjjiAkTQ3xO7+XJQRbX5zre5mr+1Sx2jtmqJR4XLjWOyCQ1Wbi1KOn/eJ8cmZ2hg7pgvDMBmBZGkUL6hIMKUs4LLZIKzGk6qe9ds/jOsfCTwV7p3Yl4xiFf0ISSuHFASqCBgVjswOq1BG6nA0FWQHZFgbl6F9zCxDcZY8LoQSEQ6zSJh9A3HNBq+ES0c1zMF+SOV4J/go+3MEWvEa4AOEipafBtuAkMea36K8JHB8smWZ27by+oRkLrdm6OeN3oL5jrjfEQpuo2AUAAUTpcmuAcp+STJg/tx6Wy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 2:31=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 11 Sep 2025 12:00:23 -0400 Usama Arif <usamaarif642@gmail.com> wr=
ote:
>
> > > I think simply adding * to the end of function name or filename is su=
fficient
> > > as they are already str.
> > >
> >
> > Instead of:
> >
> > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_cre=
ate
> >
> > Could we do something like:
> >
> > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_creat=
e(inaccurate)
>
> Can we add another row, saying "the previous row was inaccurate"?  I
> guess that would break parsers also.
>
>
>
> I don't know if this was by design, but the present format does provide
> extensibility.  It is basically
>
>         NNNN NNN name:value name:value
>
> one could arguably append a third name:value and hope that authors of
> existing parsers figured this out.

Actually that sounds like the best idea so far. Currently the format is:

<bytes> <count> <file>:<line> [<module>] func:<function>

We can adopt a rule that after this, the line can contain additional
key:value pairs. In that case for inaccurate lines we can add:

49152      48 arch/x86/kernel/cpu/mce/core.c:2709
func:mce_device_create accurate:no

In the future we can append more key:value pairs if we need them.
Parsers which don't know how to parse a new key can simply ignore
them.

Does that sound good to everyone?

>
>
> Whatev.  I'll drop this version from mm.git.

