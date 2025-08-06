Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A96C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533146B00A5; Wed,  6 Aug 2025 11:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50AB46B00A7; Wed,  6 Aug 2025 11:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4205E6B00A8; Wed,  6 Aug 2025 11:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32A596B00A5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:06:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BFEE1A062B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:06:20 +0000 (UTC)
X-FDA: 83746658520.21.96C8CDB
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26A24C0011
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:06:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4gO5mahQ;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754492778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMkdALPxV5bI1ddOoCXO/TX3xqYimqA7Ocq/kfBYHfw=;
	b=rWrd/zMX5EMRsMfEVbvchF3SlnwC2N41p/HsWSN3+96STD9HmN3xbfkAGBG5bOZm9DBqwf
	wLjEeGg2xeHLJAFnne/cPrFTI9kHrB2AeidZWEzFQGyB/oe6TCnJTO/owpOfDGxmOd69Ux
	BHdFojGcbdZKu3TvWXNuUCsnuw6bkOg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754492778; a=rsa-sha256;
	cv=none;
	b=w106WurPj2HEBNsIVt//DxoqGsKbEjIqLgguK9+RLv+kItkL/DxuOu/c5JyYmLvp1KgUuu
	vSQFxdVowvFDlXLukqMmAbW3s4Ovj5jy5y4V/VWa484NhxBn4BAcKsO1MUEevPbi57BWYl
	OrZuIgrcbIt6EbS9KL4liAvaZ9JwnlE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4gO5mahQ;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b07a5e9f9fso474721cf.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754492777; x=1755097577; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cMkdALPxV5bI1ddOoCXO/TX3xqYimqA7Ocq/kfBYHfw=;
        b=4gO5mahQNpBwrhW6bKxbtW2dafU5wD3H7TVrpRebE8bJXc6hRh46KnzP+f8JmWb2ZM
         uujeMW42jDdukAJxH3UnC48XMeDR2etHrcQPxTU0bQa2lYb+CYw+c7a2mlfQ5RxETDEy
         bUW7fVTzIxwAavvaJKEjZAi/KqXMyo07vCaQvmTWl/iY2APDDkxo9MZZUzg0R9VbPmm4
         Lk0Y5buqoOwEG7RUlZwUo7QbKa/hosFr562Bb1px9gYJPgLrE1gmbqJQ1XaCcEJ7gdV5
         87w0ODPOiDSlm+/heIz9M2CsGO3QvGIfxCstZWtX/veUWHbdkFlK30j0g2kpBNichhYp
         KX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754492777; x=1755097577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cMkdALPxV5bI1ddOoCXO/TX3xqYimqA7Ocq/kfBYHfw=;
        b=BMKwmKALtGi9MB2nsi7blkPR+2XvSj1Hbcj7wzHZ1VTsby9IIXTimR7qXH9weOZtFl
         /BqnDKgUaLikV1it4vZlNBr9BaNeSAezmnqWg9U4JHql99NxIyVvgQ/mONSou9P2kNw1
         J8Rhe9oSjm0wPCti/xxTJvR6Aoy1FtkjtNlgITxm4Jsun/97k9uGg8faxCiq37mPPFf5
         lb8dlrqAWjPkGBG3q/TLusd6VLQaVclif9KoSCBSfgayZU9REFZ0MEg7KEvR/M8i/Epc
         S41fyxN87BZP6OKcSOURRHEOPcvhwOsgKbAenlpT4dUk+OF1T21jHtmTFdwHTA2rwB/5
         Zezw==
X-Forwarded-Encrypted: i=1; AJvYcCUEB/3Lsy7CmCTZ9OXQmUJToYs4f5XXWa4SN83N9+UbcbPJk5szcdZUnJDrLnQmJI/PW60AwjZ5hw==@kvack.org
X-Gm-Message-State: AOJu0YzVD9/wDpLsXIr5qd0RpU6hzqT5h+iE+Xc6K1CIwB3s0g6l69kv
	cW0XDXWl4oH/q16vwh1LhjthAGA3nngiikY6VvMF4xDi+QaOzN99X0CBouz0CvMrOg5bp+fTiwZ
	n6UjXNjIoxXDagqaYyQTluCW0qRLprRBP/lPUEeIq
