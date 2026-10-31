Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB22C606A322
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cg4K3/Ax
Received: by kanga.kvack.org (Postfix)
	id F011F6B05B1; Sat, 31 Oct 2026 05:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8D16B05B2; Sat, 31 Oct 2026 05:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE5D6B05BF; Sat, 31 Oct 2026 05:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8FFF6B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:32:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91B0EC0651
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:32:46 +0000 (UTC)
X-FDA: 85382406732.20.74AA6F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C19C3C0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:32:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cg4K3/Ax";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVV37u2/JFMbTqwrO/nldhPTNdr2cEJ4JwbP51ZF0as=;
	b=zn9aBZ4EMuoVAVdQvTWPrEJjRyGfvJydtVNJY9IALQ4w1Ya9OORbVTDArF4exQfglu9Ovo
	SmVIvw5Qfz3LWxOlYGEMywzOzxut9CWvh90NtdtiX3ddIbmRXmR8L0BlOtpjAFqfDKLiri
	vYpo0NaUQxrI1xz2MhVqI1CO5rOuEB4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439164;
	b=1O+9KcpffvLo3emtorWHxfP0DaWMjHAJxQdsHsH+zaArIXWuPf04uV/MRNOFnpjnlo7saQ
	aB5XzsEvo16jjmlIOsd500Pne+nRiKhY5h+OonHMf4rvRBqQVQPuWBZqfKvPEpVglwRyl2
	YD63EZCpmLquj2OdP4Gj6wb9pQdGeZU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cg4K3/Ax";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D76040242;
	Sat, 31 Oct 2026 09:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CF61F000C1;
	Sat, 31 Oct 2026 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439163;
	bh=jVV37u2/JFMbTqwrO/nldhPTNdr2cEJ4JwbP51ZF0as=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cg4K3/Ax3YvyEFtn0SNP9CSc1Nk8veaJhxtFdP64CVmOxVBaqGziD6b1+pBnD2HCG
	 TVpmFTnFoZprPb5oow/zeRYBZiObDg94zPComBUYuYenUE4S3d209Zy+ZPC1Jj7kEQ
	 0gVgZmal7UaOb7UN+jTfYnC1bsVG3uHV+QGOoQhv14Un4veVVSB+CP1OIvNs9WoJvC
	 0+m11isq4Tnsx5Iacv8L+cTpIo6hCp70pcfqFrt+qJTnxkvekLbITYiHWgqwADr+vc
	 46MFftPD6d5QRa33rv24eA32zC4o7DU4fJv1ncoIwIe+TF2c/slf0sogg5/ApvFgMN
	 6yzm2FAR1D/uA==
Message-ID: <bb50fcfa-9d71-4905-a76a-ab7bc149d62b@kernel.org>
Date: Sat, 31 Oct 2026 10:32:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>,
 Andy Lutomirski <luto@amacapital.net>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>,
 Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>,
 David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>,
 linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
 <auTR9SnDLsLVmnJ7@google.com>
 <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
 <auVRLPmbWYvMnly-@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auVRLPmbWYvMnly-@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C19C3C0004
X-Stat-Signature: 4kokqynu4mmgfoj71g165jos1b8sy7xa
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793439164-495950
X-HE-Meta: U2FsdGVkX19ewnkfbh1wD3fGTnWphE5tK+A1S1zzJO+Rp79TXha4QIPp/EWrCeksSRRbpMHhKfs++AUJ3+YdcG+h7whXnGtMpMrytEyEdG8Gxri1dXh3Bj42FahYvdFRneb4JNLPBydm+XCX1ehJulSRsOTA9wxK0BoDjYZWlFCTVewEYhMhp6GsxkBsCXKUuKa06qHGO5XtDLZZnqijccxbQy6El/C7dTAr2OE6e4XNT+Whx4qk7/k1kpqDgvHvQEBiJddObPHWtySqXqe+N37c2/J0hTfXOLMOU1+RTZQxP8kzVlRoCdgvq9Ix3yj5UJ13v8YmIHLAHS13ijdXwC+vHCkJpTfIgYBnJZKonoCgLL7+p4sQ9bCkQl3oTo0f61CgsLAo31ry8jacU0plvqiEz7RwoyibhpyMS+oriZfhI4GRhW0nwYRB+/vS7sXMN5OMP1Pa51b25m1cR2h+82+dckk8EJl3CKpFCHxNtqFLA2YtD/vzRjSFw/mXk7jcsQ7yqPI2fKP+Ko/IF8Fwvk+YBf0LBUXjzuV31sVNQ+7jqUz63o9PwZJu7q7a/ZzyH6PLeZW2pgSWP5ZHp5I8uDGnapPdnbdHolEFmjVLO+dpyFf5LHR2RgD4xVpJVIVXlp+0dcRf3caNV8IBP2bwQJO1y2JEWdAzIzPTXN8E56N/tkRCe4UaMevYI+LVQCY1FH/94Wi2LjhwpBI9P7qvyxnDO9/NrvY19fZhwBvqiBz5bur9AaQxQgGUsttBE66cYchDls/UYtj7ZdZWJyyn+K7YxRitWVscph5cqzj0LGWLWO8Anr+T1y3IWCJkvPF49Xt/otJrW1+t0j9H2iVPQ8h3kbmX/3NbI/Dj0pb4fvg768T5Ns6l74Z5CHTyjkNceE5F+jvUyostDgIOLZFs3+Nj9ZQrPlSwwFWad7GTea0Sr4pt41Mr5Y3mWDBADf55W+zDKr1EUjvASKI/yGS
 3F58UFkc
 FyAfCtcbtaUWKyLdWmIEXDrxL4oqpX0ZBlSfl2e/K3c4au1O/4JVqdb11sAJz4HuyH4NzReFyw71ijMGwZvojdDT2mQ416zK1H1fVyprYKeCzHleAgQeRZ3u0HN2bNVFKPp+vpj+XTZDaxULfc/tUXrzentQ1vQr1ImzjHvm4u7Vkk3wVvFRu0rZ6fvODfF4ZWd+OSjd/dsFxmP5rDmTcSMW13fqkUIzh+lJ2bxV4V5hkxXMMLEgWqEfDl9X90ZrvtN5bkzhr30cr3oXU+3MRA2mRhXnwIMvl3dKXKaEMwt1yzduu8bjkYPoPTmhw74OTfHPOvt+VvsrwYZsutj28GBnd8JUZ6nWAKWwU+p+QwPMAj0CKsX8x1xfHe8tPolIjikre4WuigKLHPKFtomQpFGFtL91ZoVYlwpbqTjGUxgK0e6Mo+m2hnF8c2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 04:03, Samiullah Khawaja wrote:
