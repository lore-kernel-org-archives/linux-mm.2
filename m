Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A79F606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t9ydqsxk
Received: by kanga.kvack.org (Postfix)
	id 844086B05B0; Tue, 17 Nov 2026 06:52:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CB06B05B2; Tue, 17 Nov 2026 06:52:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732A36B05B3; Tue, 17 Nov 2026 06:52:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 525BC6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:52:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5E5C1403B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:52:25 +0000 (UTC)
X-FDA: 85444448250.25.BBC3BFA
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id D92BA40003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:52:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=t9ydqsxk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794916344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r/m1mAfbKgiD7yOB9oy7sj80T9BKokzsNI3WwDEi/8=;
	b=3TXSWnDMjURHEyqY64jRh4UHaepEqVaCv9AK+em4ktd1C/GPiX1j8YpVkpnhhZSuXi92Z5
	jvS2IWdOFNxpelUs62YyxfPVhhDBc+WqgDSrP7O19qnF0JgruCSbNb48Pdsjtn0hGFpfpJ
	qwYQB/F23OM+KRSezl4YD9wlgeT0tnQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=t9ydqsxk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794916344;
	b=FCmgJMCWDgReXdwUXmTC8QaD/N0dg2242BYKewPSvgRlk2XfViEuhcee5FNycdxD4Keym/
	LBP5uKb/6SJ9zXJIdSbmAcn1dLGjtw4UyuZe9mNMe7iDxo3yes5BRXCAb3gVuDMvBJYlVy
	/8hIii4WojtCpF05Fvz0uC/iWEUZdmI=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ed08b07213so21401955ad.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:52:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794916342; cv=none;
        d=google.com; s=arc-20260327;
        b=jfusJY4PRmOZc0ZKBbNPowy0q4XEemWkA31h6Wk39CCuxLDBLk7smxssl6/bPOVvSR
         ztnpau1oLI7pS0eBp1KmP3ZFHR+tu4bEOrb3ttBRjMok8Efhiwaoeye8GLcn/d5epW6m
         Sf5g95exmQveD8EDctCaxXd/TxTjixom4WaFrkhzDD0FgSW7j2Q0cIVuTTaj9NU7lEhY
         gpDG4cgsHX+6hoaD/d393kP5ezYxeWGaRsuw8PRlRbkJj1IgLenNhMP94fNczRZxm3io
         60eEH899WMXG2mTOI8a864iBeWQyVJg+aoc3Hy00VuPo5kHvY4gEEqD+VVO8F0ER+NYd
         mt+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0r/m1mAfbKgiD7yOB9oy7sj80T9BKokzsNI3WwDEi/8=;
        fh=NhMdZbw2QbLArc48PrnpRN5D/Y+p7C6QU+eEdFlkaaI=;
        b=f6HEP4o9u/qZcQCQ2yec//JAWCVOh9+QtUP2z0Qgfao5y0RJulX+i1o3mDghZjVPgc
         YAneG9/mhwRpeRMIAwXXU+pjCIv5s0dFHbsYS5D8Baud+LNcGxIDkDYaB5s1cNd6dYUN
         rrICnoh4peZ7lFQcMIaR2Uh8DD3EIzv6rD3jEJ/IdS6NScDyvNY6e86IO1XTxN23vmeP
         CVkn+jN4MKkUOkSpEf2Bf6GNoPhqWtybPrtuCp1mpS/aON599vP2/wig7O6jBcKqqbeK
         moIEO+GmD+f/TqD4650b/k3j5q1tgFu4DtuWTWQh6iNN9tBpfok4t1tm8PolXAw9l10Q
         0Oew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794916342; x=1795521142; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0r/m1mAfbKgiD7yOB9oy7sj80T9BKokzsNI3WwDEi/8=;
        b=t9ydqsxkSupBc7BJ/vxhY7Huh+10mOPFZc+4iTneF2wwFM3IQ6acuBuat1BFp/pMOs
         uz0M+MnhV9Rp7i01cVi9k8LWGc/zTuBf0cncHJibPSTtaMAUApfXDl2RMCEuE1+I/KJZ
         xK/X/WIoYMcYrqup330RaVwWdhvC3YfJmhu/LGuMjNjfzBmqPHlaz7mnke6wlhwzaZPo
         ZnzxDe54Fk4QbAXWAZrod6bEQTEZMRqktSCE6r4V8t9N5kbiKc0XWMcMv7GDnI6Kz5Zp
         SuuqpGlDME0xQtuwlGciaFTsUl1tBf7OxZR5tChoPD3yOzxpKK+MI++Q9XsuvbzxnGNu
         IIvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794916342; x=1795521142;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0r/m1mAfbKgiD7yOB9oy7sj80T9BKokzsNI3WwDEi/8=;
        b=zx4UzTod9zvoIKzTjF1HiHVre8R6xxFlye3U0xxcd3yU6d60v8YzCfh56QZNanr3dX
         kgWEPfx5o+1p3XoAS5588dcc4xBkxapQNDj8luT+BUvO338eXNdIS+V5fv42IYyRtjPi
         TL5pLQBHP5DfoJBL56O1gZsXTGddoSlAlyF8fyJW0qmMKJvTFRvJEAcMwekKBkdcjyrR
         Oe+4DdvPAUc4scAtzeFRMLGDrQOYvKM8Qa6Wvw/NXOlY/OCK34V67uk/+s7ru7qfXiau
         qZ+ywHaowUXHqySV4+zEEqysFvUIFwj0BCLyxDaFofM0mJdkIdu18F24qtAXuE0U98tx
         91jw==
