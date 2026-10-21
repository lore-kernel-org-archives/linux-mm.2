Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC58606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=g7hHjPy1
Received: by kanga.kvack.org (Postfix)
	id 726F96B0762; Wed, 21 Oct 2026 14:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7CA6B0764; Wed, 21 Oct 2026 14:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0BF6B0765; Wed, 21 Oct 2026 14:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2211E6B0762
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:47:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BB3F16065E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:47:30 +0000 (UTC)
X-FDA: 85347516660.04.EC28AE0
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94614100008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:47:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g7hHjPy1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792608448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSTZtcyPK3yzGl0K7b9zLKEzjIcPw2EBeTAvW8QX6I8=;
	b=a31TgloUrA1u+iAyW4uRAqM42RLdxlCvg3AEO3lMw9EnfeP0kfhg6jvLCUT/5fxC8qviM9
	D3d6xDj0wYBApyuRzF0rxX2jzlk0ERDGBL5P5rmcNl6UK0Fgod5+prlkhGLzEFMHTSfPTd
	HkDo+PaJYPxXXU0rLdlTIoqMu70EDyI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g7hHjPy1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792608448;
	b=yGOmPydFruL1kZl1CBLuUn0+cavRuRqguBc7cVM4rxYusreZP3hM3FKZqaMb8SkDVp6ZDU
	ZHU7iQBTUQkledCmJyumL6kaOU16Voa+fhuCpPcDS4EYsIy0ww9kmAynVE6DlJaC7TDPjv
	KqDGXU3msjkrD3ocSPdTCU41li0sjSs=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1517bda04a0so1076349c88.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792608447; cv=none;
        d=google.com; s=arc-20260327;
        b=iL2RUEoIsGPA4Va1DPIV5uzpdapER7tPO8Os3xM3j48JnEAb5Ygm7aqFatuZwvK9Dl
         u7PNeO6+25heuV5lHPeglrpWWAnceQ8RsHvrIbkyD8S4Neo94K3Jg01LrV8Og5Z0zxda
         lGESHv1gVK3JuRTruZx/IcrUvHFBS+ZOl/AEryltavywGwD7+VYRMuws5V9shVXb8H4R
         OR96hGbSFAlCYp7oLVEdywtJ+xg5Y3+ENP2yeBe3QlA8a0VXx9xCjQSsySBZKCaVjOow
         a4LPQhPMjFP4CGmTOjEP0Q806aF0F5GSxc0HUWg/CE0Te9n0tKzBKh57e4csnvPalkLU
         DUhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dSTZtcyPK3yzGl0K7b9zLKEzjIcPw2EBeTAvW8QX6I8=;
        fh=tQIK31c0+pBkerHPlu3B9QxqrGbigOmFACScnHv+EDs=;
        b=nnOdTT54xBtqh4pvhmGmUvHFDjlXPc5cmIW95oMLMHraN/ymbWPIxP7X3710C9YAeT
         AO2oewXOWr5U0irzSrgmT1GocIrYmKJUNr00AhSYmn8p7Qi/Ygq2FyCoVRtjPFgtW9i4
         qWxMW3AJFbXDc/EwmesIQA1K7bu8tOgJ6N5/+CZHBQKYi7k+kP/oagnF96RZm8VZWbBY
         pS2/uc9AfbETyg927NsNf8NRQPnDZxWcmw9p5vIBrXXeeR8mTuKe91udanvClt7i+SQY
         99Ydo0IR4w7CMq/5cnvVtUFYFUGEDhF7j4ha4p1hqS528ixVr+igJ35wiPiIYz6G+Y8Z
         85+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792608447; x=1793213247; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dSTZtcyPK3yzGl0K7b9zLKEzjIcPw2EBeTAvW8QX6I8=;
        b=g7hHjPy1tacfFQpQy6DU+RIlhqEOm66Cb5t8MwWeeK0l9liVmfw4/+7aMo9R3O8Bdg
         xPxIbRpl86vdTwRdNpAgTW8mMGvo9n56G5544Tbavu3aA5ZZ0fipoDr/BMeT7VKuv7VN
         ZhRcUdZaKLmsnshFVc9dHo5ZE/faP4kCnG8JKHOgEP7hAtxJiilG1HKR+0gv0xgNuDFA
         m6GhfPk6R10tlNNh1kaY0azFbJbxDBVMDsWDNvcqjrC1Npde0ZLSc/EBEpMbxLkX23P2
         lxU8v/2AqM4Q1nlUkuT4CK2Jkd/fSPHcWg6lbFZYKJ+sV0u2tQLuNvCLAtISU/1xLkMd
         QSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792608447; x=1793213247;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dSTZtcyPK3yzGl0K7b9zLKEzjIcPw2EBeTAvW8QX6I8=;
        b=Z9XrGwg8RNt2LQGKD+qC2yZx8vyioLWO2S5rdHEAcTIhipTkuxOZjGy4SlzUrV9e0V
         383KTbMAuoexwOaXA6wCyuAsyYgA+DPbpbfJrWP/E+jVz6AdNenItkJDimMcVGwJ7KT1
         7oydmqYOMBzPiicVt6oclEeQuIiqcpcbPd5A50ocaYi1Bj1wScI+WR3Ev/R7/8xIaI5Z
         Qy9ScUQ3GPqL1C9haAleap2P7P+CKiQeUraz8aNALFcTktqTve6AS1DH9BtHuRF5AjqQ
         MiNxoftJTk2pjlfyVCPGYi3lQmFwsprTy6fJOZGSTfb96cL0xqfYDzeBgPz7ehy1wAGk
         3vHQ==
