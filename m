Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D199DD58CC5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 04:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B2B6B0005; Mon, 23 Mar 2026 00:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC5A6B0088; Mon, 23 Mar 2026 00:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D206B0089; Mon, 23 Mar 2026 00:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E2E9F6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 00:41:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 980C41A09E6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:41:39 +0000 (UTC)
X-FDA: 84576079518.27.5ABE4D3
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id ABEAB40002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:41:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KOAqgzwQ;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774240897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAOJ0UtmqAYIg8tHB0P+xEtvsI4x8Llq84MC09xgdsw=;
	b=nBfJh3AhvkrmUC0+x6IxIKcNRJpbiOd9UwODILYIF4bwLkcxi6ymdiJdwtLH1L+To75yyq
	yDCd6ONwlBGNefrPM5Us5TS7Kap8sKT2Yj9f/UUmoVE9Xtq5j0IkJOmipyxcvazw47t+Wj
	sgmelTQM6Ix+7lywYEA2a4OK/ILlO6s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774240897; a=rsa-sha256;
	cv=pass;
	b=ElNuTmKRqrXJ51tpQnfk4blSQZ07nJ2HThr57VqgVy+JcJBCbF+Z6WoXgSARG7sfs5t1DW
	svWRyAaT1uh5bjs7cn/JXVhP4heiiLfAQkwqqQdwN7XAMHxvbDaKrZMevAqiCpbjAL4rwU
	FjPMrFcBWslFR48SEFTXY4AixpRumMQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KOAqgzwQ;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-509062d829dso1025351cf.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774240897; cv=none;
        d=google.com; s=arc-20240605;
        b=U4UPmFoOeuyoG+gPiYMRBNWXyZ4gNIYAUcpQ3t9VD50+w/jzSl8QWinCAe0j53gHdG
         cY0at4EArQdrt1G5T5Do13M+qwWDAMD7w2PDGzjBThqJZTd7jfyEVTYfuAZHHyFfFME5
         a+Z6Kl8rAmM0XTUJv+QD2SQhiHENUISDpVgHhnfr4a1SDUbzyoyoVWURZzOBBFV61HP2
         4rH43oAa+DjTM7NFp2bU8MF42ZssJNLjiP6h2BbE5O/2NZDQlc42Htgo7qp3J8Ul55EH
         YaBu9JAMGmVn5sng2Cqlmk5P/uwxwJH+hMgJCrkbpoCq0jPZnnda/4DekqYF1fXS5SuQ
         lmJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uAOJ0UtmqAYIg8tHB0P+xEtvsI4x8Llq84MC09xgdsw=;
        fh=JOKiY+1Q1N02P5+52m7XMoiCzjGJp/Z8J3133hdXj08=;
        b=PmbHI6s+Ugw8SuYaft/hPCV3i4BOXwhgpGYAiCgPVf1J0VMdt9IZF6Tw5NWBQX4I9D
         GrxziWtgT8+pjQGqCnM2ReVGiHMpuz3n9PJ/mRuOGiTazCdjYNBNC+zX8C1BzxQ/Q8TI
         sNdLdNzxQGELdNu3S+OvGv9rfvEmfYt2+ZsxGgVYAlzCNpw4tvElF1dpngWZMuAieJwm
         qtmZY55sz4ktZjRGkcW9fUmTIrQxE4SBQKMa8MKYCUy9nnMFfDW6G1WuD5jkL7y6iRaw
         FEUDGK4O9G2Hmy2CMyn/Atzm1m8VteOyU8+yqldM9d8jffLuxnQsfCpPT8dvNNcee50H
         SqIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774240897; x=1774845697; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAOJ0UtmqAYIg8tHB0P+xEtvsI4x8Llq84MC09xgdsw=;
        b=KOAqgzwQJuYEZrdZhVInVUertgxrOmmGxN8iAaQ9mMkbXTxRkCqBqQgcN2j8GyALcr
         jKgj+mcOsgnnYwcqrZQgWbUiPV/LJj/UhAoFK6bn8PGd0gQAeG8aQ0CMxlIjUNV9n/4h
         8HH6FQDAfGSkoPWwZspIFCkXJuRJFU5y7UZgDKhVvyMVZ67FRxXIMLA1EWK1xQ1YPzMR
         kHF02c12pVKrGTf7Wdw4V7Ka/ke2nRnBssjV7A5Ca4bKTG75K/AbsJaYLcy5kk4Yghr0
         AtIfHu5zc8eES1hCVnCk7DbMyTWtauTGDsNUGwqO0V5i6S9RnQfjgbavb9d6bCjF54TH
         HYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774240897; x=1774845697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uAOJ0UtmqAYIg8tHB0P+xEtvsI4x8Llq84MC09xgdsw=;
        b=VzVpkKqIAkGnOvci/PgcVLVRobe7ypG8oAPSvQEgShEmlwqbJeI1fLXiG/8crtXFPs
         daQUS3WdT7QlFoKUI0gOqamkiN3M62mQzxuIIStJNGzeB8ZLSw/eH2cnR5RXynCZ8wW/
         cxxAijSj/4xMnNVqrpfjfbLUHmzyz5KEcdAmdQ0RERncCI8GGH/sWGM8IPKZg+LBLLdK
         2KDK49/P5xPxYmbRQs/3Oej+psKbh6ptf7csVNSFcxZgnOp835i4Hsc3Tq25F+M/mVec
         GXXnvGJvSSJi19Y2PLqRmGCiocS75Nei7M+uEX2Fbe6BRXCg/OAifHj3DqzG/57Mar3+
         AcXg==
