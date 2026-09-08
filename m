Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBAFC79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06FB6B008A; Tue,  8 Sep 2026 06:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD456B008C; Tue,  8 Sep 2026 06:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4DA6B009B; Tue,  8 Sep 2026 06:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED656B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:21:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A558140491
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:21:41 +0000 (UTC)
X-FDA: 85190203602.24.02B613A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5F6AE80004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:21:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=naAVfI6v;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788862899;
	b=XzMpHAC53bIUDBBgO7fk4sI+VA3p2K/RaU8x5jC4xzTjhRBkU7O1P2oOsvoVoQqyqxxFCS
	ju0On++QCvB1jPYIE81xnvcLi+EBJa3JEzPZYzT52ph9e+3c6GE1Sw1IlaM+8eFwWE87zM
	t7fLygmUUOlsHglS4/BoUnZ73tFYSOY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=naAVfI6v;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788862899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trKkVjLDuoNyZ1KBYX25zdJ5VlGPOhjg9ThffyQDe88=;
	b=59SJy+bjh14alTRb7w4cW1vIJbnd4rzPuRHmcxwk2qxwQLLz2AjoajlspGwRSmQr/+xILf
	6AGGV+j813i5rz3VY/DdRGAY5631XWHrGFMZD0+TAL/LgOXLIZXgfIen/tIDkUldOeJ5V6
	kX7krJhUzADQ+Qyr2O16zMC5SsKrY+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BA7242A1E;
	Tue,  8 Sep 2026 10:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E441F00A3D;
	Tue,  8 Sep 2026 10:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862898;
	bh=trKkVjLDuoNyZ1KBYX25zdJ5VlGPOhjg9ThffyQDe88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=naAVfI6vDSA2o8yuJf1a9zMvqUkjjc3EB/eQ0HaObPU5xZO+BguKYHo0/BI8FO5wO
	 OPTkGvC+MxQEP7eTKyh7XFqvIXvpiVZlXuZht6DZBEg6i0YsBjd9RbSUg44cqDUg/W
	 DYi/Ymu6EFJDSFSaOdKJh+Art02RzAW1vXucjI/m+/rJbatHGfjFKKdlzVDGw1YiWx
	 oqlQi4rtudxQygI4tlVghW/3tam1Xjso8WGESLncynmqsA0rQTmaGnquHA1Uu+db/a
	 JmLA+Y/hiXysYeDOKJ1KBFXVnuQ9At4J7hZA+880iOB+OSFGQkf6N8ABwn4Z7BrKUf
	 xUnf53cNE74xg==
Date: Tue, 8 Sep 2026 11:21:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: "Liam R . Howlett" <liam@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/vma: cover hole filling through
 __mmap_region()
Message-ID: <ap_gTfb10dw0wx91@gremlin>
References: <20260906144100.849288-1-hi@tychen.cc>
 <178886112560.138404.17741948638665342936.vma-v2@tychen.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178886112560.138404.17741948638665342936.vma-v2@tychen.cc>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F6AE80004
