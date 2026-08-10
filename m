Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269C1C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090CE6B008A; Mon, 10 Aug 2026 12:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041806B0092; Mon, 10 Aug 2026 12:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72896B0093; Mon, 10 Aug 2026 12:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B593F6B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:41:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EE76120231
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:41:07 +0000 (UTC)
X-FDA: 85085924574.18.2936640
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3F8B3160009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:41:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="nliu/zTn";
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786380065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m17UbQGMqxi7cFAb0MblsfMgzscucpvWwE8sKi+3QSo=;
	b=ZT7O1Q7uKdBZzQO5Urt9e1uOAFUUb+5ahlyzz82irDsWxVj1R3FqdMf0a4/rTWfhdgbHOw
	tVFdXBvva+zxZtWUwI0hHan1JD8J3FOxqT0r5I2AjGsxtuCVZOXgwT6BFpe9JAxiS0/gA/
	W1mbIeMzFNLgd2jRDZXk9bAcoDGQVdE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786380065;
	b=YNZyA4a2gqNCIQA5vItS8unYf4a2H4TxrzzAWuK5T1YlklB/TxuT6VZvkCQwl5rFxzTwxm
	dmjfyISyF/wuMQemCFUdo+VWNMBzdElE8cOscShUm8qF5U7fXNgNnNshJUImUbRse6cVTP
	s7pYF3XnM4sLD44jApYxupTPIkTs53M=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="nliu/zTn";
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c10ed63c0so395301cf.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:41:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786380064; cv=none;
        d=google.com; s=arc-20260327;
        b=SEcJf0gclSLc7+S3I1ec/3Bna73S4B3K5NyItKLBhX+Zftjr17lQ8OOCQeDF2+eUl2
         HcDYg/2VhtZ6bBl7/eM+rn1CNpD1hX4NCKehbl6NM8YMafsBW1fEOTTDI7VhUoxf54+O
         jN2IkI0eiepB38KhMrUBvSUmMU1z20xxB/Z2Uz7EadFfqQBHcvELq2CPsaJYb5+dXYE9
         33cINDwK6CnwLp8I75UzyHfuCyDgkPHiKkaPXNT8melFVlq2z7t5VJbRj5o7qywhXkwm
         JIjJfbJDp2OzYofWspii/gqMPlD0LBQ2v4uoS+ZuHO/popvaBRRRM4CpVIaphH+YbyLr
         SULw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m17UbQGMqxi7cFAb0MblsfMgzscucpvWwE8sKi+3QSo=;
        fh=kYNGztEBH/FGeR9znkAZNQoLV15jNtPB5rpUyTv4Gzc=;
        b=cSKUVr1x7Zqa4DYOm3GcBt5tKXsuDVBsq4cthg9jRKwIh1MYxrQocTPtCn3wT+iRc2
         Sa2kMv0sx2na8lNjk0vLU/IDiQgKfxEX8KzfWJJMMznQtVM274SDoDU2J/VEo4c8Nf0C
         9H51KphBVQOpGsNjFZzL+TYRWE+HlfHJMRTv1kwhxaf6CEtz/tLU7a/S8Iq2cU1+nJr8
         KA3wHsbF1+is41GYuZnBP1s1K8fAWPXqroED33MxgSy6l/2VMX04s1f5vJTcoUKEFFwP
         crOarcd2PYoUZww8Y66qem5Bs+dlLBCiena12wjjWRQlcj5QgbpYCwzEfJLq3QJoStmV
         nNrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786380064; x=1786984864; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m17UbQGMqxi7cFAb0MblsfMgzscucpvWwE8sKi+3QSo=;
        b=nliu/zTnS0XzS3Ll0HVuME08sN/3ZDeBnQznPPMid1plAzboNd+eSZzkAXqRRg6E/W
         8OCaMQrsmD/Lonef9IdZUcL7f1Vida9G+BCiY15wnvDvBV6cK3GahRj2aLPL/yBl928T
         DCDrscUTzqOqAfQYmtCecJ0UMVXnA3PJizi4IG/IjSMTB4sWxuQI7OODFv/Fu8CCL1HV
         gLeVK9haKw4MnfWYQ9qlzmSydJRN2Nn2p2HvCfUftf6BeOixXu72kWkomGboZZ6C3UXd
         8KJHSbqS2BbkuaxyV6GJ5a+Mw/6+lKoBswctZCKuiyjUD5Vtd7cFxTBBQgveghXzPc9/
         qdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786380064; x=1786984864;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m17UbQGMqxi7cFAb0MblsfMgzscucpvWwE8sKi+3QSo=;
        b=FXxv7ePFTp5WVcg0LHwVinB/jQLZSkz7cIJZTiusFhFEJA7PW0AAZ4NbJrJmpZKHpU
         mU4AiwJ0HOKt0GML9f7yiAqAdNYEo+Enzd/DnfGseR6ZXt3LaAOONbD9qrpUZRBf9/9I
         EGn3PqjOPYaQvuUeySc69Z28xObKPe6dWTqbceWL4CcmNJKoMa/Ngu9XMrfyFOXY9I9I
         +VvXLyBANIYeHBxues4ZcDjQqKF+4GiO7Jo4Pi9zmH5LSlmULLN1cjrnEVpb9w8dq6Hq
         jfmx7/qhgT2pblAXLinWjFRbgdyEUWcKHipabeJuW3+RH3INO5VPU4HH/JbM+vIcTLhP
         YB8g==
