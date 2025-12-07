Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A51DD1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 03:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7EA6B0005; Sat,  6 Dec 2025 22:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8D96B0006; Sat,  6 Dec 2025 22:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997506B0008; Sat,  6 Dec 2025 22:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8FA6B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 22:12:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 283A51406F1
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 03:12:53 +0000 (UTC)
X-FDA: 84191203026.13.4B5079D
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 573901C0010
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 03:12:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="x8n/8rja";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3sfA0aQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sfA0aQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765077171; a=rsa-sha256;
	cv=none;
	b=i1uBq6iid8sP0aRHztbRIWxsb1OdGhbLDNJ5cA1xSPZrlyAGONa2klyfLHbSW/vU5Y3mX0
	4dTJ4ZGJFvjANY8PuTfU+8007PVgX4WGdzaKOrFoV99Ii7J6E0DkfYh+913nuy0mp228ki
	d17jxHTnc0amta3opZeTyIte9NQKEso=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="x8n/8rja";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3sfA0aQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sfA0aQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765077171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVjvCRDiLMRUoN6KdVSryCZbii8x/leb+gzOibV+bP8=;
	b=Z0tCh4JbR2keAepvSQzjwlKBN62aTft9lBTYCZqHlyET8TRi475XIuQvWymBpgUMw7kDm4
	YZzrNx14zc5RenOf8K2FabXYzXo77XJXTLrIRyuF+zc38tWvSJDzTL/AUD/R5CsadZq9ut
	TZt9c9YaSTrE455hYSVc/TBA7Kax9v4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so25342185e9.1
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 19:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765077170; x=1765681970; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVjvCRDiLMRUoN6KdVSryCZbii8x/leb+gzOibV+bP8=;
        b=x8n/8rjaki7UTFOGyH48qLHnKvMovh9zL+KiKe04ebuBI2mSb9iEkGo02xeKsZQ90H
         9eP+DTYKnreN8YvUYowF5bEOnsO+Jjl5XHfk+BsWP++eARqrKMWS0mATBlUxrQqR1sqk
         TtwCkES5FI+pBut4B6VHEUm9n2EsEU+/ykYeTniVMGsE0mV7NJamI29RDBR6XSBNA6NK
         3fTGfawhlZirU2GsPBuuIOULLYHiLow4COZEHONFvvt8V3hIl8k9ZIgYz5Nc71S4wYWv
         H4j1sEokja6WheKRYARg8H2quCA6BnnGA824CH5lUOsFTXB3BL6714okvOh7d/WFs/SG
         rokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765077170; x=1765681970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVjvCRDiLMRUoN6KdVSryCZbii8x/leb+gzOibV+bP8=;
        b=lyp8q7hHt6QdR0Jkigtch3VkQJxOeRXGO4YZ4wTT4pe+zUjLhpTCmbOf51KSNJR9bh
         fbFhj5/d2+yDgKaKzqqVYRZqAtOvejbkUCAc08HbUh6d1ztrfVxVFn7ssNizx6b38Rnx
         7gjMPNg7+QpwZ74Vp4Tb7rwZnGMX1r89yfe7JHovmWxcC3eNHcZZTu3UKy29ppW1Fzqs
         139O0aLIdVsGxN6NUaVzpDVEVVB2J13JNA5DiqRRN5H0J/bVoYDS+jGjt6N5QW75HZT2
         YaPkGSfMYunE7+pFFKWs8r80Al4Hxq7K0He+EYMJ9UCRyG70dufUQ+uJ6mQgmXa9lSuy
         wKGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKMhrXGLOkzJv/kkpyoCn4rY5V/IAw1OZSh4QH9+6lRd1yLcSqBV1hN/OKf4bHzf7mGifaIE1iJg==@kvack.org
X-Gm-Message-State: AOJu0YzzkwMMDX61UtOBAd2geXkTal+McjLUpOB8jLS5tbqXih5ZHFjk
	bY2jmwAcspW8hiEHtXCA1HrUPzZcQoOMVncQpTtc7KwWDIhM4SvTP1Ct6tWsNu+JwY6+vyeAqGg
	TqBVJlda7ZIsTPg==
