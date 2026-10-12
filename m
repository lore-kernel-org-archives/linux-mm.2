Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1938FCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 09:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88356B0088; Mon, 12 Oct 2026 05:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60816B008A; Mon, 12 Oct 2026 05:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F876B008C; Mon, 12 Oct 2026 05:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1E3E6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:58:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21A13C0A4C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:58:06 +0000 (UTC)
X-FDA: 85313523372.17.8C7AD76
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F54DC0004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:58:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iRnvKSjC;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791799084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8okIb6HYVMsdy6+U5xUzJ+gBO/rOBVZ3zjrTun8vSUo=;
	b=TNm8BVH5e6Tqz6tTD7/j/aP1AsCDph60v/UosWop54qXEf7GI9wnLFptsP4QGq2hXyYP2q
	FRrAQOYqdoh5ZHbyIPTeIpC3Kn1XUwyADbMv9cZgs8bn+8+oji8PcgxnoeM49q8Csh87xK
	6xuDWlxN3r9Rsev9tjoVsZ0jHWSuUes=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791799084;
	b=Ss6Rxfif4jo3WbIbQ/lsd2P7+LFQcpAEq5V7f0AWgLiOCTiwXhhGdjR5Dc3lHQgYR/1qQb
	UaYQjfcGc5vWsOLcwpr/5XDNRg/h35SpSI+DXgSclJeDimgJmc6nbaIUO8hUeSimh0Ccw6
	qXz1gh15Ywvko5m2XP7bq/eRiK0LDLg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iRnvKSjC;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6af9cc73235so1176781a12.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791799082; x=1792403882; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8okIb6HYVMsdy6+U5xUzJ+gBO/rOBVZ3zjrTun8vSUo=;
        b=iRnvKSjCjxojjVAstZO7pleERCfP69SrgH2ZjHw9VN495CakwiVAG0v8CQx+r7dOM1
         NOjFbW3fxMA1XUkZyZjvcN/C/b7OMk7IJ8+XZT6+5nwM7P967aYdi/bw3M3jZQL9Pt+s
         bEhv5okRMfGWrL3APOil+abh3wpZgxu/+k2DdWvD1yYs8mSjMfhAvEcXSDNtg4pvdi2w
         ujGfYEnfHqHrkkRfWWu4iuz0YH9WFqpSpbKrLvaUbbKpeS010SLDqOVQjAKzYPu07eOm
         DNRPCJyTFDWLTjXCG0WSkKE/6GymkjrDkg2OVECXLSjydZ2Upz/2sPsuspPwRt+UU3CQ
         GToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791799082; x=1792403882;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8okIb6HYVMsdy6+U5xUzJ+gBO/rOBVZ3zjrTun8vSUo=;
        b=xWlzjVZHZcUWD3R8FnVSp+72F5TQUDTDcP1leTYdic6HZvKtH1Pk01Rt3jOm7sHJWd
         OOSWicY+rnafCctEWh765K0TDEpMyhdhJanL/qiHRHG+K2YcsIdsA3jaAcrNZYSVr9sr
         Vstu0Mu8v1zoJpAa1RkgThbvnxWh8zeHs0M3IOrzrdcBMrMmUTQxaAe47ImcnVl+T+OY
         MM1HeIDZa+fHeGayHy63R4mQ5QPYyqS6XnaHL5iSgysrOfj/EdBZSzXUzGyH5yGp9YKV
         6asVTiWhoUYFMsKc43lck1VGZVoUSboa7ghMqWkawX4UIPppdqj7zuEJs6e30hAYmGRs
         A5tQ==
X-Forwarded-Encrypted: i=1; AKwUvBxQMQuw28pOhOJ/lgHxfBVCAXvi63preufbrCr3TA8k9AFK3zB14TAoqXGFdtTv1SAhHa4QA4ZDew==@kvack.org
X-Gm-Message-State: AFq9FYJCwoBrTmikqMoturGSq40KBvjnXxSr52PPx8CeA7hus8TEwkKL
	dr8YWn1HZDX1vBvZjKj5bOn8MB+e0B0xbsmVyrQCuXvzBzQIrRKFZYiU
