Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44413606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 22:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kFou5rWh
Received: by kanga.kvack.org (Postfix)
	id 183206B05B1; Sat, 21 Nov 2026 17:24:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134E96B05B4; Sat, 21 Nov 2026 17:24:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023D76B05B5; Sat, 21 Nov 2026 17:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C69BF6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:24:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FEB9C060D
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:24:43 +0000 (UTC)
X-FDA: 85460556846.19.2DD4A48
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 59E4E1C0002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:24:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kFou5rWh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795299881;
	b=TUltkeypbp+dwLeNq5qnpdySNWTRqTQMKSLZL62Doewa4Yhoi+8JyAOn6JO64KgfQZkZDO
	idv+zYFqDFqkQt2dYIw6msDWMRfFHJIo0mjzxb6s+GEz11kG06l1K7w0q3HvaFxq41XWjB
	/JNzlf0UWhprqVnLBJdjiDnKYcrn/ew=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795299881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hz3905wAXZE2z0xpo1pg4iMkZNUnir/n6DiACnoEPHk=;
	b=ZftJhdKvXv/wN7txcliDcZE7z+4OtlxAf/QKvObvFgad3TPrEohJd/knIWbNnfV7iH3Vcr
	qdC+RLTcwAb5pZqVRIdfAR+wNYN9tLdEK8mlFBOzWKNG0QxnhE9exh58FtOzU0RjI0QQhB
	AFXQZXaI5RaB0lVzZqrtshanTaiBJLk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kFou5rWh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-843b6f8e2c7so2043928a34.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:24:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795299880; cv=none;
        d=google.com; s=arc-20260327;
        b=NI83J9I3X05Be6CU7Pc/DE4ZRYAKax+OUdfpUtloKBJQL/KkA0VICRwa6X2xg5iat5
         II2UEz29QJT/vi7wBMFavf7iLuW0LtJNuXq9hvjGZpdBPYczrDOj5roRytxPlCW+TlIm
         dJCEESfN08QPYQ5DHDhfKCwceJ0HJS/sCRvkQRHe6bbzrLXdLHHbvFoS9pHQIr70Vq2F
         hH5ea0C+OfZk7gx31o1jBJtAqTQk8YWqQLl8FBBIOF62h4lBN2peClBBayP/bdPE/6AZ
         dop8jr+kpf7Y0mf4f4i26kwHcIGjn/sfmDPB4PTMty/YgZLWKnbWHQY+0NDcbzwb+R0i
         sHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hz3905wAXZE2z0xpo1pg4iMkZNUnir/n6DiACnoEPHk=;
        fh=rYF7aItcfhWO43dtTqraNgDygTHaOGaPT75t+/ZKtM8=;
        b=WNxn/lgYamuOAfqSm/p5k8oM4wrqAkHr4XX+6vWBnNmTwi6uo/BMnMEY2yrWgBGax8
         ZPsq9ZGfCrskdxLSpQx79KBiLLzjBA6X4JGVTcbLMedy+aaCrO2VRZytCAlG77B4ga3A
         5firn1kKYAhgkZJl1PfxpkJQ6529TuGHiE4hB4Zo7pHb2W+w74zIFf0qrl9olT+I1SeM
         b5IeZ09h9HiypZMOivfI4JKeg/TY6Plx93ka4SbY2402nZQumRILGMgmitWEP88M18Z5
         dbMIRU0GyEe1WxGhMeYR0/pw6MsOTW15Ykk34s86sLRl7uIK01XGlZB1F3KrjpuemFJi
         Dw2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795299880; x=1795904680; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hz3905wAXZE2z0xpo1pg4iMkZNUnir/n6DiACnoEPHk=;
        b=kFou5rWhfSfyOdmpsWVeo/hF+2r7NvgrMg9p9uNVz/eKHXcYgV1iFLT4Poq6W2H7h4
         5wvIiQXgQj6MFZQv1BxONxTATaghDdPbabVAyeeXNRMcExwL0ZUnnfzKcJE2Kex1FmGn
         vuTmIa3SRd67oIohA7XbyYtYxzBZ8wh2Gz7WXKRvtOtVd/Cj0JKjvKbKHcWQcjxi0Q3W
         FRIFVQiwQx/nrWInqh//GQag3x0w8YfDmZbCHA5YFI2DIJ5tCsHFEaBqt1N5guU6e7Pp
         BtGVAhI6gvbw1kH9SCRn9M0LagHQODB/pa1dWP9d7mf9QvARpOiMxVItxdNQxuWZCyVf
         RJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795299880; x=1795904680;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hz3905wAXZE2z0xpo1pg4iMkZNUnir/n6DiACnoEPHk=;
        b=dxOB839LAojiCuPMjegtmDoYCEDkwkGnA/tX5Ks4qUmt8vP80rr3F8iX8w2rYKq1vQ
         0dml7IrFuwYWgwCj19oJnllK7zr2BlCvPoE4EiNY44odNSrJ3RspIB63IiavAfJjT3D7
         SUWtGrANzactUOVPG8q9WZlZaIKQywcBHPKztlHk+BFd0dCD6Fg16FXU/yCGVgkWwpKv
         lxU6AiwqaOgdv45fq425Szh2V6s69MFwKxLYzfNSWIfA2oAN8PJ5JFaLJndO6Ua71OQz
         xdIqL8SI8WP69A+OtmPLt9NQ9rV2mUvmLxuiQ2DWzCV/h6gsi23HuAPAUy+O7+3CZeYe
         oA3A==