> On Fri, Oct 30, 2026 at 03:43:53PM -0700, Andy Lutomirski wrote:
>> On Fri, Oct 30, 2026 at 10:40 AM Samiullah Khawaja <skhawaja@google.com> wrote:
>>>
>>> >On 10/30/26 13:11, Jason Gunthorpe wrote:
>>> >> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>>> >>>
>>> >>> We have the exact same situation when userspace maps anonymous folios
>>> into vfio
>>> >>> and then desides to MADV_DONTNEED the pages. Or any other memory backend
>>> that is
>>> >>> used for such purposes.
>>> >>>
>>> >>> User space must not zap/punch things that might be pinned elsewhere.
>>> >>>
>>> >>> That's not specific to memfd, udmabuf, iommufd or anything else.
>>> >>>
>>> >>> I don't see a reason to make userspace (that should not shoot itself into
>>> the
>>> >>> foot) a kernel feature it must activate itself to not shoot itself into
>>> the foot.
>>>
>>> Agreed, for normal use this is userspace's problem. The seal was meant
>>> for the kernel to cheaply verify at preserve time that nothing was
>>> punched.
>>>
>>> >>
>>> >> The issue is live update doesn't preserve those background punched
>>> >> folios and now we have created an UAF attack on the kernel across
>>> >> kexec if you don't do something about it.
>>> >>
>>> >> There was some notion here that with the right sealing flags we could
>>> >> tell if everything was 'live update compatible' and then know that
>>> >> these attacks are impossible.
>>> >Just remember that there was any hole punch and refuse to live update this
>>> instance.
>>> >
>>> >We could likely implement "we saw hole punch on a pinned folio" as well, but I
>>> >don't think that's required initially.
>>>
>>> If I understand correctly, you mean recording on the memfd that a hole
>>> punch happened, and refusing the live update if it did? That would work
>>> and is much cheaper than what we do today, where iommufd walks all the
>>> mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
>>> is enough or I can record that also on the memfd. I will send patches
>>> for this.
>>
>> This entire situation continues to give me the willies.  After much
>> prodding and contemplating (in my own brain), I got a friendly LLM to
>> report:
>>
>> --- begin AI output ---
>>
>> IOMMU_IOAS_MAP_FILE uses memfd_pin_folios(). Collapse [MADV_COLLAPSE
>> or khugepaged] checks the old folio’s reference count, so a pin
>> acquired before that check makes collapse fail.
>>
>>  The problematic interleaving is:
>>
>>  1. collapse_file() locks and unmaps the old folio, then passes its
>> reference-count check (mm/khugepaged.c:2446).
>>  2. memfd_pin_folios() (mm/gup.c:3483) obtains the old folio from the
>> file’s XArray and pins it, without taking the folio lock.
>>  3. Collapse copies the contents and replaces the old cache entries
>> with the new huge folio. It does not repeat the reference check or
>> freeze the old count.
>>  4. IOAS retains the old physical pages; accesses through the file
>> use the new folio.
>>
>> --- end AI output ---
>>
>> Is this correct?  I haven't personally verified it.  But this whole
> 
> Yes, I think this is correct. memfd_pin_folios() pins the folios
> directly without taking the folio lock. Other page cache lookups lock
> the folio and recheck folio->mapping, e.g. shmem_get_folio_gfp(). Only
> memfd_pin_folios() misses it.
> 
> This scenario is different from punch hole or MADV_DONTNEED where the
> user decides to remove the pinned memory. Here the kernel is removing
> the pinned page without the user knowing. Collapse already checks the
> refcount to avoid this.
> 
> The recent fix [1] by Chris already takes the folio lock for !uptodate
> folios. I think we can take the lock unconditionally and recheck
> folio->mapping, that should fix this. I can send a patch for this fix,
> if folks agree.

I have another patch from Anthropic on my "rework schlop" queue that should fix
this:

"mm/gup: pin memfd folios under the folio lock".


We'd do just what we do in other context now, which is checking under folio lock
whether the folio was truncated.

Care to send a proper fix?

-- 
Cheers,

David

