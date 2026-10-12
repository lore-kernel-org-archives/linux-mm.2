Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B626CCA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA8D6B0095; Mon, 12 Oct 2026 11:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335C06B0098; Mon, 12 Oct 2026 11:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D64B6B0099; Mon, 12 Oct 2026 11:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E48C76B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:26:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DCFA16100F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:26:40 +0000 (UTC)
X-FDA: 85314351360.22.396972B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A01EC0008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:26:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtErWZhu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791818798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIf7zymaan5CSKxf/DjyAVBgAoSRW75yynnFxHDngzA=;
	b=075ttt9uN37JusRlOarhDB+2csMrqF8ycubgVaZWEyAWxPZ9l20i+J73G9/B7WFpWmLbEa
	0xtgiLvP/rcE2RA2hYeMlc2PSfp1BOrM3SPgmHezPJZr0R+xBOPzucqCrICrM03LvvBgna
	/iJfDDX0AvfQLUowLYDwWeEi3vuhffk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtErWZhu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791818798;
	b=ADHOTEW49O4Vy/cif0x/jtNrdq09QGDrsREuFzdwvuUWQvNhhJ+aogyEy/Y5NG/Iw9sn89
	1DRrd/qUXpfYVJwNgAJezFewnOoRd58RnbBeXa+pIc95V81/Jj1lxqruQgbWXUYaVMSvth
	dITRxmn/XqFAbFSAun/xJIGJ8AzGgB0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C87F243E04
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BFA1F008A5
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818797;
	bh=cIf7zymaan5CSKxf/DjyAVBgAoSRW75yynnFxHDngzA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gtErWZhuz+Al87MVGW9IBaaBKQBCMeAm+tWcH91ZcSS/ECSDRR8WvzWidAPVGpnQh
	 La1tqoxlGTTYWg3r6rWFhRwG8qTZ3hdUDFRD42HJGXTvaQ1/L7AgXO9uEHCEChcaDW
	 lRh+1TZM8yv3ytVwtkZy1RRHV1tFMJB17Pdqe8TLQdp7O8BmwsQz/6OxQBwW9jRyTw
	 TyClsnOtAa0N56NkcISqLclJICRIkNHIue7v0BzNNncI7vHb7RpySQ9weGF3i/OY7N
	 iw0iMz7UakraTLqjy8tVkDS6TsYwAgg2BqIBOyeZda/RT267MaBoE6lIiyyOh5sXzZ
	 Pt5x6L6dQSCyg==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5ba41ea31ccso2192286e87.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:26:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBywMQmFcvqK25c9HtQ9t/yThJhW3+AqKCpVSoST2fgiyC5eBT+h3CBQhUOh+UjqsYDQ/80+3vSyhw==@kvack.org
X-Gm-Message-State: AFq9FYJqmmBvEHSXfht9+DNJW+/aikQAF0xK/CMSQF+3EilMr+50PH6f
	KvBQgmj2qmI+AcB+0SLRGjxI/ESWn5MNH8L0YxeDhLZubGm40+gD5Am/n17Xv8XfyB6r7RM+hlF
	wrKY7CyCYYEeKP9Ftq+Vleoc2LDU7k+g=
X-Received: by 2002:a05:6512:3e20:b0:5b8:b419:b7b with SMTP id
 2adb3069b0e04-5bcde6ad522mr3321549e87.49.1791818795934; Mon, 12 Oct 2026
 08:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260925-ghes-queued-accumulate-v1-1-df50553957d4@debian.org> <56179353-7e02-40bc-b443-80ab8e6b627d@linux.alibaba.com>
In-Reply-To: <56179353-7e02-40bc-b443-80ab8e6b627d@linux.alibaba.com>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Mon, 12 Oct 2026 17:24:29 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0jj0xxNo1V478yEUQNRNqGNH_63_x4h55tvgoaJe2Efug@mail.gmail.com>
X-Gm-Features: AclHuK-xTYsyTmE-qiICl-bXlfsPI5BfK6YWXZYZCnzTzhabJ_eN3RxEEc8ueLg
Message-ID: <CAJZ5v0jj0xxNo1V478yEUQNRNqGNH_63_x4h55tvgoaJe2Efug@mail.gmail.com>
Subject: Re: [PATCH] ACPI: APEI: accumulate the queued flag across error sections
To: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Breno Leitao <leitao@debian.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Hanjun Guo <guohanjun@huawei.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>, James Morse <james.morse@arm.com>, 
	Xiaofei Tan <tanxiaofei@huawei.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kernel-team@meta.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7A01EC0008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: how115kf6rii1y53dzunrks6r1wgidfn
