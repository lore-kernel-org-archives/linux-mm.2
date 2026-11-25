Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45314606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LuStO290
Received: by kanga.kvack.org (Postfix)
	id 4809C6B0A45; Wed, 25 Nov 2026 10:07:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4579A6B0A47; Wed, 25 Nov 2026 10:07:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347626B0A48; Wed, 25 Nov 2026 10:07:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 024C86B0A45
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:07:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CE2580F1C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:07:04 +0000 (UTC)
X-FDA: 85473969168.18.AF795DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id DAD1A2000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:07:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LuStO290;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795619222;
	b=fupJl75lvFi5P7PfiCpd9iqa7AMt7rfdy0ltXBv2bH/ud+O10po7KAwNeMJ/sxZWyUXfMs
	UWT7kceuuTAkXMDLfTOxxhjCuEqvfEo+ken/jlCTAKbaQ4x6j38PiJJzSHxPXXXEny4VaB
	wLZ0Y6ysyLT84/RRTEbL6JJMPqNB/Rk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795619222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TV8CEC+IGmk7QtdtCiAfWjmfVuptrIsaCGHkVYntwg=;
	b=4cYU55pUrA+O2gpRksk9DTTtwIa0bOEwORghVUeaqP49kw+B+qFep2VQl7jXO/34nXI6R0
	NNqQBN6rAeX/zDq7IAJXJWnufIOqRoEujAR8ATJ3PYZN2E4PGpHeoO/rVkW2z6x5WkqeiC
	GHgiiBwjvAItuLPQV3OEabwCfZf+hmA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LuStO290;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795619221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TV8CEC+IGmk7QtdtCiAfWjmfVuptrIsaCGHkVYntwg=;
	b=LuStO290vxxL25UjhkyRJVgYmtEu+2mj8SShO++mcvyN9zC8npog8Tx1j6UOe/9J85r0++
	akmLJVu6jnSLhowOWgSEPOsAhCPEIkF3GfzoY59/dxHAa0XJwWpqR2YMGpy1wFCzk3wLXN
	+qE9FQErslJLKvXGJtwJmAMeksMMvBc=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-SG5dtnfENQqFc67-rCaDpw-1; Wed, 25 Nov 2026 15:06:58 +0000
X-MC-Unique: SG5dtnfENQqFc67-rCaDpw-1
X-Mimecast-MFC-AGG-ID: SG5dtnfENQqFc67-rCaDpw_1795619217
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3ab36a71c66so20865931fa.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:06:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795619216; x=1796224016;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7TV8CEC+IGmk7QtdtCiAfWjmfVuptrIsaCGHkVYntwg=;
        b=fR/ZkO2p4HHlyLYwyl8FB/mB7BO4oXOqnPRVuRGAJ3gdbY9zVaqw63cPxyN1kRtP8C
         FIIZZ/3NsCJ5x/4JnTIvCcWUvsH3tc4wciYXzM3hE7KKCdp5yT5n3tC3arTmGmSKrzcP
         e4CQ9EEVGST61NjR3IRHP9YdgDkebLq3H2cj+xKlBrVTkU17coWX7LSMbl/ULmr2alen
         xuqVb4zewBbtD7omFhVbPXd570/xT2jyypC0dTBJWhOcwCocmd06M4f8Zrs2uLKMXK7q
         lJI6QJRA9Or7vlqu6uiLauem41vS/baN9q4O9Z2E+7bWxsC42BUFdfirg83Tpk0TSLY2
         ty4A==
X-Gm-Message-State: APuU4Z+etVvudDf8/AF3jUiVNj2sOQH4gcK3bcTyDOd0kvRSz/EDdel/
	HjgiqZ5hEfaxk2H0EiAHLprBE+9TOHa/0ZKkBlLwzmznFwyiAukQmG9w2pSo1SRRegx9Wl7q4q6
	1kgVaNfk6pGLavKeBpPs1/2Ijb5CqhcCV92RNdyxxehTRcSUT9HY=
