Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BD4606A325
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=o33m3fv/
Received: by kanga.kvack.org (Postfix)
	id 8B9876B086E; Wed, 21 Oct 2026 23:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869AD6B0870; Wed, 21 Oct 2026 23:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731726B0871; Wed, 21 Oct 2026 23:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 468DE6B086E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:53:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD340120744
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:53:10 +0000 (UTC)
X-FDA: 85348891740.02.9D09E1A
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id BD28520009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:53:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="o33m3fv/";
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792641188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AuqEvetTId+KGd9+1A3sRuao4CeyCeXTKq86oAL9AY=;
	b=uhHKwLtB2lz8bZC4pg2vZSylzEhnrPR3RuUDGEnEDtwAFIAQ09N2//vJpVrpZA2BDPyT7k
	64kl/03QtkpEQ3Dr3j5MFsG8IRbwcKi5mpPlPKikECcQnkZ0V/oUn3pCh2r32UI0/ii9tw
	sviS3SyVFPvceCCaFhISyWr3iqy2jlo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792641188;
	b=GNDlr4sFn+tj2eOjq7krSlNASGzizfEu3CgWpO97s4ac7G9+PQ5qW0kfbNaBJX3Q69TBcm
	EjJfAvE8walnqR6Iwe92ODqT7Lj1crHt7QBex5o/ThpJyq3NlYK150JCh2e/aFXf5wpevu
	Bs0fBkfPfe6RRDvPHJ36ZsVqn/z+Ef0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="o33m3fv/";
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4322d310e7so190658966b.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:53:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792641187; cv=none;
        d=google.com; s=arc-20260327;
        b=HqERBNeiXa9BaKpf5GtvZgiNNNbDcDyRulVA98MdZsgSI008QGml5nrOB14MRIF+3q
         6yOZNcLn0B4TPXbItrJ1we5VcU3oFuO11lmjKsMMFYHdwQT57E6aodt/vH6Gec6LSWKp
         okLwDKf+oFuDnhD4XNtt1h5OXm+48eGh6MoQjEug85A4jALGpvmaR3Xmgin5IgqpFT0X
         yYcA7Q8hrXOqF2nQ0wMr/xMjF319EBtPDG8GT63+Dj9PMy24OVHmVZon+mmxA5qQscJN
         FCznrSwvO/zQVUrU1UwQtVj/JsXIuorYjBDKHJ+4c2cmHeqCG9hmFHrmeTxkbYGl5GLN
         W6Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5AuqEvetTId+KGd9+1A3sRuao4CeyCeXTKq86oAL9AY=;
        fh=9+PU6f1TojM7k1OP/C+O8SSQtNGITiu0nFmChgE7N7w=;
        b=nyyFfBVVq8dPXTN8EhDzXKVOWCRW1EYs9D7lJzt2sK/yKjZcEPT3rabHQQtJXdejrx
         lk23JrjIKOqEEeXMg274P/qMDcCzJZ0MIU8PQFwrPKOkUrcI8xGLHXu6jPiub0wmfUB2
         zj9Rd3OUOjuWRWWVZVdDKJkkk/eWfqxt8N6y9tF9o00Qe+DrmNzH712u21e4FNoxwkb/
         btPFoy8jqYfs/SBc+l96VuYSk8lpG6rN9dJEo6TJF5YkBwv/i79dcqykenhjwhEGdaGn
         60dPP1Ly2992q3Vk0r+JpvH2lsGeZdqSBTbleBCQsH6byXN3J1jFm548ajCAHNgFpugl
         jebg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792641187; x=1793245987; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5AuqEvetTId+KGd9+1A3sRuao4CeyCeXTKq86oAL9AY=;
        b=o33m3fv/5o9cIkPkebrdOrwzyuTH+ks5juhFe4Doq4OjR9wRxZwaHtCz+hYHNLoDue
         Xs7J8cpLxAg4bI1g13lmYWrAkxs3ybPIhHRGsmV/2mYIE5pV4mGCmPmYYWmA8BIJriXa
         pLFDyszN9lHLlnKZOG8jt1eZaw0SAl9pq/g+0w8/mlgOQjhYBTSDImQO/i54RGOosmAB
         WI0cs3OdRjurIBLUSV2hgFwouZrChfFf9ESLLabBW6mDwsbwCt+y8eJZFw/W1eU4uZFh
         30+ryOWdfdYuwFWDM086iE4KMzLRoq5X83EES1KHkIUvIQ2wHwIOIeoy5JEHXeOdWDru
         Szqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641187; x=1793245987;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5AuqEvetTId+KGd9+1A3sRuao4CeyCeXTKq86oAL9AY=;
        b=ipueGyJLoeK+XEY7KC8J1K54UoQL51ig398rKHtpQLNxPpBdJR0XKInWl+l0vhkOSy
         RjEx3h/fcIjkGOGmRpALeQgpuUufooYcxqpWfbJObu3lLAaL0fO3Y+hINH+3GwLusJX0
         tSFiVhJQyHFtOq4QIzUXQV5UqnmprRkdUJNha8RG5nfXsvq4HO0wCNk9CrByQCAMZ5WT
         U1f02aUtjICQsuUJm/1J+16FiqinEsRpwhR7G7IbbTpCtDbwm5WW3aFP+6jyXRRErznR
         L+VbP/0AxsQMMfZy2skkyjjUqzbBPfgHRZ1W+2VCD3lf0AjINjL/gANGIcc4QIp9Pbw+
         Z3+w==