X-Forwarded-Encrypted: i=1; AL+hErGskDMHBUIe5KPDgTDd71f0SMjTefAzDmRYYH7iRC5o+8v4RZz4izCEyRXc0WlrSfoeGOykl3t/fA==@kvack.org
X-Gm-Message-State: APuU4Z/+Wdg/eJInSxhP+9D+8067IkbkFT599R1Sc2iZvHYNBOKYiKtN
	/qhU5a4GoKdlTdkq828nSDjHJmti52asncqdzeKEAQzzsi/ip0bQDt1RES2/pJyUSpz12SN4zTT
	3+WgW56Rs2SZgqY5T0sJ9I2Hx5LUs+Fg=
X-Gm-Gg: AZFdTZdSEpPgltwZKkxElok+6DRZbEJgk01hz2J0E3AGLjK/8ZbeNP/mMt4lFzAbVrb
	QYovZipIGFw1W6sHWj+yuCPSDKkCX3wG36jK61C06WV82164o+BEZQ1SCQvaKJz1igIa1eOV++1
	X6mP8u9cHtH18KZ3sQzwF1hjiqp/xUvuF18Y9QaGyXsYsM1aRNL4YirGSW4iPAQPuV3D9H/7BDI
	eoC1FMkRRGeuNcXTDmitqUoq2QIrcTBtHnVnFLIXwWBF8xY8FbUd6G5kMXFlWGXtKdGHy+KW6c8
	+PLYYyoX3eOlfgxOITncVe7g6S0de2YoMOc3ZoRGWAF1b+VYghcEgwWimcg/wRU9KG+1imM53PR
	Or2IAbW6JQqq/8b4G5JHLHTyUiBx032Irmk6S
X-Received: by 2002:a05:6830:2692:b0:862:eb1e:6a78 with SMTP id
 46e09a7af769-8631593a1b2mr8377193a34.7.1795299880305; Sat, 21 Nov 2026
 14:24:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com> <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
 <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local> <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
 <20261121194030.GBawHzrrCNCMpfr7Gx@fat_crate.local> <CAG4KcRKhE1UXwrhscUdSpDJS8R0t7kWp8RXZm8j_9yXYJSQ2KQ@mail.gmail.com>
 <20261121210749.GCawIIJcidCeWs3ij9@fat_crate.local>
