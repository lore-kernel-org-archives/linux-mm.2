Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF578C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93DD6B02B0; Thu, 13 Aug 2026 14:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C636B02B1; Thu, 13 Aug 2026 14:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33566B02B6; Thu, 13 Aug 2026 14:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE096B02B0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:41:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AD6C1A0287
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:40:53 +0000 (UTC)
X-FDA: 85097112786.15.07D7902
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 44F2320005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:40:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hGkwbDBF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786646451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfCarHoh7qSi7mQScz0h/iOmFe8yy6xC72Pgonixm98=;
	b=rlHvKlsjUmn9LLQzZQXTec3m+1dBrcvWcH04vgKC/kavA8SHyy6mrUCPw9Pfi9XV+tqCYc
	pwJf0RCU+aJcK4yDGeWd5m9TGXpereeYgkr8YGxVkHKveVYhNNtOsvMWrXDAT/2i+2LySF
	vakV2MgVG4N7K5a2VOyuXDx0ZP3szrM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hGkwbDBF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786646451;
	b=pB5Qb884tNIhEByWNxy01wIByXMEDzY3m+3z64sEga7R74EwrOUdK+usLjCQooBOQCMgRi
	kkCPKi1iY+GWCIn9c+PgLohJIyQMRgTpl6u2gsbDQS2LdwKpevEvcwcU0oE6By8fZhUI2D
	ixgGw32DcwYpJVye4bdaurBN/Eh7ft8=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3900e39d935so164814a91.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:40:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786646450; cv=none;
        d=google.com; s=arc-20260327;
        b=gTzKFyjJcheb7rxj3W60cjirHv0uopKrFyTK+bAj9ZPdBbEdi5YGtuuvd4jDQb+tO4
         Esx4GCr0YXRO6T6JHccd4EIDJBDnc+0E1CfdeckUoVYAjP5c8K5kFAEbK+liiRMfGo+N
         220RejSenYQYxcoUXS6TPveFay7k9gHzbG5EbDoGnxrOJJlAPKM8YS9n7HzWPAeVhie8
         /zAst3wCPquWghX9A7V0eCc7j2DdgCdLVzREPn/SKBnvsOGDVsOt7GaBHiU5m0yQBpMF
         veE59FMCOTmNeiOBDKhBa/AsU+YZshKy5m5QtpqMd5JzuxJHDU9ng9CYkSTvlQiPfoJQ
         Zt3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=FfCarHoh7qSi7mQScz0h/iOmFe8yy6xC72Pgonixm98=;
        fh=M1uyp686ptGFX9qPnNHEhntLKqEQbK/6en6PzAzh51c=;
        b=Mx9d2/xK+YB0ZCnc7SIDjho5GBTPdwMaPfnw4IfvfW/X5HJsff56p/NrghUudnuaL8
         a+DCfL44HYOxWpNy6eVqz9xYNf885bQuVppPX/HS0kwR6jmTZA9f2mvV0CYpyJx64T+Z
         FKOw6xlB5M2Wgj3UqQFXwfJH5CADsx8HeRzH9tkAP+alAp8vvmuzOMtovpsc6uPAAJFJ
         f5wZ+tnwtPMXY+cwNXJi+tSCFWU/XuCpG3Jexji5Ez5XoeUZzJ0gEPYTIL4I6llaIWzy
         7VEL7oQNpG3SLIZtbGHo8/HBy6ilfpvjeib1ZSKzPq85Lg7KiPnd0faAplwoDGKxvqDb
         r5dQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786646450; x=1787251250; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FfCarHoh7qSi7mQScz0h/iOmFe8yy6xC72Pgonixm98=;
        b=hGkwbDBFvABCmPjHi1Woki7rmSc+IERAe79QJKOM2PfPwl1/qvKs8RFEDk50dMzNqW
         Zj+zamNhIHx/eleen5ZFgpn9kT8adYhfR3a+/nC7/hTO48FxE6lbtTxG3P32smPy//t+
         0Ms9plOBrRtKPREtfr1+xzVtC8+s5qN2t350Qb4Ivn76UkSkklHKTfu0ADi2z1VL4llO
         JRJLta8D2ZnArOHI+qC1ZCzaYWN6EdG2TD1nsdQkP1W/ZtD2w9EVlo2JPCqZ9txysL5q
         TbnZmJLepJCkjri6B6ayYjUOvmx3lTKjXw/mqyzvuDiT1NFdD2I0zJrfXzYkMtJIPxtJ
         Wxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786646450; x=1787251250;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FfCarHoh7qSi7mQScz0h/iOmFe8yy6xC72Pgonixm98=;
        b=ehsAwrQE6SdvIx/pv6Wy9bW+829g2Zi3vI3Bn7DKZMu7R/X3s0e7/slje/cRExJwNY
         7ZuUU89XyVjvOEgg6qzC3k0wFx0tDjocc52qcQ2S+aZOltZBRQypXxOl3iGIePPXhBhg
         S1gdm1Ed+wF2y6CBw4H88XgEKz1gL83CLLtD/w7RINIYkM18GN1wboYLidPtVT/E7akP
         ovceXva5Fte+05MorYQBjjvWO6BS1OkOMZTyE18/zXmDvyuk7zMytdshcvVtvviiZ80Y
         RHBK83j4f3QN5iZPFEv1MaQgCek2J1FlOjRedBsyGNzACzdkqywWOTT1c7GcD/ihhCKl
         +HEw==
