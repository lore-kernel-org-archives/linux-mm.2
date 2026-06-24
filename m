Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157A1CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 22:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23EA6B0005; Wed, 24 Jun 2026 18:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC016B0088; Wed, 24 Jun 2026 18:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D0E6B008A; Wed, 24 Jun 2026 18:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 882C06B0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:25:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF2E51404EE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:25:49 +0000 (UTC)
X-FDA: 84916239618.16.746DA2A
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id E9E8F4000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:25:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QNhmJw0j;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782339947;
	b=kU++WEwxJTBlNl4M9SpAZ5QD7WGTXKcpZDzTHCVKl+reTzPvSnohpFZgDDjn3qWtZNmI9L
	oYSPqTg4NYBo+M4ATiy5XWDI7r/J+xaBC4bYb0g4miEcA+blaBaFGQAmGKvO/u58bYn2D3
	QYb20/VH+YhnqkfmRqHTspKVASK87mA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782339947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RU91htVYuTl4zBdXuu6mQj5pUyKWdyfCeWXJbQ/VXGM=;
	b=sWYffw3s9UrY0c4I0IG1nbHPlk07g/oBdIc4HlvF50TMloxdZSCHgPMUNfrCBklDE6utis
	TZFGLy0jXnYY3JSyNTvdc1Hg+aDUjQs42FZ7XYP/PqsUMeveQGplSD/Ww9mQKHGieqYiuo
	KH8IaVswIae1gJY/3oT/aV3xkpG76wo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QNhmJw0j;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1363fe80fe8so3137608c88.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:25:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782339947; cv=none;
        d=google.com; s=arc-20240605;
        b=EY+6gNyz9GpXKck/pEo5Y+inTRspT6klT7rLqFyRwNgEUyrH7ffKsb5qv6gJxINcD2
         6H4Wyanv0iQ8SkQOKSVas8o3IwczWcTW8QciQjfRmLwYYVD4nKnCJwhqhpyuqcy7B/QU
         6rD2R49L+KH1wsB2R1vaVeatejGry5Nr6xMycs4lV3KbqEzCTueaK0TVtJuEj57eXyxC
         cqEuV8njtqTou44xAbEN8m/S7YhLXVo03gajd++bR4hHGUvu3gHDBpMkdmJVCgFeT7TH
         y1Xp6sAeOJdgUYoBWQe2fPEvsZL7ZH6UCSpGMPARJOVc7hh8plKrEJtFXzAB4nXeZOxV
         GZyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=RU91htVYuTl4zBdXuu6mQj5pUyKWdyfCeWXJbQ/VXGM=;
        fh=GQ5K2jEk9UXksRjcJl0KPndN9pDRJqVmvgpv6Ddngu0=;
        b=c4TZEcKhztB7Rl9y++9Ql+xw03h/545f32OCRq8zYvkE9K+oOBCSBp23WUu1XPkxLm
         wA65urzZgVbfKLsyZBIOvzFcIW82DU4qGLXPibF9frSr6AtTwGeg+LQTzErkru5bzNAw
         lx+i1BIVx1bQhUTXKeZx+BY16HHtUfyg7WCMoqqTygkiFKIVYWrvPEvb+Y6bUpynVPjA
         xnYcs58OU0jVBntrNAmoVjqcINCYr8FgTJ7MB52jTvwaeIPu7r2TPo3oP+ExI7pL5TMq
         M3ay5UwzuDnLkCrzctjb9wsYrUpJIoRoV8Cuaw17eCbNPS3Y3lzllvpbUUuBOa7qiNlF
         Q8wA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782339947; x=1782944747; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=RU91htVYuTl4zBdXuu6mQj5pUyKWdyfCeWXJbQ/VXGM=;
        b=QNhmJw0j64rAjq+eF2l8K6bV/Td0pfZnO1G1VqwtWyp51uYBEwktJL45Se285ELOdH
         X9PE4/KG+0FLeICkNxebw/SikRoRz+l1W2TjSsvCmsiUyFV92nZ58d4XcohN1nMWBHfE
         y2rj0ncsW49gaoEwVh2CP2y4Cert8OCPw+verPcTs6ci8B0bhC1U3YhZH8Sd95rsdcWC
         YG7b78ghf2GtYXHVkYSNTxcbFkFjyooNFtUlYikT3ae65akWtvLdFUg2moUcjbqmBnXC
         W1Ztyz+guPCPmUZPeJlumW10htWARylUFr1xDa0OnwtKwxaWMPd5jQZXwPrYfHz1i3ZP
         SFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782339947; x=1782944747;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RU91htVYuTl4zBdXuu6mQj5pUyKWdyfCeWXJbQ/VXGM=;
        b=Z1/Gbw/NCev2WTs2S2VkdeqofwOut3Miau+xwN6kPFkDp6eVN1daGnZqeO6N0r/Vni
         8YZp0YOqcQXOdKC/PZHCafDYkSOzyon4z5f9GnXrN/uQ5YOq8W0euH9GMMoY4na2IxAk
         k/mSDQGRnrg6ThnyGrCkjyJKcS6P4PUZl7UvDW9f1O1aaSPJGMgyBe8Rk2DxIqh4hXRK
         rnhJKiMoVtwpXeTLK2ov/SqashStg/KK7E89Z1JmkkZ8GHXPFbhCf9z0iS1QY2SEaI9B
         eBDgwmzZwM4teHKNcwpU3WfZBzx+oUlCxf5GQb9DRKHQ1dZlem3PppCJbFb73F35xOo+
         lflw==
