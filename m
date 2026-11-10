Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201D5606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zQkQ3+qt
Received: by kanga.kvack.org (Postfix)
	id 11A456B00EF; Tue, 10 Nov 2026 18:01:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4276B05BD; Tue, 10 Nov 2026 18:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD1D6B05BE; Tue, 10 Nov 2026 18:01:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC2876B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 582F880183
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:01:01 +0000 (UTC)
X-FDA: 85420731522.15.E7FEF58
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C1751C000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:00:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zQkQ3+qt;
	spf=pass (imf18.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9zfjeLXx8nlaVhvD+KO4LRkpHUPOVyGHHNomAn5t58=;
	b=Yh8xzc1XZrg04CSMG/Yh87ZBu3/r9Vj9QoYOPjxjUCCC7o5f1aID4Bf/pYAi0DG4gPXkk+
	2Ao2OhLcqIaILIpZ01r7Ut+23+ojncBURAnJNI6byO+sBR0uJzm0iX4L15AftswyiZLISI
	N7Zi/U5lBdPm3y3Vh22r10F6LhT2/I4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zQkQ3+qt;
	spf=pass (imf18.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794351659;
	b=ie+afK5u6mZfEzPVM+y/kifeQBxyggXSagCAxPK0/pan/D3QY0VHxaTP6MSp/XKYjDxwci
	trGw5ELzgE1dKABmrrgIAruYQiT8ZmoheC+CYYn/NtJf7qGosOmM70jwlCoZ76XFeBc3r3
	W/pX67o6lRicZJseYh7ryZNBH87xo3g=
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5eaf34452a9so1901074e0c.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:00:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794351658; cv=none;
        d=google.com; s=arc-20260327;
        b=GadjLT1LjENLCzH391qvME75FoHVWZ0UAjJc1YDLzS1ftqCqk5mLvjeQLHnn49CW9v
         MRuOMG0YyHA+tRwXw/7+oDpqLqNE0uYCYQtHAg4NsGV/JVaIuPMrgzaG/DIRFQcgSJVZ
         lRbIbBiyFffT7O7KPgF3QOxqrPhSW4aa/7BiogIU1IncwZ50o+gDVeqYgqzrAr2gWiGH
         krZtDJD96ehY8y5NQELeL/31Hh2UYUc1en6oxfS6vShceY3ySb6Pi/WoN3MVTWf7x75K
         gcbHoaoas6nSNcj+dp80v1G9oqMkDZDN32DW3lD2HIhpQnK9GLWHRyrJ/eV83NHq7zXM
         I43Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o9zfjeLXx8nlaVhvD+KO4LRkpHUPOVyGHHNomAn5t58=;
        fh=piPmb6/PTcjjKrpIAzQnMwbKJYCgRpjEo41wCpn5Az8=;
        b=DKPbzi+qsqlwp30z1Td2CuwwtTZA/HEiXAJVOMAFvDGSvjccvVSSXfBh1wbecBU63r
         dZvsL5YpybxIbuXYJpheCvokf5iTChmIKkbOJSYCBIX2fQZ1q+0j9hOQqTjVm9CWVbWb
         vQSeoafNqPX9mwlxFW77cLfZNCc4/o64XMcwtkv0bIjfV/GIdpo4FditZelNl19cFq1L
         NooX3Q2VKDBrPsr6/T0kY3KadwXor7HBn9KJKrVsg9nyBIa38IBPfFERUEnLM0JimgHk
         JaaMrbi0TOqdF8kTsqH6SuGqgttb7KoYB/BvG0FP4CHeH7rBaE0iVvhfC/8dFIDEfFa+
         LDKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794351658; x=1794956458; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o9zfjeLXx8nlaVhvD+KO4LRkpHUPOVyGHHNomAn5t58=;
        b=zQkQ3+qtR6LiwVX0Dpgydl6vwvkv84auUKJDzrv+rP6tq2pisfXUBkaqms+n0sv/WO
         8RYnuTzvoagIaDAyYdJyrCuYdypPz92OvXouCm5Vhs/lGvbjNr5ia5r04RuHyCmpv00K
         ZwzPD3OgXu05VDXjNsmNIbute9HbgA74YzRStPE7NCWVABksYLUB1wNhOc7usrxdEQ6j
         uXNEwgTkF+iX7sWnhAjeWUTK2mMr2cb8rnc3QlXq3lA3x0WieRKgdGh0jlJndoJXN0YA
         N92THsA0sSVNqGQ/KDhKe4K9ZmgKf+tl6RW1YWWwUlWLf53KhGToHOfPmCV/ZxQggSoM
         1MRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794351658; x=1794956458;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o9zfjeLXx8nlaVhvD+KO4LRkpHUPOVyGHHNomAn5t58=;
        b=2JEXyVxmbM+b6Zy3Ujo5vycQ2V0R7gvwfvsbnjO5y8MFXvB18ui06OPoaD5fmqJmss
         irCr7N/pdh/R4L36NXGah65lf617NRIyz0ZCr7/Bd/X2T1g2Y5ITknBAQGC+FK4G944Z
         DPcSDEjwnD+LZjr6uMtF+jC96ked363KiOuWiuR83lm1WfkMsnJFyKFTTdk+HRvDA82t
         Ezxyzw/vbOf72+wMyN10g9wg+cuh4b1+pkGpg2u0icvT8+Wo1XYie4kEdixPnJ9gAOGg
         EZ5YDg5BbqNae1xpPpwJ5Fa1bg3N5mFkRg8UriTuAFn867lIONuxgFyyXgLvHdoSXRTP
         mNzw==
X-Forwarded-Encrypted: i=1; AL+hErFQX4PTejtiFvyQNy08Jm71B7w6PhYnFHjXFD6WX04/TYeaoosquCUf52K/GMsbXY1W6mSK98pHqg==@kvack.org
X-Gm-Message-State: APuU4Z8y16TvQrCI6ofvyjMWWucEVhfXE2iKCLfqZq3+DGEl5D+yZkDP
	V+cigl9u8I0dofHV6FUCjdeSyU6trL0Tld2uqCnCKm+xEmiIDJ4NTT8p9NnkCahlf+0IB5efnF0
	oTz+hv15umkUxj4Hfxc+T+5Ga39oyqwg=
X-Gm-Gg: AYBFou1i3JIH1rUm4sPMaW9K/SGtLUws1WYa0rtFO3fT/6/P0+99BANPT2oQSvH+oj2
	kpQ5KIfQfkT7O1rn1Hj87C29izQhRUmRzG6zpx+UuQqxp+OnDB8Esf96IiDYatjdv8PKQDr0bFX
	LrGPoaV6o+PFDK+9DQeDvWQtYpi9pwA2oQIPhP4NkZdsNcpj4nPTviTLH5ONqAMHWK4wkO2k1i8
	tXajD4M/iL8+CVwpTDRStAL/B4NIRhdBf7Bzg+gbMFaKtsEYe6v10JFDk32XHntJCPjvJ+GMMGo
	LjILs6rd4JoSinPdzznwTwjIRsPNWst7eQUI/OB8jiUdel8WQVI/vF+nJV7QBCr9uYpeucvg4m3
	BekTnbc+6vE0PY3EyGvFKFe0SGVh0H6Q7/KO/EA==
X-Received: by 2002:ac5:c752:0:b0:5ee:b3:a43d with SMTP id 71dfb90a1353d-5ee1b02333dmr198001e0c.21.1794351658145;
 Tue, 10 Nov 2026 15:00:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com> <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com> <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local>
In-Reply-To: <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Tue, 10 Nov 2026 23:00:45 +0000
X-Gm-Features: AclHuK9UQtupPx8LMZTpk2yNTMX5hNKYK0tRiitG5dSZyQW9ncd1bgVrIhw2Lvo
Message-ID: <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
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
X-Stat-Signature: sqwcbh35a5qew3yzbf35a134iknr16df
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4C1751C000C
X-HE-Tag: 1794351659-910463
X-HE-Meta: U2FsdGVkX1+OfR4NLCI5P5jGBPCS19o2WEf6/Y09YOAGa7p4KcsOkAlVNGp2OeuNypfNVcgn/cGjsx0iyZu4rXvvRuJM2kWIR96I8DrnjgUgIVVmwsLQr97dF7WdgKLYAW4q2SN9mM10Vk5keIkxcwMtvi+w6ST9pZslxnr1Nd8tbA1nVDoq99onCXgvxXxQ84FRhTVg1h6KnHAr5sKrL2rJ1anJNXGt08GchZGn/Yubawv8DUA/YiAbR2Xn9pyFrIoBB0o8aBhGC98r4wfqs0VlIHCjxIZ2mUkHe/VMpetsd4bwZguVPhmwctkUReWSJpfaY/LVGyUj3REjfIXFyd87IW5T1fho0mKPW4jMmpSkmHW/51sRkKg/zu+M75BjxC1avLpEx9V/DIA7VmExJC9kzmG1zlf/GtgOvE1eg6xC7+33suuvLweu2jBYBNJv3a+y1DPlyOKWL1ZprjhjrSBitCmZGAPbxOY2GNhfTjR2HLGS7mJnuyU8MvHUVeixdox/FAbe/gpys0DTTvFyTDy/z7+CGGSoFZggkI7CBw9CsF2dva8APKA91XAICkTh6VCFThay0uk85oeozWxXQ5GPA20uBISF84t9ujHX/c7mjhbyuP4KqYsUC8QE47NlvFfUp7gSWznWd/mceNgMmyLPCmkcxPc+bVGf/wlDBRSqmRXBffbom7H/F6WZfxqklH+nK2ua8caGyLQMXJM2pMpSYAC9OV78iUhtHb9aqauU9zCG8s443RoQ5uliUFNMLvqvkSPytqGB+Thv6qof1SnHwfX4ILxL53QFY+AUbgpA0FBpjJVS5kUqSqvmyyQbARiaF3mxjOKvYlIRCwClJ/g/Md99VbklS0fGqwGegb17TMLD2r9i6tdu32sYcMoIYe0sQEKe/kUSF/uEAksvlWrn6Yn2AGgf1HTUnvZHIyNsvGyO+B9z9HjyY2RHoFqiwC4+CT8nrmNwRf54431
 nDGcNvV/
 A0LT2lhqLl+ae7JQOnCJbhDyyubgp+196MS4/DAC3evo53uROpBV3t5+FK2lMDQ8AAoq1pDa8gRg1Af+A9Pm6fnU3m4XR0AFd1anvvyjjHRbFRHHiaJ9jt7AYkoESIPVFd8w/QnZSrRAWg6jLQ+KT3yeu8Etzgsyq4M9f20KWBMRe4zANBowSm63/0ax51C8LHQSsZ0sE3EE48AOa3y/GG+LZ5W7NSVR3+ekBhtGOsPJFWE+Ggs6OL6/My77VbGDCZj1F5io3siTdrllQvHGyHB3m+sPuw0wWmZvAWxmfJZPAxcFwFOYMRKLMNrN+bE7ddjFgt4taGOkbJqftEVI/rOGWU6PLFCRN1rKMQmOI2k36wBR5qgC9GIzGQG08G8tVGR1apHRAtllvzclXpXyTEimCGqvuYtW8tvogK37rHI8TFYgPP96mNRGZApcYAZUxTl26dGyrKvKYDfbX2ILq9HOVpcC4HQmewsr8azhalBY9BBONqc0gbm/xVFmU1PrCDPn+jrnfMrytZjHPy99vNaSLFh0KrL57OXEjsv59OKOyJzeCukLq0QgLBb5AwDryuhA7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 7:18=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Sun, Oct 18, 2026 at 11:56:22PM +0100, Shiju Jose wrote:
> > I have got an arm64 setup only, did not try to build for X86 recently
> > after adding the following change
> > of using iowrite64 and ioread64 as suggested by
> > https://sashiko.dev/#/patchset/20260325165714.294-1-shiju.jose%40huawei=
.com
> >
> > Following change is required to build for X86_64 build when using
> > iowrite64 and ioread64, while it was
> > fine for the ARM64 build.
> > Note: I'm not sure whether RAS2 is needed for the 32 bit build or not
> > and the result of the 32 bit build.
>
> I'm not sure iowriteXX/readXX are needed here at all.
>
> Documentation/driver-api/device-io.rst talks about all those different op=
tions
> and the most generic ones are readq/writeq().
>
> About those you're using, it says:
>
> "ioread64(), ioread32(), ioread16(), ioread8(),
> iowrite64(), iowrite32(), iowrite16(), iowrite8()
>
>   These are an alternative to the normal readl()/writel() functions, with=
 almost
>   identical behavior, but they can also operate on ``__iomem`` tokens ret=
urned
>   for mapping PCI I/O space with pci_iomap() or ioport_map(). On architec=
tures
>   that require special instructions for I/O port access, this adds a smal=
l
>   overhead for an indirect function call implemented in lib/iomap.c, whil=
e on
>   other architectures, these are simply aliases."
>
> and I don't see anywhere that you absolutely need those, judging by that
> explanation there. But what do I know.
>
> Unless there's a real reason you cannot use readq/writeq()...?
>
> But those should give you the same fixed endianness when accessing little
> endian ACPI so...
>
Hi Boris,

Thanks for the guidance.

I replaced  ioread8/ioread16/ioread32/ioread64 with readb/readw/readl/readq=
 and
iowrite8/iowrite16/iowrite32/iowrite64 with
writeb/writew/writel/writeq respectively and testing passed
in the arm64 test setup. Also the X86-64 build is fine.

I am sharing the changes in patch#2 here for feedback while testing on
other platforms.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
From d504d61a17d46b0aa1141b5d1cf828facb67eef6 Mon Sep 17 00:00:00 2001
From: Shiju Jose <shijujose2008@gmail.com>
Date: Tue, 10 Nov 2026 22:48:52 +0000
Subject: [PATCH 1/1] ras: mem: Replace ioread8/16/32/64 with readb/w/l/q &
 iowrite8/16/32/64 with writeb/w/l/q

X86-64 build failed with ioread64 and iowrite64 are not defined.

To fix this issue replace ioread8/16/32/64 with readb/readw/readl/readq and
iowrite8/16/32/64 with writeb/writew/writel/writeq respectively.
---
 drivers/ras/acpi_ras2.c | 56 ++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/ras/acpi_ras2.c b/drivers/ras/acpi_ras2.c
index 51adfcddfa99..0849dd247cac 100644
--- a/drivers/ras/acpi_ras2.c
+++ b/drivers/ras/acpi_ras2.c
@@ -51,9 +51,9 @@ static int ras2_is_patrol_scrub_support(struct
ras2_mem_ctx *ras2_ctx)
  struct acpi_ras2_shmem __iomem *common =3D (void *)ras2_ctx->comm_addr;

  guard(mutex)(ras2_ctx->pcc_lock);
- iowrite8(0, &common->set_caps[0]);
+ writeb(0, &common->set_caps[0]);

- return ioread8(&common->features[0]) & RAS2_SUPPORT_HW_PARTOL_SCRUB;
+ return readb(&common->features[0]) & RAS2_SUPPORT_HW_PARTOL_SCRUB;
 }

 static int ras2_update_patrol_scrub_params_cache(struct ras2_mem_ctx *ras2=
_ctx)
@@ -63,17 +63,17 @@ static int
ras2_update_patrol_scrub_params_cache(struct ras2_mem_ctx *ras2_ctx)
  u32 scrub_params_out;
  int ret;

- iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
- iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
- iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
- iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
+ writeb(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+ writew(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
+ writeq(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
+ writeq(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
  ret =3D ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
  if (ret) {
  dev_err(ras2_ctx->dev, "Failed to read patrol scrub parameters\n");
  return ret;
  }

- scrub_params_out =3D ioread32(&ps_sm->params.scrub_params_out);
+ scrub_params_out =3D readl(&ps_sm->params.scrub_params_out);
  ras2_ctx->min_scrub_cycle =3D FIELD_GET(RAS2_PS_MIN_SC_HRS_OUT_MASK,
       scrub_params_out);
  ras2_ctx->max_scrub_cycle =3D FIELD_GET(RAS2_PS_MAX_SC_HRS_OUT_MASK,
@@ -94,10 +94,10 @@ static int
ras2_update_patrol_scrub_params_cache(struct ras2_mem_ctx *ras2_ctx)
  return 0;
  }

- if  (ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING) {
+ if  (readl(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING) {
  ras2_ctx->od_scrub =3D true;
- ras2_ctx->base =3D ioread64(&ps_sm->params.actl_addr_range[0]);
- ras2_ctx->size =3D ioread64(&ps_sm->params.actl_addr_range[1]);
+ ras2_ctx->base =3D readq(&ps_sm->params.actl_addr_range[0]);
+ ras2_ctx->size =3D readq(&ps_sm->params.actl_addr_range[1]);
  } else {
  ras2_ctx->od_scrub =3D false;
  }
@@ -128,7 +128,7 @@ static int ras2_get_demand_scrub_running(struct
ras2_mem_ctx *ras2_ctx, bool *ru
  return ret;
  }

- *running =3D ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING;
+ *running =3D readl(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING;
  if (!(*running))
  ras2_ctx->od_scrub =3D false;

@@ -338,18 +338,18 @@ static int __ras2_hw_scrub_set_enabled_bg(struct
device *dev, void *drv_data, bo
  if (ret)
  return ret;

- iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+ writeb(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
  if (enable) {
  if (ras2_ctx->bg_scrub || running)
  return -EBUSY;

- iowrite64(0, &ps_sm->params.req_addr_range[0]);
- iowrite64(0, &ps_sm->params.req_addr_range[1]);
- scrub_params_in =3D ioread32(&ps_sm->params.scrub_params_in);
+ writeq(0, &ps_sm->params.req_addr_range[0]);
+ writeq(0, &ps_sm->params.req_addr_range[1]);
+ scrub_params_in =3D readl(&ps_sm->params.scrub_params_in);
  scrub_params_in &=3D ~RAS2_PS_SC_HRS_IN_MASK;
  scrub_params_in |=3D FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK,
ras2_ctx->set_scrub_cycle);
- iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
- iowrite16(RAS2_START_PATROL_SCRUBBER, &ps_sm->params.command);
+ writel(scrub_params_in, &ps_sm->params.scrub_params_in);
+ writew(RAS2_START_PATROL_SCRUBBER, &ps_sm->params.command);
  } else {
  /*
  * There is no need to send the command to stop background scrubbing,
@@ -358,13 +358,13 @@ static int __ras2_hw_scrub_set_enabled_bg(struct
device *dev, void *drv_data, bo
  if (!ras2_ctx->bg_scrub)
  return -EPERM;

- iowrite16(RAS2_STOP_PATROL_SCRUBBER, &ps_sm->params.command);
+ writew(RAS2_STOP_PATROL_SCRUBBER, &ps_sm->params.command);
  }

- scrub_params_in =3D ioread32(&ps_sm->params.scrub_params_in);
+ scrub_params_in =3D readl(&ps_sm->params.scrub_params_in);
  scrub_params_in &=3D ~RAS2_PS_EN_BACKGROUND;
  scrub_params_in |=3D FIELD_PREP(RAS2_PS_EN_BACKGROUND, enable);
- iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
+ writel(scrub_params_in, &ps_sm->params.scrub_params_in);
  ret =3D ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
  if (ret) {
  dev_err(dev, "Failed to %s background scrubbing\n",
@@ -449,22 +449,22 @@ static int ras2_hw_scrub_set_enabled_od(struct
device *dev, void *drv_data, bool
  goto enable_bg_scrub;
  }

- iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
- scrub_params_in =3D ioread32(&ps_sm->params.scrub_params_in);
+ writeb(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+ scrub_params_in =3D readl(&ps_sm->params.scrub_params_in);
  scrub_params_in &=3D ~RAS2_PS_SC_HRS_IN_MASK;
  scrub_params_in |=3D FIELD_PREP(RAS2_PS_SC_HRS_IN_MASK,
ras2_ctx->set_scrub_cycle);
  scrub_params_in &=3D ~RAS2_PS_EN_BACKGROUND;
- iowrite32(scrub_params_in, &ps_sm->params.scrub_params_in);
- iowrite64(ras2_ctx->base, &ps_sm->params.req_addr_range[0]);
- iowrite64(ras2_ctx->size, &ps_sm->params.req_addr_range[1]);
- iowrite16(RAS2_START_PATROL_SCRUBBER, &ps_sm->params.command);
+ writel(scrub_params_in, &ps_sm->params.scrub_params_in);
+ writeq(ras2_ctx->base, &ps_sm->params.req_addr_range[0]);
+ writeq(ras2_ctx->size, &ps_sm->params.req_addr_range[1]);
+ writew(RAS2_START_PATROL_SCRUBBER, &ps_sm->params.command);

  ret =3D ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
  if (ret) {
  dev_err(dev, "Failed to start demand scrubbing rc(%d)\n", ret);
  if (ret !=3D -EBUSY) {
- iowrite64(0, &ps_sm->params.req_addr_range[0]);
- iowrite64(0, &ps_sm->params.req_addr_range[1]);
+ writeq(0, &ps_sm->params.req_addr_range[0]);
+ writeq(0, &ps_sm->params.req_addr_range[1]);
  ras2_ctx->od_scrub =3D false;
  ras2_ctx->base =3D 0;
  ras2_ctx->size =3D 0;
--=20
2.25.1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

Thanks,
Shiju

