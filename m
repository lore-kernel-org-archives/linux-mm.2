Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80782606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 18:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=jPr8oQWx
Received: by kanga.kvack.org (Postfix)
	id 9EE346B0255; Wed, 21 Oct 2026 14:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99FFD6B0256; Wed, 21 Oct 2026 14:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890D96B0257; Wed, 21 Oct 2026 14:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D98B6B0255
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:51:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFB7316061C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:51:35 +0000 (UTC)
X-FDA: 85347526950.10.26A6628
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7321180008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:51:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jPr8oQWx;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792608693;
	b=kR69358Huk6ktJXX7gjj1ZuwRDYWzKDHn1KQTBaR2+1utZfpDXJLaZ6+tf8iH3FMhkII3N
	x7fcolj6OvIkC09zWwnmhmkvtpJDSnzQDFNTVkSutnVmaJovnRvV5145JwbeNv8j42FdtU
	Fv7zXuWuUdYDutBofvSw3431vdQyCVE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jPr8oQWx;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792608693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2oW+YxRWdAsPD4uJs1XKcHYT7T/4QzyNKf44tXuYtg=;
	b=o0/Mg74oO5AsE1WL7TW5vWMHKpAnPrWmkJFUXL+uWRYD3fUqAHA1EFXruwmFb+Y6yPOL80
	zZ4cl2jIdvdnF8QNFlIaRUzK6WhH1uYsRKi0ykU6xSLu8ZhIPjYERNO//wSHsYbJaBvSbu
	30ucmCKh8z0enjqrAmLbcJycecKUMYY=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so1465386a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:51:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792608692; cv=none;
        d=google.com; s=arc-20260327;
        b=ckQR52TjOR1Q2k5YSPLqVGvBLEo+dnVnfffIADqnhGcMb0koRwaOkaQcZfScHVCMgO
         V1QarfciQvFyrcAe0VDdapqVTTlItfuqpmFXjdgQPDbjmzazX5Dgdjd6oGVynlVOWxRr
         RJOtSG5Fu3Ng/t70V8sq5nN6PvN4a6bTOo0HV1q3en18OlBbCx2ceTIeDHCjJzyYp/Yu
         3fnFiFrVElAs5/1p3St93LDtJyiQ4arTPRO5cvjKdYujwxljhHEPezbOPNk3CGLkJdM9
         ywgFu7E5wX3IN5OaObdbW2zTsZ/zdehilaYJSXCUtLDHhEfPIk0O+/KE4vKT2P5cxyQH
         25bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V2oW+YxRWdAsPD4uJs1XKcHYT7T/4QzyNKf44tXuYtg=;
        fh=HUxCtdME6SHZogRruFa+XJ39hv0q7TzgiVWBb/hd8BU=;
        b=X3jxv5+KXFAQ5n0OX5TNXrx5iJBenlyywINDeXRwUjdJKDX7QvpWCx5zxI7cePxky/
         m3+nZPbXPoF2ZlOB/WNBprBGomv0RmStI2A2w7q/crqcdiZGuFwa7eVXUrhpf5V3CZSj
         kkT4pTNT+bKtHETnnXPs7yeFh481ot1ikKhjepN2HxfsrGA2YdQIMsFz0y2ijwAF1Mie
         HU18pQZPr6ctm0cuAqYTpplXIIduv0r5KJmWD4UtrWNxdTa9gG/R6aol+Xjg/Th+Z1ic
         rmIY+ljsJM+2dkAe4t79zP2+CmIeTH+yPbufPSerTjlkOqnEsF1VwqT7JqXStaZBoV8V
         2uTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792608692; x=1793213492; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V2oW+YxRWdAsPD4uJs1XKcHYT7T/4QzyNKf44tXuYtg=;
        b=jPr8oQWxbvxdYNpeRLyMnM2itAKWqCcMEpzXPdy0MV5bjJDI+OY8b2IdMPKYzviD3X
         Znr9EUnVTTX/EgN4kbuzZIl/5g17dG/1E5Qoxp4rqd+PfGhCtbBolWPZid//xc1bgAAt
         CrG+kWMhxTUC0KoJB570K9a69QBey/WuoJSTJ7EkA380bjt07iIpG0cf0oKHx1WRRr+x
         LNHlhbNG/VqtgrPBn9n2kAXGmVjklpsgkwjY5tx9wqvdnEkXkszMDy5HmDlmMCmEkg/L
         tM5Uc9Gp1z7YciIBuKiiK/1Aq103/upvF8Huj5Urg6k2g2T0vbC94dHlkb1uf7rv+1Gv
         5WSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792608692; x=1793213492;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V2oW+YxRWdAsPD4uJs1XKcHYT7T/4QzyNKf44tXuYtg=;
        b=rBXsc/5G8nrlthiTRMV9qBUUfYXLK5ePpJJVpL2U+UmPMwIPggogB/vJWR/Xm1L2Qm
         foelrlULYaFmSUa/BpK4opF2OE7y68iyUhq4j8DdKCsC/UkkO8O3vuVRqGMfaGK5XcBk
         LNH88RKPAeJJPtW/0B9ct/TwFDaKdXWP7NfwUT+G7ErF9ggTBwG5ycdXV1umMosjwPkC
         nD9xPRVXRlY6xZPU4TgKT/HRjn5QaKbeGbtz24oOzQvMEev7SMhXCzAd9X089IGWz7Z3
         nYixdgNkKeeDzAguaojoDDuyfiyra7sbQ4JW0CprJ9B075b6qxK3dajth3uHZh34uxk1
         +fpw==
