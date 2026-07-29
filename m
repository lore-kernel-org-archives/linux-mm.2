Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC8CC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F1D6B016D; Wed, 29 Jul 2026 11:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5161C6B0177; Wed, 29 Jul 2026 11:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BA36B0179; Wed, 29 Jul 2026 11:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12AC26B016D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:25:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B92214024E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:25:46 +0000 (UTC)
X-FDA: 85042189092.04.D8C7882
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id A353B100011
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:25:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b3XjwPe0;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785338744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZhVGx2M8iOI7b0Qk6w6OOBniMXSCzyM1lZLJihM2lc=;
	b=HEkCmrf6Svuhc5ovQWGRhksKySIRs9yG+VPU37C/Wo277Nnh7i/0jowiXStH4leqYj4b2A
	Dca7irCRY8fQ0vKG57YAreFZSU7OtpBaXQKM4v/IHBnx8E+NMTESZNTKcwofJ3J/aDBX3N
	97aCZrRy0oq7Pqy1gXlWQxP0v7gls+E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b3XjwPe0;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785338744;
	b=zbmx/pNoqVG9TYsbQ7Eaj9T9XkvoT/5fbsJJx8yOChwnirDoPdM9ymvRNvMavSZA/5SKPI
	KeP15HjSRLg3K8z+QbnolvNrE3pFz6XY3pmoWM7NduuCwyZnTJmc/zbaYL8QRMcaf42agb
	n8/TLvCMiXB1amS13V0rW+Jf8OAxjl0=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84e4efb18c9so74892b3a.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785338743; x=1785943543; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XZhVGx2M8iOI7b0Qk6w6OOBniMXSCzyM1lZLJihM2lc=;
        b=b3XjwPe0Qg0lI5AbuVwLkuWHOVsjOceWZLl4jPDZUe2+XYB61dY9UzFrAd0hCkb71b
         8sXhuTb30dBqble62a+Nwq+/zgDCJ8QLdJjOfYbyEEfTA2siyj3NseCCQ+ucDnSPLPMY
         MbWWzHlxFp81mg3HiijYqrbor92Uv/BoNX7t9DuM7RlXLUHcXFvCL6SqbB3gchixRYsX
         2x2Bw19AEIQcp+1pnY+Dt/CBKejXo22WaiWY8B+wCaZ83tmWZxC3Ckji9/AIKR5MUx6x
         tvBTAnpbPOwQX5edpks2xbaL9TBBigK1BdhVOGkG5PsmdGHQy+rdxVzcCBU26Q9tnn0l
         DpyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338743; x=1785943543;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XZhVGx2M8iOI7b0Qk6w6OOBniMXSCzyM1lZLJihM2lc=;
        b=QaL+IfVnV3D3WIF8PvXRdCq6Z44T3eTb229+CfgB7UlT4gClUv2ePc0CBUEkzB8FTX
         Cgx7mF/qZz7ZRVPBEc3dfnd2L+6FPviYycAnC5DLfeB1WDTrgoqaEA5BVkebPU8Vh5gh
         RPAkE7aJZplgP8kUcnuHXVLCvHgJDdzB4RKpXTBl3Zc6lgMASMIlW1Uv+pc/0XnzSDJf
         ivXEyqIGxeNvbzA3T8EKB+sbpmYepu6ewiGhxWLFRwN2Vs2o+T7eYwMU6yRJoTUDKgng
         sg5JYhLYJp63D0MESWaq8nZhvrAi3dQH6apYTchl+kHfd4EYrcyApfhcpuwN/iZ6C2XQ
         NXTw==
X-Forwarded-Encrypted: i=1; AHgh+RrXsYpXFtredQOF2BRJtXY/9kPJ6/Jv1klT5FXBE1/DDqz/DwqNlMyfcBRFpHnZ8bO+dN2deHcwNA==@kvack.org
X-Gm-Message-State: AOJu0YxKbljE5BQcgTwi1+VW3giT/qYidjJC8U9guhw/5k3dHhqO1vkn
	hGgoHsglD7AGTJVV3djj65h7DOohMKffcYJgTLc+8HGKu0I+qH5twxwB
