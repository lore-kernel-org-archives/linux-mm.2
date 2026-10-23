Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C502606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VE5P8aSC
Received: by kanga.kvack.org (Postfix)
	id 3813D6B0BB9; Fri, 23 Oct 2026 13:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358C36B0BBA; Fri, 23 Oct 2026 13:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223EB6B0BBB; Fri, 23 Oct 2026 13:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E00F66B0BB9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:42:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6411DA680B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:42:24 +0000 (UTC)
X-FDA: 85354610208.07.A7E2FEC
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 87B84C0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:42:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VE5P8aSC;
	spf=pass (imf10.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792777342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IArJW2D7DC4NrWDvM238weKBxrWboHP+GmGljUSheNA=;
	b=Ba5ZY6+vPoKi7me6sxxpoU7AJwZwCdPXkDV38OJPOXu96datXxV1tQdPA/OTHuG7gpXZPK
	J0pxk/LDT79045vMgs/ijBCRbpDAySAX9p9qbXp0IKagMsrz7cQ3Lmf7bAxwSF2xqDRevs
	h0WTWc91O5APIo1Klz5anSlyz0mbGrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792777342;
	b=QyeKZWdfbHeOlWVPdk9EkoJsTKO/FWgGqxZ2jE4rtI/rAjLHLNsTT4gG6Px/z0BFyvT88B
	1yIU6q20PBYs2nkwrci7uFRosxB+bN9dYwN4bZO/+cHMNEsspsI9A8drmSwXnR1H33mvUL
	0F4GFQdVXaxm7q+Pt+Kl8bjfWXiJNv0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VE5P8aSC;
	spf=pass (imf10.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48e0d1c095dso809134f8f.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792777341; x=1793382141; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IArJW2D7DC4NrWDvM238weKBxrWboHP+GmGljUSheNA=;
        b=VE5P8aSCk4fm+OCEdjSAvVzIlJgHGZSyKojCwwp8x7E1vvcelQ/SWaZx5r0s108gh6
         ENOj7i17JrhMvAf0D0DkqGqVdQ4NXqJ906OURMcOgpJM7gV2s4VKwZ/GhfMU5MeoEl0Q
         ZGNNr+hMOcKfOYU0Rs5ZXFCweLQ7O6cKxrmAQMu64CPs+nFfI2WQMTb5JwD3SyU6GPyz
         9PWZW9dDtP9t/PcjgurwhFcCQ556tV4bqSRRshICIx67NAjWiNoZA3JqJ24bWGUXpiKl
         pPD4qZuD5YZ7Ij7fpeoam2M7vLr1RFya7FzxjKKrHqVJIy4OzI+oNGpx9DsLa0O/sjj5
         Su5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792777341; x=1793382141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IArJW2D7DC4NrWDvM238weKBxrWboHP+GmGljUSheNA=;
        b=HCv/SPsFLPzA5XtFu/nizxCWl72ndLxo4PsLuy0pJJXqCtGbnNKfT2w5/CQHXBUujJ
         d3i/ALpIi9a8CdaxYj9NK70w0xlWXu+YEg105UkBXKg9PNAaMyQsi+V7QhNzAGQskK/C
         kEa/k7zVTYAH8F2wU1h+YKs+28ZjejDh0HWdTwtcKAqWxPdEgras3BoKwrtg9T/YaFU5
         52ccBCCf1XFwiudKGKoZ1A7TboSGkjRLelUA9BvMMpxx5i7rUvdHJg32wm8b7S3kltvD
         +xVcKbffpexAD74M//qFIYJyZ7UzjjhT7DKTorlqDlVJoBnjZoLJwrtGriD1vwsdpXuv
         tYJw==
X-Forwarded-Encrypted: i=1; AKwUvBzxpqH/BfPMJVcnthSZOqGSiqephulPBdBXDc/xgSR/ZJHeH4RKqyM2roGx10lBDLmxKnSAfKs1FQ==@kvack.org
X-Gm-Message-State: AFq9FYJLqxgmIr2XKC+kIWqjRMJJffZHBs+gNmI1f89vGZ12+DVyY/Zs
	52GvBkAmiSMlXygGJcB3hRjRzJahO9Zj0Fe/wpW84PclNUf/xsv7rEIG
X-Gm-Gg: AYBFou0xc9k+a2jSAhRY48qRIH+fhYFt6KZllKqneoD/MMoJrbMqyUzkELA55jnJL4A
	xo1a8foCpbytBnO6ndYsBnGGBO8tiFQSvu2H+mMPCKSbZdaPncdzwF0G8AijZpy4nOE1nNuU2Ql
	oVRmeV6r8h0Ll+nHXdbTF9CgoScupY2ogg4nLtZPvv6QJv7g1Qr7RiFX7tGcQfrofJUeaanVVNw
	0JDGonvo8lfYA5CP7n0aMOr9I4PIqMoDqVKk3YdQ7rq0eizjaR2pRtLMm6747Rud43gF0IWxcUE
	oTmTx/rvm0S17aFTdNPe01tZNGftF1ifEruzRVtN+z7xVfksGgPlieRwnsX+Eql0MUDln+blPXr
	/OHn9D9EN4FTXm3ZAqdzmIrIrFvTZEiOzRvv4AEoY0X9cbUdQreIdizjX/0ZX8bNaHYx/dh3wWf
	HqGJQpV9D18B+A4QCf2L2Z0atZ0sjkE5aWEjr4iDuihPkZAO9HdHHYe0LvGdLMfDs65/eH9ihkj
	5ZZ/8uEW93MQmL/ra7DECIfoMHgfgQAXaT3aQq6AzSoxArAQ0aFU8bXmlBIP2YYE80dDJRRLBhb
	941dWE1Ch2jphVi9X8Hvj0vcRZiPp+5PoYHGhLrI49G/Tzs2/9WNnXAq+LnLJaozTUQjFIcz+Gf
	XNk3rDYDmjRVeO2jL
X-Received: by 2002:a05:6000:98e:b0:48d:ea67:79d4 with SMTP id ffacd0b85a97d-48e385af0d1mr4196895f8f.53.1792777340908;
        Fri, 23 Oct 2026 10:42:20 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3d40c182sm1118217f8f.34.2026.10.23.10.42.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Oct 2026 10:42:20 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH RFC v2 31/50] KVM: guest_memfd: Support getting PFNs for stage 2 from providers
Date: Fri, 23 Oct 2026 17:42:18 +0000
Message-ID: <20261023174218.54790-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022-gmem-alternative-providers-v2-31-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com> <20261022-gmem-alternative-providers-v2-31-5dd1dc6c660a@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87B84C0003
X-Stat-Signature: hfmbpphzsr765y4i3wyb5864sy6q587s
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792777342-893919
X-HE-Meta: U2FsdGVkX1+LJ2WcXed8MudG5njI13eCSi/ZEVbVym36DV/T5o9+Bafbj0q0Lmp0r/svnrBMODqiZNoOj4cPlVH3zFGc1o19M+YintzwtTVUJ5xDDXs1KVPwJeTzOGuvj0uzva6e5AilIAbXMhgrUYn9dcy6+FRA0YwoBIudYxi+/NJrdGaW14m0aVef1W2rTkTTV5l36s9J+bp5ZFXZWQDf2qveBamDjrTqDB1I6gKJ/Equw7vuCVvINVv8apjWk0RlKmnotpXnE3QyxWnND4VUEcBQNLIDng1aWtU8LXjYbtzxMDQEZ3/9218Bdb44a7s9wf4NhhopuIuvUpQ7UGeWFHRdNr1coqbY0k6+MJYUfeHay1UooQ5i81JCNLZNAvqlCfJvOn9TreW4chs2YT0L+FiXi09rGk/optDKwp4IqBFrEc6+wvSx6SWBeQGjobpQ14sM4MH2tUF7BwJV6fJLLu2Fi5o0cEMnVbB4C9Jjk6uV9oO8uwQlse6zsoAZoypmZkh19Q72ZMlh2tlwckoh7aTG/0igWXqg7uY+lUjkE1OmMbCjnZpOBCVM/JAOcaQ70TIQ1ZfOKCZ8rDU/u6H8JPlTQT0PxpXSWJvDs5QZu/iDcQaQxarkNRDGJfAZl3kfOhADmLy72Ub1M4aEd0jEU8Uj9pKNFzDxEwnSnHQsaycQAeSFoyUas/66b+78eEzab6lxOAZ5Hi6asKtn2mE4qhwdDEkqd4n1qZytxQeCdUhvmukGpjM5UA7Ukcuj+CqysiWGvSkKfFxbDdsZytYHoEN9AJhKt7f3rsPdph154VsmiKXstDBimzq+18TouGbYXH+uGOpsbqLl1H5/nlrYxzsc8aNWpUiS7nbRQ+Aiksvkj1rg8vsehydwsrBd73ABZS6QZ7inaV9NKiUxp1BzmpSenk57d8mD1G3W0+HGoXBMzUT0H1tMJ1zGavM78+R3yTzcIWoQ5ZsFaZ5
 WlU7Yf78
 qU1Rz0UNKlI7rPXtz52moVbnxf8D5zR6AyIcSjEN7aL1Ky850XvTO2W5eCMrAT95/Zyv/+O7v/te7extGfyntjGo+o6SBunwcbx+TJyR489hCgTPT959G03W9Kt+AF96CuEuSwNfty02BanidIN23LmuodulaCBKPr6lmffZ0EvpJB+7IqluZ62cSQrwuE9TElwklvF2N9Tb8AaFXX1SmVYNthnlSNoQk9ECxzFtpUaFhwX/p7I3k1GCutig9wIwMEjv318rbfAMOCgoxaPbd450xvbSNDnkY+giXE1m6/0Wz0VQNM33QeifW5CuzrlHeu23CkoHvLByMykJsNpEPNAFW4869QAy6/aiFJUpmUDz7d9VAXbU3gmMfksPrWtfF1pOI8wb+Kabzf2Ms1bWGTkQCiF5fzIiErofSz3ZpAkQc2ZDqiBjdz6ES7TDQMOINmvPvrujvBKyA97hmHLQTO3vTBtnmPLOBM64IXBwNKlg1qtgFR0THvXDHMselH+tAS3oBjesu7HoWoaiznBzC+Dj+S8kZL2y8hepm/emj+vfmKPNnpM6It8izc5fLbSeHC8iSbRrG2YPkD6Taqzmirshc7XT8Aee0o/UQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> +	if (kvm_gmem_is_pfn_mode(gi)) {
> +		r = gmem_provider_get_pfn(gi, index, pfn, max_order);
> +		if (r)
> +			return ERR_PTR(r);
> +		return NULL;
> +	}

The order goes from the provider to the fault handler unchecked. MPS
reports 0, but a provider with contiguous memory won't, and then a
fault can map a block that the gfn and pfn aren't aligned to, one that
mixes shared and private pages, or one that covers a page being revoked
or converted at the same time: only that page's gfn is marked as being
invalidated, so the fault doesn't retry.

Clamping the order in kvm_gmem_get_pfn() to an aligned block of uniform
attributes, and widening invalidations to the surrounding blocks, would
cover it.

Fred

