Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C227C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F18E6B009E; Mon,  6 Jul 2026 04:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A436B009F; Mon,  6 Jul 2026 04:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7933B6B00A0; Mon,  6 Jul 2026 04:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 47CAD6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:14:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0F5AC1834
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:14:18 +0000 (UTC)
X-FDA: 84957639396.06.2A3017E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DA0A9A0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:14:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYRdQkDO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TB+b0ddrTLheGoCg94qx2Bfh8AlH8NtYAV5kGOWY4PU=;
	b=MDCp0RbZKurSbHyuyKiLzWrn7XmTmxYmDLx5thV6/BrrL0YjcL7Zoe8dXgcypR/EC4cs7X
	m6H0LBT8Px1ON9Xcz+bUCWL6saEhPPecsdRioJERKvBUTYN3Hn+7noGveNSdmnU7jsk+Ef
	CK4BLBUn54TxJpYYbkktKmxOju8TDaw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYRdQkDO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325657;
	b=Hk+F4eEaJwUqQo3mZLMk9HpSj8ul9E0vOjSwsMonSIip/mxhSropUdoyLnAo2zXNmxGuwe
	81QQmGWfELoEPhk7VrveLiKoZjYGW+0JfQCI/lxZ+iJQjK87yUBsz6qz3p7CSA4mSF4QWM
	b/iVl51/xJkYoRjSSAtRBiRLzE8XTI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BACFA418FE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9D91F000E9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783325655;
	bh=TB+b0ddrTLheGoCg94qx2Bfh8AlH8NtYAV5kGOWY4PU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aYRdQkDOspVRkcqAGAPaMoGt0RdD+PLqNNjAV9dF1bgA/Q5oVz6VAzQUVGNet7Dei
	 n4Yp6A/+8tA513pDUMLQnseKukhZQSousPebV3GoeY047cPKW/h5+yM9LqSicKEc4D
	 acr8lemOdlSrqbYDLVO5wEAClD8786CLzO57yc7DQt3NNuyLQ5K1OTSlNJtsDh4KNu
	 DErZGr7w3rWxstqPh1M+LCKCDA7apTu9eaiYAdYyvI7riXq0YtX45Kw3uqHtLHCHwF
	 wLP0XRLg/OvbRCNWw9jB7jD4jt2GcTTa41dg9EXDqrAzKEXemiWBUUtr5HJJ1/XMts
	 rU6zZii9aV7Iw==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e85499ffbso234034385a.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:14:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpkvMYoETyrTqOcKDKWv5OqJ9PkP+WlHCF1+/uqTT61Xq2P8pQXMPEcSuR+ATMk2Tjm+xsACX2DgQ==@kvack.org
X-Gm-Message-State: AOJu0YyC3fQx/sXNM9BoStkZA5UEBXFHQZ+geAsw73xEhZHqjnz70yOI
	8vleAMuacoUyjkRfVdNNLGOgMmHfYWRHei26UqFQBDKAfEMaYjY+NzydStCA+ZScH4w5QTAXLpA
	qProKwH7NsrWNryVrcdnkX75HifZ+jYc=
X-Received: by 2002:a05:620a:1a15:b0:914:7b4f:cf5b with SMTP id
 af79cd13be357-92e9a323027mr1226259485a.16.1783325655004; Mon, 06 Jul 2026
 01:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260701235955.36126-1-baohua@kernel.org> <20260701235955.36126-3-baohua@kernel.org>
 <3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org>
In-Reply-To: <3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 6 Jul 2026 16:14:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xoMpPE3SJfGrvoRS6PfzENZ1cLNG+po_Jt+XOABGsWMQ@mail.gmail.com>
X-Gm-Features: AVVi8Cdjl0puxSjtBjIfqSnG5_xGwlRqh9d9ax4CxrV2obqq1fsCUOSUJyvWTbQ
Message-ID: <CAGsJ_4xoMpPE3SJfGrvoRS6PfzENZ1cLNG+po_Jt+XOABGsWMQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev, 
	chrisl@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DA0A9A0005
