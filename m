Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32084C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1213A6B007B; Mon, 27 Jul 2026 05:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3086B0088; Mon, 27 Jul 2026 05:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF8B6B008A; Mon, 27 Jul 2026 05:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2E3A6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:15:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5863B4069C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:15:10 +0000 (UTC)
X-FDA: 85033997580.14.6D2E62C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0CBB24000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:15:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XH4COWUi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bdm02+CD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gT14ov0W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=59Y51aLI;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785143708;
	b=kLXId5SycRN7+RfC2maNKVU3e78cIXtktYOcvvU95oW3gqRZmbv7sELGEca6UWHT26ZzoW
	DrcF5Szr+uDvmemyBTcamZJksfFkop2MzU1VwM0vkK9ayel4hZgg+gxy9kf3QHNAtt+IPu
	AXndiZJSilZTUt4R6n27GaaVnvFe6V8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XH4COWUi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bdm02+CD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gT14ov0W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=59Y51aLI;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785143708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nofef/k2ghi2COUtOHG8Fiu5zrxha6Onv0LZX52ftP4=;
	b=ngPtrNAXB8QMbFRssMrugGu3Ke5g4Cd4k+PBFjg5uGEVY1X6E7PJMKv4jph+VlKUGPRbYU
	5AAV2cTwepEIZKITqQA/3IG4wG09TYHXZdskY/zNODIXTklJOvpAsrLIB1ZnqnQlZXFfui
	1h0w0ux3683abPHOsMiuyzWBA8zcFCA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 214317DA77;
	Mon, 27 Jul 2026 09:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785143702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nofef/k2ghi2COUtOHG8Fiu5zrxha6Onv0LZX52ftP4=;
	b=XH4COWUi/uVSTTItRb/nUmfm8hm6XLb+2ccrA+RSH9hDCrCENsMx7DdG1OWFISHT6yiJar
	na1H2WcWdnbTJhAmma6fHG2fZdoBEv0sNydB8Z028wX4I5FNCCSh+4CvoK0zBQnxUDz5sv
	fK0AfBjzu45udqdKvJg4xwhvU+eyHcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785143702;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nofef/k2ghi2COUtOHG8Fiu5zrxha6Onv0LZX52ftP4=;
	b=bdm02+CDJ05kV++dhJds+LNeKzhLGoPjHgz72E0kyd3TFAyzK2ZG2IlQFCaDm8PiZrpNT2
	rCtsIQeQl1/lYUDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785143698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nofef/k2ghi2COUtOHG8Fiu5zrxha6Onv0LZX52ftP4=;
	b=gT14ov0WCez/rIUxEy8m1tADx6vn9TvWYnVIlGDTGvvTkjqgKfNlsTpWeYmj3zns/HRrah
	yetFtSmLwPTMVM2yAdcVmh9IB0etgC+Ko7dJ0vjckI/njniugxrFqPUNdwhmH9agXU+RvH
	Vv24fXObUNvrvroqv5eY8mBjjk6l63M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785143698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nofef/k2ghi2COUtOHG8Fiu5zrxha6Onv0LZX52ftP4=;
	b=59Y51aLI6YcXix+Z2oMApRzqEq+GdCAi5lSa72SMl9lcyKfcsYff4UnevNIIfGg1Xje3eG
	/vP8AY5Z6JDlUaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A492779B9;
	Mon, 27 Jul 2026 09:14:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Gy7HOo8hZ2r9DwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 27 Jul 2026 09:14:55 +0000
Date: Mon, 27 Jul 2026 10:14:54 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Helge Deller <deller@kernel.org>
Cc: John David Anglin <dave.anglin@bell.net>, 
	Usama Arif <usama.arif@linux.dev>, Helge Deller <deller@gmx.de>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
Message-ID: <amchbBH5zF7Rq5LT@pedro-suse>
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
 <amNzLXuwflIZFKtI@casper.infradead.org>
 <253f7ac0-205b-42f1-9fb5-d19eceb581b6@linux.dev>
 <amOEUZlp1BxYh6_t@pedro-suse>
 <fd239383-dcbe-4daf-b337-32facef07076@linux.dev>
 <3e9dece8-4e86-4ce5-bd74-b3ec305f3003@gmx.de>
 <4606e13f-6827-45d0-b3b8-6bc26358f7ae@bell.net>
 <amT0j_bBT3CCxPcg@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amT0j_bBT3CCxPcg@p100>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0CBB24000C