X-Forwarded-Encrypted: i=1; AL+hErF31aNkYEUTN4cDYcwnG0L2DAgiEtqHU8Z53SF2wOm1DPRqoJg87z5JxmlqTlwz8t/Spz9FAPq4ZA==@kvack.org
X-Gm-Message-State: APuU4Z+rcvvJcIbuDbtabhk2t9ULu7xEs+VcbFKmnqrNVYqFlmivkSjo
	oqnQ3oeOO4GpDuEwKwm6k8z7QxmktYumeu28ID1fMHhfz7aZrSEKdNs8iJk8ibalzinJaAEtkjV
	4ReUw8VDHAkV88km/edXbOUD//7J4fHHaWUqu
X-Gm-Gg: AZFdTZeRPOsupe4KdVX23NgL2gSFPkN+jUwhIdO6Kvmzy3zkM3E8XLvFqXFiadR8yNO
	kcVj/RLg9AUXKork2m2s7tuLHBGncwVlYwYoxFR1iL9goy7VUnHVJC5oZYgKB405/AWY4VHn7wh
	rBSYolmIxsfkLYlabdKaFqQgnHDsacuzcxKnzLlNPFbdJKjEBthrhF0J2R3mbz43ZEfPi83mMAg
	W20IjK5CuLaQGchK/Z90+yTu7fzNPWuf8/kD2cH/A2okTYNEDXseV1rgdqynXiRBsUhY1PXj4Uh
	J9ZvUUyXUfBhxefk0JBuDmuXGMO3bIe31zFHvyB3PxI/jk11j+3/TPjvQOE0lyIWrXclQn7orD4
	HNOHIIQPNttpuE/+yoKDt1M9hnFW/rkaYMLCihkWEt2T+oG7CDWnpBaPVueWt/pPvDA==
X-Received: by 2002:a17:903:4b28:b0:2ef:da34:7575 with SMTP id
 d9443c01a7336-2efda3478f8mr25625925ad.69.1794916342499; Tue, 17 Nov 2026
 03:52:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112140101.647-1-adrianhuang0701@gmail.com> <avsQKLgi9bqD51W8@gremlin>
