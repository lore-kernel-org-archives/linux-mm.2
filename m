Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB1CC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 22:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAD76B007B; Thu, 30 Jul 2026 18:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A916B008A; Thu, 30 Jul 2026 18:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C534B6B008C; Thu, 30 Jul 2026 18:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 926D26B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:31:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16A1A1602AC
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:31:12 +0000 (UTC)
X-FDA: 85046889984.09.6FCBDE1
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0F50040009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:31:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K9JhGGeI;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785450670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NT7QpFfx9ePxD+EfhDliJc1nWKGrZODd+FSZ20/4RHU=;
	b=CYTosktfpQiMmK+p0h228XvYcwA7J1b376aBV6ESbSAVm+p2SdLSmCz4lhCu+kr1pRPyun
	u4h5E7Ho9n5quaJ8UV0P0Brqy6E4tpS4uroeeqWlyU5RtdS6zgqUjpdDVPloWo2iMUxcYq
	qrkgQCyZ1m9KoBSfHBiBqgQ1aBfX8O8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785450670;
	b=sPku5E+0rzqMrxiPfqxzTJ2DZNX+COmBraHZa0J5GYAoSFsawbXKJc252wNDIHvsnguAPo
	yugjA1eT69nDm/T8ZIZqLPb5wWZhH34Cmx+EV+HYSeFCvX8u6KAQ+/3cODW3l6vTbIeWsx
	DbziYj384Mz2YWkUWTFJHSJzFSGfMfQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K9JhGGeI;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e88b60121so302497a91.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:31:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785450669; cv=none;
        d=google.com; s=arc-20260327;
        b=QHn7DvHwxTdKwpw25KZVMeGr7eOQEhIvVD6rrXiZWJKqwQo6hy+Edz9sazgAejexR1
         jMgvwwL/B12GDI4Pe2V1cZAY5sNIVRAzKaf8TOTUjW0urhBZJAIAo6ZlwpoGCusUWv23
         c+yFsqjXhfw3IvesGJoY+TUuf55amtyvuMLpmzm9DQ37aOhmCCHNXjx588CopsFuFWF1
         1vc3Jn9tcYV7k+F0Zs51OhOkZcuPhOt3YTIh/eiS5OkpvNSfjBW8gSzAaHeCWFaHadRJ
         ozVKA5OqYxHtFIZcVv7TsrUA0o8OrZiY3qam8NIHDeRnxPDP9i3LGlv5b51/CQB7GWLZ
         dZqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=NT7QpFfx9ePxD+EfhDliJc1nWKGrZODd+FSZ20/4RHU=;
        fh=u0RHssjk0d4iV4UEBNVGzI6tIISG66d3loNqNOewoYo=;
        b=EAl62qeIpwawwUbAw1SmgC4NJv1rpuErZ/MsuQiDieQQ0K95+mfhHZn2GsIqcaHjMZ
         LG6UL9urQ4M2pu/fFcZbp6eyGIEC+bzmQeb6QUDOLagLTMIgfVq1ppciXeeit9JLiAm9
         r27Kaj70+VbCkuKZgC1DcyodZK+s0UphERhDcPwYeqlq4y9PZAiCf7Jdvj4B4Wm4qzvf
         zKVa+5oP3J2U2YQUSm8V7j/hsPLs0MeKcrIiuMhvk2bjb68tndk6Blx3KTLt/V0ooipA
         9bMaLnbm5E0fkorOmg/SS4r6wayLcTTPTHbYNDoOBQZ2e7ZFw1CET/KESNR4X2qxWueF
         yZhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785450669; x=1786055469; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NT7QpFfx9ePxD+EfhDliJc1nWKGrZODd+FSZ20/4RHU=;
        b=K9JhGGeIbAVYUmqWzgTcVGXeTkzwMjAexKVtKbDRz53MlMiyZHEy2KIY9ichv0jAGq
         6beOD0FP74jq2DuDQKGZIRvNdGsJE+IQK9ZwUooEqAJqHz6M/1B8HYeI+lF0xYyNUw4z
         QYelNfmSKYDtNAhNkXa3bbbTItlzcMyUAFm8naFcFfxsnS35oHoHfFEShD1iOSpHtsID
         tnnQ7nmUelhWSSuDlfliuTPCTtXW/r6fnDipQVhMN6zBjMeb/jecxIyreF9fqwj63j9k
         0t6waeF8FSe+bTRkkHCi/ch7oEtSHefrrk49Nhot/EzlIfDDAIwVyDAvTLHFYiWH30tI
         MOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785450669; x=1786055469;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NT7QpFfx9ePxD+EfhDliJc1nWKGrZODd+FSZ20/4RHU=;
        b=rtA84LHLPapGhR2/0h/tkUCH4UCO+Nftl/3bev8Nj5dQ0T9DobH05vYJKGlx3Pgwgk
         4jT+0TInwE3gheuorRbuKFTbXBjThaYc9tm1gpzGvaiNehN3XstvVR3DiJSpB0hiivMF
         oMuI7yy/3lcXwADemo3c18xulzw+ZBcugV/fJ5OL6zmwmJ2bP2EvwLIYzbwa6l77RIfu
         Vb/ilKAJkR3KC5+I8ntHQD1SxgBaMJYJdVa6zp9+09tvIG9JQxdf9QGTTMbCrTt7bhSg
         wRCp3I449rc6zlsqzBCE8ixg58QOJeejTMcls7jLF54PqxW7aBBN2Vq+ug2OeS+NT9uI
         4JUQ==