X-Gm-Gg: AYBFou0BcBjQON8ZD4fZoAYmLbBFV0wvsrSPZi8ljXrPw33NeMBcS/dlG5+HrQAoz96
	PdKN/vq0vSC7dTGNwZukoRmfkXPjpWk+Qy/BanY/Uo4L++HMqHj8YmRqD02Jt4z/Ybw8WtnirGY
	toCMQ6KxXlGwGSf6QxVmfKZjNbXb8wzdR2VDM58iGHr12ToH7VObfJAHA4DPuL8tUxnKB/6OfOG
	MJhxeX26rUprfSaMCQ+j+rrSm+KesjLK/bAH66hRTGnWU66HBgp02IM95Z4oKtgoqZy6JFvvUux
	Hd4laucFGYFp9xjVo5I4Mf4hbnVjVLB1h1Ld6LfVMVCb5aqoNxipBeNXHqgH/yFJQZ6KlWetQYe
	6219UzL6GSINEedwdbOPXeSWDIkAwRoQuEjd6exZtZlHY+Kcrvav/PpWlKtN2wFbhzOYrb0q6i4
	D5favbIkR16x3liZgbghTjQCMcA0NBUxB18M1AKBrz7bcnI2xWBYmUGjy2VR+/KNO6BJw+/Mwbz
	f5UyEb4olblTVrftuUNkUOXSTSRfLsCnL0aM/WQZOg79/JbcXWvzs2/wgGjX+1MMZOSU3MDhibv
	rbhhI+YYohj8CfMt12VummJUEOf1NtkzCH8Voeh8DN6zrQ==
X-Received: by 2002:a17:906:f59d:b0:c2a:b008:8cc0 with SMTP id a640c23a62f3a-c31a70e5566mr981263366b.28.1791799082342;
        Mon, 12 Oct 2026 02:58:02 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b178d1605fsm4928885a12.2.2026.10.12.02.58.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 02:58:01 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
