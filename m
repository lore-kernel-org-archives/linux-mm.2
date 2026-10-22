Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F20A606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Wxn3VCi1
Received: by kanga.kvack.org (Postfix)
	id 5F6496B0295; Wed, 21 Oct 2026 23:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8086B0298; Wed, 21 Oct 2026 23:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4967A6B029B; Wed, 21 Oct 2026 23:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4376B0295
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:51:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A2C5120747
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:51:29 +0000 (UTC)
X-FDA: 85348887498.25.18D4A6C
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1D3B0180003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:51:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wxn3VCi1;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792641087;
	b=L/xyPNuDQi4xLjkyb3jB/XIF9IgWWh4zcLE7ApBrOEv0TZq0PqtdoXj/TFPvWCPBf2GcxU
	+6wWe4DDhlZoscERP7f25WZPoy9MV8cxuZ/ZjUWcAQ1Xb2I1p2QK/WPnRp/Z9lthkB7oje
	2JfX0GZspaz4pyTGBt3b5BtdR/BmvvU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wxn3VCi1;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792641087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3R15WlwvcCDjwHgI3tMxUhnF1Vz0ctYaUW1v5Utzjsw=;
	b=JSN4gWkqY9uswhGXMNsnhDd4F0VyzxRnuPD6x7PJXcF9+D6+x9F0/eacGz5H+GDmSMD37y
	k64+MQdCKj7LxCxmiqrTk4ZTshTKPBSvrJL4V/FTXWxgM0m3JkTGzYgrqARFWFPc5uo2Pd
	AppWxL906pNMmPSY1+fG4xS2ucfgdMk=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so1960038a12.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:51:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792641086; cv=none;
        d=google.com; s=arc-20260327;
        b=jmAXtrIBCuLxAlIHBiQCf2upwRb1qQVon8HyPYXHgW0Mvp2Q+lnf687B3C1NC6obwz
         XtTfjFIg1764QBXgxp5a/u93LHeeAnxhWWLLLlnLk3BncU20+oFxuFrN77yFcaOA8Tj3
         NGeTmecByxQgOLJAu2WqyXMIZBtjIlrGWJlsyWoWlkPz7HNxrhEKozlUW+mjcbLik7oU
         6YY4AuvFXuyFx67u1mnDH0ALpFNYJz0f/dJpfvuUKFCQqsjEd9rmAnhe1RNmTIEBSFD+
         ZVeAygRkwZ9PUqkp15LRswLlWeKQlA4GUUJk+622Zr3OciqsfrSSztpcRRmTAMAM+KHZ
         0Ndg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3R15WlwvcCDjwHgI3tMxUhnF1Vz0ctYaUW1v5Utzjsw=;
        fh=5EK/5x8lCOoJTp0Xag6cnT/BB/GqzED+rwyh2f57mBI=;
        b=o+BQSUt6YCUbJX7/3nKQOyCaV3Nttc6/ENLYw/1fkjz4oRj/JflFgl/RyKN4WoaMo1
         hryY/32xIIglHhJutR55EAMmW8wFtwroiXAyOIET5objUXD+ZBfNHIw862QUVozjaeSh
         nOyBCESqY/fxyBozXE9TF0Q4yPwanvNss320oy6JYLyXKp+rkVxx99vZcGLBX568EQia
         Kke8cM+RSvP1JIl3UXB5N2mlN5JzcAzKKqJ0xmBw/Ae9ZlMYijEWTmOgScGBP7xBRBE8
         RjkntQiRdzhrTL3sXmzJv7K64Rag5Wq6aEH+lR7k4AY0nme0qQ8efcTLcEyz1H8Q2WwD
         4jPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792641086; x=1793245886; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3R15WlwvcCDjwHgI3tMxUhnF1Vz0ctYaUW1v5Utzjsw=;
        b=Wxn3VCi1zdBcT9HGXit4cfdKRezzIShfJElkGUrFcBPeo2uLdIvpAgJb5BM7loMzKk
         Lr3LmiseSb6D3hmVyuulHLGIxLekQlgvGqJDpBHLWphGNkKKfasiOvplWadYlqg2UcKb
         EgZunnTDsu0+TJTRHGXQzNX4OxEqKZ01w3v8tv9E3VqbY6zAI9vnSZaV9WIOXAShH0dz
         aRHJHMUlIqUdpvjvVzhB8SPnv9XPcVA03iOgHZKy5GXoIvFpC3mEvoQ4EYB1gHK4vcwy
         3+f6UEPW8mIibLrnZPuWXA9/3avkvZzxcd9eT/lM5dlg1L3UF6D+PYwfwjiENMQt7NHF
         Lq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641086; x=1793245886;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3R15WlwvcCDjwHgI3tMxUhnF1Vz0ctYaUW1v5Utzjsw=;
        b=iBoU1TEqXlI8hQoE4KPiWTlzMYs/ymF8QMfwUaIDhvYQqSrYXL1hQDjXufeFq+D8lh
         OhIZrVDrRy0uBz3lsl3cRsE2BoX6/hCTzHcs+cG7mLr8h9HHRHUfyeSLW86qMXv1Q5G5
         3pAtjJy20m/5vKs7IyAqS075XauNm0nmMtWC4hevMKID2LbMVxJdsRlIjroNt7gYwvqd
         gtfDr6Lgr+gBru/BTWBlvmSKVZcyJ+NGDKARvGAkRJZXTD36vm4EDHdjjavH5j8ua/H9
         GlFJwnywNrYZWFuBhudUxCnWpLyol5ry8I6TefNlHl6XcotSWP4bAHFyeP6ieXktzrHA
         JctA==
