Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653CCFD377A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877F66B0088; Wed, 25 Feb 2026 13:38:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8260A6B0089; Wed, 25 Feb 2026 13:38:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707566B008A; Wed, 25 Feb 2026 13:38:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0246B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:38:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6B02BA442
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:38:24 +0000 (UTC)
X-FDA: 84483839328.19.2DDA80C
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 01B6620005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:38:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eo9myn++;
	spf=pass (imf13.hostedemail.com: domain of avagin@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=avagin@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772044703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRNfssoOYnj7DwadpEhtOqHiGmKc3zJlebRcyDYCah4=;
	b=C58StdVzeGNkH3wZ7DLfKj8Wm16qbAzYbZSCzwit4VnP6/uvmwHRF7hQJNsSPh0KFEbvt5
	MqV8K6E6nNIMpIgQl1CxLETDCnQpGHwWcy0Nr31cwYvEXk4FHMeB3hgropQ+Eu6ImthusS
	IdmzNpthdWfHxvxD+yU15Zt97EEu8Sw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772044703; a=rsa-sha256;
	cv=pass;
	b=XMGlL2Neq1fjbCPHtdTKlaRg8a/S+cGmWgozlWWUAR2mC4aWenUUTba33t5imXyiPrxYx4
	e3wFJIXRQAKiqU/DdMdhfv7fcBe0Qwibq88xKeHZqgoVUoupk9AU1Y/xBC3tForixy9mR6
	GK7lgvaiVl6lE1Wr8obFDRKjLXepJQU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eo9myn++;
	spf=pass (imf13.hostedemail.com: domain of avagin@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=avagin@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506a355aedfso48691cf.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:38:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772044702; cv=none;
        d=google.com; s=arc-20240605;
        b=a75CYT8QekHQ2otutqAgRG+1q9S8vZb+F7N+Uny01pOrRzhW2oppCZs2JSqHXiY5SB
         CCGC+aMPwtbX1JQ+pELDWPSr+VdSDb7lEGlOrYjcPMDilrvT65kuio3IUVZXh3sMqsE/
         Hz4SPI7V3kRKjq14W/mEXj/BK54jF2egi0Iy8xOXNMATiyBDQztuf0qaNSPL+D8VAoRg
         tvkxL75+eBmbbf9n2nTgEpbQdDAMbcnvoROa8Jdv1x6/mS9eiY6UHw7Q/C9Fb07jAmXB
         iqDS+z2G2FQeYdaajm+qD1IpApjfsUkskwTjjmIqtY2vL3+95WgSgolYCplCNrEl3LRg
         wYlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YRNfssoOYnj7DwadpEhtOqHiGmKc3zJlebRcyDYCah4=;
        fh=j3DAljNGbMg6zXGeZXpiVe+G6MB2b5g8E3Fg8RVmCMM=;
        b=ZRuBHc2xr08PwkMkrQOD960WnLMw6XnAl9dqnDG0nOmGIpzBTEpaSHPuAh3GV7bDKn
         IMjDM2U18uvHPvdkja1pfbmz2NqWeRyAOQIIuNbWQ0+BMf01Gpty6/j5CkIBWV86E87O
         QgZD6jvDmPl+6/vZ+Ve7oKuGuEvdEL9d/XlmKT0RC3Mn8TVND3FxdnV87SGhCIs4zeIx
         PafeDVGauFLfBoRYjpAdv15PilxF0cbSZmA293bsoVlgbuEAgHVK68RWwv0wDluw8/7Q
         eXVtzWQz/IYAar6Ji21veBWzsUd1zyQCZjCy6fqpuGITIuRcvelehC4/orLr7U6/eyAy
         iUrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772044702; x=1772649502; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRNfssoOYnj7DwadpEhtOqHiGmKc3zJlebRcyDYCah4=;
        b=eo9myn++PNv8Yw5RPFwIxRd2t5CebrV78aRBWQZiUqXNsido4esrGC3N15q58g+oUi
         caFnkzeRlERWhHDAEaYGYNur40tbJJmUxEu0ZjGALcoSKEk6UfXTNdrNsq3Cr4rTmgNO
         ZmgXgAR4u4v3gol96rRzkTf3Sqt9z9q8bNZGdG/amcDSQBuxsxEgwYBwQd0kr+QNNf+o
         MYP7DwJnx+dG+DzyZJkx7BPiia5mdPZ9JMBCzOj7RXE0kVkydjTUfAtJ/3PpgOvirTra
         YDu9ZK05voVsmbHVtJ6pd3vUPzMSOAvjSd2CIlUu/luKCana6xpoUBH4DV9lDZakm59+
         R5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772044702; x=1772649502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YRNfssoOYnj7DwadpEhtOqHiGmKc3zJlebRcyDYCah4=;
        b=VkoIE96NWiLKCelxJP8kcX+bp20eg8T859Om0P0p/Zuiou+nqE03/eRymEAQL8881h
         A5eBsE8fxEtuplxfvZTKJvZ3NQA8cW3YLg7Vtx2jjZ0L/V+iUangxSrfKpKpGiN39Aqj
         7sfFI8EtlHZtBEQvXnCajvT84MTgqqrTOhUXWRAqgYNgLPC841gYIMuorXmSuKiMUxcu
         xFvkipqe4JCSE5WODTCSNo4L9Gfr5s8bQ4xLvRw0ac0ENh+usIfQSqwTi2tlx+JOarM4
         2AkeK/CHuKcMT/7+Pqiz7ZbAnvQgB0zSqMhW7Y2QSqN/v0pcvQREqc5dnF0rY6S20c1Y
         G+Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWwnDyRZiJ3TMSNPFbgJW9uSzRgSlfT6ssx+W/eiQqBlGkq1R1l+8VUF7lN8IwP4IuvConOI6MMSg==@kvack.org
X-Gm-Message-State: AOJu0YwSGOr1UHyUxVwQ7+49SfuaRiI9srxyAH+uMZaMILM1RV0OybMc
	rarbPw6ARHY9PvaC9/tzrBKhkmTL5ec6YmY5qknB9HhU+Z8F1E+uHwWOhWtOVDX7NJXMUTvQEvo
	6AXLEd2GoMyBkcg4BYS2zn95GHmdn9k1zV+VeWHOa
X-Gm-Gg: ATEYQzzVrm40PK8+hY3lXciHtGEtoo999xGSMjp2vxbH+trvQGOKwTZK190YbTvYs8i
	vHVn1RDLkfjC3ouq+FdmDH+99UNj3M3g6j3oWKzJFQt5RyP1mlGPrDLVCgIjOtV0RAS1M5+FVJy
	KiYEKfoQbHwN5L46fa6JT+IJsJr1py9XC213UUZLJZxAGplBg1otEzKNqhGPUCxz+mpNoCcqgvV
	7BDE1MrlcTH4jbwk2gPC56QzB5xuJPvTjxJn2mO+zosPmth08S4h4+Yp1QJ8qCwhO6bpNbzN1aj
	NHThc7xCPXRpYmvA7sg2HVFE7p/WZ53hljdKkw==
X-Received: by 2002:ac8:58c4:0:b0:506:a1b1:422d with SMTP id
 d75a77b69052e-507441e2f1dmr515211cf.14.1772044701492; Wed, 25 Feb 2026
 10:38:21 -0800 (PST)
MIME-Version: 1.0
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com> <20260225133229.550302-4-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260225133229.550302-4-ptikhomirov@virtuozzo.com>
From: Andrei Vagin <avagin@google.com>
Date: Wed, 25 Feb 2026 10:38:08 -0800
X-Gm-Features: AaiRm50_GlTYHWyT5YUB3Dnx8A5YYbsSPDQESsyudqXzcKrLwO5o6uAEDPk1lqA
Message-ID: <CAEWA0a7XkoiG6==hp+a8CLRFY+k9o1rn8tum1c4YY97ki6fkjQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] pid_namespace: allow opening pid_for_children
 before init was created
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Jan Kara <jack@suse.cz>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Adrian Reber <areber@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 1crerc4h9jpnxuptmzkypkcjfuo3xbsy
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 01B6620005
X-HE-Tag: 1772044702-312238
X-HE-Meta: U2FsdGVkX18SxdCdra6lIkwLlM6eEOPmyjRqqyP1VsCtDIV5wXC+eAeEZLOVakmHaAALyzn1/EmUxtHt30tAIc50IShNBAhXtgEwTrz7kRyt0veF3z2ZPUcrToun25IcSw0jt2fpeCDuGjUyZmeFIrO+wtzlEvvDW+86bxx+ZCyJYcjTJyAqUAit1+qsH5saivxU6TO95ukRIGEaPdP3Zj6wUtnmKYcDUR4/i/N+8xNv9WF5KSuDLk4ILJm3aSkGSIT7wAbT0DlC5fra2io9NwyFlbG/D4uwCBR+KuYtoo5Wf1trAEMkckNJzJMNBptYhocVzYwlME0EsaHrVQxQLG3RcLriQYmeO6Ms8+7Ws04Cntct1vZW/ZK7iL15rVeWU1ZCtjO3PKChJ3+PuttgtlUGLfnJlPb9ldkae3ia4S7c2c7jAqI+31RJePaWkcZEmfgDSwEw06vYppxTbJpIQ9bYQbNHeQMUo+19fAMHrar0Mx0ar0zbgiEkk33WR1IU8OaIzh1UFkgiGLq+2tBrkdKwayRa+NkJ6+rv3eQt/nlBef88azPjuHL7Tinfy4jHIGjP4JU8IFsBOnquZzTpZOkM6yWdvPjXggQxGnU4dtrX8CWYRL17Q/1JM26rHR72XgpskUDJRzBwdI+x6ooolQTb4fIlot3AmHYpSE/S8sNkzFgGYeTdVj5M1FOoEjPAtUFyHem1bF1hTJ6nLD7a8LHAME+7yl5S8foShDEw+Mtl95164RP9lrfzqzbOpny4lqXIFq0b1AX9Q7Cbze6ev9ycGLQqWITkkCH+ZAKU44a6cghRRY9t+CSO/XZJH33qIIfY7hXV3wI+BHcDmsEc/1XCvtmrkPEPTKXBYttf485p66TXRm3w9LFqvq0a/d6qUQZX3tUcQzi4vYaLM+kUF7MxByIF3dVLFvNJW+veleDMZdpAGJQijD1ueiLzm1iPnb26cJgVTFod12XtHCw
 G2ZVKrRA
 ZLDa2dTdSWLc2++Kil1K16Vzgaes2BN9J1W7uW0B2pbWobmO+mG4SGVQcCIivD5RGIyN+Uk4RCP6CM8spLs1ElEcpX4yKOBgDk6cgK1Ma+aNuyh1M9wpwVz8pTR8zSiWW/nqU2ZdPscgho/p72zwA6VYGj3gEJYFFACF56hLyc4q7qYo5ZacHs0dW5XlORDbi3Yc+5RzptUVaw8+LPpKbF0H/LjGhqz0cf1VQ322DWePL0uNzsMaUIbvPmuJgJBsvQWvzqUVaxHQxWJWdNlDt8PSOTfZaUFsGE8i8IGBAqwWU7+oDqKns7yGnNv4n0ak5JeyeQInoATOLZ139fPlHUFwGl0gkO4P2adGXr/QdrH9oXTVEABkiEh82rakNjkfV6/Y389CIWICkwYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 5:33=E2=80=AFAM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This effectively gives us an ability to create the pid namespace init as
> a child of the process (setns-ed to the pid namespace) different to the
> process which created the pid namespace itself.
>
> Original problem:
>
> There is a cool set_tid feature in clone3() syscall, it allows you to
> create process with desired pids on multiple pid namespace levels. Which
> is useful to restore processes in CRIU for nested pid namespace case.
>
> In nested container case we can potentially see this kind of pid/user
> namespace tree:
>
>                             Process
>                           =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>     User NS0 =E2=94=80=E2=94=80=E2=96=B6 Pid NS0 =E2=94=80=E2=94=80=E2=96=
=B6 Pid p0 =E2=94=82
>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
>         =E2=96=BC           =E2=96=BC     =E2=94=82         =E2=94=82
>     User NS1 =E2=94=80=E2=94=80=E2=96=B6 Pid NS1 =E2=94=80=E2=94=80=E2=96=
=B6 Pid p1 =E2=94=82
>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
>        ...         ...    =E2=94=82   ...   =E2=94=82
>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
>         =E2=96=BC           =E2=96=BC     =E2=94=82         =E2=94=82
>     User NSn =E2=94=80=E2=94=80=E2=96=B6 Pid NSn =E2=94=80=E2=94=80=E2=96=
=B6 Pid pn =E2=94=82
>                           =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>
> So to create the "Process" and set pids {p0, p1, ... pn} for it on all
> pid namespace levels we can use clone3() syscall set_tid feature, BUT
> the syscall does not allow you to set pid on pid namespace levels you
> don't have permission to. So basically you have to be in "User NS0" when
> creating the "Process" to actually be able to set pids on all levels.
>
> It is ok for almost any process, but with pid namespace init this does
> not work, as currently we can only create pid namespace init and the pid
> namespace itself simultaneously, so to make "Pid NSn" owned by "User
> NSn" we have to be in the "User NSn".
>
> We can't possibly be in "User NS0" and "User NSn" at the same time,
> hence the problem.
>
> Alternative solution:
>
> Yes, for the case of pid namespace init we can use old and gold
> /proc/sys/kernel/ns_last_pid interface on the levels lower than n. But
> it is much more complicated and introduces tons of extra code to do. It
> would be nice to make clone3() set_tid interface also aplicable to this
> corner case.
>
> Implementation:
>
> Now when anyone can setns to the pid namespace before the creation of
> init, and thus multiple processes can fork children to the pid
> namespace, it is important that we enforce the first process created is
> always pid namespace init. (Note that this was done by the previous
> preparational patch as a standalon useful change.) We only allow other
> processes after the init sets pid_namespace->child_reaper.
>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Acked-by: Andrei Vagin <avagin@google.com>

Thanks,
Andrei