X-Gm-Gg: AR+sD11bBA5/+NaMCFx0TNxlyMpqYCJxE0XO+ruzOGo2wB4tu7AXZ82eQhyRiUFKjm9
	6TM08rz2YIMYCHFTD37vDunhawHBezNXvX2WhyzVPbuSAsnQcckzbM2Rl8PcndjD6C2syaFsT1d
	ZXpjSInYiNLxO5wN8z6lK18sCS8GyXGHqO9w/B6IqjbaNaOe1gaopLdi6LtqOe9aGHXfrI7LBID
	stCgLajG/x1Sl9BbSgu/iMtrZ0nq2qlbKYhbMvLL8ShMXTTnY/kz5rmf7kl+QgqufYirIRZHplX
	dnxBFmFlfpp69Ilog6jZv99cRsjVYbUJUTin/VKR3Vm9qfnBe4b8bF5Y9D47KkISGtSnHpD6IS2
	wuDAVL9+NQhupfEcUbSX85mssYtipkIOlUYsEYU6xCkdLZLwXDXPvuDXvWERyGdyUkKGO5D5RXS
	4QI+RJfJ+wEU7d6GfNmoSbKFL9wTOslQVd7tp5sPXDh0nEzMliHTQ20XZ1VjUb10iubQQ90OJuW
	U6+WkF47r1rD+7NLoUU6mhsYEtjUr6B+ijZeseUsGacuW3rbAWcNHR7Ms5RQjs=
X-Received: by 2002:a05:6a21:3212:b0:3c6:61b9:9162 with SMTP id adf61e73a8af0-3c8ba675ae0mr7418062637.3.1785338743236;
        Wed, 29 Jul 2026 08:25:43 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0055133sm1619666b3a.18.2026.07.29.08.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:25:42 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org
Cc: xueyuan.chen21@gmail.com,
	linux-mm@kvack.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	jannh@google.com,
	yang@os.amperecomputing.com,
	rppt@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org
