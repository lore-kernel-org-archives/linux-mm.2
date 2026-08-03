Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E3EC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 21:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00BD6B008A; Mon,  3 Aug 2026 17:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2BE6B0092; Mon,  3 Aug 2026 17:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1146B0093; Mon,  3 Aug 2026 17:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0466B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:12:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA0FC140839
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:12:41 +0000 (UTC)
X-FDA: 85061207322.16.3FAD2B9
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 099C780008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:12:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q4fJjEYT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785791560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jJvfzzQqRDZBdeM5OEoiauFHPhYv6Wo6yFTQ3ygD8s=;
	b=H4sbTFbFH/Yg2Svel5IBANIVD93upAQkO7G7UrOcqhdDtMO/kKZJROpEHqURr776QX0SnI
	NkgMa3CKVbIspyNdgexZLFMjnrWjW/POUDl/QdDiXohJQRJzbQ5oQ1aXu7LUNAc7CDRktd
	3463Fhk00+EROVFUvU02HZkzgUOqGe4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q4fJjEYT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785791560;
	b=IPLXsrnVqcs92ibZ2T7NwOlxhrHtqVxuqE2ebwnSopJm39ZhyMNqReq12klnzdijZ/vhyT
	w+z43hg3CgwEGpX0usYwVyJZRRz7cIQEP4poo4gkY0Q6B3fW6LMN1dueNBW+mGYvanMKs9
	zzUxPe/pOUwhhqn5cW4M2t30661kqnc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cab97c86bdso16185ad.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 14:12:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785791559; cv=none;
        d=google.com; s=arc-20260327;
        b=rSfOzB4NZwnkrsgztFJ/gtJD4W+88OwA4yi3PpplD+j7ZaJtqOJKbPT0toBzhIIyzg
         sWC+L+yP/lwdq6yN5yCaRGTyoeWTe5nwOhV1wddj+iNc1kaVYzXKoKUCmfTwY8ubhf5t
         I5iovyWqoh4o+nanTR424bJw8Z95Rfgcm2EIjBtdgtzxC/DAeYO1nBLPDHGOYrXMuIMS
         WxZ1sJDm8yBt20A7MO6z6kkFvGD/sfu0BkGZyhiCK89pGeKuFiwLs/fWwBKoIqkN+k53
         7605JtJN8uI1iNWuQPGaMArh2r3lqdOu5uoXqfgvslKPkOVfb0UMzWnH7FKZoQGm+V/S
         qW9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5jJvfzzQqRDZBdeM5OEoiauFHPhYv6Wo6yFTQ3ygD8s=;
        fh=gJfwcE92tX1Hx6LD+DKg/lhRHxN1luJWIwNjC2+xj94=;
        b=CwbkF1DupPm9X9NVZm7yoydthib24Kcaq+lAThCx0j6eWoOWt+K7+1F5POF/6V+Nlp
         zCM3hDT8A8eJzfaxLWlu0REQQaPJjH9T+H9sW1xql/7iKsO3AaNko437RBK+ydHL2GJ/
         75yReeoU3TPEWaVwYmQWQN7X9GavP2UVNaYVAwDOnznu3q9QZFf7BmAF6BWzaS8n8HpJ
         5VBL18+TYLLK1RemujFNpJzD+tsa3vDEwfYl5pBIT38Qsl6CP5W/ecjetP31w1kuvJMv
         43NH7Jr7OCf2E6qqDj7oFeMzyLiGJTAC2NiIYOn9wZjNeSPThbkjwwSPH86hnELh2pGJ
         ev0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785791559; x=1786396359; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5jJvfzzQqRDZBdeM5OEoiauFHPhYv6Wo6yFTQ3ygD8s=;
        b=q4fJjEYT+WZ0029BNrmkS1h9GQNV6xfZBdCxmUxoJ1cZQ1e8z7+RZ26+t/4q5eGcvA
         zfFYyhLg4+gNw4wW6tL6SBatRaZim5S4peeiNH55S4JYQJdOQlVy+l3n8R9WhMKUGXj6
         6CgmcJ7eNJy1VRO0kRsoitxj/xV30ZtUStVE2hyMbIfrizdzlCRgKd7WCxo9jKdq3jer
         qC865epHan9sNlFJkWpW2aQ6q3yVclUBEW/E0qHrHHVi0xNNJQzLxE9c80KVaUBYgHGE
         EWq+M1jURzJejCVpafY3kElq8NI6yyfWfzwa4xqIxHdDCoBbnvEzdQ7LKxxHiHm1IFrB
         rUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785791559; x=1786396359;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5jJvfzzQqRDZBdeM5OEoiauFHPhYv6Wo6yFTQ3ygD8s=;
        b=V4jbrfWuw4f4h2mS4kHfUk5fUQzzso5M+/VlvAR22u5PMXMzXp8nb19nbb8v0B6ghm
         zmB0WEKhm8Y07imRNWNR3UNyJ6I7JFel09hlRAKRRQ4+TMuT3v0sjDNs940zOTj01VnW
         V0muRv9NRx0yUyd5WQ+/TrJTfUids7ZkX/9IfLqLV5sgdXAfEKGFOly/8iKmaWvV9Mv4
         WACav2N38YzT8wDe/2a7SsFOPG1PWWakro7bbwhWOcvTsc886I+Eol+SLQ6rgDSz2b6h
         90nODV+cmc2sfO9Y8d/NSoTRiO8jLn67QsFOe4DGXT2anQuBu6fdzz/oOglGBm0w+Fr5
         k/Sg==
