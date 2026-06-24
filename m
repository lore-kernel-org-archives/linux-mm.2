Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322A7CDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 23:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87726B0088; Wed, 24 Jun 2026 19:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11836B008A; Wed, 24 Jun 2026 19:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB22E6B008C; Wed, 24 Jun 2026 19:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A61D46B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:00:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0823FA0481
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:00:38 +0000 (UTC)
X-FDA: 84916327356.08.B969E93
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id E4F3240021
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:00:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="CKPE/LQt";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782342035;
	b=YdVnK/YWJMDGSWwKe6T/KyprHv1Mj9btIgyMZeIJixuGwupdvFYpkVLE7O9IUpKZKYxAoj
	3veioy1gZvwkQ6V/mmU9O2HpF3lEy/O0cVNByMeAdyDqOwq1CXsxfFsQ2+Fu762HE79Ebw
	DBodG8MwJdYgvD7SnuVUhh9gtCA/OyA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782342035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiDSxDdQCuoFNlxYLhHEIwl1aJFHoLPbVFXDv4LT02c=;
	b=jXOdnCgXteeoOP3GS80QRRMk1OmPC+M62gRz4SkqzEuZIJ1z07xTBKVm1Uphfr3FZTzduj
	OTePM75qpp6xMIACRcIgTBeb7ZcmpG7W6QCMS+tzX4nRvHwIP8p4Do+6Cy0kPvxyo1Tee8
	3sT8C5PTDWYc3uQEyzYWvVUMznIULWQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="CKPE/LQt";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-139a5f4ca15so1825046c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:00:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782342035; cv=none;
        d=google.com; s=arc-20260327;
        b=GieMwQ8W5HpQR1QhEm+qEJ9tpwCZkKUW2dyE+Hr9nXU2FCCjgiBfRyMY4Bp92oCRd/
         uv7meh3ozORbAn/kwFaW5ZmNWXSyq4BMia+iEUtHWMEy3cs1hFZRdCKtaioAbgoAjp3W
         1m1jYE5wQrMRQFPH1Io9EWNaEA9XKhT3IVe5B1Sif/uspwzXxDRWYGkf1xng0In49RQU
         UsakZ1iahA2issSjEkU8WsnWPF2zlOLPPov682OthSTW0fwmzuzSX8AHbZJsVswNugHk
         nBxCxGWYJGzJXKiW5BSa8iV93z77JvXGa+2VH8OI7G9yOBrPsxmj5krT+irt2zi3eJP0
         E6Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=uiDSxDdQCuoFNlxYLhHEIwl1aJFHoLPbVFXDv4LT02c=;
        fh=MQn2nfe5tKyDgtg8YzcPoB8frqxKvwkDbZMddiLEaHw=;
        b=Qo+3jVd+AdRDB2z6dMDkuKtOtGIkVtSayKjDTl1gelNSPbeIpPWHbntUIeB9ldEBZS
         vE8QbB97ZGgMcqw+a8OlY5fWTpGpZl5JI+y9yJzMj0KylNf3I0z42v8PhxE9HhIXpU6Z
         QwgNfhJxm8FmWSxeqIaIOeItfcUp/KkXySZF79kbV1DYWfD/Gvt+EQK2DoEo4y1AceK2
         mZNss6s9wnK6WziQOmsnGkTCK43ZGJRrJWyvPNmeNORaRvS2JKnknTuC+FlwKBnFxRju
         aaMq7MhYorzJw0kXCgVt2iydGBUHe1qZSM6YRQgD6Raat7sfgh3wbOebsHyUbPPt0jAa
         XEfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782342035; x=1782946835; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=uiDSxDdQCuoFNlxYLhHEIwl1aJFHoLPbVFXDv4LT02c=;
        b=CKPE/LQtJbMoG/VmTvHxx9QRi9yT2cT6CHEo0DShsyPyjeHVmSNrKsAeZz0m9ZXBj6
         HAltDaDoRNUPAbBhEZ/4KyUa+OtMSmAsPJ27SpDTj9M0Fo42kCN0EggaO5SvqNbQrzaK
         454kVj7Skw3nqkUD50FYg1Wvh1fR/bq3cFGh7raF0wOY8nkhsgcCRiNci6lbCn81X3DM
         zot8Ll+0Grezu9KgOhKXFnfhrtiW+RgbrHk+cls91VJe5uOWft8tSUso9W0WHBXIKAzM
         jEVtKLG56+qqTp625JomyJhiUh9uSK6/u8Rd2TLMj/8mszFb7wpCtXsKiIO2UWTRXNE6
         T5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782342035; x=1782946835;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uiDSxDdQCuoFNlxYLhHEIwl1aJFHoLPbVFXDv4LT02c=;
        b=quQGN9aHHKPPU/llDuSlT4/apGD38N2GHEoApkE6eZDHJWH4JLDjDZS59xNzrD52Zt
         Ka9s4/AfItK6fsmpRGO+CDMpI46247gDDPKOEKsjm6K19tH/JJODUHzzrZwIGvBPxJ4s
         VGNYWZ/NtgZxV/DtbZQW6Pi0269jSY+C72Y1IbJOt8xHVnCOIVWlbggUrslvTzaY6IRa
         fd1jF/uzBeeKwyiyVhwVlpCnscIRRnGSQfWR4KqzYLm1uE6MuYKyHIJA+5oLlirTf8Xk
         toWhJAQWrz6edCgT/XMosiCIBZtjcHN513H4Il3N35QJtE2krXIKI6l+0IQh8PDRIZoB
         zLMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/cxL+Pa9vSZxYLo381CjVeeyhuQQ7fXz2Auv2Hx9lw5uujdRmWvfg2MFUwd30fhgmaKjpKwKixag==@kvack.org