Subject: Re: [PATCH v5 0/3] mm: make persistent huge zero folio read-only
Date: Wed, 29 Jul 2026 23:25:31 +0800
Message-ID: <20260729152531.1966932-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727113530.5cd347581a66b3279490a604@linux-foundation.org>
References: <20260727113530.5cd347581a66b3279490a604@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A353B100011
X-Stat-Signature: 8q5pruo1c6jfp7qtgy8r5mhgea9d1y5x
X-HE-Tag: 1785338744-648809
X-HE-Meta: U2FsdGVkX1/i8gh/Kr5gfru+wL5ZgB7snONRY5/5+A+9rxI8auj0ID8UV8ybK6hKWFrRPKLSHuyd4i2yVWRNltp8s/4NqKhqdMHqJidjYLDb2NCz4NKrD+DLkYpzIcDDg4CsK4SjhokCrQ3VIMNDuryfArWtyK0KLcRrvcWdFWfZ1lx8jZjcJiwSHjHoaBOBOCNwnb5BXwav6TQ9dH9o68UML78O5Mu4j0g2RH6lOP9ulE/rM5LHKhJvWFlP7iRYcvCyjIz76+3PefioXt29lJa1Umb8rINL1uP7YOTnUC+41XfYd1sZxfY1/92d+/7PuAcjUr7nDPkZY6Hgl6iDKvQ8KeT4pS+3/JL+5Qztr2ESphrgC+oDYeOIV4VFxoIUERQscQDqvSXfGSiPEisW1LpVjvx1SL34xPwQqT28YaTVjXhfyGlJyKCyH3dkqdohHlExeQrpUhKdXoscWxrIR1cOPVWWP1pXao4tTo8QImx9gmQZP8P6jqptlHvVUkGJPFBfzSr7I8RmyUsU8CjFg5UyOkEqRaCYE/CSFH9Es7SfyU1NDR2WQYe/fAaIvZgL1IdOnQQvAbVsyG35m70kdb4yOkMyafRECxxwz5VTtxmhQ4xFCE25ECALuvyvSpdfZ0Y1t98IO5oPrv0jcPsjX15OtArub+oEQiVe01PKwC+U2chNEJrQrnc4UwoecTuNEthc/JCIKmbXCc/eMNu6c4jGBbmPRutSl5woAiWJItFH2BCodVL8IKLf/IAJclRz6DCqV8MZCts3wUTY4/vXgE2M9qUNZjTxwtwouOqfgKRUJXMcOFS6kt8Sl9EFFUovVnynP5u/v6vnZdX86LSKU9hIKCEzpa7nf3LrY36lSMVOS9Q0Umi0BKMoQSqpf2izXyq8p7r8/aPbIMN71er9GbvFuQkbYV7giuCkSoELCdCURE4UzHGQMN8RUWHT2oLDpox9aB0v6/5e+XP+qhn
 U74XKwZQ
 RcbtDtORzN6tUemnV6lI+wj5uUiO4NvoBa22G1czZNaC/exSB41pzF4tioFT4pVmzbHqFG8Pw8gcHzTWm4wMyvhsS/A2dUnqecTUocTJwHfSlsylWVgHiSP3zl8WE54XCZVS+P8zICnVxfbknIPjTTXexruzEB+PzE3IAsw5dc8jQEq775/WkXAwT78ZotjG8MS3RKkGn35awdMi3jHzHY63gxv2UDrrx0HUmPmtURCGQRQX1NTLLaXpe+302KSVuYWmxDAJnade7ST5dbULCdMRUVbvVgqzUkDfpTZ6FDNBbusTl3IPAvWfvlXiGVhvM3h4nJ8qO/l5WbrttE06YbDsplva6HcoCK1QDX607Bzu3eDsffMok/28ksQ90oDW5LTZdARum/xjRsqf1gmwNautqnVDMDrOyHFUTtEMN0dy/xigQkZbnk3uhNNV/0PZzsZ8ig8G9N2T+26d05rpb2dTgeiEDDhLV2bEHXQ1ZYmd/fIlp/6bNL2FMqbPgITunaEUebaKn1HAhbqaaXeFOCbSqyqA+P2hDps6u4OVYFI3HxxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jul 27, 2026 at 11:35:30AM -0700, Andrew Morton wrote:
>On Mon, 27 Jul 2026 22:34:23 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
>
>> The persistent huge zero folio is shared globally and should stay zero
>> after initialization. As Jann Horn pointed out[1], kernel bugs have ended
>> up writing to pages that were meant to be read-only, including in
>> security-sensitive cases. Making the folio read-only in the direct map
>> turns such writes into faults instead of silent zero-page corruption.
>> 
>> This series adds set_direct_map_ro_noflush() so mm code can make a
>> direct-map range read-only, then uses it for the persistent huge zero
>> folio. The helper is direct-map specific, takes an address-based range as
>> discussed for set_direct_map* helpers[2], and leaves TLB invalidation to
>> the caller.
>
>Thanks.  AI review asked about a few things, some pre-existing.  Includes
>a possible pre-existing ARM barrier issue in arch/arm64/mm/pageattr.c
>	https://sashiko.dev/#/patchset/20260727143426.1077133-1-xueyuan.chen21@gmail.com
>

Hi Andrew,

Thanks. The highmem case is valid. A highmem folio has no permanent
direct-map mapping, so v6 will skip the permission update and TLB flush
in that case.

The huge_zero_pfn race is addressed by Lorenzo's mm-hotfixes series:

https://lore.kernel.org/r/20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org

I don't think the MTE report needs a change. Commit 1d0cb4c8864a
("arm64: mte: Ensure the cleared tags are visible before setting the
PTE") added the smp_wmb() specifically for this ordering.

I'll send v6 shortly.

Thanks
Xueyuan

