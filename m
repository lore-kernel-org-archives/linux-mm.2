Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 059B6C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9CD6B007B; Mon, 10 Aug 2026 13:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B5D6B008A; Mon, 10 Aug 2026 13:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333076B0092; Mon, 10 Aug 2026 13:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC2ED6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:08:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64B7A1C00F8
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:08:13 +0000 (UTC)
X-FDA: 85085992866.26.E09DA84
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 64F3B1C000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:08:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t7gL5iH9;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786381691;
	b=3/PxwCdDaRhnmJip2O05+C2aQ5a5dNp+Gf6QIdblFTR+SAVYfOwuvv24oxyulv5PLracWv
	ASOoB0NzR2xs+BWFK8N4QYcW45t6FvvIGlcRjG+QqncIAJuSPUSSTfwksbA+yikhgrswTY
	MWiDIGTkaCkmqtMXxPuEtK4bnnvaojU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t7gL5iH9;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786381691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hw4jS8x5lX9rXtu6I0WYliCdVUT3IJTa3LUDLOz24sc=;
	b=7CGvI1lzqeT1/39JG8dTiUD6IbyHAvS1dOjW/wQiUxkvk1CAeHfcGTAMDjF5SRbOBb92+I
	Hy9xo8PBtfHHsSpfTFDM6Miaen9Fx7dDtHdUSmR95wmbMydxuDuK+QzDiDaBQTFn12Resl
	YuhNEGwSQUnLjXwMOsq+A7bMAm7eOMU=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c15a5b265so6091cf.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:08:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786381690; cv=none;
        d=google.com; s=arc-20260327;
        b=k6spljgt5QWkKM3GogkqTBiqCyldv37EEDJKOOl+xfJGCcDkYSFCi72HQtxuYOoT7I
         FuHQoGh3yjw7yzjX+y0bj+4YYiDkEvT3vVxs8NH3rkjbsJ4DnEPIo7ZiIOnkaeIfKqJ0
         GgpdjhOvj3rG08PAJieAOkNdzKzVCsOtLPo88PBOueHRt9P6L89VJmVwFmlTUZBmAs/9
         1OTphfIKc0wK2Dn0FWbPg0BscA2sS/ETkYrOvVL/dnjIKqZ8P3A2SA0ASSCnxFbYlwrc
         8/X7JxBrgsAwKcbxZR0h6HL1yE/1Ju7tCVOGQido7MH+Xb+BtaQnUInudzfAP2u3PhFq
         AWfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hw4jS8x5lX9rXtu6I0WYliCdVUT3IJTa3LUDLOz24sc=;
        fh=npjurOa8fnQ0O+493c4z0Id5R88MQu7x9H8age7ismU=;
        b=krwLbl4XwjGf+22TYmCc3e5sFUlQVbmtklOWDWBCoUGfBGt/Zh51dhj/E00ReCXF7/
         XBLUQtS0f7IQp53XBw+w6WgCcP5xpBIRALUhMrAf4u3u9PmcQBv8CZrbusx4mxib1Evm
         bdUHl6m7xfso8ARdkjFlJYFkG2o9A4kgMrvZbU3DlY8JEhORg0/1ngyUtTk9PFugO3Hv
         Y3LgWMGEmYZANxHdynJHDk4p82irxMvVnXwL6RtK4QUjpBneQaBnCuUrBpVXLsKbSxNT
         ivz/LWUcF3bF4RoebakC+y/Wa7QNPeXbErrJSq16Vi+TN0dRdpMLZD7AOJroGS9e4hdp
         hcVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786381690; x=1786986490; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hw4jS8x5lX9rXtu6I0WYliCdVUT3IJTa3LUDLOz24sc=;
        b=t7gL5iH9grupwpRc5fDLmYRvE3VDE6seYv3IglwT1XL2ioS5FelIGKFql4DIpPR0Sh
         6dCcu6+yK3dL6WRiS7yfVZgtQmrs+SkA632DAS1issMpsvapAtZ/JfthFQgGxg+FnXvW
         n+IS6GKsIvhAA/Cni4hluNZ9J5DkcN8Km47XqsChpyCrFyuzCcgzYbIthfioCZxOWmkp
         O779FlFYbGf5mH1KbfZem7KL1oggDH0AxstW+oviaIM78+SCK7+2HcXY20yWiAu6XEm0
         YXTcYut4jtZBDn50WYTZLJauBHegbrfE2I9bzdzCWg4LzrSlSLkO1uh6KKrqqSEIfGGj
         uUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786381690; x=1786986490;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hw4jS8x5lX9rXtu6I0WYliCdVUT3IJTa3LUDLOz24sc=;
        b=SRF/tjKVFu2ksOfWOAy4+/beGoECefTkekJSaYHWVgCn8M8/JqDnsneliXe60b8dUH
         h1JGmzG8ovE+1AOcSSOqjgT+sO5Ort3Y0PaXK9CqPBBSbav0LC1KgcW2wyVytbz/J/cC
         nVl3+TewAwhzjowpdH0MChZfcmwwIcimdLvtD7K55uBkSaGfBFzXeZb4moghupaaH8LW
         zYHdxiCZqKUiZdkt6VGmvmo57AGQd8x+FD4F4HHCSnFDFOelPiOi/+oWzObfLW/wLgpC
         H90t6Edol3QBjRNDq0e7FrPV2pyXzohfCYv3J+fDQ2RSuDOXYieZISiX3P2N1FBK/QUr
         9GYQ==
