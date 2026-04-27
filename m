Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7444AFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE4E6B0092; Mon, 27 Apr 2026 06:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB62B6B0093; Mon, 27 Apr 2026 06:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF31C6B0095; Mon, 27 Apr 2026 06:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE81B6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:23:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B522C0339
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:23:17 +0000 (UTC)
X-FDA: 84703948434.15.95B3A36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 30CD74000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:23:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q53B/wDn";
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777285395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qaj+dGhMqsmOlVqI0n4zS+2yba79faKYxkzvdqljdAk=;
	b=Fxu7qJNqQX6D7TnUToH0jSn50BDJ/CsdTLNBRPq3oexmskGwKTUzvJLwRNGiwhCnWeu2Sx
	G+lnnvnPBbscVhTUGcBLnZ9VwbJouCC0w3xEPhveiY4h80a/qEPGChEwKBXIhCUGcRNqWV
	+lW9PVn+QteTEos7Lt4T0MsRRO14QxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777285395; a=rsa-sha256;
	cv=none;
	b=zTj14ra6TZfxCaW4cnZ65JYihroB1VLeWIaKDOLEe4ASQi6AkaZhsikfJ/PphcntDKyo5q
	SICHC71bAF/NUTNzN7gl/FqheNkw37m2O73Im7zy+tV2EreTNMSa6RWPb27/qJYPoNExbG
	7n8XzN4sePjGotygSlQgFvdZgwljMiM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q53B/wDn";
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8092060154;
	Mon, 27 Apr 2026 10:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98520C19425;
	Mon, 27 Apr 2026 10:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285394;
	bh=fUpg5gsOkSvFFfXQrHt3olWMMe5hz0pDIK5bBl+Z4nI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q53B/wDnwzeVo4lRh05DTg7drzUct4zy+D6ard5OgdVJy7Jz1RQF1/zm6N4h0Lqzh
	 v46K+wEI/XGqlmLe0UPUEgNf+kbOTUJWjAeigI84HIY99I0QLvaQs4D7iLH+jxw/hP
	 z8sFdNEZnB05fIoGqDm7Uoo8a7ZZ2raE2MX7ik6PzEoDsHQETMWrvACW/S3nW6SUpP
	 3Lb3NEJtzR0R36dqyVe7GebvpMIpkiAe8gM57BOFIKTGa9PgAvwe4iX2s+Ter7f9R/
	 WNdq5RSGjWuRlUBYZ3k6T6FucEcqJiYIiVhusrr7DyiEGEQysQUnF+TE9oTLhsGS8w
	 QlW+YYOWaAIMA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id A0F32F4007D;
	Mon, 27 Apr 2026 06:23:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 27 Apr 2026 06:23:12 -0400
X-ME-Sender: <xms:EDnvaQSASUKodycG1gWLUkRqBODcT9UusFWuy84vdI-C3EVmYufugQ>
    <xme:EDnvadC6-xz2k5ijqgWULOeGYjGZQeVdWEsjAwSBx7fPDGqKpEse8NdnwVpj6k7UF
    C2NIWcQpqiuYJJHhT9ZBPjSrZN1DtvYfXGE5uHo4X5ks1osi0kPtCo>
X-ME-Received: <xmr:EDnvaaD_JVeCq3t-d_gtRzhqKeED6OUKcSkXYaJOJcQ3nfi7DWy9HbSPTRXHdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeuieejieffkeehfeffffdtkeelfeelhefhfefhudehjeehvdffleeuvddufefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvg
    guhhgrthdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhi
    ohhnrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohep
    iihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:EDnvaezPSEKdvW2LemvwhYxKBhVJcmT29F55rubrnyv9XDy2vahUyg>
    <xmx:EDnvacg7o_b0HkyUZlruDqdALLMJrZk0a42P7vq1OIA2_qb-I6p_3A>
    <xmx:EDnvaQZD1VWHhFcIoaSbSMel-FmR9c7XKvLPVZFQH_m0L40votz4Zg>
    <xmx:EDnvadfzPVAnKIroABNUL3__tR9HwN84QFfqdRDcRujfhZimidzqOw>
    <xmx:EDnvaVBEE4PfygYDF4d5N4qsl8ds4iUS0KIA0ls_UKoIIIdgGgsVhP9M>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 06:23:11 -0400 (EDT)
Date: Mon, 27 Apr 2026 11:23:10 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <ae82JuqoHfgk1_I5@thinkstation>
References: <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <aes7b17nG0cXrtEd@thinkstation>
 <aetZUOINzfTXChLL@x1.local>
 <aetyhki-UD70dyRL@thinkstation>
 <652b4a01-2382-4faf-bc1c-f127ee0b2c75@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <652b4a01-2382-4faf-bc1c-f127ee0b2c75@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30CD74000D
