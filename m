Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A62D6CFA6
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 21:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA9D6B0363; Thu, 22 Jan 2026 16:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81F56B0364; Thu, 22 Jan 2026 16:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84916B0365; Thu, 22 Jan 2026 16:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94EA56B0363
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:55:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3769E1B3649
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:55:33 +0000 (UTC)
X-FDA: 84360956946.02.278CB8B
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 41DF2A000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:55:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jT8KiWHq;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769118931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d073vIjiyMQqqIhnhMU9GQH3rRYcsGAX3Wwsgfbic2g=;
	b=aB9NBajo9LWxWiR3ORnPp9p4VGIWck6Gr8JS39zrJfTN/rSDTyYT8AUTjYDQilo0xdUR7m
	m1u4f2+kd4gC+5NQ6EfQeS2lRFVjvqntDe74psHSWPhsxuXxJ/MwKEZDnOSo1EigOWv4pv
	/oj9BosKg6xjBR/niTgBMNOEP05LkmY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jT8KiWHq;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769118931; a=rsa-sha256;
	cv=pass;
	b=2JiUZGEwhmzt+dmNIcC/JWhHjLyVnab78ag65RytnYqagL8UHuL/r2d5903JCnnfXklcH4
	XaB1I2kFFQx1JnTEb5/0c7wBbiDC7EjqisBfBFYobDO/bBg5S1kxZgC9p4oyo/PqKkT70b
	UCaS8VPwpZVfSuhKrq8+apJKla/LjQA=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50299648ae9so63331cf.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:55:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769118930; cv=none;
        d=google.com; s=arc-20240605;
        b=Q+7caPJE6NpS8aoQPIXBuKEXxbQ2QnyN3AkMJQUukWBsl+oE6mrfnf6ZkFLP9/zoG0
         vDaZKW6nQOnwM1wBw9FJOj4M81o2eIJRwe0thP0Fyjloa9/ZNMlfLE2zz4Co122SMxKf
         knkKczrOZ3kxFwNBXnBknW7iWnzuVY8L1SUGESLQI1psCuc7CRBNqce5BphZzk2srnXe
         ApV2MWoVP41DF3hF+dtGFUoK9+fRGfHV1P7nuDaBd/eTToRwXKhtpozIMLUxxKXl8b/z
         0m46X3+rbAemG9HiBVlEQIWSWYO9kN/ga7siUhzWiyRF5jvTpcZ7w1o+iCiKR5NhWWXB
         UerA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d073vIjiyMQqqIhnhMU9GQH3rRYcsGAX3Wwsgfbic2g=;
        fh=v9eNwmhDt8gPz/QHPPZrySBJcSXZ1R1Wbg6XwC7iQuI=;
        b=A8mS6u28VHqMapfRFs/hP234r60yp1C4jT3vJzG0LzQFDWKKY7GU0LqpDjWNtp8fs6
         j3dx9xA94q41aEhP3nBhTSI6OOzk6FBMMjnpwPfJpikJ4NNJ3yhTiM6HH6hAQ0K11VGj
         tEU8pg03OaKtWJq5nyLzLTwFuptffcwPqrc39bJFukvYZJXYcmirDsiXASvAitHbz0UU
         vFwQ721BW9bKKnYbz7Z2VFMhxRBedzdGdDROrtMUxoMLCYEoD/P9fa7/cY7R5oRR/HrU
         5lhV4FrnrNpPtvuy15aOKeTLHOvPa4NsfASRXGAB4bpoPIjT6e9AZGXqFET2kZmDeTff
         yK9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769118930; x=1769723730; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d073vIjiyMQqqIhnhMU9GQH3rRYcsGAX3Wwsgfbic2g=;
        b=jT8KiWHqleQWdQ3tzvxkhke2rjkvXLmlsY/Re8lqKbfmuRAJH77Ij9lfw11v86NvEZ
         1Czl8Pm8hz2mzUxS/yZc0zViJ1o0aioq4V70gYgystZVf13WwOuieK52AcieCI/vOd7C
         TG7FXH/zNvziPb06NhbrpRlFZmEQphtcCPMw9EXMPI5dTNia/scV2lllqC8uti2OxCk2
         6u9UNnWbsLh6Nq2xFRCeuFmxgFibMlZ3H3Jz8CVIdH8LvmtK2TRxC9a5gOl+U3kaDgEb
         06sip/aF9tDvi7iYDAMxuVRAvr+w/YQLNKoN9EwkAH9IofSgQZvaxs3K9JtPSSVVtXz9
         3VYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769118930; x=1769723730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d073vIjiyMQqqIhnhMU9GQH3rRYcsGAX3Wwsgfbic2g=;
        b=QaHVuXLJX1r7kirWvpj4HnXlTSNIcFNXZ1dS2Mq/Ap0MoJwswIPPX30ytTYL4Pmoxc
         AwTii/aCbwBxAOP67HXUb1L0Y7p+aKM7UFuTjdsEk4FMvJFeIyK+MjDqlDazAMMLoWL0
         u5GaNhysJbohofCqcMAJQ1C8IBVfOzdA2H3QnXokZSjjrB9d28WKki9AEhV90RChNTJt
         3uHRXd1fQQ1PvbWdXxoNJTg78f8eYnSkok0RqVbSD+eNGFCBFjpe9szjCgPu+afz86MS
         rmqFPNB5IYoO9wl9BwDFt53Zf7l0XIf+/i0zSydywudJa2kX3CKLbQHQdEtFd7GQK84W
         J+Sg==
