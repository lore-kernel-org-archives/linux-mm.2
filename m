Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23853CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 05:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F57B6B0005; Mon, 18 May 2026 01:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6016B0088; Mon, 18 May 2026 01:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095856B008C; Mon, 18 May 2026 01:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E860A6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 01:54:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80BC3A0809
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:54:33 +0000 (UTC)
X-FDA: 84779476026.04.985B131
Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	by imf10.hostedemail.com (Postfix) with ESMTP id 73FE2C0003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:54:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XTL6hZdU;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779083671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9Xsm/ouRy8rllw0+gW2As39+lMNLqayO0PK1J5oNAk=;
	b=htod8LdvPgsORXOypBnVvLIzK/bDRa+CXF+XdahAqYGFaYNV4y9dP31/o/EJz5/Z9Wdeqs
	2B6fFM9wW5IXy8fVJk6AzRl6EiHk3kGO0IH4CSZy/unoie5RfwssT1Rewn3KXqOaYWr5T+
	UvUXKlVUCg3+5YW3AK51PLR9raAiaWQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XTL6hZdU;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779083671; a=rsa-sha256;
	cv=pass;
	b=a2YV6kHzl7BKVS9ln4vyIHi4JvCm6q0IUHKcNu0iI12PXp5iLEr6Z4m9h6K11j2uhUd3vi
	f1eU3OqWUVZVuxej/EEfFuRYUnZ8hMQHNwiUhNk3tkE8v/PIOfY55FA5PuHM/4iqrN5v9n
	nL8VcilHV3WZYRrA559lNFUqk4JKIjg=
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-1329fc4bf77so4638103c88.1
        for <linux-mm@kvack.org>; Sun, 17 May 2026 22:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779083670; cv=none;
        d=google.com; s=arc-20240605;
        b=fO28Ea3KkykrD7PbPkK3aAKS/H9xfo2+T+wThva9m9za6wIRRE/Ui3RZ4OfOl0JpQW
         SXVWgf/fFcFm1sufcxYrotu+qIegjIIxIawTeu9qgXQsq/U7NIQdnwrcD9vNKGjsSsD0
         iE8wBd6utZDQOtWkc9ObsdCAyarGrBQCSZnfHNVmDnhyVrOIFCZsQMlwNiEZMK0eycd/
         3o7L8ft3OuBJp0FNGN1raOAnZzMtOfm3ud7F+a51SkY1QBCHErikoyKjMVTn0yN0vKbS
         aOVtI7etxce8nnj7pPIZe7Q1CUMfWAZGaq4gbD0VIpg0aJ3bqhDr5Bgx0+iD/3KFLJRR
         0b8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s9Xsm/ouRy8rllw0+gW2As39+lMNLqayO0PK1J5oNAk=;
        fh=lWRTefCeRiEZFizXlZsv9oAgkpwGdgTXUqwzc0kwVjE=;
        b=I8++JyvUbnUI1CkrMjeHd4lB8nRNUYCfwJ5F8xcYXjU9S7EXaBYf2NldWBUtFwGzlw
         ZY6l4iLrNagN0vtQX6LB8k8i/BksWtobr35IGvfqTYq95ihwXdfUR4EtwQbYTXydB3Jp
         3INVgAE80QdJn51jVSpzjllRbb+n4q3v/BZGiBetDEcZhprl9feW8ggIl+c0qxHwtiTJ
         4nauSC6M0pz/DoWTicVxu5AfWf2Zik8QoVVJmqpiw3YyL0LgTjvK8oWhD39uUyOs7v3F
         6FelytS9Fi9KU3dZCe1RXpvHGX41VZwctfHUDSR6lH0oSKTjvfo5fFj/kzy11KSDiz/f
         NwjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779083670; x=1779688470; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9Xsm/ouRy8rllw0+gW2As39+lMNLqayO0PK1J5oNAk=;
        b=XTL6hZdU1qCeueG9YiI09lbYU9NJ1it5IkrIE5aEWuWfTc8ba38RZae5j3f0FE8H5w
         0wQ1a1pH0AjFKdfROSTh1HZXCrvZimjGg/ZIGvWDb/uoBrt0ODbSfBlwNTWbmre7UKZZ
         +oF1PRJ+j0ypgRe5Cj/iVOEW0msrOwzLxfUh9/AZaCx+PFBDgagD1U4/VWnvQ+wduvwg
         yrpKfYWq0v/1AyH3Nx52O2+icohYvFhm5ti5eaYdOSv7YafHxbuVImUy9xcg36BCoCBc
         GHPp6H+El9RglJJNKjze9+2HDf/Orp9lAvsYSSOdwgHEJ1z8ufcMoW8iRk/UWWh7P3Kf
         7WJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779083670; x=1779688470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s9Xsm/ouRy8rllw0+gW2As39+lMNLqayO0PK1J5oNAk=;
        b=nfXPsB2D+bN5A3HA+gjXEq6iEvz2FH2q/9zYnPyA/eCBXgXjiGHPV7BUqVOihQ3XpC
         rggiOLrY0UMWIOPiNjgD0g4iu+/HHWf92k0oervCC6diKAPDH7wERV+eIzvRTAWLN5ea
         RaLtC+4c1I7PNZeCHXIrXCcZVOwY7gLS+6bkjOiOQRgrAz9QdHu8YJR007+okeliE4Ou
         lrn3L48Z+Kc5gN2ds72TAuNs2rxIYN6huAcRh5H6gM1ctVcj7Wvk9sA8cXt6knxsNL03
         ebiF8DTHONGFPMObCHRbPKuyalFqbTuBQV07GnzGLB4pkQ0fwaNj7CKAqVx9EghV6jmM
         egwg==
