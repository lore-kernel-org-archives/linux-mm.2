Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4419EC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 00:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F3B6B008C; Wed, 19 Aug 2026 20:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68846B0092; Wed, 19 Aug 2026 20:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C557C6B0095; Wed, 19 Aug 2026 20:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 925136B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:50:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A21B1C1A41
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:50:57 +0000 (UTC)
X-FDA: 85119818154.08.6079094
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C68CC000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:50:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dlTkXmbj;
	spf=pass (imf22.hostedemail.com: domain of 3bU-GagYKCIAwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3bU-GagYKCIAwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787187055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WeiRdUabSD1784CoNk4W8kzu7y18u8HhbtUkTWVxO9k=;
	b=ub8yzQL2qydcHVLZYBKV6coZXv47CglWSLDGUu3trH7VBwLAXKSHtqn6EZ42EPGrV23mKE
	BRIfvDMOevjPsBsJVsHn4buedScp7ZksM2LSQ/D4g9oI4YsnVpFjwGf0r3Y3VO62rxsTJF
	3WguQ96cuX/gYdWKHDoAl2r2XP+OhF0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dlTkXmbj;
	spf=pass (imf22.hostedemail.com: domain of 3bU-GagYKCIAwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3bU-GagYKCIAwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787187055;
	b=a1NeQJ1XXoZ3ReIYAH3g5+a7u1JVC5Gk/Y80P38hkMYAm1ukXk2suL0Zc7rqwvwfzi7fNE
	YmhNE73zeRHIFNQX6wxuozaZshODedTd/Cfl8xrIFqQxRS0eFamGrLEZQqeCfXIvI+Du5n
	vWqE+sSVAOBNrXJYo7gwG9mPMw40EPg=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ce8a76df2dso32400405ad.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787187054; x=1787791854; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WeiRdUabSD1784CoNk4W8kzu7y18u8HhbtUkTWVxO9k=;
        b=dlTkXmbjNCkTtvVxW5/n+YJ08XsD9sMUp7UoJaecy92+hDdv3NVDRG9SUmN5qE/dJV
         I/PQsmTQpmebMheDE94kCK0Cz+XTsLBaFtAwwrY1M9rTCCeQRRL9omA0IQZh7cjUeVm2
         9wHEwR72ImMyXmlJUh8MnHSR/yu+Jqqcx1K1lp3y/ztyZSVbYZ5uALw7zWVCBX6XSvKj
         ypyBv4ZGHLbtN9i1BH0Vjr774fssiCml+6bkCIF4FwcoJw+BJnp+swynq1VBwhcBA+jP
         AYniax3lBg6yJsOEP068CVUNIDxE9v1CZ1RocGGfm3IbjHDFkK5t6bqEYoLZN+N7P9yz
         ZpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787187054; x=1787791854;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WeiRdUabSD1784CoNk4W8kzu7y18u8HhbtUkTWVxO9k=;
        b=njGPT2ex0szYkuRdYn0CLl4cMP1hqCUHiimqyLtPu5BkcOh/mWSBAPT9P6424l28Dl
         qN2PNBAYXLzHU7YYRmQIsVZZk4DIpDFK9JGzyUJ3dYwg5cb8NmblAEssYZg65iyiFayx
         3qqYLbg7jQ3JLLqwJn8d/H253hXMMl9ymYV4ipcatFXWcfYPgYn4wOF22pYIERD18zSa
         g4q/ceUo1BX+BOJj8GEN2V9+iBCAfnkItYJMU98iPmjrHv0siPAPxL5RLTJWSlhT+/Y0
         N62i26j/IbYqNFPpOzH7DL1i7/MkTfD3scOb1u0hqoSSpS9IIypZfiHCIaRGCBMLA/5h
         +60A==
X-Forwarded-Encrypted: i=1; AHgh+RqF308OYs4rritul5bxok8I/Yj+EdNo+OBxBgdpiQAfyYeQQvfNnFlFyAwdJj5aWrxH+4WDYys17g==@kvack.org
X-Gm-Message-State: AFuF++mV4Gb7o+z+ll+xD7VXVz4Qu4VO+m1B8vdTO8qwXRTUJ9j1/c48
	bXAb6mdn1qu85nPyXnOrvRND1tKEmn65RigMrrLSbnfZ1yT+GfjP+ogYeexTp9Ulx3WXe7FS66K
	2O0B5uw==
X-Received: from plbke14.prod.google.com ([2002:a17:903:340e:b0:2d0:de7f:1ccb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f687:b0:2d3:2e86:647a
 with SMTP id d9443c01a7336-2d5fd6b24camr145291955ad.5.1787187053833; Wed, 19
 Aug 2026 17:50:53 -0700 (PDT)
Date: Wed, 19 Aug 2026 17:50:53 -0700
In-Reply-To: <CAEvNRgFd-6-QxR7w8SxPRa0UU+AAF7pDupLP8cPbQ9y3m=2QVw@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org> <annnrGR1noVuBkCc@google.com>
 <cc44c9d7-a6cd-40a5-9f68-4822fb9c9d0c@intel.com> <CAEvNRgFd-6-QxR7w8SxPRa0UU+AAF7pDupLP8cPbQ9y3m=2QVw@mail.gmail.com>
Message-ID: <aoZPbZZx2UVGZ-D1@google.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C68CC000A
X-Stat-Signature: 3cgqawt17ppjee85w5dwauufzy17tos5
X-Rspam-User: 
X-HE-Tag: 1787187055-780470
X-HE-Meta: U2FsdGVkX1+RlWnrh1u4ESg02edaq4n+Q5boVcJckl2NQUXsGcf9TYVnPuJW9r5uiYRRfhVuAuYuk7FXa5GFxul37uWne4rKuIWNFNyaOmiKi22dqudZexDwVKGjdn0rP/ZA0XyclbTu3kRbkC4jXzwZTl5VlX1R7cZ5iY3bjy+BDahodUKEslm8VgvErOqgVzO1g1iFvp9c75TWBxVtPqp2xXSfyFDjp0FF4XYAHNYcbAgftU6F+LuGH5zMFKfBfC9xvrhOO9HMsqtMwYkXKujzRZXNZl9aL47+qdVsokhh7MQ1VXurJYp9yO+01TefGxjvsIEr14IADZq1wfECMmUe/s2LXJCKrHArCAo0Zrf+Lwptq6pjq1mk2GlqPxaUwfcW+/ynIR1pj6fG9UrAcDnwzrNS8+oL/YTWYNGQ8RNArkGs8IsiuDNscjHpK4uWOlehp70QxqlCGTVbAWNbkvnbbWMqughTbrEESKl1uxaajPNj6zVKasFv/CFSTO3KZI0rtCef+Ium2JGtJ6WP6iHEnRIX/hZgaMU2yHo74hDu4SYSbc7u0Qvggar3h3M+I8xtgvS3XMm1C99kE+XAdlXnBz9QEVG3UjgEP/H0ZkWysxkO+g7c3hNd7Xo0eJQjz0TszHQGEh0/nCBSS3ifYKoHLLzOeQZK9W/oTiA9FqsQ11Iu3zKqSgFH0y34+1aItMt2ksvFhiVqeDQrkQEZbTSYjT7NArcKSp8XHHW58AI2dpU3iCsMK7LASHC4AX0UlOovOdObmCqe2NJ6XLBMwzPGkH/88xYxtn+hRlGV6cMEeioGksPFiD/YDW2grPOE9mAXsAeYHVAQQBloQM0SVfAkZgrj/9efow6majN6euMUBcjw5OjmbiOpd6bBPTymR1syIvi/JVQp3I9RCM98fzUCelO8hVnWkXptgEcyIbq6YXo5UlSjmld3Fmzot/Zebf3E5h915w9kj8vpxSa
 uJwxKFLv
 69kCKcCzOIJreyGIy4yOVB73wVIk0B8xUoOmEj+0LbTG7yg/HbojR9P9fz9/HTqdnBwtuCa1THc1pWFiWRsSbf81J+9BwvfoCg99nyKKcOwYqcDsxUBYmpUilmWa01A2sDuuFtD4wlpBnIXr4C28MS2KOBAF/33WW6ZDP3hhNzKl1N0HFNYG5lLlnfHgRJ9SMEBSTcy3swGr0Pea0ULIR6kDdLkNhtX5EPhXWDam/CzGV4uY10l2e8z6INN2ZG7XYitU8krQDDrrfwQQiLbs9WLYv/UAwzyKDnJ+PzbBlyU+b92jKZ+U+9aHEUmCYOYqQyrJWfKSdw9xD4l+ErIQnbgX93OW1bYwi/nCj6mzAYIpe3GFI/tVJsHerTndJSX9gXrWkBvsopYffTLft5RBI2x2d8raQt9rUrvARiVFs0BxKOMcWw6II1vMV8XhM8brmY/bE+Msxs64ZrhR81eTShIxM2gKlBnOXJIfD21tyghZxLiMEk++o6GV/SjtpWKVT8DvmhQXS2q97puovLVLhjU0OtiBqOiuigpMvhPcY3iRoZ4NML0xbBrDYLqhSZrl1s9N6bdWuhCeNmbavrhZ7XxsxRi5DynQNd3rf6Iwm/LNuV+QBsekBPi39qC313lFEY+FLzhI/joUAVSxmZcyx9rznspn+r1HFebU+Ou8gtM8Uu7/bRtMwalBxH8p9d3y52MNu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026, Ackerley Tng wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
> > On 8/10/2026 11:01 PM, Sean Christopherson wrote:
> >>> As mentioned in v9, the name is confusing.
> >>>
> >>> 	kvm_gmem_mem_is_private
> >>>
> >>> ?
> >> Ya, +1 to kvm_gmem_mem_is_private.
> >
> > So kvm_gmem_mem_is_private() calls kvm_gmem_is_private_mem()
> > internallly. Ummmm.
> 
> How about
> 
>   kvm_gmem_mem_is_private(kvm, gfn)
>   __gmem_mem_is_private(inode, index)  <== this is a static function
>                                            anyway, though it calls
>                                            kvm_gmem_get_attributes(inode, entry)

Hmm, what if we do:

	kvm_gmem_is_private_gfn(kvm, gfn)
	kvm_gmem_is_private_mem(inode, index)
	
And then to be consistent with the non-gmem code, slot in the rename you suggest
below:

  KVM: Rename memory attribute APIs to prepare for in-place gmem conversion
  <rename kvm_mem_is_private() => kvm_is_private_gfn()>
  KVM: Provide generic interface for checking memory private/shared status

I would also be a-ok with:

	kvm_gmem_is_private_mem(kvm, gfn)
	__kvm_gmem_is_private_mem(inode, index);

along with a kvm_mem_is_private() => kvm_is_private_mem() rename, though the more
I look at this, the more I prefer scoping the external API to a gfn.  Especially
for the guest_memfd code, where KVM needs to query shared vs. private without a
gfn.

I don't love kvm_gmem_mem_is_private(), it looks like a typo (though as above, I
do like it more than kvm_gmem_is_private()).

> or
> 
>   kvm_gmem_gfn_is_private(kvm, gfn)
>   kvm_gmem_is_private_mem(inode, index)
> 
>   (rename the vm stuff with the suffix gfn_is_private())
> 
> or (current, it is actually weird)
> 
>   kvm_gmem_mem_is_private(kvm, gfn)
>   kvm_gmem_is_private_mem(inode, index)
> 
> or
> 
>   kvm_gmem_mem_is_private(kvm, gfn)
>   kvm_gmem_index_is_private(inode, index)