X-Forwarded-Encrypted: i=1; AJvYcCVy2gZuD3XL0mY+SfYoz9QoCD3rNAvkx6Zvwsn++cLFerSnvtW5jVt0LVMahF35bP/MltAYHBfeiA==@kvack.org
X-Gm-Message-State: AOJu0YwdJIlDXg8KtO3wm0Z8z0ZEMR+gQVrvTkMgA5lqNX2CjaBSEIDj
	I0BxRNVOjwjOh9p69DDkwziAWwwkpVUcjvUkYYTdmgfRbo8QyO3npQKCL1ubH1YGgZb8kv690d5
	0YDhHvvpzMftFUw1223hv8zTDGbhIFLZGj5bfsCRa
X-Gm-Gg: AZuq6aJglxVWe8VbbNuTra2R1Y2waSY+YzZJmRIBIdpKOStqUAzIZlPmAjKnj2WZLV0
	QVo3paM/saRqV0hPjHAI8fP3KbaUYQc+iODeTHfaNoJpxZdHHompEMJBGQxWfY46xyrTUonWvX1
	Z8fSsMsJLyi7JddCcboTpjsZzR5N0Q09VT2HXtokwKAXCJNebmZxZsqi1CYEv8YQRAdqdWNnzsu
	t+EoM0HgXC5JgwOOnWWpDp5gdoq8LUnnF8dNxXcnUTgnw/lSGgnbbOZed5BKTsbWrbVjSuQSDUJ
	SszRwSG27kmtsOvWeqAkYiLOhpGzSjtT9mY=
X-Received: by 2002:a05:622a:94:b0:4ff:bffa:d9e4 with SMTP id
 d75a77b69052e-502f8df02b7mr835541cf.13.1769118929938; Thu, 22 Jan 2026
 13:55:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com> <70dcf80f79ecd00a750ea17101061b0949119429.1769086312.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <70dcf80f79ecd00a750ea17101061b0949119429.1769086312.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 13:55:19 -0800
