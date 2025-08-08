Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9B7C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9686B0089; Fri,  8 Aug 2025 04:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A90B6B008A; Fri,  8 Aug 2025 04:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6616B008C; Fri,  8 Aug 2025 04:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 100166B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:37:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8568083172
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:37:08 +0000 (UTC)
X-FDA: 83752935336.05.41C71FC
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id AF320100002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:37:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="g2Y/05GZ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3MbeVaAkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3MbeVaAkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754642226; a=rsa-sha256;
	cv=none;
	b=D8svjchu2HNaIWniXc7bmy91S8q9ohrbeyY/JdWQulx1DFoNZf6ssJZA/RkzKNDX6aNWI4
	mbQniGLtunMlJVmCL5vQ1xyFr0WL6Ii6G3GQV4la6XfWS82EjRkbckAb7ipYZdbN74eY14
	Ao0WiHzSAGSwIsxY61UFAqZVUT7dAK4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="g2Y/05GZ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3MbeVaAkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3MbeVaAkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754642226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWf5Rs52y8GbqmsWSRM2y/wPZrw81H/2+73aRTZVaPQ=;
	b=ts7Q6bE2imtQFV7CJ7QFMN+V0Hc0TEvPGp1m8TpXVsq79xioHOyi/ojBUBZbrhZ5jOYbX3
	oDcCWcShQcFr537EL0Ey7JgRjbE5rDQbRCzGHy0T6ErbT2fyyOHeN3YJugkn0IlRIbq1dV
	MSdW9Z5rd3jAgePNDCb1jXY68Rt/6hY=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b7806a620cso909319f8f.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 01:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754642225; x=1755247025; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QWf5Rs52y8GbqmsWSRM2y/wPZrw81H/2+73aRTZVaPQ=;
        b=g2Y/05GZ0qVlJ1Osem32iLFZux73ZmY6Qxk4OBN3Dh7ogMfHQI2c4rzuI1xtuMR7q/
         +NAyMYPewaP+QPYFBvCQaZedvWEtUCJY5dubpDM9w6L+pdccpTsH7zgJIDpZJ1CDFh46
         5BFF/A8LLrnPoctscY/uaeGCP3wi7ghcuH6hFS6LgYS82lKTmubHet+Cw0juaraoUrFE
         NLqx86e++aoQq2Z/+nTRn6M4p2GkdF8L+hEa0ra5XOrGfS6pn33XdN5sfThHBr8Z2Ft/
         7mq5CLqDtp91TSNYc0PVCaUPDwCeu4ihgQC4UnFXLF/pOe7/qn9tuzEP6lbu2DEmNHSo
         cxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754642225; x=1755247025;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWf5Rs52y8GbqmsWSRM2y/wPZrw81H/2+73aRTZVaPQ=;
        b=N4rDU96gceUsplXcN6fdRr6wkivg4/BYewdBj9MYcMN/D3ymDDAxmX5srwc8k7RjUb
         WMkdtLHiYVsmsY6S+Jxgq+wYGGX5ExTg8LUA139gYVXh1IZn2KfNUS03wi7qe3qJzTEF
         wjNqRovZYbViOBnSRYHqLkUtDda0F8InvhMSz+iNiGFfbqX/E5KxGwNLvmvKkXAWm3L/
         b0WwcIp3grkRLCRukRVxlmmWXrCfkPYaulum43AXqJjhJZEbxUxyXHWg1Vh88YleHgel
         Xy5fu/5t1A16moZutwD8gvgJTANsSF+VlXcUW5phGIR4K+Vb4MpbmVSR05sQ7t7jOSP3
         OwVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj47gxbQeW3emduaMRfPhP5n++UosqODOzSkbloqsHrCxNs+/CfyY26l3WPmgPXrtr63KXOyGYfw==@kvack.org
X-Gm-Message-State: AOJu0Yy1/bO7IdFY6+GKJvcOYY5SokXAQ4MTe0mfLhkB/ODkL4n2iQgE
	EnVxLbuZGY0BeLURlLcHhZJBu4bajYWnwPZUSa6eK0Qitimaiy1Bvrszg7EuYpE5u5Uunu9UWPc
	S03tu0mKrUn1ndNm5uQ==
X-Google-Smtp-Source: AGHT+IHeQjxsRMOFdPNpW8//eVd1Z083P34hPSyuC17y0Mc2IqIpwxhiZDy/PEnJRm6n62VtLAtwv9yuCnyvOmU=
X-Received: from wmsd10.prod.google.com ([2002:a05:600c:3aca:b0:459:da33:b20c])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:584c:0:b0:3a5:8cdd:c174 with SMTP id ffacd0b85a97d-3b900b36f82mr1932975f8f.26.1754642225158;
 Fri, 08 Aug 2025 01:37:05 -0700 (PDT)
