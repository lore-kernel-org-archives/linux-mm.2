Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E5A606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xAbTl858
Received: by kanga.kvack.org (Postfix)
	id 102D76B08E1; Tue, 27 Oct 2026 16:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2F96B08E3; Tue, 27 Oct 2026 16:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4656B08E4; Tue, 27 Oct 2026 16:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C512D6B08E1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:52:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 466911609F7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:52:41 +0000 (UTC)
X-FDA: 85369604922.09.4103180
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 58F8D4000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:52:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xAbTl858;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of salehmammadof@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=salehmammadof@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793134359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LoofaIKz55kWAcyDFISKd9SC93RZPVKbXtvYHk+8LM=;
	b=oQms0ch4O9Drm2M6k859+IBspkQ5frAcm6Gg9jSEgmXUWYR44CXMJJ3aTlRg1GfNdLjMZg
	1VvYZRMV7qystQJNGDUs6FpgwQE4bWo2xPrz/UBhRML16kTNgRcNYPwBBdgNkRQQu+FRNl
	ao4+oOcmUAbNhq+0E+Fuz7+dZr62Dis=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xAbTl858;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of salehmammadof@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=salehmammadof@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793134359;
	b=c7QfTykjiB79oS+4ypsGiuNtogzplv5Ilf9OxD1+/Sc0r8TOt5+Fvjp34fLyRRWv+zOpDB
	PGxy33XoeNjsfs4h/G6xLA4EFNYm+sdopZm8Q1UJ+yjmzvsckPlVteVrMzLHzXPJEeXVWj
	nK2088WWazWgKUK+aOAJ7loxOq5oBeY=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-157fe9d771bso321911c88.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:52:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793134358; cv=none;
        d=google.com; s=arc-20260327;
        b=C+Q33Uvs9IaTGD1BnxPpA7sYeAI60Hx+eQPNloNYq/u1dz5w3OOOSxBkdK7LShNn8c
         vsMELfNT2DW+1dqH3FVmwmTG+9A0mNXS+XRq4YJWauJu8MhbHDl6DlWwUbjXs/E+OjiO
         w5KjzrwFTU80aQeRtge0czCO3rUaJGwQVIwuvvNfW6Ktu2UGn+QZLgZpHIAr2lRRT3HF
         RPm80ReEVXAlQYVmt+GwoGyFUYnfz8pWZzcvsyN/EY3J0en6wPgIhvrhQ3KjID/L/QgD
         uYU06LwTpgMjZGby872SEgUVkJFqwupqRSctJkEauVe8MYxsiXy9HoKkmK93GNeysDVl
         ilXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9LoofaIKz55kWAcyDFISKd9SC93RZPVKbXtvYHk+8LM=;
        fh=2TSRbIYuQ1Lhz/nSQM8m78ve/MJyzCCa7Ye5M0I+Hqg=;
        b=DjkIVOmj03LL8c4fQL3GiK4ZbEZXsbPr0bGPi7Ffk1sRvXQTx5NBda3o9AjUI3GMeL
         iZAv7CgoXJH0oy64JEcsX0TcZHB/vARQBRBnNZ8lFNqJDhS79QGGErrBI3K49J77hk2S
         8HI3enlRzrdl5omYHiKHYaH+hoV0230QOgFW/8xig/Am+CODHel/deQpcfz5oeqmxa1f
         VnbHN+jBhk7ZZqZXagw9PMAd8beMTMnFF7Nd8nxII9ZQkPd2EUjYewfgNeoNXm2QSvcC
         ceccd3/dVgfZYnAWqY4onUbD76o/ZKREORak4lEgK9N8KQV1Q6Zf/EHOGu5BnEnpXEwS
         kbXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793134358; x=1793739158; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LoofaIKz55kWAcyDFISKd9SC93RZPVKbXtvYHk+8LM=;
        b=xAbTl858TmPeKNkrgex59jzu0oh774DLuSuY1M0cwtq346FM0lL7s5jCFRozpwRbbw
         x+cJCk1nO1uRc0utrVXTFoFmtfxGeQ3Aj5oRycnAWUkzpZ0MEYF4xWTg1TrKLpaOvGZa
         ue4f/1rXwDFWrNeN0o7BNtK2hL9P9UTlEoq7Q3KSEepZQDKAI2Z6DN/GrqPkdHM2f3JY
         7JP6VaRaz5ryDshsAIaNXhRT0ZPHuTeERVM/nZSSW44iKp3kPKzXovttQ9U0u9tvYK14
         UehR2lkrj1mj7Y7fQyoChowhfwXLRIoOqm8PZQiyAxAlJm+VLlmszyuvOA0tvh0HvnaF
         UlMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793134358; x=1793739158;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9LoofaIKz55kWAcyDFISKd9SC93RZPVKbXtvYHk+8LM=;
        b=oCt6QkN6aTvWN6E8jaSMhubavA5/tdV2gCsWNXnijZarGWUrc536BdPpHPziME+U5t
         Smyk+nTczAajekwegZNZNywVLHUeALOn/134qhyhNYF7RU80pd4hN0Hankq3Qjzfp3AP
         FGkOiXC7lX477DuRgcuUkACXiXbrQ1ILnR0TfBlG56Nnm72zqiTWvuy09jP4djQbYn2r
         j7D5n7KpOuNmGUOR7jGBQSAzXELmP6KflZ4qN2MX1IsrdAlwmpd8OhsW+kVZFmfa/UnP
         UX8L50sqNnJhcqgknP2EppU1PE0jYTA54gly7lWySGic6WVBrfkW/Sa+jhj3fsrZ7N0i
         S00w==