X-Forwarded-Encrypted: i=1; AFNElJ9u+1ahHEjoJ/vS9uXsLFxfpLalJFXU+8tqGfVPhI6dp5exKSyfTzUI2ubfJ3Cbr/3c/moh1JLF3Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1GS/GUcBQZbe/U52oMJ+TrJkg4qkoyK4KM95KGVKlkMtMqDwX
	gzPjTwLK4Ad5KXF40bgNL4VoSMo0pqtqjKjttFLCvVuAU+XiJiDdK4cHjhOjCrRn2KltRl5DApI
	RlWItPoej74JY6wPvaB187Hl/tKLamg==
X-Gm-Gg: Acq92OESGuIfrFrttffhQGH/Z8HKo40eouVcrCIGOv53I+NPkn7/G+z6Nqb2c9h0YBA
	23nGFloEyoTfnju6F19Jc7Tz5R0AOfBCDhRBNbXEMy1hr9JKCIpiBkiacyFHEScnPokvPQHG4Ca
	0uPlKTWIU0f8Gk1dAQSxqUnh9ZEX/U1XXeS8wuMGRjHaOfQ7KEPNC/M+pYdnbm5I5JXTkOZCuaL
	nSKWHPEKasR4vBdXOBtqmLPXZzgU92voeTItg0WTL+b4fyG660tl/JWl5c7qq2C32WPRl+aSCmm
	sWwANH8=
X-Received: by 2002:a05:7022:ff42:b0:132:7ab5:6cb6 with SMTP id
 a92af1059eb24-1350451da55mr5923196c88.2.1779083670222; Sun, 17 May 2026
 22:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260516210357.2247-6-ravis.opensrc@gmail.com> <20260517234326.89365-1-sj@kernel.org>
