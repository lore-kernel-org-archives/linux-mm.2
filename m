Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FAC606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 03:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N1PToDuw
Received: by kanga.kvack.org (Postfix)
	id 8A8BF6B05B2; Fri, 30 Oct 2026 23:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851D36B05B3; Fri, 30 Oct 2026 23:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7407D6B05B4; Fri, 30 Oct 2026 23:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4338C6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:03:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C41BC1608DF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:03:30 +0000 (UTC)
X-FDA: 85381425780.25.FD6F3DF
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id AFF1120003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:03:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=N1PToDuw;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793415808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CykDRQmyupGap9MJ8JD7H5K9Ycd/s3V7wlgI2ffH55o=;
	b=nNM1rtb2gQmizppWmqCaiHWRlmS4jNNdlIEjOdKtGkJvhjfRy0mddhpBaGGWtVwZl90/2l
	W6NYwZ7y23hs0sDGMmOxAlQ0OZOf38TyUj3iPeDp6/gUHUYzL1idrWka7FFaBanEwKddeU
	RGlwT5F1TMpwuuFnG6nnBqDSnM0VHY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793415808;
	b=PPD/c8PEfIAG6neYm2kqu1FCFjqR0IBgUwPNVtxBbLWDMqyxB9Z8R9QNHTjOZZDYtNwDSj
	HOG4u55oudCFaYRsvmJ4GayclzBbELcuDevN16KUgdl+f1PuyafrFVHP4lYGljLFufFI0y
	nE/KKj9YTW/rp9aswsXjh9P7gIXbBt0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=N1PToDuw;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ea7f9c11e6so27505ad.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793415807; x=1794020607; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CykDRQmyupGap9MJ8JD7H5K9Ycd/s3V7wlgI2ffH55o=;
        b=N1PToDuwCsu2drN0L6iVSHSh7VjWPZu7Z2HDyjaJBD9rcpxcZaFsO0fqpTmlhJMLtw
         BEVpkjYo40eeGW1tFAaC07tuF0PK858YbUxzA52C+CQezJChXwtQz6FEuGrLy0DhzFbB
         XmgDPa/+F4+QJ1tmNZ241IeU2AegsN3sFWnVc6UjaMEOO9lS3XViOWV6e2MHG+P9vmVm
         4lbOog8DXW0HVlwlWd5K/3gtcKt9l70nNCQjaXWARn0TZpbN92b5Urz48+och+pSLvCk
         kEUwDFCY5pUobaYX9bwtcpGx/S1NMHB58slwwxTwggk/VWBpw+c/2+Lz8Z3Qay6ozkQT
         3fsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793415807; x=1794020607;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CykDRQmyupGap9MJ8JD7H5K9Ycd/s3V7wlgI2ffH55o=;
        b=vMPz3I40vXgvUjZP82X64ALGWPb5o+S87ia4NU71zanT74UkaZo4Qf1sVk+uVAYW1e
         OkGHy//Kl/x99ZbZbtBL1/0Kuv/AloDVyk1R1F6wgjdGJD4U2ps1gvHlR/Q9GP4OJPqD
         d4/Q3TLEGZeVNP1oYXYhgzkwStP395vS6Ef4Flh5VwNzONdb4ZYOlm9KNroHiiGZd+zT
         PCPbUI7z1RR6y4XLC30BKm3b7uVqEEEX0/fMphmroFSh0k3CFDAzD26Qf7VPC5yHAaZR
         WQAtPOb9MY9nSAmEVEfJTIXI2gsvPvLxxLT++mVS6EW083T4ItF+QAgVY/hFLJxFu4/A
         hg/Q==
X-Forwarded-Encrypted: i=1; AKwUvByg3nY79LtXFxt/p2VcTp9CQwHA1fWiymgu+MXEwxbnq1N0U5WChQsf7x1KgYh4oue1YphUVK3XqA==@kvack.org
X-Gm-Message-State: AFq9FYLuc3oPB7Yiaowntry9G1Ge4F9vQMmrlRGvxjGxY2p82Xkvej5S
	Dg/DHL3IYCtrcvhHk7LS17D2QMH4xehp9u2uolex6xBMjUpCoS4UbavWr58fMCD2rg==
