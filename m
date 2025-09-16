Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B900CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886208E000A; Tue, 16 Sep 2025 13:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8370D8E0001; Tue, 16 Sep 2025 13:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF898E000A; Tue, 16 Sep 2025 13:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF108E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:47:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B658B7E3B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:47:45 +0000 (UTC)
X-FDA: 83895846090.07.4C6BE2D
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4428F4000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:47:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LgfPcPOm;
	spf=pass (imf07.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758044863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WV8PZeNRScOuv4YluUBiR/tynYHUDyQLkirKhaJTO4E=;
	b=CGqWwsxvV/Jv1udkAHs1+zHKWxaOuwdf5S8nDf97FErLeEY+ZBX3tilCc8sVWR7uwfV7oZ
	0OkhiIbuDAViQOmzOqqDXtvYvAuqe8BSrlPqh0F2HR1KpFsXMCUnbvMXdrjkZwcKkkqTfK
	qTg9RXD8fmwaDXMMJHsX7axxPfbR/eg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LgfPcPOm;
	spf=pass (imf07.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758044863; a=rsa-sha256;
	cv=none;
	b=PTct6JSJxd79uVV3UbjXti1GNlS65pmlpRIV+u5ddzx577g9QEyUQhcBe3S/W5tn9jzAUs
	cTTfvuLYo6i+5SEixjixo2ohTVC1kSB739oDoyWPAINbqWWFiMB7KRH9onYZxh8JNAZdvQ
	6T6qvT7jXhcKxCJrCCKCI3PfiLb6cPQ=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-267c90c426dso18335ad.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758044862; x=1758649662; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WV8PZeNRScOuv4YluUBiR/tynYHUDyQLkirKhaJTO4E=;
        b=LgfPcPOm4A7/KpEOO7FuYhMkxvUTT6NLvPiWfskSa5PUHWdF1YqCY7fjeCHOH9LBEJ
         NXBKmh2bSKVcnOZjSvzNErQSLwdIWOK9qArRRDHLqQokmpnD3g1b2ZzYyDnjJj9unjAo
         J440vqwaEaZI9y1jkUsJo98b9u7DxrHWMj4MAN/wyvjcWIE3xlGuNmUoB8yIXj3ACSSu
         mTXHbpJINgNDbp3NbYOJMGN2xpOieCM5EIfW8CmD5qbwXRTqhVm/Mui6wj1P2gMrdebx
         sI17cpcTMX9BzjSLz7ueTD6A8VgZ3ACxkbRm/SZGHYn0H0rh5sHAfWiXDnrfBEFOHIQw
         pQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758044862; x=1758649662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WV8PZeNRScOuv4YluUBiR/tynYHUDyQLkirKhaJTO4E=;
        b=gh4UvoZHK+0+DJxlmiNGKsPezTekX66PkqL3mvjYBVAHsL+I3WVsrfhj8HxnudCbwh
         pZFb4vmy6QvISfGqYFz8giQJN6KlUgMG82pMBYGcdZjvGXiSkO+Xjvuj7lc3szjD7K2R
         yJA16wjkUYuudVlsJi4rtQ+E6AAhrBmg9I3PCVVeBoPf4wilBuhY9Fz+jJVrVSwoq//8
         ICZLyKBIEhywwI/UGp0YFmLVdEORuRo87L6lzDzF5vAnkr0S13xzBrMMi8MhnBiygRjG
         tTPyFzKJFcjL8N8+u3/mxsoWg4YSLo+QqYH0xAmNyPrJWV2pljcfgGvAw75CHQhnwtaV
         NuYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMRKYe+FUZV1pPvJj032a1TR+TMONb4BQ2E4TzIqtjiApXezslpAk1z83ARMGZzgtKckRmr//eQQ==@kvack.org
X-Gm-Message-State: AOJu0YxaIvZJSMNFxUuo79DCtU7hkLfBOD++mQu8VyDuIZO8ZDAoTaEW
	YCn3vVJL7uuS8NaoM7Alf7YN49j+QC+2rqaOCc0kSL4uZqxxF0aTttYCPegEkrf0m9v53qZaqgn
	6vcfRjZO97dtEetBvTqBEp6L0Llkljv0L7IrmoOJB
X-Gm-Gg: ASbGncv9D70sy+EvBCu4Q1IbYkbKzEf5FoAxxJTP+Pvcy7ROZ7HYxmlId3+5v+DdxkG
	ff1AUkH2qA/2+CwMsSzOteFgNPf7zp9j2ySOelJUjPMuTyPPgnistrHI3HAtuBQfKc2ovaUq+xy
	Y0m+zc9/fgjNaUaJ8fhk2tVr7fgswkzFJPrLWrjCi5tsi4Ckc1gu/nErCUU1wppyQfkOx6AF/C8
	/0IKNwttG6GKrrIeA4MCxzKfcZhiZD4qTKwd4brnK4NGRMP9kbSvG8=
X-Google-Smtp-Source: AGHT+IH481Ptt6TGK3gOl1kWB0jZ6sD/yNX/MW49IQWxuVmUns01xHRPJ06rIkyHQhotda3n4zze0byfKtMf1L55b6o=
X-Received: by 2002:a17:902:ea06:b0:267:912b:2b4d with SMTP id
 d9443c01a7336-26801263c77mr123545ad.7.1758044861731; Tue, 16 Sep 2025
 10:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org> <aa95777a-8012-4d08-abcf-7175f9e2691c@lucifer.local>
In-Reply-To: <aa95777a-8012-4d08-abcf-7175f9e2691c@lucifer.local>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 16 Sep 2025 10:47:30 -0700
X-Gm-Features: AS18NWAFaSQqFXRnUy8iH8cngSLpkM9xdFvTXyHLo_pUfxdfSq_22GyY9mLtXWo
Message-ID: <CAC_TJvdwt_66v_A3RnuUBS_XJ7xMwWhEwHEEeLpu2_M5aVQ=Fg@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, minchan@kernel.org, david@redhat.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t4pb4ibykhg4airjkwcwsxac19bzqq1c
X-Rspam-User: 
X-Rspamd-Queue-Id: 4428F4000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1758044863-755789
X-HE-Meta: U2FsdGVkX1/e4YlY8gQnae2swVLjghXn9vIlnOkKn9kkptVdj+fgdwT+kocyTsm6Y7u2Cqz27TZ0mA1efjbsaVfqjEmJnRuZQh+drhu++d+H4eFA8ALo7xILgtlcgMkhBC0ls2i/dkneFg9fqfgO1pt4yCzHMU7fPCUjuBKIzHvJwcGHF77yrdEsAgaUaui9YRefhhpBR5FLkNFvNM3KzBV33rGiEUMldEbylnKhVNgL8fPj2Tw5cGrPKp14x1ubL9HifoUjaSaZ31XUnvk2Wt6vwZLEpsoCtSmbD+Fz0Hm8IlUoKKP64TH1nGfDakNphL8xd0c6Kfv4SpirkTw5ITdfhwkjdNrHSia2ukTMntDWoELBNhHXz1ZUOxtYoA5+M0goNUitblNwOENXiA3e1nbvbly6C5EEznIQthrRTlSO+XaAHVbBWDXx//elniH9V42bqOupS5kh4XcpdSYocCYiuL2Ps4K9vQmZd8YZzUt5ImbJz46NcRxq/oD/QSD+bsMz1T/JG485dMf8ahxwkQRCkkD54HtgF6BOXtJg3GMyra0UH9hg5wNHExohQpcYxXXpXSrfEeMornWK+KQ1P/2fNbMPbLCE4kDDdUqA6R3jBDx6oxwEZnak3IkK8DsdrcybqQIaWO2ejlId+gE02tvlvU9FPE88RaxNMW298jQQzCZdfLTsaddOJDoAo5tYM5V6oE7Ovu5bebB1+vS1julwN+Kh+QqcVV8/uquPYKFCRLz1AW+QRPXVCzmbYRihTqAOiaGTc9/t7UoeVJzUcHg/nYWlE247g21Vj0OAUj20MtS4oyetq+fLQeYF01r8uYTX3Imf2ekVfHIVaGqa2Zx6/JVLw/xigiGYZNIVqvti7NOUn3qpKe0e3mGeQzQV6wIhBBd+Q6mBd8AvcAzploQSLYtD+trA0pFgpxjymKOMWdN4OQXy3kLtIkQwHnQTI5uQQFlVranwyMaBMwp
 a4P/Tqqb
 OXpjuLagVVx03sLRCsZ6YlY91gm0tzCUyuFxRFA5O29EgU/2Q64cHXe4dEVENdelhnZVtYuVD6yYjkn6onNuhKOvCYtTaNYKwcWNA12ax0zBdFGsgtEQ3NzUOxPhXjrU1FeqdxXXJ1Zd/2DuUdrpBMp332L8fuHEGhtkgQzzplw5iX2g3NETXfxPQQlBtsAU2akwKsSBIgB0wFWlIB9zS6tr84Y/srMF11367
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 3:12=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Sep 15, 2025 at 03:34:01PM -0700, Andrew Morton wrote:
> > Anyhow, this -rc cycle has been quite the firehose in MM and I'm
> > feeling a need to slow things down for additional stabilization and so
> > people hopefully get additional bandwidth to digest the material we've
> > added this far.  So I think I'll just cherrypick [1/7] for now.  A
> > great flood of positive review activity would probably make me revisit
> > that ;)
> >
>
> Kalesh - I do intend to look at this series when I have a chance. My revi=
ew
> workload has been insane so it's hard to keep up at the moment.
>
> Andrew - This cycle has been crazy, speaking from point of view of somebo=
dy
> doing a lot of review, it's been very very exhausting from this side too,
> and this kind of work can feel a little... thankless... sometimes :)
>
> I feel like we maybe need a way to ask people to slow down, sometimes at
> least.
>
> Perhaps being less accepting of patches during merge window is one aspect=
,
> as the merge window leading up to this cycle was almost the same review
> load as when the cycle started.
>
> Anyway, TL;DR: I think we need to be mindful of reviewer sanity as a fact=
or
> in all this too :)
>
> (I am spekaing at Kernel Recipes then going on a very-badly-needed 2.5 we=
ek
> vacataion afterwards over the merge window so I hope to stave off burnout
> that way. Be good if I could keep mails upon return to 3 digits, but I ha=
ve
> my doubts :P)

Hi Lorenzo,

Absolutely, take care of yourself. We all appreciate the  amount of
work you put into reviewing :)

Have a good talk and enjoy your vacation. Don't worry about the backlog.

-- Kalesh

>
> Cheers, Lorenzo

