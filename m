Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50AF2CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA776B0005; Fri,  5 Jun 2026 14:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B18F6B0088; Fri,  5 Jun 2026 14:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C83B6B008C; Fri,  5 Jun 2026 14:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC6B6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:28:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2963340269
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:28:02 +0000 (UTC)
X-FDA: 84846693204.27.23E481F
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 760D980006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:28:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IKcoCuNs;
	spf=pass (imf02.hostedemail.com: domain of 3LhUjagYKCD0rdZmibfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3LhUjagYKCD0rdZmibfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Al0zDa4bN146O1R+FtGZtDttdy90kv7zGQH5evIcYPw=;
	b=eUQmX2SFt1TommlRwSAeM+QTmjEusNJNJ+dUlBYV6M8mu/J+wSP7zqbFyC8X5lJcj6e/PB
	Ecvrxtn5RLPFiRILmol8l9WdXcS/7FOwWN5y5zYkaglX2FdEFAbqMxj2Hl4qMrg+10OBDZ
	HtyCqBg4i7u+5EyBxTUzLkYBQ4T9KVk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IKcoCuNs;
	spf=pass (imf02.hostedemail.com: domain of 3LhUjagYKCD0rdZmibfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3LhUjagYKCD0rdZmibfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684080;
	b=Ji23qxbmTj0OC0KsAbcS4Z18HbF9J+wtkni3XAlgcyIiGLiMgpK0xy32vz2jRluG3Nrn9e
	MP1SbawEZ3r/YNdN8GMRQBBU1h8mxNu06iF/mEL5MienwnGGbKu0+0HewE1gNqjKCkpd+i
	B/gv6dnp1KQVVVVlMLqEoaSTTfN8wu4=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36d98b54cf2so1690286a91.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 11:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780684079; x=1781288879; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Al0zDa4bN146O1R+FtGZtDttdy90kv7zGQH5evIcYPw=;
        b=IKcoCuNsZESS5qpCJKXvTOczSvbe+0jXiEtMD93/0i8hGTfPpwh/eg6gWC+6OWQfqQ
         yKrioz5W4nK6wII27khSHL9m8kNnL78F9LB3VayWT8caUxTAlPsn93M+zZGalcWS9yC/
         Fu7oPdNPj5XqdHjyeRGA4liJ0t/9fg2UFU7KXClptIep/0NStIkhAYkpv6DnKtWhqA85
         IedImGyBw2JNoPsMpGSZjk2NIy2PGUSepUnzamKywwJLncbu78Dvr01pM9rjtOMt3Xk9
         /ZIB5kMuDCuidMxXkX+YwRQJ/s7TYEtRsv01RfsdKdUP4ZTurHxsKw8fZY4yJUw9VvF8
         sP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780684079; x=1781288879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Al0zDa4bN146O1R+FtGZtDttdy90kv7zGQH5evIcYPw=;
        b=M/cA60QHh6RVVspiDwd5yv5X6DvStSRZ2Scrl3bJKxSPONpdFZ7o4NDrjQFHOAh48J
         XPhZo+sjMNmlwpXIJXjc3f6I3a5IZwMt3oQ/QIFKY5mdjUHxU4N2c/OOpbxIC156w81V
         5wIbP1porW+jpZQ5d187fl7IbUSHr6fvU12j26dnKlQPgRY0/uqZQJRWTmlluenshgHI
         wJPcbyALhFyRKbjSgqJI53DYiHeohwYVznqm0Q+K/g0n2gAOnfXPuL8EjqDAOodZqQRG
         zAFzpQ4tVfG+QJzLlFYtqdSEHip96x3e6HM9FzOyjbfGP71NhZ13mTfwdtX+rj4+kqZg
         yAPw==
X-Forwarded-Encrypted: i=1; AFNElJ9ADo9Ksix/s3SsILpLG6B5TZP2WteQ22qulY5FXf2KoqubHEOY7bPwHjFVER0xl0el9XmRGIAvQA==@kvack.org
X-Gm-Message-State: AOJu0YxcKOJBmzMtlH23Qtkx6UOshIkjTBuIPbVD8XS3zqF1hVHp9W15
	Pz93ro0mCuIgKSpqsGU/1yaX4p0s9X8STi1wGVmjDqrSlMRf2Wkyb53Qw55TQJ//JaExMbEXt0Q
	nQNGaEA==
X-Received: from pfwp41.prod.google.com ([2002:a05:6a00:26e9:b0:842:5fa6:3103])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5210:b0:36a:1ed8:6fe6
 with SMTP id 98e67ed59e1d1-370f0b58cefmr4684526a91.24.1780684078907; Fri, 05
 Jun 2026 11:27:58 -0700 (PDT)
Date: Fri, 5 Jun 2026 11:27:58 -0700
In-Reply-To: <CAEvNRgHz5GDjq0GqRmpQdHc-X45gCNr39VYWZH-T7XhPEtN5CQ@mail.gmail.com>
Mime-Version: 1.0
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <CAEvNRgGpaggjd3=ooyzv7iEbmA-x1mWJHgjLSjPi8=5CPrk-yQ@mail.gmail.com>
 <aiHeDZEPkAcWcSkn@google.com> <CAEvNRgHz5GDjq0GqRmpQdHc-X45gCNr39VYWZH-T7XhPEtN5CQ@mail.gmail.com>
Message-ID: <aiMVLtblIKu1DQWJ@google.com>
Subject: Re: [PATCH v7 00/42] guest_memfd: In-place conversion support
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
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
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 760D980006
X-Stat-Signature: u9jii9h44i5juobgs5ccutryhwe6ww4y
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780684080-496445
X-HE-Meta: U2FsdGVkX19e5XE/S5MKBlNdixvGNpCd7jA2hsdBAdkoiMYRVnSU4YjjaEiVFMQ+DSmGdtYyREj5VcbJE0AgpwksfFp3/WeBfDMtd9ecxCWGJCSN0+LLKDjzUaiQCC6iuQjnGDEHTODlUNkOwEchBG6tqsgXOG5QlX6Mv4OpYssfcOMoCwx+uNcQGYJeubbO+2uAYR6NFD2U3MuerHK8hxgvKw65CzimSgLR3pGkT+9ZoFk9F/aJFkoiN/DvVHrJtY/YbsVJh1oC//Ttv7auoQKvdWJO87btPXhbB32EjTI406A924R4Ufu/mOuC1I8nhaiRfJYWoU4l3duf5UlS8jgs4ZO9W4Xo8mozzGbdyW9vv4WcUovJjgZ8KRYRH3fe1jjXe7mIVVHBYXopkXwlRwmelYy9BPZWyNuG2bK7V52ZSMjfdBlhMEEj/rZIonhS+Xx5sHlsIm4dvtRSGMJcjRMLfj3fmphIGUJWflkwD6Dt2nd68u9cHxcrcZ3bL1xTxD4PXYY7vjv3XRg8bZPMcbV9HjWzS9ePV22Xl+w8weu5Y2+93xQuwCHuy7P40d1OkvQWXEK4CZKxlWswo9p9B8nB3hzMWpn8oc1vXDHt7DEWvCT0r8kGVQN384Qrxbx5tufnVU4AR5Vr4mYyVEvLsgzU2Otj7OIiWExt1bgsFWAc08TWAx2YQAK/AXJ2kdh04/KLEQmHBtDGgovP1q/47sytW/eU0MKYqesBpTE9BcuQwtULNE2zULOuSeB88EayeQgWtYz1RKB8fWXELchUfeycO3ZZ0UmiJu2QNTuQYoVZsMPCG3oWp9/dMGr4m9kVAOzYZDEaEAYceb/tlu6cKydSggTRe5pONYpUd1KpgFzKuxkA3AKvWyyTCStpGThrR83+A1I09CO/7Z40qKSN7CBff8wRPzyQ0vU+dioolkNehh/2R09KlIBUeWhzucataNFPTefQR+L7ltq4HzW
 N/j7qHYD
 ptCgB1jPjrPN749X5+aJnBLISks2rV6hPb13VBwxKHI34tbdpzOe58e1WirsOxlew1WDjS/xHR0y5YgxdzT+GIvg/ZgblANGvgmBTx1NqcYf/0rEWut1rYr/vGRan+dcM8gja7S907+k1GFVKPaNkXY5w9xFskdiFVHWY2KVgKT++mWGQH0/3Nc2YAb6fiN8J1pkbA1cALtufsaq2qHfAEy1agEu0gN3uLYIH9YBRixMy5+Pt3jU7XJOYOickL4J2YoriuXxtBwhUs0apoWz+tN95bO6iutw4XV+VbnsSkDmkWaXCaqSC3xafvMNzQ9k15umsJJ6JZHIRkd3WRw0P9oFtNNGqhnJYD3wYiCy7wc0nchsDC+PIcREJ7g85hacWJ4/zI5xOvKu+vE9oWWIQTXHeXC/SbW0+RR4FEHMC2+AT6Efklw0Y6uw7+rnZXu860/moBfzjYS+eNu+7LOq8gT6qxMEW6d7c1J5bRkuMo1FOy2dRzcDYrCrm+L2Ak5Ugbb3Dd+PHD1bouBr6LHAVa0+8ypaLlSzLqu78UVboVgbPP8G+bl0zlkAOrtCyoNogT6OTyIZeXJSZG+Rbv52JiHzc7WkM8wkxqipfeD+M/sx+Lsom4IPwdU6ez/g14aVGuOSXhMuo3/1dkAuoKdRq7TrvZhmVQ0r7DzT+vZkVgnaiD2cvgjdLzo04DU/kpqU1oIemeIBa213unIXqDcj+laBwXhpdwqMeu7+xIbmr1AvTVvoyUbzTT+gZihEfOqX+oR/n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> >> + KVM: selftests: Test conversion with elevated page refcount
> >>     + Askar pointed out that soon vmsplice may not pin pages. Should I
> >>       pin pages through CONFIG_GUP_TEST like in [2]? I prefer not to
> >>       take a dependency on CONFIG_GUP_TEST.
> >
> > I'm not exactly excited about taking a dependency on CONFIG_GUP_TEST either, but
> > it probably is the least awful choice.  E.g. KVM also pins pages is certain flows,
> > but we're _also_ actively working to remove the need to pin.
> >
> > Hmm, maybe IORING_REGISTER_PBUF_RING?  AFAICT, it's almost literally a "pin user
> > memory" syscall.
> >
> 
> Hmm that takes a dependency on io_uring, which isn't always compiled
> in. Between CONFIG_IO_URING and CONFIG_GUP_TEST, I'd rather
> CONFIG_GUP_TEST.

Or try both?  If it's not a ridiculous amount of work.

