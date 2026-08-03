Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F3DEC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8636B0092; Mon,  3 Aug 2026 15:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598586B0093; Mon,  3 Aug 2026 15:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488756B0095; Mon,  3 Aug 2026 15:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171416B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:13:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29799807C2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:13:42 +0000 (UTC)
X-FDA: 85060907484.11.2892B81
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1EC7E14000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:13:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j1xKpkH8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785784420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVJfjo5glrhbtnsH0cPaVmUOmhUGiMwC66kCF9ApoHk=;
	b=YWrVcP1Q8/WihjQxL3wZBG22fvNnLZP7PFSlstjTUZd2wj1OeLMK+Bqf+wFHKyfNDw3ypJ
	NoOR6JKzrnjSphTxzlBpnVXoF/6sIh7pcnievmDB05j6SLnaaznV/plEfccCGzKqxuNmVA
	GUpHVDdZZs2sGWBRudLFtal40/MGwkU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j1xKpkH8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785784420;
	b=BZzsaBmYLOQ9Bpi3yIso71lIx+0XXXZi1G+lpErlBBrgSdkW8w+Sbom+s+gPDHP2SucQgb
	F8gbYFAYwur8Kfy2utpMQrU7rRdU9w1NKzk/QV2jE81OKzvERsMlgQm/vNy7ph5BM/V8oi
	t41hLKH//e5iZS+qjOieNwp5R84wVEs=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c01c79467so57501cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:13:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785784419; cv=none;
        d=google.com; s=arc-20260327;
        b=Z/dkMN6hPuxlNtGPTmM8lc2LjihrLJubOsr1lQhNiQrTAhNoyIWhScqANjE9a4c2j/
         BgAVRKG/gbbOmKYhV24EquJFEJLfLDbjgMbHTriZhPIZEzSPCn3wre61I8/FlKaFdgty
         wzl/jgWhHHuvFw7nP3oG1UuQ/Ay65Vcte3/YQ5snCkpkdK1Ywb/3Ekg4iYBxXsmEgx00
         NyMfyEX0OTgHz92TfL60c9U5POnt3rNi3ztn60P/lhcNYPRFhCcJ5mnCVden3Do14bk+
         vWPwThhVS9eUxOJYakW7rJkLeQo84vuLsjeSAGPBHoZxntaKtBvBpMtWznHTuaFnze1+
         bDBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kVJfjo5glrhbtnsH0cPaVmUOmhUGiMwC66kCF9ApoHk=;
        fh=251owZLE1pCz4pds6sh39AvtiLH8kbHkoKunRUaUW/8=;
        b=SuTMo1MbYrZok1HqDgcQGBBVW8jINbB3YMTLD29OM/T5vr11G9qXx7+5IQcjSXH7Kq
         /zXURzhCP9F8Mlaa831a+7tr8dqOGXYgwBAtCpGl8yDXWcsw7BRqvIONvCeWeXYdiGQW
         IpUtsLE7byy8yfaqTuILJMVID3iE9lndNThpltBJsGC34CFJIYPyOgqCJAq0qsN/7cK8
         rq/ZtXd12lb0lWWIcFOJiJ3RPogppjfM9qcB8fXB1uoY8Arg4KmhvogqKYgjvZjfd9bV
         icyZUufARy36iPoGOKACd/OxtFL/fCl407fO8g+RgmjY4HjCz67E8pB4IR1o3xfj+Ofq
         2FnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785784419; x=1786389219; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kVJfjo5glrhbtnsH0cPaVmUOmhUGiMwC66kCF9ApoHk=;
        b=j1xKpkH8sCl8Jdl+59YIu2SaInA4Tb28dX1ZKezcIv3KyUcRcyo5G6ckF/cF6/+qM0
         8BAvGbd/+VYxoChcnPKRql9drG86duxEdRSYn0FJbAfIIpsv9up8V3JAASBkzc5OLuMV
         o7LCNBJi+Jm6EFsRY0+Sd3nsh7zhOq0uUBDO05imDvUMS2fgFHU6QauZxL25OYAQF6BQ
         vGcMAs6coCSwayb1xKqxl4JDZOU3nWCbf/oiOvYyUhpLm5i74I/mrqDvVnWrVZ15EknP
         n5sC7bRyQvPEdUkrKDGlfmYlIlimw3wud/CNMPdN5HfjXBzhNeMibaOjtTPxBPDxCbUU
         CV2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785784419; x=1786389219;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kVJfjo5glrhbtnsH0cPaVmUOmhUGiMwC66kCF9ApoHk=;
        b=carECZqrRv8SnwR7DgJKFLwiKbCEq5NWqTc2dnqimrcBK0cg0TJT7WFPLexEXHMrSs
         ZlqeUVBTSARF/bx0DYKZqH2YfkEqIpHaxZ0t+ZYXb2SOy9znSGtM6Ul5UDWLYs6i0zGW
         s0qLXHCj+Fgyud0YDetMhG5LAlTbvQ5rugB6tOYU7g5GP/sHZL9Mwl4fzjTCKRHLWZxW
         jcJ00mTVjiTjXY6y0CbXdwgP0Hs85XO0Z2fh+04LQgnrcVZ1LCYx5oAFb17IPHsqVMQT
         DzR8Ltn2E6f4mOSbGg0Njs5+DPmQ3RueRyemUEPmJPt8m7SRHR1ZKUkQs2BylZxdZJ97
         Ufeg==