X-Forwarded-Encrypted: i=1; AHgh+RqAUQ+CBcBlLBbSLR7JDhvW0cBNtiEh8YLHXwsR1Dt+Ze1pLHh66UEpA7W+YMJHOBldpF9+1/iFKA==@kvack.org
X-Gm-Message-State: AOJu0YxHnog+da1IOlVD2GcHuwgsqpB5AKCpN01fGiq61Y83uSjBJZgQ
	nYAIXu82O01VEHDgvmXQ3uDNxaHFlKlk+3nK2qlMVKTXZzeh7F1apWDNqEmgWCKUZHkj3ZWwgxK
	6SJOk2NFdzly85a0IZMi6aG1Wfw3MT7+A4fILjA0U
X-Gm-Gg: AR+sD12tX9LE0sSn9pDRiSozxertUzJJgYKMYoOsRK+HAPLx1jq2OqSIafxAwRlZwj6
	4G5AKOQlXt2D2afcVzgmDaO75ByUCHtFmUBc31LiIGaSATmYS1WdDXS7uc+fRZS+3CVthWocjGa
	/0WelTyprUdT6v5PhjFsnDzwCuoVexeVrLZl19pAmv5rJv4CWHIsmF2rO9HMzX+YBqq/PwFE8Wy
	pd9WU7iWqw7y0Fr5sISati8g9aFoG/s06RlXtTu1XRpTZzJ5BjvVs9RVNyJAxjimAoUgWS/B+sB
	YqF+983pvYDZtDGt+Ic0FQriBJT8/o/cPO/jvhC0cAWNAn4qBE4XhTRoIzxj2XqfcA==
X-Received: by 2002:a05:622a:e142:10b0:519:b655:235 with SMTP id
 d75a77b69052e-52d51249f79mr45641cf.3.1786381684618; Mon, 10 Aug 2026 10:08:04
 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-4-surenb@google.com>
 <anmm18_pG4HXMZo_@lucifer>