X-Gm-Message-State: AFq9FYI8RA5pLXvCcNxAhI5VGp9XEwBVjNLfoHStq4fgfNHdmYV7XapV
	uG40D+BqpjMRrNnHns+RtDhkBRd04NuJqHNRV7jclzlOsUnv6RIQmRhwhYIGX+dOZtUSWx44bzL
	+uP8iF0YVWXPFzK4ox4x5/MfB+SB6FVw=
X-Gm-Gg: AYBFou3GwuxBeXmo6Z0pFfkcZDhQxzZiD2L0CzhtvmX1cQ9nwow/6FG+CznvPtju9nX
	L5B3dq1+SYJMh8Yfnl/glm927UBOan2CHsIxN66JbHvmTborsqhT28XoxncELuz+irL+1IegRkF
	dy/mxJg4oOJN/2wM26yh5XerXtnr21h2fmRA9FCSY2gJf+5s7G2yFRl9bHP2iOhJ6xZoon7qhy7
	s68kTFqFH7l5lqVl3Wbl4GCbn0uDRVp8i6yDoxpM94gveofiynZNYr4g2NRiaIkclcUcqxMAC8j
	sSHM8be5A1eG5dbUC4KdVs2utRcyX5esBRj+jTxR7DhdtZljtsoBYiLb7tWEidJ3FGcY1yqp6ye
	Hccff8jKmF9o+0B1Q1Fp7DWIWf7iL6bzC+blKl7VroPmII9tvhPEF+43EOqvEllHq2PjX
X-Received: by 2002:a05:701b:458c:b0:17f:7280:134e with SMTP id
 a92af1059eb24-1a6cef7a368mr407794c88.32.1793134357875; Tue, 27 Oct 2026
 13:52:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
 <o5sj6bswd6arkusrxj5w5ww3jwk5hz7ktzxvdik72h7c4uen5i@fnwkmk6hvuf5> <CAKu0nJWyt8OGYkYBdnUnWo3rT-FwKEwoTmsCe71vC4cfUcbE0Q@mail.gmail.com>
