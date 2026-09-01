Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A60BC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DE06B008A; Tue,  1 Sep 2026 16:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445836B0095; Tue,  1 Sep 2026 16:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3834E6B0096; Tue,  1 Sep 2026 16:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19FD86B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:14:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C38E1C218E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:33 +0000 (UTC)
X-FDA: 85166296026.11.0B98F94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CF04B4000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbice+wL;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788293671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEZEmYZMoaqekOPk8qqP2ODpRIO0XT0q9KzPXapNk2g=;
	b=4d9I1ajBl8Zatna0EQ0IuNtsOioru/nyLfEbsbK2K776HU3ps8+zJsJOya25wsE1MlGtNg
	nKKRHC/7bdwXcMARG7qzO/CggjUXMhh9tbZo3d47CVtWt8PXnJJ2sdAg+fWCnILPYLxbyj
	uuRl19YAVMBXMBBfPje6EXJT/IxgNr4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788293671;
	b=c6+EjIPp5i6pabxdqqMJ4LTAu852figas2CcX4sEjAa+nrtTSRTF8/Bj39GMA3+c0v8X0X
	Y9PrdayKkQOqVRC7DcNAGfu0+szQX6PkKQIwgxOsWZRTCJb6qgnZP2+xOzGXUgciD3WY5F
	00OdsvvJ81VtrlP84M1GBJrqZWquZUw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbice+wL;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B951600D9;
	Tue,  1 Sep 2026 20:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F541F00A3A;
	Tue,  1 Sep 2026 20:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788293670;
	bh=aEZEmYZMoaqekOPk8qqP2ODpRIO0XT0q9KzPXapNk2g=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=lbice+wLj+lCT8QM98ULT3hhnoph1ybVba4ki8BaTAtUERzwAFL3Q3ECL7S5NT1Bw
	 af2GJr4OE3roJ0CS54vKzLOApz5rbUWlstAZhqaAhUNZ+JAnPt7rSJsk7J5froWi6z
	 n6f784ysOfk8nLzxDJ3tgE66oJGb46pYShdqP6dF53A4x5gCcAGnWTkm2AlG7GUgbe
	 7psRiBXFRCeVSoQRgDSVpVkwPSeHbJYdpqYtqhOmr7exMFXhudxgQCLL7hmUTZebm0
	 wspK7+0gVSANfLCupzkEWgZLef4c9lQ7lAmSrFa9KB3Su9TirvLHRfJcxRMW4GPASs
	 HWsZUWUQSNuLQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 02/17] kexec: Extract kexec_free_segment_cma() from
 kimage_free_cma()
From: Mike Rapoport <rppt@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
 chenhuacai@kernel.org, kernel@xen0n.name, maddy@linux.ibm.com, 
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, tglx@kernel.org, 
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
 akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, 
 kees@kernel.org, thuth@redhat.com, gshan@redhat.com, jic23@kernel.org, 
 james.morse@arm.com, ardb@kernel.org, leitao@debian.org, 
 yeoreum.yun@arm.com, sourabhjain@linux.ibm.com, coxu@redhat.com, 
 tangyouling@kylinos.cn, hbathini@linux.ibm.com, adityag@linux.ibm.com, 
 ionut.nechita@windriver.com, liaoyuanhong@vivo.com, seanjc@google.com, 
 fuqiang.wang@easystack.cn, makb@juniper.net, piliu@redhat.com, 
 ebiggers@kernel.org, jbouron@amazon.com, mclapinski@google.com, 
 me@linux.beauty, graf@amazon.com, bgwin@google.com, robh@kernel.org, 
 takahiro.akashi@linaro.org, palmer@rivosinc.com, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260826092541.3905933-3-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-3-ruanjinjie@huawei.com>