In-Reply-To: <anmm18_pG4HXMZo_@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 10 Aug 2026 10:07:53 -0700
X-Gm-Features: AUfX_mzuGBlGghpOLfsrYokaQ8uXJHlSCTBj-M36Mn2c4Ekhhiai1f7pbLd7WRc
Message-ID: <CAJuCfpEQDCpTB5gv=x2A-K8_EvhFL84TbqmmyFFpszxomveV4A@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@kernel.org, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 64F3B1C000B
X-Stat-Signature: fpwphag3j35qu5bk1aoctmndwgbj3wrx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786381691-401320
X-HE-Meta: U2FsdGVkX19vnBB0Up9E/hDcMCE3sI8wP0sqh1HiLAvV6pMLxZUNu96I2NkJ1mCuXLAbbycnHi9Mhv8kB2LEUjUxegehVV+hzWKjD8JfiycaJFgZNSKEhx+7Q1dS71c1Pim5Y7N1w88YPR8P7KtGIEVFT8SBVr0PsK21zC/uE3wnXMhXFORtav328Oq/4e78NcDgrlA2+pAQoTam/b0T4HsKj4uMsZXrJOt2iD5JC5szasm0d+NUmks0mlBFLKJMgZSwr7uW/UYJnh4vgE14YJgFb1kW1iLUnw0/PtRxI+fRs8+bp+csdHoUjdOLEMCWs0XkNTkCLOYljPVEJViXhkIN6uVR+QertGc9xw3i60QQUZ70FRl9COrebH9uSjhAG6whmwpHydNfxkACGC6R2NdrhKJ+oDn1ODMbn3biT1pBhIynUQPCzcCgqPoQ0yScE9iZ3IltRmGtf08bvZyAAvA9XeY6NNUWwHxBNbBOP/e+vfAsOb6MNL6RxaheCivrA7fru4mVPLNBPaIyCw+j7rBshMzQ6jek/7U6syDK7kx+1rIOu0LrosOotw0N7U2V1hJXsQpfriVeg7640J+MC5jy7XQbv/oqmfZ0YXesqD1Y+jdeQn4Ru7Ia+mhgcLtcWtk7dc+d+/YQirlmSOAG9mbzE5sNT+UfuYnrRrpo8QPiNCWBAybI6Mlqlc8zu3JS9mtUuOZpTBaFmRX02Chh5swBvz2jPKV5mchkK2eXQkscsr2hdHbMZNgLH02KbISFcYDDqwOqx+Exquw9TfYa+XZgmXjdfH+Mk+1dJSt0GhD+Lj/ghPEDuzwPWUVza7ePaS/ih+hW4K/3eqH8Olv5jXa/b7r/edz2WlILKxAI7QSEGtwbEdRJ5p//LADJ8tcprObKRYllZ1UKEHaPGjHQ7iSjlHqt+86uwajTAiRVH8xnOtsGR09WzzeLcz+e6yCbNbTJQzsibYung7InGLD
 yIG1P5JD
 vtsSHtGDsn0/8uwuWCNyg8JTbvpmK32riJyi8ckP52N2f52FC9b3OBatjZf94pw7IiGjjETFEtefCsiFGHpqZlyzMeQFbTQtRsa/I6pGUy1KQE/6c1VIyIbfBv39CHa3HasGlE8hdVe1tKt8f8Nhg/usYc7ByUs+EyyHYg4sohr2SUK+A05w/ZRz3sG050pRcZmLq4VzwKbP2Ve+5+4gNvkvcC9mzcWmQdgStRWA3GBTUlRgej59gQ2zow+UtgqQgCBAYLWOzSTjmIhZ2EOIh0OtC6lchd78svFTclDf/zPdLMOKA6LxND0dtM3bFn7c3BEL11dHq+hjk/G+yLqECnr64d4WXMeXMLfWbJyZswcS6z1zZaBPU0Hcvc7uusl/jFC+C7PlJCIMNo9eMEf/RcQcv4585k8KrufzYFkP1aLzFOc1zK0+RHnrHe742KJi6Qlr/QzBWU3igaQJ8VuhM/W7JqYM8WbkksFTxz0INd++FsQPdvY9+puc5lDAUatZ9mjG+Y6iQSLs3hCrDXNGWbN/mxtuX3XqDJFVJpcFL2Iv0rblrw7arox/fmQcyw+U5irjaAj8lO3+4ytzWC0i1lL5xK8dhf+X7jTzKwzgb3ynyAfdBeIFNeJ/aJUm2w+dwJU+LeqdXKvgfDbU+qJGOV+v3Jv/4btsupVf9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 3:42=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Thu, Aug 06, 2026 at 01:05:46PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > =3D=3D Background =3D=3D