X-Gm-Gg: AZFdTZemXKPTy5hNhdE7kAztvXEvM0jwjI6qC9YLZy56J3mUpbPBi0dAV+MeZg2Doeb
	vcPXrnSAtzHhnJw8Bg6wirqWnAcGk2RMRtLPANB18VTWf0t3Q0A4cMEm3CqfJImQHrX5oWRZ09G
	c83XaS95gxtpLnnylNatk3GBIXe7pdj9o3NIkB66aWMo8bBxvnNeBZi2nc6aNwiDBiBEGF8VCyC
	1dfmKqdbOvijReh7Vyqxi2CElT+Bggml4XZzQU/tOmkEJ/heBJdrX4IJ5eCz/ZPdszCs4TW4yR7
	Kzt10LK78omehBYUbOesEn1ffsygjrCesgExe50QG1ySAB8gbGJlUG/rf9eCnsolhniKxvWtXbP
	Mmu55T2aFDJEtD12KhdtByfaxpgvY6MR+x0zcJ6Y/TvAyignicFwgpd4f+qaog0ONw83nZVTwaS
	w750Mc
X-Received: by 2002:a2e:bc02:0:b0:3ab:751:6ba8 with SMTP id 38308e7fff4ca-3ae7fab444amr50263341fa.28.1795619216524;
        Wed, 25 Nov 2026 07:06:56 -0800 (PST)
X-Received: by 2002:a2e:bc02:0:b0:3ab:751:6ba8 with SMTP id 38308e7fff4ca-3ae7fab444amr50263231fa.28.1795619216125;
        Wed, 25 Nov 2026 07:06:56 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae8053568esm50270861fa.25.2026.11.25.07.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 07:06:55 -0800 (PST)
Message-ID: <4a3f734d-bd8d-468c-bfd3-15431ec22ad7@redhat.com>
Date: Wed, 25 Nov 2026 17:06:54 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/test_hmm: invalidate all mirrors on device-private
 migration
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Aveline Noir <jm5905938@gmail.com>,
 Ralph Campbell <rcampbell@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Shuah Khan <shuah@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 stable@vger.kernel.org
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
 <awbtZjtII9h1oJ5R@raptor>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <awbtZjtII9h1oJ5R@raptor>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vTML24J86KmIwAepNechop3_YaVY1fbNcT-LYvCs6U0_1795619217
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DAD1A2000F
X-Rspam-User:
X-Stat-Signature: bwa1jdu7m14wbeqtka95ywxmk8j1gun3
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795619221-799704
X-HE-Meta: U2FsdGVkX18X2qd8B+yuzdUlWM7m9QPCzEVgxwSt6cLAi7IgZtMPb0tUUt59zruxcZCXEUgdA4WGRFO8MnTqCvHsnQxERBPsrT1bywE8AiK7Xatc/ha+mxXGWaT701t24mKGCu71ZYren30kPczmALGGWhpxgAiVUXO3gcncObpjd/8GKakbR5ink7G25r2akXeMULl3c0jBaCtAtNud+/h9dX+mkuSppbAoS4uOVvt29wa/O1A3nQ3jDwvTQ/KCu07SVm1ZcRdcyuFBFWrVkWEpg8Va9glOaRDf9Amuxn1402Df9l8Az1/6wrI2GfNeB6LNgjV6kHQ2w2rmlZ8ygI2O9bksZKgxb5dHso9ilnTFSIJk/vO1T+0Hox1hxUeYfd0u7k9zJKEMBW5GEDN3EVE/EoKrmtawSImhRafBKlGoUrSZ6yd6QOPTNZ5iPuE92kH/iUR2QnPF8S25AFEMCDuXdNt9Ac4+V6w2l2yTTfoOkpF44107DITG4yTkCK9s0zfxsHKWGWM3Zv3OwksTwt2MJ5QlESi06P+ulPzw/iomvxbtaBZzwSR62Ydl8p6oJbNTfytEJk4DSdivzjitgXDt8qNdaf7SGLo5adV6cqCCqsoIpmgY3EhATrCNrLd3taMWSzbeuos3p1sjuD4gpKXwk4HINTNCD9DGWd9l+hzlQicycyPZnHw6UwBVsL+emCPXOAyTogBD4GwujwxIkoEHNU2lO9B2yHMB8XIM1ofqPjo/oc5NiiXS6vZR5V5XYD27cUbHYTVT3U/UjYHmWJVi+pibIAa1Dgtf1tiiIEorZTGSlv2keSnuriQEu2lsh7MdKz19mYPL/GgTPHa1MTl5u0e+6Z7ivC5aZIHqQ92QzWpupbg7UhAlR4GNuCIc83sPXkxLPwUiMqhT0ZUeOIwCl5bGTkn+z9FqEd3Yz4sStQt5fsRSmQlC/fC/LUECVQ9zDPOAp60CU2ajICe
 LvrJcFas
 KdvnoAaF0YXXrV0eT6uXpCS2KjXuuokiEl8WrMfFo5jLjbHeAHOIkDMpsYBViIRhfI8br/U0SaitQDoTDm4EHIxea+Gs9BOBwQp9Z+DJO3SevpItz8TdQtXNIX21Gtewtln7gERY+ds59dCNv/f3dYSkSg9wjPX7BuEWi35Oj2YcNRBqZsuReQ+vMe5xmXr8jk902jbP55w8c9YYf5f4NvFTkXCmMZVspJ4Nbedlvs8vFjT1LuZeLcNcm9cTD4d/Nu6uUUf8VEGhme3d98NDCSRARyUJl5xpH7k4e7nLU1Puk5RbpHumlF7xWxIQFEKEuXTU8SvHjWoS2LAiouCVRxBmotg6fk65iqoBgf0cbQsdz3yOp5VhtAFUkL6zYFt7kZZ6mxNG4gzj1suFhPVwJP4XtqutbG5v/jytzACBPTQLU2MruY7oERCMDndYqz1ECOb6eblAchwto56ZWYzztpuNxnl8Sf0w4KMtd//UHHG4tlZgYnYnKd0W2K2Xqhq2mfuCbMOCPDK3P0xpwNO7TGPagV1dZ0Ii1F7p4K+tX3gh5BOjH7ZPuYXRrAvLDqBOl5uTpx3Rp2cO2Yoj5elKE9JA7wVX/xV3rQZrLhoKTkyoYWEjLlN09BtbTpz8cSaQBLpg2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,


