Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8305DC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 13:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FEDF6B0095; Fri, 21 Aug 2026 09:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEFB6B009B; Fri, 21 Aug 2026 09:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4D36B009D; Fri, 21 Aug 2026 09:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08F016B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:52:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81E988011C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:52:23 +0000 (UTC)
X-FDA: 85125416166.13.99A293F
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id A342D8000E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:52:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dubsy3RO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787320341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MQng+9xXyTKknMt+t9Rj4wyf14y6xu9aKeDOtOOdJk=;
	b=JFbAgpMiJ6XLsZD+uidkJG5S/JIw/UCuQiyd8Mzf3JiFIiBy2xVVL5YZn0jG/wbalt2k8f
	k1tI2P2sMXWLj3NjqaA1go+yaQ+0a6z28bOojYry4IzdoSHs26t/oGnWS6Mn0z9MWBAKB0
	/EU5rGRsO1lYpi0eWUoWxJQ9vuQIoAU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dubsy3RO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787320341;
	b=SyMA7d0HIP58meK7M9r7QZIgO8/2SRnPcRwxrZvuMbPTYW78GDvYuN6qZnTzyJYtK16ghF
	zf2C2RuQLObvZLtsy2mw25dwsoblsi/kh2xcsAYWi+c+F1/QoozABMDeIW/P8vdSfqNo5E
	pGZ3TzBrGi4iCzTOkpN/o2y4KCrvAb0=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso922522a34.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:52:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787320340; cv=none;
        d=google.com; s=arc-20260327;
        b=JWgFXxZLlil7zHhzSYbDa7cN+khUb4Ihnq+36VLVfk/Wmb/tEoG+Iunmz8EnkQoprO
         FdNoMxh8SqgKoWhTXVZRYZ7fmuWhAIowgQW+KvZyINBSLo1jUAXhZB64ugdRciG87n4K
         K2MhKMw0VVwZagqJYj/ewariBnMR8dtIJwTMEvUtzZvNOvd7IWaLu5ALULez3xNw0PNa
         gfgevn4wfjLGyVGAgJgm9DY32ZaxNSaMCkoziEJC5KbUPIr8TYniHm6NGDjU2fiGggRF
         52s1PZNjvx2HMNoCn6n2t53QjHa5NLI+0zKoUKWVayrI9N0mxVdtYneZ2nhqgNT0byXZ
         ViJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0MQng+9xXyTKknMt+t9Rj4wyf14y6xu9aKeDOtOOdJk=;
        fh=YjtP/iuPdRqS/0td0aw/+UnF3Awd8xTrYvRuIqdVkhQ=;
        b=HvehYdMkXy1xwVj6VlG07JzvwtBPW87dQEmjVKKjaEARLAop/fswMbFDp8duxf0gP2
         2k76PrF1qNH1oBAh94UFSZtj8riLawfLACiEKiGaISj//MxY+/QRi3otiTUgSgkZdfAM
         NTiBOUbBvj2/rG7R99F1TU51+7Rl4wWIWDPoKt7ndmS8mDVyh/cIFzxFKHz4G/fueWGr
         b3MKqvhMyqtXKw1JXe+LGNnQ6i0ew4ug+Z1y08tN0UFopepp5BXgQj2cH7572Ks0ciKZ
         ZWSzU7XQIYlAkmuHCOLltJxn94FOlTrjrxJHqciGIaheMn6OPJ5Cw7qgjL//1g9AgXyp
         htrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787320340; x=1787925140; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0MQng+9xXyTKknMt+t9Rj4wyf14y6xu9aKeDOtOOdJk=;
        b=Dubsy3ROJUqNFQKu0LGOUNWJ7+QhNSsijB7IMFgxPNlhZpl5TBs+BoQhUlCmB6QiEi
         osH7MDEPWEgLJ+vng+2Fuz7Az+UbAJobf+Mx9L7XtE1PIzO57FIbl6pC/oaNx+d0sWla
         Co4rupnZm6O9c+yPsaD0PimLJ5cNd0mQRqCcx/ASYCVEe0KoUwB9r9vD5uLy5XZyvvgr
         MGHhsNI1fF0SRtmiNuKIujKlB/br6xC8csEFVi/DslsSJOaCzg60tPKHplRsAZ4ST6FY
         9W+diIOvD303k4WEP3vNCPzCyCbkvdcLvF39LEnpJZbZIsGnHmnSbtR260z43TY4AY7d
         mKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787320340; x=1787925140;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0MQng+9xXyTKknMt+t9Rj4wyf14y6xu9aKeDOtOOdJk=;
        b=fxZjjT+MGifkv9FvQ0ARPbqZGI0oJrnnKpybf0oUPR/VMAVm8FbmjvAxVkluqo07hz
         QtF8KsBnlwODJJinpNqExSJmJXTZWhqLjlusTRiw9yKuO1ztbhuyCZUHNtl5wtD67fjw
         aBeLMBu4bEvF36FJNUCCr0qsJoKJdcS18E8k70ZYYN2WAkUkjTX8LvsVTeo+1tNBMx7S
         2dD03Y8FE0HIdDTVh5YFRTiBw5DjzTskVZM67aybD5lNmqv9OOx0Uwme5GxWO9CQtrIK
         t5tIv+/ihsECdmqivv3gWtUzX9S++lsG0mujIn/QrmbyrKlocEyFp+z6UqmUaWh+QHUW
         9k4A==
