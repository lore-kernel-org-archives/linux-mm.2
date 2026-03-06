Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB48AF0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24AD66B0005; Fri,  6 Mar 2026 07:14:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6546B008A; Fri,  6 Mar 2026 07:14:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123766B008C; Fri,  6 Mar 2026 07:14:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 048BF6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:14:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C044013B0FC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:14:07 +0000 (UTC)
X-FDA: 84515530134.21.B53B042
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1B00A40006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:14:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVqQGJSF;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772799246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73LzocOiKFmkpCrC2LXz/bgp2Wq8zbMaYA+a+8ryW6U=;
	b=fDP4DO+2Qf8IlfhMIqBfvQ2qd2mEDW4+yLf2Wy6hMjMnY6tD6YZCWOCDOM5YuegfsFerGP
	PWoyNKiIW0SwAy4l+getdFSUnXR0HJLqKcFpdpnk6d3tj1MhSW7RK4lMH9lM6erxbTHcZb
	mkGx92Dr2hW4TwPv0okYcBn5M7pYS9U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVqQGJSF;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772799246; a=rsa-sha256;
	cv=none;
	b=lhmrLttXZfysbw1/OnaOUZunEqgNy5kb8OSBr55jSE8sZTZizMqTIjAXSwKtsLfJUY3pHr
	9VfuT6ghM/0lYR6xlfnO04f0y0OOlrx7DqOsdZwBYOI5PgqQ1bSNT6IIvLt7aK1ibFGIFc
	xFRKFIXIdLxyrC4+rDzE9wNTWv9VDVs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6715E6012A;
	Fri,  6 Mar 2026 12:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829DEC4CEF7;
	Fri,  6 Mar 2026 12:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772799245;
	bh=Aeql3Q18nbzOXyXxhu0vMzA3N0kdNt6Kxm9MrBYhJwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dVqQGJSFiWX+fDD/OWZvs6Gl8EvNWdkhGAwY0jgLtpsGAh+dBK4hjzKSY1SnoVxJU
	 Xn8o0QmPk7618RpV/ZP3BQon0ikZoZX/2Edj80XY9nHA/af8dILFPWfW54wd0CfK5J
	 NNDPt/dl+gpaSa6q1arnlJ6LaGOiSvQqHc8RpLx+kRVj9NJ49/AzP4n1GT/dB3EozG
	 MzrBFPGFBVBNv32TOIbQwG4bTmYYGJvCCLdYq7arv1NHHiBCMmGv2K2Sm+N0LRxzpC
	 aFvJFL0+ixqlChqXpUk4/1NsRYhl/5ShnknPXYh+3W2ihDb5KHKe+eLdNWM7yGCDkz
	 //0PKp6ZWU7fQ==
Date: Fri, 6 Mar 2026 12:14:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 05/16] mm/oom_kill: use MMU_NOTIFY_CLEAR in
 __oom_reap_task_mm()
Message-ID: <8ad03e9e-b14a-4348-aea3-fefd5d2b163d@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-6-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-6-david@kernel.org>
X-Rspamd-Queue-Id: 1B00A40006
X-Stat-Signature: ugmo9m9zbx563rsrxuuunutbfnq4say9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772799245-517933
X-HE-Meta: U2FsdGVkX1/l+oYUndtmkx/AzSEz6MCgpbO3cnRC9OlUMG7c61P6cKR+KKV1zk2uIc/7b+Tq1E+yMSOR5sblD5krg/g0CjCNPrHrADKdQpo81C3V7ejj5yIKh5c1YgnYA/HHFNH6jVn2s+lXurNttg07VRMGeFsEVjcqoRWEQff9n+mIBAgMJDhJ4FP9kPac9USOVRdDgEnhLAs/wMWTF4FISHMzqmhg2f5Vrw7VTSAJoJm/Rl0Hp1rSQIWdXDdmiLInYX/Jy4rqid4wG2UOjEJ8U2CLIBi3B/y8pmYrZbm7OTzE1z4LTwRgcLEzseP6DN/eJomO0X66YbU3GLga9KNFi2XkLGSZAmDo3dfTzd4yBWYzmcu2WaPrEo+AUJqnvIMfsv82JTNkByosj97WfdfufijM0NHvqIr8lRET1a3qRRXlAVCi4mAEJdye2i2Dn37bHm3tTwr5RKA7rB+i5EIaHu+wQsDkzTOh0pek0l+G4i36O1qMWAAHq9bqgrGSjlNvErwJCJBkirW6INBt18yOeZIkTINXWqk1wXB2wm+HYQ2AM4W73Qegwtx06x1aSIPIlP1HKMeLwus1RvLtUls0AbmhlDqp7TFp5pxwqPFTtnljsp68BXVU+4xwfNkKovXjM8dxZOcjZVlCzXDch3Wg+v47j2LoP0IkKXqG3482jCcAImNTCNwJvSW5MofKUintC+cRF0yTmdIz8mgq6asc2vZJasFmkQOamJuMH8FUYEePSF5s96Zq4HqmZcibxYpKW2XUmtqVfDXQEHDzipxI3XLi+oXkCBJ36D6wo0WnU8XU934LWXHDFQKStaaNp2lyo+NInTxgQyFmeRfSjRThyRzgZMPgeBPMUgRhGngrlhQzJKV/YKzJzHpAkmd0nYQol2ikGsMZMkRAMOBMLoOKND3i05icQDECdqpkY4M8mNwFsPgnLFayJv31WMZZgUJ6MBHbefWjSs0fccO
 bLBzLPhJ
 LQk57nC3skDExS6WL+FusrRxMJpGmbCn2+MVtSc+h/NOgwsPSpHF2BqW7JSC/9OTnE8AxKmpwXu//iDc6hkojnsxF8gsqb2Ke2GDqVmleimDNxm4OIyRZUq11NaCrDTvEEWGLVvze9pInY9cmPoDJh4fz6nUBMPGpyBAAGdAyP5pACO+S4vydN6FZ6ROWS4vUOJrvwxwnU8gH1+rpLmWrAA95NmpmyhXjmfe5NARuUkc4RaIHNz/GcyOWPYG3yoDR1WDdssHu/echvduN3tzCe0AkSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:36PM +0100, David Hildenbrand (Arm) wrote:
> In commit 7269f999934b ("mm/mmu_notifier: use correct mmu_notifier events
> for each invalidation") we converted all MMU_NOTIFY_UNMAP to
> MMU_NOTIFY_CLEAR, except the ones that actually perform munmap() or
> mremap() as documented.
>
> __oom_reap_task_mm() behaves much more like MADV_DONTNEED. So use
> MMU_NOTIFY_CLEAR as well.
>
> This is a preparation for further changes.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/oom_kill.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5c6c95c169ee..0ba56fcd10d5 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -551,7 +551,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  			struct mmu_notifier_range range;
>  			struct mmu_gather tlb;
>
> -			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
> +			mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0,
>  						mm, vma->vm_start,
>  						vma->vm_end);
>  			tlb_gather_mmu(&tlb, mm);
> --
> 2.43.0
>