X-Stat-Signature: zo6fkfmwajreiiabfsfo6k11btxf93un
X-Rspam-User: 
X-HE-Tag: 1777285395-309487
X-HE-Meta: U2FsdGVkX19RrbS2aXq/hPz+bQnx1Ua6YDtjWqlI4WyqKZ25vOgwNky3cXkLwqu1TXDXocdQGGJDgtHHjTFJRcUFYvbHTjR292goeTYIpns7p5x5Gbuclm1lqwFCPOmIIuBjgAmBthhZwlEqAo7hYxSWscyO10MXHotYe4W72wJp29fZQFyjJTmXnM7BOWDuUgKARMgEp+Rxyleq5qUZsfeULWxxVbfule5/d10mNHiC2VoMHbOyNpQAAnlJCF3wTpPPSUxKcznK1XlgC4iEpURifNsx1l/oDeJV2IJ+TfpZJtZ8c2Dn4WE2Hq6zo8Hzrwivj7rg0QeT4iA4frZeW09PiN9l1nwUkMgwY7KF2ifSoiFBbNl5kqZt1AzpdeVdUkQr7FLF2SxyI3vMfDiyZh/PkKnkIIKq6tYKaWesQMGP5thODnBVMkT7zLGT/V7zli76Hmv67TMjOwBt0n389psIEGK3fhXbibLG3XjFqzk+6MDafQrF1ALGcAzmh78m76FBBMdEIlJkEoiEHXGXniWM8DmYO0g9i76sQzxzVXSOOzu/kSo95EG00IZ91sORSdAW2vl0EYJrVMt1HIsk+SwLK+Hl6h0ys+xw6oX6ACCTLMSAjij/XRK/5E3ECbR/URmoRWYkkR42MROipzbqf5FtNT09HbpH5AcYHaE/kFgTJ4IGvDWuSku7BY9F5j1oX620yNqRMRGVI4iHsrH86bkIv18Jbo3MlpkT7lB5gOYth9vQu2e+MVFWFkTj9rgy51PuNFrdZcCrChaUKl/VAEVpA0rP4jZFSf0touHSmQJuNn/hB0eNNfi3Z7BTp8TkZ0Sci1BjF/YCjkkVReZLHfYbyahr3ro3toU9uUKQTyvfTO/LgawNlHxwgh8CHYtnXSIRFZw6CueVnuZgok8Nk3Fw85moozyWoFy3oudUf5tz9puHuBuAs09ivbSZ4KloaYBOWE4CnQ7PXzCqqVA
 8knR6k+u
 jVVDHey2rS9U+HjrbkCQkCEhjXqIhNktDYM+eRxZtwpoqEDyRAz0fJT75WUN/pNVpy98ajseeKcNe9LiXfFLrWY85SE9TcvYpORukAL6CmaTJJFw0qnPwfOMI8qiMKCk79znYMIWJSvKxQZF+Ec2BMvOGvBqm7WMzOYjXYKqmyT+xFcaNYerB9FTC0HHa99lH4EluCWPgSAB64Yb4c6Dr567yYjNzKwi/fNm5RZDpkXo+uBDfsodw2DVoVVOAHNZOoWVlVbKqr8i25PsGTXd1DdDtyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 08:05:16AM +0200, David Hildenbrand (Arm) wrote:
> On 4/24/26 15:49, Kiryl Shutsemau wrote:
> > On Fri, Apr 24, 2026 at 07:51:44AM -0400, Peter Xu wrote:
> >> On Fri, Apr 24, 2026 at 11:34:48AM +0100, Kiryl Shutsemau wrote:
> >>> Both page_idle and the LRUs (legacy or MGLRU) track accesses on physical
> >>> memory. We need visibility in the virtual address space domain.
> >>
> >> Yes they are, but ACCESS bit isn't.
> > 
> > A-bit is not a reliable signal for userspace working-set tracking
> > because the kernel itself is a concurrent consumer. 
> Right, I don't think we want to rely on either the A bit just like we don't want
> to rely on the Dirty bit in other code. (and even SoftDirty bit is a flawed concept)
> 
> I do see some value in a reliable RWP mechanism based on uffd. The real question
> is, how much benefit it would bring (which other use cases could benefit from it).

I have not put much thought into use-cases beyond VMs, but I think other
mmap-heavy loads (databases, GC'd runtimes, etc) can make a use in a
similar way: workset tracking and organizing userspace-driven memory
tiering based on the workset data.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