X-Forwarded-Encrypted: i=1; AHgh+RrR1EMZBoZS+w2HC/4ao2QdEvmubNdhVS27YP+sWFI9xZaISMF9rmiJscCrqlWg1TpEWeeTr4Y84g==@kvack.org
X-Gm-Message-State: AOJu0YztZuKbMKpD6QtQzB2EkLv9/6HgediOYkQNvbSUTPSeN9gjKciL
	W4vXdKkBKGZD/jIJyz5hK0KWgIuXRFxW3zWdyTYiggFzFv+fOx31vvAGTsIn7f0FHTeZB4FwSsf
	MSxuk6eRO0T+F7o9VVFxgQfTJT0v71HnTacW5hzTP
X-Gm-Gg: AR+sD12RhLbauqDDAqsTDPqraH7KrY8CGlgjRfbC5+54xP8qe37IMCZLRlN4Reqx8dI
	M5AQXg6m3bHZOQyr4bG0q7hk+S6xntYD6g7reNE42y2iEpoP+sMt3/DBMiZzctTGoV5tZBMDsVx
	nFIC15lAwQtFPl4VK5h67VAryrZbxoHLn8Ko9OKignE60kbaom3v2xbGbE9y/+ZT6gFehssRpdq
	QaQT9iHjLv6saQFK7/+ELiZFf29Qnt+M3+JM4bZIVGGujZuz4AsN6utBMaMppICq1++6M73sDiA
	aYsJnMcthHBiBdxZvURMDZEB++22eO9nJHGkRCn9hWW6MYq8hcm0anub24w2KngX9DJui9qopwT
	qot87gFMyRPPNzIVYsiHMigSQp1U0Sqs=
X-Received: by 2002:a17:90b:1c03:b0:38e:2860:253f with SMTP id
 98e67ed59e1d1-3931e25f24fmr8532991a91.12.1786646449351; Thu, 13 Aug 2026
 11:40:49 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 11:40:48 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 11:40:48 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <cc44c9d7-a6cd-40a5-9f68-4822fb9c9d0c@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org> <annnrGR1noVuBkCc@google.com>
 <cc44c9d7-a6cd-40a5-9f68-4822fb9c9d0c@intel.com>
