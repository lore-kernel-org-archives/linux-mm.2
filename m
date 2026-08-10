Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C718C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 21:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6BB76B008C; Mon, 10 Aug 2026 17:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E435A6B0092; Mon, 10 Aug 2026 17:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31876B0093; Mon, 10 Aug 2026 17:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9F206B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:41:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45D11A21B7
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:41:14 +0000 (UTC)
X-FDA: 85086680868.09.DFF2848
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4EC3FC000A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:41:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JnsIevSJ;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786398072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8crpjggh9sIrGYI26ZMJ/PrD9iP41/J2cmh4fS1aC8Y=;
	b=aXXDsPESzYsI7aagnXOaMtohvX8qfMOD2S4oyDC059QSOA8Grr20x/UxbcvjLWzHjC+CsO
	+rpMfcPseQcR5hMMkrZF5vUtFbSnzFNJxiccwkYJmcDpxT3tbLVJO+wWg/eAY1BEfO8taW
	bKvcgiWDyQP6cNl/MvLRUJepVVpgJsg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JnsIevSJ;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786398072;
	b=sclbRxJHlVC2JAiIcOem0/bGPmQ6GHY+Pto6a8r+hcKHPXki+JrxMQhdEHLkh733ai1+oj
	mVj6CKpGqsWwxYLaDKswDMNx7khe9HYct75J00H4/Oe80RTtS9Y+Ht4SsWBOl/3WsRQqG+
	aRxIW/F7a/11MEkwnPRFugAgL5DDAMU=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3900e39d935so2394046a91.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786398071; cv=none;
        d=google.com; s=arc-20260327;
        b=Yj0H+P36cpWqScUejaWh06k52vMtyfvKBGEJ/Q6hLdA+1a4NweFs0LoxaMQJ3Qhe/8
         dAuxat9hqBgbnvBoTOmt85MROHWtUFnK1ijsc6d0DVo8+hxJyfIddXR0Ig2E67Y/lqwm
         pKHaBkEnOCRztFrmdd4b5JjHMvndTsHjFjQKY2Y9LROuiajXxc6zSPkFxg04TcaKVUb6
         oW4Y1iQsNkZLSy812TlVuPoz8jOrJQI/fNshrFnjjkQi096azzmXCTOQEms0KxQg+D6+
         8lZDuZJSb5ckULn8j5sedpfT8ni4rt+Cnpc7YzJofldb49ikj/BtNjxgLReQ/6Fbl/7b
         t0IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=8crpjggh9sIrGYI26ZMJ/PrD9iP41/J2cmh4fS1aC8Y=;
        fh=8ehXk8SKBDrwXLg1zufRBb4j3mzmIsasXzGsxC11/Nc=;
        b=Dg2Jz2gF93wvv13jr9OBFtcGtc2wMuf61InqIq7nzsAHDbg0J6lo7WPkr/YGJdPBaC
         DyqTa00OgMgQBspOHqMZ1upPYrGxFXeE369ysSy6VeavytEpKj7U5kcRHeubU+y45hoW
         UhzKYtKPFBfc62VMI/Y0V5vNzatHRE3RAiumusFTBtYUniDskvxJQCrFlss+0a6RG3Ez
         5bkD0ES7GUaz+IUM+z2EtGTmO71DmSDi910QxkfFe79PVYVNv3w5RcvBe4dEmdr0+5gg
         GBY1kqcSlKUguuwCx4bdgD8myqF+L6MqfwAlAlbxhKQ9lHNWAXLai+QtU0hs5rAtWDZD
         nlVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786398071; x=1787002871; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8crpjggh9sIrGYI26ZMJ/PrD9iP41/J2cmh4fS1aC8Y=;
        b=JnsIevSJrcL188M0UnG+odd1VLl+CU3O5OBbyLKIsKVfP1hyVQ4wa7wbrHTlsmeSCI
         Aeft8WIEGcrmyWiSmgVZiSizgFcjeQMipS7tTn2KuZ2GnmS0GHLPnWkeUEc88j+NuVHb
         Aps9tHB3WS+8r/h60EOpkDEyxHv1b6JwflvBS7AO46xzEk4LV1wsN533tiMHckzoyzIo
         SDWT/tf15ScEm9Cy/FmEFkjhvde+HGcqYGwEuzI1Gdx8uj3/te5sAti52B+V/kkrwD6F
         O7pMgJVViz8YXGqJumNKxqE2ba/Pp1apAGDTkNbFBgFPTqrWowHp1QGg6xgEMUst9ELc
         8oIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786398071; x=1787002871;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8crpjggh9sIrGYI26ZMJ/PrD9iP41/J2cmh4fS1aC8Y=;
        b=Lb+SAvvKFVjzchtYuUASi76JBkG2EQgyeMm9SWQPfNl6wLSS5+SUDM95DK4LL5sAXB
         0qz61fZjsYJaMvMCIV2r8i+r0AS78gSnWrJScm6Q+FLOqcqWHkuWMRJhSJ4M9rL0TWuG
         KkJLH81/6J4rEQWPKJ4wCdDonnXUq3xkTmo983zpYFzHtjooXIsOb+78LsZzYpWzxYfl
         fG1cZ3m5Qg44MWc7aDdPsLzI66irhRyF2wR4BJDsiyPntuvHkIXyl3t8uuJerK8z6A3s
         vVEMCJDrjTMpzE386EqKM9uhPwnHw12AVegubkR3z9g9pMG0y2X0tl0k9qMZnvNh7+1q
         AOSw==
