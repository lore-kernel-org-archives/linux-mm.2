Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B0D7CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE176B008A; Wed, 20 May 2026 02:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D382A6B008C; Wed, 20 May 2026 02:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF676B0092; Wed, 20 May 2026 02:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A84E76B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:23:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 596701C00AD
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:23:50 +0000 (UTC)
X-FDA: 84786807420.20.E9DB08E
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 65F41C0007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:23:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bLeJCKXY;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1suTFoH1EtOKjY9tGXkwvOUanGUsdAx5moIqDv9CmZQ=;
	b=2aUDPnseILGHZT4OyusiZkCVyLrjNBkROlDhi3i3s5EYrmJTvzh5pmP8kfeNni1pmYMm0f
	hTS+I85vlEgx6ZNWH5vKLOO2IZzfRJQkYv8E9eb16znsdFJwWCiRvwsEmjI2NAwyO+WKLl
	QEtLRb46qSCz5oxdPQKH7UTQBingZ14=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bLeJCKXY;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258228; a=rsa-sha256;
	cv=none;
	b=wOxDauAyYdutIIwnLN+rcezdaBW1AKRxM6f5CqXYFZdZjR4/Yt05b62G8WTJHSrRmcmkj+
	xwtjk3uceRPlI3jYAN2N6sXt/6CAGauS1tAX/ceTwkD5AXrYRvHXHCKp2jsEhqws7fCTId
	IKWszH2P2IFlmNJ1RAdXJWPAI3s0ff4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2baca4df358so25388495ad.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 23:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779258227; x=1779863027; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1suTFoH1EtOKjY9tGXkwvOUanGUsdAx5moIqDv9CmZQ=;
        b=bLeJCKXYSOywpXS+JNG+VkSkxGsqJ9j2VLf9vLFopJfJ3jjO7y+ESzRsX4evhzRRi2
         h3liuxMCDasUzab2FaxiRPrkS7Zv3JrLEZUs1yKvA28Kz4iKP8PhPTIvtBElsRzrj6Hs
         wF/lSg0OsUV1VJ+JCPJsq/O9Oh7XiOnQW6KL26WAh1HmIRj20YaXEuI3RBvwtK8EfmFG
         POkuV12Ko0RKC66rKBgvfJmozaZS6ODO+FK1Uv3gpg2zpXquqP+MxBhKynP0ZD70/4UP
         cXKzxTw16Bchdix1G6B5GbB++AGuvnqjHyqS1eDpPKp+/g++RwrjZOIjETTXVtxPIdW3
         FDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779258227; x=1779863027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1suTFoH1EtOKjY9tGXkwvOUanGUsdAx5moIqDv9CmZQ=;
        b=oUxF5WXGIPt+XdKC0wyk3wIPEFkYUqKkvcpDTg2tLdm0mf3y0lbm31LEbi+/XCg0YI
         084tBAKw1+2sUH7LZWDW+R12RLKH66fMcBQ52UWf5GXYkMP9i/iheH8B8c+WQBlVo06B
         x6vQ3BELDAAaCjBEM9Q+hFJI2jJ5xFD+BxH/YFVSJdhtxrknpnOj3U3PaI98/BGw1aXV
         ts3715KlYKgT9gnw4VkNUHb9hWAqTbJOOK9teqo4HoC51EksdjxWcvb1wAhRh1F62XIb
         r4LYnr/cin793pimDHUzccMAe9/woTSdnMdGm3MaEY+brDIbMLO82Ay4SivC/ErfxbLJ
         WGWQ==
X-Forwarded-Encrypted: i=1; AFNElJ/+X2dXhxmCvyJGGntR3XYj6bmY+vM1XKYGax08e6ZLPET6zoK0P17l5cWnugkFQ/1EK9WoetpITA==@kvack.org
X-Gm-Message-State: AOJu0YyCUvaZB/vQqs5j1/NtuXmiJ9nIa2mnv5LcQn9Q5Dm5Smh+lq3E
	16DFM+Kiw8EB2gfa3or4aZuFWf2cnnZA0RTde/K3iuEdV9fzmaHyf5j8
X-Gm-Gg: Acq92OHwEXhyqe62qGFBqinLcj/Ov8bp5+uVdiux+otUTwX6J6J3XFpyN/ismvbX6zj
	3eZpFbaSub9ye6YbuaDmDvDblHHySsvMYONeI0mCtBBVYJtsrVjL54JON9Z12L6+EdO9TXd+qtN
	GUuWYZiSKL4qIbStGzf5lhsnION0X2SUJWEVYnyeUvhA/4Xk7xJsjSG13qu765ar0aX1rJUQNa0
	7wYBcGprVQ9JiALGQINR7upCGR4zY4kemPT79jGSeSmNBMGXGp7Mv5qwUEilbjDVVC6TaliKW39
	xIYCV2T8YkaWn7qUr/QWXx+UjyPEZ8UDEUU2jzieUqizuDOId3A3OYCc4B7iJoXlTGmMhjyypOE
	YNzQ9Maq7QfTjTY8tjk4T6FQfW1LcS7U2C4NVvBRz5AhuTKRs+7qN/G6Ed3AZM5wR+LacQabKct
	G3C2gVqWbDAIAjQUC8Gc/ZLys9dnD1m30XdCS3ay5gt1dkbU8wroeJ31UujFbaK0ArdvIp
