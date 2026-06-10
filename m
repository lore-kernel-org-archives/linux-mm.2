Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D7CCD8C90
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 17:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D256B0005; Wed, 10 Jun 2026 13:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B286B0088; Wed, 10 Jun 2026 13:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B4D6B008C; Wed, 10 Jun 2026 13:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8848C6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:49:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9989D1A0264
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:49:15 +0000 (UTC)
X-FDA: 84864739470.22.1DCAEAA
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 87D5480003
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:49:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mfx0qQvV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781113753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46dTS54fJkFDX+n3fNAtP/BR3hdg+QzeIr8BMTbVi98=;
	b=8NWOcV7eXAInzxmQeEmYPjDqlzF8ED1OjTl5+zN89XSjtU62j80Jhcn2u2uEemCDqQwFf4
	QrGdpVx/Lhsw303/xzU2gYn6D0y07A13Pr4D7I7qysRlvW92Rsmw1p1alOPX9+eQkkEU48
	RraEgsyZZPe6QXNFW26sT2SYf6wIfJc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mfx0qQvV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781113753;
	b=zxdFzPeFUUs1UHQ8kfhaT7l0yOblho0NjiX5b8B+9WEyHRqUij1p/hwD7R6lfAGYAKHb/R
	veOgEZYUdp2/Sqi+Uf4C6wXYiyBssW8464T1Nfsthwc69IBIGUQmJUc8XzV4rDiyIvt5fq
	Wo21OZc1NgCKUiSryf81jpbVABuEpfU=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-13809ed8fbeso1360928c88.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:49:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781113752; cv=none;
        d=google.com; s=arc-20240605;
        b=IhPpx0XdoyCW0lxieO0bqrpY4PCEJpgsimecN/Ut8iB7Bg0ocks46hpiI+Q22pf15K
         wWONxOcRCLRcrAf5RhCnPHukGFCCZ0qnWeebhTiIgugT7NZJqG7BfbYZZgnPTqxzhng8
         /BMH1J8qA2Ie3Aglf3Hls3c04uMcdNjrdmeHyLCFOnVvKTvbPdAFnVHUDOdh6rKwnH7J
         XtavOrHDFzhJl5eNVAq+7D5p2Y9GQ+p8zbUedn/PjtKBiZM0sY4QJj8szzMAIEmVesY+
         7wbTRAXQt7aPuL5p/sRRkT23W1U8/Dl0F3/NHOkP9JGMZSC3NgoZsNGIx8X/rwDaJg0e
         K5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=46dTS54fJkFDX+n3fNAtP/BR3hdg+QzeIr8BMTbVi98=;
        fh=rn56rOP3ryz8Uy6o0CR81rJyckwBlLLnmugWlBe9soc=;
        b=iuCiERHVyqLh5nNnkj6Rf/2iWq94z8cY4IhAuZc6+4ovdS0Zd77ZlfTGfiJYvYoy7h
         FO8qFv0hDVXMep0WWZ+xOMdpBrSgegqHHEARDjqFsKRpkge6CwShq+//ge+yGkgOoSPp
         /N72SiaktT9xhT+OEU9m5WGGwmZ71/fxpkswvourUgNF41kcTYg1JcRccc+5kIQUzCDW
         dt4fF8NZVwkkuo6mWG7TSYT3sBdl04lOcZYYLk+rff1DXKbAGAlsXFSvrttjHVfeqWiY
         5XUU//dCERDrKZVXNp1pgCAwn0PFt4ntFter8GMDgdRfqnOsH0ZtDziVOFIssIwurxw6
         uhlQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781113752; x=1781718552; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=46dTS54fJkFDX+n3fNAtP/BR3hdg+QzeIr8BMTbVi98=;
        b=Mfx0qQvV5Ptic7AwoNPrTaoVX38C+8vELfvndU1QbLu7C9XFDvMgPW7ZTx0y5CdF2p
         ZuYvoW0Z75C3J244pDjCJN5WhTAl7TVZqd9ciprRNO/Mhj91Lkbih7/RD8Bhm+fyfpyR
         wVUoQEfTTJY5MfeSvMcEQ12UcG0kMmNc0mH7BdjDYt734VUdJkgRSNqVB3aRV5ib4ob0
         JKV0dlxQhuRbv9GChpXjlhGVTRfvDvSMkjCosjF3Xfp49in+WfbJFLOrUQmf2Usk/ow8
         ObMEY5YIAgfAKEMCkVBVo5qz31ATCWDSP7/LwF5pf6gpRkJYkE8E/dStwQSh0MyFSakP
         99rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781113752; x=1781718552;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=46dTS54fJkFDX+n3fNAtP/BR3hdg+QzeIr8BMTbVi98=;
        b=izu89zUF/fqtnE6Qw10NPEW1pqhPymnnO8sz9zEse57nrNDwU8oG4KV6ZaqjP9VT2h
         c0ChU4lo/6Y2jZ/oMNHQqr31tVsqYdfyXCmlQTbANBesPIkoVtY5abLCoigQwjeaQ/uE
         p70aDj6jxwwtgkpkjilXLD1IkB0TbttMO93oqNrQbpdtwZu1ffp3FNW2UC5YhQQLpTzb
         yd6Hi86uCwm/wYdts+bJ1RUZwo+yU2Ai6w0x+7hJorx6mkmJqE4tW60ZfB1H+Hz0sjUX
         +6SEXkbKNH3GnXDe4pUhq3khTCzj7WVg4VuNL+ueOzpQJorZbuqHObKYxS83EnNTI9IZ
         ix+A==