On 11/25/26 16:15, Alexandru Elisei wrote:
> Hi,
> 
> I tried to test this patch, applied on top of v7.4-rc4.

FYI, I am doing changes to test_hmm.c invalidation handling and will fix the two fd invalidation as a follow up also.


> 
> With the changes to the migrate_anon_huge_fault test, but with no changes to
> lib/test_hmm.c, to see if the test fails without the fix to the kernel, I get a
> kernel fault:
> 
> [   95.571212] Unable to handle kernel paging request at virtual address ffff7fffdfe00000
> [   95.571221] Mem abort info:
> [   95.571223]   ESR = 0x0000000096000004
> [   95.571225]   EC = 0x25: DABT (current EL), IL = 32 bits
> [   95.571228]   SET = 0, FnV = 0
> [   95.571230]   EA = 0, S1PTW = 0
> [   95.571231]   FSC = 0x04: level 0 translation fault
> [   95.571234] Data abort info:
> [   95.571235]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> [   95.571237]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> [   95.571239]   GCS = 0, Overlay = 0, DirtyBit = 0
> [   95.571242] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001cc71d000
> [   95.571245] [ffff7fffdfe00000] pgd=0000000000000000, p4d=0000000000000000
> [..]
> [   95.692002] pc : __pi_memcpy_generic+0x110/0x230
> [   95.696623] lr : dmirror_do_read+0x7c/0xf0
> [..]
> 
> decode_stacktrace.sh says that happens in lib/test_hmm.c:503.
> 
> This looks more serious that the use-after-free that KASAN reported.
> 
> With the changes to the test and to the kernel, I get this error when running
> the test:
> 
> $ sudo tools/testing/selftests/mm/hmm-tests -r hmm.hmm_device_private.migrate_anon_huge_fault
> # [INFO] detected hugetlb page size: 2048 KiB
> # [INFO] detected hugetlb page size: 32768 KiB
> # [INFO] detected hugetlb page size: 64 KiB
> # [INFO] detected hugetlb page size: 1048576 KiB
> TAP version 13
> 1..1
> # Starting 1 tests from 1 test cases.
> #  RUN           hmm.hmm_device_private.migrate_anon_huge_fault ...
> # hmm-tests.c:2156:migrate_anon_huge_fault:Expected *(int *)buffer->mirror (0) == (npages - 1) * self->page_size / sizeof(int) (523264)
> # migrate_anon_huge_fault: Test terminated by assertion
> #          FAIL  hmm.hmm_device_private.migrate_anon_huge_fault
> not ok 1 hmm.hmm_device_private.migrate_anon_huge_fault
> # FAILED: 0 / 1 tests passed.
> # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> 
> Might be something on my side? I'll investigate further, but I'm not very
> familiar with the code.
> 
> Thanks,
> Alex
--Mika


