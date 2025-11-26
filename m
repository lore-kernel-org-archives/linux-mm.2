Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB7ED10379
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 04:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7EB6B0008; Tue, 25 Nov 2025 23:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF686B000A; Tue, 25 Nov 2025 23:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD616B000D; Tue, 25 Nov 2025 23:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 407E66B0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 23:28:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7C5DB9235
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:28:36 +0000 (UTC)
X-FDA: 84151477032.27.4B78F5C
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8CCDA0005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:28:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vjldCcHP;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764131314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drm4DoHOqrTYC0sapqoyi+0m9Pnf5m0XGACkKnax0oE=;
	b=4/z7MjcA0YAYTY4KHeae4eOLsCee4VTD5BqJnLxT4Kd6NJmqp7QkAUkWXlZ9cfq6SVmTap
	aJ6CG6My6cnsiMVsIEqPc+RJGakTZ3CT1n0dlNR/xtbpKWs8mXYbMt023/1g4/foRreMjp
	p0hMIcb0MpQhCUfVkQyWUGiUwXQmue8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vjldCcHP;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764131315; a=rsa-sha256;
	cv=none;
	b=IUgll3BuEMfIcy5U52Bd33nLy+DLjzM3/vh1yUw875pI1iBvYOCSwPpVV1TyXQSiuwCV+0
	/6o7ZUgihKavnuyHtQTd9/ioBGTSQTa0jiaVyOzMJrJja6s+K1ZHjyZBIEZUiVt3AJoO1M
	F/MGitG99EdCjMRfO8FBL2BUJnR4Rv4=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee147baf7bso116451cf.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 20:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764131314; x=1764736114; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drm4DoHOqrTYC0sapqoyi+0m9Pnf5m0XGACkKnax0oE=;
        b=vjldCcHPYVrZChFzscKVwhTcB/NE91wesMgRz0Z5478hAfz2HmXhRLvvLqfotHpoer
         hnqK39DNObt2/B7VAWrcpfUdN2XehSX70J7YAfJWNC7q3LNd4r3GVJieIbUZC0XrkeX0
         xrbdIlPYX9OqMAtLijPHSPJRza89fNMMCwK3maSGZN3vcwmwMUm3FBuaeqtTGNmWW0nZ
         ngR/j7jI2AhB51wdpIkk6uxjC2FemLE2JzwQPEGaGnfgkViwv5Do+/av+lm8WyMF++rE
         Ubtcov5m0TEqJU/dGj0Y2tjjnhrBdXFz/dpctOSqgUsfmLw4uGHsJp2DwyzQ27vEPK9z
         BuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764131314; x=1764736114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=drm4DoHOqrTYC0sapqoyi+0m9Pnf5m0XGACkKnax0oE=;
        b=H3i52pfaBejVeSvbeWUgvFqe64yown2aJKAPqpuGHTO4eULYGP1v0rtV6axKn8nDaK
         R7VVCcair2XmobunaG7ZeNaaPx9xOpHdL9rCLnDWBJet8kTP4NLUCzr85KoAPJCaC3gq
         bpOhrQ/HDKVpNq4zKlyxCioissq4Pa7dhI/wHMbNj4MBBYozjGqgClwsErmtYxsp+8kC
         tK/NHI+ngtXFGtBAjSTkD060BGPXU1sW9to0uloEOn+hJNJvujosR9NZ2bCV1hNkJ5Vx
         0QWxaRL26fOy8FolRPyYAsCxlyTJQZk+NIGB8aP0ow83fphwwj7IfLQh0h4zUMJZT1wM
         mkDw==
X-Forwarded-Encrypted: i=1; AJvYcCXQNzs2PAJLMT2RWwgHubXLUhXQzlbWoCZ/qUPZbuO1pLiKQ5gC6k9dTqp4lpciybpYNlyyg3F+vg==@kvack.org
X-Gm-Message-State: AOJu0Ywo/Lpyu+xlKymXzRL8yRxtzDG6TNiYM9gZJNzdVXVW/wwEg/vj
	HPywElp8WW+4dhafvaieUiVyuI/gViatDuazJml4mW0FVbVXmgLmcA14+BGkygJyQHM5Vvwd8w4
	DCrwDuBKz8HwYbMU/OX7FhNjlzBB8eTnwnBMw/dzA
X-Gm-Gg: ASbGncvSUET1uxgYnS4lj7bE0U3cplSqvfklLlL2FsmGgJ/cy/Qn4BknrykYofYk0//
	1BZfSWuF2Z85LotM9dgJjuIGRhMhwEz4Zr3VjXvYRZWDsGmSRPUQTsEbGafYtTSS11Sg8dlhuyJ
	bZqVtOwvTZR+Ow8N4zky2gtrhzxo54QlhYJIs8Sh6T7XdeJNrAozy20yqMV/WYcMLz0/NEPXYC6
	3cOBDFIVelbH0UOwwuUWzc+MyQHB1UNOD6UJRoZvM+lGKkKPMs3qcOJpoTJEcv0z7J2nw==
X-Google-Smtp-Source: AGHT+IE9A8yMSmSdhayVhMqlf1mg5/piGDgQ4GJmiPTw7/Ebwna8OTlXSKOf4fq/XHIGlcDZlsavWrR0+nVSPDUPY9c=
X-Received: by 2002:ac8:5fc1:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-4efc6ce40fbmr2589701cf.18.1764131313769; Tue, 25 Nov 2025
 20:28:33 -0800 (PST)