X-Forwarded-Encrypted: i=1; AKwUvBw+FW+6kdmAjaiR3YdFVKR6pv+SCPP2Vj7QmCVRay+3eC/hyrNQtK/0CRI/aYMDk3I4EEX09v07+w==@kvack.org
X-Gm-Message-State: AFq9FYIOl3yvtsUA9uukWx08alCHsBo25g3t5/IhRLKAXiXLH4AT5vad
	kyzja2YOoELo7T7+O1iKPERJjenf/bfQ9fTG5dj0PoMqQIYkq3/tdO6dFKs1gdr3aGZvfaZd9W/
	eAxpex7h+IpNlIlisiD4hPdcOG8YRcHj5MULEv4F7
X-Gm-Gg: AYBFou3mPBbaCKq2AYlmQ/KJIqIlR3G5TBrVcWQF764t6Ks2kIqSQOl3ugvVhDShUzd
	jQsO96tq+T//XkuU6B8AykKCaI6y7B6tNSWu61Q63MAXPvifd9mEiSMxlQaHOfhUZMVx1xlp/iZ
	zCU1jUTOR2eMzQ53Qogdw/d0G2fk9AdCQGy6TwQs/9YOkuiGKDaf8TB+PkDaB4Oc2PSUYD3GH6j
	xsJGQzHsoOQD/c6vSfiviQDSV2lfejVQ/MwDefdVAvtN0l11HSFVe1LeEvV5+ZVcz3kmd5AQfkp
	gymzza7lWKCkwlTnpCP8ke+Ot8kQHRaMxMKr7DtrGmnpiQP8SYuNIM24K6EnKYAXLilo98Wa2HW
	YBCAwVG3IPfKauu9ejNXZ8yPffBfJedYZKr9mTA==
X-Received: by 2002:a17:906:dc89:b0:c40:f9ea:7387 with SMTP id
 a640c23a62f3a-c46791a979emr355026566b.6.1792641186777; Wed, 21 Oct 2026
 20:53:06 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
