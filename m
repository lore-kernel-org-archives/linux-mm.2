Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11B4C61DD7
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 21:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBA06B0092; Fri, 28 Aug 2026 17:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C546B0095; Fri, 28 Aug 2026 17:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B9B6B0096; Fri, 28 Aug 2026 17:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8505B6B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:10:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DACC0140561
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:10:57 +0000 (UTC)
X-FDA: 85151922954.11.C317B2E
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 19C06180004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:10:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=H6q3qA6z;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787951455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tScSPJONssrRk2WXz6/33ewRDUw0skQt8yglR8/KZoI=;
	b=SXtnqGEguYr19DPrzYGgGhMqmzfH3mXB3IRKfZmnMcGRFe2k+uoP8sF95Tg5mxkTssFrT6
	N5Q2xjXELS5CvdxIN37ykLwH8CxGjjgEBISoIcrhQuo7Kbnetn86w1su6DXG5SamAQ1aVq
	7gU+Q5hmJ1JjiyxAGmEzvbs4GS5KL38=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=H6q3qA6z;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787951455;
	b=D8/lOpwyFkkUa8gEC0+cOzmoBwWjrUCPwMlM3WHLlDV8QOMR+jpbwEGnnPgmc/vyAFQ8Nc
	Hjdk8eCVVPTNTcvinjLxjI89PiP/4R5PpMHkTmPtzNzeqoPlR8aNeEncbwOh88sxiM9DIb
	3ppATqSNn22fL2S24tkXeoqOZ4zJeYw=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d58efc7356so16353365ad.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:10:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787951454; cv=none;
        d=google.com; s=arc-20260327;
        b=AgqNb6+lxit520e90D+mmUtTLpPcFC4v2Dt0CZfrR/uQv2H9L1kO94frAQ5ae6sOPw
         +ZbLu06ZnL/A3WF6EC6Z2h8nw4uMqYZCzZ9fPAxil6T14J6T5e6FwBpYFTw01QhzyvgV
         ouF4rNgS9TBd6vjvAIiPjm2DRXTJHUF8+GBQ8qTunxz4OFTnABVsflHXqYosSZv/rtXz
         yR3+h2/WcFTGsrwFFhmA1M8NIofjgunh4W045GPk1MVrCvnXQHMaCe4hInqEQhgJKBDt
         YmF6DNFIMuIvKJSmhZ5mo2Fck22d6Cf9oMzYG+KiK2k4zsfL4AtEz+4TJb+30p9uUxEO
         d5yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tScSPJONssrRk2WXz6/33ewRDUw0skQt8yglR8/KZoI=;
        fh=yj2+i+ha5ptq6FbXCGu5L8Ul2S445sBip/YTAefRaH0=;
        b=Cvw08JmTtUgKvHOKnJCQLBB9kUfNGDQ8T8BGZjDSFE7Vh60R/y8B6wEqsXukvQiodm
         /SOHUJc8pKvPJAMdjHSKJxMowjmKajyYja3oxcNHc9rXACh7zHe7ZwPtiMBaWxddqBPX
         CKl33R8o6j9DyiN08bOlope0JgsvCvhMXEBnlXUySQPk6LW1D3GHkvw9zt0hCqzlWICm
         8JwTNjwGhN1TslMk+oWRQ/KHRTDczYiCh9iN9IX1Ik4hIw4q3W+mCspmRlRTKptX3uHK
         BN+IG/ItMVahliZK1mhg/XqenGxvaO/zSThKDfw6LV1eqst47Vh3m6O5epmiUl71EovW
         szCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1787951454; x=1788556254; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tScSPJONssrRk2WXz6/33ewRDUw0skQt8yglR8/KZoI=;
        b=H6q3qA6zo1mQ9PVgzLk8J/ynnUMiqWwz0mQChkfsVgwxTNppOyTCtDGpAj0gSTrvqt
         3XJV6gPpY5fUSLnJPlys6+4EIp62LAwUT9vPqmeX0asMFhKSrgfW6tPVUgqjK5tGwTG3
         5q8L4Sh3qZIbQIQCvlm4KfU0j89/TUV227wdwkD9/QWelQ60PCRZzD5KDfktVbGb67nq
         pM6zwytAzt/9WDejPneJHpYRlDvdfBWYctQ117HGIKrwcwQ0miyxvV1CNvQfinouZSuY
         S2tD2Eb2+t4NtzQ5nWQFL0SMyCkrw0VI57y/vd0dV1TDEE4qq0UWoD6pQzLPD74F/OKU
         JEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787951454; x=1788556254;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tScSPJONssrRk2WXz6/33ewRDUw0skQt8yglR8/KZoI=;
        b=DajmCR8mOt8ceTjq4mY4MpkyFtIr0mAiq5XoxlpU/v+Xo23F7XkOhcIWdtunDs+wmr
         1qBjVgzI0BI+4YoZuJFunkPIORhxJumldnGDaw+GlHucuYDYJJd9I0jd3YNGWrEs3H8b
         Xuzf3ZycUjCdRF7C31WTTOcOmexWfTNRiFhSgnniF44O0YP15RAE0s7walPssVIHt7WE
         QsmkSpj8BbC5as7Ibc5DG5M4gqBiNfVei9TteSXblJjJRhgNbWuUUVWUtSGiKoVmQWJZ
         j2R4wklwuhEBTOvImVFR+lCdrvPCzsGmbtCYbBqvLElaZBeaVa4lACC8n40Y8SiO8N+b
         e8+g==