X-Forwarded-Encrypted: i=1; AKwUvBwy6zNv3NWC8Tu0012C753r68zVMvz31eGK6IBfJ3fjBBbsasfh4KpcG1lyPBK3hGLK3JOlrxmtEQ==@kvack.org
X-Gm-Message-State: AFq9FYI5quPNH69dZg6kJYD8WJ/FTj7n5Y4z5VUfJsCuHpbZF+fUJSDC
	dsx4tRwZdONbEbMF7Yau4Es3wUYtbFz+5V0hJEoVPh8uMhqtPm5MH4cwCltrm4GmXsXSPpkRgUR
	3JUU0A95E3eA7fC2/Si1W5mlISaNKZEHyhFes/sox8g==
X-Gm-Gg: AYBFou0NJxCSWD/eLyzOCl0rhhbIkPld18bzmq72B+StraIgrtQXFOAUx2N2JaeMQL4
	TzZd1OKghmXMcaDwaErFpYr54PayiCHsVhMfapOOw5OozAPGXCvRH2vJ3/PMHcrzAmxxNnw8gwj
	kVN3ZJxJ6kkVYjZpCV4sISwhg6vRU8WpwK0g0Xsck6a9aUnjwxkhEZNOctOHoJ89tGwmiumX54J
	w6ewIWtuYs7Ar9hLa4V6YUjXqzR9G8o8Im3FogZ5vDU7rf9vaLyn/AHW7S/TISOYPiOVQxCqM7w
	n+PMgCJRyKlbxdB4sygbz71Btu0ic2verhf+49+9F4zGYGSWuM4a3GzutEFhzuud3wTDwnSvQBs
	zBmo+9KFUta7uxH9v5zXNs+N/tSc8R907C8l/431bu8xHbmx3HaNFSoSAVrFQGX1pjm4=
X-Received: by 2002:a05:6402:400b:b0:6b4:2185:7147 with SMTP id
 4fb4d7f45d1cf-6b4218572dbmr568868a12.15.1792641085570; Wed, 21 Oct 2026
 20:51:25 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-5-tarunsahu@google.com>
 <CA+CK2bCWo7ixrNLKPvqETn3JSFwSNaB2UsPgy9RHVAhWroJURQ@mail.gmail.com>
 <atlINfvlXY4wMbpO@google.com> <CA+CK2bDf-pKbH2J13mRYRT7Ddj-Q+VXaGYePs+E-azSWXKzV5w@mail.gmail.com>
 <atl6K2Juy6Bh29lh@google.com>
