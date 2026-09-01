Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01420C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A736B009F; Tue,  1 Sep 2026 03:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBADB6B00A1; Tue,  1 Sep 2026 03:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC416B00A2; Tue,  1 Sep 2026 03:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9052E6B009F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:46:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3F911402B8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:46:39 +0000 (UTC)
X-FDA: 85164411318.15.7D6E57E
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	by imf18.hostedemail.com (Postfix) with ESMTP id 771C01C0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:46:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XkEbO+rY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788248798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlyokOQKEuSb7ajHVfiS5ipxVlTBTO70JbfgLZonmQo=;
	b=NjcPDLJfFiIwRo0VLCpf3TPJbtTPiVj9sllWu92TfyhZVyeqbGUbHZYW9PtRfQ3ry6RPSJ
	+lpJU/pDjCWk1OcE8D5vgJSkExdUFh45DkgJ6ej4iBAJz4Rkv9+Atb+wE9PgGXq8Y985xj
	TL9kwH3KeMnYTzNIECxkOroAiTObwg8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XkEbO+rY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788248798;
	b=17xfU+KOD6bbVcpmi2alYRKXAWHCFQFciElpkcwGxjQnZCpx8tCqQeznV1lCmfDNdBFG9/
	dvQpCmi7wwyQd4tiLBcnfEU5n8fVF8a0zeVY7FDQEX8dcqmokijIOKPvJLuncvZKvpJ2eZ
	JZiuDRxA5f/BDR6c6GtWGteRcaJ9lW0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=46/XfvU4UUxnGFLvYengC/Ov+6x7Xx2+ZA9VWoRfrDc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788248795; v=1; x=1788853595;
 b=XkEbO+rYsQfXIcA6+0JUkpH+9tSbR7IyMDgx8dyp7GszbLuUZJ2J32Y2NhcD1McxKqXylQ3Z
 X9oKv9PYyb6pegjG1dj5adB4Bw+WzoOW61sc12PngidlUo+jbjvc2l8MtZXw84j5A8OgBVqMopr
 pqFUIA5nQey8RrwE8lk3tAiw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cfd0dad44bdf86ad;
	Tue, 01 Sep 2026 07:46:35 +0000
X-Mizu-Trace-ID: cfd0dad44bdf86ad
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b2a8173142so3270e87.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 00:46:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzoC/HXFs7FKxycXhCDiGkn+BeA1vtaV7v8wx58F2oh0t1jxXhSes3BSTXTNhR982ShKwRkPoWtKA==@kvack.org
X-Gm-Message-State: AFuF++kQALkenjsm+eK9L4oEiRHW2qMdh6VF7KL/FzfAF2hwwEvewxl1
	hX6s3u6uP7mZUOx1ReHnpjvVsPru1C1zL70HrDAPcHWX6CJmV84V24BDjGeQY98jdJX/N0uwma2
	HDhQgIFGs/xjtoW99K4CmM0VPpgYuJlZdXjEaMoKu
X-Received: by 2002:a05:6512:b8d:b0:5b2:8963:e5d4 with SMTP id
 2adb3069b0e04-5b600a42bd7mr91617e87.5.1788248790675; Tue, 01 Sep 2026
 00:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-15-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-15-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 08:45:54 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzJbC=ZvB3Mopw-TLf=13-iqxGw5RfTp6Gt5S1hi8WRRA@mail.gmail.com>