X-Forwarded-Encrypted: i=1; AKwUvBytUABicUuNbqfnYTrbV2qJ9xTwDh3BxEXsmftgyhiYkdKwtW0YUquDFng5OphJsvOnyS71zELCkg==@kvack.org
X-Gm-Message-State: AFq9FYLrOKv6plo1zaIarVXTP6km12/85UVLBKaZ2cadgnrf6JPLOgeL
	ActZzk6Ni7BhKYEdo+s9mk3vaXcvo/GaYjhcSJYhbkFepJb+lnqpSTJg8iuEuY83Br4aPS5q5es
	AwiPPdEJlJ6C4BQRq9sNnHbYqogvB1REHftR7SymY
X-Gm-Gg: AYBFou3wkzTslqmWwVEkAR/DDuIIAPNTrCtOxyCCyf4s/4KBrHx4unfc58tGw6nI/eq
	AKN+wiLaln5kV9ML91OcA5QEnN2jMKH92nYQ8jYtguBlio/JBWlN+MKsWDbfDNxeKV/GBTF0LV3
	89uOT+hqNhOag4oGaB3mIXZ9Gh6DOfYb+EvSQREyQd3rlHHY25DzXJZXbrDvRljXFeI8oF1JWHg
	DTuv4rEFv2eCMKWSRSrwfAFECSY99R+H8VhGlxKrq5s/FIFow/aKMkrhkZq7Pihr1d47joPgdok
	IYlB3vnQe6f1rCBlULSJUjiv1AW1uxeW90p5uAjfi11TrQHBUxuKc10RpVb7/2SCcFWA11qjSzm
	higTFu3GR1hUqe+8xTLvmXkpgLES89nrlR5JijXWqmwVZMW7Ze5rMWD0v280=
X-Received: by 2002:a05:7022:2507:b0:14c:efa5:ee7 with SMTP id
 a92af1059eb24-190a4d18cc9mr4696437c88.14.1792608446024; Wed, 21 Oct 2026
 11:47:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com> <9huzecdi6go0.fsf@tarunix.c.googlers.com>
In-Reply-To: <9huzecdi6go0.fsf@tarunix.c.googlers.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 21 Oct 2026 11:46:56 -0700
X-Gm-Features: AclHuK9GVWu4pH4tc-A36maNXu-EHT2uwChCmCT-hqS2EBFk28gxkLJBLwcVEzg
Message-ID: <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: tarunsahu@google.com
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Andrew Morton <akpm@linux-foundation.org>, 
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, 
	arnd@arndb.de, jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94614100008
