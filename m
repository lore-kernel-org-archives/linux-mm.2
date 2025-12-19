Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63F6E66891
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F2D6B0088; Fri, 19 Dec 2025 16:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B406B008A; Fri, 19 Dec 2025 16:28:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07276B008C; Fri, 19 Dec 2025 16:28:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CDD026B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:28:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81D0889FF1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:28:54 +0000 (UTC)
X-FDA: 84237510588.02.7BEE6D9
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id 870F218000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:28:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cD8fmjKE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766179732; a=rsa-sha256;
	cv=none;
	b=ALglFJfJlujVop269R8Uw2XRDS9E2guKpvXnfB5W0G1XjWnam/D7VAHZhLr11IOMGIdyvA
	zhub49Owvtag6OPS5QKKBVAwpcl8Wk5uW1zSRSn20nR8k7ki801GmVplCAqklV8Nj8qS4t
	iFV0wdcQvZpbg2k7MuVlbIWfUkKMePY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cD8fmjKE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766179732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qdyLYhk6D9KpgNEc9lTRHJNMgr66Y5zIziSEMCrXTM=;
	b=iGDRutnMG45LGr3eD9RR7wedvusrV9MBvTTf2gweIYES/4hbXwFDVgmYVzQUnhbckba9/g
	vIfo3dy+HnvQY75rJdXUaQyhMaD7+wcOz0l7IP8Rp/EY4oKtDXsxlSdGJivBoz5wGLEM7O
	OM4EL1yFNUgZYVa6XwdMso4UIgBv+oY=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7ade456b6abso1926622b3a.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766179731; x=1766784531; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9qdyLYhk6D9KpgNEc9lTRHJNMgr66Y5zIziSEMCrXTM=;
        b=cD8fmjKE2G6Yzvn8JqSDHdTGWVRdwFrISDRfBE7upPeMrBGxK9AU2bIKywOIWnX6f0
         gQLWakZLrwA5C3/AuswyqMTxppvb8QzZ02URwlSRWrrdB1RSs/FtFtxkg4H3hhS5pAH1
         +dk1pSfypsQu/WbiR5IHJdOxX/jED5EHLwTswvzo9YIUkWJcBtnyaAofkWN+cVqUHODS
         nPg9sW4h09Mxwj9EVPMmQ7Zg1eNblPmAiamslT9vO1nm6VY/Xa1T2y2wtqd9sBvd09G5
         cjbC8M81O8OGqpoOdBPDXRM4RTE1klFf2SlQND8iX+47fWGYBefRNIPSBSl8NK70NcMB
         8lBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766179731; x=1766784531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9qdyLYhk6D9KpgNEc9lTRHJNMgr66Y5zIziSEMCrXTM=;
        b=YHa1xqViqVTCtrrHsIVLmxwAp3ItjJvGhFFUvCoQFct47a6YRnpiyS6kIWiYtXx24C
         TuvHwXm8vT1xIMxEwouijcgtzil8T0kXhTlGG7hlbMoXmpnRbfTkxNZnppLFECt26ycR
         E1sSgalrN9rVBpu/hY/lA9moZgchk/mFohhuwWy5qRilQ+AK0I5g3v4kJgdlVy+FfDdF
         GRuB2llZPZ8JQc//KA6NTORYAKSbnqt2CmkGQldcFkCCoGNCqatuGNFeqFSmjhAphfuo
         C6W1lELyr2HTtXMgtJ4iJiLyBJjsbp+jXn/IAEcbQiM7nvqjqRT90gvXi4hiR/iwU/jq
         bDBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD5SPpQ9+cyvHji6Nm2ITwO6YArSLXkh2g5EAg5tuOiodsqm6SZnBVjPgb9vuQt8pE95OFSlSBMg==@kvack.org
X-Gm-Message-State: AOJu0Yx+k9HAGfRjo7P51ylqAgg8ERnp+OuIl1co/DEcXN2JCZIL7W5c
	WXXlYkNe5Gv1DcR+hqt1sODsSsgDB0dB/XJxHaZi/nfNJ29LGuRht48q
X-Gm-Gg: AY/fxX6z7FOKRlT3Dw59ycSJ71bgtg9Xk+XKArtQqR1/PDGpdGlxyChdDbq9J9VskyT
	4hJ0lm26dMCYrdFbNFA95Rb1nwQ5N2qazEG9AVnOc8sHD3I4iZGSCbGxY974SsJw730piPBDRAf
	/iDoR1QuIasWeWbepOy82oca5ZpJZs+lm6Hmytpjy6CyGBiGYUA7j8Q6xvXdltLF5b1IqC7VYYH
	2/xQ25YoOPGr9KGWp6/pzEF+oPI6bo/ncTGeLZSBWiYze6st5UBcUfjh79s3yLl5fwXN7VjA1ET
	XqWr5lEm8sIUlTtxQDLyqp1nXfN13VqckmEdgFM9iiHK29zjN40QbSWBO5CJ1LQU0iwi5zU+Ze4
	qCg73PS3N9kEvsC4wm353JgxqKWy17ysUZ/bvbUK70LOSR9CAk1sgCRlT/6v5fPUOmmx/Kvcnmn
	WuozcPITDdcW7j0KCsW+nxdcXdjB3n37y/IF6IWRCqR/ziFKI7fGCMbMM2JsjSj6S1txtv4LRZ7
	ZVx96JCMk3FkHtWvN8AaStHptuUHtYdsfcL2cVS/b0amFAgEqs7Zhp+1hELKEDM4cexmQNd86cO
	Wz4=