X-Forwarded-Encrypted: i=1; AJvYcCWZBxMFORBw5OHrPBTtaQkYTOY2JTx76Qz2tXf/eXi21nkH0yTDLQRILGVzTwmalMGyl8hpu8qyuA==@kvack.org
X-Gm-Message-State: AOJu0YxzQ9IorVaE6JSzSjFxUo2r5ICv23UnEwNXsYXqbgRqQ0/jIpYj
	GgF8FZwPC4lLTaVW27kdblVyRZBISsoZKD7ek8q2PH01zVp1vyttwP4RbWjetT7lCnbDXik5HS2
	P8leoOC2d3NupjJHQujJzaOP4TOuAZuIJfMpL0uUb
X-Gm-Gg: ATEYQzw8Vb+bB5XljO+gcX0q983Tgr/XyHe+D67x9Jw9kgstId6T5H7DPRfOYxhHXMa
	fB//074noLvB2EjFn+ZffO5wuCGVhD0cI+Lww04ncFx8NIqA6u1CRq9l4FK/sO47gEO8biRCyfC
	572LRRWhr4qbx1WTB0G3APRc2meLTiNMBrdB3olBFWl6uPSPsSRJqvOyV9H+29/Cx6Z0ikYZbWy
	H0tLmPYcM3N/CD+FdAbUUrJjUdMA+5LBlUYtxSr/x2tDo+D1aZOodHmZ2wd7ofd8uiRS8/c6y7+
	zuQ7Tg==
X-Received: by 2002:ac8:5c8b:0:b0:507:35b2:6b9 with SMTP id
 d75a77b69052e-50b48107de0mr21777311cf.7.1774240896259; Sun, 22 Mar 2026
 21:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com> <20260322054309.898214-4-surenb@google.com>
