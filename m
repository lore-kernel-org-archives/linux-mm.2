Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73099CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 14:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB7F6B0092; Sat, 23 May 2026 10:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C0C6B0095; Sat, 23 May 2026 10:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753646B0096; Sat, 23 May 2026 10:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 570F96B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:00:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED56293A99
	for <linux-mm@kvack.org>; Sat, 23 May 2026 14:00:55 +0000 (UTC)
X-FDA: 84798845670.16.874C5F7
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id D2230140021
	for <linux-mm@kvack.org>; Sat, 23 May 2026 14:00:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of yskelg@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=yskelg@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779544854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WuWEfTQYjsCVqVvHObEiNmRNaaJS3/KGoVEjCdjn4Xk=;
	b=EJ38USHchDgP4DexZGT1H5BsoOW4eCWiP3bFzATdUDKx9gM7I9NczCC7XFaygzBYVFUQL+
	73/42Ljoqkt+mVp4/GOSrKnX0jwggC8221D/yjeHHjkl0z5/9yF+wY4ThTJByqWtU+FAO6
	trTzKBJGdSzcMGdz75hgcLN8Rp4axQc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of yskelg@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=yskelg@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779544854; a=rsa-sha256;
	cv=none;
	b=JdBXjBmlqwkFDQh7tOCOFDf7S/Jr/5RZbV1PrV0FRJidztynqBg16MGOuKPUYf3H+4c7W1
	dUC5tfD5bbk96PA6nvJO4axm9+R5+4Qx/k1VmJlidybNg+A96/1RKCqP8KwEIBN5by9PKl
	mXBsWGFMIzajggK4Hha4bsIG48ipRjE=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67f6d4f0d70so1104355a12.2
        for <linux-mm@kvack.org>; Sat, 23 May 2026 07:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779544852; x=1780149652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WuWEfTQYjsCVqVvHObEiNmRNaaJS3/KGoVEjCdjn4Xk=;
        b=OUo6FxI+ssA4kQhzoTglJAv/IH+Wm0jzAgX6iEPUiQsIdSsnxRpDPmdz9JWABx/h/Z
         FnBAaEnTzkvoZ/YI8ZxpfL96l5hHGnCOUd7b1fYf26WuSmGGx5lt24XpVV3Epvvtn6nV
         sIA6t+3mH4nVTbGqzubGIamlwkGR/ynqUhf2JYE7D0CFipiJFW5c7AQxYYq4j3E83aOl
         9O0LxlLlel2OeVKUS79pj5ym4xaVxyNmRRpzvRzvjJEx7HAIw5G/Ju9+CJ2HxsRAqBcy
         5xDvGDiH2WGRnrwexXMgNPd3JdJWB7E0JVbilgdB2RGsJhpf6kmH7p+bMx59KzG4xlXo
         YHrw==
X-Forwarded-Encrypted: i=1; AFNElJ+jqB06B1DOUzK78sfmeSH2HykQA50+cT8rc9+6Gqob9e/ExmbEV8EwRDG1MQyABqNKIoqiL8Uvow==@kvack.org
X-Gm-Message-State: AOJu0Yw4TXwIUvgtsqnbh8nKZulZhwxIaCPBbby7GqpuY9mLhlxAR+wU
	Z2POucA806advaHDbZfxNeqnE289RW/q0YAoALwFQKxzRLpATBkYoVGnBZVST/XrbvI=
X-Gm-Gg: Acq92OECAhIGDUpXoo4NwXCOs13hDP0m367TOid0ryRRt/1h/qwCPNJftZD4F0Bjalu
	tmSstPRdylwqh90xg9lCctZlGb7ga13lVi5UCXelEKB0o1EiXlKWyztLv4E4p5WilqBqXHFGLBK
	lWh85uuoL9geOlhvni+itTzXQ6NPCUsiFz7JwGa+B5pdb0D5PRDMuENUXJvtydLl45ED93Qb/vb
	khVR+EChlvzAFyHol3OSmscPr3wBPu9VUfmC+I6SjnxZg7z9gF6O3T2/qoCzImX9Sg5dImBli44
	YTy0G969CyC9xhmAcrOcMgiS3XpJRmRjsTpKDJdABy+NV6+xxRmIHPDgtdsEiS25EFfIHxq+Btv
	HE3ce5ABBVIgj5/P3V9e53tt9j4pk1sxYDLdI+fxxxmzVa2ujOuuRGLlhlu4Y2K82pspl/Qd4Pc
	yLm8Ore6cDd+kJGo83O7YMIcC9nvltUbV17UCDbBlkx8ixyc/QHRpavTlFnWCIXeOCje9xGr1+l
	gdYrTgpDkp45NERLIFhU7E1Gt/YXWt+cPio1rNi93bzZKqzcFCeRh8OusUZGCM56aEUt9eKVT3G
	Opx/SMNqxQ==
