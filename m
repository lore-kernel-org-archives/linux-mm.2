Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03BDFCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 05:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B13B8E00BE; Tue, 14 Oct 2025 01:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488A18E0005; Tue, 14 Oct 2025 01:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FA28E00BE; Tue, 14 Oct 2025 01:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2873C8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:28:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8160C0733
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:28:20 +0000 (UTC)
X-FDA: 83995589160.18.E2ACD65
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id F0707180006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:28:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="S1/sziiO";
	spf=pass (imf06.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760419699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptPHbzU60TAIm8mnnxk2ahAv+Cxa99UUvkWsQlBP2xU=;
	b=HKPSV6TXEsYxvcZ4L04oGzIJz5TZQ/BLiDEt8FCPBCIP0u6U8pZSg6WnKXc7Uf4oSoOuPf
	b5f197SicOSpmnn8qXQRxBS8PU8tyNwQ+ilJjT9RTijDVwX9JJYO4P7hkbyxKEhy1TIdmk
	J89WfqBs+Deh1hiulRBma4TygLAYC60=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="S1/sziiO";
	spf=pass (imf06.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760419699; a=rsa-sha256;
	cv=none;
	b=RzWrMLDXNUAKaoR9vi++C0ffRmvW3B1t413zosivYQLLpEnroE9MpyEC5CG3KjdRKmUMvQ
	ZwotprO4pYxWK9WeE2VXZxyJ1tlyvLm+VgW0PcLix6iXMBg15pz7mpj12sp/Ok/ai0DUhn
	9azd8Q2HWVZwHGc6BBeRQloQAUy4BKc=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-59070c9111eso6013476e87.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760419697; x=1761024497; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptPHbzU60TAIm8mnnxk2ahAv+Cxa99UUvkWsQlBP2xU=;
        b=S1/sziiOUS6H4g6RKdOPEj4OtsbSCmciFSctm9E+nFVTsoUct3FbW1jb6/WmBDV/tv
         pA8B74P4/rtFU7m2uxPTghjlbPNBccMs75jLxj71uXeRZT1E+RpVunecnAgXuSoHO47Q
         GkSWPTzVrP4eo1IxkDHq5voEVsk+VLkXFBkrwDXepJLQWM2IRlu/t1schDsZvtEpMtyL
         WadjVvNhNciJj5e+kU+B5of5kIJak8byMAa68Y36WTr4A0IPMoVuF2Ap8zlbBdT9sIpO
         aCKLT1A8xtz4SLiWUoB3FWQkyYt5vTuJMNCo4oyOPGAAf767SQVpcMunqIbc2en1S7Y4
         UPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760419697; x=1761024497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptPHbzU60TAIm8mnnxk2ahAv+Cxa99UUvkWsQlBP2xU=;
        b=Z7HPkQXlige6xKKKRLkNqqsx4dZAchCBFzoeAJAFmdN5ulXkij+4dfwKlyBHnS9Mbl
         fwMGwnxCsqSHTU7EGGmWoRoNgGOHsib6ICasTiSl+1jgo2ZyXrslit0syZ4HNZrPvzp/
         uPaASAG3MWs/F1rFOU79SXhW221Z3s7MWff4HSTYv+l6XNTsRME4Tl3fnwcGHzHe1FH+
         sMbhUEN8QpUlFglrU1F9eTIgOIfmuQfMrHzrKJsVfmTj85R832Vw6YBtseZ1/PGhzKKi
         V4FU6V+VQexU9X3fO1Hlxl7zDLrI0+Z7rXDQfU34PNOBv04dd18Mo20ocLhnenpD82zK
         IHWw==
X-Forwarded-Encrypted: i=1; AJvYcCU+5lg9r18Hd/1tdsAwvStjnoy4KRbYAA2FekLUN/pLPZsfiiTRTYdIwZR25pkD0SvMAmVUyMD6kw==@kvack.org
X-Gm-Message-State: AOJu0Yz0RNOh4SEvHC7N3LFi4HUA8kIZY1SY8AygCPa/wZNHcybYP0/C
	8KPt4rRozKVqX5pvwrXcSHCm2iEzL8OgWLiF5j2RWHMVE/sTyjjRODmKFv3ly5D5sxczKuhhsFq
	8M/aoKx3cWcZQ+fI46mzJ+YvQaPs5gBw=
X-Gm-Gg: ASbGncvZOkeQFdG9iuIIuykSHVQdyodJ9SxwHL+fHjmLMnZx83CoOmpbe2ZqOnC36uL
	lt5lp6hJAklVuHz7iSJTJI/Kz2/9CC86i/piN0OYNKpjNHrzlT2q4XVJlfEe5mbQQ32cVRH6PJp
	kRjTnKuAHkqxA5XnB2ttoyan2R96cV7kgcW7PuQl3iBDGlkpJlO0TwFSdhzNdwHkNTX5+j8D1wP
	tIJ5ncFkWyM06loq3owVP2eVg==
X-Google-Smtp-Source: AGHT+IGdjfNUCN4gunItNKInWlyxyXS9VWDbMBSmmBL39oiGRrNBNxoCrVW6HmO4TTj1J7zFqIEW6QQm2vhVXKpWfzQ=
X-Received: by 2002:a2e:bcc7:0:b0:372:950f:2aff with SMTP id
 38308e7fff4ca-37609e0ed4emr64933311fa.27.1760419696692; Mon, 13 Oct 2025
 22:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com> <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv> <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com> <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
 <aMfWz4gwFNMx7x82@MiWiFi-R3L-srv> <CA+fCnZcWEuBerMeS4RCXQtged06MJhY=55KsYeJEOJn3K0psXQ@mail.gmail.com>
 <aNNY1AzfGua3Kk3S@MiWiFi-R3L-srv> <CACzwLxh10=H5LE0p86xKqfvObqq+6ZN5Cs0hJ9i1MKJHWnNx2w@mail.gmail.com>
 <aNTfPjS2buXMI46D@MiWiFi-R3L-srv>
In-Reply-To: <aNTfPjS2buXMI46D@MiWiFi-R3L-srv>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Tue, 14 Oct 2025 10:27:59 +0500
X-Gm-Features: AS18NWDpoAnK8X4S74wzUC_xmUwiiptVaXx4Fi_Po4Ht89THf-aVMKFaVW0-Q-g
Message-ID: <CACzwLxiJ0pGur42Vigq=JnYecyZn-Z5BC3VcqxSUttT54kEusA@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, glider@google.com, 
	dvyukov@google.com, elver@google.com, linux-mm@kvack.org, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F0707180006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5itf947d99iazjkgoj9fpdfu1cwfdf1f
X-HE-Tag: 1760419698-437589
X-HE-Meta: U2FsdGVkX194lHL+9mH8EtnY5TTS6oblz5JvGuAVCDYAElC8RdshR1Wr1k5IXKeK1lK5MCaAfImae9YOPYzDpB6+hYAxrJHh6Q5GC7GiDCdyi23Ca3BMCYmChfvRqhQh66qHn0QDsnkcdtNF2ycRkPhv/TC05BDm2vxGX5ZIiD0mBSJyZaIekIgTf8Rpj3uUjQ902EsxoHw44EFqJBcb9XdpIN8Uq5i7T+MNIlHJrJPuLQ9yDZurAWtHUP89F2l2cuZTRiB4etxBs8o6tUATiHzPX6W6MFZTZOAvkixCLkGXZoZc/qwrgEx/n3wI0wQtIDbJa1rJXedR4YhYPZbWfCMvf5JY/rPQhcpk/5y9s/86yEt6jT6VlYVF5f8wLMAzOEvzFciMKfkEt6Uv5JYIj1TkUzWF5cbCOMxVKtXwrLToXgyzHsw1u6lTPjO6KCGRs2miwynXZkISdRkKocqX09QpgTP7ijxNM8S1AgWZ5tlJgSlh/FVX2qzP1Cu6Zlhxh/JCxowjnblqwCwbFrL4OK52ecCelLVXVoG3OdMPZkdctDJ3UBmBDNdtK5fUy3c4MTHuABPQ85CQ0QSHX2tp6KOuyfkPEs/ggvA65YUfAP0ayGp40HpgmHWANI4J+dFGGOkBHYr6U0ne+ISYcEWYlVTIFaB6uVkeI0TFn1NI/xD36QNqk14EzJLot5UVjVAYjjHULQrSEbVD05MS/xnr5H4lT+REMYxjJioY7lA1KOOlxN+wJST0osvVllohwGSoQ/+qp7kQrI7zwk/GQo7c6vAXvlwKtb1T1Vo3NiSqBYfK6DtWwCTn2lgIvdkXxvvya76cc7wutExKKNOxKdNWtbAklRpgmrna1E62op/8CauyMPErP9aveRyH6qNJ6xP0mHH+OocaTG9k/v3lA/v/ZtDOYcgLxlcCMyvNF8e+GfVzy5WODAdcEW9QuY7K3dEpzm/ILwWe63mtcBdVOCa
 aPfKJn0U
 PqPG+uJRJtEv667z2i2NckVGCrQRjHfsjHwuAfPf9ThCFoIbSTNtqG8LvqfftzQVeDuogzJGkWd3DNEqXwnNWNuJ6rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 11:21=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 09/25/25 at 12:07am, Sabyrzhan Tasbolatov wrote:
> > On Wed, Sep 24, 2025 at 5:35=E2=80=AFAM Baoquan He <bhe@redhat.com> wro=
te:
> > >
> > > On 09/23/25 at 07:49pm, Andrey Konovalov wrote:
> > > > Since the Sabyrzhan's patches are already in mm-stable (and I assum=
e
> > > > will be merged during the next merge window), just rebase your chan=
ges
> > > > on top.
> > >
> > > That's fine, I will rebase.
> > >
> > > >
> > > > But also note that Sabyrzhan is planning to move out the
> > > > kasan_enabled() checks into include/linux/kasan.h (which is a clean=
-up
> > > > I would have also asked you to do with the kasan=3Doff patches), so
> > > > maybe you should sync up with him wrt these changes.
> > >
> > > Hi Sabyrzhan,
> > >
> > > What's your thought? You want to do the cleanup after my rebasing on
> > > your merged patches or you prefer to do it ahead of time? Please let =
me
> > > know so that I can adjust my posting accordingly. Thanks.
> > >
> >
> > Hello,
> >
> > I can make all necessary changes only next week. Currently, traveling.
> > I will send the fix-up patch Andrey has described somewhere next week.
> > Please let me know if it's ok.
>
> Please take it easy, today is Thursday, I will wait for your clean up
> patch next week and post. I can do some preparation work for rebasing on
> your merged patches. Thanks.

Hello,

Just heads up that I've already sent cleanup patches [1] and
Andrew has merged them into mm-new tree.
Hopefully, one week's delay wasn't a problem.

[1] https://lore.kernel.org/all/20251009155403.1379150-1-snovitoll@gmail.co=
m/