In-Reply-To: <20260517234326.89365-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sun, 17 May 2026 22:54:18 -0700
X-Gm-Features: AVHnY4JSJ_v1VisgQmkmSmbMTe-WurEHckc4yzgeccnY1Ya-JDuePUsGS8NIYOs
Message-ID: <CALa+Y17XTzjAK5ZyKAKZLN1cAE-+c+2DgqpmuHGWgjUAZMgkFg@mail.gmail.com>
Subject: Re: [RFC PATCH 5/5] mm/damon/paddr: add time budget to migration page walk
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73FE2C0003
X-Stat-Signature: 57okrgby4qanxbeqctemu4u43q969ius
X-HE-Tag: 1779083671-795536
X-HE-Meta: U2FsdGVkX198AMdAjYkTEs+rZhqpLA1cJJ+63TtDhfxktCDGfgtxk77NXz0BTbyMZRrymEsOyVR95M48swbsffw9EOqetIDn6F+GYVeOTr/5GjjqvmcbhDOcv2W88LtC0yyTfjuhL52ZdNgTfbpUC11QLn1kwfbOhy/BSfLlNmpuW+rwK9SI1UoIsF8uV5bUf2yVBX+PLc0gfNPGfg0XimSn7FLSRFHj8cscxgEIQIJ08n8D4ln0WMAfGuc2TJzJqrjVfMzw1M7eIbFh1r27z/9vs0x9DfqeOiVhhwBss0IoUfVnXXkaefMH/+c+PxKqkXM/XoGcPtfl7v3aDJ+Pk9X8c5aE/V4k6ojDVARph/f+uZZiw5b0PK78KIQ+6UH7+fq2YfWa5ivzzSuXh4HLtFeZAlXO+DQSetN+Z7cgDwoVgu8hh+hQT+4bKyJ0uKUXUiE3kf28AzglRLUZZmnbeyw3dQ49shFjYml68arBeL+cL2gQmANG5QnPqrN1bJlZKgJW0F52uZIvH8uuTtmmXRVepLZTy/60XSbDCOTwbPraXJ2qdy6U4sju5GV4wPdeQUkiouGUXmBi6S5Tydx7EHE3no+CCCWPArCheCGuBj+YPBra6tiQdIN0vcLjRJbTjb0viL+Lu5iSeQC7t9ahQM5YHmYIjoB3O+urpArvcZKzjeSlZNPf2Q+/HHWtiJfJHHH0od92a3z06LDI2RqLcaamiWThhXhAi28P5PBZXt1HVPiKBSPsUF/m4u0U0p+j6ZPO2ZwTdE58d3B9iVlurOfN48ntByVHL6JuRuRuLHVotIvZnUeRdinPNJiyIVwr2LXaOtSPJeLkFXeUMYQ3W4p6lcB1Lnr+C6OHVfNEykpGtV0/Q8iJaDfBPLB9Sg30DJzTT8r6bPh0F9ZSmAZEEuSVqvALxWToaH7TmhAhQEOBKLa3xoxi78fVGToJVaxK3D4XgGN7ByiZh7C2Xnf
 IcQ8U7uM
 lYnIfbymlWWVVcSG6bVRYX8zkuOtvBkX4BRJhHxKkKY5JvZv0BpK6kQ+ki4AM7en/ZTDyiDBxJ0Asyxyi3/K0juIxjqZM31oBVhpXB55FgiD/zcjTzvc6oAQc7fkbL4+3OHHCEnLqu1gUgZJ+NSlLFQ9nDLWbWAHpTXXOzo+wmHUBHKJZioMqNip+kmhPGZ6GrrSSaES2bgoCnt/TGslXkHDtvoAcFiKk7yIWWTp+Ii0wr8Nrr2T7p3FkKFVef/LNaIk/WE46AA4Oxjxf0h1sKJjX0te5M7EELplsiuuwG1J+RMgde3rnlaesbBQfzZoREFucl9bsdBRMRfN++SUtQL90XOgsPdP47ZVkGAaB7K2JujUuc+t8Sb2ylY7G/kFOevnSTiJ/a7PO3eruMM8G0LCiiksiZ7/8jv2zsxt37CPb6Vcz2Lok1MlK9g02rcWkU9cBJz+YICkPYpVQEOtn8MIC7htE+REO1xUONVNW7wZW6S3TTh5AcVyuL6KTaEY9DZlZ5ooIOXSef14pInd6DR7zpXxJvQBqes42lR/OVOfGmvK2lM+NstXvmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 4:43=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Sat, 16 May 2026 14:03:57 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > On populated physical address ranges the pageblock skip optimization
> > alone is insufficient =E2=80=94 most pageblocks contain at least one al=
located
> > page, so the walk still iterates millions of PFNs.
>
> So my questions to the fourth patch of this series are also applied here,
> especially about the assumption of systems having most memory free.  I wi=
ll
> hold digging deep here until the high level discussion is completed.
>
Hello SJ,

Stepping back to look at this with fresh eyes, I think this
patch is in the same bucket as patches 1 and 3 (full background
on the patch 3 thread): it came out of the same parallel debug
effort, where I was seeing long walks during the startup
transient on a multi-hundred-GB monitored target -- before
kdamond_split_regions() and damon_apply_min_nr_regions() had
trimmed the initial regions down -- and was unsure whether
those long walks were contributing to the NMI-side
responsiveness issues I was chasing.

Once the actual NMI problem was fixed and the per-region work
in steady state is bounded by DAMON's region splitting (and by
the scheme's quota when one is set), the per-call cost in
damon_pa_migrate() is already small enough that the budget
isn't doing useful work.  cond_resched() after damon_migrate_pages()
covers the preemption case.

If a real workload later shows a per-region walk long
enough to matter, I'll re-evaluate then with concrete numbers.

Thanks,
Ravi

>
> Thanks,
> SJ
>
> [...]