X-Received: by 2002:a17:903:37ce:b0:2bd:a403:1d82 with SMTP id d9443c01a7336-2bda4031ef2mr184057385ad.21.1779258226945;
        Tue, 19 May 2026 23:23:46 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5fb35sm204241485ad.12.2026.05.19.23.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 23:23:46 -0700 (PDT)
Date: Wed, 20 May 2026 14:23:41 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Kairui Song <kasong@tencent.com>, 
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 323/362] mm/memcontrol-v1.c:651:31: error:
 implicit declaration of function 'swp_cluster_offset'
Message-ID: <ag0mdxBWcrZ8hxPP@KASONG-MC4>
References: <202605200624.e9eMvkBW-lkp@intel.com>
 <20260519152620.b7b5fd2d68d635ec8d34ad2c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519152620.b7b5fd2d68d635ec8d34ad2c@linux-foundation.org>
X-Stat-Signature: hmegystzjgb5bto5sjokfk7qjtnwbjba
X-Rspamd-Queue-Id: 65F41C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779258228-733168
X-HE-Meta: U2FsdGVkX1+g+nJ8x0ifF3rfwWYlGTfsFpEzEQ7JMdqXKNF6I9pXAtfzvZGclPsKaJ6DkWCo3+3JYeqtm/nVr1tnGcb7Q36vcKQQGKBuqKUFlAq5W2xwGxTdbYbxO9qFHUlmRujQak/v+r4TiN3Zuryj8jnXcRL0GiLFRAsdFLZn20zIOZMVQHrpUIjssX6lK/q0ovp7dED29U0ipUpriZKDufknLXLHGL+n1h0rEQ+/sLlMxwLgswegcvYL0lWyhKf5AE8LkIR/Z6wc8JV2n+3NgnoY2v1SXbpFHCgKGpppy8P0SGqxW7ZxhJteJekrCqJGXN0IBOVCvkgx7oWSihaVa9UH1uWguFFMJNpoXBMnorfxm1UbQt5dAl/RUMs45dt6H0jkPlaCPoT66sRQVcadBCHM/ul4rtIOz0q0YbR6vAmBHoi9d0ayKZBo77WvEdKhOPeDUDIZjYMId6oYaRowIvVjqiIAP5Mnj3pPDxM3+tK5jFb1IoDZuVQQbaxZ4s9uxm/YaKyyzqJt4spa/KuiwbH/whaizybNEmgr0c1GRZeJe6z7P5dQPaZGefx8Nq4BDiKqWHqNVFHZCRoaMSGFn7xbOJ4t+fqjugQA0qcF0zcShswR5uY/9NwSP5GgSRnI1E2Oald2Jue2k9lcPNOYpxBxBjfWE1V3u0PbPkQ7Lhz+RuQ15LrBQPFNOq9Bf97AiWT3UmYwiW6fPQlYyX7nLg2mmg3WELh6fc5cGGONbYVDpNTzgLhsRnZ1KaFHYS5GKfaaBJynD7yhdbYrHPsklvQACPFxU7yG73+SgSvXjS2xXYtAxZjXfsxOl7S/09xVJFKAUWGsz/aVa8os+R7jbGXLfpgJZA7+sdoHqEaGweAPJXFf56brvahAZRATqjaJ/jOzhmcHfAmEBzLS37AmWvLGJGFTBYR/NnIaxTyG0GAJcLC2RXZoHXzvKCT1kGYXFx4sgiKJadMrBoN
 +9pAkI7F
 hMqjI7YuXoNjarx+nzp3IOgaxsNajvtAMOSUR2r0AWVFb/UkSXqLXzDqvnQKi3ibYzWb5e5ohQsoa8kH0rSEvRYa2e1ZRM5Uiv8nEbuWZdeuwgopC1Qd5bdxcqy7K1ArwCZJLZgoMKQ9qUfEGd3b9z/YZxXgVguJ+GYMQZD5s+n7ypI+DDHPpY+M24OP3DWX/5CHKW8sXby8fUINWeZus5ve22GiCN2kYsuclz12IYvD12pCUvkBbWh358000LucA0y20/WT9zAmTff0BdkRmWp46DGtZ9VEF4p3fSSJia7py/7tfSg7P2h+fbu7CWdSFb2JrYbWLcSwZ6da9bo+FZQ2gH6JZPf8QNZR/T4tIzeU7OLa5Y+8dvWgeVXMMJue5OzsHiPJZtPpU84R8H0KLuq0sJ2dtCskAfcy2cJ3IdoM8qzVjETwlQg+gqpskRaUXS1S/65dzx+8qxV9muOiK8jDh9V+PZ0xtT2SeydczNFfayp9lZ2boG1XnhEj553EI9SpDWpyNABr2Isnrq3NFigAPJ1vTseXVqXq0GLFBX4bCTVuoqciURFpsHvo4Ps8xCuiOl1s1KqTMDjAjwg1yMkneENVX09PT2/kQ3WxhI4RQ0jBBouyXIr2wADz4qsBLGQiWerUiPeQPX6QViEJ0DigWbPv9Iw/OGBN1cH2Us1yAtvl+9RAkpGoaCmLB4XHaG88/quXDVaW5jbjnrT0RD5VMjK6HOblYrhlp2sVIqHbrNmpmqsEpwVJTvSegDs5J+Pqcc2XvOKB4AlNzpfRbLH7ABA2q+bPHdMpc1YEGQialMTkH7rU/Z3p8XWHb6ZPNRslucesDD6NKFKsrai8g5Ws78+KytB9DEISiMg15hk58Z88tm5CL92PAwdtrA1nqJ+rtpL2F3gpSsB8MLAVhd1EQJq8jjBtnLSe/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 03:26:20PM +0800, Andrew Morton wrote:
> On Wed, 20 May 2026 06:16:25 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   ac33089a65a951edf4365b1ff7fbe5b5e8062d06
> > commit: dc1675a14ba774891fdf5212b7bedc7f50661862 [323/362] mm/memcg, swap: store cgroup id in cluster table directly
> > config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/config)
> > compiler: sh4-linux-gcc (GCC) 15.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605200624.e9eMvkBW-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    mm/memcontrol-v1.c: In function '__memcg1_swapout':
> > >> mm/memcontrol-v1.c:651:31: error: implicit declaration of function 'swp_cluster_offset' [-Wimplicit-function-declaration]
> >      651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
> >          |                               ^~~~~~~~~~~~~~~~~~
> 
> Thanks.  I added the below to fix the build, but I've no reason to
> believe that it's correct.
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
> Date: Tue May 19 03:23:38 PM PDT 2026
> 
> "fix" CONFIG_SWAP=n build
> 
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Youngjun Park <youngjun.park@lge.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/swap.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/mm/swap.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
> +++ a/mm/swap.h
> @@ -482,5 +482,11 @@ static inline int swap_zeromap_batch(swp
>  {
>  	return 0;
>  }
> +
> +static inline unsigned int swp_cluster_offset(swp_entry_t entry)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_SWAP */
>  #endif /* _MM_SWAP_H */
> _
> 

Thanks for the fix, this is not wrong at the moment, memcg1's swap code
is dead code with !CONFIG_SWAP so filling anything there is fine.

I didn't notice that memcg1 won't filter out the swap code when
!CONFIG_SWAP. So following patch should be better:

Just eliminate the dead code. It should be put before this series,
there will be a minor conflict in memcontrol.h as a few declarations
are moved by this, but should be easy to solve. I can send a rebased
version of this series if the conflict is too trouble some to solve,
or we can clean this up later and just keep this dummy swp_cluster_offset
for now.

From 55dd3196e47f3d148edb01f2a37057e6af4bcdaf Mon Sep 17 00:00:00 2001
From: Kairui Song <kasong@tencent.com>
Date: Wed, 20 May 2026 11:14:13 +0800
Subject: [PATCH] mm/memcg: v1: guard swap helpers under CONFIG_SWAP

These helpers are essentially dead weight when CONFIG_SWAP is disabled,
so just guard them with the right ifdef, we will have a smaller vmlinux:

./scripts/bloat-o-meter mm/memcontrol-v1.o.old mm/memcontrol-v1.o
add/remove: 0/3 grow/shrink: 0/0 up/down: 0/-473 (-473)
Function                                     old     new   delta
__UNIQUE_ID_addressable___SCK__preempt_schedule_53       8       -      -8
memcg1_swapin                                 12       -     -12
memcg1_swapout                               453       -    -453
Total: Before=17932, After=17459, chg -2.64%

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 11 ++++++-----
 mm/memcontrol-v1.c         |  2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b..1e02f0afecb6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1899,9 +1899,6 @@ static inline void mem_cgroup_exit_user_fault(void)
 	current->in_user_fault = 0;
 }
 
-void memcg1_swapout(struct folio *folio, swp_entry_t entry);
-void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages);
-
 #else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -1928,7 +1925,12 @@ static inline void mem_cgroup_enter_user_fault(void)
 static inline void mem_cgroup_exit_user_fault(void)
 {
 }
+#endif /* CONFIG_MEMCG_V1 */
 
+#if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG_V1)
+void memcg1_swapout(struct folio *folio, swp_entry_t entry);
+void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages);
+#else
 static inline void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 {
 }
@@ -1936,7 +1938,6 @@ static inline void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 static inline void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 {
 }
-
-#endif /* CONFIG_MEMCG_V1 */
+#endif
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 433bba9dfe71..8fb02dc5b259 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -603,6 +603,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_SWAP
 /**
  * memcg1_swapout - transfer a memsw charge to swap
  * @folio: folio whose memsw charge to transfer
@@ -704,6 +705,7 @@ void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 		mem_cgroup_uncharge_swap(entry, nr_pages);
 	}
 }
+#endif /* CONFIG_SWAP */
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid)
-- 
2.54.0

