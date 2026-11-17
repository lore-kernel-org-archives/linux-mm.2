Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E77606A333
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=FcR0DuxQ
Received: by kanga.kvack.org (Postfix)
	id 330316B05B1; Tue, 17 Nov 2026 12:45:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E01D6B05B2; Tue, 17 Nov 2026 12:45:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A85C6B05B6; Tue, 17 Nov 2026 12:45:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E52BE6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:44:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75286A8144
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:44:59 +0000 (UTC)
X-FDA: 85445336718.09.5C49E93
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 766494000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:44:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=FcR0DuxQ;
	spf=pass (imf17.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.175 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794937497;
	b=7wHARmtF1+iXcP9vw40T0JQnwff8cDJcy6fXzO3gLjFrkpmuUiuo4Ag6XIPm3NLWHq0cwv
	9AgswId51aJP0QqR3GUuYQVS9SZLhPEcUZlQvtqHzYoxhECLhHbGnd9PUaxPIZASHJWrDh
	HMEEh7drkV1C/vleO9s12SZ2I1A8YCo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=FcR0DuxQ;
	spf=pass (imf17.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.175 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794937497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNNOnQUc8HQHxzszI7I5Z5MCWmY2JGLCloKQuWJY2Z0=;
	b=oyD9SF5eMQ1kLH0t9dDpAlRp0dKH57a6zcXKxEs9F8+LCyeAc9hNlTLlnEd5CN1oVrUgOR
	HGMNFZGzKL5v+h2EKssrXKw1rQJNtYZdh0d8q+AGfh1QcC39F3UqQ48Ra2tAe+ryFl1p3/
	6Us5pOumrslQ3mKuW1CZWIbYDwRPqdM=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3ae25c846edso1106081fa.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:44:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794937495; cv=none;
        d=google.com; s=arc-20260327;
        b=F+jBreV4J1mfeA8RREECZ/yIqGw/+XrEub9rLknIYwjljcHfbe8OnJXlGecX9kAYV6
         6LeJdx9Jgx89a+MxzXFgl8BR7CBcGtM8ZsTAwN1qmkeF9uPM1Ec0ZCyqCDpjpsPU2acn
         p+jAXIAHDDAXVelv3pTZGsJ6t7sMPmHanbKaG/OI47eAvilH5ep0v2LILj3ykMW2bEDO
         +/zcLCKt0Rp9vR5sl+A5TIVvamLP4Ijq2X9Cu2DEwdh8OxleyqCeJLImDHErj7UyKALg
         tTvFXw0Pdl1RB/M+wD3XvGGxMe+k/dqXJBn1yfITooZVWByQsy9GgA4nYaajegAFN0Rc
         u0Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eNNOnQUc8HQHxzszI7I5Z5MCWmY2JGLCloKQuWJY2Z0=;
        fh=eFd74iq53RUmv2VRsP81QQmGT7O5d+g4kMlVZzMOtnY=;
        b=KY7crW2m7+eML3BYsh4DLJb/oTQu52dWouxlic2d7moQGy0LPOfS0hIsmeUWZ29XTS
         2GOxgHOw8I46kl1lyqUNC10X5PcOAIWr9xFUZYZkQWtcTV6wLkGaWMhwG3JN0pDFnGch
         bjkWm+bMMFKin61ijgYeFirAdhR7vRdjFvlWuld3o0PNl7YW+55vZHmOdrInum2/T2IO
         fXYYhvPSjJudFE5vTjIl6O1I8TJvcQhG+4a6qTw3hrBW25TbhQV1d/yeVwGM8i/MpLAR
         SgoKE4CDv4Z+f7dclk/d7lpX1CedDlo8lpzfnAvamyYZOHWnKtU8o96+Ahe/GBpkVQM6
         03DA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1794937495; x=1795542295; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eNNOnQUc8HQHxzszI7I5Z5MCWmY2JGLCloKQuWJY2Z0=;
        b=FcR0DuxQFhomiRA+LsawLPt9MGnBebngRHuZoyC8qyY8FUioSiXAOvkL1NbNQmHRr0
         0xZURi2R+rKIAzLo+cgn7VSh5W3Uk2lPsnlLKdiZ+UQtX28Lvjfa0XIlusvjmCor1G+t
         jEL2ojnJvT1X4NiYcH/HV91+6s72ycNkQIEwxuA/wymleSqtc4f65FpJj+UzVGeppp3H
         WYUwSEPv3WJhv8DBsGZ2Mv+TVMObu3Wcjrs63lr1Wd3017v4QByasSVRDRZ1kpqLzfpJ
         GkKvEy1uuakkNUkZph/0t+SfbIWkQ+2QfSTolWUn8qda/xYQnteYZOAUDBJ2cJSbUrei
         NRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937495; x=1795542295;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eNNOnQUc8HQHxzszI7I5Z5MCWmY2JGLCloKQuWJY2Z0=;
        b=YN6OA3kD2D0xPeuSd2z6nAVSiN988oE6pL8H79q0leihwd0M6uf7Y9Cyh5WtF19bFv
         A2ol0tz8sc78bg3YtNtk8TXETAk8mfkGhw8vcMd+q7of4yNYuCXZTf9E1khNfhSrVDmy
         U8rysmtYTUXxwKwtkmkYHiXDpq0VxWA48zzrrMnGS9fhNfdSM4M7+EDxE+lbAlyLiGlW
         5eaJYilG+V4C+MuXW9NL+LtDDbZ8najK+C63T4qaKn4RdMgNgkO6GKegM0ma+qtnuLmL
         EjtR7mkFHpqsNROBKaUWalVf2/M33ZiRgWnFO/tSVq0k2eSCJiGvxXzI5OEqsL/MqjtQ
         /B0g==
X-Forwarded-Encrypted: i=1; AL+hErFPfJaTs5H4o2tasTWt3E9XDGPpGHRCklVhVxNwf+/m944aw2Jpv3RGmaUUDQ/SwMzq47RU7bBR/Q==@kvack.org
X-Gm-Message-State: APuU4Z/LKmO+KgHzXcB0BtJw+3/C+tlOa5lvGS4vEU5FA95vD/+tOKPr
	m8HR/uNKt/M3MdPi9ZpPKun7oa9qtflcWQH8ETEM2xqe0rZIadDeQU92SeWc3QQGvEn/wdPOPWQ
	RXprdASJ0mxzoNqvYY++oq1m8tc3mQcqwzAQcOoIH
X-Gm-Gg: AYBFou3ZaaupUSE4Tcxh4cKtnqryYkVUL9MNiP/GZook8nQuZAy53dyXZHxVJ8bG742
	xrj8NbcWxQTTcuSFCcL7SPeVO4DE2YXoTa8hcgbCG+sgl4YoX/CDH6/lMA1aPFnM/sUSNetvTUL
	9J8K0lcTgVkkTR18xyNAvKlHOnL94g5KslxHd0Afjpg9LIii37soMs9kquJvZe2ovpfk+KA66mi
	AkWLZPR47SXpHJ4A9jTw+di5DBe/+RFkOHP0W86wNBQVNXG2KtCoA9t/z8H3/i868N7wCv8CQa9
	o3tUzSBDM+jVrexZR7RLf6tvEq3eeVrjKEDyOuCmIZw05tH8G3LrWDIdzhEy+HPS7+kdIFzEqbE
	y0PtSB33VP4KjENV1d2U26NfOfshwPdLImvP30gYm4GGuNw88Du2nTuI=
X-Received: by 2002:ac2:51c6:0:b0:5bf:b945:4334 with SMTP id
 2adb3069b0e04-5c170a15b78mr6210350e87.67.1794937495491; Tue, 17 Nov 2026
 09:44:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117050841.3289652-1-jarkko@kernel.org>
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Nov 2026 09:44:43 -0800
X-Gm-Features: Aa3M54pzaE332pTi53D1YpA5VO7WahNUrZvzEHccu8lFNhASVJD5SKW-Zdzq05g
Message-ID: <CALCETrUBUnJVhiMkft6hTZZMe8nTpMBRTGY2v=9x5ETBSvmPZQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Namespace for namespace roots
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Ben Segall <bsegall@google.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Manfred Spraul <manfred@colorfullife.com>, Mel Gorman <mgorman@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, 
	Paul Moore <paul@paul-moore.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Serge Hallyn <sergeh@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 766494000A
X-Stat-Signature: dey7ax9oiqx6toesn3krk5dm793tmu6z
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794937497-892026
X-HE-Meta: U2FsdGVkX1+/fXnHPeYVJYLWXUfbsmYxlrB494mPxIquqO7CENvEBZYcjkbkLQbJiwtOUsKzNZoWLMMRB8o7YuGBlD7nC/G9DAkPF4zjM/CCPI/J9IXziaUK9S8rou1wAfoTGTr3FE037bKGFSd1HJ43ljUD2VemKmsU1ZkmjUgoINcgUgYR9CiRH+1GjugxDiygxyzJ3Mdkf2ToPxCIItVNg5F0OpdXeMghw8cwGmddUVugSjx+9hd4Gm9ATa4Idw3cvOVkdwF3vV4HCrLROxCGmI8HRnHNqLzptYni6Fio4nWbEbGItWi8yJYwYiB8cQor6kdUNRGJWTg8u236aVEu+DM25s9Ii+1BAVL9obXB4IAZ21VUd47C9PSzz91R1qeLMtGMdiLlZO/FJIrmi1eT+FRK0myxcdu9tClu/VQtqaqxa+SrPMhu9gR3MGGsiTbVJ1bviyPwC6oskRHezyz+4lgiGaLapPNrEZcXyhjWKUKGBW6ClyLEA38IhEWHP6TDDksAiQd1rzTKXo/oundYj9E9ihufc9klxW2dirzG2i3kOgxHD85rZK+yVOjI3FGKCzJ45ScFAQqL6lZ2XvzYfFNVh6HZEBfCpNKq2/yQA5QITMqEHE9UaZKA3gEJTKHvA+rywCDfFp4N8yi4E3tB8jM1HtrAbU03TLnRY1zLS5TAGuOpq46k6lug7jZWwITbNMR4xx7E+QcmaRRrUiiJdIBF9kAP37JGztU3GcWZO0hNKk2GnLPisdCbYykIQed6CxqhBCkpkJEFOimLQnhQtdZr+pVmV+343xK1NhiaeQhGhUhZ/3q23Qb5Psnhh4x3nfaTudHp6BqMpUPszTckSNBI0bjaP5k1pHvRhamVwBg6AnL7oV6fJQCyab1v43hLF80/SBKy/9eJUn52akFqCHkNQncbjrA2e+SShoYtswtEAsKRmGLqi95XJvzx7h1C8LiRH2Af9ZZo0xx
 ABMsmqrY
 WbrHFDEmxU6sVuv20QO26fB01T3nN0WkndMFJKhRTh8AS9khB4aHsesmkvEJoANHt4PeOEDwhdhkci4APhidFRj8V26F0fYbsWVjuSKG90nz415X60k5/AfxJ86DpnejKci6WXXevuBKjzt9L1uZ8kKYBr8wnBnWA8zRY1P2uRGbe+P01I4FikvlHnQKoUog9Vgtx2Sdk+gxScIzbQguysjD0v51Y6pF6QARbvakUrhgTAkOHWMb8DwlNjG7DJfqiU6b4VzoTcDbJBMq1zmP10ez/QLB+dEMJA5yhla9EzKTo5gxbleNz56XD91f57Bxs8eXIFAkXp8R77TCiyxyQ1XAIqa4KlMlZl6dVdV/DLnYN+NOlyKDx56tNPrJBgqjm2WXMUL/dSDKd6JUW3utmiznwuOEraHzbCggdC3TOgjEOI6tFctLn78lODKGl3aWjKsq4PFxSKgiF9Z/qGzSAaxcgHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 9:08=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> OVERVIEW
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> The problem that root namespaces try to resolve is starting a container
> from a root mount tree that is pre-populated before any process is allowe=
d
> to run, without inheriting any host mount-tree ancestors.
>
> Work on this feature started originally in 2025 from David Howells'
> container object patch set [1], but I turned container objects into a
> namespace of namespace roots and built a new implementation around this
> premise.
>
> In early 2026, the patch set was left to gather dust in my kernel tree
> [2]. Then, the other day I saw [3] as was shocked by its over the top
> complexity and thus, here we are.
>
> Not doubling the number of container frameworks inside Linux kernel is at
> least a benefit over container object based solutions. Parallel plumbing =
is
> an inherent flaw of container objects, and it directly affects on
> development and maintenance cost of container runtimes.
>
> Also, thanks to better scoped implementation surface, verifying rootns
> correctness is factors easier than with container objects, and even my
> early kselftest is meaningful. We know what and where we are testing,
> which is always great.
>
> Finally, it is more compatible with pre-existing container tooling
> whereas container objects would have much higher cost.
>
> [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.st=
git@warthog.procyon.org.uk/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.gi=
t/log/?h=3Drootns
> [3] https://lore.kernel.org/linux-fsdevel/20261105-b4-cells-v3-0-bc909593=
7a84@toxicpanda.com/
>
> IMPLEMENTATION
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> rootns_create() allocates a rootns object backed by a pollable anonymous
> inode fd, pinning dedicated empty mount (CLONE_EMPTY_MNTNS) and PID
> namespaces along with any optional namespaces selected in flags.
>
> Before entry, a manager prepares the mount tree through the control fd:
> FSCONFIG_SET_ROOTNS binds a newly opened fs_context to the target rootns,
> and move_mount(..., MOVE_MOUNT_T_ROOTNS_ROOT) installs "/" onto the nullf=
s
> root once and attaches relative submounts beneath it.
>
> rootns_enter() forks a child directly into the rootns credentials,
> nsproxy, and root path without mutating the caller in place. The first
> entrant becomes PID 1; once it exits and zap_pid_ns_processes() reaps all
> members, poll() reports EPOLLHUP and rootns_wait() returns init's status
> and rusage. rootns_kill() walks pid_ns->idr under RCU to signal member
> thread groups.

Can you clarify what this new API actually does?  I've read this three
times, and the best understanding I've come up with is that you've
designed a way to create a group of namespaces identified by an fd and
you're adding an API to configure and enter them cleanly.  Which
sounds very sensible.  But I'm completely confused as to why a
namespace needs to be owned by a "rootns" or why that ownership
affects even newly created sub-namespaces.

--Andy
--=20
Andy Lutomirski
AMA Capital Management, LLC

