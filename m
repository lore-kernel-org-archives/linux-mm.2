Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27082EB3644
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 23:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081456B0112; Mon,  2 Mar 2026 18:29:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F6C6B0113; Mon,  2 Mar 2026 18:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E498A6B0114; Mon,  2 Mar 2026 18:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4DAE6B0112
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:29:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70624140365
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:29:41 +0000 (UTC)
X-FDA: 84502717362.28.70EDF12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A139E40012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:29:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TSxh7FtX;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772494179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PH6stFB2Nx/ECXz2prAUsaDuxA0K8V3rfmFNdCvYncM=;
	b=JvceUdI3inYmsIRZ0tdlP2o74G2G62+hvGA0a+xDX4V61TeGbWft1DqKS0qbmcHg5mmrmL
	/CbwgXmwSrjlNKiu+aOSfKjvNxa2WcxAOM9HhDnZonYToBDRmJnh+eO+gJubO+CXe9qqng
	vAggfAPljBm5tyvduAQyHRhCg+HINBc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TSxh7FtX;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772494179; a=rsa-sha256;
	cv=none;
	b=CoT8aes45aOk8xb1rBEwm/Y1oJE4C8lN4/pD/dCkrxUeHQfwkRLpe9Hiygx4Wcl4G43tRd
	iwD5TtSO3gVxsKLoTszJlp2G1qKqoQJc3zKpgzBNqRwQYkhGam/Tv3FqwCZd/zkvtrOP78
	cRAB/7f/vtvZnDDj+MzMrq90FBs4yJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E62141AB1;
	Mon,  2 Mar 2026 23:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67948C2BC86;
	Mon,  2 Mar 2026 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772494178;
	bh=cGbDhS0SYNM7ywiKo18nxPHughICS0VYorf2j+DgiJI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TSxh7FtXeAjmq+kHAoxRq7blbJce7OjcAyo5efUABhyEIDg5ECsbidW5Mcj6tsYRQ
	 DzsG6rRpbWkeoTG5vogARAaO0jUDloWcC8I+5NMkdmsuNVjw9kdp+VtHQVYC7rwOhD
	 vT8qcareSz2ZYaJdXKgw++Ul/6kRr6+5kG6+y49U=
Date: Mon, 2 Mar 2026 15:29:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, "linux-mm @ kvack . org"
 <linux-mm@kvack.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, David Rientjes
 <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Alice Ryhl
 <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio
 Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?ISO-8859-1?Q?Hj=F8nnev?=
 =?ISO-8859-1?Q?=E5g?= <arve@android.com>, Todd Kjos <tkjos@android.com>,
 Christian Brauner <brauner@kernel.org>, Carlos Llamas
 <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten
 <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jason
 Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Dimitri
 Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, Neal
 Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>,
 David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 00/16] mm: cleanups around unmapping / zapping
Message-Id: <20260302152934.eba1cfede1c9b8cebdf45b09@linux-foundation.org>
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mffhs4ycn7yp6omj1kzbzwmpx8c96kwm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A139E40012
X-HE-Tag: 1772494179-532067
X-HE-Meta: U2FsdGVkX19cQPNvI+dQSOKbpOzHaXZX3B3P2+fhCL3mfScrQVQAkA+Wm8PzinEMgsq3mJQhI/4RH1HSVTPcHy6/ZHsdFQsNkmU15JlSAW6MbKWboLzV8p7u/JC3braE4fZZPIy7FVS4mva7xOXfRZRECL/mQOkJddLcky9ANZJs/16YN8yc+dwxT45diP07a/D+VW5zUpHVUhkIMIYTdx47WUjqirWej3jBH668FyjbCzPr6TiZFhT2f/8mP6DD5rjUG/fl33GdouMROO7Q2ZEdtbRu4lh19MeN6RFs2oNO0XRD/gGxXOkVQL+4xphuJWyANBe8G2k0vjNNfmRspW9y0OmdYESWrxUGriC4Lr9fSylB65mkELX77HVQ2gzP+H6b5mTLpn6iUCJPakMJ0W+mhgNJMVts9T2r+qMf0INzjN9Bb5At5O547NUUda9NPbxXjLuhvGvSqyBF0xkTYHOfgoWfQABpMwDg6sE3JBXh/GoR+S+mIlJVwm3w3ufsnOET6JLqD2Kozksktjq8cPnuT7N5gTG/GgqCWU1X2szI1A2/k9swXRyGi7Vg0ulLfXa9vks3WrjnnLsAYn+9+g5XxELnmf4iAgsRrYg9x+HFMcuV8yAZxo7AoI2G7OgoztiUS93T9I6RauHTIfK1GK0b7nKxdo7jeUFq0EAL+D9yoYvHYBOKDU0ipbOnAJEfgTslOc8+BaBXjaf8gPzDKNi2GM6ckdvc1U/0nRqSeyR27mevWCyPxs8bmtf/2+WDCUmYC1MDl9s0ouHW5p0w1UqEP+L9DCo7TOdI/nHJ04kf+qKYBgqsamYKBOY4ObK2ouHgiiErAOOA2ARhBFBjlauHyX1KGCYqEgUerwB1BmVNO7X+X3cV2AOtEr3qD6C5Kq9ZvDS6zBmY9AIfA82u0uCXPv3vQd3ZcKzIhE+oSAX0KYFlIeTcE8GzXr5zXAvc+YCrOFt71F+Civr7Yqt
 qvGXHyvg
 dnX+WQfkv8Z/sQrmcxx3IyXJEXn8YRAkZmes2c8phPBesd1ObSnXF+ci1RT058bHVCkwfe5ekhtBwvXIre5lGZiyOColI7pzIwtAhrrOfzgJRozolO8GuQnlJvNI9L3JO/A7kqCa20Kuk2H+cD9WsnRbpfQazJKoOj3b6KEyD/Y24LWIULsMfsZ7KUEjPV0lb+xESGSBS64ieWKVehxzFfh/DSt6q3JExKD6odFBrY2wMVbBbE9exH3uuF0NdKMeRC6dC4DfE2ZQkxhjSU7LbFDBQJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 21:08:31 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> A bunch of cleanups around unmapping and zapping. Mostly simplifications,
> code movements, documentation and renaming of zapping functions.

Thanks, I added this (and the below) to mm.git

I suppressed the dded-to-mm emails to protect the innocent.

--- a/rust/kernel/mm/virt.rs~mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix
+++ a/rust/kernel/mm/virt.rs
@@ -123,9 +123,7 @@ impl VmaRef {
         // SAFETY: By the type invariants, the caller has read access to this VMA, which is
         // sufficient for this method call. This method has no requirements on the vma flags. The
         // address range is checked to be within the vma.
-        unsafe {
-            bindings::zap_page_range_single(self.as_ptr(), address, size)
-        };
+        unsafe { bindings::zap_page_range_single(self.as_ptr(), address, size) };
     }
 
     /// If the [`VM_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise
_


