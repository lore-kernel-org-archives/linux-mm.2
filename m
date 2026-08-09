Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77557C5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 00:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72F06B00E8; Sat,  8 Aug 2026 20:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49336B00E9; Sat,  8 Aug 2026 20:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5EF76B00EA; Sat,  8 Aug 2026 20:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 735556B00E8
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:52:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE95216046E
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:52:12 +0000 (UTC)
X-FDA: 85079904504.20.0B0590C
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id EAC6E1C0003
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:52:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rjWMc+rA;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786236730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4liCDh36/+ZyZXBwFufBk0+NwnQDPX73vt+RUacM7I=;
	b=06tYr/m4Tiwi0jucENTJuYbUZvafNTxt+io9nl1m6CO42eF51+H/MEbPeTljXqR9KGbRBn
	WY/CjS2m6HVeMPG0ezZMerohRRKXleC2xWggEv+lXV4zFFQccqmSqOmh+8dnfw0/8Q5r82
	Zby9cX2DcVJB7BiPoXHBINDAQqkxAX4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786236730;
	b=rOQWRren8C951vkTe2GKHQRt5z0ENwvB3ZYWCm+TqG+aLoYzNvLZtU75XRvR+uVasdbjVi
	7Hvk2elgJSIQKVm4bT5drJWnQ2IWJpxm/QvHLvo/kkgXnZ4vcZImZgX9snjuGyPzML5WSt
	l7XUrRcMsIrz/lKjHYXz1ZTMv8lVmiU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rjWMc+rA;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c10ed63c0so123471cf.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 17:52:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786236730; cv=none;
        d=google.com; s=arc-20260327;
        b=Z9bIfDb+EeIhxt1srw7g43b43PSoUMVelQcwJChwSF231UPOGzCCqGQ1p3uOzMcqiG
         vF/YFuQjrfAncNaEGQU9ve5g2UL+d0PF067dU15bGDGeIHNBiY3P71C5hISLRBpnej67
         gjC5ObsZ/zUO2cPBbY0eBZHh+SU4Ihm0/u47dWR5wQxGbr51JX511LX+RKaUDqm9X1Ty
         zSSlMAGRjNnt8sbqWuKPlE72QUsaNTpnASVY06bpRBKNj5f+PssFiPHBupBT5RXOswvP
         oCI3oqn0T9T1V44GzLDTo2lsYLXx9MdrQXnLWaPq+pd7lXWgyXWUKcpqy+zuihShLZzj
         i5vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v4liCDh36/+ZyZXBwFufBk0+NwnQDPX73vt+RUacM7I=;
        fh=mB5WPff/seAr84CuYRMIWBQpT1vBJcGQAPwV5rdFKRU=;
        b=CdPD4414jGjN7Tov0IbM/1R2BY9VES7LmpjKeyUnbK8i1WO9xVRkMFFLMU1DT0kpVD
         d3HnSpFaAGj+WNnr7qmrAt2ndP5iHrr/NNOfRXDObw5tKYsYVjvipayhP7IYWs1pHSsw
         T+cM3vvz8/7mbigmDch/li9ZlNUmpSY6l7v1krn3VMVa2+01zwmSLwLK/WIoM9EXWvgs
         KR9SSECNdPZuS9eE2J4aFu3fdETetpT5+XMWjNovhtdiuhPfg/WvTEDLy5PmvYb48+Za
         KVodmBGYZa816hcN3O+F28scxlqi63XDDzO+Q/NjOgTQOkpmzHzmCBklsbJkKtefwkZQ
         invA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786236730; x=1786841530; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v4liCDh36/+ZyZXBwFufBk0+NwnQDPX73vt+RUacM7I=;
        b=rjWMc+rAfA5VGS8lNWb7ViO6ojGoWvBwxAfB+QBftFjptWH9cLJNMJsoM487+CO3FL
         e5Mk/rx+pxi2D2WGu1c/YmKS96vGqBWhKi3c0zC0pQOKTkaXSFj7OedEnNwZVqMOjxAz
         gOHT8dS2g5bSL9WTI47/tzK5kaxjbek2moKkMcWxmRgPDOysvQHY09Ox4ETQzOFkda4b
         cR34H41qRI833ZIVoPzqonzxNpAyU4htwdx8P0rvKnB1ogWxhSGlTQ9iCubYmn17Omeh
         RSDc54LNui7omnvOmyf79tFZYegwNllGnUmAVEoSLQyYafk02vSDTk8nBdaGkBci9Hym
         8ieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786236730; x=1786841530;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v4liCDh36/+ZyZXBwFufBk0+NwnQDPX73vt+RUacM7I=;
        b=cCTvFnTU/O4MPLrPWOz2vU1hulCtPWizJ76jGaz6ri+3v30giCyx2PWmo56Xbx3lVt
         Tdd4Q9oiLHlcIx8EwPD8S9O+Sfvm7013HGa/wdRROggx/8cb+H0qra539TM5H+KRcfah
         E2wn+IBMSQYZa9CJ/X4dGGaAQP55lXPGOKuivQqalkkMykL45fnH8Fe6pouiQwAhIZSU
         pkvkw9ZAfoLK9lP6ngSfwpmVZ5M5JA4/TD13LG0k2ZwwTIaiJONx0PDcqbbzlpVGnTzl
         X4J406OozHn5nu/5UNZc7Xwz8/qpN2rDOQAJ2rfcGDdtnVqTHJPqZ7bgJficy/NrNzPM
         dgYg==
