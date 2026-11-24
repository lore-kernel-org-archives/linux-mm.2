Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36552606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZKayue7
Received: by kanga.kvack.org (Postfix)
	id EB9256B0742; Tue, 24 Nov 2026 10:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91066B0743; Tue, 24 Nov 2026 10:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD9E6B0744; Tue, 24 Nov 2026 10:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B45AC6B0742
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:25:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F93EC0BBE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:25:55 +0000 (UTC)
X-FDA: 85470387870.15.08F7A92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9B9DD1A0013
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:25:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BZKayue7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795533953;
	b=MXNDfLgmYkDmi3cc3EdKFtNwXhfTPAZpNzGpncU08SASqnLJ6i5i/xXMa21CCpxafl+NiN
	5WV46MH64hTV4dvg1pyQOcC0vHQMU9d3kU0w3EQAIawrfU6dI2ToNAsy6ehqe1/IKJUctQ
	gqSl08PLdisoQQboZr/Bk6xXwtuTBZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795533953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UXh4PQJOR3VknqTlOD7G3LYkfB1ZlA2WQOnvCIXzSk=;
	b=JYt1mTVS0nY8dXlIoD2Abwdd1QQacMhjv3Z/tUFyEIpuy4ZJt/gsOzAuvk/o+Rm+lIZRGT
	r9bY+nf/UR3gW74mq0DvT5pb6sOeyY5fa9MLh1CAeRGBagPn2IeuqXdUUILzXZoDjvBBrW
	IIGzDDmRr778Hqop67U+4nKPoKqha60=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BZKayue7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF5CA443FA;
	Tue, 24 Nov 2026 15:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CC31F000C6;
	Tue, 24 Nov 2026 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795533952;
	bh=1UXh4PQJOR3VknqTlOD7G3LYkfB1ZlA2WQOnvCIXzSk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BZKayue7T+OsylZjV79b6R0ytIW756sZrlscpck2YyZhapT9Gi9uxQD2TAqTTjgK1
	 Ny12Sm0RAzgn+HtgnA1nCyeqansp2lHh7ivIj/Ix1qFbH4HuVOa8qCEjIyvtoi9D6R
	 +jHmiVlbd0ZMEtoLUPptwix0CB+DWa1XVAy1+YYY895ci0d7bJUu/p9MbsNhjGaGh1
	 rfdPKCuFn+l+eN4jST+wJuMHZLweG6N0w74drNJ6WDvCm0j+qp/odn0AgQomKQb69w
	 XBI0ZPyD+v+OEE7bdKKZ7xDxe6TzGo/x9t8gCGRgnlp50DOQffqNVxBveg3UN2VOyB
	 +YF0ajNdmMBkw==
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
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
In-Reply-To: <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com> (David Matlack's message
	of "Mon, 23 Nov 2026 09:32:17 -0800")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-6-tarunsahu@google.com>
	<2vxzse0rzjdn.fsf@kernel.org> <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com>
Date: Tue, 24 Nov 2026 15:25:44 +0000
Message-ID: <2vxz33sqz1xj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: k69jbj3siuto9g37bxkmzitgkmrj5zow
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9B9DD1A0013
X-Rspamd-Server: rspam03
X-HE-Tag: 1795533953-542692
X-HE-Meta: U2FsdGVkX18OWAK7NXnxPkcTERB6BWwbm0rLTtNMp2TJVBO+RElP0laGoDyOyGisqeLvSSWzK8lHeqWTljtfvdD0LS6mtT0Hrtu1jzjVgJG+ui6XcubVuOBAvDR8ZgIUAIk0Wa8US/d4EiSZB1TDfGdPFIAZypEhFNotFta2KHuUY8tjvZuve6QljJq3BSr6qWLEiMfUUGrthXOxxvW04FG52oSEj5OtWl50GjxQsJoZiX28fYPJ0bEsBcXfY85OjtDC3Mx/v/lgVZHHbO5EbvEjkTe8PBfRUQwbZhF48Qn74Zif1bY2l9OG6w9CJ2pFjqQDadgsTzYC/FzyJXu/xdHsmLydhbG6RnKQ7AwogEV5pzpiQKLtx92sbX2wbvrAn+08hvL+KZ8ipoHxx88K4oHE7GqcC1b1SANDM+TCpsk82yZYKKrqaFXNL+gYGcsIo//uJOnbnZlHUgPWynwlWFpZM9dcnWP1Xxw9wLWUuqs8OvlhkppeedZdRUxVZKDGOz8lnbp5+ir2fv4NYal5FJl8dUNPEagwsB0lr2lNOe3jZDBDNSWnjUK6yx03kFFhNznPc+nk4qAcAAvXHr+Oc9A7YOoD9v1InPufgbqgYyiNKBQE6bnfsC3sSqcUJMrrOwwlVRJ5E4fQN48l+QG1IBmRxGp8LEJG6LA+r0gI0PkTE/wNiVEehp5PB4S6mmQm2IXYsl5rEVu0LjZ1QUfVEbii64OMpZbRKp+KS8VzdsOIbFKMbtd01EGLru8AZEeLopZlP8O+9CASLGyCkNXZ0EaHnWqM8EFZK1fcw77QCFEuRy4kzwOXFwe06Tq15yp6g+yWVJ2J5NDSCzuze9rKNhY2gUyBtid1rZrRoBwgfL0fCY4tNcRLDBp7VJQhGV7uYCL2zpGIfYxtLpSLRd4tMXEuXLB3XfkC0Vw0ogtVhztGevL6aaYPkJSG5hDsNuSNMBvipWvxp0iCfoLVIuA
 6l/YdUc1
 Q+AMOx8KKgd0KxCF+fYCcTsxeZmljEZZHzlufvMaOamE3z1pp9A3l7tzkfH466y1jnzAOsZV+WLtmSCYRIan92ZGMCR3Kvw2zXIY9nHSWMyDhmNmFcB7ab0W1ZAT5mlJ+RgRMEnrwZP4R1MhGGw8a5xsckMIMXR+Ity3pjS/whGT+V1V+8nDb+CaVEVooHLBFiKYh/XjlE5kTNloashVokuBB+7XuBHYW/QLxhH3aPU6BA7T/8M3ohQ/WWhP8G/hpjYnDpgjWt+4Ib+Sr1AJVGKg4SWX0HCo9CnuqtYvwLOob+dvEH3PSNB59uXfBFTkc0lhwBYPE+GEryAF/+cJGiAoUVF5yJeF26knNibgVGxRNVsj9C5/5YC0p7/IVbeffH6aYRA0bdPm//c8OUAMpgkx7OC+fIUTlHB8FdxCVv1XhrXmgTTd4rJ+bwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23 2026, David Matlack wrote:

