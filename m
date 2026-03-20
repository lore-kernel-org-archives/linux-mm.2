Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B7B2108B8E7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48536B008A; Fri, 20 Mar 2026 06:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21BD6B0093; Fri, 20 Mar 2026 06:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A635F6B0095; Fri, 20 Mar 2026 06:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9832C6B008A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:04:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E38086E54
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:11 +0000 (UTC)
X-FDA: 84566005902.09.5E5B6D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B04C3140002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vAzNcrs8;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774001049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TO1zuzNcun0kkWR0GSCmWT/+8q/5K9hCcXkZoI8wkhM=;
	b=MgMX49HoonDPruaWtdmUzliTNEk1z6O0HssZ9MIL65ZZ5u/o/Vlqmnf/tkewHe6709iE9r
	z94jvQhh6eAHJsziST1iVCsjWFYiVjsw9Gb6XzZ0tZabDc8gxys332bULEPPLNsHvF2JEg
	cuBp32Uh9VP1jeVIt7aV2i1B7Np4cO4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vAzNcrs8;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774001049; a=rsa-sha256;
	cv=none;
	b=C4lhRQ9hiJLuAY8FOuVPxJqXsypcg71vqQh1QwfIMNqRDgJeYKY8ZROkAiCL2EyYSD9d5A
	kEOaVBpailM4MUnVHoQvLTq1QN8N7uBS8nHpE7VhTRjvVoUSCnwn2/i5We5d6Y+YlVIzQU
	6kN5D00FZAbdcuREbo09f5o3dRyxLuo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC3CF60127;
	Fri, 20 Mar 2026 10:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22ADDC4CEF7;
	Fri, 20 Mar 2026 10:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774001048;
	bh=NQpsBeY5EaadXVFBxdOq2KBH0GUNgPBbX8h8P+4LcqI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vAzNcrs8BNxVujqkG0WrRcxfbGidYf6UY2B9j2wpPS73gPa9CErzvvHuXkHT5s3MR
	 5mWouqCj4ulvQYSX2gQ0oeuYWbQhMr3B0IR/nJS4TcF+OEjR+zmBU/sIjqSVVSsL0W
	 C/IK4z4Z23+U0QSh28UkwodQL+Mr6P7XEcQVKXPrnIIRz+UunLW9iJ2nh7O8NTsA3L
	 MG3EwvZtxvk5AOmzYxXXkBtommmTKLw070xlnQs0ejRB5W/N+Ch44k1T2oEWB2N2GH
	 SJc6rzEWEiFmEyb28TIZla0WZ1PJY1+D/NNbiLn70ecSKmqZcRVkafJSgmy4rT5CHS
	 kIduEphstAAdA==
Message-ID: <1105e346-e850-45c2-92be-6c255a110658@kernel.org>
Date: Fri, 20 Mar 2026 11:03:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/23] mm: update vma_supports_mlock() to use new VMA
 flags
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773846935.git.ljs@kernel.org>
 <8bd076169508ea4640f66f91c4b84b433a3476f1.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <8bd076169508ea4640f66f91c4b84b433a3476f1.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B04C3140002
X-Stat-Signature: 3x3f1ydxh4d6awixhrya8acdzqaqmph3
X-Rspam-User: 
X-HE-Tag: 1774001049-484247
X-HE-Meta: U2FsdGVkX1+VmGevAPNedUSWdSZhObDYCl5gW0PNeB1ZQTI9t164uXib9wTPHg+My8OVY3QW7KALnWDpNsIvkw4sioi1tLDFycJUpJwGAxr2MwxkoIcp31cfT73wDp8LUWcNjaWI2vFLZuDr9I844DAvSjLSttLejA35fm+FruWfcJzpVdLI46HQNoJdwGeMhBAKU+XhHkLzLNNFXqjQcqlgAI3mXFwEVDffOmih4Y66qn89TVRZnCrYi9/G4jlONKxLXO3/ubu9OAYMcGVJKzUviiTEsFKyqEM0ulQ2i+PxwtRb0JH9PqEW6Uu7/qOWt2FsnYAlej+R4UdNOMBcyIGsrrltnoB6AaEPIjZp524ZDpZJYypAfH88wQaMoqEK1ftsR/7swPRpPBboOFbtqnFpsorg4thdp/jMQ8/P0l7kUpguaBz9WvgRkR9+RYCR/pYYW1DEupWC+vRbee7NJ1+mw64Hr+xwK4kVQu0AKQHBhJyLBqtDwKC2kSAjbFzqU+6R8LLRJoPrFu1rQ2A45APIsecGzSmqS2a1RF3sKAoLJtQJ59OPQ+Uv3QT5ztjqyYD/vFBtWwsldw5jrG9hgsf8TsGjXHeFl/0+qaiyd0vkCBwjaS27ucY8L/ENufrElU7i65pF/7D0ykE+JsQlWtNjjRx47v9reKS9vCoEOzMCb+daaPua7itqjEXUStDmsfh+chppE3WLRxAjWFw2isCjdxOqtyHZ4yD201K82pm48h3NPJ6uITupPScPZpYz5nhWAsYoQL2pQyvO+DkMFTROPKy+pMEjdVBQmXlEVcOfrffcK1o/aqVVWIk3tpHw7YWwqn7cP+Sju6v6XnZ3UG2+RdX/3Xafcfjz9pAEh/5EkL+kHNko2IqptoaybWYw53gZqpGFPUxZjsTY3kWo6fk94tgPe/W5mAitGFZ2C+Oy2hWbDg8QofgDvnRJVIYH+eZxAV0i9Dlmr7Iz9Mz
 0C44aw5P
 3TK8dhnQhDzgUld+QYcyAHW3BEHOf0J53GtLcQlwmXAfKtmAQpfkQs0OT8YSgBio7riIVR8diFtkNlSIAv1T/87HWDunwXH3x7Zri6naQY/d+c7zqW/Lk8wHDxy1oKfvklTnrrPoeJrvyQDmlEZJ3J13RJBZci6nTOdYhxbwBHbZnOyV3B+FfHbqnCMZsWebYlfzqOzy9it8NdNhQqjYMrn1uWd1IGqAXrrgKjTtNTy2fVZP4EqSGA2/sT0xzvkL9eVXbNx3LBzyyobHFBzulVhTVBlwd7mTdbJVSYWJY9vvkhlRzyOOPI7UnJjZgpMbgbc2nl0Ewa1F0Areb7zdHcWRt7g3Hwz7f+W8fGPigH4RiIfGaBUAIpKeEkuWriH/Z8/EH6mgy3bCaWLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> We now have the ability to test all of this using the new vma_flags_t
> approach, so let's do so.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  mm/internal.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 80d8651441a7..708d240b4198 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1252,7 +1252,9 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>  
>  static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
>  {
> -	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
> +	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
> +		return false;
> +	if (vma_test_single_mask(vma, VMA_DROPPABLE))
>  		return false;
>  	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
>  		return false;