X-Forwarded-Encrypted: i=1; AHgh+RrpMdag2pWGP7Ce6LPnxBFVClL/xk1y2WwGdumGQo9tG3r3wQAstTyUeKLYzgGphw2IJ4vm4CfNuA==@kvack.org
X-Gm-Message-State: AOJu0Yx698QZZ96NqAgKakMswZyht3EHxGrWKuDnJtSbZvHiDm+Um6cD
	5RWLCX61KkG3X9NDnV1N7U0M64wCwKuiCEAKRq61F6W1QSJoH/ROnRkJ7E2UtYSpwPoSPVd629r
	wRs4HRSLfJKm4pY/P+y2jqVA8lddhRAO4zH3BbXYT
X-Gm-Gg: AR+sD136MSEDtRIwLoRKbgi4vLjqTexBmpV9+4u1wXB69acmVPdO8R9XmXDskA6QhxA
	0+ypacXeTIWlCFJTDFuBwpZaz9yqHCbJSzl9u+6DxGSECtaeu+ewaFOqbxdLduHWBmgEAekjlx6
	w1QTuT/kVlDfLZ7kVX5aweVafB8Eh6IJJjiwk+v9znLafw92gfpg4K9C8lnEtyroGgkPP/ygcD7
	zlWQW0XB0LZ6/IrnsWljhD5/1wjz1VyIjcaVITl8T01J85h6V/oJ2t/6k+HuKXMOFpOZkA/fNW6
	JaTlsgbVOOaoqgx+OKr+Mh7vDTx2t3RpzEc7RGVRGWxVGUT9qVZzKdk=
X-Received: by 2002:a05:622a:1f12:b0:51c:6b7:d3de with SMTP id
 d75a77b69052e-52d2810403cmr12830401cf.5.1786236729475; Sat, 08 Aug 2026
 17:52:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-6-surenb@google.com>
 <anbaJuYXEoldvtPn@casper.infradead.org>
