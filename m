Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650BD606A335
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mQPqyhx7
Received: by kanga.kvack.org (Postfix)
	id 871ED6B05BD; Mon, 16 Nov 2026 09:26:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8491C6B05BE; Mon, 16 Nov 2026 09:26:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760CD6B05BF; Mon, 16 Nov 2026 09:26:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53D3B6B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:26:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DABF4400BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:26:45 +0000 (UTC)
X-FDA: 85441208370.27.6894083
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 249A61C0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:26:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQPqyhx7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794839204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/cDML+T26sdQopeF9JOcLeFrLc7HBAnzv/NOTzn5RY=;
	b=kC+SvMH9gbg2JLY82yGuRiXwAgksytCDXGJGRUt1YnqZVY54lnbeEAQXwdVfBkPeOjELjD
	BA3caTCZHoFbxk8R763Bb495WOQEvpWhJiixIciAQ9TWw89Vf7pT0zGriylxpm+7yQbuC0
	GUVxKNmmI+DInvSv890zrRXlxwXu4ug=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQPqyhx7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794839204;
	b=Qun1GiMMkkG1jIsdgJxjCU3As3cPh/BvgU3h0IdjazW4a1O1grG6I5agVUz/qGQsCsl8LB
	IN6tGNKE/0QjBY1nqh8GKCvyGa5M7+OjlkQCH8mgkOXrXFqjTZ/b9S1N50Fl6p9/koNYIz
	YoZur/XvoAs697XrW3bydbi9eL31XQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98D1F62C1F;
	Mon, 16 Nov 2026 14:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70F71F000C7;
	Mon, 16 Nov 2026 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794839203;
	bh=j/cDML+T26sdQopeF9JOcLeFrLc7HBAnzv/NOTzn5RY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mQPqyhx7ZPLZTQfXvRc7983IUMX1IFW5Nh8Az9s/0fDxDHzrRyTckj6/jlUz9PNSx
	 Ajg2Ajy5EAkH34N0p7lF8V3Ze6POz4mAmfRq9R4NPFSooDUyExHjKqeJEMfq3Kn2Or
	 /6IiFXfNQtVWUPxSp0MCl1REJCIBvkA7ZEEG40hwncFFnxBjttPU8JFPWflyD7UFl9
	 hqnkavPOKEg5AI4lZsQFO18q/ReLgQMHhS6XQNwIy4qGPK3rGm8m+8okUcjH+ufxxs
	 D7HrfeEhkJ0bMylk7JCWy0VE+W1VibRzG6MCMqzyKie3cFrqV3QB1TVSc+wkQT8+cN
	 /pzC4U2mRrWKw==
Message-ID: <02e6240c-78ac-48a2-8bf8-36a2327e9de8@kernel.org>
Date: Mon, 16 Nov 2026 15:26:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/userfaultfd: prevent poison marker loss
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
 <avij463DZ_tSwgKy@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avij463DZ_tSwgKy@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 249A61C0006
X-Rspam-User: 
X-Stat-Signature: 3pga3qarbf1kbf3yxtsm8qih9mx6gud7
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794839203-817328
X-HE-Meta: U2FsdGVkX19f70epR9iT5SwAElYCNTcQWasESODFB4fklkTSH5e57MDlOn4tqBPD2fdZvWDid3pkRTWc17JIH4X/dZ0HTPOnzyI0LX+z1Pb6wGJu2imkCmzpSEImP/HlmD6BGvbupYe+zgvfMi86qsAZrz+OsEUmAAXkY+XfXWdw8yT8r9to/5vku2y/FCZKh6AuWnjjJhNwjS1IVY8mKIXGKS1RKhDKKuOEFBgnqDh3WonVp0fMu0GdoMAYD4eP5s4NuiJU497n/IgyOwWvBfJyOlIu3zYrmoC31MXMKVUq9bIxMQh/CGPtwRQPlZd6YNGKT7dLwGqMd5/iuHqGH2YgxRLFSIZslwlvO89eMxGTygxLqug4+7PUZjM9p2+1KmGr4B8QwlVOPfgZur0cNBSDXgW/u+CASA/ntaWjVgnDxUBMBezvh4bSefb08YLOST63RoUohpHNMY3ZU1s8eCgAYsv7Z2oVJv0e31wPJVpZwL88ufk2aZZVaNPcV8n/pqlcg0z7mVtSTdamMGZEkwtQjXLGF6lVnyiwmCCwF0iVkKvIecGNcjH/Tmyw4G+cv8rb6bI5B802wWPsTc40sfYLh0NtRjerWLGVSUQAaLYMxJ1Bavro6EL2zi4483dwVNHu3DlIYQxLXohEPdczVzR1SNYbKDZxICadLK68dEK3Gku3O21z7FtiIfbcM9zba1yKvStbuuAUjys287pqNdUo4sk+O4Ry5Z0Q595Cfdg+jSHmRfNeiCF8wluYCe4tFoJsJIT077KbMHXlUiF2GXOB98VV209ytYYegK/utlQGnL9uTdsE3fAPpo+/URT5tT96OnhCM/vsfCGj4X48CoYcJqngN3RDZp3DF9cDKZ2pw46TJkCR47xiKKWmgIN6i17y0jEudXL1Ufkb46f25FRZmRPRl3hKYqGn/EqVeBs9ONPcWnRvkkYN0C6ndECVNuuYz7uWRxHX8BclT2R
 /J2Ll6KP
 vPh1tsLkN2WUH2tR4ZXfi6Oynl95MWB1dx74WqDY6jCc+nZaG4EzBQ3OviuQjArU5o1HY6SSMfvOII85EX+a9smKabpvZedknzAE6H0QzXawvZ5vbmA0lPpk+FBZN/SWcWqHR+f5f+eHOXyOgs5922iIFyf8fZtSIHIPMj2xgWKuGr8pbk1n7ShCmmkyB1HQq3/ownpXU2o+WYUia5ab4I5/D6QTTPdMLRD15deV6geeXvnGIDgQ308KXRAWjCTlgQ0ns
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 19:40, Lorenzo Stoakes (ARM) wrote:
> On Sat, Nov 07, 2026 at 12:51:05AM +0100, David Hildenbrand (Arm) wrote:
>> Unregistering userfaultfd leaves poison markers in the page tables.
>> However, once unregistered, hugetlb PMD tables can be shared again.
>>
>> Further, shmem page-table retraction can discard poison markers even
>> while registered in missing mode, and fork() can skip copying page
>> tables containing poison markers.
>>
>> To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
>> markers. Preserve it across unregistration, splits, merges and fork(),
>> just like we do with guard markers.
>>
>> Use the new atomic VMA flag to disable PMD sharing and page-table
>> retraction, and to force page-table copying during fork().
>>
>> Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
>> 64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
>> Expose the flag as "up" in smaps.
>>
>> Losing poison markers, while unpleasant, is not really fatal, and the
>> use case is rather a niche thing. In addition, we rely on the atomic
>> VMA flags infrastructure ... so let's not CC stable.
>>
>> Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
>> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> 
> Are we looking to cc: stable or this something for newer kernels only?

