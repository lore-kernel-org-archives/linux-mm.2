Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3BD8C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA91F6B0088; Tue, 25 Aug 2026 14:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D335E6B008C; Tue, 25 Aug 2026 14:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFAAA6B0095; Tue, 25 Aug 2026 14:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93D486B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:55:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0660D1C01BD
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:55:58 +0000 (UTC)
X-FDA: 85140696396.29.D3EA881
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf11.hostedemail.com (Postfix) with ESMTP id 564CC40008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:55:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CZgOaPXF;
	spf=pass (imf11.hostedemail.com: domain of 3OuWNagYKCJcJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3OuWNagYKCJcJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787684156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xccKXo6SW1SbkIzehhqjd8J3GgWcAs1E82/+Xs14ta0=;
	b=P6yftrbZceUZiM1JOtU0B+h57jxCorR5Dzq3njTkVjVZXDPBCsCUvTb2DuSQs7z936VUTh
	5wt1DzII0AQlBRM6iDodwjoUiJ8GFUGFXT3ulGaFMzmKSonYftTr6H2J6dCtP27hXYHMNL
	zx4fmCtpfPsJI7ux0WdFlwH4LM33oBw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787684156;
	b=zXxLEVP+uFm+p24GoVPkh4P2yp0uQED0nogj+ZOZUocsUYVyO8dvp+7Cqr5bksyd5rkhgV
	kTH/BySgsUpEmasx4RyAwodqWCzsGrlUgcgXc3qtI7ZrLiJtTDXdyeU/LUwUbiRbPXbL5c
	kImeeUiUgSrOQoHhrltWBd1wSfI080g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CZgOaPXF;
	spf=pass (imf11.hostedemail.com: domain of 3OuWNagYKCJcJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3OuWNagYKCJcJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cf1c86963bso11966815ad.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787684155; x=1788288955; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xccKXo6SW1SbkIzehhqjd8J3GgWcAs1E82/+Xs14ta0=;
        b=CZgOaPXFDwUyBgkRqclgBryYyl/jhfRPq4bh8m0ADn9s3Li4tI5mSDUoEImJ7vFvdU
         cveMujEUw51z6wdBq4BlBABn6L7V72gp5q/McBjAR9iWkVQo8o26LtlCIy//2FzUZcbP
         WFwvUmK+rPfpgLGZAq+qP9ybhkao1ElVV45hsmY0vBSHThbGjqckPyVChtTzM0lSC5PG
         rVxBTUTYUF8jGzERckOllWyPy01SZWrU1mbDqkdI3Bdi8yJwpDlI2sPsvPxCnowakEFh
         Q1DOYUfAtNP8rVIvumTgljzxeuRmPQ/NqWOlWARlPK5jhtkPqo1hHxP45Ox83FSB+Ea1
         ghhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787684155; x=1788288955;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xccKXo6SW1SbkIzehhqjd8J3GgWcAs1E82/+Xs14ta0=;
        b=hJRNrc+bX4AvEwfzSE2Mkg4I4lQmn6waBj54SkVBduLL1ef0fW3RIg7YaWT/xuUqEp
         k8XRBxHvuilP6tB3VRuHVujLCulAC2r2TaGjhWqBWCkQ+V8j8FgaSLTB8qbcKeUHGmyL
         k4OYHttrJVpVqrgWHR9dES8whEBfhiUXRVJxlPQfVgBwFWcLtbPhpmVHW5Vag4I4qr+G
         WoztZrL23r2brznbrpvKGRRKtK5aiYuYRln+YbLVTxIbcGJCViG9y7MreDhsO1O79GjZ
         ttz7G3ESJTcDpmyQ+JiSD716R3in2uCFVpY5phjplLfHGt9JAGBBL3ExeudDWgxRvLFG
         hQug==
X-Forwarded-Encrypted: i=1; AHgh+Rr6DgSLkTKv0GAP5LxPv5yXgVArXTPyvdyQvEaACVsWNhBrC+1cmNqxpNLEbgY4ft99nXgmMuqL0A==@kvack.org
X-Gm-Message-State: AFuF++n5PUPGVui6RncaySg1AF2smHrOFj2msCZklKo4tYNyJqWBJtpu
	HmZydPxyptbnu3uFcVo7FHR7WR4E/HY0PnFebO3dD9cPl2qdO0JA1EwJEdHua/A74Oc+wvsWVjS
	/I0qIYg==
X-Received: from pgbdm4.prod.google.com ([2002:a05:6a02:d84:b0:c79:39f0:12f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1398:b0:3bf:8de9:c64e
 with SMTP id adf61e73a8af0-3ceed381cdcmr1617377637.2.1787684154733; Tue, 25
 Aug 2026 11:55:54 -0700 (PDT)
Date: Tue, 25 Aug 2026 11:55:54 -0700
In-Reply-To: <meww2a2uf3yeevsfpicyrlg3hch2x4bsdqv2lsv3vfjxg4qzes@co5eogmhkxrk>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org> <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com> <7eba513d-cdae-4832-abac-038dcdd88517@intel.com>
 <meww2a2uf3yeevsfpicyrlg3hch2x4bsdqv2lsv3vfjxg4qzes@co5eogmhkxrk>
Message-ID: <ao3lOu8-wpGTs2wd@google.com>
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 564CC40008
X-Stat-Signature: bgr513tqxx5rutxx87k9f3guwdbrns6q
X-HE-Tag: 1787684156-935771
X-HE-Meta: U2FsdGVkX19z7Owb6TXEPW3fOwT8+krzdaqigZ8OinKtclKMu5oCqvztCaiXuGHgD4GoEe/UyGChbr7C5Rq9szhZzLfHp/ahdWKDL3r+ySZslMdnE95Sw5Yj1cV7sRVJiHioDcWMyPnnRAbD43sImtccqtvS+No46p2UmRZPfQ1H/vuwv8ACjXWnAPvDoTBJJnYL32VVwf8FhdufmRSNtAwbof5HybkrcahXWGpPGQhegDdv23dkbqGYrKoJL99/nj6DA5bWtsZBzTIESG8B1T5dG0LNAKBpmbOtAfODzRWouR0D/4BRlWBm1arfAMcF2UB+SB7i6FI6noCLUoWXBLDje1btTR4Pg+JviM7cE6DozxT6GUS9USf7gknACcDTeoVOPOOrIt90yjbpnSUbCNTIYrzTjT5Yd5NgGPld0BaX7R2tLcWgCOBLiqdTWp1KLLEAbpLiLYGK1Pew2vMv2x2VSmRJub3VjdscAbh4jUmGB45iRYiSW29Nd82nhNf+HAFY6rdtIbJTFqHJpKA9kUwGiQLy817FG4HlOvIIF0puG+fZ05wNTffRL0i6IinSFvaLB++UIkwYlPFTX/oqtXU2+qUlZ/o/W9477hNblhA2DvvcmyL0AxD99qBmtYEOIaoLB7rVydRKsbYF7HCYMzopyKNkzUylaCXjFI2wkOZx7H13X+zvRFS6m7ncBqEckb7rXQaRGLU9xkdchABziJxKpaVxVAJUJbGAfHz0Ow+GA8zjJAPzDsvkUpT4ml3qhuN9/7RAmAuGCG7HY3Uea/oYfRhOeyizRfYS7R+zGk8ek+qQwL77iv74fzmvMBKS1963CTEhEMxEFS4Rn+lZwFSL31YUdyfyAhafeHRSg3xDZV3SLAAZGRXZQ2hNGZzR735W/kEemesd97iGRteBWU6QxH5c6LjC5nURbVglFbA2VIXjIM+3iMhgO6iBx5Qms82W0+3KtLjZ6Ocrvwv
 raB1qM1K
 2Nl7dkxriBKkNnjHQikrKktb326RV5U+GyW30ak0MP+IlfgwkiBIIZJsy/JVklRhmr1hmJgZxSuxv4rQoLAjxn6zmwRyDvfUGJXsOh43tqGskjsAv6pdZljktVo6I9UurRpKJX7ZXg7QEFf4Fm4huxT4X3s52RzfxftiZlT/VgfKMbd7rPZ5IJM5suG4wBqjhYrrfNBrk/c+TGhEG0Dfkj/hMRDILRh/qgYLlGJcqdk8pxm1cTqxpXF2Z4vHlyfY91iJP6NV35tqI0fcjftWW9pXdoaWjFP+SyOyLZwEmxWIJyJGKROtBJ+6+1AqZo2d5K/F7uOJx2UPrkw688uRdrk7eXlsgkehAvvEmBHICFOHrzUDYzlLgBjkmh+v/gUXX8VSKtWSwKhHv9BksFgQHDsTSRodTMHOzvhrHNaKX3agPT3txoOTrtwa7QJTbTAE+/tAceFnp0VfwF+LSsljWj1CDuzV3bMAEqEmSXIyG7QDApoLEAFc4h03x1KVeMdzHyMYMAfsKoVqe95oik0mRp8NYjSpKrwID//r2lajgMZPoGCikG0hxoGaIRmYagtCJOcKGVCL5kedId71ZMWFAmtKFBwJRCHeFkHwdM+4eZtVZImyjON8DZbeDwM+/eAa8TA44e6NS39bSLTFnlX6+TtIWR6dqP3s3B7gwL3+2/8+EdV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026, Michael Roth wrote:
> On Wed, Aug 26, 2026 at 12:13:47AM +0800, Xiaoyao Li wrote:
> > On 8/20/2026 9:32 AM, Sean Christopherson wrote:
> > > And vice versa, a PUNCH_HOLE on a SHARED gmem (if userspace is
> > > using an INIT_SHARED gmem for the shared branch of a memslot) could invalidate the
> > > PRIVATE mappings (of a different gmem instance).
> > 
> > I'm wondering now how this could happen.
> > 
> > the requirement for PUNCH_HOLE on gmem to trigger mapping invalidation is
> > the gmem is bound with the memslot. But how can a memslot bound with two
> > gmem instances?
> 
> I think this is for when userspace uses an mmap'able guest_memfd instance
> to handle shared memory, and a 'normal' guest_memfd instance for private
> memory. Each instance is bound to the same memslot/GPA range, and
> KVM_SET_MEMORY_ATTRIBUTES handles switching between the 2.

Yep, exactly.

