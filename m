Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E91CA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 03:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8F590020A; Thu, 14 Aug 2025 23:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2793D8E0002; Thu, 14 Aug 2025 23:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140CA90020A; Thu, 14 Aug 2025 23:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF9F38E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:27:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FCAEC0852
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:27:05 +0000 (UTC)
X-FDA: 83777555610.27.091BAD6
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id BD88C160008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:27:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LYt1k+dO;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755228423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4clEhlACsA0tDdg/T9dMN1cKs24lEi4PWd19tCjEwc=;
	b=JBXUaEoyihaTZR9EWBhNEemb5hWMhhxUzGNvgfOwIINJQgYXcj86mhD/0tZCD75Enun873
	Fvtc8FHFXiu2t+72bsfBQ5R8pJKOZu8iKHIUcsQ0Njeu+0H2vhT8EFMLSBqdw+qOnKEqK/
	rsXJL3if8YuF9ccNMhwR58gdkVgLGOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755228423; a=rsa-sha256;
	cv=none;
	b=Y7Y+cmSYTgo54Q2RnY00Lbcy4OAOEuuM8GljPoURkXIIR72hz4Gz/m13wruIJcXgeoQLDJ
	y1+rWX1ODvtqVYUFAMiuoZ//+MdTnUMjf39keTdscy9Tg81sLtifIAmq8DekqzPRJ6z3xs
	1dSmUKLGr4AD0Jux4Sri4ob6jfwWRSo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LYt1k+dO;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e2eb9ae80so1442414b3a.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755228422; x=1755833222; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i4clEhlACsA0tDdg/T9dMN1cKs24lEi4PWd19tCjEwc=;
        b=LYt1k+dOIBYq06qXOfMapEhvRkQNpo+xtsGS1nXK8z0smKsRJXYLIlxgJu99qk5/UA
         74S3rphZhWGdGAcscY3LQsN4Ej/QGXk8P2xaU5nKuxc6pd4sY/ItRJXO3zm5FqIqNacR
         dhiZmNbN0uFuYDvVZ2o66CnQ+bHBINRMAXwGH26/alUFQqR0TK1nR4TZOejh9l43KEX6
         0MNptGBHMdzb49HSa0aQoFoVi+8Z7DYNJpV8+38YYKh4S+XuzemATyoLgGlnnoLORy6d
         PmGBwAkyGhAqO+he29ogHAELuWCoZO1iXhE1ffQWcsR2ZR8yIdqgeUHULeb7T0tAYZ4s
         JrFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755228422; x=1755833222;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i4clEhlACsA0tDdg/T9dMN1cKs24lEi4PWd19tCjEwc=;
        b=hOxuI7bURHP5ktoB7zQ7cKnNHHhal4Q1nlo0oC4OGu2PjxqBC6tOmqabWsSI9yPXVo
         nmSN9A+igAO0prNH0utI6c200kBV6xY78nX6SVZUWScm7s2Dl5f1zKCxmrzil67ILCFQ
         c0lVlvQf815Wgjkdzo8jXBJb7+KCcD6NzcdD1AQ7QA/PIK5bZyMosGtX0cKuEuARTKKl
         pCq593m2IsXNJ45df20tDR9OIjNc8Ixci9mEskJZlVgtPBgiiGjKhELiDsQwhTcP+KgX
         dJ//+C1Bb9mSZccsAi3Gd81FlyUse+oiKs4dU69FlHMgB4JXs6JXLjmywRfU7tBAA3O9
         OpIA==
X-Forwarded-Encrypted: i=1; AJvYcCUabIUCxhVe4KvtapKbwA7zYIaeKS8ij73my8+h+lKkxvDL0aE/v0Od9qfSdQg4DHbtFs7xeneHCQ==@kvack.org
X-Gm-Message-State: AOJu0YxkuGolbHSAaTz0yh5gufPNOFAa96AchJTKg4gpv+21fuqA1e1g
	0fkKMNhd8EyPn1i+JnI2yOtcWin33DvGNOPR83oQ0wsMt4im9aMHsmJZ
X-Gm-Gg: ASbGnctl1VLHP9XX4oqlPcZ9X2HoebA3EfGap3CUOvYHHodxqReyGbKWjtKnhxeir3i
	fU7unnhN6ziTw6cUVlfa5vFW/p0FJ9OQUiKAbVeiYNFgnZEHbWsVpdE58YpIrt8jFshXRwVe8Za
	7sHZKUMN5N4+QnBglmFxuTTIyF7FsJvt9Cw5bGBOR1E4UvE3mjbrRhAOvy12a8qK6FeYGnaxjiR
	P9I5c4r9rZJe/n4jR3i3HRe3Qs85DL67PfUenu0dLdeSFkpeWRfvY9RsThOLxau429RYAViqbpt
	e5VZk6wcv4l6Lt9xx/1Mp5anIZEOm6Y8TDTXxNlXY0SDYS04N9PjzdgHDRuYDD8SDk61T9nY8dh
	IUM4m2dVzW3U=