X-Stat-Signature: oqujzuugz7w8um8f13xcuo3cu4kzxydn
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792608448-415206
X-HE-Meta: U2FsdGVkX18Uz+LuLbKs94/pFfc9DFM8KNrEr8xRaP97lA7ezCzKkzC3Gr727aVYxwOk5cMMiIBFoDluLGX9UprFMkFub3l6lCy0GF5LF8MScJSJtb+Jw2LrV59ErE2FMABPDH2jjkQbmzcThkSwiYo2HO2f5EgTYjO/HnGC2rPBc67Ayn+VIyFFy6E7tVgvPIlS/buLPipiLoLLJhUYkIBiyq5gUMS3mNFotc4fHUDYlH59tcSmuW2BOhzaGCPWqcyqf/p4uFSQilkiCo+cEgtxVB8YNTkBH1NLEoYzAEpn+KH6J1LyYW0TIHA1DMaKGigC3nS4JyFQzEYUPRruShn0Qsa/CSUqDNreNug4FZXTF5+0jXQkMsUiSVxNwcrdbQqWHJR1BgSigAJAwaN1AqWgfnhmcWJ8IA6KTdNqH6VsunGldZSXY1ApvgYapgZn9XxLZjr1GuVLxTsrBKS/7m8INm9WS+uh9BNkzDtT/lA0i4brFuVUAmaZl3wgtOBueBdkj3+fnw/uGawT2shrODa0n0OrrdZlQEwc4gpy4iXTyjSaTxYrCTJLMmia+A9zyDmxCB6SkYxZ7ssOAJ7YnE+VTHHcA61GACcuErI9u/5RUydQ3E1RjW6/fY7ikSd0n9liPvSnJdSCAsj7etGV7xKe1yp5CDS7oWfm5KPVmvtuLPPW8My0StRpHUGo34ScpHe9XLvy3NDGDvGXH3ZCduC+NZ9YtU5xTtrN2Zwdq7JfoAQjzyxLBSlLp0KN5kF114OeEiuc2M81fUH5QDRnu9eCY5KzDa94n81PPHdfwu62Ti9d79eQROjEkjgFFfN2jOJdPXCL1PV+OpDXFrpdOvPSx4RQ7S84TSVCBmgOT22Ca1n28sSIrnffIJru+kGHDEkzKKP29gEt/OM8z6IQWtOxWvdnmEq/MkyOr2WoqizCVXUl+YyrxvuGp2zxb9YjUzE1Al/m7kkdGGQOdQH
 sgzC2O3l
 Ud0Zy3lQucYUeWC2pceD3+gsxArCymwDHtEhrtqxIWjcwh9kSYLWsyS3SPx+thFow1RhqrgAp4Un1WJDa0uaYq82yQkyMmoqYI1+UWDY80OmbGJEhQTngnF4sRWtZyATWALFS0NtGpArUHqIZ6AHQzRtPjPNb5UZ03RDojkwzZpKcVr+4NmjN1yuKe08R4sbX/piZJ2K7+pKDSXuFHBFjfYj0n7uPhik9a5IA+PfojLso8JssYH8isa+YQnxhxi/9IQ3IjwpXv8d40WdZeA9pZ+8jjgsZMluHrMz0us+r7dEWFWgr3uri+RRe9G7uCqB/rv60
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com> wrote:
>
> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>
> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.c=
om> wrote:
> >>
> >> LUO and its file handlers validate handed-over state with monolithic
> >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serializ=
ed
> >> structure, even an optional additive one, must bump the string, which
> >> breaks live update between adjacent kernels. Replace the string in
> >> struct luo_ser with a feature header, so that the target kernel can
> >> accept or reject the source kernel state per feature.
> >>
> >> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> >
> > This patch is all wrong; 128 bytes is far too large. For every _ser
> > struct, we only need 8 bytes instead.
>
> NOO, It is not. It is intended to avoid complex mess with unnecessary
> over-engineering.
>
> >
> > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > 30 feature flags + 2 reserved bits for flags extension). The last two
> > bits of the flags indicate whether an extended flags field is present.
> > Each extended flags field is 8 bytes, and its last two bits indicate
> > that yet another extended flags field follows.
>
> If we will have dynamic extension of flags, Think about this.

To support dynamic extensions in a backward compatible way you want
something like this:

struct luo_feature_hdr {
   size
   flags
   extensions  // offset of first luo_feature_extensions (or 0)
}

struct luo_feature_extentions {
    flags
    extensions // offset of next luo_feature_extensions (or 0)
}

And then an example serialization struct would be:

struct foo_ser {
    struct luo_feature_hdr header;
    ... fields ...
    struct luo_feature_extension extensions1;
    ... fields ...
    struct luo_feature_extension extensions2;
}

