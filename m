Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AE4C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71BA48E009C; Thu, 24 Jul 2025 12:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD118E007C; Thu, 24 Jul 2025 12:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593A98E009C; Thu, 24 Jul 2025 12:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 452268E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14EF91332BB
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:36:20 +0000 (UTC)
X-FDA: 83699710920.19.E27F5F9
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 24164180008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:36:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FM+MCZ6A;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753374978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqGt3VkJa5c1wNzNWCy8jgXUeRDGPVbUUg4zAoFy1j8=;
	b=D0IpFJEhV/8s3L5Al4DCSwn3EgJEpPwyvrdO7OOgkGAqetMi+ozVH0+IoFkrfhEMp/MSKo
	KjdmUzaC7ZmRb+IIZteXrveuRMF2qwUa51BdJLBOBl8U7tq8X9ZpI4Ox/cPTKRkyn94mkG
	ATvobgATd3LvxzRMzJPWR6cx4mUAHLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753374978; a=rsa-sha256;
	cv=none;
	b=ok1UyjYEDg9Rv8iNvgf+PQeAoYUFwR9gM5gOLSK/COIpuhVTpkTGSV/wMC6wb1BOq6GXN+
	fnDzlviDSK/W4/kUk/2cc+aoegQQLJIsKYTHTXSvhdNKVZmuzb/ZnhR3dTVuXkGpIe/1zw
	NIi/F6GntS1fGXb+ylJ27R7W+1zD/Ow=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FM+MCZ6A;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ab86a29c98so4281cf.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753374977; x=1753979777; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqGt3VkJa5c1wNzNWCy8jgXUeRDGPVbUUg4zAoFy1j8=;
        b=FM+MCZ6AFdwuRZ9ERV442L/qyHP7dSF59dxSt0XlNdE7qpdVl4gmkSgHQTTtSXYtU1
         OyrTdwlyKVAxJHIU42gcZlGyCAHRLonAIFvoL0AKuw+frFDk6NQP7HZ0oRJLvat1DS9e
         FHQdq9fOlVqZ0HjcszBPW4CVolhvePsTHp40LVjtnyzmDDh9JImhlb4bAE+TTLmjOIjp
         sQaED4A2OGfJK3AsroLOgiXF8cbicsdh3ZeJmapWIMzPPZ0dyf3awCPY4/jpo8W0nxFr
         NZq6LjcV1EmiyNxJWa9WJFkVeaZKysk1/yawDvNwZag3DcZHoCtKDJpoqKJwu3MnVMoW
         ikug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753374977; x=1753979777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nqGt3VkJa5c1wNzNWCy8jgXUeRDGPVbUUg4zAoFy1j8=;
        b=SSKlax05Cu6JFF8new92TyyLzUpg5Tf95+uMP9LnuwR2Qaz3K46cHgDW1XWf3eDDT2
         QD/dwDaM7VS/KE66T1sHrTq2aZxiakJRXlAmKVV77uw3vrZ4hu7BoNo8q6bdF3T3EVkj
         v4s5Cn64475Q3pzAaJjwSCWJ5aKRKwYY5V9Ni4SpdGbdkDlAv37MkznAFRmzrCDEvrta
         XeR24I108E0uwarX/zDliL5mF+tEBdEcas3u6naafgA4kdUdTymwXpxGpAKKdpVph+fV
         2S/RtgboMXW9kD5x5fuJTtNxKng5sKfIF01LEy/ikleESbZzLONgw/EJkpMcA5PP6FzP
         O9ww==
X-Forwarded-Encrypted: i=1; AJvYcCV1CCvLR8rS68dfESWolJ8MRRMd0gF2AqIB+wPhxUiK5UOetsOG3HbU6FCOBrBm/0x/DH5FbsBKRQ==@kvack.org
X-Gm-Message-State: AOJu0Yzv5cUJC0dyRam3xaSb9l8+FPk3dhEJ0Tc4wIpBJyGze9RhS4q6
	sBAEIFyA4T1+xTdhixU3PmNpfMxF3cJoXPo8ukJL8wkK3V0AzC4bEb9JNbZTE2SVjgpZxHsgaSL
	Zl/mThbLBF3H5XRh7yXpmOdtdINr44JskIz6FNHVtkO3GBPqCRjGGvS+WPQg=
X-Gm-Gg: ASbGncsE6UOUB2BhnIuOKymWwtgor6yw/O2GxkkzRAxh5ACI7EYFaNLB/NBTUUCbcxe
	TXRAx8C/37X5E8AV+X7vx27Khyj4U6CqH/WPE6hMMfSvdPhjl+MiAoW8yls7PUhTdMQAn4xzjTP
	Yzpv8bK888DODD1Z0jkiaM9raQMulGowvdHtwFOX/jgn9jAS95u2D0iMawD7QdWH5KrxKNJjVNm
	a7li1u/Is3dGKmvQHc9kS5R7fyuBWn7VHvlWqD8kn0B6A==
X-Google-Smtp-Source: AGHT+IGEkTaoqK4mqjSdCBRA2FdSwj9nvwSmcEFhgbAaeoVMoTA5UJNh79eP58SzZx6jSiPuqEf+ILthQYauPIfrCEs=
X-Received: by 2002:a05:622a:1815:b0:4a7:e3b:50be with SMTP id
 d75a77b69052e-4ae7cb8dbddmr4286931cf.16.1753374976711; Thu, 24 Jul 2025
 09:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
 <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com>
 <702ab3bb-db4c-49cb-bb77-4e864cae610e@suse.cz> <CAG48ez0RrGX-UDhUF+1x5-euJN9z448dsrXMgv4+7-_s=zan_A@mail.gmail.com>
