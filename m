Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E407C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 20:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067306B007B; Mon, 27 Jul 2026 16:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FBE6B0088; Mon, 27 Jul 2026 16:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A256B008A; Mon, 27 Jul 2026 16:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA4536B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:06:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EC37401BE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:06:36 +0000 (UTC)
X-FDA: 85035639192.09.337822A
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3126B180007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:06:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EupKB36x;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785182794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WT3D5aoPs392vdVyfO0XAxS3rqs8yFAgGjz3WyPghwM=;
	b=m9U70Pjc6dTq6KIJOPOKtCKe4jCZa2wiEe+1i1rXSocNjzShAs77dXSdsRLNwiajjO15ON
	VuzY4C6NLhax7q6cCWfy/edjcsVXVv5ZVwmuyMG62S8y8+zbnCkpMDf883ze10SMVvZZyf
	uH2q4bdCVpWEXx7YJ20q55sD3vTBxOg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EupKB36x;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785182794;
	b=gmvobh/D4f6lYSWs1czn4h00vK+A/OPxSf+M7N0Vg/s1+5lPpCSQWw1RdoKUOXgopkNDUK
	sP4d92iZfdJ1YmW0KCBz1ZX2YzZGV/5S1DOKVjBSvH3mhaUhrOyl6ZBWjqQvcQ/V91XpeR
	guhIu+l0dewrgqwhayJXzNCFSiuraN4=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cbb8b54fcf8so3060843a12.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:06:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785182793; cv=none;
        d=google.com; s=arc-20260327;
        b=OlUQQKSJScJqZnPiGFIu4HexScxXDEO5+2CdtZ4h/Bo4PIykHmyX1EUlfgQHfROWW5
         25mAZPLmyNqevWI23nAMyXNdWuz/YefnMHSgxryNBihvDIp+TtQETfDS7CuBBUZ9q0l1
         KPgmubv6GSyLSkitlruomefnoIB03CRvq6nwgdepysEJVRsnIBRmuUyP+6fbQyjvVoI0
         3k5Bbvwf+tF/8DgVzG13/1aecnG0WMQ15QsTRUgHgDhsQuuxHNtPM2Om6qPgcA5WJp/G
         aeXfgrVpsLVnmcWmW0hvHcsLZKAYhPzpwK3eFvMBhugNmDTc7qZV/x9dMkdRT9H0wi91
         qg+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WT3D5aoPs392vdVyfO0XAxS3rqs8yFAgGjz3WyPghwM=;
        fh=bnpL/BDWZJX5naOamFcDkeWdwOBvz4lefKLAIE5uOJc=;
        b=IqHATnW16I7S9OPzOp9My0pwcQFm0+Lsd7xJ/ORZQBGskMDWfEO5TrzAFwfu9MZI/C
         JbQ7v1qR9br0lIIJIicHp6ekhhBdMj1uWY/URotPcT5v8WcYWv5/dqpV9pJnXxqft5CG
         H3JEFycEmkdS5EtGJLvPaeCulTEhtlQHloyIsyeL69q32T267HSdM19Lo2a/dY7H5tyB
         1fWn8n5V9iCR3fIuddFwvsYu6zCaEBw9okTM+n881Lkm4vqEttvNf2abtW+4X5cMLmuU
         xnQiss20sOZ6tpkJe8z6osa6xSizMmpGwOYkzAtA64H/0XYPBfmUTKIna9DTIP7HRILn
         Fwtw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785182793; x=1785787593; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WT3D5aoPs392vdVyfO0XAxS3rqs8yFAgGjz3WyPghwM=;
        b=EupKB36xaptIgwuIgqb4+eWQfjnypC5zZ5hgFwkojlxFFISRAOCb+uNQ8tCVj2R5j1
         qTboQ8ZyMze7Ean2G3ggg6uEauck7Mj8tzUllzmhcS5wCZLr3LTFojXPGT+Pq315c6rV
         4SLl038QzMkGVQnFJtBKoF+KVRLlj1+g1+eE94baewoWuirsTK5/+N+fGs0OX01RBg+X
         lDLkrVsYaXnhINHtS9LfxBdk4kpvdgZi28VcGmuXxR4BnMzUP01QsPlCSsAwtep81YIJ
         bW1y5slGHHfa6s7GPF0QOtVuIpBp2PJgnWqdcSVWvu6dFr+kXYmMO743hrEvmgLrZuQ4
         NNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785182793; x=1785787593;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WT3D5aoPs392vdVyfO0XAxS3rqs8yFAgGjz3WyPghwM=;
        b=DDySTh91h2aDyAjuCD3Nso+dgp/kLAAWoUuKcoVCgBzJAAmBPckJo5HyifGyV6T1+B
         6iNaEkybHn6S4z3J2vCjnqNRqv7PBB9ZyUL0gApUJTbYenAtxqkJAAfCEpAMZAgV84Ec
         0ObQ2wjQ5o/EQ1/C+U6AvW/TyJbauDTSZBl7Isio7ihqSbm7utEPoeiJ7mCv8+tlFVon
         vzI+O1gZAsqkFOPjFoIv65eQjzBVB69+QsRNrSAXN1KkpuaJA3sioZt6Ghygm3noGL7s
         z+1CAeES1K6HftZRlKib4pD0+MX7cMjffXkaDXCfSjd8euMpxOrnb79Sp+aez8VYeGKy
         /Wdg==
