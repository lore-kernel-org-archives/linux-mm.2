Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5DF1C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281C96B007B; Mon, 10 Aug 2026 05:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232F46B008A; Mon, 10 Aug 2026 05:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FAC56B008C; Mon, 10 Aug 2026 05:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4A066B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:07:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60457A06EC
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:07:19 +0000 (UTC)
X-FDA: 85084780998.02.E087F8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B7E64000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:07:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6Q0AXKO;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786352837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaCqwnPU4MBwQ8WKfnRzGYLwwrlidVKqP1tcsF0Tq/M=;
	b=nWAlZ4+GQ+hQp3iBYR7H9ZEP6Iwt/+OW11WpMoiLExY2ZF2VkQ9G5n5N0kqXKFHE2pNJ5z
	gW4LJInLkHaSL5XfOI+TxKGwOY0QDFl1A4P0pIm7K9rXADkwUnfD8bA63xzh7lvTQiID7M
	osXeenoyYDIcESOCt43tP8jnAKmQJrY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786352837;
	b=ApUFoedyaA3a0Hl1T/GLzpBVDe+/MVzaP2ZiS403zTKZM09Jiw0g1JzMEMDdtuufHOoSHG
	ID6S5QqzQpf6ZwkCw6tH+SmLphgZfHkX8DBOLtOtJEZkUBIL0VhVp9WjewimVHrY889LhH
	ezjedXdao2I2gv4RH9tW07KbyVIgsSk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6Q0AXKO;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB602600B1;
	Mon, 10 Aug 2026 09:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315081F000E9;
	Mon, 10 Aug 2026 09:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786352836;
	bh=kaCqwnPU4MBwQ8WKfnRzGYLwwrlidVKqP1tcsF0Tq/M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R6Q0AXKO+pDbHy3YbM5oOGtGy7ATbPcXonSgqTFHS9yZtC88Ci0nN34FsVl+ABtU9
	 4/16utvmo+WPfo4hEU4dSNDqBb1vnAZjJIHrFc7N74FdJ8zzKoRzu7JWJHLs2HXft6
	 /rpMoQcx5QZrpavyEuASahw8umTEXWe8xFGwFHQwk5aHaSHBKLRA1F9uDJ776sOtqI
	 aLhM/b0Qd17X/DSF96vf3Pji3IgDpvrUye5wix97PvowCBgMGkx6phjq3JIeRZ7qhI
	 ZFb00Tc0+hZxWJCiyqEqIc5QC5oG2h9XNc9ckJdD3c8Gqh8myJLBqlX+5L8OHVX7wz
	 IfiBjL4l0oB9w==
Message-ID: <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org>
Date: Mon, 10 Aug 2026 11:06:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6B7E64000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: tgem3acw5ac89zz968fogkmcteos7re1
X-HE-Tag: 1786352837-518470
X-HE-Meta: U2FsdGVkX1+tBbnIbXEmaJfqBqt3hBMb/CqE+JVL15rHV0MWtAqyxehjvlzMaHXnud2v0Jwhk1iGEbGjQweGLrl2U1Nx/MkugYmlfIiLXJB/NwbCmWWZUrFT9ff7LBNSEyBczDEd4qKGoA+XDIVU0iZDUqp1jzHI+Qpj2GCQH0MekSATO8lTW7FCyd0/ZfBlXbUzh49clBe0f4gaXygqSRUzOWsYIPe/hwbtuOhD4wFR0UzCrCJIHzWqc2l0GkDn5/hiB3uBlP0WKgcNdTHCvZuRZ5dT3IxVezMDFO+q6VsJlXi+g4w6lH9BriHWnWROub+lmSU4GO60S1/qymsCCNpjf9XfZtEYev7e2eM6zuFtejCIUUQSpxw3nM6NapjtI4TlmkB8Qif+u9wPivOPKvpsyjIFnf7a7+YMRekTfDx+4gyPO4mXx/kLlwnmUG3cg7RmIZJEoglKm2Cc8YVPQ+TPRgFntudVDaH6FyeErd19JDy7RiAgXPb731Qr/q2CameMUqsXHAe+V58CaJ7PLuiDLE287nqn777sajnWoquKM1BiQVTd5l/5y1l9egm9G0mqMjDcZLQkUs4d4Jodcz3bLjU05yzmUdEgCWZFfo6eO25RM2uOKGoVxL7UUtnyaWeMk6gK6HUAo+84c7qDdyt8IQZKT2j+hJL6N4YErqlCLgTQp3PoREk3eU+tMiZf3HC+YD3T4cNJBAfxPJDg4uNcjB/4By07JJx2JSftFppnjRr3KQLZxEyxBEh3LS96V4+G/PAnwWu7OIWtgcaOimILf8BVdiRKaYT7RtZvnJJ5ArsXzbaMMUjTskA6WbxyW1lKICTg3lyHdKYMX99XviTdmqr8oRsKUlIq5IxdQ1iNK7OTn7czcOVyaflIzxpD8pE+3AqsW/t2NTQv+7Eq2tA/a3VA1D/lpAntK751xnRq13fVetleME3dJUsjcUbNwLrVrgknpOWxQZFODbg
 pzUKwOz4
 6BGeq/0hDn29s0CczcmGyXxPyI9l8llk9E1rFM+jITNI6asfbNhoDUQtQWSiRmBpO+bkNRS0okvp73LvUSvS4Ss1+PER4PxFbJt52bfvd9AH9Fvm7QaUjRjuv3/VMD8BUatyN1ja1QDSeyO/32McDojtFFjaNRTl+Xi/yqtfUKojldKZVI67EGMsbXogv4EJFoGmOeuvA1er4IAajgbLc4S6Y49+EjC8U6e56r5rbJq4AWSsQJ7QxNgQ5xI/4rgAen2AWUo/vgd02EyV2qMYVWmT94ToB1WOYRzmr+xhIOf5YZkqXfTU64JEVKibHXYgHZzMh2Mu6ESGZrYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Before conversion, a guest_memfd could be either all shared, or all

You mean "in-place conversion support" ?

> private, configured at creation time using the INIT_SHARED flag. Hence,
> when zapping pages from stage 2 page tables, guest_memfd can filter which
> to zap based on the initial shared/private state.
> 
> With conversion, guest_memfd tracks shared/private state on a per-page

Same here.

> level, so a range can contain both private and shared pages. Zap both
> private and shared pages for simplicity.
> 
> An alternative would be to iterate guest_memfd attributes and only zap both
> if shared and private pages exist within the range. Setting both the shared
> and private filters lets the zapping logic do that iteration instead.

I mean, we just want to zap anything that belongs to guest_memfd, independent of
shared vs. private, really?

IOW, it's not about shared vs. private, but really about zapping anything that
belongs to guest_memfd.

So, couldn't there just be a KVM_FILTER_GMEM thingy instead?

But I didn't quite digest how these filters are used.

I can see that kvm_gfn_range_filter_to_root_types() does some magic to them, but
I am not a KVM MMU expert to know what KVM_MIRROR_ROOTS would mean.

-- 
Cheers,

David