X-Forwarded-Encrypted: i=1; AHgh+RpBS7DHmpIKlwd6T/ytrI7hajL8ANRhoHD101WYIDbPIsVOyRvpG8jVcgwi6rQSfGPK7h9zK4b2lA==@kvack.org
X-Gm-Message-State: AOJu0YzwF8Rrh8FqRCnFPpz6zoXbiG2VTCrnVERiMnCdK5kewe05RhfH
	TYgM7vMUcn2Oe23Kvm/nUag8710v8YbtAehJH+U6/u+DO262Xpu+/7WP9x5Rg1f0mE5/zhIvfS7
	k95KE9j0rTUC+ijGxu49NBZKYkIYezy50pMS7Lex4
X-Gm-Gg: AR+sD11ACu8rCiIRywGtAq3ygv6c67q7f3tiMIEJis2e2rHrI9jrG/ly2apBXf2wH2+
	aPE6S3FeV0LkUpo3cUfoA+Rrrc36I6duvLHiHsrRz+AB68UbZcGZytCA2rSNCDZCOhSdLMJMfXI
	6IMZx175ywnTKeEqRgMC75n39IoqWW5denqRr3HorFxTe05QrhKF2BwmkANe4ClQo9xvD9JVvY5
	TROhYhgiDyPhIwBYfl/h+R+JQRaW+Pt8+Uqk8rQxe+i8zNr/Z4tovchOuTAQ15SH2LHLKWPjssw
	HRhAWGhlBXU0LJTkBg7JItOXx8KP+RfRuJ7WWSMkK6I=
X-Received: by 2002:a05:622a:1245:b0:52c:d3a1:358c with SMTP id
 d75a77b69052e-52cd4fc8ae1mr1989871cf.16.1785784418356; Mon, 03 Aug 2026
 12:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-4-surenb@google.com>
 <152ee467-b5e4-470c-ad95-c638aa9986bc@kernel.org> <anCst8u7ybHf39n8@lucifer>
 <9c301dd5-76cc-40dc-bbab-a79559d6db1a@kernel.org> <anDBVu0PIzy7dks-@lucifer>
