Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB6DFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 16:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70066B0088; Mon,  4 May 2026 12:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9A16B008A; Mon,  4 May 2026 12:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0E46B008C; Mon,  4 May 2026 12:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7B316B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:42:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F091A0217
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:42:51 +0000 (UTC)
X-FDA: 84730306542.18.538BB20
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 61BD0100007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:42:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CD0RhGi4;
	spf=pass (imf14.hostedemail.com: domain of avagin@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777912969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGEZKuzc7QfAPlEmqhUpyNCXzeAPwLtCzNhdHRZFupM=;
	b=Nh2boSlNuz04EJhvY4TPH/f3LIYitJK6gp/jnuxHt2N1AZng/asS1fPkIoXyWDXohe+rdi
	e5UCNA8mLiqrJLggw+otIQKOclI20ai/MoI1g7fsz0TQAEKIIcv1ehLmgTT/g0RPAhqn/3
	MvNyH/Gh7IJX8D00QOM/DZRRlJiAgmY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CD0RhGi4;
	spf=pass (imf14.hostedemail.com: domain of avagin@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777912969; a=rsa-sha256;
	cv=pass;
	b=U/APDzoBw0+fymYOPw+rq5muPPqCm6GYSiodGKRbxDiG3N1T6pgVBBcEqK7ijaFmlxSATc
	CwKvxEKa6rdPF41SiKUZgXCLH/7tBYk2cMoTX5jYvErgSthAFe8C6XeXQFZcueGS8BuswW
	I9sR6sLk60yz6SWN909n5bSVrVYfP+s=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ad617d5b80so25913935ad.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 09:42:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777912968; cv=none;
        d=google.com; s=arc-20240605;
        b=CxJGDM3HugSIPsnlE6Q02KJsgC7FNKKlY7i3Y7u/WdOeo8GE5PQgLxs88gnZajHOZz
         AUrDhEFAGdF5g7p+Hvc0JKZybKsJDjsoq9UckesrmxWw4W3HPlOtyHioMTp2t52+1qcU
         YStOkw/fZoE83DwV+dpHPIyuznGhVozczWaoxYGvcyXtVIkKqJh7S3se54XZhaDCupNY
         R3eIqtQ/B3xtu8DbAmfQUAjVCpc7tO1zE/bEABDQi3kjYQJdGKPkJXPQidFniqPZpYYm
         OfzEpo0rR+uD3qWqW7ShyKVJ2aJAcF0uviisIF79unrcfByEwiRnAfgTEdlpPFlDZDl7
         etIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jGEZKuzc7QfAPlEmqhUpyNCXzeAPwLtCzNhdHRZFupM=;
        fh=VFPKGVeZkvsGiWhnT6+ilGOUnwPFpxsW7pAv5+diKJM=;
        b=e0tyz6G3/fjqpVjk1fuBPVMB6TMi2m64uGB6OgBa//u46dcBZe2rhQoSgj1Ca2Q9s/
         N7k1B+w/i8X4nxTbP1glTkLHBED4qb8slopj+wPleT8k6PUz5nOp0NDgb6J5+MWvLSHc
         h/F7TfUfd0rL5sB4rZvBYf2/Le1gSkmGAddGTOWMX8WYYtZQ8amhkXVWQk5t/nfPpc2v
         PYdAOoHxdxmOP8LGs/Z+w+y3BFHmiePBv0SrFzTIOhSZG6T7kj5utjdVeEAoc2cVnVOe
         Wuw+d1FCvQAsUFEMrQYyBGnLH/dHtxocvY5ytKAbT+x8CbODwHXLEp60Oyi0pXTsVxQl
         NNgg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777912968; x=1778517768; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jGEZKuzc7QfAPlEmqhUpyNCXzeAPwLtCzNhdHRZFupM=;
        b=CD0RhGi4X0nJlyLSLqDK453X7A6PXzyi7aprsJCx0zbER/G206LdaiRVhSXVGGQtf2
         DfPakv14YnZpVkuTY6djS7dNk5XdjIsrbo92GGLYvHqlaIhAGXjNzjtuxT0EsVvZ2/QH
         ZkWW5k/+vuN0gRL6eGBn2RJLWq7Wn3knSYDmTu6eNlNYPnXwzn5ryH7W1OvrKUg3kjDh
         piEDisptquEJJcZIEvMUeYjcLBuY77RyYKYVMyytk2KBTSRnefgpNEKJBdOYOaf0zR4W
         rbhGm2PVFcy1wlmaIRjSdVgOPz5aipR++mEVAh1RJSxiOqG2kWT1Q5s88Q/l2ru0M2gY
         eo0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777912968; x=1778517768;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jGEZKuzc7QfAPlEmqhUpyNCXzeAPwLtCzNhdHRZFupM=;
        b=i82oKZBWkt2XjJaqiPTy6GXWYYVlsCwh0T74MbbS/dibGaeUldUVlgquPjepP29ek2
         OSS50Ej/WjxUoVcyuWmlEKdyghCAS26m4jCFw7Nk9/tO+fiztNLVZAozIWDOp4b8xYGv
         qVNQGwqFE8927td2d8yb5S28Wr70W61BxTJ2obwzLsFbJ9AouDV0jPGvpMMfEKGONhW9
         95Xky3VYKpKw2e19uKKGVv+wlENKs+9cDhKQAgWGi/e5+nzttWb9oAF02XDV9O1IGjlx
         KMozwLBZwv8hm2jJkUe9WTcq2QcpG+uMobTgTnvFEF59AoZJyptOXtpAuiJ9ClmO4Q+w
         BnvQ==
X-Forwarded-Encrypted: i=1; AFNElJ+r/F6UC1ARb+lEa9AjeUQiiYfJujhSPC4aTT+bNbCDZGMjup23STKCxAqRq8+pS1x6sQDysWBNLg==@kvack.org
X-Gm-Message-State: AOJu0Yz75FOfwnOn4xnId9K+FCpHnaV49ajVOH50a/VT4sRmAm2k0UmK
	Eo54g8kq0RLfWhO1wYsiUAHVIG2Bx/RxQdtXMeNgNInKaaLXYkyRm321NOlNmjX/i36m8ZKHwN3
	pEEH7C4Dk4dubyEmow6DHXLdg2DzCB88=
X-Gm-Gg: AeBDieucw+oaginZPhML1VsKybUrLQz+8p39h9ehyV7713AJIG8HqU6TTmPiu2KqoFY
	qC5uDlPYlRjDg6WlHQwiil5iwzo8EK0424MIbpdaXbKLutHLuy2v9zDwYm8gTOj5Bxlcj8H0bNL
	kCh8/wi1hnoDn7w+L1PtEAG58GALMAImFbiEAR0KL8mJiXBFbX9va6Em8hHnlZrnB/MqtXXni3/
	CceOa2I5wfiR/5lw94aT7W2fCg9EgvI344iDwakfdsXUXS7IELwVW+hjlv5x4EiUALldhNHQj4s
	DbFmASNNa9q2jO5hzw==
X-Received: by 2002:a17:903:1b23:b0:2ba:4eee:6c2c with SMTP id
 d9443c01a7336-2ba4eee732amr930675ad.8.1777912967958; Mon, 04 May 2026
 09:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <CANaxB-y=SD7V7dcBXuAqq8=p2R46SAr1uKZtMACynvk1=Cftqg@mail.gmail.com>
 <20260424221126.1238744-1-elaidya225@gmail.com>
In-Reply-To: <20260424221126.1238744-1-elaidya225@gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Mon, 4 May 2026 09:42:35 -0700
X-Gm-Features: AVHnY4LD8cm9XWtC5uHN2XK6wOSOA4_xygzvNm0JPNYcuxtCaJQCmlTzed3-0Z4
Message-ID: <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm: fix VM_SOFTDIRTY propagation on VMA merge
To: Ahmed Elaidy <elaidya225@gmail.com>
Cc: stable@vger.kernel.org, lorenzo.stoakes@oracle.com, linux-mm@kvack.org, 
	akpm@linux-foundation.org
Content-Type: multipart/alternative; boundary="000000000000e5945f0651009ec5"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61BD0100007
X-Stat-Signature: im369nhby31x1u4bred3cj49mugfrnxy
X-HE-Tag: 1777912969-961933
X-HE-Meta: U2FsdGVkX1+7vuJRRte96yXKfI2h7fit/XmXUG8okf7UlkBk2UnW82j8wa/HsxLGLAr3L/i2j3KEBLXZWe3thzbLxE3PA4/wfAF0nE1o49kNOJz1SaVSthkgZ2gkTOab7TGe4zXRr9E5bVH/6qTLlqpqaherYAOc0nZ1JXWQ88fZwQi5quy9fHE+aK39qNo4cVWzCaf03P5akOUNWvOHH001+qBubdwcLgskXbYsLK/FG+qM8ZUMUMMTagFvHwQM5/nWJmt2p3cnYnY32C5zT2L5OA3SA3UwGCgyBafuyEfEJbx7dPPfvkHeuqfBgLTwCl0blbxQtw4yFtGrcNzundarGpXQ2wIVLO/zNhw7HH1drohuxKEhlRudlswW9V2os0L/5YD2rcdhQu2LLM8ZrDeVIpRnxkpyw0iR0X5oVtmH+y2ZKMO70JO8KTcEf8bGthseFiDC8l137eheuRFJVqOtIRoCkXsj9eYXzY6UKCmaIrZGqlGgjEvKkT/vNUf67L4ATvpX91YKFpe40fYB71MpoReKg/suKHoqVzP+3kUlQj/JeVY1xcgCD6jh7QCO4n2JLCfN7WO4KAueWz1EUhKISiaZ/ZW5RTDl0042fcyxpK1WI7PVqKr5Lk2DbtlOhOwoVVM1syBQ+nlRnbq25kEsxdGtB3RZN6pcRezFQRWumqZDIc2eHyYUT3YUOtmQhK3iAyEwaChcl35UjHL/iVFXd3ROO319b1ljURy0eaEmcVLTRItr/HyheFVBt1jzDbPK2un0kcvhnwXOh9LbDB2vc78pg47esUB6HVnMFphmLhp+q8blYwdZTjWNNkA7GqfueU2zOwfmm2TC6UoJXAbXHr2pAg75yzo1EW3aBDVj984wLJF1nmNwSMrEBuPBRxRKj4UIO6Mq27aPFZPI16x9fH2NcZHtLPWRRjRubgdG14awFQqbGSWk3c8V+LXEmMvOxsZu9xMXimHSt73
 e2Cknp9q
 UEC4/6ug8bACKYbZxHwi5oodZqG2CbQV1cnKQXd0qaXn4D5UWlKUXL8a07iMyTRyYKX0lw5vt4FgbD7foBb6Q34z+ZU92Dfm3oC3czpiRZvNwD4wzGbWb8U6XwCev7XcKurLUxP8JIyh89qwb93m7h1TgwwN4FTI8CD9I1bJHlz0HwzdT0yqvXwA+4kjeEO/eMptsm+HgY3QAGZvhrCYaatzL6fbwKvhzceJ3FDVkBSsKb9DhUUUT0qnzh2kJm5mHJH2VfxzPqBWmStMrGKPXj309aT8CK3d+HFVTlmpIixJwXyyctGYTVWAHc/MzdBII5EMSCwOJtvan7mS3sjDg+zdFQtAri2UBsDrW0l6iE1YGvdE7Bd8IQurFoyvKNZyzBhO97fqI052lzDdZ3T4+KvwqDhMGYAcUtRnC8KZurfoiDBPtngKECEUTSX9QW6/0uQxQIQ1ha1nowJRz3XiCqbJ2aDDLl0wP8vqXdTEgDjodsUQFT+yOGdba+LrSxZ6rFwFXcJ90i9IJecn9q2cXDecRun0aZ65W2U3asiGpmSQX+TJZ3rqqHFLkd5fHK8BWF3+RcoAMjTbtX3ioPth9UPnLSOyWzKEpXFdJGDI6P4jX9GIFuUSmXNjdGh8vztAY9QfZJcugY7yxDWBM0X+UOIT/uN+5R8kft2h1DDkcoTbTMNMmW+g8qJqO/XulMTpvpLJxSDlytBZWh4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000e5945f0651009ec5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 3:11=E2=80=AFPM Ahmed Elaidy <elaidya225@gmail.com>=
 wrote:

> During VMA merging, such as through mprotect(), VM_SOFTDIRTY flags could =
be
> lost. This breaks tools relying on soft-dirty tracking, such as CRIU
> incremental dump/restore.
>
> Upstream resolved this using a broader VM_STICKY infrastructure (commit
> bf14d4a05387 "mm: propagate VM_SOFTDIRTY on merge"). To minimize churn an=
d
> risk in the stable 6.18.y tree, this patch skips backporting the entire
> VM_STICKY series (9 patches). Instead, it introduces a minimal standalone
> fix.
>
> VM_SOFTDIRTY is intentionally excluded from normal flag comparison to all=
ow
> merging in mprotect. This patch ensures the resulting merged VMA retains
> the VM_SOFTDIRTY flag if either of the original VMAs had it.
>
> Suggested-by: Andrei Vagin <avagin@gmail.com>
> Cc: stable@vger.kernel.org


It probably should be: Cc: stable@vger.kernel.org # 6.18.x and
the prefix in the subject can be [PATCH 6.18.y]..

Please add The Fixes tag to the commit that introduced the issue.


> Cc: lorenzo.stoakes@oracle.com
> Signed-off-by: Ahmed Khalid Elaidy <elaidya225@gmail.com>
> ---
>  mm/vma.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 5815ae9e5770..03728d855684 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -978,6 +978,14 @@ static __must_check struct vm_area_struct
> *vma_merge_existing_range(
>         if (err || commit_merge(vmg))
>                 goto abort;
>
> +       /*
> +        * VM_SOFTDIRTY is excluded from normal flag comparison to allow
> +        * merging in mprotect, but we have to ensure the result is
> correctly
> +        * marked with it if either side had it.
> +        */
> +       if ((vmg->target->vm_flags ^ vmg->vm_flags) & VM_SOFTDIRTY)
> +               vm_flags_set(vmg->target, VM_SOFTDIRTY);
>

Should we fix vma_merge_new_range too?

How are you testing this patch?

Thanks,
Andrei

--000000000000e5945f0651009ec5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Apr 24,=
 2026 at 3:11=E2=80=AFPM Ahmed Elaidy &lt;<a href=3D"mailto:elaidya225@gmai=
l.com">elaidya225@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex">During VMA merging, such as through mprotect(), =
VM_SOFTDIRTY flags could be<br>
lost. This breaks tools relying on soft-dirty tracking, such as CRIU<br>
incremental dump/restore.<br>
<br>
Upstream resolved this using a broader VM_STICKY infrastructure (commit<br>
bf14d4a05387 &quot;mm: propagate VM_SOFTDIRTY on merge&quot;). To minimize =
churn and<br>
risk in the stable 6.18.y tree, this patch skips backporting the entire<br>
VM_STICKY series (9 patches). Instead, it introduces a minimal standalone f=
ix.<br>
<br>
VM_SOFTDIRTY is intentionally excluded from normal flag comparison to allow=
<br>
merging in mprotect. This patch ensures the resulting merged VMA retains<br=
>
the VM_SOFTDIRTY flag if either of the original VMAs had it.<br>
<br>
Suggested-by: Andrei Vagin &lt;<a href=3D"mailto:avagin@gmail.com" target=
=3D"_blank">avagin@gmail.com</a>&gt;<br>
Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable@vger=
.kernel.org</a></blockquote><div><br></div><div>It probably should be: Cc: =
<a href=3D"mailto:stable@vger.kernel.org">stable@vger.kernel.org</a> # 6.18=
.x and</div><div>the prefix in the subject=C2=A0can be=C2=A0[PATCH 6.18.y].=
.</div><div><br></div><div>Please add The Fixes tag to the commit that intr=
oduced the issue.</div><div><br></div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddi=
ng-left:1ex"><br>
Cc: <a href=3D"mailto:lorenzo.stoakes@oracle.com" target=3D"_blank">lorenzo=
.stoakes@oracle.com</a><br>
Signed-off-by: Ahmed Khalid Elaidy &lt;<a href=3D"mailto:elaidya225@gmail.c=
om" target=3D"_blank">elaidya225@gmail.com</a>&gt;<br>
---<br>
=C2=A0mm/vma.c | 8 ++++++++<br>
=C2=A01 file changed, 8 insertions(+)<br>
<br>
diff --git a/mm/vma.c b/mm/vma.c<br>
index 5815ae9e5770..03728d855684 100644<br>
--- a/mm/vma.c<br>
+++ b/mm/vma.c<br>
@@ -978,6 +978,14 @@ static __must_check struct vm_area_struct *vma_merge_e=
xisting_range(<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err || commit_merge(vmg))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto abort;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * VM_SOFTDIRTY is excluded from normal flag co=
mparison to allow<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * merging in mprotect, but we have to ensure t=
he result is correctly<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * marked with it if either side had it.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((vmg-&gt;target-&gt;vm_flags ^ vmg-&gt;vm_f=
lags) &amp; VM_SOFTDIRTY)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vm_flags_set(vmg-&g=
t;target, VM_SOFTDIRTY);<br></blockquote><div><br></div><div>Should we fix=
=C2=A0vma_merge_new_range too?</div><div>=C2=A0</div><div>How are you testi=
ng this patch?</div><div><br></div><div>Thanks,</div><div>Andrei</div></div=
></div>

--000000000000e5945f0651009ec5--

