Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3376606A88D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWr6K2YH
Received: by kanga.kvack.org (Postfix)
	id 0EAC86B05B0; Mon, 16 Nov 2026 08:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074146B05B1; Mon, 16 Nov 2026 08:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A1B6B05B2; Mon, 16 Nov 2026 08:59:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9FD96B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:59:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE5E11608FD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:59:09 +0000 (UTC)
X-FDA: 85441138818.21.421945A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CF224100008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:59:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aWr6K2YH;
	spf=pass (imf14.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794837548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgfzmSZN2nQ6JXjZlO2C+3pfQzKvR/nXPua0MzMaI+M=;
	b=8ej21CHSejNYwuYOxHOAV03AEBuqPF3D853bivgClzlm4vU5WFG5AxrDCrrsRbzCMVnUm2
	DTc7nmCcr6f27IJNvYGwy5CKzljO1Ql/o5GnFLtLxbjusFCyTTjup2/mZO6dCc0GQRHmOx
	eBlAGZUpuakLKBLqQACl+YgElzPmAsU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aWr6K2YH;
	spf=pass (imf14.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794837548;
	b=s0xLP833nOlKmFGQVPDVMMhqLTZNjF/qsQG9YNC4G82Ld1ZfGk9VMjzpIykVqZ8mpwzX/U
	zAFia5yV2YsnVl7MucbymfozOgFBYZ1HG4oC1O0lukkL5DmfOcjoLvPj0KbI0zttY1l1PW
	A7je4t+BXFl4ALJpB8RxpfgLJpEfhPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C9A143076;
	Mon, 16 Nov 2026 13:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DFD1F000C9;
	Mon, 16 Nov 2026 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794837543;
	bh=lgfzmSZN2nQ6JXjZlO2C+3pfQzKvR/nXPua0MzMaI+M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=aWr6K2YHdoXcwe5G15aCFhZ9sJlbcxn9bWbL4b781difDMlYQzJSng+FnIzKjYXQa
	 kP8L94t8V3QaOcUvH9XQps+7mTljEEvhwDEaEIbQk2lBBXHEAmFq74yJz2F1y0izik
	 u7hYsvyWRMV4KIAfnowrzgMKyriFTaH/dDaSLnzEhkJbQkgp0wnSWqvw+bp3KeFxIV
	 je+SE20GH3FBOaebGv8YoBP7i7rGDsnBvJef2R5uPw9+ffHl9acZ1qRXRLVUeW23aX
	 32ckSphdHr/1uOXnvGZxo3CxKWliFJWYH+GIZ+IN7iN5aUgy2a+eAqRSZm6JJpymr1
	 5Op7/OQosYq4w==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory transitions
In-Reply-To: <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-3-aneesh.kumar@kernel.org>
 <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
Date: Mon, 16 Nov 2026 19:28:42 +0530
Message-ID: <yq5ah5hgyj1p.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF224100008
X-Rspam-User: 
X-Stat-Signature: yzrnhrdysdqzygs6ryj6hjtg1fqxb3uh
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794837547-478349
X-HE-Meta: U2FsdGVkX1+75ms6ff15Z0mis4Sz38bZzlZsD7ggQ1Egrv4ZWM6cig8q5I7A3OtCIbDx45WfATE4lDXNnvm8GamfoC4FtnO4TlWv7F85MFbAl5+ZEh0doODr4/vFG9qODBRS5u8d5aEtLPpJJ8bhsQ9GabaqdrBdkWzyaHumtkyqjj9qOs2yRvPBn/lQXxRpRYA4aEGY7Uzop2i3VYp065VW5/2mDk54/+7zdtdpXAq36La/GAQPsKDlJlPzmkv/JxnkCHcLY0pphl4hiNrUqfa/6+w1iNgEtJR+bn8GAk4LsMAN/Sd/R1uye+EFXNkxaMvpm94Iz5jJS3Ijv7C5KdaNBEFvRa/Aj9uQlxoqN8Cp+RHeN5ei1pLflGPaF1m4ju2fJbBtTnWp6UFyPGRrgc+kbEUKz3vclPjaUFd+yfl9775sr5WgkBs008NW5+CM4nUKCs5vmSH4utlUdEcms8FM8q5UeiQydaPGDVZb8rZiLfhamL/ygE7h90lcR0SKhntqYJRDJBr7He/yEDROrMc54XyTuCt8xJCssNxUUljp7G8vRip9102MYXrLeeqcGqAfvxlh5JtsneUgCbszqysFLMsD6Xn+vIoQ1p0TDWlHcaVFk68zQJSjKybaACYIf1xZYkLKI18tHTR/j2L3mLM6T0cQJUVG79/J/sfqaS81jxH5divvOQDjQJxAOP+1avwjVbc+wc2N16IUHBuuJnXFDiZFc4usJgN6hucaBujN32nJD7l2JbmlhpRsPU/yWz23UJI5Aktd1wt3S34LpJgsD5Y5PERYykoCZ4Di3QZ71j2r9PXnl6AWRB4oZRo0J7DGxDmd5fWtM/Oo6cop6MDNMnRrCCcOTvoAk+0JKHZIk5VeqqD3RmlQpyFRsJg7R7Vb5G7yQPSAlQmxTYARNYANZ8BJKcQHch95+DpMu9WHWFCPZNjlnBr6t7/tbVciZe10sbn38giwGEmD0Wh
 Z0yUC0YM
 o9CXePkfd7DeQZYbTlN1uv6xHQs4vjaCPVQKMo8XYhANhNY6JPDzDbz9QWBGnGB2T4Zw94ZmlaZSZU2NmnmBTdlIeaad+l+FJMLGykilkFZVoJJJnpAlLAKxFcr3l/5rdk3WkXGCp5eIhQfAl1SxVYzPFicv3FeslTeZtRd/L+0/xW5TMMUUINmB/SD08UoAyRcdawPMaNrU/Va2WX5UsKu+ARFiVnz3iY/Lgo+/X5VBMfSHOKb/Piaz+P5PTH8OJJKwdnVWqe0EcfkqB5iMPbAH/1QQWDcyS3y1f+GcY94CpiTfjPBCvBTMOFeyRt/dF/cJARCUm2rhVD9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fuad Tabba <fuad.tabba@linux.dev> writes:

> Hi Aneesh,
>
> On Mon, 16 Nov 2026 at 09:12, Aneesh Kumar K.V (Arm)
> <aneesh.kumar@kernel.org> wrote:
> [...]
>> Keep allocations on platforms without memory encryption on the ordinary page
>> allocator path so the original GFP constraints, including __GFP_ZERO, remain
>> intact. Remove post-transition memset() calls that are now redundant and
>> explicitly clear allocations on paths where no transition occurs.
>>
>> This intentionally makes every private-to-shared transition destructive;
>> callers can no longer use set_memory_decrypted() to preserve existing contents.
>
> pKVM shares memory in place, and a guest has to be able to share
> memory it has already set up, as Vincent pointed out [1]. That was one
> of the primary reasons for in-place conversion in guest_memfd.
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/avro44jUWOARFzul@google.com/


Thanks for catching this. We discussed it before, but I reached the
opposite conclusion:

https://lore.kernel.org/all/yq5a5wzw2ree.fsf@kernel.org

My mistake. How do you suggest we handle this? We want to avoid zeroing
pages multiple times with different CoCo configurations. For example, to
allocate a zeroed page, we currently do:

alloc_pages(__GFP_ZERO)
set_memory_decrypted()
memset(0, PAGE_SIZE)

Should we do something like 

https://lore.kernel.org/all/yq5aa4p82sqt.fsf@kernel.org/

-anees

