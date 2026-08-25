Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49D8C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DD46B0099; Mon, 24 Aug 2026 20:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE1B6B009B; Mon, 24 Aug 2026 20:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC886B009D; Mon, 24 Aug 2026 20:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE166B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:19:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9034C016F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:19:05 +0000 (UTC)
X-FDA: 85137881850.12.A426360
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 11B9C120006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:19:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cqqTpfbA;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AA8OiM1vXV9NGju9aaAoOj8PkOEmbJNYD0kmJf+fW0=;
	b=240Nlc+gqf3QMx1IXkzEB5IOANZoridNTi9X/t0ll8BT7Ikk7B1FRFnBWXznhdysx9J9Tb
	HwKOBwQUZNB/+/QbVt3lY6YR8J98ETQ7KgIZ53O37HzG0O+pJB7QXm4DVDC3GCBR69cW3N
	Lq258uYQIB+itk1+eNVfHD2dglzk87A=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cqqTpfbA;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617144;
	b=LxXfTCAciCb8uB7i7WPdaKq94TbMWAcRxO3EiXZO1xzdlGt8xf69I2AhDmzWH3SNL7ZAd1
	1kQZGtBzT6w6XtpnqXYyqkV21/hNGzCfmdCTZF1J9jC/iQqsZJ/1TQ2D0o3HBccM0MBTjo
	T7Su11HwKnSqzc4jNaBAKGyM89ppIGg=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso587925366b.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:19:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617143; cv=none;
        d=google.com; s=arc-20260327;
        b=fPyR8EGNID092y+kFSLIyKm4nXCWuffVoU9eH5fL6jCaaoqkt0KeX9r1F+Bqd81E8B
         wREiVhZ0eoJT8yTE7tbym/VmmOpVnSjFfbsaPTXlqWAZYSszoeOCDbTefeuv6gE3kTuZ
         lvfwJ/p/XzmZrhczhIbUq902WrNBby0ZxmH0nINwb1lf4VL0BN8soxDrqcNiCbiTn3rA
         w8BPDhOA1+ynIgffgP9Zt4ZIShAzP8lPF0OiIgzP7yS8mtLyBIQ/nSno+Z/fHZEBhhpe
         HqsD+GxjOU/9ANAMrirjF8oB/K5SKOG6SDdd3TclfVHQki9HOHlGXBmXIO6YAdh1KY+x
         6nlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4AA8OiM1vXV9NGju9aaAoOj8PkOEmbJNYD0kmJf+fW0=;
        fh=T8IREhvjC+rytFm9uxmrUvn5vaDw3eq27CfdJwv4+po=;
        b=PMWiTU0abW5IZvAxHp8VcZPB1qJiMbNpl61+nQUVsBd5uqI/XlfTlcB1EX8BKSJuQu
         kEdrzQg5UeR1E18/Bs27xJX7g2lio647QQDmvnhBZffl8LsqYP4ukdfrlGM/yUg8MybH
         hO6Ip/Wq/dMJRLIhi2iwvxBgKsQ43+qTLmhbxzkYMmIWxOywAK89qgsnDD1cPVClrMf2
         ClpQVJCFGON0Jx+jrGteXlDgSYmCECSD0RN37Upfh/BiTj0lprq0d3TqOIGTzNFwG1KM
         MQsoM5jXvA7TPF8/zb4mDK5KG7lvMzJ3O6rR0Da62X/UC71FC1MKIpYRx12FaoRNqerQ
         CVfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787617143; x=1788221943; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4AA8OiM1vXV9NGju9aaAoOj8PkOEmbJNYD0kmJf+fW0=;
        b=cqqTpfbA21aqZsFIXTryuUXFNyPEL1CyaQTuzVlwWLLDx2qjvxuSKAfQTzF/JvRdxr
         icnhyoBkt7TzAvz5Px6+bySEfhHOS8ezQQ+iZpotiO8BrBDGLNYmuc0o+bxfMq+Q0Vxr
         wcuBDAZbrBVbc7O2V5aaKzFAkEW4XPBqxKTWF0SNomCO1vBq8m5KkIYPO2ZRaZozOmHk
         eqoOS4L4xbBIkDyFA+/b27k4AXavgMlsxb7skm9EUeXPH6+ZZPWGkidVJpXM+c0ru3mT
         ti9mBiLGwSh9X5hZrX8PfomBGe9OWi5+Uro8b+wZJ5FcRTTc/Ctx6vIDsirSwWqD8AMH
         vt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617143; x=1788221943;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4AA8OiM1vXV9NGju9aaAoOj8PkOEmbJNYD0kmJf+fW0=;
        b=nhlyK5JVuiIx2YxyFgczxX/Xqvhm73tSngsRb24DYuNbkH2GtSQBu6x20QOVNdW4TD
         rIvhiF1ACNrmA7C0dfk9tumRw1nEzuxIQeU8k3a+ynpf4wbbQBP1eGftk0sDqJ8is/4r
         ZnuutMB1o4tWjirS4xtweH9EmsQono69q039Xmc2qHZLK9yhqRxvxdf9Im01xdADg90u
         dn2PKpLcKvn7TabB82oSEQyUrVN4HDgG1fyvqMIModzocNFSK2eeufrSLHZm8KrdsTwV
         55TYKsOVHw4bWb/ATrJlZnm1EGTZGHKoYhJw+82BSQnlrgggTC5RUOUZWvg2M3kPDPJu
         ExKQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp4ud29XP03MHEpVJkJthEljLAFG4oBi8ZpWZhHMSPI0oTP03J+0l1Dw3y1CLNkh2XQtiddkU33zQ==@kvack.org