X-HE-Tag: 1791818798-93617
X-HE-Meta: U2FsdGVkX19u1Q33tUjdLG/X5iv6oynbz69Z5BdjA6b0Qub2JDLnIZ5ofWOaFmKX67ps3RgAWCoGcJ2HfPMSX7kMbO+fiyUXzPWJNfUiAGyM4rCOKQq6S12KAruN0nPkDRUYmpVBrvqBJNtprJ3wsxF8bHH5KyJgx5uS6jnJGW4ShE1/LddgPBHbwMQcgr2GR6sfQQzIvrzc96Jlt6H4Mw70l2YOkVAWis3dBY1fyEFTqbUye5TKz+zQtNXQLHpnjRSVWPkaguPk1/nv/g353YpVuYOl/GuoTG8Guz6iSQR1CXxim/2yydH1DVsUZLAWAiPfrp1HfoMZykMyPKRMCa4Syy1SS0q5K44QveCbEffOg20BMBrnKR9uTcMRogLZLeMWU0WQpEl7rvjZZKtYe5miiKop/RUpCMAygJDN61dMCyMii0HaPuFk3ofJ/o1ZDWCTL8wQJMiZRaPjuHXbVAAG1mPJwbyVCEbwTpLws5c/HoNpfFHk2VkC//zOOlgXL+FbNM9Y2Ezj+LQYn2Tloc9LmQn3vTPyamot4999deYJH1sWoB763y6jdrTkPpJjrNerZZO28exwF8yVxc4vhCKUAN8FmNuVn5VuyaSXroxpxBsjNHNnVHPkAwc06hTkxJYCrSRCmdHQGa0Hfb2HmZ0RipFrP2z5IJANhmwLTN5xQJtJ8nf3RBlXHmNhpGWGcGJgIQlGVcG/EA+c+1veR+XPRwUh+bDJht8276kSTHkXekt4Ztrkdi2JJe5h+pt+b4oGmSzMcSA4LnEY9ER60ErXbGV+cC8G6qJ5GmTk1LqzTHxYu0uB6VXYTwDd39RTmUZkjX00ZrSPnCifUJabE+oefE/+BZ5hdmA+cP9tSCRgCly71U3TDvunOGkFDHGKLvfpj2WUK5VsdNy3zLtXohZTjALQEajetlfzL+X/An1hmWyeVZtZAfcEN0TKmQg6FufYGHegQ0hxtm3sIB4
 YbTUCTNk
 AHm9smxtzWZAFCk+n1WbRGMhgy61qT6jXjvZeWI8RhaYYfmx6/N3VbENR53aLlAqghYWqWrK64T0LEDrK561LG7sp4gnZdd6gcwrkmpfNoOvzRahSpmSoOqf5kmKffv/S0hXNQMVal0zDDu4N+/hHEX/cOa9sKyj601GxsVM1xOEpJ/ZO/G8g+0qIAMqJVZW/By3QFylZ3LAUqGMczyLcNKbzEg8e3m+MJG1ZXWyKmjTe0Dd65205FQD6+axx42jGZg08yAB0Ljd4U5ElO9+u9D9gyRiMRdO4u4KZ8kTJ0b3EyLgDdlW2V3kGylPwPBCT0G4H5OxaKQNGQax4g43ael1l3qpxmGP7lrElKMlMAUhJtlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 3:59=E2=80=AFAM Shuai Xue <xueshuai@linux.alibaba.c=
om> wrote:
>
>
>
> On 9/25/26 11:09 PM, Breno Leitao wrote:
> > ghes_do_proc() walks every error section of a CPER record, and
> > ghes_handle_arm_hw_error() walks every error-info entry of an ARM
> > processor section.  Both assign to "queued" instead of OR-ing into it,
> > so only the last iteration counts: a later section or entry that queues
> > no memory-failure work clears the flag an earlier one set.
> >
> > Instead of reassigning the variable at every time, just do an `OR`, so,
> > if there was a single match, it will return "queued" as set.
> >
> > The comment above the check says "If no memory failure
> > work is queued", which is the semantics this patch implements. I.e, onl=
y
> > SIGBUS if there are queue was not handled at all. If we want to SIGBUS
> > if any event was not handled/queued at all, we will need something more
> > sophisticated.
> >
> > Fixes: 7f17b4a121d0 ("ACPI: APEI: Kick the memory_failure() queue for s=
ynchronous errors")
> > Fixes: ccb5ecdc2dde ("ACPI: APEI: fix synchronous external aborts in us=
er-mode")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >   drivers/acpi/apei/ghes.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> > index fe10ab0e02f68..ec2d5ca51db02 100644
> > --- a/drivers/acpi/apei/ghes.c
> > +++ b/drivers/acpi/apei/ghes.c
> > @@ -603,7 +603,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_he=
st_generic_data *gdata,
> >                * and don't filter out 'corrected' error here.
> >                */
> >               if (is_cache && has_pa) {
> > -                     queued =3D ghes_do_memory_failure(err_info->physi=
cal_fault_addr, flags);
> > +                     queued |=3D ghes_do_memory_failure(err_info->phys=
ical_fault_addr, flags);
> >                       p +=3D err_info->length;
> >                       continue;
> >               }
> > @@ -951,11 +951,11 @@ static void ghes_do_proc(struct ghes *ghes,
> >                       atomic_notifier_call_chain(&ghes_report_chain, se=
v, mem_err);
> >
> >                       arch_apei_report_mem_error(sev, mem_err);
> > -                     queued =3D ghes_handle_memory_failure(gdata, sev,=
 sync);
> > +                     queued |=3D ghes_handle_memory_failure(gdata, sev=
, sync);
> >               } else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
> >                       ghes_handle_aer(gdata);
> >               } else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
> > -                     queued =3D ghes_handle_arm_hw_error(gdata, sev, s=
ync);
> > +                     queued |=3D ghes_handle_arm_hw_error(gdata, sev, =
sync);
> >               } else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) =
{
> >                       struct cxl_cper_sec_prot_err *prot_err =3D acpi_h=
est_get_payload(gdata);
> >
> >
> > ---
> > base-commit: 587858367581b9c55c3690f4e63382ad622719d4
> > change-id: 20260925-ghes-queued-accumulate-591c8ac3b32d
> >
> > Best regards,
> > --
> > Breno Leitao <leitao@debian.org>
>
> Good catch, thanks for the fix.
>
> Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>

Applied as 7.4 material, thanks!