X-Gm-Message-State: AOJu0YwSiqyFZ7khPDYN+lCF5ru+Yv/yVWNXQGHj8+4bQLeOvGSf3wis
	bMxfm2qnmgj5l9HElcHuyATJeU76gnFonZVqv0fLYcd/o4DVVi2dmkpjqZwHRDfJRUsUkbrHobr
	1uWy8fXb1DSbvQFiYi4wDwSTysaTYFoz2lrYKFrwV
X-Gm-Gg: AfdE7cmXM63WMkLuxc9ktWU//DI5uvvT3Dr0fXWvsnlUKTMInH8vdWnG08u0BiUlcfV
	CzDvcX8sG2l5CniTZ3HNi4DeOnRHtphKgz5r3Pu9LFvQz90egAs+JsgNYr4kqQwyxusHSNq+7q1
	ZHZxDSUgSxlH3y32rCWOIVG/A4GpvtV36oJPlVNhPRHaPsu+V8rukFpf2IFYXdHk3F8HNKUyiHL
	4NVvAT02geSFMrOR9Ox7MT83TWnw8nxBe18YbxznB5PE/MaDNuY6DdwclINDNI0Ge5EVizCqiBV
	2Zh/tPzwZ04v4JIkdfrgBfDrbeIGz6IO9VtWdzKaI3BmjHSwkJ9RuuxCVvgK1h/Lzsf3sQ==
X-Received: by 2002:a05:7022:160a:b0:139:cf4f:3b80 with SMTP id
 a92af1059eb24-139dbb1250dmr40215c88.34.1782342033417; Wed, 24 Jun 2026
 16:00:33 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 16:00:32 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 16:00:32 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajxasFBzp_9KnQLq@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
 <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com> <ajnf5Z9nWZxoLS4x@google.com>
 <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com> <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
 <ajxasFBzp_9KnQLq@google.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 16:00:32 -0700