X-Forwarded-Encrypted: i=1; AHgh+Rpl3KThBx3+3WlTKREmPkxSL6yOEQsVKl9BdCkIYqLgYwuU2zEfV864eEhihLZQSV8mIMi2pdMrxw==@kvack.org
X-Gm-Message-State: AOJu0YxrV39OKnw/sd7ePWRTUD+0S3C5OXuf6PTlg4YfdHWXA9TsiDue
	r2Mi/R8LmNBShd8FVmrDFvrndhz/2vGVybkT/7jFy0ViA5FBNBy+WJ1/T4Z4+w2P0mTpanSxlKF
	z7USfZWjDW9TIdXj3XVZYat72qSKru2YM7Jv3561j
X-Gm-Gg: AR+sD10kzpf95aD88c6BGYBFhsNPfgfnpcfjHG97eUPC3S56LnvVpHGAg/YjGQSFgYw
	6r0nR56gjm4mlrbSAZadIq4j/BNQTJLtyddtGn8tyWCOKL/K3mMLG3ZmV+phZB2BzQEjVDhegyL
	njjRw8nWNXQBB9nS6Z97tS7+t7TsYHARQxZeTodiCHlMcWFXUV3CkIiskNroYpCGcQ+RMYGo73c
	PsJ6OiQPQn8rHoxWwM4ysNjdJrb1TDxbnEZFV0RD/eODEN+2HcEe/G/h+6zHQ==
X-Received: by 2002:a05:6300:670d:b0:3b4:5c70:ca3e with SMTP id
 adf61e73a8af0-3c6c7cc8bd0mr999176637.25.1785182792364; Mon, 27 Jul 2026
 13:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <CALzav=cRhFW+zNX6xCnhjJXXDHgyhOxuoX26FG2Ve8+wMccypg@mail.gmail.com>
 <20260727192701.GA1250952@bhelgaas>