X-Forwarded-Encrypted: i=1; AHgh+RoU4vW2YSgT5vFwK9zLrZIs2M/IDVnMwyQhLeIu0mKPsxI7ZEp/A5/714JKk8JkTMFBft2nMUAVHQ==@kvack.org
X-Gm-Message-State: AOJu0Yyyq5n3U7eDHzRiScqg4WBlpjR4Kb/pVeiXJPaYO6z9AvF1l08Q
	uLiJSlmiagLesp5NYsOj4TnSXL39fIVNo7O01t0Xq3+d1Eb/1H46en0iJeIp8WXJx+WFq9xUXZI
	bq4Cm6oEj7nP9ZeavmPGEQHAj12b1Yt2N+Hne+/iM
X-Gm-Gg: AR+sD11ArKLUtlqKifPtbQhRc5lRa/j23zBiB+RFSoBU/lh7QJp+uH+eGIPFtJ0p5N9
	vZEVVQta9CdkQCQonOacLRfSdyDNonmhDlCTXFFOUhoJJ5hIXc0vmpCKPhBzTslzNCqGIfpAaHD
	6AStdfc9lPIO4tZ/MofbraM0qbUg9cmWbHC9sUE2deNSMraNdDsD9WNDuuEwlVYLFxHlNdhgn1k
	LkpwJBCM4JDScsjE8oW94Ymlp1ga7x3rHaw61vPXQ0Y+vsXbNd5yU4vLUs3/uHhJt3pK37nTlhG
	nhVc8tUOg8SRDeN0njrsoqFMqFTIyrEbH9HXYmBHZWB/kuh4cwAfPHYV/3UOnXyPd30B8/ibWMN
	yQONTVbYen2j8rUn/rSw+qSVh30JDYWZk8rYHlQOnoLnwzbs=
X-Received: by 2002:a17:90b:3c88:b0:38e:3fdc:62e5 with SMTP id
 98e67ed59e1d1-38f9bdb3885mr3385917a91.19.1785450668084; Thu, 30 Jul 2026
 15:31:08 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:31:07 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:31:06 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-13-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com> <20260728-gmem-inplace-conversion-v9-13-35f9aec2aed2@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 15:31:06 -0700