X-Stat-Signature: w6f6hfwmu8ahmnwcx9h1q1zm3okapn48
X-HE-Tag: 1788862899-850977
X-HE-Meta: U2FsdGVkX1+Z87oVG1Sqy+yqt7g1K8LaCoT04Yi//hPIS3rnieO1H3UBzt4ttBwRHMypxBCwyapGpTTP+YRDSmw0a0uWjN9/i4hgz0P2au0aU5grFiJRgJqboxLekD1YN3rqIp+YMagPFU8S24XCbQqKmuvynVC0rH1//3RjHq0ms/tvtSwfT3VjZ8LudfotAD5G9gG/LUSnI8dR5m8ovAtCKNc1Ypte5pzvK5uuY1nP992wBa2hT+3XJ697Mn6ntJWle+ZCcO2d/X0dXBNdyFxPiREQfsOL0uuZb/XDiTNyMMvwdSEz7XYi2IpECeoZ4NkCDqggI+LOOd09DrBovaI86iyfo8Xg+LuiIZq/4ylgC4IlMHqAx3+EtwOwsfzTGuXbT6UAOr7pDMUJzZnojfX8tDPTQYhBdVNcriIzj2inXVQ++6bsSShv+t/Zhi5vjKQVq9EWoTQ2hD+EPxnJKRFp0ZrYaLMAATs5zJYQqWb/BRQTzTBOxZ6R18IORbQb2711eV4FHnV9qio2R00hmIWbth+Yg3KiFEqHwgIjmP6SW7iCQCkp1GE6jZHnvFmzWdiA5c+Gjne6dp2HyNwH67VIQTOJK+/kEdU2+/oIuD8Ak9VfSeuH+u6lgiMVA2pa9ovqsmD0u7//Fpt3XhM/2R7dP5MrHqY9uXgxv7/tHWVBQqHD68JtQPJoYBGZzFcmEnwI68moPN/kVMz2bapaD4rH8bKmoUZwvh5jYuJhLxutq2Jz2h1MfokMwFuKc05871x6MTLAlQQphkkKfR+lOaLOpmZf+VduUDTjorvAsLjVjr2lnhnFpuMvbnclwttxaZ9qy2hw44gmbCNKjq9Tul0MpLwsD94JoFpgPTy8Vg5ND/vn1eCAhlhkRgAAayiRWbMUrwjtSOIgIHHS4p4dfGyLyLx80QBdcowoC2O00virU/knz875771vW+oT8UdivQ7T5Pw3/ysyFNYJJ1J
 HWplt4PU
 OZv9QOnE/gTT45HreMtLbw/j/S7b+k0yur/0/r4I6/g0NQ/TY2divJRKSLrfBHpI5TvpgjiUAs3Iludjfhb9jstzw+l7dktRFd135D8n/AvTEIZjHxFZ5dUraRh3pjiQ827s9kDcNS1H7lpI7peb/AsHik8ALnlFrVbL98RfW4HgD+KyauxxWZAch/Lf9smR9nWrBckqaqt44nEx6x4qaYQ+uI8DUb9KV8cdLNq8m1bGpQpKxa008A7gI7vui8J9AXkxsSQCCVdw2NzBhdrPKuB9y2h48EpXj0DMpcX/AtCxKe8nn/IF/AFBzM9JVAjf0sMUrY/pOgETGuKM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 05:55:15PM +0800, Tianyi Chen wrote:
> The mmap tests extend existing mappings one neighbor at a time, while
> merge tests construct merge state directly. Neither exercises filling
> a hole between compatible mappings through the mmap setup and completion
> path.
>
> Fill a gap through __mmap_region() and require both neighbors to merge
> into one VMA. Repeat with only the new mapping's execute permission set
> and require three separate VMAs. Check boundaries, permissions, page
> offsets, map_count and cleanup.
>
> Signed-off-by: Tianyi Chen <hi@tychen.cc>

For future - please always send v2 patches not in-reply-to anything :P otherwise
mails get buried.

Otherwise all LGTM, thanks for addressing feedback! So:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> Assisted-by: Codex:GPT-6
> ---
> Changes in v2:
> - Rebase onto mm-unstable, preserving the new /dev/zero test.
> - Rename hole_flags to middle_flags and describe each mapping's address
>   and length in its comment.
> - Remove the redundant hole, per-page and outer-boundary iterator checks.
> - Use const bounds and named booleans for the middle VMA's expected execute
>   permission, and separate assertion groups for readability.
>
> Validation: all 29 VMA tests passed with ASan and UBSan enabled, built
> with clang 20 using the existing VMA Makefile.
>
> v1: https://lore.kernel.org/r/20260906144100.849288-1-hi@tychen.cc
> Review: https://lore.kernel.org/r/ap5pmX-RddQ-c90O@gremlin

Thanks! :) very nice.