X-Gm-Features: AcwNN1W8nZTxVvoFPBYtI3aVIovLXAurzaZOGm0KyMs0U_MOniIbd1ibspvycU0
Message-ID: <CA+EHjTzJbC=ZvB3Mopw-TLf=13-iqxGw5RfTp6Gt5S1hi8WRRA@mail.gmail.com>
Subject: Re: [PATCH v12 15/45] KVM: guest_memfd: Ensure pages are not in use
 before conversion
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
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ud48he376fbf6sdycutoswodu7z5ftq4
X-Rspamd-Queue-Id: 771C01C0006
X-HE-Tag: 1788248797-521482
X-HE-Meta: U2FsdGVkX19Hk1vHh8EMDHzkWApZ2wfBKrnOAo0EMXWymonabC06mf5xwdsGZ5Hik0rFelwK05GfBSDvZCqH9JPJm2w1EQlZcoWaDcjKiOMPtxpALYxG3atv4/8ZX3vcSHWM2rrJPUq+0/ylrrHkSiXAGhqDRW3o3ZoHRkzarkoRaE/52+2ZEpfiq/I07ahHwA3/jUMsGLFF8DJzpGvXRFC+V16fWXgCT6PKDJzpMWLB8AX/Qb4od0TSub1ZNtQWta4Iz4wzEfS0aGEWBev/GlFNhgH2WjaYbmmWJ8bGJ27VUwhUur0AfdPoHo6EHBV2Pme5uUGNVparcc/ispPhr/4zibTUiGbN8LPiVv6euWiGmZHee4avxiDJAX9QohyMkL1TZyx7CRaSiAUD2AWdpgP6mkBKW6iBN7DLCsxJ6ke2XgGwhvX9FWPd/MNAngDk3vsFkHG+JtBX0g1M0Y2EpX4QGbw1ihY2QBvUx33OFfPvbkvyrcSZk2Y1oS0pWxW87/NZB7WcnXKBuyuwvdTcsthGJ+BNjv96FFUTIiWIqTbpAC9J+OOstZomrL9nAAoiZjb9wLeP4rlHhEUp6IM/3+kDdyU1bwCq30JPNFQO3nTaJAnqhlWrBlUv7HzqfqV5nB6XflBBm69n+FRUb5ouSG9yfEoRiOssnxkmYbsqu8PQvaGDKdEUnMmg0yNVDGOiRf5vGVi355bGyBmxpCL5XxwWBrjhazP580++4KSy3mB64YTjIqvZPHCXXtHnPUWNrQqDrXVMFn8kNUpGYGkB7lo1OFebHgqCN8FjLZzb+aBr/T6qlssyGTpkrcG/o21PcioMPHovaugINV6ey/abaSEnTF4uKVu+EX7Qubfk2ZZb/uk4On1mAuJBbfRDEzqugjbAV1smyqcQgaj13/sbvccJeubpzxGgbtYSnlxP4IQQqJp8M89qgYtJEFRKQwlvuhEhfz9eMfN0KUSIf6F
 HeHeDWUW
 SdYlokNvS6rCsgqvNDL3uSrnGqb8EZRmUI/fnm/ehTw34C3CLBHh3Mm8FxsUwk+YHTRAYJqe+NVC6q5Aq9Z0tHEaMcfJiW+Drv9M5/Ju1kvwEtq2+2eU/2T7pM0xgWrCxiIdwqZyMKQ3TWLaQmGLoHSO0AFVQyCAWaINdvH9QcyFzy8LAxSLsRG6upY+kW3nmp9dSllvXkZ7EJkOr5ixDMHykisqSmnIppkw4e9ifa2MFmEiE2zHSAo5ro8UyVu7nsCNYjwxeFXJNmGfaCTuoGl6PZG91bUxCg0qo4R6WnPUafRg0oRm7gu8OwPytujQHvAWs2tW+Cz4K9jLhR5+VH8nkQfJ7MiIyy1TcymmBN6fPMBC9GpGAe/g+/mhkiP0tnW1N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> When converting memory to private in guest_memfd, it is necessary to ensure
