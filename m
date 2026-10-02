Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E83FCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 17:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5406B0088; Fri,  2 Oct 2026 13:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F6E6B008A; Fri,  2 Oct 2026 13:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D916B008C; Fri,  2 Oct 2026 13:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08BFD6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:37:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CB68407CD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:37:32 +0000 (UTC)
X-FDA: 85278393144.28.126307C
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf22.hostedemail.com (Postfix) with ESMTP id D4EF0C0005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:37:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790962650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uxM8g3vFmtnpMlvmHhp9gGXOehR9l+sJQqPIVxpzEBA=;
	b=k3mde/c4eOS4yh20FwUtlCcKMs6GMZLDpg1SQbD1UaGtK5XlxsA91e+caJL1Bhu+5F3+90
	YJaRiXvtzlqoVfmsOdhX+5YjqdGAvGw1jzKX+wgh65BAypuDzjVCU2padR12uGvWb3QEza
	bb0qthE6Xccs9X7avdMbt5FPXHysIs4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790962650;
	b=HqfjcYhXdEJvo8SijGQK6SL4FNQS1r0tCqAs1CRhgts9GV4Yz5+iZQxPskd4kTFeCMjsAo
	seSTbY8qYEoMHMs/atwFhKhap2y0uEq/fgS+jtPX98rFAKdxGKLedAclcCRt9QYv036suo
	Gv0BOFmFQt47RpBnq6X8vR76gM2XoLE=
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED5661607E5;
	Fri,  2 Oct 2026 17:37:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id CDA0720028;
	Fri,  2 Oct 2026 17:37:26 +0000 (UTC)
Message-ID: <bfefed1916a675a32ddcbebcf5a23b91fc750bcd.camel@perches.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: add include/linux/hugetlb_cgroup.h to
 HUGETLB SUBSYSTEM
From: Joe Perches <joe@perches.com>
To: Enze Li <lienze@kylinos.cn>, muchun.song@linux.dev, osalvador@suse.de, 
	david@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Oct 2026 10:37:25 -0700