X-Stat-Signature: qarm8o1tp9yixftyrzfdia3zrjcwnbmm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783325656-300301
X-HE-Meta: U2FsdGVkX19FOPrJzQtS0RWUUvizAURdvnDgSHK4EXvrE8I+vcyGl1RM+LYJ5nuKXoaWHCk/hFMItzMuPuvREM4M8AjoYKrYUzq4Dvl9d/beJY6mK/r89VNEiItgU4PJdJY1tmpAY50drX+rmYJjUA/TJF3XlOmxTFGUeGYzw9V8IQIwei5FNLyA22kpPfDr40A34SZEgAa2ZnNR++9ixdNn+/qMvmyqjSKkn/9bhtEZUt1MEeEP9atD6LehBAJi4SxtrskbtiYj/KE1vLgsBARQ4oyjYWZUqg9JyJqZzDMZxvJ7sZKR2yiA1jpX+hava1IApGTyRzyqm8SP8VKu34TaJi9dXWBxsvGx/doS0NfmEXQIGTmPG+FDXv+5rOxKGa4X2mbyktvz2NR7UtUqIiSm6JRwXSWZj4HznYxi72HMYzI2+iL0AIoQrd1J5xdpFriRYgRIYGWNpQ15U1V2WFcU6WlB/MhowxKj8SIfunaO0MbVtIMAXf7wSQmMOdljg9U3AOqxSnsaPKEW3NURkoNB0OI4iCoHh1+Xa1ODjPxd+O11txEVO46fzd1u+rXg3KyO0rWlTm910E+QebHCHuASg1QN3fRjSTR8vg2LjMS+CzZ0DENkh1vrDG2Gd8hKciGIplEo4x9mRZBcPwg2UdxpLBdDK62SYKlYkDrikFSoDaZq9GA0CzwOS/E1SKmEXHQzJea+jYse78A7jNx5VfbOJobNYS6umvYbWxHLBOxH2WjaMfBdB1qLKDo1kOqC0J5CG0Inmwq1gHXTRnRx5HyJ46qdVLQtsJtlEsCzAkfBcczlvJ7rQvzMfUSOl52T47Or4XwMY2mIvfU2Yd+mIQsIqh1bsyYfphhISp5ueugyV7UyOPZFL6BURVQjIJfAOls/OEfCCPpiGblbhJ1BQxD03ppJRgQ7yVACJRZqSN7JGg+QCtEG0zrW8YOWahjMEN7WyzAWPm9s6lEsZNS
 e2Gz8yJS
 zqZei8V1W3/1M+egxxMheZV4FerE0xREReXi9vy0cyU3AwsNLBGy7nLwxPK19oEK8/4lXAbTV/1oETe2YvqfX4Usmdfl8zKelSXXx88Tqm2dzWGi72hdxv6IJp6F8Dq4zx8i0sIJGk/1KAcRTf3I0fPt3ribN6JJ3Z8la7S23EMhUays04tuabWnAZTyiL1IcqEe+aF9ww7OjzJKLrN5kX2Axn7awkirs2/Byi3O15jCyHsH/0hkssjsrJLOqzkOd770cNAmEWO18g0tNuGLBMQbl0C0DeyxFhIKzhW5I7tI2jGVOzuW7Nvxpz9dkAhMp63OHKuuxidwr9PKjoi4ZKV2IQoghkqVMIRlF75fijGd5HcAHUtckUduIlxYmK338zuCE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 4:14=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 7/2/26 01:59, Barry Song (Xiaomi) wrote:
> > The "we just allocated them without exposing them to the swapcache"
> > case no longer exists, as Kairui has routed synchronous I/O through
> > the swapcache as well in his series "unify swapin use swap cache and
> > cleanup flags"[1]. As a result, folio_ref_count() should never be 1
> > in this path, since at least two references are held (base ref plus
> > swapcache). Remove the folio_ref_count()=3D=3D1 check and update the
> > comment accordingly.
>
> Sashiko points out two minor things (one flagged as medium, lol, sure sur=
e).
>
> Here, you can clarify that folio_ref_count()=3D=3D1 is true for freshly a=
llocated
> pages (due to the KSM check) in which case exclusive=3Dtrue already.

Thanks. Sashiko's comment below seems valid. While there's no
need to change the code, the changelog should be updated to
reflect it. I'll do that in v4.

"Is the claim that folio_ref_count() should never be 1 in this path accurat=
e?
When ksm_might_need_to_copy() allocates a fresh folio to break KSM sharing,
the new folio bypasses the swap cache:
do_swap_page() {
 ...
 if (!folio_test_ksm(folio)) {
   ...
 if (folio !=3D swapcache) {
    /*
     * We have a fresh page that is not exposed to the
     * swapcache -> certainly exclusive.
     */
  exclusive =3D true;
  }
  ...
}
In this specific case, the folio refcount would still be exactly 1 when it
reaches this path.
While the code change itself is safe because the KSM copy path explicitly
sets exclusive =3D true earlier (satisfying the new if (exclusive) check
without needing the refcount check), the rationale in the commit message
seems to overlook this scenario."

>
> >
> > [1] https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a03=
3@tencent.com/
> >
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Reviewed-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/memory.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 87da78eb1abd..71e9d394816b 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5046,13 +5046,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >               pte =3D pte_mkuffd_wp(pte);
> >
> >       /*
> > -      * Same logic as in do_wp_page(); however, optimize for pages tha=
t are
> > -      * certainly not shared either because we just allocated them wit=
hout
> > -      * exposing them to the swapcache or because the swap entry indic=
ates
> > -      * exclusivity.
> > +      * Similar logic as in do_wp_page(); however, optimize for pages =
that are
> > +      * certainly not because the swap entry indicates exclusivity.
>
> s/not/not shared/
>
> but likely you should just simplify to "... pages that are certainly excl=
usive."

Thanks. I will fix the doc in v4.

Best Regards
Barry