X-Forwarded-Encrypted: i=1; AHgh+Rq0+kldt9rgLBZ6nPINKSTij/J3HCKgFOMJS/o3z5sv0w+wifKzDMmEE8y56XHSYWCaQWRcTyKEXw==@kvack.org
X-Gm-Message-State: AOJu0Yxrv6UKL3lS42UpFcGTnGrxvPojLapsf5rEcPCkfMhjFujlPb4y
	u9VSvoRxS1/2aJjy1HGI2kYfZIQZAkVLn+xZbSi7nFBPfY06ltGbKiYWZpaWNC0nFyLriNIz01d
	wL1esIrJKd9UDIfP1QMA0kltguFtL0NVM+5wsNFUd
X-Gm-Gg: AR+sD10kH/1/n7Y+bYxAw0h8PMKxq31trfqbs9AUulgEFyjQtU8M8bfQm+yibXXJQuy
	usnZ8celObbiWCOcWCp9W7LBp612vGJMezpynLbWzrFmkbjQAhGhrQNo3gWvyy1rGZXAfyqPdRQ
	cdMze+z9vei95TljQ+gK9yQiTbE7F97b7Xk22f69FvSa620cbqu3C7qwsRIaUgyw4w4Go1QdwF8
	q2oApWAaqu6MAyg89dK4/PO5e5/vVmG4Gd51GNqg7KT7VdUWcfC5Z2qUo29EnMlb1lhwXajsIR9
	4On5giQo0Ty8UOs787d7VsdrJLlkSVplM4Hl6t9PsdbynT18AplfXlBI1PcGgt38v331XXQSnss
	a+Jd9+FskUFI9LbYCs/6dlImnBhTAzw==
X-Received: by 2002:a17:902:cccf:b0:2d0:8b22:22e8 with SMTP id
 d9443c01a7336-2d08dac64f2mr2794505ad.17.1785791558228; Mon, 03 Aug 2026
 14:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-2-surenb@google.com>
 <CAJuCfpGezxdaSme_QpHVq-QVeZAUaF360_Ajvkrn3QqDcSQVog@mail.gmail.com> <anC1iE21eonDK06n@lucifer>
In-Reply-To: <anC1iE21eonDK06n@lucifer>
From: Jann Horn <jannh@google.com>
Date: Mon, 3 Aug 2026 23:12:01 +0200
X-Gm-Features: AUfX_mzFwteAQxBUM4TvuzYNFGYmEeNzpupbj75hFXyN-f5Jb1ghubsN_Vgb6e8
Message-ID: <CAG48ez1=_O0g7rArdpoVwg84jOJuELEAXu5sw=TO_CWBsK=T7w@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, aliceryhl@google.com, 
	arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 099C780008
