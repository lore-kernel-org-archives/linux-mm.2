Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182A0C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958556B007B; Fri, 25 Jul 2025 15:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909206B0089; Fri, 25 Jul 2025 15:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81EED6B008A; Fri, 25 Jul 2025 15:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73E2E6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:11:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CBD51DA647
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:11:05 +0000 (UTC)
X-FDA: 83703729690.08.362B79F
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 97C56180014
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:11:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4lwg1tWz;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753470663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohbQ5KF8b/EeqfVu3tRLb4Pn8KVgHa3I47YPvi58yJM=;
	b=JhlasPf4JS//uWE4JfBH8eEqQPERIwqAwuPkjOYSDgyLxCKTA31KfdsZCiWHaa41xoYKLy
	Ad9zEl+ws32sy/rhSFDuD4m6rYc2yccpGPMLIvrJecnhAtkFpo4OvUxa7ElJdkMT4kruTi
	dLI7ABOnnHL+xsBebqyvZmYw2Xd4/Mw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4lwg1tWz;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753470663; a=rsa-sha256;
	cv=none;
	b=7lvfgZCfcf72eysQs1qTUyKhJpgmGLkIdUqOACULEN/VwA/C60ShFMzgQhdTxpeT5Fn4cD
	UUcw53HtgNiwHpP2sa6VodVWbi6kN5tBE+VPm83LFRuhnJNg4j3IOe4HOtbr41xL88Kw+a
	NJZO8UShbjuJ9Md2owaXI4voKUTPq0c=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-611d32903d5so2118a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753470662; x=1754075462; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohbQ5KF8b/EeqfVu3tRLb4Pn8KVgHa3I47YPvi58yJM=;
        b=4lwg1tWzM9+3J3s+Ksvui74px5oWdzrww85v88+Ifq9O/fYNWrEEwMPSutGQDaepFH
         YgTXTmUGo1Y1w7Q6hhlnPFtW+VWm/z4k98vw1fRAf3acm/MeP1qI3D+h+t0fbnmAb8OH
         +R8jB9RWh9qf3rjFXgY7iMMyy3F0MqI9gOp8FWBtLaaS/+HuhVSTmbPfyx+PxdDvSAD2
         wfKatKbhRITP3d84QKUj53JSInWc6NoADYhVP07ZfbkiUwv3d4S91U93pILhh5O5b+09
         5uL85/MI5ymELDImPMXLHAI5sIoPQYbSg3ec/4poaMw8ogdkmb3HzakXR1noq2ClxbnL
         u0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753470662; x=1754075462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohbQ5KF8b/EeqfVu3tRLb4Pn8KVgHa3I47YPvi58yJM=;
        b=UQEpJSWZOyt7XIZOBSt+zAhJlpmujWgtOSyrOxHbX2ek+7fLx/sLhJbHNyqI4tD535
         uSQ84Lic63b2Rfu7t8Wje5nu/JdRkVVmhZuGP525tM8RhXYy8LSppP0+KfLhnAUkE/7r
         FPylhifg1rwb2yCn5oV1izFnWXEe93xG+mZQ7ZFTxc6G3VL0cXQuI8e2drpZWg052V4P
         lbBbkJZ/y7cYI4CfY+6wwD/7mAkuho2zOb82X1TCa1JZEmuYPAEsAwdy1Mno6h/81e4h
         BesdTQh21gFkutCZGzsWBYpoQMnGETk/SCUEhAj4BP1xZERTE7wMklGAywuk6xBBGG52
         6w0w==
X-Forwarded-Encrypted: i=1; AJvYcCWURIak//QpwJ3y4zXCO5cJ9BPhZ6w2xlvuELfKDssoye56EeIesY1NcQv8QrGMCWgVpqJHPIt4VA==@kvack.org
X-Gm-Message-State: AOJu0YxewdNWIFK22aMD77C6B41yu4SAWrMMK/3TTrAw/2gwkNLvv0pN
	qO2whL2qWPWbvraPIaDi1lc3TeqX54SGG9pvuuNUgzRQAN/Sk5cJzlUrBMoE6k9IOgf+FDh9t8w
	Qci5mfDvb1JX8OklS3o34/F0wd78Y4gsbH8reA1JR
X-Gm-Gg: ASbGncu5PxynbvGRPaml3vv5Plhtg/9xyyBEi02SS+cigFJVqHKBbx+YWh4H/fWqsHU
	2lWmkEgDNusiohroe0QZR4McSPg+FM8XTC111lndVRQO085Uf5aaGZEl6wYadnIW7Bhsw3tJCZs
	URdyVaOo/37zbUCoeQTHwrNFh7boS3rORQTM+T13JzjFCieiMqWjxIdBEQA4sW+QRZXgsa8nGjG
	QytGu+ayBKmxWj91rp4uF1NxgyeDlr7kuM=
