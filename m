Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E0CCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 20:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495DB6B0005; Thu, 11 Jun 2026 16:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46BBC6B0088; Thu, 11 Jun 2026 16:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381246B008C; Thu, 11 Jun 2026 16:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 277216B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:40:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0A30C27C1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:40:48 +0000 (UTC)
X-FDA: 84868800576.27.D9EE579
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCCCB180003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:40:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eU5tmWxr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781210446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a67OUTXkhjPmGT9xbEw7aC5sM6vpNtps3UHtPFQcUpU=;
	b=yf257M+olaIDD0xshRhO9wNXQGHHbT2S9G1tInZ6oQ0TkuHY3MtVkj6LGSsu55LZ/W8OvP
	CnDrK326eax7b5A48jer3yfK+WKUMlJU7RqWD6P6Kv+w6tOnHOyP+b2IZ+YEKgKBCV/wQK
	ziYdU7lv1Pehvnd1xEPqH+1rD73wSqM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eU5tmWxr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781210446;
	b=rI7J2w87ztVY27u7n3a07eat3wsQU6PkEvEVfR+qGdEFoyDeKiVsx4vNNv5gUceD0M/C7r
	S16U7J9JYbduH15f6k3CD6uJDdwkG1orisGBGuq1CV4rH3Z2wlMQx8tK4e5jhyobpYg3Hr
	FDu4p1xmEYt/7b9JAA6wV6piuTkkJWM=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51765331535so36901cf.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:40:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781210446; cv=none;
        d=google.com; s=arc-20240605;
        b=FcETlsU2sa1iSqiFhRy3yJXYu4470hBnCQXJbXpJl1XXek3qC6gJfPD+zRvercDJiA
         QHrm5AS5zfhgyG/Jbw42FdWWsuG3Mu2bqmMurLfuEeYmYqQs0LOketh2t70URODQEIav
         9Chb+wmqtDLdgiuRpmX1Tw/qFMIPDZCTUeSViC4yJ3EYY6dfKr4AJNUM/pK7tijI4sUa
         RbNtYZ7L57SAjrQlTpqQEDXlYrLriRuz70H2+QHYr6OpPSgrCzbBc4ot4WNdyrL7FIDv
         astaDfExQj5IwAC8PzR4mUX6UReJofhaGs0S1KuLHXII1OMTSQiPupA3BLzFM7JRfdFl
         BMtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a67OUTXkhjPmGT9xbEw7aC5sM6vpNtps3UHtPFQcUpU=;
        fh=Uml+DoVFbD90oOOL4H7UMeAb9sNWjwwOgSNQtV7WtTE=;
        b=C76w/RJVy8uF3kkvjM5l3h2b3RLUNg9Z+rJFnysPqk9gX3bTqstICcFZBG26pvAi+G
         MdKJFNRoQGsZnRI8OY3lLh0NCoDK41GFLs+KHq3MjGlKl51KytPhE8nJwLs31NF9ms5K
         Zyi4EjSgcrQXHvZCTvCM00KiXFRBVHbEDTq6gQnah3E3nzlmtIhQy+B9ar/CUYE/iNV1
         EZsD7wTbE/1Ncsh/AsdOnUe3wELvasiRoUEtpxrUSEp5KKLOtRlOHnBes1DLVC006Kfv
         XVZLvE03rcRcb08WaF0QWa72WGOjpcnbNmXYYgm+x7IWL4BvPE0ubbZFUyKbFj2sc4p1
         09hg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781210446; x=1781815246; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a67OUTXkhjPmGT9xbEw7aC5sM6vpNtps3UHtPFQcUpU=;
        b=eU5tmWxrz+8lmybuo360aUZOq9hA6o3SZIU3LN3O/5a0OoZnIiRi+8VgZ644SjWo4O
         A5g3FFfhI5Llr6VcfUuM7IVn9uovLZpEnwBT6YFqobTUUFuDTTGJMvCru7YjNAsnfm2o
         u3DyQDBb5ulzWbWvdSy+XfXahENJmVLD28qh95awr1Vh65S0iDDfadt5pPHy6aXEhw/e
         xU8k57cV1dCMxQWlI1A2FN0VVBJ5XgGN+rzFcNM7CemBw3rg1gPEzD6TCoSRHb1D/eTA
         JXRpbHKBDO/xrEfb7SRr+BlaTWI+R3ou5oK4sSEZM7pEZeXtIJhhHy897neJ1h+MR1q6
         eO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781210446; x=1781815246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a67OUTXkhjPmGT9xbEw7aC5sM6vpNtps3UHtPFQcUpU=;
        b=IWebJojKarSCHyEXFI+wj3ctmtBybesM/fZecBF6bakyXuSqUpNAQMsifgny2rHnIm
         1OZnc2Sk/55tEcAR10Y68SQnRJ+X1urQYWvPd/DLpCSS2WbjSdJqt1o4VilI39SOtgDa
         b7piAgO1QqLeDL4NBmzmC1EgzzuO1P08OF1sx0LXIPAaWoZh0S/rSTJmBEVFgyh49bcG
         lnX2938ZqGbML3q+XBdbSe2NykQdg/AkkSdnAwz0rAecAhJpoOV0GzY5VlHRrby0GeQV
         Xm4TVVJ7mqy6JWud1mIJCHdhsRYpAOWipT+7PbCg22X6Aq1SSCSGZ76zunBP0kilTc0U
         o1Wg==