In-Reply-To: <20260727192701.GA1250952@bhelgaas>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Jul 2026 13:06:04 -0700
X-Gm-Features: AUfX_mxd_Oq9PiU6WIdCESXtBp_uYjHaNiC_kTE5jOYjh-Uu0garCTxaVZ4f-sk
Message-ID: <CALzav=d1u5fuOgodeGKiFKPhMOx5xrdvgOeNqWfj-C7ZRG-EdQ@mail.gmail.com>
Subject: Re: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the PCI core
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3126B180007
X-Stat-Signature: hoong8noc77xrx38yrpiwxipnwbabobb
X-HE-Tag: 1785182794-588923
X-HE-Meta: U2FsdGVkX1+VmDQFRLC0h9zs/U0u7H77LHG6oWpNIKqWVO+TU1iLzHALtXKtEAvZIautMhVxR8S8y6j7XCxvkMJ15s6/A0mrl4mN78wCOQ5OpoqRobG8AkcbLuO4y0aIi4H9rM8PKqOpfZY2jpFSpLJG8uRMnhSInTtZ+JJGaSqzDlDj8ia+0p/8f4C7byz1jEEQnXzMXmwAD4a6k7IgAfNf3ODmJUQ+eAG3WsJtIW4jVcFUyfOE/binkA/HI37z4LwAoDFYhRJilm3HE6LAvG4qaTSO5cn7ViT3729Xjbx5DU5UOqd4bQ1yp6KPoeQ4t7Yv9l0TEAh5FoWsWN1Ri9K7ieUcnIEeZdZm5TBkuaJE+HedHLxuSPl1z6FmG5rqLd4clD6olICKrQfVGCuvXjFxnFb1Ze9GRg2H2zKTzA/culcpGPPJmZtKf7BJD5ezycObtZ+n1MimDwGzTOSGcr5iExcDrahIJ2WMEP9H6J6Iiw2qrLMP/Jem9UlfXENRVJyb1qZZEVav+SXd8OiovVGda5Wbv7co2bRcKYtD2MhT1EInZG/Zk5JCeMHsYQFgE0SzrIUYeZF0/jvi9bkbfEHU755w/5EuYlDCs9nrapBsFsjzRxvIiki50j+kXgPBzRxW77V4/UkvJry8pyqqtyZCe3KForGL6u3ng1gva5HDmhQKPj71S3FYrvGx9N2PdwPQHd5pWyP/JeGhT/06hCF1fW4hIuY0NZNGbfD4wRS8yQ/jFWs+eZJRSNC6k7ORAB4CcXg02aU52aNWK/ZrkDxO4J3kCCFZNHBmhKP3Ma30tvjN7rbiZc352uaMkTG22Qkc/gdPHZbzPA/76RK5CE5YVlOvGJUprFHiZgO4nChYsA64tv51bq23llT1Y6ZDUnFqBGBD4YlutTrMzcQghNFk2dsdhs0kEnL3RKe+wwf/J3xMhzFRZdkfQu8nYRBD/NvYMhD4s4BixqZZKf5
 93PdDIAX
 EKpwcnZyyZEZmoWaoiodFDCMFgIwW9yE6oaHTgMxPLyRYc//Bt0j+AkspzMhcqDABep81nFVfnDuKl+BP1VyUFWomIlwx9Iy/IefFSU/TcWzHTkW1DB5OkxOwoSYCtVrGo72CNLQ3i2JnEF2N+B43CP48xDp5tBIKILFoV8BzwgJBULRnNjnJVDW2DwK9cPh2KbV7EuExnWbBAPyOm5FXp5uH7VQ8CYJ1GSJqPJqs2QRAUVel8pYHD1VOi6V9DACKhV9UHvJc+UFpUZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 12:27=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org>=
 wrote:
>
> On Mon, Jul 27, 2026 at 10:40:52AM -0700, David Matlack wrote:
> > On Thu, Jul 23, 2026 at 3:21=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.o=
rg> wrote:
> > > On Fri, Jul 10, 2026 at 09:26:04PM +0000, David Matlack wrote:
> > > > Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to ena=
ble
> > > > it to participate in the preservation of PCI devices across Live Up=
date.
> > > > Essentially, this commit enables the PCI core to allocate a struct
> > > > (struct pci_ser) and preserve it across a Live Update whenever at l=
east
> > > > one device is preserved.
> > > > ...
> > >
> > > > +#define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
> > >
> > > Is KBUILD_BASENAME buying us something important here?  Just from
> > > code-reading perspective, it's more work because without some digging
> > > I don't know what it will end up looking like in a dmesg log.
> > >
> > > > +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args=
)
> > > > +{
> > > > +     struct pci_flb_outgoing *outgoing =3D args->obj;
> > > > +
> > > > +     WARN_ON(outgoing->ser->nr_devices);
> > > > +     kho_block_set_destroy(&outgoing->block_set);
> > > > +     kho_unpreserve_free(outgoing->ser);
> > > > +     kfree(outgoing);
> > > > +     pr_debug("Unpreserved struct pci_ser\n");
> > >
> > > If this pr_debug() is useful, maybe it should include an address and
> > > there should be a corresponding pr_debug() on the preserve side so we
> > > could find things in a crashdump?
> > >
> > > > +int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh=
)
> > > > +{
> > > > +     pr_debug("Registering file handler \"%s\"\n", fh->compatible)=
;
> > >
> > > Is fh->compatible enough to identify a driver?
> >
> > Not necessarily. VFIO could theoretically have one file handler that
> > handles all the vfio-pci variant drivers. But I suspect we'll end up
> > with 1 fh per driver in practice.
> >
> > Are you thinking about how we can ensure devices are bound to
> > compatible drivers after Live Update?
>
> No, I don't understand enough to worry about things like that.  I'm
> just wondering if there's enough info in the message to be useful,
> since fh->compatible is the only text that's variable.  Same reason I
> asked about the "Unpreserved struct pci_ser" message above.  E.g., if
> a user reports these messages, will we need more information to debug
> it, or is the message itself enough?

Ah ok. From that perspective, I think this be sufficient to confirm
that VFIO has registered it's file handler for devices bound to
vfio-pci, which is all this log needs to do IMO.