X-Gm-Gg: AYBFou26whVeq4Ep6FMMdlClV0pBo+G7ItFYsZw/4gnr+O3vLeoJmGSsxiIvy3qEuy/
	Oln1i9JMnTwR+gT8R+9+EOzDov9gIrHiAAD/m22zRyOS31Lo/Ff+g9Z1ssVRCjaCe1eqjkoDLYi
	e/JWWTDlGeu07iECFIv8kUiLP7NGWyHgBSiLSSsFBgYSK9pUrDZLWay8lSFmRz93o/H4oQZPqTN
	7SfVDBdEs6HFmO8+Ci7X0d0rmZ4TDzekJEyULW1nqrfi4rzFVayaWF2PZXL6ChrxU1BhH1r28Iv
	/8jvzbsDnR5Exn7QrweC4a94lBr2nwwKjLwN4eFaS62p2GRhCJKUAbN/+0Drd8xrPP3FeM/fxRO
	rLvEla/FCeHYCv41o/tSbIZ/eL5DSX5q5A3wTir9nHCKVvE4yv55lFU8l7vLqPwW1JXReXvt3tU
	I+v3WvwEXbyYKzou1BT/p0kQmZwV+UcXt33IbD4WAoLYEK19qESwGeM7ydLDN3ZDt6MTgUp417v
	eQeqgRzCQkyk6SEM54TNvbEZ/ZqJZ8EauhRFenfq0OrZI8M2klVDsPUTickUPBmyy9xLu/1zmKa
	mn+G9vEn+YlxoZcredvpAFOj+iRdOFNjK2JZAvZwRo4rbjqh34FYaEnIPJmjaO5ATyYN97BrqEL
	qoOt/GJ3YkueUaSZ5EqqcRphby3eyiJGzS0eDxyI96yE=
X-Received: by 2002:a17:903:2c04:b0:2c9:b404:b55 with SMTP id d9443c01a7336-2eb1b8c1cddmr13716365ad.6.1793415806880;
        Fri, 30 Oct 2026 20:03:26 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845429e6sm5927972a91.6.2026.10.30.20.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 20:03:25 -0700 (PDT)
Date: Sat, 31 Oct 2026 03:03:21 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auVRLPmbWYvMnly-@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
 <auTR9SnDLsLVmnJ7@google.com>
 <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AFF1120003
X-Stat-Signature: 9dc899h6a5fsab33m1ifzmi35q5ye1gf
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793415808-433538
X-HE-Meta: U2FsdGVkX1+o0jqVOdCg0U4UFLoTRZAgIhUcdQgb+FjCgHJjUHOIC2YrhnbCdjCxztfYTjEU3wtoSy9SWnQxipvnF+oad/rEBtbcqrcTwZ5TMkt+L8VexawMaypGmwQJl0VL/HlzZRDN0O+o/o5PO5Rh9aiRI7cW01xMBNiSIazaQjqUp0p8Ey9Jafw7yoapQGqpLgMaBNkQox6DKrZTTeYlr5BwQrQXUQam2fwEY9jPP/L5B1YESw9PYs78+aKRHPk9k8AOZIKGRWGykffb+0EudXACqLnFpH6ZnQkLJcnlMUCT5CYZpVnrmTmcQs771cNFojxXbfJIEDpO+kPR9O3yfZd7LPwL3bqLCRL3nSW+x8w00KX52/3ug50fNb8VgabIbS0u+LNLlri4P9MFpBYiHKVaiwkKDal0o1PfMYbpITvKhG3GqXX6QVKfGIRqf3XolhzE8VR+8GTepQwrpRpEnoHCRijM/lRaz0XhYOATyY3/Rm5QskoASBk6nLstl9a+BV/DN5FJFAkJg+QxYFUihmMOCFG8kOvuTB0SSsg2oCBroRfo8cvhGUIlc/jRKTNGvrP05pOzMUmBzpqucGTBZxCqQ+qdiEdNjWmAkpgMC7uNlyo8q0x2HbJQwoJ4rmfcIpSfDlQ9w+Rl4wL9bc2toRqbs5SrNYY5S6+blEyA78Qbdh8a+7IsD+GXgpTnji31FegsCXxtgBm1QWt/vVEV+9QB5Q7hj9ZCwGSPRZ9ZbmvzZ/2PEUcepCxRaXnkGMTOySFZwrhCzN2EPC4cpBzu7iRbkVpElS8PrHAsv7UqRDuxiT0B4SHAjuBLgFfCUBAxLbnxBu25mI/bbtYbfICQl4ysSyryMAgj2GE6m1Eg2hW+nwZPZlEm5rL55B1iChWIvqzqvYt91B20LpOzT3LzI5aq+SJ1PObaJao05ZsteC97c7J9t+XnKIz1tZKm6/ji7Bo/H//yKD5+O/g
 SnRQtxco
 SQGh1+IYHmfTyR5KFMpfPPpoXqFMjhPBQgerTWQafrwiny6fMCPAQEuAz3/CpLI0GOb4vjPZtd2j3eIoTfV1CKAd4iiJTagXPZOI8P9qMSNN5dz9Lbecg3R2nu9877sgciDbJolH37b/xBSBq3T/xemTtGiR2V77++dANXA0H6qW4C2lSgC9jutFfKid+wSvzkSecWQa7DtRrWuCxMtxQ9NX/eLY9P+yAijXA9EiyXPltiDt1PKRv3GTaZ2REEwxZfkrh/SWT9IfwXnr+2v/yL++2tfEWRU6n9Bp1bwJTKm2HeAqa35fbeU1lk5Z5O5T/qK+vWcijuHkZyQF30xXwyNtAIUbdHfogj/OpsfvWZBlNHcGKUYrtYI0iloaS0y+q8nobDFh1SfktaRFpVV76FJL0O5vUhPoia/PCXRpXYP51kEb4Q8reIQsdMR/HZxlxpMNjkVcBGXjQj1K8yFWtZOLy0Qnc3pttjV/uF/D8PtXJME3LnhHr6K/ZGWMGDbXWUpbINZKv0QdQFQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 03:43:53PM -0700, Andy Lutomirski wrote:
