Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BDBC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DF66B0160; Wed, 12 Aug 2026 09:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28826B0161; Wed, 12 Aug 2026 09:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16946B0162; Wed, 12 Aug 2026 09:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2040E6B0160
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:36:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94FBC1C10A0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:36:37 +0000 (UTC)
X-FDA: 85092717234.02.582DCC6
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id A917A100005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:36:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BswxLY3o;
	spf=pass (imf05.hostedemail.com: domain of tabba@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786541795;
	b=VRGO2XtV8WpQl+tTGh7mcP3PGpokto5va3FnDq0Db9DB6Hh7bZfqEvi1x7JDRbJbBWjHdt
	dGbRPHOrptuKva3+uUFbuE8CvJgdRJoWsW0lAv8+9j4n7t+426g7bCjD6fweHhBd5amp/3
	iiCMeuQoGQba++Tw4+3f9Dtb4cJ73kU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BswxLY3o;
	spf=pass (imf05.hostedemail.com: domain of tabba@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8ig8WOZx7XhZvybLzPJyMWD7j4qDk1RSS9jPUIQvDQ=;
	b=lSuKkNjjPsPpQxz9EAup0daEvZeB8BU+RgRws55gnuMGvX2gwYVrNgGr01ytCJkXBtYW6b
	yuRM2bFRP4zwRop4qva2a7n7N9X165D5MXbqBj6BKnNMP51ntTUbqUcEDsu8idiqkg+pax
	2TW3enVQy/a5XeF/n3xcotnkafr8ygY=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c15a5b265so228931cf.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:36:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786541795; cv=none;
        d=google.com; s=arc-20260327;
        b=ehPgvagXo06szsrx76QviBIOIb9lp7K9mNtdsA2ZNhSHte57d1+qOKJbOiNr6RTpLM
         NVZJ4kn9R13LlRCBDllL1z49ZnlPrC+XlogeQoARxsltZwnHbCSl8mvizw22YrG45TG6
         WQm/74vKYE7ZEu3Xsord2F+OV/XTVXTf/YoB4E9Lq0odmYhRiXp4WVeHmPhb0zTnIF0C
         3b+VGyOFGguJbPEMDbbfAYTYwPG7ljn+CfsPIBL0ApvJU7qNtWGftNkphcNQsjB+35MX
         NI5X7/OR+MLaul2y2bjqLDAO09gA2AsI/PKbqpAzrl9ANrU2AyTKwHWSgP+YdeVxzUdY
         t9zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=O8ig8WOZx7XhZvybLzPJyMWD7j4qDk1RSS9jPUIQvDQ=;
        fh=zDjP48aEt/cxtrcZMBBCggyiK76CaHAmByGAgN/bxkI=;
        b=p5BFec5M/xTTk7wg4VCx7kCIdwPo6ksyLXk89Y3Yto81nbw9jA13XxyoOfwRtoeJ+Q
         kLSduRDrPLeBwpOSUBGgK5+mn6SFl+Q7aP1zdO5pLqqmo4IOh+ltmBNW3HqoYOGmdwDM
         s5KhajWIHIK5eJo4BKcOYsA00/4A60qv+lC8Cs28CXmmhKOh00bkmbYMBk4ZITK/F3bd
         NbYCCiCscQv2F0SZJVTD7c5USCL67JzmiphM/DFjm9EoK0qqzH9qgRLmJZTEGebxMlu5
         Eoqqywb7RhGYD8nLUyaqHmf8kL52Ll3+ipANCuFBGtC2jhc8PHgM6tTAG18BScQh/jmm
         6NQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786541795; x=1787146595; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O8ig8WOZx7XhZvybLzPJyMWD7j4qDk1RSS9jPUIQvDQ=;
        b=BswxLY3oPZg5RJ9Fy/hxkWhDrlGSlzhqubaoHOPkvWUvL4Y6B3Ok0AFiwg0yh4CQA0
         el1IHDJ7aDaF5rk6MWn5UX6aTPgLiayw72oToS8QGWo1X092LsRgOFptadxIXQTck3oH
         fgPZAH7Q+i8yBTihzMvjKLLpcStgR3/WCNzPYixsmWiOoMsqWFjscc1r+MV+jlT0Tq6b
         KFc7NdwT982qkIo5dN/FkCR+07g9PhxttGaS9aF5L77GwD3LmHxcpqKj69yYLxgJV1ng
         rz2vIodkGvIHYE+s6iUTitAa8YXhNHjDuiWX7QB3PUpVD/BDjN6eitLKiT078JSQjU+U
         0aeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786541795; x=1787146595;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=O8ig8WOZx7XhZvybLzPJyMWD7j4qDk1RSS9jPUIQvDQ=;
        b=La6QW6ahlOVlrX2tHjKNpP7CYgW4n88193X5FYjsobqUaEQcvDLLv/W45qNcPKZwKh
         J+WFmPpkPmQ8yrf97DupT2fQ4eu21gVpM41Ag+4qJv9A8A52nfm1zF4Pgwhy2Z5qZC6H
         wrMhK07TeY1EjtVmZigHJaXotqUEZZQiM1BUHPXGXKpjRCvZjMcpiLFpiEsz5WCjKum1
         Kp2+2llIsTDYWR5Gx2gsrg40SM5AePO4oeQ+mb5MJSmzzdAiJOOvHq2DUMTA/PosHCVG
         2gkiTWUGeCZMM/ccCspsyoliZdY4TM/g+6s1Z2l0FBC1v4G70cqq81GO3k2gkNBT0Wdn
         YUsg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7LWeWwSYWCeNNjuIvThFsq4EOzZOr4oKkRclenUj8W3w15WFa/OeYdcRVvOI1ym86EIxz5DLC8Q==@kvack.org
X-Gm-Message-State: AOJu0YwPm9HC3dTemd6JJepHeQI18GGsqaDlfhG9nJcppdQ4N6ycDfI4
	N8qgeRLxaptgcd4qk7sNUahtcKeJFh4qvYlPgcPvOb86dJ0lbDDlp1KgdPFyF84ngEZyuUyAoSW
	U/VK6vG2CW9nNpBZ4wuVyLcejbAB2UOUbr/QwKXUN
X-Gm-Gg: AR+sD10g7IsqpDFcwRV/uonIF1gzBhMpdSAAAfw3F2kr3Udw3vKMzNcHCSRQkqGZMls
	tZ0DDVYOKAnWiRgw2FgLoMZSEaxGONVTNwrS+QPD53Z2KWc5KnG5Q7igBsPDQCk6A+dJyZT+rAb
	y9a+dOIoMMF9/pv8iWPYYMFRHyrJjkrJe1Jj4lODoiuNS2RxbKPX7ojYsrZgznfn5bCXK63y9+d
	NRKFmRPK1o7Ge1wKR0gR7xVGRSX8rac0TG/baVoABLZZqHXzQXX94Fa6h7B97RFwXnPJJi7xAQ+
	kMEsB7MpSejjN7hNhooDFqp4msKtawcKNu2cKbZbfkPfbg==
X-Received: by 2002:a05:622a:e198:10b0:50f:af60:3496 with SMTP id
 d75a77b69052e-52d65464646mr13738681cf.1.1786541794243; Wed, 12 Aug 2026
 06:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com> <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 12 Aug 2026 15:35:57 +0200
X-Gm-Features: AUfX_mzWYjCDwiui5b6BAKCYfBkQOYXMoJhicR-4oNYgSy_SG6-tlHfLwASmQvc
Message-ID: <CA+EHjTxPznVrL8t2T1AX0Qs6Ph8z-Z3e_z0ZLt3sgAOf37VFRw@mail.gmail.com>
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A917A100005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ptn1dhtkm5jfdt59cxtkfw3bmcusjcey
X-HE-Tag: 1786541795-946243
X-HE-Meta: U2FsdGVkX18Y96DWEl95kbjlv8jDOKYwO69O7n2LcyLIqwnlMORyW44rZXlwdggJXBaEi8vkLTC/6WmnXw1qcSeSr9nytndGz6Qi1aS8eTX0iAoAIxJomKTd3mTjTo+B/sdW84eS2/IatIY613PmxDUixUq9da0cZ4j6Xuiqf7X6imbLTtTMvDs8KE/x7TUVgrL6eX+8xqpBrF2YaHtcDU9S73BJqQ7O2C7mEp0f33QgiD97iZlnL/FtOkWA6kDZjDFswr5QyQTGREXXS1xI8XQz6G5wRZna419guEaKL0VxX7JVXkz+BjFeIHa5raN9PqJ0gWaMFZyQBgbUmVmf+H+Va/0VniTTZF6YcnvCi0N4GkMgz+XJtQGyo366gy7fAoOU9v4NG9r9HCQec3DpUhUbAZY4VWrRJjsd+3/jX6M+ZNTvvrjTy0k8cxJht54PeoLP0GCrtp0nmn6usbKQ3XYYcw9b6zXUBnGpRRqi3H6q7I3Lwfg1OV4ovHEjcI8DatBNCRst1sOQQHJ5S0fnnfooRZUH9L3JWvB83uRcd1ympRuFzxKOI9gOQ0Gelpz3Bf4UYfkIMPS3YozPpWy/+XTey3OAZHmseKpCe4KamSdl+sCd1aOf7mDXZ74bWGR/Jo+8ixcjCLz2xXesRrM6KwFOIYyooYrcvMlG+Vo/nAS51CPA5O82fpqdYeTXjCqm764F800GU/uWmI+FUC5q+m6G1nRD0691rzrIclc0oTroI/7o/2umFt0eShBhC4+nrkO/SC5ZoL8QA/RZSTK8tAWX0a20WcODaBFdvIehHn92atildexylD49RUhOogPCZGLjIyKbSJ59ilnfVEx65iJ7bdszc6dWsNHMzaPakd5TD+vDeCZpjGw6b5TpRYEXLNp2+IsaF9bKEmDoRkyykfl2SUanVV25nKjW3jKbc20U5H5kRzSV2y4h9WXku911OtoGmeD/w9qNRAVuKi5
 OnBC8KLx
 sRde4E7V0Lw7WUfGr2DKLWqwJRPcuHuEOMvwzDNrbkIJtpiNJyqITblCaWJ+vF/ATyrBA1S52BXTm3+5p+Fo9ghBq2y0Xv4cRB4cXOzzlMMzhCoiQExNmPtykDu8Cev8I5IglBwhBuRx72mxLZLs52ztigk2sWuAsmGSL/xJUnj3/MG/4FE2y83vPSOPCk4b17X3gAgc62ohPT9oN0VvqPWj8QHrQkhg3epIODPJRWdv/SZfkpVlszB/tFTy4YwqDB0cruHfv5B67xYz3md6KdV7BGYOLC1UUUC189cZxGsuAVwGaK/DPQ+K3N71JTqwJaB2Q9WBA5gJ470RIemdwWGw22683XGGnpdTwuqDwJHEUSJM8gzPXqv1Pi5EU16xwmhM2T4SkeXXa6sY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026 at 23:52, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Before conversion, a guest_memfd could be either all shared, or all
> private, configured at creation time using the INIT_SHARED flag. Hence,
> when zapping pages from stage 2 page tables, guest_memfd can filter which
> to zap based on the initial shared/private state.
>
> With conversion, guest_memfd tracks shared/private state on a per-page
> level, so a range can contain both private and shared pages. Zap both
> private and shared pages for simplicity.
>
> An alternative would be to iterate guest_memfd attributes and only zap both
> if shared and private pages exist within the range. Setting both the shared
> and private filters lets the zapping logic do that iteration instead.
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  virt/kvm/guest_memfd.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 75979c885e030..b1537226e5adf 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -136,14 +136,6 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>         return folio;
>  }
>
> -static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
> -{
> -       if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
> -               return KVM_FILTER_SHARED;
> -
> -       return KVM_FILTER_PRIVATE;
> -}
> -
>  static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>                                         pgoff_t end,
>                                         enum kvm_gfn_range_filter attr_filter)
> @@ -186,15 +178,13 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>  }
>
>  static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
> -                                     pgoff_t end)
> +                                     pgoff_t end,
> +                                     enum kvm_gfn_range_filter filter)
>  {
> -       enum kvm_gfn_range_filter attr_filter;
>         struct gmem_file *f;
>
> -       attr_filter = kvm_gmem_get_invalidate_filter(inode);
> -
>         kvm_gmem_for_each_file(f, inode)
> -               __kvm_gmem_invalidate_start(f, start, end, attr_filter);
> +               __kvm_gmem_invalidate_start(f, start, end, filter);
>  }
>
>  static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
> @@ -229,7 +219,8 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>          */
>         filemap_invalidate_lock(inode->i_mapping);
>
> -       kvm_gmem_invalidate_start(inode, start, end);
> +       kvm_gmem_invalidate_start(inode, start, end,
> +                                 KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
>
>         truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
>
> @@ -344,7 +335,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>          * memory, as its lifetime is associated with the inode, not the file.
>          */
>         __kvm_gmem_invalidate_start(f, 0, -1ul,
> -                                   kvm_gmem_get_invalidate_filter(inode));
> +                                   KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
>         __kvm_gmem_invalidate_end(f, 0, -1ul);
>
>         list_del(&f->entry);
> @@ -525,7 +516,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>         start = folio->index;
>         end = start + folio_nr_pages(folio);
>
> -       kvm_gmem_invalidate_start(mapping->host, start, end);
> +       kvm_gmem_invalidate_start(mapping->host, start, end,
> +                                 KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
>
>         /*
>          * Do not truncate the range, what action is taken in response to the
>
> --
> 2.55.0.654.g21b8a5bc05-goog
>
>