In-Reply-To: <anDBVu0PIzy7dks-@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 12:13:25 -0700
X-Gm-Features: AUfX_mwQxdWzx1zQARcqH0kWX7mHq63TE2aOrOqiGijIcM6ixMYrduESoAttqUM
Message-ID: <CAJuCfpEYFs94heKZn3hikYuCJU3CEHr2u1SSxXMyFQwHHAcjDg@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EC7E14000F
X-Rspamd-Server: rspam01
X-Stat-Signature: y931p8otfhgc84r4zc4155e1m659hsss
X-HE-Tag: 1785784419-477757
X-HE-Meta: U2FsdGVkX19d6MwO66NreZ55fUklsny5xVnLbUmeFEuAAzACtSxuh5vwgYOszre00Z5FJVhfhEudY6E5khDmI7rCtnvwMSsjLvOP84A/Iyt9v40ncUI5uufog2xdf2nDczUgipSaVnUrVBR+JsQAo5rFNg48RfxWbvKXrTUFaeIYRWqMi1eZwynDM+9jklR52wAGgQKMcI3Kv9hL63vWKG4DU5/r7YtNEiv8nwWN2upXju8Ed1jxoePfXMMR4MD7rJkL/92cMuYQL5G+TheHSTCR0fLRKeZwegrzRmJMcq4m/81OJuBEyyvwmAoINeVRVfVykaCeTutBAq6oOcB8NMnC7p3k7uivwL7i3POkqrC/MRMGh6RqzK4sTydekyDopHhZro4Ea2nordIVLJ32BIzaS3zGt4ItFl2OjzzNTe1KSXKuoDcBseV+EK35MoOxF8FsrE+I5YkYINoao9cxFT5gTm4+bAweN43GJtWcIZh9OrcZfrGRrHQ2E5HuBFb89UWhFCSjcaihiOA4jbjx96Tfr2v3ntQQqbVKysRrjKuGp8DAcU8xMgojOP43SaR3uZlU2+4zUOk6PJjtStaZ8rHNYGBoxqwmmJDSf9za6wcioG3HGGY2Vd4gw7Ud6Cd9JTN+P7PUETaJD0BR9E1zA1bdwuqxYuS//XnWy1U4PLD1MYQ/cQqNcN3Ed6CnoA4DTPJoOBOAkWV1Ej/6UFbRiK5ht1hEMe8FkafTnecE13mMbqBMmwMqqq6eNt7cYhwP5Kd/LbkCkmtyxgKBbAPAJ4TkxtcutUWnaOIcH4RyDS0KT536rp9UVpcLzFSfH/hQ1kv440GszKQIoh/3sAVcau6TBbgKmF5qhuSkHVHgJiRcrFHHQ90m5tjP3sYO4HT+jxaRHoqLiQ7U9Qi9+jvhKOpbTOJf1yEQxP1w1YHN2BaIxcpBNAS8hk0q/zVz+dLI/q7s/z5jfrJx9YRHk6U
 xd9wbYgF
 //unwwySdSRzWkHAQj0UyidIs7rEFyOgZU9fEO+DCeFRz/t/Wd1NaohZgAZgc4QFAW5biLj/2ASbDm5zYoILCmIL+JV862UNZklDWyt7ldQr7RdpAMZMBX+IK0p5g07fINy0xDqQSKc5TdawIAQSrR0/RBTffMaYsCfKEBCTsKFKmiHYa9Ze0tSb31HAIZjG/dVOEYawS1JR+a899vK5SmMwV1YmY+f9F0yG+OgPDvfr1L/ae4XVbxL04KDnKSycU131yDHP663nR/qhZrAgXwtkO19QtItaQq5yAJysz2Yp8OSb82iDmDlTyoGeQzMyCP4iQ8nUifsdTrThOzwO7Qgkyq+tHZHZPk3x+XEYPhOSVbL9z7nZgUZxlWeMp8oqIoJaSseVCbNmMxyn9kWwdBcCCN/DrPu6ACFq+DeD1PPRKOLI13LySPJJfbI8N9KsH0NzKByH8o+Wb5bXrb7I8KOkbAlfPB2uu9xHnfzJBImwzEb/2r1lrfj313hWoj7xse2j74So94rChWp9dV8yybUQ5KQkCvkbmQv/iyH311Wu4rW1AhhBR7l7S/OAHk5wCkSmf41q+xfJqooln4XvmuonTinReJBZFf7X6Mw5M35Bv60oiRYaKCuK3irC904h8dDVTjMBInLVzclhNzOZ3komydHVKNctES+vc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 9:44=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Mon, Aug 03, 2026 at 06:24:34PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 8/3/26 17:00, Lorenzo Stoakes (ARM) wrote:
> > > On Mon, Aug 03, 2026 at 04:55:19PM +0200, Vlastimil Babka (SUSE) wrot=
e:
> > >> On 8/2/26 23:54, Suren Baghdasaryan wrote:
> > >> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > >> >
> > >> > =3D=3D Background =3D=3D
> > >> >
> > >> > There are basically two parallel ways to look up a VMA: the
> > >> > traditional way, which is protected by mmap_read_lock, and the RCU=
-based
> > >> > per-VMA lock way which is based on RCU and refcounts.
> > >> >
> > >> > =3D=3D Problem =3D=3D
> > >> >
> > >> > The mmap_lock one is more straightforward to use but it has a big
> > >> > disadvantage in that it can not be mixed with page faults since th=
ose
> > >> > can take mmap_lock for read, which can deadlock when mixed with ne=
sted
> > >> > page faults and parallel writers.
> > >> > For example:
> > >> >
> > >> >  mmap_read_lock(mm);
> > >> >  // Another thread does mmap_write_lock().
> > >> >  // New mmap_lock readers are blocked.
> > >> >  vma =3D vma_lookup(mm, address);
> > >> >  // This deadlocks on mmap_read_lock() if it faults:
> > >> >  copy_from_user(address);
> > >> >  mmap_read_unlock(mm);
> > >> >
> > >> > The per-VMA lock can be mixed with faults, but they can fail and n=
eed to
> > >> > be able to fall back to the traditional way.
> > >> >
> > >> > =3D=3D Solution =3D=3D
> > >> >
> > >> > Add a variant of the RCU-based lookup that waits for writers. This=
 is
> > >> > basically the same as the existing RCU-based lookup, but on a fail=
ure to
> > >> > lock it temporarily takes mmap_lock for read and waits for writers
> > >> > to finish before locking the VMA, dropping the mmap_lock and retur=
ning
> > >> > the locked VMA. This has some advantages:
> > >>
> > >> Maybe mention that the helper is called vma_start_read_unlocked()?

Ack.