X-Forwarded-Encrypted: i=1; AKwUvBx2q3zWmr9+fqGAEbomFf+KH2J7PJw5VH2XxqZ0PKcpfs7AsUZQrK8YKAG7vpyFoczaARAVnlwdHQ==@kvack.org
X-Gm-Message-State: AFuF++l236/DcCSbAvNvG1z3QLbaYH12XNnoVhFvwf7K2qZTV5Welzf3
	64S5p9lqtdJONJd2jeeatJlXtrK61Puee8UJ/xE1RNyEY3NybKGsmYUJrqfnSCbk+kQkb+FjW5m
	KA6TZMsHEgy6axXNA1Z84SrphAhrq12/YgGSgZ63n
X-Gm-Gg: AYBFou3BzvXGgX6yVBtDQ8Z0XxrGRPnEZBGHZKvLBuCyZf/WQgfzJcTH178bktDrgtK
	cf3vY/HXszWEeOUjt6hNCUqWzQjW0UVBiwUDW4r15RiLpVasZHGrT8g9PaQgYOAoyUy3ZZyghK0
	fVfiT3+MTa6QuYMwC3d0Tc8ePqpqWeUNPFnze2//A2/D20ks5FKvMssal37bI1vR1lW3ginMbuE
	K6BYKigyFTzjxdfRuCFIZYOL5f0TY8c+b65zyL4BlzoIldvw9f5h/JlUZhZt6XhQPSsHXbPKoZT
	y37PwYmiWPPZ+PqBIV+JdvWe8OxfSUGewr+tlzxuGgsWm0JQfx+M5BY=
X-Received: by 2002:a17:903:b83:b0:2d8:d4d0:792e with SMTP id
 d9443c01a7336-2d8d4d079b2mr38565945ad.18.1787951453839; Fri, 28 Aug 2026
 14:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
 <82929c994076d95f99560ecc67f6cfce@paul-moore.com> <CAG48ez1rd3cFhmGn7mWkaVvGqYg+cDiGUhuhH6r51dUm-QBXUA@mail.gmail.com>
 <CAG48ez2jgJHewZYK1SVccJmBa=bjoMW80SPNcbgW2XCtZaWhjg@mail.gmail.com>