Date: Mon, 12 Oct 2026 09:58:00 +0000
Message-ID: <20261012095800.50250-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <yq5ald8680t2.fsf@kernel.org>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com> <yq5ald8680t2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F54DC0004
X-Stat-Signature: 1go39gzz1xkqwsn419exf3k9jpxeyrp3
X-HE-Tag: 1791799084-244439
X-HE-Meta: U2FsdGVkX1+yYEfBHEhLMKol9kDKTTJLPOPyDcc7A8Q5ab3r/MUnh7OzC8fHa5NPJrcdnnC9Ts/1dfVar/S/HXzBdYYA9jTSanKPh3Fxj8vu1lNPvEPh+vBzQPoLc0HXAi8k+aSlY6FEz1Eg+uOCHDosRzk2qDfXevhDyDKxI0wtp61lEC6fNnNC2jdGK6snphoETshcnon5tKZQdNzh9ig29YG9UH4FO6DVi7zppNGmUlmk9tXDRdAohT906rFYAYIhc+rz5LCE21Bzdy6wd2nO+NZOCecxbEcmHNYS8wSFziK3tRd000gcbcUB1Dq6QMKUxOhbJQ+tjV2X80zhMYgc7hU6gV7PVnegNKSliAg49xyaupoCqj0McEpxjy1MhGJfx8qRR0YNc14p+ngdSxpj1qs5fs/6/Jyjy1p7Cm5at2NDenUp3tPuZP7MDptkNoPCy5SPnYVSL31apYQaL3ojS9vAj/CI95HINFEBiss/4c+/5CqAQPhrPWpXGOZximTFXmXVWb4jYjEOGnDxsXOjbbN5BLR0+VSMbwP7Xm83weT0mcr8UV203McCGZCU0BOteOktmAFbLt5LbAboSJvDdSQy+/nhgHEc3SvJU/PWtxXB2GiyUlbTJZxgnsjOJMFTXI8XmQLvhvWFWhpTiy9F+HhTHftDLtWYl0dPoHBZDcSSXCyTnKG2FJErOYJcEUe6cfs9D8DfxpPFH+SLVdW72ZMZvrirm1jc3MDIM+o1nwQcPh6sx5asvntlnU28IChEO2ozUYDxHbJIeRqbOXqi5yIHOYkH/UhhimoVSTWoXlJ4bmS6qz+TYPce8RIbY8yJeb/5pYherWhsSdDJiQrreOGqbvTbtedhkewo75rERtVAcPSCC5Y/Qmob3htarixHlMr6jPY0KL13OCq/1DJ3MCgiWmFTPUbFIpMTIIhKB32vMuMBWgjL0BAWIpBnkKrX+Ad0IScop6+pbvs
 kZJwoctz
 N30GMFBY50BVxeIy0qu+VFOmU1yx707fIIz6rq9UCYbM3ibhBsxV+PuOi9Af9Gw7DZ9epybZXrvR5tF/77Z9nIDrTv6p2LZVrU2If+VtGHfR1AZHZ0pUoc6QU6tMNCEwwrchDTmX3es/ZajNX4iaJVQ/X2o9Cio1pScr5iJ9wzN661PWCPjURYnq6VrSNzSt2v1PSbVFAfcrxleW9A6wpzh3MsbmO3FAYBF5NOVmLMwV5j91962AdKMgVh+OmGLDhj9pBpcLmeSZ4ahk+DjIdchEkLHZw9ngwtn5x4Sjyk3ibQXpyEJMOLyg9jdgUrfRhlYT40wd2WNxn5afD9pHzEXdqc8AMDjGNMRzaFpiIl4HFhYkFRG/RyzWfo0SEMyNXI5dLxqH+uHC9M2PmrBhj2IqB2nD2vszPsWlz0QqXu8sMHDjsg+vE1spEIS+Cb45bjRr1FvhKmdyjg3Isd9qAo881OgPSYNa8x3JMkvoxD8gr9pHJuTpTSmdnGOqQhDPnPZLYyAO1PzvW/SKKWXQjCyK5m6iO/1cv3qZNs4NLHwEAGDmMzEeTa7SrHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026, Aneesh Kumar K.V wrote:
> I have been working on something similar for confidential computing use
> cases. There is likely some overlap between this series and what I posted
> at [1].
>
> I have not reviewed this series in detail yet, but I will compare the two
> approaches and identify what can be shared between the use cases. Please
> let me know how you would like to proceed.
>
> [1] https://lore.kernel.org/all/20261010072504.536230-1-aneesh.kumar@kernel.org/

Thanks for the pointer. I read your series, and Ackerley's resource fd
RFC that it builds on. The use cases differ, but the interfaces overlap,
and it would be good to agree on the common parts.

All three series add a flag and an fd to KVM_CREATE_GUEST_MEMFD. I
think one resource_fd is enough, with guest_memfd picking the backend
from the kind of file it gets. I am happy to drop provider_fd for
Ackerley's flag and field. We also find the provider from the file in
three different ways; I would like us to pick one, preferably without
a registry.

The main constraint on our side is that the provider stays the authority
on which frame backs which page: it moves pages between VMs and has to
survive a live update. What would not work for us is guest_memfd
becoming the primary manager of PFN memory, as Ackerley suggests. Your
get_pfn() leaves VFIO as the authority for the BAR, so I think we agree
there.

You refuse dma-buf exports while guest_memfd is attached. That is
roughly what the memory provider interface is for: one owner, several
users, and one revoke that reaches all of them. A BAR exposed as a
provider file could be mapped by both guest_memfd and iommufd.

I plan to change the revoke anyway, because iommufd must not leave the
device with a hole: it should replace mappings in place instead of
unmapping and remapping. Would that fit your case? I suspect it depends
on locking, for example whether you have to revoke while holding
memory_lock.

Shared/private state and the conversion hooks would stay in
guest_memfd and the arch code, as in your series.

Does that sound reasonable? Ackerley, David, any thoughts?

Thanks,
Fred

