Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10928606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=OZoReE26
Received: by kanga.kvack.org (Postfix)
	id AF6E06B05B3; Fri, 30 Oct 2026 08:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7436B05B4; Fri, 30 Oct 2026 08:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9956E6B05B5; Fri, 30 Oct 2026 08:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7AF6B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:11:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB0D71A06BA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:11:21 +0000 (UTC)
X-FDA: 85379177562.28.BAAA174
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F306C000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:11:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OZoReE26;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.49 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793362279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/h51dJLYeoxkjlU1HlBvF+u6DEcazEkF7G3j/5sadA=;
	b=MZ+C9XR1GkGWQBLYvOoiL6/hKBgpzVY3Z96pZou5JK47B5lb3jcKKt3StiQccoO8bdQYwA
	Y7CwDg3fXostzaL1gMqS8Yc1CdouHL8e6HU49xDGGk0A5WIftaeye9Ab9xIP0aeN5ybCWt
	VRCMmuMbzSo5MRLt1y76acainqbOxNU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OZoReE26;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.49 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793362279;
	b=wCkN2rWzv0ZeOdA0FffBM7IgSRj3j1mesmPXqAlS9Y4OOmUBpw08SOGXOWnceAOcvvJTNb
	MtBLbHrEIgEm2crigps7PGwH2izXFHFwGegbEPe6AnNnZseygRbQZOhyDhQXJfyXM5qnpK
	BBt7tYK9wJ7MQW2Zc8MYkmACAOqOaMA=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91b55859245so10482206d6.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793362277; x=1793967077; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G/h51dJLYeoxkjlU1HlBvF+u6DEcazEkF7G3j/5sadA=;
        b=OZoReE266p8JgQP9yBDMUoMg2vbNeD28pYHckCcagP9jjG4W8ZycVd27qIh+42caWY
         I84fxuoyFXwVqeiDOCMBcrqUvDRRTkRYBZXbL+1gX8PoMoXyB+49tsC3oGVaBAoHxB5i
         rEZ+/ujZ4Jh7NifmCM0cg21x1hCSV5F8ryonic+oH1xXznurj9KuIeX5qbaDluw6atjL
         86t7GJeyHGLrke9U8TzPuLdIMYrBX8JP6YLlgvYbiYZoYbKXQ+LNJeZ8KMDqBY502OBR
         ZcdDaG7blkIWHlNc0IvK0Y3jRyjnNiGdu7dP8E/jQXFZ4KnpOMX6ButIRmdK9OH6B0ky
         7TsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793362277; x=1793967077;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G/h51dJLYeoxkjlU1HlBvF+u6DEcazEkF7G3j/5sadA=;
        b=C0nq7NDIXyZqBDfIZzXHL6oZVlpB8sYrB4p6oXlP22I6UCl0Q8TEN2WADJi389R5sL
         8w/tNAa619KdscC1LS+OcG+tCxnKPd4SKdNTJB3WZhR21++CLCBOPU5112KekGPJ8pNn
         Ql/mB8gLZEzdLBtHFwQGFr8wet7R62rJlKHN1/a8t6e9rqbVrKEQuSicCHMA0mZqyLxB
         OyChtaCYTnP6lCuy8b0Diq0Ai4rcfWXJadiBbMjPUDIdmw0vAN8hKPUf4njI0rl4KFP/
         F2rNWykvmq+g4bbJ+iIz3qWzp1pKIyHddHnSaK3aONF53/2sVb2CX8nXU5U+6vSqcAe6
         M/Gg==
X-Forwarded-Encrypted: i=1; AKwUvByXUu9Amc+FAvAju7gP/xnaYXHVfpqAw18orv0UGBbC2BB/Wk0p7LmxTLzb1I5TUO84m9pEI1hbRw==@kvack.org
X-Gm-Message-State: AFq9FYL47chQ8UIpLIvZ2f1yx3eoLUl2SEqGYv/wlh0/O/ZKrywQLyO/
	9Ei59vTkAWtI6/rXoGvK/Cz5k5GwUthn5+Y5XSx70efRm374WkHcLYhPSbsyg6xytCYggCiLcSu
	B4EpF
X-Gm-Gg: AYBFou3T4Zv0gS7QQXZdqJbf4zvT5HdV/eYEsdUQPwnrk7BxGk61s5Lfee/2BhWeJmb
	bqn7CmyPBbZXqociP+1p8Mcr2Ri2ef0ZyPjLq/X+iPr5px4cDRrb+FOhWgVtFBikycNe9p6Ecem
	3k+5HGau7LePSEQbCLitIF2Lf/brfTHXcXVUe/XuUtKhWDCfQfFm+xNMEwl5bqiMRkngGLu8vub
	CLuWJYsEznOFWgRZyqaahHqOWYpQHhHeeFzFRe/HGuGGh2cQJH7PLlnzgsmuA2ga2InvyoVwso4
	PA5+ci8CuIckmD8hGsqq7DmbYBRnkEaHmjbmfzNA3Q+y7LQZDS7GA0kjiSGjLOOI6I6o6K5sgg6
	3IvGDo0oMiRbwUGVKLonp8Nsh3hOYDOy7eApDqxSrnYaA7yDRZ9TTxejK9DbsBezU7ycJxsgZuy
	4UwHtS9W5s1Y0xQfZ7TGNADnmO+sRXmu4K3h87vlr5W4Q4C/vl31aVloDpleZJ8UhSK/MaN+KVW
	9t005FH5myqLjvOjJvtv+WZJbdvH1OXz9/nuqkzIPCKKcz0TtHccdN9SxGazeBJ668b40X9bzmv
	QnEubCRSOeTCzlTv+5fixZ02U1+j3BGJVFmTkmuIbYdrkXPv4z/rYhBdXfV30f7fzIyuy9av08e
	puuyehAmQSsoDt62xu7aKbKq/0U51ZWAI