X-Forwarded-Encrypted: i=1; AFNElJ+vebOBoo1CPvpNAR9zJW5g95WN5vueko8/ExA9eQ/ZttMelzZ0Zc/fXJlnxxsEdUd0+2d2B357dw==@kvack.org
X-Gm-Message-State: AOJu0YxtA+oy1DN77bZXaNAHMpzN5oK/4cJyg/rMfcS5FU69ZA0UBmfh
	lA0QmWwBPYBgY6YzxRvv1346MyQDs/Dw6RzAI/BwZHn1E1h9MSzAHdsX2bjtK5RthJhS/xZsx/3
	tM9hD0rHypN+I8nKU0jEp2G5OT/GpNJr/ACl8WB62
X-Gm-Gg: AfdE7cmOQRSjc3Ac8PDKevBhjzVavI0+ZqDLquO/ob+W1ow5flUfdv5w6rIVoNV5+BV
	jKE+EvTcQ5HAOfOwUeYx1aqLt84/ChrbAwNfW/mo1bgTDm9wVoujSusBFDVgM5DTcWMyGEP78Mi
	qO8qvfeDWsVb1jM3kSp67nMuVn+STWvL2MAnaPLTgBcdy4MOISja+hjPNciCuWcYyVelDD1P5u3
	8SO9iSLJaHw1NCtp2DmIdvkOCGkrTdxQaklzGjdIJGFt34p+uBTERIDhG6Lor+7z8cmjWeqUNY7
	fS/hBq6hkdp9pnXUmtIFGW9y7qnpjXELJ+U7r9sdubahRDXTlBhtmchTnyJE3c6WmnLj2w==
X-Received: by 2002:a05:7022:906:b0:137:e6a9:b998 with SMTP id
 a92af1059eb24-139d0c99607mr4114854c88.31.1782339945380; Wed, 24 Jun 2026
 15:25:45 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 15:25:44 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 15:25:44 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajwMYCSrPlxg-Fok@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com> <ajwMYCSrPlxg-Fok@google.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 15:25:44 -0700