X-Gm-Features: AUfX_mwSrnPTxdnd5yQR4dz6uVJVHdsuk5_VpYazXm1_NpOUC6lIlEZN5j_ISHs
Message-ID: <CAEvNRgEscmPoW2f4UWHnPub_ycDg_QHRR-cCU5yL9HXu=G-OFQ@mail.gmail.com>
Subject: Re: [PATCH v9 13/41] KVM: guest_memfd: Return early if range already
 has requested attributes
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0F50040009
X-Stat-Signature: q4h1jtdep9imimq9ez3gobswn7x3c6nc
X-Rspam-User: 
X-HE-Tag: 1785450669-787358
X-HE-Meta: U2FsdGVkX19kTa20rHOhXtoLJtQTc3x7DXhQTEMmz09Dm2aqzpjAssZ+9y1yUNnucK8uYBjT8nY2zQrIUFoJ8edPzUgZZAP65gVaoW9SwiWe2HrRQj9C8RLuUcVSdi+zOeP7SuZE35/x68gB7/HSeqheswxnZqC1vkp97NB617QcePs73WMm+DABbts2UY1iyRG+pIz3X2yKQrqlvRFXXV07QJEz73+8Z9TNBvtWS9IZKS3rqYkBxX38plwxGWinPgTF5JxCyvQFDVnDwWgjKS72Ho50cqmPSCgv5Geu9o+PsTk3+79hpkKgwfa2QAGPQxGnj2i8PJ6ViCRSLCg6xj6FQrdnqVL0dvdWuUT3rpTMG0vaGj0bgNC9xYE0rLz3tQCfoVd0VJXu/j25nTGLaHF5k4ljImMt0rPTZN4ORCWuZg37M4YryxiW3LTbgaGFvxeQ4LjvKbonounxo140HAvMYTUDWEsm+5JD0DU+6vCrrvdq1D3UMatCvhVT8ImvVwHjPV/lh2TFgf4WgXKsyGotwYcDdHikbQYGOTMwGZTY4O/v2YPeMLdv0PAXXUk3ZtzoHGJ/GTlh2mtFHeptv0Db6qWJoiv2vZb2bTDmor7qVDQRG1cM+dEg6o6KQlFUSAQSjNmwTbg8Y/gSGW52svXufyyk74v9fHehkFzGLETIUTAk5zuCN/9DJhZ8uJICgh3vt6fG4bckRWfKlr1XXX1aPlhlSi2HarhJqM3vvKu2Fw47QhS/pD2kMQ53uY1kIUUU6zGNKpycH8bggW09mAdCgiMdSRi7PL8/OnSiyDHjF5azFS99t8rVXvwo2yQ/JCCuxgCwiOhdTybHFbnGpC3AMg8YcKpnktK6W5XzKwD509TyySgTPWfQQs82LPsdUH6AXcgKchX5TexXB2sVDPT6h1Wi/YlwsBZ7cyaI5WN6ziLOqZW2xqpd6Ry9GD3rpQlpqVKtraaDPdKRW2w
 0gwIZywF
 Rm6vStjHNrJMalbUOWWq5BEpB67BdO0ohwnlmydEIVLgT69hVXjfsNdz1/vLY+pEcdRIStHmBb7FhkimJnJarfVzOoXkcyWp6xCQ+1MtDgdEmb6k9x+sZz93Z+X+kXbv1iPc1zIOjnBzl5b7C8DUkr61/bD7C4gqX7DkEXkbXrS/G1KWwRjeRl3LRX86l8yDWF3xOcr3hRDL9K06d5XYRZct60IDwZ+ODHSDpF8b2dJJBDDHczApsdh8A+Sgrhbup42prJ2+Lfben++kJii8BedhOAb0QhkZ+7MQ0ZcumvMaNlE3Mlu7ba2orVirLzF40JKf7FULaVKFDFY2oANO971tRbuctw0zeZzOrvHoKJ7u6MVX/Xmu59Vcb2L5n0qxTME8nOE5AULXWKKpfjxztqR4UceVMagzZDV2eTgJ/Lgv94SrLJE40cRaiW3OYvu4jeE60qMFQsDiMtdgWaN39oOMOix43SfSrTr13rnRaADRcs4z9oaUeIQMfIwlG5OxLu2d3NdVWP1lxQfoYTkWAy8SQDeH7DmCoBPFLqec/C8kv1DiLGfMGCWqjZzsq5SCSlffITUOX2dF9wSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Ackerley Tng <ackerleytng@google.com>
>
> Extract a helper out of kvm_gmem_range_is_private() that checks that a
> range has given attributes.
>

This should have been

  Extract out a helper that checks that a range has given attributes.

kvm_gmem_range_is_private() was renamed to kvm_range_is_private() in
some earlier patch. Thanks Fuad!

> Optimize setting memory attributes by returning early if all pages in the
> requested range already has the requested attributes.
>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>
> [...snip...]
>

