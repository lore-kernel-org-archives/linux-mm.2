Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F006D10AB82D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2782A6B00AF; Thu, 26 Mar 2026 20:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250356B00B0; Thu, 26 Mar 2026 20:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165E66B00B1; Thu, 26 Mar 2026 20:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 039136B00AF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:07:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99F985DAB0
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:07:49 +0000 (UTC)
X-FDA: 84589904658.05.D81AB13
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7DD8F80011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:07:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="qxoQkM/X";
	spf=pass (imf30.hostedemail.com: domain of jthoughton@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774570067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6bohw50RBT0u5gW1o6sQ8ESS0bizoR3I3eC4aqE/wA=;
	b=j7P+SKgH1jiXEZsoN4+HxN8wM9lt3xx5B97nttNyoA9kzngi2P+HaMSv1+l3DCXypt0EYS
	qN5R4NpBU5HmHWpIi01N1edlYp+doPRVckzqDw8E+NtI0km60KDIPCW3gL9cmWi5USRrA4
	p4ydP2gu8xuH2b0JgiBROihSKHgBdeA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="qxoQkM/X";
	spf=pass (imf30.hostedemail.com: domain of jthoughton@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774570067; a=rsa-sha256;
	cv=pass;
	b=JkboP1vbfLnPfCALPcRxWtV8FTz8VldS8hTNs6+2mOLjUaqIO0cxeLL3VcvD+6Xb4qJPc/
	M2op+VIAehhgVtNgKwZ/S2g1YorcmlvHQRGug2NiRHZMNQM7OHo3IMhD2mzQuGN5OSG4FO
	OAgknMaJQphTT9c7GaBC3Jomy+Xzp9k=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6674cba2c50so4054767a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:07:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774570066; cv=none;
        d=google.com; s=arc-20240605;
        b=H+8koNh9Ze0VgMdpw7ynzRETQ9IC0OgEEgNNczvbqOzDTdJ9bYkKD5Ianl2vDCuKer
         7VgmGI+4EQA88XWo32HacttpnTg/OOt2jlTHakF2fx9WRoHJ/ow6p88T+eNmQPY4zjwi
         IU0VZqYVmqHIIZL0hLJtk/e6COv/t6dgYtYiRkNqShChFgIh2kginuCVsWo1yNWl+x+C
         eSVX+VVJMT+xoTmAajCR1vlPfSMzuZbLl1vlwcwYVGGyNegiEnOivJNLEWK/AdbK1vnL
         eY9svekxNFLJBOW3Vevrzfh7pTQJl9GffAV2rTJe/jue/dSwkN+XsBQ3v5jtgj4eu0WE
         2fIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l6bohw50RBT0u5gW1o6sQ8ESS0bizoR3I3eC4aqE/wA=;
        fh=1pEl9Wm5yfAdIRgtew+aKr2wG1sPARWww3B3kqqQ5fo=;
        b=TFsBKl/ZMEmVjp9dDEDEXEE3IOIdFaNArQizukKr7gp3z2kC3OyhMFLagY01HxypKI
         NpirBmXXdB6iShEwxCtEotSPXuVlFXdF93S8WjrJXxGU+9sZnC4bXx1gWrXk/Mc+plIa
         NjyB0equt1Htky4qj/D00CyZ9svSQwsUhZ6/D7wg1KDL9NesDe6L0CfNfaNqNuc635ws
         /4YYq64Z56HwjSJ/28+A9QDJNmMvIsDAB2pVmfh1sSvMD6GUcsCFRY+2zccg5LSAIT2G
         eJpmwtRHiCwkzosxIgTUrIa7lOxKWXlpAfxr8V487gPYp9Gi5mEAL3hrkAP4GGosB/xG
         brDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774570066; x=1775174866; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6bohw50RBT0u5gW1o6sQ8ESS0bizoR3I3eC4aqE/wA=;
        b=qxoQkM/XqVjf53w0rG0MSQIB8PkTZ63xEAq7Ck0JZJ+z8/GAKWXTWDeRguvuwsCXZN
         efKJYpVcY7+A2eOqHMzRvlyI9+SMqUl6GcjExH+7QZegn7a2aZkp4BPCtjTzKjlHwybk
         1w8Ow1CMICiN7yyboHkXPRrTE8xr+tvdkgqSS70CIZ1yiYTygaxOl39oM32nbjnnN8se
         TPtCzH1D17qI5EaW3fZZ9LAKnf6paT+13g6zj9CRs+thXAVx9lJrH01CDc4yn25QPKCB
         A/eIw76vB7t3rl/GFj/W7I6CZc4kued8BOi/24+rJYGbYSD1jY7ClEz+lPaM4sWwFOEU
         6FAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774570066; x=1775174866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l6bohw50RBT0u5gW1o6sQ8ESS0bizoR3I3eC4aqE/wA=;
        b=YuHC7+S/+5hOs5nB6uuaaXNLKUPJmhWcGXMCdeUgFTjD07HvW2DD9GqTU/xrfdS3Ym
         fGl6/1yMxdJt54wlOsH9OkTiDxnOutN2f18McKO4U9uhT99vK4icbtoRP+aSmYMkP4Tn
         bOLOZ3UxTk68++22gu1FnC4le/4Gin8JPOsAVk2i21cHrL282S/4G6uv7BNQjp9EW8vy
         Tyow8dV72DETDP87RtJ1y51RpSgTcNO8YelzoZaCnRSHWlADiNMl/puNeKjeL07HqPx3
         6amIi/ODeKypTBQ5rOUpW3q/j5j0ZICLEHhAQ1MZOCJ456JNU+6T1I8yhZbAlANxvbtr
         G9Ig==
X-Forwarded-Encrypted: i=1; AJvYcCU3mucuM40QIk7vQGjomJUaq+XaXc7q5BoRXV6YSqKu+6UDauLG86a7Zgtbs6nwo6ugW+bPdsJEAw==@kvack.org
X-Gm-Message-State: AOJu0YzqqjkX6mLTbxWGg+ww+3JEFcvviWHvQzx428LcI8vhLjRIpNEL
	3oXYEKhTcIsK5uAqskhvgD4q+NoQ2k3E3G5PQkAAiGx9dD/4mYcfI6SOlS8w02Kh0CgCDtCCAcO
	qKEfyrG38pzpbzy12HwqZa3k2P+Vr6TIcWo5dB8Hg
X-Gm-Gg: ATEYQzygg3loTWxFeNp7iuLT26smsujzIgVYOsXRHfpKOPVnuWIeP0tj+rmorXO08Fl
	DRL1fF4KPeNcClehCAlMIvxHZzDJsUdP4CRUNcFA4WQQXAGAPJdve0Je580nq3H9kNe4zvOtFER
	ZyxRpQ72htrmNEpFbJQaFV22+ra2wpJH47dtx9qjKLCwwvAsBYpzo4DmWVk26CRVDl6UodziAJR
	DrVJYMIe2Dl7vTfWhtoNX75PrZJ0uIl7YMrGaaXyjsDGsMtisV65CDwpBdmzNH2RlcE+0VaXW0V
	K5Rhc4GmIzfB/h/fRhKMwpXqs3TLw1mQYa+48G8UvsF+MWLy4B4RCfLnsXZWU6ug027v0Q==
X-Received: by 2002:a17:907:7b9f:b0:b97:b0ee:34ed with SMTP id
 a640c23a62f3a-b9b5226a311mr13471466b.22.1774570065298; Thu, 26 Mar 2026
 17:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260306171815.3160826-1-rppt@kernel.org> <20260306171815.3160826-10-rppt@kernel.org>
In-Reply-To: <20260306171815.3160826-10-rppt@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Thu, 26 Mar 2026 17:07:08 -0700
X-Gm-Features: AQROBzAFCjzaDdbadwVNMyg-TBL1aRLjN2g4Sfb-4vpKogbGWYvxURBEW8LNmxM
Message-ID: <CADrL8HUE1iBSPPDQZ3e-1gxN0Ts9kHAzb4o5X_XqSmQy2y9dRA@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] userfaultfd: introduce vm_uffd_ops->alloc_folio()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DD8F80011
X-Stat-Signature: qfj79f5fcq3k1yu573f3zri7eb3sfigj
X-Rspam-User: 
X-HE-Tag: 1774570067-528521
X-HE-Meta: U2FsdGVkX1/hiqdVEU3sMOhsQ/snygU/KlziEAuel6n2Pvh+sxUMQ0ix3PgbW8GKedbzobUU4RqeJJPJYSfd0I1A4CuY99/d+Q0LGmgmWHV1ie4lrzTSNGf2VdIwLZSdGpFXutxVHE8hEewAEweOk2e088pGSb7ZFZuGyEuMwUsqZ3jBOyJTUcZRJRfmPDfeRKLVkdqABhtbXOibycxkbdvQTjxX/kX06h3PkVZDOO8ycoUIAfi/788730PX1O4GBEZhydTzJfeYF3qNhqsBbHw0mXsNOYSySe5p9IEFJZCiAmOX6rFCpupH0Yp92SikhiOM06U5OBnwCPBuYYENEJGouxSAk/Uq7hQM2q0SBylN/kQk7LXItvJZ9ARprw79w+9X9j4TRNyR6xxcXQL0JdCTuxH+u+FkjyVs8MUqnMOLEkiX5VoS/XhffDdgxrHTmJNM2V8RCAGScND0Y2mc5eRbdv4/NnMP0IcL1TgqTFKPqpya8DZxyzJ8kPpyr79LCoMuQjzgOSNNeyzJgt4leKQPgjyEOxiEWMSz+qwqnnxfpnaLKOf0FR69vMLq2TO8cOrnznX4FmbQZCG1A3IMcWcZKir4VoliHCz3d7+BNyM2kabT0+9Pae7oHKN+5cQ0/NVx5KBj6f8vRHnjgLRF4h9Jeit64Ln/G0ph8gH+KSnsjQ4b9/mZCImPy5PEU0xt//0PCeIf1/X73YkHRFeMilFKEM+V1YrDBjySz1ehBd46d5d5hgTyjqXAaKMc/IL8Jcte16LtN9qrcgfthqZCDNyJj/rIwoBIJzNcXGaeFcr+zzYH8UvRZuvfZz8owK8kRR3tHT+WSteBr3meqYVKcpstfYDYPQeWmw3vrLmkD1DwKc3MQNAMrqumo3kbRlRDewORLh7pOTJk4GHTQTA4B8Z5qCpu56zH69liMhFfQekYFQHV1LvokM4juY9OySFoaKf4qMiZtCuF0kES0g2
 7CLasJHR
 S1Vn74urSrgM4KfFS5Y3YpKlBI1CY00qc4G4r/mphhTbhw2rylaIp0gCezzdHQ71zRWc4DT99pcbr85zgSBpU6KlkzCWf0RYW8+r+1P/5n2slomLtTt0EPt3cimRaFh8ajVtDMKq4m4F/x0klkCKukZLrJc6Aj7sRCJF6o0ByDkRdQNTVPTZKzLgWuGghRBwGf4N5NS+984rDr7KWNUSjMLOO6sA/yA8foumMHI4e/muvjlw0KxgpEM4JXzS1+Ef7xp8RTsPq4Q62smL9mRARphLv384XCuhSuTzvEqaNmI21e3vWL19V7aYcjEsvsjkVCNX1IvkWS57Jcco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 9:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> and use it to refactor mfill_atomic_pte_zeroed_folio() and
> mfill_atomic_pte_copy().
>
> mfill_atomic_pte_zeroed_folio() and mfill_atomic_pte_copy() perform
> almost identical actions:
> * allocate a folio
> * update folio contents (either copy from userspace of fill with zeros)
> * update page tables with the new folio
>
> Split a __mfill_atomic_pte() helper that handles both cases and uses
> newly introduced vm_uffd_ops->alloc_folio() to allocate the folio.
>
> Pass the ops structure from the callers to __mfill_atomic_pte() to later
> allow using anon_uffd_ops for MAP_PRIVATE mappings of file-backed VMAs.
>
> Note, that the new ops method is called alloc_folio() rather than
> folio_alloc() to avoid clash with alloc_tag macro folio_alloc().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  include/linux/userfaultfd_k.h |  6 +++
>  mm/userfaultfd.c              | 92 ++++++++++++++++++-----------------
>  2 files changed, 54 insertions(+), 44 deletions(-)
>
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.=
h
> index 66dfc3c164e6..4d8b879eed91 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -91,6 +91,12 @@ struct vm_uffd_ops {
>          * The returned folio is locked and with reference held.
>          */
>         struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t p=
goff);
> +       /*
> +        * Called during resolution of UFFDIO_COPY request.
> +        * Should return allocate a and return folio or NULL if allocatio=
n fails.

"Should allocate and return a folio or NULL if allocation fails."

I see this mistake is fixed in the next patch. :)

> +        */
> +       struct folio *(*alloc_folio)(struct vm_area_struct *vma,
> +                                    unsigned long addr);
>  };
>
>  /* A combined operation mode + behavior flags. */
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 98ade14eaa5b..31f3ab6a73e2 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -42,8 +42,26 @@ static bool anon_can_userfault(struct vm_area_struct *=
vma, vm_flags_t vm_flags)
>         return true;
>  }
>
> +static struct folio *anon_alloc_folio(struct vm_area_struct *vma,
> +                                     unsigned long addr)
> +{
> +       struct folio *folio =3D vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, =
vma,
> +                                             addr);
> +
> +       if (!folio)
> +               return NULL;
> +
> +       if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL)) {
> +               folio_put(folio);
> +               return NULL;
> +       }
> +
> +       return folio;
> +}
> +
>  static const struct vm_uffd_ops anon_uffd_ops =3D {
>         .can_userfault  =3D anon_can_userfault,
> +       .alloc_folio    =3D anon_alloc_folio,
>  };
>
>  static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma=
)
> @@ -458,7 +476,8 @@ static int mfill_copy_folio_retry(struct mfill_state =
*state, struct folio *folio
>         return 0;
>  }
>
> -static int mfill_atomic_pte_copy(struct mfill_state *state)
> +static int __mfill_atomic_pte(struct mfill_state *state,
> +                             const struct vm_uffd_ops *ops)
>  {
>         unsigned long dst_addr =3D state->dst_addr;
>         unsigned long src_addr =3D state->src_addr;
> @@ -466,16 +485,12 @@ static int mfill_atomic_pte_copy(struct mfill_state=
 *state)
>         struct folio *folio;
>         int ret;
>
> -       folio =3D vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, ds=
t_addr);
> +       folio =3D ops->alloc_folio(state->vma, state->dst_addr);
>         if (!folio)
>                 return -ENOMEM;
>
> -       ret =3D -ENOMEM;
> -       if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
> -               goto out_release;
> -
> -       ret =3D mfill_copy_folio_locked(folio, src_addr);
> -       if (unlikely(ret)) {
> +       if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY)) {
> +               ret =3D mfill_copy_folio_locked(folio, src_addr);
>                 /*
>                  * Fallback to copy_from_user outside mmap_lock.
>                  * If retry is successful, mfill_copy_folio_locked() retu=
rns
> @@ -483,9 +498,15 @@ static int mfill_atomic_pte_copy(struct mfill_state =
*state)
>                  * If there was an error, we must mfill_put_vma() anyway =
and it
>                  * will take care of unlocking if needed.
>                  */
> -               ret =3D mfill_copy_folio_retry(state, folio);
> -               if (ret)
> -                       goto out_release;
> +               if (unlikely(ret)) {
> +                       ret =3D mfill_copy_folio_retry(state, folio);
> +                       if (ret)
> +                               goto err_folio_put;
> +               }
> +       } else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
> +               clear_user_highpage(&folio->page, state->dst_addr);
> +       } else {
> +               VM_WARN_ONCE(1, "unknown UFFDIO operation");

"Unknown UFFDIO operation. flags=3D%x", flags

seems a little better to me.

>         }
>
>         /*
> @@ -498,47 +519,30 @@ static int mfill_atomic_pte_copy(struct mfill_state=
 *state)
>         ret =3D mfill_atomic_install_pte(state->pmd, state->vma, dst_addr=
,
>                                        &folio->page, true, flags);
>         if (ret)
> -               goto out_release;
> -out:
> -       return ret;
> -out_release:
> +               goto err_folio_put;
> +
> +       return 0;
> +
> +err_folio_put:
> +       folio_put(folio);
>         /* Don't return -ENOENT so that our caller won't retry */
>         if (ret =3D=3D -ENOENT)
>                 ret =3D -EFAULT;
> -       folio_put(folio);
> -       goto out;
> +       return ret;
>  }
>
> -static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> -                                        struct vm_area_struct *dst_vma,
> -                                        unsigned long dst_addr)
> +static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
> -       struct folio *folio;
> -       int ret =3D -ENOMEM;
> -
> -       folio =3D vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> -       if (!folio)
> -               return ret;
> -
> -       if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> -               goto out_put;
> +       const struct vm_uffd_ops *ops =3D vma_uffd_ops(state->vma);
>
> -       /*
> -        * The memory barrier inside __folio_mark_uptodate makes sure tha=
t
> -        * zeroing out the folio become visible before mapping the page
> -        * using set_pte_at(). See do_anonymous_page().
> -        */
> -       __folio_mark_uptodate(folio);
> +       return __mfill_atomic_pte(state, ops);
> +}
>
> -       ret =3D mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -                                      &folio->page, true, 0);
> -       if (ret)
> -               goto out_put;
> +static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
> +{
> +       const struct vm_uffd_ops *ops =3D vma_uffd_ops(state->vma);
>
> -       return 0;
> -out_put:
> -       folio_put(folio);
> -       return ret;
> +       return __mfill_atomic_pte(state, ops);
>  }
>
>  static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> @@ -551,7 +555,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_sta=
te *state)
>         int ret;
>
>         if (mm_forbids_zeropage(dst_vma->vm_mm))
> -               return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, ds=
t_addr);
> +               return mfill_atomic_pte_zeroed_folio(state);
>
>         _dst_pte =3D pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
>                                          dst_vma->vm_page_prot));
> --
> 2.51.0
>

