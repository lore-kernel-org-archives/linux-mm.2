Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CF3E6ADFE
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 20:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047C06B0005; Mon, 22 Dec 2025 15:58:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D986B0089; Mon, 22 Dec 2025 15:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5356B008A; Mon, 22 Dec 2025 15:58:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9EB56B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:58:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 659AC58ADB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:58:09 +0000 (UTC)
X-FDA: 84248319498.24.93DB155
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4785180005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:58:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U6uiNnJ6;
	spf=pass (imf16.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766437087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2JwsXhbVrvin+ouBUUe/Bg2Yvo7yUAk65L8kN39yRc=;
	b=ZHWHvjkN4v79CoIlNVkVGC0sP9ZP5qCfGJi6vY/LCr6tN6vtrEvYA7NsZs+6JKW57/w7aM
	4djvfHJOHppg8prLMTHBjt4vRZVl++EZhF3xUfgszL3yWc0bTTN9RBc9fiMR6O1H+xTLW0
	e+0LbFxWKLb9VlaQkoaovU7CvMBmazM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U6uiNnJ6;
	spf=pass (imf16.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766437087; a=rsa-sha256;
	cv=none;
	b=XvAcsDSJ4NcFQKnCNVQiuKgZ7OAOn4WxUR6YQQBB5PvzhIHAQgplR+AggWIT7UuyaeR40e
	iPV9x6wZKCVI+k5DwDGEpL5GR0PQZvJ0B76wkul8Q2PaVbDbNXZg4+oEKHZAhGtqC7WEUi
	GdoXxUd+P/D4MeHQW4ATD3hEcgtaiyU=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-78fccbc683bso16532557b3.3
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766437087; x=1767041887; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K2JwsXhbVrvin+ouBUUe/Bg2Yvo7yUAk65L8kN39yRc=;
        b=U6uiNnJ64INlaZ7MP7RHpPEEpyy8T+aoUslF2OdnAKXZnjIjp2DVFow1Pvf0NGN/Va
         YcUyDtX8WcIle+Ouqf/olKiNOl+q807eYvo+zwtfpQCIrRXsMVTT0Ni7AEQj/ZdhSxKx
         4PYa+W8TT0WR2LVFOHLWWqwFaD8u9IuRQ6OQqfPkEzyphEy8ynUrQIcMTw4JVb6MdD7G
         SJ37REaIG99DuekxYy4ZFLk0Poagt4Q8ZIRrC9ZuQgee5d8RK+LE3EgjDNzGIc14NSue
         TE92uOaXroPUTxORIP1x4W8ZcstBbBF9F6olXYj3y9n9sT1Qg1kf0J/eKQYyImRGG+R/
         RIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766437087; x=1767041887;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K2JwsXhbVrvin+ouBUUe/Bg2Yvo7yUAk65L8kN39yRc=;
        b=ZnOjwtNso6Rr9P81Rsf7gKYyoYr2+6Um79wSXi5tfK4jZVjl/cE941lzMD352rLLb8
         CO2w6as6Nro9VUhDHq1+GPVlU9mknWjN5NpWDjM/bApo6BHBz57JCf6xl2DJULm2Wxsp
         /maYFTGAzVpARNovQvo8HU9U3jpKORf7imwSnCqlpEQqF5MB9n8JS9NyOsKO3ZlC6W4d
         ZmN1k7sw/Lb2fOGSpHGwYuyvMEkfTO2iLIBaPyOmY9hk9hmtGlM7idif86HY2NwrTXvw
         DlsNdabhLVCvNeYwNsGzsYq7XiG69VxoO45LD8d4LiJ97+AgRCTC61rxiMqeUCiMgFRm
         oRqw==
X-Forwarded-Encrypted: i=1; AJvYcCWowUSixbVmYoT15Fkfjg3b9UE5EQZDyq4rhhSkNL9dqb4dAImPhQtu3LCF+UP16wAbC3ioimo/ug==@kvack.org
X-Gm-Message-State: AOJu0YxHRLL7UfKgaPTI3LIDhN0RQUGpSMMEaUx+zZQDiOgMKjyve6Rv
	TJvtOebbCxoKHlyeDJIEGQb4fO5r9iHVSE3bbRrM73HxC9u9RCP71Lj/MYh4mImMt2FIUMXaox6
	3rGuKogU0P0V1B/xLdegvvk1bwxRvd7Y=
X-Gm-Gg: AY/fxX79TxNQmbVAQkd4f99jcRp0jmpbnz4FF70nfVScCXHp12vYHXxRBbIFFVm1xQ3
	tmQmvuLQFPGk5olyYxuJnww7Eb4fROWYkm0KKJL99ct8zzAsj01WhUVwJEGjtZNZn656DS22Kgo
	tG4YzEqjODezDk+OsDwL+Z8+f4qAN35LYUQlJtyWj4eIPqE4pukDRLFr01gXbsqfJoFPv0snKK9
	pL+BOy9T3Q6jFHo2jaLY2WHH69pFeLk4rNWx+c7LjgN0kTNf2LE4bbM6kcIextBZ+Htue70
X-Google-Smtp-Source: AGHT+IF5ZVj6nX1dD8EnmEt0YjgWz+adSjxmOuScYUwkqSyaS9s01jAx5b4fOFRW1VwZtIbeNVqCJx47VZz1WHIZvHc=
X-Received: by 2002:a05:690c:6310:b0:78f:8b7b:7910 with SMTP id
 00721157ae682-78fb4002b0amr103176137b3.36.1766437086616; Mon, 22 Dec 2025
 12:58:06 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4opA5kdX0c3RrUL0g9e95JJb5hr=ZaGS7FGoQ-nxgF3Q@mail.gmail.com>
 <20251221192751.42586-1-sj@kernel.org>
In-Reply-To: <20251221192751.42586-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Tue, 23 Dec 2025 05:57:55 +0900
X-Gm-Features: AQt7F2pXawDf_RH2SHgy-D6ustF5xP7l5AcTJDceDCDSA83zi1-9LmxQ0aLlvCk
Message-ID: <CAHOvCC6wQ5h5j42iTaepRnSkA6mqeY-ExpHA4Qc6K+-xb6T0eQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
To: SeongJae Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>, akpm@linux-foundation.org, damon@lists.linux.dev, 
	linux-mm@kvack.org, enze.li@gmx.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mssy13847i6dbjqics9n9xoa5m1akotm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B4785180005
X-HE-Tag: 1766437087-304024
X-HE-Meta: U2FsdGVkX1/mSOh2O+aDpSlTpT2oA+anyRfV6Sjzy0hSkqT/RervVxgiBu8OblY3XNpCMEaS+quGvIQ56HZLIQABE5QZHtnQz1oGpGjyMitYWrHjnbqe3/gTvoaD7PdRtcbDLcEIRIsDbxC1y9SLGCNA3pmElyy4op0u6luWSm0TCLMkjMgchich5lRT5dNvPHtP9J9G14nb23FH+huq+Jr9iHBxbl2WH4D6ZkqwhkecK6d2FP/M+rqquagQKRV499dP2tJVs7sbsqQWtcfmHuK1e/Jj9Ybob03bm6ZVXJxhVxg6MGPoxyIgU8dWyEgY1v4Oone3+eZ15dYndjOEFLGM6G1iQZpTT7ZGDeZklmMiV5I/rB25mqC5XgvBxTb/lydZMIKtV+EQM4IBkBiF/mT41dSj0Mkg1+aahSmVRGiKzDagJkGKfuHn+tQmIyCDMyfHwEZs0R4PH2TiGq1Zb5fhGNv0u//kSZtf6bKdART7swXAs32+7iiSAPf7skboWDdIsU3SMJg+r7+3UGKUo0FdhcGDqoZrEksjEsTlmkfQTHA00ih5MNELFVuHglNC9f0l8kAb/cDsOHjo/fZUCGb5D8mM6OPKotULqiF6qkIFSQrLKp/sDl1HoedmPEjoTiyuBtqCngzjJY5gt2X3z1g8bBEcdAMbrHfvhaV45B/g8Zx1lCmUwGVgwdEcpK1UbR5/cpGQYmFcdQUt1p8oTsx4+kAhwQ3gY0b77qjXykVsKJFcugtmuaU0oLV8SjmcyZfIzkPnkOqxE+tvK+5ZWTgNIuAhYCFLfB6+pFSy/h/kKIJoUKUHPYQFnUOI05vZCHjAyj1yH1oPD5gtnY+V8d6pMScTc24OVaPmK8tg0KYebjTB/+FcC5IPV8FDQUcc/Wo46LPnYvoAwu2hbSbm/CNZiuZIU9UfLisN3Dt5ruQCA8W6iCCTByUs2ExUllOaAHzbhGUTX3n3UTnXlrU
 o/S+OKYK
 aiqhN/xxCKuze/Dg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 at 04:27, SeongJae Park <sj@kernel.org> wrote:
>
> On Sun, 21 Dec 2025 20:04:23 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Sun, 21 Dec 2025 at 17:12, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Sun, 21 Dec 2025 11:42:43 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Fri, 19 Dec 2025 at 21:52, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > On Thu, 18 Dec 2025 21:46:37 +0800 Enze Li <lienze@kylinos.cn> wrote:
> > > > >
> > > > > > On 2025/12/16 07:16, SeongJae Park wrote:
> > > > > > > Hello Enze,
> > > > > > >
> > > > > > > On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
> > > [...]
> > > > > If runtime controls are essential, I think using DAMON sysfs
> > > > > interface or DAMON user-space tool is a better choice.
> > > >
> > > > I also think the current DAMON design structure is suitable for DAMON sysfs
> > > > and user-space tools.  DAMON sysfs can run multiple nr_ctxs, so I think it
> > > > would be a good idea to consolidate it into this.  As Enze mentioned, DAMON
> > > > was originally designed as a kernel loadable module,
> > >
> > > I don't recall where Enze mentioned so.  Could you please give me a pointer?
> >
> > Although Enze did not directly state this, His patch is a loadable module,
> > which implies that it was "designed as a kernel loadable module."
>
> Thanks for clarifying.  I understand you are saying Enze's prdm module is
> designed as a loadable module, while you are not saying about other parts of
> DAMON.
>
> >
> > >
> > > And I'm not sure based on what you are saying it was originally designed as a
> > > loadable module.  Maybe you are saying something before DAMON's mainline
> > > landing, but that's quite long ago and my memory management is not good.  Could
> > > you please add more contexts?
> > >
> > > > but I was curious as to
> > > > why it wasn't run that way.
> > >
> > > Maybe I could give you an answer if you could give me the context that I asked
> > > above.
> > >
> > > > When executing the damon_start(**ctxs,
> > > > nr_ctxs, exclusive)
> > > > function, nr_ctxs=1, exclusive=true is passed so that modules are currently
> > > > executed only one at a time.  Therefore, there is no point in running
> > > > DAMON
> > > > as a kernel module, since you are not running multiple modules simultaneously.
> > >
> > > I'm not following your point well.  Could you please elaborate your point?
> >
> > So far in my view, I have analyzed DAMON as follows:
> >
> > DAMON core  <---------> kernel module   <------> damo(user-space)
> > mm/damon/core.c         mm/damon/lru_sort.c
> > mm/damon/vaddr.c        mm/damon/reclaim.c
> > mm/damon/paddr.c        samples/damon/*.c
> > mm/damon/sysfs.c
> >
> > Above, lru_sort and reclaim are DAMON core characteristics, but they have
> > a kernel module structure because they are executed with module_init().
> > I personally think this is inappropriate.
>
> Could you please further clarify why you think it is inappropriate?
>
> > Additionally, currently, DAMON is
> > executed only once at a time according to the exclusive=true condition
> > when damon_start() is called.  In this structure, I believe that the meaning
> > of "kernel loadable module"  is non-existent.
>
> I have to say I still don't get your points.  More elaboration would be nice.

To summarize the Damon I have analyzed so far,

DAMON core  <---------------> DAMON kernel module
| mm/damon/core.c               + mm/damon/lru_sort.c (schemes setting)
| mm/damon/vaddr.c              + mm/damon/reclaim.c (quota, filter)
| mm/damon/paddr.c              + samples/damon/*.c (using samples)
| mm/damon/sysfs.c
            |
        /sys/kernel/mm/damon/admin
            |
            +--------------------------> open/read(get)/write(set)/close
                                               (user-space system call)

The DAMON kernel module above is a sample that sets some parameters of
DAMON.  I think it's better to use damon/sysfs since all of this can be
done in damon/sysfs.  I am continuing to analyze this.  If any
improvements are found, I'll send you a patch.

Thanks,
JaeJoon

>
> >
> > >
> > > > I'm doing some more research into why we run modules with exclusive=true.
> > >
> > > Hoplefully commit 8b9b0d335a34 ("mm/damon/core: allow non-exclusive DAMON
> > > start/stop") will give you more contexts.
> > >
> > > To summarize again, the intention is to avoid kdamonds interrupting each
> > > other's access checks.  For example, suppose the DAMON context for
> > > DAMON_RECLAIM and another one (could be created by DAMON sysfs interface users
> > > or other DAMON modules, say, DAMON_STAT) are running concurrently.  And if
> > > those pick a same page as access check sampling target, their finding of the
> > > access on the page depend on a race condition.  To avoid such a case, DAMON
> > > modules call damon_start() with exclusive argument set.
> > >
> > > Maybe this is unclearly documented.  I will recheck the documentation and
> > > improve it to make this more clear.  If you find the rooms to improve and have
> > > ideas for the improvements, please feel free to send patches.
> > >
> > > > One more thing I would like to add is that I think it would be less
> > > > confusing
> > > > to move lru_sort and reclaim to the samples/damon/ path.
> > >
> > > No, I don't think so.  Those are for real world products, not for samples.
> > >
> > > > And it would
> > > > be
> > > > a good idea to organize the core sources toward
> > > > mm/damon/modules-common.c source.
> > >
> > > I don't find exactly what kind of reorganization you mean.  But I agree there
> > > could be rooms to improve in terms of the files and code organization.  Any
> > > suggestion is welcome.
> > >
> > > [...]
> > > > > > Finally, I would like to add that designing prdm with an extremely
> > > > > > simple workflow -- load the module, set the target PIDs, and enable the
> > > > > > switch -- will contribute to the promotion of DAMON, allowing a broader
> > > > > > user base to benefit from the DAMON system.
> > > > >
> > > > > That workflow is definitely much easier than directly using DAMON sysfs
> > > > > interface.  But, for the reason we have DAMON user-space tool.  Using it, the
> > > > > workflow can also be as simple as prdm, like below.
> > > > >
> > > > >    # damo start $TARGET_PID --damos_action pageout --damos_access_rate 0% 0% --damos_age 2m max
> > > >
> > > > Where can I find the damo source or documentation?
> > >
> > > You could use https://github.com/damonitor/damo and its README.md file.
> >
> > Thank you so much for sharing.  I am trying to analyze the related contents
> > in more detail to improve your DAMON.  I'll try to organize it a bit better
> > and send you a patch.
>
> Looking forward.
>
>
> Thanks,
> SJ
>
> [...]