X-Gm-Message-State: AFuF++lnrPgKKW7q7jczYZ1jGGnT+aQ6bxqKC+ZOOcf1COw4Dzkl4N/P
	RN0k9KFL5iesxn9Awb06kKtOKVu9bCvI1DdDpKjqbUQeK6/oxkt3Pp6F43VKnMY3NMWA3kBBek1
	9lptALL0kx391RD2yy8hq3BY5RTqN9Xso85aX7p/Z
X-Gm-Gg: AR+sD11EvA8s544Fnerew9rrJo3nj+DsvMm6nC4TDYp7qgXjSKlokkVdTkGud+x/W+i
	wquwnAoE6iuRALcHuTdJgHYe8XafmCDy/yLCriPe2s/P4D/mT+h/Pt2Tf/AkccSN9B1/sFLDRmP
	I76IQmsTintXqv0jBgOZ75JZID11++QulkmKoMFnErXoLr0iFKdoyV9WPWrCQ4i++iqwspPzTSs
	ALH8vLZ7l/HVg2MgMtMiHWO95k+kJqPEThy8hKm1gdJwT/Dl0nV4X/8DVVvEQQ6FHBtTTXrmBGN
	OKKu8vOLfjU2AyeYRrvEAuE1UyFM821BXL7K7diBRQc/sYEfSQPx5HIxbW4r1JEUggZ5tXviFtB
	IrsLkhC7qrUZwgJS68dz1UqAXwUQM5kwdek/tnvbKoZTVAL33aOA1PNlQl6+SUXdrAHfKcEOH5j
	ps4wRXwzBod7aLnKpSlpuIuTw=
X-Received: by 2002:a17:906:f049:b0:c16:126b:98b4 with SMTP id
 a640c23a62f3a-c246a2ef584mr3235540266b.3.1787617142396; Mon, 24 Aug 2026
 17:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-8-jthoughton@google.com> <aoRnMRZ0jE0ycwcT@arm.com>
