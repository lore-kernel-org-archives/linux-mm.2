Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12BECC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9706B009D; Mon,  3 Aug 2026 15:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53636B009E; Mon,  3 Aug 2026 15:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3936B009F; Mon,  3 Aug 2026 15:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96AD06B009D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:17:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27F2D1C138D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:17:13 +0000 (UTC)
X-FDA: 85060916346.17.4482C6C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3182D140002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:17:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mEBkKe3a;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785784631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNIAfYo4GwsoTuLWmj2sTbEFVhYgxiEUZM7PCsadCHA=;
	b=I/Vdu0Au8ID4+Kmf0fxXgrNHUuR08oQDKgxptR0OfQF/CH+eAD5VWZ49rxKC23cnt/6CfW
	MUozOJN19lUVnk5zaogaZkNxEcVOHUetdCgKQt4CF4kwrRX81qenm+3W94IBZNrUV8V+gA
	2iOD3BDbl7N8/spzwGY8Dy2c1H7iotE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mEBkKe3a;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785784631;
	b=FrDFo0lXRZID5eTtkPC4HkMhdfhlEuJ1cT8dzHOqshQGuI3+454kKqwqxKZDxkwyi9E/ns
	of1Dit16ELfphkhOE7PSJBox7lGe9hG8m5qD1LuMRcVlp9k4wpZD+yReQ2epEpkMQueO6d
	g53z1vlE+CS9QGznHsR287L3FAW0F9A=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c01c79467so58541cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:17:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785784630; cv=none;
        d=google.com; s=arc-20260327;
        b=bl1/O4ICkt99ZLL7e4IauuOjG6FCfhpC7u9Rj2udQ/Ro0wxzx04IaUl8TwuEYIMEG2
         aDPhTjnW7IW1JuqgAapCfgqnzyoGYWGG+QbSDd4oENJj5Mnb/yjpCmsUmkZz5pKyJHOT
         3RfvdnW5DltEWMAdTIIT7MQGl7DtCuAggoE0n7pgBZRxzComLgE8IqEgTK7zNxsTa5pO
         bQ+h4XGliRjcmdL589pzp+0sa8VMTmukd8wWvisO98jtL0bDLgmguXrnkpFXNPeXZcGP
         I39X3hA68OGT7qOiA3NHPDrXTx50Ivrv5EbV4MUXNGLqtL2mRkADyXUPj78xJSBKnUFD
         v9yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hNIAfYo4GwsoTuLWmj2sTbEFVhYgxiEUZM7PCsadCHA=;
        fh=gSwad0vlBS0gxTRldLym7zVKbEC0TesmKV8GWsmKZ8g=;
        b=hYl55Gicach6KMAvsK0drBWMPejIgNFemvhRwhZyqNaDMM3yCz9KIzoZraMfccv4k6
         gaEgOOmkya7i27ogOkLB+hiQpOZ8/GWrvXLRUjysxjESxmsoArUXsqyM36zsqDZK7bNe
         KxG6BFLxt0lwR4ZfZczoEjwvd9K3DPzjNgAEtwhH7QyrD9j7snHIIMKZy9+U8ofjC80i
         aZv2ZSzU87NEyhFlCQcTtSOAWvS2koHNX2bV5X+LEwUNK2w4PDIY73cn63EM0yDH8U3T
         V/tQ79B5l3rb21U9D/44u7UqejCjAltaayZ0ukD/R2PUgGIDUPRhDG+wZHHnfumWGNh1
         695w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785784630; x=1786389430; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hNIAfYo4GwsoTuLWmj2sTbEFVhYgxiEUZM7PCsadCHA=;
        b=mEBkKe3aqiVWKlLHB4wp0JiwBjJZ+YmGSM9FpQigXgO8rCDThqV1JI4yoHcETmWNHJ
         wzzFsaI070IXCED5oAbi44AB0fk1rWbKh4zgBZkdFOFIhBZ3l/UY9Ohi03m8xcX/l871
         ZuOsPWu24lJVvFc3IcbeZNDrVOrLTDY9b0MCwTsGZr7LaPqrA/XdpKZNfoYqiUN7fxmP
         owQMWYsI7Myxvv8LqB76HwvpsNigwmO088+tZLECdnRbzFWeUAbcJRdK+DSUisN/88gg
         0jqD4W0EtlQr1bp7ws84EFuLU+IHtgiEj8vwW4mx1DIU0liJOwbItQObfBn7yQdV3WAZ
         kjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785784630; x=1786389430;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hNIAfYo4GwsoTuLWmj2sTbEFVhYgxiEUZM7PCsadCHA=;
        b=Ft7PBWLRbB/10+yeM1G870gm29EniLcc92YCd22hsxZyGeAYSa/9eqF7OkkYF1AHQH
         DN3zlbPYb2oBSMlrtVVa8/8Q+7S9Gaw2dXRdVRP2q0EngZmW/Hcu8y/F41pU8LCBYtjG
         OmCoccnusT7TLxxtVtbFVR8AkmDpvyVsQXGMFjaIlibIgV2NbxIbmW8f4EYytcUoWuRS
         1KivEb6oF5RtVO+aaRxMOvfKn+qSuMcr4raRLKz/jLTz4G3JtDUFbAVe09FG8hKw0sIc
         IFQT3G/FKUj2AXg038MD2rtBoYwbuQEVT4LnOYx/NRG2rtOdfIaI98vto7/rJuzF6tBY
         1Ttg==