In-Reply-To: <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 21 Oct 2026 20:52:39 -0700
X-Gm-Features: AclHuK_94mheSr-cOV0RjUmA5boG8AcWT7XfL_o8Cm1BzPA_mpTiDbYCVzKwGVg
Message-ID: <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Pasha Tatashin <pasha.tatashin@soleen.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD28520009
X-Stat-Signature: 1e7xj91sh1ryjyn4s3zf71suaxkmi9ke
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792641188-575725
X-HE-Meta: U2FsdGVkX1+j5RORYZWY/WlENtDi7bLRDXXj6oDqZGNhNnmJWvRPuHS4xngc/OkL4n5OQtf4RLT6pTaB3in+43D050TNdJFhTXw3uhrRvpiv3cv31b3k0BHQwTmyprYDJ6t4VPqXbRkVhKmI4UPs1mDn0KBvcextC4g1DoqHGo/sMjzaGAcK5SVbGQa+9yLOvNGKnGi6zhiUTGdM9eNctMPDZFY1Mj/Gc7q84el15gzn9+NayXpLvU9c0RV0aie9aaig+ycnpLwLwAzG9vATBqeSZFx0uCgly7klyRBiR14rZiTy+VLZTgLueebsgt5S1axdXAecN4Itl1btVnQJrtsV4M0GRFHySS9n+IVlYCZHffRbL9l+g6CQTIfqqTHDMgj+uJ8ZhtlZPOA8lYzrTka6grCH2JnXaVkXWp4g1yjCkyYZa2YohkEn1zOyTHOpP78nDU79tHUbP08hi19+67wgnxhht49+MNl002o//M1I2Yx1lEuGJkQGbCgFHtHXwJ/xDNOHM0T+CVv59XGC7tyTBFuzjORQ085oDDIh3zpyhAzAIRfqrMDipCaCf6BxdJ0xS4AaMPdHO2QPxIhXBgIvO42V2WP8UKwsx7+xwfQrmsBWjJhK+VBSXQsWmmwxSeU+dzGb2PJjQq8VGaYKOE4c240tvMLWSC5HqmA5k4tMsYZklSqyx4VtZmAxOTQ0aS59YvPfhlY5JT7z/Pv6TOKOxNQsh2RuqhK2E07xGqKxb5vyTNqZC3k6DZUXYfkK/itn7fCmAVUN8d5Iz29iHDKmyAStYxb03St6Zgt1Dsi8xOrR1I2SRo6PeBsV3JtULnLhYdyuB77o991MOj9NYVzN3GCTsuJX4axTKm0S46BSFHhneLFO9YaOgfUK5RFFvaTNKj0wUP6UUtVmEecFuIybzq2uzfMjPBPM5bc9YuynBgVnHsWqHw79qOA8xejT7ZU3QBDg/tuwHu5wU49
 AtGuneLY
 nD6b1HxnMJIZsJQ7ND88M2pK9KqyRc4fVPIyTkJzOcNQjSrtio5sEq2EjE8BKSD0n84DBj0KI58QgKBK5nHZ6K1o/xg/HRVPHYN1b3+t22SE/ayqJ6dq8GwbSp0GbpwSfKNgWipFXSqjmRxtTQIdpoDjq77cs2/fsQqg95yr5QYYpcFaTKahoFP0PrRUzT8XhGQ6zBM5H2BLZ7nvVHnZb7sXsPRvbDnC3YDJS+G74WvnEEzDfIghfng4W4gpK9e5iT8dZx6pahUYCG5kBYajqkDScDM0x5sz+GUBAvK2+cqRP1nxQ17TB/PfvnI3FTyzfCMXV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 8:32=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Wed, Oct 21, 2026 at 10:57=E2=80=AFPM David Matlack <dmatlack@google.c=
om> wrote:
> >
> > On 2026-10-21 09:26 PM, Pasha Tatashin wrote:
> > > On Wed, Oct 21, 2026 at 7:28=E2=80=AFPM David Matlack <dmatlack@googl=
e.com> wrote:
> > > >
> > > > On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > > > > On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack@g=
oogle.com> wrote:
> > > > > >
> > > > > > On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com>=
 wrote:
> > > > > > >
> > > > > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > > > > >
> > > > > > > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <taruns=
ahu@google.com> wrote:
> > > > > > > >>
> > > > > > > >> LUO and its file handlers validate handed-over state with =
monolithic
> > > > > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change t=
o a serialized
> > > > > > > >> structure, even an optional additive one, must bump the st=
ring, which
> > > > > > > >> breaks live update between adjacent kernels. Replace the s=
tring in
> > > > > > > >> struct luo_ser with a feature header, so that the target k=
ernel can
> > > > > > > >> accept or reject the source kernel state per feature.
> > > > > > > >>
> > > > > > > >> struct luo_feature_hdr is a fixed 128-byte header: the ser=
ialized
> > > > > > > >
> > > > > > > > This patch is all wrong; 128 bytes is far too large. For ev=
ery _ser
> > > > > > > > struct, we only need 8 bytes instead.
> > > > > > >
> > > > > > > NOO, It is not. It is intended to avoid complex mess with unn=
ecessary
> > > > > > > over-engineering.
> > > > >
> > > > > 128-byte per serialized struct is not starter.
> > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > The first 4 bytes are the size, and the next 4 bytes are fl=
ags (i.e.,
> > > > > > > > 30 feature flags + 2 reserved bits for flags extension). Th=
e last two
> > > > > > > > bits of the flags indicate whether an extended flags field =
is present.
> > > > > > > > Each extended flags field is 8 bytes, and its last two bits=
 indicate
