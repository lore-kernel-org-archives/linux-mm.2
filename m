Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FC2EF3700
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165726B0088; Mon,  9 Mar 2026 04:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1262F6B008A; Mon,  9 Mar 2026 04:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010ED6B008C; Mon,  9 Mar 2026 04:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE4306B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:02:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D9E413BAD8
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:02:06 +0000 (UTC)
X-FDA: 84525781452.24.DD1D45D
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64DAF16000A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:02:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oOV0xii1;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773043324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iKTwpN//vgpsNCCXbcsIw/eIDxxyup8fH8lZJsZvpA=;
	b=mXZwDOYwQ+/9wMXsrJ90TN056jhdSqjMMHTsMdNCg2YZ/8DZVLLeZDIdt7vIU93yEMm2qj
	p92Wnsoeo57OloJqMcgo8OXGwHjNxE6Gb8iB2qEHiEiny5f696SkSwJTVcSfUwlWkrAnT4
	0YJo1BuQOQdzv10hZ79AC79yZt+3cgc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oOV0xii1;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773043324; a=rsa-sha256;
	cv=pass;
	b=ux9J1L0kgIZCCQpjCskUi6H2K4vEKTViR6M0O7Regw9QXzRGi3FOZJwZXIDI1CYU81+J/Z
	yZuGOchsPVkGNBG2Jv28OJQWAlMxuc5QSdlFdJ3O+cGf10DswnWENotyHlo+YVmnFeXc1E
	h+OCCh8V948ZrYwHtK7QSVUNRKlcOBM=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-94de4f5531eso3566430241.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 01:02:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773043323; cv=none;
        d=google.com; s=arc-20240605;
        b=N26Ev++rUOxfAEZQwQzCeh+04wWHt2R1Gc/Wu0XHLEEdHXoANIT/scNFqg5lfQf76N
         YoXp9dHluBslW2Qfd7S7C9fzxgz9BAkqLSBcqYAPeuMWgwHYhXI+5eQ3AbHMzns4nJIW
         uiaISez97nam1uNs37Jt7ke12nBgllAO11C0dNXpLhvtWkNMOt7LoDhyXCBqP1U4m4ts
         T9HkcsCftKyJg4lm2yIHH/sJCzRhD2uMp8rslPfBx4aYiaUh3EEgT5VCCi58i19Do6UY
         bsxmUNpi0gafQHDjhDqVRV7IuZw21XNp3ehi/3Bpib+QOnj6ciGEZJ7vJ7NULDHH7XNp
         SvBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=5iKTwpN//vgpsNCCXbcsIw/eIDxxyup8fH8lZJsZvpA=;
        fh=jXsdAt6T6XIwtnjPsQFu6y+RJU87nUfQQ0ReJLReFcI=;
        b=FBsUf/tjKX0uJL2Paosdiq8vMK8RsoWzCwMb/DekaG19JnY7CA+QV2hc9U6PO0j8B9
         EIEn0dSlKy+zq26MYmwwpuPSgR6cv30Y/Bm+j8qqNymPjBh//ne/EyiSHb0k4i8TxdSo
         5IvVFomTVCJvrmV8OzU+yKgkUP3qXizJrXaR/tQ8j/HrerlDe59BL/a4VlCtJbXtRrr5
         /mGQr7eZFtz3KzGxivUNyylwV1GdSWt8aa7zhFWW83MA3Yr+divsnXSKuT9oWFqJg58T
         wL3tnaNlDr35LDN4FwbOg3DhKoTy1Ca+nVHz5yRGGD+zagCg+cxGFttdONDoTon1oLth
         jENw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773043323; x=1773648123; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5iKTwpN//vgpsNCCXbcsIw/eIDxxyup8fH8lZJsZvpA=;
        b=oOV0xii14awuq8gEh0GSloKd3vwZzmg5MFZ0XHCTNPok7kFfylq6BJKHhIanlm2oed
         MPL9boPQC5/mCqpoJDvf9TDbew4I3smZyPhtYsnpJl2xbtGyM9wjaikLJworL2rJhl6b
         seCNRvl21wDAHVbOwiLvvfdYaxmjW40/gLbmZNQbj2DZn6z/q4GSZxFhvtF3puYP32ge
         m7DPC5kqjWN46SibkXXdUkertNBkdUYjcneyXrKYlslvszzEjgUYunMY6Cq67NYgrdWj
         eemc1vJrh68ghFKzHVCq+skyJ/+jpOKSmLLT1MWhokrWZDkaMmzNXyGRgF2B23k3o2gU
         vAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773043323; x=1773648123;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iKTwpN//vgpsNCCXbcsIw/eIDxxyup8fH8lZJsZvpA=;
        b=CGoykgbjMIU2BePmSY2x1LgIg/XtZJUOCFCkwEoD8nGV14aa6FAITQkK3HoIagkT9z
         ttad7z8gU/CjpV9nCmwUh3VcQnKjKFqoL4O5KddeBvDm+ojL9DClTWPcFiaUtsDXbnEa
         JeIG7gv9Z3zwKRfFqcAoeE+k9i62gftgWLaud/6vfountQMfDdpHM2E31CofrdZg58FY
         W8J1c08aKCgUzbwOqxPWhM2C/03+1uRwa9AQ1G5RJboqf3788B+hjgOwPw777n1z3jQi
         ZUNwKkB7EtmK3p2C2V6TA5t2gtPGK6W4V81AuzL43YPcwa/+nJ4Fqe9fa+QJzXoPI8jV
         VyIg==