In-Reply-To: <20260322054309.898214-4-surenb@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 22 Mar 2026 21:41:25 -0700
X-Gm-Features: AQROBzB-kgyO_oEQY20cC0lvKSqR0xCjsdgKi5Q7Yl3nGZ7l0Zr3zEDlsBs17n0
Message-ID: <CAJuCfpHOy7QR1Bk4tA_JNzeS1M2OYEJuuxuZeWjnZoY3u62B5A@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] KVM: s390: avoid kvm_s390_handle_pv() error overwrite
To: akpm@linux-foundation.org
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
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ABEAB40002
X-Stat-Signature: efj6w4irxcjndyxwdoqhewm18bahk4wo
X-Rspam-User: 
X-HE-Tag: 1774240897-803840
X-HE-Meta: U2FsdGVkX1++wRbzbpiO0mIYTkeUYZRCWlDUuWno356EVkiM+dRLaJYk3bPrYl3bE613WMnx9nIULtBqyAnQ2u5ZU/lEtCet9Gz/vbuhCh3r7Fo3wCp5291OPVt1exC3Fh9bjVkIFTXXXDpIBxqdtl9Nvt3brA88ZKWKJk/i6FK21Y6BHQadyjYyX1G7TcDgznOb1NzpcQhXC4zepPKTPCh6Dn6HczxABUaw3fwQpBpYNWOQnGe82Ni5CnHNiWhry7c9HLunypn+jpl7FfcWFC8Vcblnsnk2GMg2rs6qayyCudHORbnV3UygQCmq3iGVF25IIpw9b65SVLZoCdWTPY3MruVqkeSxaza5NO1MnkW2F8WfOl54NvoXSFR5Nx9JByl+Sy+XxydMj3dpteReXsMGKAVeFbN0xvG2BFv0JXQvEvZcKjXygrw08Oqjg1E73Ahfz/jB5sDw6Mt1lJ3i8e4KQbw8lu6+TxWXhgjumMjukKU58QXh0hxp3tpnVsda5AxLO8BuELj5Vg4xoB1wpAZPAEXeJtTiFhMIUN79gEY10jzK/xbFqMVS0ZesEa6TdQaarJvO6DlCcfvYYMcHJJY+6Ava5ZQx4RpBTgW91BkxzimuH5K45dq08TG92gf5d4plcS17nTfiZ9GCrezvtzU8YvFa5wXJF7GVapNrON9vdhaGb9ErWPraD21tCyYRKNRSHqNnidf9StxA0DqDyWUCwD8PYAhX6lVrNm/hFXDriOvbUJ8O2s9Q7ZUwTtU23y5g512zORyCTFu0PdEn8a41tA8ainfEhKUtgAGUA3TRttFyHwpnK1jKBCBI4j/Cc7hP0PVHsdFNf+U0QYFzgsVli0AYVoLSeRWSPJpFQ3p1+hXobI0Ob0RSIvqfNrfZS/OJho3eKGLReDyU6gy7Sk3941V4i+zPqFX06s560K21+v+yfU2VMAJNvImmsxrKE4HBUsMeda1iFDNJusb
 UejJjPr8
 1TSS7BScbiBKvgYWYF22asKCbnNokVGe3PP9YNcN1o1jo6eFt92YFznasW19XyJyEbmWWkLpuC96nbrftFC8sxemLXAAG7PUri1cmugoUkvpM1ypnxUVcFaxEo+3SQUG6mkGpf/Y8I1QGQA7xahZ4Ls2y6XfUuXSOKELFJlSyW2MR/KJo4D7O++1bYCcgKljIZrlwXjt5L42Mh9S6+hAjqWNF1bE5SDSjc/MLVJxRVPMLXC0Jg6PHnKpdOZkMKWcjMXjcI0RMP0n62DxaNIGpUfH/n9BsKUR7E3CMGEq+9Tr2mY65bjKa/vjP0eJrDlaPdDU9Nnh0YVSZq9CXZCUZ/6EZbi6vTWITP5gh8REtvX3LtllQEz+Lg2oNS6vH685FNQJcSdk4OwbNsFlxgGz3lRim43HKo3tP5lNWoL3vWGkuVKYfbhmbdES/Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 10:43=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> If kvm_s390_handle_pv() call fails its error code gets recorded but
> execution proceeds as if the call was successful. If the next call to
> copy_to_user() fails then the original error is overwritten.
> The follow-up patch adds fatal signal checks during VMA walk, which
> makes it possible for kvm_s390_handle_pv() to return EINTR error.
> Without this fix any error including EINTR can be overwritten and
> original error will be lost.
>
> Change error handling for kvm_s390_handle_pv() to alter normal flow
> once failure happens. This is consistent with how kvm_arch_vm_ioctl
> handles errors for other ioctl commands.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 3eb60aa932ec..ddad08c0926f 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2947,6 +2947,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned i=
nt ioctl, unsigned long arg)
>                 }
>                 /* must be called without kvm->lock */
>                 r =3D kvm_s390_handle_pv(kvm, &args);
> +               if (r)
> +                       break;

At [1] Sashiko says:

"Does skipping the copy_to_user() call here prevent returning Ultravisor
error codes (rc and rrc) to userspace when kvm_s390_handle_pv() fails?
When an Ultravisor command fails inside kvm_s390_handle_pv(), it populates
args.rc and args.rrc with hardware failure codes and returns a negative
error code (e.g. -EINVAL).
Before this patch, execution unconditionally continued to copy_to_user(),
allowing these diagnostic codes to reach userspace even if the ioctl
ultimately returned an error.
By breaking early on error, this skips copy_to_user() entirely and silently
drops the updated rc and rrc values, which might break userspace's ability
to handle and diagnose hardware Secure Execution failures.
If the goal is to prevent overwriting the original error with -EFAULT,
could we perform the copy unconditionally and only update 'r' if it was
previously 0?"

[1] https://sashiko.dev/#/patchset/20260322054309.898214-1-surenb@google.co=
m

This might be the reason why copy_to_user() in the original code is
called even when kvm_s390_handle_pv() fails. Then I guess it would not
be a problem if copy_to_user() later fails and overrides EINTR with
EFAULT. We could avoid that override by checking if r is already
holding an error code but that would change current behavior and
possibly the userspace expectations. I'm more inclined to simply drop
this patch and let errors including EINTR to be handled as they are
today. If anyone has objections please let me know.

>                 if (copy_to_user(argp, &args, sizeof(args))) {
>                         r =3D -EFAULT;
>                         break;
> --
> 2.53.0.1018.g2bb0e51243-goog
>