X-Gm-Gg: ASbGncuNdXkfTU/BrhRotyUzDVirWspv5t1+qaffBkbfxfMSI2GQWvtwvt4fMbDiWTb
	gGuZqOcdaZhYTG/mMDQAQThF0R8MWgB0L1tB3aI4KKzDVoHaUI/D5HyOsiprLcTwbcbCE+V9/LA
	9TXBiE6dToA23hg3Ly2MCA3xaRyRN08ewUbjhdzkCejAM7vPT0LvWxwKEPna6Hesh+XegVAaTf3
	EYMX11qfyzf1JtFVgwXXJf02ygegdTiDWrvVQ==
X-Google-Smtp-Source: AGHT+IFxjgJYfLtCzxTqC2qd/VGsYO0V9QbHxfH3kUKXYt+WP9H5eIIUksOBWWr2ADiUXznJbKHJFYhIUDbkwryBSWk=
X-Received: by 2002:a05:622a:38b:b0:4b0:8318:a95 with SMTP id
 d75a77b69052e-4b0904dbb54mr5571461cf.8.1754492776656; Wed, 06 Aug 2025
 08:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <aIz1xrzBc2Spa2OH@x1.local> <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local> <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
 <aI1ckD3KhNvoMtlv@x1.local> <CAJuCfpHcScutgGi3imYTJVXBqs=jcqZ5CkKKe=sfVHjUg0Y6RQ@mail.gmail.com>
 <aJIXlN-ZD_soWdP0@x1.local> <CAJuCfpFzP_W8i8pwL+-Uv-n+2LixgFrzqn2HsY_h-1kbP=g3JQ@mail.gmail.com>
 <CAJuCfpFEf92gTR+Jw+1wcCcT0fEt-SP193NHzpyxVXJA=VAwng@mail.gmail.com>
 <CAJuCfpFeSVq+hq4JRJStLgFfQgmS6SQ7zoFsj4=SeQT89r3TTw@mail.gmail.com> <aJKkjEYmeq93w35-@x1.local>