>On Fri, Oct 30, 2026 at 10:40 AM Samiullah Khawaja <skhawaja@google.com> wrote:
>>
>> On Fri, Oct 30, 2026 at 03:39:40PM +0100, David Hildenbrand (Arm) wrote:
>> >On 10/30/26 13:11, Jason Gunthorpe wrote:
>> >> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>> >>> On 10/26/26 23:05, Samiullah Khawaja wrote:
>> >>>> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
>> >>>> holes from being punched into a shmem or hugetlbfs memfd while leaving
>> >>>> the file fully writable.
>> >>>>
>> >>>> Background
>> >>>> ==========
>> >>>>
>> >>>> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
>> >>>> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
>> >>>> device for DMA. Pinning keeps those folios allocated, but it does not
>> >>>> keep them in the file. If userspace later calls
>> >>>> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
>> >>>> the folios are dropped from the page cache while the device continues
>> >>>> to use them. The pin holder is never notified, and from that point on
>> >>>> the device and the file silently diverge.
>> >>>
>> >>> We have the exact same situation when userspace maps anonymous folios into vfio
>> >>> and then desides to MADV_DONTNEED the pages. Or any other memory backend that is
>> >>> used for such purposes.
>> >>>
>> >>> User space must not zap/punch things that might be pinned elsewhere.
>> >>>
>> >>> That's not specific to memfd, udmabuf, iommufd or anything else.
>> >>>
>> >>> I don't see a reason to make userspace (that should not shoot itself into the
>> >>> foot) a kernel feature it must activate itself to not shoot itself into the foot.
>>
>> Agreed, for normal use this is userspace's problem. The seal was meant
>> for the kernel to cheaply verify at preserve time that nothing was
>> punched.
>>
>> >>
>> >> The issue is live update doesn't preserve those background punched
>> >> folios and now we have created an UAF attack on the kernel across
>> >> kexec if you don't do something about it.
>> >>
>> >> There was some notion here that with the right sealing flags we could
>> >> tell if everything was 'live update compatible' and then know that
>> >> these attacks are impossible.
>> >Just remember that there was any hole punch and refuse to live update this instance.
>> >
>> >We could likely implement "we saw hole punch on a pinned folio" as well, but I
>> >don't think that's required initially.
>>
>> If I understand correctly, you mean recording on the memfd that a hole
>> punch happened, and refusing the live update if it did? That would work
>> and is much cheaper than what we do today, where iommufd walks all the
>> mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
>> is enough or I can record that also on the memfd. I will send patches
>> for this.
>
>This entire situation continues to give me the willies.  After much
>prodding and contemplating (in my own brain), I got a friendly LLM to
>report:
>
>--- begin AI output ---
>
>IOMMU_IOAS_MAP_FILE uses memfd_pin_folios(). Collapse [MADV_COLLAPSE
>or khugepaged] checks the old folio’s reference count, so a pin
>acquired before that check makes collapse fail.
>
>  The problematic interleaving is:
>
>  1. collapse_file() locks and unmaps the old folio, then passes its
>reference-count check (mm/khugepaged.c:2446).
>  2. memfd_pin_folios() (mm/gup.c:3483) obtains the old folio from the
>file’s XArray and pins it, without taking the folio lock.
>  3. Collapse copies the contents and replaces the old cache entries
>with the new huge folio. It does not repeat the reference check or
>freeze the old count.
>  4. IOAS retains the old physical pages; accesses through the file
>use the new folio.
>
>--- end AI output ---
>
>Is this correct?  I haven't personally verified it.  But this whole

Yes, I think this is correct. memfd_pin_folios() pins the folios
directly without taking the folio lock. Other page cache lookups lock
the folio and recheck folio->mapping, e.g. shmem_get_folio_gfp(). Only
memfd_pin_folios() misses it.

This scenario is different from punch hole or MADV_DONTNEED where the
user decides to remove the pinned memory. Here the kernel is removing
the pinned page without the user knowing. Collapse already checks the
refcount to avoid this.

The recent fix [1] by Chris already takes the folio lock for !uptodate
folios. I think we can take the lock unconditionally and recheck
folio->mapping, that should fix this. I can send a patch for this fix,
if folks agree.

[1] https://lore.kernel.org/all/20261029-fixes_core-v2-20-a64ce7f83abb@kernel.org/

Thanks,
Sami