X-Forwarded-Encrypted: i=1; AFNElJ94C3uwFKjHYbpQ0QCMAkBaT7fuIYDduZOsqi9k3gibpIaYu6JQjQFXERXGrfkFY3fWqMzYQAsI3w==@kvack.org
X-Gm-Message-State: AOJu0YyQucLHpSNR1M6asqCLgrfD9woUoDkV1U/gmHjJXvSu6XUDQkoo
	v3t5wd0gAcHwp/aYYey2v/EMQ+loxrPuqOIU+Ru3x2AbjaRfqzk6rHC6rHoWXxK9L/dO+brQNgP
	kMW5N5PFtVZKzGZRKC9+ztwX/4A1Z5TLUvF6Dnp+O
X-Gm-Gg: Acq92OGrTj0nOjeAaq7pA61pn9cj9ShFOYfmQtrhzllwy6XotAtq5imieWTf8ayesF7
	8FA+ZWLpUNhGXsVLRcx5yOwfNQuPBjX0Bv8J7YHzau/48Byj1bfPR1VBt+i7ovIVtgzayBbgo+/
	ZYgTTtRPwxTvMSzjo/bXQsOTKrRfytVG74bZ8j5dDo63gyHhiCiHuiKgHwZ4HHXLt1Zwaf0+C4M
	AMFEYAUZck8nQldxDpL2vI9M7zerq4xVMktg577yQYdqwFLrQA6Yfor3vtzqupu/HP3D9K8tYlh
	t5p8U5leRg17PCzv1IUwccobtkGV/G2lJq/Ec1rBX3Y9iRs2q74jiame7SHcZZbjqamotNhUSJu
	QFVfc
X-Received: by 2002:a05:7022:6b8c:b0:12d:de3e:52c1 with SMTP id
 a92af1059eb24-13840b97c4dmr92377c88.37.1781113751391; Wed, 10 Jun 2026
 10:49:11 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 10 Jun 2026 10:49:10 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 10 Jun 2026 10:49:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aiMVLtblIKu1DQWJ@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <CAEvNRgGpaggjd3=ooyzv7iEbmA-x1mWJHgjLSjPi8=5CPrk-yQ@mail.gmail.com>
 <aiHeDZEPkAcWcSkn@google.com> <CAEvNRgHz5GDjq0GqRmpQdHc-X45gCNr39VYWZH-T7XhPEtN5CQ@mail.gmail.com>
 <aiMVLtblIKu1DQWJ@google.com>
