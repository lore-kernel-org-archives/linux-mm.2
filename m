Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16310606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=ZszjAgdC
Received: by kanga.kvack.org (Postfix)
	id 1BB6C6B05B3; Mon,  9 Nov 2026 14:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D266B05B4; Mon,  9 Nov 2026 14:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C4A6B05B5; Mon,  9 Nov 2026 14:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF8326B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:36:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD65E1401D9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:36:48 +0000 (UTC)
X-FDA: 85416588096.23.4455BB8
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 471AAA000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:36:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZszjAgdC;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794253006;
	b=1DrvE968iD23VlzC1JvXSQUokUWyCDEZqUef3Hy2d0nWS2Q6GH5N6xo+xAsLBVeVV6j6RV
	gQLAQSRGCaU+jwdIubQYW41c9++tOyQx7O+eG6RNUkrIQ4NfgIP71zBTsVLK+rMjnZScYf
	tqE5JFP3Px1TqJvamIcdJN2/+Ei0XR0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794253006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7b1DQocnv6+T5lOYkcaiSGK/dXpQFZSh9YUyP7VK80=;
	b=l/MX2Bgkpa3ue6aXuMOM5cH4TEZlms/jKd2r6QMFDQo/PT3J6TkCjhojyky7gHl0b7zPeA
	Nz/nxTjunnPiDrchErMHNiSFjkCxI5rIIYfOWnuNDO+yKRzIb57zfTLytkD/ciDJLZFCbI
	TiMQ535ZjAURQI6reB1EhdIjg4udCss=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZszjAgdC;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Message-ID:Subject:Cc:To
	:From:Date:MIME-Version:From:Reply-To;
	bh=Z7b1DQocnv6+T5lOYkcaiSGK/dXpQFZSh9YUyP7VK80=; t=1794253005; x=2109613005; 
	b=ZszjAgdC+S0J1zmq/ElE7KYBTX2AVJX7MQcdpa/vCD07UK/2M7362W7zKAWVGKR6obE2k5WxtoY
	ywp3XVQ20orkXFwLwPaU4reViZpKaShNCkYtDT1xd8YQ7YqaCGcPRxBPu5zFpZ+mleKl9y+sB43sg
	0nkIdVy7cNgUMR1JKiOdOLRGGJ1zVdgLjAgS5YotKwcZann718s1qmKks3ctZN6ZWPab9+SojUFtQ
	T69IrgPVqit7n0IY945mj10SvDxVChFEo0dLbfhkEJ3iWiv2VS/U58V/8c29gdTegVf368P8x1Qnt
	vcAzqLuYQV7THrKaRVq2ZciKuhHKhctEW33w==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xQVAJ-007cPZ-RP; Mon, 09 Nov 2026 20:36:27 +0100
Received: from webmail.service.igalia.com ([192.168.21.45])
	by mail.igalia.com with esmtp (Exim)
	id 1xQVAI-00000005GaE-3m2c;
	Mon, 09 Nov 2026 20:36:27 +0100
Received: from localhost ([127.0.0.1] helo=webmail.igalia.com)
	by webmail.service.igalia.com with esmtp (Exim 4.98.2)
	(envelope-from <mfo@igalia.com>)
	id 1xQVAI-0000000GRqV-37ef;
	Mon, 09 Nov 2026 20:36:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Mon, 09 Nov 2026 16:36:26 -0300
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Hamid Nassiby <hamid.nassiby@nokia.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, Ran Xiaokai <ran.xiaokai@zte.com.cn>,
 ranxiaokai627@163.com, Andrew Morton <akpm@linux-foundation.org>, Vlastimil
 Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Oscar Salvador
 <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 6.18.y] Revert "mm/page_owner: fix memory leak in
 page_owner_stack_fops->release()"