> >
> > There are basically two parallel ways to look up a VMA: the
> > traditional way, which is protected by mmap_read_lock, and the RCU-base=
d
> > per-VMA lock way which is based on RCU and refcounts.
> >
> > =3D=3D Problem =3D=3D
> >
> > The mmap_lock one is more straightforward to use but it has a big
> > disadvantage in that it can not be mixed with page faults since those
> > can take mmap_lock for read, which can deadlock when mixed with nested
> > page faults and parallel writers.
> > For example:
> >
> >       mmap_read_lock(mm);
> >       // Another thread does mmap_write_lock().
> >       // New mmap_lock readers are blocked.
> >       vma =3D vma_lookup(mm, address);
> >       // This deadlocks on mmap_read_lock() if it faults:
> >       copy_from_user(address);
> >       mmap_read_unlock(mm);
> >
> > The per-VMA lock can be mixed with faults, but they can fail and need t=
o
> > be able to fall back to the traditional way.
>
> As discussed in reply to Matthew, this isn't so useful to have here I don=
't
> think.

Ack.

>
> >
> > =3D=3D Solution =3D=3D
> >
> > Add vma_start_read_unlocked() - a variant of the RCU-based lookup that
> > waits for writers. This is basically the same as the existing RCU-based
> > lookup, but on a failure to lock it temporarily takes mmap_lock for rea=
d
> > and waits for writers to finish before locking the VMA, dropping the
> > mmap_lock and returning the locked VMA. This has some advantages:
>
> Nitty but maybe reads better as something like:
>
>         ..., on failing to acquire the VMA lock it waits for writers to
>         finish by temporarily acquiring the mmap read lock and taking the
>         VMA lock with it held via vma_start_read_locked() before dropping
>         it again.

Sounds good. Will adopt your version/

>
> >
> >  1. Callers do not need to have a fallback path for when they
> >     collide with writers.
> >  2. It can be used in contexts where page faults can happen because
> >     it can take the mmap_lock for read but never *holds* it.
> >  3. Its fast path does not require taking mmap_lock for read.
> >
> > Basically, when applied correctly, this approach results in faster
> > *and* simpler code.
>
> I think this suffices as justification for the function with the above
> deadlock scenario simply excised.

Ack.