X-Gm-Features: AVVi8CexQH0jh1eCpdBx_tPh-SkjHNyZ1QVX7X8uuwzX2_PG5elQvyIsXuHuijg
Message-ID: <CAEvNRgE8HZDOnexMJeim6TjmxGG1AUXFY2+HH1YyKB=aM6D-DQ@mail.gmail.com>
Subject: Re: [PATCH v8 18/46] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9E8F4000B
X-Stat-Signature: mojk75hqkd1d7y5s4e7odbquoqgg6d18
X-HE-Tag: 1782339947-856728
X-HE-Meta: U2FsdGVkX19tQwvHuaJn9uNkWPLY9A9aBoWyi1eRnuRI31QjKDtWdppZy2Yio0FxaHUibpeqHHYP+vqbhukR/hYHbXzEZiEBWjbV6OTp7S2nPhnxXagNS/1hof93gAftrseElotyLuh6AIzkalun3kSA4FqYRrWfO4CQDOJOcdgifsbG41aicy0HU8kF9tZCrw8wk74QiRGIwoTt1xL8HBKDd43NkaO+OtG58rXJkrqfP+Nt7ZD1+qhKD+KLcEUrxOxLs+wodJ1q2aYvif8RL/y1S4lOPtaL5ytuaPbxBeAbgGPeUuydVgFyQa/tzIgTdNkjOS92rcW37w0UeWrhPrwqgEtovSN6yExTnyrzVLVPo+MDJwLC61+vE48urfCrbAK9Dx1XEoSDChf2Pv3zJsHx/scBuCZEEhFeH6XlGs/N35tzRdWvDmq8pRobLr+DlkbHD6LvvMUR9qn2Aywr8dVNBfflPokeCBScVHIUGj14ygEvFltlDQ0qdZK12c9eGJoRc2MrkPGl5AZOwkyfd5lzMAkuNHgob4wNvHExaRP1KfO87wSQs4+SuA+3tXhPuhMDibwe5cPXaOl8VI7/xhC5M0Tq49dOwlbIc6KydLj7zGwjTL6WS1sv8rNNYHi+ynSDvykaXIuverZXXSCxPqeai4Ry/IWXaxJ2FpIh9m3umz8qRE8v/LVHj2LEEIfiKbByBC56Oe96h00muLX95KvAQk/s2nCTxtmivSnlAGVIBSnUukprrQXxflYW18FSQ+WLoNPUGqCM3O3xSixjHSEb6w19g7gm5wNGwRi7iyYKkRDZGuukQXjv+JX/gIzPuQ28UKgATzqlGnCnN6oDHuYhRG9oIXTQIBE3bJ8dF7RjKgUbDJ6/onIvT7IR0sgrugDYhK1yXo/Gxb8Zg+PBR6dJ7NsStyLsVBGsptv59Ai1AdXdZi8rVD+TRC5LJIprCm2z3LdgS8zkMxP51Z5
 RDqIB6ai
 BKB1MdzwyEWprNT+m6DWcDjU6b4NDgvpty8bdP4CqmV7/fPbiksvaMJCm2DX0Sk4q4XlD8GfhrkXV6iiWnIHWSpkrHT3PWZCNU1nm5CHAo3O+jW46pFUdhCe62Ulbf+3zXy9YuO1nxI+FkyXNOxF4cXooUKM8liAqyoXfmhbuqlMR3IShkihPPNBfMY2StWrJcBPiKCGR61fQsMGlOYAPpFJuYXokpyIfljmIqiyioQhbFZtyc6PK0P3OvCVw9PKNXTdMbrdwpEg6gz4ZXCrqrkvSuqKuwpS5TnNrUR3pEhefRbnJ5V4rcS8cy8ed8nFSPWMC5Ntok/weyO6pku1NiMGTvflGeiR+cntezMGSm3LlRPwPn7s4yLiH6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jun 18, 2026, Ackerley Tng wrote:
>> When checking if a guest_memfd folio is safe for conversion, its refcount
>> is examined. A folio may be present in a per-CPU lru_add fbatch, which
>> temporarily increases its refcount.
>
> Under what circumstances does this happen,

It happened 100% of the time in selftests. Perhaps it's because in the
selftests the pages are almost always freshly allocated and so the
lru_add fbatch isn't full yet? (and that the host isn't super busy so
lru_add fbatch doesn't get drained yet).

I've not tested without this beyond selftests.

I don't think we can depend on workloads to drain the lru_add fbatch?

> and what alternatives are there for
> userspace to work around the issue?

The thing is, the refcounts don't come with a label of who added the
refcount so we can't really return a different error for lru_add fbatch
presence. All folios get added to the lru_add fbatch even if they're
unevictable and eventually not participate in LRU.

We could make userspace try fadvise(POSIX_FADV_DONTNEED)? I think that
has other problems, and this kind of makes userspace have one more user
to guess. Userspace already needs to check if the page is pinned for
DMA, and if it's not pinned for DMA, userspace already needs to retry
because of other possible kernel users...