MIME-Version: 1.0
References: <20251126034404.2264317-1-willy@infradead.org>
In-Reply-To: <20251126034404.2264317-1-willy@infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 25 Nov 2025 20:28:22 -0800
X-Gm-Features: AWmQ_blk9wRDV0VZnYwqgq4TyMcsFhCXzh61Hco1ss7K3iz47Z8usI4x7tlFiFg
Message-ID: <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E8CCDA0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fzg5yzmrraeh44dj4h1k54u5y7k591sk
X-HE-Tag: 1764131314-925014
X-HE-Meta: U2FsdGVkX1/jmUvwDGXbVG/cRkkoeJ6yZ+dZ50ruJjnpIi7y+rOv2y2kdQ0arjRdiLDio9hW8oumYpwh84v1QvSRESlPJP/xJnM+uKxz1Mm+FBZTzfVCoqEO+j3iuxklSCH2H5GhaQZ5s0j1DEEkgnonUHpYixvaJGQkIzaCJcMI+qbCeJDzEJvcTK1B2i2aFxGXIsK7/x6rbXcVXtEfakSi8SYk/oVNT5OlsWtl+694CrhMVdKptx3mkr2sbQO3rba5LKTx0zdCwM/AdbaleUhdpiCg3QRhrNMjapWxGyFRdMSJe5L5XirUaiAb5QUPuJxUhA6Iu43/V6aG90bdKZ8SUb2Y/4YE4JFKbfkjy4sR26/0OGnqfzh9mARhlf0Hm1UcacDFeWWtkTUC5sBHenYZD/cOxn3ucP75XEskpkN+lIxYXSiPyb0xUOuHkFSfPltRtQ/PcshMMmFxGVwW4BA/tgbEMEYSBZoAiTDxvhUGIHOAC39fkoGMtpC81+86w6Bv+3/SDUmYij96Guu9Fi2PbbAYLDOg+RuWIJUbNke3UETSBzUVAplCxJsHPs7elPYHv+X8RxjBTXmawgm45Mu1Q1krwT6K66Gjp+4EIddc2MoyFjaPqe6SEVKdomUPC7MVXU0G8wgB2rB2EnH2UUe9oHGISpQcD1gV0TORdt0u6ztYgCogzPcnUXBuTvpcPnPYfHMPddf6VWwVAkP84NDo1KmQdzRunV3tFtibNWIvhyXmWyFDBEMSh8BL01latZupXREMMkOqvLAZcXL5EpXXzGz5nhPCNopG8phtCcYbXLCIYGCjNTWe0790UN7h4ue9I7afYVPpqW32bhfzIYKKU4XgEvX5iU08a2q/Bk2Xff1akRuKJrSjB39goC3makeCXg4lwh6sjFeDYD7b7h3wSupHzB86AD9uOndyHo6CvCTeCyEvlEUiM2XYIasR+rm+rJa429vDYhHvEBg
 lkcTo4yN
 nbZf6wLE42nh2HIGItjcm1SHrxppoRkEAt8+2pCA3V+34+sny+npMYJCqmHnGh6kzf6mdKLSUS7Hy+Uf66Q49I9YSTH5Q8qcGTh/Z7niRdu4DSQnEH0LG4vBDpa1gnkETEbXh55OntypvJmYjDXh0OWdw288F/nBVzc5BDyvx15J8OJdm1cKrN/IHCs1fedb7x4lZunpxxrMOysrE7pfc/KK8AVV+FENhiB4ztVOGGb8DqUyKFb+AazOIt+rwI+zi428T4YcnalDX9lMiGZCGlk9hpDfz1o8+Tjz+F60eMp9udIJBRkaeD6MxGA1qZERSxqTRAHVS9Hk+XmfI89uVXmXbi1Tnvou1vJcQZJjPguGPswAnezRC9BMfOHeHn+te8F0ILIa73PZJnjr0J9am/u42ugfy8VrVsice2n73pG5cJpMpADCe/CEfTRGEiB84Avt2Dl1/p67t0OuqwjleP7B/1+rePlDxdYigImztTpTd+sE9kMIZkXhElg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 7:44=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> If we get a signal, we need to restore the vm_refcnt.  The wrinkle in
> that is that we might be the last reference.  If that happens, fix the
> refcount to look like we weren't interrupted by a fatal signal.
>
> Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
> Andrew, since the vma_start_write_killable() patch is in mm-stable,
> I don't think you can put this in as a fixup, right?
>
> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.

Doh! This is embarassing...

> Any other stupid thing I've done?  And am I doing the right thing
> with refcount_set()?
>
>  mm/mmap_lock.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index e6e5570d1ec7..71af7f0a5fe1 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -74,9 +74,18 @@ static inline int __vma_enter_locked(struct vm_area_st=
ruct *vma,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
>                    state);
>         if (err) {
> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcn=
t)) {
> +                       /* Oh cobblers.  While we got a fatal signal, we
> +                        * raced with the last user.  Pretend we didn't n=
otice
> +                        * the signal
> +                        */
> +                       refcount_set(&vma->vm_refcnt, VMA_LOCK_OFFSET);
> +                       goto acquired;

Wait, why do we consider this as a successful acquisition? The
vm_refcnt is 0, so this is similar situation to an earlier:

if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
        return 0;

IOW, the vma is not referenced, so we failed to lock it. I think the
fix should be:

        if (err) {
+               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)=
) {
+                       /* Oh cobblers.  While we got a fatal signal, we
+                        * raced with the last user.  VMA is not referenced=
,
+                        * fail to lock it.
+                        */
+                       err =3D 0;
+               }
                rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
                return err;
        }


> +               }
>                 rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>                 return err;
>         }
> +acquired:
>         lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
>
>         return 1;
> --
> 2.47.2
>