In-Reply-To: <CAKu0nJWyt8OGYkYBdnUnWo3rT-FwKEwoTmsCe71vC4cfUcbE0Q@mail.gmail.com>
From: Saleh Mammadof <salehmammadof@gmail.com>
Date: Wed, 28 Oct 2026 00:52:25 +0400
X-Gm-Features: AclHuK_SBRlqLLn-j1HyYSLGmNovybSzM-arAzeYTesz1U6d3Tv7tIew-cdLlb8
Message-ID: <CAKu0nJX68hxKU=G+bNq5HaUF9yPPy2bS3ifo0O=qwcW1m010Lg@mail.gmail.com>
Subject: Re: filemap_invalidate_inode() - losing -EBUSY from invalidate_inode_pages2_range?
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, hch@lst.de, dhowells@redhat.com, 
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Content-Type: multipart/alternative; boundary="0000000000006f93f1065ed8a03c"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58F8D4000A
X-Stat-Signature: 8jmzuocuihjy8gea9kjactppwqfyag67
X-Rspam-User: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793134359-605705
X-HE-Meta: U2FsdGVkX1/E+iseROKfJ6lfm1irsaWMK+8krQAKKG14tgaFD3TWXlFdD24YgJnQFj1+jRkmgkokueuVyfTv0amd9xcrmS90iTRH50uGxyqcA8h7/DeNV2N60uOIdxFuforp+RT+AixAVHkoBKzOgZRDtRM3y7cbou9f50xU0BWWwzNfpwEo97YreqI2PaD5SuHmydG5C3Qd2Pixx2I2I7zhQLicxUmQe599W+0PHhPBGmW8gC6JVopij5hAqsznDcu5Wlv2a6Fcugdc2tgvDsj6lbrEdffAhXm4TZhGXE+AyBzr3/3+5d431bZTHF7wfi3q9SQ7lRXHNpmWfuazlxrnFVwr40DTdu19NFdt/AA6qORbv6HCK9bJDJuMFedAi8JYuv3zTz4KS5juck048/oO7BPRTWTPS4N05dbnX0XN+BW4ePvXubU/kZ8h+iFfIam8D6QvK7L7oTEsGlhG4OfPYXL5QqdtlP914SquvfXZGIJV++0LvCp1/9cF6U0xlqNNEZQz7UhA7QJLk14b750t5IoU384WM7b9SZa9rOCRGeUg9+/ZvkbwNn3YJJ2Vm1g3WvLWNCDQoTELrL4MBQP27wRh2rizDV20FvNYvuPldyQmN6zf/vqb8ForiKdj0nXV4H6HxjQCW9n0AGshEg56Z6R0KnkZXOtfUd6/fyF89ARI6onkKnVJN2dKKslY+eHq3LFjzNQ6I/eH+E3hUYctx6q2ay5fA60ihsjrjLKxm3Pvz4ZxROmGDzSgsK9quXKnDgdNgOLmTNcWv769D5JxS+ig/s1JziFx4I2qQ1RyhGmCCxaapk9MihQDwpSVzfKFwncoU2wqUAihtkw6pXu7WoD/TvtpIkB9H6pGpP6gMu7oQvCFF42HKpq4wEHVykX35SFVxzhewGKDrr0/K4Bi4HN6VwMFSFW/DaD5qDY7WxbynFmRsG8RTMrDB5hEK7q3lsaAUjrUHoUkgdc
 U6Sqoe3S
 5kQmEQEIOM3YqLaMjkThlmAXR+W/ZzsKHDuSHul85kPU5hdDOuVjIAw57ws1CMZXYy+hRRN4poW8yaJFdSf8bKF+YcP77ZzqcqgY2MxKWkOIQ/xmlJZpv7ysHem2zifjQHRBz8+gyljjzhPnV0UUtrkTzP+4WMrZjVJUYe+blhe1A59VnfUKO7EdeRIrRd4xBnIyKeHMeAbEqs009o/9W5VAMWgSQyxswUEpaPwJdalAgLqzJN4uO4Ud62Gq8EE8JDavTDon/o1K38FJevyOi4ZaOEls2cvKQ7kxDaOFnif5HYfpMVQOnsJTmWwU0/edymaRMr63BaAs8QWetvjl0KKk0heLsf+JGaVnyjqI1TPrssNdGy/LYEdAhPrvpCxpZK9d898DtUO7mNHENx0E2mRZ5w//OsHZMHh0RdST1ZFXlue41vkeqHFc4eOitel7ftLMs0ONFFCOX6kLbJwJde8qKWPBPoULEf/47IavwCRnhIiX+sbSmXz+kOcws3bbtWtWN7pKCJIEy3aP4wBnWCIZ9JvCH3njvR1xRoqQhhs/oZM+tceGP3B0tzIkqxR2wx/JbW75/xXfdTdxfhLTXPks+GGgtiLIopIJsApeaNsrXAU8cDpNkzzu9EsoGJwzp9qm4SuM32d4ibGvNP+2oWuwosQTrilvBe2ldSctFRKqIy38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--0000000000006f93f1065ed8a03c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Thanks, Honza, and thanks for looping in the btrfs people.

To summarize: filemap_invalidate_inode() ignores the return value of
invalidate_inode_pages2_range() and returns only what filemap_check_errors(=
)
finds on the mapping (AS_EIO/AS_ENOSPC). So -EBUSY, and errors from
folio_launder(), are dropped, and the caller sees 0 even if a folio was
left in the page cache.

