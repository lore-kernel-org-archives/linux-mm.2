Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF416CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 22:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32876B0088; Wed, 24 Jun 2026 18:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3456B008A; Wed, 24 Jun 2026 18:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA5C6B008C; Wed, 24 Jun 2026 18:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67D626B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:30:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D26EAA048E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:30:16 +0000 (UTC)
X-FDA: 84916250832.04.3B891C6
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id D060D40014
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:30:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AD4YIzQ9;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782340214;
	b=zBlt0ciYfPlRwzaPUuLSm3gb0FgOBlN9kLPGwuJFRuacTQ+EO19Bvm2SFLK7cvAgzBVA2i
	VcOzh1euNBa6CvVtK6nZ44NMig2qllfmUjpC9pkagnUZPdI48Wx4JTunD8rdK30uWuTgg9
	jOwwdaVZXfEQ1rShG1BH8G9Qn3n8cas=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782340214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVosxF/7uHKl1pdZQ4oI0wtR65vPmKvzzWf+IZ9YyQw=;
	b=StBgs2VQXKI6W43NMGo6AFV7QHg3oGwyeu0d1QKf+BHuxVCUQulnyPjQrEx0LZ/9RFatyr
	JxYbhB55hIZrm2yqgDDCxVFnu1dm0jP3OsjRTOYfGlDCdOO/j0hmScCECHF4qbQhOtNgvy
	LE4bfx/nt5gVXOvqo5fUtqWHur+Mu7g=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AD4YIzQ9;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-13981833e13so1991157c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:30:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782340214; cv=none;
        d=google.com; s=arc-20240605;
        b=OZA+oXQ1Ua8yI1NEe1LJmzctX7NjhO6cRF5e2rGZKcmNpalhKQeKZyYg79lXyrZXPC
         1P+lIjvYChnjwUxpn2GdYVMNJmzKIFk3Dam0VRnBPKcTtu/vjLcnmWpQsICWyx3viv6U
         oNKmWHccwTEtRvu11A7T+58IbVXWT8EqNbQ565IshLnIhJub3kYe3FJP2eoGjIPLceQZ
         uTqSVaCK7CyUFp/SVZnzcoP/lzBYqII+eNb1bx+TWCMzjUo4Pgz5RBrwPw4mxrH04QRJ
         +lrr54hBxKLFciIvH7G4P2wnDwt7hn9Ol5Ibms4vK4B4vqzCV+uhzWkxmGAB8Dk8q9jv
         vWgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=oVosxF/7uHKl1pdZQ4oI0wtR65vPmKvzzWf+IZ9YyQw=;
        fh=jMxXdJypoF7+9QceKWoYzuhKQQDa6Uq2CKAYSoTQQ6A=;
        b=RIdeS1iwWKARJf9LFgGq7+/HPMdiBW8hPGwGclIiA7tutu4ve1+LXw+QzICeYNuFbS
         RsXtxUVdCo5Uv7KpJED/BzYzm0T5eO4qcXIXqoI8zy38g7EVf5bLZV6UNsCxSAhc7Y5+
         kUYlRsZsvXMp399XzOPIr7efE7AKFV6shQrG0Edlt2pKobA9Feo3sgpXYLKRxyul9X0w
         S31Lm3ZNFJsJtAfgkBWVUaR98BChwwqimX+IS6oYM0VHm8RNmw/xFJPQ3MaC04A69Pfh
         Xa1G8GIERGHDij72bGhfUxD2TTPtwtKoDG6DmrBH4KQDiFfTCD0VhBjduaXvVVqk/wgo
         qjQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782340214; x=1782945014; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=oVosxF/7uHKl1pdZQ4oI0wtR65vPmKvzzWf+IZ9YyQw=;
        b=AD4YIzQ9zUgXHyrHdgQRQ+l6x/AksyhcAZ+i0MUv496hnvE0VLyyfUkNMiKfk1aLe+
         PdQzjsVSnQINMggIo/nQMvdjO2hcczvES6T9XBDhZCK7T3O0E2bwf9kZXtqSW56NhOh0
         ojd/p9KY+WLRWHBCyAf+KdOF5PZRwOdQQNyKXv5KS8IBJuYqOTFCkb2fLtdld+RFs6di
         fUd8wkxC/AwzOUTLP5KD5WMmsPkOkhauVYYN6jLo2IM1xX7hgqAqfHJ5jMfhqzPFpuMC
         GuokoP632uRuHbuyS4eKMtkdSwdhqzWpVTDvutC1WYI/hgbvdOzO3hXMZA/B2jBTfckx
         xZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782340214; x=1782945014;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oVosxF/7uHKl1pdZQ4oI0wtR65vPmKvzzWf+IZ9YyQw=;
        b=kcRiiSufKEaVNsezZf3alOCW2oHCdbREdpMaYjqW9E7Xonj8yBC0JVgchl9jNPzXpF
         y5jtEx6PIwLkpCCrqvwbKhL9IkhNBMwLn60UXfnoZpVUPMETCXUzPBIdLr9k4cWUZCD/
         BkV3odczildr+PzKG4xecfiCF2SIT19fK7UjL05XhIMaNbB+/SGYgNGsk0HKexGKIxZn
         ij2JMqZyM4Y1d+gve1+4XVXt4eCnU8/kZZ+yHpHIMjkERarRJxJlBFAVH7O3qJzXhXQD
         5zGsXImjNLXp4P+pAsd7iawOnGs7ADFbRd/LTDLk2b1LO0qg5eS9bsZ+OxCZLdto0f/U
         SwUw==
