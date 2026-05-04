Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB3F0CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 19:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01616B0088; Mon,  4 May 2026 15:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1BE6B008A; Mon,  4 May 2026 15:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979516B008C; Mon,  4 May 2026 15:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86F786B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 15:54:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B60D11C0189
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:54:43 +0000 (UTC)
X-FDA: 84730790046.08.F957FA4
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89D8CA000C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:54:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LgS5fPgq;
	spf=pass (imf15.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777924481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7TlWmjvuaWTbdKH+xTGjgyMdRT3xF1i67XyiWIDUsc=;
	b=nk5cJWBaeH4k4jKYASI+OI3kSW4SNcNLrRQmZkS9wXXxabdLz+OUHtg+mcN431Pqk12GDC
	oHyUXKX0Vevfj+eE+XJ+GE7wmzbFtn0n5iLMRiF3NgHJ+4OWBTgUaBmYmZWM8pbOy2DSR1
	E8YJG966mwXhiu2PvLGLr0lX67Hc0H4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777924481; a=rsa-sha256;
	cv=pass;
	b=RLYO2Ba7vEyYB7O8lES7D9BOnJ3I36nQDLgzmfxXG5Il38kAH7XPGl/moWB4OBXl4uXx3I
	wNKKyKbAp+r32KC5yZo8DJCd4l5CmUf3Y2nSA6b4U3VVdvT4CODzgUdedVDBXeG50QO0+z
	GbePooZi+qEnAu8PXH/xkg13OGp0xbs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LgS5fPgq;
	spf=pass (imf15.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67b6a6bd7b8so1541209a12.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 12:54:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777924480; cv=none;
        d=google.com; s=arc-20240605;
        b=CQG1buj+YrLCHvJwScv6Ei6+MfGIiB/9MljyKSzVlJHb7OzEMCHCn6WOmO0cMYzEL/
         eYbyBEWZrGvJPz9L9ZT16IYS6VOwmFd83OxDwLBhE+iANDpgNYTVa8zdLXQ7h+EATr2p
         n9yUdBRDGOwj6oUOSOc2EnQX5hl0BtQF41GzasohE4WYjIHg1ljBjxBZjUgeUYDf2OF1
         BDPVEdDXkZ7y/9qhRUVmxXIcbR9LPsBiQUH7EfOtYeLvQ+RgdEFkQJNdEXtvg0iMN8tr
         Q2QAsuEkq1aYTTBWUiEOyu0CXqkQ0EHU4IHzbILrZaJ6UWwKcWo4JgLC9TB1IYtNBSEI
         dkrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=f7TlWmjvuaWTbdKH+xTGjgyMdRT3xF1i67XyiWIDUsc=;
        fh=4/yMNaW1PVWPrgoZHYgPKlZ0k04MfI3KP271CYL2AGo=;
        b=lrcUYh4NkopHrKJAns701H7viTERe0M79TadwQM0ilqfnqNfVuP2M5MzI5vpF3Wiyo
         hD+2D8UqmGVlcrdY1dchQ5s9P2+ECGHMeJr0Qqd7gZyKBasODKV+gLQFVi2W5ljBa/JU
         A0Ir04BnVeXcJDKQjbma/XMVEetkscoFDYnmgQivbPNlAXLn3J5iQFtRIbIxN7G59Ay/
         kJG5RKT2i4ENJeitMugkh6tLlrvglbgncqDKuhiD7B+IfQmrkHYxlC6zaqpvh5jNYIOw
         sM9Sq//ppvz04g2ebLJDSR1tccnUx3vCcckk6SUu/C/uWmGijAaTNBr/K5OwNubqLF8V
         UWuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777924480; x=1778529280; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f7TlWmjvuaWTbdKH+xTGjgyMdRT3xF1i67XyiWIDUsc=;
        b=LgS5fPgqq0c+VPogWKOn1iJTNNiOM2o/OwkUJtPwiHP7D/rMtPmfltj4llm3J7g7TV
         QmqbjuY7kNrdQ4K6UZ9LLJ7CAye/f0kpN1bHGkvjBf45dvZKJEEPrWxxBBcAKlQS/A3o
         VNcFPleyCIhMd+pV7NYYlHZhUit37CiABHt0QxzIGuw1pki1tnQ0RfMdOrEcblyuOfKO
         uzdoUHVNO6rwPqhIPZM4gbMOVkcGWQVtrmcZ4VWJSE3ufx3Jr8/wwZXOIw1gAhaXPi3i
         KnMqPs1E4CoI4akwFSC/7P0RK4cjgeg8/eBTbdmB+wd8Wjq5lXpRYXWEBKWJMnGq9PL0
         rkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777924480; x=1778529280;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7TlWmjvuaWTbdKH+xTGjgyMdRT3xF1i67XyiWIDUsc=;
        b=IIGbLvYvVwg6zuo/Tl3yDMOcGLIVhl3Bj6oRK8o+27ZmT/EbXJN4IuvgV4QQVQsVyL
         WoMvRTTox8PpgdRCYUfTYhQeuA9S/zs4t3y9pri4haLsaydYWxNhYRyogkXXAtZX/u2l
         hnt+PLvyVSxqVojX00y25wkNGK6h7s7fSpjYo1Vb00Qu9NlMs6ReSiR4hrxnuHOc7Rsk
         2Q3LCyyI44SrDAIlIr4zJWcAGB9uVXo+9Q6cVMXukyy3hiJHbcf0jxGaQOV86QYROonN
         00DaxVmn51L1ljKBvj4NBf5lBQ4JIsljxQUb5uXFErzyK49Yc5orEOG4uyoLKNzGnhhX
         SZMA==
X-Forwarded-Encrypted: i=1; AFNElJ/43F63SMk/Gb2ypp5Mf30vzNEtcejvihoLd9XFEHQkYBWRECpipev1vNe/1aPKMfxsFGW3/s3XUQ==@kvack.org
X-Gm-Message-State: AOJu0YyYEHwxR2vJ/PH919ueQw/FJfTSIEoqQfWS8W4rW9+S9XzlCE49
	N2mIovJ3uf3MgDG4zimLyMdSKYzA2myn9u0+KyneNlHogevOiMClrtpHU4+5j18kTTANSNsUmas
	YefRL7PfqXsxmI8T8yWBELfXiexQNGgs=
X-Gm-Gg: AeBDietaj7N4PLD38HqqEI4r4e+1rnFu1OothfDhxEERDLAVtVtCcc+eDk148K9GNTY
	s+4odxtjXdo6ZjOpeIzsTom87Ig4OjICAL1Q8zv0XE1mqFxJl37gFnm2ne6HZ3DcZ9i/TE2eiBn
	4o8gyBgqFVY913n+aOrSZtCSMdxcUfBAJQGtFuHHBROn79e3M3X35pWsFJfd0PK4zqAVSiSnxHb
	FFbu+mXQo12aR7T3vEdlyESRfqyjZUoMW6CAJ2WmVXxhaYCLyZv3+0llY/nFvGu9gSj0WP7LmxO
	Dk4Fg+0YX3046HoIl/z2Yd2JGMGyHO8=
X-Received: by 2002:a05:6402:3d1:b0:67b:7e67:7f5f with SMTP id
 4fb4d7f45d1cf-67cc393a57dmr347310a12.9.1777924479556; Mon, 04 May 2026
 12:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <CANaxB-y=SD7V7dcBXuAqq8=p2R46SAr1uKZtMACynvk1=Cftqg@mail.gmail.com>
 <20260424221126.1238744-1-elaidya225@gmail.com> <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
In-Reply-To: <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Mon, 4 May 2026 22:54:25 +0300
X-Gm-Features: AVHnY4J4P0cuLEwYAXYzy4xMwAuhavSYa6Cqx9DgwPVrD9WwW3QZr0SDr-J89nw
Message-ID: <CAP48DwbO8zq3dczf8Xcy3JxaU8eaU5zLynitXB7dk1kse-nNZA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: fix VM_SOFTDIRTY propagation on VMA merge
To: Andrei Vagin <avagin@gmail.com>
Cc: stable@vger.kernel.org, lorenzo.stoakes@oracle.com, linux-mm@kvack.org, 
	akpm@linux-foundation.org
Content-Type: multipart/alternative; boundary="0000000000000aa0d50651034df8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89D8CA000C
X-Rspam-User: 
X-Stat-Signature: j9e4n4ikzzr6szagyshsi8cebmpkcn8k
X-HE-Tag: 1777924481-83834
X-HE-Meta: U2FsdGVkX19wlMsvgbwrfBC+VezQdPK9EhbYau4p+VZAZwuCW1m/VD5SulfHHFoiI8XmGbCMinPO6aMGL5bz5Yzl+EX51/TkPhcrZv3w++cMaa23FhhXNGKpaPW/IhByRTWK/f3T7rzDXGE3DYpajQ9idMWWCZ0lDJK+otVCfHI8eUL9uebYbRxVRLDcyP24zk0tbnSW0aj/lWh/gJPhRS1rC0gGzgqwrMvmCWaY8sa6P4ErSM95up1wBsyDikBlsJuinlsMMhZAAZOZcCclmk1R1fhthYnZ98njpJuf+iExlK81Ag63SsMP1p4Ry/ac1/K3mAgKCviu8V0i2TGz9IJI+C2ZORWD9ZpEwnr5b1sP6a9Bc31xbkSjbT8jU56P2yp0Qsw0edGV2HuQhiYsvRbVUGggi1m1kTUrk/0hizenM7VSm0GGzDEwFRIJN2CY2XGj2cW2qP1pDcow1b+HwdG3hFMoiR/9MvU5oKUHqlZ0BZYExn7ANbzz8979Mf3PlNAcFovX/Q33B/+HuHeYAJK5TRqcpbzZ3R4VBwqZtqmVeCS7654CBmDdwo16KBUkAQPlhwtf5m92M+BABRbCNXaCDJg8AXxIeVb/fRA4LDxwlrFoc0CdqjuMxrjc/iLg57IdvU2ynMIcpMGsPy15ATUZ1M83wu9hVXQ1rqH6mDd8nhMGOdrWe8GDNeri4RjXdquUlTyx42O7EALkPBLSkUoBMWcTOy8p1gQ/WR0AgnoSiAMWuvXkrsBOmRu4fcx8B5+i4rHK+hWokpkTVQDEmMkcE592CHzGPER3GJSomc3ah3t8dEm3rCJrxHIGOheCMKEYPx7lrOiqWQNV+jnySJLtqlHh8oiDNsvPKv7ovLL3SaSAxDo/HEJvre6dAsvLjM4zGq9Nm37T9SLJdVEzYAIoXbKX4E+Xpk7Q5kdK/DKPusfwtBJDyBqNtB0eAXD0lb1OoTH5gh0N671qRmw
 g5YZEKdG
 liEDZcYJNMD9ri/YBzM/yL0H6jrkcyA9R/PH3mCkbMKmA2eft9D3iM54bF+XInoQeWHRaPWvmUCvCo4lOkq+7kh7K+xEYJa6qR/fRgqr++lDENAGP7n6QjYWRN/ug5TnrXUB9wgQPnLMyVW2k0HV1purSux2Ct5u5sJI15lmL9JBWsS/iID/se8wlld3sTcTbAOEDj2150KGtUHOr4lYdEylBjVMgnQ//ee/XzpQanndJsDY2lX6vHojs5vmrPkgtNo786EuAr9D0HDYN7PQs3HvQovr2fMbqK3dmyvC1xPxnsG2pu2aaCQEFOpvmjqPXT2q+aCXZNXVX73qq/ksagUhtt8eIY3J3e5jhoQai7CMFdyhOK97GdFio1kec7IP7zA+KNZE+v9trgqm+AGlSoarFvLN2OaFW9mwVqdj62blQyGM2hVVho3DLFtt35Zdcp+feMTro9IgCYtSQqf4Pdzd1yvCuWJrIXsz+Czdih0FtfXAYLXdP+gM+bGZxvmaxtgG7bh+KsMJ9hF7ZQ8mO8dXYKxr8A4PMD748prQvL+Jh83GJbSD9XhJlC5IodiJdSCNac65UhYUWzrQc/jeVgfGmI9sX5fGnSBl6TxKJVdXR3pLVxAq0IyxmFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000000aa0d50651034df8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrei,

Thanks for the review.

> Should we fix vma_merge_new_range too?

Yes, vma_merge_new_range() exhibited the exact same logic gap where
vma_expand() leaves the merged VMA without VM_SOFTDIRTY if the target
sequence didn't have it natively. I have added the exact same fix to
vma_merge_new_range() in v3.

> How are you testing this patch?

Testing was done using the CRIU ZDTM transition test suite
(soft-dirty-merged-vmas.c) on virtme-ng. The test enforces an unprivileged
namespace testing environment (ZDTM_ROOTLESS=3D1) where it tracks
VM_SOFTDIRTY across merged VMAs. The unpatched 6.18 kernel fails this
incremental tracking natively, but correctly propagates the bit with this
fix applied.

I've addressed the formatting suggestions and added the Fixes tag to point
to the 2014 commit (34228d473efe). I have just sent the v3 patch to the
list.

Best regards,
Ahmed

On Mon, May 4, 2026 at 7:42=E2=80=AFPM Andrei Vagin <avagin@gmail.com> wrot=
e:

>
>
> On Fri, Apr 24, 2026 at 3:11=E2=80=AFPM Ahmed Elaidy <elaidya225@gmail.co=
m> wrote:
>
>> During VMA merging, such as through mprotect(), VM_SOFTDIRTY flags could
>> be
>> lost. This breaks tools relying on soft-dirty tracking, such as CRIU
>> incremental dump/restore.
>>
>> Upstream resolved this using a broader VM_STICKY infrastructure (commit
>> bf14d4a05387 "mm: propagate VM_SOFTDIRTY on merge"). To minimize churn a=
nd
>> risk in the stable 6.18.y tree, this patch skips backporting the entire
>> VM_STICKY series (9 patches). Instead, it introduces a minimal standalon=
e
>> fix.
>>
>> VM_SOFTDIRTY is intentionally excluded from normal flag comparison to
>> allow
>> merging in mprotect. This patch ensures the resulting merged VMA retains
>> the VM_SOFTDIRTY flag if either of the original VMAs had it.
>>
>> Suggested-by: Andrei Vagin <avagin@gmail.com>
>> Cc: stable@vger.kernel.org
>
>
> It probably should be: Cc: stable@vger.kernel.org # 6.18.x and
> the prefix in the subject can be [PATCH 6.18.y]..
>
> Please add The Fixes tag to the commit that introduced the issue.
>
>
>> Cc: lorenzo.stoakes@oracle.com
>> Signed-off-by: Ahmed Khalid Elaidy <elaidya225@gmail.com>
>> ---
>>  mm/vma.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/mm/vma.c b/mm/vma.c
>> index 5815ae9e5770..03728d855684 100644
>> --- a/mm/vma.c
>> +++ b/mm/vma.c
>> @@ -978,6 +978,14 @@ static __must_check struct vm_area_struct
>> *vma_merge_existing_range(
>>         if (err || commit_merge(vmg))
>>                 goto abort;
>>
>> +       /*
>> +        * VM_SOFTDIRTY is excluded from normal flag comparison to allow
>> +        * merging in mprotect, but we have to ensure the result is
>> correctly
>> +        * marked with it if either side had it.
>> +        */
>> +       if ((vmg->target->vm_flags ^ vmg->vm_flags) & VM_SOFTDIRTY)
>> +               vm_flags_set(vmg->target, VM_SOFTDIRTY);
>>
>
> Should we fix vma_merge_new_range too?
>
> How are you testing this patch?
>
> Thanks,
> Andrei
>

--0000000000000aa0d50651034df8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Andrei,<br><br>Thanks for the review. <br><br>&gt; Shou=
ld we fix vma_merge_new_range too?<br><br>Yes, vma_merge_new_range() exhibi=
ted the exact same logic gap where vma_expand() leaves the merged VMA witho=
ut VM_SOFTDIRTY if the target sequence didn&#39;t have it natively. I have =
added the exact same fix to vma_merge_new_range() in v3.<br><br>&gt; How ar=
e you testing this patch?<br><br>Testing was done using the CRIU ZDTM trans=
ition test suite (soft-dirty-merged-vmas.c) on virtme-ng. The test enforces=
 an unprivileged namespace testing environment (ZDTM_ROOTLESS=3D1) where it=
 tracks VM_SOFTDIRTY across merged VMAs. The unpatched 6.18 kernel fails th=
is incremental tracking natively, but correctly propagates the bit with thi=
s fix applied.<br><br>I&#39;ve addressed the formatting suggestions and add=
ed the Fixes tag to point to the 2014 commit (34228d473efe). I have just se=
nt the v3 patch to the list.<br><br>Best regards,<br>Ahmed</div><br><div cl=
ass=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_a=
ttr">On Mon, May 4, 2026 at 7:42=E2=80=AFPM Andrei Vagin &lt;<a href=3D"mai=
lto:avagin@gmail.com">avagin@gmail.com</a>&gt; wrote:<br></div><blockquote =
class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px sol=
id rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div dir=3D"ltr"><br=
></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr"=
>On Fri, Apr 24, 2026 at 3:11=E2=80=AFPM Ahmed Elaidy &lt;<a href=3D"mailto=
:elaidya225@gmail.com" target=3D"_blank">elaidya225@gmail.com</a>&gt; wrote=
:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.=
8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">During VMA mer=
ging, such as through mprotect(), VM_SOFTDIRTY flags could be<br>
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
<a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable@vger.ker=
nel.org</a> # 6.18.x and</div><div>the prefix in the subject=C2=A0can be=C2=
=A0[PATCH 6.18.y]..</div><div><br></div><div>Please add The Fixes tag to th=
e commit that introduced the issue.</div><div><br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex"><br>
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
</blockquote></div>

--0000000000000aa0d50651034df8--