> > >>
> > >> >
> > >> >  1. Callers do not need to have a fallback path for when they
> > >> >     collide with writers.
> > >> >  2. It can be used in contexts where page faults can happen becaus=
e
> > >> >     it can take the mmap_lock for read but never *holds* it.
> > >> >  3. Its fast path does not require taking mmap_lock for read.
> > >> >
> > >> > Basically, when applied correctly, this approach results in faster
> > >> > *and* simpler code.
> > >> >
> > >> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > >> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >> > Cc: Suren Baghdasaryan <surenb@google.com>
> > >> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > >> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > >> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > >> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > >> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > >> > Cc: linux-mm@kvack.org
> > >> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > >> > Cc: Todd Kjos <tkjos@android.com>
> > >> > Cc: Christian Brauner <christian@brauner.io>
> > >> > Cc: Carlos Llamas <cmllamas@google.com>
> > >> > Cc: Alice Ryhl <aliceryhl@google.com>
> > >> > Cc: "David S. Miller" <davem@davemloft.net>
> > >> > Cc: David Ahern <dsahern@kernel.org>
> > >> > Cc: netdev@vger.kernel.org
> > >> > ---
> > >> >  include/linux/mmap_lock.h | 15 +++++++++++----
> > >> >  mm/mmap_lock.c            | 29 +++++++++++++++++++++++++++++
> > >> >  mm/userfaultfd.c          |  6 ++++--
> > >> >  3 files changed, 44 insertions(+), 6 deletions(-)
> > >> >
> > >> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > >> > index eb32b482434e..fdd8f5cf5722 100644
> > >> > --- a/include/linux/mmap_lock.h
> > >> > +++ b/include/linux/mmap_lock.h
> > >> > @@ -228,10 +228,12 @@ static inline void vma_refcount_put(struct v=
m_area_struct *vma)
> > >> >  }
> > >> >
> > >> >  /*
> > >> > - * Use only while holding mmap read lock which guarantees that lo=
cking will not
> > >> > - * fail (nobody can concurrently write-lock the vma). vma_start_r=
ead() should
> > >> > + * Use only while holding mmap read lock which guarantees that vm=
a lock is not
> > >> > + * contended (nobody can concurrently write-lock the vma). vma_st=
art_read() should
> > >> >   * not be used in such cases because it might fail due to mm_lock=
_seq overflow.
> > >> >   * This functionality is used to obtain vma read lock and drop th=
e mmap read lock.
> > >> > + * VMA can't be detached while we are holding mmap lock, therefor=
e in practice this
> > >> > + * function can fail only when there are so many readers that vm_=
refcnt overflows.
> > >> >   */
> > >> >  static inline bool vma_start_read_locked_nested(struct vm_area_st=
ruct *vma, int subclass)
> > >> >  {
> > >> > @@ -247,16 +249,21 @@ static inline bool vma_start_read_locked_nes=
ted(struct vm_area_struct *vma, int
> > >> >  }
> > >> >
> > >> >  /*
> > >> > - * Use only while holding mmap read lock which guarantees that lo=
cking will not
> > >> > - * fail (nobody can concurrently write-lock the vma). vma_start_r=
ead() should
> > >> > + * Use only while holding mmap read lock which guarantees that vm=
a lock is not
> > >> > + * contended (nobody can concurrently write-lock the vma). vma_st=
art_read() should
> > >> >   * not be used in such cases because it might fail due to mm_lock=
_seq overflow.
> > >> >   * This functionality is used to obtain vma read lock and drop th=
e mmap read lock.
> > >> > + * VMA can't be detached while we are holding mmap lock, therefor=
e in practice this
> > >> > + * function can fail only when there are so many readers that vm_=
refcnt overflows.
> > >> >   */
> > >> >  static inline bool vma_start_read_locked(struct vm_area_struct *v=
ma)
> > >> >  {
> > >> >          return vma_start_read_locked_nested(vma, 0);
> > >> >  }
> > >> >
> > >> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *=
mm,
> > >> > +                                               unsigned long addr=
ess);
> > >> > +
> > >> >  static inline void vma_end_read(struct vm_area_struct *vma)
> > >> >  {
> > >> >          vma_refcount_put(vma);
> > >> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > >> > index e20d01e8d38f..6ff05e68e61b 100644
> > >> > --- a/mm/mmap_lock.c
> > >> > +++ b/mm/mmap_lock.c
> > >> > @@ -338,6 +338,35 @@ struct vm_area_struct *lock_vma_under_rcu(str=
uct mm_struct *mm,
> > >> >          return NULL;
> > >> >  }
> > >> >
> > >> > +/*
> > >> > + * Find the VMA covering 'address' and lock it for reading. Waits=
 for writers to
> > >> > + * finish if the VMA is being modified. Returns NULL if there is =
no VMA covering
> > >> > + * 'address'.
> > >>
> > >> Hm but it can also return NULL when vm_refcnt overflows, in theory.
> > >> Should we also return -EAGAIN (like uffd_lock_vma() below), or just =
retry in
> > >> here and hope for the best? The latter would be simpler for the user=
s.
> > >> (AFAICS due to VM_REFCNT_LIMIT we never end up triggering the refcou=
nt
> > >> saturation)
> > >
> > > The problem is everything's unlocked so 'didn't find a VMA' doesn't r=
eally mean
> > > much more than 'something went wrong' because hey maybe if you check =
again now
> > > you'll find something :)
> >
> > Well there might be use cases where you know that either there's a vma =
with
> > your address and then you need to do something with it, or there's not =
and
> > then you don't. And it can't suddenly appear after you check.
>
> You don't hold a lock that prevents new VMAs appearing/disappearing
> spontaneously at the point you call lock_vma_under_rcu(), or after you dr=
op the
> mmap read lock, only that at the point of checking a VMA spans address, s=
o
> there's nothing preventing a VMA suddenly appearing after you check right=
? Or it
> not being the one you wanted?
>
> And checking to see if it's 'really the one you meant' is itself fraught =
(see
> the whole uffd saga on that).
>
> Point I'm making is that in any case where you'd actually care you'd need=
 to
> take a stronger lock anyway, so it's actually potentially dangerous to
> differentiate between the two.

Yeah, I tend to agree with Lorenzo that  when lock_vma_under_rcu()
fails, we should not make any assumptions about the reason because the
range is not locked and therefore is not stable. Any assumption risks
being wrong if a race occurs.

>
> Given the overflow is very very unlikely I think it's also not a big deal=
 to not
> differentiate anyway.
>
> >
> > So in that case treating that spurious NULL as "there's no vma so I don=
't
> > need to do anything" would be wrong.
> >
> > The usages in 4/5 and 5/5 seem like they are not this case though. So i=
t's
> > fine. But perhaps worth just mentioning it in the comment then.
>
> Agree this is worth spelling out in the comment (I raised similarly).
>
> Maybe something like:
>
>         If a VMA exists which spans @address, return that VMA, read-locke=
d.
>
>         If no VMA is mapped there or, very unlikely, a reference count ov=
erflow
>         occurred, return NULL.
>
>         Nothing prevents VMAs being unmapped/mapped before or after the V=
MA is
>         looked up, if a stronger guarantee is required, take an mmap lock=
.

This last statement is true only if the function returns NULL, so I
think it should be in the same paragraph as the "If no VMA is
mapped..." sentence and prepended with "In this case...". So:

       If no VMA is mapped there or, very unlikely, a reference count overf=
low
       occurred, return NULL. In this case, nothing prevents VMAs
being unmapped/
       mapped before or after the VMA is looked up, if a stronger guarantee=
 is
       required, take an mmap lock.

Does that sounds good?

>
> >
> > > So I think this might be a feature more than a bug, especially given =
overflow is
> > > not exactly likely.
> > >
> > >>
> > >> > + *
> > >> > + * Use only in code paths where no mmap_lock and no VMA lock is h=
eld.
> > >> > + *
> > >> > + * The fast path does not take mmap_lock.
> > >> > + */
> > >> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *=
mm,
> > >> > +                                               unsigned long addr=
ess)
> > >> > +{
> > >> > +        struct vm_area_struct *vma;
> > >> > +
> > >> > +        /* Fast path: return stable VMA covering 'address': */
> > >> > +        vma =3D lock_vma_under_rcu(mm, address);
> > >> > +        if (vma)
> > >> > +                return vma;
> > >> > +
> > >> > +        /* Slow path: preclude VMA writers by temporarily getting=
 mmap read lock. */
> > >> > +        mmap_read_lock(mm);
> > >> > +        vma =3D vma_lookup(mm, address);
> > >> > +        if (vma && !vma_start_read_locked(vma))
> > >> > +                vma =3D NULL;
> > >> > +        mmap_read_unlock(mm);
> > >> > +
> > >> > +        return vma;
> > >> > +}
> > >> > +
> > >> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struc=
t mm_struct *mm,
> > >> >                                                              struc=
t vma_iterator *vmi,
> > >> >                                                              unsig=
ned long from_addr)
> > >> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > >> > index edd90892f8cc..c3a0c38a3dc3 100644
> > >> > --- a/mm/userfaultfd.c
> > >> > +++ b/mm/userfaultfd.c
> > >> > @@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_a=
non(struct mm_struct *mm,
> > >> >   *
> > >> >   * Should be called without holding mmap_lock.
> > >> >   *
> > >> > - * Return: A locked vma containing @address, -ENOENT if no vma is=
 found, or
> > >> > - * -ENOMEM if anon_vma couldn't be allocated.
> > >> > + * Return: A locked vma containing @address, -ENOENT if no vma is=
 found,
> > >> > + * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma r=
efcount
> > >> > + * overflow happened due to high number of readers and the caller=
 should
> > >> > + * retry later.
> > >> >   */
> > >> >  static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
> > >> >                                         unsigned long address)
> > >>
> > >
> > > --
> > > Cheers, Lorenzo
> >
>
> --
> Cheers, Lorenzo

