Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26FCD6AB17
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 21:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CAFA6B0088; Thu,  2 Apr 2026 17:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BBB6B0089; Thu,  2 Apr 2026 17:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC806B008A; Thu,  2 Apr 2026 17:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8AC16B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:58:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8728D850F4
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 21:58:29 +0000 (UTC)
X-FDA: 84614980338.24.E0DB665
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04C4D140004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 21:58:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBJzCsq7;
	spf=pass (imf09.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775167108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuToGNZ0fDyV9ckReF7x/iBdAj/35w5vB4q5GhoKJJE=;
	b=FiuKu227H/pJdsPFvjDpCyx24wiQZECak5RP92Jedl/JgEjWO6pCVyF0RciTWuzJ1K5i27
	xWlYKnUUgsOqlF96cCF22dy9gBEhWNfm6+jPsFpiAEHOhYTdkeb/Nw0nyegK13gERUajUt
	gRfLPDml9NY4I6sXjf7UR/8Ur6KHGcg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBJzCsq7;
	spf=pass (imf09.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775167108; a=rsa-sha256;
	cv=none;
	b=2vPpuRF4KZVIEFBGZPsJ60nXBIoLED6yKqHzLaVRMPbGoI/dmN6Pl+WtMNWVsD/uZDQAcR
	jRQuhy/ZtCstlQTrRms6RX/8/XC00S6i7070KIOi4Y0xHPkk7Ri9IAfRERKT+EnL/AUDJG
	tT7KBj0qj9gECBIEGJj/DjZt3WUp3hg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9BAC403EA;
	Thu,  2 Apr 2026 21:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D96C116C6;
	Thu,  2 Apr 2026 21:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775167106;
	bh=QvUc9vANqYsb1luDp8UYk1f8BqkeVaTMVXLV75eutnQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=KBJzCsq7TNcgHpU+TWPAd3W8YuuJXdgpviR9Ow38UzYp/E+eDMYCQdUq5+04/Mnru
	 vF8yruBgH9Kqoxj3RdUA00tDQnEgnr1qE7AXbmqG7qka9IVu/f1eZKTg86JWT+ETrn
	 TjxI1jdECoYVYFvAydaPvhTr0DLyOkSNS0rHhfEWArmmkmeciwTpFwX+5aQHpstoUl
	 foXfbAlUvknuR2UINHvJ3kK1f5ozCCWUSVy6PFFL3eEN4gpoDz+keSHvFP6Ep2zvPe
	 Ej2doeiB7lotVTyVy6ov80wS5IsFWdnGSH4WR6z1XJ7lBV9TObDwXGWdYhpggyK3MT
	 1b1VbHt8uneOw==
Date: Thu, 2 Apr 2026 15:58:18 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Yury Norov <ynorov@nvidia.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    "David S. Miller" <davem@davemloft.net>, 
    "Michael S. Tsirkin" <mst@redhat.com>, Theodore Ts'o <tytso@mit.edu>, 
    Albert Ou <aou@eecs.berkeley.edu>, Alexander Duyck <alexanderduyck@fb.com>, 
    Alexander Gordeev <agordeev@linux.ibm.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Alexandra Winter <wintera@linux.ibm.com>, 
    Andreas Dilger <adilger.kernel@dilger.ca>, 
    Andrew Lunn <andrew+netdev@lunn.ch>, Anna Schumaker <anna@kernel.org>, 
    Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
    Arnaldo Carvalho de Melo <acme@kernel.org>, 
    Aswin Karuvally <aswin@linux.ibm.com>, Borislav Petkov <bp@alien8.de>, 
    Carlos Maiolino <cem@kernel.org>, 
    Catalin Marinas <catalin.marinas@arm.com>, Chao Yu <chao@kernel.org>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Christian Brauner <brauner@kernel.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    Dave Hansen <dave.hansen@linux.intel.com>, 
    David Airlie <airlied@gmail.com>, 
    Dominique Martinet <asmadeus@codewreck.org>, 
    Dongsheng Yang <dongsheng.yang@linux.dev>, 
    Eric Dumazet <edumazet@google.com>, 
    Eric Van Hensbergen <ericvh@kernel.org>, 
    Heiko Carstens <hca@linux.ibm.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>, 
    Jaegeuk Kim <jaegeuk@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
    Jani Nikula <jani.nikula@linux.intel.com>, 
    Janosch Frank <frankja@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>, 
    Jens Axboe <axboe@kernel.dk>, 
    Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
    Latchesar Ionkov <lucho@ionkov.net>, Linus Walleij <linusw@kernel.org>, 
    Madhavan Srinivasan <maddy@linux.ibm.com>, Mark Brown <broonie@kernel.org>, 
    Michael Ellerman <mpe@ellerman.id.au>, Miklos Szeredi <miklos@szeredi.hu>, 
    Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
    Paolo Abeni <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
    Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
    Rodrigo Vivi <rodrigo.vivi@intel.com>, 
    Sean Christopherson <seanjc@google.com>, Simona Vetter <simona@ffwll.ch>, 
    Takashi Iwai <tiwai@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
    Trond Myklebust <trondmy@kernel.org>, 
    Tvrtko Ursulin <tursulin@ursulin.net>, Vasily Gorbik <gor@linux.ibm.com>, 
    Will Deacon <will@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
    Zheng Gu <cengku@gmail.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
    linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
    linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
    linux-s390@vger.kernel.org, linux-block@vger.kernel.org, 
    intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
    dm-devel@lists.linux.dev, netdev@vger.kernel.org, 
    linux-spi@vger.kernel.org, linux-ext4@vger.kernel.org, 
    linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
    linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
    linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
    linux-perf-users@vger.kernel.org, v9fs@lists.linux.dev, 
    virtualization@lists.linux.dev, linux-sound@vger.kernel.org
Subject: Re: [PATCH 8/8] arch: use rest_of_page() macro where appropriate
In-Reply-To: <20260304012717.201797-9-ynorov@nvidia.com>
Message-ID: <ee15482d-22a8-9686-ba64-d216b25d8e68@kernel.org>
References: <20260304012717.201797-1-ynorov@nvidia.com> <20260304012717.201797-9-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04C4D140004
X-Stat-Signature: pfg4k9n44313rnc9gscgts98yoc5kcxm
X-Rspam-User: 
X-HE-Tag: 1775167107-719079
X-HE-Meta: U2FsdGVkX1+qRPQaNFAVrN5ud1P2Ftbtvo/dICjeK3XXeHltObKpfXImdINxlaEaFfqucyRxRaZeILTDdtlOCp64lxOGbq3XkuYpnezbTbvsTGgNsPHH5IVdIU9t+2cmc0pCmaGTsa2wyYv3imG5oYdFLf9y9v8QMnf6XmuebCphgyZYMo6YKn44jm+n/lu9B1aX2P7szRPNsdaKvtnNgaZh+m2kj/PP0yt84gImB4+o/vhtQHmZP1RBZ/YlREbLShdEuNG7DJsDIw1I3SVn1clN3vbQWBMGdebGDS0xZKQPmOKBoJx009tYFXOp4HZAduULJaLCKlYXL5zNz4IIXqFIvo1mvQlyxAkCdHNCNufLCc43p1uAAWh7aeGMOkNy9HG/SHuXQFyNhCJHYNcDvgANZet7qECQKBB96FaM8+o5+URbu6k1+X3LAwnHT5B+qfKQI+UwLZOPY0aqeeEUrjbDJ7boHcFvcwsHbCuYdKFI13hyB9Yu6Mv+BmDR9P7faJYi29itYriOwA+hOpWE5tyfn8vcBxcfUouCVnzPvul60nkArdpWBk//brKWaQuzgPilJeVKcKMNWZq3Sh2Q+96lllDsVLFQD11+QUxf5DeSpMIh0Wzmzgc9LTOJkW66rXXEe8cIj+5zvV5FHoL1NQiFUZacYVHWNq34879iKJEbmn1tQiWHhdIcdkpu+CBzMnRbBoogW8jp1nvbedaFtltKsuc79XQ9pNBcGreM7W1qOYNLBFK2t2YcAtKI2YzkiFUYD+2BlA6R5tHYi6yXFVBBp3R+2V4V1BEEm6LkaSATnOMG6fSicCEJXW5YqblDhrUx7Wy+v0vXcLoE3ptWGeJnIPI62H6LflxzTGBvCB2AxJbnfW3P+7zUXdtZZ5JVJ8eg/wyUO0QntoAe4cJ7hY8GQ9dxLNZ/UatNs7PHwcEROj1WVR4JWXyjDDPleGQM4gHC58cMStWjxfHvtaa
 THT25AYv
 4jqze80wQgHNJLabwK+krQXNB9J+90fGIiqSjzM4y5s1vl/HfbE0MrsCcmaDP3b/j9lPEg0ROZ0dGXDLvhpTADHPEog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Mar 2026, Yury Norov wrote:

> Switch arch code to using the macro. No functional changes intended.
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv


- Paul

