Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DC9CD13DE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 23:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774996B0088; Thu, 30 Apr 2026 19:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FEB36B008A; Thu, 30 Apr 2026 19:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EB36B008C; Thu, 30 Apr 2026 19:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41DBF6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:51:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D21AD140231
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 23:51:56 +0000 (UTC)
X-FDA: 84716872632.25.FFCFA4C
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id C297540007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 23:51:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S5oMHka+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777593114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpU7aJAXyZDKrOT/BsTxtUzbjAh38uTL3HfdWXDy/eU=;
	b=MQmbXNXofblzBJf1IgzXsg5SlxPVra7A9qCoc4EP6kqP5ncyGzxYLyIpuoiJamLpZQKmvQ
	AOOir2gTf5psZKqoLdXWcBIjdgNoA22DyCKOYd33cie6ZopA+ND8wyT6+8mUYSgUy6Dd6C
	dWGLYEZKyqg1kXBJwW5kB6nfvJKrsIQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777593114; a=rsa-sha256;
	cv=pass;
	b=WcNa7ZQ0UZq3JTLGDsrNALiSQo/uqPLGOKuVYBBm7dWac+yTAkyBI6DhjabJENrkYZCGq/
	lpYrI9IXDwKhYFj5vdqjPwIrAfNx1vhrPGFSiaI8eXKITKol2RyOAUqR/CS5NwaTnFeaLj
	Mk5lPPULUjvZOGzzAtxQpAAvS6/M7oY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S5oMHka+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-56d958880ecso500958e0c.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:51:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777593114; cv=none;
        d=google.com; s=arc-20240605;
        b=j+EJKfGHkxmHyZvLqDpio9E/zq99cFncFBKotzAxNa/R/TngjOHi6qvrLf8l8n1dsZ
         KsCgSSWkwkb2WRR+Bt3lyyLm/s6JJeQCWn93DcqBtXnDMaIho6HjsBnV+IIzD0DvBaLD
         qU60cdeENsHtPlT9WdwQwABo7/I0y1Zih0i0DL5hhZ2vD48ofhD1yhtibHYqY1BeNi9s
         JW5ttN8COa5j/r7NUifiutVIc3dPJo+pVAH88jbrrRlTzPqFiZ23cS5L32ZzLqDACxEa
         EvU8gWSmuhIBgtqwDLTNTovbAVx6lCKq5ejCxIP6Y6R2am6Gt5flO/QpnCr3PM8LnJre
         f1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=BpU7aJAXyZDKrOT/BsTxtUzbjAh38uTL3HfdWXDy/eU=;
        fh=1z2YWJx+1MeaAkOTPZxXfpPxVlK6mmKyzrFp3XyhBRM=;
        b=OwJ4dmuQuZxtpahH0Gx0kcukWlDzb+0cgTXRuxGcwsJ2Pm8FEm2IqzODMDg0U3DIKD
         5TdX/+XVUB04tw+0FDYtapzbSOFGfJtZTHortgvXlfyrzBGNJWMgiyL5b5tq5HxnYogm
         JElFd3FUib8KElp3OpQGmwu0U5JqwRvGunlh2Wr4O6Rsptt90y6L85mOB+GXGW58BA9b
         UFAAd4IzVRbyq+T5BOx82eQniRRP8uKNyFMS5RdY7DuZlAR/O2JaKmGKfUQfuA2jzyMS
         OtKOWVbcrp6FbiGF+9mYk7t9IiIcYmcDMw8VZCvvl3Ahxgu5IIbXYKJS3BI7vAts0c0b
         ZLeQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777593114; x=1778197914; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=BpU7aJAXyZDKrOT/BsTxtUzbjAh38uTL3HfdWXDy/eU=;
        b=S5oMHka+jDpaNg4acb0EDU55dw4/c4S6YdV+4YggLX+z7/AqNZQgOeWVVDTl3Apsru
         ykGAoyNyUdNVoA+cU/OZLCDXVcF+NQmlwaPLRzJFAeixjjG2DAbtG0al9fX2b4OR37Fd
         oV9GirIL3MbtWq6kdcD48lRzukOS9oTyaTktqNBr60gcs1bW/OY/HexSKQXlH9lEFyzF
         KWP4LXP3ssshHbFZZnvVrIRe7ONpJtKeB5TkhT4JGIEjojxyI45MNAemK8zgHTkw28DW
         LLROopxoGfOQLs6SsDOKahrHea2628ehwGQhegT0Z6ifWmclFTfJ8zecFakDmbFnOJZ1
         s6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777593114; x=1778197914;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BpU7aJAXyZDKrOT/BsTxtUzbjAh38uTL3HfdWXDy/eU=;
        b=RO7Slp30QQAPkl8AyCb8qyLvjhFi8D+jwhM2AWyk8/uws66wjurftDptq5aSI8ar46
         bFk0JgIsdNPgZcOAr+wzorlWasB533eyNSG5AysBNyf3wc+2BuPFltjSJ4ORUm0+LPjp
         xEfZ+aZJA8byl3ZjIjpdEbBUxUhbNjGn6wSBbgtPUEIKNhF9Qm0zbz6F5b9YC9y/y6qi
         YgOu9tDoQXVn/HQKjK/uXHanp8LESoQ8qNv8MdlHXBZel2XbUkMDvjcPuKvXIyfTmc45
         tJGNmUMqVkVI0z+PHNB+kTgjRlAf5BiSxdJ2qY0pq4cWoeFWXyRb17WOVpNxi3MoMY/I
         bSdg==