In-Reply-To: <20261001123747.634845-1-lienze@kylinos.cn>
References: <20261001123747.634845-1-lienze@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18O5sdPDYTx+BSdgMTkhO/Vk7CiFlfhBWY=
X-HE-Meta: U2FsdGVkX19H9ajhoVGn9d8exUtin1T3k2oSe/ypqD9OqZeSa6xn1DrwZLvcIcS/pjPOFLrE2bWV1/Mug/qlshnsyFnD2bJ20tp+R+QbxrXzBqxFBOydqiDNmHuTbmHEhc763XCcvx3B/pyjTwdt7at9PNacD5UcGUKTPzETAzreDJ2L3qUnukXwKexkh7Hm7sETwZtGtL5G6FR1qYbBZm/W98L8lR0AR4hYAUCciqhDUuHT86SounqawUZNQ2kP3ENEyDwrbeGDW+UjeIsbuTHPKAP+JvqXqrrjmkSj8WQJeXUE3tY0XxnlS/xCn76SX7Z+DokXHE3FDpKcgQKmuUuMViX/kajAS2igwTj6dZS9Oqg6vo7rV5gV91fZaAGJMFGnVLqxIlrLS0JZ9HAyTg==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4EF0C0005
X-Rspam-User: 
X-Stat-Signature: eawzfyacp7zj3fdkn1b9xkzxo8bag8nd
X-HE-Tag-Orig: 1790962646-23624
X-HE-Tag: 1790962650-717030
X-HE-Meta: U2FsdGVkX1+KvSUB2IT7RSSlM/7BvrHZa0QcQw1FA2iclCppKukrmle2tQ26U8QVX2rtm1khwd5rWuqvLzKX/t+x5617CCT/l/GOFqwfMnNENlm4p4AHQDoiOjUpLiqdfOLejlPxCUZ/PA0G1m+psazsajp6fVJLrJMN0OI0HESE7mcOIcCinWpWG3yHL2Si0kadwx+A6PMslhDGsX+cD0lJBK/3NZLTqlvfLw2GHE0ybh0xj5/9YyJsf9e8xjHusj0x0MP4D9kbSs4Wu0083ghMRSk+jU/1AFK6c2ZuMlymfL99RofOFvZjZqbpJKj9jkn/wKiR4I6mxL1n8sXwt4laz0Yk+l/xMGkQZbh9okcHtQc7/ujn8jwEKqSsn4E+JJ7Mpz6xoH2slqrkxw4XlKl++ZYRdJx8RO8lzM63Eh0H9YoxBkom8nufCVdHDYXvNmfqQSMVXK6+TEfB/fsVi+PVA3Y09JqkmOvb46KVVpVvoVjKKRIKD1a5WdOdsdiTwNA96WSXT55WVKsOqVI646n+Cg45pDr5a3ju2O2Aca6fT2V53+os3Sv2D2EV4iQxvanzMxzoepcn3VtaIR7u+duoT5QjM7gypA8KWBUafHj5wKKozlViWmH0oaZ9aUcCjZngTXq1KDA4fiSpb9eUfPbEWKcOEJuXMZx4tNyJeMSrt4bzE6JB99hHohglbOO8XnAA5Kg9wqCApnpqeIBpReMO0kZiZxcscmL/JUQcXileVTfwIl7ms/ih9FKXYUjIzo8+WnUxvED/eJ6K2IjFERnpdU9nvyBgsKdWNkkQ5NhoUjuBjDrottKjbQ+zunMgixSLO7qMiv3KvsHxdp1Fe6qVRpEIDA3lx5dEIzD0LjVqBQSsIIioh1vJn4PrCre7hxSb1OceSsFOMoM5vlSRl8mw592+iP8tp5aqfdAL4E26Dixc0BHKNBgtoThnacG69Bslr5Pn2lS6t9Q0XNw
 PinYxZhH
 qwFnd7dZCfKo8V6VJO+G5qvIfLjjZOtIoR82F0MZZmLVDzN1F7RmGdyzIrlIrLkslIhiYN5TaUQckfmtvRfqgDGE/rDjRCpGd+A3LfkVCTdSkQCyQinsE37+a/RTUD/frObrtU6ZElbPcYo0W+AqL+QNYpwhSEsM2v4Finqck5r/KtFos5fSkLdp8ZAgJ5EczXK/n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-01 at 20:37 +0800, Enze Li wrote:
> include/linux/hugetlb_cgroup.h is the header file paired with
> mm/hugetlb_cgroup.c, but it is not listed among the HUGETLB SUBSYSTEM
> F: entries.  As a result get_maintainer.pl does not attribute the header
> to the hugetlb maintainers explicitly.  Add the F: entry so the file is
> covered.

This misses another file: include/linux/hugetlb_inline.h

The current HUGETLB block is:

HUGETLB SUBSYSTEM
M:	Muchun Song <muchun.song@linux.dev>
M:	Oscar Salvador <osalvador@suse.de>
R:	David Hildenbrand <david@kernel.org>
L:	linux-mm@kvack.org
S:	Maintained
F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
F:	Documentation/admin-guide/mm/hugetlbpage.rst
F:	Documentation/mm/hugetlbfs_reserv.rst
F:	Documentation/mm/vmemmap_dedup.rst
F:	fs/hugetlbfs/
F:	include/linux/hugetlb.h
F:	include/trace/events/hugetlbfs.h
F:	mm/hugetlb.c
F:	mm/hugetlb_cgroup.c
F:	mm/hugetlb_cma.c
F:	mm/hugetlb_cma.h
F:	mm/hugetlb_sysctl.c
F:	mm/hugetlb_sysfs.c
F:	mm/hugetlb_vmemmap.c
F:	mm/hugetlb_vmemmap.h
F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c

And your suggestion is:

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -12097,6 +12097,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
>  F:	Documentation/mm/vmemmap_dedup.rst
>  F:	fs/hugetlbfs/
>  F:	include/linux/hugetlb.h
> +F:	include/linux/hugetlb_cgroup.h

but:

$ git ls-files include/linux/hugetlb*
include/linux/hugetlb.h
include/linux/hugetlb_cgroup.h
include/linux/hugetlb_inline.h

