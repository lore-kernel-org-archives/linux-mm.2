Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C009606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=cy+K8rcf
Received: by kanga.kvack.org (Postfix)
	id 9C2AA6B05B9; Mon, 26 Oct 2026 22:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999EC6B05BA; Mon, 26 Oct 2026 22:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF9E6B05BB; Mon, 26 Oct 2026 22:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 613316B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:41:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB7C5C08E9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:41:27 +0000 (UTC)
X-FDA: 85366855014.15.BE6B464
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 94A49180002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:41:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=cy+K8rcf;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of axboe@kernel.dk designates 74.125.82.51 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793068885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
	b=O6gkRDUIdPMsyddAH4M2UPtE13SRSbeU8NRPv8DNazSjDKZNomzz9ghEpMo2ZN4vfRwfvo
	kbHBgOQ7Z5TWZf1JnUpOl6H6WIJ1Yot55Oyq6i4OMyU1dhsIVkFdH5GqTKa4YkKWirZAjz
	WblxGJr7UOdPfuKcySWnjkHtiZRQ+IQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=cy+K8rcf;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of axboe@kernel.dk designates 74.125.82.51 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793068885;
	b=k9wQnCYcITK0JT52WR0NEqHBjJXC7sawm/+s4yRjNhVmgOuFwxTRPnGqDwL5uW+jef6cat
	yJrNm82UMwiFNRiA7dhRfyqKRjEGP/JdvdeIZEpYK116j8xtDyoMkwNBeNtsSRNmP/UI0r
	+FYfGpVOkVeiHaujIKvYt23h8ubw7cs=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-18cdcfc05ffso4488341c88.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1793068884; x=1793673684; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=cy+K8rcfz+yDWnxBWKylR9Kqj16+4qxx9UC245j6x6Iw6Wj+hUWBaXS7/89m5lO+Fb
         iD09Ya1GUvCy6Lm67zDvlA/pv59x0JxqA+nI9/N8GnSxfzfUFiEoC+hoDatYq6OeoorP
         IjuNrrQapEWXe/NLLXCHAklsLP4PH0gNQt84vIjPAP4Qs4VfJYN002Xa2HqOoVTPZxEx
         Xz3F0bWtqKheqo0JI59frrYMCAM1MKQU935Q0I8zsp0fCbhirnBOyod877Uwoc2ZsfUO
         Cl0SHW6ze41TTEt+1yB9CYIFtfbjrDuDDlUST4gEHkmrns7D4yHGhyMHPRjE6PxUbE6g
         FX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793068884; x=1793673684;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=t3QC3AKz7L73bIWxdyeva+qD4oBag4R2netxISJ9B4ZY/jrGLpK1NToA+s37fOJvM4
         KzgmzanvH9wUN2eL7E7/w0GX2oZhOuCVTSLGxBt9887ysZmkJ1A/QR846CvgzcTYYvZ0
         /k3iqrt1XvutUteRzXUnggQ9JSslvlezPBjXiYJMmU10aAsPZv8vENGfcbcjHTzoO3Vc
         G77SigdQqm8rMVTunNfB3MNKnUbWUQQgW9STFqoZq8vK0z2/IBZbVGwn6LamSebk59Ud
         d1sZoSlBw1eFag7nizGkrTYq7eFtYjKCGnXei7TdkygIx/IgalzW7+IZG+wAD/s8tgeH
         6iOQ==
X-Forwarded-Encrypted: i=1; AKwUvByouXW8xVe5uL/ET+aDxwwRm9MoBj6xECpuqMAcDt2Gu2JMn8qIg5gDU04niC4NTolCljcKinkprg==@kvack.org
X-Gm-Message-State: AFq9FYJrOYUGikCaJurLsSq+OzfU0echscKiutK8QOyhx9FWGIRF3MKu
	yHhkTmXPP7NiOR50SHNY1v0wcmctEVUJLzzdL5bRL2PI1tCWA1R6qMg5w9wtZAqanJs=
X-Gm-Gg: AYBFou1NxBvWdYIi+Q84EY1wNJab7MenRQxN3+zqBpCwzOQfM5+/rfozrBExtgFYu6N
	tW8jmDqkRKUplgC0qVV0LVHG6chZL3HLD27eDAAAsfkI8scAdwTbhmzRV793w+vAt0PMPcECEvI
	LcSeYvkLjP2Djjz5CR4GtG2xaemjKX7Kq1qWp8tdz+FYoiZKZhqzF43Enp0lsqMHJbhRrMTIq3U
	3flLNOh3bHiZFfXqwRr8szFnnpcIfHmvC2Zrl/0QWLFDaPSGElg99rlqkoTPjmsSaklYCA0IlUM
	0sjWGnYNtz+nLg4K1HJQta8VZvV73gkRcEjklp3KVA68IqcC6kI4uknkRqmk4p6YRkI/px4iDbM
	ZwNDChZFuQ6U22mPKxzndVrLQ+7tqe1IGOmYo1Sa74sK293U0FyIsTEjs1r1Gx/ZuAzT8yaobDt
	oDIeh7fSVZ9V5yJKciPIDhrRqhHY4CTUsew1glsMn2T+2IrxcIlCOsPtqBX0+zMiWF3wGYBW01H
	Y69T/OlQkcdiDNs+uJgGqZi6A7Hpnz+a3uWgnusVH4yU+m5B7v4yXtI7hPz4dsRRa1JNag46gQI
	adn1gL2G9G2H39f9xXIWFSiHqPTQmgbiG8bxgOs=