X-Stat-Signature: 99fx4c9imbojaywa74jb7fsaq9858mwk
X-Rspam-User: 
X-HE-Tag: 1785143707-560269
X-HE-Meta: U2FsdGVkX1/KqIK4Y3ptfyBKrCPVArDsexlr3MuNvGGqy2Nd0bYwzNUpN29hY5djKHF6ScVuTB1fW5Umm3YJuTnKMSMD0qzYrZCSyHBGLq6Z7UVzGj6CKBs0kCScB+kpF7W1SD3oYGonV+YBgTELjOwCIjK+5rozFmlZGSwULCXLayuTXpoAOsJm/t4ZoazOHTlZ3tqadCQPgpdIMyK8J6MKD87OUgN+6TpJSzsqgmn5xy8WTo6reYzaSBrte84VPNy5Fz9zzctINg0bpXkzZu/cfwGR4iaEmsXrNY/qp4w36TT8K4Payjb6V7EJWpoJEVN7tLAsVW1YTewzUeQuizDUfMMbHfRs4KoRrgh2YjZjgXFMpVHbKQg4FZE0g4kZXxSA+lBMI+i9j3H5Ayr9V1fiX0eb1vJxOHK5anzGR2YoUmSkv6AwtMoSDTgbssdHKvP+Nv7E685r/wfhR/VQzRRxt1i07nCK9gvuainkJKrPs+NyM4CLHHa6UsOadIaVvRZk0e9Ev4yys7nnMl08ZA3tiajoku7aah93ExCtK9Bm91B5lWQdFm4yZkw14tQQKuDnWaNOwHFZGS1smhX6DV4IimoAb/inJ5CpcloPo0BX970Vrn9bvWWDKpZ7+l8uPm1U8ahxd8J+KKPreNY6CbyAgU7m5ou58ra75vd2ZQ6RfRcQUmnIcybj+/sioWcbHwcGllRBHAsn0tVFDCXgnDHBVW3eihc6CHajeJYVwGF15M2b6rngVxE2nYFSgqj542JvxuL4qEpn8GL3kuAly8VPnoPxc/Um3RfeIdvY9UK1oMAzNhNtLMz2uO6xd0iGHKwhRPnopeWogUfzjKFvJoaJgdM+ZQgIQ5FOtjGWa1EswxFgMGXfIKW9QKM5MNtagkReS+ap9mXTx4CsVe5pmSgzNcfGUg/rF3y7xpfce7R8+xKkVfXvCMHwlBWcL19Ye/z4Ah1zetkcROvf9ZE
 jV7WKWDG
 5bnZQTeU5ta1rw48cO7AekwVuZAJpz62fz7+GbsNuameJhpdy5N031wiQox6Tl/hT50rQZi2TcaAGDw36hkdhEFR1cuksYoyZMraqNDFU4BXmM+ac4JoO4wOONKKndc3wVtrtxMOiqglVEQ4H+Wv5tf8FjF+ny3L/OA69yZVp0c9WrhLRNrduULICgm4xXkBsTEtLMdNyNvCdNk/NWnL5B0VjFJ1cyquSgejWPpAIWE3qAI6iFxu5Lp5dUcAXLu6O/C1w4LzvxbEutvsIsoApmEuSbPIeokh+Q1rMKBV++3yCONSUQIbzbaOdXJmz/P7cN14uGOtinpmbd+sUtUzmVTCLQIFJGRT/2ITrqz+9RgOtc7KXeikdvegKT1+hczQBCpNHdKnJyLKWYmEUE+dE+l6BfnWjmQGHcrollR22iYCRJ143uajtSwUC59gW8pVXOMGL+kCdvxHKCRYR84WolCZnPU8HuyFgDAUETkXX1+MiRlPe9XhA8WBknG3mjaA9hfaZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 07:38:23PM +0200, Helge Deller wrote:
> * John David Anglin <dave.anglin@bell.net>:
> > On 2026-07-25 12:27 p.m., Helge Deller wrote:
> > > On 7/24/26 17:48, Usama Arif wrote:
> > >>
> > >>
> > >> On 24/07/2026 16:32, Pedro Falcato wrote:
> > >>> On Fri, Jul 24, 2026 at 04:03:44PM +0100, Usama Arif wrote:
> > >>>>
> > >>>>
> > >>>> On 24/07/2026 15:14, Matthew Wilcox wrote:
> > >>>>> On Fri, Jul 24, 2026 at 02:36:59PM +0100, Usama Arif wrote:
> > >>>>>>
> > >>>>>>
> > >>>>>> On 24/07/2026 11:20, Pedro Falcato wrote:
> > >>>>>>> ptep_get() does not need write access to the PTE.
> > >>>>>>>
> > >>>>>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > >>>>>>> ---
> > >>>>>>>   arch/parisc/include/asm/pgtable.h | 2 +-
> > >>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
> > >>>>>>>
> > >>>>>> hmm I think you might break build bisectibility if
> > >>>>>> you separate out the patches, you should squash patch 3 and 4,
> > >>>>>> with patch 1.
> > >>>>>
> > >>>>> I don't see how this breaks bisectability.  Can you elaborate on what
> > >>>>> you think would break?
> > >>>>
> > >>>> Patch 1 does:
> > >>>>
> > >>>> -static inline pte_t ptep_get_lockless(pte_t *ptep)
> > >>>> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
> > >>>>   {
> > >>>>       return ptep_get(ptep);
> > >>>>   }
> > >>>>
> > >>>>
> > >>>> ptep_get() takes a non-const arg till patch 3 for example for parsic.
> > >>>> I don't think you can pass a const variable to non const function arg?
> > >>>>
> > >>>> So parsic won't compile in patch 1 and 2, powerprc wont compile
> > >>>> for patches 1, 2 and 3..
> > >>>
> > >>> Aha, yes, nice catch! I'll have to rethink that. Maybe squashing the patches
> > >>> would be the cleanest way forward.
> > >>>
> > >>
> > >> Yes, squashing is the simplest way forward.
> > >>
> > >>> FWIW, the vast majority of architectures aren't doing funny things on
> > >>> ptep_get(). E.g PA-RISC, loongarch only define these so they can use it in
> > >>> their own asm/pgtable.h. I'd really like to delete these but I can't tell
> > >>> if they are *actually* required.
> > >>>
> > >>
> > >> Ah maybe there is something in git history on why it was needed?
> > >>
> > >> If not, hopefully someone from the arch lists could clarify..
> > > I tried to remove ptep_get() and ptep_test_and_clear_young() from
> > > arch/parisc/include/asm/pgtable.h, but this then triggers compile errors:
> > > 
> > >  CC      arch/parisc/kernel/asm-offsets.s
> > > In file included from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/mm.h:31,
> > >                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pid_namespace.h:7,
> > >                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/ptrace.h:10,
> > >                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/arch/parisc/kernel/asm-offsets.c:21:
> > > /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pgtable.h: In function ‘clear_young_dirty_ptes’:
> > > /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pgtable.h:683:25: error: implicit declaration of function ‘ptep_test_and_clear_young’;
> > > did you mean ‘pmdp_test_and_clear_young’? [-Wimplicit-function-declaration]
> > >   683 |                         ptep_test_and_clear_young(vma, addr, ptep);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> > >       |                         pmdp_test_and_clear_young
> > > 
> > > So, I think the answer is, that the local copy of ptep_get() is used in the parisc implementation of
> > > ptep_test_and_clear_young() function.
> > > 
> > > Switching to the default include/linux/pgtable.h seems not easy doable....
> > 
> > Did you remove define for __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG in parisc version of pgtable.h?
> 
> Indeed, I missed to remove that.
> 
> Usama, if you want you can add the patch below to your patch set, thus
> simplifying your series?

It's actually my series but thanks Helge I'll pick it up!

> 
> Helge
> 
> ------
> 
> From: Helge Deller <deller@gmx.de>
> Date: Sat, 25 Jul 2026 19:19:55 +0200
> Subject: [PATCH] parisc: Drop own implementations for ptep_get() and
>  ptep_test_and_clear_young()
> 
> Switch to the generic implementations, which are identical.
> 
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Suggested-by: John David Anglin <dave.anglin@bell.net>
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
> diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
> index 467b8547ac8b..d92dee9fef3f 100644
> --- a/arch/parisc/include/asm/pgtable.h
> +++ b/arch/parisc/include/asm/pgtable.h
> @@ -432,25 +432,6 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>  	return pte;
>  }
>  
> -static inline pte_t ptep_get(pte_t *ptep)
> -{
> -	return READ_ONCE(*ptep);
> -}
> -#define ptep_get ptep_get
> -
> -static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> -		unsigned long addr, pte_t *ptep)
> -{
> -	pte_t pte;
> -
> -	pte = ptep_get(ptep);
> -	if (!pte_young(pte)) {
> -		return false;
> -	}
> -	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
> -	return true;
> -}
> -
>  bool ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
>  pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
>  
> @@ -491,7 +472,6 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
>  #define HAVE_ARCH_UNMAPPED_AREA
>  #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
>  
> -#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>  #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>  #define __HAVE_ARCH_PTEP_CLEAR_FLUSH
>  #define __HAVE_ARCH_PTEP_SET_WRPROTECT

-- 
Pedro