X-Forwarded-Encrypted: i=1; AKwUvBxp+YJ4oGYdktEsBDiVwalWHVbPMhz+3gDQfuzzcVKmph6aurfQW27HpQtnJD4EmKeUbuOEYv9Xpw==@kvack.org
X-Gm-Message-State: AFq9FYLEI1Zp9Zq2AGFUq1zA49O6/WXKDrIzQ6PgGN1XGjSDVhkz0N4y
	d9B55xt1dIkWLG45osZKe+6MQmbeY58wGJbeEenelqp9Sff5HsQ3b+qN1pwl+JgW8sp04speZHB
	0t0KS7S5EIpT1p7xVg+eRGddx7JXext5z3X1cTDsGWQ==
X-Gm-Gg: AYBFou2q2jO165M8yPK67cL8BISQMXuu5KYLUvJ7C7xrEIlSwrhgx9MNwyHzsf7jb74
	L+kY0X5rEFfNHx44Mdla61Cqelyz8kDms35RVt3XOauIgqzPut+oP3KTNu5D1cTCFu5r2zfPvW6
	4mRnfA9R0jzzgP9vQvahepMQVfqZ1/hrhls397O9nkqhJbP23Gx3mT75REEekGqLI6hGpcHoyEY
	pD4GMAGtluK2BJKJ+PDbXqmXpfyolMN2AMxA8nwkVIpP9at+AoLyMW7XSJ5aduBjIm1lkzS3R6/
	M8WqkyQvTiZkKt3TMGZ8HAtKTzSABJXde2+GfZ7aNQ2ph//ZKcVZyjGtn/qa8oe0eKkQVW3fMpU
	YHUC+ZQ6SZg+SaaY/i5kbQmS/TdzAaVQXv6C91yzlN6QYw+fCau0NuSoxOMku8zo/m+E=
X-Received: by 2002:a05:6402:241a:b0:6b4:1df2:244e with SMTP id
 4fb4d7f45d1cf-6b41df242e6mr53870a12.38.1792608691873; Wed, 21 Oct 2026
 11:51:31 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
