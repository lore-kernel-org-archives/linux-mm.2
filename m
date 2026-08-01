Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32695C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 22:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0FB6B007B; Sat,  1 Aug 2026 18:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22D26B0088; Sat,  1 Aug 2026 18:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C4D6B008A; Sat,  1 Aug 2026 18:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99F836B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 18:34:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3A0E80386
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 22:34:50 +0000 (UTC)
X-FDA: 85054156740.09.A228398
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id ACBCE40006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 22:34:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aF0tMJwj;
	spf=pass (imf27.hostedemail.com: domain of pratmal@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785623688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ge2Z+XX709xzAtZe7afFgNbCFGM6FF+LCnu7eUBhqgE=;
	b=3mtyOzCuSkzpzfTC+7a982Ye+hJt0LiC8ylBKUHDUjSs1NJuOFPqs2KYAI82WD/OKuIk/d
	MdTP6iO/saFO5UNPI9mD4jfEh/Z72MOj/MXGVKoERwJzjx8wPzgYq1vRlrF4laUoEHpMvf
	HQsiPElq4sguPEu4y3tr3OHz7+w4KV0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785623688;
	b=JKL/laX5E/3z2Jh6CeX+XavffD5rzj9MtF+0UvI7BfQ8FXQECLnG5PMPTq7IKyD3Y9kMO1
	IZtJxvGrS9taDPAz/3lVH6pANaHYo18cf3H9yrzkrN6XrSr7LBsNGaoWzdphFV0UkyRfRa
	XAMgRFWezgLsyW/KW7FejgFhMFg+PAg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aF0tMJwj;
	spf=pass (imf27.hostedemail.com: domain of pratmal@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c10ed63c0so125921cf.1
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 15:34:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785623688; cv=none;
        d=google.com; s=arc-20260327;
        b=DuxNGaU74CbRX91uuL90XfZdJ3s8EIfNCA8k6ppY1FH9drjX44z2qgDWVK939ns2ix
         sI5KqSidkKTq9rQTs6a4Emj4pff5HFlq0yYYrVQHRyPONlos6/hyINwY3rAvzkoJ1Qe6
         IqpNcu9eY/5+z6fXWA+8oIUqiGhPTO7SfnRIcRyGKIkd/OF6Y6LengVQUhAZgz+AHZFx
         5wDmsrZehYY33hxBJ7gUn8FRcUXbxzCGNo90m03K1fnIDO+jw93z+bS58Amz9ErAn3X9
         Jv9m2UZus5HBw86dIDzTSA/yEiLpEsOobisxoQ0LhjlJf8AA1PtgxfMfvgB3wnfZTxIE
         9JTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ge2Z+XX709xzAtZe7afFgNbCFGM6FF+LCnu7eUBhqgE=;
        fh=sMbZ7gtnoZWe7bzA08JoMAVKSNRn+18qa+oZKed80HY=;
        b=rqQoocmP7i05lMiEXqlhS8nOYQeZNDy3BV0hnu0fwwS802gVGHXOyLfzn4Bf60Zrhn
         DUeimn8ZxNJJ16NzrsE9jkPyt3evoEOi3obtsVI+OjWNPxU7BcWiTjHqC2BB6Tx3yDy/
         UjwiTdi0skA9G2oE+b2M6QUGGHOnAe20Fk3sPkt+4YoybiPJELvS2suIee08FyoFV/4I
         QjokO8W0iT5FwKIbqnzFZm8NsBZ0HrLYFyfaxYlTTa6CfNGptQRj/375XkEEfuvzMWTj
         uWJ3+UWRFfXMW4VhNhJQowoEaRlEMqMvP0L0Z+/sO4C3I1kUZSUvkO/qF7T4oohbWeiQ
         zrUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785623688; x=1786228488; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ge2Z+XX709xzAtZe7afFgNbCFGM6FF+LCnu7eUBhqgE=;
        b=aF0tMJwjrc06BX95aJvRfi2W1FXKC++RdMUnH64KFCjOlGky3ShZyS7J8JB0gMlhCL
         W0u4slQ4QPkOkebPDPBoVPu9ekkBbHoOFyS2iIyFg+Uy1Wkcpipg8kTfJyvUnICKxM1g
         +hRH4DvnCn0DMpC7fL7JIDPRUDKlVqh2u+QZ0ObiLlePlOE2tpDB0rZ1czTlBOiC3/5a
         KrciGc+l6Z7gwqKrX6NYJrA2z2q48nXVXedAFjhOsMSTYzGHUD0QLZiiRb+byeu9OtJt
         92PGKGGGV8HcXq7KRiNRR83ICudE71VERR1nRtkO1pnA47AYX93IhJ8FAMyfC42jmDGW
         Pgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785623688; x=1786228488;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ge2Z+XX709xzAtZe7afFgNbCFGM6FF+LCnu7eUBhqgE=;
        b=IPe6rjAtf428OQRL38BGPohXw8Thaizlpjpp9Lssp8UD5BdJA5I0qQcg2bny1SO3Be
         CekaPShRYwSmu8CL9QQiLX+KJ1xjdQHlB6vekj0b6IPx+4q/tUZPYuelcLbnohZFu3a+
         X40MjGiy/xwaSufIF3kBj2iQCzKb9GfBHik1yoz7SipJ4uTSBMO2U2ifd91VSMNECNf3
         4r87vQvCDJRs/iMZWrf6jNAFxoYJp7qh4splAM9BJ+SYfBvPwaLix9/IfHb1ZmtPXP4m
         63kKRQ69NrjF4Vzx+spV1xVGf4aFiTcGV57NaD+k9OIuaR112g59rYMUoiV8Q+WOPJ8q
         LQnA==
X-Forwarded-Encrypted: i=1; AHgh+Rq4CQeRzdGZzgehlEXP/fhpJzh5XDJuyTt519EaZwtuY7vu/HX7yL67uNT0/FWeUeTgaI1qDvTGtA==@kvack.org
X-Gm-Message-State: AOJu0Ywz++vPD9OoFmU40Xzj9WzhbB8IGA0VghVTM5Hd6Tfp2QMGVp+j
	z94vJmaCeZZuaNcXhDQc9uNRXF0wOHQSXiZfhpX+pe0SvZyRyLq58ba618y0GDoCCXNKpRssd8i
	v/SV5kgarWn3nTkn/CWwk0liqTleJjQiQMk2Zr9VK
X-Gm-Gg: AR+sD10Xb0cLUizy41dJTIyFPWUJ+aVamS6P6MZv3Necq4hzAGeAWUWO0y864wC7qE7
	30BmFpjYBGJzlqGHiPfRlWRmyDt2QRZzaiB0ST9yAi0ljt+SjerJtMzCpv9FyCKNR4n4hscuyhr
	mdfUQdxL9bzhrO3ajVNhoJumUCZrL6qsBzs+5nuy4safWbTRWLW8rm/mgyqIJJBEwJF2XybTCJK
	FAmM0Zw5uvx9rA4m52YH3NkBHV79F1l0R204SwenRP9M51IYL3LF1vaJTT+iySZfN2THJU4vnJH
	NjBNABERw98gCzpdq9KaAGsce4bqhiDdKh1Af6VLiCQ2V8kaRpSR5PA6QO/0RuoSZQPSxr74vgs
	YEA==
X-Received: by 2002:a05:622a:1823:b0:51c:935d:8d74 with SMTP id
 d75a77b69052e-52b5b0e51demr14219141cf.9.1785623687170; Sat, 01 Aug 2026
 15:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260512010148.1175-1-sj@kernel.org> <8356ad87-9c1e-4068-b5ee-86e8bb669c3b@arm.com>
In-Reply-To: <8356ad87-9c1e-4068-b5ee-86e8bb669c3b@arm.com>
From: Pratyush Mallick <pratmal@google.com>
Date: Sat, 1 Aug 2026 15:34:35 -0700
X-Gm-Features: AUfX_mz696M7XR-goPw8_g3II4Wu2Zq38_AHsPjgxwAEVHxBd9Y69N2bHp4o46g
Message-ID: <CALHaPKcpWpT=T34_9dKHPNtAqvwHs=_Z0Sv1TS9jC7ezoRnQHg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] selftests/mm: use pattern matching in .gitignore
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: SeongJae Park <sj@kernel.org>, akpm@linux-foundation.org, shuah@kernel.org, 
	yosry@kernel.org, david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ACBCE40006
X-Stat-Signature: b3oi7s9j9zxfrpxujfg6r7ikmjuii66q
X-HE-Tag: 1785623688-85049
X-HE-Meta: U2FsdGVkX181FnYc4brHLrDB3wkrnU1nsODLmuJhKPNcfm4o+DnrlxxzJTmbSPv7xoBrYNuPEuJEonm4LZpJDQjjpoSezrJ/p9s4JO1pBhDblP32hNnH6FWG5bAQ7WaODHKu0u0Qrnm17mR0AVYQYrgfVjsnR5HHvx6lTHNEPzAj3YLeU5f+2eDYfL8mBBc8Tw8JJvpi4nLsIDnr1uDi7smg3rw9K575GoXAqQOHJN3zLfK2yOr1aVOMNQ4mYxN6ZOq6zhjDoEUzWFyEis+fTXS7+5YV3rtbqdYSfWjz6BnmtcD58R/8r4WTHlRJgRCL24mH6HzrTbhSIibWHJPxvPmK/2hFykxFM7yckdVaopLQslmmWTU9FWMWqokHH7gJ4HQ5hDxjB/l+DGyTljNss1XTqsR35ScmZ4xNjRtn98liikUrqW9/r1ZVEOzAt9PJriyQVGxiXaQ7Yism5Ixamh3wD0P8oOhsxA0EHxCwJ1nADeoxdTmua5MBBrkL5wCLHDIYVkvqTxGNOSdQX81dwXWazDKAJQKSsUpliL9r2AZ9hbdII9wfKcPzi+gl/H0qhi+hdur21B3v6wgF98eyOzBlgGl9qFPoAVfiSoRp2/4RS4PRjb2cMeUgb+FkaDO5FrMLFFbTEYWKuWpp2Fmgpd58vqkEZlNVy7inL90PGvCmgTpYq1dsccby8vtuGrF19PGw3zngnUw4SARX/Y+gSqlAO0p5fZTQA7X8Io9FfvxJfT0pElV4iaWaYXERbDLZZvHiOMcAwSFDEQCEJ6rpnJ7ajRpcKQHFVRYCip6uE+0WzdJWNcrp2jEuNG05ZcsNy5lh0mNXOhOSSm3Ff3oGqT1xY9rOAeRJXgpD+u9fOhBmJVmCrwIbSS8pp7WWjBMe1EPLcG5wyP/LsqqGJTC2Ieq0LWwu410AOhWDB84qdGypKRhG4ELcyUVj3iP3AJbNutNqADw7dj/u7Y7QAEq
 4P/pfqUE
 T+R0xiMEUz0CCU9ToXTdfYUDsJGL3JJiTgXWcphsovWHFHGoQvepxT/NMWDx6DNQMH2mwNOOhZWmzKxuhwJ24FpWmCA/8eefWXOiJ9AHhxrRAFs57WMD47NNGdOG6hDPB+LAo8tENxKmFFfFAzm7WmYcru9q8uNMI1AKaGNG51+R+BHLAg36CIH9xmVxOWJDWDIecEinV50TJ0COTtAaXyMFchSMAuLApJ/TFjjJJLJX1Qac+9B53RMWtyNEpGFBExovBkkr4I0E9XMkCsC8AUaE/+tBbmfezI1goWl2yKG5SWU3SPuC0nWQeHXPBXLoY9bUHoidVywDtp1ilGTrMjpf4LC3rSjAhZmU1bQ8lfzuG4Ren/E4XtKyt041wEfrjKv4mEZtxMoVSONqDSZV9v22bTF3HYGohDVK9cTw93LcJjJrvzNzfjzIkNMESS7YDaChw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

Thanks for the reminder. I completely forgot about this.

Will send a V4 with the patches reordered.

Regards,
Pratyush

On Fri, Jul 31, 2026 at 2:16=E2=80=AFAM Sarthak Sharma <sarthak.sharma@arm.=
com> wrote:
>
> Hi Pratyush and SeongJae!
>
> On 5/12/26 6:31 AM, SeongJae Park wrote:
> > On Mon, 11 May 2026 17:34:09 +0000 pratmal@google.com wrote:
> >
> >> From: Pratyush Mallick <pratmal@google.com>
> >>
> >> The current selftests/mm/.gitignore hardcodes each generated test bina=
ry
> >> by name, which requires manual updates every time a new test is added.
> >>
> >> This series switches to a pattern-matching approach (similar to KVM
> >> selftests), ignoring everything by default and allowing specific sourc=
e
> >> extensions. To accommodate this without tracking generated headers,
> >> local_config.h is renamed to local_config.h_gen.
> >>
> >> Changelog since v2:
> >> - Split the changes into two separate patches (header rename and
> >>   .gitignore update)
> >> - Added Suggested-by for David Hildenbrand for the header rename appro=
ach.
> >> - Dropped David's and Yosry's Reviewed-by tags.
> >> - Kept Lorenzo Stoakes's Reviewed-by and added Mike Rapoport's Acked-b=
y.
> >>
> >> Changelog since v1 (RFC):
> >> - Renamed local_config.h to local_config.h_gen to avoid conflict with =
!*.h.
> >> - Updated Makefile, check_config.sh, and affected .c files for the ren=
ame.
> >> - Removed *.mod.c as it was unnecessary.
> >
> > Adding previous revision links together [1] would be helpful for people=
 who
> > willing to see details of previous discussions.
> >
> >>
> >> Pratyush Mallick (2):
> >>   selftests/mm: use pattern matching in .gitignore
> >>   selftests/mm: rename local_config.h to local_config.h_gen
> >
> > So, after applying the first patch, we may show local_config.h unexpect=
edly
> > shown on 'git status' output?  Maybe too trivial thing, but I'm wonderi=
ng if we
> > already considered doing the renaming first.
>
> Just a gentle ping on this patchset, since it has been some time since
> the last discussion :).
>
> Would it make sense to reorder the patches as SeongJae suggested and
> respin? Pratyush, if you don't have time to send a v4, I would be happy
> to prepare and send it. Please let me know if you'd like me to.
>
> >
> > [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> >
> >
> > Thanks,
> > SJ
> >
> > [...]
> >
>
> Thanks,
> Sarthak
>