>
>  tools/testing/vma/tests/mmap.c | 68 ++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
>
> diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
> index fa73faff226..53e4abe6a63 100644
> --- a/tools/testing/vma/tests/mmap.c
> +++ b/tools/testing/vma/tests/mmap.c
> @@ -45,6 +45,72 @@ static bool test_mmap_region_basic(void)
>  	return true;
>  }
>
> +static bool mmap_region_fill_hole(bool merge)
> +{
> +	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
> +			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT);
> +	vma_flags_t middle_flags = vma_flags;
> +	struct mm_struct mm = {};
> +	struct vm_area_struct *vma;
> +	unsigned long addr;
> +	int count = 0;
> +	VMA_ITERATOR(vmi, &mm, 0);
> +
> +	current->mm = &mm;
> +	if (!merge)
> +		vma_flags_set(&middle_flags, VMA_EXEC_BIT);
> +
> +	/* Map at 0x300000, length 0x3000. */
> +	addr = __mmap_region(NULL, 0x300000, 0x3000, vma_flags, 0x300, NULL);
> +	ASSERT_EQ(addr, 0x300000);
> +
> +	/* Map at 0x306000, length 0x3000, leaving a hole. */
> +	addr = __mmap_region(NULL, 0x306000, 0x3000, vma_flags, 0x306, NULL);
> +	ASSERT_EQ(addr, 0x306000);
> +	ASSERT_EQ(mm.map_count, 2);
> +
> +	/* Map at 0x303000, length 0x3000, filling the hole. */
> +	addr = __mmap_region(NULL, 0x303000, 0x3000, middle_flags, 0x303, NULL);
> +	ASSERT_EQ(addr, 0x303000);
> +	ASSERT_EQ(mm.map_count, merge ? 1 : 3);
> +
> +	vma_iter_set(&vmi, 0);
> +	for_each_vma(vmi, vma) {
> +		const unsigned long start = 0x300000 + count * 0x3000;
> +		const unsigned long end = merge ? 0x309000 : start + 0x3000;
> +		/* Only the middle VMA in the non-merge case has VMA_EXEC. */
> +		const bool is_middle_vma = count == 1;
> +		const bool expect_exec_vma = is_middle_vma && !merge;
> +
> +		ASSERT_EQ(vma->vm_start, start);
> +		ASSERT_EQ(vma->vm_end, end);
> +		ASSERT_EQ(vma_start_pgoff(vma), start >> PAGE_SHIFT);
> +		ASSERT_EQ(vma_start_anon_pgoff(vma), start >> PAGE_SHIFT);
> +
> +		ASSERT_TRUE(vma_test_all(vma, VMA_READ_BIT, VMA_WRITE_BIT,
> +					 VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT,
> +					 VMA_MAYEXEC_BIT));
> +		ASSERT_EQ(vma_test(vma, VMA_EXEC_BIT), expect_exec_vma);
> +
> +		count++;
> +	}
> +
> +	ASSERT_EQ(count, mm.map_count);
> +
> +	ASSERT_EQ(cleanup_mm(&mm, &vmi), count);
> +	return true;
> +}
> +
> +static bool test_mmap_region_fill_hole_merge(void)
> +{
> +	return mmap_region_fill_hole(true);
> +}
> +
> +static bool test_mmap_region_fill_hole_flags_mismatch(void)
> +{
> +	return mmap_region_fill_hole(false);
> +}
> +
>  static bool test_pure_anon_dev_zero(void)
>  {
>  	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
> @@ -84,5 +150,7 @@ static bool test_pure_anon_dev_zero(void)
>  static void run_mmap_tests(int *num_tests, int *num_fail)
>  {
>  	TEST(mmap_region_basic);
> +	TEST(mmap_region_fill_hole_merge);
> +	TEST(mmap_region_fill_hole_flags_mismatch);
>  	TEST(pure_anon_dev_zero);
>  }
> --
> 2.55.0
>

--
Cheers, Lorenzo