X-Forwarded-Encrypted: i=1; AHgh+RrvC8Bo4kV8vqBw/T9qYXOxVxeAbCb3R2TF6RmD+v6W2sJGgbnfzb0krE7ahMHNX05hQ7WrD6Sqsw==@kvack.org
X-Gm-Message-State: AOJu0YzkUoYvtuFUzwsXnYv54JMpO1mpxItCCTBLqKw8ZootAPMC9iFn
	rzpoF/JlQvZRrcTDAqsXARtBN2XrYvYP5RFQQcCpGLmsXq3E24yDvWqDX654mWL+Gq8RHQzpkxA
	jz4wXBWkQLX6XZL/7n4rzI9H+lKCFICY=
X-Gm-Gg: AR+sD12nmDzKpoRcM6yVkK7dTrYbriw02L9tI9odJJ5NSnQi8GidZlGa7eTBXXOHDFG
	vsRVWlIE/8Z2s1vNtfmZlm6OWz6kgKCcWWffaCK4w/I7bND+gMSElQNghOeMquLljHRSVasWzrR
	p7zpAW3bG2zbb25WsENq8OrntANUL2rxGc24BqECj2TTZWcafvWFcAojkxzORU2DXHrj0FcOCaL
	CX7UFisCTmTEpS7rjGoZ55CXR8ncSbUK+/FMNSIJ9YpT5BbLnWCy9s8GyWqbI+RfVS2RaobrcvB
	FJJdIw3x4xVM9u5zS8PX22/F9kKf89i1QQq8/+rmoPqX
X-Received: by 2002:a05:6820:341a:20b0:6aa:e176:bcb5 with SMTP id
 006d021491bc7-6b15925da2fmr5108790eaf.14.1787320340365; Fri, 21 Aug 2026
 06:52:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com> <CAEjxPJ714iCMiQRVAN6MQoOyNx998MS5Xfhbhmugcwz+gWYAuQ@mail.gmail.com>
 <CAG48ez3h2Gft4onQ8AgBmf8gHrF26YqTinajuBysNPkUKaTBoA@mail.gmail.com>