X-Received: by 2002:a05:6402:458e:b0:66f:9021:af19 with SMTP id 4fb4d7f45d1cf-6889ca475cdmr1443256a12.4.1779544851684;
        Sat, 23 May 2026 07:00:51 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-688bb828cd8sm2009647a12.31.2026.05.23.07.00.47
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 07:00:49 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48fde653997so7242535e9.2
        for <linux-mm@kvack.org>; Sat, 23 May 2026 07:00:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9CVTCrhpynk3nbqAubOWb8hzVnXQ90T+JcPNc1LnBl/sSSIo72LkdYpcto7Nu+UygPMqd+SUu3Jg==@kvack.org
X-Received: by 2002:a05:600c:8484:b0:48a:56d4:7274 with SMTP id
 5b1f17b1804b1-490428ce814mr56748215e9.3.1779544847387; Sat, 23 May 2026
 07:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <20251205071855.72743-1-byungchul@sk.com> <6b2a816f-eb3b-4e0c-a024-ee2e3743eb04@kernel.org>
In-Reply-To: <6b2a816f-eb3b-4e0c-a024-ee2e3743eb04@kernel.org>
From: Yunseong Kim <ysk@kzalloc.com>
Date: Sat, 23 May 2026 16:00:36 +0200
X-Gmail-Original-Message-ID: <CA+7O06GxeDLR9RcKDN2i-Rgc4kgzz6BfF4b0XAH4tFx=A723Nw@mail.gmail.com>
X-Gm-Features: AVHnY4Jzdbo-RS-M3p-EbMJdQhZ_EyUwot0ge9SpoXayUSqjrmRfCiJZJ7yo4J8
Message-ID: <CA+7O06GxeDLR9RcKDN2i-Rgc4kgzz6BfF4b0XAH4tFx=A723Nw@mail.gmail.com>
Subject: Re: DEPT (the dependency tracker) as AI review prompt? (was: DEPT v18)
To: Harry Yoo <harry@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org, kernel_team@skhynix.com, 
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com, 
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, 
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org, 
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch, 
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu, 
	willy@infradead.org, david@fromorbit.com, amir73il@gmail.com, 
	gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org, 
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org, 
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org, jglisse@redhat.com, 
	dennis@kernel.org, cl@linux.com, penberg@kernel.org, rientjes@google.com, 
	vbabka@suse.cz, ngupta@vflare.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org, 
	dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org, 
	dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com, 
	melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com, 
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com, 
	max.byungchul.park@gmail.com, boqun.feng@gmail.com, longman@redhat.com, 
	yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com, 
	netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com, 
	corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org, 
	hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org, gustavo@padovan.org, 
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com, 
	da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org, 
	frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com, neil@brown.name, 
	okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org, 
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kristina.martsenko@arm.com, 
	wangkefeng.wang@huawei.com, broonie@kernel.org, kevin.brodsky@arm.com, 
	dwmw@amazon.co.uk, shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com, 
	yuzhao@google.com, baolin.wang@linux.alibaba.com, usamaarif642@gmail.com, 
	joel.granados@kernel.org, richard.weiyang@gmail.com, geert+renesas@glider.be, 
	tim.c.chen@linux.intel.com, linux@treblig.org, 
	alexander.shishkin@linux.intel.com, lillian@star-ark.net, 
	chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com, 
	link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org, brauner@kernel.org, 
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com, 
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org, 
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org, 
	miguel.ojeda.sandonis@gmail.com, neilb@ownmail.net, bagasdotme@gmail.com, 
	wsa+renesas@sang-engineering.com, dave.hansen@intel.com, geert@linux-m68k.org, 
	ojeda@kernel.org, alex.gaynor@gmail.com, gary@garyguo.net, 
	bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org, 
	aliceryhl@google.com, tmgross@umich.edu, rust-for-linux@vger.kernel.org, 
	Chris Mason <clm@meta.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Josef Bacik <josef@toxicpanda.com>, Yunseong Kim <yunseong.kim@est.tech>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zy48j7m5mo3sr8n1u737hxfnw58wsyux
