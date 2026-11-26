Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D29606A334
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4YDuVLo
Received: by kanga.kvack.org (Postfix)
	id 301126B05B1; Thu, 26 Nov 2026 11:36:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1F66B05B2; Thu, 26 Nov 2026 11:36:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8B86B05B3; Thu, 26 Nov 2026 11:36:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0F276B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:36:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78FD54050A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:36:05 +0000 (UTC)
X-FDA: 85477822290.23.34FFF09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AFED9A000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:36:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4YDuVLo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795710963;
	b=hBKF1YfyXpAtnuNCHBs2i+6JLWdA/Xo8ubXIBUbow2QJI+nSO4i+mZKBeeBlygjkDhHGEp
	eE+ajij4Hc4O3WDt9lNJLH2CEhXdz+vB2w3WENkAI4Bqb4uqX0iTHM8KTRx58ailA+cZOZ
	z4yPT0GhFw1uYppuRVlT/O53Ah2IPdo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795710963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATJlsXEmgBegCpn5BwHudI3qqubv1tTP7fksevRvHqo=;
	b=jztQOyw/otbsvVn/rHQIXEEsKOSu1DYVhRZtnXhbPeCriPQO8Ik74iY027tdd1kmd05T6l
	Iv/V6IZnVeT8HefWUpwHvjSZnPHu/2UQoQ/6KhCAf0ysdvnIW+uL4iC8rtd9KOq+Z7eY3L
	G3rqrsjB5NZJv7JpcEpRwzPtdO3LA8Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4YDuVLo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC21E43D4C;
	Thu, 26 Nov 2026 16:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBB51F000C0;
	Thu, 26 Nov 2026 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795710962;
	bh=ATJlsXEmgBegCpn5BwHudI3qqubv1tTP7fksevRvHqo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=P4YDuVLowB3qq6ykOWDZcHMLKiSKQ8CQtAy4yUDqIkd8odRAKualfMPxWHGSnkm+R
	 2PWj2HwPnluHX217yIVBnz4ltf8gud7DVpDIOVnWPvj2tmRtQDwkW5GrLyBPVwc1P2
	 H8DVFw6/ujmQyjdb8hK5mKWwhnS5tQTm/FrakhOc6yTOGs/qksPdzN8PYv8RMpUQw7
	 ulmxngnaHoudWBkL+v4xPagIwwh7UNMjhR3rRlw1bwVr1T+AnwXiCuZycThNIvKJJn
	 Anqy+ejek6aYvEhB9sE0PqvuZhyTpgFBZ7BDw7EvqPO1q3MBdMmd2U7pPYubVmNwfN
	 QLihl37EmKX6Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Matlack" <dmatlack@google.com>
Cc: "Pratyush Yadav" <pratyush@kernel.org>,  "Tarun Sahu"
 <tarunsahu@google.com>,  "Pasha Tatashin" <pasha.tatashin@soleen.com>,
  "Mike Rapoport" <rppt@kernel.org>,  <robin.murphy@arm.com>,
  <maz@kernel.org>,  <will@kernel.org>,  "Alexander Graf"
 <graf@amazon.com>,  <seanjc@google.com>,  <jgg@nvidia.com>,
  <loganodell@google.com>,  <arnd@arndb.de>,  <dwmw2@infradead.org>,
  <baolu.lu@linux.intel.com>,  "Bjorn Helgaas" <bhelgaas@google.com>,
  <oupton@kernel.org>,  <alex@shazbot.org>,  <gle.com@google.com>,
  <pbonzini@redhat.com>,  "Andrew Morton" <akpm@linux-foundation.org>,
  <kevin.tian@intel.com>,  <joro@8bytes.org>,  <kvmarm@lists.linux.dev>,
  <linux-pci@vger.kernel.org>,  <kexec@lists.infradead.org>,
  <kvm@vger.kernel.org>,  <iommu@lists.linux.dev>,
  <linux-arm-kernel@lists.infradead.org>,  <skhawaja@google.com>,
  <sagis@google.com>,  <linux-arch@vger.kernel.org>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
In-Reply-To: <DN4H5ST3X9L1.3IUEC1CA5QI8H@google.com> (David Matlack's message
	of "Wed, 25 Nov 2026 09:40:47 -0800")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-4-tarunsahu@google.com>
	<2vxz4idb1i2w.fsf@kernel.org> <DN3VG4JCILOO.YN40XHHSWRPH@google.com>
	<2vxzld6hx97g.fsf@kernel.org> <DN4H5ST3X9L1.3IUEC1CA5QI8H@google.com>
