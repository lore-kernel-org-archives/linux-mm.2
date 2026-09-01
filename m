Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12D0C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7936B00B7; Tue,  1 Sep 2026 06:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71306B00B8; Tue,  1 Sep 2026 06:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37F96B00BA; Tue,  1 Sep 2026 06:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9A36B00B7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:34:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 23EB31A02DD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:34:56 +0000 (UTC)
X-FDA: 85164835392.06.A870E8B
Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id 97C391A0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:34:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Fko/KJTG";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788258894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i972GG/DrZKuZfQXxZQ+goAiJ8LgEGFcE7AVKjeLI5A=;
	b=FotvMhvipFAfaiN1NYfax8NRgywZd53u94/rRnAbLscfxGraYoQqkjC1+3zkS6vHzRBX8/
	6ZZs+tKhU3+YOAvMqV9A1m25vpQEbkuX79rFrDxNsOjHESmrbzE2flytqKEFLOP7GEvkjk
	1Gl2qvFS7Mx6oyzPSTM3lgXPZd8MhxI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Fko/KJTG";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788258894;
	b=mGVawqkgTBWm+8iDFbD8jY945twuRc56PyZxoC3jfM4tFUNGsJRy8b5Dq8LQH5JAVrzoeN
	cZ5bnv0oJY1VebAU3DatB2ZjTDXQuOevQfIHatsTiQtA0pB5B5nFTz8o38MhqxH1Ge/dzN
	WTgMmJqMbndCijhzZkPCnpwy+nYwE7o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hGwrqJibjsI979lLLZMh7q1FzrzRBk6jSe5g0u5F2Qc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788258892; v=1; x=1788863692;
 b=Fko/KJTG+UgOPW6fXQx2paHTq6dn+386Qq+Xn+RJnQCYXxWdShpUlJQmcF5MRYvlsGfky2iA
 jKdWSVk/oeeMIMp4BDA9u1DuGIdhk/gQ7vv8yt3Bn1HVztql3qW2vpfJQ9zCN+AmqU7AD+eAp6O
 pLruDk2f2KtcUrQbdw1uOdgQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 917e2f0b78a20bac;
	Tue, 01 Sep 2026 10:34:52 +0000
X-Mizu-Trace-ID: 917e2f0b78a20bac
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso7032e87.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 03:34:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzhbuMEbj/YCatkrH64NeJX8jj0DUCsiM7/dC8zqwD4aH6oQJ2c7Y4d/LEQkYnX5z9Vl1xvjtgScQ==@kvack.org
X-Gm-Message-State: AFuF++k01WnUIbGSV5tgJ5wToVdWb3aU8MtWRHe0/elYPjdhv+/oq8Rp
	G5qOhlnhuTUIhJG/CK3/enWzVowko/v2CVGN+NPa/MPtDkFg46BCIIFoP2Mmc6GqM6i7QTJtLNM
	/6BAAwtrYC9CEpCQWSMMdp+yOwo4lSS3l31Wp/CV2
X-Received: by 2002:a05:6512:ac4:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5b600a0b6f4mr114181e87.1.1788258889928; Tue, 01 Sep 2026
 03:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-13-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-13-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 11:33:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxdJmjBu8vJqbZks3ANP7QFZzGvp4J7kqxvTNR-fKMmJA@mail.gmail.com>