X-Gm-Features: AVVi8Cd6MsvMJuk5LYLyYsxDOenZ5WDyms3uLYv9lo6HnpeNhZqAtHcdl1tcM3o
Message-ID: <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
To: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E4F3240021
X-Stat-Signature: dq16k4mgpkwfgq1widakk9aqsk1u46xp
X-HE-Tag: 1782342035-843047
X-HE-Meta: U2FsdGVkX1+6i6Dm7PeSyfWa9id3ML5CDOiI3HLZcIoaiYOdZGzsQfcSCqeN4HRhhzrSMky1OYfnY8Kdl0GYEKAP+DdESPLlQ8ctI4QIpjcU5QzzS6NeA+cxva0ijSaHvWk8EWBx+kF5CTmlVcr9BVhhKqqI47mhWwS5Py5SAgwi9XENVlmRO9WVagc5ZFy0Z9KRaUS2L8gnBag8+IrMQHz/I4NakbA0XIz4xyanP9A4wod9LCYNQihhTmdipy3lRkJ7c064MWUi1KZAr2LQPYnU+hJPI/Bt3OLAEvr+Olq9kEBCgmlp+DEaXOq0Z9lnAT0JIIWF1fcMc0MymLLPJv/IbfnHANO6JvOW+Ns0sRulycI8Nz3662sH+5Z1Uu6oOOyTcWqPmffU3r825UruCsxNCeQA36kztW6svP3NSOv8IsT+v0um8hRPwm9CUEQq9ezvjW40J9UmS0B/9dKXXrBLeTDggQU9RO+0JocF0WtoSPcv+8dZnzVIPZhOvHFscQU+cCF5hqb7V9t7rUDmrA1Bm3/0GLaLBDMIUTy9UdtpOdfx4khlbAUy3X5n2VwFAyfytEWaxyQVQi6a89vN1+8+cc1etFBAvX3/38wP8UK5Qh94BocUd0cJ6JeseRCX76k7odZunfnsKtA53gRs0dKrNrFZX2GMDM+twdwVLvRgeFtL9Lmt/gg02i/e2jxth3Q96r+jqjJamxZ5mNC1SXDktHbrHf8Y9jziYrdv4NnfigdVn2NBGAvLmfGEj3W67MXIuNdXsmDcbyZA2d4hGgSW00fL/18DeuD4ph9XBC8zNSAUa6xjXFREphPzYBHheNORSy8KWG4PxoU2vpz5P6rTjxwOdXp/k9wJ0fSVACsF0sx5y3WAunrnwHjZ3ovTrHk9Sm76auNAOEUiR9YRWQKMnpmv4obLuERKMXZ4cqE+qbJAS8d0tzuCq9ZlfNsXFuFo5HDCYyA0AcQPHmK
 RfT1Ay5Q
 GPfNhNdGRvpmhb6mSsg29KxTP0Yp6aQHpWbxR19qjPlEO8uAebKZWuoLT1jWlhi6qFCpofeo/9oTrlrdjC/ekzULt4IQbqdMtdpyjH6fVmy5TBbK1cJ2DiQL4SQX+YK/1Uh6EF6VjW6FxXyGZsEHgHXIpr47eqFSyxhUve42MFj24uFtGdyuL3b59WdVXq8C014awpZHOYdKNp21ofuHpHLDdV+HW00bkfQXawItzphpaQroZWd2ND5eu53n+d+ew1+deUs74VNn6Xr7m4gv62DjRVzQBxE6mcQZfbgwGcsGgWd/fFXNTGe93+87UWaEKaxwpK9byhYvshEJ4Sq1U6A4UijMEwoWHODx7vSSzdpH9F07QtHaGW2LkLzZ8k0nDje+jbPXWNOMPdxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jun 23, 2026, Yan Zhao wrote:
>> On Tue, Jun 23, 2026 at 01:16:14PM +0800, Yan Zhao wrote:
>> > On Mon, Jun 22, 2026 at 06:22:45PM -0700, Sean Christopherson wrote:
>> > > On Mon, Jun 22, 2026, Yan Zhao wrote:
>> > > > On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
>> > > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> > > > > index ffe9d0db58c59..56d10333c61a7 100644
>> > > > > --- a/arch/x86/kvm/vmx/tdx.c
>> > > > > +++ b/arch/x86/kvm/vmx/tdx.c
>> > > > > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>> > > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>> > > > >  		return -EIO;
>> > > > >
>> > > > > -	if (!src_page)
>> > > > > -		return -EOPNOTSUPP;
>> > > > > +	if (!src_page) {
>> > > > > +		if (!gmem_in_place_conversion)
>> > > > When userspace turns on gmem_in_place_conversion while creating guest_memfd
>> > > > without the MMAP flag, the absence of src_page should still be treated as an
>> > > > error.
>> > >
>> > > Why MMAP?
>> > Hmm, I was showing a scenario that in-place conversion couldn't occur.
>> > I didn't mean that with the MMAP flag, mmap() and user write must occur.
>> >
>> > > Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
>> > > because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
>> > > and written memory.  And when write() lands, MMAP wouldn't be necessary to
>> > > initialize the memory.
>> > Do you mean using up-to-date flag as below?
>
> Yes?  I didn't actually look at the implementation details.
>
>> > if (!src_page) {
>> > 	src_page = pfn_to_page(pfn);
>> > 	if (!folio_test_uptodate(page_folio(src_page)))
>> > 		return -EOPNOTSUPP;
>> > }

Yan is right that with the earlier patch "Zero page while getting pfn",
folio_test_uptodate() here will always return true.

Actually, this is an alternative fix for the issue Sashiko pointed out
on v7 where userspace can do a populate() (either TDX or SNP) without
first allocating the page, with src_address == NULL, and leak
uninitialized memory into the guest.

Advantage of using the uptodate check in populate: if the host never
allocates the page, populate doesn't incur zeroing before writing the
page anyway in populate().

Disadvantage: Both TDX and SNP will have to implement this uptodate
check. guest_memfd can't check centrally because for SNP, for a
PAGE_TYPE_ZERO, !src_page should be allowed with a !uptodate page since
firmware will zero and there's no leakage of uninitialized host memory?

>>
>> Another concern with this fix is that:
>> commit "KVM: guest_memfd: Zero page while getting pfn" [1] always marks the
>> folio uptodate before reaching post_populate().
>>
>> [1] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com/
>>
>> > One concern is that TDX now does not much care about the up-to-date flag since
>> > TDX doesn't rely on the flag to clear pages on conversions.
>> > I'm not sure if the flag can be reliably checked in this case. e.g.,
>> > now the whole folio is marked up-to-date even if only part of it is faulted by
>> > user access.
>> > Ensuring that the up-to-date flag works correctly with huge page support seems
>> > to have more effort than introducing a dedicated flag for TDX.
>> >
>> > > > Additionally, to properly enable in-place copying for the TDX initial memory
>> > > > region, userspace must not only specify source_addr to NULL, but also follow
>> > > > a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
>> > > > 1. create guest_memfd with MMAP flag
>> > > > 2. mmap the guest_memfd.
>> > > > 3. convert the initial memory range to shared.
>> > > > 4. copy initial content to the source page.
>> > > > 5. convert the initial memory range to private
>> > > > 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
>> > > > 7. do not unmap the source backend.
>> > > >
>> > > > So, would it be reasonable to introduce a dedicated flag that allows userspace
>> > > > to explicitly opt into the in-place copy functionality? e.g.,
>> > >
>> > > Why?  It's userspace's responsibility to get the above right.  If userspace fails
>> > > to provide a src_page when it doesn't want in-place copy, that's a userspace bug.

Yan, is your concern that userspace forgot to update the code and
forgets to provide a src_page, and if we keep the "Zero page while
getting pfn" patch, ends up with the guest silently having a zero page?
I think that would be found quite early in userspace VMM testing...

>> > I mean if userspace specifies a NULL source_addr by mistake, it's better for
>> > kernel to detect this mistake, similar to how it validates whether source_addr
>> > is PAGE_ALIGNED.
>
> The alignment case is different.  If userspace provides an unaligned value, KVM
> *can't* do what userspace is asking because hardware and thus KVM only supports
> converting on page boundaries.
>
> For a NULL source, KVM can still do what userspace is asking.  Rejecting userspace's
> request would then be making assumptions about what userspace wants.
>

Also, +1 on this, what if userspace, knowing that pages are zeroed on
allocation, actually wants to rely on that to get a zero page in the guest?

>> > Since userspace already needs to perform additional steps to enable in-place
>> > copy, specifying a dedicated flag to indicate that the NULL source_addr is
>> > intentional seems like a reasonable burden.
>
> I don't see how it adds any value.  I wouldn't be at all surprised if most VMMs
> just wen up with code that does:
>
> 	if (in-place) {
> 		src = NULL;
> 		flags |= KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION;
> 	}

