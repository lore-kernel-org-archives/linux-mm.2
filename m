Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF249C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 23:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F466B007B; Mon, 10 Aug 2026 19:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F02A6B008A; Mon, 10 Aug 2026 19:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705D16B008C; Mon, 10 Aug 2026 19:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F64C6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:23:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8AD3C02B6
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:23:15 +0000 (UTC)
X-FDA: 85086937950.23.80AE1E8
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0AC3E8000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:23:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gRGRoa9+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3YF16agYKCF8PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3YF16agYKCF8PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786404194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpMqKDZdeqkAxP+HMbo4Vf8RyrsMvHYCAM3HPa8Xz3s=;
	b=w6OTHc+8vrxAHewrXkNKUCMm8X7xNyQA0ORJQzV3e6F7rMW4cfLFQ0uafO3G6vyGgo4dbp
	BcYlVlv0vrHtP+fcqkKKw0GCguPDFJYTb8z6ZbbyC7IjQuymS88fPIVta8SOz2Ij1ICRaE
	6ZVMD22QmD7aZVb2xPslqxgklbi0Dn8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gRGRoa9+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3YF16agYKCF8PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3YF16agYKCF8PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786404194;
	b=tkIbw/eG8wZE2hI+V9lv3sPYoVY6IKTg83EggdQAXepI1PYtUnrk0ATQeVGMs0XIAHCO7w
	QUtdFjucp7kOcYG5Av4hFePKxfVKE0MPW81itY55jj+D4VLNjQ8qr5HGgTK+wEHj+qoA1X
	ypQmHQkT4hzy0SZG9Iex17AYmCVN44A=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso3261165ad.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786404193; x=1787008993; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FpMqKDZdeqkAxP+HMbo4Vf8RyrsMvHYCAM3HPa8Xz3s=;
        b=gRGRoa9++SgN3LhznLUW4kyrYh4Byg4HFlqWx40o/BYN7PG00Zxs/TuZBKsDrt5vNH
         J4SSApqCizDMj9kJIovdNGtDbPvM3vxum2cVSOHYn/C48Ysaj6iz5a76ffczJ6aGn5mu
         0OCvGNukPHIg85p0i35gTzcKoLQhAFulfs7DTlfRPKayi+XJXclsqIU6lflWsNrLMImZ
         aFRcq0Nsm3rzOIjx+RaXJa76n1SPnZ8IRihk4ig8mdR6pv9dcBywvh/TofzxCu9N69U+
         bIKZ45Kxl4DIKoOUL8sJtuMqfo99i1zJzsETX50F74U3tc9jvrlOUEs8GVH6UziH5Fil
         pkwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786404193; x=1787008993;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FpMqKDZdeqkAxP+HMbo4Vf8RyrsMvHYCAM3HPa8Xz3s=;
        b=RaBBdIt54mKFfnwX6VMj862FnZ9RQxM14vuZXS2d5WgLjTpu1woy5UemGT5HPro4GM
         U+sj46bKcSYHYsJEJMNKRpmNNvjs8gvd5zQ2dFNVtN9UKbXyHUhBXSq2P4Gr4tvc1vk5
         Oa8dKgXj7jGNdosGN2ZWVZd8mgl6MdXzoAWrxDN15O7iu57sCnII7p3IV0BVUPtoBpXD
         B2bVVNAqcng2XDh4fbVpmZG6VWpBRp5zSCFQOlGdS19BqaYOsy3oHVMayraqd9x97MVM
         nejmpy47BWCmtGcO7py/oYj+vqPp2ycfaEBqNPgdQgWcfKAcs5Nzsf7iREk0PGvFJxbF
         m4gw==
X-Forwarded-Encrypted: i=1; AHgh+RoSk/NiXr1Nkk/7LkrFn7p5TEaBAPtvG+v0Va8vn1OghjCFONWL/AWeGBwe50uWjaLjPp3lk69ZyQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7ETvPbspJiTW3C0EQiZvkTl6gNqfGw+fWCuCduckfG+NAwKp/
	VCbIyaGQlBIog0v9uHJ2p/J4KTjtQVdSVFVkdt0CGOyB5PoGipSyriWwVO/u+lDS1R3KT79QN6A
	xX6dtRg==