X-Forwarded-Encrypted: i=1; AFNElJ/BFjU9NqId73F2bCvt2uMXr4dDX+C/nwwIN/ouLYPTLwsGj0C8zYjvNjsqvDrLeYcEx/mX6afU0Q==@kvack.org
X-Gm-Message-State: AOJu0YwapPFmkHxuSpcuHXMaPfYIJ35gvcj1Ly/WC3/h5ca9IJDZVF9y
	hGSev2EhBtgY5NlELpKvQCGbS/mHYTf4S1A4NSipl+rByQMbcDvMGSdCeqvk6RhXvny0jFTocq5
	8NijZNLscTPWYyrociRBqECOIzKFlAzInuiAfFS81
X-Gm-Gg: AfdE7cnxzCB9ZTsKroWpnejEcnby5H97HpQkTxBIMR3TkgoNUCbIfQ5tZiKBS0QLK4P
	vqzBPmeH5Z35MYRVIGPfLSDQqV6AuPYXICPRk3wuTSv3eNVcnUoyf5/DH+1SFxFvYSkhfluAyXg
	80SlA7w5GjY5I9QXOk2FFs0RiGS8w4vjubOjaMz7+FnvafM8LeC8a6mgqBOWAFRJ+TPw3fYz3qj
	j1esVvhbSUVcK02bwxbEkHUvW7QtT6N+/Q5mHz5fFEbRG9uQ2Y7XBNxwqE1AEofOF4Dllf8j2ea
	59fSFWK+kMZFa8epzYNFUKbdnmK0pZVCPWgxrSHU1ipR7sBkxfWfMaNj8c8=
X-Received: by 2002:a05:7022:fe06:b0:132:5d42:55ba with SMTP id
 a92af1059eb24-139c5d0503fmr6919345c88.16.1782340212554; Wed, 24 Jun 2026
 15:30:12 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 15:30:11 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 15:30:11 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajpKK/SyRh8LExrY@yzhao56-desk.sh.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com> <ajpKK/SyRh8LExrY@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 15:30:11 -0700