Date: Fri, 8 Aug 2025 08:37:03 +0000
In-Reply-To: <t6lhpij2tv2y3cbps6g3mu6boiic2amy3xx6ppkksrb2625odo@6plivbxstgkm>
Mime-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com> <t6lhpij2tv2y3cbps6g3mu6boiic2amy3xx6ppkksrb2625odo@6plivbxstgkm>
Message-ID: <aJW3L3SEVUl_AVvN@google.com>
Subject: Re: [PATCH 1/3] rust: maple_tree: add MapleTree
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF320100002
X-Stat-Signature: b117p85qqf6pmw74mfc9i65d4sbzcruh
X-HE-Tag: 1754642226-713021
X-HE-Meta: U2FsdGVkX19cxf2OSfuttyBS7kxzRAVanArD8j0+zWnO8LCLn9x0bEfK3dPal27JChAQxUNZVyJyw4EbP5sI/0KeXKOYdVc0WgXgrbc0PSChxwVqmgMKH7h9ZvgRDzRfo3+lYVcfslJBZX5GRTkPiw7Gyjs8eTQtriNEiWximrCHm1CUqPaDV3yC6tTSj26isUlT0Zh7lgzGwnE8HFPPGF6RkmIbRWzfmxCziLFFo6MQgV5qkWusn+OqwVF/kdFpqqGvAsPfy/A/bfcI4NSZXR4ULLdSJ6XWPwL0tqr/rf2gLIBhl+4Q+rVZcBsRHuYaSo/UYX2WtHAk8HxLoj3HEND9nqTEinK4V9wMsn1YD5lSQQtAmULw7aE11lru3eku5CS0v8FuY/wGCiVaMpIMJhcG62ddK/8cc3H3Tq+yPZFSzI2Wb1W4063VsDgvV2EE2Tx7ysYVKEAI5RshbnZtOLh2d7CdaVn1H0pZXgsbJyKue2ZZO1nZ727nYF3RI9NPppeqU3uiczj3SUs+BXLgUgntwFbJjXRGh3rJPjsRZu40HaT5doNdyD9PAyjwwv8avCLZjcgW50sgDoE+xfsiopCH7/JacILfWm4ITlNASZXvLh1hB+SS7uOvqWYOTS8BjCiNQXolp3I5axfHGkt+OThZt3iyHdw3ipwlVe7JFQGaOFoCIbfvbIvbPFs7bxmb0h3GhBc9SIWbZd4E8sLQN/AKP3YWqGgmF8sQnrf7BSCYKopQ2WJ1viXFRj9Eiu/SIyg1eD8Ha7O4Gv5VbG7WidMiPxfhorvj+HKTVSKbbifWD8m/pGRwrZVk/WJiV6EPfo5c5s9xv3e/CqpFdDdCw1bY2ru1UrQNlbUHrXB695VneBzS/sz7ULwr8Vo0olya0wPkmEvB33yzhwdzSvH483UHtMpATK5/FXTp+tQBH/c9G4uCE3X4/uUhELZ2QvCRcNC4077F3dPxmDiKWDZ
 cRrmQahq
 WTJbTrkc5Vgca/FEi4WH9z1EGTbh7TLHR/Z2iY8Lh7jdyV+6mG3X41qaFRanvgG02v7nu0oPiRmp2E/PshZdSbm7h+5JCILA/KsnmlzGcwb6AcZ2KbZ+K/t2cSHnmVonbCy9LQDn/iXOg50mkJEJpvZLSZbcCAXBuwxm4ZVnJ8gOyHenml7BiFwkhlVN/a9dB8F8IWfCNlPnWswAp5Tp18+gSKJ+6VwQvjwUU/5+nrjmUcIuiqDBuUdSlK9CRr8l++JHeNeVvPMRhZwdnKvwXxgYro9ZWxM95siRkoLOvH4xeLhxcr+NnFo9grXzsB6zCGKFpP/3kVTa73wQuO3ApASqzQFwlVBWaxGOQS/0LlVjF0keoMXbvk/9/OAoV8P1+zsIo3eT3loK6X+GA+fgz1nWLgoulacIpgii+myTImeWAgJjev2ugusPtxAkuJPMDRwWs1HsJDsJqFcg5dBiQwzLITpldMn7a+uWXp0uS6pinJAt9RplDobjt92rCm+6FHuZ9kPqGzteiE9puR3DgjW/gFnsNdpabedEVznbNXV0UT+fMZ5Rg0auNGYBPiYsTqxTwWue82srmy3qKqC4IN5JjruIJDVnWH1MOYLQwr9wqkkshMYSdXZUcrgfF7MAeNrAQKaCarFa7bSFZ3VCqdWy7rm9WJ+arsue7UCHiBPM5sIzrg9F3N8jqMtOubRH/rdhVXNjsCM1sTEtQBNh/Cqk+QvjmoTR/tPtf/vhC8OB6K9qKvuJvN6XUJd3uCgYX3BGX/uBMt/wuf6QbY0rDOTohN8mQWZOHcPXzRN3k724/o2FpXYr8AamvYzacS+Se4VjB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 12:12:47PM -0400, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [250726 09:23]:
> > The maple tree will be used in the Tyr driver to allocate and keep track
> > of GPU allocations created internally (i.e. not by userspace). It will
> > likely also be used in the Nova driver eventually.
> > 
> > This adds the simplest methods for additional and removal that do not
> > require any special care with respect to concurrency.
> > 
> > This implementation is based on the RFC by Andrew but with significant
> > changes to simplify the implementation.
> > 
> > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> >  MAINTAINERS               |   2 +
> >  rust/helpers/helpers.c    |   1 +
> >  rust/helpers/maple_tree.c |  14 +++
> >  rust/kernel/lib.rs        |   1 +
> >  rust/kernel/maple_tree.rs | 286 ++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 304 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index dd810da5261b5d664ef9750f66ec022412e8014b..b7e7308ce07c050239c14c4f3a0fd89bdd8e8796 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -15956,7 +15956,9 @@ L:	rust-for-linux@vger.kernel.org
> >  S:	Maintained
> >  W:	http://www.linux-mm.org
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > +F:	rust/helpers/maple_tree.c
> >  F:	rust/helpers/mm.c
> > +F:	rust/kernel/maple_tree.rs
> >  F:	rust/kernel/mm.rs
> >  F:	rust/kernel/mm/
> 
> We should have another section for the maple tree, since it's not just
> used for mm.  Your stated plan is to use it for GPU allocations and the
> code doesn't live in mm/, wdyt?

Sure, I can add a new section if you prefer that.

Alice