MIME-Version: 1.0
Date: Thu, 13 Aug 2026 11:40:48 -0700
X-Gm-Features: AUfX_mwbi2KKm_8JKoJYp71B4rnhRB-DpUSQbtCK9ZlqdFzmBXno1Ngt_qJ6KFA
Message-ID: <CAEvNRgFd-6-QxR7w8SxPRa0UU+AAF7pDupLP8cPbQ9y3m=2QVw@mail.gmail.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: w5sow8dmxr31m6pr1kusm5aj6t7atpoi
X-Rspamd-Queue-Id: 44F2320005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786646451-471819
X-HE-Meta: U2FsdGVkX198KLi2ODe8Uk9y7FoWofabjYOqXHbNGicxH03YIJQNq3eVainBP/o1VDJeLo3DOYYml4Y2oesPLvUdbS97AfnNCuvANivKL+bhQb/ofp6/7RYn0XoczU7WRRcDzZtOPbCv7REOnEQZC1xxUfdbf4bR+E7J0s2rGwIqRRCAqe1FVowbW1DKV2B6lt2ibnsupf9ebKdXRjB2oQW6Hiaaxoktgpxx5KgQzL/TlrANwVFRG/9FKU1Jf1Swsu8ZYcSdBGWzIetxk3QZKSQqezeWrK8siIYT4z/aelkEbPo1+JfJ1qunjWtrmNfzhI8v9CMZhxpT+H7nrT5Jn21JiNFUfph4PD5pk4c2/AVrau1XFwrujKLCUq+rSC0JojjDK2cUOE3d2ZIC+TCo0PKtFHpmnbRptsy/6Gw98+MxDnCE68LM1C520+HH/QOLkq4nQbS/Hj8lPxuubSNPEgYDbYpThxpyPq+X8bRmKGliIwXiHnN9ZVSZxk3c1mDFkt6EUBeq/iQgGmCVCKy0Gn06krmFXs62G22dEqoFKL2KwWa0m6CXA9n/kpIqUYN8v37Y0g/nqV8/GRqiC1EV9fR54+QNeIE6f1YOghHQDBn+qeHZcz/Kw5mZ5HBRg5tl3FVvRLq8rfC0JLbKKt87yIPu2w3faWllR1RdS8/k/Ae4CZe0EHBJ7O/Ta8NrVpYtWzWb2tfb7WREzAoaohLyuVaxzeHKOaNQektMI+3s8aVsMN+UCxp9nADdS4LWsDXw0M3pYdHUSC4BLOmq+vGj8HpQsoiaRkZl88NjO+qN2N/+v9mVAiqyedZ3F9wiFJN2tTMLSgiEvc/V07DbqPMg7FarkXSshrVrqQ+oC98SLUXNSMqSTB3aeMxW0Tegnh6CDk4LEP3tRVBn7+7dRd7r89b5KI3pxpP/D7TLHsDpeSrzFPhbKGcx5j/vG2fNS6xIdVuAV22b+cWpoHkQfOD
 gCwTBo+x
 nJbO6mvlS+sNae6XLw1GZeeS26e0S5qrP9yjaEcd4/xXkbRpvdVoV9h05ZAqd8uQ+rCImG255VV4I34IwFsxSLNADHmnKaULU9twsfZKcZOqYxoiX6vYbwpttc2GYVms8QSCEidoYJ1hmvusYb4RyBGjVCroxUuaklt58ikr8GBfs+imI2NylvnMXgTJhbZQyb/Qjh676NmN6JbZErasZGljUMijA/Am/0Y3k4o+LD/Lf3QBnj3fF6HwIiDIJuECTLkRdhmyuhqbHK2P5IQIrF6Otj/fkkkTv6hDTPvSMlD2O4Dx10CP+AOBt/aF5KIXG/VRZoyhkhBS/pBKKxeXF6rtBpMKfomJELP9rO+K+2WeTnEvCVkAWZFTv3ocQagERUaTc88jdFHYkIZLmBmvDCX6eyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 8/10/2026 11:01 PM, Sean Christopherson wrote:
>>> As mentioned in v9, the name is confusing.
>>>
>>> 	kvm_gmem_mem_is_private
>>>
>>> ?
>> Ya, +1 to kvm_gmem_mem_is_private.
>
> So kvm_gmem_mem_is_private() calls kvm_gmem_is_private_mem()
> internallly. Ummmm.

How about

  kvm_gmem_mem_is_private(kvm, gfn)
  __gmem_mem_is_private(inode, index)  <== this is a static function
                                           anyway, though it calls
                                           kvm_gmem_get_attributes(inode, entry)

or

  kvm_gmem_gfn_is_private(kvm, gfn)
  kvm_gmem_is_private_mem(inode, index)

  (rename the vm stuff with the suffix gfn_is_private())

or (current, it is actually weird)

  kvm_gmem_mem_is_private(kvm, gfn)
  kvm_gmem_is_private_mem(inode, index)

or

  kvm_gmem_mem_is_private(kvm, gfn)
  kvm_gmem_index_is_private(inode, index)

