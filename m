Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCC2606A33E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q2oj78y3
Received: by kanga.kvack.org (Postfix)
	id BF5BF6B05B6; Wed, 28 Oct 2026 12:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD386B05B7; Wed, 28 Oct 2026 12:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6C06B05B8; Wed, 28 Oct 2026 12:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 879A36B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:54:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23A9914019D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:54:43 +0000 (UTC)
X-FDA: 85372634046.28.9CB3C7E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3BE21140008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:54:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q2oj78y3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793206481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3ystJhrkZfs4wDwVdxIpAnqZwF+5sjgEnOhfYS+4Ds=;
	b=yoZHz/ExSPpEZvuyQgM8p/YWK7zW6k3CV8eoMcuKzk8EKLBII0vxtWhX3ktiEngJ5mJEdH
	VCFjA/tjtvVKX5zivbS8ZY0oeii8smzRQa0PIx3n9zsT7OyiAq/sXxFgGaxO9GcM4uIZiH
	DtexXho3see/111PQCl5TEXkeLMXB4M=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q2oj78y3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793206481;
	b=1AhdJ2zJVwo4J9QyMDovjlpZY68OsZtKypqsXzd/msQgsnr446JvkBUNtliQo7PZuElHqW
	4GLJcT2/kvChP2+2ajGSAeyNblWLBlslLYRgi9MG/PfwR7O8aSH9yCTxggqCy4lfDnwRth
	HM6hdmVjZhCN3UNQfqyLedT7Oxsy7Bw=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so190648266b.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793206480; cv=none;
        d=google.com; s=arc-20260327;
        b=nexbT7jHAYzbbbwGI+2Wvvv5uZ0xzSCda7/gFBA/kN12Ft3Wh6PROnFaS7bxEMM+yf
         QOJxpltcMPeAxUK3GtjfLWADq/6xS3/QwIKCZN8++/qdlQTidLrpJntnF5LQSjmBBGaG
         2DjiAGYlXpaWufcysi2aiBet2pf6NqXduX+oFYkBPF8PUXI5UlE6wMqvQ05iWLPuVeRp
         2UVRJR1BvobCY4WYuVZWNieUeQunL4roEODJ1zmRskuB0cm8/ylLQdcmUBldvECyurXG
         AszVgz5kOWov3h6Cf1oOVDvF5cEHXs3rNLy3aC2LDscBy+nSEG6iD2snDXoCj3CS2VU7
         kbfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h3ystJhrkZfs4wDwVdxIpAnqZwF+5sjgEnOhfYS+4Ds=;
        fh=6KZEJvcpHNSOWPW9l6p+Sv+Dsxlhb9Jdq8KJRpMSujc=;
        b=XQf3Tkhiy7GyvTEwq7CVxtY0h5+otOuXygS/hee4OATDA9KX2c48QQah0mwXrixUhb
         VXnRwAOTkf82HI1GGIszQMMEnrwqpBlAiZi3f1u/AnLZYPxgdmmMz/o4z4vUb5Y5cQnN
         UltrzcrZFtA0Zn1O90lg2+QYwRBOqxJAeUmc9iuGj8Gwi/kx16Fs31EGfOhvXg8JatXC
         2ACWM7kiWmuRCzajAeS8YpI052zBIxB1p7L/bOOQb9NyikN+hRZd9ULP879Re250CDg/
         kIznsJW1gXDW5wAsl3MDjrdioWCrwvFETLhDAs9T2TCIKGAu58NuDme5yEV571HjelXS
         EvTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793206479; x=1793811279; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h3ystJhrkZfs4wDwVdxIpAnqZwF+5sjgEnOhfYS+4Ds=;
        b=Q2oj78y3Q8Q3PGDZOB0Nr/FgV9mFSz/WzFt2K6Mg/C3Q6WtbvXXH55n5KAd5TXYl6p
         E1nz7i6+X12G2iHxBlgK6sU6UUt6FuVmwTCfQT2EbJpbDdsB7Sl0Y1KCKFLLQA1EK4WU
         uP2Mrhxh0XOdE+joYFWPBZnE0t2NHcNJ+RUl2qLWsUxVFTkn2/C5zRYbgdDcoPGStf1H
         IRl8BHP88FpE4itBH4Dve9Jrg7dDc72jbDc2jQ/vO8bYISQWcS08Bk+p6vWc9npljho6
         WLgTqbQXwQnVfYrMJSfohCL11wP+VwB7ypZiKxOlf9agC6YmVnxx5KpSoQqH7+AvvfqP
         ai/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793206480; x=1793811280;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h3ystJhrkZfs4wDwVdxIpAnqZwF+5sjgEnOhfYS+4Ds=;
        b=AYaHr07Wbmc+M1th68FchUm2+8G8BxVHFcCqoP+NZ4CSRSECQNcA0BHGypx0utoi1G
         KEJbLqI0Wgc8cLRdtctR/SZsfhv1ozo7dCXMMUZK6tskJ5L/2/2NX6TvmH5cQgetbaB1
         yDOVkTQvAVIjRreCKH5s+B9Wla2YTfEyvA+3gCbKxCrNs7VVMkTrf3Gvoj5hBY0/AhvP
         YmvkjIqK6E3Q5zz5p0kJXTuyiSskU+MljX0VxDJGL1p5Ep6k+PSFJg4zZA08/Zdt1g+O
         pypFL9PSHHVosZj1CkdgZd5gbMwRpFT4jSD1eFGtehD1+RBaIPc2XaVvMLkNHlp4Y19G
         BgWw==
