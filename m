Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6655DEFCD71
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 09:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98706B0089; Mon,  9 Mar 2026 05:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83DC6B008A; Mon,  9 Mar 2026 05:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86786B008C; Mon,  9 Mar 2026 05:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD616B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:54:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B2E61A082F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:15 +0000 (UTC)
X-FDA: 84526064070.25.7246238
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8CB96A000E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kcF3hNYH;
	spf=pass (imf25.hostedemail.com: domain of 3xJiuaQsKCAUfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3xJiuaQsKCAUfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773050053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pIf0vYFKMELNG2TTEBOnMZwDB9piTsTF1zoj75pjk5Y=;
	b=LFodxVPUCnp9capSl03i9spTS0SWCct2WqzCBJmqUpzMf78VZ2bVwoYQnCop5szSenOYJj
	j0JisdR3dXNNqq1ZzN4FEj29ZuPfHyAbknrk7jeQYrKhLyREuQoalmuaHbYXMaoNsq+oyw
	znRg3ldB62zriMSGDAY7D9RR2YOCzkM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kcF3hNYH;
	spf=pass (imf25.hostedemail.com: domain of 3xJiuaQsKCAUfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3xJiuaQsKCAUfhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773050053; a=rsa-sha256;
	cv=none;
	b=sK5PADOKje4UQrdyAKxnRfo9/cpS3I/VXISUuEEMGi7U5RsihlDFF9exuTnCSoS7LRzLSG
	w8z6cgWcSkEpSu5VKEcx8cecb3DVHDirva+daE6FWARXpxaK4vS8DxMXIcBThZhrOyJJtV
	4Gz3MAhiFhCRtrkWtZ3WXbBwMyhaco4=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4af66f40so87429895ad.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 02:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773050052; x=1773654852; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pIf0vYFKMELNG2TTEBOnMZwDB9piTsTF1zoj75pjk5Y=;
        b=kcF3hNYHfcQNq1dRDa6kdAzssSygJ7d0KgG4rNUlplujpVLGSyBsukfIjNM6q2ojzs
         CLhhs/RR8hC4j/VmMc6ip8Q/07DJ0Cq5JYbVLs+RHvggAhnDkIjQw/Yj2RMELiWAurPc
         MrxX2h4fZT3LfwQtcYJp/fqM42NF2vj0hF/Nyjj6NNzEMyfMybzsM0GXpw/EpKZKYBU7
         AyA634gT6bEtudSlvS4dPJimbY6NaiUYLk3V3ccag5vZMdwOJ1hM4WgR9pN/cqsPA9Vf
         fqgj3bhR2sQooR9gms8wA7CCXAGVePYXZjPzsP2lyCZlZPah1CWsTaxQBhDjMUKOrPrO
         bv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773050052; x=1773654852;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pIf0vYFKMELNG2TTEBOnMZwDB9piTsTF1zoj75pjk5Y=;
        b=JYMo9lJzn+otMEV+RgeCXJOpvAGeeOtoaLHfDcnej3BZWmddroIr36aH/Sst0wvta3
         ibDglZXeJATMpxYiq5x+VCpy5EE82yUdRyi9AyleqEVkJugRtNLH2jCTQC5bW64QOT3A
         vEqakFtfzY1YWEvmoiy/ILn0SDdkXsuM7J3354RwCyZD6Ryk5PdxmeQXeibsKOe7gUtT
         D+oyd+A/NekA1SX2a9YJEqsev+ZKG6MVQTWRCdEuhCjD3k24e3qM0/SBp/AnmqLMXCOj
         ibJY9OzEKlqPI9dGc6Lgshtg98x1xFFrGQTVUHiQtgxB5wJYDP9Kw7jMgcuWLucHm6Ld
         niPg==
X-Forwarded-Encrypted: i=1; AJvYcCVAlnFwVKSbmDkSObqz9Ru4FavHiYaiZqf+v3LbaBTOeA+7vtrNT2uANOIGeMAa5pjik4m0yETPNg==@kvack.org
X-Gm-Message-State: AOJu0Yxkhg7Yqzyosxj1FtBWv9EJAIpYyE8AStYKpuADai4G111xPJuO
	5UIm22pnDk09hCK+ef3brtHAg5Ejx9sqQyHj0sovz+fzkh2yzPGnhaC6hXQaYX6j5aQ2HAIsYoq
	yQr10HSd8c1qihPK5/To14t+4zQ==
X-Received: from plbv8.prod.google.com ([2002:a17:903:44c8:b0:2a3:1bf9:d25])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e80b:b0:2ae:54b2:27d1 with SMTP id d9443c01a7336-2ae82467157mr111432675ad.44.1773050052185;
 Mon, 09 Mar 2026 02:54:12 -0700 (PDT)
Date: Mon, 09 Mar 2026 09:53:51 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAK+YrmkC/x2MywqDMBAAf0X23KV5oC29FvyAXsVDElcNNrFkR
 QLivzftcQZmDmBKnhge1QGJds9+jQX0pQI3mzgR+qEwKKEaoVSNU6CAvKF9r25hvGk96nqQQkk JJfokGn3+Dzt4tU/oi7SGCW0y0c2/17IHzPfmGilvcJ5fe4EsdoQAAAA=
X-Change-Id: 20260225-gmem-st-blocks-733f35d10211
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773050050; l=1868;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=68O4lC98Vin61Vk35g2/k0cZz6nrw+/Eb7DGyikKBoQ=; b=ESwVyUWcaPjwEE0yP3Xk8C7LGm2Jq8bAYp6gfzWYbQj40hBFC3hJqHMd7GHOzniNAxF11gI5E
 q/oaiFZvM1hCbkoIMF3gQqAFMwjT0SDV8AXTcEaNL2gvCD6adqoDxsi
X-Mailer: b4 0.14.3
Message-ID: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
Subject: [PATCH RFC v3 0/4] guest_memfd: Track amount of memory allocated on inode
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: swzbsyrnhgfi86nerjztgugm1zp7wjzs
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CB96A000E
X-HE-Tag: 1773050053-420800
X-HE-Meta: U2FsdGVkX1/bDoRGKyFY9zfAz8CxVWhOkvvNkG1aDPU59CP0odc1FlijRGOGhWEL0J6MQibtR+ndWy4jgjk+qFDUYbfzWtzVtj8bcOrha0lt1U1uO74Q180Tqg0Ah34dvD22Y6IcaF2sZl3SHO0bepWs2EXfysGyFK4wFDy2nxGFvcx0E8bBFFgX0nlmEoZthJhWULpm8yZerRQzDesfQylo9BiRJYzfjCPC5fNPhTEdggltQU6fQhztd/yEc58fr57Whnxmhd3/gA6GajKL0bpGNdbXs6tlgQaK4SdjEw50BSezQ1lkf0ODj8xHCGDxtEaumjOiKTiXIc79ZfoXZXcm1uVSSiTYyIr+35pv3oZ1T5SM7WuODN3SLfaT0hn8qksO2ozUykqVfvHU8sq7umiv/JZWQF74w5KftE3WZ5B/FcfXH/6O8HeClMAel62iOCaSfbLe+QH32p6oEfX06Y92tRQjIextCpdwwP8cxm9eBApdpS1tIzCb2m/Vk6UG/B7EG5kLiqhiJZTtUmwD0LhMGrpUJFhn/lngc02TGGt5pz77K2cVzFdFDzklEa+R7xPFwGTewaACuqs8neGu4VTomynroQWgytYbzphxQMKOQoGvpQHhWiyY90lH7SpK6jGv7lIrtrqIzYy51wzOcSlyIbhZhEEqcFFpkRBtCljkb3acaYxlT7FlSUjE2QdKfN8R5/fWEZLcBmAYnz5P6K2hDR+q4CuLCZmSjTtMYJMPYhTC9C0AXy86OjFjGKdUnbjjdyEzF6u94q7/EL6LdYbbFODVbJ6LR6C8R/YjzSWlLsz/3+GgLywGmrp0OH3DSVxf4dYE1VNNNb9vAgduY/8iHAiUAu+b2KumwHSkZp50VvriWqQKPmwp4Yb5EAUm6pwZSggC+w2h3J8jAUVErHfqUP3zZpJCvjiJ4ZjEZfFaCLh2tVb0+fRmMaXWTUxf1yFXm2jieoCgKp/4Sjn
 tBxT/TU0
 LjnPRZ6V02DMyN0gGWkItMGf8LpT+tbWdJlF1E64Vy1rDUykbkrbIeFxkYruBOATZppJxfDAwr8AerZ2PlsdJGEPnflJzFejLiYYP4ydF+T7rebfcIdfiUDjusAB9A4iCe35FTnnmCdHVVXzfXh+hDMfcqiiHMDZrcQuBoMbEV8j2qVmPrJdOvCcJbFfQ0qEavZT28h8a0jjvcc609au2sIubXNBaxmbtlK7RJXDMLMkkqkrFdp/WMWKwjrygbeFBDYWKy2eCwBcMVVLkHJtIHhoDNfw7hfLv/WrvSn5BHYTzYXffAzOJOW0AoEj+L1bxJ3k8GB6g/1xkrE7PbTh5DzArUWyNol/9cNd+6wSCoRaBHe0d9/Iy9RQUA72iAAL7D7lAu8AXl7OMZQ65CfRRaUu7bxBp9CFtanMdR3NIUZVTQ0yoJj7MDHwCDjk3crYC1v4k8K7cP7+OSv2KVgXJTToOkx5kPxtUX+wjwResHU2BfT/slyfw4Re5FbW4qHYoXoQfgkOF6BY44x7jrsGW66tZYVWRADuqrQywTRhRmtTBylwGXv/2wEZBpgGlk+WkWbSnEJNtCxWzX8xzg1CVw5ibsa621i14YLBN4RXnQ1JCICEPwIhVxaENcZx2v7PA5q3+Og4djBr3gxR5XLsqaABaG56Xvm4NHPTvmy8Gaq9cNPCng1HslkZBXLEkgLUkgmu1QePOtjDJqzk2/Kzmg06M4keT0KSLbD+u8aHM2Gp21d4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Currently, guest_memfd doesn't update inode's i_blocks or i_bytes at
all. Hence, st_blocks in the struct populated by a userspace fstat()
call on a guest_memfd will always be 0. This patch series makes
guest_memfd track the amount of memory allocated on an inode, which
allows fstat() to accurately report that on requests from userspace.

The inode's i_blocks and i_bytes fields are updated when the folio is
associated or disassociated from the guest_memfd inode, which are at
allocation and truncation times respectively.

RFC v3 uses the .invalidate_folio() callback to update accounting in inode
fields at truncation time, and sets AS_RELEASE_ALWAYS for guest_memfd
mappings to enable .invalidate_folio() for guest_memfd.

RFC v3 series is based on kvm-x86/next.

+ RFC v2: Removed a full custom implementation of .evict_inode for
  guest_memfd in favor of adding .unaccount_folio callback.
  + https://lore.kernel.org/all/20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com/T/
+ RFC v1: https://lore.kernel.org/all/cover.1771826352.git.ackerleytng@google.com/T/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (4):
      KVM: guest_memfd: Track amount of memory allocated on inode
      KVM: guest_memfd: Set release always on guest_memfd mappings
      KVM: selftests: Wrap fstat() to assert success
      KVM: selftests: Test that st_blocks is updated on allocation

 tools/testing/selftests/kvm/guest_memfd_test.c     | 32 +++++++++++++++-------
 tools/testing/selftests/kvm/include/kvm_syscalls.h |  2 ++
 virt/kvm/guest_memfd.c                             | 15 ++++++++++
 3 files changed, 39 insertions(+), 10 deletions(-)
---
base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
change-id: 20260225-gmem-st-blocks-733f35d10211

Best regards,
--
Ackerley Tng <ackerleytng@google.com>