X-Received: from plkb4.prod.google.com ([2002:a17:903:fa4:b0:2c0:a516:2c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fdad:b0:2bf:9760:b94d
 with SMTP id d9443c01a7336-2d0ca7fd072mr611571635ad.15.1786404192685; Mon, 10
 Aug 2026 16:23:12 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:23:12 -0700
In-Reply-To: <20260728121138.1103610-5-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-5-tarunsahu@google.com>
Message-ID: <anpdYD1UaO0ffQgi@google.com>
Subject: Re: [PATCH v4 04/11] KVM: Track weak reference to vm_file in struct kvm
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0AC3E8000E
X-Stat-Signature: bcitkbpu5bb8xx1yfurjrdq4pozcswp9
X-Rspam-User: 
X-HE-Tag: 1786404193-456605
X-HE-Meta: U2FsdGVkX1/8Zvlbs4oh+FgwQuTbDH6za5YdSI2DvLXrjIaI7O/JXji4c9Wvx1nFnMlhMVmmJTo+Mnh9+XM5ApmlL7SM3c6l9XtzGDJKSPQ9CeMxd4g8JwqGWnb/U0DkgSw+ztyxpJOhyD61UB5Bb2VSbDrAef1Git6McqVwHy608zp0EXrylGD+PQYiEDq/ait9OUs/Cb1P/cQmbraIavHKuS6eHvWbYCmlXMfzPX2LKe9ycAwl/gDngjx7lvpv3vxXjISXsc4DDHrsuZ6Gt1S36Fn8YE1I3VdSYZYnqLtjJ+U43HZdsMaD3U2NzH0P2CA4ZQJ1Bsw0cvhY62Ish2j6j2mVNvg6qcBDmjD/jD/8ePs663Al6izTRyx76ZA/rRxSGkY7jGjkPHbyHQ7UgcerWYXgR+OM/TKArcGonFZ8q/wAitqxhef1QPjXq2Gnk/Cifr1skWz/0ophSA9ly4p0t//R/bLlJTHiqLUEXe6a6yx0kfO/k2TMjOmcReWFor0nj0nGdxVGLKhs7C9sWCAFNZX4pwnbm2F685jlt1tq+6I/myGPgRzLM3ImA7WFDAgYcwACykKzcmFwSOctKoKl+RtbG9Siaxf9PABDHyYFFMqz7bpNmeSfgl3cmE0ZqsWJlR/qcC84fkMzyJy3fwe/AeWKs/n0/uB2wk71bDe6sviscnqaExff0+vxG2WTnn/07/1urRlQdmsXyi+sMJrgVY/KUJGvL4XETvp9ujNSG74JIg7pF6gRZ3n/rR7SpJ1VSh37NbkVxxdhW/LUc+licINH0iV2XC09wfspC8DN9+OyrbUB19eIRVRfsSUpAtiShGu1+sV7H8mgrkKqqb+cz+7GzFRbas5ZyJmqYvnDh357hv4ZNf+WonKMZTm7sPRoHPbL0WBR8JpRV4EPOwxyhhFLulrAIIWl6WYubM8FwujGNxu0AvKAE0qPHRKoGQLG3m6CW2Adxxyh3Zy
 YqobnDKa
 mtrAL92fcQqmioz/gD0RD4p1r58Q7OOXvPL4FBK/im+6PVjtpNYfNtM0EGfCuZPDElGJKwGlidMUNJAtmsK4LNxmt8q5DrdNzQw6zGGS/pSttfFMaDL1naDb3mMe/YaIAKbNeAlIiRyFj0lDUS58l+tM1AkeMlymEM0KrWu9cpY2VrMt+2boIIQyMpBMCGgOQr4B/gB3/4Qsbgk2pj/qeiiSvipWxl8+0XLKk870wOiJT7p4Mc9XU9pxtscbLS75k9YaX+E7qZXlBmWKBm4WJ57Ios9A1t0Mbb3KA2XglJ9TRD6TSUFDlgQyUY8XXUdOD282CUsemqCJAj82MqBEzfAg2vtagvEHQUMWrXDw9pxyfyrIdvioNvy4ylyQfUT6UAoYdKFUgns7mqOpnxx1uS3PiyYEs9MgvnWJ5wqQhfhCuIJgjHJggsNmuiIC/8lPDqEIjRt33dXtzN0FxDIU3ukNhDeCVn2H3JZSVJXRBBVNvxxu0cMqne3/CC5d8aqdvMd+DQwsDZp+vlM9leRrcnKmw8NT7F7GfSHnQmjjCWDfq3FOI31R+GquB1RbRTfE3Lo+32/1BoiD5Zjv0v8XV/Fwe9PSZxz5HySDh74Z8bdE5hEP0fRbQPFefoBGR4eiuZKh3v8rgS89GIpIeCR/SIhRK+803nheQLEVuA6t9AC1LlRXwwOcM7zmGLFt3EtaMgHEDVvQvBq+AGxVKFHOi7n3DXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> - Add a weak reference 'vm_file' in struct kvm under

"vm_file" is effectively already claimed by vm_area_struct.vm_file.  *If* we go
this route, I would very strongly prefer to take a dependency on "vfio: Use
file-based reference counting for KVM"[*].  I'll poke that thread, we really
should land that one particular patch long before the s390-is-arm64 insanity.

Empashish on "if" because this all feels backwards.  It's not at all clear to
me why liveupdate goes directly to guest_memfd, but then requires a token associated
with the VM.

https://lore.kernel.org/all/20260731130902.654679-2-seiden@linux.ibm.com

