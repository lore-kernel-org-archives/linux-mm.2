Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38457CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 16:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FD18E0064; Mon, 13 Oct 2025 12:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DFDD8E0009; Mon, 13 Oct 2025 12:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF1F8E0064; Mon, 13 Oct 2025 12:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 486098E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:11:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE9F5140556
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:11:41 +0000 (UTC)
X-FDA: 83993581602.01.DF7B856
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2202C1A0016
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:11:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Iw6W6lL8;
	spf=pass (imf19.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760371900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqOTihtF3LWBkyrOGHrf9dtz4pV67L7r6ac9tYX6C1E=;
	b=xWlOyb6SsB7DnZxcuVcsZyvZv1j6m31ngMkSyuPVXRDvj8JnPPRriq41RrdIeSIba2eewQ
	LxsGkjifikwvU1KYN8+fUCIXMdjgBlMY0r3Cih43gjEc3pYwEV0ZME2MfL218ssXiAuBDb
	J07VvzBEdtMfgEVaRtu1CGU8MHQk2tc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Iw6W6lL8;
	spf=pass (imf19.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760371900; a=rsa-sha256;
	cv=none;
	b=YIqnHJzVagT+ht8T0HRxFkSmsEF4E5qa4IDbj0rNn55xxVKPcJGgn7EhUkcUA121JVVhJV
	XXsGq8GM7JGyOb4IPpu/UIn7SH8VuzLAmc79NrP1BI1HrgtXJt7W48GMtuE9eMu+iJHHXv
	IWM6TPh7w9XpB1mXbYcnZhpLDYpZfwk=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33292adb180so4278524a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1760371899; x=1760976699; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqOTihtF3LWBkyrOGHrf9dtz4pV67L7r6ac9tYX6C1E=;
        b=Iw6W6lL8UkykX/55LosnZtdTVkEEUFQy7PupC8LwUkNhYyHrlRSSzrik2BsKMIZhkq
         iPaik1A5Yxty67M+zZiWN0nu7WTlcRiQnsY1R2xBXtKISEor6Nh/XVjCZprUUPaadozv
         d9uqGCIM/9OaxBlDuybPjaDy5L917FjrlmDnZiq/QO777a+dhAUdS7ZBKy2YcBaKZZ/E
         uoEBR1ipacf0PVI01HOv2T+kzlRzOtZe+F8/s4DxLEivKksOOmUggf+Fbhva956Q25X4
         +vopWRVKGzzIwmEVzOZcVLqn89MNdniuFF7GljFKS6p4sGwR4uznxjJkdNH1Ke6L7tbZ
         /uKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760371899; x=1760976699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JqOTihtF3LWBkyrOGHrf9dtz4pV67L7r6ac9tYX6C1E=;
        b=h0+NIDCEv7ESrrhL3MsgXPxn4k/Z/ZD9cLNJEfui0hbT7FiZgL5OCw1MAKkbCUBNpT
         tFHYo0h1wS6g51hWksNiej3L9FZFQ/Rn9Bg1YSD4USEl/NVrAWkeXa86axHgNhxVRFJn
         /0DrpzsIeoqZ1gWuEjdKiel6UoFfD1M8BfGxVrYlIf/RjXYvP8yM+TY+iapVavrAhziX
         hOmwcg/sm/grdfOF4m4N9yuOWCqud+MXyyPxHqHOH/KDG5+hF1rtHH/XZV/xcWMAcOht
         7RDsW6/1l0jppPuDCmV8ULNxsq3rjWHQQQjGIiuBEMeiC7O5zvxrqbt/6JBb+1u5r8VI
         vN0g==
X-Forwarded-Encrypted: i=1; AJvYcCUniHZG71EkZowJDfMHHHDL5bU5F9i6lfnjY/VG/hiGmNQ0gGaCR2At+EQzp/EPSrd+Tlme5TDU7A==@kvack.org
X-Gm-Message-State: AOJu0Yxg+AgcWBcf8EeyHX/3GsVhRXVXA3UlCbyoQcMRv7uNa90v+he9
	LPnsQygj65RvTDhLCnPGO9km7xFUzY1QZ2B4hdgwsl3k9/YK/t1UzJVg1nNwdB+15gjVOkLcx1P
	KWa6IFz6e/8OI7z4uII7wxqxQbFUiItZsS9GS6phO4BDkFwsZ/TSdsg==
X-Gm-Gg: ASbGncvnggmGKWviLdkVUUpp2P4p3u0JdSya1gaeaQwutPHBEiPNZvH0d704tmCYVZ7
	7cyEo4b54CqsjSbe421SdNUGhN2GDSPVeQAantxjXmcXKMu0JNrui16D651skOK88wSNu/BQbP+
	tmAL21RfvmnPwo/yuuxeusbCZ4BZAAPa3G8S6Cz3Be4j+dYEg2cbrnDDVx7kzl4rWoUye8JvJvw
	l4w7BreSoZI8k1akGu9Vgkw5g==
X-Google-Smtp-Source: AGHT+IHRsuUk9qzBCL3fBbXKncdyg4e+WegpXlz1W9aKK5q8PTZ1CSe8HMgR8w4ThEmt0m0Vt2wsoc3RPFAThEuvYAo=
X-Received: by 2002:a17:90b:1e0c:b0:32e:749d:fcb6 with SMTP id
 98e67ed59e1d1-33b51118ef7mr32930909a91.12.1760371898906; Mon, 13 Oct 2025
 09:11:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250918020434.1612137-1-tweek@google.com> <CAHC9VhSbWJ-8tj5BxSTxznGO8zraKRSE31a+tqdfMHB53ef-MQ@mail.gmail.com>
 <CAEjxPJ5GidA9oT_fbKRe_nH1J3mER0ggM-dBW=Nuo765JDuQKg@mail.gmail.com> <CAHC9VhS2TU2GWgfUOHerbfjyxb5QZMSMqLdQirjSdkUohR7opg@mail.gmail.com>
In-Reply-To: <CAHC9VhS2TU2GWgfUOHerbfjyxb5QZMSMqLdQirjSdkUohR7opg@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 13 Oct 2025 12:11:26 -0400
X-Gm-Features: AS18NWDWa7MaOMrTZEmj_OT-vE-kCVjZdzIYuzWQVFZrpDBS2O2ZFbNWHUYu4oU
Message-ID: <CAHC9VhTSRkP=jNw8bLRx5em6MnX9HTywBqXGsJCBPQ9MKJym=g@mail.gmail.com>
Subject: Re: [PATCH v3] memfd,selinux: call security_inode_init_security_anon
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Hugh Dickins <hughd@google.com>, James Morris <jmorris@namei.org>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2202C1A0016
X-Stat-Signature: 4cc6ofsuwwxe419r5tnzyyks7aessmig
X-Rspam-User: 
X-HE-Tag: 1760371899-753772
X-HE-Meta: U2FsdGVkX1/3yO5kA7v9ymYnAHR48lmRqFPLcSTFyj5P5ZclaNUqpdgYRIBbZUT2bv9DaYE+wT+CXGXQXEY2AqRYUiN+EymihUnPfshle5BCL+2JWuLZy+1ypmkjmTk/SyNElwToe/ZKB9j/GJWSJlqDauOXnUyFSR7gG3Ou3m3i/2ubXDLCfTa3C37FqogsK1mSByBXnzFQ5OxdZ/Mxy/z6F6MonoYMGM4K42s1EL6qkBizBe+m1Sjuj+xMPgdvTl5q8fYEP4K+1h1E2rqySR0zXzdzv1pkQRsu6vXtsWCAz+VbNMWzzKO7y/tG7dTFgBdoVAacBQvM+i7VL8QtwLSMsapWqGDN5xQCf/egxYudCC++cD8Ow2XmV+qckRJYBmTod/dLH3cG2PfvT4f+HXe1LI8eNqk1bqGuyCuFOOc8H+pt1gCUxgeTGz7Bzvv5JA69MFR/dgI3FAO2w2H00hK0Ne3ENR2Je+dnzoVW/TydG2MCk5RkJusuxZi6nII0w0Fv08q2vLGKSlsA7ikREiOU2k50/qRo5QbKyaw0cAeNlOmjA830Hl/JSfyZsnVgT1j2QbkptWSBmD4ELIWJ5LEBfFIDnpNI3V2lqbsSHnH+kjgclHofGggHWHiExidQa9lKKlMhSV49ozzd64F8cK/Q0oHpap1xW9gPfLZGkm9hUjkc/PTuTWfWZDzzBqcE9DzpG6TTn1ywioTZNuX1sPyvuHxXI7kWrgROwD+qHyGK/9LKLu7O0OIvkVukvqfvwu3mX7Zc1cPRXtnKMXh4z0Sv04fJTR1NSXbkywDXhFSs18W5Usy7JcKRBC0XyUVxD7FfZQVMnTY8sEcXZaVE8QI7Oug73MQmwo8wufrBBP5XPWNYHUHYUCyZYr2LeIboybETJwK6BICgi38enddFGbvyQaOucIbd6UcbL4bbMM+F3uqGHW4B7KgNwWetQxbrJr1Qeea6BxbdLt7pRtB
 DmMMya0q
 EBqt0H6rM6pKigZOg5+ia614NRBAL+/GABoUNvUvo2dtGs8WpTqiUu8fn6VKEenywUQNQyGeaE6jTaWq9DfrpYRFnLvNYqpTOoMHBlpfizMNAdyRNbsz2PavOTem8TJ23hHnFtklfIJXa9G67xbdr25fNLGd/Q04IkCQCKDjTVRx7in0yod6ZPlsL3KB4fML458/Mc5YLZjKRmoPmL57K+XZMWuZW5cYT0LAYl5p78T4WhtDv1AnczXBY5RFITkfN9Qkvy/YtV75JaDVI3DvVGrbdtes07npLqEzEqGitHCovt7/IMVK8tsxF/uquTUrkkWvnGmhNb3o+vK66GsAzWDD+weRJVO30YrFTou+YzvuaRe/ibFngnzkVXlJjgU1lpxFZukWidaOTWTAhP/MnGp/K2LnC3Y77Orgz85inqStk6S8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 3:30=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
> On Mon, Sep 22, 2025 at 9:12=E2=80=AFAM Stephen Smalley
> <stephen.smalley.work@gmail.com> wrote:
> >
> > When would you recommend that I re-apply the corresponding userspace
> > patch to reserve this policy capability number for memfd_class?
> > After it is moved to selinux/dev? Understand that it isn't truly
> > reserved until it lands in a kernel.org kernel but would prefer to
> > reapply it sooner than that since there may be other policy capability
> > requests queueing up (e.g. bpf token) that should be done relative to
> > it. Can always revert it again if necessary, at least until another
> > userspace release is made (not sure on timeline for that).
>
> When it comes to API issues like this, my standard answer is "tagged
> release from Linus" as it is the safest option, but you know that
> already.
>
> The fuzzier answer is that unless something crazy happens, I'm likely
> going to move the patches, in order, from selinux/dev-staging into
> selinux/dev when the merge window closes.  This means that any
> policycap API additions for the next cycle are going to start with the
> memfd_class policycap, so it *should* be fairly safe to merge the
> userspace bits now, I just wouldn't do a userspace release with that
> API change until we see a tagged release from Linus.

... and the patch is now in selinux/dev, thanks everyone!

--=20
paul-moore.com