> > > > > > > > that yet another extended flags field follows.
> > > > > > >
> > > > > > > If we will have dynamic extension of flags, Think about this.
> > > > > >
> > > > > > To support dynamic extensions in a backward compatible way you =
want
> > > > > > something like this:
> > > > > >
> > > > > > struct luo_feature_hdr {
> > > > > >    size
> > > > > >    flags
> > > > >
> > > > > __u32 size
> > > > > __u32 flags
> > > > >
> > > > > >    extensions  // offset of first luo_feature_extensions (or 0)
> > > > >
> > > > > __u64 extensions[0]  --> but the size should be specificed in
> > > > > declaration macro that I showed in the next patch.
> > > >
> > > > I think you may have misunderstood what I meant. In my proposal,
> > > > extensions is an offset to the first extension, not an array of
> > > > extensions that immediately follow the header.
> > > >
> > > > If the extensions immediately follow the header, then the number of
> > > > extensions is baked into the struct layout. Every field after them =
sits
> > > > at an offset that depends on how many extensions there are. If we e=
ver
> > > > need one more extension, all the fields shift and old and new kerne=
ls
> > > > can no longer read each other's struct. That is the problem Tarun
> > >
> > > We can structure it cleanly by nesting the payload: something like
> > > struct { struct header {...}h; struct serialize_data { ... }p; };
> > > That way, the header can expand dynamically at the front, while all
> > > fields inside `serialize_data` stay at fixed offsets relative to the
> > > start
> > > of the payload.
> > >
> > > Since the header size is self-describing via continuation bits (e.g.,
> > > the last two bits indicating whether another flag word follows), LUO
> > > can
> > > easily compute where the payload begins in the incoming blob. This
> > > keeps the implementation simple, avoids linked lists of offsets.
> >
> > Oh interesting. I agree a dynamically sized header at the front can wor=
k
> > and is simpler than a linked list.
> >
> > So the header and the payload need to be separate, and the payload is
> > located with pointer arithmetic on the header. For example:
> >
> > struct luo_ser_hdr {
> >     u32 size;    /* Size of the payload in bytes */
> >     u32 flags;    /* Bits [31:30] indicate an extension word follows */
> >     /* u64 extension words follow while the continuation bits are set *=
/
> > };
> >
> > /* Size of the header, including any extension words. */
> > size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr);
> >
> > static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> > {
> >     return (void *)hdr + luo_ser_hdr_size(hdr);
> > }
> >
> > On preserve:
> >
> >     hdr =3D kho_alloc_preserve(luo_ser_hdr_size_for(nr_ext) + sizeof(*s=
er));
> >     luo_ser_hdr_init(hdr, sizeof(*ser), ...);
> >     ser =3D luo_ser_payload(hdr);
> >     ...
> >     args->serialized_data =3D virt_to_phys(hdr);
> >
> > On retrieve:
> >
> >     hdr =3D phys_to_virt(args->serialized_data);
> >     err =3D luo_ser_hdr_validate(hdr, ...);
> >     if (err)
> >         return err;
> >
> >     ser =3D luo_ser_payload(hdr);
> >
> > What would size mean in luo_ser_hdr? The size of the payload or the siz=
e
> > of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing s=
o
> > maybe it's just the size of the payload?
>
> > What would size mean in luo_ser_hdr? The size of the payload or the siz=
e
> > of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing s=
o
> > maybe it's just the size of the payload?
>
> Either works, but having size cover the combined hdr + payload
> provides a few extra guarantees:
>
> 1. A single static_assert validates the entire serialized struct at
> compile time, including the header and the number of ext_flags
> elements.
> 2. Bounds checking while traversing the header continuation bits on
> retrieve: we can sanity-check that luo_ser_hdr_size(hdr) <=3D hdr->size
> so we never walk past the end of the serialized blob if there is
> memory corruption.
>
> If we declare the payload struct separately and pass it into the
> macro, handlers also get a clean type for luo_ser_payload(hdr):
>
> #define DECLARE_LUO_SER(name, expected_size, ext_flags_count, payload_typ=
e) \
>     struct name {                                                        =
   \
>         __u32 size;                                                      =
   \
>         __u32 flags;                                                     =
   \
>         __u64 ext_flags[ext_flags_count];                                =
   \
>         payload_type payload;                                            =
   \
>     };                                                                   =
   \
>     static_assert(sizeof(struct name) =3D=3D (expected_size),            =
       \
>                   "LUO struct " #name " size mismatch!")
>
> For example:
>
> struct luo_memfd_payload {
>     __u64 pos;
>     __u64 size;
> };
>
> DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);

This looks pretty reasonable but I would name the payload
luo_memfd_ser. The combined struct that DECLARE_LUO_SER() creates
should never be used directly since the offset of the payload in that
struct is only valid in the current kernel. So I would give that
struct a special name that makes it obvious you shouldn't be using it.

