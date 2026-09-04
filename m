Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B79C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184966B008C; Fri,  4 Sep 2026 13:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B8B6B0092; Fri,  4 Sep 2026 13:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098E36B0095; Fri,  4 Sep 2026 13:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D509D6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:14:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F60380154
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:14:33 +0000 (UTC)
X-FDA: 85176728826.20.774199E
Received: from outbound.st.icloud.com (st-2006d-snip4-2.eps.apple.com [57.103.76.143])
	by imf21.hostedemail.com (Postfix) with ESMTP id 446661C000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:14:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Nvk14w0C;
	spf=pass (imf21.hostedemail.com: domain of bfguo@icloud.com designates 57.103.76.143 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788542071;
	b=6gYFsaq4ID2PP4sG3g/Pj5tyjsuV7DdjnVUo/ZqXaRkQZ+z2QomnKtJZcK44eMyXmdv2j6
	jUCf11hV0+ECCXM9LtftlF10naA06MWUXK6zNn+1KIMKevXQyXxjXwkTMi+vXO80N3lNtU
	DiCZw8pxZlVVoZJuXpynSeT3/NaFPZQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Nvk14w0C;
	spf=pass (imf21.hostedemail.com: domain of bfguo@icloud.com designates 57.103.76.143 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788542071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PUjns3T+p/kPui4QPMIUQkm8bxeLcpKz5BN+CLKbhk=;
	b=z9IYZdkE/h/6J2Qglo/d6v6xOmESaLGADs/Vt7GinAmY9TtwPS4kkQ5IZ3pJRI0VC9Q+cm
	OYyRaiqKxhA7CP03H8CpuGjmFHk3aM+b/F7Dd260N5PpVy2IqmdTo8OcNRQpw2XqHZhdT8
	D6x7sNR5NXdjSq32JYJPxXTkMjgBkTo=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-8 (Postfix) with ESMTPS id A913918001E7;
	Fri, 04 Sep 2026 17:14:24 +0000 (UTC)
X-ICL-RepId: 01a06d6a-17b8-7a68-ada1-712180f6f38f
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAV0XA1ccVkVcGEMJXQVXHB0eQ0VbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtASGBLVQ9oMXwUcyJrH3cpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788542070; x=1791134070; bh=3PUjns3T+p/kPui4QPMIUQkm8bxeLcpKz5BN+CLKbhk=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=Nvk14w0C+eqLgxeJsNZc5d6EbYHz/zNgykmIaeHIGbym3fwCI5wqoFcTcPVast29Ev/y3nM6A5dP48IqEhA/ri+CHa5PaKhOQFH656NZHGK+Tb+XQxJo9rb2aNZGyHTacmdMLnD/y8ZDbYGi4XlzYL3m9VtARP2HwYAkTY9griHnPGlCXrKdZ5H4IH1jLtOoMFouh0LnRNbRDurdHayuGZo7ZOhPUYtqAEO+PAcvMncksR+Zn2PR40VjSwJQy17Y5kQv5OR63MyjyiUo2ACJpSeFwcb2alu3Db783nniSjkplaj/CCXaSaAXhd3fJ93+U5JOHVkAF6aUXXc2Lwj9Rg==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-8 (Postfix) with ESMTPSA id 8B93318001CF;
	Fri, 04 Sep 2026 17:14:17 +0000 (UTC)
Date: Sat, 5 Sep 2026 01:14:11 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: bingfangguo@tencent.com, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memcg: clear folio memcg after changing per memcg
 stats
Message-ID: <apr8Y3fb_ZNdJZXr@BINGFANGGUO-MC0>
References: <20260902-memcg-swapcache-stats-fix-v3-1-795f5d455f7b@tencent.com>
 <CAMgjq7BNk004x_zQM3k4QuCLmqMx0BVvd4HLxHq5+XvZ0fTk2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BNk004x_zQM3k4QuCLmqMx0BVvd4HLxHq5+XvZ0fTk2Q@mail.gmail.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDE1NyBTYWx0ZWRfX8KJhLY/XYNm8
 KVgE+6yqZ82TCqBx3HEMQ8nLljrTMWviaRMC+NrwGVBAv7tYvk5RXVmOnYNHovEHn7gai62u5Dh
 P+wrQw82yC2neCKtFtmoP7Z143jZW1rZ90qNVMpt+wd6Y1AzwUYBno3lsrH9YTYeccraT/QhyiA
 Mr7xYO7GmRT2J86KbLqLdvxlprZS4OdXzbByTp57Ki/ae829ezGZXozKvOKaFFaM96WICDHmL+j
 ShQlaKkWp3D39qLNVnmacJgX1JjnlEZDiEgp/UsDNMeMB4hZVsA88MKEz0IyFyIo65xjLdPtRZK
 qqH7rix9LN/uerMvGMU19b3KVYaVjLPqpZBCQ/bMnPGMaOdDMVbBf681DjdlEc=
X-Authority-Info-Out: v=2.4 cv=dorWylg4 c=1 sm=1 tr=0 ts=6a9afc73
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=GvQkQWPkAAAA:8 a=63lRpd9jxPUBlUCG1FUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: AoQW78-Djq_M_fGKO5SCjzuqySa_Yud-
X-Proofpoint-ORIG-GUID: AoQW78-Djq_M_fGKO5SCjzuqySa_Yud-
X-JNJ: AAAAAAABRHED1L5dBQ4HEu/bug8yg6PIzAZSBuaZH7zY4mi9le0sMftYg+WAhyJhSG6Us3ZNdSywY6+YjgrYwMnvqJ/DCpVneNPBYnWR/R5czNVQg3WWgN38Tqux5xD0MS7RQfF3wx7jJeDYRwJfjICit4Eym0nx9aUW3BqEUUkS4r4XmN2wIYX00Q5vs+xPa/ZtH3UeE1zdae2+eUoRmCM0HTI6TUYm5Ebg2FNs0tWJ+OJQI6fd7Kwc764RY2NtF/PCEcN/MTGE3FcqQAfUGTKGdzkCy2uSAQBBSAG7XXHTzPdE7tiLGz0C/ojTFmTkYv/YyYPw/x2DsC68SnD7M6A7VXgi24bHLmEw5qx2lwZJrtFi3a/23C+fJIQfYhYy1jD063sEgQuRKZPJQKVojVyIbKGoPJMCLlTxrnKjbJf1pQQakCHPs7Ddu5UKXMEc9o+KA7JYWQuGpUEXOaCBlsvjaRJFUquy0XDl3ShGcZAdk3SdNJw5QNONAQkfh8hFRQqrifuB+1ZLam6K7qrvND5s0jB6Lt31rWrzo6cW/pIHJQArxtR/nmUwcZX2wnVH8jUYdzOQHgBXyVi2mdb8jcKSPAPwwDWSmaXLuOk/j+ZNyDP/7OgcwAeCU1IerQNQPdQy2xEuFcgDiFaIha+IXCpAo07TkQwxaT/IYJK7pd/yeb4Jv57gMTQ7rB2Tex5CXte+zQCKXNorkddTjEBMx3+Fxa2JvnPwi4L2XDjams2OH92C+yGjnjcaMaor7TJIOS595ag6qJAGlsGP2XPfSFu4+dHXJZOdkFjwHsHFqYABOUjMi5p0bPzlZiduO5Pxmcd4JivmhwvKQ15JoEKi1gJ7YDGODqDkLavN3KcBbcHxvtiVT3TnT5WSfoDvf1lU844M7cMIO9SG/57Sj1C4TLoQyJgPeCiWW/WshuW0USRkdjJn1QoJXrqhUm9DmnUFHQlk+beIW+mIDHEcu99nfw7
 mPT2z5OL
 vd6nVisrKeH+lVGHJJ7Han1hEMBLfq6beQSm0TGW0TU5Q5DBbI3CrfbuLQGFTBiOj4a61nCcDU7MFvD7evwpaH1GsJEcRUQvEcG3qcdLoqka7bnjvxTtcdrO+wV5n//CdidB13vVcERkmmOOOUSmuxevkWE2l5qlx7PKH4iW+uVZnSgtyCSKlfiSyv4XUOWnG7kwfVV6LHWI0NuGSk2qbRuMsuHENdDoi0mnwXFQ41hF2V4Uis1BjD298VwMu24VrzRxHIV2lhQxvD65q2H2PrWT2RACh38F55zukK39/noZPftU/EEfTBefnaLX3wgKsgFx5QfamrsKUrLwxYz7Z/Uh3FXok1npPktBRfI6ldDcPRHL3e/1Ec0fv4WRl8RGqsMaxnWtqcuSHChPOhjjB1rbdfyff8NATRhfI60G/+79Eig6f/OjZ/6OcyEMepqK7bh/f/F93ynVOW5gVzDshK5AVoi/26j84GolFE6bQ
X-Rspam-User: 
X-Stat-Signature: 887snconhymx1m7gohayxhbhdeoh64jp
X-Rspamd-Queue-Id: 446661C000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1788542071-383020
X-HE-Meta: U2FsdGVkX19FE0TasG0kQTcFbTpp1KVBhK8gKUBgYz04I+1SulXBFaZnAF1vWv6pP1AiNUmWRlORE1kUaw4+asBgr4cLP31/3pnlGKACV7nyx4y7T5Gwi9zlTDm4hJx5roeMtB/+ybPi2yyBLUTLe5NrNKmjPkCGcLOg/wr/WGKIR7+gw2OuEBcSLcmiwgBwqgqvjLqOo6MpFj6Ipk7qhFtDADWz+6WE6SlzoFbO1uXFle8q55+4ofxGhz+DycY07RTIvZ7HfwjqQlrPFSoqtK4aRq/4INnKd0zqU//oRl5fQlKn8rNHlTq2Z6lKzQFn/4eP/NNqPEIJpqeAS1N/5DFNNWV/p7T/qGEaa+Z2tsHP4Yqo3IqGQ/aemCG0u2DJ8sRNF52sfX3vUWnbWfM5B4lIV8DIRC7kfR06xBDP4eXjD45l40d8zg3spwSqkgQN5Abf0Nh2A+YgMR69tqL505MBrpb6KlZGxolFeT2ePL0SsTxX01HoVUhY9XzTU+v8vm19fpyQDeBMMk6Fr5yNhfw9BJxSKee1LHmQQ5nirzTZtLx+iFAqvjUJUQdZeJ4I6WSTuqwip+PjKjwaNbl4BUc3rAuMMZ6/LMVWtsNH7HuEaAMzKio7ORZin4mdk+XFW/Hy16fDJgfdHHIcRfbhYbDwrOPtOMGH1lvt7F8QRq04kji8gG+tvsC876w2oIpFr6SH1sZOmiHil6okRLFdxWjoQqypGt7st2Dca3FGwP4+QsKM+0aAQszh2B2rmEGI05Xad1yS8Hm0fx73OxBh7YJub/RTZXNeIf16yCfV/F+vwodVVUTPrI+f78r5m1/d7AMnE4xMDV9SLUVikIqCqRigG2EGKAByZlHEZAsgDg/I1pSwfdDaZI6jVMCOe2k+f8M69DzjRFT892lJKaKAI+vsS7EQk5meTAJhONxtNfU7Zjm6CQZmUVGzNBTcPpgPPCmOb1ubv58lFVZPiQ2
 rRq6KBlb
 NwUSVeo97+tvkcgOWIowwY5pOh5TFqOha/lct3e7Gqn6WX+Ujh0R2qg+IDNY7QNoAbzXCgSHKUD5g5oomhwjcHydZATNbbAZlGyqpPb92sYAjjLfrwv7O5XCuJCL1oFBoUL2tVHmcjSZeFWFs61QoUkpHqtftM0I89R9KzXz6xHtau0iXiM4eF8CXOBCiPvL2E6FxipHdYUnQpDnUzS070BkYJWIDUWB4JgJBsWEZ3jdY78U7hhkItYrqwVWwpPvwKdnT/C9TxD7QmbKxUnEI7re/3cYtWIY1jKgVbRrnWVJjkpSU1yo0hHHnkeDU+dmHXP7SFb+z335iEG2GS6mdgvZcyjyWuz4my3HvOHsiMN5EhUTMCDTneJX76XDsrmpjJt002j+CWTaajzMrPGfYEF5qZzw/HinccNbIETLScAo3jRhH7qSYEr94xjV8c/lmoE8he4eMP0d2SZGmRTp4ysKvmcXBH6tEbP9ufa0mA9EIJZHA7pgUB7Yh2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 08:42:05PM +0800, Kairui Song wrote:
> On Wed, Sep 2, 2026 at 10:07 AM Bingfang Guo via B4 Relay
> <devnull+bingfangguo.tencent.com@kernel.org> wrote:
> >
> > From: Bingfang Guo <bingfangguo@tencent.com>
> >
> > I notice extremely high swapcached count in the per memcg level
> > memory.stat when running tests with cgroupv1 setup by swapping pages in
> > and out.  It seems that the counter never gets decreased so the value is
> > rather useless and confusing to users reading it. So I think fixing it
> > so that the value can reflect the actual swapcache usage correctly could
> > be helpful.
> 
> Thanks! Good catch, I missed the V1 case.
> 

Hi, Kairui. Thanks for your reviewing!

> > __memcg1_swapout() transfers the memsw charge of a folio to its swap
> > entry and clears folio->memcg_data as part of that.  In the vmscan
> > swapout path it runs before __swap_cache_del_folio(), which then
> > decrements the swapcache stats through lruvec_stat_mod_folio().  Since
> > folio->memcg_data has already been cleared, folio_memcg() returns NULL
> > and the NR_SWAPCACHE decrement only updates the node-level counter
> > instead of the memcg's lruvec, leaking the per-memcg swapcache count.
> >
> > Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
> > the NR_FILE_PAGES and NR_SWAPCACHE updates but before
> > __swap_cache_do_del_folio() removes the folio from the swap cache.  This
> > keeps the stats attributed to the folio's memcg while still recording
> > the swap cgroup with a valid folio->swap.  Add a swapout parameter so
> > the plain swap_cache_del_folio() path is left unchanged.
> >
> > Fixes: b197d41462c20 ("mm/memcg, swap: store cgroup id in cluster table directly")
> 
> Is this the right Fixes? I think the problem could be introduced by
> 2732acda82c9?
> 

You are right... I'll update it in the next version.

> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> > The problem is reproducible using the following script and program:
> >
> > ```
> > #!/bin/bash
> > set -e
> >
> > CG=/sys/fs/cgroup/memory/swapcache-leak-test
> > SIZE=$((256 * 1024 * 1024))   # 256 MiB of anon memory
> >
> > [ "$(id -u)" -eq 0 ] || { echo "must run as root"; exit 1; }
> > grep -q . /proc/swaps <<<"$(tail -n +2 /proc/swaps)" || { echo "no swap active; run: swapon <dev>"; exit 1; }
> >
> > cleanup() { rmdir "$CG" 2>/dev/null || true; }
> > trap cleanup EXIT
> >
> > cc -O2 swapout.c -o swapout
> >
> > mkdir -p "$CG"
> > echo "+memory" > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || true
> >
> > echo "== before reclaim =="
> > grep -E '^(swapcached|anon) ' "$CG/memory.stat"
> >
> > # Put ourselves in the cgroup, allocate & touch anon memory, then wait to be reclaimed.
> > (
> >         echo $BASHPID > "$CG/cgroup.procs"
> >         # Allocate and dirty SIZE bytes of anonymous memory.
> >         ./swapout
> > ) &
> > WORKER=$!
> > sleep 2
> >
> > echo "== after reclaim (swap cache should drain to ~0) =="
> > grep -E '^(swapcached|anon) ' "$CG/memory.stat"
> >
> > SWAPCACHED=$(awk '/^swapcached /{print $2}' "$CG/memory.stat")
> > echo
> > if [ "$SWAPCACHED" -gt $((1024 * 1024)) ]; then
> >         echo "LEAK DETECTED: swapcached = $SWAPCACHED bytes (expected ~0)  [BUGGY kernel]"
> >         RC=1
> > else
> >         echo "OK: swapcached = $SWAPCACHED bytes  [FIXED kernel]"
> >         RC=0
> > fi
> >
> > kill "$WORKER" 2>/dev/null || true
> > wait "$WORKER" 2>/dev/null || true
> > exit $RC
> > ```
> >
> > swapout.c:
> > ```
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <unistd.h>
> > #include <sys/mman.h>
> >
> > int main(int argc, char **argv)
> > {
> >         size_t mib = (argc > 1) ? strtoul(argv[1], NULL, 10) : 256;
> >         size_t size = mib * 1024UL * 1024UL;
> >         long page = sysconf(_SC_PAGESIZE);
> >         char *buf;
> >         size_t i;
> >
> >         buf = mmap(NULL, size, PROT_READ | PROT_WRITE,
> >                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> >         if (buf == MAP_FAILED) {
> >                 perror("mmap");
> >                 return 1;
> >         }
> >
> >         /* Fault in and dirty every page so it becomes reclaimable anon. */
> >         for (i = 0; i < size; i += page)
> >                 buf[i] = 1;
> >
> >         printf("allocated and dirtied %zu MiB, paging out...\n", mib);
> >
> >         /* Force the whole range out to swap. */
> >         if (madvise(buf, size, MADV_PAGEOUT)) {
> >                 perror("madvise(MADV_PAGEOUT)");
> >                 return 1;
> >         }
> >
> >         /* Give reclaim a moment, then stay alive so the cgroup can be inspected. */
> >         printf("paged out; sleeping so memory.stat can be read. pid=%d\n", getpid());
> >         sleep(30);
> >
> >         munmap(buf, size);
> >         return 0;
> > }
> > ```
> >
> > Test result:
> >
> > before:
> > ```
> > == before reclaim ==
> > swapcached 0
> > allocated and dirtied 256 MiB, paging out...
> > paged out; sleeping so memory.stat can be read. pid=4778
> > == after reclaim (swap cache should drain to ~0) ==
> > swapcached 268435456
> >
> > LEAK DETECTED: swapcached = 268435456 bytes (expected ~0)  [BUGGY kernel]
> > ```
> >
> > after the patch:
> > ```
> > == before reclaim ==
> > swapcached 0
> > allocated and dirtied 256 MiB, paging out...
> > paged out; sleeping so memory.stat can be read. pid=2601
> > == after reclaim (swap cache should drain to ~0) ==
> > swapcached 0
> >
> > OK: swapcached = 0 bytes  [FIXED kernel]
> > ```
> 
> Nice, the reproducer is under "---" so won't be included in the commit
> message but anyone can find it on lore.
> 
> > ---
> > Changes in v3:
> > - Add doc for the new parameter.
> > - Link to v2: https://lore.kernel.org/r/20260901-memcg-swapcache-stats-fix-v2-1-9caad330459b@tencent.com
> >
> > Changes in v2:
> > - Update the commit message to describe the problem in the beginnning.
> > - Change function declaration for !CONFIG_SWAP as well.
> > - Link to v1: https://lore.kernel.org/r/20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com
> > ---
> >  mm/swap.h       |  6 ++++--
> >  mm/swap_state.c | 11 ++++++++---
> >  mm/vmscan.c     |  3 +--
> >  3 files changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 0b5d507739bcb..b3b54c28929a1 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -319,7 +319,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
> >  void __swap_cache_add_folio(struct swap_cluster_info *ci,
> >                             struct folio *folio, swp_entry_t entry);
> >  void __swap_cache_del_folio(struct swap_cluster_info *ci,
> > -                           struct folio *folio, swp_entry_t entry, void *shadow);
> > +                           struct folio *folio, swp_entry_t entry, void *shadow,
> > +                           bool swapout);
> >  void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> >                                 struct folio *old, struct folio *new);
> >
> > @@ -452,7 +453,8 @@ static inline void swap_cache_del_folio(struct folio *folio)
> >  }
> >
> >  static inline void __swap_cache_del_folio(struct swap_cluster_info *ci,
> > -               struct folio *folio, swp_entry_t entry, void *shadow)
> > +               struct folio *folio, swp_entry_t entry, void *shadow,
> > +               bool swapout)
> >  {
> >  }
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 305877e1f4d7b..99985208b529b 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -306,6 +306,7 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
> >   * @folio: The folio.
> >   * @entry: The first swap entry that the folio corresponds to.
> >   * @shadow: shadow value to be filled in the swap cache.
> > + * @swapout: whether this operation swaps out the folio.
> >   *
> >   * Removes a folio from the swap cache and fills a shadow in place.
> >   * This won't put the folio's refcount. The caller has to do that.
> > @@ -314,13 +315,17 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
> >   * using the index of @entry, and lock the cluster that holds the entries.
> >   */
> 
> Perhaps the Context: part of kdoc could briefly mention that for
> "swapout = true" case, the folio should be a reclaiming one?

Of course, that will be better! I think I can do this:

---
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 049635247964..9c37a0f5f049 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -313,6 +313,7 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
  *
  * Context: Caller must ensure the folio is locked and in the swap cache
  * using the index of @entry, and lock the cluster that holds the entries.
+ * @swapout should be set if the folio is being reclaimed.
  */
 void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
                            swp_entry_t entry, void *shadow, bool swapout)