X-Gm-Features: AVVi8CdqNo4bRyAdjZ4VoxTkK6AK5USFMYju6TEGtZz_v5HiC3fCw0ntlVpZrZ8
Message-ID: <CAEvNRgE=-cdbiToHEu-FCks2XSh3inVDdW3r+h9VYYbE4REttw@mail.gmail.com>
Subject: Re: [PATCH v8 21/46] KVM: guest_memfd: Zero page while getting pfn
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: zedkexq14e9x9gc79ur83mzjppizh5u9
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D060D40014
X-HE-Tag: 1782340214-408126
X-HE-Meta: U2FsdGVkX1+gidGseNg7hKfpXMh1lItHW874DVDBs77Gf/7AFchFyE1RtMiU0tA9hR4Q5zI358YbiCULrrN3FweEHe7v1bBKzA3j6FNNCxhc//inqAy4TiyD+BbWn3zn5x8QGDdyMzMaCjm9SJ/DRwnp+UP2HAifjPEYDieU/bYTjM2fUv6esOUtn5xf5303wfy3YMWtGAQTVrvJn/cu7Z3of1VACJDW+OroNrChRMj2+vTlZEA+re0BMfGFSpiFgnPFQdjNjuAllLyF4uL3os95dVOeHvmHbHBCbFqN77R+nOfqtNpk6xIM8TKrcOlDdu7n1g9Oc5fTVJTR0Mcuvu7qSSrFgpL/nXiGiGsIFck7wUdLcY9gGSi70lbvaaEvaRWP5Vw8NWf9nTUh+3a8nKd0fGFzk5VVb3GLzGxQF5btSlv+2VbRs4p4QygfNZ+AYpoP2ogVp9ZAf5yl9JEa8pBS25Bje2UtdZLNMgxlwcCAYsui1T6gMLls/Eo5CbVtRGRbzccdOpX6IKO8YHeNGaAmYfSXBFyETsDM28qtixqDS6hspSapfy/3PNLF7/niuFK35DmD6003lKu/GjK/9raV/ljH9AvP9pHSEg8+veTwYwriTTb7KAn0i0XzVZ6Ng/7IGjXYYV8jukb+2XEBAXEcNUMLvRWmHXjH6hPotzdmWN+NVHpNwLyq37dlI5fP9Sz0ExYX9F9IarDrgj4Sj3NvmkBBCUNsmxfXcYxm+kMWXYAyXYXpHNzwgQh47+u0xWcQcLCsKmGHwx9KmDpmNmridd2YMzJ/dkoJK2Dz7HvSkI3ukfu1KxuX0FAMNxkxgsLL/O7dZiMfO1GIQjhONeh1uf2TWaf5/+UueoZiVNlmRS8upo7xZ3wSnqtfbheiSLeyha2B/aCv+UFgK57p3KFZe7PmECk8FTSu9bF8KkCO5QTO06RujzflYXgCYiPo+EiXIffLkeq9v9mUTdx
 7ivBBw7X
 571xjJdBeZNHVlJDVyj5OmQ1BjUxhsCL7Xd64f9l9HEFworWjAa4l4yPSFLD6Vy6qhyBTJm8Y4qXFMz/3qHzGMENIDm6+HLF4/s5iGCpvJYqVAxruJ6Fw2EUGIIj4TjUCWkZs4Zc6YaS8zmrexv56hykze5MCvSWgoJSRj9tkn9QJ0MC+q99dyZ4HRXV2lRXPjhj+OFlQp01DNo4vb0i5zvqQQxviEULC4q5jmO1fDUobfO1xMO3jtf+r1j51AvnKQqWwRNGsHtFw6mv8Zk1C1ApG9qDVSbEkIDovDCAxA9afKmeL47pbVE4LaWTKrojOqKuc+keOSNN6zv6aI+oixRQBCh1HEUg1MDA9nnR+4oHkdUVcWlMRDb9FpEYWWt5hrWnIVOjC2OoD/Zw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Thu, Jun 18, 2026 at 05:31:58PM -0700, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Move the folio initialization logic from kvm_gmem_get_pfn() into
>> __kvm_gmem_get_pfn() to also zero pages if the page is to be used in
>> kvm_gmem_populate().
>>
>> With in-place conversion, the existing data in a guest_memfd page can be
>> populated into guest memory through platform-specific ioctls.
>>
>> Without first zeroing the page obtained using __kvm_gmem_get_pfn(), it
>> might contain uninitialized host memory, which would leak to the guest if
>> the populate completes.
>>
>> guest_memfd pages are zeroed at most once in the page's entire lifetime
>> with guest_memfd, and that is tracked using the uptodate flag.
>>
>> Zeroing the page in __kvm_gmem_get_pfn() is chosen over zeroing in
>> kvm_gmem_get_folio() since other flows, such as a future write() syscall,
>> can get a page, write to the page and then set page uptodate without
>> zeroing.
>>
>> This aligns with the concept of zeroing before first use - the other place
>> where zeroing happens is in kvm_gmem_fault_user_mapping().
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  virt/kvm/guest_memfd.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 90bc1a26512b6..86c9f5b0863cb 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -1137,6 +1137,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>>  		return ERR_PTR(-EHWPOISON);
>>  	}
>>
>> +	if (!folio_test_uptodate(folio)) {
>> +		clear_highpage(folio_page(folio, 0));
>> +		folio_mark_uptodate(folio);
>> +	}
> Note:
> In the __kvm_gmem_populate() path, this folio_mark_uptodate() call makes the
> later one after post_populate() pointless.
>
> __kvm_gmem_populate
>     |1.__kvm_gmem_get_pfn
>     |     |->folio = kvm_gmem_get_folio()
>     |     |  if (!folio_test_uptodate(folio))
>     |     |     folio_mark_uptodate(folio);
>     |2. ret = post_populate()
>     |3. if (!ret)
>     |       folio_mark_uptodate(folio);
>

Good point! I'll remove the folio_mark_uptodate() in the populate path
then. Thanks!

>>
>> [...snip...]
>>