Date: Tue, 01 Sep 2026 23:14:00 +0300
Message-Id: <178829364020.3691424.17302958503793700435.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: qid5fruikmq4541u6cf4bzuuc1we1quo
X-Rspamd-Queue-Id: CF04B4000E
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788293671-415689
X-HE-Meta: U2FsdGVkX19bPhuJoT0P0J/G+cHU9g5s/9vnVmYFUByJvxk1KUTYRbgIWdCWYS9LLsNt/Yf3qiNLrBf0U0wozwbnlQqxiBsNnHqO74A4UFbd9TuFQvRz1WDXuRCH2scheGgO8Ww+tcuwmbI1n/Do2hfci6aQFOUPILDzuy/zTiWrBgZFUEt/qIjxDxNutSdeRjbjrIt/phKflQUoyDT3P1J51CU6Pvr2ZTujNyHogzZtJGmUf1P+eWI2cLsYjTCyiTFpwbwBY6+u//rYT0EZbMEq5OVPsH9+pSvIeG0UOZ3fZPJhUso+ITPyMJwerVB8GGlEBZ1kMgB+cNR55wHosA5YULU6t4KnsaW9INo2A7GqYzxYuTyIibT9Mkt9ttcP54lM7BvXEuNSvpobYeSn/pW/Zg8WOvMDLP9Cce05c/S6ZmszT6WgyR/SE6CmFNnhpULCD2VTI24U661LBw9pQMsGyJ2ZdudSCArOQtAS5gbPyRUieFXY6hHbe4wMP3i730mrAWLHQ4kESwaDvQfDQg0NZwXDMHd7RfQW9tuu8vmAOEsaB2c/SucKLX1yJDWKPL0/5jaoAJZW+eWgJMLkg3ReASagtz3UxwNXOmOgtG3xJqGRVc/36yz/15s6STsLAVFg4FJSldDD8EtGnaqOPSgQQoO82KVORDDxi2IqYs27bOqzX5+XJuMYmuxm5cRc4O/IGYEpmUgcXu2a7iVnZ/f/RR0E9Ji96TnSwn3y6givOXEICmY+cUWomSh3dHXP9mBICSDxGX1DCo7fmLcvXGXhNTl07WvbTi0ggyytz+BvcBLhqyWyOpbxr1OOR0PDDV3mXScwZeHttxeGpDD2pvyOKpHL28wxAkcFSSpJ/fYwargGxJBE1Q1efZp2y4i7GPLRFWpmD/2McJ4YtNyZAVuxXxAZfV0xiuS7LIFbmOe1Zrlmraq64EISGb2qnzneO+jiYjgmiWvajtKSpVf
 htmFaunw
 Vjsu7DCPuxNb9zupBHvHf/XcLHoz2krkesY5ucNBMn6ci+69tL2DtIr05y7MjM6Z5pjxNdjAGJgaq7uem3ZdC/lq3QtXJ5c18PwI7Pp2S2VNMnDO3vu2Lqyas2oHa2lSNjd4vjHgXgOCJnB58Hr+AlwzveM838mKq537DMrixzAoBqRDg8nKFidtIUxL/XVpa1BlM3MeOiUJQCA/vpSwQJgsDpQzMXI8sV/+YZcAb4ysLEqYQKrM0umRRcKWreFSXKW6nlu/S8aEMd7Bp0ef9+9iDyTd/oJgmppVFjiNDhgB+fJ6RMeN2+/3VTLbBA7TpCDKWf7KU3BmQGX+HZaVpV3YgXWOuu4n6k2JKqx7qSOdoOb1TZYq0J/8UtMXRdKz3bJFXAIS3WlW5l7T5eNEchEi+h3KdTaAwFp9BQrMj/+Y53/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> kimage_free_cma() relies on image->nr_segments to iterate over segments.
> When an architecture loader (e.g., arm64) truncates nr_segments on a
> mid-way failure, CMA pages allocated beyond the new boundary become
> unreachable, causing silent memory leaks.
> 
> Extract the per-segment freeing logic into the exported helper
> kexec_free_segment_cma(), so that architecture loaders can release
> individual segments before nr_segments is truncated. Refactor
> kimage_free_cma() to loop over the new helper, preserving existing
> behavior.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 83c296c0eb6cc..d7c83938dfd3d 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -533,6 +533,7 @@ extern bool kexec_file_dbg_print;
>  
>  extern void *kimage_map_segment(struct kimage *image, int idx);
>  extern void kimage_unmap_segment(void *buffer);
> +extern void kexec_free_segment_cma(struct kimage *image, unsigned long idx);

No need for extern, even though it's inconsistent with old declarations.

-- 
Sincerely yours,
Mike.


