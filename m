Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5443606A320
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 19:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=E/9pEJTV
Received: by kanga.kvack.org (Postfix)
	id 3B11C6B05B1; Sat, 31 Oct 2026 15:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362046B05B2; Sat, 31 Oct 2026 15:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252346B05B3; Sat, 31 Oct 2026 15:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F33C36B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:30:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75DCFA87A1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:30:45 +0000 (UTC)
X-FDA: 85383913650.17.C3EDFAA
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D53C4000A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:30:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="E/9pEJTV";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793475043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8QGpnyPZ7DhkQpiphg595uJGsoBZBg/wk/3XMNmDqI=;
	b=1Jlyi4jDb2FZz0zonqstPZUNI1PJ0XF3yhfzHZZ+TsOi9Q25jUIfiKoD6Ih+f5UE3TIpyK
	7hm+px+RLtvLBCQoRnA1A3nUc9O+GQZjrF6zNoskIRZQdAyw0AFjJT1o2dLXKGgAe+9gep
	KmVGUe4ClUFW/AmStt8d03FbfasjCYk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="E/9pEJTV";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793475043;
	b=fLqQXxMyoq5HJ+Z7k4dmCePmSyZd9/RXFi6RDhFdT3rznCPs9+p/cMAcaL7m9G8su55yCa
	KA6wanffuYvaKqe94QPGvrG74YirLflXM7LTVqeI/1nqF/tfECj3UKuK1PhmEIu9ahPyhD
	Eka7tSgUWYwF59lYxz2EH/jTTWP2pqA=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e9f6a16afcso31745ad.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793475042; x=1794079842; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+8QGpnyPZ7DhkQpiphg595uJGsoBZBg/wk/3XMNmDqI=;
        b=E/9pEJTVAGpOHtP802Mr9kHshtuLfVQA7fK0b7A1dEuhYeF2xcb60oJTWZQQqJCsvp
         PAZ/vN4iUK3brCyd5sVGYRy77a/4+Q4bK7KU1kjhbubb8kFR1+/hmJEfHdI6JLYMU+tW
         SFKhS8bnJBBbC7GHIwPkyQCgiWnDjFfw24VeuU4j8Z61S8EAaTTtN90R8+FW75GYvjTE
         mxVD8/biYzGSNauW0Xi77tOR5cNWwt4R2FTVVLE5FlvJxCukkir+TxVWkxTLKOFU5dTa
         dB+kAx8bqOx1UT2YgjyvxjAA7DgDTS4O/HhIyImplEIEBLGHuee8E06BXGJR2tRXSCE+
         fl+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793475042; x=1794079842;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+8QGpnyPZ7DhkQpiphg595uJGsoBZBg/wk/3XMNmDqI=;
        b=ZNaacvDx86yUv/kJTAk814rB2y5SVxhfHAJY//VV3NIrV1z53AwWWE8BlUDkOQO4Sc
         clhfdArUtrn/EgEvg3aKxfr5RbZlyInsB9aPkI+/ww7z8w2PW73cpUdYOpC1+909vHK7
         7OQDCgmRh7L3DF7PflMpyFsuYbNki1IGg0mPPBJXzXB2m7RBZkhf9TUrlZPRhaiJeCIT
         oQxbKTTnumIIVjAaEUY+7tcRdz0M76hAxxRwQiUmO5aH63WMKKdzAt3wrQ+KI81jP1Qv
         M4kUzobFzjYjAELcwJPXr0xUUgouyTc504/DmuFVi+4mtpj6yJ6MPvk9pvGMMub9gXXv
         NPlQ==
X-Forwarded-Encrypted: i=1; AKwUvBzf2gG+jAJkpyjyNMcQVMjqM0UdArXdvCrqiuttbDXZJbx05EQRArDiX/kqb3dItwdQ05y+AHmusA==@kvack.org
X-Gm-Message-State: AFq9FYK5aiBWrrp0ShW1Hbr8CtEZmlXOfacsdpp3XEHWNWR2en+5nhKx
	xXVJK7VrhIWaZR8jKSvwSjXzaCqQ5ug9x9ZvUiqVkX0Pwawxj6uj8N+2vu2h1CDVsA==