Per above:

"Losing poison markers, while unpleasant, is not really fatal, and the
use case is rather a niche thing. In addition, we rely on the atomic
VMA flags infrastructure ... so let's not CC stable."

We cannot really backport to the pre MADV_GUARD fixes that handle the atomic flag correctly.

We could easily backport to stable kernels that have it.

Thoughts?


[...]

>>  #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
>>  #define VM_IO		INIT_VM_FLAG(IO)
>>  #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
>> @@ -502,13 +508,17 @@ enum {
>>  #endif
>>
>>  /*
>> - * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
>> - * gated on the same configs as their VM_* flags above -- both of which imply
>> + * vma_flags_t masks for the userfaultfd VMA flags. The three high-bit modes are
>> + * gated on the same configs as their VM_* flags above -- all of which imply
>>   * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
>>   * whose bitmap cannot hold it.
>>   */
>>  #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
>> +#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
>>  #define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
>> +#else
>> +#define VMA_UFFD_WP		EMPTY_VMA_FLAGS
>> +#endif
> 
> Could you just move these up to the block above to match the convention here?
> 

Did you have the following change on top of my changes in mind?

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6cd9d86f7adac..fa56d9e9f3ebd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -410,8 +410,10 @@ enum {
 #define VM_MAYBE_UFFD_POISON   INIT_VM_FLAG(MAYBE_UFFD_POISON)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 #define VM_UFFD_WP     INIT_VM_FLAG(UFFD_WP)
+#define VMA_UFFD_WP    mk_vma_flags(VMA_UFFD_WP_BIT)
 #else
 #define VM_UFFD_WP     VM_NONE
+#define VMA_UFFD_WP    EMPTY_VMA_FLAGS
 #endif
 #define VM_LOCKED      INIT_VM_FLAG(LOCKED)
 #define VM_IO          INIT_VM_FLAG(IO)
@@ -508,17 +510,12 @@ enum {
 #endif

 /*
- * vma_flags_t masks for the userfaultfd VMA flags. The three high-bit modes are
- * gated on the same configs as their VM_* flags above -- all of which imply
+ * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
+ * gated on the same configs as their VM_* flags above -- both of which imply
  * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
  * whose bitmap cannot hold it.
  */
 #define VMA_UFFD_MISSING       mk_vma_flags(VMA_UFFD_MISSING_BIT)
-#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-#define VMA_UFFD_WP            mk_vma_flags(VMA_UFFD_WP_BIT)
-#else
-#define VMA_UFFD_WP            EMPTY_VMA_FLAGS
-#endif
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 #define VMA_UFFD_MINOR         mk_vma_flags(VMA_UFFD_MINOR_BIT)
 #else
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index b8b7cc2f00388..75c3e9270b62a 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -201,7 +201,7 @@ static inline bool userfaultfd_missing(struct vm_area_struct *vma)

 static inline bool userfaultfd_wp(struct vm_area_struct *vma)
 {
-       return vma_test_any_mask(vma, VMA_UFFD_WP);
+       return vma_test_single_mask(vma, VMA_UFFD_WP);
 }

 static inline bool userfaultfd_minor(struct vm_area_struct *vma)

-- 
Cheers,

David

