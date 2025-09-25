Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF83CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004E58E0008; Thu, 25 Sep 2025 09:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7508E0006; Thu, 25 Sep 2025 09:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6B18E0008; Thu, 25 Sep 2025 09:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA9188E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:41:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9994A140255
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:41:52 +0000 (UTC)
X-FDA: 83927885664.13.E8E0FDD
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id CDDD01C0008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:41:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DJhNJzeu;
	spf=pass (imf20.hostedemail.com: domain of 3nUbVaAYKCMwAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3nUbVaAYKCMwAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758807710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dU4j5xINCBqy1Rj7i7G1Vfx3gRcoZTHMrIeb9JUSMNk=;
	b=wwlT6L67yaMUsJYaNb6DJgDv8c1aosF94sLOK5u9Mj58NGY9WXSeTZrF7aH5vuNsC6hW8W
	EnyCS2O8SAERc2gvy+gJZZadFa5l9dBg5V+z/7r7rSE2dBY4bfvxdsgIJFcyiXeN9xZW9o
	naFs98al3O7Id/xZlfIt4WuFW1YETm4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DJhNJzeu;
	spf=pass (imf20.hostedemail.com: domain of 3nUbVaAYKCMwAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3nUbVaAYKCMwAws51uy66y3w.u64305CF-442Dsu2.69y@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758807710; a=rsa-sha256;
	cv=none;
	b=A+dv/NgVvIrZbvyErPWHAQpzFnDFblXMHdnr6nrW4ALyF74ByGP5Msbtyu6TTSTQCbrF65
	wW2ErxiGniG2Nw1nXumyDUyQG/1mmre/FEaou2kS0BysshjPLiozcZtK2tntbZXs6dgrwd
	yfgr2FGSQGvzY7K53TdMU/+zEqRv78g=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so980499a91.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758807709; x=1759412509; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dU4j5xINCBqy1Rj7i7G1Vfx3gRcoZTHMrIeb9JUSMNk=;
        b=DJhNJzeuCfbHNp0Bw/wlKqoChho+7rrnlX2YKz2NhfVht8LjVQARo1Wnn9TKv0Lwgn
         HAlz5DjehQvmL1sDKyOUwoBfjRDfH1RycXV9MAM70dLQFSzVgzXQQEc4pk3ORkEMSx5C
         Ia9tUo5KU0LcDbjvFq9+DTvpPVXu+XkfXR0BnyyOthJLqeltQCRZpfKbZ8NAPSLCp5Ar
         lofxfPcHWWXN9b//NTvuy7czsyWQhq5tR9IAZkaq2ZChL229UmXt2SQCHqPRY+8tJkCV
         tvCcbqrnBRz1cYQqixjZS98UJxpenEfBNhmODL5BVpRoISQru/Y3llu4rnAXki3m0JFz
         iHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758807709; x=1759412509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dU4j5xINCBqy1Rj7i7G1Vfx3gRcoZTHMrIeb9JUSMNk=;
        b=d+5oa/cQxhCj9s6giLc3wPFTf55UMl8uac79oEcgizlyTLOQMpjShW5WnD6qgpjxQb
         q2PMRfdYZtjs3WSe/Kv0JkF1GMyfaFPjy9Uc88hVqWCDO6n593Ky8hS+Kno2laBw3k4X
         J4Tz2smiTgp+NTAriLdVmHeLhsjb1HWKcZ1o7dddBaQ5AgSKPIeb/Z1ZtOJjL6aW7oZk
         rIOM5BbK4mE6DNvKZx3oL7zUyM2zTNpnm/VrcfALim/DrQHz2AtHNeUuPfHSGVnUSZr7
         6ctyHuYgissePyabKCZsiBUPOV4TKPi1jN8OIFuzOBcqkXSTo9d5sWZg8aEDKnI0Gddn
         BWUg==
X-Forwarded-Encrypted: i=1; AJvYcCVHvUGYy8lLO7+gP/XPlloPA0WCJRkDz3+csCC4ded39TR96vGGUolAa/fBEYVORy+gfXmW12nh0Q==@kvack.org
X-Gm-Message-State: AOJu0YwV9zw3gYLRo0bdIM/MCz2sA5EyyXL+YfEk04uF5CG4vIX7YUGP
	Ej39xdhfRxZ3KL4fsoFmU95ZFZfPu0/6egqjL/o7IK57H1j7+bUawd1WILnSX2e3QW+6E9iNw1m
	Gz+s4Ng==
X-Google-Smtp-Source: AGHT+IGEjcBsUTlo4/vVd9aOmfS85HeXK7VXkMsc2AM9X82gWAt19f8n9mk94PI8ByiZcVy2ayMJHM96hBY=
X-Received: from pjbjx4.prod.google.com ([2002:a17:90b:46c4:b0:330:88c4:627])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c4a:b0:334:e020:2f16
 with SMTP id 98e67ed59e1d1-334e0202f83mr1618309a91.11.1758807709301; Thu, 25
 Sep 2025 06:41:49 -0700 (PDT)
Date: Thu, 25 Sep 2025 06:41:42 -0700
In-Reply-To: <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-7-shivankg@amd.com>
 <diqztt1sbd2v.fsf@google.com> <aNSt9QT8dmpDK1eE@google.com>
 <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com> <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
Message-ID: <aNVFrZDAkHmgNNci@google.com>
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, willy@infradead.org, 
	akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org, 
	vbabka@suse.cz, brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, 
	xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, 
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	tabba@google.com, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, 
	pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, chao.gao@intel.com, 
	bharata@amd.com, nikunj@amd.com, michael.day@amd.com, shdhiman@amd.com, 
	yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, 
	michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, 
	peterx@redhat.com, jack@suse.cz, hch@infradead.org, cgzones@googlemail.com, 
	ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com, 
	jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: CDDD01C0008
X-Rspamd-Server: rspam05
X-Stat-Signature: mj6i89bayodz7z5ryabqxjb31ipwo885
X-Rspam-User: 
X-HE-Tag: 1758807710-229492
X-HE-Meta: U2FsdGVkX18v75OGzdGh4/qUPPr0R8k1CD8jqTi/AtNGwKtYFzZ4HugoDqWm4NNjz1DqivWBn4DIWhJAjShkmOhedyiGmr+iS/t4TIyQrsJGH36JvgyCFeqnNVDdXz+txpYFxU1det3hViDxFKH3hPFuCW0m7TmEpIsx3oBO0NcHtolfsScaMM4FuvOgJJJwxnf31f7KAw4ii54bJ+mHGsWMVgPcRTi4IgdU2LxNu8YQr6fgaRD+hr6G7oUUPXxcF42Zt9SCQSDT6Fzjw+ae+sGLw21Vdpexbcwr6L/TKQGXJaPhdd0u6OiWXlRmDs9sO/az8ZImLGwchqmnlLBcr9Pua+IPJDzCcAV7GnO5lPwUf6TXVC4YrrP6Yk+HByeIS7M0fAl08Kw/KrrbrL8M0iU9fGaP+8CVzClSv5Mtok8URfsc7ksXmrZVn41X3T6Tfs3MAFB8jCUObKmD0PjiTXcl1kBT8CzlC7iQl3VjLxjhbaPbzUEcFrx5T5HYUPpoP2Z72nRJJ9PMfeg0f9+rc81uDBmxc+oQy4Va8F5a1qKUa7jN5wdU2SRg5DA6aE4ZxPRxNMm+h4XiUj0xFoXLErTri9WE6YBKeGeN10CqcwR3thJev4ZJIV9jPvBBSCZveDRGBPl3BHioLMFEN38GNc5zB8VCgR40+atuGMVx4dilOpXDjV/6QXSdENYvYiwnRbPKPwOk0iWR3UPO/EcHUBT9RSacW/2rFkYuc/DzBcic0740iPMrrVw/8coLBUfD+CRC2+PZPKy6gy1qeyj0HCHcNTHD/0TbYYkYhBbtY0A8ko/B9LXbx0KxdAGcHj79nVAtpqV2M+gJA8pszISu4Te624NcJie7lYUmFw6ImVPdxxXQTW0K32cxIWXgG0rNVI7GgCjqFLEYc0CS5DwK0hdQJhQNPjR7blb4UeJqU5cB4jsAVWTRBjrFRZ2zJ2E9ot6O+JF+icospL54nxd
 Rk0etGPN
 3jK6Eq66DVxs5W0TcZV1r0ZCd8W17czXdlg7Fc46rGHUIT1RDH9UhYmo3fZJKXJx+YUnEBeYikdix/vWEcOvoNuSSuqG/NwViHzL8XZwYRfv268m4dd035Fz+Y814umwXuo/IJIHfkjrsZJhW/nVNuFoGe8p1XOBWHxTpqjy/ueJ1eAD9s6ho0Q5Qu/mNH+5Fw+/UqsJ46J4GRToiHSOOjcv/lWEThevhYF5t9TKLhEEkXrjAtIQTwCFXp8+VI3sczaO4Ehv/Ck4NId2NgG/WqPQPBANTqFfMsUbwTA+Xq6lbiFkAixkqbCGo7vo5qHat5j3j39MB8EhPhMZ31eYADhJTd5kikMwqdBMqoG9vLnfJta6bhXkxQwWMTQ3tZ77AZN9iHyMBIpLpc7ZEAulHJqXtp70cYo8Y4Szq4qakjR3r1VcTK0r9021W2ihPsU1nUx8cHPYVKA5y6gvcPd+mFMa9sITARDThIWcmQcHl+aeSZjhtgj2VqA1SvG8L8NSGlZHmC1ebZNmGxcMDoVqMBeLVZNreIsKWSc1j7dvS5Ub2UV0490RPAjV7UiqEOB6SbQ2QDyRuRNl/mSdJyg84fY2diQq6pxn+Uxfpq6GU5A0JQ7ErvaQBxc28xEmpX+1h53mDp4R21+0ZYGgcA37UTC275wmVLMO5cOIa7dGycwNIpCQ+epzMikh3wkbScmefoqkOD/PEtrIl5vM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025, David Hildenbrand wrote:
> On 25.09.25 13:44, Garg, Shivank wrote:
> > On 9/25/2025 8:20 AM, Sean Christopherson wrote:
> > I did functional testing and it works fine.
> 
> I can queue this instead. I guess I can reuse the patch description and add
> Sean as author + add his SOB (if he agrees).

Eh, Ackerley and Fuad did all the work.  If I had provided feedback earlier,
this would have been handled in a new version.  If they are ok with the changes,
I would prefer they remain co-authors.

Regarding timing, how much do people care about getting this into 6.18 in
particular?  AFAICT, this hasn't gotten any coverage in -next, which makes me a
little nervous.

