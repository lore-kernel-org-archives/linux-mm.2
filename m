Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B959606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7FHZ7/q
Received: by kanga.kvack.org (Postfix)
	id 446CF6B05B4; Thu, 26 Nov 2026 07:18:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E106B05B5; Thu, 26 Nov 2026 07:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334586B05BB; Thu, 26 Nov 2026 07:18:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E50F6B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:18:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9510D804A2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:18:08 +0000 (UTC)
X-FDA: 85477172256.26.44DB731
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DFC45180012
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:18:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d7FHZ7/q";
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795695487;
	b=veV2SZu6Vn7sczRT3PIzZ3eGKfvARtn8620/OPNfWNXBZCChrUi8TH4fsZZJhJD0AqWstc
	VKUmShQ58uU4fV8v90xm8VGD7XYr3OZj60itesU12jjndyydCdBJjQ3/ZFbqdot5Li5lMz
	0uo02v8W007ec4ZBXpdzzpvZu+IAzvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fv3YfealIuJOICIo52kCGcexbGGkcP1zYkCoBpg/CRc=;
	b=j2UXHegzhL6iHNv+rQ9j436ZDZphS7QNnHJa/uiuIem4JoxrpiM1Gj92pZtA2dfJnD1tes
	O04+OmIu7suriWueQmW/sakzXmMb2py0dIInEJBN+YO4+7QhR9vXBI+alPXPWb52rFKLnk
	pDirBwlcnNSReMjg2qNzUVyJvoj+6Cs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d7FHZ7/q";
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33C2740C1A;
	Thu, 26 Nov 2026 12:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A351F000E0;
	Thu, 26 Nov 2026 12:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795695486;
	bh=fv3YfealIuJOICIo52kCGcexbGGkcP1zYkCoBpg/CRc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=d7FHZ7/qUp6WWqybny1XNnHENYGPzZQbY033qB8LP+ktd04t0YBSNl5E0O+sG4tfb
	 qYjI0sP/lnADMjPMofkcXeziLzNt7GqRbBheXfA2+1yhLE0CUrcyMTtSlYaCCY7H09
	 uoMkRwHYyHZRx5vDQSEUejVWNr5nGWk78t+OYL5ASbIHgkGtkdyCcdhFJV2QYRTSX/
	 AntiUF73LI7CSYKoLAM+NcGDiRodxjxMn3ADxZ3atvxtzb+Myp9Q0iMVOVib4BIMtZ
	 Fakbv0fVxZv2UKoKkwnrXPj8HzqFSo+iA92jTp57TPWKBAjOTopU0UM3cZv4WOkqPY
	 L5VoV6BiLk/zg==
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
In-Reply-To: <DN3O9LHR4XNH.1EYLA6D1F0J2P@google.com> (David Matlack's message
	of "Tue, 24 Nov 2026 11:02:12 -0800")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-6-tarunsahu@google.com>
	<2vxzse0rzjdn.fsf@kernel.org> <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com>
	<2vxz33sqz1xj.fsf@kernel.org> <DN3O9LHR4XNH.1EYLA6D1F0J2P@google.com>
Date: Thu, 26 Nov 2026 12:17:58 +0000
Message-ID: <2vxz5wxjyefd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFC45180012
X-Stat-Signature: 4maqz8ifcnw787r3q66tbgy4b91ur1b6
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795695486-493924
X-HE-Meta: U2FsdGVkX1/WIh+4VFNfGzTQD2N/ST/nGYa8PMnzsAUNtraAmywnpsGPrHSBb2+LagS4e0OQt7fjw5PboOs8qmG2hrIn3ehtQYzG7em60SAVUqqEke7g4mfqO0czBxTsOeq1RdxxR1vvfhjhTh52LLE5sEUgyD5mhcr6GPdTQ33WQcvLm4WBWDumUuBQ0EuXA7B59H2pGgYocJ98fX7/ZPPLkaejTdbhnKQT+hCWgGka8UGg25HAYvU717i7Z6ipI7/eho9ACanGTgYuXCY0XJXZF8GVUJarzIIhe0GacFl2YWtltR2zf2fFbyim65jTaXpSX6X3PdX6u+B48GpXF8JlnKwjAAfemHcWfb4jSTe/UeMHC4tZ7KOBiXl5GWOQEKEvhbuxgMSMjKrWQJOwNKtOVyOGMYaejaSO0hUsBX9OCGxES9x1kRQVio+ExpUOpc8b/mGRMwGjnHR8AwYKS7tu29A9N7EtmIOJG6/CnPPIQ1mfR+CpoDSuJylnplfKnU4CsnbnJfzdbjwK/YXfNEPP1+zjG3Z8O2rFknkDVrsj1+9pp52L76eDouHeT3pYug+NVeDdqH6ilcDal1MInrnowdHngB242jGDfXY7xN9oKXnfPHpKBCoaYudJXCSwzg4I76HTVshmE5myJ6ws72Y9hQ+7Q1Jca8c7vHmIIO2On+TvXw45qsipUcc4a2mdLUofRdNOzHVgObGaQL49ejI2Kk8qwhOsdkWYpQCcLfdNjttp97U30aiQ+rES1OL8Pnh7G9MP1jkYD6FsRWwC/a9x5vcHIxI9BpKbauU541ZfMI0mgVbYE8lf/nHFIPeXI1zyKAlXO43LLwOo0yVf8YLCcxxq2yQ3tWmjHP0jfuCD5IS1xDr7H0cmgyeGjlE2JnzOSmQWzaFVbjVlxxDpXm4KCceIP6+i4cWPjiAvL0ay4rTV40S6eIiQZbNGr437UYxY88E/N+5TRVgYS+d
 4qjygvkw
 eYDkdbBjxlyE9Wfa4jSfE7KFJebrb/dT5xdsG6unG0IfYFIFCYqRSmkLdDEazpKmRmxO/c1bZbdqQDjkrDs+ZbzBfQL6BovbF4cdIpuydIdR06EcI6r9RkvrALqlTZXLGED0mJuNRg1bmqFq0bSFTfVgzLVaJN0U6T62N0Za6z/LtD2/ZRuPUOy9TeVrmeiTnLoS1mh57zBcK6DJfMNPHSpsVQ99D0Sjxb3M4IVWHFCx9RHc1I8jEkBPkPBsk5Ef9PVl5bd/W525N78zXwbOa5JtK/OH1Js7+4+JHtpA2ryd+Y+9CcQc25r+2p6UbgeRSJDJCbC5/HGWy6HwW8Dk5dHHdGEK2GWtctfoAN2wzHHnsm64degP9Z0VbdoZtBuhQU65D60dsvR8tb/o5/zal6nkpD2iRg5yNR0m9yciP3+LNj8mIpWkWGEJ13Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24 2026, David Matlack wrote:

> On Tue Nov 24, 2026 at 7:25 AM PST, Pratyush Yadav wrote:
>> I don't think it buys us any functionality. It just hides the problem in
>> some lucky cases.
>
> Following up on our offline discussion: I think it's worth keeping
> support for optional features, both before and after the spec changes
> land.
>
> Before the spec lands, optional features are the only way to enable new
> features at all. For example, the PCI follow-up series [1] preserves
> BARs and bridge windows using an optional flag. It's purely additive: a
> kernel that doesn't understand it keeps behaving the way it does today.
> With optional features it can be enabled as soon as it lands, and Live
> Update keeps working in both directions, including rollback. If every
> feature is required, there is no way to enable it until the outgoing
> kernel can learn what its target supports.

Right, that's a fair point. But I really do hope we land the spec API,
because I don't think we will get very far with only optional features.
More on this below.

>
> After the spec lands, optional features are still useful, and at worst
> harmless:
>
>  - Kernels that predate the spec mechanism can't provide a spec. As long
>    as one of them is a possible target (e.g. for rollback), optional
>    features are still the only features the outgoing kernel can use.

Technically speaking, you can generate their spec by hand and feed it
into the outgoing kernel, as long as they use the same flags format
(which they should).

>
>  - The outgoing kernel doesn't need to consult the spec for optional
>    features at all (less complexity), since by definition the target can
>    ignore them. It can always produce the same payload, and only
>    required features need to be gated on what the target supports.
>
>  - Nothing prevents an outgoing kernel that has a spec from choosing not
>    to set optional bits its target doesn't understand, if we ever want
>    that.

Makes sense.

>
> The cost of keeping them is negligible in the current design: the same
> number of bits in the header, and one range check on the incoming side.

Yeah. The ABI ends up being a tiny bit more complex, but I think it
should be fine. It does plug a gap until we land the spec API, and since
PCI would use it in the near future, I think it is fine to keep both.

>
> The one rule we need is that optional really means safe to ignore, e.g.
> optional data must not reference preserved memory or carry restrictions
> that the next kernel has to act on. Anything like that must be a
> required feature.

Right. If an optional feature preserves any memory, it will get leaked
if the next kernel doesn't understand it. So I think it is only useful
for adding extra information in the main serialization structure.

While we're on this topic, here's a brain dump of my ideas of how the
feature flags should be used.

I don't think feature flags from the spec should be a passive check of
"can the next kernel understand my payload?". I think it should take an
active role in deciding how serialization works. Each serializer should
look at the spec to figure out what tools it can use to best describe
the object being preserved.

I'll take the example of memfd and KHO map once again. If we already had
the spec API available, multi-index entries would be added as a required
feature.

Then, during preserve(), memfd_luo should look at the spec of the next
kernel, and decide if it can use multi-index entries, or if it should
fall back to single-index entries. Userspace does not directly dictate
any of this. memfd_luo makes this decision based on the spec it has for
the next kernel (set at a system-wide level). It figures out the best
way to describe the memfd with the features that the next kernel can
understand.

Another example to demonstrate this would be LUO moving from a fixed
buffer to hold LUO sessions and files to KHO block.

Assuming the spec and feature flags were available at that time, we
should have added a new feature flag for KHO block, but still kept the
old code around for the fixed buffer. When doing the serialization, the
kernel decides if the spec has KHO block enabled. If it does, LUO uses
KHO block. Otherwise, it falls back to the fixed buffer.

I think this scheme will be a lot more flexible and future proof than
using the spec passively for validation and trying to write a payload
that can be understood by as many kernels as possible.

-- 
Regards,
Pratyush Yadav

