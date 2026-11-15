Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7D8606A32E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CYbyMtIL
Received: by kanga.kvack.org (Postfix)
	id 7E41F6B05B6; Sun, 15 Nov 2026 01:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB776B05B7; Sun, 15 Nov 2026 01:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F81B6B05B8; Sun, 15 Nov 2026 01:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF786B05B6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:37:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0B24160597
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:37:35 +0000 (UTC)
X-FDA: 85436397270.28.0328CE4
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28FE5C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:37:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CYbyMtIL;
	spf=pass (imf28.hostedemail.com: domain of 3LFP5agkKCBcGxEHAFx4H3BB381.zB985AHK-997Ixz7.BE3@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3LFP5agkKCBcGxEHAFx4H3BB381.zB985AHK-997Ixz7.BE3@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794724654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aE92BuA/q+u7mWs8kchTDkcjs1m/i8lsv1ezZ7OruqU=;
	b=72Adh0/0cZEmMhj8lhYAYHGADzVLH7eMmW0nZFhmdJKVhrSeeQh6fhZgpYZcCXYEQC8VbP
	fw1fOli7PWmpgkkif/fM1em6XP28rzxXup9sS8yDJNIML+WDFimbs3xWOXxGu8BC2Xmgrn
	+mH5N3zEf1yf/mwdqHlxA+Q/axv8GaU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794724654;
	b=DKE9ku0WApnAN2Ihd3Xl0CwLUR3tcheT6v5Ius420uMczUjvH5j5jgOjwvzuacbTr0KgZL
	qnhSDh88mj07PF1Y5zSY4m0ehpAPuoO39A5NMta5EaIofCaV+3HUwaRJt+uSdlNcgi3JOi
	btrrfdgY8l5sUMxxDPyo0FcJPslAaRo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CYbyMtIL;
	spf=pass (imf28.hostedemail.com: domain of 3LFP5agkKCBcGxEHAFx4H3BB381.zB985AHK-997Ixz7.BE3@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3LFP5agkKCBcGxEHAFx4H3BB381.zB985AHK-997Ixz7.BE3@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c49df8fe86eso94532866b.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794724652; x=1795329452; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aE92BuA/q+u7mWs8kchTDkcjs1m/i8lsv1ezZ7OruqU=;
        b=CYbyMtILiY1z6qOyVXqgZxbPNYCvJy44TWRWtGkuZ1XLFJi+ZapgrxFkbfdRrbCxEn
         FxpDWIlbNbuxbfI6qSL3Zq1PgjCC2UNTQuuxWKqoBOlzzAVdJgGOQtXIoe2cvlHJXnqp
         PIeqlwSII07+h7q8qyrxJZeOORWjejQnTkDUoVv6YMhuB1vpEPa1yO4SiEvf6Q62g9IQ
         JB46QPj21tl5Fx99lJD1yoTtGOLlzsIb0LEfGQD/Nvo92NRs/k4mN6m57/E3dwHfvDmB
         4j8O42xL/8S61V6s1ETUmaW+vlwXj8jP/2oAQRhT4BTy6lSz+rEZ6FbulZukn1kEmcK9
         hpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794724652; x=1795329452;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aE92BuA/q+u7mWs8kchTDkcjs1m/i8lsv1ezZ7OruqU=;
        b=oXRAMg6ej9wkb0WEOfTyYUtDqEtUzJBfwhDMU/mouYBEgyS+Lcwf+NpyoSV2AvzvsW
         A60RrL4oVKFSw0XZSCUfBCV2M815geYERyUc1YPezbPY5/7NAnLEOB5Pef9vU5K0Zf+v
         4JnRShjOt+Fyf6xnJRKyGh9jTTEwbfF3hMg1X/kf+Y0H79Ndg1XusB0tH41sOPkZgZAM
         Mh+K2oRtt90WA8Pa7jtCyRDdsee1dZdLapSRiNTwCC+cFMngDY99DziDVgaZGcUO77RG
         KQkcylSaKzXIvRn9bmCnGuhNeQrUfMcKLboNy6g4g58MXhanXMDrRkGMaSjwaRKzvckC
         IDzg==
X-Forwarded-Encrypted: i=1; AL+hErFYw4RzuT+mbJV8c+VEe16yi7sk7TD8Fnn+itsECMpol6R53JjAsEwwWKee1qGoVmR6nNlMuRo/bg==@kvack.org
X-Gm-Message-State: APuU4Z8sWOGmXFJ3K2u1ZCAGXM2KlrG9gYyOwGG+oROKPHaXDQUR20ZT
	irG+u8DJuAM6wTuXQ/wvL4hvHDxn+a6sCJBAVBFufoMK6KuAbSWoCgCQpyzHj/G8O0osO1wAwDo
	Xo5NAkedJNmwjcOlMuQ==
X-Received: from ejbge24.prod.google.com ([2002:a17:907:9098:b0:c46:7bd3:aa06])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:a714:b0:c42:5363:38dc with SMTP id a640c23a62f3a-c509637e20cmr533164966b.25.1794724652053;
 Sat, 14 Nov 2026 22:37:32 -0800 (PST)
Date: Sun, 15 Nov 2026 06:37:31 +0000
In-Reply-To: <DMROZB8DPEWD.W2BFC7JIBVZP@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-3-tarunsahu@google.com>
 <DMROZB8DPEWD.W2BFC7JIBVZP@google.com>
Message-ID: <9huzjymepplg.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block header
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: dtcd4kdfoshjnjmrdn6j7erisbhnj7xq
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 28FE5C0004
X-Rspam-User: 
X-HE-Tag: 1794724654-861759
X-HE-Meta: U2FsdGVkX19dAO9p5LxB+R2ogcVh4Xhh1JmItSe0hFJVASlLb/PgzadXfD5JUpGv659LqMHwWsdCbHkNw3ni+b4jfH+inoRTTxYJHSXvsiHFCVMbYgGteUD356J0f4vLfKfZ2NlCuY/kh4vgnAZDFcCANHDmLJab5UCpmGJt7vJ2ACi1gl4AXGo+xtH/E+SwSLyGN73NZ/Mb8Bhl2BGDw/tLjz1/8QvHTxhYOx2UUmmVKWg2ujOeLjxmCI5knAnzpVTc35vNtvFO/12IJ+df6HJQ0UMx2CaYRLYlwPKIt8ZU7kRHuZSmCAdQF9aP99un4mcSrlABAEurC5c+9oM0kF0b/97uyva2xKXdREOo2hu9xh9p+a5mDnfCedxpgZvTJt40cF7rFoK035aw6RGlshDfp2tP4oscKzwhlwQHXgNMZOMSXJ+6/1Hq5YDY8iJo/AmDN7zrYByIUkdSKaGbKY+sj97ZzRzfjWvpRVp5k8pD9Q4SyvJlwPoT5A4c5DDdSKcVXNGRuiQ4Z7RZJil0ih1jpgC1FtFsEMZQ1xAjYFa6O0l8MSXFIiOkmPdS/C1EqgWe5g4vdrJzD4pHxXOhwJdvaNJOQofrZo68gh1GutF1CjZOY8epSm78Vt5MHmioXs3F+bUSBjHvd1CLLnVXAJeQV+1fH/yis1EgtDOxeXQYqPGSa7XWONmDq6QPmgAE9pTf5YUZ0wsO7yYoiABe0Oktaug6Er9jbPKsoluLonu2/02QjcUIpRhfxpLTCLBfwqqnYDqLa/gYZZ41pCHOhSGFl5ZUvsyHZSjgfsOAhwLiiXIZ3aHjcFWMdOV/HqOXYKO/IFwfecOMU2HcwxonqglJLUsvpWEbr0i7DuGcmAHGdhGmJgAYn1fJl5rGhMrVUywJ3jan6XB3OckI/vdqH2jnby6ph30FQmqD0L9ckVRBvb0xYubB1S/3VAFJzrqOtlzodaTapuOUpLuN4aQ
 9gJXlrJs
 e08RLNilzJh+a1DoL8ltWdGB+a9lMs6r/f6VhXeytZDjfe59Gws/DiU7H5nrffRtXJvQRG8zd+5Qc6Hnr7P8tFShzCjsPad5OnfGzy5eSaf9EKr09wSmMXPDFRzRqTKkKoqZyKiZEmpg//KmsJXOM+2Kjbab4EuG1vLBTBJMIIuPQATMteviYvH+uYXg+5qn2G/yt1xo+5f1fMmSbRcwXaiuhuIjMqvE5tZz4oCRLaPOWQAOCiJYIlJRpPH0nzTR7UYOErSY3ZP6R4GiLYvW89srzOxU9x3Hy1w7eQdSuXgsRXBiHlMS1vmzd7shljNPk/9thVQvZOxfcraBseQTAja1b46ZJmgB4Plgvs0P9qbionTexr8GV+6FQqdoy5EotuBFs3026j/H8lnET1pxuHRkzDFt0dZiWGnHDDjANDcpxaoghi19xp/4N4IgLHDQPbl8Ef56d23vmqioiPCCTcL+mfx5/dvzPGI1XFdFzeku14wOKEkKcnZllsCq5Ko6a+4f81oUzxFrmY0LstgihOnjTg9J/768alKElG9Hhz3b7YiGuFWx3hXfZKY50YxRsRqxMJHQRMyDdqVVvWA7cd4LLdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Matlack" <dmatlack@google.com> writes:

> On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
>> Add an entry_size field to struct kho_block_header_ser. On the outgoing
>> side, record bs->entry_size into every block header during allocation.
>> During restoration, derive the entry stride directly from the block
>> header instead of relying on caller-supplied dimensions. The
>> kho_block_set_init() interface remains unchanged. A zero entry size,
>
> Since the entry size now comes from the block headers, incoming block
> sets should not take an entry size at all. I pointed this out on the
> PCI patch (16/19) as well. As is, every incoming path still calls
> kho_block_set_init() with this kernel's (outgoing) entry size, which
> kho_block_set_restore() then silently overwrites. That makes the
> callers (e.g. pci_flb_retrieve() and the LUO session/file restore
> paths) read as if they iterate incoming entries with the outgoing entry
> size. kho_block_set_restore() should initialize the block set itself
> from the incoming block headers, and the incoming paths should drop the
> kho_block_set_init() call.
>
I agree, responded to the PCI 16/19 patch.

> Please also add an accessor for the entry size, e.g.
> kho_block_set_entry_size(). Users of the block set need it to check that
> incoming entries are large enough for the fields they read, and that
> the fields of a feature are within the entry.

Sure, Will update it.

> [...]
>
>> + * Each block header also records the size of its entries. A newer kernel may
>> + * append fields to an entry, so the kernel that writes a block and the kernel
>> + * that reads it can use different entry sizes. The reader steps through the
>> + * entries with the recorded size, so every entry is found, and it does not read
>> + * beyond the recorded size of an entry.
>
> KHO blocks can't guarantee the last part. The iterator returns a void *
> that the caller casts to its own struct, so it is up to the caller to
> not read fields beyond the entry size. Please document that callers must
> check the entry size before accessing fields that may not be present.

Yes, I meant the same thing. by having a check on entry_size reader must
prevent itself to read beyong the provded entry_size. I update the
correct the documentation.

Also, I realize tha, after checking the base fields using offsetofend,
for any following new feature fields, a entry_size should also be
compared against the readers offsetofend till this feature field for
required fields. Incase reader does not have that field and
kho_ser_validate passes, that means that field certainly is optional.

I can add this also part of the documentation.

~Tarun