I did only a limited check of the effect. On a debug kernel (btrfs on a
loop device, FICLONERANGE into a destination with cached pages) I forced
-EBUSY from invalidate_inode_pages2_range(), and filemap_invalidate_inode()
returned 0 and the ioctl reported success. I also made a few quick attempts
to hit -EBUSY naturally on btrfs (dirty pages, splice, dirty data outside
the cloned range) and did not see it, but those tests were small and may
well be flawed, so I can=E2=80=99t say how reachable it is in practice.

The callers differ:

   - btrfs reflink (fs/btrfs/reflink.c): the comment above the call says
   btrfs_wait_ordered_range() is there so the invalidation does not fail,
   because a dirty folio would make btrfs_release_folio() return false and
   the invalidation return -EBUSY, and that such a failure can=E2=80=99t be=
 ignored.
   The caller then checks ret < 0, so it seems to expect -EBUSY to be
   returned.
   - netfs direct write and cifs appear to check the return value; afs
   ignores it.

Question for the maintainers: would you want filemap_invalidate_inode() to
return the invalidation error (with -EIO/-ENOSPC from filemap_check_errors(=
)
keeping precedence), or is the current behaviour acceptable for your
callers? If propagating it is what you=E2=80=99d want, I=E2=80=99m happy to=
 send a patch.

Thanks,
Saleh

On Wed, Oct 28, 2026 at 12:51=E2=80=AFAM Saleh Mammadof <salehmammadof@gmai=
l.com>
wrote:

> Thanks Jan, makes sense. I'll wait to hear what the btrfs folks think the
> expected behavior should be.
>
> On Mon, Oct 26, 2026 at 5:34=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
>> Hi!
>>
>> On Sun 25-10-26 02:27:13, Saleh Mammadof wrote:
>> > Been going through mm/filemap.c lately and something caught my eye in
>> > filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or
>> > the wbc variant) and then invalidate_inode_pages2_range(), but doesn't
>> > seem to check either return value directly - just falls through to
>> > filemap_check_errors() at the end.
>> >
>> > The thing is, invalidate_inode_pages2_range() can return -EBUSY if a
>> > folio won't evict (release_folio failing, launder_folio erroring out,
>> > folio going dirty again mid-invalidation, etc), and
>> filemap_check_errors()
>> > only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...
>> > disappears?
>>
>> Yes. Whether it matters or not depends on the caller I guess so you shou=
ld
>> discuss with the users of filemap_invalidate_inode() what they'd like th=
e
>> function to do. Adding btrfs people into the loop.
>>
>>                                                                 Honza
>>
>> > If I'm reading this right it could matter for callers that actually
>> > branch on the return value - btrfs reflink bails out on a negative
>> > return when clearing the destination cache, cifs sets
>> > CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If they
>> > get back 0 when a folio was actually left behind, they'd think the
>> > invalidation fully succeeded.
>> >
>> > Could be I'm missing some other path that catches this, genuinely not
>> > sure. Haven't tried to reproduce it, just going off reading the code.
>> > Let me know if I'm off base here.
>> >
>> > Saleh
>> --
>> Jan Kara <jack@suse.com>
>> SUSE Labs, CR
>>
>

--0000000000006f93f1065ed8a03c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p dir=3D"ltr">Hi all,</p>
<p dir=3D"ltr">Thanks, Honza, and thanks for looping in the btrfs people.</=
p>
<p dir=3D"ltr">To summarize: <code dir=3D"ltr">filemap_invalidate_inode()</=
code> ignores the return value of <code dir=3D"ltr">invalidate_inode_pages2=
_range()</code> and returns only what <code dir=3D"ltr">filemap_check_error=
s()</code> finds on the mapping (AS_EIO/AS_ENOSPC). So -EBUSY, and errors f=
rom <code dir=3D"ltr">folio_launder()</code>, are dropped, and the caller s=
ees 0 even if a folio was left in the page cache.</p>
<p dir=3D"ltr">I did only a limited check of the effect. On a debug kernel =
(btrfs on a loop device, FICLONERANGE into a destination with cached pages)=
 I forced -EBUSY from <code dir=3D"ltr">invalidate_inode_pages2_range()</co=