so maybe:

F:	include/linux/hugetlb*

or maybe:

X:	arch/**/*hugetlb*
F:	**/*hugetlb*

and remove a lot of other entries

$ git ls-files -- '**/*hugetlb*'
Documentation/admin-guide/cgroup-v1/hugetlb.rst
Documentation/admin-guide/mm/hugetlbpage.rst
Documentation/arch/arm64/hugetlbpage.rst
Documentation/mm/hugetlbfs_reserv.rst
Documentation/translations/zh_CN/arch/arm64/hugetlbpage.rst
Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
Documentation/translations/zh_TW/arch/arm64/hugetlbpage.rst
arch/arm/include/asm/hugetlb-3level.h
arch/arm/include/asm/hugetlb.h
arch/arm64/include/asm/hugetlb.h
arch/arm64/mm/hugetlbpage.c
arch/loongarch/include/asm/hugetlb.h
arch/loongarch/mm/hugetlbpage.c
arch/mips/include/asm/hugetlb.h
arch/mips/mm/hugetlbpage.c
arch/parisc/include/asm/hugetlb.h
arch/parisc/mm/hugetlbpage.c
arch/powerpc/include/asm/book3s/64/hugetlb.h
arch/powerpc/include/asm/hugetlb.h
arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h
arch/powerpc/include/asm/nohash/hugetlb-e500.h
arch/powerpc/mm/book3s64/hugetlbpage.c
arch/powerpc/mm/book3s64/radix_hugetlbpage.c
arch/powerpc/mm/hugetlbpage.c
arch/powerpc/mm/nohash/e500_hugetlbpage.c
arch/riscv/include/asm/hugetlb.h
arch/riscv/mm/hugetlbpage.c
arch/s390/include/asm/hugetlb.h
arch/s390/mm/hugetlbpage.c
arch/sh/include/asm/hugetlb.h
arch/sh/mm/hugetlbpage.c
arch/sparc/include/asm/hugetlb.h
arch/sparc/mm/hugetlbpage.c
arch/x86/include/asm/hugetlb.h
arch/x86/mm/hugetlbpage.c
fs/hugetlbfs/Makefile
fs/hugetlbfs/inode.c
include/asm-generic/hugetlb.h
include/linux/hugetlb.h
include/linux/hugetlb_cgroup.h
include/linux/hugetlb_inline.h
include/trace/events/hugetlbfs.h
include/uapi/asm-generic/hugetlb_encode.h
mm/hugetlb.c
mm/hugetlb_cgroup.c
mm/hugetlb_cma.c
mm/hugetlb_cma.h
mm/hugetlb_internal.h
mm/hugetlb_sysctl.c
mm/hugetlb_sysfs.c
mm/hugetlb_vmemmap.c
mm/hugetlb_vmemmap.h
tools/include/asm-generic/hugetlb_encode.h
tools/testing/selftests/arm64/mte/check_hugetlb_options.c
tools/testing/selftests/cgroup/test_hugetlb_memcg.c
tools/testing/selftests/memfd/run_hugetlbfs_test.sh
tools/testing/selftests/mm/charge_reserved_hugetlb.sh
tools/testing/selftests/mm/hugetlb-madvise.c
tools/testing/selftests/mm/hugetlb-mmap.c
tools/testing/selftests/mm/hugetlb-mremap.c
tools/testing/selftests/mm/hugetlb-read-hwpoison.c
tools/testing/selftests/mm/hugetlb-shm.c
tools/testing/selftests/mm/hugetlb-soft-offline.c
tools/testing/selftests/mm/hugetlb_dio.c
tools/testing/selftests/mm/hugetlb_fault_after_madv.c
tools/testing/selftests/mm/hugetlb_madv_vs_map.c
tools/testing/selftests/mm/hugetlb_reparenting_test.sh
tools/testing/selftests/mm/ksft_hugetlb.sh
tools/testing/selftests/mm/write_hugetlb_memory.sh
tools/testing/selftests/mm/write_to_hugetlbfs.c
tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c