X-Forwarded-Encrypted: i=1; AFNElJ/RsgIhFE1D4KViWsEz+ourfkyFVgUh6/D0CeTy9W+Tq+6gYMr25YgBd/iZS2IpGU2u0rEatxS4XQ==@kvack.org
X-Gm-Message-State: AOJu0YwSxCbCbJ+YI7xRKZXFeXqmIVCQB1mfAZywjPrzHRzjA7nhQs51
	ZMHv3Ug8tax6qMbEliFh2VoeF74tF0dM6bHWKSCDoc85Vzg+Yf67rCkBLfBOTj11iwKbYjr8yN9
	l/uDhJdE+ZS/fYlrHN/UuHLr2S2p1NPN4ZVKI361h
X-Gm-Gg: AeBDiesmGyhjdJtQfKLWMzEz4j6U+uas0svhviO8pwNpyspg1mT1LKKtE9J52iadThA
	kaAUMIFP1H1tla9AVZzwgze0SZgnYkFK275LcRdQV1qE3pL5ypeL/74vt+D+QCjI/iqyXsSYEGh
	tB5LbWvAKIELNy15SVTmJLzRJ6A86h3JzHmToK4wpB59TmS6UL4WZH5N1G4JRDQQz09BXKaPcez
	KD+L8jb/sz1UB+fHBsMZKIzX2qs1rYc4QHLO1TnbMlCgVd5SvC8zsyukmbMN65c0sC4jzgmRcGg
	z2x1EgG+IjTquWAav/zdX1Pi0rjrcx1ZK0iP0U7j/m8VGGNb521JkkiQHZdZtwn+cX3vKaonsDP
	eKpdCVu4qog8vC3I=
X-Received: by 2002:a05:6122:8b14:b0:56c:d66b:7516 with SMTP id
 71dfb90a1353d-574beb44409mr376458e0c.13.1777593113169; Thu, 30 Apr 2026
 16:51:53 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Apr 2026 16:51:52 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Apr 2026 16:51:52 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <x7n77snnvvukofo3slopl74c5tmlb2t2un5qy5fq6eb3d2xt7e@6a6tixg5mdfc>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <x7n77snnvvukofo3slopl74c5tmlb2t2un5qy5fq6eb3d2xt7e@6a6tixg5mdfc>
