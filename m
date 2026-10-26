Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C986C606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=OyyM6arR
Received: by kanga.kvack.org (Postfix)
	id DF9CF6B05F1; Mon, 26 Oct 2026 19:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1A96B05F2; Mon, 26 Oct 2026 19:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EE96B05F3; Mon, 26 Oct 2026 19:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD84B6B05F1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:28:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EBD6A084C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:28:49 +0000 (UTC)
X-FDA: 85366369578.03.6204671
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8AA831C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:28:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OyyM6arR;
	spf=pass (imf18.hostedemail.com: domain of 3LeLfagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3LeLfagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxRwD13OM0fFBvRZdfnXU3z0HVhv0MS7kXCqcjKQ5Ko=;
	b=BDL81lT1n6elz3m7ksTIupYEJ5yXXBosTWv+6qcZbLnuj2Aj1BufXizhjclfTAih/jnnTk
	EMHFm8xDgcHGLaqAEBr9ues2wBmaYNOIXREj2DkbU1sKxnUiIfMJfBQOh+2h9fqkrNGJQS
	ML9ED9EDRVlV6iFSvVUjuawZJxZDDFk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OyyM6arR;
	spf=pass (imf18.hostedemail.com: domain of 3LeLfagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3LeLfagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057327;
	b=M9rVBkabSpvOYJsh+Hjo5Rmcu4opLyZBY2fggaIyiqBg75Bazg+5gyK9p+hlboedGfUPX+
	WL/4cQcB22fe7dGS4+6DZMb9tcF5zM0bj0lmknD6PT73uifod+SQzcfBim3H+Q4xFAl8fH
	G9ZJjHUbgdx2C525EW6sD777GP5rG1E=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b1f5b673baso3524730a12.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793057326; x=1793662126; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RxRwD13OM0fFBvRZdfnXU3z0HVhv0MS7kXCqcjKQ5Ko=;
        b=OyyM6arRXWeKUzOKNtgTKrenH7Dg7jAw+ILIoFZnp0rl3SeL1AEGub0KyU4Y0piE/4
         Yw5UzCWljOpfORS/J2cT8NGwiiuPHFQMVUA0tWfg6FaZ7tBwzqvR0m/F12S1zI3Ctf34
         mW7LCZrowPzmXQ8+w2n+9SRSIrLj7WZ+rY8qlMt7Hp2bxF0glGdEWpW7595k8ovbSUkD
         VdZC5GOABOq+8auBmgvgb+Ur3Gezow0mEywTDv8JYHcJEb9OF3+bd6oy4HdCvreLNHSX
         0sQolROnQTtGr3bzyXjrAwdhf/sVfD4rlhalMNRmFHYarPwtwB5x7eGcPfKbNUddUHPs
         /Hhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793057326; x=1793662126;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RxRwD13OM0fFBvRZdfnXU3z0HVhv0MS7kXCqcjKQ5Ko=;
        b=RpHuJsh4avsif4abUtZX0c3zXDz88xRiDTmsz9JWuCmaAL4HXyRC/aberUvWId0vgW
         3Rw0DEWTLq8H34iJ5AtL48Yo6oJas5fxHoWbCUq6de1r784xsIFHtOSveABSipEsABJN
         Q4SIOKly7lZI2pFZlRivZgXW9ipYYGvL2k1l9niVe2n7WLwpoM2F3s/y5dIM2s6wVKjt
         grwmQBcl1EHx3FG4RSqDBSjbxF6wvlbBigyJcVgYk8Ko0T92ENZOVDcpgDIB+3UZknI/
         wu8SfKQgQUiqw9/u9NxtRsdUe3BgL2YVhotAdnu/lQzBuLiu8ti2PWn7sMS39xiySy2l
         0MgQ==
X-Forwarded-Encrypted: i=1; AKwUvBwR46bIRk0Qx2M5i07++FRVafcwYKikYUerkRVo/3vgOZGqzu2rKOZBi60NbE0l1AvKMiveYkW2kQ==@kvack.org
X-Gm-Message-State: AFq9FYLyIdUK2xZLDVrrYYbC8RD9W3jNCp2xxP1+bg5wqQCrjolluZ41
	Wos3iP8rmYdj/orEKa8A67e256wYs58mvN2dSNmX8IZxG6m1QntUzEGthhEFWKHPwrltpa9ZrxG
	D0QaBWfUiOeOkrTTe4A==
X-Received: from edxw25.prod.google.com ([2002:a05:6402:719:b0:6a7:4541:3de3])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4026:b0:6b4:1037:2b87 with SMTP id 4fb4d7f45d1cf-6b44300b84fmr9392138a12.31.1793057325809;
 Mon, 26 Oct 2026 16:28:45 -0700 (PDT)
Date: Mon, 26 Oct 2026 23:28:45 +0000
In-Reply-To: <at_CncIPYCxOVkLo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com> <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com> <at_CncIPYCxOVkLo@google.com>
Message-ID: <9huzecdcghxu.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8AA831C0004
X-Stat-Signature: n49c79hbqxp756pbqwjio1pkdweouxzw
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793057327-696131
X-HE-Meta: U2FsdGVkX196aDLDBZ2n+sJ2RnKI+wUwZUz07xqUmZzbAP4cLWZZFYrOyTik0fNyjW2Zg6Mz7thEkmtkr4d/wewbiWrmh2uUb5DkUJwv6GdODRUWOevUhdPs/XwnrQ0jUnE+08zIuKxiYnmpWokXbcu2yDQKmzlAGp2F8UK2pGgPkTjo0VNSpf+dqSXFk6hGWCNjUuZFMbB2jG1F8MEIndWCnezxvaej3MZqitS3Nz+mv2qWVhmTGrk54jK4FzA46Snxjkqfns7gOkFQxakLaTha5Zj11/2knSPdi73wfN4Xw3f9RUJnke7sSJ2lJuBBaCcovD6AXZit41ZFLwyy4LBLybMbKjSiRbpYuS2LB+4FFyuwOOtrtuBp1ZT7jmlQAhLD8PhKPBe4cOsB4VHzl/gWrPkQXUm4Be7UAX28y2EQjJpMeV4/1gc6KBskN7u9nuJfHp3mHa6mbbuCl42lbv8IFs7JlaGvnd5w9EwmfdV+EeSbkDyYnILoj4bGPI+FxM+e84W0uuc0KOdHx5e4XQB85BUpMaCBuj7zIt7nQPto712BGNJv7Zzh5lq/GFsfw/71HP96Ea2rhyrbCWkWzNsQnSSiWDOZpGypWGXbkhqjK3B5OPoQuSchnIVOBlQThCQc49WqFgrr7DnCMsiOvtKBq1zb7dIw8CcEUvyWZzGupeA4aoNlxAv8TN2pqc/T5uhS5xSVfQNMUIZimq17ylPly+QAi+znbUQQo2vJuuQI6LZ7VW+gRE7eNPPvD+BOrqnrrvjoMHgA5CPz8+8HZj8iX5EKuEwpmM2YIZHlmbzf1Mhx95QKBWDoMzoqTl44pzcINk3HKH5gTxxRsjB2SEi2SX+kkEvPBNf1rs9alqs/tWuyMzVwHjMn2ejlXEDudqG/bQIRJDJDTXy7zn0UVcuQ1hLf7g6E/WA9Mrkpt3daE2CEInpldTqeKqyBvIgYyrOnTS8oh8Tep+b929L
 lrDKvDbA
 cBkljSV089MjHXtFoSvHuzaTI1VsU6VURdmal/dt3QUIAPdWQGCRjzyNzDxuCLe/iyyQWlCpH+47RRKryFs7xTfhoHO4+GR2KCLVUHvKP+HCWdb94pBAq1DU7Oo/xcM7NPQQP9tFMPECLC0+V9h+6t9+WSR7q6ZkAE2kYt5iqXPqUQuQ+ZQdIFlHi9E+bArgPFF+Tue3gQMTid0f4BRbz7sX5lwjlMbdbC2dUoSuz7imab3DleVoRtje8rZ9xBt52T4sW2fPfmWcH/37XVViwaUjb4ouODmIajchD4KZw9K26WNJF9TX4n/YXkZcy/t7ndJIisQ6L+41z7zgGItxHSC8C9CDU2Mr2Gx8fq/JMDRc54fFkbUyGP6rNb7TlglR1NzK6+WnMGmz3zezmeXcKiKlJ/Vw3xkLDv256EcqOJ/ryE15V07VLZjRi65ZsDCHQwkZu6xirEvNOBxagXcpVGX9bcmZ2FOgYdcywXHwzhuqve6fp+Mh9DtatRITze242+Axcx6K44tY1t66NXOrowpwCxRDqa7HSXamWJ7IlOTwDRH9F6NtVTwToTEIbeItpIxIXO5tfqTJ0ekl8gGYhXp8kTSSOBHv4i/g1ENLb70sugHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

David Matlack <dmatlack@google.com> writes:

> On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
>> Right, Required bit should be source kernel payload property to tell
>> target kernel that the payload must be handled to correctly deserialize
>> the data. It should be source kernel (userspace) responsiblity to make
>> sure it understand the target kernel before doing liveupdate.
>> 
>> Saying this, During deserialization, target kernel's required bit is not
>> necessary. So I propose the following truth table.
>> 
>> Source hdr  Target supported[i]  Action
>> ----------  -------------------  ----------------------------------
>> 00          0 or 1               Accept: feature absent in payload
>> 01          0                    Accept: ignore the feature data
>> 01          1                    Accept: use the feature data
>> 11          0                    Reject: -EOPNOTSUPP
>> 11          1                    Accept: use the feature data
>> 10          0 or 1               Reject: -EINVAL (invalid encoding)
>
> Yes, this matches what I had in mind for the semantics.
>
> To be explicit: the source kernel should set the bits for each Live
> Update based on what is actually preserved, rather than generating the
> header from a static per-kernel array. E.g. memfd would only mark a
> feature present for memfds that actually use it. That's what allows
> rollback to an older kernel as long as nothing being preserved depends
> on the new feature.
>
> But looking at this again, I think the required bit is redundant. Whether
> a feature can be safely ignored is a property of the feature itself, not
> of any particular file. Every file that has a feature present will have
> the same required bit for it. The only thing that actually varies per
> file is whether the feature is present.

The required bit is subsystem property not the per-file. e.g. memfd_luo,
it is set at compile time for a kernel. So every file will get that required
bit set. It is not per file property.

struct u8 memfd_luo_feature_state {
       [MEMFD_LUO_CORE_FEATURE] = LUO_FEATURE_REQUIRED
}


>
> The required bit still has to be conveyed to the target somehow, since
> the kernel that needs it is the one that doesn't know about the feature.
> But it can be conveyed by the feature's number rather than an extra bit:
> split the flag space into required features and optional features, and
> assign each feature to one of them when it is defined. This is similar
> to the required_flags and optional_flags approach in struct pci_ser [1].
>
> Keeping the same header shape as discussed with Pasha:
>
> struct kho_ser_hdr {
>     __u32 size;           /* Size of header + payload in bytes */
>     __u16 nr_required;    /* Number of required feature bits */
>     __u16 nr_optional;    /* Number of optional feature bits */
>     __u64 flags[];        /* Required bits, followed by optional bits */
> };
>
> Required feature N is bit N of flags[], and optional feature N is bit
> nr_required + N (using nr_required from the incoming header). The length
> of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
> are numbered contiguously, so there are no gaps, and up to 64 features
> still fit in a 16-byte header.
>
> Each bit just means the feature is present, so the truth table becomes:
>
> Source bit       Target supports  Action
> ---------------  ---------------  ------------------------------
> Not set          -                Accept: feature absent
> Optional set     No               Accept: ignore the feature data
> Optional set     Yes              Accept: use the feature data
> Required set     No               Reject: -EOPNOTSUPP
> Required set     Yes              Accept: use the feature data
>
> There is no invalid encoding left to check.


IIUC, I believe this will not work.

To Communicate between source and target, We are defining a protocol, A
protocol which will be standard for all the kernel. And each bit location in
flags must have the same meaning in both the source and target kernel.

Now in you approach, If Source kernel send feature N to target kernel,
target kernel must understand Nth bit as the same feature. Even though
the bit position in your approach is not fixed but they are fixed
relative to their starting point.

required: reference is 0th bit: So target kernel will undersatnd the
          bit as the same feature as source kernel.
optional: reference is nr_required: So target kernel will understand the
          bit as the same feature as the source kernel.

To make sure there is harmony between these two kernel. Even though a
bit is not set in required for a feature that must be 0 in required
range. and similarly for optional bits.

So flags will look like 0b 0 0 1 1 0 0 0 1 0 0 1 1 1 0
                               o o o o o o r r r r r r

                        0b 0 0 0 0 0 0 0 0 1 1 1 1 1 1
                                           o o o r r r <= This is wrong
                                           because target can never know
                                           which bit mean what feature.
                                           So as you said there will be
                                           no gaps which will not work here.

So, Based on the first, We still using same number of bits and increased
complexity and no gain.


For the current appraoch and V3 [2]. Think the below one as msb is
required bit and lsb is feature present in payload bit.

00  FEATURE_ABSENT / DEPRECATED
01  FEATURE_OPTIONAL
11  FEATURE_REQUIRED
10  IS INVALID (analogy: required set but feature is not present) which can
have different meaning in future if in future, a need arises to reuse this
field.

Deserialization can happen per feature from right to left. without
jumping back and forth.

Because of all these reasons, I believe current approach presented in
V3 [2] is the better. It is close to your PCI series with two flags
field for required and optional except I combined both field into one
flags. In your above approach you do have two counts but not having gaps
(which is wrong) and the way you proposed to parse with an offset is different.

Let me know what you think.

[2] https://lore.kernel.org/all/20261026174217.603114-1-tarunsahu@google.com/
>
> [1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@google.com/

