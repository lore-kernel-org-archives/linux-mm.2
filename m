Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 023491048924
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 00:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCC26B0005; Fri, 27 Feb 2026 19:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBEBA6B0088; Fri, 27 Feb 2026 19:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7E26B0089; Fri, 27 Feb 2026 19:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC4396B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:44:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E73C1409B5
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:44:12 +0000 (UTC)
X-FDA: 84492018744.05.766D162
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99DDF180003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:44:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUSy53X0;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772239450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBwblb3CHX9Jab/Y2KovLLCIWamrFhoMAgXNfbYKr/0=;
	b=v/vcKLfvyVqRvqFYCmjTHpzt4+RsyWJMIDzipINa6ExPkzrdEUgaoyij45cW/Xt9urgr6Z
	llArvnBbiB4uJO61FeTpkXryzD0haooCo+Lr+eJMQUt3xtqL6VgB7p790ctqBjL/Cu4eBx
	Kbjjp/HTCq/WdoplTmImbEuNHjfzjEU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUSy53X0;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772239450; a=rsa-sha256;
	cv=none;
	b=BJHLgXCvOv/KLValc3tntuPnGueib2nZaIWZhDRtvf4gg0QUZLKUvbGrZJPWSfZNm5F440
	oTqhaA1X2ChVKvhklff2PnKIKFCz0kWhbyK2NhTK7zW3lHkf5lDVlp1kZHkvOYwjL8CQGd
	SsbNnuxFuQtBShHlYmm5Ish7uLmvtgU=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12776bebe9fso1696678c88.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772239449; x=1772844249; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EBwblb3CHX9Jab/Y2KovLLCIWamrFhoMAgXNfbYKr/0=;
        b=nUSy53X09ecrRE1wEPgqv9B77M79xJ5oi8cTHUwvJKaC9Lpo34ToUZ/5Lx6M13DSCH
         ZEWvEnja0d7cYZnOjemtFf4ByBa52fS0ri9Bez6m9J3s+ht85gXh22XSGaZoi/xsxoWU
         9MqDekLXJtJX4JmtoGb6YYJkdkOfOXmIMl0H43yy80soC8X2ywxUVghZTfc5F7j3tTAg
         6WvVz3KsgN1mTZPBdjdITWHPYuVKnFtpokPgwbceZq3Ouhw7WYR6yJueQExnygziJeMT
         kgmoKeHepObP0N4YRZhvD1Ydc0coGpD0Xb7KYhji5dJ2/wdF6AiH+P2Frg18lY65/742
         OezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772239449; x=1772844249;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBwblb3CHX9Jab/Y2KovLLCIWamrFhoMAgXNfbYKr/0=;
        b=s2ByQsh9d0upPr7WKMSjN+GnoKx2XNveNmIfqR+VDun0amQmRS641vmY+zsMT3ExM4
         /cvkhP6IAlpHEdxNTX9//1K7KSoSA7Db4xa86rYYBjVyrkC8L1YFLTeJDw+Sf1UurDL2
         pRoB3Ur1W4gJ6ea750yQ4r+vJDfyGWo1aSmPQmuWQneSOwZynCtkhPKtzyNiq7hj6lZC
         sYvAeIFesM8XmmIBByDVPQ/qgAr8akSgAChuiD+kPtVN+Fkm6Lw7/CHF3h0KHs/Zqwaa
         RmWgD5XD5oHcE6d/FFGGWvkiWKf2LccoPrb0V4iaxp/XOf8w8tO+Hw0m1qpytcrowbIt
         kFYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrs6nJjRMaXl9SY9kjZnjrh6ZckRDRYwYe4TVlXsqqIRLzTPHEaPC88dqp7wg8z9EWSPvBVcCHdQ==@kvack.org
X-Gm-Message-State: AOJu0YyH/sFCBsuIuPhX9MuApDoi+Lsaqa2+oDw1NC/wC/j/weKggKu7
	PlbKKyhgAJu7gKSc/ghUD3x98v5ML0Fj3HVZBbO6pYAEc4mAvX+LuAsj
X-Gm-Gg: ATEYQzx4wQsDB+vsIPGgVBD0r+ejH/W0F385jYRK3YXo30d2NZy+y548uDWit/FiHNW
	d7w0nVgQgw6pYoosMXQqnnIcSZAk27qQM41l7HbteFWBGU6Km1vUwOjRqPIk+aULPuEfkmKmPmq
	f8KtD7a1CFaXYibbA2/itCLOi3URCNy8AP+HhK3VCdktPXabGHXmMkYZNuSrIykTz/bFUd/g/Na
	grchImg1d6idxuwd+Ic7P9a2nMi9RGMlyNDxWAEP82BdFfm9blZpP+YGw3To2L0YtE4+G8+VRVq
	Owi2sH7fpus8Cm245fq9kD1tSnoAm2ets7iq5tbjWqVDfVctgRkzyArsUZGA9YKxoa+0oL9z43O
	Hg9QbHKq0FCesTQChALS6aOmLF5SFJNWzC5NOZGiRPNXjKBEimPLv9BUebQWW31RsglE7Az0QBn
	f9mXhEfq9zaNeLjo9j9gaohPSxrkr6GQstvgJpgjwSxGofJClMwdOaLijYOxHo9cXnR7zfM/POT
	8+IFu5dL32nYyo=