MIME-Version: 1.0
Date: Thu, 30 Apr 2026 16:51:52 -0700
X-Gm-Features: AVHnY4KlBX901bcbV2QvS7GwShwnTIsgZQP6_kTRQYnSwTTeAKUt2VFX-7vfC-o
Message-ID: <CAEvNRgHRpvsEjtr1A_Qz3d4oMEaffTxESavrZ73Jtt6OobCwhA@mail.gmail.com>
Subject: Re: [PATCH RFC v5 00/53] guest_memfd: In-place conversion support
To: Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: C297540007
X-Rspamd-Server: rspam04
X-Stat-Signature: htwmnuyhk75btccemzh1xm6ius4ao3he
X-HE-Tag: 1777593114-821391
X-HE-Meta: U2FsdGVkX1+3VnmSPwKAaR2RrNmObzhBjuc5onWOSyldFp/aJB8a5MsN3oZGuRD5s4tc8xPvwfHX2dZpjMIM0j29RsQdCoF71SEqaWla3uHclBb8uwrE1ub5yTAO2MfMRhRWcyI5P/z1orIz++mAu2sQY3dIGs7HU7+sM8IBZeQrSojtF45buQmNVYeLu1G2zfekNxb6kW98gH8llm/WPuyOuLKRO74rZnu+R9PwRnDPp5+bh6JIcUobWxCh6sGcCK5sb6UDDH+eXfQrQrZ9OeZcLlDLLN0BSgkND68jNuJzEX7ntTmWC62I0y/ks8wT/5RsG/mv7TOqF06w3IDV7rtRmrgZbz/A/EI+Oa0+rnVmeHsix27m12M19u+/OPTvG/dU+QlYqQn1l6anOw7S2qT9IHffuKe7+NZXRVQ959PK2o8EZHcXkH7pu0Gr7ZBuIJbWVgkeN/O1Jsh1qopPZDbJmOFTOLlMB9Egf2wz+5M30mH57sb2WIz3fb5GC5fBZFmin1V3GMCPSYzX9uJxOU/f9s6ImKtA0pnqI++oI97pQP32CpRJDGRwYJN00AWB/busonJnSWV/5CGJi+rKGeDHUrjQlNlx2ScO5PlDqz6wuuul2plXqPBH4AkwkQ7Z+69Y0Yi3/M7mfOT1sF3CcmWYY7jZxA/cHD84pM5ABaXpPHtkK7uWdh1vQk9GQITqf/ZcHWfWtoTOCBDfK36J1Nt8RinRdUzwmHpySa9GbBt7qjyjgy2sDqRUK+6fiNbf2LotnJNIsGZUE0LPrGswAO4619DvVEfuhcuPt3UVg+TRducVxGJin5r3Q/4Y9fCq81eA3LF8Z2e/LqtI3oCQ3d7Sx8DUvRqW2aPtmOS9cOL9ifR3XUX+ieex4JifTJdYL1UWsSjt4P3sUtWc04IxpMZb9iZHS862g2a1UjA7Ui5SyUlJ9my794eqxzUuUJ+WhSVOboLB6l/dgI38p8q
 4PTpI0JU
 foR+uAB6638NUdpYm5TXRKZByJY6jv47OJb+rb44qLMn4asHlgRK6wX1H0XCxiKPouXPN4shJ730zF1Qq8WBjVQKAb4mxSFfrtxsiTDjxmPvom73vaP0MKDxW+rgKRl5Mo22sOYkmBJa7mDzfzlEeeMF67tjQCdTpY/ZnLAWRKkQmPorjsaAMugGXOpZoFBlU0cslDzRwz9sXvXZidLcV/Vjy9UW0S6GqNgOXb/22XhI+Jru3ejwGmHoUNMLsw6UwRWgCavMB90xMnqdwYeEAwYemWMYzTWYtAdFtmNwfCt4muH0nG7MDmQaRYZ1xXKP+VJ2d3DW15Tf1zYV8HGWRA1aiPrSlAJm+rGp/7mRH6XmnkVjnamRJBR6RMRPYkh3PmvLBuj2ewVbsQaMlz8AVUZ/Q54Mq6VoWMGa3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