X-Google-Smtp-Source: AGHT+IEmoIr1XRdh2jEsRUDswYZqXhX3eoQiIFPX3VP+DLGDPoq40SIlYagZTuIw1RSOFbCoujpa5asPuE2+JQ==
X-Received: from wmbgz9-n1.prod.google.com ([2002:a05:600c:8889:10b0:471:1414:8fd1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:37c3:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-47939e37b60mr41129515e9.27.1765077169581;
 Sat, 06 Dec 2025 19:12:49 -0800 (PST)
Date: Sun, 07 Dec 2025 03:12:48 +0000
In-Reply-To: <20251205165743.9341-1-kalyazin@amazon.com>
Mime-Version: 1.0
References: <20251205165743.9341-1-kalyazin@amazon.com>
X-Mailer: aerc 0.21.0
Message-ID: <DERNMX91W3P4.AHN53QLCCIH5@google.com>
Subject: Re: [PATCH v8 00/13] Direct Map Removal Support for guest_memfd
From: Brendan Jackman <jackmanb@google.com>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, 
	"jmattson@google.com" <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>, <owner-linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 573901C0010
X-Stat-Signature: 61koyq1kw1d83k3c93chhpyqm6peiqo3
X-Rspam-User: 
X-HE-Tag: 1765077171-232320
X-HE-Meta: U2FsdGVkX1+zIEVi1+Bg2rvVXh6oTVPrwlyegOPuuV2fTp4BfJRKUBKWz2mrggeIb4dGcKxzANGGjb5z9wqQMm/pMqg2i4YwwFKzqS4LkSxYhiqJclUC7E/yBEHJZUeB7frUoF0Mtj7kSe6aovmJ/x8/yB2IdkVeiQQ3h3giSy0p6h4dldw/kofVWVGWucJTeOluGoKBETA+Xh4+997GWAXqqIEUi/e1Qm//+GEfOgPAUPfRDzotpQsNO8FCePMRPyAGuNZtIoQX+qv7sHsiNweEanNVaFLScOKmu4L9yv7CFvaOrnLuF7r8JTbMyRd3NkK2BkTNoSD6ACXzxWdGdvM/zuOHH4MciCAQJNt7jyKPYP1ukIgBV/CC00NeWvISyxVnQ0wzcE1vH+84ORefYUzRcMWSLPenMu66wlDlmOBMGvD+XwYQ4dfZeYHGGBtHYhLowzr1HjJf5YokLDfUPgmDYfimobP/f9EPeHFOdzV2O+OdPnm/2IllynhrdXrIXkPDfqjCzRULmTk1u3hvTyszaCje1dw6cvZoK8U7ygzqVnsisMpomg0oKkpfbUNHACFHv4NV3ADgOFHlOSB5fSrigwyzJW5mPvAcrwUwTC4VqODhEk20FalFWWcdrH8e79QJlRsl55jdMWJT+VRJQiyUjvk6GQ9UOhVmfLoIS6QRLY+I7RB8DpbzQVqVZU2h6VTWdB2h2SaEmJiEgN5SvKIHlBqdHYmBf8ZZM71T1MJsfOFVjyqx+WDLL8t+RjPHX+X8dNP0B0Z2jTtufinjjzCFS3bFrCTEOr7G7zXIH1RGTcHqngNTQ3Vo6UPl901bvBAKVM19O/lJ9BEma5LyUnGMKhUneVbbZCfCJBAbFQX+SUNDphXJlm/IJvktVb5iCmYI4nBMVYpSYEIOFivuntU8Frw5xsT+e18Yfos8vhlzYvyb2+V62uFjBXxIuN2f1r71W8Nk6EG+PVdNt34
 0yZJ8Iwj
 Qypoc+J+Yqbhj6C1SPrNb7XEe5tnz6JTs9oWADB6aTzTQDCYzVrZGepy+c9reP8TS+LocjMbpbWTrAZV9ryejhq+UogSWG0NHj6BGlrn7FWbq4j/yysIBpOR9EEcL78Is1wk6ajGGwsRoe3xZZ2VtGWI+8BMfFbZgfeFCK6ldW5rDKeYjkJzqdj0nCoaPppG6LQVe05MX7bZLDhk33iPm+bD7wypgmS6uWz8hDYq23ojm1vupfTCrC/gLYtlBInF/y8lQ7DsTI38TrA3VjlTlzfmU96pp7bXCfVZNSjPSph+ctkOjOmuvYq7qRxBtVKwHtY+JDR+GuzOq4k2z3Qh7hUsPB5bwDgcrz+JntUR2R2TnnQWKlup9ppsnzoa8F2mGK48uZgoVqsL/Xuh6hg8/IMCscV/n1MJCmF+5PQcbmC4rTrJf0JaUwidPv4fwNP7eCyOn/HgUed7cskkkcQ5L+8KCJLF4MMqRziqBWoQC9smDYW9y+dESdZXOt1nRzcyJgFxeR0zYvfcKMUjXOouh01PJUg4USZW2Hznb8B+SFAv8oNMiwQf3zGjeiDNAOOf91Q4NVQ7F3dxAxU9qCf8xUvqWvSLPJx64YQ+0NUePA66rPlXNuwDwp55ZyYnu1HVW4pNra+CSbULKqVMeuBsnfR5oHDdArNPO2wT/BrkHWkeQxV3MYObBAAk8rXAdNyPaT+TlfbzEHUhcGMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Dec 5, 2025 at 4:57 PM UTC, Nikita Kalyazin wrote:
> Changes since v7:
>  - David: separate patches for adding x86 and ARM support
>  - Dave/Will: drop support for disabling TLB flushes

In case anyone was following along at home - it looks like
kvm_arch_gmem_supports_no_direct_map() has been refactored which also
fixes the can_set_direct_map() issue from [0].

[0] https://lore.kernel.org/kvm/DDWOP8GKHESP.2EOY2HGM9RXHU@google.com/#t