X-Forwarded-Encrypted: i=1; AHgh+RpuIRDB2KIIpGdK3EntCNhpST5hTSZoxKvWZ5AvbWAfLXzsKZmghJyhsCj/MN8d5hTj5VGzgZ8Qnw==@kvack.org
X-Gm-Message-State: AOJu0YzCeMwNw64+bAHgIt2v6LFVeJeKh9KhX94aYhrxkYG5DX/0yHHF
	Pby448PGsmtkiFdV8pzgULUm58LeRkknHxkyajjoBitQ2DubW2vAStHSjZAmwjzigb+gaJqU8m1
	Vkjp+GHTNhQOLMFKSYyFD+JmZPjAyXbaUovEsNimz
X-Gm-Gg: AR+sD12Ngh7ZG0eCrMUPtbKpgElLCeWUOVaIlxKXrxj/5+fBaMwZaAYKWuEes9PnFAj
	vx1XlpYgUORzS1FCiH7uQAi5n96nXycz8c0WOJJBl7akY0iKnjVX8sQDsbjerdxGSgXfEET6BOa
	fk2ST0j/zAfoi5I7HFiV6jmlO+pi79K7nHRkw21stY/81S/9hE3VHmBvnYq6DQNwes47TWTdSel
	gZXgS4OXIC71QrbpWlnhqeay+QW7BueruOcX1su2frskOCvYg5cIZYtHNnjw8Ny4gxaMTTJLh6W
	FswOfHI+75839rNU6nGR1uICPqsOJlbIc1mB7Dm4syvgvJk1t8l00Q==
X-Received: by 2002:ac8:6a0a:0:b0:52b:806e:2633 with SMTP id
 d75a77b69052e-52cd50fb3a7mr1807921cf.1.1785784629587; Mon, 03 Aug 2026
 12:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-5-surenb@google.com>
 <anB7shWzNHUa4poC@lucifer>