In-Reply-To: <atl6K2Juy6Bh29lh@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 23:50:49 -0400
X-Gm-Features: AclHuK9es7KH6zjO9m5YDGIDDY6Onq6kZ5W4q1tuNZUyMat9PK3sQU18xuWoZac
Message-ID: <CA+CK2bB9xoAWP0kC+KtXeDTdwt0kWqb-PLHN=6DsA=mnRpMfxA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
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
X-Stat-Signature: c4js35ya48x9r7f5on7r9356x6tcaqkj
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D3B0180003
X-Rspam-User: 
X-HE-Tag: 1792641086-122633
X-HE-Meta: U2FsdGVkX1++nZfcCEwmWNxv0f0LmFrkayfd5lE+ofh+xjaAkXqEPnzPy8EeVdLHgzzUqLDdF16v17orUwCBbtT+TZQMdsae/V90tESWeTI5pMeC78ZRZhAM1G4upIPINvqrY3MRaSPJewxrdvYfS7gYCXd6imzy49OwiBWc6p8Or9uihP2nS9axJfFydcJby8yKP4Hu4f7He97KE+FC2p9AxZa65wzi331LAp5++I7NmU19WrxkiufzUfDwp+GWE9jGur3Eu8O5irt096svLpTayT9ff5Hyk7q3dJEHk0Ldvf1b3b6/FfMsr6+NYs0WMcQR4j27cyQeBg+g88zMikpHpIkt+IFjhIVfdpiwOv2Z7bET2IIiacVtKPiLtLspwMBrJKBQxuYQQDE6Q4OX9ig/JWZOgR6gZzs/Gedg5q6MP1Tb9AOM1sjAxwQjCz/JMIOtg89CYmvbB1nyGViGTmI3HTYlM/wrQIkHCUSjPxR9q9rnkLac8zscTnsNa/bd5gCKN1240uA8VR0jR1ffe1XtZOout/0nvcdLl5LyaGzMelyB4VY5VpmzwV0tKzfI192Fam+e8g6Y99DoFO9UyAF4D02bRHgov14s6M2Uv1+ptAOklBX0nk5Lv2Hp4WSgakkwmVqSnlsP8sKRaDtMap8dBU1Oq2FbO5HLUgUrKxoigk0Milgfsh8WiYzfBelP9+0cvyj6rkGCHxvzpYU4MBmmIKHqVREZLh76/hZWvLqOouqxwCpUpqWxrVhqrtcfZ7G/B2BukJNZule56yhmRTygUtipQjJRjOE2v+/Nb3+CB9a6GWBlwRAw8eZO5V0gHydmaeRy+10IbcCnyF0WWx+8waOe/f+0EPdqPdYRPytw0GkPKFHP8noX6sPHtklVmsro3nbGitRy/Dvcr/qNo/G++VUoYQN987K/6N1Zi4ICQTIIdIZNXGC8F8DPKtIkHXycU4TB27mbnFVDn1g
 6gsJlML5
 UKWZDTukM5azzMD1Fxt7ZnjrK2xoSp68cPe10o4hhSjdicUHOCZW8B6DnxvDUutE+8l6yQrCGMzjqMjH7rkuBskihm9kEwu1rkji9t6P/qSZgne0vQnXPTrAt/zee/es0yvfi4K2N1LVv9sIzP9/ZPmk6rewxl8n+FjYtQMPvh/TDC/xqP5Mg4H1wZ/nTbNiC/7KCtxgBBz1Jign/QL5+5LP1Dx4ykwOAtKlZ4DwRKAMUnFFHZ9oC+aIFRJldydxAVzjuBJ/8MrPCiqsYr3aZtnvXKR/zFc5HwtmYgGM8Cw1oWaYSnxRLuC8IzTNrQHccN/A5kRTfVMnQVcQAbjWB8OmHrDs9qoNxKgp7GpDDqan6VleNqSCT/Lof3w/ON9DezB7W7rJFfi67344=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:51=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2026-10-21 08:41 PM, Pasha Tatashin wrote:
> > > > >  /**
> > > > >   * struct memfd_luo_ser - Main serialization structure for a mem=
fd.
> > > > > + * @features:  ABI feature and size header for memfd_luo_ser.
> > > > >   * @pos:       The file's current position (f_pos).
> > > > >   * @size:      The total size of the file in bytes (i_size).
> > > > >   * @seals:     The seals present on the memfd. The seals are uAB=
I so it is safe
> > > > > @@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
> > > > >   *             struct memfd_luo_folio_ser.
> > > > >   */
> > > > >  struct memfd_luo_ser {
> > > > > +       struct luo_feature_hdr features;
> > > >
> > > > I have not looked into this yet, but I would prefer to use some kin=
d
> > > > of macro constructor for serialized structs. That way, they will
> > > > automatically include the header, making it easier to search the co=
de
> > > > for what is actually preserved versus what exists only in this kern=
el.
> > >
> > > If you want to know what is preserved don't you just look at
> > > include/linux/kho/abi?
> >
> > Yes, and having it initialized and declared in the code correctly with
> > proper macros and verified just gives the right handling and avoids
> > making silly mistakes. The second reason is so we never forget to
> > include the header, and to make it expandable and easy for everyone to
> > use. I think this kind of constructor is just useful overall. Are
> > there any reasons why we wouldn't want to use it?
> >
> > > > So, I think something like this:
> > > > /* Base serialization header: 4 bytes total size, 4 bytes flags */
> > > > struct luo_ser_hdr {
> > > >     __u32 total_size;
> > >
> > > Why do we need the size? I'm not really opposed to it I just don't
> > > understand what problem it solves.
> > [...]
> > > The luo_ser_hdr is needed for top-level file handler and FLB ser
> > > structs. Those structs are always dynamically allocated and preserved
> > > with KHO.
> >
> > The top level is not enough. I think it is needed for every single
> > serialized struct in kho/abi - the blocks, the FLBs, etc. They all
> > must
> > be expandable in case we need to allow that. Let's have future
> > protection for everything that gets preserved.
> >
> > For example, take a look at vCPU preservation:
> > https://lore.kernel.org/all/20260920193650.3373435-9-pasha.tatashin@sol=
een.com
> > https://lore.kernel.org/all/20260920193650.3373435-11-pasha.tatashin@so=
leen.com
> >
> > +struct kvm_vcpu_ser {
> > +    u32 vcpu_id;
> > +    u32 flags;
> > +    u64 vm_token;
> > +    DECLARE_KHOSER_PTR(arch_state, struct kvm_vcpu_arch_ser *);
> > +};
> >
> > We might want to add fields to the arch-independent part, and we also
> > absolutely must keep the arch-dependent parts expandable. Therefore,
> > the header needs to stay small and flexible enough to grow as needed.
>
> Hm, anything that is dynamically allocated can have it, but anything
> that it is embedded directly or in an array cannot, because those
> structs cannot grow anyway. So I agree it's not exclusive to the
> top-level FLB and FH structs. But I would push back on any a mandate
> that _every_ struct in include/linux/kho/abi needs it.

OK, we should *aspire* to convert as many serialized structs as
possible to the versioned format by default, and require a very strong
justification for any exceptions (such as tightly packed arrays or
block set entries). Even in those cases, we should be certain that
omitting
the header saves meaningful memory and that we are not shooting
ourselves in the foot if we later decide to replace those container
primitives or need to evolve the entries independently.

Right now, shared serialized primitives like kho_vmalloc and
kho_block_header_ser do not have proper versioning at all, and because
they are used by many clients, updating them is already problematic.
We can't simply rely on top-level FH flags to version everything:
since these primitives are shared across handlers, any change to them
would otherwise require updating every FH that uses them.

BTW, since these primitives live in KHO and all the ABI headers are in
include/linux/kho/abi/, perhaps this header format, versioning, and
the declaration macros should be part of KHO rather than LUO (e.g.,
struct kho_ser_hdr and DECLARE_KHO_SER)? Then LUO would just focus
exporting FD preservation-capabilities to userspace, as it deals only
with FDs, not internal representation. There should also be a global
switch that shows the KHO version the kernel is using, perhaps via
sysfs.