de>, and <code dir=3D"ltr">filemap_invalidate_inode()</code> returned 0 and=
 the ioctl reported success. I also made a few quick attempts to hit -EBUSY=
 naturally on btrfs (dirty pages, splice, dirty data outside the cloned ran=
ge) and did not see it, but those tests were small and may well be flawed, =
so I can=E2=80=99t say how reachable it is in practice.</p>
<p dir=3D"ltr">The callers differ:</p>
<ul dir=3D"ltr">
<li>btrfs reflink (<code dir=3D"ltr">fs/btrfs/reflink.c</code>): the commen=
t above the call says <code dir=3D"ltr">btrfs_wait_ordered_range()</code> i=
s there so the invalidation does not fail, because a dirty folio would make=
 <code dir=3D"ltr">btrfs_release_folio()</code> return false and the invali=
dation return -EBUSY, and that such a failure can=E2=80=99t be ignored. The=
 caller then checks <code dir=3D"ltr">ret &lt; 0</code>, so it seems to exp=
ect -EBUSY to be returned.</li>
<li>netfs direct write and cifs appear to check the return value; afs ignor=
es it.</li>
</ul>
<p dir=3D"ltr">Question for the maintainers: would you want <code dir=3D"lt=
r">filemap_invalidate_inode()</code> to return the invalidation error (with=
 -EIO/-ENOSPC from <code dir=3D"ltr">filemap_check_errors()</code> keeping =
precedence), or is the current behaviour acceptable for your callers? If pr=
opagating it is what you=E2=80=99d want, I=E2=80=99m happy to send a patch.=
</p>
<p dir=3D"ltr">Thanks,<br>
Saleh</p></div><br><div class=3D"gmail_quote gmail_quote_container"><div di=
r=3D"ltr" class=3D"gmail_attr">On Wed, Oct 28, 2026 at 12:51=E2=80=AFAM Sal=
eh Mammadof &lt;<a href=3D"mailto:salehmammadof@gmail.com">salehmammadof@gm=
ail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-lef=
t:1ex"><div dir=3D"ltr">Thanks Jan, makes sense. I&#39;ll wait to hear what=
 the btrfs folks think the expected behavior should be.</div><br><div class=
=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Oct 26, 2026=
 at 5:34=E2=80=AFPM Jan Kara &lt;<a href=3D"mailto:jack@suse.cz" target=3D"=
_blank">jack@suse.cz</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">Hi!<br>
<br>
On Sun 25-10-26 02:27:13, Saleh Mammadof wrote:<br>
&gt; Been going through mm/filemap.c lately and something caught my eye in<=
br>
&gt; filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or<br=
>
&gt; the wbc variant) and then invalidate_inode_pages2_range(), but doesn&#=
39;t<br>
&gt; seem to check either return value directly - just falls through to<br>
&gt; filemap_check_errors() at the end.<br>
&gt; <br>
&gt; The thing is, invalidate_inode_pages2_range() can return -EBUSY if a<b=
r>
&gt; folio won&#39;t evict (release_folio failing, launder_folio erroring o=
ut,<br>
&gt; folio going dirty again mid-invalidation, etc), and filemap_check_erro=
rs()<br>
&gt; only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...<=
br>
&gt; disappears?<br>
<br>
Yes. Whether it matters or not depends on the caller I guess so you should<=
br>
discuss with the users of filemap_invalidate_inode() what they&#39;d like t=
he<br>
function to do. Adding btrfs people into the loop.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Honza<br>
<br>
&gt; If I&#39;m reading this right it could matter for callers that actuall=
y<br>
&gt; branch on the return value - btrfs reflink bails out on a negative<br>
&gt; return when clearing the destination cache, cifs sets<br>
&gt; CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If they=
<br>
&gt; get back 0 when a folio was actually left behind, they&#39;d think the=
<br>
&gt; invalidation fully succeeded.<br>
&gt; <br>
&gt; Could be I&#39;m missing some other path that catches this, genuinely =
not<br>
&gt; sure. Haven&#39;t tried to reproduce it, just going off reading the co=
de.<br>
&gt; Let me know if I&#39;m off base here.<br>
&gt; <br>
&gt; Saleh<br>
-- <br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.com" target=3D"_blank">jack@suse.c=
om</a>&gt;<br>
SUSE Labs, CR<br>
</blockquote></div>
</blockquote></div>

--0000000000006f93f1065ed8a03c--