>
> [...snip...]
>
> I made a super-long-winded reply to that thread, but to summarize:
>
> PRESERVE flag has different enumeration/behavior/enforcement for pre-launch
> vs. post-launch, and similar considerations might come into play for
> other flags, so to make it easier to enumerate what flags are available
> for pre-launch/post-launch, maybe we could have 2 capabilities instead
> of 1:
>
>   KVM_CAP_MEMORY_ATTRIBUTES2_PRE_LAUNCH_FLAGS
>   KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS
>
> where SNP/TDX would only advertise PRESERVE for PRE_LAUNCH, and pKVM I
> guess would enumerate it for both (or maybe just POST_LAUNCH?)
>
> That lets us keep the flags definitions more straightforward but still
> allows userspace to easily enumerate what exactly should be available at
> pre vs. post launch time, and give us some flexibility to detail
> variations in behavior between the 2 phases without documenting
> edge-cases in terms of VM types.
>

Oops Michael I only read this after the meeting today.

Sean, today at guest_memfd biweekly we also discussed this topic. I
brought up this topic because IMO the interface is starting to get
a little awkward, I'm struggling to put the awkwardness into words.

Here are some awkward points:

For PRESERVE, even though it is defined (now) as that what the host
writes will be readable in the guest, it only works for both to-private
and to-shared conversions for KVM_X86_SW_PROTECTED_VMs and pKVM. That's
because guest_memfd doesn't actually invoke encryption during the
conversion. For TDX and SNP, the encryption can only be done before the
VM is finalized, through vendor-specific ioctls that go through
kvm_gmem_populate() to load memory into the guest.

For ZERO, it is defined in api.rst that ZERO is not supported for
to-private conversions, and the rationale there was that when ZEROing,
guest_memfd/KVM can zero, but it's really the contract between the guest
and the vendor trusted firmware whether the guest sees zeros later.

Another awkward point is that ZERO was meant to enable an optimization
for TDX since the firmware zeroes memory, but it actually only zeroes
memory when the page is unmapped from Secure EPTs. guest_memfd (for now)
doesn't track whether the page was unmapped from Secure EPTs as part of
the conversion, so guest_memfd can't assume it was mapped before the
conversion request. To uphold the ZERO contract with userspace,
guest_memfd applies zeroing for TDX anyway.

Summarizing from guest_memfd biweekly today:

David suggested enumerating the combinations, something like
`SHARED_ZERO` and friends (since to-private and ZERO is not supported)
and Michael then brought up the other axis of pre/post launch. IIRC
there might be another axis since pKVM would need to determine
dynamically if a to_shared conversion can be permitted for the range
being converted, based on whether the guest had requested a to_shared
conversion.

I think this might just result in too many flags, and could paint us
into a corner if more options get supported later.


I spent even more time thinking about this today. I get that we want a
consistent contract to userspace, can we scope the contract differently?

What if we scope as "what KVM guarantees the content will look like
after guest_memfd updates attributes"? This is a smaller contract, since
it doesn't promise anything about what the guest sees. Running this
through a few examples:

+ Pre-finalize, SNP, to-private, PRESERVE: guest_memfd guarantees that
  after setting memory attributes, the contents of the pages will not
  change. The contents are then ready for populate. What populate does
  to the memory is another contract between SNP and the guest that is
  out of scope of guest_memfd's contract.

+ Post-finalize, SNP, to-private, PRESERVE: guest_memfd guarantees that
  after setting memory attributes, the contents of the pages will not
  change. SNP's contract with the guest does not, though. After the page
  gets faulted in, the guest sees scrambled data. This may be a
  meaningless operation now, but it leaves the door open so perhaps we
  could have an SNP-specific ioctl in future where step 1 is to set
  memory attributes within guest_memfd to private and step 2 is to
  encrypt in place.

