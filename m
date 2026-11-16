Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6C7606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lzIDDbwi
Received: by kanga.kvack.org (Postfix)
	id 8E2CA6B00EF; Mon, 16 Nov 2026 01:27:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893C56B05B0; Mon, 16 Nov 2026 01:27:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7823A6B05B1; Mon, 16 Nov 2026 01:27:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A08F6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:27:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCE30808E0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:26:59 +0000 (UTC)
X-FDA: 85439999358.21.BDEA644
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6013180002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:26:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lzIDDbwi;
	spf=pass (imf06.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794810418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wd/v+54C2+9hZ5vK2vynCTpvfy6lXgdEPXyeyseozC8=;
	b=7DjPs0YR3RQRe0PKhxZe+rkHR8HFk6jjrfiHxW1RKQDf6kwkAKI9O0LiXIBtVjUvg6cAgT
	oQqeELIdS+6gPZRjvLkQMNVEFpq+we8diP97KXl4tsvKjqct5eFEGcs9sfhp91tWtm5TOs
	v+9u6P6wwDVco5szxehmTIxYsZOtwl8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794810418;
	b=44fxJ9x1y8YPR3s7lGpkKsxbShSX7kcHSwMPreQUGjrRa3BTOnHr7pLhunZwUQ4XQaZwrN
	sN617eArLeqmw7gDsDjo5gBKguvfSbUwpJNHyvUCaoGOaM/jwqkovni42T5iPKyjBQINPL
	GBeJehQ2p3jfdf8uvn0zhhSGwNW/NpA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lzIDDbwi;
	spf=pass (imf06.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so1228292a12.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:26:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794810416; cv=none;
        d=google.com; s=arc-20260327;
        b=R6Nq/V8xAVQlfQJGqWaKvaWuV+1jjI5veZAUPBdJELcMuaEdnFvKOb1VMNqmrbPOee
         BP4ytvKjipAHlWK/06vqj2EuPqxecDmJICvKSMCoVObqv89vrkkZlY7mu/6tH0MrgEGD
         T4b3IF5Oo5hyFTpOwn7LpmKsQIRlA3MIauaFjttiVpzbhO1zVP6GY+DxbDaD1uLU2aD5
         Sv+JQBqCTMpul7WuvnQWF85JfymqWel/JpoWfSFQQrNhrB89kG53/3IUpZTIdsZ8wmjY
         Ms1CymgMBz6xT1wakiXjjxCYQio0K4X46dWPXa9uCBaQIRWi4xwcku9xY080hpYl7QHF
         c7tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wd/v+54C2+9hZ5vK2vynCTpvfy6lXgdEPXyeyseozC8=;
        fh=Fq7YNmThzBGZ/g6wseyG8UOQLF6ULblF5KWuc9jMrdw=;
        b=CmSUo6pqo7Cdwp3j1fmEl+PhQrtBnIBoYcV3ODMk2bJT4Oa/jGX4TM15dpCsuvlzzn
         6hGzv+t/gff1xQ4PzNRx8sWHo2NjtTAQ4sRjLn4E8btVRbSprlH7rrQH6XrYqQzSkRol
         e9u39avrtWP1YnemETLuYvL7oAacOhbrfsxZaQsj+ZQI5GshzqndD3IX94clfl3gp/AT
         C1dvg3cCavfznPKcUOKo47VymnG9M95dXPDEvM/FPjjrXG8OnWLxF559ddtqO5r3lfMB
         jALc1Sx9Tgb+uGsRY9p/vmVM5aGJ7sM3kZ/5cQd2rWeo6dci9ONzMnW0AzllS8UyKAEM
         F2AQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794810416; x=1795415216; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wd/v+54C2+9hZ5vK2vynCTpvfy6lXgdEPXyeyseozC8=;
        b=lzIDDbwiFiqrJbLBgb4Eor7HymCzVfQOw/Z8GQ+71Ud+rpCeB1KCPz5/TZ1SHyWLgK
         CqCGqDe4pIo0BKxZWTwzKkZRtZVbx9UuFKNSDophw0pPcNLg7WW4SoKiiTm0rJ003N3K
         llguZCDXgIHlo+2hLK3V7aOChk+CPtxSrMicSxa9zQeSljMgUUlASyuCnd6ux8mTqoHw
         XS6lyXbcpTbf+dC4/2DhBxCg+/Uv0Wv/PniB9RFoxkv5qU5TS9wosh2RJPyQATF8DVCJ
         o18tO6uU3WkXeWm7InYfI9Ib6zNs5LI2VrhIkjaIt9oIvSSJ1bqcF4E+KiYmxaK6L1nO
         L4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794810416; x=1795415216;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wd/v+54C2+9hZ5vK2vynCTpvfy6lXgdEPXyeyseozC8=;
        b=1Rn7fqtKlbdSLrCQ0w3BchmXErtFxjXbGA4RD+8XkCH4n0K2I9FbaJWq4roU5mOL05
         6VzfAIoRxKFs0iAAeESvyYBhSeUX7f3ynHbM75+uEFxQsELUg9CnkJ/YBa0wZBfnT5AR
         j+vxMQZY7pRRQnjK4l3iKeAPy55fMrEcGnEw+MYlWoLV6MhK1wfkEAYIMUogMUsI1kb2
         fMCEHHRi8oQfEV+LT1ANBBJOQ0GlMfaGrcy7Rk8kGaFa5iq1LVk3i25eeIdZiF9lRcB3
         DHJJhTRH3G0FR1D39pIYNtCFKtu7q71fVEY5l6NBZBeeAD4Nz4QAsGGanpNMsN4rPlrO
         qUzg==
X-Forwarded-Encrypted: i=1; AL+hErExbOdko9M29nctwPVFXr8fCtlThZhytwO/4oT51EGP87SWwS9u0WGlmnE8hv1poA/kEKRP1qzbww==@kvack.org
X-Gm-Message-State: APuU4Z9bqzuM2D64ilPHADyzc2qFjWo/+NATdWdQ20alzjaPCV+iaM6f
	COqDShdhh4Ddn/zv5hV4rul0rHTu3G1AFwwlZIcem7oqwsiV2sepHqK/eW525Y8wT8EKYO++8au
	rw9NNOQvBolCI2Wtw/ZUzSFmdNjNnnDs=
X-Gm-Gg: AZFdTZfEPJstgCJK6VKYXajtzm9820g4c8dBIPMzqais7g/rhoN5QVXqmMwJzHh2F2t
	nIVGaubchwtQ7eKQiL3vugq57kbDB1gopDUqrf8SJ3bfdWikOVx3lgy3/dx0UB4uOBFIK3pAaqr
	yo6XTTNM8HmEl86CBUhwyVNDJw25hRaEL6dWv3kqbmCr5RhxmHuc/FpEKp2XZRziyl+VZOVf3QE
	5whu/zmDrVJb9fp+4BOGuuXO6SuEy3fzpcEGFGMCVST/eJuaJKgE+WDHML7/a1DCHb0p0QUTrQ8
	sh2f8lhk9+RoBvkLJ0aI8bEuuQwUnBYFU65RZYZZPzqGYdjfXWRPm9prnSRPbcM/nuPOCevhHy8
	p1g3Wb1HBmdEZGIdYjGWBIa6S9yvOcILgT7IClwiLQhcw45B6/c8p5Tyg78DZNbyi/Q==
X-Received: by 2002:a17:903:1844:b0:2ed:3c25:782 with SMTP id
 d9443c01a7336-2ee0da7f5a1mr90997955ad.24.1794810416253; Sun, 15 Nov 2026
 22:26:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112140101.647-1-adrianhuang0701@gmail.com>
 <20261112183727.68afda9533aff699eea12cdd@linux-foundation.org>
 <CAJuCfpEqQQb1_UkWH50tgbdVz9KZ2anfCGWsvvoYFsnC_KHcjg@mail.gmail.com> <CAJuCfpH57DNEb5ckB_c4QTWiiHVGSHNhB=S6HFdjvJ6GgGNSnw@mail.gmail.com>
In-Reply-To: <CAJuCfpH57DNEb5ckB_c4QTWiiHVGSHNhB=S6HFdjvJ6GgGNSnw@mail.gmail.com>
From: Huang Adrian <adrianhuang0701@gmail.com>
Date: Mon, 16 Nov 2026 14:26:44 +0800
X-Gm-Features: AclHuK9IzBryxrXRbSIYeEf8bDFSSEJ-fF65yis3zCtQgIP3kFYe9Y881Oj97MU
Message-ID: <CAHKZfL3UxswfJgK+2rHj8Y-Lckbg1Kt+oVK4iyr0pkPWRmW6mQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable 1/1] fs/proc/task_mmu: advance seq_file
 position on interrupted VMA lookup
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ahuang12@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1ikb7zdebnaqqxej9645nz3kuytg8s5f
X-Rspamd-Queue-Id: D6013180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794810417-786210
X-HE-Meta: U2FsdGVkX1/n7ogRkupxMdYLs8BWvpjWOjWGNrKiAutV6HujIUXdy9z9+pIU+kNWESRL3xaWHaO0nMOjUPj1DKMQ3+C6BZ3kwkzEj0PBUieEtKzZJ5l9pGYZWgWdiqJdfkbfvWfNM1i4Wn+OFOVNFv3kZO5j/+oArsoEXQL3KEg0Si0AWkFdYW7TLQKoeqECzoY5zySPGDARPtYF8b2Xvxx4YQtTB9LWHsdR8EWrUeoj0/Di7SCKeWms58fXlu7zBumvFJdd0SWPzxXsqIkhjfk+IvlTbWJfKyAzg/UBjj8QqkorFfqHwnuhSCa9RenH3Fvkqcf69fijlDpOb4dfBdpi/kAngIwbKW+Af8VToALGCTENl27videH6Z0Lu3HKU4dztppozMzHTgQ50XFvYuziR9/BJfiKRCkZN48Xp7jKVyYPMdgMsw1/9zY9wa7H3pt81xxq2GjU4aG4kw6kz0ia6dWtEy7kYWTjeBzV67S+UQtR3maWtYt3Lm/CKGsMPbv+L/UQxiHSYJ3AiK/zHu9boGoVCVX6W+c+l4O1xBAmDO6MYz8ZYnGaejE+BDkCY/mt1igjJUAXOKbnVIg7Xjul+syQRfjzPYLWANZ4KnQKNh/5zIRstT3IEZzFJlYA61OsSaFyuJ6IkbLFqXKeSS/sPJggKo2eGp9AJV3JcmPvPySIpRrMZDj6eXKUCNkg4vdO2wFxBmQ47puLlC8mn+8QhsfSf2pSyRvJgGS7KiMjFT4aHDN+ycP1763dRg5ntqBv1ZjMBEd5NPXZFbt3riQtiakGV8XQqkMv2WV6FIEVejq8YHcM8p8YFWGbHpX/CNmqQAUqLGZPcTyLYbHSAq0GyejAYRpm+KEwLW+vC2CH3UMz3vtjEMlfJZcMCrD19mTqRuP42TuA/NpVaJc31uS0jbGNX1O1dwb9HYUArOaVWCRb1Esy0f8qLoX7pXFEXbmg2IzoLlK224UIVSA
 AXWspQjr
 OkqvFE1Zmf5IJzPB8T5iBvwb5crLAzWICItdCuEqb5mNr/sdEolumsPE1ywxbpfE9kCA5yE/31inRaffsCBKPuD18tQOTmmVWd13jEnMBs9U34FDKoscNdJT0lEQvSrIy1s+jfR4Z6doVgxYPufJ9SYqh5inoxcGrJ8q7REUjsSFvbtGuqYknyFmpNI8qMsmB8qXimInR+hfR6T+Pzr4xwxxjVsuGvaE8U6M2EY9gYSUQyDA+yXzDxYMSmlFTJYjLY+0oLAxusyQFMkivqIHfuyjLghhO+Gvef4WNSWYUR0o/xmCrX96Ogovpd99Z70s6KYdiIogt+eGOhYYoAQWk3aLd0tIx6paghinwicjkt+/looYFJgIWyq1c7rHRi3ojTTQrCz68bJLYCuLi/Ty9I9tWtALcMKVylqMdLGUtY8fxafF9+gidrp5GpjBFH3C4VScqAGvTFSulM5e9ewfSMsA9Rk+GcA5JPOej+VrdapWJas8EZyFX4Qy+PHtDbmMIka5l05IAL8Jy8/F9z4eCM41jGRy72WbJZkPKC2JsT0TrRzf1G9pfPZDb4ba4/Bd/wLYqKiAgnVBw7BiBbXfGPd8YZQRun6Mu0N8hi8tZewSRpdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew and Suren,

On Fri, Nov 13, 2026 at 11:17=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Thu, Nov 12, 2026 at 7:13=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Thu, Nov 12, 2026 at 6:37=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > >
> > > On Thu, 12 Nov 2026 22:01:01 +0800 "Adrian Huang (Lenovo)" <adrianhua=
ng0701@gmail.com> wrote:
> > >
> > > > Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> > > > per-vma lock") introduced the possibility of returning -EINTR
> > > > from proc_get_vma() when the VMA lookup is interrupted.
> > >
> > > OK, but what's causing the interruption?
> > >
> > > > When this happens in m_next(), proc_get_vma() returns an error
> > > > pointer without updating the position index. Consequently,
> > > > seq_read_iter() reports:
> > > >
> > > >   seq_file: buggy .next function m_next did not update position ind=
ex
> > > >
> > > > The above buggy message is reproduced by the following command:
> > > >
> > > >   # stress-ng --vma 0 -t 60
> > >
> > > afaict "stress-ng -t" can send SIGALRM, but mmap_read_lock_killable()
> > > only responds to fatal signals.
> > >
> > > So please clarify: exactly what is causing this to happen?
> >
> > Also I don't think stress-ng --vma 0 -t 60 command reads maps, smaps
> > or smaps_rollup files by itself but I might be mistaken. It would be
> > nice to get more details on how this gets reproduced.
>
> Just after sending this I found
> https://github.com/ColinIanKing/stress-ng/blob/master/stress-vma.c#L536,
> so I stand corrected. Still, it would be nice to know how exactly this
> issue is reproduced.

The --vma stressor performs the following jobs:
  * It creates a thread that repeatedly reads /proc/self/maps while other
    threads modify the process's VMAs[1][2].
  * It sends SIGKILL (fatal signal) to its own threads approximately
    every 10 seconds[3]. This happens independently of the 60-second
    timeout for the command 'stress-ng --vma 0 -t 60'.

As a result, down_read_killable() in Linux kernel returns -EINTR.

This finding is based on code inspection and analysis. To validate the
behavior, I collected ftrace logs and added debug patches to trace the
relevant task PID/TID information. The full explanation is fairly
detailed, so I have not included it here, but I can provide it if
there's interest.

[1] https://github.com/ColinIanKing/stress-ng/blob/master/stress-vma.c#L748
[2] https://github.com/ColinIanKing/stress-ng/blob/master/stress-vma.c#L658
[3] https://github.com/ColinIanKing/stress-ng/blob/master/stress-vma.c#L768

-- Adrian