In-Reply-To: <anB7shWzNHUa4poC@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 12:16:58 -0700
X-Gm-Features: AUfX_mwQH4Pvuvudr4leJ9DstYfBHWpHm3T1TlhK6nWezd5tB43ondZfCM0sUQk
Message-ID: <CAJuCfpHMf3v4aD9CkeNJ9t5cN=8iWW1WCJsJfyzTs3xYb_6JwQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] binder: Remove mmap_lock fallback
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3182D140002
X-Rspam-User: 
X-Stat-Signature: s133xns1681ywoi31dmq4wjbss3jwau1
X-HE-Tag: 1785784631-430247
X-HE-Meta: U2FsdGVkX1/Pf4gAPG7iuoZiw3hHOSQiUtfroxj+5WT1W4/sukZoB3B3eidLMnsxCWr5yDMsjaITrqw5nkreR+KiI7fe5QDy0NmTlgBSZCZDByhouIfNtbN4MPnllV/7lztt4UlnNDQGw2st9t8wZ7IwRrQFZKIIJInYgGqMXKfjHBj3MqLxbw3jaS0jCpqKy7Ilu/jcIYBhwV0AaGGRGvzIuGmPP+Ybd90yyT8WHj3B3iSgt8iWcvJ297b+N7klZuRdq4sxRLYCPjntBYdVRqI+aEEkVdndoxu0LJ5anu0aXdDZEe85j66/9O1jJ78VuJHEp2DI9AM5fqomYlAIu7JF4bKcJ1uZXKQk5+OYCUZmxnOMS4qw9VMNoA287JHcUMpGmtzDP2E/+ew0dFMCr91H7fInpgVTTdx0LRD9E+ncfCojdEayOnlvnuD9/vvzKkFUoU6K2ipHzOCHBOXQ1emJWVMcEh8yvjryNNuId45cz0p93ID0qIipzkxKzgYdEpZhT4u0mnfPzt1Rv6SHImYDc7OeRhqzGAPYvsU7rA0hQk2jtqxs+PekBO5EjwCgPUUYZaf5eRhPG5LCfdwbmWUuQ8IncWGA1L0xv9OgEWTGgHMoOfJBp6OdOjaO+chzLgEYLrjVw2HB5yrp+h6AtaL4XOu+F45HXgTo2GI1DXxjxHJVwvlTZCi8pmSo1Vp83Qmzp0scrY66TidLqW9DF2WwsKV3M2RyvOTerbROT/Tgia48ptrlKvEHM22/fLKpnlxtKoQqP3VDRcmgwp13nMRuF9xu9XfrpzBwvafnUXbm/Gn9EoZbVwg/cMoOvAyxjJd5XyQQv48tCpAYq3xipxCGvV7y5IoMiuP/Xbb8olwuepSLkh9GSYLfrXhs0akpFvd4hMnY0SrArsaUH6xiXrD+oxPuz98eRtexa6YBQo2CD+S9Rua/4tZdy8Y6tu9CpOeZh4cjyQzx5LODDz0
 hgRsMpJp
 jezM+AN/Aj47U+hfufwVXQ/YEQ1Bp5CqhT0L1HFovMaVJC3+S7Pkn3RdwNF+GUnen8NOTZrT5E22xJUy1ZyGz4CkjhH8H59yqRAVEChtyW0P7Qkjs3s+38Zr98UgUlxvZiPEK7Q4OcXbtRZCewlDVFh0Q+9zzTEsg35xROfcb4BevmvKNbRwjw1Ds7kTpgsVk1lCYO3cJOTJwk5JN6kFZiZmgRoxE+46nR24tjmIKN3zNsa7m8msJAlc6bQgFIPlhMcAz9JhUmO/m1i/wqoy/IYdLh3kp/dBdGp+1SOBu9dF0dfiO/ng48noR9CBm1cZu8EMTjmpKEGJiNaghnpawOI37GNUJilHvrVztad0CHwDf4EUHp2la6KQfJy9ErqhmCSEzkj4NQknHHeOOrdCq9jqX3cS76bvntAdww3ToIYHx8l/IaszP4lSupNjq3xXmQei94039pknKsc+d3WoYXTw6MdWkQhVDFhZFMA0ystFLLhjqnR56HJIcukWDjxkYbEwHycNtpgJkcoOye0o+5wVYoREVYkrBR/faDJq9N9rcYElDUvtYkSl/aoYTk4T1/8XxvabFC6blXCQqVG0YPnOZlRGC1ovt7BX7oMYrZXdADLYPd+uWkeTi7wjPL+K0dpVAPDDQHKpCuPIbvD/j9L+YHvBR9mMz5aJpuNVTAh0ERHoM5Z+wCQX+ZlJ3IU7YkqyVORoIoTZLJafqcHi0UspMXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 4:33=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Sun, Aug 02, 2026 at 02:54:58PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > Previously, the per-VMA locking could fail in the face of writers