+ pKVM, to-private, PRESERVE: guest_memfd guarantees that after setting
  memory attributes, the contents of the pages don't change. Separately,
  pKVM doesn't do encryption, so the pKVM guest reads the same contents
  the host wrote. The distinction here from the current state is that
  guest_memfd didn't guarantee that the pKVM guest will see the same
  content the host wrote since that's a separate contract between the
  pKVM guest and pKVM.

+ Post-finalize, TDX, to-shared, ZERO: guest_memfd guarantees that
  contents of the pages will be zeroed in the process of updating
  guest_memfd attributes. Host userspace reads zeros after faulting it
  in, which is because guest_memfd did zero the pages after conversion
  to shared. A future optimization is possible, where guest_memfd only
  zeroes the pages that were unmapped from Secure EPTs, since (this
  version of) TDX zeros memory when unmapping from Secure EPTs.

+ Post-finalize, TDX, to-shared, PRESERVE: -EOPNOTSUPP. guest_memfd is
  unable to guarantee that the process of setting memory attributes will
  not change memory contents. The process of setting memory attributes
  requires unmapping from Secure EPTs, which will zero the memory. (In
  future, if we want to relax this, we could permit this if nothing in
  the requested range was mapped in Secure EPTs)

+ Post-finalize, SNP, to-shared, PRESERVE: guest_memfd guarantees that
  after setting memory attributes, the contents of the pages will not
  change. For SNP, unmapping doesn't change memory contents? The guest
  reads garbage, and that's a separate contract between SNP and the
  guest. In the guest_memfd contract, guest_memfd PRESERVEs the memory
  contents in the process of setting memory attributes, and can fulfil
  that.

+ Post-finalize, TDX, to-private, ZERO: guest_memfd zeroes the shared
  memory before updating the attributes to be private, because it
  promised to. If this memory gets faulted in to Secure EPTs, TDX
  firmware zeros it again, because that's TDX's contract with the
  guest. I can't see any benefit to userspace in using this combination,
  but the guest_memfd contract and implementation are simple.

TLDR:

+ PRESERVE == guarantee that the process of setting memory attributes
  doesn't change memory contents.
    + implementation == do nothing in most cases, except -EOPNOTSUPP for
      to-shared on TDX, since unmapping is a required part of setting
      memory attributes to private, and a TDX side effect of unmapping
      is zeroing memory,
+ ZERO == guarantee that the process of setting memory attributes zeroes
  memory contents.
    + implementation == memset(zero) in most cases. For TDX, a future
      optimization exists, where memset() can be skipped for pages that
      were mapped in Secure EPTs before conversion
+ UNSPECIFIED == no guarantees
    + implementation == guest_memfd does nothing explicitly about memory
      contents. The implementation is pretty much the same as PRESERVE
      except guest_memfd won't take into account vendor-specific side
      effects of the process of conversion. Except for the test vehicle
      KVM_X86_SW_PROTECTED_VMS, where memory is scrambled.

>>
>> [...snip...]
>>
>
> Looking at the example you have there:
>
>   + Note: These content modes apply to the entire requested range, not
>   + just the parts of the range that underwent conversion. For example, if
>   + this was the initial state:
>   +
>   +   * [0x0000, 0x1000): shared
>   +   * [0x1000, 0x2000): private
>   +   * [0x2000, 0x3000): shared
>   + and range [0x0000, 0x3000) was set to shared, the content mode would
>   + apply to all memory in [0x0000, 0x3000), not just the range that
>   + underwent conversion [0x1000, 0x2000).
>
> Userspace would be aware of whether the range contains pages that were
> already set to private, so if it really wants to set the just the
> [0x1000, 0x2000) range to shared with appropriate content mode, it is
> fully able to do so by just issuing the ioctl for that specific range.
> If it attempts to issue it for the entire range, it only seems like it
> would defy normal expectations and cause confusion to skip ranges, and
> I'm not sure it gains us anything useful in exchange for that potential
> confusion.
>

Great that we're aligned here :) No complaints from guest_memfd biweekly
today as well :)

>>
>> [...snip...]
>>

