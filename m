Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44F4C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 22:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7CD6B0088; Mon, 28 Jul 2025 18:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF8E6B0089; Mon, 28 Jul 2025 18:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCF76B008A; Mon, 28 Jul 2025 18:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3120B6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:08:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0065AB9807
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:08:19 +0000 (UTC)
X-FDA: 83715062760.10.06A1FD0
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 023404000F
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:08:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b=wpSxUsEx;
	spf=pass (imf17.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.208.41 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753740498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVZlePzGjkHlHhNr3txJWdkuHXKAOIv3uj0JeG3SlOk=;
	b=WHsbBGixYNIHPIq7sE9z3G2Mj4iJFkHAp1RG4L8bDfSZExXynbMTKNP9U0Ex7lB4aNppan
	S7g/M72vKdEmQw6fvJw+cCucWY4M9JWe+YUjtMSz8PXMvptKksEwpN3KysU1WH6Yge9ouI
	lJXMb7SzLuOiUJmHM+KJTammBR+aWxA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753740498; a=rsa-sha256;
	cv=none;
	b=UZkqiuYj4pfZ2JtkCY5dHaBViX17B4n3c+wwbmiyGndSyoB4nUXY2QWt/0fJJi9GXCKSLG
	IdQq2laVfJSG6AS5Bzq90hmJsCh0MrdFGsj07UV1n3wIQQRoskxEdj0bNk7YQGvPNAAiVJ
	x+96K+/OwcqtiAwjwXB9YwTyNTzEuxE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b=wpSxUsEx;
	spf=pass (imf17.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.208.41 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60867565fb5so7630287a12.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kowalczyk-ws.20230601.gappssmtp.com; s=20230601; t=1753740496; x=1754345296; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVZlePzGjkHlHhNr3txJWdkuHXKAOIv3uj0JeG3SlOk=;
        b=wpSxUsExaRQxdE6Km//X3R+1mZqloK9zX5MX9jT7zX9NdoUpFtWvnhnKzwu9n8hNHO
         kwyFY6Q0GknxHNWp1p/vVPgqMbFUfxiwHaAX6CekRzL0BpvAF7dxJ+Ln7T0qG6c/OYSV
         +atrgki2IFk6iWFB9bnVm/F7JLkUdpa7rvY/KEK0RXRjMAPPI34PGf1tK2B9CAuabwZK
         FLCwg/repvXzdBSI7WPJUio9A3lSqLfpg3nBc+FKW6TO6a/88Zkn+OJusy+6qar2J5nL
         X65wkH9fwVr6NPVu8fyEadsYKYN8VJdHnCZimkZrSkFQQNIMEFUAY7QfX14lBSFhvTIR
         9G9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753740496; x=1754345296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVZlePzGjkHlHhNr3txJWdkuHXKAOIv3uj0JeG3SlOk=;
        b=QjyP3+CNel3v7SWvO7zfFqW4lBfRLpX11MopOVhhyjR3rSoebkkA2Zj7TgRAVQ2mMU
         ATFNnPRfR+SO6BZ1qnpPM2xZutElJzl3xUgVrokqSfgESZZQPgrEbmrT72VzVWDqgE4O
         rEqT9Qd3aNh2sX7477Ip9AkECWpsKdaOXOXw6XMOWaYSA0g3oNOXYICsV8R7c0jgHGXQ
         nheu8gHXp/5dZtR/ggrdIFjLvKw9eJdOAOA4WicaDLzFjwAFe0vyQ/5laUpz2ydek4HU
         oc4RIL/Ts1EtAlb1DxKuLUmeCqGEf79hzQpBopGNf6vcUF3gzjTSCVEnfdmq2E6KkmYZ
         0QCA==
X-Forwarded-Encrypted: i=1; AJvYcCVNecExtBWk+VkhBGPsC8cruGiJjntnSRbvyK1n4/Lwqs6Bx+RvC/jVhgLd7g1kt0PNe3LXKT3qDg==@kvack.org
X-Gm-Message-State: AOJu0YzF2GtZ0eJ3pCCq/68+gzXVUel3t1EULVTa3qMATZmMCrwoHulg
	DsSFWDZy/mazr74JIv3YZXRR+ex9j++xTDaHSSwn2KzM/R63FY8GHgeQlBob0eO+2ysdl+9NPyi
	ITdkbuBvVO0TcGG3QBuUdgq31H81ZLALxRz7oDdpF
X-Gm-Gg: ASbGnct/48dZUmvmKFWlr1ZIrTJ/Ym3vY4h1okTK1Pvrsln3Q/NqBovnwcGQvTmIx30
	vrtmqEMJTSOXboaAV4CBpVGJGagsNyReorSGUCO3S99jlSv9JSAB7+3wSVQ2/RUPzAlFwFn5pix
	4598bp3nbjOIwHzFFIfwB4vJSRYcqPHfib7qXHjRfrFslWGyoSo3+5p8Y2GR689C871kUP3QOcv
	/AcbZxfsVu+vmY=
X-Google-Smtp-Source: AGHT+IF09mPBLrOHTEIB8WHhuFE3I3nCCAFLkKtWOTo/2h9D6SAx8Ni8uYSGEDjY0L/5w9XZjlAxtrdCm0GvAmW8byA=
X-Received: by 2002:a05:6402:2103:b0:60c:397d:d638 with SMTP id
 4fb4d7f45d1cf-614f1d4b520mr12115084a12.14.1753740496343; Mon, 28 Jul 2025
 15:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
 <20250728144424.208d58d5a95057ee7081ccd8@linux-foundation.org>
In-Reply-To: <20250728144424.208d58d5a95057ee7081ccd8@linux-foundation.org>
From: Patryk Kowalczyk <patryk@kowalczyk.ws>
Date: Tue, 29 Jul 2025 00:08:05 +0200
X-Gm-Features: Ac12FXx-SLKO8_1dJESpw0d0b6bu9iuRE34W3EgqURU7mQvBpXDzfaq2MkrIgX8
Message-ID: <CAJCW39+85dtfEjqNejB8xT=JCo2gU5XWY_ohb0OxYKs6G929jg@mail.gmail.com>
Subject: Re: [PATCH] mm: shmem: fix the shmem large folio allocation for the
 i915 driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, hughd@google.com, 
	ville.syrjala@linux.intel.com, david@redhat.com, willy@infradead.org, 
	maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de, 
	airlied@gmail.com, simona@ffwll.ch, jani.nikula@linux.intel.com, 
	joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, tursulin@ursulin.net, 
	christian.koenig@amd.com, ray.huang@amd.com, matthew.auld@intel.com, 
	matthew.brost@intel.com, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 023404000F
X-Stat-Signature: kacra19z5a1iqxmdbp16pchqckuma6xa
X-Rspam-User: 
X-HE-Tag: 1753740497-551847
X-HE-Meta: U2FsdGVkX19uGQoUUMmWIt2+LdPwgC/tpYrlwte9WPCz7r691Z4x58RKb+P8oiJ5mKBUqgpDlALfLcEXM3mWAky3nI1TnMFlToFngngyGvFwp6tGbhuHYCX+ZnRN8hFTK0iH695ocDCHn+ponr+NJeQP8KXoKRG+HyfqyrVPL2pqdsmy3sQbNuu4endRC/BiMMLv/lVeOzrMCM8xprTlPkrrf7GrsshJtevOkFz9TnLegknDQjEJs/N1cETNrzsr8Zr9XgkozI7MXxUam4SpLsc2foAZ/U4sHjBKDrMW6VBE9P+aQ1NS66Tb1p7Y/gpyqVD8sD8XguEqJOfF80DsFd9gl/Cw/PEZAWnyjB1IH85VVXnF2WhP/sNLTDT+UHZKlf0onRHmAAa9ZCuyXj9R5CZnuzXLqo3YV6nYvLhPpcIOrSxzOBeF8u/HXVtplBlTMfxaQGQ7hsqiENai4VN7DtBeaHNnTkL0bqQDM4s8+HfvDBwfmPg4YwyPSapbcE999n3tb5Gfe6K7Jau3SjYjPH0P3deI6mw9ZPchNMnmyyf3GnkoyU8OUn/sPddR4MOK0/s8lL9XN+6O8kWBC9PWrbMdHOG0NXYR8zP+2bNHtnDcL/GN7AXWPRaLIkItrHGPhGXbfNj4c+ZR9Rnmm1Qh/Eus1AEkEB2UzK1aSLAWvCz6oZadJK2dFY89FgywpPBZ3Q62d0NdA0KzgANI9TPIQOohJSWJ2BTZZXv/JUm2FPjxpeLFkzDRoKAz5aymZ95wDoyWzlZyNaGe9uILl8WeTwJcgefHFEPoge3p+jtcJOL5ZAvT1RpzzIAia1ZJnU4yAkpwoXTNJIr33LNFJKk8mLsDWR1I4QFp6qphkm5OQ8TfM9zJOaptjZxrkNFIAo18hkDjKzjv0XPR0CGoAHuC0T+2u9CD5HkCHEGRrg3ZzPV35E8bJ8Os0c/nQu4HoVyAThosDewQcoR87XiyzQn
 IHCnUzEL
 Cfc7Vsxr31Ye3mM5gVPu9WZj+d1aOJzoyUUDllmes/7y4HkE5DOMOZLCR1/+9SWS9VzjfeKsy+V6gutEzyaBKlQS8LA3q8nxeXjQdLpJ/NGP/Csf+A0qjt6lUpnECKFq0+tRIBU8q0u7zG0sMcAimJjqGrM9y9j3kZGdeEn511Fb9VIQ7Y0Ueet7yGm7hDNPkD+XlGEuoIyF0dl8bd9PVpOgqeWgzK0EHjFw1dBwj4DDjqxa59bjOrtsODG27fa/PXpnjFHd/d5kKCVTtRJoY0h9oSkSCSBZgvqXvRjt/ff2s6o5F3AmgFahcT8nGLs5wWEjzsBLFjUBBWcurJlSeuUS3+qPqahCD3g3ceGRkfOVaas4DrIxxXdL+vNK+zvej5azl5VvfpsqGtxBaT5XF6GbmQir8KBhqak8vT3EQkcI6Yvhevvjresjnkb6Qqj6WVuQcMjm1+bLfYi3L9ccZkEpovIu5Ns4DMRrKrr/m4gBFeZBWX/7WkkZ6XAe/awA+sUrb53FfPCINNrOKGQkrDZK2oDVQtcBPrsUWPeEBDTIhdbAJXM+CWtoc4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,
I apologize for the second email; the first one contained HTML content
that was not accepted by the group.

In my tests, the performance drop ranges from a few percent up to 13%
in Unigine Superposition
under heavy memory usage on the CPU Core Ultra 155H with the Xe 128 EU GPU.
Other users have reported performance impact up to 30% on certain workloads=
.
Please find more  in the regressions reports:
https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845

I believe the change should be backported to all active kernel
branches after version 6.12.

best regards,
Patryk

pon., 28 lip 2025 o 23:44 Andrew Morton <akpm@linux-foundation.org> napisa=
=C5=82(a):
>
> On Mon, 28 Jul 2025 16:03:53 +0800 Baolin Wang <baolin.wang@linux.alibaba=
.com> wrote:
>
> > After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpf=
s"),
> > we extend the 'huge=3D' option to allow any sized large folios for tmpf=
s,
> > which means tmpfs will allow getting a highest order hint based on the =
size
> > of write() and fallocate() paths, and then will try each allowable larg=
e order.
> >
> > However, when the i915 driver allocates shmem memory, it doesn't provid=
e hint
> > information about the size of the large folio to be allocated, resultin=
g in
> > the inability to allocate PMD-sized shmem, which in turn affects GPU pe=
rformance.
> >
> > To fix this issue, add the 'end' information for shmem_read_folio_gfp()=
  to help
> > allocate PMD-sized large folios. Additionally, use the maximum allocati=
on chunk
> > (via mapping_max_folio_size()) to determine the size of the large folio=
s to
> > allocate in the i915 driver.
>
> What is the magnitude of the performance change?
>
> > Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> > Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> > Reported-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
>
> This isn't a regression fix, is it?  acd7ccb284b8 adds a new feature
> and we have now found a flaw in it.
>
> Still, we could bend the rules a little bit and backport this, depends
> on how significant the runtime effect is.