X-Forwarded-Encrypted: i=1; AKwUvBw3q4ephYqARvWm8N/NWDnDgdJSFK2FFddJ2Wsmr9dBwzOqaDr8GY/puxAGiCyRwNqf3VyYZMoZDA==@kvack.org
X-Gm-Message-State: AFq9FYKxtq9SHp75qMYVMQv7ttVHh8WtaXXmttjA5kRS2TCAA7xzIgZ2
	tHfUoPK459l0E4pkOUcw1YRyPpXBgd+b9+ni4TPf2oxueEdZI/ex+M0e/fYao1qMgNcCuBUWR+H
	HLmtpOIybLPFe0zSg6iut7/VGAPZM9s8=
X-Gm-Gg: AYBFou2gfgnxZbU96hFY6R0dSNqBmc58kkDYREXyqJnfe3Ma8C4OiIrW1ehkFsfcfmf
	xgFitniUFbHGRyX9oUW3ZR8i+oSQmrARorbpBA3bqgjpWcWdeObC7UU1cImZo2N9tP6WfeLtT8R
	PcW6M8DguFMAM6SWIUaDI5XvHXP7npb4z8/4D1d3UKzyUwu/2goJ3T4OV3XAzK7IEDtz8uuWEt5
	2Boh9RcHNVC1kdJcF1AhQDJo8Zzh2/C6IDNYVc3NhLuPfBhfkVh4FrE7aKjBIPh2ZljvANc/x2o
	l53TzZmLVRAHF4c6Mhoql8pZmpYBibOpxUL5Hsxi8iuL1nKIUc+TEssS5O1oGaP/ri8++/ekVZF
	5Q6Ir3J76S6ahmza7N8nM1j0XZUyuk8hknfdSRmwzowu1P2BD5q2SVWcCZEdYg/cvEke0Pg==
X-Received: by 2002:a17:906:f586:b0:c46:5973:2a1c with SMTP id
 a640c23a62f3a-c49be00bf7amr248310266b.37.1793206479455; Wed, 28 Oct 2026
 09:54:39 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org> <auBbKP8UNI9talDL@gremlin> <e5766fe2-6cbb-45bc-bc57-87314c130de8@kernel.org>