Date: Thu, 26 Nov 2026 16:35:54 +0000
Message-ID: <2vxzse0nwnx1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AFED9A000A
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: kza3wodhnq84cburgjdeophatwn878k3
X-HE-Tag: 1795710963-911870
X-HE-Meta: U2FsdGVkX1+Ii7nvRvaW0125GCjySIbbvChALJkq4VI/lWbcfwK9EPKht4zk0Ug3Fx7P4vGzAhZWb+q3psPH8kuyWk1RlBCSA7SRhBpehXRdl2XgBQ6v+kjskzWG5EQ6Er7FM3eGOSH/eSaOSq28wCMW0VzRjFfmHO5izE7C8JTcK60wr7fQ1BunmEYDU0VSZ6n6Nbtcy6QaK+W+zUsFWX5wuDf/NIxfvmQo9DbN/66yK4q5pP+zbjK+Huqhe/jewgg4HubecAjWXgsjrTLn32xfKJFIsCQpLFlHHVcHXj9ny9DyD7oU65f1bAc6TqhF+Akozudj/VY1vAQYDb7/idfObkyvaCshuCbpWN+GZTpDiowicWrKxzf9wMrqHhNgsAx4QXAPH7kEEjLZy1yhECwf5wGeL8X3C1PmX+OMlhLBC3cfXI+IEIjUUbTXYr64WF1+DbMd6tQ5CmaAUGeRdhohTl5mn/kfbxoKlcXdpC1THRC/btiO3O/Rl30tSMViJsGtaVS/L7t2iCs7RZZTL/1dZWP4219R8pm6X/+mAz5Z8b2l2zEnFUpnExQSs4ONXHyoUB6JcafN0T4o0VkvWTrZxubiOxY9W2X6Bn0NRU5+Efjo6+bKtxJqJI3AWev29FLSLa7kFimF2Zt7iKH4x7s7W6LqphGbFbvRWmrn3udb4wybgaM5hnAyW8SH0cPW4v4yNpymAisJGxuGCqcWoaTXYOAYOmb/BN0TIRjagocsLVw58wpBXcLiFB3oZ6oj+1iqOfHBsKg/GqIdi465uC+swTePAQs/k9RYE2ghDpZtZ90FlyYqrGAE8EkNLmhbWnciohEA1XcKwNLhA/+Dopxjb2qOLeHpzeyBzlMYWjHronSWjdkX/uGGvyGCTxUVrymfsO3Zq7T6jTsS4LIuny2ojoI6ehXvuHuqDlpxelamGWj1JVr91ruhNDCElzUFDItZ6iEltwmIOgd2l8S
 7KPm8FoT
 TeVZwq7FgAHSIGKAHMHI+kovnX1xWuQs05jFaMx65vRimWhLMUFX+n9huafoEcC3vhnBhawQlvDcwaJlPhB2wYpR0aGQAfPraB8t1vOp7nlhMKj4EA5xTzlj8BLf3KuXcn1cU+gD412I9tjkE9LA6fKK+yK23OE2K4IjdTO2Wxf4zjjmDj9kKmasff6UKe24BntZUVWczmZqi23m1cH4FD9XRfpaJEMqZ8RnKi0VI04EYNcyItwjQ3HvDFYVxjJrshnyHNUo7boCrEV6OYSxXHY/l8KjpRWLuihbH+njoUCUWWvFwAWCL7l2B3QOetJw970JBfh+Jpuo1OEXtWBtBpgNYL8LCM8DIYhGgjrsbGf/jjiwMWvu66/qVxyVLI306nrCxSpM+7KWNjdMne+eFkwQa+xZWGWxHzreifjIRs6YKfn5jsfK9SNINOTXMR8RT7KgZPm1+FhdGboNIYVcQlC1/ZGb+sI6uoN2mnw07V3sepqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25 2026, David Matlack wrote:

> On Wed Nov 25, 2026 at 6:43 AM PST, Pratyush Yadav wrote:
> [...]
>
>> So I wouldn't want to support slab until we have file handlers that
>> churn through a lot of preserved objects.
>
> Makes sense. If KHO slab isn't coming, then I'm fine with the arena.
>
> One thing I realized is that the choice between the two is visible to
> the incoming kernel. With separate allocations, the incoming kernel has
> to free struct kho_vmalloc and struct memfd_luo_ser separately. With
> the arena, it must only free the top-level allocation. So we should
> pick one now (while memfd is bumping its compatible string anyway)
> rather than switching later.
>
> Separate allocations leaves the door open to KHO slab but wastes memory
> in the short term. It's not obvious to me which direction to go :)

Separate allocations aren't any more flexible than arena allocations.
Even if you have separate allocations, you need to know how they were
allocated to be able to free them. If they came from slab, you need to
call kmem_cache_free(), if they came from kho_alloc_preserve(), you need
to call kho_restore_free().

So you need to store the information of their origin somewhere, probably
in a feature flag. Same goes for arena. If we ever want to move away
from arena, we'd have to use a feature flag.

So to me, I think they are about the same in flexibility. Using separate
allocations is a tiny bit easier, arena is a tiny bit more efficient.
Which is why I like arena mode.

-- 
Regards,
Pratyush Yadav