X-Forwarded-Encrypted: i=1; AFNElJ/dU/5I6s/OppAXEkzhr33xyl0Y26zw+M4RyXQlXHw+TaAXEE8VuWTQPlFAJFM/3Iw0qVUeFNN+LA==@kvack.org
X-Gm-Message-State: AOJu0YyFprjrvCyQNSs/25YYGVxR7OvboriBFp8IlV6gZggFxP9uTVl/
	mTNsJxx8mGyLGyPpwMB1kFR0FF938moFv7hFbUoW3m2fsGNdTRbOkgezZQRococ8ETfsVsUjT3b
	1heRIXPKdYNYgQbIT86ESZHMoetW59j4QK3kLsKgT
X-Gm-Gg: Acq92OGfj+X04Byw5UFVtRpnUAGvXEJhgd8M2rZHnz/8671PWm8z9M1pd5eMPA/AcX6
	/k7BjPLwrCc3V+BGF1tsinW3v+SnYOrlNMqgYBPlDIo2JWcQdNx2pSdHExsoWiss2DN5CBXMEeW
	bfE11cz6NRNiZgqeABna7GBqlm/cqZL9MFr0MM/sKUHWGOP1SGHQx5R6AqqoLkq4R1oPUCLdEs4
	tA3qFT6RJeZEQ981g40KvAPcXe3YRpeTV7KIyXFg1V4szSXuPxD9EH2RWqz0h+cERKIF0o6RvTu
	ytLrcmH1MybDIpbD0F9ibstG528sGf/xyD2y
X-Received: by 2002:ac8:7d0a:0:b0:516:4f62:85ef with SMTP id
 d75a77b69052e-517fb16d601mr2052891cf.20.1781210444924; Thu, 11 Jun 2026
 13:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com> <20260610230417.77D64DBB@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230417.77D64DBB@davehans-spike.ostc.intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Jun 2026 13:40:32 -0700