In-Reply-To: <e5766fe2-6cbb-45bc-bc57-87314c130de8@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 29 Oct 2026 00:54:01 +0800
X-Gm-Features: AclHuK9Ir5cjQUbkmvsMXXN1XNQvMKyhNeup0qo5sC4qB6sDOiJzphX3Pz6BQcc
Message-ID: <CAMgjq7DzLFcznTqVaRneoN+qa9StPTvcBwHMdLM52ZbfZ-ffEQ@mail.gmail.com>
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking PUD
 and PMD tables
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3BE21140008
X-Rspam-User: 
X-Stat-Signature: otq5he61k1s487ub47q5m5pdyftxyks8
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793206481-838696
X-HE-Meta: U2FsdGVkX19v9VBEMMvJNs1tSCsrD4FBfu7+HuF0YAFdjyx8HzWSbo0hY3RPlMLqj0S6jHh0BGE0bvjmfdH7cWsODrVAz254iFFpA6sbWnA7G0NrCMykdeP1QrAeNXmu/nG89B/Jk2IeIc3h1F8tLtVMFu8WCUf+BmxQO74yNZQL/X2uZpFbv+9ryNJXXFgbswhTat2W7VhKx5QqlouIVAiK8puZscXaLYoBJ4VnJpFX4M1plPjLNQT3/RPt0ndjHH/X445Zuzy5uGr2ZV/VOINN1Uf0s5ijYGUb+jCJtg42yZzrmwGUwbUCQ8ewKf9Fwe0zfvMg90EgGf+0bYsvocJHNN9BERvIUB8c5eq6YBNWfpD/uzvYL1+taj8N9WmVNv1XnVIUZl0SOJvK6MMsp09UUu8Dhc6bee3QVQGuy+KhbYc9OB1IdmSEqUC4eEQaYP2a60z2PgUlD3CCGp8uchugA+ZKY6k0alTQ4dFGn+0M0JPxbsHcvf+yKvW/ud3XOS0Qa/ibE62lxyDP5O/j4rqw8InquChOQCMG/OpiKRTIU37xWgxCLxJOL5Kc2oqZL2pJX7+UW65PcW8e2boVtiUiI2HMYi+pPdjhrXLaPQSWttUu5SjokOI3hqYc5dbS5ajsUaUx0PZwn9J0ZVyY68wmFNKnnblj+S+BI7TMv+vvrPONyAMys50n+vVffN79/kuNYswF1iJ3SMNy1ax8sKDtp44R51cPvQTh35sqXFFw7+chdZ9Cme1avkZh37dIcUoGGvA337OnR1+3NYNCK/GnNIXr4uqs2pwpqXRshoGfSgGRZ28Ppg9HIQDDE+ma7kerog6mcx640kffnPBbo2oD5HBlzL1vkItLYYSPPfnu0tvDMrcdNLFIfdGcg4kq8B3DCPJHQBtHHtAfmItvSzW2YHPelTES9XQz/sNxM7Z1Tcv4Kr7d8SikEHmB2oNhT6GOQmSyk2RvzR6XeBD
 O9Zwl9nX
 kQg80x2FzC56/YEZ+my4k/L4vTF0oGiCL8CUUoDG5ljA3z4ZOyU5MDo454nU8Dzmd2VuR8zbVUsuoz247RAX1+SouNxg38evFlg4trdwri9HXXfebi/t733EFdWjF8rPOxc3Tw3DnHG8Mjy1aSssOy43dVMGrBf0hg/Ej2jBlDRf8Jt/qIQ1Pa0i4dy9MB+CFn/LyjBWINhTbTijGrIGihFhZVOYB9Q21whJPN1OKOvL34OG1W9SdNDm5AyC56Y/A/YYFaKtOOQpKrmWOD6PWMd8s2ama5yDndFYw0wPpsOvPgzMJaw6dtUyrXnabuxnQoxt6zNobLq6Hp80WResOnrK//Aqo02CPhlGILjPtpM5MR159yX35rFNcENKrDTumoIBHDlQQ8j8T4e4o63RPCq8UhN9+t+1PgKmsEDgSD/ZSKQSWVbMcT129xhC3RY1RQM7V65YY4yJcqd7gzlicBVJ/xZ459arJQ8xLZCr7uHSOeyX8ZaS5CQT2zk+9NRyuNKVCdM6NM1QRFO538t/VAO2IAJE04BSS7NGE8Q3oLGpHDOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 3:07=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/27/26 09:06, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Oct 27, 2026 at 12:17:21AM +0100, David Hildenbrand (Arm) wrote=
:
> >> From: Josef Bacik <josef@toxicpanda.com>
> >>
> >> MGLRU passes stack copies of page-table entries in walk_pud_range() an=
d
> >> walk_pmd_range() when walking to the next level. These copies can beco=
me
> >> stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a P=
TE
> >> table concurrently.
> >>
> >> This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
> >> support page table walks"). Likely, earlier locking masked the latent
> >> bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
> >> retract_page_tables() without mmap or vma lock") allowed concurrent
> >> retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg lock=
ing
> >> for MGLRU") dropped the walker's outer RCU protection.
> >>
> >> The fix is simple, so just fix the original commit so we don't have to
> >> speculate. To fix it, pass the actual PMD/PUD pointers. This restores =
the
> >> RCU-protected lookup and validation against the live PMD. Note that th=
e PUD
> >> handling is required as well to handle folded page tables correctly in=
 all
> >> cases.
> >>
> >> Fix generated by an LLM and sent by Josef Bacik in private.
> >>
> >> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >> [ david: handle walk_pud_range() as well, clarify+simplify description=
,
> >>          adjust Fixes: ]
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >> ---
> >
> > God, terrible. And why does MGLRU feel it needs its own independent pag=
e
> > walking mechanism?...
>
> It's all a big mess. I think at LSF/MM there was some talk of using that =
also
> for traditional LRU, but I guess it might take a while ...

Right, there are reasons, MGLRU's page table walker uses a bloom
filter and have some zig-zag avoidance. It would be nice to fold that
into the generic walker eventually, but it=E2=80=99s not a high priority ri=
ght
now, but we=E2=80=99ll get there eventually. And using that for CLRU lacks
support for lazy promotion so I'm not very sure about that, but still
things are being unified bit by bit, so it will at least looks better
step by step. :)