> that the pages are not currently being accessed by any other part of the
> kernel or userspace to avoid any current user writing to guest private
> memory.
>
> guest_memfd checks for any outstanding references to determine whether a
> page is still in use. The only expected references after unmapping the
> range requested for conversion are those that are held by guest_memfd
> itself.
>
> Update the kvm_memory_attributes2 structure to include an error_offset
> field. This allows KVM to report the exact offset where a conversion
> failed. If the safety check fails, return -EAGAIN and copy the error_offset
> back to userspace so that it can potentially retry the operation or handle
> the failure gracefully.
>
> Update documentation to document the error_offset field and the possible
> -EAGAIN error.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 19 +++++++++--
>  include/uapi/linux/kvm.h       |  3 +-
>  virt/kvm/guest_memfd.c         | 77 +++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 91 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4dbf452f6e809..25cb15970f1ae 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6613,7 +6613,7 @@ KVM_S390_KEYOP_SSKE
>  :Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
>  :Architectures: all
>  :Type: guest_memfd ioctl
> -:Parameters: struct kvm_memory_attributes2 (in)
> +:Parameters: struct kvm_memory_attributes2 (in/out)
>  :Returns: 0 on success, <0 on error
>
>  Errors:
> @@ -6622,6 +6622,8 @@ Errors:
>    EINVAL     The specified `offset` or `size` was invalid (e.g. not
>               page aligned, causes an overflow, or size is zero).
>    EFAULT     The parameter address was invalid.
> +  EAGAIN     Some page within requested range had unexpected refcounts. The
> +             offset of the page will be returned in `error_offset`.
>    ENOMEM     Ran out of memory trying to track private/shared state
>    ========== ===============================================================
>
> @@ -6635,6 +6637,7 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
>  ::
>
>    struct kvm_memory_attributes2 {
> +       /* in */
>         union {
>                 __u64 address;
>                 __u64 offset;
> @@ -6642,7 +6645,9 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
>         __u64 size;
>         __u64 attributes;
>         __u64 flags;
> -       __u64 reserved[12];
> +       /* out */
> +       __u64 error_offset;
> +       __u64 reserved[11];
>    };
>
>    #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> @@ -6664,6 +6669,16 @@ which includes operations such as unmapping pages from the host or
>  stage-2 page tables, may result in side effects on memory contents
>  that vary across different trusted firmware implementations.
>
> +If this ioctl returns -EAGAIN, the offset of the page with unexpected
> +refcounts will be returned in ``error_offset``. This can occur if
> +there are transient refcounts on the pages, taken by other parts of
> +the kernel.
> +
> +Userspace is expected to figure out how to remove all known refcounts
> +on the shared pages, such as refcounts taken by get_user_pages(), and
> +try the ioctl again. A possible source of these long term refcounts is
> +if the guest_memfd memory was pinned in IOMMU page tables.
> +
>  See also: :ref:`KVM_SET_MEMORY_ATTRIBUTES`.
>
>  4.145 KVM_PPC_GET_COMPAT_CAPS
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ac371a50041c9..8dff2fc1972e9 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1665,7 +1665,8 @@ struct kvm_memory_attributes2 {
>         __u64 size;
>         __u64 attributes;
>         __u64 flags;
> -       __u64 reserved[12];
> +       __u64 error_offset;
> +       __u64 reserved[11];
>  };
>
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 803c7cdbbe0f6..fe02c47c85fb5 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -538,8 +538,46 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>         return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>  }
>
> +static bool kvm_gmem_has_outstanding_references(struct inode *inode,
> +                                               pgoff_t start, size_t nr_pages,
> +                                               pgoff_t *err_index)
> +{
> +       struct address_space *mapping = inode->i_mapping;
> +       pgoff_t last = start + nr_pages - 1;
> +       bool has_outstanding = false;
> +       struct folio_batch fbatch;
> +       pgoff_t next;
> +       int i;
> +
> +       folio_batch_init(&fbatch);
> +
> +       next = start;
> +       while (has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {

has_outstanding starts as false, so the loop never runs and the function
always returns false. The outstanding-reference check is dead at this
patch, so a to-private conversion would not be rejected even when a page
still has an outstanding reference.

It's fixed later in "KVM: guest_memfd: Handle lru_add fbatch refcounts
during conversion safety check", which changes the condition to
!has_outstanding. I think that fix belongs in this patch, so the check
works when it is introduced and the series bisects cleanly.

Missed it on the previous review, but with this fixed it still holds.

Cheers,
/fuad



> +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +                       struct folio *folio = fbatch.folios[i];
> +
> +                       /*
> +                        * Outstanding references are anything other than those
> +                        * from the page cache, plus 1 temporary reference held
> +                        * by filemap_get_folios() in the folio batch.
> +                        */
> +                       if (folio_ref_count(folio) != folio_nr_pages(folio) + 1) {
> +                               has_outstanding = true;
> +                               *err_index = max(start, folio->index);
> +                               break;
> +                       }
> +               }
> +
> +               folio_batch_release(&fbatch);
> +               cond_resched();
> +       }
> +
> +       return has_outstanding;
> +}
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> -                                    size_t nr_pages, uint64_t attrs)
> +                                    size_t nr_pages, uint64_t attrs,
> +                                    pgoff_t *err_index)
>  {
>         bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>         struct address_space *mapping = inode->i_mapping;
> @@ -556,8 +594,28 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>
>         mas_init(&mas, mt, start);
>         r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> -       if (r)
> +       if (r) {
> +               *err_index = start;
>                 goto out;
> +       }
> +
> +       if (to_private) {
> +               /*
> +                * Forcefully unmap the pages from all userspace page tables,
> +                * and then verify there are no outstanding references, e.g.
> +                * acquired via GUP or similar.  Tell userspace to try again if
> +                * there are outstanding references and hope that whatever has
> +                * pinned the page will put its reference "soon".
> +                */
> +               unmap_mapping_pages(mapping, start, nr_pages, false);
> +
> +               if (kvm_gmem_has_outstanding_references(inode, start, nr_pages,
> +                                                       err_index)) {
> +                       mas_destroy(&mas);
> +                       r = -EAGAIN;
> +                       goto out;
> +               }
> +       }
>
>         /*
>          * From this point on guest_memfd has performed necessary
> @@ -578,9 +636,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>         struct gmem_file *f = file->private_data;
>         struct inode *inode = file_inode(file);
>         struct kvm_memory_attributes2 attrs;
> +       pgoff_t err_index;
>         size_t nr_pages;
>         pgoff_t index;
> -       int i;
> +       int i, r;
>
>         if (copy_from_user(&attrs, argp, sizeof(attrs)))
>                 return -EFAULT;
> @@ -606,8 +665,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>
>         nr_pages = attrs.size >> PAGE_SHIFT;
>         index = attrs.offset >> PAGE_SHIFT;
> -       return __kvm_gmem_set_attributes(inode, index, nr_pages,
> -                                        attrs.attributes);
> +       r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
> +                                     &err_index);
> +       if (r) {
> +               attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
> +
> +               if (copy_to_user(argp, &attrs, sizeof(attrs)))
> +                       return -EFAULT;
> +       }
> +
> +       return r;
>  }
>
>  static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

