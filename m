Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593ED606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 19:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JNwZmfob
Received: by kanga.kvack.org (Postfix)
	id 7200F6B00FB; Mon, 19 Oct 2026 15:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7A46B035A; Mon, 19 Oct 2026 15:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6354D6B035C; Mon, 19 Oct 2026 15:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 405206B00FB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:53:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2F241C41BC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:53:18 +0000 (UTC)
X-FDA: 85340424876.19.3B8AE2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EF6211A000F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:53:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNwZmfob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792439597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyY7JNrqiai4abS/gqtvGdCXTYu9bu6Za3R7laojQRg=;
	b=073O+NEtHHlQPWr2j/bd3FR7NCtrkgty2ziBcbrR4EdIX4nzlMQvHBz8xWCiqt510+l2ay
	hjz+Pqgfd2+nab/QRAMvMKJECMoLMtLgETKAvA92uxpBfarmbJPJTwp8QLtpabWm2RQj/j
	s2vkIygdyEDjsKSfidTDRU20DEmkJeY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNwZmfob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792439597;
	b=M0iccIYZzJritB9sZ7/XhjkivbvMrVaAk59t++WS4WgOQpJqZXH8O82bpAYnb6aTOcIurZ
	BYS3RvNreTD8NmdP6XD8U3Z48OlD+r2Ou5CoVXWONNdodyOYO3faRR6NyXo50LARO7rYSV
	a1q0J1FnzSOfTtADaqxmPFvi9yqE/Hk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FDE560210
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9DE1F000C8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792439596;
	bh=dyY7JNrqiai4abS/gqtvGdCXTYu9bu6Za3R7laojQRg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JNwZmfobCYy44kF73fLPY3nx2mQpel3uc8oCw5yPeblOK9knkM7xVo/+J9D8Iq7bu
	 /iQPRLEf22B1WMVJG4qUjLLweblmu2RuVgTpQUS1XILp4cAzI+lcyrtvezARBYnkoO
	 PrE6DSv+IJafrFiSHGYTBNzfB2MbBNAs/N8BU+axmotJzpmeqs104le2tTMJoeHeVp
	 1xuj8vb3rCtxQSkiIfEALrtAXehbiavVBYVjxb62W2RbsKO9mmx+2HOSIQ78fhyDzB
	 mJmZQgH+m/0TWSGP4EDkA08nZl1EVzRZrtqMLivYRhtmHtTsTNdogjD0dleMijjE4d
	 HhdwzF0pz/7xA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c34bff61551so352349566b.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:53:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy62gaTjl7PQVczXaGOH8/ZG7P/emyqStnYklWisbhN7WQEmieL/VYBmWMjTBtDCfGlqj65nJsH/g==@kvack.org
X-Gm-Message-State: AFq9FYKmOnxGegokkPg00f4N42cN2X/WeBxB6B8OJSrj7U/c7nMgl4W3
	P7V9miVhXXCqDaIaotOK3q6nbOLBt3i4HZ2EM1qOpylR+Z85etxGa2oPh8HMgmT6OXapXYDaAke
	T445aaAYI09/4PDTmkpk/FYWwu0rIOow=
X-Received: by 2002:a17:907:9346:b0:c41:8e21:4d5a with SMTP id
 a640c23a62f3a-c4199c63959mr703570166b.5.1792439594928; Mon, 19 Oct 2026
 12:53:14 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
 <atI_yuCc4BiweBQP@google.com> <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
 <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
 <atXXma5NXxoSWJO0@pcnci.linuxbox.cz> <atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
 <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
 <CAO9r8zO41EromgLGhKv8H0aKXjrffH+t4CFGU6cLo59JJ3CEuA@mail.gmail.com>
 <20261019105844.02d4623b7063fec25ebd34ad@linux-foundation.org>
 <CAO9r8zN1dTJmULsKCwNrNr_vKyrV+vMfD7wifQ05uAti7E-yDw@mail.gmail.com> <20261019181510.GAatZeLtUmU3Zy9VZt@fat_crate.local>
In-Reply-To: <20261019181510.GAatZeLtUmU3Zy9VZt@fat_crate.local>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 19 Oct 2026 12:53:01 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMdLN+wms164bs_c5BfnrYZoNAPz6b6hcODt1JnUMniVQ@mail.gmail.com>
X-Gm-Features: AclHuK9WexEVPWPjZM8Xg7vW7SIGXnR7j5todzSpiBgiM_zmWuBHXiwBEKHuGRQ
Message-ID: <CAO9r8zMdLN+wms164bs_c5BfnrYZoNAPz6b6hcODt1JnUMniVQ@mail.gmail.com>
Subject: Re: hunting memory corruption bug in 6.18.x
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>, 
	Sean Christopherson <seanjc@google.com>, David Laight <david.laight.linux@gmail.com>, 
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com, 
	pbonzini@redhat.com, Tal Zussman <tz2294@columbia.edu>, 
	Matt Fleming <matt@readmodwrite.com>, gregkh@linuxfoundation.org, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EF6211A000F