In-Reply-To: <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 14:50:54 -0400
X-Gm-Features: AclHuK9td__2XcAMViewCe_NhDoA_TjTC8gr4y8u3SANqGewpEKZoTgIKv6iXME
Message-ID: <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gj8ngdrzbub9i3u55s1nymua7bjg38a5
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7321180008
X-Rspam-User: 
X-HE-Tag: 1792608693-129252
X-HE-Meta: U2FsdGVkX1+H7vq74KWYUDCvx9DVcr8EpaarHfxrKA3qj+SnHQHpVWiFkwbHkkpvinWbR0W11e7q+8wnAhNx+hFgWBkSy6XQhJ8jxSnogmD48iEBPXfoeN8pKqI1Wpl3qCPo6bVuJ+gcIzQ2QXosGM3aEvvS1pi4DwFfrmAbopp613UNKCTqlFBrpcU/y1UkGfUWgYLvggfdP0qvavEJmT4yfiZCMsfVOLaDh1VGcE6ZxUhar8QNIkVBhy81ofMfdnltXHdghm31VDMX3VNyNZnKMVd0R+zNDEqJFbGaSUgxJSnBsv6BI1BxJqH0rWECodb+SLQ+cHeOK/dTPJKOKkhElk9c+hAOHyNdZIusbP6/gCKuHBS3hcDBlyBkQ127/PThpX1zfdrh7yHc5DSqk04rHKTYfIn+fISJgnDduTdf6e9SvWETswFSEOxUurBV++kTLg52lhv9/b9WZEBj+S0Sy8XvYsHXj5jB0B+SWUDUuX6IepC+DVgvWoy9StM+XUFVg+5xNUbB1zN6Fvn74oL0O1O2j8zXIKH+u5PyBvsTu3PQroLqmt4b2H83/KCFzh721ZB7XD6AVzVyIS47UH4v63qI0w3HhyStGNLNaWhTMCprArpgqpYDPagKQZruzGrRbEGdvw1o9Q6MocrDN0GYKYd+fL/Ks6vmn+XyFbAElWM6vMo8WF0+xu45U4QC4ERF6dlQnOzicS2BXLE2awxyhYHr9blGzKYfWODdrATmgYMSnut6SBxnf/tkUhpg2dmHXZXH2AKq3oXx08/2U6eWQLhWyBIV+wYDaefv4Wf3l5Dk1QJPIMDM1MBlxzLyuV9ndsulaa16mCsk2QTA1K363vnQej1PlFfRV2hZI1+c3KFW8Ky0Wejt+sNpywlX+gS/toF+HyDJTfSoXSv+D6COsGzFRgkjzqdPjgLZ3QrrWgCNujOS3XsR7bKBV2eM1sWcXS6lZLfd8En4ZFv
 t0M+FcxQ
 naHL2QlLG1RveHOl+y+ziC+ok0/RvR0FoIgamNubMW4pEcT54LE/cHg6tm3GokVGxbupB5FAq4eI1f7CO+O7Ry5Y0b/Iz/YCe0td48HhDPNYuxCN2ApegzWI+cyMOWwHs6ZwL1cpwGZ9TfWMbiZ5FWXw4IYdvMzQlVh2WSMkVPZkC0ZiOLfUxU6XaRd5wdDpgbxaYk5qcb36tHCCcaOIV0JyzCs+wRxHxZ11JKth5n5yEQ2iO0vNygtCpabtZN0xSRJxYZoIUG0LTJWF6s3vypanRNhQhFrarSEYUNmDQi0f64G/8eIVcd9Hct41OVjtoJ8Av
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com> wrote:
> >
> > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> >
> > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google=
.com> wrote:
> > >>
> > >> LUO and its file handlers validate handed-over state with monolithic
> > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serial=
ized
> > >> structure, even an optional additive one, must bump the string, whic=
h
> > >> breaks live update between adjacent kernels. Replace the string in
> > >> struct luo_ser with a feature header, so that the target kernel can
> > >> accept or reject the source kernel state per feature.
> > >>
> > >> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> > >
> > > This patch is all wrong; 128 bytes is far too large. For every _ser
> > > struct, we only need 8 bytes instead.
> >
> > NOO, It is not. It is intended to avoid complex mess with unnecessary
> > over-engineering.

128-byte per serialized struct is not starter.

> >
> > >
> > > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > > 30 feature flags + 2 reserved bits for flags extension). The last two
> > > bits of the flags indicate whether an extended flags field is present=
.
> > > Each extended flags field is 8 bytes, and its last two bits indicate
> > > that yet another extended flags field follows.
> >
> > If we will have dynamic extension of flags, Think about this.
>
> To support dynamic extensions in a backward compatible way you want
> something like this:
>
> struct luo_feature_hdr {
>    size
>    flags

__u32 size
__u32 flags

>    extensions  // offset of first luo_feature_extensions (or 0)

__u64 extensions[0]  --> but the size should be specificed in
declaration macro that I showed in the next patch.

> }
>
> struct luo_feature_extentions {
>     flags
>     extensions // offset of next luo_feature_extensions (or 0)
> }
>
> And then an example serialization struct would be:
>
> struct foo_ser {
>     struct luo_feature_hdr header;
>     ... fields ...
>     struct luo_feature_extension extensions1;
>     ... fields ...
>     struct luo_feature_extension extensions2;
> }