X-Received: by 2002:a05:7022:2485:b0:127:5cfd:785 with SMTP id a92af1059eb24-1278fc28856mr2211264c88.4.1772239449165;
        Fri, 27 Feb 2026 16:44:09 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12789a43885sm7533362c88.12.2026.02.27.16.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 16:44:08 -0800 (PST)
Date: Fri, 27 Feb 2026 16:44:06 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
Message-ID: <aaI6Vq-uyJ6F4P7u@fedora>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
 <aaH5Z5HTC5GyJ6sT@fedora>
 <2fe139df-1764-40e5-983d-48d7f97c2e39@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2fe139df-1764-40e5-983d-48d7f97c2e39@intel.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99DDF180003
X-Stat-Signature: xu9nystxm4as63p17pi78xfkz37pwzub
X-Rspam-User: 
X-HE-Tag: 1772239450-563867
X-HE-Meta: U2FsdGVkX193mLs9WI5oe+XUs00yDhIYQOCJC9bTVUQOOqDpcHozGFgkwadclYfUUr3cuz6yWf/mxapX/DZR/p5+wQHdH0i2j7x9Om/gttPxRha4NCVbJM5JXuC9B/EhGf+qRdB5W4BddSEPlSKa7EfRR1M9tgcWxs8j04wHIJzGF54qe639wPiW62Bhr+iwbeIpEVmVozgnyWs7yRaW1KrBj86YZMVB802VAK8qJjaWs6tMcwXncO6Jv0yEQfIxSTl1YSAfHYwcYT/9CrIPtr4D+gaBiecr47gt92jNhwnniVIcj9nFUE1aI4UNuQMKg2nUgNtTVEH+lpLDmB4VHajxUT3QvyacmoGjfLBBC80BjhzBm7GFFr4Sh6hqUU97JWdHGgJc2lk9+fY184JAwTVKRYHz4K3ceAQ27oVIBJOnf0EZGb/Nmfp52wcFOkN6bUdinQOqJUJPD4ly9KV/v8hIZDztrld11BGspPa+vWG/BrVFaqPEdpHSw1K3TmTIX8+hMidmM5UXGQdg9GPnig1gn5Lp4CP/JwqCjzhjiwXqCuEWGUNE4/u2yTU5H5y6w0P25nJRF0FLblYdFD2+N6csd1mZRC/xo4Pjl0+byBghnroxtFYDhUrZTee5X+HdEmuobPiM4L+nbyCKQDW/mU/jpVDdPRlpEesOrHvQ0/gTAR9j4ZWQXZX6zHXRXIMEsxFTbIu7h+uXkOhszwdGTPNZ1ieuB9GcqVXfZxTik6IHRy18/K3eBebqtjZ4XwuF6MHky+Fzf9qiTPBlomgKbPbxU4Jfpy8TaJAe+d5xR12YzNFPtilYeVaoV4hz+vViOnqlP0xIAmS+h+vKuaqqsR1EEFEpbafexM+STOavWBiF8Tg7RWPWm/kdKJFl3JNNaim5NjA9/wf9e9AHAuyL2au6EFbSI6KPTiIDsCNC9Wl5VUEfSTCHYCm8Co97lQLXNDrMtvCgHcK1Nnwo0Fw
 hth2v8nz
 VcqAu740AREB2nb/npW5Ced3xgCYTbnftcaMMNc7JBhq9ZPXI+Xy17vIGkli7RwxNcVunUzYgEfMwCxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 02:24:33PM -0800, Dave Hansen wrote:
> On 2/27/26 12:07, Vishal Moola (Oracle) wrote:
> > Do you have any more comments for this series? If not, could you please
> > take this through the x86 tree. Thanks 🙂
> 
> From a 2-second glance, this doesn't have normal comment style and isn't
> using imperative voice. Quite a few "we's". Looks like it needs some
> more eyeballs.

Ok, my mistake on the comment style. I'll fix that.

Sorry I'm not the greatest at imperative voice, I'll pass all my comments
through AI to convert them all to imperative voice.

In regards to more eyeballs, I've realized I didn't cc ALL x86
maintainers. +CC the rest of the x86 maintainers and we'll hope
someone else looks at it as well.