In-Reply-To: <CAG48ez2jgJHewZYK1SVccJmBa=bjoMW80SPNcbgW2XCtZaWhjg@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 28 Aug 2026 17:10:42 -0400
X-Gm-Features: AcwNN1WNKsySMz2VwH2iqet3Ed_WMqL6Q3m5wfbte2R22sYcRFQ3wDSSX0w0dFo
Message-ID: <CAHC9VhSHMmJn4bkRUodAnrVGTb57qZx3tL26g91jD_ocQCNLeQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19C06180004
X-Stat-Signature: 9qpp7titfx3m8jw79z7hfod8eeqrsi69
X-Rspam-User: 
X-HE-Tag: 1787951454-335942
X-HE-Meta: U2FsdGVkX18A9gCJDc8+mkYc2chpDW+vUznYtugMHLYs+QARLVdXlLUlYTelYXnuMEFcitJ/ImjiIt8Te3o4HDKkiO40eRyJtERhOPIZ9/M3mEUTgGAX7fLaQv7S4WIV9HfnCXVQGTolXIPkcWnO+ozkNJXINhRSdvsfCdzvuBcLO9ddYzPiOAEXyDaV/eCvF+Ch7N2gI+gqgO+MlntBuQkyfKUwqPpizxmmpGCbJj/K8ahwYxzBuuFq4UbrZk+AQgP+01m08jaO8nzuDAGCjB6Ps+Je0RMkPDbSLQlVpFCg4MIXnuHA6SDsCyinU4Rb1O4dS9lOoJNrRxb2D5GLuDW/ScvhfOqQL3OesPzyUhtPb/gxwCwnRMQBN7pZRLWISxJ9lpG/2Ygrk2TEsQSyCqELjpWzBkhsj06E9iW+n8LYs6+xTckPpDRgE7fIxnzQmfhyvBH9y9nFV+euKu7qZINY3NVL5i+uCwM9xEX6KjDBqlT4Jh+lQFO8OIqnfrF1cNsgvS+G2jeikUinz0SMY51YrscbqcwiBr+EuK5VklNWltWTDS2nnNDQc7WkHG+lRN9GR5S2Wq3zIWCGjyEyP2OZsRlvl8ViIFdo7FgVa+uEf4GNc/U0rSOZjo1WoZCPM6uS41+FyjI6/0eAliqPLPRY7gq9TdpwKFnfYoS5E+FjHJnXY/8slQHluooLsq4+Ou/hgNBsngXLz9Q4LzdYhx2xNsQTEXQAtwEkErx8l6rBiVjfTkNPKVQlEc8z5BzyRZc4Ajz/gNeYJWyM2OsBhWrPw0a54kIgZm/PVjInpy7awLG9QeML8mtXKlQ+2H/MrKTUMZXzBY0gDDH627kWemx7i8gCyzP/N/RLoCwqyjWL3M3NCwdJWQwWhjAkDq97vYF/RRvoMNNom/CvElX2UMC3y3wPDrc2Rc1fm6s3xqZRN23/JbdfEZGESWWfCclKW29YAxIF7uf25Ez4P5I
 ay8itJQR
 4tEaiU9lee+fqmyrw0YhD9cmNVlxPH2ovkW0iH3C9OXvb175TQdkAptL0gUnWlARfcUg9fE5QKBU0j/6rVklqjKRfuyZ6fNm/Kb3T2J/CozQuEK8UAhzFOcXbjBnYbnsxNQg4RMK7rdwuz4++N+CCpGGSy7Dh0o/t9OCR0mz/rtdJ4YeWYK4DH6Ms4II71xjSHKsG8Xt2sscES4BFN6x18zePkC4jE7djelg42UUW17HcAk9PGHuXVDjBbUstqptz3kBtXp8g+VkkacjC/C7ilg/UynINvXLL6FXKrCP5ZIsR+3KG18mmnCqiyqKcB9OJHtUfYGgE9pgBnR1WGlli8+9Yj6njRLjZVf4tnxRwSPhg779c5PuHAEkNNFvSctxMPOQey0J+8tKW9EJqmJgGh6yVGIekeXtijXbms3Q0mVKrWm9iHq4kRIYT1vWyNPBtHqqufADu7Z/4aoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 9:21=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
> On Fri, Aug 28, 2026 at 3:03=E2=80=AFPM Jann Horn <jannh@google.com> wrot=
e:
> > On Fri, Aug 28, 2026 at 3:10=E2=80=AFAM Paul Moore <paul@paul-moore.com=
> wrote:
> > > Beyond that, we really try to avoid making LSM hook calls conditional=
.  It
> > > can limit what an LSM can enforce, it tends to be a bit more fragile,=
 and
> > > it adds some unnecessary work in the case where CONFIG_SECURITY is
> > > disabled.  I would suggest passing 'opened_by_owner' flag as a second
> > > parameter to the LSM hook and calling the hook unconditionally in the
> > > default switch case as a replacement for the 'return true;' statement=
.  I
> > > understand it may seem a bit odd, but we try to make the LSM interfac=
e as
> > > generic as possible with respect to different models and this is one =
way
> >
> > I guess I can do that, but then the question becomes, what other modes
> > of using the LSM hook that don't currently exist in the kernel should
> > I be supporting with this? I can make this a parameter, but any LSM
> > policy that actually uses the parameter in a different way would
> > probably be buggy/inconsistent, unless other new LSM hooks are added.
> >
> > If your intent is to make the hook work for any /proc/$pid/mem access,
> > including when the caller is ptrace-attached, then I guess I have to
> > move around the security hook call in proc_mem_foll_force() a little
> > bit. I guess I'll do that in v3, though I really don't like trying to
> > come up with a reasonable in-kernel API contract for a scenario that
> > currently has zero users.
>
> I started thinking about how to implement this, and an annoying aspect
> about this is:
>
> Currently, I only have to look at the credentials of the opener of the
> file - that is both the subject and object of the access. But if I
> want to provide a hook that works for any /proc/$pid/mem access, and
> want the hook to know what the object of the access is, and do it
> race-free, then I would need to grab the creds of the target task in
> mm_access(), bubble them up into proc_mem_open() and mem_open() (which
> will require touching all the callers of mm_access() and
> proc_mem_open()), store them into mem_private there, then let
> proc_mem_foll_force() extract the creds from there. All that would be
> unused code.
>
> Do you think I should just not provide credentials for the target, and
> document "if opened_by_owner is true, the subject credentials are also
> the object credentials; if opened_by_owner is false, you don't get to
> know what the object is"?

From my perspective there are good reasons for not making the LSM hook
conditional (see previous emails), but I will happily admit that we
don't have any (?) good reasons for attempting to generalize this hook
beyond what it is at this point in time.  I would suggest documenting
the limitations when opened_by_owner is false and leave it at that; if
someone wants to implement something that requires more
hooks/parameters we can always revisit this.

--=20
paul-moore.com

