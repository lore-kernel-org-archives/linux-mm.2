Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B852BF54AD7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 16:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A806B0089; Tue, 24 Mar 2026 12:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB6C6B008A; Tue, 24 Mar 2026 12:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01636B0092; Tue, 24 Mar 2026 12:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCCA76B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:00:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8113F1A02FE
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:00:03 +0000 (UTC)
X-FDA: 84581417886.11.9D1F400
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC61618001C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:59:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="pa3Z/Mse";
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLrSVgO5Jwz0u6hqz5pvyqn1EORmtlk3PJkOIiSuuek=;
	b=R+KsvLZmmxnj3lJDkMxfMCnVr3yeByh7Aw1aO/4uDzsIGciuHUVcj7PGe28tzas2Fw1Oj1
	JereQCstTHMp0XZCC9aDQZTxy7XlyJ0sa9SqGJR42lWP4ViC56kMuIoziyyisR1htgqZpU
	HO6AB8G2B2f4BiSQhuNoA/GLLGuNJ48=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="pa3Z/Mse";
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774367999; a=rsa-sha256;
	cv=pass;
	b=lLFfodrPbLHguHYTh9GTUIo9uwEIGE6BLuwMPWdr9eUFeEqHIn32wwePM4cC9MQ+J8BIti
	pnmMVabf83NcceHvfTUy27V5m99Szu/ugneJHL0fRh7xdszVBpyxc6qkxo2hWLZWsMhGAV
	UaMCpYjGZO+gl0Wpe0isIUyrjSAXD6k=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5091ed02c54so494951cf.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:59:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774367999; cv=none;
        d=google.com; s=arc-20240605;
        b=Sg9mK63CsoVlbSsV8/YBx1Musw2+t9vbaLCSEQuak6q92tzexvd2v7M4lRSoKqOuBn
         1EWoApvUhx8kbiOcTvTRjhwOawgiP9Q6vEtIxzwIan9Td2Yw6jkQhp3FMXj9jE/768T7
         hbraRSrSViDgtVUAFIwb44Zvo/HWKUFJTpXJ5NNxbzTGjeS0K1Gn/cs8c/d0HYt5lcBH
         qrQyboZPrzcpPp+Y+Hib+QBlOFgUqrS/0eOZrVtwCYEDdpCiMI9eVxt/sc8jKlULF5le
         RfgyX3/dHu3TGt5DFKGr72Okpks/MnUH8acqWqRNLJqd2iLwHA60mg5IHRLSPcsLjFin
         kEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XLrSVgO5Jwz0u6hqz5pvyqn1EORmtlk3PJkOIiSuuek=;
        fh=Qbuish54FfbfhQUDagFVJDXGjzW5tD2fXsNRu0MZ3aU=;
        b=NtqEruMo2uZSooFgLQPujNOPx0p+/ACAljHx3qWYzDLdUyjrT1kPns2dCCeupCorlh
         fA0kpAFraNAnTI6ZtgI+Jez3GJFV05tHhe+jvD7tO/Ffmg9RvL8bcsVB5iQIH6iKvTaj
         4hrgIhGDNotPbkEpCplSq3zm0UTIvZTQ1Dr6M9UgYJ8+ZMdyYoUf9LqBLdCKq3RbT5yx
         42xF+wGoGazLSjrmp2RAUjUYKC9nv65pvuVWrnlaOvu3Pt5fOd1W/i9G4K9UBzuBTGtc
         mWQ+DTSMQ8mRg8aZIvgLESu6+JQmYggnZA/PTCNnVHx6+cbYG8x0zAK6eX4h2t0zT9y5
         MggA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774367999; x=1774972799; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLrSVgO5Jwz0u6hqz5pvyqn1EORmtlk3PJkOIiSuuek=;
        b=pa3Z/MseyYynLybYuboFmQpyYwmtuhnfGAN+ZbjLWQ+lfMQIYB+04iSO9aCtj+vZRR
         a4yNFniieTeYywfS6tQBpBQo/RhClZQgIQOpkIzkhpmaYFxMn7uty2UbiaVPLO2hRTUS
         RbzqEuFhxoPw2QCB2xiHGg1CMUQrLULoXuKOcC69VrBLwkM6KAN5GKKWJUzbwAIu17co
         PqgLumZ1SzJgJVhg6kXoqxppTXG2ysQkmG/HP1wly4oS3LO6l+QpBjeprRjIhTk8TxGL
         ERc9u2jk28UMCMXBXjLS27BSUHy5poFxe8FPfrU4MRVSWbt6NPLOI/jg0H5AZgjmH2UP
         eDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774367999; x=1774972799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XLrSVgO5Jwz0u6hqz5pvyqn1EORmtlk3PJkOIiSuuek=;
        b=Sla9KICt9tT/0Hjwt1MRFhxNO+Nx6HzAv+GOXPDPvDjR52Aj3uGVs0XOm8ALIPsl2a
         UmGYI356wORojOVjAopBoYz3LUSgHndpQm1lxIjm3dlGwnhXBY9EnfwdDhIUdzqWi4Gi
         SF4EwVMXzoY58Ho7Aay5SUqlRdWxgcLpHAUh44LLu50cTM9brTkvb8XGKugVGP6P/ZuN
         JdTfmKK/GOiAOrMy+p/lWYHx2LyvsqgLDvjjMAjcQEYZHFkbCSmPHwx5yO7jH3J6pVzb
         r6YIe1YAIRiDVCZFVHGeFTRMWk78UG+UYNev5a2Y9KvtKBRI409AqdgvyjLQFXuwFiHV
         Yv+A==