X-Rspamd-Queue-Id: D2230140021
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779544853-156947
X-HE-Meta: U2FsdGVkX1/aH6qJsKA0l/fLYFTgs3R6Hkp1nSHkL0/uGr8/QY5T/srwmQvEQKhRX49yqsMb0ylejZ6axjttdFUwpmLvQVBO2KLQ2HEht8D78cZGgLoWqw5IRGLTg93JYQytEktS50rX47VNk6e3+Dh/J8frTG2/Ew05yUOl1rAOYIFirBPbu2h60Bpo70kJvrYz/kskzRmnAz0vWVqS8VxvXpSDPXKiGIpDy5AkhyxJEmCz6O939Y5TeqNwPHvpP0DG2jxieuw2RNhwEp0fAaaawGjnfsspCsJLLRlNt1SzTEt2RqUkzZJQe5CZVECX5k2pKt0rC5XHvNFoZRanbQqLOZCJnrc6F8mqY2N85cPv3uxl38m64Wivhk6d8laIRTAIgs4WleH76tF9VqXLnLPiS3AUpG24M7szpv/dkQwVyWl75QrOPj6r7HJIFMyWkdmYA1wVzJ8fB5FzmKlOQfyDCS63KGwyGm1AgmZpPcFd4S9QD/y3qv342/3PctXMORSSu5JuxQCbzsoC2iD93JGVNxGazDrlofMO+YzwlBjH2jr+dhNKCQ90xReqiJClbylLl41NyU83HAoKxR0KuRsBSbJzCACNcD/pksHJNgdOH/RjqodRXFjFl4Uy8Qb/ZLDTOWUEvkDawjeQmbtADNuxAILd75n23LjugzHFW2qBkPJu2e9K5HpN4OU7mJ3oy0Bja+C3mqUazVZwGooEZzkKrP6zqin/SAEZrthnyqtsbn2Bp9m8RgFv2HdIIK2/K5pAyR7UMxkwe1rMiqsKhd1D+BZ2yje//y6aD+Lw0GIeRSTBXm/vtc7DxITZ/oaWBLyHRRv7mDolTVX+8kE3Qyk/iT9uiZ839VNR1A2+pM9pkLtliuVbMkghVUBYvhMUT5gdWAaaNg0LapxpmISSDbpbWYvqhtCfnLHXs4SIkRDfpd/aPoz52ZFVIXDJFCWqhrxuOvolN4Z+Efl2mup
 +ETRuyAN
 tQtIhwxdwe9z4lkWIYNSYrYShU/aER0x/vA8qPBFdSk96ht/zzboe4/3GsIZAcJaIupPYBXFC63CnISNTcpd+QRrR9M0gpKrrnXwuwRepqoeurj9x89LIHG7fuX581/SPWsCB96aWVAKEs4s3KqBetloB8cVqt2tSIIMZucfUoxYys2pigD5TL+uZW5jFkUvzzUEnYlT97NM09JDW+XB5vFV0UB3bV9UxAVRpTC74K8dC4LYTgKTZ9rLoXDh21Ll7X/qPr2j5AhnyOme96HcDE+Sw2B1XyOt2R3WFnI+AjfNjg9UoxSOT6RXYbAGEuA2rlBlNvTHvk92ligP+bi949A+4WsppWt3jegftrx+O2QTgz0YzJC1mU2V4hERLBeBD11kEg83qGE9aVW3lMOTYN88jb5YJXz6y+eXfmMsRbCB4JgktxyqjXXHuPwZBpT8ZXBn+zVtMWYjcwdXG54zqTG7uq9UwyuR9uNoDO2sr9TkrqNbAZJnxkjlISi43SrY2rZ+KcpqOIzfccarKYj/+Q0XH5La91Mtl2wWdE7u2i59kNUPpbDVlKj03CURuwcckb2w+vViZnvvWQ95Gjaf1WbqH13XklxZYOxuUIo4PFzC+8WglNPJYRDaUChvrrcXZXJwe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Sat, May 23, 2026 at 2:33=E2=80=AFPM Harry Yoo <harry@kernel.org> wrote:
>
> Can we start DEPT as an AI review prompt, by documenting DEPT's
> dependency tracking model and false positive elimination rules as a
> carefully crafted prompt?
>
> While DEPT can identify deadlock issues beyond lockdep's capabilities,
> it is hard to enable in automated testing; without fine-grained
> annotations it can produce a high rate of false positives, and verifying
> them requires significant human effort.
>
> The open source AI Review Prompt has locking.md file [1] that teaches
> the AI how to review locks and detect misuse.
>
> If we can write a review prompt for DEPT in a similar manner and have
> the AI do the deadlock detection and false positive elimination, I think
> we could identify those problems more effectively with much less human
> effort.
>
> [1]
> https://github.com/masoncl/review-prompts/blob/main/kernel/subsystem/lock=
ing.md
>
> --
> Cheers,
> Harry / Hyeonggon

I think this is an excellent idea, Harry.

I've previously experimented with running DEPT alongside syzkaller fuzzing,
and many hung tasks missed by lockdep are caught by DEPT, but the resulting
high volume of reports makes it easy for issues to get lost in the massive
log output. Sorting through that output manually is a huge bottleneck, so
leveraging a well-crafted AI prompt to triage the warnings and filter out
the false positives would be incredibly valuable.

Leveraging an AI prompt to triage these warnings would be incredibly valuab=
le.
I'd be happy to help translate DEPT's tracking model into specific rules fo=
r
reducing false positives and establishing solid filtering patterns.

> On 12/5/25 4:18 PM, Byungchul Park wrote:
> > I'm happy to see that DEPT reported real problems in practice:
> >
> >     https://lore.kernel.org/lkml/6383cde5-cf4b-facf-6e07-1378a485657d@I=
-love.SAKURA.ne.jp/
> >     https://lore.kernel.org/lkml/1674268856-31807-1-git-send-email-byun=
gchul.park@lge.com/
> >     https://lore.kernel.org/all/b6e00e77-4a8c-4e05-ab79-266bf05fcc2d@ig=
alia.com/
> >
> > I=E2=80=99ve added documentation describing DEPT =E2=80=94 this should =
help you
> > understand what DEPT is and how it works.  You can use DEPT simply by
> > enabling CONFIG_DEPT and checking dmesg at runtime.
> > ---
> >
> > Hi Linus and folks,
> >
> > I=E2=80=99ve been developing a tool to detect deadlock possibilities by=
 tracking
> > waits/events =E2=80=94 rather than lock acquisition order =E2=80=94 to =
cover all the
> > synchronization mechanisms.  To summarize the design rationale, startin=
g
> > from the problem statement, through analysis, to the solution:
> >
> >     CURRENT STATUS
> >     --------------
> >     Lockdep tracks lock acquisition order to identify deadlock conditio=
ns.
> >     Additionally, it tracks IRQ state changes =E2=80=94 via {en,dis}abl=
e =E2=80=94 to
> >     detect cases where locks are acquired unintentionally during
> >     interrupt handling.
> >
> >     PROBLEM
> >     -------
> >     Waits and their associated events that are never reachable can
> >     eventually lead to deadlocks.  However, since Lockdep focuses solel=
y
> >     on lock acquisition order, it has inherent limitations when handlin=
g
> >     waits and events.
> >
> >     Moreover, by tracking only lock acquisition order, Lockdep cannot
> >     properly handle read locks or cross-event scenarios =E2=80=94 such =
as
> >     wait_for_completion() and complete() =E2=80=94 making it increasing=
ly
> >     inadequate as a general-purpose deadlock detection tool.
> >
> >     SOLUTION
> >     --------
> >     Once again, waits and their associated events that are never
> >     reachable can eventually lead to deadlocks.  The new solution, DEPT=
,
> >     focuses directly on waits and events.  DEPT monitors waits and even=
ts,
> >     and reports them when any become unreachable.
> >
> > DEPT provides:
> >
> >     * Correct handling of read locks.
> >     * Support for general waits and events.
> >     * Continuous operation, even after multiple reports.
> >     * Simple, intuitive annotation APIs.
> >
> > There are still false positives, and some are already being worked on
> > for suppression.  Especially splitting the folio class into several
> > appropriate classes e.g. block device mapping class and regular file
> > mapping class, is currently under active development by me and Yeoreum
> > Yun.
> >> Anyway, these efforts will need to continue for a while, as we=E2=80=
=99ve seen
> > with lockdep over two decades.  DEPT is tagged as EXPERIMENTAL in
> > Kconfig =E2=80=94 meaning it=E2=80=99s not yet suitable for use as an a=
utomation tool.
> >
> > However, for those who are interested in using DEPT to analyze complex
> > synchronization patterns and extract dependency insights, DEPT would be
> > a great tool for the purpose.

Best regards,
Yunseong