X-Forwarded-Encrypted: i=1; AHgh+RoOJzKHd7EU+SYDDsufRrpHI9H+OM/Ki8uWdGAq7tuzWdr0DbUElhtk0TuWdKCvDt7Fnt1pfD9Wlw==@kvack.org
X-Gm-Message-State: AOJu0YypDXc/UX/YQ9AFuFKSIl8YiQm7NXjsrXRbRkqJo6bvV1Snal8m
	oVO9EcuhBplJX4TVYeR/WTsCStOwI7COjOV0NS/0Js9ZjelnvzAGrja8voy1bC4kDf1WThwND2f
	+UvrWEyPaj0xNepMAzUDICyRJWnKxSyVeMl4NQOQ7
X-Gm-Gg: AR+sD12hlIA1LPkBPNpeuM0XM8HG79sMNiHxwavlPq5JFOZK15Cp3avF6eTz4vz2Oq5
	Cztx+Ty+BNlKXbkPVNIAxiKj1uQbUTbGi9P8fR3vSEsECjb9dFKy5eskbcX9sDks1ok7iFb1Rvr
	ecLmjtcbhc1DiJ8M6orsXPjaxNYhXKnDnkyjAmpWI85TKWUNbXwoENTSWaO6iGKy+ZDDh7j/EF3
	0KwJvAKNCTzUPivYZHVIe/nAALm8tiGZAB82721pRMX2ImTnwelMfTgz0a65teOuZyMsd2k61cO
	baziOIRMJTLreOmw5rmi68OT2eKQHut2lWNQtJ8EWq7XPXg0HYiYOxohHPCmMzY2qWbxGr95+Pl
	GcUo4gBZOLgOONwcj9/qr5B3e6igu51Y0iDs=
X-Received: by 2002:a05:6a21:6e8e:b0:3bf:7c02:c46f with SMTP id
 adf61e73a8af0-3cc1a1be7a1mr5874285637.14.1786398070269; Mon, 10 Aug 2026
 14:41:10 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 14:41:08 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 Aug 2026 14:41:08 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <eb1b5763-37bc-4cb3-890c-1e619e5a8ae4@kernel.org>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com> <eb1b5763-37bc-4cb3-890c-1e619e5a8ae4@kernel.org>