X-Google-Smtp-Source: AGHT+IFnM9lb8v0yhy+r9g7LlejQ85g1+jN80aPjt0EXGFDmgpf5XaZMiO20Q6d8dkFVzoj7t44+LzAH3gV+dXXjqTY=
X-Received: by 2002:a05:6402:2088:b0:607:bd2:4757 with SMTP id
 4fb4d7f45d1cf-61505ca9e53mr18025a12.1.1753470661523; Fri, 25 Jul 2025
 12:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752232673.git.lorenzo.stoakes@oracle.com>
 <8f41e72b0543953d277e96d5e67a52f287cdbac3.1752232673.git.lorenzo.stoakes@oracle.com>
 <CAG48ez0KjHHAWsJo76GuuYYaFCH=3n7axN2ryxy7-Vabp5JA-Q@mail.gmail.com> <892e3e49-dbcd-4c1f-9966-c004d63f52df@lucifer.local>
In-Reply-To: <892e3e49-dbcd-4c1f-9966-c004d63f52df@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 21:10:25 +0200
X-Gm-Features: Ac12FXzH0kaDd1FSHQ6rjBvK5l93OfpQZvkg8iFQz3nK0xtBEz9RE_fXG7JCCE8
Message-ID: <CAG48ez3qB7W3JqjrkkQ3SRdQNza3Q9noqkgmBg=3F_8vhwQ4gQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/10] mm/mremap: permit mremap() move of multiple VMAs
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 97C56180014
X-Rspamd-Server: rspam06
X-Stat-Signature: gq6e79ph6a3bkkqpm5ghxbstcgbhur1t
X-HE-Tag: 1753470663-489781
X-HE-Meta: U2FsdGVkX1+bHsVRn7eZIP5nJXr2uS4VFKkUJji17DbED6l1H0ktmpofX/WucI3vegF7hWzFCpYc0ES4Ojq3YvESVCRY7ilVq2vJv/LcFbduEnCERbiBGowt669jbD1XY801+fPUqAxxSO2l923qN2MkvMO440fHxxL1inS410LSCplhhzymVCoE3JhfDVIdRrSPK0DPcTe+BhsdIg6Q+SMPJE6BFJA5Hoz4vjWfIh8ca4KK7n9lf5w3pFOTYAyUZ2sCEt5wQ9oaqYmln5oPA7V/i9c6koE9tKokEOyXW0Ih5cLOAltQXdy8ZtHP5cLQ5rl0HmQriXRZ0NBkCea7EY6ElwYFzMQqNNC1kZfoQ8JqXy4Z9I8UWXAcaENKvoHqPMzq3/rn82c86FocfLEGZRxC9dFELl0qwF+BZaP/vxmmO2drd3jW1/or79GWqeT0KfvO6qF4jMS82XkwcKQOic4CmEO8niIBUhaRhlCJ1Xyo+XGYH+N05oa4J/KZqCMHr8TvMlU8Hrxx23hFI/fSRu+kj6JGIc+L2S+DD1EslInnqEUy7uIYHrDEBsKNtekuEGKchhatRbM1Zp4Op952j0EdXNMuuQFlPK/y/NGH1UbQDn0DbnAO0uUZJTqe5BBByhODgGmhBI7w7Js0xgoNbVvu1sQ8qDTKHs/woIGB9iX3wtO2z2lirVmQXxtcpJoDsAgyNo82S/CQ407746T4rkTh9GcRRL66ya/N5Lncw2F2IugRpurfTcupbQEh0+SBMPNLjPEr//jXc57gy0d3+YXVTqUW9odGAECvAUGNOSXOv+b5SkBqItLV2oPWBixCfBORbEbC4R/MGyfWby+fvAUKtq1YTKr2hHU8DpJjGPMPP7aa3sqNkteBKoI201UDB8yLuXyg3UX2B9GZsPOm7Yw5GlxXYRLNei353pOxBl0iJkFaBmKVPlbVSMnfmIu0kGKSdkdqrxD7hY0bGfE
 dO6wxz4h
 73yt1UGhJWWC1YmEZust+tKTnRItWNeicib3FOlETFh8FntRJ2OHSYkYp5TTzs72mCUdpy7REePdB3gZU6oSKQRUICkwx+PSgaVG9MMNpceNf3A/AciJpD+sqDCGGGk0baVkrX73SyUlbPw/j5+A4zAxdU5/pOvkncc0Izt2oVU2R9ISLrcaljA7w6mfadQrlYp9lOur1ummgeGU4UE9W5YXxMSQAYxVs/7dl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 7:28=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Fri, Jul 25, 2025 at 07:11:49PM +0200, Jann Horn wrote:
> > On Fri, Jul 11, 2025 at 1:38=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > Note that any failures encountered will result in a partial move. Sin=
ce an
> > > mremap() can fail at any time, this might result in only some of the =
VMAs
> > > being moved.
> > >
> > > Note that failures are very rare and typically require an out of a me=
mory
> > > condition or a mapping limit condition to be hit, assuming the VMAs b=
eing
> > > moved are valid.
> >
> > Hrm. So if userspace tries to move a series of VMAs with mremap(), and
> > the operation fails, and userspace assumes the old syscall semantics,
> > userspace could assume that its memory is still at the old address,
> > when that's actually not true; and if userspace tries to access it
> > there, userspace UAF happens?
>
> At 6pm on the last day of the cycle? :) dude :) this long week gets ever
> longer...

To be clear, I very much do not expect you to instantly reply to
random patch review mail I send you late on a Friday evening. :P

> Otherwise for mapping limit we likely hit it right away. I moved all the
> checks up front for standard VMA/param errors.

Ah, I missed that part.