In-Reply-To: <avsQKLgi9bqD51W8@gremlin>
From: Huang Adrian <adrianhuang0701@gmail.com>
Date: Tue, 17 Nov 2026 19:52:11 +0800
X-Gm-Features: AclHuK_YP7jGU0mfHFtcV45lYkePktMNfOxs8gWCYOKlclcpX8iMtc-uS_KjPxk
Message-ID: <CAHKZfL2UmshKugf9uPBHK2xZnNNifRfXdT686-cj3SvN0PzkTg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable 1/1] fs/proc/task_mmu: advance seq_file
 position on interrupted VMA lookup
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ahuang12@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D92BA40003
X-Stat-Signature: 9txqyfjhauc4u9p34846sitgsw3ddztb
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794916343-187803
X-HE-Meta: U2FsdGVkX19w40uN68Rqb/m9ZRbKr30itugctpO2JyyjI0dZnHtfgjDDEss8p7sVpN+nC5lk2IziqKDm8/zgkBd0VbJ4k5TSsx/EmFDinUQXXjqSOmVmX6Yrpx7b4iuR+Jga3eUBGXbrlH9Ya2wbFmiW1xkF/6up9jC9tj7rK4rpLG9kQfHIpuKrW62xySTI8of0c2S6WC7WGGEP6lPNclY4UfnEY6iVdy9d6vyPI5ePnEh7QDiVT0WurUWrDpP9uOVAgNmFBaenBTzzxxzPznEfvMWUDZXRoA7TRZgYxUHYYHJXDhfnGguGi7q9q3SeZO9p2Zf2xDvUFzNaEAAjq9Jow+tI32Kvzx/tU0ZGit33DooIWuhZ2RKu+CXCL5lu8q9fqgaYN3PFk5Qjft97vItovJKlGpN+ipEBmHxZ/DVuy9KSxbst/6F370qgynPBAAVeJQlKQZMg+Myr9GDGqNuZvAZ7AyEdiyXayGlaykhNYHRU+bBRwkTYZNZmygqNJdB7K6OZNSHE9hEvNCB6KsiJ50a+Vd1S3Gg4uic3Q0zkJvBZOPqybumSAgAQwFbFpbdO8zD2Z8SSksAOUmDkYKuKzPRCmc6sCHQbxNrNNd0MfS2qSNK0uYsL3bUktFTQVHLAh9lLmZwJutVDggXtWtT2tWeFmoKo53+b9EEcWWrok2zVmzeFuWXW55Vel/WhdpJ9Zb4CMzIihSsZwK+/R7EUB4V9K0XdmMbgaVVsGbZaawFEcpsjia5XBK8ebzUxaAVtNunuMDNxgI4lRcIW8aa/tPZsCUuJlbYXT4NpUQmzJW5jkDdijzqQu4db6Bj8NBTE4XyEejngETa8X8Q/HHRAIbzF31lYZpqN3IYNdKdeFnGhfah1WgiGL6lXs37d3ZYzik4wZRQjTWB4Zs4WvB8HYI6VB4WbDnGFMTP7tcoDeOLoqGATCxnxLuqaQ/dj6PQ1a2/wVAK/byN7oVx
 lcdT3HKw
 RXRtKmaRTj7xnPKR0QGu/3JvGi8UdlBiRrigVCrgRiaqDgnMtugQv2v99cPpAI/LQFQNFPORhE9pMRY/fOM2Xp2FHUyyJ0PO/Z6aHje5dgt60Qe2DBmCcT/ZXLDaLHiZLnhzbnmryHE+rWMwvGbMUi31ib/D5ezBycx9O8M2ZlJK+Nfw6+Omw6bhThGonLb0uYWqTcMcecjyTpka6GJSVOcl43LMT7Zs0q+oofShi+8/xpHKH0B0PgZz/Dq5xknhRiu/HrnlMYnOJRNAfpXmEcmIdpkydxzVXBXt/3a1s8sJv1vTy9Q58TrsFa9449Cz5Y8ztVRNY9K4TR9H2M83Mgp9d2BDhw6GAFrlJxjdvFsNXk+Tq2aYsTO53MEbBDwR7KDp08Kf+RSHm3YJkpGh4YNatzCTvzbQJjintn15Dh87U0sk/9d/jDSVOKBuEjx6sznwHXwSW/hp+XgvdRe/uYMHI5lV28lQBTtKksD0WYlVuGCRDIinUUYmc0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 10:37=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Thu, Nov 12, 2026 at 10:01:01PM +0800, Adrian Huang (Lenovo) wrote:
> > Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> > per-vma lock") introduced the possibility of returning -EINTR
> > from proc_get_vma() when the VMA lookup is interrupted.
> >
> > When this happens in m_next(), proc_get_vma() returns an error
> > pointer without updating the position index. Consequently,
> > seq_read_iter() reports:
> >
> >   seq_file: buggy .next function m_next did not update position index
>
> What does seq_read_iter() 'reporting' something mean? It feels like you'r=
e
> trying to make this into something bigger than it is.
>
> What you mean to say is a rate-limited pr_info() output occurs, and when =
a
> process that _has received a fatal signal_ (!!) somehow continues long
> enough to try to output more data, you get an pr_info().
>
> The relevant code from seq_read_iter():
>
>                 if (pos =3D=3D m->index) {
>                         pr_info_ratelimited("buggy .next function %ps did=
 not update position index\n",
>                                             m->op->next);
>                         m->index++;
>                 }
>
> Anyway you should mention the fatal signal requirement clearly.
>
> >
> > The above buggy message is reproduced by the following command:
> >
> >   # stress-ng --vma 0 -t 60
>
> OK I could reproduce the output locally. It seems that this run results i=
n
> fatal signals being sent to the processes triggering this output.
>
> > Update the position index when VMA lookup fails, as required by
> > the seq_file interface. Also save the original position in
> > priv->last_pos so that subsequent iteration can restart from
> > the correct address without skipping or repeating a VMA.
>
> We don't really care about skipping or repeating a VMA for a process that=
's
> about to die :)
>
> We may as well do this but better to just hoist that to share code.
>
> >
> > Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vm=
a lock")
>
> This isn't really a bug, it's really cosmetic to be honest. So not sure i=
f
> we need a cc: stable hmm.
>
> > Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
>
> See attached suggested patch that makes the comment sane + hoists the sha=
red
> bit (dropping a silly existing comment).

Your suggested patch is better. I verified it on my side and it works
as expected. Thanks.

-- Adrian

