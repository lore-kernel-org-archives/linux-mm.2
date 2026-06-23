Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A98D3CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FDAA6B0088; Mon, 22 Jun 2026 21:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEAF6B008C; Mon, 22 Jun 2026 21:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4A86B0093; Mon, 22 Jun 2026 21:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41E996B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:24:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B646D1C54F5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:24:53 +0000 (UTC)
X-FDA: 84909433266.25.D8E846E
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A622140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:24:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mRzitYB4;
	spf=pass (imf09.hostedemail.com: domain of 3YuA5agYKCGMTFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3YuA5agYKCGMTFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782177892;
	b=2YMVSKT7WW0fkvXvThbkPwKh2kbsiL+hATu4z3tDhLeWC5MJgry7SAvUnlS4lwExRV1KA/
	sHOMPIC6wB28QbH9ck5GwyMDQh/SNKeJTMJM4HGwq66mjG0GBhwrc6GR3YjuxCLxE8FODm
	M5/ofhN8oYyALPaijLacb90fc8pu8gE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782177892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP6zcq/A46NjpXBVqyG7Tuag7/oGP09m6JyCX4S5UME=;
	b=IxKWDdNcsDUWHQGH2xBebeiDQaHigGXTtbht9rU1NqHHGZU82FNyXoXJIUt6WqTtI0Saqi
	gtzhJlF1p7BXqoMNnHt4gLKtfBEDcgLjk1rGBEKdJaERgbmBfjbuFzOAx1rrunH6cGzXaa
	Qrdnp8mfkOw7mZPXWS7Z+hK+YLiqni4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mRzitYB4;
	spf=pass (imf09.hostedemail.com: domain of 3YuA5agYKCGMTFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3YuA5agYKCGMTFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36bbcd40642so3267420a91.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782177891; x=1782782691; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cP6zcq/A46NjpXBVqyG7Tuag7/oGP09m6JyCX4S5UME=;
        b=mRzitYB403hoivLjhK/Xbbmymk6rXX906Wso+JTGCLwMxDuVRp8+wmSML9eBny1jdS
         8kENJffER74c0M7PAIBf8KEHyF6iHxtyAQsjLdy1gZOgMF+c5RvNaYRzluwupIedZHyl
         nV/LQjAgenG7E9+PMQhnlEkcVSJKLxJyjmAe/kotSdpLwbY4Jwpx6zOiQpDWF5mNloiX
         bQunPjUO1JZAqf/3qtyAxe0jqwhLdvMB6dtFqGs8/e2N5EM0TDkJb5XxKshVhuSejQOj
         MGUfVtbku7kNm1SryylTm+SFOosDE0BaFvleXgCawYkHNLsPycd9ExCSs8MNXPS9wKUt
         Om+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782177891; x=1782782691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cP6zcq/A46NjpXBVqyG7Tuag7/oGP09m6JyCX4S5UME=;
        b=dAUoKBddor61S19V7aPA7e84IDKRwDQRsoDeWJkgiiSbj9s1Jetek6lhM9bcFX+zmP
         XaKMY3DnvH02eBfFZAtAFfmLGN+aSBEuTMPhBQAMsCXAi+YuT80zmLOoraKiwn4yFMgW
         OrwF28f3hpahhBGBHdQmWXvJ5d+FIBScgehGcdDX8vvJrwu1xuDhg789w34OpXuiwrvR
         1OYLv/KLzeh4TBPG3klpiQJpOub16BT57Qmog9rfIlh5U6D/rIA5iFxgzV0Yr6o+hvZv
         F4XodNmLhmXMsWF4U9EElsIO0fNYvmnsyXu61osV7LYvsyLTqQBffY8iB+bNQX633C3m
         0Lyw==
X-Forwarded-Encrypted: i=1; AHgh+RrgVMOoTGIfqdhDPQ+qzhEqgwsQMcJYFXzhjfZjxlqUtJNJvJ+FCLigrTYPVoj32Ess91igFRodiQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9qeyViM0pj/CNGwxzGKU1bI0HA6Skl4yufPgr1OjnwuCrLzth
	K1XDF3S0RNMA7pWXGh9geWR2yAiAHqrjRvyLZttmeLdCcEodeekE+L3bgkafWMG7e/aXclz4yOp
	XDZq1vA==
X-Received: from pjbbf6.prod.google.com ([2002:a17:90b:b06:b0:37d:8595:7a08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2707:b0:366:3ac:f730
 with SMTP id 98e67ed59e1d1-37d160feaa4mr19637357a91.25.1782177890287; Mon, 22
 Jun 2026 18:24:50 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:24:49 -0700
In-Reply-To: <CA+EHjTyj-JdW8H0ii2j3dayqnT2s3VV+brSG++p335=FGd2GXg@mail.gmail.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com> <CA+EHjTyj-JdW8H0ii2j3dayqnT2s3VV+brSG++p335=FGd2GXg@mail.gmail.com>
Message-ID: <ajngYb3aNTvtXkwl@google.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0A622140002
X-Stat-Signature: 6fgzwre7nnwy67g4eu7crxrgy78erfhr
X-HE-Tag: 1782177891-297940
X-HE-Meta: U2FsdGVkX1+1hbSaPl8bIo9YBJ3HCOVv0TjPXFat32g0i9EY0lN2v0dFPDAE9Hm8n5eZ1BZKgDPrIHce+5IkqYk1LtC+JUhJZSqsFO8nIBvy5LR4nzs38jTU6vgn81mqVcF+AdUjMNUDA7YwcK5ROLHWWg5bhM8JsKfjcFmrjgdBwvqMGk0msflcnpZNISsx9rhm9BxZQ2Sr3Qggg2y+xp8GOqgz+2xEk+5P2FpgUyqgZr/QaNBe/HDxSEG6uL3nluI03mwWVmK8PMje5FK95XGrkck8jV1j7zbEenNBicrF5n/mokiyFGA3HaYF9Gf1ABgUWPX/dQONGEStCXNA06n0Binavhc+wgiip89czToSSexhPEouZ9OVh2EKYAuAA2QMgUd3sNQaff8YMI+8y/uGFpZn9d2vgkjx37Ke1813myZ/9T41d3FdIrg0WtJtqVlUDvMTKfGpvYxmCvxXynuGNbOb5qtONFaErp0Z2GWqTT7WNwkXqTBCNSdDBShFOBi/uKo06tSmythAr87+MutoUgwKLAnHPTy4nnBaqctMaTsMwqHJvhw/Vgzw3SRwhIe/IlsjD8qRVu78Rok5u/4KYhCluALmUdb0c66AHN4kFmAOUVTivCtexz86dgzpM4EOVPjQ1kzP+9K5SK5U/Dl8eop4LtEfq6ySDrWgDefZGfcyae3ybsBRT9MqhgEm/fjGGXapgwbWzw0y6YgNsQgUsgi/wAN30gFT+2UZmKcJIjITERagVDYthxM1UV0ZhqW/8HvFoXHQu8WQJTOLCC53/aj5gfUsZEo3w29pVgnbxGworGfMhuDXu/8mjJNFCFkmKRsf+4Ash7xTQhK6qgrPPgSZAZKNJ9C0EzZL7SakNe18U13fZmhKoZUpv2zO2z1SqHiz9g1bQP4CuVh7mfYU7t66MDSFj1TlR/9ODYES3v0amLs9uT9Bo+4Yd7evpVBQowiDfDDW7T6e1gE
 zGCuTVrb
 m9fO/AUUEvsrblAOMfMr41vZGNQC71UcR/c22u1nnIgWoiXk6CsildsPX7irEERNIgNKAKfmqND/aKDJiYSKcQcSa42rttcGwKhWY8kv/5izntUTGkzGUfjpIUTYXbJv6ySKJUSG9pNY4ucDlrBj+x5MSagcxEt19gxsCpgJoTRJoivmOZAir2IMhOHNMKYrVo3smrUBR9RqDboeXnHjgciM3lRKUz9ZXacZYGLIbJ/Ksla4Qz+HY/ckZY1LGCR6mYmbTD9IYiNQY/pOjI+BkUpvBbN2axSRotPJvMC1HEe2CcBcUms9qB0jC5bkUbLcGkHzmcvdPxwa9hMlLGQOQ/VLbDC/Rv/+Lrw0KKIBdpPlbwwcPnuTRlzMVAfEv0JkWE4hDusMtLWwiKdKV2smzMT5Bqhqp8ChfZY3Z6YfJ3nNl0/d50q9JafkcJARaOmvZmN3sP3FsvfmSHjoKy9KwZMrqQh90cReh97Yo32CUcS54l0X1ofcFY8J5WOp3R1l/2ileqdBzuYPfvYaaZajMBdFFOjqK1CvgWU8QdHkkDozTGZlxpHsu9B5QcpqSpy65lJ2/Hf7MKUmnZWPRLbN1Thbmjo3xVVgl1xOTgVqvwdflG0udQdOBE/nMnG7BHQvbNq22
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026, Fuad Tabba wrote:
> nit: why does it have Sean's SoB?

Heh, I had the same question at first.  It's because I tweaked the module param
name to gmem_in_place_conversion, and so updated this patch and sent that version
to Ackerley off-list.  Ackerley's SoB really should come last in this case, even
though it creates a somewhat weird SoB chain given the author.