X-Forwarded-Encrypted: i=1; AHgh+RqNDqxOEHJYaQVLkcBBT7C+s1RcwZCjU7C+JHSzFo+Zhl7AXwMf99D+LfgLBfI9wFvZpM1qA7f4kg==@kvack.org
X-Gm-Message-State: AOJu0YxCMCdcKdWyk0MODUAhj1VdswV9UoeW1B5Ahoc6L/LAd5VTSqfe
	msoZw7ye8sxvq4T2UlXjoqOkRGF4n55c+aDUaPg5S5xDlkb+4mJyTd8D81zIR/T7qFAWO0Cdl/r
	LlSnPxbWF4q4c43YSSAwOL8EllOEc525rlhuABR13
X-Gm-Gg: AR+sD12U9hgVluu1VsK7L0YBYgD8/PZgPf2WH2CuYKXYmWe72BkHTZXrcnxOz774GL/
	/VmWCWM20PFTScnJ7wCH2RBNG0h7mB6ffEdk6/rje3vl0VcaZAUJtDC5Yd1SzC80lc83Ry0Ag5B
	2c8Bj+3mNfykJj++GbN1fwL2GEZRMnDh6i0UuLmOMMpbK4zJ+3uN17E9rOjay6qyM/crPM8AGo2
	1gf9juKl4OxZqcikiOAzbBAbeuQY5Q7dRF7/qv079BrvONB8LZTtuDVX43IvcMB3dgPvf1bawLJ
	rz9N6p+KDvutP5Xra7Deunm75XdR2UUkwceADeHornc=
X-Received: by 2002:a05:622a:4a8a:b0:528:38d6:71b4 with SMTP id
 d75a77b69052e-52d28159aafmr36460991cf.11.1786380063820; Mon, 10 Aug 2026
 09:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-2-surenb@google.com>
 <anaCkrk55EQoE2aS@casper.infradead.org> <anmQIeQIGkZdCKVU@lucifer> <anmcwYilggkd_-B5@lucifer>
In-Reply-To: <anmcwYilggkd_-B5@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 10 Aug 2026 09:40:52 -0700
X-Gm-Features: AUfX_mxHsauyQeZO29u25G5ulMG58oqaTVi8Qutjp1dLMmIvZ6xLXUZCqjxNRn0
Message-ID: <CAJuCfpHngcCttUaUtAJVxF5J4-WGGscx+mEu7LPqd4K61kLOdw@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@kernel.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F8B3160009
X-Stat-Signature: r66gzzf9cmksb6zqbz7xxtckzranmfqn
X-Rspam-User: 
X-HE-Tag: 1786380065-803717
X-HE-Meta: U2FsdGVkX18uRghZaMjOMgpH6+5SqnJsbT7lGVUny36/9iVgJsChQkKKa0qd4kRQ8J6uOypNakQiYtq4GW1YZKhAxvBhuWr4gWMxZwroBjbIKAWkQhhfsM0hUlemOZ+6EozJ2KmJa1+ALkiKGTGO69weVdZcXYais6CXj1RzJiJ8vvmjXwn40HwRrqtZbblE3El36owZK/KNRnKSQ6baCmXzYQO5MAJ5kTBsttS99Kfp67AO6ULG0/tmlGwDzzTCDqU5tFISHKLS+Z7GJP7IQtHc6EqxAZfcJ4DMnykTELnsEh02nZFMen8sQFykUV4LSnxUN/InPLKBLhj/3SVAwca3i5teGDlVcvg3vP1zuxseckb9Om3BsMAztZImXOibQFu9VcxSGC/4DRW73z1UUtMJ8Cotk3Z+rscsqbyKNqSNZ/ebawcLMBS0G/9LoUgbsQE4s/2X+PkPj75OjxV4fSST40OMnqGo4kQO9h987ZyQfhzMbhZOdi8ZO19T5BGKuxQS2y8I2pCu3tgubb8Yr7t06waW5/4tKRrZ+2/JzzX/8m5VGKDZXOsDf4ZGBuYviFREBvEPh1lnOvUNTCpFmyEZpRaKqtZa0Qz7v+1xHnjLdxkaNTSitHAh5tO2Z/N3kQt7or7gkUZC8HHzwbZHHz5PTpzlnzKokHuSuHBU9FvHp3SlEeJdzXYSEaOI8KxokNEjr0AZRtQW0P1AgvSsnk4rpR/TwwC2Q5dX73ZWAfKH7gqz6sw9ati3DNgG27gNRcXe2EzHDJ+SaQxBj71Two9arbXzQKw1Y1yczUOC7nxy/tcoQhOHLeqGyBVDrxdhCyWki9Mh7FCDNGD8j3eW8kppmOkPILhqJNSpBHKdPcS4AbA+JhyjIIVENEHSjQ+ad4ftWd6YoQkpZAWEL2H8heEZYUkv6WSzcMpiu6oV9SscoZpkRHFEn/4i+Vibp/aK0/G6SDQeCciUJE/PGRt
 bftBWcsJ
 1uYKOeT4ydiSAiu6FGe7/2JaSjoljiCNWJByRdTwEeY30XR8K3TcUgfMaeQbPZ7eupfOHIsjMlW0LeoeJLYNjpmR8OiVyuQ1/L5ZjXxP/ks5MZUw34/Q2NRfQx7PJrNplv9KY796kdCk/PZ0qQ3TVaSKbdNbzniZfN/jJNVskE1ZED4zVZx/vvZpeAvMiK2PQi/yxzAtq6CeRnN/RGP45Hc+18BdmqpHA/ZgW50fz/fDsR6seB2958PwLgGetpwSCFBVr22z2qE8vYWjuCmRjjkUK9A/rwVC6kSitLTcW+tFTvqWB1vz1rX3wvZsboM00HfxI5mZ0ApcKLCriEKemqJm9xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 2:43=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Mon, Aug 10, 2026 at 09:52:11AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Aug 08, 2026 at 02:12:50AM +0100, Matthew Wilcox wrote:
> > > On Thu, Aug 06, 2026 at 01:05:44PM -0700, Suren Baghdasaryan wrote:
> > > > +++ b/kernel/bpf/stackmap.c
> > > > @@ -272,13 +272,8 @@ struct stack_map_vma_lock {
> > > >  /*
> > > >   * Acquire a stable read-side reference on the VMA covering @ip.
> > > >   *
> > > > - * With CONFIG_PER_VMA_LOCK=3Dy this returns a VMA with its per-VM=
A read
> > > > - * lock held and mmap_lock dropped, so the caller may sleep.
> > > > - *
> > > > - * With CONFIG_PER_VMA_LOCK=3Dn it returns a VMA with mmap_lock st=
ill
> > > > - * held; the caller must snapshot any fields it needs and pin vm_f=
ile
> > > > - * with get_file() before stack_map_unlock_vma() drops mmap_lock, =
as
> > > > - * the VMA may be split, merged, or freed after that.
> > > > + * This returns a VMA with its per-VMA read lock held and mmap_loc=
k
> > > > + * dropped, so the caller may sleep.
> > >
> > > I don't know if BPF is compatible with !MMU or not, but the comment
> > > is inconsistent with the code.  How about:
> >
> > <requisite nommu rant>
> >
> > I do think there are components that simply don't think to depend on CO=
NFIG_MMU
> > even though they do.
> >
> > In fact more than think - have run into exactly that before.
> >
> > It's another thing that speaks to nommu being a legacy barnacle that ba=
shes us
> > on the head fairly regularly for little to no gain (and nobody is testi=
ng it for
> > tip kernel AFAICT).
> >
> > </requisite nommu rant>
> >
> > >
> > >  * On NOMMU configurations, returns with the mmap_lock held.  If the =
MMU
> > >  * is enabled, the per-VMA lock will be held instead.  The lock
> > >  * should be released with stack_map_unlock_vma() which will release =
the
> > >  * appropriate lock.  Once the lock is released, the VMA may be freed=
.
> >
> > I mean I suppose it's accurate but I don't love the idea of essentially=
 implying
> > nommu+bpf is a thing and also treating it as so important that it must =
be called
> > out here.
> >
> > I'd rather it be inaccurate for nommu as are most comments in mm and mm=
-adjacent
> > components, it's kinda implied in general. Those who care can look at t=
he code.
>
> Actually scratch that I'm wrong, firstly Suren's series explicitly does s=
ome
> nommu-specific logic in the bpf code and secondly BPF already has nommu-s=
pecific
> stuff in it.
>
> It seems nommu bpf is (kinda) a supported path.

Ok, I'll change it the way Matthew suggested then.

>
> >
> > >
> > > >   * Returns NULL on failure, in which case no lock is held.
> > > >   */
>
> --
> Cheers, Lorenzo