In-Reply-To: <aJKkjEYmeq93w35-@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Aug 2025 08:06:04 -0700
X-Gm-Features: Ac12FXyjlXEiW5mf5x6iYKFmYX_DWMhNB6rnZ5RUsIFipgSWRnXVMmPjiayC93I
Message-ID: <CAJuCfpGpEOaKdqpqTpfbw1cdHEEWhiu6KRFQFWaM-AKODiDFcg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 26A24C0011
X-Stat-Signature: 4xfrnmr3azm546nrb1h7fr7iddjfmf8r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754492777-83112
X-HE-Meta: U2FsdGVkX189F3HUSufM5GNQjxUoeAaLkNjRRB6Rz2r5llEMq9ZkXFang7rqcXnVZhYnQtbXGCu9ewn14rNW+Fm92dHGAhNtVLs4GyGGCtB2pAVcxXw/NdtPk9zIlqzLLVPSjH836UHPNaSPYnnhmKzmQuVmytZ+qmJoaYMQ/+mp81vnV4X5qWX7fZ1A7SXMzfYOoeyfnogO2h6/qDyjqI6OFsdXj66tdZ5J/xZuAiZm9eH49TL8m6QXn3Q14pwvQR6fkpMWjSiMGTlNxuicp50qjzip4zCrrIpUDrWUstQFKOD+mUidtj78ps7eriMJB2SQdKSPmABycyK4AMgGX/MfzdfHzyk961RAyaPQdGa1QBI+xPV7Cf08op0VnNSb5ibhSIy2apFDKS1BJT8N5jo2hdWUw9vO4vdEubagy7wW41stYsS2o2PMrNmEzIIZXBeiX328toy2LCwJ5HeY+6Ufyu32Ar29mI46i42fq8RRNSCeQ5MNq8qJ9SPwhlXU/kKSSSTJjl5McAJzwbb6ypOUZn+IlLtbCXzp7QrEGKK8t4X/JYFtKJ/S+cu0rcu9EP9ROf6mJWCeFb2bZsdX6oHIDYisLL3ojUpWbPnkmK8sAqnd1iuv2Q0aopxI0qKO8vqWGMsAyaLG1CKCWRaWDxJmoVsMJt53hSUtfIdM8HXhQsKtJBmUEu87M2U1rfVzDHu6Ks3yIqCxdx7NC3w4vNL152kcbDQgC28zvBadleeMz7wH7tKiDm0+AkNdKtKXDHZirDSxYnpt3U1q/YqCiXXACzCEEnPddRabPJ6HVVrQLJs3bdUDbMIXhvBUiJvaHpVYcCQrHQUVw8h1r+TQRy5WWc9bMyktZSgHYa2/2PS9qVZN5VSx0YdKGEi6NQ6Pepnd6Lwt86UbWJJliOQpQ8NVj79EjqxSIED/56pezzWLI+eKZOfLxdktB4SFbR7ezO3qTkPON4XW17F9Juk
 HgTC5Z77
 eaDCT90YxU/PKmrADcrcLTWkwmzx/EZNNJmdDUnIxNzEIqrNQCja+V4sTt10Pr8FQ9boNW9KF0UeEYbwJGYAf19YSfwLC7+hmIoz3qoxhzmKUqmXhTw8oANVRGaBVcGBE3IDdF2Ib/l6G7VvtnN3iPi+j9my+h2fqDajMscbVijBcsKxQYucuaIbW/lEMhQodzZerbCmCtekfqoA/ZgvXpSPgHelLmKCHfa0iDdryN0zeythJc9MnI2QmHO9RpXQ6Br9SBBt/7oRwVXC2hz3pXoe3KuOD43ewZhpT/DgJ3bmxvJV9ecbOT5ujD/oZLv94E0ArSTwfOhydEadjM4IV74RYAbCjNvB42r53Og1WZXFNKJQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 5:41=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Aug 05, 2025 at 04:41:18PM -0700, Suren Baghdasaryan wrote:
> > Ok, I let the reproducer run for half a day and it did not hit this
> > case, so I must have done something wrong during my initial
> > investigation. Sorry for the confusion. I could have sworn that I saw
> > this case but now it just does not happen.
>
> I'm wildly guessing you might have hit the numa balancing bug I mentioned=
,
> that might explain what you mentioned previously on the testing results.
> It might just be tricky to reproduce:
>
>   - We'll need a valid THP (pmd) first in the MOVE source region
>
>   - THP needs to be selected by numa balancing for a check (marking
>     prot_none)
>
>   - (before any further access..) UFFDIO_MOVE needs to happen on top tryi=
ng
>     to move the whole THP being marked as prot_none.
>
> AFAICT, task_numa_work() is the only place that can mark the THP, and whe=
n
> it happens, should see change_huge_pmd(cp_flags=3DMM_CP_PROT_NUMA) and th=
en
> returns with HPAGE_PMD_NR.
>
> [sorry I am still pretty occupied with other things.  I can try to reprod=
uce
>  together with you after I get more time back]
>
> > With migration entry being the only case that leads to that
> > pmd_folio(), the only check we need to add is the "if
> > (pmd_present(*src_pmd))" before pmd_folio(). Would you like me to
> > check anything else or should I go ahead and post that fix?
>
> We could fix the migration entry first, then if any of us can reproduce t=
he
> above numa balancing issue then it can be a 2nd patch on top.
>
> After all, so far we didn't yet prove it, either some unreproduceable tes=
t,
> or pure code analysis.  Meanwhile it might also be cleaner if we have one
> patch fix one issue, rather than having one patch fix two bugs.
>
> What do you think?

Agree, that seems reasonable. I'll post the new fix today.
Thanks,
Suren.

>
> Thanks,
>
> --
> Peter Xu
>