X-Stat-Signature: ic7q5iiaipisdjpir1nggxxnfi1x6dpj
X-Rspam-User: 
X-HE-Tag: 1785791559-701699
X-HE-Meta: U2FsdGVkX1/DadcYePb1/uw+YdRya/ea+BtonRG51I1HcjbF92ObwAizTMe1a+8L2PjWw8VBiBvBQvm3t1SS+glcLnEvuvuNAk937e6edD9OMD7Q8ALBoHAqRFW2HBXdOWSu8s42XScSt4GI9sptaexXl0D745eQTerpTIIDx6j2FPHgYJYo1xzZbVm5homDCX5CM6PLGAODo0s09jiMg4MV6CppE6+LrzC2OpVn58TsGqOAtgDqNe1QdM4xpX1dtIbVZcSl9KIHbnzude6mhRcwM4IBe5Z3wGpy6ngAT30dbxOHRKoAfPAPcqzdII4Ol8f/SfHD7EkuzTyyeCWSnaN++qXNdPXvlphtbipw5yjt85UViZgq/Lf+yG+DesaxlbP5ZenvjCMxof3IlREqDaRU6sjMaEje+s6NcLXzMtZXPMMCFYTkTqefLGyyDHL92iOsIIF7FE/r2TH42ETyKT8z5ggF7X8SqsJg7VRuxetlLqso1oR0tc2PlNFkKqqiV6dqcpxATRTQ7XOMboY8raEnttbJNxxO8WMOfyKRCg3ZfgSfDAoxFz6hqjTDx33r/wb6tZEk+Yf2ptUB06EEU/5gLTfaAsZKH3WxZM9Wqi9B1Sjhv5HECCM7/rUorVUJliEiELr3GPQRuxQNLdoVvSPI0l+ARZ4kGeb+EeKwxmxQDVoXSN7RaSvCYdiTgxbRdWJFq+CIhv8lqPpSZeeRxtxZL+Z62MnLONgyKggRFldwSVWDjYMWKoPtUO5FGf9YhHH1ckJSSua56S7P76UqQ7TAvvrOHpGV5Vbsf9TYX8JDZhHxIN13JSJYueREpJU0ITk9nwSNbFutKzZgUEA5b0tIhtPAt/qLk7kOGbkK5THk+L7wHrkbRWwHmUeuLooNJ1u8yta5NcO020SjwRDqp+40NA8bQbcR1XjmZwT8xBkLxJoDG1O8yGC7i440y2sCBHR25k436Cm28a0V+O8
 f/4X3hSJ
 cU8FBzgd5Xg4t8dWwQyrY/hmROxrbaBFRCTqcjvhyITSH4lDDOp5b+ON16gam68u2o8OeEJ0KLPuAV4eI54gv5s914sJPJuonf+V0wFoWKF9kurpX3cDyVAZb1jODmktbDI8O0WBUp2ILnRIJjhMQDbnQ6WEFdK3W+vBaYnZNE+z50/sg5fVmtJ/32Xl3o2nsYBgjSOlwsYsJ6bvcHkwjSZj7yl7zv+NtfP8/PqZK3x0wKq5na8i78xcYrjsg118xHVGjcIN1kcA6WWsK/7MosbCZ+UhwDBqUikibn/438FGEBosDX/Vn01KPbEqgEDUga1aOnT/hvyJdJDpp2hP6zA1ievWoH5dEV6bQ48E0BRJwOqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 6:08=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
> On Mon, Aug 03, 2026 at 08:24:44AM -0700, Suren Baghdasaryan wrote:
> > On Sun, Aug 2, 2026 at 2:55=E2=80=AFPM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> > > -#endif /* CONFIG_PER_VMA_LOCK */
> >
> > Now that I'm looking closer into this, I think we would break NOMMU
> > case because nommu.c does not take VMA write locks at all. So,
> > lock_vma_under_rcu() for example would always succeed.
>
> I don't think anything's broken actually.
>
> Per-VMA locks was gated on CONFIG_MMU so nothing there assumes per-VMA fl=
ags,
> but now you have stuff that happens that didn't before but:
>
> * vm_area_free() -> vma_assert_detached() - fine - it's always detached i=
n nommu.

I don't think that's true, AFAICS vma_mark_attached() is called from
vma_iter_store_new() which is called from the nommu version of
do_mmap(). But I think you're right that one blunt workaround for this
would be to add a hack that prevents ever marking VMAs in nommu as
attached...

> * vm_area_dup() -> vma_lock_init() - no asserts, just sets refcount to 0 =
(correct).