In-Reply-To: <anbaJuYXEoldvtPn@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 8 Aug 2026 17:51:58 -0700
X-Gm-Features: AUfX_mz0H2dhrc0_RWDLxxG1OQBtlVHwDKim8LfHEsvh69mmXopyqhXcVVjfQFo
Message-ID: <CAJuCfpHh1E34LVTd=4y8m+2ugGABc3MSU2Z5N4pFY4ttH0a5Rw@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] tcp: Remove mmap_lock fallback path
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EAC6E1C0003
X-Stat-Signature: pj8jjgu6sm9n1zf8pw4x5ezckf6794q9
X-Rspam-User: 
X-HE-Tag: 1786236730-184086
X-HE-Meta: U2FsdGVkX1/6FnkN72M/P4BuVJ3wzXsxW5bX7YLDa/JKzw51rLGC2v6STjd+gmK9sDODEQA4zVHKXFBP+jbcarMqPkLsWsYrQBC+7dLulUxCf+0voCxDdNTHqHhnGLzjlD2KYRdZ42VGw7bek9xbfbJi6KVVfNGHwqbKd5dNlUVY4Zpi7Ij683Tg8pifltiABfURxMYyUNi+mBdk/6fMTYPNuB4BGgYJCzV2U4+mWfBRJXPlyJHZECSwHdt00xsgC/KFn9Q6Z36wblT8xvRDH3ZmPptvIXlSRYgD3z7uFYFizuqK/puQbwVe/zohB9QVV1KiwoP5X5ow0biTPQoAX4HoJAIRR8iB/7Di33o5DCUoo7uhnsWWK9dOyNiZGwwCG5Pb34PFB6676lT9iTsfw0RJDa4D48iOk5OAgB/gu8xD+goqK4Xw2VIUhA/3bP8ApXC6lc40VOp4uA/dyoR9g7mCn0GAJ8ioc+FKZKjdjZGq9RRgU72S9FG3blXbDt/6QXJVZS77+8a38h8FVh/zBXDUuLJpjmM8sp72DP4cUhRRu0vzJpB6p9Le8mr0S3/FbKLzrjUhX2kAs2glyd5+Rx73FZLq+94gK6LRxRvb6NxoIG4zjvFjPlMbekB/xEu+WV1OXbghy2YuFtyOug1v+OJgBZRiBMyOaB2EYUOqATvzlUq4QCNdR7e64ciscNuEHa2yU+i0RgvKX6WjLjguwSlXZXDNeG+xTARx8tZINwS77TzVvYsDrR4LkjmUfm/DvsJ4QWNLq0PNmv5+VKUrWvLcyy/p8g6b29/qN8/Pt/y8XHgWnoGz92hcIbyUYc+ER9f7oz1IVgjG+lzQmYnXF4w5zZy5RBl4jY6skcleDTlhN7yANYspmpjtnO7z/8bgcp80fxSbYHwdHs6mL/6lnir0OeFjWSVIxREbiNRBpc1uwbfEyDSmwPfMsPIJ1iVJBIm+goSW7kfjOBq0MR/
 fWWYu3ci
 nadA79D8VC4Gc+66ir9AX8fiVvWUEBVhll91Kdy1185g9HPVzZS4yiqfVJ5Ek3cN1f6Q4WPyJKvyQJ+Ug0RZhp03l41tL0WRe2se1aWWMI42vtOa6bxani8rpBJzdX8GKI076Q3N61eYPD/4PzXekG2YRMPIwklIfa4/gCv3ivdvzoi3XDRHFV0+Eq8ZyJfNnBsP5/u8kuD26eaIOLXhqeeN4vyEN0Emh8rzo7OOBvxNbfL4/DUym8S46c+p3oQfLY8J52sOJMCKv/4y43DY7nOxiYTShthKlK4mSubBsB+4QnfA0g7RxBBpSUa2HlVTsSQcufqlz8+5kJGMi7fWoZ+IooUs4LUnXofbEFcWC8XkjV+71+OFT7EpiaK8Vj95NzDouudIgJmIuZ1qdyrQMlJfied0FA/bDIkr4pr8w+1OxZxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 8, 2026 at 12:26=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Thu, Aug 06, 2026 at 01:05:48PM -0700, Suren Baghdasaryan wrote:
> > Previously, the per-VMA locking could fail in the face of writers
> > which necessitates a fallback to mmap_lock. The new
> > lock_vma_under_rcu_wait() will wait for writers instead of failing.
>
> It's not called that any more ...

Ack. Will fix. It's obvious that I took over someone else's patch, isn't it=
? :)

>