MIME-Version: 1.0
Date: Wed, 10 Jun 2026 10:49:09 -0700
X-Gm-Features: AVVi8CeVNL_ZT6N2PrMDnjQ93ySm3TRS4viAqGi095JXk89KfuwRXMizMLlfDgE
Message-ID: <CAEvNRgF31BzyFyVUa7tDJ=qJ-8ws2kxfNjLxmV=OxKSqhaOiPw@mail.gmail.com>
Subject: Re: [PATCH v7 00/42] guest_memfd: In-place conversion support
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
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
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 87D5480003
X-Stat-Signature: hggpdqrwi7z4w4kh16fy68n48x1gtn7c
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781113753-727599
X-HE-Meta: U2FsdGVkX1+c1IZPah7Ax6DT6mJkqCm9eiddPJLxGtrrHP8Zd07iouOYlJnSf2a8TGPHrMOAUuQjrZS0dn9/6oeS39ZaiPvNe+Ru+akXAYfvX6jfb9ld7owGko4nEHXiO9UNy39crSAAZMSSwf3xiW083WIGFPudb/EJornzCtNTm4951dVg+0Sb3trZLX3R6DjqfckPJ/820uKfqX0f49PSc3bposfvl2XRTZAFFlBA8ItnoHLfR0vX+xk5Etvk8Vm/azMHiaOP6dV+/rsyCa4HUwSIZXgTPNjur4Re001i7PQtmDO8rmT73nS3Hg7uKPjeQjik5VFj/mIsOv6B5sAD6MeISCVYl8e+mlufEeHNqH/nNhpiuGbHnCNvoIBoe3JihLfZWpMhvNfgTwnDT9zaa4cGH1A31XMm7cXMNsrNjPKi2ckkK68bg+e7jeTufDfSFjY4kqOAKgLBFmv1GiO9G7k9WRDx9tPiipiqFbLRyOaY2qHVHH8D9IRXyqqfpKQN9Fr6tOXjQ144UFh9F6cSniqiZYdGnA2X5dJtx08ur4a8gCSmira1XhUuAMJK365VBJ79SadzAqOjDBx5kcqbsreL3QXbkP5U/7siLYE5O8mOf3xpyv6OJGnwlDlJFguw8FzIOITrRACzPG8jTdta43psfROII0luBZFqJj/fn3ZAUQImhVC587GD5vKZz86mEYJ3G34Z27fparOKSF0DKo2Oax2NgF2tXMzUq0qTibDjbVLaPv00D2CRyTWNWRtdkVoZSyF+cKJj3mvR/fh4DphaXpo4VaxaRzXibS69q2MjptzkbeHG57x5ZqqrNjwZc/4+galcHTBwsJtDi6z5Pf7JZkj7PBczI73efQ/56Wl7U9I8eX8bSSV1+w4e5yb/sDZvC9IVIIYcmgApi22ll9oFq4Wt4k/G+kWT+d7GCmrYxuUSo6QbSypba/mdPJyIudJZExXSP7HOTB9
 oxYAdtNH
 krmnrw38jzMrsb3TyG8bZlWcnrjH2Ix73FVscym73+YppTylK71Nh58YtOnjDdQPCYEmdlCDUOhoG7UtTTCc33YT1PdRXa0dih4Zvwnf0CHXFGBh/Jzh7ysb0c/YyxQ9EKjjyiL5dAtf30nISyRqrDTJs4x9hOr7d+c8IdRcJJa7EySssWirgvjyNpmLND+TEqYYebFqTtsYizecG3GD/HT+sDSGaYZN3REGG/7gnj15A91nOEPG+ATQk4hgo0QUnQCACEQgzt/yCdUE4OXfIxqHwUoMsk+bbzfJh2eAWzxn3CJlQDBUw63hSN8sIMQEjaI93VuEO+4GC96KhgprNZ3y+uT4Jd1h7+41JGaTCPMjkWCzNDm39aR/S26CRZinsah2zF6smXvk/u3YIj8n5/O0z3d0T2ZPm2fZabugKr4YaFEiLqY91prNtyjWA5fZ+eOdLFeyFlH7lSTNsCbv7Xz1MzqQma0TmwKFtYJ668FLQ5lXn33r0xab4H4d3UpR+oA6BwNhubByJDk41YqGaVnDGIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jun 04, 2026, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> >> + KVM: selftests: Test conversion with elevated page refcount
>> >>     + Askar pointed out that soon vmsplice may not pin pages. Should I
>> >>       pin pages through CONFIG_GUP_TEST like in [2]? I prefer not to
>> >>       take a dependency on CONFIG_GUP_TEST.
>> >
>> > I'm not exactly excited about taking a dependency on CONFIG_GUP_TEST either, but
>> > it probably is the least awful choice.  E.g. KVM also pins pages is certain flows,
>> > but we're _also_ actively working to remove the need to pin.
>> >
>> > Hmm, maybe IORING_REGISTER_PBUF_RING?  AFAICT, it's almost literally a "pin user
>> > memory" syscall.
>> >
>>
>> Hmm that takes a dependency on io_uring, which isn't always compiled
>> in. Between CONFIG_IO_URING and CONFIG_GUP_TEST, I'd rather
>> CONFIG_GUP_TEST.
>
> Or try both?  If it's not a ridiculous amount of work.

CONFIG_GUP_TEST was tried in [1]

[1] https://lore.kernel.org/all/baa8838f623102931e755cf34c86314b305af49c.1747264138.git.ackerleytng@google.com/

It looks like this

  static void pin_pages(void *vaddr, uint64_t size)
  {
  	const struct pin_longterm_test args = {
  		.addr = (uint64_t)vaddr,
  		.size = size,
  		.flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE,
  	};

  	gup_test_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
  	TEST_REQUIRE(gup_test_fd > 0);

  	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
  }

  static void unpin_pages(void)
  {
  	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_STOP), 0);
  }

So in the test I'll call pin_pages(), then try to convert, see that it
fails with EAGAIN and reports the expected error_offset, then I call
unpin_pages(), then I convert again and expect success.

Are you uncomfortable with the CONFIG_GUP_TEST interface? What would you
like me to try with CONFIG_IO_URING? I'm thinking that the main
difference between the two is just down to which non-default CONFIG
option we want to take for guest_memfd tests.