X-Received: by 2002:ad4:5aa5:0:b0:917:848a:43de with SMTP id 6a1803df08f44-91ca49e9300mr29477496d6.8.1793362277155;
        Fri, 30 Oct 2026 05:11:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca804ee76sm14028506d6.26.2026.10.30.05.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:11:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMlRx-00000000ZRR-0Qze;
	Fri, 30 Oct 2026 09:11:13 -0300
Date: Fri, 30 Oct 2026 09:11:13 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>,
	Alexander Aring <alex.aring@gmail.com>,
	Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <20261030121113.GB3889730@ziepe.ca>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
X-Rspamd-Queue-Id: 3F306C000B
X-Rspam-User: 
X-Stat-Signature: 7xoma9t3g819g6nfio4swjzre5cygxzq
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793362278-496841
X-HE-Meta: U2FsdGVkX1+GJ42zrwFPhr7ZvN02SJhQLDnRRJ1CPPGqcnRMVIu+YB7R+p5+5SVPh1yObbNoO3UmxCLeovQq0C3o2R8Vtj+E1iFoWxBHUCrcTC2Se99N6kpp3JRgN+VHvUFPxIfbdKYgYVLMrqKh7VPxKdM0bI/7RD/botuucWWNE0/Txnkz8lWc5o/KYGUmM3uxS5GkhuN4PsDVeJStOwFHMdAO2RIvbj88UpBw7yOBuaBrKK199g6X7MbT/nREfRjfCc1Hm1n6U+w2kZ9SJpWE/1RP+FmDycxq5bPLUQRI2k71rLc6iu01lOrurxohyO2Furl8WHK2SISR0PzCU98MNHMDKk4rZYhBFoBArBRSh54O/r8bUnqL8CuYEPFzVfsbQagg2W8PG3Zw98SyctcUG0UDaBJ9LKfAhRmmH9bgvuEF8BkD8Z0Uq860jgPUwotL9tbFZYTa6en7tx2ZbpmiN1bs/D9Bq2FMe3nND7pKVvTvFjTaCgeMyhFCiM712uw5xxBvYi/9Y293Rn4ixwEVsxAedoML57mPEzXzTGYtDkcFKDoYIFAg9ZY/sXoQtr9Yewgi04xK8VKCswi68htvNLzx3Jy/6KBGP1L4F3jgPTULWcbrdd3AtfL9K1uDd8S+0vZrT+XVooGOAkpcNCrcLX2e84+KBBKLJ9L1jqEDtmpjGmhci4rM9c4A3rk92Qmlcdax5fNF2XkUFbhR2h1DUtrgP5Dh4r7wWIlm7txMNxEMd1ph4dXqzoeKwxCutC846ycZXQfvNrZP2fwdniygLUIpewGiON/wDBupsbFhM8GvHSgl1x45OrDB84jQA5R5OZuQ2Skl02FVAnQqX1kqxhZyIgrZ3n8qorV9JFztXyZ9J83+vGRpZGiruvfbRezWUyhIzCz37J3CKtyLRZ2bedmV83a2mUKvnxYNuur4Z9hse/UdZs+I4fHCbkxQpg6vyZaSBk2HeZn6hSo
 Pjk5m2eC
 sOzHQtJr0pH2DNH5ewSAMPpmkuFSG6ISvVKaboYvBHBrgD7ywCJG4ecVh1IxHySZngsyjM9dokSWjGg0pDpCDQ9oL9nIVAHXdBNP6sKrY1bxSp6pDxqXIkxj7iRSmRdiZmVojMMOKFWyX06hgo9fz1mrk7ke5I1UA56SiqEyekgmhRLVQrPUoh9RPmXan3eXbhojgPIDQu8IiYbDkBf52yXaVJED/jcTZspERCgG1ba+VZWpSNoT64TVDzP1N6Tv5hu8E+baY9oaKEXJfflJl/Q0pHvLgoMPmSkOR06Q4XQeI1m3Halvisly9ssNvlOb6Bf1UP4nE9Hf0UlM2nE+/4l5Ic3928Rx271fK5RXcaNWU9LeC0iEjXPylRcJilO0zl7Z2s+4dB/VVl865BMBu8eDijNPiFC/x9KL3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
> On 10/26/26 23:05, Samiullah Khawaja wrote:
> > This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
> > holes from being punched into a shmem or hugetlbfs memfd while leaving
> > the file fully writable.
> > 
> > Background
> > ==========
> > 
> > Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> > memfd_pin_folios() to pin the folios backing a memfd and hand them to a
> > device for DMA. Pinning keeps those folios allocated, but it does not
> > keep them in the file. If userspace later calls
> > fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
> > the folios are dropped from the page cache while the device continues
> > to use them. The pin holder is never notified, and from that point on
> > the device and the file silently diverge.
> 
> We have the exact same situation when userspace maps anonymous folios into vfio
> and then desides to MADV_DONTNEED the pages. Or any other memory backend that is
> used for such purposes.
> 
> User space must not zap/punch things that might be pinned elsewhere.
> 
> That's not specific to memfd, udmabuf, iommufd or anything else.
> 
> I don't see a reason to make userspace (that should not shoot itself into the
> foot) a kernel feature it must activate itself to not shoot itself into the foot.

The issue is live update doesn't preserve those background punched
folios and now we have created an UAF attack on the kernel across
kexec if you don't do something about it.

There was some notion here that with the right sealing flags we could
tell if everything was 'live update compatible' and then know that
these attacks are impossible.

Jason