X-Forwarded-Encrypted: i=1; AJvYcCVdGIDf4CahV0ha8puQg0+ahENO3wUjZBvgmZvoPEYzGYTFMwTWQ3xsOsXquU6NAAJyfBuwDBT/qQ==@kvack.org
X-Gm-Message-State: AOJu0YyxdNkd06FYCmAu6hxrTeMbCPJElNNQF+ois+6Om0BjEdHMIzDs
	rM0+T7wP7974/EsqrLVlzOFQLVIoILQSaHrPq/rOWupG5r7iIE9ypEArqQ8Cd4IkMKG0/sXNRf8
	veToX/dx99i8cXHPXkdN3DlJP/3244XWJnvgVOgQV
X-Gm-Gg: ATEYQzyaXdV7ZHYMy+NqQA2U1bDUmF5aWpcBrGNVMnG2aSBoHhubSZd1rvuxP4iGgfK
	2ypY7RL7O0UByq6K4fIg8x2gvgWwqhCfgHb0+dGfYB47T8I7JAaeQTVwU5DJdYy2lW92Hby7OUj
	aiHMuecoRefmYor6zPntXpDZDyUDRPPo1Jwb1DCzdO/7bKpgUFXjE5kNJpkTIt8uq0xTD8tbHln
	9MXc13ykk4Pe1a1WLpQaaCtSYYcLdKAWju+6ZkdTckKYrHJXNO7XXkyHPS8Fk4OvOYuDOQxuKiD
	p8+99Adnv5h0iSFEeT/RNnjSTb8dwI44ZfnVpj4mmjqlIs7EDoiwVvP7+XDJdVbg6cSqyA==
X-Received: by 2002:a05:6102:4194:b0:5ff:cee8:660c with SMTP id
 ada2fe7eead31-5ffe61bf0d2mr3868411137.31.1773043322886; Mon, 09 Mar 2026
 01:02:02 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 01:02:02 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 01:02:02 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aahNprLw0_Cdhzxp@google.com>
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com> <5097ff66-b727-4eac-b845-3bd08d1a0ead@suse.com>
 <aahNprLw0_Cdhzxp@google.com>
MIME-Version: 1.0
Date: Mon, 9 Mar 2026 01:02:02 -0700
X-Gm-Features: AaiRm52tdsuammFV80Tf5JuKg-WPQwxrDNCct9c5X_bV6T_IkMHGIVZ0r4R166A
Message-ID: <CAEvNRgFwyqY0q-PTvMGjK82rxvbCfPxK8-RUPML3w_8mzAk8xA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/6] KVM: guest_memfd: Directly allocate folios
 with filemap_alloc_folio()