X-Received: by 2002:a05:701b:4184:20b0:191:444:425 with SMTP id a92af1059eb24-199290fe40cmr12440066c88.2.1793068884148;
        Mon, 26 Oct 2026 19:41:24 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a1bfaf25sm29293759c88.14.2026.10.26.19.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 19:41:23 -0700 (PDT)
Message-ID: <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
Date: Mon, 26 Oct 2026 20:41:21 -0600
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user memory
 when canceled
To: James Houghton <jthoughton@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
 io-uring@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-2-jthoughton@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20261026215226.3713941-2-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94A49180002
X-Stat-Signature: rfuyrwugdqcz5otaiu7w86wj5rx7pc8i
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793068885-357580
X-HE-Meta: U2FsdGVkX1+epJOuJsFkmcQEMjGRlQQQpOKKWUAq2CEmzMI9I6Uc76fQyIzhv159Kd0c+Kl/wlASzbdPbBe4HY/JHjBy61NhXWqyDPW5mrzpLGrozUbnxeBHO9jLx1QX+niIxocL1JcInsanlSBUvXgF0I8XQob3Y83b7FmPTT4yCpc7QdFSQ81oqiqGAxWDJXp1LzOYNdJCWSTlk9PXWjXidVA1tq8Vz9W9N3RLO/8anSUEvq0QiJKk2y8Fp/HpG6eCunKv6rDMOwJGHRlYt5gk66qrN4M3W7i8WZDW+ros/a7QLLmCokEvJhwu63jUFz9GxZ2tYV3c2AFXyjSvmomy8/ixsPv6isxJk7KiLL8vn7uJ9yfNOzPA/35UTS0W9INBAK4K9L6EZR9g9LYy0rDtSce9yArVdZPDWyjLdqyahl+c1Eu31YVXJZzHb/E+2gqItFbk1CarOHRiBkvkd9zLtBtA8h22DO8yyGtTlM6Hnt+Gpb1I7Ja4cUS920v/GKXLShdCiYZJR4/FyC8L9H9ngJtUXXsF1DS9AWgIv4rjfMWH8M4ibXP3SDDCCaQqkbYwS4jqTewUTTrUu+tg1o3wRCNREMtG4UeM0dthmw50GCrP1d4Gp+7wxYADx+bq8xtkos8Q0GpE2GWD6LPClkoVsfHbOD5gKuOVVtwrchKTxGIhDhBkhNXWZPbDKvrmI+Pj6wQ/vhKd6JdQjjDFlBPo/BrHTDW3dDMrpcJtiD17f0HCNuLuAN57DI38ccyocmBwhlRqDZYJKE+M8wCZ9Pf9D0TQWJnt1iG5PzZ1oLYLuLWLQB4puxcIG7M8OYL5EyugJlLMYfG95gGlAqMTmYowaXVWdzYn5SLV3T4ZAhSYu488493BOJS7zlh3qVxQFPJIK1mnx2E+JfiBAa0FGPYhQd8mSEMMhLzBrBZuuKveOg5dQfOaqGph0CqOBdR/2YGzaG4zh3yLptgnwn/
 jmr8kkGj
 5IvDJSOECIjBQ69J6wpu3IZPNYzl2vGGYHIehBg8P4SzfexfwNrD01t+x4PaG3Mw2+ukjcetz7Lifcfjvj6JlUC7g4Zy4KcoDHScn8S8qj3NqPpr0T3bc1BLrO5FSxtB2kDx2aI6K64Ei41FWFzgfUMKaNo0zyp9SRwhgw/0MzzXswoORQrUnPa8sJXkExw7xeJluQaKSUA9PfSwdfTdVGi3o9ad4MJEkI/4SS3G7nYvYE1US3BVFVG4F7i8x4TSiM0umQ4oE+RpSWv+R9lSyorp+sbV/Tz+s11i+W6P6HnpucNQB3UP+5bZAWjyd4ff/ndqTYQvGFTdZ645/FG5OyGwyPM4ojHy3C6zbOIabUmx7yKjyulW08orR4betBIF63MrMfr3EBK7b/sc1AaEg6i85oYUmDRbP0Nls5wlb9wbxtfy1BG4WAR5Yri4EQDCB2Lby+ezjxLd6IS0lLPY0h65IH8/CP6Wv/9+qsn6FR1ZtnpljwAHLWBXoVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