X-Forwarded-Encrypted: i=1; AJvYcCW1zE0bnB361W0SYYBKpo1YXioQ/VMghnp5gWTtRQ3PH2JiRaftR5GQ7ELvNjOELaMRE/W3QQiWtg==@kvack.org
X-Gm-Message-State: AOJu0YxPxraD23gQ8GmnTemIke3PycPbzr18w+NIA7V3eKFn8xHaOXxv
	BNCWcZLV+pXoeEkAIb48ILJGa7JDhY6rl+FbVnlKQF7XRFx5KI1DcBgmF8Z8Dff0qYNmPrZYWny
	rjtmEMcUtBZIg1HG325P4pXpeS/4k9C7hn205tPL7
X-Gm-Gg: ATEYQzyFqzcG1rn36VZiK9ILhq0c6IGlAI4Q5KWpUQd0hOSj3kJQH54GnwI9K2QAP9S
	ig78mVA1kG+CjKewqZ2q3N7OW/wel8Koli2FQRTun+Jxu34eAsiVvtBU/3O6WZGcSkBPzClKWWq
	9ocJMNAYi+d1YUwrzoAmKIW6jDSRHYbm2ChZh+Zb9HlP5XbMlbFg4mVl/SM7XpdgBqOioLRZrdX
	AaV0efJPcstMlYBjdBMMfw5nMSSqXjtMUM5nHQxRogcnLx+XWmHh+D0gI4Ha+zcy3Mq4PQeZ3zd
	NOlH5YFkdBUwt/cTxNDaEhjhXlMJXJofk7Nizg==
X-Received: by 2002:a05:622a:8d15:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50b6fab570emr14738871cf.2.1774367998125; Tue, 24 Mar 2026
 08:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com> <20260322091723.dbc1a8e45f4412fca43ba510@linux-foundation.org>
 <CAJuCfpGEA17hB4BMdr5a7=NxfeF1RUt0q=_w2WieVv0XoN24Gg@mail.gmail.com>