In-Reply-To: <CAG48ez3h2Gft4onQ8AgBmf8gHrF26YqTinajuBysNPkUKaTBoA@mail.gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Fri, 21 Aug 2026 09:52:09 -0400
X-Gm-Features: AcwNN1XIMQRcAUBNk7fjxozSpQ8JckvqGIQ5KHe6kYNDH33rw4pKhCm-h8pgeiw
Message-ID: <CAEjxPJ5cUDBekWe7fC1JYnw6CfT8GVa9fqrFwLPPAOqSP6jn3g@mail.gmail.com>
Subject: Re: [PATCH 3/3] selinux: require EXECMEM or PTRACE for FOLL_FORCE introspection
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: wk56hqptkefgmr7aabiq7ajokuh84mx9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A342D8000E
X-HE-Tag: 1787320341-962186
X-HE-Meta: U2FsdGVkX19RQfR7dQGJnAF4PAyfN1Qu8vxerk1KkTOkNvpw/DIq5TSEv/QB+kbnNPzc+E+x5Rp6YDgwl+kC75lwGekxB1gDpgh5y+i/zxkr1gvcppknhgEMEtaCTziehwYUh73kKJIU2IbVcid7nAllbNDQSyYN5h/TOVEwYQCaMeamEnYa4LFx5ZfjkuXwCKLuCMeG80kKDEroAVzgh9reVmMLQBPvzhUhynCDU4QT3mYtnOWbTwJsSzb9oaGWplxzWPzbZGvexQVNgzJtRtKehMhxF3C4RXaYU/vwCK+P1Xev3/c7Jkjq/7Ry9TqGNuHzmy3yY+fbD4Xc2REt0kw2/zAe4QOs+fBVvhgg4Qyv3UBLW8yCL7hhflFSrris0BOdnCs5gf6xKzTaPd+XaOWY+He/Hpc9WzT6vWnaD30tHxvvJ8Ovc6MOQMZOMFIcH1766phnSCF3Ey/jN9QGnTtW522QJ5A59rhnKP5l4lwL/tsafV5mcR8a7yp2RN0uASv4mr5a82UjbJn0E08WFTQZLF5ol76eVWbnqjsvyjyDruHcZaqoyqzvGEpJtW1T54YOsBHQGKvYPkZE6PtF6p4uwB34bbi4X8NT0aXzOgp5+lcHIWpFMhqw+4WqpVNIa05SGkzkANl7X60YJEj5pnnSlVeL2v614Bd26do4r0ebUmeelkzqDrkjoRClySh9g6xC1RlQEsa7NDukDWv9ikbNp+cLUXXeXRI4tZsitFB5ubg7tx1DRsU5fwcU/h0XowrEIUDLUtA4kWw0/Zj0XiVLs0K6zJQSBRUn2eFoEIIMcUZtiqA/l5p/sTI0Ee1IG+0Cn7Q0/Fx4LiI+2lvJnsYlWtAWj2V+pSbI7SVbCZMUUwcixl4toFHF6JMcm3EBG3eeIwCboK/RXro6VsGioO8RaLrryjwUsL6VHhqhTmn6oaL71i0waaXRCzV+2POFOYUQ26DfvKexkwz+oIW
 21AAI6sR
 ZXnzjchv3189fCBMBvPgYU8xZyZIp7CQi3JcyyjzP185KPuKwp3SlomVeRERT/GNO0iIjjAbuS6DQnz8WvC9hPBQgSixFzDrHAbzKuqnr1nxfeBPivs4//A/B6SgvhyhEhECOhb32MTDrczPdHknTLsp9WhxT42DtOloOapsrfZobN0ylSF4JBhbEkUxy4EOIfk0w7O8POgRNkdpzxnqLc87tCHgFtpEnQtnY/LvpRI7Y0s9OmPhCLixOix+ovOWmcRMiktIHF9c9qWzFbKZiGcj21fzRGO8wJjKIMMJItxXTTpjFKsXBPtaUksQtJGdtfkdOdoFYXASqxA52HvNCooQujYSO1qf6qnHnXYgugqQfRuA5gtAzyoy/hZj7zWceC77fRv5lIGdAjNzYRaZGzkWLB9Elik85wvmvX9COs59teBmO9npa0VArAUT0O8Aiw5zyqpaMLrkMRHrzAHe2u+8fcvOky4kFci4LK0/j9F9nP8U5QdprvJi84MLq7lcT7vCEZbH+8OwlnL3pzfK7Xe0j5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 11:23=E2=80=AFAM Jann Horn <jannh@google.com> wrote=
:
>
> On Wed, Aug 19, 2026 at 4:54=E2=80=AFPM Stephen Smalley
> <stephen.smalley.work@gmail.com> wrote:
> > On Tue, Aug 18, 2026 at 3:51=E2=80=AFPM Jann Horn <jannh@google.com> wr=
ote:
> > >
> > > On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a proce=
ss can
> > > only create anonymous executable memory via /proc/self/mem if it has =
one
> > > of:
> > >
> > >  - EXECMEM (like for other methods of creating anonymous executable p=
ages)
> > >  - PTRACE (like when using /proc/$pid/mem of another process)
> >
> > Allowing it if _either_ permission is allowed is unusual in SELinux
> > and seems prone to errors.
> > Is there a reason to not just require PTRACE always?
>
> Hmm, that might work.
>
> My two concerns about that approach are:
>
> 1. This is an operation where a process acts on itself, while PTRACE
> is normally for acting on another process. It feels to me like those
> are different types of privilege.
> 2. I feel like blocking this operation even for a process with EXECMEM
> privilege increases the risk of breaking existing configurations.
>
> I think if we want to gate it on PTRACE, we might need to put this
> behind a policy capability and let policy authors figure this out?
> But I'm no expert on how new security hooks are normally added, or
> what SELinux policies outside Android look like, so if you think it
> would be fine to just check for PTRACE, I'd be happy to go with that.

I don't think a new policy capability is necessary here. Is there any legit=
imate
user of this capability that wouldn't already have ptrace permission?
The other alternative is to introduce a new permission for this, but that w=
ill
deny-by-default on existing Android and allow-by-default on Fedora based
on handle-unknown until it is defined in the policy. In the case of Android=
, my
understanding was that kernel updates can always be coordinated with policy
updates so there is no need to worry about a new kernel breaking userspace
with old policies i.e. if and when Android ships a kernel that
includes these patches
they can also ship an updated policy that allows the new permission
where necessary
but I could be wrong.

> (I've caused stable regressions several times at this point and am
> trying to avoid causing more...)