>
> >
> > While at it, fix the comments for vma_start_read_locked(),
> > vma_start_read_locked_nested(), and uffd_lock_vma().
> >
> > Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Thanks :>)
>
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> LGTM, so with the changes to commit message applied feel free to add:
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---
> >  include/linux/mmap_lock.h | 19 +++++++++++++++----
> >  mm/mmap_lock.c            | 35 +++++++++++++++++++++++++++++++++++
> >  mm/userfaultfd.c          |  6 ++++--
> >  3 files changed, 54 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 7b2bbb09a952..a23fe6cbe301 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -228,10 +228,14 @@ static inline void vma_refcount_put(struct vm_are=
a_struct *vma)
> >  }
> >
> >  /*
> > - * Use only while holding mmap read lock which guarantees that locking=
 will not
> > - * fail (nobody can concurrently write-lock the vma). vma_start_read()=
 should
> > + * Use only while holding mmap read lock which guarantees that vma loc=
k is not
> > + * contended (nobody can concurrently write-lock the vma). vma_start_r=
ead() should
> >   * not be used in such cases because it might fail due to mm_lock_seq =
overflow.
> >   * This functionality is used to obtain vma read lock and drop the mma=
p read lock.
> > + *
> > + * VMA can't be detached while we are holding mmap lock, therefore in =
practice this
> > + * function can fail only when there are so many readers that vm_refcn=
t overflows.
> > + * The failure case is very unlikely and is already annotated as such =
internally.
> >   */
> >  static inline bool vma_start_read_locked_nested(struct vm_area_struct =
*vma, int subclass)
> >  {
> > @@ -247,16 +251,23 @@ static inline bool vma_start_read_locked_nested(s=
truct vm_area_struct *vma, int
> >  }
> >
> >  /*
> > - * Use only while holding mmap read lock which guarantees that locking=
 will not
> > - * fail (nobody can concurrently write-lock the vma). vma_start_read()=
 should
> > + * Use only while holding mmap read lock which guarantees that vma loc=
k is not
> > + * contended (nobody can concurrently write-lock the vma). vma_start_r=
ead() should
> >   * not be used in such cases because it might fail due to mm_lock_seq =
overflow.
> >   * This functionality is used to obtain vma read lock and drop the mma=
p read lock.
> > + *
> > + * VMA can't be detached while we are holding mmap lock, therefore in =
practice this
> > + * function can fail only when there are so many readers that vm_refcn=
t overflows.
> > + * The failure case is very unlikely and is already annotated as such =
internally.
> >   */
> >  static inline bool vma_start_read_locked(struct vm_area_struct *vma)
> >  {
> >       return vma_start_read_locked_nested(vma, 0);
> >  }
> >
> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > +                                            unsigned long address);
> > +
> >  static inline void vma_end_read(struct vm_area_struct *vma)
> >  {
> >       vma_refcount_put(vma);
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index e20d01e8d38f..1c4902131e98 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -338,6 +338,41 @@ struct vm_area_struct *lock_vma_under_rcu(struct m=
m_struct *mm,
> >       return NULL;
> >  }
> >
> > +/**
> > + * vma_start_read_unlocked() - Find the VMA covering 'address' and rea=
d-lock it.
> > + * @mm: the mm_struct of the address space to search
> > + * @address: address that the vma should contain
> > + *
> > + * The fast path does not take mmap_lock. Waits for writers to finish =
if the
> > + * VMA is being modified by taking mmap_lock.
> > + * Use when mmap_lock is not held, otherwise use vma_start_read_locked=
().
> > + * Nothing prevents VMAs being unmapped/mapped before or after the VMA=
 is
> > + * looked up, if a stronger guarantee is required, take an mmap_lock.
>
> Great thanks!
>
> > + *
> > + * Return: If a VMA exists which spans @address, return that VMA, read=
-locked.
> > + * If no VMA is mapped there or, very unlikely, a reference count over=
flow
> > + * occurred, return NULL.
> > + */
> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > +                                            unsigned long address)
> > +{
> > +     struct vm_area_struct *vma;
> > +
> > +     /* Fast path: return stable VMA covering 'address': */
> > +     vma =3D lock_vma_under_rcu(mm, address);
> > +     if (vma)
> > +             return vma;
> > +
> > +     /* Slow path: preclude VMA writers by temporarily getting mmap re=
ad lock. */
> > +     mmap_read_lock(mm);
> > +     vma =3D vma_lookup(mm, address);
> > +     if (vma && !vma_start_read_locked(vma))
> > +             vma =3D NULL;
> > +     mmap_read_unlock(mm);
> > +
> > +     return vma;
> > +}
> > +
> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_=
struct *mm,
> >                                                           struct vma_it=
erator *vmi,
> >                                                           unsigned long=
 from_addr)
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index edd90892f8cc..c3a0c38a3dc3 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_anon(s=
truct mm_struct *mm,
> >   *
> >   * Should be called without holding mmap_lock.
> >   *
> > - * Return: A locked vma containing @address, -ENOENT if no vma is foun=
d, or
> > - * -ENOMEM if anon_vma couldn't be allocated.
> > + * Return: A locked vma containing @address, -ENOENT if no vma is foun=
d,
> > + * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcou=
nt
> > + * overflow happened due to high number of readers and the caller shou=
ld
> > + * retry later.
> >   */
> >  static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
> >                                      unsigned long address)
> > --
> > 2.55.0.654.g21b8a5bc05-goog
> >
>
> --
> Cheers, Lorenzo

