Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE865CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C224D6B0088; Fri, 19 Jun 2026 08:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9E26B008A; Fri, 19 Jun 2026 08:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8F56B008C; Fri, 19 Jun 2026 08:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84C3E6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:51:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21235120421
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:51:54 +0000 (UTC)
X-FDA: 84896649348.26.5F28DA8
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1431E18000B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:51:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WRQR3g80;
	spf=pass (imf16.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=julianbraha@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781873512;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laROZbWnzE0hCDsDDd6yA+mJoystSAqNpvIVq0sPclE=;
	b=O/np1VDxRAsZdLoLUB4MzPo9ct7DidnvHnJPoWOiGGnAj/v8oiG4EF/wDjxuHdLXDg7aBy
	+bYBe3zR6Eb2xpnATOoX0UKht8IIY+oGLPMRJAqY9Sruy0Odv0TeCauWJU1Wj3cKWpFq+4
	xgB1jBSVgO3JM8Q7Scx3LvMcEEEzOYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781873512;
	b=xiUtE1WOR+KjCQ6h4NMJX3peSNm4f6YEDoDwQDegu90Ca+McaMdzgAP7hG1BO1Pi2ks5Qa
	FKC2foTZKcYHeFJ1n/VkgSOz/Aj/P/HUEaRsRVAgEG0Yu8Ht3EOo2djIPGbxwnyP7dVNc/
	hZweCNooNEbKqFDiAtSvJt2FGWs03VQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WRQR3g80;
	spf=pass (imf16.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=julianbraha@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso27193685e9.2
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781873510; x=1782478310; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=laROZbWnzE0hCDsDDd6yA+mJoystSAqNpvIVq0sPclE=;
        b=WRQR3g80iiim4BJkOhv70HtRO6gjZMt6Y5dilA5Hy0xwiuFqXKFRgKqfNaXBQkxTx+
         TG5ltiEZEsYVu3MqezbC990LvO8z1SumF81Tpt43Mq8TPsVCvLDWGWDRRgcESWtWfJMA
         43hBdiQAAKJUvQcsxlYceDFYW+Pc8RgXIuSPlrK5aFn7Be/Q0Ml3deYkTHCe3tZkYGI6
         Nb82SSoo8prR2IpdT9xTMeR12Ys6W1NTtBRgPzZE9ZwrIhxciuSL6igNOKmO23GIq+fG
         jZ8CAt6g6NRncwpEVRbHX5kyOtKA+GgB2DqHdtrvcMVLAy8uAxTzEw5hyo8C0E7DhgJX
         +SYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781873510; x=1782478310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laROZbWnzE0hCDsDDd6yA+mJoystSAqNpvIVq0sPclE=;
        b=VkpJKFIiUP+0ASRpwKh+aJzqdw4Jy1Uka6ibUvM4B8H0h789WatyLXPekcQ9oRBRCz
         mVkho6N3H9kMq5BxErP7b9eJSOhFaUcgtz95yZaRK9t1bMuMsy2HuULt/+GgfCxaPoB4
         CMPKXz7/B6VN4SK9VeiY/Jm+ZTreS7EQaMbaceCs+uY6VxhfE4QgcfBsI1JiRgRjz/Y5
         BEqN7c/9lsYDfGPyBec7EQMpU7wT+W71uzt9RyY3En7LY1O8O4nuU22yVZEqnLvCkn1t
         1VPaB+isjG9l5nZxkwvxuI5QKZH23OcgViJoSLiQ9k4Ss24Hi4vStjGvtf+d8oFIGfKv
         LShQ==
X-Forwarded-Encrypted: i=1; AFNElJ9pz+PilPbDfR40MASFOmQxUUxmsuvHCU8/9DuwQnaXmzRGjqme1Vab/3OZuaqeBoe1F2Q1zZhDmA==@kvack.org
X-Gm-Message-State: AOJu0YxwmcXhKATlauic23QUPs7tjbtbWuERFpO7CYyKvvb6cg+cNo/c
	bGIsMocm79rOEnSQCdHaqqa/I1hFu8fcEtbqnht3fQGxVGCJsfZHdwE4
X-Gm-Gg: AfdE7cmRMmokCuW6iQ9/Kfh//WDhmrBs4kZBV8z5/hwLu/YTjDEF92+m91uTX6OXgo1
	kxth/Zc7iz/x0Lzgv53Os1IHz3NeTmv1gWLHlKH6Vd8t1v8dk0lYOwWuiuXiqIb161FW9sPc/JD
	cAuOYSiPisIYoAAZD5yFq0ZEinwrBmXNkDo42DaRdCcnrxLOERAkTwxJ8KYTVjV2r8w6iFVrl/2
	jFd2JE3ft7n+JunyZMCrMETAyddPllm3K719hNopuXXZdV3rx3bSrKQQMeRE8Ci4MuWEAMXy2bv
	/ezjioe1UmCRDPSgH1A+mhfXIIvORDDIKeIE91ZpnN0LbHLm7Z6rd0FrmMJpDdfDkEMUwJYuSHH
	7Tnsn5ZQyDoTDsYW8EzW5HDp08uXDj58NwTCN7nw7AmEqfLDa2Gr/V4JXJWrTqnMUtlouPPfJ7w
	hkQwCoBxr3R9S6BrgqhioYMdMjB6AJqcYnepkIQzWDhVYiAAw6f44ouakJ8loejy1uJ7te++CuK
	4reijA=
X-Received: by 2002:a05:600c:8b10:b0:490:b00c:8e6a with SMTP id 5b1f17b1804b1-4923f58988dmr65892965e9.28.1781873510164;
        Fri, 19 Jun 2026 05:51:50 -0700 (PDT)
Received: from [10.128.11.42] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650c115fd8sm7984157f8f.35.2026.06.19.05.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2026 05:51:48 -0700 (PDT)
Message-ID: <8e53844c-f2f8-4a4b-bf72-f3140c170d43@gmail.com>
Date: Fri, 19 Jun 2026 13:51:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/46] KVM: Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 selectable
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1431E18000B
X-Stat-Signature: d8xk36uwicoe17dh3hims9q83wbozthz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781873511-984888
X-HE-Meta: U2FsdGVkX1/RwS/RDpe7ngYk/NHXS5cfZKwH2+/xRkgjTJoJ8+kkX9kcU8ga5YMnJaCk0pmSxN/w0bcSSfuLkefa33dxVig8zZb+t6OXNhDllHM3a+eaXJNhEpKJJNQHqLvdbIx/JabddBbaj56qUfGkNt3Wf6rIY80VI3fgjt4DFYOb8dD3+WDpDL0rGsxASJqaqjY/9VGs3qJqj0aQeKKvSPleRQliyeQz/zDdcJCRKNIdjl37xCG7r+/UL/IDqp351xIbj6yaG9VZka3tz7XydbW5P2B0vmuSSrnK3pHq1OhASBz8CrrrBkgmwqOfAjK4mNxK9w4zbk9UuB7Q/ZLQcYJNFvH0bZ1qW6FegaXDBfwv7Y4K3tGe0obyT7jTAA5bjNOg8m63QIT+viqoKmvMNzQUYKe5308jAw+GvWKnRR3mbLT8MwarZKGJkeI53C2nNK3KDqAM/T3QacRAzwKTr8+1myDwGJquqQnrEFm6Og5+uGhct5ca9uwmWkggqtK9unA3tlPnuodwUtu6xIz5vNyoX68lG+6CyXeV90k28Ti45/5GMwwDMZw6nSMDG0P1jfu4UmLpYVmX05IlaAohibcW+vNwrzYvZ32I1q8m/HWOgse/j3F62un1Ehl5OgbWnm4gKGo3DwZacGuRF52DUldd/7Pt4SRRbj2ZY0H0SG2RY7SlBHtneGgxr5hQggqskx7AxFmyO7/ZABXOrTLUGD+WuwYh6lYffCoIz4ciMswYEm7lmKFa0ysa5C/XEseFc1bk5n0zVOXeEj/On/r+Fn/DgVp5dbM28gw7g5NW9evt6TF8hXNGn87HS0f7HQ9dR3MWgzfrcl26oyyA5KZPWoGsjoHbhkjGAQlgNn5HvKjAAu7/eEjtuuDD2EmRWdqfNowf7ZFg69ZhJLSX4srnJFNyQPMSILp0C7B+gJjys8zcSLrPXTMzxpzcutZASzz0IMt42sn2BG7tEH9
 h/7Va6MK
 gImJeUJDvByKbdvP++FF5iK95MybgTcLwGycD57+czidlb5wW2PFZH4LFROFWvFPC+Zg0j+8ThBGBL+/APm+XWN2JM7aocdP7WtHSvYtw3NPpNmAHv2ZSozbr7k7JeZthWCTiqUzuNDoAfyYzLIHWfuwWloUc6m6eNRPzWRJOzoOMzdIa4B/uM1zK0G4/Lo2s59MHNVllIUexXRwiXlnm9WPOoqwutoqEpDLk1YLsdr4lfeMAcNDWar6Uj0fKIleAZR15YeQ21xicnMLDjxsXYND4A3dStsO3PFCTEo8StcBvivvJVTMWK/O+RaofDjRAcCRNyh7LTRsTJt4PTVRNetgsw6/dYd78+hLNaPdK/kI8hpV67avBzmlGXRbRgZH6PVyDDhKkjic2tlgfMCnplfluuVd2kd1qunxq0eo9XZ8tXw0edLEHkUFCyoA2Jro7gIEv4R4ND2Iy74rFWwIX3kj0xyA0rfCS7GcnZAnn1BEPXE1QdVU4G89Qd/gc4bANx2Y9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

On 6/19/26 01:31, Ackerley Tng via B4 Relay wrote:

>  config KVM_VM_MEMORY_ATTRIBUTES
> -	bool
> +	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
> +	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"

Sorry for the style nitpick, but could you keep the type and prompt as
the first attribute in the Kconfig option definition (like the other
options do)?

- Julian Braha