X-Stat-Signature: 66khxem4qtfq169thfu6mzjsbyt1worm
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792439596-317062
X-HE-Meta: U2FsdGVkX1+zKMo9Vd4NJ5ZJC4aNknJkfrVfEduFRsks2SBsknx3r4RG+owUc2sByf4aAVmyJQ1bgm35VIeCY+uUucl3smalUru2eWLCQQlQXPNAtX/36+DFH7Y6Dj/N4tBdfpT1sIfqM7Mxv3S7ISWOn44x9M09KIIRS+ojcAONtDrzS6PYH/lqSgYgU79WjVJ8u9OjRaMuxslwHZ1ROmjWJ7jTdSX1UdrLdD8igg+i1brFy1VDQPC8vf04faWNvl9TUwJo91Otwk4BdeOZ8EedXuMfJacjbfUjkWpXpu7C6KIuDlFHhmeN9oEwxjncD1KKNAXafP73dk5QWiEVIc9IFcLvCVJSpey5xpPxeN+zJQwXa0eUChUjExb9oYh6IZjHGrh7MuUJPepc/eNxzQR87o1l7wyQ9qL/hjiINdBJaVkW1OXZ8vFcA8RYepfpqmFwGjwXfJLiiz0LZF1qC4MEy19PBn2yYkwt331wjMeXn7tb20CVSte0Ir39Z5D9Gh64nyUowIoPsmlxszAXHimdjruEsF8AFDUvzwax26I4p3cnrZURcLy+kogq6lga3DaEEUOppuuwKs+SRJm5m+SjiwOUcvjGZviMugj6RqbwvvfZ7hGfeyOMQOSsiq8TnPSd2rSPSjWINShkCo8aRL16zI4DHnHKqkEBiFopp7OfD+zta/YZ+InubOXA3/UuX0xsqjI1TuOKCIamo2/F4fmPOdAq6kMTaF3aK8r9DdLINbQjfoFbYz4CEIds/xLt5sw0wXPA7kF1Fgul9NYFeVvTLveQASEMPQ9bY6NrdGD8yeccIK5lZJE5ZbFGspzNnhs7v2vsasu+XsvydvsTUGQ+QBkz+sgWiaJQE8TByNcB4IHEpt7jg5DEEUNMs5N1kaJChoF950Ewg+gyyhn6lkAldE/HYdPCw52yJcdXuRY9t35KwVhfkDPRErXpqqDp3L7hkuBirEMHmMJyNxo
 81Drx+EF
 dXP6TdjqMddF9AATa4oOhy4AOXzxtiujVGMPJts0sxljfNKmfP2rO034qFroNR6dpojeGZvp7iurHxW/pKqgWKzFyqrZe+Uqebmukbg6sN0FEN0zA1Nl0JPZqBTDPb8jknrBa32ZdHkUQschgsw4FzeC66mYY1ajypiLsA/xaiIlPrPXxpz3snH40q94iuyufSYPMBAngJOMPS56c/HAVz8nlM/UNG8nsaNOKdTzuovwm8Nv6uu56byan88b+Hyo0Y/US8TJQJ79PkMggT55vO+OVyIH1hsTpdPtBSAbB/KCUReNM/qsgzKj43EgGsKLmyoiz+rNHRzwhQZo5yIv/mkgUsCPv57W03LDoCVKPAhRGBm3fRVs1KYLDrnnH14YMx5GmJ7NsMlDVYNncyi/jXaGVzELUVB6qoQHxWqxp2Emhi3P3uzenVex2Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:15=E2=80=AFAM Borislav Petkov <bp@alien8.de> wro=
te:
>
> On Mon, Oct 19, 2026 at 11:00:00AM -0700, Yosry Ahmed wrote:
> > Right, but this is for new patches that get merged into Linus's tree,
> > what about existing patches? Any way to retrigger that workflow?
>
> You take your patch, apply it to the stable trees here:
>
> https://www.kernel.org/category/releases.html
>
> and send the applied and tested version it to <stable@kernel.org>.
>
> I.e., you backport it yourself. :)

Will do, I have done manual backports before but only for conflicts. I
was more asking if I need to send the patch to all branches or if it
will be automatically backported to the others if there are no
conflicts.

>
> Do git-log on those branches to see how stable backports are annotated. I=
t
> needs to say:
>
> "Commit <sha1> upstream."
>
> at the top.
>
> There's also Documentation/process/stable-kernel-rules.rst
>
> HTH.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