X-Gm-Gg: AYBFou25w1TuREZYjHJKYlmn+6w/KScm62AG2hFtCYOoPW2xpKgovnEX1I0IoHXYEUt
	aGSoxztX4CpxiCO1JhTpbK1R2vXoRDuIiRUHfn0DMfRoUHOQpUUBdFQQ30/aqZnkv+TEUG2hvwd
	cAQH63H47qgT3VEoDu6qSmlsciEQeRqONzA3eu3caBOGH+eQWKBRmet+EhfwAMNIuIQSX5OAyEl
	PIM2Epi5OHKqfNEIV4ua+Bn4jOtIbA6DRi2wmH3FnD0vb4OFHvnhDbegHAXxufl8b4v2hhuiCDi
	YNkJRrEv8UyTa43ho35Vf8nqAzaz8hBDP2nrr5FC7npVIdPwfH9xwcDC5F+SOt+UanSyfAAjAEQ
	C6RguL9XlbLvxCmqJvAYyflWgujuCvlmYxwrHBNMy1t9boMRLq4GKsBFHwQsMo6P8MV6OUu6OT3
	85lMSDaqTMAe2NC2Z2qysUrf91+9BNeKoTdAYjVEe9daV+Vxrdcii4qJi7IzRWV/nQB5BAcAs3D
	92Ns+qMA8ne0QPMPZ+okOkbDWWPuibqHixKgbuVBFsLe/Xn4w6kWNiLApjFuHjjjaAGWZ1tRMPX
	+jrGDawFTemYsa+PlokLo5YD3rkbQjWmiumdd+myXnXmOIbzKdNN41FnZIz6Ikw1widhi8Yh14V
	OWEz3/IbD+cA/gE4ZrcYbRw==
X-Received: by 2002:a17:903:3904:b0:2e2:d665:6ad8 with SMTP id d9443c01a7336-2eb1b81b9e8mr16615795ad.4.1793475041906;
        Sat, 31 Oct 2026 12:30:41 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9b1506sm12552004a91.15.2026.10.31.12.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 12:30:39 -0700 (PDT)
Date: Sat, 31 Oct 2026 19:30:36 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auZAViCjlzN3gd6g@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
 <auTR9SnDLsLVmnJ7@google.com>
 <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
 <auVRLPmbWYvMnly-@google.com>
 <bb50fcfa-9d71-4905-a76a-ab7bc149d62b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb50fcfa-9d71-4905-a76a-ab7bc149d62b@kernel.org>
X-Rspamd-Queue-Id: 9D53C4000A
X-Stat-Signature: f1syyz4769pnaobwjdjw4kitf8qnmcuk
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793475043-612734
X-HE-Meta: U2FsdGVkX18LH9ru14X9F3UkkyzMgZa84mqIDmSDQajPc0fG1DcpQcnRCQp2IoRw/54rLW8/2CJeUFLuFTGClMIF/JZg8ZUU+h/SLHr3ULsREunax6Z5eZGu1t9QliKLi/SdqisqLLR3h6Ha17dupd92nBp4DtsIYWKMeLQLeb3SWZe8cd0AtDZuAiyD7hOoDWc/TNMAihIJL3dwEyy91srAvrUolRYY2TZPW+lI8qy1NP8USHyEYAVz9EuhrGM15p2XMCvJQlcTdBEx06VTw0pSCMufRjbzkQKesE8jZUJLSHaz3+LFlfuyQKTvR8QkjIg8lQK8rYwLMOanOefOZFrO7x7ufJb6I0IibxUSuwoBzt/FCtyY71EYeJqTl6z0Wk/5gu7b/MVPlEWZ1bstqHBIhONKJnFxoRRS2QlP0uJqFEsE4GyZE4Eg/3TvMLXlOVIPu8HVEL1yq2MYcK3BzgPpJRh3KXxWfv/2XpRjfdFCgsF+qd6XW5DkEKX4NHnfUtVo52uiRI2/kMwMk/hSOOSUHn9i51LA7w84wEUmHlPoOGmbJwMkRVz4cuGTmQ/yn0uwlPpb4r+3hZZM8lbnkuPHgQYyMvWQtq1hM5lKCfALjAAxTBCY/4+wJAPeODT74Kk8ixSWfTlT7Sz8wsYm58nWwEfcW/KFi2AV7okKCJybbGQ4G0MM4rZZ9SetZhbBKaElwyYSVyr3SpI51+XXMzXV7KzTVTXmtiPih7L9Up25whVkOaSWxjNhExajzx8mmpmdaIcmFtcRtQEgA6MCh9zhVdvveWajitKOdK1EPB7HSJRToxJfr3YeQdllnmS1mY8YZy7/slnJo1PgL8uhYMMi9J3iN4S5cScW3kECnY1z3tVFwJNHYMv2HDINfIHVTt4gXXKeGjXqWG5k/d6K2DvrNVWYH0iVjAepzN8cZereEPFfM+I1ejWY3dm7TEdWpUOlp0Eo6p5A3Og1mN6
 8DlqTyso
 XYoXl7f1HHj7SThGVUImNPoVhx4vkUaJBkLQ9seMQC4egvQGPmhm4XDDwmMkDl9uqE5XmMlkjR5VCkw8tW1QNKlYdtUN30xt0yBwpeitcAe0m/0+MVW0tamQ0hI8OshKpJ78DzXexhrxhYR4BN8hf3t/fNMHbOcCx/AwliaA9RB0p1PlyK8a1nEk8sDiu6KowhEYsP/6HMxLPSvDvjPVUmaGQPtRgVOwGCfqiyOGe+jE2V+axlNZ9QTuobJM6UI0FdeXq3NLen1zrLtAm+ICq7JQA+9IIbxAv4S1055vQ5ysKlRN2Q9Qy8Z2ZzYZrbptVCi0AH7piWBTETZWbjnaH/jnXErm6kBI6h7f1fAiwtKTNH9EBiW5n9DfawrwhTezN7ZO/JFoAmJacNv44MFKiAu0N0QqvkCSJCf+/nF1A8OtEGmiFn0QD8sykQHvtSFN3tuK3NBiHaq/jzbhq8awfRk6cv+E6pr+d6EssnBzO/91K150mbpcfLosp4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 10:32:32AM +0100, David Hildenbrand (Arm) wrote:
>On 10/31/26 04:03, Samiullah Khawaja wrote:
>> On Fri, Oct 30, 2026 at 03:43:53PM -0700, Andy Lutomirski wrote:
>>> On Fri, Oct 30, 2026 at 10:40 AM Samiullah Khawaja <skhawaja@google.com> wrote:
>>>>
>>>> >On 10/30/26 13:11, Jason Gunthorpe wrote:
>>>> >> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>>>> >>>
>>>> >>> We have the exact same situation when userspace maps anonymous folios
>>>> into vfio
>>>> >>> and then desides to MADV_DONTNEED the pages. Or any other memory backend
>>>> that is
>>>> >>> used for such purposes.
>>>> >>>
>>>> >>> User space must not zap/punch things that might be pinned elsewhere.
>>>> >>>
>>>> >>> That's not specific to memfd, udmabuf, iommufd or anything else.
>>>> >>>
>>>> >>> I don't see a reason to make userspace (that should not shoot itself into
>>>> the
>>>> >>> foot) a kernel feature it must activate itself to not shoot itself into
>>>> the foot.
>>>>
>>>> Agreed, for normal use this is userspace's problem. The seal was meant
>>>> for the kernel to cheaply verify at preserve time that nothing was
>>>> punched.
>>>>
>>>> >>
>>>> >> The issue is live update doesn't preserve those background punched
>>>> >> folios and now we have created an UAF attack on the kernel across
>>>> >> kexec if you don't do something about it.
>>>> >>
>>>> >> There was some notion here that with the right sealing flags we could
>>>> >> tell if everything was 'live update compatible' and then know that
>>>> >> these attacks are impossible.
>>>> >Just remember that there was any hole punch and refuse to live update this
>>>> instance.
>>>> >
>>>> >We could likely implement "we saw hole punch on a pinned folio" as well, but I
>>>> >don't think that's required initially.
>>>>
>>>> If I understand correctly, you mean recording on the memfd that a hole
>>>> punch happened, and refusing the live update if it did? That would work
>>>> and is much cheaper than what we do today, where iommufd walks all the
>>>> mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
>>>> is enough or I can record that also on the memfd. I will send patches
>>>> for this.
>>>
>>> This entire situation continues to give me the willies.  After much
>>> prodding and contemplating (in my own brain), I got a friendly LLM to
>>> report:
>>>
>>> --- begin AI output ---
>>>
>>> IOMMU_IOAS_MAP_FILE uses memfd_pin_folios(). Collapse [MADV_COLLAPSE
>>> or khugepaged] checks the old folio’s reference count, so a pin
>>> acquired before that check makes collapse fail.
>>>
>>>  The problematic interleaving is:
>>>
>>>  1. collapse_file() locks and unmaps the old folio, then passes its
>>> reference-count check (mm/khugepaged.c:2446).
>>>  2. memfd_pin_folios() (mm/gup.c:3483) obtains the old folio from the
>>> file’s XArray and pins it, without taking the folio lock.
>>>  3. Collapse copies the contents and replaces the old cache entries
>>> with the new huge folio. It does not repeat the reference check or
>>> freeze the old count.
>>>  4. IOAS retains the old physical pages; accesses through the file
>>> use the new folio.
>>>
>>> --- end AI output ---
>>>
>>> Is this correct?  I haven't personally verified it.  But this whole
>>
>> Yes, I think this is correct. memfd_pin_folios() pins the folios
>> directly without taking the folio lock. Other page cache lookups lock
>> the folio and recheck folio->mapping, e.g. shmem_get_folio_gfp(). Only
>> memfd_pin_folios() misses it.
>>
>> This scenario is different from punch hole or MADV_DONTNEED where the
>> user decides to remove the pinned memory. Here the kernel is removing
>> the pinned page without the user knowing. Collapse already checks the
>> refcount to avoid this.
>>
>> The recent fix [1] by Chris already takes the folio lock for !uptodate
>> folios. I think we can take the lock unconditionally and recheck
>> folio->mapping, that should fix this. I can send a patch for this fix,
>> if folks agree.
>
>I have another patch from Anthropic on my "rework schlop" queue that should fix
>this:
>
>"mm/gup: pin memfd folios under the folio lock".
>
>
>We'd do just what we do in other context now, which is checking under folio lock
>whether the folio was truncated.
>
>Care to send a proper fix?

Sure, I will send a fix.

Thanks,
Sami

