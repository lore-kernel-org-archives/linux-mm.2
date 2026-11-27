Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A75C606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G1NP2Erz
Received: by kanga.kvack.org (Postfix)
	id 971D16B05B0; Fri, 27 Nov 2026 07:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921586B05B1; Fri, 27 Nov 2026 07:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837726B05B2; Fri, 27 Nov 2026 07:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6522A6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:56:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1659A5CAC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:56:18 +0000 (UTC)
X-FDA: 85480897236.07.F28C66E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 32F791A0010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:56:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1NP2Erz;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795784177;
	b=RvtXd7osZRe7S8yPXIg7v4vWCiJci0owOST48x8sqAXeaskvR2Xw5QNn4TyvNR/+xbpuWH
	i5jnuS8Cop+/Z066nAiEWi1UoJQ/e7oUtqHiQXvFnZF7Zr4g4Ch7Kkm0o5OsyBXh6/ydZl
	5u3GDxYX2aiWQRRNLFTD97GJLuP8BHk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795784177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCgU5Kg2KvKrAQHYH6tU0m/C/hUcvMv2qP9GBHYvr3o=;
	b=FFiFTdvx0S55YDbHb4Rme0EWWe6KHhGfmx2CRHL/IM2h2X29QTCsKhsSuwupWoP78rfEwi
	IVxbPW/7WW255guKWISgMX6jHn+uM9KtoesaF8CJUTSliaSWKp5tMwG9m9MLsUgGqW4GB/
	RkHnPN30Elv0MiYD6Y9mjLlVioOaP4c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1NP2Erz;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECE6C6299F;
	Fri, 27 Nov 2026 12:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9CD1F00893;
	Fri, 27 Nov 2026 12:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795784175;
	bh=VCgU5Kg2KvKrAQHYH6tU0m/C/hUcvMv2qP9GBHYvr3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G1NP2ErzHAioaVQ+nq2m7ayY7YcxNVkVJBX390lHxNjRrXeEYuztB/tbo/rgHtCrQ
	 CKJDVzC2jFZT+wf5yZOlgXfYlfA6XYXwaitYBHL7K6Yov5uLo1Mp/5mMAtMpVEp6J6
	 o9VeU2wzc0cJcsUJDFY5B3x73p4j7tzuJaDKOJHBOrYbLhfwPmEsBn2enO26FBiPuu
	 FKIHmIbV5+GeNCmnmebxxQgy1ag4A7ecdWd/y4JvGOHSwRvPCG7jCmOxiYTj8S7NmG
	 +tS6HLUhsEpLfhtX3W27g8tiiCOODNEfUdkh9XOS3x7z/CUZOfbG3fPmaIBlz0RTIv
	 qlctJuf5Q13BQ==
Date: Fri, 27 Nov 2026 13:56:07 +0100
From: Christian Brauner <brauner@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, Alexey Kardashevskiy <aik@amd.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, David Hildenbrand <david@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Fred Griffoul <fgriffo@amazon.co.uk>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
	John Starks <John.Starks@microsoft.com>, Michael Roth <michael.roth@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tarun Sahu <tarunsahu@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v3 03/88] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
Message-ID: <20261127-plagiat-bergtour-einfrieren-b73600501aca@brauner>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-3-8484dde66a7e@google.com>
 <20261120-provokant-zyklisch-schutt-55d8eddf2ce4@brauner>
 <awBaeiUw0i-uEQzM@seanjc-mac.roam.internal>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <awBaeiUw0i-uEQzM@seanjc-mac.roam.internal>
