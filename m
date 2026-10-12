Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3C0CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5196B0088; Mon, 12 Oct 2026 11:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385DE6B008A; Mon, 12 Oct 2026 11:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275766B008C; Mon, 12 Oct 2026 11:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3D9D6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:48:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73DF41610C5
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:48:56 +0000 (UTC)
X-FDA: 85314407472.30.615E6D8
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92C5D18000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:48:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LtYFx8Hd;
	spf=pass (imf16.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791820134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bz+XxQbQvV9Rkz3jiplflbfyEnwSo6hWkWyEVkUNcs8=;
	b=5yDI/JeDcZRv9BBs5pLijLpnaqhTIExCTiFtZJi0MB5wExlPILrET2mprk6W+1HSQaZHaW
	Dyyhj07gLmhiWytEPCrBbrr45PhJVBi6sSJv250BhxIDZqchv49zAuWlknADYQrhdA6zGn
	0MAPjiJbeZRsq6mG05AqFhGU2fIqMWo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LtYFx8Hd;
	spf=pass (imf16.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791820134;
	b=kDp2JO6YC9d0oH/Yazr+F7Q61kF2mT/PzCAbGwmcDHRJnZpJzCBlztT6MlOw9bvy/rimhw
	SJ1zMCXUDl4pSw9cw1tRE/CNNVJZ3pYmzYThsF5P7uRCQKpHS2GSZVbVaitGSUGxJ/L+CF
	pOJ5DBK4JZvRSofnYi4uHLD92v7+yh0=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a17baef589so16559195e9.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791820133; x=1792424933; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bz+XxQbQvV9Rkz3jiplflbfyEnwSo6hWkWyEVkUNcs8=;
        b=LtYFx8HdQ2REYW4nPO8u5qBv0LVqOVGh0HP+tuP3lBZXmRIhIFIO/qLchoPjeH8okk
         32UrWa2FhvWEfxDgp3V6rIBkKMKP3MidmI/I3JaHLpNzbXZWxPJwsrBCz8F209wuI6dA
         TvQP9rBdbADIgR812biqsWEEMaitdoobgB2FY1YktMI3+MTD+ynmkm8aRGOLxTaaAO5u
         YF4Wz7eP4bc0Cxdsh/Xvmi+36A9t6Jyx3V/cLPIRbiaHQgb3VleSMHSAEz4XMFQhR7GE
         Nh9FUx56LjwDQEo/d8pohYZelT2fPcKAOsl2+dyl10vPE6uYr6bLa9FQbLfwSS/Ke69H
         xO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791820133; x=1792424933;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bz+XxQbQvV9Rkz3jiplflbfyEnwSo6hWkWyEVkUNcs8=;
        b=bu8jemwnA8EdatcAqSudGYTOBfkd4RuNmLWxSf0yorChA99amCvedoY/ueO9RLffbj
         FvCIopWOyuGarh2ALChgaYL1IkiBUaJlVRhec/p5r3rWzRo5tz3RZBx9+RswLVw7Ue4c
         sPHRvZY6SNxVXdKxWhPKfaD1mi7vqqo3BAOrbwuxO5s9l/6bJR4+rXek96DlpsZmcKRW
         uLuNB6jey7vJnruWXe3YTE0jHz95sR7USI9OyHnbTaCeUfJA7S0xDMSX3/UZt6jBDdrj
         6YLaRdVr/fa1EWhCq14FK1vtN9P/A1sSPc7lGHfBmPK6LAPnFL0pVmbQkU7OODGol0Vn
         k3tg==
X-Forwarded-Encrypted: i=1; AKwUvBz9vR/t9tPauNsl88FN/8rL59PHleYWa/u//TfH9rZhm7mHuVNfKG16MXloq92Wbja80qd3zfLstw==@kvack.org
X-Gm-Message-State: AFq9FYKXvUaoyUHapalphSbzznHwn3XxWy+lkGgUNEadJLtIcfy/qOni
	wUFIqnZaAVZyqx5X4TU79AiY1wUHtuPFHfx9AYxk6MBqsM+dH5fcGrRw
X-Gm-Gg: AYBFou3gn+jvDn60pThgaQV7vFXEDrf5BKV8yp4oSb2m+aDdE+Kz+uXwl5Y1rSO2J0X
	yqyl/rbKeJGpOPXdl+L/TMx2Co65B2jJzmLxsrB9caZ96M2obyP/udk1LH31HYPut8+xHGlGdnQ
	EovaQ3WQ5tBK404fAK7IYuMqLYnVddGTJASiBtW2BCxARV9TM5C93IljbbDvGoiV7BnSBhUrgjs
	+7wl4xjALYwEr7RGf1MocGJrG/tKYIb9vcKxt7Q628biIZ4u4qpnOzWeOVqUalDC2Y7Nek2Og5+
	r1XToND8aSm7Tsy5QKZtyTGCXzufiJvDeDAiT+9HUbFo5J04VU8egQPycKUB4GX4J/3rN1mlR3g
	cFtXMIOPGxOd2rRLvo9uKhKTi6Bw+oM9EPZjHlGrNFxtBuOwapyBEOlEuMtzehUCyvlebxGLIFv
	0r741f+x9xWI0Y7WhCqaejFoD0V+DYGpTPUHQ1UwRC3jjSqrqxSaNG4+uZivUlgxbgsJ9z+OHDh
	guXexjoZ/oFasZbbktMCofukl0KF4IcBQCHaSQ+iRU5XCDz+vn07d08x537pIJHSHmSJ8XFgg/L
	Q51f4nxJjfANKuRATt3AJAsaOzBcUglgJzo=
X-Received: by 2002:a05:600c:699b:b0:4a0:4a8:d444 with SMTP id 5b1f17b1804b1-4a18e4af334mr195124235e9.33.1791820132890;
        Mon, 12 Oct 2026 08:48:52 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a193f2c992sm210228205e9.5.2026.10.12.08.48.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 08:48:52 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
Date: Mon, 12 Oct 2026 15:48:50 +0000
Message-ID: <20261012154850.96716-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <0ae3d92ef99c264cfd76d3c1ddef357e96c98d93.camel@infradead.org>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com> <yq5ald8680t2.fsf@kernel.org> <20261012095800.50250-1-griffoul@gmail.com> <CAEvNRgF1hMz+4ivH6WhsEOLTJGOegYO9AYK6OByYysPp_nVJ=g@mail.gmail.com> <20261012150715.25132-1-griffoul@gmail.com> <0ae3d92ef99c264cfd76d3c1ddef357e96c98d93.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 92C5D18000A
X-Rspam-User: 
X-Stat-Signature: ibmkjiwmrn4cbge4r4qkq7y9mwdq4gyt
X-HE-Tag: 1791820134-28715
X-HE-Meta: U2FsdGVkX18Ag6Et2AQYAp4AUCSr/HsMb/c1YyqkT298ueXuEn3MhRZixEYg/W6WdzkG8n8MEalO1XTmvLYdzyHE5k2gS9w+B3yGHXk+XawpbvE6XJZ658aSMfIaTP8CZQkVYXx1Yl9ohjHU7mOs6Lz8tzCbi8Fb4SVD2AGup+Ratz/wj0UnmgqajozDsHS626tqkpIUwqKtRe8/hz3S9GR3Oo00Rumde0h8hIhf1EcVN4eOYp1kdXQzwlz4cvfkshr1SXHWLtlD2QjgWaJsFe5pi2tKXxXrJQ5kTsqT1WCi09AaN/80y3Yl314DtyGkxAgjPjU0Otmnle3UBfd77eHW8gmTIld+oyefALElLSJ2CFvS1nsmX7jXB+ERsZj4NHqy2NyVuV2aETV5mQaSS6LwnwjxJoEeZv5BEXh+tSKRRWbh/7+xAS78esRzobM4wydNT3XR4eCbFF//rcfMNcEfm26l942t+FuOzmcjTKMXxPpv+7yp4grwsEQm1SvBkdq7dIz+CSXGdTv5cQFB5xXtEDSP+jQVmvawAE78Mi/5P2Y5E6VUEiVmhdl14xU1iZ+iVId7bDbBuf7X1kXakzP46CEOCtHAFmyEdPsHDcaCNZxc7U1TgcTCEl20n+2oTjldSlCnZMij7/6x1RAo32NYco37OItfyyJulwQ0zRHFdgEvA51UzncRjas6UIYDoguxeNwFrRBf6YQum5oEop+cgX/fxNUqQKdX/wMS/DOWzV8n4HEEivzmk9OMfWaHGsgsicOgHi+5IcW3Xbb9rt/pHgoDXaHHkgWdKs+bO8DbdxDPRx7BM65lT26ExEpWXDOIAu7zv8+K/xun7/Dm4Vv5h00z+b7i5ya8bon+PpVntTXGm5MyWtbB46A2y2SoNDMMytontEuSad29xSxLpwJ9r+mOqK/XkHQenattO89GD6G0L6m8Jf3nc5AS/tY6h8CfuC1PEudrSvLLM8k
 LsoAN8C6
 DBvqiqT0YvmyO6b1FcO/iCxxIc8ZDIUxAIF0fC9zoZPt9BdfJy7a0sfdL0R9I9pLQ7qvcOSA1K3KpBN/rbDPFbg6MccxYn5BfCbIoCIl0egJotdIwxPl1O2l6CG73uC0oXHjc2x76vyVSRAGmdJEhbDV4d+PYhK/KB/jWgWkHWx0xVTCEyYt7U5M8E6JgacXbGTk0vPypaU6kahXLIrKcCA5qZfSEO2v8KcgoX75NNeRT2R6J4CZ9x0SxVg2oocxTdEAhGmae32ww9aZh+T4CpaOtm8q7Hc3lq0aUsNQHeOCp+jjVXt28IePHu1n1x7g+q+fc45HryvaTNI284wwY+PErPGV66i0echoZwVke6+c2P8I+1g9LbvTeawcYltcuSHwcprPPxSjUUeuolIwpZedViGlktjzyqBqPlUPSPc7W5qev9WxzkED1YMRpUFXXaVo9G+H9JdLEyPu2Z0tG3hSIRjbuYGffbg0iecMzO0qr3KoVUJ6LqtStLo68ynMVVFn16i96cRo9G7uqcBdVOQO7lGDe9WGgWoTY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-10-12 at 16:13 +0100, David Woodhouse wrote:
> On Mon, 2026-10-12 at 15:07 +0000, Fred Griffoul wrote:
> >  Devices are different, because a device may not support
> > faults. So the provider also revokes the range on the target once it
> > owns the frames, and iommufd maps them right away. In other words, a
> > revoke means that the frames behind a range changed, whether they went
> > away or arrived.
>
> That would map to the IOMMUFD 'REPLACE' operation that hitlessly
> replaces a PTE, but does anyone actually need that?

No, not on the target. Before the move the child has nothing mapped
in that range, so when the frames arrive iommufd just maps them. That
is a plain map, not a REPLACE.

> As I said, assume that the "crappy devices can't take faults and need a
> scratch patch" issue is dealt with *elsewhere* and not relevant to the
> guest_memfd/memprovider work. That's purely a quirk on a given IOAS
> within iommufd.

Agreed. The replace is only needed on the source, where the frames go
away and a device that cannot fault must see the scratch page instead.
With that quirk on the IOAS, iommufd does it, and the provider does not
need to know about it.

Thanks,
Fred