X-Gm-Features: AZwV_QinqaDgDNGKTqn3OPsVIG7-oCO5uUdRG2R6faYgmu8hZbcVs5vP3ybOn7I
Message-ID: <CAJuCfpF1LthyP2FR4T8iDd+zOi1WAjqma2KBkHcCJsOjm+s32A@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 08/10] mm/vma: improve and document __is_vma_write_locked()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4m5mi47xw9sy95ykcm5wsfr61s7gg59i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41DF2A000A
X-HE-Tag: 1769118931-320192
X-HE-Meta: U2FsdGVkX18ljySDTz052e4AMevTdzMHd/DCH29CLBaM5BYSluoVmit+yyoKbU7j9UMxbGmwJNxx7lYMRRJMpwa/iM/SvdIa9wmfe/Lv+iaBXaEgzfMxW0dYfdQU4abIrfBx/OyCPck4GkRTNsRHAP55ExadMb9Nbo7bkmQb4MyMeroZT5O/Hr5I1XoJ1RGWX7Hq+KNQ1f8ZgeF/Vg0O5rpohhO/28810QbI7/WU+1mWo8Bak2R+JJEW2kulgCZKd0Ftl1GWmMdm5th4vrKg2syqiNjJ44rGAb63yHml6xgq3/gmWryH7rtP7V0r45Nry14hPOF8kOxYUP2ELUH2F0ZTmapkgAoj+49LHEsDbj11ql+Rgjpan3iSgWXaey6giJ8I1FvvsLUCcGiY9tJvRcdCf4PuyJvtJb6LwScxQw05PlqpBR639Ftk+qywUkM24JUnYKTHyB7LDR4hIZ1v3YZWPH/9czGzTsgqcAXfAK35FSd7el7TjM9v8fYfcTFLmxkHAdC7xQxpciso6ovVxt3ZUzPbSbAdLMy6fs1TXEHpweYppYeN1+hRx4vfusEZNExL7VdSmacZZiPoZI90x+cRjUULksFEKgJTIRJ95sFLVJWVO0zWnnHpaoJgr1Gcf2OJsIS0n9TLbS3tOkgEg0qOJX9gh8Gzta98413FiPSQU+3j60n8hUY0iF696PSojD0m/e+0zqj2DQpFirawj5WP3qWl4R2UTEHAAiT6PrQVvauNydGIw/7IV22Ngv8/YHeFM0x7wZJ3OpHhh2x1cakOdJCD8MGHYxv4Wx7QZrMRjQK4+exJVAiDL820WF0qdMiCeKmvTyFceCoa7BehfjuwsDH/nMbKA58C1F6GEl3ZB+dshr9oLUOl+vMIU5PT4zAYipGvulH235mOzVLuvoXcEnDe3oQ3PkGT5824BZda7aPALiRs4sI9w62CupV56JOz499L9vmpuugUT3B
 2kh3P29h
 uXS7+gUTAtE6TBaLn+z3R3UA+b7d/sRXRgMb24tA4PuV/rLLlNugNhPqhhoEBFQDNwIBQsKmv9aCi+b45QIaRYz15pe3/irSUygNM0ijU/sj9bnBtL5auSqtLBJ5Q5+Dma4ANcs/IYr7/j6pj4iBxVRm60xIFjJ6GaEhB0skmDeFLwdBjGxHooRnPTKQPmVN1uZtO+CJ8wZvO+yY+ufkksQcspeQukghecPbLPVnyekc7y1TU6LOoIY1ljAGXoGIf6SKCqbztQYme0hi2CRvQWmMn53OssxeqC4He0WML/nL1vqPrIa1rOTUKmq45LpYA4Qa7Wz5aYAbhycas2fg01t69TPFRHDM6dSayBmoIMcGgWDD05NOkklNHKX0DZFyeyQKPFA9YJi6yucYZwVQWUg3V5bb3WIdSjCqa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 5:02=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The function is a little confusing, clean it up a little then add a
> descriptive comment.

I appreciate the descriptive comment but what exactly was confusing in
this function?

>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mmap_lock.h | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 873bc5f3c97c..b00d34b5ad10 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -252,17 +252,30 @@ static inline void vma_end_read(struct vm_area_stru=
ct *vma)
>         vma_refcount_put(vma);
>  }
>
> -/* WARNING! Can only be used if mmap_lock is expected to be write-locked=
 */
> -static inline bool __is_vma_write_locked(struct vm_area_struct *vma, uns=
igned int *mm_lock_seq)
> +/*
> + * Determine whether a VMA is write-locked. Must be invoked ONLY if the =
mmap
> + * write lock is held.
> + *
> + * Returns true if write-locked, otherwise false.
> + *
> + * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.

True, this does not result in a functional change because we do not
use mm_lock_seq if __is_vma_write_locked() succeeds. However this
seems to add additional gotcha that you need to remember. Any reason
why?

> + */
> +static inline bool __is_vma_write_locked(struct vm_area_struct *vma,
> +                                        unsigned int *mm_lock_seq)
>  {
> -       mmap_assert_write_locked(vma->vm_mm);
> +       struct mm_struct *mm =3D vma->vm_mm;
> +       const unsigned int seq =3D mm->mm_lock_seq.sequence;
> +
> +       mmap_assert_write_locked(mm);
>
>         /*
>          * current task is holding mmap_write_lock, both vma->vm_lock_seq=
 and
>          * mm->mm_lock_seq can't be concurrently modified.
>          */
> -       *mm_lock_seq =3D vma->vm_mm->mm_lock_seq.sequence;
> -       return (vma->vm_lock_seq =3D=3D *mm_lock_seq);
> +       if (vma->vm_lock_seq =3D=3D seq)
> +               return true;
> +       *mm_lock_seq =3D seq;
> +       return false;
>  }
>
>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_s=
eq,
> --
> 2.52.0

