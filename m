Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 776B9CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 06:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38226B0088; Thu, 18 Jun 2026 02:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8976B008A; Thu, 18 Jun 2026 02:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7A46B008C; Thu, 18 Jun 2026 02:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6346B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:34:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11B841667B6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 06:34:31 +0000 (UTC)
X-FDA: 84892069542.17.0359C04
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 229DB20006
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 06:34:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AHTzL+lO;
	spf=pass (imf13.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781764469;
	b=Vug3Cm2LfvOOr8rsDAwqEgDsWl5uPAd9unmMeAzIAYtrCi/TXeFYf3ZWqvjOyjuN/W/Ly5
	2z3kZRblFS9twIqAedMCwwo5th0FJN26+fjdWLXLNiOKACj6xcLHsZK3ABbRrtUFtAgRkd
	O3DdR3yuDmt8tRm1g9zAIIUkeljBSfc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AHTzL+lO;
	spf=pass (imf13.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781764469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Oo8NBVlLWLPAiABDvAMPw2Gh1H7ACmqAdcOnRERYcA=;
	b=KInZvgZhHHHjM95dCo6Tb4TmqsuA5oaKh7i1etGIWUyRLpc8ZtZkF7p9izwVrYBe3CRZDO
	4f0e0IOV51XFj5e+sG9nGcbUvzPO+aLeqSmpfpNyY9Jo4JYoa86iydavoVfFcgJCdpIZqS
	Tdf2zhPAjP/nTGx7HfDZgUlVtk+5tJc=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e6c047c6bfso413843a34.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:34:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781764468; cv=none;
        d=google.com; s=arc-20240605;
        b=B6+5JPrj9L7sRTm2ZflR0iI1zOUksW5ccFUEYfTr4N72cNQ62/QT9BQ2Qysu00DLhy
         Ut+SuedFlBlpihwPAjz9qXVJAOUowFBimfC9kyrI7j8fXMsT4T/c3Op5HveH2AHnv3G/
         6kDFvKEBQN5P1Li229DwUAJPrlJqaWFNBwY8/Tu4/y+tcAlSDVrK97bYNjHIvvBpG2li
         bZyvhnT4HRngx6nuA+jce2gM13W3moMgt/Yrk2YYxxRSxL6ZJbJPOQdEAbw25S6UE7PA
         aL3TjjNQfG84GxCS0796Kk2V9hoICaUcBYeF4Faw2jSWokRgtHWLn8cN7eds5MmHqqMX
         0Ezg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Oo8NBVlLWLPAiABDvAMPw2Gh1H7ACmqAdcOnRERYcA=;
        fh=s9QI6Yu4aqxHLdE3aQvhVdFJk5HhLu+/LA9DvQ4Rvy0=;
        b=Bh8fq6Jfaqc/Ly28/MNHtrg4KTM6RYMUIUrQ/GJeqSC5uNDSRFMWGxw/5amSwRbImT
         y+oqGPFLCW913aiDfViWBZArY3Ht/sdbQoMGRfIfNShf+RxKfXBIAtUthXFDlnThtcwX
         wyegVSfh1xgIv1LzYq9oxQg7goo9Poz01xMI6We3Du3sI2qsiFCCojH/RZFHwP1AGNDo
         UkRbG0Yo5xARaQFmnsAkl1DNhESlSieDQLbWl7HSof0ZaGNGif07xnaQOdtL4SaxNUnB
         uTDkQY8yx1NHLpSMB/gHSqtWerNClVeme931JgK7snNI5wVcHkYpdK0r5l4BpbQ4xmM0
         D+7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781764468; x=1782369268; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Oo8NBVlLWLPAiABDvAMPw2Gh1H7ACmqAdcOnRERYcA=;
        b=AHTzL+lObru1U87LOmejchWs3H2XJvQi0S9ojI1UajyjgcV/epGmgc614mr12HgYfL
         z/fYC4lmcEClbllBWVji1W52ygybLq7AhKge68lRfZIMa0DbcHtdYk3D1sbj7zAC/JfN
         DK+EuaSCn/esStk/7FDvGBW1bTkFEyF6tOsMGJHWPYk8K8wyxD10SbCjheJKVJz91aP2
         SIjdsvq49+o+6i5yfF1oYbR28ZV+fFZX+ceWYPeYQWggS8DCEQqioehfwAIMqVyI7T9m
         BbguL03ad8urqCciCU6KBvORTzfUDqqTg/BIAHaNMP1XVn3N1ZjkszoV1WO3sBI8rBWO
         eEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781764468; x=1782369268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Oo8NBVlLWLPAiABDvAMPw2Gh1H7ACmqAdcOnRERYcA=;
        b=q53fB0stPjohSjdNNqxDA1CNRRlyJ8+pUui26ZrQH7AYsV6RA2XFXoAT/PZmNYzd8x
         7p1tZfEGPq1W6EaTohUGyF+wO+RO2rtwg7wtcsLGkA33Xa2Okgu2n2KD8cBnxVSJf0Sn
         izQF51h3Rt1RpolS0ems29cCqff8EBsiY1eWlyUhQejpFlCIZOafuYjvbEdQRfbdCqnc
         dXTk0WwBUDXkJlSBhg+hAFXLzUBffu5kAUaSbz0coymQvT2p7qIcC0k3OZkd0GXJ9ciW
         iRR5+IYlUa15C+rddalcuqJ7N8kzes8jJzD675pWN9lbXZysp/ihxKB3zFxn3XCtYFrT
         k18w==
X-Forwarded-Encrypted: i=1; AFNElJ8KTT2G6bXDRxec9VVkKmwXivThijXSNQWwAcM66L9jfvqCcCl1JnWA50giKdf5NHVcqYUJ2f7zrA==@kvack.org
X-Gm-Message-State: AOJu0Yx7cro1muzMwNBFDW6H3s4jfTPUnRKlZYmlieCF91BLsOEAg61f
	FauyY4CHGT2Zlmw0Ryriy2ILjg0UzD1RuHuBcL1yYmlYEODOU8kh9vxKVPuEOkgFE70PDUMgFUc
	aD4fojY1dQMUeKYWkVRqfIo/dAJBoBxI=
X-Gm-Gg: Acq92OEIwu9XyttNor8M5G/0Gv1o7FUg7/KFvPn9XdA05xQ3XbXpBJ5lzxDwlmDL9cU
	ciJKZN9C0hP8EnSq2yVtbDBTEr/ux8sERju8deoe8PUJsN/t2CSNlfLGv8L/iiDtSpXSOwMWJnb
	xyYEL9b/pYcFi9E77Bb5U2Nik4Bc13RPEy7XGbi/89btJTKcOMtiMgDAmWVNGu6OPPKVEQFxEbg
	eqKbyrGCwJuLS+UUIQnwjnXuiQPCxGBDTWfA0Hl15EhKBcBoH+gkyQbnj1kLUqmwTrtBu4=
X-Received: by 2002:a05:6830:6d50:b0:7dc:2f4f:17b4 with SMTP id
 46e09a7af769-7e90b3dd22emr6348498a34.21.1781764468073; Wed, 17 Jun 2026
 23:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
 <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
 <20260617-attest-gewechselt-tragik-7ed473860051@brauner> <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
In-Reply-To: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 17 Jun 2026 23:34:16 -0700
X-Gm-Features: AVVi8CdkTtlsRp3whjFCRdKN_CHwplubM07nLp2T3ItfxHiU3lLc-EI912kwpts
Message-ID: <CANaxB-xVCP5HSUNwphFrKPdW0Qh1pA33A6npac60WArkZMFt7w@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Val Packett <val@packett.cool>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	Bernd Schubert <bernd@bsbernd.com>, Aleksandr Mikhalitsyn <alexander@mihalicyn.com>, 
	"criu@lists.linux.dev" <criu@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 229DB20006
X-Stat-Signature: gfru7ynj3mj3h8ty5bgfh8d7u7e5wo56
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781764468-746731
X-HE-Meta: U2FsdGVkX189o3WgZ8PrU5/wqbt2wO6H9aWT1LUdTWXRARDTyvl5183EgrNQBwl0gGjlOxJhRW5hMWJyvJD6bKhSXZaQZR+d27n758X2akywkiHDRlphZ/PnPccLxBQbSGPL6ATJPPy4rptKSb0N/N8V6ajC5sS17ZTbnFImrc6vrdNBmqyNm9e9zUCKcQ7drL8Oa5bU4DDopDOwEe8bf/TYrzCr3PMnHsJ6o7wieqN/QBGjt+skCzRtvCIpBlr1jLjRRx5VIxp+RI2eKwhnGg7VTj/qo/PT8woqjftzSEdm0y7rhOtp+P0hJaPMFrcwvvhjpq6MJ/8e9PeeqdoZOtB2FV1RfVW+gcO/NmcixPiWc8/jeJNQF0sTxBCjqjsGIzHpdKdOODiVkYHJZZg+i11td03QIRPn+nSiOnj/nJpNWBwNSYNydqxUvHPOYNK3ub7kLU3uvaXYQx92ZDbu66IWTl5ye+t35rfEzKcKKCR1ziFJnAe9RYtDooppJrxoAMH5cvpXgB+082u5hH5qCI+A4uA8XXxBSjJnHS7U0SV/EYIscJxE1w/ykzu95tq/wB+ksX+6tvIyACBzmoBIGTzVyCtxkG8QtsL5KONGVEfiFVMQu8YH9HXz6Am11egsevCt99ESidJUe9hB319nFXih1oUFJVxnKv5cdLg5hOifMgslDGqFLwyH+tUWQOqBdMI7hc+xJmrPWEW4ZhW+A9Zr1ZZt7VSaODJwPUBYfcVFrT9ig6eTElxqNuVIXRg+TnCNlpDZ1/y2WSB4wEtyQAKdInC0GMLuaWCo5lN62gMFo0mDjxYYgv4RyIAgg68T4YuNZ6mm6upI4+z65xDP2cM/FzDgEflK/xnbgmJVuiU/RrOH/B+Rs8iaM8DHZsJB7W9kFyo8owoyyabuyb+xpAY4wurMXSg1neEDu2Ws2soYCyzadKinN1X2mXXgcnMiBL+egv9JKVMvihD6Kyp
 ylLjExzX
 ZSGnZsxFQM7TsbqrUxC1sIVhFBvdYrjePMI/Po2JXPjG/JDiA16H1n6WwGq3vAK96P/P7Lp71FL9XNlaZ5NscMe+J2URULW2fmDIHNElV2CAkXrqSp173l16HUNiTHr30CYufaMMltp3Q/DDWhT5HflUrSEviH4MmuuMZcNNqalVddVuD2HaH5LGMOk/KgPzkWiGLE8vBYYxnhNxq63LsrND4/hmkisaX0BXULLG3uIFHWoALdLYsPHquU/mkZ2ibPJLfLiu96qHBo0rgSvWSHerAV3NgYVBDxKfkF8XNUPwfC/wyb4B5lsUDxhr1d1dIdAGafJBiEoBMWGcGzXc8H1Nn5qHSS5trPGtVqoWpGPC3J6vUkDuaTzisL8qIY16OQ9wzaSCtKnhuLGql1YQ7/vwhhQckxUxgAhp6SQX3gp5vPan3QM+dlyTAKaaTjzvLM4HkBDhGZ35HWw4amtAIVTeuCDU17hV09/zzAKdf3QNBs6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 12:57=E2=80=AFPM Andrei Vagin <avagin@gmail.com> wr=
ote:
>
> On Wed, Jun 17, 2026 at 4:08=E2=80=AFAM Christian Brauner <brauner@kernel=
.org> wrote:
> >
> > > After this patch, step b) is a straight copy which means step d)'s
> > > fixup doesn't modify what's in the pipe. This could be fixed up in
> > > libfuse to not depend on modify-after-vmsplice, but I don't think thi=
s
> > > helps for applications using already-released libfuse versions. I
> > > think this patch needs to be reverted.
> >
> > Note, nothing was merged. I deliberately kept in -next though for a lon=
g
> > time to see how quickly we'd see regressions.
>
> The bait worked. CRIU wins a prize in this lottery.
>
> The CRIU fifo test fails with this change. The problem is that vmsplice
> with SPLICE_F_NONBLOCK to a fifo file descriptor fails with -EOPNOTSUPP.

Actually, this change introduces a performance and functional
regression for CRIU.

Here is a brief overview of how CRIU currently dumps memory pages:

CRIU injects a parasite code blob into the target process's address
space. The parasite invokes vmsplice() with the SPLICE_F_GIFT flag to
pin physical pages directly inside a pipe without copying them. The main
CRIU process then takes over from outside the target context, calling
splice() on the other end of the pipe to stream the data directly into
checkpoint image files or a remote network socket.

I ran a simple test that creates an anonymous mapping and touches every
page within it:
Without this patch, CRIU takes 9 seconds to dump the test process.
With this patch, It takes 18 seconds...

Plus, it obviously introduces some memory overhead.

If these changes are merged, we will need to completely rework the
memory dumping mechanism in CRIU. Using vmsplice() in this proposed form
no longer makes any sense for our architecture...

Thanks,
Andrei