> > which necessitate a fallback to mmap_lock. The new
> > vma_start_read_unlocked() will wait for writers instead of failing.
> >
> > Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> LGTM, just a nit below.
>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---
> >  drivers/android/binder/page_range.rs | 19 +++----------------
> >  drivers/android/binder_alloc.c       | 17 +++++------------
> >  rust/kernel/mm.rs                    | 18 ++++++++++++++++++
> >  3 files changed, 26 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/android/binder/page_range.rs b/drivers/android/bin=
der/page_range.rs
> > index e82a5523804f..f7ad88a0d806 100644
> > --- a/drivers/android/binder/page_range.rs
> > +++ b/drivers/android/binder/page_range.rs
> > @@ -439,22 +439,9 @@ unsafe fn use_page_slow(&self, i: usize) -> Result=
<()> {
> >          // workqueue.
> >          let mm =3D MmWithUser::into_mmput_async(self.mm.mmget_not_zero=
().ok_or(ESRCH)?);
> >          {
> > -            let vma_read;
> > -            let mmap_read;
> > -            let vma =3D if let Some(ret) =3D mm.lock_vma_under_rcu(vma=
_addr) {
> > -                vma_read =3D ret;
> > -                check_vma(&vma_read, self)
> > -            } else {
> > -                mmap_read =3D mm.mmap_read_lock();
> > -                mmap_read
> > -                    .vma_lookup(vma_addr)
> > -                    .and_then(|vma| check_vma(vma, self))
> > -            };
> > -
> > -            match vma {
> > -                Some(vma) =3D> vma.vm_insert_page(user_page_addr, &new=
_page)?,
> > -                None =3D> return Err(ESRCH),
> > -            }
> > +            let vma_read_guard =3D mm.vma_start_read_unlocked(vma_addr=
).ok_or(ESRCH)?;
> > +            let vma =3D check_vma(&vma_read_guard, self).ok_or(ESRCH)?=
;
> > +            vma.vm_insert_page(user_page_addr, &new_page)?;
> >          }
> >
> >          let inner =3D self.lock.lock();
> > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_al=
loc.c
> > index 84104ba04e30..519dcded19b2 100644
> > --- a/drivers/android/binder_alloc.c
> > +++ b/drivers/android/binder_alloc.c
> > @@ -259,21 +259,14 @@ static int binder_page_insert(struct binder_alloc=
 *alloc,
> >       struct vm_area_struct *vma;
> >       int ret =3D -ESRCH;
> >
> > -     /* attempt per-vma lock first */
> > -     vma =3D lock_vma_under_rcu(mm, addr);
> > -     if (vma) {
> > -             if (binder_alloc_is_mapped(alloc))
> > -                     ret =3D vm_insert_page(vma, addr, page);
> > -             vma_end_read(vma);
> > +     vma =3D vma_start_read_unlocked(mm, addr);
> > +     if (!vma)
> >               return ret;
> > -     }
> >
> > -     /* fall back to mmap_lock */
> > -     mmap_read_lock(mm);
> > -     vma =3D vma_lookup(mm, addr);
> > -     if (vma && binder_alloc_is_mapped(alloc))
> > +     if (binder_alloc_is_mapped(alloc))
> >               ret =3D vm_insert_page(vma, addr, page);
> > -     mmap_read_unlock(mm);
> > +
> > +     vma_end_read(vma);
>
> Nice cleanup :)
>
> >
> >       return ret;
> >  }
> > diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> > index 2633e704c83d..877fad68be9c 100644
> > --- a/rust/kernel/mm.rs
> > +++ b/rust/kernel/mm.rs
> > @@ -190,6 +190,24 @@ pub fn lock_vma_under_rcu(&self, vma_addr: usize) =
-> Option<VmaReadGuard<'_>> {
> >          }
> >      }
> >
> > +    /// Find the VMA covering 'address' and lock it for reading. Waits=
 for writers to finish if the
> > +    /// VMA is being modified.
>
> This seems a little inconsistent with the C version's comment, should the=
y not be the same?

Ack. Will change.

>
> > +    #[inline]
> > +    pub fn vma_start_read_unlocked(&self, vma_addr: usize) -> Option<V=
maReadGuard<'_>> {
> > +        // SAFETY: We may invoke `vma_start_read_unlocked` because we =
know this `mm` has non-zero
> > +        // `mm_users`.
> > +        let vma =3D unsafe { bindings::vma_start_read_unlocked(self.as=
_raw(), vma_addr) };
> > +        if vma.is_null() {
> > +            return None;
> > +        }
> > +        Some(VmaReadGuard {
> > +            // SAFETY: If `vma_start_read_unlocked` returns a non-null=
 ptr, then it points at a
> > +            // valid vma. The vma is stable for as long as the vma rea=
d lock is held.
> > +            vma: unsafe { VmaRef::from_raw(vma) },
> > +            _nts: NotThreadSafe,
> > +        })
> > +    }
> > +
> >      /// Lock the mmap read lock.
> >      #[inline]
> >      pub fn mmap_read_lock(&self) -> MmapReadGuard<'_> {
> > --
> > 2.55.0.508.g3f0d502094-goog
> >
>
> --
> Cheers, Lorenzo