X-Gm-Features: AcwNN1W_H4CnVusKniYHLtrTvE9k4_Zq5YT-PzaJWqqbnOmAYps19c1F8GBPWTQ
Message-ID: <CA+EHjTxdJmjBu8vJqbZks3ANP7QFZzGvp4J7kqxvTNR-fKMmJA@mail.gmail.com>
Subject: Re: [PATCH v12 13/45] KVM: guest_memfd: Pass mapping type filter to
 invalidation helper
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9us5drtwkzh6ym5nb99w7gg5dwoc753x
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 97C391A0003
X-Rspam-User: 
X-HE-Tag: 1788258893-346822
X-HE-Meta: U2FsdGVkX1/2MYLZ/yplyiswOBPu3XRyGyzyD7ZNpLD/d9jV5V9eY9oWFzGvNwkdKsE/4/9EoT1+maJsJZqt5p5Fi3adiZ0RAwMGOVFr/rRlHpBKLt+LMXeGWtdjQU6VJH6vPEXLli2kZUjF5sOfa5khOzk+PXCWHFTbVNA0LEXiqZpABUFJxcpoEB9WrS0WbvRQ2QkRFm+lDdeBUEnLlGar0gce+XBF8+t5eiWWQl8+Kfj0dxb2T48DnlwRMAFAtVOGutJW+yd1qlA9NvRLwkOmwvvzJ5EWH+7fy9FgZ0jeQlWPe9X9IRu9wuUaUVYVpPD8C8mx3vkr1nvYVT5+EYoSwaVxQ1CZE0xHsOn54QWvWCYuPbVW8aveE80ByAp5vjmm9CyLxI5XZNmcX3tGDNSsNodBCV4QDzqJf+ykswvvaplrYlwcp2JVJO7wmHMaycZjSHhGmrf83RUSGEFtbN46UhqIsvUp/X03YGCuBzw8iNkBF4nNysURRE7xAGdvBd0djFKvYPznSPKhNp2lCtsvBszfrSZd/iiiEI/FNAyLMmNm2IvcIk27/S96QPHp4hmqyAmFDkrpuq+sM0ICOXEOyJfvIBEF9EKcarVGh80kF8ueYq5WPqtqOKLSH9XVkeLCjS8Zpebndor2DltMD7AhxDraKO+awR2DiihCDVxUxvSHE+OKEwdPVcj2H4sWznf7zsnNiCWvXbxE8HrwGPrfQwl35RPd1unlU+k0GzwKjH998G/Xbv5QhyqiLgAWsOtKiqL3KnFvy6k1+otEimnEOzXmPYE5O/VgiYHawkAanHZVXHXqnnbJKSlvY5RIl5boWBzuQt9wfXU+8oq73w6PhDbZGSgpsCAaIb2CRA0H/GTlAJ2K0ADX8UQUSDjqqSJyQbzKJftWpapT9qcia/6TMCWUjJkWQSEiCAeW3l1ErPwHDNBb1pdMhAM2KqB5dMznGPUjRWAZsBd2xzl
 aIc4A1Ej
 Fx0IRmOblQYZSaiACPJnfqQIQyuat8orzW6SSKpQuEdp2ldroJ3k31KK3l5K3McIimbQNIdUHyAUTqRwCLEEKoh4CkaBfwDOR90X8PrOr3sflx84r6ckI2A49NaEW3szwM3uZaCpBWNzv0O0htNRCwFwDsiWQ/UnlRUuL1fvigtoFKBbqIAIlIgAzLyuqHFfQCbb7jpH6dtgyKBbAsH/8lu8kzn8W2KI2p83+scCYme16L5gsYwljleubqsg76/W69GY6ZhDg7/0K0YCpULk5xbmabIbalWckuh2tRz89urW4wnghLZ3Nm1yYkcnlEIBe82aFWkgNVs877LPPV4VB7iGbAGpvJvgY2F4mVfFwZswf50Dsf7ozG17cQ79J6eiHbUT3UxnrlXWg0rQWlpdwg0kLhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Accept the mapping type filter as a parameter in the invalidation start
> helper instead of querying it internally. This allows callers to specify
> which mappings (shared, private, or both) should be invalidated.
>
> In the next patch, the conversion process will use this new parameter to
> invalidate mappings only when they're different from the target state of
> the conversion, i.e. invalidate only shared mappings on a shared to private
> conversion and not both.
>
> No functional change intended.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  virt/kvm/guest_memfd.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index e41802944756b..e19de803149c2 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -192,13 +192,13 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>  }
>
>  static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
> -                                     pgoff_t end)
> +                                     pgoff_t end,
> +                                     enum kvm_gfn_range_filter filter)
>  {
> -       enum kvm_gfn_range_filter attr_filter = kvm_gmem_get_all_gfns_filter(inode);
>         struct gmem_file *f;
>
>         kvm_gmem_for_each_file(f, inode)
> -               __kvm_gmem_invalidate_start(f, start, end, attr_filter);
> +               __kvm_gmem_invalidate_start(f, start, end, filter);
>  }
>
>  static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
> @@ -224,6 +224,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
>
>  static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  {
> +       enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
>         pgoff_t start = offset >> PAGE_SHIFT;
>         pgoff_t end = (offset + len) >> PAGE_SHIFT;
>
> @@ -233,7 +234,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>          */
>         filemap_invalidate_lock(inode->i_mapping);
>
> -       kvm_gmem_invalidate_start(inode, start, end);
> +       kvm_gmem_invalidate_start(inode, start, end, filter);
>
>         truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
>
> @@ -522,6 +523,8 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
>
>  static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
>  {
> +       struct inode *inode = mapping->host;
> +       enum kvm_gfn_range_filter filter;
>         pgoff_t start, end;
>
>         filemap_invalidate_lock_shared(mapping);
> @@ -529,7 +532,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>         start = folio->index;
>         end = start + folio_nr_pages(folio);
>
> -       kvm_gmem_invalidate_start(mapping->host, start, end);
> +       filter = kvm_gmem_get_all_gfns_filter(inode);
> +       kvm_gmem_invalidate_start(inode, start, end, filter);
>
>         /*
>          * Do not truncate the range, what action is taken in response to the
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