> On Mon Nov 23, 2026 at 6:56 AM PST, Pratyush Yadav wrote:
> [...]
>
>> When we have all this available, I don't see the point in
>> differentiating between optional and required features at the ABI level.
>> At the ABI level, all that matters is what the incoming kernel
>> understands. If the incoming kernel does not understand a specific
>> field, the outgoing kernel should just not use it. There's no point.
>> Best case, it gets ignored.
>
> I pretty strongly disagree.
>
> An optional feature is one that the next kernel does not need to
> understand to correctly restore the object. A required feature is one
> that the next kernel must understand to correctly restore the object.
> Optional features can be enabled without any compatibility concerns.
> Required features must be enabled carefully (IMO via uAPI) to avoid
> breaking Live Update.
>
> I agree it's a good idea for the outgoing kernel to check that the next
> kernel supports all of the required features it is using, so the Live
> Update can be stopped before the kexec. But that doesn't remove the
> need for the distinction. The next kernel still has to decide what to
> do when it sees a feature bit it doesn't understand, e.g. because no
> spec was provided, the spec was wrong, or we kexec'd into a different
> kernel than planned. Without the distinction it can only:
>
>  A. Treat all features as optional, which risks misinterpreting state
>     and corrupting memory if the previous kernel did not properly
>     validate the next kernel's capabilities.

Right, that's a bad idea.

>
>  B. Treat all features as required, which means no new feature can be
>     enabled until every kernel it might Live Update to (including
>     rollback targets) understands it, even when those kernels could
>     safely ignore it.

I think this is what we should do.

Why do all kernels need to understand a new feature?

If a kernel can safely parse an object without ever looking at an
optional feature, why set it in the first place? The outgoing kernel
already knows its target can't understand it.

So say you add a new optional feature in kernel X+1. For a rollback, the
kernel X+1 knows it is going to X which doesn't understand the feature.
It should just not use it in the payload, which means it never activates
the bit for that feature. All the feature bits X sees are the ones it
understand, and everything goes smoothly.

And to be clear, I'm saying that the feature bits in the ABI header
should be set dynamically based on what is used in the payload. The
feature bits in the spec are static. They say what the target kernel
understands. The feature bits in the payload are dynamic. They say what
features are actually used.

>
> Neither of those is a good outcome.
>
>> The semantics of required or optional then become "can I describe this
>> object with the capabilities I can use?". If the answer is yes,
>> serialization succeeds, if the answer is no, serialization fails. So
>> with this, KHO_MAP_F_MULTI_INDEX or KHO_MAP_F_DYN_DEPTH are indeed
>> optional. All memfds can be described without these, they just will be
>> less efficient.
>
> I think this is a different meaning of "optional". Whether the outgoing
> kernel can choose not to use a feature is a decision for the serializer.
> Whether the next kernel can safely ignore a feature's data is a property
> of the ABI. KHO_MAP_F_MULTI_INDEX is optional in the first sense, but
> required in the second: a kernel that doesn't understand it will
> misinterpret the map. The header needs to convey the second.

Right, which is why a payload handed to an old kernel should never set
KHO_MAP_F_MULTI_INDEX. Even if you have a property that is truly
optional and ignoring it will still make things work fine, why would you
want to set it in the first place? You know it will be ignored, so just
don't use it.

>
> So I see the spec and required bits as complementary: the spec lets the
> outgoing kernel avoid features the next kernel doesn't support and fail
> before kexec, and required bits let the next kernel fail safely if that
> check was skipped or wrong.

I see a marginal benefit in setting the optional bits by adding a tiny
bit more safety. But even then, it only hides the real problem. The
previous kernel should not be skipping its checks in the first place. If
you're lucky, it might only end up using an optional feature and you
might be able to ignore it. But if the checks don't happen or are
broken, you'd be just as likely to be unlucky and the previous kernel
might use a required feature if it skips the spec checks.

I don't think it buys us any functionality. It just hides the problem in
some lucky cases.

In fact, we could even add a "strict" mode in the future, where the
outgoing kernel refuses KHO if the spec to the incoming kernel is not
provided.

-- 
Regards,
Pratyush Yadav