In-Reply-To: <20261109141527.2880867-1-hamid.nassiby@nokia.com>
References: <20261109141527.2880867-1-hamid.nassiby@nokia.com>
Message-ID: <267189c6da8e01cdb49415cd97c4edee@igalia.com>
X-Sender: mfo@igalia.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -48
X-Spam-Bar: ----
X-Rspamd-Score: -0.9
X-Rspamd-Action: no action
X-Rspamd-Bar: /
X-Rspamd-Queue-Id: 471AAA000B
X-Rspamd-Server: rspam12
X-Stat-Signature: hs81m7q4e79shnrbrywndzo8chb9qfsa
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794253006-372411
X-HE-Meta: U2FsdGVkX1/I5cLr4DaDQtrkmI7ipfRXxTmWqGP7yPcs+wuzVei4ihYdI7rHjzpQYQqymHshci8xQcYlJUrXFMXndqj8mae8hoTetnkWanwNtanTOqHTgYZbKUqXEqKz9DIxJhaIOUWw0DI6UWaf2lyM9pCOqFMnxy/5WxC4br/ptYkiwQ5yEplXhieDK033hxUI3GrMUS9+gBw2req0PcOx+TlVoTy+VzzioAmR9VE7nQd4cn07VWZfDvUmowNFrGf8FK96ZmuMEp4eFMWLyktEJNFY08gECG22ZmQUQ62GDNui22ITkaECz9tN947sZbPYDYYXJoMQ5GJJO40iGUfrJ+FREza1bhzxgMv63D6V0KovvxvvF5otdPp94vBQeWEmtaVSJrEbTEXQPc2okyT9FEeai8L405bdaEws6w3Q2aiFjUwyooFu8JIn5rAT8fTPVAkZaOuvo4Svq3V2JxozOiBnEhN8HW7an58el/tW/sLe3qzfM0suUYhKXqRFb0FvCqSfAOoUnxggN0I+zd0LvvHi/cgUqqhHS3z9TyL9N2utC5JZZ68AvYTi82QJioW4BGERqTCDfLZ43Io1W33UOwjIzNe1NpiyQTcsqq7VFNLFnF6ve8B2maOq5vq2o1VhEpBfGqVJi3cXtw1/j7RxITXwMH9kCl7Fy9XOClkOO8cdusjqo522bF3caw5PTDnzzoMB81o9zQN7t/ZA69KLEafYORYXMjBOG4YZKsLvVMivW6lkzZQ69O2zlPbO9rE5DdxD9Lw3pHWFkk8lTzn+HANQVcdr1Br3cSyF68hEtl8bommRmMPYrG1VGBI72YrX2Tqu57ZsSKvMnyRVBTW3aaXXOZ+2KmqBjMyghlN9MBp25IfUHnqtpGUpVJ4+lQE4szAVyNrv55RrCZ1D/dFFuWNAGxMRpeczyUoh2LEiWoci83iQTNCVpl4KQLLItI28KYwXhqzLDUv5rMJ
 xzWQDep2
 4D3lJywipesDoIWjaGaEYafc/6Zh7e1gt8RyDWvEBPGO7JN3R0J/LRI2ZgBEiBjKJgtMLfOVvjINJ1LMcdmJw68VavsrR4RIDXBE5C6t4ATgbZA97RLfFAlW1gWBPGKlUpferjvuAn/gEnNd7pq1JrX0Ti0TcWD87s1Dp9vd50f7yOeMQXy33ipaadarxWyw7GORppn32ArwKfyJ7GN4mX6wGFCjGKp4TMT2IenRedEP9i0lG1GfxB+YARVhZjKb6CQQI3hkktzb26Zyr4m7Erem12FVl3nrI8YJega3MflrcfIvM8XlfOHJ/gD4eHruGipQ9OfkOtETG35n7l0SvLPgtiCQdC2HG77F16Vw1YvDZ673VURe5bChvuZp5E07YvNv4fSg9JxgYMCS/efQxXcad4I0Nz33Gu+llYE9G7kartXTJ/mJetIAtkICkj1xPOF9jbDgg7JkEpn86fXsRlwOp7BSPAu0XCrbAMAlTsxCWMNs+hmm5PI/3RALQU16YGhTuB2jHmXhxyYET6Uyi1MboilfdaowmESzHFRkxaKdeTrfo3/Dyv8kPHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-09 11:15, Hamid Nassiby wrote:
> This reverts commit 05a8edf607be826738dfc620a17d9d98e8976762, which is
> commit a76a5ae2c6c6 upstream.

Thanks for handling this and submitting a fix.

Reviewed-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Tested-by: Mauricio Faria de Oliveira <mfo@igalia.com>

cheers,

>
> The upstream change is only correct on top of commit 156c0c5d1463
> ("mm/page_owner: introduce struct stack_print_ctx"), which first appeared
> in v6.19. That commit makes page_owner_stack_open() allocate a struct
> stack_print_ctx through seq_open_private() and moves the stack_list
> cursor into it, so ->release() must free it with seq_release_private().
> 6.18 does not have that commit: page_owner_stack_open() passes a size of 0
> to seq_open_private(), so there is nothing to leak, and
> stack_start()/stack_next() store the current struct stack node directly
> in m->private.
> 
> The upstream commit was backported because it is tagged for stable and
> carries a Fixes tag for 765973a09803 ("mm,page_owner: display all stacks
> and their count"), but the leak it fixes only exists since 156c0c5d1463.
> 
> seq_release_private() kfree()s m->private. Closing show_stacks before
> EOF therefore frees a struct stack node that is still linked in
> stack_list, and the next reader of show_stacks walks into freed memory.
> On v6.18.60 (x86_64 QEMU, KASAN, page_owner=on), a single 4 KiB read()
> and close() followed by a full read gives:
> 
>   BUG: KASAN: slab-use-after-free in stack_print+0x165/0x170
>   Read of size 8 at addr ff110000062adfc0 by task init/1
>   ...
>   Allocated by task 1:
>    __kasan_kmalloc+0x7f/0x90
>    __set_page_owner+0x4a5/0x720
>   ...
>   Freed by task 1:
>    kfree+0xf8/0x460
>    seq_release_private+0x58/0x110
>    full_proxy_release+0xa1/0x130
>    __fput+0x35c/0xac0
>    __x64_sys_close+0x79/0xd0
>   ...
>   The buggy address belongs to the object at ff110000062adfc0
>    which belongs to the cache kmalloc-16 of size 16
> 
> Without KASAN, the same bug panics arm64 hardware running a
> 6.12.108-based kernel ("head -12 show_stacks; cat show_stacks").
> 
> With this revert applied, the QEMU reproducer completes 20
> partial-read/full-read cycles without a KASAN report. mm/page_owner.c is
> unchanged between v6.18.60 and v6.18.62.
> 
> Backporting 156c0c5d1463 instead is not proposed: it prepares for the
> new show_handles and show_stacks_handles debugfs files rather than
> fixing anything, so reverting the backport is the minimal change for
> stable.
> 
> Link: https://lore.kernel.org/stable/20260106170556.173097317@linuxfoundation.org/
> Signed-off-by: Hamid Nassiby <hamid.nassiby@nokia.com>
> ---
> 
> Notes:
>     The analysis, the QEMU/KASAN reproducer and this changelog were
>     prepared with AI assistance. The arm64 crash was hit on our own
>     hardware; I reviewed the analysis and confirmed the fix there, with
>     repeated partial and full reads of show_stacks on the reverted kernel.
>     
>     The same backport is in 6.12.y as 7fbea59f737e; a separate
>     [PATCH 6.12.y] revert is sent alongside this one.
> 
>  mm/page_owner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index bc2676414..589ec37c9 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -936,7 +936,7 @@ static const struct file_operations page_owner_stack_operations = {
>  	.open		= page_owner_stack_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
> -	.release	= seq_release_private,
> +	.release	= seq_release,
>  };
>  
>  static int page_owner_threshold_get(void *data, u64 *val)
> 
> base-commit: c3f63d70f236bb7685e6d11d1d9b5b351552e600

-- 
Mauricio