MIME-Version: 1.0
Date: Mon, 10 Aug 2026 14:41:08 -0700
X-Gm-Features: AUfX_mzgTn4rWAG2ncU9fSNARUBhUErwbxwxxfyCmQfQUmSlzmOMXp1B7HqwTck
Message-ID: <CAEvNRgHyRdt7rp=5e5FMbTT=fXNfB=np7VWd_GdmJcPOQgps4g@mail.gmail.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pd3qxhog5g4tw8iuwdqkrsng57xnsmes
X-Rspamd-Queue-Id: 4EC3FC000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786398072-102777
X-HE-Meta: U2FsdGVkX1+TRdWaycbZLblanvdbPS2oaeRSNoRaqWYwG6tR6LUThNal5jOfA520TuRuO6C1eQOnkADWcxycZfmgOMlsdh23kLMFbE0oFJ0kbN29UppKNUwyrdH/34k/WikVNu307phce2j1oMT7PWJGFwyYJW5m8F09mCPJhPiPAaNIyplng28faGo+r8T/twayw2jpL5YX39LM3yJ8pqLe8tNiNJkJWrxECII0KUpJSX7p1Krr3zIN8TNIMbpTB2IXLN9+2joL3a/knAcSOCLQX39d42Gnlb3hVqU8Q1PC1YEyjdF9bnQTD92A6mDvmKGs54Xt9AihFFjStp+OkYhQTQuhcofzJwbk1R6iT939eTxuFLt5gLilwNDjvqkhyKaxWUES9a1tpGyKZlM3bMX6e2jKCDC+lzJKjuKFp7o+NiMfstisWpc1u9g63fKkWDrXpYVokBt3QBFVdbcj4nvfN3wTepRSqhn8WfpMdU+s9AiBiQ+nv81qsNA6NMGaKhNuIkjrtWUeyqpAGzLyCfb4JoW3RA1hKR8mqD12OoiN/yG3qTRVjjuRa3fYDfrwTUHzL9u5pJwnniIQQtDhD7UM7hrh++S4Qw5pnIMBc3NbOoQ7fb78IHq4oX8S3IC4Dz4HAjg+GRMvFf4ceF5ytf7UVRuFqv3ycBOowW5eBTqwbFwpOKO7fypd53BcRHn7RNsFKs0/pQVoU5zc6wLyjuqVmgyQpCGG2NXrRTA6n36pH5/acmTcwEE2B+8cti+hU4QW5hnc88ib1LSrrk7RFAQXo6BFjAtWKUrHLJH3lj3oOvb0xwsvyCWfwwF/ArnGtgBn6npxH2Tpp16SgT7/dw/gSp4Okv6O8yclK+bqQkTXRiRyn15w0s4WjTsedQKJw3/IzG0jGJIC0JqQ5wJdJ0CQpSoIUsEmVxZUtwVA7PGV112+sbSKSyqP2LaFCpqH1aNmpg6ujYdO97DX4GI
 F+eO5Dd3
 8Te11BUIZlA2pXMCDhzapSkAlLok5QqyIPhZ/lqMVDUrfybijjRy9Z0swfQzi7KISuWH8QGEwJbS7O1aU02LYHA0GhIa/5m40Ykm5aqjeFDc7n8UyqW9EE/Q0JypYbu3Ohs4xCft7upmaWa+ppshr4tmfZ79i9e4fIBOhmbSbe29AAg94xeyaTYnV1b5loCF6YPw9+s/z+SHls++jr6taIjbf/w5vqjsD8gNG852PmnlggUPw1kquKxVbDqqx6Im7O7BYykuJqImqHQdap7+DtFHNSpvopmxXc1scqcVuVvBFVSy1fzkE4H+Z+5XtMn84n+2j2vYNn6DJOj+9dGHTfyZIKFGdoDVGVgPGuJhE2YdKG6VF0LVD4kfLUCFsXW2TvDmnvTarE9yAIUFJ7yMzTYRnMxWu6mqYSErLIJdfU1tziVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> When converting memory to private in guest_memfd, it is necessary to ensure