X-Gm-Features: AVVi8Cew8aBPn6x6_sXyc7lWo3YXmdpq0raUK5xFBrEewhgPTGQ_KDM8NSP7OKA
Message-ID: <CAJuCfpE8VsYTfHA2Qbv-KXBKOV-e4e1MDNJdDYgMCEPjtosgOg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] binder: Remove mmap_lock fallback
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 99s84k8i7en7cnxkq9734ieardfjof5b
X-Rspamd-Queue-Id: CCCCB180003
X-HE-Tag: 1781210446-809941
X-HE-Meta: U2FsdGVkX1+0RKTp8J+yr8G6PIwBcE/dCkdvmaDlrbhbQBPNX1C3BsZlvV1Q0hc/Dk7CgP7yMSMItgunEtmCY1TwvGLBk2kHZlabHpJ0ZyD1NRtDhAwLAGD+c57DfvK6RN93xDQ0KO9AIevmUUI5ZpY51f27L/9bzzBoxVMn66y++dURPxkXcz2bzuJP4zQM2gB/BTcwKhuk228a8cll/g57AjGOWMFZkFOCSuH1xBpN3bnlsp1yUfxruoYHTAtwEu+gA0+LbUH6y4WPKkuHiUTt5xmaMafWBuCY1WtiFJLUxDqnB9saE/ilY6Dv+tPlonrdeCq9bBnMjk3J+SQq9kKN2DCoGY8xhZ/YQZoaqS42q7p6nDg6GPwPTyioGrIBCMGoFyCJepORqxtFxJa6EXoLQOgJnvYcPPLex7ieGRuWIeW0YlDxCBvhRpOdbEMXhbnPwDV0pyPX2jKmxwO7TQVFUe3quOu8HKWeaiPDi/S8PxWmmayxCVGrI2Pa01tl9PI0V4vh8ELLeafJ3SALWIJvIkGCg7Bac/LhbhzMPAfyCfbwYCpeebPD4NLR9dNncfoSPggKinFJAnDI6j+NQQt8tBtpvJIvYgelAx6XETdjrCsUZSiUZezkzkx++AVzKRTEE9tHlSxlAd6mCw8o/8E6Y/RA4wMRUnHY7VK8zotgutEE9xMvo7zOs6k9p+OfnOCFpc5ig1CwK+meDT4+k0637489xFQCZyZoVAXbthNHojq+7odIJze2cdiM3uKJ81/aw1ifLXBfjZe1vudPsucIFNTGlDpccIh5vDRnkHo8aAsj6zHc4HhZXA9iwaI4TuR+uQs8+zuUVIO7anmiKsh/n2ucMXdTJ/Uh67BvtmBUFC96+sn9I/aXhxk0zwLgQJKGNM1kdba/6qkubLgAJVJd1hVoq2VghbpIVjuIsdfHF7xONvDkJ2fxruaSi3m5Wbk4qXC1lca58xvKveK
 vgVuPcoU
 s66Kt3VDUJUZPiyi8jD2TRF+Mkaewgeg8TSf8SWxJz+DR49MsItROS7h+c0jl9rAmYPaRXtj1QlLGXwq/RBgViCGI+aEpMuQCOe4G2wsLuw8UopU49QcqLsqNZ9JuMSUKxn7HAuouTV7DHiwrOMk6XTb4hOYdAM66bo9GuNVdZ8llskTbtbvIH+T2Nvgva2lKl37kJFCVl3BnOTw8mc1sRao+niDPk2lIjNYTtmTGlwGKj4A51gdyQC8YDcAZeiVPzunIJP9aLuF7OtRlBb/0vsZlnSuh0Q26umMraeOP7FvN4Wy8t+BK7hjopKP5fhDgD7J/khICt5dI7vhKgQxrVNFDAwDKPwTbGDJjNhZK0pJlsklkESLp//+0khBuF2ysEsfdvDbvv6QkJu3SKfAmRFjh5u/FoZUoR2ERs6pfQrlFaz/EuAKCXjwFV48WDJ177PSM32dgAKM+0ag4HrS3tEZ6BlWMCwF0HBy51uWIeG4ZBCXja8HN/sIv4Ax5XbIuCBofrNBOtj5XzV6JAFZOSDil2NbWGOd6RSUm+r976Cc5R0dKkW0AUzCtxqGeYCMxUAghwel9JGlc0ZAlJRBoRiSBug5SuwnR4lLHyTCgIVxyRURrfgvJh23lAur/zmFf8fx4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 4:04=E2=80=AFPM Dave Hansen <dave.hansen@linux.inte=
l.com> wrote:
>
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> Previously, the per-VMA locking could fail in the face of writers
> which necessitate a fallback to mmap_lock. The new
> vma_start_read_unlocked() will wait for writers instead of failing.
>
> Use the new helper. Wait for writers. Remove the fallback to mmap_lock.

Nice!

>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
>
> ---
>
>  b/drivers/android/binder_alloc.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
>
> diff -puN drivers/android/binder_alloc.c~binder-vma-waiter drivers/androi=
d/binder_alloc.c
> --- a/drivers/android/binder_alloc.c~binder-vma-waiter  2026-06-10 15:57:=
56.419452721 -0700
> +++ b/drivers/android/binder_alloc.c    2026-06-10 15:57:56.423452863 -07=
00
> @@ -259,21 +259,14 @@ static int binder_page_insert(struct bin
>         struct vm_area_struct *vma;
>         int ret =3D -ESRCH;
>
> -       /* attempt per-vma lock first */
> -       vma =3D lock_vma_under_rcu(mm, addr);
> -       if (vma) {
> -               if (binder_alloc_is_mapped(alloc))
> -                       ret =3D vm_insert_page(vma, addr, page);
> -               vma_end_read(vma);
> +       vma =3D vma_start_read_unlocked(mm, addr);
> +       if (!vma)
>                 return ret;
> -       }
>
> -       /* fall back to mmap_lock */
> -       mmap_read_lock(mm);
> -       vma =3D vma_lookup(mm, addr);
> -       if (vma && binder_alloc_is_mapped(alloc))
> +       if (binder_alloc_is_mapped(alloc))
>                 ret =3D vm_insert_page(vma, addr, page);
> -       mmap_read_unlock(mm);
> +
> +       vma_end_read(vma);
>
>         return ret;
>  }
> _