X-Google-Smtp-Source: AGHT+IFntC97OMoIKW8iak4Csi+Sa/wJHZS2qz46SkDovenEuEnw3BILL/ha2LHm12T/rhrLMeYBbA==
X-Received: by 2002:a05:7022:6988:b0:119:e56b:91ed with SMTP id a92af1059eb24-121722e01c2mr4354548c88.30.1766179731046;
        Fri, 19 Dec 2025 13:28:51 -0800 (PST)
Received: from ?IPV6:2a00:79e0:2e7c:8:5874:79f3:80da:a7a3? ([2a00:79e0:2e7c:8:5874:79f3:80da:a7a3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254cd77sm12305503c88.14.2025.12.19.13.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:28:50 -0800 (PST)
Message-ID: <ecb35204-ea13-488b-8d60-e21d4812902a@gmail.com>
Date: Fri, 19 Dec 2025 14:28:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/36] lockdep: Annotate lockdep assertions for context
 analysis
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-8-elver@google.com>
 <cdde6c60-7f6f-4715-a249-5aab39438b57@acm.org>
 <CANpmjNPJXVtZgT96PP--eNAkHNOvw1MrYzWt5f2aA0LUeK8iGA@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <CANpmjNPJXVtZgT96PP--eNAkHNOvw1MrYzWt5f2aA0LUeK8iGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 870F218000E
X-Stat-Signature: 97xcjwenggis6xzrj4xr349rtb779o7t
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766179732-738461
X-HE-Meta: U2FsdGVkX1+F71BBzCV8yFdiSy50ynez/3mZIQYM1VWUgFmLXbiGMWU5ScXkz3GkGYkvKm7ka/Fme/cGvJGSjcuU48DQFgTeNuFklSLH8jBASHiMZYQG2UQTkGwxcHzegvFc/4eYjgarCiKvyVvnLpIVgdTn0GYU5niznIxrbo9Vug8j8u74CTZLmcR/wTeTsvV8c5Z+CHgsDujxnm0Q/Xu+LEPAs6D8bTs5PVl2U07TRosK8nULGk/GeiuqF0DStmcKNAAa7UmktXjVaxU4jAkkWJ9GPqy8VCKquatrCHQ6yG7YlVqKjfyyUh1naVeWuOoQsb8XFz3uuRefxC//+Wgf8GxsL+nQ2VgtKy9d1ya/TmhuULwBPdhiFPETh9WBPBEsmRWEcMuk/vMhLvEwmMMExYdOBl36zrQypTRGfrAeQWC018X1wvaC4i2KcgxoiqeehlbNdtiRmNy5GQxa5FA5N9x5GS+O2gPw+ogzGHgulROojxjEUrtYf5oYiAaRilRaOTnwGPHLpJfgTD3/K+ueRNWiWYUPH0AT9LBSnRVS+hFp0ltZ7chake3W5kROMaaVlvhc3nH7GRhFCj18I6eQ62B1TSqg2XVBfT6Fxcq1mZa9WABpVPLtjrCJ2ppi2KJTWFn4PLL3vkHO0n3A8WpNHIuIijG4KyF8CN3NcJDp+0E4AEnzLOmDBLoUZBx8hQ7rkhJviqIiNEoMBvVQKd3CpU95ARnL4UP4x/ycwemSkpY/2be3q9BaBXUEUTvZJrJVhHG7+EVR+3IEXFlNZv86k6x/Mmxhp2Y7KQFcNZp696BfWRbt2tG7SekVBDmHVn5gjwuHoKsNfrfenhmOp1pqr5BRafARtxX+oN/yM4ieLAj3ustel7kQGWw2mFj2nwz8xkgf6Kl+U9SjbSFUgQLRekxDEEYd+4mDTO9Hr35phbVVNaCh3B6o2qlMQXZwfWmkPVKwTkwGupuKMXa
 ehVjZS5B
 Juc3EVKZy9wetIJrRtvLh/coFNjGJrMep1mE9fnYEMHIcM4HVrN2UbgQQ6GJgbtsFuz0uDeungOJejQ9YRkxQI08GH5Rp7bZyE4D2hOFbpgk7N5O1VC9t9fgNYUNo9eLxtUH5BPaYgi7pj54sPshFQH5MaxDxQV7pxMXEs/SwfY2Klh59JnO2J10hSxm6sfpyBza/FAXuWL6CO9xBFwOz5XFb8M/eF4p0m5avTXdi3bGztveH0C9U1YYeORG2lGcLOYVk3EgnbPhAm1i/apBUk8aSDGjpEecFb108Ohf/BWsrFOkQQiUmWSsjvWjPj0ZpbF+zBn7b2Le8IlFAfGkXkNCaGtEjT8usD34m5Mw9ypdLC+dTh11DLlLvGeKDpyulP93UY+0tW8sbpxwy8OwmN4oveSvuijOQNHiIkHiEgMxuzpknOg7G4/uNoXk2tHmZ1IFtcy3VP8Qipyfo5eM5aNGiaY9CCW5LsnMjFj7lRQthwHFuj6usgFmbcSFB9qdv/ITuM4VY9NXDcPUL1xow3NsAhRwvTngoPtshgspX8cEuV77o0gk1ySKS5LFbmaIvGL+144U0qsY+eTyd4WvR7Nrk27lC2W5RwYJj2Xhben7mZ4tWFfuWMDyYKqSHPblXFN6byUw3kaFTJRWKIKZIb3YVt60UERrYDzVwfWkRi0bhm8s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 2:16 PM, Marco Elver wrote:
> It's basically an escape hatch to defer to dynamic analysis where the
> limits of the static analysis are reached.

That's not how lockdep_assert_held() is used in the kernel. This macro
is more often than not used to document assumptions that can be verified
at compile time.

This patch seems like a step in the wrong direction to me because it
*suppresses* compile time analysis compile-time analysis is useful. I
think that this patch either should be dropped or that the __assume()
annotations should be changed into __must_hold() annotations.

Bart.