>> that the pages are not currently being accessed by any other part of the
>> kernel or userspace to avoid any current user writing to guest private
>> memory.
>>
>> guest_memfd checks for unexpected refcounts to determine whether a page is
>> still in use. The only expected refcounts after unmapping the range
>> requested for conversion are those that are held by guest_memfd itself.
>>
>> Update the kvm_memory_attributes2 structure to include an error_offset
>> field. This allows KVM to report the exact offset where a conversion
>> failed to userspace. If the safety check fails, return -EAGAIN and copy
>> the error_offset back to userspace so that it can potentially retry the
>> operation or handle the failure gracefully.
>>
>> Update documentation to document the error_offset field and the possible
>> -EAGAIN error.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
>> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
>> Reviewed-by: Fuad Tabba <tabba@google.com>
>> Tested-by: Shivank Garg <shivankg@amd.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>
> [...]
>
>>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 3783e63476569..13c3989136f67 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -524,8 +524,42 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>>  	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>>  }
>>
>> +static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>> +					    size_t nr_pages, pgoff_t *err_index)
>
> I would focus on the "to_private" aspect or abstract it to
> "kvm_gmem_mem_has_unexpected_refs" or sth like that.
>

Do you mean something like kvm_gmem_is_safe_for_to_private_conversion,
as in that you want to emphasise that "safe" here refers to a to_private
and not a to_shared conversion?

Perhaps a little ahead of its time, but later with restructuring for
huge pages, we also need no additional refcounts other than gmem's own
so that restructuring is safe, hence this function name was meant to
extend there as well.

In this case "unexpected" (especially since the next patch adds checks
for maybe dma pinned and unmapping), begs the question "unexpected in
what way"?

>> +{
>> +	struct address_space *mapping = inode->i_mapping;
>> +	const int filemap_get_folios_refcount = 1;
>> +	pgoff_t last = start + nr_pages - 1;
>> +	struct folio_batch fbatch;
>> +	bool safe = true;
>> +	pgoff_t next;
>> +	int i;
>> +
>> +	folio_batch_init(&fbatch);
>> +
>> +	next = start;
>> +	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
>> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>> +			struct folio *folio = fbatch.folios[i];
>> +
>> +			if (folio_ref_count(folio) !=
>> +			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
>
> I'd rather add a comment than have this filemap_get_folios_refcount.
>
> /*
>  * We expect one reference per folio-page in the pagecache and one
>  * reference from filemap_get_folios().
>  */
> if (folio_ref_count(folio) != folio_nr_pages(folio) + 1)
>

This comment explains what's "unexpected". I can do this and switch it
to kvm_gmem_mem_has_unexpected_refs() unless people have other
suggestions.

I wish there was a folio_pagecache_refs(folio) that
folio_expected_ref_count() can share with this, and also
folio_swapcache_refs(), to solidify the definition of refcounts taken by
the pagecache.

>> +				safe = false;
>> +				*err_index = max(start, folio->index);
>> +				break;
>> +			}
>> +		}
>> +
>> +		folio_batch_release(&fbatch);
>> +		cond_resched();
>> +	}
>> +
>> +	return safe;
>> +}
>> +
>>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> -				     size_t nr_pages, uint64_t attrs)
>> +				     size_t nr_pages, uint64_t attrs,
>> +				     pgoff_t *err_index)
>>  {
>>  	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>  	struct address_space *mapping = inode->i_mapping;
>> @@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>>
>>  	mas_init(&mas, mt, start);
>>  	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>> -	if (r)
>> +	if (r) {
>> +		*err_index = start;
>>  		goto out;
>> +	}
>> +
>> +	if (to_private) {
>
> I'd add a comment here for the "why are we unmapping".
>

Does this sound right:

Unmap here to ensure that userspace page tables have no mappings, which
also ensures refcounts from those mappings are dropped.

> --
> Cheers,
>
> David