To: Sean Christopherson <seanjc@google.com>, Vlastimil Babka <vbabka@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64DAF16000A
X-Stat-Signature: 5amk79dohkfk8ah851rff5nnf3e34ifm
X-Rspam-User: 
X-HE-Tag: 1773043324-852989
X-HE-Meta: U2FsdGVkX1+byPLuKtWbzWNkBGEGU7VB2ecD/0f1/aTdjhSieJMAVMH+XE/tk1jXoNmKv+gZ/0bsNXjU8zCPpniWtx1IGyc+mA3TLhj7yu/wXtHX799U3Bi7xRhsYQ73QuNooU6AVDDLaZRbTYmcjSGcql9fRgaJfLdvbg3Ks60UUMEW5iFzlXGi1mDr1No8uN/x7wiAhlBicnPo8AEw/dossivERkBzPcC/i2rnRJm8+x6aaz2wn5IVo7SuejQNOVd5FeszPLmSHMyXPSYSA7wVp3wpGQiaXVy5+C6engKS9oPKa12ofB+d+Txz0O67McICt+1gqqKxAPvfsceCxEimM7o9D+vU+UnjXNe+PgECbyjIGFhlwrg00NJqBi802NBMIH6I5u/5m5Kuc15sFEOT5TgyZDp10FKFmzvkuNlhJaqtNCvmCJ8KAbEhkB7W9MacKcywFtYSppGdyrYLY31+EXkq9UIF3ECiNkQ0e31gm7i9kTefa2VgpUMA5ZRDTe/U26QXnFi5qvI7DS+YfW5hSt966evMk3Ke4sYmoxF4shb7oUjww1WGzXyfqK0dNLlrAD01nc+OlF0E5Utfl0xomRfTi0Smnm4Vd8TXAOllfm1SgAjfFkzgzgXKKJp1Faar4E94oZM2zdJ6MvZDtg65a/oC+y/lRtov+AHpYdH/FQvax+uAmSN0xja8RCdPTQtWbbsCi5filzUmoG3HfYPSMvdD/9d+l+qZ7G5ssBRrTzTHgRK1WvgTLF9uFTfn7dj6+PW5uOsDXBtSmHvoCiEP7YEeQel4wCKxPtFr9gqP49iaIeqHZre9hzG0KZiiWRiCSkmdCZhwdhAWa9iFu5ea6ffj/U30LF6Kgc/6P4VGjYSPGdMnDWREa2UL3uP4d6HaZhYlPE+zF81rl6oOYs5CAtIGWJHWJGmw4hMyDVzZUWYtXRUwXqj4ZLr3fix86WBwxRUowLuCDVmkgkY
 mRGDSjiZ
 siWIweL0n2deB/UKtPRcUf8eH9BmJEB8jWRG82S0vAVo9VeVc6+5pvBOTeQ/cRGtpjNJDQfptpcZxFgLanE1FnzqRsjmJUYW8mH2B5vCpTtrcLFYoB9CZClm/93gd2akL0eu2rT8NpITQTbhHYK8bcDiPknZ9zv4duQ3WwgAHkq32warfnhc6/1GZX5mWYIj8vIkk7dMLpyg3WhBDcalehj/jZSpIjhAkQlvFsesC8gk8i0oofT9QNq/MagnuJrQd5l4RHJ0s5/gR+TGNzz9r1rhA+97g1S7bhgbAHs5EXMjAeg/QYdV7UWZ+kP17KUWG+FiwQXVupBlADlW1NX/oz73OGiXn3ndj47T+7G1R0AIvcmiu+Ykxa1tW+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Mar 02, 2026, Vlastimil Babka wrote:
>> On 2/25/26 08:20, Ackerley Tng wrote:
>> > __filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which
>>
>>                                                            FGP?
>>
>> > adds complexity for the reader. Since guest_memfd doesn't meaningfully use
>> > any of the other FGP flags, undo that complexity by directly calling
>> > filemap_alloc_folio().
>> >
>> > Directly calling filemap_alloc_folio() also allows the order of 0 to be
>> > explicitly specified, which is the only order guest_memfd supports. This is
>> > easier to understand,
>
> That's debatable.  IMO, one isn't clearly better than the other, especially since
> filemap_lock_folio() is itself a wrapper for __filemap_get_folio_mpol().  And there
> is a cost to open-coding, as it means we risk missing something if there's a change
> in __filemap_get_folio_mpol() that's beneficial to guest_memfd.
>
> As Vlastimil said, if this greatly simplifies accounting, then I'm ok with it.
> But the changelog needs to focus on that aspect, because I don't see this as a
> clear win versus using __filemap_get_folio_mpol().
>

FGF_GET_ORDER() indeed caps the order at 0. I was overly focused on the
earlier line where it did mapping_min_folio_order(), where I thought
other code could possibly influence the eventual order.

I'll revert to __filemap_get_folio_mpol() in the next version and see
how that goes. Thanks!

> And if we go through with this, we should probably revert 16a542e22339 ("mm/filemap:
> Extend __filemap_get_folio() to support NUMA memory policies"), because guest_memfd
> is/was the only user.
>
>> > +static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>> > +{
>> > +	/* TODO: Support huge pages. */
>> > +	struct mempolicy *policy;
>> > +	struct folio *folio;
>> > +	gfp_t gfp;
>> > +	int ret;
>> > +
>> > +	/*
>> > +	 * Fast-path: See if folio is already present in mapping to avoid
>> > +	 * policy_lookup.
>> > +	 */
>> > +	folio = filemap_lock_folio(inode->i_mapping, index);
>> > +	if (!IS_ERR(folio))
>> > +		return folio;
>> > +
>> > +	gfp = mapping_gfp_mask(inode->i_mapping);
>> > +
>> > +	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
>
> This is a potential performance regression.  Previously, KVM would do a policy
> lookup once per retry loop.  Now KVM will do the lookup
>
> I doubt it will matter in practice, because on EEXIST filemap_lock_folio() should
> be all but guaranteed to find the existing folio.  But it's also something that
> should be easy enough to avoid, and it's also another argument for using
> __filemap_get_folio_mpol() instead of open coding our own version.