In-Reply-To: <CAG48ez0RrGX-UDhUF+1x5-euJN9z448dsrXMgv4+7-_s=zan_A@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 24 Jul 2025 16:36:05 +0000
X-Gm-Features: Ac12FXymU6JzZGcIsdtyJQehBIbGmtgDvjj-rJwsSEAjONoiPQWeKLqkYmWBeNg
Message-ID: <CAJuCfpGPjMSMqL1p=dMK3NJ_Cytk037Gm63TU5OuY6QK7Vi+4g@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 24164180008
X-Stat-Signature: m43agwrc1jbbmohsmm9xqgxrcbsawnry
X-Rspam-User: 
X-HE-Tag: 1753374977-247179
X-HE-Meta: U2FsdGVkX188x++dJrCBpKuwg02Q56viOslKRslV7DfedpfJ8FNxi8hXChLXZLy5Pj4hp/KH6bswu9RXlSMq9F/A62Ki7fOuB9f4Pks/wnSyRhXRdW5ncDH/VFfdjqVZiJ9CUJo60EZHd1foGDxdSsSdmfJf7dn9sFqNwATe4Mm4KLVZhus7NB8XStl2PBkmbIjaAxZoNfdrJjlMibIxr5tgO3Mz7BT3XjvoUrLZEwTveMBSSpsuOF6cNpGri2k+08anJgu3ul3XtSNfjfC/bZF/dmpGefP2zdawgWF6ps+gAGzilKTFjB1d/vLtYLrIZSYtqsrDkwXBai7mAMA89/voYl4PI5H8lGSZvmviaHf7v2xiFvia68gPOIWrc4v4zrTT34J1bWCUDpABa/ge76gUJXjD3S1vWQTPDamiH3ndMO5mzYRrlUCq0I3A9r7ZIwr5o7ZONP5n7Rb1EuwwRyEyVhJ1Yv+VXQYlSQRN5e/aD8O9/OnAE32Sf1DoRSh0MmFF9A8KFa5IR/H3sQqIEevLreJHu02EFlEni0Kmx8ExLSHhQ0YPeNYunhIhjsG4wZDYvkD0VWFXO2D8KOcFdjar+lQ4NO1s7l9XtAta1XjuvtVAVAKfw3cJQ/RHDeayR3t6RDf+itpUoOpZ0ScnM/q/OHSLbk5mJzf/Di97J3aMivm9bnk/C/BygrL7tAMNh13tZ5CH4MsissiltDzH9XM2wDS1paZzSMXYwMVv0O3XQDN5r3i3Scvl4hjGeihAvWBdaNybnFCLaNnLRqvb5+Lz5fRysNir43Mb13gJzARWVTxxsH0MQveLWcY2hOvjS1P2FwiG+6tiF30hpCEKbcsnP5rJBb98PotZ7Z7sEYAWdIOKMA2T6behVfiCEMLkW2Oyf05RMUXzPhHmpcCvaZkSpr7LOnq7tccDqobOzfL9WKFAZgfNpPpRlmm+idEZQ305Mdyu0JVY8t/1mL1
 7pMN0Jp3
 DjYIH8mxOmfoMeYy8xcMUpR8bO+4vKXLdx7oqKENv92m3leW3UOtOQ8F8f+pL52FBx7x74NyoZemcxvSp84HII7Dtsw44+OICr5niMtAWBTrRW1p8m5GA4v9SPm1ihD+g4QRXQWSSlNlrVg9ubYTOPQO8NiFh9n124mLlv4HdaO3sEJM+03FkZMdGZ44HW+66brQnE+5z+0g++OpL+KcNz00FCdAfikJI3kVsLVUaR90RCy6i4laGfUqltn/WZcWZotN6hI7xnB0KJGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 2:45=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On Thu, Jul 24, 2025 at 10:38=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz>=
 wrote:
> > On 7/24/25 04:30, Suren Baghdasaryan wrote:
> > > So, I think vma_refcount_put() can mmgrab(vma->mm) before calling
> > > __refcount_dec_and_test(), to stabilize that mm and then mmdrop()
> > > after it calls rcuwait_wake_up(). What do you think about this
> > > approach, folks?
> >
> > Yeah except it would be wasteful to do for all vma_refcount_put(). Shou=
ld be
> > enough to have this version (as Jann suggested) for inval_end_read: par=
t of
> > lock_vma_under_rcu. I think we need it also for the vma_refcount_put() =
done
> > in vma_start_read() when we fail the seqcount check? I think in that ca=
se
> > the same thing can be happening too, just with different race windows?
> >
> > Also as Jann suggested, maybe it's not great (or even safe) to perform
> > __mmdrop() under rcu? And maybe some vma_start_read() users are even mo=
re
> > restricted? Maybe then we'd need to make __mmdrop_delayed() not RT-only=
, and
> > use that.
>
> FWIW, I think I have been mixing things up in my head - mmdrop_async()
> exists, but this comment in free_signal_struct() explains that it's
> because __mmdrop() is not softirq-safe because x86's pgd_lock spinlock
> does not disable IRQs.
>
> /*
> * __mmdrop is not safe to call from softirq context on x86 due to
> * pgd_dtor so postpone it to the async context
> */
>
> So I guess using mmdrop() here might actually be fine, since we're
> just in atomic context, not in softirq.

Thanks for looking more into this. Even if it's safe, I would still
prefer to make mmdrop() outside of RCU read section. The code might
actually end-up cleaner that way too.