In-Reply-To: <aoRnMRZ0jE0ycwcT@arm.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 24 Aug 2026 17:18:25 -0700
X-Gm-Features: AcwNN1ULVV36J9NLxd762hVRv_uaRizf-iGnaiBYSt4u_4U8MisWrig5oazgX0M
Message-ID: <CADrL8HXyR0UVfaLs4i+DQtxDYCUzubatjfN6OZDURzR-R7dhNg@mail.gmail.com>
Subject: Re: [PATCH 07/18] arm64: Add system_supports_hvo
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tcwop1q8sb7r4zpap5qpupie9mq4wmo4
X-Rspamd-Queue-Id: 11B9C120006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787617143-887827
X-HE-Meta: U2FsdGVkX1+qC5+7MUlbkKqiKdKIBAp3JEweujE14kmWo1kHbc3Xg6iXjsQlVYX3Sprzwy839pDPgsSlmdaIIfWge8i2lZv+xkSUAkhtMty98Vk4w8s4I+TYded0GhhVFHKjTqmdM1Von+yNpVRtwvO3FX+3QiJhxrVf7QaLNR0PGi3JLDeReLE8y/ZZihGhsuSwwbQOvBv4pshyaM4BmKYaS3zupUd5qeaGufYzVaPsn0VQQCa1CDK5XkYAFvcrxDcuSn3G0vxVD0wYz3JmOHWC/hs6JN2kUDbVDTtsf4hWA7V9KMxHWrkKe4ONkHJ44nlTkuglbQx+/OdJvycollLv81Wo2fU/NUKoKRrmU1qLCOEO8pPrAXrqK59+BloQEjlXh26WsKc13YI6T4epZkbLkl1BBWb2ah0URerRv+HZzAEEj5+AEvLhfAP8scR4PmJa8lTKvNRFgD/9VbA5F38gxoUbRhQPtfOylQiHFPueczV+im713VLeCy7/43RUqVIqe3RJdKA2d8bGEW9Gnrz7YTMKBKokkKCTSS6huXj1rSgeBsTPnB+nHnDOOdJLd3NBGRDojd0G5TUDya4lelA2xEdqDgUbLMgwUy1ErI+QRrDIydTMCeAYny2kwL/6zMuHdnxCraxa1EIE92zyTi7mQ0toskSufVw5C7YbEypIO/kICmTeI99ihajqsKwUjOXSEhQuyR+k1qesVHC8e6+H/AXlmQtMyJtyp+l95ixfn3qIJ++YfQj0qDrpW8NnmHgjyjyAr7RMwIIuLdA9uj3BomHHtBt7c42T4/Op3ydWYnSrqxr06rf4UPO1Vro8A3m6yoMSnCsoPTpxi39CKgqHD8Jatm83hjUfnfYMpy0Y+AXFrJDQA/2HQ+JzrovFOKbxUnmYXEqvUvUwL0b7bxoKWXGQG+ZkqR0k4cHeeGmpDyEvnWVa7v4ekqTGdulGwLyxb914p+57ThGU2Qy
 SuXk7UI6
 mqhM0l9N0M8163+m6pawOCpqTlF4R2Y1s5qlEVRv5lUmblkuCr5f/CdG2I01/gKXF035Hqiku8MvetJnojyoVQXCjlzMrWHCQBTwnjdETzZ7mS27eCQlLaKiYL3DvLkgfMAqxtYVbEBZ5ISSt51eUZjsZVfcAeaSlh6T9bFZ9FDha2iitabG5Hx0UdYWSTOmI8/g7wXk9sQ4ythJpAFXusJOI1N/Ob4ye7QhOq7VPN5SIhbbWszfwcTNFr4UqpgsikODj8IR1dO+nK1WjSwjGqnBXBqOvrc7kivzZhnFl0RnDTcnykb5Mg+zoocnckN21K557ZNmqYrtpChfqSxrz6FYVkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 7:07=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, Jul 08, 2026 at 03:11:17AM +0000, James Houghton wrote:
> > diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/=
cpucaps.h
> > index 25c61cda901c..6db3ef827f86 100644
> > --- a/arch/arm64/include/asm/cpucaps.h
> > +++ b/arch/arm64/include/asm/cpucaps.h
> > @@ -75,6 +75,8 @@ cpucap_is_possible(const unsigned int cap)
> >               return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
> >       case ARM64_HAS_LSUI:
> >               return IS_ENABLED(CONFIG_ARM64_LSUI);
> > +     case ARM64_HVO_COMPATIBLE:
> > +             return IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP);
> >       }
>
> We shouldn't use HVO, a software feature, as a CPU capability name, even
> if it's called HVO_COMPATIBLE. Maybe we can come up with a hardware
> related name, e.g. BBM_THROUGH_AF.

I was struggling to come up with a good name. BBM_THROUGH_AF sounds
good, thanks!

I think with that more generic name, the
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP reference here no longer makes
sense, so I'll drop that.

> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeat=
ure.c
> > index 9a22df0c5120..3b9224b99a5f 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -2172,6 +2172,16 @@ static bool has_bbml2_noabort(const struct arm64=
_cpu_capabilities *caps, int sco
> >       return cpu_supports_bbml2_noabort();
> >  }
> >
> > +static bool hvo_compatible(const struct arm64_cpu_capabilities *caps, =
int scope)
> > +{
> > +     /*
> > +      * We need BBML2 to support Block -> Table transitions without ta=
king
> > +      * faults, and we need HW AF support to support changing the OA w=
ithout
> > +      * taking faults.
> > +      */
> > +     return cpu_supports_bbml2_noabort() && supports_hw_af(scope);
> > +}
>
> I think this is wrong. cpu_supports_bbml2_noabort() only checks the
> current CPU while hvo_compatible() will be run once on the sanitised
> register values (SCOPE_SYSTEM). I should be something like:
>
>         cpus_have_cap(ARM64_HAS_BBML2_NOABORT) && supports_hw_af(scope)

Yep, it's wrong. :( I think I had some things confused in my head.

With my newfound understanding of things, I don't think the previous
patch (6) is doing anything. So I'll drop that patch and just write:

         cpus_have_cap(ARM64_HAS_BBML2_NOABORT) && cpu_has_hw_af()

Thanks!