X-Google-Smtp-Source: AGHT+IEWmNmS0mZB+sG7vmnApcWmG90xfM+LSnDAqr9fergPICvDpFzevhiBxYKw6Ow5a6S6XPe5Qw==
X-Received: by 2002:a05:6a00:1793:b0:76b:e561:9e1b with SMTP id d2e1a72fcca58-76e446c8803mr593207b3a.1.1755228422508;
        Thu, 14 Aug 2025 20:27:02 -0700 (PDT)
Received: from smtpclient.apple ([2402:1f00:8001:567::104])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e4528c28csm153092b3a.29.2025.08.14.20.26.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Aug 2025 20:27:02 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v4 2/5] selftests/mm: mark all functions static in
 split_huge_page_test.c
From: wang lian <lianux.mm@gmail.com>
In-Reply-To: <20250815023915.1394655-3-ziy@nvidia.com>
Date: Fri, 15 Aug 2025 11:26:43 +0800
Cc: Wei Yang <richard.weiyang@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>,
 linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <219CDAAB-2571-4F47-815C-96A41F8D4410@gmail.com>
References: <20250815023915.1394655-1-ziy@nvidia.com>
 <20250815023915.1394655-3-ziy@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD88C160008
X-Stat-Signature: a3a3z8xsm4kreypajibxmixk68ekydeu
X-HE-Tag: 1755228423-28880
X-HE-Meta: U2FsdGVkX193AfQc/wSFY12Pze1vGOQGcbY41G8+Wb2YFwQHTCXdwpQLxvNfB29RL8jD3ZLHlu53h4LoKPzfPsfvbfNCPgd3eXXWs/eEcFAhvuv6UrBiHf9UP0xuXPxCvgJ/zDqDpvru6e/4SlmQKbog10U3pX1sEXAKQsvNBZPZTBQOO+CeXS32gSEbnjCbu8gAYhTcNlaVVsM+H6D+6Hr7t9cgiLhQjvg61oJ8178S4Sq2Q1ibViZxCu/q5PVul5qx7j86xgK4GiYOo7OHht+DvIPqxg9zfZgroi10lswrm10f9SbRrbwwJwswcaJlFpX9vZWLyL2KxZMUrcz3Y+/aT6aiKXngfx5VPp7aBi7ysLv0US3b52hwDUPl29cHPOK/Qz6alQX1jFz5uQBnpond9/nAUg0JEJMXXHJ9vtP5LaAKJZMRG17Smf35fw1fgeirNRIK6aeQ9PZaTsKMMNHAc2rXP6AOTpJZvnNSlLqVUmhF2urCEgSxCew72CFAoWK4BXe4OspWUvKpbrwt5zPHyYVKZyWNnLG5ZrK3h9qXj4eJUv+64wAQ9ps5MUUsOuQs5KUUvKeFMbXkb9u85/tWi/kV5MFgt7wxy1yB4LDhZiA+kcHjxpAVDzM7zgADNGfhcTCVhL/nctDPK29R6R2FdlY3q2TaI9UtzV9h3k8CP0xMKtrgdY/ZBLT5SZkvNg0d2bBda8U/dcUY4NghV8+1Xvc6Sc4MIgeqE8/fGDx5pmoR+h5fndTK96ICl2Yxx8L96w3OODyxGrKD9IxXUhS69ScKYG3jhwEhHhubt1hjo58I1df7j9UC+NOzv0ArXLwEBArK8pi5ocyswkZb2+srzGyoQk/NsP5+qOKez59ShM6lGAD0nLwwm95imWgl+oD0m8eMhB77J3pfEjOMElAV5nviKpVmSK3FYzObLKkq3qOobfWP2WZ7p6A/X36Su1ZF8t7ZOPD+vL+RYFS
 dKKtEJTV
 TEe69YA0V5jI5qh3ecz+oL9I/AiepY3UfU4QsgnFhbAkJECkOqos0rOd2bYFzS2xfCvIImu1Ta8J6bVmWIzFrC/djRHAOuTWmMiRi6Kkgr9sO/p969fkgp9GZsRkmy9m+Fj/Oiuit+uSxzLfa4qncRB4XmwP1ND5o4T1oLM61eF0d5IUVFsc315w5WQ5mlHGBNy4kh4FuBQdoSnhc7PS8XsLrxSA3FqCJ16jtmacWr89aZ4tKK/w4+OwyKQayCn3p6KtfX6VwfMGTdcekBi0nWXQdLlVZvrsQJElz5uVoBMBTxIppza1rLysFVyi1hI3HeQH7Q6ldVI1KiWI9zs8wwFtjcC43lwsJ5v0SgL9cWosbmtS+hGHDihRSPQdNjVMuei4+AMqutPxizcUSzfNRBrcXGg+qSvwcY8a4j+Xxejx2qhkBiI4X35N3o6bYGYlNJ2RcEYNeoLX+jwHqeZhQOQOtg1vVi1235K9ngP2mSPAaH6XdKwiLVXUBd2E72TpEzgdiAlOugI+wVzXytu3zMwqi3j47a71r/zliOINZ1ULrgnqND1V4UEAOdW0T6lqiW4wKP8dm1aafAGmaKNiG3PAdLh3oaVLVhX4YDZOVhhjcRrKopvyPyw9yJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 15, 2025, at 10:39, Zi Yan <ziy@nvidia.com> wrote:
>=20
> All functions are only used within the file.
>=20
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> .../selftests/mm/split_huge_page_test.c       | 22 +++++++++----------
> 1 file changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c =
b/tools/testing/selftests/mm/split_huge_page_test.c
> index 5d07b0b89226..89d3dc08fe4c 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -38,7 +38,7 @@ uint64_t pmd_pagesize;
> #define KPF_THP      (1UL<<22)
> #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>=20
> -int is_backed_by_thp(char *vaddr, int pagemap_file, int =
kpageflags_file)
> +static int is_backed_by_thp(char *vaddr, int pagemap_file, int =
kpageflags_file)
> {
> 	uint64_t paddr;
> 	uint64_t page_flags;
> @@ -136,7 +136,7 @@ static void =
verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
> 		       rss_anon_before, rss_anon_after);
> }
>=20
> -void split_pmd_zero_pages(void)
> +static void split_pmd_zero_pages(void)
> {
> 	char *one_page;
> 	int nr_hpages =3D 4;
> @@ -148,7 +148,7 @@ void split_pmd_zero_pages(void)
> 	free(one_page);
> }
>=20
> -void split_pmd_thp_to_order(int order)
> +static void split_pmd_thp_to_order(int order)
> {
> 	char *one_page;
> 	size_t len =3D 4 * pmd_pagesize;
> @@ -182,7 +182,7 @@ void split_pmd_thp_to_order(int order)
> 	free(one_page);
> }
>=20
> -void split_pte_mapped_thp(void)
> +static void split_pte_mapped_thp(void)
> {
> 	char *one_page, *pte_mapped, *pte_mapped2;
> 	size_t len =3D 4 * pmd_pagesize;
> @@ -265,7 +265,7 @@ void split_pte_mapped_thp(void)
> 	close(kpageflags_fd);
> }
>=20
> -void split_file_backed_thp(int order)
> +static void split_file_backed_thp(int order)
> {
> 	int status;
> 	int fd;
> @@ -365,7 +365,7 @@ void split_file_backed_thp(int order)
> 	ksft_exit_fail_msg("Error occurred\n");
> }
>=20
> -bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
> +static bool prepare_thp_fs(const char *xfs_path, char =
*thp_fs_template,
> 		const char **thp_fs_loc)
> {
> 	if (xfs_path) {
> @@ -381,7 +381,7 @@ bool prepare_thp_fs(const char *xfs_path, char =
*thp_fs_template,
> 	return true;
> }
>=20
> -void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
> +static void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
> {
> 	int status;
>=20
> @@ -394,8 +394,8 @@ void cleanup_thp_fs(const char *thp_fs_loc, bool =
created_tmp)
> 				   strerror(errno));
> }
>=20
> -int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, =
int *fd,
> -		char **addr)
> +static int create_pagecache_thp_and_fd(const char *testfile, size_t =
fd_size,
> +		int *fd, char **addr)
> {
> 	size_t i;
> 	unsigned char buf[1024];
> @@ -461,8 +461,8 @@ int create_pagecache_thp_and_fd(const char =
*testfile, size_t fd_size, int *fd,
> 	return -1;
> }
>=20
> -void split_thp_in_pagecache_to_order_at(size_t fd_size, const char =
*fs_loc,
> -		int order, int offset)
> +static void split_thp_in_pagecache_to_order_at(size_t fd_size,
> +		const char *fs_loc, int order, int offset)
> {
> 	int fd;
> 	char *addr;
> --=20
> 2.50.1

LGTM.
Reviewed-by: wang lian <lianux.mm@gmail.com>


