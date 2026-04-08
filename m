Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC40FF512F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 00:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB1E6B0088; Tue,  7 Apr 2026 20:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BAC6B0089; Tue,  7 Apr 2026 20:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A8E6B008A; Tue,  7 Apr 2026 20:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B38C26B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:30:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E287BC2E24
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:30:58 +0000 (UTC)
X-FDA: 84633508596.06.A470947
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 398D4C000F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:30:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lVOPp7Z6;
	spf=pass (imf28.hostedemail.com: domain of 3v6HVaQYKCK4gSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3v6HVaQYKCK4gSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775608257; a=rsa-sha256;
	cv=none;
	b=tHNJHpaLj+eatcnlTRiSrkfQkv+ip3oF+VjRdQYTa0+uTDrK5WtMmKGRvKovYGWGO8puns
	OTGG+t5OdjVyE2+WWO++ZGsq+bkMEYh/qatUqtJQZnmdgpilJrtF4ZL8M3Bt41D3gt7IHZ
	6SawoTgZHhHy9W4g9hKXu2zOqorqYwc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775608257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxNq84u8TlwsmIxTYoSXMB/rB8U2PkuGcR9W+hscQl8=;
	b=btC2LWz0PflHP0Yb9Yjfcg7lxFEzVkbXNqX63fRZT94SQEG0faEu0q9mknfWQz3yRaQ1NO
	4GuncYzbk5Wwwi0fTopUZY264XCSnULrc1Oi7FYWQSlkZZJe6ESNjUcdjpdKLSb5uRqjqT
	IrQIXqfp+oNzQO0bgdO++NZbxtsm1eY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lVOPp7Z6;
	spf=pass (imf28.hostedemail.com: domain of 3v6HVaQYKCK4gSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3v6HVaQYKCK4gSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c83bd48afso3185112b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 17:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775608256; x=1776213056; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yxNq84u8TlwsmIxTYoSXMB/rB8U2PkuGcR9W+hscQl8=;
        b=lVOPp7Z6djMgL2tOQ7u+avKhcHrgFArU48RQlKCrgjogA+x9zga7xB11mYcmFE6Cqo
         kqoHQIIOxSP2hp2vA8FRFalHgxIwWy5lQ8mUM3Css8qmT3dipegTjCJviC/intsAtmRn
         om7b8Vi6fzGO6GUn340xYFLnFnk53ZoIaZIH1LCHtcj8DcEI8klAR2TM/mve/1zM3yZ4
         shH1nUsHeDxXEda8lmVaO78EbP0HY2ugrhQf9RAt56Wt2Hc5SIwFuzryvGRtBJGVARI5
         Kt7ldg1eCul8UmIZGKKZdFq0ixspy2qynufSA35O9KgoDdeEtiHYxeboaF1kwDhA9uoD
         gCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775608256; x=1776213056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yxNq84u8TlwsmIxTYoSXMB/rB8U2PkuGcR9W+hscQl8=;
        b=DAaIGMtPRiQ4BrZU6ZmzKQkMHv3WAuG9wZp2JbGo4rkMdtCKLnlGqY1wKLR+F5fzqh
         fDJm2WX8PqQLL1a4z4+VW5LqeJ87oLTmxafJ2LfDKYDaj/6tnYzI9D/JNxxYEVzRbKSN
         PGUB5MorgfAqsMH73J6RQgVtEeIYZDXG4qcpx93+eJYywyjUH5dRrW1EpYIsm0eKzAR+
         Wv3Iuorq+Wf047kiLaxdrYNiY6A2W2Jy4zfcXEIhrrOLX0W2GFZSGyXENdxjqEL18DlZ
         QXUiFFWLOPtAbd33rUmY3ibHvDFb12oIT/ecPNlPo0H8W327I7hffGseuF1q1gWY1nAf
         ZOGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe3S3q/IJH3bdjsHVNsUTC7wxgiFVZBT9Til0uZz5EegbWK3n7Cm9K2UJvpmgDP7hgcn/mRLHLCw==@kvack.org
X-Gm-Message-State: AOJu0YxZaNp0lEcbncigbxHdT9x40vHWMLlvxKJEe0CoGmr+DPRSnkMi
	WJrJUXItiVASd1QPwHyXnvzw8xuUQS+jYzY5Bs/SQ3zlmG2ebfxidZWyAY5mW7UElT8z0Lw7G51
	iccNsGA==
X-Received: from pfff14.prod.google.com ([2002:a05:6a00:bd0e:b0:829:7f86:623])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:348e:b0:827:28ba:ff00
 with SMTP id d2e1a72fcca58-82d0da68e4amr19209230b3a.18.1775608255720; Tue, 07
 Apr 2026 17:30:55 -0700 (PDT)
Date: Tue, 7 Apr 2026 17:30:54 -0700
In-Reply-To: <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com> <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
Message-ID: <adWhvts20eePFo1p@google.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Michael Roth <michael.roth@amd.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 398D4C000F
X-Stat-Signature: 8x8m7661jtrry35tibdi1ck8jufm8c5x
X-HE-Tag: 1775608256-918506
X-HE-Meta: U2FsdGVkX1+XRQzERXFmd5+HPNjWH9eNr9QjNL8ZW6Xx9agvqbS1m2IxVwk4ZeGU1DUMMTJHgK64tBQcAT0pEUqNW/2+c3XYaetKwO2sF9ZT8FsfiA4yKLjm+aeCAMhz04YCfS8Z0dbiobGIyqt3hXpUWsvkvBrCcEnu9+Q+z96L+E5FBkgz1BZFNZnT665n6/A+tGEge/Uqby+nsmE4fuiAniKMV4A29JpoyjuCyjXYh6COuYyLDWGjjZPX+DaRO5Dc5YDOcC1supGQL5ZWb2VEx5BOYKI0ZkgHBUFI1DmOfwcDMRHRsUWsc9KOvFWzkW9iBMEPeM8rU4aF8DVJ6e9gGIka7TET12KhIwN57VFluuQ7FKOkFpqio8d1C7pSJBseKb5eZ60FqIzI4jSIt/IDgU4NMI4MbT+OJFgo6e2A7lJOOLmRDuD1F1C4RtEsXjTTgGZvWTRXYv5d8x5y75Es8e7fV5kgN6imm2XkYyu14Wwwqrk669kK6W1p6TLp4pRGXmj538WDq/5nZmMlZSqkN69ti7fa+DXOWn9aw9NCpnmXa9pirKXBxzZcg5QlWQSIzsVIvOF0AzZPQp8MJ8rU1cimzLXC2CtRRJfUq6RbcUvmTMrudPprZGgEI8q9LxGFRacbaXQHXeMBkH8ef0SOjJJQr8S5+3gNPMU3VddFkHb2/rq7d19p2Ey46W2FqCnIUt3dGmsF+3Wy6ZXs9O8h3ZvTs/jVRVeEESGCieV2Hqx4wEAuna44Ta7Gvl14qdX17QvFKHAiNrC0SBU0BP9yEy5zCqvrv97d9BPRuyswQJvHLoAgiTjNfrcnB1ouSnf2b+E4+zIwGFQGZeLz6FyVUbkvHWbidMhFDsYe0VQyToEwz+duW+xi8YHZZ3fcgRr0B+GHqRk2Mg+hK2HrPC/bpFB55UB67oYiLDLPqt9bdkLhAPZkCiRA3h8RClUA3aHuiwX5WDORnXJMI2v
 XkRmWfqq
 j2XVRstHxzG8hiCsvL6eq01a8gIhPxF04Iw19QtpHbaxrN/LzZNxt2gbUao+Ti6/7EeSKp8XzuTGTinaQVh9/KHuO33sT8l6AHLGShhPcpmzb5cM/94KzoSCLDrbF7tB2MM6MYcRMjpFXK+N/HxybYIXTC9fBHz3uPvtM9KPdrFh9wOiCDXCen+r6TyGzbDRzYmzHNdhqw3iTOMA4S9Xnv+lmw0R9yzfM2j06DG6t58EVjGx2V3P9X84P94+9/pVinolok3e8KJAgTANIdQOMrENoujfsUnWLhMF1KQg4a5QSzFB6jABezC7oBqKPD817bGzU6O6wy+K8OkKVMCeJD34Al3B2yzX+59f7Srnei4ri6JcNqqGcLfCbHHKQ0/CB7lUyV+J8fubBber8EeAWqjAY+idp7TjiycDcf71vPj46mFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026, Ackerley Tng wrote:
> Currently, in TDX's populate flow, KVM doesn't do any copying, it only
> instructs TDX to do the copying.

I disagree with this statement.  For all intents and purposes, the TDX-Module is
firmware.  If Intel had elected to implement TDX via XuCode, and presented it to
software as ISA (see SGX), then under the hood "firmware" would still be doing the
actual copy, but KVM would be execute some form of "copy" instruction.

Saying "KVM doesn't do any copying" is (very loosely) analogous to saying that
KVM doesn't copy anything when it does REP MOVSQ.  It wasn't me your honor, Intel's
string engine did it!

I don't think it changes anything in practice, but I don't want to treat TDX
SEAMCALLs (or SNP PSP commands) as something completely different than what we
usually think of as "hardware".

