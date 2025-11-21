Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3082CFC510
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 23:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96036B0024; Fri, 21 Nov 2025 18:07:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DB26B0026; Fri, 21 Nov 2025 18:07:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83036B0029; Fri, 21 Nov 2025 18:07:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C50516B0024
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:07:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE504130161
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:07:25 +0000 (UTC)
X-FDA: 84136152450.30.8949775
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by imf11.hostedemail.com (Postfix) with ESMTP id A9CC440008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:07:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=otxxdykF;
	spf=pass (imf11.hostedemail.com: domain of ryan.lee@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=ryan.lee@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763766444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mURGdZgdGyl5h9hsbUzCtRvDVWH4yABOB0i1o0xgZtw=;
	b=guP0QPGJYh3DZCEkMdo0XQSFKltvk7IhUjTztnz+5HFU/TKcXojJOAefpfqBFt5ULgRHSk
	L5DsYtdKMoZa7PjzQvMyQukMJlR+xR5jE09XY3SaEtSKwuaIARwZBzSZRofxq1hS8fEpdp
	pzvV5+KjHYlgaeZDi9UR2doPxGfs1og=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763766444; a=rsa-sha256;
	cv=none;
	b=lATnygVsJna5aMkbWeBYX1A3W0LIPrfMHLKS5j8+4R7jT2B/nI78nqQAI/hjD6qDynR5OD
	9CpUZ1QkP9UDuVViBSpx1WlXLqb4zPJnvBi0N6oC5AuTVMfa6CLDJyMQieIPQMXDSQvQxx
	+bjvXWRWTo+GMp7TCTBSQltALyy2wBg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=otxxdykF;
	spf=pass (imf11.hostedemail.com: domain of ryan.lee@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=ryan.lee@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9020A3FB91
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1763766431;
	bh=mURGdZgdGyl5h9hsbUzCtRvDVWH4yABOB0i1o0xgZtw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=otxxdykFtRBhDU2v2lxpyRd+7UvBDKlLcIUemkCgGLPEBfKVZljGPXbj+axYT6Fdz
	 bpkK5AHMwRc3IAi5yrCmwSNEfaFKxR+/7sQN5EEEoxob+ynRVCh7f5GksvPBYOqBIc
	 kzChTNC8YsMSeujRZB//qNcTRCwE6juyxkmcNnNg9IS2wG/fti3KgiZb5G6C2thcPX
	 7MmoNd853sb/KLQivYVZPpC5qZLMd9At+amc799pZOl9JWfXW7slgnng9s3YlNBKRE
	 xYvU/NFR41wfwW0YC3slPcihHI9TwgbuLE7Gn0JiL99rkzJJ973C9O76ltK/N+lP8Y
	 xhP8U79KqU50iQnwOarqfm/ghR6RjsuANKLUjTERuujgp1ugvYNelH2tE36GyArcM8
	 SWZLBP5SxKahm5G0pXGoly7zkA9+fBJi2MIkCvxMMf1APdCovqGmAT4z+cXSKYp5td
	 dkyeHoQ3wJRMgpGSYDUs63P4VjQkS/36fe6zknwq5VKP4qPmmD2jTtoHIxMN/msmU8
	 YYuBMTKSmTTao4QQIqT2oOfdUKaXrfJQz/u7a4voidfvnMcEFqnQBbteYFuhguVs0o
	 +s/QXBJSnMwMXA9ElhDuO1Gy4qUQh1s+mTFJAF2QQKvHpgMieYnQwSZQwGR/KrwSyE
	 K9oUOrk37I1YSRloiA/5OhW0=
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78692e4e1faso69193347b3.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:07:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763766429; x=1764371229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mURGdZgdGyl5h9hsbUzCtRvDVWH4yABOB0i1o0xgZtw=;
        b=XP+zVGBjFiPP+B4u7xZhLwmRG2dfDBhuPT1VdNJpswuCfXLpDmpveFDNhbP9GqXhHt
         F+0SVlqKv2n/FmdGkfG2BT5tyNCenrlzMtl1ttsshYd9eI3mIxmeg+8A3TJETkebl7b1
         vQ9wlDZhd26ObRNlNj5UGf93W934mqV97BD7OIdbo/DgudVYGiB7oMjBaLsiRylbK4Uo
         h2GrAWTFdt/L2tlmgoJZw+sB03AbctYg9TXG+/cyB6Nyv76/D78JQByhLA1g3Z4dgyJh
         GWibZPkGXlG5TPe4gvOkyGg5aOmZfng+LHYyXJD/qPb7V/q1aPf1ugLdGbL61utA1FSo
         66dg==
X-Forwarded-Encrypted: i=1; AJvYcCVu2n4uibGhBS0/sGVDrKl4xjACfVRcRM+9fBPC3Fwvt4OiunEXGXRlxHw0PjpKl3d85T843Ek9wQ==@kvack.org
X-Gm-Message-State: AOJu0Yyti3IyezATw87e2pXrcPJqqrCtYQnsYGPxW60eroxIU11BQ6NO
	Y1LVC2C5InSNERlAFpMvwRfF8Psklte4WGFuUhR/yTI518MTt8FeHovhhThbTB8JL7CTxxuqgwK
	m7eWTAlEfGtelgzTG82Klpv4Ja9l79MslHxQl0XRqoRFt5HJWFP6K+zbXuHXs5ltqd9//6+pcKY
	aIYIPso3ccLiM6DwTHi7hZrPp/Yos+Lxc60JS9iJKrx+w=
X-Gm-Gg: ASbGnctJQorL5lYgMhUM974Z6OaBvbH737OpnMo4LTG3EMIHvvyHdLm1gKnfuOLo38C
	mAa7jONgHSIAzBbiEGzF0wliIC1G9ZjBuQd0wh66OuNIfp6Mj9Mn9Wk3KRrM6yOODfCAMTKl9O9
	Lo2TUG6Oy7/ew77L0ZKb6MJRAgu7uBHfZFtNsRaD8sN8n7UZkF0NNqG4EhuSZznivpnQ==
X-Received: by 2002:a53:b10a:0:b0:63f:c019:23bc with SMTP id 956f58d0204a3-642f8e30acamr6393267d50.27.1763766428803;
        Fri, 21 Nov 2025 15:07:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGNbsczd5MfsDryDTrdB8miQHCP9n6FhmNbRk59/WbSb6lt9I6iTtdnnpp053CuQIcThR+YHVO/xZ+HKm10C6g=
X-Received: by 2002:a53:b10a:0:b0:63f:c019:23bc with SMTP id
 956f58d0204a3-642f8e30acamr6393202d50.27.1763766428362; Fri, 21 Nov 2025
 15:07:08 -0800 (PST)
MIME-Version: 1.0
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <87tsyozqdu.fsf@email.froward.int.ebiederm.org> <87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
 <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org> <87a50gxo0i.fsf@email.froward.int.ebiederm.org>
 <GV2PPF74270EBEEAD4CACA124C05BE1CE45E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <87o6ovx38h.fsf@email.froward.int.ebiederm.org> <GV2PPF74270EBEEFA106F4EF26B087ED898E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEED0840E45459881C0EDD4E4D5A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <87ikf3w5us.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87ikf3w5us.fsf@email.froward.int.ebiederm.org>
From: Ryan Lee <ryan.lee@canonical.com>
Date: Fri, 21 Nov 2025 15:06:57 -0800
X-Gm-Features: AWmQ_bl4fHuqSO33WuXiPW9zqHuMd1nfWUHzCuIgifbxs4kTz1ezfJlXQS9fZjo
Message-ID: <CAKCV-6sH03G2xuZrhqEMExx-AAKPZgQ7Z1BnDgV5HimFVGCWwg@mail.gmail.com>
Subject: Re: [RFC][PATCH] exec: Move cred computation under exec_update_lock
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, 
	Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>, 
	James Morris <jamorris@linux.microsoft.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>, 
	Adrian Reber <areber@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexei Starovoitov <ast@kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	tiozhang <tiozhang@didiglobal.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Frederic Weisbecker <frederic@kernel.org>, YueHaibing <yuehaibing@huawei.com>, 
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>, xu xin <xu.xin16@zte.com.cn>, 
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>, 
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>, 
	"Joel Fernandes (Google)" <joel@joelfernandes.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hans Liljestrand <ishkamiel@gmail.com>, Penglei Jiang <superman.xpt@gmail.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Adrian Ratiu <adrian.ratiu@collabora.com>, 
	Ingo Molnar <mingo@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Eric Dumazet <edumazet@google.com>, 
	apparmor <apparmor@lists.ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9CC440008
X-Stat-Signature: 7st1osioix4dkxr7x5tzjz9pfsojyxdk
X-Rspam-User: 
X-HE-Tag: 1763766443-186669
X-HE-Meta: U2FsdGVkX194SnAkL+m5l2vFbI+jW0SPvDYcld1i+maU1CZFyqma4ZCYR9jxR8qxQvh4fLVc+/rANf/GjCbT1k5xyilYU7F+fN5kjZoa6Ca9u4CRFDE2RjgGStj2v1kNCnjeGxO1/za3QMC2JO9SSTQaUkQZLI++PfiJ/RzjYExkGA4mjbfGAHqZ+Wwhx1l+Z7lTeJDY6pcKGLAve9YHKAXrXjWa3oGewhax1irYLsXUwU7fEX0Mps/kkWQLeUgvJV4x77fQR2nPwvZDM5EDv7gddJUAt+Fk6ARKvUUgi3OC/TP4anBNQPmG1fyWb/muVw03825YLSSzeLnRNPVogV+xLfxDceddFLAyW1Zs/dVYTUiKWWyGjH2YMrCI7kdUzQKRScE89uVPJWRWB5PDvSoFmXr2T26Hkthh1JqGXodmF1gq7XSJyxzL3j+a8Citcnq2rILVPiUaecEhtP/wb5ysEyvyRgZxhVPKrm2V2PoyGHKTG8fyZMwMxDj5myH5jLQxmqW5r9X1NwRqKANAe4iCpMcSupAKdS3cfCCyZqxDDzTxSTne/Ol63PmQHS5F3QC2gq3pr5YSWwt4Hlt8hS6F9HXJPt8wthJlHICVd47ltnU9zD5OuwBwhNIgmRPqDVQvHJV69o1OPj9A1TT8pNtftxvWM2XwHBctdcBLJl1MvFMJpZspGZdNFJJ4bkOAT6E/xX/MwJVGTNtKsIsFqlBDSSwlEKcRVgGRREnSXae1mlzAYrCTZO+TmU9OHIxmWErR7TVl4Az7kf8pwHNaf/6fh4O3i4WG+YF90kNlhbgoMN48GKUzL3frf4m9Gv7B+z2omEtKKzwmpe0ynKjyGJZTuAv0u3Gxqh6TNDUGVnStI4LuP0EGcV5P0yFzi/XM5MHHQRxrewpVtOqrQsZEtUG9bSrJaZEAH+r/unuzvowcgWBnmivqq6FPq7W+F1TouvWUCUejAfar8Pk5IHy
 tvWQOcqv
 gngNSNGhGT7TwoJaZlYm6TGaJ55rktT8Z12FIfR+NFh63JS2JSLDVndW6kQDpwC1eSaym7mpzvjYZg+IaL4wh3KfG/ovol1bYcvv2BKhpqC2MKrk0sQfcfztGSzGse4kDCydDwMyM4eXT2ahUR5w9ltL9zsKwhWuFOe3mdolZSbUutbV0AoDQ8z5/IsUMxkOe3II3Gj7LMWfTUximGCgExntIOANL+dsgnFuyq53YeXfMe1rpC67CDbBtlHNoaLoiIKXz5BUFpeOU/GesY+J1blXwsmD4L/lDMgyKoNuCLRwUd8CS110y+wR19Y7b/XIvOea2sB69S4zFQIpBa5ozDdblVau/pcqGuxCVPk95aevcOdorJ6qLY9Lxeuxam8yD1c78O/EyQoN8IDco407it55wToZg4c6ORE9P6f0TfRClzvTqpPwRW7emOObijf0blZgm1KOobADRdD9pP6ZpXJld3i6vc3zVF+jL71Eu+ntrC9pP6MzYirWI7EQY7W/wbl9xfhRoToMAB9/kvX3Col4WSlSFEqbjcIWN/aUT3KPzf33j3O5CcpbtIHMXvIvCmcmFIn75wlSkRQ/tthZvWOCF9ddMmsjl48ZoJX39p3F/q6ZbWx3XewY8DX3W2EAioXdluLWwekpGJVU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 11:20=E2=80=AFAM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>
> > On 11/21/25 10:35, Bernd Edlinger wrote:
> >> On 11/21/25 08:18, Eric W. Biederman wrote:
> >>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> >>>
> >>>> Hi Eric,
> >>>>
> >>>> thanks for you valuable input on the topic.
> >>>>
> >>>> On 11/21/25 00:50, Eric W. Biederman wrote:
> >>>>> "Eric W. Biederman" <ebiederm@xmission.com> writes:
> >>>>>
> >>>>>> Instead of computing the new cred before we pass the point of no
> >>>>>> return compute the new cred just before we use it.
> >>>>>>
> >>>>>> This allows the removal of fs_struct->in_exec and cred_guard_mutex=
.
> >>>>>>
> >>>>>> I am not certain why we wanted to compute the cred for the new
> >>>>>> executable so early.  Perhaps I missed something but I did not see=
 any
> >>>>>> common errors being signaled.   So I don't think we loose anything=
 by
> >>>>>> computing the new cred later.
> >>>>>
> >>>>> I should add that the permission checks happen in open_exec,
> >>>>> everything that follows credential wise is just about representing =
in
> >>>>> struct cred the credentials the new executable will have.
> >>>>>
> >>>>> So I am really at a loss why we have had this complicated way of
> >>>>> computing of computed the credentials all of these years full of
> >>>>> time of check to time of use problems.
> >>>>>
> >>>>
> >>>> Well, I think I see a problem with your patch:
> >>>>
> >>>> When the security engine gets the LSM_UNSAFE_PTRACE flag, it might
> >>>> e.g. return -EPERM in bprm_creds_for_exec in the apparmor, selinux
> >>>> or the smack security engines at least.  Previously that callback
> >>>> was called before the point of no return, and the return code should
> >>>> be returned as a return code the the caller of execve.  But if we mo=
ve
> >>>> that check after the point of no return, the caller will get killed
> >>>> due to the failed security check.
> >>>>
> >>>> Or did I miss something?
> >>>
> >>> I think we definitely need to document this change in behavior.  I wo=
uld
> >>> call ending the exec with SIGSEGV vs -EPERM a quality of implementati=
on
> >>> issue.  The exec is failing one way or the other so I don't see it as=
 a
> >>> correctness issue.
> >>>
> >>> In the case of ptrace in general I think it is a bug if the mere act =
of
> >>> debugging a program changes it's behavior.  So which buggy behavior
> >>> should we prefer?  SIGSEGV where it is totally clear that the behavio=
r
> >>> has changed or -EPERM and ask the debugged program to handle it.
> >>> I lean towards SIGSEGV because then it is clear the code should not
> >>> handle it.
> >>>
> >>> In the case of LSM_UNSAFE_NO_NEW_PRIVS I believe the preferred way to
> >>> handle unexpected things happening is to terminate the application.
> >>>
> >>> In the case of LSM_UNSAFE_SHARE -EPERM might be better.  I don't know
> >>> of any good uses of any good uses of sys_clone(CLONE_FS ...) outside
> >>> of CLONE_THREAD.
> >>>
> >>>
> >>> Plus all of these things are only considerations if we are exec'ing a
> >>> program that transitions to a different set of credentials.  Somethin=
g
> >>> that happens but is quite rare itself.

AppArmor's exec rules rely heavily on transitioning to different creds
on exec. For example, an AppArmor policy like

profile example_1 /usr/bin/example_1 {
    /usr/bin/example_2 Px -> example_2_profile,
    /usr/bin/example_3 Px,
}

will allow binary example_1 to execute binaries example_2 and
example_3, launching those processes under a different confinement
(example_2_profile and a profile that attaches to /usr/bin/example_3,
respectively). We will need to look into how much this patch (or a
corresponding change in behavior) would affect our use case, but
confinement transitions (where the confinement information is stored
as an LSM blob on the cred struct) are extremely common in a system
that uses AppArmor as an LSM.

> >>>
> >>> In practice I don't expect there is anything that depends on the exac=
t
> >>> behavior of what happens when exec'ing a suid executable to gain
> >>> privileges when ptraced.   The closes I can imagine is upstart and
> >>> I think upstart ran as root when ptracing other programs so there is =
no
> >>> gaining of privilege and thus no reason for a security module to
> >>> complain.
> >>>
> >>> Who knows I could be wrong, and someone could actually care.  Which i=
s
> >>> hy I think we should document it.>>
> >>
> >>
> >> Well, I dont know for sure, but the security engine could deny the exe=
cution
> >> for any reason, not only because of being ptraced.
> >> Maybe there can be a policy which denies user X to execute e.g. any su=
id programs.
> >>
> >>
> >> Bernd.
> >>
> >
> > Hmm, funny..
> >
> > I installed this patch on top of
> >
> > commit fd95357fd8c6778ac7dea6c57a19b8b182b6e91f (HEAD -> master, origin=
/master, origin/HEAD)
> > Merge: c966813ea120 7b6216baae75
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Thu Nov 20 11:04:37 2025 -0800
> >
> > but it does panic when I try to boot:
> >
> > [  0.870539]     TERM=3D1inux
> > [  0.870573] Starting init: /bin/sh exists but couldn't execute it (err=
or -14) 0.8705751 Kernel panic- not syncing: No working init found. Try pas=
sing i mit=3D option to kernel. See Linux Documentation/admin-guide/init.rs=
t for guidance
> > [  0.870577] CPU: UID: 0 PID: 1 Comm: sh Not tainted 6.18.0-rc6+ #1 PRE=
EMPT(voluntary)
> > [  0.870579] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS Vi=
rtualBo x 12/01/2006
> > [  0.870580] Call Trace:
> > [  0.870590]  <TASK>
> > [  0.870592]  vpanic+0x36d/0x380
> > [  0.870607]  ? __pfx_kernel_init+0x10/0x10
> > [  0.870615]  panic+0x5b/0x60
> > [  0.870617]  kernel_init+0x17d/0x1c0
> > [  0.870623]  ret_from_fork+0x124/0x150
> > [  0.870625}  ? __pfx_kernel_init+0x10/0x10
> > [  0.870627]  ret_from_fork_asm+0x1a/0x30
> > [  0.870632]  </TASK>
> > [  0.8706631 Kernel Offset: 0x3a800000 from Oxffffffff81000000 (relocat=
ion ran ge: 0xffffffff80000000-0xffffffffbfffffff)
> > [  0.880034] ---[ end Kernel panic - not syncing: No working init found=
. Try passing init option to kernel. See Linux Documentation/admin-guide/in=
it.rst for guidance. 1---`
> >
> >
> > Is that a known problem?
>
> Nope.  It looks like the code needs a little bit bug fixing testing.
>
> I will take see about taking a look.
>
> Eric
>

I've also CC'ed the AppArmor mailing list on this patch to facilitate
discussion if, upon further investigation, this patch would require
changes or cause other problems on the AppArmor side.