X-Rspam-User:
X-Rspamd-Queue-Id: 32F791A0010
X-Stat-Signature: ik9yhpx7kubatg7nqiudoob1gggiurww
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795784177-917302
X-HE-Meta: U2FsdGVkX1/vOW9KOQfZJxfPTty5TmArza4QBiR/CZDxdEPLPYUTrOnbsTrHB9X/DS5YEeY03jy7Uv5/0ZrFo5DaSqwvN8QBw703X/udPZz5FeFcMxEcimd0M3A4L/PqEOl+EGo7h75sknzeyxePfjnPt81u30odis2p3a7oRms5Hnzroy0EOOuWWpu8NYvfcdqx8mWOfInPIakDamhJM63kQASu2AH9uNWqnCCnP54pihjuxFjvj998jckC1Jp24xVmkiNFjr0kTCsDoSPyytT4JaOtN7KCW45tTlU9eL97PIscp+jDP0eXvBTkEkz2/iOUjRyETWeTeQd4R5ffCJUeIwIYK+QWZccqOa64/JaStZantBW4frzHFfpVEqfoMHK+FSExxEw10LyXQ1pmm8BWWSlFm4G/ejOILZHu95zc+b/K/iJ8uoQXBflp2hC45HlekBJy5RtYAMi2DumuiQbxEx20QckrTRVCIqTxTxVkjNxEUw7hAQ0wvYzBDdQYwOmNzHAwFor7pP36+1Kmk96eqhZqCamrGOhOINR17Ibs9+reFEB2hVfPcgH7nwRSs4TEpQk0rEbRX13HOJmC0NYQ1hYbFm+BJI0P371lLbJyBVvXCPAsb0FTo+1qaQ3FwAXV6x+rWQPMTFTU/b+JTMtXUyjxVzieM0WhqI0fh2CvBblbCSnUQh21iXWBx7/5bsgHMJRNnb/YXF+vrf5MibjcVFE++2vVsvFHQ5Yk0FBDaV1ZYPLoQDpFHNW0TgFrNkTFzjSKQaTyo2O1EdQwVaf2EUy4ECofTl0IhQXFRSlCf7VHTZM5mse/Z06IdIUMYDeF5CzyozHrv2XIdgOqf01m7p4ghe/qya9oZkdxlCk2EDQxO3iy41nmnMwMSlPMyOmLc0MSHOZf6JRdnxKVXz6R2JD8ZAzWyaOqXxXMk68uHT/6jbvZ4qhkyXPTNsos/+5NCQTtrDIiaEiDaYl
 3G5JV6jY
 zDAGyLn050c4RLUx7zfZYt4dniSBqHslcvqTGw1aofNuN07rmhKhKx/b1GIFJHli+85K+iPaQrIVry19XQaPpeF4k9Hi6aWjZ8H5ePcJj3dxyhTwLphWcvZuKQS9Ve5FPFqt+XYSOHWF0vHSEFNP+mdePFN6SnjrkV/rgC0K0/W7hxfIAyeNfRi+1qyecL2lTNMN/08gAgSd5zVDEQ4xWxhuNX54o0f9TsV8nQEmAYHVKb+EWkHdGjf81cjwxJft/4wLC4C/VNBAOWgmz8iDfj8+6qvUZChjZEwQ4T+sJi+q/d0PH8nBx8IlchxoSwyzVR4rffNx3h2Y8SfidCRGYqvH6umSS3sSBpN/hKnFxA2gsz+BoR8yZvDiQxbrmBvgXIlLCA1BIwVoAFCwEnneKPK2aMI11NfB4pxrc1curDr2jt0rSv6q/bS4sX8YNpC/UGuHplUHXA6c2sjA0zmph1aZO95/iil5A8UAIEeaP64gV+r4KNhbKVeJOBc9g+mFZGzR6uPRQTsgo3kLs5Di7R8gOgRp86x8OOv6aHL1mo1a6yAS9fDOtU9vaiOzNxdsdMbhHanxOvuvbQGNoaJl77bWl80S4qeLE0fsf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:34:34AM -0800, Sean Christopherson wrote:
> Eww.  I really, really want to avoid having to update KVM just to recognize a
> new provider, and I shudder to think of the potential module dependency hell we
> could end up in.

I don't think you have to. LUO solves the same thing without file
operations:

* Providers register a handler with the core.
* The core asks each registered handler whether it owns the file:

	liveupdate_register_file_handler(&memfd_luo_handler);

	bool (*can_preserve)(struct liveupdate_file_handler *handler,
			     struct file *file);

You should just do the same here, I think. So put a small provider
registry into core code that is always built in and not into kvm.ko.

Providers register a handler with a ->can_connect(file) callback and kvm
walks the handlers when it's handed a file. This way kvm never needs to
know about individual providers and the providers only depend on the
registry but neither on kvm noor on each other.

