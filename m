Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44803606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eZXJ2vJR
Received: by kanga.kvack.org (Postfix)
	id 528616B05B1; Fri, 13 Nov 2026 19:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8056B05B2; Fri, 13 Nov 2026 19:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE536B05B3; Fri, 13 Nov 2026 19:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB0C6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:39:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F6278026E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:39:26 +0000 (UTC)
X-FDA: 85431865932.28.F87B564
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F10B6C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:39:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZXJ2vJR;
	spf=pass (imf10.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794616765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TR03HYANH3JxjEWewr/Ab8mbFLXagZ4CIuGxSt6TVjM=;
	b=DrcVgQdRcTfl5fFtLi7/jF3iCjF1R0fHHRzD6CP3itOiXlwTgA/LcF9ylImzK0dR5U54f2
	WWA2z++oSfU41m3memVwe1iHE0YN2BNfG6NUQxs8YErnq92dm84c2V8eOd1QqVg14b3LZv
	Qwr1H45leCzMUSoOvMoeQkGJwCOq2BY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794616765;
	b=bclf4Pe1M5/tQprU4qC+FDvyR/AXEStMcCgFeu5HZp+Wrc6McWH/92HzS8ojB8NueIPhP7
	EJ7PRO9KS2NAFR2HzLn21nENQ1VDHK9mqJNGkrcN3uKrD4XVP8a/HKI3QuzJk6GHuZDzs6
	b806PwW6/V+zfzSDSZXjBjE/Ycpv1dw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZXJ2vJR;
	spf=pass (imf10.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07EC9612C6;
	Sat, 14 Nov 2026 00:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0B51F000C4;
	Sat, 14 Nov 2026 00:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794616763;
	bh=TR03HYANH3JxjEWewr/Ab8mbFLXagZ4CIuGxSt6TVjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZXJ2vJRLbnEG/8DsfpS1WuvlhpDqKP5Ad7yHWSwzESZK0n3LldVDoj2CztwVoCBh
	 WTyP444vnzXJIHBKOWers+5ZvvFHF0FcSQqh1ztHVQEnRDIYzGQ7Fsld0tRoOkG+md
	 qMjOIFLT9TK9QF3l3iksNJzcJp1Vcv7aCWz13sEtAz2rq6sqNqdCrHH4YAPoOQDDX/
	 V/liyDsiVNmhpiNwMmSQjiHF+gNZ+/mPG2yZwcEyUbOYevaxMdRiUuSG15wINfKhFc
	 KcK+hIAcFVniTfpSyuSxGJFzfwl9hM1tMKtU8cX6G7+1T7DKRhIXJEwi0gI0gCSYQN
	 8uBXHdzKeJP3A==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: 4ncienth@gmail.com,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	corbet@lwn.net,
	david@kernel.org,
	jannh@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rdunlap@infradead.org,
	rppt@kernel.org,
	sashal@kernel.org,
	shakeel.butt@linux.dev,
	stable@vger.kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 7.3 463/507] mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
Date: Sat, 14 Nov 2026 01:39:12 +0100
Message-ID: <20261114003912.82206-1-ojeda@kernel.org>
In-Reply-To: <20261113153812.408825269@linuxfoundation.org>
References: <20261113153812.408825269@linuxfoundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F10B6C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8efztp6mwu15318redo55g1zf97oanc6
X-Rspam-User: 
X-HE-Tag: 1794616764-149950
X-HE-Meta: U2FsdGVkX19iuWc0U1KYH54H93H6ZVv5G8KgoRm+OEoSN8S6h7ISypKc3XxPKqiEkEi1AWzdnq96JI3cmjbYUDNXx7LqXxHXTnD+WnypRI+pV5ZjUL8URfjADpesWLuUp1cO2sX3NgvqorPOhfpOTD2nzijnaUIi5dARwpGx9c0TOrNAfz0/NMGKyqrbyWdj/3UCrMOT7zVNLVIJc3dQT6Sq0R7VJGVgj/uS6rCuEkntuTI5aB+bkCU68Xy1DVOIru/yJsoixZeLE4JZ16EoyQIYbhn/j7d/03l5xrgd2wubkbPzql+GetPcTWwxHJFokUyCqcUTXdBk31haN93jzZD3O7S1O1KsoTNEWDxrYkjZ12bb6CRgkDmmGZNSjftTPnZHVBz5oAVyBm61BoOWOGymi1WZul+PlIkQNOWYFVbKQpA+ivoEg6SwQCDeHcPGlN39FZg8GqdiseBL2xUQuweMsDpWkjDwR+//wcJUQjOL/fY8+Lw+gSgd/r3vE6jERD3O5mEUirJGQ7VSei6wNnJf3dBotljF2KSAFWoiBncQIwNKn8TUoPvAdSNdiMz2PjqoU/wwbBE+nzQtNUQJCLZ3bz3st7J/gk3ndtJIStH1ykoOQh0dexd/WI2foIZc34hsGrhZecwW3GRLnGTg9T8Jnahi8bd2ePTv/X4s2WRjJEadQoAK61FCxSh081/JhRQQKPld4arCB6Ackm3N3bZLnlWjKsprfKYzDDDZp72MPUZosBmAGBz1PBxGLvpUekv25OSoZ8SRzpWckU/2Qn94PWOEr6FOxI2NChXactPdK3aq4fxGLCpgFvSmJrTaCYHd9V1s3shsLUJ2fwQ+5mGqxCRMBrXf0sR3rwo2SNXVpkKbpUxk2r+Fo5vx/ZtbKC86QkK2OdCVF+ex8Eqit9LmYMUK17Nl0ZwkuF290HsND+kv6pF5IaSoL5oR90nZS1u7MOVIlzcehqxGlrF
 WJP4MnSe
 VuUQZyhZQ2UkW7g/EC37cOJTqdE5iztyTZdIp/vCVfdfAXzTqho6e3EcVK4h+F6BWCy7WblCWaXU2y+qPx8fjv8ixaPehM8PHrwiBrtR5Kj7nFIOxX2k+0R1dmYz+4A8xOSDdGYqlpYDaR9hBfjD7qNOYtnPs35wVl5iQk/MI78SVwcfR0PF7eXOTVM+gCn8PK1cuNfLIlVPZD81Bn/xele7iGiapCiC1AtP/iQlHuskbsbwyrg+bQtLnGpzGsrgRwoM+wWNvybqXUYNa8yPBdt6QJM9k0kJJJ9oOv4ryXK9WjgWlsq6aBh0zuIbyXs93j6ahEaP+Sidikujz/WR1MrnA1KPRiyUvYvyP+a4abbcFSIUTua4z2cqHNjpx7665Pwho/iuDVoLoh2/qTl8COx2/2SVysyt3nu3I/i2lzLrrSup6vkr507zFL1qpz8HnLpqwTkNIpQsTUP/5NOQwZ10vysjVNnE2rb02s3ENqQTcmsOYku9+As0U6tmQ/QjbZ+/mAPoa0oldsSRtkpm24IWNDPXmd3aDfAg4BPFOCte65UIFKQE1E0ShkA1QoJFxydacNiUPjRjGH1dO8nvo2y0Lc/j8EFlxHlj5IlV0Z01TVqEj/3hpfA0wmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 10:52:47 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> @@ -589,6 +593,16 @@ static inline void vma_end_write_all(struct mm_struct *mm)
>  {
>  	mmap_assert_write_locked(mm);
>  	mm_lock_seqcount_end(mm);
> +
> +	/*
> +	 * VMA seqcounts are not updated on unlock, so once the mm seqcount has
> +	 * wrapped, any VMA still carrying a sequence number from before the
> +	 * wrap would satisfy __is_vma_write_locked() when that number comes
> +	 * round again, and readers would not be excluded. Reset every VMA's
> +	 * seqcount so that no stale value survives the wrap.
> +	 */
> +	if (unlikely(!mm->mm_lock_seq.sequence))
> +		__mm_reset_vma_seqcounts(mm);
>  }

In a UM ~defconfig build with LLVM:

    In file included from arch/um/kernel/asm-offsets.c:8:
    In file included from ./include/linux/audit.h:13:
    In file included from ./include/linux/ptrace.h:10:
    In file included from ./include/linux/pid_namespace.h:7:
    In file included from ./include/linux/mm.h:18:
    ./include/linux/mmap_lock.h:604:20: error: no member named 'mm_lock_seq' in 'struct mm_struct'
      604 |         if (unlikely(!mm->mm_lock_seq.sequence))
          |                       ~~  ^
    ./include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
       77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
          |

That exists only under `CONFIG_PER_VMA_LOCK` (commit 47e725702b0b ("mm:
make per-VMA locks available universally") from Dave's series was not
backported).

I hope this helps!

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org

Cc: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>

Cheers,
Miguel