In-Reply-To: <20261121210749.GCawIIJcidCeWs3ij9@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Sat, 21 Nov 2026 22:24:28 +0000
X-Gm-Features: Aa3M54pmfzCjwgwOho9jx8HJwewKtlzAxxWUC8EhQd9hmHj0B3lyfXoGWgN4lh0
Message-ID: <CAG4KcRKzXNsvBWuuU2_aX5gO7u4vgKAK+bkrB2vgEFBGu3WJCA@mail.gmail.com>
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
To: Borislav Petkov <bp@alien8.de>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	tony.luck@intel.com, lenb@kernel.org, Yazen.Ghannam@amd.com, 
	mchehab@kernel.org, ashok.raj@oss.qualcomm.com, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59E4E1C0002
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 5d4ngb8yzqq8478m9r1tr16d3dcm6e7o
X-HE-Tag: 1795299881-965095
X-HE-Meta: U2FsdGVkX184+lEOcB/UrUvEBt31yvfoc79NMbISSWzHrSzAWzD6XuRkyqSs+ZCaAxc+8WCc+34P1ejLRxG2s7yVAgYWyR8HQ47pl4omQXOYPSblhBZEiEHPkWha46OjQGbfImtsq3vU5e33Tg9WMETAQyKJuLDzDVwcph+DnabKYXjEjeka94KAq0OQV1Rp9hog+J/PYBagcAN8Ui4rdl/tnrFyIowWD5WRBBPZtKTLGhaKHgShfGpFv64gM3BcmCStvd21AbXzU5vgFVeC6Qi7Xuoe6/Gfyl4ccb40aDXa+W0hZ0bS3wVisDgQkxvithijKEiddmdbAUmgPkxUvVwM53C3Vaq4LjVtdR1sGcwK3nETi4tbQVBg5aTvuaExZh7aNoCKOZjLXRL+59WrpIizIrcrzp763fEH1P2mmiGvnVVAO9tmxOUMZ7adKwu33xqnsid+UxbA2pGlH+5aYFhBeK14Wmbesr1VJSvaXAhvRpOAqYaunaGC8q1izvAWJQsimqDVnknlTANp2c3Lsh0+GZvF/eC8JV1LhSCjjBeqgWM3lnAnkb/bSIt6ljpcafKLkDHLZPm1L6l7f5PXF3Le3CXpcfurQ9oe6Wtikfd8pZsGaeaKi1LiWlUdQ6ozqwqQKJzfnIIRinpXNPwKc3kWaQ1gbJsQxOkbqKnd1m+AGdZCQOIkqD0nccUsqE55qMu+SBGnwNKBFUzwbyI/CwUgWNmYhCBBJdmvwqDxJPEA2ahqtP1BqNEysBWdB8LQ8K1TTmgr0nrMKRgrs4nPz5rQuL3oc7G1pa9sj+CfJVuMwkB2HhE/aXHHib0IPSEqOJcZz1N/0VypY4MJ5jXLbCt6eT1MsokDsLD7tGFypoF4hS0++u5AAJ+v8tNxY2HTi7WO8dbQI74qnYASeAKN1mDsgAcBdYu75dw0rjzg4WcTOUwzQ6CY1INdGEkBjcqKQNZhr85jrkf//W5H7Px
 cyFYtj6B
 j1FKm6IrP2lWCsS9SnZJ/n9ORy2EIPOsGOa1Zx0mpWFKmYoFMMkHP6rVFD7U6sSTedBmJNx9fVAUfNRVuUAlJzv8w0xLyr9LpotrLMfIt/Bym62ViJSqIkAvOWq12ULuh6csjoDxy87F7Z2flqGocCCKqFoOizHU3aR4fh/iRvCrSfoOsAWgRJ/1hEjIGKaCBgv8EzEzQ/ITVBYmp4t7z9lXg9tXsafrRxgvmhmReG3pxZqtDj0uIjOHqC4csutyBqYU7R9TUkZgvYF6nMS3kTYtMZbxW4SuqEGxCsY+YwG5T1QegpRn/tc/wE5aVmffQ+X0COT0Lhu+Rfpp/rari3eryMIh1e6fdqy09uxQLNl76sW8qKcnHW0YU92jtEFmkFbtpzF9ClvjvR326IBgQbXxT6f5CfwFvjBGgoQjKy1w0rhOvGgtnzRMun5lMl4Mp2DVHUE5wioyvtkJpSATh03Xr66lyFfQpRZCQMJjLVwEKP0s/Bvku4odzd53mDZ+U3mJB4a45IM/eh3UWrOvcq9Iee4nHaGPXPCNdMzSRqoEz5DNUyxRbN6K+7VyjCS3/t9e0SN4bnhqzOqaRQ+8/WqpHPDYs+JXe9U4/QKre10+4/ycgNz4eZaODnE5U7CjAPUJB13pp30hebV2WG/K74ZNr0UemdLGkztTWM7TSwAT3xtq80yoHRJ2HPn1qHVRF6BReNCCsRtxTdKRzPJ+b9DM1iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 9:08=E2=80=AFPM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Sat, Nov 21, 2026 at 07:53:54PM +0000, Shiju Jose wrote:
> > Please find the attached patch with the changes.
>
> Thanks, you missed a spot. I fixed it up:
>
> diff --git a/drivers/ras/ras2_mem.c b/drivers/ras/ras2_mem.c
> index 70f7f0b497ed..de5555d2e1b8 100644
> --- a/drivers/ras/ras2_mem.c
> +++ b/drivers/ras/ras2_mem.c
> @@ -117,10 +117,10 @@ static int ras2_get_demand_scrub_running(struct ras=
2_mem_ctx *ras2_ctx, bool *ru
>                 return 0;
>         }
>
> -       iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]=
);
> -       iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
> -       iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
> -       iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
> +       writeb(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
> +       writew(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
> +       writeq(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
> +       writeq(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);

Thanks Boris for fixing this and verified by testing.

Thanks,
Shiju

>
>         ret =3D ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
>         if (ret) {
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