In-Reply-To: <CAJuCfpGEA17hB4BMdr5a7=NxfeF1RUt0q=_w2WieVv0XoN24Gg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Mar 2026 08:59:47 -0700
X-Gm-Features: AQROBzAMqgNkN_nl_EndICe5F5XJG6Br11eHuUlOIjfDgcmYOvJ6ZgT0J1pHfxM
Message-ID: <CAJuCfpHQ6ru79hjnRnz6vpb2-Rjff8QsM9d_4g9jd+_jb9-qvw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Use killable vma write locking in most places
To: Andrew Morton <akpm@linux-foundation.org>
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	Roman Gushchin <kfree@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC61618001C
X-Stat-Signature: tbw4axukgfnmaqnk66qjfc8xpi7e8hfp
X-Rspam-User: 
X-HE-Tag: 1774367999-806101
X-HE-Meta: U2FsdGVkX18PsyetGAvmRjsTdPSbbehqOV1ZFSAieSrCOmDwTprAOyyvi0En5AZDqj68YYOl3XILRO1a/ZsrxH35IFB7g6fqLBzVuZS5wwMixJX/YyKw4BFxWVF4cJeSmT720V7aqzDk4oq5oP4ysE4lj6RgSkJMjSBKX4GIw/Fwslp3pom7KaNQYoG7UuRQxEhoWTh/QeHbF35Yr4Drt6pRyzPC6r5vuZye1KI6Ni9V6tD9xgsJ9gMKHaQbA4rfQmKtMuDhLkUH2gbUmwWaGUFgNWjYout0uHG9YtDk953i4gwhwXPZw7E/78DrJSv1tbd/niAmqk4CC3huvsvgUKX4Ob7+BV40U3+iHTNWwu/weJP19NR3C6aKYCGzuveQruEQL5vy1X/lQDaHp4lW++ULzD6njUl/zUxsdeZLzpXAsU/VnVjMvuYPmXiPnmWxW0sv/tPk8eRiHC9nAtg7dsl4QLtPxL3yqcNlMziIjpuaWqrEkBttgHhYF3vJ5GH6M8zDEQw0CnnOj6Wt/Co/zOr+fEh/vyyrSRTxA4nom9AoJAyKtDJcxGaqL3rUMI/YQYnz9khYEFjbB4JUCGx5SkCwZR8iNcOeL4upObnUWnyIZr699CaxKluaA7lxiKRk+RdDdSFEIZjunlTIDvTIp+iJGonjWdv0bgj0tyLFG7P+yxw2hLjACvsVHnHkbmlq+D9cZyFzlD1q6zh/woed4SwArQi5PvyWAGeHr7kDqXBJexvZwO+PMVbfP+GAuiP+wOtdDuNGVqcs6Dy9at0G+RbpbqVNm4VvJ9NpJMpEyeex2knP4E0XbMbz0AogR+f7pk2AAIGKWFxcNtU0Bcsk3NHqOfc6V923ezmRHoabKph7DCcc/ddtkfimPjFKnpZDWnF0jb/zjRd6RR/4fDRtFdTnBWjh0cMtAbGJ/r4jHXMZ15gRGU5Oxe5W5G9Fe7eVfs/XX7JSKr64+eAiV6b
 ct3PvEKG
 9GdN4EH6VruWmjjGk5lJTUHFV25i72XVUfzRpDohyceKMda8dqg4Jtd2+Ar6dDTGtfqe0R0yFz8PDXX+CpijKVtCwZPMS4bVCglMMCRde1V9LdxDDqiDljaiVtLi9arFvFhjn2Uke+IXqAUS6/bsP9z0GGL1Bhn5O3lTAqhwqJrictc7LYUGUTeK5aRY3ms45Dz7OSjnA19j6frM7rgTHIpc4xVPiLo3EP5QwxdL4QLfDMTdrzdPYCUDDokTLHG11RLl18hpahE7Nr8knYz2N09srmhH2Qo+X/Dbr1a45bUDv/xpOMzvryJOczjDXBTp9JCr7N3/EpmdURbJdR7AJaMne5R67Sy0AQl6W/vLNJRwq43lSqi9BpORU6Y2PWRukksEEYA2ZC6jU3D215y04gQDh1RNCovnJE5TsgNiXHvBOXeJIT0JD/ijsOLk/OCfkYPfRclViMfdMIMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 9:29=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Sun, Mar 22, 2026 at 9:17=E2=80=AFAM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Sat, 21 Mar 2026 22:43:04 -0700 Suren Baghdasaryan <surenb@google.co=
m> wrote:
> >
> > > Now that we have vma_start_write_killable() we can replace most of th=
e
> > > vma_start_write() calls with it, improving reaction time to the kill
> > > signal.
> >
> > Thanks.  Sashiko review raised a few possible issues:
> >         https://sashiko.dev/#/patchset/20260322054309.898214-1-surenb@g=
oogle.com
>
> Thanks! This Sashiko dude is good :)

Interestingly Sashiko had one false flag: "Does this code leave
mm->locked_vm permanently corrupted if vma_start_write_killable()
fails?"

In mlock_fixup() the path that we call vma_start_write_killable()
happens only if both new_vma_flags and old_vma_flags have their
VMA_LOCKED_BIT set. In such case nr_pages is 0, so "mm->locked_vm +=3D
nr_pages;" does not change the value of mm->locked_vm and we are fine.
Perhaps this can be used to improve the model?

CC'ing Roman.

